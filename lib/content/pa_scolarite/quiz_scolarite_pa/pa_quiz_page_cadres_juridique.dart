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
final List<QuizQuestion> questionsCadresJuridiquePages = [
  const QuizQuestion(
    category: "Généralités — Commission rogatoire",
    question: "Dans quel cadre juridique intervient la commission rogatoire ?",
    options: [
      "Dans le cadre de l’enquête de flagrance uniquement",
      "Dans le cadre de l’information judiciaire",
      "Uniquement après le jugement",
    ],
    answer: "Dans le cadre de l’information judiciaire",
    explanation:
        "La commission rogatoire est un mode de délégation de pouvoirs du juge d’instruction (ou d’une juridiction) pendant l’information judiciaire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Commission rogatoire",
    question:
        "Quelle est la finalité principale de la commission rogatoire pour le juge d’instruction ?",
    options: [
      "Déléguer une partie de ses pouvoirs pour faire réaliser des actes d’instruction",
      "Transférer définitivement son dossier à un autre juge",
      "Se dessaisir de l’affaire au profit du procureur",
    ],
    answer:
        "Déléguer une partie de ses pouvoirs pour faire réaliser des actes d’instruction",
    explanation:
        "Lorsque le juge d’instruction ne peut matériellement accomplir tous les actes, il délègue certains actes par commission rogatoire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorités — Délégantes",
    question:
        "Quelle juridiction d’instruction peut délivrer une commission rogatoire ?",
    options: [
      "Uniquement le juge des libertés et de la détention",
      "Uniquement la chambre de l’instruction",
      "Toute juridiction d’instruction, dont le juge d’instruction",
    ],
    answer: "Toute juridiction d’instruction, dont le juge d’instruction",
    explanation:
        "Le texte vise les juridictions d’instruction (juge d’instruction, chambre de l’instruction) et de jugement, toutes pouvant délivrer une commission rogatoire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorités — Délégantes",
    question:
        "Parmi les juridictions suivantes, laquelle peut délivrer une commission rogatoire ?",
    options: [
      "Le tribunal correctionnel",
      "Le conseil municipal",
      "Le préfet de département",
    ],
    answer: "Le tribunal correctionnel",
    explanation:
        "Les juridictions de jugement, comme le tribunal correctionnel, ont également le pouvoir de délivrer des commissions rogatoires.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorités — Délégantes",
    question:
        "Dans la pratique courante, de quel magistrat émanent le plus souvent les commissions rogatoires ?",
    options: [
      "Du procureur de la République",
      "Du juge d’instruction",
      "Du juge des libertés et de la détention",
    ],
    answer: "Du juge d’instruction",
    explanation:
        "Même si d’autres juridictions peuvent en délivrer, les commissions rogatoires émanent le plus souvent du juge d’instruction.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorités — Délégataires",
    question:
        "Selon l’article 151 du Code de procédure pénale, qui peut être requis par commission rogatoire ?",
    options: [
      "Tout juge du tribunal, tout juge d’instruction ou tout officier de police judiciaire",
      "Uniquement un officier de police judiciaire",
      "Uniquement un gendarme adjoint volontaire",
    ],
    answer:
        "Tout juge du tribunal, tout juge d’instruction ou tout officier de police judiciaire",
    explanation:
        "Le juge d’instruction peut requérir ces trois catégories pour exécuter les actes d’information dans leur ressort de compétence.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorités — Délégataires",
    question:
        "Dans la pratique policière, quels agents sont principalement chargés d’exécuter les commissions rogatoires ?",
    options: [
      "Les agents de police judiciaire uniquement",
      "Les officiers de police judiciaire",
      "Les adjoints de sécurité",
    ],
    answer: "Les officiers de police judiciaire",
    explanation:
        "Seuls les O.P.J. peuvent se voir directement déléguer une commission rogatoire. Les APJ et assistants peuvent ensuite les seconder.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Compétence — Matérielle OPJ",
    question: "Les actes exécutés par l’OPJ sur commission rogatoire doivent :",
    options: [
      "Se rattacher à la répression de l’infraction visée aux poursuites",
      "Pouvoir concerner n’importe quelle infraction future",
      "Être limités aux simples constatations sans audition",
    ],
    answer: "Se rattacher à la répression de l’infraction visée aux poursuites",
    explanation:
        "L’article 151 al. 3 impose que les actes d’instruction se rattachent directement à l’infraction visée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Compétence — Matérielle OPJ",
    question:
        "Parmi les actes suivants, lequel l’OPJ ne peut PAS faire sur commission rogatoire ?",
    options: [
      "Procéder à des auditions de témoins",
      "Ordonner une expertise",
      "Effectuer des constatations",
    ],
    answer: "Ordonner une expertise",
    explanation:
        "L’OPJ ne peut ni ordonner d’expertise ni délivrer de mandats : ces pouvoirs restent réservés au magistrat.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Compétence — Matérielle OPJ",
    question:
        "L’OPJ peut-il interroger une personne mise en examen sur commission rogatoire ?",
    options: [
      "Oui, librement",
      "Oui, seulement en présence de l’avocat",
      "Non, les interrogatoires de la personne mise en examen sont réservés au juge d’instruction",
    ],
    answer:
        "Non, les interrogatoires de la personne mise en examen sont réservés au juge d’instruction",
    explanation:
        "L’article 152 al. 2 interdit à l’OPJ de procéder aux interrogatoires et confrontations de la personne mise en examen.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Compétence — Territoriale OPJ",
    question:
        "En principe, dans quelles limites territoriales l’OPJ est-il compétent ?",
    options: [
      "Dans tout le territoire national, sans condition",
      "Dans les limites territoriales où il exerce ses fonctions habituelles",
      "Uniquement dans sa commune de service",
    ],
    answer:
        "Dans les limites territoriales où il exerce ses fonctions habituelles",
    explanation:
        "L’article 18 al. 1 C.P.P. fixe la compétence ordinaire de l’OPJ au ressort de ses fonctions habituelles.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Compétence — Territoriale OPJ",
    question:
        "L’extension de compétence de l’OPJ à l’ensemble du territoire national est possible :",
    options: [
      "Sans condition, dès qu’il est en enquête",
      "Seulement après information du juge d’instruction mandant",
      "Uniquement avec l’autorisation du maire",
    ],
    answer: "Seulement après information du juge d’instruction mandant",
    explanation:
        "L’article 18 al. 3 prévoit l’extension à tout le territoire après information du juge d’instruction, mentionnée par P.V.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Formalisme — Commission rogatoire",
    question:
        "Quel élément doit obligatoirement figurer dans la commission rogatoire selon l’article 151 al. 2 ?",
    options: [
      "Le numéro d’immatriculation du véhicule de l’OPJ",
      "La nature de l’infraction objet des poursuites",
      "La liste nominative de tous les témoins à entendre",
    ],
    answer: "La nature de l’infraction objet des poursuites",
    explanation:
        "La commission rogatoire doit indiquer la nature de l’infraction, être datée, signée et revêtue du sceau du magistrat.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Formalisme — Commission rogatoire",
    question: "Sous quelle forme la commission rogatoire doit-elle exister ?",
    options: [
      "Elle doit être écrite",
      "Elle peut être purement orale",
      "Elle doit être enregistrée en vidéo",
    ],
    answer: "Elle doit être écrite",
    explanation:
        "La commission rogatoire doit être matérialisée par un écrit daté, signé et revêtu du sceau du magistrat.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Typologie — Générale / Spéciale",
    question: "Une commission rogatoire dite « générale » est :",
    options: [
      "Générale quant aux infractions visées",
      "Générale quant aux actes prescrits, mais pas quant aux infractions",
      "Toujours valable pour toutes les affaires du service",
    ],
    answer:
        "Générale quant aux actes prescrits, mais pas quant aux infractions",
    explanation:
        "La commission générale peut laisser une grande latitude sur les actes, mais reste cantonnée aux infractions déterminées.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Typologie — Générale / Spéciale",
    question: "Une commission rogatoire « spéciale » :",
    options: [
      "Délègue une mission et des actes précisément mentionnés",
      "Autorise l’OPJ à agir librement",
      "Ne peut viser qu’un seul témoin",
    ],
    answer: "Délègue une mission et des actes précisément mentionnés",
    explanation:
        "La commission spéciale encadre strictement les actes (ex : entendre tel témoin, saisir tel dossier).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Typologie — Contre personne dénommée / X",
    question:
        "Lorsqu’une commission rogatoire est délivrée contre une personne dénommée, elle doit :",
    options: [
      "Rester anonyme pour respecter le secret",
      "Mentionner le nom de la personne mise en examen et l’infraction reprochée",
      "Éviter de désigner l’infraction pour ne pas l’influencer",
    ],
    answer:
        "Mentionner le nom de la personne mise en examen et l’infraction reprochée",
    explanation:
        "Lorsque des indices suffisants existent, la commission mentionne la personne et la qualification retenue.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Typologie — Contre personne dénommée / X",
    question: "Une commission rogatoire délivrée « contre X » signifie que :",
    options: [
      "L’infraction n’est pas encore connue",
      "Les auteurs ne sont pas encore identifiés",
      "Le juge renonce à poursuivre",
    ],
    answer: "Les auteurs ne sont pas encore identifiés",
    explanation:
        "L’infraction est connue mais les auteurs n’ont pas été déterminés au moment de la délivrance.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "International — Forme",
    question:
        "Une commission rogatoire internationale doit notamment comporter :",
    options: [
      "Un résumé entièrement oral par téléphone",
      "Un exposé précis des faits et les références des textes applicables",
      "Uniquement l’identité de la victime",
    ],
    answer:
        "Un exposé précis des faits et les références des textes applicables",
    explanation:
        "La CR internationale doit identifier l’autorité émettrice, exposer les faits, les qualifications et la mission.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Actes — Constatations",
    question:
        "Sur commission rogatoire, l’OPJ peut effectuer des constatations :",
    options: [
      "Uniquement sur les lieux de l’infraction",
      "Sur tout lieu, objet ou document utile aux investigations",
      "Uniquement au tribunal",
    ],
    answer: "Sur tout lieu, objet ou document utile aux investigations",
    explanation:
        "Les constatations peuvent porter sur les lieux, les objets ou documents utiles à l’enquête dans le cadre de la mission.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Prélèvements — Signalétiques",
    question:
        "Quels types d’opérations l’OPJ peut-il faire réaliser sur commission rogatoire au titre des relevés signalétiques ?",
    options: [
      "Uniquement un examen médical complet",
      "Prises d’empreintes digitales, palmaires ou photographies",
      "Simple vérification d’identité sans prise d’empreintes",
    ],
    answer: "Prises d’empreintes digitales, palmaires ou photographies",
    explanation:
        "Il peut procéder aux relevés nécessaires à l’alimentation des fichiers de police (art. 55-1).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Auditions — Témoins",
    question: "En commission rogatoire, le témoin est en principe tenu :",
    options: [
      "De comparaître, prêter serment et déposer",
      "Uniquement de comparaître",
      "Uniquement de déposer, sans serment",
    ],
    answer: "De comparaître, prêter serment et déposer",
    explanation:
        "L’article 153 soumet le témoin à trois obligations : comparaître, prêter serment, déposer.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Auditions — Témoins",
    question:
        "Quelle formule de serment doit prêter le témoin sur commission rogatoire ?",
    options: [
      "Je jure de dire la vérité devant la police",
      "Je jure de répondre uniquement aux questions du juge",
      "De dire toute la vérité, rien que la vérité",
    ],
    answer: "De dire toute la vérité, rien que la vérité",
    explanation:
        "L’article 103 C.P.P. impose cette formule et les indications d’état civil et de liens avec les parties.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Auditions — Témoins",
    question:
        "Parmi les personnes suivantes, laquelle est dispensée de prêter serment comme témoin ?",
    options: [
      "Un voisin qui a vu la scène",
      "Un mineur de moins de 16 ans",
      "Un agent de police judiciaire",
    ],
    answer: "Un mineur de moins de 16 ans",
    explanation:
        "Les mineurs de moins de 16 ans et certains proches sont dispensés de serment (art. 108 C.P.P.).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Auditions — Témoins",
    question:
        "Une personne gardée à vue entendue comme témoin sur commission rogatoire :",
    options: [
      "Doit obligatoirement prêter serment",
      "N’est pas tenue de déposer et peut refuser de faire des déclarations",
      "Doit obligatoirement reconnaître les faits",
    ],
    answer:
        "N’est pas tenue de déposer et peut refuser de faire des déclarations",
    explanation:
        "La personne en garde à vue n’est pas obligée de déposer ; elle peut garder le silence (art. 153 al. 3).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Sanctions — Témoins",
    question:
        "Le témoin qui refuse de comparaître, de prêter serment ou de déposer sans excuse valable encourt :",
    options: [
      "Une simple admonestation",
      "Une amende de 3 750 euros",
      "Une peine d’emprisonnement automatique",
    ],
    answer: "Une amende de 3 750 euros",
    explanation:
        "L’article 153 renvoie à l’article 434-15-1 du Code pénal : amende de 3 750 €.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Témoin assisté",
    question:
        "L’audition d’un témoin assisté par l’OPJ sur commission rogatoire est possible :",
    options: [
      "Uniquement si le juge l’ordonne d’office",
      "Uniquement si le témoin assisté en fait lui-même la demande",
      "Jamais, c’est interdit",
    ],
    answer: "Uniquement si le témoin assisté en fait lui-même la demande",
    explanation:
        "L’article 152 al. 2 prévoit que l’OPJ ne peut entendre un témoin assisté que sur demande de celui-ci.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Témoin assisté",
    question: "Le témoin assisté entendu par l’OPJ :",
    options: [
      "Prête serment comme un témoin simple",
      "Ne prête pas serment",
      "Est obligatoirement assisté de son avocat",
    ],
    answer: "Ne prête pas serment",
    explanation:
        "L’article 113-7 C.P.P. prévoit que le témoin assisté ne prête pas serment.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Parties — Personne mise en examen",
    question: "Après sa mise en examen, la personne :",
    options: [
      "Peut encore être interrogée librement par l’OPJ",
      "Ne peut plus être interrogée que par le juge d’instruction",
      "Ne peut plus être entendue du tout",
    ],
    answer: "Ne peut plus être interrogée que par le juge d’instruction",
    explanation:
        "L’OPJ ne peut ni l’interroger ni la confronter ; ces actes relèvent du magistrat.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Parties — Partie civile",
    question:
        "La partie civile peut être entendue par l’OPJ sur commission rogatoire :",
    options: [
      "Uniquement si elle en fait la demande",
      "Toujours, même contre son gré",
      "Jamais, seul le juge peut l’entendre",
    ],
    answer: "Uniquement si elle en fait la demande",
    explanation:
        "L’article 152 al. 2 prévoit que l’OPJ ne peut entendre la partie civile que sur sa demande.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Perquisitions — Généralités",
    question:
        "Les perquisitions en matière d’information judiciaire sont notamment régies par :",
    options: [
      "Les articles 92 et suivants du Code de procédure pénale",
      "Les articles 20 et 21 du Code pénal",
      "Uniquement par la Constitution",
    ],
    answer: "Les articles 92 et suivants du Code de procédure pénale",
    explanation:
        "Le texte mentionne les articles 92 et suivants comme base des perquisitions sur information.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Perquisitions — Domicile mis en examen",
    question:
        "En principe, la perquisition au domicile de la personne mise en examen doit se faire :",
    options: [
      "En son absence obligatoire",
      "En présence de la personne mise en examen ou d’un représentant, ou à défaut de deux témoins",
      "Uniquement en présence du procureur",
    ],
    answer:
        "En présence de la personne mise en examen ou d’un représentant, ou à défaut de deux témoins",
    explanation:
        "L’article 95 renvoie aux règles des articles 57 et 59 : présence de la personne, d’un représentant ou de témoins.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Perquisitions — Domicile tiers",
    question:
        "Lors d’une perquisition au domicile d’un tiers, ce dernier est :",
    options: [
      "Toujours exclu de l’opération",
      "Invité à y assister",
      "Obligé de quitter les lieux",
    ],
    answer: "Invité à y assister",
    explanation:
        "L’article 96 précise que le tiers au domicile duquel la perquisition a lieu est invité à y assister.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Saisies / Scellés",
    question:
        "Les objets, documents ou données informatiques saisis doivent être :",
    options: [
      "Laissés sur place dans un carton scotché",
      "Immédiatement inventoriés et placés sous scellés",
      "Transmis oralement au juge",
    ],
    answer: "Immédiatement inventoriés et placés sous scellés",
    explanation:
        "L’article 97 al. 2 impose l’inventaire et la mise sous scellés des saisies.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Conditions",
    question:
        "En commission rogatoire, qui contrôle la garde à vue prévue par l’article 154 du Code de procédure pénale ?",
    options: ["Le maire", "Le juge d’instruction", "Le préfet"],
    answer: "Le juge d’instruction",
    explanation:
        "La garde à vue sur commission rogatoire est contrôlée par le juge d’instruction, qui doit être avisé dès le début.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Généralités",
    question:
        "Sur commission rogatoire, les OPJ et APJ ne peuvent pas adresser de réquisitions techniques ou scientifiques fondées sur les articles 60 et 77-1 parce que :",
    options: [
      "La loi l’interdit formellement sans condition",
      "L’article 156 du Code de procédure pénale prévoit que, pour les questions techniques, le juge ordonne une expertise",
      "Les opérateurs refusent systématiquement de répondre",
    ],
    answer:
        "L’article 156 du Code de procédure pénale prévoit que, pour les questions techniques, le juge ordonne une expertise",
    explanation:
        "En matière technique, c’est l’expertise ordonnée par le juge qui prime, et non les réquisitions de l’OPJ.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Ordre général",
    question:
        "Les réquisitions d’ordre général de l’article 99-3 du Code de procédure pénale permettent notamment à l’OPJ :",
    options: [
      "De requérir toute personne ou organisme détenant des documents utiles à l’instruction",
      "De pratiquer une perquisition de nuit sans autorisation",
      "De placer une personne en détention provisoire",
    ],
    answer:
        "De requérir toute personne ou organisme détenant des documents utiles à l’instruction",
    explanation:
        "L’OPJ peut requérir documents, y compris informatiques, sous réserve des limites posées par l’article 60-1-2.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Géolocalisation",
    question:
        "Les réquisitions de géolocalisation en temps réel (art. 230-32 à 230-44) peuvent viser :",
    options: [
      "Uniquement la personne suspecte elle-même",
      "Une personne, un véhicule ou un objet qu’elle détient",
      "Uniquement les téléphones fixes",
    ],
    answer: "Une personne, un véhicule ou un objet qu’elle détient",
    explanation:
        "Le dispositif permet de suivre les déplacements d’une personne, d’un véhicule ou d’un objet par balise ou terminal.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Interceptions",
    question:
        "Qui est compétent pour ordonner l’interception de correspondances émises par la voie des communications électroniques (art. 100) ?",
    options: [
      "L’officier de police judiciaire",
      "Le juge d’instruction",
      "Le maire de la commune",
    ],
    answer: "Le juge d’instruction",
    explanation:
        "L’article 100 prévoit que le juge d’instruction peut prescrire interception, enregistrement et transcription.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Retenue judiciaire — Violation contrôle judiciaire",
    question:
        "En cas de présomption de violation de certaines obligations du contrôle judiciaire, la personne peut être retenue :",
    options: ["48 heures maximum", "24 heures maximum", "12 heures maximum"],
    answer: "24 heures maximum",
    explanation:
        "L’article 141-4 permet une retenue de 24 heures au plus dans un local de police ou de gendarmerie.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE =====================
  const QuizQuestion(
    category: "Autorités — Délégataires",
    question:
        "Pourquoi la délivrance de commissions rogatoires à plusieurs services de police ou de gendarmerie dans une même affaire peut-elle être envisagée ?",
    options: [
      "Pour faire travailler le plus de services possible",
      "Parce que la loi l’impose toujours",
      "Pour faire procéder à des vérifications distinctes nécessitant des diligences séparées en des lieux différents",
    ],
    answer:
        "Pour faire procéder à des vérifications distinctes nécessitant des diligences séparées en des lieux différents",
    explanation:
        "La circulaire du 1er mars 1993 précise que cela se justifie lorsque les diligences sont nettement séparées dans des lieux différents.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Compétence — Territoriale OPJ",
    question:
        "Dans quel cas l’OPJ n’a-t-il pas à informer le juge d’instruction lorsqu’il se transporte hors de son ressort habituel ?",
    options: [
      "Jamais, il doit toujours informer",
      "Lorsque le transport a lieu dans un ressort limitrophe à celui où il exerce habituellement ses fonctions",
      "Lorsqu’il s’agit d’un crime uniquement",
    ],
    answer:
        "Lorsque le transport a lieu dans un ressort limitrophe à celui où il exerce habituellement ses fonctions",
    explanation:
        "L’article 18 prévoit une dispense d’information pour les ressorts limitrophes (Paris et petite couronne étant un seul département).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "International — Exécution",
    question:
        "Selon la jurisprudence de la Cour de cassation, quel droit s’applique aux conditions de fond et de forme des actes réalisés à l’étranger sur commission rogatoire internationale ?",
    options: [
      "Le droit français exclusivement",
      "La lex fori, c’est-à-dire la loi de l’État où l’acte est accompli",
      "Le droit choisi librement par l’OPJ",
    ],
    answer: "La lex fori, c’est-à-dire la loi de l’État où l’acte est accompli",
    explanation:
        "La Cour de cassation rappelle que le magistrat français n’a pas à apprécier la régularité de l’acte au regard de la loi étrangère, la lex fori s’appliquant dans l’État requis.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Contrôle — Juge d’instruction",
    question:
        "Que permet l’article 152 al. 3 du Code de procédure pénale au juge d’instruction dans le cadre d’une commission rogatoire ?",
    options: [
      "Se transporter sans greffier pour diriger et contrôler l’exécution de la commission rogatoire",
      "Se substituer définitivement à l’OPJ",
      "Déléguer la direction de l’enquête au procureur",
    ],
    answer:
        "Se transporter sans greffier pour diriger et contrôler l’exécution de la commission rogatoire",
    explanation:
        "Le juge peut se rendre sur place pour contrôler l’exécution, sans accomplir lui-même d’actes d’instruction.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Procédure — PV de saisine",
    question:
        "En matière d’instruction, à quoi correspond le procès-verbal de saisine établi par l’OPJ ?",
    options: [
      "À la simple ouverture du dossier de flagrance",
      "À l’enregistrement par l’OPJ des pouvoirs qui lui sont délégués pour l’exécution de la commission rogatoire",
      "À la clôture de l’enquête",
    ],
    answer:
        "À l’enregistrement par l’OPJ des pouvoirs qui lui sont délégués pour l’exécution de la commission rogatoire",
    explanation:
        "Le PV de saisine marque la réception officielle de la commission rogatoire et des pouvoirs qui en découlent.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Procédure — Délais",
    question:
        "En l’absence de délai fixé par le juge d’instruction, dans quel délai l’OPJ doit-il transmettre la commission rogatoire et les procès-verbaux après la fin des opérations ?",
    options: ["Dans les 24 heures", "Dans les 3 jours", "Dans les 8 jours"],
    answer: "Dans les 8 jours",
    explanation:
        "L’article 151 al. 4 prévoit la transmission dans les huit jours de la fin des opérations si aucun délai particulier n’a été fixé.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Prélèvements — Refus",
    question:
        "Le refus par une personne soupçonnée de commettre une infraction de se soumettre aux prélèvements et signalisation ordonnés par l’OPJ constitue :",
    options: [
      "Une simple irrégularité de procédure sans sanction",
      "Un délit puni d’un an d’emprisonnement et de 15 000 € d’amende",
      "Une contravention de 4e classe",
    ],
    answer: "Un délit puni d’un an d’emprisonnement et de 15 000 € d’amende",
    explanation:
        "Le texte précise cette incrimination spécifique pour refus de prélèvements et signalisation.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Auditions — Témoins",
    question:
        "Les personnes astreintes au secret professionnel entendues comme témoins :",
    options: [
      "Peuvent refuser de comparaître",
      "Doivent comparaître et décliner leur identité avant d’invoquer le secret",
      "Sont dispensées d’audition",
    ],
    answer:
        "Doivent comparaître et décliner leur identité avant d’invoquer le secret",
    explanation:
        "Elles comparaissent, déclinent leur identité puis invoquent éventuellement le secret (art. 226-13 et 226-14 C.P.).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Auditions — Journalistes",
    question:
        "Quel droit particulier l’article 109 al. 2 du Code de procédure pénale reconnaît-il au journaliste entendu comme témoin ?",
    options: [
      "Le droit de refuser de prêter serment",
      "Le droit de ne pas révéler l’origine des informations recueillies dans l’exercice de son activité",
      "Le droit de refuser toute convocation",
    ],
    answer:
        "Le droit de ne pas révéler l’origine des informations recueillies dans l’exercice de son activité",
    explanation:
        "Ce droit protège la confidentialité des sources des journalistes professionnels.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Indices graves et concordants",
    question:
        "Lorsqu’apparaissent, au cours de l’audition, des indices graves et concordants à l’encontre d’une personne entendue comme simple témoin, l’OPJ doit :",
    options: [
      "Poursuivre l’audition normalement",
      "Mettre fin immédiatement à l’audition et aviser le juge d’instruction",
      "Placer la personne d’office en détention",
    ],
    answer:
        "Mettre fin immédiatement à l’audition et aviser le juge d’instruction",
    explanation:
        "À peine de nullité, l’OPJ doit cesser l’audition et informer le magistrat, seul compétent pour décider du statut de la personne.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Indices graves et concordants",
    question:
        "Parmi les caractéristiques suivantes, lesquelles doivent être réunies pour parler d’indices « graves et concordants » au sens de l’article 105 du Code de procédure pénale ?",
    options: [
      "Pluralité, gravité et concordance des indices",
      "Un seul aveu suffit toujours",
      "Uniquement des preuves matérielles",
    ],
    answer: "Pluralité, gravité et concordance des indices",
    explanation:
        "Les indices doivent être multiples, graves et non contradictoires, formant un faisceau probant.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Témoin assisté",
    question:
        "Le témoin assisté entendu par l’OPJ peut-il être soumis à une mesure de garde à vue pour la durée de son audition ?",
    options: [
      "Oui, s’il refuse de répondre",
      "Non, aucune mesure de contrainte (garde à vue ou retenue) n’est possible pour cette audition",
      "Oui, mais seulement 4 heures",
    ],
    answer:
        "Non, aucune mesure de contrainte (garde à vue ou retenue) n’est possible pour cette audition",
    explanation:
        "La circulaire précise qu’il ne peut être retenu et peut mettre fin à tout moment à son audition.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Personne sous contrôle judiciaire",
    question:
        "La perquisition au domicile d’une personne placée sous contrôle judiciaire ou assignée à résidence avec surveillance électronique, et interdite de détenir une arme, est possible :",
    options: [
      "Uniquement avec le consentement écrit de la personne",
      "En présence d’indices graves ou concordants de présence d’armes, selon les modalités des articles 56 à 58 et avec accord ou instructions du juge d’instruction",
      "Sans aucune condition particulière",
    ],
    answer:
        "En présence d’indices graves ou concordants de présence d’armes, selon les modalités des articles 56 à 58 et avec accord ou instructions du juge d’instruction",
    explanation:
        "L’article 141-5 encadre cette perquisition en renvoyant aux articles 56 à 58 C.P.P.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Saisies / Données informatiques",
    question:
        "Lorsqu’une copie des données informatiques est réalisée dans le cadre d’une saisie, que peut ordonner le juge d’instruction pour le support d’origine non placé sous main de justice ?",
    options: [
      "La restitution immédiate sans condition",
      "L’effacement définitif des données illégales ou dangereuses",
      "La destruction matérielle systématique du support",
    ],
    answer: "L’effacement définitif des données illégales ou dangereuses",
    explanation:
        "L’article 97 al. 4 permet l’effacement définitif des données illicites ou dangereuses sur le support d’origine.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Saisie pénale — Comptes bancaires",
    question:
        "Dans quel cadre l’OPJ peut-il procéder à la saisie pénale de sommes figurant sur un compte bancaire ou d’actifs numériques ?",
    options: [
      "Uniquement pour les contraventions",
      "Lorsque la peine de confiscation est prévue ou pour des crimes/délits punis de plus d’un an d’emprisonnement, sur autorisation du juge d’instruction",
      "Uniquement sur instruction du maire",
    ],
    answer:
        "Lorsque la peine de confiscation est prévue ou pour des crimes/délits punis de plus d’un an d’emprisonnement, sur autorisation du juge d’instruction",
    explanation:
        "La saisie pénale des comptes nécessite l’autorisation du juge d’instruction dans ce cadre.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Mandat de recherche",
    question: "Le mandat de recherche peut être décerné :",
    options: [
      "Uniquement à l’encontre d’une personne déjà mise en examen",
      "Contre une personne à l’encontre de laquelle il existe une ou plusieurs raisons plausibles de soupçonner la commission d’une infraction",
      "Uniquement contre un témoin assisté",
    ],
    answer:
        "Contre une personne à l’encontre de laquelle il existe une ou plusieurs raisons plausibles de soupçonner la commission d’une infraction",
    explanation:
        "L’article 122 définit le mandat de recherche et exclut certains statuts (mise en examen, témoin assisté, personne visée nominativement par réquisitoire).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Garde à vue — Prolongation",
    question:
        "En commission rogatoire, qui est compétent pour autoriser la prolongation de la garde à vue au-delà de la première période ?",
    options: [
      "Le procureur de la République",
      "Le juge d’instruction mandant",
      "Le maire du lieu d’interpellation",
    ],
    answer: "Le juge d’instruction mandant",
    explanation:
        "La prolongation relève du juge d’instruction, qui doit motiver sa décision et, le cas échéant, peut être assisté d’un JLD pour certains reports.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Garde à vue — Avocat",
    question:
        "En garde à vue exécutée sur commission rogatoire, quel renseignement supplémentaire l’avocat doit-il recevoir ?",
    options: [
      "Le numéro de matricule de tous les enquêteurs",
      "Le fait que la mesure intervient dans le cadre de l’exécution d’une commission rogatoire",
      "La liste de toutes les perquisitions en cours",
    ],
    answer:
        "Le fait que la mesure intervient dans le cadre de l’exécution d’une commission rogatoire",
    explanation:
        "L’article 154 al. 2 prévoit cette information spécifique à fournir à l’avocat.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions — Informatique / Télécom",
    question:
        "Pour requérir les opérateurs de télécommunications de préserver le contenu des informations consultées par les utilisateurs (art. 60-2, al. 2), l’OPJ doit :",
    options: [
      "Agir librement sans contrôle",
      "Obtenir l’autorisation expresse du juge d’instruction",
      "Passer par le préfet de police",
    ],
    answer: "Obtenir l’autorisation expresse du juge d’instruction",
    explanation:
        "Les réquisitions du second alinéa de l’article 60-2 nécessitent l’autorisation du juge d’instruction.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions — Géolocalisation / Urgence",
    question:
        "En cas d’urgence, lorsque l’OPJ met en place une géolocalisation en temps réel, que doit-il faire dans les 24 heures ?",
    options: [
      "Prévenir uniquement le maire",
      "Informer le juge d’instruction, qui doit décider par écrit de la poursuite ou non des opérations",
      "Clôturer la procédure sans compte-rendu",
    ],
    answer:
        "Informer le juge d’instruction, qui doit décider par écrit de la poursuite ou non des opérations",
    explanation:
        "À défaut d’autorisation écrite dans ce délai, il est mis fin à la géolocalisation.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Interceptions — Nature des infractions",
    question:
        "En matière d’interception de correspondances (art. 100), quand le seuil de trois ans d’emprisonnement n’est-il pas exigé ?",
    options: [
      "Lorsque l’enquête concerne une simple contravention",
      "Lorsqu’il s’agit d’un délit commis par communications électroniques sur la ligne de la victime, à sa demande",
      "Lorsque l’OPJ souhaite simplement vérifier une rumeur",
    ],
    answer:
        "Lorsqu’il s’agit d’un délit commis par communications électroniques sur la ligne de la victime, à sa demande",
    explanation:
        "Dans ce cas, l’interception peut intervenir même si la peine maximale est inférieure à trois ans.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Interceptions — Lignes protégées",
    question:
        "En principe, une interception ne peut porter sur une ligne dépendant du cabinet d’un avocat ou de son domicile que :",
    options: [
      "Lorsqu’elle est autorisée par le juge d’instruction sans autre condition",
      "Lorsqu’il existe des raisons plausibles de soupçonner l’avocat d’avoir participé à l’infraction et que la mesure est proportionnée",
      "Jamais, quel que soit le contexte",
    ],
    answer:
        "Lorsqu’il existe des raisons plausibles de soupçonner l’avocat d’avoir participé à l’infraction et que la mesure est proportionnée",
    explanation:
        "Le dernier alinéa de l’article 100 prévoit cette exception encadrée pour les lignes d’avocats.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Interceptions — Informations préalables",
    question:
        "Selon l’article 100-7 du Code de procédure pénale, une interception sur la ligne d’un député ou d’un sénateur ne peut avoir lieu que :",
    options: [
      "Avec l’accord du maire de la commune",
      "Après information du président de l’assemblée à laquelle il appartient",
      "Après consultation des électeurs",
    ],
    answer:
        "Après information du président de l’assemblée à laquelle il appartient",
    explanation:
        "L’information préalable du président de l’assemblée est une condition de validité, à peine de nullité.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Interceptions — Conditions de forme",
    question: "La décision d’interception de correspondances doit notamment :",
    options: [
      "Être orale pour rester secrète",
      "Être écrite, motivée et préciser la durée maximale de quatre mois",
      "Être prise par le préfet",
    ],
    answer: "Être écrite, motivée et préciser la durée maximale de quatre mois",
    explanation:
        "L’article 100-1 fixe ces conditions de forme et de durée (quatre mois renouvelables, dans la limite d’un an).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Interceptions — Destruction des enregistrements",
    question:
        "À l’expiration du délai de prescription de l’action publique, que devient l’enregistrement des interceptions ?",
    options: [
      "Il est conservé à titre historique",
      "Il est détruit à la diligence du procureur ou du procureur général, avec établissement d’un procès-verbal",
      "Il est transmis à la presse",
    ],
    answer:
        "Il est détruit à la diligence du procureur ou du procureur général, avec établissement d’un procès-verbal",
    explanation:
        "L’article 100-6 prévoit la destruction des enregistrements à l’expiration de la prescription.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Retenue judiciaire — Droits de la personne",
    question:
        "Dans le cadre de la retenue judiciaire pour présomption de violation du contrôle judiciaire, la personne bénéficie notamment :",
    options: [
      "Uniquement du droit de se taire",
      "Des droits prévus aux articles 63-2, 63-3, 63-3-1 à 63-4-3 (prévenir un proche, médecin, avocat, interprète, etc.)",
      "D’aucun droit spécifique",
    ],
    answer:
        "Des droits prévus aux articles 63-2, 63-3, 63-3-1 à 63-4-3 (prévenir un proche, médecin, avocat, interprète, etc.)",
    explanation:
        "L’article 141-4 renvoie expressément à ces droits, qui doivent être notifiés à la personne retenue.",
    difficulty: "Intermédiaire",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  const QuizQuestion(
    category: "International — Conventions UE",
    question:
        "Selon la convention du 29 mai 2000 relative à l’entraide judiciaire entre États membres de l’Union européenne, l’État requis :",
    options: [
      "Peut ignorer les formalités demandées par l’État requérant",
      "Respecte les formalités de procédure expressément indiquées par l’État requérant, sauf si elles sont contraires aux principes fondamentaux de son droit",
      "Applique uniquement sa propre procédure sans tenir compte des demandes",
    ],
    answer:
        "Respecte les formalités de procédure expressément indiquées par l’État requérant, sauf si elles sont contraires aux principes fondamentaux de son droit",
    explanation:
        "L’article 4 de la convention pose ce principe de respect des formalités demandées, sous réserve des principes fondamentaux.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Auditions — Témoin assisté / Plainte avec CPC",
    question:
        "Lorsqu’une personne est nommément visée par une plainte avec constitution de partie civile, la Chancellerie considère qu’elle doit :",
    options: [
      "Toujours être entendue comme simple témoin",
      "Toujours bénéficier du droit d’être entendue en qualité de témoin assisté devant le juge d’instruction",
      "Être immédiatement mise en examen",
    ],
    answer:
        "Toujours bénéficier du droit d’être entendue en qualité de témoin assisté devant le juge d’instruction",
    explanation:
        "La circulaire du 18 novembre 2011 impose que ces personnes puissent bénéficier du statut de témoin assisté.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Indices graves et concordants — Nullité",
    question:
        "Quelles sont les conséquences sur la procédure si l’OPJ poursuit l’audition d’une personne comme simple témoin alors que des indices graves et concordants de culpabilité sont apparus ?",
    options: [
      "Aucune conséquence particulière",
      "Seule l’audition est annulée mais les actes subséquents restent valables",
      "L’audition et tous les actes découlant de cette audition peuvent être annulés",
    ],
    answer:
        "L’audition et tous les actes découlant de cette audition peuvent être annulés",
    explanation:
        "Cette atteinte aux droits de la défense entraîne l’annulation en chaîne des actes fondés sur l’audition irrégulière.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Témoin assisté — Indices graves et concordants",
    question:
        "L’article 105 du Code de procédure pénale, relatif à l’interdiction d’entendre comme témoin une personne contre laquelle existent des indices graves et concordants, s’applique-t-il au témoin assisté ?",
    options: [
      "Oui, toujours",
      "Non, il n’est pas applicable au témoin assisté",
      "Oui, mais uniquement en flagrance",
    ],
    answer: "Non, il n’est pas applicable au témoin assisté",
    explanation:
        "L’article 113-6 al. 2 précise que l’article 105 n’est pas applicable au témoin assisté, qui peut donc continuer à être entendu, sous contrôle du magistrat.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Perquisitions — Article 56 et renvoi",
    question:
        "Pourquoi le renvoi à l’article 56 du Code de procédure pénale, pour les perquisitions au domicile d’un tiers sur commission rogatoire, est-il important ?",
    options: [
      "Parce qu’il dispense d’établir un procès-verbal",
      "Parce qu’il impose le respect des formalités de perquisition et permet de retenir sur place les personnes susceptibles de fournir des renseignements",
      "Parce qu’il autorise automatiquement les perquisitions de nuit",
    ],
    answer:
        "Parce qu’il impose le respect des formalités de perquisition et permet de retenir sur place les personnes susceptibles de fournir des renseignements",
    explanation:
        "L’article 56 encadre les perquisitions et permet la rétention des personnes présentes le temps nécessaire.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Saisies / Scellés",
    question:
        "Qui peut ouvrir les scellés fermés et dépouiller les documents saisis dans le cadre de l’instruction (art. 97 al. 6) ?",
    options: [
      "L’OPJ seul, en l’absence de la défense",
      "Uniquement le juge d’instruction, l’OPJ n’ayant qu’un rôle de conservation",
      "Le juge d’instruction ou l’OPJ commis, en présence de la personne mise en examen et de son avocat ou eux dûment appelés",
    ],
    answer:
        "Le juge d’instruction ou l’OPJ commis, en présence de la personne mise en examen et de son avocat ou eux dûment appelés",
    explanation:
        "Les scellés ne peuvent être ouverts qu’en respectant les droits de la défense (présence ou convocation).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Géolocalisation — Lieux privés",
    question:
        "Pour l’introduction dans des lieux d’habitation en dehors des heures légales afin de mettre en place un dispositif de géolocalisation, qui doit délivrer l’autorisation ?",
    options: [
      "Le juge d’instruction",
      "Le juge des libertés et de la détention",
      "Le procureur de la République",
    ],
    answer: "Le juge des libertés et de la détention",
    explanation:
        "Le texte précise que, pour les lieux d’habitation en dehors des heures légales, l’autorisation émane du JLD, saisi par le juge d’instruction.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Géolocalisation — Activation à distance",
    question:
        "L’activation à distance d’un appareil électronique en vue de sa localisation en temps réel ne peut pas concerner :",
    options: [
      "Un téléphone portable volé",
      "Un appareil utilisé par un médecin, un notaire, un avocat, un magistrat ou un journaliste",
      "Un véhicule appartenant à la victime",
    ],
    answer:
        "Un appareil utilisé par un médecin, un notaire, un avocat, un magistrat ou un journaliste",
    explanation:
        "L’article 230-34-1 exclut les appareils de certaines professions protégées, sauf exceptions prévues par la loi.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Interceptions — Correspondances protégées",
    question:
        "Selon l’article 100-5 du Code de procédure pénale, quelles correspondances ne peuvent pas être transcrites, à peine de nullité ?",
    options: [
      "Celles avec un mis en examen",
      "Celles avec un avocat sur l’exercice des droits de la défense ou avec un journaliste permettant d’identifier une source",
      "Toutes les correspondances téléphoniques",
    ],
    answer:
        "Celles avec un avocat sur l’exercice des droits de la défense ou avec un journaliste permettant d’identifier une source",
    explanation:
        "Ces correspondances sont expressément exclues de la transcription pour protéger le secret de la défense et des sources.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Interceptions — Agents requis",
    question:
        "Les agents requis pour installer un dispositif d’interception (art. 100-3) sont astreints :",
    options: [
      "Uniquement au secret professionnel classique",
      "Au respect du secret de l’instruction et du secret des correspondances, et ne peuvent ni révéler l’existence des interceptions ni leur contenu",
      "À aucune obligation particulière",
    ],
    answer:
        "Au respect du secret de l’instruction et du secret des correspondances, et ne peuvent ni révéler l’existence des interceptions ni leur contenu",
    explanation:
        "L’article 100-3 et la circulaire de 1991 rappellent ces obligations strictes.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Retenue judiciaire — Limites des investigations",
    question:
        "Pendant la retenue judiciaire prévue à l’article 141-4, la personne peut-elle faire l’objet d’investigations corporelles internes ?",
    options: [
      "Oui, si le juge d’instruction est d’accord",
      "Oui, pour toute infraction punie d’emprisonnement",
      "Non, aucune investigation corporelle interne ne peut être réalisée pendant la retenue",
    ],
    answer:
        "Non, aucune investigation corporelle interne ne peut être réalisée pendant la retenue",
    explanation:
        "Le texte interdit expressément les investigations corporelles internes durant la retenue par les services de police ou de gendarmerie.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Généralités — Contrôle d'identité",
    question:
        "Quel est l'objectif principal des contrôles, relevés et vérifications d'identité ?",
    options: [
      "Limiter la liberté d'aller et venir des personnes",
      "Établir l'identité dans un équilibre entre libertés individuelles et maintien de l'ordre public",
      "Permettre de sanctionner immédiatement toute infraction",
    ],
    answer:
        "Établir l'identité dans un équilibre entre libertés individuelles et maintien de l'ordre public",
    explanation:
        "Les contrôles d'identité visent à établir l'identité d'une personne tout en respectant les libertés individuelles, sous le contrôle de l'autorité judiciaire, et en permettant la recherche des infractions et la prévention des atteintes à l'ordre public.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Textes applicables",
    question:
        "Quels articles du code de procédure pénale encadrent les contrôles, relevés et vérifications d'identité ?",
    options: [
      "Articles 56 à 65 du CPP",
      "Articles 78-1 à 78-7 du CPP",
      "Articles 121-1 à 121-7 du CPP",
    ],
    answer: "Articles 78-1 à 78-7 du CPP",
    explanation:
        "Les opérations d'établissement de l'identité (contrôle, relevé et vérification) sont encadrées par les articles 78-1 à 78-7 du code de procédure pénale.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — CESEDA",
    question:
        "En complément du CPP, quel code fixe les obligations de présentation de documents pour les étrangers lors d'un contrôle d'identité ?",
    options: [
      "Le Code du travail",
      "Le Code civil",
      "Le Code de l'entrée et du séjour des étrangers et du droit d'asile (CESEDA)",
    ],
    answer:
        "Le Code de l'entrée et du séjour des étrangers et du droit d'asile (CESEDA)",
    explanation:
        "Le CESEDA fixe l’obligation, pour les étrangers, de présenter les pièces ou documents sous le couvert desquels ils sont autorisés à circuler ou séjourner en France.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Champ d'application",
    question:
        "Selon l'article 78-1 du CPP, sur qui peut s'exercer un contrôle d'identité ?",
    options: [
      "Uniquement sur les ressortissants français",
      "Sur toute personne se trouvant sur le territoire national",
      "Uniquement sur les personnes déjà connues des services de police",
    ],
    answer: "Sur toute personne se trouvant sur le territoire national",
    explanation:
        "L’article 78-1 du CPP précise que le contrôle d’identité vise toute personne se trouvant sur le territoire national, Français comme étrangers.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Distinction",
    question:
        "Quelle est la différence principale entre contrôle d'identité et vérification d'identité ?",
    options: [
      "Il n'y a aucune différence, ce sont des synonymes",
      "Le contrôle est la première invitation à justifier de son identité, la vérification est une phase coercitive encadrée par un formalisme spécifique",
      "La vérification se fait uniquement sur la voie publique",
    ],
    answer:
        "Le contrôle est la première invitation à justifier de son identité, la vérification est une phase coercitive encadrée par un formalisme spécifique",
    explanation:
        "Le contrôle d’identité est l’invitation à justifier de son identité sur place. La vérification d’identité intervient ensuite, avec rétention possible, lorsque la personne ne peut ou ne veut pas justifier de son identité.",
    difficulty: "Facile",
  ),

  // ==== PERSONNES HABILITÉES ====
  const QuizQuestion(
    category: "Autorités habilitées — Contrôle d'identité",
    question:
        "Quels personnels sont habilités à procéder à un contrôle d'identité selon l'article 78-2 du CPP ?",
    options: [
      "Uniquement les agents de police municipale",
      "Seuls les OPJ et, sur leur ordre et sous leur responsabilité, les APJ et certains APJA",
      "Tous les fonctionnaires de la fonction publique d'État",
    ],
    answer:
        "Seuls les OPJ et, sur leur ordre et sous leur responsabilité, les APJ et certains APJA",
    explanation:
        "Les contrôles d'identité sont réservés aux OPJ et, sur leur ordre et sous leur responsabilité, aux APJ et à certains APJA mentionnés par l’article 21 du CPP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorités habilitées — Exclusions",
    question:
        "Parmi les personnels suivants, lesquels ne peuvent PAS procéder eux-mêmes à un contrôle d'identité ?",
    options: ["Les OPJ", "Les agents de police municipale", "Les APJ"],
    answer: "Les agents de police municipale",
    explanation:
        "Les agents de police municipale peuvent relever l'identité des contrevenants dans certains cas, mais ils ne sont pas habilités à mettre en œuvre un contrôle d’identité au sens de l’article 78-2 du CPP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorités habilitées — Formule légale",
    question:
        "Que signifie la formule « sur ordre et sous la responsabilité » de l’OPJ concernant l’action des APJ et APJA ?",
    options: [
      "Qu'ils doivent obligatoirement demander une autorisation préalable pour chaque contrôle",
      "Qu'ils agissent dans le cadre de leur mission de secondement de l’OPJ, sous son autorité, sans nécessiter une autorisation préalable à chaque fois",
      "Qu'ils ne peuvent agir qu'en présence physique de l’OPJ",
    ],
    answer:
        "Qu'ils agissent dans le cadre de leur mission de secondement de l’OPJ, sous son autorité, sans nécessiter une autorisation préalable à chaque fois",
    explanation:
        "La formule rappelle simplement que les APJ et APJA agissent pour seconder les OPJ, sous leur autorité. Il n’est pas nécessaire d’obtenir une autorisation préalable pour chaque contrôle, mais la mention doit figurer sur les PV.",
    difficulty: "Intermédiaire",
  ),

  // ==== CONTROLES RELEVANT DE LA POLICE JUDICIAIRE (INITIATIVE POLICIERS) ====
  const QuizQuestion(
    category: "Police judiciaire — Article 78-2",
    question:
        "Dans le cadre de la police judiciaire, sur quelle base un policier peut-il décider de procéder à un contrôle d'identité de sa propre initiative ?",
    options: [
      "Sur la seule intuition personnelle de l'agent",
      "Sur la base de raisons plausibles de soupçonner que la personne est dans l'un des cas prévus par l'article 78-2",
      "Uniquement si la personne refuse un déféré au parquet",
    ],
    answer:
        "Sur la base de raisons plausibles de soupçonner que la personne est dans l'un des cas prévus par l'article 78-2",
    explanation:
        "Le contrôle de police judiciaire à l’initiative des policiers suppose des raisons plausibles de soupçonner la personne d’être dans l’un des cinq cas énumérés par l’article 78-2.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Cinq cas de l'article 78-2",
    question:
        "Parmi les propositions suivantes, laquelle fait partie des cinq cas permettant un contrôle d'identité à l'initiative des policiers (police judiciaire) ?",
    options: [
      "La personne a violé une simple règle de politesse",
      "La personne se prépare à commettre un crime ou un délit",
      "La personne circule la nuit dans une ville touristique",
    ],
    answer: "La personne se prépare à commettre un crime ou un délit",
    explanation:
        "L'article 78-2 prévoit notamment le cas où la personne se prépare à commettre un crime ou un délit comme fondement d’un contrôle d’identité.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Personne auteur",
    question:
        "Dans quel cas un contrôle d'identité peut-il être réalisé lorsque la personne est soupçonnée d'être l'auteur d'une infraction ?",
    options: [
      "Uniquement pour un crime",
      "Uniquement pour un délit",
      "Pour un crime, un délit ou une contravention",
    ],
    answer: "Pour un crime, un délit ou une contravention",
    explanation:
        "Le contrôle d’identité peut être pratiqué lorsqu'il existe des raisons plausibles de soupçonner que la personne a commis ou tenté de commettre un crime, un délit ou une contravention.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Renseignements utiles",
    question:
        "Dans quel cas un contrôle d'identité peut-il viser une personne qui n'est pas suspecte mais peut aider l'enquête ?",
    options: [
      "Uniquement si elle est témoin direct d'un crime",
      "Si elle est susceptible de fournir des renseignements utiles en cas de crime ou de délit",
      "Uniquement si elle se présente spontanément au commissariat",
    ],
    answer:
        "Si elle est susceptible de fournir des renseignements utiles en cas de crime ou de délit",
    explanation:
        "L’article 78-2 alinéa 4 permet de contrôler l’identité des personnes susceptibles de fournir des renseignements utiles en cas de crime ou de délit.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Contrôle judiciaire",
    question:
        "Quel cas prévu à l'article 78-2 permet de contrôler une personne déjà soumise à une mesure judiciaire ?",
    options: [
      "Lorsqu'elle ne répond pas au téléphone",
      "Lorsqu'elle viole les obligations d'un contrôle judiciaire ou d'une mesure d’assignation à résidence avec surveillance électronique",
      "Lorsqu'elle change de domicile",
    ],
    answer:
        "Lorsqu'elle viole les obligations d'un contrôle judiciaire ou d'une mesure d’assignation à résidence avec surveillance électronique",
    explanation:
        "L’article 78-2 alinéa 5 vise les personnes qui ne respectent pas les obligations auxquelles elles sont soumises dans le cadre d’un contrôle judiciaire, d’une ARSE ou d’une mesure suivie par le JAP.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Personne recherchée",
    question:
        "Que prévoit l’article 78-2 pour une personne qui fait l’objet de recherches ordonnées par une autorité judiciaire ?",
    options: [
      "Qu'elle ne peut être contrôlée que sur convocation",
      "Qu'elle peut faire l’objet d’un contrôle d’identité",
      "Qu’elle ne peut être contrôlée qu’en flagrance",
    ],
    answer: "Qu'elle peut faire l’objet d’un contrôle d’identité",
    explanation:
        "L’alinéa 6 de l’article 78-2 permet le contrôle d’identité des personnes faisant l’objet de recherches ordonnées par une autorité judiciaire (mandats, décisions du parquet, du JAP, etc.).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Raisons plausibles",
    question:
        "Qu'est-ce qui caractérise les « raisons plausibles » justifiant un contrôle d'identité en police judiciaire ?",
    options: [
      "Une simple impression subjective du policier",
      "Des éléments concrets liés au comportement et au contexte",
      "Une rumeur dans le quartier",
    ],
    answer: "Des éléments concrets liés au comportement et au contexte",
    explanation:
        "Les raisons plausibles doivent être matérialisées par les agissements de la personne dans un contexte donné (fuite, rôder de nuit, dissimulation d’un sac, etc.), et non par une simple intuition.",
    difficulty: "Intermédiaire",
  ),

  // ==== CONTROLES SUR RÉQUISITIONS DU PROCUREUR ====
  const QuizQuestion(
    category: "Réquisitions du procureur — Forme",
    question:
        "Sous quelle forme le procureur de la République doit-il donner ses réquisitions pour des contrôles d'identité généralisés ?",
    options: [
      "Verbalement, devant les agents",
      "Par un simple appel téléphonique non consigné",
      "Par des réquisitions écrites",
    ],
    answer: "Par des réquisitions écrites",
    explanation:
        "Les contrôles sur réquisitions du procureur doivent être fondés sur des réquisitions écrites précisant notamment les infractions recherchées.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions du procureur — Infractions visées",
    question:
        "Lors de contrôles d'identité sur réquisitions, que doivent obligatoirement préciser les réquisitions du procureur de la République ?",
    options: [
      "La couleur des uniformes portés par les agents",
      "Les infractions à rechercher",
      "Le nombre maximum de personnes contrôlées",
    ],
    answer: "Les infractions à rechercher",
    explanation:
        "Les réquisitions doivent préciser les infractions ciblées afin d’éviter des contrôles déclenchés de façon purement aléatoire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions du procureur — Durée",
    question:
        "En pratique, quelle durée les opérations de contrôles d'identité sur réquisitions ne doivent-elles pas dépasser ?",
    options: ["Une demi-journée", "24 heures", "48 heures"],
    answer: "Une demi-journée",
    explanation:
        "Ces opérations doivent se dérouler dans un temps relativement court, n'excédant pas, en pratique, une demi-journée, pour éviter les contrôles généralisés et permanents.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions du procureur — Lieux et temps",
    question:
        "Que doivent préciser les réquisitions du parquet concernant les contrôles d'identité ?",
    options: [
      "Uniquement le nombre d’agents engagés",
      "Le périmètre exact et la période de temps des opérations",
      "Uniquement la nature de la population visée",
    ],
    answer: "Le périmètre exact et la période de temps des opérations",
    explanation:
        "Les réquisitions délimitent les lieux et la période des contrôles pour garantir un dispositif ciblé, légal et non généralisé.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réquisitions du procureur — Toute personne",
    question:
        "Lors d'un contrôle d'identité sur réquisitions du procureur, qui peut être contrôlé ?",
    options: [
      "Uniquement les personnes déjà connues défavorablement",
      "Uniquement les personnes à l’apparence suspecte",
      "Toute personne se trouvant dans les lieux et créneaux horaires visés",
    ],
    answer:
        "Toute personne se trouvant dans les lieux et créneaux horaires visés",
    explanation:
        "Le contrôle peut viser toute personne se trouvant dans le périmètre et sur la période définis par les réquisitions, même si en pratique tous ne peuvent pas être contrôlés.",
    difficulty: "Facile",
  ),

  // ==== CONTROLES PRÉVENTIFS (POLICE ADMINISTRATIVE) ====
  const QuizQuestion(
    category: "Préventif — Finalité",
    question:
        "Quel est l’objectif principal des contrôles d'identité préventifs prévus à l’alinéa 8 de l’article 78-2 du CPP ?",
    options: [
      "Vérifier la régularité des contrats de travail",
      "Prévenir une atteinte à l'ordre public, notamment à la sécurité des personnes et des biens",
      "Contrôler la fiscalité des commerçants",
    ],
    answer:
        "Prévenir une atteinte à l'ordre public, notamment à la sécurité des personnes et des biens",
    explanation:
        "Les contrôles préventifs sont des contrôles de police administrative destinés à prévenir une atteinte à l’ordre public.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Préventif — Comportement",
    question:
        "Dans le cadre d'un contrôle préventif (alinéa 8 de l'article 78-2 CPP), le comportement de la personne est-il une condition de régularité du contrôle ?",
    options: [
      "Oui, il doit être anormal ou suspect",
      "Non, la loi précise que le contrôle n'est pas lié au comportement de la personne",
      "Oui, seulement la nuit",
    ],
    answer:
        "Non, la loi précise que le contrôle n'est pas lié au comportement de la personne",
    explanation:
        "Le texte indique expressément que le contrôle préventif n’est pas conditionné au comportement individuel de la personne contrôlée.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Préventif — Lieux",
    question:
        "Dans quels types de lieux peuvent être mis en œuvre les contrôles d'identité préventifs ?",
    options: [
      "Uniquement à domicile",
      "Dans des lieux publics ou ouverts au public (gares, salles de spectacle, galeries marchandes…)",
      "Uniquement dans les commissariats de police",
    ],
    answer:
        "Dans des lieux publics ou ouverts au public (gares, salles de spectacle, galeries marchandes…)",
    explanation:
        "La circulaire et le texte précisent que les contrôles préventifs ne peuvent avoir lieu que dans les lieux publics ou ouverts au public.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Préventif — Motivation",
    question:
        "Que rappelle le Conseil constitutionnel concernant les contrôles généralisés et discrétionnaires ?",
    options: [
      "Qu’ils sont parfaitement admis pour lutter contre la délinquance",
      "Qu’ils sont compatibles avec la liberté individuelle",
      "Qu’ils sont incompatibles avec le respect de la liberté individuelle",
    ],
    answer:
        "Qu’ils sont incompatibles avec le respect de la liberté individuelle",
    explanation:
        "Dans sa décision n° 93-323 du 5 août 1993, le Conseil constitutionnel indique que les contrôles généralisés et discrétionnaires sont incompatibles avec la liberté individuelle.",
    difficulty: "Difficile",
  ),

  // ==== CONTROLES EN ZONE FRONTIÈRE ====
  const QuizQuestion(
    category: "Zone frontière — Finalité",
    question:
        "À quoi sont principalement destinés les contrôles d'identité en zone frontière prévus par l’article 78-2 alinéas 9 à 17 ?",
    options: [
      "À rétablir les contrôles permanents aux frontières intérieures",
      "À prévenir et rechercher les infractions liées à la criminalité transfrontalière",
      "Uniquement à vérifier le paiement des péages autoroutiers",
    ],
    answer:
        "À prévenir et rechercher les infractions liées à la criminalité transfrontalière",
    explanation:
        "Après la suppression des contrôles aux frontières intérieures, ces dispositions visent surtout la criminalité transfrontalière et le respect de certaines obligations documentaires.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Zone frontière — Bande des 20 km",
    question:
        "Dans quelle zone peut-on effectuer des contrôles d'identité fondés sur l’article 78-2 en lien avec la frontière terrestre Schengen ?",
    options: [
      "Dans toute la France",
      "Dans une zone située à moins de 20 km de la frontière terrestre avec les États parties à Schengen",
      "Uniquement dans les aéroports internationaux",
    ],
    answer:
        "Dans une zone située à moins de 20 km de la frontière terrestre avec les États parties à Schengen",
    explanation:
        "L’article 78-2 prévoit des contrôles dans une zone de 20 km en deçà de la frontière terrestre Schengen, sous conditions de fréquence et de finalité (criminalité transfrontalière).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Zone frontière — Durée contrôles ports/aéroports",
    question:
        "Quelle est la durée maximale d'une opération de contrôles d'identité autour des ports et aéroports constituant des points de passage frontaliers ?",
    options: [
      "6 heures dans un même lieu",
      "12 heures dans un même lieu",
      "24 heures dans un même lieu",
    ],
    answer: "12 heures dans un même lieu",
    explanation:
        "La loi prévoit que la durée maximale de ces contrôles ne peut être supérieure à 12 heures dans un même lieu, sans caractère systématique.",
    difficulty: "Intermédiaire",
  ),

  // ==== CONTROLES DANS LES LOCAUX PROFESSIONNELS ====
  const QuizQuestion(
    category: "Locaux professionnels — Réquisitions",
    question:
        "Quelle condition est nécessaire pour que les policiers puissent pénétrer dans des locaux professionnels afin de vérifier l'absence de travail dissimulé ?",
    options: [
      "L’accord oral du chef d’entreprise",
      "Des réquisitions écrites du procureur de la République",
      "L’autorisation du maire",
    ],
    answer: "Des réquisitions écrites du procureur de la République",
    explanation:
        "L’article 78-2-1 du CPP impose des réquisitions écrites du procureur de la République pour pénétrer dans les locaux professionnels en vue de rechercher du travail dissimulé.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Locaux professionnels — Lieux visés",
    question:
        "Quels lieux peuvent être visés par les réquisitions pour contrôle dans les locaux professionnels ?",
    options: [
      "Uniquement les domiciles des salariés",
      "Les lieux à usage exclusivement professionnel et leurs annexes",
      "Tous les lieux, y compris les domiciles familiaux",
    ],
    answer: "Les lieux à usage exclusivement professionnel et leurs annexes",
    explanation:
        "Les réquisitions ne peuvent viser que des locaux à usage exclusivement professionnel, leurs annexes et dépendances, à l’exclusion notamment des domiciles.",
    difficulty: "Intermédiaire",
  ),

  // ==== VISITES DE VÉHICULES / BAGAGES / NAVIRES (RÉQUISITIONS) ====
  const QuizQuestion(
    category: "Visites véhicules — Réquisitions",
    question:
        "Selon l’article 78-2-2 CPP, pour quelles infractions les visites de véhicules sur réquisitions du procureur peuvent-elles être ordonnées ?",
    options: [
      "Uniquement pour les infractions routières",
      "Pour certaines infractions graves comme le terrorisme, les armes, les explosifs, les vols, le recel, le trafic de stupéfiants",
      "Pour tout type d'infraction sans restriction",
    ],
    answer:
        "Pour certaines infractions graves comme le terrorisme, les armes, les explosifs, les vols, le recel, le trafic de stupéfiants",
    explanation:
        "L’article 78-2-2 liste des catégories d’infractions graves (terrorisme, armes, explosifs, vols, recel, stupéfiants, etc.) justifiant visites de véhicules, navires et fouilles de bagages sur réquisitions.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Visites véhicules — Présence",
    question:
        "Lors d'une visite de véhicule à l'arrêt ou en stationnement sur réquisitions du procureur, en présence de qui la visite doit-elle avoir lieu ?",
    options: [
      "Toujours en l’absence de toute personne",
      "En présence du conducteur ou du propriétaire, ou à défaut d’une personne ne relevant pas de l’autorité administrative des agents",
      "Uniquement en présence d’un avocat",
    ],
    answer:
        "En présence du conducteur ou du propriétaire, ou à défaut d’une personne ne relevant pas de l’autorité administrative des agents",
    explanation:
        "Pour les véhicules à l’arrêt, la visite doit se faire en présence du conducteur ou du propriétaire. À défaut, l’OPJ ou l’APJ requiert une personne extérieure à son autorité, sauf risque grave pour la sécurité.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Visites véhicules — Durée réquisitions",
    question:
        "Quelle est la durée maximale d'une opération de visites de véhicules sur réquisitions du procureur selon l'article 78-2-2 ?",
    options: [
      "12 heures, non renouvelables",
      "24 heures, renouvelables sur décision expresse et motivée",
      "48 heures, sans renouvellement possible",
    ],
    answer: "24 heures, renouvelables sur décision expresse et motivée",
    explanation:
        "Le procureur fixe la durée, qui ne peut excéder 24 heures, avec possibilité de renouvellement par décision expresse et motivée.",
    difficulty: "Difficile",
  ),

  // ==== DISTINCTION CONTROLE D'IDENTITÉ / CONTROLE DE RÉGLEMENTATION ====
  const QuizQuestion(
    category: "Contrôle d'identité vs réglementation",
    question:
        "Qu'est-ce qui caractérise un contrôle de réglementation par rapport au contrôle d'identité de l’article 78-2 CPP ?",
    options: [
      "Il vise des obligations spécifiques liées à une activité ou un statut (chasseurs, automobilistes, commerçants ambulants, etc.)",
      "Il est toujours effectué en garde à vue",
      "Il ne peut jamais avoir lieu sur la voie publique",
    ],
    answer:
        "Il vise des obligations spécifiques liées à une activité ou un statut (chasseurs, automobilistes, commerçants ambulants, etc.)",
    explanation:
        "Le contrôle de réglementation porte sur la présentation de titres ou documents obligatoires liés à une activité ou un statut spécifique, distinctement du cadre du contrôle d’identité général.",
    difficulty: "Intermédiaire",
  ),

  // ==== CONTRÔLE DES ÉTRANGERS / CESEDA ====
  const QuizQuestion(
    category: "Étrangers — CESEDA",
    question:
        "Selon l’article L. 812-2 du CESEDA, à quel moment un étranger doit-il être en mesure de présenter les documents l’autorisant à séjourner ou circuler en France ?",
    options: [
      "À tout moment, même sans contrôle préalable",
      "Uniquement lors d’un contrôle routier pour excès de vitesse",
      "À la suite d’un contrôle d’identité effectué dans les conditions du CPP",
    ],
    answer:
        "À la suite d’un contrôle d’identité effectué dans les conditions du CPP",
    explanation:
        "L’article L. 812-2 prévoit que ce contrôle des documents intervient à la suite d’un contrôle d’identité mené dans le cadre des articles 78-1 à 78-2-2 CPP.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Étrangers — Critères objectifs",
    question:
        "Le contrôle de la situation administrative d’un étranger peut-il être fondé sur la couleur de peau ou le nom de famille ?",
    options: [
      "Oui, ces éléments suffisent",
      "Non, il doit reposer sur des éléments objectifs extérieurs à la personne (ex : véhicule immatriculé à l’étranger, banderoles, tracts…) ",
      "Oui, si la personne parle une langue étrangère",
    ],
    answer:
        "Non, il doit reposer sur des éléments objectifs extérieurs à la personne (ex : véhicule immatriculé à l’étranger, banderoles, tracts…) ",
    explanation:
        "Les critères doivent être objectifs et extérieurs à la personne, afin d’exclure toute discrimination fondée sur la couleur de peau, le nom, la langue, etc.",
    difficulty: "Difficile",
  ),

  // ==== MOYENS DE PREUVE DE L’IDENTITÉ ====
  const QuizQuestion(
    category: "Preuve identité — Tout moyen",
    question:
        "Que prévoit l’article 78-2 CPP concernant les moyens de justifier de son identité lors d’un contrôle ?",
    options: [
      "La personne ne peut justifier que par sa carte nationale d'identité",
      "La personne peut justifier de son identité par tout moyen",
      "La personne doit être conduite au poste systématiquement",
    ],
    answer: "La personne peut justifier de son identité par tout moyen",
    explanation:
        "Le texte est volontairement large et dispose que toute personne peut justifier de son identité par tout moyen.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Preuve identité — Documents probants",
    question:
        "Parmi les documents suivants, lequel est considéré comme probant et officiel pour établir l'identité ?",
    options: [
      "Une carte de fidélité de magasin",
      "Un permis de conduire",
      "Un ticket de caisse",
    ],
    answer: "Un permis de conduire",
    explanation:
        "Les documents officiels avec photographie (CNI, passeport, permis de conduire) sont probants pour l’identité, sous réserve de leur authenticité.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Preuve identité — Documents non probants",
    question:
        "Un livret de famille présenté lors d’un contrôle d’identité constitue :",
    options: [
      "Une preuve irréfutable de l'identité",
      "Un commencement de preuve pouvant être pris en compte selon les circonstances",
      "Un document sans aucune valeur",
    ],
    answer:
        "Un commencement de preuve pouvant être pris en compte selon les circonstances",
    explanation:
        "Les documents sans photo ou sans procédure d’identification stricte ne sont qu’un commencement de preuve, à apprécier par les fonctionnaires.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Preuve identité — Témoignages",
    question:
        "Dans quelles conditions les témoignages peuvent-ils être utilisés pour confirmer l'identité lors d’un contrôle ?",
    options: [
      "Ils peuvent être recueillis plusieurs jours après le contrôle",
      "Ils doivent être concomitants et recueillis dans l'immédiate action de contrôle",
      "Ils doivent obligatoirement être recueillis par un magistrat",
    ],
    answer:
        "Ils doivent être concomitants et recueillis dans l'immédiate action de contrôle",
    explanation:
        "Les témoignages doivent être simultanés au contrôle pour être utilisables dans la confirmation de l’identité.",
    difficulty: "Intermédiaire",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE =====================
  // ==== RELEVÉ D’IDENTITÉ ====
  const QuizQuestion(
    category: "Relevé d'identité — Personnels habilités",
    question:
        "Quels agents peuvent procéder à un relevé d’identité pour dresser procès-verbal de certaines contraventions selon l'article 78-6 CPP ?",
    options: [
      "Uniquement les OPJ",
      "Les volontaires de la réserve, les policiers adjoints, certains agents de la Ville de Paris et les agents de police municipale",
      "Uniquement les gendarmes d’active",
    ],
    answer:
        "Les volontaires de la réserve, les policiers adjoints, certains agents de la Ville de Paris et les agents de police municipale",
    explanation:
        "L’article 78-6 énumère ces catégories (volontaires gendarmerie, réservistes, policiers adjoints, ASP, APM, etc.) comme pouvant relever l’identité des contrevenants.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Relevé d'identité — Nature",
    question:
        "De quelle nature est l'opération de relevé d'identité prévue à l'article 78-6 du CPP ?",
    options: [
      "Une opération de police administrative",
      "Une opération de nature judiciaire, nécessitant qu'une infraction ait été préalablement commise",
      "Une simple démarche administrative sans lien avec une infraction",
    ],
    answer:
        "Une opération de nature judiciaire, nécessitant qu'une infraction ait été préalablement commise",
    explanation:
        "Le relevé d’identité est une opération judiciaire : une contravention doit avoir été commise pour pouvoir y recourir.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Relevé d'identité — Refus du contrevenant",
    question:
        "En cas de refus du contrevenant de justifier de son identité lors d’un relevé, que doit faire l’APJA ?",
    options: [
      "Laisser partir le contrevenant",
      "Le conduire immédiatement en garde à vue",
      "Rendre compte à l’OPJ territorialement compétent pour instructions",
    ],
    answer:
        "Rendre compte à l’OPJ territorialement compétent pour instructions",
    explanation:
        "En cas de refus, l’APJA doit aviser l’OPJ, qui peut ordonner une présentation immédiate pour vérification d’identité ou rétention en attendant.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Relevé d'identité — Coercition",
    question:
        "L’agent de police judiciaire adjoint peut-il user de la coercition pour maintenir sur place un contrevenant le temps d’aviser l’OPJ ?",
    options: [
      "Non, il ne dispose d'aucun pouvoir coercitif",
      "Oui, il peut le faire et le refus d'obtempérer est pénalement sanctionné",
      "Oui, mais uniquement s'il s'agit d'un crime",
    ],
    answer:
        "Oui, il peut le faire et le refus d'obtempérer est pénalement sanctionné",
    explanation:
        "L’APJA peut maintenir le contrevenant sur place en attendant la décision de l’OPJ. Le refus est puni de 2 mois d’emprisonnement et 7 500 € d’amende.",
    difficulty: "Difficile",
  ),

  // ==== VÉRIFICATION D’IDENTITÉ & RÉTENTION ====
  const QuizQuestion(
    category: "Vérification d'identité — Définition",
    question:
        "Comment peut-on définir la vérification d'identité au sens de l'article 78-3 CPP ?",
    options: [
      "Une simple confirmation orale de l'identité",
      "La recherche coercitive de l'identité d'une personne qui n'a pas voulu ou pu justifier de son identité à la suite d'un contrôle ou d'un relevé",
      "Une audition libre au commissariat",
    ],
    answer:
        "La recherche coercitive de l'identité d'une personne qui n'a pas voulu ou pu justifier de son identité à la suite d'un contrôle ou d'un relevé",
    explanation:
        "La vérification d’identité permet, de manière coercitive, de rechercher l’identité d’une personne après échec du contrôle ou du relevé.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vérification d'identité — Rétention",
    question:
        "Quelle est la durée maximale de la rétention d’une personne pour vérification d'identité sur le territoire métropolitain (hors régimes particuliers) ?",
    options: ["2 heures", "4 heures", "8 heures"],
    answer: "4 heures",
    explanation:
        "La mesure de rétention ne peut excéder 4 heures à compter du début du contrôle, sauf régime spécifique (Mayotte, Guyane : 8 heures).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vérification d'identité — Début du délai",
    question:
        "À partir de quand commence à courir le délai maximal de 4 heures de rétention pour vérification d’identité ?",
    options: [
      "À l’arrivée de la personne au commissariat",
      "Au moment où l'O.P.J. signe le procès-verbal",
      "Au moment où le policier constate que la personne ne peut ou ne veut pas justifier de son identité",
    ],
    answer:
        "Au moment où le policier constate que la personne ne peut ou ne veut pas justifier de son identité",
    explanation:
        "La rétention débute dès le constat de l’impossibilité ou du refus de justifier de son identité, même sur la voie publique.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Vérification d'identité — Sort de la personne",
    question:
        "À l'issue de la durée maximale de rétention pour vérification d'identité, que doit-il se passer si l'identité n'est toujours pas établie et qu'il n’y a pas de placement en garde à vue ?",
    options: [
      "La personne doit être relâchée",
      "La rétention peut être prolongée sans limite",
      "La personne doit être présentée immédiatement devant un juge d’instruction",
    ],
    answer: "La personne doit être relâchée",
    explanation:
        "Au terme des 4 heures, la personne doit être remise en liberté, sauf placement en garde à vue si les conditions en sont réunies.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification d'identité — Garde à vue",
    question:
        "Si une garde à vue fait suite à une vérification d'identité, comment se calcule la durée totale de privation de liberté ?",
    options: [
      "La durée de la rétention s'ajoute à celle de la garde à vue",
      "La durée de la rétention s'impute sur celle de la garde à vue",
      "La garde à vue recommence un nouveau délai sans tenir compte de la rétention",
    ],
    answer: "La durée de la rétention s'impute sur celle de la garde à vue",
    explanation:
        "L’article 78-4 CPP prévoit que la durée de la rétention s’impute sur la durée de la garde à vue.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification d'identité — Prise d’empreintes",
    question:
        "Dans quelles conditions l’O.P.J. peut-il recourir à la prise d’empreintes ou de photographies pour établir l’identité ?",
    options: [
      "Dès le début du contrôle d'identité, sans condition",
      "Uniquement si c’est le moyen le plus simple, même si la personne présente un document fiable",
      "Si la personne maintient son refus ou donne des éléments manifestement inexacts et si ces opérations sont l’unique moyen d’établir l’identité, après autorisation d’un magistrat",
    ],
    answer:
        "Si la personne maintient son refus ou donne des éléments manifestement inexacts et si ces opérations sont l’unique moyen d’établir l’identité, après autorisation d’un magistrat",
    explanation:
        "L’article 78-3 impose un double critère (refus/identité inexacte + unique moyen) et une autorisation préalable du procureur ou du juge d’instruction.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Vérification d'identité — Droit d'aviser",
    question:
        "Lors d'une vérification d'identité, de quel droit la personne doit-elle être informée immédiatement ?",
    options: [
      "Du droit au silence",
      "Du droit de faire aviser le procureur de la République et de prévenir sa famille ou une personne de son choix",
      "Du droit automatique à un avocat commis d’office",
    ],
    answer:
        "Du droit de faire aviser le procureur de la République et de prévenir sa famille ou une personne de son choix",
    explanation:
        "L’article 78-3 prévoit l’information de la personne sur son droit d’aviser le procureur et de prévenir un proche.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification d'identité — Délit de refus",
    question:
        "Quel risque pénal encourt la personne qui refuse de se prêter aux prises d’empreintes ou photographies dûment autorisées par le magistrat ?",
    options: [
      "Aucun risque, c’est un droit absolu",
      "Une simple amende contraventionnelle",
      "Un délit passible de 3 mois d’emprisonnement et 3 750 € d’amende",
    ],
    answer: "Un délit passible de 3 mois d’emprisonnement et 3 750 € d’amende",
    explanation:
        "L’article 78-5 CPP sanctionne le refus de se soumettre aux mesures d’identité judiciaire autorisées.",
    difficulty: "Difficile",
  ),

  // ==== PROCÈS-VERBAL DE VÉRIFICATION ====
  const QuizQuestion(
    category: "PV de vérification — Mentions obligatoires",
    question:
        "Parmi les éléments suivants, lequel doit obligatoirement figurer dans le procès-verbal de vérification d’identité ?",
    options: [
      "Le numéro de badge du préfet",
      "Les motifs justifiant le contrôle et la vérification, ainsi que les heures de début et de fin de la rétention",
      "La profession des parents de la personne contrôlée",
    ],
    answer:
        "Les motifs justifiant le contrôle et la vérification, ainsi que les heures de début et de fin de la rétention",
    explanation:
        "Le PV doit permettre un contrôle sérieux de la légalité (motifs, déroulement, heures, recours à l’identité judiciaire, etc.).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "PV de vérification — Signature",
    question:
        "Que doit faire l’O.P.J. si la personne refuse de signer le procès-verbal de vérification d’identité ?",
    options: [
      "Annuler la procédure",
      "Le mentionner expressément ainsi que les motifs de ce refus",
      "Obliger la personne à signer par la force",
    ],
    answer: "Le mentionner expressément ainsi que les motifs de ce refus",
    explanation:
        "Le refus de signature et ses motifs sont portés sur le PV, qui reste valable dès lors que les mentions légales sont respectées.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "PV de vérification — Conservation données",
    question:
        "Si la vérification d’identité n’est suivie d’aucune enquête ou mesure d’exécution, que devient le procès-verbal et les éléments d’identification ?",
    options: [
      "Ils sont conservés indéfiniment dans un fichier central",
      "Ils doivent être détruits dans un délai de six mois",
      "Ils sont conservés dix ans",
    ],
    answer: "Ils doivent être détruits dans un délai de six mois",
    explanation:
        "L’article 78-3 prévoit l’interdiction de mise en mémoire et la destruction dans les six mois, afin d’éviter un fichage détourné.",
    difficulty: "Difficile",
  ),

  // ===================== NOUVELLE SÉRIE GÉANTE — NIVEAU FACILE =====================

  // ==== Contenu général ====
  const QuizQuestion(
    category: "Généralités — Objectifs",
    question: "Les opérations de contrôle d'identité visent principalement à :",
    options: [
      "Limiter les déplacements de la population",
      "Établir l’identité des personnes et prévenir les atteintes à l’ordre public",
      "Identifier les personnes pour des campagnes fiscales",
    ],
    answer:
        "Établir l’identité des personnes et prévenir les atteintes à l’ordre public",
    explanation:
        "Les articles 78-1 à 78-7 CPP encadrent ces opérations visant à concilier libertés et sécurité.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Article 78-1 CPP",
    question:
        "Selon l’article 78-1 CPP, qui peut être soumis à un contrôle d’identité ?",
    options: [
      "Uniquement les Français âgés de plus de 18 ans",
      "Toute personne présente sur le territoire national",
      "Uniquement les touristes étrangers",
    ],
    answer: "Toute personne présente sur le territoire national",
    explanation:
        "Le CPP ne distingue ni nationalité ni âge : toute personne peut être contrôlée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Début d'un contrôle",
    question: "Quand commence légalement un contrôle d’identité ?",
    options: [
      "Lorsque l’agent décide verbalement de contrôler la personne",
      "Lorsque la personne est invitée à justifier de son identité",
      "Uniquement lorsque la personne est amenée au commissariat",
    ],
    answer: "Lorsque la personne est invitée à justifier de son identité",
    explanation:
        "Le contrôle débute dès l’invitation à confirmer son identité, même sans contact physique.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Documents acceptés",
    question: "Quel document permet de prouver son identité ?",
    options: [
      "Un permis de conduire",
      "Un ticket de métro",
      "Un badge d’entreprise",
    ],
    answer: "Un permis de conduire",
    explanation:
        "Tout document officiel avec photo est un moyen probant de justifier son identité.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Absence de papiers",
    question:
        "Si une personne n’a aucun document sur elle lors d’un contrôle d’identité :",
    options: [
      "Elle est automatiquement placée en garde à vue",
      "Elle peut justifier son identité par tout moyen, y compris témoignages",
      "Le contrôle doit être annulé immédiatement",
    ],
    answer:
        "Elle peut justifier son identité par tout moyen, y compris témoignages",
    explanation:
        "Le CPP permet la preuve de l’identité par tous moyens raisonnables et immédiats.",
    difficulty: "Facile",
  ),

  // ==== Agents habilités ====
  const QuizQuestion(
    category: "Autorités habilitées — Distinction",
    question: "Quels agents NE PEUVENT PAS procéder à un contrôle d’identité ?",
    options: ["Les agents de police municipale", "Les OPJ", "Les APJ"],
    answer: "Les agents de police municipale",
    explanation:
        "Les APM peuvent relever une identité, pas effectuer un contrôle d’identité au sens 78-2.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorités habilitées — APJ",
    question:
        "Un APJ peut-il procéder à un contrôle d’identité sans ordre préalable de l’OPJ ?",
    options: [
      "Oui, mais toujours sous la responsabilité d’un OPJ",
      "Oui, totalement indépendamment",
      "Non, jamais",
    ],
    answer: "Oui, mais toujours sous la responsabilité d’un OPJ",
    explanation:
        "La mention « sur ordre et sous responsabilité » rappelle la hiérarchie, pas un ordre préalable obligatoire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorités habilitées — Nullité",
    question:
        "Quelle mention doit obligatoirement figurer dans un PV de contrôle sous peine de nullité ?",
    options: [
      "La température extérieure",
      "La formule : « sur ordre et sous la responsabilité de l’OPJ »",
      "Le numéro de matricule de la mairie",
    ],
    answer: "La formule : « sur ordre et sous la responsabilité de l’OPJ »",
    explanation:
        "L’absence de cette mention peut entraîner la nullité du contrôle.",
    difficulty: "Facile",
  ),

  // ==== Contrôles Police Judiciaire — Raisons plausibles ====
  const QuizQuestion(
    category: "Police judiciaire — Cas 1",
    question:
        "Un contrôle d’identité pour police judiciaire peut avoir lieu si la personne :",
    options: [
      "A commis ou tenté de commettre une infraction",
      "A refusé de répondre à une question banale",
      "Marche rapidement dans la rue",
    ],
    answer: "A commis ou tenté de commettre une infraction",
    explanation:
        "C’est l’un des cinq cas de 78-2 permettant le contrôle d’identité.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Cas 2",
    question:
        "Quel exemple correspond à une raison plausible de soupçonner un acte préparatoire ?",
    options: [
      "Une personne qui prend une photo d’un bâtiment",
      "Un individu escaladant un mur la nuit",
      "Un joggeur traversant un parc",
    ],
    answer: "Un individu escaladant un mur la nuit",
    explanation: "Cela peut constituer un acte préparatoire à un cambriolage.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Renseignement",
    question:
        "Une personne peut être contrôlée si elle est susceptible de fournir :",
    options: [
      "Des renseignements utiles à un crime ou un délit",
      "Un avis politique",
      "Un commentaire sur la météo",
    ],
    answer: "Des renseignements utiles à un crime ou un délit",
    explanation: "78-2 alinéa 4 : la personne peut ne pas être suspecte.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Personne recherchée",
    question: "Une personne peut être contrôlée si elle fait l’objet :",
    options: [
      "D’une convocation au collège",
      "De recherches ordonnées par une autorité judiciaire",
      "D'un rappel à l’ordre municipal",
    ],
    answer: "De recherches ordonnées par une autorité judiciaire",
    explanation: "Un mandat judiciaire est un fondement légal de contrôle.",
    difficulty: "Facile",
  ),

  // ==== Contrôle sur réquisitions du procureur ====
  const QuizQuestion(
    category: "Réquisitions — Écrit",
    question:
        "Les réquisitions du procureur pour un contrôle d’identité doivent être :",
    options: [
      "Orales et improvisées",
      "Écrites et motivées",
      "Publiées au Journal Officiel",
    ],
    answer: "Écrites et motivées",
    explanation:
        "78-2 : les réquisitions doivent être obligatoirement écrites.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Périmètre",
    question: "Que doit obligatoirement indiquer la réquisition du procureur ?",
    options: [
      "Le nom du chef de patrouille",
      "Les lieux et la période des contrôles",
      "La couleur des véhicules engagés",
    ],
    answer: "Les lieux et la période des contrôles",
    explanation:
        "Les réquisitions doivent être limitées dans le temps et l’espace.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Réquisitions — Population visée",
    question:
        "Lors d’un contrôle sur réquisitions, quelles personnes peuvent être contrôlées ?",
    options: [
      "Uniquement les personnes suspectes",
      "Toute personne se trouvant dans le périmètre défini",
      "Uniquement les automobilistes",
    ],
    answer: "Toute personne se trouvant dans le périmètre défini",
    explanation:
        "Les réquisitions visent toute personne, non une catégorie ciblée.",
    difficulty: "Facile",
  ),

  // ==== Contrôles préventifs (Police administrative) ====
  const QuizQuestion(
    category: "Préventif — Objectif",
    question:
        "Les contrôles préventifs prévus par l’alinéa 8 de 78-2 servent à :",
    options: [
      "Prévenir une atteinte à l’ordre public",
      "Punir immédiatement la délinquance",
      "Sanctionner les infractions routières",
    ],
    answer: "Prévenir une atteinte à l’ordre public",
    explanation:
        "Contrôle de police administrative sans lien avec une infraction.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Préventif — Comportement",
    question: "Dans un contrôle préventif, le comportement de la personne :",
    options: [
      "Est déterminant",
      "N’est pas une condition de régularité",
      "Doit être agressif pour justifier le contrôle",
    ],
    answer: "N’est pas une condition de régularité",
    explanation: "Le contrôle vise « toute personne » sur les lieux concernés.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Préventif — Lieux",
    question: "Les contrôles préventifs peuvent être réalisés dans :",
    options: [
      "Les domiciles privés",
      "Les lieux publics et ouverts au public",
      "Uniquement dans les commissariats",
    ],
    answer: "Les lieux publics et ouverts au public",
    explanation:
        "Un contrôle dans un domicile serait assimilé à une perquisition.",
    difficulty: "Facile",
  ),

  // ==== Contrôles zone frontière ====
  const QuizQuestion(
    category: "Frontière — Bande des 20km",
    question: "Les contrôles dans la bande des 20 km visent principalement :",
    options: [
      "À remplacer les anciens contrôles aux frontières intérieures",
      "À lutter contre la criminalité transfrontalière",
      "À contrôler le permis de pêche",
    ],
    answer: "À lutter contre la criminalité transfrontalière",
    explanation: "Finalité précisée dans la loi du 14 mars 2011.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Frontière — Durée",
    question:
        "La durée maximale d’un contrôle autour d’un port ou aéroport ne peut dépasser :",
    options: ["4 heures", "8 heures", "12 heures"],
    answer: "12 heures",
    explanation:
        "78-2 al. 10 : durée maximale 12h, sans caractère systématique.",
    difficulty: "Facile",
  ),

  // ==== Moyens de preuve de l’identité ====
  const QuizQuestion(
    category: "Preuve — Photographie",
    question: "Un document probant d’identité doit de préférence comporter :",
    options: [
      "Une photographie",
      "Une adresse e-mail",
      "Une empreinte digitale",
    ],
    answer: "Une photographie",
    explanation: "La photo permet d’associer le porteur au document.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Preuve — Témoins",
    question:
        "Les témoignages permettant de confirmer l'identité doivent être :",
    options: [
      "Donnés plusieurs jours plus tard",
      "Concomitants et immédiats",
      "Envoyés par courrier recommandé",
    ],
    answer: "Concomitants et immédiats",
    explanation: "Les témoignages doivent être obtenus pendant le contrôle.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE =====================

  // ==== Relevé d’identité ====
  const QuizQuestion(
    category: "Relevé d'identité — Nature juridique",
    question: "Le relevé d’identité prévu par 78-6 CPP est :",
    options: [
      "Une opération de police administrative",
      "Une opération de police judiciaire",
      "Une formalité civile",
    ],
    answer: "Une opération de police judiciaire",
    explanation: "Il suppose qu’une infraction ait été commise préalablement.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Relevé d'identité — Refus",
    question:
        "En cas de refus de justifier de son identité lors d’un relevé, l’agent peut :",
    options: [
      "Laisser partir immédiatement la personne",
      "Utiliser la coercition pour la maintenir sur place en attendant l’OPJ",
      "Appeler systématiquement le maire",
    ],
    answer:
        "Utiliser la coercition pour la maintenir sur place en attendant l’OPJ",
    explanation: "Le refus est même sanctionné par 2 mois d’emprisonnement.",
    difficulty: "Intermédiaire",
  ),

  // ==== Vérification d’identité & rétention ====
  const QuizQuestion(
    category: "Vérification — Compétence",
    question: "Qui est compétent pour ordonner une vérification d’identité ?",
    options: ["L’APJ", "L’OPJ exclusivement", "Le préfet"],
    answer: "L’OPJ exclusivement",
    explanation: "L’APJ peut constater le refus, mais seul l’OPJ décide.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification — Début du délai",
    question:
        "Quand commence le délai légal de la rétention pour vérification d’identité ?",
    options: [
      "À l’arrivée au commissariat",
      "Au moment du constat du refus/impossibilité de justifier",
      "À la première audition",
    ],
    answer: "Au moment du constat du refus/impossibilité de justifier",
    explanation:
        "Le CPP prévoit que la rétention débute dès le constat sur place.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification — Droit d’aviser",
    question:
        "La personne retenue peut demander d’aviser une personne de son choix :",
    options: ["Uniquement si elle est mineure", "À tout moment", "Jamais"],
    answer: "À tout moment",
    explanation: "78-3 CPP : droit d’aviser famille ou personne choisie.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification — OPJ",
    question: "Pendant la rétention, le procureur de la République peut :",
    options: [
      "Mettre fin à la rétention à tout moment",
      "Allonger le délai à 10 heures",
      "Remplacer l’OPJ par un APJA",
    ],
    answer: "Mettre fin à la rétention à tout moment",
    explanation: "Il exerce un contrôle permanent de la mesure.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification — Garde à vue",
    question:
        "Si une garde à vue est décidée après une vérification d’identité :",
    options: [
      "La rétention ne compte pas",
      "La rétention s’impute sur la garde à vue",
      "Une nouvelle durée de 24h recommence intégralement",
    ],
    answer: "La rétention s’impute sur la garde à vue",
    explanation:
        "La durée totale de privation de liberté est calculée globalement.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification — OPJ",
    question:
        "Que doit contenir la motivation de la demande d’empreintes/photographies ?",
    options: [
      "Une appréciation générale de la personnalité",
      "La preuve que ces opérations sont l’unique moyen d’établir l’identité",
      "L’accord préalable du maire",
    ],
    answer:
        "La preuve que ces opérations sont l’unique moyen d’établir l’identité",
    explanation: "Condition essentielle pour recourir à l’identité judiciaire.",
    difficulty: "Intermédiaire",
  ),

  // ===================== NIVEAU DIFFICILE =====================

  // ==== Jurisprudence, cas pratiques ====
  const QuizQuestion(
    category: "Jurisprudence — Fouille",
    question:
        "Selon la jurisprudence (Cass. crim 23 mars 2016), une palpation de sécurité lors d’un contrôle d’identité :",
    options: [
      "Autorise automatiquement la fouille du sac",
      "N’autorise pas la fouille du sac sans assentiment ou indice d’infraction",
      "Oblige à placer la personne en garde à vue",
    ],
    answer:
        "N’autorise pas la fouille du sac sans assentiment ou indice d’infraction",
    explanation:
        "La fouille nécessite consentement ou élément objectif d’infraction flagrante.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Étranger",
    question:
        "Un étranger peut être contrôlé sur sa situation administrative si :",
    options: [
      "Son apparence laisse penser qu’il n’est pas français",
      "Des éléments objectifs extérieurs indiquent une possible extranéité",
      "Il parle une autre langue",
    ],
    answer:
        "Des éléments objectifs extérieurs indiquent une possible extranéité",
    explanation:
        "Les critères doivent être neutres et objectifs (immatriculation étrangère, tracts...).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Document douteux",
    question: "Si un document d’identité présenté paraît falsifié :",
    options: [
      "L’agent doit immédiatement arrêter la personne",
      "Le contrôle peut se transformer en enquête judiciaire si suspicion raisonnable",
      "Le document doit être accepté",
    ],
    answer:
        "Le contrôle peut se transformer en enquête judiciaire si suspicion raisonnable",
    explanation:
        "La découverte d’un faux document peut fonder une procédure incidente.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Refus de décliner l'identité",
    question: "Une personne refuse de donner son identité lors du contrôle :",
    options: [
      "Elle doit être relâchée immédiatement",
      "Cela justifie une rétention pour vérification d’identité",
      "Elle doit être placée en garde à vue sans condition",
    ],
    answer: "Cela justifie une rétention pour vérification d’identité",
    explanation:
        "Le refus est explicitement prévu comme motif de rétention (78-3).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Témoins",
    question:
        "Une personne affirme que deux passants peuvent attester de son identité, mais ceux-ci sont déjà partis :",
    options: [
      "Les policiers doivent la laisser les rechercher",
      "La vérification d'identité peut être engagée",
      "La personne doit être relâchée",
    ],
    answer: "La vérification d'identité peut être engagée",
    explanation: "Les témoignages doivent être concomitants et immédiats.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Jeune mineur",
    question:
        "Lors d’une vérification d’identité d’un mineur supposé, l’agent doit :",
    options: [
      "Obligatoirement contacter ses parents avant tout",
      "Apprécier l’âge apparent et informer immédiatement le procureur",
      "Arrêter l’opération car un mineur ne peut être vérifié",
    ],
    answer: "Apprécier l’âge apparent et informer immédiatement le procureur",
    explanation: "78-3 : avis obligatoire au procureur pour les mineurs.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Contrôle professionnel",
    question: "Une visite dans des locaux professionnels peut être effectuée :",
    options: [
      "Sans réquisition du procureur si l’employeur est présent",
      "Uniquement avec des réquisitions écrites du procureur",
      "Uniquement avec l’accord oral du gérant",
    ],
    answer: "Uniquement avec des réquisitions écrites du procureur",
    explanation:
        "78-2-1 impose des réquisitions écrites pour entrer dans les locaux professionnels.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Refus empreintes",
    question:
        "Une personne retenue refuse de donner ses empreintes malgré l’autorisation du procureur :",
    options: [
      "Elle peut être relâchée",
      "Elle commet un délit passible de 3 mois d’emprisonnement",
      "On doit abandonner la procédure",
    ],
    answer: "Elle commet un délit passible de 3 mois d’emprisonnement",
    explanation: "78-5 CPP sanctionne ce refus.",
    difficulty: "Difficile",
  ),

  // ===================== NOUVELLE FOURNÉE DE QUESTIONS SUPPLÉMENTAIRES =====================

  // ==== Cadre général & principes ====
  const QuizQuestion(
    category: "Généralités — Libertés individuelles",
    question:
        "Qui est gardienne des libertés individuelles dans le cadre des contrôles d’identité ?",
    options: [
      "L’autorité administrative",
      "L’autorité judiciaire",
      "Le maire de la commune",
    ],
    answer: "L’autorité judiciaire",
    explanation:
        "Les contrôles d’identité s’inscrivent dans un équilibre entre sécurité et libertés, dont l’autorité judiciaire est la gardienne.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Nature des opérations",
    question:
        "Les contrôles, relevés et vérifications d’identité sont principalement :",
    options: [
      "Des opérations tendant à établir l’identité d’une personne",
      "Des moyens de sanction immédiate",
      "Des formes de punition collective",
    ],
    answer: "Des opérations tendant à établir l’identité d’une personne",
    explanation:
        "Ce sont des opérations centrées sur l’établissement de l’identité, non sur la sanction.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Distinction phases",
    question:
        "Quelle affirmation est exacte concernant les différentes phases d’identification ?",
    options: [
      "Contrôle, relevé et vérification d’identité sont strictement identiques",
      "Le contrôle est la première phase, la vérification est coercitive, le relevé est une opération spécifique pour les contraventions",
      "Seule la vérification d’identité existe en droit",
    ],
    answer:
        "Le contrôle est la première phase, la vérification est coercitive, le relevé est une opération spécifique pour les contraventions",
    explanation: "Chaque phase a un cadre juridique et des acteurs différents.",
    difficulty: "Intermédiaire",
  ),

  // ==== Contrôle d’identité — Fondements supplémentaires ====
  const QuizQuestion(
    category: "Police judiciaire — Cas 3 (contrôle judiciaire)",
    question:
        "Quel exemple illustre une personne pouvant être contrôlée car elle viole les obligations d’un contrôle judiciaire ?",
    options: [
      "Une personne qui traverse hors passage piéton",
      "Une personne assignée à résidence avec bracelet qui n’est pas à son domicile aux heures imposées",
      "Un conducteur qui roule à 49 km/h au lieu de 50",
    ],
    answer:
        "Une personne assignée à résidence avec bracelet qui n’est pas à son domicile aux heures imposées",
    explanation:
        "Elle viole une obligation imposée par l’autorité judiciaire (78-2 al. 5).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Cas 4 (renseignements)",
    question:
        "Un contrôle peut viser une personne simplement témoin de faits si :",
    options: [
      "Elle possède un casier judiciaire vierge",
      "Elle est susceptible de fournir des renseignements utiles en cas de crime ou délit",
      "Elle refuse de répondre à un sondage",
    ],
    answer:
        "Elle est susceptible de fournir des renseignements utiles en cas de crime ou délit",
    explanation:
        "Le texte vise les personnes pouvant aider à la manifestation de la vérité, même sans être suspectes.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Police judiciaire — Initiatives OPJ",
    question:
        "Qui peut prendre l’initiative d’un contrôle d’identité dans un cadre purement judiciaire, sans réquisition du parquet ?",
    options: ["Le préfet", "L’OPJ et, sous son contrôle, l’APJ", "Le maire"],
    answer: "L’OPJ et, sous son contrôle, l’APJ",
    explanation:
        "78-2 al. 1 : l’initiative appartient aux policiers, sous réserve de raisons plausibles.",
    difficulty: "Facile",
  ),

  // ==== Contrôles préventifs — Conditions plus fines ====
  const QuizQuestion(
    category: "Préventif — Menace à l’ordre public",
    question: "Pour mettre en place un contrôle préventif, il faut :",
    options: [
      "Des éléments objectifs faisant présumer une menace à l’ordre public",
      "Une simple impression d’insécurité",
      "Une décision du maire",
    ],
    answer:
        "Des éléments objectifs faisant présumer une menace à l’ordre public",
    explanation:
        "Les contrôles préventifs doivent reposer sur des circonstances précises : risques d’atteinte aux personnes ou aux biens.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Préventif — Justification a posteriori",
    question:
        "En cas de contestation, que devront démontrer les policiers à propos du contrôle préventif ?",
    options: [
      "Qu’ils ont contrôlé tout le monde",
      "Qu’ils ont bien identifié un lieu et un contexte présentant un risque particulier pour la sécurité",
      "Qu’ils ont fouillé chaque personne présentée",
    ],
    answer:
        "Qu’ils ont bien identifié un lieu et un contexte présentant un risque particulier pour la sécurité",
    explanation:
        "La menace à l’ordre public doit être caractérisée et justifiable devant le juge.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Préventif — Lieu privé",
    question:
        "Un contrôle préventif au domicile d’une personne peut-il être effectué ?",
    options: [
      "Oui, à tout moment si la personne accepte verbalement",
      "Oui, mais uniquement la nuit",
      "Non, il serait requalifié en perquisition et doit respecter un autre cadre juridique",
    ],
    answer:
        "Non, il serait requalifié en perquisition et doit respecter un autre cadre juridique",
    explanation:
        "Les contrôles préventifs se limitent aux lieux publics ou ouverts au public.",
    difficulty: "Difficile",
  ),

  // ==== Contrôles en zone frontière — Variantes ====
  const QuizQuestion(
    category: "Frontière — Section autoroutière",
    question:
        "Un contrôle en zone frontière sur autoroute peut se poursuivre au-delà des 20 km si :",
    options: [
      "L’OPJ le décide",
      "Le premier péage autoroutier est au-delà de cette limite",
      "La météo est défavorable",
    ],
    answer: "Le premier péage autoroutier est au-delà de cette limite",
    explanation:
        "La loi permet le contrôle jusqu’au premier péage même au-delà de la bande des 20 km.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Frontière — Points de passage frontaliers",
    question:
        "Dans un rayon de 10 km autour d’un aéroport désigné comme point de passage frontalier, on peut :",
    options: [
      "Procéder à des contrôles d’identité permanents et systématiques",
      "Procéder à des contrôles d’identité non permanents et non systématiques",
      "Uniquement contrôler les cartes d’embarquement",
    ],
    answer:
        "Procéder à des contrôles d’identité non permanents et non systématiques",
    explanation:
        "La loi impose le caractère non permanent et non systématique pour respecter les libertés.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Frontière — Territoires ultras-marins",
    question:
        "Quelle particularité concerne la Guyane en matière de contrôles d’identité en zone frontière ?",
    options: [
      "Aucune zone spécifique",
      "Une zone entre la frontière ou le littoral et une ligne à 20 km en deçà, plus une bande de 5 km de part et d’autre de certains axes",
      "Uniquement dans les aéroports",
    ],
    answer:
        "Une zone entre la frontière ou le littoral et une ligne à 20 km en deçà, plus une bande de 5 km de part et d’autre de certains axes",
    explanation:
        "Le texte prévoit une configuration spéciale pour la Guyane en raison de la pression migratoire.",
    difficulty: "Difficile",
  ),

  // ==== Contrôle de réglementation vs contrôle d’identité ====
  const QuizQuestion(
    category: "Réglementation — Différence",
    question:
        "Un contrôle du permis de conduire d’un automobiliste en circulation est :",
    options: [
      "Un contrôle d’identité au sens de 78-2",
      "Un contrôle de réglementation routière",
      "Une vérification d’identité",
    ],
    answer: "Un contrôle de réglementation routière",
    explanation:
        "Le contrôle de documents liés à une activité (conduite, chasse…) est un contrôle de réglementation, pas un contrôle d’identité.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Réglementation — Caractère autonome",
    question:
        "Un contrôle de réglementation (ex : permis de chasse) peut-il être effectué sans contrôle d’identité préalable ?",
    options: [
      "Non, il suppose toujours un contrôle d’identité",
      "Oui, car il repose sur l’apparence objective de l’activité exercée",
      "Uniquement si la personne est connue défavorablement",
    ],
    answer:
        "Oui, car il repose sur l’apparence objective de l’activité exercée",
    explanation:
        "La situation est visible : chasseur armé, conducteur, forain, etc.",
    difficulty: "Intermédiaire",
  ),

  // ==== Étrangers & CESEDA — Approfondissement ====
  const QuizQuestion(
    category: "Étrangers — Durée contrôle situation",
    question:
        "Le contrôle de situation administrative prévu à l’article L. 812-2 CESEDA ne peut excéder :",
    options: ["2 heures", "4 heures", "6 heures dans un même lieu"],
    answer: "6 heures dans un même lieu",
    explanation:
        "La durée est plafonnée à 6 heures, sans contrôle systématique.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Étrangers — Contrôle systématique",
    question:
        "Le contrôle de situation administrative des étrangers peut-il être systématique dans une zone donnée ?",
    options: [
      "Oui, s’il est limité dans le temps",
      "Non, la loi exclut explicitement un contrôle systématique",
      "Oui, si le maire en fait la demande",
    ],
    answer: "Non, la loi exclut explicitement un contrôle systématique",
    explanation:
        "Les textes précisent qu’il ne peut s’agir d’un contrôle systématique.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Étrangers — Critères objectifs",
    question:
        "Parmi les éléments suivants, lequel peut constituer un critère objectif d’extranéité ?",
    options: [
      "La couleur de peau",
      "La plaque d’immatriculation étrangère du véhicule",
      "Le prénom à consonance étrangère",
    ],
    answer: "La plaque d’immatriculation étrangère du véhicule",
    explanation:
        "Les critères doivent être objectifs et extérieurs à la personne (véhicule, banderoles…).",
    difficulty: "Difficile",
  ),

  // ==== Moyens de preuve de l’identité — Approfondissement ====
  const QuizQuestion(
    category: "Preuve — Document privé",
    question:
        "Une carte de membre d’un club sportif avec photo peut-elle être prise en compte ?",
    options: [
      "Non, jamais",
      "Oui, comme élément de preuve à apprécier par les policiers",
      "Oui, avec la même valeur qu’une CNI",
    ],
    answer: "Oui, comme élément de preuve à apprécier par les policiers",
    explanation:
        "Tout document même privé peut constituer un commencement de preuve s’il semble crédible.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Preuve — Absence totale de document",
    question:
        "Si la personne ne présente aucun document et aucun témoin n’est disponible :",
    options: [
      "Elle doit être relâchée",
      "Une vérification d’identité avec rétention peut être engagée",
      "Les policiers doivent l’ignorer",
    ],
    answer: "Une vérification d’identité avec rétention peut être engagée",
    explanation:
        "Refus ou impossibilité matérialisée justifient la rétention pour vérification.",
    difficulty: "Intermédiaire",
  ),

  // ==== Relevé d’identité — Approfondissement ====
  const QuizQuestion(
    category: "Relevé d'identité — Contraventions visées",
    question: "Le relevé d’identité par les APJA selon 78-6 peut viser :",
    options: [
      "Les crimes uniquement",
      "Les contraventions à certains arrêtés municipaux et au code de la route",
      "Uniquement les délits",
    ],
    answer:
        "Les contraventions à certains arrêtés municipaux et au code de la route",
    explanation:
        "Le texte vise principalement les contraventions à la police de la circulation et à des arrêtés.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Relevé d'identité — Recueil simple",
    question:
        "Quelle différence entre recueil d’identité et relevé d’identité ?",
    options: [
      "Aucune, ce sont des synonymes",
      "Le recueil repose sur la bonne foi sans exiger de document, le relevé permet d’exiger une pièce d’identité",
      "Le recueil se fait uniquement en garde à vue",
    ],
    answer:
        "Le recueil repose sur la bonne foi sans exiger de document, le relevé permet d’exiger une pièce d’identité",
    explanation: "Le relevé ajoute un pouvoir d’exiger un justificatif.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Relevé d'identité — Durée maintien sur place",
    question:
        "La rétention sur la voie publique par un APJA dans l’attente des instructions de l’OPJ doit durer :",
    options: [
      "Le temps strictement nécessaire pour joindre l’OPJ",
      "Au minimum quatre heures",
      "Jusqu’à la fin de la journée de service",
    ],
    answer: "Le temps strictement nécessaire pour joindre l’OPJ",
    explanation: "Le maintien sur place doit être proportionné et limité.",
    difficulty: "Intermédiaire",
  ),

  // ==== Vérification d’identité — Détails procéduraux ====
  const QuizQuestion(
    category: "Vérification — Lieu d’exécution",
    question: "La rétention pour vérification d’identité peut avoir lieu :",
    options: [
      "Uniquement dans un local de police",
      "Sur place ou dans un local de police",
      "Uniquement dans un véhicule de patrouille",
    ],
    answer: "Sur place ou dans un local de police",
    explanation:
        "78-3 : l’intéressé peut être retenu sur place ou conduit dans un local.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vérification — Information des droits",
    question:
        "À quel moment la personne doit-elle être informée de son droit de faire aviser le procureur de la République ?",
    options: [
      "Uniquement en fin de rétention",
      "Dès sa présentation à l’OPJ",
      "Après la rédaction du PV",
    ],
    answer: "Dès sa présentation à l’OPJ",
    explanation: "L’information doit être immédiate et mentionnée au PV.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification — PV",
    question:
        "Si la vérification d’identité n’est suivie d’aucune enquête, une copie du procès-verbal :",
    options: [
      "N’est jamais remise à l’intéressé",
      "Doit être remise à l’intéressé",
      "Est envoyée au maire",
    ],
    answer: "Doit être remise à l’intéressé",
    explanation:
        "L’original part au parquet, l’intéressé reçoit une copie si aucune procédure ne suit.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification — Heures à mentionner",
    question: "Le procès-verbal de vérification d’identité doit mentionner :",
    options: [
      "Uniquement l’heure de fin de rétention",
      "Les heures de début du contrôle ou relevé d’identité, et de début/fin de rétention",
      "Uniquement la date du jour",
    ],
    answer:
        "Les heures de début du contrôle ou relevé d’identité, et de début/fin de rétention",
    explanation:
        "Ces mentions permettent de contrôler la durée maximale légale.",
    difficulty: "Difficile",
  ),

  // ==== Visites de véhicules / bagages (identité et sécurité) ====
  const QuizQuestion(
    category: "Véhicules — Présence OPJ",
    question:
        "Lors d’une visite de véhicule sur réquisitions du procureur (78-2-2), la visite doit être faite :",
    options: [
      "Par n’importe quel agent, sans OPJ",
      "Par un OPJ, éventuellement assisté d’APJ/APJA",
      "Uniquement par la police municipale",
    ],
    answer: "Par un OPJ, éventuellement assisté d’APJ/APJA",
    explanation: "La visite impose la présence effective d’un OPJ.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Bagages — Inspection visuelle",
    question:
        "Lors d’une inspection visuelle des bagages sur réquisitions, le propriétaire :",
    options: [
      "Ne doit jamais être présent",
      "Doit être présent et ne peut être retenu que le temps nécessaire à la fouille",
      "Peut être retenu automatiquement 4 heures",
    ],
    answer:
        "Doit être présent et ne peut être retenu que le temps nécessaire à la fouille",
    explanation:
        "La loi impose la présence du propriétaire et un temps limité.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Véhicules — Prévention atteinte grave",
    question:
        "Pour prévenir une atteinte grave à la sécurité (78-2-4), la visite de véhicule peut être réalisée :",
    options: [
      "Avec l’accord du conducteur ou à défaut sur instruction du procureur",
      "Uniquement avec l’accord écrit du maire",
      "Sans base légale particulière",
    ],
    answer:
        "Avec l’accord du conducteur ou à défaut sur instruction du procureur",
    explanation:
        "Le texte prévoit l’accord ou, à défaut, une instruction du parquet.",
    difficulty: "Difficile",
  ),

  // ==== Manifestations & armes (78-2-5) ====
  const QuizQuestion(
    category: "Manifestation — Contrôles possibles",
    question:
        "Sur les lieux d’une manifestation sur la voie publique, que permet l’article 78-2-5 ?",
    options: [
      "Contrôle d’identité systématique de tous les manifestants",
      "Inspection visuelle/fouille des bagages et visite des véhicules pour rechercher les armes",
      "Perquisition des domiciles des organisateurs",
    ],
    answer:
        "Inspection visuelle/fouille des bagages et visite des véhicules pour rechercher les armes",
    explanation:
        "Les contrôles d’identité sont exclus dans ce dispositif spécifique.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Manifestation — Limites",
    question: "Dans le cadre de l’article 78-2-5, les contrôles d’identité :",
    options: [
      "Sont autorisés",
      "Sont expressément exclus",
      "Sont obligatoires pour chaque personne fouillée",
    ],
    answer: "Sont expressément exclus",
    explanation: "Le texte vise seulement les armes, via bagages et véhicules.",
    difficulty: "Difficile",
  ),

  // ==== Nullités & contrôles du procureur ====
  const QuizQuestion(
    category: "Nullité — Mentions manquantes",
    question:
        "L’absence de mention de la durée de rétention dans le PV de vérification d’identité peut entraîner :",
    options: [
      "Aucune conséquence",
      "La nullité de la procédure",
      "La simple annulation du PV sans effet sur le reste",
    ],
    answer: "La nullité de la procédure",
    explanation: "Les formalités de 78-3 sont imposées à peine de nullité.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Contrôle parquet — Pendant la rétention",
    question:
        "Pendant la vérification d’identité, le procureur de la République peut :",
    options: [
      "Se rendre sur place, ordonner un examen médical ou mettre fin à la rétention",
      "Modifier rétroactivement l’heure de début de rétention",
      "Supprimer l’obligation de PV",
    ],
    answer:
        "Se rendre sur place, ordonner un examen médical ou mettre fin à la rétention",
    explanation: "Le parquet exerce un contrôle concret sur la mesure.",
    difficulty: "Intermédiaire",
  ),
  const QuizQuestion(
    category: "Généralités — Champ d’application",
    question:
        "Quel est l’objectif principal du dispositif procédural spécifique à la criminalité et délinquance organisées ?",
    options: [
      "Alléger les contrôles sur l’action de la police judiciaire",
      "Adapter la procédure pour lutter contre des organisations structurées et utiliser des moyens d’enquête intrusifs",
      "Permettre aux suspects d’être jugés plus rapidement",
    ],
    answer:
        "Adapter la procédure pour lutter contre des organisations structurées et utiliser des moyens d’enquête intrusifs",
    explanation:
        "Le titre XXV du CPP crée un cadre dérogatoire permettant des techniques spéciales (écoutes, infiltration, sonorisation...) pour lutter contre la criminalité organisée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Criminalité organisée — Généralités",
    question:
        "Quel est l’objectif principal du régime procédural spécial de la criminalité organisée ?",
    options: [
      "Permettre plus facilement les classements sans suite",
      "Autoriser des techniques d’enquête plus intrusives",
      "Limiter les pouvoirs du parquet",
    ],
    answer: "Autoriser des techniques d’enquête plus intrusives",
    explanation:
        "Le titre XXV CPP permet un recours élargi à des moyens d’enquête très intrusifs pour lutter contre les organisations criminelles.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Criminalité organisée — Généralités",
    question:
        "Sous quel titre du code de procédure pénale se trouve la procédure applicable à la criminalité et délinquance organisées ?",
    options: ["Titre XV", "Titre XXV", "Titre II"],
    answer: "Titre XXV",
    explanation:
        "Le titre XXV du CPP est intitulé « De la procédure pénale applicable à la criminalité et à la délinquance organisées et aux crimes ».",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Criminalité organisée — Champ",
    question:
        "Les infractions relevant de la criminalité organisée sont principalement définies dans :",
    options: [
      "Les articles 40 à 60 CPP",
      "Les articles 706-73, 706-73-1 et 706-74 CPP",
      "Les articles 121-1 à 121-7 CP",
    ],
    answer: "Les articles 706-73, 706-73-1 et 706-74 CPP",
    explanation:
        "Ces articles listent les infractions entrant dans le champ de la criminalité et délinquance organisées.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "706-73 — Infractions visées",
    question:
        "Parmi les infractions suivantes, laquelle relève de l’article 706-73 CPP ?",
    options: [
      "Contravention de 4e classe",
      "Trafic de stupéfiants",
      "Simple vol à l’étalage",
    ],
    answer: "Trafic de stupéfiants",
    explanation:
        "Les crimes et délits de trafic de stupéfiants (art. 222-34 à 222-40 CP) sont expressément visés par 706-73 CPP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "706-73 — Infractions visées",
    question:
        "Les crimes et délits constituant des actes de terrorisme sont visés par :",
    options: [
      "L’article 706-73 CPP",
      "L’article 706-73-1 CPP",
      "Uniquement par le Code pénal",
    ],
    answer: "L’article 706-73 CPP",
    explanation:
        "Les actes de terrorisme (art. 421-1 à 421-6 CP) figurent au 11° de l’article 706-73 CPP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "706-73 — Exemples",
    question:
        "Le meurtre commis en bande organisée entre dans le champ de la criminalité organisée au titre :",
    options: [
      "Du 1° de l’article 706-73 CPP",
      "Du 3° de l’article 706-73-1 CPP",
      "Du 21° de l’article 706-73 CPP",
    ],
    answer: "Du 1° de l’article 706-73 CPP",
    explanation:
        "Le 1° de 706-73 vise le crime de meurtre commis en bande organisée (art. 221-4 CP).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "706-73-1 — Infractions visées",
    question: "L’escroquerie commise en bande organisée relève de :",
    options: [
      "L’article 706-73 CPP",
      "L’article 706-73-1 CPP",
      "L’article 706-74 CPP",
    ],
    answer: "L’article 706-73-1 CPP",
    explanation:
        "L’escroquerie en bande organisée est visée au 1° de l’article 706-73-1 CPP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "706-74 — Rappel",
    question:
        "Les infractions de l’article 706-74 CPP bénéficient des règles de criminalité organisée :",
    options: [
      "Toujours, sans condition",
      "Uniquement quand la loi le prévoit expressément",
      "Jamais",
    ],
    answer: "Uniquement quand la loi le prévoit expressément",
    explanation:
        "Pour 706-74, les règles spéciales ne s’appliquent que lorsque le texte le prévoit.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Criminalité organisée — Bande organisée",
    question: "La bande organisée est une circonstance :",
    options: ["Atténuante", "Aggravante", "Neutre sur la peine"],
    answer: "Aggravante",
    explanation:
        "La bande organisée constitue une circonstance aggravante prévue par le Code pénal.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Criminalité organisée — Intérêt",
    question:
        "Un intérêt majeur de la procédure spéciale de criminalité organisée est :",
    options: [
      "La réduction des délais de prescription",
      "La mise en place de techniques spéciales d’enquête",
      "La suppression du contrôle du juge",
    ],
    answer: "La mise en place de techniques spéciales d’enquête",
    explanation:
        "Elle permet d’utiliser géolocalisation prolongée, interceptions, IMSI-catcher, sonorisation, etc.",
    difficulty: "Facile",
  ),

  // ===================== GÉOLOCALISATION & SURVEILLANCE =====================
  const QuizQuestion(
    category: "Géolocalisation — Durée",
    question:
        "En matière de criminalité organisée, la géolocalisation peut durer au maximum :",
    options: ["15 jours", "2 mois", "2 ans"],
    answer: "2 ans",
    explanation:
        "L’autorisation initiale (15 jours) peut être prolongée jusqu’à une durée totale de deux ans (art. 230-32 et s. CPP).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Géolocalisation — Autorité",
    question:
        "Qui délivre l’autorisation initiale de géolocalisation en enquête de flagrance pour une infraction 706-73 ?",
    options: [
      "Le juge d’instruction",
      "Le procureur de la République",
      "Le préfet",
    ],
    answer: "Le procureur de la République",
    explanation:
        "En flagrance, l’autorisation initiale est donnée par le procureur, pour 15 jours maximum.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Surveillance — Champ",
    question: "La surveillance (art. 706-80 CPP) peut porter sur :",
    options: [
      "Uniquement les personnes",
      "Uniquement les biens",
      "Les personnes ET les objets, biens ou produits",
    ],
    answer: "Les personnes ET les objets, biens ou produits",
    explanation:
        "La surveillance peut viser les personnes soupçonnées et l’acheminement des biens issus des infractions.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Surveillance — Territoire",
    question:
        "La surveillance mise en place au titre de l’article 706-80 CPP peut être étendue :",
    options: [
      "Au seul département d’origine",
      "À l’ensemble du territoire national",
      "Uniquement à la région",
    ],
    answer: "À l’ensemble du territoire national",
    explanation:
        "Le texte permet une extension des surveillances sur tout le territoire national.",
    difficulty: "Facile",
  ),

  // ===================== INFILTRATION =====================
  const QuizQuestion(
    category: "Infiltration — Principe",
    question: "L’infiltration consiste pour l’enquêteur à :",
    options: [
      "Surveiller à distance par caméra",
      "Se faire passer pour un coauteur, complices ou receleur",
      "Contrôler les identités dans un quartier",
    ],
    answer: "Se faire passer pour un coauteur, complices ou receleur",
    explanation:
        "L’OPJ/APJ se fait passer pour un membre du réseau ou une personne intéressée à la commission de l’infraction.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infiltration — Autorisation",
    question:
        "Qui autorise une opération d’infiltration en enquête de flagrance ou préliminaire ?",
    options: [
      "Le juge des libertés et de la détention",
      "Le procureur de la République",
      "Le préfet de police",
    ],
    answer: "Le procureur de la République",
    explanation:
        "L’infiltration doit être autorisée par écrit et de façon motivée par le procureur (ou le juge d’instruction en information).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infiltration — Durée",
    question:
        "La durée initiale maximale d’une autorisation d’infiltration est de :",
    options: ["1 mois", "3 mois", "4 mois"],
    answer: "4 mois",
    explanation:
        "L’autorisation est délivrée pour 4 mois, renouvelables dans les mêmes conditions (art. 706-81 CPP).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infiltration — Interdiction",
    question: "Quelle limite importante s’applique à l’agent infiltré ?",
    options: [
      "Il ne peut jamais participer à une réunion",
      "Il ne doit pas provoquer la commission d’infractions",
      "Il doit révéler sa véritable identité au suspect",
    ],
    answer: "Il ne doit pas provoquer la commission d’infractions",
    explanation:
        "À peine de nullité, l’agent ne peut être à l’origine de l’infraction (pas d’agent provocateur).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Infiltration — Protection",
    question: "La révélation de l’identité réelle d’un agent infiltré est :",
    options: [
      "Tolérée si faite par un confrère",
      "Une infraction pénale",
      "Sans conséquence juridique",
    ],
    answer: "Une infraction pénale",
    explanation:
        "La loi protège l’anonymat de l’agent infiltré, sa révélation est pénalement sanctionnée.",
    difficulty: "Facile",
  ),

  // ===================== GARDE À VUE — DURÉES =====================
  const QuizQuestion(
    category: "Garde à vue — Droit commun",
    question:
        "La durée maximale d’une garde à vue de droit commun (hors criminalité organisée) est en principe de :",
    options: ["24 heures", "48 heures", "72 heures"],
    answer: "48 heures",
    explanation:
        "La garde à vue de droit commun est de 24h renouvelable une fois, soit 48h au total.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Criminalité organisée",
    question:
        "Pour une infraction relevant de l’article 706-73 CPP (hors terrorisme et mules), la garde à vue peut aller jusqu’à :",
    options: ["72 heures", "96 heures", "120 heures"],
    answer: "96 heures",
    explanation:
        "L’article 706-88 permet deux prolongations supplémentaires de 24h ou une de 48h, soit 96h maxi.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Terrorisme — Procédure",
    question: "La garde à vue en matière de terrorisme peut aller jusqu’à :",
    options: ["48h", "96h", "144h"],
    answer: "144h",
    explanation:
        "L’article 706-88-1 CPP permet une durée exceptionnelle de 6 jours (144h) en matière terroriste.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Mules",
    question:
        "Pour un passeur de stupéfiants in corpore (mule), la garde à vue peut atteindre :",
    options: ["96 heures", "120 heures", "144 heures"],
    answer: "120 heures",
    explanation:
        "L’article 706-88-2 CPP prévoit une prolongation exceptionnelle de 24h après 96h, soit 120h.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Avocat",
    question:
        "En matière de criminalité organisée, l’intervention de l’avocat peut être différée pour :",
    options: [
      "Éviter une atteinte grave à la vie ou à l’intégrité d’une personne",
      "Soulager la charge de travail de l’OPJ",
      "Sanctionner le mis en cause",
    ],
    answer:
        "Éviter une atteinte grave à la vie ou à l’intégrité d’une personne",
    explanation:
        "Le report doit répondre à des raisons impérieuses liées aux preuves ou à la protection des personnes.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Médecin",
    question:
        "Lors d’une prolongation supplémentaire de GAV en criminalité organisée, l’examen médical :",
    options: [
      "Est facultatif",
      "Est obligatoire",
      "Est remplacé par l’avis de l’OPJ",
    ],
    answer: "Est obligatoire",
    explanation:
        "Le texte impose un examen médical et un certificat sur l’aptitude au maintien en garde à vue.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Mineurs — Garde à vue",
    question:
        "Le régime de GAV des majeurs en criminalité organisée (706-88) s’applique aux mineurs :",
    options: [
      "De tout âge",
      "Uniquement de plus de 13 ans",
      "De plus de 16 ans sous conditions",
    ],
    answer: "De plus de 16 ans sous conditions",
    explanation:
        "Art. L. 413-11 CJPM : mineur > 16 ans, infraction 706-73 (sauf 21°) et participation de majeurs.",
    difficulty: "Facile",
  ),

  // ===================== PERQUISITIONS =====================
  const QuizQuestion(
    category: "Perquisitions — Nuit",
    question:
        "En criminalité organisée, les perquisitions de nuit au domicile :",
    options: [
      "Sont toujours interdites",
      "Peuvent être autorisées par le JLD ou le juge d’instruction",
      "Sont laissées à l’appréciation de l’OPJ",
    ],
    answer: "Peuvent être autorisées par le JLD ou le juge d’instruction",
    explanation:
        "Les articles 706-89 à 706-91 CPP prévoient cette possibilité, sur autorisation écrite et motivée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Perquisitions — Stupéfiants",
    question: "L’article 706-28 CPP permet des perquisitions de nuit :",
    options: [
      "Uniquement dans des locaux d’habitation",
      "Dans certains lieux liés aux stupéfiants, hors habitation",
      "Dans les tribunaux",
    ],
    answer: "Dans certains lieux liés aux stupéfiants, hors habitation",
    explanation:
        "Cet article vise les lieux où l’on use en société de stupéfiants ou où ils sont fabriqués/entrepôs, hors domicile.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Perquisitions — Proxénétisme",
    question: "L’article 706-35 CPP autorise des perquisitions de nuit :",
    options: [
      "Dans n’importe quel domicile",
      "Dans certains lieux ouverts au public où des personnes se prostituent",
      "Uniquement en garde à vue",
    ],
    answer:
        "Dans certains lieux ouverts au public où des personnes se prostituent",
    explanation:
        "Ex : hôtels, débits de boissons, clubs, lieux ouverts au public recevant habituellement des personnes se livrant à la prostitution.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Perquisition — Absence de la personne",
    question:
        "En criminalité organisée, la perquisition au domicile d’une personne gardée à vue en son absence :",
    options: [
      "Est toujours interdite",
      "Est possible sous conditions strictes",
      "Ne nécessite aucune autorisation",
    ],
    answer: "Est possible sous conditions strictes",
    explanation:
        "706-94 CPP : nécessite accord du magistrat et présence de témoins ou représentant.",
    difficulty: "Facile",
  ),

  // ===================== INTERCEPTIONS & TECHNIQUES SPÉCIALES =====================
  const QuizQuestion(
    category: "Interceptions — 706-95",
    question:
        "L’article 706-95 CPP permet, en enquête de flagrance ou préliminaire :",
    options: [
      "Les contrôles d’identité systématiques",
      "L’interception de correspondances électroniques",
      "La fouille des véhicules sans motif",
    ],
    answer: "L’interception de correspondances électroniques",
    explanation:
        "706-95 autorise les interceptions, enregistrements et transcriptions des communications électroniques.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Interceptions — Durée",
    question:
        "La durée d’une interception de correspondances autorisée en vertu de l’article 706-95 est :",
    options: [
      "1 mois renouvelable une fois",
      "3 mois renouvelables sans limite",
      "15 jours non renouvelables",
    ],
    answer: "1 mois renouvelable une fois",
    explanation:
        "Une durée d’un mois, renouvelable une fois dans les mêmes conditions de forme et de durée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "IMSI-catcher — Objet",
    question: "Un IMSI-catcher permet notamment :",
    options: [
      "De relever les plaques d’immatriculation",
      "De capter des données techniques de connexion et localiser un terminal",
      "De vérifier l’authenticité des billets de banque",
    ],
    answer:
        "De capter des données techniques de connexion et localiser un terminal",
    explanation:
        "Il permet notamment l’identification d’un équipement terminal, du numéro d’abonnement et sa localisation.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Sonorisation — Objet",
    question:
        "La sonorisation au sens des articles 706-96 et suivants permet :",
    options: [
      "De filmer la voie publique",
      "De capter les paroles prononcées à titre privé ou confidentiel",
      "D’ouvrir le courrier papier",
    ],
    answer: "De capter les paroles prononcées à titre privé ou confidentiel",
    explanation:
        "Il s’agit de la captation, fixation et enregistrement de paroles dans certains lieux ou véhicules.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Captation de données — 706-102-1",
    question: "La captation de données informatiques permet :",
    options: [
      "Uniquement la saisie matérielle des ordinateurs",
      "D’accéder, enregistrer et conserver des données informatiques à distance",
      "De bloquer l’accès internet d’un suspect",
    ],
    answer:
        "D’accéder, enregistrer et conserver des données informatiques à distance",
    explanation:
        "Le dispositif technique permet d’accéder aux données telles qu’affichées, introduites ou échangées.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Dossier coffre — Objet",
    question: "Le « dossier coffre » (art. 706-104 CPP) sert à :",
    options: [
      "Conserver les casiers judiciaires",
      "Isoler certaines informations pour protéger des personnes",
      "Classer les archives du tribunal",
    ],
    answer: "Isoler certaines informations pour protéger des personnes",
    explanation:
        "Ce PV distinct contient des données sensibles (identité des techniciens, etc.) pour éviter de mettre en danger des personnes.",
    difficulty: "Facile",
  ),

  // ===================== ENQUÊTE PRÉLIMINAIRE & DURÉES =====================
  const QuizQuestion(
    category: "Enquête préliminaire — Durée",
    question:
        "En matière de criminalité organisée, la durée maximale d’une enquête préliminaire est de :",
    options: [
      "1 an non renouvelable",
      "3 ans, renouvelables 2 ans",
      "6 mois seulement",
    ],
    answer: "3 ans, renouvelables 2 ans",
    explanation:
        "La durée ne peut excéder 3 ans, renouvelables 2 ans sur autorisation écrite et motivée du procureur.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Enquête préliminaire — Sanction",
    question:
        "Que deviennent les actes concernant une personne, réalisés après l’expiration du délai butoir de l’enquête préliminaire en criminalité organisée ?",
    options: [
      "Ils restent valables",
      "Ils sont nuls",
      "Ils sont régularisés par le juge d’instruction",
    ],
    answer: "Ils sont nuls",
    explanation:
        "Tout acte d’enquête postérieur au délai butoir est frappé de nullité pour cette personne.",
    difficulty: "Facile",
  ),

  // ===================== MESURES CONSERVATOIRES & FINANCEMENT =====================
  const QuizQuestion(
    category: "Mesures conservatoires — 706-103",
    question:
        "L’article 706-103 CPP permet au JLD d’ordonner des mesures conservatoires pour :",
    options: [
      "Garantir le paiement des amendes et l’indemnisation des victimes",
      "Organiser la garde du matériel saisi",
      "Assurer la publicité de la décision",
    ],
    answer: "Garantir le paiement des amendes et l’indemnisation des victimes",
    explanation:
        "Ces mesures portent sur les biens du mis en examen pour sécuriser les sanctions pécuniaires et réparations.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Mesures conservatoires — Champ",
    question:
        "Les mesures conservatoires de l’article 706-103 peuvent porter sur :",
    options: [
      "Uniquement les biens meubles",
      "Uniquement les biens immobiliers",
      "Les biens meubles ou immeubles, divis ou indivis",
    ],
    answer: "Les biens meubles ou immeubles, divis ou indivis",
    explanation:
        "Le texte vise les biens meubles et immeubles, qu’ils soient divis ou indivis, de la personne mise en examen.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE =====================
  // ================ QUESTIONS PLUS TECHNIQUES =====================
  const QuizQuestion(
    category: "706-73 — Blanchiment",
    question: "Le blanchiment visé au 14° de l’article 706-73 CPP concerne :",
    options: [
      "Le produit de n’importe quelle infraction",
      "Uniquement le produit d’un délit routier",
      "Le produit des infractions mentionnées aux 1° à 13° de 706-73",
    ],
    answer: "Le produit des infractions mentionnées aux 1° à 13° de 706-73",
    explanation:
        "Le texte vise le blanchiment ou le recel des produits des infractions graves listées aux 1° à 13°.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "706-73-1 — Blanchiment",
    question: "Le 3° bis de l’article 706-73-1 CPP vise :",
    options: [
      "Tous les blanchiments de droit commun",
      "Certains blanchiments de l’article 324-2 CP, sauf ceux déjà couverts par 706-73",
      "Uniquement le blanchiment douanier",
    ],
    answer:
        "Certains blanchiments de l’article 324-2 CP, sauf ceux déjà couverts par 706-73",
    explanation:
        "Le 3° bis étend le régime procédural à des blanchiments particuliers (324-2 CP) non déjà couverts par 706-73.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Association de malfaiteurs — 706-73",
    question:
        "L’association de malfaiteurs relève de 706-73 CPP lorsqu’elle a pour objet :",
    options: [
      "N’importe quelle infraction",
      "La préparation d’une infraction mentionnée aux 1° à 14° ou 17°",
      "La préparation d’une simple contravention",
    ],
    answer: "La préparation d’une infraction mentionnée aux 1° à 14° ou 17°",
    explanation:
        "Le 15° de 706-73 vise l’association de malfaiteurs liée à ces infractions graves.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Non-justification de ressources",
    question:
        "Le délit de non-justification de ressources (art. 321-6-1 CP) relève de la criminalité organisée lorsqu’il est :",
    options: [
      "Toujours applicable",
      "En relation avec certaines infractions graves (706-73 ou 706-73-1)",
      "Uniquement en cas de récidive",
    ],
    answer:
        "En relation avec certaines infractions graves (706-73 ou 706-73-1)",
    explanation:
        "706-73 (16°) et 706-73-1 (5°) conditionnent ce délit à un lien avec les infractions énumérées.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Conseil constitutionnel — Gravité",
    question:
        "Concernant le vol en bande organisée, le Conseil constitutionnel a précisé que les mesures dérogatoires ne s’appliquent que si :",
    options: [
      "Le vol est commis de nuit",
      "Le vol présente une atteinte grave à la sécurité, à la dignité ou à la vie",
      "Le vol est commis à l’étranger",
    ],
    answer:
        "Le vol présente une atteinte grave à la sécurité, à la dignité ou à la vie",
    explanation:
        "Décision 2004-492 DC : exigence de gravité suffisante pour justifier les mesures spéciales.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Aide au séjour irrégulier — Limites",
    question:
        "Le Conseil constitutionnel a indiqué que le délit d’aide au séjour irrégulier en bande organisée :",
    options: [
      "Peut viser les organisations humanitaires",
      "Ne doit pas viser les organisations humanitaires d’aide aux étrangers",
      "Ne peut jamais être poursuivi",
    ],
    answer:
        "Ne doit pas viser les organisations humanitaires d’aide aux étrangers",
    explanation:
        "Il rappelle que l’intention délictuelle (art. 121-3 CP) doit être caractérisée et que l’aide humanitaire ne doit pas être pénalisée.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Infiltration — Rapport",
    question: "Qui rédige le rapport retraçant l’opération d’infiltration ?",
    options: [
      "L’agent infiltré uniquement",
      "L’OPJ coordonnateur",
      "Le préfet de police",
    ],
    answer: "L’OPJ coordonnateur",
    explanation:
        "L’OPJ sous la responsabilité duquel se déroule l’opération rédige le rapport, sans compromettre la sécurité de l’agent.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Infiltration — Poursuite de la couverture",
    question:
        "Après la fin officielle de l’infiltration, l’agent peut poursuivre ses activités :",
    options: [
      "Sans limite de durée",
      "Pendant le temps strictement nécessaire à sa sécurité, jusqu’à 4 mois (renouvelables sous conditions)",
      "Uniquement 24 heures",
    ],
    answer:
        "Pendant le temps strictement nécessaire à sa sécurité, jusqu’à 4 mois (renouvelables sous conditions)",
    explanation:
        "Art. 706-85 CPP : possibilité de prolonger pour assurer une sortie sécurisée du réseau criminel.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Garde à vue — Terrorisme",
    question:
        "En matière terroriste, la prolongation de GAV au-delà de 96 heures :",
    options: [
      "Est décidée par le procureur seul",
      "Est décidée par le JLD à la requête du procureur ou du juge d’instruction",
      "Ne nécessite aucune décision écrite",
    ],
    answer:
        "Est décidée par le JLD à la requête du procureur ou du juge d’instruction",
    explanation:
        "706-88-1 : prolongations supplémentaires de 24h décidées par le JLD, avec présentation de la personne.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Avocat — Report d’intervention",
    question:
        "Le report de l’intervention de l’avocat en GAV 706-88 au-delà de la 24e heure :",
    options: [
      "Est décidé par le procureur",
      "Est décidé par le JLD, à la requête du procureur",
      "Ne peut jamais être décidé",
    ],
    answer: "Est décidé par le JLD, à la requête du procureur",
    explanation:
        "Au-delà de la 24e heure, le report doit être autorisé par le JLD, décision écrite et motivée.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Droit à l’examen médical — Longue GAV",
    question:
        "En GAV longue (criminalité organisée), un nouvel examen médical :",
    options: [
      "Peut être ordonné à tout moment par le magistrat ou l’OPJ",
      "Est strictement limité aux premières 24h",
      "Est interdit au-delà de 72h",
    ],
    answer: "Peut être ordonné à tout moment par le magistrat ou l’OPJ",
    explanation:
        "Même si le texte ne le prévoit pas expressément à chaque étape, un examen peut toujours être ordonné si nécessaire.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Enquête préliminaire",
    question:
        "En enquête préliminaire, les perquisitions de nuit hors locaux d’habitation pour des infractions 706-73 ou 706-73-1 :",
    options: [
      "Sont décidées par l’OPJ",
      "Sont autorisées par le JLD, à la requête du procureur",
      "Ne sont jamais possibles",
    ],
    answer: "Sont autorisées par le JLD, à la requête du procureur",
    explanation:
        "Art. 706-90 CPP : perquisitions de nuit hors habitation sur autorisation écrite et motivée du JLD.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Sans assentiment",
    question:
        "En enquête préliminaire, les perquisitions sans l’assentiment de la personne chez qui elles ont lieu :",
    options: [
      "Sont possibles pour les délits punis d’au moins 3 ans d’emprisonnement",
      "Sont toujours interdites",
      "Nécessitent uniquement l’accord de l’OPJ",
    ],
    answer:
        "Sont possibles pour les délits punis d’au moins 3 ans d’emprisonnement",
    explanation:
        "Art. 76 al. 4 CPP, combiné avec 706-90 pour la criminalité organisée.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Interceptions — Lignes protégées",
    question:
        "Les interceptions visant une ligne d’avocat, magistrat ou parlementaire :",
    options: [
      "Sont interdites en toutes circonstances",
      "Sont possibles avec avis de l’autorité compétente (bâtonnier, président d’assemblée...)",
      "Sont laissées à l’appréciation de l’OPJ",
    ],
    answer:
        "Sont possibles avec avis de l’autorité compétente (bâtonnier, président d’assemblée...)",
    explanation:
        "Art. 100-7 CPP : avis préalable obligatoire, à peine de nullité.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Techniques spéciales — Durée",
    question:
        "La durée initiale des techniques spéciales d’enquête (IMSI-catcher, sonorisation, captation de données) en enquête est :",
    options: [
      "1 mois renouvelable une fois",
      "4 mois renouvelables deux ans",
      "15 jours non renouvelables",
    ],
    answer: "1 mois renouvelable une fois",
    explanation:
        "Art. 706-95-16 CPP : 1 mois, renouvelable une fois en enquête (flagrance ou préliminaire).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Instruction — Techniques spéciales",
    question:
        "En information judiciaire, la durée des techniques spéciales d’enquête peut aller jusqu’à :",
    options: [
      "4 mois sans renouvellement",
      "4 mois renouvelables pendant 2 ans maximum",
      "6 mois renouvelables sans limite",
    ],
    answer: "4 mois renouvelables pendant 2 ans maximum",
    explanation:
        "En instruction, l’autorisation est de 4 mois, renouvelable dans la limite totale de 2 ans.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Dossier coffre — Contestation",
    question:
        "Le versement d’informations dans le « dossier coffre » peut être contesté :",
    options: [
      "Jamais, c’est secret absolu",
      "Selon les modalités prévues à l’article 706-104-1 CPP",
      "Uniquement par le procureur",
    ],
    answer: "Selon les modalités prévues à l’article 706-104-1 CPP",
    explanation:
        "Le texte organise la contestation et l’utilisation des éléments issus des techniques spéciales.",
    difficulty: "Intermédiaire",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  // ================ CAS PRATIQUES & QUESTIONS PIÈGES ==========
  const QuizQuestion(
    category: "Cas pratique — Surveillance",
    question:
        "Des OPJ suivent discrètement un véhicule transportant des biens issus d’un trafic de stupéfiants entre plusieurs régions françaises. Quel dispositif juridique permet d’étendre cette surveillance sur tout le territoire ?",
    options: [
      "Les dispositions générales de l’article 60 CPP",
      "La surveillance prévue à l’article 706-80 CPP",
      "Uniquement une commission rogatoire",
    ],
    answer: "La surveillance prévue à l’article 706-80 CPP",
    explanation:
        "706-80 autorise l’extension de la surveillance sur toute la France pour certaines infractions graves.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Infiltration",
    question:
        "Un agent infiltré, autorisé pour une enquête sur un réseau de traite des êtres humains (706-73), propose lui-même l’idée d’augmenter la violence des faits pour faire réagir le groupe. Quelle conséquence procédurale principale risque-t-on ?",
    options: [
      "La nullité de l’autorisation du procureur uniquement",
      "La nullité des actes d’infiltration pour incitation à l’infraction",
      "Aucune, c’est autorisé en infiltration",
    ],
    answer:
        "La nullité des actes d’infiltration pour incitation à l’infraction",
    explanation:
        "L’agent ne doit pas provoquer l’infraction ; sinon, risque de nullité des actes.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Perquisition de nuit",
    question:
        "Un JLD autorise une perquisition de nuit dans un domicile pour une enquête préliminaire en escroquerie en bande organisée (706-73-1). L’ordonnance ne précise pas l’adresse exacte. Quel risque ?",
    options: [
      "Aucun, l’adresse est facultative",
      "Nullité de la perquisition pour autorisation insuffisamment déterminée",
      "Simple irrégularité sans conséquence",
    ],
    answer:
        "Nullité de la perquisition pour autorisation insuffisamment déterminée",
    explanation:
        "706-92 CPP exige une autorisation précise (adresse, lieux visés) à peine de nullité.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Interceptions",
    question:
        "Dans une enquête 706-73, les enquêteurs interceptent la ligne d’un avocat sans avis au bâtonnier. Les interceptions révèlent néanmoins des informations accablantes. Que risque-t-on ?",
    options: [
      "Les interceptions sont valables puisqu’il s’agit de criminalité organisée",
      "Nullité des interceptions pour violation de l’article 100-7 CPP",
      "Une simple remarque du juge mais les preuves restent valables",
    ],
    answer: "Nullité des interceptions pour violation de l’article 100-7 CPP",
    explanation:
        "L’avis de l’autorité professionnelle est une garantie essentielle, à peine de nullité.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — IMSI-catcher",
    question:
        "Un IMSI-catcher est installé dans le cabinet d’un journaliste pour une affaire de trafic de stupéfiants (706-73). L’autorisation vise la captation des données techniques de connexion. Que dire ?",
    options: [
      "La mesure est régulière si autorisée par le JLD",
      "La mesure est irrégulière, ces lieux sont protégés",
      "La mesure est possible seulement le jour",
    ],
    answer: "La mesure est irrégulière, ces lieux sont protégés",
    explanation:
        "Les locaux d’une entreprise de presse ou domicile d’un journaliste sont protégés (56-2, 56-3 CPP).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Captation de données",
    question:
        "Pour capter les données d’un ordinateur utilisé par un magistrat, dans une enquête 706-73, les enquêteurs sollicitent une autorisation 706-102-1. Quelle est la réponse correcte ?",
    options: [
      "C’est possible avec autorisation du JLD",
      "C’est interdit, ces systèmes sont exclus du dispositif",
      "C’est possible uniquement la nuit",
    ],
    answer: "C’est interdit, ces systèmes sont exclus du dispositif",
    explanation:
        "706-102-5 exclut notamment les systèmes se trouvant dans certains lieux protégés (magistrats, avocats, etc.).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Durée enquête préliminaire",
    question:
        "Une enquête préliminaire pour association de malfaiteurs liée à un trafic de stupéfiants dure 3 ans et 6 mois sans renouvellement formel par le procureur. Un acte est réalisé à 3 ans et 4 mois au préjudice de M. X. Quelle conséquence ?",
    options: [
      "L’acte est valable car l’enquête porte sur de la criminalité organisée",
      "L’acte est nul pour M. X, le délai butoir est dépassé",
      "Il suffit de régulariser a posteriori",
    ],
    answer: "L’acte est nul pour M. X, le délai butoir est dépassé",
    explanation:
        "Au-delà de 3 ans, il fallait une prolongation de 2 ans par décision écrite et motivée du procureur.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Dossier coffre",
    question:
        "Des informations relatives à l’identité d’un technicien ayant posé une sonorisation sont conservées dans un dossier distinct non accessible aux parties. Sur quel fondement ?",
    options: [
      "Article 706-104 CPP (dossier coffre)",
      "Article 63-3 CPP",
      "Article 75 CPP",
    ],
    answer: "Article 706-104 CPP (dossier coffre)",
    explanation:
        "Le dossier coffre isole les informations susceptibles de mettre en danger des personnes ayant concouru aux techniques spéciales.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Mineur et GAV",
    question:
        "Un mineur de 15 ans est mis en cause pour trafic de stupéfiants (706-73). Peut-on appliquer le régime de GAV 706-88 ?",
    options: [
      "Oui, car l’infraction est listée à 706-73",
      "Non, le mineur doit avoir plus de 16 ans",
      "Oui, si le parquet l’autorise",
    ],
    answer: "Non, le mineur doit avoir plus de 16 ans",
    explanation:
        "L. 413-11 CJPM : régime spécial 706-88 seulement pour les mineurs > 16 ans.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Mesures conservatoires",
    question:
        "Dans une information pour trafic de stupéfiants, le parquet souhaite garantir le paiement des amendes et l’indemnisation des victimes. Quelle procédure utiliser ?",
    options: [
      "La saisie administrative à tiers détenteur",
      "Les mesures conservatoires de l’article 706-103 CPP",
      "Uniquement la saisie pénale spéciale",
    ],
    answer: "Les mesures conservatoires de l’article 706-103 CPP",
    explanation:
        "706-103 permet au JLD, saisi par le procureur, d’ordonner des mesures conservatoires sur les biens de la personne mise en examen.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Infiltration et témoignage",
    question:
        "En jugement, le prévenu demande la confrontation directe avec l’agent infiltré dont les déclarations sont à l’origine de sa mise en examen. Que se passe-t-il ?",
    options: [
      "La confrontation est impossible car l’agent est anonyme",
      "La confrontation peut avoir lieu dans des conditions préservant l’anonymat",
      "La procédure doit être annulée",
    ],
    answer:
        "La confrontation peut avoir lieu dans des conditions préservant l’anonymat",
    explanation:
        "L’agent peut être confronté sous couvert de dispositifs techniques protégeant son identité (706-61 CPP).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Généralités — Champ d’application",
    question:
        "Quels articles du CPP définissent principalement le champ d’application de la procédure applicable à la criminalité organisée ?",
    options: [
      "Les articles 63 à 78",
      "Les articles 706-73 et 706-73-1",
      "Les articles 221-1 à 221-5",
    ],
    answer: "Les articles 706-73 et 706-73-1",
    explanation:
        "Les articles 706-73, 706-73-1 et 706-74 du CPP déterminent les infractions relevant de la criminalité et de la délinquance organisées.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Nature des infractions",
    question:
        "Parmi les propositions suivantes, laquelle correspond à une caractéristique typique de la criminalité organisée selon le CPP ?",
    options: [
      "Des infractions commises uniquement par un individu isolé",
      "Des infractions commises par des organisations structurées, souvent en bande organisée",
      "Des infractions exclusivement financières",
    ],
    answer:
        "Des infractions commises par des organisations structurées, souvent en bande organisée",
    explanation:
        "La criminalité organisée vise des infractions commises par des groupes structurés, avec préparation et répartition des rôles (bande organisée, association de malfaiteurs, etc.).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Articles 706-73 — Infractions visées",
    question:
        "Quel type d’infraction fait partie de la liste de l’article 706-73 du CPP ?",
    options: [
      "Les contraventions routières simples",
      "Les crimes et délits de trafic de stupéfiants",
      "Les injures non publiques",
    ],
    answer: "Les crimes et délits de trafic de stupéfiants",
    explanation:
        "Les articles 222-34 à 222-40 du code pénal relatifs au trafic de stupéfiants sont expressément visés par l’article 706-73.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Articles 706-73 — Infractions visées",
    question:
        "Quelle affirmation est exacte à propos du crime de meurtre commis en bande organisée ?",
    options: [
      "Il est visé à l’article 706-73 du CPP",
      "Il ne relève jamais de la criminalité organisée",
      "Il est uniquement sanctionné en droit administratif",
    ],
    answer: "Il est visé à l’article 706-73 du CPP",
    explanation:
        "Le meurtre commis en bande organisée (art. 221-4 CP) figure dans la liste de l’article 706-73 du CPP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Articles 706-73 — Terrorisme",
    question:
        "Les crimes et délits constituant des actes de terrorisme relèvent-ils de la criminalité organisée au sens de l’article 706-73 ?",
    options: [
      "Oui, ils sont expressément visés par l’article 706-73",
      "Non, ils relèvent d’un régime totalement distinct",
      "Uniquement pour les contraventions",
    ],
    answer: "Oui, ils sont expressément visés par l’article 706-73",
    explanation:
        "Les actes de terrorisme (art. 421-1 à 421-6 CP) sont mentionnés au 11° de l’article 706-73.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Articles 706-73-1 — Infractions économiques",
    question:
        "Quel délit figure parmi ceux visés par l’article 706-73-1 du CPP ?",
    options: [
      "Le vol simple",
      "L’escroquerie en bande organisée",
      "L’outrage à personne dépositaire de l’autorité publique",
    ],
    answer: "L’escroquerie en bande organisée",
    explanation:
        "L’escroquerie en bande organisée (art. 313-2 CP, dernier alinéa) figure au 1° de l’article 706-73-1.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Articles 706-74 — Champ résiduel",
    question:
        "Que vise principalement l’article 706-74 du CPP en matière de criminalité organisée ?",
    options: [
      "Les crimes et délits commis en bande organisée non déjà visés par 706-73 et 706-73-1",
      "Les contraventions de 1re classe",
      "Uniquement les infractions routières en récidive",
    ],
    answer:
        "Les crimes et délits commis en bande organisée non déjà visés par 706-73 et 706-73-1",
    explanation:
        "L’article 706-74 joue un rôle de filet pour d’autres infractions commises en bande organisée, dans les cas où la loi prévoit expressément les règles spéciales.",
    difficulty: "Facile",
  ),

  // ==========================================================
  //                 NIVEAU FACILE — GARDE À VUE
  // ==========================================================
  const QuizQuestion(
    category: "Garde à vue — Durée",
    question:
        "En matière de criminalité organisée relevant de l’article 706-73 (hors exceptions), quelle peut être la durée maximale d’une garde à vue d’un majeur ?",
    options: ["48 heures", "72 heures", "96 heures"],
    answer: "96 heures",
    explanation:
        "L’article 706-88 permet, à titre exceptionnel, deux prolongations supplémentaires de 24 h après les 48 h de droit commun, soit 96 heures au total.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Terrorisme",
    question:
        "En matière de terrorisme (706-73, 11°), quelle peut être la durée maximale exceptionnelle d’une garde à vue ?",
    options: ["96 heures", "120 heures", "144 heures"],
    answer: "144 heures",
    explanation:
        "L’article 706-88-1 prévoit qu’en matière de terrorisme, la garde à vue peut, à titre exceptionnel, atteindre 6 jours (144 heures).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Mules",
    question:
        "Pour une « mule » (transport de stupéfiants in corpore), la garde à vue peut, à titre exceptionnel, atteindre :",
    options: ["96 heures", "120 heures", "72 heures"],
    answer: "120 heures",
    explanation:
        "L’article 706-88-2 CPP prévoit une prolongation exceptionnelle de 24 h après les 96 h, soit 120 heures maximum.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Avocat",
    question:
        "Dans la procédure de criminalité organisée (706-73), l’intervention de l’avocat peut être :",
    options: [
      "Toujours immédiate sans exception",
      "Différée pour des raisons impérieuses pendant 48 h voire 72 h pour certains cas",
      "Supprimée pour toute la durée de la garde à vue",
    ],
    answer:
        "Différée pour des raisons impérieuses pendant 48 h voire 72 h pour certains cas",
    explanation:
        "L’article 706-88 permet le report de l’intervention de l’avocat jusqu’à 48 h, voire 72 h pour le terrorisme ou certains trafics de stupéfiants.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Mineurs",
    question:
        "Pour un mineur de moins de 16 ans, la garde à vue en matière de criminalité organisée peut-elle dépasser 48 heures ?",
    options: [
      "Oui, jusqu’à 96 heures",
      "Non, elle ne peut pas être prolongée au-delà de 48 heures",
      "Oui, jusqu’à 72 heures",
    ],
    answer: "Non, elle ne peut pas être prolongée au-delà de 48 heures",
    explanation:
        "L’article L. 413-11 du CJPM prévoit que la garde à vue des mineurs de moins de 16 ans ne peut être prolongée au-delà de 48 h, même en criminalité organisée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Examen médical",
    question:
        "En criminalité organisée, lors de la première prolongation supplémentaire (au-delà de 48 h), que prévoit la loi concernant l’examen médical ?",
    options: [
      "Il est facultatif",
      "Il est obligatoire",
      "Il est uniquement décidé par le gardé à vue",
    ],
    answer: "Il est obligatoire",
    explanation:
        "L’article 706-88 impose un examen médical lors de la première prolongation supplémentaire, avec certificat sur l’aptitude au maintien en garde à vue.",
    difficulty: "Facile",
  ),

  // ==========================================================
  //             NIVEAU INTERMÉDIAIRE — SURVEILLANCE / INFILTRATION
  // ==========================================================
  const QuizQuestion(
    category: "Surveillance — Champ d’application",
    question:
        "Selon l’article 706-80 du CPP, dans quel cadre les opérations de surveillance étendue à tout le territoire peuvent-elles être mises en œuvre ?",
    options: [
      "Seulement pour les contraventions routières",
      "Pour les crimes et délits relevant de la criminalité organisée visés aux articles 706-73, 706-73-1 ou 706-74",
      "Uniquement pour les infractions de terrorisme",
    ],
    answer:
        "Pour les crimes et délits relevant de la criminalité organisée visés aux articles 706-73, 706-73-1 ou 706-74",
    explanation:
        "L’article 706-80 autorise la surveillance de personnes et de flux d’objets liés aux infractions entrant dans le champ de la criminalité organisée.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Surveillance — Non-intervention",
    question:
        "Dans le cadre des opérations de surveillance (706-80-1 CPP), que peuvent demander les enquêteurs à d’autres services ?",
    options: [
      "De procéder immédiatement aux interpellations",
      "De ne pas contrôler ni interpeller certaines personnes ni saisir certains biens pour ne pas compromettre l’enquête",
      "De classer sans suite la procédure",
    ],
    answer:
        "De ne pas contrôler ni interpeller certaines personnes ni saisir certains biens pour ne pas compromettre l’enquête",
    explanation:
        "Les OPJ/APJ peuvent solliciter, avec autorisation du procureur, l’absence de contrôle ou de saisie pour préserver la surveillance et l’enquête.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Infiltration — Principe",
    question:
        "Quel est l’objectif principal d’une opération d’infiltration (art. 706-81 CPP) ?",
    options: [
      "Inciter les suspects à commettre de nouvelles infractions",
      "Révéler une infraction et identifier les membres de l’organisation criminelle de l’intérieur",
      "Assurer uniquement la protection des témoins",
    ],
    answer:
        "Révéler une infraction et identifier les membres de l’organisation criminelle de l’intérieur",
    explanation:
        "L’infiltration permet à un OPJ/APJ de se faire passer pour coauteur, complice ou victime afin de pénétrer le réseau criminel.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Infiltration — Autorisation",
    question:
        "Qui autorise l’opération d’infiltration dans le cadre d’une enquête (hors instruction) ?",
    options: [
      "Le juge des libertés et de la détention",
      "Le procureur de la République par décision écrite et motivée",
      "Le préfet de département",
    ],
    answer: "Le procureur de la République par décision écrite et motivée",
    explanation:
        "En enquête, l’infiltration doit être autorisée par le procureur, par décision écrite et spécialement motivée (art. 706-81 et 706-83 CPP).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Infiltration — Durée",
    question:
        "Quelle est la durée maximale initiale d’une opération d’infiltration autorisée par le magistrat ?",
    options: [
      "1 mois renouvelable",
      "4 mois renouvelables",
      "6 mois non renouvelables",
    ],
    answer: "4 mois renouvelables",
    explanation:
        "L’autorisation d’infiltration est délivrée pour 4 mois maximum, renouvelables dans les mêmes conditions (art. 706-81 CPP).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Infiltration — Interdictions",
    question:
        "Quelle limite majeure est posée à l’opération d’infiltration à peine de nullité ?",
    options: [
      "L’agent ne peut jamais se faire passer pour un tiers intéressé",
      "Les actes réalisés ne doivent pas constituer une incitation ayant déterminé la commission des infractions",
      "L’agent ne peut pas utiliser une identité d’emprunt",
    ],
    answer:
        "Les actes réalisés ne doivent pas constituer une incitation ayant déterminé la commission des infractions",
    explanation:
        "L’infiltration ne doit pas se transformer en provocation : l’agent ne doit pas être à l’origine de la décision criminelle.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Infiltration — Protection de l’agent",
    question:
        "Quelle affirmation est exacte concernant la protection de l’agent infiltré ?",
    options: [
      "Son identité réelle doit obligatoirement figurer dans la procédure",
      "La révélation de son identité d’emprunt constitue une infraction pénale",
      "Il n’a aucune protection particulière",
    ],
    answer:
        "La révélation de son identité d’emprunt constitue une infraction pénale",
    explanation:
        "L’article 706-84 CPP incrimine la révélation de l’identité d’emprunt d’un agent infiltré, avec des peines aggravées en cas de violences ou de mort.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  //     NIVEAU INTERMÉDIAIRE — PERQUISITIONS / INTERCEPTIONS
  // ==========================================================
  const QuizQuestion(
    category: "Perquisitions — Nuit et criminalité organisée",
    question:
        "En enquête de flagrance sur une infraction relevant de 706-73 ou 706-73-1, qui peut autoriser une perquisition de nuit au domicile ?",
    options: [
      "Le préfet",
      "Le juge des libertés et de la détention, à la requête du procureur de la République",
      "Le maire de la commune",
    ],
    answer:
        "Le juge des libertés et de la détention, à la requête du procureur de la République",
    explanation:
        "L’article 706-89 CPP exige une ordonnance écrite du JLD, saisi par le procureur, pour perquisitionner de nuit au domicile en criminalité organisée.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Trafic de stupéfiants",
    question:
        "En matière de trafic de stupéfiants (706-28 CPP), les perquisitions de nuit sont possibles :",
    options: [
      "Dans tous les locaux, y compris les domiciles, sans autorisation",
      "Dans les locaux où l’on use en société de stupéfiants ou où ils sont fabriqués/entreposés, hors locaux d’habitation",
      "Uniquement dans les commissariats",
    ],
    answer:
        "Dans les locaux où l’on use en société de stupéfiants ou où ils sont fabriqués/entreposés, hors locaux d’habitation",
    explanation:
        "L’article 706-28 permet des perquisitions de nuit dans certains lieux liés aux stupéfiants, mais exclut les locaux d’habitation.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Proxénétisme",
    question:
        "En matière de proxénétisme (706-35 CPP), les perquisitions de nuit peuvent être réalisées :",
    options: [
      "Dans tout lieu privé sans condition",
      "Dans certains lieux ouverts au public (hôtels, débits de boissons, clubs, etc.) où des personnes prostituées sont reçues habituellement",
      "Uniquement au domicile des personnes prostituées",
    ],
    answer:
        "Dans certains lieux ouverts au public (hôtels, débits de boissons, clubs, etc.) où des personnes prostituées sont reçues habituellement",
    explanation:
        "L’article 706-35 vise des lieux limitativement énumérés et plus largement tout lieu ouvert ou utilisé par le public où la prostitution est habituelle.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Perquisitions — Absence de la personne",
    question:
        "En matière de criminalité organisée, la perquisition au domicile d’une personne gardée à vue ou détenue, en son absence, est possible :",
    options: [
      "Sans condition particulière",
      "Avec accord du procureur ou du juge d’instruction et présence de témoins ou d’un représentant",
      "Seulement si la personne est d’accord par écrit",
    ],
    answer:
        "Avec accord du procureur ou du juge d’instruction et présence de témoins ou d’un représentant",
    explanation:
        "L’article 706-94 impose l’autorisation écrite de l’autorité judiciaire et des garanties (témoins ou représentant du mis en cause).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Interceptions — Communications",
    question:
        "En enquête préliminaire ou de flagrance, qui autorise les interceptions de correspondances émises par la voie des communications électroniques pour les infractions de 706-73 et 706-73-1 ?",
    options: [
      "Le juge d’instruction",
      "Le juge des libertés et de la détention, à la requête du procureur de la République",
      "Le directeur départemental de la police",
    ],
    answer:
        "Le juge des libertés et de la détention, à la requête du procureur de la République",
    explanation:
        "L’article 706-95 renvoie au JLD, saisi par le procureur, pour autoriser les interceptions dans le cadre de l’enquête.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Interceptions — Durée",
    question:
        "Quelle est la durée initiale maximale d’une interception de correspondances autorisée par le JLD au titre de l’article 706-95 ?",
    options: [
      "15 jours, non renouvelables",
      "1 mois, renouvelable une fois dans les mêmes conditions",
      "3 mois, renouvelables illimités",
    ],
    answer: "1 mois, renouvelable une fois dans les mêmes conditions",
    explanation:
        "L’article 706-95 prévoit une durée d’un mois, renouvelable une fois, soit deux mois maximum en enquête.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Interceptions — Lignes protégées",
    question:
        "Les interceptions visant les lignes d’un avocat, d’un parlementaire ou d’un magistrat sont :",
    options: [
      "Interdites en toutes circonstances",
      "Possibles uniquement avec des conditions renforcées (raisons plausibles, avis de l’autorité supérieure)",
      "Libres si l’enquête concerne la criminalité organisée",
    ],
    answer:
        "Possibles uniquement avec des conditions renforcées (raisons plausibles, avis de l’autorité supérieure)",
    explanation:
        "Les articles 100 et 100-7 prévoient des garanties spécifiques pour les lignes d’avocats, parlementaires et magistrats.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  //   NIVEAU INTERMÉDIAIRE — TECHNIQUES SPÉCIALES (IMSI, SONO, DATA)
  // ==========================================================
  const QuizQuestion(
    category: "Techniques spéciales — Champ d’application",
    question:
        "Les techniques spéciales d’enquête (IMSI-catcher, sonorisation, captation de données) prévues aux articles 706-95-11 à 706-102-5 peuvent être utilisées :",
    options: [
      "Uniquement pour les délits routiers",
      "Si les nécessités de l’enquête relative à une infraction entrant dans le champ de 706-73 ou 706-73-1 l’exigent",
      "Uniquement en cas de flagrant délit",
    ],
    answer:
        "Si les nécessités de l’enquête relative à une infraction entrant dans le champ de 706-73 ou 706-73-1 l’exigent",
    explanation:
        "L’article 706-95-11 pose ce cadre général pour ces techniques très intrusives.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Techniques spéciales — Autorisation",
    question:
        "En enquête, qui autorise le recours aux techniques spéciales d’enquête (IMSI-catcher, sonorisation, captation de données) ?",
    options: [
      "Le juge des libertés et de la détention, à la requête du procureur de la République",
      "Le juge d’instruction",
      "Le préfet de police",
    ],
    answer:
        "Le juge des libertés et de la détention, à la requête du procureur de la République",
    explanation:
        "L’article 706-95-12 confie cette compétence au JLD saisi par le procureur.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Techniques spéciales — Durée",
    question:
        "Pour ces techniques spéciales (enquête), quelle est la durée maximale initiale d’autorisation par le JLD ?",
    options: [
      "15 jours, non renouvelables",
      "1 mois, renouvelable une fois",
      "4 mois, non renouvelables",
    ],
    answer: "1 mois, renouvelable une fois",
    explanation:
        "L’article 706-95-16 prévoit un mois renouvelable une fois en enquête (soit deux mois maximum).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Techniques spéciales — Vie privée",
    question:
        "Que doit-il être fait des séquences ou données sans lien avec les infractions et portant sur la vie privée ?",
    options: [
      "Elles peuvent être librement conservées au dossier",
      "Elles ne peuvent pas être conservées dans le dossier de la procédure",
      "Elles doivent être publiées dans un rapport distinct",
    ],
    answer:
        "Elles ne peuvent pas être conservées dans le dossier de la procédure",
    explanation:
        "L’article 706-95-18 impose la destruction des éléments sans lien avec l’infraction et relatifs à la vie privée.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  //           NIVEAU INTERMÉDIAIRE — ENQUÊTE PRÉLIMINAIRE / INSTRUCTION
  // ==========================================================
  const QuizQuestion(
    category: "Enquête préliminaire — Durée",
    question:
        "En matière de criminalité organisée, quelle est la durée maximale d’une enquête préliminaire avant renouvellement ?",
    options: ["Un an", "Deux ans", "Trois ans"],
    answer: "Trois ans",
    explanation:
        "La durée ne peut excéder 3 ans à compter du premier acte (audition libre, GAV ou perquisition), renouvelable 2 ans sur autorisation écrite du procureur.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Enquête préliminaire — Perquisitions de nuit",
    question:
        "En enquête préliminaire, les perquisitions de nuit dans des locaux non d’habitation pour des infractions de 706-73 ou 706-73-1 sont possibles :",
    options: [
      "Sans aucune autorisation",
      "Si le JLD les autorise par ordonnance motivée à la requête du procureur",
      "Uniquement avec l’accord écrit du suspect",
    ],
    answer:
        "Si le JLD les autorise par ordonnance motivée à la requête du procureur",
    explanation:
        "L’article 706-90 organise ce régime dérogatoire sous contrôle du JLD.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Instruction — Perquisitions de nuit au domicile",
    question:
        "En information judiciaire, qui autorise les perquisitions de nuit au domicile en matière de criminalité organisée ?",
    options: [
      "Le juge d’instruction, par ordonnance motivée",
      "Le JLD à la demande du procureur",
      "Le directeur départemental de la sécurité publique",
    ],
    answer: "Le juge d’instruction, par ordonnance motivée",
    explanation:
        "L’article 706-91 confie au juge d’instruction le pouvoir d’autoriser de telles perquisitions sur commission rogatoire.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Instruction — Techniques spéciales",
    question:
        "En information judiciaire, qui autorise l’emploi des techniques spéciales d’enquête (IMSI-catcher, sonorisation, captation de données) ?",
    options: [
      "Le juge d’instruction, après avis du procureur de la République",
      "Le JLD, saisi par le juge d’instruction",
      "Le procureur de la République seul",
    ],
    answer: "Le juge d’instruction, après avis du procureur de la République",
    explanation:
        "En phase d’instruction, l’autorisation est donnée par le juge d’instruction (art. 706-95-13), après avis du parquet.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Instruction — Durée techniques spéciales",
    question:
        "En information judiciaire, la durée maximale d’autorisation d’une technique spéciale d’enquête (renouvellements compris) ne peut dépasser :",
    options: ["6 mois", "1 an", "2 ans"],
    answer: "2 ans",
    explanation:
        "L’article 706-95-16 prévoit une autorisation initiale de 4 mois, renouvelable, dans la limite totale de 2 ans.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  //           NIVEAU INTERMÉDIAIRE — DOSSIER COFFRE / MESURES
  // ==========================================================
  const QuizQuestion(
    category: "Dossier coffre — Objet",
    question:
        "À quoi sert le « dossier coffre » prévu aux articles 706-104 et 706-104-1 CPP ?",
    options: [
      "À stocker les pièces médicales des gardés à vue",
      "À consigner, dans un dossier distinct, certaines informations sensibles (lieux d’installation, identité des techniciens, etc.)",
      "À archiver les plaintes anciennes",
    ],
    answer:
        "À consigner, dans un dossier distinct, certaines informations sensibles (lieux d’installation, identité des techniciens, etc.)",
    explanation:
        "Le dossier coffre protège des données dont la divulgation mettrait gravement en danger les personnes ayant participé aux techniques spéciales.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Dossier coffre — Conditions",
    question: "Le recours au dossier coffre n’est possible que :",
    options: [
      "Sur décision de l’OPJ",
      "Sur autorisation du JLD, à la requête du procureur, lorsque la divulgation mettrait gravement en danger certaines personnes",
      "Sur simple demande d’un enquêteur",
    ],
    answer:
        "Sur autorisation du JLD, à la requête du procureur, lorsque la divulgation mettrait gravement en danger certaines personnes",
    explanation:
        "L’article 706-104 encadre strictement ce dispositif très particulier.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Mesures conservatoires — Objet",
    question:
        "Quel est l’objectif des mesures conservatoires prévues à l’article 706-103 du CPP en matière de criminalité organisée ?",
    options: [
      "Garantir le paiement des amendes encourues et l’indemnisation des victimes",
      "Sanctionner les enquêteurs fautifs",
      "Saisir systématiquement tous les biens de la famille du mis en examen",
    ],
    answer:
        "Garantir le paiement des amendes encourues et l’indemnisation des victimes",
    explanation:
        "Les mesures conservatoires portent sur les biens du mis en examen pour assurer le paiement et l’éventuelle réparation.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Mesures conservatoires — Compétence",
    question:
        "Qui peut ordonner les mesures conservatoires prévues à l’article 706-103 du CPP ?",
    options: [
      "Le juge d’instruction",
      "Le juge des libertés et de la détention, saisi par le procureur de la République",
      "Le président du tribunal correctionnel",
    ],
    answer:
        "Le juge des libertés et de la détention, saisi par le procureur de la République",
    explanation:
        "Le JLD est compétent sur tout le territoire national pour ces mesures, sur requête du procureur.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  //              NIVEAU DIFFICILE — CAS FIN / FINESSE
  // ==========================================================
  const QuizQuestion(
    category: "Constitutionnel — Vol en bande organisée",
    question:
        "Selon la décision du Conseil constitutionnel du 2 mars 2004, les mesures dérogatoires en matière de procédure pénale pour le vol en bande organisée :",
    options: [
      "S’appliquent automatiquement à tout vol en bande organisée",
      "Ne s’appliquent que si le vol présente des éléments de gravité suffisants (atteinte grave à la sécurité, dignité ou vie des personnes)",
      "Ne s’appliquent jamais",
    ],
    answer:
        "Ne s’appliquent que si le vol présente des éléments de gravité suffisants (atteinte grave à la sécurité, dignité ou vie des personnes)",
    explanation:
        "Le Conseil a posé une réserve : l’autorité judiciaire doit apprécier la gravité pour recourir au régime dérogatoire.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Constitutionnel — Aide au séjour",
    question:
        "Le Conseil constitutionnel a précisé, à propos du délit d’aide au séjour irrégulier en bande organisée, que :",
    options: [
      "Il pouvait viser les organisations humanitaires d’aide aux étrangers",
      "Il ne saurait concerner les organisations humanitaires d’aide aux étrangers",
      "Il ne s’applique pas à la criminalité organisée",
    ],
    answer:
        "Il ne saurait concerner les organisations humanitaires d’aide aux étrangers",
    explanation:
        "Le Conseil a exclu les organisations humanitaires du champ de cette incrimination en matière de criminalité organisée.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Report avocat",
    question:
        "Le report de l’intervention de l’avocat au-delà de la 24e heure (criminalité organisée) est décidé :",
    options: [
      "Par le procureur de la République",
      "Par le juge des libertés et de la détention, à la requête du procureur",
      "Par l’OPJ en charge de l’enquête",
    ],
    answer:
        "Par le juge des libertés et de la détention, à la requête du procureur",
    explanation:
        "Au-delà de la 24e heure, seul le JLD saisi par le parquet peut autoriser le report (art. 706-88).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Enquête préliminaire — Nullité",
    question:
        "En matière de criminalité organisée, tout acte d’enquête concernant une personne après l’expiration des délais de 3 ans (ou 3 + 2 ans) est :",
    options: [
      "Régulier si le parquet est informé",
      "Nul de plein droit",
      "Régulier si la personne est d’accord",
    ],
    answer: "Nul de plein droit",
    explanation:
        "Le texte prévoit la nullité des actes accomplis au-delà des délais maximum de l’enquête préliminaire.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Techniques spéciales — Lieux protégés",
    question:
        "Les techniques spéciales comme la sonorisation ou la captation informatique ne peuvent jamais être mises en œuvre :",
    options: [
      "Dans un commissariat de police",
      "Dans un cabinet d’avocat, au domicile d’un journaliste ou dans une juridiction, sauf cas spécifiques prévus par la loi",
      "Dans un véhicule utilisé par les mis en cause",
    ],
    answer:
        "Dans un cabinet d’avocat, au domicile d’un journaliste ou dans une juridiction, sauf cas spécifiques prévus par la loi",
    explanation:
        "Les articles 56-1, 56-2, 56-3, 56-5 et 100-7 protègent certains lieux et professions (avocats, magistrats, journalistes...).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "IMSI-catcher — Finalité",
    question: "L’IMSI-catcher permet notamment :",
    options: [
      "Uniquement l’écoute des conversations audio",
      "Le recueil des données techniques de connexion et la localisation d’un terminal, voire l’interception de correspondances",
      "Uniquement la géolocalisation par GPS",
    ],
    answer:
        "Le recueil des données techniques de connexion et la localisation d’un terminal, voire l’interception de correspondances",
    explanation:
        "L’article 706-95-20 décrit l’IMSI-catcher comme un dispositif recueillant identifiants, localisation et éventuellement correspondances.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Captation de données — Lieux d’installation",
    question:
        "La captation de données informatiques (706-102-1 et s.) peut être mise en place dans un lieu d’habitation la nuit :",
    options: [
      "Sans aucune autorisation judiciaire",
      "Sur autorisation du JLD, à la requête du procureur de la République",
      "Uniquement par décision de l’OPJ",
    ],
    answer:
        "Sur autorisation du JLD, à la requête du procureur de la République",
    explanation:
        "Pour un lieu d’habitation hors heures légales, l’autorisation doit venir du JLD (706-102-5).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Droit de prévenir",
    question:
        "En matière de terrorisme ou pour une « mule », si la demande de prévenir un proche n’a pas été satisfaite au début de la garde à vue, la personne peut la réitérer :",
    options: [
      "À la 48e heure",
      "À compter de la 96e heure",
      "Jamais, ce droit est définitivement perdu",
    ],
    answer: "À compter de la 96e heure",
    explanation:
        "Les articles 706-88-1 et 706-88-2 permettent une nouvelle demande d’avis à partir de la 96e heure.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Mineurs — Conditions GAV 706-88",
    question:
        "Pour appliquer à un mineur de plus de 16 ans le régime de garde à vue de l’article 706-88 (criminalité organisée), quelles conditions doivent être réunies ?",
    options: [
      "Le mineur doit être récidiviste",
      "Le mineur doit être soupçonné d’une infraction de l’article 706-73 et au moins un majeur doit avoir participé comme auteur ou complice",
      "Le mineur doit être émancipé",
    ],
    answer:
        "Le mineur doit être soupçonné d’une infraction de l’article 706-73 et au moins un majeur doit avoir participé comme auteur ou complice",
    explanation:
        "L’article L. 413-11 CJPM exige ces deux conditions cumulatives.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Généralités — Disparitions inquiétantes",
    question:
        "Quel est l’objectif principal du cadre de l’article 74-1 du C.P.P. ?",
    options: [
      "Rechercher les causes d’un crime déjà constaté",
      "Découvrir la personne disparue",
      "Organiser la garde à vue des proches de la personne disparue",
    ],
    answer: "Découvrir la personne disparue",
    explanation:
        "L’article 74-1 C.P.P. instaure un cadre d’enquête spécifique dont la finalité première est la découverte de la personne disparue, avant même de caractériser une infraction.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Disparitions inquiétantes",
    question:
        "Sur quel type de personnes l’article 74-1 du C.P.P. s’applique-t-il à l’origine ?",
    options: [
      "Uniquement aux majeurs non protégés",
      "Uniquement aux personnes âgées de plus de 70 ans",
      "Aux mineurs et aux majeurs protégés",
    ],
    answer: "Aux mineurs et aux majeurs protégés",
    explanation:
        "Le texte vise d’abord la disparition d’un mineur ou d’un majeur protégé ; il est ensuite étendu aux majeurs présentant un caractère inquiétant ou suspect.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions — Disparition flagrante",
    question:
        "Quelle condition de temporalité est exigée par l’article 74-1 pour la disparition ?",
    options: [
      "Qu’elle ait eu lieu il y a plus d’un mois",
      "Qu’elle vienne d’intervenir ou d’être constatée",
      "Qu’elle soit déclarée depuis au moins 48 heures",
    ],
    answer: "Qu’elle vienne d’intervenir ou d’être constatée",
    explanation:
        "Le texte exige le caractère « flagrant » de la disparition : elle doit venir d’intervenir ou d’être constatée pour justifier ce cadre spécifique.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions — Caractère inquiétant",
    question:
        "Quelles sont les deux conditions générales pour appliquer les articles 74-1 et 80-4 du C.P.P. ?",
    options: [
      "Une disparition ancienne et une plainte de la famille",
      "Une disparition flagrante et un caractère inquiétant",
      "Une disparition volontaire et une fugue avérée",
    ],
    answer: "Une disparition flagrante et un caractère inquiétant",
    explanation:
        "Le fascicule précise que deux conditions doivent être réunies : la disparition doit être flagrante et présenter un caractère inquiétant.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions — Disparitions obligatoirement inquiétantes",
    question:
        "Parmi les propositions suivantes, laquelle correspond à une disparition obligatoirement inquiétante ?",
    options: [
      "Tout majeur non protégé de plus de 30 ans",
      "Toute disparition de mineur",
      "Toute personne ayant déjà fugué plusieurs fois",
    ],
    answer: "Toute disparition de mineur",
    explanation:
        "Les disparitions de mineurs et de majeurs protégés sont toujours considérées comme inquiétantes, même en cas de fugue habituelle.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions — Disparitions obligatoirement inquiétantes",
    question:
        "La disparition de quel type de personne est automatiquement considérée comme inquiétante au sens de l’article 74-1 ?",
    options: [
      "Toute personne sans domicile fixe",
      "Tout majeur protégé (tutelle, curatelle, sauvegarde de justice)",
      "Toute personne bénéficiant du RSA",
    ],
    answer: "Tout majeur protégé (tutelle, curatelle, sauvegarde de justice)",
    explanation:
        "Les majeurs protégés placés sous sauvegarde de justice, tutelle ou curatelle font partie des disparitions obligatoirement inquiétantes.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions — Disparitions inquiétantes par circonstances",
    question:
        "La disparition d’un adulte non protégé peut être jugée inquiétante lorsqu’elle fait craindre :",
    options: [
      "Un simple changement d’emploi",
      "Un projet de déménagement à l’étranger",
      "Un danger pour la personne, lié à son âge, sa santé ou les circonstances",
    ],
    answer:
        "Un danger pour la personne, lié à son âge, sa santé ou les circonstances",
    explanation:
        "Les disparitions inquiétantes en raison des circonstances reposent sur un risque pour la personne disparue (âge, santé, contexte de la disparition).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Acteurs — Procureur de la République",
    question:
        "Qui doit obligatoirement être avisé lorsque les enquêteurs souhaitent utiliser le cadre de l’article 74-1 du C.P.P. ?",
    options: [
      "Le maire de la commune",
      "Le procureur de la République",
      "Le préfet de département",
    ],
    answer: "Le procureur de la République",
    explanation:
        "Ce cadre spécifique ne peut être mis en œuvre que sur instructions du procureur de la République, qui doit donc être immédiatement avisé.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Acteurs — Procureur de la République",
    question:
        "Quel choix n’appartient PAS au procureur de la République lorsqu’il est avisé d’une disparition inquiétante ?",
    options: [
      "Décider une procédure administrative de recherche",
      "Ordonner des investigations dans le cadre de l’article 74-1",
      "Prononcer une peine d’emprisonnement contre les proches",
    ],
    answer: "Prononcer une peine d’emprisonnement contre les proches",
    explanation:
        "Le procureur dirige l’enquête, mais ne prononce pas de peine : seul un juge de jugement peut condamner pénalement.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Acteurs — OPJ / APJ",
    question:
        "Sous l’empire de l’article 74-1, qui peut accomplir les actes des articles 56 à 62 du C.P.P. ?",
    options: [
      "Les seuls agents de police judiciaire, sans contrôle",
      "Les OPJ et, sous leur contrôle, les APJ",
      "Uniquement les gendarmes gradés",
    ],
    answer: "Les OPJ et, sous leur contrôle, les APJ",
    explanation:
        "Comme en flagrance, ce sont les OPJ qui dirigent les actes, assistés le cas échéant par les APJ agissant sous leur contrôle.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Actes — Garde à vue",
    question:
        "Une garde à vue peut-elle être décidée sur le seul fondement de l’article 74-1 C.P.P. ?",
    options: [
      "Oui, dès le début de l’enquête",
      "Oui, uniquement pour les proches du disparu",
      "Non, aucune suspicion de crime ou délit n’est encore caractérisée",
    ],
    answer: "Non, aucune suspicion de crime ou délit n’est encore caractérisée",
    explanation:
        "Le texte précise que le cadre 74-1 ne permet pas de placer en garde à vue, faute de suspicion d’infraction déterminée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Sanctions — Non-signalement",
    question:
        "Quelle est la peine encourue pour une personne qui, connaissant la disparition d’un mineur de moins de 15 ans, n’en informe pas les autorités pour retarder les recherches (art. 434-4-1 C.P.) ?",
    options: [
      "Deux ans d’emprisonnement et 30 000 € d’amende",
      "Six mois d’emprisonnement et 7 500 € d’amende",
      "Cinq ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "Deux ans d’emprisonnement et 30 000 € d’amende",
    explanation:
        "Le rappel du fascicule précise que le non-signalement volontaire d’une telle disparition est puni de 2 ans d’emprisonnement et 30 000 € d’amende.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Suites — Personne retrouvée",
    question:
        "Lorsque la personne disparue (mineur ou majeur protégé) est retrouvée et que les causes ne sont ni criminelles ni délictuelles, l’adresse peut être communiquée aux proches :",
    options: [
      "Uniquement avec l’accord du juge des enfants ou du juge des tutelles",
      "Libre­ment, à toute personne qui en fait la demande",
      "Uniquement au maire de la commune",
    ],
    answer:
        "Uniquement avec l’accord du juge des enfants ou du juge des tutelles",
    explanation:
        "Le texte protège la vie privée du mineur ou du majeur protégé : l’adresse ne peut être révélée sans l’accord du juge compétent.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Suites — Personne retrouvée",
    question:
        "Lorsque la personne disparue est majeure non protégée et retrouvée, à quelle condition son adresse peut-elle être communiquée ?",
    options: [
      "Avec l’accord du maire",
      "Avec l’accord de l’intéressé",
      "Sans aucune condition",
    ],
    answer: "Avec l’accord de l’intéressé",
    explanation:
        "Pour les majeurs non protégés, la communication de l’adresse nécessite leur accord, afin de respecter leur vie privée.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE =====================
  const QuizQuestion(
    category: "Généralités — Nature du cadre 74-1",
    question:
        "Pourquoi dit-on que le cadre de l’article 74-1 du C.P.P. est « spécifique » ?",
    options: [
      "Parce qu’il ne peut être utilisé qu’en matière de terrorisme",
      "Parce qu’il repose sur une disparition inquiétante sans constatation préalable d’infraction",
      "Parce qu’il est réservé à la gendarmerie nationale",
    ],
    answer:
        "Parce qu’il repose sur une disparition inquiétante sans constatation préalable d’infraction",
    explanation:
        "Le cadre est spécifique car il permet des investigations poussées alors qu’aucun crime ou délit n’est encore caractérisé, la base étant la disparition inquiétante.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Généralités — Nature transitoire",
    question:
        "En quoi le cadre de l’article 74-1 du C.P.P. est-il qualifié de « transitoire » ?",
    options: [
      "Il cesse automatiquement après 24 heures",
      "Il doit obligatoirement être remplacé par une enquête administrative",
      "Il prend fin dès que la disparition est élucidée ou qu’un cadre de droit commun s’impose",
    ],
    answer:
        "Il prend fin dès que la disparition est élucidée ou qu’un cadre de droit commun s’impose",
    explanation:
        "Ce cadre est provisoire : il s’arrête soit lorsque la disparition est résolue (volontaire, non inquiétante), soit lorsque des indices de crime ou délit imposent flagrance, préliminaire ou instruction classique.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Conditions — Disparitions inquiétantes par circonstances",
    question:
        "La disparition d’un adulte non protégé traité pour une grave dépression, disparu subitement sans explication, doit être appréciée comme :",
    options: [
      "Une disparition banale relevant du simple choix de vie",
      "Une disparition inquiétante en raison des circonstances et de l’état de santé",
      "Une disparition qui exclut le recours à l’article 74-1",
    ],
    answer:
        "Une disparition inquiétante en raison des circonstances et de l’état de santé",
    explanation:
        "L’état de santé (dépression, tendances suicidaires) et le caractère subit de la disparition font entrer dans la catégorie des disparitions inquiétantes par circonstances.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Acteurs — Procureur de la République",
    question:
        "Le procureur de la République, avisé d’une disparition inquiétante, ne peut PAS :",
    options: [
      "Décider une enquête selon l’article 74-1",
      "Lancer une enquête préliminaire classique",
      "Refuser toute investigation et classer sans suite d’office sans examen",
    ],
    answer:
        "Refuser toute investigation et classer sans suite d’office sans examen",
    explanation:
        "Chaque signalement doit être examiné attentivement ; le procureur peut privilégier la voie administrative, judiciaire 74-1, préliminaire ou information, mais pas ignorer la situation sans appréciation.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Acteurs — Procureur de la République",
    question:
        "Dans quel cas le procureur peut-il déclencher le plan « Alerte enlèvement » ?",
    options: [
      "Lors de toute disparition de majeur",
      "En cas d’enlèvement avéré d’un mineur",
      "Uniquement à la demande expresse de la famille",
    ],
    answer: "En cas d’enlèvement avéré d’un mineur",
    explanation:
        "La circulaire rappelle que, lors de l’enlèvement avéré d’un mineur, le procureur territorialement compétent apprécie l’opportunité de déclencher le plan « Alerte enlèvement ». ",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Acteurs — Juge d’instruction",
    question:
        "Lorsque le procureur requiert l’ouverture d’une information sur le fondement de l’article 80-4 du C.P.P., le juge d’instruction est saisi pour :",
    options: [
      "Rechercher les causes de la disparition",
      "Poursuivre immédiatement le ou les auteurs mis en cause",
      "Statuer sur la culpabilité de la personne disparue",
    ],
    answer: "Rechercher les causes de la disparition",
    explanation:
        "L’information ouverte sur le fondement des articles 74-1 et 80-4 a pour seul objet la recherche des causes de la disparition, sans saisine globale des faits.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Acteurs — Juge d’instruction",
    question:
        "L’information ouverte sur le fondement des articles 74-1 et 80-4 du C.P.P. a pour particularité :",
    options: [
      "De mettre automatiquement en mouvement l’action publique",
      "De ne pas mettre en mouvement l’action publique",
      "D’interdire toute constitution de partie civile",
    ],
    answer: "De ne pas mettre en mouvement l’action publique",
    explanation:
        "Cette information est exorbitante du droit commun : elle vise uniquement à rechercher les causes de la disparition et ne déclenche pas ipso facto l’action publique.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Acteurs — Famille / partie civile",
    question:
        "Dans le cadre de l’article 80-4 du C.P.P., comment la famille de la personne disparue peut-elle intervenir dans la procédure ?",
    options: [
      "En provoquant directement l’ouverture de l’information en recherche des causes",
      "En se constituant partie civile à titre incident dans l’information ouverte par le parquet",
      "En imposant au parquet l’ouverture d’une information par simple courrier",
    ],
    answer:
        "En se constituant partie civile à titre incident dans l’information ouverte par le parquet",
    explanation:
        "La famille ne peut pas provoquer elle-même l’ouverture de l’information « recherches des causes de la disparition », mais peut se constituer partie civile une fois celle-ci ouverte.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Acteurs — OPJ / APJ",
    question:
        "Que doit faire l’OPJ ou l’APJ lorsqu’une disparition lui est signalée et qu’il la juge inquiétante ?",
    options: [
      "Attendre 24 heures avant de saisir le parquet",
      "Prévenir immédiatement le procureur de la République pour décider du cadre des recherches",
      "Décider seul d’ouvrir une information judiciaire",
    ],
    answer:
        "Prévenir immédiatement le procureur de la République pour décider du cadre des recherches",
    explanation:
        "L’OPJ ou l’APJ apprécie le caractère inquiétant, puis en avise sans délai le procureur, seul compétent pour choisir le cadre (administratif, 74-1, préliminaire ou information).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Actes — Pouvoirs de l’OPJ (art. 56 à 62)",
    question:
        "Dans le cadre de l’article 74-1, quels types d’actes l’OPJ peut-il accomplir sur instructions du procureur de la République ?",
    options: [
      "Uniquement entendre les proches de la victime",
      "Tous les actes prévus aux articles 56 à 62 du C.P.P. (perquisitions, saisies, réquisitions, convocations…) sans garde à vue",
      "Uniquement des contrôles d’identité",
    ],
    answer:
        "Tous les actes prévus aux articles 56 à 62 du C.P.P. (perquisitions, saisies, réquisitions, convocations…) sans garde à vue",
    explanation:
        "Le fascicule précise que l’OPJ peut user de l’ensemble des pouvoirs de l’enquête de flagrance prévus aux articles 56 à 62, à l’exception de la garde à vue.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Actes — Durée du cadre 74-1",
    question:
        "Combien de temps les investigations peuvent-elles être menées sous le régime de l’article 74-1 avant de basculer éventuellement vers un autre cadre ?",
    options: [
      "48 heures",
      "Huit jours à compter des instructions du procureur",
      "Un mois renouvelable",
    ],
    answer: "Huit jours à compter des instructions du procureur",
    explanation:
        "À l’issue d’un délai de 8 jours, les recherches peuvent se poursuivre dans les formes de l’enquête préliminaire, sauf ouverture d’une information.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Actes — Suite après 8 jours",
    question:
        "À l’issue des huit jours d’enquête sous article 74-1, si la disparition demeure inquiétante, le procureur peut :",
    options: [
      "Imposer la clôture de toute investigation",
      "Poursuivre les recherches en enquête préliminaire ou requérir l’ouverture d’une information",
      "Prononcer lui-même une peine contre la famille",
    ],
    answer:
        "Poursuivre les recherches en enquête préliminaire ou requérir l’ouverture d’une information",
    explanation:
        "Le texte prévoit explicitement la poursuite sous forme d’enquête préliminaire ou l’ouverture d’une information de recherche des causes.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Actes — Information 80-4",
    question:
        "Dans le cadre d’une information « recherche des causes de la disparition », quelle est la durée maximale des interceptions téléphoniques possibles ?",
    options: [
      "Deux mois renouvelables",
      "Un mois non renouvelable",
      "Six mois non renouvelables",
    ],
    answer: "Deux mois renouvelables",
    explanation:
        "Le texte précise que les interceptions dans ce cadre ne peuvent excéder deux mois, renouvelables une fois, sous contrôle du juge d’instruction.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Suites — Personne non retrouvée",
    question:
        "Si la personne disparue n’est pas retrouvée, quelle option ne figure PAS parmi les suites possibles mentionnées par le texte ?",
    options: [
      "Requérir une information pour recherche des causes de la disparition",
      "Poursuivre l’information déjà ouverte",
      "Clore définitivement le dossier sans suite obligatoire",
    ],
    answer: "Clore définitivement le dossier sans suite obligatoire",
    explanation:
        "Le texte prévoit soit l’ouverture, soit la poursuite d’une information, soit la poursuite des investigations en préliminaire, mais pas une clôture automatique sans suite.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Suites — Caractère criminel ou délictuel",
    question:
        "Lorsque l’enquête diligentée au titre de l’article 74-1 permet d’établir l’existence d’une infraction à l’origine de la disparition, le procureur peut :",
    options: [
      "Revenir au cadre administratif de recherche de personnes",
      "Poursuivre en flagrant délit ou en enquête préliminaire, ou ouvrir une information classique",
      "Clore l’enquête car le cadre 74-1 est alors épuisé",
    ],
    answer:
        "Poursuivre en flagrant délit ou en enquête préliminaire, ou ouvrir une information classique",
    explanation:
        "Dès qu’un crime ou un délit est caractérisé, on bascule vers les cadres de droit commun : flagrance, préliminaire ou instruction pénale.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Exemples pratiques — Cas de mineur fugueur",
    question:
        "Un mineur placé en foyer, connu pour des fugues répétées, ne rentre pas à l’heure et reste introuvable. Comment doit être qualifiée cette disparition ?",
    options: [
      "Elle n’est pas inquiétante puisqu’il fugue souvent",
      "Elle est obligatoirement inquiétante au sens de l’article 74-1",
      "Elle relève seulement d’une procédure administrative de fugue",
    ],
    answer: "Elle est obligatoirement inquiétante au sens de l’article 74-1",
    explanation:
        "Le texte précise que toute disparition de mineur est inquiétante, même si l’intéressé a l’habitude de fuguer.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Exemples pratiques — Adulte en bonne santé",
    question:
        "Un adulte de 30 ans, sans antécédent médical ni difficulté particulière, quitte son domicile après une dispute et ne donne plus de nouvelles depuis 3 heures. Sans élément supplémentaire, comment apprécier cette situation ?",
    options: [
      "Comme automatiquement inquiétante au sens du texte",
      "Comme relevant d’abord d’une appréciation prudente, pouvant ne pas justifier immédiatement le recours à l’article 74-1",
      "Comme un enlèvement certain",
    ],
    answer:
        "Comme relevant d’abord d’une appréciation prudente, pouvant ne pas justifier immédiatement le recours à l’article 74-1",
    explanation:
        "L’article 74-1 repose sur un caractère inquiétant : en l’absence d’éléments sur l’âge, la santé ou les circonstances, le parquet peut privilégier d’abord une appréciation moins intrusive.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Exemples pratiques — Personne malade",
    question:
        "Une personne âgée souffrant de la maladie d’Alzheimer quitte son domicile sans prévenir et ne revient pas. Cette disparition doit être :",
    options: [
      "Considérée comme inquiétante en raison de l’âge et de l’état de santé",
      "Considérée comme une disparition volontaire sans danger",
      "Traitée uniquement par la famille, sans intervention judiciaire",
    ],
    answer:
        "Considérée comme inquiétante en raison de l’âge et de l’état de santé",
    explanation:
        "L’état de santé et la vulnérabilité de la personne justifient le recours au cadre des disparitions inquiétantes.",
    difficulty: "Intermédiaire",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  const QuizQuestion(
    category: "Analyse juridique — Articulation 74-1 / préliminaire",
    question:
        "Dans quel cas le procureur peut-il décider de ne pas appliquer l’article 74-1, mais de recourir directement à l’enquête préliminaire ?",
    options: [
      "Lorsque la disparition n’est ni flagrante ni inquiétante mais nécessite des vérifications",
      "Lorsque la disparition concerne automatiquement un mineur",
      "Lorsque la famille exige expressément l’application de l’article 74-1",
    ],
    answer:
        "Lorsque la disparition n’est ni flagrante ni inquiétante mais nécessite des vérifications",
    explanation:
        "Le parquet conserve la possibilité d’ordonner une enquête préliminaire classique lorsque les conditions spécifiques de l’article 74-1 ne sont pas réunies.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Analyse juridique — Nature de l’information 80-4",
    question:
        "Pourquoi l’information ouverte sur le fondement de l’article 80-4 du C.P.P. est-elle qualifiée d’« exorbitante du droit commun » ?",
    options: [
      "Parce qu’elle permet de condamner sans jugement",
      "Parce que le juge d’instruction n’est pas saisi de l’intégralité des faits et n’a pour objet que la recherche des causes de la disparition",
      "Parce qu’elle suspend les droits de la défense",
    ],
    answer:
        "Parce que le juge d’instruction n’est pas saisi de l’intégralité des faits et n’a pour objet que la recherche des causes de la disparition",
    explanation:
        "Contrairement à une information classique, le juge n’est saisi que d’une mission limitée : comprendre les causes de la disparition, sans mise en mouvement automatique de l’action publique.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Analyse juridique — Garde à vue et découverte d’infraction",
    question:
        "Dans le cadre d’une information ouverte pour recherche des causes de la disparition, une garde à vue peut être décidée :",
    options: [
      "Envers toute personne proche de la victime, par précaution",
      "Uniquement s’il existe une ou plusieurs raisons plausibles de soupçonner une personne d’avoir commis une infraction révélée par l’enquête",
      "Jamais, car la garde à vue est exclue de ce cadre",
    ],
    answer:
        "Uniquement s’il existe une ou plusieurs raisons plausibles de soupçonner une personne d’avoir commis une infraction révélée par l’enquête",
    explanation:
        "Le texte précise que la garde à vue devient possible lorsque, au cours des investigations sur les causes de la disparition, des éléments laissent soupçonner la commission d’une infraction.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Techniques spéciales — Réquisitions et informatique",
    question:
        "Dans le cadre d’une information pour recherche des causes de la disparition, quelles opérations informatiques l’OPJ commis par le juge peut-il réaliser ?",
    options: [
      "Uniquement consulter les réseaux sociaux de la victime sans formalités",
      "Accéder, au cours d’une perquisition, à des données informatiques stockées sur des serveurs distants et requérir toute personne pour obtenir les moyens de protection",
      "Installer librement des logiciels espions sans autorisation judiciaire",
    ],
    answer:
        "Accéder, au cours d’une perquisition, à des données informatiques stockées sur des serveurs distants et requérir toute personne pour obtenir les moyens de protection",
    explanation:
        "Le fascicule rappelle les pouvoirs prévus aux articles 97-1 et 57-1 C.P.P. : accès aux données distantes, réquisition de toute personne connaissant les mesures de protection, dans le cadre des perquisitions autorisées.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Techniques spéciales — Réquisitions opérateurs",
    question:
        "Quel est l’objet principal des réquisitions aux opérateurs de télécommunications mentionnées dans le cadre des disparitions inquiétantes ?",
    options: [
      "Demander aux opérateurs de couper la ligne de la personne disparue",
      "Assurer la préservation du contenu des informations consultées et la mise en place éventuelle d’un dispositif d’interception",
      "Obtenir les relevés bancaires de la personne disparue",
    ],
    answer:
        "Assurer la préservation du contenu des informations consultées et la mise en place éventuelle d’un dispositif d’interception",
    explanation:
        "Les articles 99-4, 60-2 et 100-3 à 100-5 C.P.P. visent la préservation des données, l’installation d’interceptions et la transcription des correspondances utiles à la manifestation de la vérité.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Interceptions — Juges compétents",
    question:
        "Dans le cadre de l’article 74-1 (sans information), qui autorise les interceptions de correspondances par la voie des télécommunications ?",
    options: [
      "Le procureur de la République seul",
      "Le juge d’instruction saisi d’office",
      "Le juge des libertés et de la détention, à la demande du procureur",
    ],
    answer:
        "Le juge des libertés et de la détention, à la demande du procureur",
    explanation:
        "Le dispositif renvoie aux articles 100 et suivants : c’est le JLD qui autorise, sur requête du procureur, les interceptions et fixe leur durée.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Interceptions — Lignes protégées",
    question:
        "Sous peine de nullité, quelles lignes téléphoniques ne peuvent être interceptées qu’après avis de leur autorité supérieure ?",
    options: [
      "Celles des fonctionnaires de police",
      "Celles des députés, sénateurs, avocats et magistrats",
      "Celles des délégués syndicaux",
    ],
    answer: "Celles des députés, sénateurs, avocats et magistrats",
    explanation:
        "Le rappel du fascicule vise les règles générales : les lignes dépendant des cabinets ou domiciles de parlementaires, avocats ou magistrats sont protégées et nécessitent un avis préalable.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Suites — Communication du dossier",
    question:
        "Pourquoi le droit à la communication du dossier prévu à l’article 114 du C.P.P. est-il restreint lorsque la personne disparue (mineur ou majeur protégé) est retrouvée ?",
    options: [
      "Parce que la procédure devient secrète à vie",
      "Parce que la communication ne peut se faire qu’en respectant les limitations destinées à protéger la vie privée ou la sécurité de la personne",
      "Parce que le dossier est automatiquement détruit",
    ],
    answer:
        "Parce que la communication ne peut se faire qu’en respectant les limitations destinées à protéger la vie privée ou la sécurité de la personne",
    explanation:
        "Le texte prévoit expressément que le droit de communication du dossier s’exerce sous réserve des restrictions visant à protéger la vie privée ou la sécurité du mineur ou du majeur protégé retrouvé.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Comparaison — Article 74-1 vs recherche administrative",
    question:
        "En quoi le recours à l’article 74-1 du C.P.P. permet-il des investigations plus poussées que la simple procédure administrative de recherche de personnes ?",
    options: [
      "Il permet uniquement de diffuser une affiche de recherche",
      "Il autorise les actes d’enquête de flagrance (perquisitions, saisies, réquisitions, auditions forcées…) sous contrôle du procureur",
      "Il permet de condamner directement la personne disparue pour fugue",
    ],
    answer:
        "Il autorise les actes d’enquête de flagrance (perquisitions, saisies, réquisitions, auditions forcées…) sous contrôle du procureur",
    explanation:
        "La procédure administrative prévue par la loi du 21/01/1995 est moins intrusive ; l’article 74-1 ouvre la voie à de véritables actes d’enquête judiciaire.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Disparition volontaire révélée",
    question:
        "Une enquête 74-1 est ouverte pour un majeur protégé. Deux jours plus tard, il est retrouvé sain et sauf, ayant quitté volontairement son domicile pour rejoindre un proche. Quelle conséquence procédurale en découle ?",
    options: [
      "Le cadre 74-1 prend fin, la disparition n’ayant plus de caractère inquiétant",
      "L’enquête doit se poursuivre obligatoirement 8 jours",
      "Le parquet doit ouvrir une information pénale",
    ],
    answer:
        "Le cadre 74-1 prend fin, la disparition n’ayant plus de caractère inquiétant",
    explanation:
        "Le caractère transitoire du cadre fait qu’il cesse dès que la disparition est élucidée et ne présente plus de risque pour la personne.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Suspicion de crime",
    question:
        "Au cours d’une enquête 74-1, les indices convergent vers un possible homicide commis sur la personne disparue. Quelle est la réaction juridiquement adaptée du parquet ?",
    options: [
      "Maintenir le cadre 74-1 jusqu’au terme des 8 jours",
      "Basculer vers une enquête de flagrance ou préliminaire pour homicide, ou ouvrir une information pénale classique",
      "Clore la procédure et laisser la famille agir seule",
    ],
    answer:
        "Basculer vers une enquête de flagrance ou préliminaire pour homicide, ou ouvrir une information pénale classique",
    explanation:
        "Dès qu’un crime est suspecté, le cadre spécifique 74-1 doit céder la place aux procédures de droit commun adaptées (flagrance, préliminaire, instruction).",
    difficulty: "Difficile",
  ),
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
  const QuizQuestion(
    category: "Généralités — Cadre juridique",
    question:
        "Dans quel texte est prévue la procédure de recherche des causes de la mort de cause inconnue ou suspecte ?",
    options: [
      "Dans l’article 56 du Code de procédure pénale",
      "Dans l’article 74 du Code de procédure pénale",
      "Dans l’article 78 du Code civil",
    ],
    answer: "Dans l’article 74 du Code de procédure pénale",
    explanation:
        "L’article 74 du Code de procédure pénale prévoit spécifiquement la procédure applicable en cas de découverte d’un cadavre dont la cause de la mort est inconnue ou suspecte.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Finalité",
    question:
        "Quel est l’objectif principal de l’enquête prévue par l’article 74 du Code de procédure pénale ?",
    options: [
      "Rechercher immédiatement l’auteur de l’infraction",
      "Rechercher les causes de la mort",
      "Préparer le jugement devant le tribunal correctionnel",
    ],
    answer: "Rechercher les causes de la mort",
    explanation:
        "L’enquête prévue par l’article 74 du Code de procédure pénale a pour finalité première de déterminer la cause de la mort, afin de savoir s’il y a ou non infraction.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions d’application",
    question:
        "Quelle est la première condition pour appliquer l’article 74 du Code de procédure pénale ?",
    options: [
      "La présence d’un témoin direct du décès",
      "La découverte d’un cadavre",
      "La découverte d’objets suspects à proximité du lieu",
    ],
    answer: "La découverte d’un cadavre",
    explanation:
        "L’article 74 du Code de procédure pénale s’applique d’abord en cas de découverte d’un cadavre, qu’il s’agisse ou non d’une mort violente.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions d’application",
    question:
        "Outre la découverte d’un cadavre, quelle autre condition est exigée pour l’application de l’article 74 du Code de procédure pénale ?",
    options: [
      "La mort doit avoir eu lieu sur la voie publique uniquement",
      "La cause de la mort doit être inconnue ou suspecte",
      "La famille doit avoir demandé une enquête",
    ],
    answer: "La cause de la mort doit être inconnue ou suspecte",
    explanation:
        "Deux conditions sont requises : la découverte d’un cadavre et une cause de la mort inconnue ou suspecte.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Découverte de cadavre",
    question:
        "Que signifie l’expression « découverte de cadavre » au sens de l’article 74 du Code de procédure pénale ?",
    options: [
      "Un cadavre qui était caché ou dissimulé",
      "L’existence matérielle d’un corps humain, qu’il ait été caché ou non",
      "Uniquement un corps découvert dans un lieu public",
    ],
    answer:
        "L’existence matérielle d’un corps humain, qu’il ait été caché ou non",
    explanation:
        "L’expression ne suppose pas que le corps ait été dissimulé : elle vise le fait de constater l’existence d’un corps, les causes de la mort restant inconnues ou suspectes.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Typologie des morts",
    question:
        "Parmi les propositions suivantes, laquelle NE fait PAS partie des trois catégories de décès distinguées par la loi ?",
    options: [
      "Mort dont la cause n’est pas criminelle ou délictuelle",
      "Mort ayant une origine criminelle ou délictuelle",
      "Mort dont la cause est exclusivement civile",
    ],
    answer: "Mort dont la cause est exclusivement civile",
    explanation:
        "La loi distingue la mort dont la cause n’est pas criminelle ou délictuelle, la mort ayant une origine criminelle ou délictuelle, et la mort de cause inconnue ou suspecte.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Mort naturelle",
    question:
        "La mort naturelle, au sens de l’article 78 du Code civil, trouve son origine :",
    options: [
      "Dans une cause interne, comme une maladie ou la vieillesse",
      "Dans un accident de la route",
      "Dans un homicide volontaire",
    ],
    answer: "Dans une cause interne, comme une maladie ou la vieillesse",
    explanation:
        "La mort naturelle résulte d’une cause interne, par exemple une pathologie ou la sénescence, et ne relève pas de la police judiciaire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Mort violente non pénale",
    question:
        "La mort violente non criminelle ni délictuelle recouvre notamment :",
    options: [
      "Les homicides volontaires uniquement",
      "Les morts par blessures, intoxication ou brûlures d’origine accidentelle ou suicidaire",
      "Uniquement les catastrophes naturelles",
    ],
    answer:
        "Les morts par blessures, intoxication ou brûlures d’origine accidentelle ou suicidaire",
    explanation:
        "Il s’agit d’une mort violente dont la cause n’est ni criminelle ni délictuelle, pouvant résulter d’un accident ou d’un suicide (non provoqué).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Procureur de la République",
    question:
        "Qui doit être informé immédiatement par l’officier ou l’agent de police judiciaire en cas de découverte d’un cadavre de cause inconnue ou suspecte ?",
    options: [
      "Le maire de la commune",
      "Le procureur de la République",
      "Le juge d’instruction",
    ],
    answer: "Le procureur de la République",
    explanation:
        "L’article 74 du Code de procédure pénale impose d’aviser immédiatement le procureur de la République.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Premières constatations",
    question:
        "Que doit faire l’officier de police judiciaire, ou l’agent agissant sous son contrôle, après avoir été avisé d’une mort suspecte ?",
    options: [
      "Attendre l’arrivée du juge d’instruction pour commencer les opérations",
      "Se transporter sans délai sur les lieux et procéder aux premières constatations",
      "Faire d’abord auditionner les voisins avant de se déplacer",
    ],
    answer:
        "Se transporter sans délai sur les lieux et procéder aux premières constatations",
    explanation:
        "L’article 74 du Code de procédure pénale prévoit expressément que l’enquêteur se transporte sans délai sur les lieux pour procéder aux premières constatations.",
    difficulty: "Facile",
  ),

  // =========================================================
  //                   NIVEAU INTERMÉDIAIRE
  // =========================================================
  const QuizQuestion(
    category: "Procédure — Rôle du procureur",
    question:
        "Selon l’article 74 du Code de procédure pénale, que peut faire le procureur de la République après avoir été informé d’une mort suspecte ?",
    options: [
      "Se rendre sur place ou déléguer un officier de police judiciaire pour y procéder",
      "Saisir directement la cour d’assises",
      "Saisir automatiquement le juge des libertés et de la détention",
    ],
    answer:
        "Se rendre sur place ou déléguer un officier de police judiciaire pour y procéder",
    explanation:
        "Le procureur de la République peut se rendre sur place, assisté de personnes qualifiées, ou déléguer un officier de police judiciaire aux mêmes fins.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Procédure — Enquête art. 74",
    question:
        "Dans le cadre de l’enquête pour recherche des causes de la mort (article 74 du Code de procédure pénale), quels actes peuvent être réalisés sur instructions du procureur de la République ?",
    options: [
      "Uniquement des constatations sur place et des auditions libres",
      "Les actes prévus aux articles 56 à 62 du Code de procédure pénale",
      "Uniquement des perquisitions au domicile du défunt",
    ],
    answer: "Les actes prévus aux articles 56 à 62 du Code de procédure pénale",
    explanation:
        "L’article 74 du Code de procédure pénale précise qu’il peut être procédé aux actes prévus aux articles 56 à 62, dans les conditions posées par ces textes.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Procédure — Durée",
    question:
        "À l’issue d’un délai de huit jours à compter des instructions du procureur de la République, que peuvent devenir les investigations menées au titre de l’article 74 du Code de procédure pénale ?",
    options: [
      "Elles deviennent automatiquement nulles",
      "Elles peuvent se poursuivre dans les formes de l’enquête préliminaire",
      "Elles doivent impérativement cesser",
    ],
    answer:
        "Elles peuvent se poursuivre dans les formes de l’enquête préliminaire",
    explanation:
        "Le texte prévoit explicitement qu’après huit jours, les investigations peuvent se poursuivre dans le cadre de l’enquête préliminaire.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Information judiciaire",
    question:
        "Dans le cadre de la mort de cause inconnue ou suspecte, qui peut requérir l’ouverture d’une information pour recherche des causes de la mort ?",
    options: [
      "La famille du défunt directement, par simple courrier",
      "Le procureur de la République",
      "L’officier de police judiciaire en charge de l’enquête",
    ],
    answer: "Le procureur de la République",
    explanation:
        "L’ouverture d’une information pour recherche des causes de la mort relève de la seule initiative du procureur de la République.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Partie civile — Article 80-4",
    question:
        "Selon l’article 80-4 du Code de procédure pénale, les membres de la famille ou les proches de la personne décédée peuvent :",
    options: [
      "Provoquer directement l’ouverture d’une information pour recherche des causes de la mort",
      "Se constituer partie civile à titre incident dans l’information déjà ouverte",
      "Saisir directement la chambre de l’instruction pour imposer une autopsie",
    ],
    answer:
        "Se constituer partie civile à titre incident dans l’information déjà ouverte",
    explanation:
        "L’article 80-4 permet à la famille ou aux proches de se constituer partie civile à titre incident, mais l’ouverture de l’information appartient au procureur de la République.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Rôle de la famille",
    question:
        "En cas d’inaction du parquet concernant une mort suspecte, que peut faire la famille du défunt ?",
    options: [
      "Saisir directement le juge d’instruction par lettre simple",
      "Déposer plainte avec constitution de partie civile en invoquant l’existence d’une infraction",
      "Saisir le maire pour exiger une autopsie",
    ],
    answer:
        "Déposer plainte avec constitution de partie civile en invoquant l’existence d’une infraction",
    explanation:
        "Si le parquet ne agit pas, la famille peut recourir à la plainte avec constitution de partie civile, en se plaçant alors sur le terrain d’une infraction pénale.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Actes — Autopsie",
    question:
        "Dans le cadre de l’article 74 du Code de procédure pénale, l’autopsie est encadrée par :",
    options: [
      "Les articles 230-28 à 230-31 du Code de procédure pénale",
      "Uniquement par le Code civil",
      "Uniquement par une circulaire du ministère de l’Intérieur",
    ],
    answer: "Les articles 230-28 à 230-31 du Code de procédure pénale",
    explanation:
        "Les dispositions particulières relatives à l’autopsie sont prévues par les articles 230-28 à 230-31 du Code de procédure pénale.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Actes — Autopsie",
    question:
        "À qui la réquisition d’autopsie peut-elle être adressée dans le cadre de l’enquête pour recherche des causes de la mort ?",
    options: [
      "À tout médecin inscrit à l’Ordre, sans autre condition",
      "À un praticien titulaire d’un diplôme ou d’un titre justifiant d’une formation ou d’une expérience en médecine légale",
      "À un étudiant en médecine de troisième année",
    ],
    answer:
        "À un praticien titulaire d’un diplôme ou d’un titre justifiant d’une formation ou d’une expérience en médecine légale",
    explanation:
        "L’article 230-28 du Code de procédure pénale impose que la réquisition soit adressée à un praticien compétent en médecine légale.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Actes — Réquisitions",
    question:
        "Dans le cadre de l’article 74 du Code de procédure pénale, les réquisitions du procureur de la République concernent notamment :",
    options: [
      "Des personnes qualifiées, telles que médecins ou autres experts techniques",
      "Uniquement des policiers habilités",
      "Uniquement la famille du défunt",
    ],
    answer:
        "Des personnes qualifiées, telles que médecins ou autres experts techniques",
    explanation:
        "Le procureur peut faire requérir par l’officier ou l’agent de police judiciaire toute personne qualifiée pour apprécier les circonstances du décès.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Actes — Réquisitions",
    question:
        "Quelle est l’obligation des personnes requises (non inscrites sur les listes d’experts) selon l’article 74 du Code de procédure pénale ?",
    options: [
      "Elles prêtent serment par écrit d’apporter leur concours à la justice en leur honneur et en leur conscience",
      "Elles doivent seulement confirmer oralement leur accord",
      "Elles peuvent refuser sans conséquence",
    ],
    answer:
        "Elles prêtent serment par écrit d’apporter leur concours à la justice en leur honneur et en leur conscience",
    explanation:
        "Les personnes non inscrites sur les listes d’experts prêtent serment par écrit avant d’intervenir.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Actes — Limites",
    question:
        "Dans le cadre de l’enquête de l’article 74 du Code de procédure pénale, l’officier de police judiciaire :",
    options: [
      "Peut placer une personne en garde à vue comme en enquête de flagrance",
      "Ne dispose pas de la possibilité de placer une personne en garde à vue",
      "Peut délivrer un mandat de recherche",
    ],
    answer:
        "Ne dispose pas de la possibilité de placer une personne en garde à vue",
    explanation:
        "Le texte précise que dans ce cadre spécifique, l’officier de police judiciaire ne peut pas placer en garde à vue ni bénéficier de mandat de recherche.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Suites de l’enquête",
    question:
        "Lorsque l’enquête de l’article 74 du Code de procédure pénale établit une mort naturelle ou une mort violente sans responsabilité d’un tiers, que peut faire le procureur de la République ?",
    options: [
      "Classer la procédure et autoriser l’inhumation",
      "Saisir automatiquement la cour d’assises",
      "Ouvrir systématiquement une information judiciaire",
    ],
    answer: "Classer la procédure et autoriser l’inhumation",
    explanation:
        "En l’absence de responsabilité d’un tiers, la procédure est classée et l’inhumation autorisée par le procureur de la République.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Suites de l’enquête",
    question:
        "Si des doutes subsistent sur les causes de la mort après l’enquête de l’article 74 du Code de procédure pénale, le procureur de la République peut :",
    options: [
      "Uniquement classer sans suite",
      "Soit requérir une information, soit faire poursuivre l’enquête en préliminaire après huit jours",
      "Saisir directement le tribunal correctionnel",
    ],
    answer:
        "Soit requérir une information, soit faire poursuivre l’enquête en préliminaire après huit jours",
    explanation:
        "Le procureur peut requérir une information pour recherche des causes de la mort ou prolonger les investigations en enquête préliminaire.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Suites de l’enquête",
    question:
        "Si l’enquête permet d’établir le caractère criminel ou délictuel de l’événement, le procureur de la République peut notamment :",
    options: [
      "Autoriser la poursuite des investigations selon le mode du flagrant délit ou de l’enquête préliminaire, ou ouvrir une information",
      "Uniquement classer l’affaire pour éviter la médiatisation",
      "Transférer automatiquement le dossier au maire",
    ],
    answer:
        "Autoriser la poursuite des investigations selon le mode du flagrant délit ou de l’enquête préliminaire, ou ouvrir une information",
    explanation:
        "Une fois la nature infractionnelle établie, le parquet choisit le cadre procédural classique : flagrance, préliminaire ou information judiciaire.",
    difficulty: "Intermédiaire",
  ),

  // =========================================================
  //                    NIVEAU DIFFICILE
  // =========================================================
  const QuizQuestion(
    category: "Cas pratique — Découverte de corps",
    question:
        "Vous êtes officier de police judiciaire. On vous signale la découverte d’un corps dans un appartement, sans trace évidente de lutte, mais dans un contexte ambigu. Quelle démarche est conforme à l’article 74 du Code de procédure pénale ?",
    options: [
      "Informer immédiatement le procureur de la République, vous transporter sans délai sur les lieux et procéder aux premières constatations",
      "Attendre le rapport écrit du médecin traitant avant de vous déplacer",
      "Vous rendre sur les lieux seulement après accord du juge d’instruction",
    ],
    answer:
        "Informer immédiatement le procureur de la République, vous transporter sans délai sur les lieux et procéder aux premières constatations",
    explanation:
        "Dès la découverte d’un cadavre de cause inconnue ou suspecte, l’officier de police judiciaire avise le procureur, se transporte sans délai sur les lieux et réalise les premières constatations.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Mort violente non pénale",
    question:
        "Une personne décède à la suite d’une chute d’échelle sur un chantier, sans élément laissant supposer une infraction. Comment qualifier juridiquement la mort ?",
    options: [
      "Mort naturelle au sens de l’article 78 du Code civil",
      "Mort violente dont la cause n’est ni criminelle ni délictuelle",
      "Mort de cause inconnue nécessitant systématiquement l’application de l’article 74 du Code de procédure pénale",
    ],
    answer: "Mort violente dont la cause n’est ni criminelle ni délictuelle",
    explanation:
        "Il s’agit d’une mort violente (chute, blessure) mais sans élément d’infraction, relevant de la mort violente non criminelle ni délictuelle.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Autopsie",
    question:
        "Une autopsie a été ordonnée dans le cadre de l’article 74 du Code de procédure pénale. Quelle affirmation est exacte ?",
    options: [
      "Les enquêteurs doivent obligatoirement être présents pour placer eux-mêmes les prélèvements sous scellés",
      "Le médecin légiste peut lui-même placer les prélèvements sous scellés, conformément à sa mission",
      "L’autopsie ne peut être menée que si la famille y consent expressément",
    ],
    answer:
        "Le médecin légiste peut lui-même placer les prélèvements sous scellés, conformément à sa mission",
    explanation:
        "Les textes prévoient que le praticien peut réaliser les prélèvements et les placer sous scellés. La présence des enquêteurs n’est pas toujours indispensable.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Garde à vue — Limites art. 74",
    question:
        "Dans le cadre strict de l’enquête pour recherche des causes de la mort (article 74 du Code de procédure pénale), quelle est la position concernant la garde à vue ?",
    options: [
      "L’officier de police judiciaire peut placer en garde à vue comme en flagrance",
      "La garde à vue n’est pas possible dans ce cadre, faute de cadre infractionnel déterminé",
      "La garde à vue est possible uniquement sur décision du procureur général",
    ],
    answer:
        "La garde à vue n’est pas possible dans ce cadre, faute de cadre infractionnel déterminé",
    explanation:
        "L’enquête de l’article 74 du Code de procédure pénale ne repose pas encore sur la constatation d’une infraction déterminée, ce qui exclut la garde à vue à ce stade.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Suites — Ouverture d’information",
    question:
        "Après une enquête de l’article 74 du Code de procédure pénale, des doutes sérieux subsistent. Le procureur de la République requiert une information pour recherche des causes de la mort. Quelle conséquence majeure en découle ?",
    options: [
      "Le juge d’instruction est saisi uniquement de la recherche des causes de la mort et ne met pas en mouvement l’action publique",
      "L’action publique est automatiquement mise en mouvement contre X",
      "L’officier de police judiciaire perd toute compétence sur le dossier",
    ],
    answer:
        "Le juge d’instruction est saisi uniquement de la recherche des causes de la mort et ne met pas en mouvement l’action publique",
    explanation:
        "L’information pour recherche des causes de la mort est exorbitante du droit commun : elle ne met pas en mouvement l’action publique et a pour seul but la détermination de la cause du décès.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Juge d’instruction — Pouvoirs",
    question:
        "Dans le cadre d’une information pour recherche des causes de la mort (articles 74 et 80-4 du Code de procédure pénale), le juge d’instruction dispose :",
    options: [
      "Des pouvoirs de l’instruction préparatoire, avec la possibilité d’ordonner notamment les perquisitions, saisies, expertises et interceptions dans des limites temporelles",
      "Uniquement du pouvoir de lire le dossier de police",
      "Uniquement du pouvoir de délivrer des mandats de dépôt",
    ],
    answer:
        "Des pouvoirs de l’instruction préparatoire, avec la possibilité d’ordonner notamment les perquisitions, saisies, expertises et interceptions dans des limites temporelles",
    explanation:
        "Le juge d’instruction peut utiliser l’arsenal de l’instruction préparatoire, sous réserve notamment que les interceptions de correspondances ne dépassent pas deux mois renouvelables.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Actes délégués — Juge d’instruction",
    question:
        "Dans une information pour recherche des causes de la mort, le juge d’instruction peut déléguer par commission rogatoire à un officier de police judiciaire :",
    options: [
      "Uniquement la rédaction de rapports administratifs",
      "Les constatations, perquisitions, saisies, scellés, réquisitions et auditions nécessaires à la manifestation de la vérité",
      "Uniquement l’audition de la famille du défunt",
    ],
    answer:
        "Les constatations, perquisitions, saisies, scellés, réquisitions et auditions nécessaires à la manifestation de la vérité",
    explanation:
        "Le juge d’instruction peut déléguer par commission rogatoire un ensemble d’actes d’enquête à l’officier de police judiciaire, comme dans une information classique.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Interceptions — Limites",
    question:
        "Dans une information pour recherche des causes de la mort, les interceptions de correspondances émises par la voie des télécommunications peuvent être réalisées :",
    options: [
      "Sans aucune limite de durée",
      "Pour une durée maximale de deux mois renouvelable",
      "Uniquement avec l’accord de la famille du défunt",
    ],
    answer: "Pour une durée maximale de deux mois renouvelable",
    explanation:
        "Les textes précisent que ces interceptions ne peuvent excéder deux mois, renouvelables, ce qui constitue une limite spécifique.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Suites de l’enquête",
    question:
        "À l’issue d’une enquête menée en application de l’article 74 du Code de procédure pénale, un faisceau d’indices graves et concordants laisse supposer un homicide volontaire. Quelle est l’option la plus cohérente pour le procureur de la République ?",
    options: [
      "Classer la procédure pour apaiser les tensions",
      "Ouvrir une information judiciaire pour homicide et basculer dans un cadre infractionnel classique",
      "Se limiter à l’enquête préliminaire sans autre acte",
    ],
    answer:
        "Ouvrir une information judiciaire pour homicide et basculer dans un cadre infractionnel classique",
    explanation:
        "Une fois le caractère criminel établi, l’information judiciaire pour l’infraction concernée permet les mises en examen et les mesures coercitives adaptées.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Exhumation",
    question:
        "Après l’inhumation d’un corps, de nouveaux éléments font suspecter une cause pénale du décès. Quel mécanisme procédural permet, le cas échéant, l’exhumation du corps aux fins d’autopsie ?",
    options: [
      "Une simple demande de la famille au maire",
      "Une information judiciaire ouverte par le procureur de la République",
      "Une réquisition de l’officier de police judiciaire sans autre formalité",
    ],
    answer:
        "Une information judiciaire ouverte par le procureur de la République",
    explanation:
        "Lorsque des doutes surviennent après l’inhumation, il appartient au parquet d’apprécier l’opportunité de requérir l’ouverture d’une information permettant l’exhumation.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Police technique — APJ",
    question:
        "Dans le cadre d’une information pour recherche des causes de la mort, les agents de police judiciaire, sous le contrôle de l’officier de police judiciaire commis par le juge d’instruction, peuvent notamment :",
    options: [
      "Installer un dispositif d’interception sans en référer à l’officier de police judiciaire",
      "Accéder à des données informatiques lors d’une perquisition et requérir des informations permettant d’y accéder",
      "Décider seuls des réquisitions à des opérateurs téléphoniques sans lien avec la procédure",
    ],
    answer:
        "Accéder à des données informatiques lors d’une perquisition et requérir des informations permettant d’y accéder",
    explanation:
        "Les agents de police judiciaire peuvent, dans ce cadre, assister l’officier de police judiciaire pour les opérations informatiques et les réquisitions techniques prévues par le Code de procédure pénale.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Personne grièvement blessée",
    question:
        "Les dispositions de l’article 74 du Code de procédure pénale s’appliquent également en cas de découverte d’une personne grièvement blessée lorsque :",
    options: [
      "Elle est mineure",
      "La cause de ses blessures est inconnue ou suspecte",
      "Elle est connue des services de police",
    ],
    answer: "La cause de ses blessures est inconnue ou suspecte",
    explanation:
        "Le texte précise que les alinéas 1 à 4 sont également applicables en cas de découverte d’une personne grièvement blessée dont la cause des blessures est inconnue ou suspecte.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Généralités — Article 74-2 C.P.P.",
    question:
        "Quel est l’objectif principal de la procédure prévue par l’article 74-2 du C.P.P. ?",
    options: [
      "Rechercher les témoins d’une infraction",
      "Rechercher et découvrir une personne en fuite",
      "Contrôler les conditions de garde à vue",
    ],
    answer: "Rechercher et découvrir une personne en fuite",
    explanation:
        "L’article 74-2 crée un cadre juridique spécifique pour rechercher de manière effective une personne en fuite.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Article 74-2 C.P.P.",
    question:
        "Sur instructions de quelle autorité la procédure de l’article 74-2 du C.P.P. peut-elle être mise en œuvre ?",
    options: [
      "Sur instructions du préfet",
      "Sur instructions du juge d’instruction",
      "Sur instructions du procureur de la République",
    ],
    answer: "Sur instructions du procureur de la République",
    explanation:
        "Le texte précise que la procédure ne peut être mise en œuvre que « sur instructions du procureur de la République ». L’OPJ n’agit jamais de sa propre initiative.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Généralités — Article 74-2 C.P.P.",
    question:
        "Les actes réalisés dans le cadre de l’article 74-2 du C.P.P. renvoient principalement aux articles :",
    options: [
      "Articles 53 à 55 du C.P.P.",
      "Articles 56 à 62 du C.P.P.",
      "Articles 63 à 65 du C.P.P.",
    ],
    answer: "Articles 56 à 62 du C.P.P.",
    explanation:
        "L’article 74-2 autorise les OPJ, sur instructions du procureur, à user des moyens d’investigation prévus par les articles 56 à 62 du C.P.P. (flagrance).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions d’application — Mandat d’arrêt",
    question:
        "La procédure de l’article 74-2 du C.P.P. est notamment applicable à une personne en fuite qui :",
    options: [
      "Fait uniquement l’objet d’une simple convocation",
      "Fait l’objet d’un mandat d’arrêt",
      "Fait uniquement l’objet d’une plainte simple",
    ],
    answer: "Fait l’objet d’un mandat d’arrêt",
    explanation:
        "L’un des cas d’application vise la personne faisant l’objet d’un mandat d’arrêt, qu’il soit délivré par une juridiction d’instruction ou de jugement.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions d’application — Mandat d’arrêt",
    question:
        "Un mandat d’arrêt permettant la mise en œuvre de l’article 74-2 peut être délivré notamment par :",
    options: [
      "Le maire de la commune",
      "Le juge d’instruction ou le président de la cour d’assises",
      "Le directeur d’établissement pénitentiaire",
    ],
    answer: "Le juge d’instruction ou le président de la cour d’assises",
    explanation:
        "Le 1° de l’article 74-2 vise le mandat d’arrêt délivré par le juge d’instruction, le JLD, la chambre de l’instruction ou son président, ou le président de la cour d’assises.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions d’application — Mandat d’arrêt",
    question:
        "La procédure de recherche des personnes en fuite peut s’appliquer à un mandat d’arrêt délivré par :",
    options: [
      "Une juridiction de jugement ou le juge de l’application des peines",
      "Uniquement le tribunal de police",
      "Uniquement la cour de cassation",
    ],
    answer:
        "Une juridiction de jugement ou le juge de l’application des peines",
    explanation:
        "Le 2° de l’article 74-2 vise expressément le mandat d’arrêt délivré par une juridiction de jugement ou par le juge de l’application des peines.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions d’application — Peines",
    question:
        "La procédure 74-2 peut s’appliquer à une personne condamnée à une peine privative de liberté :",
    options: [
      "Inférieure à 6 mois, même non exécutoire",
      "Sans sursis ou avec sursis révoqué, supérieure ou égale à un an",
      "Uniquement si la peine est assortie d’un sursis simple",
    ],
    answer: "Sans sursis ou avec sursis révoqué, supérieure ou égale à un an",
    explanation:
        "Le 3° vise la personne condamnée à une peine privative de liberté sans sursis, ou résultant de la révocation d’un sursis, supérieure ou égale à un an, dès que la condamnation est exécutoire ou passée en force de chose jugée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions d’application — Fichiers nationaux",
    question:
        "Les personnes inscrites au fichier judiciaire national automatisé des auteurs d’infractions terroristes (FIJAIT) sont concernées par l’article 74-2 lorsqu’elles :",
    options: [
      "Sont simplement inscrites au fichier",
      "Ont manqué aux obligations prévues à l’article 706-25-7",
      "Ont purgé leur peine depuis plus de 10 ans",
    ],
    answer: "Ont manqué aux obligations prévues à l’article 706-25-7",
    explanation:
        "Le 4° vise les personnes inscrites au FIJAIT qui ont manqué à leurs obligations prévues à l’article 706-25-7 C.P.P.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions d’application — Fichiers nationaux",
    question:
        "Les personnes inscrites au fichier judiciaire national automatisé des auteurs d’infractions sexuelles ou violentes (FIJAISV) sont concernées si elles :",
    options: [
      "Demandent une réduction de peine",
      "Manquent aux obligations prévues à l’article 706-53-5",
      "Changent de domicile avec autorisation",
    ],
    answer: "Manquent aux obligations prévues à l’article 706-53-5",
    explanation:
        "Le 5° vise expressément les personnes inscrites au fichier des auteurs d’infractions sexuelles ou violentes, en cas de manquement à leurs obligations.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions d’application — Aménagements de peine",
    question:
        "L’article 74-2 peut être appliqué à une personne ayant fait l’objet d’une décision de retrait ou de révocation :",
    options: [
      "D’une amende forfaitaire",
      "D’un aménagement de peine ou d’une libération sous contrainte",
      "D’un simple rappel à la loi",
    ],
    answer: "D’un aménagement de peine ou d’une libération sous contrainte",
    explanation:
        "Le 6° vise les décisions de retrait ou de révocation d’un aménagement de peine ou d’une libération sous contrainte entraînant l’exécution d’un reliquat de peine supérieur à un an.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Conditions d’application — Quantum de peine",
    question:
        "Pour que l’article 74-2 s’applique à une décision de mise à exécution d’un reliquat de peine, la durée d’emprisonnement à exécuter doit être :",
    options: [
      "Supérieure à un an",
      "Supérieure à trois mois",
      "Exactement égale à un an",
    ],
    answer: "Supérieure à un an",
    explanation:
        "La décision doit avoir pour conséquence la mise à exécution d’un quantum ou d’un reliquat de peine d’emprisonnement supérieur à un an.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorités habilitées — OPJ/APJ",
    question:
        "Dans le cadre de l’article 74-2, qui peut être assisté d’agents de police judiciaire pour accomplir les actes de l’enquête ?",
    options: [
      "Le maire",
      "L’officier de police judiciaire",
      "Le juge d’instruction",
    ],
    answer: "L’officier de police judiciaire",
    explanation:
        "Les OPJ, assistés le cas échéant des APJ, peuvent accomplir les actes prévus par les articles 56 à 62 pour rechercher la personne en fuite.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Autorités habilitées — OPJ",
    question:
        "Dans le cadre de l’article 74-2, qui peut rédiger les actes de procédure ?",
    options: [
      "Les agents de police judiciaire",
      "Les OPJ uniquement",
      "Les agents de police municipale",
    ],
    answer: "Les OPJ uniquement",
    explanation:
        "Même si les APJ peuvent assister l’OPJ, seuls les officiers de police judiciaire sont habilités à rédiger les actes de procédure.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Actes de l’enquête — Garde à vue",
    question:
        "Dans le cadre de la procédure de l’article 74-2, l’OPJ peut-il placer une personne en garde à vue ?",
    options: [
      "Oui, dans tous les cas",
      "Oui, uniquement avec l’accord du JLD",
      "Non, la garde à vue n’est pas possible dans ce cadre",
    ],
    answer: "Non, la garde à vue n’est pas possible dans ce cadre",
    explanation:
        "Le texte précise que dans le cadre de l’article 74-2, l’OPJ ne peut pas prendre de mesure de garde à vue.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Actes de l’enquête — Flagrance",
    question:
        "Les actes que l’OPJ peut réaliser dans le cadre de l’article 74-2 correspondent à ceux :",
    options: [
      "De l’enquête de flagrance",
      "De l’enquête préliminaire uniquement",
      "De l’instruction uniquement",
    ],
    answer: "De l’enquête de flagrance",
    explanation:
        "L’article 74-2 renvoie aux actes prévus par les articles 56 à 62, c’est-à-dire à ceux de l’enquête de flagrance (perquisitions, auditions, etc.).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Interceptions — Autorisation",
    question:
        "Dans le cadre de l’article 74-2, qui autorise les interceptions téléphoniques ?",
    options: [
      "Le procureur de la République",
      "Le juge des libertés et de la détention",
      "Le juge d’instruction",
    ],
    answer: "Le juge des libertés et de la détention",
    explanation:
        "Les interceptions sont autorisées par le juge des libertés et de la détention du tribunal judiciaire, à la requête du procureur.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Interceptions — Durée",
    question:
        "Dans le cadre de l’article 74-2, la durée initiale maximale d’une autorisation d’interception téléphonique est de :",
    options: ["Un mois", "Deux mois", "Six mois"],
    answer: "Deux mois",
    explanation:
        "L’autorisation est délivrée pour une durée maximale de deux mois, renouvelable dans les mêmes conditions.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Interceptions — Limite en matière correctionnelle",
    question:
        "En matière correctionnelle, la durée totale des interceptions autorisées dans le cadre de l’article 74-2 est limitée à :",
    options: ["Deux mois", "Quatre mois", "Six mois"],
    answer: "Six mois",
    explanation:
        "En matière correctionnelle, la durée totale ne peut excéder six mois, même en cas de renouvellements.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Techniques spéciales — Rappel",
    question:
        "Les techniques spéciales d’enquête mobilisables via l’article 74-2 renvoient à celles applicables :",
    options: [
      "À la criminalité organisée et aux crimes",
      "Aux contraventions routières",
      "Uniquement aux délits de presse",
    ],
    answer: "À la criminalité organisée et aux crimes",
    explanation:
        "Le texte renvoie aux techniques prévues pour la délinquance et la criminalité organisées (titre XXV).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Extension — Mandat d’arrêt européen et extradition",
    question:
        "Les dispositions de l’article 74-2 du C.P.P. sont également applicables en matière :",
    options: [
      "De simple contravention",
      "De mandat d’arrêt européen et d’extradition",
      "De médiation pénale",
    ],
    answer: "De mandat d’arrêt européen et d’extradition",
    explanation:
        "Le rappel indique que l’article 74-2 est applicable pour l’exécution de MAE (art. 695-36) et d’extradition (art. 696-21).",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE =====================
  const QuizQuestion(
    category: "Conditions d’application — Synthèse",
    question:
        "Parmi les propositions suivantes, laquelle ne correspond PAS à une condition d’application de l’article 74-2 du C.P.P. ?",
    options: [
      "Mandat d’arrêt délivré par une juridiction de jugement",
      "Inscription au fichier des auteurs d’infractions sexuelles ayant manqué à leurs obligations",
      "Personne simplement suspectée sans condamnation, ni mandat, ni fichage",
    ],
    answer:
        "Personne simplement suspectée sans condamnation, ni mandat, ni fichage",
    explanation:
        "L’article 74-2 vise des personnes déjà condamnées, sous mandat ou fichées pour manquement aux obligations, pas de simples suspects.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Conditions d’application — Mandats",
    question:
        "Dans le cadre du 1° de l’article 74-2, le mandat d’arrêt délivré par le juge d’instruction concerne une personne :",
    options: [
      "Mise en examen mais non renvoyée",
      "Renvoyée devant une juridiction de jugement",
      "Simplement entendue comme témoin",
    ],
    answer: "Renvoyée devant une juridiction de jugement",
    explanation:
        "Le texte vise la personne faisant l’objet d’un mandat d’arrêt alors qu’elle est renvoyée devant une juridiction de jugement.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Conditions d’application — Condamnation",
    question:
        "Pour le 3° de l’article 74-2, la condamnation privative de liberté prenant en compte un sursis révoqué doit :",
    options: [
      "Être simplement prononcée, même non exécutoire",
      "Être exécutoire ou passée en force de chose jugée",
      "Toujours être assortie d’un sursis probatoire en cours",
    ],
    answer: "Être exécutoire ou passée en force de chose jugée",
    explanation:
        "Le texte vise les condamnations exécutoires ou passées en force de chose jugée, supérieures ou égales à un an.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Autorités habilitées — Procureur",
    question:
        "Dans le cadre de l’article 74-2, le procureur de la République peut demander aux OPJ :",
    options: [
      "De se limiter à de simples vérifications administratives",
      "D’user des moyens d’investigation prévus pour l’enquête de flagrance",
      "De prononcer eux-mêmes les peines",
    ],
    answer:
        "D’user des moyens d’investigation prévus pour l’enquête de flagrance",
    explanation:
        "Le procureur peut demander aux OPJ d’utiliser les articles 56 à 62 C.P.P. pour rechercher la personne en fuite.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Autorités habilitées — Procureur",
    question:
        "Dans le cadre des interceptions 74-2, les attributions normalement confiées au juge d’instruction par les articles 100-3 à 100-5 C.P.P. sont exercées par :",
    options: [
      "Le président du tribunal correctionnel",
      "Le procureur de la République ou l’OPJ requis par lui",
      "Le juge de l’application des peines",
    ],
    answer: "Le procureur de la République ou l’OPJ requis par lui",
    explanation:
        "L’article 74-2 prévoit que ces attributions sont exercées par le procureur ou l’OPJ requis par lui.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Autorités habilitées — JLD",
    question:
        "Selon l’article 74-2, le juge des libertés et de la détention doit être informé :",
    options: [
      "Uniquement à la fin de l’enquête",
      "Sans délai des actes accomplis dans le cadre des interceptions",
      "Uniquement en cas d’échec des interceptions",
    ],
    answer: "Sans délai des actes accomplis dans le cadre des interceptions",
    explanation:
        "Le texte impose une information sans délai du JLD sur les actes accomplis au titre des interceptions autorisées.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Interceptions — Conditions générales",
    question:
        "Pour autoriser des interceptions dans le cadre de l’article 74-2, la peine encourue pour l’infraction doit être :",
    options: ["D’au moins 1 an", "D’au moins 3 ans", "D’au moins 10 ans"],
    answer: "D’au moins 3 ans",
    explanation:
        "Les articles 100 et suivants, auxquels renvoie l’article 74-2, imposent que la peine encourue soit égale ou supérieure à 3 ans.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Interceptions — Lignes protégées",
    question:
        "À peine de nullité, les lignes dépendant du cabinet ou domicile d’un député, sénateur, avocat ou magistrat ne peuvent être interceptées que :",
    options: [
      "Avec l’accord du préfet",
      "Après avis de leur autorité supérieure",
      "Avec l’accord de la personne elle-même",
    ],
    answer: "Après avis de leur autorité supérieure",
    explanation:
        "Les interceptions concernant ces professions protégées nécessitent un avis préalable de l’autorité supérieure (président d’assemblée, bâtonnier, etc.).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Interceptions — Secret professionnel",
    question:
        "Les correspondances avec un avocat ne peuvent être transcrites dans le cadre des interceptions 74-2 que si :",
    options: [
      "Elles concernent un rendez-vous amical",
      "Elles relèvent de l’exercice des droits de la défense",
      "Elles ne relèvent pas de l’exercice des droits de la défense et ne sont pas couvertes par le secret professionnel, sauf cas prévus par la loi",
    ],
    answer:
        "Elles ne relèvent pas de l’exercice des droits de la défense et ne sont pas couvertes par le secret professionnel, sauf cas prévus par la loi",
    explanation:
        "Les correspondances avocat relevant des droits de la défense et protégées par le secret ne peuvent être transcrites, sauf exceptions textuelles.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Actes de l’enquête — OPJ",
    question:
        "Parmi les actes suivants, lesquels peuvent être accomplis par l’OPJ dans le cadre de l’article 74-2 ?",
    options: [
      "Perquisitions et réquisitions prévues par les articles 56 à 62",
      "Prononcer une peine d’emprisonnement",
      "Placer la personne en détention provisoire",
    ],
    answer: "Perquisitions et réquisitions prévues par les articles 56 à 62",
    explanation:
        "L’OPJ peut réaliser tous les actes de flagrance (auditions, perquisitions, réquisitions, examens techniques et scientifiques).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Actes de l’enquête — PV d’interception",
    question:
        "Que doit faire l’OPJ après les opérations d’interception téléphonique en application de l’article 74-2 ?",
    options: [
      "Notifier immédiatement les résultats à la personne recherchée",
      "Rédiger un procès-verbal précis et placer les enregistrements sous scellés fermés",
      "Détruire les enregistrements après écoute",
    ],
    answer:
        "Rédiger un procès-verbal précis et placer les enregistrements sous scellés fermés",
    explanation:
        "L’OPJ doit décrire précisément les opérations réalisées et placer les enregistrements sous scellés, afin d’assurer la traçabilité et l’intégrité des preuves.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Actes de l’enquête — Interprète",
    question:
        "Si des interceptions portent sur des conversations en langue étrangère, l’OPJ doit :",
    options: [
      "Les ignorer",
      "Les transmettre telles quelles au JLD",
      "Recourir à un interprète pour les transcrire utilement",
    ],
    answer: "Recourir à un interprète pour les transcrire utilement",
    explanation:
        "Le texte impose de recourir à un interprète pour les correspondances en langue étrangère afin d’assurer une transcription fiable.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Techniques spéciales — Liste",
    question:
        "Parmi les techniques suivantes, laquelle fait partie des techniques spéciales d’enquête mobilisables via l’article 74-2 ?",
    options: [
      "La contravention forfaitaire",
      "L’IMSI-catcher",
      "Le rappel à la loi",
    ],
    answer: "L’IMSI-catcher",
    explanation:
        "L’IMSI-catcher (art. 706-95-20 C.P.P.) figure parmi les techniques spéciales mobilisables lorsque les conditions de l’article 74-2 sont réunies.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Techniques spéciales — Accès à distance",
    question:
        "L’accès à distance aux correspondances stockées par la voie des communications électroniques (articles 706-95 à 706-95-3) permet :",
    options: [
      "De contrôler les horaires de travail du mis en cause",
      "De recueillir à distance des messages stockés (boîtes mail, messageries sécurisées)",
      "De vérifier le casier judiciaire en direct",
    ],
    answer:
        "De recueillir à distance des messages stockés (boîtes mail, messageries sécurisées)",
    explanation:
        "Cette technique permet de consulter à distance des correspondances électroniques stockées, utiles pour localiser ou suivre la personne.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Techniques spéciales — Conditions",
    question:
        "Les techniques spéciales d’enquête via l’article 74-2 (surveillance, infiltration, etc.) ne sont applicables que si :",
    options: [
      "La personne est simplement recherchée pour une contravention",
      "La personne a fait l’objet d’une des décisions 1°, 2°, 3° ou 6° pour une infraction 706-73 ou 706-73-1",
      "La personne est seulement témoin dans l’affaire",
    ],
    answer:
        "La personne a fait l’objet d’une des décisions 1°, 2°, 3° ou 6° pour une infraction 706-73 ou 706-73-1",
    explanation:
        "Les sections 1, 2 et 4 à 6 du titre XXV sont applicables si la personne a fait l’objet de l’une des décisions mentionnées aux 1° à 3° et 6° pour une infraction relevant des articles 706-73 ou 706-73-1.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Généralités — Moment d’utilisation",
    question:
        "L’article 74-2 du C.P.P. vise en particulier la recherche d’une personne faisant l’objet d’un mandat d’arrêt :",
    options: [
      "Avant toute mise en examen",
      "Après la clôture de l’information",
      "Uniquement pendant la garde à vue",
    ],
    answer: "Après la clôture de l’information",
    explanation:
        "Le texte précise que ce dispositif permet la recherche effective d’une personne faisant l’objet d’un mandat d’arrêt après la clôture de l’information.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Interceptions — Renouvellement",
    question:
        "Dans le cadre 74-2, le renouvellement de l’autorisation d’interception téléphonique :",
    options: [
      "Est interdit",
      "Est possible dans les mêmes formes et durées que l’autorisation initiale",
      "Peut être décidé oralement par l’OPJ",
    ],
    answer:
        "Est possible dans les mêmes formes et durées que l’autorisation initiale",
    explanation:
        "L’autorisation est renouvelable dans les mêmes conditions de forme et de durée, sous réserve des limites (6 mois en correctionnelle).",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Interceptions — Nature de la décision",
    question:
        "La décision du JLD autorisant les interceptions dans le cadre de l’article 74-2 :",
    options: [
      "Est écrite et n’est susceptible d’aucun recours",
      "Doit être orale pour être plus rapide",
      "Doit être validée par la chambre de l’instruction",
    ],
    answer: "Est écrite et n’est susceptible d’aucun recours",
    explanation:
        "Conformément aux articles 100 et suivants, la décision autorisant les interceptions est écrite et non susceptible de recours.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Techniques spéciales — Sonorisation",
    question:
        "La sonorisation et fixation d’images mobilisable via l’article 74-2 correspond à :",
    options: [
      "La simple vidéosurveillance de voie publique",
      "La pose de micros/caméras dans certains lieux ou véhicules autorisés",
      "La captation des conversations des jurés de la cour d’assises",
    ],
    answer:
        "La pose de micros/caméras dans certains lieux ou véhicules autorisés",
    explanation:
        "Les articles 706-96 à 706-100 encadrent la captation de paroles et d’images dans des lieux ou véhicules privés ou publics, sous contrôle judiciaire.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Techniques spéciales — Captation de données",
    question:
        "La captation de données informatiques (706-102-1 à 706-102-5) permet notamment :",
    options: [
      "D’accéder aux données stockées dans un système informatique et de les enregistrer",
      "De perquisitionner un domicile sans autorisation",
      "De contrôler l’identité sur la voie publique",
    ],
    answer:
        "D’accéder aux données stockées dans un système informatique et de les enregistrer",
    explanation:
        "Cette technique permet d’accéder à des données informatiques, de les enregistrer, conserver et transmettre, sans le consentement des intéressés.",
    difficulty: "Intermédiaire",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  const QuizQuestion(
    category: "Conditions d’application — Analyse fine",
    question:
        "Parmi les situations suivantes, laquelle permet de mettre en œuvre à la fois l’article 74-2 et les techniques spéciales d’enquête du titre XXV ?",
    options: [
      "Personne mise en examen pour vol simple sans mandat ni condamnation",
      "Personne renvoyée devant une juridiction pour une infraction 706-73 et faisant l’objet d’un mandat d’arrêt",
      "Personne témoin assisté dans une procédure de contravention",
    ],
    answer:
        "Personne renvoyée devant une juridiction pour une infraction 706-73 et faisant l’objet d’un mandat d’arrêt",
    explanation:
        "Les techniques spéciales ne sont applicables que si la personne a fait l’objet d’une des décisions mentionnées (mandat, condamnation, etc.) pour une infraction entrant dans le champ de 706-73 ou 706-73-1.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Conditions d’application — Fichiers",
    question:
        "Une personne inscrite au FIJAIT ou au fichier des infractions sexuelles/violentes peut être concernée par l’article 74-2 si :",
    options: [
      "Elle est simplement inscrite au fichier, sans manquement",
      "Elle a manqué à ses obligations prévues respectivement par les articles 706-25-7 ou 706-53-5",
      "Elle demande une révision de son procès",
    ],
    answer:
        "Elle a manqué à ses obligations prévues respectivement par les articles 706-25-7 ou 706-53-5",
    explanation:
        "L’article 74-2 vise le manquement aux obligations attachées à ces fichiers, pas la simple inscription.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Autorités habilitées — Répartition des rôles",
    question:
        "Dans le cadre des interceptions autorisées par 74-2, la répartition des rôles est la suivante :",
    options: [
      "Le JLD exécute les interceptions, le procureur se contente de les autoriser",
      "Le JLD autorise, le procureur et l’OPJ exécutent et contrôlent matériellement",
      "L’OPJ autorise et exécute seul les interceptions",
    ],
    answer:
        "Le JLD autorise, le procureur et l’OPJ exécutent et contrôlent matériellement",
    explanation:
        "Le JLD autorise l’interception, tandis que les attributions de mise en œuvre sont exercées par le procureur ou l’OPJ requis.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Actes de l’enquête — Limites",
    question:
        "Pourquoi la garde à vue est-elle exclue de la procédure de l’article 74-2 du C.P.P. ?",
    options: [
      "Parce que la garde à vue n’existe plus en droit français",
      "Parce que la finalité de 74-2 est de localiser une personne déjà visée par un titre et non de l’entendre sous contrainte",
      "Parce que seul le préfet peut décider d’une garde à vue",
    ],
    answer:
        "Parce que la finalité de 74-2 est de localiser une personne déjà visée par un titre et non de l’entendre sous contrainte",
    explanation:
        "La procédure vise à rechercher la personne afin d’exécuter un mandat ou une décision, non à reprendre une enquête de garde à vue.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Interceptions — Correctionnel / Criminel",
    question:
        "En matière criminelle, la durée totale des interceptions autorisées dans le cadre de l’article 74-2 est :",
    options: [
      "Limitée à 6 mois comme en correctionnel",
      "Limitée à 1 an maximum",
      "Sans limitation de durée légale tant que les renouvellements sont justifiés",
    ],
    answer:
        "Sans limitation de durée légale tant que les renouvellements sont justifiés",
    explanation:
        "Le texte prévoit une limite de 6 mois en correctionnel, mais aucune limite en matière criminelle, sous réserve de décisions motivées.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Interceptions — Lignes d’avocat",
    question:
        "Dans quel cas une ligne dépendant du cabinet ou domicile d’un avocat peut-elle être interceptée dans le cadre 74-2 ?",
    options: [
      "Jamais, quelle que soit la situation",
      "Uniquement s’il existe des raisons plausibles de soupçonner l’avocat d’avoir commis ou tenté de commettre une infraction objet de la procédure ou connexe",
      "Uniquement si l’avocat y consent par écrit",
    ],
    answer:
        "Uniquement s’il existe des raisons plausibles de soupçonner l’avocat d’avoir commis ou tenté de commettre une infraction objet de la procédure ou connexe",
    explanation:
        "Cette exception est prévue par les articles 100 et 100-7, applicables par renvoi de l’article 74-2.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Techniques spéciales — Conditions cumulatives",
    question:
        "Pour recourir à l’IMSI-catcher dans le cadre 74-2, il faut notamment :",
    options: [
      "Uniquement que la personne soit recherchée pour une contravention",
      "Que la personne fasse l’objet d’une des décisions 1°, 2°, 3° ou 6° et que l’infraction entre dans le champ de 706-73 ou 706-73-1",
      "Que le préfet donne son autorisation",
    ],
    answer:
        "Que la personne fasse l’objet d’une des décisions 1°, 2°, 3° ou 6° et que l’infraction entre dans le champ de 706-73 ou 706-73-1",
    explanation:
        "Les techniques spéciales du titre XXV sont réservées aux infractions de criminalité organisée ou assimilées, et à certaines décisions relatives à la personne recherchée.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Techniques spéciales — Respect des lieux protégés",
    question:
        "Dans le cadre d’une sonorisation via 74-2, quel est l’un des risques majeurs de nullité ?",
    options: [
      "L’absence de présence d’un OPJ sur les lieux",
      "La mise en place du dispositif dans un lieu protégé (cabinet d’avocat, locaux de presse, etc.)",
      "L’absence de signature de l’APJ",
    ],
    answer:
        "La mise en place du dispositif dans un lieu protégé (cabinet d’avocat, locaux de presse, etc.)",
    explanation:
        "Les textes interdisent la mise en place de sonorisations dans certains lieux protégés ; le non-respect de ces règles entraîne la nullité.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Articulation — Mandat d’arrêt européen",
    question:
        "Dans le cadre d’un mandat d’arrêt européen, l’utilisation de la procédure 74-2 permet :",
    options: [
      "Uniquement de contrôler la régularité de la décision étrangère",
      "D’utiliser les mêmes moyens de recherche qu’en cas de mandat d’arrêt national, sous réserve des textes spécifiques",
      "De prononcer soi-même la peine étrangère",
    ],
    answer:
        "D’utiliser les mêmes moyens de recherche qu’en cas de mandat d’arrêt national, sous réserve des textes spécifiques",
    explanation:
        "Les dispositions de 74-2 sont déclarées applicables au mandat d’arrêt européen (art. 695-36 C.P.P.).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Articulation — Extradition",
    question: "En matière d’extradition, le recours à l’article 74-2 permet :",
    options: [
      "De remplacer la procédure d’extradition par une procédure simplifiée",
      "De rechercher la personne réclamée sur le territoire national en utilisant les moyens prévus par 74-2",
      "D’obliger l’État étranger à remettre immédiatement la personne",
    ],
    answer:
        "De rechercher la personne réclamée sur le territoire national en utilisant les moyens prévus par 74-2",
    explanation:
        "L’article 696-21 C.P.P. rend applicables les dispositions de 74-2 pour la recherche des personnes visées par une demande d’extradition.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Procédure — Information du JLD",
    question:
        "Pourquoi le législateur impose-t-il d’informer sans délai le JLD des actes accomplis dans le cadre des interceptions 74-2 ?",
    options: [
      "Pour lui permettre d’interroger la personne recherchée",
      "Pour garantir un contrôle juridictionnel continu sur la légalité et la proportionnalité des mesures",
      "Pour permettre au JLD de gérer les scellés au commissariat",
    ],
    answer:
        "Pour garantir un contrôle juridictionnel continu sur la légalité et la proportionnalité des mesures",
    explanation:
        "Le JLD exerce un contrôle permanent sur ces mesures très intrusives, d’où l’obligation d’information sans délai.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Procédure — Déclenchement de 74-2",
    question:
        "Quel serait le défaut majeur d’une enquête prétendument menée sur le fondement de l’article 74-2 alors qu’aucune instruction écrite ou orale du procureur n’apparaît en procédure ?",
    options: [
      "Un simple vice de forme sans conséquence",
      "L’absence de base légale du cadre 74-2, pouvant entraîner la nullité des actes",
      "Une simple irrégularité matérielle du procès-verbal",
    ],
    answer:
        "L’absence de base légale du cadre 74-2, pouvant entraîner la nullité des actes",
    explanation:
        "L’article 74-2 exige clairement des instructions du procureur ; à défaut, l’OPJ serait hors cadre légal pour les actes spécifiques à ce dispositif.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Techniques spéciales — Proportionnalité",
    question:
        "Dans le cadre de 74-2, le recours à des techniques spéciales très intrusives (sonorisation, captation de données) doit respecter principalement :",
    options: [
      "Un principe de simplicité administrative",
      "Un principe de proportionnalité par rapport à la gravité de l’infraction et à l’objectif de recherche",
      "Un principe de rapidité purement opérationnelle",
    ],
    answer:
        "Un principe de proportionnalité par rapport à la gravité de l’infraction et à l’objectif de recherche",
    explanation:
        "Même autorisées par la loi, ces techniques doivent rester proportionnées, ce qui est apprécié par le JLD ou le magistrat compétent.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizCadresPrincipalesPagePA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName =
      '/pa/procedure_penale/quiz/cadres_juridiques_principales';
  final String uid;
  final String email;

  const QuizCadresPrincipalesPagePA({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizCadresPrincipalesPagePA> createState() => _QuizCadresPrincipalesPagePAState();
}

class _QuizCadresPrincipalesPagePAState extends State<QuizCadresPrincipalesPagePA>
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
  static const _introHiddenKey = 'intro_pa_page_cadres_juridique';
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
        ? questionsCadresJuridiquePages
        : questionsCadresJuridiquePages
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
            'quiz_name': 'Quiz Page',
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
      await _sb.from('quiz_cadres_juridiques_principales').insert({
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
      debugPrint('❌ quiz_cadres_juridiques_principales insert failed: $e');
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
      'source_file': 'pa_quiz_page_cadres_juridique',
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
                            icon: Icons.document_scanner_rounded,
                            title: 'Cadres juridiques',
                            description: 'Identifie les différents cadres d’intervention policière : conditions de déclenchement, spécificités et actes autorisés dans chacun.',
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
