import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:copiqpolice/ui/app_notifier.dart'
    show AppNotifier, AppSettingsController;

Color _opa(Color c, double a) => c.withValues(alpha: a);

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

class QuizOption {
  final String label; // texte affiché + valeur comparée
  final String? assetImage; // ex: "assets/images/major.png"
  final String? networkImage; // si un jour tu veux du réseau

  const QuizOption({required this.label, this.assetImage, this.networkImage});
}

class QuizQuestion {
  final String category;
  final String question;
  final List<String> options;
  final String answer;
  final String explanation;
  final String difficulty;
  final String? sub;

  // ✅ nouveau
  final String? questionImageAsset; // ex: "assets/images/dgpn.png"

  const QuizQuestion({
    required this.category,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.difficulty,
    this.sub,
    this.questionImageAsset,
  });
}

final List<QuizQuestion> questionDeontologie = [
  QuizQuestion(
    category: "Droits & obligations — Contexte",
    question:
        "Les droits et obligations des policiers sont principalement encadrés par :",
    options: [
      "Le Code général de la fonction publique (CGFP), complété par des textes spécifiques (CSI, RGEPN…)",
      "Uniquement le Code pénal",
      "Uniquement le Code de procédure pénale (CPP)",
    ],
    answer:
        "Le Code général de la fonction publique (CGFP), complété par des textes spécifiques (CSI, RGEPN…)",
    explanation:
        "Le CGFP pose le cadre général, et des textes comme le CSI / RGEPN ajoutent des règles propres à la fonction policière.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Droits & obligations — Références principales",
    question: "Parmi les textes de base, on retrouve :",
    options: [
      "CGFP + CSI + RGEPN",
      "CPP + Code du travail + Code des impôts",
      "Code rural + Code minier + Code de la route",
    ],
    answer: "CGFP + CSI + RGEPN",
    explanation:
        "Références principales : CGFP (fonction publique), CSI (déontologie police), RGEPN (cadre interne).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Droits & obligations — Références principales",
    question:
        "Avant la prise de fonctions, tout agent de la Police nationale :",
    options: [
      "Prête serment de servir avec dignité et loyauté la République, ses principes et sa Constitution",
      "Signe uniquement un contrat de confidentialité",
      "N’a aucune formalité particulière",
    ],
    answer:
        "Prête serment de servir avec dignité et loyauté la République, ses principes et sa Constitution",
    explanation:
        "Dans ton cours : serment = dignité + loyauté envers la République, ses principes et la Constitution.",
    difficulty: "Facile",
  ),

  // =========================================================
  // I — Statut Fonction Publique : Droits
  // =========================================================
  QuizQuestion(
    category: "Statut FP — Droits",
    question: "La liberté d’opinion des agents publics est :",
    options: ["Garantie", "Interdite", "Autorisé uniquement hors service"],
    answer: "Garantie",
    explanation:
        "CGFP : liberté d’opinion garantie aux agents publics (références citées dans ton cours).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Statut FP — Droits",
    question: "Les opinions (politiques, religieuses, syndicales…) :",
    options: [
      "Ne doivent pas figurer dans le dossier individuel",
      "Doivent être mentionnées dans le dossier individuel",
      "Doivent être affichées sur l’uniforme",
    ],
    answer: "Ne doivent pas figurer dans le dossier individuel",
    explanation:
        "Dans ton cours : les opinions ne doivent pas apparaître au dossier individuel.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Statut FP — Droits",
    question: "La liberté d’expression d’un policier :",
    options: [
      "En service : neutralité → liberté d’expression exclue dans l’exercice des fonctions",
      "En service : totale, sans limites",
      "Hors service : interdite",
    ],
    answer:
        "En service : neutralité → liberté d’expression exclue dans l’exercice des fonctions",
    explanation:
        "Dans ton cours : en service, la neutralité prime. Hors service, liberté relative avec réserve.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Statut FP — Droits",
    question: "Hors service, la liberté d’expression est :",
    options: [
      "Relative, limitée par l’obligation de réserve",
      "Totale, sans aucune limite",
      "Interdite pour tous les agents publics",
    ],
    answer: "Relative, limitée par l’obligation de réserve",
    explanation:
        "Ton cours : hors service, liberté relative mais obligation de réserve.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Statut FP — Droits",
    question: "La non-discrimination signifie :",
    options: [
      "Aucune distinction directe ou indirecte (origine, sexe, opinions, santé, handicap, etc.)",
      "Seulement l’interdiction de discriminer sur le sexe",
      "Seulement l’interdiction de discriminer sur l’âge",
    ],
    answer:
        "Aucune distinction directe ou indirecte (origine, sexe, opinions, santé, handicap, etc.)",
    explanation:
        "Ton cours liste une large interdiction (directe/indirecte) sur de nombreux critères.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Statut FP — Droits",
    question: "Concernant les agissements sexistes :",
    options: [
      "Aucun agent ne doit en subir",
      "Ils sont tolérés si ce n’est “pas méchant”",
      "Ils sont autorisés hors service",
    ],
    answer: "Aucun agent ne doit en subir",
    explanation: "Ton cours : aucun agent ne doit subir d’agissement sexiste.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Statut FP — Droits",
    question: "Le droit syndical pour les policiers :",
    options: [
      "Est reconnu, dans un cadre et avec des limites (secret, déontologie, fonctionnement du service)",
      "Est totalement interdit",
      "Permet de divulguer des infos d’enquête sans restriction",
    ],
    answer:
        "Est reconnu, dans un cadre et avec des limites (secret, déontologie, fonctionnement du service)",
    explanation:
        "Ton cours : droit syndical oui, mais secret + déontologie + compatibilité service.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Statut FP — Droits",
    question: "La protection fonctionnelle :",
    options: [
      "Protège l’agent contre attaques/menaces/violences/injures/diffamations/outrages, si pas de faute personnelle",
      "Ne concerne que les officiers",
      "S’applique uniquement en cas d’accident de service",
    ],
    answer:
        "Protège l’agent contre attaques/menaces/violences/injures/diffamations/outrages, si pas de faute personnelle",
    explanation:
        "Ton cours : l’État défend l’agent (et parfois proches) si pas de faute personnelle.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Statut FP — Droits",
    question: "La protection fonctionnelle peut concerner aussi :",
    options: [
      "Conjoint, enfants et ascendants directs",
      "Uniquement les collègues",
      "Uniquement les amis proches",
    ],
    answer: "Conjoint, enfants et ascendants directs",
    explanation:
        "Ton cours : elle peut concerner conjoint, enfants, ascendants directs.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // I — Statut Fonction Publique : Obligations
  // =========================================================
  QuizQuestion(
    category: "Statut FP — Obligations",
    question: "L’obéissance hiérarchique signifie :",
    options: [
      "Se conformer aux instructions du supérieur hiérarchique",
      "Faire uniquement ce qu’on veut tant que c’est utile",
      "Obéir seulement si l’ordre est écrit",
    ],
    answer: "Se conformer aux instructions du supérieur hiérarchique",
    explanation: "Ton cours : principe général d’obéissance hiérarchique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Statut FP — Obligations",
    question: "On peut refuser un ordre si :",
    options: [
      "Il est manifestement illégal et compromet gravement un intérêt public",
      "Il ne plaît pas à l’agent",
      "Il est donné oralement",
    ],
    answer:
        "Il est manifestement illégal et compromet gravement un intérêt public",
    explanation:
        "Ton cours : exception classique = ordre manifestement illégal + intérêt public gravement compromis.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Statut FP — Obligations",
    question: "Le secret professionnel et la discrétion :",
    options: [
      "Exposent à sanctions pénales + disciplinaires en cas de violation",
      "Ne concernent que les enquêtes judiciaires",
      "Ne s’appliquent pas sur les réseaux sociaux",
    ],
    answer: "Exposent à sanctions pénales + disciplinaires en cas de violation",
    explanation:
        "Ton cours : violation = pénal + disciplinaire + responsabilité civile possible.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Statut FP — Obligations",
    question: "Les réseaux sociaux :",
    options: [
      "Doivent rester compatibles avec secret, discrétion et déontologie",
      "Sont libres : on peut publier opérations et modalités d’intervention",
      "Sont interdits pour tous les policiers",
    ],
    answer: "Doivent rester compatibles avec secret, discrétion et déontologie",
    explanation:
        "Ton cours : attention aux infos pro (opérations, modalités, photos, propos portant atteinte…).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Statut FP — Obligations",
    question: "La probité, c’est :",
    options: [
      "Agir avec désintéressement et sans intérêts personnels opposés à l’administration",
      "Chercher d’abord l’intérêt personnel",
      "Utiliser sa qualité pour obtenir un avantage",
    ],
    answer:
        "Agir avec désintéressement et sans intérêts personnels opposés à l’administration",
    explanation:
        "Ton cours : probité = désintéressement + pas d’avantage personnel via sa qualité.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Statut FP — Obligations",
    question: "Parmi les infractions typiques liées à la probité, on trouve :",
    options: [
      "Corruption / trafic d’influence / concussion / prise illégale d’intérêts",
      "Vol simple uniquement",
      "Diffamation uniquement",
    ],
    answer:
        "Corruption / trafic d’influence / concussion / prise illégale d’intérêts",
    explanation: "Ton cours liste ces 4 infractions pénales typiques.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // II — Particularismes policiers
  // =========================================================
  QuizQuestion(
    category: "Particularismes police — Hiérarchie",
    question: "Dans la Police, le principe hiérarchique implique :",
    options: [
      "Instructions + rendre compte de l’exécution (ou raisons de l’inexécution)",
      "Aucune obligation de rendre compte",
      "Obéir uniquement si on est OPJ",
    ],
    answer:
        "Instructions + rendre compte de l’exécution (ou raisons de l’inexécution)",
    explanation:
        "Ton cours : autorité hiérarchique donne des instructions précises et l’agent rend compte.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Particularismes police — Hiérarchie",
    question: "Les policiers adjoints :",
    options: [
      "N’ont pas de principe hiérarchique entre eux (ils sont subordonnés aux personnels sous l’autorité desquels ils sont placés)",
      "Sont hiérarchiquement supérieurs aux GPX",
      "Sont hiérarchiquement supérieurs aux gradés",
    ],
    answer:
        "N’ont pas de principe hiérarchique entre eux (ils sont subordonnés aux personnels sous l’autorité desquels ils sont placés)",
    explanation:
        "Ton cours : pas de hiérarchie entre PA ; subordination aux personnels d’encadrement.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Particularismes police — Réserve",
    question: "Le devoir de réserve chez les policiers est :",
    options: [
      "Plus strict : modération dans l’expression en service et hors service",
      "Moins strict que pour les autres agents publics",
      "Inexistant hors service",
    ],
    answer:
        "Plus strict : modération dans l’expression en service et hors service",
    explanation:
        "Ton cours : plus stricte chez les policiers, manque de retenue = sanction disciplinaire.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Particularismes police — Grève",
    question: "Pour les personnels actifs, la grève est :",
    options: [
      "Interdite (cessation concertée ou acte collectif d’indiscipline = sanction possible)",
      "Toujours autorisée",
      "Autorisé uniquement le week-end",
    ],
    answer:
        "Interdite (cessation concertée ou acte collectif d’indiscipline = sanction possible)",
    explanation:
        "Ton cours : interdiction de faire grève pour les personnels actifs.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Particularismes police — Grève",
    question: "Pour les policiers adjoints, le droit de grève est :",
    options: [
      "Admis",
      "Interdit",
      "Admis uniquement après 10 ans d’ancienneté",
    ],
    answer: "Admis",
    explanation: "Ton cours : policiers adjoints = droit de grève admis.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Particularismes police — Dignité",
    question: "L’obligation de dignité impose :",
    options: [
      "Un comportement exemplaire en toutes circonstances (service / hors service), y compris sur les réseaux sociaux",
      "Uniquement une tenue correcte en service",
      "Uniquement de respecter l’uniforme",
    ],
    answer:
        "Un comportement exemplaire en toutes circonstances (service / hors service), y compris sur les réseaux sociaux",
    explanation:
        "Ton cours : dignité = exemplarité permanente, ne pas nuire à la considération de l’institution.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Particularismes police — Indépendance",
    question: "L’indépendance implique notamment :",
    options: [
      "Interdiction de collecter des fonds/dons en se prévalant de sa qualité, ou via un intermédiaire",
      "Autorisation de collecter des dons en uniforme",
      "Obligation de publier des tracts en commissariat",
    ],
    answer:
        "Interdiction de collecter des fonds/dons en se prévalant de sa qualité, ou via un intermédiaire",
    explanation:
        "Ton cours : interdiction de collecte de fonds/dons via la qualité de policier.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Particularismes police — Discernement",
    question: "Discernement & impartialité :",
    options: [
      "Choisir la meilleure réponse légale selon risques/menaces/délais et agir sans discrimination",
      "Toujours choisir l’option la plus rapide même si illégale",
      "Adapter la réponse selon les opinions personnelles",
    ],
    answer:
        "Choisir la meilleure réponse légale selon risques/menaces/délais et agir sans discrimination",
    explanation:
        "Ton cours : professionnalisme = équité, neutralité, laïcité, sans discrimination.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // Obligations spécifiques (exemples)
  // =========================================================
  QuizQuestion(
    category: "Obligations spécifiques — Conjoint",
    question: "L’activité du conjoint/concubin peut entraîner des mesures si :",
    options: [
      "Elle jette le discrédit sur la fonction policière ou crée une équivoque préjudiciable",
      "Elle rapporte beaucoup d’argent",
      "Elle est exercée à domicile",
    ],
    answer:
        "Elle jette le discrédit sur la fonction policière ou crée une équivoque préjudiciable",
    explanation:
        "Ton cours : l’autorité peut agir pour sauvegarder l’intérêt du service.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Obligations spécifiques — Résidence",
    question: "L’obligation de résidence signifie :",
    options: [
      "Résider au lieu d’affectation ou à distance permettant un rappel inopiné rapidement",
      "Résider uniquement dans son département d’origine",
      "Résider uniquement à moins de 1 km du service",
    ],
    answer:
        "Résider au lieu d’affectation ou à distance permettant un rappel inopiné rapidement",
    explanation:
        "Ton cours : distance compatible avec rappel inopiné “dans les délais les plus brefs”.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Obligations spécifiques — Hors service",
    question: "L’obligation d’agir même hors service implique :",
    options: [
      "Intervenir de sa propre initiative ou sur réquisition (personne en danger, troubles à l’ordre public, protection personnes/biens)",
      "Ne jamais intervenir hors service",
      "Intervenir uniquement si on est en uniforme",
    ],
    answer:
        "Intervenir de sa propre initiative ou sur réquisition (personne en danger, troubles à l’ordre public, protection personnes/biens)",
    explanation:
        "Ton cours : obligation d’agir même hors service (au-delà de l’assistance à personne en péril).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Obligations spécifiques — Hors service",
    question: "Les textes imposent-ils “l’héroïsme à tout prix” ?",
    options: [
      "Non : marge d’appréciation (moyens, moment d’intervention…)",
      "Oui : obligation de se mettre en danger systématiquement",
      "Oui : obligation d’intervenir uniquement seul",
    ],
    answer: "Non : marge d’appréciation (moyens, moment d’intervention…)",
    explanation:
        "Ton cours : pas d’héroïsme à tout prix, l’agent conserve une marge d’appréciation.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // III — Cumul d’activité
  // =========================================================
  QuizQuestion(
    category: "Cumul d’activité — Principe",
    question: "Principe général (décret 2020-69) :",
    options: [
      "L’agent public consacre l’intégralité de son activité professionnelle aux tâches confiées",
      "L’agent public travaille d’abord sur ses activités privées",
      "L’agent public peut cumuler librement sans formalité",
    ],
    answer:
        "L’agent public consacre l’intégralité de son activité professionnelle aux tâches confiées",
    explanation: "Ton cours : principe du décret 2020-69 (30/01/2020).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Cumul d’activité — Interdictions",
    question: "Est strictement interdit (exemple) :",
    options: [
      "Participer à la direction de sociétés/associations à but lucratif",
      "Activité bénévole sans but lucratif",
      "Production d’œuvres de l’esprit (si compatible)",
    ],
    answer: "Participer à la direction de sociétés/associations à but lucratif",
    explanation:
        "Ton cours : participation à direction à but lucratif = interdit.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Cumul d’activité — Autorisées",
    question: "Est librement autorisé (si compatible déontologie) :",
    options: [
      "Activité bénévole sans but lucratif",
      "Plaider contre une personne publique",
      "Diriger une société commerciale en lien avec l’administration",
    ],
    answer: "Activité bénévole sans but lucratif",
    explanation: "Ton cours : bénévolat sans but lucratif = autorisé.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Cumul d’activité — Sur autorisation",
    question: "Relève d’une autorisation (exemple) :",
    options: [
      "Activités accessoires (enseignement, expertise, sport/culture, services à la personne, etc.)",
      "Gestion du patrimoine personnel/familial",
      "Aucune activité n’est soumise à autorisation",
    ],
    answer:
        "Activités accessoires (enseignement, expertise, sport/culture, services à la personne, etc.)",
    explanation:
        "Ton cours : activités accessoires possibles mais soumises à autorisation.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Cumul d’activité — Formalisme",
    question: "La demande de cumul doit être :",
    options: [
      "Écrite à l’autorité hiérarchique (avec accusé de réception)",
      "Uniquement orale",
      "Envoyée directement au procureur",
    ],
    answer: "Écrite à l’autorité hiérarchique (avec accusé de réception)",
    explanation:
        "Ton cours : demande écrite + AR, et tout changement substantiel = nouvelle demande.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Sanctions & récompenses — Idée essentielle",
    question:
        "Une faute commise dans l’exercice ou à l’occasion de l’exercice des fonctions :",
    options: [
      "Peut entraîner une sanction disciplinaire",
      "Ne peut jamais être sanctionnée",
      "Entraîne uniquement une sanction pénale",
    ],
    answer: "Peut entraîner une sanction disciplinaire",
    explanation:
        "Ton cours : régime disciplinaire = toute faute liée aux fonctions peut être sanctionnée.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Sanctions & récompenses — Idée essentielle",
    question:
        "Un comportement exceptionnel (courage, abnégation, initiative…) peut :",
    options: [
      "Ouvrir droit à une récompense",
      "Être ignoré systématiquement",
      "Donner une sanction automatique",
    ],
    answer: "Ouvrir droit à une récompense",
    explanation:
        "Ton cours : actions exceptionnelles = rapport + proposition possible de récompense.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Sanctions & récompenses — Références",
    question: "Le contrôle externe sur la qualité OPJ/APJ relève notamment :",
    options: [
      "Des articles 224 à 230 du CPP",
      "Du Code du travail",
      "Du Code rural",
    ],
    answer: "Des articles 224 à 230 du CPP",
    explanation:
        "Ton cours : contrôle externe (qualité OPJ/APJ) = CPP art. 224 à 230.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Sanctions & récompenses — Références",
    question: "Le contrôle par le Défenseur des droits est cité via :",
    options: [
      "CSI (art. R. 434-24)",
      "CGFP (art. L. 111-1)",
      "Code pénal (art. 223-6)",
    ],
    answer: "CSI (art. R. 434-24)",
    explanation: "Ton cours : contrôle Défenseur des droits = CSI R. 434-24.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // I — Contrôle
  // =========================================================
  QuizQuestion(
    category: "Contrôle de la PN",
    question: "Le contrôle interne de la Police nationale s’exerce notamment :",
    options: [
      "Par la chaîne hiérarchique et les services d’inspection",
      "Uniquement par le procureur",
      "Uniquement par le Défenseur des droits",
    ],
    answer: "Par la chaîne hiérarchique et les services d’inspection",
    explanation: "Ton cours : contrôle interne = hiérarchie + inspections PN.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Contrôle de la PN",
    question: "Le contrôle externe peut être assuré :",
    options: [
      "Par des autorités judiciaires et des organismes (ex. Défenseur des droits)",
      "Uniquement par les collègues du même service",
      "Uniquement par le chef de service",
    ],
    answer:
        "Par des autorités judiciaires et des organismes (ex. Défenseur des droits)",
    explanation:
        "Ton cours : contrôle externe = judiciaire + autorités/organismes.",
    difficulty: "Facile",
  ),

  // =========================================================
  // II — Policiers actifs : sanctions (4 groupes)
  // =========================================================
  QuizQuestion(
    category: "Policiers actifs — Sanctions",
    question:
        "Les sanctions disciplinaires des policiers actifs sont réparties :",
    options: [
      "En 4 groupes, par gravité croissante",
      "En 2 groupes uniquement",
      "En 6 groupes uniquement",
    ],
    answer: "En 4 groupes, par gravité croissante",
    explanation: "Ton cours : 4 groupes, du moins grave au plus grave.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Policiers actifs — 1er groupe",
    question: "Le 1er groupe comprend notamment :",
    options: [
      "Avertissement / Blâme / Exclusion temporaire (max 3 jours)",
      "Rétrogradation / Révocation",
      "Déplacement d’office / Mise à la retraite",
    ],
    answer: "Avertissement / Blâme / Exclusion temporaire (max 3 jours)",
    explanation:
        "Ton cours : 1er groupe = avertissement, blâme, exclusion temporaire max 3 jours.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Policiers actifs — 1er groupe",
    question: "L’avertissement :",
    options: [
      "N’est pas inscrit au dossier, mais porté sur un registre spécial",
      "Est inscrit au dossier pendant 10 ans",
      "Est automatiquement une révocation",
    ],
    answer: "N’est pas inscrit au dossier, mais porté sur un registre spécial",
    explanation:
        "Ton cours : avertissement = registre spécial, pas au dossier.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Policiers actifs — 1er groupe",
    question: "Le blâme :",
    options: [
      "Est inscrit au dossier et effacé au bout de 3 ans si aucune autre sanction n’intervient",
      "N’est jamais inscrit au dossier",
      "Est effacé au bout de 30 jours automatiquement",
    ],
    answer:
        "Est inscrit au dossier et effacé au bout de 3 ans si aucune autre sanction n’intervient",
    explanation:
        "Ton cours : blâme = dossier, effacement auto 3 ans si rien d’autre.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Policiers actifs — 2ème groupe",
    question: "Le 2ème groupe peut inclure :",
    options: [
      "Déplacement d’office / Abaissement d’échelon / Exclusion (4 à 15 jours)",
      "Révocation / Mise à la retraite d’office",
      "Avertissement uniquement",
    ],
    answer:
        "Déplacement d’office / Abaissement d’échelon / Exclusion (4 à 15 jours)",
    explanation:
        "Ton cours : 2e groupe = radiation tableau avancement, abaissement, exclusion 4-15j, déplacement d’office.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Policiers actifs — 2ème groupe",
    question: "L’exclusion temporaire (4 à 15 jours) :",
    options: [
      "Est privative de rémunération et possible avec sursis total ou partiel",
      "N’a jamais d’impact sur la rémunération",
      "Est toujours de 1 mois minimum",
    ],
    answer:
        "Est privative de rémunération et possible avec sursis total ou partiel",
    explanation:
        "Ton cours : 4 à 15 jours, privative de rémunération, sursis possible.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Policiers actifs — 3ème groupe",
    question: "Le 3ème groupe comprend notamment :",
    options: [
      "Rétrogradation / Exclusion temporaire (16 jours à 2 ans)",
      "Avertissement / Blâme",
      "Révocation uniquement",
    ],
    answer: "Rétrogradation / Exclusion temporaire (16 jours à 2 ans)",
    explanation:
        "Ton cours : 3e groupe = rétrogradation + exclusion 16 jours à 2 ans (sursis possible).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Policiers actifs — 4ème groupe",
    question: "Le 4ème groupe correspond aux sanctions les plus graves :",
    options: [
      "Mise à la retraite d’office / Révocation",
      "Blâme / Avertissement",
      "Déplacement d’office / Abaissement d’échelon",
    ],
    answer: "Mise à la retraite d’office / Révocation",
    explanation:
        "Ton cours : 4e groupe = mise à la retraite d’office + révocation.",
    difficulty: "Facile",
  ),

  // =========================================================
  // Procédure / Effacement / Suspension
  // =========================================================
  QuizQuestion(
    category: "Procédure disciplinaire — Conseil",
    question: "Les sanctions du 1er groupe :",
    options: [
      "Peuvent être prononcées sans consultation du conseil de discipline",
      "Nécessitent toujours un conseil de discipline",
      "Sont décidées uniquement par le procureur",
    ],
    answer:
        "Peuvent être prononcées sans consultation du conseil de discipline",
    explanation:
        "Ton cours : 1er groupe possible sans consultation du conseil.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Procédure disciplinaire — Cumul",
    question: "Les sanctions disciplinaires :",
    options: [
      "Peuvent s’appliquer sans préjudice des peines pénales",
      "Remplacent toujours les peines pénales",
      "Sont impossibles si une enquête pénale existe",
    ],
    answer: "Peuvent s’appliquer sans préjudice des peines pénales",
    explanation: "Ton cours : disciplinaire et pénal peuvent coexister.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Procédure disciplinaire — Effacement",
    question: "Blâme et exclusion (max 3 jours) :",
    options: [
      "Effacement automatique au bout de 3 ans si aucune autre sanction n’intervient",
      "Effacement au bout de 10 ans",
      "Jamais effacés",
    ],
    answer:
        "Effacement automatique au bout de 3 ans si aucune autre sanction n’intervient",
    explanation:
        "Ton cours : effacement automatique au bout de 3 ans si pas de nouvelle sanction.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Procédure disciplinaire — Effacement",
    question: "Sanctions des 2ème ou 3ème groupes :",
    options: [
      "Possibilité de demander suppression des mentions après 10 ans de services effectifs à compter de la sanction",
      "Suppression automatique après 1 an",
      "Suppression impossible",
    ],
    answer:
        "Possibilité de demander suppression des mentions après 10 ans de services effectifs à compter de la sanction",
    explanation:
        "Ton cours : demande possible après 10 ans de services effectifs à compter de la sanction.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Procédure disciplinaire — Suspension",
    question: "La suspension est :",
    options: [
      "Une mesure administrative provisoire (pas une sanction)",
      "Une sanction du 4ème groupe",
      "Une récompense",
    ],
    answer: "Une mesure administrative provisoire (pas une sanction)",
    explanation:
        "Ton cours : suspension = mesure conservatoire/provisoire, pas une sanction.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Procédure disciplinaire — Suspension",
    question: "Pendant la suspension (dans ton cours) :",
    options: [
      "Le fonctionnaire conserve pendant 4 mois son traitement + indemnités/prestations associées",
      "Le traitement est supprimé immédiatement",
      "Le traitement est doublé",
    ],
    answer:
        "Le fonctionnaire conserve pendant 4 mois son traitement + indemnités/prestations associées",
    explanation:
        "Ton cours : maintien 4 mois du traitement + indemnités/prestations.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // Récompenses (actifs)
  // =========================================================
  QuizQuestion(
    category: "Récompenses — Policiers actifs",
    question: "Une action exceptionnelle doit faire l’objet :",
    options: [
      "D’un rapport circonstancié du supérieur hiérarchique (avec proposition éventuelle)",
      "D’un post sur les réseaux sociaux",
      "D’une demande orale sans trace",
    ],
    answer:
        "D’un rapport circonstancié du supérieur hiérarchique (avec proposition éventuelle)",
    explanation:
        "Ton cours : rapport circonstancié + proposition possible de récompense.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Récompenses — Policiers actifs",
    question: "Parmi les récompenses possibles, on retrouve :",
    options: [
      "Lettre de félicitations / Gratification / Prime / Décoration / Avancement exceptionnel",
      "Uniquement une augmentation automatique",
      "Uniquement une médaille",
    ],
    answer:
        "Lettre de félicitations / Gratification / Prime / Décoration / Avancement exceptionnel",
    explanation: "Ton cours liste ces exemples de récompenses.",
    difficulty: "Facile",
  ),

  // =========================================================
  // III — Policiers adjoints
  // =========================================================
  QuizQuestion(
    category: "Policiers adjoints — Discipline",
    question:
        "Les sanctions disciplinaires des policiers adjoints sont prises par :",
    options: [
      "Le préfet du département d’affectation",
      "Le maire",
      "Le procureur de la République",
    ],
    answer: "Le préfet du département d’affectation",
    explanation:
        "Ton cours : PA → sanctions prises par le préfet du département d’affectation.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Policiers adjoints — Sanctions",
    question: "Par ordre croissant, les sanctions PA incluent notamment :",
    options: [
      "Avertissement → Blâme → Exclusion (max 3 jours) → Exclusion (4 jours à 6 mois) → Licenciement",
      "Blâme → Révocation → Mise à la retraite",
      "Avertissement uniquement",
    ],
    answer:
        "Avertissement → Blâme → Exclusion (max 3 jours) → Exclusion (4 jours à 6 mois) → Licenciement",
    explanation:
        "Ton cours : liste complète des sanctions PA, avec licenciement en dernier.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Policiers adjoints — Suspension",
    question:
        "Pour un policier adjoint, une suspension conservatoire peut être décidée :",
    options: [
      "Par arrêté du préfet, dans l’intérêt du service",
      "Uniquement par un juge",
      "Uniquement par le conseil de discipline",
    ],
    answer: "Par arrêté du préfet, dans l’intérêt du service",
    explanation:
        "Ton cours : suspension conservatoire PA = arrêté préfectoral.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Policiers adjoints — Récompenses",
    question: "Les récompenses citées pour les policiers adjoints sont :",
    options: [
      "Lettre de félicitations / Prime pour résultats exceptionnels",
      "Décoration obligatoire / Avancement automatique",
      "Aucune récompense possible",
    ],
    answer: "Lettre de félicitations / Prime pour résultats exceptionnels",
    explanation:
        "Ton cours : PA → lettre de félicitations + prime résultats exceptionnels.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Organisation — Police nationale",
    question:
        "La Police nationale est placée sous l’autorité de quel ministère ?",
    options: [
      "Ministère de l’Intérieur",
      "Ministère des Armées",
      "Ministère de la Justice",
    ],
    answer: "Ministère de l’Intérieur",
    explanation:
        "Organisation générale : la Police nationale relève du ministère de l’Intérieur (sécurité intérieure).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Organisation — Police nationale",
    question: "Au niveau central, la Police nationale est pilotée par :",
    options: ["La DGPN", "La Préfecture de police", "La Cour de cassation"],
    answer: "La DGPN",
    explanation:
        "La direction générale de la Police nationale (DGPN) assure le pilotage central.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Organisation — Police nationale",
    question: "Que signifie « DNPJ » ?",
    options: [
      "Direction nationale de la police judiciaire",
      "Direction nationale de la police de proximité",
      "Direction nationale de la protection judiciaire",
    ],
    answer: "Direction nationale de la police judiciaire",
    explanation:
        "DNPJ = direction nationale de la police judiciaire (filière PJ).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Organisation — Police nationale",
    question:
        "Quelle direction nationale pilote la Police aux frontières (PAF) ?",
    options: ["DNPAF", "DNCRS", "DNPJ"],
    answer: "DNPAF",
    explanation: "La filière Police aux frontières est portée par la DNPAF.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Organisation — Police nationale",
    question: "Quelle direction nationale pilote les CRS ?",
    options: ["DNCRS", "DNPAF", "DNPJ"],
    answer: "DNCRS",
    explanation:
        "Les compagnies républicaines de sécurité dépendent de la DNCRS.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Organisation — Territoire",
    question:
        "Quel échelon couvre plusieurs départements dans l’organisation territoriale ?",
    options: ["La zone", "La commune", "Le canton"],
    answer: "La zone",
    explanation:
        "L’échelon zonal regroupe plusieurs départements pour coordonner l’action.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Organisation — Territoire",
    question: "Le commissariat est avant tout :",
    options: [
      "Un service de police chargé de missions sur un secteur (accueil, interventions, enquêtes)",
      "Un établissement pénitentiaire",
      "Un organe juridictionnel",
    ],
    answer:
        "Un service de police chargé de missions sur un secteur (accueil, interventions, enquêtes)",
    explanation: "Le commissariat est une structure de police au niveau local.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Organisation — Chaîne hiérarchique",
    question: "En règle générale, les ordres et instructions circulent :",
    options: [
      "Par la voie hiérarchique",
      "Uniquement par SMS",
      "Uniquement par la presse",
    ],
    answer: "Par la voie hiérarchique",
    explanation:
        "Le principe est la voie hiérarchique (avec possible transmission directe en urgence, puis information).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Organisation — Contrôles",
    question:
        "En matière judiciaire, l’action de la police est contrôlée par :",
    options: ["L’autorité judiciaire", "Le maire", "La Cour des comptes"],
    answer: "L’autorité judiciaire",
    explanation:
        "En police judiciaire, l’action est placée sous le contrôle de l’autorité judiciaire (CPP).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Organisation — Contrôles",
    question: "Le Défenseur des droits est :",
    options: [
      "Une autorité constitutionnelle indépendante",
      "Une juridiction pénale",
      "Un service de renseignement",
    ],
    answer: "Une autorité constitutionnelle indépendante",
    explanation:
        "Il peut être saisi par les citoyens et contrôler l’action des forces de sécurité.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Organisation — Contrôles",
    question: "L’IGPN est principalement associée à :",
    options: [
      "Le contrôle interne (inspection) de la Police nationale",
      "La gestion des prisons",
      "La délivrance des passeports",
    ],
    answer: "Le contrôle interne (inspection) de la Police nationale",
    explanation:
        "L’IGPN participe au contrôle interne (enquêtes administratives et/ou judiciaires selon cadre).",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Organisation — Filières",
    question: "La « police judiciaire » a pour objectif principal :",
    options: [
      "Constater les infractions, rassembler les preuves, rechercher les auteurs",
      "Délivrer des titres de séjour",
      "Gérer l’état civil",
    ],
    answer:
        "Constater les infractions, rassembler les preuves, rechercher les auteurs",
    explanation:
        "La PJ est centrée sur l’enquête judiciaire (infractions, preuves, auteurs, procédures).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Organisation — Filières",
    question: "La Police aux frontières (PAF) intervient prioritairement sur :",
    options: [
      "Le contrôle des flux transfrontaliers et missions liées aux frontières",
      "La collecte des impôts",
      "La gestion des écoles",
    ],
    answer:
        "Le contrôle des flux transfrontaliers et missions liées aux frontières",
    explanation:
        "PAF : frontières, flux (aéroports/ports/gares internationales) et missions associées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Organisation — Filières",
    question: "Les CRS sont classiquement mobilisées pour :",
    options: [
      "Le maintien / rétablissement de l’ordre et l’appui opérationnel",
      "La diplomatie",
      "La politique étrangère",
    ],
    answer: "Le maintien / rétablissement de l’ordre et l’appui opérationnel",
    explanation:
        "Les CRS sont une force spécialisée souvent engagée en maintien de l’ordre et renfort.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Organisation — Filières",
    question: "Dans l’organisation, une « filière » correspond à :",
    options: [
      "Un domaine de missions avec sa chaîne de pilotage et ses unités",
      "Un grade",
      "Un tribunal",
    ],
    answer: "Un domaine de missions avec sa chaîne de pilotage et ses unités",
    explanation:
        "Ex : PJ, PAF, CRS : chaque filière regroupe des services spécialisés organisés et pilotés.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Organisation — Chaîne hiérarchique",
    question: "La responsabilité des ordres donnés appartient :",
    options: [
      "À l’autorité qui donne l’ordre",
      "Uniquement à l’exécutant",
      "Toujours au procureur",
    ],
    answer: "À l’autorité qui donne l’ordre",
    explanation:
        "Dans le principe hiérarchique, l’autorité hiérarchique assume la responsabilité des ordres donnés.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Organisation — Chaîne hiérarchique",
    question:
        "Un ordre est dit « manifestement illégal » et doit être refusé s’il est :",
    options: [
      "Manifestement illégal et compromet gravement un intérêt public",
      "Simplement contraire à une opinion personnelle",
      "Difficile à exécuter",
    ],
    answer: "Manifestement illégal et compromet gravement un intérêt public",
    explanation:
        "Le refus n’est possible que dans ce cas précis : illégalité manifeste + gravité pour l’intérêt public.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Organisation — Territoire",
    question: "À quoi sert surtout l’échelon zonal ?",
    options: [
      "Coordonner l’action et les moyens à une échelle supra-départementale",
      "Remplacer le ministère",
      "Rendre des jugements",
    ],
    answer:
        "Coordonner l’action et les moyens à une échelle supra-départementale",
    explanation:
        "La zone sert de niveau de coordination au-dessus du département (organisation, moyens, appui).",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Organisation — Contrôles",
    question:
        "Quel énoncé est le plus juste concernant les contrôles sur la police ?",
    options: [
      "Il existe des contrôles internes et externes (dont judiciaire et Défenseur des droits)",
      "La police n’est contrôlée que par elle-même",
      "La police est contrôlée uniquement par les médias",
    ],
    answer:
        "Il existe des contrôles internes et externes (dont judiciaire et Défenseur des droits)",
    explanation:
        "Contrôles multiples : inspections internes, contrôle judiciaire, et autorités indépendantes.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Organisation — Niveau central",
    question: "Le pilotage au niveau central sert surtout à :",
    options: [
      "Fixer les priorités, organiser les moyens et harmoniser les pratiques",
      "Remplacer toutes les unités locales",
      "Gérer uniquement les contraventions",
    ],
    answer:
        "Fixer les priorités, organiser les moyens et harmoniser les pratiques",
    explanation:
        "Le central définit la stratégie/doctrine et assure la cohérence nationale.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question:
        "Pourquoi l’usage des réseaux sociaux est-il sensible pour un policier ?",
    options: [
      "Parce qu’une publication peut révéler des informations personnelles ou professionnelles",
      "Parce que les réseaux sociaux sont interdits aux policiers",
      "Parce que seules les publications publiques sont contrôlées",
    ],
    answer:
        "Parce qu’une publication peut révéler des informations personnelles ou professionnelles",
    explanation:
        "Une publication anodine peut révéler identité, habitudes, missions ou affectation et mettre en danger l’agent et ses proches.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question:
        "Même sous pseudonyme, un policier est-il responsable de ses publications ?",
    options: [
      "Oui, totalement",
      "Seulement si son identité est connue",
      "Non, le pseudonyme protège juridiquement",
    ],
    answer: "Oui, totalement",
    explanation:
        "Même sous pseudonyme, les publications peuvent engager la responsabilité disciplinaire et pénale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question: "Quel article impose le secret et la discrétion professionnels ?",
    options: [
      "Article 26 de la loi du 13 juillet 1983",
      "Article 15-3 du code de procédure pénale",
      "Article 225-1 du code pénal",
    ],
    answer: "Article 26 de la loi du 13 juillet 1983",
    explanation:
        "L’article 26 impose le secret professionnel et la discrétion pour les faits et informations connus dans l’exercice des fonctions.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question: "Quel est un risque institutionnel lié aux réseaux sociaux ?",
    options: [
      "Atteinte à la neutralité et à l’image de l’institution",
      "Perte automatique du statut de fonctionnaire",
      "Suppression du compte personnel",
    ],
    answer: "Atteinte à la neutralité et à l’image de l’institution",
    explanation:
        "En se revendiquant policier, l’agent engage l’image de l’institution et doit respecter neutralité et réserve.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question: "Le droit à l’oubli existe-t-il réellement sur internet ?",
    options: [
      "Non, une diffusion est difficile à supprimer",
      "Oui, après 24 heures",
      "Oui, sur demande à la plateforme",
    ],
    answer: "Non, une diffusion est difficile à supprimer",
    explanation:
        "Une publication peut être capturée, partagée et causer des préjudices irréversibles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question:
        "Quelle bonne pratique est recommandée pour un policier sur les réseaux ?",
    options: [
      "Désactiver la géolocalisation",
      "Publier uniquement en uniforme",
      "Mentionner son service pour crédibilité",
    ],
    answer: "Désactiver la géolocalisation",
    explanation:
        "La géolocalisation peut révéler des habitudes et exposer l’agent et ses proches.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question:
        "Un policier peut-il évoquer une mission achevée sur les réseaux sociaux ?",
    options: [
      "Non, le secret professionnel s’applique",
      "Oui, si la mission est terminée",
      "Oui, sans citer de noms",
    ],
    answer: "Non, le secret professionnel s’applique",
    explanation:
        "Le secret professionnel couvre les missions en cours comme achevées.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Marques de respect",
    question: "Le salut en uniforme est avant tout :",
    options: [
      "Une marque de respect et de courtoisie",
      "Un geste facultatif",
      "Un salut militaire identique à l’armée",
    ],
    answer: "Une marque de respect et de courtoisie",
    explanation:
        "Le salut exprime respect envers la hiérarchie et courtoisie envers le public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Marques de respect",
    question: "À qui le salut est-il dû en uniforme ?",
    options: [
      "Aux supérieurs, au drapeau et aux autorités",
      "Uniquement aux policiers gradés",
      "Seulement en cas de cérémonie",
    ],
    answer: "Aux supérieurs, au drapeau et aux autorités",
    explanation:
        "Le salut est dû aux supérieurs, au drapeau, aux autorités civiles et militaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Marques de respect",
    question:
        "Lors d’une présentation dans un bureau, que fait le policier en premier ?",
    options: [
      "Se mettre au garde-à-vous et saluer",
      "S’asseoir directement",
      "Commencer à parler sans saluer",
    ],
    answer: "Se mettre au garde-à-vous et saluer",
    explanation: "La présentation commence par la posture et le salut.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Marques de respect",
    question: "Quelle formule est adaptée à un commissaire ?",
    options: ["Mes respects", "À vos ordres", "Salut chef"],
    answer: "Mes respects",
    explanation:
        "Les commissaires et directeurs sont salués par la formule « Mes respects ».",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Code de déontologie",
    question:
        "Sous quelle autorité agissent la police et la gendarmerie pour la sécurité intérieure ?",
    options: [
      "Le ministre de l’Intérieur",
      "Le ministre de la Justice",
      "Le Président de la République uniquement",
    ],
    answer: "Le ministre de l’Intérieur",
    explanation:
        "Les forces de sécurité intérieure sont placées sous l’autorité du ministre de l’Intérieur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Code de déontologie",
    question: "Les règles déontologiques s’appliquent-elles hors service ?",
    options: [
      "Oui, pendant et hors service",
      "Non, uniquement en service",
      "Seulement en uniforme",
    ],
    answer: "Oui, pendant et hors service",
    explanation:
        "Les obligations déontologiques s’appliquent aussi en dehors du service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question:
        "Un policier doit-il rendre compte d’un fait privé pouvant entraîner des poursuites ?",
    options: [
      "Oui, sans délai",
      "Non, c’est privé",
      "Seulement en cas de condamnation",
    ],
    answer: "Oui, sans délai",
    explanation:
        "Tout fait susceptible d’entraîner des poursuites doit être porté à la hiérarchie.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question: "Un policier peut-il refuser un ordre manifestement illégal ?",
    options: [
      "Oui, s’il compromet gravement un intérêt public",
      "Non, jamais",
      "Uniquement par écrit",
    ],
    answer: "Oui, s’il compromet gravement un intérêt public",
    explanation:
        "Un ordre manifestement illégal doit être signalé et peut être refusé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Secret professionnel",
    question:
        "Divulguer une information d’enquête sur les réseaux sociaux est :",
    options: [
      "Une faute disciplinaire grave",
      "Autorisé sans citer de noms",
      "Toléré hors service",
    ],
    answer: "Une faute disciplinaire grave",
    explanation:
        "Le secret de l’enquête et de l’instruction s’impose en toute circonstance.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Probité",
    question: "Un policier peut-il accepter un cadeau lié à ses fonctions ?",
    options: [
      "Non, en aucun cas",
      "Oui, s’il est de faible valeur",
      "Oui, avec l’accord du citoyen",
    ],
    answer: "Non, en aucun cas",
    explanation: "La probité interdit tout avantage lié à la fonction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Impartialité",
    question: "Le policier doit traiter les personnes :",
    options: [
      "Avec la même attention et sans discrimination",
      "Selon leur réputation",
      "Selon leur comportement passé",
    ],
    answer: "Avec la même attention et sans discrimination",
    explanation:
        "L’impartialité est une valeur fondamentale du service public.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "La déontologie policière correspond à :",
    options: [
      "L’ensemble des règles morales et professionnelles encadrant la fonction",
      "Un simple code de bonne conduite facultatif",
      "Des recommandations sans valeur juridique",
    ],
    answer:
        "L’ensemble des règles morales et professionnelles encadrant la fonction",
    explanation:
        "La déontologie fixe les devoirs, obligations et valeurs du policier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Les règles déontologiques s’appliquent :",
    options: [
      "En service et hors service",
      "Uniquement en service",
      "Seulement en uniforme",
    ],
    answer: "En service et hors service",
    explanation:
        "Le policier reste soumis à ses obligations déontologiques en permanence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le respect de la déontologie conditionne principalement :",
    options: [
      "La légitimité de l’action policière",
      "La rapidité des interventions",
      "Le nombre d’interpellations",
    ],
    answer: "La légitimité de l’action policière",
    explanation:
        "Le respect des valeurs renforce la confiance de la population.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "La déontologie vise à protéger :",
    options: [
      "Le citoyen et le policier",
      "Uniquement l’institution",
      "Uniquement le policier",
    ],
    answer: "Le citoyen et le policier",
    explanation: "Elle encadre l’action policière tout en protégeant l’agent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Un manquement déontologique peut entraîner :",
    options: [
      "Une sanction disciplinaire et/ou pénale",
      "Uniquement un rappel oral",
      "Aucune conséquence",
    ],
    answer: "Une sanction disciplinaire et/ou pénale",
    explanation:
        "Les manquements peuvent engager la responsabilité de l’agent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier est avant tout :",
    options: [
      "Au service de la population",
      "Au service de ses opinions",
      "Au service de son unité uniquement",
    ],
    answer: "Au service de la population",
    explanation:
        "La mission première est la protection des personnes et des biens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "La neutralité impose au policier :",
    options: [
      "De ne pas afficher ses convictions en service",
      "De ne jamais avoir d’opinion personnelle",
      "De soutenir publiquement l’institution",
    ],
    answer: "De ne pas afficher ses convictions en service",
    explanation:
        "Le policier doit rester neutre dans l’exercice de ses fonctions.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "La dignité du policier doit être respectée :",
    options: [
      "En toute circonstance",
      "Uniquement en service",
      "Seulement en uniforme",
    ],
    answer: "En toute circonstance",
    explanation: "La dignité est une exigence permanente.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "La déontologie policière repose principalement sur :",
    options: [
      "La loi, les règlements et des valeurs éthiques",
      "Les usages propres à chaque service",
      "Les consignes orales de la hiérarchie uniquement",
    ],
    answer: "La loi, les règlements et des valeurs éthiques",
    explanation:
        "La déontologie découle de textes juridiques et de valeurs fondamentales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier est dépositaire :",
    options: [
      "De l’autorité publique",
      "D’une autorité personnelle",
      "D’un pouvoir discrétionnaire illimité",
    ],
    answer: "De l’autorité publique",
    explanation: "Il agit au nom de l’État et de la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "L’exercice de l’autorité doit toujours être :",
    options: [
      "Légitime et proportionné",
      "Ferme et dissuasif uniquement",
      "Rapide avant tout",
    ],
    answer: "Légitime et proportionné",
    explanation:
        "Toute action policière doit respecter la légalité et la proportionnalité.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le respect des règles déontologiques contribue directement :",
    options: [
      "À la confiance de la population",
      "À l’augmentation des contrôles",
      "À la réduction des missions",
    ],
    answer: "À la confiance de la population",
    explanation:
        "La confiance est essentielle à l’efficacité de l’action policière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier doit faire preuve de discernement afin de :",
    options: [
      "Adapter son action à chaque situation",
      "Appliquer mécaniquement les règles",
      "Éviter toute prise de décision",
    ],
    answer: "Adapter son action à chaque situation",
    explanation:
        "Le discernement permet une réponse adaptée, légale et proportionnée.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "La probité interdit au policier :",
    options: [
      "De tirer un avantage personnel de sa fonction",
      "De refuser un cadeau symbolique",
      "De recevoir des remerciements verbaux",
    ],
    answer: "De tirer un avantage personnel de sa fonction",
    explanation:
        "La probité exclut tout favoritisme ou enrichissement personnel.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "La notion de loyauté implique notamment :",
    options: [
      "La fidélité aux institutions républicaines",
      "L’adhésion personnelle aux décisions",
      "L’absence totale de critique privée",
    ],
    answer: "La fidélité aux institutions républicaines",
    explanation: "La loyauté est un devoir professionnel fondamental.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Un policier identifiable comme tel engage :",
    options: [
      "L’image de l’institution",
      "Uniquement sa responsabilité personnelle",
      "Seulement son service d’affectation",
    ],
    answer: "L’image de l’institution",
    explanation:
        "Le comportement individuel rejaillit sur toute l’institution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le devoir de réserve impose principalement :",
    options: [
      "De la mesure dans l’expression publique",
      "Le silence absolu en toutes circonstances",
      "L’adhésion politique à l’État",
    ],
    answer: "De la mesure dans l’expression publique",
    explanation: "Le policier doit rester mesuré, notamment en public.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier doit se comporter avec dignité :",
    options: [
      "Même en dehors du service",
      "Uniquement en mission",
      "Seulement face au public",
    ],
    answer: "Même en dehors du service",
    explanation: "La dignité s’impose en permanence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "La neutralité interdit au policier en service :",
    options: [
      "Toute manifestation de convictions politiques ou religieuses",
      "Toute discussion personnelle",
      "Toute expression d’opinion privée",
    ],
    answer: "Toute manifestation de convictions politiques ou religieuses",
    explanation: "La neutralité est indispensable à l’impartialité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "L’exemplarité du policier signifie qu’il doit :",
    options: [
      "Adopter un comportement irréprochable",
      "Être plus sévère que les autres",
      "Éviter tout contact avec le public",
    ],
    answer: "Adopter un comportement irréprochable",
    explanation: "Le policier doit être un modèle de respect de la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le respect de la déontologie permet aussi :",
    options: [
      "De protéger juridiquement le policier",
      "D’éviter toute sanction automatique",
      "De réduire les contrôles hiérarchiques",
    ],
    answer: "De protéger juridiquement le policier",
    explanation: "Le respect des règles sécurise l’agent dans ses missions.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier doit traiter toute personne :",
    options: [
      "Avec impartialité et respect",
      "Selon sa réputation",
      "Selon son attitude uniquement",
    ],
    answer: "Avec impartialité et respect",
    explanation: "L’égalité de traitement est un principe fondamental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Un comportement contraire à la déontologie peut :",
    options: [
      "Nuire à la crédibilité de l’institution",
      "Rester sans conséquence",
      "Être justifié par l’ancienneté",
    ],
    answer: "Nuire à la crédibilité de l’institution",
    explanation: "Chaque manquement affaiblit la confiance publique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier agit toujours :",
    options: [
      "Dans le respect de la loi",
      "Selon son appréciation personnelle",
      "Selon l’urgence uniquement",
    ],
    answer: "Dans le respect de la loi",
    explanation: "La légalité est le fondement de toute action policière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question:
        "Le principe de proportionnalité signifie que l’action policière doit être :",
    options: [
      "Adaptée à la gravité de la situation",
      "La plus ferme possible",
      "Identique dans toutes les situations",
    ],
    answer: "Adaptée à la gravité de la situation",
    explanation: "La réponse doit être mesurée et nécessaire.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier doit inspirer confiance par :",
    options: [
      "Son comportement et son attitude",
      "Son autorité seule",
      "Sa tenue uniquement",
    ],
    answer: "Son comportement et son attitude",
    explanation: "La confiance repose sur le professionnalisme et le respect.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le respect de la dignité humaine est :",
    options: [
      "Une obligation absolue",
      "Conditionné au comportement de la personne",
      "Applicable uniquement en garde à vue",
    ],
    answer: "Une obligation absolue",
    explanation: "La dignité doit être respectée en toute circonstance.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question:
        "Le policier doit s’abstenir de toute discrimination fondée notamment sur :",
    options: [
      "L’origine, le sexe, les opinions",
      "Le comportement en intervention",
      "La situation judiciaire uniquement",
    ],
    answer: "L’origine, le sexe, les opinions",
    explanation: "Toute discrimination est strictement interdite.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "La loyauté impose au policier :",
    options: [
      "De rendre compte fidèlement",
      "De protéger ses collègues coûte que coûte",
      "De taire toute erreur",
    ],
    answer: "De rendre compte fidèlement",
    explanation: "Le compte rendu loyal est une obligation hiérarchique.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier doit éviter tout comportement pouvant :",
    options: [
      "Porter atteinte à l’image de l’institution",
      "Créer un débat public",
      "Être interprété différemment",
    ],
    answer: "Porter atteinte à l’image de l’institution",
    explanation: "L’image de la police doit être préservée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le respect de la déontologie s’impose :",
    options: [
      "À tous les policiers, quel que soit le grade",
      "Uniquement aux cadres",
      "Uniquement en service",
    ],
    answer: "À tous les policiers, quel que soit le grade",
    explanation: "Les règles s’appliquent à tous sans exception.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier doit faire preuve de retenue notamment :",
    options: [
      "Dans ses propos publics",
      "Dans ses pensées personnelles",
      "Dans ses échanges privés",
    ],
    answer: "Dans ses propos publics",
    explanation: "La retenue protège l’institution et l’agent.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le manquement à la déontologie peut entraîner :",
    options: [
      "Des sanctions disciplinaires",
      "Uniquement un rappel à l’ordre",
      "Aucune conséquence",
    ],
    answer: "Des sanctions disciplinaires",
    explanation: "Tout manquement est susceptible de sanction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier doit toujours conserver :",
    options: ["Son sang-froid", "Un ton autoritaire", "Une distance totale"],
    answer: "Son sang-froid",
    explanation: "La maîtrise de soi est essentielle en intervention.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "L’autorité du policier repose avant tout sur :",
    options: [
      "La légitimité de sa mission",
      "La crainte qu’il inspire",
      "La force physique",
    ],
    answer: "La légitimité de sa mission",
    explanation: "L’autorité découle de la loi et de la mission.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le respect du public implique notamment :",
    options: [
      "La courtoisie et le vouvoiement",
      "La familiarité",
      "La neutralité émotionnelle totale",
    ],
    answer: "La courtoisie et le vouvoiement",
    explanation: "Le vouvoiement est une règle de base.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier doit éviter toute attitude :",
    options: ["Humiliante ou vexatoire", "Directive", "Professionnelle"],
    answer: "Humiliante ou vexatoire",
    explanation: "Le respect de la dignité est impératif.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier est tenu d’exercer ses fonctions avec :",
    options: ["Neutralité", "Partialité assumée", "Préférence personnelle"],
    answer: "Neutralité",
    explanation: "La neutralité garantit l’égalité de traitement des citoyens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "La neutralité impose au policier de ne pas :",
    options: [
      "Exprimer ses convictions politiques ou religieuses en service",
      "Donner des consignes claires",
      "Appliquer la loi",
    ],
    answer: "Exprimer ses convictions politiques ou religieuses en service",
    explanation: "Toute manifestation de convictions est interdite en service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "L’impartialité signifie que le policier :",
    options: [
      "Traite toutes les personnes de manière égale",
      "S’adapte selon sa sympathie",
      "Favorise les personnes coopératives",
    ],
    answer: "Traite toutes les personnes de manière égale",
    explanation: "L’impartialité exclut toute discrimination.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question:
        "Le policier doit éviter toute familiarité excessive car elle peut :",
    options: [
      "Nuire à l’autorité et à l’image du service",
      "Améliorer la relation systématiquement",
      "Être exigée par le public",
    ],
    answer: "Nuire à l’autorité et à l’image du service",
    explanation: "La distance professionnelle est essentielle.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le respect du secret professionnel concerne :",
    options: [
      "Les informations connues dans l’exercice des fonctions",
      "Uniquement les enquêtes judiciaires",
      "Seulement les dossiers sensibles",
    ],
    answer: "Les informations connues dans l’exercice des fonctions",
    explanation: "Le secret couvre toute information non publique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le secret professionnel s’impose au policier :",
    options: [
      "Même après la fin du service",
      "Uniquement pendant le service",
      "Seulement en mission judiciaire",
    ],
    answer: "Même après la fin du service",
    explanation: "Le secret professionnel est permanent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Divulguer une information couverte par le secret peut engager :",
    options: [
      "La responsabilité disciplinaire et pénale",
      "Uniquement un rappel à l’ordre",
      "Aucune responsabilité",
    ],
    answer: "La responsabilité disciplinaire et pénale",
    explanation: "La violation du secret est lourdement sanctionnée.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "La discrétion professionnelle impose au policier :",
    options: [
      "De ne pas divulguer d’informations sensibles",
      "De garder le silence absolu",
      "De refuser toute discussion privée",
    ],
    answer: "De ne pas divulguer d’informations sensibles",
    explanation: "La discrétion complète le secret professionnel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier doit adopter une attitude exemplaire car il est :",
    options: [
      "Représentant de l’État",
      "Un citoyen ordinaire en uniforme",
      "Un simple exécutant",
    ],
    answer: "Représentant de l’État",
    explanation: "Il agit au nom de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "L’exemplarité s’applique au policier :",
    options: [
      "En service et hors service",
      "Uniquement pendant le service",
      "Seulement en uniforme",
    ],
    answer: "En service et hors service",
    explanation: "Le comportement privé peut engager l’institution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Un comportement inapproprié hors service peut :",
    options: [
      "Porter atteinte au crédit de la police",
      "Être sans conséquence",
      "Être protégé par la vie privée",
    ],
    answer: "Porter atteinte au crédit de la police",
    explanation: "L’image de l’institution doit toujours être préservée.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier doit rendre compte à sa hiérarchie :",
    options: [
      "De tout fait important survenu en service ou hors service",
      "Uniquement des succès",
      "Seulement sur demande écrite",
    ],
    answer: "De tout fait important survenu en service ou hors service",
    explanation: "Le compte rendu est une obligation hiérarchique.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le refus de rendre compte constitue :",
    options: [
      "Une faute professionnelle",
      "Un droit individuel",
      "Une option facultative",
    ],
    answer: "Une faute professionnelle",
    explanation: "Le compte rendu est obligatoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "La loyauté interdit notamment au policier :",
    options: [
      "De mentir à sa hiérarchie",
      "D’exprimer une difficulté",
      "De demander conseil",
    ],
    answer: "De mentir à sa hiérarchie",
    explanation: "La loyauté implique sincérité et honnêteté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "La déontologie vise principalement à :",
    options: [
      "Encadrer l’exercice de l’autorité",
      "Limiter l’action policière",
      "Remplacer le droit pénal",
    ],
    answer: "Encadrer l’exercice de l’autorité",
    explanation: "Elle garantit un usage légitime de l’autorité.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier doit exercer ses missions avec loyauté envers :",
    options: [
      "Les institutions de la République",
      "Ses opinions personnelles",
      "Son entourage professionnel uniquement",
    ],
    answer: "Les institutions de la République",
    explanation:
        "La loyauté est due à l’État et aux institutions républicaines.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "La loyauté implique notamment :",
    options: [
      "La sincérité dans les comptes rendus",
      "L’approbation systématique des décisions",
      "Le silence sur toute difficulté",
    ],
    answer: "La sincérité dans les comptes rendus",
    explanation: "Un compte rendu doit être fidèle et exact.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier ne peut refuser d’exécuter un ordre que s’il est :",
    options: [
      "Manifestement illégal",
      "Contraire à ses convictions",
      "Difficile à appliquer",
    ],
    answer: "Manifestement illégal",
    explanation:
        "Seuls les ordres manifestement illégaux peuvent être refusés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Un ordre manifestement illégal est un ordre :",
    options: [
      "Dont l’illégalité est évidente",
      "Simplement discutable",
      "Mal compris",
    ],
    answer: "Dont l’illégalité est évidente",
    explanation:
        "L’illégalité doit être claire et non sujette à interprétation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "L’exécution d’un ordre manifestement illégal peut engager :",
    options: [
      "La responsabilité de l’agent",
      "Uniquement celle du supérieur",
      "Aucune responsabilité",
    ],
    answer: "La responsabilité de l’agent",
    explanation: "L’obéissance n’exonère pas de responsabilité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question:
        "Le policier doit rendre compte lorsqu’un événement personnel est susceptible :",
    options: [
      "D’entraîner des poursuites",
      "De rester privé",
      "D’être sans lien avec le service",
    ],
    answer: "D’entraîner des poursuites",
    explanation:
        "Tout fait pouvant engager la responsabilité doit être signalé.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le respect de la hiérarchie est indispensable pour :",
    options: [
      "Le bon fonctionnement du service",
      "La rapidité uniquement",
      "Éviter toute responsabilité",
    ],
    answer: "Le bon fonctionnement du service",
    explanation: "La chaîne hiérarchique structure l’action policière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "La discipline policière repose notamment sur :",
    options: [
      "L’obéissance hiérarchique",
      "L’initiative individuelle exclusive",
      "La liberté totale d’action",
    ],
    answer: "L’obéissance hiérarchique",
    explanation: "La discipline est essentielle à la cohésion.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier doit adopter un comportement courtois afin de :",
    options: [
      "Préserver la relation avec la population",
      "Éviter toute interaction",
      "Gagner du temps",
    ],
    answer: "Préserver la relation avec la population",
    explanation: "La courtoisie favorise le respect mutuel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "La relation avec le public doit toujours être empreinte de :",
    options: [
      "Respect et politesse",
      "Autorité stricte",
      "Distance systématique",
    ],
    answer: "Respect et politesse",
    explanation: "Le respect est une exigence professionnelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le vouvoiement est une règle destinée à :",
    options: [
      "Marquer le respect",
      "Créer une distance excessive",
      "Imposer l’autorité",
    ],
    answer: "Marquer le respect",
    explanation: "Le vouvoiement est une marque de courtoisie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier doit veiller à son apparence car elle reflète :",
    options: [
      "L’image de l’institution",
      "Son style personnel",
      "Sa personnalité",
    ],
    answer: "L’image de l’institution",
    explanation: "L’apparence participe à la crédibilité du service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Une tenue négligée peut être perçue comme :",
    options: [
      "Un manque de professionnalisme",
      "Un détail sans importance",
      "Un choix personnel",
    ],
    answer: "Un manque de professionnalisme",
    explanation: "La tenue participe à l’autorité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le policier doit adapter son langage afin de rester :",
    options: [
      "Compréhensible et respectueux",
      "Technique uniquement",
      "Autoritaire",
    ],
    answer: "Compréhensible et respectueux",
    explanation: "Le langage doit être clair et adapté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le manquement au respect du public peut constituer :",
    options: [
      "Une faute disciplinaire",
      "Une simple erreur sans conséquence",
      "Un droit à l’erreur systématique",
    ],
    answer: "Une faute disciplinaire",
    explanation: "Le respect du public est une obligation.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’usage de la force par un policier doit toujours être :",
    options: [
      "Nécessaire et proportionné",
      "Systématique en cas de refus",
      "Décidé librement sans cadre",
    ],
    answer: "Nécessaire et proportionné",
    explanation:
        "L’usage de la force obéit aux principes de nécessité et de proportionnalité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question:
        "Le principe de proportionnalité signifie que la force utilisée doit être :",
    options: [
      "Adaptée à la menace",
      "La plus forte possible",
      "Identique en toute situation",
    ],
    answer: "Adaptée à la menace",
    explanation:
        "La réponse doit correspondre strictement au niveau de menace.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "Le principe de nécessité impose que l’usage de la force soit :",
    options: ["Le dernier recours", "Utilisé dès le début", "Automatique"],
    answer: "Le dernier recours",
    explanation: "La force n’est utilisée qu’en l’absence d’alternative.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "Avant d’utiliser la force, le policier doit privilégier :",
    options: [
      "Le dialogue",
      "La contrainte physique immédiate",
      "L’intimidation",
    ],
    answer: "Le dialogue",
    explanation:
        "La communication est prioritaire lorsque la situation le permet.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’usage de la force doit cesser :",
    options: [
      "Dès que l’objectif est atteint",
      "Uniquement sur ordre hiérarchique",
      "Après immobilisation prolongée",
    ],
    answer: "Dès que l’objectif est atteint",
    explanation: "Toute force inutile devient illégitime.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’emploi d’un moyen de force injustifié peut constituer :",
    options: [
      "Une faute disciplinaire et pénale",
      "Une simple erreur professionnelle",
      "Un acte couvert par la mission",
    ],
    answer: "Une faute disciplinaire et pénale",
    explanation: "L’abus de force engage la responsabilité de l’agent.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question:
        "Le policier doit toujours pouvoir justifier l’usage de la force par :",
    options: [
      "Les circonstances de la situation",
      "Son ressenti personnel",
      "La pression du public",
    ],
    answer: "Les circonstances de la situation",
    explanation: "La justification repose sur des éléments objectifs.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’usage de la force est interdit lorsqu’il vise :",
    options: ["À punir", "À neutraliser une menace", "À protéger autrui"],
    answer: "À punir",
    explanation: "La force n’est jamais une sanction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés publiques",
    question: "Le respect des libertés individuelles est une obligation :",
    options: [
      "Fondamentale du policier",
      "Secondaire face à l’ordre public",
      "Applicable uniquement hors service",
    ],
    answer: "Fondamentale du policier",
    explanation: "Les libertés publiques sont au cœur de la mission policière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés publiques",
    question: "Toute atteinte aux libertés doit être :",
    options: [
      "Légalement fondée",
      "Décidée par l’agent",
      "Systématiquement préventive",
    ],
    answer: "Légalement fondée",
    explanation: "Une base légale est indispensable.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés publiques",
    question: "Une mesure de contrainte sans base légale est :",
    options: ["Illégale", "Tolérée en cas d’urgence", "Valable si efficace"],
    answer: "Illégale",
    explanation: "Toute mesure doit reposer sur la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés publiques",
    question: "Le policier doit informer la personne concernée :",
    options: [
      "Des raisons de la mesure",
      "Uniquement de son identité",
      "Après la mesure seulement",
    ],
    answer: "Des raisons de la mesure",
    explanation: "L’information participe au respect des droits.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés publiques",
    question: "Le respect de la dignité humaine s’impose :",
    options: [
      "En toute circonstance",
      "Uniquement hors contrainte",
      "Selon le comportement de la personne",
    ],
    answer: "En toute circonstance",
    explanation: "La dignité humaine est intangible.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés publiques",
    question: "Les propos humiliants ou dégradants sont :",
    options: [
      "Strictement interdits",
      "Tolérés sous tension",
      "Admis pour impressionner",
    ],
    answer: "Strictement interdits",
    explanation: "Ils constituent un manquement déontologique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés publiques",
    question: "Le policier doit faire preuve d’impartialité afin de :",
    options: [
      "Garantir l’égalité de traitement",
      "Faciliter les procédures",
      "Éviter toute intervention",
    ],
    answer: "Garantir l’égalité de traitement",
    explanation: "L’impartialité est un principe fondamental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés publiques",
    question: "Une discrimination dans l’action policière est :",
    options: [
      "Interdite",
      "Tolérée selon le contexte",
      "Justifiée par l’efficacité",
    ],
    answer: "Interdite",
    explanation: "Toute discrimination est prohibée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés publiques",
    question: "Le contrôle d’identité doit reposer sur :",
    options: [
      "Une base légale",
      "Une intuition personnelle",
      "Une pression hiérarchique",
    ],
    answer: "Une base légale",
    explanation: "Le contrôle d’identité est strictement encadré.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés publiques",
    question: "Un contrôle abusif peut engager :",
    options: [
      "La responsabilité de l’agent",
      "Celle du public",
      "Aucune conséquence",
    ],
    answer: "La responsabilité de l’agent",
    explanation: "Les abus sont sanctionnables.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Personnes interpellées",
    question: "Toute personne interpellée doit être traitée avec :",
    options: [
      "Dignité et respect",
      "Fermeté systématique",
      "Suspicion permanente",
    ],
    answer: "Dignité et respect",
    explanation:
        "Le respect de la dignité humaine s’impose à toutes les étapes de l’intervention.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes interpellées",
    question: "L’usage de menottes est autorisé uniquement lorsqu’il est :",
    options: [
      "Justifié par le comportement ou le risque",
      "Automatique lors d’une interpellation",
      "Demandé par la hiérarchie",
    ],
    answer: "Justifié par le comportement ou le risque",
    explanation: "Le menottage doit être nécessaire et proportionné.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes interpellées",
    question: "Une personne maîtrisée et coopérative doit être :",
    options: [
      "Traitée sans contrainte inutile",
      "Maintenue sous pression",
      "Systématiquement menottée",
    ],
    answer: "Traitée sans contrainte inutile",
    explanation: "Toute contrainte injustifiée est interdite.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes interpellées",
    question: "Le policier doit adapter son comportement face à une personne :",
    options: ["Vulnérable", "Opposante uniquement", "Connue défavorablement"],
    answer: "Vulnérable",
    explanation:
        "Une attention particulière est requise pour les personnes vulnérables.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Garde à vue",
    question: "La garde à vue est une mesure :",
    options: [
      "Strictement encadrée par la loi",
      "Décidée librement par le policier",
      "Utilisable à titre préventif",
    ],
    answer: "Strictement encadrée par la loi",
    explanation:
        "La GAV est une mesure privative de liberté encadrée juridiquement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Garde à vue",
    question: "Une personne placée en garde à vue doit être informée :",
    options: [
      "De ses droits",
      "Uniquement du motif",
      "Après la première audition",
    ],
    answer: "De ses droits",
    explanation: "L’information immédiate des droits est obligatoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Garde à vue",
    question: "Le non-respect des droits en garde à vue peut entraîner :",
    options: [
      "La nullité de la procédure",
      "Un simple rappel",
      "Aucune conséquence",
    ],
    answer: "La nullité de la procédure",
    explanation: "Le respect des droits conditionne la validité des actes.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Garde à vue",
    question:
        "Le policier doit veiller à l’état de santé de la personne gardée à vue :",
    options: [
      "Tout au long de la mesure",
      "Uniquement à l’arrivée",
      "Seulement sur demande",
    ],
    answer: "Tout au long de la mesure",
    explanation: "La surveillance est continue et obligatoire.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes vulnérables",
    question: "Une personne mineure bénéficie :",
    options: [
      "De protections spécifiques",
      "Des mêmes règles sans adaptation",
      "D’aucune particularité",
    ],
    answer: "De protections spécifiques",
    explanation: "Les mineurs font l’objet d’un régime particulier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes vulnérables",
    question: "Une personne en état d’ivresse manifeste doit être :",
    options: [
      "Protégée et surveillée",
      "Sanctionnée immédiatement",
      "Laissée sans assistance",
    ],
    answer: "Protégée et surveillée",
    explanation: "La protection de la personne prime.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes vulnérables",
    question: "Une personne souffrant de troubles mentaux doit être :",
    options: [
      "Traitée avec discernement",
      "Neutralisée systématiquement",
      "Interpellée sans précaution",
    ],
    answer: "Traitée avec discernement",
    explanation: "L’adaptation du comportement est essentielle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes vulnérables",
    question: "Le recours à un médecin est obligatoire lorsque :",
    options: [
      "L’état de la personne le nécessite",
      "La garde à vue dépasse 24h",
      "La personne refuse de parler",
    ],
    answer: "L’état de la personne le nécessite",
    explanation: "La santé prime sur toute autre considération.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Auditions",
    question: "Les auditions doivent être conduites :",
    options: [
      "Sans pression ni contrainte",
      "Avec fermeté psychologique",
      "En privilégiant l’aveu",
    ],
    answer: "Sans pression ni contrainte",
    explanation: "Toute pression est contraire à la déontologie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Auditions",
    question: "Obtenir un aveu par contrainte est :",
    options: [
      "Strictement interdit",
      "Toléré sous stress",
      "Justifié par l’enquête",
    ],
    answer: "Strictement interdit",
    explanation: "Les aveux doivent être libres et volontaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Auditions",
    question: "Le respect du silence de la personne entendue est :",
    options: ["Obligatoire", "Optionnel", "Un frein à l’enquête"],
    answer: "Obligatoire",
    explanation: "Le droit au silence est un droit fondamental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Responsabilité",
    question: "Un manquement déontologique peut entraîner :",
    options: [
      "Une sanction disciplinaire",
      "Uniquement un rappel oral",
      "Aucune conséquence",
    ],
    answer: "Une sanction disciplinaire",
    explanation: "La déontologie engage la responsabilité de l’agent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Responsabilité",
    question: "Un comportement contraire à la déontologie nuit :",
    options: [
      "À la confiance du public",
      "Uniquement à l’agent",
      "Seulement au service",
    ],
    answer: "À la confiance du public",
    explanation: "La confiance est essentielle à l’action policière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Responsabilité",
    question: "Chaque policier est responsable :",
    options: [
      "De ses actes individuels",
      "Uniquement des ordres reçus",
      "Collectivement sans distinction",
    ],
    answer: "De ses actes individuels",
    explanation: "La responsabilité personnelle demeure.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Responsabilité",
    question: "Le respect strict de la déontologie permet :",
    options: [
      "Une action policière légitime",
      "D’éviter toute contestation",
      "De simplifier les procédures",
    ],
    answer: "Une action policière légitime",
    explanation: "La légitimité repose sur le respect des règles.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Contrôles",
    question: "Un contrôle d’identité doit toujours être :",
    options: [
      "Justifié légalement",
      "Effectué au hasard",
      "Autoritaire sans explication",
    ],
    answer: "Justifié légalement",
    explanation: "Tout contrôle doit reposer sur un fondement légal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Contrôles",
    question: "Lors d’un contrôle, le policier doit se comporter avec :",
    options: [
      "Courtoisie et professionnalisme",
      "Suspicion constante",
      "Dureté systématique",
    ],
    answer: "Courtoisie et professionnalisme",
    explanation: "Le comportement conditionne l’acceptation du contrôle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Contrôles",
    question: "Un contrôle discriminatoire est :",
    options: [
      "Strictement interdit",
      "Toléré en prévention",
      "Justifié par l’expérience",
    ],
    answer: "Strictement interdit",
    explanation:
        "Toute discrimination est contraire aux principes républicains.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Contrôles",
    question: "Le contrôle fondé uniquement sur l’apparence constitue :",
    options: [
      "Une discrimination",
      "Une méthode admise",
      "Un contrôle préventif",
    ],
    answer: "Une discrimination",
    explanation: "L’apparence ne peut justifier un contrôle.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Palpations",
    question: "La palpation de sécurité vise principalement à :",
    options: [
      "Prévenir un danger",
      "Humilier la personne",
      "Faciliter l’interpellation",
    ],
    answer: "Prévenir un danger",
    explanation: "Elle a pour but d’assurer la sécurité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Palpations",
    question: "La palpation de sécurité doit être :",
    options: [
      "Justifiée et proportionnée",
      "Systématique",
      "Effectuée sans motif",
    ],
    answer: "Justifiée et proportionnée",
    explanation: "Toute mesure doit être nécessaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Palpations",
    question: "La palpation doit être réalisée par un agent :",
    options: ["Du même sexe", "Le plus gradé", "Disponible uniquement"],
    answer: "Du même sexe",
    explanation: "Le respect de la personne est impératif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Palpations",
    question: "Une palpation injustifiée peut constituer :",
    options: [
      "Une atteinte aux libertés",
      "Une simple formalité",
      "Un acte administratif",
    ],
    answer: "Une atteinte aux libertés",
    explanation: "Elle porte atteinte aux droits fondamentaux.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fouilles",
    question: "La fouille d’une personne est :",
    options: ["Strictement encadrée", "Libre d’appréciation", "Automatique"],
    answer: "Strictement encadrée",
    explanation: "La fouille obéit à un cadre légal précis.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fouilles",
    question: "La fouille intégrale nécessite :",
    options: [
      "Un cadre légal strict",
      "La seule décision de l’agent",
      "Un simple soupçon",
    ],
    answer: "Un cadre légal strict",
    explanation: "Elle constitue une atteinte importante à l’intimité.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fouilles",
    question: "La dignité de la personne doit être respectée lors :",
    options: [
      "De toute fouille",
      "Uniquement en garde à vue",
      "Seulement pour les mineurs",
    ],
    answer: "De toute fouille",
    explanation: "La dignité humaine est intangible.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fouilles",
    question: "Une fouille sans base légale peut entraîner :",
    options: [
      "Une sanction disciplinaire",
      "Une validation automatique",
      "Aucune conséquence",
    ],
    answer: "Une sanction disciplinaire",
    explanation: "Le non-respect des règles engage la responsabilité.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés",
    question: "Le policier doit concilier sécurité publique et :",
    options: [
      "Respect des libertés",
      "Efficacité maximale",
      "Rapidité d’action",
    ],
    answer: "Respect des libertés",
    explanation: "La sécurité ne justifie pas tout.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés",
    question: "Toute atteinte aux libertés doit être :",
    options: ["Nécessaire et proportionnée", "Décidée librement", "Préventive"],
    answer: "Nécessaire et proportionnée",
    explanation: "Principe fondamental de l’action policière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés",
    question: "Le principe de proportionnalité implique :",
    options: [
      "Une réponse adaptée à la situation",
      "Une réponse maximale",
      "Une réponse dissuasive",
    ],
    answer: "Une réponse adaptée à la situation",
    explanation: "L’action doit être mesurée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés",
    question: "Une intervention disproportionnée peut :",
    options: [
      "Engager la responsabilité de l’agent",
      "Être justifiée après coup",
      "Être ignorée",
    ],
    answer: "Engager la responsabilité de l’agent",
    explanation: "Le policier est responsable de ses choix.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Image de l’institution",
    question: "Le comportement du policier engage :",
    options: [
      "L’image de la Police nationale",
      "Uniquement sa carrière",
      "Son équipe uniquement",
    ],
    answer: "L’image de la Police nationale",
    explanation: "Chaque agent représente l’institution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Image de l’institution",
    question: "Une attitude irréprochable contribue à :",
    options: [
      "Renforcer la confiance du public",
      "Accélérer les procédures",
      "Réduire les contrôles",
    ],
    answer: "Renforcer la confiance du public",
    explanation: "La confiance est essentielle à la mission.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Image de l’institution",
    question: "Le respect des règles déontologiques garantit :",
    options: [
      "La légitimité de l’action policière",
      "L’absence totale de critique",
      "Une efficacité absolue",
    ],
    answer: "La légitimité de l’action policière",
    explanation: "La légitimité repose sur le droit et l’éthique.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’usage de la force par un policier doit toujours être :",
    options: [
      "Nécessaire et proportionné",
      "Systématique lors d’une résistance",
      "Décidé librement",
    ],
    answer: "Nécessaire et proportionné",
    explanation:
        "La force ne peut être utilisée qu’en dernier recours et de manière adaptée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’usage de la force est autorisé lorsque :",
    options: [
      "Il est strictement nécessaire",
      "La situation est tendue",
      "L’agent est contrarié",
    ],
    answer: "Il est strictement nécessaire",
    explanation: "La nécessité est une condition essentielle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "Le principe de proportionnalité implique :",
    options: [
      "Une réponse adaptée à la menace",
      "Une réponse maximale",
      "Une réponse dissuasive",
    ],
    answer: "Une réponse adaptée à la menace",
    explanation: "La réponse doit être mesurée et justifiée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’usage excessif de la force constitue :",
    options: [
      "Une faute",
      "Un acte professionnel",
      "Une initiative personnelle",
    ],
    answer: "Une faute",
    explanation: "Tout excès engage la responsabilité de l’agent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "Le policier doit cesser l’usage de la force lorsque :",
    options: [
      "La menace disparaît",
      "La personne est interpellée",
      "Le supérieur arrive",
    ],
    answer: "La menace disparaît",
    explanation: "La force ne se justifie plus sans menace.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "Une personne maîtrisée et immobilisée doit être :",
    options: [
      "Traitée sans violence supplémentaire",
      "Maintenue sous pression",
      "Punitive",
    ],
    answer: "Traitée sans violence supplémentaire",
    explanation: "Toute violence inutile est interdite.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’usage de la force doit être précédé lorsque possible :",
    options: ["D’une sommation", "D’une sanction", "D’un rapport"],
    answer: "D’une sommation",
    explanation: "La sommation permet d’éviter le recours à la force.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’absence de sommation peut être justifiée lorsque :",
    options: [
      "L’urgence l’impose",
      "Le public est présent",
      "La personne fuit",
    ],
    answer: "L’urgence l’impose",
    explanation: "L’urgence peut rendre la sommation impossible.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question:
        "Le policier est responsable de l’usage de la force même sur ordre :",
    options: ["Oui", "Non", "Uniquement en cas de blessure"],
    answer: "Oui",
    explanation: "La responsabilité individuelle demeure.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "Un ordre d’utiliser la force manifestement illégal doit être :",
    options: ["Refusé", "Exécuté", "Négocié"],
    answer: "Refusé",
    explanation: "Un ordre manifestement illégal ne doit pas être exécuté.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’usage de la force doit être mentionné :",
    options: [
      "Dans un compte rendu",
      "Uniquement à l’oral",
      "Seulement en cas de blessure",
    ],
    answer: "Dans un compte rendu",
    explanation: "La traçabilité est obligatoire.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "Le compte rendu doit être :",
    options: ["Précis et sincère", "Bref et approximatif", "Orienté"],
    answer: "Précis et sincère",
    explanation: "La sincérité est une obligation déontologique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "Toute blessure constatée doit être :",
    options: ["Signalée", "Minimisée", "Ignorée"],
    answer: "Signalée",
    explanation: "Toute blessure doit faire l’objet d’un signalement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "Le recours aux armes est autorisé uniquement :",
    options: [
      "Dans les cas prévus par la loi",
      "Sur décision personnelle",
      "En cas de fuite",
    ],
    answer: "Dans les cas prévus par la loi",
    explanation: "L’usage des armes est strictement encadré.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’usage des armes doit respecter :",
    options: [
      "Nécessité, proportionnalité et légalité",
      "Efficacité maximale",
      "Rapidité",
    ],
    answer: "Nécessité, proportionnalité et légalité",
    explanation: "Ces principes encadrent strictement l’usage des armes.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "Un usage injustifié de l’arme peut entraîner :",
    options: [
      "Des sanctions pénales et disciplinaires",
      "Un simple rappel",
      "Aucune conséquence",
    ],
    answer: "Des sanctions pénales et disciplinaires",
    explanation: "Les conséquences peuvent être lourdes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "Le policier doit porter assistance à une personne blessée :",
    options: [
      "Même si elle est l’auteur des faits",
      "Uniquement si elle coopère",
      "Seulement sur ordre",
    ],
    answer: "Même si elle est l’auteur des faits",
    explanation: "L’assistance à personne blessée est une obligation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’obligation d’assistance s’applique :",
    options: [
      "En toute circonstance",
      "Uniquement hors service",
      "Seulement aux victimes",
    ],
    answer: "En toute circonstance",
    explanation: "L’obligation d’assistance est générale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "Le principe de neutralité impose au policier :",
    options: [
      "De ne pas afficher ses convictions",
      "De défendre ses opinions",
      "De rester silencieux en toute circonstance",
    ],
    answer: "De ne pas afficher ses convictions",
    explanation:
        "Le policier doit rester neutre dans l’exercice de ses fonctions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "La neutralité concerne principalement :",
    options: [
      "Les opinions politiques, religieuses et philosophiques",
      "Uniquement la religion",
      "Uniquement la politique",
    ],
    answer: "Les opinions politiques, religieuses et philosophiques",
    explanation: "Toutes les convictions personnelles sont concernées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "En service, le policier peut exprimer ses opinions politiques :",
    options: ["Jamais", "Uniquement à ses collègues", "Avec modération"],
    answer: "Jamais",
    explanation: "Toute expression d’opinion est interdite en service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "Le port d’un signe religieux visible en service est :",
    options: ["Interdit", "Autorisé discrètement", "Toléré"],
    answer: "Interdit",
    explanation: "La neutralité impose l’absence de signes visibles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "La neutralité du policier garantit :",
    options: [
      "L’égalité de traitement des citoyens",
      "La liberté d’opinion",
      "La rapidité des procédures",
    ],
    answer: "L’égalité de traitement des citoyens",
    explanation: "Tous les citoyens doivent être traités sans distinction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "Le devoir de réserve s’applique :",
    options: [
      "En et hors service",
      "Uniquement en service",
      "Uniquement hors service",
    ],
    answer: "En et hors service",
    explanation:
        "Le comportement du policier engage l’institution en permanence.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "Hors service, le policier peut s’exprimer librement :",
    options: [
      "Dans les limites du devoir de réserve",
      "Sans aucune limite",
      "Uniquement anonymement",
    ],
    answer: "Dans les limites du devoir de réserve",
    explanation: "La liberté d’expression reste encadrée.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question:
        "Une publication politique sur les réseaux sociaux peut constituer :",
    options: [
      "Un manquement au devoir de réserve",
      "Un droit absolu",
      "Une obligation citoyenne",
    ],
    answer: "Un manquement au devoir de réserve",
    explanation:
        "Les réseaux sociaux n’exemptent pas des obligations déontologiques.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "Critiquer publiquement l’institution policière est :",
    options: ["Interdit", "Autorisé anonymement", "Toléré hors service"],
    answer: "Interdit",
    explanation: "Cela porte atteinte au crédit de l’institution.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "Le devoir de réserve vise à protéger :",
    options: [
      "L’image et la crédibilité de l’institution",
      "La liberté individuelle",
      "La hiérarchie uniquement",
    ],
    answer: "L’image et la crédibilité de l’institution",
    explanation: "L’institution doit rester digne et respectée.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "Un policier identifiable ne doit pas :",
    options: [
      "Tenir de propos polémiques",
      "Informer le public",
      "Répondre aux citoyens",
    ],
    answer: "Tenir de propos polémiques",
    explanation: "Les propos polémiques nuisent à la neutralité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "L’obligation de neutralité s’applique aussi :",
    options: [
      "Sur les réseaux sociaux",
      "Uniquement en patrouille",
      "Uniquement en uniforme",
    ],
    answer: "Sur les réseaux sociaux",
    explanation: "Internet est un espace public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "La neutralité interdit au policier :",
    options: [
      "Toute discrimination",
      "Toute interaction",
      "Toute opinion privée",
    ],
    answer: "Toute discrimination",
    explanation: "La neutralité garantit l’impartialité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "Un manquement à la neutralité peut entraîner :",
    options: [
      "Des sanctions disciplinaires",
      "Un simple avertissement oral",
      "Aucune conséquence",
    ],
    answer: "Des sanctions disciplinaires",
    explanation: "Le non-respect des règles est sanctionnable.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "Le respect de la neutralité renforce :",
    options: [
      "La confiance du public",
      "L’autorité personnelle",
      "La liberté d’expression",
    ],
    answer: "La confiance du public",
    explanation: "La neutralité est un pilier de la légitimité policière.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "Afficher une opinion religieuse en uniforme est :",
    options: ["Strictement interdit", "Toléré", "Acceptable hors mission"],
    answer: "Strictement interdit",
    explanation: "La neutralité religieuse est absolue en service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "Le policier doit s’abstenir de toute prise de position :",
    options: [
      "Susceptible de nuire à l’institution",
      "Uniquement politique",
      "Uniquement médiatique",
    ],
    answer: "Susceptible de nuire à l’institution",
    explanation: "Toute prise de position nuisible est proscrite.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "La neutralité est indissociable de :",
    options: ["L’impartialité", "La discrétion", "La disponibilité"],
    answer: "L’impartialité",
    explanation: "La neutralité garantit une action impartiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "Un comportement partisan en service est :",
    options: [
      "Une faute déontologique",
      "Un droit individuel",
      "Une liberté protégée",
    ],
    answer: "Une faute déontologique",
    explanation: "Le service public impose une stricte neutralité.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Principes généraux",
    question: "Le policier exerce ses fonctions principalement au service :",
    options: [
      "De la population",
      "De sa hiérarchie",
      "De ses convictions personnelles",
    ],
    answer: "De la population",
    explanation:
        "Le policier est au service de la population et des institutions républicaines.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Principes généraux",
    question: "Le policier agit avec loyauté envers :",
    options: [
      "Les institutions de la République",
      "Ses collègues uniquement",
      "L’opinion publique",
    ],
    answer: "Les institutions de la République",
    explanation:
        "La loyauté envers les institutions est un principe fondamental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Principes généraux",
    question: "Le respect de la dignité humaine est exigé :",
    options: [
      "En toute circonstance",
      "Uniquement en service",
      "Uniquement lors des contrôles",
    ],
    answer: "En toute circonstance",
    explanation: "La dignité doit être respectée en permanence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "La neutralité impose au policier :",
    options: [
      "L’absence d’expression de convictions",
      "La défense de ses idées",
      "La liberté totale d’opinion",
    ],
    answer: "L’absence d’expression de convictions",
    explanation:
        "Les convictions personnelles ne doivent jamais transparaître.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "En service, un policier peut afficher une opinion politique :",
    options: ["Non, jamais", "Oui avec discrétion", "Oui hors intervention"],
    answer: "Non, jamais",
    explanation: "Toute opinion politique est interdite en service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "Le port d’un signe religieux en uniforme est :",
    options: ["Interdit", "Toléré", "Autorisé discrètement"],
    answer: "Interdit",
    explanation: "La neutralité religieuse est obligatoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Image",
    question: "Le comportement du policier engage :",
    options: [
      "L’image de l’institution",
      "Uniquement sa responsabilité personnelle",
      "Son service uniquement",
    ],
    answer: "L’image de l’institution",
    explanation: "Le policier est assimilé à l’institution qu’il représente.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Image",
    question: "Tenir des propos injurieux en public constitue :",
    options: [
      "Un manquement déontologique",
      "Une liberté d’expression",
      "Un fait sans conséquence",
    ],
    answer: "Un manquement déontologique",
    explanation: "Les propos injurieux nuisent au crédit de la police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question: "Les réseaux sociaux sont considérés comme :",
    options: ["Un espace public", "Un espace privé", "Un espace sans règles"],
    answer: "Un espace public",
    explanation: "Les publications peuvent être vues et partagées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question: "Même sous pseudonyme, le policier est :",
    options: [
      "Responsable de ses publications",
      "Protégé juridiquement",
      "Libre de tout propos",
    ],
    answer: "Responsable de ses publications",
    explanation: "L’anonymat n’exonère pas de responsabilité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question: "Publier une photo en uniforme sur un réseau social peut :",
    options: [
      "Mettre en danger le policier",
      "Être sans risque",
      "Être obligatoire",
    ],
    answer: "Mettre en danger le policier",
    explanation: "L’identification expose le policier et ses proches.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question: "Le droit à l’oubli sur internet est :",
    options: ["Inexistant", "Garanti", "Partiel"],
    answer: "Inexistant",
    explanation: "Une publication peut rester durablement accessible.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question: "La géolocalisation sur les réseaux sociaux doit être :",
    options: ["Désactivée", "Toujours activée", "Utilisée librement"],
    answer: "Désactivée",
    explanation: "La géolocalisation peut révéler des habitudes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question: "Mentionner une mission en cours sur internet est :",
    options: ["Strictement interdit", "Toléré", "Autorisé hors service"],
    answer: "Strictement interdit",
    explanation: "Le secret professionnel s’impose.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question: "Une publication humoristique peut engager la responsabilité :",
    options: ["Oui", "Non", "Uniquement si elle est signée"],
    answer: "Oui",
    explanation: "L’intention humoristique n’exonère pas.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question: "Critiquer publiquement la hiérarchie est :",
    options: ["Interdit", "Autorisé anonymement", "Toléré hors service"],
    answer: "Interdit",
    explanation: "Cela porte atteinte à la discipline et à l’image.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Image",
    question: "Le policier doit faire preuve d’exemplarité :",
    options: [
      "En et hors service",
      "Uniquement en service",
      "Uniquement en uniforme",
    ],
    answer: "En et hors service",
    explanation: "Le comportement privé peut rejaillir sur l’institution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Image",
    question: "Le crédit de la police nationale correspond à :",
    options: ["La réputation de l’institution", "Son budget", "Son effectif"],
    answer: "La réputation de l’institution",
    explanation: "Le crédit repose sur la confiance du public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Sanctions",
    question: "Un manquement déontologique peut entraîner :",
    options: [
      "Une sanction disciplinaire",
      "Aucune conséquence",
      "Uniquement un rappel oral",
    ],
    answer: "Une sanction disciplinaire",
    explanation: "Les manquements sont sanctionnables.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "Le respect strict des règles d’usage de la force garantit :",
    options: [
      "La légitimité de l’action policière",
      "L’absence de contestation",
      "Une efficacité absolue",
    ],
    answer: "La légitimité de l’action policière",
    explanation: "La légitimité repose sur le respect du droit.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "Le respect des règles déontologiques est aussi :",
    options: [
      "Une garantie pour l’agent",
      "Une contrainte inutile",
      "Une option facultative",
    ],
    answer: "Une garantie pour l’agent",
    explanation: "La déontologie protège autant qu’elle oblige.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Secret professionnel",
    question: "Le secret professionnel s’impose au policier :",
    options: [
      "Dans et hors service",
      "Uniquement en service",
      "Uniquement lors des enquêtes",
    ],
    answer: "Dans et hors service",
    explanation: "Le secret professionnel s’impose en toute circonstance.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Secret professionnel",
    question: "Le secret professionnel concerne :",
    options: [
      "Les informations connues par les fonctions",
      "Uniquement les procédures judiciaires",
      "Uniquement les dossiers sensibles",
    ],
    answer: "Les informations connues par les fonctions",
    explanation:
        "Toute information obtenue dans le cadre des fonctions est protégée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Secret professionnel",
    question: "Divulguer une information à un proche est :",
    options: ["Interdit", "Toléré", "Autorisé hors service"],
    answer: "Interdit",
    explanation: "Le secret professionnel s’impose même aux proches.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Secret professionnel",
    question: "Le secret professionnel protège principalement :",
    options: [
      "Les personnes et les enquêtes",
      "La hiérarchie",
      "L’administration uniquement",
    ],
    answer: "Les personnes et les enquêtes",
    explanation: "Il protège la vie privée et l’efficacité des missions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discrétion professionnelle",
    question: "La discrétion professionnelle impose de :",
    options: [
      "Limiter la diffusion d’informations",
      "Informer librement",
      "Communiquer publiquement",
    ],
    answer: "Limiter la diffusion d’informations",
    explanation: "Le policier doit faire preuve de retenue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discrétion professionnelle",
    question: "Un policier peut commenter une affaire en cours :",
    options: ["Non", "Oui anonymement", "Oui hors service"],
    answer: "Non",
    explanation: "Toute affaire en cours est couverte par la discrétion.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discrétion professionnelle",
    question: "Parler d’une intervention passée sans autorisation est :",
    options: ["Interdit", "Autorisé", "Toléré avec prudence"],
    answer: "Interdit",
    explanation: "La discrétion s’applique aussi aux faits passés.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Probité",
    question: "La probité correspond à :",
    options: [
      "L’honnêteté et l’intégrité",
      "La loyauté hiérarchique",
      "La discrétion",
    ],
    answer: "L’honnêteté et l’intégrité",
    explanation: "La probité exclut tout avantage personnel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Probité",
    question: "Un policier peut accepter un cadeau lié à ses fonctions :",
    options: ["Non", "Oui s’il est modeste", "Oui avec accord du citoyen"],
    answer: "Non",
    explanation: "Tout avantage lié aux fonctions est interdit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Probité",
    question:
        "Utiliser sa qualité de policier pour un avantage personnel est :",
    options: ["Strictement interdit", "Toléré", "Autorisé hors service"],
    answer: "Strictement interdit",
    explanation: "C’est un manquement grave à la probité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Probité",
    question: "La corruption est :",
    options: [
      "Incompatible avec la fonction",
      "Tolérée dans certains cas",
      "Autorisé indirectement",
    ],
    answer: "Incompatible avec la fonction",
    explanation: "La corruption est formellement interdite.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Probité",
    question: "Un conflit d’intérêts doit être :",
    options: ["Évité ou signalé", "Ignoré", "Géré personnellement"],
    answer: "Évité ou signalé",
    explanation: "Le policier doit prévenir tout conflit d’intérêts.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Impartialité",
    question: "L’impartialité impose :",
    options: [
      "L’absence de discrimination",
      "La neutralité politique uniquement",
      "L’égalité entre collègues",
    ],
    answer: "L’absence de discrimination",
    explanation: "Toute personne doit être traitée de manière égale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Impartialité",
    question: "Un policier peut adapter son comportement selon l’origine :",
    options: ["Non", "Oui", "Uniquement en intervention"],
    answer: "Non",
    explanation: "Toute distinction discriminatoire est interdite.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Impartialité",
    question: "Traiter différemment un proche est :",
    options: ["Un manquement", "Autorisé", "Toléré"],
    answer: "Un manquement",
    explanation: "L’impartialité s’impose même envers les proches.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Impartialité",
    question: "L’impartialité s’applique :",
    options: [
      "À toutes les missions",
      "Uniquement au judiciaire",
      "Uniquement au public",
    ],
    answer: "À toutes les missions",
    explanation: "Toutes les missions sont concernées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Probité",
    question: "Consulter un fichier par curiosité est :",
    options: ["Interdit", "Autorisé", "Toléré hors service"],
    answer: "Interdit",
    explanation: "L’accès aux fichiers doit être justifié par le service.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Probité",
    question: "Partager ses identifiants informatiques est :",
    options: ["Interdit", "Autorisé", "Toléré"],
    answer: "Interdit",
    explanation: "Les accès sont strictement personnels.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question: "La police nationale fonctionne selon un principe de :",
    options: [
      "Hiérarchie",
      "Autonomie individuelle",
      "Liberté totale d’action",
    ],
    answer: "Hiérarchie",
    explanation: "La police est une institution hiérarchisée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question: "Un ordre doit en principe être transmis par :",
    options: ["La voie hiérarchique", "Un collègue", "Un tiers extérieur"],
    answer: "La voie hiérarchique",
    explanation: "Les ordres suivent la chaîne hiérarchique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question: "Un supérieur hiérarchique est responsable :",
    options: [
      "Des ordres qu’il donne",
      "Uniquement de lui-même",
      "Uniquement de ses subordonnés",
    ],
    answer: "Des ordres qu’il donne",
    explanation: "L’autorité hiérarchique assume la responsabilité des ordres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question: "Le policier doit exécuter les ordres :",
    options: [
      "Loyablement et fidèlement",
      "Uniquement s’il est d’accord",
      "Uniquement par écrit",
    ],
    answer: "Loyablement et fidèlement",
    explanation: "L’obéissance est un principe fondamental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question: "Un ordre manifestement illégal doit être :",
    options: ["Refusé", "Exécuté", "Ignoré sans en parler"],
    answer: "Refusé",
    explanation: "Un ordre manifestement illégal ne doit pas être exécuté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question: "Un ordre est manifestement illégal lorsqu’il est :",
    options: [
      "Évidemment contraire à la loi",
      "Difficile à comprendre",
      "Donné oralement",
    ],
    answer: "Évidemment contraire à la loi",
    explanation: "L’illégalité doit être évidente.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question: "Refuser un ordre légal expose à :",
    options: [
      "Une sanction disciplinaire",
      "Aucune conséquence",
      "Une récompense",
    ],
    answer: "Une sanction disciplinaire",
    explanation: "Le refus d’obéissance constitue une faute.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question: "Un ordre écrit illégal :",
    options: [
      "N’exonère pas la responsabilité",
      "Protège totalement l’agent",
      "Devient légal",
    ],
    answer: "N’exonère pas la responsabilité",
    explanation: "Même écrit, un ordre illégal engage la responsabilité.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Compte rendu",
    question: "Le policier doit rendre compte :",
    options: [
      "À sa hiérarchie",
      "Uniquement à ses collègues",
      "Uniquement au public",
    ],
    answer: "À sa hiérarchie",
    explanation: "Le compte rendu est un devoir hiérarchique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Compte rendu",
    question: "Le compte rendu doit être :",
    options: ["Loyal et précis", "Orienté", "Incomplet si nécessaire"],
    answer: "Loyal et précis",
    explanation: "Les faits doivent être relatés fidèlement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Compte rendu",
    question: "Omettre volontairement un fait est :",
    options: ["Une faute", "Toléré", "Autorisé"],
    answer: "Une faute",
    explanation: "Toute omission volontaire est sanctionnable.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Compte rendu",
    question: "Le droit au silence est opposable à la hiérarchie :",
    options: ["Non", "Oui", "Uniquement hors service"],
    answer: "Non",
    explanation:
        "Le droit au silence ne s’applique pas dans la relation hiérarchique.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Compte rendu",
    question: "Un agent convoqué par une autorité doit :",
    options: [
      "En informer sa hiérarchie",
      "Ne rien dire",
      "Prévenir uniquement ses collègues",
    ],
    answer: "En informer sa hiérarchie",
    explanation: "L’obligation de rendre compte s’impose.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question: "Contourner volontairement la hiérarchie est :",
    options: ["Une faute", "Autorisé", "Encouragé"],
    answer: "Une faute",
    explanation: "La voie hiérarchique doit être respectée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question: "En cas d’urgence, un ordre peut être transmis :",
    options: ["Directement", "Uniquement par écrit", "Uniquement par note"],
    answer: "Directement",
    explanation: "L’urgence permet une transmission directe.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question: "Après une transmission directe en urgence, il faut :",
    options: [
      "Informer la hiérarchie intermédiaire",
      "Ne rien faire",
      "Attendre une sanction",
    ],
    answer: "Informer la hiérarchie intermédiaire",
    explanation: "La chaîne hiérarchique doit être informée.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Responsabilité",
    question: "La responsabilité du subordonné :",
    options: [
      "N’exonère pas celle du supérieur",
      "Annule celle du supérieur",
      "Remplace celle du supérieur",
    ],
    answer: "N’exonère pas celle du supérieur",
    explanation: "Chacun reste responsable de ses actes.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Responsabilité",
    question: "Mentir à sa hiérarchie constitue :",
    options: ["Un manquement grave", "Une simple erreur", "Un droit"],
    answer: "Un manquement grave",
    explanation: "Le devoir de loyauté interdit le mensonge.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discipline",
    question: "La discipline est indispensable :",
    options: [
      "Au fonctionnement de l’institution",
      "Uniquement en opération",
      "Uniquement en école",
    ],
    answer: "Au fonctionnement de l’institution",
    explanation: "La discipline garantit l’efficacité collective.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’usage de la force par un policier doit être :",
    options: [
      "Nécessaire et proportionné",
      "Systématique",
      "Libre d’appréciation totale",
    ],
    answer: "Nécessaire et proportionné",
    explanation:
        "La force n’est utilisée que si nécessaire et de façon proportionnée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "La force peut être utilisée uniquement lorsque :",
    options: [
      "Elle est strictement nécessaire",
      "L’agent le souhaite",
      "La personne refuse de parler",
    ],
    answer: "Elle est strictement nécessaire",
    explanation: "La nécessité est une condition obligatoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’usage de la force doit viser :",
    options: [
      "Un objectif légal",
      "Une punition",
      "Une démonstration d’autorité",
    ],
    answer: "Un objectif légal",
    explanation: "La force ne peut servir qu’un but légal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Proportionnalité",
    question: "La proportionnalité signifie que la force doit être :",
    options: [
      "Adaptée à la menace",
      "Maximale",
      "Identique dans toutes les situations",
    ],
    answer: "Adaptée à la menace",
    explanation: "La réponse doit correspondre à la gravité de la situation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Proportionnalité",
    question: "Une force excessive est :",
    options: ["Interdite", "Tolérée en intervention", "Autorisé sous stress"],
    answer: "Interdite",
    explanation: "Toute force disproportionnée est fautive.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discernement",
    question: "Le discernement consiste à :",
    options: [
      "Analyser la situation avant d’agir",
      "Appliquer systématiquement",
      "Agir sans réfléchir",
    ],
    answer: "Analyser la situation avant d’agir",
    explanation: "Le policier doit adapter sa réponse au contexte.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discernement",
    question: "Le discernement prend en compte :",
    options: [
      "Le danger et les délais",
      "L’opinion personnelle",
      "La fatigue uniquement",
    ],
    answer: "Le danger et les délais",
    explanation: "Le contexte et l’urgence sont essentiels.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discernement",
    question: "Le discernement est exigé :",
    options: [
      "Dans toutes les situations",
      "Uniquement hors urgence",
      "Uniquement en judiciaire",
    ],
    answer: "Dans toutes les situations",
    explanation: "Le discernement est permanent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "Le dialogue doit être privilégié lorsque :",
    options: [
      "La situation le permet",
      "La force est plus rapide",
      "L’agent est pressé",
    ],
    answer: "La situation le permet",
    explanation: "Le dialogue est prioritaire si possible.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’usage de la force est un :",
    options: ["Dernier recours", "Premier réflexe", "Outil systématique"],
    answer: "Dernier recours",
    explanation: "La force intervient après l’échec des autres moyens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "Employer la force sans nécessité constitue :",
    options: ["Une faute", "Un droit", "Une obligation"],
    answer: "Une faute",
    explanation: "L’absence de nécessité rend la force illégitime.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Menottage",
    question: "Le menottage est justifié lorsque la personne est :",
    options: [
      "Dangereuse ou susceptible de fuir",
      "Calme et coopérative",
      "Simplement contrôlée",
    ],
    answer: "Dangereuse ou susceptible de fuir",
    explanation: "Le menottage n’est pas systématique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Menottage",
    question: "Le menottage doit être :",
    options: ["Justifié et proportionné", "Automatique", "Punitif"],
    answer: "Justifié et proportionné",
    explanation: "Il s’agit d’une mesure de sûreté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Menottage",
    question: "Menotter sans justification est :",
    options: ["Fautif", "Recommandé", "Obligatoire"],
    answer: "Fautif",
    explanation: "Le menottage doit toujours être motivé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes privées de liberté",
    question: "Une personne interpellée est placée sous :",
    options: [
      "La protection des policiers",
      "La seule responsabilité judiciaire",
      "Aucune protection",
    ],
    answer: "La protection des policiers",
    explanation: "La dignité et la sécurité doivent être garanties.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes privées de liberté",
    question: "Tout traitement inhumain ou dégradant est :",
    options: ["Interdit", "Toléré en cas de stress", "Autorisé en urgence"],
    answer: "Interdit",
    explanation: "La dignité humaine est inviolable.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes privées de liberté",
    question: "L’état de santé d’une personne retenue doit être :",
    options: ["Surveillé", "Ignoré", "Évalué uniquement à la fin"],
    answer: "Surveillé",
    explanation: "Le policier est responsable de la personne retenue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "La force doit cesser lorsque :",
    options: [
      "La menace disparaît",
      "La personne est maîtrisée",
      "L’intervention se termine",
    ],
    answer: "La menace disparaît",
    explanation: "La force ne doit jamais excéder la nécessité.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Relation avec la population",
    question: "Le policier agit envers la population avec :",
    options: [
      "Respect et courtoisie",
      "Autorité systématique",
      "Distance excessive",
    ],
    answer: "Respect et courtoisie",
    explanation: "La relation avec le public doit rester respectueuse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Relation avec la population",
    question: "La courtoisie du policier est :",
    options: [
      "Une obligation déontologique",
      "Optionnelle",
      "Réservée aux personnes calmes",
    ],
    answer: "Une obligation déontologique",
    explanation: "La courtoisie s’impose en toutes circonstances.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Relation avec la population",
    question: "Le tutoiement d’un usager est :",
    options: ["À éviter sauf nécessité", "Recommandé", "Obligatoire"],
    answer: "À éviter sauf nécessité",
    explanation: "Le respect passe aussi par le langage.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "Le policier doit faire preuve de neutralité :",
    options: [
      "En toutes circonstances",
      "Uniquement en service",
      "Uniquement en judiciaire",
    ],
    answer: "En toutes circonstances",
    explanation: "La neutralité est permanente.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "Exprimer une opinion politique en service est :",
    options: ["Interdit", "Autorisé", "Toléré"],
    answer: "Interdit",
    explanation: "Le devoir de neutralité s’impose.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "Le policier traite les personnes :",
    options: [
      "De manière impartiale",
      "Selon leur comportement passé",
      "Selon leur opinion",
    ],
    answer: "De manière impartiale",
    explanation: "L’impartialité est une exigence fondamentale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Respect",
    question: "La dignité humaine doit être respectée :",
    options: [
      "En toute circonstance",
      "Uniquement hors garde à vue",
      "Uniquement en public",
    ],
    answer: "En toute circonstance",
    explanation: "Aucune situation ne justifie une atteinte à la dignité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Respect",
    question: "Les propos humiliants sont :",
    options: [
      "Interdits",
      "Tolérés sous stress",
      "Acceptables en intervention",
    ],
    answer: "Interdits",
    explanation: "Ils constituent une faute déontologique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Relation avec la population",
    question: "Le policier doit expliquer ses actions lorsque :",
    options: ["Cela est possible", "La personne insiste", "Jamais"],
    answer: "Cela est possible",
    explanation: "La pédagogie renforce la confiance.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Relation avec la population",
    question: "La confiance du public repose notamment sur :",
    options: ["Le comportement du policier", "La sanction", "La contrainte"],
    answer: "Le comportement du policier",
    explanation: "Le comportement individuel engage l’institution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discrimination",
    question: "Toute discrimination est :",
    options: [
      "Strictement interdite",
      "Tolérée implicitement",
      "Possible en contrôle",
    ],
    answer: "Strictement interdite",
    explanation: "Aucune distinction illégitime n’est admise.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discrimination",
    question: "Le contrôle fondé sur l’apparence est :",
    options: ["Interdit", "Autorisé", "Recommandé"],
    answer: "Interdit",
    explanation: "Un contrôle doit toujours être objectivement justifié.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discrimination",
    question: "Un contrôle doit reposer sur :",
    options: [
      "Des critères objectifs",
      "Des préjugés",
      "L’intuition personnelle",
    ],
    answer: "Des critères objectifs",
    explanation: "La légitimité repose sur l’objectivité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Relation avec la population",
    question: "Le policier représente :",
    options: ["L’État", "Sa propre opinion", "Son service uniquement"],
    answer: "L’État",
    explanation: "Chaque policier engage l’image de l’État.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Relation avec la population",
    question: "Une provocation verbale doit entraîner :",
    options: [
      "Du sang-froid",
      "Une réponse agressive",
      "Une sanction immédiate",
    ],
    answer: "Du sang-froid",
    explanation: "Le policier maîtrise ses réactions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Maîtrise de soi",
    question: "La maîtrise de soi est :",
    options: [
      "Une obligation professionnelle",
      "Un choix personnel",
      "Secondaire",
    ],
    answer: "Une obligation professionnelle",
    explanation: "Elle conditionne la légitimité de l’action.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Maîtrise de soi",
    question: "Une réaction excessive face à une insulte est :",
    options: ["Fautive", "Compréhensible", "Justifiée"],
    answer: "Fautive",
    explanation: "La retenue est exigée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Relation avec la population",
    question: "Le dialogue avec la population permet :",
    options: [
      "La prévention des tensions",
      "L’aggravation des conflits",
      "La perte d’autorité",
    ],
    answer: "La prévention des tensions",
    explanation: "Le dialogue est un outil professionnel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Relation avec la population",
    question: "Un comportement déplacé peut entraîner :",
    options: [
      "Une sanction disciplinaire",
      "Aucune conséquence",
      "Une simple remarque",
    ],
    answer: "Une sanction disciplinaire",
    explanation: "Le comportement est strictement encadré.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question: "Le policier est placé sous l’autorité :",
    options: ["De la hiérarchie", "Du public", "De sa seule conscience"],
    answer: "De la hiérarchie",
    explanation:
        "La Police nationale fonctionne selon un principe hiérarchique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question: "Le principe hiérarchique implique :",
    options: [
      "L’exécution des ordres",
      "La discussion permanente",
      "L’indépendance totale",
    ],
    answer: "L’exécution des ordres",
    explanation: "Les ordres doivent être exécutés dans le respect de la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question: "Un ordre légal doit être :",
    options: ["Exécuté", "Contesté systématiquement", "Ignoré"],
    answer: "Exécuté",
    explanation: "L’obéissance hiérarchique est la règle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question: "Un ordre manifestement illégal doit être :",
    options: ["Refusé", "Exécuté", "Reporté"],
    answer: "Refusé",
    explanation:
        "Le policier ne doit pas exécuter un ordre manifestement illégal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question: "Un ordre compromettant gravement un intérêt public doit être :",
    options: ["Refusé", "Appliqué", "Négocié"],
    answer: "Refusé",
    explanation: "La loi prime sur l’obéissance.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Responsabilité",
    question: "Le policier reste responsable :",
    options: ["De ses actes", "Uniquement des ordres reçus", "De rien"],
    answer: "De ses actes",
    explanation:
        "L’exécution d’un ordre n’efface pas la responsabilité personnelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Responsabilité",
    question: "La responsabilité disciplinaire peut être engagée :",
    options: [
      "Même sans infraction pénale",
      "Uniquement en cas de délit",
      "Uniquement en cas de plainte",
    ],
    answer: "Même sans infraction pénale",
    explanation: "Une faute déontologique suffit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Responsabilité",
    question: "La responsabilité pénale du policier est :",
    options: ["Personnelle", "Collective", "Inexistante"],
    answer: "Personnelle",
    explanation: "Chaque agent répond pénalement de ses actes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question: "Rendre compte signifie :",
    options: ["Informer la hiérarchie", "Informer le public", "Ne rien dire"],
    answer: "Informer la hiérarchie",
    explanation: "Le compte rendu est une obligation professionnelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Compte rendu",
    question: "Le compte rendu doit être :",
    options: ["Exact et loyal", "Partiel", "Orienté"],
    answer: "Exact et loyal",
    explanation: "Toute altération des faits est fautive.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Compte rendu",
    question: "Omettre volontairement un fait est :",
    options: ["Une faute", "Acceptable", "Recommandé"],
    answer: "Une faute",
    explanation: "Le compte rendu doit être complet.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Compte rendu",
    question: "Le policier rend compte :",
    options: [
      "De tout fait notable",
      "Uniquement sur demande",
      "Uniquement en judiciaire",
    ],
    answer: "De tout fait notable",
    explanation: "Le devoir de rendre compte est permanent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question: "Contester un ordre doit se faire :",
    options: [
      "Par voie hiérarchique",
      "Devant le public",
      "Sur les réseaux sociaux",
    ],
    answer: "Par voie hiérarchique",
    explanation: "Le respect de la hiérarchie est essentiel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question: "La hiérarchie garantit :",
    options: ["La cohérence de l’action", "L’arbitraire", "La confusion"],
    answer: "La cohérence de l’action",
    explanation: "Elle structure l’action policière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Responsabilité",
    question: "Un policier peut être sanctionné pour :",
    options: [
      "Un manquement déontologique",
      "Une simple opinion privée",
      "Une pensée",
    ],
    answer: "Un manquement déontologique",
    explanation: "La déontologie encadre le comportement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Responsabilité",
    question: "La responsabilité administrative concerne :",
    options: ["Les fautes de service", "Les crimes uniquement", "Les opinions"],
    answer: "Les fautes de service",
    explanation: "Elle engage l’administration.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question: "L’obéissance hiérarchique est limitée par :",
    options: ["La légalité", "La fatigue", "L’humeur"],
    answer: "La légalité",
    explanation: "Aucun ordre illégal ne doit être exécuté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Compte rendu",
    question: "Un rapport mensonger constitue :",
    options: ["Une faute grave", "Une simple erreur", "Un détail"],
    answer: "Une faute grave",
    explanation: "La loyauté est essentielle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Compte rendu",
    question: "Le compte rendu protège aussi :",
    options: [
      "Le policier",
      "Uniquement l’administration",
      "Uniquement le public",
    ],
    answer: "Le policier",
    explanation: "Il trace l’action réalisée.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Secret professionnel",
    question: "Le secret professionnel s’impose au policier :",
    options: [
      "Dans et hors service",
      "Uniquement en service",
      "Uniquement hors service",
    ],
    answer: "Dans et hors service",
    explanation: "Le secret professionnel ne cesse pas hors service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Secret professionnel",
    question: "Le secret professionnel concerne :",
    options: [
      "Les informations connues par les fonctions",
      "Les informations publiques",
      "Les rumeurs",
    ],
    answer: "Les informations connues par les fonctions",
    explanation:
        "Toute information acquise dans le cadre professionnel est protégée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Secret professionnel",
    question: "La violation du secret professionnel est :",
    options: ["Punissable pénalement", "Tolérée", "Sans conséquence"],
    answer: "Punissable pénalement",
    explanation: "La violation du secret est une infraction pénale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discrétion",
    question: "L’obligation de discrétion professionnelle impose :",
    options: [
      "La retenue dans la communication",
      "La transparence totale",
      "La liberté d’expression complète",
    ],
    answer: "La retenue dans la communication",
    explanation: "La discrétion protège le service et les personnes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discrétion",
    question: "Un policier peut divulguer une information professionnelle :",
    options: [
      "S’il y est légalement autorisé",
      "À ses proches",
      "Sur les réseaux sociaux",
    ],
    answer: "S’il y est légalement autorisé",
    explanation: "Toute divulgation doit être prévue par la loi.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Discrétion",
    question: "La discrétion professionnelle s’applique :",
    options: [
      "Même sans secret pénal",
      "Uniquement en enquête judiciaire",
      "Uniquement pour les OPJ",
    ],
    answer: "Même sans secret pénal",
    explanation: "La discrétion va au-delà du secret pénal.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Communication",
    question: "La communication avec les médias relève :",
    options: [
      "De l’autorité hiérarchique",
      "De l’initiative personnelle",
      "Du public",
    ],
    answer: "De l’autorité hiérarchique",
    explanation: "Le policier ne communique pas librement avec la presse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Communication",
    question: "Un policier interrogé par un journaliste doit :",
    options: [
      "S’abstenir de répondre sans autorisation",
      "Tout expliquer",
      "Répondre anonymement",
    ],
    answer: "S’abstenir de répondre sans autorisation",
    explanation: "La communication institutionnelle est encadrée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question: "Les réseaux sociaux sont soumis :",
    options: [
      "Aux obligations déontologiques",
      "À aucune règle",
      "À la liberté totale",
    ],
    answer: "Aux obligations déontologiques",
    explanation: "Internet ne supprime pas les obligations professionnelles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question: "Publier une photo de service sans autorisation est :",
    options: ["Interdit", "Autorisé", "Recommandé"],
    answer: "Interdit",
    explanation: "Les images de service sont protégées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question:
        "Critiquer publiquement l’institution policière peut constituer :",
    options: [
      "Un manquement au devoir de réserve",
      "Un droit absolu",
      "Une obligation",
    ],
    answer: "Un manquement au devoir de réserve",
    explanation: "Le devoir de réserve s’impose aux policiers.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question: "Un policier doit éviter en ligne :",
    options: [
      "Tout propos portant atteinte à l’image de la police",
      "Toute activité",
      "Toute opinion privée",
    ],
    answer: "Tout propos portant atteinte à l’image de la police",
    explanation: "L’image de l’institution doit être protégée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Secret professionnel",
    question: "Révéler une enquête en cours à un proche est :",
    options: ["Une infraction", "Toléré", "Sans conséquence"],
    answer: "Une infraction",
    explanation: "Le secret de l’enquête est absolu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Secret professionnel",
    question: "Le secret professionnel protège :",
    options: [
      "Les personnes et les procédures",
      "Uniquement la police",
      "Uniquement l’État",
    ],
    answer: "Les personnes et les procédures",
    explanation: "Il garantit les droits et la sécurité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discrétion",
    question: "Parler d’un dossier sensible dans un lieu public est :",
    options: ["Un manquement", "Autorisé", "Anodin"],
    answer: "Un manquement",
    explanation: "La discrétion s’impose en tout lieu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discrétion",
    question: "La discrétion professionnelle vise à :",
    options: [
      "Préserver la confiance du public",
      "Limiter l’information",
      "Protéger uniquement l’agent",
    ],
    answer: "Préserver la confiance du public",
    explanation: "La confiance repose sur la retenue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Communication",
    question: "Un policier ne doit jamais divulguer :",
    options: ["Des informations opérationnelles", "Son identité", "Son grade"],
    answer: "Des informations opérationnelles",
    explanation: "Les informations opérationnelles sont sensibles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question: "Un pseudonyme sur les réseaux sociaux :",
    options: [
      "N’exonère pas des responsabilités",
      "Protège totalement",
      "Autorise tout propos",
    ],
    answer: "N’exonère pas des responsabilités",
    explanation: "L’anonymat n’efface pas les obligations.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Réseaux sociaux",
    question: "Partager une intervention en direct est :",
    options: ["Strictement interdit", "Autorisé", "Encouragé"],
    answer: "Strictement interdit",
    explanation: "Cela met en danger les personnes et le service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Neutralité",
    question: "La neutralité religieuse impose :",
    options: [
      "L’absence de signes ostentatoires",
      "La liberté totale",
      "L’expression personnelle",
    ],
    answer: "L’absence de signes ostentatoires",
    explanation: "Le policier est soumis au principe de laïcité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "Un usage injustifié de la force peut entraîner :",
    options: [
      "Des sanctions disciplinaires et pénales",
      "Une simple remarque",
      "Aucune conséquence",
    ],
    answer: "Des sanctions disciplinaires et pénales",
    explanation: "Les abus sont sévèrement sanctionnés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Sanctions",
    question: "La violation du secret professionnel peut entraîner :",
    options: [
      "Des sanctions disciplinaires et pénales",
      "Un simple avertissement",
      "Aucune conséquence",
    ],
    answer: "Des sanctions disciplinaires et pénales",
    explanation: "La violation du secret est lourdement sanctionnée.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’usage de la force par le policier doit toujours être :",
    options: ["Strictement nécessaire", "Systématique", "Préventif"],
    answer: "Strictement nécessaire",
    explanation: "La force n’est utilisée qu’en cas de nécessité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question:
        "Le principe de proportionnalité signifie que la force utilisée doit être :",
    options: [
      "Adaptée à la situation",
      "Maximale",
      "Identique dans tous les cas",
    ],
    answer: "Adaptée à la situation",
    explanation: "La réponse doit être proportionnée à la menace.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’usage de la force est autorisé uniquement si :",
    options: [
      "Il est nécessaire et proportionné",
      "Le policier est en colère",
      "La personne résiste verbalement",
    ],
    answer: "Il est nécessaire et proportionné",
    explanation: "La force est strictement encadrée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "Le policier doit cesser l’usage de la force dès que :",
    options: [
      "La menace disparaît",
      "La personne est immobilisée depuis longtemps",
      "Le supérieur arrive",
    ],
    answer: "La menace disparaît",
    explanation: "La force cesse dès qu’elle n’est plus nécessaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’usage de la force doit toujours respecter :",
    options: [
      "La dignité humaine",
      "La rapidité d’action",
      "L’efficacité avant tout",
    ],
    answer: "La dignité humaine",
    explanation: "Le respect de la dignité est fondamental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés",
    question: "Le policier agit dans le respect :",
    options: [
      "Des libertés fondamentales",
      "Des objectifs uniquement",
      "De la pression opérationnelle",
    ],
    answer: "Des libertés fondamentales",
    explanation: "La mission policière respecte les libertés publiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés",
    question: "Une atteinte injustifiée aux libertés peut constituer :",
    options: ["Une faute", "Un acte normal", "Une obligation"],
    answer: "Une faute",
    explanation: "Toute atteinte doit être légalement fondée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés",
    question: "Le contrôle d’identité doit être :",
    options: ["Légalement justifié", "Systématique", "Discrétionnaire"],
    answer: "Légalement justifié",
    explanation: "Le contrôle repose sur un cadre légal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Libertés",
    question: "Un contrôle abusif peut engager :",
    options: [
      "La responsabilité du policier",
      "Uniquement celle de l’État",
      "Aucune responsabilité",
    ],
    answer: "La responsabilité du policier",
    explanation: "Tout acte illégal engage la responsabilité.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’usage de la contrainte doit être précédé :",
    options: [
      "D’une sommation si possible",
      "D’un contact physique immédiat",
      "D’un avertissement médiatique",
    ],
    answer: "D’une sommation si possible",
    explanation: "La sommation est une étape essentielle.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Personnes interpellées",
    question: "Toute personne interpellée doit être traitée avec :",
    options: [
      "Dignité et respect",
      "Fermeté sans limite",
      "Méfiance systématique",
    ],
    answer: "Dignité et respect",
    explanation:
        "La dignité humaine doit être respectée en toutes circonstances.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes interpellées",
    question: "Une personne interpellée est placée sous la protection :",
    options: [
      "Des policiers",
      "D’elle-même uniquement",
      "De la justice uniquement",
    ],
    answer: "Des policiers",
    explanation:
        "La personne est sous la responsabilité des forces de l’ordre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Garde à vue",
    question: "La garde à vue doit respecter :",
    options: [
      "Les droits de la personne",
      "La convenance du service",
      "L’opinion des agents",
    ],
    answer: "Les droits de la personne",
    explanation: "La GAV est strictement encadrée par la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Garde à vue",
    question: "Toute personne placée en garde à vue doit être informée :",
    options: ["De ses droits", "Uniquement du motif", "Uniquement de la durée"],
    answer: "De ses droits",
    explanation: "L’information des droits est obligatoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Garde à vue",
    question: "Le non-respect des droits en garde à vue peut entraîner :",
    options: [
      "La nullité de la procédure",
      "Aucune conséquence",
      "Un simple rappel",
    ],
    answer: "La nullité de la procédure",
    explanation: "Les vices de procédure ont des conséquences juridiques.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Mineurs",
    question: "Un mineur interpellé doit bénéficier :",
    options: [
      "De garanties spécifiques",
      "Du même régime qu’un majeur",
      "D’aucune protection particulière",
    ],
    answer: "De garanties spécifiques",
    explanation: "Le statut de mineur impose des règles renforcées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Mineurs",
    question: "La présence d’un représentant légal est :",
    options: ["Obligatoire sauf exception légale", "Facultative", "Interdite"],
    answer: "Obligatoire sauf exception légale",
    explanation: "Les droits du mineur doivent être garantis.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes vulnérables",
    question: "Une personne vulnérable doit faire l’objet :",
    options: [
      "D’une attention particulière",
      "D’un traitement standard",
      "D’une contrainte renforcée",
    ],
    answer: "D’une attention particulière",
    explanation: "La vulnérabilité impose une vigilance accrue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes vulnérables",
    question: "La vulnérabilité peut être liée :",
    options: [
      "À l’âge, la santé ou le handicap",
      "Uniquement à l’âge",
      "Uniquement au comportement",
    ],
    answer: "À l’âge, la santé ou le handicap",
    explanation: "La vulnérabilité prend plusieurs formes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes privées de liberté",
    question: "Toute personne privée de liberté doit être protégée contre :",
    options: [
      "Les traitements inhumains ou dégradants",
      "Les contraintes administratives",
      "La procédure judiciaire",
    ],
    answer: "Les traitements inhumains ou dégradants",
    explanation: "La dignité humaine est intangible.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes privées de liberté",
    question:
        "Un manquement grave à la protection d’une personne détenue engage :",
    options: [
      "La responsabilité disciplinaire et pénale",
      "Uniquement la responsabilité morale",
      "Aucune responsabilité",
    ],
    answer: "La responsabilité disciplinaire et pénale",
    explanation: "Les manquements graves sont lourdement sanctionnés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "Un usage excessif de la force peut être qualifié de :",
    options: ["Faute grave", "Geste professionnel", "Erreur sans conséquence"],
    answer: "Faute grave",
    explanation: "L’excès de force est strictement sanctionné.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-9 du Code de déontologie ?",
    options: ["La probité", "L’impartialité", "Le discernement"],
    answer: "La probité",
    explanation:
        "L’article R. 434-9 traite de la probité du policier ou du gendarme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "Quel article du Code de déontologie concerne la probité ?",
    options: ["Article R. 434-9", "Article R. 434-11", "Article R. 434-8"],
    answer: "Article R. 434-9",
    explanation: "La probité est définie par l’article R. 434-9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-11 du Code de déontologie ?",
    options: ["L’impartialité", "La probité", "La loyauté"],
    answer: "L’impartialité",
    explanation:
        "L’article R. 434-11 impose l’impartialité dans l’exercice des missions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "Quel article impose l’impartialité au policier ?",
    options: ["Article R. 434-11", "Article R. 434-10", "Article R. 434-12"],
    answer: "Article R. 434-11",
    explanation: "L’impartialité est prévue par l’article R. 434-11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "L’article R. 434-8 concerne :",
    options: [
      "Le secret et la discrétion professionnels",
      "La probité",
      "Le devoir de réserve",
    ],
    answer: "Le secret et la discrétion professionnels",
    explanation:
        "L’article R. 434-8 traite du secret professionnel et du devoir de discrétion.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "Quel article traite du secret professionnel ?",
    options: ["Article R. 434-8", "Article R. 434-12", "Article R. 434-9"],
    answer: "Article R. 434-8",
    explanation:
        "Le secret et la discrétion professionnels sont fixés à l’article R. 434-8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-10 ?",
    options: ["Le discernement", "L’obéissance", "La neutralité"],
    answer: "Le discernement",
    explanation:
        "L’article R. 434-10 impose le discernement dans l’action policière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "Quel article impose le discernement au policier ?",
    options: ["Article R. 434-10", "Article R. 434-11", "Article R. 434-14"],
    answer: "Article R. 434-10",
    explanation: "Le discernement est défini à l’article R. 434-10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "L’article R. 434-12 concerne :",
    options: [
      "Le crédit et le renom de l’institution",
      "La probité",
      "Le secret professionnel",
    ],
    answer: "Le crédit et le renom de l’institution",
    explanation:
        "L’article R. 434-12 protège l’image et la réputation de l’institution.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article interdit tout comportement portant atteinte à l’image de la police ?",
    options: ["Article R. 434-12", "Article R. 434-9", "Article R. 434-8"],
    answer: "Article R. 434-12",
    explanation:
        "Le crédit et le renom de l’institution sont protégés par l’article R. 434-12.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-29 ?",
    options: ["Le devoir de réserve", "La probité", "La disponibilité"],
    answer: "Le devoir de réserve",
    explanation: "L’article R. 434-29 traite du devoir de réserve du policier.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "Quel article encadre le devoir de réserve du policier ?",
    options: ["Article R. 434-29", "Article R. 434-30", "Article R. 434-11"],
    answer: "Article R. 434-29",
    explanation: "Le devoir de réserve est défini par l’article R. 434-29.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "L’article R. 434-30 concerne :",
    options: ["La disponibilité", "L’impartialité", "La loyauté"],
    answer: "La disponibilité",
    explanation: "L’article R. 434-30 impose la disponibilité du policier.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-2 ?",
    options: [
      "Cadre général de l'action de la police nationale et de la gendarmerie nationale",
      "Nature du code de déontologie et champ d'application",
      "Principe hiérarchique",
    ],
    answer:
        "Cadre général de l'action de la police nationale et de la gendarmerie nationale",
    explanation:
        "R. 434-2 fixe le cadre général : missions, respect des lois, loyauté, honneur, dévouement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article définit le cadre général de l'action de la police nationale et de la gendarmerie nationale ?",
    options: ["Article R. 434-2", "Article R. 434-3", "Article R. 434-4"],
    answer: "Article R. 434-2",
    explanation: "Le cadre général est posé à l’article R. 434-2.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-3 ?",
    options: [
      "Nature du code de déontologie et champ d'application",
      "Principe hiérarchique",
      "Protection fonctionnelle",
    ],
    answer: "Nature du code de déontologie et champ d'application",
    explanation:
        "R. 434-3 précise l’origine des règles et le champ d’application (policier/gendarme).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article précise la nature du code de déontologie et son champ d’application ?",
    options: ["Article R. 434-3", "Article R. 434-2", "Article R. 434-7"],
    answer: "Article R. 434-3",
    explanation:
        "La nature et le champ d’application sont définis à l’article R. 434-3.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-4 ?",
    options: [
      "Principe hiérarchique",
      "Obéissance",
      "Obligations incombant à l'autorité hiérarchique",
    ],
    answer: "Principe hiérarchique",
    explanation:
        "R. 434-4 traite des décisions, ordres, voie hiérarchique et obligation de rendre compte.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article impose le passage des ordres par la voie hiérarchique (sauf urgence) ?",
    options: ["Article R. 434-4", "Article R. 434-5", "Article R. 434-6"],
    answer: "Article R. 434-4",
    explanation:
        "Le principe hiérarchique et la voie hiérarchique sont posés par R. 434-4.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-5 ?",
    options: [
      "Obéissance",
      "Protection fonctionnelle",
      "Secret et discrétion professionnels",
    ],
    answer: "Obéissance",
    explanation:
        "R. 434-5 encadre l’obéissance et l’exception de l’ordre manifestement illégal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article encadre l’exécution des ordres et l’exception de l’ordre manifestement illégal compromettant gravement un intérêt public ?",
    options: ["Article R. 434-5", "Article R. 434-4", "Article R. 434-7"],
    answer: "Article R. 434-5",
    explanation: "C’est précisément l’objet de l’article R. 434-5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-6 ?",
    options: [
      "Obligations incombant à l'autorité hiérarchique",
      "Contrôle hiérarchique et des inspections",
      "Crédit et renom de l’institution",
    ],
    answer: "Obligations incombant à l'autorité hiérarchique",
    explanation:
        "R. 434-6 : intégrité physique, santé, condition et formation adaptée des subordonnés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article impose au supérieur hiérarchique de veiller à la santé physique et mentale des subordonnés ?",
    options: ["Article R. 434-6", "Article R. 434-7", "Article R. 434-4"],
    answer: "Article R. 434-6",
    explanation:
        "La protection de l’intégrité/santé des subordonnés est à l’article R. 434-6.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-7 ?",
    options: [
      "Protection fonctionnelle",
      "Contrôle des pairs",
      "Aide aux victimes",
    ],
    answer: "Protection fonctionnelle",
    explanation:
        "R. 434-7 : défense/protection de l’État contre attaques et protection juridique si pas de faute personnelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article prévoit que l’État défend le policier/gendarme et peut étendre la protection à ses proches ?",
    options: ["Article R. 434-7", "Article R. 434-6", "Article R. 434-23"],
    answer: "Article R. 434-7",
    explanation: "Protection fonctionnelle : article R. 434-7.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-8 ?",
    options: ["Secret et discrétion professionnels", "Probité", "Discernement"],
    answer: "Secret et discrétion professionnels",
    explanation:
        "R. 434-8 : ne pas divulguer à qui n’a ni le droit ni le besoin d’en connaître.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article interdit de divulguer des informations à une personne qui n’a ni le droit ni le besoin d’en connaître ?",
    options: ["Article R. 434-8", "Article R. 434-9", "Article R. 434-21"],
    answer: "Article R. 434-8",
    explanation: "Secret et discrétion professionnels : R. 434-8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-9 ?",
    options: ["Probité", "Impartialité", "Crédit et renom"],
    answer: "Probité",
    explanation:
        "R. 434-9 : pas d’avantage perso, pas de cadeaux liés aux fonctions, pas de favoritisme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article interdit d’accepter un avantage ou un présent lié aux fonctions (directement ou indirectement) ?",
    options: ["Article R. 434-9", "Article R. 434-12", "Article R. 434-11"],
    answer: "Article R. 434-9",
    explanation:
        "Interdiction d’accepter un présent lié aux fonctions : probité (R. 434-9).",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-10 ?",
    options: ["Discernement", "Aide aux victimes", "Emploi de la force"],
    answer: "Discernement",
    explanation:
        "R. 434-10 : analyser risques/menaces/délais pour choisir la meilleure réponse légale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article impose de choisir la meilleure réponse légale selon les risques/menaces et les délais pour agir ?",
    options: ["Article R. 434-10", "Article R. 434-18", "Article R. 434-16"],
    answer: "Article R. 434-10",
    explanation:
        "C’est exactement la définition du discernement : article R. 434-10.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-11 ?",
    options: ["Impartialité", "Probité", "Relation avec la population"],
    answer: "Impartialité",
    explanation:
        "R. 434-11 : même attention/respect, pas de distinction discriminatoire (réf. 225-1 CP).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article renvoie aux discriminations de l’article 225-1 du code pénal ?",
    options: ["Article R. 434-11", "Article R. 434-16", "Article R. 434-20"],
    answer: "Article R. 434-11",
    explanation:
        "Le renvoi explicite à 225-1 CP est dans l’article R. 434-11 (impartialité).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-12 ?",
    options: [
      "Crédit et renom de la police nationale et de la gendarmerie nationale",
      "Non cumul d'activité",
      "Disponibilité",
    ],
    answer:
        "Crédit et renom de la police nationale et de la gendarmerie nationale",
    explanation:
        "R. 434-12 : dignité en toute circonstance, y compris réseaux sociaux, pas nuire à l’institution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article vise explicitement les réseaux sociaux et l’interdiction de nuire à la réputation de l’institution ?",
    options: ["Article R. 434-12", "Article R. 434-29", "Article R. 434-8"],
    answer: "Article R. 434-12",
    explanation:
        "Les réseaux de communication électronique sociaux sont cités à l’article R. 434-12.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-13 ?",
    options: ["Non cumul d'activité", "Port de la tenue", "Contrôle des pairs"],
    answer: "Non cumul d'activité",
    explanation:
        "R. 434-13 : se consacre à la mission ; activité privée lucrative seulement dans les cas/conditions prévues.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article pose le principe de non cumul d’activité (sauf conditions autorisées) ?",
    options: ["Article R. 434-13", "Article R. 434-30", "Article R. 434-25"],
    answer: "Article R. 434-13",
    explanation: "Le non cumul d’activité est l’objet de l’article R. 434-13.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-14 ?",
    options: [
      "Relation avec la population",
      "Contrôles d'identité",
      "Assistance aux personnes",
    ],
    answer: "Relation avec la population",
    explanation: "R. 434-14 : courtoisie, vouvoiement, dignité, exemplarité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article impose l’usage du vouvoiement dans la relation avec la population ?",
    options: ["Article R. 434-14", "Article R. 434-16", "Article R. 434-20"],
    answer: "Article R. 434-14",
    explanation:
        "Le vouvoiement est explicitement prévu par l’article R. 434-14.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-15 ?",
    options: ["Port de la tenue", "Emploi de la force", "Aide aux victimes"],
    answer: "Port de la tenue",
    explanation:
        "R. 434-15 : exercice en uniforme (dérogations possibles) et identification individuelle sauf exceptions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article rappelle le principe : exercice en uniforme et obligation d’identification individuelle (sauf exceptions) ?",
    options: ["Article R. 434-15", "Article R. 434-14", "Article R. 434-23"],
    answer: "Article R. 434-15",
    explanation: "Port de la tenue + identification : article R. 434-15.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-16 ?",
    options: [
      "Contrôles d'identité",
      "Traitement des sources humaines",
      "Usage des armes",
    ],
    answer: "Contrôles d'identité",
    explanation:
        "R. 434-16 : pas de ciblage sur caractéristiques physiques/signes distinctifs sans signalement précis ; palpation non systématique, dignité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article précise que la palpation de sécurité est exclusivement une mesure de sûreté et ne doit pas être systématique ?",
    options: ["Article R. 434-16", "Article R. 434-17", "Article R. 434-18"],
    answer: "Article R. 434-16",
    explanation:
        "Le cadre de la palpation de sécurité est dans l’article R. 434-16.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-17 ?",
    options: [
      "Protection et respect des personnes privées de liberté",
      "Emploi de la force",
      "Assistance aux personnes",
    ],
    answer: "Protection et respect des personnes privées de liberté",
    explanation:
        "R. 434-17 encadre la protection, la dignité, les fouilles, et l’usage des menottes/entraves.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article interdit le dévêtement intégral sauf cas prévus (référence à l’article 63-7 CPP dans le texte) ?",
    options: ["Article R. 434-17", "Article R. 434-16", "Article R. 434-18"],
    answer: "Article R. 434-17",
    explanation: "Le passage sur le dévêtement intégral figure dans R. 434-17.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article encadre l’usage des menottes/entraves (justifié si danger ou risque de fuite) ?",
    options: ["Article R. 434-17", "Article R. 434-18", "Article R. 434-19"],
    answer: "Article R. 434-17",
    explanation:
        "Menottes/entraves : R. 434-17 (danger pour autrui/soi ou risque de fuite).",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-18 ?",
    options: ["Emploi de la force", "Aide aux victimes", "Usage des fichiers"],
    answer: "Emploi de la force",
    explanation:
        "R. 434-18 : force dans le cadre de la loi, seulement si nécessaire, proportionnée ; armes en cas d’absolue nécessité selon statut.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article pose les principes « nécessité » et « proportionnalité » dans l’emploi de la force ?",
    options: ["Article R. 434-18", "Article R. 434-10", "Article R. 434-16"],
    answer: "Article R. 434-18",
    explanation: "Nécessité + proportionnalité pour la force : R. 434-18.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article indique que l’usage des armes n’a lieu qu’en cas d’absolue nécessité (dans le cadre applicable au statut) ?",
    options: ["Article R. 434-18", "Article R. 434-19", "Article R. 434-23"],
    answer: "Article R. 434-18",
    explanation:
        "La mention « absolue nécessité » pour les armes est dans R. 434-18.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-19 ?",
    options: [
      "Assistance aux personnes",
      "Aide aux victimes",
      "Traitement des sources humaines",
    ],
    answer: "Assistance aux personnes",
    explanation:
        "R. 434-19 : intervenir, même hors service, avec les moyens disponibles, pour porter assistance aux personnes en danger.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article prévoit le devoir d’intervention même hors service, lorsque les circonstances le requièrent ?",
    options: ["Article R. 434-19", "Article R. 434-20", "Article R. 434-14"],
    answer: "Article R. 434-19",
    explanation:
        "Le devoir d’assistance/intervention même hors service : R. 434-19.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-20 ?",
    options: [
      "Aide aux victimes",
      "Contrôles d'identité",
      "Contrôle des pairs",
    ],
    answer: "Aide aux victimes",
    explanation:
        "R. 434-20 : attention particulière aux victimes, qualité de prise en charge, confidentialité des propos.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article impose de garantir la confidentialité des propos et déclarations des victimes ?",
    options: ["Article R. 434-20", "Article R. 434-8", "Article R. 434-21"],
    answer: "Article R. 434-20",
    explanation:
        "La confidentialité des victimes pendant la procédure est visée par R. 434-20.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-21 ?",
    options: [
      "Usage des traitements de données à caractère personnel",
      "Traitement des sources humaines",
      "Principe hiérarchique",
    ],
    answer: "Usage des traitements de données à caractère personnel",
    explanation:
        "R. 434-21 : respect vie privée + règles de création/utilisation des fichiers, finalités, règles propres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article encadre l’alimentation et la consultation des fichiers dans le strict respect de leurs finalités ?",
    options: ["Article R. 434-21", "Article R. 434-8", "Article R. 434-22"],
    answer: "Article R. 434-21",
    explanation: "Finalités et règles des traitements : R. 434-21.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-22 ?",
    options: [
      "Traitement des sources humaines",
      "Contrôle hiérarchique et des inspections",
      "Port de la tenue",
    ],
    answer: "Traitement des sources humaines",
    explanation:
        "R. 434-22 : recours à des informateurs selon les règles d’exécution du service propres à chaque force.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article évoque le recours à des informateurs (sources humaines) avec obligation d’appliquer les règles en vigueur ?",
    options: ["Article R. 434-22", "Article R. 434-21", "Article R. 434-23"],
    answer: "Article R. 434-22",
    explanation: "Informateurs/sources humaines : article R. 434-22.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-23 ?",
    options: [
      "Principes du contrôle",
      "Le Défenseur des droits",
      "Contrôle des pairs",
    ],
    answer: "Principes du contrôle",
    explanation:
        "R. 434-23 : police/gendarmerie soumises aux contrôles prévus par la loi et conventions ; contrôle judiciaire en matière judiciaire (CPP).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article précise que, pour les missions judiciaires, police et gendarmerie sont soumises au contrôle de l’autorité judiciaire (CPP) ?",
    options: ["Article R. 434-23", "Article R. 434-24", "Article R. 434-25"],
    answer: "Article R. 434-23",
    explanation: "Contrôle de l’autorité judiciaire : R. 434-23.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-24 ?",
    options: [
      "Le Défenseur des droits",
      "Principes du contrôle",
      "Sanction des manquements déontologiques",
    ],
    answer: "Le Défenseur des droits",
    explanation:
        "R. 434-24 : contrôle du Défenseur des droits, possible saisine disciplinaire, communication d’infos, convocations, assistance.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article impose de communiquer au Défenseur des droits les informations/pièces utiles et de déférer à ses convocations ?",
    options: ["Article R. 434-24", "Article R. 434-23", "Article R. 434-25"],
    answer: "Article R. 434-24",
    explanation:
        "Coopération avec le Défenseur des droits : article R. 434-24.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-25 ?",
    options: [
      "Contrôle hiérarchique et des inspections",
      "Contrôle des pairs",
      "Disponibilité",
    ],
    answer: "Contrôle hiérarchique et des inspections",
    explanation:
        "R. 434-25 : contrôle de la hiérarchie + inspections ; obligation de faciliter contrôles/inspections.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article prévoit que le policier/gendarme facilite en toute circonstance les opérations de contrôle et d’inspection ?",
    options: ["Article R. 434-25", "Article R. 434-26", "Article R. 434-27"],
    answer: "Article R. 434-25",
    explanation: "Faciliter contrôles/inspections : R. 434-25.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-26 ?",
    options: [
      "Contrôle des pairs",
      "Sanction des manquements déontologiques",
      "Devoir de réserve (police)",
    ],
    answer: "Contrôle des pairs",
    explanation:
        "R. 434-26 : policiers et gendarmes veillent individuellement et collectivement au respect du code.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article rappelle que les pairs sont dépositaires du code et doivent veiller à son respect ?",
    options: ["Article R. 434-26", "Article R. 434-25", "Article R. 434-27"],
    answer: "Article R. 434-26",
    explanation: "Contrôle des pairs : article R. 434-26.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-27 ?",
    options: [
      "Sanction des manquements déontologiques",
      "Principes du contrôle",
      "Non cumul d'activité",
    ],
    answer: "Sanction des manquements déontologiques",
    explanation:
        "R. 434-27 : tout manquement expose à sanction disciplinaire, indépendamment du pénal le cas échéant.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article prévoit sanction disciplinaire pour manquement au code, sans exclure les sanctions pénales ?",
    options: ["Article R. 434-27", "Article R. 434-23", "Article R. 434-13"],
    answer: "Article R. 434-27",
    explanation: "Sanction disciplinaire + pénal possible : article R. 434-27.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "À quoi correspond l’article R. 434-28 (dispositions propres à la police nationale) ?",
    options: [
      "Considération, respect et devoir de mémoire",
      "Devoir de réserve (police)",
      "Disponibilité (police)",
    ],
    answer: "Considération, respect et devoir de mémoire",
    explanation:
        "R. 434-28 : risques/sujétions méritent respect ; le policier honore la mémoire des morts en mission.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article demande d’honorer la mémoire de ceux qui ont péri dans l’exercice de missions de sécurité intérieure ?",
    options: ["Article R. 434-28", "Article R. 434-31", "Article R. 434-12"],
    answer: "Article R. 434-28",
    explanation: "Devoir de mémoire (police nationale) : article R. 434-28.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-29 (police nationale) ?",
    options: ["Devoir de réserve", "Disponibilité", "Principe hiérarchique"],
    answer: "Devoir de réserve",
    explanation:
        "R. 434-29 : neutralité ; pas d’expression de convictions en service ; hors service liberté dans les limites réserve/loyauté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article interdit au policier, en service, toute expression/manif de convictions religieuses, politiques ou philosophiques ?",
    options: ["Article R. 434-29", "Article R. 434-12", "Article R. 434-11"],
    answer: "Article R. 434-29",
    explanation: "Neutralité en service (police) : article R. 434-29.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-30 (police nationale) ?",
    options: ["Disponibilité", "Non cumul d'activité", "Port de la tenue"],
    answer: "Disponibilité",
    explanation:
        "R. 434-30 : le policier est disponible à tout moment pour les nécessités du service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article impose d’être joignable/rappelable au service (disponibilité) ?",
    options: ["Article R. 434-30", "Article R. 434-13", "Article R. 434-4"],
    answer: "Article R. 434-30",
    explanation: "Disponibilité (police) : article R. 434-30.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-31 (gendarmerie nationale) ?",
    options: [
      "L'état de militaire, le service de la Nation et le devoir de mémoire",
      "Devoir de réserve (gendarmerie)",
      "Autres textes afférents à la déontologie (gendarmerie)",
    ],
    answer:
        "L'état de militaire, le service de la Nation et le devoir de mémoire",
    explanation:
        "R. 434-31 : état militaire (sacrifice, discipline, disponibilité, loyalisme, neutralité) + honneurs/mémoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article énonce les exigences de l’état militaire (discipline, disponibilité, neutralité, esprit de sacrifice, etc.) ?",
    options: ["Article R. 434-31", "Article R. 434-32", "Article R. 434-33"],
    answer: "Article R. 434-31",
    explanation:
        "Les exigences liées à l’état militaire sont détaillées dans R. 434-31.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-32 (gendarmerie nationale) ?",
    options: [
      "Devoir de réserve",
      "Considération, respect et devoir de mémoire",
      "Contrôle des inspections",
    ],
    answer: "Devoir de réserve",
    explanation:
        "R. 434-32 : opinions/croyances seulement hors service et avec réserve exigée par l’état militaire (code de la défense).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article encadre l’expression d’opinions/croyances des militaires de la gendarmerie (hors service, avec réserve) ?",
    options: ["Article R. 434-32", "Article R. 434-31", "Article R. 434-29"],
    answer: "Article R. 434-32",
    explanation: "Devoir de réserve gendarmerie : article R. 434-32.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question: "À quoi correspond l’article R. 434-33 (gendarmerie nationale) ?",
    options: [
      "Autres textes afférents à la déontologie des militaires de la gendarmerie nationale",
      "Sanction des manquements déontologiques",
      "Relation avec la population",
    ],
    answer:
        "Autres textes afférents à la déontologie des militaires de la gendarmerie nationale",
    explanation:
        "R. 434-33 : renvoi au code de la défense et aux sujétions spécifiques du métier de gendarme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles (Code CSI)",
    question:
        "Quel article rappelle que le gendarme est soumis au statut général des militaires (code de la défense) + sujétions spécifiques ?",
    options: ["Article R. 434-33", "Article R. 434-27", "Article R. 434-23"],
    answer: "Article R. 434-33",
    explanation:
        "Renvoi aux textes afférents (code de la défense) : R. 434-33.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-2 ?",
    options: [
      "Cadre général de l’action de la police nationale et de la gendarmerie",
      "Principe hiérarchique",
      "Relation avec la population",
    ],
    answer:
        "Cadre général de l’action de la police nationale et de la gendarmerie",
    explanation:
        "R. 434-2 définit les missions générales : défense des institutions, respect des lois, maintien de l’ordre, protection des personnes et des biens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article précise que policiers et gendarmes exercent avec loyauté, honneur et dévouement ?",
    options: ["Article R. 434-2", "Article R. 434-4", "Article R. 434-11"],
    answer: "Article R. 434-2",
    explanation:
        "Les notions de loyauté, honneur et dévouement figurent explicitement à l’article R. 434-2.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-3 ?",
    options: [
      "Nature du code de déontologie et champ d’application",
      "Obéissance",
      "Protection fonctionnelle",
    ],
    answer: "Nature du code de déontologie et champ d’application",
    explanation:
        "R. 434-3 précise les fondements juridiques du code et à qui il s’applique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article précise que le code s’applique pendant et en dehors du service ?",
    options: ["Article R. 434-3", "Article R. 434-12", "Article R. 434-30"],
    answer: "Article R. 434-3",
    explanation:
        "Le champ d’application du code (service et hors service) est posé à l’article R. 434-3.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-4 ?",
    options: ["Principe hiérarchique", "Obéissance", "Contrôle hiérarchique"],
    answer: "Principe hiérarchique",
    explanation:
        "R. 434-4 définit la responsabilité de l’autorité hiérarchique et l’obligation de compte-rendu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article impose de rendre compte de tout fait pouvant entraîner une convocation judiciaire ou administrative ?",
    options: ["Article R. 434-4", "Article R. 434-5", "Article R. 434-7"],
    answer: "Article R. 434-4",
    explanation:
        "L’obligation d’informer la hiérarchie figure au II de l’article R. 434-4.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-5 ?",
    options: ["Obéissance", "Probité", "Discernement"],
    answer: "Obéissance",
    explanation:
        "R. 434-5 encadre l’obéissance aux ordres et l’exception de l’ordre manifestement illégal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article autorise le refus d’exécuter un ordre manifestement illégal compromettant gravement un intérêt public ?",
    options: ["Article R. 434-5", "Article R. 434-6", "Article R. 434-27"],
    answer: "Article R. 434-5",
    explanation: "L’exception à l’obéissance figure à l’article R. 434-5.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-6 ?",
    options: [
      "Obligations incombant à l’autorité hiérarchique",
      "Protection fonctionnelle",
      "Principe hiérarchique",
    ],
    answer: "Obligations incombant à l’autorité hiérarchique",
    explanation:
        "R. 434-6 impose au supérieur hiérarchique de veiller à la santé, la sécurité et la formation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article impose à la hiérarchie de veiller à la santé physique et mentale des agents ?",
    options: ["Article R. 434-6", "Article R. 434-7", "Article R. 434-19"],
    answer: "Article R. 434-6",
    explanation:
        "La protection de l’intégrité physique et mentale figure à l’article R. 434-6.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-7 ?",
    options: [
      "Protection fonctionnelle",
      "Secret professionnel",
      "Aide aux victimes",
    ],
    answer: "Protection fonctionnelle",
    explanation:
        "R. 434-7 prévoit la défense et l’assistance de l’État envers le policier ou le gendarme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article prévoit la protection juridique de l’agent poursuivi sans faute personnelle ?",
    options: ["Article R. 434-7", "Article R. 434-27", "Article R. 434-23"],
    answer: "Article R. 434-7",
    explanation: "La protection juridique relève de l’article R. 434-7.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-8 ?",
    options: ["Secret et discrétion professionnels", "Probité", "Impartialité"],
    answer: "Secret et discrétion professionnels",
    explanation:
        "R. 434-8 interdit toute divulgation d’informations non autorisée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article interdit la divulgation d’informations même à des proches ?",
    options: ["Article R. 434-8", "Article R. 434-9", "Article R. 434-21"],
    answer: "Article R. 434-8",
    explanation:
        "Le secret professionnel s’applique à toute personne non habilitée, y compris les proches.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-9 ?",
    options: ["Probité", "Discernement", "Impartialité"],
    answer: "Probité",
    explanation:
        "R. 434-9 interdit tout avantage personnel, cadeau ou abus de fonction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article interdit l’acceptation de cadeaux ou avantages liés à la fonction ?",
    options: ["Article R. 434-9", "Article R. 434-12", "Article R. 434-13"],
    answer: "Article R. 434-9",
    explanation: "L’interdiction des avantages figure à l’article R. 434-9.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-10 ?",
    options: ["Discernement", "Emploi de la force", "Assistance aux personnes"],
    answer: "Discernement",
    explanation:
        "R. 434-10 impose l’analyse des situations et l’adaptation de la réponse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article impose d’adapter son action aux risques, délais et contexte ?",
    options: ["Article R. 434-10", "Article R. 434-18", "Article R. 434-16"],
    answer: "Article R. 434-10",
    explanation: "Le discernement est défini à l’article R. 434-10.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article impose au policier d’être disponible pour le service ?",
    options: ["Article R. 434-30", "Article R. 434-29", "Article R. 434-12"],
    answer: "Article R. 434-30",
    explanation: "La disponibilité est prévue par l’article R. 434-30.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Fondamentaux",
    question: "La loyauté du policier s’exerce envers :",
    options: [
      "Les institutions de la République",
      "Ses collègues uniquement",
      "Le public exclusivement",
    ],
    answer: "Les institutions de la République",
    explanation: "La loyauté est un pilier du service public.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-11 ?",
    options: ["Impartialité", "Probité", "Neutralité"],
    answer: "Impartialité",
    explanation:
        "L’article R. 434-11 impose l’impartialité et l’absence de discrimination.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article interdit toute discrimination fondée sur l’origine, le sexe, la religion ou l’orientation sexuelle ?",
    options: ["Article R. 434-11", "Article R. 434-12", "Article R. 434-29"],
    answer: "Article R. 434-11",
    explanation: "Les discriminations sont interdites par l’article R. 434-11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-12 ?",
    options: [
      "Crédit et renom de l’institution",
      "Devoir de réserve",
      "Neutralité",
    ],
    answer: "Crédit et renom de l’institution",
    explanation:
        "L’article R. 434-12 impose une exemplarité permanente, y compris hors service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article impose de ne porter atteinte ni à l’image ni à la réputation de la police ou de la gendarmerie ?",
    options: ["Article R. 434-12", "Article R. 434-29", "Article R. 434-30"],
    answer: "Article R. 434-12",
    explanation:
        "La protection du crédit et du renom figure à l’article R. 434-12.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "L’utilisation inappropriée des réseaux sociaux relève principalement de quel article ?",
    options: ["Article R. 434-12", "Article R. 434-8", "Article R. 434-21"],
    answer: "Article R. 434-12",
    explanation:
        "Les réseaux sociaux peuvent porter atteinte au crédit de l’institution (R. 434-12).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-13 ?",
    options: ["Non-cumul d’activités", "Disponibilité", "Probité"],
    answer: "Non-cumul d’activités",
    explanation:
        "L’article R. 434-13 impose la priorité exclusive donnée à la mission.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article interdit l’exercice d’une activité privée lucrative sans autorisation ?",
    options: ["Article R. 434-13", "Article R. 434-30", "Article R. 434-9"],
    answer: "Article R. 434-13",
    explanation:
        "Le non-cumul d’activités est encadré par l’article R. 434-13.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-14 ?",
    options: [
      "Relation avec la population",
      "Aide aux victimes",
      "Impartialité",
    ],
    answer: "Relation avec la population",
    explanation:
        "L’article R. 434-14 impose courtoisie, vouvoiement et respect.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article impose l’usage du vouvoiement dans la relation avec la population ?",
    options: ["Article R. 434-14", "Article R. 434-11", "Article R. 434-16"],
    answer: "Article R. 434-14",
    explanation:
        "Le vouvoiement est explicitement prévu à l’article R. 434-14.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-15 ?",
    options: [
      "Port de la tenue",
      "Identification individuelle",
      "Disponibilité",
    ],
    answer: "Port de la tenue",
    explanation:
        "L’article R. 434-15 traite du port de l’uniforme et de l’identification.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article rend obligatoire l’identification individuelle visible du policier ?",
    options: ["Article R. 434-15", "Article R. 434-25", "Article R. 434-16"],
    answer: "Article R. 434-15",
    explanation:
        "L’identification individuelle est prévue à l’article R. 434-15.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-16 ?",
    options: [
      "Contrôles d’identité",
      "Emploi de la force",
      "Protection des personnes privées de liberté",
    ],
    answer: "Contrôles d’identité",
    explanation:
        "L’article R. 434-16 encadre les contrôles d’identité et les palpations.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article interdit de fonder un contrôle d’identité sur l’apparence physique seule ?",
    options: ["Article R. 434-16", "Article R. 434-11", "Article R. 434-10"],
    answer: "Article R. 434-16",
    explanation:
        "Les contrôles discriminatoires sont interdits par l’article R. 434-16.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-17 ?",
    options: [
      "Protection et respect des personnes privées de liberté",
      "Emploi de la force",
      "Aide aux victimes",
    ],
    answer: "Protection et respect des personnes privées de liberté",
    explanation:
        "L’article R. 434-17 protège la dignité des personnes privées de liberté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article encadre strictement le menottage et interdit toute mesure humiliante ?",
    options: ["Article R. 434-17", "Article R. 434-18", "Article R. 434-16"],
    answer: "Article R. 434-17",
    explanation: "Les conditions du menottage figurent à l’article R. 434-17.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-18 ?",
    options: [
      "Emploi de la force",
      "Usage des armes",
      "Assistance aux personnes",
    ],
    answer: "Emploi de la force",
    explanation:
        "L’article R. 434-18 impose nécessité, proportionnalité et absolue nécessité pour les armes.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-19 ?",
    options: [
      "Assistance aux personnes",
      "Aide aux victimes",
      "Emploi de la force",
    ],
    answer: "Assistance aux personnes",
    explanation:
        "L’article R. 434-19 impose au policier ou gendarme de porter assistance aux personnes en danger.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article impose d’intervenir même hors service pour porter assistance à une personne en danger ?",
    options: ["Article R. 434-19", "Article R. 434-14", "Article R. 434-20"],
    answer: "Article R. 434-19",
    explanation:
        "Le devoir d’assistance, y compris hors service, figure à l’article R. 434-19.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-20 ?",
    options: [
      "Aide aux victimes",
      "Assistance aux personnes",
      "Relation avec la population",
    ],
    answer: "Aide aux victimes",
    explanation:
        "L’article R. 434-20 impose une attention particulière et une prise en charge de qualité des victimes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article impose de garantir la confidentialité des propos des victimes ?",
    options: ["Article R. 434-20", "Article R. 434-8", "Article R. 434-21"],
    answer: "Article R. 434-20",
    explanation:
        "La confidentialité des propos des victimes est prévue à l’article R. 434-20.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Le refus de prendre une plainte constitue un manquement principalement à quel article ?",
    options: ["Article R. 434-20", "Article R. 434-14", "Article R. 434-19"],
    answer: "Article R. 434-20",
    explanation:
        "L’aide aux victimes inclut l’obligation de recevoir les plaintes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-21 ?",
    options: [
      "Usage des traitements de données à caractère personnel",
      "Secret professionnel",
      "Contrôle des pairs",
    ],
    answer: "Usage des traitements de données à caractère personnel",
    explanation:
        "L’article R. 434-21 encadre strictement l’usage des fichiers de police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article interdit la consultation d’un fichier de police par curiosité personnelle ?",
    options: ["Article R. 434-21", "Article R. 434-9", "Article R. 434-8"],
    answer: "Article R. 434-21",
    explanation:
        "Les fichiers ne peuvent être consultés que pour des nécessités de service.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Le partage d’identifiants d’accès aux applications constitue un manquement à quel article ?",
    options: ["Article R. 434-21", "Article R. 434-8", "Article R. 434-12"],
    answer: "Article R. 434-21",
    explanation:
        "La protection des données personnelles est imposée par l’article R. 434-21.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-22 ?",
    options: [
      "Traitement des sources humaines",
      "Aide aux victimes",
      "Contrôle hiérarchique",
    ],
    answer: "Traitement des sources humaines",
    explanation: "L’article R. 434-22 encadre le recours aux informateurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article impose prudence et respect des règles lors du recours à des informateurs ?",
    options: ["Article R. 434-22", "Article R. 434-9", "Article R. 434-5"],
    answer: "Article R. 434-22",
    explanation:
        "Le recours aux sources humaines est strictement encadré par l’article R. 434-22.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-23 ?",
    options: [
      "Principes du contrôle",
      "Contrôle hiérarchique",
      "Sanction disciplinaire",
    ],
    answer: "Principes du contrôle",
    explanation:
        "L’article R. 434-23 pose les principes généraux du contrôle de l’action policière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article rappelle que la police et la gendarmerie sont soumises au contrôle de l’autorité judiciaire ?",
    options: ["Article R. 434-23", "Article R. 434-25", "Article R. 434-24"],
    answer: "Article R. 434-23",
    explanation:
        "Le contrôle par l’autorité judiciaire est rappelé à l’article R. 434-23.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-24 ?",
    options: [
      "Le Défenseur des droits",
      "Contrôle des inspections",
      "Contrôle des pairs",
    ],
    answer: "Le Défenseur des droits",
    explanation:
        "L’article R. 434-24 traite du contrôle exercé par le Défenseur des droits.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article impose au policier ou gendarme de répondre aux convocations du Défenseur des droits ?",
    options: ["Article R. 434-24", "Article R. 434-25", "Article R. 434-26"],
    answer: "Article R. 434-24",
    explanation:
        "La coopération avec le Défenseur des droits est prévue à l’article R. 434-24.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-25 ?",
    options: [
      "Contrôle hiérarchique et des inspections",
      "Contrôle des pairs",
      "Sanction disciplinaire",
    ],
    answer: "Contrôle hiérarchique et des inspections",
    explanation:
        "L’article R. 434-25 encadre le contrôle interne et les inspections.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-26 ?",
    options: [
      "Contrôle des pairs",
      "Contrôle hiérarchique",
      "Sanction disciplinaire",
    ],
    answer: "Contrôle des pairs",
    explanation:
        "L’article R. 434-26 impose aux policiers et gendarmes de veiller collectivement au respect du code.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article rappelle que le silence face à un manquement déontologique vaut consentement ?",
    options: ["Article R. 434-26", "Article R. 434-27", "Article R. 434-25"],
    answer: "Article R. 434-26",
    explanation:
        "Le contrôle des pairs est explicitement prévu à l’article R. 434-26.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-27 ?",
    options: [
      "Sanction des manquements déontologiques",
      "Contrôle des pairs",
      "Protection fonctionnelle",
    ],
    answer: "Sanction des manquements déontologiques",
    explanation:
        "L’article R. 434-27 prévoit les sanctions disciplinaires en cas de manquement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article précise qu’un manquement déontologique peut entraîner une sanction disciplinaire indépendamment des poursuites pénales ?",
    options: ["Article R. 434-27", "Article R. 434-23", "Article R. 434-7"],
    answer: "Article R. 434-27",
    explanation:
        "Les sanctions disciplinaires sont prévues par l’article R. 434-27.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-28 ?",
    options: [
      "Considération, respect et devoir de mémoire",
      "Devoir de réserve",
      "Disponibilité",
    ],
    answer: "Considération, respect et devoir de mémoire",
    explanation:
        "L’article R. 434-28 rend hommage aux policiers morts en service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article impose d’honorer la mémoire des policiers décédés dans l’exercice de leurs fonctions ?",
    options: ["Article R. 434-28", "Article R. 434-12", "Article R. 434-29"],
    answer: "Article R. 434-28",
    explanation: "Le devoir de mémoire est défini à l’article R. 434-28.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-29 ?",
    options: ["Devoir de réserve", "Neutralité", "Disponibilité"],
    answer: "Devoir de réserve",
    explanation:
        "L’article R. 434-29 encadre l’expression des opinions du policier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article interdit l’expression de convictions religieuses ou politiques dans l’exercice des fonctions ?",
    options: ["Article R. 434-29", "Article R. 434-11", "Article R. 434-12"],
    answer: "Article R. 434-29",
    explanation:
        "Le devoir de réserve et de neutralité figure à l’article R. 434-29.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "La publication de propos critiques sur les réseaux sociaux concernant l’institution relève principalement de quel article ?",
    options: ["Article R. 434-29", "Article R. 434-8", "Article R. 434-21"],
    answer: "Article R. 434-29",
    explanation:
        "Les propos publics sont encadrés par le devoir de réserve (R. 434-29).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-30 ?",
    options: [
      "Disponibilité",
      "Non-cumul d’activités",
      "Protection fonctionnelle",
    ],
    answer: "Disponibilité",
    explanation:
        "L’article R. 434-30 impose au policier d’être joignable et mobilisable.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article impose de pouvoir être rappelé au service à tout moment ?",
    options: ["Article R. 434-30", "Article R. 434-13", "Article R. 434-6"],
    answer: "Article R. 434-30",
    explanation:
        "L’obligation de disponibilité est définie à l’article R. 434-30.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Éteindre volontairement son téléphone pour éviter un rappel constitue un manquement à quel article ?",
    options: ["Article R. 434-30", "Article R. 434-13", "Article R. 434-4"],
    answer: "Article R. 434-30",
    explanation:
        "La disponibilité implique d’être joignable par la hiérarchie.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-31 ?",
    options: [
      "L’état de militaire, le service de la Nation et le devoir de mémoire",
      "Le devoir de réserve du policier",
      "La disponibilité",
    ],
    answer:
        "L’état de militaire, le service de la Nation et le devoir de mémoire",
    explanation:
        "L’article R. 434-31 rappelle les valeurs attachées à l’état militaire et au service de la Nation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article impose au militaire de la gendarmerie discipline, neutralité et esprit de sacrifice ?",
    options: ["Article R. 434-31", "Article R. 434-32", "Article R. 434-33"],
    answer: "Article R. 434-31",
    explanation: "Les valeurs militaires sont énoncées à l’article R. 434-31.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Le devoir de mémoire à l’égard des gendarmes morts en service est prévu par quel article ?",
    options: ["Article R. 434-31", "Article R. 434-28", "Article R. 434-33"],
    answer: "Article R. 434-31",
    explanation:
        "L’article R. 434-31 impose l’hommage aux militaires victimes du devoir.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-32 ?",
    options: [
      "Devoir de réserve du militaire de la gendarmerie",
      "Devoir de réserve du policier",
      "Contrôle des pairs",
    ],
    answer: "Devoir de réserve du militaire de la gendarmerie",
    explanation:
        "L’article R. 434-32 encadre l’expression des opinions du militaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article interdit au militaire de la gendarmerie d’exprimer ses opinions en faisant état de son statut ?",
    options: ["Article R. 434-32", "Article R. 434-29", "Article R. 434-31"],
    answer: "Article R. 434-32",
    explanation:
        "Le devoir de réserve militaire est fixé par l’article R. 434-32.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "L’expression d’opinions politiques en service par un gendarme constitue un manquement à quel article ?",
    options: ["Article R. 434-32", "Article R. 434-12", "Article R. 434-26"],
    answer: "Article R. 434-32",
    explanation:
        "La neutralité du militaire est imposée par l’article R. 434-32.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "À quoi correspond l’article R. 434-33 ?",
    options: [
      "Autres textes afférents à la déontologie des militaires de la gendarmerie",
      "Sanctions disciplinaires",
      "Contrôle hiérarchique",
    ],
    answer:
        "Autres textes afférents à la déontologie des militaires de la gendarmerie",
    explanation:
        "L’article R. 434-33 renvoie au code de la défense et aux sujétions militaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article rappelle que le gendarme est soumis au statut général des militaires ?",
    options: ["Article R. 434-33", "Article R. 434-31", "Article R. 434-27"],
    answer: "Article R. 434-33",
    explanation:
        "Le renvoi au code de la défense figure à l’article R. 434-33.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "L’obligation de logement par nécessité de service pour les gendarmes découle principalement de quel article ?",
    options: ["Article R. 434-33", "Article R. 434-30", "Article R. 434-31"],
    answer: "Article R. 434-33",
    explanation:
        "Les sujétions spécifiques au statut militaire sont rappelées à l’article R. 434-33.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Le refus d’exécuter intégralement une mission confiée à un gendarme relève prioritairement de quel article ?",
    options: ["Article R. 434-31", "Article R. 434-5", "Article R. 434-33"],
    answer: "Article R. 434-31",
    explanation:
        "L’esprit de service et l’obéissance liés à l’état militaire figurent à l’article R. 434-31.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article consacre le principe de probité du policier et du gendarme ?",
    options: ["Article R. 434-9", "Article R. 434-11", "Article R. 434-12"],
    answer: "Article R. 434-9",
    explanation: "La probité est définie à l’article R. 434-9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Refuser un cadeau offert en raison de sa fonction relève de quel article ?",
    options: ["Article R. 434-9", "Article R. 434-14", "Article R. 434-20"],
    answer: "Article R. 434-9",
    explanation:
        "L’interdiction des avantages et présents est prévue par l’article R. 434-9.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "La divulgation d’informations couvertes par le secret professionnel viole quel article ?",
    options: ["Article R. 434-8", "Article R. 434-21", "Article R. 434-12"],
    answer: "Article R. 434-8",
    explanation:
        "Le secret et la discrétion professionnels sont fixés à l’article R. 434-8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Publier sur les réseaux sociaux des éléments d’une enquête constitue un manquement à quel article ?",
    options: ["Article R. 434-8", "Article R. 434-12", "Article R. 434-21"],
    answer: "Article R. 434-8",
    explanation:
        "La divulgation d’informations couvertes par le secret est interdite par l’article R. 434-8.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article impose au policier et au gendarme d’agir avec discernement ?",
    options: ["Article R. 434-10", "Article R. 434-18", "Article R. 434-11"],
    answer: "Article R. 434-10",
    explanation: "Le discernement est prévu à l’article R. 434-10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Verbaliser sans tenir compte du contexte constitue un manquement à quel article ?",
    options: ["Article R. 434-10", "Article R. 434-11", "Article R. 434-14"],
    answer: "Article R. 434-10",
    explanation: "Le discernement impose d’adapter l’action aux circonstances.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Traiter différemment une personne en raison de ses opinions constitue un manquement à quel article ?",
    options: ["Article R. 434-11", "Article R. 434-9", "Article R. 434-12"],
    answer: "Article R. 434-11",
    explanation: "L’impartialité est imposée par l’article R. 434-11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "L’interdiction de toute discrimination est prévue par quel article ?",
    options: ["Article R. 434-11", "Article R. 434-14", "Article R. 434-20"],
    answer: "Article R. 434-11",
    explanation:
        "L’impartialité et l’égalité de traitement sont prévues à l’article R. 434-11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Tenir des propos injurieux en public porte atteinte à quel principe ?",
    options: ["Crédit et renom de l’institution", "Probité", "Disponibilité"],
    answer: "Crédit et renom de l’institution",
    explanation: "Le devoir d’exemplarité est prévu à l’article R. 434-12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article interdit les comportements portant atteinte à l’image de la police ou de la gendarmerie ?",
    options: ["Article R. 434-12", "Article R. 434-29", "Article R. 434-30"],
    answer: "Article R. 434-12",
    explanation:
        "Le crédit et le renom de l’institution sont protégés par l’article R. 434-12.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Exercer une activité lucrative non autorisée constitue un manquement à quel article ?",
    options: ["Article R. 434-13", "Article R. 434-30", "Article R. 434-9"],
    answer: "Article R. 434-13",
    explanation: "Le non-cumul d’activités est prévu à l’article R. 434-13.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article impose la courtoisie et le vouvoiement envers la population ?",
    options: ["Article R. 434-14", "Article R. 434-15", "Article R. 434-20"],
    answer: "Article R. 434-14",
    explanation:
        "La relation avec la population est encadrée par l’article R. 434-14.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "L’obligation de porter l’uniforme relève de quel article ?",
    options: ["Article R. 434-15", "Article R. 434-14", "Article R. 434-16"],
    answer: "Article R. 434-15",
    explanation: "Le port de la tenue est prévu par l’article R. 434-15.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Effectuer un contrôle d’identité fondé sur l’apparence constitue un manquement à quel article ?",
    options: ["Article R. 434-16", "Article R. 434-11", "Article R. 434-10"],
    answer: "Article R. 434-16",
    explanation:
        "Les contrôles d’identité sont strictement encadrés par l’article R. 434-16.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "L’usage des menottes uniquement en cas de nécessité relève de quel article ?",
    options: ["Article R. 434-17", "Article R. 434-18", "Article R. 434-16"],
    answer: "Article R. 434-17",
    explanation:
        "La protection des personnes privées de liberté est prévue à l’article R. 434-17.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article encadre la protection des personnes privées de liberté ?",
    options: ["Article R. 434-17", "Article R. 434-18", "Article R. 434-16"],
    answer: "Article R. 434-17",
    explanation:
        "La protection, la dignité et la sécurité des personnes privées de liberté sont prévues par l’article R. 434-17.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Menotter systématiquement une personne sans nécessité constitue un manquement à quel article ?",
    options: ["Article R. 434-17", "Article R. 434-18", "Article R. 434-10"],
    answer: "Article R. 434-17",
    explanation:
        "L’usage des menottes doit être justifié par la dangerosité ou le risque de fuite (article R. 434-17).",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "L’emploi de la force uniquement lorsque cela est nécessaire relève de quel article ?",
    options: ["Article R. 434-18", "Article R. 434-17", "Article R. 434-10"],
    answer: "Article R. 434-18",
    explanation: "L’usage de la force est encadré par l’article R. 434-18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel principe impose que la force soit proportionnée à la menace ?",
    options: ["Article R. 434-18", "Article R. 434-10", "Article R. 434-11"],
    answer: "Article R. 434-18",
    explanation:
        "La proportionnalité dans l’usage de la force est prévue à l’article R. 434-18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Intervenir spontanément pour porter secours, même hors service, relève de quel article ?",
    options: ["Article R. 434-19", "Article R. 434-14", "Article R. 434-20"],
    answer: "Article R. 434-19",
    explanation:
        "L’assistance aux personnes en danger est prévue par l’article R. 434-19.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Refuser d’intervenir face à une personne en danger constitue un manquement à quel article ?",
    options: ["Article R. 434-19", "Article R. 434-17", "Article R. 434-14"],
    answer: "Article R. 434-19",
    explanation:
        "L’assistance aux personnes est une obligation déontologique (article R. 434-19).",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "La prise en charge attentive et confidentielle des victimes relève de quel article ?",
    options: ["Article R. 434-20", "Article R. 434-14", "Article R. 434-21"],
    answer: "Article R. 434-20",
    explanation: "L’aide aux victimes est définie par l’article R. 434-20.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Refuser de prendre une plainte constitue un manquement à quel article ?",
    options: ["Article R. 434-20", "Article R. 434-14", "Article R. 434-11"],
    answer: "Article R. 434-20",
    explanation:
        "Le policier ou le gendarme doit assurer la prise en charge des victimes (article R. 434-20).",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "La consultation des fichiers de police doit respecter quel article ?",
    options: ["Article R. 434-21", "Article R. 434-8", "Article R. 434-9"],
    answer: "Article R. 434-21",
    explanation:
        "L’usage des données à caractère personnel est encadré par l’article R. 434-21.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Consulter un fichier par curiosité personnelle viole quel article ?",
    options: ["Article R. 434-21", "Article R. 434-9", "Article R. 434-12"],
    answer: "Article R. 434-21",
    explanation:
        "Les fichiers ne peuvent être utilisés qu’aux fins prévues par la loi.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question: "Le recours à des informateurs est encadré par quel article ?",
    options: ["Article R. 434-22", "Article R. 434-21", "Article R. 434-23"],
    answer: "Article R. 434-22",
    explanation:
        "Le traitement des sources humaines est prévu à l’article R. 434-22.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article rappelle que la police et la gendarmerie sont soumises à des contrôles ?",
    options: ["Article R. 434-23", "Article R. 434-24", "Article R. 434-25"],
    answer: "Article R. 434-23",
    explanation:
        "Les principes du contrôle sont définis à l’article R. 434-23.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Le contrôle exercé par le Défenseur des droits relève de quel article ?",
    options: ["Article R. 434-24", "Article R. 434-23", "Article R. 434-25"],
    answer: "Article R. 434-24",
    explanation:
        "Le rôle du Défenseur des droits est précisé à l’article R. 434-24.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article consacre le principe du contrôle des pairs en matière de déontologie ?",
    options: ["Article R. 434-26", "Article R. 434-25", "Article R. 434-27"],
    answer: "Article R. 434-26",
    explanation: "Le contrôle des pairs est prévu par l’article R. 434-26.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Fermer les yeux volontairement sur un manquement déontologique d’un collègue relève de quel article ?",
    options: ["Article R. 434-26", "Article R. 434-27", "Article R. 434-25"],
    answer: "Article R. 434-26",
    explanation:
        "Le silence des pairs face à un manquement vaut consentement (article R. 434-26).",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Tout manquement au code expose à une sanction disciplinaire selon quel article ?",
    options: ["Article R. 434-27", "Article R. 434-26", "Article R. 434-24"],
    answer: "Article R. 434-27",
    explanation:
        "Les sanctions disciplinaires sont prévues par l’article R. 434-27.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Un manquement déontologique peut-il entraîner à la fois une sanction disciplinaire et pénale ?",
    options: [
      "Oui, article R. 434-27",
      "Non, uniquement disciplinaire",
      "Non, uniquement pénale",
    ],
    answer: "Oui, article R. 434-27",
    explanation:
        "L’article R. 434-27 prévoit l’indépendance des sanctions disciplinaires et pénales.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Police nationale",
    question:
        "Quel article impose le respect de la mémoire des policiers morts en service ?",
    options: ["Article R. 434-28", "Article R. 434-12", "Article R. 434-29"],
    answer: "Article R. 434-28",
    explanation: "Le devoir de mémoire est prévu par l’article R. 434-28.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Police nationale",
    question:
        "S’absenter sans motif valable lors d’une minute de silence constitue un manquement à quel article ?",
    options: ["Article R. 434-28", "Article R. 434-29", "Article R. 434-30"],
    answer: "Article R. 434-28",
    explanation:
        "Le devoir de mémoire est une obligation professionnelle (article R. 434-28).",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Police nationale",
    question:
        "L’obligation de neutralité du policier est prévue par quel article ?",
    options: ["Article R. 434-29", "Article R. 434-12", "Article R. 434-11"],
    answer: "Article R. 434-29",
    explanation:
        "Le devoir de réserve et de neutralité est défini à l’article R. 434-29.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Police nationale",
    question:
        "Exprimer ses opinions politiques en service constitue un manquement à quel article ?",
    options: ["Article R. 434-29", "Article R. 434-12", "Article R. 434-10"],
    answer: "Article R. 434-29",
    explanation:
        "Le policier est soumis à une stricte neutralité en service (article R. 434-29).",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Police nationale",
    question:
        "Publier des critiques publiques sur une décision de justice relève de quel manquement ?",
    options: ["Article R. 434-29", "Article R. 434-12", "Article R. 434-11"],
    answer: "Article R. 434-29",
    explanation:
        "La diffusion publique de critiques sur la justice viole le devoir de réserve.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Police nationale",
    question:
        "Quel article impose la disponibilité permanente du policier pour les nécessités du service ?",
    options: ["Article R. 434-30", "Article R. 434-13", "Article R. 434-19"],
    answer: "Article R. 434-30",
    explanation:
        "La disponibilité du policier est prévue par l’article R. 434-30.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Police nationale",
    question:
        "Éteindre volontairement son téléphone pour éviter un rappel au service constitue un manquement à quel article ?",
    options: ["Article R. 434-30", "Article R. 434-13", "Article R. 434-29"],
    answer: "Article R. 434-30",
    explanation:
        "La disponibilité implique de pouvoir être joint à tout moment (article R. 434-30).",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Police nationale",
    question:
        "Changer de résidence sans en informer la hiérarchie relève de quel article ?",
    options: ["Article R. 434-30", "Article R. 434-28", "Article R. 434-13"],
    answer: "Article R. 434-30",
    explanation:
        "Le changement de résidence doit être signalé en raison de l’obligation de disponibilité.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Gendarmerie",
    question:
        "Quel article rappelle que l’état militaire implique discipline, disponibilité et esprit de sacrifice ?",
    options: ["Article R. 434-31", "Article R. 434-32", "Article R. 434-33"],
    answer: "Article R. 434-31",
    explanation:
        "L’article R. 434-31 définit les valeurs attachées à l’état militaire du gendarme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie",
    question:
        "L’esprit de sacrifice pouvant aller jusqu’au sacrifice suprême est prévu par quel article ?",
    options: ["Article R. 434-31", "Article R. 434-32", "Article R. 434-29"],
    answer: "Article R. 434-31",
    explanation:
        "L’article R. 434-31 rappelle les exigences fondamentales de l’état militaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie",
    question:
        "Honorer la mémoire des gendarmes morts en service relève de quel article ?",
    options: ["Article R. 434-31", "Article R. 434-28", "Article R. 434-33"],
    answer: "Article R. 434-31",
    explanation:
        "Le devoir de mémoire est expressément prévu pour la gendarmerie à l’article R. 434-31.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie",
    question:
        "Refuser de prendre en compte une personne se présentant juste avant la fermeture constitue un manquement à quel article ?",
    options: ["Article R. 434-31", "Article R. 434-30", "Article R. 434-14"],
    answer: "Article R. 434-31",
    explanation:
        "Le gendarme doit se montrer disponible et loyal dans l’exécution de la mission (article R. 434-31).",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie",
    question:
        "Exécuter partiellement une mission sans en informer la hiérarchie viole quel article ?",
    options: ["Article R. 434-31", "Article R. 434-5", "Article R. 434-33"],
    answer: "Article R. 434-31",
    explanation:
        "La mission confiée doit être menée jusqu’à son terme ou signalée (article R. 434-31).",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie",
    question:
        "Quel article encadre le devoir de réserve spécifique aux militaires de la gendarmerie ?",
    options: ["Article R. 434-32", "Article R. 434-29", "Article R. 434-12"],
    answer: "Article R. 434-32",
    explanation:
        "Le devoir de réserve des militaires est prévu par l’article R. 434-32.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie",
    question:
        "Un gendarme peut-il exprimer ses opinions politiques en service ?",
    options: [
      "Non, article R. 434-32",
      "Oui, librement",
      "Oui, avec autorisation",
    ],
    answer: "Non, article R. 434-32",
    explanation:
        "Le devoir de réserve interdit toute expression politique en service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie",
    question:
        "Exprimer publiquement ses convictions religieuses en se revendiquant gendarme relève de quel article ?",
    options: ["Article R. 434-32", "Article R. 434-31", "Article R. 434-12"],
    answer: "Article R. 434-32",
    explanation:
        "Le devoir de réserve des militaires est strict (article R. 434-32).",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie",
    question:
        "Participer aux instances de concertation interne est prévu par quel article ?",
    options: ["Article R. 434-32", "Article R. 434-33", "Article R. 434-31"],
    answer: "Article R. 434-32",
    explanation: "Le dialogue interne est reconnu par l’article R. 434-32.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie",
    question:
        "Quel article rappelle que le gendarme est soumis au statut général des militaires ?",
    options: ["Article R. 434-33", "Article R. 434-31", "Article R. 434-32"],
    answer: "Article R. 434-33",
    explanation:
        "L’article R. 434-33 renvoie au code de la défense et au statut militaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie",
    question:
        "L’obligation de logement par nécessité absolue de service découle de quel article ?",
    options: ["Article R. 434-33", "Article R. 434-30", "Article R. 434-31"],
    answer: "Article R. 434-33",
    explanation:
        "Cette obligation est liée aux sujétions spécifiques du statut militaire.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Principes généraux",
    question:
        "Quel article pose le cadre général des missions de la police et de la gendarmerie nationales ?",
    options: ["Article R. 434-2", "Article R. 434-3", "Article R. 434-4"],
    answer: "Article R. 434-2",
    explanation:
        "L’article R. 434-2 définit le cadre général de l’action des forces de sécurité intérieure.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Principes généraux",
    question:
        "Le respect des droits de l’homme dans l’exercice des missions est affirmé par quel article ?",
    options: ["Article R. 434-2", "Article R. 434-8", "Article R. 434-11"],
    answer: "Article R. 434-2",
    explanation:
        "L’article R. 434-2 rappelle l’exigence du respect des droits fondamentaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Champ d’application",
    question:
        "Les règles déontologiques s’appliquent-elles en dehors du service ?",
    options: [
      "Oui, article R. 434-3",
      "Non, uniquement en service",
      "Uniquement en mission judiciaire",
    ],
    answer: "Oui, article R. 434-3",
    explanation:
        "L’article R. 434-3 précise que les règles s’appliquent en service et hors service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question:
        "Quel article impose à l’autorité hiérarchique d’assumer la responsabilité des ordres donnés ?",
    options: ["Article R. 434-4", "Article R. 434-5", "Article R. 434-6"],
    answer: "Article R. 434-4",
    explanation:
        "L’article R. 434-4 pose le principe hiérarchique et la responsabilité du chef.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question:
        "Informer la hiérarchie d’une convocation judiciaire relève de quel article ?",
    options: ["Article R. 434-4", "Article R. 434-7", "Article R. 434-27"],
    answer: "Article R. 434-4",
    explanation:
        "L’obligation de rendre compte est prévue à l’article R. 434-4.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question: "Dans quel cas un policier peut-il refuser d’exécuter un ordre ?",
    options: [
      "Ordre manifestement illégal et gravement préjudiciable",
      "Ordre contraire à ses convictions",
      "Ordre jugé inutile",
    ],
    answer: "Ordre manifestement illégal et gravement préjudiciable",
    explanation:
        "L’article R. 434-5 encadre strictement le refus d’obéissance.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question:
        "Demander la confirmation écrite d’un ordre est prévu par quel article ?",
    options: ["Article R. 434-5", "Article R. 434-4", "Article R. 434-6"],
    answer: "Article R. 434-5",
    explanation:
        "L’article R. 434-5 prévoit cette possibilité en cas d’ordre manifestement illégal.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Autorité hiérarchique",
    question:
        "Veiller à la santé physique et mentale des subordonnés relève de quel article ?",
    options: ["Article R. 434-6", "Article R. 434-7", "Article R. 434-4"],
    answer: "Article R. 434-6",
    explanation:
        "L’article R. 434-6 impose une obligation de protection des personnels.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Protection",
    question: "La protection fonctionnelle est prévue par quel article ?",
    options: ["Article R. 434-7", "Article R. 434-6", "Article R. 434-27"],
    answer: "Article R. 434-7",
    explanation: "L’article R. 434-7 consacre la protection fonctionnelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Secret professionnel",
    question:
        "Divulguer une information confidentielle à un proche viole quel article ?",
    options: ["Article R. 434-8", "Article R. 434-9", "Article R. 434-12"],
    answer: "Article R. 434-8",
    explanation:
        "Le secret et la discrétion professionnels sont prévus à l’article R. 434-8.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Probité",
    question:
        "Accepter un cadeau lié à ses fonctions constitue une violation de quel article ?",
    options: ["Article R. 434-9", "Article R. 434-11", "Article R. 434-12"],
    answer: "Article R. 434-9",
    explanation:
        "La probité interdit tout avantage personnel (article R. 434-9).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discernement",
    question:
        "Adapter sa réponse à la situation et aux risques relève de quel article ?",
    options: ["Article R. 434-10", "Article R. 434-18", "Article R. 434-11"],
    answer: "Article R. 434-10",
    explanation: "Le discernement est défini par l’article R. 434-10.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Impartialité",
    question:
        "Traiter différemment une personne en raison de son origine constitue une violation de quel article ?",
    options: ["Article R. 434-11", "Article R. 434-14", "Article R. 434-12"],
    answer: "Article R. 434-11",
    explanation:
        "L’impartialité interdit toute discrimination (article R. 434-11).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Exemplarité",
    question:
        "Tenir des propos injurieux sur les réseaux sociaux porte atteinte à quel article ?",
    options: ["Article R. 434-12", "Article R. 434-29", "Article R. 434-8"],
    answer: "Article R. 434-12",
    explanation:
        "L’article R. 434-12 protège le crédit et le renom de l’institution.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Relation avec la population",
    question:
        "Quel article impose au policier ou au gendarme d’être au service de la population ?",
    options: ["Article R. 434-14", "Article R. 434-11", "Article R. 434-12"],
    answer: "Article R. 434-14",
    explanation:
        "L’article R. 434-14 pose le principe du service à la population.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Relation avec la population",
    question:
        "L’usage du vouvoiement avec le public est imposé par quel article ?",
    options: ["Article R. 434-14", "Article R. 434-15", "Article R. 434-8"],
    answer: "Article R. 434-14",
    explanation:
        "La courtoisie et le vouvoiement sont exigés par l’article R. 434-14.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Relation avec la population",
    question:
        "Tutoyer une personne contrôlée sans justification constitue un manquement à quel article ?",
    options: ["Article R. 434-14", "Article R. 434-11", "Article R. 434-16"],
    answer: "Article R. 434-14",
    explanation:
        "Le respect et la courtoisie envers la population sont obligatoires.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Tenue",
    question:
        "Quel article impose le port de la tenue réglementaire en service ?",
    options: ["Article R. 434-15", "Article R. 434-14", "Article R. 434-12"],
    answer: "Article R. 434-15",
    explanation:
        "Le port de la tenue et l’identification individuelle relèvent de l’article R. 434-15.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Tenue",
    question:
        "Exercer en tenue civile impose néanmoins une identification visible selon quel article ?",
    options: ["Article R. 434-15", "Article R. 434-16", "Article R. 434-7"],
    answer: "Article R. 434-15",
    explanation:
        "L’identification individuelle reste obligatoire même en tenue civile.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Contrôles d’identité",
    question:
        "Quel article encadre les contrôles d’identité sans discrimination ?",
    options: ["Article R. 434-16", "Article R. 434-11", "Article R. 434-14"],
    answer: "Article R. 434-16",
    explanation:
        "L’article R. 434-16 interdit les contrôles fondés sur des critères discriminatoires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Contrôles d’identité",
    question: "La palpation de sécurité est-elle systématique ?",
    options: [
      "Non, article R. 434-16",
      "Oui, toujours",
      "Oui, sur simple contrôle",
    ],
    answer: "Non, article R. 434-16",
    explanation: "La palpation est une mesure de sûreté non systématique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Contrôles d’identité",
    question: "Pratiquer une palpation sans nécessité viole quel article ?",
    options: ["Article R. 434-16", "Article R. 434-18", "Article R. 434-17"],
    answer: "Article R. 434-16",
    explanation: "La palpation doit être justifiée par un risque objectif.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes privées de liberté",
    question:
        "Quel article place toute personne interpellée sous la protection des forces de l’ordre ?",
    options: ["Article R. 434-17", "Article R. 434-18", "Article R. 434-19"],
    answer: "Article R. 434-17",
    explanation:
        "La protection et la dignité des personnes privées de liberté sont garanties par l’article R. 434-17.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes privées de liberté",
    question:
        "Menotter une personne sans danger ni risque de fuite viole quel article ?",
    options: ["Article R. 434-17", "Article R. 434-18", "Article R. 434-16"],
    answer: "Article R. 434-17",
    explanation: "Le menottage doit être strictement justifié.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question:
        "Quel article pose le principe de nécessité et de proportionnalité dans l’emploi de la force ?",
    options: ["Article R. 434-18", "Article R. 434-10", "Article R. 434-17"],
    answer: "Article R. 434-18",
    explanation:
        "L’usage de la force est strictement encadré par l’article R. 434-18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question: "L’usage des armes est autorisé uniquement en cas de :",
    options: [
      "Absolue nécessité",
      "Danger supposé",
      "Refus d’obtempérer systématique",
    ],
    answer: "Absolue nécessité",
    explanation:
        "Le principe d’absolue nécessité est rappelé à l’article R. 434-18.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Assistance",
    question:
        "Intervenir pour porter secours même hors service relève de quel article ?",
    options: ["Article R. 434-19", "Article R. 434-14", "Article R. 434-7"],
    answer: "Article R. 434-19",
    explanation:
        "L’obligation d’assistance est prévue par l’article R. 434-19.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Assistance",
    question:
        "Refuser d’intervenir sans motif valable constitue un manquement à quel article ?",
    options: ["Article R. 434-19", "Article R. 434-27", "Article R. 434-4"],
    answer: "Article R. 434-19",
    explanation: "Le devoir d’assistance est une obligation professionnelle.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Aide aux victimes",
    question:
        "Quel article impose une attention particulière aux victimes tout au long de la procédure ?",
    options: ["Article R. 434-20", "Article R. 434-14", "Article R. 434-17"],
    answer: "Article R. 434-20",
    explanation:
        "L’article R. 434-20 encadre l’aide et la prise en charge des victimes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Aide aux victimes",
    question:
        "Refuser de prendre une plainte alors que les faits constituent une infraction viole quel article ?",
    options: ["Article R. 434-20", "Article R. 434-27", "Article R. 434-14"],
    answer: "Article R. 434-20",
    explanation:
        "La prise de plainte est une obligation rappelée par l’article R. 434-20.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Aide aux victimes",
    question:
        "Garantir la confidentialité des propos des victimes relève de quel article ?",
    options: ["Article R. 434-20", "Article R. 434-8", "Article R. 434-21"],
    answer: "Article R. 434-20",
    explanation:
        "La protection des victimes inclut la confidentialité de leurs déclarations.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Données personnelles",
    question:
        "Quel article encadre l’usage des fichiers contenant des données personnelles ?",
    options: ["Article R. 434-21", "Article R. 434-8", "Article R. 434-9"],
    answer: "Article R. 434-21",
    explanation:
        "L’article R. 434-21 régit l’utilisation des traitements de données personnelles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Données personnelles",
    question:
        "Consulter un fichier par simple curiosité constitue une violation de quel article ?",
    options: ["Article R. 434-21", "Article R. 434-9", "Article R. 434-11"],
    answer: "Article R. 434-21",
    explanation:
        "Toute consultation doit être strictement motivée par le service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Données personnelles",
    question:
        "Partager son identifiant d’accès aux applications professionnelles viole quel article ?",
    options: ["Article R. 434-21", "Article R. 434-8", "Article R. 434-27"],
    answer: "Article R. 434-21",
    explanation:
        "La sécurité et la finalité des fichiers doivent être strictement respectées.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Sources humaines",
    question: "Le recours à des informateurs est encadré par quel article ?",
    options: ["Article R. 434-22", "Article R. 434-9", "Article R. 434-21"],
    answer: "Article R. 434-22",
    explanation:
        "L’article R. 434-22 encadre le traitement des sources humaines.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Sources humaines",
    question:
        "Pourquoi le recours aux sources humaines doit-il être strictement encadré ?",
    options: [
      "Pour garantir la sécurité juridique de l’agent",
      "Pour accélérer les procédures",
      "Pour contourner la procédure judiciaire",
    ],
    answer: "Pour garantir la sécurité juridique de l’agent",
    explanation:
        "L’article R. 434-22 insiste sur la prudence et la sécurité juridique.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Sources humaines",
    question:
        "Entretenir une relation privée non encadrée avec un informateur peut constituer :",
    options: [
      "Un manquement déontologique",
      "Une bonne pratique",
      "Une obligation professionnelle",
    ],
    answer: "Un manquement déontologique",
    explanation:
        "Les relations non encadrées exposent l’agent à des risques disciplinaires.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Contrôle",
    question:
        "Quel article pose le principe du contrôle de l’action de la police et de la gendarmerie ?",
    options: ["Article R. 434-23", "Article R. 434-25", "Article R. 434-26"],
    answer: "Article R. 434-23",
    explanation:
        "L’article R. 434-23 rappelle que les forces sont soumises à des contrôles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Contrôle",
    question: "Le contrôle de l’action judiciaire est exercé par :",
    options: [
      "L’autorité judiciaire",
      "L’autorité administrative uniquement",
      "Le Défenseur des droits uniquement",
    ],
    answer: "L’autorité judiciaire",
    explanation:
        "L’article R. 434-23 précise le rôle de l’autorité judiciaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Défenseur des droits",
    question: "Quel article encadre le rôle du Défenseur des droits ?",
    options: ["Article R. 434-24", "Article R. 434-23", "Article R. 434-25"],
    answer: "Article R. 434-24",
    explanation: "Le Défenseur des droits est mentionné à l’article R. 434-24.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Défenseur des droits",
    question:
        "Un policier peut-il refuser de répondre à une convocation du Défenseur des droits ?",
    options: [
      "Non, article R. 434-24",
      "Oui, sans justification",
      "Oui, en cas de service",
    ],
    answer: "Non, article R. 434-24",
    explanation: "L’agent doit coopérer avec le Défenseur des droits.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Inspection",
    question:
        "Faciliter les opérations de contrôle et d’inspection relève de quel article ?",
    options: ["Article R. 434-25", "Article R. 434-26", "Article R. 434-27"],
    answer: "Article R. 434-25",
    explanation:
        "L’article R. 434-25 impose la coopération lors des inspections.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Contrôle des pairs",
    question:
        "Le contrôle exercé par les collègues est prévu par quel article ?",
    options: ["Article R. 434-26", "Article R. 434-25", "Article R. 434-27"],
    answer: "Article R. 434-26",
    explanation: "Les pairs sont les premiers garants du respect du code.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Sanctions",
    question:
        "Quel article prévoit qu’un manquement déontologique expose à une sanction disciplinaire ?",
    options: ["Article R. 434-27", "Article R. 434-25", "Article R. 434-26"],
    answer: "Article R. 434-27",
    explanation:
        "L’article R. 434-27 pose le principe des sanctions disciplinaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Sanctions",
    question:
        "Les sanctions disciplinaires excluent-elles les poursuites pénales ?",
    options: [
      "Non, elles sont indépendantes",
      "Oui, elles s’y substituent",
      "Uniquement pour les fautes graves",
    ],
    answer: "Non, elles sont indépendantes",
    explanation:
        "L’article R. 434-27 précise l’indépendance des sanctions disciplinaires et pénales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Sanctions",
    question:
        "Un même comportement peut-il constituer plusieurs manquements déontologiques ?",
    options: [
      "Oui, article R. 434-27",
      "Non, un seul manquement possible",
      "Uniquement en cas de récidive",
    ],
    answer: "Oui, article R. 434-27",
    explanation:
        "Un même fait peut contrevenir à plusieurs obligations déontologiques.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Non cumul d’activité",
    question:
        "Quel article interdit l’exercice d’une activité privée lucrative non autorisée ?",
    options: ["Article R. 434-13", "Article R. 434-30", "Article R. 434-12"],
    answer: "Article R. 434-13",
    explanation:
        "Le principe de non cumul d’activité est posé à l’article R. 434-13.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Non cumul d’activité",
    question:
        "Une activité privée autorisée doit-elle être déclarée à l’administration ?",
    options: [
      "Oui, article R. 434-13",
      "Non, si elle est occasionnelle",
      "Uniquement en dehors du service",
    ],
    answer: "Oui, article R. 434-13",
    explanation: "Toute activité privée doit être déclarée et autorisée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Non cumul d’activité",
    question:
        "Effectuer une mission de sécurité privée constitue un manquement à quel article ?",
    options: ["Article R. 434-13", "Article R. 434-12", "Article R. 434-27"],
    answer: "Article R. 434-13",
    explanation:
        "La sécurité privée est incompatible avec les fonctions de policier ou gendarme.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Devoir de réserve (Police)",
    question: "Quel article encadre le devoir de réserve des policiers ?",
    options: ["Article R. 434-29", "Article R. 434-12", "Article R. 434-32"],
    answer: "Article R. 434-29",
    explanation:
        "Le devoir de réserve des policiers est défini par l’article R. 434-29.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Devoir de réserve (Police)",
    question:
        "Exprimer ses convictions politiques en service constitue un manquement à quel article ?",
    options: ["Article R. 434-29", "Article R. 434-12", "Article R. 434-8"],
    answer: "Article R. 434-29",
    explanation: "La neutralité est obligatoire dans l’exercice des fonctions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Devoir de réserve (Police)",
    question:
        "Critiquer publiquement une décision de justice peut violer quel article ?",
    options: ["Article R. 434-29", "Article R. 434-11", "Article R. 434-14"],
    answer: "Article R. 434-29",
    explanation: "Le devoir de réserve s’impose également hors service.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Disponibilité",
    question:
        "Quel article impose la disponibilité permanente pour les nécessités du service ?",
    options: ["Article R. 434-30", "Article R. 434-13", "Article R. 434-31"],
    answer: "Article R. 434-30",
    explanation:
        "La disponibilité est une obligation statutaire (article R. 434-30).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Disponibilité",
    question:
        "Éteindre volontairement son téléphone pour ne pas être rappelé viole quel article ?",
    options: ["Article R. 434-30", "Article R. 434-13", "Article R. 434-27"],
    answer: "Article R. 434-30",
    explanation: "Le policier doit pouvoir être joint à tout moment.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Disponibilité",
    question:
        "Ne pas signaler un changement de résidence constitue un manquement à quel article ?",
    options: ["Article R. 434-30", "Article R. 434-4", "Article R. 434-29"],
    answer: "Article R. 434-30",
    explanation: "La hiérarchie doit pouvoir localiser l’agent.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Synthèse",
    question:
        "Le non cumul d’activité, la réserve et la disponibilité participent principalement à :",
    options: [
      "La loyauté envers l’institution",
      "La liberté individuelle",
      "La protection des victimes",
    ],
    answer: "La loyauté envers l’institution",
    explanation:
        "Ces obligations garantissent la neutralité et la disponibilité du service public.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Synthèse",
    question:
        "Quelle obligation vise directement la possibilité de rappel en urgence ?",
    options: ["La disponibilité", "La probité", "Le discernement"],
    answer: "La disponibilité",
    explanation: "L’article R. 434-30 garantit la capacité de rappel immédiat.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Synthèse",
    question:
        "Quel article affirme que la légitimité de l’action policière repose aussi sur le respect des valeurs éthiques ?",
    options: ["Article R. 434-2", "Article R. 434-3", "Article R. 434-12"],
    answer: "Article R. 434-2",
    explanation:
        "L’article R. 434-2 rappelle que la conformité à la loi s’accompagne d’exigences éthiques.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Champ d’application",
    question:
        "Quel article précise que les règles déontologiques font l’objet d’une formation initiale et continue ?",
    options: ["Article R. 434-3", "Article R. 434-6", "Article R. 434-27"],
    answer: "Article R. 434-3",
    explanation:
        "La formation à la déontologie est prévue par l’article R. 434-3.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question:
        "Le droit au silence peut-il être invoqué dans la relation hiérarchique ?",
    options: [
      "Non, article R. 434-4",
      "Oui, toujours",
      "Uniquement hors service",
    ],
    answer: "Non, article R. 434-4",
    explanation: "Le compte rendu hiérarchique est obligatoire.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question:
        "Un ordre écrit exonère-t-il le subordonné de sa responsabilité ?",
    options: [
      "Non, article R. 434-5",
      "Oui, automatiquement",
      "Uniquement en urgence",
    ],
    answer: "Non, article R. 434-5",
    explanation: "La responsabilité personnelle demeure malgré un ordre écrit.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Autorité hiérarchique",
    question:
        "Confier une mission incompatible avec le niveau de formation viole quel article ?",
    options: ["Article R. 434-6", "Article R. 434-4", "Article R. 434-27"],
    answer: "Article R. 434-6",
    explanation: "Le supérieur doit adapter les missions aux compétences.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Protection fonctionnelle",
    question:
        "Refuser de transmettre une demande de protection fonctionnelle viole quel article ?",
    options: ["Article R. 434-7", "Article R. 434-6", "Article R. 434-27"],
    answer: "Article R. 434-7",
    explanation: "La protection fonctionnelle est un droit de l’agent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Secret professionnel",
    question:
        "Divulguer une information par maladresse constitue-t-il un manquement ?",
    options: [
      "Oui, article R. 434-8",
      "Non, si l’intention manque",
      "Uniquement si préjudice",
    ],
    answer: "Oui, article R. 434-8",
    explanation: "La maladresse n’exonère pas du secret professionnel.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Probité",
    question: "Se prévaloir de sa qualité pour obtenir un avantage constitue :",
    options: [
      "Un manquement à l’article R. 434-9",
      "Un simple manque de courtoisie",
      "Une tolérance admise",
    ],
    answer: "Un manquement à l’article R. 434-9",
    explanation: "La probité exclut tout avantage personnel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discernement",
    question:
        "La verbalisation systématique sans tenir compte du contexte viole quel article ?",
    options: ["Article R. 434-10", "Article R. 434-11", "Article R. 434-14"],
    answer: "Article R. 434-10",
    explanation: "Le discernement impose l’analyse de la situation.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Impartialité",
    question:
        "Favoriser un proche dans une procédure constitue une violation de quel article ?",
    options: ["Article R. 434-11", "Article R. 434-9", "Article R. 434-12"],
    answer: "Article R. 434-11",
    explanation: "L’impartialité exclut tout favoritisme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Exemplarité",
    question:
        "Un comportement privé portant atteinte à l’image de l’institution relève de quel article ?",
    options: ["Article R. 434-12", "Article R. 434-29", "Article R. 434-8"],
    answer: "Article R. 434-12",
    explanation: "L’exemplarité s’impose en service et hors service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Non cumul",
    question:
        "Exercer une activité privée sans autorisation même hors service viole quel article ?",
    options: ["Article R. 434-13", "Article R. 434-30", "Article R. 434-27"],
    answer: "Article R. 434-13",
    explanation: "Toute activité privée lucrative doit être autorisée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Relation population",
    question:
        "Un comportement agressif envers un usager viole principalement quel article ?",
    options: ["Article R. 434-14", "Article R. 434-11", "Article R. 434-18"],
    answer: "Article R. 434-14",
    explanation: "La relation avec la population doit rester courtoise.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Contrôles",
    question:
        "Un contrôle d’identité fondé sur l’apparence physique viole quel article ?",
    options: ["Article R. 434-16", "Article R. 434-11", "Article R. 434-14"],
    answer: "Article R. 434-16",
    explanation: "Les contrôles discriminatoires sont interdits.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Force",
    question:
        "Employer la force au-delà de ce qui est nécessaire viole quel article ?",
    options: ["Article R. 434-18", "Article R. 434-17", "Article R. 434-10"],
    answer: "Article R. 434-18",
    explanation: "La proportionnalité est un principe fondamental.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question:
        "Un agent ne rend pas compte d’un incident survenu en service. Quel article est violé ?",
    options: ["Article R. 434-4", "Article R. 434-5", "Article R. 434-27"],
    answer: "Article R. 434-4",
    explanation:
        "L’obligation de rendre compte relève du principe hiérarchique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question:
        "Un agent refuse un ordre légal au motif qu’il est contraire à ses convictions personnelles. Quel article est concerné ?",
    options: ["Article R. 434-5", "Article R. 434-10", "Article R. 434-29"],
    answer: "Article R. 434-5",
    explanation:
        "Les convictions personnelles ne justifient pas un refus d’obéissance.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Autorité hiérarchique",
    question:
        "Un chef ne met en place aucune formation malgré l’évolution des missions. Quel article est violé ?",
    options: ["Article R. 434-6", "Article R. 434-4", "Article R. 434-3"],
    answer: "Article R. 434-6",
    explanation: "L’autorité hiérarchique doit assurer une formation adaptée.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Protection fonctionnelle",
    question:
        "Un agent victime d’outrages ne reçoit aucun soutien administratif. Quel article est concerné ?",
    options: ["Article R. 434-7", "Article R. 434-12", "Article R. 434-27"],
    answer: "Article R. 434-7",
    explanation: "La protection fonctionnelle est un droit garanti.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Secret professionnel",
    question:
        "Un policier évoque une enquête en cours sur un réseau social privé. Quel article est violé ?",
    options: ["Article R. 434-8", "Article R. 434-12", "Article R. 434-21"],
    answer: "Article R. 434-8",
    explanation:
        "Le secret professionnel s’impose y compris sur les réseaux sociaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Probité",
    question:
        "Un agent accepte un repas gratuit en raison de sa qualité professionnelle. Quel article est violé ?",
    options: ["Article R. 434-9", "Article R. 434-11", "Article R. 434-12"],
    answer: "Article R. 434-9",
    explanation: "La probité interdit tout avantage lié à la fonction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discernement",
    question:
        "Un agent poursuit un véhicule malgré un danger manifeste pour les tiers. Quel article est concerné ?",
    options: ["Article R. 434-10", "Article R. 434-18", "Article R. 434-17"],
    answer: "Article R. 434-10",
    explanation: "Le discernement impose d’adapter l’action aux risques.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Impartialité",
    question:
        "Un agent privilégie un proche dans une procédure. Quel article est violé ?",
    options: ["Article R. 434-11", "Article R. 434-9", "Article R. 434-14"],
    answer: "Article R. 434-11",
    explanation: "L’impartialité exclut toute faveur personnelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Exemplarité",
    question:
        "Un agent tient des propos injurieux en public hors service. Quel article est concerné ?",
    options: ["Article R. 434-12", "Article R. 434-29", "Article R. 434-8"],
    answer: "Article R. 434-12",
    explanation: "Le devoir d’exemplarité s’impose en toute circonstance.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Non cumul",
    question:
        "Un agent exerce une activité privée sans autorisation administrative. Quel article est violé ?",
    options: ["Article R. 434-13", "Article R. 434-30", "Article R. 434-27"],
    answer: "Article R. 434-13",
    explanation: "Le non cumul d’activité impose une autorisation préalable.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Relation population",
    question:
        "Un agent tutoie systématiquement les usagers sans raison. Quel article est concerné ?",
    options: ["Article R. 434-14", "Article R. 434-11", "Article R. 434-16"],
    answer: "Article R. 434-14",
    explanation: "Le respect et le vouvoiement sont obligatoires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Tenue",
    question:
        "Un agent porte une tenue incomplète en service. Quel article est violé ?",
    options: ["Article R. 434-15", "Article R. 434-12", "Article R. 434-14"],
    answer: "Article R. 434-15",
    explanation:
        "La tenue réglementaire participe à l’identification et à l’image du service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Contrôles d’identité",
    question:
        "Un contrôle est effectué uniquement en raison de l’apparence d’une personne. Quel article est violé ?",
    options: ["Article R. 434-16", "Article R. 434-11", "Article R. 434-14"],
    answer: "Article R. 434-16",
    explanation: "Les contrôles discriminatoires sont interdits.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Personnes privées de liberté",
    question:
        "Une personne menottée est exposée inutilement à la vue du public. Quel article est concerné ?",
    options: ["Article R. 434-17", "Article R. 434-18", "Article R. 434-12"],
    answer: "Article R. 434-17",
    explanation:
        "La dignité des personnes privées de liberté doit être préservée.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Usage de la force",
    question:
        "Un agent utilise la force sans nécessité objective. Quel article est violé ?",
    options: ["Article R. 434-18", "Article R. 434-10", "Article R. 434-17"],
    answer: "Article R. 434-18",
    explanation: "L’usage de la force doit être nécessaire et proportionné.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Principe général",
    question:
        "Le respect des règles déontologiques conditionne principalement :",
    options: [
      "La légitimité et l’efficacité de l’action policière",
      "Uniquement la responsabilité pénale",
      "La hiérarchie administrative",
    ],
    answer: "La légitimité et l’efficacité de l’action policière",
    explanation:
        "Le code rappelle que la déontologie fonde la légitimité de l’action des forces de l’ordre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Champ d’application",
    question: "Le code de déontologie s’applique aux policiers et gendarmes :",
    options: [
      "Pendant et en dehors du service",
      "Uniquement en service",
      "Seulement lors des missions judiciaires",
    ],
    answer: "Pendant et en dehors du service",
    explanation: "Le code s’applique y compris hors service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question:
        "Un agent invoque le droit au silence pour refuser un compte rendu hiérarchique. Ce comportement est :",
    options: ["Fautif", "Justifié", "Protégé par le code pénal"],
    answer: "Fautif",
    explanation:
        "Le droit au silence ne s’applique pas dans la relation hiérarchique.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question: "Un ordre manifestement illégal doit être :",
    options: [
      "Refusé",
      "Exécuté avec prudence",
      "Exécuté si confirmé par écrit",
    ],
    answer: "Refusé",
    explanation: "Un ordre manifestement illégal ne doit jamais être exécuté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question: "La confirmation écrite d’un ordre manifestement illégal :",
    options: [
      "N’exonère pas la responsabilité de l’agent",
      "Protège totalement l’agent",
      "Rend l’ordre légal",
    ],
    answer: "N’exonère pas la responsabilité de l’agent",
    explanation: "L’écrit ne supprime pas la responsabilité individuelle.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Autorité hiérarchique",
    question: "La formation professionnelle des agents est :",
    options: [
      "Une obligation de l’autorité hiérarchique",
      "Une faculté",
      "Une option laissée à l’agent",
    ],
    answer: "Une obligation de l’autorité hiérarchique",
    explanation:
        "L’article R.434-6 impose une formation adaptée et actualisée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Protection fonctionnelle",
    question: "La protection fonctionnelle est accordée lorsque les faits :",
    options: [
      "Ne constituent pas une faute personnelle",
      "Sont toujours pénaux",
      "Ont été commis hors service uniquement",
    ],
    answer: "Ne constituent pas une faute personnelle",
    explanation: "L’État protège l’agent sauf faute personnelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Secret professionnel",
    question: "Le secret professionnel s’impose :",
    options: [
      "Même à l’égard des proches",
      "Uniquement envers le public",
      "Seulement en enquête judiciaire",
    ],
    answer: "Même à l’égard des proches",
    explanation: "Le besoin d’en connaître est la règle absolue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Probité",
    question: "La probité interdit notamment :",
    options: [
      "Tout avantage lié à la fonction",
      "Uniquement la corruption pénale",
      "Les cadeaux après le service",
    ],
    answer: "Tout avantage lié à la fonction",
    explanation: "La probité va au-delà des seules infractions pénales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Probité",
    question:
        "Orienter un usager souhaitant faire un don vers une œuvre institutionnelle est :",
    options: [
      "Un comportement conforme",
      "Une faute disciplinaire",
      "Un abus de fonction",
    ],
    answer: "Un comportement conforme",
    explanation: "Le code recommande cette pratique.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Discernement",
    question: "Le discernement implique :",
    options: [
      "Une adaptation constante à la situation",
      "Une application automatique des règles",
      "Une action identique en toute circonstance",
    ],
    answer: "Une adaptation constante à la situation",
    explanation: "Le discernement exclut la routine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Impartialité",
    question: "Le ciblage d’une personne en raison de sa religion est :",
    options: [
      "Une discrimination interdite",
      "Autorisé en prévention",
      "Toléré en enquête",
    ],
    answer: "Une discrimination interdite",
    explanation: "Toute discrimination est prohibée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Exemplarité",
    question: "Le devoir d’exemplarité est une obligation :",
    options: ["De résultat", "De moyen", "Conditionnelle"],
    answer: "De résultat",
    explanation: "La simple atteinte suffit à caractériser le manquement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Non cumul",
    question: "Une activité privée lucrative est possible :",
    options: [
      "Uniquement après autorisation",
      "Libre hors service",
      "Sans déclaration",
    ],
    answer: "Uniquement après autorisation",
    explanation: "Toute activité doit être déclarée et autorisée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Relation population",
    question: "La courtoisie et le vouvoiement sont :",
    options: ["Obligatoires", "Recommandés", "Facultatifs"],
    answer: "Obligatoires",
    explanation: "Ils participent à la crédibilité de l’institution.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Champ d’application",
    question:
        "Les règles déontologiques s’imposent aux policiers et gendarmes :",
    options: [
      "Même en dehors du service",
      "Uniquement en service",
      "Seulement en mission judiciaire",
    ],
    answer: "Même en dehors du service",
    explanation:
        "Le code précise que les obligations s’appliquent pendant et hors service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question: "Les ordres hiérarchiques doivent être transmis :",
    options: [
      "Par la voie hiérarchique",
      "Directement sans exception",
      "Par écrit uniquement",
    ],
    answer: "Par la voie hiérarchique",
    explanation: "La voie hiérarchique est la règle, sauf urgence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question:
        "En cas d’urgence, un ordre peut être transmis directement à condition :",
    options: [
      "D’informer la hiérarchie intermédiaire sans délai",
      "D’être confirmé par écrit",
      "D’être validé par le procureur",
    ],
    answer: "D’informer la hiérarchie intermédiaire sans délai",
    explanation: "L’information de la hiérarchie reste obligatoire.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question:
        "Un ordre contraire aux convictions personnelles de l’agent peut être refusé :",
    options: ["Non", "Oui", "Uniquement hors service"],
    answer: "Non",
    explanation:
        "Les convictions personnelles ne justifient jamais un refus d’ordre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question:
        "L’invocation abusive de l’illégalité manifeste d’un ordre expose l’agent :",
    options: [
      "À une responsabilité disciplinaire",
      "À aucune sanction",
      "À une simple remarque",
    ],
    answer: "À une responsabilité disciplinaire",
    explanation: "Un refus injustifié constitue une faute.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Autorité hiérarchique",
    question: "Le supérieur hiérarchique est responsable :",
    options: [
      "Des ordres qu’il donne",
      "Uniquement des résultats",
      "Seulement en cas d’échec",
    ],
    answer: "Des ordres qu’il donne",
    explanation: "La responsabilité de l’ordre incombe à son auteur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Protection fonctionnelle",
    question: "La protection fonctionnelle peut concerner :",
    options: [
      "L’agent et ses proches",
      "Uniquement l’agent",
      "Uniquement hors service",
    ],
    answer: "L’agent et ses proches",
    explanation:
        "La protection est étendue aux proches dans certaines conditions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Secret professionnel",
    question:
        "La divulgation d’une information confidentielle par maladresse est :",
    options: ["Fautive", "Tolérée", "Sans conséquence"],
    answer: "Fautive",
    explanation: "Même involontaire, la divulgation constitue une faute.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Secret professionnel",
    question: "Le principe fondamental du secret professionnel repose sur :",
    options: [
      "Le droit et le besoin d’en connaître",
      "La hiérarchie",
      "La confiance personnelle",
    ],
    answer: "Le droit et le besoin d’en connaître",
    explanation:
        "Seules les personnes habilitées peuvent recevoir l’information.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Probité",
    question:
        "Le fait de se prévaloir de sa qualité de policier pour obtenir un avantage est :",
    options: ["Interdit", "Toléré hors service", "Autorisé sans contrepartie"],
    answer: "Interdit",
    explanation: "La probité interdit tout avantage lié à la fonction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Probité",
    question: "La probité vise à prévenir notamment :",
    options: [
      "La corruption et le favoritisme",
      "Les erreurs professionnelles",
      "Les conflits hiérarchiques",
    ],
    answer: "La corruption et le favoritisme",
    explanation: "La probité s’oppose à toute forme d’avantage indu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discernement",
    question: "Le discernement impose à l’agent :",
    options: [
      "D’évaluer les risques et délais avant d’agir",
      "D’agir systématiquement",
      "D’appliquer la sanction maximale",
    ],
    answer: "D’évaluer les risques et délais avant d’agir",
    explanation: "L’analyse préalable est essentielle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Impartialité",
    question:
        "Traiter différemment une personne en raison de son origine constitue :",
    options: [
      "Une discrimination interdite",
      "Une mesure préventive",
      "Un pouvoir discrétionnaire",
    ],
    answer: "Une discrimination interdite",
    explanation: "L’impartialité exclut toute distinction discriminatoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Exemplarité",
    question:
        "Un comportement privé peut constituer un manquement déontologique s’il :",
    options: [
      "Porte atteinte au crédit de l’institution",
      "N’a aucune publicité",
      "Ne concerne pas le service",
    ],
    answer: "Porte atteinte au crédit de l’institution",
    explanation: "La vie privée peut engager la responsabilité déontologique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Non cumul d’activité",
    question:
        "Exercer une activité privée lucrative sans autorisation constitue :",
    options: ["Une faute", "Un droit", "Une simple irrégularité"],
    answer: "Une faute",
    explanation: "Toute activité non autorisée est interdite.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Déontologie — Champ d’application",
    question:
        "Les règles du code de déontologie trouvent leur origine principalement :",
    options: [
      "Dans la Constitution, les traités internationaux et les lois",
      "Uniquement dans le règlement intérieur",
      "Dans les usages professionnels",
    ],
    answer: "Dans la Constitution, les traités internationaux et les lois",
    explanation:
        "Article R. 434-3 : le code procède de la Constitution, des traités et des lois.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Champ d’application",
    question: "La formation au code de déontologie est :",
    options: ["Initiale et continue", "Uniquement initiale", "Facultative"],
    answer: "Initiale et continue",
    explanation: "Le code impose une formation initiale et continue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question:
        "Le défaut de compte rendu d’un incident survenu hors service est :",
    options: [
      "Un manquement déontologique",
      "Autorisé hors service",
      "Toléré s’il n’y a pas de poursuite",
    ],
    answer: "Un manquement déontologique",
    explanation:
        "Article R. 434-4 : obligation de rendre compte même hors service.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Hiérarchie",
    question: "Le droit au silence peut être opposé à la hiérarchie :",
    options: ["Non", "Oui en cas de procédure", "Oui hors service"],
    answer: "Non",
    explanation:
        "Le droit au silence judiciaire ne s’applique pas à la relation hiérarchique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question: "Un ordre manifestement illégal doit être :",
    options: [
      "Refusé",
      "Exécuté avec prudence",
      "Exécuté après confirmation orale",
    ],
    answer: "Refusé",
    explanation:
        "Article R. 434-5 : l’ordre manifestement illégal ne doit pas être exécuté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Obéissance",
    question:
        "La confirmation écrite d’un ordre illégal exonère l’agent de sa responsabilité :",
    options: ["Non", "Oui", "Uniquement en urgence"],
    answer: "Non",
    explanation: "Même écrit, l’ordre illégal n’exonère pas l’agent.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Autorité hiérarchique",
    question: "Le supérieur hiérarchique doit veiller notamment :",
    options: [
      "À la santé physique et mentale des subordonnés",
      "Uniquement à la discipline",
      "Uniquement aux résultats",
    ],
    answer: "À la santé physique et mentale des subordonnés",
    explanation: "Article R. 434-6 : protection physique et mentale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Formation",
    question: "Les actes de formation constituent :",
    options: [
      "Des activités de service",
      "Des activités facultatives",
      "Du temps personnel",
    ],
    answer: "Des activités de service",
    explanation: "La formation s’impose aux agents désignés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Protection fonctionnelle",
    question: "La protection fonctionnelle est accordée lorsque :",
    options: [
      "Il n’y a pas de faute personnelle",
      "Il y a une faute disciplinaire",
      "L’agent est hors service",
    ],
    answer: "Il n’y a pas de faute personnelle",
    explanation: "Article R. 434-7.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Secret professionnel",
    question: "Communiquer une information à un collègue non habilité est :",
    options: ["Interdit", "Autorisé en interne", "Toléré en urgence"],
    answer: "Interdit",
    explanation: "Le secret s’impose y compris en interne.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Probité",
    question: "Accepter un cadeau lié à sa fonction est :",
    options: [
      "Interdit",
      "Autorisé sans contrepartie",
      "Autorisé hors service",
    ],
    answer: "Interdit",
    explanation: "Article R. 434-9 : aucun avantage accepté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Probité",
    question: "La probité impose notamment d’éviter :",
    options: [
      "Les conflits d’intérêts",
      "Les relations professionnelles",
      "Les comptes rendus écrits",
    ],
    answer: "Les conflits d’intérêts",
    explanation: "Tout intérêt privé ne doit pas interférer avec la mission.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Discernement",
    question: "Le manque de temps pour agir :",
    options: [
      "Réduit l’exigence de discernement",
      "Augmente la responsabilité",
      "Supprime toute responsabilité",
    ],
    answer: "Réduit l’exigence de discernement",
    explanation: "Le discernement s’apprécie selon les délais disponibles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Impartialité",
    question: "L’impartialité implique :",
    options: [
      "L’absence de parti pris",
      "Un traitement différencié",
      "Une priorité aux proches",
    ],
    answer: "L’absence de parti pris",
    explanation: "Article R. 434-11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Exemplarité",
    question: "L’usage des réseaux sociaux par un policier est :",
    options: [
      "Soumis au devoir d’exemplarité",
      "Libre sans restriction",
      "Protégé par la vie privée",
    ],
    answer: "Soumis au devoir d’exemplarité",
    explanation: "Article R. 434-12.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Non cumul d’activité",
    question: "Toute activité privée doit être :",
    options: [
      "Déclarée et autorisée",
      "Simplement signalée",
      "Libre hors service",
    ],
    answer: "Déclarée et autorisée",
    explanation: "Article R. 434-13.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Relation population",
    question: "La relation avec la population doit être marquée par :",
    options: [
      "La courtoisie et le vouvoiement",
      "La fermeté uniquement",
      "La familiarité",
    ],
    answer: "La courtoisie et le vouvoiement",
    explanation: "Article R. 434-14.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Tenue",
    question: "Le port de l’uniforme vise notamment :",
    options: ["L’identification de l’agent", "La discrétion", "L’anonymat"],
    answer: "L’identification de l’agent",
    explanation: "Article R. 434-15.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Contrôle d’identité",
    question: "Un contrôle d’identité fondé uniquement sur l’apparence est :",
    options: ["Interdit", "Autorisé", "Recommandé"],
    answer: "Interdit",
    explanation: "Article R. 434-16.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Palpation de sécurité",
    question: "La palpation de sécurité est :",
    options: ["Une mesure de sûreté", "Une fouille judiciaire", "Systématique"],
    answer: "Une mesure de sûreté",
    explanation: "Elle vise uniquement la sécurité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie",
    question:
        "Les sujétions spécifiques du métier de gendarme sont rappelées par quel article ?",
    options: ["Article R. 434-33", "Article R. 434-32", "Article R. 434-27"],
    answer: "Article R. 434-33",
    explanation:
        "L’article R. 434-33 clôt les dispositions propres à la gendarmerie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Refuser de coopérer lors d’une inspection constitue un manquement à quel article ?",
    options: ["Article R. 434-25", "Article R. 434-26", "Article R. 434-23"],
    answer: "Article R. 434-25",
    explanation:
        "Le contrôle hiérarchique et des inspections est prévu par l’article R. 434-25.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Articles",
    question:
        "Quel article impose que l’usage de la force soit strictement nécessaire et proportionné ?",
    options: ["Article R. 434-18", "Article R. 434-19", "Article R. 434-10"],
    answer: "Article R. 434-18",
    explanation:
        "Les principes de nécessité et de proportionnalité figurent à l’article R. 434-18.",
    difficulty: "Moyen",
  ),
];

class QuizDeontologieGPX extends StatefulWidget {
  static const String routeName = '/gpx/institution/deontologie/quiz';
  final String uid;
  final String email;

  const QuizDeontologieGPX({super.key, required this.uid, required this.email});

  @override
  State<QuizDeontologieGPX> createState() => _QuizDeontologieGPXState();
}

class _QuizDeontologieGPXState extends State<QuizDeontologieGPX>
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

    final pool = useAll
        ? questionDeontologie
        : questionDeontologie
              .where((q) => q.difficulty == _selectedDifficulty)
              .toList();

    _qs = List<QuizQuestion>.from(pool);
    _qs.shuffle(_rng);

    // ✅ Options = List<String>
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
            'module_name': 'Deontologie',
            'quiz_name': 'Quiz- Deontologie',
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
      await _sb.from('quiz_deontologie').insert({
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
      debugPrint('❌ quiz_deontologie insert failed: $e');
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? Colors.white : _Brand.textDark;

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

          // ✅ Image de la question (galon / grade)
          if (question.questionImageAsset != null &&
              question.questionImageAsset!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Container(
                height: 160,
                padding: const EdgeInsets.all(12),
                color: isDark
                    ? Colors.white.withAlpha(18)
                    : const Color(0xFFF2F3F6),
                child: Image.asset(
                  question.questionImageAsset!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // ✅ Options (String)
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

  // ✅ nouveau : image optionnelle
  final String? assetImage;

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
    this.assetImage,
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

    Widget? thumb() {
      if (assetImage == null || assetImage!.isEmpty) return null;

      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 54,
          height: 54,
          padding: const EdgeInsets.all(6),
          color: isDark ? Colors.white.withAlpha(18) : const Color(0xFFF2F3F6),
          child: Image.asset(assetImage!, fit: BoxFit.contain),
        ),
      );
    }

    final t = thumb();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              dot(selected || correct || wrong),
              const SizedBox(width: 14),

              if (t != null) ...[t, const SizedBox(width: 12)],

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
