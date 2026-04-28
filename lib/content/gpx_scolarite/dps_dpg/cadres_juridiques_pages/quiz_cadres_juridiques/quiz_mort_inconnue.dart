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
final List<QuizQuestion> questionsMortInconnue = [
  // =========================================================
  //                     NIVEAU FACILE
  // =========================================================
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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

  QuizQuestion(
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
];

// ============================================================================
// PAGE
// ============================================================================
class QuizMortInconnuePage extends StatefulWidget {
  static const String routeName = '/gpx/generalites/quiz/mort_inconnue';
  final String uid;
  final String email;

  const QuizMortInconnuePage({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizMortInconnuePage> createState() => _QuizMortInconnuePageState();
}

class _QuizMortInconnuePageState extends State<QuizMortInconnuePage>
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
        ? questionsMortInconnue
        : questionsMortInconnue
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
            'quiz_name': 'Mort Inconnue',
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
      await _sb.from('quiz_mort_inconnue').insert({
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
      debugPrint('❌ quiz_mort_inconnue insert failed: $e');
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
