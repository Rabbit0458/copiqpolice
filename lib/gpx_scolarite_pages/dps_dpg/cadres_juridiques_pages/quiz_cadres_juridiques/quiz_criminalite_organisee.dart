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
import 'package:copiqpolice/ui/app_notifier.dart'
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
final List<QuizQuestion> questionsCriminaliteOrganisee = [
  // ==========================================================
  //                 NIVEAU FACILE — GÉNÉRALITÉS
  // ==========================================================
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
    category: "Criminalité organisée — Généralités",
    question:
        "Sous quel titre du code de procédure pénale se trouve la procédure applicable à la criminalité et délinquance organisées ?",
    options: ["Titre XV", "Titre XXV", "Titre II"],
    answer: "Titre XXV",
    explanation:
        "Le titre XXV du CPP est intitulé « De la procédure pénale applicable à la criminalité et à la délinquance organisées et aux crimes ».",
    difficulty: "Facile",
  ),

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
    category: "Criminalité organisée — Bande organisée",
    question: "La bande organisée est une circonstance :",
    options: ["Atténuante", "Aggravante", "Neutre sur la peine"],
    answer: "Aggravante",
    explanation:
        "La bande organisée constitue une circonstance aggravante prévue par le Code pénal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
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
  QuizQuestion(
    category: "Géolocalisation — Durée",
    question:
        "En matière de criminalité organisée, la géolocalisation peut durer au maximum :",
    options: ["15 jours", "2 mois", "2 ans"],
    answer: "2 ans",
    explanation:
        "L’autorisation initiale (15 jours) peut être prolongée jusqu’à une durée totale de deux ans (art. 230-32 et s. CPP).",
    difficulty: "Facile",
  ),

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
    category: "Infiltration — Durée",
    question:
        "La durée initiale maximale d’une autorisation d’infiltration est de :",
    options: ["1 mois", "3 mois", "4 mois"],
    answer: "4 mois",
    explanation:
        "L’autorisation est délivrée pour 4 mois, renouvelables dans les mêmes conditions (art. 706-81 CPP).",
    difficulty: "Facile",
  ),

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
    category: "Garde à vue — Droit commun",
    question:
        "La durée maximale d’une garde à vue de droit commun (hors criminalité organisée) est en principe de :",
    options: ["24 heures", "48 heures", "72 heures"],
    answer: "48 heures",
    explanation:
        "La garde à vue de droit commun est de 24h renouvelable une fois, soit 48h au total.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Garde à vue — Criminalité organisée",
    question:
        "Pour une infraction relevant de l’article 706-73 CPP (hors terrorisme et mules), la garde à vue peut aller jusqu’à :",
    options: ["72 heures", "96 heures", "120 heures"],
    answer: "96 heures",
    explanation:
        "L’article 706-88 permet deux prolongations supplémentaires de 24h ou une de 48h, soit 96h maxi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Terrorisme — Procédure",
    question: "La garde à vue en matière de terrorisme peut aller jusqu’à :",
    options: ["48h", "96h", "144h"],
    answer: "144h",
    explanation:
        "L’article 706-88-1 CPP permet une durée exceptionnelle de 6 jours (144h) en matière terroriste.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Garde à vue — Mules",
    question:
        "Pour un passeur de stupéfiants in corpore (mule), la garde à vue peut atteindre :",
    options: ["96 heures", "120 heures", "144 heures"],
    answer: "120 heures",
    explanation:
        "L’article 706-88-2 CPP prévoit une prolongation exceptionnelle de 24h après 96h, soit 120h.",
    difficulty: "Facile",
  ),

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
    category: "Garde à vue — Durée",
    question:
        "En matière de criminalité organisée relevant de l’article 706-73 (hors exceptions), quelle peut être la durée maximale d’une garde à vue d’un majeur ?",
    options: ["48 heures", "72 heures", "96 heures"],
    answer: "96 heures",
    explanation:
        "L’article 706-88 permet, à titre exceptionnel, deux prolongations supplémentaires de 24 h après les 48 h de droit commun, soit 96 heures au total.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Garde à vue — Terrorisme",
    question:
        "En matière de terrorisme (706-73, 11°), quelle peut être la durée maximale exceptionnelle d’une garde à vue ?",
    options: ["96 heures", "120 heures", "144 heures"],
    answer: "144 heures",
    explanation:
        "L’article 706-88-1 prévoit qu’en matière de terrorisme, la garde à vue peut, à titre exceptionnel, atteindre 6 jours (144 heures).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Garde à vue — Mules",
    question:
        "Pour une « mule » (transport de stupéfiants in corpore), la garde à vue peut, à titre exceptionnel, atteindre :",
    options: ["96 heures", "120 heures", "72 heures"],
    answer: "120 heures",
    explanation:
        "L’article 706-88-2 CPP prévoit une prolongation exceptionnelle de 24 h après les 96 h, soit 120 heures maximum.",
    difficulty: "Facile",
  ),

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
    category: "Enquête préliminaire — Durée",
    question:
        "En matière de criminalité organisée, quelle est la durée maximale d’une enquête préliminaire avant renouvellement ?",
    options: ["Un an", "Deux ans", "Trois ans"],
    answer: "Trois ans",
    explanation:
        "La durée ne peut excéder 3 ans à compter du premier acte (audition libre, GAV ou perquisition), renouvelable 2 ans sur autorisation écrite du procureur.",
    difficulty: "Intermédiaire",
  ),

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
];

// ============================================================================
// PAGE
// ============================================================================
class QuizCriminaliteOrganiseePage extends StatefulWidget {
  static const String routeName = '/gpx/generalites/quiz/criminalite_organisee';
  final String uid;
  final String email;

  const QuizCriminaliteOrganiseePage({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizCriminaliteOrganiseePage> createState() =>
      _QuizCriminaliteOrganiseePageState();
}

class _QuizCriminaliteOrganiseePageState
    extends State<QuizCriminaliteOrganiseePage>
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
        ? questionsCriminaliteOrganisee
        : questionsCriminaliteOrganisee
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
            'quiz_name': 'Criminalité Organisée',
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
      await _sb.from('quiz_criminalite_organisee').insert({
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
      debugPrint('❌ quiz_criminalite_organisee insert failed: $e');
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
