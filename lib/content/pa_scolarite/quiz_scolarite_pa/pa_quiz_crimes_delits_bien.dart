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

final List<QuizQuestion> questionInfractionsVoisinesDuVol = [
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Définition",
    question: "La demande de fonds sous contrainte consiste à :",
    options: [
      "Solliciter sur la voie publique la remise de fonds, en réunion et de manière agressive ou sous la menace d’un animal dangereux",
      "Obtenir des fonds par menaces de violences",
      "Se faire remettre des fonds par manœuvres frauduleuses",
    ],
    answer:
        "Solliciter sur la voie publique la remise de fonds, en réunion et de manière agressive ou sous la menace d’un animal dangereux",
    explanation:
        "312-12-1 CP : comportement de mendicité agressive en réunion ou sous menace d’un animal dangereux.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Définition",
    question:
        "L’infraction prévue à l’article 322-11-1 al.1 du Code pénal vise :",
    options: [
      "La détention ou le transport de substances incendiaires ou explosives en vue de préparer des infractions dangereuses",
      "L’utilisation effective d’un engin explosif",
      "La fabrication industrielle d’explosifs autorisés",
    ],
    answer:
        "La détention ou le transport de substances incendiaires ou explosives en vue de préparer des infractions dangereuses",
    explanation:
        "322-11-1 al.1 CP : détention ou transport de substances/produits incendiaires ou explosifs en vue de la préparation caractérisée de destructions dangereuses (322-6) ou d’atteintes aux personnes.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Élément légal",
    question:
        "Quel article définit et réprime la détention ou le transport de substances incendiaires ou explosives avec préparation caractérisée ?",
    options: [
      "322-11-1 al.1 du Code pénal",
      "322-6 du Code pénal",
      "322-14 du Code pénal",
    ],
    answer: "322-11-1 al.1 du Code pénal",
    explanation:
        "Le texte d’incrimination est expressément l’article 322-11-1 alinéa 1 du Code pénal.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Détention",
    question: "La détention, au sens de 322-11-1, correspond :",
    options: [
      "Au fait d’avoir les substances à sa disposition, sans être nécessairement propriétaire",
      "Uniquement au fait d’en être propriétaire",
      "Uniquement au stockage sur la voie publique",
    ],
    answer:
        "Au fait d’avoir les substances à sa disposition, sans être nécessairement propriétaire",
    explanation:
        "La détention s’entend comme le fait d’avoir les produits à disposition, au domicile ou ailleurs, sans exigence de propriété.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Transport (piège)",
    question:
        "Être trouvé porteur de produits incendiaires sur la voie publique caractérise :",
    options: [
      "À la fois la détention et le transport",
      "Uniquement le transport",
      "Uniquement la détention",
    ],
    answer: "À la fois la détention et le transport",
    explanation:
        "Le cours précise que le fait d’être porteur sur la voie publique caractérise simultanément la détention et le transport.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Nature des produits",
    question: "Sont visés par 322-11-1 al.1 :",
    options: [
      "Explosifs industriels et engins explosifs improvisés",
      "Uniquement les explosifs industriels",
      "Uniquement les substances chimiques interdites",
    ],
    answer: "Explosifs industriels et engins explosifs improvisés",
    explanation:
        "Le texte vise aussi bien les explosifs industriels que les explosifs artisanaux (EEI) et produits incendiaires comme les cocktails Molotov.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Pluralité (ultra-piège)",
    question: "La jurisprudence exige, en principe :",
    options: [
      "La présence d’au moins deux objets, substances ou éléments",
      "Un seul objet suffit toujours",
      "Uniquement un engin déjà assemblé",
    ],
    answer: "La présence d’au moins deux objets, substances ou éléments",
    explanation:
        "L’emploi du pluriel implique que la présence d’un seul objet n’est pas suffisante ; la jurisprudence retient au moins deux éléments.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Préparation caractérisée",
    question: "La préparation caractérisée suppose :",
    options: [
      "Un ou plusieurs faits matériels révélant sans ambiguïté l’intention",
      "Le début d’exécution de l’infraction finale",
      "Une simple intention non matérialisée",
    ],
    answer:
        "Un ou plusieurs faits matériels révélant sans ambiguïté l’intention",
    explanation:
        "L’auteur ne doit pas être passé à l’acte ; la résolution d’agir doit ressortir d’actes préparatoires concrets.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Piège utilisation",
    question:
        "Si les substances sont effectivement utilisées, la qualification retenue sera :",
    options: [
      "322-6 du Code pénal ou une atteinte aux personnes",
      "Toujours 322-11-1",
      "322-14 du Code pénal",
    ],
    answer: "322-6 du Code pénal ou une atteinte aux personnes",
    explanation:
        "322-11-1 vise l’anticipation : en cas d’utilisation ou tentative, on bascule vers 322-6 ou les infractions d’atteintes aux personnes.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Élément moral",
    question: "L’élément moral exige :",
    options: [
      "La conscience de détenir ou transporter ces produits pour commettre une infraction dangereuse",
      "Une simple imprudence",
      "Un résultat dommageable effectif",
    ],
    answer:
        "La conscience de détenir ou transporter ces produits pour commettre une infraction dangereuse",
    explanation:
        "L’intention coupable doit être démontrée, révélée par les actes préparatoires.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Peine",
    question: "Peines encourues pour l’infraction simple de 322-11-1 al.1 :",
    options: [
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "10 ans d’emprisonnement et 150 000 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende",
    explanation:
        "Répression de droit commun prévue par l’article 322-11-1 al.1 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Aggravation",
    question: "La circonstance aggravante spécifique prévue est :",
    options: [
      "La commission en bande organisée",
      "La récidive légale",
      "L’usage d’un réseau électronique",
    ],
    answer: "La commission en bande organisée",
    explanation:
        "Article 322-11-1 al.2 CP : aggravation en cas de bande organisée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.2 — Peine aggravée",
    question: "En cas de bande organisée, la peine encourue est :",
    options: [
      "10 ans d’emprisonnement et 500 000 € d’amende",
      "15 ans de réclusion criminelle",
      "7 ans d’emprisonnement et 150 000 € d’amende",
    ],
    answer: "10 ans d’emprisonnement et 500 000 € d’amende",
    explanation:
        "L’aggravation par bande organisée porte la peine à 10 ans et 500 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Tentative (V/F)",
    question:
        "Vrai/Faux : la tentative de l’infraction prévue à l’article 322-11-1 al.1 est punissable.",
    options: ["Vrai", "Faux", "Seulement en bande organisée"],
    answer: "Faux",
    explanation: "La tentative n’est pas punissable pour cette infraction.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Complicité",
    question: "La complicité est-elle punissable pour 322-11-1 al.1 ?",
    options: ["Oui", "Non", "Seulement pour les personnes morales"],
    answer: "Oui",
    explanation: "La complicité est expressément prévue et punissable.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "322-11-1 al.3 — Définition",
    question: "L’article 322-11-1 al.3 réprime :",
    options: [
      "La détention ou le transport sans motif légitime de produits incendiaires ou explosifs permettant des destructions dangereuses",
      "Toute détention d’explosifs industriels",
      "La fabrication de cocktails Molotov",
    ],
    answer:
        "La détention ou le transport sans motif légitime de produits incendiaires ou explosifs permettant des destructions dangereuses",
    explanation:
        "322-11-1 al.3 CP vise l’absence de motif légitime, indépendamment d’une préparation caractérisée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.3 — Motif légitime (piège)",
    question:
        "Un bidon d’essence transporté pour tondre une pelouse constitue :",
    options: [
      "Un motif légitime",
      "Une infraction automatique",
      "Une préparation caractérisée",
    ],
    answer: "Un motif légitime",
    explanation:
        "Le texte exclut l’infraction lorsque le transport repose sur une raison légitime et de bonne foi.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.3 — Peine",
    question: "La peine encourue pour 322-11-1 1° ou 2° est :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation:
        "Répression prévue pour la détention ou le transport sans motif légitime (alinéa 3).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "322-6 — Définition",
    question: "L’article 322-6 al.1 du Code pénal incrimine :",
    options: [
      "Les destructions, dégradations ou détériorations dangereuses pour les personnes",
      "Toute destruction volontaire",
      "Les destructions involontaires",
    ],
    answer:
        "Les destructions, dégradations ou détériorations dangereuses pour les personnes",
    explanation:
        "322-6 al.1 CP vise les atteintes intentionnelles aux biens créant un danger pour les personnes.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-6 — Moyen dangereux",
    question: "Quels moyens sont expressément visés par l’article 322-6 ?",
    options: [
      "Substance explosive, incendie ou tout moyen créant un danger",
      "Uniquement l’incendie",
      "Uniquement les explosifs industriels",
    ],
    answer: "Substance explosive, incendie ou tout moyen créant un danger",
    explanation:
        "Le texte vise l’explosion, l’incendie ou tout autre moyen de nature à créer un danger pour les personnes.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6 — Élément moral (jurisprudence)",
    question:
        "Selon la Cour de cassation, l’élément intentionnel est caractérisé par :",
    options: [
      "Le seul usage d’un moyen intrinsèquement dangereux",
      "La volonté de blesser une personne déterminée",
      "La recherche d’un profit",
    ],
    answer: "Le seul usage d’un moyen intrinsèquement dangereux",
    explanation:
        "Cass. crim., 24 juin 1998 : l’emploi d’un moyen dangereux suffit à caractériser l’intention.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "322-14 — Définition",
    question: "L’infraction de fausse alerte consiste à :",
    options: [
      "Divulguer sciemment une fausse information provoquant un danger ou l’intervention inutile des secours",
      "Exagérer un risque réel",
      "Se tromper de bonne foi",
    ],
    answer:
        "Divulguer sciemment une fausse information provoquant un danger ou l’intervention inutile des secours",
    explanation:
        "322-14 CP réprime les fausses informations relatives à des destructions dangereuses ou à des sinistres.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-14 — Élément moral",
    question: "L’élément moral des fausses alertes suppose :",
    options: [
      "La connaissance de la fausseté de l’information",
      "Une simple imprudence",
      "Un résultat dommageable effectif",
    ],
    answer: "La connaissance de la fausseté de l’information",
    explanation:
        "L’auteur doit savoir que l’information est fausse et vouloir tromper.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-14 — Peine",
    question: "Les fausses alertes sont punies de :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "6 mois d’emprisonnement et 7 500 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation: "Peine prévue par l’article 322-14 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-6-1 — Définition",
    question: "L’article 322-6-1 al.1 CP réprime :",
    options: [
      "Le fait de diffuser des procédés permettant la fabrication d’engins de destruction (hors cadre professionnel)",
      "Le fait de détenir des explosifs en vue d’un usage domestique",
      "Le fait de menacer de dégrader un bien sans écrit",
    ],
    answer:
        "Le fait de diffuser des procédés permettant la fabrication d’engins de destruction (hors cadre professionnel)",
    explanation:
        "322-6-1 al.1 : diffusion de procédés de fabrication d’engins de destruction, sauf à destination des professionnels.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-6-1 — Moyen de diffusion (piège)",
    question: "Pour 322-6-1, la diffusion doit être :",
    options: [
      "Une transmission vers une ou plusieurs personnes, par tout moyen",
      "Uniquement publique et sur internet",
      "Uniquement par écrit",
    ],
    answer: "Une transmission vers une ou plusieurs personnes, par tout moyen",
    explanation:
        "Tous moyens visés (courriers, tracts, revues, communications électroniques, etc.).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6-1 — Public visé",
    question: "L’infraction 322-6-1 peut être retenue si la diffusion est :",
    options: [
      "À un correspondant déterminé (privé) ou à un public non identifié",
      "Uniquement à un public non déterminé",
      "Uniquement à un professionnel",
    ],
    answer: "À un correspondant déterminé (privé) ou à un public non identifié",
    explanation:
        "Elle vise la diffusion privée ou publique ; exclusion du strict cadre professionnel.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-6-1 — Exclusion (pro)",
    question:
        "La diffusion de procédés dans un cadre strictement professionnel (recherche/sécurité/enquête) :",
    options: [
      "N’entre pas dans le champ de 322-6-1",
      "Est toujours punissable",
      "Devient un crime",
    ],
    answer: "N’entre pas dans le champ de 322-6-1",
    explanation:
        "Le texte exclut les diffusions à destination des professionnels.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6-1 — Élément moral",
    question: "L’élément moral de 322-6-1 suppose notamment :",
    options: [
      "La connaissance du risque et la diffusion consciente d’un procédé dangereux",
      "Une simple négligence",
      "La réalisation effective d’une explosion",
    ],
    answer:
        "La connaissance du risque et la diffusion consciente d’un procédé dangereux",
    explanation:
        "L’auteur n’ignore pas le risque et diffuse sciemment un procédé destiné à fabriquer un engin de destruction.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6-1 — Aggravation",
    question: "La circonstance aggravante de 322-6-1 al.2 vise :",
    options: [
      "L’usage d’un réseau de communication électronique vers un public non déterminé",
      "La bande organisée",
      "La récidive",
    ],
    answer:
        "L’usage d’un réseau de communication électronique vers un public non déterminé",
    explanation:
        "Aggravation si diffusion via réseau électronique à destination d’un public non déterminé.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-6-1 — Peine simple",
    question: "Peine encourue (322-6-1 al.1) :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Répression de base de 322-6-1 al.1.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-6-1 — Peine aggravée",
    question: "Peine encourue (322-6-1 al.2) :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation:
        "Aggravation par réseau électronique vers public non déterminé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6-1 — Tentative (V/F)",
    question: "Vrai/Faux : la tentative de 322-6-1 est punissable.",
    options: ["Vrai", "Faux", "Seulement si internet"],
    answer: "Faux",
    explanation: "Le texte indique : tentative non punissable pour 322-6-1.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-6-1 — Complicité",
    question: "La complicité de diffusion de procédés (322-6-1) est :",
    options: [
      "Punissable",
      "Non punissable",
      "Uniquement pour les personnes physiques",
    ],
    answer: "Punissable",
    explanation: "Complicité : oui.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "322-5 — Définition (involontaire dangereux)",
    question: "L’article 322-5 al.1 CP réprime :",
    options: [
      "Les destructions/dégradations/détériorations involontaires dangereuses par explosion/incendie dues à manquement à une obligation loi/règlement",
      "Toute destruction volontaire par incendie",
      "Les tags effaçables",
    ],
    answer:
        "Les destructions/dégradations/détériorations involontaires dangereuses par explosion/incendie dues à manquement à une obligation loi/règlement",
    explanation:
        "322-5 : involontaire + danger + explosion/incendie + manquement à obligation de prudence/sécurité imposée par loi ou règlement.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-5 — Obligation (piège concours)",
    question: "Pour 322-5 al.1, l’obligation violée doit être :",
    options: [
      "Imposée par une loi ou un règlement (acte général et impersonnel)",
      "Une simple règle morale de prudence",
      "Une consigne orale d’un collègue",
    ],
    answer: "Imposée par une loi ou un règlement (acte général et impersonnel)",
    explanation:
        "Les magistrats doivent préciser la source exacte de l’obligation (Cass. crim., 18 juin 2002).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-5 — Résultat",
    question: "322-5 vise comme résultats :",
    options: [
      "Destruction, dégradation ou détérioration d’un bien appartenant à autrui",
      "Uniquement destruction totale",
      "Uniquement détérioration légère",
    ],
    answer:
        "Destruction, dégradation ou détérioration d’un bien appartenant à autrui",
    explanation:
        "Même triptyque que 322-1/322-6 : destruction / dégradation / détérioration.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-5 — Causalité (piège)",
    question:
        "En cas de causalité indirecte, la responsabilité pénale suppose :",
    options: [
      "Une faute délibérée ou caractérisée",
      "N’importe quelle faute",
      "Aucune faute",
    ],
    answer: "Une faute délibérée ou caractérisée",
    explanation:
        "Distinction causalité directe/indirecte (121-3 al.4 : auteur indirect).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-5 — Élément moral al.1",
    question: "L’élément moral de 322-5 al.1 correspond à :",
    options: [
      "Méconnaître les exigences légales/réglementaires qui auraient dû être respectées",
      "Vouloir absolument détruire le bien",
      "Diffuser une fausse alerte",
    ],
    answer:
        "Méconnaître les exigences légales/réglementaires qui auraient dû être respectées",
    explanation:
        "Il ne s’agit pas de n’importe quelle faute : omission de respecter une obligation précise.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-5 — Élément moral al.2 (aggravé)",
    question: "322-5 al.2 vise :",
    options: [
      "La violation manifestement délibérée d’une obligation particulière en connaissance des risques",
      "La simple maladresse",
      "Le cas où le bien est culturel",
    ],
    answer:
        "La violation manifestement délibérée d’une obligation particulière en connaissance des risques",
    explanation:
        "Forme aggravée : l’auteur connaît les risques et choisit de ne pas respecter l’obligation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-5 — Peine al.1",
    question: "Peine encourue (322-5 al.1) :",
    options: [
      "1 an d’emprisonnement et 15 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "10 ans d’emprisonnement et 150 000 € d’amende",
    ],
    answer: "1 an d’emprisonnement et 15 000 € d’amende",
    explanation:
        "Répression de base pour destruction involontaire dangereuse (al.1).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-5 — Peine al.2",
    question: "Peine encourue (322-5 al.2) :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "1 an d’emprisonnement et 15 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation: "Aggravation par violation manifestement délibérée (al.2).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-5 — Tentative/Complicité (V/F)",
    question:
        "Vrai/Faux : pour 322-5, tentative et complicité sont punissables.",
    options: ["Vrai", "Faux", "Tentative oui, complicité non"],
    answer: "Faux",
    explanation: "322-5 : tentative non ; complicité non (selon le cours).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "322-1 I — Définition (dommage important)",
    question: "L’article 322-1 I CP réprime :",
    options: [
      "Les destructions/dégradations/détériorations volontaires sans danger pour les personnes, avec dommage important",
      "Les destructions par incendie",
      "Les fausses alertes",
    ],
    answer:
        "Les destructions/dégradations/détériorations volontaires sans danger pour les personnes, avec dommage important",
    explanation:
        "322-1 I : pas de danger pour les personnes + dommage important + bien d’autrui.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-1 I — Moyen (piège)",
    question: "Pour 322-1 I, les moyens :",
    options: [
      "Peuvent être quelconques, sauf incendie/substances explosives (qui renvoient à 322-6)",
      "Doivent être un incendie",
      "Doivent être une explosion",
    ],
    answer:
        "Peuvent être quelconques, sauf incendie/substances explosives (qui renvoient à 322-6)",
    explanation:
        "Les moyens ne sont pas précisés ; mais l’incendie/explosion relèvent des textes dangereux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-1 I — Élément moral",
    question: "L’intention requise par 322-1 I est :",
    options: [
      "L’intention simple : agir sciemment et volontairement sans droit",
      "Un dol spécial de vengeance",
      "La recherche d’un profit",
    ],
    answer: "L’intention simple : agir sciemment et volontairement sans droit",
    explanation:
        "Cass. crim., 18 sept. 1991 : savoir ne pas être propriétaire et n’avoir aucun droit de disposition.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-1 I — Peine simple",
    question: "Peine encourue (322-1 I) :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "6 mois d’emprisonnement et 7 500 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation:
        "Répression du dommage important sans danger pour les personnes.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-2 — Circonstance (registre public)",
    question:
        "L’article 322-2 aggrave lorsque le bien détruit/dégradé/détérioré est :",
    options: [
      "Un registre, une minute ou un acte original de l’autorité publique",
      "Un bien culturel exposé dans un musée",
      "Un véhicule privé",
    ],
    answer:
        "Un registre, une minute ou un acte original de l’autorité publique",
    explanation:
        "322-2 : protection des registres d’état civil, minutes notariales, originaux d’actes/constats/PV.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-2 — Peine",
    question: "Peine encourue avec 322-2 :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Aggravation spécifique 322-2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-3 — Aggravations (piège)",
    question: "L’article 322-3 prévoit notamment une aggravation lorsque :",
    options: [
      "Les faits sont commis par plusieurs personnes agissant comme auteurs/complices",
      "Le dommage est léger",
      "La victime est inconnue",
    ],
    answer:
        "Les faits sont commis par plusieurs personnes agissant comme auteurs/complices",
    explanation:
        "322-3 liste plusieurs circonstances (pluralité, vulnérabilité, contre personnes dépositaires, etc.).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-3 — Peine (deux circonstances)",
    question: "Peine encourue lorsque 322-3 est retenu (selon tableau) :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation:
        "Le tableau du cours mentionne 5 ans / 75 000 € pour l’aggravation (322-3).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-1 I — Tentative/Complicité",
    question: "Pour 322-1 I, la tentative et la complicité sont :",
    options: [
      "Tentative oui (322-4) / Complicité oui",
      "Tentative non / Complicité non",
      "Tentative oui / Complicité non",
    ],
    answer: "Tentative oui (322-4) / Complicité oui",
    explanation:
        "322-4 prévoit la tentative punissable pour ces délits ; complicité punissable.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "R.635-1 — Définition (dommage léger)",
    question: "R.635-1 CP vise :",
    options: [
      "Les destructions/dégradations/détériorations volontaires avec dommage léger (sans danger pour les personnes)",
      "Les tags uniquement",
      "Les destructions dangereuses par incendie",
    ],
    answer:
        "Les destructions/dégradations/détériorations volontaires avec dommage léger (sans danger pour les personnes)",
    explanation: "Contravention 5e classe si dommage léger.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "R.635-1 — Intention (piège contravention)",
    question: "Particularité de R.635-1 :",
    options: [
      "Elle exige l’intention (volontaire), contrairement au principe des contraventions matérielles",
      "Elle ne requiert jamais d’intention",
      "Elle exige une bande organisée",
    ],
    answer:
        "Elle exige l’intention (volontaire), contrairement au principe des contraventions matérielles",
    explanation:
        "Le texte requiert l’intention coupable : dommage « volontaire ».",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "R.635-1 — Peine",
    question: "Peine encourue (R.635-1) :",
    options: ["1 500 € d’amende", "3 750 € d’amende", "7 500 € d’amende"],
    answer: "1 500 € d’amende",
    explanation: "Contravention de 5e classe : 1 500 €.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "322-1 II — Tags (définition)",
    question: "L’article 322-1 II CP réprime :",
    options: [
      "Le traçage d’inscriptions/signes/dessins sans autorisation, avec dommage léger",
      "Toute dégradation importante",
      "Les menaces de destruction",
    ],
    answer:
        "Le traçage d’inscriptions/signes/dessins sans autorisation, avec dommage léger",
    explanation:
        "Spécial « tags » : dommage léger et effaçable sans altérer le support.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-1 II — Biens visés (piège)",
    question: "Pour 322-1 II, les biens expressément visés sont :",
    options: [
      "Façades, véhicules, voies publiques, mobilier urbain",
      "Uniquement les bâtiments publics",
      "Uniquement les véhicules",
    ],
    answer: "Façades, véhicules, voies publiques, mobilier urbain",
    explanation: "Liste fermée donnée par le cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-1 II — Dommage (piège)",
    question: "Si l’inscription est indélébile et altère le support :",
    options: [
      "On bascule vers 322-1 I (dommage important)",
      "On reste en 322-1 II",
      "C’est une contravention R.631-1",
    ],
    answer: "On bascule vers 322-1 I (dommage important)",
    explanation: "322-1 II suppose dommage léger (effaçable facilement).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-1 II — Répression (base)",
    question: "Peine de base pour 322-1 II :",
    options: [
      "3 750 € d’amende + TIG possible",
      "2 ans d’emprisonnement + 30 000 €",
      "6 mois d’emprisonnement + 7 500 €",
    ],
    answer: "3 750 € d’amende + TIG possible",
    explanation:
        "Le cours mentionne l’amende et la TIG ; pas d’emprisonnement.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-1 II — Conséquence procédure (piège concours)",
    question: "Attention : 322-1 II, non puni d’emprisonnement, implique :",
    options: [
      "Pas de GAV ni de flagrance sur ce seul fondement",
      "GAV possible systématiquement",
      "Crime automatique en récidive",
    ],
    answer: "Pas de GAV ni de flagrance sur ce seul fondement",
    explanation:
        "Le cours alerte : pas de peine d’emprisonnement → pas de cadre flagrance/GAV uniquement pour ce délit.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "322-3-1 — Définition (biens culturels)",
    question: "L’article 322-3-1 CP protège :",
    options: [
      "Les biens culturels publics ou classés (immeubles/objets inscrits, archéologie, musées, édifices affectés au culte…)",
      "Uniquement les biens appartenant à l’État",
      "Uniquement les monuments naturels",
    ],
    answer:
        "Les biens culturels publics ou classés (immeubles/objets inscrits, archéologie, musées, édifices affectés au culte…)",
    explanation:
        "322-3-1 liste plusieurs catégories (patrimoine, archives classées, musées, culte…).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-3-1 — Particularité (piège)",
    question: "Pour 322-3-1, l’infraction est constituée même si :",
    options: [
      "L’auteur est propriétaire du bien",
      "Le dommage est important",
      "Le bien appartient à autrui",
    ],
    answer: "L’auteur est propriétaire du bien",
    explanation:
        "Spécificité : le texte vise la protection patrimoniale ; propriété de l’auteur n’exclut pas l’infraction.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-3-1 — Peine",
    question: "Peine encourue (322-3-1) :",
    options: [
      "7 ans d’emprisonnement et 100 000 € d’amende (ou 1/2 valeur du bien)",
      "5 ans d’emprisonnement et 75 000 €",
      "2 ans d’emprisonnement et 30 000 €",
    ],
    answer:
        "7 ans d’emprisonnement et 100 000 € d’amende (ou 1/2 valeur du bien)",
    explanation: "Répression renforcée pour biens culturels.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-3-1 — Aggravation",
    question: "322-3-1 est aggravé notamment lorsque :",
    options: [
      "Les faits sont commis par plusieurs personnes agissant comme auteurs/complices",
      "Le dommage est léger",
      "Le bien est un véhicule privé",
    ],
    answer:
        "Les faits sont commis par plusieurs personnes agissant comme auteurs/complices",
    explanation: "Renvoi à la circonstance de pluralité (322-3 1°).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-3-1 — Peine aggravée",
    question: "Peine aggravée (322-3-1 al.6) :",
    options: [
      "10 ans d’emprisonnement et 150 000 € (ou 1/2 valeur du bien)",
      "15 ans de réclusion",
      "3 ans d’emprisonnement et 45 000 €",
    ],
    answer: "10 ans d’emprisonnement et 150 000 € (ou 1/2 valeur du bien)",
    explanation: "Aggravation prévue par le cours (alinéa 6).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "322-12 — Menaces sans condition (définition)",
    question: "L’article 322-12 CP réprime :",
    options: [
      "La menace de destruction/dégradation/détérioration dangereuse pour les personnes, réitérée (si verbale) ou matérialisée (écrit/image/objet)",
      "Toute menace, même légère, unique et verbale",
      "Uniquement les menaces avec condition",
    ],
    answer:
        "La menace de destruction/dégradation/détérioration dangereuse pour les personnes, réitérée (si verbale) ou matérialisée (écrit/image/objet)",
    explanation:
        "Sans condition : verbale → doit être réitérée ; sinon, une seule suffit si support matériel.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-12 — Peine",
    question: "Peine encourue (322-12) :",
    options: [
      "6 mois d’emprisonnement et 7 500 € d’amende",
      "1 an d’emprisonnement et 15 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "6 mois d’emprisonnement et 7 500 € d’amende",
    explanation: "Répression des menaces sans condition.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-13 — Menaces avec condition (définition)",
    question: "L’article 322-13 al.1 CP vise :",
    options: [
      "La menace de commettre une atteinte aux biens avec l’ordre de remplir une condition",
      "Une menace unique verbale sans condition",
      "Une fausse alerte",
    ],
    answer:
        "La menace de commettre une atteinte aux biens avec l’ordre de remplir une condition",
    explanation:
        "La condition = injonction (faire/ne pas faire) qui contraint la victime.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-13 — Peine base",
    question: "Peine encourue (322-13 al.1) :",
    options: [
      "1 an d’emprisonnement et 15 000 € d’amende",
      "6 mois d’emprisonnement et 7 500 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "1 an d’emprisonnement et 15 000 € d’amende",
    explanation: "Menaces avec condition : 1 an / 15 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-13 — Aggravation",
    question: "L’article 322-13 al.2 aggrave lorsque :",
    options: [
      "La menace vise une destruction/dégradation/détérioration dangereuse pour les personnes",
      "La menace est écrite",
      "La menace est commise en bande organisée",
    ],
    answer:
        "La menace vise une destruction/dégradation/détérioration dangereuse pour les personnes",
    explanation: "Aggravation spécifique prévue par l’alinéa 2.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-13 — Peine aggravée",
    question: "Peine encourue (322-13 al.2) :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "6 mois d’emprisonnement et 7 500 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Menace avec condition + danger personnes : 3 ans / 45 000 €.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "322-14 — Distinction (piège concours)",
    question: "322-14 al.1 vise une fausse info portant sur :",
    options: [
      "Une destruction/dégradation/détérioration dangereuse pour les personnes (passée ou à venir)",
      "Un sinistre non pénal (accident/feu accidentel) visant l’intervention des secours",
      "Une menace avec condition",
    ],
    answer:
        "Une destruction/dégradation/détérioration dangereuse pour les personnes (passée ou à venir)",
    explanation:
        "Al.1 : fait croire à une infraction dangereuse ; al.2 : fait croire à un sinistre provoquant secours inutiles.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-14 — Distinction (sinistre)",
    question: "322-14 al.2 vise plutôt :",
    options: [
      "La fausse information faisant croire à un sinistre et provoquant l’intervention inutile des secours",
      "La diffusion de procédés de fabrication",
      "La détention d’essence interdite par arrêté",
    ],
    answer:
        "La fausse information faisant croire à un sinistre et provoquant l’intervention inutile des secours",
    explanation:
        "Al.2 : sinistre (accident, feu accidentel, etc.) et intervention inutile.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "322-6 — Résultats (QCM piège)",
    question: "Dans 322-6, le résultat exigé est :",
    options: [
      "Une atteinte au bien (destruction/dégradation/détérioration) + mise en danger de l’intégrité physique",
      "Une blessure effective obligatoire",
      "Uniquement un incendie total",
    ],
    answer:
        "Une atteinte au bien (destruction/dégradation/détérioration) + mise en danger de l’intégrité physique",
    explanation:
        "Il suffit d’un danger pour les personnes, pas nécessairement de blessure effective.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-6 — Bien d’autrui",
    question: "Pour 322-6, le bien doit :",
    options: [
      "Appartenir à autrui",
      "Appartenir nécessairement à l’État",
      "Être uniquement un immeuble",
    ],
    answer: "Appartenir à autrui",
    explanation:
        "Le texte vise un bien appartenant à autrui (meuble/immeuble).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "322-1 I vs R.635-1 (ultra-piège)",
    question: "La différence principale entre 322-1 I et R.635-1 est :",
    options: [
      "L’importance du dommage (important = délit / léger = contravention)",
      "Le type de bien (immeuble vs meuble)",
      "L’intention (présente seulement en délit)",
    ],
    answer:
        "L’importance du dommage (important = délit / léger = contravention)",
    explanation:
        "Éléments constitutifs proches ; la gravité du dommage fait basculer vers la contravention.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-1 II vs R.635-1 (piège)",
    question:
        "Un graffiti effaçable sans altérer le support, sans autorisation, relève prioritairement :",
    options: ["De 322-1 II (tags)", "De R.635-1", "De 322-6"],
    answer: "De 322-1 II (tags)",
    explanation:
        "322-1 II est une incrimination spéciale pour inscriptions/signes/dessins (dommage léger).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Révisions rapides — Articles (V/F)",
    question:
        "Vrai/Faux : 322-12 concerne les menaces d’atteintes aux biens sans condition.",
    options: ["Vrai", "Faux", "Ça dépend si c’est écrit"],
    answer: "Vrai",
    explanation:
        "322-12 = sans condition ; modalités : réitération si verbal / écrit-image-objet si unique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Articles (V/F)",
    question:
        "Vrai/Faux : 322-13 concerne les menaces d’atteintes aux biens avec condition.",
    options: ["Vrai", "Faux", "Uniquement si incendie"],
    answer: "Vrai",
    explanation: "322-13 = menaces avec ordre de remplir une condition.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Articles (V/F)",
    question: "Vrai/Faux : 322-14 réprime les fausses alertes.",
    options: ["Vrai", "Faux", "Uniquement internet"],
    answer: "Vrai",
    explanation:
        "322-14 = communication/divulgation d’une fausse information (destruction dangereuse ou sinistre).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peines (piège)",
    question: "Associe la bonne peine : 322-12 =",
    options: ["6 mois + 7 500 €", "1 an + 15 000 €", "2 ans + 30 000 €"],
    answer: "6 mois + 7 500 €",
    explanation: "322-12 : 6 mois d’emprisonnement + 7 500 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peines (piège)",
    question: "Associe la bonne peine : 322-13 al.1 =",
    options: ["1 an + 15 000 €", "6 mois + 7 500 €", "3 ans + 45 000 €"],
    answer: "1 an + 15 000 €",
    explanation: "Menaces avec condition (base).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peines (piège)",
    question: "Associe la bonne peine : 322-14 =",
    options: ["2 ans + 30 000 €", "3 ans + 45 000 €", "3 ans + 45 000 € + TIG"],
    answer: "2 ans + 30 000 €",
    explanation: "Fausse alerte : 2 ans / 30 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Définition",
    question: "322-11-1 al.1 CP réprime :",
    options: [
      "La détention ou le transport de substances/produits incendiaires ou explosifs en vue de préparer (faits matériels) des infractions 322-6 ou des atteintes aux personnes",
      "Le fait de détenir un seul briquet sur la voie publique",
      "La menace de taguer une façade",
    ],
    answer:
        "La détention ou le transport de substances/produits incendiaires ou explosifs en vue de préparer (faits matériels) des infractions 322-6 ou des atteintes aux personnes",
    explanation:
        "Infraction préventive : possession + préparation caractérisée (faits matériels) + finalité (322-6 ou atteintes aux personnes).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Finalité (piège concours)",
    question: "La finalité de 322-11-1 al.1 est :",
    options: [
      "Préparer 322-6 OU des atteintes aux personnes (Titre II Livre II)",
      "Préparer seulement 322-1 (dommage important)",
      "Préparer uniquement des contraventions",
    ],
    answer: "Préparer 322-6 OU des atteintes aux personnes (Titre II Livre II)",
    explanation:
        "Le texte vise 322-6 + atteintes aux personnes (atteintes à la vie, violences...).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Détention vs transport",
    question: "La détention (322-11-1) se définit comme :",
    options: [
      "Avoir à sa disposition les substances/produits, sans être forcément propriétaire",
      "Avoir acheté légalement un produit ménager",
      "Avoir vu un produit chez un tiers sans pouvoir y accéder",
    ],
    answer:
        "Avoir à sa disposition les substances/produits, sans être forcément propriétaire",
    explanation:
        "Notion large : disponibilité matérielle (domicile, parties communes, chez autrui...).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Souplesse (piège)",
    question:
        "Être trouvé porteur de produits sur la voie publique peut caractériser :",
    options: [
      "À la fois la détention et le transport",
      "Uniquement le transport",
      "Uniquement la détention",
    ],
    answer: "À la fois la détention et le transport",
    explanation:
        "Le cours insiste sur la souplesse : porteur sur voie publique = détention + transport.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Pluralité (ultra-piège)",
    question:
        "Selon le cours/jurisprudence, 322-11-1 al.1 vise des objets/substances au pluriel :",
    options: [
      "La présence d’un seul objet est en principe insuffisante (il faut au moins deux éléments)",
      "Un seul objet suffit toujours",
      "La pluralité n’a aucune importance",
    ],
    answer:
        "La présence d’un seul objet est en principe insuffisante (il faut au moins deux éléments)",
    explanation:
        "Le texte emploie le pluriel ; la jurisprudence retient l’exigence d’au moins deux éléments/objets.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Préparation caractérisée",
    question:
        "La “préparation caractérisée” exigée par 322-11-1 al.1 implique :",
    options: [
      "Un ou plusieurs faits matériels révélant sans ambiguïté l’intention",
      "Une simple pensée ou un projet évoqué",
      "Une destruction déjà consommée",
    ],
    answer:
        "Un ou plusieurs faits matériels révélant sans ambiguïté l’intention",
    explanation:
        "Le texte est en amont : il faut des actes préparatoires concrets, sans passage à l’acte.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Absence d’utilisation (piège)",
    question: "Si les substances sont utilisées ou tentées d’être utilisées :",
    options: [
      "On poursuit plutôt sur 322-6 (ou atteintes aux personnes), pas sur 322-11-1 al.1",
      "On cumule automatiquement 322-11-1 al.1 et 322-6",
      "On requalifie en simple contravention",
    ],
    answer:
        "On poursuit plutôt sur 322-6 (ou atteintes aux personnes), pas sur 322-11-1 al.1",
    explanation:
        "322-11-1 al.1 = avant utilisation. Utilisation/tentative = bascule vers 322-6 ou infractions contre les personnes.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Élément moral",
    question: "L’élément moral de 322-11-1 al.1 nécessite :",
    options: [
      "La conscience de détenir/transporter dans le but de commettre une infraction dangereuse pour les personnes",
      "Une simple imprudence",
      "Un mobile politique obligatoire",
    ],
    answer:
        "La conscience de détenir/transporter dans le but de commettre une infraction dangereuse pour les personnes",
    explanation: "Intention démontrée par les actes préparatoires.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Répression",
    question: "Peine encourue (322-11-1 al.1) :",
    options: [
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende",
    explanation:
        "Détention/transport en vue de préparation (al.1) : 7 ans / 100 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.2 — Bande organisée",
    question: "La circonstance aggravante de 322-11-1 al.2 est :",
    options: ["Bande organisée", "Récidive légale", "Pluralité de victimes"],
    answer: "Bande organisée",
    explanation: "Le texte prévoit l’aggravation en bande organisée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.2 — Peine aggravée",
    question: "Peine encourue (322-11-1 al.2) :",
    options: [
      "10 ans d’emprisonnement et 500 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "5 ans d’emprisonnement et 150 000 € d’amende",
    ],
    answer: "10 ans d’emprisonnement et 500 000 € d’amende",
    explanation: "Aggravation bande organisée : 10 ans / 500 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 (al.1/2) — Tentative (V/F)",
    question: "Vrai/Faux : la tentative de 322-11-1 est punissable.",
    options: ["Vrai", "Faux", "Seulement en bande organisée"],
    answer: "Faux",
    explanation: "Le cours indique : tentative non.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 — Complicité",
    question: "Complicité pour 322-11-1 :",
    options: ["Oui", "Non", "Uniquement si mineur"],
    answer: "Oui",
    explanation:
        "Complicité punissable (aide/assistance, provocation, instructions...).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "322-11-1 al.3 — Définition (sans motif légitime)",
    question: "322-11-1 al.3 vise la détention/transport sans motif légitime :",
    options: [
      "De certains produits explosifs non soumis à régime particulier OU de produits incendiaires/éléments interdits par arrêté préfectoral",
      "De tout objet inflammable sans exception",
      "Uniquement en bande organisée",
    ],
    answer:
        "De certains produits explosifs non soumis à régime particulier OU de produits incendiaires/éléments interdits par arrêté préfectoral",
    explanation:
        "Deux branches : 1° explosifs “hors régime” ; 2° incendiaires/éléments si interdits par arrêté préfectoral + absence de motif légitime.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.3 — 1° (explosifs)",
    question: "Pour 322-11-1 al.3 1°, il faut :",
    options: [
      "Détenir/transporter des produits explosifs non soumis à régime particulier, sans motif légitime",
      "Détenir des explosifs industriels sous autorisation",
      "Avoir commis une destruction",
    ],
    answer:
        "Détenir/transporter des produits explosifs non soumis à régime particulier, sans motif légitime",
    explanation:
        "Le texte vise les explosifs (notamment artisanaux) non soumis à un régime particulier.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.3 — 2° (arrêté préfectoral)",
    question:
        "Pour 322-11-1 al.3 2°, en plus de l’absence de motif légitime, il faut :",
    options: [
      "La violation d’un arrêté préfectoral interdisant détention/transport (urgence/risque trouble OP)",
      "La preuve d’un passage à l’acte",
      "Une bande organisée",
    ],
    answer:
        "La violation d’un arrêté préfectoral interdisant détention/transport (urgence/risque trouble OP)",
    explanation:
        "Condition cumulative : pas de motif légitime + arrêté préfectoral d’interdiction.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.3 — Motif légitime (piège)",
    question: "Le “motif légitime” :",
    options: [
      "S’apprécie au cas par cas, selon le contexte",
      "Est toujours présumé absent",
      "Disparaît dès qu’il y a un contrôle de police",
    ],
    answer: "S’apprécie au cas par cas, selon le contexte",
    explanation:
        "Notion souple : contexte violences urbaines/manifs vs usage domestique normal.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.3 — Élément moral (1°)",
    question: "Pour 322-11-1 al.3 1°, l’élément moral correspond à :",
    options: [
      "La conscience de détenir/transporter des explosifs sans motif légitime",
      "La volonté de détruire un bien culturel",
      "La diffusion d’une fausse information",
    ],
    answer:
        "La conscience de détenir/transporter des explosifs sans motif légitime",
    explanation: "Branche 1° : connaissance + absence de motif légitime.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.3 — Élément moral (2°)",
    question: "Pour 322-11-1 al.3 2°, l’élément moral implique :",
    options: [
      "Absence de motif légitime + non-respect de l’arrêté préfectoral",
      "Un dol spécial d’extorsion",
      "Une simple maladresse",
    ],
    answer: "Absence de motif légitime + non-respect de l’arrêté préfectoral",
    explanation: "Branche 2° : cumul absence motif + violation arrêté.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.3 — Peine",
    question: "Peine encourue (322-11-1 al.3 1° et 2°) :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Le cours indique : 3 ans / 45 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.3 — Tentative (V/F)",
    question: "Vrai/Faux : la tentative de 322-11-1 al.3 est punissable.",
    options: ["Vrai", "Faux", "Oui si arrêté préfectoral"],
    answer: "Faux",
    explanation: "Tentative : non (cours).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "322-6 — Moyens (QCM ultra-piège)",
    question: "322-6 al.1 vise une atteinte au bien par :",
    options: [
      "Substance explosive, incendie, ou tout autre moyen de nature à créer un danger pour les personnes",
      "Uniquement incendie",
      "Uniquement un moyen non dangereux",
    ],
    answer:
        "Substance explosive, incendie, ou tout autre moyen de nature à créer un danger pour les personnes",
    explanation:
        "La formule “tout autre moyen” est large dès lors que la sécurité des personnes est gravement mise en danger.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-6 — Danger (piège)",
    question: "Pour 322-6, il faut :",
    options: [
      "Un danger pour les personnes (mise en danger), pas forcément un dommage corporel",
      "Une ITT obligatoire",
      "Un décès obligatoire",
    ],
    answer:
        "Un danger pour les personnes (mise en danger), pas forcément un dommage corporel",
    explanation:
        "L’atteinte au bien doit être de nature à créer un danger pour les personnes.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6 — Élément moral (jurisprudence)",
    question:
        "Selon la Cour de cassation, l’usage d’une substance explosive ou l’incendie :",
    options: [
      "Caractérise suffisamment l’intention en raison du danger grave inhérent",
      "Exclut l’intention car “accident possible”",
      "N’est jamais intentionnel",
    ],
    answer:
        "Caractérise suffisamment l’intention en raison du danger grave inhérent",
    explanation:
        "Cass. crim., 24 juin 1998 : danger grave inhérent à ces moyens d’action.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-6 — Tentative",
    question: "La tentative du délit de 322-6 est :",
    options: [
      "Punissable",
      "Non punissable",
      "Punissable seulement si ITT > 8 jours",
    ],
    answer: "Punissable",
    explanation:
        "Le cours indique : 322-11 prévoit la tentative punissable pour 322-6.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6 — Complicité",
    question: "La complicité pour 322-6 est :",
    options: [
      "Punissable",
      "Non punissable",
      "Punissable uniquement en récidive",
    ],
    answer: "Punissable",
    explanation: "Complicité : oui (infraction consommée ou tentée).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "322-14 — Élément matériel (piège)",
    question: "L’élément matériel de 322-14 nécessite :",
    options: [
      "Communiquer OU divulguer une fausse information",
      "Exiger le paiement d’une rançon",
      "Détruire effectivement un bien",
    ],
    answer: "Communiquer OU divulguer une fausse information",
    explanation: "Le moyen est indifférent (écrit/oral/téléphone/radio...).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-14 — Al.1 vs Al.2 (QCM piège)",
    question: "La différence principale entre 322-14 al.1 et al.2 est :",
    options: [
      "Al.1 = croire à une infraction dangereuse ; Al.2 = croire à un sinistre et provoquer l’intervention inutile des secours",
      "Al.1 = menace ; Al.2 = tentative",
      "Al.1 = tag ; Al.2 = dommage léger",
    ],
    answer:
        "Al.1 = croire à une infraction dangereuse ; Al.2 = croire à un sinistre et provoquer l’intervention inutile des secours",
    explanation:
        "Al.1 cible les atteintes dangereuses aux biens ; al.2 cible le sinistre (accident, feu accidentel...) et la mobilisation inutile.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-14 — Élément moral",
    question: "L’élément moral de 322-14 implique :",
    options: [
      "Connaissance de la fausseté + volonté de faire croire à l’info",
      "Simple rumeur transmise sans y croire",
      "Négligence",
    ],
    answer: "Connaissance de la fausseté + volonté de faire croire à l’info",
    explanation: "Intention coupable requise ; mobile indifférent.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-14 — Tentative (V/F)",
    question:
        "Vrai/Faux : la tentative de fausse alerte (322-14) est punissable.",
    options: ["Vrai", "Faux", "Seulement al.1"],
    answer: "Faux",
    explanation: "Tentative : non (cours).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-14 — Complicité",
    question: "La complicité de 322-14 est :",
    options: ["Oui", "Non", "Oui seulement si l’auteur est mineur"],
    answer: "Oui",
    explanation: "Complicité punissable.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "322-12 — Condition de forme (ultra-piège)",
    question: "Pour 322-12, une menace verbale unique suffit si :",
    options: [
      "Jamais : une menace verbale doit être réitérée",
      "Toujours : une seule menace verbale suffit",
      "Seulement si la victime est dépositaire de l’autorité publique",
    ],
    answer: "Jamais : une menace verbale doit être réitérée",
    explanation:
        "Sans condition : verbale → réitération ; sinon matérialisation (écrit/image/objet).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-12 — Support matériel",
    question: "Pour 322-12, une menace peut être unique si elle est :",
    options: [
      "Matérialisée par un écrit, une image ou tout autre objet",
      "Forcément réitérée",
      "Rédigée par un professionnel",
    ],
    answer: "Matérialisée par un écrit, une image ou tout autre objet",
    explanation:
        "Le support matérialise la menace : pas besoin de réitération.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-13 — Condition (QCM piège)",
    question: "Dans 322-13, la “condition” peut être :",
    options: [
      "Une obligation de faire ou de ne pas faire (action ou abstention)",
      "Uniquement payer de l’argent",
      "Uniquement un délai",
    ],
    answer: "Une obligation de faire ou de ne pas faire (action ou abstention)",
    explanation:
        "Condition = injonction qui contraint la liberté d’agir de la victime.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "322-3 — Circonstances (ciblage DAP/MSP)",
    question:
        "Une circonstance aggravante de 322-3 est constituée si les faits sont commis :",
    options: [
      "Au préjudice d’un dépositaire de l’autorité publique/mission de service public, en vue d’influencer son comportement",
      "Sur un bien appartenant à l’auteur",
      "Sans dommage",
    ],
    answer:
        "Au préjudice d’un dépositaire de l’autorité publique/mission de service public, en vue d’influencer son comportement",
    explanation:
        "Le texte vise notamment magistrat, gendarme, police, douanes, AP, etc.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-3 — Domicile (piège)",
    question: "322-3 peut aggraver si l’infraction est commise :",
    options: [
      "Dans un local d’habitation/entrepôt en pénétrant par ruse, effraction ou escalade",
      "Uniquement sur voie publique",
      "Uniquement sur un bien culturel",
    ],
    answer:
        "Dans un local d’habitation/entrepôt en pénétrant par ruse, effraction ou escalade",
    explanation:
        "Circonstance listée : pénétration par ruse/effraction/escalade.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-3 — Visage dissimulé",
    question:
        "Dissimuler volontairement son visage afin de ne pas être identifié :",
    options: [
      "Constitue une circonstance aggravante (322-3)",
      "Écarte l’infraction (anonymat)",
      "Transforme le délit en contravention",
    ],
    answer: "Constitue une circonstance aggravante (322-3)",
    explanation: "Circonstance aggravante prévue par 322-3 (cours).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "322-1 II — Amende forfaitaire délictuelle (piège)",
    question: "Le texte “tags” (322-1 II) permet :",
    options: [
      "Le recours à l’amende forfaitaire délictuelle (même en récidive)",
      "Uniquement une composition pénale",
      "Uniquement un rappel à la loi",
    ],
    answer: "Le recours à l’amende forfaitaire délictuelle (même en récidive)",
    explanation:
        "Le cours mentionne explicitement la procédure d’AFD pour 322-1 II.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-1 II — Aggravation (322-2)",
    question:
        "Pour les “tags”, si le support est un registre/acte original de l’autorité publique :",
    options: [
      "On peut retenir l’aggravation via 322-2",
      "On reste forcément en R.635-1",
      "On bascule automatiquement en 322-6",
    ],
    answer: "On peut retenir l’aggravation via 322-2",
    explanation:
        "Le cours présente 322-2 et 322-3 comme applicables aux “tags” via aggravations.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Révisions rapides — Associe l’article (QCM)",
    question:
        "“Fausse information visant à faire intervenir inutilement les secours” =",
    options: ["322-14 al.2", "322-12", "322-6-1"],
    answer: "322-14 al.2",
    explanation: "Al.2 : sinistre + intervention inutile des secours.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Associe l’article (QCM)",
    question: "“Menace avec ordre de remplir une condition” =",
    options: ["322-13", "322-12", "R.635-1"],
    answer: "322-13",
    explanation: "Menaces avec condition.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Associe l’article (QCM)",
    question:
        "“Destruction involontaire dangereuse par incendie/explosion + obligation loi/règlement violée” =",
    options: ["322-5", "322-6", "322-1 I"],
    answer: "322-5",
    explanation:
        "Involontaire + danger + manquement obligation de prudence/sécurité.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Associe l’article (QCM)",
    question:
        "“Détention/transport en vue de préparer 322-6 ou atteintes aux personnes (faits matériels)” =",
    options: ["322-11-1 al.1", "322-6-1", "322-3-1"],
    answer: "322-11-1 al.1",
    explanation:
        "Infraction de prévention des violences urbaines/incendies/explosifs.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6-1 — Définition",
    question: "L’infraction de 322-6-1 al.1 CP réprime :",
    options: [
      "La diffusion (sauf à destination des professionnels) de procédés permettant la fabrication d’engins de destruction",
      "Le simple fait de posséder un extincteur",
      "Le fait de taguer une façade",
    ],
    answer:
        "La diffusion (sauf à destination des professionnels) de procédés permettant la fabrication d’engins de destruction",
    explanation:
        "322-6-1 : diffusion par tout moyen de “procédés” permettant fabriquer des engins de destruction (explosifs, nucléaires, biologiques, chimiques, ou produits domestiques/industriels/agricoles).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-6-1 — Moyens de diffusion (piège)",
    question: "Pour 322-6-1, le moyen de diffusion peut être :",
    options: [
      "N’importe lequel (tract, revue, courrier, vidéo, communications électroniques…)",
      "Uniquement Internet",
      "Uniquement un affichage public",
    ],
    answer:
        "N’importe lequel (tract, revue, courrier, vidéo, communications électroniques…)",
    explanation: "Tous moyens : transmission vers une ou plusieurs personnes.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6-1 — Public visé (QCM piège)",
    question:
        "L’infraction 322-6-1 peut être constituée si la diffusion est faite :",
    options: [
      "À un correspondant déterminé (privé) OU à un public non identifié",
      "Uniquement à un public non identifié",
      "Uniquement à des professionnels",
    ],
    answer: "À un correspondant déterminé (privé) OU à un public non identifié",
    explanation:
        "La diffusion peut être “privée” (destinataire déterminé) ou publique (site…).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-6-1 — Exception (professionnels)",
    question: "322-6-1 ne s’applique pas lorsque la diffusion intervient :",
    options: [
      "Dans un cadre strictement professionnel (chercheurs, investigations/enquête…) ",
      "Dès qu’il y a un téléphone",
      "Dès que l’auteur est mineur",
    ],
    answer:
        "Dans un cadre strictement professionnel (chercheurs, investigations/enquête…) ",
    explanation: "Exclusion : diffusion à destination des professionnels.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6-1 — Notion d’engin de destruction",
    question: "L’“engin de destruction” visé par 322-6-1 implique :",
    options: [
      "Un risque pour l’intégrité physique des personnes et/ou la destruction d’un bien en cas d’utilisation",
      "Un simple objet bruyant",
      "Un moyen uniquement artistique (graffiti)",
    ],
    answer:
        "Un risque pour l’intégrité physique des personnes et/ou la destruction d’un bien en cas d’utilisation",
    explanation:
        "Le cours vise des engins susceptibles de provoquer incendies/explosions/contaminations, dangereux pour les tiers.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-6-1 — Élément moral (V/F)",
    question:
        "Vrai/Faux : pour 322-6-1, il faut prouver que l’auteur voulait effectivement nuire.",
    options: ["Vrai", "Faux", "Seulement en cas d’Internet"],
    answer: "Faux",
    explanation:
        "Élément moral : connaissance du risque + diffusion sciemment ; le mobile importe peu.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-6-1 — Aggravation",
    question: "La circonstance aggravante de 322-6-1 al.2 est :",
    options: [
      "Diffusion via un réseau de communication électronique à destination d’un public non déterminé",
      "Bande organisée",
      "Réitération de la menace",
    ],
    answer:
        "Diffusion via un réseau de communication électronique à destination d’un public non déterminé",
    explanation:
        "Al.2 : usage d’un réseau électronique + public non déterminé.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-6-1 — Peines",
    question: "Peine encourue pour 322-6-1 al.1 :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 150 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Peines principales al.1 : 3 ans / 45 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-6-1 — Peines aggravées",
    question: "Peine encourue pour 322-6-1 al.2 :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation:
        "Aggravation “réseau électronique + public non déterminé” : 5 ans / 75 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6-1 — Tentative (V/F)",
    question: "Vrai/Faux : la tentative de 322-6-1 est punissable.",
    options: ["Vrai", "Faux", "Seulement al.2"],
    answer: "Faux",
    explanation: "Tentative : non (cours).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6-1 — Complicité",
    question: "La complicité de diffusion (322-6-1) est :",
    options: ["Oui", "Non", "Uniquement si l’auteur est fonctionnaire"],
    answer: "Oui",
    explanation: "Complicité : oui (règles générales).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "322-6 — Bien d’autrui (piège)",
    question: "Pour 322-6, le bien doit :",
    options: [
      "Appartenir à autrui",
      "Appartenir à l’auteur",
      "Être un bien culturel classé uniquement",
    ],
    answer: "Appartenir à autrui",
    explanation:
        "322-6 protège un bien appartenant à une autre personne que l’auteur.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-6 — Destruction / Dégradation / Détérioration",
    question: "La “destruction” au sens du cours correspond à :",
    options: [
      "Rendre le bien impropre à l’usage auquel il était destiné (totalement ou partiellement)",
      "Un dommage effaçable sans altération du support",
      "Une simple menace verbale",
    ],
    answer:
        "Rendre le bien impropre à l’usage auquel il était destiné (totalement ou partiellement)",
    explanation:
        "Destruction = résultat le plus grave : bien rendu inapte à son usage.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6 — Dégradation vs détérioration (piège concours)",
    question: "La “dégradation” se distingue surtout par :",
    options: [
      "Une diminution des qualités du bien sans le rendre inutilisable",
      "Une perte de valeur mais bien réparable et encore apte après réparation",
      "Une absence totale de dommage",
    ],
    answer: "Une diminution des qualités du bien sans le rendre inutilisable",
    explanation:
        "Dégradation = dommage important mais non rendant le bien inutilisable ; détérioration = moins grave, perte de valeur.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-6 — Incendie (définition du cours)",
    question: "Au sens du cours, l’incendie est :",
    options: [
      "Un feu qui se propage, non maîtrisé, dangereux pour les personnes",
      "Une simple flamme maîtrisée (bougie)",
      "Une fumée sans combustion",
    ],
    answer: "Un feu qui se propage, non maîtrisé, dangereux pour les personnes",
    explanation:
        "L’incendie se distingue d’un feu “simple” par la propagation et le danger.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6 — “Tout autre moyen” (QCM piège)",
    question: "“Tout autre moyen de nature à créer un danger” peut viser :",
    options: [
      "Un moyen non listé dès lors que la sécurité des personnes est gravement mise en danger",
      "Uniquement des explosifs industriels",
      "Uniquement l’incendie de forêts",
    ],
    answer:
        "Un moyen non listé dès lors que la sécurité des personnes est gravement mise en danger",
    explanation:
        "Interprétation large : ex. dérégler des freins, créer une voie d’eau, favoriser avalanche, etc. (exemples du cours).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "322-5 — Définition",
    question: "322-5 al.1 CP vise :",
    options: [
      "Des destructions/dégradations/détériorations involontaires dangereuses par explosion/incendie, par manquement à une obligation loi/règlement",
      "Des tags effaçables",
      "Une menace avec condition",
    ],
    answer:
        "Des destructions/dégradations/détériorations involontaires dangereuses par explosion/incendie, par manquement à une obligation loi/règlement",
    explanation:
        "Involontaire + danger + manquement à une obligation particulière de prudence/sécurité imposée par la loi ou le règlement.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-5 — Obligation (piège)",
    question: "Pour 322-5, l’obligation violée doit être :",
    options: [
      "Précise et imposée par une loi ou un règlement (acte général et impersonnel)",
      "Un simple “bon sens” sans texte",
      "Une règle privée interne sans valeur",
    ],
    answer:
        "Précise et imposée par une loi ou un règlement (acte général et impersonnel)",
    explanation:
        "Les magistrats doivent préciser source et nature exacte de l’obligation violée (cours).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-5 — Causalité (QCM piège)",
    question: "Le lien de causalité en 322-5 :",
    options: [
      "Peut être direct ou indirect (la causalité n’a pas à être immédiate)",
      "Doit toujours être immédiat et unique",
      "Est présumé dès qu’il y a un incendie",
    ],
    answer:
        "Peut être direct ou indirect (la causalité n’a pas à être immédiate)",
    explanation: "Le cours distingue causalité directe/indirecte (121-3).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-5 — Élément moral (al.2) (piège concours)",
    question: "322-5 al.2 (aggravé) vise notamment :",
    options: [
      "La violation manifestement délibérée d’une obligation particulière de sécurité/prudence (en connaissance des risques)",
      "La simple étourderie",
      "Un dol spécial de vengeance",
    ],
    answer:
        "La violation manifestement délibérée d’une obligation particulière de sécurité/prudence (en connaissance des risques)",
    explanation:
        "Al.2 : l’auteur sait les risques mais choisit volontairement de ne pas respecter l’obligation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-5 — Tentative / Complicité (V/F piège)",
    question: "Vrai/Faux : pour 322-5, la complicité est non punissable.",
    options: ["Vrai", "Faux", "Vrai seulement al.1"],
    answer: "Vrai",
    explanation:
        "Le cours indique : tentative non ; complicité non (particularité de 322-5).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "322-1 I — Définition",
    question: "322-1 I CP vise :",
    options: [
      "Des destructions/dégradations/détériorations volontaires sans danger pour les personnes et entraînant un dommage important",
      "Des destructions dangereuses par incendie/explosion",
      "Des fausses alertes",
    ],
    answer:
        "Des destructions/dégradations/détériorations volontaires sans danger pour les personnes et entraînant un dommage important",
    explanation:
        "Article de base “dommage important” hors moyens dangereux (incendie/explosifs).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-1 I — Moyen employé (piège)",
    question: "Pour 322-1 I, le moyen employé peut être :",
    options: [
      "N’importe lequel, sauf incendie ou substances explosives (qui relèvent d’autres textes)",
      "Uniquement un explosif",
      "Uniquement une inscription",
    ],
    answer:
        "N’importe lequel, sauf incendie ou substances explosives (qui relèvent d’autres textes)",
    explanation: "Le cours écarte incendie/explosifs (322-6).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-1 I — Élément moral",
    question: "L’élément moral de 322-1 I nécessite :",
    options: [
      "Une intention simple (agir sciemment et volontairement, sans droit de disposition)",
      "Un dol spécial obligatoire (nuire)",
      "Une faute d’imprudence",
    ],
    answer:
        "Une intention simple (agir sciemment et volontairement, sans droit de disposition)",
    explanation:
        "Cass. crim., 18 sept. 1991 : intention simple, mobile indifférent.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "R.635-1 — Dommage léger",
    question: "R.635-1 CP vise :",
    options: [
      "Des destructions/dégradations/détériorations volontaires sans danger pour les personnes, avec dommage léger",
      "Des menaces avec condition",
      "Des biens culturels classés",
    ],
    answer:
        "Des destructions/dégradations/détériorations volontaires sans danger pour les personnes, avec dommage léger",
    explanation:
        "Contravention 5e classe : éléments proches de 322-1 I mais dommage léger.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "R.635-1 — Élément moral (piège)",
    question: "Contrairement à beaucoup de contraventions, R.635-1 exige :",
    options: [
      "L’intention coupable (le texte vise un dommage “volontaire”)",
      "Seulement la matérialité des faits",
      "Une imprudence",
    ],
    answer: "L’intention coupable (le texte vise un dommage “volontaire”)",
    explanation:
        "Le cours souligne l’exigence d’intention malgré la nature contraventionnelle.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "R.635-1 — Peine",
    question: "Peine principale R.635-1 :",
    options: ["1 500 € d’amende", "3 750 € d’amende", "15 000 € d’amende"],
    answer: "1 500 € d’amende",
    explanation: "Contravention 5e classe : 1 500 €.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "322-1 II — Tags (définition)",
    question: "322-1 II CP réprime :",
    options: [
      "Tracer inscriptions/signes/dessins sans autorisation sur façades/véhicules/voies publiques/mobilier urbain avec dommage léger",
      "Tout dommage important par explosif",
      "Toute menace verbale",
    ],
    answer:
        "Tracer inscriptions/signes/dessins sans autorisation sur façades/véhicules/voies publiques/mobilier urbain avec dommage léger",
    explanation:
        "Spécifique “tags” : dommage léger (effaçable sans altérer le support).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-1 II — Dommage léger (piège)",
    question: "Si l’inscription est indélébile et altère le support :",
    options: [
      "On bascule vers 322-1 I (dommage important) si les conditions sont réunies",
      "On reste forcément en 322-1 II",
      "C’est une simple 1ère classe",
    ],
    answer:
        "On bascule vers 322-1 I (dommage important) si les conditions sont réunies",
    explanation:
        "Le cours : 322-1 II = dommage léger ; dommages importants = 322-1 I.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-1 II — Peine (piège)",
    question: "Peine principale 322-1 II (tags) :",
    options: [
      "3 750 € d’amende + TIG possible",
      "2 ans d’emprisonnement + 30 000 €",
      "6 mois d’emprisonnement + 7 500 €",
    ],
    answer: "3 750 € d’amende + TIG possible",
    explanation: "Le cours mentionne l’amende et la TIG pour 322-1 II.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-1 II — GAV/Flagrance (piège concours)",
    question: "Particularité signalée pour 322-1 II (tags) :",
    options: [
      "Pas de peine d’emprisonnement → pas de cadre flagrance/GAV sur ce seul fondement",
      "GAV obligatoire",
      "Toujours crime",
    ],
    answer:
        "Pas de peine d’emprisonnement → pas de cadre flagrance/GAV sur ce seul fondement",
    explanation:
        "Attention du cours : pas d’emprisonnement → pas de GAV/flag sur le seul délit.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "322-3-1 — Définition (biens culturels)",
    question:
        "322-3-1 CP réprime les destructions/dégradations/détériorations portant sur :",
    options: [
      "Des biens culturels publics ou classés (immeubles/objets classés, archéologie, biens exposés en musée/bibliothèque/archives, édifices affectés au culte…)",
      "Uniquement les véhicules",
      "Uniquement les tags effaçables",
    ],
    answer:
        "Des biens culturels publics ou classés (immeubles/objets classés, archéologie, biens exposés en musée/bibliothèque/archives, édifices affectés au culte…)",
    explanation: "Liste détaillée du cours : 1° à 4°.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-3-1 — Propriétaire (ultra-piège)",
    question:
        "Vrai/Faux : 322-3-1 peut être constitué même si l’auteur est propriétaire du bien.",
    options: ["Vrai", "Faux", "Seulement si musée"],
    answer: "Vrai",
    explanation:
        "Le cours précise : constitué même si l’auteur est propriétaire (intérêt collectif).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-3-1 — Dommage (piège)",
    question: "Pour 322-3-1, le dommage peut être :",
    options: [
      "Léger OU important (indifférent), dès lors que le bien est protégé",
      "Uniquement important",
      "Uniquement léger",
    ],
    answer:
        "Léger OU important (indifférent), dès lors que le bien est protégé",
    explanation:
        "La protection tient à la nature du bien, pas au niveau du dommage.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-3-1 — Peines",
    question: "Peines principales (322-3-1) :",
    options: [
      "7 ans d’emprisonnement + 100 000 € (ou 1/2 valeur du bien)",
      "2 ans d’emprisonnement + 30 000 €",
      "6 mois d’emprisonnement + 7 500 €",
    ],
    answer: "7 ans d’emprisonnement + 100 000 € (ou 1/2 valeur du bien)",
    explanation:
        "Le cours prévoit aussi la référence à la moitié de la valeur du bien.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-3-1 — Aggravation",
    question: "322-3-1 est aggravé notamment lorsque :",
    options: [
      "Les faits sont commis par plusieurs personnes agissant comme auteur/complice (circ. 322-3 1°)",
      "Il y a un dommage léger",
      "La victime retire sa plainte",
    ],
    answer:
        "Les faits sont commis par plusieurs personnes agissant comme auteur/complice (circ. 322-3 1°)",
    explanation:
        "Aggravation par la circonstance de pluralité (référence 322-3 1°).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-3-1 — Peine aggravée",
    question: "Peine aggravée (322-3-1 al.6) :",
    options: [
      "10 ans d’emprisonnement + 150 000 € (ou 1/2 valeur du bien)",
      "5 ans d’emprisonnement + 75 000 €",
      "3 ans d’emprisonnement + 45 000 €",
    ],
    answer: "10 ans d’emprisonnement + 150 000 € (ou 1/2 valeur du bien)",
    explanation: "Aggravé : 10 ans / 150 000 € (ou moitié valeur).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "322-12 — Peine",
    question:
        "Peine principale 322-12 (menaces sans condition, dangereuses, réitérées ou matérialisées) :",
    options: [
      "6 mois d’emprisonnement et 7 500 € d’amende",
      "1 an d’emprisonnement et 15 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "6 mois d’emprisonnement et 7 500 € d’amende",
    explanation: "Menaces sans condition : 6 mois / 7 500 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-13 — Peine (avec condition)",
    question: "Peine principale 322-13 al.1 (menace avec condition) :",
    options: [
      "1 an d’emprisonnement et 15 000 € d’amende",
      "6 mois d’emprisonnement et 7 500 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "1 an d’emprisonnement et 15 000 € d’amende",
    explanation: "Menaces avec condition : 1 an / 15 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-13 — Aggravation (danger personnes)",
    question: "322-13 al.2 aggrave lorsque la menace porte sur :",
    options: [
      "Une destruction/dégradation/détérioration dangereuse pour les personnes",
      "Un dommage léger uniquement",
      "Un simple tag",
    ],
    answer:
        "Une destruction/dégradation/détérioration dangereuse pour les personnes",
    explanation: "Al.2 : aggravation si danger pour les personnes.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-13 — Peine aggravée",
    question: "Peine aggravée 322-13 al.2 :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 150 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Menace avec condition + danger personnes : 3 ans / 45 000 €.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "322-14 — Peine",
    question: "Peines principales 322-14 (al.1 ou al.2) :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "6 mois d’emprisonnement et 7 500 €",
      "3 ans d’emprisonnement et 45 000 €",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation:
        "Fausse alerte : 2 ans / 30 000 € (dans les deux alinéas au cours).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Quiz ultra-piège — Qualification (menace)",
    question:
        "Une menace écrite unique de “mettre le feu à ta voiture ce soir” (sans exiger quoi que ce soit) relève plutôt de :",
    options: ["322-12", "322-13", "322-14"],
    answer: "322-12",
    explanation:
        "Sans condition : écrit/objet suffit (menace unique) → 322-12.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Quiz ultra-piège — Qualification (condition)",
    question: "“Si tu ne paies pas, je brûle ton commerce” relève plutôt de :",
    options: ["322-13", "322-12", "R.631-1"],
    answer: "322-13",
    explanation: "Menace avec ordre de remplir une condition (payer).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Quiz ultra-piège — Qualification (fausse info)",
    question:
        "Appeler en disant “il y a une bombe dans la gare” pour créer la panique :",
    options: ["322-14 al.1", "322-14 al.2", "322-12"],
    answer: "322-14 al.1",
    explanation:
        "Fausse information faisant croire à une destruction dangereuse pour les personnes.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Quiz ultra-piège — Qualification (sinistre)",
    question:
        "Téléphoner en prétendant inventer un accident grave pour faire venir les secours “pour rire” :",
    options: ["322-14 al.2", "322-14 al.1", "322-13"],
    answer: "322-14 al.2",
    explanation:
        "Al.2 : fausse information faisant croire à un sinistre + intervention inutile.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — V/F (articles)",
    question:
        "Vrai/Faux : 322-6 concerne des destructions dangereuses pour les personnes, alors que 322-1 I vise l’absence de danger pour les personnes.",
    options: ["Vrai", "Faux", "Ça dépend du dommage"],
    answer: "Vrai",
    explanation:
        "322-6 = moyen dangereux/danger personnes ; 322-1 I = pas de danger personnes + dommage important.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — V/F (peines)",
    question:
        "Vrai/Faux : 322-11-1 al.1 est puni moins sévèrement que 322-11-1 al.3.",
    options: ["Vrai", "Faux", "Uniquement en bande organisée"],
    answer: "Faux",
    explanation: "Al.1 : 7 ans/100k ; al.3 : 3 ans/45k.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — QCM (peines)",
    question: "Associe la bonne peine : 322-12 =",
    options: ["6 mois + 7 500 €", "1 an + 15 000 €", "2 ans + 30 000 €"],
    answer: "6 mois + 7 500 €",
    explanation: "Menaces sans condition : 6 mois / 7 500 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — QCM (peines)",
    question: "Associe la bonne peine : 322-6-1 al.2 =",
    options: ["5 ans + 75 000 €", "3 ans + 45 000 €", "7 ans + 100 000 €"],
    answer: "5 ans + 75 000 €",
    explanation:
        "Diffusion aggravée via réseau électronique + public non déterminé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — QCM (peines)",
    question: "Associe la bonne peine : 322-14 =",
    options: ["2 ans + 30 000 €", "3 ans + 45 000 €", "6 mois + 7 500 €"],
    answer: "2 ans + 30 000 €",
    explanation: "Fausse alerte : 2 ans / 30 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Définition",
    question: "322-11-1 al.1 CP réprime :",
    options: [
      "La détention ou le transport de substances/produits incendiaires ou explosifs en vue de la préparation (caractérisée) de 322-6 ou d’atteintes aux personnes",
      "Le fait de menacer de taguer un mur",
      "Le fait de posséder un briquet chez soi",
    ],
    answer:
        "La détention ou le transport de substances/produits incendiaires ou explosifs en vue de la préparation (caractérisée) de 322-6 ou d’atteintes aux personnes",
    explanation:
        "Texte : détention/transport + produits incendiaires/explosifs (ou éléments entrant dans leur composition) + préparation caractérisée par faits matériels + infractions 322-6 ou atteintes aux personnes.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Acte préparatoire (piège concours)",
    question: "Pour 322-11-1 al.1, l’intention doit apparaître :",
    options: [
      "Par une préparation caractérisée par un ou plusieurs faits matériels",
      "Uniquement par un aveu",
      "Uniquement par un casier judiciaire",
    ],
    answer:
        "Par une préparation caractérisée par un ou plusieurs faits matériels",
    explanation:
        "Le texte exige une préparation “caractérisée” par actes matériels : on est en amont de l’acte.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Détention vs transport",
    question: "La “détention” au sens du cours correspond à :",
    options: [
      "Avoir à disposition des substances/produits, sans être forcément propriétaire",
      "Détenir uniquement dans sa poche",
      "Transporter uniquement en véhicule",
    ],
    answer:
        "Avoir à disposition des substances/produits, sans être forcément propriétaire",
    explanation:
        "Détention = mise à disposition (au domicile, parties communes, chez autrui, etc.).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Souplesse (piège)",
    question:
        "Être trouvé porteur de tels produits sur la voie publique caractérise :",
    options: [
      "À la fois la détention et le transport (selon le cours)",
      "Uniquement le transport",
      "Uniquement la détention",
    ],
    answer: "À la fois la détention et le transport (selon le cours)",
    explanation:
        "Le cours insiste sur la souplesse : porteur = détention + transport.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Pluralité (ultra-piège)",
    question:
        "Selon le cours/jurisprudence citée, un seul objet suffit toujours à 322-11-1 al.1.",
    options: ["Vrai", "Faux", "Seulement en bande organisée"],
    answer: "Faux",
    explanation:
        "Le texte vise au pluriel ; la jurisprudence retient qu’un seul objet n’est pas suffisant (logique “au moins deux”).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Objet matériel (QCM piège)",
    question: "Peuvent être visés par 322-11-1 al.1 :",
    options: [
      "Des produits incendiaires/explosifs ET des éléments/substances destinés à entrer dans la composition d’engins",
      "Uniquement des explosifs industriels",
      "Uniquement des produits interdits par arrêté préfectoral",
    ],
    answer:
        "Des produits incendiaires/explosifs ET des éléments/substances destinés à entrer dans la composition d’engins",
    explanation:
        "Al.1 vise aussi les “éléments/substances destinés à entrer dans la composition”.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Infraction visée (piège)",
    question: "La préparation visée renvoie notamment :",
    options: [
      "Aux infractions de 322-6 ou aux atteintes aux personnes (titre II livre II)",
      "Uniquement aux tags",
      "Uniquement aux fausses alertes",
    ],
    answer:
        "Aux infractions de 322-6 ou aux atteintes aux personnes (titre II livre II)",
    explanation:
        "Le cours : préparation de destructions dangereuses (322-6) ou d’atteintes aux personnes.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Absence d’utilisation (piège concours)",
    question:
        "Si les substances sont utilisées (ou tentées d’être utilisées), on poursuit plutôt sur :",
    options: [
      "322-6 ou une infraction d’atteinte aux personnes (et non 322-11-1 al.1)",
      "322-11-1 al.1 uniquement",
      "R.635-1",
    ],
    answer:
        "322-6 ou une infraction d’atteinte aux personnes (et non 322-11-1 al.1)",
    explanation:
        "322-11-1 al.1 vise l’avant-acte. Si usage/tentative d’usage : on bascule sur l’infraction principale.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Élément moral",
    question: "Pour 322-11-1 al.1, il faut démontrer :",
    options: [
      "L’intention coupable (but de commettre une infraction dangereuse pour les personnes)",
      "Une simple négligence",
      "Une récidive obligatoire",
    ],
    answer:
        "L’intention coupable (but de commettre une infraction dangereuse pour les personnes)",
    explanation:
        "Le délit n’est retenu que si l’intention est établie (actes préparatoires).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Peines",
    question: "Peines principales 322-11-1 al.1 :",
    options: [
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "10 ans de réclusion et 150 000 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende",
    explanation: "Cours : 7 ans / 100 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.2 — Bande organisée",
    question: "La circonstance aggravante de 322-11-1 al.2 est :",
    options: ["La bande organisée", "L’écrit", "La réitération"],
    answer: "La bande organisée",
    explanation: "Al.2 : faits commis en bande organisée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.2 — Peines aggravées",
    question: "Peines 322-11-1 al.2 (bande organisée) :",
    options: [
      "10 ans d’emprisonnement et 500 000 € d’amende",
      "5 ans d’emprisonnement et 150 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "10 ans d’emprisonnement et 500 000 € d’amende",
    explanation: "Cours : bande organisée → 10 ans / 500 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.1 — Tentative (V/F)",
    question: "Vrai/Faux : la tentative de 322-11-1 al.1 est punissable.",
    options: ["Vrai", "Faux", "Seulement en bande organisée"],
    answer: "Faux",
    explanation: "Cours : tentative = non.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 — Complicité",
    question: "La complicité de 322-11-1 est :",
    options: ["Punissable", "Non punissable", "Punissable seulement si ITT"],
    answer: "Punissable",
    explanation: "Cours : complicité oui (infractions consommées).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "322-11-1 al.3 — Définition générale",
    question: "322-11-1 al.3 incrimine :",
    options: [
      "La détention/transport sans motif légitime de certains produits incendiaires/explosifs susceptibles de permettre 322-6 (selon les cas)",
      "La fausse alerte",
      "Les menaces avec condition",
    ],
    answer:
        "La détention/transport sans motif légitime de certains produits incendiaires/explosifs susceptibles de permettre 322-6 (selon les cas)",
    explanation:
        "Al.3 vise deux hypothèses (1° explosifs non soumis à régime particulier ; 2° produits incendiaires/éléments interdits par arrêté préfectoral).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.3 — Hypothèse 1° (piège)",
    question: "322-11-1 al.3 1° concerne :",
    options: [
      "Des substances/produits explosifs permettant 322-6, non soumis à un régime particulier, détenus/transportés sans motif légitime",
      "Uniquement les produits interdits par arrêté préfectoral",
      "Uniquement la bande organisée",
    ],
    answer:
        "Des substances/produits explosifs permettant 322-6, non soumis à un régime particulier, détenus/transportés sans motif légitime",
    explanation:
        "Le cours : vise notamment des produits de fabrication artisanale non soumis au régime des explosifs conventionnels.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.3 — Hypothèse 2° (QCM piège)",
    question: "322-11-1 al.3 2° exige notamment :",
    options: [
      "Absence de motif légitime + violation d’un arrêté préfectoral interdisant détention/transport",
      "Absence de motif légitime seule",
      "Violation d’un arrêté préfectoral seule",
    ],
    answer:
        "Absence de motif légitime + violation d’un arrêté préfectoral interdisant détention/transport",
    explanation:
        "Le cours précise : pour ces produits “banals”, il faut les deux conditions.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.3 — Motif légitime (piège concours)",
    question: "Le “motif légitime” permet surtout :",
    options: [
      "D’apprécier au cas par cas (contexte) si la détention/transport est justifié",
      "D’exclure l’infraction uniquement si la personne est mineure",
      "D’exclure l’infraction uniquement si c’est chez soi",
    ],
    answer:
        "D’apprécier au cas par cas (contexte) si la détention/transport est justifié",
    explanation:
        "Cours : ex. contexte violences urbaines vs usage normal (bonne foi).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-11-1 al.3 — Peines",
    question: "Peines pour 322-11-1 al.3 (1° ou 2°) :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Cours : al.3 = 3 ans / 45 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-11-1 al.3 — Tentative (V/F)",
    question: "Vrai/Faux : la tentative de 322-11-1 al.3 est punissable.",
    options: ["Vrai", "Faux", "Seulement 2°"],
    answer: "Faux",
    explanation: "Cours : tentative non.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "322-6 — Peine de base (rappel)",
    question:
        "Peines principales 322-6 al.1 (destructions dangereuses, intentionnelles) :",
    options: [
      "10 ans d’emprisonnement et 150 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "10 ans d’emprisonnement et 150 000 € d’amende",
    explanation: "Cours : qualification délit (base) = 10 ans / 150 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6 — Élément intentionnel (ultra-piège)",
    question:
        "Selon le cours, l’emploi d’un moyen intrinsèquement dangereux (incendie/substance explosive) :",
    options: [
      "Caractérise suffisamment l’élément intentionnel (danger inhérent connu de tous)",
      "N’apporte jamais rien à l’intention",
      "Supprime l’infraction",
    ],
    answer:
        "Caractérise suffisamment l’élément intentionnel (danger inhérent connu de tous)",
    explanation:
        "Référence du cours : toute personne est censée connaître l’efficacité/danger de ces moyens.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-6 — Tentative",
    question: "La tentative de 322-6 est :",
    options: [
      "Punissable (322-11 CP)",
      "Non punissable",
      "Punissable seulement si mort",
    ],
    answer: "Punissable (322-11 CP)",
    explanation:
        "Cours : l’article 322-11 prévoit la tentative punissable pour le délit de 322-6.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6 — Complicité",
    question: "La complicité de 322-6 (consommée ou tentée) est :",
    options: ["Oui", "Non", "Oui seulement si bande organisée"],
    answer: "Oui",
    explanation: "Cours : complicité punissable pour consommée et tentée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "322-14 — Élément matériel (piège)",
    question: "Pour 322-14, l’auteur doit :",
    options: [
      "Communiquer ou divulguer une fausse information (moyen indifférent)",
      "Seulement écrire une lettre",
      "Seulement utiliser Internet",
    ],
    answer:
        "Communiquer ou divulguer une fausse information (moyen indifférent)",
    explanation: "Le moyen est indifférent : écrit/oral/téléphone/radio, etc.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-14 al.1 — Objet (QCM piège)",
    question: "322-14 al.1 suppose de faire croire :",
    options: [
      "Qu’une destruction/dégradation/détérioration dangereuse pour les personnes va être ou a été commise",
      "Qu’un simple tag va être effacé",
      "Qu’une contravention a été commise",
    ],
    answer:
        "Qu’une destruction/dégradation/détérioration dangereuse pour les personnes va être ou a été commise",
    explanation: "Al.1 vise des faits “dangereux pour les personnes”.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-14 al.2 — Objet (piège)",
    question: "322-14 al.2 vise plutôt :",
    options: [
      "Faire croire à un sinistre et provoquer l’intervention inutile des secours",
      "Faire croire à une infraction de tag",
      "Menacer avec condition",
    ],
    answer:
        "Faire croire à un sinistre et provoquer l’intervention inutile des secours",
    explanation:
        "Al.2 : sinistre (accident, feu d’origine accidentelle, etc.) + intervention inutile.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-14 — Élément moral",
    question: "L’élément moral de 322-14 implique :",
    options: [
      "Connaissance de la fausseté + volonté de faire croire (mobile indifférent)",
      "Seulement une imprudence",
      "Un dol spécial de gain financier",
    ],
    answer:
        "Connaissance de la fausseté + volonté de faire croire (mobile indifférent)",
    explanation: "Intention requise : l’auteur sait que c’est faux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-14 — Tentative/Complicité",
    question: "Pour 322-14 :",
    options: [
      "Tentative non, complicité oui",
      "Tentative oui, complicité non",
      "Tentative oui, complicité oui uniquement",
    ],
    answer: "Tentative non, complicité oui",
    explanation: "Cours : tentative non ; complicité oui.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "322-12 — Condition de matérialisation (piège concours)",
    question: "Une menace sans condition tombe sous 322-12 si elle est :",
    options: [
      "Réitérée si verbale OU matérialisée par écrit/image/objet (unique possible)",
      "Toujours unique même verbale",
      "Toujours réitérée même écrite",
    ],
    answer:
        "Réitérée si verbale OU matérialisée par écrit/image/objet (unique possible)",
    explanation:
        "Cours : verbal = réitération ; écrit/image/objet = une seule suffit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-12 — Objet (piège)",
    question:
        "322-12 vise des menaces de destructions/dégradations/détériorations :",
    options: [
      "Dangereuses pour les personnes",
      "Toujours légères",
      "Uniquement sur biens culturels",
    ],
    answer: "Dangereuses pour les personnes",
    explanation:
        "Le texte du cours sur 322-12 : menace de faits dangereux pour les personnes, sans condition, réitérée ou matérialisée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-12 — Tentative/Complicité",
    question: "Pour 322-12 :",
    options: [
      "Tentative non, complicité oui",
      "Tentative oui, complicité non",
      "Tentative oui uniquement si écrit",
    ],
    answer: "Tentative non, complicité oui",
    explanation: "Cours : tentative non ; complicité oui.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "322-13 — Condition (définition)",
    question: "La “condition” au sens de 322-13 correspond à :",
    options: [
      "Un ordre/injonction de faire ou ne pas faire (action/abstention) pour éviter le mal annoncé",
      "Une simple insulte",
      "Une promesse de cadeau",
    ],
    answer:
        "Un ordre/injonction de faire ou ne pas faire (action/abstention) pour éviter le mal annoncé",
    explanation:
        "Condition = atteinte à la liberté d’agir : contrainte sur le comportement de la victime.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-13 — Élément moral",
    question: "Pour 322-13, il est requis :",
    options: [
      "La volonté d’atteindre moralement la victime (mobile indifférent)",
      "Une intention d’exécuter réellement la menace",
      "La preuve que l’auteur avait les moyens matériels",
    ],
    answer: "La volonté d’atteindre moralement la victime (mobile indifférent)",
    explanation:
        "Indifférent que l’auteur puisse exécuter la menace ; intention = intimidation/atteinte morale.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "322-1 I — Dommage important (ultra-piège)",
    question: "Le caractère “important” du dommage (322-1 I) est :",
    options: [
      "Apprécié souverainement par le juge",
      "Défini par un seuil fixe en euros dans le Code pénal",
      "Toujours présumé si le bien est un véhicule",
    ],
    answer: "Apprécié souverainement par le juge",
    explanation:
        "Cours : l’importance du résultat reste à l’appréciation du juge.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-1 I — Bien d’autrui (piège copropriété)",
    question:
        "Selon le cours, le propriétaire peut malgré tout relever de 322-1 I si :",
    options: [
      "Il n’a pas la pleine et entière propriété (ex : copropriétaire)",
      "Il possède une facture",
      "Il a une autorisation orale",
    ],
    answer: "Il n’a pas la pleine et entière propriété (ex : copropriétaire)",
    explanation:
        "Le cours cite l’application à un copropriétaire détruisant une clôture de l’immeuble.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "322-3 — Circonstances aggravantes (rappel)",
    question:
        "Parmi les circonstances aggravantes (322-3), on retrouve notamment :",
    options: [
      "La dissimulation du visage pour éviter l’identification",
      "Le fait d’être de bonne foi",
      "Le dépôt d’une plainte",
    ],
    answer: "La dissimulation du visage pour éviter l’identification",
    explanation:
        "322-3 liste de nombreuses circonstances ; celle-ci en fait partie.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-2 — Registre/minute/acte original",
    question:
        "322-2 concerne notamment la destruction/dégradation/détérioration :",
    options: [
      "D’un registre, d’une minute ou d’un acte original de l’autorité publique",
      "D’un véhicule privé uniquement",
      "D’un bien culturel classé uniquement",
    ],
    answer:
        "D’un registre, d’une minute ou d’un acte original de l’autorité publique",
    explanation:
        "Registres d’état civil, minutes notariales, originaux d’actes/constats/PV dressés par autorités habilitées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-1 II — Tags (tentative)",
    question: "La tentative de 322-1 II (tags) est :",
    options: [
      "Punissable (322-4)",
      "Non punissable",
      "Punissable seulement si récidive",
    ],
    answer: "Punissable (322-4)",
    explanation:
        "Cours : 322-4 prévoit la tentative punissable pour ces délits.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-1 II — Complicité",
    question: "La complicité pour 322-1 II (tags) est :",
    options: ["Oui", "Non", "Seulement par provocation"],
    answer: "Oui",
    explanation: "Cours : complicité punissable pour consommée et tentée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Quiz ultra-piège — 322-11-1 al.1 ou al.3 ?",
    question:
        "On constate plusieurs objets/produits, et des faits matériels montrant une préparation d’une infraction dangereuse. On vise plutôt :",
    options: ["322-11-1 al.1", "322-11-1 al.3", "322-14"],
    answer: "322-11-1 al.1",
    explanation:
        "Al.1 = détention/transport + préparation caractérisée (faits matériels) + finalité (322-6 ou atteintes personnes).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Quiz ultra-piège — 322-11-1 al.3 2°",
    question:
        "Transport d’un produit incendiaire “banal” en violation d’un arrêté préfectoral, sans motif légitime :",
    options: ["322-11-1 al.3 2°", "322-11-1 al.1", "322-12"],
    answer: "322-11-1 al.3 2°",
    explanation:
        "Al.3 2° : absence motif légitime + violation arrêté préfectoral.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Quiz ultra-piège — 322-6 vs 322-11-1",
    question:
        "Si l’usage d’un moyen dangereux est commencé (commencement d’exécution), on se rapproche plutôt de :",
    options: [
      "322-6 (ou tentative 322-6)",
      "322-11-1 al.1 uniquement",
      "R.635-1",
    ],
    answer: "322-6 (ou tentative 322-6)",
    explanation:
        "322-11-1 vise l’avant-usage ; dès qu’on bascule dans l’utilisation/tentative, 322-6 prend le relais.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Révisions rapides — V/F (peines)",
    question:
        "Vrai/Faux : 322-11-1 al.2 est plus sévèrement puni que 322-11-1 al.1.",
    options: ["Vrai", "Faux", "Seulement si ITT"],
    answer: "Vrai",
    explanation: "Al.1 : 7 ans/100k ; al.2 : 10 ans/500k.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — V/F (tous les moyens)",
    question:
        "Vrai/Faux : en 322-6, le Code liste exhaustivement tous les moyens possibles.",
    options: ["Vrai", "Faux", "Vrai seulement pour l’incendie"],
    answer: "Faux",
    explanation:
        "Le texte vise aussi “tout autre moyen de nature à créer un danger” (formule large).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — QCM (articles)",
    question: "Associe : “fausses alertes” =",
    options: ["322-14", "322-12", "322-6-1"],
    answer: "322-14",
    explanation:
        "322-14 : fausses informations (destruction dangereuse ou sinistre) entraînant croyance/intervention inutile.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — QCM (articles)",
    question: "Associe : “menaces avec condition” =",
    options: ["322-13", "322-12", "R.635-1"],
    answer: "322-13",
    explanation: "Menaces + ordre de remplir une condition.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — QCM (articles)",
    question: "Associe : “diffusion de procédés (engins de destruction)” =",
    options: ["322-6-1", "322-11-1", "322-3-1"],
    answer: "322-6-1",
    explanation: "Diffusion de procédés (sauf professionnels).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-6-1 — Définition",
    question: "322-6-1 al.1 CP réprime :",
    options: [
      "La diffusion, par tout moyen (sauf à destination des professionnels), de procédés permettant la fabrication d’engins de destruction",
      "La détention d’un bidon d’essence chez soi",
      "La menace de taguer un mur",
    ],
    answer:
        "La diffusion, par tout moyen (sauf à destination des professionnels), de procédés permettant la fabrication d’engins de destruction",
    explanation:
        "322-6-1 : diffusion de procédés permettant la fabrication d’engins de destruction ; exclusion du cadre strictement professionnel.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-6-1 — Élément matériel (piège)",
    question: "Pour 322-6-1, la diffusion suppose :",
    options: [
      "Une transmission vers une ou plusieurs personnes (moyen indifférent)",
      "Une diffusion uniquement sur Internet",
      "Une diffusion uniquement par écrit papier",
    ],
    answer:
        "Une transmission vers une ou plusieurs personnes (moyen indifférent)",
    explanation:
        "Tous moyens : courrier, tract, affiche, revue, vidéo, communications électroniques, etc.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6-1 — Public visé (ultra-piège)",
    question:
        "La diffusion à un correspondant déterminé (en privé) peut suffire à caractériser 322-6-1.",
    options: ["Vrai", "Faux", "Seulement si c’est un site public"],
    answer: "Vrai",
    explanation:
        "Le cours : destination à un particulier déterminé ou à un public non identifié (site) → possible.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-6-1 — Exception (pro)",
    question:
        "L’infraction de 322-6-1 ne s’applique pas lorsque la diffusion intervient :",
    options: [
      "Dans un cadre strictement professionnel (ex : recherches, sécurité, enquêtes)",
      "Quand il y a plus de 3 destinataires",
      "Quand c’est gratuit",
    ],
    answer:
        "Dans un cadre strictement professionnel (ex : recherches, sécurité, enquêtes)",
    explanation:
        "Le texte exclut la destination aux professionnels (cadre pro).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6-1 — Élément moral (piège concours)",
    question: "Pour 322-6-1, l’auteur doit notamment :",
    options: [
      "Savoir le risque et diffuser sciemment un procédé dangereux",
      "Avoir déjà utilisé lui-même un engin",
      "Être en bande organisée",
    ],
    answer: "Savoir le risque et diffuser sciemment un procédé dangereux",
    explanation: "Connaissance du risque + diffusion volontaire.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-6-1 — Aggravation",
    question: "La circonstance aggravante de 322-6-1 al.2 est :",
    options: [
      "L’usage d’un réseau de communication électronique à destination d’un public non déterminé",
      "La réitération verbale",
      "La présence d’une condition",
    ],
    answer:
        "L’usage d’un réseau de communication électronique à destination d’un public non déterminé",
    explanation:
        "Al.2 : diffusion via réseau électronique vers public non déterminé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6-1 — Peines",
    question: "Peines 322-6-1 al.1 :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "6 mois d’emprisonnement et 7 500 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Cours : 3 ans / 45k (simple).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-6-1 — Peines aggravées",
    question: "Peines 322-6-1 al.2 :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "10 ans d’emprisonnement et 150 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Aggravation réseau électronique vers public non déterminé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-6-1 — Tentative/Complicité",
    question: "Pour 322-6-1 :",
    options: [
      "Tentative non, complicité oui",
      "Tentative oui, complicité non",
      "Tentative oui, complicité oui uniquement",
    ],
    answer: "Tentative non, complicité oui",
    explanation: "Cours : tentative non ; complicité oui.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "322-5 — Définition",
    question: "322-5 al.1 CP vise :",
    options: [
      "Des destructions/dégradations/détériorations involontaires dangereuses par explosion/incendie, par manquement à une obligation légale ou réglementaire de prudence/sécurité",
      "Des tags avec dommage léger",
      "Une fausse alerte à la bombe",
    ],
    answer:
        "Des destructions/dégradations/détériorations involontaires dangereuses par explosion/incendie, par manquement à une obligation légale ou réglementaire de prudence/sécurité",
    explanation:
        "Involontaire + explosion/incendie + obligation précise (loi/règlement) violée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-5 — Obligation (piège)",
    question: "Le “règlement” au sens du cours correspond :",
    options: [
      "Aux actes administratifs à caractère général et impersonnel",
      "À un accord verbal entre voisins",
      "À un contrat privé uniquement",
    ],
    answer: "Aux actes administratifs à caractère général et impersonnel",
    explanation: "Le cours précise la notion de règlement.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-5 — Source obligatoire",
    question: "Les magistrats doivent pouvoir :",
    options: [
      "Préciser la source et la nature exacte de l’obligation violée",
      "Se contenter d’un “devoir général de prudence” sans texte",
      "Se baser uniquement sur le ressenti de la victime",
    ],
    answer: "Préciser la source et la nature exacte de l’obligation violée",
    explanation:
        "Le cours insiste : obligation précise imposée par loi/règlement.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-5 — Causalité (QCM piège)",
    question: "En matière de 322-5, le lien de causalité :",
    options: [
      "N’a pas à être immédiat (le fait peut engendrer un dommage qui s’aggrave)",
      "Doit toujours être unique et exclusif",
      "Est inutile si le dommage est important",
    ],
    answer:
        "N’a pas à être immédiat (le fait peut engendrer un dommage qui s’aggrave)",
    explanation: "Le cours admet une causalité non nécessairement immédiate.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-5 — Causalité indirecte (ultra-piège)",
    question: "L’auteur “indirect” (121-3 al.4) est celui qui :",
    options: [
      "A créé/contribué à créer la situation ayant permis le dommage ou n’a pas pris les mesures pour l’éviter",
      "A directement allumé le feu",
      "A uniquement assisté la victime",
    ],
    answer:
        "A créé/contribué à créer la situation ayant permis le dommage ou n’a pas pris les mesures pour l’éviter",
    explanation:
        "Définition cours : auteur indirect = à l’origine de la situation dangereuse.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-5 — Peines (al.1)",
    question: "Peines 322-5 al.1 :",
    options: [
      "1 an d’emprisonnement et 15 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "10 ans d’emprisonnement et 150 000 € d’amende",
    ],
    answer: "1 an d’emprisonnement et 15 000 € d’amende",
    explanation:
        "Cours : al.1 (faute simple sur obligation précise) = 1 an / 15k.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "322-5 — Violation manifestement délibérée",
    question: "322-5 al.2 correspond à :",
    options: [
      "La violation manifestement délibérée d’une obligation particulière de sécurité/prudence (en connaissance des risques)",
      "Une simple maladresse sans conscience",
      "Un acte intentionnel (322-6)",
    ],
    answer:
        "La violation manifestement délibérée d’une obligation particulière de sécurité/prudence (en connaissance des risques)",
    explanation: "Al.2 : forme “aggravée” de l’élément moral.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-5 — Peines (al.2)",
    question: "Peines 322-5 al.2 :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "6 mois d’emprisonnement et 7 500 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation: "Cours : al.2 = 2 ans / 30k.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-5 — Tentative/Complicité (piège)",
    question: "Pour 322-5 :",
    options: [
      "Tentative non, complicité non",
      "Tentative oui, complicité oui",
      "Tentative non, complicité oui",
    ],
    answer: "Tentative non, complicité non",
    explanation: "Cours : tentative non ; complicité non.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "322-1 I — Moyen employé (piège)",
    question: "322-1 I (dommage important) vise tous moyens, sauf :",
    options: [
      "L’incendie et les substances explosives (qui basculent en 322-6 / 322-5)",
      "La peinture",
      "La gravure",
    ],
    answer:
        "L’incendie et les substances explosives (qui basculent en 322-6 / 322-5)",
    explanation:
        "Cours : 322-1 I n’englobe pas l’incendie / explosifs (régimes spécifiques).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-1 I — Élément moral",
    question: "L’élément moral de 322-1 I est :",
    options: [
      "L’intention simple (agir sciemment et volontairement)",
      "La négligence",
      "La préméditation obligatoire",
    ],
    answer: "L’intention simple (agir sciemment et volontairement)",
    explanation: "Pas besoin de dol spécial ; mobile indifférent.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "R.635-1 — Qualification",
    question: "R.635-1 CP correspond à :",
    options: [
      "La contravention de 5e classe pour destructions/dégradations/détériorations avec dommage léger",
      "Un délit puni de 10 ans",
      "Un crime",
    ],
    answer:
        "La contravention de 5e classe pour destructions/dégradations/détériorations avec dommage léger",
    explanation: "Dommage léger → contravention 5e classe.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "R.635-1 — Intention (piège)",
    question: "Contrairement à beaucoup de contraventions, R.635-1 exige :",
    options: [
      "Une intention (dommage volontaire)",
      "Une simple imprudence suffit",
      "Aucun élément moral",
    ],
    answer: "Une intention (dommage volontaire)",
    explanation: "Le texte requiert le caractère “volontaire”.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "R.635-1 — Peine",
    question: "Peine principale R.635-1 :",
    options: ["1 500 € d’amende", "3 750 € d’amende", "30 000 € d’amende"],
    answer: "1 500 € d’amende",
    explanation: "Contravention 5e classe : 1 500 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "R.635-1 — Tentative/Complicité",
    question: "Pour R.635-1 :",
    options: [
      "Tentative non, complicité oui (aide/instructions)",
      "Tentative oui, complicité non",
      "Tentative oui, complicité oui seulement",
    ],
    answer: "Tentative non, complicité oui (aide/instructions)",
    explanation: "Cours : tentative non ; complicité prévue (al.9).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "322-3-1 — Définition",
    question: "322-3-1 CP protège :",
    options: [
      "Les biens culturels publics/classés (immeubles/objets classés ou inscrits, patrimoine archéologique, biens culturels du domaine public mobilier, édifices affectés au culte…)",
      "Uniquement les véhicules",
      "Uniquement les biens appartenant à l’État",
    ],
    answer:
        "Les biens culturels publics/classés (immeubles/objets classés ou inscrits, patrimoine archéologique, biens culturels du domaine public mobilier, édifices affectés au culte…)",
    explanation:
        "Liste large : patrimoine protégé, y compris dépôt temporaire, musées/bibliothèques/archives, édifices du culte.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-3-1 — Bien d’autrui ? (ultra-piège)",
    question:
        "Pour 322-3-1, l’infraction peut être constituée même si l’auteur est propriétaire du bien.",
    options: ["Vrai", "Faux", "Seulement si bande organisée"],
    answer: "Vrai",
    explanation:
        "Le cours : constitué même si l’auteur est propriétaire (intérêt collectif).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-3-1 — Dommage léger/important",
    question: "Sous 322-3-1, le dommage peut être :",
    options: [
      "Léger ou important (indifférent)",
      "Uniquement important",
      "Uniquement léger",
    ],
    answer: "Léger ou important (indifférent)",
    explanation: "Il suffit que le bien soit dans la catégorie protégée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-3-1 — Peines",
    question: "Peines (simple) 322-3-1 :",
    options: [
      "7 ans d’emprisonnement et 100 000 € d’amende (ou 1/2 valeur)",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende (ou 1/2 valeur)",
    explanation: "Cours : 7 ans / 100k ou 1/2 valeur du bien.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-3-1 — Aggravation",
    question: "L’aggravation (322-3-1 al.6) correspond :",
    options: [
      "À la circonstance “plusieurs personnes” (1° de 322-3) appliquée aux biens culturels",
      "À la bande organisée de 322-11-1",
      "À la fausse alerte",
    ],
    answer:
        "À la circonstance “plusieurs personnes” (1° de 322-3) appliquée aux biens culturels",
    explanation:
        "Renvoi : aggravation si plusieurs personnes agissant auteur/complice.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "322-3-1 — Peines aggravées",
    question: "Peines aggravées 322-3-1 :",
    options: [
      "10 ans d’emprisonnement et 150 000 € d’amende (ou 1/2 valeur)",
      "10 ans d’emprisonnement et 500 000 € d’amende",
      "5 ans d’emprisonnement et 150 000 € d’amende",
    ],
    answer: "10 ans d’emprisonnement et 150 000 € d’amende (ou 1/2 valeur)",
    explanation: "Cours : aggravé = 10 ans / 150k ou 1/2 valeur.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "322-3-1 — Tentative/Complicité",
    question: "Pour 322-3-1 :",
    options: [
      "Tentative oui (322-4), complicité oui",
      "Tentative non, complicité oui",
      "Tentative oui, complicité non",
    ],
    answer: "Tentative oui (322-4), complicité oui",
    explanation:
        "Cours : 322-4 prévoit tentative pour ces délits ; complicité oui.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Ultra-piège — Choix de texte",
    question:
        "Un incendie involontaire (manquement à une obligation précise) qui met des personnes en danger relève plutôt de :",
    options: ["322-5", "322-6", "322-1 I"],
    answer: "322-5",
    explanation:
        "Involontaire + incendie/explosion + obligation prudence/sécurité = 322-5.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Ultra-piège — Choix de texte",
    question:
        "Une destruction volontaire par incendie, créant un danger pour les personnes, relève plutôt de :",
    options: ["322-6", "322-1 I", "R.635-1"],
    answer: "322-6",
    explanation: "Incendie/explosif + danger personnes + intentionnel = 322-6.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Ultra-piège — 322-14 vs 322-12",
    question:
        "Annoncer faussement une bombe pour déclencher une évacuation correspond le mieux à :",
    options: ["322-14", "322-12", "322-13"],
    answer: "322-14",
    explanation:
        "Fausse information faisant croire à une destruction dangereuse (ou sinistre) = fausse alerte.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Ultra-piège — 322-12 vs 322-13",
    question: "“Si tu ne paies pas, je détruis ta voiture” correspond à :",
    options: ["322-13 (avec condition)", "322-12 (sans condition)", "322-14"],
    answer: "322-13 (avec condition)",
    explanation:
        "Présence d’une injonction/condition (payer) pour éviter le mal.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Révisions rapides — V/F (322-3-1)",
    question: "Vrai/Faux : pour 322-3-1, le dommage doit être important.",
    options: ["Vrai", "Faux", "Vrai si édifice du culte"],
    answer: "Faux",
    explanation:
        "Dommage léger ou important : indifférent dès lors que le bien est protégé.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — V/F (322-6-1)",
    question:
        "Vrai/Faux : 322-6-1 exige que l’engin ait effectivement été fabriqué ou utilisé.",
    options: ["Vrai", "Faux", "Seulement en al.2"],
    answer: "Faux",
    explanation:
        "L’infraction porte sur la diffusion du procédé (en amont), pas sur l’usage effectif.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — QCM (tentative)",
    question: "La tentative est punissable pour :",
    options: ["322-6", "322-14", "322-13"],
    answer: "322-6",
    explanation:
        "Cours : tentative punissable pour 322-6 (322-11). 322-14 et 322-13 : tentative non.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — QCM (complicité)",
    question: "La complicité n’est PAS retenue (selon le cours) pour :",
    options: ["322-5", "322-14", "322-12"],
    answer: "322-5",
    explanation:
        "Cours : 322-5 → complicité NON. 322-14/322-12 → complicité OUI.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Définition",
    question: "La non-justification de ressources (321-6 CP) vise :",
    options: [
      "L’impossibilité de justifier des ressources/biens, avec des relations habituelles liées à des crimes/délits ≥ 5 ans",
      "Le simple fait d’être pauvre sans justificatifs",
      "Le refus de présenter une pièce d’identité lors d’un contrôle",
    ],
    answer:
        "L’impossibilité de justifier des ressources/biens, avec des relations habituelles liées à des crimes/délits ≥ 5 ans",
    explanation:
        "321-6 al.1 : train de vie/biens non justifiés + relations habituelles avec auteurs (infractions ≥ 5 ans procurant profit) ou victimes d’une de ces infractions.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Texte",
    question: "La non-justification de ressources est prévue par :",
    options: [
      "321-6 al.1 du Code pénal",
      "321-1 du Code pénal",
      "441-6 du Code pénal",
    ],
    answer: "321-6 al.1 du Code pénal",
    explanation:
        "Le cours : l’article 321-6 al.1 définit et réprime la non-justification de ressources.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Alternative",
    question: "321-6 incrimine notamment :",
    options: [
      "Ne pas justifier des ressources correspondant au train de vie OU ne pas justifier l’origine d’un bien détenu",
      "Uniquement le fait de détenir de l’argent liquide",
      "Uniquement le fait de fréquenter des délinquants",
    ],
    answer:
        "Ne pas justifier des ressources correspondant au train de vie OU ne pas justifier l’origine d’un bien détenu",
    explanation:
        "Deux portes d’entrée : ressources/train de vie ou origine d’un bien détenu.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Piège “lien profit”",
    question:
        "Pour les relations habituelles avec des auteurs, 321-6 exige aussi :",
    options: [
      "Que ces infractions procurent un profit direct ou indirect à la personne fréquentée",
      "Que l’auteur soit condamné",
      "Que le mis en cause ait participé à l’infraction d’origine",
    ],
    answer:
        "Que ces infractions procurent un profit direct ou indirect à la personne fréquentée",
    explanation:
        "Le texte : infractions ≥ 5 ans procurant un profit direct/indirect à l’auteur fréquenté.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category:
        "Non-justification de ressources (321-6) — Piège “train de vie modeste”",
    question:
        "Vrai/Faux : un train de vie “modeste” exclut automatiquement 321-6.",
    options: ["Vrai", "Faux", "Seulement si pas de véhicule"],
    answer: "Faux",
    explanation:
        "Cass. crim., 6 fév. 2008 : même avec un train de vie modeste, des avoirs disproportionnés et flux suspects peuvent suffire.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Preuve (piège)",
    question:
        "Vrai/Faux : 321-6 crée une présomption automatique de culpabilité dès qu’il y a des espèces.",
    options: ["Vrai", "Faux", "Uniquement au-delà de 10 000 €"],
    answer: "Faux",
    explanation:
        "Cass. crim., 13 juin 2012 : pas de présomption générale de responsabilité pénale ; l’accusation doit prouver les éléments.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Documents attendus",
    question:
        "Pour justifier la licéité d’un bien détenu, le document le plus “béton” est :",
    options: ["Facture d’achat", "Message WhatsApp", "Rumeur de voisinage"],
    answer: "Facture d’achat",
    explanation:
        "Le cours : preuve de la licéité notamment par production de factures.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Cas pratique",
    question:
        "Une personne détient une grosse somme, 3 véhicules puissants, et vit en groupe organisé avec des proches auteurs de vols (≥5 ans). Elle ne justifie pas ses ressources. Qualification principale :",
    options: [
      "Non-justification de ressources (321-6)",
      "Recel (321-1) uniquement",
      "Association de malfaiteurs automatique",
    ],
    answer: "Non-justification de ressources (321-6)",
    explanation:
        "Le cours cite un cas-type : relations habituelles + détention disproportionnée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Élément moral",
    question: "L’élément moral de 321-6 suppose :",
    options: [
      "La conscience de bénéficier du produit d’infractions commises par une personne fréquentée",
      "L’intention de revendre les biens",
      "Une volonté de nuire à l’État",
    ],
    answer:
        "La conscience de bénéficier du produit d’infractions commises par une personne fréquentée",
    explanation:
        "Le cours : conscience de bénéficier du produit des infractions (ou de profiter des ressources de la victime).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Piège compagne",
    question:
        "Vrai/Faux : une compagne qui croit vivre avec un “dirigeant de société” peut être relaxée faute de conscience, même si son conjoint est trafiquant.",
    options: ["Vrai", "Faux", "Seulement si mariage"],
    answer: "Vrai",
    explanation:
        "Le cours cite : pas coupable si elle “croit” légitimement (Cass. crim., 25 juin 2003).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Non-justification aggravée (321-6-1) — Autorité sur mineur",
    question: "321-6-1 al.1 aggrave lorsque :",
    options: [
      "Les crimes/délits sont commis par un mineur sur lequel la personne a autorité",
      "Le mis en cause est mineur",
      "Le bien est un véhicule",
    ],
    answer:
        "Les crimes/délits sont commis par un mineur sur lequel la personne a autorité",
    explanation:
        "Aggravation 321-6-1 al.1 : mineur sur lequel l’adulte a autorité.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification aggravée (321-6-1) — Peines al.1",
    question: "Peines 321-6-1 al.1 :",
    options: ["5 ans + 150 000 €", "3 ans + 75 000 €", "7 ans + 200 000 €"],
    answer: "5 ans + 150 000 €",
    explanation: "Tableau : al.1 = 5 ans d’emprisonnement, 150 000 € d’amende.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification aggravée (321-6-1) — Infractions visées al.2",
    question: "321-6-1 al.2 vise notamment :",
    options: [
      "Traite des êtres humains, extorsion, association de malfaiteurs, armes/explosifs, trafic de stupéfiants (y compris relations avec usagers)",
      "Uniquement les vols simples",
      "Uniquement les contraventions",
    ],
    answer:
        "Traite des êtres humains, extorsion, association de malfaiteurs, armes/explosifs, trafic de stupéfiants (y compris relations avec usagers)",
    explanation:
        "Le cours liste ces infractions (et ajoute : relations habituelles avec personnes faisant usage de stupéfiants).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification aggravée (321-6-1) — Peines al.2",
    question: "Peines 321-6-1 al.2 :",
    options: ["7 ans + 200 000 €", "5 ans + 150 000 €", "10 ans + 300 000 €"],
    answer: "7 ans + 200 000 €",
    explanation: "Tableau : al.2 = 7 ans, 200 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification aggravée (321-6-1) — Mineurs al.3",
    question: "321-6-1 al.3 aggrave lorsque :",
    options: [
      "Une infraction de l’alinéa 2 est commise par un ou plusieurs mineurs",
      "Le mis en cause est majeur",
      "Le bien est immobilier",
    ],
    answer:
        "Une infraction de l’alinéa 2 est commise par un ou plusieurs mineurs",
    explanation: "Al.3 : alinéa 2 + mineur(s) impliqué(s).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification aggravée (321-6-1) — Peines al.3",
    question: "Peines 321-6-1 al.3 :",
    options: ["10 ans + 300 000 €", "7 ans + 200 000 €", "3 ans + 75 000 €"],
    answer: "10 ans + 300 000 €",
    explanation: "Tableau : al.3 = 10 ans, 300 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification (321-6) — Confiscation obligatoire (piège)",
    question:
        "Vrai/Faux : en 321-6, la confiscation des biens saisis non justifiés est obligatoire.",
    options: ["Vrai", "Faux", "Seulement si récidive"],
    answer: "Vrai",
    explanation:
        "Le cours : confiscation obligatoire des biens saisis dont l’origine n’est pas justifiée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification (321-6) — Tentative",
    question: "Tentative en 321-6 / 321-6-1 :",
    options: [
      "Non (tentative non punissable)",
      "Oui, toujours",
      "Oui, seulement si bande organisée",
    ],
    answer: "Non (tentative non punissable)",
    explanation: "Le tableau : TENTATIVE : NON.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification (321-6) — Complicité",
    question: "Complicité en 321-6 :",
    options: ["Oui", "Non", "Seulement si mineur"],
    answer: "Oui",
    explanation:
        "Le tableau : COMPLICITÉ : OUI (121-6 / 121-7 : aide, assistance, provocation, instructions).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Recel (321-1) — Texte",
    question: "Le recel est défini et réprimé par :",
    options: ["321-1 CP", "321-6 CP", "441-1 CP"],
    answer: "321-1 CP",
    explanation: "Le cours : 321-1 définit et réprime le recel.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Double définition (piège)",
    question: "Le recel, c’est :",
    options: [
      "Dissimuler/détenir/transmettre/intermédiaire une chose provenant crime/délit OU bénéficier du produit en connaissance",
      "Uniquement revendre un objet volé",
      "Uniquement cacher un objet",
    ],
    answer:
        "Dissimuler/détenir/transmettre/intermédiaire une chose provenant crime/délit OU bénéficier du produit en connaissance",
    explanation:
        "Le texte prévoit aussi le “recel d’usage” : bénéficier du produit d’un crime/délit.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Acte de dissimulation",
    question:
        "Vrai/Faux : dissimuler un bien est répréhensible même si le bien est ensuite retrouvé.",
    options: ["Vrai", "Faux", "Seulement si vol"],
    answer: "Vrai",
    explanation: "Le cours : peu importe le résultat (retrouvé ou non).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Dissimulation = indice",
    question:
        "Vrai/Faux : la dissimulation peut faire présumer la connaissance de l’origine frauduleuse.",
    options: ["Vrai", "Faux", "Seulement si professionnel"],
    answer: "Vrai",
    explanation:
        "Le cours : la seule dissimulation fera présumer la connaissance.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Objet recelé (piège)",
    question: "Le recel peut porter sur :",
    options: [
      "Énergie, secrets de fabrication, photocopies violant un secret, biens meubles/immeubles",
      "Uniquement objets volés “physiques”",
      "Uniquement argent",
    ],
    answer:
        "Énergie, secrets de fabrication, photocopies violant un secret, biens meubles/immeubles",
    explanation:
        "Le cours : tout ce qui est matière à vol + extensions (énergie, secrets, photocopies…).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Infraction d’origine (piège)",
    question:
        "Vrai/Faux : l’infraction d’origine doit être un crime ou un délit (pas une contravention).",
    options: ["Vrai", "Faux", "Seulement pour le recel d’usage"],
    answer: "Vrai",
    explanation: "Le cours : contraventions exclues.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Tiers auteur (piège concours)",
    question:
        "Vrai/Faux : l’auteur de l’infraction principale peut être poursuivi pour recel de ses propres biens.",
    options: ["Vrai", "Faux", "Seulement si bande organisée"],
    answer: "Faux",
    explanation:
        "Le cours : la chambre criminelle n’admet pas l’auto-recel ; l’infraction d’origine doit être commise par un tiers.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Complice vs receleur",
    question:
        "Vrai/Faux : le complice de l’infraction d’origine peut aussi être poursuivi pour recel (délit distinct).",
    options: ["Vrai", "Faux", "Jamais cumulable"],
    answer: "Vrai",
    explanation:
        "Le cours : possible de poursuivre un complice comme receleur, recel = délit distinct.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Relaxé auteur d’origine (piège)",
    question:
        "Si l’auteur d’origine échappe aux poursuites pour prescription ou non-identification, alors le receleur :",
    options: [
      "Peut quand même être poursuivi/condamné",
      "Est automatiquement relaxé",
      "Ne peut être poursuivi que si l’auteur est condamné",
    ],
    answer: "Peut quand même être poursuivi/condamné",
    explanation:
        "Le cours : le receleur peut être condamné même si auteur d’origine inconnu/prescrit/non poursuivi pour raisons procédurales.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Disparition juridique (piège)",
    question:
        "Si une loi abroge l’incrimination de l’infraction d’origine (disparition juridique), alors :",
    options: [
      "Le recel n’est plus légalement constitué",
      "Le recel reste punissable",
      "Le recel devient une contravention",
    ],
    answer: "Le recel n’est plus légalement constitué",
    explanation:
        "Le cours : sans infraction originaire, le recel disparaît (ex. banqueroute simple abrogée).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Élément moral",
    question: "L’élément moral du recel exige :",
    options: [
      "La connaissance de l’origine frauduleuse (crime/délit)",
      "La volonté de nuire à la victime",
      "Une condamnation préalable de l’auteur d’origine",
    ],
    answer: "La connaissance de l’origine frauduleuse (crime/délit)",
    explanation:
        "Le recel n’est punissable que si connaissance (mauvaise foi).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Moment d’appréciation",
    question: "La bonne/mauvaise foi s’apprécie :",
    options: [
      "Au moment où la personne reçoit/transmet/tire profit",
      "Au moment du jugement uniquement",
      "Au moment où la victime porte plainte",
    ],
    answer: "Au moment où la personne reçoit/transmet/tire profit",
    explanation:
        "Le cours : appréciation au moment de l’acte (réception/transmission/profit).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Recel (321-1) — Peines",
    question: "Peines du recel simple (321-1) :",
    options: ["5 ans + 375 000 €", "3 ans + 75 000 €", "10 ans + 750 000 €"],
    answer: "5 ans + 375 000 €",
    explanation: "Tableau : 321-1 = 5 ans, 375 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel aggravé (321-2) — Peines",
    question: "Peines du recel aggravé (321-2) :",
    options: ["10 ans + 750 000 €", "5 ans + 375 000 €", "7 ans + 200 000 €"],
    answer: "10 ans + 750 000 €",
    explanation: "Tableau : 321-2 = 10 ans, 750 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel (321-3) — Amende proportionnelle (piège)",
    question:
        "Vrai/Faux : l’amende du recel (321-1/321-2) peut être portée jusqu’à la moitié de la valeur des biens recelés.",
    options: ["Vrai", "Faux", "Seulement si bande organisée"],
    answer: "Vrai",
    explanation:
        "Nota : 321-3 permet d’élever l’amende au-delà, jusqu’à la moitié de la valeur des biens recelés.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel — Tentative (piège concours)",
    question: "Tentative de recel :",
    options: [
      "Non punissable pour recel simple ; punissable si recel criminel (crime) uniquement",
      "Toujours punissable",
      "Jamais punissable",
    ],
    answer:
        "Non punissable pour recel simple ; punissable si recel criminel (crime) uniquement",
    explanation:
        "Le cours : tentative recel simple non prévue ; tentative de recel criminel toujours punissable.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel — Complicité",
    question: "Complicité en matière de recel :",
    options: ["Oui (121-7)", "Non", "Seulement si professionnel"],
    answer: "Oui (121-7)",
    explanation:
        "Le cours : complicité applicable (aide/assistance, provocation, instructions).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "QCM ultra-piège — Recel d’usage",
    question:
        "Une personne profite sciemment du train de vie financé par des détournements commis par son conjoint. Qualification la plus juste :",
    options: [
      "Recel d’usage (321-1 : bénéficier du produit)",
      "Non-justification (321-6) uniquement",
      "Aucune si elle ne touche pas d’argent",
    ],
    answer: "Recel d’usage (321-1 : bénéficier du produit)",
    explanation:
        "Le cours cite le cas : bénéficier du train de vie = recel d’usage en connaissance de cause.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM ultra-piège — Recel vs 321-6",
    question:
        "Différence clé : 321-1 requiert une “chose provenant d’un crime/délit”, alors que 321-6 repose sur :",
    options: [
      "Train de vie/biens non justifiés + relations habituelles (≥5 ans) avec auteurs/victimes",
      "Seulement une absence de facture",
      "Seulement une condamnation préalable d’un proche",
    ],
    answer:
        "Train de vie/biens non justifiés + relations habituelles (≥5 ans) avec auteurs/victimes",
    explanation:
        "321-6 = délit spécifique basé sur non-justification + relations habituelles.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Recel (321-2) pro (ultra-piège)",
    question:
        "Un brocanteur achète régulièrement des bijoux sans facture, ne les inscrit pas au registre de police, et sait qu’ils sont volés. Qualification principale :",
    options: [
      "Recel aggravé (321-2) via facilités pro / habitude",
      "Recel simple (321-1) uniquement",
      "Non-justification (321-6)",
    ],
    answer: "Recel aggravé (321-2) via facilités pro / habitude",
    explanation:
        "321-2 : habitude ou facilités pro ; le cours évoque l’expérience pro + omissions au registre comme indices de mauvaise foi.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — 321-6-1 al.2 stupéfiants (ultra-piège)",
    question:
        "Une personne ne justifie pas ses ressources et fréquente habituellement des personnes faisant usage de stupéfiants. Qualification la plus adaptée (si conditions remplies) :",
    options: [
      "Non-justification aggravée 321-6-1 al.2",
      "Non-justification simple 321-6 uniquement",
      "Recel 321-1 automatiquement",
    ],
    answer: "Non-justification aggravée 321-6-1 al.2",
    explanation:
        "Le cours : al.2 vise aussi les relations habituelles avec personnes faisant usage de stupéfiants (trafic).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Article + peine (321-6)",
    question:
        "Un mis en cause ne justifie pas l’origine d’une Mercedes + sommes sur compte + construction maison, en relations habituelles avec auteurs ≥5 ans. Qualification + peine de base :",
    options: [
      "321-6 : 3 ans + 75 000 € (+ confiscation obligatoire)",
      "321-1 : 5 ans + 375 000 €",
      "321-6-1 al.3 : 10 ans + 300 000 €",
    ],
    answer: "321-6 : 3 ans + 75 000 € (+ confiscation obligatoire)",
    explanation:
        "Base 321-6 : 3 ans, 75 000 €, confiscation obligatoire des biens non justifiés.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Article + peine (321-2)",
    question:
        "Un receleur agit en bande organisée sur des biens provenant d’un délit : qualification + peine encourue :",
    options: [
      "321-2 : 10 ans + 750 000 €",
      "321-1 : 5 ans + 375 000 €",
      "321-4 : peines de l’infraction d’origine (automatique)",
    ],
    answer: "321-2 : 10 ans + 750 000 €",
    explanation:
        "321-2 aggrave notamment en bande organisée (ou habitude / facilités pro).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — 321-4 (crime) (ultra-piège)",
    question:
        "Un receleur sait que le bien provient d’un crime. Application la plus juste :",
    options: [
      "321-4 : peines attachées au crime connu (recel criminel possible)",
      "321-1 seulement",
      "321-2 seulement",
    ],
    answer: "321-4 : peines attachées au crime connu (recel criminel possible)",
    explanation:
        "321-4 renvoie aux peines de l’infraction d’origine lorsque supérieures et si le receleur en a connaissance.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Vrai/Faux — Recel (indices)",
    question:
        "Vrai/Faux : l’absence de facture peut être un indice de connaissance de l’origine frauduleuse.",
    options: ["Vrai", "Faux", "Jamais"],
    answer: "Vrai",
    explanation:
        "Le cours : absence de facture = indice possible de mauvaise foi.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Recel (nature exacte)",
    question:
        "Vrai/Faux : le receleur doit connaître la nature exacte de l’infraction d’origine (vol/escroquerie/etc.).",
    options: ["Vrai", "Faux", "Seulement si crime"],
    answer: "Faux",
    explanation:
        "Le cours : pas nécessaire de connaître la nature exacte ni les circonstances ; seulement crime/délit.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Non-justification (victime)",
    question:
        "Vrai/Faux : 321-6 peut viser des relations habituelles avec des victimes d’infractions ≥5 ans.",
    options: ["Vrai", "Faux", "Seulement si extorsion"],
    answer: "Vrai",
    explanation:
        "Le texte mentionne aussi les relations avec les victimes d’une de ces infractions.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Non-justification (profit)",
    question:
        "Vrai/Faux : pour la branche “victime”, 321-6 exige que la victime profite de l’infraction.",
    options: ["Vrai", "Faux", "Uniquement si mineur"],
    answer: "Faux",
    explanation:
        "Le “profit” est une condition liée à la branche “auteurs” (profit direct/indirect des infractions).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "QCM ultra-piège — Articles spéciaux (recel)",
    question: "Parmi ces “recels spéciaux”, lequel existe dans le cours ?",
    options: [
      "Recel de criminel (434-6)",
      "Recel de faux (441-1)",
      "Recel d’outrage (433-5)",
    ],
    answer: "Recel de criminel (434-6)",
    explanation:
        "Le cours liste des recels spécifiques : 434-6, 434-7, 434-4, etc.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM ultra-piège — Recel spécial (cadavre)",
    question: "Le recel de cadavre est prévu par :",
    options: ["434-7 CP", "321-1 CP", "441-4 CP"],
    answer: "434-7 CP",
    explanation: "Nota du cours : recel de cadavre = 434-7.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM ultra-piège — Recel spécial (document/objet)",
    question:
        "Le recel de document/objet facilitant la découverte d’un crime/délit est :",
    options: ["434-4 CP", "321-2 CP", "225-6 CP"],
    answer: "434-4 CP",
    explanation:
        "Nota du cours : recel de document/objet facilitant découverte = 434-4.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Définition",
    question: "La non-justification de ressources (321-6 CP) implique :",
    options: [
      "Ne pas pouvoir justifier de ressources/biens + relations habituelles liées à des infractions ≥ 5 ans",
      "Avoir un compte bancaire sans justificatif",
      "Refuser de déclarer ses revenus aux impôts (en soi)",
    ],
    answer:
        "Ne pas pouvoir justifier de ressources/biens + relations habituelles liées à des infractions ≥ 5 ans",
    explanation:
        "321-6 al.1 : impossibilité de justifier ressources correspondant au train de vie ou origine d’un bien détenu + relations habituelles avec auteurs (≥ 5 ans, profit) ou victimes.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Objet",
    question: "La non-justification (321-6) peut porter sur :",
    options: [
      "Des ressources ne correspondant pas au train de vie ET/OU l’origine d’un bien détenu",
      "Uniquement des salaires",
      "Uniquement des espèces",
    ],
    answer:
        "Des ressources ne correspondant pas au train de vie ET/OU l’origine d’un bien détenu",
    explanation:
        "Le texte vise deux volets : ressources vs train de vie et origine d’un bien détenu (mobilier/immobilier).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Relations habituelles",
    question: "Les relations habituelles peuvent être caractérisées par :",
    options: [
      "Rencontres, entrevues ou visites régulières",
      "Une seule interaction sur la voie publique",
      "Le simple fait d’habiter la même ville",
    ],
    answer: "Rencontres, entrevues ou visites régulières",
    explanation:
        "Le cours précise que les relations habituelles peuvent se limiter à des rencontres/entrevues/visites.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Seuil des infractions",
    question:
        "Les infractions liées aux relations habituelles doivent être punies :",
    options: [
      "D’au moins 5 ans d’emprisonnement",
      "D’au moins 1 an d’emprisonnement",
      "D’une simple amende",
    ],
    answer: "D’au moins 5 ans d’emprisonnement",
    explanation:
        "321-6 : crimes ou délits punis d’au moins 5 ans d’emprisonnement.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Profit",
    question: "Pour l’hypothèse “relations avec auteurs”, il faut :",
    options: [
      "Que ces infractions procurent un profit direct ou indirect aux auteurs",
      "Que les auteurs aient été condamnés définitivement",
      "Que l’auteur de 321-6 ait commis l’infraction d’origine",
    ],
    answer:
        "Que ces infractions procurent un profit direct ou indirect aux auteurs",
    explanation:
        "Le texte exige que les infractions procurent un profit direct/indirect aux personnes fréquentées.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Victimes",
    question:
        "321-6 vise aussi le cas où la personne est en relations habituelles avec :",
    options: [
      "La victime d’une des infractions concernées",
      "Un témoin",
      "Un policier (en uniforme)",
    ],
    answer: "La victime d’une des infractions concernées",
    explanation:
        "Le texte vise aussi les relations habituelles avec des victimes d’une des infractions (≥ 5 ans).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Indices train de vie",
    question: "Pour prouver le train de vie reproché, l’enquête peut relever :",
    options: [
      "Hôtel/restaurant, achats véhicules, mouvements bancaires, paiements espèces",
      "Uniquement un relevé d’identité bancaire",
      "Uniquement des déclarations anonymes",
    ],
    answer:
        "Hôtel/restaurant, achats véhicules, mouvements bancaires, paiements espèces",
    explanation:
        "Le cours liste des indices de train de vie (dépenses, véhicules, flux bancaires, espèces).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Justificatifs",
    question: "La justification des moyens d’existence peut se faire par :",
    options: [
      "Factures, bulletins de paye, déclaration de revenus",
      "Une promesse orale",
      "Une photo d’un compte bancaire",
    ],
    answer: "Factures, bulletins de paye, déclaration de revenus",
    explanation:
        "Le texte mentionne des documents “indiscutables” (factures, bulletins de paye, déclaration de revenus).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Présomption",
    question:
        "Vrai/Faux : 321-6 instaure une présomption de culpabilité automatique.",
    options: ["Vrai", "Faux", "Ça dépend des relations"],
    answer: "Faux",
    explanation:
        "Cass. crim., 13 juin 2012 : pas de présomption de responsabilité pénale ; l’accusation doit rapporter la preuve.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Appréciation",
    question: "Qui apprécie souverainement les faits et preuves débattues ?",
    options: ["Les juges du fond", "Le mis en cause", "L’enquêteur uniquement"],
    answer: "Les juges du fond",
    explanation:
        "Le cours indique que les juges ont un pouvoir souverain d’appréciation des faits/circonstances et preuves débattues.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category:
        "Non-justification de ressources (321-6) — Avoirs disproportionnés",
    question:
        "Vrai/Faux : un train de vie modeste n’exclut pas 321-6 si les avoirs bancaires sont disproportionnés.",
    options: ["Vrai", "Faux", "Seulement si luxe visible"],
    answer: "Vrai",
    explanation:
        "Jurisprudence citée : couple au train de vie modeste mais avoirs bancaires disproportionnés + mouvements + espèces (Cass. crim., 6 fév. 2008).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Biens concernés",
    question: "L’obligation de justifier l’origine peut concerner :",
    options: [
      "Biens mobiliers et immobiliers",
      "Uniquement les véhicules",
      "Uniquement les liquidités",
    ],
    answer: "Biens mobiliers et immobiliers",
    explanation:
        "Le cours précise que cela correspond aux biens mobiliers et immobiliers.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Renversement",
    question: "Concernant l’origine d’un bien détenu, le mécanisme implique :",
    options: [
      "Que le prévenu explique la provenance (ex : factures)",
      "Que l’État prouve l’achat exact",
      "Que la victime prouve le vol",
    ],
    answer: "Que le prévenu explique la provenance (ex : factures)",
    explanation:
        "Le cours explique le renversement : c’est au prévenu d’établir la licéité (factures...).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Élément moral",
    question: "L’élément moral suppose :",
    options: [
      "Conscience de bénéficier du produit d’infractions commises par une relation habituelle",
      "Intention de rédiger un faux document",
      "Simple imprudence dans la gestion du budget",
    ],
    answer:
        "Conscience de bénéficier du produit d’infractions commises par une relation habituelle",
    explanation:
        "Le cours : conscience de bénéficier du produit d’infractions commises par la/les personnes fréquentées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Erreur de croyance",
    question: "La compagne d’un trafiquant ne sera pas coupable si elle :",
    options: [
      "Croit être en ménage avec un dirigeant de société",
      "A déjà reçu un cadeau",
      "Vit sous le même toit",
    ],
    answer: "Croit être en ménage avec un dirigeant de société",
    explanation:
        "Le cours cite l’exemple : absence de conscience → pas d’infraction (Cass. crim., 25 juin 2003).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Peine simple",
    question: "Peines encourues (321-6) :",
    options: ["3 ans et 75 000 €", "5 ans et 150 000 €", "1 an et 15 000 €"],
    answer: "3 ans et 75 000 €",
    explanation:
        "321-6 : 3 ans d’emprisonnement et 75 000 € d’amende + confiscation obligatoire des biens non justifiés.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Confiscation",
    question:
        "Vrai/Faux : la confiscation des biens saisis non justifiés est obligatoire en 321-6.",
    options: ["Vrai", "Faux", "Ça dépend du montant"],
    answer: "Vrai",
    explanation:
        "Le texte précise : confiscation obligatoire des biens saisis dont l’origine n’est pas justifiée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Tentative/complicité",
    question: "Tentative et complicité (321-6) :",
    options: [
      "Tentative non ; complicité oui",
      "Tentative oui ; complicité non",
      "Tentative oui ; complicité oui",
    ],
    answer: "Tentative non ; complicité oui",
    explanation: "Le cours : tentative NON ; complicité OUI (121-6/121-7).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category:
        "Non-justification de ressources (321-6-1) — Mineur sous autorité",
    question: "321-6-1 al.1 aggrave si les infractions sont commises :",
    options: [
      "Par un mineur sur lequel la personne a autorité",
      "Par un majeur cohabitant",
      "Par un collègue de travail",
    ],
    answer: "Par un mineur sur lequel la personne a autorité",
    explanation:
        "Aggravation 321-6-1 al.1 : crimes/délits commis par un mineur sur lequel l’auteur a autorité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6-1) — Peine al.1",
    question: "Peine 321-6-1 al.1 :",
    options: ["5 ans + 150 000 €", "7 ans + 200 000 €", "10 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation: "321-6-1 al.1 : 5 ans d’emprisonnement et 150 000 € d’amende.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6-1) — Champs al.2",
    question: "321-6-1 al.2 vise notamment :",
    options: [
      "Traite, extorsion, association de malfaiteurs, armes/explosifs, trafic de stupéfiants (y compris relations avec usagers)",
      "Uniquement le vol simple",
      "Uniquement l’escroquerie",
    ],
    answer:
        "Traite, extorsion, association de malfaiteurs, armes/explosifs, trafic de stupéfiants (y compris relations avec usagers)",
    explanation:
        "Le cours liste TEH, extorsion, association de malfaiteurs, infractions armes/explosifs et trafic de stups (incluant relations avec usagers).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6-1) — Peine al.2",
    question: "Peine 321-6-1 al.2 :",
    options: ["7 ans + 200 000 €", "5 ans + 150 000 €", "3 ans + 75 000 €"],
    answer: "7 ans + 200 000 €",
    explanation: "321-6-1 al.2 : 7 ans d’emprisonnement et 200 000 € d’amende.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6-1) — Mineurs al.3",
    question: "321-6-1 al.3 aggrave lorsque :",
    options: [
      "Une infraction de l’al.2 est commise par un ou plusieurs mineurs",
      "Une infraction quelconque est commise par un majeur",
      "Le train de vie est luxueux",
    ],
    answer: "Une infraction de l’al.2 est commise par un ou plusieurs mineurs",
    explanation:
        "Aggravation 321-6-1 al.3 : infraction mentionnée à l’al.2 commise par un ou plusieurs mineurs.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6-1) — Peine al.3",
    question: "Peine 321-6-1 al.3 :",
    options: ["10 ans + 300 000 €", "7 ans + 200 000 €", "5 ans + 150 000 €"],
    answer: "10 ans + 300 000 €",
    explanation:
        "321-6-1 al.3 : 10 ans d’emprisonnement et 300 000 € d’amende.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Non-justification (321-6)",
    question:
        "Des parents vivent en groupe organisé, détiennent de grosses sommes et 3 véhicules puissants sans revenus compatibles, leurs enfants commettent des vols. Qualification la plus probable ?",
    options: [
      "Non-justification de ressources (321-6)",
      "Recel uniquement (321-1)",
      "Aucune infraction faute de preuve",
    ],
    answer: "Non-justification de ressources (321-6)",
    explanation:
        "Jurisprudence citée : parents en possession de numéraires/vêtements provenant de vols commis par enfants, ressources insuffisantes → 321-6 (Cass. crim., 8 fév. 1989).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Non-justification (321-6)",
    question:
        "Un exploitant de bar-restaurant détient d’importantes liquidités sans rapport avec ses ressources déclarées. Qualification la plus adaptée :",
    options: [
      "Non-justification de ressources (321-6)",
      "Corruption passive (432-11)",
      "Faux administratif (441-2)",
    ],
    answer: "Non-justification de ressources (321-6)",
    explanation:
        "Jurisprudence citée : possession d’importantes liquidités sans rapport avec ressources (Cass. crim., 19 mai 1999) → 321-6.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Recel (321-1) — Définition",
    question: "Le recel (321-1 CP) est notamment :",
    options: [
      "Dissimuler/détenir/transmettre une chose en sachant qu’elle provient d’un crime ou d’un délit",
      "Utiliser une fausse identité pour obtenir un titre",
      "Ne pas dénoncer un crime",
    ],
    answer:
        "Dissimuler/détenir/transmettre une chose en sachant qu’elle provient d’un crime ou d’un délit",
    explanation:
        "321-1 : dissimuler, détenir, transmettre ou faire l’intermédiaire, en sachant l’origine crime/délit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Recel d’usage",
    question: "Constitue aussi un recel :",
    options: [
      "Bénéficier par tout moyen du produit d’un crime ou d’un délit (en connaissance de cause)",
      "Toucher un salaire légal",
      "Recevoir un don licite",
    ],
    answer:
        "Bénéficier par tout moyen du produit d’un crime ou d’un délit (en connaissance de cause)",
    explanation:
        "321-1 al.2 : recel d’usage = profit du produit en connaissance de cause.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Dissimuler",
    question:
        "Vrai/Faux : dissimuler un bien d’origine frauduleuse est répréhensible quel que soit le résultat.",
    options: ["Vrai", "Faux", "Seulement si le bien est retrouvé"],
    answer: "Vrai",
    explanation:
        "Le cours : les agissements de dissimulation sont répréhensibles quel que soit leur résultat (peu importe retrouvés ou non).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Exemple local",
    question: "Exemple jurisprudentiel de dissimulation :",
    options: [
      "Mettre un local à disposition pour entreposer des objets volés",
      "Oublier une facture",
      "Perdre ses papiers",
    ],
    answer: "Mettre un local à disposition pour entreposer des objets volés",
    explanation:
        "Cass. crim., 30 mars 1999 : mise à disposition d’un local pour stocker des objets volés → recel.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Dissimuler et comptabilité",
    question: "La dissimulation peut aussi consister à :",
    options: [
      "Porter des mentions fausses en comptabilité pour couvrir la possession frauduleuse",
      "Ne pas remplir une main courante",
      "Refuser de répondre à une question",
    ],
    answer:
        "Porter des mentions fausses en comptabilité pour couvrir la possession frauduleuse",
    explanation:
        "Le cours cite la dissimulation via de fausses mentions comptables (C.A. Paris, 12 juillet 1985).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Présomption de connaissance",
    question:
        "Vrai/Faux : la seule dissimulation peut faire présumer la connaissance de l’origine frauduleuse.",
    options: ["Vrai", "Faux", "Uniquement si vol aggravé"],
    answer: "Vrai",
    explanation:
        "Le cours : la dissimulation fera présumer la connaissance de l’origine frauduleuse, donc le recel (ex. plaques dissimulées).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Détention",
    question: "La détention recéleuse consiste à :",
    options: [
      "Avoir la chose à sa disposition, sans être nécessairement propriétaire",
      "Avoir signé un contrat de vente légal",
      "Regarder un objet volé sans le toucher",
    ],
    answer:
        "Avoir la chose à sa disposition, sans être nécessairement propriétaire",
    explanation:
        "Le cours : détenir = avoir à disposition une chose ; le simple fait de détention peut constituer le recel (délit continu).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Profit indifférent",
    question:
        "Vrai/Faux : le profit personnel est indispensable pour caractériser le recel.",
    options: ["Vrai", "Faux", "Ça dépend de la valeur"],
    answer: "Faux",
    explanation:
        "Le cours : usage/profit/bénéfice importent peu pour le recel de détention ; la détention suffit si connaissance.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Réception indirecte",
    question: "La chose peut être reçue :",
    options: [
      "Directement de l’auteur ou indirectement via un intermédiaire même de bonne foi",
      "Uniquement de l’auteur principal",
      "Uniquement via un professionnel",
    ],
    answer:
        "Directement de l’auteur ou indirectement via un intermédiaire même de bonne foi",
    explanation:
        "L’innocence d’un intermédiaire n’exclut pas la responsabilité du receleur si connaissance de l’origine.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Transmission",
    question: "La “transmission” recéleuse, c’est :",
    options: [
      "Céder/remettre/faire parvenir une chose transmissible",
      "Refuser de transmettre un dossier administratif",
      "Signer une plainte",
    ],
    answer: "Céder/remettre/faire parvenir une chose transmissible",
    explanation:
        "Le cours définit la transmission comme céder/remettre/faire passer une chose.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Intermédiaire",
    question: "Faire office d’intermédiaire signifie :",
    options: [
      "Mettre en relation des personnes/choses pour transmettre, même par un acte isolé",
      "Être obligatoirement rémunéré",
      "Devoir détenir matériellement la chose",
    ],
    answer:
        "Mettre en relation des personnes/choses pour transmettre, même par un acte isolé",
    explanation:
        "Le cours : pas besoin d’habitude, but lucratif non exigé, et détention matérielle non nécessaire.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Intermédiaire (jurisprudence)",
    question:
        "Intervenir uniquement dans la négociation de biens volés peut caractériser :",
    options: [
      "Un recel par entremise",
      "Un recel impossible",
      "Une simple contravention",
    ],
    answer: "Un recel par entremise",
    explanation:
        "Cass. crim., 30 nov. 1999 : intervention dans la négociation de bons volés → recel par entremise.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Recel d’usage (passager)",
    question:
        "Un passager d’un véhicule dont il connaît l’origine frauduleuse est :",
    options: [
      "Receleur (recel d’usage)",
      "Jamais responsable",
      "Seulement témoin",
    ],
    answer: "Receleur (recel d’usage)",
    explanation:
        "Le cours cite le passager d’un véhicule volé comme receleur (Cass. crim., 09 juillet 1970).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Train de vie d’un proche",
    question:
        "Profiter du train de vie financé par un détournement commis par son conjoint peut être :",
    options: [
      "Un recel (bénéficier du produit)",
      "Un outrage",
      "Une non-dénonciation",
    ],
    answer: "Un recel (bénéficier du produit)",
    explanation:
        "Le cours cite le profit du train de vie lié à un détournement comme recel (Cass. crim., 09 mai 1974).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Services/repas",
    question:
        "Vrai/Faux : bénéficier de repas/distractions payés avec des chèques détournés peut constituer un recel.",
    options: ["Vrai", "Faux", "Seulement si on signe un reçu"],
    answer: "Vrai",
    explanation:
        "Cass. crim., 07 mai 2002 : repas/distractions réglés avec fonds détournés → recel (bénéficier par tout moyen).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Contrat de travail fictif",
    question:
        "Bénéficier d’un salaire sans prestation (suite à détournement de fonds publics) peut constituer :",
    options: [
      "Un recel",
      "Un faux administratif (441-2) automatiquement",
      "Une contravention",
    ],
    answer: "Un recel",
    explanation:
        "Le cours cite : bénéficier d’un contrat/salaire sans prestation à la suite d’un détournement → recel (Cass. crim., 30 mai 2001).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Travaux/fournitures/crédits",
    question:
        "Faire réaliser des travaux chez soi grâce à un marché “à perte” peut caractériser :",
    options: [
      "Un recel (bénéficier du produit)",
      "Une rébellion",
      "Une non-justification (321-6) uniquement",
    ],
    answer: "Un recel (bénéficier du produit)",
    explanation:
        "Le cours cite un exemple de travaux réalisés grâce à un marché : recel (Cass. crim., 14 mai 2003).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Informations",
    question: "Le recel de délit d’initié est caractérisé par :",
    options: [
      "Bénéficier du produit de l’exploitation d’informations privilégiées",
      "Détenir l’information sans l’utiliser",
      "Publier l’information au public",
    ],
    answer:
        "Bénéficier du produit de l’exploitation d’informations privilégiées",
    explanation:
        "Le cours : recel d’initié = bénéficier du produit de l’exploitation sur le marché (Cass. crim., 26 oct. 1995).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Objet de l’acte",
    question:
        "Tout ce qui est matière à vol peut faire l’objet d’un recel, notamment :",
    options: [
      "Meubles, bijoux, argent, énergie, secrets de fabrication",
      "Uniquement un véhicule",
      "Uniquement des espèces",
    ],
    answer: "Meubles, bijoux, argent, énergie, secrets de fabrication",
    explanation:
        "Le cours élargit la nature de la chose : objets, énergie, secrets, etc.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Subrogation",
    question:
        "Vrai/Faux : le recel peut viser un bien acheté avec des fonds recelés (subrogation).",
    options: ["Vrai", "Faux", "Seulement si achat immobilier"],
    answer: "Vrai",
    explanation:
        "Le cours : recel possible quand les fonds reçus servent à acheter un bien ou investir (Cass. crim., 22 juin 1972).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Contraventions",
    question: "Le recel exclut :",
    options: ["Les contraventions", "Les délits", "Les crimes"],
    answer: "Les contraventions",
    explanation:
        "La chose doit provenir d’un crime ou d’un délit ; les contraventions sont exclues.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Qualification de l’infraction d’origine",
    question:
        "Vrai/Faux : le juge doit préciser la nature de l’infraction d’origine pour retenir le recel.",
    options: ["Vrai", "Faux", "Uniquement si bande organisée"],
    answer: "Vrai",
    explanation:
        "Le cours : la simple mention “origine frauduleuse” ne suffit pas ; il faut préciser l’infraction initiale.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Croyance erronée",
    question:
        "Vrai/Faux : si la personne croit à tort que le bien provient d’un crime/délit, on peut retenir le recel.",
    options: ["Vrai", "Faux", "Seulement si la valeur est élevée"],
    answer: "Faux",
    explanation:
        "Le cours : pas de recel si l’auteur croit à tort que le bien provient d’un crime ou d’un délit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Abrogation",
    question:
        "Si l’infraction d’origine a été abrogée (plus d’infraction), alors :",
    options: [
      "Le recel n’est pas légalement constitué",
      "Le recel reste constitué car l’objet est “frauduleux”",
      "Le recel devient une tentative",
    ],
    answer: "Le recel n’est pas légalement constitué",
    explanation:
        "Le cours cite l’abrogation de la banqueroute simple : absence d’infraction originaire → pas de recel (Cass. crim., 17 mai 1989).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Auteur d’origine tiers",
    question: "En principe, l’infraction d’origine doit être commise :",
    options: ["Par un tiers", "Par le receleur lui-même", "Par la victime"],
    answer: "Par un tiers",
    explanation:
        "Le cours : l’auteur de l’infraction principale ne peut pas être poursuivi pour recel ; infraction d’origine par un tiers.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Complice",
    question:
        "Vrai/Faux : le complice de l’infraction d’origine peut être poursuivi comme receleur.",
    options: ["Vrai", "Faux", "Seulement si le bien est un véhicule"],
    answer: "Vrai",
    explanation:
        "Le cours : le recel est un délit distinct, le complice peut aussi être poursuivi comme receleur.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Obstacles procéduraux",
    question:
        "Le receleur peut être condamné même si l’auteur d’origine échappe aux poursuites pour :",
    options: [
      "Prescription, non-identification, immunité familiale",
      "Fait justificatif supprimant l’infraction",
      "Abrogation du texte",
    ],
    answer: "Prescription, non-identification, immunité familiale",
    explanation:
        "Le cours : raisons procédurales n’empêchent pas la condamnation du receleur (contrairement à la disparition objective de l’infraction).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Connaissance (niveau)",
    question: "Le receleur doit connaître :",
    options: [
      "L’origine crime/délit (sans besoin de connaître la qualification exacte)",
      "Le numéro d’article exact de l’infraction d’origine",
      "L’identité complète de l’auteur d’origine",
    ],
    answer:
        "L’origine crime/délit (sans besoin de connaître la qualification exacte)",
    explanation:
        "Le cours : pas nécessaire de connaître la nature précise/circonstances exactes ; suffit de savoir origine crime/délit.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Indices",
    question: "La connaissance peut être déduite notamment de :",
    options: [
      "Dissimulation, acquisition à bas prix, objets de valeur par non-pro, absence de facture",
      "Le fait d’acheter en ligne",
      "Le fait de payer en espèces (seul)",
    ],
    answer:
        "Dissimulation, acquisition à bas prix, objets de valeur par non-pro, absence de facture",
    explanation:
        "Le cours cite ces indices pour déduire la connaissance de l’origine frauduleuse.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Moment d’appréciation",
    question: "La bonne/mauvaise foi s’apprécie :",
    options: [
      "Au moment où le prévenu reçoit/transmet/tire profit de la chose",
      "Au moment de l’enquête uniquement",
      "Au moment du jugement uniquement",
    ],
    answer: "Au moment où le prévenu reçoit/transmet/tire profit de la chose",
    explanation:
        "Le cours : l’appréciation se fait au moment de recevoir, transmettre ou tirer profit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Piège Pelegrin",
    question:
        "Vrai/Faux : conserver un bien après apprendre son origine frauduleuse suffit toujours à caractériser un recel.",
    options: ["Vrai", "Faux", "Ça dépend du prix d’achat"],
    answer: "Faux",
    explanation:
        "Arrêt Pelegrin : si bonne foi reconnue au moment de l’acquisition, pas de recel du seul fait de conserver après découverte.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-2) — Aggravation",
    question: "Le recel est aggravé (321-2) quand il est commis :",
    options: [
      "De façon habituelle/avec facilités professionnelles OU en bande organisée",
      "En état d’ivresse",
      "La nuit seulement",
    ],
    answer:
        "De façon habituelle/avec facilités professionnelles OU en bande organisée",
    explanation: "321-2 : habitude ou facilités pro ; bande organisée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-4) — Peines de l’infraction d’origine",
    question: "321-4 s’applique lorsque :",
    options: [
      "L’infraction d’origine (connue) est punie d’une peine privative de liberté supérieure à celle du recel",
      "L’infraction d’origine est une contravention",
      "Le receleur est mineur",
    ],
    answer:
        "L’infraction d’origine (connue) est punie d’une peine privative de liberté supérieure à celle du recel",
    explanation:
        "321-4 : si peine d’origine > peine recel, receleur puni des peines attachées à l’infraction d’origine (et des seules C.A. connues).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Peines",
    question: "Peines du recel simple (321-1) :",
    options: ["5 ans + 375 000 €", "3 ans + 75 000 €", "10 ans + 750 000 €"],
    answer: "5 ans + 375 000 €",
    explanation: "321-1 : 5 ans d’emprisonnement et 375 000 € d’amende.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel (321-2) — Peines",
    question: "Peines du recel aggravé (321-2) :",
    options: ["10 ans + 750 000 €", "7 ans + 200 000 €", "5 ans + 150 000 €"],
    answer: "10 ans + 750 000 €",
    explanation: "321-2 : 10 ans d’emprisonnement et 750 000 € d’amende.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel (321-3) — Amende majorée",
    question:
        "Vrai/Faux : l’amende de 321-1/321-2 peut être portée jusqu’à la moitié de la valeur des biens recelés.",
    options: ["Vrai", "Faux", "Uniquement en bande organisée"],
    answer: "Vrai",
    explanation:
        "321-3 : amendes de 321-1 et 321-2 peuvent être élevées jusqu’à la moitié de la valeur des biens recelés.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel — Tentative",
    question: "Tentative de recel :",
    options: [
      "Non pour recel simple ; oui si recel aggravé est un crime",
      "Oui toujours",
      "Non toujours",
    ],
    answer: "Non pour recel simple ; oui si recel aggravé est un crime",
    explanation:
        "Le cours : tentative recel simple non prévue ; tentative de recel criminel toujours punissable.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel — Complicité",
    question: "La complicité en matière de recel est :",
    options: [
      "Punissable (121-7)",
      "Non punissable",
      "Punissable seulement si habituelle",
    ],
    answer: "Punissable (121-7)",
    explanation:
        "Le cours : complicité applicable au recel selon 121-7 (aide/assistance, provocation, instructions).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QCM ultra-piège — Recel vs non-justification",
    question:
        "La non-justification (321-6) se distingue du recel (321-1) car elle exige :",
    options: [
      "Des relations habituelles + train de vie/biens non justifiés (sans identifier une “chose” précise)",
      "La détention matérielle d’une chose précise uniquement",
      "Une manœuvre frauduleuse envers l’administration",
    ],
    answer:
        "Des relations habituelles + train de vie/biens non justifiés (sans identifier une “chose” précise)",
    explanation:
        "321-6 peut viser l’incohérence ressources/train de vie ou origine de biens + relations habituelles ; le recel suppose une chose provenant d’un crime/délit + connaissance.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai / Faux — Recel",
    question:
        "Vrai/Faux : le recel peut être constitué même si l’auteur d’origine est décédé ou en fuite.",
    options: ["Vrai", "Faux", "Seulement si vol"],
    answer: "Vrai",
    explanation:
        "Le cours : recel constitué même si l’auteur de l’infraction d’origine est décédé ou en fuite (la punition de l’auteur d’origine est indifférente).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai / Faux — Recel",
    question:
        "Vrai/Faux : l’absence de facture est un indice pouvant permettre de déduire la connaissance de l’origine frauduleuse.",
    options: ["Vrai", "Faux", "Ça dépend de la profession"],
    answer: "Vrai",
    explanation:
        "Le cours cite l’absence de facture parmi les indices possibles de connaissance de l’origine frauduleuse.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Recel (321-1)",
    question:
        "Un individu cache des plaques d’immatriculation volées sous la garniture d’un véhicule. Qualification la plus probable :",
    options: [
      "Recel (détention/dissimulation)",
      "Non-justification (321-6)",
      "Faux administratif (441-2)",
    ],
    answer: "Recel (détention/dissimulation)",
    explanation:
        "Jurisprudence citée : dissimulation de plaques volées → connaissance présumée de l’origine frauduleuse, recel.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Recel (321-1)",
    question:
        "Une personne utilise un véhicule volé en tant que passager puis conducteur, en sachant l’origine. Qualification :",
    options: [
      "Recel (bénéficier du produit)",
      "Vol",
      "Aucune infraction car restitution possible",
    ],
    answer: "Recel (bénéficier du produit)",
    explanation:
        "Le cours cite l’utilisation d’un véhicule volé comme recel d’usage (CA Nancy, 9 déc. 1992).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révision rapide — Non-justification",
    question: "Peine 321-6 (base) :",
    options: ["3 ans + 75 000 €", "5 ans + 150 000 €", "10 ans + 750 000 €"],
    answer: "3 ans + 75 000 €",
    explanation: "321-6 : 3 ans et 75 000 € (+ confiscation obligatoire).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révision rapide — Non-justification",
    question: "Article aggravation mineur sous autorité :",
    options: ["321-6-1 al.1", "321-6 al.1", "321-2"],
    answer: "321-6-1 al.1",
    explanation:
        "321-6-1 al.1 : infractions commises par un mineur sur lequel l’auteur a autorité.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révision rapide — Recel",
    question: "Article recel aggravé (habitude/pro/bande organisée) :",
    options: ["321-2", "321-3", "321-4"],
    answer: "321-2",
    explanation:
        "321-2 : recel aggravé (habituelle/facilités pro ou bande organisée).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révision rapide — Recel",
    question: "Peines recel simple (321-1) :",
    options: ["5 ans + 375 000 €", "3 ans + 75 000 €", "7 ans + 200 000 €"],
    answer: "5 ans + 375 000 €",
    explanation: "321-1 : 5 ans et 375 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révision rapide — Recel",
    question: "Peines recel aggravé (321-2) :",
    options: ["10 ans + 750 000 €", "7 ans + 200 000 €", "5 ans + 150 000 €"],
    answer: "10 ans + 750 000 €",
    explanation: "321-2 : 10 ans et 750 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Champ",
    question:
        "Pour retenir 321-6, il faut que la personne soit en relations habituelles avec :",
    options: [
      "Des auteurs d’infractions ≥ 5 ans OU des victimes d’une de ces infractions",
      "Uniquement des auteurs condamnés",
      "Uniquement des personnes en bande organisée",
    ],
    answer:
        "Des auteurs d’infractions ≥ 5 ans OU des victimes d’une de ces infractions",
    explanation:
        "Le texte vise les relations habituelles avec auteurs (≥5 ans, profit) ou victimes d’une des infractions.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category:
        "Non-justification de ressources (321-6) — Piège condamnation préalable",
    question:
        "Vrai/Faux : pour retenir 321-6, la personne fréquentée doit avoir été condamnée définitivement.",
    options: ["Vrai", "Faux", "Seulement si crime"],
    answer: "Faux",
    explanation:
        "Le cours indique qu’on peut retenir 321-6 sans condamnation définitive de la personne fréquentée (présomption d’innocence respectée).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Train de vie",
    question: "Le “train de vie” peut être établi par :",
    options: [
      "Des dépenses (hôtel/restaurant), achats, flux bancaires, paiements en espèces",
      "Uniquement un train de vie luxueux visible",
      "Uniquement des revenus déclarés faibles",
    ],
    answer:
        "Des dépenses (hôtel/restaurant), achats, flux bancaires, paiements en espèces",
    explanation:
        "Le cours : preuves par indices concrets (dépenses, achats, mouvements de fonds, espèces).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Valeur probante",
    question:
        "Parmi ces éléments, lequel est le PLUS pertinent pour justifier des ressources ?",
    options: [
      "Bulletins de salaire + déclaration de revenus",
      "Déclaration orale d’un ami",
      "Publication sur réseaux sociaux",
    ],
    answer: "Bulletins de salaire + déclaration de revenus",
    explanation:
        "Le cours vise des documents “indiscutables” : factures, bulletins de paye, déclaration de revenus.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Biens (piège)",
    question:
        "Vrai/Faux : 321-6 vise uniquement les biens “en espèces” (cash).",
    options: ["Vrai", "Faux", "Seulement si > 10 000 €"],
    answer: "Faux",
    explanation:
        "Le texte vise l’origine d’un bien détenu : biens mobiliers ET immobiliers.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category:
        "Non-justification de ressources (321-6) — Indices (piège concours)",
    question:
        "Quel indice est le PLUS évocateur d’une non-justification au sens 321-6 ?",
    options: [
      "Avoirs bancaires disproportionnés + mouvements de fonds + nombreux paiements en espèces",
      "Acheter un café tous les matins",
      "Posséder une carte bancaire",
    ],
    answer:
        "Avoirs bancaires disproportionnés + mouvements de fonds + nombreux paiements en espèces",
    explanation:
        "Le cours cite précisément ces éléments (Cass. crim., 6 fév. 2008) pour matérialiser l’écart ressources/train de vie.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category:
        "Non-justification de ressources (321-6) — Écart ressources/train de vie",
    question: "La non-justification “ressources” suppose :",
    options: [
      "Un patrimoine/train de vie sans rapport avec les revenus",
      "Un simple retard de déclaration",
      "Une dette fiscale uniquement",
    ],
    answer: "Un patrimoine/train de vie sans rapport avec les revenus",
    explanation:
        "Volet 1 : ressources personnelles ne correspondant pas au train de vie (écart anormal).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Origine d’un bien",
    question: "La non-justification “origine d’un bien” implique :",
    options: [
      "Une origine indéterminée du bien détenu et l’impossibilité d’en expliquer la provenance",
      "Un bien détérioré",
      "Un bien non assuré",
    ],
    answer:
        "Une origine indéterminée du bien détenu et l’impossibilité d’en expliquer la provenance",
    explanation:
        "Volet 2 : bien détenu dont l’origine ne peut être justifiée (factures, traçabilité).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Piège sur la charge",
    question:
        "Vrai/Faux : en 321-6, la charge de la preuve est toujours intégralement sur le prévenu.",
    options: ["Vrai", "Faux", "Uniquement pour les espèces"],
    answer: "Faux",
    explanation:
        "Cass. crim., 13 juin 2012 : pas de présomption générale ; l’accusation doit rapporter la preuve du délit spécifique. (Le cours évoque un renversement surtout sur l’origine du bien).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category:
        "Non-justification de ressources (321-6) — Relations habituelles (piège)",
    question: "Les relations habituelles exigent :",
    options: [
      "Une régularité (rencontres/visites/entrevues), pas forcément une cohabitation",
      "Une cohabitation obligatoire",
      "Un lien de parenté obligatoire",
    ],
    answer:
        "Une régularité (rencontres/visites/entrevues), pas forcément une cohabitation",
    explanation:
        "Le cours : relations habituelles peuvent être de simples rencontres/visites ; pas besoin de cohabiter.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Scénario",
    question:
        "Une personne a un train de vie supérieur à ses ressources, et est vue très régulièrement avec des victimes d’extorsion. Elle ne peut justifier l’origine de biens. Qualification :",
    options: [
      "Non-justification de ressources (321-6)",
      "Recel (321-1) automatiquement",
      "Aucune, car elle fréquente des victimes",
    ],
    answer: "Non-justification de ressources (321-6)",
    explanation:
        "321-6 vise aussi les relations habituelles avec la victime d’une des infractions (≥ 5 ans) + non-justification.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources — Spécifiques (nota)",
    question:
        "Parmi ces domaines, lequel possède une incrimination spécifique de non-justification ?",
    options: ["Terrorisme", "Outrage", "Tapage nocturne"],
    answer: "Terrorisme",
    explanation:
        "Nota du cours : infractions spécifiques en terrorisme (421-2-3), proxénétisme, mendicité.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources — Spécifiques (nota)",
    question:
        "Les incriminations spécifiques de non-justification concernent notamment :",
    options: [
      "Terrorisme, proxénétisme, mendicité",
      "Vol, recel, outrage",
      "Diffamation, injure, provocation",
    ],
    answer: "Terrorisme, proxénétisme, mendicité",
    explanation:
        "Le cours liste : 421-2-3 CP ; 225-6 3° CP ; 225-12-5 al.6 CP.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Recel (321-1) — Acte matériel",
    question: "Le recel peut être constitué par :",
    options: [
      "Dissimuler, détenir, transmettre, ou faire l’intermédiaire pour transmettre",
      "Simplement refuser de dénoncer",
      "Simplement mentir à un enquêteur",
    ],
    answer:
        "Dissimuler, détenir, transmettre, ou faire l’intermédiaire pour transmettre",
    explanation: "Le cours décrit ces actes matériels constitutifs du recel.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Délit continu",
    question:
        "Vrai/Faux : la détention recéleuse fait du recel un délit continu.",
    options: ["Vrai", "Faux", "Seulement en bande organisée"],
    answer: "Vrai",
    explanation:
        "Le cours : la détention implique que le recel est un délit continu.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Usage indifférent (piège)",
    question:
        "Vrai/Faux : pour la détention recéleuse, l’usage du bien est indispensable.",
    options: ["Vrai", "Faux", "Seulement si véhicule"],
    answer: "Faux",
    explanation:
        "Le cours : usage/profit indifférents ; la détention suffit si connaissance.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Intermédiaire (piège)",
    question:
        "Vrai/Faux : être “intermédiaire” suppose d’avoir la chose en main à un moment donné.",
    options: ["Vrai", "Faux", "Seulement si rémunéré"],
    answer: "Faux",
    explanation:
        "Le cours : recel par entremise ne suppose pas l’appréhension matérielle et directe de la chose.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Prix anormal",
    question: "Un achat à prix très bas peut servir à déduire :",
    options: [
      "La connaissance de l’origine frauduleuse",
      "L’absence de toute infraction",
      "Une simple contravention",
    ],
    answer: "La connaissance de l’origine frauduleuse",
    explanation:
        "Le cours : acquisition à bas prix = indice possible de connaissance de l’origine frauduleuse.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Indices (piège concours)",
    question: "Quel faisceau est le PLUS “mauvaise foi” ?",
    options: [
      "Objets de grande valeur + vendeur non pro + absence de facture + dissimulation",
      "Achat d’occasion avec facture",
      "Cadeau offert en famille avec preuve d’achat",
    ],
    answer:
        "Objets de grande valeur + vendeur non pro + absence de facture + dissimulation",
    explanation:
        "Le cours : ces circonstances variées permettent de déduire la connaissance de l’origine frauduleuse.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Connaissance de l’infraction d’origine",
    question: "Le receleur doit connaître :",
    options: [
      "L’origine criminelle/délictuelle, pas nécessairement l’article exact ni les circonstances",
      "Le jugement condamnant l’auteur d’origine",
      "Le nom de la victime",
    ],
    answer:
        "L’origine criminelle/délictuelle, pas nécessairement l’article exact ni les circonstances",
    explanation:
        "Le cours : pas besoin de connaître la qualification exacte ou les circonstances précises.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Auteur d’origine inconnu",
    question:
        "Vrai/Faux : le recel peut être constitué même si l’auteur de l’infraction d’origine demeure inconnu.",
    options: ["Vrai", "Faux", "Seulement si vol"],
    answer: "Vrai",
    explanation:
        "Le cours cite : recel constitué même si auteur inconnu (Cass. crim., 24 nov. 1964).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Bonne foi (piège)",
    question:
        "Si une personne achète de bonne foi, puis apprend après coup l’origine frauduleuse, alors :",
    options: [
      "Le recel n’est pas automatiquement constitué du seul fait de conserver",
      "Le recel est automatique dès qu’elle apprend",
      "C’est une tentative de recel",
    ],
    answer:
        "Le recel n’est pas automatiquement constitué du seul fait de conserver",
    explanation:
        "Arrêt Pelegrin : l’appréciation se fait au moment de l’acquisition ; conserver après coup n’implique pas automatiquement recel si bonne foi initiale reconnue.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Acte positif",
    question:
        "Vrai/Faux : le recel d’usage suppose un bénéfice/profit du produit de l’infraction.",
    options: ["Vrai", "Faux", "Uniquement si argent"],
    answer: "Vrai",
    explanation:
        "Recel d’usage : bénéficier, par tout moyen, du produit d’un crime/délit en connaissance de cause.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Objet (piège)",
    question:
        "Vrai/Faux : le recel ne peut porter que sur des biens “matériels”.",
    options: ["Vrai", "Faux", "Uniquement si document public"],
    answer: "Faux",
    explanation:
        "Le cours mentionne aussi des informations (ex : produit de leur exploitation) et des secrets de fabrication.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Subrogation (piège)",
    question:
        "Si un receleur reçoit des fonds frauduleux et achète un bien avec, alors le bien acheté :",
    options: [
      "Peut entrer dans le recel (subrogation dans le patrimoine)",
      "Échappe au recel car “nouveau bien”",
      "Relève uniquement de la fraude fiscale",
    ],
    answer: "Peut entrer dans le recel (subrogation dans le patrimoine)",
    explanation:
        "Le cours : le recel s’applique au produit, y compris quand les fonds servent à acheter un bien (subrogation).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Contraventions (piège)",
    question:
        "Vrai/Faux : on peut retenir le recel si la chose provient d’une contravention.",
    options: ["Vrai", "Faux", "Seulement si contravention de 5e classe"],
    answer: "Faux",
    explanation:
        "La chose doit provenir d’un crime ou d’un délit : contraventions exclues.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Illégalité de l’infraction d’origine",
    question:
        "Vrai/Faux : si les éléments constitutifs de l’infraction principale ne sont pas réunis, le recel ne peut pas être retenu.",
    options: ["Vrai", "Faux", "Seulement si bande organisée"],
    answer: "Vrai",
    explanation:
        "Le cours : si les faits ne constituent pas un crime/délit ou si l’infraction principale n’est pas légalement constituée, pas de recel.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-2) — Habitude/pro",
    question: "Le recel est aggravé (321-2) si commis :",
    options: [
      "De façon habituelle OU en utilisant les facilités de l’activité professionnelle",
      "Sans aucune répétition possible",
      "Uniquement si le bien est un véhicule",
    ],
    answer:
        "De façon habituelle OU en utilisant les facilités de l’activité professionnelle",
    explanation:
        "321-2 : aggravation si habituel ou facilités pro (et aussi bande organisée).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-4) — Peine de l’origine",
    question: "En 321-4, le receleur est puni :",
    options: [
      "Des peines attachées à l’infraction d’origine connue (et des seules circonstances aggravantes connues)",
      "Toujours de 10 ans",
      "Toujours de 5 ans",
    ],
    answer:
        "Des peines attachées à l’infraction d’origine connue (et des seules circonstances aggravantes connues)",
    explanation:
        "321-4 : si peine de l’infraction d’origine > recel, peines = celles de l’infraction d’origine (+ seulement C.A. connues).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel — QCM ultra piège (321-4)",
    question:
        "Un receleur sait que le bien provient d’un crime (peine > 10 ans). Application :",
    options: [
      "321-4 : recel puni comme l’infraction d’origine (crime) selon ce qu’il en connaît",
      "321-2 uniquement (10 ans max)",
      "321-1 uniquement (5 ans max)",
    ],
    answer:
        "321-4 : recel puni comme l’infraction d’origine (crime) selon ce qu’il en connaît",
    explanation:
        "Si la peine d’origine est supérieure, 321-4 renvoie aux peines de l’infraction d’origine (et C.A. connues).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel — Personnes morales",
    question:
        "Vrai/Faux : les personnes morales peuvent être pénalement responsables du recel.",
    options: ["Vrai", "Faux", "Seulement les associations"],
    answer: "Vrai",
    explanation:
        "Le cours : responsabilité des personnes morales prévue (321-12) + amende et peines complémentaires (131-39).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel — Peines complémentaires (PM)",
    question:
        "Pour une personne morale, des peines complémentaires possibles incluent :",
    options: [
      "Dissolution, interdiction d’activité, fermeture d’établissement",
      "Uniquement un rappel à la loi",
      "Uniquement une TIG",
    ],
    answer: "Dissolution, interdiction d’activité, fermeture d’établissement",
    explanation:
        "Le cours mentionne les peines complémentaires de 131-39 (ex : dissolution, interdiction d’exercer, fermeture).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "QCM ultra-piège — Recel vs non-justification",
    question: "Quel couple “bon texte” est correct ?",
    options: [
      "Recel : 321-1 ; Non-justification : 321-6",
      "Recel : 321-6 ; Non-justification : 321-1",
      "Recel : 441-1 ; Non-justification : 432-10",
    ],
    answer: "Recel : 321-1 ; Non-justification : 321-6",
    explanation: "Recel = 321-1 ; non-justification = 321-6.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "QCM ultra-piège — Seuil 5 ans",
    question: "Le seuil “≥ 5 ans” intervient :",
    options: [
      "En 321-6 (relations habituelles avec auteurs/victimes d’infractions ≥ 5 ans)",
      "En 321-1 (recel) obligatoirement",
      "En 441-1 (faux) uniquement",
    ],
    answer:
        "En 321-6 (relations habituelles avec auteurs/victimes d’infractions ≥ 5 ans)",
    explanation:
        "Le seuil est un critère constitutif de 321-6 (infractions liées punies ≥ 5 ans).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — V/F (321-6)",
    question: "Vrai/Faux : 321-6 exige que l’auteur d’origine soit identifié.",
    options: ["Vrai", "Faux", "Seulement si crime"],
    answer: "Faux",
    explanation:
        "Le texte vise des relations habituelles ; la condamnation/identification n’est pas une condition stricte (logique du délit spécifique).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — V/F (321-1)",
    question:
        "Vrai/Faux : le recel peut viser des prestations en nature (repas, travaux) si on en bénéficie en connaissance de cause.",
    options: ["Vrai", "Faux", "Seulement si argent"],
    answer: "Vrai",
    explanation:
        "Le cours étend le recel d’usage aux repas/services/travaux/crédits, etc.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Article/peine",
    question: "Associer correctement : recel simple →",
    options: [
      "321-1 : 5 ans + 375 000 €",
      "321-1 : 3 ans + 75 000 €",
      "321-2 : 5 ans + 375 000 €",
    ],
    answer: "321-1 : 5 ans + 375 000 €",
    explanation: "Rappel : 321-1 (5 ans, 375 000 €).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Article/peine",
    question: "Associer correctement : non-justification base →",
    options: [
      "321-6 : 3 ans + 75 000 € (+ confiscation obligatoire)",
      "321-6 : 5 ans + 150 000 €",
      "321-6-1 al.3 : 3 ans + 75 000 €",
    ],
    answer: "321-6 : 3 ans + 75 000 € (+ confiscation obligatoire)",
    explanation: "Rappel : 321-6 = 3 ans, 75 000 € + confiscation obligatoire.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Recel vs non-justification (ultra-piège)",
    question:
        "Une personne vit au-dessus de ses moyens, a des flux bancaires suspects, mais aucun objet précis d’origine frauduleuse n’est identifié. Elle est en relations habituelles avec des auteurs de trafic stupéfiants. Meilleure qualification :",
    options: [
      "Non-justification de ressources (321-6) / aggravations possibles 321-6-1",
      "Recel (321-1) nécessairement",
      "Faux (441-1)",
    ],
    answer:
        "Non-justification de ressources (321-6) / aggravations possibles 321-6-1",
    explanation:
        "Sans “chose” identifiée, on bascule plutôt sur 321-6 (train de vie/biens non justifiés + relations habituelles).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Recel (ultra-piège)",
    question:
        "Un garagiste accepte de “garder” des voitures volées destinées à être transformées, sans tirer de profit personnel, mais en sachant l’origine. Qualification :",
    options: [
      "Recel (détention/dissimulation) 321-1",
      "Aucune car pas de profit",
      "Non-justification 321-6",
    ],
    answer: "Recel (détention/dissimulation) 321-1",
    explanation:
        "Le profit n’est pas exigé : détenir/simuler en connaissance de cause suffit (le cours cite un cas similaire).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Recel par entremise (ultra-piège)",
    question:
        "Une personne ne touche jamais les biens, mais met en relation vendeur/acheteur et négocie des bons volés, en sachant l’origine. Qualification :",
    options: [
      "Recel par entremise (321-1)",
      "Aucune car pas de détention",
      "Escroquerie",
    ],
    answer: "Recel par entremise (321-1)",
    explanation:
        "Le recel par entremise ne suppose pas l’appréhension matérielle ; une négociation suffit (jurisprudence citée).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Article",
    question:
        "L’infraction de non-justification de ressources est prévue par :",
    options: ["321-6 CP", "321-1 CP", "441-6 CP"],
    answer: "321-6 CP",
    explanation:
        "L’article 321-6 al.1 définit et réprime la non-justification de ressources.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category:
        "Non-justification de ressources (321-6) — Infractions concernées",
    question:
        "Les relations habituelles visées par 321-6 doivent concerner des infractions :",
    options: [
      "Crimes ou délits punis d’au moins 5 ans d’emprisonnement",
      "Toute contravention",
      "Uniquement des crimes",
    ],
    answer: "Crimes ou délits punis d’au moins 5 ans d’emprisonnement",
    explanation:
        "321-6 : infractions criminelles ou délictuelles punies d’au moins 5 ans, procurant un profit direct/indirect.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Train de vie",
    question: "Le critère “train de vie” peut notamment être établi par :",
    options: [
      "Dépenses d’hôtel/restaurant, achats de véhicules, mouvements bancaires, paiements espèces",
      "Uniquement une déclaration sur l’honneur",
      "Uniquement un casier judiciaire",
    ],
    answer:
        "Dépenses d’hôtel/restaurant, achats de véhicules, mouvements bancaires, paiements espèces",
    explanation:
        "Le cours cite divers indices de train de vie (dépenses, véhicules, flux bancaires, espèces).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Justificatifs",
    question:
        "Pour justifier de ses ressources, la personne peut produire notamment :",
    options: [
      "Factures, bulletins de paye, déclaration de revenus",
      "Uniquement un témoignage",
      "Uniquement une attestation de voisinage",
    ],
    answer: "Factures, bulletins de paye, déclaration de revenus",
    explanation:
        "Le cours mentionne des documents “indiscutables” : factures, bulletins, déclaration de revenus.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Charge de la preuve",
    question:
        "Vrai/Faux : 321-6 crée une présomption automatique de culpabilité pénale.",
    options: ["Vrai", "Faux", "Ça dépend du train de vie"],
    answer: "Faux",
    explanation:
        "Cass. crim., 13 juin 2012 : pas de présomption de responsabilité pénale ; délit spécifique dont l’accusation doit rapporter la preuve.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category:
        "Non-justification de ressources (321-6) — Bien d’origine indéterminée",
    question: "L’infraction peut aussi viser :",
    options: [
      "L’impossibilité de justifier l’origine d’un bien détenu",
      "Uniquement l’absence de salaire déclaré",
      "Uniquement des revenus en espèces",
    ],
    answer: "L’impossibilité de justifier l’origine d’un bien détenu",
    explanation:
        "321-6 : non-justification de l’origine d’un bien détenu (biens mobiliers/immobiliers).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Renversement",
    question:
        "Concernant l’origine d’un bien détenu, le mécanisme décrit par le cours implique que :",
    options: [
      "Le prévenu doit expliquer la provenance du bien (factures, éléments de licéité)",
      "Le juge doit prouver l’acte exact d’acquisition",
      "La victime doit fournir les factures",
    ],
    answer:
        "Le prévenu doit expliquer la provenance du bien (factures, éléments de licéité)",
    explanation:
        "Le cours indique un renversement : c’est au prévenu de déterminer la provenance/licéité (factures…).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Relations habituelles",
    question: "Les “relations habituelles” peuvent se limiter à :",
    options: [
      "Rencontres, entrevues ou visites",
      "Une unique vue de loin",
      "Un message isolé sans contact",
    ],
    answer: "Rencontres, entrevues ou visites",
    explanation:
        "Le cours précise que des rencontres/entrevues/visites peuvent suffire à caractériser des relations habituelles.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Auteurs vs victimes",
    question: "321-6 vise des relations habituelles avec :",
    options: [
      "Des auteurs d’infractions ≥ 5 ans OU des victimes d’une de ces infractions",
      "Uniquement des auteurs",
      "Uniquement des complices",
    ],
    answer:
        "Des auteurs d’infractions ≥ 5 ans OU des victimes d’une de ces infractions",
    explanation:
        "Le texte vise les deux hypothèses : fréquentation d’auteurs ou de victimes d’infractions ≥ 5 ans.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Profit",
    question:
        "Pour l’hypothèse “auteurs”, il faut en outre que l’auteur fréquenté :",
    options: [
      "Bénéficie directement ou indirectement du produit de l’infraction",
      "Soit condamné définitivement",
      "Soit mineur",
    ],
    answer: "Bénéficie directement ou indirectement du produit de l’infraction",
    explanation:
        "Le texte exige un profit direct/indirect tiré de l’infraction par la personne fréquentée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category:
        "Non-justification de ressources (321-6) — Condamnation préalable",
    question:
        "Vrai/Faux : la condamnation définitive de la personne fréquentée est nécessaire.",
    options: ["Vrai", "Faux", "Uniquement en cas de crime"],
    answer: "Faux",
    explanation:
        "Le cours indique qu’on peut retenir 321-6 sans constater une condamnation définitive de la personne fréquentée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Élément moral",
    question: "L’élément moral principal exige :",
    options: [
      "La conscience de bénéficier du produit d’infractions commises par une relation habituelle",
      "L’intention de commettre l’infraction d’origine",
      "Une négligence dans la tenue des comptes",
    ],
    answer:
        "La conscience de bénéficier du produit d’infractions commises par une relation habituelle",
    explanation:
        "321-6 : conscience de bénéficier du produit d’infractions commises par la/les personnes fréquentées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Erreur de croyance",
    question:
        "Exemple donné : ne sera pas coupable la compagne d’un trafiquant si elle :",
    options: [
      "Croit être en ménage avec un dirigeant de société",
      "A reçu un cadeau une fois",
      "A un compte bancaire séparé",
    ],
    answer: "Croit être en ménage avec un dirigeant de société",
    explanation:
        "Le cours cite l’exemple : absence de conscience → pas d’infraction (Cass. crim., 25 juin 2003).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Peines",
    question: "Peines de base (321-6) :",
    options: ["3 ans + 75 000 €", "5 ans + 150 000 €", "2 ans + 30 000 €"],
    answer: "3 ans + 75 000 €",
    explanation:
        "321-6 : 3 ans d’emprisonnement et 75 000 € d’amende. Confiscation obligatoire des biens non justifiés.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Confiscation",
    question:
        "Vrai/Faux : en 321-6, la confiscation des biens saisis non justifiés est obligatoire.",
    options: ["Vrai", "Faux", "Seulement si récidive"],
    answer: "Vrai",
    explanation:
        "Le texte précise : confiscation obligatoire des biens saisis dont l’origine n’est pas justifiée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6) — Tentative/complicité",
    question: "Tentative et complicité (321-6) :",
    options: [
      "Tentative non ; complicité oui",
      "Tentative oui ; complicité non",
      "Tentative oui ; complicité oui",
    ],
    answer: "Tentative non ; complicité oui",
    explanation: "Le cours : tentative NON ; complicité OUI (121-6/121-7).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6-1) — Aggravation",
    question: "321-6-1 al.1 aggrave lorsque :",
    options: [
      "Les crimes/délits sont commis par un mineur sur lequel la personne a autorité",
      "La personne est fonctionnaire",
      "Le train de vie est “modeste”",
    ],
    answer:
        "Les crimes/délits sont commis par un mineur sur lequel la personne a autorité",
    explanation:
        "Aggravation 321-6-1 al.1 : infractions commises par un mineur sur lequel l’auteur a autorité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6-1) — Stups / armes / TEH",
    question: "321-6-1 al.2 vise notamment :",
    options: [
      "Traite des êtres humains, extorsion, association de malfaiteurs, armes/explosifs, trafic de stupéfiants (y compris relations avec usagers)",
      "Uniquement les vols simples",
      "Uniquement les contraventions d’usage de stupéfiants",
    ],
    answer:
        "Traite des êtres humains, extorsion, association de malfaiteurs, armes/explosifs, trafic de stupéfiants (y compris relations avec usagers)",
    explanation:
        "Le cours liste TEH, extorsion, association de malfaiteurs, infractions armes/explosifs et trafic de stups (incluant relations avec usagers).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources (321-6-1) — Mineurs multiples",
    question: "321-6-1 al.3 aggrave lorsque :",
    options: [
      "Il s’agit d’une infraction de l’alinéa 2 commise par un ou plusieurs mineurs",
      "La personne est en bande organisée",
      "L’auteur est mineur",
    ],
    answer:
        "Il s’agit d’une infraction de l’alinéa 2 commise par un ou plusieurs mineurs",
    explanation:
        "Aggravation 321-6-1 al.3 : infractions de l’al.2 commises par un ou plusieurs mineurs.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources — Peines aggravées",
    question: "Peine aggravée (321-6-1 al.1) :",
    options: ["5 ans + 150 000 €", "7 ans + 200 000 €", "10 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation: "321-6-1 al.1 : 5 ans d’emprisonnement et 150 000 € d’amende.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources — Peines aggravées",
    question: "Peine aggravée (321-6-1 al.2) :",
    options: ["7 ans + 200 000 €", "5 ans + 150 000 €", "3 ans + 75 000 €"],
    answer: "7 ans + 200 000 €",
    explanation: "321-6-1 al.2 : 7 ans et 200 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-justification de ressources — Peines aggravées",
    question: "Peine aggravée (321-6-1 al.3) :",
    options: ["10 ans + 300 000 €", "7 ans + 200 000 €", "5 ans + 150 000 €"],
    answer: "10 ans + 300 000 €",
    explanation: "321-6-1 al.3 : 10 ans et 300 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "QCM piège — Non-justification vs recel",
    question: "Différence clé : le recel (321-1) suppose :",
    options: [
      "Une chose provenant d’un crime/délit + connaissance de l’origine frauduleuse",
      "Un train de vie disproportionné + relations habituelles",
      "Une fausse déclaration à l’administration",
    ],
    answer:
        "Une chose provenant d’un crime/délit + connaissance de l’origine frauduleuse",
    explanation:
        "321-1 : dissimuler/détenir/transmettre ou bénéficier du produit en sachant l’origine. 321-6 : train de vie/biens non justifiés + relations habituelles.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Non-justification (321-6)",
    question:
        "Un couple a un train de vie modeste mais dispose d’avoirs bancaires disproportionnés, multiplie les mouvements et paie souvent en espèces. Qualification la plus adaptée ?",
    options: [
      "Non-justification de ressources (321-6)",
      "Recel nécessairement (321-1)",
      "Aucune infraction sans aveu",
    ],
    answer: "Non-justification de ressources (321-6)",
    explanation:
        "Exemple jurisprudentiel : même train de vie modeste, avoirs disproportionnés + mouvements + espèces → 321-6.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Non-justification (321-6)",
    question:
        "Une personne ne justifie pas l’origine de sommes sur un compte + détention d’un véhicule + construction d’une maison. Qualification ?",
    options: [
      "Non-justification de ressources (321-6)",
      "Faux administratif (441-2)",
      "Extorsion (312-1)",
    ],
    answer: "Non-justification de ressources (321-6)",
    explanation:
        "Le cours cite l’exemple de non-justification de sommes, véhicule, maison (Cass. crim., 27 avril 2000).",
    difficulty: "Difficile",
  ),

  // =========================
  // RECEL (321-1 et suivants)
  // =========================
  const QuizQuestion(
    category: "Recel (321-1) — Définition",
    question: "Le recel (321-1 CP) consiste notamment à :",
    options: [
      "Dissimuler, détenir, transmettre une chose en sachant qu’elle provient d’un crime ou d’un délit",
      "Mentir à l’administration pour obtenir un document",
      "Insulter un agent public",
    ],
    answer:
        "Dissimuler, détenir, transmettre une chose en sachant qu’elle provient d’un crime ou d’un délit",
    explanation:
        "321-1 : dissimulation/détention/transmission/intermédiaire + connaissance origine crime/délit ; et aussi bénéficier du produit par tout moyen.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Texte",
    question: "Le recel est défini et réprimé par :",
    options: ["321-1 CP", "321-6 CP", "432-11 CP"],
    answer: "321-1 CP",
    explanation: "Le recel est prévu à l’article 321-1 du Code pénal.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Actes matériels",
    question: "Les actes matériels du recel peuvent être :",
    options: [
      "Dissimuler, détenir, transmettre ou faire l’intermédiaire",
      "Seulement détenir",
      "Seulement revendre à profit",
    ],
    answer: "Dissimuler, détenir, transmettre ou faire l’intermédiaire",
    explanation:
        "321-1 vise dissimuler/détenir/transmettre + faire office d’intermédiaire.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Recel d’usage",
    question: "Constitue aussi un recel :",
    options: [
      "Bénéficier, par tout moyen, du produit d’un crime ou d’un délit",
      "Refuser de rendre un objet trouvé",
      "Être témoin d’un vol",
    ],
    answer: "Bénéficier, par tout moyen, du produit d’un crime ou d’un délit",
    explanation:
        "321-1 al.2 : recel d’usage = profiter du produit en connaissance de cause.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Délit continu",
    question:
        "Vrai/Faux : la détention recéleuse fait du recel un délit continu.",
    options: ["Vrai", "Faux", "Seulement si revente"],
    answer: "Vrai",
    explanation:
        "Le cours précise : la détention implique un délit continu ; le simple fait de détenir peut constituer le recel.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Objet",
    question: "La chose recelée doit provenir :",
    options: [
      "D’un crime ou d’un délit (pas d’une contravention)",
      "D’une contravention uniquement",
      "Uniquement d’un crime",
    ],
    answer: "D’un crime ou d’un délit (pas d’une contravention)",
    explanation:
        "Le recel suppose une infraction d’origine crime/délit ; contraventions exclues.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Infraction d’origine",
    question:
        "Vrai/Faux : il suffit d’écrire “origine frauduleuse” sans préciser l’infraction d’origine.",
    options: ["Vrai", "Faux", "Ça dépend du juge"],
    answer: "Faux",
    explanation:
        "Le cours indique que le juge doit préciser la nature de l’infraction initiale ; la simple mention d’origine frauduleuse ne suffit pas.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Auteur de l’infraction d’origine",
    question:
        "En principe, l’auteur de l’infraction d’origine peut-il être poursuivi pour recel ?",
    options: [
      "Non, l’infraction d’origine doit être commise par un tiers",
      "Oui, toujours",
      "Oui, seulement en cas de vol",
    ],
    answer: "Non, l’infraction d’origine doit être commise par un tiers",
    explanation:
        "Le cours : l’auteur principal ne peut être poursuivi pour recel ; l’infraction d’origine doit être commise par un tiers.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Complice et receleur",
    question:
        "Un complice de l’infraction d’origine peut-il aussi être poursuivi comme receleur ?",
    options: [
      "Oui, le recel est un délit distinct",
      "Non, jamais",
      "Uniquement si mineur",
    ],
    answer: "Oui, le recel est un délit distinct",
    explanation:
        "Le cours : un complice peut être poursuivi comme receleur, le recel étant distinct.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Connaissance",
    question: "L’élément moral du recel exige :",
    options: [
      "La connaissance de l’origine crime/délit de la chose",
      "La connaissance précise de la qualification exacte (ex : vol aggravé)",
      "Une simple imprudence",
    ],
    answer: "La connaissance de l’origine crime/délit de la chose",
    explanation:
        "Il n’est pas nécessaire de connaître précisément la nature/circonstances de l’infraction d’origine, seulement l’origine frauduleuse crime/délit.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Indices de mauvaise foi",
    question: "La connaissance de l’origine frauduleuse peut être déduite de :",
    options: [
      "Acquisition à bas prix, absence de facture, dissimulation, objets de valeur proposés par non-pro",
      "Le seul fait d’acheter d’occasion",
      "Le paiement par carte bancaire",
    ],
    answer:
        "Acquisition à bas prix, absence de facture, dissimulation, objets de valeur proposés par non-pro",
    explanation:
        "Le cours cite divers indices : bas prix, dissimulation, absence facture, contexte suspect.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Piège Pelegrin",
    question:
        "Vrai/Faux : conserver une chose après avoir appris son origine frauduleuse est toujours un recel.",
    options: ["Vrai", "Faux", "Uniquement si la police le demande"],
    answer: "Faux",
    explanation:
        "Le cours (arrêt Pelegrin) : pas de recel si bonne foi reconnue au moment de l’acquisition ; l’appréciation se fait au moment de recevoir/transmettre/tirer profit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Intermédiaire",
    question: "Faire office d’intermédiaire suppose :",
    options: [
      "Mettre en relation des personnes/choses pour transmettre, même par un acte isolé",
      "Exercer ce rôle à titre professionnel uniquement",
      "Avoir matériellement détenu la chose",
    ],
    answer:
        "Mettre en relation des personnes/choses pour transmettre, même par un acte isolé",
    explanation:
        "Le cours : pas besoin d’habitude/métier ; acte isolé suffit ; pas nécessaire d’avoir la chose en main.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Intermédiaire sans détention",
    question:
        "Vrai/Faux : le recel par entremise nécessite l’appréhension matérielle de la chose.",
    options: ["Vrai", "Faux", "Ça dépend de la valeur"],
    answer: "Faux",
    explanation:
        "Le recel par entremise ne suppose pas l’appréhension matérielle directe.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Recel d’usage (exemples)",
    question: "Est un exemple de recel d’usage :",
    options: [
      "Profiter du train de vie financé par un détournement commis par un proche",
      "Refuser de prêter sa voiture",
      "Acheter un objet neuf en magasin",
    ],
    answer:
        "Profiter du train de vie financé par un détournement commis par un proche",
    explanation:
        "Le cours cite le profit du train de vie (Cass. crim., 09 mai 1974) comme recel d’usage.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Objet très large",
    question: "L’objet du recel peut être :",
    options: [
      "Meubles, bijoux, argent, énergie, secrets de fabrication, photocopies violant un secret",
      "Uniquement des objets physiques volés",
      "Uniquement de l’argent liquide",
    ],
    answer:
        "Meubles, bijoux, argent, énergie, secrets de fabrication, photocopies violant un secret",
    explanation:
        "Le cours élargit l’objet : toute chose “matière à vol” et au-delà (énergie, secrets…).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Subrogation",
    question:
        "Vrai/Faux : le recel peut porter sur le “produit” de la chose via subrogation (achat/investissement).",
    options: ["Vrai", "Faux", "Uniquement si immeuble"],
    answer: "Vrai",
    explanation:
        "Le cours : recel possible quand les fonds recelés servent à acheter un bien ou investir (subrogation).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Abrogation infraction d’origine",
    question:
        "Si l’incrimination de l’infraction d’origine est abrogée, le recel :",
    options: [
      "N’est plus légalement constitué (absence d’infraction originaire)",
      "Reste punissable car “origine frauduleuse” suffit",
      "Devient automatiquement une contravention",
    ],
    answer: "N’est plus légalement constitué (absence d’infraction originaire)",
    explanation:
        "Le cours cite l’exemple de banqueroute simple abrogée : pas d’infraction originaire → pas de recel.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Auteur d’origine inconnu",
    question:
        "Vrai/Faux : le recel peut être constitué même si l’auteur de l’infraction d’origine est inconnu.",
    options: ["Vrai", "Faux", "Uniquement si vol"],
    answer: "Vrai",
    explanation:
        "Le cours : recel constitué même si l’auteur est demeuré inconnu ou si les circonstances exactes ne sont pas établies.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Relaxé/amnistie",
    question:
        "Si l’auteur de l’infraction d’origine est relaxé pour une raison objective supprimant l’infraction, le recel :",
    options: [
      "N’est pas punissable (infraction originaire disparaît juridiquement)",
      "Reste punissable quoi qu’il arrive",
      "Devient automatiquement recel aggravé",
    ],
    answer:
        "N’est pas punissable (infraction originaire disparaît juridiquement)",
    explanation:
        "Le cours : si l’infraction d’origine disparaît juridiquement (fait justificatif/amnistie réelle), le recel ne peut tenir.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Obstacles procéduraux",
    question:
        "Le receleur peut être condamné même si l’auteur de l’infraction d’origine échappe aux poursuites pour :",
    options: [
      "Prescription, non-identification, immunité familiale (raisons procédurales)",
      "Fait justificatif",
      "Abrogation du texte",
    ],
    answer:
        "Prescription, non-identification, immunité familiale (raisons procédurales)",
    explanation:
        "Le cours distingue raisons procédurales (recel possible) vs raison objective supprimant l’infraction (recel non).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-1) — Peines simples",
    question: "Peines du recel simple (321-1) :",
    options: ["5 ans + 375 000 €", "3 ans + 75 000 €", "10 ans + 750 000 €"],
    answer: "5 ans + 375 000 €",
    explanation: "321-1 : 5 ans d’emprisonnement et 375 000 € d’amende.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel (321-2) — Aggravations",
    question: "Le recel est aggravé (321-2) lorsqu’il est commis :",
    options: [
      "De façon habituelle/avec facilités professionnelles OU en bande organisée",
      "Uniquement avec violences",
      "Uniquement par un agent public",
    ],
    answer:
        "De façon habituelle/avec facilités professionnelles OU en bande organisée",
    explanation:
        "321-2 : habituelle ou avec facilités pro ; et bande organisée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recel (321-2) — Peines aggravées",
    question: "Peines du recel aggravé (321-2) :",
    options: ["10 ans + 750 000 €", "7 ans + 200 000 €", "5 ans + 500 000 €"],
    answer: "10 ans + 750 000 €",
    explanation: "321-2 : 10 ans d’emprisonnement et 750 000 € d’amende.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recel (321-3) — Amende au-delà",
    question:
        "Vrai/Faux : l’amende 321-1/321-2 peut être portée jusqu’à la moitié de la valeur des biens recelés.",
    options: ["Vrai", "Faux", "Uniquement en bande organisée"],
    answer: "Vrai",
    explanation:
        "321-3 : amendes prévues par 321-1 et 321-2 peuvent être élevées jusqu’à la moitié de la valeur des biens recelés.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (321-4) — Peines de l’infraction d’origine",
    question:
        "321-4 prévoit que si la peine de l’infraction d’origine est supérieure à celle du recel :",
    options: [
      "Le receleur encourt les peines de l’infraction d’origine (et certaines C.A. connues)",
      "Le receleur est relaxé",
      "Le receleur encourt toujours 5 ans maximum",
    ],
    answer:
        "Le receleur encourt les peines de l’infraction d’origine (et certaines C.A. connues)",
    explanation:
        "321-4 : peines attachées à l’infraction d’origine si plus sévères, et peines des seules circonstances aggravantes dont le receleur a eu connaissance.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (tentative) — Règles",
    question: "Tentative de recel :",
    options: [
      "Non punissable pour recel simple ; punissable pour recel aggravé crime",
      "Toujours punissable",
      "Jamais punissable",
    ],
    answer:
        "Non punissable pour recel simple ; punissable pour recel aggravé crime",
    explanation:
        "Le cours : tentative recel simple non prévue ; tentative de recel criminel toujours punissable.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Recel (complicité) — Règles",
    question: "Complicité en matière de recel :",
    options: ["Oui (121-7)", "Non", "Uniquement si bande organisée"],
    answer: "Oui (121-7)",
    explanation:
        "La complicité est applicable au recel conformément à l’article 121-7 (aide/assistance, provocation, instructions).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QCM piège — Recel vs non-justification",
    question:
        "Scénario : une personne a des comptes alimentés en espèces, fréquente habituellement des auteurs de délits ≥ 5 ans, mais aucun bien précis “recelé” n’est identifié. Qualification la plus adaptée :",
    options: [
      "Non-justification de ressources (321-6)",
      "Recel (321-1) nécessairement",
      "Faux (441-1)",
    ],
    answer: "Non-justification de ressources (321-6)",
    explanation:
        "321-6 permet d’inférer le lien train de vie/relations habituelles sans identifier une “chose” précise recelée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM piège — Recel d’usage",
    question:
        "Un passager monte dans une voiture qu’il sait volée. Qualification :",
    options: [
      "Recel (bénéficier par tout moyen)",
      "Vol",
      "Aucune infraction car il ne conduit pas",
    ],
    answer: "Recel (bénéficier par tout moyen)",
    explanation:
        "Le cours cite le passager d’un véhicule d’origine frauduleuse comme receleur (recel d’usage).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM piège — Intermédiaire",
    question:
        "Une personne négocie la vente de titres volés sans jamais les toucher. Qualification :",
    options: [
      "Recel par entremise",
      "Recel impossible sans détention",
      "Escroquerie uniquement",
    ],
    answer: "Recel par entremise",
    explanation:
        "Le recel par entremise ne suppose pas la détention matérielle ; intervenir dans la négociation peut suffire.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Recel (321-1)",
    question:
        "Un garagiste met à disposition un local pour stocker des objets volés, en connaissance de cause. Qualification ?",
    options: [
      "Recel (dissimulation)",
      "Non-justification (321-6)",
      "Aucune infraction si non retrouvé",
    ],
    answer: "Recel (dissimulation)",
    explanation:
        "La mise à disposition d’un local pour entreposer des objets volés est citée comme recel (dissimulation).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Recel (321-2)",
    question:
        "Un professionnel de l’occasion omet volontairement d’inscrire des bijoux volés au registre de police. Orientation la plus pertinente :",
    options: [
      "Recel aggravé (facilités professionnelles)",
      "Recel simple uniquement",
      "Aucune infraction car pas de revente",
    ],
    answer: "Recel aggravé (facilités professionnelles)",
    explanation:
        "321-2 : aggravation si recel commis en utilisant les facilités d’une activité professionnelle (indice : registre de police).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions flash — Recel",
    question: "Article recel simple :",
    options: ["321-1 CP", "321-2 CP", "321-6 CP"],
    answer: "321-1 CP",
    explanation: "Le recel simple est réprimé par 321-1 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions flash — Recel",
    question: "Article recel aggravé (habitude/pro/bande organisée) :",
    options: ["321-2 CP", "321-4 CP", "321-3 CP"],
    answer: "321-2 CP",
    explanation:
        "Les aggravations “habituelle/pro/bande organisée” relèvent de 321-2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions flash — Non-justification",
    question: "Article non-justification de ressources :",
    options: ["321-6 CP", "321-1 CP", "434-6 CP"],
    answer: "321-6 CP",
    explanation: "La non-justification de ressources est visée par 321-6 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions flash — Non-justification",
    question: "Peine 321-6-1 al.2 :",
    options: ["7 ans + 200 000 €", "10 ans + 300 000 €", "5 ans + 150 000 €"],
    answer: "7 ans + 200 000 €",
    explanation: "Aggravation al.2 : 7 ans et 200 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions flash — Non-justification",
    question: "Tentative non-justification de ressources :",
    options: ["Non", "Oui", "Uniquement al.2"],
    answer: "Non",
    explanation: "Le cours : tentative NON pour 321-6/321-6-1.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions flash — Recel",
    question: "Tentative recel simple :",
    options: ["Non", "Oui", "Seulement si bande organisée"],
    answer: "Non",
    explanation: "Tentative recel simple non prévue, donc non punissable.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions flash — Recel",
    question: "Peines recel simple :",
    options: ["5 ans + 375 000 €", "3 ans + 75 000 €", "10 ans + 1 000 000 €"],
    answer: "5 ans + 375 000 €",
    explanation: "321-1 : 5 ans et 375 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions flash — Recel",
    question: "Peines recel aggravé (321-2) :",
    options: ["10 ans + 750 000 €", "7 ans + 200 000 €", "5 ans + 500 000 €"],
    answer: "10 ans + 750 000 €",
    explanation: "321-2 : 10 ans et 750 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai / Faux — Recel",
    question:
        "Vrai/Faux : le recel peut porter sur des services (repas, distractions) payés avec des fonds détournés.",
    options: ["Vrai", "Faux", "Uniquement si argent liquide"],
    answer: "Vrai",
    explanation:
        "Le cours cite des repas/distractions financés par chèques issus d’un abus de confiance comme recel.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai / Faux — Recel",
    question:
        "Vrai/Faux : l’innocence d’un intermédiaire exclut automatiquement la responsabilité du receleur final.",
    options: ["Vrai", "Faux", "Ça dépend du prix"],
    answer: "Faux",
    explanation:
        "Le receleur est responsable s’il connaît l’origine frauduleuse, même via un intermédiaire de bonne foi.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "STAD (323-1) — Définition",
    question: "L’accès ou le maintien frauduleux dans un STAD consiste à :",
    options: [
      "Accéder ou se maintenir, frauduleusement, dans tout ou partie d’un système de traitement automatisé de données",
      "Détruire un ordinateur physiquement",
      "Publier un commentaire insultant en ligne",
    ],
    answer:
        "Accéder ou se maintenir, frauduleusement, dans tout ou partie d’un système de traitement automatisé de données",
    explanation:
        "Art. 323-1 CP : accès ou maintien frauduleux dans tout ou partie d’un STAD.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "STAD (323-1) — Texte",
    question: "L’infraction d’accès ou maintien frauduleux est prévue par :",
    options: [
      "323-1 du Code pénal",
      "323-3 du Code pénal",
      "321-1 du Code pénal",
    ],
    answer: "323-1 du Code pénal",
    explanation:
        "Le cours : l’article 323-1 définit et réprime l’accès ou maintien frauduleux.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "STAD — Notion de système (piège)",
    question: "Un STAD peut être :",
    options: [
      "Un ensemble matériel + logiciel capable de mémoriser/traiter/restituer des infos",
      "Uniquement un serveur Internet",
      "Uniquement un ordinateur portable",
    ],
    answer:
        "Un ensemble matériel + logiciel capable de mémoriser/traiter/restituer des infos",
    explanation:
        "Le cours : ensemble de biens matériels/logiciels doté de mémoire et traitement.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "STAD — Jurisprudence (radiotéléphone)",
    question:
        "Vrai/Faux : un radiotéléphone peut être considéré comme un STAD.",
    options: ["Vrai", "Faux", "Seulement s’il est connecté à Internet"],
    answer: "Vrai",
    explanation:
        "Jurisprudence : le radiotéléphone a été jugé système (CA Paris, 18 nov. 1992).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "STAD — Jurisprudence (annuaire électronique)",
    question:
        "Vrai/Faux : l’annuaire électronique de France Télécom a été jugé STAD.",
    options: ["Vrai", "Faux", "Seulement si payant"],
    answer: "Vrai",
    explanation:
        "Jurisprudence : annuaire électronique FT = système (Tr. corr. Brest, 14 mars 1995).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "STAD — Réseau carte bleue (piège concours)",
    question: "Le réseau « carte bleue » est :",
    options: [
      "Un STAD au sens de 323-1",
      "Un simple moyen de paiement sans traitement automatisé",
      "Uniquement un terminal isolé",
    ],
    answer: "Un STAD au sens de 323-1",
    explanation:
        "Jurisprudence : réseau carte bleue = STAD (TGI Paris, 25 fév. 2000).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "STAD — Terminal de paiement (TPE) (piège)",
    question: "Le terminal de paiement est considéré :",
    options: [
      "Comme partie intégrante du STAD car il vérifie l’authenticité via calcul de données",
      "Comme un objet passif, jamais partie du système",
      "Comme un document administratif",
    ],
    answer:
        "Comme partie intégrante du STAD car il vérifie l’authenticité via calcul de données",
    explanation:
        "Le cours : le TPE effectue un calcul de données, il est partie intégrante du STAD.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "STAD — Maître du système",
    question: "Le « maître du système » est :",
    options: [
      "Celui qui a acquis le droit d’exploiter le système et en dispose (modifier/supprimer/autoriser l’accès)",
      "Uniquement le développeur informatique",
      "Toujours l’État",
    ],
    answer:
        "Celui qui a acquis le droit d’exploiter le système et en dispose (modifier/supprimer/autoriser l’accès)",
    explanation:
        "Le cours : pas forcément le concepteur ; c’est celui qui exploite et décide.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "STAD — Condition centrale",
    question: "Les délits informatiques supposent :",
    options: [
      "Le non-respect de la volonté du maître du système",
      "Un dommage matériel obligatoire",
      "Un piratage par Internet uniquement",
    ],
    answer: "Le non-respect de la volonté du maître du système",
    explanation:
        "Le cours : l’incrimination repose sur la violation de la volonté du maître du système.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 323-1 : ACCÈS FRAUDULEUX
  // =========================================================
  const QuizQuestion(
    category: "Accès frauduleux (323-1) — Sans droit",
    question: "L’accès devient pénalement répréhensible quand :",
    options: [
      "La personne n’a pas le droit d’accéder OU n’a pas le droit d’accéder de cette manière",
      "Le système est protégé par mot de passe uniquement",
      "La personne est mineure",
    ],
    answer:
        "La personne n’a pas le droit d’accéder OU n’a pas le droit d’accéder de cette manière",
    explanation:
        "Le cours : sans droit = pas d’autorisation ou dépassement du mode d’accès autorisé.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Accès frauduleux (323-1) — Définition technique",
    question: "L’accès peut être présenté comme :",
    options: [
      "L’établissement d’une communication avec le système",
      "La destruction des données",
      "La création d’un virus",
    ],
    answer: "L’établissement d’une communication avec le système",
    explanation:
        "Le cours : accès = établir une communication, tous modes de pénétration irréguliers.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Accès frauduleux (323-1) — Dépassement d’autorisation",
    question: "Est un accès frauduleux :",
    options: [
      "Accéder à une zone non autorisée alors qu’on est habilité pour une autre partie du système",
      "Se connecter uniquement à son espace autorisé",
      "Ouvrir un fichier public",
    ],
    answer:
        "Accéder à une zone non autorisée alors qu’on est habilité pour une autre partie du système",
    explanation:
        "Le texte vise « tout ou partie » : habilité pour une partie ≠ habilité pour tout.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Accès frauduleux (323-1) — Piège protection",
    question:
        "Vrai/Faux : il faut un dispositif de protection (mot de passe) pour que l’accès frauduleux existe.",
    options: ["Vrai", "Faux", "Seulement si Internet"],
    answer: "Faux",
    explanation:
        "CA Paris 05/04/1994 : pas nécessaire que l’accès soit limité par un dispositif de protection.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Accès frauduleux (323-1) — Code d’essai (jurisprudence)",
    question:
        "Vrai/Faux : utiliser pendant plus de 2 ans un code remis pour une période d’essai peut constituer 323-1.",
    options: ["Vrai", "Faux", "Seulement si vol du code"],
    answer: "Vrai",
    explanation:
        "Cass. crim., 03 oct. 2007 : usage prolongé d’un code d’essai = accès sans droit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Accès frauduleux (323-1) — Cheval de Troie",
    question:
        "L’insertion d’un « cheval de Troie » dans un système est un exemple de :",
    options: [
      "Mode de pénétration irrégulier pouvant caractériser un accès frauduleux",
      "Simple maladresse non pénale",
      "Délivrance indue de document administratif",
    ],
    answer:
        "Mode de pénétration irrégulier pouvant caractériser un accès frauduleux",
    explanation:
        "Le cours cite l’insertion d’un cheval de Troie (Tr. corr. Limoges, 14 mars 1994).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Accès frauduleux (323-1) — Procédure imposée",
    question: "L’absence de droit peut résulter :",
    options: [
      "Du non-respect d’une procédure imposée par le maître (code, paiement, etc.)",
      "Du fait que la personne soit majeure",
      "Du fait que le système soit en France",
    ],
    answer:
        "Du non-respect d’une procédure imposée par le maître (code, paiement, etc.)",
    explanation:
        "Le cours : accès sans droit dès lors que le maître restreint et impose une procédure.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Accès frauduleux (323-1) — Ancien salarié (piège)",
    question:
        "Un ancien salarié utilise après son départ des codes d’accès toujours valables pour accéder aux bases internes :",
    options: [
      "Accès frauduleux (323-1)",
      "Accès licite car il connaissait les codes",
      "Simple faute civile",
    ],
    answer: "Accès frauduleux (323-1)",
    explanation:
        "Jurisprudence : ex-salarié AFP utilisant des codes après départ = accès sans droit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Accès frauduleux (323-1) — Téléphonie (piège concours)",
    question:
        "Un technicien crée un numéro d’appel réservé à l’installateur pour pénétrer dans un standard téléphonique et obtenir des communications illimitées :",
    options: ["Accès frauduleux (323-1)", "Recel (321-1)", "Outrage (433-5)"],
    answer: "Accès frauduleux (323-1)",
    explanation:
        "Le cours cite une décision sur le standard téléphonique (CA Paris, 19 juin 2001).",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 323-1 : MAINTIEN FRAUDULEUX
  // =========================================================
  const QuizQuestion(
    category: "Maintien frauduleux (323-1) — Définition",
    question: "Le maintien frauduleux vise notamment :",
    options: [
      "Un accès initial par hasard/erreur ou régulier, suivi d’un maintien non autorisé",
      "Uniquement l’intrusion par force",
      "Uniquement la suppression de données",
    ],
    answer:
        "Un accès initial par hasard/erreur ou régulier, suivi d’un maintien non autorisé",
    explanation:
        "Le cours : maintien utile quand accès initial peut être accidentel ou régulier puis dépassement.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Maintien frauduleux (323-1) — Inoffensif",
    question:
        "Vrai/Faux : un maintien « inoffensif » (simple promenade) est incriminable.",
    options: ["Vrai", "Faux", "Seulement si données modifiées"],
    answer: "Vrai",
    explanation:
        "Le cours : maintien inoffensif ou actif = incriminable si sans droit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Maintien frauduleux (323-1) — Délit continu",
    question: "Le maintien est :",
    options: [
      "Un délit continu (prescription à partir de la fin du maintien)",
      "Un délit instantané (prescription dès l’accès)",
      "Une contravention",
    ],
    answer: "Un délit continu (prescription à partir de la fin du maintien)",
    explanation:
        "Le cours : maintien = délit continu, prescription court quand le maintien cesse.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Maintien frauduleux (323-1) — Minitel (jurisprudence)",
    question:
        "L’usage abusif à des fins ludiques d’un minitel mis à disposition pour le service peut relever :",
    options: ["Du maintien frauduleux (323-1)", "Du vol", "De la concussion"],
    answer: "Du maintien frauduleux (323-1)",
    explanation:
        "Jurisprudence : usage abusif du minitel = maintien (CA Paris, 15 déc. 1999).",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 323-1 : ÉLÉMENT MORAL
  // =========================================================
  const QuizQuestion(
    category: "STAD (323-1) — Élément moral",
    question: "L’élément moral exige :",
    options: [
      "La conscience d’accéder ou de se maintenir sans droit contre le gré du maître",
      "Un profit obligatoire",
      "Une intention de détruire le système",
    ],
    answer:
        "La conscience d’accéder ou de se maintenir sans droit contre le gré du maître",
    explanation:
        "Le cours : conscience d’être contre la volonté du maître (CA Paris, 15 déc. 1999).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "STAD (323-1) — Accès par erreur (piège)",
    question:
        "Vrai/Faux : un accès purement par erreur (sans intention) n’est pas sanctionné.",
    options: ["Vrai", "Faux", "Toujours sanctionné"],
    answer: "Vrai",
    explanation:
        "Le cours : accès par erreur, possible si système non protégé, n’est pas pénalement sanctionné.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "STAD (323-1) — Compétences du prévenu",
    question: "La vraisemblance de l’erreur est appréciée notamment selon :",
    options: [
      "Les compétences informatiques du prévenu",
      "La taille de l’entreprise",
      "Le jour de la semaine",
    ],
    answer: "Les compétences informatiques du prévenu",
    explanation:
        "Le cours : juges apprécient l’erreur/intention selon compétences informatiques.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "STAD (323-1) — Mobile indifférent",
    question:
        "Vrai/Faux : agir “par jeu” ou “pour prouver une faille” peut quand même être puni.",
    options: ["Vrai", "Faux", "Jamais si but éthique"],
    answer: "Vrai",
    explanation:
        "Le cours : mobile indifférent (jeu, prouesse, démonstration de faiblesse).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "STAD (323-1) — “rendre service” (jurisprudence)",
    question:
        "Un informaticien accède pour dénoncer la mauvaise protection des données :",
    options: [
      "Peut quand même tomber sous 323-1 (mobile indifférent)",
      "Est automatiquement couvert par un motif légitime",
      "Ne peut jamais être poursuivi",
    ],
    answer: "Peut quand même tomber sous 323-1 (mobile indifférent)",
    explanation:
        "Le cours : mobile indifférent ; exemple TGI Paris 13 fév. 2002.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 323-1 : CIRCONSTANCES AGGRAVANTES + PEINES
  // =========================================================
  const QuizQuestion(
    category: "STAD (323-1) — Peines simples",
    question: "Peines de base (323-1 al.1) :",
    options: ["3 ans + 100 000 €", "2 ans + 30 000 €", "5 ans + 150 000 €"],
    answer: "3 ans + 100 000 €",
    explanation:
        "Tableau : 323-1 al.1 = 3 ans d’emprisonnement + 100 000 € d’amende.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "STAD (323-1) — Aggravation al.2",
    question: "323-1 al.2 aggrave quand il résulte :",
    options: [
      "Suppression/modification de données OU altération du fonctionnement du système",
      "Simple curiosité sans conséquence",
      "Un conflit verbal avec l’administrateur",
    ],
    answer:
        "Suppression/modification de données OU altération du fonctionnement du système",
    explanation:
        "Al.2 : suppression/modification données ou altération du fonctionnement.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "STAD (323-1) — Peines al.2",
    question: "Peines 323-1 al.2 :",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "7 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation:
        "Tableau : al.2 = 5 ans d’emprisonnement + 150 000 € d’amende.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "STAD (323-1) — Aggravation al.3 (État)",
    question: "323-1 al.3 vise :",
    options: [
      "Un STAD à caractère personnel mis en œuvre par l’État",
      "Tout système privé",
      "Une messagerie instantanée",
    ],
    answer: "Un STAD à caractère personnel mis en œuvre par l’État",
    explanation:
        "Le cours : aggravation quand visé = STAD à caractère personnel mis en œuvre par l’État.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "STAD (323-1) — Peines al.3",
    question: "Peines 323-1 al.3 :",
    options: ["7 ans + 300 000 €", "5 ans + 150 000 €", "10 ans + 300 000 €"],
    answer: "7 ans + 300 000 €",
    explanation:
        "Tableau : al.3 = 7 ans d’emprisonnement + 300 000 € d’amende.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "STAD — Bande organisée (323-4-1)",
    question: "Lorsque l’infraction est commise en bande organisée :",
    options: [
      "323-4-1 : 10 ans + 300 000 €",
      "323-1 al.1 : 3 ans + 100 000 €",
      "Aucune aggravation prévue",
    ],
    answer: "323-4-1 : 10 ans + 300 000 €",
    explanation:
        "Tableau : bande organisée (323-4-1) = 10 ans d’emprisonnement + 300 000 € d’amende.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "STAD — Risque mort / obstacle aux secours (323-4-2)",
    question: "323-4-2 s’applique si l’infraction :",
    options: [
      "Expose autrui à un risque immédiat de mort/blessures graves OU fait obstacle aux secours",
      "Cause uniquement un dommage financier",
      "N’implique que des insultes en ligne",
    ],
    answer:
        "Expose autrui à un risque immédiat de mort/blessures graves OU fait obstacle aux secours",
    explanation:
        "Le cours : aggravation spéciale sécurité des personnes / secours.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // TENTATIVE / COMPLICITÉ (323-1)
  // =========================================================
  const QuizQuestion(
    category: "STAD (323-1) — Tentative",
    question: "La tentative d’accès/maintien frauduleux est :",
    options: [
      "Punissable (323-7 CP)",
      "Non punissable",
      "Punissable seulement si bande organisée",
    ],
    answer: "Punissable (323-7 CP)",
    explanation:
        "Le cours : tentative spécialement prévue par 323-7 (commencement d’exécution + échec indépendant).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "STAD (323-1) — Conditions de la tentative",
    question: "Pour la tentative (323-7), il faut :",
    options: [
      "Commencement d’exécution + non aboutissement par circonstances indépendantes de la volonté",
      "Uniquement une intention",
      "Uniquement une préparation (discussion)",
    ],
    answer:
        "Commencement d’exécution + non aboutissement par circonstances indépendantes de la volonté",
    explanation: "Règle générale rappelée par le cours + 323-7.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "STAD (323-1) — Complicité",
    question: "La complicité en 323-1 est :",
    options: ["Oui (121-7)", "Non", "Seulement si mineur"],
    answer: "Oui (121-7)",
    explanation:
        "Le cours : complicité applicable (aide/assistance, provocation, instructions).",
    difficulty: "Facile",
  ),

  // =========================================================
  // 323-3 : INTRODUCTION / EXTRACTION / DÉTENTION / REPRODUCTION / TRANSMISSION / SUPPRESSION / MODIFICATION
  // =========================================================
  const QuizQuestion(
    category: "Données (323-3) — Texte",
    question:
        "L’introduction/suppression/modification frauduleuse de données est prévue par :",
    options: [
      "323-3 du Code pénal",
      "323-1 du Code pénal",
      "323-4 du Code pénal",
    ],
    answer: "323-3 du Code pénal",
    explanation:
        "Le cours : 323-3 définit et réprime les actions frauduleuses sur les données.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Données (323-3) — Définition globale",
    question: "323-3 réprime notamment :",
    options: [
      "Introduire, extraire, détenir, reproduire, transmettre, supprimer ou modifier frauduleusement des données",
      "Uniquement accéder au système",
      "Uniquement vendre un virus",
    ],
    answer:
        "Introduire, extraire, détenir, reproduire, transmettre, supprimer ou modifier frauduleusement des données",
    explanation: "Liste complète de l’article 323-3 dans le cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Données (323-3) — Système en cours (piège)",
    question:
        "Vrai/Faux : 323-3 peut s’appliquer même si le système est en cours d’élaboration.",
    options: ["Vrai", "Faux", "Seulement si système finalisé"],
    answer: "Vrai",
    explanation:
        "Le cours : peu importe que le système soit finalisé ou en cours (Cass. crim., 05 janv. 1994).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Données (323-3) — Accès licite ou non (piège)",
    question:
        "Vrai/Faux : l’auteur doit forcément avoir un accès illicite au système pour tomber sous 323-3.",
    options: ["Vrai", "Faux", "Seulement si suppression"],
    answer: "Faux",
    explanation:
        "Le cours : l’auteur peut avoir eu un accès licite ou non ; l’action frauduleuse sur les données suffit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Données (323-3) — Perturbation",
    question:
        "Vrai/Faux : il faut une perturbation apparente du fonctionnement pour 323-3.",
    options: ["Vrai", "Faux", "Seulement si transmission"],
    answer: "Faux",
    explanation:
        "Le cours : peu importe l’absence de perturbation apparente ou immédiate.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Données (323-3) — Données hors système (piège)",
    question:
        "Manipuler des données sur une clé USB (hors du système) relève de 323-3 :",
    options: [
      "Non, tant que ce n’est pas réintroduit dans le système",
      "Oui systématiquement",
      "Oui uniquement si données personnelles",
    ],
    answer: "Non, tant que ce n’est pas réintroduit dans le système",
    explanation:
        "Le cours : action sur données sorties du système ≠ 323-3, sauf réintroduction.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Données (323-3) — “Sniffing”",
    question: "L’introduction d’un logiciel espion (sniffing) relève :",
    options: [
      "De l’introduction frauduleuse de données (323-3)",
      "Uniquement de l’accès (323-1)",
      "D’une contravention",
    ],
    answer: "De l’introduction frauduleuse de données (323-3)",
    explanation:
        "Le cours : introduction d’un logiciel espion entre dans le champ (323-3).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Données (323-3) — Extraction (piège vol)",
    question: "L’extraction de données est réprimée car :",
    options: [
      "On protège les données même si elles ne sont pas “soustraites” (copie sans privation)",
      "C’est toujours un vol au sens classique",
      "Ça ne peut jamais être puni",
    ],
    answer:
        "On protège les données même si elles ne sont pas “soustraites” (copie sans privation)",
    explanation:
        "Le cours : vol difficile car pas de soustraction ; 323-3 permet de réprimer la copie.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Données (323-3) — Détention",
    question: "La détention de données (323-3) peut s’apparenter à :",
    options: [
      "Un recel de données extraites/reproduites/transmises frauduleusement",
      "Une simple curiosité sans portée",
      "Une exonération fiscale",
    ],
    answer:
        "Un recel de données extraites/reproduites/transmises frauduleusement",
    explanation:
        "Le cours : la détention peut s’apparenter à un recel de données.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Données (323-3) — Suppression",
    question: "Supprimer des données peut consister à :",
    options: [
      "Effacer/écraser OU déplacer hors du système ou dans une zone réservée",
      "Uniquement brûler un disque dur",
      "Uniquement renommer un fichier",
    ],
    answer:
        "Effacer/écraser OU déplacer hors du système ou dans une zone réservée",
    explanation:
        "Le cours : suppression = atteinte à l’intégrité, ou déplacement hors/zone réservée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Données (323-3) — Modification",
    question: "Modifier des données signifie :",
    options: [
      "Modifier l’information portée par les données",
      "Changer la couleur du clavier",
      "Changer l’écran d’ordinateur",
    ],
    answer: "Modifier l’information portée par les données",
    explanation:
        "Le cours : modification = modification de l’information portée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Données (323-3) — Élément moral",
    question: "L’élément moral de 323-3 repose sur :",
    options: [
      "La violation délibérée d’un interdit (savoir que ce n’est pas autorisé et vouloir le résultat)",
      "Un dommage obligatoire",
      "Un mobile de profit obligatoire",
    ],
    answer:
        "La violation délibérée d’un interdit (savoir que ce n’est pas autorisé et vouloir le résultat)",
    explanation: "Le cours : conscience + volonté, violation délibérée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Données (323-3) — Peines simples",
    question: "Peines de base de 323-3 :",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "7 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation:
        "Tableau : 323-3 = 5 ans d’emprisonnement + 150 000 € d’amende.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Données (323-3) — Aggravation (État)",
    question: "323-3 al.2 aggrave lorsque :",
    options: [
      "Infraction contre un STAD à caractère personnel mis en œuvre par l’État",
      "Données non personnelles",
      "Le prévenu est salarié",
    ],
    answer:
        "Infraction contre un STAD à caractère personnel mis en œuvre par l’État",
    explanation:
        "Le cours : aggravation spéciale État pour STAD à caractère personnel.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Données (323-3) — Bande organisée",
    question: "Bande organisée (323-4-1) sur 323-3 :",
    options: ["7 ans + 300 000 €", "10 ans + 300 000 €", "5 ans + 150 000 €"],
    answer: "7 ans + 300 000 €",
    explanation:
        "Tableau 323-3 : aggravation bande organisée = 7 ans + 300 000 €.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Données (323-3) — Risque mort (323-4-2)",
    question:
        "Si l’infraction expose autrui à un risque immédiat de mort (323-4-2) :",
    options: ["10 ans + 300 000 €", "7 ans + 300 000 €", "5 ans + 150 000 €"],
    answer: "10 ans + 300 000 €",
    explanation:
        "Tableau : 323-4-2 = 10 ans d’emprisonnement + 300 000 € d’amende.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Données (323-3) — Tentative",
    question: "Tentative pour 323-3 :",
    options: ["Oui (323-7)", "Non", "Seulement si l’auteur est professionnel"],
    answer: "Oui (323-7)",
    explanation:
        "Le cours : tentative spécialement prévue et réprimée par 323-7.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Données (323-3) — Complicité",
    question: "Complicité pour 323-3 :",
    options: ["Oui (121-7)", "Non", "Seulement en bande organisée"],
    answer: "Oui (121-7)",
    explanation:
        "Le cours : complicité applicable (aide/assistance, provocation, instructions).",
    difficulty: "Facile",
  ),

  // =========================================================
  // 323-3-1 : OUTILS / PROGRAMMES / DONNÉES ADAPTÉS (SANS MOTIF LÉGITIME)
  // =========================================================
  const QuizQuestion(
    category: "Outils hacking (323-3-1) — Texte",
    question:
        "Le fait d’importer/détenir/offrir/mettre à disposition des outils adaptés est prévu par :",
    options: [
      "323-3-1 du Code pénal",
      "323-4 du Code pénal",
      "323-1 du Code pénal",
    ],
    answer: "323-3-1 du Code pénal",
    explanation:
        "Le cours : 323-3-1 définit et réprime la fourniture de moyens adaptés.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Outils hacking (323-3-1) — Définition",
    question: "323-3-1 vise :",
    options: [
      "Sans motif légitime, importer/détenir/offrir/céder/mettre à disposition un outil/programme/données conçus pour commettre 323-1 à 323-3",
      "Uniquement pirater un compte",
      "Uniquement vendre un ordinateur",
    ],
    answer:
        "Sans motif légitime, importer/détenir/offrir/céder/mettre à disposition un outil/programme/données conçus pour commettre 323-1 à 323-3",
    explanation:
        "Le texte vise la fourniture de moyens adaptés, sans motif légitime.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Outils hacking (323-3-1) — Actes visés",
    question: "Parmi ces actes, lequel est visé par 323-3-1 ?",
    options: [
      "Mise à disposition d’un programme adapté",
      "Refus de donner son mot de passe à la police",
      "Faire une blague sur un forum",
    ],
    answer: "Mise à disposition d’un programme adapté",
    explanation:
        "323-3-1 vise importation, détention, offre, cession, mise à disposition.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Outils hacking (323-3-1) — Motif légitime (piège)",
    question: "Un motif légitime peut être :",
    options: [
      "Recherche / sécurité informatique",
      "Envie de tester “pour rigoler”",
      "Vengeance personnelle",
    ],
    answer: "Recherche / sécurité informatique",
    explanation:
        "Le cours cite recherche scientifique/technique et sécurisation des réseaux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Outils hacking (323-3-1) — Appréciation",
    question: "La légitimité du motif est appréciée :",
    options: [
      "Par les magistrats au cas par cas",
      "Uniquement par l’entreprise victime",
      "Uniquement par l’auteur",
    ],
    answer: "Par les magistrats au cas par cas",
    explanation:
        "Le cours : notion imprécise, appréciation par les magistrats.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Outils hacking (323-3-1) — Intention de nuire (piège)",
    question:
        "Vrai/Faux : 323-3-1 exige forcément la volonté directe de nuire.",
    options: ["Vrai", "Faux", "Seulement si virus"],
    answer: "Faux",
    explanation:
        "Le cours : pas forcément volonté directe de nuire ; simple détention peut suffire sans intention de diffusion.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Outils hacking (323-3-1) — Virus",
    question: "Le texte permet de sanctionner :",
    options: [
      "La simple détention/mise à disposition d’un virus sans qu’il ait été introduit",
      "Uniquement le virus déjà diffusé",
      "Uniquement l’accès frauduleux",
    ],
    answer:
        "La simple détention/mise à disposition d’un virus sans qu’il ait été introduit",
    explanation:
        "Le cours : incrimination utile même sans commission révélée des atteintes.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Outils hacking (323-3-1) — Si infraction commise",
    question:
        "Si l’outil est utilisé et l’infraction 323-1 à 323-3 est réalisée, le détenteur peut être poursuivi :",
    options: [
      "Comme complice de l’infraction réalisée",
      "Uniquement pour 323-3-1",
      "Jamais",
    ],
    answer: "Comme complice de l’infraction réalisée",
    explanation:
        "Le cours : sinon, poursuite en complicité si l’infraction est réalisée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Outils hacking (323-3-1) — Tentative",
    question: "Tentative pour 323-3-1 :",
    options: ["Oui (323-7)", "Non", "Seulement si bande organisée"],
    answer: "Oui (323-7)",
    explanation:
        "Le cours : tentative spécialement prévue et réprimée par 323-7.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Outils hacking (323-3-1) — Peines (base alignée)",
    question: "Peines de base attendues (mécanisme répressif) :",
    options: [
      "Peines prévues pour l’infraction elle-même ou la plus sévèrement réprimée",
      "Toujours 1 an + 15 000 €",
      "Contravention",
    ],
    answer:
        "Peines prévues pour l’infraction elle-même ou la plus sévèrement réprimée",
    explanation:
        "Le cours : mécanisme identique (peines de l’infraction elle-même / plus sévère).",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 323-4 : ASSOCIATION DE MALFAITEURS EN INFORMATIQUE
  // =========================================================
  const QuizQuestion(
    category: "Association hackers (323-4) — Texte",
    question: "L’association de malfaiteurs en informatique est prévue par :",
    options: [
      "323-4 du Code pénal",
      "450-1 du Code pénal",
      "323-1 du Code pénal",
    ],
    answer: "323-4 du Code pénal",
    explanation:
        "Le cours : 323-4 définit et réprime l’association de malfaiteurs en informatique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Association hackers (323-4) — Définition",
    question: "323-4 réprime :",
    options: [
      "Participation à un groupement/entente en vue de préparer (faits matériels) des infractions 323-1 à 323-3-1",
      "Simple utilisation d’un ordinateur",
      "Insulte sur un réseau social",
    ],
    answer:
        "Participation à un groupement/entente en vue de préparer (faits matériels) des infractions 323-1 à 323-3-1",
    explanation:
        "Le texte : groupement/entente + préparation caractérisée par faits matériels + infractions ciblées.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Association hackers (323-4) — Nombre de personnes (piège)",
    question: "Vrai/Faux : une entente à 2 personnes peut suffire.",
    options: ["Vrai", "Faux", "Minimum 3 personnes"],
    answer: "Vrai",
    explanation:
        "Le cours : entente retenue pour deux personnes (Tr. corr. Limoges, 14 mars 1994).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Association hackers (323-4) — But initial",
    question:
        "Vrai/Faux : le groupement doit avoir été créé dès l’origine pour pirater.",
    options: ["Vrai", "Faux", "Seulement si association déclarée"],
    answer: "Faux",
    explanation:
        "Le cours : pas nécessaire ; une association peut dériver vers délinquance, seuls participants conscients sont visés.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Association hackers (323-4) — Faits matériels (piège)",
    question: "La préparation doit être caractérisée par :",
    options: [
      "Un ou plusieurs faits matériels (ex: échange de codes, méthodes pour casser un code)",
      "Une simple intention interne sans acte",
      "Un seul message “on va hacker” sans autre élément",
    ],
    answer:
        "Un ou plusieurs faits matériels (ex: échange de codes, méthodes pour casser un code)",
    explanation:
        "Le cours : échanges d’infos, communication de codes, moyens pour casser un code, etc.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Association hackers (323-4) — Infractions visées (piège)",
    question:
        "Parmi ces infractions, laquelle est incluse dans le champ 323-4 ?",
    options: [
      "Accès/maintien frauduleux (323-1)",
      "Outrage (433-5)",
      "Recel (321-1)",
    ],
    answer: "Accès/maintien frauduleux (323-1)",
    explanation: "Le cours : infractions visées = 323-1 à 323-3-1.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Association hackers (323-4) — Élément moral",
    question: "L’élément moral exige :",
    options: [
      "Participation volontaire + conscience de l’objet délictueux du groupement/entente",
      "Un profit obligatoire",
      "Une condamnation préalable des autres membres",
    ],
    answer:
        "Participation volontaire + conscience de l’objet délictueux du groupement/entente",
    explanation:
        "Le cours : participation volontaire et connaissance que des infractions se préparent.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category:
        "Association hackers (323-4) — Connaissance totale (piège concours)",
    question:
        "Vrai/Faux : chaque membre doit connaître toutes les activités des autres.",
    options: ["Vrai", "Faux", "Seulement le chef"],
    answer: "Faux",
    explanation:
        "Jurisprudence : pas nécessaire que chaque membre soit au courant de tout (CA Aix, 02 juin 1993).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Association hackers (323-4) — Répression (mécanisme)",
    question: "La peine de 323-4 correspond :",
    options: [
      "Aux peines prévues pour l’infraction elle-même ou la plus sévèrement réprimée",
      "Toujours 3 ans + 100 000 €",
      "Toujours 10 ans + 300 000 €",
    ],
    answer:
        "Aux peines prévues pour l’infraction elle-même ou la plus sévèrement réprimée",
    explanation:
        "Le cours : mécanisme répressif = peine de l’infraction / plus sévère (pluralité).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Association hackers (323-4) — Tentative",
    question: "Tentative pour 323-4 :",
    options: ["Non", "Oui (323-7)", "Oui mais seulement si mineur"],
    answer: "Non",
    explanation: "Le tableau : TENTATIVE : NON pour 323-4.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Association hackers (323-4) — Complicité",
    question: "Complicité pour 323-4 :",
    options: ["Oui (121-7)", "Non", "Seulement en bande organisée"],
    answer: "Oui (121-7)",
    explanation: "Le tableau : COMPLICITÉ : OUI.",
    difficulty: "Facile",
  ),

  // =========================================================
  // QCM ULTRA-PIÈGES CONCOURS (mix 323-1 / 323-3 / 323-3-1 / 323-4)
  // =========================================================
  const QuizQuestion(
    category: "QCM ultra-piège — Accès vs Données",
    question:
        "Une personne a un accès autorisé au logiciel, mais modifie frauduleusement des écritures comptables enregistrées définitivement :",
    options: [
      "323-3 (modification frauduleuse de données) même si accès licite",
      "323-1 uniquement",
      "Aucune infraction si elle avait le mot de passe",
    ],
    answer: "323-3 (modification frauduleuse de données) même si accès licite",
    explanation:
        "Le cours : accès licite possible ; la modification frauduleuse de données suffit (Cass. crim., 08 déc. 1999).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM ultra-piège — Promenade",
    question:
        "Un étudiant se balade dans un système non protégé qu’il n’avait pas le droit d’utiliser, sans rien modifier :",
    options: [
      "323-1 (maintien inoffensif) si conscience d’être sans droit",
      "Pas d’infraction car pas de dommage",
      "Uniquement 323-3",
    ],
    answer: "323-1 (maintien inoffensif) si conscience d’être sans droit",
    explanation:
        "Le cours : maintien inoffensif = incriminable ; l’élément moral = conscience.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM ultra-piège — Mot de passe non requis",
    question:
        "Le système est ouvert sans mot de passe. Un individu y accède malgré l’interdiction affichée. Infraction possible :",
    options: [
      "Oui, 323-1 (pas besoin de protection technique)",
      "Non, car pas de protection",
      "Seulement une contravention",
    ],
    answer: "Oui, 323-1 (pas besoin de protection technique)",
    explanation:
        "CA Paris 05/04/1994 : pas nécessaire de dispositif de protection.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM ultra-piège — Outil + motif légitime",
    question:
        "Un chercheur conserve un programme conçu pour tester la robustesse d’un système dans un cadre de sécurité informatique :",
    options: [
      "323-3-1 peut être écarté si motif légitime (sécurité/recherche)",
      "323-3-1 s’applique toujours",
      "323-4 s’applique automatiquement",
    ],
    answer: "323-3-1 peut être écarté si motif légitime (sécurité/recherche)",
    explanation:
        "Le cours : absence de motif légitime est une condition ; sécurité/recherche peuvent être légitimes.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM ultra-piège — Entente",
    question:
        "Deux personnes échangent des codes et méthodes pour casser un accès afin de préparer des intrusions 323-1 :",
    options: [
      "323-4 (association de malfaiteurs en informatique)",
      "323-1 uniquement",
      "Aucune infraction tant que pas d’accès",
    ],
    answer: "323-4 (association de malfaiteurs en informatique)",
    explanation:
        "Le cours : groupement/entente + faits matériels préparatoires = 323-4, même à deux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Article",
    question:
        "L’accès ou le maintien frauduleux dans un STAD est réprimé par :",
    options: ["323-1 CP", "323-3 CP", "323-4 CP"],
    answer: "323-1 CP",
    explanation:
        "323-1 : accès ou maintien frauduleux dans tout ou partie d’un STAD.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Article",
    question:
        "L’introduction / extraction / suppression / modification frauduleuse de données est réprimée par :",
    options: ["323-3 CP", "323-1 CP", "323-3-1 CP"],
    answer: "323-3 CP",
    explanation:
        "323-3 : actions frauduleuses portant sur les données contenues dans le système.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Article",
    question:
        "La détention/offre/cession/mise à disposition d’outils adaptés au piratage (sans motif légitime) est réprimée par :",
    options: ["323-3-1 CP", "323-4 CP", "323-1 CP"],
    answer: "323-3-1 CP",
    explanation:
        "323-3-1 : moyens conçus/spécialement adaptés pour commettre 323-1 à 323-3.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Article",
    question:
        "L’association de malfaiteurs en informatique (entente/groupement) est réprimée par :",
    options: ["323-4 CP", "450-1 CP", "323-7 CP"],
    answer: "323-4 CP",
    explanation:
        "323-4 : participation à une entente/groupement préparant des infractions 323-1 à 323-3-1.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peine (323-1 al.1)",
    question: "Peines 323-1 al.1 (accès/maintien frauduleux simple) :",
    options: ["3 ans + 100 000 €", "5 ans + 150 000 €", "7 ans + 300 000 €"],
    answer: "3 ans + 100 000 €",
    explanation:
        "Tableau : 323-1 al.1 = 3 ans d’emprisonnement + 100 000 € d’amende.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peine (323-1 al.2)",
    question:
        "Peines 323-1 al.2 (si suppression/modification données OU altération fonctionnement) :",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "10 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation: "Tableau : 323-1 al.2 = 5 ans + 150 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peine (323-1 al.3)",
    question:
        "Peines 323-1 al.3 (STAD à caractère personnel mis en œuvre par l’État) :",
    options: ["7 ans + 300 000 €", "5 ans + 150 000 €", "3 ans + 100 000 €"],
    answer: "7 ans + 300 000 €",
    explanation: "Tableau : 323-1 al.3 = 7 ans + 300 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peine (323-3)",
    question: "Peines 323-3 (actions frauduleuses sur les données) :",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "7 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation:
        "Tableau : 323-3 = 5 ans d’emprisonnement + 150 000 € d’amende.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peine (323-4-2)",
    question:
        "Lorsque l’infraction expose autrui à un risque immédiat de mort / obstacle aux secours (323-4-2), la peine peut aller à :",
    options: ["10 ans + 300 000 €", "7 ans + 300 000 €", "5 ans + 150 000 €"],
    answer: "10 ans + 300 000 €",
    explanation:
        "Tableau : 323-4-2 = 10 ans d’emprisonnement + 300 000 € d’amende.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "STAD — Vrai/Faux ultra-piège",
    question: "Vrai/Faux : un STAD, c’est uniquement « un site internet ».",
    options: ["Vrai", "Faux", "Seulement s’il y a des données personnelles"],
    answer: "Faux",
    explanation:
        "Le cours : ensemble matériel + logiciel (machine, composants, programmes...).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "STAD — Vrai/Faux (maître du système)",
    question: "Vrai/Faux : le maître du système est forcément son concepteur.",
    options: ["Vrai", "Faux", "Seulement si c’est une PME"],
    answer: "Faux",
    explanation:
        "Le cours : le maître du système peut être celui qui a acquis le droit de l’exploiter.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Accès frauduleux — Piège concours (sans droit)",
    question: "« Sans droit » (323-1) signifie notamment :",
    options: [
      "Accès interdit OU accès autorisé mais obtenu/ réalisé autrement que prévu (dépassement, contournement procédure)",
      "Accès seulement si effraction physique",
      "Accès seulement si vol de mot de passe",
    ],
    answer:
        "Accès interdit OU accès autorisé mais obtenu/ réalisé autrement que prévu (dépassement, contournement procédure)",
    explanation:
        "Le cours : pas de droit d’accès OU pas le droit d’y accéder « de cette façon ».",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Accès frauduleux — Piège affichage",
    question:
        "Un système ouvert sans mot de passe mais avec une restriction claire d’accès (réservé) :",
    options: [
      "Peut quand même être 323-1 (pas besoin de protection technique)",
      "Ne peut jamais être 323-1",
      "Devient forcément 323-3",
    ],
    answer: "Peut quand même être 323-1 (pas besoin de protection technique)",
    explanation:
        "CA Paris 05/04/1994 : pas nécessaire de dispositif de protection.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Accès frauduleux — Cas pratique",
    question:
        "Un salarié autorisé à consulter la base A utilise ses accès pour entrer dans la base B non autorisée :",
    options: [
      "Accès frauduleux 323-1 (tout ou partie du système)",
      "Aucune infraction car il est « dans l’entreprise »",
      "Uniquement 323-3-1",
    ],
    answer: "Accès frauduleux 323-1 (tout ou partie du système)",
    explanation:
        "Le texte vise « tout ou partie » : habilitation partielle ≠ habilitation totale.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Maintien frauduleux — Piège erreur",
    question:
        "Un utilisateur se connecte par erreur sur un espace non protégé puis reste et explore malgré l’interdiction :",
    options: [
      "Maintien frauduleux possible si conscience d’être sans droit",
      "Impossible car l’accès initial était accidentel",
      "Uniquement une tentative",
    ],
    answer: "Maintien frauduleux possible si conscience d’être sans droit",
    explanation:
        "Le cours : maintien vise justement des accès initiaux réguliers/hasard suivis d’un maintien illicite.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Maintien frauduleux — Délit continu",
    question:
        "Vrai/Faux : pour le maintien, la prescription court à partir de la fin du maintien.",
    options: ["Vrai", "Faux", "Seulement si données modifiées"],
    answer: "Vrai",
    explanation:
        "Le cours : maintien = délit continu, prescription à la fin du maintien.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "323-1 — Élément moral (V/F)",
    question:
        "Vrai/Faux : 323-1 exige la conscience d’agir contre le gré du maître du système.",
    options: ["Vrai", "Faux", "Seulement en bande organisée"],
    answer: "Vrai",
    explanation:
        "Le cours : conscience d’accéder ou se maintenir sans droit (contre la volonté du maître).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-1 — Mobile (piège)",
    question:
        "Vrai/Faux : si l’auteur agit « pour prouver une faille », il n’y a pas d’infraction.",
    options: ["Vrai", "Faux", "Seulement si aucune donnée n’est vue"],
    answer: "Faux",
    explanation:
        "Le cours : mobile indifférent (jeu, prouesse, démonstration) → peut être poursuivi.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "323-3 — Cas pratique (accès licite)",
    question:
        "Une personne a un accès licite mais supprime volontairement des données sans autorisation :",
    options: [
      "323-3 (suppression frauduleuse de données)",
      "323-1 uniquement",
      "Aucune infraction car accès licite",
    ],
    answer: "323-3 (suppression frauduleuse de données)",
    explanation:
        "Le cours : 323-3 peut s’appliquer même si l’accès au système était licite.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3 — Extraction (piège vol)",
    question: "Extraire des données (copie) sans priver le propriétaire :",
    options: [
      "Peut être réprimé par 323-3 (protection des données en elles-mêmes)",
      "Ne peut jamais être puni car pas de soustraction",
      "Est forcément un vol",
    ],
    answer:
        "Peut être réprimé par 323-3 (protection des données en elles-mêmes)",
    explanation:
        "Le cours : 323-3 permet de sanctionner la copie/extraction de données.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3 — Détention (piège)",
    question:
        "La détention de données obtenues frauduleusement peut être vue comme :",
    options: [
      "Une forme proche du recel de données (idée du cours)",
      "Une contravention automatique",
      "Un faux administratif",
    ],
    answer: "Une forme proche du recel de données (idée du cours)",
    explanation:
        "Le cours : détention peut s’apparenter à un recel de données extraites/reproduites/transmises.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3 — Données hors système",
    question:
        "Manipuler des données sur un support externe (hors du système) :",
    options: [
      "N’entre pas dans 323-3 tant qu’elles ne sont pas réintroduites dans le système",
      "Relève automatiquement de 323-3",
      "Relève automatiquement de 323-1",
    ],
    answer:
        "N’entre pas dans 323-3 tant qu’elles ne sont pas réintroduites dans le système",
    explanation:
        "Le cours : action sur données sorties du système ≠ 323-3 sauf réintroduction.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "323-3-1 — Définition (ultra-piège)",
    question: "323-3-1 sanctionne :",
    options: [
      "La fourniture / détention d’outils ou données adaptés pour commettre 323-1 à 323-3, sans motif légitime",
      "Le simple fait de programmer en Python",
      "Le fait d’acheter un antivirus",
    ],
    answer:
        "La fourniture / détention d’outils ou données adaptés pour commettre 323-1 à 323-3, sans motif légitime",
    explanation:
        "Le cours : importation/détention/offre/cession/mise à disposition, sans motif légitime.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3-1 — Motif légitime (V/F)",
    question:
        "Vrai/Faux : la recherche en sécurité informatique peut constituer un motif légitime.",
    options: ["Vrai", "Faux", "Jamais"],
    answer: "Vrai",
    explanation:
        "Le cours : motifs légitimes possibles = recherche + sécurisation des SI/réseaux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3-1 — Intention de nuire (V/F)",
    question: "Vrai/Faux : 323-3-1 exige une intention directe de nuire.",
    options: ["Vrai", "Faux", "Seulement en bande organisée"],
    answer: "Faux",
    explanation:
        "Le cours : la simple détention peut être réprimée même sans intention initiale de diffuser/contaminer.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "323-4 — Définition (ultra-piège)",
    question: "L’association de malfaiteurs en informatique suppose :",
    options: [
      "Groupement/entente + préparation caractérisée par faits matériels + infractions visées (323-1 à 323-3-1)",
      "Une infraction consommée obligatoire",
      "Un minimum de 5 membres",
    ],
    answer:
        "Groupement/entente + préparation caractérisée par faits matériels + infractions visées (323-1 à 323-3-1)",
    explanation:
        "Le cours : préparation en amont, matérialisée par des actes (échanges codes, méthodes, etc.).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-4 — Piège effectif",
    question:
        "Vrai/Faux : on peut être poursuivi 323-4 même si aucun piratage n’a finalement eu lieu.",
    options: ["Vrai", "Faux", "Seulement si un mineur participe"],
    answer: "Vrai",
    explanation:
        "Le cours : 323-4 vise la préparation caractérisée par faits matériels, en amont.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-4 — Piège connaissance totale",
    question:
        "Vrai/Faux : chaque membre doit connaître toutes les activités de l’entente pour être condamné.",
    options: ["Vrai", "Faux", "Seulement le chef"],
    answer: "Faux",
    explanation:
        "Le cours : pas nécessaire que chaque membre connaisse toutes les activités (CA Aix, 02/06/1993).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Mini-cas — Qualification (323-1)",
    question:
        "Un ex-salarié conserve des identifiants et continue d’accéder à des bases internes après son départ :",
    options: [
      "323-1 (accès sans droit)",
      "323-3-1 (outils)",
      "323-4 (entente)",
    ],
    answer: "323-1 (accès sans droit)",
    explanation:
        "Le cours cite un cas type : accès via codes après départ = accès frauduleux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Mini-cas — Qualification (323-3)",
    question:
        "Un employé copie des fichiers internes (sans suppression) et les transmet à un tiers :",
    options: [
      "323-3 (extraction/reproduction/transmission)",
      "323-1 uniquement",
      "Aucune infraction",
    ],
    answer: "323-3 (extraction/reproduction/transmission)",
    explanation:
        "323-3 vise extraction, reproduction et transmission frauduleuse de données.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Mini-cas — Qualification (323-3-1)",
    question:
        "Une personne vend un programme conçu spécialement pour casser des accès, sans motif légitime :",
    options: ["323-3-1", "323-1", "323-4"],
    answer: "323-3-1",
    explanation:
        "323-3-1 vise l’offre/cession/mise à disposition d’outils adaptés, sans motif légitime.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Mini-cas — Qualification (323-4)",
    question:
        "Deux personnes échangent des codes et scripts pour préparer des intrusions futures :",
    options: ["323-4", "323-1 seulement", "323-3 seulement"],
    answer: "323-4",
    explanation:
        "Entente + faits matériels préparatoires = 323-4 même si l’infraction finale n’a pas eu lieu.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "QCM ultra-piège — Accès vs Maintien",
    question:
        "Le maintien frauduleux est particulièrement utile pour réprimer :",
    options: [
      "Un accès initial régulier/accidentel suivi d’un maintien non autorisé",
      "Uniquement les intrusions par force",
      "Uniquement la suppression de données",
    ],
    answer:
        "Un accès initial régulier/accidentel suivi d’un maintien non autorisé",
    explanation:
        "Le cours : maintien vise les situations où l’accès initial ne suffit pas à lui seul.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM ultra-piège — Preuve de l’intention",
    question:
        "La présence d’un dispositif de protection (mot de passe) est surtout utile pour :",
    options: [
      "Établir plus facilement le caractère délibéré et irrégulier (ex : forcement)",
      "Créer l’infraction (sinon rien)",
      "Supprimer automatiquement l’élément moral",
    ],
    answer:
        "Établir plus facilement le caractère délibéré et irrégulier (ex : forcement)",
    explanation:
        "Le cours : pas indispensable, mais aide à prouver l’intrusion délibérée.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "323-1 — Tentative (V/F)",
    question:
        "Vrai/Faux : la tentative d’accès/maintien frauduleux est punissable (323-7).",
    options: ["Vrai", "Faux", "Seulement si l’État est visé"],
    answer: "Vrai",
    explanation: "Le cours : tentative spécialement prévue par 323-7.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3 — Tentative (V/F)",
    question: "Vrai/Faux : la tentative de 323-3 est punissable (323-7).",
    options: ["Vrai", "Faux", "Seulement si bande organisée"],
    answer: "Vrai",
    explanation:
        "Le cours : tentative prévue par 323-7 pour les délits du chapitre.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-1 — Complicité (V/F)",
    question:
        "Vrai/Faux : la complicité est possible pour 323-1 via 121-7 (aide/assistance, provocation, instructions).",
    options: ["Vrai", "Faux", "Seulement si le complice touche de l’argent"],
    answer: "Vrai",
    explanation: "Le cours : complicité applicable conformément à 121-7.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "323-3 — Complicité (V/F)",
    question: "Vrai/Faux : la complicité est possible pour 323-3 via 121-7.",
    options: ["Vrai", "Faux", "Jamais"],
    answer: "Vrai",
    explanation:
        "Le cours : complicité applicable (aide/assistance, provocation, instructions).",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "STAD — Jurisprudence (piège)",
    question:
        "Vrai/Faux : un radiotéléphone a déjà été jugé comme étant un STAD.",
    options: ["Vrai", "Faux", "Seulement s’il a un navigateur web"],
    answer: "Vrai",
    explanation:
        "Le cours cite : radiotéléphone = système (CA Paris, 18/11/1992).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "STAD — Jurisprudence (piège)",
    question:
        "Vrai/Faux : l’annuaire électronique de France Télécom a déjà été jugé comme étant un STAD.",
    options: ["Vrai", "Faux", "Seulement si l’accès est payant"],
    answer: "Vrai",
    explanation:
        "Le cours cite : annuaire électronique FT = système (Tr. corr. Brest, 14/03/1995).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "QCM ultra-piège — « Tout ou partie »",
    question: "La mention « tout ou partie du système » permet :",
    options: [
      "De réprimer l’accès à une zone unique (ex: un logiciel/terminal) ou le dépassement d’une habilitation partielle",
      "D’exiger une intrusion totale dans tout le réseau",
      "D’exclure les systèmes téléphoniques",
    ],
    answer:
        "De réprimer l’accès à une zone unique (ex: un logiciel/terminal) ou le dépassement d’une habilitation partielle",
    explanation:
        "Le cours : vise aussi la zone unique + l’habilité partiel qui dépasse.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM ultra-piège — Données vs support externe",
    question: "Quel énoncé est correct ?",
    options: [
      "323-3 vise l’action sur des données contenues dans le système ; une action sur support externe n’entre pas sauf réintroduction",
      "323-3 vise n’importe quel support externe quoi qu’il arrive",
      "323-3 ne vise que la suppression, pas l’extraction",
    ],
    answer:
        "323-3 vise l’action sur des données contenues dans le système ; une action sur support externe n’entre pas sauf réintroduction",
    explanation:
        "Le cours : distinction données dans le système vs hors système.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique concours — Qualification + peine",
    question:
        "Un individu accède sans droit à un STAD et modifie des données (323-1 al.2) : peine encourue ?",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "7 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation:
        "323-1 al.2 : suppression/modification données ou altération fonctionnement.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique concours — Qualification + peine",
    question:
        "Accès frauduleux contre un STAD à caractère personnel mis en œuvre par l’État : peine ?",
    options: ["7 ans + 300 000 €", "5 ans + 150 000 €", "10 ans + 300 000 €"],
    answer: "7 ans + 300 000 €",
    explanation:
        "323-1 al.3 : aggravation spéciale État (données personnelles).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique concours — Qualification + peine",
    question: "Introduction frauduleuse de données (323-3) : peine de base ?",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "7 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation: "Tableau : 323-3 = 5 ans + 150 000 €.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Piège — Sniffing",
    question:
        "Un logiciel espion introduit dans un système pour capter des infos (sniffing) correspond à :",
    options: [
      "323-3 (introduction de données)",
      "323-1 uniquement",
      "323-4 uniquement",
    ],
    answer: "323-3 (introduction de données)",
    explanation:
        "Le cours : introduction d’un logiciel espion entre dans 323-3.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — Cracking",
    question:
        "Dans le cours, la forme de piratage appelée « cracking » renvoie surtout à :",
    options: [
      "Une action sur les données (323-3) : modification/suppression/altération des infos",
      "Le recel",
      "La concussion",
    ],
    answer:
        "Une action sur les données (323-3) : modification/suppression/altération des infos",
    explanation:
        "Le cours : 323-3 correspond souvent au « cracking » (action sur données).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Vrai/Faux — Pacte inutile",
    question:
        "Vrai/Faux : Pour 323-1, il faut obligatoirement un dommage pour que l’infraction existe.",
    options: ["Vrai", "Faux", "Seulement si données personnelles"],
    answer: "Faux",
    explanation:
        "323-1 al.1 existe sans dommage ; le dommage est une aggravation (al.2/3).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Promenade",
    question:
        "Vrai/Faux : un maintien « inoffensif » peut être réprimé s’il est sans droit.",
    options: ["Vrai", "Faux", "Seulement si l’auteur est informaticien"],
    answer: "Vrai",
    explanation: "Le cours : maintien inoffensif ou actif est incriminable.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Ultra-piège — Erreur vs compétence",
    question: "Un accès « par erreur » est apprécié notamment au regard :",
    options: [
      "Des compétences informatiques du prévenu",
      "De la météo",
      "Du type de clavier",
    ],
    answer: "Des compétences informatiques du prévenu",
    explanation:
        "Le cours : vraisemblance de l’erreur/intention appréciée selon compétences.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Ultra-piège — Sans droit (source)",
    question: "L’absence de droit d’accès peut résulter :",
    options: [
      "De la loi (ex: secret) OU de la volonté du maître de restreindre l’accès (procédure, code, prix)",
      "Uniquement d’une condamnation préalable",
      "Uniquement d’un piratage par malware",
    ],
    answer:
        "De la loi (ex: secret) OU de la volonté du maître de restreindre l’accès (procédure, code, prix)",
    explanation:
        "Le cours : sans droit peut résulter de la loi ou de la volonté/procédure imposée par le maître.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Mix concours — Choisis la bonne qualification",
    question:
        "On copie des données internes, on les garde chez soi (sans diffusion). Qualification la plus directe :",
    options: [
      "323-3 (extraction/détention/reproduction)",
      "323-1 uniquement",
      "323-4",
    ],
    answer: "323-3 (extraction/détention/reproduction)",
    explanation:
        "323-3 vise extraction, détention, reproduction de données obtenues frauduleusement.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Mix concours — Choisis la bonne qualification",
    question:
        "On ne touche pas aux données, mais on reste connecté sans droit pour « explorer » :",
    options: ["323-1 (maintien)", "323-3", "323-3-1"],
    answer: "323-1 (maintien)",
    explanation:
        "Le maintien sans droit est incriminé même « inoffensif » (simple promenade).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Mix concours — Choisis la bonne qualification",
    question:
        "On met à disposition un outil adapté au piratage, sans motif légitime, mais aucun piratage n’a encore eu lieu :",
    options: ["323-3-1", "323-1", "323-3"],
    answer: "323-3-1",
    explanation:
        "323-3-1 sanctionne la simple fourniture/détention/offre d’outils adaptés, sans besoin d’infraction consommée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Mix concours — Choisis la bonne qualification",
    question:
        "On s’organise à plusieurs, échanges de codes + méthodes, préparation matérialisée, sans passage à l’acte :",
    options: ["323-4", "323-1", "323-3-1"],
    answer: "323-4",
    explanation:
        "323-4 : entente/groupement + préparation caractérisée par faits matériels.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peine (323-3 aggravé État)",
    question:
        "Peines pour 323-3 lorsqu’il est commis contre un STAD à caractère personnel mis en œuvre par l’État :",
    options: ["7 ans + 300 000 €", "5 ans + 150 000 €", "10 ans + 300 000 €"],
    answer: "7 ans + 300 000 €",
    explanation:
        "Le cours : aggravation « État / caractère personnel » = 7 ans + 300 000 € (tableau).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peine (323-3 bande organisée)",
    question:
        "Peines (max) quand l’infraction est commise en bande organisée :",
    options: ["7 ans + 300 000 €", "5 ans + 150 000 €", "3 ans + 100 000 €"],
    answer: "7 ans + 300 000 €",
    explanation:
        "Le cours mentionne l’aggravation bande organisée (323-4-1) : 7 ans + 300 000 €.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Tentative (323-7)",
    question: "La tentative des infractions du chapitre STAD est prévue par :",
    options: ["323-7 CP", "323-6 CP", "323-4 CP"],
    answer: "323-7 CP",
    explanation:
        "Le cours : tentative d’accès/maintien (et autres) spécialement prévue par 323-7.",
    difficulty: "Moyenne",
  ),

  // =====================
  // STAD — DÉFINITION / NOTIONS (ULTRA PIÈGES)
  // =====================
  const QuizQuestion(
    category: "STAD — Définition (piège concours)",
    question: "Un STAD peut être défini comme :",
    options: [
      "Un ensemble matériel + logiciel capable de mémoriser et traiter l’information",
      "Un document papier classé en mairie",
      "Uniquement un ordinateur connecté à Internet",
    ],
    answer:
        "Un ensemble matériel + logiciel capable de mémoriser et traiter l’information",
    explanation:
        "Le cours : ensemble de biens matériels et logiciels, mémoire + traitement, restitution des résultats.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "STAD — Inclusion (V/F)",
    question:
        "Vrai/Faux : un STAD inclut aussi les programmes/logiciels assurant son fonctionnement.",
    options: ["Vrai", "Faux", "Uniquement les serveurs"],
    answer: "Vrai",
    explanation:
        "Le cours : le système = machine + composants + programmes/logiciels.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "STAD — « Maître du système » (piège)",
    question: "Le « maître du système » est :",
    options: [
      "Celui qui dispose des prérogatives d’exploitation (modifier, supprimer, autoriser l’accès)",
      "Uniquement l’informaticien qui a codé le logiciel",
      "Uniquement l’État",
    ],
    answer:
        "Celui qui dispose des prérogatives d’exploitation (modifier, supprimer, autoriser l’accès)",
    explanation:
        "Le cours : pas forcément concepteur ; c’est celui qui exploite et décide de l’usage.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "STAD — Volonté du maître (V/F)",
    question:
        "Vrai/Faux : les délits STAD reposent sur le non-respect de la volonté du maître du système.",
    options: ["Vrai", "Faux", "Seulement en cas de données personnelles"],
    answer: "Vrai",
    explanation:
        "Le cours : les délits supposent le non-respect de la volonté du maître du système.",
    difficulty: "Facile",
  ),

  // =====================
  // 323-1 — ACCÈS FRAUDULEUX (QCM PIÈGES)
  // =====================
  const QuizQuestion(
    category: "323-1 — Accès (définition)",
    question: "L’accès (323-1) peut être compris comme :",
    options: [
      "L’établissement d’une communication avec le système",
      "Le fait de casser physiquement un serveur",
      "Le fait de supprimer des fichiers",
    ],
    answer: "L’établissement d’une communication avec le système",
    explanation:
        "Le cours : accès = établissement d’une communication ; modes techniques indifférents.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-1 — Protection (ultra piège)",
    question:
        "Vrai/Faux : si un système n’a aucun mot de passe, l’accès frauduleux est impossible à retenir.",
    options: ["Vrai", "Faux", "Seulement si c’est un site public"],
    answer: "Faux",
    explanation:
        "Le cours : pas nécessaire que l’accès soit limité par un dispositif de protection.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Dépassement d’autorisation",
    question:
        "Une personne a un droit d’accès limité, mais « force » une zone restreinte. Qualification :",
    options: [
      "323-1 (accès sans droit dans une autre partie)",
      "Aucune infraction (elle avait un compte)",
      "323-3-1 uniquement",
    ],
    answer: "323-1 (accès sans droit dans une autre partie)",
    explanation:
        "Le cours : « tout ou partie » + accès sans droit = dépassement d’habilitation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Accès par personne interposée (piège)",
    question:
        "Vrai/Faux : utiliser l’identifiant d’un tiers (même obtenu « gentiment ») peut caractériser un accès sans droit.",
    options: ["Vrai", "Faux", "Seulement si volé"],
    answer: "Vrai",
    explanation:
        "L’accès sans droit vise aussi se faire passer pour une personne autorisée / forcer les codes.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Accès « payant » (piège)",
    question:
        "Si le maître du système subordonne l’accès au paiement d’un prix :",
    options: [
      "Accéder sans payer peut être « sans droit »",
      "Accéder sans payer est toujours licite",
      "Seul un contrat civil est possible",
    ],
    answer: "Accéder sans payer peut être « sans droit »",
    explanation:
        "Le cours : absence de droit peut résulter du non-respect d’une procédure (code/paiement).",
    difficulty: "Difficile",
  ),

  // =====================
  // 323-1 — MAINTIEN FRAUDULEUX (QCM PIÈGES)
  // =====================
  const QuizQuestion(
    category: "323-1 — Maintien (définition)",
    question: "Le maintien frauduleux vise notamment les situations où :",
    options: [
      "L’accès initial est accidentel/régulier mais la suite (rester/explorer) devient sans droit",
      "La personne casse un disque dur",
      "La personne revend un ordinateur",
    ],
    answer:
        "L’accès initial est accidentel/régulier mais la suite (rester/explorer) devient sans droit",
    explanation:
        "Le cours : maintien utile pour les accès de hasard, erreur, ou procédures régulières suivies d’opérations illicites.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Maintien inoffensif (V/F)",
    question:
        "Vrai/Faux : un maintien « promenade » sans dommage peut être sanctionné.",
    options: ["Vrai", "Faux", "Seulement si l’auteur est informaticien"],
    answer: "Vrai",
    explanation: "Le cours : maintien inoffensif ou actif est incriminable.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-1 — Délit continu (piège)",
    question: "Le maintien est qualifié de délit continu car :",
    options: [
      "La prescription court à la fin du maintien",
      "Il se prescrit dès l’accès initial",
      "Il n’est jamais prescriptible",
    ],
    answer: "La prescription court à la fin du maintien",
    explanation:
        "Le cours : la prescription ne court qu’à compter de la fin du maintien.",
    difficulty: "Difficile",
  ),

  // =====================
  // 323-1 — CIRCONSTANCES AGGRAVANTES (QCM CONCOURS)
  // =====================
  const QuizQuestion(
    category: "323-1 — Aggravation (al.2)",
    question: "L’aggravation 323-1 al.2 est retenue lorsqu’il en est résulté :",
    options: [
      "Suppression/modification de données OU altération du fonctionnement",
      "La simple lecture de données",
      "Une capture d’écran",
    ],
    answer:
        "Suppression/modification de données OU altération du fonctionnement",
    explanation:
        "Le cours : aggravation si suppression/modification données ou altération fonctionnement.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-1 — Aggravation (al.3) (piège)",
    question: "L’aggravation 323-1 al.3 vise les atteintes contre :",
    options: [
      "Un STAD à caractère personnel mis en œuvre par l’État",
      "N’importe quel compte Facebook",
      "Un ordinateur personnel sans données",
    ],
    answer: "Un STAD à caractère personnel mis en œuvre par l’État",
    explanation: "Le cours : aggravation spéciale État + caractère personnel.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-4-1 — Bande organisée (V/F)",
    question:
        "Vrai/Faux : la bande organisée est une circonstance aggravante autonome des infractions STAD.",
    options: ["Vrai", "Faux", "Uniquement pour 323-4"],
    answer: "Vrai",
    explanation:
        "Le cours : 323-4-1 prévoit l’aggravation lorsque l’infraction est commise en bande organisée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-4-2 — Risque immédiat (piège)",
    question: "323-4-2 vise notamment les situations où l’infraction :",
    options: [
      "Expose à un risque immédiat de mort/mutilation OU fait obstacle aux secours",
      "Provoque seulement une perte de mot de passe",
      "Crée uniquement un préjudice moral",
    ],
    answer:
        "Expose à un risque immédiat de mort/mutilation OU fait obstacle aux secours",
    explanation:
        "Le cours : aggravation spécifique « sécurité des personnes / secours / péril imminent ».",
    difficulty: "Difficile",
  ),

  // =====================
  // 323-3 — ACTIONS SUR LES DONNÉES (ULTRA PIÈGES)
  // =====================
  const QuizQuestion(
    category: "323-3 — Portée (piège)",
    question:
        "Vrai/Faux : pour 323-3, il faut un trouble visible du fonctionnement du système.",
    options: ["Vrai", "Faux", "Seulement si État visé"],
    answer: "Faux",
    explanation:
        "Le cours : l’action peut être sanctionnée même sans perturbation apparente/immediate.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3 — Introduction",
    question: "L’introduction de données correspond à :",
    options: [
      "L’incorporation de caractères informatiques nouveaux dans le système",
      "La vente d’un ordinateur d’occasion",
      "Le fait de se connecter à un Wi-Fi",
    ],
    answer:
        "L’incorporation de caractères informatiques nouveaux dans le système",
    explanation:
        "Le cours : introduction = insertion de données nouvelles dans le système.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3 — Extraction (piège)",
    question: "L’extraction de données permet de réprimer :",
    options: [
      "La copie laissant les données au propriétaire (pas de « soustraction »)",
      "Uniquement la suppression totale",
      "Uniquement l’impression papier",
    ],
    answer:
        "La copie laissant les données au propriétaire (pas de « soustraction »)",
    explanation:
        "Le cours : protège les données même sans dépossession → vol difficilement applicable.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3 — Reproduction",
    question: "La reproduction de données vise :",
    options: [
      "Les actes de copie de données obtenues frauduleusement, quel qu’en soit le support",
      "Uniquement la copie papier",
      "Uniquement la duplication d’un serveur",
    ],
    answer:
        "Les actes de copie de données obtenues frauduleusement, quel qu’en soit le support",
    explanation: "Le cours : reproduction = copie sur n’importe quel support.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3 — Transmission",
    question: "La transmission de données vise :",
    options: [
      "Toute diffusion à un tiers, quel qu’en soit le moyen/support",
      "Seulement l’envoi par e-mail",
      "Seulement la publication sur Internet",
    ],
    answer: "Toute diffusion à un tiers, quel qu’en soit le moyen/support",
    explanation:
        "Le cours : transmission = diffusion à un tiers quel que soit le moyen.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3 — Suppression (piège)",
    question: "Supprimer des données peut consister :",
    options: [
      "En un effacement/écrasement OU un déplacement hors système / zone réservée",
      "Uniquement en brûlant le serveur",
      "Uniquement en changeant un mot de passe",
    ],
    answer:
        "En un effacement/écrasement OU un déplacement hors système / zone réservée",
    explanation:
        "Le cours : suppression = effacement mais aussi déplacement hors zone accessible.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3 — Modification (piège)",
    question: "Modifier des données signifie :",
    options: [
      "Modifier l’information portée par les données (altération du contenu)",
      "Changer de clavier",
      "Ouvrir un fichier en lecture seule",
    ],
    answer:
        "Modifier l’information portée par les données (altération du contenu)",
    explanation:
        "Le cours : modification = modification de l’information qu’elles portent.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3 — Accès licite (ultra piège)",
    question:
        "Vrai/Faux : l’auteur doit forcément avoir un accès frauduleux au système pour être poursuivi 323-3.",
    options: ["Vrai", "Faux", "Seulement si données personnelles"],
    answer: "Faux",
    explanation:
        "Le cours : l’auteur peut avoir eu un accès licite ou non ; l’action frauduleuse porte sur les données.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3 — Données hors système (cas)",
    question:
        "Une personne modifie des données sur une clé USB puis ne les réintroduit jamais dans le système :",
    options: [
      "Pas 323-3 (données hors système) tant qu’elles ne sont pas réintroduites",
      "323-3 automatiquement",
      "323-1 automatiquement",
    ],
    answer:
        "Pas 323-3 (données hors système) tant qu’elles ne sont pas réintroduites",
    explanation:
        "Le cours : action sur données sorties du système ≠ 323-3 sauf réintroduction.",
    difficulty: "Difficile",
  ),

  // =====================
  // 323-3-1 — OUTILS / DONNÉES ADAPTÉS (ULTRA PIÈGES)
  // =====================
  const QuizQuestion(
    category: "323-3-1 — Actes visés",
    question: "323-3-1 vise notamment :",
    options: [
      "Importer, détenir, offrir, céder, mettre à disposition",
      "Se connecter avec son propre mot de passe",
      "Acheter un ordinateur",
    ],
    answer: "Importer, détenir, offrir, céder, mettre à disposition",
    explanation: "Le cours : liste des comportements sanctionnés.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3-1 — Objet visé",
    question: "323-3-1 vise :",
    options: [
      "Équipement / instrument / programme / donnée conçus ou spécialement adaptés",
      "Uniquement des virus",
      "Uniquement des mots de passe",
    ],
    answer:
        "Équipement / instrument / programme / donnée conçus ou spécialement adaptés",
    explanation:
        "Le cours : formulation large (outils + données) adaptés pour commettre 323-1 à 323-3.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3-1 — Lien avec infraction consommée (piège)",
    question:
        "Vrai/Faux : 323-3-1 exige que l’infraction STAD (323-1 à 323-3) ait déjà été commise.",
    options: ["Vrai", "Faux", "Seulement pour la détention"],
    answer: "Faux",
    explanation:
        "Le cours : incrimination peut sanctionner la simple détention/mise à disposition sans infraction commise révélée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3-1 — Motif légitime (piège concours)",
    question: "Le « motif légitime » peut inclure :",
    options: [
      "Recherche ou sécurité informatique (sécurisation des SI / réseaux)",
      "La vengeance personnelle",
      "Le profit facile",
    ],
    answer:
        "Recherche ou sécurité informatique (sécurisation des SI / réseaux)",
    explanation:
        "Le cours cite : recherche scientifique/technique + sécurisation des SI/réseaux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3-1 — Appréciation (piège)",
    question: "La légitimité du motif est :",
    options: [
      "Appréciée par les magistrats (notion imprécise)",
      "Fixée automatiquement par la police",
      "Toujours présumée légitime",
    ],
    answer: "Appréciée par les magistrats (notion imprécise)",
    explanation:
        "Le cours : notion non listée, appréciée par les magistrats selon les hypothèses.",
    difficulty: "Difficile",
  ),

  // =====================
  // 323-4 — ASSOCIATION DE MALFAITEURS INFORMATIQUE (ULTRA PIÈGES)
  // =====================
  const QuizQuestion(
    category: "323-4 — Groupement/entente (piège)",
    question:
        "Vrai/Faux : l’entente peut être retenue même si le groupement ne comporte que deux personnes.",
    options: ["Vrai", "Faux", "Minimum 3"],
    answer: "Vrai",
    explanation:
        "Le cours : entente retenue pour deux personnes (exemple jurisprudentiel cité).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-4 — Objet (piège)",
    question: "Les infractions préparées visées par 323-4 peuvent être :",
    options: ["323-1 à 323-3-1", "Uniquement 323-1", "Uniquement 323-3"],
    answer: "323-1 à 323-3-1",
    explanation: "Le cours : infractions visées = 323-1 à 323-3-1.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-4 — Faits matériels (piège concours)",
    question:
        "Les « faits matériels » caractérisant la préparation peuvent être :",
    options: [
      "Échanges d’infos : codes d’accès, moyens de « casser » un code, méthodes",
      "Uniquement un post sur un forum sans contenu",
      "Uniquement un achat de PC",
    ],
    answer:
        "Échanges d’infos : codes d’accès, moyens de « casser » un code, méthodes",
    explanation:
        "Le cours : exemples d’actes préparatoires matérialisant la préparation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-4 — Élément moral (V/F)",
    question:
        "Vrai/Faux : il faut une participation volontaire et la conscience que l’entente prépare des atteintes STAD.",
    options: ["Vrai", "Faux", "Seulement si l’attaque a réussi"],
    answer: "Vrai",
    explanation:
        "Le cours : participation volontaire + conscience de l’objet délictueux du groupement/entente.",
    difficulty: "Difficile",
  ),

  // =====================
  // MINI-CAS PRATIQUES — QUALIFICATION + ARTICLE + PEINE (CONCOURS)
  // =====================
  const QuizQuestion(
    category: "Mini-cas concours — Qualification + peine",
    question:
        "Un individu s’introduit dans un STAD sans droit, sans rien modifier. Qualification + peine ?",
    options: [
      "323-1 al.1 : 3 ans + 100 000 €",
      "323-1 al.2 : 5 ans + 150 000 €",
      "323-3 : 5 ans + 150 000 €",
    ],
    answer: "323-1 al.1 : 3 ans + 100 000 €",
    explanation:
        "Accès frauduleux simple sans altération/suppression/modification : 323-1 al.1.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Mini-cas concours — Qualification + peine",
    question:
        "Après accès sans droit, l’auteur altère le fonctionnement du système. Qualification + peine ?",
    options: [
      "323-1 al.2 : 5 ans + 150 000 €",
      "323-1 al.1 : 3 ans + 100 000 €",
      "323-4 : 3 ans + 100 000 €",
    ],
    answer: "323-1 al.2 : 5 ans + 150 000 €",
    explanation:
        "Aggravation al.2 si altération du fonctionnement ou modification/suppression de données.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Mini-cas concours — Qualification + peine",
    question:
        "Accès frauduleux à un STAD de l’État contenant des données personnelles. Qualification + peine ?",
    options: [
      "323-1 al.3 : 7 ans + 300 000 €",
      "323-1 al.2 : 5 ans + 150 000 €",
      "323-3 : 5 ans + 150 000 €",
    ],
    answer: "323-1 al.3 : 7 ans + 300 000 €",
    explanation:
        "Aggravation spéciale : STAD à caractère personnel mis en œuvre par l’État.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Mini-cas concours — Qualification + peine",
    question:
        "Un salarié efface des données du système auquel il a accès, sans autorisation. Qualification + peine ?",
    options: [
      "323-3 : 5 ans + 150 000 €",
      "323-1 : 3 ans + 100 000 €",
      "323-3-1 : 3 ans + 100 000 €",
    ],
    answer: "323-3 : 5 ans + 150 000 €",
    explanation:
        "323-3 : suppression frauduleuse de données, même si l’accès initial était licite.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Mini-cas concours — Qualification + peine",
    question:
        "Un individu copie des données (extraction) puis les transmet à un tiers. Qualification + peine de base ?",
    options: [
      "323-3 : 5 ans + 150 000 €",
      "323-1 : 3 ans + 100 000 €",
      "323-4 : 5 ans + 150 000 €",
    ],
    answer: "323-3 : 5 ans + 150 000 €",
    explanation:
        "323-3 vise extraction et transmission frauduleuse de données.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Mini-cas concours — Qualification + peine",
    question:
        "Une personne met en vente un outil conçu pour commettre 323-1 à 323-3, sans motif légitime. Qualification + peine de base ?",
    options: [
      "323-3-1 : peines alignées sur l’infraction la plus sévèrement réprimée (mécanisme du cours)",
      "323-1 al.1 : 3 ans + 100 000 €",
      "323-4 : 3 ans + 100 000 €",
    ],
    answer:
        "323-3-1 : peines alignées sur l’infraction la plus sévèrement réprimée (mécanisme du cours)",
    explanation:
        "Le cours : 323-3-1 est puni selon les peines prévues pour l’infraction elle-même / la plus sévèrement réprimée (mêmes mécanismes d’aggravation).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Mini-cas concours — Qualification + peine",
    question:
        "Deux personnes s’entendent, échangent codes et méthodes pour préparer des intrusions. Qualification ?",
    options: ["323-4", "323-1", "323-3"],
    answer: "323-4",
    explanation:
        "323-4 : entente/groupement + préparation caractérisée par faits matériels.",
    difficulty: "Difficile",
  ),

  // =====================
  // VRAI/FAUX — FLASH (MODE RÉVISIONS)
  // =====================
  const QuizQuestion(
    category: "Flash V/F — 323-1",
    question:
        "Vrai/Faux : l’accès peut être réprimé même si la personne n’a pas « forcé » un mot de passe.",
    options: ["Vrai", "Faux", "Seulement si mineur"],
    answer: "Vrai",
    explanation:
        "Le cours : pas nécessaire de dispositif de protection ; ce qui compte = sans droit.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Flash V/F — 323-1",
    question:
        "Vrai/Faux : le maintien est incriminable même s’il est « sans préjudice ».",
    options: ["Vrai", "Faux", "Seulement si données modifiées"],
    answer: "Vrai",
    explanation:
        "Le cours : maintien inoffensif (« promenade ») = incriminable.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Flash V/F — 323-3",
    question:
        "Vrai/Faux : 323-3 peut viser la simple copie (extraction) sans suppression.",
    options: ["Vrai", "Faux", "Seulement si diffusion"],
    answer: "Vrai",
    explanation:
        "Le cours : extraction protège les données même si elles restent disponibles au propriétaire.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Flash V/F — 323-3-1",
    question:
        "Vrai/Faux : la simple détention d’un outil adapté peut suffire (sans intention de nuire).",
    options: ["Vrai", "Faux", "Seulement si déjà utilisé"],
    answer: "Vrai",
    explanation:
        "Le cours : pas forcément volonté directe de nuire ; détention réprimée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Flash V/F — 323-4",
    question:
        "Vrai/Faux : 323-4 exige que l’infraction finale (piratage) soit commise.",
    options: ["Vrai", "Faux", "Seulement si bande organisée"],
    answer: "Faux",
    explanation:
        "Le cours : vise la préparation caractérisée par faits matériels, en amont.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peine (323-1 simple)",
    question:
        "Peine encourue pour l’accès/maintien frauduleux simple (323-1 al.1) :",
    options: ["3 ans + 100 000 €", "5 ans + 150 000 €", "7 ans + 300 000 €"],
    answer: "3 ans + 100 000 €",
    explanation:
        "Tableau : 323-1 al.1 = 3 ans d’emprisonnement + 100 000 € d’amende.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peine (323-1 al.2)",
    question:
        "Peine encourue si suppression/modification de données OU altération du fonctionnement (323-1 al.2) :",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "10 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation: "Tableau : aggravation 323-1 al.2 = 5 ans + 150 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peine (323-1 al.3)",
    question:
        "Peine encourue si STAD à caractère personnel mis en œuvre par l’État (323-1 al.3) :",
    options: ["7 ans + 300 000 €", "5 ans + 150 000 €", "3 ans + 100 000 €"],
    answer: "7 ans + 300 000 €",
    explanation: "Tableau : 323-1 al.3 = 7 ans + 300 000 €.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peine (323-3)",
    question:
        "Peine de base pour introduction/extraction/détention/reproduction/transmission/suppression/modification frauduleuse (323-3) :",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "7 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation:
        "Tableau : 323-3 = 5 ans d’emprisonnement + 150 000 € d’amende.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Tentative (V/F)",
    question:
        "Vrai/Faux : la tentative d’accès/maintien frauduleux est punissable.",
    options: ["Vrai", "Faux", "Seulement si préjudice"],
    answer: "Vrai",
    explanation: "Le cours : tentative spécialement prévue par 323-7 CP.",
    difficulty: "Facile",
  ),

  // =====================================================
  // 323-1 — ACCÈS / MAINTIEN (QCM ULTRA-PIÈGES CONCOURS)
  // =====================================================
  const QuizQuestion(
    category: "323-1 — Accès (piège « sans droit »)",
    question: "L’accès est « sans droit » notamment lorsque :",
    options: [
      "Le maître du système a manifesté l’intention de restreindre l’accès",
      "Le système est public sur Internet",
      "Le prévenu n’a pas causé de dommage",
    ],
    answer:
        "Le maître du système a manifesté l’intention de restreindre l’accès",
    explanation:
        "Le cours : sans droit = contre la volonté du maître, même sans protection technique.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Accès (piège « ancien salarié »)",
    question:
        "Un ancien salarié conserve des identifiants et se connecte après son départ :",
    options: [
      "Accès frauduleux (323-1)",
      "Pas d’infraction (identifiants valides)",
      "Seulement faute disciplinaire",
    ],
    answer: "Accès frauduleux (323-1)",
    explanation:
        "Le cours cite l’hypothèse : usage de codes après départ = accès sans droit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Accès (piège « période d’essai »)",
    question:
        "Utiliser un code remis pour une période d’essai, pendant 2 ans :",
    options: [
      "Accès frauduleux (323-1)",
      "Aucun délit (code remis)",
      "323-3-1 uniquement",
    ],
    answer: "Accès frauduleux (323-1)",
    explanation:
        "Le cours : dépasser la période/autorisation = accès sans droit (exemple jurisprudentiel).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Accès (piège « tout ou partie »)",
    question: "323-1 réprime l’accès frauduleux :",
    options: [
      "Dans tout ou partie du système",
      "Uniquement dans tout le système",
      "Uniquement si données modifiées",
    ],
    answer: "Dans tout ou partie du système",
    explanation:
        "Le cours : formulation « tout ou partie » → zone unique ou sous-partie.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-1 — Maintien (piège « hasard »)",
    question: "Le maintien vise en particulier :",
    options: [
      "Les accès d’abord fortuits/accidentels puis prolongés sans droit",
      "Uniquement les intrusions par piratage technique",
      "Uniquement les accès payants",
    ],
    answer: "Les accès d’abord fortuits/accidentels puis prolongés sans droit",
    explanation:
        "Le cours : maintien utile pour accès par erreur/inadvertance puis maintien.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Maintien (piège prescription)",
    question: "Pourquoi parle-t-on de délit continu pour le maintien ?",
    options: [
      "Parce que la prescription court à la fin du maintien",
      "Parce que la peine augmente chaque jour automatiquement",
      "Parce qu’il n’existe pas de prescription",
    ],
    answer: "Parce que la prescription court à la fin du maintien",
    explanation: "Le cours : prescription à compter de la fin du maintien.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Élément moral (piège concours)",
    question: "L’élément moral de 323-1 exige :",
    options: [
      "La conscience d’accéder ou se maintenir sans droit (contre le gré du maître)",
      "Un mobile lucratif obligatoire",
      "Une intention de nuire obligatoire",
    ],
    answer:
        "La conscience d’accéder ou se maintenir sans droit (contre le gré du maître)",
    explanation:
        "Le cours : conscience du caractère non autorisé ; mobile indifférent.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-1 — Mobile (V/F)",
    question:
        "Vrai/Faux : agir « par jeu » exclut l’infraction d’accès frauduleux.",
    options: ["Vrai", "Faux", "Seulement si mineur"],
    answer: "Faux",
    explanation:
        "Le cours : le mobile est indifférent (jeu, prouesse, démonstration).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "323-1 — Accès par erreur (piège)",
    question: "L’accès par erreur :",
    options: [
      "N’est pas pénalement sanctionné si l’absence d’intention est crédible",
      "Est toujours puni comme 323-1",
      "Est automatiquement 323-3",
    ],
    answer:
        "N’est pas pénalement sanctionné si l’absence d’intention est crédible",
    explanation:
        "Le cours : accès par erreur (système non protégé) non sanctionné ; appréciation selon compétences.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Compétences du prévenu (piège)",
    question:
        "Pour distinguer erreur vs intrusion volontaire, les juges apprécient notamment :",
    options: [
      "Les compétences en informatique du prévenu",
      "Le lieu de résidence",
      "Le casier routier",
    ],
    answer: "Les compétences en informatique du prévenu",
    explanation:
        "Le cours : vraisemblance de l’erreur/intention appréciée selon compétences.",
    difficulty: "Moyenne",
  ),

  // =====================================================
  // 323-1 — AGGRAVATIONS (QCM ULTRA-PIÈGES)
  // =====================================================
  const QuizQuestion(
    category: "323-1 — Aggravation (nature)",
    question: "323-1 al.2 vise :",
    options: [
      "Résultat : suppression/modification de données OU altération du fonctionnement",
      "Seulement la consultation de données",
      "Le simple fait de rester connecté",
    ],
    answer:
        "Résultat : suppression/modification de données OU altération du fonctionnement",
    explanation: "Aggravation au résultat (données/fonctionnement).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-1 — Aggravation État (ultra piège)",
    question: "Pour 323-1 al.3, il faut :",
    options: [
      "Un STAD à caractère personnel mis en œuvre par l’État",
      "N’importe quel STAD public",
      "Un STAD d’entreprise privée",
    ],
    answer: "Un STAD à caractère personnel mis en œuvre par l’État",
    explanation: "Aggravation spéciale (État + caractère personnel).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-4-2 — Secours (piège concours)",
    question: "323-4-2 peut être retenu si l’infraction :",
    options: [
      "Fait obstacle aux secours destinés à échapper à un péril imminent",
      "Supprime un fichier non essentiel",
      "Ralentit une connexion domestique",
    ],
    answer: "Fait obstacle aux secours destinés à échapper à un péril imminent",
    explanation:
        "Le cours : obstacle aux secours / sinistre / sécurité des personnes.",
    difficulty: "Difficile",
  ),

  // =====================================================
  // 323-3 — DONNÉES (INTRODUCTION / EXTRACTION / DETENTION…)
  // =====================================================
  const QuizQuestion(
    category: "323-3 — Champ (piège « système en cours »)",
    question:
        "Vrai/Faux : 323-3 peut s’appliquer même si le système est en cours d’élaboration.",
    options: ["Vrai", "Faux", "Seulement si finalisé"],
    answer: "Vrai",
    explanation:
        "Le cours : peu importe que le système soit finalisé ou en cours d’élaboration.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3 — Accès licite (V/F)",
    question: "Vrai/Faux : 323-3 exige un accès frauduleux préalable (323-1).",
    options: ["Vrai", "Faux", "Seulement si extraction"],
    answer: "Faux",
    explanation: "Le cours : l’auteur peut avoir eu un accès licite ou non.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3 — « cracking » (culture concours)",
    question:
        "Dans le cours, l’action sur les données (323-3) est souvent appelée :",
    options: ["Cracking", "Phishing", "Spoofing"],
    answer: "Cracking",
    explanation:
        "Le cours : cette forme de piratage est souvent appelée « cracking ».",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3 — Logiciel espion (piège)",
    question: "L’introduction d’un logiciel espion dans un système relève :",
    options: [
      "De 323-3 (introduction/modification de données)",
      "Uniquement de 323-1",
      "Uniquement de 323-4",
    ],
    answer: "De 323-3 (introduction/modification de données)",
    explanation:
        "Le cours : insertion logiciel espion (« sniffing ») entre dans 323-3.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3 — Extraction (piège vol)",
    question: "L’extraction vise à sanctionner :",
    options: [
      "La copie sans dépossession (vol difficile car pas de soustraction)",
      "Uniquement le vol de matériel",
      "Uniquement la suppression",
    ],
    answer:
        "La copie sans dépossession (vol difficile car pas de soustraction)",
    explanation:
        "Le cours : extraction protège les données même si elles restent dispo au propriétaire.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3 — Détention (piège recel)",
    question: "La détention de données (323-3) peut s’apparenter à :",
    options: [
      "Un recel de données extraites/reproduites/transmises frauduleusement",
      "Une simple sauvegarde licite",
      "Un acte civil uniquement",
    ],
    answer:
        "Un recel de données extraites/reproduites/transmises frauduleusement",
    explanation:
        "Le cours : détention = proche d’un recel de données issues d’actions frauduleuses.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3 — Transmission (piège « support »)",
    question: "Transmission (323-3) :",
    options: [
      "Diffusion à un tiers, quel qu’en soit le moyen ou support",
      "Seulement par internet",
      "Seulement par courrier",
    ],
    answer: "Diffusion à un tiers, quel qu’en soit le moyen ou support",
    explanation:
        "Le cours : transmission = toute diffusion, moyen indifférent.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3 — Modification vs introduction (piège)",
    question:
        "Pourquoi le cours dit qu’il est difficile de séparer modification/introduction/suppression ?",
    options: [
      "Pour modifier, il faut souvent ajouter/retirer/déplacer des données",
      "Parce que la loi l’interdit",
      "Parce que les données sont toujours chiffrées",
    ],
    answer:
        "Pour modifier, il faut souvent ajouter/retirer/déplacer des données",
    explanation:
        "Le cours : modifier implique souvent ajout/retrait/déplacement.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3 — Élément moral",
    question: "L’élément moral de 323-3 repose sur :",
    options: [
      "La violation délibérée d’un interdit (conscience du caractère non autorisé)",
      "Un résultat dommageable obligatoire",
      "Un profit obligatoire",
    ],
    answer:
        "La violation délibérée d’un interdit (conscience du caractère non autorisé)",
    explanation:
        "Le cours : l’auteur sait que ce n’est pas autorisé et veut cependant le résultat.",
    difficulty: "Moyenne",
  ),

  // =====================================================
  // 323-3 — AGGRAVATIONS (ÉTAT / BANDE / 323-4-2)
  // =====================================================
  const QuizQuestion(
    category: "323-3 — Aggravation État (peine)",
    question:
        "323-3 commis contre un STAD à caractère personnel mis en œuvre par l’État :",
    options: ["7 ans + 300 000 €", "5 ans + 150 000 €", "10 ans + 300 000 €"],
    answer: "7 ans + 300 000 €",
    explanation: "Tableau : aggravation État = 7 ans + 300 000 €.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-4-2 — Peine maximale (piège tableau)",
    question: "Quand 323-4-2 est retenu, la peine peut aller jusqu’à :",
    options: ["10 ans + 300 000 €", "7 ans + 300 000 €", "5 ans + 150 000 €"],
    answer: "10 ans + 300 000 €",
    explanation: "Le cours : aggravation 323-4-2 = 10 ans + 300 000 €.",
    difficulty: "Difficile",
  ),

  // =====================================================
  // 323-3-1 — OUTILS / PROGRAMMES (ULTRA-PIÈGES)
  // =====================================================
  const QuizQuestion(
    category: "323-3-1 — Définition",
    question: "323-3-1 réprime le fait (sans motif légitime) :",
    options: [
      "D’importer/détenir/offrir/céder/mettre à disposition des moyens adaptés",
      "De refuser de donner un mot de passe",
      "D’acheter un antivirus",
    ],
    answer:
        "D’importer/détenir/offrir/céder/mettre à disposition des moyens adaptés",
    explanation:
        "Le cours : incrimine la fourniture/possession de moyens conçus/adaptés pour 323-1 à 323-3.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3-1 — Motif légitime (V/F)",
    question:
        "Vrai/Faux : la recherche en sécurité informatique peut constituer un motif légitime.",
    options: ["Vrai", "Faux", "Jamais"],
    answer: "Vrai",
    explanation:
        "Le cours cite explicitement recherche/sécurité informatique parmi les motifs possibles.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "323-3-1 — Absence d’intention (piège)",
    question:
        "Vrai/Faux : l’absence d’intention de diffuser un virus exclut 323-3-1.",
    options: ["Vrai", "Faux", "Seulement si mineur"],
    answer: "Faux",
    explanation:
        "Le cours : la simple détention peut suffire, même sans volonté directe de nuire.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3-1 — Complicité (cas)",
    question:
        "Si l’outil est fourni et qu’une attaque est ensuite commise, le fournisseur peut être :",
    options: [
      "Poursuivi comme complice de l’infraction réalisée",
      "Toujours relaxé car il n’a pas attaqué",
      "Uniquement sanctionné disciplinairement",
    ],
    answer: "Poursuivi comme complice de l’infraction réalisée",
    explanation:
        "Le cours : si l’infraction est commise, le prévenu peut être poursuivi comme complice.",
    difficulty: "Difficile",
  ),

  // =====================================================
  // 323-4 — ASSOCIATION DE MALFAITEURS (ULTRA-PIÈGES)
  // =====================================================
  const QuizQuestion(
    category: "323-4 — Définition",
    question: "323-4 réprime :",
    options: [
      "Participation à un groupement/entente préparant des infractions 323-1 à 323-3-1",
      "Tout piratage isolé",
      "La simple possession d’un ordinateur",
    ],
    answer:
        "Participation à un groupement/entente préparant des infractions 323-1 à 323-3-1",
    explanation:
        "Le cours : préparation caractérisée par faits matériels + infractions visées 323-1 à 323-3-1.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-4 — Faits matériels (piège)",
    question: "Quel exemple illustre un « fait matériel » de préparation ?",
    options: [
      "Échanger des codes d’accès / méthodes de contournement",
      "Se plaindre d’un site lent",
      "Lire un article sur la cybersécurité",
    ],
    answer: "Échanger des codes d’accès / méthodes de contournement",
    explanation:
        "Le cours : échanges d’informations sur modes opératoires (codes, casser code…).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-4 — Connaissance partielle (piège concours)",
    question:
        "Vrai/Faux : chaque membre doit connaître toutes les activités des autres membres.",
    options: ["Vrai", "Faux", "Seulement en bande organisée"],
    answer: "Faux",
    explanation:
        "Le cours : pas nécessaire que chaque membre soit au courant de toutes les activités des autres.",
    difficulty: "Difficile",
  ),

  // =====================================================
  // MINI CAS — QUALIFICATION + ARTICLE + PEINE (PIÈGES)
  // =====================================================
  const QuizQuestion(
    category: "Cas concours — Qualification + peine",
    question:
        "Un agent « se promène » dans un système après avoir atterri dessus par erreur, mais reste et explore volontairement. Qualification la plus juste ?",
    options: [
      "Maintien frauduleux (323-1)",
      "Aucune infraction (accès initial par erreur)",
      "323-3 (modification de données)",
    ],
    answer: "Maintien frauduleux (323-1)",
    explanation:
        "Le maintien réprime les accès initiaux accidentels suivis d’un maintien volontaire sans droit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas concours — Qualification + peine",
    question:
        "Une personne copie des données (extraction) sans toucher au fonctionnement, puis les conserve chez elle. Qualification + peine de base ?",
    options: [
      "323-3 : 5 ans + 150 000 €",
      "323-1 : 3 ans + 100 000 €",
      "323-4 : 3 ans + 100 000 €",
    ],
    answer: "323-3 : 5 ans + 150 000 €",
    explanation: "323-3 vise extraction et détention frauduleuses de données.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas concours — Qualification + peine",
    question:
        "Un technicien installe un « cheval de Troie » pour pouvoir revenir plus tard. Qualification principale ?",
    options: [
      "323-1 (accès/maintien) + possible 323-3 (introduction de données)",
      "Uniquement 323-4",
      "Uniquement 323-3-1",
    ],
    answer: "323-1 (accès/maintien) + possible 323-3 (introduction de données)",
    explanation:
        "Le cours cite l’insertion d’un cheval de Troie et 323-3 vise l’introduction ; 323-1 vise l’accès sans droit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas concours — Qualification + peine",
    question:
        "Une intrusion empêche les secours d’être déclenchés pendant un sinistre. Peine maximale évoquée au cours ?",
    options: ["10 ans + 300 000 €", "7 ans + 300 000 €", "5 ans + 150 000 €"],
    answer: "10 ans + 300 000 €",
    explanation:
        "323-4-2 : obstacle aux secours / péril imminent → 10 ans + 300 000 €.",
    difficulty: "Difficile",
  ),

  // =====================================================
  // FLASH V/F — TRÈS PIÈGE (RÉVISIONS)
  // =====================================================
  const QuizQuestion(
    category: "Flash V/F — STAD",
    question: "Vrai/Faux : un radiotéléphone a déjà été jugé comme un STAD.",
    options: ["Vrai", "Faux", "Seulement si connecté à Internet"],
    answer: "Vrai",
    explanation: "Le cours cite : radiotéléphone = système (jurisprudence).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Flash V/F — STAD",
    question: "Vrai/Faux : un annuaire électronique peut constituer un STAD.",
    options: ["Vrai", "Faux", "Uniquement un site web moderne"],
    answer: "Vrai",
    explanation:
        "Le cours cite : annuaire électronique France Télécom = système.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Flash V/F — 323-1",
    question:
        "Vrai/Faux : l’infraction nécessite forcément un dispositif de protection (mot de passe).",
    options: ["Vrai", "Faux", "Seulement si données sensibles"],
    answer: "Faux",
    explanation:
        "Le cours : pas nécessaire qu’il y ait un dispositif de protection.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Flash V/F — 323-1",
    question:
        "Vrai/Faux : l’accès sans droit peut résulter du non-respect d’une procédure (code/paiement).",
    options: ["Vrai", "Faux", "Seulement si contrat signé"],
    answer: "Vrai",
    explanation:
        "Le cours : absence de droit = non-respect procédure imposée par le maître du système.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Flash V/F — 323-3",
    question:
        "Vrai/Faux : la manipulation de données sur support externe (clé USB) tombe automatiquement sous 323-3.",
    options: ["Vrai", "Faux", "Toujours"],
    answer: "Faux",
    explanation:
        "Le cours : action sur données sorties du système pas visée, sauf réintroduction.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Définition",
    question: "L’infraction 323-1 CP consiste à :",
    options: [
      "Accéder ou se maintenir frauduleusement dans tout ou partie d’un STAD",
      "Voler du matériel informatique",
      "Insulter un agent public en ligne",
    ],
    answer:
        "Accéder ou se maintenir frauduleusement dans tout ou partie d’un STAD",
    explanation:
        "323-1 CP : accès ou maintien frauduleux dans un système de traitement automatisé de données.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "323-1 — Texte",
    question:
        "Le texte qui réprime l’accès/maintien frauduleux dans un STAD est :",
    options: [
      "323-1 du Code pénal",
      "323-4 du Code pénal",
      "441-1 du Code pénal",
    ],
    answer: "323-1 du Code pénal",
    explanation:
        "Le cours : 323-1 définit et réprime l’accès ou le maintien dans un STAD.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "323-1 — Objet (piège)",
    question: "323-1 protège principalement :",
    options: [
      "La volonté du maître du système (accès autorisé vs non autorisé)",
      "Uniquement les données à caractère personnel",
      "Uniquement les systèmes publics",
    ],
    answer: "La volonté du maître du système (accès autorisé vs non autorisé)",
    explanation:
        "Le cours : les délits supposent le non-respect de la volonté du maître du système.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-1 — STAD (définition concours)",
    question: "Un STAD peut être décrit comme :",
    options: [
      "Ensemble matériel/logiciel capable de mémoriser et traiter de l’information",
      "Uniquement un ordinateur connecté à Internet",
      "Uniquement une base de données de l’État",
    ],
    answer:
        "Ensemble matériel/logiciel capable de mémoriser et traiter de l’information",
    explanation:
        "Le cours : ensemble de biens matériels et logiciels + mémoire + traitement + restitution.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-1 — STAD (piège composantes)",
    question: "Dans la notion de STAD, on inclut :",
    options: [
      "La machine, ses composants, et les programmes/logiciels",
      "Uniquement le serveur physique",
      "Uniquement le logiciel",
    ],
    answer: "La machine, ses composants, et les programmes/logiciels",
    explanation:
        "Le cours : le système peut être la machine, ses composants et les logiciels.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-1 — Jurisprudence (V/F)",
    question:
        "Vrai/Faux : un terminal de paiement peut être une partie intégrante d’un STAD.",
    options: ["Vrai", "Faux", "Seulement s’il est piraté"],
    answer: "Vrai",
    explanation:
        "Le cours : terminal de paiement fait partie du système carte bleue car il traite des données.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Accès (notion)",
    question: "Dans le cours, l’accès à un STAD correspond surtout à :",
    options: [
      "L’établissement d’une communication avec le système",
      "La destruction du serveur",
      "Le téléchargement d’un antivirus",
    ],
    answer: "L’établissement d’une communication avec le système",
    explanation:
        "Le cours : accès = communication avec le système (mode technique indifférent).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-1 — Accès (piège protection)",
    question:
        "Pour caractériser 323-1, faut-il un mot de passe ou une protection technique ?",
    options: [
      "Non, pas nécessaire",
      "Oui, obligatoire",
      "Oui, sinon c’est une contravention",
    ],
    answer: "Non, pas nécessaire",
    explanation:
        "Le cours : pas nécessaire que l’accès soit limité par un dispositif de protection.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Accès (piège dépassement autorisation)",
    question:
        "La personne est autorisée à accéder à une zone A mais force l’accès à une zone B :",
    options: [
      "Accès frauduleux (323-1)",
      "Pas d’infraction car elle était autorisée",
      "Seulement 323-4",
    ],
    answer: "Accès frauduleux (323-1)",
    explanation:
        "Le cours : « tout ou partie » → même habilité sur une partie, accès non autorisé sur une autre = 323-1.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Maintien (piège « promenade »)",
    question: "Le maintien « inoffensif » (simple promenade) :",
    options: [
      "Peut être incriminé (323-1) s’il est sans droit",
      "N’est jamais incriminé",
      "Est une simple faute civile",
    ],
    answer: "Peut être incriminé (323-1) s’il est sans droit",
    explanation: "Le cours : maintien inoffensif ou actif est incriminable.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Maintien (piège délit continu)",
    question: "Le maintien frauduleux est qualifié de délit continu car :",
    options: [
      "La prescription court à partir du moment où le maintien cesse",
      "La peine se multiplie automatiquement par jour",
      "Il n’y a jamais de prescription",
    ],
    answer: "La prescription court à partir du moment où le maintien cesse",
    explanation:
        "Le cours : délit continu → prescription à la fin du maintien.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Élément moral (piège erreur)",
    question: "L’accès par erreur :",
    options: [
      "N’est pas sanctionné si l’absence d’intention est crédible",
      "Est toujours sanctionné",
      "Devient automatiquement 323-3",
    ],
    answer: "N’est pas sanctionné si l’absence d’intention est crédible",
    explanation:
        "Le cours : accès par erreur non sanctionné ; l’appréciation dépend notamment des compétences.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Élément moral",
    question: "L’élément moral de 323-1 exige :",
    options: [
      "Conscience d’accéder/se maintenir sans droit contre le gré du maître",
      "Intention de nuire obligatoire",
      "But lucratif obligatoire",
    ],
    answer:
        "Conscience d’accéder/se maintenir sans droit contre le gré du maître",
    explanation:
        "Le cours : conscience d’agir sans droit ; mobile indifférent.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-1 — Mobile (V/F)",
    question:
        "Vrai/Faux : agir pour « démontrer une faille » supprime l’infraction 323-1.",
    options: ["Vrai", "Faux", "Seulement si aucun dommage"],
    answer: "Faux",
    explanation:
        "Le cours : mobile indifférent (jeu, prouesse, démonstration, rendre service).",
    difficulty: "Moyenne",
  ),

  // =====================================================
  // 323-1 — AGGRAVATIONS & PEINES (ULTRA-PIÈGES)
  // =====================================================
  const QuizQuestion(
    category: "323-1 — Aggravation (résultat)",
    question: "323-1 al.2 est caractérisé si :",
    options: [
      "Suppression/modification de données OU altération du fonctionnement",
      "Simple consultation de données",
      "Simple accès sans durée",
    ],
    answer:
        "Suppression/modification de données OU altération du fonctionnement",
    explanation: "Aggravation au résultat (données/fonctionnement).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-1 — Peine (al.2)",
    question: "Peine encourue pour 323-1 al.2 :",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "7 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation:
        "Tableau : 323-1 al.2 = 5 ans d’emprisonnement + 150 000 € d’amende.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-1 — Aggravation État (piège)",
    question: "323-1 al.3 suppose :",
    options: [
      "STAD à caractère personnel mis en œuvre par l’État",
      "Toute donnée personnelle (RGPD) chez un privé",
      "Toute administration (même délégataire privé)",
    ],
    answer: "STAD à caractère personnel mis en œuvre par l’État",
    explanation:
        "Aggravation spéciale : caractère personnel + mis en œuvre par l’État.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-1 — Peine (al.3)",
    question: "Peine encourue pour 323-1 al.3 :",
    options: ["7 ans + 300 000 €", "5 ans + 150 000 €", "10 ans + 300 000 €"],
    answer: "7 ans + 300 000 €",
    explanation:
        "Tableau : 323-1 al.3 = 7 ans d’emprisonnement + 300 000 € d’amende.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-4-1 — Bande organisée (piège)",
    question:
        "Lorsque l’infraction est commise en bande organisée (323-4-1), la peine peut aller jusqu’à :",
    options: ["10 ans + 300 000 €", "7 ans + 300 000 €", "5 ans + 150 000 €"],
    answer: "10 ans + 300 000 €",
    explanation:
        "Tableau : 323-4-1 = 10 ans d’emprisonnement + 300 000 € d’amende.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-4-2 — Risque personnes (piège)",
    question: "323-4-2 vise notamment :",
    options: [
      "Risque immédiat de mort/blessures graves ou obstacle aux secours",
      "Risque financier seulement",
      "Atteinte à la réputation en ligne",
    ],
    answer: "Risque immédiat de mort/blessures graves ou obstacle aux secours",
    explanation:
        "Le cours : risque immédiat + mutilation/infirmité permanente ou obstacle aux secours / sinistre.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-4-2 — Peine (max)",
    question: "Peine maximale en cas de 323-4-2 :",
    options: ["10 ans + 300 000 €", "7 ans + 300 000 €", "3 ans + 100 000 €"],
    answer: "10 ans + 300 000 €",
    explanation:
        "Tableau : 323-4-2 = 10 ans d’emprisonnement + 300 000 € d’amende.",
    difficulty: "Difficile",
  ),

  // =====================================================
  // 323-3 — DONNÉES (INTRO/EXTRACTION/DETENTION/REPRO/TRANSMISSION…)
  // =====================================================
  const QuizQuestion(
    category: "323-3 — Définition",
    question: "323-3 réprime notamment :",
    options: [
      "Introduire/extraire/détenir/reproduire/transmettre/supprimer/modifier frauduleusement des données",
      "Accéder sans droit à un système",
      "Former une entente pour pirater sans acte matériel",
    ],
    answer:
        "Introduire/extraire/détenir/reproduire/transmettre/supprimer/modifier frauduleusement des données",
    explanation:
        "Le cours : 323-3 vise toutes les actions frauduleuses sur les données du système.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "323-3 — Accès licite (piège)",
    question:
        "Pour 323-3, l’auteur doit-il avoir accédé frauduleusement au système ?",
    options: [
      "Non, accès licite ou non",
      "Oui, obligatoire",
      "Oui sauf si reproduction",
    ],
    answer: "Non, accès licite ou non",
    explanation:
        "Le cours : l’auteur peut avoir eu un accès licite ou non au système.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3 — Extraction (piège concours)",
    question: "L’extraction réprime notamment :",
    options: [
      "La simple copie des données sans soustraction",
      "Uniquement l’effacement définitif",
      "Uniquement le vol de disque dur",
    ],
    answer: "La simple copie des données sans soustraction",
    explanation:
        "Le cours : extraction protège les données même si elles restent chez le propriétaire.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3 — Détention (piège)",
    question: "La détention de données au sens de 323-3 peut ressembler à :",
    options: [
      "Un recel de données",
      "Un vol de matériel",
      "Une simple lecture",
    ],
    answer: "Un recel de données",
    explanation:
        "Le cours : détention = proche d’un recel de données extraites/reproduites/transmises frauduleusement.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3 — Reproduction",
    question: "La reproduction (323-3) vise :",
    options: [
      "Les actes de copie de données obtenues frauduleusement, quel que soit le support",
      "Uniquement la copie papier",
      "Uniquement le screenshot",
    ],
    answer:
        "Les actes de copie de données obtenues frauduleusement, quel que soit le support",
    explanation: "Le cours : reproduction = copie, support indifférent.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3 — Transmission",
    question: "La transmission (323-3) correspond à :",
    options: [
      "Toute diffusion à un tiers, moyen/support indifférent",
      "Uniquement un envoi par mail",
      "Uniquement un transfert payant",
    ],
    answer: "Toute diffusion à un tiers, moyen/support indifférent",
    explanation:
        "Le cours : transmission = diffusion à un tiers, quel qu’en soit moyen ou support.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3 — Suppression",
    question: "Supprimer des données peut notamment consister à :",
    options: [
      "Effacer/écraser des données ou les déplacer hors du système/zone réservée",
      "Débrancher l’écran",
      "Changer un mot de passe autorisé",
    ],
    answer:
        "Effacer/écraser des données ou les déplacer hors du système/zone réservée",
    explanation:
        "Le cours : suppression = atteinte physique (écrasement) ou déplacement hors/zone réservée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3 — Action hors système (piège)",
    question: "Action sur des données sorties du système (clé USB) :",
    options: [
      "En principe hors 323-3, sauf réintroduction dans le système",
      "Toujours 323-3",
      "Toujours 323-1",
    ],
    answer: "En principe hors 323-3, sauf réintroduction dans le système",
    explanation:
        "Le cours : manipulation de données sur support externe hors champ, sauf si réintroduites.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3 — Élément moral",
    question: "L’élément moral de 323-3 repose sur :",
    options: [
      "Violation délibérée d’un interdit (conscience + volonté du résultat)",
      "Une intention de nuire obligatoire",
      "Un enrichissement obligatoire",
    ],
    answer:
        "Violation délibérée d’un interdit (conscience + volonté du résultat)",
    explanation:
        "Le cours : l’auteur sait que ce n’est pas autorisé et veut cependant le résultat.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3 — Peine (base)",
    question: "Peine de base de 323-3 :",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "7 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation:
        "Tableau : 323-3 = 5 ans d’emprisonnement + 150 000 € d’amende.",
    difficulty: "Moyenne",
  ),

  // =====================================================
  // 323-3-1 — OUTILS / PROGRAMMES (MOYENS ADAPTÉS) — ULTRA PIÈGES
  // =====================================================
  const QuizQuestion(
    category: "323-3-1 — Définition",
    question: "323-3-1 vise (sans motif légitime) :",
    options: [
      "Importer/détenir/offrir/céder/mettre à disposition des moyens conçus/adaptés pour 323-1 à 323-3",
      "Accéder sans droit à une base",
      "Refuser une perquisition informatique",
    ],
    answer:
        "Importer/détenir/offrir/céder/mettre à disposition des moyens conçus/adaptés pour 323-1 à 323-3",
    explanation:
        "Le cours : incrimine la fourniture/possession d’outils/données adaptés pour commettre les atteintes STAD.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3-1 — Actes visés (piège)",
    question: "Les actes visés incluent :",
    options: [
      "Importation + détention + offre + cession + mise à disposition",
      "Seulement importation",
      "Seulement mise à disposition payante",
    ],
    answer: "Importation + détention + offre + cession + mise à disposition",
    explanation: "Le cours liste exactement ces 5 comportements.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-3-1 — Motif légitime (piège)",
    question: "Un motif légitime peut être :",
    options: [
      "Recherche/sécurité informatique",
      "Simple curiosité",
      "Envie de tester sur des voisins",
    ],
    answer: "Recherche/sécurité informatique",
    explanation:
        "Le cours : recherche scientifique/technique et sécurisation peuvent constituer un motif légitime.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3-1 — Élément moral (piège concours)",
    question: "323-3-1 exige forcément une intention directe de nuire :",
    options: ["Faux", "Vrai", "Seulement si virus"],
    answer: "Faux",
    explanation:
        "Le cours : la simple détention peut être réprimée même sans intention de diffuser/contaminer.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-3-1 — Tentative (V/F)",
    question:
        "Vrai/Faux : la tentative est punissable pour les atteintes STAD (chapitre).",
    options: ["Vrai", "Faux", "Seulement pour 323-4"],
    answer: "Vrai",
    explanation:
        "Le cours : tentative spécialement prévue et réprimée par 323-7 CP (notamment 323-1 et 323-3).",
    difficulty: "Moyenne",
  ),

  // =====================================================
  // 323-4 — ASSOCIATION DE MALFAITEURS EN INFORMATIQUE
  // =====================================================
  const QuizQuestion(
    category: "323-4 — Définition",
    question: "L’association de malfaiteurs en informatique (323-4) vise :",
    options: [
      "Participation à un groupement/entente préparant des infractions 323-1 à 323-3-1",
      "Toute intrusion isolée",
      "Toute erreur de manipulation informatique",
    ],
    answer:
        "Participation à un groupement/entente préparant des infractions 323-1 à 323-3-1",
    explanation:
        "Le cours : préparation caractérisée par faits matériels d’infractions visées 323-1 à 323-3-1.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-4 — Nombre de participants (piège)",
    question: "Le nombre de participants requis pour une « entente » :",
    options: ["Peut être 2", "Minimum 5", "Minimum 3"],
    answer: "Peut être 2",
    explanation: "Le cours : entente retenue pour deux personnes (exemple).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-4 — Faits matériels (piège)",
    question: "Un fait matériel de préparation peut être :",
    options: [
      "Échange de codes d’accès / méthodes pour casser un code",
      "Lecture d’un forum sans poster",
      "Achat d’un ordinateur",
    ],
    answer: "Échange de codes d’accès / méthodes pour casser un code",
    explanation:
        "Le cours : échanges d’infos sur la réalisation (codes, moyen de casser…).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "323-4 — Élément moral",
    question: "L’élément moral suppose :",
    options: [
      "Participation volontaire + conscience de l’objet délictueux de l’entente",
      "Intention de nuire obligatoire",
      "Résultat dommageable obligatoire",
    ],
    answer:
        "Participation volontaire + conscience de l’objet délictueux de l’entente",
    explanation:
        "Le cours : participation volontaire et connaissance de la préparation d’infractions STAD.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "323-4 — Connaissance (piège concours)",
    question: "Chaque membre doit connaître toutes les activités des autres :",
    options: ["Faux", "Vrai", "Seulement si chef"],
    answer: "Faux",
    explanation:
        "Le cours : pas nécessaire que chaque membre connaisse toutes les activités des autres.",
    difficulty: "Difficile",
  ),

  // =====================================================
  // QCM « ULTRA-PIÈGES » — DISTINCTIONS ENTRE 323-1 / 323-3 / 323-3-1 / 323-4
  // =====================================================
  const QuizQuestion(
    category: "QCM piège — Bonne qualification",
    question:
        "Quel texte vise spécifiquement la fourniture/détention d’outils conçus pour attaquer un STAD ?",
    options: ["323-3-1", "323-1", "323-3"],
    answer: "323-3-1",
    explanation:
        "323-3-1 : moyens adaptés (programme, instrument, donnée) sans motif légitime.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QCM piège — Bonne qualification",
    question:
        "Quel texte vise l’action directe sur les données (copie, suppression, modification) ?",
    options: ["323-3", "323-1", "323-4"],
    answer: "323-3",
    explanation:
        "323-3 : actions frauduleuses sur les données contenues dans le système.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QCM piège — Bonne qualification",
    question:
        "Quel texte vise l’accès sans droit, même sans toucher aux données ?",
    options: ["323-1", "323-3", "323-3-1"],
    answer: "323-1",
    explanation: "323-1 : accès/maintien frauduleux, même « promenade ». ",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QCM piège — Bonne qualification",
    question:
        "Quel texte vise la participation à une entente préparant des atteintes STAD, matérialisée par des échanges de moyens ?",
    options: ["323-4", "323-1", "323-3-1"],
    answer: "323-4",
    explanation: "323-4 : groupement/entente + préparation + faits matériels.",
    difficulty: "Difficile",
  ),

  // =====================================================
  // MINI CAS — QUALIFICATION + ARTICLE + PEINE (CONCOURS)
  // =====================================================
  const QuizQuestion(
    category: "Cas concours — Qualification + peine",
    question:
        "A se connecte sans autorisation à une base. Il ne modifie rien. Qualification + peine ?",
    options: [
      "323-1 al.1 : 3 ans + 100 000 €",
      "323-3 : 5 ans + 150 000 €",
      "323-4 : 3 ans + 100 000 €",
    ],
    answer: "323-1 al.1 : 3 ans + 100 000 €",
    explanation: "Accès frauduleux simple (323-1 al.1).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas concours — Qualification + peine",
    question:
        "B accède sans droit et efface des logs, provoquant aussi un dysfonctionnement. Qualification la plus complète côté aggravation ?",
    options: [
      "323-1 al.2 (résultat sur données/fonctionnement) : 5 ans + 150 000 €",
      "323-1 al.1 seulement",
      "323-4 uniquement",
    ],
    answer:
        "323-1 al.2 (résultat sur données/fonctionnement) : 5 ans + 150 000 €",
    explanation:
        "Suppression/modification ou altération du fonctionnement → aggravation 323-1 al.2.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas concours — Qualification + peine",
    question:
        "C copie des données (sans les supprimer) puis les transmet à un tiers. Qualification principale + peine base ?",
    options: [
      "323-3 : 5 ans + 150 000 €",
      "323-1 : 3 ans + 100 000 €",
      "323-3-1 : 3 ans + 100 000 €",
    ],
    answer: "323-3 : 5 ans + 150 000 €",
    explanation: "Extraction/reproduction/transmission frauduleuse = 323-3.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas concours — Qualification + peine",
    question:
        "D conserve chez lui un malware conçu pour attaquer des STAD, sans motif légitime établi. Qualification ?",
    options: [
      "323-3-1 (détention d’un programme adapté)",
      "323-1 (accès frauduleux)",
      "323-4 (association) automatiquement",
    ],
    answer: "323-3-1 (détention d’un programme adapté)",
    explanation:
        "323-3-1 réprime la détention/offre/cession/mise à disposition de moyens adaptés sans motif légitime.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas concours — Qualification + peine",
    question:
        "E et F échangent codes/techniques pour préparer une intrusion, mais aucun accès n’a encore été réalisé. Qualification ?",
    options: [
      "323-4 (association de malfaiteurs en informatique)",
      "323-1 (tentative d’accès)",
      "Aucune infraction (tant que rien n’est fait)",
    ],
    answer: "323-4 (association de malfaiteurs en informatique)",
    explanation:
        "Groupement/entente + préparation + faits matériels (échanges de codes/techniques).",
    difficulty: "Difficile",
  ),

  // =====================================================
  // FLASH V/F — ARTICLES / PEINES / PRINCIPES (MODE RÉVISIONS RAPIDES)
  // =====================================================
  const QuizQuestion(
    category: "Flash V/F — 323-1",
    question:
        "Vrai/Faux : l’accès peut être frauduleux même si le système n’a aucun mot de passe.",
    options: ["Vrai", "Faux", "Seulement si l’État"],
    answer: "Vrai",
    explanation:
        "Le cours : pas nécessaire d’un dispositif de protection ; volonté du maître suffit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Flash V/F — 323-3",
    question:
        "Vrai/Faux : modifier des données enregistrées définitivement dans un système peut relever de 323-3.",
    options: ["Vrai", "Faux", "Seulement si elles sont publiques"],
    answer: "Vrai",
    explanation:
        "Le cours cite la modification de données comptables enregistrées définitivement.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Flash V/F — 323-3-1",
    question:
        "Vrai/Faux : l’absence de liste précise des « motifs légitimes » laisse l’appréciation aux magistrats.",
    options: ["Vrai", "Faux", "Motifs fixés uniquement par décret"],
    answer: "Vrai",
    explanation:
        "Le cours : notion imprécise → appréciation par les magistrats.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Définition",
    question: "La demande de fonds sous contrainte consiste à :",
    options: [
      "Solliciter sur la voie publique la remise de fonds, en réunion et de manière agressive ou sous la menace d’un animal dangereux",
      "Obtenir des fonds par menaces de violences",
      "Se faire remettre des fonds par manœuvres frauduleuses",
    ],
    answer:
        "Solliciter sur la voie publique la remise de fonds, en réunion et de manière agressive ou sous la menace d’un animal dangereux",
    explanation:
        "312-12-1 CP : comportement de mendicité agressive en réunion ou sous menace d’un animal dangereux.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Distinction",
    question:
        "La demande de fonds sous contrainte se distingue de l’extorsion par :",
    options: [
      "Les moyens employés (réunion agressive ou animal dangereux)",
      "L’absence totale de menace",
      "Le caractère contractuel de la remise",
    ],
    answer: "Les moyens employés (réunion agressive ou animal dangereux)",
    explanation:
        "Elle ne repose pas sur violences ou menaces de violences caractérisant l’extorsion.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte — Élément matériel",
    question: "La remise effective des fonds est-elle nécessaire ?",
    options: ["Oui", "Non", "Seulement si la somme est élevée"],
    answer: "Non",
    explanation:
        "Le délit est constitué par la seule sollicitation sur la voie publique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte — Peines",
    question: "Peines prévues par l’article 312-12-1 CP :",
    options: [
      "6 mois d’emprisonnement et 3 750 € d’amende",
      "1 an d’emprisonnement et 15 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "6 mois d’emprisonnement et 3 750 € d’amende",
    explanation:
        "Délit simple, sans circonstance aggravante prévue par le texte.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte — Tentative / Complicité",
    question: "Concernant 312-12-1 CP :",
    options: [
      "Tentative non, complicité oui",
      "Tentative oui, complicité oui",
      "Tentative non, complicité non",
    ],
    answer: "Tentative non, complicité oui",
    explanation:
        "Le délit est consommé dès la sollicitation ; complicité possible (art. 121-7 CP).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Abus de confiance (314-1) — Définition",
    question: "L’abus de confiance est :",
    options: [
      "Le détournement d’un bien remis à titre précaire",
      "La soustraction frauduleuse d’un bien",
      "L’obtention d’un bien par manœuvres frauduleuses",
    ],
    answer: "Le détournement d’un bien remis à titre précaire",
    explanation:
        "314-1 CP : remise préalable acceptée à charge de restitution, représentation ou usage déterminé.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Remise préalable",
    question: "La remise préalable peut résulter :",
    options: [
      "D’un contrat, de la loi, d’une décision de justice ou d’une situation de fait",
      "Uniquement d’un contrat écrit",
      "Uniquement d’une décision judiciaire",
    ],
    answer:
        "D’un contrat, de la loi, d’une décision de justice ou d’une situation de fait",
    explanation: "La jurisprudence admet des cadres très larges de remise.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Détournement (piège)",
    question:
        "Le simple retard de restitution constitue toujours un abus de confiance.",
    options: ["Vrai", "Faux", "Seulement en cas de plainte"],
    answer: "Faux",
    explanation: "Le retard n’est délictueux que s’il devient frauduleux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Élément moral",
    question: "L’élément moral de l’abus de confiance repose sur :",
    options: [
      "La conscience de la précarité de la détention et la volonté de la transgresser",
      "La simple imprudence",
      "La préméditation obligatoire",
    ],
    answer:
        "La conscience de la précarité de la détention et la volonté de la transgresser",
    explanation: "Infraction intentionnelle nécessitant la mauvaise foi.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Peines",
    question: "Peines de l’abus de confiance simple (314-1 CP) :",
    options: [
      "5 ans d’emprisonnement et 375 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "7 ans d’emprisonnement et 750 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 375 000 € d’amende",
    explanation: "Peines de base prévues par l’article 314-1 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Chantage (312-10) — Définition",
    question: "Le chantage consiste à :",
    options: [
      "Obtenir une remise ou un engagement par menace de révélation diffamatoire",
      "Obtenir un bien par violences",
      "Obtenir un bien par tromperie",
    ],
    answer:
        "Obtenir une remise ou un engagement par menace de révélation diffamatoire",
    explanation:
        "312-10 CP : menace de révélation ou d’imputation de faits portant atteinte à l’honneur ou à la considération.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Chantage — Fait vrai ou faux (piège)",
    question:
        "Le fait menacé doit être nécessairement faux pour caractériser le chantage.",
    options: ["Vrai", "Faux", "Seulement si écrit"],
    answer: "Faux",
    explanation: "Peu importe que le fait soit vrai ou faux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Chantage — Tentative",
    question: "La tentative de chantage est :",
    options: ["Punissable", "Non punissable", "Punissable seulement si écrite"],
    answer: "Punissable",
    explanation: "Article 312-12 CP : la tentative est expressément prévue.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Filouterie (313-5) — Définition",
    question: "La filouterie consiste à :",
    options: [
      "Se faire fournir certains biens ou services en sachant qu’on ne paiera pas",
      "Soustraire frauduleusement un bien",
      "Obtenir un bien par menaces",
    ],
    answer:
        "Se faire fournir certains biens ou services en sachant qu’on ne paiera pas",
    explanation: "313-5 CP : protection de certains professionnels.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Filouterie — Cas visés",
    question: "L’article 313-5 CP vise notamment :",
    options: [
      "Restaurants, hôtels, taxis, stations-service",
      "Tous les commerces",
      "Uniquement les hôtels",
    ],
    answer: "Restaurants, hôtels, taxis, stations-service",
    explanation: "Liste limitative prévue par le texte.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Filouterie — Tentative",
    question: "La tentative de filouterie est :",
    options: ["Punissable", "Non punissable", "Punissable en récidive"],
    answer: "Non punissable",
    explanation: "La tentative n’est pas prévue par l’article 313-5 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Escroquerie (313-1) — Définition",
    question: "L’escroquerie suppose notamment :",
    options: [
      "Un moyen de tromperie déterminant la remise",
      "Une violence",
      "Une contrainte physique",
    ],
    answer: "Un moyen de tromperie déterminant la remise",
    explanation:
        "Usage de faux nom, fausse qualité, abus de qualité vraie ou manœuvres frauduleuses.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Escroquerie — Mensonge simple (piège)",
    question:
        "Un simple mensonge non appuyé par un acte suffit à caractériser l’escroquerie.",
    options: ["Vrai", "Faux", "Seulement si la victime est vulnérable"],
    answer: "Faux",
    explanation: "Les simples mensonges ne suffisent pas sans manœuvres.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Escroquerie — Peines simples",
    question: "Peines de l’escroquerie simple (313-1 CP) :",
    options: [
      "5 ans d’emprisonnement et 375 000 € d’amende",
      "7 ans d’emprisonnement et 750 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 375 000 € d’amende",
    explanation: "Peines de base prévues par l’article 313-1 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Extorsion (312-1) — Définition",
    question: "L’extorsion est :",
    options: [
      "L’obtention d’une remise par violence, menace de violences ou contrainte",
      "L’obtention d’une remise par tromperie",
      "La soustraction frauduleuse",
    ],
    answer:
        "L’obtention d’une remise par violence, menace de violences ou contrainte",
    explanation: "312-1 CP : remise forcée mais consciente de la victime.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Extorsion — Tentative",
    question: "La tentative d’extorsion est :",
    options: ["Punissable", "Non punissable", "Punissable seulement en bande"],
    answer: "Punissable",
    explanation: "Article 312-9 CP : tentative expressément prévue.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Extorsion — Qualification",
    question:
        "L’extorsion avec violences ayant entraîné plus de 8 jours d’ITT est :",
    options: ["Un crime", "Un délit aggravé", "Une contravention"],
    answer: "Un crime",
    explanation: "Article 312-3 CP : extorsion criminelle.",
    difficulty: "Moyenne",
  ),

  // =========================
  // DEMANDE DE FONDS SOUS CONTRAINTE — 312-12-1
  // =========================
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Conditions",
    question:
        "Pour caractériser la demande de fonds sous contrainte « en réunion », il faut :",
    options: [
      "Au moins deux auteurs",
      "Au moins trois auteurs",
      "Un auteur seul mais agressif",
    ],
    answer: "Au moins deux auteurs",
    explanation:
        "Le texte vise un comportement commis par deux auteurs au moins se livrant à une mendicité agressive.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Lieu",
    question: "La sollicitation doit être effectuée :",
    options: [
      "Sur la voie publique",
      "Uniquement dans un commerce",
      "Uniquement au domicile de la victime",
    ],
    answer: "Sur la voie publique",
    explanation: "312-12-1 CP : sollicitation sur la voie publique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Objet",
    question: "La sollicitation peut porter sur :",
    options: [
      "Des fonds, des valeurs ou un bien",
      "Uniquement de l’argent liquide",
      "Uniquement des denrées alimentaires",
    ],
    answer: "Des fonds, des valeurs ou un bien",
    explanation:
        "Le texte vise fonds/valeurs/bien (objet/denrée à valeur marchande).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Animal dangereux",
    question: "L’expression « animal dangereux » renvoie :",
    options: [
      "À tout animal présentant un danger apparent ou raisonnablement supposé",
      "Uniquement aux chiens de catégorie 1 ou 2",
      "Uniquement aux animaux sauvages",
    ],
    answer:
        "À tout animal présentant un danger apparent ou raisonnablement supposé",
    explanation:
        "Le critère est la dangerosité apparente/supposée et la contrainte exercée via l’animal.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Intention",
    question: "L’élément moral suppose :",
    options: [
      "La conscience d’un comportement menaçant pour obtenir une remise",
      "La volonté de se venger de la victime",
      "La préméditation obligatoire",
    ],
    answer: "La conscience d’un comportement menaçant pour obtenir une remise",
    explanation:
        "Intention : savoir que la remise ne résulterait pas d’un accord librement consenti.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category:
        "Demande de fonds sous contrainte (312-12-1) — Qualification (piège)",
    question:
        "Si des menaces de violences caractérisées sont utilisées pour obtenir l’argent, on retient forcément :",
    options: [
      "Plutôt l’extorsion selon les faits",
      "Toujours 312-12-1",
      "Toujours la filouterie",
    ],
    answer: "Plutôt l’extorsion selon les faits",
    explanation:
        "312-12-1 vise la mendicité agressive ; des menaces/violences peuvent basculer vers l’extorsion selon l’ITT et les circonstances.",
    difficulty: "Difficile",
  ),

  // =========================
  // ABUS DE CONFIANCE — 314-1 et suivants
  // =========================
  const QuizQuestion(
    category: "Abus de confiance (314-1) — Choses visées",
    question: "Quelles catégories sont visées par 314-1 CP ?",
    options: [
      "Fonds, valeurs ou bien quelconque",
      "Uniquement les fonds",
      "Uniquement les biens immobiliers",
    ],
    answer: "Fonds, valeurs ou bien quelconque",
    explanation:
        "Le texte vise fonds/valeurs/bien quelconque remis à charge de restituer/représenter/usage déterminé.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Abus de confiance (314-1) — Remise libre",
    question: "Dans l’abus de confiance, la remise initiale est :",
    options: [
      "Libre et consentie, puis détournée",
      "Toujours forcée par violence",
      "Toujours obtenue par manœuvres frauduleuses",
    ],
    answer: "Libre et consentie, puis détournée",
    explanation:
        "La remise est préalable et acceptée à titre précaire ; le détournement survient ensuite.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Titre précaire",
    question: "La remise « à titre précaire » signifie :",
    options: [
      "Le bénéficiaire n’a pas la libre disposition du bien",
      "Le bénéficiaire devient propriétaire",
      "La remise est impossible sans écrit",
    ],
    answer: "Le bénéficiaire n’a pas la libre disposition du bien",
    explanation:
        "Il doit rendre/représenter/faire un usage déterminé : prérogatives limitées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Preuve de la remise (piège)",
    question:
        "En cas de simple situation de fait (relation amicale), la remise se prouve :",
    options: [
      "Par tous moyens, sans se fonder sur de simples présomptions ou témoignages isolés",
      "Uniquement par écrit",
      "Uniquement par aveu",
    ],
    answer:
        "Par tous moyens, sans se fonder sur de simples présomptions ou témoignages isolés",
    explanation:
        "Le cours précise : preuve libre mais ne saurait reposer sur de simples présomptions ou témoignages.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Détournement",
    question: "Le détournement peut notamment consister en :",
    options: [
      "Refus de restituer, impossibilité de restituer, transgression de l’affectation",
      "Uniquement une vente du bien",
      "Uniquement un oubli de restitution",
    ],
    answer:
        "Refus de restituer, impossibilité de restituer, transgression de l’affectation",
    explanation:
        "Le détournement recouvre plusieurs formes : usage contraire, refus, disparition, etc.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Mise en demeure (piège)",
    question:
        "Une mise en demeure de restituer est toujours nécessaire pour caractériser l’abus de confiance.",
    options: ["Vrai", "Faux", "Seulement pour les véhicules loués"],
    answer: "Faux",
    explanation:
        "La jurisprudence retient que le délit peut être caractérisé par le seul détournement sans mise en demeure.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Préjudice",
    question: "Le préjudice exigé :",
    options: [
      "Peut être matériel ou moral, réel ou éventuel",
      "Doit être uniquement matériel et chiffré",
      "Doit être uniquement moral",
    ],
    answer: "Peut être matériel ou moral, réel ou éventuel",
    explanation:
        "Il suffit que l’acte soit susceptible de priver la victime de ses droits.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Aggravation",
    question: "Une circonstance aggravante spécifique est :",
    options: [
      "La bande organisée (314-1-1)",
      "La nuit",
      "La récidive obligatoire",
    ],
    answer: "La bande organisée (314-1-1)",
    explanation: "314-1-1 CP : abus de confiance commis en bande organisée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Tentative",
    question: "La tentative d’abus de confiance :",
    options: [
      "Est punissable",
      "N’est jamais punissable",
      "Est punissable seulement si le préjudice est réalisé",
    ],
    answer: "Est punissable",
    explanation:
        "La tentative est expressément prévue (cours : tentative toujours punissable).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Immunité familiale",
    question:
        "L’immunité familiale est-elle applicable à l’abus de confiance ?",
    options: ["Oui", "Non", "Seulement en cas de bande organisée"],
    answer: "Oui",
    explanation:
        "314-4 CP : renvoi à l’immunité familiale de 311-12 applicable à l’abus de confiance.",
    difficulty: "Moyenne",
  ),

  // =========================
  // CHANTAGE — 312-10 à 312-12
  // =========================
  const QuizQuestion(
    category: "Chantage (312-10) — Nature de la menace",
    question: "La menace constitutive du chantage est :",
    options: [
      "Une menace de révélation ou d’imputation diffamatoire",
      "Une menace de violences",
      "Une menace de dégradation avec condition",
    ],
    answer: "Une menace de révélation ou d’imputation diffamatoire",
    explanation:
        "Le chantage se distingue de l’extorsion par la nature diffamatoire de la menace.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Chantage — Forme",
    question: "La menace dans le chantage peut être :",
    options: [
      "Écrite ou orale",
      "Uniquement écrite",
      "Uniquement par voie de presse",
    ],
    answer: "Écrite ou orale",
    explanation: "Le texte ne distingue pas : menace verbale ou écrite.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Chantage — Menaces implicites",
    question:
        "La menace doit-elle forcément énoncer clairement le fait diffamatoire ?",
    options: [
      "Non, une menace implicite compréhensible peut suffire",
      "Oui, le fait doit être précisément détaillé",
      "Oui, et uniquement par écrit",
    ],
    answer: "Non, une menace implicite compréhensible peut suffire",
    explanation:
        "La jurisprudence admet les menaces voilées/sous-entendues si la pression est claire pour la victime.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Chantage — Objet recherché",
    question: "Le chantage peut viser notamment :",
    options: [
      "Une signature, un engagement, une renonciation, la révélation d’un secret, ou une remise",
      "Uniquement de l’argent",
      "Uniquement une signature",
    ],
    answer:
        "Une signature, un engagement, une renonciation, la révélation d’un secret, ou une remise",
    explanation:
        "312-10 CP liste plusieurs objets possibles, comme l’extorsion.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Chantage — Mise à exécution",
    question: "Quand la menace est mise à exécution, on applique :",
    options: ["312-11 CP", "312-2 CP", "313-2 CP"],
    answer: "312-11 CP",
    explanation:
        "312-11 CP : aggravation lorsque l’auteur a mis la menace à exécution.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Chantage — Peines simples",
    question: "Peines du chantage simple (312-10) :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "6 mois d’emprisonnement et 7 500 € d’amende",
      "7 ans d’emprisonnement et 750 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "312-10 CP : 5 ans et 75 000 € (cours).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Chantage — Aggravation en ligne",
    question: "Le chantage est aggravé notamment lorsqu’il est exercé :",
    options: [
      "Par un service de communication au public en ligne avec images/vidéos à caractère sexuel",
      "Par téléphone uniquement",
      "Sur la voie publique uniquement",
    ],
    answer:
        "Par un service de communication au public en ligne avec images/vidéos à caractère sexuel",
    explanation:
        "312-10 al.3 CP : aggravation liée au mode de diffusion en ligne et contenus sexuels.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Chantage — Immunité familiale",
    question: "L’immunité familiale s’applique au chantage ?",
    options: ["Oui", "Non", "Uniquement si la victime est un ascendant"],
    answer: "Oui",
    explanation: "312-12 al.2 CP : renvoi à 311-12.",
    difficulty: "Moyenne",
  ),

  // =========================
  // FILOUTERIE — 313-5
  // =========================
  const QuizQuestion(
    category: "Filouterie (313-5) — Spécificité",
    question: "La filouterie se distingue du vol car :",
    options: [
      "La remise est volontaire (mode normal de la profession)",
      "Il y a soustraction frauduleuse",
      "Elle suppose des violences",
    ],
    answer: "La remise est volontaire (mode normal de la profession)",
    explanation:
        "Le professionnel fournit volontairement selon ses usages ; pas de soustraction.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Filouterie (313-5) — Spécificité vs escroquerie",
    question: "La filouterie se distingue de l’escroquerie car :",
    options: [
      "La remise ne résulte pas de manœuvres frauduleuses",
      "Elle suppose un faux nom",
      "Elle suppose une fausse qualité",
    ],
    answer: "La remise ne résulte pas de manœuvres frauduleuses",
    explanation:
        "Pas de tromperie déterminante : la remise résulte des usages professionnels.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Filouterie — Condition d’impécuniosité",
    question: "L’« impossibilité absolue de payer » signifie :",
    options: [
      "Aucun moyen de paiement sur soi ET aucune ressource/patrimoine pour payer",
      "Ne pas avoir de liquide sur soi uniquement",
      "Avoir oublié son portefeuille",
    ],
    answer:
        "Aucun moyen de paiement sur soi ET aucune ressource/patrimoine pour payer",
    explanation:
        "Condition très exigeante (absolue) + connaissance par l’auteur.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Filouterie — Restaurant",
    question: "Pour le 1° (boissons/aliments), il faut notamment :",
    options: [
      "Que l’auteur passe commande (prenne l’initiative)",
      "Que l’auteur vole en cuisine",
      "Que les denrées soient obligatoirement consommées",
    ],
    answer: "Que l’auteur passe commande (prenne l’initiative)",
    explanation:
        "« Se faire servir » : initiative de commande, consommation non nécessaire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Filouterie — Hôtel (10 jours)",
    question: "Pour la filouterie d’hôtel, l’occupation :",
    options: [
      "Ne doit pas excéder dix jours",
      "Doit excéder dix jours",
      "Peut être illimitée",
    ],
    answer: "Ne doit pas excéder dix jours",
    explanation:
        "313-5 : condition spécifique au 2° (chambres) : occupation ≤ 10 jours.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Filouterie — Station-service (piège)",
    question:
        "Prendre du carburant en station libre-service et partir sans payer caractérise :",
    options: [
      "Plutôt un vol (selon le cours/jurisprudence)",
      "Une filouterie",
      "Un chantage",
    ],
    answer: "Plutôt un vol (selon le cours/jurisprudence)",
    explanation:
        "La filouterie suppose « se faire servir » par un professionnel ; en libre-service, la qualification peut être le vol.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Filouterie — Taxi",
    question: "La filouterie « taxi » vise :",
    options: [
      "Se faire transporter puis ne pas payer la course",
      "Monter sans payer dans un bus",
      "Refuser de payer un billet de train",
    ],
    answer: "Se faire transporter puis ne pas payer la course",
    explanation:
        "313-5 : 4° taxi/voiture de place (pas les transports en commun).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Filouterie — Peines",
    question: "Peines de la filouterie (313-5 CP) :",
    options: [
      "6 mois d’emprisonnement et 7 500 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 375 000 € d’amende",
    ],
    answer: "6 mois d’emprisonnement et 7 500 € d’amende",
    explanation: "313-5 CP : 6 mois et 7 500 €.",
    difficulty: "Facile",
  ),

  // =========================
  // ESCROQUERIE — 313-1 et suivants
  // =========================
  const QuizQuestion(
    category: "Escroquerie (313-1) — Moyens",
    question: "Quels moyens sont visés par 313-1 CP ?",
    options: [
      "Faux nom, fausse qualité, abus de qualité vraie, manœuvres frauduleuses",
      "Violences, menaces, contrainte",
      "Révélation diffamatoire",
    ],
    answer:
        "Faux nom, fausse qualité, abus de qualité vraie, manœuvres frauduleuses",
    explanation: "Les 4 formes de tromperie prévues par le texte.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Escroquerie — Caractère déterminant",
    question: "Le moyen frauduleux doit être :",
    options: [
      "Déterminant de la remise et résulter d’un comportement actif",
      "Postérieur à la remise",
      "Sans lien avec la remise",
    ],
    answer: "Déterminant de la remise et résulter d’un comportement actif",
    explanation:
        "Le procédé doit provoquer la remise et être antérieur/déterminant.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Escroquerie — Fausse qualité",
    question: "La « qualité » peut notamment être :",
    options: [
      "Un attribut de nature à inspirer confiance (profession/titre/état…)",
      "Uniquement un prénom",
      "Uniquement un surnom",
    ],
    answer:
        "Un attribut de nature à inspirer confiance (profession/titre/état…)",
    explanation:
        "Notion large : attribut juridique ou particularité donnant crédit.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Escroquerie — Abus de qualité vraie",
    question: "L’abus de qualité vraie correspond à :",
    options: [
      "Utiliser une qualité réelle pour donner force et crédit à des mensonges",
      "Inventer un faux nom",
      "Menacer de violences",
    ],
    answer:
        "Utiliser une qualité réelle pour donner force et crédit à des mensonges",
    explanation: "Qualité réellement détenue, détournée pour tromper.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Escroquerie — Manœuvres frauduleuses (composition)",
    question: "Les manœuvres frauduleuses peuvent notamment être :",
    options: [
      "Production d’écrits, mise en scène, intervention d’un tiers",
      "Uniquement un mensonge verbal",
      "Uniquement une violence",
    ],
    answer: "Production d’écrits, mise en scène, intervention d’un tiers",
    explanation: "Triade classique retenue par la jurisprudence.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Escroquerie — Remise",
    question: "La remise en escroquerie peut consister en :",
    options: [
      "Fonds/valeurs/bien, fourniture d’un service, ou acte opérant obligation/décharge",
      "Uniquement de l’argent liquide",
      "Uniquement un bien mobilier",
    ],
    answer:
        "Fonds/valeurs/bien, fourniture d’un service, ou acte opérant obligation/décharge",
    explanation: "313-1 CP : 3 types de remise/acte visés.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Escroquerie — Préjudice",
    question: "Le préjudice est :",
    options: [
      "Indispensable à l’existence de l’escroquerie",
      "Facultatif si la tromperie est prouvée",
      "Toujours présumé sans discussion",
    ],
    answer: "Indispensable à l’existence de l’escroquerie",
    explanation: "Sans préjudice, un élément manque (cours).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Escroquerie — Tentative",
    question: "La tentative d’escroquerie est :",
    options: [
      "Toujours punissable (simple ou aggravée)",
      "Jamais punissable",
      "Punissable uniquement en récidive",
    ],
    answer: "Toujours punissable (simple ou aggravée)",
    explanation: "313-3 CP : tentative expressément prévue.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Escroquerie — Immunité familiale",
    question: "L’immunité familiale s’applique à l’escroquerie ?",
    options: ["Oui", "Non", "Seulement si la victime est un conjoint"],
    answer: "Oui",
    explanation: "313-3 al.2 CP : renvoi à 311-12.",
    difficulty: "Moyenne",
  ),

  // =========================
  // EXTORSION — 312-1 à 312-9
  // =========================
  const QuizQuestion(
    category: "Extorsion (312-1) — Moyens",
    question: "L’extorsion suppose :",
    options: [
      "Violence, menace de violences ou contrainte",
      "Manœuvres frauduleuses",
      "Menace de révélation diffamatoire",
    ],
    answer: "Violence, menace de violences ou contrainte",
    explanation: "312-1 CP : moyens coercitifs (physiques ou moraux).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Extorsion — Menace",
    question: "Pour l’extorsion, les menaces :",
    options: [
      "N’ont pas besoin d’être réalisées : leur formulation peut suffire",
      "Doivent être réalisées pour être punies",
      "Doivent être écrites obligatoirement",
    ],
    answer: "N’ont pas besoin d’être réalisées : leur formulation peut suffire",
    explanation:
        "La remise obtenue par menace suffit, même sans passage à l’acte.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Extorsion — Contrainte morale",
    question: "La contrainte morale s’apprécie notamment selon :",
    options: [
      "La force des pressions et la vulnérabilité/impressionnabilité de la victime",
      "Uniquement la taille de l’auteur",
      "Uniquement le montant demandé",
    ],
    answer:
        "La force des pressions et la vulnérabilité/impressionnabilité de la victime",
    explanation:
        "Appréciation souveraine : âge, santé, vulnérabilité, crainte inspirée, etc.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Extorsion — Rôle de la victime",
    question: "Dans l’extorsion, la remise est :",
    options: [
      "Active (faite par la victime) mais obtenue sous pression",
      "Une soustraction sans intervention de la victime",
      "Toujours réalisée par un tiers",
    ],
    answer: "Active (faite par la victime) mais obtenue sous pression",
    explanation:
        "La victime remet l’objet, mais sa volonté est viciée par la violence/menace/contrainte.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Extorsion — Objet (piège)",
    question: "L’extorsion peut porter sur :",
    options: [
      "Une signature, un engagement/renonciation, un secret, ou une remise de fonds/valeurs/bien",
      "Uniquement de l’argent",
      "Uniquement un bien immobilier",
    ],
    answer:
        "Une signature, un engagement/renonciation, un secret, ou une remise de fonds/valeurs/bien",
    explanation: "312-1 CP liste plusieurs objets, comme le chantage.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Extorsion — Peines simples",
    question: "Peines de l’extorsion simple (312-1) :",
    options: [
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "6 mois d’emprisonnement et 3 750 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende",
    explanation: "312-1 CP : 7 ans + 100 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Extorsion — Aggravation (ITT ≤ 8 jours)",
    question: "Extorsion avec violences ayant entraîné une ITT ≤ 8 jours :",
    options: ["Délit aggravé (312-2)", "Crime (312-3)", "Contravention"],
    answer: "Délit aggravé (312-2)",
    explanation:
        "312-2 CP : circonstances aggravantes délictuel (ITT ≤ 8 jours).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Extorsion — Aggravation (arme)",
    question: "Extorsion commise avec usage ou menace d’une arme :",
    options: ["Crime (312-5)", "Délit simple (312-1)", "Filouterie (313-5)"],
    answer: "Crime (312-5)",
    explanation:
        "312-5 CP : extorsion criminelle si arme (usage/menace) ou port d’arme prohibé/à autorisation.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Extorsion — Bande organisée",
    question: "L’extorsion commise en bande organisée est :",
    options: ["Un crime (312-6)", "Un délit simple", "Une contravention"],
    answer: "Un crime (312-6)",
    explanation: "312-6 CP : extorsion en bande organisée (réclusion).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Extorsion — Tentative",
    question: "La tentative d’extorsion :",
    options: [
      "Est punissable (312-9)",
      "N’est jamais punissable",
      "Est punissable uniquement en bande organisée",
    ],
    answer: "Est punissable (312-9)",
    explanation: "312-9 CP : tentative expressément prévue et réprimée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Extorsion — Immunité familiale (conditions)",
    question: "L’immunité familiale en extorsion :",
    options: [
      "Peut s’appliquer (ascendant/descendant/conjoint selon conditions)",
      "N’existe jamais en extorsion",
      "S’applique uniquement entre frères et sœurs",
    ],
    answer: "Peut s’appliquer (ascendant/descendant/conjoint selon conditions)",
    explanation:
        "312-9 CP : renvoi à 311-12 avec exceptions (moyens de paiement/documents essentiels, etc.).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Extorsion — Exemption / réduction de peine (bande organisée)",
    question:
        "En cas d’extorsion en bande organisée, l’auteur peut bénéficier :",
    options: [
      "D’une exemption ou réduction de peine s’il avertit l’autorité et empêche/correctement aide",
      "D’une immunité automatique",
      "D’une relaxe obligatoire",
    ],
    answer:
        "D’une exemption ou réduction de peine s’il avertit l’autorité et empêche/correctement aide",
    explanation:
        "312-6-1 CP : exemption si avertit et évite la réalisation ; réduction si permet de faire cesser/éviter mort/IPP ou identifier les autres.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Comparaison — Extorsion vs Chantage",
    question:
        "La différence principale entre extorsion et chantage porte sur :",
    options: [
      "La nature de la menace (violences/contrainte vs révélation diffamatoire)",
      "Le montant des sommes demandées",
      "Le lieu de commission",
    ],
    answer:
        "La nature de la menace (violences/contrainte vs révélation diffamatoire)",
    explanation:
        "Extorsion : violence/menace de violences/contrainte ; chantage : menace diffamatoire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Comparaison — Escroquerie vs Filouterie",
    question: "Escroquerie vs filouterie :",
    options: [
      "Escroquerie = remise déterminée par fraude ; Filouterie = remise selon usages professionnels sans manœuvres",
      "Escroquerie = violences ; Filouterie = diffamation",
      "Escroquerie = vol ; Filouterie = recel",
    ],
    answer:
        "Escroquerie = remise déterminée par fraude ; Filouterie = remise selon usages professionnels sans manœuvres",
    explanation:
        "Différence clé : existence de manœuvres/tromperie déterminante en escroquerie.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Comparaison — Vol vs Abus de confiance",
    question: "Le critère distinctif majeur :",
    options: [
      "Abus de confiance = remise préalable consentie ; Vol = soustraction",
      "Abus de confiance = menace ; Vol = tromperie",
      "Abus de confiance = toujours en bande organisée",
    ],
    answer:
        "Abus de confiance = remise préalable consentie ; Vol = soustraction",
    explanation:
        "Abus de confiance : détournement après remise ; vol : soustraction frauduleuse.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Comparaison — Demande de fonds sous contrainte vs Extorsion",
    question: "La demande de fonds sous contrainte vise prioritairement :",
    options: [
      "Des comportements de mendicité (sollicitation) sur la voie publique",
      "Les manœuvres frauduleuses en ligne",
      "Les fraudes aux allocations",
    ],
    answer:
        "Des comportements de mendicité (sollicitation) sur la voie publique",
    explanation:
        "312-12-1 CP : mendicité agressive en réunion ou via animal dangereux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Comparaison — Chantage vs Menace simple",
    question: "Le chantage exige :",
    options: [
      "Une exigence d’obtenir quelque chose (remise/engagement/secret...) par menace diffamatoire",
      "Une simple insulte",
      "Une rumeur sans demande",
    ],
    answer:
        "Une exigence d’obtenir quelque chose (remise/engagement/secret...) par menace diffamatoire",
    explanation:
        "Il faut un objet recherché ; sinon l’infraction peut ne pas être constituée.",
    difficulty: "Moyenne",
  ),

  // =========================
  // DEMANDE DE FONDS SOUS CONTRAINTE — 312-12-1 (SUITE)
  // =========================
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Distinction",
    question:
        "La demande de fonds sous contrainte se distingue de l’extorsion principalement par :",
    options: [
      "Les moyens visés (réunion agressive ou menace d’un animal dangereux) et le contexte de mendicité",
      "Le fait qu’elle nécessite toujours une arme",
      "Le fait qu’elle vise uniquement les commerçants",
    ],
    answer:
        "Les moyens visés (réunion agressive ou menace d’un animal dangereux) et le contexte de mendicité",
    explanation:
        "312-12-1 vise la mendicité agressive (en réunion) ou sous menace d’un animal dangereux, sur la voie publique.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Sollicitation",
    question:
        "Pour que l’infraction soit constituée, la remise des fonds doit être effective :",
    options: ["Oui", "Non", "Uniquement si la somme dépasse 150 €"],
    answer: "Non",
    explanation:
        "Le délit repose sur la sollicitation : pas besoin que la remise soit effectivement réalisée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category:
        "Demande de fonds sous contrainte (312-12-1) — Réunion + agressivité",
    question:
        "Une mendicité en réunion mais non agressive suffit à caractériser 312-12-1 :",
    options: ["Vrai", "Faux", "Seulement la nuit"],
    answer: "Faux",
    explanation:
        "Le texte vise « en réunion et de manière agressive » : les deux éléments doivent ressortir des faits.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Animal",
    question: "La menace d’un animal dangereux suppose :",
    options: [
      "Que l’animal soit utilisé pour contraindre la personne sollicitée",
      "Que l’animal soit obligatoirement muselé",
      "Que l’animal appartienne à une race interdite",
    ],
    answer: "Que l’animal soit utilisé pour contraindre la personne sollicitée",
    explanation:
        "L’important est l’usage de l’animal comme moyen de contrainte et sa dangerosité apparente/supposée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category:
        "Demande de fonds sous contrainte (312-12-1) — Exemple jurisprudentiel (idée)",
    question:
        "Frapper aux vitres des voitures à un carrefour pour demander de l’argent, à deux, peut caractériser :",
    options: ["312-12-1", "313-5", "314-1"],
    answer: "312-12-1",
    explanation:
        "Exemple du cours : comportement agressif en réunion visant à contraindre à s’arrêter/remettre de l’argent.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Tentative",
    question: "La tentative de demande de fonds sous contrainte est :",
    options: [
      "Punissable",
      "Non envisageable",
      "Punissable seulement en récidive",
    ],
    answer: "Non envisageable",
    explanation:
        "Le délit est constitué dès la sollicitation : la tentative n’a pas de place.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Peines",
    question: "Peines encourues (312-12-1) :",
    options: [
      "6 mois d’emprisonnement et 3 750 € d’amende",
      "1 an d’emprisonnement et 15 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "6 mois d’emprisonnement et 3 750 € d’amende",
    explanation: "Cours : 312-12-1 CP = 6 mois + 3 750 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Complicité",
    question: "La complicité est possible pour 312-12-1 :",
    options: ["Oui", "Non", "Uniquement si la remise a eu lieu"],
    answer: "Oui",
    explanation:
        "La complicité est applicable conformément à l’article 121-7 CP.",
    difficulty: "Facile",
  ),

  // =========================
  // ABUS DE CONFIANCE — 314-1 (SUITE / PIÈGES / CAS)
  // =========================
  const QuizQuestion(
    category: "Abus de confiance (314-1) — Finalité de la remise",
    question: "La remise doit être faite à charge de :",
    options: [
      "Rendre, représenter ou faire un usage déterminé",
      "Revendre librement le bien",
      "Le transformer sans condition",
    ],
    answer: "Rendre, représenter ou faire un usage déterminé",
    explanation:
        "C’est le cœur de la détention précaire : finalité convenue limitant la libre disposition.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Détournement (refus)",
    question:
        "Le refus de restituer caractérise en principe le détournement frauduleux, sauf :",
    options: [
      "Si un droit civil de rétention/compensation le justifie",
      "S’il est exprimé poliment",
      "Si la victime est un proche",
    ],
    answer: "Si un droit civil de rétention/compensation le justifie",
    explanation:
        "Le refus peut être légitimé par rétention/compensation ; sinon il révèle la volonté de se comporter en propriétaire.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Retard de restitution",
    question: "Un simple retard de restitution est :",
    options: [
      "En principe une inexécution civile, sauf s’il devient frauduleux",
      "Toujours un abus de confiance",
      "Toujours un vol",
    ],
    answer: "En principe une inexécution civile, sauf s’il devient frauduleux",
    explanation:
        "Le retard devient pénal si les circonstances révèlent une intention frauduleuse (ex : non-restitution malgré démarches).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Bien immatériel",
    question:
        "Un bien « quelconque » peut-il être immatériel exploitable (ex : fichier clientèle) ?",
    options: ["Oui", "Non", "Seulement si c’est une somme d’argent"],
    answer: "Oui",
    explanation:
        "Le cours vise des éléments exploitables matériellement, même non corporels (ex : fichier clientèle, connexion…).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Origine du bien",
    question: "L’origine illicite du bien remis empêche l’abus de confiance :",
    options: ["Vrai", "Faux", "Seulement si le bien est volé"],
    answer: "Faux",
    explanation:
        "Le cours indique que l’origine illicite des choses confiées n’exclut pas l’infraction.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Préjudice (piège)",
    question:
        "Il faut prouver que l’auteur a tiré un profit pour que l’abus de confiance soit constitué :",
    options: ["Vrai", "Faux", "Uniquement si la victime est une entreprise"],
    answer: "Faux",
    explanation:
        "Le préjudice suffit : pas besoin d’un profit ni d’une entrée du bien dans le patrimoine de l’auteur.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Victime (autrui)",
    question: "La victime (« autrui ») peut être :",
    options: [
      "Propriétaire, possesseur, détenteur ou même un tiers",
      "Uniquement le propriétaire",
      "Uniquement une personne physique",
    ],
    answer: "Propriétaire, possesseur, détenteur ou même un tiers",
    explanation:
        "Le texte vise toute personne lésée dès lors que la propriété ne revenait pas à l’auteur.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Élément moral",
    question: "L’intention frauduleuse suppose :",
    options: [
      "La conscience de l’obligation de restitution/usage déterminé et la volonté d’y contrevenir",
      "Un mobile de vengeance",
      "Une récidive préalable",
    ],
    answer:
        "La conscience de l’obligation de restitution/usage déterminé et la volonté d’y contrevenir",
    explanation:
        "Le caractère frauduleux découle de la connaissance des obligations liées à la détention précaire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Aggravation (314-2)",
    question: "Peut être aggravé l’abus de confiance commis :",
    options: [
      "Au préjudice d’une personne vulnérable (âge, maladie, grossesse…) connue ou apparente",
      "Uniquement en ville",
      "Uniquement si le bien est une voiture",
    ],
    answer:
        "Au préjudice d’une personne vulnérable (âge, maladie, grossesse…) connue ou apparente",
    explanation:
        "314-2 CP (selon cours) prévoit plusieurs aggravations, dont la vulnérabilité de la victime.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Aggravation (314-3)",
    question: "Une aggravation spécifique vise notamment :",
    options: [
      "Le mandataire de justice ou officier public/ministériel dans l’exercice des fonctions",
      "Tout salarié",
      "Toute personne mineure",
    ],
    answer:
        "Le mandataire de justice ou officier public/ministériel dans l’exercice des fonctions",
    explanation: "314-3 CP : aggravation liée à certaines qualités/fonctions.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Peines simples",
    question: "Peines de l’abus de confiance simple (314-1) :",
    options: [
      "5 ans d’emprisonnement et 375 000 € d’amende",
      "6 mois d’emprisonnement et 7 500 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 375 000 € d’amende",
    explanation: "314-1 CP : 5 ans + 375 000 €.",
    difficulty: "Facile",
  ),

  // =========================
  // CHANTAGE — 312-10 (SUITE)
  // =========================
  const QuizQuestion(
    category: "Chantage (312-10) — Fait vrai ou faux",
    question: "Pour le chantage, le fait objet de la menace doit être vrai :",
    options: ["Oui", "Non", "Uniquement si c’est écrit"],
    answer: "Non",
    explanation:
        "Le chantage peut viser l’imputation de faits imaginaires ou la révélation de faits vrais.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Chantage — Personne visée",
    question: "La menace diffamatoire peut viser :",
    options: [
      "Une personne physique ou une personne morale",
      "Uniquement une personne physique",
      "Uniquement un agent public",
    ],
    answer: "Une personne physique ou une personne morale",
    explanation:
        "Le cours rappelle que l’honneur/la considération peuvent concerner aussi une société (personne morale).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Chantage — Victime indirecte (piège)",
    question:
        "Le chantage peut exister si la menace vise un tiers, mais contraint une autre personne à remettre :",
    options: ["Oui", "Non", "Seulement si le tiers est un conjoint"],
    answer: "Oui",
    explanation:
        "Le délit existe dès la menace de révélation d’un fait portant atteinte à l’honneur d’un tiers si elle détermine la remise.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Chantage — Acte exigé",
    question: "Il peut y avoir chantage si l’auteur menace mais n’exige rien :",
    options: ["Vrai", "Faux", "Seulement si la menace est publique"],
    answer: "Faux",
    explanation:
        "Il faut un objet recherché (signature, engagement, secret, remise…). Sinon l’élément matériel n’est pas caractérisé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Chantage — Tentative",
    question: "La tentative de chantage est :",
    options: [
      "Punissable",
      "Non punissable",
      "Punissable uniquement si la menace est exécutée",
    ],
    answer: "Punissable",
    explanation:
        "312-12 CP : la tentative est réprimée comme le délit lui-même (commencement d’exécution + échec indépendant).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Chantage — Aggravation (mise à exécution)",
    question:
        "Quand l’auteur exécute sa menace (révèle/impute effectivement), la qualification aggravée est :",
    options: ["312-11", "312-2", "313-2"],
    answer: "312-11",
    explanation:
        "312-11 CP : aggravation lorsque l’auteur a mis sa menace à exécution.",
    difficulty: "Facile",
  ),

  // =========================
  // FILOUTERIE — 313-5 (SUITE / PIÈGES)
  // =========================
  const QuizQuestion(
    category: "Filouterie (313-5) — Nombre de cas",
    question: "L’article 313-5 vise :",
    options: ["4 cas précis", "6 cas", "Un nombre illimité de situations"],
    answer: "4 cas précis",
    explanation:
        "Boissons/aliments ; chambres (≤10 jours) ; carburant servi ; taxi/voiture de place.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Filouterie — Établissement",
    question: "La filouterie « boissons/aliments » suppose :",
    options: [
      "Un établissement dont l’activité principale est de vendre boissons/aliments et accessible au public",
      "Une commande chez un particulier",
      "Un repas servi par un ami à domicile",
    ],
    answer:
        "Un établissement dont l’activité principale est de vendre boissons/aliments et accessible au public",
    explanation: "Restaurants, cafés, brasseries… Pas chez un particulier.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Filouterie — Prestations annexes (hôtel)",
    question:
        "Dans la filouterie d’hôtel (313-5, 2°), les prestations annexes (ex : consommations) sont :",
    options: [
      "En principe hors champ du 2° (interprétation stricte)",
      "Toujours incluses",
      "Toujours qualifiées d’escroquerie",
    ],
    answer: "En principe hors champ du 2° (interprétation stricte)",
    explanation:
        "Le cours précise que seules les chambres (occupation) sont visées ; les annexes ne sont pas visées par ce cas.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Filouterie — Carburant (réservoir)",
    question: "Pour le carburant, il faut que le produit soit versé :",
    options: [
      "Dans le réservoir d’un véhicule",
      "Dans un jerrycan",
      "Dans n’importe quel récipient",
    ],
    answer: "Dans le réservoir d’un véhicule",
    explanation:
        "Le cours exclut les récipients (jerrycans) : c’est le réservoir du véhicule.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Filouterie — Impécuniosité vs oubli",
    question:
        "Oublier son portefeuille et s’en apercevoir au moment de payer, de bonne foi :",
    options: [
      "N’est pas une filouterie",
      "Est toujours une filouterie",
      "Est une escroquerie",
    ],
    answer: "N’est pas une filouterie",
    explanation:
        "La filouterie requiert impécuniosité absolue connue OU détermination à ne pas payer, pas une simple négligence.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Filouterie — Détermination à ne pas payer",
    question:
        "La « détermination à ne pas payer » est plus facile à établir lorsque :",
    options: [
      "L’auteur prend la fuite au moment de payer",
      "L’auteur demande l’addition",
      "L’auteur laisse un pourboire",
    ],
    answer: "L’auteur prend la fuite au moment de payer",
    explanation:
        "Le comportement de fuite est un indice fort de volonté de ne pas payer.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Filouterie — Tentative",
    question: "La tentative de filouterie (313-5) est :",
    options: [
      "Punissable",
      "Non prévue",
      "Punissable uniquement en cas de taxi",
    ],
    answer: "Non prévue",
    explanation:
        "Le cours indique que la tentative n’est pas prévue pour 313-5.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Filouterie — Personnes morales",
    question: "Une personne morale peut être responsable de filouterie :",
    options: ["Oui", "Non", "Seulement pour le taxi"],
    answer: "Oui",
    explanation:
        "Le cours rappelle la responsabilité pénale des personnes morales et l’amende au quintuple (modalités).",
    difficulty: "Moyenne",
  ),

  // =========================
  // ESCROQUERIE — 313-1 (SUITE / PIÈGES / CAS)
  // =========================
  const QuizQuestion(
    category: "Escroquerie (313-1) — Mensonge simple",
    question:
        "Un simple mensonge non corroboré (sans fait extérieur) suffit à constituer l’escroquerie :",
    options: ["Vrai", "Faux", "Seulement si la victime est âgée"],
    answer: "Faux",
    explanation:
        "Le cours rappelle que les simples mensonges sont insuffisants s’ils ne sont accompagnés d’aucun acte extérieur (manœuvres).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Escroquerie — Antériorité",
    question: "Les manœuvres frauduleuses doivent être :",
    options: [
      "Antérieures et déterminantes de la remise",
      "Postérieures à la remise",
      "Sans lien temporel",
    ],
    answer: "Antérieures et déterminantes de la remise",
    explanation:
        "La jurisprudence exige qu’elles déterminent la remise et soient antérieures.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Escroquerie — Faux nom",
    question: "L’usage d’un faux nom peut viser :",
    options: [
      "Un nom réel (d’un tiers) ou imaginaire",
      "Uniquement un nom imaginaire",
      "Uniquement un surnom connu",
    ],
    answer: "Un nom réel (d’un tiers) ou imaginaire",
    explanation:
        "Le faux nom = patronyme qui n’est pas le sien, qu’il existe ou non.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Escroquerie — Fausse qualité (exemple)",
    question:
        "Se présenter faussement comme policier pour obtenir une remise de fonds illustre :",
    options: [
      "L’usage d’une fausse qualité",
      "La filouterie",
      "L’abus de confiance",
    ],
    answer: "L’usage d’une fausse qualité",
    explanation:
        "Le cours cite l’exemple de la fausse qualité de policier comme moyen de tromperie.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Escroquerie — Abus de qualité vraie",
    question: "L’abus de qualité vraie suppose :",
    options: [
      "Une qualité réellement détenue utilisée pour crédibiliser la tromperie",
      "Une qualité inventée",
      "Une menace diffamatoire",
    ],
    answer:
        "Une qualité réellement détenue utilisée pour crédibiliser la tromperie",
    explanation: "L’agent détourne la confiance attachée à sa vraie qualité.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Escroquerie — Remise de service",
    question: "La « fourniture d’un service » (313-1) peut viser :",
    options: [
      "Toute prestation (restauration, spectacle, communication, stationnement payant…)",
      "Uniquement un service public",
      "Uniquement un service médical",
    ],
    answer:
        "Toute prestation (restauration, spectacle, communication, stationnement payant…)",
    explanation: "Le cours illustre la notion de service de manière large.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Escroquerie — Acte opérant obligation/décharge",
    question: "Un « acte opérant obligation ou décharge » peut être :",
    options: [
      "Une quittance, un contrat, une promesse, un quitus…",
      "Uniquement un acte notarié",
      "Uniquement une facture",
    ],
    answer: "Une quittance, un contrat, une promesse, un quitus…",
    explanation:
        "Tout acte créant/constatant/éteignant un droit au détriment de la victime.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Escroquerie — Préjudice moral (piège)",
    question:
        "Le préjudice moral en escroquerie est toujours retenu automatiquement :",
    options: [
      "Vrai",
      "Faux",
      "Seulement si la victime est une personne morale",
    ],
    answer: "Faux",
    explanation:
        "Le cours indique que le préjudice moral est souvent admis (consentement vicié) mais pas systématiquement selon cas.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Escroquerie — Aggravation (313-2)",
    question: "Une circonstance aggravante (313-2) peut être :",
    options: [
      "Commise en bande organisée",
      "Commise un dimanche",
      "Commise avec un animal dangereux",
    ],
    answer: "Commise en bande organisée",
    explanation:
        "Le cours liste la bande organisée parmi les circonstances aggravantes de l’escroquerie.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Escroquerie — Peines simples",
    question: "Peines de l’escroquerie simple (313-1) :",
    options: [
      "5 ans d’emprisonnement et 375 000 € d’amende",
      "6 mois d’emprisonnement et 7 500 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 375 000 € d’amende",
    explanation: "313-1 CP : 5 ans + 375 000 €.",
    difficulty: "Facile",
  ),

  // =========================
  // EXTORSION — 312-1 (SUITE / PIÈGES / AGGRAVATIONS)
  // =========================
  const QuizQuestion(
    category: "Extorsion (312-1) — Promesses fallacieuses (piège)",
    question:
        "Si la victime remet un bien uniquement à cause de promesses mensongères (sans violence/contrainte), on retient :",
    options: [
      "Pas l’extorsion (autre qualification possible selon les faits)",
      "Toujours l’extorsion",
      "Toujours la filouterie",
    ],
    answer: "Pas l’extorsion (autre qualification possible selon les faits)",
    explanation:
        "Le cours : pas d’extorsion si remise obtenue seulement par promesses fallacieuses (sans moyens coercitifs).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Extorsion — Contrainte sur les proches",
    question: "La contrainte morale peut viser :",
    options: [
      "La victime ou ses proches",
      "Uniquement la victime",
      "Uniquement le patrimoine de l’auteur",
    ],
    answer: "La victime ou ses proches",
    explanation: "La crainte peut affecter la victime ou ses proches (cours).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Extorsion — Objet déterminé (piège)",
    question:
        "Exiger un « dédommagement » sans précision sur montant/nature suffit à caractériser l’objet :",
    options: ["Vrai", "Faux", "Seulement si c’est écrit"],
    answer: "Faux",
    explanation:
        "Le cours : l’objet doit être suffisamment déterminé ; une demande trop imprécise peut être insuffisante.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Extorsion — ITT > 8 jours",
    question:
        "Extorsion avec violences ayant entraîné une ITT > 8 jours relève :",
    options: [
      "D’une extorsion aggravée criminelle (312-3)",
      "D’un délit simple",
      "D’une contravention",
    ],
    answer: "D’une extorsion aggravée criminelle (312-3)",
    explanation:
        "Le cours place l’ITT > 8 jours dans l’extorsion aggravée criminelle.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Extorsion — Mutilation/infirmité permanente",
    question: "Extorsion avec mutilation ou infirmité permanente :",
    options: ["312-4", "312-2", "313-2"],
    answer: "312-4",
    explanation:
        "312-4 CP : aggravation criminelle si mutilation/infirmité permanente.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Extorsion — Mort / barbarie",
    question:
        "Extorsion précédée/accompagnée/suivie de violences ayant entraîné la mort ou tortures/barbarie :",
    options: ["312-7", "312-2", "314-2"],
    answer: "312-7",
    explanation:
        "Le cours indique l’aggravation maximale (312-7) en cas de mort ou tortures/barbarie.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Extorsion — Délit vs crime (repère)",
    question: "L’extorsion simple est :",
    options: ["Un délit", "Un crime", "Une contravention"],
    answer: "Un délit",
    explanation: "312-1 CP : extorsion simple = délit (7 ans).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Extorsion — Tentative (commencement)",
    question:
        "En extorsion, un rendez-vous fixé pour recevoir la remise peut constituer :",
    options: [
      "Un commencement d’exécution (tentative)",
      "Un fait non punissable",
      "Une complicité uniquement",
    ],
    answer: "Un commencement d’exécution (tentative)",
    explanation:
        "Le cours cite qu’un rendez-vous peut suffire comme début d’exécution si l’infraction échoue indépendamment.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Extorsion — Immunité familiale (exceptions)",
    question:
        "Même si l’immunité familiale pourrait s’appliquer, elle est écartée notamment si l’extorsion porte sur :",
    options: [
      "Des documents d’identité / moyens de paiement / moyens de télécommunication indispensables",
      "Des vêtements non essentiels",
      "Des objets décoratifs",
    ],
    answer:
        "Des documents d’identité / moyens de paiement / moyens de télécommunication indispensables",
    explanation:
        "Le cours mentionne des exceptions à l’immunité familiale (objets/documents indispensables).",
    difficulty: "Difficile",
  ),

  // =========================
  // QCM MÉLANGÉS (RÉVISION RAPIDE)
  // =========================
  const QuizQuestion(
    category: "Mix — Identifier l’infraction",
    question:
        "Menacer de publier des rumeurs humiliantes si la victime ne signe pas une renonciation :",
    options: ["Chantage", "Extorsion", "Filouterie"],
    answer: "Chantage",
    explanation:
        "Menace diffamatoire + exigence d’un acte (renonciation) = chantage.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Mix — Identifier l’infraction",
    question:
        "Obtenir une remise de fonds en se faisant passer pour un notaire et en montrant un faux document :",
    options: ["Escroquerie", "Filouterie", "Demande de fonds sous contrainte"],
    answer: "Escroquerie",
    explanation:
        "Fausse qualité + production de document/mise en scène = moyens de tromperie (313-1).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Mix — Identifier l’infraction",
    question:
        "Recevoir une voiture en dépôt pour la restituer, puis la vendre :",
    options: ["Abus de confiance", "Filouterie", "Chantage"],
    answer: "Abus de confiance",
    explanation:
        "Remise à titre précaire + détournement par aliénation = 314-1.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Mix — Identifier l’infraction",
    question:
        "Se faire servir un plein par un pompiste en sachant être absolument incapable de payer :",
    options: ["Filouterie", "Escroquerie", "Vol"],
    answer: "Filouterie",
    explanation:
        "313-5 : se faire servir des carburants par un professionnel avec impécuniosité absolue ou volonté de ne pas payer.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Mix — Identifier l’infraction",
    question: "Obtenir de l’argent par coups et menaces physiques :",
    options: ["Extorsion", "Chantage", "Abus de confiance"],
    answer: "Extorsion",
    explanation: "Violence/menace de violences/contrainte = 312-1.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Mix — Piège (remise non effective)",
    question: "Dans 312-12-1, l’infraction est consommée :",
    options: [
      "Dès la sollicitation agressive/en réunion ou sous menace d’animal dangereux",
      "Uniquement si la victime donne de l’argent",
      "Uniquement si la victime est vulnérable",
    ],
    answer:
        "Dès la sollicitation agressive/en réunion ou sous menace d’animal dangereux",
    explanation:
        "Le texte incrimine la sollicitation ; la remise n’est pas nécessaire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Flash V/F — 323-4",
    question:
        "Vrai/Faux : un groupement initialement légal peut tomber sous 323-4 s’il dérive vers la délinquance informatique.",
    options: ["Vrai", "Faux", "Jamais"],
    answer: "Vrai",
    explanation:
        "Le cours : association déclarée qui dérive → seuls ceux qui continuent à participer sont visés.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai / Faux — Non-justification",
    question:
        "Vrai/Faux : 321-6 peut viser des relations habituelles avec des victimes d’infractions ≥ 5 ans.",
    options: ["Vrai", "Faux", "Uniquement avec auteurs"],
    answer: "Vrai",
    explanation:
        "Le texte vise aussi les relations habituelles avec des victimes d’une des infractions concernées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Distinction",
    question:
        "La demande de fonds sous contrainte se distingue de l’extorsion par :",
    options: [
      "Les moyens employés (réunion agressive ou animal dangereux)",
      "L’absence totale de menace",
      "Le caractère contractuel de la remise",
    ],
    answer: "Les moyens employés (réunion agressive ou animal dangereux)",
    explanation:
        "Elle ne repose pas sur violences ou menaces de violences caractérisant l’extorsion.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte — Élément matériel",
    question: "La remise effective des fonds est-elle nécessaire ?",
    options: ["Oui", "Non", "Seulement si la somme est élevée"],
    answer: "Non",
    explanation:
        "Le délit est constitué par la seule sollicitation sur la voie publique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte — Peines",
    question: "Peines prévues par l’article 312-12-1 CP :",
    options: [
      "6 mois d’emprisonnement et 3 750 € d’amende",
      "1 an d’emprisonnement et 15 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "6 mois d’emprisonnement et 3 750 € d’amende",
    explanation:
        "Délit simple, sans circonstance aggravante prévue par le texte.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte — Tentative / Complicité",
    question: "Concernant 312-12-1 CP :",
    options: [
      "Tentative non, complicité oui",
      "Tentative oui, complicité oui",
      "Tentative non, complicité non",
    ],
    answer: "Tentative non, complicité oui",
    explanation:
        "Le délit est consommé dès la sollicitation ; complicité possible (art. 121-7 CP).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Abus de confiance (314-1) — Définition",
    question: "L’abus de confiance est :",
    options: [
      "Le détournement d’un bien remis à titre précaire",
      "La soustraction frauduleuse d’un bien",
      "L’obtention d’un bien par manœuvres frauduleuses",
    ],
    answer: "Le détournement d’un bien remis à titre précaire",
    explanation:
        "314-1 CP : remise préalable acceptée à charge de restitution, représentation ou usage déterminé.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Remise préalable",
    question: "La remise préalable peut résulter :",
    options: [
      "D’un contrat, de la loi, d’une décision de justice ou d’une situation de fait",
      "Uniquement d’un contrat écrit",
      "Uniquement d’une décision judiciaire",
    ],
    answer:
        "D’un contrat, de la loi, d’une décision de justice ou d’une situation de fait",
    explanation: "La jurisprudence admet des cadres très larges de remise.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Détournement (piège)",
    question:
        "Le simple retard de restitution constitue toujours un abus de confiance.",
    options: ["Vrai", "Faux", "Seulement en cas de plainte"],
    answer: "Faux",
    explanation: "Le retard n’est délictueux que s’il devient frauduleux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Élément moral",
    question: "L’élément moral de l’abus de confiance repose sur :",
    options: [
      "La conscience de la précarité de la détention et la volonté de la transgresser",
      "La simple imprudence",
      "La préméditation obligatoire",
    ],
    answer:
        "La conscience de la précarité de la détention et la volonté de la transgresser",
    explanation: "Infraction intentionnelle nécessitant la mauvaise foi.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Peines",
    question: "Peines de l’abus de confiance simple (314-1 CP) :",
    options: [
      "5 ans d’emprisonnement et 375 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "7 ans d’emprisonnement et 750 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 375 000 € d’amende",
    explanation: "Peines de base prévues par l’article 314-1 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Chantage (312-10) — Définition",
    question: "Le chantage consiste à :",
    options: [
      "Obtenir une remise ou un engagement par menace de révélation diffamatoire",
      "Obtenir un bien par violences",
      "Obtenir un bien par tromperie",
    ],
    answer:
        "Obtenir une remise ou un engagement par menace de révélation diffamatoire",
    explanation:
        "312-10 CP : menace de révélation ou d’imputation de faits portant atteinte à l’honneur ou à la considération.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Chantage — Fait vrai ou faux (piège)",
    question:
        "Le fait menacé doit être nécessairement faux pour caractériser le chantage.",
    options: ["Vrai", "Faux", "Seulement si écrit"],
    answer: "Faux",
    explanation: "Peu importe que le fait soit vrai ou faux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Chantage — Tentative",
    question: "La tentative de chantage est :",
    options: ["Punissable", "Non punissable", "Punissable seulement si écrite"],
    answer: "Punissable",
    explanation: "Article 312-12 CP : la tentative est expressément prévue.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Filouterie (313-5) — Définition",
    question: "La filouterie consiste à :",
    options: [
      "Se faire fournir certains biens ou services en sachant qu’on ne paiera pas",
      "Soustraire frauduleusement un bien",
      "Obtenir un bien par menaces",
    ],
    answer:
        "Se faire fournir certains biens ou services en sachant qu’on ne paiera pas",
    explanation: "313-5 CP : protection de certains professionnels.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Filouterie — Cas visés",
    question: "L’article 313-5 CP vise notamment :",
    options: [
      "Restaurants, hôtels, taxis, stations-service",
      "Tous les commerces",
      "Uniquement les hôtels",
    ],
    answer: "Restaurants, hôtels, taxis, stations-service",
    explanation: "Liste limitative prévue par le texte.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Filouterie — Tentative",
    question: "La tentative de filouterie est :",
    options: ["Punissable", "Non punissable", "Punissable en récidive"],
    answer: "Non punissable",
    explanation: "La tentative n’est pas prévue par l’article 313-5 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Escroquerie (313-1) — Définition",
    question: "L’escroquerie suppose notamment :",
    options: [
      "Un moyen de tromperie déterminant la remise",
      "Une violence",
      "Une contrainte physique",
    ],
    answer: "Un moyen de tromperie déterminant la remise",
    explanation:
        "Usage de faux nom, fausse qualité, abus de qualité vraie ou manœuvres frauduleuses.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Escroquerie — Mensonge simple (piège)",
    question:
        "Un simple mensonge non appuyé par un acte suffit à caractériser l’escroquerie.",
    options: ["Vrai", "Faux", "Seulement si la victime est vulnérable"],
    answer: "Faux",
    explanation: "Les simples mensonges ne suffisent pas sans manœuvres.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Escroquerie — Peines simples",
    question: "Peines de l’escroquerie simple (313-1 CP) :",
    options: [
      "5 ans d’emprisonnement et 375 000 € d’amende",
      "7 ans d’emprisonnement et 750 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 375 000 € d’amende",
    explanation: "Peines de base prévues par l’article 313-1 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Extorsion (312-1) — Définition",
    question: "L’extorsion est :",
    options: [
      "L’obtention d’une remise par violence, menace de violences ou contrainte",
      "L’obtention d’une remise par tromperie",
      "La soustraction frauduleuse",
    ],
    answer:
        "L’obtention d’une remise par violence, menace de violences ou contrainte",
    explanation: "312-1 CP : remise forcée mais consciente de la victime.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Extorsion — Tentative",
    question: "La tentative d’extorsion est :",
    options: ["Punissable", "Non punissable", "Punissable seulement en bande"],
    answer: "Punissable",
    explanation: "Article 312-9 CP : tentative expressément prévue.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Extorsion — Qualification",
    question:
        "L’extorsion avec violences ayant entraîné plus de 8 jours d’ITT est :",
    options: ["Un crime", "Un délit aggravé", "Une contravention"],
    answer: "Un crime",
    explanation: "Article 312-3 CP : extorsion criminelle.",
    difficulty: "Moyenne",
  ),

  // =========================
  // DEMANDE DE FONDS SOUS CONTRAINTE — 312-12-1
  // =========================
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Conditions",
    question:
        "Pour caractériser la demande de fonds sous contrainte « en réunion », il faut :",
    options: [
      "Au moins deux auteurs",
      "Au moins trois auteurs",
      "Un auteur seul mais agressif",
    ],
    answer: "Au moins deux auteurs",
    explanation:
        "Le texte vise un comportement commis par deux auteurs au moins se livrant à une mendicité agressive.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Lieu",
    question: "La sollicitation doit être effectuée :",
    options: [
      "Sur la voie publique",
      "Uniquement dans un commerce",
      "Uniquement au domicile de la victime",
    ],
    answer: "Sur la voie publique",
    explanation: "312-12-1 CP : sollicitation sur la voie publique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Objet",
    question: "La sollicitation peut porter sur :",
    options: [
      "Des fonds, des valeurs ou un bien",
      "Uniquement de l’argent liquide",
      "Uniquement des denrées alimentaires",
    ],
    answer: "Des fonds, des valeurs ou un bien",
    explanation:
        "Le texte vise fonds/valeurs/bien (objet/denrée à valeur marchande).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Animal dangereux",
    question: "L’expression « animal dangereux » renvoie :",
    options: [
      "À tout animal présentant un danger apparent ou raisonnablement supposé",
      "Uniquement aux chiens de catégorie 1 ou 2",
      "Uniquement aux animaux sauvages",
    ],
    answer:
        "À tout animal présentant un danger apparent ou raisonnablement supposé",
    explanation:
        "Le critère est la dangerosité apparente/supposée et la contrainte exercée via l’animal.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Demande de fonds sous contrainte (312-12-1) — Intention",
    question: "L’élément moral suppose :",
    options: [
      "La conscience d’un comportement menaçant pour obtenir une remise",
      "La volonté de se venger de la victime",
      "La préméditation obligatoire",
    ],
    answer: "La conscience d’un comportement menaçant pour obtenir une remise",
    explanation:
        "Intention : savoir que la remise ne résulterait pas d’un accord librement consenti.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category:
        "Demande de fonds sous contrainte (312-12-1) — Qualification (piège)",
    question:
        "Si des menaces de violences caractérisées sont utilisées pour obtenir l’argent, on retient forcément :",
    options: [
      "Plutôt l’extorsion selon les faits",
      "Toujours 312-12-1",
      "Toujours la filouterie",
    ],
    answer: "Plutôt l’extorsion selon les faits",
    explanation:
        "312-12-1 vise la mendicité agressive ; des menaces/violences peuvent basculer vers l’extorsion selon l’ITT et les circonstances.",
    difficulty: "Difficile",
  ),

  // =========================
  // ABUS DE CONFIANCE — 314-1 et suivants
  // =========================
  const QuizQuestion(
    category: "Abus de confiance (314-1) — Choses visées",
    question: "Quelles catégories sont visées par 314-1 CP ?",
    options: [
      "Fonds, valeurs ou bien quelconque",
      "Uniquement les fonds",
      "Uniquement les biens immobiliers",
    ],
    answer: "Fonds, valeurs ou bien quelconque",
    explanation:
        "Le texte vise fonds/valeurs/bien quelconque remis à charge de restituer/représenter/usage déterminé.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Abus de confiance (314-1) — Remise libre",
    question: "Dans l’abus de confiance, la remise initiale est :",
    options: [
      "Libre et consentie, puis détournée",
      "Toujours forcée par violence",
      "Toujours obtenue par manœuvres frauduleuses",
    ],
    answer: "Libre et consentie, puis détournée",
    explanation:
        "La remise est préalable et acceptée à titre précaire ; le détournement survient ensuite.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Titre précaire",
    question: "La remise « à titre précaire » signifie :",
    options: [
      "Le bénéficiaire n’a pas la libre disposition du bien",
      "Le bénéficiaire devient propriétaire",
      "La remise est impossible sans écrit",
    ],
    answer: "Le bénéficiaire n’a pas la libre disposition du bien",
    explanation:
        "Il doit rendre/représenter/faire un usage déterminé : prérogatives limitées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Preuve de la remise (piège)",
    question:
        "En cas de simple situation de fait (relation amicale), la remise se prouve :",
    options: [
      "Par tous moyens, sans se fonder sur de simples présomptions ou témoignages isolés",
      "Uniquement par écrit",
      "Uniquement par aveu",
    ],
    answer:
        "Par tous moyens, sans se fonder sur de simples présomptions ou témoignages isolés",
    explanation:
        "Le cours précise : preuve libre mais ne saurait reposer sur de simples présomptions ou témoignages.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Détournement",
    question: "Le détournement peut notamment consister en :",
    options: [
      "Refus de restituer, impossibilité de restituer, transgression de l’affectation",
      "Uniquement une vente du bien",
      "Uniquement un oubli de restitution",
    ],
    answer:
        "Refus de restituer, impossibilité de restituer, transgression de l’affectation",
    explanation:
        "Le détournement recouvre plusieurs formes : usage contraire, refus, disparition, etc.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Mise en demeure (piège)",
    question:
        "Une mise en demeure de restituer est toujours nécessaire pour caractériser l’abus de confiance.",
    options: ["Vrai", "Faux", "Seulement pour les véhicules loués"],
    answer: "Faux",
    explanation:
        "La jurisprudence retient que le délit peut être caractérisé par le seul détournement sans mise en demeure.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Préjudice",
    question: "Le préjudice exigé :",
    options: [
      "Peut être matériel ou moral, réel ou éventuel",
      "Doit être uniquement matériel et chiffré",
      "Doit être uniquement moral",
    ],
    answer: "Peut être matériel ou moral, réel ou éventuel",
    explanation:
        "Il suffit que l’acte soit susceptible de priver la victime de ses droits.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Aggravation",
    question: "Une circonstance aggravante spécifique est :",
    options: [
      "La bande organisée (314-1-1)",
      "La nuit",
      "La récidive obligatoire",
    ],
    answer: "La bande organisée (314-1-1)",
    explanation: "314-1-1 CP : abus de confiance commis en bande organisée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Tentative",
    question: "La tentative d’abus de confiance :",
    options: [
      "Est punissable",
      "N’est jamais punissable",
      "Est punissable seulement si le préjudice est réalisé",
    ],
    answer: "Est punissable",
    explanation:
        "La tentative est expressément prévue (cours : tentative toujours punissable).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Abus de confiance — Immunité familiale",
    question:
        "L’immunité familiale est-elle applicable à l’abus de confiance ?",
    options: ["Oui", "Non", "Seulement en cas de bande organisée"],
    answer: "Oui",
    explanation:
        "314-4 CP : renvoi à l’immunité familiale de 311-12 applicable à l’abus de confiance.",
    difficulty: "Moyenne",
  ),

  // =========================
  // CHANTAGE — 312-10 à 312-12
  // =========================
  const QuizQuestion(
    category: "Chantage (312-10) — Nature de la menace",
    question: "La menace constitutive du chantage est :",
    options: [
      "Une menace de révélation ou d’imputation diffamatoire",
      "Une menace de violences",
      "Une menace de dégradation avec condition",
    ],
    answer: "Une menace de révélation ou d’imputation diffamatoire",
    explanation:
        "Le chantage se distingue de l’extorsion par la nature diffamatoire de la menace.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Chantage — Forme",
    question: "La menace dans le chantage peut être :",
    options: [
      "Écrite ou orale",
      "Uniquement écrite",
      "Uniquement par voie de presse",
    ],
    answer: "Écrite ou orale",
    explanation: "Le texte ne distingue pas : menace verbale ou écrite.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Chantage — Menaces implicites",
    question:
        "La menace doit-elle forcément énoncer clairement le fait diffamatoire ?",
    options: [
      "Non, une menace implicite compréhensible peut suffire",
      "Oui, le fait doit être précisément détaillé",
      "Oui, et uniquement par écrit",
    ],
    answer: "Non, une menace implicite compréhensible peut suffire",
    explanation:
        "La jurisprudence admet les menaces voilées/sous-entendues si la pression est claire pour la victime.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Chantage — Objet recherché",
    question: "Le chantage peut viser notamment :",
    options: [
      "Une signature, un engagement, une renonciation, la révélation d’un secret, ou une remise",
      "Uniquement de l’argent",
      "Uniquement une signature",
    ],
    answer:
        "Une signature, un engagement, une renonciation, la révélation d’un secret, ou une remise",
    explanation:
        "312-10 CP liste plusieurs objets possibles, comme l’extorsion.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Chantage — Mise à exécution",
    question: "Quand la menace est mise à exécution, on applique :",
    options: ["312-11 CP", "312-2 CP", "313-2 CP"],
    answer: "312-11 CP",
    explanation:
        "312-11 CP : aggravation lorsque l’auteur a mis la menace à exécution.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Chantage — Peines simples",
    question: "Peines du chantage simple (312-10) :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "6 mois d’emprisonnement et 7 500 € d’amende",
      "7 ans d’emprisonnement et 750 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "312-10 CP : 5 ans et 75 000 € (cours).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Chantage — Aggravation en ligne",
    question: "Le chantage est aggravé notamment lorsqu’il est exercé :",
    options: [
      "Par un service de communication au public en ligne avec images/vidéos à caractère sexuel",
      "Par téléphone uniquement",
      "Sur la voie publique uniquement",
    ],
    answer:
        "Par un service de communication au public en ligne avec images/vidéos à caractère sexuel",
    explanation:
        "312-10 al.3 CP : aggravation liée au mode de diffusion en ligne et contenus sexuels.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Chantage — Immunité familiale",
    question: "L’immunité familiale s’applique au chantage ?",
    options: ["Oui", "Non", "Uniquement si la victime est un ascendant"],
    answer: "Oui",
    explanation: "312-12 al.2 CP : renvoi à 311-12.",
    difficulty: "Moyenne",
  ),

  // =========================
  // FILOUTERIE — 313-5
  // =========================
  const QuizQuestion(
    category: "Filouterie (313-5) — Spécificité",
    question: "La filouterie se distingue du vol car :",
    options: [
      "La remise est volontaire (mode normal de la profession)",
      "Il y a soustraction frauduleuse",
      "Elle suppose des violences",
    ],
    answer: "La remise est volontaire (mode normal de la profession)",
    explanation:
        "Le professionnel fournit volontairement selon ses usages ; pas de soustraction.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Filouterie (313-5) — Spécificité vs escroquerie",
    question: "La filouterie se distingue de l’escroquerie car :",
    options: [
      "La remise ne résulte pas de manœuvres frauduleuses",
      "Elle suppose un faux nom",
      "Elle suppose une fausse qualité",
    ],
    answer: "La remise ne résulte pas de manœuvres frauduleuses",
    explanation:
        "Pas de tromperie déterminante : la remise résulte des usages professionnels.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Filouterie — Condition d’impécuniosité",
    question: "L’« impossibilité absolue de payer » signifie :",
    options: [
      "Aucun moyen de paiement sur soi ET aucune ressource/patrimoine pour payer",
      "Ne pas avoir de liquide sur soi uniquement",
      "Avoir oublié son portefeuille",
    ],
    answer:
        "Aucun moyen de paiement sur soi ET aucune ressource/patrimoine pour payer",
    explanation:
        "Condition très exigeante (absolue) + connaissance par l’auteur.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Filouterie — Restaurant",
    question: "Pour le 1° (boissons/aliments), il faut notamment :",
    options: [
      "Que l’auteur passe commande (prenne l’initiative)",
      "Que l’auteur vole en cuisine",
      "Que les denrées soient obligatoirement consommées",
    ],
    answer: "Que l’auteur passe commande (prenne l’initiative)",
    explanation:
        "« Se faire servir » : initiative de commande, consommation non nécessaire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Filouterie — Hôtel (10 jours)",
    question: "Pour la filouterie d’hôtel, l’occupation :",
    options: [
      "Ne doit pas excéder dix jours",
      "Doit excéder dix jours",
      "Peut être illimitée",
    ],
    answer: "Ne doit pas excéder dix jours",
    explanation:
        "313-5 : condition spécifique au 2° (chambres) : occupation ≤ 10 jours.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Filouterie — Station-service (piège)",
    question:
        "Prendre du carburant en station libre-service et partir sans payer caractérise :",
    options: [
      "Plutôt un vol (selon le cours/jurisprudence)",
      "Une filouterie",
      "Un chantage",
    ],
    answer: "Plutôt un vol (selon le cours/jurisprudence)",
    explanation:
        "La filouterie suppose « se faire servir » par un professionnel ; en libre-service, la qualification peut être le vol.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Filouterie — Taxi",
    question: "La filouterie « taxi » vise :",
    options: [
      "Se faire transporter puis ne pas payer la course",
      "Monter sans payer dans un bus",
      "Refuser de payer un billet de train",
    ],
    answer: "Se faire transporter puis ne pas payer la course",
    explanation:
        "313-5 : 4° taxi/voiture de place (pas les transports en commun).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Filouterie — Peines",
    question: "Peines de la filouterie (313-5 CP) :",
    options: [
      "6 mois d’emprisonnement et 7 500 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 375 000 € d’amende",
    ],
    answer: "6 mois d’emprisonnement et 7 500 € d’amende",
    explanation: "313-5 CP : 6 mois et 7 500 €.",
    difficulty: "Facile",
  ),

  // =========================
  // ESCROQUERIE — 313-1 et suivants
  // =========================
  const QuizQuestion(
    category: "Escroquerie (313-1) — Moyens",
    question: "Quels moyens sont visés par 313-1 CP ?",
    options: [
      "Faux nom, fausse qualité, abus de qualité vraie, manœuvres frauduleuses",
      "Violences, menaces, contrainte",
      "Révélation diffamatoire",
    ],
    answer:
        "Faux nom, fausse qualité, abus de qualité vraie, manœuvres frauduleuses",
    explanation: "Les 4 formes de tromperie prévues par le texte.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Escroquerie — Caractère déterminant",
    question: "Le moyen frauduleux doit être :",
    options: [
      "Déterminant de la remise et résulter d’un comportement actif",
      "Postérieur à la remise",
      "Sans lien avec la remise",
    ],
    answer: "Déterminant de la remise et résulter d’un comportement actif",
    explanation:
        "Le procédé doit provoquer la remise et être antérieur/déterminant.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Escroquerie — Fausse qualité",
    question: "La « qualité » peut notamment être :",
    options: [
      "Un attribut de nature à inspirer confiance (profession/titre/état…)",
      "Uniquement un prénom",
      "Uniquement un surnom",
    ],
    answer:
        "Un attribut de nature à inspirer confiance (profession/titre/état…)",
    explanation:
        "Notion large : attribut juridique ou particularité donnant crédit.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Escroquerie — Abus de qualité vraie",
    question: "L’abus de qualité vraie correspond à :",
    options: [
      "Utiliser une qualité réelle pour donner force et crédit à des mensonges",
      "Inventer un faux nom",
      "Menacer de violences",
    ],
    answer:
        "Utiliser une qualité réelle pour donner force et crédit à des mensonges",
    explanation: "Qualité réellement détenue, détournée pour tromper.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Escroquerie — Manœuvres frauduleuses (composition)",
    question: "Les manœuvres frauduleuses peuvent notamment être :",
    options: [
      "Production d’écrits, mise en scène, intervention d’un tiers",
      "Uniquement un mensonge verbal",
      "Uniquement une violence",
    ],
    answer: "Production d’écrits, mise en scène, intervention d’un tiers",
    explanation: "Triade classique retenue par la jurisprudence.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Escroquerie — Remise",
    question: "La remise en escroquerie peut consister en :",
    options: [
      "Fonds/valeurs/bien, fourniture d’un service, ou acte opérant obligation/décharge",
      "Uniquement de l’argent liquide",
      "Uniquement un bien mobilier",
    ],
    answer:
        "Fonds/valeurs/bien, fourniture d’un service, ou acte opérant obligation/décharge",
    explanation: "313-1 CP : 3 types de remise/acte visés.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Escroquerie — Préjudice",
    question: "Le préjudice est :",
    options: [
      "Indispensable à l’existence de l’escroquerie",
      "Facultatif si la tromperie est prouvée",
      "Toujours présumé sans discussion",
    ],
    answer: "Indispensable à l’existence de l’escroquerie",
    explanation: "Sans préjudice, un élément manque (cours).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Escroquerie — Tentative",
    question: "La tentative d’escroquerie est :",
    options: [
      "Toujours punissable (simple ou aggravée)",
      "Jamais punissable",
      "Punissable uniquement en récidive",
    ],
    answer: "Toujours punissable (simple ou aggravée)",
    explanation: "313-3 CP : tentative expressément prévue.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Escroquerie — Immunité familiale",
    question: "L’immunité familiale s’applique à l’escroquerie ?",
    options: ["Oui", "Non", "Seulement si la victime est un conjoint"],
    answer: "Oui",
    explanation: "313-3 al.2 CP : renvoi à 311-12.",
    difficulty: "Moyenne",
  ),

  // =========================
  // EXTORSION — 312-1 à 312-9
  // =========================
  const QuizQuestion(
    category: "Extorsion (312-1) — Moyens",
    question: "L’extorsion suppose :",
    options: [
      "Violence, menace de violences ou contrainte",
      "Manœuvres frauduleuses",
      "Menace de révélation diffamatoire",
    ],
    answer: "Violence, menace de violences ou contrainte",
    explanation: "312-1 CP : moyens coercitifs (physiques ou moraux).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Extorsion — Menace",
    question: "Pour l’extorsion, les menaces :",
    options: [
      "N’ont pas besoin d’être réalisées : leur formulation peut suffire",
      "Doivent être réalisées pour être punies",
      "Doivent être écrites obligatoirement",
    ],
    answer: "N’ont pas besoin d’être réalisées : leur formulation peut suffire",
    explanation:
        "La remise obtenue par menace suffit, même sans passage à l’acte.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Extorsion — Contrainte morale",
    question: "La contrainte morale s’apprécie notamment selon :",
    options: [
      "La force des pressions et la vulnérabilité/impressionnabilité de la victime",
      "Uniquement la taille de l’auteur",
      "Uniquement le montant demandé",
    ],
    answer:
        "La force des pressions et la vulnérabilité/impressionnabilité de la victime",
    explanation:
        "Appréciation souveraine : âge, santé, vulnérabilité, crainte inspirée, etc.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Extorsion — Rôle de la victime",
    question: "Dans l’extorsion, la remise est :",
    options: [
      "Active (faite par la victime) mais obtenue sous pression",
      "Une soustraction sans intervention de la victime",
      "Toujours réalisée par un tiers",
    ],
    answer: "Active (faite par la victime) mais obtenue sous pression",
    explanation:
        "La victime remet l’objet, mais sa volonté est viciée par la violence/menace/contrainte.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Extorsion — Objet (piège)",
    question: "L’extorsion peut porter sur :",
    options: [
      "Une signature, un engagement/renonciation, un secret, ou une remise de fonds/valeurs/bien",
      "Uniquement de l’argent",
      "Uniquement un bien immobilier",
    ],
    answer:
        "Une signature, un engagement/renonciation, un secret, ou une remise de fonds/valeurs/bien",
    explanation: "312-1 CP liste plusieurs objets, comme le chantage.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Extorsion — Peines simples",
    question: "Peines de l’extorsion simple (312-1) :",
    options: [
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "6 mois d’emprisonnement et 3 750 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende",
    explanation: "312-1 CP : 7 ans + 100 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Extorsion — Aggravation (ITT ≤ 8 jours)",
    question: "Extorsion avec violences ayant entraîné une ITT ≤ 8 jours :",
    options: ["Délit aggravé (312-2)", "Crime (312-3)", "Contravention"],
    answer: "Délit aggravé (312-2)",
    explanation:
        "312-2 CP : circonstances aggravantes délictuel (ITT ≤ 8 jours).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Extorsion — Aggravation (arme)",
    question: "Extorsion commise avec usage ou menace d’une arme :",
    options: ["Crime (312-5)", "Délit simple (312-1)", "Filouterie (313-5)"],
    answer: "Crime (312-5)",
    explanation:
        "312-5 CP : extorsion criminelle si arme (usage/menace) ou port d’arme prohibé/à autorisation.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Extorsion — Bande organisée",
    question: "L’extorsion commise en bande organisée est :",
    options: ["Un crime (312-6)", "Un délit simple", "Une contravention"],
    answer: "Un crime (312-6)",
    explanation: "312-6 CP : extorsion en bande organisée (réclusion).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Extorsion — Tentative",
    question: "La tentative d’extorsion :",
    options: [
      "Est punissable (312-9)",
      "N’est jamais punissable",
      "Est punissable uniquement en bande organisée",
    ],
    answer: "Est punissable (312-9)",
    explanation: "312-9 CP : tentative expressément prévue et réprimée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Extorsion — Immunité familiale (conditions)",
    question: "L’immunité familiale en extorsion :",
    options: [
      "Peut s’appliquer (ascendant/descendant/conjoint selon conditions)",
      "N’existe jamais en extorsion",
      "S’applique uniquement entre frères et sœurs",
    ],
    answer: "Peut s’appliquer (ascendant/descendant/conjoint selon conditions)",
    explanation:
        "312-9 CP : renvoi à 311-12 avec exceptions (moyens de paiement/documents essentiels, etc.).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Extorsion — Exemption / réduction de peine (bande organisée)",
    question:
        "En cas d’extorsion en bande organisée, l’auteur peut bénéficier :",
    options: [
      "D’une exemption ou réduction de peine s’il avertit l’autorité et empêche/correctement aide",
      "D’une immunité automatique",
      "D’une relaxe obligatoire",
    ],
    answer:
        "D’une exemption ou réduction de peine s’il avertit l’autorité et empêche/correctement aide",
    explanation:
        "312-6-1 CP : exemption si avertit et évite la réalisation ; réduction si permet de faire cesser/éviter mort/IPP ou identifier les autres.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Comparaison — Extorsion vs Chantage",
    question:
        "La différence principale entre extorsion et chantage porte sur :",
    options: [
      "La nature de la menace (violences/contrainte vs révélation diffamatoire)",
      "Le montant des sommes demandées",
      "Le lieu de commission",
    ],
    answer:
        "La nature de la menace (violences/contrainte vs révélation diffamatoire)",
    explanation:
        "Extorsion : violence/menace de violences/contrainte ; chantage : menace diffamatoire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Comparaison — Escroquerie vs Filouterie",
    question: "Escroquerie vs filouterie :",
    options: [
      "Escroquerie = remise déterminée par fraude ; Filouterie = remise selon usages professionnels sans manœuvres",
      "Escroquerie = violences ; Filouterie = diffamation",
      "Escroquerie = vol ; Filouterie = recel",
    ],
    answer:
        "Escroquerie = remise déterminée par fraude ; Filouterie = remise selon usages professionnels sans manœuvres",
    explanation:
        "Différence clé : existence de manœuvres/tromperie déterminante en escroquerie.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Comparaison — Vol vs Abus de confiance",
    question: "Le critère distinctif majeur :",
    options: [
      "Abus de confiance = remise préalable consentie ; Vol = soustraction",
      "Abus de confiance = menace ; Vol = tromperie",
      "Abus de confiance = toujours en bande organisée",
    ],
    answer:
        "Abus de confiance = remise préalable consentie ; Vol = soustraction",
    explanation:
        "Abus de confiance : détournement après remise ; vol : soustraction frauduleuse.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Comparaison — Demande de fonds sous contrainte vs Extorsion",
    question: "La demande de fonds sous contrainte vise prioritairement :",
    options: [
      "Des comportements de mendicité (sollicitation) sur la voie publique",
      "Les manœuvres frauduleuses en ligne",
      "Les fraudes aux allocations",
    ],
    answer:
        "Des comportements de mendicité (sollicitation) sur la voie publique",
    explanation:
        "312-12-1 CP : mendicité agressive en réunion ou via animal dangereux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Comparaison — Chantage vs Menace simple",
    question: "Le chantage exige :",
    options: [
      "Une exigence d’obtenir quelque chose (remise/engagement/secret...) par menace diffamatoire",
      "Une simple insulte",
      "Une rumeur sans demande",
    ],
    answer:
        "Une exigence d’obtenir quelque chose (remise/engagement/secret...) par menace diffamatoire",
    explanation:
        "Il faut un objet recherché ; sinon l’infraction peut ne pas être constituée.",
    difficulty: "Moyenne",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizCrimesDelitsBiensPA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName =
      '/pa/crime_delit_nation_pages/quiz/pa_quiz_crimes_delits_bien';
  final String uid;
  final String email;

  const QuizCrimesDelitsBiensPA({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizCrimesDelitsBiensPA> createState() => _QuizCrimesDelitsBiensPAState();
}

class _QuizCrimesDelitsBiensPAState extends State<QuizCrimesDelitsBiensPA>
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
  static const _introHiddenKey = 'intro_pa_crimes_delits_bien';
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
        ? questionInfractionsVoisinesDuVol
        : questionInfractionsVoisinesDuVol
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
            'mode': UserContextService.I.modeOrDefault,'module_name': 'Crimes & délits contre les biens',
            'quiz_name': 'Crimes & délits contre les biens',
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
      await _sb.from('quiz_crimes_delits_bien').insert({
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
      debugPrint('❌ quiz_crimes_delits_bien insert failed: $e');
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
      'source_file': 'pa_quiz_crimes_delits_bien',
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
                            icon: Icons.inventory_2_rounded,
                            title: 'Crimes contre les biens',
                            description: 'Identifie les infractions contre les biens : vol, escroquerie, abus de confiance, extorsion et leurs circonstances aggravantes.',
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
