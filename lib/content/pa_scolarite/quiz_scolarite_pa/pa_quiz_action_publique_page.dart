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
final List<QuizQuestion> questionsActionPublique = [
  // … tes questions déjà présentes
  // Puis tu ajoutes celles-ci:
  const QuizQuestion(
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

  const QuizQuestion(
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
  const QuizQuestion(
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

  const QuizQuestion(
    category: "Principes fondamentaux",
    question:
        "La présomption d’innocence implique que la charge de la preuve incombe à qui ?",
    options: ["Au prévenu", "Au ministère public", "À la victime"],
    answer: "Au ministère public",
    explanation:
        "C’est à l’accusation d’apporter la preuve de la culpabilité, la personne étant présumée innocente.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
    category: "Sujets actifs",
    question:
        "Quel est le principal organe responsable de la mise en mouvement de l’action publique ?",
    options: ["Le ministère public", "La partie civile", "Le juge de paix"],
    answer: "Le ministère public",
    explanation:
        "Le parquet détient le pouvoir d’intenter des poursuites au nom de la société.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
    category: "Droits de la défense",
    question:
        "Quel droit fondamental permet à une personne suspectée d’être assistée par un avocat ?",
    options: ["Droit à l’égalité", "Droit à la défense", "Droit au silence"],
    answer: "Droit à la défense",
    explanation:
        "Ce droit garantit à tout suspect la possibilité de préparer sa défense.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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
  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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
  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  const QuizQuestion(
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

  // Fin du premier bloc
];

// ============================================================================
// PAGE
// ============================================================================
class QuizActionPubliquePagePA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName = '/pa/procedure_penale/quiz/action_publique';
  final String uid;
  final String email;

  const QuizActionPubliquePagePA({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizActionPubliquePagePA> createState() => _QuizActionPubliquePagePAState();
}

class _QuizActionPubliquePagePAState extends State<QuizActionPubliquePagePA>
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
  static const _introHiddenKey = 'intro_pa_action_publique';
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
        ? questionsActionPublique
        : questionsActionPublique
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
            'quiz_name': 'Action publique',
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
      await _sb.from('quiz_action_publique').insert({
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
      debugPrint('❌ quiz_action_publique insert failed: $e');
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
      'source_file': 'pa_quiz_action_publique_page',
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
                            icon: Icons.balance_rounded,
                            title: 'Action publique',
                            description: 'Comprends le déclenchement et l’exercice de l’action publique : les acteurs, les conditions et les causes d’extinction.',
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
