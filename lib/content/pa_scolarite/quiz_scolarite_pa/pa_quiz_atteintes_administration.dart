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

final List<QuizQuestion> questionAtteinteAdministration = [
  // =========================================================
  // PROVOCATION DIRECTE À LA RÉBELLION — ARTICLE 433-10 CP
  // (Banque étendue)
  // =========================================================
  const QuizQuestion(
    category: "Provocation à la rébellion — But de l’infraction",
    question:
        "La provocation directe à la rébellion vise principalement à réprimer :",
    options: [
      "Les agissements rendant plus difficile la mission des forces de l’ordre",
      "Les critiques politiques des institutions",
      "Les refus d’obtempérer sans violence",
    ],
    answer:
        "Les agissements rendant plus difficile la mission des forces de l’ordre",
    explanation:
        "Le texte indique que l’objectif est de sanctionner ceux qui compliquent la mission (interpellation, expulsion, etc.) en incitant directement à une rébellion.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Lien exigé",
    question: "Pour être répréhensible, la provocation doit présenter :",
    options: [
      "Une relation précise et incontestable avec l’acte de rébellion",
      "Une simple hostilité générale envers la police",
      "Une injure isolée",
    ],
    answer: "Une relation précise et incontestable avec l’acte de rébellion",
    explanation:
        "La provocation doit être directe : lien étroit et précis avec les faits visés.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Opposition violente",
    question: "Les termes de la provocation doivent tendre sans ambiguïté à :",
    options: [
      "Une opposition violente à l’action d’un dépositaire de l’autorité publique",
      "Un débat public contradictoire",
      "Une simple désapprobation",
    ],
    answer:
        "Une opposition violente à l’action d’un dépositaire de l’autorité publique",
    explanation:
        "Condition centrale : l’incitation doit viser une opposition violente à l’action de l’autorité.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Personne visée",
    question: "La provocation directe à la rébellion doit s’adresser :",
    options: [
      "Pas nécessairement à une personne déterminée",
      "Obligatoirement à une personne nommément désignée",
      "Uniquement à un agent public",
    ],
    answer: "Pas nécessairement à une personne déterminée",
    explanation:
        "L’article vise aussi la distribution d’écrits / moyens de diffusion : pas besoin d’une cible déterminée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Cris et discours",
    question: "Les cris ou discours incriminés doivent avoir été tenus :",
    options: [
      "Sur la voie publique ou dans un lieu public",
      "Uniquement dans un commissariat",
      "Uniquement sur Internet",
    ],
    answer: "Sur la voie publique ou dans un lieu public",
    explanation:
        "Le support “cris/discours publics” suppose la voie publique ou un lieu public.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Écrits",
    question: "Les écrits peuvent constituer une provocation s’ils sont :",
    options: [
      "Affichés ou distribués",
      "Gardés dans un carnet privé",
      "Détruits avant toute diffusion",
    ],
    answer: "Affichés ou distribués",
    explanation: "Le texte vise les écrits affichés ou distribués.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Tracts",
    question:
        "Des tracts appelant à la rébellion peuvent caractériser l’infraction s’ils sont :",
    options: [
      "Remis de la main à la main ou distribués dans des boîtes aux lettres",
      "Écrits mais jamais diffusés",
      "Envoyés uniquement à soi-même",
    ],
    answer:
        "Remis de la main à la main ou distribués dans des boîtes aux lettres",
    explanation: "Le document cite explicitement ces modes de distribution.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Presse",
    question:
        "Si la provocation est commise par presse écrite ou audiovisuelle, on applique :",
    options: [
      "Les dispositions particulières (loi du 29 juillet 1881 sur la presse)",
      "Uniquement l’article 433-6",
      "Uniquement le Code de la route",
    ],
    answer:
        "Les dispositions particulières (loi du 29 juillet 1881 sur la presse)",
    explanation:
        "433-10 al.2 renvoie aux règles spécifiques de la presse (loi 1881).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Infraction formelle",
    question:
        "On dit que la provocation à la rébellion est une infraction formelle car :",
    options: [
      "Elle est constituée par le seul acte, même sans résultat",
      "Elle exige une rébellion effectivement commise",
      "Elle exige une blessure d’un agent",
    ],
    answer: "Elle est constituée par le seul acte, même sans résultat",
    explanation:
        "Peu importe que l’incitation ait été suivie d’effet : le résultat est indifférent.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Tentative",
    question:
        "Concernant la provocation directe à la rébellion (433-10), la tentative est :",
    options: [
      "Non punissable (TENTATIVE : NON)",
      "Punissable dans tous les cas",
      "Punissable seulement si un agent est blessé",
    ],
    answer: "Non punissable (TENTATIVE : NON)",
    explanation: "Le document précise : TENTATIVE : NON.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Complicité",
    question: "La complicité de provocation directe à la rébellion est :",
    options: [
      "Oui, punissable (COMPLICITÉ : OUI)",
      "Non, jamais punissable",
      "Punissable seulement pour les mineurs",
    ],
    answer: "Oui, punissable (COMPLICITÉ : OUI)",
    explanation:
        "Le document indique que la complicité est punissable selon 121-6 et 121-7 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Base légale complicité",
    question: "Les textes généraux de la complicité mentionnés sont :",
    options: [
      "Articles 121-6 et 121-7 du Code pénal",
      "Articles 433-6 et 433-7",
      "Article 223-1 uniquement",
    ],
    answer: "Articles 121-6 et 121-7 du Code pénal",
    explanation: "Le document renvoie aux articles 121-6 et 121-7 CP.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Personnes morales",
    question:
        "Les personnes morales peuvent être pénalement responsables sur le fondement de :",
    options: [
      "L’article 121-2 du Code pénal",
      "L’article 433-9 uniquement",
      "Aucun texte",
    ],
    answer: "L’article 121-2 du Code pénal",
    explanation:
        "Le document précise la responsabilité pénale des personnes morales (121-2 CP).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Circonstances aggravantes",
    question:
        "La provocation directe à la rébellion (433-10) comporte des circonstances aggravantes :",
    options: ["Aucune", "Oui, en réunion", "Oui, si l’auteur est détenu"],
    answer: "Aucune",
    explanation:
        "Le document indique explicitement : IV — CIRCONSTANCES AGGRAVANTES : AUCUNE.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Notion de complice",
    question:
        "Si la provocation est suivie d’effet, l’auteur peut être poursuivi comme :",
    options: [
      "Complice de la rébellion par instruction (121-7 CP)",
      "Auteur de violences volontaires uniquement",
      "Victime d’outrage",
    ],
    answer: "Complice de la rébellion par instruction (121-7 CP)",
    explanation:
        "Nota : si suivie d’effet, poursuites possibles comme complice par instruction (121-7).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Exemple jurisprudentiel",
    question:
        "Dans Cass. crim., 21 février 2017, la provocation est caractérisée notamment car le prévenu :",
    options: [
      "Incite la foule à faire obstacle à son interpellation en appelant à les 'défoncer'",
      "Refuse de donner ses papiers calmement",
      "Filme la scène sans parler",
    ],
    answer:
        "Incite la foule à faire obstacle à son interpellation en appelant à les 'défoncer'",
    explanation:
        "Le cas cité : harangue la foule et incite à l’opposition violente à l’interpellation.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // RÉBELLION — ARTICLES 433-6 À 433-9 CP
  // (Banque étendue)
  // =========================================================
  const QuizQuestion(
    category: "Rébellion — Définition complète",
    question:
        "La rébellion correspond au fait d’opposer une résistance violente à :",
    options: [
      "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public agissant dans l’exercice de ses fonctions",
      "N’importe quel particulier",
      "Un commerçant refusant un paiement",
    ],
    answer:
        "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public agissant dans l’exercice de ses fonctions",
    explanation:
        "Définition issue de 433-6 CP : résistance violente à une personne protégée agissant dans l’exercice de ses fonctions.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Répression",
    question: "La rébellion est définie par 433-6 CP et réprimée par :",
    options: [
      "L’article 433-7 du Code pénal",
      "L’article 433-10 du Code pénal",
      "L’article 434-5 du Code pénal",
    ],
    answer: "L’article 433-7 du Code pénal",
    explanation: "Le document précise : 433-6 définit, 433-7 réprime.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Dépositaire autorité publique",
    question: "Est dépositaire de l’autorité publique celui qui :",
    options: [
      "Dispose d’un pouvoir de décision fondé sur une parcelle d’autorité publique",
      "Rend un simple service bénévole",
      "N’a aucun pouvoir et agit pour lui-même",
    ],
    answer:
        "Dispose d’un pouvoir de décision fondé sur une parcelle d’autorité publique",
    explanation:
        "Définition rappelée : pouvoir de décision attaché aux fonctions.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Exemples dépositaires",
    question:
        "Parmi ces personnes, lesquelles sont notamment citées comme dépositaires de l’autorité publique ?",
    options: [
      "Policiers, gendarmes, douaniers, huissiers",
      "Livreurs et agents d’entretien privés",
      "Clients d’un service public",
    ],
    answer: "Policiers, gendarmes, douaniers, huissiers",
    explanation:
        "Le document liste plusieurs exemples : policiers, gendarmes, douaniers, huissiers, etc.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Élus locaux",
    question:
        "Les responsables des exécutifs locaux (maires, présidents d’intercommunalités, etc.) sont cités comme :",
    options: [
      "Dépositaires de l’autorité publique",
      "Toujours simples particuliers",
      "Toujours jurés d’assises",
    ],
    answer: "Dépositaires de l’autorité publique",
    explanation:
        "Ils figurent dans la liste des personnes concernées comme dépositaires.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Mission de service public",
    question: "Est chargé d’une mission de service public celui qui :",
    options: [
      "Accomplit un service public à titre temporaire ou permanent, volontairement ou sur réquisition",
      "Exerce forcément un pouvoir de commandement",
      "Agit exclusivement pour un intérêt privé",
    ],
    answer:
        "Accomplit un service public à titre temporaire ou permanent, volontairement ou sur réquisition",
    explanation:
        "Définition donnée dans le document (mission d’intérêt général sans pouvoir de décision).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Exemple service public",
    question:
        "Le document donne comme exemple de personne chargée d’une mission de service public :",
    options: [
      "Le serrurier requis par l’OPJ",
      "Un voisin témoin",
      "Un vendeur de magasin",
    ],
    answer: "Le serrurier requis par l’OPJ",
    explanation: "Exemple explicite : serrurier requis par l’OPJ.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Condition d’exercice",
    question:
        "Il n’y a rébellion que si la résistance se manifeste alors que l’agent agit :",
    options: [
      "Dans le cadre de ses fonctions",
      "Uniquement en uniforme",
      "Uniquement la nuit",
    ],
    answer: "Dans le cadre de ses fonctions",
    explanation: "Condition essentielle : exercice des fonctions.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — RGE police nationale",
    question:
        "Selon l’art. 113-3 du règlement général d’emploi, un policier même hors service est tenu :",
    options: [
      "D’intervenir pour assistance, prévenir/réprimer trouble à l’ordre public, protéger personnes et biens",
      "De ne jamais intervenir",
      "D’appeler uniquement un collègue",
    ],
    answer:
        "D’intervenir pour assistance, prévenir/réprimer trouble à l’ordre public, protéger personnes et biens",
    explanation:
        "Le document rappelle l’obligation d’intervention même hors service.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Jurisprudence hors service",
    question:
        "Cass. crim., 15 décembre 2015 retient qu’un policier est en service s’il intervient :",
    options: [
      "Dans sa circonscription et dans le cadre de ses attributions, de sa propre initiative ou sur réquisition",
      "Uniquement après ordre écrit",
      "Uniquement s’il est en uniforme",
    ],
    answer:
        "Dans sa circonscription et dans le cadre de ses attributions, de sa propre initiative ou sur réquisition",
    explanation: "Jurisprudence citée dans le document.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Pour l’exécution des lois",
    question: "Il y a rébellion si l’agent agit notamment dans le cadre :",
    options: [
      "D’une mission de police judiciaire ou administrative",
      "D’un litige strictement privé",
      "D’une discussion amicale",
    ],
    answer: "D’une mission de police judiciaire ou administrative",
    explanation:
        "Le document vise PJ (flagrant, préliminaire, CR, mandats...) et PA (ordre public).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Ordre implicite",
    question:
        "Le document précise que l’ordre à l’origine de l’intervention peut être :",
    options: [
      "Implicite (ex : contrôle d’identité APJ sous ordre et responsabilité OPJ)",
      "Toujours écrit et signé",
      "Toujours judiciaire uniquement",
    ],
    answer:
        "Implicite (ex : contrôle d’identité APJ sous ordre et responsabilité OPJ)",
    explanation:
        "L’ordre peut être implicite ou nécessiter autorisation/réquisition selon les cas.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Illégalité de l’acte",
    question:
        "Même si l’acte accompli par l’agent se révèle illégal, la rébellion :",
    options: [
      "Peut être constituée (illégalité sans incidence)",
      "Est automatiquement exclue",
      "Devient uniquement une contravention",
    ],
    answer: "Peut être constituée (illégalité sans incidence)",
    explanation:
        "Cass. crim., 1er sept. 2004 : l’illégalité supposée est sans incidence.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Litige privé",
    question:
        "Si l’agent commet un acte sans lien avec sa mission (litige privé), la résistance :",
    options: [
      "Ne constituerait pas une rébellion",
      "Constitue forcément une rébellion",
      "Constitue automatiquement un outrage",
    ],
    answer: "Ne constituerait pas une rébellion",
    explanation:
        "Le document précise que l’absence de lien missionnel exclut la rébellion.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Résistance violente",
    question: "La rébellion suppose un acte de résistance :",
    options: [
      "Violente (résistance active, initiative de confrontation)",
      "Purement passif",
      "Uniquement verbal",
    ],
    answer: "Violente (résistance active, initiative de confrontation)",
    explanation: "Sont exclus : simple désobéissance et obstacle passif.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Exclusion obstacle passif",
    question:
        "Quel exemple est cité comme ne caractérisant pas la rébellion (obstacle passif) ?",
    options: [
      "S’accrocher au volant et refuser de suivre sans violence",
      "Porter un coup de poing à un agent",
      "Donner un coup de pied à un agent",
    ],
    answer: "S’accrocher au volant et refuser de suivre sans violence",
    explanation:
        "Cass. crim., 1er mars 2006 : refus passif d’un sexagénaire frêle accroché au volant.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Violence sans coups",
    question: "La jurisprudence peut retenir la rébellion même si l’auteur :",
    options: [
      "Se débat et résiste activement sans frapper les agents",
      "Reste immobile et silencieux",
      "S’endort volontairement",
    ],
    answer: "Se débat et résiste activement sans frapper les agents",
    explanation:
        "Cass. crim., 7 nov. 2006 : résistance active, fuite, sans coups portés.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Distinction violences/rébellion",
    question:
        "On retient plutôt la rébellion lorsque l’acte violent est commis :",
    options: [
      "Alors que l’agent exerce ses fonctions à l’égard de l’individu",
      "Toujours, même si l’agent n’agit pas dans ses fonctions",
      "Uniquement si l’agent est blessé gravement",
    ],
    answer: "Alors que l’agent exerce ses fonctions à l’égard de l’individu",
    explanation:
        "Cass. crim., 21 fév. 2006 : si l’acte violent répond à l’exercice des fonctions envers l’auteur → rébellion.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Actes distincts",
    question:
        "Si les violences ne sont pas distinctes de la résistance violente, la Cour retient :",
    options: [
      "La rébellion",
      "Deux infractions systématiques",
      "Aucune infraction",
    ],
    answer: "La rébellion",
    explanation:
        "Cass. crim., 21 fév. 2006 : pas d’actes distincts → qualification de rébellion.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Élément moral 1",
    question: "L’élément moral suppose généralement :",
    options: [
      "La connaissance de la qualité de l’agent (uniforme/signes) et l’objet de l’intervention",
      "L’ignorance totale de l’identité de l’agent",
      "Une simple maladresse",
    ],
    answer:
        "La connaissance de la qualité de l’agent (uniforme/signes) et l’objet de l’intervention",
    explanation:
        "La connaissance découle souvent de l’uniforme/signes distinctifs et des explications données.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Élément moral 2",
    question: "Le mobile de l’auteur de la rébellion est :",
    options: ["Indifférent", "Toujours aggravant", "Toujours justificatif"],
    answer: "Indifférent",
    explanation:
        "Infraction intentionnelle : volonté de résister, mobile indifférent.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Circonstance aggravante réunion",
    question: "La rébellion est aggravée lorsqu’elle est commise :",
    options: [
      "En réunion (433-7 al.2)",
      "En journée",
      "En présence de témoins",
    ],
    answer: "En réunion (433-7 al.2)",
    explanation: "Aggravation expressément prévue à 433-7 al.2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Circonstance aggravante arme",
    question: "La rébellion est aggravée lorsque l’auteur est :",
    options: [
      "Porteur d’une arme apparente ou cachée (433-8)",
      "Sans papiers d’identité",
      "En retard",
    ],
    answer: "Porteur d’une arme apparente ou cachée (433-8)",
    explanation: "Aggravation prévue par 433-8 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Aggravation maximale",
    question:
        "Un degré d’aggravation supplémentaire est prévu lorsque la rébellion armée est commise :",
    options: ["En réunion", "Par un mineur", "Sur la voie publique"],
    answer: "En réunion",
    explanation:
        "Le document mentionne une aggravation supplémentaire si rébellion armée + réunion.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Auteur détenu",
    question:
        "La rébellion est traitée spécifiquement par l’article 433-9 CP lorsque l’auteur :",
    options: ["Est détenu", "Est mineur", "Est journaliste"],
    answer: "Est détenu",
    explanation: "433-9 vise la rébellion commise par une personne détenue.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Peines simple",
    question: "La rébellion simple (433-7 al.1) est punie de :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation: "Peines principales : 2 ans + 30 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Peines réunion",
    question: "La rébellion aggravée en réunion (433-7 al.2) est punie de :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "10 ans d’emprisonnement et 150 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Aggravation en réunion : 3 ans + 45 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Peines arme",
    question: "La rébellion avec port d’arme (433-8 al.1) est punie de :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "433-8 al.1 : 5 ans + 75 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Peines arme + réunion",
    question:
        "La rébellion armée commise en réunion (433-8 al.2) est punie de :",
    options: [
      "10 ans d’emprisonnement et 150 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "10 ans d’emprisonnement et 150 000 € d’amende",
    explanation: "Aggravation maximale : 10 ans + 150 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Rébellion détenu",
    question:
        "Lorsque l’auteur de la rébellion est détenu (433-9), la répression prévoit :",
    options: [
      "Cumul des peines de la rébellion et de l’infraction pour laquelle il est détenu",
      "Un simple avertissement",
      "Uniquement une amende",
    ],
    answer:
        "Cumul des peines de la rébellion et de l’infraction pour laquelle il est détenu",
    explanation: "Le document indique un cumul des peines dans ce cas.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Tentative",
    question: "Concernant la rébellion, la tentative est :",
    options: [
      "Non (TENTATIVE : NON)",
      "Oui, toujours",
      "Oui, seulement en réunion",
    ],
    answer: "Non (TENTATIVE : NON)",
    explanation: "Le document précise : TENTATIVE : NON.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Complicité",
    question: "Concernant la rébellion, la complicité est :",
    options: [
      "Oui (COMPLICITÉ : OUI)",
      "Non",
      "Uniquement pour les personnes morales",
    ],
    answer: "Oui (COMPLICITÉ : OUI)",
    explanation: "Complicité punissable selon 121-6/121-7 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Exemple complicité",
    question:
        "Dans Cass. crim., 8 décembre 2009, constitue une complicité de rébellion le fait :",
    options: [
      "De jeter des graviers/débris de verre sur un policier en sommant de relâcher un interpellé",
      "De filmer la scène",
      "De s’éloigner des lieux",
    ],
    answer:
        "De jeter des graviers/débris de verre sur un policier en sommant de relâcher un interpellé",
    explanation:
        "Le document cite cet exemple comme aide/assistance à la résistance.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Personnes morales",
    question:
        "Les personnes morales peuvent être responsables de rébellion conformément à :",
    options: [
      "L’article 121-2 du Code pénal",
      "L’article 433-10 uniquement",
      "Aucun texte",
    ],
    answer: "L’article 121-2 du Code pénal",
    explanation: "Le document rappelle 121-2 CP pour les personnes morales.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // MENACES DE CRIME OU DÉLIT ENVERS PERSONNES PROTÉGÉES — 433-3
  // (Banque étendue)
  // =========================================================
  const QuizQuestion(
    category: "Menaces 433-3 — Définition (objet)",
    question: "L’article 433-3 vise la menace de commettre :",
    options: [
      "Un crime ou un délit contre les personnes ou les biens",
      "Une simple contravention",
      "Un acte uniquement moral",
    ],
    answer: "Un crime ou un délit contre les personnes ou les biens",
    explanation:
        "La menace doit annoncer la commission prochaine d’un crime/délit contre personnes ou biens.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Bien visé",
    question:
        "Si la menace concerne un bien, elle peut consister en l’annonce :",
    options: [
      "D’une destruction, dégradation ou détérioration",
      "D’un simple déménagement",
      "D’un prêt d’objet",
    ],
    answer: "D’une destruction, dégradation ou détérioration",
    explanation:
        "Le document précise la nature possible du mal annoncé concernant un bien.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Réitération",
    question: "La menace 433-3 est punissable :",
    options: [
      "Même si elle n’a pas été réitérée ni matérialisée",
      "Uniquement si elle est répétée 3 fois",
      "Uniquement si elle est exécutée",
    ],
    answer: "Même si elle n’a pas été réitérée ni matérialisée",
    explanation:
        "Le document indique l’absence d’exigence de réitération ou matérialisation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Destinataires",
    question: "Les destinataires des menaces 433-3 sont :",
    options: [
      "Énumérés de manière limitative par la loi",
      "Toute personne sans exception",
      "Uniquement les policiers",
    ],
    answer: "Énumérés de manière limitative par la loi",
    explanation:
        "La loi liste précisément les catégories de victimes protégées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Mandat électif",
    question:
        "Sont visées par l’expression “mandat électif public” notamment :",
    options: [
      "Députés/sénateurs, élus régionaux/départementaux/communaux, eurodéputés",
      "Uniquement les candidats",
      "Uniquement les ministres",
    ],
    answer:
        "Députés/sénateurs, élus régionaux/départementaux/communaux, eurodéputés",
    explanation:
        "Le document détaille des exemples de mandats électifs publics.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Dépositaire autorité",
    question:
        "Parmi les catégories citées comme dépositaires de l’autorité publique :",
    options: [
      "Magistrats, officiers publics/ministériels, gendarmes, policiers, douanes, inspection du travail, pénitentiaire",
      "Clients d’un service public",
      "Bénévoles d’association",
    ],
    answer:
        "Magistrats, officiers publics/ministériels, gendarmes, policiers, douanes, inspection du travail, pénitentiaire",
    explanation: "Le document énumère ces catégories au titre de 433-3.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Mission service public",
    question:
        "Sont cités comme personnes chargées d’une mission de service public (433-3) :",
    options: [
      "Sapeurs-pompiers/marins-pompiers, enseignants, agents de transport public, professionnels de santé",
      "Uniquement les magistrats",
      "Uniquement les élus",
    ],
    answer:
        "Sapeurs-pompiers/marins-pompiers, enseignants, agents de transport public, professionnels de santé",
    explanation: "Le document cite ces exemples (alinéas 1 et 2).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Activité privée de sécurité",
    question:
        "L’article 433-3 protège aussi les personnes exerçant une activité privée de sécurité :",
    options: [
      "Mentionnée aux articles L.611-1 ou L.621-1 CSI, dans l’exercice des fonctions",
      "Uniquement en dehors de leurs fonctions",
      "Uniquement si elles sont élus",
    ],
    answer:
        "Mentionnée aux articles L.611-1 ou L.621-1 CSI, dans l’exercice des fonctions",
    explanation:
        "Le document vise explicitement ces activités privées de sécurité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Proches",
    question: "L’article 433-3 protège aussi :",
    options: [
      "Le conjoint, ascendants, descendants, ou personne vivant habituellement au domicile, en raison des fonctions",
      "Uniquement les amis",
      "Uniquement les collègues",
    ],
    answer:
        "Le conjoint, ascendants, descendants, ou personne vivant habituellement au domicile, en raison des fonctions",
    explanation:
        "Alinéa 4 : proches et cohabitants, en raison des fonctions exercées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Lien avec fonctions",
    question:
        "Pour les personnes du 1er alinéa, l’infraction est constituée si les menaces interviennent :",
    options: [
      "Dans l’exercice ou du fait de l’exercice des fonctions",
      "Uniquement le soir",
      "Uniquement par écrit",
    ],
    answer: "Dans l’exercice ou du fait de l’exercice des fonctions",
    explanation:
        "Le document distingue : alinéa 1 = dans l’exercice ou du fait ; alinéas 2 et 3 = dans l’exercice.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Alinéas 2 et 3",
    question:
        "Pour les victimes des alinéas 2 et 3, la menace doit avoir lieu :",
    options: [
      "Dans l’exercice des fonctions",
      "Du fait des fonctions uniquement",
      "Sans aucun lien avec les fonctions",
    ],
    answer: "Dans l’exercice des fonctions",
    explanation:
        "Le document précise : alinéas 2 et 3 → dans l’exercice des fonctions.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Qualité connue",
    question: "La qualité de la victime doit être :",
    options: [
      "Apparente ou connue de l’auteur",
      "Nécessairement écrite sur un papier",
      "Toujours ignorée",
    ],
    answer: "Apparente ou connue de l’auteur",
    explanation: "Condition : l’auteur agit en raison de cette qualité.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Élément moral",
    question: "L’élément moral des menaces 433-3 suppose que l’auteur :",
    options: [
      "A conscience du trouble créé par les menaces",
      "Veuille forcément exécuter la menace",
      "Ait forcément les moyens de l’exécuter",
    ],
    answer: "A conscience du trouble créé par les menaces",
    explanation:
        "Peu importe intention/moyens d’exécution ; il faut conscience du trouble.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Intention d’exécution",
    question:
        "Pour caractériser l’infraction 433-3, l’intention de mettre la menace à exécution :",
    options: [
      "Est indifférente",
      "Est obligatoire",
      "Est présumée irréfragable",
    ],
    answer: "Est indifférente",
    explanation:
        "Le document le dit clairement : peu importe intention/moyens.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Texte",
    question:
        "Les menaces envers personnes protégées sont définies et réprimées par :",
    options: [
      "L’article 433-3 du Code pénal",
      "L’article 433-10 du Code pénal",
      "L’article 432-1 du Code pénal",
    ],
    answer: "L’article 433-3 du Code pénal",
    explanation: "Base légale : 433-3 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Infractions spécifiques justice",
    question:
        "Le document rappelle que certaines menaces pour entraver l’action de la justice relèvent d’infractions spécifiques :",
    options: [
      "Articles 434-5, 434-8 et 434-15 CP",
      "Articles 121-6 et 121-7 CP",
      "Articles 222-7 et 222-8 CP",
    ],
    answer: "Articles 434-5, 434-8 et 434-15 CP",
    explanation:
        "Mention explicite : menaces visant la justice → infractions spécifiques 434-5/434-8/434-15.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Aggravation al.5",
    question:
        "L’article 433-3 al.5 prévoit une aggravation notamment lorsque :",
    options: [
      "Il s’agit d’une menace de mort ou d’une menace contre les biens dangereuse pour les personnes",
      "La menace est faite par SMS uniquement",
      "La victime ne porte pas d’uniforme",
    ],
    answer:
        "Il s’agit d’une menace de mort ou d’une menace contre les biens dangereuse pour les personnes",
    explanation: "Aggravation prévue à l’alinéa 5.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Aggravation al.6 (but)",
    question:
        "L’article 433-3 al.6 vise les menaces/violences/intimidations utilisées pour :",
    options: [
      "Obtenir qu’une personne accomplisse ou s’abstienne d’un acte de sa fonction/mission/mandat, ou faciliter par sa fonction",
      "Obtenir un cadeau personnel sans lien",
      "Éviter une contravention de stationnement uniquement",
    ],
    answer:
        "Obtenir qu’une personne accomplisse ou s’abstienne d’un acte de sa fonction/mission/mandat, ou faciliter par sa fonction",
    explanation:
        "Al.6 : pression pour obtenir action/abstention liée aux fonctions/mission/mandat.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Aggravation al.6 (abus d’autorité)",
    question:
        "L’alinéa 6 vise aussi le fait de faire pression pour qu’une personne abuse de son autorité (vraie ou supposée) afin d’obtenir :",
    options: [
      "Distinctions, emplois, marchés, ou toute décision favorable d’une autorité/administration publique",
      "Uniquement une réduction en magasin",
      "Uniquement un remboursement privé",
    ],
    answer:
        "Distinctions, emplois, marchés, ou toute décision favorable d’une autorité/administration publique",
    explanation:
        "Al.6 : obtenir une décision favorable via abus d’autorité vraie ou supposée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Exclusion 433-3-1",
    question:
        "Le document précise que les dispositions de l’alinéa 6 ne s’appliquent pas aux faits prévus par :",
    options: [
      "L’article 433-3-1 du Code pénal",
      "L’article 433-10 du Code pénal",
      "L’article 434-5 du Code pénal",
    ],
    answer: "L’article 433-3-1 du Code pénal",
    explanation:
        "Exclusion explicite : al.6 ne s’applique pas aux faits relevant de 433-3-1.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Peines simples",
    question: "Les menaces simples (433-3) sont punies de :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Peines principales : 3 ans + 45 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Peines aggravées al.5",
    question:
        "Les menaces aggravées par l’alinéa 5 (menace de mort / biens dangereuse) sont punies de :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "10 ans d’emprisonnement et 150 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Aggravation al.5 : 5 ans + 75 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Peines aggravées al.6",
    question:
        "Les faits aggravés par l’alinéa 6 (pression pour acte de fonction/abus d’autorité) sont punis de :",
    options: [
      "10 ans d’emprisonnement et 150 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "10 ans d’emprisonnement et 150 000 € d’amende",
    explanation: "Aggravation al.6 : 10 ans + 150 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Tentative",
    question: "Concernant les menaces 433-3, la tentative est :",
    options: ["Non (TENTATIVE : NON)", "Oui", "Oui si menace de mort"],
    answer: "Non (TENTATIVE : NON)",
    explanation: "Le document précise : TENTATIVE : NON.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Complicité",
    question: "Concernant les menaces 433-3, la complicité est :",
    options: [
      "Oui (COMPLICITÉ : OUI)",
      "Non",
      "Seulement si violence physique",
    ],
    answer: "Oui (COMPLICITÉ : OUI)",
    explanation: "Complicité punissable selon 121-6/121-7 CP.",
    difficulty: "Facile",
  ),

  // =========================================================
  // 433-3-1 — MENACES/VIOLENCES/INTIMIDATION POUR DÉROGATION
  // AUX RÈGLES DE FONCTIONNEMENT D’UN SERVICE PUBLIC
  // (Banque complète)
  // =========================================================
  const QuizQuestion(
    category: "433-3-1 — Définition",
    question:
        "L’infraction 433-3-1 consiste à user de menaces/violences/intimidation :",
    options: [
      "Pour obtenir une exemption totale/partielle ou une application différenciée des règles d’un service public",
      "Pour insulter un agent public",
      "Pour refuser d’obtempérer sans violence",
    ],
    answer:
        "Pour obtenir une exemption totale/partielle ou une application différenciée des règles d’un service public",
    explanation:
        "But central : obtenir une application dérogatoire des règles de fonctionnement d’un service public.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "433-3-1 — Élément légal",
    question:
        "L’infraction relative à la dérogation aux règles d’un service public est définie et réprimée par :",
    options: [
      "L’article 433-3-1 du Code pénal",
      "L’article 433-3 du Code pénal",
      "L’article 433-10 du Code pénal",
    ],
    answer: "L’article 433-3-1 du Code pénal",
    explanation: "Base légale : 433-3-1 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Comportements visés",
    question:
        "Le 433-3-1 permet de sanctionner des comportements variés car il vise :",
    options: [
      "Les menaces (même sans réitération), les violences et tout acte d’intimidation",
      "Uniquement les violences avec ITT",
      "Uniquement les menaces écrites",
    ],
    answer:
        "Les menaces (même sans réitération), les violences et tout acte d’intimidation",
    explanation:
        "Le texte vise menaces, violences et tout acte d’intimidation, et les menaces même sans réitération.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "433-3-1 — Victime",
    question: "La victime visée par 433-3-1 est :",
    options: [
      "Toute personne participant à l’exécution d’une mission de service public",
      "Uniquement une personne dépositaire de l’autorité publique",
      "Uniquement un élu",
    ],
    answer:
        "Toute personne participant à l’exécution d’une mission de service public",
    explanation:
        "Sans condition de statut, fonction ou responsabilités : toute personne participant au service public.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "433-3-1 — Condition de statut",
    question:
        "Pour 433-3-1, il existe une condition de statut/fonction/responsabilités pour la victime :",
    options: [
      "Non, aucune condition",
      "Oui, uniquement fonctionnaire",
      "Oui, uniquement dépositaire de l’autorité publique",
    ],
    answer: "Non, aucune condition",
    explanation:
        "Le texte précise : sans condition de statut, de fonction ou de responsabilités.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Intention particulière",
    question: "Pour caractériser 433-3-1, il faut démontrer :",
    options: [
      "Une intention particulière d’obtenir une application dérogatoire des règles",
      "Une intention de tuer",
      "Une intention d’insulter",
    ],
    answer:
        "Une intention particulière d’obtenir une application dérogatoire des règles",
    explanation:
        "Le document insiste sur la démonstration d’une intention particulière (objectif précis).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Preuve de l’intention",
    question: "L’intention d’obtenir un régime dérogatoire peut être prouvée :",
    options: [
      "Par des propos explicites ou par des éléments de contexte",
      "Uniquement par aveu écrit",
      "Uniquement par témoins policiers",
    ],
    answer: "Par des propos explicites ou par des éléments de contexte",
    explanation:
        "Le document indique que la preuve peut venir d’une expression claire ou du contexte.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "433-3-1 — Exemples (piscine)",
    question: "Exemple donné par le document d’un objectif de dérogation :",
    options: [
      "Obtenir des horaires réservés aux femmes pour l’accès à une piscine",
      "Obtenir un remboursement bancaire",
      "Obtenir un emploi privé",
    ],
    answer:
        "Obtenir des horaires réservés aux femmes pour l’accès à une piscine",
    explanation: "Exemple cité : horaires réservés pour accès piscine.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Exemples (cantine)",
    question: "Autre exemple de dérogation cité :",
    options: [
      "Obtenir un régime alimentaire particulier dans les cantines scolaires",
      "Obtenir un nouveau téléphone",
      "Obtenir une remise sur un billet de concert",
    ],
    answer:
        "Obtenir un régime alimentaire particulier dans les cantines scolaires",
    explanation: "Exemple cité : régime alimentaire particulier en cantine.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Bénéfice",
    question:
        "Le comportement incriminé doit poursuivre l’objectif d’obtenir une dérogation :",
    options: [
      "Pour soi-même ou pour autrui",
      "Uniquement pour soi",
      "Uniquement pour la victime",
    ],
    answer: "Pour soi-même ou pour autrui",
    explanation: "Le document précise : au bénéfice de soi-même ou d’autrui.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Élément moral (trouble)",
    question: "Pour 433-3-1, l’auteur doit avoir conscience :",
    options: [
      "Du trouble créé par menaces/violences dans l’esprit de la victime",
      "D’être filmé",
      "D’être en tort civilement",
    ],
    answer: "Du trouble créé par menaces/violences dans l’esprit de la victime",
    explanation:
        "Le texte reprend la logique : conscience du trouble ; intention d’obtenir la dérogation.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "433-3-1 — Intention d’exécution",
    question: "Pour 433-3-1, l’intention de mettre les menaces à exécution :",
    options: [
      "Est indifférente",
      "Est obligatoire",
      "Doit être prouvée par un acte préparatoire",
    ],
    answer: "Est indifférente",
    explanation:
        "Peu importe intention/moyens d’exécution, c’est l’objectif dérogatoire qui compte.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "433-3-1 — Circonstances aggravantes",
    question:
        "Le document indique pour 433-3-1 des circonstances aggravantes :",
    options: ["Aucune", "Oui, en réunion", "Oui, si arme"],
    answer: "Aucune",
    explanation: "IV — CIRCONSTANCES AGGRAVANTES : AUCUNE.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Peines",
    question: "Les peines principales encourues pour 433-3-1 sont :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "V — Répression : 5 ans + 75 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Personnes morales",
    question: "Concernant 433-3-1, les personnes morales :",
    options: [
      "Peuvent être reconnues responsables",
      "Ne peuvent jamais être responsables",
      "Sont responsables uniquement en cas de réunion",
    ],
    answer: "Peuvent être reconnues responsables",
    explanation:
        "Le document précise que les personnes morales peuvent être reconnues responsables.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Tentative",
    question: "Concernant 433-3-1, la tentative est :",
    options: ["Non (TENTATIVE : NON)", "Oui", "Oui uniquement si violence"],
    answer: "Non (TENTATIVE : NON)",
    explanation: "Le document précise : TENTATIVE : NON.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Complicité",
    question: "Concernant 433-3-1, la complicité est :",
    options: [
      "Oui (COMPLICITÉ : OUI)",
      "Non",
      "Uniquement si l’auteur principal est condamné",
    ],
    answer: "Oui (COMPLICITÉ : OUI)",
    explanation: "Complicité punissable selon 121-6/121-7 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Nature de l’objectif",
    question: "L’objectif visé par 433-3-1 est d’obtenir :",
    options: [
      "Une exemption totale/partielle ou une application différenciée des règles du service public",
      "Une décision de justice",
      "Une remise commerciale",
    ],
    answer:
        "Une exemption totale/partielle ou une application différenciée des règles du service public",
    explanation:
        "C’est le cœur du texte : application dérogatoire des règles de fonctionnement.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // QUESTIONS “PIÈGES” — DISTINCTIONS
  // Rébellion vs Violences volontaires vs Outrage vs Refus d’obtempérer
  // + QCM Vrai/Faux (format options)
  // + Mini cas pratiques (qualification + article + peine)
  // =========================================================

  // ---------------------------------------------------------
  // OUTRAGE — RAPPELS (Général)  ⚠️
  // NB: Les articles/outils exacts peuvent varier selon la situation.
  // Ici, je reste sur le socle classique : outrage = propos/gestes/écrits
  // portant atteinte à la dignité/respect dû à la fonction, pendant/dû aux fonctions.
  // ---------------------------------------------------------
  const QuizQuestion(
    category: "Distinctions — Rébellion vs Outrage",
    question: "La différence principale entre outrage et rébellion est que :",
    options: [
      "L’outrage est une atteinte verbale/gestuelle à la dignité, la rébellion est une résistance violente",
      "L’outrage implique toujours une violence physique",
      "La rébellion ne concerne jamais les forces de l’ordre",
    ],
    answer:
        "L’outrage est une atteinte verbale/gestuelle à la dignité, la rébellion est une résistance violente",
    explanation:
        "Outrage = paroles/gestes/écrits atteinte au respect dû à la fonction. Rébellion = résistance violente à l’action de l’agent.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Distinctions — Rébellion vs Refus d’obtempérer",
    question:
        "Le refus d’obtempérer se distingue classiquement de la rébellion car :",
    options: [
      "Le refus d’obtempérer vise la désobéissance à un ordre (souvent routier), la rébellion suppose une résistance violente",
      "Le refus d’obtempérer suppose forcément des coups portés",
      "La rébellion est toujours routière",
    ],
    answer:
        "Le refus d’obtempérer vise la désobéissance à un ordre (souvent routier), la rébellion suppose une résistance violente",
    explanation:
        "Dans ton cours : rébellion = violence/résistance active. Le refus d’obtempérer = non-exécution d’un ordre (souvent en circulation) sans nécessaire violence.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Distinctions — Rébellion vs Obstacle passif",
    question: "Un obstacle purement passif à l’action de l’agent :",
    options: [
      "Ne caractérise pas la rébellion",
      "Caractérise toujours la rébellion",
      "Caractérise automatiquement une provocation à la rébellion",
    ],
    answer: "Ne caractérise pas la rébellion",
    explanation:
        "Ton doc : la simple désobéissance et l’obstacle passif sont exclus de la rébellion.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Distinctions — Rébellion (violence) : exemple",
    question:
        "Lequel de ces comportements correspond le plus à une rébellion ?",
    options: [
      "Se débattre violemment pendant l’interpellation en bousculant l’agent",
      "Dire : 'Je ne suis pas d’accord' sans geste",
      "Rester assis sans bouger",
    ],
    answer:
        "Se débattre violemment pendant l’interpellation en bousculant l’agent",
    explanation: "Résistance active et violente = rébellion.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Distinctions — Violences volontaires vs Rébellion",
    question:
        "On retient plutôt les violences volontaires aggravées (plutôt que la rébellion) lorsque :",
    options: [
      "L’agent public n’exerçait pas de prérogative à l’égard de l’auteur au moment du coup",
      "L’agent était en train d’interpeller l’auteur et celui-ci répond par un acte violent",
      "Il n’y a aucun acte violent",
    ],
    answer:
        "L’agent public n’exerçait pas de prérogative à l’égard de l’auteur au moment du coup",
    explanation:
        "Ton doc : si l’agent n’exerce pas sa mission envers l’individu, on bascule plutôt sur violences aggravées. Sinon, rébellion.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Distinctions — Rébellion vs Violences distinctes",
    question:
        "Si les coups portés ne sont pas distincts de la résistance violente lors de l’interpellation :",
    options: [
      "La qualification de rébellion peut suffire (pas d’actes distincts)",
      "Il y a forcément deux infractions cumulées",
      "Il n’y a aucune infraction",
    ],
    answer:
        "La qualification de rébellion peut suffire (pas d’actes distincts)",
    explanation:
        "Ton doc cite Cass. crim. (21 fév. 2006) : pas d’actes de violences distincts -> rébellion.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Distinctions — Outrage vs Menaces 433-3",
    question:
        "Dire à un policier : 'Je vais brûler ta voiture ce soir' (en raison de ses fonctions) correspond plutôt à :",
    options: [
      "Des menaces de crime/délit envers personne dépositaire (433-3 CP)",
      "Un simple outrage",
      "Une provocation à la rébellion (433-10 CP)",
    ],
    answer: "Des menaces de crime/délit envers personne dépositaire (433-3 CP)",
    explanation:
        "Menace d’atteinte aux biens = 433-3 si victime protégée et qualité connue + lien fonctions.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Distinctions — Menaces vs Outrage",
    question: "L’outrage se distingue d’une menace car la menace contient :",
    options: [
      "L’annonce d’un crime ou d’un délit à venir contre personnes ou biens",
      "Une simple critique générale",
      "Un silence méprisant",
    ],
    answer:
        "L’annonce d’un crime ou d’un délit à venir contre personnes ou biens",
    explanation:
        "Menace = annonce de mal criminel/délictuel, outrage = atteinte au respect/dignité (sans annonce d’infraction).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Distinctions — Provocation à la rébellion vs Outrage",
    question:
        "Crier à une foule : 'Allez-y, tapez les policiers !' correspond plutôt à :",
    options: [
      "Provocation directe à la rébellion (433-10 CP)",
      "Outrage",
      "Refus d’obtempérer",
    ],
    answer: "Provocation directe à la rébellion (433-10 CP)",
    explanation:
        "Incitation directe à opposition violente à l’autorité = 433-10 (infraction formelle).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Distinctions — Provocation vs Complicité",
    question:
        "Si après une provocation, la rébellion est réellement commise, l’auteur de la provocation peut être poursuivi :",
    options: [
      "Comme complice de la rébellion par instruction (121-7 CP)",
      "Uniquement pour outrage",
      "Uniquement pour refus d’obtempérer",
    ],
    answer: "Comme complice de la rébellion par instruction (121-7 CP)",
    explanation:
        "Nota de ton doc 433-10 : si suivie d’effet → complicité possible.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Distinctions — Rébellion en réunion",
    question: "La rébellion est aggravée lorsqu’elle est commise :",
    options: ["En réunion (433-7 al.2 CP)", "En plein jour", "Sans témoin"],
    answer: "En réunion (433-7 al.2 CP)",
    explanation: "Circonstance aggravante prévue à 433-7 al.2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Distinctions — Rébellion armée",
    question: "La rébellion est aggravée lorsque l’auteur est :",
    options: [
      "Porteur d’une arme apparente ou cachée (433-8 CP)",
      "Plus âgé que 40 ans",
      "En état de stress",
    ],
    answer: "Porteur d’une arme apparente ou cachée (433-8 CP)",
    explanation: "Aggravation spécifique prévue à 433-8.",
    difficulty: "Facile",
  ),

  // ---------------------------------------------------------
  // QCM “VRAI/FAUX” — format options (3 choix)
  // ---------------------------------------------------------
  const QuizQuestion(
    category: "Vrai/Faux — Provocation 433-10",
    question:
        "Vrai ou Faux : La provocation directe à la rébellion n’est punissable que si la rébellion a effectivement lieu.",
    options: ["Vrai", "Faux", "Ça dépend de l’uniforme"],
    answer: "Faux",
    explanation:
        "Infraction formelle : punissable même sans résultat (sans être suivie d’effet).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Provocation 433-10",
    question:
        "Vrai ou Faux : La provocation directe à la rébellion doit viser une personne déterminée.",
    options: ["Vrai", "Faux", "Uniquement si c’est écrit"],
    answer: "Faux",
    explanation:
        "Elle peut être diffusée par tracts/écrits/moyens de transmission sans destinataire déterminé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Rébellion",
    question:
        "Vrai ou Faux : Un obstacle passif (se laisser porter, s’agripper sans violence) suffit à caractériser une rébellion.",
    options: ["Vrai", "Faux", "Uniquement si l’agent tombe"],
    answer: "Faux",
    explanation:
        "Ton doc : obstacle passif et simple désobéissance exclus du champ de la rébellion.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Rébellion",
    question:
        "Vrai ou Faux : La rébellion peut être retenue même si l’acte accompli par l’agent était illégal.",
    options: ["Vrai", "Faux", "Uniquement si c’est un OPJ"],
    answer: "Vrai",
    explanation:
        "Cass. crim., 1er septembre 2004 : illégalité supposée sans incidence.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Menaces 433-3",
    question:
        "Vrai ou Faux : Pour être punissable, la menace 433-3 doit être réitérée.",
    options: ["Vrai", "Faux", "Seulement si menace de mort"],
    answer: "Faux",
    explanation: "Punissable même sans réitération ni matérialisation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Menaces 433-3",
    question:
        "Vrai ou Faux : Peu importe que l’auteur ait réellement l’intention ou les moyens d’exécuter la menace.",
    options: ["Vrai", "Faux", "Ça dépend du lieu"],
    answer: "Vrai",
    explanation:
        "Élément moral : conscience du trouble. Intention/moyens d’exécution indifférents.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 433-3-1",
    question:
        "Vrai ou Faux : L’infraction 433-3-1 exige de prouver une intention particulière d’obtenir une dérogation aux règles du service public.",
    options: ["Vrai", "Faux", "Uniquement si violences"],
    answer: "Vrai",
    explanation:
        "Le texte insiste sur l’objectif précis : exemption/application différenciée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Rébellion (aggravations)",
    question:
        "Vrai ou Faux : La rébellion commise en réunion est moins sévèrement punie que la rébellion simple.",
    options: ["Vrai", "Faux", "Uniquement si pas d’arme"],
    answer: "Faux",
    explanation:
        "En réunion = aggravation (3 ans / 45 000 €) > simple (2 ans / 30 000 €).",
    difficulty: "Facile",
  ),

  // ---------------------------------------------------------
  // MINI CAS PRATIQUES — Qualification + article + peine
  // (Chaque cas = QCM)
  // ---------------------------------------------------------
  const QuizQuestion(
    category: "Cas pratique — Interpellation (violence)",
    question:
        "Lors d’une interpellation, un homme se débat violemment, bouscule un policier et tente de s’enfuir. Quelle qualification principale ?",
    options: [
      "Rébellion (433-6 CP), réprimée par 433-7 al.1 — 2 ans et 30 000 €",
      "Outrage — 6 mois et 7 500 €",
      "Refus d’obtempérer — contravention",
    ],
    answer: "Rébellion (433-6 CP), réprimée par 433-7 al.1 — 2 ans et 30 000 €",
    explanation:
        "Résistance active et violente à l’action d’un agent dans l’exercice de ses fonctions = rébellion (simple).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Obstacle passif",
    question:
        "Un homme refuse de descendre de sa voiture et s’agrippe au volant sans donner de coups ni bousculer. Qualification la plus adaptée ?",
    options: [
      "Pas rébellion (obstacle passif) — rechercher autre qualification selon contexte",
      "Rébellion certaine (433-6)",
      "Provocation à la rébellion (433-10)",
    ],
    answer:
        "Pas rébellion (obstacle passif) — rechercher autre qualification selon contexte",
    explanation:
        "Ton cours : simple désobéissance/obstacle passif ≠ rébellion (exemple Cass. crim., 1er mars 2006).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Rébellion en réunion",
    question:
        "Trois individus entourent des policiers pour empêcher une interpellation et se débattent violemment avec eux. Qualification/peine ?",
    options: [
      "Rébellion en réunion — 433-7 al.2 — 3 ans et 45 000 €",
      "Rébellion simple — 433-7 al.1 — 2 ans et 30 000 €",
      "Provocation à la rébellion — 433-10 — 2 mois et 7 500 €",
    ],
    answer: "Rébellion en réunion — 433-7 al.2 — 3 ans et 45 000 €",
    explanation:
        "Réunion = circonstance aggravante spécifique de la rébellion.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Rébellion armée",
    question:
        "Lors d’un contrôle, un individu se débat violemment. Une arme blanche est retrouvée sur lui (cachée). Qualification/peine ?",
    options: [
      "Rébellion avec arme — 433-8 al.1 — 5 ans et 75 000 €",
      "Rébellion simple — 433-7 al.1 — 2 ans et 30 000 €",
      "Menaces 433-3 — 3 ans et 45 000 €",
    ],
    answer: "Rébellion avec arme — 433-8 al.1 — 5 ans et 75 000 €",
    explanation:
        "Port d’une arme, apparente ou cachée, pendant la rébellion = aggravation 433-8.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Arme + réunion",
    question:
        "Deux individus se rebellent violemment contre les policiers. L’un d’eux est porteur d’une arme. Qualification/peine maximale dans ton tableau ?",
    options: [
      "Rébellion armée en réunion — 433-8 al.2 — 10 ans et 150 000 €",
      "Rébellion en réunion — 433-7 al.2 — 3 ans et 45 000 €",
      "Rébellion simple — 433-7 al.1 — 2 ans et 30 000 €",
    ],
    answer: "Rébellion armée en réunion — 433-8 al.2 — 10 ans et 150 000 €",
    explanation:
        "Cumul arme + réunion = niveau d’aggravation supérieur (10 ans / 150k).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Provocation à la rébellion",
    question:
        "Un individu crie sur la voie publique : « Venez, ils ne sont que deux, on va les défoncer ! » pour empêcher son interpellation. Qualification/peine ?",
    options: [
      "Provocation directe à la rébellion — 433-10 — 2 mois et 7 500 €",
      "Rébellion simple — 433-7 al.1 — 2 ans et 30 000 €",
      "Menaces 433-3 — 3 ans et 45 000 €",
    ],
    answer: "Provocation directe à la rébellion — 433-10 — 2 mois et 7 500 €",
    explanation:
        "Incitation directe à opposition violente (infraction formelle) = 433-10.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Menaces envers policier",
    question:
        "En raison d’un contrôle, un homme dit à un policier en uniforme : « Je vais te casser la gueule ce soir ». Qualification/peine (simple) ?",
    options: [
      "Menaces de crime/délit envers dépositaire — 433-3 — 3 ans et 45 000 €",
      "Outrage uniquement",
      "Provocation à la rébellion — 433-10 — 2 mois et 7 500 €",
    ],
    answer:
        "Menaces de crime/délit envers dépositaire — 433-3 — 3 ans et 45 000 €",
    explanation:
        "Annonce d’un délit à venir contre la personne + qualité apparente/connue + lien fonctions = 433-3 (simple).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Menace de mort",
    question:
        "Un individu dit à un enseignant : « Je vais te tuer » pendant qu’il est en fonction. Qualification/peine ?",
    options: [
      "Menaces aggravées — 433-3 al.5 — 5 ans et 75 000 €",
      "Menaces simples — 433-3 — 3 ans et 45 000 €",
      "433-3-1 — 5 ans et 75 000 €",
    ],
    answer: "Menaces aggravées — 433-3 al.5 — 5 ans et 75 000 €",
    explanation: "Menace de mort = aggravation al.5.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Pression pour acte de fonction (al.6)",
    question:
        "Un individu menace un agent public pour qu’il falsifie une décision administrative en sa faveur. Qualification/peine ?",
    options: [
      "Menaces/intimidation pour obtenir acte de fonction/abus d’autorité — 433-3 al.6 — 10 ans et 150 000 €",
      "Menaces simples — 433-3 — 3 ans et 45 000 €",
      "433-3-1 — 5 ans et 75 000 €",
    ],
    answer:
        "Menaces/intimidation pour obtenir acte de fonction/abus d’autorité — 433-3 al.6 — 10 ans et 150 000 €",
    explanation:
        "Al.6 vise la pression pour faire accomplir/s’abstenir un acte de fonction ou abus d’autorité pour décision favorable.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Dérogation service public (433-3-1)",
    question:
        "Un usager menace un agent municipal pour obtenir une exemption aux règles d’accès d’un service public (traitement différencié). Qualification/peine ?",
    options: [
      "433-3-1 — 5 ans et 75 000 €",
      "433-3 al.6 — 10 ans et 150 000 €",
      "Outrage uniquement",
    ],
    answer: "433-3-1 — 5 ans et 75 000 €",
    explanation:
        "But = application dérogatoire des règles du service public → 433-3-1 (intention particulière).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Dérogation (cantine)",
    question:
        "Après plusieurs refus, un parent menace le personnel d’une cantine pour obtenir un régime alimentaire non prévu par le règlement. Qualification/peine ?",
    options: [
      "433-3-1 — 5 ans et 75 000 €",
      "Menaces simples 433-3 — 3 ans et 45 000 €",
      "Provocation 433-10 — 2 mois et 7 500 €",
    ],
    answer: "433-3-1 — 5 ans et 75 000 €",
    explanation:
        "Exemple donné dans ton doc : obtention d’un régime différencié dans cantines scolaires → 433-3-1.",
    difficulty: "Moyenne",
  ),

  // ---------------------------------------------------------
  // SUPER PIÈGES — cas “mixte” et questions à choix proches
  // ---------------------------------------------------------
  const QuizQuestion(
    category: "Piège — Outrage + Rébellion (ordre logique)",
    question:
        "Pendant l’interpellation, un individu insulte l’agent puis se débat violemment pour échapper. La qualification principale liée à l’acte physique est :",
    options: [
      "Rébellion (433-6 / 433-7) ; l’outrage peut exister à côté selon faits distincts",
      "Outrage uniquement",
      "Provocation à la rébellion",
    ],
    answer:
        "Rébellion (433-6 / 433-7) ; l’outrage peut exister à côté selon faits distincts",
    explanation:
        "La résistance violente = rébellion. Les insultes peuvent constituer outrage si distinctes.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — Menace vs Outrage",
    question:
        "Dire à un policier : « T’es nul, t’es un clown » correspond plutôt à :",
    options: [
      "Outrage (atteinte au respect dû à la fonction)",
      "Menaces 433-3",
      "Rébellion",
    ],
    answer: "Outrage (atteinte au respect dû à la fonction)",
    explanation:
        "Pas d’annonce d’un crime/délit futur : c’est insultant/dégradant = outrage (si conditions réunies).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège — Menace de bien",
    question:
        "Dire à un gardien d’immeuble assermenté : « Je vais dégrader ta loge » en raison de sa fonction correspond plutôt à :",
    options: [
      "Menaces 433-3 (contre les biens) — 3 ans et 45 000 € (simple)",
      "Outrage uniquement",
      "433-3-1",
    ],
    answer: "Menaces 433-3 (contre les biens) — 3 ans et 45 000 € (simple)",
    explanation:
        "Menace d’atteinte aux biens + victime protégée (gardien assermenté cité) + lien fonctions → 433-3.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — Provocation vs Rébellion",
    question:
        "Un individu crie à la foule d’empêcher l’interpellation, mais personne ne bouge. Qualification ?",
    options: [
      "Provocation directe à la rébellion (433-10) quand même",
      "Aucune infraction",
      "Rébellion simple",
    ],
    answer: "Provocation directe à la rébellion (433-10) quand même",
    explanation: "Infraction formelle : pas besoin d’effet.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège — Menaces vs 433-3-1",
    question:
        "Un usager menace un agent d’un service public pour obtenir un traitement 'hors règle' (dérogation). Qualification la plus pertinente ?",
    options: [
      "433-3-1 (objectif dérogatoire)",
      "433-3 simple dans tous les cas",
      "Rébellion",
    ],
    answer: "433-3-1 (objectif dérogatoire)",
    explanation:
        "Quand le cœur du dossier = obtenir une exemption/application différenciée des règles → 433-3-1.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Provocation à la rébellion — Définition",
    question: "La provocation directe à la rébellion consiste à :",
    options: [
      "Inciter directement quelqu’un à commettre le délit de rébellion",
      "Critiquer verbalement l’action des forces de l’ordre",
      "Refuser d’obtempérer à une sommation",
    ],
    answer: "Inciter directement quelqu’un à commettre le délit de rébellion",
    explanation:
        "L’article 433-10 CP vise la provocation directe à commettre le délit de rébellion.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Texte",
    question: "La provocation directe à la rébellion est prévue par :",
    options: [
      "Article 433-10 du Code pénal",
      "Article 433-6 du Code pénal",
      "Article 433-3 du Code pénal",
    ],
    answer: "Article 433-10 du Code pénal",
    explanation: "Le délit est défini et réprimé par l’article 433-10 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Caractère direct",
    question: "Pour être punissable, la provocation doit :",
    options: [
      "Tendre sans ambiguïté à une opposition violente à l’action de l’autorité",
      "Exprimer un simple mécontentement",
      "Être suivie d’effet",
    ],
    answer:
        "Tendre sans ambiguïté à une opposition violente à l’action de l’autorité",
    explanation:
        "La provocation doit présenter un lien précis et incontestable avec l’acte de rébellion.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Résultat",
    question: "La provocation directe à la rébellion est constituée :",
    options: [
      "Même si elle n’est pas suivie d’effet",
      "Uniquement si la rébellion a lieu",
      "Uniquement si des violences sont commises",
    ],
    answer: "Même si elle n’est pas suivie d’effet",
    explanation:
        "Il s’agit d’une infraction formelle : le résultat est indifférent.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Moyens",
    question: "La provocation peut être réalisée notamment par :",
    options: [
      "Cris, discours publics, écrits affichés ou distribués",
      "Un simple regard menaçant",
      "Une pensée non exprimée",
    ],
    answer: "Cris, discours publics, écrits affichés ou distribués",
    explanation:
        "L’article 433-10 vise divers moyens de transmission de la parole, de l’écrit ou de l’image.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Presse",
    question:
        "Lorsque la provocation est commise par la presse écrite ou audiovisuelle :",
    options: [
      "La loi du 29 juillet 1881 s’applique",
      "L’article 433-10 est inapplicable",
      "Il n’y a pas d’infraction",
    ],
    answer: "La loi du 29 juillet 1881 s’applique",
    explanation:
        "L’alinéa 2 de l’article 433-10 renvoie aux règles spécifiques de la presse.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Élément moral",
    question: "L’élément moral de la provocation à la rébellion suppose :",
    options: [
      "La volonté d’inciter autrui à commettre un acte de rébellion",
      "Une simple imprudence",
      "Un état d’énervement",
    ],
    answer: "La volonté d’inciter autrui à commettre un acte de rébellion",
    explanation: "Il s’agit d’une infraction intentionnelle.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Peines",
    question:
        "Les peines encourues pour la provocation directe à la rébellion sont :",
    options: [
      "2 mois d’emprisonnement et 7 500 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "2 mois d’emprisonnement et 7 500 € d’amende",
    explanation: "Peines prévues à l’article 433-10 CP.",
    difficulty: "Facile",
  ),

  // =========================================================
  // RÉBELLION — ARTICLES 433-6 À 433-9 CP
  // =========================================================
  const QuizQuestion(
    category: "Rébellion — Définition",
    question: "La rébellion consiste à :",
    options: [
      "Opposer une résistance violente à un agent public agissant dans l’exercice de ses fonctions",
      "Refuser verbalement un ordre",
      "Contester une décision administrative",
    ],
    answer:
        "Opposer une résistance violente à un agent public agissant dans l’exercice de ses fonctions",
    explanation:
        "L’article 433-6 CP définit la rébellion par une résistance violente.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Texte",
    question: "La rébellion est définie par l’article :",
    options: [
      "433-6 du Code pénal",
      "433-10 du Code pénal",
      "432-8 du Code pénal",
    ],
    answer: "433-6 du Code pénal",
    explanation: "L’article 433-6 CP définit la rébellion.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Victime",
    question: "La victime de la rébellion doit être :",
    options: [
      "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
      "Un simple particulier",
      "Un témoin",
    ],
    answer:
        "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
    explanation: "La qualité de la victime est un élément constitutif.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Exercice des fonctions",
    question: "Il y a rébellion uniquement si l’agent agit :",
    options: [
      "Dans l’exercice de ses fonctions",
      "Dans un cadre privé",
      "En dehors de toute mission",
    ],
    answer: "Dans l’exercice de ses fonctions",
    explanation:
        "La résistance doit intervenir pendant l’exercice des fonctions.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Illégalité de l’acte",
    question: "L’illégalité éventuelle de l’acte accompli par l’agent :",
    options: [
      "N’exclut pas la rébellion",
      "Supprime l’infraction",
      "Transforme la rébellion en outrage",
    ],
    answer: "N’exclut pas la rébellion",
    explanation: "La Cour de cassation juge l’illégalité sans incidence.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Résistance",
    question: "La rébellion suppose :",
    options: [
      "Une résistance violente et active",
      "Une simple inertie",
      "Un refus passif",
    ],
    answer: "Une résistance violente et active",
    explanation: "La simple désobéissance ou l’obstacle passif sont exclus.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Élément moral",
    question: "L’élément moral de la rébellion suppose :",
    options: [
      "La connaissance de la qualité de l’agent et la volonté de résister",
      "Une erreur de perception",
      "Un trouble psychologique",
    ],
    answer:
        "La connaissance de la qualité de l’agent et la volonté de résister",
    explanation:
        "L’auteur doit avoir conscience de s’opposer à un agent public.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Réunion",
    question: "La rébellion est aggravée lorsqu’elle est commise :",
    options: ["En réunion", "La nuit", "En état d’ivresse"],
    answer: "En réunion",
    explanation: "Article 433-7 al.2 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Arme",
    question: "La rébellion est aggravée lorsque l’auteur :",
    options: [
      "Est porteur d’une arme, apparente ou cachée",
      "Crie fortement",
      "Fuit les lieux",
    ],
    answer: "Est porteur d’une arme, apparente ou cachée",
    explanation: "Article 433-8 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Peines simples",
    question: "Les peines encourues pour la rébellion simple sont :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "2 mois d’emprisonnement et 7 500 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation: "Peines prévues par l’article 433-7 al.1 CP.",
    difficulty: "Facile",
  ),

  // =========================================================
  // MENACES ENVERS PERSONNE DÉPOSITAIRE / SERVICE PUBLIC — 433-3
  // =========================================================
  const QuizQuestion(
    category: "Menaces — Définition",
    question: "Les menaces réprimées par l’article 433-3 CP consistent à :",
    options: [
      "Menacer de commettre un crime ou un délit contre une personne protégée",
      "Insulter un agent public",
      "Refuser d’obtempérer",
    ],
    answer:
        "Menacer de commettre un crime ou un délit contre une personne protégée",
    explanation: "L’article 433-3 vise les menaces de crime ou de délit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Menaces — Résultat",
    question: "La menace est punissable :",
    options: [
      "Même si elle n’est pas réitérée ou exécutée",
      "Uniquement si elle est suivie d’effet",
      "Uniquement si elle est écrite",
    ],
    answer: "Même si elle n’est pas réitérée ou exécutée",
    explanation: "La matérialisation ou l’exécution est indifférente.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Menaces — Qualité de la victime",
    question:
        "Pour constituer l’infraction, la qualité de la victime doit être :",
    options: [
      "Apparente ou connue de l’auteur",
      "Mentionnée par écrit",
      "Ignorée de l’auteur",
    ],
    answer: "Apparente ou connue de l’auteur",
    explanation:
        "La menace doit être motivée par les fonctions connues de la victime.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces — Élément moral",
    question: "L’auteur des menaces doit avoir :",
    options: [
      "Conscience du trouble causé par ses propos",
      "L’intention de passer à l’acte",
      "Un mobile légitime",
    ],
    answer: "Conscience du trouble causé par ses propos",
    explanation: "L’intention de réaliser la menace est indifférente.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces — Peines simples",
    question: "Les peines encourues pour les menaces simples sont :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Peines prévues par l’article 433-3 CP.",
    difficulty: "Facile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizAtteinteAdministrationPA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName = '/pa/nation/quiz/atteintes_administration';
  final String uid;
  final String email;

  const QuizAtteinteAdministrationPA({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizAtteinteAdministrationPA> createState() => _QuizAtteinteAdministrationPAState();
}

class _QuizAtteinteAdministrationPAState extends State<QuizAtteinteAdministrationPA>
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
  static const _introHiddenKey = 'intro_pa_atteintes_administration';
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
        ? questionAtteinteAdministration
        : questionAtteinteAdministration
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
            'mode': UserContextService.I.modeOrDefault,'module_name': 'Crimes & délits contre la nation',
            'quiz_name':
                'Atteintes à l\'administration publique (particuliers)',
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
      await _sb.from('quiz_atteintes_administration').insert({
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
      debugPrint('❌ quiz_atteintes_administration insert failed: $e');
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
      'source_file': 'pa_quiz_atteintes_administration',
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
                            icon: Icons.domain_rounded,
                            title: 'Atteintes à l’administration',
                            description: 'Identifie les infractions commises contre l’administration : corruption, concussion, prise illégale d’intérêts.',
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
