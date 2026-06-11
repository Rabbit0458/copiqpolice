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
];

// ============================================================================
// PAGE
// ============================================================================
class QuizVoisinesDuVolPA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName = '/pa/crimes_biens/quiz/voisines_du_vol';
  final String uid;
  final String email;

  const QuizVoisinesDuVolPA({super.key, required this.uid, required this.email});

  @override
  State<QuizVoisinesDuVolPA> createState() => _QuizVoisinesDuVolPAState();
}

class _QuizVoisinesDuVolPAState extends State<QuizVoisinesDuVolPA>
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
  static const _introHiddenKey = 'intro_pa_voisines_du_vol';
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
            'quiz_name': 'Infractions voisines du vol',
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
      await _sb.from('quiz_voisines_du_vol').insert({
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
      debugPrint('❌ quiz_voisines_du_vol insert failed: $e');
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
      'source_file': 'pa_quiz_voisines_du_vol',
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
                            icon: Icons.shopping_bag_rounded,
                            title: 'Infractions voisines du vol',
                            description: 'Distingue le vol des infractions voisines : extorsion, chantage, abus de confiance, escroquerie, recel et leurs spécificités.',
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
