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
final List<QuizQuestion> questionsCommissionRogatoireProcedure = [
  // ===================== NIVEAU FACILE =====================
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
    category: "Garde à vue — Conditions",
    question:
        "En commission rogatoire, qui contrôle la garde à vue prévue par l’article 154 du Code de procédure pénale ?",
    options: ["Le maire", "Le juge d’instruction", "Le préfet"],
    answer: "Le juge d’instruction",
    explanation:
        "La garde à vue sur commission rogatoire est contrôlée par le juge d’instruction, qui doit être avisé dès le début.",
    difficulty: "Facile",
  ),

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
    category: "Procédure — Délais",
    question:
        "En l’absence de délai fixé par le juge d’instruction, dans quel délai l’OPJ doit-il transmettre la commission rogatoire et les procès-verbaux après la fin des opérations ?",
    options: ["Dans les 24 heures", "Dans les 3 jours", "Dans les 8 jours"],
    answer: "Dans les 8 jours",
    explanation:
        "L’article 151 al. 4 prévoit la transmission dans les huit jours de la fin des opérations si aucun délai particulier n’a été fixé.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
];

// ============================================================================
// PAGE
// ============================================================================
class QuizCommissionRogatoirePage extends StatefulWidget {
  static const String routeName = '/gpx/generalites/quiz/commission_rogatoire';
  final String uid;
  final String email;

  const QuizCommissionRogatoirePage({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizCommissionRogatoirePage> createState() =>
      _QuizCommissionRogatoirePageState();
}

class _QuizCommissionRogatoirePageState
    extends State<QuizCommissionRogatoirePage>
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
        ? questionsCommissionRogatoireProcedure
        : questionsCommissionRogatoireProcedure
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
            'module_name': 'Cadres Juridiques',
            'quiz_name': 'Commission rogatoire',
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
      final int total = _qs.length.clamp(1, 1 << 30);
      final int percent = ((_score / total) * 100).round();

      await _sb
          .from('quiz_history')
          .update({
            'score': percent,
            'correct_count': _score,
            'finished_at': DateTime.now().toUtc().toIso8601String(),
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _historyRowId!)
          .eq('uid', widget.uid);
    } catch (e) {
      debugPrint('❌ quiz_history (finish) update failed: $e');
    }
  }

  Future<void> _saveAnswer({
    required String question,
    required String userAnswer,
    required String correctAnswer,
    required bool isCorrect,
    required String difficulty,
  }) async {
    try {
      await _sb.from('quiz_commission_rogatoire').insert({
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
      debugPrint('❌ quiz_commission_rogatoire insert failed: $e');
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
