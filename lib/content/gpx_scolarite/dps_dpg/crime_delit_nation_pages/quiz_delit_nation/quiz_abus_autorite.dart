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

final List<QuizQuestion> questionAbusAutoriteParticuliers = [
  // =========================================================
  // 432-8 — ATTEINTE À L'INVIOLABILITÉ DU DOMICILE
  // =========================================================
  QuizQuestion(
    category: "Inviolabilité du domicile — Définition",
    question:
        "Constitue une atteinte à l’inviolabilité du domicile le fait, par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public, de :",
    options: [
      "S’introduire ou tenter de s’introduire dans le domicile d’autrui contre le gré de l’occupant hors les cas prévus par la loi",
      "Se maintenir dans le domicile d’autrui après une invitation",
      "Refuser d’ouvrir la porte à l’occupant",
    ],
    answer:
        "S’introduire ou tenter de s’introduire dans le domicile d’autrui contre le gré de l’occupant hors les cas prévus par la loi",
    explanation:
        "L’article vise l’introduction ou la tentative d’introduction, contre le gré, hors les cas légaux.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Texte",
    question:
        "L’infraction d’atteinte à l’inviolabilité du domicile est prévue par :",
    options: [
      "Article 432-8 du Code pénal",
      "Article 432-9 du Code pénal",
      "Article 432-7 du Code pénal",
    ],
    answer: "Article 432-8 du Code pénal",
    explanation:
        "Le cours indique que l’infraction est prévue et réprimée par l’article 432-8 C.P.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Auteur",
    question: "Peut être auteur de l’infraction (432-8) :",
    options: [
      "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
      "Tout particulier sans qualité",
      "Uniquement un magistrat",
    ],
    answer:
        "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
    explanation: "L’infraction vise spécifiquement ces qualités.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Dépositaire autorité publique",
    question: "Est dépositaire de l’autorité publique celui qui :",
    options: [
      "Dispose d’un pouvoir de décision fondé sur une parcelle de l’autorité publique conférée par ses fonctions",
      "Réalise une mission d’intérêt général sans pouvoir de décision",
      "Est uniquement salarié d’une entreprise privée",
    ],
    answer:
        "Dispose d’un pouvoir de décision fondé sur une parcelle de l’autorité publique conférée par ses fonctions",
    explanation:
        "Définition donnée : pouvoir de décision lié à l’autorité publique conférée par les fonctions.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Exemples",
    question:
        "Parmi les personnes citées comme dépositaires de l’autorité publique, on retrouve notamment :",
    options: [
      "Policiers et gendarmes",
      "Agents immobiliers",
      "Livreurs privés",
    ],
    answer: "Policiers et gendarmes",
    explanation:
        "Le cours cite policiers, gendarmes, douaniers, huissiers, etc.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Mission de service public",
    question: "Est chargé d’une mission de service public celui qui :",
    options: [
      "Accomplit un service public quelconque à titre temporaire ou permanent, volontairement ou sur réquisition",
      "A toujours un pouvoir de commandement",
      "Exerce obligatoirement une fonction militaire",
    ],
    answer:
        "Accomplit un service public quelconque à titre temporaire ou permanent, volontairement ou sur réquisition",
    explanation: "Définition textuelle du cours.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Contexte d’action",
    question: "Pour que 432-8 soit constitué, l’auteur doit agir :",
    options: [
      "Dans l’exercice ou à l’occasion de l’exercice de ses fonctions ou de sa mission",
      "Uniquement en dehors de toute fonction",
      "Seulement pendant ses congés",
    ],
    answer:
        "Dans l’exercice ou à l’occasion de l’exercice de ses fonctions ou de sa mission",
    explanation: "Condition explicitement mentionnée.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Abus de qualité",
    question:
        "L’auteur doit avoir abusé de sa qualité pour pénétrer au domicile, ce qui exclut :",
    options: [
      "Une violation de domicile pour des raisons personnelles",
      "Une action réalisée pendant une mission",
      "Une action en lien avec ses attributions",
    ],
    answer: "Une violation de domicile pour des raisons personnelles",
    explanation: "Le cours indique que les raisons personnelles sont exclues.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Notion de domicile",
    question: "Le domicile est :",
    options: [
      "Le lieu où une personne a le droit de se dire chez elle, qu’elle y habite ou non",
      "Uniquement le domicile légal déclaré",
      "Uniquement un lieu dont on est propriétaire",
    ],
    answer:
        "Le lieu où une personne a le droit de se dire chez elle, qu’elle y habite ou non",
    explanation: "Définition du cours : droit de se dire chez soi.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Étendue",
    question: "Peuvent entrer dans la notion de domicile :",
    options: [
      "Résidence, lieu de séjour occasionnel, domicile légal",
      "Uniquement une résidence principale occupée en permanence",
      "Uniquement un logement meublé et habité",
    ],
    answer: "Résidence, lieu de séjour occasionnel, domicile légal",
    explanation: "Le cours étend la notion à résidence et séjour occasionnel.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Logements inoccupés",
    question: "Un logement inoccupé peut être considéré comme un domicile si :",
    options: [
      "Il contient des meubles traduisant une occupation effective (table, chaises, lit, etc.)",
      "Il contient uniquement une bicyclette",
      "Il est vide mais la porte est fermée",
    ],
    answer:
        "Il contient des meubles traduisant une occupation effective (table, chaises, lit, etc.)",
    explanation:
        "Le cours précise que des meubles caractérisant l’occupation peuvent suffire selon appréciation du juge.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Dépendances",
    question: "Le domicile comprend aussi :",
    options: [
      "Les dépendances (caves, terrasses, etc.)",
      "Uniquement les pièces principales",
      "Uniquement l’entrée",
    ],
    answer: "Les dépendances (caves, terrasses, etc.)",
    explanation: "Le cours vise l’habitation avec ses dépendances.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Cours/Jardins",
    question:
        "Cours, jardins et parcs sont assimilés au domicile lorsqu’ils sont :",
    options: [
      "Clos et attenants à l’habitation",
      "Toujours assimilés",
      "Jamais assimilés",
    ],
    answer: "Clos et attenants à l’habitation",
    explanation: "Condition explicitement mentionnée (clos + attenants).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Proximité",
    question: "Pour une dépendance, la jurisprudence exige :",
    options: [
      "Un lien étroit et immédiat + proximité avec l’habitation",
      "Aucune condition, toute dépendance suffit",
      "Uniquement que ce soit dans la même commune",
    ],
    answer: "Un lien étroit et immédiat + proximité avec l’habitation",
    explanation: "Le cours insiste sur l’annexe au domicile et la proximité.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Acte matériel",
    question: "L’action incriminée au 432-8 est :",
    options: [
      "L’introduction ou la tentative d’introduction dans un domicile",
      "Le maintien dans un domicile",
      "La surveillance du domicile depuis la voie publique",
    ],
    answer: "L’introduction ou la tentative d’introduction dans un domicile",
    explanation: "Le texte précise que le maintien n’est pas visé.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Consentement",
    question:
        "L’article 432-8 réprime l’introduction seulement si elle est effectuée :",
    options: [
      "Contre le gré de l’occupant",
      "Avec consentement",
      "Uniquement de nuit",
    ],
    answer: "Contre le gré de l’occupant",
    explanation: "Condition : contre le gré, sinon pas d’infraction.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Consentement vicié",
    question: "Le consentement de l’occupant ne doit pas être vicié par :",
    options: [
      "Des manœuvres/stratagèmes policiers",
      "Une demande écrite",
      "Une invitation orale",
    ],
    answer: "Des manœuvres/stratagèmes policiers",
    explanation: "Le cours mentionne le consentement vicié par stratagèmes.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — À l’insu",
    question: "L’absence de consentement englobe le fait de pénétrer :",
    options: [
      "À l’insu de l’occupant",
      "Uniquement après refus écrit",
      "Uniquement avec violence",
    ],
    answer: "À l’insu de l’occupant",
    explanation:
        "Le cours cite l’exemple de pénétrer à l’insu (fenêtre ouverte).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Cas légaux",
    question: "Le 432-8 sanctionne l’introduction lorsqu’elle est faite :",
    options: [
      "Hors les cas permis par la loi",
      "Même lorsqu’un texte autorise l’entrée",
      "Uniquement en cas d’urgence médicale",
    ],
    answer: "Hors les cas permis par la loi",
    explanation: "Le texte vise uniquement les introductions hors cas légaux.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Élément moral",
    question: "L’élément moral du 432-8 suppose :",
    options: [
      "La conscience de pénétrer irrégulièrement au domicile d’autrui",
      "Une intention de nuire obligatoire",
      "L’accord écrit de l’occupant",
    ],
    answer: "La conscience de pénétrer irrégulièrement au domicile d’autrui",
    explanation: "Conscience de l’irrégularité des agissements.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Circonstances aggravantes",
    question: "Pour l’infraction 432-8, les circonstances aggravantes sont :",
    options: ["Aucune", "Toujours présentes", "Uniquement si violence"],
    answer: "Aucune",
    explanation: "Le cours indique : AUCUNE.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Répression",
    question: "Peines principales encourues (personnes physiques) pour 432-8 :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "3 ans et 45 000 €",
      "5 ans et 75 000 €",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation: "Répression mentionnée : 2 ans + 30 000 €.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Tentative",
    question: "La tentative pour 432-8 est :",
    options: [
      "Incriminée (OUI)",
      "Non incriminée",
      "Uniquement en cas de violence",
    ],
    answer: "Incriminée (OUI)",
    explanation:
        "Le cours précise : TENTATIVE : OUI (spécifiquement incriminée).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Complicité",
    question: "La complicité (432-8) est :",
    options: [
      "Punissable (121-6 et 121-7)",
      "Impossible",
      "Punissable uniquement si l’auteur est un particulier",
    ],
    answer: "Punissable (121-6 et 121-7)",
    explanation: "Complicité punissable selon 121-6 et 121-7.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 432-9 — ATTEINTE AU SECRET DES CORRESPONDANCES
  // =========================================================
  QuizQuestion(
    category: "Secret des correspondances — Texte",
    question:
        "L’atteinte au secret des correspondances est prévue et réprimée par :",
    options: [
      "Article 432-9 du Code pénal",
      "Article 432-8 du Code pénal",
      "Article 225-1 du Code pénal",
    ],
    answer: "Article 432-9 du Code pénal",
    explanation: "Le cours indique : article 432-9 C.P.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Définition",
    question:
        "L’infraction (432-9) peut consister à ordonner, commettre ou faciliter :",
    options: [
      "Le détournement, la suppression, l’ouverture de correspondances ou la révélation de leur contenu, hors les cas prévus par la loi",
      "Uniquement la lecture d’un journal",
      "Uniquement la destruction d’un colis perdu",
    ],
    answer:
        "Le détournement, la suppression, l’ouverture de correspondances ou la révélation de leur contenu, hors les cas prévus par la loi",
    explanation: "Définition textuelle du cours.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Auteurs",
    question: "Peuvent être auteurs (432-9) :",
    options: [
      "Dépositaires de l’autorité publique / chargés mission service public, et certains agents d’opérateurs télécoms dans l’exercice de leurs fonctions",
      "Uniquement un juge d’instruction",
      "Uniquement un particulier",
    ],
    answer:
        "Dépositaires de l’autorité publique / chargés mission service public, et certains agents d’opérateurs télécoms dans l’exercice de leurs fonctions",
    explanation:
        "Le cours vise aussi des agents exploitants de réseaux/fournisseurs télécoms.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Réseau ouvert au public",
    question: "Un réseau ouvert au public (CPCE) est :",
    options: [
      "Un réseau établi/utilisé pour fournir au public des services de communications électroniques",
      "Un réseau privé domestique uniquement",
      "Un réseau réservé aux administrations",
    ],
    answer:
        "Un réseau établi/utilisé pour fournir au public des services de communications électroniques",
    explanation: "Définition reprise du cours (CPCE).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Communications électroniques",
    question: "Les communications électroniques s’entendent comme :",
    options: [
      "Émissions/transmissions/réceptions de signes, signaux, écrits, images ou sons par divers moyens",
      "Uniquement les appels téléphoniques",
      "Uniquement les SMS",
    ],
    answer:
        "Émissions/transmissions/réceptions de signes, signaux, écrits, images ou sons par divers moyens",
    explanation: "Formulation du cours : câble, hertzien, optique, etc.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Correspondances matérielles",
    question: "Sont protégées comme correspondances matérielles :",
    options: [
      "Plis clos et plis ouverts, imprimés, journaux, paquets, etc.",
      "Uniquement les plis clos",
      "Uniquement les courriers professionnels",
    ],
    answer: "Plis clos et plis ouverts, imprimés, journaux, paquets, etc.",
    explanation:
        "Le cours précise que les plis clos comme ouverts sont protégés.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Contenu",
    question: "Le contenu de la correspondance protégée peut être :",
    options: [
      "Professionnel ou privé",
      "Uniquement privé",
      "Uniquement professionnel",
    ],
    answer: "Professionnel ou privé",
    explanation: "Peu importe le contenu : pro ou privé.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Télécommunications",
    question:
        "Pour les correspondances par télécommunications, elles doivent être :",
    options: [
      "En cours de transmission ou parvenues à destination mais non encore appréhendées par le destinataire",
      "Uniquement non envoyées",
      "Uniquement déjà lues",
    ],
    answer:
        "En cours de transmission ou parvenues à destination mais non encore appréhendées par le destinataire",
    explanation: "Condition donnée pour correspondances dématérialisées.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Modalités",
    question: "Dans 432-9, 'ordonner' correspond à :",
    options: [
      "Un ordre émanant d’une personne dépositaire de l’autorité publique (abus de pouvoir)",
      "Un simple conseil sans autorité",
      "Une demande de service entre collègues",
    ],
    answer:
        "Un ordre émanant d’une personne dépositaire de l’autorité publique (abus de pouvoir)",
    explanation: "Le cours relie ordonner à l’abus de pouvoir.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Contenu de l’atteinte",
    question: "Le 'détournement' d’une correspondance vise :",
    options: [
      "La modification du cours de sa transmission (atteinte à l’acheminement)",
      "La remise au bon destinataire",
      "La destruction d’un brouillon",
    ],
    answer:
        "La modification du cours de sa transmission (atteinte à l’acheminement)",
    explanation:
        "Le cours précise : atteinte à l’acheminement = détourner/modifier le cours.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Inviolabilité du support",
    question: "L’atteinte à l’inviolabilité du support peut consister en :",
    options: [
      "L’ouverture d’une correspondance",
      "La lecture d’un courrier reçu par soi-même",
      "L’affranchissement d’une lettre",
    ],
    answer: "L’ouverture d’une correspondance",
    explanation: "Exemple clair donné dans le cours.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Suppression",
    question: "La suppression d’une correspondance consiste en :",
    options: [
      "Tout acte empêchant qu’elle ne parvienne à destination",
      "Le fait de la remettre en main propre",
      "Le fait de l’archiver",
    ],
    answer: "Tout acte empêchant qu’elle ne parvienne à destination",
    explanation: "Définition du cours.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Télécoms",
    question: "Pour les télécommunications, l’atteinte peut consister en :",
    options: [
      "Interception/détournement, utilisation ou divulgation du contenu",
      "Uniquement l’envoi d’un SMS",
      "Uniquement la suppression d’un mail de sa propre boîte",
    ],
    answer: "Interception/détournement, utilisation ou divulgation du contenu",
    explanation: "Le cours liste ces formes pour télécommunications.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Divulgation",
    question: "La divulgation consiste à :",
    options: [
      "Révéler à un tiers sans qualité le contenu d’une correspondance non destinée à l’agent",
      "Remettre à l’expéditeur",
      "Informer le destinataire",
    ],
    answer:
        "Révéler à un tiers sans qualité le contenu d’une correspondance non destinée à l’agent",
    explanation: "Définition du cours.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Élément moral",
    question: "L’élément moral (432-9) suppose :",
    options: [
      "Conscience d’agir sans droit, savoir que la correspondance ne lui est pas destinée",
      "Obligation d’intention de nuire",
      "Simple négligence",
    ],
    answer:
        "Conscience d’agir sans droit, savoir que la correspondance ne lui est pas destinée",
    explanation: "Le cours insiste sur la conscience d’agir sans droit.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Erreur de fait",
    question: "L’erreur de fait :",
    options: [
      "Peut faire disparaître l’intention si l’ouverture est par méprise (ex: rechercher l’adresse pour réexpédier)",
      "Aggrave toujours la peine",
      "N’a aucun effet",
    ],
    answer:
        "Peut faire disparaître l’intention si l’ouverture est par méprise (ex: rechercher l’adresse pour réexpédier)",
    explanation:
        "Le cours : l’erreur de fait entraîne la disparition de l’intention.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Circonstances aggravantes",
    question: "Pour 432-9, circonstances aggravantes :",
    options: ["Aucune", "Toujours présentes", "Uniquement si récidive"],
    answer: "Aucune",
    explanation: "Le cours indique : AUCUNE.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Répression",
    question: "Peines (432-9) :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans et 30 000 €",
      "5 ans et 75 000 €",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Répression indiquée : 3 ans + 45 000 € (al.1 et al.2).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Tentative",
    question: "La tentative (432-9) est :",
    options: ["NON", "OUI", "OUI uniquement pour télécoms"],
    answer: "NON",
    explanation: "Le cours précise : TENTATIVE : NON.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Complicité",
    question: "La complicité (432-9) est :",
    options: ["OUI", "NON", "Uniquement si l’auteur est un magistrat"],
    answer: "OUI",
    explanation: "Le cours indique : COMPLICITÉ : OUI.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Faits justificatifs",
    question: "432-9 exclut l’infraction lorsqu’elle est réalisée :",
    options: [
      "Dans les cas prévus par la loi (ex: procédures judiciaires)",
      "En dehors de tout texte",
      "Uniquement la nuit",
    ],
    answer: "Dans les cas prévus par la loi (ex: procédures judiciaires)",
    explanation: "Cas prévus par la loi : procédure judiciaire notamment.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Interceptions judiciaires",
    question:
        "Les interceptions télécoms peuvent être autorisées par le juge d’instruction :",
    options: [
      "En matière criminelle et pour les délits punis d’au moins 3 ans d’emprisonnement",
      "Pour tout délit, sans condition",
      "Uniquement pour contraventions",
    ],
    answer:
        "En matière criminelle et pour les délits punis d’au moins 3 ans d’emprisonnement",
    explanation: "Le cours cite le cadre (CPP 100 à 100-8).",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 432-7 — DISCRIMINATIONS PAR PERSONNE EXERÇANT FONCTION PUBLIQUE
  // =========================================================
  QuizQuestion(
    category: "Discriminations — Texte",
    question:
        "L’infraction de discrimination (par une personne exerçant une fonction publique) est prévue par :",
    options: [
      "Article 432-7 du Code pénal",
      "Article 432-8 du Code pénal",
      "Article 225-1 du Code pénal uniquement",
    ],
    answer: "Article 432-7 du Code pénal",
    explanation: "Le cours indique : article 432-7 C.P.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Définition",
    question:
        "La discrimination (432-7) commise par une personne dépositaire/chargée mission SP consiste notamment à :",
    options: [
      "Refuser le bénéfice d’un droit accordé par la loi ou entraver l’exercice normal d’une activité économique",
      "Uniquement insulter une personne",
      "Uniquement refuser de saluer",
    ],
    answer:
        "Refuser le bénéfice d’un droit accordé par la loi ou entraver l’exercice normal d’une activité économique",
    explanation: "Définition donnée en 1° et 2°.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Fondements",
    question:
        "La discrimination vise une distinction opérée entre personnes sur certains fondements, par exemple :",
    options: [
      "Origine, sexe, situation de famille, grossesse, handicap, âge, etc.",
      "Uniquement le niveau de diplôme",
      "Uniquement la tenue vestimentaire professionnelle",
    ],
    answer:
        "Origine, sexe, situation de famille, grossesse, handicap, âge, etc.",
    explanation: "Le cours liste de nombreux critères (225-1 et 225-1-1).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Qualité de l’auteur",
    question: "Pour 432-7, l’auteur doit être :",
    options: [
      "Dépositaire de l’autorité publique ou chargé d’une mission de service public",
      "Un particulier",
      "Uniquement une personne morale",
    ],
    answer:
        "Dépositaire de l’autorité publique ou chargé d’une mission de service public",
    explanation: "Condition de qualité rappelée dans le cours.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Exemples de droits",
    question: "Le 'droit accordé par la loi' peut consister en :",
    options: [
      "Une prestation sociale, un document administratif, un concours, une mutation, un congé, etc.",
      "Une faveur au bon vouloir d’un agent",
      "Un pourboire obligatoire",
    ],
    answer:
        "Une prestation sociale, un document administratif, un concours, une mutation, un congé, etc.",
    explanation: "Exemples donnés dans le cours.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Discrétion",
    question: "Ne constitue pas un 'droit accordé par la loi' :",
    options: [
      "Une simple liberté d’appréciation laissée à la discrétion d’un fonctionnaire (ex: distinction)",
      "L’obtention d’un document administratif prévu par un texte",
      "Le bénéfice d’une prestation sociale",
    ],
    answer:
        "Une simple liberté d’appréciation laissée à la discrétion d’un fonctionnaire (ex: distinction)",
    explanation: "Le cours le précise explicitement.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Discriminations — Activité économique",
    question: "Entraver une activité économique consiste à :",
    options: [
      "Rendre plus difficile l’exercice d’une activité (tracasseries, pressions, dénigrement, etc.)",
      "Refuser de travailler",
      "Faire une publicité",
    ],
    answer:
        "Rendre plus difficile l’exercice d’une activité (tracasseries, pressions, dénigrement, etc.)",
    explanation: "Le cours donne des exemples d’entrave.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Victime",
    question: "Les agissements discriminatoires peuvent viser :",
    options: [
      "Une personne physique ou les membres d’une personne morale",
      "Uniquement une personne physique",
      "Uniquement une association",
    ],
    answer: "Une personne physique ou les membres d’une personne morale",
    explanation: "Le cours précise les deux.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Élément moral",
    question: "L’élément moral de 432-7 exige :",
    options: [
      "Une volonté discriminatoire (conscience de se livrer à des agissements discriminatoires)",
      "Une simple imprudence",
      "Aucune intention",
    ],
    answer:
        "Une volonté discriminatoire (conscience de se livrer à des agissements discriminatoires)",
    explanation: "Le cours : existence d’une volonté discriminatoire.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Circonstances aggravantes",
    question: "Circonstances aggravantes pour 432-7 :",
    options: ["Aucune", "Uniquement si récidive", "Uniquement si violence"],
    answer: "Aucune",
    explanation: "Le cours indique : AUCUNE.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Répression",
    question: "Peines principales (personnes physiques) pour 432-7 :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans et 45 000 €",
      "2 ans et 30 000 €",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Répression mentionnée : 5 ans + 75 000 €.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Tentative",
    question: "La tentative (432-7) est :",
    options: ["NON", "OUI", "OUI uniquement si entrave économique"],
    answer: "NON",
    explanation: "Le cours précise : la tentative n’est pas incriminée.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Complicité",
    question: "La complicité (432-7) est :",
    options: [
      "OUI (121-6 et 121-7)",
      "NON",
      "OUI uniquement si l’auteur est maire",
    ],
    answer: "OUI (121-6 et 121-7)",
    explanation:
        "Complicité punissable conformément aux articles 121-6 et 121-7.",
    difficulty: "Moyenne",
  ),

  // ✅ Questions supplémentaires à ajouter après celles-ci (432-8 — inviolabilité du domicile)
  QuizQuestion(
    category: "Inviolabilité du domicile — Conditions",
    question:
        "Pour que l’infraction (432-8) soit constituée, l’auteur doit agir :",
    options: [
      "Dans l’exercice ou à l’occasion de l’exercice de ses fonctions ou de sa mission",
      "Uniquement en dehors de ses fonctions",
      "Uniquement en dehors de tout cadre professionnel",
    ],
    answer:
        "Dans l’exercice ou à l’occasion de l’exercice de ses fonctions ou de sa mission",
    explanation:
        "Le texte exige que l’auteur agisse dans l’exercice ou à l’occasion de l’exercice de ses fonctions/mission.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Abus de qualité",
    question:
        "L’auteur doit avoir abusé de sa qualité pour pénétrer au domicile, ce qui exclut :",
    options: [
      "Une violation de domicile pour des raisons personnelles",
      "Une action réalisée dans le cadre de ses attributions",
      "Une action liée à l’exercice de la mission",
    ],
    answer: "Une violation de domicile pour des raisons personnelles",
    explanation:
        "Le cours précise que l’auteur doit avoir abusé de sa qualité et que les raisons personnelles sont exclues.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Notion de domicile",
    question: "Le domicile se définit comme :",
    options: [
      "Le lieu où une personne a le droit de se dire chez elle, qu’elle y habite ou non",
      "Uniquement le domicile légal déclaré",
      "Uniquement un logement dont la personne est propriétaire",
    ],
    answer:
        "Le lieu où une personne a le droit de se dire chez elle, qu’elle y habite ou non",
    explanation:
        "Le cours définit le domicile comme le lieu où la personne a le droit de se dire chez elle, indépendamment du titre.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Étendue",
    question: "La notion de domicile peut recouvrir :",
    options: [
      "Le domicile légal, une résidence, ou un lieu de séjour occasionnel",
      "Uniquement la résidence principale",
      "Uniquement un logement occupé en permanence",
    ],
    answer:
        "Le domicile légal, une résidence, ou un lieu de séjour occasionnel",
    explanation:
        "Le cours indique que le domicile peut être légal, résidence, ou lieu de séjour occasionnel.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Logement inoccupé",
    question: "Un logement inoccupé peut être considéré comme un domicile si :",
    options: [
      "Il contient des meubles signalant une occupation effective (table, chaises, lit, etc.)",
      "Il contient seulement une bicyclette ou un carton de livres",
      "Il est vide mais la porte est verrouillée",
    ],
    answer:
        "Il contient des meubles signalant une occupation effective (table, chaises, lit, etc.)",
    explanation:
        "Le cours précise que la présence de meubles peut caractériser le domicile si elle permet de s’y dire chez soi; vélo/carton seuls insuffisants.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Dépendances",
    question: "Le domicile se comprend comme :",
    options: [
      "Une habitation quelconque avec ses dépendances (caves, terrasses, etc.)",
      "Uniquement les pièces à vivre",
      "Uniquement l’entrée et le salon",
    ],
    answer:
        "Une habitation quelconque avec ses dépendances (caves, terrasses, etc.)",
    explanation:
        "Le cours inclut les dépendances (caves, terrasses…) dans la notion de domicile.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Jardins/Parcs",
    question: "Cours, jardins et parcs sont assimilés au domicile lorsque :",
    options: [
      "Ils sont clos et attenants à l’habitation",
      "Ils sont visibles depuis la rue",
      "Ils appartiennent à la commune",
    ],
    answer: "Ils sont clos et attenants à l’habitation",
    explanation:
        "Le cours précise l’assimilation dès lors que ces lieux sont clos et attenants à l’habitation.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Proximité",
    question:
        "Pour qu’une dépendance entre dans la notion de domicile, la jurisprudence exige :",
    options: [
      "Un lien étroit et immédiat et une proximité avec l’habitation",
      "Uniquement qu’elle soit sur la même parcelle cadastrale",
      "Aucune condition particulière",
    ],
    answer: "Un lien étroit et immédiat et une proximité avec l’habitation",
    explanation:
        "Le cours insiste sur la nécessité d’un lien étroit et immédiat et d’une proximité entre dépendance et habitation.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Acte matériel",
    question: "L’action incriminée par l’article 432-8 vise :",
    options: [
      "L’introduction ou la tentative d’introduction dans un domicile",
      "Le maintien dans un domicile",
      "Le fait de rester sur le trottoir devant le domicile",
    ],
    answer: "L’introduction ou la tentative d’introduction dans un domicile",
    explanation:
        "Le texte vise l’introduction/tentative; il ne vise pas le maintien dans les lieux.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Moyen",
    question: "L’introduction illicite (432-8) peut être réalisée :",
    options: [
      "Quel que soit le moyen, même sans violence ou artifice",
      "Uniquement avec violence",
      "Uniquement avec effraction",
    ],
    answer: "Quel que soit le moyen, même sans violence ou artifice",
    explanation:
        "Le cours indique que l’introduction est répréhensible quel que soit le moyen, même sans violence ni artifice.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Contre le gré",
    question:
        "L’article 432-8 ne réprime l’introduction que si elle est effectuée :",
    options: [
      "Contre le gré de l’occupant",
      "Avec consentement exprès",
      "Sur invitation de l’occupant",
    ],
    answer: "Contre le gré de l’occupant",
    explanation:
        "Condition centrale : l’introduction doit être contre le gré de l’occupant; sinon l’infraction n’est pas constituée.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Absence de consentement",
    question:
        "Même sans opposition formelle, l’absence de consentement peut être retenue notamment si l’auteur pénètre :",
    options: [
      "À l’insu de l’occupant (ex: en enjambant une fenêtre ouverte)",
      "Uniquement après un refus écrit",
      "Uniquement après violence",
    ],
    answer: "À l’insu de l’occupant (ex: en enjambant une fenêtre ouverte)",
    explanation:
        "Le cours indique qu’il suffit que la personne n’ait pas consenti, ce qui englobe une entrée à l’insu de l’occupant.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Consentement vicié",
    question: "Le consentement de l’occupant ne doit pas être vicié par :",
    options: [
      "Des manœuvres ou stratagèmes policiers",
      "Une demande polie",
      "Une présence en uniforme",
    ],
    answer: "Des manœuvres ou stratagèmes policiers",
    explanation:
        "Le cours précise que le consentement vicié par des manœuvres/stratagèmes ne fait pas obstacle à la caractérisation.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Cas légaux",
    question: "432-8 sanctionne l’introduction lorsque celle-ci intervient :",
    options: [
      "Hors les cas permis par la loi",
      "Même lorsqu’un texte l’autorise",
      "Uniquement en journée",
    ],
    answer: "Hors les cas permis par la loi",
    explanation:
        "Le cours rappelle que certains textes autorisent l’entrée; 432-8 sanctionne l’entrée hors de ces cas.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Élément moral",
    question: "L’élément moral de l’infraction (432-8) implique :",
    options: [
      "La conscience de pénétrer irrégulièrement au domicile d’autrui",
      "L’intention obligatoire de nuire",
      "Une simple imprudence",
    ],
    answer: "La conscience de pénétrer irrégulièrement au domicile d’autrui",
    explanation:
        "Le cours vise la conscience de l’irrégularité des agissements (intention).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Circonstances aggravantes",
    question:
        "Concernant l’article 432-8, les circonstances aggravantes sont :",
    options: ["Aucune", "Toujours présentes", "Uniquement si effraction"],
    answer: "Aucune",
    explanation: "Le cours indique : IV - Circonstances aggravantes : AUCUNE.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Répression",
    question: "Peines encourues (personne physique) pour 432-8 :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation:
        "Le cours mentionne comme peines principales : 2 ans d’emprisonnement et 30 000 € d’amende.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Tentative",
    question:
        "La tentative de violation de domicile par une personne dépositaire/chargée mission SP (432-8) est :",
    options: [
      "Incriminée (OUI)",
      "Non incriminée",
      "Incriminée uniquement en cas de violence",
    ],
    answer: "Incriminée (OUI)",
    explanation:
        "Le cours indique explicitement : TENTATIVE : OUI (incriminée spécifiquement).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Complicité",
    question: "La complicité (432-8) est :",
    options: [
      "Punissable conformément aux articles 121-6 et 121-7 du Code pénal",
      "Impossible",
      "Punissable uniquement si l’auteur principal est un particulier",
    ],
    answer: "Punissable conformément aux articles 121-6 et 121-7 du Code pénal",
    explanation:
        "Le cours indique : complicité punissable (aide/assistance, provocation, instructions).",
    difficulty: "Moyenne",
  ),

  // ✅ Suite — encore plus de questions 432-8 (Inviolabilité du domicile)
  QuizQuestion(
    category: "Inviolabilité du domicile — Dépositaire de l'autorité publique",
    question:
        "Sont notamment concernés comme dépositaires de l’autorité publique :",
    options: [
      "Policiers, gendarmes, douaniers, huissiers de justice",
      "Agents immobiliers, employés de supermarché, commerçants",
      "Médecins, infirmiers, pharmaciens",
    ],
    answer: "Policiers, gendarmes, douaniers, huissiers de justice",
    explanation:
        "Le cours cite explicitement policiers, gendarmes, douaniers, huissiers, etc.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Responsables exécutifs locaux",
    question: "Ont aussi la qualité de dépositaires de l’autorité publique :",
    options: [
      "Maires, présidents d’intercommunalités, conseils départementaux et régionaux",
      "Uniquement les députés",
      "Uniquement les agents d’entretien municipaux",
    ],
    answer:
        "Maires, présidents d’intercommunalités, conseils départementaux et régionaux",
    explanation:
        "Le cours vise les responsables des exécutifs locaux (et certains adjoints/délégués).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Adjoints et délégués",
    question:
        "Le cours indique que possèdent la qualité de dépositaires de l’autorité publique :",
    options: [
      "Les adjoints au maire et conseillers municipaux délégués",
      "Tous les élus sans distinction",
      "Uniquement les parlementaires",
    ],
    answer: "Les adjoints au maire et conseillers municipaux délégués",
    explanation:
        "Ils sont mentionnés comme ayant la qualité de dépositaires de l’autorité publique.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Mission de service public",
    question: "Une personne chargée d’une mission de service public :",
    options: [
      "Participe à une mission d’intérêt général sans pouvoir de décision/commandement",
      "Dispose toujours d’un pouvoir de décision",
      "Est forcément fonctionnaire au sens strict",
    ],
    answer:
        "Participe à une mission d’intérêt général sans pouvoir de décision/commandement",
    explanation:
        "Le cours précise qu’elle participe à une mission d’intérêt général sans prérogatives de puissance publique.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Élus locaux et mission SP",
    question:
        "Les élus locaux peuvent être qualifiés de 'chargés d’une mission de service public' :",
    options: [
      "Lorsqu’ils ne reçoivent pas, par délégation, de prérogatives de puissance publique",
      "Uniquement lorsqu’ils sont maires",
      "Jamais, car un élu est toujours dépositaire de l’autorité publique",
    ],
    answer:
        "Lorsqu’ils ne reçoivent pas, par délégation, de prérogatives de puissance publique",
    explanation:
        "Le cours indique que sans délégation de prérogatives de puissance publique, ils sont chargés d’une mission SP.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — 'À l’occasion' des fonctions",
    question:
        "Agir 'à l’occasion de l’exercice des fonctions' implique que l’agent :",
    options: [
      "A abusé de sa qualité dans un contexte lié à ses fonctions, même hors stricte compétence",
      "A agi uniquement dans sa vie privée, sans lien avec ses fonctions",
      "A toujours agi en service et en uniforme",
    ],
    answer:
        "A abusé de sa qualité dans un contexte lié à ses fonctions, même hors stricte compétence",
    explanation:
        "Le cours distingue agir dans l’exercice ou à l’occasion : l’acte reste rattaché aux fonctions/mission.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Domicile et titre juridique",
    question: "Pour caractériser un domicile, il faut :",
    options: [
      "Que la personne ait le droit de s’y dire chez elle, quel que soit le titre juridique d’occupation",
      "Que la personne soit propriétaire des lieux",
      "Que la personne y soit domiciliée administrativement",
    ],
    answer:
        "Que la personne ait le droit de s’y dire chez elle, quel que soit le titre juridique d’occupation",
    explanation:
        "Le cours précise que le titre juridique importe peu : c’est le droit de s’y dire chez soi.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Condition d’intimité",
    question:
        "La seule condition rappelée par le cours pour retenir la notion de domicile est que :",
    options: [
      "Le lieu protège l’intimité",
      "Le lieu soit une résidence principale",
      "Le lieu soit déclaré aux impôts",
    ],
    answer: "Le lieu protège l’intimité",
    explanation:
        "Le cours indique : la condition est la protection de l’intimité.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Exemples meubles suffisants",
    question:
        "Parmi les éléments cités comme pouvant signaler une occupation effective d’un logement vacant :",
    options: [
      "Table, chaises, lit, canapé, appareils électroménagers",
      "Un carton de livres et une bicyclette",
      "Un tapis de sol seul",
    ],
    answer: "Table, chaises, lit, canapé, appareils électroménagers",
    explanation:
        "Le cours donne ces exemples et précise que bicyclette/carton seuls ne suffisent pas.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Moyen d’introduction",
    question: "Pour 432-8, l’introduction peut être caractérisée :",
    options: [
      "Même sans violence ni artifice, quel que soit le moyen",
      "Uniquement avec effraction",
      "Uniquement s’il y a dégradation",
    ],
    answer: "Même sans violence ni artifice, quel que soit le moyen",
    explanation:
        "Le cours précise : quel que soit le moyen, même sans violence ou artifice.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Non visé",
    question: "Le cours indique que n’est pas visé par 432-8 :",
    options: [
      "Le maintien dans un domicile",
      "La tentative d’introduction",
      "L’introduction sans violence",
    ],
    answer: "Le maintien dans un domicile",
    explanation:
        "Il est précisé : l’action incriminée est l’introduction ou la tentative, pas le maintien.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Enquête préliminaire (exemple)",
    question:
        "Selon l’exemple du cours, un OPJ en enquête préliminaire qui refuse de quitter les lieux après retrait du consentement écrit :",
    options: [
      "Ne commet pas une violation de domicile au sens de 432-8 (sur ce fondement)",
      "Commet automatiquement une violation de domicile",
      "Commet forcément une tentative de violation",
    ],
    answer:
        "Ne commet pas une violation de domicile au sens de 432-8 (sur ce fondement)",
    explanation:
        "Le cours donne cet exemple pour illustrer que le maintien n’est pas visé par 432-8.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Jurisprudence (hôtel)",
    question:
        "D’après la jurisprudence citée, des policiers qui invitent par téléphone un occupant d’hôtel à les rejoindre dans le hall :",
    options: [
      "Ne constituent pas une pénétration dans un domicile",
      "Constituent toujours une introduction dans un domicile",
      "Constituent une tentative d’introduction",
    ],
    answer: "Ne constituent pas une pénétration dans un domicile",
    explanation:
        "Le cours cite une décision où le hall d’hôtel + invitation ne vaut pas pénétration dans un domicile.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Jurisprudence (garage)",
    question:
        "D’après la jurisprudence citée, des gendarmes sur le seuil d’un garage ouvert par l’agent immobilier, sans y pénétrer :",
    options: [
      "Ne sont pas constitutifs d’une introduction dans un domicile",
      "Sont constitutifs d’une introduction dans un domicile",
      "Sont constitutifs d’une suppression de correspondance",
    ],
    answer: "Ne sont pas constitutifs d’une introduction dans un domicile",
    explanation:
        "Le cours cite une décision : photographie sur le seuil sans pénétrer ≠ introduction.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Consentement",
    question:
        "L’infraction n’est pas constituée si l’agent de la force publique pénètre au domicile :",
    options: [
      "Avec le consentement de l’occupant",
      "Même avec consentement",
      "Uniquement si l’occupant est absent",
    ],
    answer: "Avec le consentement de l’occupant",
    explanation:
        "Le texte précise : pas d’infraction si l’entrée est consentie (hors consentement vicié).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Consentement vicié (rappel)",
    question:
        "Le consentement n’empêche pas l’infraction s’il est obtenu par :",
    options: [
      "Manœuvres ou stratagèmes policiers",
      "Une demande claire et loyale",
      "Une autorisation écrite librement donnée",
    ],
    answer: "Manœuvres ou stratagèmes policiers",
    explanation:
        "Le cours précise que le consentement vicié par manœuvres/stratagèmes ne vaut pas consentement.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Hors les cas prévus par la loi",
    question:
        "Pourquoi 432-8 est qualifié de sanction du non-respect des conditions de fond ?",
    options: [
      "Parce qu’il sanctionne l’entrée au domicile lorsque les conditions légales d’intervention ne sont pas respectées",
      "Parce qu’il sanctionne toute intervention, même régulière",
      "Parce qu’il sanctionne uniquement les dégradations",
    ],
    answer:
        "Parce qu’il sanctionne l’entrée au domicile lorsque les conditions légales d’intervention ne sont pas respectées",
    explanation:
        "Le cours indique que 432-8 sanctionne le non-respect des conditions de fond encadrant les interventions publiques.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Personnes morales",
    question: "Le cours indique que les personnes morales :",
    options: [
      "Peuvent être reconnues responsables pénalement",
      "Ne peuvent jamais être responsables",
      "Sont responsables uniquement pour les contraventions",
    ],
    answer: "Peuvent être reconnues responsables pénalement",
    explanation:
        "Le tableau de répression mentionne : personnes morales peuvent être reconnues responsables.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Inviolabilité du domicile — Complicité (formes)",
    question: "La complicité peut résulter notamment de :",
    options: [
      "Aide/assistance, provocation, ou instructions données",
      "Uniquement d’un silence",
      "Uniquement d’un témoignage ultérieur",
    ],
    answer: "Aide/assistance, provocation, ou instructions données",
    explanation:
        "Le cours cite ces faits constitutifs de complicité (121-6 et 121-7).",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 432-9 — ATTEINTE AU SECRET DES CORRESPONDANCES
  // =========================================================
  QuizQuestion(
    category: "Secret des correspondances — Définition",
    question:
        "L’atteinte au secret des correspondances consiste notamment, pour une personne dépositaire de l’autorité publique ou chargée d’une mission de service public, à :",
    options: [
      "Ordonner, commettre ou faciliter le détournement, la suppression, l’ouverture ou la révélation du contenu de correspondances, hors les cas prévus par la loi",
      "Lire une correspondance avec l’accord de son destinataire",
      "Conserver une correspondance déjà remise à son destinataire",
    ],
    answer:
        "Ordonner, commettre ou faciliter le détournement, la suppression, l’ouverture ou la révélation du contenu de correspondances, hors les cas prévus par la loi",
    explanation:
        "Définition complète de l’atteinte au secret des correspondances donnée par le cours.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Texte",
    question:
        "L’infraction d’atteinte au secret des correspondances est prévue par :",
    options: [
      "L’article 432-9 du Code pénal",
      "L’article 432-8 du Code pénal",
      "L’article 225-1 du Code pénal",
    ],
    answer: "L’article 432-9 du Code pénal",
    explanation:
        "Le cours indique que l’infraction est prévue et réprimée par l’article 432-9 du C.P.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Auteurs",
    question: "Peut être auteur de l’infraction prévue à l’article 432-9 :",
    options: [
      "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
      "Uniquement un particulier",
      "Uniquement un magistrat",
    ],
    answer:
        "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
    explanation: "Le texte vise spécifiquement ces catégories d’auteurs.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Autres auteurs",
    question: "Peut également être auteur de l’atteinte aux correspondances :",
    options: [
      "Un agent d’un exploitant de réseaux ouverts au public de communications électroniques ou d’un fournisseur de services de télécommunications",
      "Uniquement un agent de La Poste",
      "Uniquement un officier de police judiciaire",
    ],
    answer:
        "Un agent d’un exploitant de réseaux ouverts au public de communications électroniques ou d’un fournisseur de services de télécommunications",
    explanation:
        "Le cours étend l’infraction à certains agents des réseaux et télécommunications.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Agissement",
    question: "L’auteur doit agir :",
    options: [
      "Dans l’exercice ou à l’occasion de l’exercice de ses fonctions ou de sa mission",
      "Uniquement en dehors de ses fonctions",
      "Uniquement à titre personnel",
    ],
    answer:
        "Dans l’exercice ou à l’occasion de l’exercice de ses fonctions ou de sa mission",
    explanation: "Condition identique à celle des autres abus d’autorité.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Correspondances matérielles",
    question: "Sont considérées comme correspondances matérielles :",
    options: [
      "Plis clos, plis ouverts, imprimés, journaux, paquets",
      "Uniquement les lettres fermées",
      "Uniquement les colis recommandés",
    ],
    answer: "Plis clos, plis ouverts, imprimés, journaux, paquets",
    explanation:
        "Le cours précise que les plis clos comme ouverts sont protégés.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Télécommunications",
    question:
        "Les correspondances émises par la voie des télécommunications sont :",
    options: [
      "Des correspondances dématérialisées sans support tangible",
      "Uniquement des courriers électroniques",
      "Uniquement des appels téléphoniques",
    ],
    answer: "Des correspondances dématérialisées sans support tangible",
    explanation:
        "Le cours définit les correspondances télécoms comme dématérialisées.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — État de la correspondance",
    question:
        "Pour être protégées, les correspondances télécoms doivent être :",
    options: [
      "En cours de transmission ou parvenues à destination mais non encore appréhendées par le destinataire",
      "Uniquement non envoyées",
      "Uniquement déjà lues",
    ],
    answer:
        "En cours de transmission ou parvenues à destination mais non encore appréhendées par le destinataire",
    explanation: "Condition précisée dans le cours.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Actes matériels",
    question: "L’atteinte peut consister notamment à :",
    options: [
      "Détourner, supprimer, ouvrir une correspondance ou en révéler le contenu",
      "Retarder une réponse administrative",
      "Refuser d’écrire une lettre",
    ],
    answer:
        "Détourner, supprimer, ouvrir une correspondance ou en révéler le contenu",
    explanation: "Liste des actes matériels constitutifs de l’infraction.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Détournement",
    question: "Le détournement d’une correspondance consiste à :",
    options: [
      "Modifier le cours de sa transmission",
      "La remettre à son destinataire",
      "La classer dans un dossier",
    ],
    answer: "Modifier le cours de sa transmission",
    explanation:
        "Le cours vise l’atteinte à l’acheminement de la correspondance.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Ouverture",
    question: "L’ouverture d’une correspondance constitue :",
    options: [
      "Une atteinte à l’inviolabilité du support",
      "Une simple irrégularité administrative",
      "Un fait justificatif",
    ],
    answer: "Une atteinte à l’inviolabilité du support",
    explanation:
        "Le cours qualifie l’ouverture comme atteinte à l’inviolabilité du support.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Révélation",
    question: "La révélation du contenu d’une correspondance consiste à :",
    options: [
      "Divulguer à un tiers sans qualité le contenu d’une correspondance qui ne lui est pas destinée",
      "Informer le destinataire",
      "Transmettre la correspondance à son auteur",
    ],
    answer:
        "Divulguer à un tiers sans qualité le contenu d’une correspondance qui ne lui est pas destinée",
    explanation: "Définition donnée par le cours.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Élément moral",
    question: "L’élément moral de l’infraction 432-9 suppose :",
    options: [
      "La conscience d’agir sans droit et de porter atteinte au secret de la correspondance",
      "Une intention de nuire obligatoire",
      "Une simple négligence",
    ],
    answer:
        "La conscience d’agir sans droit et de porter atteinte au secret de la correspondance",
    explanation: "Le cours précise que l’intention de nuire n’est pas exigée.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Erreur de fait",
    question: "L’erreur de fait peut entraîner :",
    options: [
      "La disparition de l’intention et donc l’absence d’infraction",
      "Une aggravation de la peine",
      "Une qualification automatique",
    ],
    answer: "La disparition de l’intention et donc l’absence d’infraction",
    explanation: "Exemple : ouverture par méprise pour réexpédier une lettre.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Tentative",
    question:
        "La tentative d’atteinte au secret des correspondances (432-9) est :",
    options: [
      "Non incriminée",
      "Incriminée",
      "Incriminée uniquement pour les télécommunications",
    ],
    answer: "Non incriminée",
    explanation: "Le cours précise expressément : TENTATIVE : NON.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Répression",
    question: "Les peines encourues pour l’article 432-9 sont :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Répression prévue par l’article 432-9.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 432-7 — DISCRIMINATIONS PAR PERSONNE EXERÇANT UNE FONCTION PUBLIQUE
  // =========================================================
  QuizQuestion(
    category: "Discriminations — Définition",
    question:
        "La discrimination commise par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public consiste notamment à :",
    options: [
      "Refuser le bénéfice d’un droit accordé par la loi ou entraver l’exercice normal d’une activité économique",
      "Tenir des propos désobligeants",
      "Refuser une faveur discrétionnaire",
    ],
    answer:
        "Refuser le bénéfice d’un droit accordé par la loi ou entraver l’exercice normal d’une activité économique",
    explanation: "Définition donnée par l’article 432-7 du Code pénal.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Texte",
    question: "L’infraction de discrimination est prévue par :",
    options: [
      "L’article 432-7 du Code pénal",
      "L’article 225-1 du Code pénal uniquement",
      "L’article 432-8 du Code pénal",
    ],
    answer: "L’article 432-7 du Code pénal",
    explanation:
        "Le cours indique que l’infraction est prévue par l’article 432-7.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Critères",
    question: "La discrimination peut être fondée notamment sur :",
    options: [
      "L’origine, le sexe, la situation de famille, l’état de santé, le handicap, l’âge",
      "Le niveau scolaire uniquement",
      "La tenue vestimentaire professionnelle",
    ],
    answer:
        "L’origine, le sexe, la situation de famille, l’état de santé, le handicap, l’âge",
    explanation:
        "Liste non exhaustive des critères mentionnés par le Code pénal.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Droit accordé par la loi",
    question: "Le 'droit accordé par la loi' s’entend :",
    options: [
      "De toute règle de portée générale et impersonnelle",
      "Uniquement d’une loi votée par le Parlement",
      "Uniquement d’un règlement intérieur",
    ],
    answer: "De toute règle de portée générale et impersonnelle",
    explanation:
        "Le cours précise que la notion de loi n’est pas entendue de manière restrictive.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Discriminations — Activité économique",
    question: "Entraver l’exercice d’une activité économique consiste à :",
    options: [
      "Rendre plus difficile l’exercice de cette activité",
      "Empêcher toute activité commerciale",
      "Refuser une aide facultative",
    ],
    answer: "Rendre plus difficile l’exercice de cette activité",
    explanation:
        "Le cours cite notamment les tracasseries administratives, pressions, dénigrement.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Élément moral",
    question: "L’élément moral de la discrimination suppose :",
    options: [
      "Une volonté discriminatoire consciente",
      "Une simple erreur administrative",
      "Une négligence",
    ],
    answer: "Une volonté discriminatoire consciente",
    explanation: "Le cours précise l’existence d’une volonté discriminatoire.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Tentative",
    question: "La tentative de discrimination (432-7) est :",
    options: [
      "Non incriminée",
      "Incriminée",
      "Incriminée uniquement en cas de récidive",
    ],
    answer: "Non incriminée",
    explanation: "Le cours précise que la tentative n’est pas incriminée.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Répression",
    question: "Les peines encourues pour l’article 432-7 sont :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Répression prévue par l’article 432-7 du Code pénal.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 432-9 — ATTEINTE AU SECRET DES CORRESPONDANCES (SUITE)
  // =========================================================
  QuizQuestion(
    category: "Secret des correspondances — Ordonner",
    question:
        "Dans le cadre de l’article 432-9, l’action d’« ordonner » suppose :",
    options: [
      "Un abus de pouvoir émanant d’une personne dépositaire de l’autorité publique",
      "Une simple suggestion sans autorité",
      "Une demande amicale entre collègues",
    ],
    answer:
        "Un abus de pouvoir émanant d’une personne dépositaire de l’autorité publique",
    explanation:
        "Le cours précise que l’ordre doit émaner d’une personne dépositaire de l’autorité publique.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Commettre",
    question: "Dans l’article 432-9, le terme « commettre » vise :",
    options: [
      "L’acte matériel directement accompli par l’auteur lui-même",
      "Uniquement le fait de donner des instructions",
      "Uniquement le fait de surveiller",
    ],
    answer: "L’acte matériel directement accompli par l’auteur lui-même",
    explanation:
        "Le cours distingue clairement ordonner / commettre / faciliter.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Faciliter",
    question:
        "Faciliter une atteinte au secret des correspondances consiste à :",
    options: [
      "Fournir des indications, instructions ou une aide permettant la commission de l’infraction",
      "Observer sans intervenir",
      "Ignorer volontairement les faits",
    ],
    answer:
        "Fournir des indications, instructions ou une aide permettant la commission de l’infraction",
    explanation:
        "La facilitation correspond à une aide matérielle ou intellectuelle.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Photocopie",
    question:
        "La photocopie de documents contenus dans une correspondance constitue :",
    options: [
      "Une atteinte au secret des correspondances",
      "Un acte neutre sans conséquence pénale",
      "Un simple manquement disciplinaire",
    ],
    answer: "Une atteinte au secret des correspondances",
    explanation:
        "Le cours cite expressément la photocopie comme modalité d’atteinte.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Interception",
    question: "L’interception d’une correspondance consiste à :",
    options: [
      "Capter un message pendant le cours de sa transmission",
      "Lire un message déjà ouvert par son destinataire",
      "Archiver un message reçu légalement",
    ],
    answer: "Capter un message pendant le cours de sa transmission",
    explanation: "Définition donnée pour les correspondances télécoms.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Utilisation",
    question: "L’utilisation du contenu d’une correspondance vise :",
    options: [
      "Le fait de se servir du contenu comme si l’agent en était le destinataire",
      "La simple conservation de la correspondance",
      "La restitution immédiate",
    ],
    answer:
        "Le fait de se servir du contenu comme si l’agent en était le destinataire",
    explanation: "L’utilisation est distincte de la divulgation.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Jurisprudence",
    question:
        "Selon la jurisprudence citée, la lecture et la divulgation de mails d’un étudiant constituent :",
    options: [
      "Une violation du secret des correspondances",
      "Un simple contrôle administratif",
      "Un fait justificatif",
    ],
    answer: "Une violation du secret des correspondances",
    explanation: "C.A. Paris, 17 décembre 2001.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Intention",
    question: "L’élément intentionnel de l’article 432-9 :",
    options: [
      "N’exige pas l’intention de nuire",
      "Exige nécessairement une intention de nuire",
      "Est présumé automatiquement",
    ],
    answer: "N’exige pas l’intention de nuire",
    explanation:
        "La Cour de cassation précise que l’intention de nuire n’est pas requise.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Erreur de fait (limite)",
    question:
        "L’erreur de fait en matière de correspondances télécoms ne s’applique que si :",
    options: [
      "Il est possible de recevoir la correspondance sans en connaître le contenu",
      "La correspondance a déjà été lue",
      "L’agent est en service",
    ],
    answer:
        "Il est possible de recevoir la correspondance sans en connaître le contenu",
    explanation:
        "Précision du cours concernant l’application de l’erreur de fait.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Faits justificatifs",
    question:
        "L’atteinte au secret des correspondances n’est pas constituée lorsqu’elle est réalisée :",
    options: [
      "Dans les cas prévus par la loi",
      "Pour faciliter une enquête",
      "À titre préventif",
    ],
    answer: "Dans les cas prévus par la loi",
    explanation: "Exemples : procédures judiciaires autorisées par le CPP.",
    difficulty: "Facile",
  ),

  // =========================================================
  // 432-7 — DISCRIMINATIONS (SUITE ET APPROFONDISSEMENT)
  // =========================================================
  QuizQuestion(
    category: "Discriminations — Qualité de l’auteur",
    question: "L’article 432-7 vise les discriminations commises par :",
    options: [
      "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
      "Tout particulier",
      "Uniquement les élus",
    ],
    answer:
        "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
    explanation: "Condition de qualité indispensable à la qualification.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Refus de droit",
    question:
        "Refuser le bénéfice d’un droit accordé par la loi peut concerner :",
    options: [
      "L’obtention d’un document administratif",
      "Une faveur discrétionnaire",
      "Une décision purement politique",
    ],
    answer: "L’obtention d’un document administratif",
    explanation: "Le cours cite explicitement les documents administratifs.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Libertés publiques",
    question: "Le droit accordé par la loi peut consister en :",
    options: [
      "L’exercice des libertés publiques",
      "Une simple tolérance administrative",
      "Une faveur personnelle",
    ],
    answer: "L’exercice des libertés publiques",
    explanation: "Le cours mentionne expressément les libertés publiques.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Exclusion",
    question:
        "Ne constitue pas un refus du bénéfice d’un droit accordé par la loi :",
    options: [
      "L’exercice d’un pouvoir discrétionnaire (ex : attribution d’une distinction)",
      "Le refus d’un document obligatoire",
      "Le refus d’un droit social",
    ],
    answer:
        "L’exercice d’un pouvoir discrétionnaire (ex : attribution d’une distinction)",
    explanation: "Cass. crim., 17 juin 2008.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Discriminations — Entrave économique",
    question: "L’entrave à une activité économique peut résulter :",
    options: [
      "De tracasseries administratives ou de pressions",
      "Uniquement d’une interdiction formelle",
      "Uniquement d’une condamnation judiciaire",
    ],
    answer: "De tracasseries administratives ou de pressions",
    explanation: "Le cours cite les tracasseries, pressions, dénigrement.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Victime",
    question:
        "Les discriminations réprimées par l’article 432-7 peuvent viser :",
    options: [
      "Une personne physique ou une personne morale",
      "Uniquement une personne physique",
      "Uniquement une entreprise",
    ],
    answer: "Une personne physique ou une personne morale",
    explanation: "Le cours précise que les deux sont visées.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Élément moral",
    question: "La discrimination suppose :",
    options: [
      "La conscience de se livrer à des agissements discriminatoires",
      "Une simple négligence",
      "Un résultat préjudiciable",
    ],
    answer: "La conscience de se livrer à des agissements discriminatoires",
    explanation: "L’élément moral est une volonté discriminatoire.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Fait justificatif",
    question:
        "La répression est écartée lorsque les agissements discriminatoires sont :",
    options: [
      "Conformes à un texte légal autorisant ces agissements",
      "Motivés par une urgence",
      "Justifiés moralement",
    ],
    answer: "Conformes à un texte légal autorisant ces agissements",
    explanation: "Exemple : directives gouvernementales prévues par la loi.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Discriminations — Tentative",
    question: "La tentative de discrimination est :",
    options: [
      "Non incriminée",
      "Incriminée",
      "Incriminée uniquement en cas de récidive",
    ],
    answer: "Non incriminée",
    explanation: "Le cours précise expressément : tentative non incriminée.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Complicité",
    question: "La complicité de discrimination est punissable :",
    options: [
      "Conformément aux articles 121-6 et 121-7 du Code pénal",
      "Uniquement pour les personnes morales",
      "Uniquement en cas de violence",
    ],
    answer: "Conformément aux articles 121-6 et 121-7 du Code pénal",
    explanation: "Régime classique de la complicité pénale.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 432-9 — ATTEINTE AU SECRET DES CORRESPONDANCES (ENCORE)
  // =========================================================
  QuizQuestion(
    category: "Secret des correspondances — Réseau ouvert au public",
    question:
        "Un réseau ouvert au public de communications électroniques est un réseau :",
    options: [
      "Établi ou utilisé pour fournir au public des services de communications électroniques",
      "Réservé uniquement aux forces de l’ordre",
      "Exclusivement interne à une entreprise privée",
    ],
    answer:
        "Établi ou utilisé pour fournir au public des services de communications électroniques",
    explanation:
        "Définition reprise du code des postes et communications électroniques citée dans le cours.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Exemples de réseaux",
    question:
        "Sont cités comme pouvant être des réseaux de communications électroniques :",
    options: [
      "Réseaux satellitaires, terrestres et certains systèmes utilisant le réseau électrique",
      "Uniquement les réseaux téléphoniques filaires",
      "Uniquement la radio FM",
    ],
    answer:
        "Réseaux satellitaires, terrestres et certains systèmes utilisant le réseau électrique",
    explanation: "Le cours énumère ces exemples de réseaux.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Auteur (agent de réseau)",
    question:
        "Pour être auteur en tant qu’agent d’un exploitant de réseau ouvert au public, il faut :",
    options: [
      "Travailler pour une personne physique ou morale exploitant ce réseau, salariée ou non",
      "Être obligatoirement cadre dirigeant",
      "Être exclusivement fonctionnaire",
    ],
    answer:
        "Travailler pour une personne physique ou morale exploitant ce réseau, salariée ou non",
    explanation:
        "Le cours précise que cela vise toute personne relevant de l’autorité de l’exploitant, salariée ou non.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Fournisseur télécoms",
    question:
        "Un agent d’un fournisseur de services de télécommunications est :",
    options: [
      "Toute personne travaillant pour une personne physique ou morale qui assure une fourniture de services",
      "Uniquement un agent public",
      "Uniquement un sous-traitant indépendant hors entreprise",
    ],
    answer:
        "Toute personne travaillant pour une personne physique ou morale qui assure une fourniture de services",
    explanation:
        "Définition large donnée par le cours : salariée ou non, quelle que soit la position.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Peu importe le contenu",
    question: "Pour 432-9, le contenu de la correspondance :",
    options: [
      "Est indifférent : privé ou professionnel",
      "Doit être uniquement privé",
      "Doit être uniquement professionnel",
    ],
    answer: "Est indifférent : privé ou professionnel",
    explanation:
        "Le cours précise que peu importe le contenu : privé ou professionnel.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Moment de protection",
    question:
        "Une correspondance par télécommunications est protégée lorsqu’elle est :",
    options: [
      "En cours de transmission ou arrivée à destination mais non encore appréhendée",
      "Uniquement avant envoi",
      "Uniquement après lecture par le destinataire",
    ],
    answer:
        "En cours de transmission ou arrivée à destination mais non encore appréhendée",
    explanation: "Condition exacte rappelée dans le cours.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Détournement (mail)",
    question: "Le détournement d’un courrier électronique peut consister à :",
    options: [
      "Dévier le mail vers une autre boîte que celle du destinataire",
      "Supprimer le mail de sa propre boîte",
      "Répondre au mail",
    ],
    answer: "Dévier le mail vers une autre boîte que celle du destinataire",
    explanation: "Exemple de manipulation informatique cité dans le cours.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Divulgation (tiers)",
    question: "Effectue une divulgation le tiers qui :",
    options: [
      "Transmet à autrui un e-mail qu’il a réussi à intercepter",
      "Supprime un e-mail intercepté",
      "Avertit le destinataire qu’il a été intercepté",
    ],
    answer: "Transmet à autrui un e-mail qu’il a réussi à intercepter",
    explanation: "Le cours donne cet exemple pour qualifier la divulgation.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Complicité",
    question:
        "Un particulier peut être complice d’un dépositaire de l’autorité publique (432-9) s’il :",
    options: [
      "Fournit les moyens matériels pour intercepter ou détourner une correspondance",
      "Se contente d’entendre parler des faits",
      "Refuse de témoigner",
    ],
    answer:
        "Fournit les moyens matériels pour intercepter ou détourner une correspondance",
    explanation:
        "Le cours indique qu’un particulier peut se rendre complice en fournissant des moyens.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Élément intentionnel (Cass.)",
    question:
        "Selon la jurisprudence citée (27 février 2018), l’élément intentionnel implique :",
    options: [
      "L’intention de porter atteinte au contenu des correspondances litigieuses",
      " provenir d’un dommage effectif",
      "Une intention de nuire obligatoire",
    ],
    answer:
        "L’intention de porter atteinte au contenu des correspondances litigieuses",
    explanation:
        "Le cours cite : intention de porter atteinte au contenu (sans exigence d’intention de nuire).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Circonstances aggravantes",
    question: "Pour l’infraction 432-9, les circonstances aggravantes sont :",
    options: [
      "Aucune",
      "Toujours présentes si télécommunications",
      "Présentes si la correspondance est privée",
    ],
    answer: "Aucune",
    explanation: "Le cours indique : IV - Circonstances aggravantes : AUCUNE.",
    difficulty: "Facile",
  ),

  // =========================================================
  // 432-7 — DISCRIMINATIONS (ENCORE)
  // =========================================================
  QuizQuestion(
    category: "Discriminations — Définition (2 branches)",
    question: "L’article 432-7 vise deux types d’actes discriminatoires :",
    options: [
      "Refuser un droit accordé par la loi / Entraver une activité économique",
      "Refuser un droit / Intercepter un courrier",
      "Entraver une activité économique / Violer un domicile",
    ],
    answer:
        "Refuser un droit accordé par la loi / Entraver une activité économique",
    explanation: "Le texte liste expressément 1° et 2°.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Droit accordé par la loi",
    question: "Le mot « loi » au sens de 432-7 doit être compris comme :",
    options: [
      "Toute règle de portée générale et impersonnelle",
      "Uniquement une loi parlementaire",
      "Uniquement un arrêté municipal",
    ],
    answer: "Toute règle de portée générale et impersonnelle",
    explanation: "Le cours précise que la notion n’est pas restrictive.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Discriminations — Exemples de droits",
    question:
        "Parmi les exemples de « droit accordé par la loi » cités par le cours :",
    options: [
      "Prestation sociale, document administratif, inscription à un concours, mutation, congé",
      "Uniquement un logement de fonction",
      "Uniquement une prime",
    ],
    answer:
        "Prestation sociale, document administratif, inscription à un concours, mutation, congé",
    explanation: "Liste d’exemples donnée dans le cours.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Ne constitue pas un droit",
    question: "Ne constitue pas un « droit accordé par la loi » :",
    options: [
      "Une distinction attribuée à la discrétion d’un fonctionnaire",
      "Une prestation sociale prévue par un texte",
      "Une liberté publique prévue par un texte",
    ],
    answer: "Une distinction attribuée à la discrétion d’un fonctionnaire",
    explanation:
        "Le cours précise qu’un pouvoir discrétionnaire (ex : distinction) n’est pas un droit.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Discriminations — Entrave économique (formes)",
    question:
        "Selon le cours, l’entrave à une activité économique peut résulter de :",
    options: [
      "Tracasseries administratives, dénigrement, pressions auprès de fournisseurs",
      "Uniquement d’une fermeture administrative",
      "Uniquement d’une condamnation pénale",
    ],
    answer:
        "Tracasseries administratives, dénigrement, pressions auprès de fournisseurs",
    explanation: "Exemples explicitement donnés dans le cours.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Victime",
    question:
        "Les agissements discriminatoires peuvent être commis au détriment :",
    options: [
      "D’une personne physique ou des membres d’une personne morale",
      "Uniquement d’une personne physique",
      "Uniquement d’une personne morale",
    ],
    answer: "D’une personne physique ou des membres d’une personne morale",
    explanation: "Le cours vise les deux hypothèses.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Élément moral",
    question: "La volonté discriminatoire se caractérise par :",
    options: [
      "La conscience de se livrer à des agissements discriminatoires",
      "La simple maladresse",
      "Le fait que la victime se sente discriminée",
    ],
    answer: "La conscience de se livrer à des agissements discriminatoires",
    explanation: "L’élément moral est une conscience/volonté discriminatoire.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Circonstances aggravantes",
    question: "Pour 432-7, les circonstances aggravantes sont :",
    options: [
      "Aucune",
      "Toujours présentes en cas de pluralité de victimes",
      "Présentes si la discrimination est publique",
    ],
    answer: "Aucune",
    explanation: "Le cours indique : IV - Circonstances aggravantes : AUCUNE.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Répression",
    question: "Les peines principales encourues pour 432-7 sont :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Le cours fixe la répression à 5 ans et 75 000 €.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Tentative",
    question: "La tentative en matière de discrimination (432-7) est :",
    options: [
      "Non incriminée",
      "Incriminée",
      "Incriminée si l’entrave est économique",
    ],
    answer: "Non incriminée",
    explanation: "Le cours précise : tentative non incriminée.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Complicité",
    question: "La complicité de discrimination suppose :",
    options: [
      "Aide/assistance, provocation ou instructions données (121-6/121-7)",
      "Uniquement l’accord moral",
      "Uniquement une présence sur place",
    ],
    answer:
        "Aide/assistance, provocation ou instructions données (121-6/121-7)",
    explanation: "Rappel du régime de complicité évoqué dans le cours.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 432-9 — ATTEINTE AU SECRET DES CORRESPONDANCES (APPROFONDISSEMENT)
  // =========================================================
  QuizQuestion(
    category: "Secret des correspondances — Moment de l’atteinte",
    question:
        "L’atteinte au secret des correspondances peut être constituée même si :",
    options: [
      "La correspondance n’a pas encore été lue par son destinataire",
      "La correspondance est déjà lue par son destinataire",
      "La correspondance est détruite par son auteur",
    ],
    answer: "La correspondance n’a pas encore été lue par son destinataire",
    explanation:
        "Le cours précise que les correspondances sont protégées tant qu’elles ne sont pas appréhendées par leur destinataire.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Support",
    question:
        "Pour les correspondances télécoms, l’absence de support matériel implique que :",
    options: [
      "L’atteinte porte sur le flux de communication",
      "L’infraction ne peut jamais être constituée",
      "Seules les correspondances écrites sont protégées",
    ],
    answer: "L’atteinte porte sur le flux de communication",
    explanation:
        "Les correspondances dématérialisées sont protégées pendant leur transmission.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Enquête pénale",
    question:
        "Hors autorisation judiciaire, l’interception d’une correspondance dans le cadre d’une enquête constitue :",
    options: [
      "Une atteinte au secret des correspondances",
      "Un acte d’enquête régulier",
      "Un simple manquement disciplinaire",
    ],
    answer: "Une atteinte au secret des correspondances",
    explanation:
        "Les interceptions ne sont licites que dans les cas prévus par la loi (CPP).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — CPP",
    question:
        "Les interceptions judiciaires de correspondances sont encadrées par :",
    options: [
      "Les articles 100 à 100-8 du Code de procédure pénale",
      "L’article 432-9 du Code pénal",
      "Le Code civil",
    ],
    answer: "Les articles 100 à 100-8 du Code de procédure pénale",
    explanation: "Référence expresse citée dans le cours.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — JLD",
    question:
        "Dans certaines enquêtes, les interceptions peuvent être autorisées par :",
    options: [
      "Le juge des libertés et de la détention",
      "Le maire",
      "Le préfet seul",
    ],
    answer: "Le juge des libertés et de la détention",
    explanation:
        "Le cours vise les autorisations dans le cadre des enquêtes de flagrance/préliminaire.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Utilisation interne",
    question:
        "Se servir du contenu d’une correspondance interceptée à des fins personnelles constitue :",
    options: [
      "Une utilisation réprimée par l’article 432-9",
      "Un fait justificatif",
      "Une simple indiscrétion",
    ],
    answer: "Une utilisation réprimée par l’article 432-9",
    explanation: "L’utilisation est une modalité autonome de l’atteinte.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Qualité de la victime",
    question: "La qualité de la victime est indifférente car :",
    options: [
      "Toute correspondance est protégée, quel que soit son auteur ou destinataire",
      "Seules les correspondances privées sont protégées",
      "Seules les correspondances professionnelles sont protégées",
    ],
    answer:
        "Toute correspondance est protégée, quel que soit son auteur ou destinataire",
    explanation:
        "Le cours précise que le contenu et la qualité des personnes importent peu.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Absence de préjudice",
    question: "L’absence de préjudice pour la victime :",
    options: [
      "N’empêche pas la constitution de l’infraction",
      "Écarte systématiquement l’infraction",
      "Transforme le délit en contravention",
    ],
    answer: "N’empêche pas la constitution de l’infraction",
    explanation: "L’infraction est formelle : le préjudice n’est pas exigé.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 432-7 — DISCRIMINATIONS (APPROFONDISSEMENT)
  // =========================================================
  QuizQuestion(
    category: "Discriminations — Principe d’égalité",
    question:
        "L’infraction de discrimination sanctionne une atteinte au principe :",
    options: [
      "D’égalité devant la loi et le service public",
      "De hiérarchie administrative",
      "De continuité du service public",
    ],
    answer: "D’égalité devant la loi et le service public",
    explanation: "La discrimination porte atteinte au principe d’égalité.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Situation de famille",
    question:
        "Refuser un droit en raison de la situation de famille constitue :",
    options: [
      "Une discrimination pénalement réprimée",
      "Une simple erreur administrative",
      "Un fait justificatif",
    ],
    answer: "Une discrimination pénalement réprimée",
    explanation: "La situation de famille figure parmi les critères prohibés.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Langue",
    question:
        "La capacité à s’exprimer dans une langue autre que le français peut constituer :",
    options: [
      "Un critère prohibé de discrimination",
      "Un critère toujours légitime",
      "Un critère disciplinaire",
    ],
    answer: "Un critère prohibé de discrimination",
    explanation: "Ce critère est expressément visé par les textes.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Discriminations — Lanceur d’alerte",
    question:
        "Le fait de discriminer une personne en raison de sa qualité de lanceur d’alerte est :",
    options: [
      "Pénalement réprimé",
      "Autorisé en cas de trouble",
      "Un simple manquement déontologique",
    ],
    answer: "Pénalement réprimé",
    explanation: "La qualité de lanceur d’alerte est expressément protégée.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Discriminations — Absence de droit",
    question: "Si aucun droit n’est accordé par la loi, il ne peut y avoir :",
    options: [
      "Discrimination pénale au sens de l’article 432-7",
      "Responsabilité pénale",
      "Responsabilité disciplinaire",
    ],
    answer: "Discrimination pénale au sens de l’article 432-7",
    explanation: "L’existence d’un droit légal est une condition essentielle.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Activité économique (preuve)",
    question:
        "Pour caractériser l’entrave à une activité économique, il suffit de démontrer que :",
    options: [
      "L’exercice de l’activité a été rendu plus difficile",
      "L’activité a cessé totalement",
      "Un préjudice financier chiffré existe",
    ],
    answer: "L’exercice de l’activité a été rendu plus difficile",
    explanation: "La cessation ou le préjudice chiffré ne sont pas exigés.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Motivation",
    question: "Une motivation administrative apparemment neutre peut :",
    options: [
      "Dissimuler une discrimination",
      "Écarter toute discrimination",
      "Supprimer l’élément moral",
    ],
    answer: "Dissimuler une discrimination",
    explanation:
        "La volonté discriminatoire peut être déduite des circonstances.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Discriminations — Absence d’intention",
    question: "Si l’auteur n’a pas conscience de discriminer :",
    options: [
      "L’infraction n’est pas constituée",
      "L’infraction est automatique",
      "La peine est aggravée",
    ],
    answer: "L’infraction n’est pas constituée",
    explanation: "L’élément moral exige une conscience discriminatoire.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Personnes morales",
    question:
        "Les personnes morales peuvent être reconnues responsables de discrimination :",
    options: ["Oui", "Non", "Uniquement en matière contraventionnelle"],
    answer: "Oui",
    explanation:
        "Le cours précise que la responsabilité pénale des personnes morales peut être retenue.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Finalité",
    question: "La répression de la discrimination vise principalement à :",
    options: [
      "Garantir l’égalité d’accès aux droits et aux activités",
      "Sanctionner les erreurs administratives",
      "Assurer l’efficacité des services publics",
    ],
    answer: "Garantir l’égalité d’accès aux droits et aux activités",
    explanation:
        "La finalité est la protection de l’égalité et des droits fondamentaux.",
    difficulty: "Facile",
  ),

  // =========================================================
  // 432-9 — ATTEINTE AU SECRET DES CORRESPONDANCES (NIVEAU EXPERT)
  // =========================================================
  QuizQuestion(
    category: "Secret des correspondances — Infraction formelle",
    question: "L’infraction prévue par l’article 432-9 est une infraction :",
    options: [
      "Formelle, ne nécessitant aucun résultat dommageable",
      "Matérielle, nécessitant un préjudice",
      "De résultat uniquement",
    ],
    answer: "Formelle, ne nécessitant aucun résultat dommageable",
    explanation: "Aucun préjudice n’est exigé : l’atteinte suffit.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Lecture partielle",
    question: "Le fait de lire partiellement une correspondance constitue :",
    options: [
      "Une atteinte au secret des correspondances",
      "Un acte non punissable",
      "Une tentative non incriminée",
    ],
    answer: "Une atteinte au secret des correspondances",
    explanation:
        "Toute prise de connaissance non autorisée du contenu est réprimée.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Professionnel / privé",
    question: "Une correspondance professionnelle est protégée :",
    options: [
      "Au même titre qu’une correspondance privée",
      "Uniquement si elle est confidentielle",
      "Uniquement si elle est personnelle",
    ],
    answer: "Au même titre qu’une correspondance privée",
    explanation: "Le contenu professionnel ou privé est indifférent.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Courrier arrivé",
    question:
        "Une correspondance arrivée à destination mais non encore ouverte :",
    options: [
      "Reste protégée pénalement",
      "N’est plus protégée",
      "Relève uniquement du droit civil",
    ],
    answer: "Reste protégée pénalement",
    explanation:
        "La protection cesse uniquement après appréhension par le destinataire.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Consentement du tiers",
    question: "Le consentement d’un tiers non destinataire :",
    options: [
      "N’a aucun effet juridique",
      "Autorise la lecture",
      "Supprime l’élément moral",
    ],
    answer: "N’a aucun effet juridique",
    explanation: "Seul le destinataire peut consentir.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Conservation",
    question:
        "La conservation d’une correspondance interceptée sans en révéler le contenu :",
    options: [
      "Peut constituer une atteinte",
      "N’est jamais punissable",
      "Est toujours justifiée",
    ],
    answer: "Peut constituer une atteinte",
    explanation:
        "Selon les circonstances, elle peut révéler une utilisation illicite.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Suppression",
    question:
        "La suppression d’une correspondance empêchement sa réception constitue :",
    options: [
      "Une atteinte au secret des correspondances",
      "Un simple dysfonctionnement",
      "Une tentative non punissable",
    ],
    answer: "Une atteinte au secret des correspondances",
    explanation: "La suppression est expressément visée par le texte.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances — Autorité hiérarchique",
    question:
        "L’ordre donné par un supérieur hiérarchique n’exonère pas l’exécutant :",
    options: [
      "De sa responsabilité pénale",
      "De toute responsabilité",
      "Uniquement disciplinaire",
    ],
    answer: "De sa responsabilité pénale",
    explanation: "L’ordre illégal n’est pas justificatif.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 432-7 — DISCRIMINATIONS (NIVEAU EXPERT)
  // =========================================================
  QuizQuestion(
    category: "Discriminations — Infraction intentionnelle",
    question:
        "La discrimination prévue par l’article 432-7 est une infraction :",
    options: ["Intentionnelle", "Non intentionnelle", "De négligence"],
    answer: "Intentionnelle",
    explanation: "Elle suppose une volonté discriminatoire consciente.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Neutralité apparente",
    question:
        "Une décision apparemment neutre peut constituer une discrimination si :",
    options: [
      "Elle est fondée sur un critère prohibé",
      "Elle est écrite correctement",
      "Elle est prise collectivement",
    ],
    answer: "Elle est fondée sur un critère prohibé",
    explanation:
        "La forme de la décision n’écarte pas l’intention discriminatoire.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Discriminations — Charge de travail",
    question:
        "Alourdir volontairement la charge administrative d’un professionnel pour un motif discriminatoire constitue :",
    options: [
      "Une entrave à l’exercice d’une activité économique",
      "Un simple contrôle",
      "Un fait justificatif",
    ],
    answer: "Une entrave à l’exercice d’une activité économique",
    explanation: "Rendre l’activité plus difficile suffit.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Dénigrement",
    question:
        "Le dénigrement d’un professionnel auprès de ses partenaires peut caractériser :",
    options: [
      "Une discrimination par entrave économique",
      "Une simple opinion",
      "Un fait non répréhensible",
    ],
    answer: "Une discrimination par entrave économique",
    explanation: "Le cours cite expressément le dénigrement.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Discriminations — Absence de texte",
    question:
        "En l’absence de texte accordant un droit, la qualification de discrimination :",
    options: [
      "N’est pas possible pénalement",
      "Est automatique",
      "Est présumée",
    ],
    answer: "N’est pas possible pénalement",
    explanation: "L’existence d’un droit légal est indispensable.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Discriminations — Critère multiple",
    question: "Une discrimination peut être fondée sur :",
    options: [
      "Un ou plusieurs critères prohibés",
      "Un seul critère",
      "Uniquement l’origine",
    ],
    answer: "Un ou plusieurs critères prohibés",
    explanation: "La pluralité de critères n’exclut pas l’infraction.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Discriminations — Personnes morales",
    question: "La responsabilité pénale d’une personne morale suppose :",
    options: [
      "Une infraction commise pour son compte par un organe ou représentant",
      "Une faute personnelle du dirigeant",
      "Une condamnation préalable d’un salarié",
    ],
    answer:
        "Une infraction commise pour son compte par un organe ou représentant",
    explanation:
        "Application du droit commun de la responsabilité pénale des personnes morales.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Discriminations — But poursuivi",
    question: "Le but poursuivi par l’auteur est :",
    options: [
      "Indifférent dès lors que le critère discriminatoire est établi",
      "Toujours déterminant",
      "Toujours exonératoire",
    ],
    answer: "Indifférent dès lors que le critère discriminatoire est établi",
    explanation: "Le mobile n’efface pas la discrimination.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizAbusAutoriteGPXSchool extends StatefulWidget {
  static const String routeName = '/gpx/nation/quiz/abus_autorite_particuliers';
  final String uid;
  final String email;

  const QuizAbusAutoriteGPXSchool({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizAbusAutoriteGPXSchool> createState() =>
      _QuizAbusAutoriteGPXSchoolState();
}

class _QuizAbusAutoriteGPXSchoolState extends State<QuizAbusAutoriteGPXSchool>
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
        ? questionAbusAutoriteParticuliers
        : questionAbusAutoriteParticuliers
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
            'module_name': 'Crimes & délits contre la nation',
            'quiz_name': 'Abus d\'autorité (particuliers)',
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
      await _sb.from('quiz_abus_autorite_particuliers').insert({
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
      debugPrint('❌ quiz_abus_autorite_particuliers insert failed: $e');
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
