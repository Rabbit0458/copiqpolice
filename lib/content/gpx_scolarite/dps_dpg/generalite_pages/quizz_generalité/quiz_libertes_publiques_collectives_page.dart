// ignore_for_file: use_build_context_synchronously

// ============================================================================
//  Quiz UsageArmes – version refondue
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

final List<QuizQuestion> questionsLibertesPubliquesCollectives = [
  QuizQuestion(
    category: "Manifestations – Cadre général",
    question:
        "La manifestation sur la voie publique est principalement encadrée par :",
    options: [
      "Le Code du travail",
      "Les articles L.211-1 et suivants du Code de la sécurité intérieure",
      "Les articles 431-1 et suivants du Code pénal",
    ],
    answer:
        "Les articles L.211-1 et suivants du Code de la sécurité intérieure",
    explanation:
        "Le régime juridique des cortèges, défilés et rassemblements sur la voie publique est organisé par les articles L.211-1 et suivants du Code de la sécurité intérieure.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Déclaration",
    question:
        "L’un des principaux objectifs de la déclaration préalable de manifestation est :",
    options: [
      "D’augmenter le nombre de manifestants",
      "De permettre à l’autorité de police d’évaluer les risques et d’adapter le dispositif",
      "D’identifier les personnes qui assisteront en tant que simples spectateurs",
    ],
    answer:
        "De permettre à l’autorité de police d’évaluer les risques et d’adapter le dispositif",
    explanation:
        "La déclaration permet la préparation opérationnelle : évaluation des risques, effectifs à prévoir, itinéraire, mesures de sécurité.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Itinéraire",
    question: "L’itinéraire d’un cortège déclaré doit être :",
    options: [
      "Imposé uniquement par le préfet",
      "Précisé dans la déclaration pour permettre l’organisation du dispositif de sécurité",
      "Toujours tenu secret pour les forces de l’ordre",
    ],
    answer:
        "Précisé dans la déclaration pour permettre l’organisation du dispositif de sécurité",
    explanation:
        "La déclaration doit comporter l’itinéraire lorsqu’il s’agit d’un défilé, afin de dimensionner les moyens et de sécuriser le parcours.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Organisateurs",
    question:
        "Les organisateurs d’une manifestation sont particulièrement responsables :",
    options: [
      "Du comportement des forces de l’ordre",
      "Du respect de l’itinéraire et des consignes de sécurité communiqués",
      "De la rédaction des procès-verbaux de police",
    ],
    answer:
        "Du respect de l’itinéraire et des consignes de sécurité communiqués",
    explanation:
        "Les organisateurs sont interlocuteurs de l’autorité et doivent veiller au respect des modalités arrêtées (itinéraire, horaires, encadrement).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Non-déclaration",
    question: "Une manifestation organisée sans déclaration préalable est :",
    options: [
      "Toujours autorisée si elle est pacifique",
      "Susceptible de constituer une infraction pour les organisateurs",
      "Sans conséquence juridique",
    ],
    answer: "Susceptible de constituer une infraction pour les organisateurs",
    explanation:
        "L’article 431-9 du Code Pénal. sanctionne l’organisation d’une manifestation non déclarée ou malgré interdiction.",
    difficulty: "Facile",
  ),
  // ===================== BLOC 3 – Nouvelles questions (50) =====================

  // ===================== NIVEAU FACILE =====================
  QuizQuestion(
    category: "Notions générales",
    question:
        "Parmi les propositions suivantes, laquelle relève d’une liberté publique collective ?",
    options: [
      "La liberté d’aller et venir",
      "La liberté de manifester",
      "Le droit au respect de la vie privée",
    ],
    answer: "La liberté de manifester",
    explanation:
        "La liberté de manifester s’exerce collectivement, contrairement à des libertés essentiellement individuelles comme la vie privée.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Distinction",
    question:
        "La manifestation sur la voie publique se distingue principalement de l’attroupement par :",
    options: [
      "L’existence d’une déclaration préalable à l’autorité de police",
      "La présence obligatoire de banderoles",
      "La diffusion de musique",
    ],
    answer: "L’existence d’une déclaration préalable à l’autorité de police",
    explanation:
        "La manifestation est en principe déclarée, alors que l’attroupement est un rassemblement susceptible de troubler l’ordre public sans nécessaire déclaration.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Lieu de déclaration",
    question:
        "À Paris, la déclaration préalable de manifestation doit être déposée :",
    options: [
      "À la mairie de l’arrondissement",
      "À la préfecture de police",
      "Au tribunal judiciaire",
    ],
    answer: "À la préfecture de police",
    explanation:
        "À Paris, c’est la préfecture de police qui reçoit les déclarations de manifestations (art. L.211-1 C.S.I. et suivants).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Délai",
    question:
        "Le délai légal pour déposer une déclaration de manifestation est de :",
    options: [
      "Au moins 3 jours francs et au plus 15 jours francs avant la date",
      "Au moins 24 heures avant la date",
      "Exactement 30 jours avant la date",
    ],
    answer: "Au moins 3 jours francs et au plus 15 jours francs avant la date",
    explanation:
        "Ce délai permet à l’autorité d’anticiper et d’organiser les mesures nécessaires au maintien de l’ordre.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Exceptions",
    question:
        "Les manifestations traditionnelles à caractère folklorique ou religieux :",
    options: [
      "Sont en principe exemptées de déclaration préalable",
      "Sont automatiquement interdites",
      "Sont toujours soumises à un régime criminel",
    ],
    answer: "Sont en principe exemptées de déclaration préalable",
    explanation:
        "L’article L.211-1 C.S.I. réserve une exception pour certaines manifestations traditionnelles.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Organisateurs",
    question: "Les organisateurs d’une manifestation doivent être :",
    options: [
      "Majeurs et clairement identifiés dans la déclaration",
      "Obligatoirement des élus",
      "Uniquement des associations reconnues d’utilité publique",
    ],
    answer: "Majeurs et clairement identifiés dans la déclaration",
    explanation:
        "L’autorité doit pouvoir identifier des interlocuteurs responsables et joignables.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Récépissé",
    question:
        "Lorsqu’une déclaration de manifestation est déposée, l’autorité doit :",
    options: [
      "Remettre immédiatement un récépissé",
      "Conserver la déclaration secrète",
      "Transmettre automatiquement au juge d’instruction",
    ],
    answer: "Remettre immédiatement un récépissé",
    explanation:
        "Le récépissé atteste de la déclaration et pourra être présenté lors de contrôles.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Sanction organisateur",
    question:
        "Organiser une manifestation non déclarée ou interdite est puni :",
    options: [
      "D’un simple rappel à la loi",
      "De 6 mois d’emprisonnement et 7 500 € d’amende (art. 431-9 du Code Pénal.)",
      "D’une peine criminelle",
    ],
    answer:
        "De 6 mois d’emprisonnement et 7 500 € d’amende (art. 431-9 du Code Pénal.)",
    explanation:
        "Le Code pénal sanctionne sévèrement l’organisation d’une manifestation illégale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Attroupements – Nombre de personnes",
    question: "Pour qu’il y ait attroupement au sens de la loi pénale :",
    options: [
      "Il suffit d’un rassemblement de plusieurs personnes",
      "Il faut obligatoirement plus de 1 000 personnes",
      "Il faut au moins 100 personnes armées",
    ],
    answer: "Il suffit d’un rassemblement de plusieurs personnes",
    explanation:
        "Le texte ne fixe pas de seuil chiffré ; c’est l’aptitude à troubler l’ordre public qui caractérise l’attroupement.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Attroupements – Sommations",
    question:
        "Avant d’avoir recours à la force pour disperser un attroupement, il est en principe nécessaire :",
    options: [
      "D’effectuer deux sommations réglementaires",
      "D’attendre la tombée de la nuit",
      "De consulter un juge",
    ],
    answer: "D’effectuer deux sommations réglementaires",
    explanation:
        "L’article R.211-11 C.S.I. impose en principe deux sommations avant l’usage de la force.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Attroupements – Visage dissimulé",
    question:
        "Participer à un attroupement après sommations en dissimulant volontairement son visage :",
    options: [
      "N’a pas d’incidence",
      "Aggrave la peine encourue",
      "Est obligatoire pour tous les participants",
    ],
    answer: "Aggrave la peine encourue",
    explanation:
        "Les textes aggravent la répression lorsque la personne dissimule son visage pour échapper à l’identification.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Presse – Fondement constitutionnel",
    question: "La liberté de la presse trouve son principal fondement dans :",
    options: [
      "L’article 11 de la Déclaration de 1789",
      "L’article 16 de la Constitution de 1958",
      "Le Code de la route",
    ],
    answer: "L’article 11 de la Déclaration de 1789",
    explanation:
        "L’article 11 consacre la libre communication des pensées et des opinions, base de la liberté de la presse.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Presse – Grande loi",
    question: "La « charte » de la liberté de la presse en France est :",
    options: [
      "La loi du 29 juillet 1881",
      "La loi du 5 mars 2007",
      "L’ordonnance de 1944 uniquement",
    ],
    answer: "La loi du 29 juillet 1881",
    explanation:
        "Cette loi organise le régime libéral de la presse et les délits de presse.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Presse – Journalistes",
    question: "La carte d’identité de journaliste professionnel :",
    options: [
      "Est délivrée par une commission paritaire",
      "Est délivrée par la mairie",
      "Est automatiquement obtenue après un an de travail",
    ],
    answer: "Est délivrée par une commission paritaire",
    explanation:
        "Une commission composée de journalistes et d’éditeurs attribue la carte, selon des critères précis.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Presse – Délit de fausses nouvelles",
    question:
        "La publication de fausses nouvelles de nature à troubler la paix publique :",
    options: [
      "Est toujours sans sanction",
      "Constitue une infraction de presse prévue par la loi de 1881",
      "Relève du Code de la route",
    ],
    answer: "Constitue une infraction de presse prévue par la loi de 1881",
    explanation:
        "L’article 27 de la loi de 1881 réprime la diffusion de fausses nouvelles dangereuses pour la paix publique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Presse – Délai de prescription",
    question:
        "En matière de délits de presse, le délai de prescription « de droit commun » est :",
    options: ["De 3 mois", "De 2 ans", "De 10 ans"],
    answer: "De 3 mois",
    explanation:
        "Sauf cas particuliers (notamment faits à caractère raciste), les délits de presse se prescrivent par trois mois.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU MOYEN =====================
  QuizQuestion(
    category: "Manifestations – Contenu déclaration",
    question:
        "La déclaration préalable d’une manifestation doit notamment comporter :",
    options: [
      "Les seules coordonnées des journalistes présents",
      "L’identité des organisateurs, l’objet, le lieu, la date, l’horaire et, le cas échéant, l’itinéraire",
      "Une liste complète de tous les participants",
    ],
    answer:
        "L’identité des organisateurs, l’objet, le lieu, la date, l’horaire et, le cas échéant, l’itinéraire",
    explanation:
        "Ces informations permettent à l’autorité d’apprécier les risques et d’organiser le maintien de l’ordre.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Manifestations – Pouvoir de substitution",
    question:
        "Si le maire refuse d’interdire une manifestation alors que le risque de trouble grave est manifeste, le préfet :",
    options: [
      "Ne peut rien faire",
      "Peut se substituer à lui et prendre lui-même l’arrêté d’interdiction",
      "Doit saisir le Conseil constitutionnel",
    ],
    answer:
        "Peut se substituer à lui et prendre lui-même l’arrêté d’interdiction",
    explanation:
        "Le préfet peut se substituer au maire défaillant en matière de maintien de l’ordre (police administrative).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Manifestations – Contravention R.644-4 du Code Pénal.",
    question: "L’article R.644-4 du Code pénal vise :",
    options: [
      "Le simple fait de regarder une manifestation",
      "La participation à une manifestation interdite sur le fondement de l’article L.211-4 C.S.I.",
      "Le refus de lire le journal officiel",
    ],
    answer:
        "La participation à une manifestation interdite sur le fondement de l’article L.211-4 C.S.I.",
    explanation:
        "Cet article prévoit une contravention de 4 ème classe pour la participation à une manifestation interdite.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Manifestations – Peines complémentaires",
    question:
        "L’interdiction de participer à des manifestations sur la voie publique pour une durée maximale de 3 ans :",
    options: [
      "Ne peut jamais être prononcée",
      "Constitue une peine complémentaire possible (art. 131-32-1 du Code Pénal.)",
      "Est automatique pour toute personne interpellée",
    ],
    answer:
        "Constitue une peine complémentaire possible (art. 131-32-1 du Code Pénal.)",
    explanation:
        "Le juge peut l’ordonner pour certains délits commis lors de manifestations.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Manifestations – Responsabilité de l’État",
    question:
        "Les dommages causés lors de crimes ou délits commis à force ouverte ou par violence au cours d’une manifestation :",
    options: [
      "Ne donnent jamais lieu à indemnisation",
      "Engagent la responsabilité civile de l’État de plein droit (art. L.211-10 C.S.I.)",
      "Sont toujours exclusivement à la charge des communes",
    ],
    answer:
        "Engagent la responsabilité civile de l’État de plein droit (art. L.211-10 C.S.I.)",
    explanation:
        "L’État peut ensuite se retourner contre les auteurs, mais répond de plein droit vis-à-vis des victimes.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Attroupements – Textes applicables",
    question:
        "Le régime juridique des attroupements est principalement fixé par :",
    options: [
      "Les articles 431-3 à 431-8-1 du Code Pénal. et L.211-9 à L.211-10 C.S.I.",
      "Le Code de commerce",
      "Uniquement la loi de 1881",
    ],
    answer:
        "Les articles 431-3 à 431-8-1 du Code Pénal. et L.211-9 à L.211-10 C.S.I.",
    explanation:
        "Ces textes organisent définition, dispersion, infractions et réparation des dommages.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Attroupements – Nature politique",
    question:
        "Le fait que le délit d’attroupement soit qualifié de « délit politique » par la Cour de cassation :",
    options: [
      "Empêche toute poursuite",
      "Influe sur certains régimes (extradition, etc.) mais n’empêche pas la comparution immédiate",
      "Signifie qu’il relève des juridictions administratives",
    ],
    answer:
        "Influe sur certains régimes (extradition, etc.) mais n’empêche pas la comparution immédiate",
    explanation:
        "La loi a expressément prévu la possibilité des procédures rapides malgré cette qualification.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Attroupements – Insignes distinctifs",
    question:
        "Lors des sommations de dispersion, les autorités habilitées doivent :",
    options: [
      "Être en civil sans signe distinctif",
      "Porter des insignes distinctifs (écharpe ou brassard tricolore selon la fonction)",
      "Se masquer le visage",
    ],
    answer:
        "Porter des insignes distinctifs (écharpe ou brassard tricolore selon la fonction)",
    explanation:
        "L’article R.211-12 C.S.I. impose ces insignes pour matérialiser l’autorité civile qui procède aux sommations.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Attroupements – Participation armée",
    question:
        "Participer à un attroupement en étant porteur d’une arme (art. 431-5 du Code Pénal.) est puni :",
    options: [
      "D’une simple amende",
      "De 3 ans d’emprisonnement et 45 000 € d’amende, voire plus en cas de visage dissimulé",
      "Uniquement d’un travail d’intérêt général",
    ],
    answer:
        "De 3 ans d’emprisonnement et 45 000 € d’amende, voire plus en cas de visage dissimulé",
    explanation:
        "Le texte prévoit une aggravation si le visage est dissimulé après sommations.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Transparence capitalistique",
    question:
        "Les règles de transparence des entreprises de presse visant à identifier actionnaires et dirigeants ont pour but principal :",
    options: [
      "D’organiser un contrôle policier permanent",
      "De permettre au lecteur de connaître les intérêts en présence et de garantir le pluralisme",
      "De fixer les prix de vente des journaux",
    ],
    answer:
        "De permettre au lecteur de connaître les intérêts en présence et de garantir le pluralisme",
    explanation:
        "La transparence est un outil de protection de la liberté d’expression et du pluralisme.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Clause de conscience",
    question: "La clause de conscience permet au journaliste :",
    options: [
      "De refuser tout contrôle hiérarchique",
      "De rompre son contrat avec des indemnités majorées en cas de changement notable de la ligne du journal portant atteinte à ses intérêts moraux",
      "De s’opposer à toute sanction disciplinaire",
    ],
    answer:
        "De rompre son contrat avec des indemnités majorées en cas de changement notable de la ligne du journal portant atteinte à ses intérêts moraux",
    explanation:
        "Elle protège l’indépendance morale du journaliste en cas de cession ou de changement de ligne éditoriale.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Entreprise de presse",
    question:
        "Les règles limitant les investissements étrangers dans les entreprises de presse ont pour objectif :",
    options: [
      "D’empêcher tout financement",
      "De préserver l’indépendance nationale de l’information",
      "De favoriser les monopoles privés",
    ],
    answer: "De préserver l’indépendance nationale de l’information",
    explanation:
        "Elles visent à éviter que des puissances étrangères contrôlent des organes d’information stratégique.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Secret des sources (limites)",
    question: "Le secret des sources des journalistes peut être levé :",
    options: [
      "Uniquement pour convenance de la police",
      "En présence d’un impératif prépondérant d’intérêt public, par des mesures nécessaires et proportionnées",
      "Jamais, en aucune circonstance",
    ],
    answer:
        "En présence d’un impératif prépondérant d’intérêt public, par des mesures nécessaires et proportionnées",
    explanation:
        "C’est l’équilibre recherché par la loi et la jurisprudence entre liberté de la presse et exigences de la justice.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Responsabilité en cascade",
    question:
        "En matière de délits de presse, la personne principalement responsable est :",
    options: [
      "Le directeur de la publication pour les écrits périodiques",
      "Le vendeur de journaux",
      "Le lecteur",
    ],
    answer: "Le directeur de la publication pour les écrits périodiques",
    explanation:
        "La loi de 1881 organise un système de responsabilité dite « en cascade » qui commence par le directeur de publication.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Publication jeunesse",
    question:
        "Lorsqu’un juge ordonne la saisie d’une publication dangereuse pour la jeunesse (incitation à la violence, pornographie) :",
    options: [
      "Il porte atteinte à la liberté de la presse mais dans le cadre des limites prévues par la loi",
      "Il viole automatiquement la Constitution",
      "Il doit saisir le Conseil de sécurité de l’ONU",
    ],
    answer:
        "Il porte atteinte à la liberté de la presse mais dans le cadre des limites prévues par la loi",
    explanation:
        "La liberté de la presse n’est pas absolue ; elle est conciliée avec la protection des mineurs et de l’ordre public.",
    difficulty: "Moyenne",
  ),

  // ===================== NIVEAU DIFFICILE (inclut Expert) =====================
  QuizQuestion(
    category: "Manifestations – Mesures préventives",
    question:
        "L’article L.211-3 C.S.I. autorisant l’interdiction temporaire du port d’objets pouvant constituer une arme par destination suppose :",
    options: [
      "Un simple souhait du préfet",
      "L’existence de risques sérieux de troubles graves à l’ordre public dans un périmètre et une durée déterminés",
      "Qu’un crime ait déjà été commis",
    ],
    answer:
        "L’existence de risques sérieux de troubles graves à l’ordre public dans un périmètre et une durée déterminés",
    explanation:
        "La mesure doit être justifiée, ciblée et proportionnée au risque anticipé.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Manifestations – Réquisitions 78-2-5 CPP",
    question:
        "Les réquisitions du procureur de la République fondées sur l’article 78-2-5 CPP lors d’une manifestation doivent :",
    options: [
      "Pouvoir être orales et générales",
      "Être écrites, préciser les lieux, la durée et les infractions visées (ex. port d’armes lors d’une réunion publique)",
      "Être validées par le Conseil constitutionnel",
    ],
    answer:
        "Être écrites, préciser les lieux, la durée et les infractions visées (ex. port d’armes lors d’une réunion publique)",
    explanation:
        "Elles encadrent les contrôles de bagages ou de véhicules, pour garantir le respect des libertés individuelles.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Manifestations – État d’urgence & contrôle",
    question:
        "Même en état d’urgence ou régime d’exception, les interdictions générales de manifester :",
    options: [
      "Échappent à tout contrôle juridictionnel",
      "Restent contrôlées par le juge administratif (nécessité, proportionnalité, adaptation)",
      "Sont décidées exclusivement par le président du Sénat",
    ],
    answer:
        "Restent contrôlées par le juge administratif (nécessité, proportionnalité, adaptation)",
    explanation:
        "Les juridictions administratives veillent à la conciliation entre sauvegarde de l’ordre public et libertés fondamentales.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Attroupements – Article 431-4 du Code Pénal.",
    question:
        "Pour que l’infraction de participation à un attroupement après sommations (art. 431-4 du Code Pénal.) soit constituée, il faut notamment :",
    options: [
      "Que la personne soit restée volontairement après les sommations et qu’elles aient été régulièrement faites",
      "Qu’il y ait au moins 500 personnes",
      "Que les forces de l’ordre soient armées",
    ],
    answer:
        "Que la personne soit restée volontairement après les sommations et qu’elles aient été régulièrement faites",
    explanation:
        "La preuve des sommations et de la présence persistante de la personne est centrale pour la qualification.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Attroupements – Article 431-6 du Code Pénal.",
    question:
        "La provocation directe à un attroupement armé réprimée par l’article 431-6 du Code Pénal. vise :",
    options: [
      "Uniquement les discours prononcés dans une salle fermée",
      "Les discours, écrits ou tout autre moyen de communication publique",
      "Uniquement les tracts distribués dans la rue",
    ],
    answer:
        "Les discours, écrits ou tout autre moyen de communication publique",
    explanation:
        "Le champ est large et inclut les différents vecteurs de diffusion, y compris modernes (réseaux sociaux).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Attroupements – Documentation pour l’action récursoire",
    question:
        "En vue de l’action récursoire de l’État après des dégradations commises lors d’attroupements, les forces de l’ordre doivent :",
    options: [
      "Se limiter à un compte-rendu très succinct",
      "Réaliser des constatations détaillées (photos, vidéos, descriptions), identités, et les consigner avec précision",
      "Ne conserver aucune trace pour préserver la paix sociale",
    ],
    answer:
        "Réaliser des constatations détaillées (photos, vidéos, descriptions), identités, et les consigner avec précision",
    explanation:
        "La qualité des procès-verbaux conditionne la possibilité pour l’État d’agir contre les auteurs.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Attroupements – Usage des armes non létales",
    question:
        "L’usage de certaines armes non létales (ex. LBD, grenades de désencerclement) dans le cadre des attroupements :",
    options: [
      "Peut intervenir seulement après sommations, sauf cas d’urgence définis par la loi",
      "Est entièrement discrétionnaire",
      "Ne fait l’objet d’aucune traçabilité",
    ],
    answer:
        "Peut intervenir seulement après sommations, sauf cas d’urgence définis par la loi",
    explanation:
        "L’usage est encadré par le C.S.I. (nécessité, proportionnalité, procédure) et doit pouvoir être justifié.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Pluralisme (C. const.)",
    question:
        "Le Conseil constitutionnel a érigé le pluralisme des courants d’expression en :",
    options: [
      "Principe à valeur simplement réglementaire",
      "Objectif et principe à valeur constitutionnelle",
      "Principe sans portée juridique",
    ],
    answer: "Objectif et principe à valeur constitutionnelle",
    explanation:
        "Les décisions notamment de 1984 et 1986 reconnaissent au pluralisme une valeur constitutionnelle forte.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Décision de 1984",
    question:
        "Dans sa décision du 11 octobre 1984, le Conseil constitutionnel a particulièrement insisté sur :",
    options: [
      "Le rôle du Conseil d’État dans la censure",
      "La nécessité de la transparence des organes de presse pour garantir la liberté d’opinion",
      "L’interdiction totale de la publicité",
    ],
    answer:
        "La nécessité de la transparence des organes de presse pour garantir la liberté d’opinion",
    explanation:
        "La transparence permet au public de mesurer les influences qui pèsent sur l’information.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Perquisitions (magistrat)",
    question:
        "En matière de perquisitions dans les locaux de presse, il est exigé que :",
    options: [
      "Elles soient décidées et dirigées par un magistrat spécifiant l’infraction et les documents recherchés",
      "Elles soient faites uniquement sur ordre oral d’un policier",
      "Elles soient systématiquement nocturnes",
    ],
    answer:
        "Elles soient décidées et dirigées par un magistrat spécifiant l’infraction et les documents recherchés",
    explanation:
        "Cette exigence renforce les garanties entourant la liberté de la presse et le secret des sources.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Diffamation/non public",
    question:
        "La diffamation non publique (par exemple dans un courrier privé) :",
    options: [
      "Relève d’un régime de contravention distinct de la diffamation publique",
      "Est plus sévèrement punie que la diffamation publique",
      "N’est pas réprimée du tout",
    ],
    answer:
        "Relève d’un régime de contravention distinct de la diffamation publique",
    explanation:
        "La publicité est un élément aggravant ; son absence entraîne un régime contraventionnel.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Apologie / provocation",
    question: "Les articles 23 et 24 de la loi de 1881 répriment notamment :",
    options: [
      "Les seules erreurs typographiques",
      "La provocation et l’apologie de certains crimes et délits, notamment terroristes ou contre l’humanité",
      "La critique politique pacifique",
    ],
    answer:
        "La provocation et l’apologie de certains crimes et délits, notamment terroristes ou contre l’humanité",
    explanation:
        "La loi encadre fermement les discours de haine ou de glorification de crimes graves.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Injure discriminatoire",
    question: "L’injure publique à caractère raciste ou discriminatoire :",
    options: [
      "Est moins gravement sanctionnée qu’une injure simple",
      "Bénéficie d’un délai de prescription allongé et de peines aggravées",
      "N’est pas visée par la loi de 1881",
    ],
    answer:
        "Bénéficie d’un délai de prescription allongé et de peines aggravées",
    explanation:
        "Le législateur a renforcé la répression des propos discriminatoires, y compris sur la durée de prescription.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Équilibre enquête / sources",
    question:
        "Lorsqu’un enquêteur doit entendre un journaliste sur une affaire en cours, il doit :",
    options: [
      "Lui demander systématiquement l’identité de ses sources",
      "Concilier la recherche de la vérité avec le respect du secret des sources et des garanties procédurales",
      "Refuser de l’entendre",
    ],
    answer:
        "Concilier la recherche de la vérité avec le respect du secret des sources et des garanties procédurales",
    explanation:
        "La liberté de la presse impose un équilibre subtil entre besoin d’enquête et protection des sources.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Rôle pratique du policier",
    question:
        "Pour un policier sur la voie publique, filmer ou photographier des journalistes en action lors d’une manifestation :",
    options: [
      "Est toujours interdit",
      "Peut être justifié pour les besoins probatoires, mais ne doit pas servir à intimider ou entraver la liberté de la presse",
      "Est obligatoire pour tous les journalistes",
    ],
    answer:
        "Peut être justifié pour les besoins probatoires, mais ne doit pas servir à intimider ou entraver la liberté de la presse",
    explanation:
        "La captation d’images doit rester proportionnée, justifiée et respectueuse des libertés fondamentales.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Manifestations – Contraventions",
    question:
        "La participation à une manifestation interdite sur le fondement de l’article L.211-4 C.S.I. peut être sanctionnée :",
    options: [
      "Par une contravention de 4 ème classe",
      "Uniquement par un avertissement verbal",
      "Par une peine criminelle",
    ],
    answer: "Par une contravention de 4 ème classe",
    explanation:
        "L’article R.644-4 du Code Pénal. prévoit une contravention de 4 ème classe pour la participation à une manifestation interdite.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Notion d’ordre public",
    question:
        "Lorsqu’il apprécie la légalité d’une manifestation, le préfet doit notamment tenir compte :",
    options: [
      "De la couleur politique des organisateurs",
      "Des risques d’atteinte à l’ordre public (sécurité, tranquillité, salubrité)",
      "Du nombre de journalistes présents",
    ],
    answer:
        "Des risques d’atteinte à l’ordre public (sécurité, tranquillité, salubrité)",
    explanation:
        "Le pouvoir de police administrative générale vise le maintien de l’ordre public, non la censure d’opinions.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – État d’urgence / régime exceptionnel",
    question:
        "En période d’état d’urgence ou de régime exceptionnel, les pouvoirs de police :",
    options: [
      "Peuvent être significativement renforcés (couvre-feux, interdictions générales, etc.)",
      "Sont supprimés",
      "Sont exercés uniquement par les juges",
    ],
    answer:
        "Peuvent être significativement renforcés (couvre-feux, interdictions générales, etc.)",
    explanation:
        "Les régimes d’exception permettent des restrictions plus fortes aux libertés publiques, sous contrôle du juge.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Attroupements – Voie publique",
    question: "Un attroupement suppose un rassemblement :",
    options: [
      "Sur la voie publique ou dans un lieu public",
      "Uniquement dans un domicile privé",
      "Uniquement à la télévision",
    ],
    answer: "Sur la voie publique ou dans un lieu public",
    explanation:
        "La notion d’attroupement vise les espaces publics, susceptibles de troubler l’ordre public.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Attroupements – Troubles effectifs",
    question:
        "Pour qu’il y ait attroupement au sens de l’article 431-3 du Code Pénal., il est :",
    options: [
      "Indispensable qu’il y ait déjà des violences commises",
      "Suffisant qu’il y ait un risque ou une menace de troubles à l’ordre public",
      "Nécessaire que les manifestants soient armés",
    ],
    answer:
        "Suffisant qu’il y ait un risque ou une menace de troubles à l’ordre public",
    explanation:
        "La simple susceptibilité de trouble suffit : il n’est pas exigé que des violences soient déjà réalisées.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Attroupements – Sommations",
    question:
        "La formule traditionnellement utilisée lors des sommations de dispersion est introduite par :",
    options: [
      "« Attention ! Attention ! Obéissance à la loi. Dispersez-vous. »",
      "« Peuple de France, écoutez-moi. »",
      "« Silence dans les rangs. »",
    ],
    answer: "« Attention ! Attention ! Obéissance à la loi. Dispersez-vous. »",
    explanation:
        "Cette formule, ou toute formule équivalente rappelant la loi et la nécessité de se disperser, est utilisée pour matérialiser les sommations.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Attroupements – Participation après sommations",
    question:
        "Après les sommations réglementaires, les personnes qui restent volontairement dans l’attroupement :",
    options: [
      "Prennent le risque de commettre un délit",
      "Sont automatiquement considérées comme victimes",
      "Ne peuvent pas être poursuivies",
    ],
    answer: "Prennent le risque de commettre un délit",
    explanation:
        "Rester dans un attroupement après sommations constitue le délit visé par l’article 431-4 du Code Pénal.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Attroupements – Port d’arme",
    question: "Participer à un attroupement en étant porteur d’une arme :",
    options: [
      "Est plus sévèrement puni qu’en étant non armé",
      "N’a aucune incidence sur la peine",
      "Est autorisé si l’arme est déclarée",
    ],
    answer: "Est plus sévèrement puni qu’en étant non armé",
    explanation:
        "L’article 431-5 du Code Pénal. aggrave la répression lorsque le participant est porteur d’une arme.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Presse – 4ème pouvoir",
    question: "La presse est parfois qualifiée de « 4 ème pouvoir » car :",
    options: [
      "Elle fait partie officiellement des pouvoirs constitutionnels",
      "Elle joue un rôle de contrôle et de critique des pouvoirs publics",
      "Elle commande directement la police",
    ],
    answer: "Elle joue un rôle de contrôle et de critique des pouvoirs publics",
    explanation:
        "En informant, dénonçant et analysant, la presse influence durablement l’opinion et contrôle symboliquement les pouvoirs institués.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Presse – Délits de presse",
    question:
        "Les infractions commises par voie de presse (injure, diffamation, etc.) sont régies principalement par :",
    options: [
      "Le Code du travail",
      "La loi du 29 juillet 1881",
      "Le Code de la défense",
    ],
    answer: "La loi du 29 juillet 1881",
    explanation:
        "La plupart des infractions commises par voie de presse trouvent leur régime spécifique dans la loi de 1881.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Presse – Injure publique",
    question: "L’injure publique se définit comme :",
    options: [
      "Une allégation d’un fait précis",
      "Une expression outrageante, terme de mépris ou invective ne renfermant l’imputation d’aucun fait",
      "Une simple critique politique",
    ],
    answer:
        "Une expression outrageante, terme de mépris ou invective ne renfermant l’imputation d’aucun fait",
    explanation:
        "L’injure vise le propos dégradant, sans fait précis susceptible de preuve, contrairement à la diffamation.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Presse – Diffamation",
    question: "La diffamation suppose :",
    options: [
      "Une appréciation purement subjective",
      "L’allégation ou l’imputation d’un fait précis portant atteinte à l’honneur ou à la considération",
      "Une simple caricature humoristique",
    ],
    answer:
        "L’allégation ou l’imputation d’un fait précis portant atteinte à l’honneur ou à la considération",
    explanation:
        "Il faut un fait déterminé, susceptible de débat probatoire, pour caractériser la diffamation.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Presse – Personnes protégées",
    question:
        "Les injures ou diffamations visant un agent public dans l’exercice de ses fonctions :",
    options: [
      "Sont plus sévèrement réprimées",
      "Sont dépourvues d’importance juridique",
      "Ne peuvent jamais être poursuivies",
    ],
    answer: "Sont plus sévèrement réprimées",
    explanation:
        "La loi de 1881 prévoit des circonstances aggravantes lorsque la victime est dépositaire de l’autorité publique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Presse – Jeunesse",
    question: "Les publications destinées à la jeunesse :",
    options: [
      "Ne font l’objet d’aucun contrôle particulier",
      "Peuvent être encadrées plus strictement pour éviter les contenus violents, pornographiques ou discriminatoires",
      "Doivent toujours être validées par le ministre de l’Éducation",
    ],
    answer:
        "Peuvent être encadrées plus strictement pour éviter les contenus violents, pornographiques ou discriminatoires",
    explanation:
        "La loi protège particulièrement les mineurs face à certains contenus susceptibles de les heurter.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU MOYEN =====================
  QuizQuestion(
    category: "Manifestations – Multi-communes",
    question:
        "Lorsque le cortège d’une manifestation doit traverser plusieurs communes :",
    options: [
      "Une seule déclaration au ministère suffit",
      "Chacune des mairies concernées doit être saisie",
      "Seule la préfecture de région est compétente",
    ],
    answer: "Chacune des mairies concernées doit être saisie",
    explanation:
        "Chaque autorité de police municipale concernée doit être informée, pour adapter les mesures de maintien de l’ordre.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Manifestations – Notification interdiction",
    question: "Une décision d’interdiction de manifestation doit :",
    options: [
      "Toujours être publiée au Journal officiel",
      "Être notifiée aux organisateurs par un OPJ ou tout agent mandaté, ou rendue publique par tous moyens si nécessaire",
      "Être annoncée uniquement sur les réseaux sociaux",
    ],
    answer:
        "Être notifiée aux organisateurs par un OPJ ou tout agent mandaté, ou rendue publique par tous moyens si nécessaire",
    explanation:
        "La notification peut être individuelle ou, si ce n’est pas possible, réalisée par voie d’affichage ou autre moyen public.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Manifestations – Référé",
    question: "Un arrêté d’interdiction de manifestation peut être contesté :",
    options: [
      "Uniquement devant la Cour de cassation",
      "Par un référé devant le tribunal administratif",
      "Uniquement par un recours hiérarchique auprès du préfet",
    ],
    answer: "Par un référé devant le tribunal administratif",
    explanation:
        "Le juge administratif, saisi en urgence, contrôle la réalité du risque et la proportionnalité de l’interdiction.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Manifestations – Interdiction d’objets",
    question:
        "L’interdiction temporaire de port d’objets pouvant constituer une arme par destination (L.211-3 C.S.I.) vise :",
    options: [
      "Un périmètre déterminé et une durée limitée",
      "Tout le territoire national sans limite de temps",
      "Uniquement les locaux privés",
    ],
    answer: "Un périmètre déterminé et une durée limitée",
    explanation:
        "La mesure doit être ciblée dans l’espace et le temps, en lien avec le risque identifié.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Manifestations – Outrage au drapeau",
    question:
        "L’outrage public au drapeau tricolore lors d’une manifestation est :",
    options: [
      "Une simple incivilité sans sanction",
      "Une infraction punie d’amende, aggravée en cas de commission en réunion",
      "Toujours un crime",
    ],
    answer:
        "Une infraction punie d’amende, aggravée en cas de commission en réunion",
    explanation:
        "L’article 433-5-1 du Code Pénal. réprime l’outrage au drapeau ou à l’hymne national, notamment en réunion.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Attroupements – Autorités habilitées",
    question:
        "Parmi les autorités suivantes, laquelle peut être habilitée à procéder aux sommations de dispersion :",
    options: [
      "Le directeur de cabinet du préfet dûment mandaté",
      "Le président du tribunal judiciaire",
      "Tout agent de police municipale",
    ],
    answer: "Le directeur de cabinet du préfet dûment mandaté",
    explanation:
        "Outre le préfet, certaines autorités comme le directeur de cabinet, les maires, ou certains officiers de police peuvent être habilitées.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Attroupements – Signal visuel/sonore",
    question:
        "Lorsque l’usage d’un haut-parleur est impossible lors des sommations :",
    options: [
      "Les sommations sont inutiles",
      "Un signal sonore ou visuel (par exemple fusée) peut compléter ou remplacer l’annonce",
      "Il faut attendre le lendemain pour disperser",
    ],
    answer:
        "Un signal sonore ou visuel (par exemple fusée) peut compléter ou remplacer l’annonce",
    explanation:
        "Le texte prévoit la possibilité d’employer d’autres moyens pour matérialiser les sommations.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Attroupements – Proportionnalité",
    question:
        "En matière de dispersion d’attroupements, la proportionnalité de la force signifie que :",
    options: [
      "La force doit être strictement adaptée au trouble à faire cesser",
      "Il faut toujours utiliser toutes les armes disponibles",
      "La force peut être utilisée même après la fin du trouble",
    ],
    answer: "La force doit être strictement adaptée au trouble à faire cesser",
    explanation:
        "La force doit cesser lorsque le trouble disparaît et ne peut excéder ce qui est nécessaire pour rétablir l’ordre.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Attroupements – Procès-verbal",
    question:
        "En cas d’interpellation lors d’un attroupement, il est essentiel de mentionner dans le procès-verbal :",
    options: [
      "La couleur des vêtements de tous les manifestants",
      "Les sommations effectuées, la situation de la personne (présente après sommations, armée ou non, visage dissimulé ou non)",
      "Les opinions politiques supposées de l’intéressé",
    ],
    answer:
        "Les sommations effectuées, la situation de la personne (présente après sommations, armée ou non, visage dissimulé ou non)",
    explanation:
        "Ces éléments conditionnent la qualification pénale (431-4, 431-5, 431-6 du Code Pénal.) et la solidité du dossier.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Attroupements – Responsabilité de l’État",
    question:
        "L’article L.211-10 C.S.I. concernant les attroupements prévoit une responsabilité :",
    options: [
      "Sans faute de l’État pour certains dommages causés par crimes ou délits commis à force ouverte ou par violence",
      "Uniquement en cas de faute lourde des forces de l’ordre",
      "Uniquement en cas de manifestation autorisée",
    ],
    answer:
        "Sans faute de l’État pour certains dommages causés par crimes ou délits commis à force ouverte ou par violence",
    explanation:
        "La responsabilité de plein droit de l’État permet aux victimes d’être indemnisées, l’État pouvant ensuite exercer un recours.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Création d’un journal",
    question: "Pour créer un journal au regard de la loi de 1881, il faut :",
    options: [
      "Une autorisation préalable du préfet",
      "Une simple déclaration, sans autorisation ni cautionnement",
      "L’accord du Conseil constitutionnel",
    ],
    answer: "Une simple déclaration, sans autorisation ni cautionnement",
    explanation:
        "La loi de 1881 consacre un régime très libéral pour la création d’un journal.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Directeur de publication",
    question: "Le directeur de la publication d’un journal :",
    options: [
      "N’a aucune responsabilité pénale",
      "Est la personne pénalement responsable en premier lieu des infractions de presse",
      "Est uniquement responsable de la mise en page",
    ],
    answer:
        "Est la personne pénalement responsable en premier lieu des infractions de presse",
    explanation:
        "Le système de responsabilité en cascade place le directeur de publication au premier rang.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Secret des sources et témoignage",
    question:
        "Lorsqu’un journaliste est entendu comme témoin sur des faits révélés par ses articles :",
    options: [
      "Il est tenu de divulguer systématiquement ses sources",
      "Il peut refuser de révéler l’identité de ses sources, sauf cas strictement encadrés",
      "Il doit prêter serment de révéler toute information",
    ],
    answer:
        "Il peut refuser de révéler l’identité de ses sources, sauf cas strictement encadrés",
    explanation:
        "La protection des sources est un élément central de la liberté de la presse, rappelée par la CEDH et la Cour de cassation.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Pluralisme et concentration",
    question:
        "Les règles limitant les concentrations d’entreprises de presse visent avant tout à :",
    options: [
      "Protéger la rentabilité des entreprises",
      "Garantir le pluralisme des courants d’expression",
      "Limiter les exportations de journaux à l’étranger",
    ],
    answer: "Garantir le pluralisme des courants d’expression",
    explanation:
        "Le pluralisme est un objectif de valeur constitutionnelle ; les règles de concentration visent à éviter des situations de monopole d’information.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Aides publiques",
    question:
        "Les aides publiques à la presse (fiscales, postales, directes) soulèvent notamment la question :",
    options: [
      "De l’indépendance réelle de la presse vis-à-vis du pouvoir politique",
      "De la suppression de toute liberté éditoriale",
      "De la nationalisation obligatoire des journaux",
    ],
    answer:
        "De l’indépendance réelle de la presse vis-à-vis du pouvoir politique",
    explanation:
        "Si les aides visent le pluralisme, elles interrogent aussi sur la dépendance financière à l’égard de l’État.",
    difficulty: "Moyenne",
  ),

  // ===================== NIVEAU DIFFICILE (inclut Expert) =====================
  QuizQuestion(
    category: "Manifestations – Réquisitions 78-2-5 CPP",
    question:
        "Les réquisitions fondées sur l’article 78-2-5 CPP lors d’une manifestation doivent notamment :",
    options: [
      "Être générales et permanentes sur tout le territoire",
      "Préciser le périmètre, la durée et la nature des contrôles (bagages, véhicules, etc.)",
      "Être orales et non écrites",
    ],
    answer:
        "Préciser le périmètre, la durée et la nature des contrôles (bagages, véhicules, etc.)",
    explanation:
        "Le procureur doit détailler le cadre spatial, temporel et matériel des contrôles pour respecter la proportionnalité.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Manifestations – Contrôle d’identité préventif",
    question:
        "Les contrôles d’identité aux abords d’une manifestation sur le fondement de l’art. 78-2 al. 8 CPP sont possibles :",
    options: [
      "Sans limite de temps ni de lieu",
      "Dans des lieux et pour une durée déterminés, en cas de risque d’atteinte à l’ordre public",
      "Uniquement si un délit a déjà été commis",
    ],
    answer:
        "Dans des lieux et pour une durée déterminés, en cas de risque d’atteinte à l’ordre public",
    explanation:
        "Il s’agit de contrôles préventifs encadrés, justifiés par des risques d’atteintes aux personnes et aux biens.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Manifestations – État de siège / état d’urgence",
    question:
        "En état de siège ou d’urgence, certaines mesures comme la censure de la presse et l’interdiction généralisée de manifestations :",
    options: [
      "Sont automatiquement applicables sans texte",
      "Nécessitent un fondement légal spécifique et restent soumises au contrôle du juge",
      "Sont décidées exclusivement par les maires",
    ],
    answer:
        "Nécessitent un fondement légal spécifique et restent soumises au contrôle du juge",
    explanation:
        "Même en régime d’exception, les limitations aux libertés doivent se fonder sur la loi et restent contrôlées par les juridictions.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Attroupements – Délit politique",
    question:
        "La qualification de « délit politique » du délit d’attroupement (431-4 du Code Pénal.) par la Cour de cassation implique notamment :",
    options: [
      "Qu’il est jugé par des juridictions spéciales",
      "Qu’il bénéficie de certains régimes particuliers (extradition, etc.), sans faire obstacle aux procédures pénales rapides",
      "Qu’il ne peut jamais faire l’objet d’une comparution immédiate",
    ],
    answer:
        "Qu’il bénéficie de certains régimes particuliers (extradition, etc.), sans faire obstacle aux procédures pénales rapides",
    explanation:
        "La loi a précisément prévu la compatibilité de ce caractère politique avec les procédures prévues aux art. 393 à 397-7 et 495-7 à 495-15-1 CPP.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Attroupements – Usage des armes réglementé",
    question:
        "Les armes susceptibles d’être utilisées dans le cadre de la dispersion d’attroupements sont listées :",
    options: [
      "Dans l’article D.211-17 du Code de la sécurité intérieure",
      "Uniquement dans le Code pénal",
      "Dans la loi de 1881",
    ],
    answer: "Dans l’article D.211-17 du Code de la sécurité intérieure",
    explanation:
        "Cet article énumère les armes (grenades à effet sonore, lacrymogènes, LBD, etc.) utilisables dans ce cadre.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Attroupements – Usage immédiat de la force",
    question:
        "L’article L.211-9 C.S.I. permet de faire usage immédiatement de la force, sans attendre l’issue des sommations, lorsque :",
    options: [
      "Les forces de l’ordre subissent des violences ou que des lieux stratégiques sont menacés",
      "Les manifestants chantent trop fort",
      "Il pleut fortement",
    ],
    answer:
        "Les forces de l’ordre subissent des violences ou que des lieux stratégiques sont menacés",
    explanation:
        "Il s’agit de situations d’urgence où la sécurité des forces ou de certains lieux ne permet plus de suivre intégralement la procédure ordinaire.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Attroupements – Provocation et responsabilité",
    question:
        "En cas de provocation à un attroupement armé (art. 431-6 du Code Pénal.), la responsabilité pénale :",
    options: [
      "Ne peut être retenue qu’en présence d’une arme à feu",
      "Peut être engagée même si la provocation n’a pas été suivie d’effet, mais avec une peine moindre",
      "Suppose toujours une atteinte à la vie",
    ],
    answer:
        "Peut être engagée même si la provocation n’a pas été suivie d’effet, mais avec une peine moindre",
    explanation:
        "La peine est aggravée lorsque l’attroupement armé a effectivement eu lieu, mais l’infraction existe déjà au stade de la simple provocation.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Secret des sources (principe)",
    question:
        "Selon la jurisprudence de la CEDH, la protection des sources des journalistes est :",
    options: [
      "Un simple privilège que le législateur peut supprimer facilement",
      "Une pierre angulaire de la liberté de la presse",
      "Une mesure réservée aux journalistes de service public",
    ],
    answer: "Une pierre angulaire de la liberté de la presse",
    explanation:
        "La Cour européenne rappelle régulièrement que la protection des sources est essentielle à la liberté journalistique.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Perquisitions nulles",
    question:
        "Une perquisition irrégulière dans les locaux d’un organe de presse :",
    options: [
      "N’a aucune conséquence",
      "Peut entraîner la nullité des actes et des saisies qui en découlent",
      "Est automatiquement validée après coup par le procureur",
    ],
    answer:
        "Peut entraîner la nullité des actes et des saisies qui en découlent",
    explanation:
        "Le non-respect des garanties légales en matière de perquisitions peut conduire à l’annulation des actes.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Publication d’informations secrètes",
    question:
        "La publication d’informations relatives à la défense nationale ou au secret de l’instruction :",
    options: [
      "Est toujours libre au nom du droit à l’information",
      "Peut constituer une infraction spécifique réprimée par la loi de 1881 et le Code pénal",
      "N’est sanctionnée que moralement",
    ],
    answer:
        "Peut constituer une infraction spécifique réprimée par la loi de 1881 et le Code pénal",
    explanation:
        "Plusieurs textes encadrent la diffusion d’informations sensibles, notamment pour protéger la défense nationale et le bon déroulement de la justice.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Droit de réponse",
    question: "La personne mise en cause par un article de presse dispose :",
    options: [
      "D’un droit de réponse permettant de faire publier sa version des faits",
      "Uniquement du droit de porter plainte pénale",
      "D’aucun moyen spécifique de réaction",
    ],
    answer:
        "D’un droit de réponse permettant de faire publier sa version des faits",
    explanation:
        "La loi de 1881 organise le droit de réponse, en plus des actions civiles ou pénales éventuelles.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Délais de prescription raciste",
    question:
        "Pourquoi le législateur a-t-il allongé à un an la prescription pour certains délits de presse à caractère raciste ou discriminatoire ?",
    options: [
      "Parce qu’ils sont considérés comme particulièrement graves et parfois difficiles à poursuivre rapidement",
      "Pour simplifier la tâche des auteurs",
      "Pour éviter la plainte des victimes",
    ],
    answer:
        "Parce qu’ils sont considérés comme particulièrement graves et parfois difficiles à poursuivre rapidement",
    explanation:
        "Le délai plus long permet un traitement plus effectif de ces infractions, en tenant compte de leur gravité.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Intervention policière en rédaction",
    question:
        "Lorsqu’un policier intervient dans les locaux d’un média sur réquisition judiciaire, il doit veiller :",
    options: [
      "À exiger toutes les notes des journalistes sans distinction",
      "À limiter son intervention aux éléments visés par la réquisition, en respectant la liberté de la presse et le secret des sources",
      "À interroger tous les journalistes sur leurs sources",
    ],
    answer:
        "À limiter son intervention aux éléments visés par la réquisition, en respectant la liberté de la presse et le secret des sources",
    explanation:
        "Toute intervention dans un média est sensible : l’agent doit strictement respecter le cadre légal fixé par la réquisition et les garanties protectrices.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Manifestations – Définition",
    question:
        "Une manifestation sur la voie publique se caractérise principalement par :",
    options: [
      "Une occupation momentanée de la voie publique par un rassemblement statique ou mobile",
      "Toute réunion dans un local privé",
      "Tout échange sur les réseaux sociaux",
    ],
    answer:
        "Une occupation momentanée de la voie publique par un rassemblement statique ou mobile",
    explanation:
        "On entend généralement par manifestation l’occupation momentanée de la voie publique par un rassemblement statique ou mobile (cortège), à caractère revendicatif, festif ou protestataire.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Liberté fondamentale",
    question:
        "La liberté de manifester est principalement rattachée en droit français :",
    options: [
      "À la liberté d’entreprendre",
      "À la liberté d’expression et aux libertés publiques à valeur constitutionnelle",
      "Au droit de propriété",
    ],
    answer:
        "À la liberté d’expression et aux libertés publiques à valeur constitutionnelle",
    explanation:
        "La manifestation est un mode collectif d’exercice de la liberté d’expression, reconnue comme principe à valeur constitutionnelle.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Déclaration",
    question:
        "Selon l’article L.211-1 du C.S.I., les cortèges et rassemblements sur la voie publique :",
    options: [
      "Doivent faire l’objet d’une déclaration préalable",
      "Nécessitent toujours une autorisation écrite du préfet",
      "Ne sont soumis à aucune formalité",
    ],
    answer: "Doivent faire l’objet d’une déclaration préalable",
    explanation:
        "L’article L.211-1 du Code de la sécurité intérieure soumet les cortèges, défilés et rassemblements sur la voie publique à une obligation de déclaration préalable.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Exceptions",
    question:
        "Parmi les manifestations suivantes, laquelle est en principe dispensée de déclaration préalable ?",
    options: [
      "Les cortèges revendicatifs sur la voie publique",
      "Les manifestations traditionnelles à caractère folklorique ou religieux",
      "Les rassemblements politiques devant une préfecture",
    ],
    answer:
        "Les manifestations traditionnelles à caractère folklorique ou religieux",
    explanation:
        "L’article L.211-1 C.S.I. prévoit une exception pour certaines manifestations traditionnelles à caractère folklorique ou religieux.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Autorité compétente",
    question:
        "À Paris, l’autorité compétente pour recevoir la déclaration préalable de manifestation est :",
    options: [
      "Le maire de l’arrondissement",
      "La préfecture de police",
      "Le ministère de l’Intérieur",
    ],
    answer: "La préfecture de police",
    explanation:
        "À Paris, la déclaration préalable est déposée auprès de la préfecture de police.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Délai",
    question:
        "Le délai légal pour déposer une déclaration de manifestation est en principe :",
    options: [
      "Au moins 3 jours francs avant et au plus 15 jours francs avant la date",
      "La veille avant 18h",
      "Au moins un mois avant",
    ],
    answer:
        "Au moins 3 jours francs avant et au plus 15 jours francs avant la date",
    explanation:
        "La déclaration doit parvenir entre 3 et 15 jours francs avant la manifestation, afin de permettre à l’autorité de préparer le dispositif.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Déclaration",
    question:
        "La déclaration de manifestation doit obligatoirement comporter :",
    options: [
      "Les noms, prénoms et domiciles des organisateurs",
      "Le budget prévisionnel détaillé de la manifestation",
      "La liste nominative de tous les participants",
    ],
    answer: "Les noms, prénoms et domiciles des organisateurs",
    explanation:
        "Le contenu de la déclaration comprend notamment l’identité des organisateurs, l’objet, le lieu, la date, l’horaire et l’itinéraire envisagé.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Interdiction",
    question:
        "L’article L.211-4 du C.S.I. permet d’interdire une manifestation lorsque :",
    options: [
      "Elle n’est pas populaire",
      "Elle est de nature à troubler gravement l’ordre public et qu’aucune mesure moins restrictive ne suffit",
      "Elle se déroule un jour férié",
    ],
    answer:
        "Elle est de nature à troubler gravement l’ordre public et qu’aucune mesure moins restrictive ne suffit",
    explanation:
        "L’interdiction est une mesure grave, justifiée seulement en cas de risques sérieux de troubles graves à l’ordre public et en l’absence d’autres moyens suffisants.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Sanctions pénales",
    question:
        "Organiser une manifestation non déclarée ou malgré interdiction est puni par l’article 431-9 du Code Pénal. de :",
    options: [
      "Une simple amende forfaitaire de 135 €",
      "6 mois d’emprisonnement et 7 500 € d’amende",
      "10 ans d’emprisonnement",
    ],
    answer: "6 mois d’emprisonnement et 7 500 € d’amende",
    explanation:
        "L’article 431-9 du Code pénal sanctionne l’organisation d’une manifestation non déclarée, interdite ou déclarée de manière mensongère.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Participants",
    question:
        "La simple participation à une manifestation interdite sur le fondement de l’article L.211-4 C.S.I. est :",
    options: [
      "Un crime",
      "Une contravention de 4 ème classe",
      "Toujours un délit",
    ],
    answer: "Une contravention de 4 ème classe",
    explanation:
        "L’article R.644-4 du Code pénal punit la participation à une manifestation interdite d’une contravention de 4 ème classe.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Port d’arme",
    question:
        "Participer à une manifestation ou réunion publique en étant porteur d’une arme constitue :",
    options: [
      "Une simple contravention",
      "Un délit puni de 3 ans d’emprisonnement et 45 000 € d’amende",
      "Un crime puni de 20 ans de réclusion",
    ],
    answer: "Un délit puni de 3 ans d’emprisonnement et 45 000 € d’amende",
    explanation:
        "L’article 431-10 du Code pénal réprime le fait de participer armé à une manifestation ou réunion publique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Manifestations – Dissimulation du visage",
    question:
        "Sans motif légitime, dissimuler volontairement son visage lors d’une manifestation, dans un contexte de risque d’atteintes à l’ordre public, est puni :",
    options: [
      "D’un simple rappel à la loi",
      "D’un an d’emprisonnement et 15 000 € d’amende",
      "De 10 ans d’emprisonnement",
    ],
    answer: "D’un an d’emprisonnement et 15 000 € d’amende",
    explanation:
        "L’article 431-9-1 du Code pénal réprime la dissimulation volontaire du visage dans certaines manifestations, en vue d’échapper à l’identification.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Attroupements – Définition",
    question:
        "Selon l’article 431-3 du Code pénal, constitue un attroupement :",
    options: [
      "Tout rassemblement de personnes dans un domicile privé",
      "Tout rassemblement de personnes sur la voie publique ou dans un lieu public susceptible de troubler l’ordre public",
      "Toute file d’attente devant un commerce",
    ],
    answer:
        "Tout rassemblement de personnes sur la voie publique ou dans un lieu public susceptible de troubler l’ordre public",
    explanation:
        "L’attroupement vise un rassemblement sur la voie publique ou dans un lieu public susceptible de troubler l’ordre public, même sans violences effectives.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Attroupements – Sommations",
    question:
        "En principe, avant de disperser un attroupement par la force, l’autorité compétente doit :",
    options: [
      "Faire deux sommations préalables",
      "Toujours procéder à des arrestations massives",
      "Demander l’autorisation du procureur de la République",
    ],
    answer: "Faire deux sommations préalables",
    explanation:
        "L’article R.211-11 C.S.I. prévoit deux sommations avant l’usage de la force pour disperser un attroupement.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Attroupements – Participation",
    question:
        "Continuer à participer volontairement à un attroupement après les sommations, sans être porteur d’une arme, est puni :",
    options: [
      "D’un an d’emprisonnement et 15 000 € d’amende",
      "De 6 mois d’emprisonnement",
      "Uniquement d’une amende contraventionnelle",
    ],
    answer: "D’un an d’emprisonnement et 15 000 € d’amende",
    explanation:
        "L’article 431-4 du Code pénal réprime la participation à un attroupement après sommations, même sans arme.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Attroupements – Nature politique",
    question:
        "Le délit d’attroupement prévu à l’article 431-4 du Code pénal a été qualifié par la Cour de cassation comme :",
    options: [
      "Un délit politique",
      "Un simple délit de droit commun",
      "Un crime de guerre",
    ],
    answer: "Un délit politique",
    explanation:
        "Par un arrêt du 28 mars 2017, la chambre criminelle a qualifié le délit d’attroupement comme un délit politique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Presse – Textes fondateurs",
    question:
        "La grande « charte » de la liberté de la presse en France est la loi du :",
    options: ["10 août 1792", "29 juillet 1881", "1ère août 1986"],
    answer: "29 juillet 1881",
    explanation:
        "La loi du 29 juillet 1881 constitue la grande loi de référence sur la liberté de la presse en France.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Presse – Référence constitutionnelle",
    question:
        "La liberté d’expression et la libre communication des pensées et des opinions sont proclamées par :",
    options: [
      "L’article 11 de la Déclaration de 1789",
      "L’article 2 de la Constitution de 1958",
      "L’article 66 de la Constitution",
    ],
    answer: "L’article 11 de la Déclaration de 1789",
    explanation:
        "L’article 11 de la Déclaration des droits de l’Homme et du citoyen proclame la libre communication des pensées et des opinions.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Presse – Principe",
    question:
        "Selon la loi du 29 juillet 1881, la presse est en principe soumise :",
    options: [
      "À un régime d’autorisation préalable",
      "À un régime de censure administrative",
      "À un régime libéral, la répression n’intervenant qu’a posteriori en cas d’abus",
    ],
    answer:
        "À un régime libéral, la répression n’intervenant qu’a posteriori en cas d’abus",
    explanation:
        "La loi de 1881 rompt avec les régimes d’autorisation et de censure, pour consacrer un régime de liberté sous responsabilité.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Presse – Entreprise de presse",
    question:
        "L’article 5 de la loi du 29 juillet 1881 prévoit que tout journal ou écrit périodique peut être publié :",
    options: [
      "Uniquement avec autorisation préalable du préfet",
      "Sans autorisation préalable ni dépôt de cautionnement",
      "Seulement après contrôle du ministère de l’Intérieur",
    ],
    answer: "Sans autorisation préalable ni dépôt de cautionnement",
    explanation:
        "L’article 5 consacre un régime de simple déclaration, sans autorisation ni cautionnement.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Presse – Journaliste",
    question:
        "Le journaliste professionnel est, en principe, une personne qui :",
    options: [
      "Exerce à titre bénévole dans un journal",
      "Exerce à titre principal et rétribué une activité de rédaction ou de diffusion d’informations",
      "Est fonctionnaire du ministère de la Culture",
    ],
    answer:
        "Exerce à titre principal et rétribué une activité de rédaction ou de diffusion d’informations",
    explanation:
        "Le statut de journaliste professionnel suppose une activité principale, rémunérée, au sein d’un ou plusieurs organes de presse.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU MOYEN =====================
  QuizQuestion(
    category: "Manifestations – Lieu de déclaration",
    question:
        "Dans une commune où la police n’est pas étatisée, la déclaration de manifestation sur la voie publique est normalement déposée :",
    options: [
      "Auprès du maire de la commune",
      "Exclusivement à la préfecture de région",
      "Directement auprès du ministère de l’Intérieur",
    ],
    answer: "Auprès du maire de la commune",
    explanation:
        "En dehors de Paris et des communes à police étatisée, la déclaration se fait en mairie ; si la manifestation traverse plusieurs communes, chaque maire doit être saisi.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Manifestations – Contrôle du préfet",
    question:
        "Lorsqu’un maire interdit une manifestation dans une zone de police non étatisée, son arrêté :",
    options: [
      "Est insusceptible de tout contrôle",
      "Doit être transmis au préfet dans les 24 heures",
      "N’est valable que s’il est publié au Journal officiel",
    ],
    answer: "Doit être transmis au préfet dans les 24 heures",
    explanation:
        "L’arrêté d’interdiction du maire doit être transmis au préfet, qui peut saisir le tribunal administratif en cas de désaccord.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Manifestations – Contrôle du juge",
    question:
        "Le juge administratif contrôle la légalité d’un arrêté d’interdiction de manifestation en particulier au regard :",
    options: [
      "Du simple ressenti politique du préfet",
      "Des principes de nécessité et de proportionnalité des mesures de police",
      "Du nombre de participants annoncés uniquement",
    ],
    answer:
        "Des principes de nécessité et de proportionnalité des mesures de police",
    explanation:
        "Comme pour tout acte de police, le juge vérifie la nécessité, l’adaptation et la proportionnalité de l’interdiction aux risques allégués.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Manifestations – Contrôles d’identité",
    question:
        "Les contrôles d’identité aux abords d’une manifestation, pour prévenir les atteintes aux personnes et aux biens, peuvent reposer sur :",
    options: [
      "L’article 78-2 alinéa 8 du Code de procédure pénale",
      "L’article 66 de la Constitution",
      "Le Code du travail",
    ],
    answer: "L’article 78-2 alinéa 8 du Code de procédure pénale",
    explanation:
        "L’article 78-2 CPP permet notamment des contrôles préventifs aux abords des manifestations en cas de risque avéré.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Manifestations – Fouilles",
    question:
        "Les réquisitions permettant de contrôler bagages et véhicules aux abords d’une manifestation reposent sur :",
    options: [
      "L’article 78-2-5 du Code de procédure pénale",
      "L’article L.211-10 du C.S.I.",
      "L’article 431-9-1 du Code pénal",
    ],
    answer: "L’article 78-2-5 du Code de procédure pénale",
    explanation:
        "L’article 78-2-5 CPP autorise le procureur à délivrer des réquisitions pour fouilles de bagages et visites de véhicules dans un périmètre et une durée limités.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Manifestations – Objets dangereux",
    question:
        "En cas de risques sérieux de troubles graves à l’ordre public, l’article L.211-3 C.S.I. permet :",
    options: [
      "D’interdire le port et le transport, sans motif légitime, d’objets pouvant constituer une arme",
      "D’interdire toute circulation routière sur le territoire national",
      "D’interdire tous les déplacements à plus de 5 km du domicile",
    ],
    answer:
        "D’interdire le port et le transport, sans motif légitime, d’objets pouvant constituer une arme",
    explanation:
        "L’article L.211-3 C.S.I. est une mesure préventive liée au risque de violence lors de certaines manifestations.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Manifestations – Responsabilité de l’État",
    question:
        "Selon l’article L.211-10 du C.S.I., l’État est civilement responsable :",
    options: [
      "Des simples contraventions commises isolément",
      "Des dégâts résultant des crimes et délits commis à force ouverte ou par violence lors de manifestations ou rassemblements",
      "Uniquement des erreurs des organisateurs",
    ],
    answer:
        "Des dégâts résultant des crimes et délits commis à force ouverte ou par violence lors de manifestations ou rassemblements",
    explanation:
        "L’article L.211-10 pose une responsabilité de plein droit de l’État pour certains dommages causés en lien avec des manifestations ou attroupements.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Attroupements – Autorité compétente",
    question:
        "En matière d’attroupements, le maintien de l’ordre relève, selon le C.S.I., principalement :",
    options: [
      "Du ministre de l’Intérieur",
      "Du garde des Sceaux",
      "Du ministre de la Justice militaire",
    ],
    answer: "Du ministre de l’Intérieur",
    explanation:
        "L’article D.211-10 C.S.I. précise que le maintien de l’ordre dans ces cas relève exclusivement du ministre de l’Intérieur.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Attroupements – Forces armées",
    question:
        "Les forces armées autres que la gendarmerie nationale peuvent participer au maintien de l’ordre :",
    options: [
      "Sans condition particulière",
      "Uniquement lorsqu’elles sont légalement requises par l’autorité civile compétente",
      "Jamais, même sur réquisition",
    ],
    answer:
        "Uniquement lorsqu’elles sont légalement requises par l’autorité civile compétente",
    explanation:
        "La participation de forces militaires au maintien de l’ordre suppose une réquisition régulière de l’autorité civile compétente.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Attroupements – Insignes",
    question:
        "Lorsqu’une autorité exécute les sommations de dispersion d’un attroupement, elle doit :",
    options: [
      "Porter un insigne distinctif (écharpe ou brassard tricolore)",
      "Être en civil sans aucun signe distinctif",
      "Être accompagnée d’un huissier de justice",
    ],
    answer: "Porter un insigne distinctif (écharpe ou brassard tricolore)",
    explanation:
        "L’article R.211-12 C.S.I. impose le port d’insignes distinctifs aux autorités procédant aux sommations.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Attroupements – Usage de la force",
    question:
        "Selon l’article R.211-13 C.S.I., le recours à la force pour disperser un attroupement :",
    options: [
      "Doit être absolument nécessaire au maintien de l’ordre public",
      "Peut être utilisé à titre préventif sans sommations",
      "Nécessite toujours l’accord du maire",
    ],
    answer: "Doit être absolument nécessaire au maintien de l’ordre public",
    explanation:
        "La force ne peut être employée que si elle est absolument nécessaire et proportionnée au trouble à faire cesser.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Attroupements – Dispense de sommations",
    question: "Dans certains cas, l’article L.211-9 C.S.I. permet :",
    options: [
      "De renoncer aux sommations et de recourir immédiatement à la force dans certaines situations de violences ou menaces graves",
      "D’interdire tout attroupement sur le territoire national",
      "De placer automatiquement les participants en garde à vue",
    ],
    answer:
        "De renoncer aux sommations et de recourir immédiatement à la force dans certaines situations de violences ou menaces graves",
    explanation:
        "En cas de violences ou de menaces graves contre les forces de l’ordre ou certains lieux, la loi autorise un recours immédiat à la force.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Attroupements – Dissimulation et arme",
    question:
        "Participer à un attroupement après sommations, en étant porteur d’une arme et le visage dissimulé pour ne pas être identifié, est puni au maximum :",
    options: [
      "D’un an d’emprisonnement",
      "De 5 ans d’emprisonnement et 75 000 € d’amende",
      "De 10 ans de réclusion criminelle",
    ],
    answer: "De 5 ans d’emprisonnement et 75 000 € d’amende",
    explanation:
        "L’article 431-5 du Code pénal aggrave les peines lorsque le participant porte une arme et dissimule son visage.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Pluralisme",
    question:
        "Le pluralisme des courants d’expression, en matière de presse, a été reconnu par le Conseil constitutionnel comme :",
    options: [
      "Un simple objectif de politique publique sans valeur juridique",
      "Un principe à valeur constitutionnelle",
      "Une notion uniquement morale sans portée juridique",
    ],
    answer: "Un principe à valeur constitutionnelle",
    explanation:
        "Le Conseil constitutionnel, dans sa décision du 11 octobre 1984 notamment, fait du pluralisme un principe à valeur constitutionnelle.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Transparence",
    question:
        "Les règles de transparence sur la propriété et la direction des entreprises de presse ont été renforcées notamment par :",
    options: [
      "L’ordonnance du 26 août 1944 et la loi du 23 octobre 1984",
      "Le Code du travail",
      "Le Code de procédure pénale",
    ],
    answer: "L’ordonnance du 26 août 1944 et la loi du 23 octobre 1984",
    explanation:
        "Ces textes visent à favoriser la transparence des organes de presse pour informer le public sur leurs responsables et leurs propriétaires.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Carte professionnelle",
    question:
        "La carte d’identité professionnelle des journalistes est délivrée :",
    options: [
      "Par une Commission paritaire composée de journalistes et d’éditeurs",
      "Par le préfet de département",
      "Par le Conseil constitutionnel",
    ],
    answer:
        "Par une Commission paritaire composée de journalistes et d’éditeurs",
    explanation:
        "Cette Commission paritaire décide de l’octroi ou du retrait de la carte de presse, décision susceptible de recours devant le juge administratif.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Clause de conscience",
    question: "La « clause de conscience » d’un journaliste lui permet :",
    options: [
      "De refuser tout contrôle fiscal",
      "De rompre son contrat avec indemnités majorées en cas de changement profond de la ligne éditoriale",
      "De bénéficier automatiquement d’un logement de fonction",
    ],
    answer:
        "De rompre son contrat avec indemnités majorées en cas de changement profond de la ligne éditoriale",
    explanation:
        "La clause de conscience protège le journaliste lorsqu’un changement de l’orientation du journal porte atteinte à son honneur ou à ses intérêts moraux.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Secret des sources",
    question: "Le secret des sources des journalistes peut être levé :",
    options: [
      "Uniquement en cas de crime de terrorisme commis par un journaliste",
      "Lorsque un impératif prépondérant d’intérêt public l’exige et que les mesures sont nécessaires et proportionnées",
      "À la simple demande d’un officier de police judiciaire",
    ],
    answer:
        "Lorsque un impératif prépondérant d’intérêt public l’exige et que les mesures sont nécessaires et proportionnées",
    explanation:
        "La loi protège le secret des sources ; les atteintes doivent rester exceptionnelles, justifiées et proportionnées.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Injure / diffamation",
    question:
        "La diffamation se distingue de l’injure publique notamment parce qu’elle comporte :",
    options: [
      "Une menace de violence physique",
      "L’allégation ou l’imputation d’un fait précis portant atteinte à l’honneur",
      "Toujours des propos à caractère religieux",
    ],
    answer:
        "L’allégation ou l’imputation d’un fait précis portant atteinte à l’honneur",
    explanation:
        "La diffamation implique un fait précis susceptible de preuve, alors que l’injure consiste en des propos outrageants sans fait précis.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Presse – Prescription",
    question:
        "En matière de délits de presse, le délai de prescription de l’action publique est en principe :",
    options: [
      "De 3 mois à compter de la publication",
      "De 5 ans à compter de la publication",
      "De 10 ans à compter de la publication",
    ],
    answer: "De 3 mois à compter de la publication",
    explanation:
        "La loi de 1881 prévoit un bref délai de prescription de 3 mois, porté à un an pour certains délits à caractère raciste ou discriminatoire.",
    difficulty: "Moyenne",
  ),

  // ===================== NIVEAU DIFFICILE (inclut Expert) =====================
  QuizQuestion(
    category: "Manifestations – Déclaration mensongère",
    question:
        "Selon l’article 431-9 du Code pénal, est puni comme organisateur de manifestation illicite celui qui :",
    options: [
      "Omet de mentionner l’heure précise de fin",
      "Présente une déclaration incomplète ou inexacte destinée à tromper sur l’objet ou les conditions de la manifestation",
      "Ne joint pas de plan de situation détaillé",
    ],
    answer:
        "Présente une déclaration incomplète ou inexacte destinée à tromper sur l’objet ou les conditions de la manifestation",
    explanation:
        "L’article 431-9 vise aussi la déclaration frauduleuse destinée à tromper l’autorité, assimilée à l’organisation d’une manifestation non conforme.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Manifestations – Dissimulation du visage (contravention)",
    question:
        "À côté du délit de dissimulation du visage (art. 431-9-1 du Code Pénal.), une contravention de 5ᵉ classe (art. R.645-14 du Code Pénal.) peut viser :",
    options: [
      "Les mêmes faits, mais en l’absence de trouble grave à l’ordre public",
      "Uniquement la dissimulation par un mineur",
      "Uniquement la dissimulation lors d’événements sportifs",
    ],
    answer:
        "Les mêmes faits, mais en l’absence de trouble grave à l’ordre public",
    explanation:
        "Lorsque le contexte est moins grave, l’infraction est requalifiée en contravention de 5ᵉ classe, toujours pour dissimulation illicite.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Manifestations – Substances explosives",
    question: "L’article 322-11-1 du Code pénal réprime notamment :",
    options: [
      "La simple possession d’un briquet",
      "La détention ou le transport de substances ou produits incendiaires ou explosifs destinés à préparer des atteintes graves lors d’une manifestation",
      "Le simple fait de filmer des violences",
    ],
    answer:
        "La détention ou le transport de substances ou produits incendiaires ou explosifs destinés à préparer des atteintes graves lors d’une manifestation",
    explanation:
        "Cette disposition vise les comportements préparatoires à des violences graves contre les personnes ou les biens.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Attroupements – Procédures rapides",
    question:
        "L’article 431-8-1 du Code pénal permet, pour les délits commis à l’occasion d’attroupements :",
    options: [
      "D’écarter toute garantie procédurale",
      "De recourir à des procédures rapides comme la comparution immédiate ou la CRPC",
      "De juger les mis en cause sans avocat",
    ],
    answer:
        "De recourir à des procédures rapides comme la comparution immédiate ou la CRPC",
    explanation:
        "L’attroupement étant qualifié de délit politique, le texte précise la compatibilité avec les procédures pénales rapides.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Attroupements – Provocation armée",
    question:
        "L’article 431-6 du Code pénal réprime la provocation directe à un attroupement armé. Lorsque cette provocation a été suivie d’effet, la peine maximale est :",
    options: [
      "3 ans d’emprisonnement",
      "5 ans d’emprisonnement",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende",
    explanation:
        "La peine est aggravée lorsque l’attroupement armé s’est effectivement produit à la suite de la provocation.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Attroupements – Loi du 29 juillet 1881",
    question:
        "L’article 24 de la loi du 29 juillet 1881 est mobilisable lorsque :",
    options: [
      "Il y a provocation à certains crimes ou délits commis à l’occasion d’attroupements",
      "Une manifestation n’a pas été déclarée",
      "Le préfet refuse de signer un arrêté",
    ],
    answer:
        "Il y a provocation à certains crimes ou délits commis à l’occasion d’attroupements",
    explanation:
        "L’article 24 réprime la provocation à certains crimes ou délits, ce qui peut concerner des faits commis lors d’attroupements.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Droit au respect de la vie privée",
    question:
        "La publication en presse écrite de détails intimes non justifiés par l’intérêt général constitue :",
    options: [
      "Une diffamation",
      "Une atteinte à la vie privée",
      "Un simple manquement déontologique non sanctionné",
    ],
    answer: "Une atteinte à la vie privée",
    explanation:
        "La divulgation non autorisée d’éléments de la vie personnelle (adresse, santé, vie sentimentale…) engage la responsabilité de l’éditeur.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Fausses nouvelles",
    question:
        "La publication de fausses nouvelles, au sens de la loi de 1881, suppose notamment :",
    options: [
      "Que la nouvelle soit fausse, et de nature à troubler la paix publique",
      "Que la nouvelle soit simplement impopulaire",
      "Qu’un préfet ait démenti l’information",
    ],
    answer:
        "Que la nouvelle soit fausse, et de nature à troubler la paix publique",
    explanation:
        "L’infraction vise la diffusion de nouvelles inexactes ou falsifiées susceptibles de troubler l’ordre public.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Secret des sources et perquisitions",
    question:
        "Une perquisition dans les locaux d’un journal pour obtenir les sources d’un journaliste :",
    options: [
      "Doit être dirigée par un magistrat et respecter des exigences strictes de nécessité et proportionnalité",
      "Peut être décidée librement par un officier de police judiciaire",
      "Peut être réalisée sans procès-verbal",
    ],
    answer:
        "Doit être dirigée par un magistrat et respecter des exigences strictes de nécessité et proportionnalité",
    explanation:
        "Le secret des sources est fortement protégé ; les perquisitions doivent être encadrées par un magistrat et justifiées.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Personne responsable",
    question:
        "En matière de délits de presse, la personne responsable principale est en principe :",
    options: [
      "Le directeur de la publication pour les écrits périodiques",
      "Le journaliste auteur de l’article",
      "L’imprimeur",
    ],
    answer: "Le directeur de la publication pour les écrits périodiques",
    explanation:
        "Le système de la loi de 1881 établit une hiérarchie des responsabilités, plaçant en tête le directeur de la publication.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Délits racistes",
    question:
        "Pour certains délits de presse à caractère raciste ou discriminatoire, le délai de prescription est porté :",
    options: ["À 6 mois", "À un an", "À 5 ans"],
    answer: "À un an",
    explanation:
        "Le législateur a prolongé la prescription à un an pour tenir compte de la gravité particulière de ces infractions.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Presse – Interventions policières",
    question:
        "Lorsqu’une enquête vise un média ou un journaliste, le policier doit notamment :",
    options: [
      "Chercher à connaître toutes les sources par tous moyens",
      "Respecter strictement le cadre de la réquisition judiciaire et la protection des sources",
      "Appeler directement la rédaction pour exiger des informations",
    ],
    answer:
        "Respecter strictement le cadre de la réquisition judiciaire et la protection des sources",
    explanation:
        "La liberté de la presse et le secret des sources imposent aux forces de l’ordre un comportement particulièrement encadré.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizLibertesPubliquesCollectivesPage extends StatefulWidget {
  static const String routeName =
      '/gpx/generalites/quiz/libertes_publiques_collectives';

  final String uid;
  final String email;

  const QuizLibertesPubliquesCollectivesPage({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizLibertesPubliquesCollectivesPage> createState() =>
      _QuizLibertesPubliquesCollectivesPageState();
}

class _QuizLibertesPubliquesCollectivesPageState
    extends State<QuizLibertesPubliquesCollectivesPage>
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
  int? _historyRowId; // id (int) retour insert quiz_history
  SupabaseClient get _sb => Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _page = PageController(initialPage: 0);
    _rng = math.Random(DateTime.now().millisecondsSinceEpoch);

    // --- Audio ---
    _goodSfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    _badSfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

    // Pré-charge pour éviter le délai au premier play
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

  // ========================================================================
  // HELPERS
  // ========================================================================
  void _seedAndShuffle() {
    final useAll = _mixMode || _selectedDifficulty == null;
    final pool = useAll
        ? questionsLibertesPubliquesCollectives
        : questionsLibertesPubliquesCollectives
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

  // ========================================================================
  // SUPABASE
  // ========================================================================
  Future<void> _createHistoryOnStart() async {
    try {
      final res = await _sb
          .from('quiz_history')
          .insert({
            'uid': widget.uid,
            'email': widget.email,
            'module_name': 'Généralités',
            'quiz_name': 'Libertés collectives',
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
            'score': percent, // pourcentage final
            'correct_count': _score, // nb de bonnes réponses
            'finished_at': DateTime.now().toUtc().toIso8601String(),
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _historyRowId!)
          .eq('uid', widget.uid); // important pour la RLS
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
      await _sb.from('quiz_libertes_collectives').insert({
        'user_uid': widget.uid,
        'email': widget.email,
        'question': question,
        'user_answer': userAnswer,
        'correct_answer': correctAnswer,
        'is_correct': isCorrect,
        'score': _score, // score cumulé au moment T
        'difficulty': difficulty,
      });
    } catch (e) {
      debugPrint('❌ quiz_libertes_collectives insert failed: $e');
    }
  }

  // ========================================================================
  // AUDIO UTIL
  // ========================================================================
  Future<void> _playAnswerSfx(bool good) async {
    try {
      HapticFeedback.mediumImpact();

      final AudioPlayer p = good ? _goodSfx : _badSfx;
      await p.stop();
      await p.setSource(
        AssetSource(good ? 'sfx/correct_answer.mp3' : 'sfx/wrong_answer.mp3'),
      );
      await p.resume();
    } catch (_) {
      // on ignore les erreurs audio
    }
  }

  // ========================================================================
  // ACTIONS
  // ========================================================================
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

  // ========================================================================
  // UI
  // ========================================================================
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

  // ========================================================================
  // RESULT DIALOG
  // ========================================================================
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
          message: 'Tu maîtrises les libertés collectives 💪',
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
          message: 'Reprends les cours',
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

// Carte d'explication + couleur résultat
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

// Bandeau qui calcule automatiquement la taille idéale de l'animation
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

// Carte résultat avec anneau qui tourne infiniment
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

// ---------- widgets internes du splash ----------
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
