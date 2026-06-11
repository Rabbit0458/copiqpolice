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

final List<QuizQuestion> questionDDD = [
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
];

// ============================================================================
// PAGE
// ============================================================================
class QuizDDDPA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName =
      '/pa/crimes_biens/quiz/destructions_degradations';
  final String uid;
  final String email;

  const QuizDDDPA({super.key, required this.uid, required this.email});

  @override
  State<QuizDDDPA> createState() => _QuizDDDPAState();
}

class _QuizDDDPAState extends State<QuizDDDPA> with TickerProviderStateMixin {
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
  static const _introHiddenKey = 'intro_pa_destructions_degradations';
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
        ? questionDDD
        : questionDDD
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
            'quiz_name': 'Les destructions, dégradations et détérioations',
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
      await _sb.from('quiz_ddd').insert({
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
      debugPrint('❌ quiz_ddd insert failed: $e');
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
      'source_file': 'pa_quiz_destructions_degradations',
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
                            icon: Icons.delete_sweep_rounded,
                            title: 'Destructions et dégradations',
                            description: 'Maîtrise les infractions de destruction et dégradation de biens : conditions, circonstances aggravantes et peines encourues.',
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
