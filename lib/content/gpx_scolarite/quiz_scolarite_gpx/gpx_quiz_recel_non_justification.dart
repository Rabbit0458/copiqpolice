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

final List<QuizQuestion> questionRecelNonJustification = [
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
    category: "Vrai / Faux — Non-justification",
    question:
        "Vrai/Faux : 321-6 peut viser des relations habituelles avec des victimes d’infractions ≥ 5 ans.",
    options: ["Vrai", "Faux", "Uniquement avec auteurs"],
    answer: "Vrai",
    explanation:
        "Le texte vise aussi les relations habituelles avec des victimes d’une des infractions concernées.",
    difficulty: "Moyenne",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizRecelNonJustificationGPX extends StatefulWidget {
  static const String grade = 'gpx';
  static const String routeName =
      '/gpx/crimes_biens/quiz/recel_non_justification';
  final String uid;
  final String email;

  const QuizRecelNonJustificationGPX({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizRecelNonJustificationGPX> createState() => _QuizRecelNonJustificationGPXState();
}

class _QuizRecelNonJustificationGPXState extends State<QuizRecelNonJustificationGPX>
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
  static const _introHiddenKey = 'intro_gpx_recel_non_justification';
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
        ? questionRecelNonJustification
        : questionRecelNonJustification
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
            'quiz_name': 'Recel & non-justification de ressources',
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
      await _sb.from('quiz_recel_non_justification').insert({
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
      debugPrint('❌ quiz_recel_non_justification insert failed: $e');
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
      'source_file': 'gpx_quiz_recel_non_justification',
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
                            icon: Icons.inventory_rounded,
                            title: 'Recel et non-justification',
                            description: 'Maîtrise le recel : éléments constitutifs, liens avec l’infraction d’origine et infraction de non-justification de ressources.',
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
