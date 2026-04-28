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
final List<QuizQuestion> questionsInstructionPreparatoire = [
  // ========== GÉNÉRALITÉS – INSTRUCTION PRÉPARATOIRE ==========
  QuizQuestion(
    category: "Généralités — Instruction préparatoire",
    question:
        "Quel est l’objectif principal de l’instruction préparatoire (information judiciaire) ?",
    options: [
      "Déterminer immédiatement la peine à prononcer",
      "Rechercher des preuves et établir des charges suffisantes pour une mise en jugement",
      "Remplacer l’enquête de police",
      "Protéger uniquement la victime",
    ],
    answer:
        "Rechercher des preuves et établir des charges suffisantes pour une mise en jugement",
    explanation:
        "L’instruction préparatoire permet au juge d’instruction ou à la chambre de l’instruction de rassembler les preuves et d’établir des charges suffisantes en vue d’un éventuel renvoi devant une juridiction de jugement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Notions générales — Actions",
    question:
        "Dans quel cas une infraction fait-elle naître à la fois une action publique et une action civile ?",
    options: [
      "Uniquement lorsqu’il s’agit d’une contravention",
      "Lorsqu’elle cause un dommage à une personne déterminée",
      "Seulement lorsqu’elle est commise sans témoin",
    ],
    answer: "Lorsqu’elle cause un dommage à une personne déterminée",
    explanation:
        "Quand l’infraction cause un préjudice à une victime identifiée, elle donne naissance à l’action publique (peine) et à l’action civile (réparation du dommage).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Notions générales — Actions",
    question:
        "Quelle action est exercée pour obtenir la peine prévue par la loi à l’encontre de l’auteur d’une infraction ?",
    options: [
      "L’action civile",
      "L’action publique",
      "L’action administrative",
    ],
    answer: "L’action publique",
    explanation:
        "L’action publique vise à faire prononcer une peine afin de réparer le trouble causé à l’ordre social.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Principes fondamentaux",
    question:
        "Quel principe garantit le droit à un procès équitable dans la procédure pénale ?",
    options: [
      "Principe de légalité",
      "Principe du contradictoire",
      "Principe de l’opportunité des poursuites",
    ],
    answer: "Principe du contradictoire",
    explanation:
        "Il garantit que chaque partie peut s’exprimer et être entendue dans une procédure équitable.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes fondamentaux",
    question:
        "La présomption d’innocence implique que la charge de la preuve incombe à qui ?",
    options: ["Au prévenu", "Au ministère public", "À la victime"],
    answer: "Au ministère public",
    explanation:
        "C’est à l’accusation d’apporter la preuve de la culpabilité, la personne étant présumée innocente.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Action publique",
    question:
        "Qui représente la société et exerce l’action publique en procédure pénale ?",
    options: [
      "La partie civile",
      "Le ministère public (parquet)",
      "Le juge d’instruction",
    ],
    answer: "Le ministère public (parquet)",
    explanation:
        "Le parquet agit au nom de la société pour faire respecter la loi pénale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Action civile",
    question: "Qui peut exercer l’action civile née d’une infraction ?",
    options: [
      "Le ministère public",
      "La victime ou ses ayants droit",
      "Le juge d’instruction",
    ],
    answer: "La victime ou ses ayants droit",
    explanation:
        "L’action civile vise à réparer le dommage subi par la victime suite à une infraction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Différences action publique / civile",
    question:
        "Quelle est la différence essentielle entre l’action publique et l’action civile ?",
    options: [
      "L’action publique vise la peine, l’action civile la réparation du dommage",
      "Toutes les deux visent uniquement une sanction pénale",
      "L’action civile est exercée par l’État uniquement",
    ],
    answer:
        "L’action publique vise la peine, l’action civile la réparation du dommage",
    explanation:
        "L’une concerne l’ordre social, l’autre le préjudice individuel subi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Sujets actifs",
    question:
        "Quel est le principal organe responsable de la mise en mouvement de l’action publique ?",
    options: ["Le ministère public", "La partie civile", "Le juge de paix"],
    answer: "Le ministère public",
    explanation:
        "Le parquet détient le pouvoir d’intenter des poursuites au nom de la société.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Sujets passifs",
    question:
        "L’action publique peut-elle être dirigée contre les héritiers du délinquant ?",
    options: [
      "Oui, toujours",
      "Non, sauf exceptions légales",
      "Oui, mais uniquement pour la responsabilité civile",
    ],
    answer: "Non, sauf exceptions légales",
    explanation:
        "Le principe de personnalité des peines exclut la poursuite des héritiers, sauf situations spécifiques.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Réquisitoire",
    question: "Que permet le réquisitoire introductif ?",
    options: [
      "Mettre en mouvement l’action publique contre un auteur connu ou inconnu",
      "Mettre fin à l’action publique",
      "Fermeture du dossier sans suite",
    ],
    answer:
        "Mettre en mouvement l’action publique contre un auteur connu ou inconnu",
    explanation:
        "Il s’agit du document par lequel le parquet saisit la juridiction contre un prévenu.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Plaintes",
    question:
        "Quelle est la différence entre une plainte simple et une plainte avec constitution de partie civile ?",
    options: [
      "La plainte simple déclenche l’action publique automatiquement",
      "La plainte avec constitution de partie civile engage l’action publique même si le parquet s’y oppose",
      "Aucune différence juridique",
    ],
    answer:
        "La plainte avec constitution de partie civile engage l’action publique même si le parquet s’y oppose",
    explanation:
        "Cette plainte permet à la victime de forcer les poursuites judiciaires.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Classement sans suite",
    question: "Le classement sans suite signifie-t-il un déni de justice ?",
    options: [
      "Oui, toujours",
      "Non, c’est une décision provisoire légale du procureur",
      "Oui, sauf lorsqu’il s’agit d’infractions mineures",
    ],
    answer: "Non, c’est une décision provisoire légale du procureur",
    explanation:
        "Le classement est possible en l’absence de charges suffisantes ou pour raisons d’opportunité.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Opportunité des poursuites",
    question: "L’article 40-1 du CPP consacre quel principe ?",
    options: [
      "Opportunité des poursuites",
      "Obligation de poursuivre",
      "Secret de l’instruction",
    ],
    answer: "Opportunité des poursuites",
    explanation:
        "Le parquet décide librement de poursuivre ou non, sauf exceptions légales.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Droits de la défense",
    question:
        "Quel droit fondamental permet à une personne suspectée d’être assistée par un avocat ?",
    options: ["Droit à l’égalité", "Droit à la défense", "Droit au silence"],
    answer: "Droit à la défense",
    explanation:
        "Ce droit garantit à tout suspect la possibilité de préparer sa défense.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Prescription",
    question: "Que produit la prescription de l’action publique ?",
    options: [
      "Elle suspend temporairement l’action publique",
      "Elle éteint définitivement l’action publique",
      "Elle réduit la peine encourue",
    ],
    answer: "Elle éteint définitivement l’action publique",
    explanation:
        "Au-delà d’un certain délai sans poursuite, l’action s’éteint juridiquement.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Amnistie",
    question: "Quelle est la portée d’une loi d’amnistie sur les infractions ?",
    options: [
      "Elle aggravent la peine",
      "Elle efface la punissabilité des faits visés rétroactivement",
      "Elle n’a aucun effet juridique",
    ],
    answer: "Elle efface la punissabilité des faits visés rétroactivement",
    explanation:
        "L’amnistie empêche toute poursuite ou sanction pour les faits amnistiés.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Transaction pénale",
    question: "Qu’est-ce qu’une transaction pénale ?",
    options: [
      "Une procédure civile accessoire",
      "Un accord entre ministère public et auteur pour éteindre l’action publique contre sanction",
      "Un recours automatique contre la décision du parquet",
    ],
    answer:
        "Un accord entre ministère public et auteur pour éteindre l’action publique contre sanction",
    explanation:
        "La transaction est une alternative aux poursuites permettant d’éviter un procès.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Alternative aux poursuites",
    question:
        "Quelles sont certaines mesures alternatives aux poursuites possibles ?",
    options: [
      "Médiation pénale, avertissement pénal, composition pénale",
      "Exclusion du procès, amnistie automatique",
      "Condamnation inévitable",
    ],
    answer: "Médiation pénale, avertissement pénal, composition pénale",
    explanation:
        "Ces mesures permettent de régler certains cas sans passer par une juridiction.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Mise en mouvement de l’action",
    question:
        "Quelles autorités peuvent mettre en mouvement l’action publique en cas d’infraction ?",
    options: [
      "Ministère public, particuliers (via plainte avec constitution), juridiction d’office",
      "Uniquement le juge",
      "La police uniquement",
    ],
    answer:
        "Ministère public, particuliers (via plainte avec constitution), juridiction d’office",
    explanation:
        "Plusieurs acteurs disposent du pouvoir de déclencher les poursuites selon les cas.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Personne morale",
    question:
        "Qui peut être poursuivi lorsque l’infraction est commise par une personne morale ?",
    options: [
      "Le représentant légal ou délégué de la personne morale",
      "Seulement la personne morale elle-même",
      "La victime",
    ],
    answer: "Le représentant légal ou délégué de la personne morale",
    explanation:
        "Les représentants agissent pour la personne morale mais peuvent aussi être poursuivis individuellement.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Notions générales — Actions",
    question:
        "Quel est l’objectif principal de l’action civile née d’une infraction pénale ?",
    options: [
      "Punir l’auteur de l’infraction par une peine",
      "Réparer le dommage matériel, corporel ou moral subi par la victime",
      "Assurer la publicité de la décision pénale",
    ],
    answer:
        "Réparer le dommage matériel, corporel ou moral subi par la victime",
    explanation:
        "L’action civile tend à obtenir des dommages et intérêts ou une autre forme de réparation du préjudice individuel subi par la victime.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Notions générales — Actions",
    question:
        "Peut-il exister une action civile sans qu’aucune infraction pénale n’ait été commise ?",
    options: [
      "Oui, sur le fondement de la responsabilité civile (articles 1240 et suivants du code civil)",
      "Non, l’action civile suppose toujours une infraction pénale",
      "Oui, mais seulement devant les juridictions répressives",
    ],
    answer:
        "Oui, sur le fondement de la responsabilité civile (articles 1240 et suivants du code civil)",
    explanation:
        "Une action civile autonome peut être exercée devant le juge civil pour obtenir réparation d’un dommage, même en l’absence d’infraction pénale.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Comparaison — Fondement",
    question:
        "Quel est le fondement de l’action publique lorsqu’une infraction est commise ?",
    options: [
      "Le dommage subi par la victime",
      "La faute civile commise par l’auteur",
      "L’infraction elle-même, en tant qu’atteinte à l’ordre social",
    ],
    answer: "L’infraction elle-même, en tant qu’atteinte à l’ordre social",
    explanation:
        "L’action publique trouve sa source dans l’infraction, qui trouble l’ordre social et justifie l’intervention de la société par le ministère public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Comparaison — Fondement",
    question:
        "Sur quel élément l’action civile née d’une infraction trouve-t-elle principalement son fondement ?",
    options: [
      "Sur l’infraction en tant que telle",
      "Sur le dommage causé à la victime",
      "Sur la gravité de la peine encourue",
    ],
    answer: "Sur le dommage causé à la victime",
    explanation:
        "L’action civile suppose l’existence d’un préjudice, qui constitue son fondement et justifie la demande de réparation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Comparaison — But",
    question: "Quel est le but principal de l’action publique ?",
    options: [
      "Protéger uniquement les intérêts patrimoniaux de la victime",
      "Réparer le trouble social par l’application d’une peine",
      "Constater l’infraction sans sanctionner l’auteur",
    ],
    answer: "Réparer le trouble social par l’application d’une peine",
    explanation:
        "L’action publique tend à la condamnation pénale de l’auteur pour rétablir l’ordre social troublé par l’infraction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Comparaison — But",
    question:
        "Quel est le but principal de l’action civile exercée devant une juridiction répressive ?",
    options: [
      "Obtenir l’abandon des poursuites pénales",
      "Obtenir la réparation intégrale du préjudice individuel",
      "Faire annuler la qualification pénale retenue",
    ],
    answer: "Obtenir la réparation intégrale du préjudice individuel",
    explanation:
        "La partie civile agit pour obtenir une compensation de son dommage, indépendamment de la peine prononcée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Comparaison — Exercice",
    question: "Par qui l’action publique est-elle en principe exercée ?",
    options: [
      "Par la victime ou ses héritiers",
      "Par les magistrats du ministère public",
      "Par le juge d’instruction uniquement",
    ],
    answer: "Par les magistrats du ministère public",
    explanation:
        "L’action publique appartient à la société qui l’exerce par l’intermédiaire des magistrats du parquet.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Comparaison — Exercice",
    question: "À qui appartient l’action civile née d’une infraction pénale ?",
    options: [
      "Uniquement au procureur de la République",
      "À la victime, à ses ayants droit ou à certaines personnes morales habilitées",
      "Au juge répressif agissant d’office",
    ],
    answer:
        "À la victime, à ses ayants droit ou à certaines personnes morales habilitées",
    explanation:
        "L’action civile est d’ordre privé et appartient en principe à la personne lésée ou à ceux qui tiennent leurs droits d’elle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Comparaison — Caractère",
    question: "Pourquoi dit-on que l’action publique est d’ordre public ?",
    options: [
      "Parce que la victime peut la retirer librement",
      "Parce que le ministère public ne peut en principe ni y renoncer ni transiger",
      "Parce qu’elle ne concerne que les infractions contraventionnelles",
    ],
    answer:
        "Parce que le ministère public ne peut en principe ni y renoncer ni transiger",
    explanation:
        "L’action publique relève de l’intérêt général, de sorte que le parquet ne dispose pas librement de la poursuite, sauf exceptions prévues par la loi.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Comparaison — Caractère",
    question:
        "Pourquoi l’action civile est-elle qualifiée d’action d’ordre privé ?",
    options: [
      "Parce qu’elle ne peut jamais être exercée devant le juge pénal",
      "Parce qu’elle appartient à la victime qui peut y renoncer ou transiger",
      "Parce qu’elle est toujours exercée par le parquet",
    ],
    answer:
        "Parce qu’elle appartient à la victime qui peut y renoncer ou transiger",
    explanation:
        "La partie lésée dispose de son action civile et peut décider de transiger ou de se désister, sauf cas particuliers.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Rapprochement — Actions",
    question:
        "Quel est le lien commun à l’origine de l’action publique et de l’action civile lorsqu’elles coexistent ?",
    options: [
      "La plainte préalable de la victime",
      "L’infraction commise",
      "La décision du juge d’instruction",
    ],
    answer: "L’infraction commise",
    explanation:
        "Les deux actions naissent d’un même fait, l’infraction, qui à la fois trouble l’ordre social et cause un dommage individuel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Rapprochement — Juridiction",
    question:
        "Que se passe-t-il lorsque la victime exerce son action civile devant la juridiction répressive ?",
    options: [
      "Elle déclenche l’action publique si celle-ci n’a pas encore été mise en mouvement",
      "Elle bloque définitivement toute poursuite pénale",
      "Elle ne peut obtenir que des excuses publiques",
    ],
    answer:
        "Elle déclenche l’action publique si celle-ci n’a pas encore été mise en mouvement",
    explanation:
        "La plainte avec constitution de partie civile devant le juge d’instruction met automatiquement en mouvement l’action publique.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Rapprochement — Autorité du pénal",
    question: "Que signifie l’adage « le criminel tient le civil en état » ?",
    options: [
      "Que le juge pénal doit attendre la décision du juge civil",
      "Que le juge civil doit surseoir à statuer tant que le pénal n’a pas tranché les faits",
      "Qu’aucune action civile n’est possible après une condamnation pénale",
    ],
    answer:
        "Que le juge civil doit surseoir à statuer tant que le pénal n’a pas tranché les faits",
    explanation:
        "L’autorité de la chose jugée au pénal s’impose au juge civil, qui ne peut contredire la décision pénale sur l’existence des faits et leur qualification.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Sujets actifs — Ministère public",
    question:
        "Quel organe exerce normalement l’action publique au nom de la société ?",
    options: [
      "Les juridictions administratives",
      "Les magistrats du ministère public (parquet)",
      "Les services de police",
    ],
    answer: "Les magistrats du ministère public (parquet)",
    explanation:
        "Le parquet représente la société devant les juridictions pénales et met en mouvement l’action publique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Sujets actifs — Ministère public",
    question:
        "Pourquoi dit-on que le ministère public n’a pas la “disposition” de l’action publique ?",
    options: [
      "Parce qu’il ne peut jamais engager de poursuites",
      "Parce qu’il ne peut ni transiger librement ni renoncer purement et simplement à la poursuite",
      "Parce qu’il n’a pas le droit de faire appel des décisions",
    ],
    answer:
        "Parce qu’il ne peut ni transiger librement ni renoncer purement et simplement à la poursuite",
    explanation:
        "L’action publique ne lui appartient pas comme un droit privé, elle est l’expression de l’intérêt général et reste encadrée par la loi.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Sujets actifs — Administrations",
    question:
        "Dans quelles hypothèses certaines administrations peuvent-elles exercer l’action publique ?",
    options: [
      "Lorsque la loi leur reconnaît un droit direct de poursuite pour les infractions portant atteinte aux intérêts qu’elles protègent",
      "Chaque fois qu’un procès-verbal est dressé",
      "Uniquement lorsqu’il s’agit de crimes",
    ],
    answer:
        "Lorsque la loi leur reconnaît un droit direct de poursuite pour les infractions portant atteinte aux intérêts qu’elles protègent",
    explanation:
        "Certaines administrations (forêts, équipement, douanes, fisc, etc.) disposent d’un pouvoir de poursuite pour les infractions relevant de leur domaine.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Sujets actifs — Administrations",
    question:
        "Quelle particularité distingue les administrations comme les douanes ou les contributions indirectes du ministère public en matière de poursuites ?",
    options: [
      "Elles ne peuvent jamais transiger",
      "Elles peuvent transiger avec l’auteur, la transaction éteignant l’action fiscale dans certains cas",
      "Elles peuvent prononcer des peines d’emprisonnement",
    ],
    answer:
        "Elles peuvent transiger avec l’auteur, la transaction éteignant l’action fiscale dans certains cas",
    explanation:
        "Ces administrations peuvent conclure une transaction qui éteint l’action relative aux sanctions qu’elles gèrent, ce qui n’est pas le cas général pour le parquet.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Sujets actifs — Particuliers",
    question: "La victime peut-elle exercer elle-même l’action publique ?",
    options: [
      "Oui, elle peut se substituer au parquet à tout moment",
      "Non, mais elle peut la mettre en mouvement dans certains cas",
      "Non, elle ne joue aucun rôle dans les poursuites",
    ],
    answer: "Non, mais elle peut la mettre en mouvement dans certains cas",
    explanation:
        "La partie lésée ne dispose pas de l’action publique, mais sa plainte avec constitution de partie civile peut déclencher la poursuite.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Sujets passifs — Personnalité des peines",
    question: "Contre qui l’action publique est-elle, en principe, dirigée ?",
    options: [
      "Contre l’auteur ou le complice de l’infraction",
      "Contre les héritiers du délinquant",
      "Contre toute personne ayant un lien familial avec l’auteur",
    ],
    answer: "Contre l’auteur ou le complice de l’infraction",
    explanation:
        "En vertu du principe de personnalité des peines, seule la personne pénalement responsable (auteur ou complice) peut être poursuivie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Sujets passifs — Décès",
    question:
        "Quelle est la conséquence du décès de l’auteur des faits sur l’action publique ?",
    options: [
      "L’action publique est éteinte",
      "L’action publique se poursuit contre les héritiers",
      "L’action publique est suspendue puis reprend",
    ],
    answer: "L’action publique est éteinte",
    explanation:
        "La mort du prévenu éteint l’action publique, car la peine ne peut plus être prononcée à l’encontre de la personne décédée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Sujets passifs — Personnes morales",
    question:
        "Lorsque l’infraction est commise par une personne morale, contre qui l’action publique est-elle exercée ?",
    options: [
      "Uniquement contre la personne morale",
      "Contre le représentant légal ou un délégué, au nom de la personne morale",
      "Contre les salariés de l’entreprise uniquement",
    ],
    answer:
        "Contre le représentant légal ou un délégué, au nom de la personne morale",
    explanation:
        "Le représentant légal agit pour la personne morale dans la procédure, tout en n’excluant pas sa propre responsabilité éventuelle.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Exercice — Information du parquet",
    question:
        "Selon le code de procédure pénale, qui doit informer sans délai le procureur de la République des crimes et délits dont il a connaissance dans l’exercice de ses fonctions ?",
    options: [
      "Tout citoyen",
      "Toute autorité constituée, tout officier public ou fonctionnaire",
      "Uniquement les officiers de police judiciaire",
    ],
    answer: "Toute autorité constituée, tout officier public ou fonctionnaire",
    explanation:
        "La loi impose à ces autorités un devoir d’alerte envers le parquet lorsqu’elles découvrent des infractions dans l’exercice de leurs fonctions.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Exercice — Légalité et opportunité",
    question:
        "Avant d’exercer l’action publique, que doit vérifier le procureur de la République ?",
    options: [
      "Uniquement l’identité de la victime",
      "La légalité de la poursuite (existence de l’infraction, imputabilité, compétence) et l’opportunité de poursuivre",
      "Seulement la gravité médiatique de l’affaire",
    ],
    answer:
        "La légalité de la poursuite (existence de l’infraction, imputabilité, compétence) et l’opportunité de poursuivre",
    explanation:
        "Le parquet doit d’abord s’assurer que la poursuite est juridiquement fondée, puis apprécier s’il est opportun d’engager l’action.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Exercice — Opportunité",
    question: "Que consacre l’article 40-1 du code de procédure pénale ?",
    options: [
      "Le principe de la légalité stricte des peines",
      "Le principe de l’opportunité des poursuites",
      "Le principe de la collégialité des juridictions",
    ],
    answer: "Le principe de l’opportunité des poursuites",
    explanation:
        "Cet article permet au procureur de choisir entre engager des poursuites, recourir à une alternative ou classer sans suite dans certains cas.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Exercice — Classement sans suite",
    question:
        "Dans quel cas le procureur de la République peut-il décider de classer une affaire sans suite ?",
    options: [
      "Uniquement lorsque la victime le demande",
      "Lorsqu’il estime que l’infraction n’est pas constituée, non imputable ou que la poursuite n’est pas opportune",
      "Jamais, car il est obligé de poursuivre toute infraction",
    ],
    answer:
        "Lorsqu’il estime que l’infraction n’est pas constituée, non imputable ou que la poursuite n’est pas opportune",
    explanation:
        "Le classement sans suite est possible pour des raisons juridiques (infraction non caractérisée) ou d’opportunité, dans le cadre de l’article 40-1.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Extinction — Causes générales",
    question:
        "Laquelle de ces situations fait partie des causes générales d’extinction de l’action publique ?",
    options: [
      "Le simple pardon de la victime",
      "L’amnistie décidée par la loi",
      "La mutation du procureur de la République",
    ],
    answer: "L’amnistie décidée par la loi",
    explanation:
        "L’amnistie, comme la prescription, le décès du prévenu ou la chose jugée, fait partie des causes générales d’extinction de l’action publique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Extinction — Amnistie",
    question:
        "Quel est l’effet principal d’une loi d’amnistie sur l’action publique ?",
    options: [
      "Elle suspend temporairement la poursuite",
      "Elle éteint l’action publique pour les faits visés",
      "Elle aggrave la peine encourue",
    ],
    answer: "Elle éteint l’action publique pour les faits visés",
    explanation:
        "L’amnistie fait disparaître rétroactivement le caractère punissable des faits couvrés par la loi d’amnistie.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "TITRE préliminaire — Principes",
    question:
        "Quel principe fondamental est affirmé au début de l’article préliminaire du code de procédure pénale ?",
    options: [
      "La procédure pénale doit être secrète et inquisitoriale",
      "La procédure pénale doit être équitable et contradictoire",
      "La procédure pénale doit toujours être orale",
    ],
    answer: "La procédure pénale doit être équitable et contradictoire",
    explanation:
        "Le texte impose que la procédure respecte l’équité, le contradictoire et l’équilibre des droits des parties.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "TITRE préliminaire — Séparation",
    question:
        "Quelle séparation institutionnelle la procédure pénale doit-elle garantir selon l’article préliminaire ?",
    options: [
      "Entre les juridictions civiles et administratives",
      "Entre les autorités chargées de l’action publique et celles de jugement",
      "Entre la police judiciaire et la gendarmerie",
    ],
    answer:
        "Entre les autorités chargées de l’action publique et celles de jugement",
    explanation:
        "Le texte insiste sur la séparation entre ceux qui poursuivent (parquet) et ceux qui jugent (juridictions).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "TITRE préliminaire — Égalité",
    question:
        "Comment l’égalité devant la justice pénale est-elle formulée dans l’article préliminaire ?",
    options: [
      "Les personnes riches sont jugées par une juridiction spéciale",
      "Les personnes dans des conditions semblables poursuivies pour les mêmes infractions doivent être jugées selon les mêmes règles",
      "Les étrangers sont jugés selon une procédure spécifique",
    ],
    answer:
        "Les personnes dans des conditions semblables poursuivies pour les mêmes infractions doivent être jugées selon les mêmes règles",
    explanation:
        "Le texte impose une égalité de traitement procédural pour des situations et infractions comparables.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "TITRE préliminaire — Victimes",
    question:
        "Quel rôle l’autorité judiciaire doit-elle assurer à l’égard des victimes, selon l’article préliminaire ?",
    options: [
      "Uniquement leur indemnisation automatique",
      "L’information et la garantie de leurs droits au cours de toute procédure pénale",
      "La représentation systématique par un avocat commis d’office",
    ],
    answer:
        "L’information et la garantie de leurs droits au cours de toute procédure pénale",
    explanation:
        "L’article impose à l’autorité judiciaire d’informer les victimes et de veiller à ce que leurs droits soient respectés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "TITRE préliminaire — Présomption d’innocence",
    question:
        "Que prévoit l’article préliminaire au sujet de la personne suspectée ou poursuivie ?",
    options: [
      "Elle est présumée coupable jusqu’à preuve du contraire",
      "Elle est présumée innocente tant que sa culpabilité n’a pas été établie",
      "Elle est tenue de prouver son innocence",
    ],
    answer:
        "Elle est présumée innocente tant que sa culpabilité n’a pas été établie",
    explanation:
        "La présomption d’innocence est un principe fondamental garanti par l’article préliminaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "TITRE préliminaire — Information de la personne",
    question:
        "Quel droit procédural essentiel est reconnu à toute personne suspectée ou poursuivie ?",
    options: [
      "Le droit d’être informée des charges retenues contre elle et d’être assistée d’un défenseur",
      "Le droit d’exiger le choix de son juge",
      "Le droit de refuser toute mesure de contrainte",
    ],
    answer:
        "Le droit d’être informée des charges retenues contre elle et d’être assistée d’un défenseur",
    explanation:
        "L’article préliminaire garantit l’information sur les charges et le droit à l’assistance d’un avocat.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "TITRE préliminaire — Langue",
    question:
        "Que prévoit l’article préliminaire pour une personne qui ne comprend pas le français ?",
    options: [
      "Aucun droit particulier n’est prévu",
      "Elle doit se débrouiller avec un proche comme interprète",
      "Elle a droit à un interprète et à la traduction des pièces essentielles dans une langue qu’elle comprend",
    ],
    answer:
        "Elle a droit à un interprète et à la traduction des pièces essentielles dans une langue qu’elle comprend",
    explanation:
        "Le texte impose l’interprétation et la traduction des pièces indispensables à la défense et à l’équité du procès.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "TITRE préliminaire — Contraintes",
    question:
        "Comment les mesures de contrainte sont-elles encadrées par l’article préliminaire ?",
    options: [
      "Elles peuvent être prises librement par les services d’enquête",
      "Elles sont prises sur décision ou sous le contrôle effectif de l’autorité judiciaire et doivent être nécessaires, proportionnées et respectueuses de la dignité",
      "Elles ne concernent que la garde à vue",
    ],
    answer:
        "Elles sont prises sur décision ou sous le contrôle effectif de l’autorité judiciaire et doivent être nécessaires, proportionnées et respectueuses de la dignité",
    explanation:
        "L’article impose un encadrement strict des contraintes par l’autorité judiciaire, ainsi qu’une exigence de proportionnalité et de respect de la dignité.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "TITRE préliminaire — Délai raisonnable",
    question:
        "Que garantit l’article préliminaire quant au délai de jugement ?",
    options: [
      "Qu’aucun délai n’est exigé en matière criminelle",
      "Qu’il doit être statué définitivement dans un délai raisonnable sur l’accusation",
      "Que le délai maximum est de deux ans pour toutes les infractions",
    ],
    answer:
        "Qu’il doit être statué définitivement dans un délai raisonnable sur l’accusation",
    explanation:
        "L’exigence d’un délai raisonnable assure que la personne ne reste pas indéfiniment sous la menace de poursuites.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "TITRE préliminaire — Vie privée",
    question:
        "Dans quelles conditions les mesures portant atteinte à la vie privée peuvent-elles être prises au cours de la procédure pénale ?",
    options: [
      "Dès lors qu’elles facilitent l’enquête, sans autre condition",
      "Uniquement sur autorisation du ministre de la Justice",
      "Lorsqu’elles sont nécessaires à la manifestation de la vérité, proportionnées à la gravité de l’infraction et placées sous le contrôle de l’autorité judiciaire",
    ],
    answer:
        "Lorsqu’elles sont nécessaires à la manifestation de la vérité, proportionnées à la gravité de l’infraction et placées sous le contrôle de l’autorité judiciaire",
    explanation:
        "L’article préliminaire encadre strictement les atteintes à la vie privée par un triple critère: nécessité, proportionnalité et contrôle judiciaire.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "TITRE préliminaire — Droit au recours",
    question:
        "Quel droit est reconnu à toute personne condamnée par l’article préliminaire ?",
    options: [
      "Le droit de choisir la juridiction qui la jugera",
      "Le droit de faire examiner sa condamnation par une autre juridiction",
      "Le droit automatique à la grâce présidentielle",
    ],
    answer:
        "Le droit de faire examiner sa condamnation par une autre juridiction",
    explanation:
        "Le texte garantit un droit à un recours, généralement exercé par l’appel ou le pourvoi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "TITRE préliminaire — Assistance de l’avocat",
    question:
        "Quelle règle l’article préliminaire pose-t-il concernant les déclarations faites sans assistance d’un avocat ?",
    options: [
      "Elles peuvent suffire à fonder une condamnation en toute hypothèse",
      "Aucune condamnation ne peut être prononcée en matière criminelle et correctionnelle sur le seul fondement de telles déclarations",
      "Elles sont systématiquement nulles",
    ],
    answer:
        "Aucune condamnation ne peut être prononcée en matière criminelle et correctionnelle sur le seul fondement de telles déclarations",
    explanation:
        "Le texte protège la personne contre une condamnation reposant exclusivement sur des aveux ou déclarations sans assistance d’un avocat.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "TITRE préliminaire — Droit de se taire",
    question:
        "Quand le droit de se taire doit-il être notifié à la personne suspectée ou poursuivie ?",
    options: [
      "Uniquement lors de l’audience de jugement",
      "Uniquement en garde à vue",
      "Avant tout recueil de ses observations et tout interrogatoire, dès la première présentation devant un service d’enquête, un magistrat ou une juridiction",
    ],
    answer:
        "Avant tout recueil de ses observations et tout interrogatoire, dès la première présentation devant un service d’enquête, un magistrat ou une juridiction",
    explanation:
        "L’article préliminaire impose que ce droit soit notifié en amont de tout interrogatoire, y compris pour les renseignements sur la personnalité.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "TITRE préliminaire — Secret professionnel",
    question:
        "Quel principe en matière de secret professionnel est rappelé par l’article préliminaire ?",
    options: [
      "Le secret professionnel de la défense et du conseil n’est pas applicable en procédure pénale",
      "Le secret professionnel de la défense et du conseil est garanti dans les conditions prévues par le code de procédure pénale",
      "Le secret ne protège que les communications écrites avec l’avocat",
    ],
    answer:
        "Le secret professionnel de la défense et du conseil est garanti dans les conditions prévues par le code de procédure pénale",
    explanation:
        "Le texte renvoie à la loi sur la profession d’avocat pour affirmer la protection du secret de la défense et du conseil en procédure pénale.",
    difficulty: "Moyen",
  ),

  // ----- Actions : autres aspects, sujets, alternatives, etc. -----
  QuizQuestion(
    category: "Information du parquet",
    question:
        "Quelle est l’obligation faite à tout citoyen par certaines dispositions du code pénal (par exemple pour certains crimes ou sévices sur mineurs) ?",
    options: [
      "Aucune obligation d’information n’est prévue",
      "Informer les autorités administratives ou judiciaires de certains crimes ou sévices dont il a connaissance",
      "Assurer lui-même l’arrestation de l’auteur",
    ],
    answer:
        "Informer les autorités administratives ou judiciaires de certains crimes ou sévices dont il a connaissance",
    explanation:
        "Le code pénal impose, sous peine de sanctions, la dénonciation de certains faits graves pour permettre d’agir rapidement.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Décision du parquet — Choix",
    question:
        "Quels sont les trois grands types de réponses possibles du procureur de la République face à une infraction commise par une personne identifiée ?",
    options: [
      "Non-lieu, renvoi, appel",
      "Poursuites, alternative aux poursuites ou classement sans suite",
      "Garde à vue, détention provisoire, mise en liberté",
    ],
    answer: "Poursuites, alternative aux poursuites ou classement sans suite",
    explanation:
        "L’article 40-1 C.P.P. décrit ce triptyque qui incarne le principe de l’opportunité des poursuites.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Classement sans suite — Caractère",
    question:
        "Le classement sans suite décidé par le procureur de la République a-t-il un caractère définitif ?",
    options: [
      "Oui, il interdit toute reprise de la procédure",
      "Non, il est provisoire tant que la prescription n’est pas acquise",
      "Oui, sauf en cas de plainte de la victime",
    ],
    answer: "Non, il est provisoire tant que la prescription n’est pas acquise",
    explanation:
        "De nouveaux éléments peuvent justifier la réouverture de la procédure avant que le délai de prescription ne soit expiré.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Classement sans suite — Information",
    question:
        "Qui le procureur doit-il informer lorsqu’il décide un classement sans suite ?",
    options: [
      "Uniquement le mis en cause",
      "La victime identifiée, le plaignant et les autorités ou fonctionnaires ayant signalé les faits",
      "Uniquement le ministre de la Justice",
    ],
    answer:
        "La victime identifiée, le plaignant et les autorités ou fonctionnaires ayant signalé les faits",
    explanation:
        "L’article 40-2 C.P.P. impose au parquet de motiver et notifier le classement aux personnes à l’origine du signalement.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Poursuites — Irrévocabilité",
    question:
        "Une fois que le procureur de la République a engagé des poursuites, peut-il revenir sur sa décision ?",
    options: [
      "Oui, il peut renoncer à tout moment à la procédure",
      "Non, seule la juridiction saisie peut mettre fin au procès",
      "Oui, sur autorisation de la victime",
    ],
    answer: "Non, seule la juridiction saisie peut mettre fin au procès",
    explanation:
        "La décision d’engager les poursuites est irrévocable et le parquet ne peut plus éteindre lui-même l’action publique.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Hiérarchie — Ordres du procureur général",
    question:
        "Quelle est la conséquence d’un ordre écrit du procureur général adressé au procureur de la République ?",
    options: [
      "Il doit, en principe, engager les poursuites conformément à cette instruction",
      "Il peut l’ignorer librement",
      "Il doit déporter le dossier vers une autre juridiction",
    ],
    answer:
        "Il doit, en principe, engager les poursuites conformément à cette instruction",
    explanation:
        "La hiérarchie du parquet permet au procureur général d’ordonner par écrit l’engagement des poursuites.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Partie lésée — Plainte simple",
    question:
        "La simple plainte de la victime auprès du procureur de la République oblige-t-elle ce dernier à engager des poursuites ?",
    options: [
      "Oui, il est obligé de poursuivre",
      "Non, il apprécie l’opportunité des poursuites",
      "Oui, mais uniquement pour les crimes",
    ],
    answer: "Non, il apprécie l’opportunité des poursuites",
    explanation:
        "La plainte simple ne fait pas disparaître le pouvoir d’appréciation du parquet sur la suite à donner.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Partie lésée — Plainte avec constitution de partie civile",
    question:
        "Quel est l’effet principal d’une plainte avec constitution de partie civile devant le juge d’instruction ?",
    options: [
      "Elle oblige le procureur à classer sans suite",
      "Elle met automatiquement en mouvement l’action publique",
      "Elle transforme l’action publique en action civile",
    ],
    answer: "Elle met automatiquement en mouvement l’action publique",
    explanation:
        "La constitution de partie civile devant le juge d’instruction déclenche la poursuite même contre l’avis du procureur.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Plaines préalables — Rôle",
    question:
        "Pourquoi la loi exige-t-elle parfois une plainte préalable de la victime pour que l’action publique puisse être engagée ?",
    options: [
      "Pour désengorger les tribunaux de police",
      "Pour protéger des intérêts privés et éviter de déclencher une procédure pénale contre la volonté de la personne directement touchée",
      "Pour permettre au parquet de transiger automatiquement",
    ],
    answer:
        "Pour protéger des intérêts privés et éviter de déclencher une procédure pénale contre la volonté de la personne directement touchée",
    explanation:
        "Dans certaines infractions (injure, diffamation, etc.), la plainte préalable évite un procès pénal non souhaité par la victime.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Plaines préalables — Effet du désistement",
    question:
        "Lorsque la plainte préalable est une condition nécessaire de la poursuite, quel est l’effet de son désistement ?",
    options: [
      "Aucun, la poursuite continue",
      "Il interrompt la poursuite pénale",
      "Il aggrave la responsabilité civile",
    ],
    answer: "Il interrompt la poursuite pénale",
    explanation:
        "Contrairement au principe général, le désistement de la victime met fin aux poursuites lorsque la plainte est une condition de recevabilité.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Immunités — Famille",
    question:
        "Donnez un exemple d’immunité familiale faisant obstacle à l’action du ministère public.",
    options: [
      "Le vol entre époux, sous certaines conditions",
      "La conduite en état d’ivresse par un parent",
      "Le meurtre commis entre frères et sœurs",
    ],
    answer: "Le vol entre époux, sous certaines conditions",
    explanation:
        "Le code pénal prévoit, pour des raisons familiales, des immunités qui empêchent la poursuite dans certains cas précis.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Autorisation préalable — Parlementaires",
    question:
        "Pour quelles mesures l’autorisation préalable du bureau de l’assemblée est-elle requise à l’égard d’un parlementaire ?",
    options: [
      "Pour toute poursuite pénale",
      "Pour les mesures privatives ou restrictives de liberté, sauf en cas de flagrance",
      "Uniquement pour les infractions politiques",
    ],
    answer:
        "Pour les mesures privatives ou restrictives de liberté, sauf en cas de flagrance",
    explanation:
        "Le parlementaire peut être poursuivi, mais certaines mesures de contrainte exigent une autorisation de son assemblée.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Responsabilité pénale — Fait d’autrui",
    question:
        "Dans quel cas peut-on retenir la responsabilité pénale du chef d’entreprise pour une infraction commise par un salarié ?",
    options: [
      "Jamais, le salarié est toujours seul responsable",
      "Lorsque la loi ou la jurisprudence l’admet, notamment en matière de sécurité ou de pollution",
      "Uniquement si le salarié est mineur",
    ],
    answer:
        "Lorsque la loi ou la jurisprudence l’admet, notamment en matière de sécurité ou de pollution",
    explanation:
        "Certaines infractions permettent de retenir la responsabilité pénale du dirigeant en raison de ses obligations de contrôle et de prévention.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Alternative aux poursuites — Avertissement pénal probatoire",
    question:
        "Qu’est-ce qu’un avertissement pénal probatoire dans le cadre des alternatives aux poursuites ?",
    options: [
      "Une simple lettre informelle sans effet juridique",
      "Une mesure par laquelle le procureur rappelle à l’auteur ses obligations et l’avertit qu’une nouvelle infraction entraînera une révision de la décision",
      "Une condamnation pénale avec sursis",
    ],
    answer:
        "Une mesure par laquelle le procureur rappelle à l’auteur ses obligations et l’avertit qu’une nouvelle infraction entraînera une révision de la décision",
    explanation:
        "Cette mesure permet de répondre à l’infraction sans saisine immédiate d’une juridiction, mais avec un effet dissuasif.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Alternative aux poursuites — Conditions",
    question:
        "L’alternative aux poursuites peut-elle être utilisée à l’égard d’un auteur récidiviste déjà condamné ?",
    options: [
      "Oui, sans aucune limite",
      "Non, certaines alternatives comme l’avertissement pénal probatoire sont exclues pour les personnes déjà condamnées",
      "Oui, mais uniquement pour les crimes",
    ],
    answer:
        "Non, certaines alternatives comme l’avertissement pénal probatoire sont exclues pour les personnes déjà condamnées",
    explanation:
        "Le texte limite l’usage de certaines mesures aux auteurs n’ayant pas déjà fait l’objet de condamnations.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Alternative aux poursuites — Médiation pénale",
    question:
        "Quel est l’objectif principal de la médiation pénale dans le cadre des alternatives aux poursuites ?",
    options: [
      "Prononcer une peine d’emprisonnement",
      "Permettre la réparation du préjudice via un accord amiable entre auteur et victime",
      "Classer automatiquement l’affaire sans suite",
    ],
    answer:
        "Permettre la réparation du préjudice via un accord amiable entre auteur et victime",
    explanation:
        "La médiation favorise la réparation amiable du dommage causé, évitant la saisine d’une juridiction.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Alternative aux poursuites — Composition pénale",
    question:
        "Que permet la composition pénale pour l’auteur d’une infraction délictuelle ?",
    options: [
      "D’éviter un procès en acceptant une sanction proposée par le procureur",
      "De faire appel directement au président de la République",
      "De demander un nouveau procès devant une autre juridiction",
    ],
    answer:
        "D’éviter un procès en acceptant une sanction proposée par le procureur",
    explanation:
        "La composition pénale est une procédure qui permet à l’auteur d’accepter une sanction directement, sans passer par le jugement.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Alternative aux poursuites — Composition pénale",
    question:
        "Quels sont les types de sanctions que la composition pénale peut proposer ?",
    options: [
      "Peines privatives de liberté uniquement",
      "Amendes, travail d’intérêt général, confiscations, interdictions diverses",
      "Aucune sanction, uniquement une mise en garde orale",
    ],
    answer:
        "Amendes, travail d’intérêt général, confiscations, interdictions diverses",
    explanation:
        "Les sanctions proposées sont diverses et adaptées à la gravité de l’infraction.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Saisine — Citation directe",
    question: "Qu’est-ce que la citation directe ?",
    options: [
      "Une convocation obligatoire de la victime au procès",
      "Une procédure par laquelle la victime informe directement le tribunal d’une infraction non classée crime",
      "Une mesure de détention provisoire",
    ],
    answer:
        "Une procédure par laquelle la victime informe directement le tribunal d’une infraction non classée crime",
    explanation:
        "La citation directe permet à la victime d’initier une procédure pénale pour certaines infractions sans passer par le parquet.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Saisine — Réquisitoire introductif",
    question:
        "Par qui et comment est généralement mise en mouvement l’action publique ?",
    options: [
      "Par un juge d’instruction au travers d’un mandat",
      "Par le procureur de la République, au moyen d’un réquisitoire introductif",
      "Par la victime elle-même",
    ],
    answer:
        "Par le procureur de la République, au moyen d’un réquisitoire introductif",
    explanation:
        "Le procureur initie officiellement les poursuites avec un réquisitoire signifiant à la juridiction de juger.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Saisine — Plainte avec constitution de partie civile",
    question:
        "Quel est l’effet d’une plainte avec constitution de partie civile sur l’action publique ?",
    options: [
      "Elle suspend l’action publique",
      "Elle met automatiquement en mouvement l’action publique, indépendamment du parquet",
      "Elle transforme l’action publique en action civile",
    ],
    answer:
        "Elle met automatiquement en mouvement l’action publique, indépendamment du parquet",
    explanation:
        "Cette plainte oblige le déclenchement de la poursuite, même contre l’avis du procureur.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Causes d’extinction — Décès",
    question:
        "Que devient l’action publique à la suite du décès de l’auteur des faits ?",
    options: [
      "Elle se poursuit contre ses héritiers",
      "Elle est éteinte",
      "Elle est suspendue pendant un an",
    ],
    answer: "Elle est éteinte",
    explanation:
        "Le décès du prévenu entraîne l’extinction de l’action publique car la peine ne peut plus être prononcée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Causes d’extinction — Amnistie",
    question: "Qu’est-ce que l’amnistie pénale ?",
    options: [
      "Un report de la procédure",
      "Un effacement rétroactif de la punissabilité des faits déterminés par la loi",
      "Une sanction complémentaire",
    ],
    answer:
        "Un effacement rétroactif de la punissabilité des faits déterminés par la loi",
    explanation:
        "L’amnistie fait disparaître définitivement la peine relative aux faits amnistiés.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Causes d’extinction — Prescription",
    question:
        "Quelle est la conséquence de la prescription de l’action publique ?",
    options: [
      "Le procès est automatiquement gagné par la défense",
      "L’action publique ne peut plus être exercée",
      "La victime peut faire appel",
    ],
    answer: "L’action publique ne peut plus être exercée",
    explanation:
        "Lorsque le délai prévu par la loi est dépassé sans poursuite, l’action publique est éteinte.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Extinction — Transaction pénale",
    question:
        "Quel est l’effet d’une transaction pénale acceptée par la victime et homologuée par le procureur ?",
    options: [
      "Elle remplace le jugement par une sanction immédiate",
      "Elle suspend les poursuites temporairement",
      "Elle éteint l’action publique pour les faits concernés",
    ],
    answer: "Elle éteint l’action publique pour les faits concernés",
    explanation:
        "La transaction pénale aboutit à l’extinction de l’action publique par accord entre parties et ministère public.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Réquisitoire — Définition",
    question: "Qu’est-ce qu’un réquisitoire ?",
    options: [
      "Une demande écrite ou orale du parquet en vue de poursuivre un prévenu",
      "Un acte d'accusation rédigé par la victime",
      "Une décision finale du juge",
    ],
    answer:
        "Une demande écrite ou orale du parquet en vue de poursuivre un prévenu",
    explanation:
        "Le réquisitoire formalise la volonté du ministère public de poursuivre devant le tribunal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Juge d’instruction — Pouvoirs",
    question:
        "Quel rôle spécifique le juge d’instruction joue-t-il dans certaines procédures pénales ?",
    options: [
      "Il juge directement les infractions",
      "Il conduit les investigations et ordonne la mise en mouvement de l’action publique",
      "Il assiste uniquement les avocats",
    ],
    answer:
        "Il conduit les investigations et ordonne la mise en mouvement de l’action publique",
    explanation:
        "Le juge d’instruction dirige l’instruction pénale et décide, dans certains cas, de déclencher l’action publique.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Validité de l’action — Exception",
    question: "Dans quel cas la chose jugée peut-elle être remise en cause ?",
    options: [
      "En cas de découverte d’éléments nouveaux qui influencent la décision",
      "Jamais, la chose jugée est toujours définitive",
      "À la demande de la victime uniquement",
    ],
    answer:
        "En cas de découverte d’éléments nouveaux qui influencent la décision",
    explanation:
        "Certains mécanismes, comme la révision, permettent de remettre en cause une décision définitive sur présentation de nouveaux faits.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Effets de l’extinction",
    question: "Que signifie l’extinction de l’action publique ?",
    options: [
      "Que la procédure pénale est suspendue",
      "Que la procédure pénale s’arrête définitivement et ne peut plus être reprise",
      "Que le jugement est automatiquement annulé",
    ],
    answer:
        "Que la procédure pénale s’arrête définitivement et ne peut plus être reprise",
    explanation:
        "L’extinction met fin au pouvoir de poursuivre l’auteur des faits pour l’infraction considérée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Partie civile — Rôle",
    question:
        "Dans une procédure pénale, quel est le rôle principal de la partie civile ?",
    options: [
      "Obtenir la condamnation pénale",
      "Réclamer la réparation du préjudice subi",
      "Gérer les preuves à charge",
    ],
    answer: "Réclamer la réparation du préjudice subi",
    explanation:
        "La partie civile agit pour obtenir une réparation matérielle ou morale de son dommage dans le cadre du procès pénal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Procureur de la République — Pouvoirs",
    question:
        "Quelle est l’étendue du pouvoir du procureur de la République dans la conduite de l’action publique ?",
    options: [
      "Il dispose de tous les pouvoirs, y compris celui d’arrêter l’action publique une fois engagée",
      "Il peut engager l’action publique mais ne peut plus l’arrêter une fois qu’elle est engagée",
      "Il ne peut que conseiller le juge",
    ],
    answer:
        "Il peut engager l’action publique mais ne peut plus l’arrêter une fois qu’elle est engagée",
    explanation:
        "Cette limitation protège la cohérence et la continuité de l’action publique au nom de la société.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Mise en mouvement — Cas particuliers",
    question:
        "Quels sont certains cas particuliers où la mise en mouvement de l’action publique n’appartient pas au ministère public ?",
    options: [
      "Lorsque la victime décide seule d’engager des poursuites",
      "Lorsque des juridictions, la partie lésée ou certains fonctionnaires publics détiennent ce pouvoir",
      "Lorsqu’il s’agit de contraventions uniquement",
    ],
    answer:
        "Lorsque des juridictions, la partie lésée ou certains fonctionnaires publics détiennent ce pouvoir",
    explanation:
        "Certains organes ou personnes, tels que la chambre de l’instruction, le Défenseur des droits, ou la partie lésée peuvent déclencher l’action publique dans des cas spécifiques.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Transaction pénale — Conditions",
    question:
        "Quelles sont les conditions essentielles pour qu’une transaction pénale soit valide ?",
    options: [
      "Acceptation libre et éclairée de l’auteur des faits et homologation par le procureur",
      "Approbation du juge uniquement",
      "Simple accord verbal entre les parties",
    ],
    answer:
        "Acceptation libre et éclairée de l’auteur des faits et homologation par le procureur",
    explanation:
        "La validité de la transaction pénale repose sur un consentement réel et un contrôle par le ministère public.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Alternatives — Limites légales",
    question:
        "Les alternatives aux poursuites peuvent-elles s’appliquer à tous les types d’infractions ?",
    options: [
      "Oui, sans exception",
      "Non, certaines alternatives sont exclues pour les crimes ou infractions graves",
      "Oui, sauf si la victime s’y oppose",
    ],
    answer:
        "Non, certaines alternatives sont exclues pour les crimes ou infractions graves",
    explanation:
        "Les alternatives concernent principalement les contraventions et délits mineurs, et sont limitées pour les crimes.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Extinction — Prescription interrompue",
    question:
        "Qu’est-ce qui peut interrompre la prescription de l’action publique ?",
    options: [
      "Le décès de la victime",
      "Toutes les phases utiles d’une procédure, comme une plainte, une enquête ou une citation",
      "La simple médiation pénale",
    ],
    answer:
        "Toutes les phases utiles d’une procédure, comme une plainte, une enquête ou une citation",
    explanation:
        "Ces actes donnent un nouveau point de départ au délai de prescription, suspendant sa course.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Extinction — Effet de la chose jugée",
    question:
        "Selon le principe « non bis in idem », que signifie la chose jugée ?",
    options: [
      "Une personne peut être jugée plusieurs fois pour les mêmes faits sans limite",
      "Une personne ne peut plus être poursuivie ni jugée pour les mêmes faits une fois la décision définitive rendue",
      "La victime peut relancer indéfiniment la procédure civile",
    ],
    answer:
        "Une personne ne peut plus être poursuivie ni jugée pour les mêmes faits une fois la décision définitive rendue",
    explanation:
        "Le principe interdit les poursuites ou jugements multiples pour une même infraction.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Droits fondamentaux — Assistance",
    question:
        "Dans quels cas la personne suspectée a-t-elle le droit d’être assistée d’un défenseur ?",
    options: [
      "Uniquement lors du procès en correctionnelle",
      "Dès le début de la procédure et jusqu’à son terme",
      "Non, ce droit n’existe pas en procédure pénale",
    ],
    answer: "Dès le début de la procédure et jusqu’à son terme",
    explanation:
        "Le droit à l’assistance d’un avocat est garanti depuis le début jusqu’à la fin de la procédure.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Droits fondamentaux — Interprète",
    question:
        "Quelle garantie est offerte à une personne ne comprenant pas la langue française ?",
    options: [
      "Elle ne bénéficie d’aucune garantie particulière",
      "Elle bénéficie de l’assistance d’un interprète durant les interrogatoires et les audiences",
      "Elle doit apprendre le français avant la procédure",
    ],
    answer:
        "Elle bénéficie de l’assistance d’un interprète durant les interrogatoires et les audiences",
    explanation:
        "Cette garantie est essentielle pour assurer le caractère contradictoire et équitable du procès.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Droits fondamentaux — Droit au silence",
    question:
        "Quelles conséquences a le fait qu’une personne n’ait pas été informée de son droit de se taire ?",
    options: [
      "Ses déclarations seules ne peuvent servir à prononcer une condamnation",
      "Elle perd automatiquement son droit à la défense",
      "Cela n’a aucune conséquence sur le procès",
    ],
    answer:
        "Ses déclarations seules ne peuvent servir à prononcer une condamnation",
    explanation:
        "La non-information protège contre une condamnation fondée uniquement sur des déclarations sans aide d’un avocat.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Rôle du Ministère public",
    question:
        "Quelles sont les fonctions essentielles du ministère public dans la procédure pénale ?",
    options: [
      "Il conduit l’enquête pénale principale",
      "Il met en mouvement l’action publique, veille à l’application de la loi et représente la société côté poursuite",
      "Il agit comme conseil juridique auprès des parties civiles",
    ],
    answer:
        "Il met en mouvement l’action publique, veille à l’application de la loi et représente la société côté poursuite",
    explanation:
        "Le ministère public est chargé de défendre l’intérêt général dans le processus pénal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Ministère public — Transiger",
    question: "Le ministère public peut-il transiger sur l’action publique ?",
    options: [
      "Oui, librement et à tout moment",
      "Non, sauf dans certains cas légaux et pour certaines administrations spécifiques",
      "Oui, mais uniquement en matière criminelle",
    ],
    answer:
        "Non, sauf dans certains cas légaux et pour certaines administrations spécifiques",
    explanation:
        "Le parquet ne peut renoncer ou transiger en règle générale, mais certaines administrations (forêts, douanes) disposent de ce pouvoir.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Procureur général — Instructions",
    question:
        "Quel est le rôle du procureur général vis-à-vis du procureur de la République ?",
    options: [
      "Il peut édicter des instructions écrites qui engagent le parquet local à agir",
      "Il ne peut rien ordonner au procureur local",
      "Il agit uniquement comme juge d’appel",
    ],
    answer:
        "Il peut édicter des instructions écrites qui engagent le parquet local à agir",
    explanation:
        "La hiérarchie du parquet permet un contrôle fonctionnel sur les procureurs de la République.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Juridictions de jugement — Saisine d’office",
    question:
        "Dans quelles conditions une juridiction peut-elle se saisir d’office pour des infractions commises à l’audience ?",
    options: [
      "Toujours pour toute infraction constatée",
      "Sauf pour le délit d’outrage à magistrat et les crimes qui nécessitent une instruction préalable",
      "Jamais, la saisine d’office est interdite",
    ],
    answer:
        "Sauf pour le délit d’outrage à magistrat et les crimes qui nécessitent une instruction préalable",
    explanation:
        "Certaines infractions commises en audience peuvent être poursuivies spontanément par la juridiction compétente, avec exceptions.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Défenseur des droits — Pouvoirs pénaux",
    question:
        "Dans quelles circonstances particulières le Défenseur des droits peut-il proposer une transaction pénale ?",
    options: [
      "Pour n’importe quelle infraction",
      "Pour les cas avérés de discrimination lorsqu’aucune poursuite publique n’a été engagée",
      "Uniquement pour les délits routiers",
    ],
    answer:
        "Pour les cas avérés de discrimination lorsqu’aucune poursuite publique n’a été engagée",
    explanation:
        "Le Défenseur des droits peut intervenir par transaction pénale dans son domaine spécifique.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Informations au procureur — Obligations",
    question:
        "Qui est tenu d’informer sans délai le procureur de la République de la commission d’une infraction ?",
    options: [
      "Toute autorité constituée, tout officier public ou fonctionnaire dans l’exercice de ses fonctions",
      "Uniquement les victimes",
      "Les seuls avocats",
    ],
    answer:
        "Toute autorité constituée, tout officier public ou fonctionnaire dans l’exercice de ses fonctions",
    explanation:
        "La loi criminalise le défaut d’information pour garantir l’efficacité de l’action publique.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Obligations spécifiques — Autorités complémentaires",
    question:
        "Quels autres acteurs ont l’obligation de révéler des faits délictueux ?",
    options: [
      "Les maires, commissaires aux comptes, et autres selon les législations spéciales",
      "Seuls les officiers de police judiciaire",
      "Tous les citoyens sans exception",
    ],
    answer:
        "Les maires, commissaires aux comptes, et autres selon les législations spéciales",
    explanation:
        "Certaines professions ont des obligations spécialement définies par la loi pour révéler des infractions.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Compétence territoriale et matérielle",
    question:
        "Quels sont les limitations que le procureur doit vérifier avant d’engager l’action publique ?",
    options: [
      "Limitations territoriales et matérielles assurant la compétence légale de la juridiction concernée",
      "Aucune limitation, il agit librement partout",
      "Seulement la compétence matérielle mais pas territoriale",
    ],
    answer:
        "Limitations territoriales et matérielles assurant la compétence légale de la juridiction concernée",
    explanation:
        "Ces principes garantissent que l’affaire est traitée par la bonne juridiction compétente en temps et lieu.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Prescription — Calcul",
    question:
        "Quand commence à courir le délai de prescription de l’action publique ?",
    options: [
      "Au moment de l’infraction",
      "Au moment où l’infraction est découverte, ou la victime informée",
      "Au jour du jugement",
    ],
    answer: "Au moment où l’infraction est découverte, ou la victime informée",
    explanation:
        "La prescription vise à cesser l’action publique après un certain délai dès que l’État a eu connaissance des faits.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Recours contre les décisions du parquet",
    question:
        "Le parquet est-il soumis à des recours lorsqu’il décide d’engager ou de classer une procédure ?",
    options: [
      "Non, ses décisions sont souveraines et sans recours possibles",
      "Oui, la victime peut toujours faire appel",
      "Oui, le procureur général peut enjoindre au procureur local de poursuivre",
    ],
    answer:
        "Oui, le procureur général peut enjoindre au procureur local de poursuivre",
    explanation:
        "Le parquet supérieur peut intervenir pour contraindre à l’action publique dans certaines conditions.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Transaction pénale — Effet",
    question:
        "Une fois la transaction pénale conclue, que se passe-t-il concernant l’action publique ?",
    options: [
      "Elle est suspendue temporairement en attendant un jugement",
      "Elle est éteinte pour les faits concernés",
      "Elle est transformée en action civile",
    ],
    answer: "Elle est éteinte pour les faits concernés",
    explanation:
        "La transaction aboutit à l’extinction de l’action publique pour éviter un procès.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Extinction — Chose jugée",
    question:
        "Que signifie le principe « non bis in idem » en matière pénale ?",
    options: [
      "Qu’une personne peut être jugée deux fois si la qualification change",
      "Qu’une personne ne peut plus être poursuivie pour les mêmes faits une fois la décision devenue définitive",
      "Que la victime peut relancer indéfiniment la procédure",
    ],
    answer:
        "Qu’une personne ne peut plus être poursuivie pour les mêmes faits une fois la décision devenue définitive",
    explanation:
        "La chose jugée éteint l’action publique et interdit toute nouvelle poursuite pour les mêmes faits, même sous une qualification différente.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: 'ARSE — Notions générales',
    question:
        'La loi du 24 novembre 2009 a instauré l’assignation à résidence avec surveillance électronique (ARSE) pour :',
    options: [
      'Remplacer systématiquement la détention provisoire',
      'Être prononcée lorsque les obligations du contrôle judiciaire sont insuffisantes',
      'Sanctionner l’inexécution d’une peine d’amende',
    ],
    answer:
        'Être prononcée lorsque les obligations du contrôle judiciaire sont insuffisantes',
    explanation:
        'Le texte précise que l’ARSE doit être prononcée à l’encontre d’une personne mise en examen lorsque les obligations du contrôle judiciaire se révèlent insuffisantes.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'ARSE — Notions générales',
    question:
        'L’assignation à résidence avec surveillance électronique (ARSE) concerne :',
    options: [
      'Une personne simplement suspectée',
      'Une personne déjà condamnée définitivement',
      'Une personne mise en examen',
    ],
    answer: 'Une personne mise en examen',
    explanation:
        'Comme le contrôle judiciaire et la détention provisoire, l’ARSE vise une personne mise en examen dans le cadre d’une information.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'ARSE — Notions générales',
    question:
        'À quel article du Code de procédure pénale l’ARSE est-elle rattachée ?',
    options: [
      'Article 137 du C.P.P.',
      'Article 723-8 du C.P.P.',
      'Article 63-1 du C.P.P.',
    ],
    answer: 'Article 137 du C.P.P.',
    explanation:
        'La définition de l’assignation à résidence avec surveillance électronique est prévue à l’article 137 du Code de procédure pénale.',
    difficulty: 'Facile',
  ),

  // CONDITIONS DE MISE EN ŒUVRE
  QuizQuestion(
    category: 'ARSE — Conditions de mise en œuvre',
    question:
        'Selon l’article 142-5 alinéa 1 du C.P.P., l’assignation à résidence n’est possible que si la personne encourt :',
    options: [
      'Une simple contravention',
      'Une peine d’emprisonnement correctionnel d’au moins deux ans ou une peine plus grave',
      'Uniquement une peine d’amende',
    ],
    answer:
        'Une peine d’emprisonnement correctionnel d’au moins deux ans ou une peine plus grave',
    explanation:
        'Le texte exige un seuil de gravité : au moins deux ans d’emprisonnement correctionnel encourus ou une peine plus grave.',
    difficulty: 'Facile',
  ),

  // PRONONCÉ DE LA MESURE
  QuizQuestion(
    category: 'ARSE — Prononcé de la mesure',
    question: 'Parmi ces autorités, laquelle peut ordonner une ARSE ?',
    options: ['Le juge d’instruction', 'Le maire de la commune', 'Le préfet'],
    answer: 'Le juge d’instruction',
    explanation:
        'Le texte prévoit que l’assignation à résidence peut être ordonnée par le juge d’instruction, le JLD ou toute juridiction compétente.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'ARSE — Prononcé de la mesure',
    question:
        'En plus du juge d’instruction, qui peut également ordonner l’assignation à résidence avec surveillance électronique ?',
    options: [
      'Le juge des libertés et de la détention',
      'Le juge de l’application des peines uniquement',
      'Le greffier du tribunal',
    ],
    answer: 'Le juge des libertés et de la détention',
    explanation:
        'Le juge des libertés et de la détention fait partie des autorités pouvant prononcer l’ARSE.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'ARSE — Prononcé de la mesure',
    question:
        'Une juridiction de jugement peut-elle prononcer l’ARSE sans demande de la personne mise en examen ?',
    options: [
      'Oui, même en l’absence de demande de la personne et sans recueillir son accord',
      'Non, l’accord écrit de la personne est indispensable',
      'Non, seule la défense peut la solliciter',
    ],
    answer:
        'Oui, même en l’absence de demande de la personne et sans recueillir son accord',
    explanation:
        'Le texte précise que toute juridiction peut prononcer l’ARSE même sans demande de la personne et sans recueil préalable de son accord.',
    difficulty: 'Facile',
  ),

  // OBJET DE LA MESURE
  QuizQuestion(
    category: 'ARSE — Objet de la mesure',
    question:
        'L’objet principal de l’assignation à résidence avec surveillance électronique est :',
    options: [
      'De contraindre la personne à demeurer à son domicile ou dans une résidence fixée',
      'De placer la personne en détention dans une maison d’arrêt',
      'D’obliger la personne à se présenter chaque jour au commissariat',
    ],
    answer:
        'De contraindre la personne à demeurer à son domicile ou dans une résidence fixée',
    explanation:
        'La mesure consiste à obliger la personne à rester dans un lieu déterminé, avec des possibilités de sortie uniquement pour les motifs fixés par le juge.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'ARSE — Objet de la mesure',
    question:
        'L’assignation à résidence avec surveillance électronique peut comprendre, en plus de la présence au domicile :',
    options: [
      'Des obligations et interdictions prévues aux articles 138 et 138-3 du C.P.P.',
      'L’exécution immédiate d’une peine de prison ferme',
      'La confiscation automatique du véhicule de la personne',
    ],
    answer:
        'Des obligations et interdictions prévues aux articles 138 et 138-3 du C.P.P.',
    explanation:
        'L’ARSE peut être assortie de plusieurs obligations et interdictions similaires à celles du contrôle judiciaire.',
    difficulty: 'Facile',
  ),

  // FAISABILITÉ
  QuizQuestion(
    category: 'ARSE — Faisabilité technique',
    question:
        'Quel service est chargé de vérifier la faisabilité technique de la mesure d’ARSE ?',
    options: [
      'Le service pénitentiaire d’insertion et de probation (SPIP)',
      'Le service des impôts',
      'La mairie',
    ],
    answer: 'Le service pénitentiaire d’insertion et de probation (SPIP)',
    explanation:
        'Le juge statue après vérification par le SPIP de la faisabilité technique de la mise en place du dispositif.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'ARSE — Consentement',
    question:
        'La personne placée sous ARSE doit être informée que l’installation du dispositif de surveillance :',
    options: [
      'Ne nécessite pas son consentement',
      'Ne peut être effectuée sans son consentement, mais qu’un refus peut entraîner une détention provisoire',
      'Est décidée uniquement par la police',
    ],
    answer:
        'Ne peut être effectuée sans son consentement, mais qu’un refus peut entraîner une détention provisoire',
    explanation:
        'Le texte insiste sur le consentement à l’installation, tout en précisant que le refus peut justifier un placement en détention provisoire.',
    difficulty: 'Facile',
  ),

  // =====================================================
  // NIVEAU 2 — MOYEN
  // =====================================================

  // FAISABILITÉ ET PLACEMENT PROVISOIRE
  QuizQuestion(
    category: 'ARSE — Faisabilité technique',
    question:
        'Lorsque la peine encourue est égale ou supérieure à 3 ans et que la faisabilité technique n’a pas encore été vérifiée, le juge des libertés et de la détention peut :',
    options: [
      'Refuser systématiquement la mesure',
      'Ordonner un placement conditionnel sous ARSE en décidant d’une incarcération provisoire de 15 jours au plus',
      'Placer la personne sous simple contrôle judiciaire sans autre mesure',
    ],
    answer:
        'Ordonner un placement conditionnel sous ARSE en décidant d’une incarcération provisoire de 15 jours au plus',
    explanation:
        'L’article 142-6-1 permet au JLD de décider une incarcération provisoire de 15 jours au plus, le temps de vérifier la faisabilité de l’assignation.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'ARSE — Faisabilité technique',
    question:
        'Dans le cadre de la vérification de faisabilité, le juge doit saisir :',
    options: [
      'Immédiatement le service pénitentiaire d’insertion et de probation (SPIP)',
      'Le ministère de l’Intérieur',
      'Le service des douanes',
    ],
    answer:
        'Immédiatement le service pénitentiaire d’insertion et de probation (SPIP)',
    explanation:
        'Le texte prévoit que le juge saisit sans délai le SPIP d’une demande de rapport sur la faisabilité de la mesure.',
    difficulty: 'Moyen',
  ),

  // MODALITÉS DE SURVEILLANCE ÉLECTRONIQUE
  QuizQuestion(
    category: 'ARSE — Modalités de la surveillance',
    question:
        'La surveillance électronique dans le cadre de l’ARSE se fait conformément aux dispositions de l’article :',
    options: ['723-8 du C.P.P.', '63-2 du C.P.P.', '141-4 du C.P.P.'],
    answer: '723-8 du C.P.P.',
    explanation:
        'L’article 723-8 prévoit la mise en place d’un procédé permettant de détecter à distance la présence ou l’absence de la personne.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'ARSE — Modalités de la surveillance',
    question:
        'L’assignation à résidence avec mise sous surveillance électronique mobile peut notamment être mise en œuvre lorsque :',
    options: [
      'La personne est poursuivie pour une contravention routière',
      'L’infraction ayant motivé la mise en examen est punie de plus de 7 ans d’emprisonnement et qu’un suivi socio-judiciaire est encouru',
      'La personne ne s’est pas présentée à une convocation administrative',
    ],
    answer:
        'L’infraction ayant motivé la mise en examen est punie de plus de 7 ans d’emprisonnement et qu’un suivi socio-judiciaire est encouru',
    explanation:
        'Dans ce cas, il peut être fait recours au procédé de surveillance mobile prévu à l’article 763-12 du C.P.P.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'ARSE — Violences intrafamiliales',
    question:
        'L’ARSE peut être mise en œuvre lorsque la personne est mise en examen pour des violences ou menaces punies d’au moins 5 ans d’emprisonnement commises :',
    options: [
      'Contre tout inconnu dans la rue',
      'Contre son conjoint, concubin, partenaire de PACS ou leurs enfants',
      'Uniquement contre un agent public',
    ],
    answer:
        'Contre son conjoint, concubin, partenaire de PACS ou leurs enfants',
    explanation:
        'Le texte vise les violences ou menaces commises dans le cadre familial ou de couple, avec une peine encourue d’au moins 5 ans.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'ARSE — Extradition et mandats',
    question:
        'Parmi ces situations, laquelle peut justifier l’assignation à résidence avec surveillance électronique mobile ?',
    options: [
      'Une simple audition libre de témoin',
      'Une demande d’extradition ou un mandat d’arrêt européen',
      'Une convocation devant le conseil municipal',
    ],
    answer: 'Une demande d’extradition ou un mandat d’arrêt européen',
    explanation:
        'Le texte mentionne la demande d’extradition, le mandat d’arrêt européen et d’autres demandes d’arrestation provisoire comme cas d’ARSE mobile.',
    difficulty: 'Moyen',
  ),

  // DURÉE ET RENOUVELLEMENT
  QuizQuestion(
    category: 'ARSE — Durée de la mesure',
    question:
        'Selon l’article 142-7 du C.P.P., la durée maximale initiale de l’assignation à résidence avec surveillance électronique est de :',
    options: ['3 mois', '6 mois', '1 an'],
    answer: '6 mois',
    explanation:
        'La mesure est ordonnée pour une durée choisie par le juge dans la limite maximale de 6 mois.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'ARSE — Renouvellement',
    question: 'La mesure d’ARSE peut être renouvelée :',
    options: [
      'Par tranche de six mois après débat contradictoire, dans la limite de 2 ans',
      'Sans limitation de durée',
      'Uniquement une seule fois',
    ],
    answer:
        'Par tranche de six mois après débat contradictoire, dans la limite de 2 ans',
    explanation:
        'Le texte fixe une durée maximale totale de 2 ans, avec renouvellement tous les 6 mois après débat contradictoire.',
    difficulty: 'Moyen',
  ),

  // MANQUEMENTS
  QuizQuestion(
    category: 'ARSE — Manquements',
    question:
        'Si la personne ne respecte pas son assignation à résidence, le juge peut :',
    options: [
      'Simplement lui adresser un avertissement écrit',
      'Délivrer un mandat d’arrêt ou d’amener et la placer en détention provisoire',
      'Transformer automatiquement l’ARSE en peine d’emprisonnement définitive',
    ],
    answer:
        'Délivrer un mandat d’arrêt ou d’amener et la placer en détention provisoire',
    explanation:
        'En cas de non-respect de la mesure, un mandat d’arrêt ou d’amener peut être délivré et la personne placée en détention provisoire.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'ARSE — JLD et détention non justifiée',
    question:
        'Lorsque la personne est placée en détention provisoire pour non-respect de l’ARSE, le juge des libertés et de la détention, s’il estime que cette détention n’est pas justifiée, peut :',
    options: [
      'Mettre fin à toutes les mesures',
      'Modifier les obligations de l’assignation à résidence avec surveillance électronique',
      'Prononcer directement une peine définitive',
    ],
    answer:
        'Modifier les obligations de l’assignation à résidence avec surveillance électronique',
    explanation:
        'L’article 142-8 C.P.P. permet au JLD de modifier les obligations de l’ARSE lorsque la détention provisoire ne lui paraît pas justifiée.',
    difficulty: 'Moyen',
  ),

  // =====================================================
  // NIVEAU 3 — DIFFICILE
  // =====================================================

  // CAS PRATIQUES ET ARTICULATIONS
  QuizQuestion(
    category: 'ARSE — Cas pratique',
    question:
        'Une personne mise en examen pour un délit puni de 2 ans d’emprisonnement encourt-elle légalement l’ARSE au sens de l’article 142-5 alinéa 1 ?',
    options: [
      'Oui, car le seuil minimum d’emprisonnement encouru est atteint',
      'Non, il faut au moins 3 ans d’emprisonnement encouru',
      'Non, l’ARSE ne peut être prononcée que pour les crimes',
    ],
    answer: 'Oui, car le seuil minimum d’emprisonnement encouru est atteint',
    explanation:
        'Le texte exige au moins deux ans d’emprisonnement correctionnel encourus, ce qui est le cas ici.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'ARSE — Articulation avec le contrôle judiciaire',
    question: 'Sur le plan des principes, l’ARSE est mise en œuvre :',
    options: [
      'Avant toute possibilité de contrôle judiciaire',
      'Lorsque les obligations du contrôle judiciaire se révèlent insuffisantes',
      'Uniquement après une décision de condamnation définitive',
    ],
    answer:
        'Lorsque les obligations du contrôle judiciaire se révèlent insuffisantes',
    explanation:
        'Le texte introductif souligne que l’ARSE intervient lorsque le contrôle judiciaire ne suffit plus à garantir les objectifs de la procédure.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'ARSE — Consentement et détention',
    question:
        'La personne mise en examen refuse l’installation du dispositif électronique chez elle. Juridiquement :',
    options: [
      'Le dispositif peut être installé de force',
      'L’installation ne peut avoir lieu sans son consentement, mais ce refus peut entraîner son placement en détention provisoire',
      'Le juge doit obligatoirement renoncer à toute mesure',
    ],
    answer:
        'L’installation ne peut avoir lieu sans son consentement, mais ce refus peut entraîner son placement en détention provisoire',
    explanation:
        'Le texte précise clairement cette articulation entre consentement à l’installation et risque de détention.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'ARSE — Surveillance électronique mobile',
    question:
        'Dans le cadre d’une ARSE avec surveillance électronique mobile pour une infraction punie de plus de 7 ans d’emprisonnement, le juge d’instruction :',
    options: [
      'Exerce les prérogatives habituellement dévolues au juge d’application des peines',
      'Ne fait qu’exécuter les décisions du juge de l’application des peines',
      'N’a aucun rôle dans le suivi de la mesure',
    ],
    answer:
        'Exerce les prérogatives habituellement dévolues au juge d’application des peines',
    explanation:
        'Le texte prévoit explicitement que le juge d’instruction exerce alors les prérogatives du JAP.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'ARSE — Extradition et juridictions internationales',
    question:
        'L’ARSE avec surveillance électronique mobile peut être mise en œuvre lorsque la personne fait l’objet :',
    options: [
      'D’une simple audition libre',
      'D’une demande d’extradition, d’un mandat d’arrêt européen ou d’une demande d’arrestation provisoire aux fins de remise à la Cour pénale internationale',
      'D’une contravention de stationnement',
    ],
    answer:
        'D’une demande d’extradition, d’un mandat d’arrêt européen ou d’une demande d’arrestation provisoire aux fins de remise à la Cour pénale internationale',
    explanation:
        'Le texte cite expressément ces hypothèses internationales comme cas possibles de recours à l’ARSE mobile.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'ARSE — Durée maximale',
    question:
        'Une personne est placée sous ARSE depuis 18 mois. Le juge souhaite renouveler la mesure pour une nouvelle période de 6 mois. Cette décision est-elle conforme au texte ?',
    options: [
      'Oui, car aucune durée maximale n’est prévue',
      'Oui, la durée totale atteindra 24 mois, soit la limite légale',
      'Non, la durée maximale est de 18 mois',
    ],
    answer: 'Oui, la durée totale atteindra 24 mois, soit la limite légale',
    explanation:
        'L’article 142-7 fixe une durée maximale de 2 ans, soit 24 mois, par renouvellements successifs de 6 mois.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'ARSE — Non-respect réitéré',
    question:
        'En cas de non-respect répété de l’assignation à résidence malgré un premier rappel, la réponse la plus conforme à l’esprit des textes est :',
    options: [
      'Le maintien de l’ARSE sans changement',
      'La délivrance d’un mandat d’arrêt ou d’amener et la saisine du JLD en vue d’une détention provisoire',
      'La transformation automatique en peine d’emprisonnement définitive',
    ],
    answer:
        'La délivrance d’un mandat d’arrêt ou d’amener et la saisine du JLD en vue d’une détention provisoire',
    explanation:
        'Le texte prévoit la possibilité de placer la personne en détention provisoire en cas de non-respect de l’assignation.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'ARSE — Contrôle de la durée',
    question:
        'Une mesure d’ARSE a été renouvelée sans débat contradictoire. En pratique, quel est le principal risque juridique ?',
    options: [
      'Aucun, le débat contradictoire n’est jamais obligatoire',
      'Une contestation possible pour non-respect des conditions de renouvellement (débat contradictoire obligatoire)',
      'La nullité automatique de toute la procédure pénale',
    ],
    answer:
        'Une contestation possible pour non-respect des conditions de renouvellement (débat contradictoire obligatoire)',
    explanation:
        'L’article 142-7 impose un débat contradictoire pour chaque renouvellement, à défaut la mesure peut être contestée.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'ARSE — Synthèse des acteurs',
    question:
        'Parmi ces affirmations, laquelle décrit le plus fidèlement la répartition des rôles dans la mise en œuvre de l’ARSE ?',
    options: [
      'Seul le juge d’instruction peut ordonner, modifier ou révoquer l’ARSE',
      'Le juge d’instruction, le JLD et les juridictions de jugement peuvent ordonner l’ARSE, tandis que le SPIP vérifie sa faisabilité technique',
      'Seul le SPIP décide de l’ARSE après avis du parquet',
    ],
    answer:
        'Le juge d’instruction, le JLD et les juridictions de jugement peuvent ordonner l’ARSE, tandis que le SPIP vérifie sa faisabilité technique',
    explanation:
        'Les magistrats décident de la mesure, le SPIP intervient pour la faisabilité et le suivi.',
    difficulty: 'Difficile',
  ),

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
    category: "Détention provisoire — Notions générales",
    question: "La détention provisoire est une mesure de :",
    options: [
      "Peine d’emprisonnement définitive",
      "Incarcération dans une maison d’arrêt avant tout jugement",
      "Surveillance électronique au domicile",
    ],
    answer: "Incarcération dans une maison d’arrêt avant tout jugement",
    explanation:
        "La détention provisoire est une mesure d’incarcération avant jugement, exécutée en maison d’arrêt pour une personne mise en examen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question:
        "À l’égard de quelle catégorie de personnes la détention provisoire peut-elle être prononcée ?",
    options: [
      "Toute personne simplement suspectée",
      "Toute personne condamnée en appel",
      "Uniquement la personne mise en examen",
    ],
    answer: "Uniquement la personne mise en examen",
    explanation:
        "Le texte précise que seule la personne mise en examen peut faire l’objet d’une détention provisoire : le simple suspect ou le témoin assisté n’y sont pas soumis.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question:
        "La détention provisoire est-elle la règle ou l’exception selon l’article 137 du C.P.P. ?",
    options: [
      "La règle pour les crimes et délits graves",
      "Une mesure exceptionnelle",
      "Une mesure automatique en cas de crime",
    ],
    answer: "Une mesure exceptionnelle",
    explanation:
        "L’article 137 du C.P.P. rappelle que la détention provisoire doit rester exceptionnelle et strictement encadrée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question:
        "Pourquoi la détention provisoire est-elle difficilement compatible avec la présomption d’innocence ?",
    options: [
      "Parce qu’elle suppose déjà la culpabilité",
      "Parce qu’elle cause un préjudice grave et est perçue comme une culpabilité par l’opinion publique",
      "Parce qu’elle ne peut concerner que les récidivistes",
    ],
    answer:
        "Parce qu’elle cause un préjudice grave et est perçue comme une culpabilité par l’opinion publique",
    explanation:
        "Être incarcéré avant jugement fait supporter à la personne mise en examen le choc de l’emprisonnement et la réprobation publique, souvent assimilée à une présomption de culpabilité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question:
        "Quels articles du C.P.P. encadrent principalement la détention provisoire ?",
    options: [
      "Articles 100 à 120 du C.P.P.",
      "Articles 137 à 137-4 et 143-1 à 150 du C.P.P.",
      "Articles 221 à 230 du C.P.P.",
    ],
    answer: "Articles 137 à 137-4 et 143-1 à 150 du C.P.P.",
    explanation:
        "Le support indique que la détention provisoire est régie par les articles 137 à 137-4 et 143-1 à 150 du Code de procédure pénale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question: "La détention provisoire peut-elle être assimilée à une peine ?",
    options: [
      "Oui, car elle se déroule en maison d’arrêt",
      "Non, c’est une mesure de sûreté ou d’instruction",
      "Oui, pour les délits mais pas pour les crimes",
    ],
    answer: "Non, c’est une mesure de sûreté ou d’instruction",
    explanation:
        "La détention provisoire n’est pas une peine mais une mesure de sûreté, décidée pour les besoins de l’instruction ou pour prévenir certains risques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question:
        "Quel principe doit toujours guider le choix entre contrôle judiciaire, assignation à résidence avec bracelet électronique et détention provisoire ?",
    options: [
      "Le principe de proportionnalité et de nécessité",
      "Le principe du contradictoire",
      "Le principe de publicité des débats",
    ],
    answer: "Le principe de proportionnalité et de nécessité",
    explanation:
        "La détention provisoire doit être l’ultime recours, lorsque les obligations du contrôle judiciaire ou de l’assignation à résidence avec surveillance électronique sont insuffisantes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question:
        "Parmi les propositions suivantes, quelle affirmation est exacte concernant la détention provisoire ?",
    options: [
      "Elle peut être décidée pour une simple contravention",
      "Elle n’est possible que si la personne a été mise en examen",
      "Elle peut s’appliquer à un témoin assisté",
    ],
    answer: "Elle n’est possible que si la personne a été mise en examen",
    explanation:
        "Le texte rappelle clairement que seule une personne mise en examen peut être placée en détention provisoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question:
        "La détention provisoire peut-elle avoir pour seule finalité de faire pression sur la personne mise en examen pour qu’elle avoue ?",
    options: [
      "Oui, si les preuves sont faibles",
      "Non, ce serait contraire aux textes et aux droits de la défense",
      "Oui, uniquement sur décision du procureur",
    ],
    answer: "Non, ce serait contraire aux textes et aux droits de la défense",
    explanation:
        "La détention provisoire ne peut servir à obtenir des aveux ; ses finalités sont strictement encadrées par l’article 144 du C.P.P.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Notions générales",
    question:
        "L’opinion publique peut-elle justifier à elle seule le placement en détention provisoire ?",
    options: [
      "Oui, si l’affaire est très médiatisée",
      "Non, l’indignation médiatique ne suffit jamais seule",
      "Oui, dès lors que la victime le demande",
    ],
    answer: "Non, l’indignation médiatique ne suffit jamais seule",
    explanation:
        "Même si le trouble à l’ordre public est pris en compte, l’émotion médiatique ne peut justifier à elle seule la détention provisoire.",
    difficulty: "Difficile",
  ),

  // CONDITIONS DU PLACEMENT — PERSONNE ET NATURE DE L’INFRACTION
  QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question: "Qui ne peut jamais faire l’objet d’une détention provisoire ?",
    options: [
      "La personne simplement placée en garde à vue",
      "La personne mise en examen",
      "La personne condamnée en appel",
    ],
    answer: "La personne simplement placée en garde à vue",
    explanation:
        "La détention provisoire ne concerne que la personne mise en examen et suppose la saisine du juge d’instruction puis du juge des libertés et de la détention.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "Selon les conditions tenant à la nature de l’infraction, la détention provisoire est possible :",
    options: [
      "En cas de crime ou délit puni d’au moins 3 ans d’emprisonnement",
      "En cas de simple contravention",
      "Uniquement pour les crimes",
    ],
    answer: "En cas de crime ou délit puni d’au moins 3 ans d’emprisonnement",
    explanation:
        "Le document précise que la détention provisoire peut être décidée en cas de crime ou de délit puni d’au moins 3 ans d’emprisonnement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "La détention provisoire peut aussi être décidée lorsque la personne mise en examen :",
    options: [
      "Refuse d’être entendue par les enquêteurs",
      "Se soustrait volontairement aux obligations du contrôle judiciaire ou de l’assignation à résidence avec surveillance électronique",
      "N’a pas payé l’amende de composition pénale",
    ],
    answer:
        "Se soustrait volontairement aux obligations du contrôle judiciaire ou de l’assignation à résidence avec surveillance électronique",
    explanation:
        "En cas de non-respect volontaire de ces obligations, la détention provisoire peut être ordonnée pour assurer l’efficacité du contrôle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "La détention provisoire ne peut être ordonnée ou prolongée que si elle constitue :",
    options: [
      "L’unique moyen d’atteindre certains objectifs légalement prévus",
      "Une mesure de confort pour l’enquête",
      "Un moyen de faire pression sur la famille de la personne mise en examen",
    ],
    answer: "L’unique moyen d’atteindre certains objectifs légalement prévus",
    explanation:
        "L’article 144 du C.P.P. prévoit que la détention provisoire ne peut être décidée que si elle constitue le seul moyen d’atteindre un des objectifs énumérés par la loi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "Lequel des objectifs suivants figure parmi ceux permettant de justifier la détention provisoire selon l’art. 144 C.P.P. ?",
    options: [
      "Assurer le paiement des dommages et intérêts à la victime",
      "Conserver les preuves ou les indices matériels nécessaires à la manifestation de la vérité",
      "Assurer l’exécution de la future peine d’emprisonnement",
    ],
    answer:
        "Conserver les preuves ou les indices matériels nécessaires à la manifestation de la vérité",
    explanation:
        "L’un des objectifs légaux de la détention provisoire est de garantir la conservation des preuves ou indices matériels.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "Empêcher une pression sur les témoins ou les victimes ainsi que sur leur famille est :",
    options: [
      "Un objectif légal possible de la détention provisoire",
      "Un objectif interdit par la loi",
      "Une conséquence uniquement de la peine définitive",
    ],
    answer: "Un objectif légal possible de la détention provisoire",
    explanation:
        "L’article 144 C.P.P. mentionne expressément la nécessité d’empêcher les pressions sur témoins ou victimes comme raison possible d’ordonner la détention provisoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "Quel objectif concerne spécifiquement la protection de la personne mise en examen ?",
    options: [
      "Empêcher la concertation frauduleuse",
      "Protéger le mis en examen, notamment en cas de crime odieux",
      "Éviter la récidive après condamnation",
    ],
    answer: "Protéger le mis en examen, notamment en cas de crime odieux",
    explanation:
        "L’article 144 4° C.P.P. permet la détention pour protéger la personne mise en examen, par exemple contre des mouvements populaires dangereux en cas de crime odieux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "La détention provisoire peut être ordonnée pour garantir la mise à disposition de la justice de la personne mise en examen :",
    options: [
      "Uniquement si elle n’a pas de domicile fixe ou risque de s’enfuir",
      "Dans tous les cas, même lorsqu’elle a des attaches stables",
      "Seulement si la victime s’y oppose",
    ],
    answer: "Uniquement si elle n’a pas de domicile fixe ou risque de s’enfuir",
    explanation:
        "Le texte précise que cet objectif concerne notamment les personnes sans domicile ou celles dont on peut craindre la fuite.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "Mettre fin à une infraction ou éviter son renouvellement constitue :",
    options: [
      "Un des objectifs prévus à l’article 144 C.P.P.",
      "Une conséquence de la peine seulement",
      "Un motif purement disciplinaire",
    ],
    answer: "Un des objectifs prévus à l’article 144 C.P.P.",
    explanation:
        "L’article 144 permet la détention pour mettre fin à une infraction en cours ou éviter qu’elle se renouvelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Conditions de placement",
    question:
        "Le trouble exceptionnel et persistant à l’ordre public causé par l’infraction peut-il justifier une détention provisoire ?",
    options: [
      "Oui, à condition qu’il soit d’une gravité particulière et apprécié strictement",
      "Non, il est toujours sans incidence",
      "Oui, mais uniquement en matière contraventionnelle",
    ],
    answer:
        "Oui, à condition qu’il soit d’une gravité particulière et apprécié strictement",
    explanation:
        "L’article 144 7° C.P.P. prévoit que le trouble à l’ordre public résultant de l’infraction peut justifier la détention, mais seulement en matière criminelle et sous conditions strictes.",
    difficulty: "Difficile",
  ),

  // JUGE DES LIBERTÉS ET DE LA DÉTENTION — PLACEMENT
  QuizQuestion(
    category: "Détention provisoire — Juge des libertés et de la détention",
    question:
        "Quel magistrat est compétent pour décider du placement en détention provisoire ?",
    options: [
      "Le procureur de la République",
      "Le juge des libertés et de la détention",
      "Le juge de proximité",
    ],
    answer: "Le juge des libertés et de la détention",
    explanation:
        "La décision de placement en détention provisoire revient au juge des libertés et de la détention (J.L.D.), saisi par le juge d’instruction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Juge des libertés et de la détention",
    question:
        "Le J.L.D. peut-il se saisir d’office pour décider d’une détention provisoire ?",
    options: [
      "Oui, en cas d’urgence",
      "Non, il est toujours saisi par le juge d’instruction ou le procureur de la République",
      "Oui, s’il estime le contrôle judiciaire insuffisant",
    ],
    answer:
        "Non, il est toujours saisi par le juge d’instruction ou le procureur de la République",
    explanation:
        "Le document précise que le J.L.D. ne dispose d’aucune possibilité de se saisir d’office : il est toujours saisi par le juge d’instruction ou le procureur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Juge des libertés et de la détention",
    question:
        "Dans quelles hypothèses le juge d’instruction peut-il saisir le J.L.D. pour un placement en détention ?",
    options: [
      "Uniquement lors du premier interrogatoire de première comparution",
      "Lors du placement initial ou lors de la prolongation de la détention",
      "Seulement à la demande de la victime",
    ],
    answer:
        "Lors du placement initial ou lors de la prolongation de la détention",
    explanation:
        "Le J.L.D. intervient lors du placement initial ou pour prolonger la détention à la demande du juge d’instruction ou du procureur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Juge des libertés et de la détention",
    question: "À peine de nullité, le J.L.D. ne peut pas :",
    options: [
      "Rendre une ordonnance écrite",
      "Participer au jugement des affaires dont il a connu au stade de la détention provisoire",
      "Entendre la personne mise en examen en audience publique",
    ],
    answer:
        "Participer au jugement des affaires dont il a connu au stade de la détention provisoire",
    explanation:
        "Pour garantir l’impartialité, le J.L.D. ne peut pas ensuite siéger dans la formation de jugement des mêmes faits.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Juge des libertés et de la détention",
    question:
        "La saisine du J.L.D. pour un placement en détention provisoire en matière criminelle se fait :",
    options: [
      "Par ordonnance motivée du juge d’instruction accompagnée des réquisitions du procureur de la République",
      "Par simple demande orale de la victime",
      "Par procès-verbal de l’officier de police judiciaire",
    ],
    answer:
        "Par ordonnance motivée du juge d’instruction accompagnée des réquisitions du procureur de la République",
    explanation:
        "L’article 137-1 C.P.P. prévoit cette procédure formalisée pour garantir les droits de la défense.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Juge des libertés et de la détention",
    question:
        "En matière délictuelle, pour les délits punis de moins de 10 ans d’emprisonnement, le procureur de la République peut-il saisir directement le J.L.D. ?",
    options: [
      "Oui, malgré le refus de transmission du juge d’instruction",
      "Non, seule la victime le peut",
      "Non, uniquement le juge d’instruction peut saisir le J.L.D.",
    ],
    answer: "Oui, malgré le refus de transmission du juge d’instruction",
    explanation:
        "Le texte prévoit cette possibilité en cas de désaccord avec le juge d’instruction, afin que le J.L.D. statue.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Juge des libertés et de la détention",
    question:
        "Que doit contenir l’ordonnance de placement en détention provisoire rendue par le J.L.D. ?",
    options: [
      "Uniquement l’identité de la personne mise en examen",
      "L’énoncé des conditions de droit et de fait justifiant la détention et l’indication du caractère insuffisant des autres mesures",
      "Uniquement la durée prévue de détention",
    ],
    answer:
        "L’énoncé des conditions de droit et de fait justifiant la détention et l’indication du caractère insuffisant des autres mesures",
    explanation:
        "L’article 137-3 C.P.P. impose une motivation précise, notamment sur l’insuffisance du contrôle judiciaire ou de l’assignation à résidence.",
    difficulty: "Difficile",
  ),

  // CHAMBRE DE L’INSTRUCTION — PLACEMENT
  QuizQuestion(
    category: "Détention provisoire — Chambre de l’instruction",
    question:
        "La chambre de l’instruction peut-elle ordonner un placement en détention provisoire ?",
    options: [
      "Oui, elle peut placer ou maintenir la personne sous contrôle judiciaire uniquement",
      "Oui, elle peut ordonner la détention ou le contrôle judiciaire de la personne mise en examen",
      "Non, elle ne statue que sur les appels",
    ],
    answer:
        "Oui, elle peut ordonner la détention ou le contrôle judiciaire de la personne mise en examen",
    explanation:
        "L’article 201 C.P.P. permet à la chambre de l’instruction d’ordonner un acte utile, dont le placement en détention ou sous contrôle judiciaire.",
    difficulty: "Moyenne",
  ),

  // DURÉE DE LA DÉTENTION PROVISOIRE — RÈGLES GÉNÉRALES
  QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "Selon l’article 144-1 du C.P.P., la détention provisoire ne peut excéder une durée raisonnable appréciée :",
    options: [
      "Uniquement en fonction de la personnalité du mis en examen",
      "Au regard de la gravité des faits reprochés, de la complexité des investigations et du délai nécessaire à la manifestation de la vérité",
      "Uniquement en fonction de la surcharge des juridictions",
    ],
    answer:
        "Au regard de la gravité des faits reprochés, de la complexité des investigations et du délai nécessaire à la manifestation de la vérité",
    explanation:
        "Le magistrat doit apprécier la durée à partir de ces critères cumulatifs pour garantir une détention raisonnable.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "En matière correctionnelle, la durée initiale maximale de la détention provisoire est en principe de :",
    options: ["2 mois", "4 mois", "1 an"],
    answer: "4 mois",
    explanation:
        "Le tableau et l’article 145-1 C.P.P. indiquent que, sauf exceptions, la durée initiale de la détention en matière correctionnelle est de 4 mois.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "Toujours en matière correctionnelle, la durée maximale de la détention provisoire, après prolongations possibles, ne peut excéder :",
    options: ["4 mois", "6 mois", "2 ans"],
    answer: "6 mois",
    explanation:
        "En droit commun, en matière correctionnelle, la détention provisoire ne peut excéder 6 mois (article 145-1 C.P.P.), sauf hypothèses spécifiques (bandes organisées, etc.).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "En matière criminelle, hors régimes spéciaux, la durée initiale maximale de détention provisoire est de :",
    options: ["4 mois", "6 mois", "1 an"],
    answer: "1 an",
    explanation:
        "Le tableau « crimes » indique une durée initiale d’un an, avec possibilité de prolongations dans les limites prévues par l’article 145-2 C.P.P.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "Pour un crime de droit commun, la durée maximale totale de détention provisoire (initiale + prolongations) est en principe de :",
    options: ["2 ans", "3 ans", "4 ans"],
    answer: "2 ans",
    explanation:
        "Le tableau sur les crimes prévoit, pour certains crimes de droit commun, une durée totale maximale de 2 ans, sous réserve des régimes aggravés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "La détention provisoire peut-elle dépasser 4 ans en matière criminelle ?",
    options: [
      "Non, jamais",
      "Oui, jusqu’à 4 ans et 8 mois dans certains cas prévus de criminalité organisée",
      "Oui, sans limite si l’enquête est complexe",
    ],
    answer:
        "Oui, jusqu’à 4 ans et 8 mois dans certains cas prévus de criminalité organisée",
    explanation:
        "Le tableau mentionne que, dans certains cas (criminalité organisée, atteintes graves), les durées peuvent être prolongées exceptionnellement jusqu’à 4 ans et 8 mois.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "Pour les délits commis en bande organisée punis d’au moins 10 ans d’emprisonnement (trafic de stupéfiants, proxénétisme aggravé, etc.), la durée de détention correctionnelle peut atteindre :",
    options: ["6 mois au maximum", "1 an au maximum", "2 ans au maximum"],
    answer: "2 ans au maximum",
    explanation:
        "Pour ces délits spécifiques, l’article 145-1-1 C.P.P. permet de porter la détention provisoire jusqu’à 2 ans.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "Lorsque la chambre de l’instruction est saisie pour une procédure de « mise en état » (art. 221-3 C.P.P.), l’un de ses pouvoirs est notamment :",
    options: [
      "Prononcer la nullité d’un ou plusieurs actes",
      "Modifier la peine déjà prononcée",
      "Valider les perquisitions domiciliaires sans débat",
    ],
    answer: "Prononcer la nullité d’un ou plusieurs actes",
    explanation:
        "Le texte mentionne que la chambre de l’instruction peut, par exemple, prononcer la nullité d’actes de procédure ou ordonner le règlement de l’affaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "Le dépassement des délais pour statuer sur une demande de mise en liberté entraîne :",
    options: [
      "La prolongation automatique de la détention",
      "La mise en liberté de plein droit",
      "L’irrecevabilité de la demande suivante",
    ],
    answer: "La mise en liberté de plein droit",
    explanation:
        "Le texte indique que l’inobservation des délais pour statuer sur les demandes de mise en liberté entraîne une mise en liberté automatique (de plein droit).",
    difficulty: "Moyenne",
  ),

  // PROLONGATION DE LA DÉTENTION PROVISOIRE
  QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "De qui relève la décision de prolonger la détention provisoire ?",
    options: [
      "Du procureur de la République",
      "Du juge des libertés et de la détention, saisi par le juge d’instruction",
      "Du chef d’établissement pénitentiaire",
    ],
    answer:
        "Du juge des libertés et de la détention, saisi par le juge d’instruction",
    explanation:
        "La prolongation est décidée par ordonnance motivée du J.L.D., saisi par le juge d’instruction, qui transmet le dossier accompagné des réquisitions du parquet.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Durée et prolongations",
    question:
        "Toute prolongation de détention provisoire doit se faire après :",
    options: [
      "Une audience contradictoire devant le J.L.D. ou la chambre de l’instruction",
      "Une simple note de service du juge d’instruction",
      "Une demande écrite de la victime",
    ],
    answer:
        "Une audience contradictoire devant le J.L.D. ou la chambre de l’instruction",
    explanation:
        "Le principe du contradictoire impose qu’une prolongation de détention soit décidée après débat entre les parties.",
    difficulty: "Moyenne",
  ),

  // FIN DE LA DÉTENTION PROVISOIRE — RÈGLEMENT DE LA PROCÉDURE
  QuizQuestion(
    category: "Détention provisoire — Fin de la détention provisoire",
    question: "La détention provisoire prend fin automatiquement en cas :",
    options: [
      "De non-lieu ou de requalification des faits en contravention ne relevant plus de l’article 144 C.P.P.",
      "De désaccord entre le juge d’instruction et le parquet",
      "De condamnation en première instance",
    ],
    answer:
        "De non-lieu ou de requalification des faits en contravention ne relevant plus de l’article 144 C.P.P.",
    explanation:
        "Le chapitre 3 rappelle que la détention provisoire cesse lorsque la procédure aboutit à un non-lieu ou que les faits ne justifient plus une telle mesure.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Fin de la détention provisoire",
    question:
        "En cas de renvoi devant le tribunal correctionnel, l’ordonnance de renvoi :",
    options: [
      "Met obligatoirement fin à la détention provisoire",
      "Peut maintenir la détention jusqu’à la comparution devant le tribunal par ordonnance spécialement motivée",
      "Doit toujours transformer la détention en contrôle judiciaire",
    ],
    answer:
        "Peut maintenir la détention jusqu’à la comparution devant le tribunal par ordonnance spécialement motivée",
    explanation:
        "L’article 179 C.P.P. précise que le juge de l’instruction peut maintenir l’intéressé en détention jusqu’à l’audience, si sa décision est spécialement motivée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Fin de la détention provisoire",
    question:
        "En cas de renvoi devant la cour d’assises, la détention provisoire :",
    options: [
      "Prend fin dès l’ordonnance de mise en accusation",
      "Peut être maintenue jusqu’à la comparution devant la cour, sur décision de la chambre de l’instruction",
      "Doit être transformée en assignation à résidence",
    ],
    answer:
        "Peut être maintenue jusqu’à la comparution devant la cour, sur décision de la chambre de l’instruction",
    explanation:
        "L’article 181 C.P.P. prévoit que la chambre de l’instruction peut ordonner le maintien en détention jusqu’à l’audience d’assises.",
    difficulty: "Difficile",
  ),

  // DEMANDES DE MISE EN LIBERTÉ — RÈGLES GÉNÉRALES
  QuizQuestion(
    category: "Détention provisoire — Demandes de mise en liberté",
    question:
        "Selon l’article 148 C.P.P., qui peut demander à tout moment la mise en liberté de la personne détenue ?",
    options: [
      "Uniquement le procureur de la République",
      "La personne mise en examen ou son avocat",
      "Seulement la victime ou la partie civile",
    ],
    answer: "La personne mise en examen ou son avocat",
    explanation:
        "La mise en liberté peut être demandée à tout moment par l’intéressé ou par son conseil.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Demandes de mise en liberté",
    question:
        "Après renvoi devant une juridiction de jugement, l’intéressé peut demander sa mise en liberté :",
    options: [
      "Uniquement pendant l’audience",
      "À tout moment de la procédure devant la juridiction de jugement",
      "Uniquement par l’intermédiaire du parquet",
    ],
    answer: "À tout moment de la procédure devant la juridiction de jugement",
    explanation:
        "L’article 148-2 C.P.P. prévoit que, après renvoi, la demande de mise en liberté est portée devant la juridiction de jugement compétente.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Demandes de mise en liberté",
    question:
        "Lorsque le juge d’instruction reçoit une demande de mise en liberté, il doit :",
    options: [
      "La transmettre immédiatement au procureur de la République pour réquisitions",
      "La rejeter systématiquement",
      "La renvoyer au J.L.D. sans avis",
    ],
    answer:
        "La transmettre immédiatement au procureur de la République pour réquisitions",
    explanation:
        "Le magistrat instructeur recueille l’avis du parquet avant de statuer ou de transmettre au juge des libertés et de la détention.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Demandes de mise en liberté",
    question: "Si le juge d’instruction refuse la mise en liberté, il doit :",
    options: [
      "Rendre une ordonnance motivée susceptible d’appel",
      "Simplement informer le chef d’établissement pénitentiaire",
      "Renvoyer d’office l’affaire devant la cour d’assises",
    ],
    answer: "Rendre une ordonnance motivée susceptible d’appel",
    explanation:
        "En cas de rejet, sa décision doit être motivée et peut être déférée à la chambre de l’instruction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Demandes de mise en liberté",
    question:
        "Quand la chambre de l’instruction est saisie d’une demande de mise en liberté, elle doit statuer :",
    options: [
      "Dans un délai de 30 jours à compter de la réception de la demande",
      "Dans un délai de 24 heures",
      "Sans aucun délai légal",
    ],
    answer: "Dans un délai de 30 jours à compter de la réception de la demande",
    explanation:
        "Le texte précise que la chambre de l’instruction dispose de 30 jours pour statuer, sous peine de mise en liberté de plein droit en cas de dépassement des délais.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Demandes de mise en liberté",
    question:
        "En cas de carence du juge des libertés et de la détention qui n’a pas statué dans les 5 jours ouvrables, la demande de mise en liberté est portée :",
    options: [
      "Devant la chambre de l’instruction",
      "Devant le juge de proximité",
      "Devant le tribunal de police",
    ],
    answer: "Devant la chambre de l’instruction",
    explanation:
        "L’article 148-4 C.P.P. prévoit un mécanisme de « dessaisissement » automatique au profit de la chambre de l’instruction.",
    difficulty: "Difficile",
  ),

  // MISE EN LIBERTÉ DE PLEIN DROIT / D’OFFICE
  QuizQuestion(
    category: "Détention provisoire — Mise en liberté de plein droit",
    question:
        "À l’expiration de la durée légale de détention provisoire, prolongations comprises, la mise en liberté :",
    options: [
      "Est laissée à l’appréciation du juge",
      "Est automatique (de plein droit)",
      "N’est possible qu’à la demande de la victime",
    ],
    answer: "Est automatique (de plein droit)",
    explanation:
        "L’article 148-1-1 C.P.P. prévoit que la fin de la durée maximale entraîne la libération de plein droit de la personne détenue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Mise en liberté de plein droit",
    question:
        "Quelle conséquence entraîne l’inobservation des délais pour statuer sur une demande de mise en liberté ?",
    options: [
      "La nullité de la demande",
      "La mise en liberté de plein droit",
      "La prolongation de 4 mois de la détention",
    ],
    answer: "La mise en liberté de plein droit",
    explanation:
        "Le non-respect des délais est sanctionné par une libération automatique, sans nouvelle décision de détention.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Mise en liberté d’office",
    question: "La mise en liberté d’office peut être décidée :",
    options: [
      "Par le juge d’instruction ou la chambre de l’instruction, même sans demande de l’intéressé",
      "Uniquement à la demande du mis en examen",
      "Uniquement par le procureur général",
    ],
    answer:
        "Par le juge d’instruction ou la chambre de l’instruction, même sans demande de l’intéressé",
    explanation:
        "Le texte évoque une mise en liberté décidée d’office lorsque la détention n’apparaît plus nécessaire à la bonne marche de l’information.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Mise en liberté d’office",
    question:
        "Avant d’ordonner une mise en liberté d’office, le juge d’instruction doit :",
    options: [
      "Obtenir l’accord de la victime",
      "Demander obligatoirement l’avis du procureur de la République",
      "Saisir le Conseil supérieur de la magistrature",
    ],
    answer: "Demander obligatoirement l’avis du procureur de la République",
    explanation:
        "La loi impose au juge d’instruction de recueillir l’avis du parquet avant de décider la mise en liberté d’office.",
    difficulty: "Difficile",
  ),

  // MISE EN LIBERTÉ POUR RAISONS DE SANTÉ
  QuizQuestion(
    category: "Détention provisoire — Mise en liberté pour raison de santé",
    question:
        "La mise en liberté pour raison de santé peut être ordonnée lorsqu’une expertise médicale établit que :",
    options: [
      "La personne refuse de se soigner",
      "La personne est atteinte d’une pathologie engageant le pronostic vital ou que son état de santé est incompatible avec la détention",
      "La personne est simplement fatiguée par la détention",
    ],
    answer:
        "La personne est atteinte d’une pathologie engageant le pronostic vital ou que son état de santé est incompatible avec la détention",
    explanation:
        "L’article 147-1 C.P.P. prévoit la mise en liberté lorsque l’état de santé physique ou mentale est incompatible avec la détention provisoire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Mise en liberté pour raison de santé",
    question:
        "La mise en liberté pour raison de santé peut-elle être refusée en cas de risque grave de renouvellement de l’infraction ?",
    options: [
      "Non, la santé prime toujours sur la sécurité publique",
      "Oui, si le risque de récidive est grave et établi",
      "Non, dès l’instant où l’expert conclut à l’incompatibilité",
    ],
    answer: "Oui, si le risque de récidive est grave et établi",
    explanation:
        "Le texte prévoit une exception à la mise en liberté sanitaire en cas de risque grave de renouvellement de l’infraction.",
    difficulty: "Difficile",
  ),

  // RÉPARATION D’UNE DÉTENTION PROVISOIRE INJUSTIFIÉE
  QuizQuestion(
    category: "Détention provisoire — Réparation",
    question:
        "Selon l’article 149 C.P.P., qui peut prétendre à une réparation pour détention provisoire injustifiée ?",
    options: [
      "La personne ayant bénéficié d’un non-lieu, d’une relaxe ou d’un acquittement définitif",
      "Uniquement la victime de l’infraction",
      "Toute personne ayant été condamnée à une peine inférieure au temps de détention provisoire",
    ],
    answer:
        "La personne ayant bénéficié d’un non-lieu, d’une relaxe ou d’un acquittement définitif",
    explanation:
        "Le dispositif d’indemnisation vise la personne injustement détenue qui est finalement mise hors de cause.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Réparation",
    question:
        "L’indemnisation pour détention provisoire injustifiée est accordée :",
    options: [
      "Par le premier président de la cour d’appel",
      "Par le juge d’instruction",
      "Par le J.L.D.",
    ],
    answer: "Par le premier président de la cour d’appel",
    explanation:
        "C’est le premier président de la cour d’appel qui statue sur la demande d’indemnisation présentée par l’ancien détenu.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Réparation",
    question: "La réparation d’une détention provisoire injustifiée couvre :",
    options: [
      "Uniquement le préjudice matériel",
      "Uniquement le préjudice moral",
      "Le préjudice matériel et le préjudice moral",
    ],
    answer: "Le préjudice matériel et le préjudice moral",
    explanation:
        "L’article 149 C.P.P. vise l’indemnisation du préjudice matériel et moral causé par la détention injustifiée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Réparation",
    question:
        "Certaines personnes sont exclues du droit à indemnisation pour détention provisoire injustifiée, notamment :",
    options: [
      "Le dénonciateur de mauvaise foi et le faux témoin ayant provoqué la détention",
      "Les personnes sans domicile fixe",
      "Les personnes condamnées pour d’autres infractions",
    ],
    answer:
        "Le dénonciateur de mauvaise foi et le faux témoin ayant provoqué la détention",
    explanation:
        "Le texte précise que quelques cas sont exclus, notamment lorsque la détention est la conséquence d’une fraude ou d’une faute grave imputable au demandeur.",
    difficulty: "Difficile",
  ),

  // TABLEAU DÉLITS — APPLICATION CHIFFRÉE (CAS PRATIQUES)
  QuizQuestion(
    category: "Détention provisoire — Tableaux délits",
    question:
        "Un mis en examen pour un délit puni de 3 ans d’emprisonnement encourt au maximum, en matière correctionnelle de droit commun, une détention provisoire de :",
    options: ["4 mois", "6 mois", "1 an"],
    answer: "6 mois",
    explanation:
        "Pour les délits punis de 3 ans, le régime de droit commun s’applique : 4 mois initiaux, éventuellement prolongés, dans la limite totale de 6 mois.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Tableaux délits",
    question:
        "Pour un délit puni de 7 ans d’emprisonnement mais ne relevant pas de la criminalité organisée, la durée initiale de détention provisoire est de :",
    options: ["4 mois", "6 mois", "1 an"],
    answer: "4 mois",
    explanation:
        "Le tableau « délits » fixe une durée initiale de 4 mois en matière correctionnelle, quelle que soit la peine encourue, sauf régimes spéciaux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Tableaux délits",
    question:
        "Pour un délit de trafic de stupéfiants commis en bande organisée, puni de 10 ans, la durée maximale de détention provisoire peut atteindre :",
    options: ["6 mois", "1 an", "2 ans"],
    answer: "2 ans",
    explanation:
        "Les délits commis en bande organisée punis d’au moins 10 ans relèvent du régime aggravé de l’article 145-1-1 C.P.P., permettant 2 ans de détention.",
    difficulty: "Difficile",
  ),

  // TABLEAU CRIMES — APPLICATION CHIFFRÉE
  QuizQuestion(
    category: "Détention provisoire — Tableaux crimes",
    question:
        "Pour un crime puni de 20 ans de réclusion criminelle, la durée initiale de détention provisoire est de :",
    options: ["4 mois", "6 mois", "1 an"],
    answer: "1 an",
    explanation:
        "Le tableau « crimes » indique une durée initiale d’un an, quelle que soit la peine encourue, avec des prolongations ensuite encadrées.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Tableaux crimes",
    question:
        "Pour certains crimes graves, la durée totale maximale de détention provisoire peut atteindre 3 ans. Cela suppose :",
    options: [
      "Plusieurs prolongations successives décidées par la chambre de l’instruction",
      "Une simple ordonnance du procureur",
      "Une demande écrite de la victime",
    ],
    answer:
        "Plusieurs prolongations successives décidées par la chambre de l’instruction",
    explanation:
        "Le tableau prévoit des durées maximales (2 ans, 3 ans, 4 ans) atteintes par des prolongations successives, toujours motivées et décidées après débat.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Tableaux crimes",
    question:
        "Dans les hypothèses les plus graves prévues par le C.P.P. (criminalité organisée, terrorisme…), la durée totale de détention provisoire peut aller jusqu’à :",
    options: ["2 ans", "3 ans", "4 ans et 8 mois"],
    answer: "4 ans et 8 mois",
    explanation:
        "Le tableau des crimes mentionne cette durée maximale exceptionnelle pour certaines infractions particulièrement graves.",
    difficulty: "Difficile",
  ),

  // CAS PRATIQUES — MISE EN SITUATION
  QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Un individu est mis en examen pour un délit puni de 2 ans d’emprisonnement. Peut-il être placé en détention provisoire ?",
    options: [
      "Oui, car toute peine d’emprisonnement autorise la détention",
      "Non, car le délit n’est pas puni d’au moins 3 ans d’emprisonnement",
      "Oui, uniquement si la victime est d’accord",
    ],
    answer:
        "Non, car le délit n’est pas puni d’au moins 3 ans d’emprisonnement",
    explanation:
        "La condition légale impose un crime ou un délit puni d’au moins 3 ans d’emprisonnement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Une personne mise en examen respecte toutes les obligations de son contrôle judiciaire, mais l’affaire est très médiatisée. Le seul motif avancé est l’apaisement du trouble à l’ordre public. La détention provisoire est-elle possible en matière délictuelle ?",
    options: [
      "Oui, le trouble à l’ordre public suffit",
      "Non, le trouble à l’ordre public n’est pris en compte que dans certains cas, notamment en matière criminelle",
      "Oui, si la victime le demande",
    ],
    answer:
        "Non, le trouble à l’ordre public n’est pris en compte que dans certains cas, notamment en matière criminelle",
    explanation:
        "Le trouble exceptionnel et persistant à l’ordre public est un motif principalement admis en matière criminelle et apprécié strictement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Un mis en examen est sans domicile fixe et n’a pas de attaches stables. Quel objectif de l’article 144 peut justifier sa détention provisoire ?",
    options: [
      "Protéger les témoins",
      "Garantir sa mise à disposition de la justice et prévenir le risque de fuite",
      "Assurer la réparation du préjudice civil",
    ],
    answer:
        "Garantir sa mise à disposition de la justice et prévenir le risque de fuite",
    explanation:
        "L’absence d’attaches peut rendre nécessaire la détention pour garantir la présence de la personne aux actes de procédure.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Une personne mise en examen pour un crime est détenue depuis 8 mois. L’enquête est peu complexe et les principaux témoins ont déjà été entendus. Le juge souhaite prolonger la détention par simple crainte d’un émoi médiatique. Cette prolongation est-elle conforme aux principes de la détention provisoire ?",
    options: [
      "Oui, la durée reste inférieure à 1 an",
      "Non, car la détention doit rester raisonnable et répondre à un des objectifs strictement énumérés",
      "Oui, si le J.L.D. accepte",
    ],
    answer:
        "Non, car la détention doit rester raisonnable et répondre à un des objectifs strictement énumérés",
    explanation:
        "La simple crainte médiatique ne suffit pas et la durée doit être justifiée par les nécessités de l’instruction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Un détenu dépose une demande de mise en liberté. Le juge des libertés et de la détention ne statue pas dans le délai de 5 jours ouvrables. Quelle est la conséquence ?",
    options: [
      "La demande est considérée comme rejetée",
      "L’affaire est portée devant la chambre de l’instruction",
      "La détention est automatiquement prolongée de 4 mois",
    ],
    answer: "L’affaire est portée devant la chambre de l’instruction",
    explanation:
        "Le mécanisme de dessaisissement prévoit la saisine de la chambre de l’instruction en cas de carence du J.L.D.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Un mis en examen détenu pour un délit punissable de 5 ans est toujours incarcéré après 7 mois de détention, sans régime aggravé applicable. Quelle est la situation ?",
    options: [
      "La détention est conforme, la durée maximale est de 2 ans",
      "La détention est irrégulière, la durée maximale était de 6 mois",
      "La durée maximale est de 1 an",
    ],
    answer: "La détention est irrégulière, la durée maximale était de 6 mois",
    explanation:
        "En matière correctionnelle de droit commun, la durée totale ne peut excéder 6 mois : il doit être remis en liberté de plein droit.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Une personne a bénéficié d’un non-lieu après 9 mois de détention provisoire. Elle souhaite obtenir réparation. Vers quelle autorité doit-elle se tourner ?",
    options: [
      "Le juge d’instruction",
      "Le premier président de la cour d’appel",
      "Le J.L.D.",
    ],
    answer: "Le premier président de la cour d’appel",
    explanation:
        "C’est lui qui est compétent pour statuer sur les demandes d’indemnisation pour détention injustifiée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Une expertise médicale conclut à l’incompatibilité de l’état psychique d’un détenu avec la détention, sans risque particulier de récidive. Quelle mesure doit être privilégiée ?",
    options: [
      "Le maintien en détention avec suivi médical",
      "La mise en liberté pour raison de santé",
      "La prolongation de la détention jusqu’au jugement",
    ],
    answer: "La mise en liberté pour raison de santé",
    explanation:
        "L’article 147-1 C.P.P. prévoit la mise en liberté lorsque la détention est incompatible avec l’état de santé, en l’absence de risque grave de renouvellement de l’infraction.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: 'CJPM — Principes généraux',
    question:
        'Le code de la justice pénale des mineurs (CJPM) fixe notamment comme principe :',
    options: [
      'La primauté de la réponse éducative sur la réponse répressive',
      'La primauté de la réponse répressive sur la réponse éducative',
      'L’absence de toute réponse pénale pour les mineurs',
    ],
    answer: 'La primauté de la réponse éducative sur la réponse répressive',
    explanation:
        'Parmi les trois principes fondamentaux, le CJPM consacre la primauté de la réponse éducative.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'CJPM — Principes généraux',
    question:
        'Parmi ces principes, lequel fait partie des fondements de la justice pénale des mineurs ?',
    options: [
      'Le jugement par une juridiction spécialisée',
      'Le jugement exclusivement par les juridictions de majeurs',
      'Le jugement par un jury populaire uniquement',
    ],
    answer: 'Le jugement par une juridiction spécialisée',
    explanation:
        'Le CJPM prévoit que les mineurs sont jugés par des juridictions et chambres spécialisées.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'CJPM — Principes généraux',
    question:
        'Le CJPM rappelle en liminaire que l’intérêt supérieur de l’enfant :',
    options: [
      'Est accessoire par rapport à l’ordre public',
      'Doit être pris en compte comme principe directeur de toute la procédure',
      'Ne s’applique qu’aux enfants de moins de 10 ans',
    ],
    answer:
        'Doit être pris en compte comme principe directeur de toute la procédure',
    explanation:
        'L’intérêt supérieur de l’enfant, issu de la CIDE, est érigé en principe directeur de la procédure pénale des mineurs.',
    difficulty: 'Facile',
  ),

  // PRÉSOMPTION DE DISCERNEMENT
  QuizQuestion(
    category: 'CJPM — Discernement',
    question:
        'Le seuil d’âge de la capacité de discernement, et donc de la responsabilité pénale, est fixé à :',
    options: ['10 ans', '13 ans', '16 ans'],
    answer: '13 ans',
    explanation:
        'Le CJPM reprend le principe de l’article 122-8 du Code pénal : le seuil de discernement est fixé à 13 ans.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'CJPM — Discernement',
    question: 'Pour les mineurs de moins de 13 ans, la présomption est :',
    options: [
      'Une présomption de discernement',
      'Une présomption de non discernement',
      'Une présomption de culpabilité',
    ],
    answer: 'Une présomption de non discernement',
    explanation:
        'Le texte prévoit une présomption de non discernement pour les moins de 13 ans.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'CJPM — Discernement',
    question: 'Pour les mineurs de plus de 13 ans, la présomption est :',
    options: [
      'Une présomption de discernement',
      'Une présomption d’innocence supprimée',
      'Une présomption de dangerosité',
    ],
    answer: 'Une présomption de discernement',
    explanation:
        'Au-delà de 13 ans, il existe une présomption de discernement, donc de responsabilité pénale possible.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'CJPM — Discernement',
    question:
        'La capacité de discernement d’un mineur se définit notamment par :',
    options: [
      'La capacité à comprendre et vouloir l’acte et à comprendre le sens de la procédure',
      'Sa taille et son niveau scolaire',
      'Le fait d’être déjà connu des services de police',
    ],
    answer:
        'La capacité à comprendre et vouloir l’acte et à comprendre le sens de la procédure',
    explanation:
        'Le CJPM donne cette définition fonctionnelle du discernement.',
    difficulty: 'Facile',
  ),

  // MINEUR < 13 / ≥ 13
  QuizQuestion(
    category: 'CJPM — Responsabilité pénale',
    question: 'Pour un mineur de moins de 13 ans, en principe :',
    options: [
      'Des peines peuvent être prononcées comme pour un majeur',
      'Aucune peine ne peut être encourue, seules des mesures éducatives sont possibles en cas de discernement',
      'Il ne peut faire l’objet d’aucune mesure',
    ],
    answer:
        'Aucune peine ne peut être encourue, seules des mesures éducatives sont possibles en cas de discernement',
    explanation:
        'Le CJPM interdit le prononcé de peines avant 13 ans, mais autorise des mesures éducatives si le discernement est établi.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'CJPM — Responsabilité pénale',
    question: 'Pour un mineur âgé d’au moins 13 ans :',
    options: [
      'Seules des peines sont possibles',
      'Seules des mesures éducatives sont possibles',
      'Des mesures éducatives et/ou des peines peuvent être prononcées',
    ],
    answer: 'Des mesures éducatives et/ou des peines peuvent être prononcées',
    explanation:
        'Après 13 ans, la palette va de la mesure éducative à la peine, en tenant compte de l’atténuation de responsabilité.',
    difficulty: 'Facile',
  ),

  // SPÉCIALISATION DES ACTEURS
  QuizQuestion(
    category: 'CJPM — Juridictions spécialisées',
    question:
        'Quel juge est spécialement compétent pour les affaires pénales concernant les mineurs ?',
    options: [
      'Le juge des enfants',
      'Le juge de l’application des peines des majeurs',
      'Le juge administratif',
    ],
    answer: 'Le juge des enfants',
    explanation:
        'Le juge des enfants est l’un des acteurs spécialisés de la justice pénale des mineurs.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'CJPM — Juridictions spécialisées',
    question: 'Les crimes reprochés à un mineur sont jugés par :',
    options: [
      'La cour d’assises des mineurs',
      'La cour d’assises de droit commun sans adaptation',
      'Le conseil municipal',
    ],
    answer: 'La cour d’assises des mineurs',
    explanation:
        'La cour d’assises des mineurs est composée avec des assesseurs juges des enfants.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'CJPM — Juridictions spécialisées',
    question:
        'Les fonctions du ministère public en matière de crimes, délits et contraventions de 5ᵉ classe reprochés à un mineur sont remplies par :',
    options: [
      'Un policier spécialement désigné',
      'Le procureur général ou un magistrat du ministère public spécialement chargé des affaires de mineurs',
      'Le maire',
    ],
    answer:
        'Le procureur général ou un magistrat du ministère public spécialement chargé des affaires de mineurs',
    explanation:
        'Le CJPM consacre la spécialisation du parquet pour les affaires de mineurs.',
    difficulty: 'Facile',
  ),

  // DROITS SPÉCIFIQUES
  QuizQuestion(
    category: 'CJPM — Droits spécifiques',
    question: 'En principe, le mineur poursuivi pénalement est assisté :',
    options: [
      'D’un avocat',
      'Uniquement de ses parents',
      'Uniquement d’un éducateur PJJ',
    ],
    answer: 'D’un avocat',
    explanation:
        'L’assistance par un avocat est un principe général de la procédure applicable aux mineurs.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'CJPM — Droits spécifiques',
    question: 'La publicité des audiences concernant un mineur est :',
    options: [
      'Intégrale comme pour les majeurs',
      'Restreinte afin de protéger l’identité du mineur',
      'Obligatoirement retransmise à la télévision',
    ],
    answer: 'Restreinte afin de protéger l’identité du mineur',
    explanation:
        'L’article L. 13-3 CJPM pose le principe de la publicité restreinte et l’interdiction d’identifier le mineur.',
    difficulty: 'Facile',
  ),

  // INSTRUCTION — JUGE D’INSTRUCTION
  QuizQuestion(
    category: 'CJPM — Instruction',
    question: 'Les crimes et délits reprochés à un mineur sont instruits par :',
    options: [
      'Un juge d’instruction spécialement chargé des affaires de mineurs',
      'N’importe quel juge d’instruction sans spécialisation',
      'Le juge administratif',
    ],
    answer: 'Un juge d’instruction spécialement chargé des affaires de mineurs',
    explanation:
        'Le CJPM prévoit un juge d’instruction désigné spécialement par le premier président de la cour d’appel.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'CJPM — Ouverture d’information',
    question:
        'En matière criminelle, pour les mineurs, l’information préalable :',
    options: ['Est obligatoire', 'Est facultative', 'N’existe pas'],
    answer: 'Est obligatoire',
    explanation:
        'L’article L. 423-3 CJPM rend l’information obligatoire en matière criminelle.',
    difficulty: 'Facile',
  ),

  // RÉTENTION ET MANDATS — GROS PRINCIPES
  QuizQuestion(
    category: 'CJPM — Rétention (mandats)',
    question: 'Un mineur peut être placé en rétention dans le cadre :',
    options: [
      'D’un mandat d’amener ou d’arrêt, ou d’un mandat d’arrêt européen',
      'Uniquement d’une perquisition',
      'Uniquement d’une simple convocation',
    ],
    answer: 'D’un mandat d’amener ou d’arrêt, ou d’un mandat d’arrêt européen',
    explanation:
        'La rétention peut intervenir lors de l’exécution de ces mandats.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'CJPM — Rétention (droits)',
    question:
        'Lorsqu’un mineur est placé en rétention dans le cadre d’un mandat, l’enregistrement audiovisuel de ses auditions :',
    options: [
      'Est obligatoire',
      'Est interdit',
      'Est laissé à la libre appréciation de l’OPJ',
    ],
    answer: 'Est obligatoire',
    explanation:
        'Le renvoi aux articles sur la retenue/garde à vue rend obligatoire l’enregistrement audiovisuel des auditions de mineurs.',
    difficulty: 'Facile',
  ),

  // =====================================================
  // NIVEAU 2 — MOYEN
  // =====================================================

  // DISCERNEMENT — APPRÉCIATION
  QuizQuestion(
    category: 'CJPM — Discernement (Moyen)',
    question:
        'La capacité ou l’absence de discernement d’un mineur peut être établie à partir :',
    options: [
      'Uniquement d’un examen psychiatrique',
      'Des déclarations du mineur et de son entourage, des éléments d’enquête, des circonstances des faits, des antécédents et des expertises éventuelles',
      'Uniquement de son casier judiciaire',
    ],
    answer:
        'Des déclarations du mineur et de son entourage, des éléments d’enquête, des circonstances des faits, des antécédents et des expertises éventuelles',
    explanation:
        'L’article R. 11-1 CJPM cite plusieurs sources pour apprécier le discernement.',
    difficulty: 'Moyen',
  ),

  // SPÉCIALISATION DES ACTEURS
  QuizQuestion(
    category: 'CJPM — Juridictions spécialisées (Moyen)',
    question:
        'Parmi ces juridictions, laquelle n’intervient PAS comme juridiction spécialisée pour les mineurs ?',
    options: [
      'Le tribunal pour enfants',
      'La chambre spéciale des mineurs',
      'La cour d’assises de droit commun sans composition spéciale',
    ],
    answer: 'La cour d’assises de droit commun sans composition spéciale',
    explanation:
        'Les crimes de mineurs relèvent de la cour d’assises des mineurs, où siègent des juges des enfants comme assesseurs.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'CJPM — PJJ',
    question:
        'La mise en œuvre des décisions prises en application du CJPM est confiée principalement :',
    options: [
      'Aux services et établissements de la Protection judiciaire de la jeunesse (PJJ)',
      'Aux services municipaux',
      'À la police municipale',
    ],
    answer:
        'Aux services et établissements de la Protection judiciaire de la jeunesse (PJJ)',
    explanation:
        'La PJJ est l’acteur central de la mise en œuvre des mesures éducatives et de suivi.',
    difficulty: 'Moyen',
  ),

  // DROITS SPÉCIFIQUES — AVOCAT / INFO
  QuizQuestion(
    category: 'CJPM — Avocat (Moyen)',
    question: 'S’agissant de l’avocat du mineur, le CJPM prévoit que :',
    options: [
      'Un avocat différent doit intervenir à chaque étape',
      'Le même avocat doit, dans la mesure du possible, suivre le mineur à chaque étape de la procédure',
      'L’avocat n’intervient qu’en audience',
    ],
    answer:
        'Le même avocat doit, dans la mesure du possible, suivre le mineur à chaque étape de la procédure',
    explanation:
        'Cette continuité permet une meilleure compréhension de la situation du mineur et une défense plus cohérente.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'CJPM — Information',
    question: 'La notification des droits au mineur doit être faite :',
    options: [
      'Dans un langage juridique complexe',
      'Dans des termes simples et accessibles',
      'Uniquement à l’avocat',
    ],
    answer: 'Dans des termes simples et accessibles',
    explanation:
        'L’article D. 12-2 CJPM impose une information adaptée au niveau de compréhension du mineur.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'CJPM — Représentants légaux',
    question: 'Le CJPM impose que les représentants légaux :',
    options: [
      'Ne reçoivent aucune information pour préserver le secret',
      'Reçoivent les mêmes informations que celles communiquées au mineur',
      'Ne soient informés qu’en cas de condamnation',
    ],
    answer:
        'Reçoivent les mêmes informations que celles communiquées au mineur',
    explanation:
        'L’article L. 12-5 CJPM consacre ce principe d’information parallèle.',
    difficulty: 'Moyen',
  ),

  // INSTRUCTION — OUVERTURE & COMPÉTENCE
  QuizQuestion(
    category: 'CJPM — Ouverture d’information (Moyen)',
    question:
        'Pour un délit reproché à un mineur, l’ouverture d’une information :',
    options: ['Est obligatoire', 'Est facultative', 'Est interdite'],
    answer: 'Est facultative',
    explanation:
        'L’article L. 423-2 CJPM précise le caractère facultatif en matière délictuelle et contraventions de 5ᵉ classe.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'CJPM — Compétence territoriale',
    question:
        'L’information est ouverte auprès du tribunal judiciaire siège d’un tribunal pour enfants compétent notamment en fonction :',
    options: [
      'Uniquement du lieu de l’infraction',
      'Du lieu de résidence du mineur ou de ses représentants, du lieu de placement, du lieu de l’infraction ou du lieu où le mineur a été trouvé',
      'Uniquement du lieu de naissance du mineur',
    ],
    answer:
        'Du lieu de résidence du mineur ou de ses représentants, du lieu de placement, du lieu de l’infraction ou du lieu où le mineur a été trouvé',
    explanation: 'L’article L. 231-1 CJPM énumère ces critères de compétence.',
    difficulty: 'Moyen',
  ),

  // ENQUÊTE DE PERSONNALITÉ & MJIE / MEJP
  QuizQuestion(
    category: 'CJPM — Enquête de personnalité',
    question:
        'L’enquête de personnalité ordonnée par le procureur de la République est réalisée :',
    options: [
      'Par la PJJ, qui recueille des renseignements socio-éducatifs',
      'Par la police municipale',
      'Par un expert comptable',
    ],
    answer: 'Par la PJJ, qui recueille des renseignements socio-éducatifs',
    explanation:
        'Elle vise une évaluation synthétique de la personnalité et de la situation du mineur (art. L. 322-3).',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'CJPM — MJIE',
    question:
        'Le juge d’instruction, lorsqu’il est saisi d’une affaire concernant un mineur, doit :',
    options: [
      'Toujours placer le mineur en détention',
      'Ordonner une mesure judiciaire d’investigation éducative (MJIE)',
      'Renoncer à toute mesure d’investigation',
    ],
    answer: 'Ordonner une mesure judiciaire d’investigation éducative (MJIE)',
    explanation:
        'La MJIE est obligatoire et vise une évaluation approfondie et interdisciplinaire.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'CJPM — MEJP',
    question:
        'La mesure éducative judiciaire provisoire (MEJP) peut comprendre :',
    options: [
      'Uniquement un placement',
      'Quatre modules (insertion, réparation, santé, placement) et diverses obligations et interdictions',
      'Uniquement une amende',
    ],
    answer:
        'Quatre modules (insertion, réparation, santé, placement) et diverses obligations et interdictions',
    explanation:
        'Elle peut combiner plusieurs modules et obligations prévues par l’article L. 112-2 CJPM.',
    difficulty: 'Moyen',
  ),

  // CONTRÔLE JUDICIAIRE — CONDITIONS
  QuizQuestion(
    category: 'CJPM — Contrôle judiciaire (conditions)',
    question:
        'Un mineur de moins de 13 ans peut-il être placé sous contrôle judiciaire ?',
    options: [
      'Oui, dans tous les cas',
      'Non, jamais',
      'Oui, uniquement pour les crimes',
    ],
    answer: 'Non, jamais',
    explanation:
        'Le CJPM interdit le contrôle judiciaire pour les mineurs de moins de 13 ans.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'CJPM — Contrôle judiciaire (conditions)',
    question:
        'Un mineur de moins de 16 ans peut être placé sous contrôle judiciaire notamment s’il :',
    options: [
      'Encourt une peine criminelle ou une peine d’emprisonnement ≥ 7 ans',
      'Encourt seulement une contravention',
      'Encourt une peine d’amende uniquement',
    ],
    answer:
        'Encourt une peine criminelle ou une peine d’emprisonnement ≥ 7 ans',
    explanation:
        'Le texte détaille plusieurs hypothèses, dont l’encours criminel ou une peine ≥ 7 ans.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'CJPM — Contrôle judiciaire (16-18 ans)',
    question:
        'Un mineur d’au moins 16 ans peut être placé sous contrôle judiciaire :',
    options: [
      'Uniquement s’il encourt une peine criminelle',
      'S’il encourt une peine criminelle ou toute peine d’emprisonnement',
      'Uniquement pour les contraventions',
    ],
    answer: 'S’il encourt une peine criminelle ou toute peine d’emprisonnement',
    explanation: 'Les conditions sont plus larges pour les 16-18 ans.',
    difficulty: 'Moyen',
  ),

  // CONTRÔLE JUDICIAIRE — OBLIGATIONS & RÉTENTION
  QuizQuestion(
    category: 'CJPM — Contrôle judiciaire (obligations)',
    question: 'Les obligations du contrôle judiciaire des mineurs sont :',
    options: [
      'Fixées au cas par cas sans texte',
      'Exhaustivement prévues par l’article L. 331-2 CJPM',
      'Fixées par la mairie',
    ],
    answer: 'Exhaustivement prévues par l’article L. 331-2 CJPM',
    explanation:
        'L’article énumère les obligations et interdictions possibles (limites territoriales, scolarité, etc.).',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'CJPM — Contrôle judiciaire (rétention)',
    question:
        'En cas de soupçon de non-respect des obligations du contrôle judiciaire, le mineur peut :',
    options: [
      'Être placé en rétention sur décision d’un OPJ',
      'Être immédiatement condamné',
      'Être interdit de scolarité',
    ],
    answer: 'Être placé en rétention sur décision d’un OPJ',
    explanation:
        'L’article L. 331-7 CJPM prévoit cette rétention, avec des droits spécifiques.',
    difficulty: 'Moyen',
  ),

  // DÉTENTION PROVISOIRE — PRINCIPES
  QuizQuestion(
    category: 'CJPM — Détention provisoire',
    question:
        'Un mineur de moins de 13 ans peut-il être placé en détention provisoire ?',
    options: [
      'Oui, en matière criminelle',
      'Oui, en cas de récidive',
      'Non, jamais',
    ],
    answer: 'Non, jamais',
    explanation:
        'Le CJPM interdit totalement la détention provisoire pour les moins de 13 ans.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'CJPM — Détention provisoire',
    question:
        'En matière criminelle, pour un mineur de moins de 16 ans, la détention provisoire peut être prononcée pour :',
    options: [
      '6 mois renouvelable une fois',
      'Un an renouvelable deux fois',
      '15 jours non renouvelables',
    ],
    answer: '6 mois renouvelable une fois',
    explanation:
        'Le texte fixe des durées différentes selon l’âge et la nature de l’infraction.',
    difficulty: 'Moyen',
  ),

  // CLÔTURE DE L’INSTRUCTION
  QuizQuestion(
    category: 'CJPM — Clôture de l’instruction',
    question:
        'À l’issue de l’instruction, le juge peut renvoyer devant le tribunal pour enfants :',
    options: [
      'Un mineur d’au moins 13 ans pour un délit ou une contravention de 5ᵉ classe',
      'Uniquement les majeurs',
      'Uniquement pour des contraventions des quatre premières classes',
    ],
    answer:
        'Un mineur d’au moins 13 ans pour un délit ou une contravention de 5ᵉ classe',
    explanation:
        'Le tribunal pour enfants est compétent notamment pour les délits des mineurs de 13 ans et plus.',
    difficulty: 'Moyen',
  ),

  // RÉTENTION — DROITS SPÉCIFIQUES
  QuizQuestion(
    category: 'CJPM — Rétention (droits)',
    question:
        'En rétention, l’OPJ doit informer les représentants légaux du mineur :',
    options: [
      'Uniquement en fin de mesure',
      'Dès le début de la rétention',
      'Seulement s’il le souhaite',
    ],
    answer: 'Dès le début de la rétention',
    explanation:
        'L’avis aux représentants légaux est une diligence spécifique obligatoire.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'CJPM — Examen médical',
    question: 'Pour un mineur de moins de 16 ans placé en rétention :',
    options: [
      'L’examen médical est facultatif',
      'Un médecin est désigné d’office pour l’examiner',
      'Seul l’avocat peut demander un examen',
    ],
    answer: 'Un médecin est désigné d’office pour l’examiner',
    explanation:
        'Le procureur ou le juge d’instruction désigne un médecin dès le début de la mesure.',
    difficulty: 'Moyen',
  ),

  // ACCOMPAGNEMENT / ADULTE APPROPRIÉ
  QuizQuestion(
    category: 'CJPM — Accompagnement',
    question:
        'En principe, le mineur a le droit d’être accompagné lors de ses auditions :',
    options: [
      'Par ses représentants légaux si cela est conforme à son intérêt et ne nuit pas à la procédure',
      'Par n’importe quel ami de son âge',
      'Par un journaliste',
    ],
    answer:
        'Par ses représentants légaux si cela est conforme à son intérêt et ne nuit pas à la procédure',
    explanation:
        'Ce droit est prévu à l’article L. 311-1 CJPM, sous réserve de certaines exceptions.',
    difficulty: 'Moyen',
  ),

  // =====================================================
  // NIVEAU 3 — DIFFICILE
  // =====================================================

  // CONTRÔLE JUDICIAIRE — RÉVOCATION
  QuizQuestion(
    category: 'CJPM — Contrôle judiciaire (Difficile)',
    question:
        'La révocation du contrôle judiciaire d’un mineur de 16 à 18 ans n’est possible que si :',
    options: [
      'La violation des obligations est répétée ou d’une particulière gravité ET le simple rappel ou l’aggravation des obligations ne suffit pas à atteindre les objectifs de l’article 144 CPP',
      'Il y a une seule violation mineure',
      'Le juge en décide sans condition',
    ],
    answer:
        'La violation des obligations est répétée ou d’une particulière gravité ET le simple rappel ou l’aggravation des obligations ne suffit pas à atteindre les objectifs de l’article 144 CPP',
    explanation:
        'L’article L. 334-5 CJPM pose ces deux conditions cumulatives.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'CJPM — Contrôle judiciaire (modification)',
    question:
        'La modification ou la mainlevée du contrôle judiciaire d’un mineur peut être décidée :',
    options: [
      'Uniquement à la demande du procureur',
      'Par le juge des enfants ou le juge d’instruction, d’office ou à la demande du mineur, de ses représentants légaux, de la personne en ayant la garde ou du procureur',
      'Uniquement par la cour d’assises des mineurs',
    ],
    answer:
        'Par le juge des enfants ou le juge d’instruction, d’office ou à la demande du mineur, de ses représentants légaux, de la personne en ayant la garde ou du procureur',
    explanation:
        'L’article L. 331-5 détaille les différentes personnes pouvant solliciter la modification ou la mainlevée.',
    difficulty: 'Difficile',
  ),

  // ARSE MINEURS
  QuizQuestion(
    category: 'CJPM — ARSE mineurs',
    question:
        'L’assignation à résidence sous surveillance électronique (ARSE) dans le CJPM :',
    options: [
      'Est possible pour tout mineur',
      'N’est applicable qu’au mineur de plus de 16 ans encourant une peine d’emprisonnement ≥ 3 ans',
      'Ne concerne que les contraventions',
    ],
    answer:
        'N’est applicable qu’au mineur de plus de 16 ans encourant une peine d’emprisonnement ≥ 3 ans',
    explanation:
        'L’article L. 333-1 CJPM renvoie ensuite au régime de l’ARSE des majeurs.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'CJPM — ARSE mineurs',
    question:
        'La vérification de la faisabilité technique de l’ARSE pour un mineur est confiée :',
    options: [
      'À la PJJ',
      'Aux services pénitentiaires d’insertion et de probation (SPIP)',
      'À la mairie',
    ],
    answer: 'À la PJJ',
    explanation:
        'L’article D. 333-3 CJPM confie cette mission au service de la PJJ.',
    difficulty: 'Difficile',
  ),

  // DÉTENTION PROVISOIRE — DURÉES COMPLEXES
  QuizQuestion(
    category: 'CJPM — Détention provisoire (Difficile)',
    question:
        'En matière correctionnelle, pour un mineur de 16 à 18 ans encourant une peine d’emprisonnement supérieure à 7 ans, la détention provisoire peut être prononcée :',
    options: [
      'Pour une durée d’un mois renouvelable une fois',
      'Pour une durée de quatre mois renouvelable deux fois',
      'Uniquement 15 jours non renouvelables',
    ],
    answer: 'Pour une durée de quatre mois renouvelable deux fois',
    explanation:
        'Le CJPM prévoit cette durée maximale, pouvant aller jusqu’à deux ans en matière de terrorisme.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'CJPM — Détention provisoire (terrorisme)',
    question:
        'En matière criminelle de terrorisme, la détention provisoire d’un mineur de 16 à 18 ans peut atteindre :',
    options: ['Un an maximum', 'Deux ans maximum', 'Trois ans maximum'],
    answer: 'Trois ans maximum',
    explanation:
        'Le texte mentionne que la durée peut aller jusqu’à trois ans pour les mineurs de 16 à 18 ans en matière de terrorisme.',
    difficulty: 'Difficile',
  ),

  // CLÔTURE INSTRUCTION — ORIENTATIONS COMPLEXES
  QuizQuestion(
    category: 'CJPM — Clôture instruction (Difficile)',
    question:
        'En cas de crime reproché à un mineur d’au moins 16 ans, le juge d’instruction :',
    options: [
      'Rend une ordonnance de renvoi devant le tribunal pour enfants',
      'Rend une ordonnance de mise en accusation devant la cour d’assises des mineurs',
      'Doit prononcer un non-lieu automatique',
    ],
    answer:
        'Rend une ordonnance de mise en accusation devant la cour d’assises des mineurs',
    explanation:
        'C’est la juridiction compétente pour juger les crimes de mineurs de 16 ans et plus.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'CJPM — Clôture instruction (connexité)',
    question:
        'La cour d’assises des mineurs peut être saisie, en raison de la connexité, de crimes commis par un mineur :',
    options: [
      'Uniquement après sa majorité',
      'Avant ses 16 ans, lorsqu’ils sont connexes à un crime reproché au même mineur après 16 ans',
      'Uniquement pour des faits commis à l’étranger',
    ],
    answer:
        'Avant ses 16 ans, lorsqu’ils sont connexes à un crime reproché au même mineur après 16 ans',
    explanation:
        'Le texte vise la connexité et l’indivisibilité avec un crime reproché au mineur âgé d’au moins 16 ans.',
    difficulty: 'Difficile',
  ),

  // RÉTENTION — AVIS, AVOCAT, MÉDECIN
  QuizQuestion(
    category: 'CJPM — Rétention (Difficile)',
    question:
        'Lorsqu’un mineur de plus de 16 ans est placé en rétention, qui peut demander un examen médical ?',
    options: [
      'Uniquement le mineur',
      'Le mineur lui-même, ses représentants légaux, l’adulte approprié éventuellement prévenu ou son avocat',
      'Uniquement le procureur de la République',
    ],
    answer:
        'Le mineur lui-même, ses représentants légaux, l’adulte approprié éventuellement prévenu ou son avocat',
    explanation:
        'Le CJPM prévoit un large cercle de personnes pouvant solliciter l’examen médical.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'CJPM — Assistance avocat (rétention)',
    question:
        'Si le mineur ou ses représentants légaux n’ont pas désigné d’avocat pour la rétention :',
    options: [
      'La mesure se déroule sans avocat',
      'Le procureur, le juge d’instruction ou l’OPJ saisit le bâtonnier pour qu’il en soit commis un d’office dès le début de la rétention',
      'Le mineur doit se défendre seul',
    ],
    answer:
        'Le procureur, le juge d’instruction ou l’OPJ saisit le bâtonnier pour qu’il en soit commis un d’office dès le début de la rétention',
    explanation:
        'L’assistance par avocat est obligatoire ; un avocat commis d’office doit être désigné si nécessaire.',
    difficulty: 'Difficile',
  ),

  // ACCOMPAGNEMENT — ADULTE APPROPRIÉ / EXCEPTIONS
  QuizQuestion(
    category: 'CJPM — Exceptions accompagnement',
    question:
        'Les représentants légaux peuvent être écartés de l’information et de l’accompagnement du mineur lorsque :',
    options: [
      'L’autorité le décide sans motif',
      'Cela serait contraire à l’intérêt du mineur, impossible malgré des efforts raisonnables, ou de nature à compromettre la procédure (parents impliqués, par exemple)',
      'Le mineur a plus de 14 ans',
    ],
    answer:
        'Cela serait contraire à l’intérêt du mineur, impossible malgré des efforts raisonnables, ou de nature à compromettre la procédure (parents impliqués, par exemple)',
    explanation:
        'L’article L. 311-2 et suivants encadrent strictement ces exceptions.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'CJPM — Adulte approprié',
    question: 'L’adulte approprié désigné pour accompagner le mineur :',
    options: [
      'Dispose de tous les droits des titulaires de l’autorité parentale',
      'Ne dispose pas de l’ensemble de ces droits et ne peut notamment pas choisir l’avocat du mineur',
      'Peut décider seul de la peine',
    ],
    answer:
        'Ne dispose pas de l’ensemble de ces droits et ne peut notamment pas choisir l’avocat du mineur',
    explanation:
        'Son rôle est d’accompagner et d’être informé, mais il n’a pas les prérogatives complètes d’un titulaire de l’autorité parentale.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'CJPM — Administrateur ad hoc',
    question:
        'Si aucun adulte approprié ne peut être désigné parmi les proches du mineur, le procureur, le juge des enfants ou le juge d’instruction :',
    options: [
      'Renonce à tout accompagnement',
      'Désigne un administrateur ad hoc inscrit sur une liste spécifique',
      'Confie cette fonction à un policier',
    ],
    answer: 'Désigne un administrateur ad hoc inscrit sur une liste spécifique',
    explanation:
        'Cette désignation intervient en application des textes renvoyant notamment à l’article 706-51 CPP.',
    difficulty: 'Difficile',
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
    category: 'Mandats de justice — Notions générales',
    question: 'Les mandats de justice sont :',
    options: [
      'Des actes judiciaires écrits ordonnant certaines mesures de contrainte',
      'Des simples convocations téléphoniques',
      'Des décisions administratives du préfet',
    ],
    answer:
        'Des actes judiciaires écrits ordonnant certaines mesures de contrainte',
    explanation:
        'Les mandats de justice sont définis comme des actes judiciaires écrits ordonnant la garde à vue, la comparution, l’arrestation ou la détention d’une personne.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Notions générales',
    question: 'Les mandats de justice peuvent être délivrés :',
    options: [
      'Par tout policier',
      'Uniquement par des magistrats',
      'Par le maire de la commune',
    ],
    answer: 'Uniquement par des magistrats',
    explanation:
        'Le texte précise que les mandats de justice ne peuvent être délivrés que par des magistrats.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Notions générales',
    question:
        'Selon l’article 122 alinéa 1 du C.P.P., combien de types de mandats de justice sont énumérés ?',
    options: ['Trois', 'Quatre', 'Cinq'],
    answer: 'Cinq',
    explanation:
        'L’article 122 al. 1 du C.P.P. énumère cinq types de mandats : recherche, comparution, amener, dépôt et arrêt.',
    difficulty: 'Facile',
  ),

  // =====================================================
  // QUESTIONS SUPPLÉMENTAIRES — NIVEAU 1 (FACILE)
  // =====================================================
  QuizQuestion(
    category: 'Mandats de justice — Notions générales',
    question:
        'Les mandats de justice se trouvent principalement dans le C.P.P. au chapitre consacré :',
    options: [
      'À la garde à vue',
      'Au juge d’instruction',
      'À l’exécution des peines',
    ],
    answer: 'Au juge d’instruction',
    explanation:
        'Les textes qui fixent les règles de forme et de fond des mandats sont situés dans la section consacrée au juge d’instruction.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Notions générales',
    question: 'Les mandats de justice ordonnent notamment :',
    options: [
      'La perquisition des locaux administratifs',
      'La garde à vue, la comparution, l’arrestation ou la détention d’une personne',
      'La saisie des biens immobiliers',
    ],
    answer:
        'La garde à vue, la comparution, l’arrestation ou la détention d’une personne',
    explanation:
        'Leur objet est de contraindre la personne par différents degrés de mesures (recherche, comparution, amener, dépôt, arrêt).',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Principes',
    question: 'Les mandats de justice sont valables :',
    options: [
      'Uniquement dans le ressort du tribunal qui les a décernés',
      'Sur tout le territoire de la République',
      'Uniquement dans le département concerné',
    ],
    answer: 'Sur tout le territoire de la République',
    explanation:
        'Le texte indique que les mandats sont exécutoires sur l’ensemble du territoire de la République.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Forme',
    question: 'Pour être régulier, un mandat doit être :',
    options: [
      'Daté, signé et revêtu du sceau du magistrat',
      'Signé uniquement par le greffier',
      'Non daté mais tamponné par le commissariat',
    ],
    answer: 'Daté, signé et revêtu du sceau du magistrat',
    explanation:
        'Ces mentions formelles sont exigées pour attester de l’authenticité et de la régularité du mandat.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de recherche — Personnes visées',
    question: 'Le mandat de recherche ne peut pas être délivré contre :',
    options: [
      'Le mis en examen',
      'Le témoin assisté',
      'Une personne totalement inconnue et non désignée',
    ],
    answer: 'Une personne totalement inconnue et non désignée',
    explanation:
        'Il doit viser une personne identifiée (mise en examen, témoin assisté ou personne nommément désignée dans un réquisitoire).',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de comparution — Usage',
    question: 'Le mandat de comparution est principalement utilisé :',
    options: [
      'Pour convoquer une personne domiciliée que l’on ne croit pas en fuite',
      'Pour rechercher une personne en cavale',
      'Pour exécuter une peine',
    ],
    answer:
        'Pour convoquer une personne domiciliée que l’on ne croit pas en fuite',
    explanation:
        'C’est l’outil privilégié pour appeler devant le juge une personne que l’on s’attend à voir se présenter.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de comparution — Notification',
    question: 'La notification d’un mandat de comparution peut être faite :',
    options: [
      'À la personne elle-même ou, en son absence, à son domicile',
      'Uniquement en main propre au tribunal',
      'Uniquement par courrier recommandé avec accusé de réception',
    ],
    answer: 'À la personne elle-même ou, en son absence, à son domicile',
    explanation:
        'Le mandat de comparution n’a pas vocation à une diffusion générale comme un mandat d’arrêt.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Objet',
    question: 'L’objectif principal du mandat d’amener est :',
    options: [
      'De rechercher la personne sur l’ensemble du territoire',
      'De conduire immédiatement la personne devant le magistrat',
      'De la maintenir en détention plusieurs mois',
    ],
    answer: 'De conduire immédiatement la personne devant le magistrat',
    explanation:
        'Le mandat d’amener est centré sur la présentation immédiate de la personne devant la justice.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Nature',
    question: 'Le mandat d’arrêt est à la fois :',
    options: [
      'Un simple avis de recherche sans contrainte',
      'Un ordre de recherche et d’arrestation et un titre de détention',
      'Un document purement administratif',
    ],
    answer: 'Un ordre de recherche et d’arrestation et un titre de détention',
    explanation:
        'Il permet l’arrestation de la personne et son éventuelle conduite en maison d’arrêt.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de dépôt — Effet',
    question:
        'La remise de la personne par l’agent au chef d’établissement pénitentiaire en exécution d’un mandat de dépôt :',
    options: [
      'Met fin à toute responsabilité de l’État',
      'Doit donner lieu à une reconnaissance écrite de réception',
      'N’a pas besoin de trace écrite',
    ],
    answer: 'Doit donner lieu à une reconnaissance écrite de réception',
    explanation:
        'L’article 135 al. 2 C.P.P. prévoit que le chef d’établissement délivre une reconnaissance de la remise.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats — Sanctions',
    question:
        'En cas d’irrégularité non substantielle dans la notification d’un mandat, la conséquence la plus probable est :',
    options: [
      'Aucune conséquence',
      'La nullité de l’exécution mais pas du mandat lui-même',
      'La nullité automatique de tout le dossier pénal',
    ],
    answer: 'La nullité de l’exécution mais pas du mandat lui-même',
    explanation:
        'Seules les irrégularités substantielles justifient la nullité du mandat ; les autres peuvent entraîner la nullité de l’exécution.',
    difficulty: 'Facile',
  ),

  // =====================================================
  // QUESTIONS SUPPLÉMENTAIRES — NIVEAU 2 (MOYEN)
  // =====================================================
  QuizQuestion(
    category: 'Mandat de recherche — Exécution',
    question:
        'Lorsqu’un mandat de recherche est exécuté au domicile de la personne recherchée, la perquisition effectuée :',
    options: [
      'Obéit aux règles de l’article 134 C.P.P. et doit respecter les heures légales',
      'Peut se faire de nuit sans condition',
      'Peut viser n’importe quel voisin',
    ],
    answer:
        'Obéit aux règles de l’article 134 C.P.P. et doit respecter les heures légales',
    explanation:
        'La perquisition se fait dans le respect des articles 133 et 134 C.P.P. et des heures légales de perquisition.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de recherche — Enquête préliminaire',
    question:
        'En enquête préliminaire, un mandat de recherche délivré par le procureur de la République :',
    options: [
      'Permet l’arrestation de toute personne se trouvant sur les lieux',
      'Vise une personne déterminée dont on a des raisons plausibles de soupçonner la commission ou la tentative d’une infraction',
      'Ne peut jamais être utilisé',
    ],
    answer:
        'Vise une personne déterminée dont on a des raisons plausibles de soupçonner la commission ou la tentative d’une infraction',
    explanation:
        'L’article 77-4 C.P.P. reprend le mécanisme de l’article 70 pour l’enquête préliminaire.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de comparution — Choix du magistrat',
    question:
        'Pourquoi le juge préfère-t-il souvent décerner un mandat de comparution plutôt qu’une simple convocation ?',
    options: [
      'Parce qu’il n’y a alors aucune garantie de comparution',
      'Parce que le mandat est plus solennel et soumis à des règles précises de notification',
      'Pour pouvoir immédiatement placer en détention la personne',
    ],
    answer:
        'Parce que le mandat est plus solennel et soumis à des règles précises de notification',
    explanation:
        'Le mandat de comparution renforce l’obligation de se présenter devant le magistrat.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Témoins assistés',
    question: 'Le mandat d’amener peut également être délivré à l’encontre :',
    options: [
      'D’un témoin assisté',
      'Du conseil de la personne',
      'D’un juré de cour d’assises',
    ],
    answer: 'D’un témoin assisté',
    explanation:
        'Le texte mentionne que le mandat d’amener peut viser le mis en examen comme le témoin assisté.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Régime horaire',
    question:
        'L’agent chargé de l’exécution d’un mandat d’amener ne peut pénétrer dans le domicile d’un citoyen :',
    options: [
      'Qu’entre 6 heures et 21 heures, sauf dispositions particulières',
      'Qu’entre 8 heures et 18 heures',
      'À n’importe quelle heure sans restriction',
    ],
    answer: 'Qu’entre 6 heures et 21 heures, sauf dispositions particulières',
    explanation:
        'L’article 134 C.P.P. encadre strictement les horaires d’introduction dans un lieu d’habitation.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Rapport écrit',
    question:
        'Lorsque l’agent n’a pas trouvé la personne faisant l’objet d’un mandat d’amener, il doit :',
    options: [
      'Rien faire, le mandat reste valable indéfiniment',
      'Dresser un procès-verbal de perquisition et de recherches infructueuses',
      'Rédiger un simple mot manuscrit sans valeur juridique',
    ],
    answer:
        'Dresser un procès-verbal de perquisition et de recherches infructueuses',
    explanation:
        'L’article 134 C.P.P. impose un procès-verbal lorsque la personne recherchée n’est pas trouvée.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Règlement de l’information',
    question:
        'Après le règlement de l’information, le mandat d’arrêt conserve :',
    options: [
      'Aucune force exécutoire',
      'Sa force exécutoire tant qu’il n’a pas été retiré',
      'Une force limitée aux frontières du département',
    ],
    answer: 'Sa force exécutoire tant qu’il n’a pas été retiré',
    explanation:
        'L’article 179 C.P.P. précise que le mandat d’arrêt conserve sa force après le règlement de l’information.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Personnes condamnées',
    question:
        'Le juge de l’application des peines peut décerner un mandat d’arrêt :',
    options: [
      'Contre une personne condamnée à un suivi socio-judiciaire qui ne respecte pas ses obligations',
      'Uniquement contre un prévenu avant jugement',
      'Uniquement en cas de contravention routière',
    ],
    answer:
        'Contre une personne condamnée à un suivi socio-judiciaire qui ne respecte pas ses obligations',
    explanation:
        'Le texte mentionne cette hypothèse de mandat d’arrêt décerné par le JAP (art. 712-17 ou 763-5 C.P.P. selon les cas).',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de dépôt — Chambre de l’instruction',
    question:
        'La chambre de l’instruction peut décerner un mandat de dépôt ou d’arrêt lorsque :',
    options: [
      'Elle est saisie de l’appel d’une ordonnance du JLD ou du juge d’instruction',
      'Elle statue sur un simple litige civil',
      'Elle examine un recours administratif',
    ],
    answer:
        'Elle est saisie de l’appel d’une ordonnance du JLD ou du juge d’instruction',
    explanation:
        'Dans le cadre de l’appel, la chambre peut ordonner, maintenir ou lever les mandats concernés.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandats — Discipline des magistrats',
    question:
        'Les sanctions disciplinaires contre un juge d’instruction ou un JLD pour irrégularités de mandats :',
    options: [
      'Peuvent être prononcées selon les règles du statut de la magistrature',
      'Sont décidées par les policiers',
      'Sont automatiques dès qu’une nullité est prononcée',
    ],
    answer:
        'Peuvent être prononcées selon les règles du statut de la magistrature',
    explanation:
        'Le statut de la magistrature fixe les règles disciplinaires applicables aux juges.',
    difficulty: 'Moyen',
  ),

  // =====================================================
  // QUESTIONS SUPPLÉMENTAIRES — NIVEAU 3 (DIFFICILE)
  // =====================================================
  QuizQuestion(
    category: 'Mandats — Cas avancés',
    question:
        'Une personne est appréhendée sous mandat d’amener, à plus de 200 km du siège du juge d’instruction mandant. Faute de pouvoir l’interroger immédiatement, le magistrat local :',
    options: [
      'Doit la placer en détention sans délai',
      'Peut la retenir au maximum 24 heures en lui faisant bénéficier des droits de la garde à vue',
      'Doit immédiatement la remettre en liberté sans aucune formalité',
    ],
    answer:
        'Peut la retenir au maximum 24 heures en lui faisant bénéficier des droits de la garde à vue',
    explanation:
        'Les articles 133-1 et suivants organisent cette “retenue” avec les mêmes droits que la garde à vue.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Transfert après mandat d’amener',
    question:
        'Lorsque le JLD prolonge la retenue d’une personne appréhendée hors du ressort du juge d’instruction, le transfert vers la maison d’arrêt désignée sur le mandat doit intervenir :',
    options: [
      'Dans un délai de quatre jours au plus à compter de la notification du mandat, sauf circonstances insurmontables',
      'Sans aucun délai, à la convenance de l’administration',
      'Uniquement si la personne donne son accord écrit',
    ],
    answer:
        'Dans un délai de quatre jours au plus à compter de la notification du mandat, sauf circonstances insurmontables',
    explanation:
        'Ces délais visent à éviter des détentions arbitraires prolongées en simple attente de transfert.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Présentation au JLD',
    question:
        'Lorsqu’une personne recherchée sous mandat d’arrêt est arrêtée à plus de 200 km du siège du magistrat mandant, elle doit être présentée :',
    options: [
      'Au juge d’instruction mandant dans les 6 heures',
      'À un juge ou JLD du ressort de l’arrestation dans les 24 heures',
      'Uniquement au procureur de la République',
    ],
    answer: 'À un juge ou JLD du ressort de l’arrestation dans les 24 heures',
    explanation:
        'Les articles 127 et 133 C.P.P. prévoient cette présentation devant un magistrat local avant le transfert.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Vidéo-audience',
    question:
        'Selon l’article 135-2 C.P.P., le recours à la visioconférence pour l’audition d’une personne détenue sous mandat d’arrêt :',
    options: [
      'Est toujours obligatoire',
      'Est possible mais suppose que la personne ne s’y oppose pas lorsqu’elle encourt une peine criminelle',
      'Ne peut jamais être utilisé',
    ],
    answer:
        'Est possible mais suppose que la personne ne s’y oppose pas lorsqu’elle encourt une peine criminelle',
    explanation:
        'Le texte encadre l’usage de la visioconférence pour respecter les droits de la défense.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Personne en fuite',
    question:
        'Les recherches d’une personne en fuite faisant l’objet d’un mandat d’arrêt peuvent être confiées :',
    options: [
      'À des services spécialisés de police judiciaire, y compris pour la surveillance téléphonique',
      'Uniquement à la police municipale',
      'Uniquement au procureur général',
    ],
    answer:
        'À des services spécialisés de police judiciaire, y compris pour la surveillance téléphonique',
    explanation:
        'Les textes prévoient que des services spécialisés peuvent être requis, y compris via les moyens modernes de télécommunications (art. 74-2 C.P.P. et s.).',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat de dépôt — Exécution',
    question:
        'En exécution d’un mandat de dépôt, la notification de l’ordonnance de placement en détention provisoire :',
    options: [
      'Vaut notification du mandat de dépôt lui-même',
      'Doit être distincte et répétée au moment de l’arrivée à la maison d’arrêt',
      'N’a aucune importance juridique',
    ],
    answer: 'Vaut notification du mandat de dépôt lui-même',
    explanation:
        'La loi prévoit que la notification de l’ordonnance de placement vaut notification du mandat de dépôt.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Nullité et droits de la défense',
    question:
        'Parmi les irrégularités suivantes, laquelle est la plus susceptible d’entraîner la nullité du mandat lui-même ?',
    options: [
      'Une simple faute d’orthographe dans le texte du mandat',
      'L’absence totale de mention de la qualification juridique des faits pour un mandat d’arrêt',
      'Un léger retard de quelques minutes dans la notification',
    ],
    answer:
        'L’absence totale de mention de la qualification juridique des faits pour un mandat d’arrêt',
    explanation:
        'Cette omission touche aux mentions substantielles exigées par l’article 123 C.P.P. et peut porter atteinte aux droits de la défense.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Responsabilité du greffier',
    question:
        'Le greffier est responsable de la régularité formelle des mandats. S’il laisse partir un mandat sans sceau ni signature :',
    options: [
      'Il commet une faute susceptible d’engager sa responsabilité disciplinaire',
      'Cela n’a aucune conséquence',
      'La responsabilité incombe uniquement au policier qui l’exécute',
    ],
    answer:
        'Il commet une faute susceptible d’engager sa responsabilité disciplinaire',
    explanation:
        'Le greffier doit veiller à la régularité externe de l’acte ; sa négligence peut faire l’objet de sanctions internes.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Détention arbitraire et responsabilité',
    question:
        'Un juge d’instruction laisse volontairement une personne en détention au-delà des délais légaux après un mandat d’amener. Il peut être poursuivi sur le fondement :',
    options: [
      'Des articles 432-4 à 432-6 du Code pénal, relatifs à la détention arbitraire',
      'Uniquement pour négligence civile',
      'D’aucun texte spécifique',
    ],
    answer:
        'Des articles 432-4 à 432-6 du Code pénal, relatifs à la détention arbitraire',
    explanation:
        'L’article 126 C.P.P. renvoie explicitement à ces dispositions pour sanctionner les détentions arbitraires.',
    difficulty: 'Difficile',
  ),

  // =====================================================
  // SALVE SUPPLÉMENTAIRE — NIVEAU 1 (FACILE)
  // =====================================================
  QuizQuestion(
    category: 'Mandats de justice — Notions générales',
    question:
        'Quel article du C.P.P. énumère les cinq types de mandats de justice ?',
    options: ['Article 122', 'Article 63-1', 'Article 706-54'],
    answer: 'Article 122',
    explanation:
        'L’article 122 alinéa 1 du C.P.P. énumère les cinq mandats : recherche, comparution, amener, dépôt et arrêt.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Notions générales',
    question: 'Les mandats de justice sont principalement utilisés par :',
    options: [
      'Le juge d’instruction',
      'Le juge de l’application des peines exclusivement',
      'Le préfet',
    ],
    answer: 'Le juge d’instruction',
    explanation:
        'Le texte précise qu’ils sont principalement utilisés par le juge d’instruction, même si d’autres juridictions peuvent en décerner.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Non-délégation',
    question:
        'Pourquoi dit-on que les mandats de justice sont des actes « incommunicables » ?',
    options: [
      'Parce qu’on ne peut pas les montrer au mis en examen',
      'Parce que le pouvoir de les délivrer ne peut pas être délégué par le magistrat',
      'Parce qu’ils ne sont jamais versés au dossier',
    ],
    answer:
        'Parce que le pouvoir de les délivrer ne peut pas être délégué par le magistrat',
    explanation:
        'Le juge d’instruction ne peut pas transmettre à un autre la compétence de décerner un mandat dans le cadre d’une commission rogatoire.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats — Contenu minimal',
    question: 'Pour être valable, tout mandat doit au minimum contenir :',
    options: [
      'Le nom du procureur général',
      'L’identité de la personne visée et la signature du magistrat',
      'Le numéro de matricule de l’OPJ',
    ],
    answer: 'L’identité de la personne visée et la signature du magistrat',
    explanation:
        'L’article 123 al. 1 exige l’identité de la personne et la signature du magistrat, le tout revêtu du sceau.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats — Types',
    question:
        'Lequel de ces documents correspond à un mandat de contrainte et non à une simple convocation ?',
    options: [
      'Mandat de comparution',
      'Convocation simple par officier de police judiciaire',
      'Invitation à se présenter à la mairie',
    ],
    answer: 'Mandat de comparution',
    explanation:
        'Le mandat de comparution est un acte judiciaire contraignant, à la différence d’une simple convocation.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de recherche — Finalité',
    question: 'La finalité d’un mandat de recherche est de :',
    options: [
      'Reporter une audience',
      'Rechercher une personne et la placer en garde à vue',
      'Confisquer les biens d’une personne',
    ],
    answer: 'Rechercher une personne et la placer en garde à vue',
    explanation:
        'Le mandat de recherche ordonne la recherche de la personne et son placement éventuel en garde à vue.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de comparution — Sanction du défaut de présentation',
    question:
        'Si la personne ne se présente pas à la date indiquée sur un mandat de comparution, le juge peut :',
    options: [
      'Ne rien faire',
      'Dresser un procès-verbal de non-comparution et décerner un mandat d’amener',
      'La déclarer immédiatement coupable',
    ],
    answer:
        'Dresser un procès-verbal de non-comparution et décerner un mandat d’amener',
    explanation:
        'Le mandat de comparution peut être suivi d’un mandat d’amener en cas de non-présentation.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Personne visée',
    question: 'Le mandat d’amener est destiné :',
    options: [
      'À une personne que l’on veut entendre comme mis en examen ou témoin assisté',
      'Uniquement à un juré de cour d’assises',
      'À un simple témoin de moralité',
    ],
    answer:
        'À une personne que l’on veut entendre comme mis en examen ou témoin assisté',
    explanation:
        'Il vise une personne susceptible d’être impliquée dans les faits et que le juge veut entendre.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Personne en fuite',
    question: 'Le mandat d’arrêt est particulièrement adapté lorsque :',
    options: [
      'La personne est domiciliée et se présente spontanément',
      'La personne est en fuite ou se trouve à l’étranger',
      'La procédure concerne une simple contravention',
    ],
    answer: 'La personne est en fuite ou se trouve à l’étranger',
    explanation:
        'C’est un titre de recherche et de détention pour les personnes qui se soustraient à la justice.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de dépôt — Qualité',
    question: 'Le mandat de dépôt permet :',
    options: [
      'De placer ou maintenir une personne en détention provisoire',
      'D’ordonner une simple garde à vue',
      'De prononcer une peine définitive',
    ],
    answer: 'De placer ou maintenir une personne en détention provisoire',
    explanation:
        'Il s’agit du titre de détention provisoire décerné par le juge ou le tribunal.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats — Territoire',
    question: 'Les mandats de justice sont exécutoires :',
    options: [
      'Uniquement dans la ville où ils sont émis',
      'Dans toute la France, y compris outre-mer',
      'Uniquement dans le ressort de la cour d’appel',
    ],
    answer: 'Dans toute la France, y compris outre-mer',
    explanation:
        'Ils ont vocation à s’appliquer sur l’ensemble du territoire de la République.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats — Greffier',
    question: 'Le greffier, en matière de mandats, doit notamment vérifier :',
    options: [
      'Que le mandat est signé, daté, revêtu du sceau et comporte les mentions obligatoires',
      'Que la personne est bien coupable',
      'Que le policier est disponible',
    ],
    answer:
        'Que le mandat est signé, daté, revêtu du sceau et comporte les mentions obligatoires',
    explanation:
        'C’est lui qui est responsable de la régularité formelle de l’acte.',
    difficulty: 'Facile',
  ),

  // =====================================================
  // SALVE SUPPLÉMENTAIRE — NIVEAU 2 (MOYEN)
  // =====================================================
  QuizQuestion(
    category: 'Mandat de recherche — Notification',
    question:
        'Lorsqu’une personne détenue pour une autre cause fait l’objet d’un mandat de recherche, la notification du mandat :',
    options: [
      'Doit lui être faite au plus tard lors de sa remise en liberté',
      'Est inutile car elle est déjà détenue',
      'Est remplacée par un simple appel téléphonique',
    ],
    answer: 'Doit lui être faite au plus tard lors de sa remise en liberté',
    explanation:
        'L’article 123 C.P.P. prévoit une notification même lorsqu’une personne est déjà détenue pour une autre cause.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de recherche — Effets selon l’auteur',
    question:
        'Lorsque le mandat de recherche est délivré par le procureur de la République et que la personne n’est pas découverte :',
    options: [
      'Le mandat prend fin automatiquement sans suite',
      'Le procureur peut requérir l’ouverture d’une information contre personne non dénommée',
      'La personne est déclarée coupable par défaut',
    ],
    answer:
        'Le procureur peut requérir l’ouverture d’une information contre personne non dénommée',
    explanation:
        'Le mandat de recherche peut déboucher sur l’ouverture d’une information si la personne n’est pas retrouvée.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de comparution — Public visé',
    question:
        'Pourquoi le mandat de comparution ne vise-t-il en principe pas les personnes supposées en fuite ?',
    options: [
      'Parce qu’il n’est pas exécutoire',
      'Parce qu’il repose sur l’idée que la personne est domiciliée et ne cherche pas à se soustraire à la justice',
      'Parce qu’il n’est possible que pour les témoins',
    ],
    answer:
        'Parce qu’il repose sur l’idée que la personne est domiciliée et ne cherche pas à se soustraire à la justice',
    explanation:
        'En cas de crainte de fuite, le juge optera plutôt pour un mandat d’amener ou d’arrêt.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de comparution — Exécution',
    question:
        'Dans la pratique, lorsque la personne visée par un mandat de comparution est introuvable à l’adresse indiquée :',
    options: [
      'Le mandat est réputé exécuté',
      'L’agent dresse un procès-verbal d’impossibilité de notification',
      'La personne est immédiatement recherchée sur tout le territoire par mandat d’arrêt',
    ],
    answer: 'L’agent dresse un procès-verbal d’impossibilité de notification',
    explanation:
        'Ce PV permet au magistrat de décider ensuite d’un éventuel mandat d’amener ou d’arrêt.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Conversion depuis un mandat de comparution',
    question: 'Le plus souvent, un mandat d’amener est décerné :',
    options: [
      'Directement, sans autre acte préalable',
      'Après l’échec d’un mandat de comparution ou d’une convocation restée sans effet',
      'Exclusivement à la demande de la victime',
    ],
    answer:
        'Après l’échec d’un mandat de comparution ou d’une convocation restée sans effet',
    explanation:
        'C’est la logique graduée des mesures de contrainte : comparution, puis amener, puis éventuellement arrestation.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Force utilisée',
    question:
        'L’article 134 du C.P.P. précise que la force utilisée pour exécuter un mandat d’amener :',
    options: [
      'Peut être illimitée si nécessaire',
      'Doit être strictement proportionnée et la plus douce possible pour assurer l’exécution',
      'Est laissée à l’appréciation libre de l’OPJ sans contrôle',
    ],
    answer:
        'Doit être strictement proportionnée et la plus douce possible pour assurer l’exécution',
    explanation:
        'L’usage de la force est encadré pour respecter les droits fondamentaux.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Formules d’arrestation',
    question:
        'Les formalités d’arrestation applicables lors de l’exécution d’un mandat d’arrêt (article 133 C.P.P.) imposent notamment :',
    options: [
      'La lecture intégrale du C.P.P.',
      'L’information de la personne sur l’existence du mandat et la nature des faits reprochés',
      'L’obligation de menotter la personne quelles que soient les circonstances',
    ],
    answer:
        'L’information de la personne sur l’existence du mandat et la nature des faits reprochés',
    explanation:
        'La personne doit savoir pourquoi elle est arrêtée et sur quel titre.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Maintien en rétention',
    question:
        'Lorsqu’une personne arrêtée sous mandat d’arrêt est retenue 24 heures avant d’être conduite devant le juge :',
    options: [
      'Elle ne bénéficie d’aucun droit spécifique',
      'Elle bénéficie des droits de la garde à vue (médecin, avocat, information d’un proche)',
      'Elle doit obligatoirement être mise en isolement',
    ],
    answer:
        'Elle bénéficie des droits de la garde à vue (médecin, avocat, information d’un proche)',
    explanation:
        'L’article 133-1 renvoie aux garanties de la garde à vue pendant cette période.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de dépôt — Notification',
    question:
        'Pourquoi dit-on que la notification de l’ordonnance de placement en détention provisoire vaut notification du mandat de dépôt ?',
    options: [
      'Pour éviter une double notification inutile',
      'Parce que le mandat de dépôt n’a pas à être lu à la personne',
      'Parce que la personne n’a pas le droit de prendre connaissance de la décision',
    ],
    answer: 'Pour éviter une double notification inutile',
    explanation:
        'La décision de placement en détention et le mandat de dépôt sont liés, la loi simplifie la procédure en fusionnant les notifications.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandats — Nullité et défense',
    question:
        'Une irrégularité dans la délivrance d’un mandat n’entraîne nullité qu’à condition :',
    options: [
      'Qu’elle soit substantielle et ait porté atteinte aux droits de la défense',
      'Qu’elle soit simplement mentionnée par l’avocat',
      'Qu’elle ait été commise par un policier',
    ],
    answer:
        'Qu’elle soit substantielle et ait porté atteinte aux droits de la défense',
    explanation:
        'La jurisprudence conditionne la nullité à une atteinte réelle aux droits de la défense.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandats — Discipline et pénal',
    question:
        'En cas de détention arbitraire liée à un dépassement injustifié des délais de présentation après mandat d’amener :',
    options: [
      'Seule la responsabilité disciplinaire peut être engagée',
      'La responsabilité pénale des magistrats ou fonctionnaires peut être engagée sur le fondement des articles 432-4 à 432-6 du Code pénal',
      'Aucune responsabilité n’est possible',
    ],
    answer:
        'La responsabilité pénale des magistrats ou fonctionnaires peut être engagée sur le fondement des articles 432-4 à 432-6 du Code pénal',
    explanation:
        'L’article 126 C.P.P. vise expressément cette hypothèse de détention arbitraire.',
    difficulty: 'Moyen',
  ),

  // =====================================================
  // SALVE SUPPLÉMENTAIRE — NIVEAU 3 (DIFFICILE)
  // =====================================================
  QuizQuestion(
    category: 'Mandats — Cas pratiques complexes',
    question:
        'Un mandat d’arrêt a été délivré, mais l’acte ne mentionne pas la qualification juridique des faits alors que la loi l’exige. La personne arrêtée soulève l’irrégularité :',
    options: [
      'La nullité du mandat est envisageable car une mention substantielle fait défaut',
      'La nullité est impossible car il s’agit d’un simple oubli',
      'Le juge peut corriger oralement le mandat sans conséquence',
    ],
    answer:
        'La nullité du mandat est envisageable car une mention substantielle fait défaut',
    explanation:
        'L’absence de qualification juridique peut porter atteinte au droit d’être informé des faits reprochés, ce qui est substantiel.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Distance et transferts',
    question:
        'Une personne arrêtée à plus de 200 km du siège du juge d’instruction mandant reste 48 heures avant d’être présentée au JLD local. Quel est le risque principal ?',
    options: [
      'Aucun, le délai est purement indicatif',
      'Une contestation pour non-respect des délais prévus aux articles 127 et 133 C.P.P., pouvant entraîner une nullité de la rétention',
      'La nullité automatique du jugement à venir',
    ],
    answer:
        'Une contestation pour non-respect des délais prévus aux articles 127 et 133 C.P.P., pouvant entraîner une nullité de la rétention',
    explanation:
        'La loi encadre strictement les délais pour éviter les détentions arbitraires prolongées.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Interaction avec la garde à vue',
    question:
        'Une personne est arrêtée sous mandat de recherche et immédiatement placée en garde à vue. Pour être régulière, cette garde à vue :',
    options: [
      'Doit respecter les conditions de la garde à vue (indices, finalité, droits) en plus du mandat',
      'N’a plus aucune règle puisque le mandat existe',
      'Dispense l’OPJ de notifier les droits à la personne',
    ],
    answer:
        'Doit respecter les conditions de la garde à vue (indices, finalité, droits) en plus du mandat',
    explanation:
        'Le mandat ne dispense pas du respect intégral du régime de la garde à vue.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Recours et indemnisation',
    question:
        'Une personne obtient devant le premier président de la cour d’appel une indemnité pour détention irrégulière consécutive à un mandat d’arrêt. L’État décide de se retourner contre le dénonciateur de mauvaise foi. Ce recours :',
    options: [
      'Est prévu par les textes en cas de dénonciation mensongère ou de faux témoignage',
      'Est impossible car l’État ne peut jamais agir contre un particulier',
      'Annule automatiquement l’indemnité accordée',
    ],
    answer:
        'Est prévu par les textes en cas de dénonciation mensongère ou de faux témoignage',
    explanation:
        'Le texte mentionne explicitement que l’État dispose d’un recours contre le dénonciateur de mauvaise foi ou le faux témoin.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Hiérarchie des mesures',
    question:
        'Sur le plan théorique, comment peut-on classer les mandats de justice par intensité croissante de contrainte ?',
    options: [
      'Comparution → recherche → amener → dépôt → arrêt',
      'Recherche → comparution → amener → arrêt → dépôt',
      'Comparution → amener → arrestation/dépôt/arrêt (titres de détention)',
    ],
    answer:
        'Comparution → amener → arrestation/dépôt/arrêt (titres de détention)',
    explanation:
        'On passe de la convocation contrainte (comparution), à l’amenée forcée, puis aux titres de détention (dépôt/arrêt).',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Choix de l’outil procédural',
    question:
        'Dans une information criminelle, le juge d’instruction souhaite interroger un mis en examen qui reste au domicile mais refuse de se déplacer. Quel mandat est, en principe, le plus adapté ?',
    options: ['Mandat de comparution', 'Mandat d’amener', 'Mandat de dépôt'],
    answer: 'Mandat d’amener',
    explanation:
        'Le juge sait où se trouve la personne mais doit la faire conduire devant lui de manière contrainte.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Publicité et diffusion',
    question:
        'En matière de sécurité intérieure, certains mandats d’amener ou d’arrêt peuvent être inscrits au fichier des personnes recherchées. Cette inscription :',
    options: [
      'Transforme automatiquement le mandat en peine',
      'Permet la diffusion nationale mais ne change pas la nature du mandat lui-même',
      'Supprime les droits de la défense',
    ],
    answer:
        'Permet la diffusion nationale mais ne change pas la nature du mandat lui-même',
    explanation:
        'Il s’agit d’un outil d’exécution, pas d’une modification de la nature juridique de l’acte.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Cumul des irrégularités',
    question:
        'Plusieurs irrégularités mineures affectent un mandat (erreur de date, coquilles dans l’adresse) mais aucune n’a porté atteinte aux droits de la défense. La défense invoque la nullité du mandat :',
    options: [
      'La nullité sera probablement rejetée faute d’atteinte aux droits de la défense',
      'La nullité doit être prononcée automatiquement',
      'La nullité entraîne d’office la relaxe au fond',
    ],
    answer:
        'La nullité sera probablement rejetée faute d’atteinte aux droits de la défense',
    explanation:
        'La jurisprudence se montre stricte : l’irrégularité doit être substantielle et porter atteinte à la défense.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Interaction avec le contrôle judiciaire',
    question:
        'Une personne ne respecte pas de manière répétée les obligations de son contrôle judiciaire. Le juge d’instruction décide de la faire arrêter pour l’entendre sur ces manquements. L’outil procédural logique est :',
    options: [
      'Un mandat d’amener',
      'Un mandat de comparution',
      'Un simple avertissement écrit sans titre',
    ],
    answer: 'Un mandat d’amener',
    explanation:
        'Le juge souhaite l’entendre immédiatement sous contrainte, ce qui correspond à la logique du mandat d’amener.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Équilibre libertés / ordre public',
    question:
        'Sur le plan théorique, le recours aux mandats de justice s’analyse comme :',
    options: [
      'Une atteinte injustifiée aux libertés individuelles',
      'Un équilibre entre la nécessité de l’enquête et la protection des libertés, sous le contrôle de la loi et du juge',
      'Une mesure purement administrative',
    ],
    answer:
        'Un équilibre entre la nécessité de l’enquête et la protection des libertés, sous le contrôle de la loi et du juge',
    explanation:
        'Les mandats encadrent les atteintes à la liberté individuelle par des règles strictes de forme, de fond et de contrôle juridictionnel.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Recours et indemnisation',
    question:
        'Une personne a subi une détention jugée irrégulière à la suite d’un mandat. Elle obtient une indemnisation. L’État :',
    options: [
      'Ne peut jamais agir contre quiconque',
      'Peut exercer un recours contre le dénonciateur de mauvaise foi ou le faux témoin',
      'Doit indemniser également le dénonciateur',
    ],
    answer:
        'Peut exercer un recours contre le dénonciateur de mauvaise foi ou le faux témoin',
    explanation:
        'La loi autorise l’État à se retourner contre l’auteur de la dénonciation mensongère ayant provoqué la détention.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Notions générales',
    question:
        'Parmi ces propositions, lequel N’EST PAS un type de mandat de justice ?',
    options: [
      'Mandat de recherche',
      'Mandat de dépôt',
      'Mandat de contrôle judiciaire',
    ],
    answer: 'Mandat de contrôle judiciaire',
    explanation:
        'Les cinq mandats sont : recherche, comparution, amener, dépôt, arrêt. Il n’existe pas de “mandat de contrôle judiciaire”.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Notions générales',
    question:
        'Les mandats de justice sont des actes incommunicables, c’est-à-dire :',
    options: [
      'Qu’ils ne peuvent pas être montrés à la personne concernée',
      'Qu’ils sont non délégables, le magistrat ne peut pas déléguer son pouvoir de les décerner',
      'Qu’ils ne sont pas versés au dossier de la procédure',
    ],
    answer:
        'Qu’ils sont non délégables, le magistrat ne peut pas déléguer son pouvoir de les décerner',
    explanation:
        'Le texte précise que les mandats sont des actes incommunicables au sens où le pouvoir de les décerner ne peut être délégué.',
    difficulty: 'Facile',
  ),

  // PRINCIPES GÉNÉRAUX — FORME
  QuizQuestion(
    category: 'Mandats de justice — Principes généraux',
    question:
        'Tout mandat doit préciser l’identité de la personne à l’encontre de laquelle il est décerné et :',
    options: [
      'Être signé et revêtu du sceau du magistrat qui le délivre',
      'Être validé par le préfet',
      'Être enregistré au registre du commerce',
    ],
    answer: 'Être signé et revêtu du sceau du magistrat qui le délivre',
    explanation:
        'L’article 123 alinéa 1 du C.P.P. impose que le mandat soit signé par le magistrat et revêtu de son sceau.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Principes généraux',
    question:
        'Les mandats d’amener, de dépôt, d’arrêt ou de recherche doivent mentionner :',
    options: [
      'La nature des faits imputés, leur qualification juridique et les textes applicables',
      'Uniquement le nom de la victime',
      'Uniquement la date de la prochaine audience',
    ],
    answer:
        'La nature des faits imputés, leur qualification juridique et les textes applicables',
    explanation:
        'Pour ces mandats, la loi exige l’indication des faits, de leur qualification et des textes pénaux applicables.',
    difficulty: 'Facile',
  ),

  // MANDAT DE RECHERCHE — DÉFINITION
  QuizQuestion(
    category: 'Mandat de recherche — Notions de base',
    question: 'Le mandat de recherche est défini comme :',
    options: [
      'Un ordre de conduire immédiatement une personne devant le juge',
      'Un ordre donné à la force publique de rechercher une personne et de la placer en garde à vue',
      'Un ordre de convoquer un témoin à une audience',
    ],
    answer:
        'Un ordre donné à la force publique de rechercher une personne et de la placer en garde à vue',
    explanation:
        'Le mandat de recherche ordonne de rechercher la personne et de la placer en garde à vue (art. 122 al. 2 C.P.P.).',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de recherche — Personnes visées',
    question: 'Le mandat de recherche peut être délivré contre :',
    options: [
      'Une personne mise en examen',
      'Un simple passant sans aucune raison',
      'Uniquement un témoin',
    ],
    answer: 'Une personne mise en examen',
    explanation:
        'Il peut viser le mis en examen, le témoin assisté ou la personne visée par un réquisitoire nominatif.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de recherche — Personnes visées',
    question:
        'Outre le mis en examen, le mandat de recherche peut être délivré contre :',
    options: ['Le témoin assisté', 'L’avocat de la personne', 'Le greffier'],
    answer: 'Le témoin assisté',
    explanation:
        'Le texte indique qu’il peut viser le mis en examen, le témoin assisté ou la personne visée par un réquisitoire nominatif.',
    difficulty: 'Facile',
  ),

  // MANDAT DE COMPARUTION — DÉFINITION
  QuizQuestion(
    category: 'Mandat de comparution — Notions de base',
    question: 'Le mandat de comparution a pour objet de :',
    options: [
      'Faire rechercher une personne en fuite',
      'Faire comparaître une personne devant le juge à une date et une heure indiquées',
      'Placer immédiatement la personne en détention',
    ],
    answer:
        'Faire comparaître une personne devant le juge à une date et une heure indiquées',
    explanation:
        'Le mandat de comparution ordonne à la personne de se présenter devant le juge à la date et l’heure fixées (art. 122 al. 4 C.P.P.).',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de comparution — Public visé',
    question:
        'Le mandat de comparution est surtout utilisé à l’égard de personnes :',
    options: [
      'Dont on suppose qu’elles sont en fuite',
      'Domiciliées et dont on ne craint pas la fuite',
      'Déjà détenues dans un autre établissement',
    ],
    answer: 'Domiciliées et dont on ne craint pas la fuite',
    explanation:
        'Il est utilisé pour des personnes domiciliées que l’on ne suppose pas en fuite.',
    difficulty: 'Facile',
  ),

  // MANDAT D’AMENER — DÉFINITION
  QuizQuestion(
    category: 'Mandat d’amener — Notions de base',
    question: 'Le mandat d’amener est l’ordre de :',
    options: [
      'Conduire immédiatement une personne devant le juge',
      'La maintenir en détention pendant toute la procédure',
      'La placer sous contrôle judiciaire',
    ],
    answer: 'Conduire immédiatement une personne devant le juge',
    explanation:
        'Le mandat d’amener ordonne de conduire immédiatement la personne devant le magistrat (art. 122 al. 5 C.P.P.).',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Nature',
    question: 'Le mandat d’amener est :',
    options: [
      'Une peine d’emprisonnement',
      'Une mesure de contrainte mais pas un titre de détention en soi',
      'Une simple convocation écrite',
    ],
    answer: 'Une mesure de contrainte mais pas un titre de détention en soi',
    explanation:
        'Le mandat d’amener n’est pas un titre de détention définitif, il a pour objet de présenter la personne devant la justice.',
    difficulty: 'Facile',
  ),

  // MANDAT D’ARRÊT — DÉFINITION
  QuizQuestion(
    category: 'Mandat d’arrêt — Notions de base',
    question: 'Le mandat d’arrêt est l’ordre :',
    options: [
      'D’assigner une personne à résidence',
      'D’arrêter une personne et de la conduire devant le juge d’instruction ou à la maison d’arrêt',
      'De simplement la convoquer à une date ultérieure',
    ],
    answer:
        'D’arrêter une personne et de la conduire devant le juge d’instruction ou à la maison d’arrêt',
    explanation:
        'Le mandat d’arrêt est un ordre de recherche, d’arrestation et de conduite devant le juge ou en détention (art. 122 al. 6 et art. 131 C.P.P.).',
    difficulty: 'Facile',
  ),

  // MANDAT DE DÉPÔT — DÉFINITION
  QuizQuestion(
    category: 'Mandat de dépôt — Notions de base',
    question: 'Le mandat de dépôt est avant tout :',
    options: [
      'Un titre de détention provisoire',
      'Une simple mesure de contrôle judiciaire',
      'Un mandat de perquisition',
    ],
    answer: 'Un titre de détention provisoire',
    explanation:
        'Le mandat de dépôt est le titre par lequel une personne est placée ou maintenue en détention provisoire.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de dépôt — Exécution',
    question: 'L’agent de la force publique qui exécute un mandat de dépôt :',
    options: [
      'Décide de la durée de la détention',
      'Effectue une mission purement matérielle en conduisant la personne à la maison d’arrêt',
      'Peut modifier le lieu de détention comme il le souhaite',
    ],
    answer:
        'Effectue une mission purement matérielle en conduisant la personne à la maison d’arrêt',
    explanation:
        'Il ne fait qu’exécuter matériellement la décision de placement en détention et remet la personne au chef d’établissement.',
    difficulty: 'Facile',
  ),

  // SANCTIONS — PRINCIPES
  QuizQuestion(
    category: 'Mandats de justice — Sanctions',
    question:
        'Qui est considéré comme responsable de la régularité formelle des mandats ?',
    options: [
      'Le greffier',
      'Le chef d’escorte',
      'Le directeur de la maison d’arrêt',
    ],
    answer: 'Le greffier',
    explanation:
        'Le greffier doit s’assurer que les mandats sont régulièrement signés, datés, revêtus du sceau et comportent les mentions nécessaires.',
    difficulty: 'Facile',
  ),

  // =====================================================
  // NIVEAU 2 — MOYEN
  // =====================================================

  // PRINCIPES — DIFFUSION ET FORMES
  QuizQuestion(
    category: 'Mandats de justice — Principes (niveau 2)',
    question:
        'En cas d’urgence, les mandats d’amener, d’arrêt et de recherche peuvent être diffusés :',
    options: [
      'Par simple texto d’un policier',
      'Par tous moyens, notamment télégramme, télécopie ou voie électronique',
      'Uniquement par courrier recommandé',
    ],
    answer:
        'Par tous moyens, notamment télégramme, télécopie ou voie électronique',
    explanation:
        'Le texte précise que ces mandats peuvent être diffusés par tous moyens en cas d’urgence (art. 123 al. 6 C.P.P.).',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Principes (niveau 2)',
    question: 'Les mandats sont des actes individuels, cela signifie que :',
    options: [
      'Ils ne concernent qu’une seule personne par mandat',
      'Ils peuvent viser plusieurs personnes à la fois',
      'Ils sont valables pour tout le département',
    ],
    answer: 'Ils ne concernent qu’une seule personne par mandat',
    explanation:
        'Chaque mandat doit viser une personne déterminée avec ses mentions d’identité.',
    difficulty: 'Moyen',
  ),

  // MANDAT DE RECHERCHE — REMARQUES
  QuizQuestion(
    category: 'Mandat de recherche — Délivrance (niveau 2)',
    question:
        'Selon l’article 70 du C.P.P., le procureur de la République peut décerner un mandat de recherche :',
    options: [
      'Uniquement en cas de crime',
      'Lorsqu’une enquête porte sur un crime ou un délit flagrant puni d’au moins trois ans d’emprisonnement',
      'Uniquement après l’ouverture d’une information judiciaire',
    ],
    answer:
        'Lorsqu’une enquête porte sur un crime ou un délit flagrant puni d’au moins trois ans d’emprisonnement',
    explanation:
        'Le texte précise que le procureur peut délivrer un mandat de recherche en enquête lorsque la gravité des faits le justifie.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de recherche — Agents habilités',
    question:
        'L’exécution d’un mandat de recherche est notifiée et exécutée par :',
    options: [
      'Tout citoyen',
      'Un officier ou agent de police judiciaire ou un agent de la force publique',
      'Uniquement le juge d’instruction',
    ],
    answer:
        'Un officier ou agent de police judiciaire ou un agent de la force publique',
    explanation:
        'L’article 123 al. 4 C.P.P. prévoit que ces agents notifient et exécutent les mandats.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de recherche — Effets',
    question:
        'Lorsque le mandat de recherche est délivré par le juge d’instruction et que la personne est découverte, elle est alors :',
    options: [
      'Simplement entendue comme témoin',
      'Considérée comme personne mise en examen',
      'Automatiquement jugée',
    ],
    answer: 'Considérée comme personne mise en examen',
    explanation:
        'Le texte indique qu’en cas de découverte au cours de l’instruction, la personne visée par un mandat de recherche du juge d’instruction est mise en examen.',
    difficulty: 'Moyen',
  ),

  // MANDAT DE COMPARUTION — NON-COMPARUTION
  QuizQuestion(
    category: 'Mandat de comparution — Non-présentation',
    question:
        'Si la personne ne se présente pas en exécution d’un mandat de comparution :',
    options: [
      'Le juge d’instruction ne peut rien faire',
      'Le juge dresse un procès-verbal de non-comparution et peut décerner un mandat d’amener',
      'La personne est automatiquement condamnée',
    ],
    answer:
        'Le juge dresse un procès-verbal de non-comparution et peut décerner un mandat d’amener',
    explanation:
        'Le juge apprécie la suite à donner : nouvelle tentative de comparution ou mandat d’amener.',
    difficulty: 'Moyen',
  ),

  // MANDAT D’AMENER — PERSONNES VISÉES ET CONDITIONS
  QuizQuestion(
    category: 'Mandat d’amener — Délivrance (niveau 2)',
    question:
        'Le mandat d’amener peut être décerné à l’encontre d’une personne :',
    options: [
      'Dont il existe des indices graves ou concordants rendant vraisemblable sa participation à l’infraction',
      'Uniquement déjà condamnée',
      'Uniquement témoin neutre',
    ],
    answer:
        'Dont il existe des indices graves ou concordants rendant vraisemblable sa participation à l’infraction',
    explanation:
        'Le mandat d’amener vise une personne soupçonnée sur la base d’indices graves ou concordants.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Diffusion',
    question: 'En principe, le mandat d’amener n’a pas vocation à être :',
    options: [
      'Exécuté par la police judiciaire',
      'Diffusé de façon générale comme un mandat d’arrêt',
      'Signé par le juge',
    ],
    answer: 'Diffusé de façon générale comme un mandat d’arrêt',
    explanation:
        'Le mandat d’amener concerne en principe des personnes domiciliées et n’a pas une diffusion générale.',
    difficulty: 'Moyen',
  ),

  // RÈGLES D’EXÉCUTION — PERQUISITION
  QuizQuestion(
    category: 'Mandats — Exécution (niveau 2)',
    question:
        'Selon l’article 134 du C.P.P., l’agent chargé d’exécuter un mandat d’amener, d’arrêt ou de recherche :',
    options: [
      'Ne peut jamais pénétrer au domicile',
      'Peut se rendre au domicile dans le respect des heures légales de perquisition',
      'Peut perquisitionner à toute heure sans restriction',
    ],
    answer:
        'Peut se rendre au domicile dans le respect des heures légales de perquisition',
    explanation:
        'L’introduction coercitive dans un lieu privé doit respecter les heures légales et les règles de perquisition.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandats — Exécution (niveau 2)',
    question:
        'La perquisition effectuée lors de l’exécution d’un mandat d’amener ou de recherche :',
    options: [
      'Permet toutes saisies éventuelles dans les lieux visités',
      'Ne peut tendre qu’à la découverte de la personne recherchée et des éléments utiles aux investigations',
      'N’est jamais autorisée',
    ],
    answer:
        'Ne peut tendre qu’à la découverte de la personne recherchée et des éléments utiles aux investigations',
    explanation:
        'La perquisition est strictement encadrée et doit être en lien avec l’objet du mandat.',
    difficulty: 'Moyen',
  ),

  // MANDAT D’ARRÊT — SITUATIONS PARTICULIÈRES
  QuizQuestion(
    category: 'Mandat d’arrêt — Conditions (niveau 2)',
    question: 'Le mandat d’arrêt peut être décerné notamment à l’encontre :',
    options: [
      'D’une personne en fuite hors du territoire',
      'D’un simple témoin',
      'D’un avocat dans l’exercice de ses fonctions',
    ],
    answer: 'D’une personne en fuite hors du territoire',
    explanation:
        'Il est notamment décerné en cas de fuite de la personne à l’étranger ou d’inobservation de certaines obligations.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Notifications',
    question:
        'Les agents habilités à notifier et exécuter un mandat d’arrêt sont :',
    options: [
      'Les mêmes que pour le mandat d’amener (OPJ, APJ, agents de la force publique)',
      'Uniquement les douaniers',
      'Uniquement les maires',
    ],
    answer:
        'Les mêmes que pour le mandat d’amener (OPJ, APJ, agents de la force publique)',
    explanation:
        'Les règles de notification/exécution sont alignées sur celles du mandat d’amener (art. 123, art. 188 C.P.P.).',
    difficulty: 'Moyen',
  ),

  // MANDAT DE DÉPÔT — TRIBUNAL CORRECTIONNEL
  QuizQuestion(
    category: 'Mandat de dépôt — Tribunal correctionnel',
    question:
        'Le tribunal correctionnel peut décerner un mandat de dépôt contre un prévenu :',
    options: [
      'Uniquement pour une contravention',
      'Encourant une peine d’emprisonnement égale ou supérieure à deux ans',
      'Uniquement en cas de relaxe',
    ],
    answer:
        'Encourant une peine d’emprisonnement égale ou supérieure à deux ans',
    explanation:
        'Les textes (art. 410-1 C.P.P.) prévoient cette possibilité lorsque le prévenu encourt au moins deux ans d’emprisonnement.',
    difficulty: 'Moyen',
  ),

  // SANCTIONS — NULLITÉS
  QuizQuestion(
    category: 'Mandats — Sanctions (niveau 2)',
    question:
        'Les irrégularités de forme commises lors de la délivrance d’un mandat peuvent entraîner :',
    options: [
      'La nullité du mandat lui-même si elles sont substantielles',
      'Jamais aucune conséquence',
      'La nullité automatique de toute la procédure pénale',
    ],
    answer: 'La nullité du mandat lui-même si elles sont substantielles',
    explanation:
        'Seules les irrégularités substantielles portant atteinte aux droits de la défense justifient la nullité du mandat.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandats — Sanctions (niveau 2)',
    question:
        'Les irrégularités commises lors de la notification ou de l’exécution d’un mandat entraînent en principe :',
    options: [
      'La nullité de l’exécution ou la caducité du mandat',
      'La nullité du jugement',
      'L’absence totale de sanction',
    ],
    answer: 'La nullité de l’exécution ou la caducité du mandat',
    explanation:
        'La jurisprudence distingue la nullité de l’acte lui-même et la nullité de son exécution.',
    difficulty: 'Moyen',
  ),

  // RESPONSABILITÉ PÉNALE DES MAGISTRATS
  QuizQuestion(
    category: 'Mandats — Responsabilité pénale',
    question:
        'Selon l’article 126 du C.P.P., les sanctions pénales des articles 432-4 à 432-6 du Code pénal s’appliquent :',
    options: [
      'Aux magistrats ou fonctionnaires qui ont ordonné ou toléré une détention arbitraire',
      'Aux simples témoins de l’infraction',
      'Uniquement aux avocats de la défense',
    ],
    answer:
        'Aux magistrats ou fonctionnaires qui ont ordonné ou toléré une détention arbitraire',
    explanation:
        'Ces dispositions visent notamment un dépassement injustifié des délais légaux d’interrogatoire après arrestation.',
    difficulty: 'Moyen',
  ),

  // =====================================================
  // NIVEAU 3 — DIFFICILE
  // =====================================================

  // CAS PRATIQUES — MANDAT DE RECHERCHE
  QuizQuestion(
    category: 'Mandats — Cas pratiques (niveau 3)',
    question:
        'Un mandat de recherche délivré par le procureur de la République dans le cadre d’une enquête n’a pas permis de retrouver la personne. Il n’y a aucun élément nominatif contre elle. Le procureur peut alors :',
    options: [
      'Ouvrir une information contre personne non dénommée',
      'Prononcer lui-même une peine d’emprisonnement',
      'Décider seul d’une détention provisoire',
    ],
    answer: 'Ouvrir une information contre personne non dénommée',
    explanation:
        'Le texte prévoit que le mandat de recherche peut déboucher sur l’ouverture d’une information contre personne non dénommée lorsque la personne n’est pas découverte.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Garde à vue et droits',
    question:
        'Lorsqu’une personne est retenue en vertu d’un mandat d’amener, les droits relatifs à la garde à vue lui sont reconnus, notamment :',
    options: [
      'Le droit d’être examinée par un médecin et assistée par un avocat',
      'Uniquement le droit à un repas',
      'Aucun droit particulier',
    ],
    answer: 'Le droit d’être examinée par un médecin et assistée par un avocat',
    explanation:
        'Les articles 63-3 et 63-3-1 à 63-4-4 C.P.P. sont applicables : médecin, avocat, information d’un proche, etc.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Délai de 24 heures',
    question:
        'En matière de mandat d’amener, le délai maximal de 24 heures prévu par l’article 128 du C.P.P. concerne :',
    options: [
      'Le temps dont dispose le juge d’instruction pour interroger la personne retenue',
      'La durée de la procédure devant la cour d’assises',
      'Le temps de transport de la maison d’arrêt vers le tribunal',
    ],
    answer:
        'Le temps dont dispose le juge d’instruction pour interroger la personne retenue',
    explanation:
        'Au-delà de 24 heures après arrestation, la personne doit être interrogée ou remise en liberté, sous peine de détention arbitraire.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Exécution à plus de 200 km',
    question:
        'Lorsqu’une personne arrêtée en vertu d’un mandat d’arrêt se trouve à plus de 200 km du siège du magistrat mandant, elle doit être présentée à un magistrat de ce ressort dans un délai maximal de :',
    options: ['12 heures', '24 heures', '48 heures'],
    answer: '24 heures',
    explanation:
        'Les articles 127 et suivants du C.P.P. prévoient un délai maximal de 24 heures pour la présentation devant un magistrat local.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Transfert ultérieur',
    question:
        'Après audition de la personne par le juge ou le JLD du lieu d’arrestation, le transfert vers la maison d’arrêt désignée par le mandat doit intervenir :',
    options: [
      'Dans les 4 jours (ou 6 jours en cas de changement de département) à compter de la notification du mandat, sauf circonstances insurmontables',
      'Sans aucun délai légal',
      'Uniquement avec l’accord écrit de la personne',
    ],
    answer:
        'Dans les 4 jours (ou 6 jours en cas de changement de département) à compter de la notification du mandat, sauf circonstances insurmontables',
    explanation:
        'Le texte prévoit des délais précis de transfert pour les personnes arrêtées loin du siège du juge mandant.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Après règlement de l’information',
    question:
        'Après règlement de l’information, l’exécution d’un mandat d’arrêt reste possible. Dans ce cas, la rétention de la personne par les services de police :',
    options: [
      'Est limitée à 24 heures avec application des droits de la garde à vue',
      'Peut durer indéfiniment jusqu’au jugement',
      'Ne peut jamais avoir lieu',
    ],
    answer:
        'Est limitée à 24 heures avec application des droits de la garde à vue',
    explanation:
        'L’article 179 et les articles 133-1 et suivants encadrent cette rétention postérieure au règlement de l’information.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat de dépôt — Comparution immédiate',
    question:
        'En procédure de comparution immédiate, le tribunal correctionnel peut décerner un mandat de dépôt lorsque :',
    options: [
      'Le prévenu encourt une peine d’amende',
      'Le prévenu encourt une peine d’emprisonnement et que les conditions de la détention provisoire sont réunies',
      'La victime le demande systématiquement',
    ],
    answer:
        'Le prévenu encourt une peine d’emprisonnement et que les conditions de la détention provisoire sont réunies',
    explanation:
        'Les articles 395 et suivants C.P.P. permettent au tribunal de délivrer un mandat de dépôt en comparution immédiate.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat de dépôt — Trouble à l’audience',
    question:
        'En cas de trouble à l’audience, le président du tribunal correctionnel peut :',
    options: [
      'Uniquement expulser le perturbateur',
      'Placer sous mandat de dépôt le perturbateur qui résiste à un ordre d’expulsion ou cause du tumulte',
      'Rien faire, ce n’est pas prévu par la loi',
    ],
    answer:
        'Placer sous mandat de dépôt le perturbateur qui résiste à un ordre d’expulsion ou cause du tumulte',
    explanation:
        'L’article 404 C.P.P. prévoit cette possibilité pour garantir l’ordre de l’audience.',
    difficulty: 'Difficile',
  ),

  // SANCTIONS — DÉTENTION ARBITRAIRE
  QuizQuestion(
    category: 'Mandats — Détention arbitraire (niveau 3)',
    question:
        'En cas de dépassement injustifié du délai de 24 heures pour l’interrogatoire d’une personne arrêtée en vertu d’un mandat d’amener, la responsabilité pénale peut être engagée :',
    options: [
      'Du simple agent de police uniquement',
      'Du procureur de la République, du juge d’instruction ou du chef d’établissement pénitentiaire ayant ordonné ou toléré la détention arbitraire',
      'De la victime de l’infraction',
    ],
    answer:
        'Du procureur de la République, du juge d’instruction ou du chef d’établissement pénitentiaire ayant ordonné ou toléré la détention arbitraire',
    explanation:
        'L’article 126 C.P.P. renvoie aux articles 432-4 à 432-6 du Code pénal pour réprimer la détention arbitraire.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Nullités et indemnisation',
    question:
        'La jurisprudence admet que les irrégularités commises lors de la délivrance ou de l’exécution d’un mandat entraînent nullité ou indemnisation :',
    options: [
      'Uniquement si elles sont substantielles et portent atteinte aux droits de la défense',
      'Dans tous les cas, même pour des erreurs mineures sans conséquence',
      'Jamais, car les mandats sont insusceptibles de contestation',
    ],
    answer:
        'Uniquement si elles sont substantielles et portent atteinte aux droits de la défense',
    explanation:
        'Les nullités sont d’interprétation stricte ; l’indemnisation est accordée par le premier président de la cour d’appel.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Indemnisation',
    question:
        'L’indemnisation d’une détention irrégulière liée à un mandat est allouée :',
    options: [
      'Par le premier président de la cour d’appel',
      'Par le maire de la commune',
      'Par le chef de la police municipale',
    ],
    answer: 'Par le premier président de la cour d’appel',
    explanation:
        'Le texte mentionne que l’indemnisation est allouée par le premier président de la cour d’appel, avec recours possible de l’État contre le dénonciateur de mauvaise foi.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
    category: "Action en nullité — Président chambre",
    question:
        "Dans quel délai le président de la chambre de l’instruction peut-il constater l’irrecevabilité d’une requête en nullité après réception du dossier ?",
    options: ["Dans les 24 heures", "Dans les 8 jours", "Dans les 2 mois"],
    answer: "Dans les 8 jours",
    explanation:
        "L’Article 173 alinéa 5 du Code de Procédure Pénale fixe ce délai pour l’ordonnance du président constatant l’irrecevabilité.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
    category: 'Mandats — Recours contre le dénonciateur',
    question:
        'Lorsque la détention résulte d’une dénonciation mensongère, l’État :',
    options: [
      'Dispose d’un recours contre le dénonciateur de mauvaise foi ou le faux témoin',
      'Ne peut jamais se retourner contre cette personne',
      'Doit indemniser le dénonciateur',
    ],
    answer:
        'Dispose d’un recours contre le dénonciateur de mauvaise foi ou le faux témoin',
    explanation:
        'Le texte indique expressément que l’État peut exercer un recours contre l’auteur de la dénonciation mensongère ayant provoqué la détention.',
    difficulty: 'Difficile',
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

  QuizQuestion(
    category: "Détention provisoire — Cas pratiques",
    question:
        "Une personne détenue voit sa demande de mise en liberté rejetée par le juge d’instruction. Quel recours peut-elle exercer ?",
    options: [
      "Un appel devant la chambre de l’instruction",
      "Un simple recours gracieux devant le même juge",
      "Aucun, la décision est définitive",
    ],
    answer: "Un appel devant la chambre de l’instruction",
    explanation:
        "Les ordonnances du juge d’instruction statuant sur la détention sont susceptibles d’appel devant la chambre de l’instruction.",
    difficulty: "Facile",
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
  QuizQuestion(
    category: 'ARSE — Comparaison avec la détention provisoire',
    question: 'Sur le plan des libertés, l’ARSE se situe :',
    options: [
      'Comme une mesure plus restrictive que la détention provisoire',
      'Comme une mesure intermédiaire, plus contraignante que le contrôle judiciaire mais moins que la détention provisoire',
      'Comme une simple mesure sans contrainte réelle',
    ],
    answer:
        'Comme une mesure intermédiaire, plus contraignante que le contrôle judiciaire mais moins que la détention provisoire',
    explanation:
        'Elle impose une présence au domicile contrôlée électroniquement, mais évite l’incarcération en établissement pénitentiaire.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: "Extinction — Prescription",
    question: "Quel est l’effet de la prescription de l’action publique ?",
    options: [
      "Elle réduit simplement la peine encourue",
      "Elle éteint l’action publique lorsque le délai fixé par la loi est écoulé sans poursuite",
      "Elle transforme l’action publique en action civile",
    ],
    answer:
        "Elle éteint l’action publique lorsque le délai fixé par la loi est écoulé sans poursuite",
    explanation:
        "Si aucune poursuite n’est exercée dans le délai légal, l’infraction ne peut plus donner lieu à une action publique.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Généralités — Instruction préparatoire",
    question: "À combien de degrés se déroule l’instruction préparatoire ?",
    options: [
      "Un seul degré, devant le juge d’instruction",
      "Deux degrés : devant le juge d’instruction puis devant la chambre de l’instruction",
      "Trois degrés : juge d’instruction, J.L.D. puis tribunal correctionnel",
    ],
    answer:
        "Deux degrés : devant le juge d’instruction puis devant la chambre de l’instruction",
    explanation:
        "L’instruction préparatoire est à deux degrés : au premier degré devant le juge d’instruction, au second degré devant la chambre de l’instruction.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Généralités — Instruction préparatoire",
    question:
        "Quelle est la mission principale du juge d’instruction pendant l’instruction préparatoire ?",
    options: [
      "Déterminer la peine à infliger",
      "Rechercher la vérité en instruisant à charge et à décharge",
      "Protéger uniquement les intérêts de la victime",
      "Contrôler le travail des officiers de police judiciaire uniquement",
    ],
    answer: "Rechercher la vérité en instruisant à charge et à décharge",
    explanation:
        "L’article 81 C. proc. pén. impose au juge d’instruction d’instruire à charge et à décharge afin de rechercher la vérité de manière objective.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Généralités — Instruction préparatoire",
    question:
        "Sur quels éléments porte l’instruction préparatoire, en plus des faits eux-mêmes ?",
    options: [
      "Uniquement sur la personnalité de la victime",
      "Uniquement sur la personnalité du mis en examen",
      "Sur les faits, la personnalité du délinquant et éventuellement celle de la victime",
      "Uniquement sur le casier judiciaire",
    ],
    answer:
        "Sur les faits, la personnalité du délinquant et éventuellement celle de la victime",
    explanation:
        "L’instruction doit porter à la fois sur les circonstances de l’infraction, la personnalité de l’auteur et, le cas échéant, celle de la victime (art. 81-1 C. proc. pén.).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Généralités — Instruction préparatoire",
    question:
        "Quel est l’enjeu permanent de la procédure d’instruction préparatoire ?",
    options: [
      "Opposer les parties civiles au parquet",
      "Trouver un compromis entre efficacité de la recherche de la vérité et respect des libertés individuelles",
      "Donner un avantage à la défense sur l’accusation",
      "Accélérer la procédure à tout prix",
    ],
    answer:
        "Trouver un compromis entre efficacité de la recherche de la vérité et respect des libertés individuelles",
    explanation:
        "Toute la procédure d’instruction cherche à concilier efficacité de la recherche de la vérité et garantie des droits fondamentaux, notamment par un formalisme strict.",
    difficulty: "Moyenne",
  ),

  // ========== CARACTÈRE ÉCRIT ==========
  QuizQuestion(
    category: "Caractères — Procédure écrite",
    question:
        "Pourquoi le caractère écrit de la procédure d’instruction est-il important ?",
    options: [
      "Parce qu’il permet d’éviter les audiences publiques",
      "Parce qu’il assure la traçabilité des actes et décisions de la procédure",
      "Parce qu’il dispense le juge de motiver ses décisions",
      "Parce qu’il interdit l’accès au dossier aux avocats",
    ],
    answer:
        "Parce qu’il assure la traçabilité des actes et décisions de la procédure",
    explanation:
        "Le caractère écrit permet de conserver toutes les étapes de la procédure dans un dossier consultable, garantissant la transparence et le contrôle a posteriori.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Caractères — Procédure écrite",
    question:
        "Quel élément traduit l’atténuation du caractère écrit devant la chambre de l’instruction ?",
    options: [
      "L’absence d’avocats",
      "L’absence de dossier",
      "L’audition orale du procureur général et des avocats des parties",
      "La suppression des procès-verbaux",
    ],
    answer: "L’audition orale du procureur général et des avocats des parties",
    explanation:
        "Devant la chambre de l’instruction, le caractère écrit est moins marqué car le procureur général et les avocats sont entendus à l’audience (art. 199 C. proc. pén.).",
    difficulty: "Moyenne",
  ),

  // ========== CARACTÈRE SECRET ==========
  QuizQuestion(
    category: "Caractères — Secret de l’instruction",
    question:
        "Qui est tenu au secret professionnel en application de l’article 11 du Code de procédure pénale ?",
    options: [
      "Uniquement le juge d’instruction",
      "Uniquement le procureur de la République",
      "Toute personne qui concourt à la procédure",
      "Uniquement les avocats",
    ],
    answer: "Toute personne qui concourt à la procédure",
    explanation:
        "L’article 11 C. proc. pén. impose le secret professionnel à toutes les personnes qui participent à la procédure d’instruction (magistrats, greffiers, OPJ, experts, etc.).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Caractères — Secret de l’instruction",
    question:
        "Quel est le risque pour un journaliste qui publie un acte de procédure avant sa lecture en audience publique ?",
    options: [
      "Aucun risque, la liberté de la presse prime toujours",
      "Une simple mise en garde du parquet",
      "Une infraction à la loi du 29 juillet 1881 sur la presse",
      "Une sanction disciplinaire interne uniquement",
    ],
    answer: "Une infraction à la loi du 29 juillet 1881 sur la presse",
    explanation:
        "L’article 38 de la loi du 29 juillet 1881 interdit la publication des actes de procédure avant leur lecture en audience publique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Caractères — Secret de l’instruction",
    question:
        "Quel type de recours est prévu par l’article 9-1 du Code civil pour une personne présentée publiquement comme coupable alors qu’une instruction est en cours ?",
    options: [
      "Un recours pénal automatique",
      "Une action en réparation du dommage subi",
      "Une simple demande de rectification auprès du média",
      "Une plainte obligatoire avec constitution de partie civile",
    ],
    answer: "Une action en réparation du dommage subi",
    explanation:
        "L’article 9-1 du Code civil permet à toute personne présentée comme coupable de demander réparation si elle subit un préjudice du fait de cette présentation médiatique.",
    difficulty: "Difficile",
  ),

  // ========== PROCÉDURE NON CONTRADICTOIRE ==========
  QuizQuestion(
    category: "Caractères — Non-contradictoire",
    question:
        "Quel droit renforce particulièrement le caractère contradictoire de l’instruction ?",
    options: [
      "Le droit pour les parties d’assister aux gardes à vue",
      "Le droit pour les parties de demander des actes au juge d’instruction",
      "Le droit pour les avocats de diriger l’enquête",
      "Le droit pour les journalistes d’assister aux interrogatoires",
    ],
    answer:
        "Le droit pour les parties de demander des actes au juge d’instruction",
    explanation:
        "Les parties (mise en examen, témoin assisté, partie civile) peuvent solliciter la réalisation de certains actes d’instruction, ce qui renforce le caractère contradictoire.",
    difficulty: "Moyenne",
  ),

  // ========== OUVERTURE DE L’INFORMATION ==========
  QuizQuestion(
    category: "Ouverture de l’information",
    question:
        "En matière de contravention, dans quel cas une information peut-elle être ouverte ?",
    options: [
      "Jamais, l’instruction est interdite en matière contraventionnelle",
      "Uniquement sur réquisition du procureur de la République",
      "Uniquement sur plainte de la victime",
      "Uniquement sur décision du J.L.D.",
    ],
    answer: "Uniquement sur réquisition du procureur de la République",
    explanation:
        "L’article 79 C. proc. pén. précise qu’en matière contraventionnelle l’information n’est ouverte que sur réquisition du procureur de la République.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Ouverture de l’information",
    question:
        "Quel acte le procureur de la République rédige-t-il pour saisir le juge d’instruction ?",
    options: [
      "Une citation directe",
      "Un réquisitoire à fin d’informer",
      "Un mandat d’amener",
      "Un procès-verbal de saisine",
    ],
    answer: "Un réquisitoire à fin d’informer",
    explanation:
        "La saisine du juge d’instruction par le parquet se fait par réquisitoire à fin d’informer (réquisitoire introductif).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Ouverture de l’information",
    question:
        "Quelle est la conséquence d’une plainte avec constitution de partie civile recevable devant le juge d’instruction ?",
    options: [
      "Elle ouvre automatiquement une information judiciaire",
      "Elle est transmise d’office au tribunal correctionnel",
      "Elle dessaisit le parquet définitivement",
      "Elle empêche toute enquête de police",
    ],
    answer: "Elle ouvre automatiquement une information judiciaire",
    explanation:
        "Si la plainte avec constitution de partie civile est régulière et recevable, elle déclenche l’ouverture de l’information.",
    difficulty: "Moyenne",
  ),

  // ========== PÔLES DE L’INSTRUCTION ==========
  QuizQuestion(
    category: "Organisation — Pôles de l’instruction",
    question:
        "Pour quel type d’affaires les pôles de l’instruction sont-ils spécialement compétents ?",
    options: [
      "Les infractions routières simples",
      "Les affaires criminelles ou complexes nécessitant une cosaisine",
      "Les contraventions de 1ère classe",
      "Uniquement les affaires de terrorisme",
    ],
    answer: "Les affaires criminelles ou complexes nécessitant une cosaisine",
    explanation:
        "Les pôles de l’instruction traitent notamment les affaires criminelles ou d’une certaine gravité ou complexité justifiant la cosaisine (art. 83-1 C. proc. pén.).",
    difficulty: "Difficile",
  ),

  // ========== EXPERTISE ==========
  QuizQuestion(
    category: "Expertise — Nomination",
    question:
        "Qui peut être à l’initiative d’une demande d’expertise en matière d’instruction préparatoire ?",
    options: [
      "Uniquement le juge d’instruction",
      "Uniquement le ministère public",
      "Le juge d’instruction, le ministère public ou une partie",
      "Uniquement la partie civile",
    ],
    answer: "Le juge d’instruction, le ministère public ou une partie",
    explanation:
        "L’article 156 C. proc. pén. prévoit que l’expertise peut être ordonnée à la demande du parquet, du juge d’instruction ou d’une partie (ou du témoin assisté).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Expertise — Choix de l’expert",
    question:
        "Où le juge d’instruction doit-il, en principe, choisir les experts ?",
    options: [
      "Uniquement parmi les fonctionnaires de police",
      "Parmi les personnes figurant sur les listes d’experts agréés",
      "Uniquement parmi les universitaires",
      "Uniquement dans les services de gendarmerie",
    ],
    answer: "Parmi les personnes figurant sur les listes d’experts agréés",
    explanation:
        "Les experts doivent normalement être choisis sur la liste nationale ou sur les listes des cours d’appel (art. 157 C. proc. pén.), sauf technicité particulière justifiant un autre choix motivé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Expertise — Rapport",
    question: "Quelle formalité marque la fin de la mission de l’expert ?",
    options: [
      "La signature par le parquet",
      "La rédaction d’un rapport écrit décrivant les opérations et conclusions",
      "Une simple note orale déposée au greffe",
      "Un appel téléphonique au juge d’instruction",
    ],
    answer:
        "La rédaction d’un rapport écrit décrivant les opérations et conclusions",
    explanation:
        "À la fin de leur mission, les experts rédigent un rapport, signé, décrivant leurs opérations et exposant leurs conclusions, qui est déposé au greffe (art. 166 C. proc. pén.).",
    difficulty: "Facile",
  ),

  // ========== TÉMOINS ==========
  QuizQuestion(
    category: "Auditions — Témoins",
    question:
        "Quelle est la conséquence si le juge d’instruction recueille une déposition de témoin sans préciser son identité ?",
    options: [
      "La déposition est quand même valable",
      "La déposition doit être complétée plus tard",
      "La déposition est frappée de nullité",
      "La déposition est automatiquement classée au secret",
    ],
    answer: "La déposition est frappée de nullité",
    explanation:
        "Le juge doit vérifier l’identité du témoin, faute de quoi la déposition serait entachée de nullité (art. 103 C. proc. pén.).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Auditions — Témoins",
    question:
        "Quelle sanction pénale encourt le témoin qui, régulièrement cité, ne comparaît pas devant le juge d’instruction sans excuse légitime ?",
    options: [
      "Aucune, c’est un simple manquement moral",
      "Une amende de 3 750 €",
      "Une peine de prison ferme",
      "L’interdiction définitive de témoigner",
    ],
    answer: "Une amende de 3 750 €",
    explanation:
        "L’article 434-15-1 du Code pénal punit d’une amende de 3 750 € le témoin qui ne comparaît pas, refuse de prêter serment ou de déposer.",
    difficulty: "Moyenne",
  ),

  // ========== TÉMOIN ASSISTÉ (DÉTAIL) ==========
  QuizQuestion(
    category: "Témoin assisté — Conditions",
    question:
        "Dans quel cas le statut de témoin assisté est-il obligatoirement conféré à défaut de mise en examen ?",
    options: [
      "Lorsque la personne est simplement proche de la victime",
      "Lorsque la personne est nommément visée par un réquisitoire introductif ou supplétif",
      "Lorsque la personne n’a aucun lien avec les faits",
      "Uniquement en cas d’aveu spontané",
    ],
    answer:
        "Lorsque la personne est nommément visée par un réquisitoire introductif ou supplétif",
    explanation:
        "Les personnes nommément visées par un réquisitoire ou contre lesquelles existent des indices graves et concordants doivent, à défaut de mise en examen, être au moins témoins assistés (art. 113-1 C. proc. pén.).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Témoin assisté — Droits procéduraux",
    question: "Le témoin assisté a-t-il accès au dossier de la procédure ?",
    options: [
      "Non, seul le mis en examen y a accès",
      "Oui, via son avocat qui peut consulter le dossier",
      "Uniquement à la fin de l’instruction",
      "Uniquement avec l’autorisation de la partie civile",
    ],
    answer: "Oui, via son avocat qui peut consulter le dossier",
    explanation:
        "L’article 113-3 C. proc. pén. accorde au témoin assisté, par l’intermédiaire de son avocat, un accès au dossier et à la traduction des pièces essentielles.",
    difficulty: "Moyenne",
  ),

  // ========== MISE EN EXAMEN / INTERROGATOIRE ==========
  QuizQuestion(
    category: "Mise en examen — Interrogatoire",
    question:
        "Comment s’appelle le premier interrogatoire d’une personne dont la mise en examen est envisagée ?",
    options: [
      "L’audition contradictoire",
      "L’interrogatoire de première comparution",
      "L’interrogatoire de fin d’instruction",
      "L’interrogatoire de notification",
    ],
    answer: "L’interrogatoire de première comparution",
    explanation:
        "L’article 116 C. proc. pén. encadre l’interrogatoire de première comparution, préalable indispensable à la mise en examen d’une personne qui n’est pas encore témoin assisté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Mise en examen — Garanties",
    question:
        "En matière criminelle, quelle garantie supplémentaire est prévue pour l’interrogatoire de première comparution ?",
    options: [
      "La présence obligatoire d’un journaliste",
      "L’enregistrement audiovisuel de l’interrogatoire",
      "La publicité automatique de l’audience",
      "L’absence de greffier",
    ],
    answer: "L’enregistrement audiovisuel de l’interrogatoire",
    explanation:
        "L’article 116-1 C. proc. pén. impose, en matière criminelle, l’enregistrement audiovisuel de l’interrogatoire de première comparution pour renforcer les garanties.",
    difficulty: "Difficile",
  ),

  // ========== PARTIE CIVILE (DÉTAIL) ==========
  QuizQuestion(
    category: "Partie civile — Recevabilité",
    question:
        "Quelle condition est souvent requise pour qu’une plainte avec constitution de partie civile soit recevable ?",
    options: [
      "Avoir déjà obtenu la condamnation pénale de l’auteur",
      "Justifier d’un classement sans suite ou de l’écoulement d’un délai après plainte simple",
      "Avoir saisi au préalable la chambre de l’instruction",
      "Avoir obtenu l’accord du J.L.D.",
    ],
    answer:
        "Justifier d’un classement sans suite ou de l’écoulement d’un délai après plainte simple",
    explanation:
        "L’article 85 C. proc. pén. prévoit qu’en principe la constitution de partie civile n’est recevable qu’après classement sans suite ou après un délai (3 mois) suivant une plainte simple.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Partie civile — Effets",
    question:
        "Quel est l’un des principaux avantages pour la victime de se constituer partie civile ?",
    options: [
      "Elle peut diriger l’enquête de police",
      "Elle obtient automatiquement des dommages-intérêts",
      "Elle dispose de droits procéduraux (demandes d’actes, accès au dossier, recours)",
      "Elle remplace le ministère public",
    ],
    answer:
        "Elle dispose de droits procéduraux (demandes d’actes, accès au dossier, recours)",
    explanation:
        "La partie civile acquiert des droits spécifiques dans la procédure : accès au dossier, demandes d’actes, requêtes en nullité, appels de certaines décisions, etc.",
    difficulty: "Moyenne",
  ),

  // ========== ORDONNANCES DE RÈGLEMENT ==========
  QuizQuestion(
    category: "Ordonnances de règlement — Renvoi",
    question:
        "Quel est l’effet principal d’une ordonnance de renvoi devant le tribunal correctionnel sur les mesures de sûreté ?",
    options: [
      "Elle prolonge automatiquement la détention provisoire",
      "Elle met en principe fin à la détention provisoire, au contrôle judiciaire et à l’assignation à résidence avec surveillance électronique",
      "Elle annule toutes les preuves recueillies",
      "Elle suspend l’action publique",
    ],
    answer:
        "Elle met en principe fin à la détention provisoire, au contrôle judiciaire et à l’assignation à résidence avec surveillance électronique",
    explanation:
        "L’article 179 C. proc. pén. prévoit que l’ordonnance de renvoi met en principe fin à ces mesures, sous réserve du maintien de certains mandats, notamment le mandat d’arrêt.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Ordonnances de règlement — Mise en accusation",
    question:
        "Devant quelle juridiction une ordonnance de mise en accusation renvoie-t-elle l’affaire ?",
    options: [
      "Le tribunal de police",
      "Le tribunal correctionnel",
      "La cour d’assises",
      "La chambre de l’instruction",
    ],
    answer: "La cour d’assises",
    explanation:
        "L’ordonnance de mise en accusation renvoie les personnes mises en examen devant la cour d’assises pour y être jugées (art. 181 C. proc. pén.).",
    difficulty: "Facile",
  ),

  // ========== NON-LIEU (DÉTAIL) ==========
  QuizQuestion(
    category: "Ordonnance de non-lieu — Fondement",
    question:
        "Dans lequel des cas suivants le juge d’instruction peut-il rendre une ordonnance de non-lieu ?",
    options: [
      "Lorsque les charges sont suffisantes et la culpabilité établie",
      "Lorsque les faits ne constituent pas une infraction ou qu’il n’existe pas de charges suffisantes",
      "Lorsque la victime le demande",
      "Lorsque le parquet le souhaite, sans condition",
    ],
    answer:
        "Lorsque les faits ne constituent pas une infraction ou qu’il n’existe pas de charges suffisantes",
    explanation:
        "L’ordonnance de non-lieu est rendue lorsqu’il n’y a pas d’infraction, que l’auteur reste inconnu ou qu’il n’existe pas de charges suffisantes contre la personne (art. 177 C. proc. pén.).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Ordonnance de non-lieu — Charges nouvelles",
    question:
        "Que désigne l’expression « charges nouvelles » au sens de l’article 189 du Code de procédure pénale ?",
    options: [
      "Des éléments déjà examinés par le juge",
      "Des éléments de preuve déjà rejetés",
      "Des déclarations, pièces ou procès-verbaux non encore examinés, de nature à renforcer ou compléter les charges",
      "Uniquement un nouvel aveu de la personne mise en examen",
    ],
    answer:
        "Des déclarations, pièces ou procès-verbaux non encore examinés, de nature à renforcer ou compléter les charges",
    explanation:
        "Les charges nouvelles sont des éléments non examinés par le juge d’instruction, susceptibles de renforcer des charges jugées insuffisantes ou d’apporter des développements utiles aux faits.",
    difficulty: "Difficile",
  ),

  // ========== CHAMBRE DE L’INSTRUCTION — POUVOIRS PARTICULIERS ==========
  QuizQuestion(
    category: "Chambre de l’instruction — Pouvoir de révision",
    question:
        "À quel moment le pouvoir de révision de la chambre de l’instruction trouve-t-il à s’appliquer ?",
    options: [
      "Lorsque l’instruction est encore en cours devant le juge d’instruction",
      "Lorsque le juge d’instruction n’est plus en charge de l’affaire (ex. appel d’une ordonnance de règlement)",
      "Uniquement après un arrêt de cour d’assises",
      "Uniquement en matière contraventionnelle",
    ],
    answer:
        "Lorsque le juge d’instruction n’est plus en charge de l’affaire (ex. appel d’une ordonnance de règlement)",
    explanation:
        "Le pouvoir de révision permet à la chambre de refaire ou compléter l’instruction lorsque le juge d’instruction est dessaisi (art. 205 C. proc. pén.).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Chambre de l’instruction — Droit d’évocation",
    question:
        "Que permet le droit d’évocation à la chambre de l’instruction lorsque l’information est encore en cours ?",
    options: [
      "Remplacer le parquet",
      "Dessaisir le juge d’instruction et prendre en charge tout ou partie de la procédure",
      "Prononcer la peine définitive",
      "Suspendre la procédure sans suite possible",
    ],
    answer:
        "Dessaisir le juge d’instruction et prendre en charge tout ou partie de la procédure",
    explanation:
        "Le droit d’évocation autorise la chambre de l’instruction à se saisir de l’ensemble ou d’une partie de l’information, en dessaisissant le juge d’instruction (art. 207 C. proc. pén.).",
    difficulty: "Moyenne",
  ),

  // ========== AUDIENCE DE CONTRÔLE ==========
  QuizQuestion(
    category: "Chambre de l’instruction — Audience de contrôle",
    question:
        "Dans quel contexte l’article 221-3 du Code de procédure pénale prévoit-il une audience publique de contrôle ?",
    options: [
      "Uniquement pour les contraventions routières",
      "En cas de détention provisoire datant de trois mois",
      "Uniquement lorsque la partie civile le demande",
      "Uniquement en cas de non-lieu envisagé",
    ],
    answer: "En cas de détention provisoire datant de trois mois",
    explanation:
        "L’article 221-3 C. proc. pén. permet une audience publique de contrôle de l’instruction en présence d’une détention provisoire d’au moins trois mois.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Généralités — Instruction préparatoire",
    question:
        "Quel organe est principalement compétent pour conduire l’instruction préparatoire au premier degré ?",
    options: [
      "Le tribunal correctionnel",
      "Le juge d’instruction",
      "La chambre de l’instruction",
      "Le juge des libertés et de la détention",
    ],
    answer: "Le juge d’instruction",
    explanation:
        "L’instruction préparatoire est à deux degrés : au premier degré devant le juge d’instruction, au second devant la chambre de l’instruction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Généralités — Instruction préparatoire",
    question:
        "Comment le juge d’instruction doit-il conduire ses investigations selon l’article 81 du Code de procédure pénale ?",
    options: [
      "Uniquement à charge",
      "Uniquement à décharge",
      "À charge et à décharge",
      "En suivant les seules instructions du parquet",
    ],
    answer: "À charge et à décharge",
    explanation:
        "Le juge d’instruction doit rechercher la vérité de manière objective en instruisant à charge et à décharge.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Généralités — Instruction préparatoire",
    question:
        "Quel est l’un des risques majeurs si les formalités de l’instruction ne sont pas respectées ?",
    options: [
      "Une simple remarque du procureur",
      "La nullité des actes et de la procédure ultérieure",
      "La seule réduction de peine",
      "L’impossibilité pour la victime de se constituer partie civile",
    ],
    answer: "La nullité des actes et de la procédure ultérieure",
    explanation:
        "Le non-respect des formalités essentielles peut entraîner la nullité des actes et, le cas échéant, de la procédure subséquente.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Généralités — Instruction préparatoire",
    question:
        "Quelle tension fondamentale traverse l’ensemble de la procédure d’instruction préparatoire ?",
    options: [
      "Entre rapidité de la justice et secret de la défense",
      "Entre efficacité de la recherche de la vérité et respect des libertés individuelles",
      "Entre intérêts de la presse et intérêts du parquet",
      "Entre autorité du juge et pouvoir de la police",
    ],
    answer:
        "Entre efficacité de la recherche de la vérité et respect des libertés individuelles",
    explanation:
        "La procédure cherche constamment à concilier l’efficacité de la recherche de la vérité avec la protection des droits fondamentaux.",
    difficulty: "Moyenne",
  ),

  // ================== CARACTÈRE ÉCRIT ==================
  QuizQuestion(
    category: "Caractères — Procédure écrite",
    question:
        "Que prévoit l’article 81 alinéas 2 et 3 du Code de procédure pénale concernant les actes de l’instruction ?",
    options: [
      "Qu’ils peuvent rester purement oraux",
      "Qu’ils doivent être réunis dans un dossier écrit",
      "Qu’ils doivent être rédigés uniquement par le parquet",
      "Qu’ils ne sont pas communicables aux parties",
    ],
    answer: "Qu’ils doivent être réunis dans un dossier écrit",
    explanation:
        "Les actes et décisions de l’instruction sont réunis dans un dossier, ce qui matérialise le caractère écrit de la procédure.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Caractères — Procédure écrite",
    question:
        "Pourquoi autorise-t-on la copie ou la photocopie du dossier d’instruction ?",
    options: [
      "Pour diffuser le dossier au public",
      "Pour accélérer l’exécution des décisions",
      "Pour permettre la transmission nécessaire sans ralentir le travail du juge",
      "Pour éviter d’utiliser des greffiers",
    ],
    answer:
        "Pour permettre la transmission nécessaire sans ralentir le travail du juge",
    explanation:
        "Les copies/photocopies permettent la circulation du dossier (parquet, juridictions) sans immobiliser l’original et sans bloquer le juge.",
    difficulty: "Facile",
  ),

  // ================== CARACTÈRE SECRET ==================
  QuizQuestion(
    category: "Caractères — Secret de l’instruction",
    question:
        "Quel est le principe général posé par l’article 11 du Code de procédure pénale concernant l’instruction ?",
    options: [
      "Elle est totalement publique",
      "Elle est intégralement filmée et diffusée",
      "Elle doit rester secrète à l’égard du public",
      "Elle est toujours contradictoire",
    ],
    answer: "Elle doit rester secrète à l’égard du public",
    explanation:
        "L’article 11 C. proc. pén. affirme le caractère secret de l’instruction à l’égard du public, sauf exceptions prévues par la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Caractères — Secret de l’instruction",
    question:
        "Dans quel but le procureur de la République peut-il communiquer certains éléments de la procédure au public (art. 11 al. 3 C. proc. pén.) ?",
    options: [
      "Pour satisfaire la curiosité médiatique",
      "Pour influencer les témoins",
      "Pour éviter la propagation d’informations parcellaires ou inexactes ou mettre fin à un trouble à l’ordre public",
      "Pour critiquer la défense",
    ],
    answer:
        "Pour éviter la propagation d’informations parcellaires ou inexactes ou mettre fin à un trouble à l’ordre public",
    explanation:
        "Le procureur peut communiquer de manière maîtrisée pour des raisons d’intérêt public, tout en respectant la présomption d’innocence.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Caractères — Secret de l’instruction",
    question:
        "Qui supporte l’obligation de secret professionnel au titre de l’article 11 du Code de procédure pénale ?",
    options: [
      "Uniquement les officiers de police judiciaire",
      "Uniquement les magistrats",
      "Toute personne qui concourt à la procédure d’instruction",
      "Uniquement les experts",
    ],
    answer: "Toute personne qui concourt à la procédure d’instruction",
    explanation:
        "Le secret professionnel s’impose à tous les intervenants de la procédure : magistrats, greffiers, OPJ, experts, etc.",
    difficulty: "Facile",
  ),

  // ================== CARACTÈRE NON CONTRADICTOIRE ==================
  QuizQuestion(
    category: "Caractères — Non contradictoire",
    question:
        "Quel élément illustre l’atténuation du caractère non contradictoire de l’instruction ?",
    options: [
      "L’impossibilité d’être assisté d’un avocat",
      "Le droit des parties de consulter le dossier et de demander des actes",
      "L’interdiction absolue de contact avec le juge",
      "La présence de journalistes aux interrogatoires",
    ],
    answer:
        "Le droit des parties de consulter le dossier et de demander des actes",
    explanation:
        "L’accès au dossier et la possibilité de demander des actes renforcent le contradictoire au sein de l’instruction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Caractères — Non contradictoire",
    question:
        "Quelle difficulté majeure souligne l’évolution de la législation en matière d’instruction ?",
    options: [
      "La difficulté de gérer les médias",
      "La difficulté de concilier efficacité de la vérité et droits de la défense",
      "La difficulté d’organiser les audiences publiques",
      "La difficulté d’encadrer les OPJ",
    ],
    answer:
        "La difficulté de concilier efficacité de la vérité et droits de la défense",
    explanation:
        "Le législateur tente de concilier la recherche efficace de la vérité et la protection des libertés individuelles, ce qui impose un formalisme strict.",
    difficulty: "Moyenne",
  ),

  // ================== OUVERTURE DE L’INFORMATION ==================
  QuizQuestion(
    category: "Ouverture de l’information",
    question: "En matière criminelle, l’ouverture d’une information est :",
    options: [
      "Interdite",
      "Facultative",
      "Obligatoire",
      "Subordonnée à l’accord de la partie civile",
    ],
    answer: "Obligatoire",
    explanation:
        "L’article 79 C. proc. pén. rend l’information obligatoire en matière criminelle, compte tenu de la gravité des faits.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Ouverture de l’information",
    question:
        "En matière délictuelle, l’instruction préparatoire est en principe :",
    options: [
      "Obligatoire",
      "Facultative",
      "Interdite",
      "Réservée aux délits de presse uniquement",
    ],
    answer: "Facultative",
    explanation:
        "En matière délictuelle, l’information est facultative, sauf dispositions spéciales, et utilisée notamment en cas de complexité ou d’auteur inconnu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Ouverture de l’information",
    question:
        "Dans quel cas l’information est-elle ouverte pour une contravention ?",
    options: [
      "Jamais",
      "Uniquement sur constitution de partie civile",
      "Uniquement sur réquisition du procureur de la République",
      "Sur initiative du juge d’instruction",
    ],
    answer: "Uniquement sur réquisition du procureur de la République",
    explanation:
        "Pour les contraventions, l’article 79 C. proc. pén. subordonne l’ouverture de l’information aux réquisitions du parquet.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Ouverture de l’information",
    question:
        "Le juge d’instruction peut-il se saisir d’office d’une affaire pénale ?",
    options: [
      "Oui, dans tous les cas",
      "Oui, uniquement en matière criminelle",
      "Non, il doit être saisi par le parquet ou la victime",
      "Oui, sur accord du président du tribunal",
    ],
    answer: "Non, il doit être saisi par le parquet ou la victime",
    explanation:
        "Le juge d’instruction ne peut se saisir lui-même : il est saisi par réquisitoire du parquet ou par plainte avec constitution de partie civile de la victime.",
    difficulty: "Facile",
  ),

  // ================== SAISINE & EFFETS ==================
  QuizQuestion(
    category: "Saisine du juge d’instruction",
    question:
        "Comment décrit-on la nature de la saisine du juge d’instruction lorsqu’il ne peut instruire que sur les faits visés dans l’acte de saisine ?",
    options: [
      "Il est saisi in persona",
      "Il est saisi in rem",
      "Il est saisi in facto",
      "Il est saisi in abstracto",
    ],
    answer: "Il est saisi in rem",
    explanation:
        "On dit que le juge est saisi in rem : il ne peut instruire que sur les faits spécifiés par le réquisitoire ou la plainte.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Saisine du juge d’instruction",
    question:
        "Que doit faire le juge d’instruction s’il découvre des faits nouveaux au cours de l’information ?",
    options: [
      "Les instruire directement sans formalité",
      "Les transmettre au J.L.D.",
      "Les dénoncer au procureur de la République",
      "Les classer sans suite lui-même",
    ],
    answer: "Les dénoncer au procureur de la République",
    explanation:
        "Conformément à l’article 80 C. proc. pén., le juge doit dénoncer les faits nouveaux au procureur, qui décidera de la suite (réquisitoire supplétif, nouvelle info, classement…).",
    difficulty: "Moyenne",
  ),

  // ================== POUVOIRS D’INVESTIGATION – CONSTATATIONS ==================
  QuizQuestion(
    category: "Pouvoirs du juge — Constatations matérielles",
    question:
        "Que permet l’article 92 du Code de procédure pénale au juge d’instruction ?",
    options: [
      "Se déplacer sur les lieux pour toutes constatations utiles",
      "Déléguer systématiquement toutes constatations aux OPJ",
      "Refuser tout transport sur les lieux",
      "Effectuer des constatations sans greffier ni procès-verbal",
    ],
    answer: "Se déplacer sur les lieux pour toutes constatations utiles",
    explanation:
        "L’article 92 C. proc. pén. autorise le juge à se transporter sur les lieux pour effectuer des constatations ou perquisitions en présence de son greffier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Pouvoirs du juge — Constatations matérielles",
    question:
        "Lorsqu’il se transporte sur les lieux pour procéder à des constatations, qui assiste le juge d’instruction ?",
    options: [
      "Un OPJ uniquement",
      "Le J.L.D.",
      "Son greffier, chargé de rédiger le procès-verbal",
      "Un juré tiré au sort",
    ],
    answer: "Son greffier, chargé de rédiger le procès-verbal",
    explanation:
        "Le greffier accompagne le juge et rédige le procès-verbal des constatations, qui sera signé par le juge et par lui.",
    difficulty: "Facile",
  ),

  // ================== EXPERTISE – DÉTAIL ==================
  QuizQuestion(
    category: "Expertise — Serment et mission",
    question:
        "À quel moment les experts inscrits sur une liste prêtent-ils serment d’« apporter leur concours à la justice en leur honneur et en leur conscience » ?",
    options: [
      "À chaque expertise",
      "Lors de leur inscription sur la liste",
      "Uniquement devant le juge d’instruction",
      "Jamais, ce serment n’existe pas",
    ],
    answer: "Lors de leur inscription sur la liste",
    explanation:
        "Les experts inscrits prêtent serment une fois pour toutes lors de leur inscription sur la liste de la cour d’appel ou de la Cour de cassation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Expertise — Déroulement",
    question:
        "Sous le contrôle de quelle autorité les experts accomplissent-ils leur mission en matière d’instruction préparatoire ?",
    options: [
      "Sous le contrôle exclusif des OPJ",
      "Sous le contrôle du procureur de la République uniquement",
      "Sous le contrôle du juge d’instruction",
      "Sous le contrôle de la partie civile",
    ],
    answer: "Sous le contrôle du juge d’instruction",
    explanation:
        "Les experts agissent sous le contrôle du juge d’instruction, qui doit être informé du déroulement des opérations (art. 156 et 161 C. proc. pén.).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Expertise — Rapport",
    question:
        "Que doit contenir le rapport d’expertise remis au juge d’instruction ?",
    options: [
      "Uniquement les conclusions finales",
      "Les opérations effectuées et les conclusions des experts",
      "Uniquement la liste des personnes entendues",
      "Uniquement une appréciation morale de l’accusé",
    ],
    answer: "Les opérations effectuées et les conclusions des experts",
    explanation:
        "Le rapport doit décrire les opérations réalisées et exposer les conclusions, en mentionnant les personnes ayant assisté les experts.",
    difficulty: "Facile",
  ),

  // ================== TÉMOINS – OBLIGATIONS ==================
  QuizQuestion(
    category: "Auditions — Témoins",
    question:
        "Dans quelles conditions le juge d’instruction peut-il contraindre un témoin à comparaître ?",
    options: [
      "Il ne peut jamais y contraindre",
      "Par la force publique, si le témoin, régulièrement cité, ne comparaît pas",
      "Uniquement avec l’accord de la partie civile",
      "Uniquement avec l’accord du président du tribunal",
    ],
    answer:
        "Par la force publique, si le témoin, régulièrement cité, ne comparaît pas",
    explanation:
        "En vertu de l’article 109 C. proc. pén., le juge peut ordonner l’usage de la force publique pour contraindre un témoin défaillant à comparaître.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Auditions — Témoins",
    question:
        "Quel serment les témoins doivent-ils en principe prêter devant le juge d’instruction ?",
    options: [
      "De dire ce qui les arrange",
      "De garder le secret absolu",
      "De dire « toute la vérité, rien que la vérité »",
      "De ne jamais se contredire",
    ],
    answer: "De dire « toute la vérité, rien que la vérité »",
    explanation:
        "L’article 103 C. proc. pén. prévoit que les témoins prêtent serment de dire la vérité, sauf exceptions (mineurs, proches, etc.).",
    difficulty: "Facile",
  ),

  // ================== TÉMOIN ASSISTÉ – APPROFONDI ==================
  QuizQuestion(
    category: "Témoin assisté — Statut",
    question:
        "Le statut de témoin assisté représente une position intermédiaire entre :",
    options: [
      "La victime et le parquet",
      "Le simple témoin et le mis en examen",
      "Le juré et le juge",
      "Le procureur et le J.L.D.",
    ],
    answer: "Le simple témoin et le mis en examen",
    explanation:
        "Le témoin assisté est soupçonné mais pas encore mis en examen, bénéficiant de garanties accrues sans être pleinement partie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Témoin assisté — Évolution du statut",
    question:
        "Que peut demander à tout moment un témoin assisté au juge d’instruction concernant son statut ?",
    options: [
      "Être considéré comme simple témoin",
      "Être dispensé d’avocat",
      "Sa mise en examen",
      "L’arrêt immédiat de l’enquête",
    ],
    answer: "Sa mise en examen",
    explanation:
        "L’article 113-6 C. proc. pén. permet au témoin assisté de demander sa mise en examen, qui est alors de droit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Témoin assisté — Contraintes",
    question:
        "Le témoin assisté peut-il être placé en détention provisoire au titre de ce statut ?",
    options: [
      "Oui, selon la gravité des faits",
      "Oui, s’il ne se présente pas aux convocations",
      "Non, il ne peut pas être détenu en tant que témoin assisté",
      "Oui, sur décision du parquet uniquement",
    ],
    answer: "Non, il ne peut pas être détenu en tant que témoin assisté",
    explanation:
        "Le témoin assisté ne peut faire l’objet ni de détention provisoire, ni de contrôle judiciaire, ni de renvoi devant une juridiction de jugement (art. 113-5 C. proc. pén.).",
    difficulty: "Difficile",
  ),

  // ================== MISE EN EXAMEN — DÉTAIL ==================
  QuizQuestion(
    category: "Mise en examen — Conditions",
    question:
        "Quelle condition essentielle doit être réunie pour mettre une personne en examen ?",
    options: [
      "Des rumeurs publiques",
      "Des indices graves ou concordants rendant vraisemblable sa participation à l’infraction",
      "Une simple suspicion de la victime",
      "Une dénonciation anonyme",
    ],
    answer:
        "Des indices graves ou concordants rendant vraisemblable sa participation à l’infraction",
    explanation:
        "L’article 80-1 C. proc. pén. exige des indices graves ou concordants pour justifier une mise en examen.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Mise en examen — Effets",
    question: "Une fois mise en examen, la personne :",
    options: [
      "Perd tous ses droits de la défense",
      "Acquiert des droits procéduraux renforcés (accès au dossier, demandes d’actes, recours)",
      "Ne peut plus être assistée d’un avocat",
      "Ne peut plus faire appel des décisions",
    ],
    answer:
        "Acquiert des droits procéduraux renforcés (accès au dossier, demandes d’actes, recours)",
    explanation:
        "La mise en examen donne à la personne la qualité de partie à la procédure et lui confère des droits importants d’intervention.",
    difficulty: "Facile",
  ),

  // ================== PARTIE CIVILE ==================
  QuizQuestion(
    category: "Partie civile — Actions",
    question:
        "Quel est l’un des effets principaux de la constitution de partie civile pour la victime ?",
    options: [
      "Elle dirige l’instruction à la place du juge",
      "Elle devient partie à la procédure et peut demander des actes",
      "Elle remplace le ministère public",
      "Elle obtient automatiquement une indemnisation",
    ],
    answer: "Elle devient partie à la procédure et peut demander des actes",
    explanation:
        "La partie civile dispose de droits procéduraux (demandes d’actes, requêtes en nullité, appels, etc.) qu’une simple victime n’a pas.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Partie civile — Consignation",
    question:
        "En cas de plainte avec constitution de partie civile initiant l’action publique, quelle obligation financière peut peser sur la victime ?",
    options: [
      "Le paiement anticipé des dommages-intérêts",
      "Le versement d’une consignation fixée par le juge d’instruction",
      "Le paiement des frais d’enquête de police",
      "Le paiement d’une amende automatique",
    ],
    answer: "Le versement d’une consignation fixée par le juge d’instruction",
    explanation:
        "La consignation vise à prévenir les constitutions abusives ; elle peut être remboursée ou non selon l’issue de la procédure.",
    difficulty: "Difficile",
  ),

  // ================== CLÔTURE DE L’INSTRUCTION ==================
  QuizQuestion(
    category: "Clôture — Moment",
    question:
        "À quel moment le juge d’instruction communique-t-il le dossier au procureur de la République pour avis sur les suites à donner ?",
    options: [
      "Dès l’ouverture de l’information",
      "Dès le premier interrogatoire",
      "Lorsque l’information lui paraît terminée",
      "Uniquement en cas de non-lieu envisagé",
    ],
    answer: "Lorsque l’information lui paraît terminée",
    explanation:
        "Lorsque le juge estime que tous les actes utiles ont été réalisés, il communique le dossier au parquet avant de prendre une ordonnance de règlement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Clôture — Demande des parties",
    question:
        "Qui peut demander la clôture de l’instruction sur le fondement de l’article 175-1 du Code de procédure pénale ?",
    options: [
      "Uniquement le parquet",
      "La personne mise en examen, le témoin assisté ou la partie civile",
      "Uniquement la partie civile",
      "Uniquement la personne détenue",
    ],
    answer: "La personne mise en examen, le témoin assisté ou la partie civile",
    explanation:
        "Ces trois catégories peuvent demander au juge de clore l’instruction, notamment lorsque aucun acte n’a été accompli depuis 4 mois.",
    difficulty: "Moyenne",
  ),

  // ================== ORDONNANCES DE RÈGLEMENT — SUITE ==================
  QuizQuestion(
    category: "Ordonnances de règlement",
    question:
        "Quel est l’effet principal d’une ordonnance de règlement sur la compétence du juge d’instruction ?",
    options: [
      "Elle lui permet de poursuivre l’enquête",
      "Elle le dessaisit de l’affaire",
      "Elle le rend compétent pour juger l’affaire",
      "Elle l’autorise à prononcer la peine",
    ],
    answer: "Elle le dessaisit de l’affaire",
    explanation:
        "L’ordonnance de règlement met fin à la mission d’instruction du juge, qui est dessaisi au profit de la juridiction de jugement ou d’un non-lieu.",
    difficulty: "Facile",
  ),

  // ================== CHAMBRE DE L’INSTRUCTION — RÔLE PRATIQUE ==================
  QuizQuestion(
    category: "Chambre de l’instruction — Contrôle",
    question:
        "Quel est le rôle central de la chambre de l’instruction lorsqu’elle est saisie d’un recours ?",
    options: [
      "Prononcer directement des peines",
      "Contrôler la régularité de la procédure et annuler les actes entachés de nullité",
      "Remplacer le juge d’instruction dans tous les dossiers",
      "Organiser la publicité médiatique des affaires",
    ],
    answer:
        "Contrôler la régularité de la procédure et annuler les actes entachés de nullité",
    explanation:
        "La chambre de l’instruction exerce un contrôle de légalité sur la procédure, pouvant confirmer, infirmer ou annuler les actes (art. 206 C. proc. pén.).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Généralités — Instruction préparatoire",
    question:
        "Quel est l’un des objectifs majeurs de l’instruction préparatoire pour la juridiction de jugement ?",
    options: [
      "Lui éviter d’avoir à juger",
      "Lui présenter un dossier complet et éclairé sur les faits et les personnes",
      "Remplacer le rôle du ministère public",
      "Protéger uniquement la réputation de l’accusé",
    ],
    answer:
        "Lui présenter un dossier complet et éclairé sur les faits et les personnes",
    explanation:
        "L’instruction préparatoire prépare le jugement en réunissant des éléments sur les faits, la culpabilité éventuelle et la personnalité des intéressés.",
    difficulty: "Facile",
  ),

  // 2
  QuizQuestion(
    category: "Généralités — Instruction préparatoire",
    question:
        "Dans quel cas l’instruction préparatoire est-elle considérée comme un « second degré » d’instruction ?",
    options: [
      "Devant le juge d’instruction",
      "Devant la chambre de l’instruction",
      "Devant le tribunal correctionnel",
      "Devant le juge des libertés et de la détention",
    ],
    answer: "Devant la chambre de l’instruction",
    explanation:
        "L’instruction préparatoire est à deux degrés : premier degré devant le juge d’instruction, second degré devant la chambre de l’instruction.",
    difficulty: "Facile",
  ),

  // 3
  QuizQuestion(
    category: "Généralités — Instruction préparatoire",
    question:
        "Quel type de procédure inspire principalement l’instruction préparatoire ?",
    options: [
      "La procédure accusatoire",
      "La procédure inquisitoire",
      "La procédure arbitrale",
      "La procédure administrative",
    ],
    answer: "La procédure inquisitoire",
    explanation:
        "L’instruction préparatoire s’inspire de la procédure inquisitoire : écrite, secrète et initialement non contradictoire, même si ces caractères sont aujourd’hui atténués.",
    difficulty: "Facile",
  ),

  // 4
  QuizQuestion(
    category: "Caractères — Procédure écrite",
    question: "Pourquoi dit-on que la procédure d’instruction est « écrite » ?",
    options: [
      "Parce que seule la victime peut déposer une plainte écrite",
      "Parce que tous les actes et décisions sont consignés dans un dossier",
      "Parce que les audiences sont filmées puis retranscrites",
      "Parce que les témoins répondent par écrit uniquement",
    ],
    answer:
        "Parce que tous les actes et décisions sont consignés dans un dossier",
    explanation:
        "Les actes d’instruction et les décisions sont réunis dans un dossier, ce qui caractérise la dimension écrite de la procédure.",
    difficulty: "Facile",
  ),

  // 5
  QuizQuestion(
    category: "Caractères — Procédure écrite",
    question:
        "Quel est l’intérêt, pour l’administration de la justice, d’avoir un dossier écrit d’instruction en plusieurs exemplaires ou copies ?",
    options: [
      "Pouvoir les vendre à la presse",
      "Faciliter la transmission aux différentes autorités sans immobiliser l’original",
      "Éviter que le juge ne voie le dossier",
      "Rendre les débats publics plus animés",
    ],
    answer:
        "Faciliter la transmission aux différentes autorités sans immobiliser l’original",
    explanation:
        "Les copies permettent aux différentes juridictions et au parquet d’examiner le dossier sans ralentir le travail du juge d’instruction.",
    difficulty: "Moyenne",
  ),

  // 6
  QuizQuestion(
    category: "Caractères — Secret de l’instruction",
    question:
        "Pour quelle raison principale l’instruction est-elle secrète à l’égard du public ?",
    options: [
      "Pour protéger l’image de la police",
      "Pour préserver la présomption d’innocence, la sérénité des investigations et les droits des parties",
      "Pour empêcher les victimes de s’informer",
      "Pour favoriser la médiatisation ultérieure du procès",
    ],
    answer:
        "Pour préserver la présomption d’innocence, la sérénité des investigations et les droits des parties",
    explanation:
        "Le secret protège la recherche de la vérité et les droits fondamentaux, notamment la présomption d’innocence.",
    difficulty: "Moyenne",
  ),

  // 7
  QuizQuestion(
    category: "Caractères — Secret de l’instruction",
    question:
        "Les avocats des parties ont-ils accès au dossier d’instruction malgré le secret ?",
    options: [
      "Non, jamais",
      "Oui, uniquement à la fin de l’instruction",
      "Oui, ils ont un accès étendu au dossier à tout moment de la procédure",
      "Uniquement avec l’autorisation de la partie civile",
    ],
    answer:
        "Oui, ils ont un accès étendu au dossier à tout moment de la procédure",
    explanation:
        "Les avocats peuvent consulter le dossier pour assurer efficacement la défense, ce qui constitue une atténuation du secret.",
    difficulty: "Facile",
  ),

  // 8
  QuizQuestion(
    category: "Caractères — Non contradictoire",
    question:
        "Quel droit illustre l’introduction d’éléments contradictoires dans l’instruction préparatoire ?",
    options: [
      "Le droit pour la presse d’assister à tous les interrogatoires",
      "Le droit des parties de demander au juge d’accomplir certains actes",
      "Le droit des OPJ de refuser les commissions rogatoires",
      "Le droit du juge de refuser un avocat",
    ],
    answer:
        "Le droit des parties de demander au juge d’accomplir certains actes",
    explanation:
        "Les parties peuvent formuler des demandes d’actes, de confrontations, de perquisitions, etc., ce qui renforce le contradictoire.",
    difficulty: "Moyenne",
  ),

  // 9
  QuizQuestion(
    category: "Ouverture de l’information",
    question:
        "Pourquoi l’information est-elle obligatoire en matière criminelle ?",
    options: [
      "Parce que les crimes intéressent davantage les médias",
      "Parce que les crimes sont jugés uniquement par les juges d’instruction",
      "En raison de la gravité des faits et de la nécessité de réunir de nombreux éléments sur les faits et la personnalité",
      "Pour éviter le recours à la police judiciaire",
    ],
    answer:
        "En raison de la gravité des faits et de la nécessité de réunir de nombreux éléments sur les faits et la personnalité",
    explanation:
        "L’information obligatoire en matière criminelle permet une investigation approfondie sur les faits et la personnalité de l’auteur présumé.",
    difficulty: "Facile",
  ),

  // 10
  QuizQuestion(
    category: "Ouverture de l’information",
    question:
        "Dans quelle situation une plainte avec constitution de partie civile peut-elle provoquer l’ouverture d’une information ?",
    options: [
      "Uniquement pour les contraventions",
      "Pour les crimes et délits, si la plainte est régulière et recevable",
      "Uniquement si le procureur a déjà fait un classement sans suite",
      "Uniquement si le juge des libertés et de la détention le demande",
    ],
    answer:
        "Pour les crimes et délits, si la plainte est régulière et recevable",
    explanation:
        "La plainte avec constitution de partie civile devant le juge d’instruction peut déclencher l’information en matière criminelle ou délictuelle.",
    difficulty: "Moyenne",
  ),

  // 11
  QuizQuestion(
    category: "Ouverture de l’information",
    question:
        "Quelle est la règle en matière d’ouverture d’information pour les contraventions ?",
    options: [
      "L’information est interdite",
      "L’information est toujours obligatoire",
      "L’information ne peut être ouverte que sur réquisition du procureur de la République",
      "Le juge d’instruction peut se saisir d’office",
    ],
    answer:
        "L’information ne peut être ouverte que sur réquisition du procureur de la République",
    explanation:
        "En contravention, l’article 79 C. proc. pén. subordonne l’ouverture de l’information au réquisitoire du parquet.",
    difficulty: "Moyenne",
  ),

  // 12
  QuizQuestion(
    category: "Saisine — Ministère public",
    question:
        "Comment le procureur de la République saisit-il le juge d’instruction pour ouvrir une information ?",
    options: [
      "Par simple note téléphonique",
      "Par réquisitoire à fin d’informer",
      "Par lettre recommandée à la partie civile",
      "Par décision orale à l’audience",
    ],
    answer: "Par réquisitoire à fin d’informer",
    explanation:
        "Le réquisitoire introductif est l’acte écrit et daté par lequel le parquet saisit le juge d’instruction en précisant les faits.",
    difficulty: "Facile",
  ),

  // 13
  QuizQuestion(
    category: "Saisine — Victime",
    question:
        "Quelle condition de recevabilité peut être exigée d’une victime qui dépose une plainte avec constitution de partie civile ?",
    options: [
      "Avoir déjà été entendue comme témoin",
      "Justifier d’un classement sans suite ou d’un délai de 3 mois après plainte au procureur",
      "Pouvoir payer immédiatement les dommages-intérêts",
      "Obtenir l’accord du mis en examen",
    ],
    answer:
        "Justifier d’un classement sans suite ou d’un délai de 3 mois après plainte au procureur",
    explanation:
        "La victime doit en principe attendre un classement sans suite ou l’écoulement de 3 mois après sa plainte simple au parquet.",
    difficulty: "Difficile",
  ),

  // 14
  QuizQuestion(
    category: "Conséquences de la saisine",
    question:
        "Que signifie le fait que le juge d’instruction soit saisi « in rem » ?",
    options: [
      "Qu’il est saisi uniquement de la personne",
      "Qu’il est saisi des faits indiqués dans l’acte de saisine",
      "Qu’il est saisi de toutes les infractions commises par la personne",
      "Qu’il ne peut jamais étendre la procédure",
    ],
    answer: "Qu’il est saisi des faits indiqués dans l’acte de saisine",
    explanation:
        "La saisine in rem signifie que le juge est limité aux faits visés par le réquisitoire ou la plainte, et non à la personne elle-même.",
    difficulty: "Moyenne",
  ),

  // 15
  QuizQuestion(
    category: "Conséquences de la saisine",
    question:
        "Quelle est l’une des possibilités offertes au procureur de la République lorsque le juge lui signale des faits nouveaux (art. 80 C. proc. pén.) ?",
    options: [
      "Classer sans suite, ouvrir une nouvelle information ou prendre un réquisitoire supplétif",
      "Sanctionner le juge d’instruction",
      "Se dessaisir de toutes ses affaires",
      "Saisir directement le tribunal criminel sans instruction",
    ],
    answer:
        "Classer sans suite, ouvrir une nouvelle information ou prendre un réquisitoire supplétif",
    explanation:
        "Le parquet choisit la suite à donner : réquisitoire supplétif, nouvelle information, poursuites directes ou classement.",
    difficulty: "Moyenne",
  ),

  // 16
  QuizQuestion(
    category: "Pouvoirs — Constatations matérielles",
    question:
        "Pourquoi le juge d’instruction peut-il se transporter sur les lieux d’une infraction ?",
    options: [
      "Pour interroger les jurés",
      "Pour y effectuer des constatations utiles ou des perquisitions",
      "Pour rencontrer la presse",
      "Pour remplacer le travail de la police municipale",
    ],
    answer: "Pour y effectuer des constatations utiles ou des perquisitions",
    explanation:
        "Le transport sur les lieux permet au juge de compléter ou confirmer les constatations déjà réalisées par les enquêteurs.",
    difficulty: "Facile",
  ),

  // 17
  QuizQuestion(
    category: "Pouvoirs — Constatations matérielles",
    question:
        "Lorsqu’il se transporte sur les lieux dans le cadre d’une commission rogatoire, le juge d’instruction :",
    options: [
      "Doit toujours être accompagné de son greffier",
      "Ne doit pas accomplir lui-même d’actes d’instruction",
      "Peut décider seul de nouvelles mises en examen sur place",
      "Peut prononcer la peine sur les lieux",
    ],
    answer: "Ne doit pas accomplir lui-même d’actes d’instruction",
    explanation:
        "En contrôlant l’exécution d’une commission rogatoire, il dirige sans réaliser lui-même d’actes, ce rôle appartenant à l’OPJ désigné.",
    difficulty: "Difficile",
  ),

  // 18
  QuizQuestion(
    category: "Expertise — Initiative",
    question:
        "Qui peut être à l’initiative d’une demande d’expertise en matière d’instruction préparatoire ?",
    options: [
      "Uniquement le juge d’instruction",
      "Uniquement la partie civile",
      "Le parquet, le juge d’instruction, l’une des parties ou le témoin assisté",
      "Uniquement le mis en examen",
    ],
    answer:
        "Le parquet, le juge d’instruction, l’une des parties ou le témoin assisté",
    explanation:
        "L’article 156 C. proc. pén. permet à ces différents acteurs de solliciter une expertise lorsque des questions techniques se posent.",
    difficulty: "Moyenne",
  ),

  // 19
  QuizQuestion(
    category: "Expertise — Choix de l’expert",
    question:
        "En principe, parmi qui le juge d’instruction choisit-il les experts ?",
    options: [
      "Parmi des personnes tirées au sort",
      "Parmi des policiers désignés par le préfet",
      "Parmi les personnes inscrites sur une liste nationale ou de cour d’appel",
      "Parmi les membres du jury criminel",
    ],
    answer:
        "Parmi les personnes inscrites sur une liste nationale ou de cour d’appel",
    explanation:
        "Les experts sont choisis sur des listes officielles d’experts judiciaires, sauf technicité particulière justifiant un choix hors liste.",
    difficulty: "Facile",
  ),

  // 20
  QuizQuestion(
    category: "Expertise — Rapport",
    question:
        "Que se passe-t-il une fois le rapport d’expertise remis au greffe ?",
    options: [
      "Il est détruit après lecture",
      "Il donne automatiquement lieu à un non-lieu",
      "Il est versé au dossier et peut être communiqué aux parties",
      "Il remplace tous les procès-verbaux d’enquête",
    ],
    answer: "Il est versé au dossier et peut être communiqué aux parties",
    explanation:
        "Le rapport devient une pièce importante du dossier d’instruction et les parties peuvent en prendre connaissance.",
    difficulty: "Facile",
  ),

  // 21
  QuizQuestion(
    category: "Auditions — Témoins",
    question:
        "Quelles informations essentielles le juge doit-il vérifier au début de l’audition d’un témoin ?",
    options: [
      "Son casier judiciaire uniquement",
      "Son identité, ses liens éventuels avec les parties et, le cas échéant, sa profession",
      "Son opinion sur la culpabilité de la personne mise en examen",
      "Son appartenance à un parti politique",
    ],
    answer:
        "Son identité, ses liens éventuels avec les parties et, le cas échéant, sa profession",
    explanation:
        "Ces éléments figurent au procès-verbal et permettent d’apprécier la crédibilité ou les éventuels conflits d’intérêts.",
    difficulty: "Moyenne",
  ),

  // 22
  QuizQuestion(
    category: "Auditions — Témoins",
    question: "Quels témoins sont dispensés de prêter serment ?",
    options: [
      "Tous les témoins de moins de 25 ans",
      "Les mineurs de moins de 16 ans et certains proches de la personne mise en examen",
      "Uniquement les experts",
      "Uniquement les victimes",
    ],
    answer:
        "Les mineurs de moins de 16 ans et certains proches de la personne mise en examen",
    explanation:
        "L’article 108 C. proc. pén. dispense de serment les mineurs de moins de 16 ans et plusieurs catégories de proches (parents, conjoints, etc.).",
    difficulty: "Moyenne",
  ),

  // 23
  QuizQuestion(
    category: "Auditions — Témoins",
    question:
        "Quelle est la sanction pénale prévue pour le témoin régulièrement cité qui, sans excuse légitime, refuse de comparaître ou de déposer ?",
    options: [
      "Une simple admonestation",
      "Une amende de 3 750 €",
      "Une peine de prison automatique",
      "La nullité de la procédure",
    ],
    answer: "Une amende de 3 750 €",
    explanation:
        "L’article 434-15-1 du Code pénal prévoit cette amende pour sanctionner la défaillance du témoin.",
    difficulty: "Difficile",
  ),

  // 24
  QuizQuestion(
    category: "Témoin assisté — Obligations",
    question:
        "Le témoin assisté régulièrement convoqué devant le juge d’instruction est-il tenu de comparaître ?",
    options: [
      "Non, il peut refuser sans conséquence",
      "Oui, et il peut y être contraint par la force publique",
      "Oui, mais uniquement si la partie civile le demande",
      "Non, car il est considéré comme partie",
    ],
    answer: "Oui, et il peut y être contraint par la force publique",
    explanation:
        "L’article 113-4 renvoie aux dispositions de l’article 109, permettant la contrainte par la force publique et la sanction du témoin assisté défaillant.",
    difficulty: "Difficile",
  ),

  // 25
  QuizQuestion(
    category: "Témoin assisté — Droits",
    question: "Le témoin assisté a-t-il accès au dossier d’instruction ?",
    options: [
      "Non, contrairement au mis en examen",
      "Oui, par l’intermédiaire de son avocat",
      "Uniquement après la clôture",
      "Uniquement si le procureur l’accepte",
    ],
    answer: "Oui, par l’intermédiaire de son avocat",
    explanation:
        "Le témoin assisté, avec son avocat, peut consulter le dossier, ce qui renforce ses droits de la défense.",
    difficulty: "Moyenne",
  ),

  // 26
  QuizQuestion(
    category: "Témoin assisté — Limites",
    question:
        "Quelles mesures ne peuvent pas être prononcées à l’encontre d’un témoin assisté en raison de son statut ?",
    options: [
      "Une expertise psychiatrique",
      "Un contrôle judiciaire, une assignation à résidence avec surveillance électronique ou une détention provisoire",
      "Une audition en présence d’un avocat",
      "Une convocation devant le juge d’instruction",
    ],
    answer:
        "Un contrôle judiciaire, une assignation à résidence avec surveillance électronique ou une détention provisoire",
    explanation:
        "Ces mesures de contrainte sont réservées au mis en examen et ne peuvent viser un témoin assisté (art. 113-5 C. proc. pén.).",
    difficulty: "Difficile",
  ),

  // 27
  QuizQuestion(
    category: "Mise en examen — Procédure",
    question:
        "Lors de l’interrogatoire de première comparution, quelle garantie essentielle doit être donnée à la personne dont la mise en examen est envisagée ?",
    options: [
      "L’assurance qu’elle ne sera jamais condamnée",
      "L’information complète de ses droits, notamment d’être assistée d’un avocat et de se taire",
      "La possibilité de choisir son juge",
      "La possibilité d’exclure la partie civile",
    ],
    answer:
        "L’information complète de ses droits, notamment d’être assistée d’un avocat et de se taire",
    explanation:
        "L’article 116 C. proc. pén. impose d’informer la personne de ses droits avant toute décision de mise en examen.",
    difficulty: "Moyenne",
  ),

  // 28
  QuizQuestion(
    category: "Mise en examen — Effets",
    question: "La mise en examen permet notamment :",
    options: [
      "De juger immédiatement la personne",
      "De conférer à la personne des droits étendus au dossier et à la contestation de la procédure",
      "D’empêcher tout appel",
      "De l’exclure des débats",
    ],
    answer:
        "De conférer à la personne des droits étendus au dossier et à la contestation de la procédure",
    explanation:
        "La personne mise en examen devient partie, pouvant consulter le dossier, demander des actes et former divers recours.",
    difficulty: "Facile",
  ),

  // 29
  QuizQuestion(
    category: "Partie civile — Conditions",
    question:
        "La constitution de partie civile initiale devant le juge d’instruction (art. 85 C. proc. pén.) est possible :",
    options: [
      "Pour tout type d’infraction, y compris les contraventions, même sans action publique",
      "Pour les crimes et délits, lorsqu’elle initie l’action publique",
      "Uniquement si l’auteur est identifié",
      "Uniquement après un jugement de relaxe",
    ],
    answer: "Pour les crimes et délits, lorsqu’elle initie l’action publique",
    explanation:
        "La constitution de partie civile initiale permet à la victime de déclencher l’information pour les crimes et délits.",
    difficulty: "Difficile",
  ),

  // 30
  QuizQuestion(
    category: "Partie civile — Effets procéduraux",
    question:
        "Quel droit important la partie civile obtient-elle en matière d’actes d’instruction ?",
    options: [
      "Celui de mener elle-même les auditions",
      "Celui d’imposer une expertise",
      "Celui de demander la réalisation ou l’annulation de certains actes",
      "Celui de substituer le parquet dans ses fonctions",
    ],
    answer:
        "Celui de demander la réalisation ou l’annulation de certains actes",
    explanation:
        "La partie civile peut formuler des demandes d’actes et des requêtes en nullité, ce qui lui donne un rôle actif dans l’instruction.",
    difficulty: "Moyenne",
  ),

  // 31
  QuizQuestion(
    category: "Clôture — Demande des parties",
    question:
        "Après quelle durée d’inertie procédurale les parties peuvent-elles demander la clôture de l’information (art. 175-1 C. proc. pén.) ?",
    options: [
      "1 mois sans acte",
      "2 mois sans acte",
      "4 mois sans acte",
      "12 mois sans acte",
    ],
    answer: "4 mois sans acte",
    explanation:
        "Si aucun acte n’a été accompli pendant 4 mois, la personne mise en examen, le témoin assisté ou la partie civile peuvent demander la clôture.",
    difficulty: "Moyenne",
  ),

  // 32
  QuizQuestion(
    category: "Clôture — Réponse du juge",
    question:
        "Dans quel délai le juge d’instruction doit-il répondre par ordonnance à une demande de clôture fondée sur l’article 175-1 ?",
    options: ["48 heures", "8 jours", "Un mois", "Six mois"],
    answer: "Un mois",
    explanation:
        "Le juge doit statuer par ordonnance motivée dans le délai d’un mois suivant la demande de clôture.",
    difficulty: "Difficile",
  ),

  // 33
  QuizQuestion(
    category: "Ordonnances de règlement — Renvoi",
    question:
        "Quel est l’effet d’une ordonnance de renvoi devenue définitive sur les vices de la procédure, que les parties pouvaient connaître ?",
    options: [
      "Elle laisse subsister tous les vices",
      "Elle couvre les vices de la procédure, sauf ceux que les parties ne pouvaient connaître",
      "Elle annule automatiquement la procédure",
      "Elle empêche tout jugement",
    ],
    answer:
        "Elle couvre les vices de la procédure, sauf ceux que les parties ne pouvaient connaître",
    explanation:
        "En principe, une fois définitive, l’ordonnance de renvoi purge les vices connus ou connaissables, sauf exceptions prévues par la loi.",
    difficulty: "Difficile",
  ),

  // 34
  QuizQuestion(
    category: "Ordonnances de règlement — Non-lieu",
    question: "Dans quel cas le juge rend-il une ordonnance de non-lieu ?",
    options: [
      "Lorsque les faits commencent à être médiatisés",
      "Lorsque les faits ne constituent pas une infraction, l’auteur est inconnu ou les charges sont insuffisantes",
      "Lorsque la victime retire sa plainte",
      "Lorsque le parquet le lui impose",
    ],
    answer:
        "Lorsque les faits ne constituent pas une infraction, l’auteur est inconnu ou les charges sont insuffisantes",
    explanation:
        "Le non-lieu intervient lorsque la poursuite ne peut être légalement ou factuellement justifiée.",
    difficulty: "Facile",
  ),

  // 35
  QuizQuestion(
    category: "Ordonnances de règlement — Charges nouvelles",
    question:
        "Que sont des « charges nouvelles » au sens de l’article 189 du Code de procédure pénale ?",
    options: [
      "Des faits entièrement étrangers à la procédure",
      "Des moyens de preuve qui auraient dû être détruits",
      "Des déclarations, pièces ou PV non soumis au juge et susceptibles de renforcer les charges ou d’apporter des développements utiles",
      "Des rumeurs rapportées par la presse",
    ],
    answer:
        "Des déclarations, pièces ou PV non soumis au juge et susceptibles de renforcer les charges ou d’apporter des développements utiles",
    explanation:
        "Ces éléments nouveaux peuvent justifier la réouverture d’une information après un non-lieu.",
    difficulty: "Difficile",
  ),

  // 36
  QuizQuestion(
    category: "Ordonnances de règlement — Effets non-lieu",
    question:
        "Quel est l’effet principal d’une ordonnance de non-lieu sur l’action publique ?",
    options: [
      "Elle suspend l’action publique",
      "Elle arrête l’action publique, sauf charges nouvelles",
      "Elle oblige le parquet à poursuivre devant le tribunal",
      "Elle transforme l’affaire en contravention",
    ],
    answer: "Elle arrête l’action publique, sauf charges nouvelles",
    explanation:
        "Le non-lieu met fin à l’action publique, sauf en cas de survenance de charges nouvelles permettant une nouvelle information.",
    difficulty: "Moyenne",
  ),

  // 37
  QuizQuestion(
    category: "Ordonnances de règlement — Réparation détention",
    question:
        "Quel droit spécifique a le bénéficiaire d’un non-lieu ayant subi une détention provisoire ?",
    options: [
      "Demander automatiquement la relaxe de tous ses co-mis en examen",
      "Demander à l’État réparation du préjudice causé par la détention",
      "Obtenir immédiatement la radiation de son casier judiciaire",
      "Obtenir la destitution du juge d’instruction",
    ],
    answer: "Demander à l’État réparation du préjudice causé par la détention",
    explanation:
        "Les articles 149 et suivants C. proc. pén. permettent une indemnisation par l’État en cas de détention provisoire injustifiée.",
    difficulty: "Difficile",
  ),

  // 38
  QuizQuestion(
    category: "Chambre de l’instruction — Appels",
    question:
        "Parmi les compétences suivantes, laquelle relève de la chambre de l’instruction ?",
    options: [
      "Juger en première instance les délits",
      "Statuer sur l’appel des ordonnances du juge d’instruction",
      "Prononcer la peine en matière criminelle",
      "Diriger la police judiciaire",
    ],
    answer: "Statuer sur l’appel des ordonnances du juge d’instruction",
    explanation:
        "La chambre de l’instruction connaît notamment des appels des ordonnances du juge d’instruction et du JLD.",
    difficulty: "Facile",
  ),

  // 39
  QuizQuestion(
    category: "Chambre de l’instruction — Nullités",
    question:
        "Qui est compétent pour prononcer la nullité d’un acte d’instruction ?",
    options: [
      "L’OPJ ayant rédigé l’acte",
      "Le juge d’instruction lui-même",
      "La chambre de l’instruction",
      "Le greffier",
    ],
    answer: "La chambre de l’instruction",
    explanation:
        "Seule la chambre de l’instruction peut annuler un acte de procédure d’instruction (art. 206 C. proc. pén.).",
    difficulty: "Moyenne",
  ),

  // 40
  QuizQuestion(
    category: "Chambre de l’instruction — Révision",
    question:
        "Dans quel contexte la chambre de l’instruction exerce-t-elle surtout son pouvoir de révision ?",
    options: [
      "Lorsqu’elle statue sur la peine",
      "Lors de l’appel d’une ordonnance de règlement",
      "Lorsqu’elle juge un délit routier",
      "Lorsqu’elle statue sur la compétence territoriale",
    ],
    answer: "Lors de l’appel d’une ordonnance de règlement",
    explanation:
        "À cette occasion, elle peut ordonner un supplément d’information et faire reprendre des investigations (art. 205 C. proc. pén.).",
    difficulty: "Difficile",
  ),

  // 41
  QuizQuestion(
    category: "Chambre de l’instruction — Évocation",
    question: "Le droit d’évocation permet à la chambre de l’instruction :",
    options: [
      "De juger l’affaire au fond",
      "De dessaisir le juge d’instruction et de poursuivre elle-même l’instruction",
      "De remplacer définitivement le ministère public",
      "De prononcer la peine à l’égard de la personne mise en examen",
    ],
    answer:
        "De dessaisir le juge d’instruction et de poursuivre elle-même l’instruction",
    explanation:
        "La chambre peut prendre en charge le dossier pour accomplir certains actes ou l’ensemble de l’information (art. 207 C. proc. pén.).",
    difficulty: "Moyenne",
  ),

  // 42
  QuizQuestion(
    category: "Chambre de l’instruction — Évocation (conditions)",
    question:
        "Parmi les situations suivantes, laquelle peut ouvrir la voie au droit d’évocation de la chambre de l’instruction ?",
    options: [
      "Une simple demande orale de la victime",
      "L’annulation d’un acte de procédure par la chambre",
      "Une demande de la presse",
      "Une plainte déposée devant la police municipale",
    ],
    answer: "L’annulation d’un acte de procédure par la chambre",
    explanation:
        "L’évocation peut intervenir notamment en cas d’annulation, d’infirmation d’une ordonnance (hors détention) ou de durée exagérée de l’instruction.",
    difficulty: "Difficile",
  ),

  // 43
  QuizQuestion(
    category: "Chambre de l’instruction — Alternatives à l’évocation",
    question:
        "Si la chambre de l’instruction n’use pas de son droit d’évocation après une annulation ou une infirmation, que peut-elle décider ?",
    options: [
      "Suspendre définitivement l’enquête",
      "Laisser le juge initialement saisi poursuivre l’information ou confier le dossier à un autre juge",
      "Clore automatiquement l’instruction",
      "Remettre le dossier au JLD",
    ],
    answer:
        "Laisser le juge initialement saisi poursuivre l’information ou confier le dossier à un autre juge",
    explanation:
        "Elle peut organiser la poursuite de l’instruction sans pour autant donner des directives sur le fond au magistrat instructeur.",
    difficulty: "Moyenne",
  ),

  // 44
  QuizQuestion(
    category: "Chambre de l’instruction — Audience de contrôle",
    question:
        "Dans quel contexte une audience de contrôle de la procédure d’instruction peut-elle être organisée devant la chambre de l’instruction (art. 221-3 C. proc. pén.) ?",
    options: [
      "Lorsque la presse le réclame",
      "En cas de détention provisoire d’au moins 3 mois",
      "À chaque fois qu’un témoin le demande",
      "Uniquement pour les contraventions",
    ],
    answer: "En cas de détention provisoire d’au moins 3 mois",
    explanation:
        "Cette audience permet un contrôle global de la procédure lorsque la personne est détenue depuis 3 mois.",
    difficulty: "Difficile",
  ),

  // 45
  QuizQuestion(
    category: "Chambre de l’instruction — Décisions audience de contrôle",
    question:
        "Parmi les décisions suivantes, laquelle peut être prise par la chambre de l’instruction à l’issue d’une audience de contrôle ?",
    options: [
      "Prononcer immédiatement une condamnation pénale",
      "Décider une mise en liberté ou l’annulation d’actes de procédure",
      "Suspendre la procédure civile liée",
      "Nommer directement les jurés d’assises",
    ],
    answer: "Décider une mise en liberté ou l’annulation d’actes de procédure",
    explanation:
        "Les alinéas de l’article 221-3 prévoient plusieurs mesures possibles, dont la mise en liberté, des nullités, l’évocation, etc.",
    difficulty: "Moyenne",
  ),

  // 46
  QuizQuestion(
    category: "Instruction et libertés individuelles",
    question:
        "Que révèle la place croissante des droits de la défense dans l’instruction préparatoire ?",
    options: [
      "Une volonté d’exclure les victimes de la procédure",
      "Une simple formalité symbolique",
      "Un équilibre recherché entre efficacité de l’enquête et respect des libertés",
      "Une volonté de limiter le pouvoir du parquet",
    ],
    answer:
        "Un équilibre recherché entre efficacité de l’enquête et respect des libertés",
    explanation:
        "La procédure se construit autour de cette double exigence, qui impose des garanties et un formalisme précis.",
    difficulty: "Facile",
  ),

  // 47
  QuizQuestion(
    category: "Instruction et commissions rogatoires",
    question:
        "Pourquoi le juge d’instruction recourt-il aux commissions rogatoires ?",
    options: [
      "Pour se décharger totalement de l’enquête",
      "Parce qu’il ne peut jamais interroger lui-même",
      "Parce qu’il ne peut pas toujours accomplir lui-même tous les actes nécessaires et délègue à un autre magistrat ou à un OPJ",
      "Parce que la loi l’y oblige pour toute infraction",
    ],
    answer:
        "Parce qu’il ne peut pas toujours accomplir lui-même tous les actes nécessaires et délègue à un autre magistrat ou à un OPJ",
    explanation:
        "La commission rogatoire permet au juge de faire exécuter certains actes sur l’ensemble du territoire, sous son contrôle.",
    difficulty: "Moyenne",
  ),

  // 48
  QuizQuestion(
    category: "Instruction et OPJ",
    question:
        "Dans le cadre de l’exécution d’une commission rogatoire, l’OPJ peut-il interroger une personne déjà mise en examen dans cette information ?",
    options: [
      "Oui, librement",
      "Oui, s’il en informe le parquet",
      "Non, cela lui est interdit par l’article 152 C. proc. pén.",
      "Oui, uniquement en présence de la partie civile",
    ],
    answer: "Non, cela lui est interdit par l’article 152 C. proc. pén.",
    explanation:
        "L’OPJ ne peut pas interroger ou confronter une personne déjà mise en examen dans l’information pour laquelle la commission est délivrée.",
    difficulty: "Difficile",
  ),

  // 49
  QuizQuestion(
    category: "Instruction et rôle du procureur",
    question:
        "Quel rôle fondamental le procureur de la République joue-t-il dans l’ouverture et l’orientation de l’instruction préparatoire ?",
    options: [
      "Il prononce la peine",
      "Il dirige le greffe du tribunal",
      "Il initie l’information par réquisitoire et peut orienter la suite par réquisitoires supplétifs ou classements",
      "Il est l’avocat obligatoire de la victime",
    ],
    answer:
        "Il initie l’information par réquisitoire et peut orienter la suite par réquisitoires supplétifs ou classements",
    explanation:
        "Le parquet est maître de l’opportunité des poursuites et joue un rôle central dans la saisine et la poursuite de l’instruction.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Généralités — Instruction préparatoire",
    question:
        "Qui mène principalement l’instruction préparatoire au premier degré ?",
    options: [
      "Le juge d’instruction",
      "Le tribunal correctionnel",
      "Le juge des libertés et de la détention",
      "Le procureur général",
    ],
    answer: "Le juge d’instruction",
    explanation:
        "Au premier degré, l’instruction préparatoire est conduite par le juge d’instruction, magistrat du siège.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Généralités — Instruction préparatoire",
    question:
        "Au second degré, qui exerce la fonction de juridiction d’instruction ?",
    options: [
      "Le tribunal de police",
      "La chambre de l’instruction",
      "La cour d’assises",
      "Le juge des enfants",
    ],
    answer: "La chambre de l’instruction",
    explanation:
        "La chambre de l’instruction est la juridiction d’instruction de second degré, au niveau de la cour d’appel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Caractères — Procédure",
    question:
        "Quel est l’un des trois caractères classiques de l’instruction préparatoire ?",
    options: [
      "Orale",
      "Inquisitoire (écrite, secrète, non contradictoire)",
      "Publicitaire",
      "Purement accusatoire",
    ],
    answer: "Inquisitoire (écrite, secrète, non contradictoire)",
    explanation:
        "Traditionnellement, l’instruction est inspirée de la procédure inquisitoire, même si ces caractères sont atténués aujourd’hui.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Caractères — Écrit",
    question: "Quels éléments sont réunis dans le dossier d’instruction ?",
    options: [
      "Uniquement les plaintes",
      "Tous les actes d’instruction et les décisions",
      "Uniquement les auditions des témoins",
      "Seulement les rapports d’expertise",
    ],
    answer: "Tous les actes d’instruction et les décisions",
    explanation:
        "Le dossier regroupe l’ensemble des actes et décisions pour permettre un contrôle complet de la procédure.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Caractères — Secret",
    question: "Le secret de l’instruction s’impose principalement :",
    options: [
      "Aux journalistes uniquement",
      "Au public et à toute personne concourant à la procédure",
      "Aux seules victimes",
      "Au seul juge d’instruction",
    ],
    answer: "Au public et à toute personne concourant à la procédure",
    explanation:
        "L’article 11 C. proc. pén. impose le secret à tous ceux qui concourent à la procédure et à l’égard du public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Caractères — Secret",
    question:
        "Qui peut, dans certains cas, communiquer des informations à la presse pour éviter la diffusion d’informations inexactes ?",
    options: [
      "Le juge d’instruction",
      "Le procureur de la République",
      "Le greffier",
      "Le juge des libertés et de la détention",
    ],
    answer: "Le procureur de la République",
    explanation:
        "L’article 11 al. 3 C. proc. pén. autorise le procureur à communiquer certains éléments pour des raisons d’intérêt public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Ouverture de l’information",
    question: "En matière criminelle, l’ouverture d’une information est :",
    options: [
      "Interdite",
      "Toujours facultative",
      "Obligatoire",
      "Réservée au juge des libertés et de la détention",
    ],
    answer: "Obligatoire",
    explanation:
        "En raison de la gravité des crimes, l’ouverture d’une information est obligatoire pour approfondir les investigations.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Ouverture de l’information",
    question:
        "En matière délictuelle, l’instruction préparatoire est en principe :",
    options: [
      "Obligatoire",
      "Facultative",
      "Interdite",
      "Réservée au juge administratif",
    ],
    answer: "Facultative",
    explanation:
        "En délit, le parquet peut choisir entre poursuite directe et ouverture d’information, sauf dispositions spéciales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Saisine — Juge d’instruction",
    question:
        "Le juge d’instruction peut-il se saisir de lui-même (d’office) ?",
    options: [
      "Oui, librement",
      "Oui, mais uniquement en matière criminelle",
      "Non, il doit être saisi par un acte du parquet ou de la victime",
      "Uniquement avec l’accord du JLD",
    ],
    answer: "Non, il doit être saisi par un acte du parquet ou de la victime",
    explanation:
        "Le juge d’instruction ne peut se saisir d’office, il est saisi par réquisitoire ou plainte avec constitution de partie civile.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Saisine — Ministère public",
    question:
        "Comment appelle-t-on l’acte par lequel le procureur saisit le juge d’instruction ?",
    options: [
      "Mandat de dépôt",
      "Réquisitoire à fin d’informer",
      "Ordonnance de renvoi",
      "Citation directe",
    ],
    answer: "Réquisitoire à fin d’informer",
    explanation:
        "Le réquisitoire introductif est l’acte écrit qui déclenche l’information devant le juge d’instruction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Saisine — Victime",
    question:
        "Par quel acte une victime peut-elle saisir le juge d’instruction ?",
    options: [
      "Une simple lettre non signée",
      "Une plainte avec constitution de partie civile",
      "Un SMS au parquet",
      "Une déclaration orale à la police municipale",
    ],
    answer: "Une plainte avec constitution de partie civile",
    explanation:
        "La plainte avec constitution de partie civile permet à la victime de déclencher une information sous conditions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Pouvoirs du juge — Généralités",
    question: "Le juge d’instruction doit instruire :",
    options: [
      "Uniquement à charge",
      "À charge et à décharge",
      "Uniquement en faveur de la victime",
      "Uniquement en faveur du mis en examen",
    ],
    answer: "À charge et à décharge",
    explanation:
        "Il doit rechercher tous les éléments, qu’ils confirment ou infirment la culpabilité de la personne mise en cause.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Constatations matérielles",
    question:
        "Lorsqu’il se transporte sur les lieux, le juge d’instruction est en principe assisté par :",
    options: [
      "Un juré d’assises",
      "Un OPJ uniquement",
      "Un greffier",
      "Un huissier de justice",
    ],
    answer: "Un greffier",
    explanation:
        "Le greffier dresse procès-verbal des constatations faites sur les lieux par le juge d’instruction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Expertise — Notion",
    question: "À quoi sert l’expertise dans l’instruction préparatoire ?",
    options: [
      "À remplacer le juge",
      "À répondre à des questions techniques nécessitant des compétences spécialisées",
      "À recueillir des aveux",
      "À prononcer la peine",
    ],
    answer:
        "À répondre à des questions techniques nécessitant des compétences spécialisées",
    explanation:
        "Les experts aident le juge sur des aspects techniques (médicaux, scientifiques, comptables, etc.).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Témoins — Généralités",
    question: "Qui le juge d’instruction peut-il faire citer comme témoin ?",
    options: [
      "Uniquement les policiers",
      "Toute personne dont la déposition lui paraît utile",
      "Uniquement la victime",
      "Uniquement le mis en examen",
    ],
    answer: "Toute personne dont la déposition lui paraît utile",
    explanation:
        "L’article 101 C. proc. pén. lui permet de faire citer toute personne susceptible d’éclairer les faits.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Témoins — Serment",
    question: "La formule de serment du témoin est, en principe :",
    options: [
      "« Je promets d’être discret »",
      "« Je jure de dire la vérité, toute la vérité, rien que la vérité »",
      "« Je jure de protéger la victime »",
      "« Je jure de protéger l’enquête »",
    ],
    answer:
        "« Je jure de dire la vérité, toute la vérité, rien que la vérité »",
    explanation:
        "Le serment engage le témoin à une déposition sincère et complète.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Témoin assisté — Notion",
    question: "Le témoin assisté se situe :",
    options: [
      "Entre le simple témoin et le mis en examen",
      "Au-dessus du juge d’instruction",
      "Au même niveau que le parquet",
      "Comme partie civile obligatoire",
    ],
    answer: "Entre le simple témoin et le mis en examen",
    explanation:
        "C’est un statut intermédiaire pour une personne soupçonnée mais pas (encore) mise en examen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Mise en examen — Condition",
    question: "Quelle condition est exigée pour mettre quelqu’un en examen ?",
    options: [
      "Un simple soupçon vague",
      "Des indices graves ou concordants rendant vraisemblable sa participation à l’infraction",
      "Une dénonciation anonyme",
      "Une simple rumeur publique",
    ],
    answer:
        "Des indices graves ou concordants rendant vraisemblable sa participation à l’infraction",
    explanation:
        "L’article 80-1 C. proc. pén. impose ce seuil d’indices pour justifier la mise en examen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Clôture — Rappel",
    question:
        "Que fait le juge d’instruction lorsqu’il estime que l’information est terminée ?",
    options: [
      "Il rend immédiatement un jugement",
      "Il communique le dossier au procureur de la République et avise les parties",
      "Il classe le dossier sans suite",
      "Il transmet au juge de proximité",
    ],
    answer:
        "Il communique le dossier au procureur de la République et avise les parties",
    explanation:
        "C’est le préalable aux ordonnances de règlement (renvoi, non-lieu, etc.).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Chambre de l’instruction — Rôle",
    question: "La chambre de l’instruction statue par :",
    options: ["Jugements", "Arrêts", "Ordonnances", "Simples avis"],
    answer: "Arrêts",
    explanation:
        "En tant que juridiction d’appel de l’instruction, elle statue par arrêts, uniquement susceptibles de cassation.",
    difficulty: "Facile",
  ),

  // ===================== MOYEN (21–40) =====================
  QuizQuestion(
    category: "Caractères — Secret / Publicité",
    question:
        "Dans quel cas certaines audiences se tenant normalement en chambre du conseil peuvent-elles devenir publiques ?",
    options: [
      "Si le juge y consent",
      "Si le procureur le demande",
      "Si l’intéressé le demande",
      "Si un journaliste assiste",
    ],
    answer: "Si l’intéressé le demande",
    explanation:
        "Certaines audiences peuvent être publiques à la demande de l’intéressé (art. 199 C. proc. pén.).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Secret — Sanctions",
    question:
        "Les personnes qui concourent à la procédure d’instruction et ne respectent pas le secret encourent :",
    options: [
      "Une simple remarque orale",
      "Des sanctions pénales pour violation du secret professionnel",
      "Uniquement des sanctions disciplinaires",
      "Aucune sanction",
    ],
    answer: "Des sanctions pénales pour violation du secret professionnel",
    explanation:
        "Le secret de l’instruction est lié au secret professionnel, dont la violation est pénalement réprimée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Journalistes — Limites",
    question:
        "Que risque un journaliste qui publie des actes de procédure avant leur lecture publique à l’audience ?",
    options: [
      "Rien",
      "Une nullité de l’information",
      "Des poursuites sur le fondement de la loi du 29 juillet 1881",
      "La récusation du juge d’instruction",
    ],
    answer: "Des poursuites sur le fondement de la loi du 29 juillet 1881",
    explanation:
        "L’article 38 de cette loi interdit la publication d’actes de procédure avant leur lecture en audience publique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Ouverture — Délit",
    question:
        "Parmi les raisons suivantes, laquelle justifie souvent l’ouverture d’une information en matière délictuelle ?",
    options: [
      "La médiatisation de l’affaire",
      "La complexité des faits ou l’auteur inconnu",
      "La faiblesse des charges",
      "Le souhait du mis en cause",
    ],
    answer: "La complexité des faits ou l’auteur inconnu",
    explanation:
        "L’information permet une enquête plus approfondie lorsque les faits sont complexes ou l’auteur non identifié.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Saisine — Faits nouveaux",
    question:
        "Lorsque le juge d’instruction découvre des faits nouveaux, que doit-il faire ?",
    options: [
      "Les ignorer s’ils compliquent le dossier",
      "Les juger immédiatement",
      "En informer le procureur de la République",
      "Classer le dossier",
    ],
    answer: "En informer le procureur de la République",
    explanation:
        "Le parquet appréciera s’il faut un réquisitoire supplétif, une nouvelle information ou un autre type de poursuite.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Pouvoirs du juge — Objectif",
    question:
        "Sur quels aspects le juge d’instruction doit-il porter son investigation ?",
    options: [
      "Uniquement sur les faits matériels",
      "Uniquement sur la personnalité de la victime",
      "Sur les faits, la participation des personnes et la personnalité de l’auteur (et parfois de la victime)",
      "Uniquement sur les antécédents judiciaires",
    ],
    answer:
        "Sur les faits, la participation des personnes et la personnalité de l’auteur (et parfois de la victime)",
    explanation:
        "L’instruction vise à éclairer la juridiction de jugement sur les faits et les personnes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Expertise — Refus",
    question:
        "Si le juge d’instruction refuse une demande d’expertise présentée par une partie, il doit :",
    options: [
      "Rester silencieux",
      "Donner uniquement un avis oral",
      "Rendre une ordonnance motivée dans un délai déterminé",
      "Saisir la chambre de l’instruction",
    ],
    answer: "Rendre une ordonnance motivée dans un délai déterminé",
    explanation:
        "Le refus doit être motivé par ordonnance, dans le délai d’un mois à compter de la demande (art. 156 C. proc. pén.).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Témoins — Anonymat",
    question:
        "Que se passe-t-il si l’identité d’un témoin n’est pas mentionnée au procès-verbal d’audition ?",
    options: [
      "Rien de particulier",
      "La déposition est nulle",
      "La déposition est simplement moins crédible",
      "Le témoin devient partie civile",
    ],
    answer: "La déposition est nulle",
    explanation:
        "L’anonymat d’un témoin dans l’instruction classique est contraire aux règles, la déposition serait frappée de nullité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Témoins — Obligations",
    question:
        "Parmi les obligations suivantes, laquelle NE fait PAS partie des obligations normales du témoin ?",
    options: [
      "Comparer",
      "Prêter serment (sauf exception)",
      "Déposer",
      "Accepter d’être conjoint du mis en examen",
    ],
    answer: "Accepter d’être conjoint du mis en examen",
    explanation:
        "Le témoin doit comparaître, prêter serment et déposer, mais sa situation familiale n’est évidemment pas une obligation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Témoin assisté — Droits",
    question:
        "Quel droit renforce particulièrement la protection du témoin assisté ?",
    options: [
      "Le droit d’être entendu sans avocat",
      "Le droit de demander sa mise en examen",
      "Le droit de refuser toute audition",
      "Le droit de rendre l’instruction publique",
    ],
    answer: "Le droit de demander sa mise en examen",
    explanation:
        "Le témoin assisté peut demander à être mis en examen afin de bénéficier de l’ensemble des droits de la défense attachés à ce statut.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Mise en examen — Effets",
    question: "La mise en examen permet notamment à la personne :",
    options: [
      "De se passer d’avocat",
      "De n’avoir aucun droit au dossier",
      "De demander des actes, des confrontations et de former des requêtes en nullité",
      "D’exercer le pouvoir de poursuite",
    ],
    answer:
        "De demander des actes, des confrontations et de former des requêtes en nullité",
    explanation:
        "La mise en examen donne la qualité de partie et ouvre l’accès à de nombreux droits procéduraux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Partie civile — Consignation",
    question:
        "En cas de constitution de partie civile initiale, la victime doit en principe :",
    options: [
      "Payer une amende à l’État",
      "Verser une consignation fixée par le juge d’instruction",
      "Indemniser le mis en examen",
      "Rédiger seule un acte d’accusation",
    ],
    answer: "Verser une consignation fixée par le juge d’instruction",
    explanation:
        "Cette consignation vise à éviter les plaintes abusives ; le juge peut en dispenser la victime.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Partie civile — Avantages",
    question:
        "Quel avantage la partie civile a-t-elle par rapport à la simple victime non constituée ?",
    options: [
      "Elle peut prononcer la peine",
      "Elle dirige les enquêteurs",
      "Elle devient partie à la procédure avec accès au dossier et droit de demander des actes",
      "Elle remplace le procureur à l’audience",
    ],
    answer:
        "Elle devient partie à la procédure avec accès au dossier et droit de demander des actes",
    explanation:
        "La constitution de partie civile donne un rôle actif à la victime dans l’instruction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Clôture — Demande",
    question:
        "Qui peut demander au juge d’instruction de clore l’information sur le fondement de l’article 175-1 C. proc. pén. ?",
    options: [
      "Uniquement le procureur",
      "Uniquement le mis en examen",
      "La personne mise en examen, le témoin assisté ou la partie civile",
      "Uniquement la partie civile",
    ],
    answer: "La personne mise en examen, le témoin assisté ou la partie civile",
    explanation:
        "Ces trois catégories de personnes ont un intérêt direct à voir avancer ou clore l’instruction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Ordonnance de renvoi — Effets",
    question:
        "Sur quelles mesures l’ordonnance de renvoi devant le tribunal correctionnel met-elle en principe fin ?",
    options: [
      "Aux peines déjà prononcées",
      "À la détention provisoire, au contrôle judiciaire et à l’assignation à résidence avec surveillance électronique",
      "À l’action civile",
      "Aux droits de la défense",
    ],
    answer:
        "À la détention provisoire, au contrôle judiciaire et à l’assignation à résidence avec surveillance électronique",
    explanation:
        "En principe, ces mesures prennent fin après l’ordonnance de renvoi, sauf exceptions pour certains mandats.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Non-lieu — Effets civils",
    question:
        "Que peut faire le bénéficiaire d’un non-lieu envers une partie civile qui l’a mis en cause abusivement ?",
    options: [
      "Le faire incarcérer",
      "Demander des dommages-intérêts",
      "Annuler tous les procès-verbaux",
      "Récuser le juge",
    ],
    answer: "Demander des dommages-intérêts",
    explanation:
        "L’article 91 C. proc. pén. permet au bénéficiaire d’un non-lieu de réclamer réparation en cas de plainte infondée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Chambre de l’instruction — Nullités",
    question:
        "Lorsqu’elle annule un acte pour nullité, la chambre de l’instruction doit :",
    options: [
      "Toujours clore l’information",
      "Toujours renvoyer au tribunal",
      "Éventuellement annuler aussi tout ou partie de la procédure ultérieure",
      "Sanctionner le juge d’instruction disciplinairment",
    ],
    answer:
        "Éventuellement annuler aussi tout ou partie de la procédure ultérieure",
    explanation:
        "Elle apprécie la portée de la nullité sur les actes subséquents (art. 206 C. proc. pén.).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Chambre de l’instruction — Partie civile abusive",
    question:
        "Que peut décider la chambre de l’instruction à l’égard d’une partie civile jugée abusive ou dilatoire ?",
    options: [
      "La déchoir de la nationalité",
      "Lui infliger une amende civile pouvant aller jusqu’à 15 000 €",
      "La placer en garde à vue",
      "Lui interdire tout recours",
    ],
    answer: "Lui infliger une amende civile pouvant aller jusqu’à 15 000 €",
    explanation:
        "Elle peut condamner la partie civile abusive à une amende civile, éventuellement à la charge du représentant légal.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Audience de contrôle — Saisine",
    question:
        "Qui peut être à l’origine de la tenue d’une audience de contrôle de l’instruction (art. 221-3 C. proc. pén.) ?",
    options: [
      "Uniquement la presse",
      "La personne détenue, le ministère public ou le président de la chambre d’office",
      "Uniquement le mis en examen libre",
      "Uniquement la partie civile",
    ],
    answer:
        "La personne détenue, le ministère public ou le président de la chambre d’office",
    explanation:
        "La loi prévoit ces trois modes de saisine pour déclencher une audience de contrôle.",
    difficulty: "Moyenne",
  ),

  // ===================== DIFFICILE (41–60) =====================
  QuizQuestion(
    category: "Secret — Exceptions et intérêts publics",
    question:
        "L’article 11-1 C. proc. pén. permet, sur autorisation, de communiquer certains éléments d’une procédure à des organismes habilités. Dans quel but principal ?",
    options: [
      "Faciliter la défense des mis en examen",
      "Réaliser des recherches ou enquêtes scientifiques ou techniques pour prévenir des accidents ou indemniser des victimes",
      "Informer le public sur les affaires en cours",
      "Favoriser la réinsertion professionnelle du mis en examen",
    ],
    answer:
        "Réaliser des recherches ou enquêtes scientifiques ou techniques pour prévenir des accidents ou indemniser des victimes",
    explanation:
        "Cette exception est strictement encadrée pour des finalités de sécurité ou d’indemnisation, les agents restant tenus au secret professionnel.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Non-contradictoire — Atténuations",
    question:
        "Parmi les éléments suivants, lequel illustre le mieux l’atténuation du caractère non contradictoire de l’instruction ?",
    options: [
      "La publicité systématique des auditions",
      "L’impossibilité de contester les actes",
      "Le droit des parties de former des requêtes en nullité et de demander des actes",
      "Le secret absolu du dossier pour la défense",
    ],
    answer:
        "Le droit des parties de former des requêtes en nullité et de demander des actes",
    explanation:
        "Ces possibilités renforcent le contradictoire et le rôle actif des parties dans l’instruction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Saisine — Pôle de l’instruction",
    question:
        "Que doit faire le procureur d’un tribunal sans pôle de l’instruction lorsqu’il estime qu’une affaire relève d’un pôle ?",
    options: [
      "Classer sans suite",
      "Saisir directement la cour d’assises",
      "Aviser le procureur de la République près le tribunal où se situe le pôle afin de se concerter",
      "Saisir la chambre criminelle de la Cour de cassation",
    ],
    answer:
        "Aviser le procureur de la République près le tribunal où se situe le pôle afin de se concerter",
    explanation:
        "Les deux parquets se concertent pour décider qui dirigera et contrôlera la procédure (art. D. 15-4-1 C. proc. pén.).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Conséquences de la saisine — In rem",
    question:
        "Quelle est la principale conséquence pratique du principe de saisine « in rem » du juge d’instruction ?",
    options: [
      "Il ne peut instruire que sur les faits visés dans l’acte de saisine",
      "Il doit systématiquement mettre en examen toutes les personnes citées",
      "Il ne peut jamais évoquer des faits connexes",
      "Il peut modifier librement la qualification sans en informer le parquet",
    ],
    answer:
        "Il ne peut instruire que sur les faits visés dans l’acte de saisine",
    explanation:
        "Le juge n’est pas saisi de personnes mais de faits déterminés par le réquisitoire ou la plainte.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Expertise — Choix hors liste",
    question:
        "Dans quel cas le juge peut-il désigner un expert ne figurant sur aucune des listes officielles ?",
    options: [
      "Lorsqu’il souhaite raccourcir la procédure",
      "Lorsqu’une technicité particulière justifie ce choix, qui doit alors être spécialement motivé",
      "Toujours, sans justification",
      "Uniquement si la partie civile l’exige",
    ],
    answer:
        "Lorsqu’une technicité particulière justifie ce choix, qui doit alors être spécialement motivé",
    explanation:
        "C’est une exception au principe de désignation sur listes, encadrée par l’article 157 C. proc. pén.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Expertise — Communication du rapport",
    question:
        "Dans quelles conditions les experts peuvent-ils communiquer directement leurs conclusions aux OPJ, parquet ou parties ?",
    options: [
      "Jamais",
      "Toujours, sans contrôle",
      "Uniquement avec l’accord du juge d’instruction et par tout moyen",
      "Uniquement par voie de presse",
    ],
    answer: "Uniquement avec l’accord du juge d’instruction et par tout moyen",
    explanation:
        "Cette communication est possible sous le contrôle du juge, garant du bon déroulement des opérations (art. 166 C. proc. pén.).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Témoin assisté — Obligation ou faculté",
    question:
        "Dans lequel des cas suivants le statut de témoin assisté est-il OBLIGATOIRE, à défaut de mise en examen ?",
    options: [
      "Lorsque la personne est simplement citée dans la presse",
      "Lorsque la personne est nommément visée par un réquisitoire introductif ou supplétif",
      "Lorsque la personne se présente spontanément au commissariat",
      "Lorsque la personne est inconnue",
    ],
    answer:
        "Lorsque la personne est nommément visée par un réquisitoire introductif ou supplétif",
    explanation:
        "L’article 113-1 C. proc. pén. impose ce statut à défaut de mise en examen pour les personnes nommément visées.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Témoin assisté — Indices graves et concordants",
    question:
        "Que permet l’article 113-6 al. 2 C. proc. pén. concernant un témoin assisté contre lequel existent des indices graves et concordants ?",
    options: [
      "Il interdit de maintenir ce statut",
      "Il autorise le maintien sous statut de témoin assisté si la mise en examen n’est pas jugée nécessaire",
      "Il impose la clôture de l’information",
      "Il impose une garde à vue",
    ],
    answer:
        "Il autorise le maintien sous statut de témoin assisté si la mise en examen n’est pas jugée nécessaire",
    explanation:
        "Le juge peut estimer qu’il n’est pas utile de mettre en examen, sauf si des mesures de contrainte ou un renvoi sont envisagés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Interrogatoire de première comparution",
    question:
        "Quel est l’enjeu principal de l’interrogatoire de première comparution pour une personne qui n’était pas témoin assisté ?",
    options: [
      "Savoir si elle sera convoquée comme témoin",
      "Déterminer si une expertise psychiatrique est nécessaire",
      "Déterminer si elle doit être mise en examen ou bénéficier du statut de témoin assisté",
      "Fixer la date du procès",
    ],
    answer:
        "Déterminer si elle doit être mise en examen ou bénéficier du statut de témoin assisté",
    explanation:
        "Au terme de cet interrogatoire, le juge choisit le statut procédural de la personne, avec des conséquences importantes sur ses droits.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Partie civile — Conditions spéciales",
    question:
        "Sous quelle condition spécifique une personne morale à but lucratif peut-elle se constituer partie civile initialement ?",
    options: [
      "En prouvant qu’elle est victime morale",
      "En obtenant l’accord du parquet",
      "En joignant son bilan et son compte de résultat pour justifier de ses ressources",
      "En payant une amende à l’État",
    ],
    answer:
        "En joignant son bilan et son compte de résultat pour justifier de ses ressources",
    explanation:
        "L’article 85 al. 4 C. proc. pén. exige cette justification pour limiter les constitutions abusives.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Partie civile — Non-lieu et amende civile",
    question:
        "Quand le juge d’instruction peut-il condamner une partie civile à une amende civile pouvant aller jusqu’à 15 000 € (art. 177-2 C. proc. pén.) ?",
    options: [
      "En cas de relaxe en jugement",
      "En cas de non-lieu concluant une information ouverte sur constitution de partie civile jugée abusive ou dilatoire",
      "En cas de simple retard à l’audience",
      "En cas de non-paiement de la consignation",
    ],
    answer:
        "En cas de non-lieu concluant une information ouverte sur constitution de partie civile jugée abusive ou dilatoire",
    explanation:
        "L’amende civile sanctionne l’usage abusif de l’action civile devant le juge d’instruction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Non-lieu — Charges nouvelles",
    question:
        "Qui est compétent pour décider de rouvrir une information sur charges nouvelles après un non-lieu ?",
    options: [
      "Le juge d’instruction d’office",
      "Le JLD",
      "Le procureur de la République",
      "La partie civile",
    ],
    answer: "Le procureur de la République",
    explanation:
        "L’article 190 C. proc. pén. confie au parquet la décision d’engager une nouvelle information sur charges nouvelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Chambre de l’instruction — Pouvoir de révision",
    question:
        "Lorsqu’elle exerce son pouvoir de révision (art. 205 C. proc. pén.), la chambre de l’instruction peut notamment :",
    options: [
      "Prononcer la peine définitive",
      "Refaire totalement l’instruction en ordonnant un supplément d’information confié à un magistrat désigné",
      "Remplacer définitivement le parquet",
      "Supprimer le rôle du juge d’instruction",
    ],
    answer:
        "Refaire totalement l’instruction en ordonnant un supplément d’information confié à un magistrat désigné",
    explanation:
        "Le magistrat désigné exerce alors les pouvoirs d’un juge d’instruction, y compris la commission rogatoire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Chambre de l’instruction — Évocation",
    question:
        "La chambre de l’instruction peut procéder à une évocation partielle du dossier. Cela signifie :",
    options: [
      "Qu’elle juge l’affaire au fond",
      "Qu’elle ne statue que sur la responsabilité civile",
      "Qu’elle ne réalise que certains actes avant de renvoyer le dossier au juge d’instruction",
      "Qu’elle met fin à l’information sans suite",
    ],
    answer:
        "Qu’elle ne réalise que certains actes avant de renvoyer le dossier au juge d’instruction",
    explanation:
        "Elle peut limiter son intervention à quelques actes puis renvoyer le dossier pour la poursuite de l’information.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Audience de contrôle — Renouvellement",
    question:
        "Après une première audience de contrôle, dans quel délai une nouvelle saisine est-elle possible si la détention provisoire se poursuit ?",
    options: [
      "1 mois après la première audience",
      "3 mois après la première audience",
      "6 mois après que l’arrêt est devenu définitif",
      "12 mois après l’ouverture de l’information",
    ],
    answer: "6 mois après que l’arrêt est devenu définitif",
    explanation:
        "L’article 221-3 C. proc. pén. prévoit ce délai minimal pour une nouvelle audience de contrôle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Instruction — Libertés et nullités",
    question:
        "Pourquoi la procédure d’instruction est-elle particulièrement formaliste, avec un risque important de nullités en cas de manquement ?",
    options: [
      "Pour ralentir volontairement les enquêtes",
      "Pour faciliter la tâche du parquet",
      "Parce qu’elle doit concilier recherche de la vérité et protection rigoureuse des libertés individuelles",
      "Pour avantager systématiquement la partie civile",
    ],
    answer:
        "Parce qu’elle doit concilier recherche de la vérité et protection rigoureuse des libertés individuelles",
    explanation:
        "Le formalisme est le garant des droits fondamentaux et permet de sanctionner les irrégularités par des nullités.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Instruction — Rôle global des parties",
    question:
        "Quel est l’apport majeur de l’évolution de la législation sur le rôle des parties dans l’instruction préparatoire ?",
    options: [
      "Les parties n’ont plus aucun droit",
      "Les parties peuvent participer activement (demandes d’actes, requêtes en nullité, demandes de clôture, etc.)",
      "Seule la partie civile peut agir",
      "Seul le parquet dirige tout",
    ],
    answer:
        "Les parties peuvent participer activement (demandes d’actes, requêtes en nullité, demandes de clôture, etc.)",
    explanation:
        "La procédure se veut aujourd’hui plus contradictoire, avec un rôle accru du mis en examen, du témoin assisté et de la partie civile.",
    difficulty: "Difficile",
  ),
  // 50
  QuizQuestion(
    category: "Synthèse — Instruction préparatoire",
    question:
        "Quelle affirmation décrit le mieux l’instruction préparatoire dans le système pénal français ?",
    options: [
      "Une phase purement administrative avant le procès",
      "Une phase juridictionnelle d’enquête menée par un juge indépendant, visant à rechercher la vérité tout en garantissant les droits fondamentaux",
      "Une simple formalité avant le classement sans suite",
      "Une procédure secrète sans aucun droit pour les parties",
    ],
    answer:
        "Une phase juridictionnelle d’enquête menée par un juge indépendant, visant à rechercher la vérité tout en garantissant les droits fondamentaux",
    explanation:
        "L’instruction est une phase juridictionnelle à part entière, avec un juge du siège, des garanties procédurales et un contrôle de la chambre de l’instruction.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Chambre de l’instruction — Sanctions partie civile",
    question:
        "Quelle sanction peut prononcer la chambre de l’instruction contre une partie civile abusive ou dilatoire ?",
    options: [
      "Une peine de prison",
      "Une interdiction de se constituer à l’avenir",
      "Une amende civile pouvant aller jusqu’à 15 000 €",
      "Une simple mise en garde orale",
    ],
    answer: "Une amende civile pouvant aller jusqu’à 15 000 €",
    explanation:
        "La chambre peut condamner la partie civile à une amende civile en cas de constitution abusive ou dilatoire.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Généralités — Instruction préparatoire",
    question:
        "Quel type de procédure inspire principalement l’instruction préparatoire ?",
    options: [
      "La procédure accusatoire",
      "La procédure inquisitoire",
      "La procédure administrative",
    ],
    answer: "La procédure inquisitoire",
    explanation:
        "L’instruction préparatoire s’inspire du modèle inquisitoire : procédure écrite, secrète et non contradictoire, même si ces caractères sont aujourd’hui largement atténués.",
    difficulty: "Moyenne",
  ),

  // ========== CARACTÈRES DE LA PROCÉDURE : ÉCRIT ==========
  QuizQuestion(
    category: "Caractères — Procédure écrite",
    question:
        "Que prévoit l’article 81 du Code de procédure pénale concernant la forme de l’instruction ?",
    options: [
      "Que seuls les actes oraux sont valables",
      "Que tous les actes et décisions de l’instruction sont réunis dans un dossier écrit",
      "Que le juge n’est pas tenu de conserver les actes",
    ],
    answer:
        "Que tous les actes et décisions de l’instruction sont réunis dans un dossier écrit",
    explanation:
        "L’article 81 C. proc. pén. indique que tous les actes de l’instruction et les décisions qui en résultent sont réunis dans un dossier, ce qui consacre le caractère écrit de la procédure.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Caractères — Procédure écrite",
    question:
        "Pourquoi des copies ou photocopies du dossier d’instruction sont-elles autorisées ?",
    options: [
      "Pour faciliter la communication du dossier sans ralentir le travail du juge",
      "Pour remplacer le dossier original qui est détruit",
      "Pour permettre aux journalistes de consulter le dossier",
    ],
    answer:
        "Pour faciliter la communication du dossier sans ralentir le travail du juge",
    explanation:
        "Les copies permettent aux différents acteurs judiciaires d’accéder aux pièces du dossier tout en permettant au magistrat instructeur de conserver l’original pour poursuivre son travail.",
    difficulty: "Facile",
  ),

  // ========== CARACTÈRE SECRET ==========
  QuizQuestion(
    category: "Caractères — Secret de l’instruction",
    question:
        "Quelle est la règle de principe posée par l’article 11 du Code de procédure pénale ?",
    options: [
      "La publicité permanente de l’instruction",
      "Le secret de l’instruction à l’égard du public",
      "L’obligation pour le juge de communiquer le dossier à la presse",
    ],
    answer: "Le secret de l’instruction à l’égard du public",
    explanation:
        "L’article 11 C. proc. pén. pose le principe du secret de l’instruction : toute personne qui concourt à la procédure est tenue au secret professionnel, à l’égard du public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Caractères — Secret de l’instruction",
    question:
        "Dans quel but le procureur de la République peut-il, sur le fondement de l’article 11, communiquer certains éléments de la procédure ?",
    options: [
      "Pour influencer les témoins",
      "Pour éviter la propagation d’informations inexactes ou pour mettre fin à un trouble à l’ordre public",
      "Pour informer systématiquement les médias de chaque acte",
    ],
    answer:
        "Pour éviter la propagation d’informations inexactes ou pour mettre fin à un trouble à l’ordre public",
    explanation:
        "L’alinéa 3 de l’article 11 C. proc. pén. permet au procureur de communiquer certains éléments afin d’éviter rumeurs, informations parcellaires ou pour répondre à un impératif d’ordre public.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Caractères — Secret de l’instruction",
    question:
        "Les avocats des parties ont-ils accès au dossier d’instruction ?",
    options: [
      "Non, le dossier reste réservé au seul juge d’instruction",
      "Oui, mais seulement à la fin de la procédure",
      "Oui, ils ont accès à tout moment à l’ensemble du dossier",
    ],
    answer: "Oui, ils ont accès à tout moment à l’ensemble du dossier",
    explanation:
        "L’article 114 C. proc. pén. prévoit que les avocats des parties peuvent consulter le dossier et en obtenir copie, ce qui atténue fortement le caractère secret et non contradictoire de l’instruction.",
    difficulty: "Moyenne",
  ),

  // ========== CARACTÈRE NON CONTRADICTOIRE ==========
  QuizQuestion(
    category: "Caractères — Non-contradictoire",
    question:
        "Pourquoi dit-on que le caractère non contradictoire de l’instruction est aujourd’hui atténué ?",
    options: [
      "Parce que les parties ne peuvent plus être assistées d’un avocat",
      "Parce que les parties peuvent demander des actes, former des recours et accéder au dossier",
      "Parce que le juge d’instruction n’a plus aucun pouvoir propre",
    ],
    answer:
        "Parce que les parties peuvent demander des actes, former des recours et accéder au dossier",
    explanation:
        "Les réformes du C. proc. pén. ont renforcé le rôle actif des parties : demandes d’actes, requêtes en nullité, appels, accès au dossier, ce qui limite le caractère non contradictoire d’origine.",
    difficulty: "Moyenne",
  ),

  // ========== OUVERTURE DE L’INFORMATION ==========
  QuizQuestion(
    category: "Ouverture de l’information",
    question: "En matière criminelle, l’ouverture d’une information est :",
    options: ["Facultative", "Obligatoire", "Interdite sauf avis du J.L.D."],
    answer: "Obligatoire",
    explanation:
        "L’article 79 C. proc. pén. prévoit que l’information est obligatoire en matière criminelle, en raison de la gravité des faits et de la nécessité d’examiner aussi la personnalité de l’auteur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Ouverture de l’information",
    question: "En matière délictuelle, l’information judiciaire est :",
    options: [
      "Toujours interdite",
      "Toujours obligatoire",
      "Facultative sauf dispositions spéciales",
    ],
    answer: "Facultative sauf dispositions spéciales",
    explanation:
        "En matière de délit, l’information est en principe facultative et sera privilégiée pour les affaires complexes, lorsque l’auteur est inconnu ou en fuite, ou sur plainte avec constitution de partie civile.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Ouverture de l’information",
    question:
        "Qui peut provoquer l’ouverture d’une information par plainte avec constitution de partie civile ?",
    options: [
      "Uniquement le ministère public",
      "Toute personne qui se prétend lésée par un crime ou un délit",
      "Uniquement les personnes morales",
    ],
    answer: "Toute personne qui se prétend lésée par un crime ou un délit",
    explanation:
        "La victime peut saisir directement le juge d’instruction par plainte avec constitution de partie civile pour un crime ou un délit, ce qui déclenche l’information si la plainte est régulière et recevable.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Ouverture de l’information",
    question:
        "Le juge d’instruction peut-il se saisir d’office d’une affaire pénale ?",
    options: [
      "Oui, à condition d’en informer le procureur",
      "Non, il doit être saisi par le ministère public ou la victime",
      "Oui, uniquement en matière criminelle",
    ],
    answer: "Non, il doit être saisi par le ministère public ou la victime",
    explanation:
        "Le juge d’instruction ne peut pas se saisir d’office. Il est saisi soit par un réquisitoire du procureur de la République, soit par une plainte avec constitution de partie civile.",
    difficulty: "Moyenne",
  ),

  // ========== SAISINE & LIMITES DU JUGE D’INSTRUCTION ==========
  QuizQuestion(
    category: "Saisine du juge d’instruction",
    question:
        "Que signifie l’expression « le juge d’instruction est saisi in rem » ?",
    options: [
      "Il est saisi uniquement d’une personne déterminée",
      "Il est saisi des faits décrits dans le réquisitoire ou la plainte",
      "Il est libre d’étendre l’information à tout fait qu’il découvre",
    ],
    answer: "Il est saisi des faits décrits dans le réquisitoire ou la plainte",
    explanation:
        "La saisine in rem signifie que le juge d’instruction est saisi des faits, tels que visés dans le réquisitoire ou la plainte, et non de telle ou telle personne désignée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Saisine du juge d’instruction",
    question:
        "Que doit faire le juge d’instruction s’il découvre des faits nouveaux au cours de l’information ?",
    options: [
      "Il les instruit librement sans formalité",
      "Il les classe sans suite lui-même",
      "Il les dénonce au procureur de la République pour réquisitoire supplétif ou autre décision",
    ],
    answer:
        "Il les dénonce au procureur de la République pour réquisitoire supplétif ou autre décision",
    explanation:
        "En cas de découverte de faits nouveaux, le juge doit les transmettre au procureur (art. 80 C. proc. pén.), qui pourra notamment rédiger un réquisitoire supplétif ou ouvrir une nouvelle information.",
    difficulty: "Moyenne",
  ),

  // ========== MISE EN EXAMEN ==========
  QuizQuestion(
    category: "Mise en examen — Conditions",
    question:
        "Quelle condition de fond est indispensable pour mettre une personne en examen (à peine de nullité) ?",
    options: [
      "La simple dénonciation anonyme",
      "Des indices graves ou concordants rendant vraisemblable sa participation à l’infraction",
      "Un aveu complet de la personne",
    ],
    answer:
        "Des indices graves ou concordants rendant vraisemblable sa participation à l’infraction",
    explanation:
        "L’article 80-1 C. proc. pén. exige des indices graves ou concordants rendant vraisemblable la participation à l’infraction pour justifier une mise en examen.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Mise en examen — Choix du statut",
    question:
        "Dans quel cas la mise en examen devient-elle obligatoire pour le juge d’instruction ?",
    options: [
      "Chaque fois que la personne est entendue",
      "Dès que l’enquête de police est terminée",
      "Lorsque le juge envisage une détention provisoire ou un contrôle judiciaire ou un renvoi devant une juridiction",
    ],
    answer:
        "Lorsque le juge envisage une détention provisoire ou un contrôle judiciaire ou un renvoi devant une juridiction",
    explanation:
        "Si le juge souhaite recourir à la détention provisoire, au contrôle judiciaire ou renvoyer la personne devant une juridiction de jugement, la mise en examen est indispensable.",
    difficulty: "Difficile",
  ),

  // ========== TÉMOIN ASSISTÉ ==========
  QuizQuestion(
    category: "Témoin assisté — Notion",
    question: "Le statut de témoin assisté se situe :",
    options: [
      "Entre le simple témoin et la personne mise en examen",
      "Au-dessus du statut de mis en examen",
      "En dessous du statut de simple témoin",
    ],
    answer: "Entre le simple témoin et la personne mise en examen",
    explanation:
        "Le témoin assisté occupe une position intermédiaire : il est visé par des soupçons mais ne réunit pas (ou pas encore) les conditions de la mise en examen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Témoin assisté — Droits",
    question:
        "Le témoin assisté peut-il être placé sous contrôle judiciaire ou en détention provisoire ?",
    options: [
      "Oui, dans les mêmes conditions que le mis en examen",
      "Non, il ne peut pas être soumis à ces mesures",
      "Uniquement sur décision du procureur général",
    ],
    answer: "Non, il ne peut pas être soumis à ces mesures",
    explanation:
        "L’article 113-5 C. proc. pén. précise que le témoin assisté ne peut être placé ni sous contrôle judiciaire, ni sous assignation à résidence avec surveillance électronique, ni en détention provisoire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Témoin assisté — Droits",
    question:
        "Quel droit particulier possède le témoin assisté concernant sa situation procédurale ?",
    options: [
      "Il peut demander à tout moment sa mise en examen",
      "Il peut décider seul de clore l’instruction",
      "Il peut imposer un non-lieu au juge",
    ],
    answer: "Il peut demander à tout moment sa mise en examen",
    explanation:
        "L’article 113-6 C. proc. pén. permet au témoin assisté de demander sa mise en examen. Dans ce cas, la mise en examen est de droit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Témoin assisté — Obligations",
    question:
        "Le témoin assisté est-il tenu de comparaître lorsqu’il est convoqué par le juge d’instruction ?",
    options: [
      "Non, il peut refuser sans conséquence",
      "Oui, il peut même y être contraint par la force publique",
      "Oui, mais uniquement en matière criminelle",
    ],
    answer: "Oui, il peut même y être contraint par la force publique",
    explanation:
        "En cas de convocation, le témoin assisté est soumis au régime de l’article 109 C. proc. pén. : il peut être contraint à comparaître et encourt la sanction prévue par l’article 434-15-1 du Code pénal.",
    difficulty: "Difficile",
  ),

  // ========== TÉMOINS ==========
  QuizQuestion(
    category: "Auditions — Témoins",
    question:
        "Le juge d’instruction peut-il entendre comme témoin une personne contre laquelle existent des indices graves et concordants de participation à l’infraction ?",
    options: [
      "Oui, à condition qu’elle soit assistée d’un avocat",
      "Non, il doit lui attribuer au moins le statut de témoin assisté ou la mettre en examen",
      "Oui, mais en audience publique uniquement",
    ],
    answer:
        "Non, il doit lui attribuer au moins le statut de témoin assisté ou la mettre en examen",
    explanation:
        "En vertu de l’article 105 C. proc. pén., une personne contre laquelle existent des indices graves et concordants ne peut pas être entendue comme simple témoin.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Auditions — Témoins",
    question:
        "Quel est le contenu du serment prêté par un témoin devant le juge d’instruction ?",
    options: [
      "Je jure de défendre les intérêts de la partie qui m’a cité",
      "Je jure de ne pas divulguer ce qui sera dit",
      "Je jure de dire toute la vérité, rien que la vérité",
    ],
    answer: "Je jure de dire toute la vérité, rien que la vérité",
    explanation:
        "L’article 103 C. proc. pén. impose au témoin de prêter serment de dire toute la vérité, rien que la vérité, sauf cas de dispense (mineurs de moins de 16 ans, proches, etc.).",
    difficulty: "Facile",
  ),

  // ========== PARTIE CIVILE ==========
  QuizQuestion(
    category: "Partie civile — Constitution",
    question:
        "Quel est l’effet principal de la constitution de partie civile devant le juge d’instruction ?",
    options: [
      "Elle met automatiquement fin à l’action publique",
      "Elle fait de la victime une partie à la procédure avec des droits propres",
      "Elle dessaisit le ministère public",
    ],
    answer:
        "Elle fait de la victime une partie à la procédure avec des droits propres",
    explanation:
        "La partie civile devient partie à la procédure et peut demander des actes, former certains recours, obtenir l’aide juridictionnelle, être informée de l’évolution du dossier, etc.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Partie civile — Consignation",
    question:
        "Dans quel cas la partie civile doit-elle consigner une somme fixée par le juge d’instruction ?",
    options: [
      "Uniquement en cas de délit",
      "Uniquement lorsqu’elle intervient après le ministère public",
      "Lorsqu’elle déclenche l’action publique par une plainte avec constitution de partie civile",
    ],
    answer:
        "Lorsqu’elle déclenche l’action publique par une plainte avec constitution de partie civile",
    explanation:
        "En cas de constitution initiale (avant mise en mouvement de l’action publique), la partie civile doit en principe verser une consignation, sous peine de non-validité de sa constitution.",
    difficulty: "Difficile",
  ),

  // ========== CLÔTURE DE L’INSTRUCTION ==========
  QuizQuestion(
    category: "Clôture de l’instruction",
    question:
        "Que doit faire le juge d’instruction lorsque l’information lui paraît terminée ?",
    options: [
      "Classer le dossier sans informer personne",
      "Communiquer le dossier au procureur de la République et aviser les parties",
      "Transmettre directement le dossier au tribunal correctionnel",
    ],
    answer:
        "Communiquer le dossier au procureur de la République et aviser les parties",
    explanation:
        "L’article 175 C. proc. pén. prévoit qu’à la fin de l’information, le juge communique le dossier au procureur et avise les parties ou leurs avocats.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Clôture de l’instruction",
    question:
        "Que permet l’article 175-1 du Code de procédure pénale aux personnes mises en examen, témoins assistés et parties civiles ?",
    options: [
      "Demander la récusation du juge d’instruction",
      "Demander la clôture de l’instruction après un certain délai ou inactivité",
      "Imposer la requalification des faits",
    ],
    answer:
        "Demander la clôture de l’instruction après un certain délai ou inactivité",
    explanation:
        "L’article 175-1 C. proc. pén. permet de demander au juge de clore l’instruction, notamment lorsqu’aucun acte n’a été accompli depuis 4 mois.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Clôture de l’instruction — Ordonnances",
    question:
        "Quelle est la conséquence commune aux ordonnances de renvoi et de mise en accusation lorsqu’elles deviennent définitives ?",
    options: [
      "Elles peuvent toujours être modifiées par le juge d’instruction",
      "Elles couvrent, sauf exceptions, les vices de la procédure antérieure",
      "Elles annulent toutes les mesures de sûreté",
    ],
    answer:
        "Elles couvrent, sauf exceptions, les vices de la procédure antérieure",
    explanation:
        "L’ordonnance de renvoi (tribunal) comme l’ordonnance de mise en accusation (cour d’assises) couvrent en principe les vices de la procédure, sauf cas particuliers (ex. art. 269-1 C. proc. pén.).",
    difficulty: "Difficile",
  ),

  // ========== NON-LIEU ==========
  QuizQuestion(
    category: "Ordonnance de non-lieu",
    question:
        "Quel est l’effet principal d’une ordonnance de non-lieu sur l’action publique ?",
    options: [
      "Elle suspend l’action publique",
      "Elle arrête l’action publique, sauf réouverture sur charges nouvelles",
      "Elle renvoie le dossier devant le tribunal",
    ],
    answer:
        "Elle arrête l’action publique, sauf réouverture sur charges nouvelles",
    explanation:
        "L’ordonnance de non-lieu met fin à l’action publique pour les faits visés, sauf si apparaissent ultérieurement des charges nouvelles (art. 188-190 C. proc. pén.).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Ordonnance de non-lieu",
    question:
        "Que doit faire l’État à l’égard d’une personne ayant bénéficié d’un non-lieu après détention provisoire ?",
    options: [
      "Lui présenter des excuses publiques uniquement",
      "Lui proposer automatiquement une amnistie",
      "L’informer de son droit à réparation du préjudice moral et matériel",
    ],
    answer:
        "L’informer de son droit à réparation du préjudice moral et matériel",
    explanation:
        "L’article 149 C. proc. pén. prévoit que le bénéficiaire d’un non-lieu après détention provisoire doit être informé de son droit à demander réparation à l’État.",
    difficulty: "Moyenne",
  ),

  // ========== CHAMBRE DE L’INSTRUCTION ==========
  QuizQuestion(
    category: "Chambre de l’instruction — Rôle",
    question: "Quel type de juridiction est la chambre de l’instruction ?",
    options: [
      "Une juridiction de jugement de premier degré",
      "La juridiction d’instruction du second degré",
      "Une juridiction administrative spécialisée",
    ],
    answer: "La juridiction d’instruction du second degré",
    explanation:
        "La chambre de l’instruction est la juridiction d’instruction du second degré, rattachée à la cour d’appel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Chambre de l’instruction — Compétences",
    question: "La chambre de l’instruction est seule compétente pour :",
    options: [
      "Décider de l’opportunité des poursuites",
      "Prononcer des nullités d’actes de procédure d’instruction",
      "Réformer les jugements du tribunal correctionnel",
    ],
    answer: "Prononcer des nullités d’actes de procédure d’instruction",
    explanation:
        "L’article 206 C. proc. pén. prévoit que seule la chambre de l’instruction peut prononcer la nullité d’actes de procédure et, le cas échéant, d’une partie de la procédure ultérieure.",
    difficulty: "Difficile",
  ),

  // ========== JUGE DES LIBERTÉS ET DE LA DÉTENTION ==========
  QuizQuestion(
    category: "Juge des libertés et de la détention — Rôle",
    question:
        "Dans le cadre de l’instruction préparatoire, quelle est l’une des principales compétences du J.L.D. ?",
    options: [
      "Statuer sur la culpabilité de la personne mise en examen",
      "Statuer sur la détention provisoire et son éventuelle prolongation",
      "Diriger l’enquête de police à la place du juge d’instruction",
    ],
    answer:
        "Statuer sur la détention provisoire et son éventuelle prolongation",
    explanation:
        "Le J.L.D. statue notamment sur le placement et les prolongations de détention provisoire, sur saisine du juge d’instruction ou du parquet (art. 137-1 et s. C. proc. pén.).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Juge des libertés et de la détention — Garde à vue",
    question:
        "Dans quels cas le J.L.D. peut-il autoriser une prolongation exceptionnelle de garde à vue au-delà de 48 heures ?",
    options: [
      "Pour toutes les contraventions",
      "Pour les infractions relevant de la criminalité organisée ou du terrorisme",
      "Uniquement pour les délits routiers",
    ],
    answer:
        "Pour les infractions relevant de la criminalité organisée ou du terrorisme",
    explanation:
        "Les articles 706-88 et 706-88-1 C. proc. pén. prévoient que, pour la criminalité organisée et les infractions terroristes, le J.L.D. peut autoriser des prolongations exceptionnelles de garde à vue.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizInstructionPage extends StatefulWidget {
  static const String routeName =
      '/gpx/procedure_penale/quiz/instruction_preparatoire';
  final String uid;
  final String email;

  const QuizInstructionPage({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizInstructionPage> createState() => _QuizInstructionPageState();
}

class _QuizInstructionPageState extends State<QuizInstructionPage>
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
        ? questionsInstructionPreparatoire
        : questionsInstructionPreparatoire
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
            'quiz_name': 'Instruction préparatoire',
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
      await _sb.from('quiz_instruction_preparatoire').insert({
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
      debugPrint('❌ quiz_instruction_preparatoire insert failed: $e');
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
