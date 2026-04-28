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

final List<QuizQuestion> questionsJuridictionsPenales = [
  // ==========================================================
  // NIVEAU FACILE — GENERALITES
  // ==========================================================
  QuizQuestion(
    category: "Généralités — Juridictions pénales",
    question:
        "Quel est le rôle principal des juridictions pénales en droit français ?",
    options: [
      "Organiser les élections",
      "Juger les infractions et appliquer les peines prévues par la loi",
      "Contrôler l’action du gouvernement",
    ],
    answer: "Juger les infractions et appliquer les peines prévues par la loi",
    explanation:
        "Les juridictions pénales ont pour mission de juger les auteurs d’infractions (contraventions, délits, crimes) et d’appliquer les peines prévues par la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Généralités — Juridictions pénales",
    question:
        "Quel est le rôle principal des juridictions pénales en droit français ?",
    options: [
      "Organiser les élections",
      "Juger les infractions et appliquer les peines prévues par la loi",
      "Contrôler l’action du gouvernement",
    ],
    answer: "Juger les infractions et appliquer les peines prévues par la loi",
    explanation:
        "Les juridictions pénales ont pour mission de juger les auteurs d’infractions (contraventions, délits, crimes) et d’appliquer les peines prévues par la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Intro — Exécution des décisions",
    question:
        "Quel est l’objectif principal de la réforme du droit de la peine par la loi du 23 mars 2019 ?",
    options: [
      "Supprimer toutes les peines privatives de liberté",
      "Rendre l’application des peines plus lisible, plus efficace et plus rapide",
      "Transférer l’exécution des peines aux juridictions civiles",
    ],
    answer:
        "Rendre l’application des peines plus lisible, plus efficace et plus rapide",
    explanation:
        "La loi n° 2019-222 du 23 mars 2019 a refondu le droit de la peine pour le rendre plus lisible, plus efficace et favoriser une mise à exécution rapide dans le respect de l’individualisation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Exécution des décisions – Réformes",
    question:
        "Quel est l’objectif principal de la loi n° 2019-222 du 23 mars 2019 concernant le droit de la peine ?",
    options: [
      "Supprimer les peines privatives de liberté",
      "Rendre l’application de la peine plus lisible et plus efficace, en favorisant sa mise à exécution rapide",
      "Confier l’exécution des peines uniquement au juge d’instruction",
    ],
    answer:
        "Rendre l’application de la peine plus lisible et plus efficace, en favorisant sa mise à exécution rapide",
    explanation:
        "La loi de 2019 a refondu le droit de la peine pour le rendre plus lisible et plus efficace, en permettant une mise à exécution rapide dans le respect de l’individualisation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Exécution des décisions – Réformes",
    question:
        "La loi n° 2012-409 du 27 mars 2012 relative à l’exécution des peines vise notamment à :",
    options: [
      "Renforcer la place du jury populaire en cour d’assises",
      "Garantir l’effectivité de l’exécution des peines et renforcer la prévention de la récidive",
      "Supprimer la contrainte judiciaire",
    ],
    answer:
        "Garantir l’effectivité de l’exécution des peines et renforcer la prévention de la récidive",
    explanation:
        "Le texte précise que cette loi vise à garantir l’effectivité de l’exécution des peines, renforcer la prévention de la récidive et améliorer la prise en charge des mineurs délinquants.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Exécution des décisions – Juridictionnalisation",
    question:
        "Le mouvement de juridictionnalisation des peines s’est notamment traduit par :",
    options: [
      "La suppression de tout contrôle du juge sur l’exécution des peines",
      "L’abandon définitif de la notion de mesures d’administration judiciaire",
      "La compétence exclusive du préfet pour l’exécution des peines",
    ],
    answer:
        "L’abandon définitif de la notion de mesures d’administration judiciaire",
    explanation:
        "La loi du 9 mars 2004 poursuit ce mouvement en abandonnant la notion de mesures d’administration judiciaire, au profit de décisions juridictionnelles.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Exécution des décisions – Acteurs",
    question:
        "Selon le texte, qui poursuit l’exécution des peines privatives de liberté et de certaines peines de substitution ainsi que des peines complémentaires ?",
    options: [
      "Le juge de l’application des peines",
      "Le préfet de département",
      "Le procureur de la République",
    ],
    answer: "Le procureur de la République",
    explanation:
        "Il est indiqué que le procureur de la République poursuit l’exécution de ces peines, même si le JAP intervient de plus en plus sur les modalités.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Exécution des décisions – Rôle du JAP",
    question:
        "Le juge de l’application des peines (JAP) intervient de plus en plus dans l’exécution des décisions de justice notamment pour :",
    options: [
      "Le retrait de la semi-liberté ou du placement à l’extérieur accordé par jugement",
      "La rédaction des lois pénales",
      "La nomination des procureurs de la République",
    ],
    answer:
        "Le retrait de la semi-liberté ou du placement à l’extérieur accordé par jugement",
    explanation:
        "Le texte cite explicitement l’exemple du retrait de la semi-liberté ou du placement à l’extérieur (Article 723-2 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Exécution des décisions – Individualisation",
    question:
        "Pour les peines privatives de liberté, l’individualisation de la peine doit notamment permettre :",
    options: [
      "Une remise en liberté sans aucun suivi",
      "Un retour progressif du condamné à la liberté avec un suivi judiciaire",
      "La systématisation des peines planchers",
    ],
    answer:
        "Un retour progressif du condamné à la liberté avec un suivi judiciaire",
    explanation:
        "Le texte insiste sur l’individualisation visant un retour progressif et évitant une remise en liberté sans suivi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Exécution des décisions – Peines pécuniaires",
    question:
        "Pour les peines pécuniaires, quel mécanisme est prévu pour garantir l’exécution des amendes et condamnations pécuniaires ?",
    options: [
      "Le sursis simple",
      "La contrainte judiciaire",
      "La détention provisoire automatique",
    ],
    answer: "La contrainte judiciaire",
    explanation:
        "Le texte précise que le législateur a prévu le système de la contrainte judiciaire pour garantir l’exécution des amendes et autres condamnations pécuniaires.",
    difficulty: "Facile",
  ),

  // ==========================================================
  // CHAPITRE 1 – EXÉCUTION DES PEINES (PARTIES INTERVENANTES)
  // ==========================================================
  QuizQuestion(
    category: "Exécution des peines – Parties",
    question:
        "Selon l’Article 707-1 alinéa 1 du Code de procédure pénale, qui poursuit l’exécution de la sentence ?",
    options: [
      "Le ministère public uniquement",
      "Le ministère public et les parties, chacun en ce qui le concerne",
      "Le juge de paix",
    ],
    answer: "Le ministère public et les parties, chacun en ce qui le concerne",
    explanation:
        "Le texte cite l’Article 707-1 : « Le ministère public et les parties poursuivent l’exécution de la sentence, chacun en ce qui le concerne ».",
    difficulty: "Facile",
  ),

  // --- 1.1.1 La partie civile ---
  QuizQuestion(
    category: "Exécution des peines – Partie civile",
    question:
        "En principe, quel type de réparation la partie civile obtient-elle ?",
    options: [
      "La relaxe du prévenu",
      "Le versement de dommages et intérêts",
      "Une peine de prison pour le prévenu",
    ],
    answer: "Le versement de dommages et intérêts",
    explanation:
        "La partie civile obtient en principe réparation sous forme de dommages et intérêts.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Exécution des peines – Partie civile",
    question:
        "Outre les dommages et intérêts, la partie civile peut également bénéficier :",
    options: [
      "D’un non-lieu automatique",
      "D’autres formes de réparation (publication de la décision, remise en état du bien, etc.)",
      "De la nomination au poste de procureur",
    ],
    answer:
        "D’autres formes de réparation (publication de la décision, remise en état du bien, etc.)",
    explanation:
        "Le texte mentionne ces autres formes de réparation possibles en faveur de la partie civile.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Exécution des peines – Partie civile",
    question:
        "Qui a qualité pour faire exécuter les condamnations prononcées au profit de la partie civile ?",
    options: [
      "Le ministère public",
      "Le préfet",
      "La partie civile elle-même par les voies civiles",
    ],
    answer: "La partie civile elle-même par les voies civiles",
    explanation:
        "Le texte indique qu’elle a seule qualité pour faire exécuter ces condamnations par les voies civiles (saisies, mesures d’exécution…).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Exécution des peines – Administrations",
    question:
        "Quelle administration est chargée du recouvrement des amendes à caractère fiscal et de certaines confiscations ?",
    options: [
      "L’administration des douanes",
      "L’administration des impôts",
      "L’administration pénitentiaire",
    ],
    answer: "L’administration des impôts",
    explanation:
        "Le texte précise que l’administration des impôts recouvre les amendes fiscales et certaines confiscations.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Exécution des peines – Administrations",
    question: "L’administration des douanes intervient notamment pour :",
    options: [
      "Le recouvrement des pensions alimentaires",
      "L’exécution des sanctions pécuniaires prononcées pour des infractions douanières",
      "Les décisions de mise en détention provisoire",
    ],
    answer:
        "L’exécution des sanctions pécuniaires prononcées pour des infractions douanières",
    explanation:
        "Le texte mentionne que l’administration des douanes exécute ces sanctions.",
    difficulty: "Facile",
  ),

  // ==========================================================
  // NIVEAU MOYEN – JURIDICTIONS PÉNALES
  // ==========================================================
  QuizQuestion(
    category: "Juridictions pénales – Généralités",
    question:
        "Parmi les propositions suivantes, laquelle correspond à une juridiction pénale de droit commun ?",
    options: [
      "Le tribunal de commerce",
      "Le tribunal correctionnel",
      "Le tribunal administratif",
    ],
    answer: "Le tribunal correctionnel",
    explanation:
        "En matière pénale, les juridictions de droit commun sont notamment le tribunal de police, le tribunal correctionnel et la cour d’assises.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Tribunal de police",
    question:
        "Quelle est la nature des infractions jugées par le tribunal de police ?",
    options: ["Les crimes", "Les contraventions", "Les délits financiers"],
    answer: "Les contraventions",
    explanation:
        "Le tribunal de police est compétent pour juger les contraventions, c’est-à-dire les infractions les moins graves.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Tribunal de police",
    question:
        "Sauf texte particulier, quel tribunal de police est territorialement compétent pour juger une contravention ?",
    options: [
      "Le tribunal du domicile de la victime uniquement",
      "Le tribunal du lieu de commission ou de constatation de l’infraction, ou de la résidence du prévenu",
      "Le tribunal du siège de la cour d’appel uniquement",
    ],
    answer:
        "Le tribunal du lieu de commission ou de constatation de l’infraction, ou de la résidence du prévenu",
    explanation:
        "Par principe, la compétence territoriale en matière contraventionnelle se détermine par le lieu de commission ou de constatation de l’infraction, ou la résidence du prévenu.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Tribunal correctionnel",
    question:
        "Quelle formation est en principe compétente pour juger les délits en première instance ?",
    options: [
      "La chambre criminelle de la Cour de cassation",
      "Le tribunal correctionnel",
      "La cour d’assises",
    ],
    answer: "Le tribunal correctionnel",
    explanation:
        "Le tribunal correctionnel est la juridiction de droit commun compétente pour juger les délits en première instance.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Tribunal correctionnel",
    question:
        "Dans sa formation ordinaire, comment est composé le tribunal correctionnel ?",
    options: [
      "Un président et deux juges",
      "Un juge unique assisté de jurés",
      "Un président, six jurés et un greffier",
    ],
    answer: "Un président et deux juges",
    explanation:
        "En principe, le tribunal correctionnel siège de façon collégiale : un président et deux juges. Il peut toutefois statuer à juge unique pour certains délits prévus par la loi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Tribunal correctionnel",
    question:
        "Quel type d’infraction le tribunal correctionnel juge-t-il normalement ?",
    options: [
      "Les infractions passibles uniquement d’une amende inférieure à 3 750 €",
      "Les délits, punis d’une peine d’emprisonnement ou d’une amende au moins égale à 3 750 €",
      "Tous les crimes commis sur le territoire national",
    ],
    answer:
        "Les délits, punis d’une peine d’emprisonnement ou d’une amende au moins égale à 3 750 €",
    explanation:
        "L’Article 381 du CPP prévoit que le tribunal correctionnel connaît des délits, qui sont punis d’emprisonnement ou d’une amende d’au moins 3 750 euros.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Cour d’assises",
    question:
        "Quelle est la compétence matérielle principale de la cour d’assises ?",
    options: [
      "Les contraventions de 5ᵉ classe",
      "Les délits sexuels commis par des mineurs uniquement",
      "Les crimes et certaines infractions qui leur sont connexes",
    ],
    answer: "Les crimes et certaines infractions qui leur sont connexes",
    explanation:
        "La cour d’assises a plénitude de juridiction pour juger les crimes et certaines infractions connexes renvoyées devant elle par la décision de mise en accusation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Cour d’assises",
    question:
        "Lorsque la cour d’assises statue en appel, combien de jurés composent en principe le jury ?",
    options: ["Six jurés", "Neuf jurés", "Douze jurés"],
    answer: "Neuf jurés",
    explanation:
        "Le jury est composé de six jurés lorsque la cour d’assises statue en premier ressort et de neuf jurés lorsqu’elle statue en appel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Cour d’assises",
    question:
        "Quel est le rôle du président de la cour d’assises pendant les débats ?",
    options: [
      "Il se contente de recueillir le vote des jurés",
      "Il dirige les débats, interroge l’accusé et les témoins et veille au respect des droits de la défense",
      "Il ne peut prendre la parole qu’en fin d’audience pour prononcer la peine",
    ],
    answer:
        "Il dirige les débats, interroge l’accusé et les témoins et veille au respect des droits de la défense",
    explanation:
        "Le président de la cour d’assises joue un rôle central : il dirige les débats, interroge l’accusé, les témoins, les experts, et s’assure du respect des droits de la défense.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Voies de recours",
    question:
        "En matière correctionnelle, quelle juridiction connaît de l’appel d’un jugement rendu par le tribunal correctionnel ?",
    options: [
      "La cour d’appel, chambre correctionnelle",
      "La cour d’assises",
      "La Cour de cassation",
    ],
    answer: "La cour d’appel, chambre correctionnelle",
    explanation:
        "Les jugements du tribunal correctionnel peuvent être frappés d’appel devant la cour d’appel, siégeant en chambre correctionnelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Voies de recours",
    question:
        "Quel est en principe l’effet d’un pourvoi en cassation contre une décision pénale ?",
    options: [
      "Il est toujours suspensif de l’exécution de la peine",
      "Il n’est en principe pas suspensif, sauf exceptions prévues par la loi",
      "Il annule automatiquement la décision attaquée",
    ],
    answer:
        "Il n’est en principe pas suspensif, sauf exceptions prévues par la loi",
    explanation:
        "En droit pénal, le pourvoi en cassation n’a en principe pas d’effet suspensif, sauf lorsque la loi en dispose autrement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Compétence mineurs",
    question:
        "Pour les contraventions de 5ᵉ classe commises par des mineurs, quelle juridiction est compétente ?",
    options: [
      "Le tribunal de police",
      "Les juridictions pour mineurs",
      "La cour d’assises des mineurs",
    ],
    answer: "Les juridictions pour mineurs",
    explanation:
        "Les contraventions de 5ᵉ classe commises par des mineurs relèvent de la justice pénale des mineurs et non du tribunal de police.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Compétence connexité",
    question:
        "Lorsque des contraventions sont connexes à un délit poursuivi devant le tribunal correctionnel, comment sont-elles jugées ?",
    options: [
      "Elles sont renvoyées devant le tribunal de police",
      "Elles restent de la compétence du tribunal correctionnel",
      "Elles sont jugées par la cour d’assises",
    ],
    answer: "Elles restent de la compétence du tribunal correctionnel",
    explanation:
        "Par connexité, le tribunal correctionnel peut juger les contraventions liées au délit porté devant lui.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Saisine",
    question:
        "Parmi les modes de saisine suivants, lequel permet au ministère public de faire juger rapidement un prévenu devant le tribunal correctionnel lorsque les charges sont suffisantes et l’affaire en état d’être jugée ?",
    options: [
      "La citation directe par la victime",
      "La comparution immédiate",
      "Le pourvoi immédiat",
    ],
    answer: "La comparution immédiate",
    explanation:
        "La comparution immédiate permet au procureur de traduire rapidement le prévenu devant le tribunal correctionnel lorsque les conditions légales sont réunies.",
    difficulty: "Moyenne",
  ),

  // ==========================================================
  // NIVEAU DIFFICILE – JURIDICTIONS PÉNALES
  // ==========================================================
  QuizQuestion(
    category: "Juridictions pénales – Compétence territoriale",
    question:
        "En matière délictuelle, plusieurs critères de compétence territoriale peuvent se cumuler. Lequel de ces critères n’est pas habituellement retenu par le Code de procédure pénale ?",
    options: [
      "Le lieu de commission de l’infraction",
      "Le lieu de résidence du prévenu",
      "Le lieu de résidence de l’avocat du prévenu",
    ],
    answer: "Le lieu de résidence de l’avocat du prévenu",
    explanation:
        "La compétence territoriale se détermine notamment par le lieu de commission de l’infraction, la résidence du prévenu, le lieu d’arrestation ou de détention, mais pas par la résidence de l’avocat.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Cour d’assises",
    question:
        "Lors de la constitution du jury, quel pouvoir de récusation l’accusé possède-t-il devant la cour d’assises statuant en premier ressort ?",
    options: [
      "Il ne peut récuser aucun juré",
      "Il peut récuser jusqu’à 4 jurés",
      "Il peut récuser librement tous les jurés sans limite",
    ],
    answer: "Il peut récuser jusqu’à 4 jurés",
    explanation:
        "Devant la cour d’assises statuant en premier ressort, l’accusé peut récuser jusqu’à 4 jurés lors du tirage au sort.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Cour d’assises",
    question:
        "Pour être juré d’assises, parmi les conditions suivantes, laquelle n’est pas exigée ?",
    options: [
      "Être de nationalité française",
      "Être âgé d’au moins 23 ans",
      "Être titulaire d’un diplôme universitaire de niveau licence",
    ],
    answer: "Être titulaire d’un diplôme universitaire de niveau licence",
    explanation:
        "Les conditions portent notamment sur l’âge, la nationalité, la maîtrise de la langue française et la jouissance des droits civiques, mais aucun diplôme universitaire n’est requis.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Incompatibilités jurés",
    question:
        "Parmi les personnes suivantes, laquelle est en principe incompatible avec les fonctions de juré d’assises ?",
    options: [
      "Un fonctionnaire de police en activité",
      "Un retraité sans casier judiciaire",
      "Un étudiant majeur inscrit sur les listes électorales",
    ],
    answer: "Un fonctionnaire de police en activité",
    explanation:
        "Les textes prévoient diverses incompatibilités tenant notamment aux fonctions exercées, comme celles des fonctionnaires de police ou de certains militaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Appel des décisions d’assises",
    question:
        "Quel est l’effet principal de l’appel formé contre un arrêt de condamnation rendu par une cour d’assises statuant en premier ressort ?",
    options: [
      "L’appel est impossible en matière criminelle",
      "L’appel entraîne un nouveau procès devant une autre cour d’assises",
      "L’appel est porté devant la chambre criminelle de la Cour de cassation",
    ],
    answer:
        "L’appel entraîne un nouveau procès devant une autre cour d’assises",
    explanation:
        "Depuis la réforme de l’appel en matière criminelle, un arrêt de condamnation peut être frappé d’appel, l’affaire étant rejugée par une autre cour d’assises.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Contraventions et mineurs",
    question:
        "En matière contraventionnelle, dans quel cas le tribunal de police perd-il sa compétence au profit des juridictions pour mineurs ?",
    options: [
      "Pour toutes les contraventions commises par des mineurs",
      "Uniquement pour les contraventions de 5ᵉ classe commises par des mineurs",
      "Jamais, il reste compétent dans tous les cas",
    ],
    answer:
        "Uniquement pour les contraventions de 5ᵉ classe commises par des mineurs",
    explanation:
        "Les contraventions de 5ᵉ classe commises par des mineurs relèvent des juridictions pour mineurs, tandis que les contraventions des quatre premières classes peuvent relever du tribunal de police.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – CRPC",
    question:
        "La comparution sur reconnaissance préalable de culpabilité (CRPC) est une procédure applicable :",
    options: [
      "Aux crimes et aux délits",
      "À certains délits lorsque le prévenu reconnaît les faits",
      "Uniquement aux contraventions routières",
    ],
    answer: "À certains délits lorsque le prévenu reconnaît les faits",
    explanation:
        "La CRPC, procédure de « plaider-coupable », ne concerne que certains délits et suppose la reconnaissance préalable de culpabilité par le prévenu.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Ordonnance pénale",
    question: "L’ordonnance pénale en matière délictuelle permet :",
    options: [
      "De juger un délit sans audience publique, sur proposition de peine acceptée par le prévenu",
      "De renvoyer obligatoirement l’affaire devant la cour d’assises",
      "D’annuler l’action publique",
    ],
    answer:
        "De juger un délit sans audience publique, sur proposition de peine acceptée par le prévenu",
    explanation:
        "L’ordonnance pénale délictuelle permet au procureur de proposer une peine à un prévenu, sans audience, sous réserve de l’acceptation et des conditions prévues par la loi.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Lien civil/pénal",
    question:
        "Lorsque la victime se constitue partie civile devant le tribunal correctionnel, quel est l’effet principal sur la compétence civile ?",
    options: [
      "Le tribunal correctionnel ne peut statuer que sur le pénal",
      "Le tribunal correctionnel statue aussi sur les dommages et intérêts, quel que soit leur montant",
      "La victime doit ensuite saisir le tribunal judiciaire pour les dommages et intérêts",
    ],
    answer:
        "Le tribunal correctionnel statue aussi sur les dommages et intérêts, quel que soit leur montant",
    explanation:
        "La juridiction pénale saisie de l’action publique connaît en même temps de l’action civile lorsque la victime s’est constituée partie civile, sans que le montant de la demande limite sa compétence.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Saisine d’office",
    question:
        "Dans quel cas une juridiction de jugement peut-elle se saisir d’office d’une infraction pénale ?",
    options: [
      "Uniquement si le procureur l’y autorise par écrit",
      "Notamment lorsque l’infraction est commise à l’audience de cette juridiction",
      "Dès qu’un juge a connaissance d’une rumeur d’infraction",
    ],
    answer:
        "Notamment lorsque l’infraction est commise à l’audience de cette juridiction",
    explanation:
        "Le Code de procédure pénale prévoit que la juridiction peut se saisir d’office pour les infractions commises à son audience (ou dans les locaux de l’audience) dans certaines conditions.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Juridictions d’exception",
    question:
        "Parmi les juridictions suivantes, laquelle est une juridiction pénale d’exception au sens de la compétence matérielle ?",
    options: [
      "La cour d’assises",
      "Le tribunal correctionnel",
      "Le tribunal pour enfants",
    ],
    answer: "Le tribunal pour enfants",
    explanation:
        "Les juridictions d’exception ont une compétence d’attribution limitée, par exemple en raison de la qualité des auteurs (mineurs) : c’est le cas du tribunal pour enfants.",
    difficulty: "Difficile",
  ),

  // ==========================================================
  // SUITE – QUESTIONS NIVEAU MOYEN & DIFFICILE
  // ==========================================================
  QuizQuestion(
    category: "Juridictions pénales – Tribunal de police",
    question:
        "Le tribunal de police statue en matière pénale sur les contraventions. Quelle affirmation est exacte à propos des peines qu’il peut prononcer ?",
    options: [
      "Il peut prononcer la réclusion criminelle à perpétuité",
      "Il peut prononcer des peines d’amende et certaines peines complémentaires",
      "Il ne peut prononcer qu’un simple avertissement écrit",
    ],
    answer:
        "Il peut prononcer des peines d’amende et certaines peines complémentaires",
    explanation:
        "Le tribunal de police, compétent pour les contraventions, prononce principalement des amendes mais aussi certaines peines complémentaires prévues par les textes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Tribunal de police",
    question:
        "Parmi ces modes de saisine, lequel n’est pas utilisé pour le tribunal de police ?",
    options: [
      "La convocation en justice",
      "La citation directe",
      "Le réquisitoire introductif du juge d’instruction",
    ],
    answer: "Le réquisitoire introductif du juge d’instruction",
    explanation:
        "Le réquisitoire introductif sert à saisir un juge d’instruction, pas le tribunal de police. Celui-ci est saisi par citation, convocation, comparution volontaire, etc.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Tribunal correctionnel",
    question:
        "Quel est l’un des intérêts principaux de la possibilité de juge unique au tribunal correctionnel pour certains délits ?",
    options: [
      "Supprimer toute possibilité d’appel",
      "Accélérer le traitement des dossiers tout en restant dans le cadre légal",
      "Permettre au président de prononcer des peines supérieures à celles prévues par la loi",
    ],
    answer:
        "Accélérer le traitement des dossiers tout en restant dans le cadre légal",
    explanation:
        "La formation à juge unique permet de simplifier et d’accélérer la réponse pénale pour certains délits spécialement listés par la loi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Tribunal correctionnel",
    question:
        "En matière correctionnelle, dans quel délai l’appel doit-il en principe être formé à compter du prononcé du jugement ?",
    options: ["Dans les 24 heures", "Dans les 10 jours", "Dans les 2 mois"],
    answer: "Dans les 10 jours",
    explanation:
        "Le Code de procédure pénale fixe en principe le délai d’appel en matière correctionnelle à 10 jours à compter du jugement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Tribunal correctionnel",
    question:
        "La comparution immédiate devant le tribunal correctionnel suppose notamment :",
    options: [
      "Que l’affaire soit en état d’être jugée et que la peine encourue n’excède pas certains seuils",
      "Que le prévenu soit jugé par défaut",
      "Que le juge d’instruction ait terminé une information de plusieurs mois",
    ],
    answer:
        "Que l’affaire soit en état d’être jugée et que la peine encourue n’excède pas certains seuils",
    explanation:
        "La procédure de comparution immédiate est encadrée : charges suffisantes, affaire en état, et plafond de peine encourue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Cour d’assises",
    question:
        "Lorsque la cour d’assises statue en appel, quelle formation professionnelle la compose, en plus des jurés ?",
    options: [
      "Un président et deux conseillers",
      "Un juge unique",
      "Un président et quatre juges professionnels",
    ],
    answer: "Un président et deux conseillers",
    explanation:
        "La cour est composée d’un président et de deux assesseurs, que la cour statue en premier ressort ou en appel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Cour d’assises",
    question:
        "Lors de la constitution du jury, quel principe fondamental est rappelé par le serment des jurés ?",
    options: [
      "L’obligation de condamner tout accusé traduit devant la cour",
      "La présomption d’innocence et la règle selon laquelle le doute profite à l’accusé",
      "La priorité absolue donnée aux intérêts des victimes",
    ],
    answer:
        "La présomption d’innocence et la règle selon laquelle le doute profite à l’accusé",
    explanation:
        "Le serment rappelle notamment la présomption d’innocence et l’obligation de ne condamner que si l’intime conviction est acquise.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Juridictions d’exception",
    question:
        "Quelle juridiction est compétente pour juger en matière pénale les mineurs de 13 à 18 ans pour les délits et certains crimes ?",
    options: [
      "Le tribunal correctionnel ordinaire",
      "Le tribunal pour enfants",
      "Le tribunal de police",
    ],
    answer: "Le tribunal pour enfants",
    explanation:
        "Le tribunal pour enfants est une juridiction spécialisée qui juge les délits et certains crimes commis par des mineurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Juridictions d’exception",
    question:
        "Les crimes commis par des mineurs de 16 à 18 ans peuvent relever :",
    options: [
      "Exclusivement de la cour d’assises ordinaire",
      "D’une cour d’assises des mineurs",
      "Uniquement du tribunal pour enfants",
    ],
    answer: "D’une cour d’assises des mineurs",
    explanation:
        "Pour certains crimes commis par des mineurs, la compétence appartient à la cour d’assises des mineurs, juridiction criminelle spécialisée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Action civile",
    question:
        "Si la victime ne s’est pas constituée partie civile devant la juridiction pénale, comment pourra-t-elle obtenir réparation ?",
    options: [
      "Elle ne peut plus jamais obtenir réparation",
      "Elle devra saisir la juridiction civile compétente",
      "Le ministère public obtient automatiquement réparation pour elle",
    ],
    answer: "Elle devra saisir la juridiction civile compétente",
    explanation:
        "En l’absence de constitution de partie civile devant le pénal, la victime conserve la possibilité de saisir la juridiction civile pour ses dommages et intérêts.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Sursis à statuer civil",
    question:
        "Lorsqu’une instance civile est engagée alors que des poursuites pénales sont en cours pour les mêmes faits, le juge civil :",
    options: [
      "Doit surseoir à statuer jusqu’à ce que le pénal ait tranché",
      "Doit juger en priorité, le pénal étant suspendu",
      "Ne peut être saisi qu’après la fin du procès pénal",
    ],
    answer: "Doit surseoir à statuer jusqu’à ce que le pénal ait tranché",
    explanation:
        "Selon le principe de primauté du pénal sur le civil, le juge civil sursoit à statuer en attendant la décision pénale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Appels",
    question:
        "Quel est l’effet principal de l’appel sur l’exécution d’une peine d’emprisonnement lorsqu’un prévenu est détenu à l’issue de l’audience correctionnelle ?",
    options: [
      "L’appel fait automatiquement cesser la détention",
      "L’appel ne fait pas obstacle au maintien en détention si la juridiction l’a ordonné",
      "L’appel transforme la détention en contrôle judiciaire",
    ],
    answer:
        "L’appel ne fait pas obstacle au maintien en détention si la juridiction l’a ordonné",
    explanation:
        "L’appel est en principe suspensif de l’exécution de la peine, mais certaines décisions relatives à la détention peuvent continuer à produire effet.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Rôle du ministère public",
    question:
        "Quel est le rôle principal du ministère public devant les juridictions pénales ?",
    options: [
      "Représenter uniquement la victime",
      "Représenter la société et veiller à l’application de la loi pénale",
      "Défendre les intérêts du prévenu",
    ],
    answer:
        "Représenter la société et veiller à l’application de la loi pénale",
    explanation:
        "Le parquet représente la société et exerce l’action publique devant les juridictions pénales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Débats",
    question:
        "En procédure pénale, le principe de publicité des débats signifie que :",
    options: [
      "Les débats doivent toujours être secrets",
      "Les débats sont en principe publics, sauf exceptions prévues par la loi",
      "Seuls les policiers peuvent assister aux audiences",
    ],
    answer:
        "Les débats sont en principe publics, sauf exceptions prévues par la loi",
    explanation:
        "La publicité des débats garantit la transparence de la justice, mais certaines affaires peuvent être jugées à huis clos pour des raisons prévues par les textes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Exécution des peines",
    question:
        "En matière de peines privatives de liberté, quel est l’un des objectifs de l’intervention du juge de l’application des peines (JAP) ?",
    options: [
      "Fixer à nouveau la durée de la peine prononcée par le tribunal",
      "Déterminer les modalités d’exécution et favoriser la réinsertion du condamné",
      "Annuler la condamnation pénale",
    ],
    answer:
        "Déterminer les modalités d’exécution et favoriser la réinsertion du condamné",
    explanation:
        "Le JAP module les conditions d’exécution (semi-liberté, libération conditionnelle, etc.) dans une logique d’individualisation et de réinsertion.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Application des peines",
    question:
        "Le tribunal de l’application des peines (TAP) est compétent notamment pour :",
    options: [
      "Statuer sur la culpabilité de l’auteur",
      "Décider du relèvement de la période de sûreté ou de certaines libérations conditionnelles lourdes",
      "Prononcer de nouvelles condamnations pour des faits non jugés",
    ],
    answer:
        "Décider du relèvement de la période de sûreté ou de certaines libérations conditionnelles lourdes",
    explanation:
        "Le TAP intervient pour des décisions importantes d’aménagement ou d’exécution de la peine qui dépassent les pouvoirs du JAP seul.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Chambre de l’application des peines",
    question:
        "La chambre de l’application des peines de la cour d’appel connaît :",
    options: [
      "Des appels formés contre les décisions du JAP et du TAP",
      "Des appels de tous les jugements de police",
      "Uniquement des pourvois en cassation",
    ],
    answer: "Des appels formés contre les décisions du JAP et du TAP",
    explanation:
        "La chambre de l’application des peines est la juridiction d’appel des décisions relatives à l’application des peines.",
    difficulty: "Moyenne",
  ),

  // ===================== NIVEAU DIFFICILE ====================
  QuizQuestion(
    category: "Juridictions pénales – Compétence territoriale délictuelle",
    question:
        "En matière délictuelle, plusieurs tribunaux correctionnels peuvent être compétents. Laquelle de ces propositions ne constitue pas un critère légal de compétence territoriale ?",
    options: [
      "Le lieu de l’arrestation du prévenu",
      "Le lieu de détention du prévenu pour une autre cause",
      "Le lieu où le prévenu a été scolarisé dans son enfance",
    ],
    answer: "Le lieu où le prévenu a été scolarisé dans son enfance",
    explanation:
        "La compétence peut être fondée sur le lieu de commission, de résidence, d’arrestation ou de détention, mais pas sur des critères personnels comme le lieu de scolarisation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Connexité et indivisibilité",
    question:
        "Lorsque plusieurs infractions sont connexes, quel peut être l’effet en matière de compétence des juridictions pénales ?",
    options: [
      "Chaque infraction doit toujours être jugée séparément devant sa juridiction propre",
      "Une seule juridiction peut être compétente pour juger l’ensemble des infractions connexes",
      "La compétence revient automatiquement à la Cour de cassation",
    ],
    answer:
        "Une seule juridiction peut être compétente pour juger l’ensemble des infractions connexes",
    explanation:
        "La connexité permet de regrouper les infractions devant une même juridiction pour une bonne administration de la justice.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Cour d’assises",
    question:
        "Le nombre de jurés d’assises peut être augmenté pour certaines cours (Paris notamment). Quel est l’objectif principal de cette augmentation ?",
    options: [
      "Permettre un vote plus rapide",
      "Tenir compte du nombre élevé d’affaires et assurer la disponibilité des jurés",
      "Augmenter automatiquement le taux de condamnation",
    ],
    answer:
        "Tenir compte du nombre élevé d’affaires et assurer la disponibilité des jurés",
    explanation:
        "Dans certains départements, la loi prévoit un nombre supérieur de jurés de session pour garantir le bon fonctionnement des assises.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Débats d’assises",
    question:
        "En cour d’assises, quel principe gouverne l’intime conviction des jurés et des magistrats au moment du vote sur la culpabilité ?",
    options: [
      "Ils doivent se fonder uniquement sur les aveux de l’accusé",
      "Ils doivent se prononcer selon leur intime conviction formée au vu des preuves et des débats",
      "Ils doivent d’abord demander l’avis du procureur général",
    ],
    answer:
        "Ils doivent se prononcer selon leur intime conviction formée au vu des preuves et des débats",
    explanation:
        "La décision en matière criminelle repose sur l’intime conviction de chacun des votants, construite à partir des débats.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Majorité de condamnation",
    question:
        "En premier ressort, à la cour d’assises, quelle majorité est nécessaire pour déclarer l’accusé coupable ?",
    options: [
      "La majorité simple des voix",
      "La majorité de 6 voix sur 9 (magistrats + jurés)",
      "L’unanimité des jurés uniquement",
    ],
    answer: "La majorité de 6 voix sur 9 (magistrats + jurés)",
    explanation:
        "La culpabilité est acquise si la majorité qualifiée requise est atteinte, ce qui suppose un certain nombre de voix favorables à la condamnation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – CRPC",
    question:
        "Dans le cadre de la CRPC, si le prévenu accepte la peine proposée par le procureur de la République :",
    options: [
      "L’accord doit encore être homologué par le président du tribunal judiciaire ou un juge délégué",
      "La peine est immédiatement exécutoire sans intervention d’un juge",
      "L’affaire est automatiquement renvoyée devant la cour d’assises",
    ],
    answer:
        "L’accord doit encore être homologué par le président du tribunal judiciaire ou un juge délégué",
    explanation:
        "La CRPC nécessite une homologation judiciaire pour garantir le contrôle de la proportionnalité de la peine et le respect des droits de la défense.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Ordonnance pénale délictuelle",
    question:
        "Dans la procédure d’ordonnance pénale délictuelle, quel est le droit spécifique reconnu au prévenu après notification de l’ordonnance ?",
    options: [
      "Il peut former opposition dans un certain délai pour obtenir un jugement en audience publique",
      "Il doit obligatoirement purger sa peine sans recours",
      "Il doit saisir directement la Cour de cassation",
    ],
    answer:
        "Il peut former opposition dans un certain délai pour obtenir un jugement en audience publique",
    explanation:
        "L’opposition permet au prévenu de contester l’ordonnance pénale et de demander un débat contradictoire devant la juridiction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Application des peines",
    question:
        "La libération conditionnelle d’un condamné à une peine criminelle lourde relève :",
    options: [
      "Du seul directeur de l’établissement pénitentiaire",
      "Du juge de l’application des peines statuant sans débat",
      "Du tribunal de l’application des peines, après débat contradictoire",
    ],
    answer:
        "Du tribunal de l’application des peines, après débat contradictoire",
    explanation:
        "Pour les peines les plus lourdes, la décision de libération conditionnelle relève du TAP, qui statue après débat contradictoire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Suspension de peine",
    question:
        "La suspension de peine pour raison médicale grave (hors période de sûreté) est décidée :",
    options: [
      "Par le garde des Sceaux",
      "Par le juge ou le tribunal de l’application des peines selon la durée de la condamnation",
      "Par la Cour de cassation",
    ],
    answer:
        "Par le juge ou le tribunal de l’application des peines selon la durée de la condamnation",
    explanation:
        "Les textes prévoient des modalités de suspension de peine pour motif médical, décidées par les juridictions de l’application des peines compétentes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Contrainte judiciaire",
    question:
        "La contrainte judiciaire prononcée en cas de non-paiement d’une amende :",
    options: [
      "Éteint la dette pécuniaire une fois la détention exécutée",
      "N’éteint pas la dette pécuniaire, qui reste exigible",
      "Transforme la peine en travail d’intérêt général",
    ],
    answer: "N’éteint pas la dette pécuniaire, qui reste exigible",
    explanation:
        "L’exécution de la contrainte judiciaire ne libère pas le condamné du paiement de sa dette, qui demeure due.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Recours application des peines",
    question:
        "Dans quel délai un pourvoi en cassation peut-il être formé contre un arrêt de la chambre de l’application des peines ?",
    options: [
      "Dans les 5 jours à compter de sa notification",
      "Dans les 10 jours suivant sa lecture en audience publique",
      "Dans le mois suivant la fin de peine du condamné",
    ],
    answer: "Dans les 5 jours à compter de sa notification",
    explanation:
        "Le Code de procédure pénale prévoit un délai court pour se pourvoir contre les décisions de la chambre de l’application des peines.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Primauté du pénal",
    question:
        "Le principe de primauté du pénal sur le civil implique notamment que :",
    options: [
      "Le juge civil peut remettre en cause la qualification pénale retenue par la juridiction répressive",
      "Le juge civil est lié par ce qui a été définitivement jugé au pénal sur l’existence de l’infraction et la culpabilité",
      "Les décisions civiles priment toujours sur les décisions pénales",
    ],
    answer:
        "Le juge civil est lié par ce qui a été définitivement jugé au pénal sur l’existence de l’infraction et la culpabilité",
    explanation:
        "Le juge civil ne peut contredire les constatations pénales définitives sur la matérialité des faits et la culpabilité.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Juridictions pénales – Tribunal de police",
    question:
        "En matière de contraventions, le tribunal de police peut connaître de certaines demandes civiles de la victime. Dans quelle limite principale ?",
    options: [
      "Uniquement si la victime n’est pas constituée partie civile",
      "Dans la limite de sa compétence pénale et tant que la demande dérive directement de l’infraction",
      "Sans aucune limite, quelle que soit la nature du dommage invoqué",
    ],
    answer:
        "Dans la limite de sa compétence pénale et tant que la demande dérive directement de l’infraction",
    explanation:
        "Le tribunal de police peut statuer sur les intérêts civils liés directement à la contravention, dans le cadre de sa compétence pénale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Tribunal de police",
    question:
        "Lorsque le tribunal de police statue en l’absence du prévenu régulièrement cité qui n’a pas comparu, il rend :",
    options: [
      "Un jugement contradictoire à signifier",
      "Un jugement réputé contradictoire",
      "Un jugement par défaut",
    ],
    answer: "Un jugement par défaut",
    explanation:
        "En cas de non-comparution sans excuse valable, la décision est rendue par défaut, avec des conséquences spécifiques en termes d’opposition.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Tribunal correctionnel",
    question:
        "Dans quel cas le tribunal correctionnel, saisi d’un délit, peut-il également juger une contravention ?",
    options: [
      "Jamais, les contraventions doivent toujours être renvoyées au tribunal de police",
      "Uniquement si la contravention a été commise par un mineur",
      "Lorsqu’elle est connexe au délit ou lorsqu’elle a été qualifiée à tort de délit",
    ],
    answer:
        "Lorsqu’elle est connexe au délit ou lorsqu’elle a été qualifiée à tort de délit",
    explanation:
        "Le tribunal correctionnel connaît des contraventions connexes aux délits, et peut requalifier une infraction mal qualifiée sans renvoi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Tribunal correctionnel",
    question:
        "Que se passe-t-il si, devant le tribunal correctionnel, les faits poursuivis sous la qualification de délit constituent en réalité un crime ?",
    options: [
      "Le tribunal correctionnel doit requalifier et prononcer lui-même une peine criminelle",
      "Le tribunal correctionnel se déclare incompétent et renvoie le ministère public à mieux se pourvoir, voire saisit la juridiction compétente",
      "Le tribunal correctionnel prononce automatiquement la relaxe",
    ],
    answer:
        "Le tribunal correctionnel se déclare incompétent et renvoie le ministère public à mieux se pourvoir, voire saisit la juridiction compétente",
    explanation:
        "Le tribunal correctionnel ne peut pas juger un crime : il doit se dessaisir au profit de la juridiction criminelle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Relaxe et acquittement",
    question:
        "Quelle affirmation distingue correctement la relaxe de l’acquittement ?",
    options: [
      "La relaxe est prononcée en matière criminelle, l’acquittement en matière correctionnelle",
      "La relaxe concerne les contraventions et délits, l’acquittement les crimes",
      "La relaxe met fin aux poursuites, l’acquittement n’a aucun effet sur l’action civile",
    ],
    answer:
        "La relaxe concerne les contraventions et délits, l’acquittement les crimes",
    explanation:
        "En terminologie classique, la relaxe est prononcée par les juridictions de police et correctionnelles, l’acquittement par la cour d’assises.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Cour d’assises",
    question:
        "Lorsque plusieurs accusés sont poursuivis pour un même crime, l’un d’eux peut-il être jugé séparément par une autre juridiction ?",
    options: [
      "Oui, si le ministère public en fait la demande écrite",
      "Non, la cour d’assises a plénitude de juridiction pour l’ensemble des accusés renvoyés devant elle",
      "Oui, si l’un des accusés est mineur, il est renvoyé automatiquement devant le tribunal pour enfants",
    ],
    answer:
        "Non, la cour d’assises a plénitude de juridiction pour l’ensemble des accusés renvoyés devant elle",
    explanation:
        "La cour d’assises juge les personnes renvoyées par la décision de mise en accusation, sauf disjonction légale particulière.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Cour d’assises",
    question:
        "Pourquoi la loi prévoit-elle des incompatibilités pour certaines professions (policiers, préfets, etc.) en matière de fonctions de juré ?",
    options: [
      "Pour éviter qu’ils ne fassent trop de déplacements professionnels",
      "Pour garantir l’indépendance, l’impartialité et la neutralité du jury",
      "Parce qu’ils ne sont pas considérés comme citoyens à part entière",
    ],
    answer:
        "Pour garantir l’indépendance, l’impartialité et la neutralité du jury",
    explanation:
        "Les incompatibilités visent à éviter tout risque de partialité ou de confusion de rôles dans le fonctionnement de la justice criminelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Juridictions pour mineurs",
    question:
        "La chambre spécialisée des mineurs de la cour d’appel a pour fonction principale :",
    options: [
      "D’instruire tous les dossiers pénaux concernant les mineurs",
      "De connaître des appels formés contre les décisions du juge des enfants, du tribunal pour enfants et de la cour d’assises des mineurs",
      "De juger en première instance les crimes commis par les mineurs",
    ],
    answer:
        "De connaître des appels formés contre les décisions du juge des enfants, du tribunal pour enfants et de la cour d’assises des mineurs",
    explanation:
        "Cette chambre spécialisée assure le contrôle des décisions rendues par les juridictions pour mineurs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Mineurs",
    question:
        "En matière de peines, quel principe gouverne la réponse pénale à l’égard des mineurs ?",
    options: [
      "Le principe de sévérité maximale pour assurer l’exemplarité",
      "Le principe d’individualisation et de primauté de l’éducatif sur le répressif",
      "Le principe de stricte identité de régime avec les majeurs",
    ],
    answer:
        "Le principe d’individualisation et de primauté de l’éducatif sur le répressif",
    explanation:
        "La justice pénale des mineurs reste fondée sur la notion de protection et d’éducation, tout en permettant des sanctions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Action publique",
    question:
        "Lorsque le ministère public décide de ne pas engager de poursuites, il peut notamment :",
    options: [
      "Classer sans suite, engager une mesure alternative aux poursuites ou proposer une médiation pénale",
      "Prononcer lui-même une peine d’emprisonnement sans juge",
      "Saisir directement la Cour de cassation pour avis",
    ],
    answer:
        "Classer sans suite, engager une mesure alternative aux poursuites ou proposer une médiation pénale",
    explanation:
        "Le parquet dispose d’un large pouvoir d’appréciation de l’opportunité des poursuites et peut recourir à des alternatives prévues par les textes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Action publique",
    question:
        "Dans quel cas l’action publique peut-elle être mise en mouvement par la seule plainte de la victime, sans intervention préalable du ministère public ?",
    options: [
      "En cas de crime flagrant",
      "Lorsque la plainte avec constitution de partie civile saisit directement le juge d’instruction",
      "Jamais, l’action publique appartient exclusivement au ministère public",
    ],
    answer:
        "Lorsque la plainte avec constitution de partie civile saisit directement le juge d’instruction",
    explanation:
        "La plainte avec constitution de partie civile permet à la victime de déclencher une information judiciaire, ce qui met en mouvement l’action publique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Action civile",
    question:
        "Lorsqu’une juridiction pénale relaxe le prévenu, peut-elle néanmoins accorder des dommages et intérêts à la partie civile ?",
    options: [
      "Oui, si elle estime que les faits ont causé un simple préjudice moral",
      "Non, sauf si elle requalifie l’infraction",
      "Oui, si elle estime que les faits ne constituent pas une infraction mais peuvent engager la responsabilité civile",
    ],
    answer:
        "Oui, si elle estime que les faits ne constituent pas une infraction mais peuvent engager la responsabilité civile",
    explanation:
        "La juridiction pénale peut, dans certains cas, juger qu’il n’y a pas infraction pénale mais qu’il existe une faute civile justifiant indemnisation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Voies de recours",
    question:
        "Lorsque le ministère public fait appel d’un jugement de relaxe, quelle est la conséquence pour le prévenu ?",
    options: [
      "Il est immédiatement incarcéré en attente de l’arrêt d’appel",
      "La décision n’est plus définitive et il peut être rejugé en appel, éventuellement condamné",
      "Il ne peut plus être inquiété car la relaxe est définitive",
    ],
    answer:
        "La décision n’est plus définitive et il peut être rejugé en appel, éventuellement condamné",
    explanation:
        "L’appel du parquet remet en cause le caractère définitif de la relaxe ; la cour d’appel peut confirmer ou infirmer la décision.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Voies de recours",
    question: "Le pourvoi en cassation formé contre un arrêt correctionnel :",
    options: [
      "Permet de rejuger totalement les faits",
      "Tend uniquement à faire contrôler la correcte application de la loi par la juridiction d’appel",
      "Est un troisième degré de juridiction pour revisiter l’appréciation des preuves",
    ],
    answer:
        "Tend uniquement à faire contrôler la correcte application de la loi par la juridiction d’appel",
    explanation:
        "La Cour de cassation ne juge pas les faits mais vérifie la conformité juridique de la décision attaquée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Détention provisoire",
    question:
        "En matière criminelle, la détention provisoire est décidée et prolongée :",
    options: [
      "Uniquement par le procureur de la République",
      "Par le juge des libertés et de la détention, sur saisine du juge d’instruction",
      "Par le président du tribunal correctionnel",
    ],
    answer:
        "Par le juge des libertés et de la détention, sur saisine du juge d’instruction",
    explanation:
        "Le JLD statue sur les mesures privatives de liberté pendant l’instruction, sur réquisitions du parquet et demande du juge d’instruction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Détention provisoire",
    question:
        "Parmi ces critères, lequel ne fait pas partie des motifs légaux justifiant la détention provisoire ?",
    options: [
      "Empêcher une fuite de la personne mise en examen",
      "Garantir la conservation des preuves ou des indices matériels",
      "Assurer la décompression psychologique de la personne mise en examen",
    ],
    answer:
        "Assurer la décompression psychologique de la personne mise en examen",
    explanation:
        "Les motifs sont limitativement énumérés par la loi (risque de fuite, réitération, pression sur témoins, maintien de l’ordre public, etc.).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Peines",
    question:
        "Quelle est la différence principale entre une peine principale et une peine complémentaire ?",
    options: [
      "La peine principale doit obligatoirement être une peine privative de liberté",
      "La peine complémentaire ne peut être prononcée que si la peine principale est déjà prévue pour l’infraction",
      "La peine complémentaire remplace systématiquement la peine principale",
    ],
    answer:
        "La peine complémentaire ne peut être prononcée que si la peine principale est déjà prévue pour l’infraction",
    explanation:
        "Les peines complémentaires s’ajoutent ou se substituent dans les conditions prévues, mais supposent un texte les prévoyant pour l’infraction concernée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Exécution des peines",
    question:
        "Qui assure concrètement le recouvrement des amendes pénales une fois la décision devenue exécutoire ?",
    options: [
      "Le juge de l’application des peines lui-même",
      "Le comptable public compétent au nom du procureur de la République",
      "Les services de la préfecture",
    ],
    answer:
        "Le comptable public compétent au nom du procureur de la République",
    explanation:
        "Le Trésor public est chargé du recouvrement, sur la base des extraits transmis par le greffe à la demande du parquet.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Exécution des peines",
    question:
        "Pourquoi l’exécution rapide des peines privatives de liberté est-elle considérée comme un objectif important ?",
    options: [
      "Pour éviter au parquet d’avoir trop de dossiers en cours",
      "Pour garantir l’efficacité et la crédibilité de la réponse pénale, ainsi qu’une meilleure individualisation",
      "Pour remplir au plus vite les établissements pénitentiaires",
    ],
    answer:
        "Pour garantir l’efficacité et la crédibilité de la réponse pénale, ainsi qu’une meilleure individualisation",
    explanation:
        "Une exécution rapide favorise la cohérence entre le jugement et la peine et permet d’organiser au mieux le suivi du condamné.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – JAP",
    question:
        "Lorsque le condamné ne respecte pas ses obligations dans le cadre d’un sursis probatoire, le JAP peut :",
    options: [
      "Prononcer uniquement un rappel à la loi",
      "Révoquer totalement ou partiellement le sursis et ordonner l’exécution de la peine d’emprisonnement",
      "Annuler la condamnation initiale",
    ],
    answer:
        "Révoquer totalement ou partiellement le sursis et ordonner l’exécution de la peine d’emprisonnement",
    explanation:
        "Le JAP dispose de pouvoirs de sanction en cas de manquements aux obligations, pouvant conduire à la révocation du sursis.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – TAP",
    question:
        "Le TAP est saisi pour décider d’un relèvement de la période de sûreté. Quelle est la conséquence principale de ce relèvement ?",
    options: [
      "La peine est automatiquement annulée",
      "Le condamné devient éligible plus tôt à certaines mesures d’aménagement de peine",
      "Le condamné ne peut plus jamais bénéficier d’aucun aménagement",
    ],
    answer:
        "Le condamné devient éligible plus tôt à certaines mesures d’aménagement de peine",
    explanation:
        "La période de sûreté limite l’accès à certains aménagements ; son relèvement permet d’anticiper cet accès sous conditions.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Chambre de l’application des peines",
    question:
        "L’appel de la décision du TAP formé par le ministère public dans les 24 heures :",
    options: [
      "N’a aucun effet sur l’exécution de la mesure accordée",
      "Est suspensif et empêche l’exécution de la mesure tant que la chambre n’a pas statué",
      "Transforme la peine en amende",
    ],
    answer:
        "Est suspensif et empêche l’exécution de la mesure tant que la chambre n’a pas statué",
    explanation:
        "Pour certaines décisions, l’appel du parquet dans un délai très court est expressément suspensif pour préserver l’ordre public.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – CRPC",
    question:
        "Dans une procédure de CRPC, si le prévenu refuse la peine proposée par le procureur :",
    options: [
      "La procédure est close et le parquet ne peut plus poursuivre",
      "Le dossier est renvoyé devant la juridiction de jugement compétente selon la procédure ordinaire",
      "La peine proposée devient automatiquement applicable malgré son refus",
    ],
    answer:
        "Le dossier est renvoyé devant la juridiction de jugement compétente selon la procédure ordinaire",
    explanation:
        "La CRPC repose sur l’acceptation libre et éclairée du prévenu ; en cas de refus, on revient à la voie de jugement classique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Ordonnance pénale",
    question:
        "Pourquoi la procédure d’ordonnance pénale est-elle particulièrement adaptée à certaines infractions routières ou simples délits financiers ?",
    options: [
      "Parce qu’elle permet de juger sans respecter les droits de la défense",
      "Parce qu’elle offre une réponse rapide et simplifiée pour des affaires ne nécessitant pas un débat approfondi",
      "Parce qu’elle supprime tout recours pour le prévenu",
    ],
    answer:
        "Parce qu’elle offre une réponse rapide et simplifiée pour des affaires ne nécessitant pas un débat approfondi",
    explanation:
        "L’ordonnance pénale vise à désengorger les audiences tout en respectant les garanties essentielles (possibilité d’opposition).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Contrainte judiciaire",
    question:
        "Parmi ces condamnations, pour laquelle la contrainte judiciaire est-elle en principe exclue ?",
    options: [
      "Une amende délictuelle de 4 000 €",
      "Une amende contraventionnelle isolée",
      "Une amende criminelle accompagnée d’une peine de prison",
    ],
    answer: "Une amende contraventionnelle isolée",
    explanation:
        "La contrainte judiciaire ne s’applique pas en principe aux seules amendes contraventionnelles : elle vise les condamnations de nature plus grave.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Publicité et huis clos",
    question:
        "Lorsque le huis clos total est ordonné, quelle formule décrit le mieux la publicité du prononcé de la décision ?",
    options: [
      "La décision doit malgré tout être prononcée publiquement, au moins dans son dispositif",
      "La décision doit rester entièrement secrète",
      "La décision est seulement lue aux parties présentes, sans procès-verbal",
    ],
    answer:
        "La décision doit malgré tout être prononcée publiquement, au moins dans son dispositif",
    explanation:
        "Même en cas de huis clos, la loi impose en principe un prononcé public du jugement, sauf exceptions très particulières.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Juridictions pénales – Publicité restreinte",
    question:
        "Dans quels cas une juridiction pénale peut-elle décider de juger une affaire à huis clos ?",
    options: [
      "Pour toutes les infractions routières",
      "Pour protéger l’ordre public, la moralité, ou lorsque les intérêts d’un mineur ou d’une victime l’exigent",
      "Uniquement sur demande du ministère public",
    ],
    answer:
        "Pour protéger l’ordre public, la moralité, ou lorsque les intérêts d’un mineur ou d’une victime l’exigent",
    explanation:
        "La loi prévoit des exceptions au principe de publicité lorsque la protection de certains intérêts l’impose.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Exécution des peines – Administrations",
    question:
        "Les administrations (impôts, douanes…) disposent notamment d’un pouvoir de :",
    options: [
      "Cassation des décisions pénales",
      "Transaction avant ou après jugement",
      "Révocation des juges",
    ],
    answer: "Transaction avant ou après jugement",
    explanation:
        "Le texte indique qu’elles disposent d’un droit de transaction qu’elles peuvent exercer avant ou après jugement.",
    difficulty: "Intermédiaire",
  ),

  // --- 1.1.3 Le ministère public ---
  QuizQuestion(
    category: "Exécution des peines – Ministère public",
    question:
        "À qui appartient-il essentiellement d’assurer l’exécution des sanctions pénales ?",
    options: [
      "Au maire de la commune",
      "Au ministère public",
      "Au président de la République",
    ],
    answer: "Au ministère public",
    explanation:
        "Le texte souligne que c’est au ministère public qu’il appartient d’assurer l’exécution des sanctions pénales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Exécution des peines – Ministère public",
    question:
        "Selon l’Article 707-1 CPP, le ministère public fait exécuter notamment :",
    options: [
      "Uniquement les peines d’amende",
      "Toutes les peines privatives de liberté et celles prévues aux Articles 131-1 à 131-49 CP",
      "Uniquement les peines prononcées par la cour d’assises",
    ],
    answer:
        "Toutes les peines privatives de liberté et celles prévues aux Articles 131-1 à 131-49 CP",
    explanation:
        "Le texte rappelle son rôle pour les peines privatives de liberté et celles listées aux Articles 131-1 à 131-49 du Code pénal.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Exécution des peines – Ministère public",
    question:
        "Le ministère public poursuit aussi l’exécution des sanctions pécuniaires prononcées par :",
    options: [
      "Les autorités administratives indépendantes françaises uniquement",
      "Les autorités compétentes des États membres de l’Union européenne",
      "Le Conseil d’État",
    ],
    answer: "Les autorités compétentes des États membres de l’Union européenne",
    explanation:
        "Le texte vise l’exécution des sanctions pécuniaires prononcées par les autorités compétentes d’autres États membres.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Exécution des peines – Recouvrement pécuniaire",
    question: "Pour les peines pécuniaires, qui assure le recouvrement ?",
    options: [
      "Toujours le greffe du tribunal",
      "Le comptable public compétent, ou l’AGRASC pour certains biens confisqués",
      "Les officiers de police judiciaire",
    ],
    answer:
        "Le comptable public compétent, ou l’AGRASC pour certains biens confisqués",
    explanation:
        "Le texte mentionne le comptable public et l’Agence de gestion et de recouvrement des avoirs saisis et confisqués.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Exécution des peines – Force publique",
    question:
        "Selon l’Article 709 CPP, le procureur de la République et le procureur général peuvent :",
    options: [
      "Réformer une décision de justice",
      "Requérir directement l’assistance de la force publique pour assurer l’exécution des décisions de justice",
      "Modifier la peine prononcée",
    ],
    answer:
        "Requérir directement l’assistance de la force publique pour assurer l’exécution des décisions de justice",
    explanation:
        "L’Article 709 CPP leur permet de requérir directement la force publique pour l’exécution.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Décision définitive – Principe",
    question: "Selon l’Article 708 alinéa 1 CPP, l’exécution a lieu lorsque :",
    options: [
      "La décision est notifiée à la victime",
      "La décision est devenue définitive",
      "Le prévenu est placé en garde à vue",
    ],
    answer: "La décision est devenue définitive",
    explanation:
        "Le texte cite expressément l’Article 708 al. 1 CPP : l’exécution intervient lorsque la décision est définitive.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décision définitive – Opposition",
    question:
        "Lorsque la décision a été rendue par défaut, l’exécution est suspendue :",
    options: [
      "Pendant le délai d’opposition",
      "Pendant 24 heures automatiquement",
      "Jusqu’à l’accord du préfet",
    ],
    answer: "Pendant le délai d’opposition",
    explanation:
        "Le texte précise que la décision rendue par défaut ne peut être exécutée tant que court le délai d’opposition.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décision définitive – Appel",
    question:
        "Quel est le délai d’appel en matière pénale, selon les articles cités (380-9, 498, 547 CPP) ?",
    options: [
      "5 jours",
      "8 jours",
      "10 jours à compter du prononcé de la décision",
    ],
    answer: "10 jours à compter du prononcé de la décision",
    explanation:
        "Le texte rappelle que le délai d’appel est en principe de 10 jours à compter du prononcé, pour les différentes juridictions répressives.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décision définitive – Appel",
    question:
        "Pendant le délai d’appel et l’instance d’appel, il est en principe :",
    options: [
      "Procédé à l’exécution immédiate des peines",
      "Sursis à l’exécution, sauf exceptions",
      "Automatiquement prononcé un non-lieu",
    ],
    answer: "Sursis à l’exécution, sauf exceptions",
    explanation:
        "Le texte mentionne qu’il est généralement sursis à l’exécution, sauf pour certaines mesures (exécution provisoire, maintien en détention…).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Décision définitive – Cassation",
    question: "En principe, le pourvoi en cassation est :",
    options: [
      "Toujours suspensif",
      "Jamais recevable en matière pénale",
      "Non suspensif, sauf cas prévus par la loi",
    ],
    answer: "Non suspensif, sauf cas prévus par la loi",
    explanation:
        "Le texte indique que le pourvoi en cassation n’est en principe pas suspensif, sauf disposition contraire.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Peines privatives de liberté – Rôle du parquet",
    question:
        "Qui doit faire exécuter les peines privatives de liberté prononcées par le tribunal correctionnel ou la cour d’assises ?",
    options: [
      "Le juge de l’application des peines",
      "Le procureur de la République / le parquet",
      "Le président de la cour d’assises",
    ],
    answer: "Le procureur de la République / le parquet",
    explanation:
        "Le texte précise que le ministère public (parquet) doit faire exécuter ces peines.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Peines privatives de liberté – Cour d’assises",
    question:
        "Lorsque la cour d’assises siège au niveau de la cour d’appel, qui assure l’exécution des peines ?",
    options: [
      "Le parquet général",
      "Le préfet",
      "L’administration pénitentiaire seule",
    ],
    answer: "Le parquet général",
    explanation:
        "Le texte indique que, dans ce cas, l’exécution est assurée par le parquet général.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Peines privatives de liberté – Cour d’assises",
    question:
        "Lorsque la cour d’assises siège dans les locaux du tribunal judiciaire, l’exécution des peines est assurée par :",
    options: [
      "Le parquet de ce tribunal",
      "Le juge d’instruction",
      "Le préfet",
    ],
    answer: "Le parquet de ce tribunal",
    explanation:
        "Le texte précise que c’est alors le parquet du tribunal judiciaire qui assure l’exécution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Peines privatives de liberté – Délai d’incarcération",
    question:
        "Quel délai est prescrit par l’instruction générale (Article C 816) pour la mise à exécution de la peine d’emprisonnement ?",
    options: ["8 jours", "15 jours", "1 mois"],
    answer: "15 jours",
    explanation:
        "Le texte indique qu’en pratique, l’instruction générale pour l’application du CPP prescrit la mise à exécution dans un délai de 15 jours.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Peines privatives de liberté – Extrait de décision",
    question:
        "Pour l’exécution d’une peine d’emprisonnement, le greffe établit :",
    options: [
      "Un extrait de la décision exécutoire adressé à l’établissement pénitentiaire",
      "Un mandat d’amener pour les témoins",
      "Une ordonnance de non-lieu",
    ],
    answer:
        "Un extrait de la décision exécutoire adressé à l’établissement pénitentiaire",
    explanation:
        "Le texte mentionne qu’un extrait de la décision exécutoire est adressé à l’établissement pénitentiaire à l’appui de l’écrou.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Peines privatives de liberté – Mise à exécution",
    question:
        "Si le condamné est déjà détenu, comment se fait l’exécution de la nouvelle peine ?",
    options: [
      "Il est nécessairement libéré",
      "L’écrou est régularisé sur place",
      "Un nouveau procès est organisé",
    ],
    answer: "L’écrou est régularisé sur place",
    explanation:
        "Le texte précise que si le condamné est déjà détenu, l’écrou est régularisé sur place.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Peines privatives de liberté – Mise à exécution",
    question: "Si le condamné est libre, le parquet peut :",
    options: [
      "Le relaxer d’office",
      "Le convoquer pour mise à exécution ou délivrer un réquisitoire d’arrestation",
      "Confier l’exécution au juge d’instruction",
    ],
    answer:
        "Le convoquer pour mise à exécution ou délivrer un réquisitoire d’arrestation",
    explanation:
        "Le texte indique ces deux modalités : convocation ou réquisitoire d’arrestation aux forces de l’ordre.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Peines privatives de liberté – Domicile",
    question:
        "L’intrusion au domicile d’un condamné pour exécuter une peine d’emprisonnement est encadrée par :",
    options: [
      "L’Article 716-5 du Code de procédure pénale",
      "L’Article 707-1 CPP",
      "L’Article 131-6 CP",
    ],
    answer: "L’Article 716-5 du Code de procédure pénale",
    explanation:
        "La page mentionne explicitement cet article encadrant la pénétration au domicile pour exécuter la peine.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // 1.4 – PEINES NON PRIVATIVES DE LIBERTÉ
  // ==========================================================

  // --- 1.4.1.1 Les amendes ---
  QuizQuestion(
    category: "Peines non privatives – Amendes",
    question:
        "Les condamnations pécuniaires (amendes, confiscations, réparations, etc.) deviennent exigibles :",
    options: [
      "Dès le prononcé du jugement, quelle que soit sa nature",
      "Dès que la décision les prononçant est devenue exécutoire",
      "Seulement après accord du comptable public",
    ],
    answer: "Dès que la décision les prononçant est devenue exécutoire",
    explanation:
        "Le texte précise que ces condamnations sont exigibles dès que la décision est exécutoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Peines non privatives – Amendes",
    question:
        "Dans quel délai les extraits de jugement ou d’arrêt doivent-ils être adressés au Trésorier principal en vue du recouvrement ?",
    options: [
      "15 jours (25 jours en cas de pourvoi)",
      "35 jours (45 jours en cas de pourvoi en cassation)",
      "60 jours (90 jours en cas de pourvoi)",
    ],
    answer: "35 jours (45 jours en cas de pourvoi en cassation)",
    explanation:
        "La page mentionne un délai de 35 jours, porté à 45 jours en cas de pourvoi en cassation.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Peines non privatives – Amendes",
    question: "En matière d’amende, quelle solution est toujours privilégiée ?",
    options: [
      "L’incarcération immédiate",
      "La remise de peine",
      "Le paiement de l’amende",
    ],
    answer: "Le paiement de l’amende",
    explanation:
        "Le texte précise que le paiement est toujours privilégié, la contrainte judiciaire n’intervenant qu’en défaut de paiement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Peines non privatives – Amendes",
    question:
        "Le défaut total ou partiel de paiement d’une amende peut entraîner :",
    options: [
      "La contrainte judiciaire",
      "La nullité du jugement",
      "La prescription immédiate de la peine",
    ],
    answer: "La contrainte judiciaire",
    explanation:
        "La page indique que le défaut de paiement peut conduire à une incarcération dans le cadre de la contrainte judiciaire (Article 707-1 CPP).",
    difficulty: "Intermédiaire",
  ),

  // --- 1.4.1.2 Les jours-amende ---
  QuizQuestion(
    category: "Peines non privatives – Jours-amende",
    question: "Les jours-amende constituent :",
    options: [
      "Une peine d’emprisonnement ferme",
      "Une peine pécuniaire particulière payable par jour",
      "Une simple mesure de sûreté",
    ],
    answer: "Une peine pécuniaire particulière payable par jour",
    explanation:
        "Le texte décrit les jours-amende comme une peine pécuniaire, l’intéressé s’acquittant d’une somme journalière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Peines non privatives – Jours-amende",
    question: "En cas de non-paiement des jours-amende, le JAP peut :",
    options: [
      "Prononcer automatiquement un non-lieu",
      "Ordonner un emprisonnement pour une durée égale au nombre de jours-amende impayés",
      "Transformer la peine en simple rappel à la loi",
    ],
    answer:
        "Ordonner un emprisonnement pour une durée égale au nombre de jours-amende impayés",
    explanation:
        "Le texte précise que le JAP peut ordonner un emprisonnement correspondant au nombre de jours-amende impayés.",
    difficulty: "Intermédiaire",
  ),

  // --- 1.4.1.3 Autres sanctions (substitution & complémentaires) ---
  QuizQuestion(
    category: "Peines non privatives – Substitution",
    question:
        "Les peines de substitution prévues à l’Article 131-6 du Code pénal comprennent notamment :",
    options: [
      "Uniquement des peines de prison avec sursis",
      "La suspension ou l’annulation du permis de conduire, l’interdiction de détenir une arme, la confiscation d’un objet…",
      "L’interdiction de faire appel",
    ],
    answer:
        "La suspension ou l’annulation du permis de conduire, l’interdiction de détenir une arme, la confiscation d’un objet…",
    explanation:
        "Le texte détaille ces peines de substitution prévues à l’Article 131-6 CP.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Peines non privatives – Complémentaires",
    question:
        "Les peines complémentaires prévues par le Code pénal peuvent inclure :",
    options: [
      "L’augmentation automatique de l’amende",
      "L’interdiction de droits civiques, civils et de famille, la fermeture d’établissement, l’affichage de la décision…",
      "La nomination à une fonction publique",
    ],
    answer:
        "L’interdiction de droits civiques, civils et de famille, la fermeture d’établissement, l’affichage de la décision…",
    explanation:
        "Le texte cite ces exemples de peines complémentaires pouvant aussi se substituer à d’autres peines.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Peines non privatives – Sanction-réparation",
    question:
        "Selon l’Article 131-8-1 du Code pénal, la peine de sanction-réparation consiste à :",
    options: [
      "Remplacer automatiquement toute peine d’emprisonnement",
      "Permettre au condamné d’indemniser la victime (remise en état, versements, etc.)",
      "Supprimer toute responsabilité pénale",
    ],
    answer:
        "Permettre au condamné d’indemniser la victime (remise en état, versements, etc.)",
    explanation:
        "La page rappelle que la sanction-réparation est une peine permettant d’indemniser la victime.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Peines non privatives – Personnes morales",
    question: "Les personnes morales peuvent être condamnées :",
    options: [
      "Uniquement à des avertissements",
      "À des amendes et diverses peines complémentaires",
      "Uniquement à des travaux d’intérêt général",
    ],
    answer: "À des amendes et diverses peines complémentaires",
    explanation:
        "Le texte précise qu’elles peuvent être condamnées à des amendes et à plusieurs peines complémentaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Peines non privatives – Personnes morales",
    question:
        "En matière d’amendes, le recouvrement pour les personnes morales :",
    options: [
      "Suit les mêmes règles que pour les personnes physiques",
      "N’est jamais possible",
      "Est confié uniquement au juge civil",
    ],
    answer: "Suit les mêmes règles que pour les personnes physiques",
    explanation:
        "La page indique que le recouvrement s’effectue comme pour les personnes physiques, sauf pour la contrainte judiciaire qui ne leur est pas applicable.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Peines non privatives – Personnes morales",
    question: "La contrainte judiciaire :",
    options: [
      "S’applique aussi aux personnes morales",
      "Ne s’applique pas aux personnes morales",
      "S’applique automatiquement dès qu’une amende est prononcée",
    ],
    answer: "Ne s’applique pas aux personnes morales",
    explanation:
        "Le texte précise que la contrainte judiciaire ne s’applique pas aux personnes morales.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // CHAPITRE 2 – CONTRAINTE JUDICIAIRE
  // ==========================================================
  QuizQuestion(
    category: "Contrainte judiciaire – Définition",
    question: "La contrainte judiciaire est définie comme :",
    options: [
      "Une nouvelle peine principale",
      "Une voie d’exécution permettant d’incarcérer le condamné en cas d’inexécution volontaire d’une condamnation pécuniaire",
      "Une simple mesure de sûreté sans privation de liberté",
    ],
    answer:
        "Une voie d’exécution permettant d’incarcérer le condamné en cas d’inexécution volontaire d’une condamnation pécuniaire",
    explanation:
        "Le texte la définit ainsi, comme succédant à l’ancienne contrainte par corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire – Base légale",
    question:
        "Quel article du Code de procédure pénale consacre le rôle du JAP pour ordonner la contrainte judiciaire ?",
    options: ["Article 707-1 CPP", "Article 749 CPP", "Article 761-1 CPP"],
    answer: "Article 749 CPP",
    explanation:
        "La page renvoie explicitement à l’Article 749 CPP pour la contrainte judiciaire.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire – Conditions",
    question:
        "Parmi les conditions de mise en œuvre de la contrainte judiciaire, on trouve :",
    options: [
      "Une simple erreur matérielle dans le jugement",
      "L’inexécution volontaire d’une condamnation pécuniaire",
      "L’absence de jugement définitif",
    ],
    answer: "L’inexécution volontaire d’une condamnation pécuniaire",
    explanation:
        "C’est l’une des conditions essentielles rappelées par le texte.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire – Conditions",
    question: "La contrainte judiciaire concerne les amendes :",
    options: [
      "Prononcées pour un crime ou un délit puni d’emprisonnement",
      "Prononcées uniquement pour les contraventions de 1re classe",
      "Jamais prononcées par les juridictions pénales",
    ],
    answer: "Prononcées pour un crime ou un délit puni d’emprisonnement",
    explanation:
        "Le texte prévoit cette condition de gravité pour que la contrainte judiciaire puisse s’appliquer.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire – Exclusion",
    question: "La contrainte judiciaire ne s’applique pas lorsque :",
    options: [
      "Une peine d’amende contraventionnelle est seule encourue",
      "L’amende dépasse un million d’euros",
      "Il y a plusieurs condamnés",
    ],
    answer: "Une peine d’amende contraventionnelle est seule encourue",
    explanation:
        "La page précise que la contrainte judiciaire ne s’applique pas dans cette hypothèse.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire – Personnes concernées",
    question: "La contrainte judiciaire ne peut s’exercer que contre :",
    options: [
      "Tout membre de la famille du condamné",
      "Le délinquant dont la culpabilité a été judiciairement constatée (auteur, co-auteur ou complice)",
      "Les témoins du procès",
    ],
    answer:
        "Le délinquant dont la culpabilité a été judiciairement constatée (auteur, co-auteur ou complice)",
    explanation:
        "Le texte insiste sur cette limitation de la contrainte judiciaire.",
    difficulty: "Facile",
  ),

  // --- 2.4 Causes d’exemption ---
  QuizQuestion(
    category: "Contrainte judiciaire – Exemption",
    question:
        "Selon l’Article 751 CPP, la contrainte judiciaire ne peut être prononcée contre :",
    options: [
      "Les personnes morales",
      "Les mineurs de moins de 18 ans",
      "Les fonctionnaires de police",
    ],
    answer: "Les mineurs de moins de 18 ans",
    explanation:
        "Le texte précise que la minorité pénale (< 18 ans) constitue une cause d’exemption.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire – Exemption",
    question:
        "Toujours selon l’Article 751 CPP, la contrainte judiciaire ne peut être exercée contre :",
    options: [
      "Les débiteurs âgés d’au moins 65 ans à l’époque des faits",
      "Les débiteurs âgés de plus de 21 ans",
      "Les débiteurs n’ayant pas de domicile fixe",
    ],
    answer: "Les débiteurs âgés d’au moins 65 ans à l’époque des faits",
    explanation:
        "L’âge d’au moins 65 ans à l’époque des faits constitue une cause d’exemption.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire – Insolvabilité",
    question:
        "Selon l’Article 752 CPP, la contrainte judiciaire ne peut être exercée contre :",
    options: [
      "Les condamnés qui justifient par tout moyen de leur insolvabilité",
      "Les fonctionnaires d’État",
      "Les personnes morales de droit public",
    ],
    answer: "Les condamnés qui justifient par tout moyen de leur insolvabilité",
    explanation:
        "L’insolvabilité prouvée est expressément une cause d’exemption.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire – Époux",
    question:
        "L’Article 753 CPP interdit d’exercer simultanément la contrainte judiciaire contre :",
    options: [
      "Deux associés de société",
      "Deux époux, même en cas de condamnations différentes",
      "Deux colocataires",
    ],
    answer: "Deux époux, même en cas de condamnations différentes",
    explanation:
        "La page rappelle cette protection : la contrainte ne peut être exercée simultanément contre les deux époux.",
    difficulty: "Intermédiaire",
  ),

  // --- 2.5 Procédure ---
  QuizQuestion(
    category: "Contrainte judiciaire – Procédure",
    question:
        "Avant toute incarcération sous contrainte judiciaire, la partie poursuivante doit :",
    options: [
      "Saisir la Cour de cassation",
      "Signifier un commandement de payer sous peine de contrainte judiciaire",
      "Organiser une expertise médicale",
    ],
    answer:
        "Signifier un commandement de payer sous peine de contrainte judiciaire",
    explanation: "C’est l’étape du commandement préalable, décrite au § 2.5.1.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire – Demande d’incarcération",
    question:
        "Si, dans l’année de la signification du commandement, le condamné n’a pas payé, le procureur de la République peut :",
    options: [
      "Saisir le juge de l’application des peines pour qu’il prononce la contrainte judiciaire",
      "Faire directement incarcérer le condamné sans juge",
      "Saisir le tribunal administratif",
    ],
    answer:
        "Saisir le juge de l’application des peines pour qu’il prononce la contrainte judiciaire",
    explanation:
        "La page explique que le procureur requiert le JAP, la procédure se déroulant en débat contradictoire (Article 712-6 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire – Durée",
    question:
        "La contrainte judiciaire est exclue lorsque le montant de l’amende est :",
    options: [
      "Supérieur à 500 €",
      "Inférieur à 2 000 €",
      "Supérieur à 100 000 €",
    ],
    answer: "Inférieur à 2 000 €",
    explanation:
        "Le texte mentionne qu’en dessous de 2 000 €, la contrainte judiciaire est exclue.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire – Durée maximale",
    question:
        "En matière de trafic de stupéfiants, la durée maximale de contrainte judiciaire peut être portée à :",
    options: ["3 mois", "6 mois", "Un an"],
    answer: "Un an",
    explanation:
        "La page renvoie à l’Article 706-31 alinéa 3 CPP qui permet d’aller jusqu’à un an.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire – Fin",
    question:
        "La libération anticipée en cas de contrainte judiciaire peut intervenir lorsque le débiteur :",
    options: [
      "Change de domicile",
      "S’acquitte de sa dette, verse un acompte suffisant ou fournit une caution valable",
      "Fait appel de la décision",
    ],
    answer:
        "S’acquitte de sa dette, verse un acompte suffisant ou fournit une caution valable",
    explanation:
        "Le texte mentionne ces cas de libération, mais précise que la dette subsiste malgré l’exécution de la contrainte (Article 761-1 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire – Dette",
    question:
        "Après l’exécution de la contrainte judiciaire, la dette pécuniaire :",
    options: [
      "Est éteinte",
      "Subsiste",
      "Est automatiquement réduite de moitié",
    ],
    answer: "Subsiste",
    explanation:
        "La page insiste sur le fait que la dette subsiste malgré l’exécution de la contrainte (Article 761-1 CPP).",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // CHAPITRE 3 – JURIDICTIONS DE L’APPLICATION DES PEINES
  // ==========================================================
  QuizQuestion(
    category: "Juridictions de l’application – Juridictionnalisation",
    question:
        "La loi n° 2000-516 du 15 juin 2000 a prévu la juridictionnalisation des décisions du JAP pour notamment :",
    options: [
      "La détention provisoire uniquement",
      "La semi-liberté, le placement à l’extérieur, le fractionnement et la suspension des peines, la libération conditionnelle",
      "La nomination des magistrats",
    ],
    answer:
        "La semi-liberté, le placement à l’extérieur, le fractionnement et la suspension des peines, la libération conditionnelle",
    explanation:
        "La page cite précisément ces mesures comme désormais prises après débat contradictoire.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Juridictions de l’application – Juridictionnalisation",
    question: "La loi du 9 mars 2004 a :",
    options: [
      "Supprimé le juge de l’application des peines",
      "Clarifié les règles relatives à l’application des peines et renforcé la juridictionnalisation du milieu ouvert",
      "Supprimé toute voie de recours",
    ],
    answer:
        "Clarifié les règles relatives à l’application des peines et renforcé la juridictionnalisation du milieu ouvert",
    explanation: "C’est ce que rappelle le texte pour cette loi importante.",
    difficulty: "Intermédiaire",
  ),

  // --- 3.1.1 Le JAP ---
  QuizQuestion(
    category: "JAP – Organisation",
    question:
        "Selon l’Article 712-2 CPP, où exerce-t-on les fonctions de juge de l’application des peines (JAP) ?",
    options: [
      "Dans chaque tribunal judiciaire",
      "Uniquement dans les cours d’appel",
      "Uniquement dans les tribunaux de police",
    ],
    answer: "Dans chaque tribunal judiciaire",
    explanation:
        "La page indique qu’un ou plusieurs magistrats du siège exercent ces fonctions dans chaque tribunal judiciaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "JAP – Rôle",
    question: "Le juge de l’application des peines fixe principalement :",
    options: [
      "Les règles de procédure civile",
      "Les modalités d’exécution des peines privatives ou restrictives de liberté et en contrôle les conditions d’application",
      "Les montants des amendes fiscales",
    ],
    answer:
        "Les modalités d’exécution des peines privatives ou restrictives de liberté et en contrôle les conditions d’application",
    explanation:
        "C’est le cœur de la compétence du JAP tel que décrit par le texte.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "JAP – Milieu fermé",
    question: "En milieu fermé, le JAP intervient notamment pour :",
    options: [
      "Les jugements de culpabilité",
      "Le placement à l’extérieur, la semi-liberté, la suspension ou le fractionnement des peines, la détention à domicile sous surveillance électronique, la libération conditionnelle",
      "Les recours devant la Cour de cassation",
    ],
    answer:
        "Le placement à l’extérieur, la semi-liberté, la suspension ou le fractionnement des peines, la détention à domicile sous surveillance électronique, la libération conditionnelle",
    explanation: "La page liste ces mesures relevant du JAP en milieu fermé.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "JAP – Milieu ouvert",
    question: "En milieu ouvert, selon l’Article 712-6 CPP, le JAP :",
    options: [
      "Détermine les conditions d’exécution de la peine en fonction de la situation du condamné",
      "Prononce la culpabilité ou l’innocence",
      "Gère uniquement les amendes contraventionnelles",
    ],
    answer:
        "Détermine les conditions d’exécution de la peine en fonction de la situation du condamné",
    explanation:
        "Le texte précise que cela concerne par exemple le sursis probatoire, le TIG, le suivi socio-judiciaire, etc.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "JAP – Pouvoirs",
    question: "Parmi les pouvoirs du JAP, on peut citer :",
    options: [
      "La révocation ou le retrait de mesures en cas de non-respect des obligations",
      "La rédaction des lois pénales",
      "La nomination des procureurs",
    ],
    answer:
        "La révocation ou le retrait de mesures en cas de non-respect des obligations",
    explanation:
        "Le texte indique que le JAP peut révoquer ou retirer les mesures prises sur le fondement des Articles 712-6 et 712-7 CPP (Article 712-20 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "JAP – Victime",
    question: "Selon l’Article 712-16-1 CPP, le JAP peut :",
    options: [
      "Informer la victime ou la partie civile de ses droits et lui permettre de présenter des observations",
      "Annuler la condamnation pénale",
      "Supprimer les intérêts civils",
    ],
    answer:
        "Informer la victime ou la partie civile de ses droits et lui permettre de présenter des observations",
    explanation: "Ce pouvoir est expressément mentionné dans la page.",
    difficulty: "Intermédiaire",
  ),

  // --- 3.1.2 Tribunal de l’application des peines (TAP) ---
  QuizQuestion(
    category: "TAP – Organisation",
    question:
        "Selon l’Article 712-3 CPP, un tribunal de l’application des peines (TAP) est établi :",
    options: [
      "Dans chaque tribunal judiciaire",
      "Dans le ressort de chaque cour d’appel",
      "Uniquement à Paris",
    ],
    answer: "Dans le ressort de chaque cour d’appel",
    explanation:
        "La page précise que le TAP est établi dans le ressort de chaque cour d’appel.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "TAP – Composition",
    question: "Le TAP est composé :",
    options: [
      "D’un président et de deux assesseurs, désignés parmi les JAP du ressort",
      "D’un jury populaire de 6 personnes",
      "Uniquement d’un juge unique",
    ],
    answer:
        "D’un président et de deux assesseurs, désignés parmi les JAP du ressort",
    explanation:
        "La page renvoie à l’Article 712-10 al. 4 CPP qui fixe cette composition.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "TAP – Compétence",
    question: "Le TAP est compétent notamment pour :",
    options: [
      "Les jugements de culpabilité",
      "Les décisions relatives au relèvement de la période de sûreté, à la libération conditionnelle des condamnés à plus de 10 ans, à certaines suspensions de peine",
      "Les litiges civils de voisinage",
    ],
    answer:
        "Les décisions relatives au relèvement de la période de sûreté, à la libération conditionnelle des condamnés à plus de 10 ans, à certaines suspensions de peine",
    explanation:
        "La page cite ces exemples de compétences du TAP (Article 712-11 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "TAP – Voies de recours",
    question: "Les décisions du TAP sont :",
    options: [
      "Non exécutoires tant que les voies de recours ne sont pas épuisées",
      "Exécutoires par provision, avec appel possible",
      "Toujours définitives et insusceptibles de recours",
    ],
    answer: "Exécutoires par provision, avec appel possible",
    explanation:
        "Le texte précise qu’elles sont exécutoires par provision et peuvent faire l’objet d’un appel.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "TAP – Appel du ministère public",
    question:
        "Lorsque l’appel du ministère public contre une décision du TAP est formé dans les 24 heures :",
    options: [
      "Il est irrecevable",
      "Il est suspensif",
      "Il est transmis directement à la Cour de cassation",
    ],
    answer: "Il est suspensif",
    explanation:
        "La page précise cette particularité : l’appel du ministère public dans les 24 h est suspensif.",
    difficulty: "Difficile",
  ),

  // --- 3.2 Chambre de l’application des peines ---
  QuizQuestion(
    category: "Chambre de l’application – Compétence",
    question:
        "La chambre de l’application des peines de la cour d’appel connaît :",
    options: [
      "Des appels formés contre les décisions du JAP et du TAP",
      "Uniquement des appels contre les jugements de police",
      "Uniquement des questions de compétence territoriale",
    ],
    answer: "Des appels formés contre les décisions du JAP et du TAP",
    explanation:
        "La page renvoie à l’Article 712-13 CPP pour cette compétence.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Chambre de l’application – Composition",
    question: "La chambre de l’application des peines est composée :",
    options: [
      "D’un président et de deux conseillers",
      "D’un juge unique",
      "D’un président, d’un juré et d’un greffier",
    ],
    answer: "D’un président et de deux conseillers",
    explanation:
        "La page précise cette composition, pouvant être complétée dans certains cas par deux responsables associatifs.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Chambre de l’application – Compléments",
    question:
        "Pour certains jugements visés à l’Article 712-7 CPP, la chambre de l’application peut être complétée par :",
    options: [
      "Deux députés",
      "Un responsable d’association de réinsertion et un responsable d’association d’aide aux victimes",
      "Deux avocats commis d’office",
    ],
    answer:
        "Un responsable d’association de réinsertion et un responsable d’association d’aide aux victimes",
    explanation:
        "Le texte mentionne expressément cette possibilité de composition élargie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Chambre de l’application – Décisions",
    question: "La chambre de l’application des peines statue :",
    options: [
      "Par ordonnance non motivée",
      "Par arrêt motivé après débat contradictoire",
      "Par simple note interne",
    ],
    answer: "Par arrêt motivé après débat contradictoire",
    explanation:
        "La page le rappelle et mentionne aussi la possibilité d’un pourvoi en cassation non suspensif.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Chambre de l’application – Pourvoi",
    question:
        "Les arrêts de la chambre de l’application des peines peuvent faire l’objet :",
    options: [
      "D’un pourvoi en cassation non suspensif dans les 5 jours de leur notification",
      "D’un appel devant le tribunal correctionnel",
      "D’aucun recours",
    ],
    answer:
        "D’un pourvoi en cassation non suspensif dans les 5 jours de leur notification",
    explanation:
        "La page renvoie à l’Article 712-15 CPP, qui prévoit ce délai et le caractère non suspensif du pourvoi.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes généraux — Tribunal",
    question:
        "Que représente principalement le tribunal dans l’ordre judiciaire ?",
    options: [
      "Un lieu uniquement administratif",
      "Le lieu où sont sanctionnées les personnes ayant violé la loi et où les personnes en conflit viennent chercher justice",
      "Un organe chargé uniquement de la rédaction des lois",
    ],
    answer:
        "Le lieu où sont sanctionnées les personnes ayant violé la loi et où les personnes en conflit viennent chercher justice",
    explanation:
        "Le texte précise que le tribunal est le lieu où sont sanctionnées les personnes qui ont violé la loi et où les personnes en conflit viennent chercher justice.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes généraux — Types de tribunaux",
    question: "Selon la page, selon quoi les tribunaux sont-ils organisés ?",
    options: [
      "Uniquement selon la compétence géographique",
      "Selon la nature et la gravité des litiges qui leur sont soumis",
      "Selon l’âge des justiciables",
    ],
    answer: "Selon la nature et la gravité des litiges qui leur sont soumis",
    explanation:
        "Le texte indique qu’il existe plusieurs catégories de tribunaux organisés selon la nature et la gravité des litiges.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes généraux — Ordre administratif",
    question:
        "Quelles juridictions règlent les litiges entre les citoyens et les pouvoirs publics ?",
    options: [
      "Les tribunaux de l’ordre administratif",
      "Les tribunaux de commerce",
      "Les tribunaux de police",
    ],
    answer: "Les tribunaux de l’ordre administratif",
    explanation:
        "Les litiges entre les citoyens et les pouvoirs publics relèvent des tribunaux de l’ordre administratif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes généraux — Ordre judiciaire",
    question: "Dans quels cas les tribunaux judiciaires sont-ils compétents ?",
    options: [
      "En cas de litige entre citoyens et administration",
      "En cas de litiges entre personnes ou d’atteintes à la société",
      "Uniquement pour les contraventions",
    ],
    answer: "En cas de litiges entre personnes ou d’atteintes à la société",
    explanation:
        "Le texte précise que les tribunaux judiciaires sont compétents en cas de litiges entre les personnes ou d’atteintes portées à la société.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes généraux — Juridictions judiciaires",
    question: "Les tribunaux judiciaires comprennent :",
    options: [
      "Uniquement des juridictions pénales",
      "Uniquement des juridictions civiles",
      "Des juridictions civiles et des juridictions pénales",
    ],
    answer: "Des juridictions civiles et des juridictions pénales",
    explanation:
        "Le texte précise que les tribunaux judiciaires comprennent des juridictions civiles et des juridictions pénales.",
    difficulty: "Facile",
  ),

  // ==========================================================
  // JURIDICTIONS PÉNALES — DROIT COMMUN / EXCEPTION
  // ==========================================================
  QuizQuestion(
    category: "Juridictions pénales — Typologie",
    question: "Parmi les juridictions pénales, on distingue principalement :",
    options: [
      "Les juridictions de droit commun et les juridictions d’exception",
      "Les juridictions parisiennes et provinciales",
      "Les juridictions de première instance et de cassation",
    ],
    answer: "Les juridictions de droit commun et les juridictions d’exception",
    explanation:
        "La page indique qu’il faut distinguer les juridictions de droit commun des juridictions d’exception.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Juridictions pénales — Droit commun",
    question: "Les juridictions de droit commun sont compétentes pour :",
    options: [
      "Toutes les infractions sans exception",
      "Toutes les infractions d’une catégorie déterminée, sauf celles dont un texte spécial leur retire la connaissance",
      "Uniquement les crimes",
    ],
    answer:
        "Toutes les infractions d’une catégorie déterminée, sauf celles dont un texte spécial leur retire la connaissance",
    explanation:
        "Le texte précise que les juridictions de droit commun jugent toutes les infractions d’une catégorie déterminée, sauf retrait par un texte spécial.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Juridictions pénales — Exception",
    question: "La compétence des juridictions d’exception est :",
    options: [
      "Générale pour toutes les infractions",
      "Déterminée par la loi de manière étroite",
      "Limitée aux contraventions de 1re classe uniquement",
    ],
    answer: "Déterminée par la loi de manière étroite",
    explanation:
        "Les juridictions d’exception ont une compétence d’attribution étroitement délimitée par la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Juridictions pénales — Exception",
    question:
        "La compétence des juridictions d’exception peut être déterminée :",
    options: [
      "Uniquement par la nature des infractions",
      "Uniquement par la qualité de la victime",
      "Par la nature des infractions ou par la qualité des auteurs (ex : mineurs)",
    ],
    answer:
        "Par la nature des infractions ou par la qualité des auteurs (ex : mineurs)",
    explanation:
        "Le texte mentionne que la compétence est limitée soit en raison de la nature des infractions, soit en raison de la qualité des auteurs (mineurs…).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Juridictions pénales — Droit commun",
    question:
        "Parmi les juridictions suivantes, lesquelles sont citées comme juridictions pénales de droit commun ?",
    options: [
      "Tribunal de police, tribunal correctionnel, cour d’assises",
      "Conseil d’État, tribunal administratif, cour des comptes",
      "Tribunal des pensions, tribunal paritaire des baux ruraux",
    ],
    answer: "Tribunal de police, tribunal correctionnel, cour d’assises",
    explanation:
        "La page cite expressément le tribunal de police, le tribunal correctionnel et la cour d’assises comme juridictions de droit commun.",
    difficulty: "Facile",
  ),

  // ==========================================================
  // TRIBUNAL DE POLICE — ORGANISATION
  // ==========================================================
  QuizQuestion(
    category: "Tribunal de police — Textes",
    question:
        "Par quels articles le tribunal de police est-il principalement régi ?",
    options: [
      "Articles 381 à 495-25 du CPP",
      "Articles 521 à 549 du CPP",
      "Articles 231 à 380-15 du CPP",
    ],
    answer: "Articles 521 à 549 du CPP",
    explanation:
        "La page indique que le tribunal de police est régi principalement par les Articles 521 à 549 du Code de procédure pénale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal de police — Organisation",
    question:
        "Selon l’Article 523 CPP, par quels membres est constitué le tribunal de police ?",
    options: [
      "Un président, un jury populaire et un greffier",
      "Un juge du tribunal judiciaire, un officier du ministère public et un greffier",
      "Trois juges professionnels",
    ],
    answer:
        "Un juge du tribunal judiciaire, un officier du ministère public et un greffier",
    explanation:
        "La page reprend l’Article 523 CPP : un juge du tribunal judiciaire, un officier du ministère public et un greffier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal de police — Ministère public",
    question:
        "Pour les contraventions de 5ᵉ classe ne relevant pas de l’amende forfaitaire, qui remplit obligatoirement les fonctions du ministère public ?",
    options: [
      "Le maire",
      "Le procureur de la République près le tribunal judiciaire",
      "Le préfet de département",
    ],
    answer: "Le procureur de la République près le tribunal judiciaire",
    explanation:
        "Le texte rappelle qu’il remplit obligatoirement les fonctions du ministère public pour ces contraventions (Article 45 al. 1 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal de police — Remplaçants",
    question:
        "En cas d’empêchement du commissaire de police, qui désigne les remplaçants pour un an ?",
    options: [
      "Le président du tribunal judiciaire",
      "Le préfet",
      "Le procureur général",
    ],
    answer: "Le procureur général",
    explanation:
        "La page précise que le procureur général désigne, pour une année entière, les remplaçants parmi certains officiers de police (Article 46 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal de police — Remplaçants",
    question:
        "Parmi qui le procureur général choisit-il les remplaçants du commissaire de police ?",
    options: [
      "Les maires et adjoints au maire",
      "Les commissaires et les commandants ou capitaines de police du ressort",
      "Les gendarmes et militaires de carrière",
    ],
    answer:
        "Les commissaires et les commandants ou capitaines de police du ressort",
    explanation:
        "Le texte mentionne expressément ces catégories de policiers en résidence dans le ressort du tribunal judiciaire.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal de police — Infractions forestières",
    question:
        "Pour les infractions forestières, qui exerce les fonctions du ministère public ?",
    options: [
      "Le procureur de la République uniquement",
      "Le directeur régional de l’administration chargée des forêts ou le fonctionnaire qu’il désigne",
      "Le maire de la commune",
    ],
    answer:
        "Le directeur régional de l’administration chargée des forêts ou le fonctionnaire qu’il désigne",
    explanation:
        "La page rappelle que, pour ces infractions, les fonctions du ministère public sont dévolues au directeur régional des forêts (Article 46 CPP).",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // TRIBUNAL DE POLICE — COMPÉTENCE
  // ==========================================================
  QuizQuestion(
    category: "Tribunal de police — Compétence matérielle",
    question:
        "Selon l’Article 521 CPP, le tribunal de police est compétent pour juger :",
    options: ["Tous les délits", "Toutes les contraventions", "Les crimes"],
    answer: "Toutes les contraventions",
    explanation:
        "La page indique clairement que le tribunal de police est compétent pour juger toutes les contraventions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal de police — Compétence territoriale",
    question:
        "Selon l’Article 522 al. 1 CPP, quel tribunal de police est compétent ?",
    options: [
      "Uniquement celui du lieu de résidence de la victime",
      "Celui du lieu de commission ou de constatation de l’infraction, ou celui de la résidence du prévenu",
      "Uniquement celui du siège de la cour d’appel",
    ],
    answer:
        "Celui du lieu de commission ou de constatation de l’infraction, ou celui de la résidence du prévenu",
    explanation:
        "La compétence territoriale est ainsi définie par l’Article 522 al. 1 CPP.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal de police — Transports routiers",
    question:
        "Pour certaines infractions relatives, par exemple, au chargement ou à l’équipement des véhicules, quel tribunal de police est compétent ?",
    options: [
      "Celui du lieu de résidence de la victime",
      "Celui du siège de l’entreprise détentrice du véhicule",
      "Celui du ministère public",
    ],
    answer: "Celui du siège de l’entreprise détentrice du véhicule",
    explanation:
        "L’Article 522 al. 2 CPP prévoit la compétence du tribunal du siège de l’entreprise détentrice du véhicule dans ces hypothèses.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal de police — Mineurs",
    question:
        "Les contraventions de 5ᵉ classe commises par des mineurs sont jugées :",
    options: [
      "Par le tribunal de police",
      "Par les juridictions pour enfants",
      "Par le tribunal correctionnel",
    ],
    answer: "Par les juridictions pour enfants",
    explanation:
        "La page indique que le tribunal de police n’est pas compétent pour les contraventions de 5ᵉ classe commises par des mineurs (CJPM L.423-1).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal de police — Mineurs",
    question:
        "Les contraventions des 4 premières classes commises par des mineurs relèvent :",
    options: [
      "Du tribunal de police",
      "De la cour d’assises",
      "Uniquement du tribunal pour enfants",
    ],
    answer: "Du tribunal de police",
    explanation:
        "La page précise que les 4 premières classes commises par des mineurs relèvent encore du tribunal de police (CJPM L.423-1).",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // TRIBUNAL DE POLICE — MODES DE SAISINE
  // ==========================================================
  QuizQuestion(
    category: "Tribunal de police — Saisine",
    question: "Les modes de saisine du tribunal de police sont définis par :",
    options: ["L’Article 381 CPP", "L’Article 531 CPP", "L’Article 231 CPP"],
    answer: "L’Article 531 CPP",
    explanation:
        "La page mentionne que les modes de saisine sont définis à l’Article 531 du Code de procédure pénale.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal de police — Saisine",
    question: "La citation directe devant le tribunal de police consiste à :",
    options: [
      "Envoyer une simple lettre au parquet",
      "Faire citer l’auteur d’une contravention par huissier directement devant le tribunal",
      "Faire interpeller le prévenu sans convocation",
    ],
    answer:
        "Faire citer l’auteur d’une contravention par huissier directement devant le tribunal",
    explanation:
        "La page décrit la citation directe comme une citation par huissier directement devant le tribunal de police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal de police — Saisine",
    question:
        "La convocation en justice devant le tribunal de police peut être notifiée par :",
    options: [
      "Uniquement le procureur général",
      "Un greffier, un OPJ/APJ, un assistant d’enquête, un fonctionnaire de l’article 28 ou un délégué/ médiateur du procureur",
      "Uniquement un huissier de justice",
    ],
    answer:
        "Un greffier, un OPJ/APJ, un assistant d’enquête, un fonctionnaire de l’article 28 ou un délégué/ médiateur du procureur",
    explanation:
        "La page détaille les différents intervenants habilités à notifier la convocation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Tribunal de police — Saisine",
    question:
        "Lorsque le prévenu est détenu, la convocation en justice devant le tribunal de police est notifiée par :",
    options: [
      "Le directeur de l’administration pénitentiaire",
      "Le chef de l’établissement pénitentiaire",
      "Le maire de la commune",
    ],
    answer: "Le chef de l’établissement pénitentiaire",
    explanation:
        "Le texte précise que, si le prévenu est détenu, la convocation est notifiée par le chef de l’établissement pénitentiaire.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal de police — Saisine",
    question:
        "Parmi ces modes, lequel est aussi un mode de saisine du tribunal de police ?",
    options: [
      "Comparution volontaire",
      "Saisine d’office du juge d’instruction",
      "Pourvoi en cassation",
    ],
    answer: "Comparution volontaire",
    explanation:
        "La page cite la comparution volontaire parmi les modes de saisine du tribunal de police.",
    difficulty: "Facile",
  ),

  // ==========================================================
  // TRIBUNAL CORRECTIONNEL — ORGANISATION
  // ==========================================================
  QuizQuestion(
    category: "Tribunal correctionnel — Textes",
    question: "Par quels articles le tribunal correctionnel est-il régi ?",
    options: [
      "Articles 521 à 549 CPP",
      "Articles 381 à 495-25 CPP",
      "Articles 231 à 380-15 CPP",
    ],
    answer: "Articles 381 à 495-25 CPP",
    explanation:
        "La page indique que le tribunal correctionnel est régi par les Articles 381 à 495-25 du Code de procédure pénale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Rôle",
    question: "Le tribunal correctionnel est :",
    options: [
      "La formation civile du tribunal judiciaire",
      "La formation de jugement normale du tribunal judiciaire dans le domaine pénal",
      "Une juridiction administrative",
    ],
    answer:
        "La formation de jugement normale du tribunal judiciaire dans le domaine pénal",
    explanation:
        "La page précise que c’est la formation de jugement normale du tribunal judiciaire en matière pénale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Composition",
    question:
        "Dans sa formation ordinaire, le tribunal correctionnel est composé :",
    options: [
      "D’un président et de deux juges",
      "D’un président, d’un jury et d’un greffier",
      "D’un juge unique",
    ],
    answer: "D’un président et de deux juges",
    explanation:
        "Selon l’Article 398 al. 1 CPP, repris dans la page, il s’agit d’une juridiction collégiale composée d’un président et de deux juges.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Ministère public",
    question: "Qui représente le parquet devant le tribunal correctionnel ?",
    options: [
      "Le préfet",
      "Le procureur de la République",
      "Le juge d’instruction",
    ],
    answer: "Le procureur de la République",
    explanation:
        "La page précise que le parquet est représenté par le procureur de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Juge unique",
    question: "Le tribunal correctionnel peut siéger à juge unique pour :",
    options: [
      "Tous les délits, sans exception",
      "Les délits énumérés à l’Article 398-1 CPP (ex. chèques, code de la route…)",
      "Uniquement les contraventions",
    ],
    answer:
        "Les délits énumérés à l’Article 398-1 CPP (ex. chèques, code de la route…)",
    explanation:
        "La page mentionne que pour certains délits listés à l’Article 398-1 CPP, le tribunal peut siéger à juge unique.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // TRIBUNAL CORRECTIONNEL — COMPÉTENCE
  // ==========================================================
  QuizQuestion(
    category: "Tribunal correctionnel — Compétence matérielle",
    question: "Selon l’Article 381 CPP, que juge le tribunal correctionnel ?",
    options: [
      "Les contraventions",
      "Les crimes",
      "Les délits que la loi punit d’emprisonnement ou d’une amende ≥ 3 750 €",
    ],
    answer:
        "Les délits que la loi punit d’emprisonnement ou d’une amende ≥ 3 750 €",
    explanation:
        "L’Article 381 CPP définit les délits comme les infractions punies d’emprisonnement ou d’une amende au moins égale à 3 750 €, compétence du tribunal correctionnel.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Compétence",
    question: "Le tribunal correctionnel est compétent pour juger :",
    options: [
      "Tous les délits, sauf ceux renvoyés à une juridiction particulière",
      "Uniquement les crimes",
      "Uniquement les contraventions",
    ],
    answer:
        "Tous les délits, sauf ceux renvoyés à une juridiction particulière",
    explanation:
        "La page précise qu’il juge tous les délits qui ne sont pas renvoyés devant une juridiction particulière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Connexité",
    question: "Que peut juger le tribunal correctionnel en plus d’un délit ?",
    options: [
      "Des crimes connexes",
      "Des contraventions connexes ou mal qualifiées comme délits",
      "Des litiges civils sans constitution de partie civile",
    ],
    answer: "Des contraventions connexes ou mal qualifiées comme délits",
    explanation:
        "La page précise qu’il peut connaître des contraventions connexes ou juger une contravention dont il a été saisi par erreur sous la qualification de délit (Article 466 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Compétence territoriale",
    question:
        "La compétence territoriale du tribunal correctionnel repose notamment sur :",
    options: [
      "Le lieu d’infraction, la résidence du prévenu, ou le lieu d’arrestation/détention",
      "Uniquement le domicile de la victime",
      "La circonscription du préfet",
    ],
    answer:
        "Le lieu d’infraction, la résidence du prévenu, ou le lieu d’arrestation/détention",
    explanation:
        "La page reprend les critères classiques de compétence territoriale : lieu de l’infraction, résidence, lieu d’arrestation ou détention du prévenu.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // TRIBUNAL CORRECTIONNEL — SAISINE & PROCÉDURES
  // ==========================================================
  QuizQuestion(
    category: "Tribunal correctionnel — Modes de saisine",
    question: "Les modes de saisine du tribunal correctionnel sont listés à :",
    options: ["L’Article 388 CPP", "L’Article 531 CPP", "L’Article 231 CPP"],
    answer: "L’Article 388 CPP",
    explanation:
        "La page indique que les modes de saisine sont listés à l’Article 388 du Code de procédure pénale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Saisine",
    question:
        "La comparution volontaire devant le tribunal correctionnel est prévue par :",
    options: ["L’Article 389 CPP", "L’Article 395 CPP", "L’Article 420-1 CPP"],
    answer: "L’Article 389 CPP",
    explanation:
        "La page cite la comparution volontaire et renvoie à l’Article 389 CPP.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Saisine",
    question:
        "La citation directe devant le tribunal correctionnel peut émaner :",
    options: [
      "Uniquement du ministère public",
      "Du ministère public, de la partie civile ou d’une administration légalement habilitée",
      "Uniquement de la partie civile",
    ],
    answer:
        "Du ministère public, de la partie civile ou d’une administration légalement habilitée",
    explanation:
        "L’Article 390 CPP, repris dans la page, prévoit ces différentes origines de la citation.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Saisine",
    question:
        "La convocation par procès-verbal, dite du « rendez-vous judiciaire », est prévue par :",
    options: ["L’Article 394 CPP", "L’Article 495-7 CPP", "L’Article 267 CPP"],
    answer: "L’Article 394 CPP",
    explanation:
        "La page indique que la convocation par procès-verbal est prévue à l’Article 394 CPP.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Procédures simplifiées",
    question:
        "L’ordonnance pénale devant le tribunal correctionnel est prévue par :",
    options: [
      "Les Articles 495 à 495-6 CPP",
      "Les Articles 495-7 à 495-16 CPP",
      "Les Articles 521 à 549 CPP",
    ],
    answer: "Les Articles 495 à 495-6 CPP",
    explanation: "La page renvoie à ces articles pour l’ordonnance pénale.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Procédures simplifiées",
    question:
        "La comparution sur reconnaissance préalable de culpabilité (CRPC) est régie par :",
    options: [
      "Les Articles 495-7 à 495-16 CPP",
      "Les Articles 381 à 388 CPP",
      "Les Articles 266 à 270 CPP",
    ],
    answer: "Les Articles 495-7 à 495-16 CPP",
    explanation: "La page précise que ces articles régissent la CRPC.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Procédures simplifiées",
    question: "L’amende forfaitaire délictuelle est prévue par :",
    options: [
      "Les Articles 495-17 à 495-25 CPP",
      "Les Articles 521 à 531 CPP",
      "Les Articles 231 à 240 CPP",
    ],
    answer: "Les Articles 495-17 à 495-25 CPP",
    explanation:
        "La page cite ces articles pour l’amende forfaitaire délictuelle.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // TRIBUNAL CORRECTIONNEL — PARTIE CIVILE
  // ==========================================================
  QuizQuestion(
    category: "Tribunal correctionnel — Partie civile",
    question: "Le tribunal correctionnel peut statuer au civil sur :",
    options: [
      "Les litiges de voisinage uniquement",
      "Les réparations des dommages causés aux victimes constituées parties civiles",
      "Les litiges fiscaux",
    ],
    answer:
        "Les réparations des dommages causés aux victimes constituées parties civiles",
    explanation:
        "La page explique que le tribunal correctionnel statue au civil sur les réparations pour les victimes qui se sont constituées partie civile.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Partie civile",
    question:
        "À quel moment la partie civile peut-elle se constituer devant le tribunal correctionnel ?",
    options: [
      "Uniquement lors de l’enquête préliminaire",
      "Avant l’audience au greffe ou pendant l’audience",
      "Après l’exécution de la peine",
    ],
    answer: "Avant l’audience au greffe ou pendant l’audience",
    explanation:
        "La page mentionne la constitution au greffe avant l’audience ou pendant l’audience (Article 419 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Partie civile",
    question:
        "Par quels moyens la partie civile peut-elle se constituer avant l’audience, selon l’Article 420-1 CPP ?",
    options: [
      "Uniquement oralement à l’audience",
      "Par lettre recommandée, télécopie ou communication électronique",
      "Uniquement par acte d’huissier",
    ],
    answer: "Par lettre recommandée, télécopie ou communication électronique",
    explanation:
        "La page évoque la constitution par LRAR, télécopie ou communication électronique, au moins 24h avant l’audience.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // COUR D’ASSISES — COMPOSITION & JURY
  // ==========================================================
  QuizQuestion(
    category: "Cour d’assises — Textes",
    question: "Par quels articles la cour d’assises est-elle régie ?",
    options: [
      "Articles 231 à 380-15 CPP",
      "Articles 381 à 495-25 CPP",
      "Articles 521 à 549 CPP",
    ],
    answer: "Articles 231 à 380-15 CPP",
    explanation:
        "La page indique que la cour d’assises est régie par les Articles 231 à 380-15 du CPP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Rôle",
    question: "La cour d’assises est compétente pour juger :",
    options: ["Les contraventions", "Les délits", "Les crimes"],
    answer: "Les crimes",
    explanation:
        "Le texte rappelle que la cour d’assises est compétente pour juger les crimes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Répartition géographique",
    question: "Combien y a-t-il de cours d’assises selon la page ?",
    options: [
      "Une par cour d’appel",
      "Une par département",
      "Une seule pour tout le territoire national",
    ],
    answer: "Une par département",
    explanation:
        "La page précise qu’il y a une cour d’assises par département.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Localisation",
    question: "Où la cour d’assises se tient-elle en principe ?",
    options: [
      "Au siège de la cour d’appel ou au chef-lieu du département, dans les locaux du tribunal judiciaire",
      "Au ministère de la Justice à Paris",
      "Dans toute commune choisie par l’avocat général",
    ],
    answer:
        "Au siège de la cour d’appel ou au chef-lieu du département, dans les locaux du tribunal judiciaire",
    explanation:
        "La page décrit précisément la localisation habituelle de la cour d’assises.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour d’assises — Composition",
    question: "La cour d’assises rassemble :",
    options: [
      "Uniquement des magistrats professionnels",
      "Un élément professionnel (la cour) et un élément non professionnel (le jury)",
      "Uniquement un jury populaire",
    ],
    answer:
        "Un élément professionnel (la cour) et un élément non professionnel (le jury)",
    explanation: "La page insiste sur cette composition originale cour + jury.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Cour",
    question: "La cour (élément professionnel) est composée de :",
    options: [
      "Un président et deux assesseurs",
      "Deux présidents et un juge",
      "Un président seul",
    ],
    answer: "Un président et deux assesseurs",
    explanation:
        "Le texte indique que la cour est composée de trois membres : un président et deux assesseurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Jury",
    question:
        "Combien de jurés composent le jury lorsque la cour d’assises statue en premier ressort ?",
    options: ["4", "6", "9"],
    answer: "6",
    explanation:
        "La page précise que le jury est composé de 6 jurés en premier ressort.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Jury appel",
    question:
        "Combien de jurés composent le jury lorsque la cour d’assises statue en appel ?",
    options: ["6", "9", "12"],
    answer: "9",
    explanation: "La page indique que le jury est alors composé de 9 jurés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Serment des jurés",
    question:
        "Le serment des jurés, prévu par l’Article 304 CPP, rappelle notamment :",
    options: [
      "La présomption d’innocence et la règle selon laquelle le doute profite à l’accusé et aux intérêts des victimes",
      "Le principe de l’autorité de la chose jugée",
      "Le principe de séparation des pouvoirs",
    ],
    answer:
        "La présomption d’innocence et la règle selon laquelle le doute profite à l’accusé et aux intérêts des victimes",
    explanation:
        "La page cite ces éléments contenus dans le serment des jurés (Article 304 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour d’assises — Conditions pour être juré",
    question: "Pour être juré, il faut notamment :",
    options: [
      "Être Français, avoir au moins 23 ans, savoir lire/écrire et jouir de ses droits civils et civiques",
      "Être majeur de plus de 21 ans, sans condition de nationalité",
      "Être avocat ou magistrat",
    ],
    answer:
        "Être Français, avoir au moins 23 ans, savoir lire/écrire et jouir de ses droits civils et civiques",
    explanation:
        "La page détaille ces conditions pour exercer les fonctions de juré.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour d’assises — Incompatibilités",
    question:
        "Les incompatibilités prévues aux Articles 256 et 257 CPP peuvent notamment concerner :",
    options: [
      "Les préfets, les fonctionnaires de police, les militaires, les incapables majeurs ou certains condamnés",
      "Uniquement les maires",
      "Uniquement les avocats",
    ],
    answer:
        "Les préfets, les fonctionnaires de police, les militaires, les incapables majeurs ou certains condamnés",
    explanation:
        "La page cite les fonctions, la capacité et la moralité parmi les causes d’incompatibilité avec la fonction de juré.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Dispenses",
    question:
        "Peuvent notamment être dispensées des fonctions de juré les personnes :",
    options: [
      "Âgées de plus de 70 ans ou dont la résidence principale est hors du département siège de la cour, avec motif grave",
      "Âgées de moins de 25 ans automatiquement",
      "Domiciliées dans le même canton que la victime",
    ],
    answer:
        "Âgées de plus de 70 ans ou dont la résidence principale est hors du département siège de la cour, avec motif grave",
    explanation:
        "La page prévoit des dispenses possibles pour ces personnes, sous condition de motif grave reconnu valable.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // COUR D’ASSISES — DÉSIGNATION DES JURÉS
  // ==========================================================
  QuizQuestion(
    category: "Cour d’assises — Listes de jurés",
    question:
        "À partir de quoi chaque commune dresse-t-elle une liste de jurés potentiels ?",
    options: [
      "Les listes fiscales",
      "Les listes électorales",
      "Les registres d’état civil",
    ],
    answer: "Les listes électorales",
    explanation:
        "La page précise que les listes sont établies à partir des listes électorales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Commission",
    question:
        "La commission qui établit la liste annuelle du jury est composée notamment :",
    options: [
      "Du juge d’instruction, du maire et du préfet",
      "De magistrats, du bâtonnier de l’ordre des avocats et de personnalités électives locales",
      "De jurés des années précédentes",
    ],
    answer:
        "De magistrats, du bâtonnier de l’ordre des avocats et de personnalités électives locales",
    explanation:
        "La page décrit précisément la composition de cette commission.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour d’assises — Liste de session",
    question:
        "Combien de jurés titulaires et suppléants figurent en principe sur la liste de session ?",
    options: [
      "20 titulaires et 5 suppléants",
      "35 titulaires et 10 suppléants",
      "60 titulaires et 20 suppléants",
    ],
    answer: "35 titulaires et 10 suppléants",
    explanation:
        "La page indique que 35 titulaires et 10 suppléants sont tirés au sort pour la liste de session.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour d’assises — Paris & certaines cours",
    question:
        "Pour la cour d’assises de Paris et certaines autres cours, les nombres de jurés sont portés à :",
    options: [
      "25 titulaires et 10 suppléants",
      "45 titulaires et 15 suppléants",
      "55 titulaires et 20 suppléants",
    ],
    answer: "45 titulaires et 15 suppléants",
    explanation:
        "La page précise que pour Paris et certaines cours désignées, les nombres sont portés à 45 titulaires et 15 suppléants.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour d’assises — Augmentation du nombre de jurés",
    question:
        "Qui peut décider d’augmenter le nombre de jurés lorsqu’un fort absentéisme est à craindre ?",
    options: [
      "Le procureur de la République",
      "Le premier président de la cour d’appel",
      "Le président du tribunal administratif",
    ],
    answer: "Le premier président de la cour d’appel",
    explanation:
        "Selon l’Article 266 CPP, le premier président peut augmenter ces effectifs si un nombre important de jurés risque de ne pas répondre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Notification liste",
    question:
        "La liste des jurés de session doit être signifiée à chaque accusé au plus tard :",
    options: [
      "La veille de l’ouverture des débats",
      "L’avant-veille de l’ouverture des débats",
      "Une semaine avant les débats",
    ],
    answer: "L’avant-veille de l’ouverture des débats",
    explanation:
        "La page rappelle que cette signification doit intervenir au plus tard l’avant-veille, conformément à l’Article 282 CPP.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour d’assises — Tirage au sort du jury de jugement",
    question:
        "À quel moment le président de la cour d’assises tire-t-il au sort les jurés qui composeront le jury de jugement ?",
    options: [
      "Avant la liste annuelle des jurés",
      "Avant chaque nouvelle affaire, à partir de la liste de session",
      "Après le prononcé de la décision",
    ],
    answer: "Avant chaque nouvelle affaire, à partir de la liste de session",
    explanation:
        "La page indique que, préalablement au jugement de chaque affaire, le président tire au sort les 6 ou 9 jurés de jugement.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour d’assises — Récusations",
    question:
        "Lors de la constitution du jury, l’accusé peut récuser jusqu’à :",
    options: [
      "2 jurés en premier ressort et 3 en appel",
      "4 jurés en premier ressort et 5 en appel",
      "6 jurés en premier ressort et 8 en appel",
    ],
    answer: "4 jurés en premier ressort et 5 en appel",
    explanation:
        "La page précise les possibilités de récusation pour l’accusé : jusqu’à 4 jurés en premier ressort et 5 en appel.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Convocation des jurés",
    question:
        "Dans quel délai minimum le greffier convoque-t-il les jurés titulaires et suppléants avant l’ouverture de la session ?",
    options: ["3 jours", "8 jours", "15 jours"],
    answer: "15 jours",
    explanation:
        "La page indique qu’ils sont convoqués au moins 15 jours avant l’ouverture de la session (Article 267 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour d’assises — Convocation des jurés",
    question:
        "Qui peut être requis pour rechercher les jurés qui n’auraient pas répondu à la convocation et leur remettre celle-ci ?",
    options: [
      "Les services de police ou de gendarmerie",
      "Les services municipaux",
      "Les services fiscaux",
    ],
    answer: "Les services de police ou de gendarmerie",
    explanation:
        "L’Article 267 CPP prévoit que le greffier peut requérir les services de police ou de gendarmerie pour les jurés défaillants.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // COUR D’ASSISES — COMPÉTENCE & PARQUET
  // ==========================================================
  QuizQuestion(
    category: "Cour d’assises — Compétence",
    question:
        "Selon l’Article 231 CPP, la cour d’assises a plénitude de juridiction pour :",
    options: [
      "Juger uniquement les contraventions",
      "Juger en premier ressort ou en appel les personnes renvoyées devant elle par décision de mise en accusation",
      "Réexaminer toutes les décisions civiles",
    ],
    answer:
        "Juger en premier ressort ou en appel les personnes renvoyées devant elle par décision de mise en accusation",
    explanation:
        "La page cite cet article qui donne à la cour d’assises plénitude de juridiction pour les personnes renvoyées devant elle.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour d’assises — Ministère public",
    question:
        "Lorsque la cour d’assises siège au niveau de la cour d’appel, le ministère public est représenté par :",
    options: ["Le procureur de la République", "L’avocat général", "Le préfet"],
    answer: "L’avocat général",
    explanation:
        "La page précise que, dans ce cas, c’est l’avocat général qui représente le ministère public.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour d’assises — Ministère public",
    question:
        "Lorsque la cour d’assises siège dans les locaux du tribunal judiciaire, qui représente le ministère public ?",
    options: [
      "Le procureur de la République",
      "Le président de la cour d’assises",
      "Le bâtonnier",
    ],
    answer: "Le procureur de la République",
    explanation:
        "La page indique que, lorsqu’elle siège dans les locaux du tribunal judiciaire, le ministère public est représenté par le procureur de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Intro — Exécution des décisions",
    question:
        "La loi du 27 mars 2012 relative à l’exécution des peines vise notamment à :",
    options: [
      "Renforcer uniquement les droits de la défense",
      "Garantir l’effectivité de l’exécution des peines et prévenir la récidive",
      "Supprimer les sanctions pécuniaires",
    ],
    answer:
        "Garantir l’effectivité de l’exécution des peines et prévenir la récidive",
    explanation:
        "La loi n° 2012-409 du 27 mars 2012 renforce l’effectivité de l’exécution des peines, les dispositifs de prévention de la récidive et la prise en charge des mineurs délinquants.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Intro — Exécution des décisions",
    question:
        "Quel mouvement la loi du 9 mars 2004 poursuit-elle en matière d’exécution des peines ?",
    options: [
      "La centralisation politique des peines",
      "La juridictionnalisation des peines",
      "La suppression des juges de l’application des peines",
    ],
    answer: "La juridictionnalisation des peines",
    explanation:
        "La loi du 9 mars 2004 poursuit le mouvement de juridictionnalisation des peines, en renforçant notamment le rôle du JAP et en abandonnant la notion de mesures d’administration judiciaire.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Intro — Exécution des décisions",
    question:
        "Selon la page, qui poursuit l’exécution des peines privatives de liberté et de certaines peines de substitution ?",
    options: [
      "Uniquement le juge de l’application des peines",
      "Le procureur de la République",
      "La partie civile",
    ],
    answer: "Le procureur de la République",
    explanation:
        "Le texte rappelle que selon la loi, le procureur de la République poursuit l’exécution des peines privatives de liberté et de certaines peines de substitution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Intro — Exécution des décisions",
    question: "L’exécution des peines relève de plus en plus :",
    options: [
      "Du juge de l’application des peines",
      "Du maire de la commune",
      "Du tribunal administratif",
    ],
    answer: "Du juge de l’application des peines",
    explanation:
        "La page précise que l’exécution des peines relève de plus en plus du juge de l’application des peines, notamment pour les modalités d’application.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Intro — Exécution des décisions",
    question:
        "Pour les peines pécuniaires, quel mécanisme est prévu pour garantir l’exécution ?",
    options: [
      "Le sursis simple",
      "La contrainte judiciaire",
      "La suspension automatique des poursuites",
    ],
    answer: "La contrainte judiciaire",
    explanation:
        "La page mentionne que le législateur a prévu la contrainte judiciaire pour garantir l’exécution des amendes et autres condamnations pécuniaires.",
    difficulty: "Facile",
  ),

  // ==========================================================
  // 1.1 — PARTIES INTERVENANTES (ARTICLE 707-1 CPP)
  // ==========================================================
  QuizQuestion(
    category: "Parties intervenantes — Généralités",
    question:
        "Selon l’Article 707-1 alinéa 1 du Code de procédure pénale, qui poursuit l’exécution de la sentence ?",
    options: [
      "Uniquement le ministère public",
      "Uniquement le juge d’instruction",
      "Le ministère public et les parties, chacun en ce qui le concerne",
    ],
    answer: "Le ministère public et les parties, chacun en ce qui le concerne",
    explanation:
        "L’Article 707-1 alinéa 1 CPP dispose que le ministère public et les parties poursuivent l’exécution de la sentence, chacun pour ce qui le concerne.",
    difficulty: "Intermédiaire",
  ),

  // -------- Partie civile --------
  QuizQuestion(
    category: "Partie civile",
    question:
        "En principe, sous quelle forme la partie civile obtient-elle réparation ?",
    options: [
      "Travail d’intérêt général",
      "Versement de dommages et intérêts",
      "Contrainte judiciaire",
    ],
    answer: "Versement de dommages et intérêts",
    explanation:
        "La page précise que la partie civile obtient en principe réparation sous forme de dommages et intérêts.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Partie civile",
    question:
        "Qui a qualité pour faire exécuter les condamnations prononcées au profit de la partie civile ?",
    options: [
      "Uniquement le ministère public",
      "Uniquement le comptable public",
      "La partie civile elle-même, par les voies civiles",
    ],
    answer: "La partie civile elle-même, par les voies civiles",
    explanation:
        "La partie civile a seule qualité pour faire exécuter les condamnations prononcées à son profit par les voies civiles (saisies, etc.).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Partie civile",
    question:
        "Parmi les réparations suivantes, laquelle peut également bénéficier à la partie civile selon la page ?",
    options: [
      "Publication de la décision",
      "Contrainte judiciaire",
      "Révocation du sursis probatoire",
    ],
    answer: "Publication de la décision",
    explanation:
        "La page cite d’autres formes de réparation comme la publication de la décision ou la remise en état d’un bien.",
    difficulty: "Facile",
  ),

  // -------- Administrations --------
  QuizQuestion(
    category: "Administrations — Exécution",
    question:
        "Quelle administration est compétente pour le recouvrement des amendes à caractère fiscal et certaines confiscations ?",
    options: [
      "L’administration des douanes",
      "L’administration des impôts",
      "L’administration pénitentiaire",
    ],
    answer: "L’administration des impôts",
    explanation:
        "La page indique que l’administration des impôts recouvre les amendes à caractère fiscal et certaines confiscations.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Administrations — Exécution",
    question: "L’administration des douanes est chargée de l’exécution :",
    options: [
      "Des sanctions disciplinaires",
      "Des sanctions pécuniaires prononcées pour infractions douanières",
      "Des décisions de libération conditionnelle",
    ],
    answer: "Des sanctions pécuniaires prononcées pour infractions douanières",
    explanation:
        "La page précise que l’administration des douanes exécute les sanctions pécuniaires pour infractions douanières.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Administrations — Transaction",
    question:
        "Quelle faculté importante les administrations (impôts, douanes) peuvent-elles exercer selon la page ?",
    options: [
      "Le pouvoir de grâce",
      "Le droit de transaction",
      "Le droit de prononcer des peines privatives de liberté",
    ],
    answer: "Le droit de transaction",
    explanation:
        "La page mentionne qu’elles disposent notamment d’un droit de transaction, qu’elles peuvent exercer avant ou après jugement.",
    difficulty: "Intermédiaire",
  ),

  // -------- Ministère public --------
  QuizQuestion(
    category: "Ministère public — Rôle",
    question:
        "Selon la page, à qui appartient-il « essentiellement d’assurer l’exécution des sanctions pénales » ?",
    options: [
      "Au juge d’instruction",
      "Au ministère public",
      "Au juge administratif",
    ],
    answer: "Au ministère public",
    explanation:
        "La page le dit expressément : c’est au ministère public qu’il appartient d’assurer l’exécution des sanctions pénales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Ministère public — Peines concernées",
    question:
        "Parmi les attributions suivantes, laquelle relève du ministère public selon l’Article 707-1 CPP ?",
    options: [
      "Prononcer la peine",
      "Faire exécuter toutes les peines privatives de liberté",
      "Exercer un recours gracieux",
    ],
    answer: "Faire exécuter toutes les peines privatives de liberté",
    explanation:
        "L’article 707-1 mentionne que le ministère public fait exécuter toutes les peines privatives de liberté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Ministère public — Peines du Code pénal",
    question:
        "Les peines prévues aux articles 131-1 à 131-49 du Code pénal sont :",
    options: [
      "Uniquement des peines contraventionnelles",
      "Les peines principales, complémentaires et accessoires",
      "Uniquement des mesures de sûreté",
    ],
    answer: "Les peines principales, complémentaires et accessoires",
    explanation:
        "La page précise que le ministère public fait exécuter les peines prévues aux articles 131-1 à 131-49 CP (principales, complémentaires et accessoires).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Ministère public — Sanctions UE",
    question:
        "L’Article 707-1 alinéa 6 CPP confie au ministère public la poursuite de l’exécution :",
    options: [
      "Des sanctions pécuniaires prononcées par les autorités compétentes des États membres de l’Union européenne",
      "Des décisions civiles étrangères uniquement",
      "Des décisions du Conseil constitutionnel",
    ],
    answer:
        "Des sanctions pécuniaires prononcées par les autorités compétentes des États membres de l’Union européenne",
    explanation:
        "La page mentionne que le ministère public poursuit l’exécution de ces sanctions pécuniaires européennes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Ministère public — Recouvrement pécuniaire",
    question:
        "Pour les peines pécuniaires, qui assure le recouvrement selon la page ?",
    options: [
      "Uniquement le ministère public",
      "Le comptable public compétent ou l’AGRASC pour les confiscations",
      "La partie civile",
    ],
    answer: "Le comptable public compétent ou l’AGRASC pour les confiscations",
    explanation:
        "L’Article 707-1 al. 2 CPP prévoit que le recouvrement est assuré par le comptable public compétent ou par l’Agence de gestion et de recouvrement des avoirs saisis et confisqués.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Ministère public — Force publique",
    question:
        "Que prévoit l’Article 709 du Code de procédure pénale au profit du procureur de la République et du procureur général ?",
    options: [
      "La possibilité de modifier la peine prononcée",
      "La possibilité de requérir directement l’assistance de la force publique",
      "La possibilité de prononcer une amnistie",
    ],
    answer:
        "La possibilité de requérir directement l’assistance de la force publique",
    explanation:
        "La page mentionne que l’Article 709 CPP permet au procureur de la République et au procureur général de requérir directement la force publique pour exécuter les décisions.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // 1.2 — DÉCISION DÉFINITIVE
  // ==========================================================
  QuizQuestion(
    category: "Décision définitive — Principe",
    question:
        "Selon l’Article 708 alinéa 1 CPP, quand l’exécution d’une décision pénale peut-elle intervenir ?",
    options: [
      "Dès le prononcé du jugement, même s’il est susceptible de recours",
      "Lorsque la décision est devenue définitive",
      "Uniquement après accord de la partie civile",
    ],
    answer: "Lorsque la décision est devenue définitive",
    explanation:
        "L’Article 708 alinéa 1 CPP dispose que l’exécution a lieu lorsque la décision est devenue définitive.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décision définitive — Opposition",
    question:
        "Que se passe-t-il lorsqu’un jugement a été rendu par défaut et que le délai d’opposition court encore ?",
    options: [
      "La décision peut être exécutée immédiatement",
      "La décision ne peut pas encore être exécutée",
      "Le pourvoi en cassation est automatique",
    ],
    answer: "La décision ne peut pas encore être exécutée",
    explanation:
        "La page indique que lorsque la décision est rendue par défaut, elle ne peut être exécutée tant que court le délai d’opposition.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Décision définitive — Appel",
    question:
        "Quel est le délai d’appel de principe pour un jugement du tribunal correctionnel, selon la page ?",
    options: ["3 jours", "5 jours", "10 jours"],
    answer: "10 jours",
    explanation:
        "La page rappelle que le délai est de 10 jours à compter du prononcé, notamment pour l’Article 498 CPP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décision définitive — Appel",
    question:
        "Pendant le délai d’appel et durant l’instance d’appel, il est en principe :",
    options: [
      "Procédé immédiatement à l’exécution de la peine",
      "Sursis à l’exécution, sauf exceptions",
      "Obligatoire de former un pourvoi en cassation",
    ],
    answer: "Sursis à l’exécution, sauf exceptions",
    explanation:
        "La page précise qu’en principe il est sursis à l’exécution pendant le délai et l’instance d’appel, sauf exceptions.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Décision définitive — Pourvoi",
    question: "En matière pénale, le pourvoi en cassation est en principe :",
    options: [
      "Suspensif d’exécution",
      "Non suspensif d’exécution",
      "Obligatoire avant toute exécution",
    ],
    answer: "Non suspensif d’exécution",
    explanation:
        "La page indique que le pourvoi en cassation n’est en principe pas suspensif, sauf texte contraire.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // 1.3 — PEINES PRIVATIVES DE LIBERTÉ
  // ==========================================================
  QuizQuestion(
    category: "Peines privatives — Ministère public",
    question: "Qui doit faire exécuter les peines privatives de liberté ?",
    options: [
      "Le juge d’instruction",
      "Le ministère public",
      "Le président de la cour d’assises",
    ],
    answer: "Le ministère public",
    explanation:
        "La page rappelle que le ministère public doit faire exécuter les peines privatives de liberté, qu’elles soient prononcées par le tribunal correctionnel ou la cour d’assises.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Peines privatives — Parquet compétent",
    question:
        "Lorsque la cour d’assises siège au niveau de la cour d’appel, qui assure l’exécution des peines ?",
    options: [
      "Le parquet du tribunal judiciaire",
      "Le parquet général",
      "Le juge de l’application des peines uniquement",
    ],
    answer: "Le parquet général",
    explanation:
        "La page mentionne que, dans ce cas, c’est le parquet général qui assure l’exécution.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Peines privatives — Parquet compétent",
    question:
        "Lorsque la cour d’assises siège dans les locaux du tribunal judiciaire, qui assure l’exécution ?",
    options: [
      "Le parquet de ce tribunal judiciaire",
      "Le ministre de la Justice",
      "Le président de la cour d’assises",
    ],
    answer: "Le parquet de ce tribunal judiciaire",
    explanation:
        "La page précise que, dans cette hypothèse, c’est le parquet du tribunal judiciaire qui exécute.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Peines privatives — Délai mise à exécution",
    question:
        "Quel délai est recommandé par l’instruction générale pour la mise à exécution d’une peine d’emprisonnement (Article C 816) ?",
    options: ["48 heures", "8 jours", "15 jours"],
    answer: "15 jours",
    explanation:
        "La page indique que l’instruction générale prescrit un délai de 15 jours pour mettre à exécution la peine d’emprisonnement.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Peines privatives — Modalités",
    question:
        "Quel document est adressé à l’établissement pénitentiaire pour l’écrou du condamné ?",
    options: [
      "La copie de l’assignation en justice",
      "Un extrait de la décision exécutoire",
      "Un simple procès-verbal d’interpellation",
    ],
    answer: "Un extrait de la décision exécutoire",
    explanation:
        "La page précise qu’un extrait de la décision exécutoire est établi par le greffe et envoyé à l’établissement pénitentiaire à l’appui de l’écrou.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Peines privatives — Domicile du condamné",
    question:
        "Selon l’Article 716-5 CPP, pour exécuter une peine d’emprisonnement, les agents de la force publique peuvent être autorisés à :",
    options: [
      "Perquisitionner la nuit sans condition",
      "Pénétrer au domicile du condamné dans le respect des heures légales et de la protection du domicile",
      "Intercepter les communications téléphoniques sans contrôle judiciaire",
    ],
    answer:
        "Pénétrer au domicile du condamné dans le respect des heures légales et de la protection du domicile",
    explanation:
        "La page rappelle que l’Article 716-5 CPP encadre la pénétration au domicile pour exécuter une peine d’emprisonnement.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // 1.4 — PEINES NON PRIVATIVES DE LIBERTÉ
  // ==========================================================

  // ---------- Amendes & peines pécuniaires ----------
  QuizQuestion(
    category: "Peines non privatives — Amendes",
    question:
        "À partir de quel moment les condamnations pécuniaires deviennent-elles exigibles ?",
    options: [
      "Dès le dépôt de plainte",
      "Dès que la décision est devenue exécutoire",
      "Seulement après avis du Trésor public",
    ],
    answer: "Dès que la décision est devenue exécutoire",
    explanation:
        "La page précise que les condamnations pécuniaires sont exigibles dès que la décision les prononçant est exécutoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Peines non privatives — Amendes",
    question:
        "Dans quel délai les extraits de jugement doivent-ils être adressés au Trésorier principal pour recouvrement des amendes (hors pourvoi) ?",
    options: ["10 jours", "20 jours", "35 jours"],
    answer: "35 jours",
    explanation:
        "La page indique un délai de 35 jours (45 jours en cas de pourvoi) pour l’envoi des extraits au Trésorier principal.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Peines non privatives — Amendes",
    question:
        "Que peut entraîner le défaut de paiement d’une amende selon la page ?",
    options: [
      "La réduction automatique de la peine",
      "La non-inscription au casier judiciaire",
      "L’incarcération dans le cadre de la contrainte judiciaire",
    ],
    answer: "L’incarcération dans le cadre de la contrainte judiciaire",
    explanation:
        "Le défaut total ou partiel de paiement peut entraîner une incarcération par la contrainte judiciaire (Article 707-1 CPP).",
    difficulty: "Intermédiaire",
  ),

  // ---------- Jours-amende ----------
  QuizQuestion(
    category: "Peines non privatives — Jours-amende",
    question: "Les jours-amende consistent pour le condamné à :",
    options: [
      "Exécuter un certain nombre de jours de TIG",
      "Payer une somme journalière pendant un nombre de jours fixé",
      "Se présenter quotidiennement au commissariat",
    ],
    answer: "Payer une somme journalière pendant un nombre de jours fixé",
    explanation:
        "La page indique que les jours-amende sont une peine pécuniaire particulière basée sur une somme journalière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Peines non privatives — Jours-amende",
    question:
        "En cas de non-paiement des jours-amende, que peut décider le JAP ?",
    options: [
      "L’annulation de la peine",
      "Un emprisonnement pour une durée égale au nombre de jours-amende impayés",
      "Une simple augmentation de l’amende",
    ],
    answer:
        "Un emprisonnement pour une durée égale au nombre de jours-amende impayés",
    explanation:
        "La page précise que le JAP peut ordonner un emprisonnement équivalent au nombre de jours-amende non payés.",
    difficulty: "Intermédiaire",
  ),

  // ---------- Peines de substitution & complémentaires ----------
  QuizQuestion(
    category: "Peines non privatives — Peines de substitution",
    question:
        "L’Article 131-6 du Code pénal prévoit notamment comme peine de substitution :",
    options: [
      "La réclusion criminelle à perpétuité",
      "La suspension ou annulation du permis de conduire",
      "Le sursis simple",
    ],
    answer: "La suspension ou annulation du permis de conduire",
    explanation:
        "La page cite l’Article 131-6 CP : suspension/annulation du permis, interdiction de conduire certains véhicules, interdiction de porter une arme, confiscation de la chose, etc.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Peines non privatives — Peines complémentaires",
    question:
        "Parmi ces exemples, laquelle est une peine complémentaire citée dans la page ?",
    options: [
      "Interdiction de droits civiques, civils et de famille",
      "Réclusion criminelle",
      "Travail d’intérêt général",
    ],
    answer: "Interdiction de droits civiques, civils et de famille",
    explanation:
        "La page mentionne plusieurs peines complémentaires, dont l’interdiction de droits civiques, civils et de famille.",
    difficulty: "Intermédiaire",
  ),

  // ---------- Sanction-réparation ----------
  QuizQuestion(
    category: "Peines non privatives — Sanction-réparation",
    question:
        "Selon l’Article 131-8-1 du Code pénal, la peine de sanction-réparation :",
    options: [
      "Ne peut jamais se cumuler avec une peine d’amende",
      "Peut être prononcée à la place ou en même temps qu’une peine d’emprisonnement ou d’amende",
      "S’applique uniquement aux contraventions",
    ],
    answer:
        "Peut être prononcée à la place ou en même temps qu’une peine d’emprisonnement ou d’amende",
    explanation:
        "La page précise qu’en cas de délit, la juridiction peut prononcer cette peine à la place ou en même temps qu’une peine privative ou pécuniaire.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Peines non privatives — Sanction-réparation",
    question:
        "La peine de sanction-réparation consiste principalement pour le condamné à :",
    options: [
      "Se soumettre à une expertise psychiatrique",
      "Indemniser la victime (remise en état, versements, etc.)",
      "Effectuer un stage de citoyenneté",
    ],
    answer: "Indemniser la victime (remise en état, versements, etc.)",
    explanation:
        "La page indique qu’elle consiste à indemniser la victime, par exemple en remettant un bien en état ou en versant des sommes.",
    difficulty: "Facile",
  ),

  // ---------- Personnes morales ----------
  QuizQuestion(
    category: "Peines non privatives — Personnes morales",
    question: "Les personnes morales peuvent être condamnées à :",
    options: [
      "Des peines d’amende et diverses peines complémentaires",
      "Des peines de prison ferme uniquement",
      "Aucune peine pénale",
    ],
    answer: "Des peines d’amende et diverses peines complémentaires",
    explanation:
        "La page précise que les personnes morales encourent des amendes et diverses peines complémentaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Peines non privatives — Personnes morales",
    question: "La contrainte judiciaire :",
    options: [
      "S’applique aussi aux personnes morales",
      "Ne s’applique pas aux personnes morales",
      "Est obligatoire pour les personnes morales",
    ],
    answer: "Ne s’applique pas aux personnes morales",
    explanation:
        "La page précise que la contrainte judiciaire n’est pas applicable aux personnes morales.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // CHAPITRE 2 — CONTRAINTE JUDICIAIRE
  // ==========================================================
  QuizQuestion(
    category: "Contrainte judiciaire — Définition",
    question: "La contrainte judiciaire est :",
    options: [
      "Une peine principale de substitution",
      "Une voie d’exécution permettant d’incarcérer le condamné en cas d’inexécution volontaire d’une condamnation pécuniaire",
      "Une mesure disciplinaire interne à la prison",
    ],
    answer:
        "Une voie d’exécution permettant d’incarcérer le condamné en cas d’inexécution volontaire d’une condamnation pécuniaire",
    explanation:
        "La page la définit comme une voie d’exécution succédant à la contrainte par corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire — Juge compétent",
    question:
        "Quel juge est principalement chargé d’ordonner la contrainte judiciaire ?",
    options: [
      "Le juge d’instruction",
      "Le juge de l’application des peines (JAP)",
      "Le juge des libertés et de la détention",
    ],
    answer: "Le juge de l’application des peines (JAP)",
    explanation:
        "La loi du 9 mars 2004 consacre le rôle du JAP pour ordonner la contrainte judiciaire (Article 749 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire — Conditions",
    question: "La contrainte judiciaire suppose notamment :",
    options: [
      "Une inexécution volontaire de la condamnation pécuniaire",
      "Une simple négligence du Trésor public",
      "Une opposition de la partie civile",
    ],
    answer: "Une inexécution volontaire de la condamnation pécuniaire",
    explanation:
        "La page précise que la contrainte judiciaire est liée à l’inexécution volontaire d’une condamnation pécuniaire.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire — Nature de la peine",
    question:
        "Pour être susceptible de contrainte judiciaire, la peine d’amende doit :",
    options: [
      "Avoir été prononcée pour n’importe quelle contravention",
      "Avoir été prononcée pour un crime ou un délit puni d’emprisonnement",
      "Avoir été prononcée par le juge civil",
    ],
    answer:
        "Avoir été prononcée pour un crime ou un délit puni d’emprisonnement",
    explanation:
        "La page précise que la contrainte judiciaire s’applique à l’amende prononcée pour un crime ou un délit puni d’emprisonnement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire — Personnes concernées",
    question: "La contrainte judiciaire ne peut s’exercer que contre :",
    options: [
      "Les parents du condamné",
      "Le délinquant dont la culpabilité est judiciairement constatée",
      "La partie civile",
    ],
    answer: "Le délinquant dont la culpabilité est judiciairement constatée",
    explanation:
        "La page précise qu’elle ne s’applique qu’à l’auteur, co-auteur ou complice reconnu coupable.",
    difficulty: "Intermédiaire",
  ),

  // ---------- Causes d’exemption ----------
  QuizQuestion(
    category: "Contrainte judiciaire — Exemptions",
    question:
        "La contrainte judiciaire peut-elle être prononcée contre un mineur de moins de 18 ans ?",
    options: [
      "Oui, si les faits sont graves",
      "Non, elle ne peut pas être prononcée contre un mineur de moins de 18 ans",
      "Oui, mais seulement avec l’accord des parents",
    ],
    answer:
        "Non, elle ne peut pas être prononcée contre un mineur de moins de 18 ans",
    explanation:
        "L’Article 751 CPP, cité dans la page, exclut les mineurs de moins de 18 ans de la contrainte judiciaire.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire — Exemptions",
    question:
        "La contrainte judiciaire ne peut être exercée contre les débiteurs âgés :",
    options: [
      "D’au moins 50 ans à l’époque des faits",
      "D’au moins 65 ans à l’époque des faits",
      "D’au moins 70 ans à l’époque des faits",
    ],
    answer: "D’au moins 65 ans à l’époque des faits",
    explanation:
        "La page précise que les débiteurs âgés d’au moins 65 ans à l’époque des faits ne peuvent être soumis à la contrainte judiciaire (Article 751 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire — Insolvabilité",
    question:
        "Que prévoit l’Article 752 CPP en cas d’insolvabilité du condamné ?",
    options: [
      "La contrainte judiciaire est systématiquement prononcée",
      "La contrainte judiciaire n’est pas exercée contre le condamné justifiant de son insolvabilité",
      "L’amende est automatiquement doublée",
    ],
    answer:
        "La contrainte judiciaire n’est pas exercée contre le condamné justifiant de son insolvabilité",
    explanation:
        "L’Article 752 CPP exclut la contrainte judiciaire pour les condamnés qui prouvent leur insolvabilité.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire — Conjoint",
    question: "Que prévoit l’Article 753 CPP concernant les époux ?",
    options: [
      "La contrainte judiciaire peut être exercée simultanément contre les deux époux",
      "La contrainte judiciaire ne peut être exercée contre un couple marié",
      "La contrainte judiciaire ne peut être exercée simultanément contre deux époux",
    ],
    answer:
        "La contrainte judiciaire ne peut être exercée simultanément contre deux époux",
    explanation:
        "L’Article 753 CPP interdit d’exercer simultanément la contrainte judiciaire contre les deux membres d’un couple marié.",
    difficulty: "Difficile",
  ),

  // ---------- Procédure ----------
  QuizQuestion(
    category: "Contrainte judiciaire — Commandement",
    question:
        "Quelle formalité précède obligatoirement l’incarcération au titre de la contrainte judiciaire ?",
    options: [
      "Une expertise psychiatrique",
      "Un commandement de payer signifié au débiteur",
      "Une médiation pénale",
    ],
    answer: "Un commandement de payer signifié au débiteur",
    explanation:
        "La page indique qu’un commandement de payer est signifié sous peine de contrainte judiciaire avant toute incarcération.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire — Demande d’incarcération",
    question:
        "Si, dans l’année suivant la signification du commandement, le condamné n’a pas payé, qui peut requérir le JAP pour qu’il prononce la contrainte judiciaire ?",
    options: [
      "Le président du tribunal correctionnel",
      "Le procureur de la République",
      "La partie civile",
    ],
    answer: "Le procureur de la République",
    explanation:
        "La page précise que le procureur de la République peut saisir le JAP en vue de la contrainte judiciaire.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire — Durée",
    question:
        "La contrainte judiciaire est exclue lorsque le montant de l’amende est :",
    options: [
      "Inférieur à 500 €",
      "Inférieur à 1 000 €",
      "Inférieur à 2 000 €",
    ],
    answer: "Inférieur à 2 000 €",
    explanation:
        "La page précise que la contrainte judiciaire est exclue pour les amendes inférieures à 2 000 € (Article 750 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire — Durée",
    question:
        "En matière de trafic de stupéfiants, la durée maximale de la contrainte judiciaire peut être portée à :",
    options: ["6 mois", "1 an", "2 ans"],
    answer: "1 an",
    explanation:
        "La page mentionne que l’Article 706-31 al. 3 CPP permet de porter la durée maximale à un an.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Contrainte judiciaire — Fin",
    question:
        "Selon l’Article 761-1 CPP, l’exécution de la contrainte judiciaire :",
    options: [
      "Éteint la dette pécuniaire",
      "N’éteint pas la dette, qui subsiste",
      "Transforme l’amende en dommages et intérêts",
    ],
    answer: "N’éteint pas la dette, qui subsiste",
    explanation:
        "La page indique clairement que la dette subsiste malgré l’exécution de la contrainte judiciaire.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // CHAPITRE 3 — JURIDICTIONS DE L’APPLICATION DES PEINES
  // ==========================================================

  // ---------- Juridictionnalisation ----------
  QuizQuestion(
    category: "Application des peines — Juridictionnalisation",
    question: "La loi du 15 juin 2000 a instauré notamment :",
    options: [
      "La suppression du juge de l’application des peines",
      "La juridictionnalisation des décisions du JAP",
      "Le transfert de l’exécution des peines au tribunal administratif",
    ],
    answer: "La juridictionnalisation des décisions du JAP",
    explanation:
        "La loi n° 2000-516 a posé le principe de juridictionnalisation des décisions du JAP (semi-liberté, placement à l’extérieur, libération conditionnelle, etc.).",
    difficulty: "Intermédiaire",
  ),

  // ---------- JAP ----------
  QuizQuestion(
    category: "Application des peines — JAP",
    question:
        "Selon l’Article 712-2 CPP, où se trouvent les juges de l’application des peines ?",
    options: [
      "Dans chaque cour d’appel",
      "Dans chaque tribunal judiciaire",
      "Uniquement à Paris",
    ],
    answer: "Dans chaque tribunal judiciaire",
    explanation:
        "L’Article 712-2 CPP prévoit qu’un ou plusieurs magistrats du siège exercent les fonctions de JAP dans chaque tribunal judiciaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Application des peines — JAP",
    question: "Le JAP fixe principalement :",
    options: [
      "La culpabilité de la personne",
      "Les modalités d’exécution des peines privatives ou restrictives de liberté",
      "Les règles de procédure civile",
    ],
    answer:
        "Les modalités d’exécution des peines privatives ou restrictives de liberté",
    explanation:
        "La page indique que le JAP fixe et contrôle les modalités d’exécution de ces peines.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Application des peines — JAP milieu fermé",
    question: "En milieu fermé, le JAP intervient notamment pour :",
    options: [
      "La fixation du quantum de la peine",
      "Le placement à l’extérieur, la semi-liberté, la libération conditionnelle",
      "La nomination du directeur de prison",
    ],
    answer:
        "Le placement à l’extérieur, la semi-liberté, la libération conditionnelle",
    explanation:
        "La page énumère plusieurs mesures en milieu fermé : placement à l’extérieur, semi-liberté, suspension ou fractionnement, DDSE, libération conditionnelle.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Application des peines — JAP milieu ouvert",
    question: "En milieu ouvert, l’Article 712-6 CPP prévoit que le JAP :",
    options: [
      "Détermine les conditions d’exécution des peines en fonction de la situation du condamné",
      "Fixe le montant des amendes",
      "Décide de la compétence du tribunal",
    ],
    answer:
        "Détermine les conditions d’exécution des peines en fonction de la situation du condamné",
    explanation:
        "La page indique que le JAP adapte les conditions d’exécution (sursis probatoire, TIG, suivi socio-judiciaire, etc.).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Application des peines — Pouvoirs JAP",
    question: "Selon l’Article 712-19 CPP, le JAP peut :",
    options: [
      "Prononcer une peine plus lourde que celle initialement prévue",
      "Ordonner l’incarcération provisoire du condamné après avis du procureur",
      "Annuler la condamnation",
    ],
    answer:
        "Ordonner l’incarcération provisoire du condamné après avis du procureur",
    explanation:
        "La page rappelle ce pouvoir spécifique en cas de non-respect des mesures.",
    difficulty: "Difficile",
  ),

  // ---------- TAP ----------
  QuizQuestion(
    category: "Application des peines — TAP",
    question:
        "Selon l’Article 712-3 CPP, où est établi le tribunal de l’application des peines (TAP) ?",
    options: [
      "Dans chaque tribunal judiciaire",
      "Dans chaque cour d’appel",
      "Un seul TAP pour tout le territoire",
    ],
    answer: "Dans chaque cour d’appel",
    explanation:
        "La page indique qu’il existe un TAP dans le ressort de chaque cour d’appel.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Application des peines — TAP composition",
    question: "Comment est composé le TAP selon l’Article 712-10 al. 4 CPP ?",
    options: [
      "Un président et deux assesseurs désignés parmi les JAP du ressort",
      "Un juge unique",
      "Un jury populaire de 6 membres",
    ],
    answer: "Un président et deux assesseurs désignés parmi les JAP du ressort",
    explanation:
        "La page précise que le TAP comprend un président et deux assesseurs, choisis parmi les JAP du ressort de la cour.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Application des peines — TAP compétence",
    question: "Le TAP est compétent notamment pour :",
    options: [
      "Les décisions sur les contraventions",
      "Le relèvement de la période de sûreté et la libération conditionnelle des peines supérieures à 10 ans",
      "Les jugements de divorce",
    ],
    answer:
        "Le relèvement de la période de sûreté et la libération conditionnelle des peines supérieures à 10 ans",
    explanation:
        "L’Article 712-11 CPP mentionné dans la page indique ces compétences du TAP.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Application des peines — TAP recours",
    question: "Les décisions du TAP sont :",
    options: [
      "Soumises à homologation du ministre",
      "Exécutoires par provision, avec appel suspensif du ministère public s’il est formé dans les 24 heures",
      "Non susceptibles d’appel",
    ],
    answer:
        "Exécutoires par provision, avec appel suspensif du ministère public s’il est formé dans les 24 heures",
    explanation:
        "La page précise ce régime d’exécution et de recours pour les décisions du TAP.",
    difficulty: "Difficile",
  ),

  // ---------- Chambre de l’application des peines ----------
  QuizQuestion(
    category: "Application des peines — Chambre AP",
    question:
        "La chambre de l’application des peines de la cour d’appel connaît :",
    options: [
      "Des appels formés contre les décisions du JAP et du TAP",
      "Des recours en annulation de mariage",
      "Des appels en matière civile uniquement",
    ],
    answer: "Des appels formés contre les décisions du JAP et du TAP",
    explanation:
        "L’Article 712-13 CPP, cité dans la page, confie à cette chambre les appels des décisions du JAP et du TAP.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Application des peines — Chambre AP composition",
    question: "De qui est composée la chambre de l’application des peines ?",
    options: [
      "Un président et deux conseillers",
      "Un juge unique",
      "Un président, deux jurés et un greffier",
    ],
    answer: "Un président et deux conseillers",
    explanation:
        "La page indique que la chambre est composée d’un président et de deux conseillers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Application des peines — Chambre AP élargie",
    question:
        "Pour certains jugements, la chambre de l’application des peines peut être complétée par :",
    options: [
      "Un représentant de la commune et un policier municipal",
      "Un responsable d’association de réinsertion et un responsable d’association d’aide aux victimes",
      "Deux jurés populaires",
    ],
    answer:
        "Un responsable d’association de réinsertion et un responsable d’association d’aide aux victimes",
    explanation:
        "La page le précise notamment pour certains jugements mentionnés à l’Article 712-7 CPP.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Application des peines — Chambre AP pourvoi",
    question:
        "Les arrêts de la chambre de l’application des peines peuvent faire l’objet :",
    options: [
      "D’un pourvoi en cassation non suspensif dans les 5 jours",
      "D’un appel suspensif dans les 30 jours",
      "D’aucun recours",
    ],
    answer: "D’un pourvoi en cassation non suspensif dans les 5 jours",
    explanation:
        "La page mentionne que l’Article 712-15 CPP prévoit un pourvoi dans les 5 jours, non suspensif.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Généralités — Juridictions pénales",
    question:
        "Quelle distinction fondamentale est opérée entre les juridictions pénales ?",
    options: [
      "Juridictions militaires et civiles",
      "Juridictions de droit commun et juridictions d’exception",
      "Juridictions nationales et européennes",
    ],
    answer: "Juridictions de droit commun et juridictions d’exception",
    explanation:
        "On distingue les juridictions de droit commun, à compétence générale pour une catégorie d’infractions, et les juridictions d’exception, dont la compétence est limitée par un texte spécial.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Généralités — Juridictions pénales",
    question: "Les juridictions de droit commun sont compétentes pour :",
    options: [
      "Toutes les infractions sans aucune limite",
      "Toutes les infractions d’une catégorie déterminée sauf texte spécial",
      "Uniquement les infractions commises par des mineurs",
    ],
    answer:
        "Toutes les infractions d’une catégorie déterminée sauf texte spécial",
    explanation:
        "Les juridictions de droit commun (tribunal de police, tribunal correctionnel, cour d’assises…) sont compétentes pour une catégorie d’infractions définie, sauf compétence attribuée à une juridiction d’exception.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Généralités — Juridictions pénales",
    question: "Les juridictions d’exception :",
    options: [
      "Peuvent juger toutes les infractions",
      "Ont une compétence strictement limitée par les textes qui les instituent",
      "Ne jugent que les infractions routières",
    ],
    answer:
        "Ont une compétence strictement limitée par les textes qui les instituent",
    explanation:
        "Les juridictions d’exception n’ont qu’une compétence d’attribution, définie par les textes (mineurs, terrorisme, criminalité organisée, etc.).",
    difficulty: "Facile",
  ),

  // ==========================================================
  // TRIBUNAL DE POLICE
  // ==========================================================
  QuizQuestion(
    category: "Tribunal de police — Nature des infractions",
    question:
        "Quelle catégorie d’infractions est jugée par le tribunal de police ?",
    options: ["Les crimes", "Les contraventions", "Les délits"],
    answer: "Les contraventions",
    explanation:
        "Le tribunal de police connaît des contraventions, qui sont les infractions de la première catégorie (les moins graves).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal de police — Organisation",
    question:
        "Quels sont les membres qui composent le tribunal de police dans son organisation de base ?",
    options: [
      "Un président, deux assesseurs, un jury",
      "Un juge du tribunal judiciaire, un officier du ministère public et un greffier",
      "Un juge d’instruction, un juré, un assesseur",
    ],
    answer:
        "Un juge du tribunal judiciaire, un officier du ministère public et un greffier",
    explanation:
        "L’organisation décrite dans la page précise que le tribunal de police est constitué par un juge du tribunal judiciaire, un officier du ministère public et un greffier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal de police — Ministère public",
    question:
        "Qui assure les fonctions du ministère public devant le tribunal de police ?",
    options: [
      "Uniquement le procureur général près la cour d’appel",
      "Le procureur de la République près le tribunal judiciaire ou le commissaire de police",
      "Uniquement le juge d’instruction",
    ],
    answer:
        "Le procureur de la République près le tribunal judiciaire ou le commissaire de police",
    explanation:
        "Selon la page, les fonctions du ministère public sont assurées par le procureur de la République ou, dans certains cas, par le commissaire de police.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal de police — Compétence matérielle",
    question:
        "Selon l’article 521 du Code de procédure pénale, le tribunal de police est compétent pour :",
    options: [
      "Juger tous les délits",
      "Juger les contraventions",
      "Juger les crimes",
    ],
    answer: "Juger les contraventions",
    explanation:
        "La page rappelle que la compétence matérielle du tribunal de police pour les contraventions est fondée sur l’article 521 du CPP.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal de police — Connexité",
    question:
        "Outre les contraventions ordinaires, le tribunal de police peut également connaître :",
    options: [
      "Des crimes connexes",
      "Des contraventions connexes à un délit ou mal qualifiées",
      "Des litiges civils entre particuliers",
    ],
    answer: "Des contraventions connexes à un délit ou mal qualifiées",
    explanation:
        "La page précise qu’il peut connaître des contraventions connexes à un délit ou dont il a été saisi par erreur sous la qualification de délit.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal de police — Compétence territoriale",
    question:
        "En principe, quel tribunal de police est territorialement compétent ?",
    options: [
      "Celui du lieu de naissance du prévenu",
      "Celui du siège de l’entreprise détentrice du véhicule, dans tous les cas",
      "Celui du lieu de commission ou de constatation de l’infraction ou de la résidence du prévenu",
    ],
    answer:
        "Celui du lieu de commission ou de constatation de l’infraction ou de la résidence du prévenu",
    explanation:
        "La page indique qu’est compétent le tribunal de police du lieu de commission ou de constatation de l’infraction ou celui de la résidence du prévenu (article 522 alinéa 1 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal de police — Transports routiers",
    question:
        "Pour certaines infractions en matière de transports routiers, quel tribunal de police est compétent ?",
    options: [
      "Le tribunal du domicile de la victime",
      "Le tribunal du siège de l’entreprise détentrice du véhicule",
      "Le tribunal du lieu de stationnement habituel du véhicule",
    ],
    answer: "Le tribunal du siège de l’entreprise détentrice du véhicule",
    explanation:
        "La page précise qu’en matière de transports, peut être compétent le tribunal du siège de l’entreprise détentrice du véhicule (article 522 alinéa 2 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal de police — Modes de saisine",
    question:
        "Par quels moyens le tribunal de police peut-il être saisi, selon la page ?",
    options: [
      "Référé-liberté et QPC",
      "Citation directe, convocation en justice, comparution volontaire ou renvoi d’une autre juridiction",
      "Uniquement par jugement du tribunal administratif",
    ],
    answer:
        "Citation directe, convocation en justice, comparution volontaire ou renvoi d’une autre juridiction",
    explanation:
        "Les modes de saisine du tribunal de police sont listés : citation directe, convocation, comparution volontaire ou renvoi, notamment dans le cadre de la procédure d’amende forfaitaire.",
    difficulty: "Facile",
  ),

  // ==========================================================
  // TRIBUNAL CORRECTIONNEL
  // ==========================================================
  QuizQuestion(
    category: "Tribunal correctionnel — Nature des infractions",
    question:
        "Quelle catégorie d’infractions relève en principe du tribunal correctionnel ?",
    options: ["Les contraventions", "Les délits", "Les crimes"],
    answer: "Les délits",
    explanation:
        "La page rappelle que le tribunal correctionnel est la formation de jugement normale du tribunal judiciaire en matière pénale et qu’il juge les délits (article 381 CPP).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Sanctions encourues",
    question:
        "Les délits jugés par le tribunal correctionnel sont des infractions :",
    options: [
      "Punies seulement d’une amende symbolique",
      "Punies d’une peine d’emprisonnement ou d’une amende importante",
      "Punies exclusivement de la réclusion criminelle à perpétuité",
    ],
    answer: "Punies d’une peine d’emprisonnement ou d’une amende importante",
    explanation:
        "Les délits sont des infractions punies d’emprisonnement ou d’amendes importantes, ce qui justifie la compétence du tribunal correctionnel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Composition",
    question: "Dans sa formation ordinaire, le tribunal correctionnel est :",
    options: [
      "Une juridiction collégiale composée d’un président et de deux juges",
      "Un jury populaire de six membres",
      "Un juge unique assisté de jurés",
    ],
    answer:
        "Une juridiction collégiale composée d’un président et de deux juges",
    explanation:
        "La page précise qu’il s’agit d’une juridiction collégiale composée d’un président et de deux juges (article 398 alinéa 1 CPP).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Juge unique",
    question:
        "Dans quels cas le tribunal correctionnel peut-il siéger à juge unique ?",
    options: [
      "Jamais, il doit toujours être collégial",
      "Pour certains délits énumérés par la loi",
      "Uniquement pour les contraventions",
    ],
    answer: "Pour certains délits énumérés par la loi",
    explanation:
        "Pour certains délits spécifiquement prévus par le Code de procédure pénale, le tribunal peut statuer à juge unique.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Connexité",
    question: "Le tribunal correctionnel peut aussi connaître :",
    options: [
      "Des contraventions connexes à un délit",
      "Des crimes connexes sans limitation",
      "Des recours administratifs",
    ],
    answer: "Des contraventions connexes à un délit",
    explanation:
        "La page rappelle que le tribunal correctionnel peut également juger des contraventions connexes au délit (articles 381 et 466 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Modes de saisine",
    question:
        "Quel article du Code de procédure pénale liste les modes de saisine du tribunal correctionnel ?",
    options: ["Article 231 CPP", "Article 388 CPP", "Article 628-1 CPP"],
    answer: "Article 388 CPP",
    explanation:
        "La page mentionne que les modes de saisine (comparution volontaire, citation, convocation, comparution immédiate, différée, ordonnance de renvoi, etc.) sont listés à l’article 388 CPP.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Modes de saisine",
    question:
        "Parmi les modes de saisine suivants, lequel est cité dans la page comme mode de saisine du tribunal correctionnel ?",
    options: [
      "Comparution immédiate",
      "Question prioritaire de constitutionnalité",
      "Demande de grâce",
    ],
    answer: "Comparution immédiate",
    explanation:
        "La page cite la comparution immédiate (article 395 CPP), la comparution différée, la convocation en justice, la citation directe, etc.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Procédures simplifiées",
    question:
        "La page mentionne que des procédures simplifiées existent devant le tribunal correctionnel. Lesquelles ?",
    options: [
      "Ordonnance pénale, CRPC, amende forfaitaire délictuelle",
      "Référé administratif, recours gracieux, médiation",
      "Injonction de faire, saisie immobilière, hypothèque judiciaire",
    ],
    answer: "Ordonnance pénale, CRPC, amende forfaitaire délictuelle",
    explanation:
        "Sont citées les procédures : ordonnance pénale, comparution sur reconnaissance préalable de culpabilité (CRPC) et amende forfaitaire délictuelle (articles 495 à 495-25 CPP).",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // COUR D’ASSISES
  // ==========================================================
  QuizQuestion(
    category: "Cour d’assises — Nature des infractions",
    question:
        "Quelle catégorie d’infractions relève en principe de la cour d’assises ?",
    options: ["Les contraventions", "Les délits", "Les crimes"],
    answer: "Les crimes",
    explanation:
        "La cour d’assises est compétente pour juger les crimes, qui sont les infractions les plus graves.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Définition",
    question:
        "Selon la page, l’article 231 du Code de procédure pénale définit la cour d’assises comme :",
    options: [
      "Une juridiction d’instruction",
      "Ayant plénitude de juridiction pour juger en premier ressort ou en appel les personnes renvoyées devant elle par décision de mise en accusation",
      "Une juridiction de simple homologation",
    ],
    answer:
        "Ayant plénitude de juridiction pour juger en premier ressort ou en appel les personnes renvoyées devant elle par décision de mise en accusation",
    explanation:
        "La page reprend cette définition de l’article 231 du CPP, qui souligne la plénitude de juridiction de la cour d’assises.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour d’assises — Siège",
    question:
        "Il existe une cour d’assises par département. Où siège-t-elle en principe ?",
    options: [
      "Au siège de la cour d’appel ou au chef-lieu du département",
      "Uniquement à Paris",
      "Au tribunal de commerce",
    ],
    answer: "Au siège de la cour d’appel ou au chef-lieu du département",
    explanation:
        "La page précise qu’elle se tient en principe au siège de la cour d’appel ou au chef-lieu du département dans les locaux du tribunal judiciaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Composition",
    question: "La composition de la cour d’assises comprend :",
    options: [
      "Un président, deux assesseurs et un jury de citoyens tirés au sort",
      "Un juge unique et un greffier",
      "Trois jurés uniquement",
    ],
    answer:
        "Un président, deux assesseurs et un jury de citoyens tirés au sort",
    explanation:
        "La page distingue l’élément professionnel (la cour : président + deux assesseurs) et l’élément non professionnel (le jury).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Jury",
    question:
        "Combien de jurés composent le jury de la cour d’assises en premier ressort et en appel, selon la page ?",
    options: [
      "3 en premier ressort, 6 en appel",
      "6 en premier ressort, 9 en appel",
      "9 en premier ressort, 12 en appel",
    ],
    answer: "6 en premier ressort, 9 en appel",
    explanation:
        "La page indique que le jury est composé de 6 jurés en premier ressort et de 9 jurés en appel.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour d’assises — Serment des jurés",
    question:
        "Quel principe fondamental est rappelé dans le serment des jurés, selon la page ?",
    options: [
      "Le secret des affaires",
      "La présomption d’innocence et le doute qui profite à l’accusé",
      "La neutralité politique et syndicale",
    ],
    answer: "La présomption d’innocence et le doute qui profite à l’accusé",
    explanation:
        "L’article 304 CPP, cité dans la page, prévoit que le serment des jurés mentionne notamment la présomption d’innocence et le principe in dubio pro reo.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour d’assises — Ministère public",
    question:
        "Qui représente le ministère public lorsque la cour d’assises siège au siège de la cour d’appel ?",
    options: [
      "Le procureur de la République",
      "L’avocat général",
      "Le juge d’instruction",
    ],
    answer: "L’avocat général",
    explanation:
        "La page mentionne que le ministère public est représenté par l’avocat général lorsque la cour siège au siège de la cour d’appel.",
    difficulty: "Facile",
  ),

  // ==========================================================
  // COUR CRIMINELLE DÉPARTEMENTALE
  // ==========================================================
  QuizQuestion(
    category: "Cour criminelle départementale — Objet",
    question: "La cour criminelle départementale est compétente pour juger :",
    options: [
      "Les contraventions de 5ᵉ classe",
      "En premier ressort certains crimes punis de 15 ou 20 ans de réclusion criminelle lorsqu’il n’y a pas récidive légale",
      "Uniquement les crimes commis par des mineurs",
    ],
    answer:
        "En premier ressort certains crimes punis de 15 ou 20 ans de réclusion criminelle lorsqu’il n’y a pas récidive légale",
    explanation:
        "La page précise qu’elle juge en premier ressort les personnes majeures accusées de certains crimes punis de 15 ou 20 ans de réclusion, hors récidive légale.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour criminelle départementale — Composition",
    question: "Comment est composée la cour criminelle départementale ?",
    options: [
      "D’un président et quatre assesseurs, tous magistrats professionnels",
      "D’un président, deux assesseurs et six jurés",
      "Uniquement de jurés populaires",
    ],
    answer:
        "D’un président et quatre assesseurs, tous magistrats professionnels",
    explanation:
        "La page indique qu’elle est composée exclusivement de magistrats professionnels : un président et quatre assesseurs, sans jury populaire.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // JURIDICTIONS POUR MINEURS
  // ==========================================================
  QuizQuestion(
    category: "Mineurs — Généralités",
    question: "Les juridictions pour mineurs sont des juridictions :",
    options: ["De droit commun", "D’exception", "Administratives"],
    answer: "D’exception",
    explanation:
        "La page indique qu’il s’agit de juridictions d’exception, dont la compétence est déterminée par la qualité de l’auteur (mineur) et la nature de l’infraction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Mineurs — Juge des enfants",
    question: "Le juge des enfants est :",
    options: [
      "Un magistrat du parquet",
      "Un magistrat du siège spécialisé en matière de minorité",
      "Un juré populaire tiré au sort",
    ],
    answer: "Un magistrat du siège spécialisé en matière de minorité",
    explanation:
        "Selon la page, le juge des enfants est un magistrat spécialisé du siège, compétent pour juger certaines infractions commises par des mineurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Mineurs — Juge des enfants",
    question: "Selon la page, le juge des enfants est compétent pour juger :",
    options: [
      "Uniquement les contraventions de 1ʳᵉ classe des mineurs",
      "Les contraventions de 5ᵉ classe et de nombreux délits commis par des mineurs",
      "Les crimes commis par des majeurs en récidive",
    ],
    answer:
        "Les contraventions de 5ᵉ classe et de nombreux délits commis par des mineurs",
    explanation:
        "La page indique qu’il juge les contraventions de 5ᵉ classe et de nombreux délits, notamment selon la procédure de mise à l’épreuve éducative.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Mineurs — Tribunal pour enfants",
    question: "Le tribunal pour enfants est présidé par :",
    options: [
      "Le président du tribunal judiciaire",
      "Le juge des enfants",
      "Le procureur de la République",
    ],
    answer: "Le juge des enfants",
    explanation:
        "La page précise que le tribunal pour enfants est présidé par le juge des enfants.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Mineurs — Tribunal pour enfants",
    question: "Les assesseurs du tribunal pour enfants sont :",
    options: [
      "Des magistrats professionnels de la cour d’appel",
      "Des citoyens non magistrats choisis pour leur intérêt et leurs compétences en matière de protection de l’enfance",
      "Des militaires de la gendarmerie",
    ],
    answer:
        "Des citoyens non magistrats choisis pour leur intérêt et leurs compétences en matière de protection de l’enfance",
    explanation:
        "La page souligne que ces assesseurs ne sont pas des magistrats, mais des personnes sélectionnées pour leur intérêt et leurs compétences sur les questions d’enfance.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Mineurs — Cour d’assises des mineurs",
    question: "La cour d’assises des mineurs est compétente pour :",
    options: [
      "Les crimes commis par les mineurs de seize à dix-huit ans et certaines infractions connexes",
      "Les litiges civils relatifs à l’autorité parentale",
      "Les contraventions de 3ᵉ classe commises par des mineurs",
    ],
    answer:
        "Les crimes commis par les mineurs de seize à dix-huit ans et certaines infractions connexes",
    explanation:
        "La page indique qu’elle juge les crimes commis par les mineurs de 16 à 18 ans et certains faits connexes.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Mineurs — Appel",
    question:
        "Selon la page, à quelle juridiction sont portés les appels des jugements rendus à l’égard des mineurs ?",
    options: [
      "La chambre criminelle de la Cour de cassation",
      "La chambre spéciale des mineurs de la cour d’appel",
      "La cour d’assises de Paris",
    ],
    answer: "La chambre spéciale des mineurs de la cour d’appel",
    explanation:
        "Le Nota précise que l’appel relève de la chambre spéciale des mineurs de la cour d’appel (chambre de l’enfance).",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // TERRORISME
  // ==========================================================
  QuizQuestion(
    category: "Terrorisme — Juridictions spécialisées",
    question:
        "En matière de terrorisme, quelles juridictions sont compétentes selon la page ?",
    options: [
      "Uniquement les tribunaux de police",
      "Des juridictions parisiennes spécialisées (pôle antiterroriste et cour d’assises spéciale)",
      "Uniquement les juridictions militaires",
    ],
    answer:
        "Des juridictions parisiennes spécialisées (pôle antiterroriste et cour d’assises spéciale)",
    explanation:
        "Les crimes et délits à caractère terroriste peuvent être jugés par des juridictions parisiennes spécialisées, compétentes sur tout le territoire.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Terrorisme — Cour d’assises spéciale",
    question:
        "Quelle particularité présente la cour d’assises spéciale en matière de terrorisme, d’après la page ?",
    options: [
      "Elle statue uniquement sur dossier écrit",
      "Elle statue sans jury populaire, avec des magistrats professionnels uniquement",
      "Elle statue uniquement en dernier ressort",
    ],
    answer:
        "Elle statue sans jury populaire, avec des magistrats professionnels uniquement",
    explanation:
        "La page mentionne que la cour d’assises de Paris, en matière terroriste, est composée de magistrats professionnels (article 698-6 CPP).",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // ECONOMIQUE & FINANCIER
  // ==========================================================
  QuizQuestion(
    category: "Économique et financière — Compétence territoriale",
    question:
        "Dans les affaires économiques et financières complexes, la compétence territoriale d’un tribunal judiciaire peut :",
    options: [
      "Être limitée au seul canton",
      "Être étendue au ressort de plusieurs cours d’appel",
      "Être transférée automatiquement au tribunal administratif",
    ],
    answer: "Être étendue au ressort de plusieurs cours d’appel",
    explanation:
        "L’article 704 CPP, repris dans la page, prévoit cette extension de compétence en matière économique et financière complexe.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Économique et financière — Procureur financier",
    question:
        "Le procureur de la République financier exerce ses attributions :",
    options: [
      "Près de chaque tribunal correctionnel du territoire",
      "Près du tribunal judiciaire de Paris avec compétence nationale",
      "Uniquement près de la Cour de cassation",
    ],
    answer: "Près du tribunal judiciaire de Paris avec compétence nationale",
    explanation:
        "La page rappelle qu’il exerce près le TJ de Paris mais qu’il est compétent sur tout le territoire national (article 705 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Économique et financière — Infractions boursières",
    question:
        "Les infractions boursières et financières mentionnées dans la page sont principalement prévues dans :",
    options: [
      "Le Code civil",
      "Le Code monétaire et financier",
      "Le Code de la sécurité intérieure",
    ],
    answer: "Le Code monétaire et financier",
    explanation:
        "Sont visés les articles L.465-1 à L.465-3-3 du Code monétaire et financier.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // CRIMINALITÉ ORGANISÉE & JIRS
  // ==========================================================
  QuizQuestion(
    category: "Criminalité organisée — Infractions",
    question: "Les articles 706-73 et 706-73-1 du CPP listent notamment :",
    options: [
      "Les règles de compétence des tribunaux administratifs",
      "Les infractions de criminalité organisée (terrorisme, trafics, traite, etc.)",
      "Les voies de recours ordinaires",
    ],
    answer:
        "Les infractions de criminalité organisée (terrorisme, trafics, traite, etc.)",
    explanation:
        "La page rappelle que ces articles regroupent les infractions de criminalité organisée (terrorisme, stupéfiants, traite des êtres humains, atteintes aux intérêts fondamentaux de la nation…).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Criminalité organisée — Compétence territoriale",
    question:
        "En matière de criminalité organisée, la compétence territoriale d’un tribunal judiciaire ou d’une cour d’assises peut :",
    options: [
      "Être limitée au seul ressort du tribunal judiciaire",
      "Être étendue au ressort d’une ou plusieurs cours d’appel",
      "Être automatiquement transférée à la Cour de cassation",
    ],
    answer: "Être étendue au ressort d’une ou plusieurs cours d’appel",
    explanation:
        "La page évoque l’extension de compétence territoriale prévue par les articles 706-73, 706-73-1, 706-74 et surtout 706-75 CPP.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Criminalité organisée — Compétence concurrente",
    question:
        "Pour les infractions de criminalité organisée, la compétence du parquet, du juge d’instruction et de la formation correctionnelle spécialisée est :",
    options: [
      "Exclusivement locale",
      "Concurrente à la compétence de droit commun",
      "Subordonnée à l’autorisation du gouvernement",
    ],
    answer: "Concurrente à la compétence de droit commun",
    explanation:
        "L’article 706-75 CPP, cité dans la page, prévoit une compétence concurrente des formations spécialisées.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Criminalité organisée — JIRS",
    question:
        "Combien de juridictions interrégionales spécialisées (JIRS) sont mentionnées dans la page ?",
    options: ["4", "6", "8"],
    answer: "8",
    explanation:
        "La page indique huit JIRS : Paris, Lyon, Marseille, Lille, Rennes, Bordeaux, Nancy et Fort-de-France (article D.47-3 CPP).",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // CRIMES CONTRE L’HUMANITÉ / GUERRE
  // ==========================================================
  QuizQuestion(
    category: "Crimes contre l’humanité / Guerre",
    question:
        "Selon la page, les crimes contre l’humanité et les crimes et délits de guerre peuvent être jugés :",
    options: [
      "Uniquement par la Cour pénale internationale",
      "Par les tribunaux territorialement compétents ou par des juridictions parisiennes spécialisées",
      "Uniquement par un tribunal militaire",
    ],
    answer:
        "Par les tribunaux territorialement compétents ou par des juridictions parisiennes spécialisées",
    explanation:
        "La page mentionne que l’article 628-1 CPP prévoit cette double possibilité.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // CRIMES SERIELS / NON ELUCIDÉS
  // ==========================================================
  QuizQuestion(
    category: "Crimes sériels ou non élucidés",
    question:
        "Quel tribunal est désigné comme pôle judiciaire national spécialisé pour les crimes sériels ou non élucidés ?",
    options: [
      "Le tribunal judiciaire de Paris",
      "Le tribunal judiciaire de Nanterre",
      "Le tribunal judiciaire de Marseille",
    ],
    answer: "Le tribunal judiciaire de Nanterre",
    explanation:
        "La page indique que le TJ de Nanterre est désigné comme pôle national spécialisé pour ces crimes (article 706-106-1 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Crimes sériels ou non élucidés",
    question:
        "Selon la page, le pôle spécialisé de Nanterre est notamment compétent lorsque :",
    options: [
      "La peine encourue est inférieure à 2 ans",
      "Les investigations présentent une particulière complexité",
      "L’infraction est purement contraventionnelle",
    ],
    answer: "Les investigations présentent une particulière complexité",
    explanation:
        "La compétence est liée à la complexité et au caractère sériel ou non élucidé des crimes, notamment lorsque l’auteur n’est pas identifié plus de 18 mois après les faits.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // TRIBUNAUX MILITAIRES
  // ==========================================================
  QuizQuestion(
    category: "Tribunaux militaires — Infractions en service",
    question:
        "Selon la page, les infractions militaires et les crimes ou délits de droit commun commis dans l’exercice du service par les militaires relèvent :",
    options: [
      "Des juridictions de droit commun",
      "De juridictions spécialisées en matière militaire",
      "Exclusivement de la Cour de cassation",
    ],
    answer: "De juridictions spécialisées en matière militaire",
    explanation:
        "La page rappelle que ces infractions relèvent de juridictions spécialisées (un tribunal judiciaire par cour d’appel, article 697 CPP).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunaux militaires — Infractions hors service",
    question:
        "Toute infraction commise par un militaire en dehors de l’exercice du service relève :",
    options: [
      "Des juridictions militaires",
      "Des juridictions de droit commun",
      "D’aucune juridiction pénale",
    ],
    answer: "Des juridictions de droit commun",
    explanation:
        "L’article L.2 du Code de justice militaire, mentionné dans la page, renvoie ces infractions au droit commun.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunaux militaires — Hors du territoire national",
    question:
        "Certains tribunaux judiciaires sont spécialement compétents pour les infractions commises par ou à l’encontre de militaires français :",
    options: [
      "Sur le territoire national uniquement",
      "Hors du territoire national",
      "Uniquement dans les DOM-TOM",
    ],
    answer: "Hors du territoire national",
    explanation:
        "La page cite l’article L.111-1 du Code de justice militaire, qui concerne les infractions commises hors du territoire national.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // LITTORAL MARITIME
  // ==========================================================
  QuizQuestion(
    category: "Littoral maritime — Objet",
    question:
        "Les juridictions du littoral maritime spécialisées sont compétentes notamment pour :",
    options: [
      "La pollution des eaux maritimes par rejets de navires et certaines atteintes aux biens culturels maritimes",
      "Les infractions routières",
      "Les délits forestiers",
    ],
    answer:
        "La pollution des eaux maritimes par rejets de navires et certaines atteintes aux biens culturels maritimes",
    explanation:
        "La page mentionne les articles 706-107 à 706-111-2 CPP relatifs à ces infractions.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Littoral maritime — Compétence",
    question:
        "La compétence des juridictions du littoral maritime spécialisées est :",
    options: [
      "Exclusivement locale",
      "Concurrente avec celle des tribunaux territorialement compétents",
      "Subordonnée à l’accord des autorités portuaires",
    ],
    answer: "Concurrente avec celle des tribunaux territorialement compétents",
    explanation:
        "La page précise que ces juridictions ont une compétence concurrente pour l’enquête, la poursuite, l’instruction et le jugement, sauf pour certains faits commis en haute mer.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // SANITAIRE & ENVIRONNEMENTALE
  // ==========================================================
  QuizQuestion(
    category: "Sanitaire et environnementale — Textes",
    question:
        "Quels articles du Code de procédure pénale organisent la procédure applicable aux infractions en matière sanitaire et environnementale, d’après la page ?",
    options: [
      "Articles 495 à 495-25 CPP",
      "Articles 706-2 à 706-2-3 CPP",
      "Articles 489 à 493-1 CPP",
    ],
    answer: "Articles 706-2 à 706-2-3 CPP",
    explanation:
        "La page cite ces articles comme base de la procédure spéciale en matière sanitaire et environnementale.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Sanitaire et environnementale — Compétence territoriale",
    question:
        "En matière sanitaire et environnementale, la compétence territoriale d’un tribunal judiciaire peut être étendue :",
    options: [
      "Au seul ressort du tribunal de commerce",
      "Au ressort d’une ou plusieurs cours d’appel pour des affaires complexes",
      "Uniquement à la région administrative",
    ],
    answer:
        "Au ressort d’une ou plusieurs cours d’appel pour des affaires complexes",
    explanation:
        "La page précise que cette extension concerne les affaires de grande complexité, notamment liées à certains produits ou pratiques.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Sanitaire et environnementale — Types d’affaires",
    question:
        "Les affaires sanitaires et environnementales visées concernent notamment :",
    options: [
      "Les litiges électoraux",
      "Les produits de santé, l’alimentation, et certaines pratiques médicales ou esthétiques dangereuses",
      "Les conflits de voisinage",
    ],
    answer:
        "Les produits de santé, l’alimentation, et certaines pratiques médicales ou esthétiques dangereuses",
    explanation:
        "La page cite explicitement les produits de santé, l’alimentation humaine ou animale, et certaines prestations médicales/esthétiques.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Sanitaire et environnementale — Pôles spécialisés",
    question:
        "Selon la page, quels tribunaux judiciaires sont actuellement désignés comme pôles spécialisés en matière sanitaire et environnementale ?",
    options: ["Lyon et Bordeaux", "Paris et Marseille", "Rennes et Lille"],
    answer: "Paris et Marseille",
    explanation:
        "La page indique que les tribunaux judiciaires de Paris et Marseille sont désignés comme pôles spécialisés (article D.47-5 CPP).",
    difficulty: "Facile",
  ),

  // ==========================================================
  // VOIES DE RECOURS — GENERALITES
  // ==========================================================
  QuizQuestion(
    category: "Voies de recours — Généralités",
    question:
        "Une décision rendue par une juridiction répressive acquiert autorité de chose jugée lorsque :",
    options: [
      "Elle a été signée par le greffier",
      "Elle n’est plus susceptible de voie de recours",
      "Le prévenu a payé son amende",
    ],
    answer: "Elle n’est plus susceptible de voie de recours",
    explanation:
        "La page indique que l’autorité de chose jugée suppose l’épuisement ou l’expiration des voies de recours.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Voies de recours — Généralités",
    question:
        "Quelles sont les voies de recours ordinaires mentionnées dans la page ?",
    options: [
      "Opposition et appel",
      "Pourvoi en cassation et révision",
      "QPC et recours gracieux",
    ],
    answer: "Opposition et appel",
    explanation:
        "Les voies de recours ordinaires sont l’opposition et l’appel, ouvertes pour tout motif de fond ou de forme.",
    difficulty: "Facile",
  ),

  // ==========================================================
  // OPPOSITION
  // ==========================================================
  QuizQuestion(
    category: "Opposition — Conditions",
    question: "L’opposition est possible lorsque le jugement a été rendu :",
    options: [
      "En présence du prévenu",
      "Par défaut",
      "Par la Cour de cassation",
    ],
    answer: "Par défaut",
    explanation:
        "La page rappelle que l’opposition est possible si le jugement a été rendu par défaut, c’est-à-dire sans comparution régulière du prévenu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Opposition — Délai",
    question:
        "Selon la page, le délai de principe pour former opposition lorsque le prévenu réside en France métropolitaine est de :",
    options: ["3 jours", "10 jours", "1 mois"],
    answer: "10 jours",
    explanation:
        "Le délai est de 10 jours à compter de la signification du jugement en métropole (un mois hors territoire).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Opposition — Effet extinctif",
    question:
        "Quel est l’effet principal de l’opposition sur la décision rendue par défaut ?",
    options: [
      "Elle suspend simplement l’exécution de la peine",
      "Elle anéantit la décision rendue par défaut",
      "Elle transforme la décision en simple avertissement",
    ],
    answer: "Elle anéantit la décision rendue par défaut",
    explanation:
        "La page précise que l’opposition a un effet extinctif : la décision par défaut ne reçoit pas exécution.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Opposition — Prescription",
    question: "Selon la page, l’opposition :",
    options: [
      "N’a aucun effet sur la prescription",
      "Interrompt la prescription de la peine et fait courir une nouvelle prescription de l’action publique",
      "Supprime toute prescription",
    ],
    answer:
        "Interrompt la prescription de la peine et fait courir une nouvelle prescription de l’action publique",
    explanation:
        "L’opposition a un effet interruptif sur la prescription de la peine et marque le point de départ d’une nouvelle prescription de l’action publique.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Opposition — Itératif défaut",
    question:
        "En cas d’« itératif défaut » lors de l’audience d’opposition, la page indique que :",
    options: [
      "L’opposition est maintenue et l’affaire est renvoyée",
      "L’opposition est déclarée non avenue et la décision initiale reprend pleine valeur",
      "L’affaire est automatiquement portée devant la Cour de cassation",
    ],
    answer:
        "L’opposition est déclarée non avenue et la décision initiale reprend pleine valeur",
    explanation:
        "Si le prévenu, régulièrement avisé, ne comparaît pas à nouveau, l’opposition est non avenue et le jugement initial reprend tous ses effets.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // APPEL
  // ==========================================================
  QuizQuestion(
    category: "Appel — Définition",
    question:
        "L’appel est défini dans la page comme une voie de recours qui permet :",
    options: [
      "De saisir directement la Cour européenne des droits de l’homme",
      "À une juridiction supérieure de procéder à un nouvel examen de l’affaire",
      "De transformer l’infraction en simple avertissement",
    ],
    answer:
        "À une juridiction supérieure de procéder à un nouvel examen de l’affaire",
    explanation:
        "C’est l’effet dévolutif de l’appel : la juridiction d’appel réexamine l’affaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Appel — Décisions susceptibles",
    question:
        "Selon la page, les jugements rendus en matière correctionnelle :",
    options: [
      "Sont en principe susceptibles d’appel",
      "Ne sont jamais susceptibles d’appel",
      "Ne peuvent faire l’objet que d’un pourvoi en cassation",
    ],
    answer: "Sont en principe susceptibles d’appel",
    explanation:
        "La page indique qu’ils peuvent presque toujours faire l’objet d’un appel, sauf exceptions prévues par la loi.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Appel — Personnes ayant qualité",
    question:
        "Parmi les personnes suivantes, lesquelles peuvent interjeter appel en matière correctionnelle, d’après la page ?",
    options: [
      "Uniquement le prévenu",
      "Uniquement le ministère public",
      "Toutes les parties au procès (prévenu, ministère public, partie civile, civilement responsable, etc.)",
    ],
    answer:
        "Toutes les parties au procès (prévenu, ministère public, partie civile, civilement responsable, etc.)",
    explanation:
        "La page détaille les différentes parties ayant qualité pour faire appel en matière criminelle, correctionnelle et de police.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Appel — Délai",
    question:
        "En principe, quel est le délai pour interjeter appel d’un jugement contradictoire, selon la page ?",
    options: ["24 heures", "3 jours", "10 jours"],
    answer: "10 jours",
    explanation:
        "Le délai de principe est de 10 jours à compter du prononcé ou de la signification, sauf délais particuliers (détention, mise en liberté…).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Appel — Effets",
    question:
        "Quels sont les deux effets principaux de l’appel, tels que présentés dans la page ?",
    options: [
      "Effet suspensif et effet dévolutif",
      "Effet déclaratif et effet rétroactif",
      "Effet absolu et effet relatif",
    ],
    answer: "Effet suspensif et effet dévolutif",
    explanation:
        "L’appel suspend en principe l’exécution de la décision (sauf exceptions) et dévolue l’affaire à une juridiction supérieure.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Généralités — Juridictions pénales",
    question:
        "Quelle distinction fondamentale est opérée entre les juridictions pénales ?",
    options: [
      "Juridictions militaires et civiles",
      "Juridictions de droit commun et juridictions d’exception",
      "Juridictions nationales et européennes",
    ],
    answer: "Juridictions de droit commun et juridictions d’exception",
    explanation:
        "On distingue les juridictions de droit commun (compétentes pour une catégorie large d’infractions) et les juridictions d’exception, dont la compétence est strictement déterminée par un texte.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Généralités — Juridictions pénales",
    question: "Les juridictions de droit commun sont compétentes pour :",
    options: [
      "Toutes les infractions sans aucune limite",
      "Toutes les infractions d’une catégorie déterminée sauf texte spécial contraire",
      "Uniquement les infractions commises par des mineurs",
    ],
    answer:
        "Toutes les infractions d’une catégorie déterminée sauf texte spécial contraire",
    explanation:
        "Les juridictions de droit commun ont une compétence générale pour une catégorie d’infractions (contraventions, délits, crimes), sauf lorsqu’un texte spécial attribue la compétence à une juridiction d’exception.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Généralités — Juridictions pénales",
    question: "Les juridictions d’exception voient leur compétence :",
    options: [
      "Étendue à toutes les infractions",
      "Limitée par un texte spécial qui les crée",
      "Fixée librement par le juge",
    ],
    answer: "Limitée par un texte spécial qui les crée",
    explanation:
        "Les juridictions d’exception n’ont qu’une compétence d’attribution, délimitée par les textes qui les instituent.",
    difficulty: "Facile",
  ),

  // ==========================================================
  // TRIBUNAL DE POLICE
  // ==========================================================
  QuizQuestion(
    category: "Tribunal de police — Généralités",
    question:
        "Quelle catégorie d’infractions est jugée par le tribunal de police ?",
    options: ["Les crimes", "Les contraventions", "Les délits"],
    answer: "Les contraventions",
    explanation:
        "Le tribunal de police connaît des contraventions, qui constituent la catégorie d’infractions la moins grave.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal de police — Organisation",
    question: "Quel magistrat siège comme juge au tribunal de police ?",
    options: [
      "Un juge du tribunal judiciaire",
      "Un conseiller à la cour d’appel",
      "Un juré tiré au sort",
    ],
    answer: "Un juge du tribunal judiciaire",
    explanation:
        "Le tribunal de police est constitué par un juge du tribunal judiciaire, qui préside l’audience.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal de police — Organisation",
    question: "Quels sont les membres qui composent le tribunal de police ?",
    options: [
      "Un président, deux assesseurs et un jury",
      "Un juge du tribunal judiciaire, un officier du ministère public et un greffier",
      "Un juge d’instruction, un procureur général et un juré",
    ],
    answer:
        "Un juge du tribunal judiciaire, un officier du ministère public et un greffier",
    explanation:
        "Le tribunal de police comprend un juge du tribunal judiciaire, un officier du ministère public (par exemple le commissaire de police) et un greffier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal de police — Compétence matérielle",
    question:
        "Selon l’article 521 du Code de procédure pénale, le tribunal de police est compétent pour :",
    options: [
      "Juger tous les délits",
      "Juger les contraventions",
      "Juger les crimes",
    ],
    answer: "Juger les contraventions",
    explanation:
        "L’article 521 du CPP précise que le tribunal de police connaît des contraventions.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal de police — Compétence matérielle",
    question:
        "Outre les contraventions simples, le tribunal de police peut également connaître :",
    options: [
      "Des crimes connexes",
      "Des contraventions connexes à un délit ou mal qualifiées",
      "Des litiges civils entre particuliers",
    ],
    answer: "Des contraventions connexes à un délit ou mal qualifiées",
    explanation:
        "Le tribunal de police peut connaître des contraventions connexes à un délit ou d’une contravention initialement qualifiée à tort de délit.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal de police — Compétence territoriale",
    question:
        "En principe, quel tribunal de police est territorialement compétent ?",
    options: [
      "Celui du lieu de naissance du prévenu",
      "Celui du siège de l’entreprise détentrice du véhicule",
      "Celui du lieu de commission ou de constatation de l’infraction, ou de la résidence du prévenu",
    ],
    answer:
        "Celui du lieu de commission ou de constatation de l’infraction, ou de la résidence du prévenu",
    explanation:
        "L’article 522 alinéa 1 du CPP prévoit la compétence du tribunal de police du lieu de commission/constatation ou de la résidence du prévenu.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal de police — Compétence territoriale",
    question:
        "Pour certaines infractions de transport routier, quel tribunal de police est compétent ?",
    options: [
      "Le tribunal du siège de l’entreprise détentrice du véhicule",
      "Le tribunal du domicile de la victime",
      "Le tribunal du lieu d’immatriculation du véhicule",
    ],
    answer: "Le tribunal du siège de l’entreprise détentrice du véhicule",
    explanation:
        "L’article 522 alinéa 2 du CPP prévoit, pour certaines infractions liées au transport, la compétence du tribunal du siège de l’entreprise détentrice du véhicule.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal de police — Modes de saisine",
    question: "Le tribunal de police peut être saisi notamment par :",
    options: [
      "Référé-liberté",
      "Citation directe, convocation en justice ou comparution volontaire",
      "Question prioritaire de constitutionnalité",
    ],
    answer:
        "Citation directe, convocation en justice ou comparution volontaire",
    explanation:
        "Les principaux modes de saisine du tribunal de police sont la citation directe, la convocation en justice, la comparution volontaire ou le renvoi par une autre juridiction.",
    difficulty: "Facile",
  ),

  // ==========================================================
  // TRIBUNAL CORRECTIONNEL
  // ==========================================================
  QuizQuestion(
    category: "Tribunal correctionnel — Généralités",
    question:
        "Quelle catégorie d’infractions est jugée par le tribunal correctionnel ?",
    options: ["Les contraventions", "Les délits", "Les crimes"],
    answer: "Les délits",
    explanation:
        "Selon l’article 381 du CPP, le tribunal correctionnel juge les délits, infractions punies d’emprisonnement ou d’amendes importantes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Composition",
    question: "Dans sa formation ordinaire, le tribunal correctionnel est :",
    options: [
      "Une juridiction collégiale composée d’un président et de deux juges",
      "Un juge unique",
      "Un jury populaire de six personnes",
    ],
    answer:
        "Une juridiction collégiale composée d’un président et de deux juges",
    explanation:
        "L’article 398 alinéa 1 du CPP prévoit une formation collégiale avec un président et deux juges.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Composition",
    question:
        "Dans quels cas le tribunal correctionnel peut-il siéger à juge unique ?",
    options: [
      "Jamais, il doit toujours être collégial",
      "Pour certains délits expressément prévus par la loi",
      "Uniquement en matière criminelle",
    ],
    answer: "Pour certains délits expressément prévus par la loi",
    explanation:
        "Pour des délits déterminés par le CPP (par exemple en matière de circulation routière), le tribunal peut siéger à juge unique.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Compétence",
    question: "Le tribunal correctionnel juge :",
    options: [
      "Tous les délits qui ne sont pas attribués à une juridiction particulière",
      "Uniquement les délits commis par des mineurs",
      "Uniquement les délits politiques",
    ],
    answer:
        "Tous les délits qui ne sont pas attribués à une juridiction particulière",
    explanation:
        "Le tribunal correctionnel est la juridiction de droit commun pour les délits, sauf compétence attribuée à une autre juridiction (terrorisme, mineurs, etc.).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Compétence",
    question: "Le tribunal correctionnel peut également connaître :",
    options: [
      "De contraventions connexes à un délit",
      "De tous les crimes connexes",
      "De recours contre les décisions administratives",
    ],
    answer: "De contraventions connexes à un délit",
    explanation:
        "En cas de connexité, le tribunal correctionnel peut juger des contraventions liées aux délits dont il connaît.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Saisine",
    question:
        "Parmi les modes de saisine suivants, lequel ne concerne PAS le tribunal correctionnel ?",
    options: [
      "Comparution immédiate",
      "Comparution différée",
      "Question prioritaire de constitutionnalité",
    ],
    answer: "Question prioritaire de constitutionnalité",
    explanation:
        "La QPC n’est pas un mode de saisine du tribunal correctionnel mais un mécanisme de contrôle de constitutionnalité. Les autres (comparution immédiate, différée, convocation, citation…) sont des modes de saisine.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Procédures simplifiées",
    question:
        "La comparution sur reconnaissance préalable de culpabilité (CRPC) est :",
    options: [
      "Une procédure de jugement des crimes",
      "Une procédure simplifiée applicable à certains délits",
      "Une mesure de grâce présidentielle",
    ],
    answer: "Une procédure simplifiée applicable à certains délits",
    explanation:
        "La CRPC est une procédure simplifiée de reconnaissance de culpabilité pour certains délits, prévue par les articles 495-7 à 495-16 du CPP.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Procédures simplifiées",
    question:
        "Parmi les procédures suivantes, laquelle est une procédure simplifiée devant le tribunal correctionnel ?",
    options: [
      "Ordonnance pénale délictuelle",
      "Référé administratif",
      "Recours hiérarchique",
    ],
    answer: "Ordonnance pénale délictuelle",
    explanation:
        "L’ordonnance pénale est une procédure simplifiée, tout comme la CRPC ou l’amende forfaitaire délictuelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Tribunal correctionnel — Modes de saisine",
    question:
        "Les modes de saisine du tribunal correctionnel sont énumérés à :",
    options: [
      "L’article 381 du CPP",
      "L’article 388 du CPP",
      "L’article 304 du CPP",
    ],
    answer: "L’article 388 du CPP",
    explanation:
        "L’article 388 du CPP liste les différents modes de saisine du tribunal correctionnel (comparution volontaire, citation, convocation, etc.).",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // COUR D’ASSISES
  // ==========================================================
  QuizQuestion(
    category: "Cour d’assises — Généralités",
    question:
        "Quelle catégorie d’infractions relève en principe de la cour d’assises ?",
    options: ["Les contraventions", "Les délits", "Les crimes"],
    answer: "Les crimes",
    explanation:
        "La cour d’assises est la juridiction de droit commun pour le jugement des crimes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Définition",
    question: "Selon l’article 231 du CPP, la cour d’assises a :",
    options: [
      "Une compétence limitée aux crimes commis par des mineurs",
      "Plénitude de juridiction pour juger en premier ressort ou en appel les personnes renvoyées devant elle",
      "Compétence uniquement en appel",
    ],
    answer:
        "Plénitude de juridiction pour juger en premier ressort ou en appel les personnes renvoyées devant elle",
    explanation:
        "L’article 231 du CPP donne à la cour d’assises plénitude de juridiction pour connaître des affaires criminelles qui lui sont renvoyées.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour d’assises — Siège",
    question: "Où siège en principe la cour d’assises ?",
    options: [
      "Toujours à Paris",
      "Au siège de la cour d’appel ou au chef-lieu du département",
      "Au tribunal de commerce",
    ],
    answer: "Au siège de la cour d’appel ou au chef-lieu du département",
    explanation:
        "Il existe une cour d’assises par département, siégeant en principe au siège de la cour d’appel ou au chef-lieu du département.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Composition",
    question: "La cour d’assises se compose de :",
    options: [
      "Magistrats professionnels et jurés populaires",
      "Uniquement de jurés populaires",
      "Uniquement de magistrats professionnels",
    ],
    answer: "Magistrats professionnels et jurés populaires",
    explanation:
        "La cour d’assises a une composition mixte : une cour (magistrats professionnels) et un jury (citoyens tirés au sort).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Jury",
    question:
        "Combien de jurés composent le jury en premier ressort devant la cour d’assises ?",
    options: ["3 jurés", "6 jurés", "9 jurés"],
    answer: "6 jurés",
    explanation:
        "En premier ressort, la cour d’assises siège avec 6 jurés (et 9 jurés en appel).",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour d’assises — Jury",
    question:
        "Quel principe fondamental est rappelé dans le serment des jurés ?",
    options: [
      "Le secret des affaires",
      "La présomption d’innocence et le doute qui profite à l’accusé",
      "La neutralité politique",
    ],
    answer: "La présomption d’innocence et le doute qui profite à l’accusé",
    explanation:
        "L’article 304 du CPP prévoit que le serment des jurés rappelle la présomption d’innocence et la règle du doute qui profite à l’accusé.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour d’assises — Ministère public",
    question:
        "Qui représente le ministère public lorsque la cour d’assises siège au siège de la cour d’appel ?",
    options: [
      "Le procureur de la République",
      "L’avocat général",
      "Le juge d’instruction",
    ],
    answer: "L’avocat général",
    explanation:
        "Lorsque la cour siège au siège de la cour d’appel, le ministère public est représenté par l’avocat général.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cour d’assises — Décisions",
    question:
        "À quelle majorité une décision défavorable à l’accusé doit-elle être prise en cour d’assises ?",
    options: [
      "À l’unanimité",
      "À la majorité absolue des voix",
      "À une majorité renforcée (au moins 7 voix en premier ressort)",
    ],
    answer: "À une majorité renforcée (au moins 7 voix en premier ressort)",
    explanation:
        "En cour d’assises, les décisions défavorables à l’accusé doivent recueillir une majorité qualifiée (par exemple 7 voix au moins en premier ressort).",
    difficulty: "Difficile",
  ),

  // ==========================================================
  // COUR CRIMINELLE DÉPARTEMENTALE
  // ==========================================================
  QuizQuestion(
    category: "Cour criminelle départementale",
    question:
        "Quel est l’objet principal de la cour criminelle départementale ?",
    options: [
      "Juger les contraventions de 5ᵉ classe",
      "Juger en premier ressort certains crimes punis de 15 ou 20 ans de réclusion",
      "Juger uniquement les crimes commis par des mineurs",
    ],
    answer:
        "Juger en premier ressort certains crimes punis de 15 ou 20 ans de réclusion",
    explanation:
        "Les articles 380-16 à 380-22 du CPP prévoient que la cour criminelle départementale juge certains crimes graves, sans jury populaire.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Cour criminelle départementale",
    question: "La cour criminelle départementale est composée :",
    options: [
      "Uniquement de jurés",
      "D’un président et de quatre assesseurs, tous magistrats professionnels",
      "D’un président, de deux assesseurs et de six jurés",
    ],
    answer:
        "D’un président et de quatre assesseurs, tous magistrats professionnels",
    explanation:
        "La cour criminelle départementale est une juridiction intégralement composée de magistrats professionnels.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // JURIDICTIONS POUR MINEURS
  // ==========================================================
  QuizQuestion(
    category: "Mineurs — Généralités",
    question: "Les juridictions pour mineurs sont :",
    options: [
      "Des juridictions de droit commun",
      "Des juridictions d’exception",
      "Des juridictions administratives",
    ],
    answer: "Des juridictions d’exception",
    explanation:
        "Les juridictions pour mineurs (juge des enfants, tribunal pour enfants, cour d’assises des mineurs) sont des juridictions d’exception, dont la compétence résulte de textes spécifiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Mineurs — Juge des enfants",
    question: "Le juge des enfants est :",
    options: [
      "Un magistrat du parquet",
      "Un magistrat du siège spécialisé en matière de minorité",
      "Un magistrat militaire",
    ],
    answer: "Un magistrat du siège spécialisé en matière de minorité",
    explanation:
        "Le juge des enfants est un magistrat du siège, spécialement désigné pour connaître des affaires concernant les mineurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Mineurs — Juge des enfants",
    question: "Le juge des enfants peut juger :",
    options: [
      "Les contraventions de 5ᵉ classe et de nombreux délits commis par des mineurs",
      "Uniquement les crimes des mineurs",
      "Uniquement les contraventions des majeurs",
    ],
    answer:
        "Les contraventions de 5ᵉ classe et de nombreux délits commis par des mineurs",
    explanation:
        "Selon le Code de justice pénale des mineurs, le juge des enfants connaît des contraventions de 5ᵉ classe et de nombreux délits, suivant la procédure de mise à l’épreuve éducative.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Mineurs — Tribunal pour enfants",
    question: "Le tribunal pour enfants est présidé par :",
    options: [
      "Le président du tribunal judiciaire",
      "Le juge des enfants",
      "Un conseiller à la cour d’appel",
    ],
    answer: "Le juge des enfants",
    explanation:
        "Le tribunal pour enfants est présidé par le juge des enfants, assisté de deux assesseurs non professionnels.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Mineurs — Tribunal pour enfants",
    question: "Les assesseurs du tribunal pour enfants sont :",
    options: [
      "Des magistrats professionnels",
      "Des membres du jury populaire",
      "Des citoyens nommés pour leurs compétences en matière d’enfance",
    ],
    answer: "Des citoyens nommés pour leurs compétences en matière d’enfance",
    explanation:
        "Les assesseurs ne sont pas des magistrats, mais des personnes choisies pour leur intérêt et leurs compétences concernant l’enfance.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Mineurs — Cour d’assises des mineurs",
    question: "La cour d’assises des mineurs est compétente pour :",
    options: [
      "Les crimes commis par les mineurs de 16 à 18 ans",
      "Les contraventions commises par les mineurs de moins de 13 ans",
      "Les délits douaniers commis par des majeurs",
    ],
    answer: "Les crimes commis par les mineurs de 16 à 18 ans",
    explanation:
        "La cour d’assises des mineurs juge notamment les crimes commis par les mineurs de 16 à 18 ans et certaines infractions connexes.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Mineurs — Appel",
    question:
        "L’appel des jugements rendus à l’égard des mineurs est porté devant :",
    options: [
      "La chambre criminelle de la Cour de cassation",
      "La chambre spéciale des mineurs de la cour d’appel",
      "La cour d’assises de Paris",
    ],
    answer: "La chambre spéciale des mineurs de la cour d’appel",
    explanation:
        "Les décisions du tribunal pour enfants ou du juge des enfants sont portées devant la chambre spéciale des mineurs de la cour d’appel.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // TERRORISME
  // ==========================================================
  QuizQuestion(
    category: "Terrorisme — Juridictions spécialisées",
    question:
        "Pour les infractions terroristes, quelles juridictions sont souvent compétentes ?",
    options: [
      "Les juridictions de droit commun du lieu des faits",
      "Les juridictions parisiennes spécialisées (pôle antiterroriste et cour d’assises spéciale)",
      "Les juridictions militaires",
    ],
    answer:
        "Les juridictions parisiennes spécialisées (pôle antiterroriste et cour d’assises spéciale)",
    explanation:
        "En matière de terrorisme, la compétence est souvent centralisée à Paris, avec un pôle spécialisé et une cour d’assises spéciale.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Terrorisme — Cour d’assises spéciale",
    question:
        "Quelle particularité présente la cour d’assises spéciale en matière de terrorisme ?",
    options: [
      "Elle juge sans avocat",
      "Elle statue sans jurés populaires, uniquement avec des magistrats professionnels",
      "Elle ne juge que des mineurs",
    ],
    answer:
        "Elle statue sans jurés populaires, uniquement avec des magistrats professionnels",
    explanation:
        "La cour d’assises spéciale en matière de terrorisme est composée uniquement de magistrats professionnels.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // ECONOMIQUE & FINANCIER
  // ==========================================================
  QuizQuestion(
    category: "Économique et financière",
    question:
        "Dans les affaires économiques et financières complexes, la compétence territoriale d’un tribunal judiciaire peut :",
    options: [
      "Être limitée au seul arrondissement",
      "Être étendue au ressort de plusieurs cours d’appel",
      "Être exercée uniquement par le tribunal administratif",
    ],
    answer: "Être étendue au ressort de plusieurs cours d’appel",
    explanation:
        "L’article 704 du CPP permet d’étendre la compétence territoriale en matière économique et financière complexe.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Économique et financière",
    question:
        "Le procureur de la République financier exerce ses attributions :",
    options: [
      "Auprès de chaque tribunal correctionnel",
      "Près du tribunal judiciaire de Paris, avec compétence nationale",
      "Uniquement près de la Cour de cassation",
    ],
    answer: "Près du tribunal judiciaire de Paris, avec compétence nationale",
    explanation:
        "Le procureur de la République financier est rattaché au TJ de Paris mais dispose d’une compétence nationale pour certaines infractions.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Économique et financière",
    question:
        "Les infractions boursières visées (manipulation de marché, etc.) sont principalement prévues dans :",
    options: [
      "Le Code civil",
      "Le Code monétaire et financier",
      "Le Code de l’environnement",
    ],
    answer: "Le Code monétaire et financier",
    explanation:
        "Les articles L.465-1 à L.465-3-3 du Code monétaire et financier répriment certaines infractions boursières.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // CRIMINALITE ORGANISEE & JIRS
  // ==========================================================
  QuizQuestion(
    category: "Criminalité organisée — Généralités",
    question: "L’article 706-73 du CPP énumère principalement :",
    options: [
      "Les juridictions d’exception",
      "Les infractions de criminalité organisée",
      "Les règles du pourvoi en cassation",
    ],
    answer: "Les infractions de criminalité organisée",
    explanation:
        "Cet article liste de nombreuses infractions (terrorisme, trafic de stupéfiants, traite, etc.) relevant de la criminalité organisée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Criminalité organisée — Compétence",
    question:
        "En matière de criminalité organisée, la compétence territoriale peut :",
    options: [
      "Être étendue à plusieurs cours d’appel",
      "Être limitée au canton",
      "Relever uniquement du juge de proximité",
    ],
    answer: "Être étendue à plusieurs cours d’appel",
    explanation:
        "L’article 706-75 du CPP prévoit l’extension de compétence territoriale pour certaines affaires complexes.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Criminalité organisée — JIRS",
    question:
        "Combien de juridictions interrégionales spécialisées (JIRS) sont prévues par le CPP ?",
    options: ["4", "6", "8"],
    answer: "8",
    explanation:
        "L’article D.47-3 du CPP prévoit 8 JIRS : Paris, Lyon, Marseille, Lille, Rennes, Bordeaux, Nancy et Fort-de-France.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // CRIMES CONTRE L’HUMANITÉ / GUERRE
  // ==========================================================
  QuizQuestion(
    category: "Crimes contre l’humanité / Guerre",
    question:
        "Les crimes contre l’humanité et les crimes et délits de guerre peuvent être jugés :",
    options: [
      "Uniquement par un tribunal militaire",
      "Par les tribunaux de droit commun ou par des juridictions parisiennes spécialisées",
      "Uniquement par la Cour pénale internationale",
    ],
    answer:
        "Par les tribunaux de droit commun ou par des juridictions parisiennes spécialisées",
    explanation: "L’article 628-1 du CPP prévoit cette compétence partagée.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // CRIMES SERIELS / NON ELUCIDES
  // ==========================================================
  QuizQuestion(
    category: "Crimes sériels ou non élucidés",
    question:
        "Quel tribunal est désigné comme pôle judiciaire national spécialisé pour les crimes sériels ou non élucidés ?",
    options: [
      "Le tribunal judiciaire de Paris",
      "Le tribunal judiciaire de Nanterre",
      "Le tribunal judiciaire de Marseille",
    ],
    answer: "Le tribunal judiciaire de Nanterre",
    explanation:
        "L’article 706-106-1 du CPP désigne le TJ de Nanterre comme pôle national spécialisé.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Crimes sériels ou non élucidés",
    question:
        "Le pôle spécialisé crimes sériels de Nanterre est compétent notamment lorsque :",
    options: [
      "Les infractions sont très médiatisées",
      "Les investigations présentent une particulière complexité",
      "La peine encourue excède 2 ans d’emprisonnement",
    ],
    answer: "Les investigations présentent une particulière complexité",
    explanation:
        "La compétence est liée à la complexité des investigations, au caractère sériel des crimes ou à leur non-élucidation prolongée.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // TRIBUNAUX MILITAIRES
  // ==========================================================
  QuizQuestion(
    category: "Tribunaux militaires",
    question:
        "Les infractions militaires et les crimes et délits de droit commun commis par les militaires dans l’exercice du service relèvent :",
    options: [
      "Des juridictions civiles de droit commun",
      "Des juridictions spécialisées en matière militaire",
      "Unicamente de la Cour de cassation",
    ],
    answer: "Des juridictions spécialisées en matière militaire",
    explanation:
        "Selon l’article 697 du CPP et le Code de justice militaire, les infractions commises dans l’exercice du service relèvent de juridictions spécialisées.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Tribunaux militaires",
    question:
        "Les infractions commises par un militaire en dehors de l’exercice du service relèvent :",
    options: [
      "Des juridictions militaires",
      "Des juridictions de droit commun",
      "Uniquement de la cour d’assises",
    ],
    answer: "Des juridictions de droit commun",
    explanation:
        "L’article L.2 du Code de justice militaire prévoit que ces infractions relèvent du droit commun.",
    difficulty: "Facile",
  ),

  // ==========================================================
  // LITTORAL MARITIME
  // ==========================================================
  QuizQuestion(
    category: "Littoral maritime",
    question:
        "Les juridictions du littoral maritime spécialisées sont compétentes notamment pour :",
    options: [
      "Les infractions routières",
      "La pollution des eaux maritimes par rejets de navires",
      "Les infractions forestières",
    ],
    answer: "La pollution des eaux maritimes par rejets de navires",
    explanation:
        "Les articles 706-107 à 706-111-2 du CPP prévoient leur compétence pour la pollution maritime et certaines atteintes aux biens culturels maritimes.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // SANITAIRE & ENVIRONNEMENTALE
  // ==========================================================
  QuizQuestion(
    category: "Sanitaire et environnementale",
    question: "Les articles 706-2 à 706-2-3 du CPP concernent :",
    options: [
      "Le pourvoi en cassation",
      "Les procédures en matière sanitaire et environnementale",
      "Les infractions terroristes",
    ],
    answer: "Les procédures en matière sanitaire et environnementale",
    explanation:
        "Ces articles prévoient une procédure particulière pour certaines infractions sanitaires et environnementales.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Sanitaire et environnementale",
    question:
        "Les pôles spécialisés en matière sanitaire et environnementale sont actuellement situés à :",
    options: ["Lyon et Bordeaux", "Paris et Marseille", "Lille et Rennes"],
    answer: "Paris et Marseille",
    explanation:
        "L’article D.47-5 du CPP désigne les tribunaux judiciaires de Paris et Marseille comme pôles spécialisés.",
    difficulty: "Facile",
  ),

  // ==========================================================
  // VOIES DE RECOURS — GENERALITES
  // ==========================================================
  QuizQuestion(
    category: "Voies de recours — Généralités",
    question: "Une décision pénale acquiert autorité de chose jugée lorsque :",
    options: [
      "Elle a été signée par le greffier",
      "Elle n’est plus susceptible de voie de recours",
      "Le prévenu a payé son amende",
    ],
    answer: "Elle n’est plus susceptible de voie de recours",
    explanation:
        "L’autorité de chose jugée suppose l’épuisement ou l’expiration des voies de recours.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Voies de recours — Généralités",
    question: "Les voies de recours ordinaires comprennent principalement :",
    options: [
      "L’opposition et l’appel",
      "Le pourvoi en cassation et la révision",
      "La QPC et la grâce présidentielle",
    ],
    answer: "L’opposition et l’appel",
    explanation:
        "Les voies de recours ordinaires sont ouvertes pour tout motif de fond ou de forme : opposition et appel.",
    difficulty: "Facile",
  ),

  // ==========================================================
  // OPPOSITION
  // ==========================================================
  QuizQuestion(
    category: "Opposition",
    question: "L’opposition est recevable lorsque :",
    options: [
      "Le jugement a été rendu en présence du prévenu",
      "Le jugement a été rendu par défaut",
      "La décision émane de la Cour de cassation",
    ],
    answer: "Le jugement a été rendu par défaut",
    explanation:
        "L’opposition permet de faire rejuger une affaire lorsque la décision a été rendue par défaut.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Opposition",
    question: "En principe, le délai pour former opposition est de :",
    options: ["3 jours", "10 jours", "1 mois pour tous"],
    answer: "10 jours",
    explanation:
        "Le délai est en principe de 10 jours à compter de la signification du jugement si le prévenu réside en métropole.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Opposition",
    question:
        "Quel est l’effet principal de l’opposition sur la décision rendue par défaut ?",
    options: [
      "Elle confirme définitivement la décision",
      "Elle anéantit la décision rendue par défaut",
      "Elle suspend uniquement l’exécution de la peine",
    ],
    answer: "Elle anéantit la décision rendue par défaut",
    explanation:
        "L’opposition a un effet extinctif : la décision rendue par défaut est anéantie et l’affaire est rejugée.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Opposition",
    question:
        "En cas d’« itératif défaut » (nouveau défaut du prévenu lors de l’audience d’opposition), l’opposition :",
    options: [
      "Est maintenue",
      "Est considérée comme non avenue",
      "Est automatiquement transformée en appel",
    ],
    answer: "Est considérée comme non avenue",
    explanation:
        "En cas de nouvel défaut, l’opposition est déclarée non avenue et la décision initiale reprend tous ses effets.",
    difficulty: "Intermédiaire",
  ),

  // ==========================================================
  // APPEL
  // ==========================================================
  QuizQuestion(
    category: "Appel — Généralités",
    question: "L’appel permet :",
    options: [
      "De faire réexaminer l’affaire par une juridiction supérieure",
      "De saisir directement la Cour européenne des droits de l’homme",
      "D’annuler automatiquement la décision contestée",
    ],
    answer: "De faire réexaminer l’affaire par une juridiction supérieure",
    explanation:
        "L’appel a un effet dévolutif : la juridiction d’appel réexamine l’affaire dans les limites fixées par l’appel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Appel — Décisions susceptibles",
    question: "En matière correctionnelle, les jugements sont en principe :",
    options: [
      "Insusceptibles d’appel",
      "Toujours susceptibles d’appel, sauf exceptions prévues par la loi",
      "Uniquement susceptibles de pourvoi en cassation",
    ],
    answer: "Toujours susceptibles d’appel, sauf exceptions prévues par la loi",
    explanation:
        "Les jugements correctionnels peuvent faire l’objet d’un appel, sous réserve de certaines limitations prévues par le CPP.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Appel — Personnes ayant qualité",
    question: "En matière correctionnelle, qui peut interjeter appel ?",
    options: [
      "Uniquement le prévenu",
      "Uniquement le ministère public",
      "Toute partie au procès (prévenu, ministère public, partie civile, civilement responsable, etc.)",
    ],
    answer:
        "Toute partie au procès (prévenu, ministère public, partie civile, civilement responsable, etc.)",
    explanation:
        "Toutes les parties au procès correctionnel disposent, sous conditions, de la faculté d’appel.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Appel — Délai",
    question:
        "Quel est, en principe, le délai pour interjeter appel d’un jugement correctionnel contradictoire ?",
    options: ["24 heures", "3 jours", "10 jours"],
    answer: "10 jours",
    explanation:
        "Le délai d’appel est en principe de 10 jours à compter du prononcé du jugement ou de sa signification, selon les cas.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
    category: "Appel — Effets",
    question: "L’appel a en principe un effet :",
    options: [
      "Uniquement suspensif",
      "Uniquement dévolutif",
      "À la fois suspensif et dévolutif",
    ],
    answer: "À la fois suspensif et dévolutif",
    explanation:
        "L’appel suspend généralement l’exécution de la décision (sauf exceptions) et dévolue l’affaire à la juridiction supérieure.",
    difficulty: "Intermédiaire",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizJuridictionsPage extends StatefulWidget {
  static const String routeName =
      '/gpx/procedure_penale/quiz/juridictions_penales';
  final String uid;
  final String email;

  const QuizJuridictionsPage({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizJuridictionsPage> createState() => _QuizJuridictionsPageState();
}

class _QuizJuridictionsPageState extends State<QuizJuridictionsPage>
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
        ? questionsJuridictionsPenales
        : questionsJuridictionsPenales
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
            'quiz_name': 'Juridictions pénales',
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
      await _sb.from('quiz_juridictions_penales').insert({
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
      debugPrint('❌ quiz_juridictions_penales insert failed: $e');
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
