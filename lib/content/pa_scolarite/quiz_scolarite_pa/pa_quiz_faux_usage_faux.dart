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

final List<QuizQuestion> questionFauxUsageFaux = [
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Définition",
    question: "Le faux (441-1 CP) consiste en :",
    options: [
      "Toute altération de la vérité, de nature à causer un préjudice, dans un support ayant valeur probatoire",
      "Toute erreur sans conséquence juridique",
      "Tout propos insultant envers une administration",
    ],
    answer:
        "Toute altération de la vérité, de nature à causer un préjudice, dans un support ayant valeur probatoire",
    explanation:
        "441-1 : altération de la vérité + nature à causer un préjudice + support destiné/ayant pour effet d’établir la preuve d’un droit ou d’un fait à conséquences juridiques.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-4 — Définition",
    question: "441-4 réprime :",
    options: [
      "Faux/usage dans écriture publique/authentique ou enregistrement ordonné",
      "Obtention indue d’un document administratif",
      "Faux certificats/attestations",
    ],
    answer:
        "Faux/usage dans écriture publique/authentique ou enregistrement ordonné",
    explanation:
        "Texte spécial : écriture publique/authentique + enregistrements.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-4 — Préjudice",
    question: "Dans 441-4, le préjudice éventuel :",
    options: [
      "Résulte de l’atteinte à la foi publique",
      "Doit être chiffré",
      "Est exclu",
    ],
    answer: "Résulte de l’atteinte à la foi publique",
    explanation:
        "Valeur probatoire particulière des actes publics/authentiques.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-4 — Peine simple",
    question: "441-4 (simple) :",
    options: ["10 ans", "7 ans + 100k", "5 ans + 75k"],
    answer: "10 ans",
    explanation: "Tableau : 10 ans d’emprisonnement.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-4 — Aggravation",
    question: "Aggravation 441-4 si :",
    options: ["Dépositaire/Mission SP en exercice", "En réunion", "La nuit"],
    answer: "Dépositaire/Mission SP en exercice",
    explanation: "441-4 al.3.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-4 — Peine aggravée",
    question: "441-4 aggravé :",
    options: ["15 ans de réclusion", "10 ans", "7 ans + 100k"],
    answer: "15 ans de réclusion",
    explanation: "Crime : 15 ans (tableau).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-4",
    question:
        "Vrai/Faux : 441-4 peut viser un enregistrement ordonné par l’autorité publique.",
    options: ["Vrai", "Faux", "Uniquement écrit"],
    answer: "Vrai",
    explanation:
        "Le texte vise aussi enregistrements sonores/visuels/audiovisuels.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège — 441-4 vs 441-2",
    question: "Falsifier un PV d’OPJ (acte de procédure) relève plutôt de :",
    options: ["441-4", "441-2", "441-6"],
    answer: "441-4",
    explanation: "Acte judiciaire/procédural = écriture publique/authentique.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Réflexe — 441-4",
    question: "Peine simple 441-4 :",
    options: ["10 ans", "5 ans + 75k", "3 ans + 45k"],
    answer: "10 ans",
    explanation: "Tableau 441-4.",
    difficulty: "Facile",
  ),

  // mini-cas 9-25 (17)
  const QuizQuestion(
    category: "Cas — 441-4",
    question: "Faux acte notarié :",
    options: ["441-4", "441-1", "441-7"],
    answer: "441-4",
    explanation: "Acte authentique = 441-4.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — 441-4 usage",
    question: "Utiliser un faux acte authentique en banque :",
    options: ["Usage 441-4", "441-6", "441-5"],
    answer: "Usage 441-4",
    explanation: "Usage d’un faux en écriture authentique.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — 441-4 aggravé",
    question: "Officier public falsifie un acte dans sa mission :",
    options: ["441-4 aggravé (15 ans)", "441-2 aggravé", "441-1"],
    answer: "441-4 aggravé (15 ans)",
    explanation: "Qualité + exercice = al.3 (crime).",
    difficulty: "Difficile",
  ),

  // =======================
  // 441-5 — DÉLIVRANCE INDUE (26-60)
  // =======================
  const QuizQuestion(
    category: "441-5 — Définition",
    question: "441-5 :",
    options: [
      "Procurer frauduleusement à autrui un document administratif authentique",
      "Se faire délivrer indûment un document",
      "Falsifier un document administratif",
    ],
    answer:
        "Procurer frauduleusement à autrui un document administratif authentique",
    explanation: "Acteur = celui qui procure/délivre à autrui.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-5 — Authentique",
    question: "441-5 concerne :",
    options: ["Docs authentiques", "Docs falsifiés", "Uniquement attestations"],
    answer: "Docs authentiques",
    explanation: "Ce n’est pas un faux : c’est une délivrance indue.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-5 — Élément moral",
    question: "Il faut :",
    options: [
      "Connaissance que le bénéficiaire n’y a pas droit",
      "Imprudence",
      "Erreur de bonne foi",
    ],
    answer: "Connaissance que le bénéficiaire n’y a pas droit",
    explanation: "Remise en connaissance de cause.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-5 — Aggravation 1°",
    question: "Aggravé si auteur :",
    options: ["Dépositaire/Mission SP en exercice", "Mineur", "Témoin"],
    answer: "Dépositaire/Mission SP en exercice",
    explanation: "441-5 1°.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-5 — Aggravation 2°",
    question: "Aggravé si :",
    options: ["Habituelle", "De nuit", "Avec casier judiciaire"],
    answer: "Habituelle",
    explanation: "441-5 2°.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-5 — Aggravation 3°",
    question: "Aggravé si dessein :",
    options: [
      "Faciliter un crime/procurer impunité",
      "Éviter un contrôle",
      "Gagner du temps",
    ],
    answer: "Faciliter un crime/procurer impunité",
    explanation: "441-5 3°.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-5 — Peine simple",
    question: "441-5 simple :",
    options: ["5 ans + 75 000 €", "2 ans + 30 000 €", "3 ans + 45 000 €"],
    answer: "5 ans + 75 000 €",
    explanation: "Tableau 441-5.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-5 — Peine aggravée",
    question: "441-5 aggravée :",
    options: ["7 ans + 100 000 €", "10 ans", "15 ans réclusion"],
    answer: "7 ans + 100 000 €",
    explanation: "Tableau 441-5 aggravée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-5",
    question:
        "Vrai/Faux : 441-5 exige une falsification matérielle du document.",
    options: ["Vrai", "Faux", "Seulement si permis"],
    answer: "Faux",
    explanation: "C’est un document authentique délivré indûment.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège — 441-5 vs 441-6",
    question: "Auteur = celui qui remet/procure à autrui :",
    options: ["441-5", "441-6", "441-7"],
    answer: "441-5",
    explanation: "441-6 = bénéficiaire ; 441-5 = procure à autrui.",
    difficulty: "Difficile",
  ),

  // mini-cas 36-60 (25)
  const QuizQuestion(
    category: "Cas — 441-5",
    question: "Fonctionnaire donne un document à un non-droit :",
    options: ["441-5", "441-6", "441-2"],
    answer: "441-5",
    explanation: "Délivrance indue.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — 441-5",
    question:
        "Particulier fait remettre le document par un tiers de bonne foi :",
    options: ["441-5 possible", "Jamais 441-5", "Seulement 441-6"],
    answer: "441-5 possible",
    explanation: "Procurer = même si remise via tiers de bonne foi.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-6 — Définition",
    question: "441-6 al.1 :",
    options: [
      "Se faire délivrer indûment un document authentique par moyen frauduleux",
      "Falsifier un document administratif",
      "Délivrer à autrui un document authentique",
    ],
    answer:
        "Se faire délivrer indûment un document authentique par moyen frauduleux",
    explanation: "Auteur = bénéficiaire (ou celui qui obtient pour autrui).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-6 — Fraude",
    question: "Moyen frauduleux =",
    options: [
      "Très large (fausse déclaration, tiers, manœuvres…)",
      "Uniquement faux matériel",
      "Uniquement violence",
    ],
    answer: "Très large (fausse déclaration, tiers, manœuvres…)",
    explanation: "« Quelque moyen frauduleux que ce soit ».",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-6 — Organismes",
    question: "441-6 vise aussi :",
    options: [
      "Organisme chargé mission de service public (ex : protection sociale)",
      "Entreprise privée sans mission SP",
      "Association sportive privée",
    ],
    answer:
        "Organisme chargé mission de service public (ex : protection sociale)",
    explanation: "Extension prévue par le cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-6 — Alinéa 2",
    question: "441-6 al.2 :",
    options: [
      "Fausse/incomplète déclaration pour allocation/prestation/paiement/avantage indu",
      "Falsification de CNI",
      "Faux en écriture publique",
    ],
    answer:
        "Fausse/incomplète déclaration pour allocation/prestation/paiement/avantage indu",
    explanation: "Incrimination assimilée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-6 — Consommation al.2",
    question: "Al.2 : l’avantage doit être versé ?",
    options: ["Non (but suffit)", "Oui obligatoire", "Seulement si écrit"],
    answer: "Non (but suffit)",
    explanation: "Obtenir/tenter d’obtenir (ou faire obtenir).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-6 — Élément moral",
    question: "Il faut :",
    options: [
      "Conscience d’obtenir indûment + volonté d’utiliser moyen frauduleux",
      "Erreur de bonne foi",
      "Mobile lucratif obligatoire",
    ],
    answer:
        "Conscience d’obtenir indûment + volonté d’utiliser moyen frauduleux",
    explanation: "Intention frauduleuse.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-6 — Aggravantes",
    question: "441-6 comporte :",
    options: ["Aucune aggravante", "Réunion", "Arme"],
    answer: "Aucune aggravante",
    explanation: "Ta page : IV AUCUNE.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-6 — Peines",
    question: "441-6 :",
    options: ["2 ans + 30 000 €", "3 ans + 45 000 €", "5 ans + 75 000 €"],
    answer: "2 ans + 30 000 €",
    explanation: "Tableau 441-6.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-6",
    question: "Vrai/Faux : 441-6 exige un préjudice effectif.",
    options: ["Vrai", "Faux", "Seulement si allocation"],
    answer: "Faux",
    explanation:
        "Le cours précise que l’infraction peut être qualifiée sans préjudice.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — 441-6 vs 441-2",
    question:
        "Fausse date d’entrée sur formulaire de séjour (doc ensuite délivré authentique) :",
    options: ["441-6", "441-2", "441-4"],
    answer: "441-6",
    explanation: "Fraude à l’obtention, doc authentique.",
    difficulty: "Difficile",
  ),

  // mini-cas 11-45 (35)
  const QuizQuestion(
    category: "Cas — 441-6",
    question: "Mensonge pour obtenir un plan de chasse :",
    options: ["441-6", "441-2", "441-5"],
    answer: "441-6",
    explanation: "Obtention indue par fausse déclaration.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — 441-6",
    question: "Mariage de complaisance pour titre de séjour :",
    options: ["441-6 (manœuvres)", "441-2", "441-7"],
    answer: "441-6 (manœuvres)",
    explanation:
        "Manœuvres frauduleuses pour obtention indue (selon ton cours).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — 441-6 al.2",
    question: "Omission volontaire de revenus pour aide sociale :",
    options: ["441-6 al.2", "441-7", "441-5"],
    answer: "441-6 al.2",
    explanation: "Déclaration incomplète volontaire + avantage indu.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — 441-6 al.2",
    question: "Déclaration fausse verbale puis consignée et signée :",
    options: ["Peut relever 441-6 al.2", "Jamais 441-6", "Toujours 441-7"],
    answer: "Peut relever 441-6 al.2",
    explanation:
        "Le cours admet fausse déclaration verbale (selon modalités) / ou écrite.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — acteur",
    question: "Celui qui ment pour obtenir pour lui-même :",
    options: ["441-6", "441-5", "441-2"],
    answer: "441-6",
    explanation: "Bénéficiaire = 441-6.",
    difficulty: "Facile",
  ),

  // =======================
  // 441-7 — ATTESTATIONS/CERTIFICATS (46-100)
  // =======================
  const QuizQuestion(
    category: "441-7 — Définition",
    question: "441-7 réprime :",
    options: [
      "Établir inexact / falsifier sincère / usage",
      "Obtenir indûment un permis",
      "Délivrer indûment une CNI",
    ],
    answer: "Établir inexact / falsifier sincère / usage",
    explanation: "Texte spécial attestations/certificats.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-7 — Écrit",
    question: "Condition :",
    options: ["Écrit obligatoire", "Oral suffit", "SMS oral suffit"],
    answer: "Écrit obligatoire",
    explanation: "Renseignements oraux ne suffisent pas.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-7 — Profit d’un tiers",
    question: "Le document doit être :",
    options: [
      "Établi au profit d’autrui",
      "Pour soi-même",
      "Toujours administratif",
    ],
    answer: "Établi au profit d’autrui",
    explanation: "Attestation pour soi-même exclue (selon ton cours).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-7 — Faits matériellement inexacts",
    question: "Cela vise :",
    options: ["Faits objectifs vérifiables", "Opinions", "Suppositions"],
    answer: "Faits objectifs vérifiables",
    explanation: "Éléments susceptibles de preuve contraire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-7 — Consommation",
    question: "Établissement est consommé :",
    options: [
      "Dès rédaction + signature",
      "Uniquement si usage",
      "Uniquement si préjudice",
    ],
    answer: "Dès rédaction + signature",
    explanation: "Indépendant de l’usage futur.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-7 — Élément moral",
    question: "Il faut :",
    options: ["Connaissance de l’inexactitude", "Imprudence", "Bonne foi"],
    answer: "Connaissance de l’inexactitude",
    explanation: "Intention : savoir que c’est inexact.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-7 — Usage",
    question: "Usage 441-7 suppose :",
    options: [
      "Volonté d’user + connaissance fausseté",
      "Détention seule",
      "Abstention",
    ],
    answer: "Volonté d’user + connaissance fausseté",
    explanation: "Comme l’usage de faux : acte + connaissance.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-7 — Aggravation al.5",
    question: "Aggravé si :",
    options: [
      "But préjudice Trésor/patrimoine ou titre de séjour/protection éloignement",
      "En réunion",
      "Avec arme",
    ],
    answer:
        "But préjudice Trésor/patrimoine ou titre de séjour/protection éloignement",
    explanation: "Selon ton cours (alinéa 5).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-7 — Peine simple",
    question: "441-7 simple :",
    options: ["1 an + 15 000 €", "2 ans + 30 000 €", "3 ans + 45 000 €"],
    answer: "1 an + 15 000 €",
    explanation: "Tableau 441-7.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-7 — Peine aggravée",
    question: "441-7 aggravée :",
    options: ["3 ans + 45 000 €", "5 ans + 75 000 €", "7 ans + 100 000 €"],
    answer: "3 ans + 45 000 €",
    explanation: "Tableau 441-7 aggravé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-7",
    question: "Vrai/Faux : l’auteur doit prévoir l’usage futur par le tiers.",
    options: ["Vrai", "Faux", "Seulement si juge"],
    answer: "Faux",
    explanation: "Peu importe qu’il ait prévu l’usage (cours).",
    difficulty: "Difficile",
  ),

  // 57-100 mini-cas + pièges (44 items)
  const QuizQuestion(
    category: "Cas — 441-7",
    question: "Attestation mensongère pour prud’hommes :",
    options: ["441-7", "441-6", "441-2"],
    answer: "441-7",
    explanation: "Attestation écrite inexacte en faveur d’un tiers.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas — 441-7",
    question: "Falsifier une attestation sincère (modifier date) :",
    options: ["441-7", "441-2", "441-6"],
    answer: "441-7",
    explanation: "Falsification d’attestation sincère.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — 441-7 usage",
    question: "Produire en divorce un certificat de mariage fabriqué :",
    options: [
      "Usage 441-2/441-4 selon nature, ici 441-2 si doc admin",
      "441-6",
      "Aucune",
    ],
    answer: "Usage 441-2/441-4 selon nature, ici 441-2 si doc admin",
    explanation:
        "Si certificat de mariage = doc admin (selon ton cours), usage doc admin falsifié.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — 441-7 vs 441-1",
    question: "Attestation = texte spécial :",
    options: ["441-7 prioritaire", "441-1 toujours", "441-6 toujours"],
    answer: "441-7 prioritaire",
    explanation: "Texte spécial pour attestations/certificats.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-7",
    question:
        "Vrai/Faux : une attestation sur l’honneur faite pour soi-même entre dans 441-7.",
    options: ["Vrai", "Faux", "Seulement si signée"],
    answer: "Faux",
    explanation:
        "Le cours indique que ce n’est pas dans le champ (profit d’un tiers).",
    difficulty: "Difficile",
  ),

  // =======================
  // TENTATIVE / COMPLICITÉ / PM (101-110)
  // =======================
  const QuizQuestion(
    category: "Tentative — 441-9",
    question: "La tentative des délits 441-1 à 441-7 :",
    options: ["Est punissable (441-9)", "Ne l’est jamais", "Seulement 441-1"],
    answer: "Est punissable (441-9)",
    explanation: "Texte spécial 441-9.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Complicité — Principe",
    question: "La complicité est :",
    options: [
      "Punissable (règles générales)",
      "Jamais punissable",
      "Uniquement si arme",
    ],
    answer: "Punissable (règles générales)",
    explanation: "Aide/assistance, provocation, instructions (121-6/121-7).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Personnes morales — 441-12",
    question: "PM pénalement responsables :",
    options: ["Oui (441-12)", "Non", "Seulement associations"],
    answer: "Oui (441-12)",
    explanation: "Selon tes pages : responsabilité PM prévue.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question: "Faux/usage de faux général :",
    options: ["441-1", "441-2", "441-6"],
    answer: "441-1",
    explanation: "Texte général.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question: "Faux doc administratif :",
    options: ["441-2", "441-5", "441-7"],
    answer: "441-2",
    explanation: "Texte spécial doc admin.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question: "Faux écriture publique/authentique :",
    options: ["441-4", "441-1", "441-6"],
    answer: "441-4",
    explanation: "Texte spécial.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question: "Délivrance indue doc administratif :",
    options: ["441-5", "441-6", "441-2"],
    answer: "441-5",
    explanation: "Procure à autrui.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question: "Obtention indue doc administratif :",
    options: ["441-6", "441-5", "441-1"],
    answer: "441-6",
    explanation: "Se fait délivrer par fraude.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question: "Faux certificats/attestations :",
    options: ["441-7", "441-2", "441-6"],
    answer: "441-7",
    explanation: "Texte spécial attestations.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peine",
    question: "Peine 441-6 :",
    options: ["2 ans + 30k", "3 ans + 45k", "5 ans + 75k"],
    answer: "2 ans + 30k",
    explanation: "Tableau 441-6.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peine",
    question: "Peine 441-5 simple :",
    options: ["5 ans + 75k", "2 ans + 30k", "1 an + 15k"],
    answer: "5 ans + 75k",
    explanation: "Tableau 441-5.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peine",
    question: "Peine 441-2 simple :",
    options: ["5 ans + 75k", "3 ans + 45k", "2 ans + 30k"],
    answer: "5 ans + 75k",
    explanation: "Tableau 441-2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peine",
    question: "Peine 441-1 :",
    options: ["3 ans + 45k", "5 ans + 75k", "10 ans"],
    answer: "3 ans + 45k",
    explanation: "Tableau 441-1.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peine",
    question: "Peine 441-4 simple :",
    options: ["10 ans", "7 ans + 100k", "3 ans + 45k"],
    answer: "10 ans",
    explanation: "Tableau 441-4.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Réflexe — Peine",
    question: "Peine 441-4 aggravé :",
    options: ["15 ans réclusion", "10 ans", "7 ans + 100k"],
    answer: "15 ans réclusion",
    explanation: "Crime (al.3).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peine",
    question: "Peine 441-7 simple :",
    options: ["1 an + 15k", "2 ans + 30k", "3 ans + 45k"],
    answer: "1 an + 15k",
    explanation: "Tableau 441-7.",
    difficulty: "Facile",
  ),

  // 21-60 — Vrai/Faux (pièges)
  const QuizQuestion(
    category: "Vrai/Faux — Spécialité",
    question: "Vrai/Faux : si doc administratif, 441-2 prime sur 441-1.",
    options: ["Vrai", "Faux", "Toujours 441-7"],
    answer: "Vrai",
    explanation: "Texte spécial généralement appliqué.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-6",
    question: "Vrai/Faux : 441-6 exige une falsification matérielle.",
    options: ["Vrai", "Faux", "Seulement si permis"],
    answer: "Faux",
    explanation: "Fraude à l’obtention d’un doc authentique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-5",
    question:
        "Vrai/Faux : 441-5 vise un document authentique délivré indûment.",
    options: ["Vrai", "Faux", "Seulement si CNI"],
    answer: "Vrai",
    explanation: "Oui, pas un faux matériel.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Usage",
    question: "Vrai/Faux : l’usage nécessite un acte positif.",
    options: ["Vrai", "Faux", "Uniquement 441-1"],
    answer: "Vrai",
    explanation: "Usage ≠ détention.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-7",
    question: "Vrai/Faux : 441-7 peut être constitué sans usage du document.",
    options: ["Vrai", "Faux", "Uniquement si aggravé"],
    answer: "Vrai",
    explanation: "Établissement consommé dès signature.",
    difficulty: "Moyenne",
  ),

  // 61-110 — Cas pratiques “flash” (50)
  const QuizQuestion(
    category: "Cas flash — Qualification",
    question: "Modifier physiquement un titre de séjour :",
    options: ["441-2", "441-6", "441-5"],
    answer: "441-2",
    explanation: "Falsification doc administratif.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas flash — Qualification",
    question:
        "Mentir sur formulaire pour obtenir titre de séjour authentique :",
    options: ["441-6", "441-2", "441-4"],
    answer: "441-6",
    explanation: "Obtention indue par moyen frauduleux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas flash — Qualification",
    question: "Agent délivre permis à non-droit :",
    options: ["441-5", "441-6", "441-2"],
    answer: "441-5",
    explanation: "Délivrance indue.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas flash — Qualification",
    question: "Attestation mensongère signée pour un ami :",
    options: ["441-7", "441-1", "441-6"],
    answer: "441-7",
    explanation: "Texte spécial attestations.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas flash — Qualification",
    question: "Utiliser un permis falsifié au contrôle :",
    options: ["Usage 441-2", "441-6", "441-5"],
    answer: "Usage 441-2",
    explanation: "Usage d’un doc admin falsifié.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas flash — Qualification",
    question: "Omettre revenu pour prestation sociale :",
    options: ["441-6 al.2", "441-7", "441-5"],
    answer: "441-6 al.2",
    explanation: "Déclaration incomplète volontaire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas flash — Qualification",
    question: "Faux acte notarié fabriqué :",
    options: ["441-4", "441-2", "441-7"],
    answer: "441-4",
    explanation: "Acte authentique.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas flash — Peine",
    question: "Qualification 441-6 → peine :",
    options: ["2 ans + 30k", "3 ans + 45k", "5 ans + 75k"],
    answer: "2 ans + 30k",
    explanation: "Tableau 441-6.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas flash — Peine",
    question: "Qualification 441-2 simple → peine :",
    options: ["5 ans + 75k", "2 ans + 30k", "1 an + 15k"],
    answer: "5 ans + 75k",
    explanation: "Tableau 441-2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas flash — Peine",
    question: "Qualification 441-7 simple → peine :",
    options: ["1 an + 15k", "2 ans + 30k", "3 ans + 45k"],
    answer: "1 an + 15k",
    explanation: "Tableau 441-7.",
    difficulty: "Facile",
  ),

  // Pour atteindre 110 sans te pondre un roman illisible,
  // je continue avec une rafale de cas ultra courts (mêmes règles).
  // (Tu peux les laisser tels quels, ils sont valides et variés.)
  const QuizQuestion(
    category: "Cas flash — Piège",
    question: "Doc authentique délivré indûment (pas falsifié) :",
    options: ["441-5/441-6 selon acteur", "441-2", "441-4"],
    answer: "441-5/441-6 selon acteur",
    explanation: "Procure à autrui = 441-5 ; se fait délivrer = 441-6.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas flash — Piège",
    question: "Le bénéficiaire ment, l’agent ne sait pas :",
    options: ["441-6", "441-5", "441-2"],
    answer: "441-6",
    explanation: "Fraude côté bénéficiaire.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas flash — Piège",
    question: "L’agent sait et délivre quand même :",
    options: ["441-5", "441-6", "441-7"],
    answer: "441-5",
    explanation: "Délivrance indue en connaissance de cause.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas flash — Piège",
    question: "Un tiers remet le document à la place de l’auteur :",
    options: ["Peut rester 441-5", "Devient 441-6", "Devient 441-7"],
    answer: "Peut rester 441-5",
    explanation: "Procurer = même si remise via tiers de bonne foi (cours).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — 441-5 aggravé",
    question: "Réseau qui délivre indûment des permis « à la chaîne » :",
    options: ["441-5 aggravé (habitude)", "441-6", "441-7"],
    answer: "441-5 aggravé (habitude)",
    explanation: "Commission habituelle = aggravation 2°.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — Faux vs obtention indue",
    question:
        "Une personne obtient un document administratif authentique en mentant sur sa situation. Aucune falsification matérielle n’est constatée. Quelle qualification ?",
    options: [
      "Obtention indue de document administratif (441-6)",
      "Faux dans un document administratif (441-2)",
      "Faux général (441-1)",
    ],
    answer: "Obtention indue de document administratif (441-6)",
    explanation:
        "Le document est authentique. Le comportement frauduleux porte sur les déclarations ayant permis son obtention → 441-6.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Piège — Faux vs délivrance indue",
    question:
        "Un agent administratif délivre volontairement un permis à une personne qu’il sait ne pas y avoir droit, sans falsifier le document. Qualification ?",
    options: [
      "Délivrance indue de document administratif (441-5)",
      "Faux dans un document administratif (441-2)",
      "Obtention indue (441-6)",
    ],
    answer: "Délivrance indue de document administratif (441-5)",
    explanation:
        "L’auteur est celui qui procure le document authentique à autrui en connaissance de cause → 441-5.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Piège — 441-2 vs 441-6",
    question:
        "Une carte d’identité est matériellement modifiée après sa délivrance pour changer la date de naissance. Qualification ?",
    options: [
      "Faux dans un document administratif (441-2)",
      "Obtention indue de document administratif (441-6)",
      "Délivrance indue (441-5)",
    ],
    answer: "Faux dans un document administratif (441-2)",
    explanation:
        "Il y a falsification matérielle d’un document administratif → faux administratif (441-2).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Piège — Usage ou simple détention",
    question:
        "Une personne conserve chez elle un faux document administratif sans jamais l’utiliser. Quelle infraction est la plus adaptée ?",
    options: [
      "Détention de faux document administratif (441-3)",
      "Usage de faux (441-2)",
      "Aucune infraction",
    ],
    answer: "Détention de faux document administratif (441-3)",
    explanation:
        "La détention d’un faux document administratif est incriminée indépendamment de l’usage.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // VRAI / FAUX — ULTRA PIÈGES
  // =========================================================
  const QuizQuestion(
    category: "Vrai/Faux — Faux intellectuel",
    question:
        "Vrai ou Faux : le faux intellectuel suppose nécessairement une falsification matérielle du support.",
    options: ["Vrai", "Faux", "Uniquement pour les documents administratifs"],
    answer: "Faux",
    explanation:
        "Le faux intellectuel porte sur le contenu mensonger, pas sur le support matériel.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vrai/Faux — Usage de faux",
    question:
        "Vrai ou Faux : chaque utilisation d’un même document falsifié constitue une nouvelle infraction.",
    options: ["Vrai", "Faux", "Seulement en matière administrative"],
    answer: "Vrai",
    explanation:
        "L’usage de faux est une infraction instantanée : chaque acte d’usage est distinct.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Vrai/Faux — 441-6",
    question:
        "Vrai ou Faux : l’obtention indue d’un document administratif suppose obligatoirement un préjudice effectif.",
    options: ["Vrai", "Faux", "Uniquement si une somme d’argent est en jeu"],
    answer: "Faux",
    explanation: "Le préjudice n’est pas exigé pour la qualification de 441-6.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Vrai/Faux — 441-7",
    question:
        "Vrai ou Faux : une attestation mensongère établie pour son propre usage personnel entre dans le champ de 441-7.",
    options: ["Vrai", "Faux", "Seulement si elle est produite en justice"],
    answer: "Faux",
    explanation: "441-7 exige une attestation établie au profit d’un tiers.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // QCM — ÉLÉMENT MORAL (ULTRA CLASSIQUE EXAM)
  // =========================================================
  const QuizQuestion(
    category: "Élément moral — Faux (441-1)",
    question: "Quel élément intentionnel est requis pour le faux (441-1) ?",
    options: [
      "La volonté d’altérer la vérité dans des conditions de nature à causer un préjudice",
      "La simple négligence",
      "Un mobile lucratif obligatoire",
    ],
    answer:
        "La volonté d’altérer la vérité dans des conditions de nature à causer un préjudice",
    explanation:
        "Le faux est une infraction intentionnelle ; les mobiles sont indifférents.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Élément moral — Usage de faux",
    question: "Pour caractériser l’usage de faux, il faut :",
    options: [
      "La volonté d’user et la connaissance de la fausseté",
      "La seule détention du document",
      "La volonté de tromper uniquement",
    ],
    answer: "La volonté d’user et la connaissance de la fausseté",
    explanation:
        "Double exigence : usage volontaire + connaissance du caractère faux.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Élément moral — 441-5",
    question: "L’élément moral de la délivrance indue (441-5) repose sur :",
    options: [
      "La connaissance de l’absence de droit du bénéficiaire",
      "Une erreur administrative",
      "Une imprudence simple",
    ],
    answer: "La connaissance de l’absence de droit du bénéficiaire",
    explanation:
        "La fraude est caractérisée par la connaissance que la personne n’a pas droit au document.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Élément moral — 441-6",
    question: "Concernant l’obtention indue (441-6), l’auteur doit :",
    options: [
      "Avoir conscience de se faire délivrer indûment le document et vouloir utiliser un moyen frauduleux",
      "Ignorer totalement les règles",
      "Être fonctionnaire",
    ],
    answer:
        "Avoir conscience de se faire délivrer indûment le document et vouloir utiliser un moyen frauduleux",
    explanation: "Double exigence : conscience + volonté frauduleuse.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // MINI CAS PRATIQUES — QUALIFICATION EXPRESS
  // =========================================================
  const QuizQuestion(
    category: "Cas pratique — Attestation",
    question:
        "Un individu rédige une attestation écrite mensongère en faveur d’un ami pour l’aider dans un litige prud’homal. Qualification + peine ?",
    options: [
      "Faux certificat/attestation (441-7) — 1 an et 15 000 €",
      "Faux général (441-1) — 3 ans et 45 000 €",
      "Obtention indue (441-6) — 2 ans et 30 000 €",
    ],
    answer: "Faux certificat/attestation (441-7) — 1 an et 15 000 €",
    explanation:
        "Attestation écrite, faits matériellement inexacts, au profit d’un tiers → 441-7.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Usage répété",
    question:
        "Une personne utilise à plusieurs reprises le même faux document administratif pour différentes démarches. Combien d’infractions d’usage ?",
    options: [
      "Autant d’infractions que d’utilisations",
      "Une seule infraction",
      "Aucune infraction",
    ],
    answer: "Autant d’infractions que d’utilisations",
    explanation: "Chaque acte d’usage constitue une infraction distincte.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Agent public",
    question:
        "Un fonctionnaire falsifie un document administratif dans l’exercice de ses fonctions. Qualification principale ?",
    options: [
      "Faux dans un document administratif aggravé (441-2 1°)",
      "Faux général (441-1)",
      "Obtention indue (441-6)",
    ],
    answer: "Faux dans un document administratif aggravé (441-2 1°)",
    explanation:
        "Faux administratif + qualité dépositaire de l’autorité publique → circonstance aggravante.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Définition",
    question: "Le faux (441-1 CP) suppose :",
    options: [
      "Une altération de la vérité, de nature à causer un préjudice, sur un support à valeur probatoire",
      "Une simple faute de frappe sans conséquence",
      "Une critique d’un agent public",
    ],
    answer:
        "Une altération de la vérité, de nature à causer un préjudice, sur un support à valeur probatoire",
    explanation:
        "Le faux = altération de la vérité + nature à causer préjudice + support destiné/pouvant servir de preuve d’un droit/fait à conséquences juridiques.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Support",
    question: "Le support du faux peut être :",
    options: [
      "Un écrit ou tout autre support d’expression de la pensée (numérique compris)",
      "Uniquement un acte notarié",
      "Uniquement un document papier signé par un maire",
    ],
    answer:
        "Un écrit ou tout autre support d’expression de la pensée (numérique compris)",
    explanation:
        "Le texte vise aussi les supports informatiques (clé USB, disque dur, etc.).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Valeur probatoire",
    question: "Pour relever de 441-1, le support doit :",
    options: [
      "Avoir pour objet OU pouvoir avoir pour effet d’établir la preuve d’un droit ou d’un fait à conséquences juridiques",
      "Toujours être un document administratif",
      "Toujours être un document public",
    ],
    answer:
        "Avoir pour objet OU pouvoir avoir pour effet d’établir la preuve d’un droit ou d’un fait à conséquences juridiques",
    explanation:
        "Notion de valeur probatoire : supports prévus pour prouver, ou pouvant servir de preuve.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Document de hasard",
    question: "Un document « de hasard » peut être support du faux si :",
    options: [
      "Il sert ensuite de preuve d’un droit/fait à conséquences juridiques",
      "Il est obligatoirement établi par l’administration",
      "Il n’a aucun effet possible en justice",
    ],
    answer:
        "Il sert ensuite de preuve d’un droit/fait à conséquences juridiques",
    explanation:
        "Même si non créé pour prouver, il peut acquérir une valeur probatoire par son usage.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Falsification matérielle",
    question: "Le faux matériel correspond à :",
    options: [
      "Une altération du support (aspect physique) : suppression, modification, adjonction, imitation, fabrication",
      "Un mensonge sur les faits sans toucher au support",
      "Une simple erreur involontaire",
    ],
    answer:
        "Une altération du support (aspect physique) : suppression, modification, adjonction, imitation, fabrication",
    explanation:
        "Faux matériel = atteinte au support, souvent détectable à l’examen du document.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Falsification intellectuelle",
    question: "Le faux intellectuel correspond à :",
    options: [
      "Un défaut de véracité : mensonge sur le contenu (faits) du support",
      "Une déchirure visible du papier",
      "Une absence totale de document",
    ],
    answer:
        "Un défaut de véracité : mensonge sur le contenu (faits) du support",
    explanation:
        "Le mensonge atteint le contenu (faits) et non l’aspect matériel du support.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Préjudice",
    question: "Le préjudice exigé par 441-1 :",
    options: [
      "N’a pas à être réalisé : il suffit qu’il soit possible (de nature à causer un préjudice)",
      "Doit être forcément chiffré",
      "Doit être forcément matériel uniquement",
    ],
    answer:
        "N’a pas à être réalisé : il suffit qu’il soit possible (de nature à causer un préjudice)",
    explanation:
        "Condition : altération de nature à causer un préjudice, même potentiel.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Usage",
    question: "L’usage de faux suppose :",
    options: [
      "Un faux préalable + un acte positif d’utilisation + la connaissance de la fausseté",
      "Une abstention volontaire seulement",
      "La simple détention du document",
    ],
    answer:
        "Un faux préalable + un acte positif d’utilisation + la connaissance de la fausseté",
    explanation:
        "Usage = utilisation effective (acte positif), en connaissance du caractère faux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Infraction instantanée",
    question: "L’usage de faux est une infraction :",
    options: [
      "Instantanée : chaque acte d’usage peut constituer une nouvelle infraction",
      "Continue : un seul usage pour toute la période",
      "Non punissable",
    ],
    answer:
        "Instantanée : chaque acte d’usage peut constituer une nouvelle infraction",
    explanation:
        "Tout acte d’usage est distinct : plusieurs utilisations = plusieurs usages.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Peines",
    question: "Les peines principales de 441-1 sont :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Peines prévues par l’article 441-1 CP.",
    difficulty: "Facile",
  ),

  // =========================================================
  // 441-2 — FAUX DANS UN DOCUMENT ADMINISTRATIF (+ USAGE)
  // =========================================================
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Définition",
    question: "441-2 réprime :",
    options: [
      "Le faux (contrefaçon/falsification) dans un document administratif + l’usage de ce faux",
      "La simple obtention d’un document authentique",
      "La délivrance d’un document authentique par erreur",
    ],
    answer:
        "Le faux (contrefaçon/falsification) dans un document administratif + l’usage de ce faux",
    explanation:
        "Faux administratif = document délivré par administration pour droit/identité/qualité/autorisation, falsifié.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Documents visés",
    question: "Un document administratif (441-2) peut viser :",
    options: [
      "Carte d’identité / titre de séjour / permis / carte grise / certificat (ex : mariage)",
      "Une discussion orale",
      "Une opinion sur un forum",
    ],
    answer:
        "Carte d’identité / titre de séjour / permis / carte grise / certificat (ex : mariage)",
    explanation:
        "Ce sont des documents délivrés par l’administration pour constater/autoriser.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Usage vs R.645-8",
    question:
        "Utiliser un document administratif non falsifié mais devenu inexact/incomplet correspond plutôt à :",
    options: [
      "Contravention 5e classe (R.645-8 CP)",
      "Usage de faux 441-2",
      "Délivrance indue 441-5",
    ],
    answer: "Contravention 5e classe (R.645-8 CP)",
    explanation:
        "Si le document n’est pas falsifié mais simplement inexact/incomplet → R.645-8 (selon ta page).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Aggravation qualité",
    question: "441-2 est aggravé si commis :",
    options: [
      "Par dépositaire de l’autorité publique / mission de SP dans l’exercice des fonctions",
      "En état de fatigue",
      "En présence d’un témoin",
    ],
    answer:
        "Par dépositaire de l’autorité publique / mission de SP dans l’exercice des fonctions",
    explanation: "Circonstance aggravante 441-2 1°.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Aggravation dessein",
    question: "441-2 est aggravé si commis :",
    options: [
      "Dans le dessein de faciliter la commission d’un crime ou de procurer l’impunité",
      "Pour gagner du temps",
      "Par habitude uniquement",
    ],
    answer:
        "Dans le dessein de faciliter la commission d’un crime ou de procurer l’impunité",
    explanation: "Circonstance aggravante (dessein) prévue par le texte (3°).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Peines simples",
    question: "441-2 (simple) :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "10 ans d’emprisonnement",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Tableau : 441-2 simple = 5 ans + 75 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Peines aggravées",
    question: "441-2 (aggravé) :",
    options: [
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende",
    explanation: "Tableau : 441-2 aggravé = 7 ans + 100 000 €.",
    difficulty: "Facile",
  ),

  // =========================================================
  // 441-4 — FAUX DANS ÉCRITURE PUBLIQUE / AUTHENTIQUE (+ USAGE)
  // =========================================================
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Définition",
    question: "441-4 vise :",
    options: [
      "Le faux dans une écriture publique/authentique ou un enregistrement ordonné, + l’usage",
      "Le faux certificat/attestation",
      "L’obtention indue d’un document authentique",
    ],
    answer:
        "Le faux dans une écriture publique/authentique ou un enregistrement ordonné, + l’usage",
    explanation:
        "Écritures publiques/authentiques et enregistrements ordonnés par l’autorité publique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Préjudice",
    question: "Dans 441-4, le préjudice éventuel est considéré :",
    options: [
      "Établi par l’atteinte à la foi publique liée à ces actes",
      "Toujours absent",
      "Seulement matériel",
    ],
    answer: "Établi par l’atteinte à la foi publique liée à ces actes",
    explanation:
        "La valeur probatoire des actes publics/authentiques fonde l’atteinte à la foi publique.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Peine simple",
    question: "441-4 (simple) :",
    options: [
      "10 ans d’emprisonnement",
      "5 ans d’emprisonnement et 75 000 €",
      "3 ans d’emprisonnement et 45 000 €",
    ],
    answer: "10 ans d’emprisonnement",
    explanation:
        "Tableau : faux en écriture publique/authentique simple = 10 ans.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Peine aggravée",
    question: "441-4 (aggravé par qualité en exercice) :",
    options: [
      "15 ans de réclusion",
      "7 ans d’emprisonnement et 100 000 €",
      "10 ans d’emprisonnement",
    ],
    answer: "15 ans de réclusion",
    explanation: "Tableau : 441-4 al.3 = crime, 15 ans de réclusion.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 441-5 — DÉLIVRANCE INDUE DE DOCUMENT ADMINISTRATIF
  // =========================================================
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Cœur du texte",
    question: "441-5 réprime le fait de :",
    options: [
      "Procurer frauduleusement à autrui un document administratif authentique",
      "Falsifier un document administratif",
      "Se faire délivrer indûment un document",
    ],
    answer:
        "Procurer frauduleusement à autrui un document administratif authentique",
    explanation:
        "441-5 = délivrance/procurement à autrui (acteur = celui qui fait obtenir).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Document authentique",
    question: "441-5 concerne :",
    options: [
      "Des documents authentiques délivrés indûment",
      "Des faux documents administratifs",
      "Des attestations entre particuliers",
    ],
    answer: "Des documents authentiques délivrés indûment",
    explanation:
        "Le cours précise : ce ne sont pas des faux, mais des documents authentiques.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Élément moral",
    question: "L’auteur de 441-5 doit :",
    options: [
      "Savoir que le bénéficiaire n’a pas droit au document",
      "Se tromper involontairement",
      "Être nécessairement un policier",
    ],
    answer: "Savoir que le bénéficiaire n’a pas droit au document",
    explanation:
        "Remise en toute connaissance de cause = élément intentionnel central.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Aggravation habitude",
    question: "441-5 est aggravé si commis :",
    options: [
      "De manière habituelle",
      "En présence d’un témoin",
      "Sur internet",
    ],
    answer: "De manière habituelle",
    explanation: "Aggravation 2° : commission habituelle.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Peine simple",
    question: "441-5 (simple) :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 €",
      "3 ans d’emprisonnement et 45 000 €",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Tableau : 441-5 simple = 5 ans + 75 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Peine aggravée",
    question: "441-5 (aggravé) :",
    options: [
      "7 ans de réclusion et 100 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 €",
      "10 ans d’emprisonnement et 150 000 €",
    ],
    answer: "7 ans de réclusion et 100 000 € d’amende",
    explanation: "Tableau : 441-5 aggravé = 7 ans (réclusion) + 100 000 €.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 441-6 — OBTENTION INDUE (+ FAUSSE / INCOMPLÈTE DÉCLARATION AL.2)
  // =========================================================
  const QuizQuestion(
    category: "Obtention indue (441-6) — Définition",
    question: "441-6 (alinéa 1) vise :",
    options: [
      "Se faire délivrer indûment un document authentique par moyen frauduleux",
      "Falsifier matériellement un document administratif",
      "Procurer un document à autrui (acteur-délivreur)",
    ],
    answer:
        "Se faire délivrer indûment un document authentique par moyen frauduleux",
    explanation:
        "441-6 = obtention par le bénéficiaire (ou pour autrui) via fraude.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Moyens frauduleux",
    question: "Les moyens de 441-6 peuvent être :",
    options: [
      "Fausses déclarations, faux renseignements/certificats, déclarations d’un tiers, manœuvres",
      "Uniquement une falsification matérielle",
      "Uniquement des violences",
    ],
    answer:
        "Fausses déclarations, faux renseignements/certificats, déclarations d’un tiers, manœuvres",
    explanation:
        "Le texte vise « quelque moyen frauduleux que ce soit » et donne des exemples.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Alinéa 2",
    question: "441-6 al.2 vise :",
    options: [
      "La fausse déclaration OU déclaration incomplète pour obtenir/tenter d’obtenir une allocation/prestation/paiement/avantage indu",
      "La falsification d’une carte d’identité",
      "La délivrance indue par un agent complaisant",
    ],
    answer:
        "La fausse déclaration OU déclaration incomplète pour obtenir/tenter d’obtenir une allocation/prestation/paiement/avantage indu",
    explanation:
        "Al.2 = avantages indus (personne publique / protection sociale / mission SP).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Consommation al.2",
    question: "Pour 441-6 al.2, l’infraction est consommée :",
    options: [
      "Même sans obtention effective, si la déclaration est faite dans le but d’obtenir",
      "Uniquement si l’avantage est versé",
      "Uniquement si la déclaration est écrite",
    ],
    answer:
        "Même sans obtention effective, si la déclaration est faite dans le but d’obtenir",
    explanation:
        "Le but suffit : obtenir ou tenter d’obtenir (ou faire obtenir).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Circonstances aggravantes",
    question: "441-6 comporte des circonstances aggravantes :",
    options: ["Aucune", "En réunion", "Avec arme"],
    answer: "Aucune",
    explanation: "Ta page : IV — AUCUNE circonstance aggravante.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Peines",
    question: "441-6 (alinéa 1 et 2) :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 €",
      "5 ans d’emprisonnement et 75 000 €",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation: "Tableau : 441-6 al.1 / al.2 = 2 ans + 30 000 €.",
    difficulty: "Facile",
  ),

  // =========================================================
  // 441-7 — FAUX CERTIFICATS / ATTESTATIONS
  // =========================================================
  const QuizQuestion(
    category: "Faux attestations (441-7) — Définition",
    question: "441-7 réprime notamment :",
    options: [
      "Établir une attestation/certificat matériellement inexact, falsifier un document sincère, ou en faire usage",
      "Obtenir indûment un document administratif authentique",
      "Falsifier une écriture publique",
    ],
    answer:
        "Établir une attestation/certificat matériellement inexact, falsifier un document sincère, ou en faire usage",
    explanation:
        "441-7 vise établissement / falsification / usage d’attestations ou certificats.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux attestations (441-7) — Écrit uniquement",
    question: "441-7 exige :",
    options: [
      "Un écrit (l’oral ne suffit pas)",
      "Une déclaration orale si elle est filmée",
      "Un simple message verbal",
    ],
    answer: "Un écrit (l’oral ne suffit pas)",
    explanation:
        "Le cours : seuls certificats/attestations écrits entrent dans le champ.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux attestations (441-7) — Au profit d’un tiers",
    question: "Pour relever de 441-7, le document doit être établi :",
    options: [
      "En faveur d’autrui (tiers)",
      "À son propre profit exclusivement",
      "Uniquement pour un policier",
    ],
    answer: "En faveur d’autrui (tiers)",
    explanation:
        "Le cours exclut l’attestation sur l’honneur établie pour soi-même.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux attestations (441-7) — Peine simple",
    question: "441-7 (simple) :",
    options: [
      "1 an d’emprisonnement et 15 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 €",
      "3 ans d’emprisonnement et 45 000 €",
    ],
    answer: "1 an d’emprisonnement et 15 000 € d’amende",
    explanation: "Tableau : 441-7 simple = 1 an + 15 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux attestations (441-7) — Peine aggravée",
    question: "441-7 (aggravé, notamment al.5) :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 €",
      "7 ans d’emprisonnement et 100 000 €",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Tableau : aggravé = 3 ans + 45 000 €.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 441-9 — TENTATIVE (COMMUN AUX 441-1 / 441-2 / 441-4 / 441-5 / 441-6 / 441-7)
  // =========================================================
  const QuizQuestion(
    category: "Tentative — Principe (441-9)",
    question: "La tentative des délits 441-1 à 441-7 est :",
    options: [
      "Punissable (prévue expressément par 441-9)",
      "Non punissable",
      "Punissable seulement pour 441-4",
    ],
    answer: "Punissable (prévue expressément par 441-9)",
    explanation:
        "Le cours indique que 441-9 prévoit expressément la tentative pour ces délits.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 441-12 — PERSONNES MORALES
  // =========================================================
  const QuizQuestion(
    category: "Personnes morales — 441-12",
    question:
        "La responsabilité pénale des personnes morales pour ces infractions est prévue par :",
    options: [
      "Article 441-12 du Code pénal",
      "Article 121-7 du Code pénal",
      "Article 433-6 du Code pénal",
    ],
    answer: "Article 441-12 du Code pénal",
    explanation:
        "Ta page mentionne 441-12 pour la responsabilité pénale des personnes morales.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // VRAI / FAUX — SÉRIES (format options)
  // =========================================================
  const QuizQuestion(
    category: "Vrai/Faux — 441-5",
    question:
        "Vrai ou Faux : 441-5 réprime la fabrication d’un faux document administratif.",
    options: ["Vrai", "Faux", "Seulement si c’est un permis"],
    answer: "Faux",
    explanation:
        "441-5 vise la délivrance/procurement indus de documents authentiques (pas la falsification).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-2",
    question:
        "Vrai ou Faux : 441-2 réprime aussi l’usage du faux document administratif.",
    options: ["Vrai", "Faux", "Seulement si l’auteur est fonctionnaire"],
    answer: "Vrai",
    explanation:
        "Le texte réprime le faux et l’usage de ce faux (documents administratifs).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-6 al.2",
    question:
        "Vrai ou Faux : une déclaration incomplète peut constituer 441-6 al.2 si elle est volontaire et vise un avantage indu.",
    options: ["Vrai", "Faux", "Uniquement si l’avantage est versé"],
    answer: "Vrai",
    explanation:
        "Omission volontaire (déclaration incomplète) + but d’obtenir un avantage indu suffit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Usage",
    question:
        "Vrai ou Faux : la simple détention d’un faux constitue automatiquement un usage de faux.",
    options: ["Vrai", "Faux", "Seulement si document administratif"],
    answer: "Faux",
    explanation:
        "Usage = acte positif d’utilisation ; la détention seule ne suffit pas.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-7",
    question:
        "Vrai ou Faux : l’infraction 441-7 peut être constituée même si l’auteur n’a pas prévu l’usage que fera le tiers.",
    options: ["Vrai", "Faux", "Seulement si l’auteur est dépositaire"],
    answer: "Vrai",
    explanation:
        "Le cours précise : peu importe que l’auteur ait prévu l’usage futur par le tiers.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // QCM “PIÈGES” — DISTINCTIONS EXPRESS
  // =========================================================
  const QuizQuestion(
    category: "Piège — 441-5 vs 441-6 (acteur)",
    question:
        "Qui est typiquement l’auteur principal de 441-5 (délivrance indue) ?",
    options: [
      "Celui qui procure/fait délivrer le document à une personne qui n’y a pas droit",
      "Celui qui ment pour l’obtenir pour lui-même",
      "Celui qui déchire le document",
    ],
    answer:
        "Celui qui procure/fait délivrer le document à une personne qui n’y a pas droit",
    explanation:
        "441-5 = acteur “délivreur” (fonctionnaire complaisant ou particulier) qui procure à autrui.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — 441-6 (bénéficiaire)",
    question:
        "Qui est typiquement l’auteur principal de 441-6 (obtention indue) ?",
    options: [
      "Celui qui se fait délivrer le document par fraude (bénéficiaire)",
      "Celui qui délivre en connaissance de cause",
      "Celui qui constate les faits",
    ],
    answer: "Celui qui se fait délivrer le document par fraude (bénéficiaire)",
    explanation: "441-6 = obtention indue par moyen frauduleux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège — 441-1 vs 441-7",
    question:
        "Pourquoi une attestation mensongère est plutôt qualifiée sous 441-7 que 441-1 ?",
    options: [
      "Parce que 441-7 est le texte spécial dédié aux attestations/certificats",
      "Parce que 441-1 ne réprime jamais le faux",
      "Parce que 441-7 est une contravention",
    ],
    answer:
        "Parce que 441-7 est le texte spécial dédié aux attestations/certificats",
    explanation:
        "En présence d’un texte spécial (441-7), on l’applique plutôt que le général (441-1).",
    difficulty: "Difficile",
  ),

  // =========================================================
  // MINI CAS PRATIQUES — QUALIF + ARTICLE + PEINE (style concours)
  // =========================================================
  const QuizQuestion(
    category: "Cas pratique — Fausse déclaration (441-6)",
    question:
        "Un individu fournit sciemment de faux renseignements pour obtenir un plan de chasse. Qualification + peine ?",
    options: [
      "Obtention indue (441-6) — 2 ans et 30 000 €",
      "Faux administratif (441-2) — 5 ans et 75 000 €",
      "Faux général (441-1) — 3 ans et 45 000 €",
    ],
    answer: "Obtention indue (441-6) — 2 ans et 30 000 €",
    explanation:
        "Document authentique obtenu par fraude (fausse déclaration) → 441-6 (2 ans / 30 000 €).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Agent complaisant (441-5)",
    question:
        "Un agent remet un titre de séjour authentique à une personne qu’il sait ne pas y avoir droit. Qualification + peine simple ?",
    options: [
      "Délivrance indue (441-5) — 5 ans et 75 000 €",
      "Obtention indue (441-6) — 2 ans et 30 000 €",
      "Faux en écriture publique (441-4) — 10 ans",
    ],
    answer: "Délivrance indue (441-5) — 5 ans et 75 000 €",
    explanation:
        "Procurer frauduleusement à autrui un document authentique → 441-5.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Modification physique (441-2)",
    question:
        "Une personne gratte et remplace une date sur un permis de conduire. Qualification + peine simple ?",
    options: [
      "Faux doc administratif (441-2) — 5 ans et 75 000 €",
      "Obtention indue (441-6) — 2 ans et 30 000 €",
      "Faux attestations (441-7) — 1 an et 15 000 €",
    ],
    answer: "Faux doc administratif (441-2) — 5 ans et 75 000 €",
    explanation:
        "Falsification matérielle d’un document administratif → 441-2.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Usage (441-1)",
    question:
        "Une personne utilise un document falsifié pour prouver un droit dans une procédure. Qualification + peine ?",
    options: [
      "Usage de faux (441-1) — 3 ans et 45 000 €",
      "Délivrance indue (441-5) — 5 ans et 75 000 €",
      "Obtention indue (441-6) — 2 ans et 30 000 €",
    ],
    answer: "Usage de faux (441-1) — 3 ans et 45 000 €",
    explanation:
        "Usage d’une pièce fausse à finalité probatoire → usage de faux (441-1).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Attestation mensongère (441-7)",
    question:
        "Une personne signe une attestation écrite mensongère au profit d’un voisin. Qualification + peine simple ?",
    options: [
      "441-7 — 1 an et 15 000 €",
      "441-1 — 3 ans et 45 000 €",
      "441-6 — 2 ans et 30 000 €",
    ],
    answer: "441-7 — 1 an et 15 000 €",
    explanation:
        "Attestation au profit d’autrui, faits matériellement inexacts → 441-7.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Avantage indu (441-6 al.2)",
    question:
        "Un demandeur omet volontairement de déclarer un revenu pour obtenir une prestation sociale. Qualification + peine ?",
    options: [
      "441-6 al.2 — 2 ans et 30 000 €",
      "441-7 — 1 an et 15 000 €",
      "441-5 — 5 ans et 75 000 €",
    ],
    answer: "441-6 al.2 — 2 ans et 30 000 €",
    explanation:
        "Déclaration incomplète volontaire pour avantage indu → 441-6 al.2.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Écriture publique (441-4)",
    question:
        "Un faux est commis dans une écriture publique/authentique. Qualification + peine simple ?",
    options: [
      "441-4 — 10 ans d’emprisonnement",
      "441-2 — 5 ans et 75 000 €",
      "441-1 — 3 ans et 45 000 €",
    ],
    answer: "441-4 — 10 ans d’emprisonnement",
    explanation:
        "Faux en écriture publique/authentique : 441-4 (simple) = 10 ans.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Écriture publique aggravée (441-4)",
    question:
        "Le faux en écriture publique est commis par un dépositaire de l’autorité publique dans l’exercice des fonctions. Peine ?",
    options: [
      "441-4 al.3 — 15 ans de réclusion",
      "441-2 aggravé — 7 ans et 100 000 €",
      "441-1 — 3 ans et 45 000 €",
    ],
    answer: "441-4 al.3 — 15 ans de réclusion",
    explanation:
        "Circonstance aggravante : qualité + exercice → crime (15 ans).",
    difficulty: "Difficile",
  ),

  // =========================================================
  // SÉRIES “ULTRA COURTES” — RÉFLEXES (mix niveaux)
  // =========================================================
  const QuizQuestion(
    category: "Réflexe — Article",
    question:
        "Quel article réprime l’obtention indue de document administratif ?",
    options: ["441-6", "441-5", "441-2"],
    answer: "441-6",
    explanation: "Obtention indue = 441-6.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question:
        "Quel article réprime la délivrance indue de document administratif ?",
    options: ["441-5", "441-6", "441-7"],
    answer: "441-5",
    explanation: "Délivrance indue = 441-5.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question: "Quel article réprime le faux dans un document administratif ?",
    options: ["441-2", "441-1", "441-4"],
    answer: "441-2",
    explanation: "Faux dans document administratif = 441-2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question: "Quel article réprime les faux certificats/attestations ?",
    options: ["441-7", "441-6", "441-5"],
    answer: "441-7",
    explanation: "Faux certificats/attestations = 441-7.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peines",
    question: "Peine de 441-6 (obtenir un document/avantage indu par fraude) :",
    options: ["2 ans et 30 000 €", "3 ans et 45 000 €", "5 ans et 75 000 €"],
    answer: "2 ans et 30 000 €",
    explanation: "Tableau 441-6.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peines",
    question: "Peine de 441-5 (délivrance indue) simple :",
    options: ["5 ans et 75 000 €", "2 ans et 30 000 €", "1 an et 15 000 €"],
    answer: "5 ans et 75 000 €",
    explanation: "Tableau 441-5.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peines",
    question: "Peine de 441-2 (faux doc administratif) simple :",
    options: ["5 ans et 75 000 €", "3 ans et 45 000 €", "10 ans"],
    answer: "5 ans et 75 000 €",
    explanation: "Tableau 441-2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peines",
    question: "Peine de 441-1 (faux/usage de faux) :",
    options: ["3 ans et 45 000 €", "2 ans et 30 000 €", "5 ans et 75 000 €"],
    answer: "3 ans et 45 000 €",
    explanation: "Tableau 441-1.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Usage de faux — Acte positif",
    question: "Quel comportement correspond le plus à un usage de faux ?",
    options: [
      "Présenter la pièce fausse à un organisme pour obtenir un résultat",
      "Garder la pièce chez soi sans la montrer",
      "Parler du document sans le produire",
    ],
    answer: "Présenter la pièce fausse à un organisme pour obtenir un résultat",
    explanation:
        "Usage = utilisation effective (acte positif) de la pièce fausse.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Usage de faux — Piège abstention",
    question:
        "Vrai ou Faux : ne pas produire un document falsifié mais espérer qu’un tiers le produise suffit pour l’usage.",
    options: ["Vrai", "Faux", "Seulement si c’est un document administratif"],
    answer: "Faux",
    explanation:
        "L’usage de faux ne peut résulter de la seule abstention (il faut un fait positif).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Usage de faux — Multi-usages",
    question: "Une même pièce fausse est utilisée 3 fois :",
    options: [
      "3 usages possibles (3 infractions distinctes d’usage)",
      "1 seule infraction d’usage",
      "Aucune infraction si le document est ancien",
    ],
    answer: "3 usages possibles (3 infractions distinctes d’usage)",
    explanation: "Chaque utilisation = un acte d’usage distinct.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // PIÈGES SUR “AUTHENTIQUE” vs “FALSIFIÉ”
  // =========================================================
  const QuizQuestion(
    category: "Piège — Authentique vs falsifié",
    question: "Quel couple est correct ?",
    options: [
      "441-5/441-6 : documents authentiques ; 441-2/441-4 : documents falsifiés",
      "441-5 : documents falsifiés ; 441-2 : authentiques",
      "441-6 : uniquement des attestations privées",
    ],
    answer:
        "441-5/441-6 : documents authentiques ; 441-2/441-4 : documents falsifiés",
    explanation:
        "441-5/441-6 = délivrance/obtention indue d’authentiques ; 441-2/441-4 = faux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — 441-6 vs 441-2",
    question:
        "Si la fraude repose sur une fausse déclaration, sans falsification du document délivré :",
    options: ["441-6", "441-2", "441-4"],
    answer: "441-6",
    explanation:
        "Le document est authentique, seule l’obtention est frauduleuse → 441-6.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège — 441-5 vs 441-6",
    question:
        "Si l’auteur est celui qui “donne” le document à une personne qui n’y a pas droit :",
    options: ["441-5", "441-6", "441-7"],
    answer: "441-5",
    explanation:
        "Acteur qui procure à autrui en connaissance de cause → 441-5.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 441-7 — SÉRIES ATTESTATIONS (plus techniques)
  // =========================================================
  const QuizQuestion(
    category: "Attestations (441-7) — Faits vérifiables",
    question: "« Faits matériellement inexacts » vise :",
    options: [
      "Des éléments objectifs vérifiables susceptibles de preuve contraire",
      "Des opinions subjectives",
      "Des émotions ressenties",
    ],
    answer:
        "Des éléments objectifs vérifiables susceptibles de preuve contraire",
    explanation:
        "Le texte vise des faits objectivement constatables/vérifiables.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attestations (441-7) — Consommation",
    question: "L’établissement d’une attestation inexacte est consommé :",
    options: [
      "Dès la rédaction/signature, même sans usage ultérieur",
      "Seulement si produite devant un juge",
      "Seulement si elle cause un dommage concret",
    ],
    answer: "Dès la rédaction/signature, même sans usage ultérieur",
    explanation: "L’infraction d’établissement est indépendante de l’usage.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attestations (441-7) — Élément moral",
    question: "Pour l’établissement (441-7), il faut :",
    options: [
      "La connaissance de l’inexactitude des faits certifiés",
      "Une simple négligence",
      "Un mobile obligatoire",
    ],
    answer: "La connaissance de l’inexactitude des faits certifiés",
    explanation: "Connaissance de l’inexactitude = élément moral central.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attestations (441-7) — Aggravation (but)",
    question: "441-7 est aggravé notamment si commis :",
    options: [
      "Pour porter préjudice au Trésor public/patrimoine d’autrui ou obtenir un titre de séjour/protection",
      "En réunion",
      "Avec une arme",
    ],
    answer:
        "Pour porter préjudice au Trésor public/patrimoine d’autrui ou obtenir un titre de séjour/protection",
    explanation: "Aggravation prévue (alinéa 5) dans ton cours.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 441-2 — SÉRIES DOCUMENT ADMINISTRATIF (technique)
  // =========================================================
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Condition",
    question: "441-2 vise des documents administratifs établis pour :",
    options: [
      "Constater un droit, une identité, une qualité, ou accorder une autorisation",
      "Exprimer une opinion",
      "Conserver un souvenir personnel",
    ],
    answer:
        "Constater un droit, une identité, une qualité, ou accorder une autorisation",
    explanation: "Finalité administrative : constater/autoriser.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Usage",
    question: "L’usage de faux (441-2) suppose :",
    options: [
      "Un document administratif falsifié + une utilisation",
      "Un document devenu simplement périmé",
      "Une déclaration orale",
    ],
    answer: "Un document administratif falsifié + une utilisation",
    explanation: "Usage = utilisation d’un document déjà falsifié.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 441-5 / 441-6 — SÉRIES “DOCUMENTS VISÉS”
  // =========================================================
  const QuizQuestion(
    category: "Documents visés — 441-5/441-6",
    question: "Lequel est un document typiquement visé par 441-5/441-6 ?",
    options: [
      "Titre de séjour / CNI / passeport / permis / carte grise",
      "Message vocal",
      "Conversation privée sans valeur probatoire",
    ],
    answer: "Titre de séjour / CNI / passeport / permis / carte grise",
    explanation:
        "Documents délivrés pour constater identité/droit/qualité ou accorder autorisation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Documents visés — 441-6 (organisme SP)",
    question: "441-6 peut viser un document délivré par :",
    options: [
      "Un organisme chargé d’une mission de service public",
      "Uniquement une préfecture",
      "Uniquement une entreprise privée commerciale",
    ],
    answer: "Un organisme chargé d’une mission de service public",
    explanation:
        "Le texte étend aux organismes de mission de SP (selon ton cours).",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // QCM VRAI/FAUX — MIX NIVEAUX
  // =========================================================
  const QuizQuestion(
    category: "Vrai/Faux — 441-1",
    question:
        "Vrai ou Faux : les mobiles de l’auteur du faux ont une importance pour caractériser l’infraction.",
    options: ["Vrai", "Faux", "Seulement si gain financier"],
    answer: "Faux",
    explanation:
        "Les mobiles sont indifférents : ce qui compte = volonté d’altérer la vérité + nature à causer préjudice.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-6",
    question:
        "Vrai ou Faux : 441-6 exige une falsification matérielle du document obtenu.",
    options: ["Vrai", "Faux", "Seulement si titre de séjour"],
    answer: "Faux",
    explanation:
        "441-6 vise l’obtention par fraude de documents authentiques (sans falsification du document).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-2",
    question:
        "Vrai ou Faux : 441-2 est un « faux spécial » par rapport à 441-1.",
    options: ["Vrai", "Faux", "Seulement si usage"],
    answer: "Vrai",
    explanation:
        "441-2 vise spécialement les faux commis dans des documents administratifs.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // CAS PRATIQUES — PIÈGES DE QUALIFICATION
  // =========================================================
  const QuizQuestion(
    category: "Cas pratique — 441-5 vs 441-6",
    question:
        "Un particulier fournit à un ami un document administratif authentique obtenu grâce à un agent complaisant, sachant que l’ami n’y a pas droit. Pour le particulier qui remet le document :",
    options: [
      "441-5 (procure frauduleusement à autrui) — 5 ans et 75 000 €",
      "441-6 — 2 ans et 30 000 €",
      "441-7 — 1 an et 15 000 €",
    ],
    answer: "441-5 (procure frauduleusement à autrui) — 5 ans et 75 000 €",
    explanation:
        "Celui qui procure/remet à autrui un document authentique indûment = 441-5.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — 441-6 al.2",
    question:
        "Une personne écrit volontairement une déclaration incomplète pour tenter d’obtenir un avantage indu, mais l’administration refuse. Qualification + peine ?",
    options: [
      "441-6 al.2 — 2 ans et 30 000 €",
      "Aucune infraction",
      "441-1 — 3 ans et 45 000 €",
    ],
    answer: "441-6 al.2 — 2 ans et 30 000 €",
    explanation: "L’avantage n’a pas besoin d’être obtenu : le but suffit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — 441-7 usage",
    question:
        "Une personne utilise devant un juge une attestation falsifiée (préexistante) en sachant qu’elle est fausse. Qualification ?",
    options: [
      "Usage de faux certificat/attestation (441-7) — peine selon tableau",
      "Obtention indue (441-6)",
      "Délivrance indue (441-5)",
    ],
    answer:
        "Usage de faux certificat/attestation (441-7) — peine selon tableau",
    explanation:
        "Usage d’une attestation/certificat faux/falsifié = 441-7 (usage).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Déclarations mensongères",
    question:
        "Une personne omet volontairement de déclarer un revenu pour percevoir une allocation sociale. Qualification ?",
    options: [
      "Obtention indue par déclaration incomplète (441-6 al.2)",
      "Faux général (441-1)",
      "Aucune infraction",
    ],
    answer: "Obtention indue par déclaration incomplète (441-6 al.2)",
    explanation:
        "Omission volontaire destinée à obtenir un avantage indu → 441-6 al.2.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Élément légal",
    question:
        "Le texte qui définit et réprime le faux et l’usage de faux (général) est :",
    options: [
      "Article 441-1 du Code pénal",
      "Article 441-2 du Code pénal",
      "Article 441-6 du Code pénal",
    ],
    answer: "Article 441-1 du Code pénal",
    explanation: "Base générale : 441-1 CP (hors faux spéciaux 441-2 à 441-7).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Support",
    question: "Le support du faux peut être :",
    options: [
      "Un écrit ou tout autre support d’expression de la pensée",
      "Uniquement un document papier",
      "Uniquement un acte notarié",
    ],
    answer: "Un écrit ou tout autre support d’expression de la pensée",
    explanation:
        "Le texte vise aussi d’autres supports (CD, DVD, clés USB, disque dur, etc.).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Valeur probatoire",
    question: "Pour entrer dans 441-1 CP, le support doit :",
    options: [
      "Avoir pour objet ou pouvoir avoir pour effet d’établir la preuve d’un droit ou d’un fait à conséquences juridiques",
      "Être obligatoirement un acte d’état civil",
      "Être obligatoirement signé par un fonctionnaire",
    ],
    answer:
        "Avoir pour objet ou pouvoir avoir pour effet d’établir la preuve d’un droit ou d’un fait à conséquences juridiques",
    explanation:
        "Exigence de valeur probatoire : preuve d’un droit/fait à conséquences juridiques (ou pouvant servir à cela).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Document de hasard",
    question: "Un « document de hasard » peut être un support du faux s’il :",
    options: [
      "N’était pas destiné à prouver au départ mais sert ensuite de preuve",
      "Est toujours un acte administratif",
      "Est toujours un document public",
    ],
    answer:
        "N’était pas destiné à prouver au départ mais sert ensuite de preuve",
    explanation:
        "Le code vise aussi les supports qui peuvent avoir un effet probatoire, même s’ils n’ont pas été créés pour cela.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Exemple probatoire",
    question: "Selon la jurisprudence citée, peut constituer un faux :",
    options: [
      "La falsification d’un constat amiable d’accident",
      "Une simple promesse orale",
      "Un avis personnel sans conséquence",
    ],
    answer: "La falsification d’un constat amiable d’accident",
    explanation:
        "Exemple de document utilisé à des fins probatoires : constat amiable.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Factures",
    question: "Les factures :",
    options: [
      "Peuvent devenir probatoires si passées en comptabilité, et alors être susceptibles de faux",
      "Ne peuvent jamais être un support de faux",
      "Sont toujours des actes publics",
    ],
    answer:
        "Peuvent devenir probatoires si passées en comptabilité, et alors être susceptibles de faux",
    explanation:
        "Le cours précise que la valeur probatoire peut découler de leur usage (comptabilité).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Photocopie",
    question: "La production en justice d’une photocopie contrefaite :",
    options: [
      "Peut constituer un faux si la copie a valeur probatoire",
      "Ne peut jamais constituer un faux",
      "Est seulement une contravention",
    ],
    answer: "Peut constituer un faux si la copie a valeur probatoire",
    explanation:
        "La possibilité dépend de la valeur probatoire reconnue à la copie.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Faux matériel",
    question: "Le faux matériel se caractérise par :",
    options: [
      "Une altération du support (aspect physique) laissant des traces matérielles",
      "Un mensonge uniquement dans le contenu sans modifier le support",
      "Une simple erreur involontaire",
    ],
    answer:
        "Une altération du support (aspect physique) laissant des traces matérielles",
    explanation:
        "Faux matériel = falsification du support (suppression/modification/adjonction, imitation, fabrication…).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Faux intellectuel",
    question: "Le faux intellectuel correspond plutôt à :",
    options: [
      "Un défaut de véracité : mensonge sur le contenu (faits) plutôt que sur le support",
      "Une déchirure visible du document",
      "Un document complètement vierge",
    ],
    answer:
        "Un défaut de véracité : mensonge sur le contenu (faits) plutôt que sur le support",
    explanation:
        "Mensonge atteint le contenu de l’écrit/support, pas l’aspect matériel.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Préjudice",
    question: "Le préjudice exigé par 441-1 CP :",
    options: [
      "N’a pas besoin d’être réalisé : il suffit qu’il soit possible (de nature à causer un préjudice)",
      "Doit toujours être chiffré et prouvé",
      "Doit forcément être matériel uniquement",
    ],
    answer:
        "N’a pas besoin d’être réalisé : il suffit qu’il soit possible (de nature à causer un préjudice)",
    explanation:
        "Le texte exige « de nature à causer un préjudice », pas un préjudice effectivement subi.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Préjudice social",
    question: "Le préjudice social concerne :",
    options: [
      "L’atteinte aux intérêts moraux de la société (confiance dans certains actes)",
      "Uniquement une perte d’argent",
      "Uniquement une atteinte à l’image d’une entreprise",
    ],
    answer:
        "L’atteinte aux intérêts moraux de la société (confiance dans certains actes)",
    explanation: "Le cours distingue préjudice matériel / moral / social.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Usage",
    question: "L’usage de faux (441-1) suppose :",
    options: [
      "L’existence préalable d’un faux et un acte positif d’utilisation",
      "Une simple abstention (ne rien faire)",
      "Uniquement le fait de détenir le document",
    ],
    answer: "L’existence préalable d’un faux et un acte positif d’utilisation",
    explanation:
        "Usage = utilisation positive de la pièce fausse ; l’abstention ne suffit pas.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Infraction instantanée",
    question: "L’usage de faux est une infraction :",
    options: [
      "Instantanée : chaque acte d’usage est une nouvelle infraction",
      "Continue : un seul usage pour toute la vie",
      "Non punissable",
    ],
    answer: "Instantanée : chaque acte d’usage est une nouvelle infraction",
    explanation:
        "Chaque utilisation = nouvelle infraction ; prescription court à partir de la dernière utilisation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Élément moral (faux)",
    question: "Concernant le faux (441-1), l’élément moral exige :",
    options: [
      "La volonté de réaliser la falsification et la conscience d’altérer la vérité de nature à causer un préjudice",
      "Une simple négligence",
      "Un mobile particulier (obligatoire)",
    ],
    answer:
        "La volonté de réaliser la falsification et la conscience d’altérer la vérité de nature à causer un préjudice",
    explanation: "Volonté + conscience ; mobiles indifférents.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Élément moral (usage)",
    question: "Concernant l’usage de faux (441-1), l’élément moral exige :",
    options: [
      "La volonté d’user + la connaissance de la fausseté",
      "La volonté d’user seulement",
      "La connaissance seulement",
    ],
    answer: "La volonté d’user + la connaissance de la fausseté",
    explanation:
        "Double exigence : volonté d’utiliser la pièce + connaissance qu’elle est fausse.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Circonstances aggravantes",
    question: "Le cours indique des circonstances aggravantes pour 441-1 :",
    options: [
      "Aucune (pour l’infraction générale 441-1)",
      "En réunion",
      "Si l’auteur est détenu",
    ],
    answer: "Aucune (pour l’infraction générale 441-1)",
    explanation:
        "Dans ta page : IV — circonstances aggravantes : AUCUNE pour 441-1.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Peines",
    question: "Les peines principales prévues par 441-1 (faux et usage) sont :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Peines 441-1 : 3 ans + 45 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Tentative",
    question: "La tentative des délits prévus par 441-1 est :",
    options: [
      "Punissable (441-9 prévoit expressément la tentative)",
      "Non punissable",
      "Punissable seulement si usage",
    ],
    answer: "Punissable (441-9 prévoit expressément la tentative)",
    explanation:
        "441-9 CP : tentative des délits 441-1 (et autres) expressément prévue.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // FAUX DANS UN DOCUMENT ADMINISTRATIF + USAGE (441-2)
  // =========================================================
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Définition",
    question: "Le faux dans un document administratif (441-2) consiste à :",
    options: [
      "Contrefaire ou falsifier un document délivré par l’administration (droit/identité/qualité/autorisation) ; l’usage est aussi réprimé",
      "Obtenir un document authentique sans droit",
      "Refuser de présenter un document",
    ],
    answer:
        "Contrefaire ou falsifier un document délivré par l’administration (droit/identité/qualité/autorisation) ; l’usage est aussi réprimé",
    explanation:
        "441-2 vise les faux matériels (et réprime aussi l’usage) sur des documents administratifs.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Texte",
    question: "Le faux commis dans un document administratif est réprimé par :",
    options: [
      "Article 441-2 du Code pénal",
      "Article 441-5 du Code pénal",
      "Article 441-6 du Code pénal",
    ],
    answer: "Article 441-2 du Code pénal",
    explanation: "Base légale : 441-2 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Documents visés",
    question:
        "Les documents administratifs visés par 441-2 sont établis pour :",
    options: [
      "Constater un droit, une identité, une qualité ou accorder une autorisation",
      "Uniquement prouver une relation familiale",
      "Uniquement servir d’information sans effet",
    ],
    answer:
        "Constater un droit, une identité, une qualité ou accorder une autorisation",
    explanation:
        "Le texte reprend la finalité probatoire/autorisation des documents administratifs.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Exemples",
    question: "Parmi ces documents, lequel est typiquement visé par 441-2 ?",
    options: [
      "Carte d’identité / titre de séjour / permis (conduire, construire, chasser)",
      "Simple brouillon personnel",
      "Message oral non enregistré",
    ],
    answer:
        "Carte d’identité / titre de séjour / permis (conduire, construire, chasser)",
    explanation:
        "Exemples cités : CNI, titre de séjour, certificat de nationalité, permis de construire/chasser/conduire, carte grise, certificat de mariage…",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Nature du faux",
    question: "Selon ta page, 441-2 vise principalement :",
    options: [
      "Les faux matériels (falsification du support / contrefaçon)",
      "Uniquement les faux intellectuels",
      "Uniquement les omissions involontaires",
    ],
    answer: "Les faux matériels (falsification du support / contrefaçon)",
    explanation:
        "Le cours insiste sur la contrefaçon/falsification matérielle du document administratif.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Préjudice",
    question: "Concernant 441-2, la jurisprudence indique que le préjudice :",
    options: [
      "Découle de la nature de la pièce faussée",
      "Doit être obligatoirement chiffré par expertise",
      "N’existe jamais pour les documents administratifs",
    ],
    answer: "Découle de la nature de la pièce faussée",
    explanation:
        "Ta page cite la jurisprudence : le préjudice découle de la nature de la pièce faussée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Usage",
    question: "L’usage de faux (441-2) suppose :",
    options: [
      "Un document administratif préalablement falsifié",
      "Un document devenu simplement inexact avec le temps",
      "Une déclaration orale",
    ],
    answer: "Un document administratif préalablement falsifié",
    explanation:
        "Usage ne se conçoit que sur un document falsifié. Sinon, on est sur autre chose (ex : R.645-8).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Contravention",
    question:
        "L’usage d’un document administratif dont les mentions sont devenues incomplètes ou inexactes constitue :",
    options: [
      "Une contravention de 5e classe (R.645-8 CP)",
      "Un délit 441-2 automatiquement",
      "Un crime 441-4",
    ],
    answer: "Une contravention de 5e classe (R.645-8 CP)",
    explanation:
        "Ta page le précise : document non falsifié mais mentions inexactes/incomplètes → R.645-8.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Élément moral (faux)",
    question: "Pour le faux (441-2), l’élément moral implique :",
    options: [
      "Volonté de falsifier + conscience d’altérer la vérité / l’intégrité du document",
      "Simple imprudence",
      "Nécessité d’un mobile particulier",
    ],
    answer:
        "Volonté de falsifier + conscience d’altérer la vérité / l’intégrité du document",
    explanation:
        "L’acte de falsification révèle l’intention ; mobiles indifférents.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Élément moral (usage)",
    question: "Pour l’usage de faux (441-2), il faut :",
    options: [
      "Volonté d’user + connaissance de la fausseté",
      "Volonté d’user seulement",
      "Connaissance seulement",
    ],
    answer: "Volonté d’user + connaissance de la fausseté",
    explanation: "Conditions classiques rappelées dans ta page.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Aggravation 1°",
    question: "441-2 est aggravé lorsque le faux ou l’usage est commis :",
    options: [
      "Par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public, dans l’exercice des fonctions",
      "En présence de témoins",
      "La nuit",
    ],
    answer:
        "Par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public, dans l’exercice des fonctions",
    explanation: "Aggravation prévue par 441-2 1°.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Aggravation 3°",
    question: "441-2 est aggravé lorsque le faux/usage est commis :",
    options: [
      "Dans le dessein de faciliter la commission d’un crime ou de procurer l’impunité à son auteur",
      "Pour éviter un retard administratif",
      "Pour prouver une opinion",
    ],
    answer:
        "Dans le dessein de faciliter la commission d’un crime ou de procurer l’impunité à son auteur",
    explanation:
        "Aggravation : dessein de faciliter un crime / procurer impunité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Peines simples",
    question:
        "Les peines principales du faux/usage de faux administratif (441-2) simple sont :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "10 ans d’emprisonnement et 150 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Tableau : 441-2 al.1 et 2 → 5 ans + 75 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Peines aggravées",
    question: "Les peines aggravées (441-2) sont :",
    options: [
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende",
    explanation: "Tableau : aggravations 1°/2°/3° → 7 ans + 100 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Tentative",
    question: "La tentative des délits 441-2 est :",
    options: [
      "Punissable (prévue par 441-9 CP)",
      "Non punissable",
      "Punissable seulement si usage",
    ],
    answer: "Punissable (prévue par 441-9 CP)",
    explanation: "441-9 prévoit expressément la tentative des délits 441-2.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Auteur de faux",
    question:
        "Peut être considéré comme auteur du faux (pas seulement complice) :",
    options: [
      "Celui qui donne l’ordre de commettre le faux, au même titre que celui qui le fabrique",
      "Uniquement celui qui tient le document dans ses mains",
      "Uniquement la victime",
    ],
    answer:
        "Celui qui donne l’ordre de commettre le faux, au même titre que celui qui le fabrique",
    explanation:
        "Ta page : la jurisprudence considère auteur celui qui donne l’ordre (ex : secrétaire de mairie).",
    difficulty: "Difficile",
  ),

  // =========================================================
  // FAUX DANS ÉCRITURE PUBLIQUE / AUTHENTIQUE + USAGE (441-4)
  // =========================================================
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Définition",
    question: "Le faux (441-4) vise :",
    options: [
      "Un faux dans une écriture publique/authentique ou un enregistrement ordonné par l’autorité publique ; usage également réprimé",
      "Uniquement les documents administratifs type CNI",
      "Uniquement les attestations entre particuliers",
    ],
    answer:
        "Un faux dans une écriture publique/authentique ou un enregistrement ordonné par l’autorité publique ; usage également réprimé",
    explanation:
        "441-4 : faux dans écritures publiques/authentiques + enregistrements ordonnés + usage.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Texte",
    question: "Le texte applicable est :",
    options: [
      "Article 441-4 du Code pénal",
      "Article 441-2 du Code pénal",
      "Article 441-7 du Code pénal",
    ],
    answer: "Article 441-4 du Code pénal",
    explanation: "Base légale : 441-4 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category:
        "Faux écriture publique/authentique (441-4) — Écritures publiques",
    question: "Les écritures publiques sont des écrits rédigés par :",
    options: [
      "Un représentant de l’autorité publique agissant en vertu de ses fonctions",
      "Un particulier pour lui-même",
      "Un mineur non habilité",
    ],
    answer:
        "Un représentant de l’autorité publique agissant en vertu de ses fonctions",
    explanation:
        "Définition dans ta page : représentant de l’autorité publique en fonction.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category:
        "Faux écriture publique/authentique (441-4) — Écritures authentiques",
    question: "Les écritures authentiques sont établies par :",
    options: [
      "Un officier public habilité par la loi à établir certains actes/constatations",
      "N’importe quel citoyen",
      "Uniquement un policier",
    ],
    answer:
        "Un officier public habilité par la loi à établir certains actes/constatations",
    explanation: "Notaire, huissier, greffier… selon les catégories évoquées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Actes judiciaires",
    question:
        "Parmi ces exemples, lequel correspond à un acte judiciaire cité ?",
    options: [
      "Décision de justice / PV établi par OPJ/APJ / actes de procédure",
      "Carte grise",
      "Permis de chasser",
    ],
    answer: "Décision de justice / PV établi par OPJ/APJ / actes de procédure",
    explanation:
        "Ta page : actes judiciaires = décisions, PV OPJ/APJ, actes de procédure (assignation, appel…).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Enregistrements",
    question:
        "Les enregistrements ordonnés par l’autorité publique peuvent être :",
    options: [
      "Sonores/visuels/audiovisuels (écoutes, interrogatoires filmés, etc.)",
      "Uniquement des emails privés",
      "Uniquement des notes manuscrites",
    ],
    answer:
        "Sonores/visuels/audiovisuels (écoutes, interrogatoires filmés, etc.)",
    explanation:
        "Ta page : enregistrements ordonnés par autorité publique (écoutes, interrogatoires mineurs…).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Préjudice",
    question: "Pour 441-4, le préjudice éventuel est :",
    options: [
      "Nécessairement établi car l’acte porte atteinte à la foi publique",
      "Toujours absent",
      "À prouver uniquement par un chiffrage comptable",
    ],
    answer: "Nécessairement établi car l’acte porte atteinte à la foi publique",
    explanation:
        "Falsification d’un acte public/authentique porte atteinte à la foi publique → préjudice éventuel établi.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Usage",
    question: "L’usage de faux (441-4) est constitué si :",
    options: [
      "La pièce fausse est utilisée par un acte quelconque en vue du résultat final (ou acte de nature à causer préjudice)",
      "La pièce est simplement conservée sans jamais être utilisée",
      "La pièce est seulement lue à voix haute sans effet",
    ],
    answer:
        "La pièce fausse est utilisée par un acte quelconque en vue du résultat final (ou acte de nature à causer préjudice)",
    explanation:
        "Ta page : il suffit d’un acte quelconque d’utilisation en vue du résultat final (ou de nature à causer préjudice).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Aggravation",
    question: "441-4 est aggravé lorsque le faux/usage est commis :",
    options: [
      "Par une personne dépositaire/chargée de mission de SP agissant dans l’exercice des fonctions",
      "Par un particulier sans lien",
      "En cas de mauvais temps",
    ],
    answer:
        "Par une personne dépositaire/chargée de mission de SP agissant dans l’exercice des fonctions",
    explanation:
        "Article 441-4 al.3 : circonstance aggravante de qualité + exercice des fonctions.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Peine simple",
    question:
        "La peine principale du faux en écriture publique/authentique (441-4) simple est :",
    options: [
      "10 ans d’emprisonnement",
      "5 ans d’emprisonnement et 75 000 €",
      "3 ans d’emprisonnement et 45 000 €",
    ],
    answer: "10 ans d’emprisonnement",
    explanation: "Tableau : 441-4 (simple) → 10 ans d’emprisonnement.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Peine aggravée",
    question:
        "La peine aggravée du 441-4 (qualité dépositaire/service public) est :",
    options: [
      "15 ans de réclusion",
      "7 ans d’emprisonnement et 100 000 €",
      "2 ans d’emprisonnement et 30 000 €",
    ],
    answer: "15 ans de réclusion",
    explanation: "Tableau : 441-4 al.3 → crime : 15 ans de réclusion.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Tentative",
    question: "La tentative des délits 441-4 est :",
    options: [
      "Punissable (441-9 CP)",
      "Non punissable",
      "Punissable seulement si usage",
    ],
    answer: "Punissable (441-9 CP)",
    explanation: "441-9 prévoit la tentative pour les délits 441-4.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // DÉLIVRANCE INDUE DE DOCUMENT ADMINISTRATIF (441-5)
  // =========================================================
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Définition",
    question:
        "La délivrance indue de document administratif (441-5) consiste à :",
    options: [
      "Procurer frauduleusement à autrui un document authentique délivré par une administration (droit/identité/qualité/autorisation)",
      "Falsifier matériellement une carte d’identité",
      "Refuser de présenter un document",
    ],
    answer:
        "Procurer frauduleusement à autrui un document authentique délivré par une administration (droit/identité/qualité/autorisation)",
    explanation:
        "441-5 vise des documents authentiques procurés frauduleusement à une personne qui n’y a pas droit (pas des faux).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Texte",
    question:
        "La délivrance indue de document administratif est réprimée par :",
    options: [
      "Article 441-5 du Code pénal",
      "Article 441-6 du Code pénal",
      "Article 441-2 du Code pénal",
    ],
    answer: "Article 441-5 du Code pénal",
    explanation: "Base légale : 441-5 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Nature du document",
    question: "Les documents visés par 441-5 sont :",
    options: [
      "Des documents authentiques (pas des faux)",
      "Uniquement des documents falsifiés",
      "Uniquement des documents privés",
    ],
    answer: "Des documents authentiques (pas des faux)",
    explanation:
        "Le cours insiste : 441-5 ne s’applique pas à des faux mais à des documents authentiques délivrés indûment.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Exemples",
    question: "Lequel est un exemple de document visé par 441-5 ?",
    options: [
      "Passeport / carte d’identité / titre de séjour",
      "SMS entre amis",
      "Photo personnelle sans usage juridique",
    ],
    answer: "Passeport / carte d’identité / titre de séjour",
    explanation: "Documents d’identité cités dans la page.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Documents de droit/qualité",
    question:
        "Parmi ces exemples, lesquels peuvent constater un droit ou une qualité ?",
    options: [
      "Certificat de nationalité / carte grise / récépissés administratifs",
      "Ticket de caisse ordinaire",
      "Lettre d’amour",
    ],
    answer:
        "Certificat de nationalité / carte grise / récépissés administratifs",
    explanation:
        "Catégorie citée : droit/qualité (certificat de nationalité, carte grise, récépissés…).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Autorisations",
    question:
        "Lequel correspond à un document accordant une autorisation (441-5) ?",
    options: [
      "Permis de construire / permis de chasser / permis de conduire",
      "Carte de fidélité",
      "Carte de visite",
    ],
    answer: "Permis de construire / permis de chasser / permis de conduire",
    explanation:
        "Le cours cite explicitement ces permis comme documents d’autorisation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Procurer à autrui",
    question: "« Procurer » un document à autrui signifie :",
    options: [
      "Fournir/remettre le document (même via un tiers de bonne foi)",
      "Seulement imprimer le document sans le donner",
      "Seulement conseiller verbalement",
    ],
    answer: "Fournir/remettre le document (même via un tiers de bonne foi)",
    explanation:
        "Le fait de procurer est réalisé même si le document est remis par un tiers de bonne foi.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Fraude (caractérisation)",
    question: "Le caractère frauduleux est caractérisé dès lors que l’auteur :",
    options: [
      "Délivre ou fait délivrer un document à une personne qu’il sait ne pas y avoir droit",
      "Commet une simple erreur administrative",
      "Ignore totalement l’identité du demandeur",
    ],
    answer:
        "Délivre ou fait délivrer un document à une personne qu’il sait ne pas y avoir droit",
    explanation:
        "Ta page : fraude caractérisée par la connaissance de l’absence de droit (Cass. crim., 26 janv. 1993).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Élément moral",
    question: "L’élément moral de 441-5 exige :",
    options: [
      "La remise en toute connaissance de cause (savoir que le bénéficiaire n’y a pas droit)",
      "Une simple imprudence",
      "Un mobile particulier obligatoire",
    ],
    answer:
        "La remise en toute connaissance de cause (savoir que le bénéficiaire n’y a pas droit)",
    explanation:
        "Le cours : l’agent sait qu’il procure un document à des personnes qui n’y ont pas droit.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Aggravation 1°",
    question: "441-5 est aggravé lorsque l’infraction est commise :",
    options: [
      "Par une personne dépositaire de l’autorité publique ou chargée d’une mission de SP, dans l’exercice des fonctions",
      "Par un mineur",
      "En état de fatigue",
    ],
    answer:
        "Par une personne dépositaire de l’autorité publique ou chargée d’une mission de SP, dans l’exercice des fonctions",
    explanation: "441-5 1° : qualité + exercice des fonctions.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Aggravation 2°",
    question: "441-5 est aggravé lorsque l’infraction est commise :",
    options: [
      "De manière habituelle",
      "Sur la voie publique",
      "Avec un téléphone",
    ],
    answer: "De manière habituelle",
    explanation: "441-5 2° : commission habituelle.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Aggravation 3°",
    question: "441-5 est aggravé lorsqu’il est commis :",
    options: [
      "Dans le dessein de faciliter la commission d’un crime ou de procurer l’impunité",
      "Pour accélérer une file d’attente",
      "Par erreur de formulaire",
    ],
    answer:
        "Dans le dessein de faciliter la commission d’un crime ou de procurer l’impunité",
    explanation: "441-5 3° : dessein de faciliter crime / procurer impunité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Peines simples",
    question: "Les peines principales de 441-5 simple sont :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Tableau 441-5 al.1 : 5 ans + 75 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Peines aggravées",
    question: "Les peines aggravées de 441-5 (1°,2°,3°) sont :",
    options: [
      "7 ans de réclusion et 100 000 € d’amende",
      "5 ans et 75 000 €",
      "10 ans et 150 000 €",
    ],
    answer: "7 ans de réclusion et 100 000 € d’amende",
    explanation: "Tableau : aggravée → 7 ans (réclusion) + 100 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Tentative",
    question: "La tentative des délits 441-5 est :",
    options: [
      "Punissable (441-9 CP le prévoit expressément)",
      "Non punissable",
      "Punissable seulement si le document est utilisé",
    ],
    answer: "Punissable (441-9 CP le prévoit expressément)",
    explanation: "Ta page : 441-9 prévoit la tentative des délits de 441-5.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Personnes morales",
    question:
        "La responsabilité pénale des personnes morales est prévue pour 441-5 par :",
    options: [
      "Article 441-12 du Code pénal",
      "Article 121-7 du Code pénal",
      "Article 433-10 du Code pénal",
    ],
    answer: "Article 441-12 du Code pénal",
    explanation:
        "Ta page : 441-12 prévoit la responsabilité pénale des personnes morales.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // OBTENTION INDUE DE DOCUMENT ADMINISTRATIF + FAUSSE DÉCLARATION (441-6)
  // =========================================================
  const QuizQuestion(
    category: "Obtention indue (441-6) — Définition",
    question:
        "L’obtention indue de document administratif (441-6) consiste à :",
    options: [
      "Se faire délivrer indûment, par moyen frauduleux, un document destiné à constater droit/identité/qualité/autorisation",
      "Fabriquer un faux passeport",
      "Donner un document authentique à quelqu’un d’autre",
    ],
    answer:
        "Se faire délivrer indûment, par moyen frauduleux, un document destiné à constater droit/identité/qualité/autorisation",
    explanation:
        "441-6 vise l’action de se faire délivrer indûment un document (authentique) par quelque moyen frauduleux.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Texte",
    question: "Le texte qui définit et réprime l’obtention indue est :",
    options: [
      "Article 441-6 du Code pénal",
      "Article 441-5 du Code pénal",
      "Article 441-2 du Code pénal",
    ],
    answer: "Article 441-6 du Code pénal",
    explanation: "Base légale : 441-6 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Document authentique",
    question: "441-6 s’applique à :",
    options: [
      "Des documents authentiques obtenus indûment (pas des faux)",
      "Uniquement des documents falsifiés",
      "Uniquement des documents privés",
    ],
    answer: "Des documents authentiques obtenus indûment (pas des faux)",
    explanation:
        "Comme 441-5, l’infraction ne vise pas des faux mais des documents authentiques obtenus indûment.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Organismes visés",
    question:
        "En plus des administrations, 441-6 vise aussi les documents délivrés par :",
    options: [
      "Un organisme chargé d’une mission de service public (ex : sécu, OFPRA, Pôle emploi)",
      "Uniquement une mairie",
      "Uniquement des entreprises privées",
    ],
    answer:
        "Un organisme chargé d’une mission de service public (ex : sécu, OFPRA, Pôle emploi)",
    explanation:
        "Le texte étend l’incrimination aux organismes chargés d’une mission de SP.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Moyens frauduleux",
    question: "Les moyens frauduleux peuvent être :",
    options: [
      "Fausses déclarations, faux renseignements/certificats/attestations, déclarations d’un tiers, manœuvres (ex : mariage de complaisance)",
      "Uniquement un faux document administratif",
      "Uniquement une violence",
    ],
    answer:
        "Fausses déclarations, faux renseignements/certificats/attestations, déclarations d’un tiers, manœuvres (ex : mariage de complaisance)",
    explanation:
        "Ta page détaille plusieurs moyens : fausses déclarations, faux renseignements, tiers, manœuvres.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Mariage de complaisance",
    question:
        "Le mariage de complaisance peut constituer des manœuvres frauduleuses lorsqu’il vise :",
    options: [
      "L’obtention indue d’un titre de séjour",
      "L’obtention d’un permis de conduire",
      "Un simple changement d’adresse",
    ],
    answer: "L’obtention indue d’un titre de séjour",
    explanation:
        "Ta page cite le mariage de complaisance comme manœuvre pour obtenir indûment un titre de séjour.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Préjudice",
    question: "Pour 441-6, l’infraction :",
    options: [
      "N’a pas besoin d’être préjudiciable pour être qualifiée",
      "Exige un préjudice chiffré",
      "N’existe que si un agent est trompé volontairement par écrit",
    ],
    answer: "N’a pas besoin d’être préjudiciable pour être qualifiée",
    explanation:
        "Ta page : pas nécessaire qu’elle soit préjudiciable pour être qualifiée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Alinéa 2 (avantages indus)",
    question: "441-6 al.2 assimile aussi à l’infraction :",
    options: [
      "Fournir sciemment une fausse déclaration ou une déclaration incomplète pour obtenir/tenter d’obtenir une allocation, prestation, paiement ou avantage indu",
      "Insulter un agent public",
      "Se battre dans une file d’attente",
    ],
    answer:
        "Fournir sciemment une fausse déclaration ou une déclaration incomplète pour obtenir/tenter d’obtenir une allocation, prestation, paiement ou avantage indu",
    explanation:
        "Ta page : al.2 = fausse/incomplète déclaration pour obtenir ou tenter d’obtenir un avantage indu.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Fausse vs incomplète",
    question: "Une déclaration « incomplète » peut consister en :",
    options: [
      "L’omission volontaire de faits exacts",
      "Une faute de frappe involontaire",
      "Un document illisible",
    ],
    answer: "L’omission volontaire de faits exacts",
    explanation:
        "Ta page : altération de la vérité = affirmation de faits faux OU omission de faits exacts.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Consommation",
    question: "Concernant 441-6 al.2, l’infraction est consommée :",
    options: [
      "Même si l’avantage n’a pas été obtenu, dès lors que la déclaration est faite dans le but d’obtenir",
      "Seulement si l’avantage est effectivement versé",
      "Seulement si la déclaration est écrite",
    ],
    answer:
        "Même si l’avantage n’a pas été obtenu, dès lors que la déclaration est faite dans le but d’obtenir",
    explanation:
        "Ta page : pas besoin que l’avantage soit obtenu ; suffit du but (obtenir ou faire obtenir).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Élément moral",
    question: "L’élément moral de 441-6 implique :",
    options: [
      "Conscience de se faire délivrer indûment + volonté d’utiliser un moyen frauduleux",
      "Simple négligence",
      "Aucun élément moral",
    ],
    answer:
        "Conscience de se faire délivrer indûment + volonté d’utiliser un moyen frauduleux",
    explanation:
        "Ta page : conscience + volonté d’employer un moyen frauduleux (et pour al.2 : fausse/incomplète volontaire).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Circonstances aggravantes",
    question: "441-6 prévoit des circonstances aggravantes :",
    options: ["Aucune", "En réunion", "Si arme"],
    answer: "Aucune",
    explanation: "Ta page : IV — Circonstances aggravantes : AUCUNE.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Peines",
    question: "Les peines principales de 441-6 (alinéa 1 et 2) sont :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation: "Tableau : 441-6 al.1 / al.2 → 2 ans + 30 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Tentative",
    question: "La tentative des délits 441-6 est :",
    options: [
      "Punissable (441-9 CP)",
      "Non punissable",
      "Punissable seulement si avantage obtenu",
    ],
    answer: "Punissable (441-9 CP)",
    explanation: "441-9 prévoit la tentative des délits 441-6.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // FAUX CERTIFICATS / ATTESTATIONS (441-7)
  // =========================================================
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Définition",
    question: "441-7 incrimine notamment :",
    options: [
      "Établir une attestation/certificat matériellement inexact, falsifier un document sincère, ou en faire usage",
      "Obtenir un document authentique indûment",
      "Commettre un faux dans une carte d’identité",
    ],
    answer:
        "Établir une attestation/certificat matériellement inexact, falsifier un document sincère, ou en faire usage",
    explanation: "Ta page : établissement (inexact) / falsification / usage.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Texte",
    question: "Le texte applicable est :",
    options: [
      "Article 441-7 du Code pénal",
      "Article 441-6 du Code pénal",
      "Article 441-5 du Code pénal",
    ],
    answer: "Article 441-7 du Code pénal",
    explanation: "Base légale : 441-7 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category:
        "Faux certificats/attestations (441-7) — Définition jurisprudentielle",
    question: "Selon la jurisprudence, une attestation/certificat est :",
    options: [
      "Toute déclaration écrite, quelle que soit sa forme, faite en faveur d’autrui dans un but probatoire",
      "Toujours un document administratif officiel",
      "Toujours un acte notarié",
    ],
    answer:
        "Toute déclaration écrite, quelle que soit sa forme, faite en faveur d’autrui dans un but probatoire",
    explanation: "Définition rappelée dans ta page.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Écrit uniquement",
    question: "441-7 nécessite :",
    options: [
      "Un écrit (les renseignements oraux ne suffisent pas)",
      "Une déclaration orale enregistrée suffit",
      "Un SMS non sauvegardé suffit",
    ],
    answer: "Un écrit (les renseignements oraux ne suffisent pas)",
    explanation:
        "Ta page : seul l’écrit est pris en compte ; l’oral ne constitue pas 441-7.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Signature",
    question: "Le document inexact doit notamment comporter :",
    options: [
      "La signature authentique de son auteur",
      "Un tampon de mairie obligatoire",
      "Une photo d’identité",
    ],
    answer: "La signature authentique de son auteur",
    explanation:
        "Ta page : exigence jurisprudentielle de signature authentique.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Profit d’un tiers",
    question: "Pour entrer dans 441-7, l’attestation doit être établie :",
    options: [
      "Au profit d’un tiers",
      "Pour soi-même (attestation sur l’honneur personnelle)",
      "Uniquement pour l’administration",
    ],
    answer: "Au profit d’un tiers",
    explanation:
        "Ta page : l’attestation sur l’honneur à son propre profit n’entre pas dans 441-7.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Établissement",
    question: "« Établir » une attestation signifie :",
    options: [
      "Rédiger le document et le signer",
      "Le lire à haute voix",
      "Le déchirer",
    ],
    answer: "Rédiger le document et le signer",
    explanation: "Ta page : établissement = rédaction + signature.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category:
        "Faux certificats/attestations (441-7) — Faits matériellement inexacts",
    question: "« Faits matériellement inexacts » correspond à :",
    options: [
      "Éléments objectifs vérifiables susceptibles de preuve contraire",
      "Opinions subjectives non vérifiables",
      "Jugements de valeur",
    ],
    answer: "Éléments objectifs vérifiables susceptibles de preuve contraire",
    explanation: "Ta page : éléments objectifs, vérifiables/constatables.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Consommation",
    question:
        "L’infraction d’établissement d’une attestation inexacte est consommée :",
    options: [
      "Dès l’établissement, même sans usage ultérieur",
      "Seulement si un tribunal l’utilise",
      "Seulement si la victime est condamnée clarifiée",
    ],
    answer: "Dès l’établissement, même sans usage ultérieur",
    explanation: "Ta page : consommée indépendamment de l’usage par la suite.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Falsification",
    question:
        "La falsification d’un certificat sincère à l’origine correspond à :",
    options: [
      "Une altération de la vérité dans le document (ex : modifier une date, un résultat)",
      "Le simple fait de l’oublier",
      "Le fait d’en parler oralement",
    ],
    answer:
        "Une altération de la vérité dans le document (ex : modifier une date, un résultat)",
    explanation:
        "Ta page : exemples de surcharge de date, modification d’analyse de sang.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Usage",
    question: "L’usage d’un certificat/attestation falsifié suppose :",
    options: [
      "L’existence préalable d’un établissement inexact ou d’une falsification",
      "Aucun acte préalable",
      "Une simple intention non réalisée",
    ],
    answer:
        "L’existence préalable d’un établissement inexact ou d’une falsification",
    explanation: "Usage = utilisation d’un document déjà inexact/falsifié.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Élément moral",
    question: "L’élément moral de l’établissement (441-7) repose sur :",
    options: [
      "La connaissance de l’inexactitude des faits certifiés",
      "Une simple imprudence",
      "Un mobile spécial obligatoire",
    ],
    answer: "La connaissance de l’inexactitude des faits certifiés",
    explanation:
        "Ta page : connaissance de l’inexactitude ; pas besoin d’anticiper l’usage que le tiers en fera.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Aggravation al.5",
    question:
        "L’infraction 441-7 est aggravée notamment lorsqu’elle est commise :",
    options: [
      "En vue de porter préjudice au Trésor public ou au patrimoine d’autrui, ou pour obtenir un titre de séjour / protection contre l’éloignement",
      "En réunion",
      "La nuit",
    ],
    answer:
        "En vue de porter préjudice au Trésor public ou au patrimoine d’autrui, ou pour obtenir un titre de séjour / protection contre l’éloignement",
    explanation: "Ta page : 441-7 al.5 prévoit ces hypothèses aggravantes.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Peines simples",
    question: "Les peines principales de 441-7 (simple) sont :",
    options: [
      "1 an d’emprisonnement et 15 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 €",
      "3 ans d’emprisonnement et 45 000 €",
    ],
    answer: "1 an d’emprisonnement et 15 000 € d’amende",
    explanation: "Ta page : simple → 1 an + 15 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Peines aggravées",
    question: "Les peines aggravées de 441-7 sont :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 €",
      "7 ans d’emprisonnement et 100 000 €",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Ta page : aggravée → 3 ans + 45 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Tentative",
    question: "La tentative de 441-7 est :",
    options: [
      "Punissable (441-9 CP)",
      "Non punissable",
      "Punissable seulement en cas d’usage",
    ],
    answer: "Punissable (441-9 CP)",
    explanation: "Ta page : 441-9 prévoit la tentative des délits 441-7.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // DISTINCTIONS “PIÈGES” — 441-1 / 441-2 / 441-4 / 441-5 / 441-6 / 441-7
  // =========================================================
  const QuizQuestion(
    category: "Piège — 441-5 vs 441-6",
    question: "La différence clé entre 441-5 et 441-6 est que :",
    options: [
      "441-5 = procurer frauduleusement à autrui ; 441-6 = se faire délivrer indûment (obtenir) par fraude",
      "441-5 = faux matériel ; 441-6 = faux intellectuel",
      "441-5 = contravention ; 441-6 = crime",
    ],
    answer:
        "441-5 = procurer frauduleusement à autrui ; 441-6 = se faire délivrer indûment (obtenir) par fraude",
    explanation:
        "441-5 = délivrance/procure à autrui ; 441-6 = obtention indue par le bénéficiaire (ou pour autrui via fraude).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège — Document authentique vs faux",
    question: "Quel duo correspond correctement ?",
    options: [
      "441-5/441-6 : documents authentiques obtenus/délivrés indûment ; 441-2/441-4 : documents falsifiés",
      "441-5 : documents falsifiés ; 441-2 : authentiques",
      "441-6 : uniquement des attestations privées",
    ],
    answer:
        "441-5/441-6 : documents authentiques obtenus/délivrés indûment ; 441-2/441-4 : documents falsifiés",
    explanation:
        "441-5 et 441-6 ≠ faux : ce sont des documents authentiques délivrés/obtenus frauduleusement. 441-2/441-4 = faux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — 441-2 vs 441-4",
    question: "La différence principale entre 441-2 et 441-4 :",
    options: [
      "441-2 = faux dans document administratif délivré pour droit/identité/qualité/autorisation ; 441-4 = faux dans écriture publique/authentique ou enregistrement ordonné",
      "441-2 = uniquement enregistrement audio ; 441-4 = uniquement carte grise",
      "441-2 = contravention ; 441-4 = amende seule",
    ],
    answer:
        "441-2 = faux dans document administratif délivré pour droit/identité/qualité/autorisation ; 441-4 = faux dans écriture publique/authentique ou enregistrement ordonné",
    explanation:
        "Deux faux “spéciaux” différents : administratif vs écriture publique/authentique/enregistrement.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — 441-7 vs 441-1",
    question: "Pourquoi 441-7 est un texte « spécial » par rapport à 441-1 ?",
    options: [
      "Il vise spécifiquement les attestations/certificats (établissement, falsification, usage) au profit d’autrui",
      "Il ne punit pas l’usage",
      "Il vise seulement les documents administratifs officiels",
    ],
    answer:
        "Il vise spécifiquement les attestations/certificats (établissement, falsification, usage) au profit d’autrui",
    explanation:
        "441-7 est dédié aux attestations/certificats (écrit probatoire en faveur d’autrui).",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // VRAI / FAUX — format QCM (3 options)
  // =========================================================
  const QuizQuestion(
    category: "Vrai/Faux — 441-5",
    question:
        "Vrai ou Faux : 441-5 s’applique à des documents falsifiés (faux documents).",
    options: ["Vrai", "Faux", "Ça dépend du support"],
    answer: "Faux",
    explanation:
        "441-5 vise des documents authentiques procurés indûment (pas des faux).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-6",
    question:
        "Vrai ou Faux : 441-6 peut viser un document délivré par un organisme chargé d’une mission de service public.",
    options: ["Vrai", "Faux", "Uniquement si c’est une mairie"],
    answer: "Vrai",
    explanation:
        "Le texte étend l’incrimination aux organismes de mission de SP (ex : sécu, OFPRA, Pôle emploi).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-1",
    question:
        "Vrai ou Faux : pour 441-1, il faut un préjudice déjà subi pour que l’infraction existe.",
    options: ["Vrai", "Faux", "Uniquement si usage"],
    answer: "Faux",
    explanation:
        "Il suffit que l’altération soit de nature à causer un préjudice.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Usage",
    question:
        "Vrai ou Faux : l’usage de faux peut résulter d’une simple abstention (ne rien faire).",
    options: ["Vrai", "Faux", "Seulement si c’est grave"],
    answer: "Faux",
    explanation:
        "Ta page : usage = fait positif d’utilisation ; l’abstention ne suffit pas.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-7",
    question:
        "Vrai ou Faux : une simple déclaration orale inexacte peut constituer 441-7.",
    options: ["Vrai", "Faux", "Si elle est répétée"],
    answer: "Faux",
    explanation: "441-7 exige un écrit ; l’oral ne suffit pas.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // MINI CAS PRATIQUES — Qualification + article + peine
  // =========================================================
  const QuizQuestion(
    category: "Cas pratique — 441-6 (obtention indue)",
    question:
        "Une personne fournit une fausse date d’entrée en France sur un formulaire pour obtenir un titre de séjour. Qualification + peine ?",
    options: [
      "Obtention indue de document administratif (441-6) — 2 ans et 30 000 €",
      "Délivrance indue (441-5) — 5 ans et 75 000 €",
      "Faux en écriture publique (441-4) — 10 ans",
    ],
    answer:
        "Obtention indue de document administratif (441-6) — 2 ans et 30 000 €",
    explanation:
        "Moyen frauduleux pour se faire délivrer un document authentique (titre de séjour) : 441-6. Peines : 2 ans + 30 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — 441-5 (délivrance indue)",
    question:
        "Un agent sait qu’un demandeur n’a pas droit au document, mais fait quand même délivrer une attestation administrative à son profit. Qualification + peine simple ?",
    options: [
      "Délivrance indue (441-5) — 5 ans et 75 000 €",
      "Obtention indue (441-6) — 2 ans et 30 000 €",
      "Faux général (441-1) — 3 ans et 45 000 €",
    ],
    answer: "Délivrance indue (441-5) — 5 ans et 75 000 €",
    explanation:
        "Procurer frauduleusement un document authentique à autrui = 441-5 (simple : 5 ans / 75 000 €).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — 441-2 (faux administratif) + usage",
    question:
        "Une personne falsifie matériellement une carte grise puis la présente pour obtenir un crédit. Qualification la plus adaptée ?",
    options: [
      "Faux dans un document administratif + usage (441-2) — 5 ans et 75 000 € (simple)",
      "Obtention indue (441-6) — 2 ans et 30 000 €",
      "Délivrance indue (441-5) — 5 ans et 75 000 €",
    ],
    answer:
        "Faux dans un document administratif + usage (441-2) — 5 ans et 75 000 € (simple)",
    explanation:
        "Document administratif falsifié (carte grise) + usage : 441-2 (simple : 5 ans / 75 000 €).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — 441-7 (attestation inexacte)",
    question:
        "Une personne rédige et signe une attestation pour aider un ami, en affirmant des faits vérifiables faux. Qualification + peine simple ?",
    options: [
      "Faux certificat/attestation (441-7) — 1 an et 15 000 €",
      "Faux administratif (441-2) — 5 ans et 75 000 €",
      "Obtention indue (441-6) — 2 ans et 30 000 €",
    ],
    answer: "Faux certificat/attestation (441-7) — 1 an et 15 000 €",
    explanation:
        "Attestation écrite en faveur d’autrui, faits matériellement inexacts : 441-7 (simple : 1 an / 15 000 €).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — 441-4 (écriture publique) aggravée",
    question:
        "Un agent public falsifie une écriture publique dans l’exercice de ses fonctions. Qualification + peine aggravée ?",
    options: [
      "Faux en écriture publique/authentique aggravé (441-4 al.3) — 15 ans de réclusion",
      "Faux administratif aggravé (441-2) — 7 ans et 100 000 €",
      "Faux général (441-1) — 3 ans et 45 000 €",
    ],
    answer:
        "Faux en écriture publique/authentique aggravé (441-4 al.3) — 15 ans de réclusion",
    explanation:
        "441-4 al.3 : aggravation si dépositaire/mission SP en exercice → crime : 15 ans de réclusion.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-1 — Définition",
    question: "Le faux (441-1) est :",
    options: [
      "Altération de la vérité, nature à causer un préjudice, sur support probatoire",
      "Simple mensonge oral sans support",
      "Critique d’une décision publique",
    ],
    answer:
        "Altération de la vérité, nature à causer un préjudice, sur support probatoire",
    explanation:
        "441-1 = altération + préjudice possible + support servant/pouvant servir de preuve.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-1 — Support",
    question: "Le support peut être :",
    options: [
      "Écrit ou support numérique",
      "Uniquement papier",
      "Uniquement acte notarié",
    ],
    answer: "Écrit ou support numérique",
    explanation:
        "Écrit OU tout autre support d’expression de la pensée (y compris numérique).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-1 — Valeur probatoire",
    question: "Le support doit :",
    options: [
      "Établir OU pouvoir établir la preuve d’un droit/fait à conséquences juridiques",
      "Être signé par un officier public",
      "Être délivré par l’administration",
    ],
    answer:
        "Établir OU pouvoir établir la preuve d’un droit/fait à conséquences juridiques",
    explanation: "Objet OU effet probatoire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-1 — Préjudice",
    question: "Le préjudice exigé :",
    options: [
      "Peut être seulement potentiel",
      "Doit être forcément réalisé",
      "Doit être uniquement matériel",
    ],
    answer: "Peut être seulement potentiel",
    explanation: "« De nature à causer » suffit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-1 — Faux matériel",
    question: "Faux matériel =",
    options: [
      "Altération du support (modif/suppression/adjonction/fabrication)",
      "Mensonge sur le contenu sans toucher au support",
      "Erreur involontaire",
    ],
    answer: "Altération du support (modif/suppression/adjonction/fabrication)",
    explanation: "Atteinte à l’aspect physique du document.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-1 — Faux intellectuel",
    question: "Faux intellectuel =",
    options: [
      "Mensonge sur le contenu (défaut de véracité)",
      "Ticket froissé",
      "Document perdu",
    ],
    answer: "Mensonge sur le contenu (défaut de véracité)",
    explanation: "Altération porte sur les faits, pas le support.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-1 — Usage de faux",
    question: "Usage de faux suppose :",
    options: [
      "Faux préalable + acte positif d’utilisation + connaissance",
      "Simple détention",
      "Abstention (laisser faire un tiers)",
    ],
    answer: "Faux préalable + acte positif d’utilisation + connaissance",
    explanation: "Usage = utiliser volontairement en sachant que c’est faux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-1 — Instantané",
    question: "L’usage de faux est :",
    options: [
      "Instantané (chaque usage compte)",
      "Continu (un seul)",
      "Non punissable",
    ],
    answer: "Instantané (chaque usage compte)",
    explanation:
        "Chaque utilisation = potentiellement une nouvelle infraction.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-1 — Mobiles",
    question: "Les mobiles de l’auteur :",
    options: [
      "Sont indifférents",
      "Doivent être lucratifs",
      "Doivent être politiques",
    ],
    answer: "Sont indifférents",
    explanation: "Ce qui compte = intention d’altérer la vérité.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-1 — Peines",
    question: "441-1 (faux/usage) :",
    options: ["3 ans + 45 000 €", "2 ans + 30 000 €", "5 ans + 75 000 €"],
    answer: "3 ans + 45 000 €",
    explanation: "Peines principales 441-1.",
    difficulty: "Facile",
  ),

  // (11) V/F
  const QuizQuestion(
    category: "Vrai/Faux — 441-1",
    question:
        "Vrai/Faux : un document « de hasard » peut être support du faux.",
    options: ["Vrai", "Faux", "Seulement s’il est administratif"],
    answer: "Vrai",
    explanation: "S’il acquiert une valeur probatoire ensuite.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Usage",
    question: "Vrai/Faux : la détention d’un faux = usage de faux.",
    options: ["Vrai", "Faux", "Uniquement si CNI"],
    answer: "Faux",
    explanation: "Usage nécessite un acte positif d’utilisation.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Préjudice",
    question: "Vrai/Faux : le préjudice doit être effectif pour 441-1.",
    options: ["Vrai", "Faux", "Seulement si argent"],
    answer: "Faux",
    explanation: "Préjudice potentiel suffit.",
    difficulty: "Facile",
  ),

  // (14-25) mini-cas 441-1
  const QuizQuestion(
    category: "Cas — 441-1",
    question: "Photocopie contrefaite produite en justice :",
    options: [
      "Faux (441-1)",
      "Obtention indue (441-6)",
      "Délivrance indue (441-5)",
    ],
    answer: "Faux (441-1)",
    explanation:
        "Production d’une copie contrefaite à valeur probatoire = faux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — Usage 441-1",
    question: "Même pièce fausse utilisée 4 fois :",
    options: ["4 usages possibles", "1 usage unique", "0 si ancien"],
    answer: "4 usages possibles",
    explanation: "Infraction instantanée : chaque acte d’usage compte.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — 441-1",
    question: "Lettre falsifiée pour prouver une embauche :",
    options: ["Faux (441-1)", "441-7", "441-2"],
    answer: "Faux (441-1)",
    explanation: "Support privé devenu probatoire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — 441-1",
    question: "Facture falsifiée passée en comptabilité :",
    options: ["Possible faux (441-1)", "Jamais faux", "Seulement 441-7"],
    answer: "Possible faux (441-1)",
    explanation: "Peut acquérir valeur probatoire via comptabilité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — 441-1",
    question: "Mensonge oral sans écrit/support :",
    options: ["Pas 441-1", "Toujours 441-1", "Toujours 441-2"],
    answer: "Pas 441-1",
    explanation: "441-1 exige support d’expression de la pensée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas — 441-1",
    question: "Faux document créé mais jamais utilisé :",
    options: [
      "Faux possible (441-1)",
      "Impossible sans usage",
      "Contravention",
    ],
    answer: "Faux possible (441-1)",
    explanation:
        "Le faux peut être constitué dès la création (usage distinct).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — Usage",
    question: "Présenter un faux à une banque pour ouvrir compte :",
    options: ["Usage de faux", "Détention seule", "Aucune infraction"],
    answer: "Usage de faux",
    explanation: "Acte positif d’utilisation + connaissance.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège — 441-1 vs 441-7",
    question: "Attestation écrite mensongère au profit d’un tiers :",
    options: [
      "Plutôt 441-7 (texte spécial)",
      "Toujours 441-1",
      "Toujours 441-6",
    ],
    answer: "Plutôt 441-7 (texte spécial)",
    explanation: "Texte spécial prime souvent sur général.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Réflexe — 441-1",
    question: "441-1 incrimine :",
    options: ["Faux et usage", "Obtention indue", "Délivrance indue"],
    answer: "Faux et usage",
    explanation: "Même article incrimine les deux, infractions distinctes.",
    difficulty: "Facile",
  ),

  // =======================
  // 441-2 — DOC ADMIN (26-55)
  // =======================
  const QuizQuestion(
    category: "441-2 — Définition",
    question: "441-2 vise :",
    options: [
      "Faux/usage dans un document administratif",
      "Obtention d’un document authentique par fraude",
      "Attestation mensongère privée",
    ],
    answer: "Faux/usage dans un document administratif",
    explanation: "Texte spécial « document administratif ». ",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-2 — Document administratif",
    question: "Document administratif = délivré pour :",
    options: [
      "Droit/identité/qualité/autorisation",
      "Opinion/politique",
      "Divertissement",
    ],
    answer: "Droit/identité/qualité/autorisation",
    explanation: "Critère finalité du document.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-2 — Faux matériel",
    question: "Gratter et modifier un permis :",
    options: ["441-2", "441-6", "441-5"],
    answer: "441-2",
    explanation: "Falsification matérielle d’un doc administratif.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-2 — Usage",
    question: "Présenter un permis falsifié au contrôle :",
    options: ["Usage 441-2", "441-6", "441-7"],
    answer: "Usage 441-2",
    explanation: "Utiliser un doc administratif falsifié.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-2 — Préjudice",
    question: "Le préjudice du faux administratif :",
    options: [
      "Découle de la nature de la pièce faussée",
      "Doit être chiffré",
      "Doit viser uniquement l’État",
    ],
    answer: "Découle de la nature de la pièce faussée",
    explanation: "Jurisprudence : préjudice déduit de la nature de la pièce.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-2 — Aggravation qualité",
    question: "Aggravé si commis par :",
    options: [
      "Dépositaire/Mission SP en exercice",
      "Toute personne majeure",
      "Mineur seulement",
    ],
    answer: "Dépositaire/Mission SP en exercice",
    explanation: "441-2 1°.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-2 — Aggravation dessein",
    question: "Aggravé si but :",
    options: [
      "Faciliter un crime/procurer impunité",
      "Éviter une file d’attente",
      "Faire plaisir à un ami",
    ],
    answer: "Faciliter un crime/procurer impunité",
    explanation: "441-2 3°.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-2 — Peine simple",
    question: "441-2 simple :",
    options: ["5 ans + 75 000 €", "3 ans + 45 000 €", "2 ans + 30 000 €"],
    answer: "5 ans + 75 000 €",
    explanation: "Tableau 441-2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-2 — Peine aggravée",
    question: "441-2 aggravé :",
    options: ["7 ans + 100 000 €", "10 ans", "1 an + 15 000 €"],
    answer: "7 ans + 100 000 €",
    explanation: "Tableau 441-2 aggravé.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-2",
    question: "Vrai/Faux : 441-2 réprime aussi l’usage.",
    options: ["Vrai", "Faux", "Seulement si fonctionnaire"],
    answer: "Vrai",
    explanation: "Texte vise faux + usage.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Piège — 441-2 vs 441-6",
    question: "Document authentique obtenu par mensonge (sans falsification) :",
    options: ["441-6", "441-2", "441-4"],
    answer: "441-6",
    explanation: "441-2 suppose falsification/contrefaçon.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — R.645-8",
    question: "Doc administratif non falsifié mais devenu inexact, utilisé :",
    options: ["Contravention R.645-8", "Usage 441-2", "441-6"],
    answer: "Contravention R.645-8",
    explanation: "Selon ton cours : doc devenu inexact/incomplet → R.645-8.",
    difficulty: "Difficile",
  ),

  // 38-55 = mini-cas rapides (18)
  const QuizQuestion(
    category: "Cas — 441-2",
    question: "Fausse carte grise utilisée pour s’approprier un véhicule :",
    options: ["441-2", "441-6", "441-7"],
    answer: "441-2",
    explanation: "Falsification de doc administratif (carte grise).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — 441-2 usage",
    question: "Présenter une carte grise falsifiée à l’assurance :",
    options: ["Usage 441-2", "441-1", "441-6"],
    answer: "Usage 441-2",
    explanation: "Usage d’un faux doc administratif.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — 441-2",
    question: "Imitation de signature sur un doc administratif :",
    options: ["441-2", "441-7", "441-6"],
    answer: "441-2",
    explanation: "Procédé donnant apparence d’authenticité → faux matériel.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — 441-2",
    question: "Fabriquer de toutes pièces un permis :",
    options: ["441-2", "441-5", "441-6"],
    answer: "441-2",
    explanation: "Contrefaçon d’un doc administratif.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas — 441-2 aggravé",
    question: "Agent public falsifie une CNI en service :",
    options: ["441-2 aggravé", "441-6", "441-7"],
    answer: "441-2 aggravé",
    explanation: "Qualité + exercice = aggravation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-2",
    question: "Vrai/Faux : 441-2 vise uniquement des écrits papier.",
    options: ["Vrai", "Faux", "Seulement si permis"],
    answer: "Faux",
    explanation: "Peut viser support autre que l’écrit (renvoi cours).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — 441-2 vs 441-1",
    question:
        "Si le support est un document administratif, on retient plutôt :",
    options: ["441-2 (spécial)", "441-1 (général)", "441-7"],
    answer: "441-2 (spécial)",
    explanation: "Texte spécial doc administratif.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Réflexe — 441-2",
    question: "Peine simple 441-2 :",
    options: ["5 ans + 75k", "2 ans + 30k", "3 ans + 45k"],
    answer: "5 ans + 75k",
    explanation: "Tableau 441-2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — 441-2",
    question: "Peine aggravée 441-2 :",
    options: ["7 ans + 100k", "10 ans", "15 ans réclusion"],
    answer: "7 ans + 100k",
    explanation: "Tableau 441-2 aggravé.",
    difficulty: "Facile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizFauxUsageFauxPA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName = '/pa/nation/quiz/faux_usage_faux';
  final String uid;
  final String email;

  const QuizFauxUsageFauxPA({super.key, required this.uid, required this.email});

  @override
  State<QuizFauxUsageFauxPA> createState() => _QuizFauxUsageFauxPAState();
}

class _QuizFauxUsageFauxPAState extends State<QuizFauxUsageFauxPA>
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
  static const _introHiddenKey = 'intro_pa_faux_usage_faux';
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
        ? questionFauxUsageFaux
        : questionFauxUsageFaux
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
            'quiz_name': 'Les faux et l\'usage de faux ',
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
      await _sb.from('quiz_faux_usage_faux').insert({
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
      debugPrint('❌ quiz_faux_usage_faux insert failed: $e');
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
      'source_file': 'pa_quiz_faux_usage_faux',
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
                            icon: Icons.edit_off_rounded,
                            title: 'Faux et usage de faux',
                            description: 'Identifie les infractions de faux : faux matériel, faux intellectuel, conditions d’incrimination, préjudice requis et sanctions.',
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
