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

final List<QuizQuestion> questionCultureGeneralGPXInstitutionEuropeen = [
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution de l’UE propose la plupart des textes législatifs ?",
    options: [
      "Commission européenne",
      "Parlement européen",
      "Conseil européen",
    ],
    answer: "Commission européenne",
    explanation:
        "La Commission a le monopole (principal) de l’initiative législative au niveau européen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution représente directement les citoyens de l’Union européenne ?",
    options: [
      "Parlement européen",
      "Commission européenne",
      "Conseil de l’Union européenne",
    ],
    answer: "Parlement européen",
    explanation: "Le Parlement européen est élu au suffrage universel direct.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe réunit les chefs d’État ou de gouvernement des États membres ?",
    options: [
      "Conseil européen",
      "Conseil de l’Union européenne",
      "Commission européenne",
    ],
    answer: "Conseil européen",
    explanation: "Il fixe les grandes orientations politiques de l’UE.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Le 'Conseil de l’Union européenne' est aussi appelé :",
    options: [
      "Conseil des ministres",
      "Conseil constitutionnel",
      "Conseil européen",
    ],
    answer: "Conseil des ministres",
    explanation: "Il réunit les ministres des États membres par thématique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution veille à l’interprétation du droit de l’Union européenne ?",
    options: [
      "Cour de justice de l’Union européenne (CJUE)",
      "Cour européenne des droits de l’homme (CEDH)",
      "Cour des comptes européenne",
    ],
    answer: "Cour de justice de l’Union européenne (CJUE)",
    explanation:
        "La CJUE assure l’application et l’interprétation uniforme du droit de l’UE.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution contrôle l’utilisation des fonds de l’Union européenne ?",
    options: [
      "Cour des comptes européenne",
      "Commission européenne",
      "Conseil européen",
    ],
    answer: "Cour des comptes européenne",
    explanation: "Elle vérifie la bonne gestion financière de l’UE.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel mécanisme permet aux citoyens de demander à la Commission de proposer un texte (si seuil atteint) ?",
    options: [
      "Initiative citoyenne européenne",
      "Référendum européen",
      "Motion de censure",
    ],
    answer: "Initiative citoyenne européenne",
    explanation: "L’ICE peut inviter la Commission à légiférer sur un sujet.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "L’euro est la monnaie commune gérée par :",
    options: [
      "Banque centrale européenne (BCE)",
      "Commission européenne",
      "Parlement européen",
    ],
    answer: "Banque centrale européenne (BCE)",
    explanation: "La BCE pilote la politique monétaire de la zone euro.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution peut adopter une motion de censure contre la Commission européenne ?",
    options: [
      "Parlement européen",
      "Conseil européen",
      "Cour des comptes européenne",
    ],
    answer: "Parlement européen",
    explanation:
        "Le Parlement peut contraindre la Commission à démissionner (procédure politique lourde).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — Construction européenne",
    question: "Quel traité de 1957 fonde la CEE ?",
    options: ["Traité de Rome", "Traité de Maastricht", "Traité de Lisbonne"],
    answer: "Traité de Rome",
    explanation: "Il crée la Communauté économique européenne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — Construction européenne",
    question: "Quel traité de 1992 crée l’Union européenne ?",
    options: [
      "Traité de Maastricht",
      "Traité de Paris",
      "Traité de Versailles",
    ],
    answer: "Traité de Maastricht",
    explanation: "Il marque un saut politique majeur vers l’UE.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — Construction européenne",
    question:
        "Quel traité de 2007 (en vigueur en 2009) réforme les institutions de l’UE ?",
    options: ["Traité de Lisbonne", "Traité d’Utrecht", "Traité de Trianon"],
    answer: "Traité de Lisbonne",
    explanation:
        "Il renforce notamment le rôle du Parlement et modernise le fonctionnement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Combien de versants compte la fonction publique en France ?",
    options: ["3", "2", "4"],
    answer: "3",
    explanation: "Fonction publique d’État, territoriale, et hospitalière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel versant regroupe les agents des mairies, départements et régions ?",
    options: [
      "Fonction publique territoriale",
      "Fonction publique d’État",
      "Fonction publique hospitalière",
    ],
    answer: "Fonction publique territoriale",
    explanation:
        "Elle concerne les collectivités territoriales et leurs établissements.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel versant regroupe notamment les agents des hôpitaux publics ?",
    options: [
      "Fonction publique hospitalière",
      "Fonction publique d’État",
      "Fonction publique territoriale",
    ],
    answer: "Fonction publique hospitalière",
    explanation:
        "Elle concerne les établissements publics de santé et médico-sociaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Le principe de neutralité des agents publics signifie notamment :",
    options: [
      "Ne pas manifester ses opinions dans l’exercice des fonctions",
      "Ne jamais voter",
      "Ne pas travailler en équipe",
    ],
    answer: "Ne pas manifester ses opinions dans l’exercice des fonctions",
    explanation:
        "Neutralité et impartialité sont attendues dans le service rendu au public.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose d’éviter les conflits entre intérêt général et intérêts privés ?",
    options: ["Probité", "Liberté d’opinion", "Principe de précaution"],
    answer: "Probité",
    explanation:
        "La probité implique intégrité, prévention des conflits d’intérêts, et respect de l’intérêt général.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est compétente en priorité sur les collèges ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation:
        "Les départements gèrent notamment les collèges (bâtiments, restauration, etc.).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité est compétente en priorité sur les lycées ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "Les régions gèrent notamment les lycées.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité est dirigée par un maire ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation: "Le maire est l’exécutif municipal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel représentant de l’État est chargé du contrôle de légalité dans un département ?",
    options: ["Préfet", "Maire", "Président du conseil régional"],
    answer: "Préfet",
    explanation:
        "Le préfet représente l’État et contrôle notamment la légalité des actes locaux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle structure regroupe plusieurs communes pour gérer des compétences en commun ?",
    options: ["Intercommunalité", "Sénat", "Conseil constitutionnel"],
    answer: "Intercommunalité",
    explanation:
        "EPCI : communautés de communes, d’agglomération, métropoles, etc.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle est la devise de la République française ?",
    options: [
      "Liberté, Égalité, Fraternité",
      "Travail, Famille, Patrie",
      "Unité, Autorité, Nation",
    ],
    answer: "Liberté, Égalité, Fraternité",
    explanation: "Devise officielle de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel est l’hymne national français ?",
    options: ["La Marseillaise", "Le Chant du Départ", "L’Internationale"],
    answer: "La Marseillaise",
    explanation: "Hymne national adopté sous la Révolution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle date est la fête nationale française ?",
    options: ["14 juillet", "11 novembre", "8 mai"],
    answer: "14 juillet",
    explanation:
        "Commémoration liée à la Révolution et à la Fête de la Fédération.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole figure sur de nombreuses mairies et dans les salles de mariage ?",
    options: ["Marianne", "Jeanne d’Arc", "Le coq gaulois uniquement"],
    answer: "Marianne",
    explanation: "Marianne incarne la République.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quels sont les trois couleurs du drapeau français (de gauche à droite) ?",
    options: ["Bleu, blanc, rouge", "Rouge, blanc, bleu", "Blanc, bleu, rouge"],
    answer: "Bleu, blanc, rouge",
    explanation: "Ordre officiel : bleu (côté hampe), blanc, rouge.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "La séparation des pouvoirs distingue principalement :",
    options: [
      "Exécutif, législatif, judiciaire",
      "Militaire, religieux, économique",
      "National, régional, communal",
    ],
    answer: "Exécutif, législatif, judiciaire",
    explanation: "Principe pour éviter la concentration du pouvoir.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "L’État de droit signifie notamment que :",
    options: [
      "L’État est soumis au droit",
      "Le droit est soumis à l’État",
      "Seule la police fait la loi",
    ],
    answer: "L’État est soumis au droit",
    explanation:
        "Les autorités doivent respecter la Constitution et les normes juridiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel organe contrôle la constitutionnalité des lois en France ?",
    options: ["Conseil constitutionnel", "Conseil d’État", "Cour des comptes"],
    answer: "Conseil constitutionnel",
    explanation: "Il vérifie la conformité à la Constitution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Le contrôle de constitutionnalité 'a posteriori' est rendu possible par :",
    options: ["QPC", "Décret-loi", "Ordonnance judiciaire"],
    answer: "QPC",
    explanation:
        "La Question Prioritaire de Constitutionnalité permet de contester une loi déjà en vigueur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Histoire mondiale — XXe siècle",
    question: "Quelle année marque le début de la Première Guerre mondiale ?",
    options: ["1914", "1918", "1939"],
    answer: "1914",
    explanation: "Le conflit débute à l’été 1914.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Histoire mondiale — XXe siècle",
    question: "Quelle année marque la fin de la Première Guerre mondiale ?",
    options: ["1918", "1914", "1945"],
    answer: "1918",
    explanation: "Armistice du 11 novembre 1918.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Histoire mondiale — XXe siècle",
    question:
        "Quelle année marque le début de la Seconde Guerre mondiale en Europe ?",
    options: ["1939", "1940", "1945"],
    answer: "1939",
    explanation: "Invasion de la Pologne et déclenchement du conflit européen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Histoire mondiale — XXe siècle",
    question: "Quelle année marque la fin de la Seconde Guerre mondiale ?",
    options: ["1945", "1944", "1939"],
    answer: "1945",
    explanation: "Capitulation allemande puis japonaise en 1945.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Histoire mondiale — Guerre froide",
    question:
        "Quel événement de 1962 est un moment de tension extrême entre USA et URSS ?",
    options: [
      "Crise des missiles de Cuba",
      "Blocus de Berlin",
      "Guerre du Vietnam",
    ],
    answer: "Crise des missiles de Cuba",
    explanation: "Confrontation nucléaire évitée de justesse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Histoire mondiale — Guerre froide",
    question: "Quel mur, symbole de la division Est-Ouest, tombe en 1989 ?",
    options: ["Mur de Berlin", "Mur d’Hadrien", "Mur des Lamentations"],
    answer: "Mur de Berlin",
    explanation: "Sa chute symbolise la fin de la division européenne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Histoire mondiale — Guerre froide",
    question:
        "Quel pays était à la tête du bloc de l’Ouest pendant la Guerre froide ?",
    options: ["États-Unis", "URSS", "Chine"],
    answer: "États-Unis",
    explanation: "Les États-Unis sont le principal leader du bloc occidental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Histoire mondiale — Guerre froide",
    question:
        "Quel pays était à la tête du bloc de l’Est pendant la Guerre froide ?",
    options: ["URSS", "Royaume-Uni", "France"],
    answer: "URSS",
    explanation: "L’Union soviétique dirige le bloc de l’Est.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Histoire mondiale — Institutions internationales",
    question:
        "Quelle organisation internationale est créée en 1945 pour maintenir la paix ?",
    options: ["ONU", "OTAN", "UE"],
    answer: "ONU",
    explanation: "L’Organisation des Nations unies est fondée en 1945.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Histoire mondiale — Institutions internationales",
    question:
        "Quelle alliance militaire est créée en 1949 dans le contexte de la Guerre froide ?",
    options: ["OTAN", "CEE", "SDN"],
    answer: "OTAN",
    explanation: "L’OTAN est une alliance de défense collective.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Construction européenne — Origines",
    question:
        "Quelle communauté de 1951 est un jalon majeur de la construction européenne ?",
    options: ["CECA", "CEE", "UE"],
    answer: "CECA",
    explanation: "Communauté européenne du charbon et de l’acier (1951).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Construction européenne — Origines",
    question:
        "Quelle figure française est souvent considérée comme un 'père de l’Europe' ?",
    options: ["Jean Monnet", "Napoléon III", "Charles Martel"],
    answer: "Jean Monnet",
    explanation: "Jean Monnet joue un rôle clé dans l’intégration européenne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Colonisation / Décolonisation",
    question:
        "Quelle conférence de 1884-1885 encadre le partage colonial de l’Afrique ?",
    options: [
      "Conférence de Berlin",
      "Conférence de Yalta",
      "Conférence de Potsdam",
    ],
    answer: "Conférence de Berlin",
    explanation:
        "Elle fixe des règles entre puissances européennes en Afrique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Colonisation / Décolonisation",
    question:
        "Quel pays obtient l’indépendance de la France en 1962 après une guerre longue ?",
    options: ["Algérie", "Belgique", "Italie"],
    answer: "Algérie",
    explanation: "Indépendance proclamée en 1962 après les accords d’Évian.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Colonisation / Décolonisation",
    question:
        "Quelle défaite de 1954 accélère la fin de la présence française en Indochine ?",
    options: ["Diên Biên Phu", "Trafalgar", "Stalingrad"],
    answer: "Diên Biên Phu",
    explanation: "Défaite déterminante menant aux accords de Genève.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Colonisation / Décolonisation",
    question:
        "Quel grand mouvement de 1955 réunit des pays d’Asie et d’Afrique sur la voie du non-alignement ?",
    options: [
      "Conférence de Bandung",
      "Conférence de Bretton Woods",
      "Conférence de Munich",
    ],
    answer: "Conférence de Bandung",
    explanation: "Bandung (1955) marque l’affirmation du Tiers-Monde.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Grands personnages internationaux",
    question:
        "Quel dirigeant britannique est associé à la résistance face à l’Allemagne nazie pendant la Seconde Guerre mondiale ?",
    options: [
      "Winston Churchill",
      "Neville Chamberlain",
      "Franklin D. Roosevelt",
    ],
    answer: "Winston Churchill",
    explanation: "Premier ministre britannique, symbole de résistance en 1940.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Grands personnages internationaux",
    question:
        "Quel dirigeant américain lance le 'New Deal' dans les années 1930 ?",
    options: ["Franklin D. Roosevelt", "John F. Kennedy", "Abraham Lincoln"],
    answer: "Franklin D. Roosevelt",
    explanation:
        "Programme de relance et de réformes pendant la Grande Dépression.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Grands personnages internationaux",
    question: "Qui est le dirigeant soviétique associé à la 'perestroïka' ?",
    options: ["Mikhaïl Gorbatchev", "Joseph Staline", "Léon Trotski"],
    answer: "Mikhaïl Gorbatchev",
    explanation: "Réformes en URSS dans les années 1980.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Grands personnages internationaux",
    question:
        "Quel leader indien incarne une stratégie de résistance non-violente ?",
    options: ["Gandhi", "Nehru", "Mandela"],
    answer: "Gandhi",
    explanation: "Figure de l’indépendance de l’Inde et de la non-violence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands personnages internationaux",
    question:
        "Quel leader sud-africain lutte contre l’apartheid et devient président en 1994 ?",
    options: ["Nelson Mandela", "Desmond Tutu", "F. W. de Klerk"],
    answer: "Nelson Mandela",
    explanation: "Symbole mondial de la lutte contre l’apartheid.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Histoire mondiale — XXe siècle",
    question:
        "Quel génocide est associé à l’extermination des Juifs d’Europe pendant la Seconde Guerre mondiale ?",
    options: ["Shoah", "Holodomor", "Goulag"],
    answer: "Shoah",
    explanation:
        "Extermination systématique par l’Allemagne nazie et ses collaborateurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Histoire mondiale — XXe siècle",
    question:
        "Quel procès international juge des responsables nazis après 1945 ?",
    options: [
      "Procès de Nuremberg",
      "Procès de Versailles",
      "Procès de Berlin",
    ],
    answer: "Procès de Nuremberg",
    explanation:
        "Procès majeurs pour crimes de guerre et crimes contre l’humanité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Histoire mondiale — XXe siècle",
    question:
        "Quel événement de 1929 déclenche une crise économique mondiale ?",
    options: ["Krach de Wall Street", "Crise de Suez", "Plan Marshall"],
    answer: "Krach de Wall Street",
    explanation:
        "Chute boursière aux États-Unis entraînant une dépression mondiale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — Droit",
    question: "La Cour européenne des droits de l’homme (CEDH) dépend de :",
    options: ["Conseil de l’Europe", "Union européenne", "ONU"],
    answer: "Conseil de l’Europe",
    explanation:
        "La CEDH n’est pas une institution de l’UE mais du Conseil de l’Europe.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE réunit les ministres des États membres selon le domaine traité ?",
    options: [
      "Conseil de l’Union européenne",
      "Conseil européen",
      "Commission européenne",
    ],
    answer: "Conseil de l’Union européenne",
    explanation:
        "Le Conseil de l’UE (Conseil des ministres) adopte des textes avec le Parlement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE fixe principalement les grandes orientations politiques générales ?",
    options: [
      "Conseil européen",
      "Parlement européen",
      "Cour des comptes européenne",
    ],
    answer: "Conseil européen",
    explanation:
        "Il réunit les chefs d’État ou de gouvernement et donne l’impulsion politique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE exécute le budget et met en œuvre les politiques de l’Union ?",
    options: [
      "Commission européenne",
      "Parlement européen",
      "Conseil européen",
    ],
    answer: "Commission européenne",
    explanation:
        "La Commission met en œuvre les décisions et veille à l’application du droit de l’UE.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Dans la procédure législative ordinaire, qui adopte les textes de l’UE le plus souvent ?",
    options: [
      "Parlement européen et Conseil de l’UE",
      "Commission et Conseil européen",
      "CJUE et Commission",
    ],
    answer: "Parlement européen et Conseil de l’UE",
    explanation:
        "Ils codécident sur la plupart des textes proposés par la Commission.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution de l’UE peut sanctionner un État membre en cas de manquement au droit de l’UE (via arrêt) ?",
    options: ["CJUE", "Parlement européen", "Conseil européen"],
    answer: "CJUE",
    explanation:
        "La Cour de justice de l’UE statue sur les manquements et l’interprétation du droit.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE est chargé de la politique monétaire de la zone euro ?",
    options: ["BCE", "Commission européenne", "Cour des comptes européenne"],
    answer: "BCE",
    explanation:
        "La Banque centrale européenne conduit la politique monétaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution représente les États membres au niveau des chefs d’État ou de gouvernement ?",
    options: ["Conseil européen", "Conseil de l’UE", "Parlement européen"],
    answer: "Conseil européen",
    explanation:
        "Il réunit les dirigeants nationaux et fixe la direction politique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution de l’UE est composée d’un commissaire par État membre (dans la pratique) ?",
    options: [
      "Commission européenne",
      "Parlement européen",
      "Conseil de l’Union européenne",
    ],
    answer: "Commission européenne",
    explanation:
        "Chaque État membre propose un commissaire, validé dans le cadre européen.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Les députés européens sont élus :",
    options: [
      "Au suffrage universel direct",
      "Par nomination gouvernementale",
      "Par tirage au sort",
    ],
    answer: "Au suffrage universel direct",
    explanation:
        "Les citoyens élisent leurs représentants au Parlement européen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Le siège du Parlement européen est officiellement à :",
    options: ["Strasbourg", "Bruxelles", "Luxembourg"],
    answer: "Strasbourg",
    explanation: "Les sessions plénières officielles se tiennent à Strasbourg.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel versant de la fonction publique concerne les ministères et les services de l’État ?",
    options: [
      "Fonction publique d’État",
      "Fonction publique territoriale",
      "Fonction publique hospitalière",
    ],
    answer: "Fonction publique d’État",
    explanation:
        "Elle regroupe les agents travaillant pour les administrations de l’État.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel versant regroupe les agents des communes, départements, régions et EPCI ?",
    options: [
      "Fonction publique territoriale",
      "Fonction publique d’État",
      "Fonction publique hospitalière",
    ],
    answer: "Fonction publique territoriale",
    explanation:
        "Elle concerne les collectivités territoriales et leurs établissements.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel versant regroupe les agents des hôpitaux publics et établissements médico-sociaux publics ?",
    options: [
      "Fonction publique hospitalière",
      "Fonction publique territoriale",
      "Fonction publique d’État",
    ],
    answer: "Fonction publique hospitalière",
    explanation:
        "Elle couvre une partie des personnels du secteur public de santé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Le principe d’égalité dans le service public implique :",
    options: [
      "Un traitement identique des usagers dans une situation comparable",
      "Un service réservé à certains",
      "Un accès payant obligatoire",
    ],
    answer: "Un traitement identique des usagers dans une situation comparable",
    explanation:
        "Le service public doit être rendu sans discrimination injustifiée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Le principe de continuité du service public signifie :",
    options: [
      "Le service doit fonctionner de manière régulière",
      "Le service s’arrête sans préavis",
      "Le service dépend du bénévolat",
    ],
    answer: "Le service doit fonctionner de manière régulière",
    explanation: "La continuité est un principe classique du service public.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "L’obligation de neutralité d’un agent public impose notamment :",
    options: [
      "Impartialité dans l’exercice des fonctions",
      "Promotion d’un parti en service",
      "Refus de toute hiérarchie",
    ],
    answer: "Impartialité dans l’exercice des fonctions",
    explanation: "L’agent doit rester neutre et ne pas influencer l’usager.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Le secret professionnel impose :",
    options: [
      "De ne pas divulguer des informations confidentielles",
      "De publier toutes les informations",
      "De partager les dossiers entre amis",
    ],
    answer: "De ne pas divulguer des informations confidentielles",
    explanation:
        "Certaines informations sont protégées par la loi et la mission.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "La discrétion professionnelle concerne :",
    options: [
      "Les informations connues dans l’exercice des fonctions",
      "Uniquement la vie privée",
      "Les informations déjà publiques",
    ],
    answer: "Les informations connues dans l’exercice des fonctions",
    explanation: "Obligation de réserve sur certaines informations internes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "L’obligation d’obéissance hiérarchique signifie :",
    options: [
      "Exécuter les instructions légales du supérieur",
      "Obéir à tout même illégal",
      "Ne jamais contester une décision",
    ],
    answer: "Exécuter les instructions légales du supérieur",
    explanation:
        "L’agent doit obéir sauf ordre manifestement illégal et de nature à compromettre gravement un intérêt public.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité territoriale est le niveau de proximité administré par un maire ?",
    options: ["Commune", "Région", "État"],
    answer: "Commune",
    explanation:
        "La commune est la collectivité de base, dirigée par un maire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est dirigée par un président du conseil départemental ?",
    options: ["Département", "Commune", "Région"],
    answer: "Département",
    explanation: "Le département est administré par un conseil départemental.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est dirigée par un président du conseil régional ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "La région est administrée par un conseil régional.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "La décentralisation consiste principalement à :",
    options: [
      "Transférer des compétences de l’État vers des collectivités",
      "Supprimer les collectivités",
      "Centraliser toutes les décisions à Paris",
    ],
    answer: "Transférer des compétences de l’État vers des collectivités",
    explanation:
        "Elle vise à donner plus d’autonomie locale (dans le cadre de la loi).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel représentant de l’État exerce le contrôle de légalité dans le département ?",
    options: ["Préfet", "Président du conseil régional", "Maire"],
    answer: "Préfet",
    explanation: "Le préfet contrôle la légalité des actes des collectivités.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel niveau de collectivité gère le plus souvent la voirie communale et l’état civil ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation:
        "La commune gère des compétences de proximité (état civil, urbanisme, etc.).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel type de structure permet à plusieurs communes d’exercer des compétences ensemble ?",
    options: ["EPCI (intercommunalité)", "Sénat", "Conseil constitutionnel"],
    answer: "EPCI (intercommunalité)",
    explanation:
        "Établissements publics de coopération intercommunale (communautés, métropoles...).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel budget local est voté par l’assemblée délibérante d’une collectivité ?",
    options: ["Budget primitif", "Budget national", "Budget présidentiel"],
    answer: "Budget primitif",
    explanation: "Il prévoit les recettes et dépenses de l’année.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle est la devise officielle de la République française ?",
    options: [
      "Liberté, Égalité, Fraternité",
      "Travail, Famille, Patrie",
      "Unité, Autorité, Solidarité",
    ],
    answer: "Liberté, Égalité, Fraternité",
    explanation:
        "Devise héritée de la Révolution et consacrée par la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel est l’hymne national de la France ?",
    options: ["La Marseillaise", "Le Chant du Départ", "La Parisienne"],
    answer: "La Marseillaise",
    explanation: "Chant révolutionnaire devenu hymne national.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle date correspond à la fête nationale française ?",
    options: ["14 juillet", "8 mai", "11 novembre"],
    answer: "14 juillet",
    explanation:
        "Célébration associée à la Révolution et à la Fête de la Fédération.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel personnage symbolique représente la République française ?",
    options: ["Marianne", "Charlotte Corday", "Aliénor d’Aquitaine"],
    answer: "Marianne",
    explanation: "Marianne incarne la République (bustes, mairies).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole animal est souvent associé à la France (même s’il n’est pas officiel) ?",
    options: ["Coq gaulois", "Aigle impérial", "Lion"],
    answer: "Coq gaulois",
    explanation: "Symbole culturel et sportif fréquemment utilisé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "De quel côté du drapeau se trouve la bande bleue ?",
    options: ["Côté hampe", "Côté flottant", "Au centre"],
    answer: "Côté hampe",
    explanation: "L’ordre est bleu (hampe), blanc, rouge.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe vise à éviter la concentration du pouvoir entre les mêmes mains ?",
    options: [
      "Séparation des pouvoirs",
      "Primauté du budget",
      "Droit de grâce",
    ],
    answer: "Séparation des pouvoirs",
    explanation: "Distingue notamment exécutif, législatif et judiciaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "L’État de droit signifie principalement que :",
    options: [
      "Les autorités publiques sont soumises au droit",
      "Le droit est facultatif",
      "La police décide seule des règles",
    ],
    answer: "Les autorités publiques sont soumises au droit",
    explanation:
        "La puissance publique doit respecter la hiérarchie des normes et les libertés.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel organe peut censurer une loi non conforme à la Constitution ?",
    options: [
      "Conseil constitutionnel",
      "Cour des comptes",
      "Conseil économique, social et environnemental",
    ],
    answer: "Conseil constitutionnel",
    explanation: "Il contrôle la constitutionnalité des lois.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel mécanisme permet à un justiciable de contester une loi déjà en vigueur au regard de la Constitution ?",
    options: ["QPC", "Référendum", "Ordonnance"],
    answer: "QPC",
    explanation:
        "La Question Prioritaire de Constitutionnalité est un contrôle a posteriori.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe impose que les règles de droit soient connues, stables et applicables ?",
    options: [
      "Sécurité juridique",
      "Opportunité politique",
      "Immunité générale",
    ],
    answer: "Sécurité juridique",
    explanation:
        "Principe lié à la prévisibilité du droit et à la confiance des citoyens.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Le pouvoir législatif en France est exercé principalement par :",
    options: ["Le Parlement", "Le Conseil constitutionnel", "Le Gouvernement"],
    answer: "Le Parlement",
    explanation: "Le Parlement (Assemblée nationale + Sénat) vote la loi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Le pouvoir exécutif est exercé principalement par :",
    options: [
      "Le Président et le Gouvernement",
      "Le Parlement",
      "Les tribunaux",
    ],
    answer: "Le Président et le Gouvernement",
    explanation:
        "Ils conduisent la politique de la nation et exécutent les lois.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe interdit de punir un acte qui n’était pas interdit au moment où il a été commis ?",
    options: [
      "Légalité des délits et des peines",
      "Séparation des pouvoirs",
      "Indivisibilité de la République",
    ],
    answer: "Légalité des délits et des peines",
    explanation:
        "Principe fondamental : pas d’infraction ni de peine sans texte.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE peut être saisi pour interpréter un texte européen à la demande d’une juridiction nationale ?",
    options: ["CJUE", "BCE", "Conseil européen"],
    answer: "CJUE",
    explanation: "Renvoi préjudiciel : la CJUE interprète le droit de l’UE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "La Commission européenne est dirigée par :",
    options: ["Un/une président(e)", "Un roi", "Un gouverneur militaire"],
    answer: "Un/une président(e)",
    explanation:
        "La Commission est conduite par un président ou une présidente.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Le budget de l’UE finance notamment :",
    options: [
      "Des politiques communes",
      "Uniquement les armées nationales",
      "Uniquement les communes françaises",
    ],
    answer: "Des politiques communes",
    explanation: "Ex : cohésion, agriculture, recherche, etc.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe garantit que les citoyens européens peuvent voter aux élections municipales dans leur pays de résidence (UE) ?",
    options: ["Citoyenneté européenne", "Primauté du droit", "Subsidiarité"],
    answer: "Citoyenneté européenne",
    explanation: "Elle donne certains droits politiques dans l’UE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe veut que l’UE n’agisse que si l’action est plus efficace au niveau européen ?",
    options: ["Subsidiarité", "Neutralité", "Continuité"],
    answer: "Subsidiarité",
    explanation: "L’UE intervient si le niveau national est moins efficace.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe veut que l’action de l’UE n’aille pas au-delà de ce qui est nécessaire ?",
    options: ["Proportionnalité", "Primauté", "Mutabilité"],
    answer: "Proportionnalité",
    explanation: "Les moyens doivent être adaptés au but recherché.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe fixe les grandes orientations de la politique monétaire de la zone euro ?",
    options: ["BCE", "Parlement européen", "Cour des comptes européenne"],
    answer: "BCE",
    explanation: "La BCE est l’institution monétaire de la zone euro.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "La fonction publique d’État comprend notamment :",
    options: [
      "Les agents des ministères",
      "Uniquement les mairies",
      "Uniquement les hôpitaux",
    ],
    answer: "Les agents des ministères",
    explanation: "Ex : Éducation nationale, Finances, Intérieur, etc.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "La fonction publique territoriale comprend notamment :",
    options: ["Les agents des collectivités", "Les juges", "Les députés"],
    answer: "Les agents des collectivités",
    explanation:
        "Agents communaux, départementaux, régionaux, intercommunalité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "La fonction publique hospitalière regroupe notamment :",
    options: [
      "Les agents des hôpitaux publics",
      "Les agents des entreprises privées",
      "Les agents des ambassades",
    ],
    answer: "Les agents des hôpitaux publics",
    explanation: "Établissements publics de santé et médico-sociaux publics.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Le devoir de loyauté implique principalement :",
    options: [
      "Agir dans l’intérêt du service et respecter la hiérarchie",
      "Désobéir systématiquement",
      "Favoriser un usager",
    ],
    answer: "Agir dans l’intérêt du service et respecter la hiérarchie",
    explanation:
        "L’agent sert l’intérêt général et le bon fonctionnement du service.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Le principe d’impartialité impose :",
    options: [
      "Décisions sans favoritisme",
      "Aider uniquement ses proches",
      "Traiter différemment selon l’opinion",
    ],
    answer: "Décisions sans favoritisme",
    explanation: "Impartialité dans l’accueil et le traitement des demandes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "L’agent public doit éviter le conflit d’intérêts : cela relève notamment de :",
    options: ["La déontologie", "La géographie", "Le folklore"],
    answer: "La déontologie",
    explanation: "Ensemble de règles éthiques et obligations professionnelles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel principe signifie que les collectivités s’administrent librement dans le cadre de la loi ?",
    options: ["Libre administration", "Primauté de l’UE", "Ordre public"],
    answer: "Libre administration",
    explanation: "Principe constitutionnel encadré par la loi.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "La région intervient souvent en priorité sur :",
    options: ["Développement économique", "État civil", "Police nationale"],
    answer: "Développement économique",
    explanation:
        "La région pilote des politiques de développement et d’aménagement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Le département intervient souvent en priorité sur :",
    options: ["Action sociale", "Politique étrangère", "Défense nationale"],
    answer: "Action sociale",
    explanation: "Compétences sociales (aides, solidarité, etc.).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "La commune intervient souvent en priorité sur :",
    options: ["État civil", "Monnaie", "Traités internationaux"],
    answer: "État civil",
    explanation: "Naissances, mariages, décès : compétence communale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel document local fixe les grandes orientations de l’urbanisme à l’échelle communale/intercommunale ?",
    options: ["PLU", "Code civil", "Traité de Rome"],
    answer: "PLU",
    explanation:
        "Plan local d’urbanisme : organise l’aménagement du territoire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Le drapeau tricolore est :",
    options: ["Bleu, blanc, rouge", "Vert, blanc, rouge", "Noir, jaune, rouge"],
    answer: "Bleu, blanc, rouge",
    explanation: "Symbole national officiel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel texte est souvent affiché dans les écoles et lieux publics comme symbole républicain ?",
    options: [
      "Déclaration des droits de l’homme et du citoyen",
      "Traité de Versailles",
      "Code Hays",
    ],
    answer: "Déclaration des droits de l’homme et du citoyen",
    explanation: "Texte fondateur de 1789.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole est gravé sur de nombreuses pièces et bâtiments publics en France ?",
    options: ["RF", "UE", "ONU"],
    answer: "RF",
    explanation: "RF signifie République française.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Le Parlement français est composé de :",
    options: [
      "Assemblée nationale et Sénat",
      "Gouvernement et Conseil d’État",
      "Cour des comptes et CJUE",
    ],
    answer: "Assemblée nationale et Sénat",
    explanation: "Deux chambres : bicamérisme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Le gouvernement est responsable politiquement devant :",
    options: ["L’Assemblée nationale", "Le Sénat uniquement", "La CJUE"],
    answer: "L’Assemblée nationale",
    explanation:
        "L’Assemblée peut renverser le gouvernement (motion de censure).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe affirme que nul n’est au-dessus de la loi ?",
    options: [
      "Égalité devant la loi",
      "Hérédité du pouvoir",
      "Censure préalable",
    ],
    answer: "Égalité devant la loi",
    explanation: "Principe central de l’État de droit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Le principe de légalité signifie que l’administration :",
    options: [
      "Doit respecter les normes juridiques",
      "Peut agir sans règles",
      "Décide selon l’opinion du moment",
    ],
    answer: "Doit respecter les normes juridiques",
    explanation:
        "Toute décision doit avoir une base légale et respecter le droit.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe protège contre les décisions arbitraires en imposant des règles et des recours ?",
    options: [
      "Garantie des droits",
      "Culte de la personnalité",
      "Secret du vote obligatoire",
    ],
    answer: "Garantie des droits",
    explanation:
        "L’État de droit implique des droits garantis et des voies de recours.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel texte fixe les objectifs et règles fondamentales de l’Union européenne ?",
    options: [
      "Les traités européens",
      "Les décrets nationaux",
      "Les arrêtés municipaux",
    ],
    answer: "Les traités européens",
    explanation:
        "Les traités (ex : Rome, Maastricht, Lisbonne) fondent l’UE et ses compétences.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE vote des résolutions et contrôle politiquement la Commission ?",
    options: [
      "Parlement européen",
      "Conseil européen",
      "Cour des comptes européenne",
    ],
    answer: "Parlement européen",
    explanation:
        "Le Parlement exerce un contrôle démocratique sur la Commission.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe représente les États membres au niveau ministériel dans la loi européenne ?",
    options: [
      "Conseil de l’Union européenne",
      "Conseil européen",
      "Commission européenne",
    ],
    answer: "Conseil de l’Union européenne",
    explanation:
        "Le Conseil de l’UE réunit les ministres nationaux et co-légifère avec le Parlement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe n’a pas pour rôle principal de voter des lois européennes ?",
    options: [
      "Conseil européen",
      "Parlement européen",
      "Conseil de l’Union européenne",
    ],
    answer: "Conseil européen",
    explanation:
        "Le Conseil européen fixe surtout l’impulsion politique, pas la loi au quotidien.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel type de texte européen est directement applicable dans tous les États membres ?",
    options: ["Règlement", "Directive", "Recommandation"],
    answer: "Règlement",
    explanation:
        "Le règlement s’applique directement sans transposition nationale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel type de texte européen fixe un objectif à atteindre en laissant les moyens aux États ?",
    options: ["Directive", "Règlement", "Décision locale"],
    answer: "Directive",
    explanation:
        "La directive nécessite une transposition dans le droit national.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel type d’acte européen est obligatoire pour ses destinataires (État, entreprise, personne) ?",
    options: ["Décision", "Recommandation", "Avis"],
    answer: "Décision",
    explanation: "La décision est contraignante pour ceux qu’elle vise.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe peut adopter des avis consultatifs sans valeur obligatoire ?",
    options: ["Comité économique et social européen", "BCE", "CJUE"],
    answer: "Comité économique et social européen",
    explanation:
        "Le CESE européen rend des avis consultatifs (sociaux/économiques).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe représente les collectivités et régions dans l’UE via des avis ?",
    options: ["Comité des régions", "Conseil européen", "Parlement européen"],
    answer: "Comité des régions",
    explanation:
        "Le Comité des régions conseille sur les politiques ayant un impact territorial.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe vise à garantir que les politiques européennes soient prises au plus près des citoyens ?",
    options: ["Subsidiarité", "Confidentialité", "Centralisation"],
    answer: "Subsidiarité",
    explanation:
        "L’UE intervient seulement si l’échelon européen est plus pertinent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe impose que l’action de l’UE soit limitée au nécessaire ?",
    options: ["Proportionnalité", "Primauté", "Continuité"],
    answer: "Proportionnalité",
    explanation:
        "L’UE ne doit pas aller au-delà de ce qui est nécessaire pour atteindre l’objectif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel est le rôle principal de la Cour des comptes européenne ?",
    options: [
      "Contrôler l’utilisation des fonds",
      "Voter les lois",
      "Fixer les taux d’intérêt",
    ],
    answer: "Contrôler l’utilisation des fonds",
    explanation: "Elle vérifie la régularité et la bonne gestion financière.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution défend l’intérêt général européen et peut poursuivre un État en manquement ?",
    options: [
      "Commission européenne",
      "Conseil européen",
      "Parlement européen",
    ],
    answer: "Commission européenne",
    explanation:
        "Elle engage la procédure d’infraction si un État ne respecte pas le droit de l’UE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel mécanisme permet à une juridiction nationale de demander l’interprétation du droit de l’UE ?",
    options: ["Renvoi préjudiciel", "Motion de censure", "Dissolution"],
    answer: "Renvoi préjudiciel",
    explanation: "La CJUE répond pour assurer une interprétation uniforme.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel est le nom de la monnaie commune de la zone euro ?",
    options: ["Euro", "Franc", "ECU"],
    answer: "Euro",
    explanation:
        "L’euro est la monnaie partagée par les États de la zone euro.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel versant regroupe les agents des ministères et services déconcentrés de l’État ?",
    options: [
      "Fonction publique d’État",
      "Fonction publique territoriale",
      "Fonction publique hospitalière",
    ],
    answer: "Fonction publique d’État",
    explanation: "Il s’agit du versant de l’administration d’État.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel versant regroupe les agents des communes, départements, régions et intercommunalités ?",
    options: [
      "Fonction publique territoriale",
      "Fonction publique d’État",
      "Fonction publique hospitalière",
    ],
    answer: "Fonction publique territoriale",
    explanation: "Les agents des collectivités relèvent de ce versant.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel versant regroupe les agents des établissements publics de santé ?",
    options: [
      "Fonction publique hospitalière",
      "Fonction publique territoriale",
      "Fonction publique d’État",
    ],
    answer: "Fonction publique hospitalière",
    explanation:
        "Elle concerne les hôpitaux publics et établissements médico-sociaux publics.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose aux agents publics de traiter les usagers sans discrimination ?",
    options: ["Égalité", "Cumul", "Centralisation"],
    answer: "Égalité",
    explanation:
        "Le service public s’applique à tous dans des conditions similaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose que le service public s’adapte aux besoins (numérique, horaires, organisation) ?",
    options: ["Mutabilité", "Secret professionnel", "Immunité"],
    answer: "Mutabilité",
    explanation:
        "Le service public doit évoluer avec les besoins et la société.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose un fonctionnement régulier du service public dans le temps ?",
    options: ["Continuité", "Laïcité", "Dissolution"],
    answer: "Continuité",
    explanation:
        "Le service public doit fonctionner de manière stable et continue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir interdit de divulguer des informations sensibles sur les usagers ou les dossiers ?",
    options: [
      "Secret professionnel",
      "Liberté d’expression",
      "Droit d’association",
    ],
    answer: "Secret professionnel",
    explanation:
        "Obligation liée à la confidentialité et à la protection des données.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir demande de rester mesuré dans l’expression publique quand on est agent ?",
    options: [
      "Obligation de réserve",
      "Obligation d’initiative",
      "Obligation de publicité",
    ],
    answer: "Obligation de réserve",
    explanation:
        "Elle vise à préserver la neutralité et la confiance dans le service.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe oblige l’agent à ne pas favoriser un usager pour des raisons personnelles ?",
    options: ["Impartialité", "Mutabilité", "Compétence liée"],
    answer: "Impartialité",
    explanation:
        "Décisions et comportements doivent être objectifs et équitables.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe vise à éviter conflits d’intérêts et comportements contraires à l’intérêt général ?",
    options: ["Probité", "Continuité", "Subsidiarité"],
    answer: "Probité",
    explanation:
        "La probité implique intégrité et prévention des conflits d’intérêts.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelles sont les trois collectivités territoriales principales en métropole ?",
    options: [
      "Commune, département, région",
      "Commune, canton, État",
      "Région, UE, commune",
    ],
    answer: "Commune, département, région",
    explanation: "Les trois niveaux classiques de collectivités territoriales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel est le représentant de l’État dans le département ?",
    options: ["Préfet", "Maire", "Président du conseil régional"],
    answer: "Préfet",
    explanation:
        "Il représente l’État et assure notamment le contrôle de légalité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel est le représentant de l’État dans la région ?",
    options: ["Préfet de région", "Président de région", "Procureur général"],
    answer: "Préfet de région",
    explanation: "Il coordonne l’action de l’État à l’échelle régionale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel organe délibérant vote les décisions et le budget d’une commune ?",
    options: [
      "Conseil municipal",
      "Conseil constitutionnel",
      "Conseil européen",
    ],
    answer: "Conseil municipal",
    explanation: "Le conseil municipal délibère, le maire exécute.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel organe délibérant vote les décisions et le budget d’un département ?",
    options: [
      "Conseil départemental",
      "Conseil municipal",
      "Conseil des ministres",
    ],
    answer: "Conseil départemental",
    explanation:
        "L’assemblée départementale prend les décisions locales du département.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel organe délibérant vote les décisions et le budget d’une région ?",
    options: [
      "Conseil régional",
      "Conseil municipal",
      "Conseil constitutionnel",
    ],
    answer: "Conseil régional",
    explanation:
        "L’assemblée régionale délibère sur les politiques régionales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel principe constitutionnel garantit une autonomie locale dans le cadre de la loi ?",
    options: ["Libre administration", "Primauté", "Inamovibilité"],
    answer: "Libre administration",
    explanation:
        "Les collectivités s’administrent librement dans les conditions prévues par la loi.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel document d’urbanisme fixe les règles de construction et d’aménagement à l’échelle locale ?",
    options: ["PLU", "Code pénal", "Constitution"],
    answer: "PLU",
    explanation: "Plan local d’urbanisme : zonage, règles, orientations.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle structure permet à plusieurs communes de mutualiser des compétences (déchets, transport, etc.) ?",
    options: ["EPCI", "Sénat", "CJUE"],
    answer: "EPCI",
    explanation:
        "Intercommunalité : communautés de communes, d’agglo, métropoles, etc.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle est la devise de la République française ?",
    options: [
      "Liberté, Égalité, Fraternité",
      "Paix, Travail, Justice",
      "Ordre, Nation, Autorité",
    ],
    answer: "Liberté, Égalité, Fraternité",
    explanation: "Devise républicaine officielle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel est l’hymne national de la France ?",
    options: ["La Marseillaise", "Le Chant du Départ", "La Carmagnole"],
    answer: "La Marseillaise",
    explanation: "Chant révolutionnaire devenu hymne national.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle date est célébrée comme fête nationale en France ?",
    options: ["14 juillet", "9 mai", "2 décembre"],
    answer: "14 juillet",
    explanation: "Fête nationale liée à la Révolution et à l’unité nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel symbole allégorique incarne la République française ?",
    options: ["Marianne", "Clovis", "Henri IV"],
    answer: "Marianne",
    explanation:
        "Marianne est présente dans les mairies et sur certains timbres/pièces.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel ordre des couleurs correspond au drapeau français (côté hampe vers l’extérieur) ?",
    options: ["Bleu, blanc, rouge", "Blanc, bleu, rouge", "Rouge, blanc, bleu"],
    answer: "Bleu, blanc, rouge",
    explanation: "Le bleu est côté hampe, puis blanc, puis rouge.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Que signifie l’abréviation 'RF' sur les bâtiments publics ?",
    options: ["République française", "Régime fédéral", "Réserve foncière"],
    answer: "République française",
    explanation: "RF est un marquage courant de l’État républicain.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel organe vote la loi en France ?",
    options: ["Le Parlement", "La CJUE", "La Cour des comptes"],
    answer: "Le Parlement",
    explanation: "Le Parlement (Assemblée nationale + Sénat) vote la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel organe contrôle la constitutionnalité des lois ?",
    options: [
      "Conseil constitutionnel",
      "Conseil régional",
      "Cour des comptes",
    ],
    answer: "Conseil constitutionnel",
    explanation: "Il vérifie la conformité des lois à la Constitution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "La séparation des pouvoirs vise principalement à :",
    options: [
      "Éviter l’arbitraire",
      "Supprimer le Parlement",
      "Donner tous les pouvoirs à un seul organe",
    ],
    answer: "Éviter l’arbitraire",
    explanation: "Elle limite la concentration du pouvoir.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Le principe de légalité signifie que l’administration :",
    options: [
      "Agit dans le cadre du droit",
      "Agit librement sans règles",
      "Choisit les lois à appliquer",
    ],
    answer: "Agit dans le cadre du droit",
    explanation:
        "Toute action administrative doit respecter les normes juridiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Le contrôle de constitutionnalité a posteriori en France est lié à :",
    options: ["QPC", "Suffrage censitaire", "Décentralisation"],
    answer: "QPC",
    explanation:
        "La Question prioritaire de constitutionnalité permet de contester une loi déjà en vigueur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE est parfois surnommé le 'gardien des traités' ?",
    options: [
      "Commission européenne",
      "Parlement européen",
      "Conseil européen",
    ],
    answer: "Commission européenne",
    explanation: "Elle veille au respect des traités et du droit de l’Union.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE ne représente pas un État mais l’Union et l’intérêt général ?",
    options: ["Commission européenne", "Conseil de l’UE", "Conseil européen"],
    answer: "Commission européenne",
    explanation:
        "Les commissaires ne représentent pas leur État mais l’intérêt général européen.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe adopte les orientations stratégiques sans être une chambre législative ?",
    options: ["Conseil européen", "Parlement européen", "Conseil de l’UE"],
    answer: "Conseil européen",
    explanation: "Il fixe une direction politique générale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "L’agent public doit répondre à l’intérêt général : cela renvoie à la notion de :",
    options: ["Service public", "Droit privé", "Contrat commercial"],
    answer: "Service public",
    explanation: "L’action publique est orientée vers l’intérêt général.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est souvent la plus proche des habitants pour les démarches du quotidien ?",
    options: ["Commune", "Région", "Union européenne"],
    answer: "Commune",
    explanation:
        "La commune gère des services de proximité (état civil, urbanisme, etc.).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "L’État de droit implique notamment l’existence :",
    options: [
      "De recours contre les décisions",
      "D’un pouvoir sans contrôle",
      "D’une loi secrète",
    ],
    answer: "De recours contre les décisions",
    explanation:
        "L’État de droit garantit des voies de recours et la protection des droits.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel acte européen est généralement non contraignant et sert d’orientation ?",
    options: ["Recommandation", "Règlement", "Décision"],
    answer: "Recommandation",
    explanation: "La recommandation n’a pas de force obligatoire directe.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Le principe d’égalité devant la loi signifie :",
    options: [
      "La même règle pour tous",
      "Une règle différente selon la personne",
      "Une loi réservée à certains",
    ],
    answer: "La même règle pour tous",
    explanation: "Principe fondamental de la République et de l’État de droit.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE est composé de juges et d’avocats généraux ?",
    options: ["CJUE", "BCE", "Parlement européen"],
    answer: "CJUE",
    explanation:
        "La Cour de justice de l’Union européenne comprend des juges et des avocats généraux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE publie des rapports sur la performance budgétaire et les irrégularités ?",
    options: [
      "Cour des comptes européenne",
      "Conseil européen",
      "Comité des régions",
    ],
    answer: "Cour des comptes européenne",
    explanation:
        "Elle contrôle la régularité des comptes et l’efficacité de la gestion financière.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe est compétent pour interpréter le droit de l’UE afin qu’il soit appliqué de façon uniforme ?",
    options: ["CJUE", "Parlement européen", "BCE"],
    answer: "CJUE",
    explanation:
        "La CJUE assure l’unité d’interprétation et d’application du droit de l’Union.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution de l’UE est en principe seule à pouvoir proposer une directive ou un règlement ?",
    options: [
      "Commission européenne",
      "Parlement européen",
      "Conseil européen",
    ],
    answer: "Commission européenne",
    explanation: "Elle dispose de l’initiative législative (principalement).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Le Parlement européen vote notamment :",
    options: [
      "Le budget avec le Conseil de l’UE",
      "Les taux directeurs",
      "Les arrêtés préfectoraux",
    ],
    answer: "Le budget avec le Conseil de l’UE",
    explanation:
        "Il partage le pouvoir budgétaire et législatif avec le Conseil de l’UE.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel siège est associé à la Banque centrale européenne ?",
    options: ["Francfort", "Strasbourg", "Luxembourg"],
    answer: "Francfort",
    explanation: "La BCE siège à Francfort-sur-le-Main.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE réunit les ministres des États membres pour négocier et adopter des textes ?",
    options: [
      "Conseil de l’Union européenne",
      "Conseil européen",
      "Cour des comptes européenne",
    ],
    answer: "Conseil de l’Union européenne",
    explanation:
        "Le Conseil de l’UE est l’un des deux co-législateurs avec le Parlement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE réunit les chefs d’État ou de gouvernement ?",
    options: [
      "Conseil européen",
      "Conseil de l’Union européenne",
      "Commission européenne",
    ],
    answer: "Conseil européen",
    explanation: "Il définit les grandes orientations politiques de l’Union.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel texte européen est directement applicable sans transposition nationale ?",
    options: ["Règlement", "Directive", "Avis"],
    answer: "Règlement",
    explanation:
        "Le règlement s’applique immédiatement dans tous les États membres.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel texte européen fixe un objectif et nécessite une transposition ?",
    options: ["Directive", "Règlement", "Décision locale"],
    answer: "Directive",
    explanation:
        "La directive laisse aux États le choix des moyens pour atteindre l’objectif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe européen impose d’agir au niveau le plus efficace et le plus proche des citoyens ?",
    options: ["Subsidiarité", "Centralisation", "Immunité"],
    answer: "Subsidiarité",
    explanation:
        "L’UE agit si l’objectif est mieux atteint au niveau européen.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe européen limite l’action de l’UE à ce qui est nécessaire ?",
    options: ["Proportionnalité", "Primauté", "Neutralité"],
    answer: "Proportionnalité",
    explanation:
        "L’UE ne doit pas aller au-delà du nécessaire pour atteindre un but.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe consultatif représente les acteurs économiques et sociaux au niveau européen ?",
    options: ["CESE européen", "CJUE", "BCE"],
    answer: "CESE européen",
    explanation:
        "Le Comité économique et social européen rend des avis consultatifs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe consultatif représente les régions et collectivités au niveau européen ?",
    options: ["Comité des régions", "Conseil européen", "Parlement européen"],
    answer: "Comité des régions",
    explanation:
        "Il émet des avis sur les politiques ayant un impact territorial.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe indique qu’en cas de conflit, le droit de l’UE prime sur le droit national ?",
    options: ["Primauté du droit de l’UE", "Mutabilité", "Continuité"],
    answer: "Primauté du droit de l’UE",
    explanation: "Principe clé de l’intégration européenne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe du service public impose le fonctionnement régulier du service ?",
    options: ["Continuité", "Subsidiarité", "Proportionnalité"],
    answer: "Continuité",
    explanation:
        "La continuité garantit que le service public ne s’interrompt pas arbitrairement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe du service public impose une adaptation permanente aux besoins ?",
    options: ["Mutabilité", "Immunité", "Dissolution"],
    answer: "Mutabilité",
    explanation:
        "Le service public évolue avec la société et les besoins des usagers.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose un traitement identique des usagers à situation comparable ?",
    options: ["Égalité", "Centralisation", "Cumul"],
    answer: "Égalité",
    explanation: "Principe d’égalité devant le service public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "La neutralité dans la fonction publique implique notamment :",
    options: [
      "Ne pas manifester ses opinions dans l’exercice des fonctions",
      "Publier ses opinions au guichet",
      "Choisir ses usagers",
    ],
    answer: "Ne pas manifester ses opinions dans l’exercice des fonctions",
    explanation:
        "Neutralité et impartialité garantissent la confiance des usagers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose de ne pas divulguer des informations sensibles connues au travail ?",
    options: ["Secret professionnel", "Droit syndical", "Liberté de culte"],
    answer: "Secret professionnel",
    explanation:
        "Le secret professionnel protège les informations confidentielles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose une retenue dans les propos publics pour préserver le service ?",
    options: [
      "Obligation de réserve",
      "Obligation de publicité",
      "Obligation de cumul",
    ],
    answer: "Obligation de réserve",
    explanation: "Devoir de mesure dans l’expression, selon le contexte.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "La probité renvoie principalement à :",
    options: [
      "L’intégrité et l’absence de conflit d’intérêts",
      "La vitesse d’exécution",
      "La réussite scolaire",
    ],
    answer: "L’intégrité et l’absence de conflit d’intérêts",
    explanation:
        "Probité = honnêteté, prévention de la corruption, intérêt général.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "L’impartialité impose à l’agent public :",
    options: [
      "D’agir sans favoritisme",
      "De favoriser sa famille",
      "De refuser certains usagers",
    ],
    answer: "D’agir sans favoritisme",
    explanation: "L’agent ne doit pas discriminer ni privilégier.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "L’obéissance hiérarchique signifie que l’agent doit :",
    options: [
      "Exécuter les ordres légaux",
      "Toujours exécuter même illégal",
      "Ne jamais obéir",
    ],
    answer: "Exécuter les ordres légaux",
    explanation:
        "Exception : ordre manifestement illégal et grave pour l’intérêt public.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel versant regroupe les agents des collectivités territoriales ?",
    options: [
      "Fonction publique territoriale",
      "Fonction publique d’État",
      "Fonction publique judiciaire",
    ],
    answer: "Fonction publique territoriale",
    explanation: "Communes, départements, régions, intercommunalités.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel versant regroupe les agents des hôpitaux publics ?",
    options: [
      "Fonction publique hospitalière",
      "Fonction publique territoriale",
      "Fonction publique d’État",
    ],
    answer: "Fonction publique hospitalière",
    explanation: "Personnel des établissements publics de santé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "La décentralisation consiste principalement à :",
    options: [
      "Transférer des compétences de l’État vers des collectivités",
      "Supprimer les collectivités",
      "Renforcer la centralisation",
    ],
    answer: "Transférer des compétences de l’État vers des collectivités",
    explanation: "Objectif : autonomie locale dans le cadre légal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel est l’exécutif de la commune ?",
    options: ["Maire", "Préfet", "Président du conseil régional"],
    answer: "Maire",
    explanation: "Le maire exécute les décisions du conseil municipal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel est l’organe délibérant d’une commune ?",
    options: [
      "Conseil municipal",
      "Conseil départemental",
      "Conseil des ministres",
    ],
    answer: "Conseil municipal",
    explanation: "Il vote les décisions locales et le budget.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel est l’organe délibérant d’un département ?",
    options: [
      "Conseil départemental",
      "Conseil municipal",
      "Parlement européen",
    ],
    answer: "Conseil départemental",
    explanation: "Assemblée départementale élue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel est l’organe délibérant d’une région ?",
    options: ["Conseil régional", "Conseil municipal", "CJUE"],
    answer: "Conseil régional",
    explanation: "Assemblée régionale élue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel représentant de l’État contrôle la légalité des actes des collectivités dans le département ?",
    options: ["Préfet", "Maire", "Président du conseil départemental"],
    answer: "Préfet",
    explanation:
        "Le préfet exerce le contrôle de légalité et représente l’État.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle structure permet à plusieurs communes de gérer ensemble des compétences ?",
    options: [
      "Intercommunalité (EPCI)",
      "Conseil constitutionnel",
      "Assemblée nationale",
    ],
    answer: "Intercommunalité (EPCI)",
    explanation: "Mutualisation via communautés, métropoles, etc.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel principe constitutionnel affirme que les collectivités s’administrent librement ?",
    options: ["Libre administration", "Primauté", "Neutralité"],
    answer: "Libre administration",
    explanation:
        "Principe encadré : libre administration dans les conditions prévues par la loi.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel document local fixe les règles d’urbanisme et de construction ?",
    options: ["PLU", "Code de la nationalité", "Traité de Maastricht"],
    answer: "PLU",
    explanation:
        "Plan local d’urbanisme : règles et zonage à l’échelle locale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle date correspond à la fête nationale française ?",
    options: ["14 juillet", "8 mai", "24 décembre"],
    answer: "14 juillet",
    explanation: "Célébration nationale liée à la Révolution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel est l’hymne national français ?",
    options: ["La Marseillaise", "L’Internationale", "Le Chant des Partisans"],
    answer: "La Marseillaise",
    explanation: "Hymne national officiel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle est la devise officielle de la République ?",
    options: [
      "Liberté, Égalité, Fraternité",
      "Travail, Famille, Patrie",
      "Force, Honneur, Nation",
    ],
    answer: "Liberté, Égalité, Fraternité",
    explanation:
        "Devise républicaine affichée sur de nombreux bâtiments publics.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole allégorique est souvent représenté par un buste en mairie ?",
    options: ["Marianne", "Napoléon", "Louis XIV"],
    answer: "Marianne",
    explanation: "Marianne est l’emblème républicain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel est l’ordre officiel des couleurs du drapeau (côté hampe vers l’extérieur) ?",
    options: ["Bleu, blanc, rouge", "Rouge, blanc, bleu", "Blanc, rouge, bleu"],
    answer: "Bleu, blanc, rouge",
    explanation: "Le bleu est placé côté hampe, puis blanc, puis rouge.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel sigle signifie 'République française' sur des bâtiments ou documents publics ?",
    options: ["RF", "UE", "ONU"],
    answer: "RF",
    explanation:
        "RF est l’abréviation la plus courante de République française.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel organe vote les lois en France ?",
    options: ["Parlement", "Conseil constitutionnel", "Cour des comptes"],
    answer: "Parlement",
    explanation: "Le Parlement adopte la loi : Assemblée nationale + Sénat.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Le Parlement français est composé de :",
    options: [
      "Assemblée nationale et Sénat",
      "Gouvernement et Conseil d’État",
      "CJUE et BCE",
    ],
    answer: "Assemblée nationale et Sénat",
    explanation: "Deux chambres : bicamérisme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel organe contrôle la constitutionnalité des lois ?",
    options: [
      "Conseil constitutionnel",
      "Conseil municipal",
      "Comité des régions",
    ],
    answer: "Conseil constitutionnel",
    explanation: "Il vérifie la conformité à la Constitution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "La séparation des pouvoirs distingue principalement :",
    options: [
      "Exécutif, législatif, judiciaire",
      "Régional, communal, européen",
      "Civil, pénal, commercial",
    ],
    answer: "Exécutif, législatif, judiciaire",
    explanation: "Principe protecteur contre l’arbitraire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "L’État de droit implique notamment :",
    options: [
      "Soumission des autorités au droit",
      "Absence de contrôle",
      "Pouvoir illimité",
    ],
    answer: "Soumission des autorités au droit",
    explanation:
        "Les décisions publiques doivent respecter la loi et la Constitution.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel mécanisme permet à un citoyen de contester une loi déjà en vigueur devant le Conseil constitutionnel (via une juridiction) ?",
    options: ["QPC", "Référendum local", "Ordonnance"],
    answer: "QPC",
    explanation:
        "La question prioritaire de constitutionnalité permet un contrôle a posteriori.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe affirme que la loi est la même pour tous ?",
    options: ["Égalité devant la loi", "Hérédité", "Censure"],
    answer: "Égalité devant la loi",
    explanation: "Principe fondamental de la République.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE adopte des conclusions donnant une direction politique générale ?",
    options: ["Conseil européen", "CJUE", "Cour des comptes européenne"],
    answer: "Conseil européen",
    explanation:
        "Le Conseil européen fixe les grandes orientations et publie des conclusions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE siège en formation différente selon les sujets (ex : ECOFIN, Agriculture) ?",
    options: [
      "Conseil de l’Union européenne",
      "Parlement européen",
      "Conseil européen",
    ],
    answer: "Conseil de l’Union européenne",
    explanation:
        "Il réunit les ministres compétents selon la thématique traitée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE peut adopter une motion de censure visant la Commission ?",
    options: ["Parlement européen", "Conseil européen", "BCE"],
    answer: "Parlement européen",
    explanation:
        "Le Parlement peut contraindre la Commission à démissionner (procédure politique lourde).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE valide généralement le ou la président(e) de la Commission proposé(e) ?",
    options: ["Parlement européen", "CJUE", "Cour des comptes européenne"],
    answer: "Parlement européen",
    explanation:
        "Le Parlement élit le président de la Commission proposé par le Conseil européen.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE est chargé d’assurer la stabilité des prix dans la zone euro ?",
    options: ["BCE", "Commission européenne", "Conseil de l’UE"],
    answer: "BCE",
    explanation: "La BCE a pour mission principale la stabilité des prix.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel texte européen est directement applicable dans tous les États sans transposition ?",
    options: ["Règlement", "Directive", "Recommandation"],
    answer: "Règlement",
    explanation:
        "Le règlement s’applique immédiatement et uniformément dans l’UE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel texte européen doit être transposé dans le droit national ?",
    options: ["Directive", "Règlement", "Décision individuelle"],
    answer: "Directive",
    explanation:
        "La directive fixe un objectif à atteindre, avec des modalités nationales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe vise à limiter l’action de l’UE à ce qui est nécessaire ?",
    options: ["Proportionnalité", "Neutralité", "Mutabilité"],
    answer: "Proportionnalité",
    explanation:
        "L’action européenne ne doit pas dépasser le nécessaire pour atteindre l’objectif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe veut que l’UE agisse seulement si l’échelon européen est plus efficace ?",
    options: ["Subsidiarité", "Centralisation", "Continuité"],
    answer: "Subsidiarité",
    explanation:
        "Principe clé : décision au niveau le plus pertinent et proche.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution contrôle la bonne utilisation des fonds et publie des rapports d’audit ?",
    options: [
      "Cour des comptes européenne",
      "Parlement européen",
      "Conseil européen",
    ],
    answer: "Cour des comptes européenne",
    explanation:
        "Elle vérifie la régularité et l’efficacité de la gestion financière.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe du service public impose un accès sans discrimination injustifiée ?",
    options: ["Égalité", "Primauté", "Subsidiarité"],
    answer: "Égalité",
    explanation:
        "Les usagers doivent être traités de manière égale dans une situation comparable.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe du service public impose le fonctionnement régulier dans le temps ?",
    options: ["Continuité", "Mutabilité", "Proportionnalité"],
    answer: "Continuité",
    explanation: "La continuité garantit la permanence du service public.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe du service public impose l’adaptation aux besoins et aux évolutions ?",
    options: ["Mutabilité", "Neutralité", "Primauté"],
    answer: "Mutabilité",
    explanation:
        "Le service public doit évoluer avec les techniques et les besoins des usagers.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "La neutralité impose à l’agent public de :",
    options: [
      "Rester impartial dans l’exercice des fonctions",
      "Exprimer ses opinions au guichet",
      "Refuser certains usagers",
    ],
    answer: "Rester impartial dans l’exercice des fonctions",
    explanation:
        "Neutralité et impartialité protègent l’égalité de traitement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir interdit de révéler des informations confidentielles sur les usagers ?",
    options: ["Secret professionnel", "Droit de grève", "Liberté syndicale"],
    answer: "Secret professionnel",
    explanation: "Le secret professionnel protège les informations sensibles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir exige une retenue dans l’expression publique d’un agent ?",
    options: [
      "Obligation de réserve",
      "Obligation de publicité",
      "Obligation de cumul",
    ],
    answer: "Obligation de réserve",
    explanation: "Elle vise à préserver la confiance dans le service public.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "La probité renvoie à :",
    options: [
      "L’intégrité et la prévention des conflits d’intérêts",
      "La rapidité d’exécution",
      "La popularité de l’agent",
    ],
    answer: "L’intégrité et la prévention des conflits d’intérêts",
    explanation:
        "Probité = honnêteté, respect de l’intérêt général, anti-corruption.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "L’impartialité impose :",
    options: [
      "Absence de favoritisme",
      "Favoriser ses proches",
      "Refuser les demandes complexes",
    ],
    answer: "Absence de favoritisme",
    explanation: "Les décisions doivent être objectives et équitables.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "L’obéissance hiérarchique oblige l’agent à :",
    options: [
      "Exécuter les ordres légaux",
      "Exécuter tout ordre même illégal",
      "Ignorer toute consigne",
    ],
    answer: "Exécuter les ordres légaux",
    explanation:
        "Exception : ordre manifestement illégal et grave pour l’intérêt public.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel versant concerne principalement les agents des collectivités territoriales ?",
    options: [
      "Fonction publique territoriale",
      "Fonction publique d’État",
      "Fonction publique européenne",
    ],
    answer: "Fonction publique territoriale",
    explanation:
        "Agents des communes, départements, régions et intercommunalités.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité est dirigée par un maire ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation: "Le maire est l’exécutif de la commune.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est dirigée par un président du conseil départemental ?",
    options: ["Département", "Commune", "Région"],
    answer: "Département",
    explanation: "Le conseil départemental élit son président.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est dirigée par un président du conseil régional ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "Le conseil régional élit son président.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel représentant de l’État exerce le contrôle de légalité dans le département ?",
    options: ["Préfet", "Maire", "Président du conseil régional"],
    answer: "Préfet",
    explanation:
        "Le préfet représente l’État et contrôle la légalité des actes locaux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "L’intercommunalité désigne :",
    options: [
      "La coopération entre communes",
      "Une chambre du Parlement",
      "Une juridiction européenne",
    ],
    answer: "La coopération entre communes",
    explanation: "Les communes mutualisent certaines compétences via des EPCI.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel type de structure intercommunale correspond à une grande aire urbaine avec compétences renforcées ?",
    options: ["Métropole", "Canton", "Préfecture"],
    answer: "Métropole",
    explanation:
        "La métropole est un EPCI à fiscalité propre aux compétences importantes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel principe constitutionnel concerne l’autonomie locale encadrée par la loi ?",
    options: ["Libre administration", "Primauté", "Continuité"],
    answer: "Libre administration",
    explanation:
        "Les collectivités s’administrent librement dans les conditions prévues par la loi.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel document fixe des règles d’urbanisme à l’échelle locale ?",
    options: ["PLU", "Traité de Rome", "Code de la route"],
    answer: "PLU",
    explanation:
        "Le Plan local d’urbanisme organise le zonage et les règles de construction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel est l’organe délibérant d’une commune ?",
    options: [
      "Conseil municipal",
      "Conseil régional",
      "Conseil constitutionnel",
    ],
    answer: "Conseil municipal",
    explanation: "Il vote les délibérations et le budget communal.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle date est la fête nationale française ?",
    options: ["14 juillet", "1er janvier", "15 août"],
    answer: "14 juillet",
    explanation: "Fête nationale liée à la Révolution française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel est l’hymne national de la France ?",
    options: ["La Marseillaise", "Le Chant des Partisans", "La Carmagnole"],
    answer: "La Marseillaise",
    explanation: "Hymne officiel depuis la Révolution (puis réadopté).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle est la devise de la République française ?",
    options: [
      "Liberté, Égalité, Fraternité",
      "Ordre et Progrès",
      "Unité, Travail, Justice",
    ],
    answer: "Liberté, Égalité, Fraternité",
    explanation: "Devise officielle de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel symbole allégorique est associé à la République ?",
    options: ["Marianne", "Vercingétorix", "Louis XVI"],
    answer: "Marianne",
    explanation:
        "Marianne représente la République sur les bustes et certaines pièces.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel est l’ordre officiel des couleurs du drapeau (côté hampe vers l’extérieur) ?",
    options: ["Bleu, blanc, rouge", "Rouge, blanc, bleu", "Blanc, rouge, bleu"],
    answer: "Bleu, blanc, rouge",
    explanation: "Le bleu est côté hampe, puis blanc, puis rouge.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Le sigle 'RF' signifie :",
    options: ["République française", "Régime fédéral", "Réserve foncière"],
    answer: "République française",
    explanation: "Marquage courant sur les documents et bâtiments publics.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Le pouvoir législatif est exercé par :",
    options: ["Le Parlement", "Le Gouvernement", "La Cour des comptes"],
    answer: "Le Parlement",
    explanation: "Le Parlement vote la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Le Parlement est composé de :",
    options: [
      "Assemblée nationale et Sénat",
      "Conseil constitutionnel et Conseil d’État",
      "CJUE et BCE",
    ],
    answer: "Assemblée nationale et Sénat",
    explanation: "Bicamérisme : deux chambres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel organe contrôle la constitutionnalité des lois ?",
    options: [
      "Conseil constitutionnel",
      "Conseil municipal",
      "Conseil européen",
    ],
    answer: "Conseil constitutionnel",
    explanation: "Il juge si une loi respecte la Constitution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "La séparation des pouvoirs vise à :",
    options: [
      "Limiter l’arbitraire",
      "Supprimer les élections",
      "Remplacer les lois par des coutumes",
    ],
    answer: "Limiter l’arbitraire",
    explanation: "Elle empêche la concentration excessive du pouvoir.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "L’État de droit signifie que :",
    options: [
      "Le pouvoir est encadré par le droit",
      "Le droit dépend du pouvoir",
      "Les règles ne s’appliquent pas à l’État",
    ],
    answer: "Le pouvoir est encadré par le droit",
    explanation:
        "Les autorités publiques doivent respecter la loi et la Constitution.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel mécanisme permet de contester une loi déjà en vigueur devant le Conseil constitutionnel (via une juridiction) ?",
    options: ["QPC", "Référendum national obligatoire", "Décentralisation"],
    answer: "QPC",
    explanation:
        "Question prioritaire de constitutionnalité : contrôle a posteriori.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Le principe d’égalité devant la loi implique :",
    options: [
      "Même règle pour tous",
      "Règles différentes selon la personne",
      "Lois secrètes réservées à certains",
    ],
    answer: "Même règle pour tous",
    explanation: "Principe fondamental de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Le principe de légalité impose que l’administration :",
    options: [
      "Agisse conformément au droit",
      "Agisse sans règles",
      "Agisse selon l’opinion publique uniquement",
    ],
    answer: "Agisse conformément au droit",
    explanation:
        "Toute décision administrative doit respecter les normes juridiques.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE peut engager une procédure d’infraction contre un État membre ?",
    options: [
      "Commission européenne",
      "Parlement européen",
      "Conseil européen",
    ],
    answer: "Commission européenne",
    explanation:
        "Elle veille au respect du droit de l’Union par les États membres.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE tranche les litiges entre États membres et institutions ?",
    options: ["CJUE", "Cour des comptes européenne", "BCE"],
    answer: "CJUE",
    explanation:
        "La Cour de justice de l’UE est la juridiction suprême de l’Union.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE contrôle la politique monétaire de la zone euro ?",
    options: ["BCE", "Commission européenne", "Parlement européen"],
    answer: "BCE",
    explanation:
        "La Banque centrale européenne définit et met en œuvre la politique monétaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel est le principal objectif de la BCE ?",
    options: [
      "Stabilité des prix",
      "Croissance démographique",
      "Politique sociale",
    ],
    answer: "Stabilité des prix",
    explanation: "La BCE vise à maintenir l’inflation sous contrôle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE élabore les propositions de lois européennes ?",
    options: ["Commission européenne", "Conseil de l’UE", "Parlement européen"],
    answer: "Commission européenne",
    explanation: "Elle dispose principalement de l’initiative législative.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE adopte les lois conjointement avec le Parlement ?",
    options: ["Conseil de l’Union européenne", "Conseil européen", "CJUE"],
    answer: "Conseil de l’Union européenne",
    explanation: "Il est co-législateur avec le Parlement européen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel traité crée officiellement l’Union européenne en 1992 ?",
    options: ["Maastricht", "Rome", "Lisbonne"],
    answer: "Maastricht",
    explanation:
        "Le traité de Maastricht fonde l’UE et la citoyenneté européenne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel traité renforce le rôle du Parlement européen ?",
    options: ["Lisbonne", "Nice", "Rome"],
    answer: "Lisbonne",
    explanation: "Le traité de Lisbonne étend les pouvoirs du Parlement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe garantit l’application prioritaire du droit européen sur le droit national ?",
    options: ["Primauté", "Subsidiarité", "Neutralité"],
    answer: "Primauté",
    explanation: "Le droit de l’UE prévaut en cas de conflit.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe vérifie la légalité des actes des institutions européennes ?",
    options: ["CJUE", "Cour des comptes européenne", "Conseil européen"],
    answer: "CJUE",
    explanation: "Elle contrôle la légalité des actes de l’Union.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose la neutralité religieuse de l’administration ?",
    options: ["Laïcité", "Liberté d’expression", "Mutabilité"],
    answer: "Laïcité",
    explanation: "L’administration ne favorise aucune religion.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel droit permet à un agent de se syndiquer ?",
    options: ["Droit syndical", "Droit de veto", "Droit de réserve"],
    answer: "Droit syndical",
    explanation: "Les agents peuvent adhérer à un syndicat.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à un agent de cesser le travail sous conditions ?",
    options: ["Droit de grève", "Droit de retrait", "Droit d’association"],
    answer: "Droit de grève",
    explanation: "Le droit de grève est reconnu mais encadré.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à un agent de quitter son poste en cas de danger grave et imminent ?",
    options: ["Droit de retrait", "Droit de grève", "Droit syndical"],
    answer: "Droit de retrait",
    explanation: "Il protège la santé et la sécurité de l’agent.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel devoir impose à l’agent de servir l’intérêt général ?",
    options: ["Devoir de loyauté", "Droit d’opinion", "Droit de grève"],
    answer: "Devoir de loyauté",
    explanation: "L’agent doit agir dans l’intérêt du service.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe interdit le cumul abusif d’activités privées et publiques ?",
    options: [
      "Prévention des conflits d’intérêts",
      "Mutabilité",
      "Subsidiarité",
    ],
    answer: "Prévention des conflits d’intérêts",
    explanation: "Il protège l’impartialité du service public.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel organisme contrôle la déontologie des agents publics ?",
    options: ["HATVP", "Conseil constitutionnel", "CJUE"],
    answer: "HATVP",
    explanation: "La Haute Autorité pour la transparence de la vie publique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose à l’agent d’exécuter les ordres sauf s’ils sont manifestement illégaux ?",
    options: ["Obéissance hiérarchique", "Neutralité", "Liberté syndicale"],
    answer: "Obéissance hiérarchique",
    explanation: "Principe fondamental du fonctionnement administratif.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité est compétente en matière de collèges ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation: "Les départements gèrent les collèges.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité est compétente en matière de lycées ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "Les régions gèrent les lycées.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité gère principalement les écoles primaires ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation: "Les communes sont responsables des écoles primaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel niveau territorial gère l’aide sociale et le RSA ?",
    options: ["Département", "Commune", "Région"],
    answer: "Département",
    explanation: "Le département a un rôle clé en matière de solidarité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel niveau territorial est chef de file du développement économique ?",
    options: ["Région", "Commune", "Département"],
    answer: "Région",
    explanation: "La région coordonne le développement économique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel niveau territorial gère l’état civil ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation: "Naissances, mariages et décès sont enregistrés en mairie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel représentant de l’État coordonne l’action des préfets de département ?",
    options: ["Préfet de région", "Maire", "Président de région"],
    answer: "Préfet de région",
    explanation: "Il supervise l’action de l’État à l’échelle régionale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle structure intercommunale exerce des compétences élargies dans les grandes villes ?",
    options: ["Métropole", "Canton", "Arrondissement"],
    answer: "Métropole",
    explanation:
        "La métropole regroupe plusieurs communes avec des compétences renforcées.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel texte constitutionnel consacre la devise républicaine ?",
    options: ["Constitution de 1958", "Déclaration de 1793", "Code civil"],
    answer: "Constitution de 1958",
    explanation: "La devise figure à l’article 2 de la Constitution.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole républicain figure sur certaines pièces et timbres ?",
    options: ["Marianne", "Clovis", "Napoléon"],
    answer: "Marianne",
    explanation: "Marianne est un symbole officiel de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel événement est traditionnellement commémoré le 11 novembre ?",
    options: ["Armistice de 1918", "Prise de la Bastille", "Appel du 18 juin"],
    answer: "Armistice de 1918",
    explanation: "Commémoration de la fin de la Première Guerre mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel événement est commémoré le 8 mai ?",
    options: ["Victoire de 1945", "Révolution française", "Fondation de l’UE"],
    answer: "Victoire de 1945",
    explanation: "Fin de la Seconde Guerre mondiale en Europe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe interdit toute discrimination fondée sur l’origine, le sexe ou la religion ?",
    options: ["Égalité", "Neutralité", "Subsidiarité"],
    answer: "Égalité",
    explanation: "Principe fondamental de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe garantit les libertés individuelles face au pouvoir ?",
    options: ["État de droit", "Centralisation", "Autorité"],
    answer: "État de droit",
    explanation: "Les droits et libertés sont protégés par la loi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel organe est le chef de l’exécutif en France ?",
    options: [
      "Président de la République",
      "Parlement",
      "Conseil constitutionnel",
    ],
    answer: "Président de la République",
    explanation: "Il exerce le pouvoir exécutif avec le Gouvernement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel organe dirige l’action du Gouvernement ?",
    options: [
      "Premier ministre",
      "Président du Sénat",
      "Conseil constitutionnel",
    ],
    answer: "Premier ministre",
    explanation: "Il dirige l’action du Gouvernement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe impose que toute décision administrative respecte la loi ?",
    options: ["Légalité", "Mutabilité", "Neutralité"],
    answer: "Légalité",
    explanation: "L’administration est soumise au droit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel mécanisme permet au Parlement de renverser le Gouvernement ?",
    options: ["Motion de censure", "Référendum", "Dissolution"],
    answer: "Motion de censure",
    explanation: "Elle engage la responsabilité politique du Gouvernement.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE approuve le collège des commissaires dans son ensemble ?",
    options: ["Parlement européen", "Conseil européen", "CJUE"],
    answer: "Parlement européen",
    explanation:
        "Le Parlement approuve la Commission après auditions des commissaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quelle institution européenne fixe les taux directeurs ?",
    options: ["BCE", "Commission européenne", "Parlement européen"],
    answer: "BCE",
    explanation: "La BCE conduit la politique monétaire de la zone euro.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel traité a remplacé la Constitution européenne rejetée en 2005 ?",
    options: ["Traité de Lisbonne", "Traité de Rome", "Traité de Nice"],
    answer: "Traité de Lisbonne",
    explanation: "Entré en vigueur en 2009.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe de l’UE statue sur les recours en annulation ?",
    options: ["CJUE", "Cour des comptes européenne", "BCE"],
    answer: "CJUE",
    explanation: "Elle peut annuler un acte contraire aux traités.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel droit permet à un citoyen de l’UE de circuler et séjourner librement ?",
    options: ["Libre circulation", "Droit d’asile", "Droit de veto"],
    answer: "Libre circulation",
    explanation: "Droit fondamental des citoyens de l’UE.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel programme européen finance la mobilité étudiante ?",
    options: ["Erasmus+", "Horizon Europe", "Frontex"],
    answer: "Erasmus+",
    explanation: "Programme de mobilité pour l’éducation et la formation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe gère la surveillance des frontières extérieures de l’UE ?",
    options: ["Frontex", "Europol", "Eurojust"],
    answer: "Frontex",
    explanation: "Agence européenne de garde-frontières et de garde-côtes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quelle agence européenne coopère en matière policière ?",
    options: ["Europol", "Eurostat", "EASA"],
    answer: "Europol",
    explanation: "Elle soutient la coopération policière entre États membres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quelle agence soutient la coopération judiciaire pénale ?",
    options: ["Eurojust", "Europol", "OLAF"],
    answer: "Eurojust",
    explanation: "Coordination judiciaire entre autorités nationales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel office lutte contre la fraude aux fonds européens ?",
    options: ["OLAF", "Europol", "Eurostat"],
    answer: "OLAF",
    explanation: "Office européen de lutte antifraude.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel droit permet aux agents de participer à la vie syndicale ?",
    options: ["Droit syndical", "Droit de veto", "Droit d’asile"],
    answer: "Droit syndical",
    explanation: "Liberté syndicale reconnue aux agents publics.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel droit protège l’agent en cas de danger grave et imminent ?",
    options: ["Droit de retrait", "Droit de grève", "Droit de réserve"],
    answer: "Droit de retrait",
    explanation: "Il permet de se retirer sans sanction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel devoir impose la neutralité politique et religieuse ?",
    options: ["Neutralité", "Liberté d’opinion", "Cumul d’activités"],
    answer: "Neutralité",
    explanation: "Garantit l’égalité et l’impartialité du service.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir interdit la divulgation d’informations confidentielles ?",
    options: ["Secret professionnel", "Droit syndical", "Liberté d’expression"],
    answer: "Secret professionnel",
    explanation: "Protège les données et la vie privée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel devoir exige la loyauté envers l’administration ?",
    options: ["Devoir de loyauté", "Droit de grève", "Droit d’association"],
    answer: "Devoir de loyauté",
    explanation: "L’agent agit dans l’intérêt du service.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe vise à prévenir la corruption et les conflits d’intérêts ?",
    options: ["Probité", "Mutabilité", "Subsidiarité"],
    answer: "Probité",
    explanation: "Intégrité et prévention des conflits d’intérêts.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel organisme contrôle la transparence de la vie publique ?",
    options: ["HATVP", "CNIL", "CSA"],
    answer: "HATVP",
    explanation: "Haute Autorité pour la transparence de la vie publique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe impose un traitement équitable des usagers ?",
    options: ["Impartialité", "Centralisation", "Cumul"],
    answer: "Impartialité",
    explanation: "Décisions objectives et sans favoritisme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est compétente pour les transports régionaux ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "La région est chef de file des transports.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité gère l’aide sociale à l’enfance ?",
    options: ["Département", "Commune", "Région"],
    answer: "Département",
    explanation: "Compétence sociale majeure du département.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité gère la voirie communale ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation: "Compétence de proximité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel niveau est chef de file de l’aménagement du territoire ?",
    options: ["Région", "Commune", "Département"],
    answer: "Région",
    explanation: "Coordination stratégique territoriale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel représentant de l’État exerce le contrôle budgétaire local ?",
    options: ["Préfet", "Maire", "Président de région"],
    answer: "Préfet",
    explanation: "Contrôle de légalité et budgétaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle structure regroupe plusieurs communes autour d’un projet commun ?",
    options: ["EPCI", "Canton", "Arrondissement"],
    answer: "EPCI",
    explanation: "Établissement public de coopération intercommunale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel principe garantit l’autonomie locale dans le cadre de la loi ?",
    options: ["Libre administration", "Primauté", "Neutralité"],
    answer: "Libre administration",
    explanation: "Principe constitutionnel.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel texte constitutionnel consacre la laïcité ?",
    options: ["Constitution de 1958", "Code civil", "Traité de Rome"],
    answer: "Constitution de 1958",
    explanation: "La laïcité figure à l’article 1.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel événement est commémoré le 18 juin ?",
    options: ["Appel du 18 juin 1940", "Armistice de 1918", "Victoire de 1945"],
    answer: "Appel du 18 juin 1940",
    explanation: "Discours du général de Gaulle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel monument parisien est un symbole républicain des grandes commémorations ?",
    options: ["Arc de Triomphe", "Tour Eiffel", "Sacré-Cœur"],
    answer: "Arc de Triomphe",
    explanation: "Tombe du Soldat inconnu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel pouvoir promulgue les lois ?",
    options: ["Exécutif", "Judiciaire", "Administratif"],
    answer: "Exécutif",
    explanation: "Le Président promulgue la loi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel organe peut dissoudre l’Assemblée nationale ?",
    options: [
      "Président de la République",
      "Premier ministre",
      "Conseil constitutionnel",
    ],
    answer: "Président de la République",
    explanation: "Pouvoir prévu par la Constitution.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel mécanisme engage la responsabilité du Gouvernement devant l’Assemblée ?",
    options: ["Motion de censure", "QPC", "Référendum"],
    answer: "Motion de censure",
    explanation: "Procédure parlementaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe impose que les décisions respectent la hiérarchie des normes ?",
    options: ["Légalité", "Mutabilité", "Centralisation"],
    answer: "Légalité",
    explanation: "Respect des normes supérieures.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe protège les libertés par des recours juridictionnels ?",
    options: ["État de droit", "Autorité", "Centralisation"],
    answer: "État de droit",
    explanation: "Soumission du pouvoir au droit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe garantit l’égalité devant la justice ?",
    options: ["Égalité", "Neutralité", "Subsidiarité"],
    answer: "Égalité",
    explanation: "Même droit pour tous.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe limite l’exercice du pouvoir par des contre-pouvoirs ?",
    options: ["Séparation des pouvoirs", "Centralisation", "Unicité"],
    answer: "Séparation des pouvoirs",
    explanation: "Exécutif, législatif et judiciaire distincts.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe de l’UE est composé de représentants permanents des États membres (COREPER) ?",
    options: [
      "Conseil de l’Union européenne",
      "Parlement européen",
      "Commission européenne",
    ],
    answer: "Conseil de l’Union européenne",
    explanation: "Le COREPER prépare les travaux du Conseil de l’UE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne publie les statistiques officielles de l’UE ?",
    options: ["Eurostat", "Europol", "OLAF"],
    answer: "Eurostat",
    explanation: "Eurostat est l’office statistique de l’Union européenne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel droit permet à un citoyen de l’UE de voter aux élections municipales dans un autre État membre ?",
    options: [
      "Citoyenneté européenne",
      "Droit d’asile",
      "Principe de primauté",
    ],
    answer: "Citoyenneté européenne",
    explanation:
        "La citoyenneté européenne confère des droits politiques spécifiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel traité est à l’origine de la CEE en 1957 ?",
    options: ["Traité de Rome", "Traité de Maastricht", "Traité de Lisbonne"],
    answer: "Traité de Rome",
    explanation: "Il fonde la Communauté économique européenne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel mécanisme permet à un État de quitter l’Union européenne ?",
    options: ["Article 50 du TUE", "Article 16", "Article 49.3"],
    answer: "Article 50 du TUE",
    explanation: "Il encadre juridiquement la procédure de retrait.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe de l’UE approuve les accords internationaux ?",
    options: ["Parlement européen", "CJUE", "BCE"],
    answer: "Parlement européen",
    explanation: "Son approbation est requise pour de nombreux accords.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne adopte les lignes directrices économiques ?",
    options: ["Conseil européen", "Commission européenne", "Cour des comptes"],
    answer: "Conseil européen",
    explanation: "Il fixe les grandes orientations économiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe peut infliger des sanctions financières à un État membre ?",
    options: ["CJUE", "Parlement européen", "Comité des régions"],
    answer: "CJUE",
    explanation:
        "Elle peut condamner un État pour manquement au droit de l’UE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe impose aux États d’appliquer loyalement le droit de l’UE ?",
    options: ["Coopération loyale", "Neutralité", "Centralisation"],
    answer: "Coopération loyale",
    explanation: "Principe fondamental de l’intégration européenne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut être saisi par un citoyen via une pétition ?",
    options: ["Parlement européen", "CJUE", "BCE"],
    answer: "Parlement européen",
    explanation: "Les citoyens peuvent adresser des pétitions au Parlement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel texte constitue le socle des droits et obligations des agents publics ?",
    options: [
      "Statut général de la fonction publique",
      "Code civil",
      "Constitution européenne",
    ],
    answer: "Statut général de la fonction publique",
    explanation: "Il fixe droits, obligations et garanties des agents.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à un agent d’exprimer ses opinions en dehors du service ?",
    options: ["Liberté d’opinion", "Neutralité", "Secret professionnel"],
    answer: "Liberté d’opinion",
    explanation: "Elle est garantie sous réserve du respect des obligations.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose la continuité du service même en cas de grève ?",
    options: ["Service minimum", "Mutabilité", "Subsidiarité"],
    answer: "Service minimum",
    explanation:
        "Il garantit un fonctionnement essentiel de certains services.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel organisme protège les données personnelles des usagers et agents ?",
    options: ["CNIL", "HATVP", "CSA"],
    answer: "CNIL",
    explanation: "La Commission nationale de l’informatique et des libertés.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose à l’agent d’informer sa hiérarchie d’un conflit d’intérêts ?",
    options: ["Devoir de probité", "Droit de réserve", "Neutralité"],
    answer: "Devoir de probité",
    explanation: "Il vise à prévenir toute atteinte à l’impartialité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet aux agents de participer aux élections professionnelles ?",
    options: ["Droit de participation", "Droit de veto", "Droit d’asile"],
    answer: "Droit de participation",
    explanation: "Il permet la représentation des agents dans les instances.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose l’exécution consciencieuse des missions confiées ?",
    options: ["Devoir d’obéissance", "Liberté syndicale", "Droit de retrait"],
    answer: "Devoir d’obéissance",
    explanation: "Sous réserve de la légalité des ordres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel niveau territorial est compétent pour la gestion des ports et aéroports régionaux ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "Compétence régionale en matière de transports stratégiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel niveau territorial est chef de file de la politique sociale ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation: "Il gère RSA, aide sociale et protection de l’enfance.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité gère l’éclairage public ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation: "Compétence communale de proximité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel outil juridique permet à une collectivité de déléguer un service public ?",
    options: ["DSP", "QPC", "Référendum"],
    answer: "DSP",
    explanation: "Délégation de service public à un opérateur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel document financier fixe les recettes et dépenses d’une collectivité ?",
    options: ["Budget", "PLU", "Décret"],
    answer: "Budget",
    explanation: "Le budget est voté par l’organe délibérant.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel texte proclame que la France est une République indivisible, laïque, démocratique et sociale ?",
    options: [
      "Article 1 de la Constitution",
      "Code pénal",
      "Déclaration de 1791",
    ],
    answer: "Article 1 de la Constitution",
    explanation:
        "Il définit les caractéristiques fondamentales de la République.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole est gravé sur les frontons des mairies avec la devise républicaine ?",
    options: ["RF", "UE", "ONU"],
    answer: "RF",
    explanation: "RF signifie République française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel chant est entonné lors des cérémonies officielles ?",
    options: ["La Marseillaise", "L’Internationale", "Le Chant du départ"],
    answer: "La Marseillaise",
    explanation: "Hymne national officiel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe impose le respect de la hiérarchie des normes ?",
    options: [
      "Principe de légalité",
      "Principe de mutabilité",
      "Principe de neutralité",
    ],
    answer: "Principe de légalité",
    explanation:
        "Les normes inférieures doivent respecter les normes supérieures.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe garantit la protection des droits fondamentaux par le juge ?",
    options: ["État de droit", "Centralisation", "Autorité"],
    answer: "État de droit",
    explanation: "Les citoyens disposent de recours effectifs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe empêche la concentration excessive du pouvoir ?",
    options: ["Séparation des pouvoirs", "Primauté", "Subsidiarité"],
    answer: "Séparation des pouvoirs",
    explanation: "Principe théorisé par Montesquieu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel organe peut saisir le Conseil constitutionnel avant la promulgation d’une loi ?",
    options: ["Président de la République", "Maire", "Préfet"],
    answer: "Président de la République",
    explanation: "Avec d’autres autorités habilitées.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe garantit que les citoyens participent à la souveraineté nationale ?",
    options: ["Suffrage universel", "Centralisation", "Neutralité"],
    answer: "Suffrage universel",
    explanation: "Le peuple exerce sa souveraineté par le vote.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen adopte le cadre financier pluriannuel de l’UE ?",
    options: [
      "Conseil de l’Union européenne et Parlement européen",
      "Commission européenne seule",
      "CJUE",
    ],
    answer: "Conseil de l’Union européenne et Parlement européen",
    explanation:
        "Le budget à long terme est adopté conjointement par les deux institutions.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel document définit les valeurs fondamentales de l’Union européenne ?",
    options: [
      "Traité sur l’Union européenne",
      "Charte de l’ONU",
      "Traité de Rome",
    ],
    answer: "Traité sur l’Union européenne",
    explanation: "L’article 2 du TUE énonce les valeurs fondamentales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle valeur de l’UE inclut le respect des droits fondamentaux ?",
    options: ["Dignité humaine", "Neutralité économique", "Centralisation"],
    answer: "Dignité humaine",
    explanation: "Valeur fondamentale consacrée par les traités.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel mécanisme permet de sanctionner un État portant atteinte aux valeurs de l’UE ?",
    options: ["Article 7 du TUE", "Article 50", "Directive-cadre"],
    answer: "Article 7 du TUE",
    explanation: "Il peut conduire à une suspension de certains droits.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe européen est élu au suffrage universel direct ?",
    options: [
      "Parlement européen",
      "Commission européenne",
      "Conseil européen",
    ],
    answer: "Parlement européen",
    explanation: "Les députés européens sont élus par les citoyens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quelle est la durée du mandat des députés européens ?",
    options: ["5 ans", "6 ans", "7 ans"],
    answer: "5 ans",
    explanation: "Les élections européennes ont lieu tous les cinq ans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel État a quitté l’Union européenne en 2020 ?",
    options: ["Royaume-Uni", "Norvège", "Suisse"],
    answer: "Royaume-Uni",
    explanation: "Sortie officielle suite au Brexit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel espace permet la libre circulation sans contrôle aux frontières intérieures ?",
    options: ["Espace Schengen", "Zone euro", "Conseil de l’Europe"],
    answer: "Espace Schengen",
    explanation: "Il concerne la libre circulation des personnes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "La Suisse appartient-elle à l’Union européenne ?",
    options: ["Non", "Oui", "Partiellement"],
    answer: "Non",
    explanation: "Elle coopère avec l’UE sans en être membre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen est indépendant des gouvernements nationaux ?",
    options: ["BCE", "Conseil européen", "Conseil de l’UE"],
    answer: "BCE",
    explanation: "Indépendance garantie par les traités.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose la neutralité politique des agents publics ?",
    options: ["Neutralité", "Liberté syndicale", "Mutabilité"],
    answer: "Neutralité",
    explanation: "L’agent ne doit pas afficher ses opinions dans le service.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe protège l’égalité d’accès aux emplois publics ?",
    options: ["Égalité", "Continuité", "Centralisation"],
    answer: "Égalité",
    explanation: "Fondé sur le mérite et la compétence.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel concours permet l’accès à la majorité des emplois publics ?",
    options: ["Concours administratif", "Élection", "Nomination libre"],
    answer: "Concours administratif",
    explanation: "Principe de recrutement par concours.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à l’agent d’être informé de sa situation administrative ?",
    options: ["Droit à l’information", "Droit de veto", "Droit de censure"],
    answer: "Droit à l’information",
    explanation: "Garantie statutaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel devoir impose de servir avec dignité ?",
    options: ["Dignité", "Neutralité", "Mutabilité"],
    answer: "Dignité",
    explanation: "Comportement respectueux et exemplaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel manquement peut entraîner une sanction disciplinaire ?",
    options: ["Faute professionnelle", "Opinion privée", "Grève légale"],
    answer: "Faute professionnelle",
    explanation: "Toute violation des obligations.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel organisme représente les agents dans le dialogue social ?",
    options: ["Instances représentatives", "CJUE", "Préfecture"],
    answer: "Instances représentatives",
    explanation: "Comités sociaux d’administration.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité est compétente pour l’urbanisme local ?",
    options: ["Commune", "Région", "État"],
    answer: "Commune",
    explanation: "Compétence via le PLU.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité gère les routes départementales ?",
    options: ["Département", "Commune", "Région"],
    answer: "Département",
    explanation: "Compétence départementale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité gère la formation professionnelle ?",
    options: ["Région", "Commune", "Département"],
    answer: "Région",
    explanation: "Compétence régionale stratégique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel acte permet au préfet de contester un acte local illégal ?",
    options: ["Déféré préfectoral", "Motion de censure", "QPC"],
    answer: "Déféré préfectoral",
    explanation: "Saisine du juge administratif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel symbole figure sur les pièces en euros françaises ?",
    options: ["Marianne", "Napoléon", "Charlemagne"],
    answer: "Marianne",
    explanation: "Symbole de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quelle fête commémore la fin de la Seconde Guerre mondiale en Europe ?",
    options: ["8 mai", "11 novembre", "14 juillet"],
    answer: "8 mai",
    explanation: "Victoire de 1945.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel monument abrite la tombe du Soldat inconnu ?",
    options: ["Arc de Triomphe", "Panthéon", "Invalides"],
    answer: "Arc de Triomphe",
    explanation: "Lieu majeur de mémoire nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe garantit la liberté de conscience ?",
    options: ["Laïcité", "Centralisation", "Primauté"],
    answer: "Laïcité",
    explanation: "Neutralité religieuse de l’État.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe garantit la participation des citoyens par le vote ?",
    options: ["Souveraineté nationale", "Mutabilité", "Autorité"],
    answer: "Souveraineté nationale",
    explanation: "Exercée par les représentants et le référendum.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe protège contre l’arbitraire administratif ?",
    options: ["État de droit", "Centralisation", "Secret d’État"],
    answer: "État de droit",
    explanation: "Existence de recours juridictionnels.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe impose que la loi s’applique à tous ?",
    options: ["Égalité devant la loi", "Neutralité", "Proportionnalité"],
    answer: "Égalité devant la loi",
    explanation: "Principe fondamental républicain.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe européen propose les textes législatifs ?",
    options: [
      "Commission européenne",
      "Parlement européen",
      "Conseil européen",
    ],
    answer: "Commission européenne",
    explanation:
        "La Commission détient le monopole de l’initiative législative.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe représente les États membres au niveau ministériel ?",
    options: [
      "Conseil de l’Union européenne",
      "Conseil européen",
      "Parlement européen",
    ],
    answer: "Conseil de l’Union européenne",
    explanation: "Il réunit les ministres selon les domaines concernés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen définit les grandes orientations politiques ?",
    options: ["Conseil européen", "Commission européenne", "CJUE"],
    answer: "Conseil européen",
    explanation: "Il rassemble les chefs d’État et de gouvernement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle juridiction garantit l’interprétation uniforme du droit de l’UE ?",
    options: ["CJUE", "Cour des comptes", "CEDH"],
    answer: "CJUE",
    explanation: "Elle assure l’application uniforme du droit européen.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe affirme la supériorité du droit européen sur le droit national ?",
    options: ["Primauté du droit de l’UE", "Subsidiarité", "Neutralité"],
    answer: "Primauté du droit de l’UE",
    explanation: "Principe dégagé par la jurisprudence.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel principe impose d’agir au niveau le plus efficace ?",
    options: ["Subsidiarité", "Centralisation", "Primauté"],
    answer: "Subsidiarité",
    explanation: "L’UE n’agit que si l’action est plus efficace à son niveau.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel pays ne fait pas partie de la zone euro ?",
    options: ["Suède", "Espagne", "Italie"],
    answer: "Suède",
    explanation: "La Suède est membre de l’UE mais pas de la zone euro.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel symbole figure sur le drapeau européen ?",
    options: ["12 étoiles", "15 étoiles", "27 étoiles"],
    answer: "12 étoiles",
    explanation: "Elles symbolisent l’unité et la perfection.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quelle monnaie est utilisée par la majorité des États membres ?",
    options: ["Euro", "Dollar", "Franc"],
    answer: "Euro",
    explanation: "Monnaie commune de la zone euro.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quelle agence européenne veille à la sécurité aérienne ?",
    options: ["EASA", "Europol", "Eurostat"],
    answer: "EASA",
    explanation: "Agence européenne de la sécurité aérienne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe impose l’adaptation continue du service public ?",
    options: ["Mutabilité", "Neutralité", "Égalité"],
    answer: "Mutabilité",
    explanation: "Le service public doit évoluer avec les besoins.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe garantit l’accès égal aux services publics ?",
    options: ["Égalité", "Continuité", "Mutabilité"],
    answer: "Égalité",
    explanation: "Absence de discrimination entre usagers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe impose un fonctionnement sans interruption ?",
    options: ["Continuité", "Neutralité", "Subsidiarité"],
    answer: "Continuité",
    explanation: "Principe fondamental du service public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à un agent de cesser le travail collectivement ?",
    options: ["Droit de grève", "Droit de retrait", "Droit de réserve"],
    answer: "Droit de grève",
    explanation: "Reconnu mais encadré dans la fonction publique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel devoir limite l’expression publique de l’agent ?",
    options: ["Devoir de réserve", "Droit syndical", "Liberté d’opinion"],
    answer: "Devoir de réserve",
    explanation: "Obligation de modération dans l’expression.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel type de sanction peut être prononcé pour faute grave ?",
    options: ["Révocation", "Avertissement", "Mutation"],
    answer: "Révocation",
    explanation: "Sanction disciplinaire la plus grave.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel organe statue sur les litiges entre agent et administration ?",
    options: [
      "Tribunal administratif",
      "Cour d’assises",
      "Conseil constitutionnel",
    ],
    answer: "Tribunal administratif",
    explanation: "Juridiction du contentieux administratif.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité est compétente pour les collèges ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation: "Gestion des collèges publics.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité gère les lycées ?",
    options: ["Région", "Département", "État"],
    answer: "Région",
    explanation: "Compétence régionale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel document fixe les règles d’urbanisme local ?",
    options: ["PLU", "PADD", "SCOT"],
    answer: "PLU",
    explanation: "Plan local d’urbanisme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Qui préside le conseil municipal ?",
    options: ["Le maire", "Le préfet", "Le président du département"],
    answer: "Le maire",
    explanation: "Autorité exécutive communale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Qui représente l’État dans le département ?",
    options: ["Le préfet", "Le maire", "Le président de région"],
    answer: "Le préfet",
    explanation: "Représentant de l’État.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle devise est inscrite sur les bâtiments publics ?",
    options: [
      "Liberté, Égalité, Fraternité",
      "Unité, Travail, Ordre",
      "Paix, Justice, Loi",
    ],
    answer: "Liberté, Égalité, Fraternité",
    explanation: "Devise officielle de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel personnage allégorique représente la République ?",
    options: ["Marianne", "Jeanne d’Arc", "Athéna"],
    answer: "Marianne",
    explanation: "Symbole de la République française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle date correspond à la fête nationale française ?",
    options: ["14 juillet", "11 novembre", "8 mai"],
    answer: "14 juillet",
    explanation: "Commémoration de la prise de la Bastille.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel texte fondateur proclame les droits naturels de l’homme ?",
    options: ["DDHC 1789", "Constitution de 1958", "Code civil"],
    answer: "DDHC 1789",
    explanation: "Déclaration des Droits de l’Homme et du Citoyen.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe interdit les discriminations ?",
    options: ["Égalité", "Laïcité", "Neutralité"],
    answer: "Égalité",
    explanation: "Principe fondamental constitutionnel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe garantit la liberté religieuse ?",
    options: ["Laïcité", "Centralisation", "Autorité"],
    answer: "Laïcité",
    explanation: "Neutralité de l’État vis-à-vis des cultes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel organe contrôle la constitutionnalité des lois ?",
    options: ["Conseil constitutionnel", "Conseil d’État", "Cour de cassation"],
    answer: "Conseil constitutionnel",
    explanation: "Gardien de la Constitution.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen contrôle la bonne utilisation des fonds de l’Union ?",
    options: ["Cour des comptes européenne", "CJUE", "Commission européenne"],
    answer: "Cour des comptes européenne",
    explanation: "Elle contrôle la légalité et la régularité des dépenses.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne peut proposer une révision des traités ?",
    options: ["Commission européenne", "Parlement européen", "BCE"],
    answer: "Commission européenne",
    explanation: "Elle peut formuler des propositions de modification.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen représente les collectivités territoriales ?",
    options: ["Comité des régions", "Conseil européen", "Parlement européen"],
    answer: "Comité des régions",
    explanation: "Il donne des avis consultatifs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe représente les partenaires sociaux au niveau européen ?",
    options: ["Comité économique et social européen", "Eurogroupe", "Europol"],
    answer: "Comité économique et social européen",
    explanation: "Il représente employeurs, salariés et société civile.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe réunit les ministres des Finances de la zone euro ?",
    options: ["Eurogroupe", "Conseil européen", "BCE"],
    answer: "Eurogroupe",
    explanation: "Instance informelle de coordination économique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe permet aux parlements nationaux de contrôler l’action de l’UE ?",
    options: ["Subsidiarité", "Primauté", "Neutralité"],
    answer: "Subsidiarité",
    explanation: "Ils peuvent émettre des avis motivés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel droit permet à un citoyen de saisir le Médiateur européen ?",
    options: ["Droit de pétition", "Droit de grève", "Droit d’initiative"],
    answer: "Droit de pétition",
    explanation: "En cas de mauvaise administration.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quelle langue n’est pas langue officielle de l’UE ?",
    options: ["Norvégien", "Espagnol", "Allemand"],
    answer: "Norvégien",
    explanation: "La Norvège n’est pas membre de l’UE.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel budget représente environ 1 % du PIB européen ?",
    options: [
      "Budget de l’UE",
      "Budget de la BCE",
      "Budget du Conseil de l’Europe",
    ],
    answer: "Budget de l’UE",
    explanation: "Budget limité par rapport aux budgets nationaux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut déclencher une procédure d’infraction ?",
    options: ["Commission européenne", "CJUE", "Parlement européen"],
    answer: "Commission européenne",
    explanation: "Gardienne des traités.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose l’adaptabilité des missions du service public ?",
    options: ["Mutabilité", "Neutralité", "Égalité"],
    answer: "Mutabilité",
    explanation: "Adaptation constante aux besoins.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe interdit toute discrimination entre usagers ?",
    options: ["Égalité", "Continuité", "Neutralité"],
    answer: "Égalité",
    explanation: "Principe fondamental du service public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe garantit un fonctionnement sans interruption ?",
    options: ["Continuité", "Mutabilité", "Subsidiarité"],
    answer: "Continuité",
    explanation: "Service public permanent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir interdit à l’agent de tirer un avantage personnel de sa fonction ?",
    options: ["Probité", "Neutralité", "Réserve"],
    answer: "Probité",
    explanation: "Prévention de la corruption.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose la discrétion sur les informations connues dans le service ?",
    options: ["Secret professionnel", "Liberté d’expression", "Droit syndical"],
    answer: "Secret professionnel",
    explanation: "Obligation statutaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel devoir impose de respecter la hiérarchie administrative ?",
    options: ["Obéissance hiérarchique", "Neutralité", "Dignité"],
    answer: "Obéissance hiérarchique",
    explanation: "Sous réserve de la légalité des ordres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à l’agent d’alerter sur un danger grave et imminent ?",
    options: ["Droit de retrait", "Droit de grève", "Droit de réserve"],
    answer: "Droit de retrait",
    explanation: "Protection de la santé et de la sécurité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel juge est compétent pour les litiges disciplinaires ?",
    options: [
      "Juge administratif",
      "Juge judiciaire",
      "Conseil constitutionnel",
    ],
    answer: "Juge administratif",
    explanation: "Contentieux de la fonction publique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité est compétente pour l’aide sociale ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation: "Chef de file de l’action sociale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est compétente pour le développement économique ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "Chef de file économique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel organe délibérant vote le budget communal ?",
    options: ["Conseil municipal", "Maire", "Préfet"],
    answer: "Conseil municipal",
    explanation: "Organe délibérant de la commune.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel acte administratif local peut être annulé par le juge ?",
    options: ["Arrêté", "Décret", "Loi"],
    answer: "Arrêté",
    explanation: "Contrôle de légalité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel principe garantit l’autonomie des collectivités ?",
    options: ["Libre administration", "Centralisation", "Subordination"],
    answer: "Libre administration",
    explanation: "Principe constitutionnel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole républicain est représenté par une femme coiffée d’un bonnet phrygien ?",
    options: ["Marianne", "Athéna", "Jeanne d’Arc"],
    answer: "Marianne",
    explanation: "Allégorie de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle couleur ne figure pas sur le drapeau français ?",
    options: ["Vert", "Bleu", "Rouge"],
    answer: "Vert",
    explanation: "Le drapeau est bleu, blanc, rouge.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel texte est lu lors de certaines cérémonies républicaines ?",
    options: ["DDHC", "Code pénal", "Code du travail"],
    answer: "DDHC",
    explanation: "Déclaration de 1789.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe empêche la concentration du pouvoir politique ?",
    options: ["Séparation des pouvoirs", "Centralisation", "Primauté"],
    answer: "Séparation des pouvoirs",
    explanation: "Principe théorisé par Montesquieu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe protège les libertés individuelles par le contrôle du juge ?",
    options: ["État de droit", "Autorité", "Subordination"],
    answer: "État de droit",
    explanation: "Soumission du pouvoir à la loi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe garantit la participation des citoyens à la vie politique ?",
    options: ["Suffrage universel", "Neutralité", "Centralisation"],
    answer: "Suffrage universel",
    explanation: "Base de la démocratie représentative.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen est qualifié de « gardienne des traités » ?",
    options: ["Commission européenne", "CJUE", "Conseil européen"],
    answer: "Commission européenne",
    explanation: "Elle veille à l’application correcte du droit de l’UE.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel vote est requis pour adopter une directive européenne ?",
    options: ["Majorité qualifiée", "Unanimité", "Majorité simple"],
    answer: "Majorité qualifiée",
    explanation: "Règle principale au Conseil de l’UE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne ne possède aucun pouvoir législatif ?",
    options: ["BCE", "Parlement européen", "Conseil de l’UE"],
    answer: "BCE",
    explanation: "Elle conduit la politique monétaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe adopte les sanctions économiques de l’UE ?",
    options: ["Conseil de l’Union européenne", "Commission européenne", "CJUE"],
    answer: "Conseil de l’Union européenne",
    explanation: "Il agit sur proposition de la Commission.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel principe impose que l’UE n’excède pas ses compétences ?",
    options: ["Principe de proportionnalité", "Primauté", "Neutralité"],
    answer: "Principe de proportionnalité",
    explanation: "Action limitée à ce qui est nécessaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen adopte les accords commerciaux internationaux ?",
    options: ["Conseil de l’UE", "Parlement européen", "BCE"],
    answer: "Conseil de l’UE",
    explanation: "Après approbation du Parlement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel État a rejoint l’UE en dernier avant 2020 ?",
    options: ["Croatie", "Bulgarie", "Roumanie"],
    answer: "Croatie",
    explanation: "Adhésion en 2013.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe peut suspendre le droit de vote d’un État membre ?",
    options: ["Conseil européen", "Commission européenne", "CJUE"],
    answer: "Conseil européen",
    explanation: "Dans le cadre de l’article 7 du TUE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel mécanisme permet aux citoyens de proposer une loi européenne ?",
    options: [
      "Initiative citoyenne européenne",
      "Référendum européen",
      "Pétition simple",
    ],
    answer: "Initiative citoyenne européenne",
    explanation: "1 million de signatures nécessaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution valide la nomination du président de la Commission ?",
    options: ["Parlement européen", "Conseil européen", "CJUE"],
    answer: "Parlement européen",
    explanation: "Vote à la majorité des députés.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe interdit toute distinction entre usagers du service public ?",
    options: ["Égalité", "Neutralité", "Mutabilité"],
    answer: "Égalité",
    explanation: "Principe fondamental du service public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe impose la continuité même en cas de crise ?",
    options: ["Continuité", "Subsidiarité", "Proportionnalité"],
    answer: "Continuité",
    explanation: "Fonctionnement permanent du service public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir interdit l’agent d’utiliser ses fonctions à des fins privées ?",
    options: ["Probité", "Neutralité", "Réserve"],
    answer: "Probité",
    explanation: "Prévention des conflits d’intérêts.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à l’agent de se défendre en cas de poursuites ?",
    options: ["Protection fonctionnelle", "Droit syndical", "Droit de grève"],
    answer: "Protection fonctionnelle",
    explanation: "Protection juridique par l’administration.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel organe conseille l’administration sur la légalité des actes ?",
    options: ["Conseil d’État", "Cour de cassation", "Conseil constitutionnel"],
    answer: "Conseil d’État",
    explanation: "Plus haute juridiction administrative.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel manquement peut entraîner une sanction disciplinaire ?",
    options: [
      "Faute professionnelle",
      "Opinion personnelle",
      "Adhésion syndicale",
    ],
    answer: "Faute professionnelle",
    explanation: "Violation des obligations statutaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est responsable de la gestion des collèges ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation: "Compétence éducative départementale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité est compétente pour les lycées ?",
    options: ["Région", "État", "Commune"],
    answer: "Région",
    explanation: "Gestion des lycées publics.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel représentant de l’État exerce le contrôle de légalité ?",
    options: ["Préfet", "Maire", "Président de région"],
    answer: "Préfet",
    explanation: "Représentant de l’État dans les territoires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel acte permet au préfet de saisir le juge administratif ?",
    options: ["Déféré préfectoral", "Arrêté", "Décret"],
    answer: "Déféré préfectoral",
    explanation: "Contrôle juridictionnel des actes locaux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel texte fonde juridiquement la citoyenneté française moderne ?",
    options: [
      "Déclaration des droits de l’Homme et du citoyen",
      "Code pénal",
      "Constitution de 1946",
    ],
    answer: "Déclaration des droits de l’Homme et du citoyen",
    explanation: "Texte fondamental de 1789.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle fête nationale célèbre la République française ?",
    options: ["14 juillet", "11 novembre", "8 mai"],
    answer: "14 juillet",
    explanation: "Commémoration de la prise de la Bastille.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel symbole figure sur le sceau officiel de l’État français ?",
    options: ["Marianne", "Coq", "Bonnet phrygien seul"],
    answer: "Marianne",
    explanation: "Allégorie de la République.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe garantit que la loi s’impose à tous, gouvernants compris ?",
    options: ["État de droit", "Autorité", "Centralisation"],
    answer: "État de droit",
    explanation: "Soumission du pouvoir à la loi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe garantit l’indépendance des juges ?",
    options: ["Séparation des pouvoirs", "Primauté", "Neutralité"],
    answer: "Séparation des pouvoirs",
    explanation: "Principe fondamental démocratique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe fonde la légitimité des représentants élus ?",
    options: [
      "Suffrage universel",
      "Autorité administrative",
      "Centralisation",
    ],
    answer: "Suffrage universel",
    explanation: "Expression directe de la souveraineté nationale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen adopte les règlements et directives avec le Parlement européen ?",
    options: [
      "Conseil de l’Union européenne",
      "Conseil européen",
      "Commission européenne",
    ],
    answer: "Conseil de l’Union européenne",
    explanation: "Il partage le pouvoir législatif avec le Parlement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne n’est pas mentionnée dans les traités fondateurs mais résulte de la pratique ?",
    options: ["Eurogroupe", "Commission européenne", "CJUE"],
    answer: "Eurogroupe",
    explanation:
        "Instance informelle des ministres des Finances de la zone euro.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle juridiction européenne juge les litiges entre l’UE et ses agents ?",
    options: ["Tribunal de l’Union européenne", "CJUE", "Cour des comptes"],
    answer: "Tribunal de l’Union européenne",
    explanation: "Compétent en matière de contentieux administratif européen.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel acte juridique européen est directement applicable dans les États membres ?",
    options: ["Règlement", "Directive", "Recommandation"],
    answer: "Règlement",
    explanation: "Il s’applique sans transposition nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel acte européen fixe un objectif à atteindre mais laisse le choix des moyens ?",
    options: ["Directive", "Règlement", "Décision"],
    answer: "Directive",
    explanation: "Elle nécessite une transposition nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut adresser des recommandations sans force contraignante ?",
    options: ["Commission européenne", "CJUE", "BCE"],
    answer: "Commission européenne",
    explanation: "Les recommandations n’ont pas de valeur obligatoire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel pays fondateur ne fait pas partie de la zone euro ?",
    options: ["Danemark", "Italie", "Belgique"],
    answer: "Danemark",
    explanation: "Il dispose d’une clause d’exemption.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle capitale accueille le siège de la Commission européenne ?",
    options: ["Bruxelles", "Strasbourg", "Luxembourg"],
    answer: "Bruxelles",
    explanation: "Bruxelles est le principal centre institutionnel de l’UE.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen est présidé par un président élu pour 2 ans et demi ?",
    options: [
      "Conseil européen",
      "Parlement européen",
      "Commission européenne",
    ],
    answer: "Conseil européen",
    explanation: "Le président assure la continuité des travaux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quelle institution européenne n’exerce qu’un rôle consultatif ?",
    options: ["Comité des régions", "Parlement européen", "Conseil de l’UE"],
    answer: "Comité des régions",
    explanation: "Il représente les collectivités territoriales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose à l’administration de s’adapter aux évolutions sociales ?",
    options: ["Mutabilité", "Neutralité", "Égalité"],
    answer: "Mutabilité",
    explanation: "Principe d’adaptation du service public.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit garantit la défense de l’agent devant une commission disciplinaire ?",
    options: ["Droits de la défense", "Droit syndical", "Droit de retrait"],
    answer: "Droits de la défense",
    explanation: "Principe général du droit.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose une attitude respectueuse envers les usagers ?",
    options: ["Dignité", "Neutralité", "Obéissance"],
    answer: "Dignité",
    explanation: "Comportement exemplaire exigé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à l’agent de contester une sanction disciplinaire ?",
    options: [
      "Recours administratif",
      "Droit de veto",
      "Protection fonctionnelle",
    ],
    answer: "Recours administratif",
    explanation: "Devant le juge administratif.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe interdit toute prise illégale d’intérêts ?",
    options: ["Probité", "Neutralité", "Continuité"],
    answer: "Probité",
    explanation: "Principe essentiel de l’éthique publique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est compétente pour la gestion de l’eau potable ?",
    options: ["Commune", "Région", "État"],
    answer: "Commune",
    explanation: "Compétence communale ou intercommunale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité est responsable des transports scolaires ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "Compétence régionale depuis la loi NOTRe.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel document encadre la coopération intercommunale ?",
    options: [
      "Schéma départemental de coopération intercommunale",
      "PLU",
      "Décret préfectoral",
    ],
    answer: "Schéma départemental de coopération intercommunale",
    explanation: "Il organise l’intercommunalité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel organe exécute les décisions du conseil départemental ?",
    options: [
      "Président du conseil départemental",
      "Préfet",
      "Conseil régional",
    ],
    answer: "Président du conseil départemental",
    explanation: "Autorité exécutive du département.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole républicain est présent dans toutes les salles d’audience ?",
    options: ["La devise républicaine", "Le drapeau européen", "Le coq"],
    answer: "La devise républicaine",
    explanation: "Liberté, Égalité, Fraternité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole républicain est utilisé lors des investitures présidentielles ?",
    options: ["Constitution", "Drapeau européen", "Code civil"],
    answer: "Constitution",
    explanation: "Le Président jure de la respecter.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe garantit que l’administration agit conformément à la loi ?",
    options: [
      "Principe de légalité",
      "Principe d’autorité",
      "Principe de neutralité",
    ],
    answer: "Principe de légalité",
    explanation: "Fondement du droit administratif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe garantit l’indépendance de l’autorité judiciaire ?",
    options: ["Séparation des pouvoirs", "Centralisation", "Primauté"],
    answer: "Séparation des pouvoirs",
    explanation: "Garantie démocratique essentielle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe permet au citoyen de contester une loi déjà en vigueur ?",
    options: ["QPC", "Référendum", "Motion de censure"],
    answer: "QPC",
    explanation: "Question prioritaire de constitutionnalité.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen adopte le budget annuel de l’Union avec le Parlement ?",
    options: [
      "Conseil de l’Union européenne",
      "Commission européenne",
      "Conseil européen",
    ],
    answer: "Conseil de l’Union européenne",
    explanation:
        "Le budget est adopté conjointement par le Conseil et le Parlement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen assure la présidence tournante tous les six mois ?",
    options: [
      "Conseil de l’Union européenne",
      "Conseil européen",
      "Parlement européen",
    ],
    answer: "Conseil de l’Union européenne",
    explanation:
        "La présidence est exercée successivement par les États membres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne ne peut pas proposer directement une loi ?",
    options: ["Parlement européen", "Commission européenne", "Conseil de l’UE"],
    answer: "Parlement européen",
    explanation: "Il peut demander à la Commission de proposer un texte.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe européen peut censurer la Commission ?",
    options: ["Parlement européen", "CJUE", "Conseil européen"],
    answer: "Parlement européen",
    explanation: "La motion de censure entraîne la démission de la Commission.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe permet aux États de conserver leurs compétences non transférées à l’UE ?",
    options: ["Principe de compétence d’attribution", "Primauté", "Solidarité"],
    answer: "Principe de compétence d’attribution",
    explanation:
        "L’UE n’agit que dans les compétences qui lui sont attribuées.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen publie le Journal officiel de l’Union européenne ?",
    options: [
      "Office des publications de l’UE",
      "Commission européenne",
      "CJUE",
    ],
    answer: "Office des publications de l’UE",
    explanation: "Il diffuse les actes juridiques européens.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quelle ville accueille principalement le Parlement européen ?",
    options: ["Strasbourg", "Bruxelles", "Luxembourg"],
    answer: "Strasbourg",
    explanation: "Les sessions plénières s’y tiennent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel pays membre de l’UE n’utilise pas l’alphabet latin comme alphabet principal ?",
    options: ["Grèce", "Italie", "Portugal"],
    answer: "Grèce",
    explanation: "La Grèce utilise l’alphabet grec.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut engager un recours en manquement contre un État ?",
    options: ["Commission européenne", "Parlement européen", "BCE"],
    answer: "Commission européenne",
    explanation: "Elle saisit ensuite la CJUE.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe impose que les actions de l’UE soient nécessaires et adaptées ?",
    options: ["Proportionnalité", "Subsidiarité", "Primauté"],
    answer: "Proportionnalité",
    explanation: "Principe fondamental du droit de l’UE.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe impose un accueil identique de tous les usagers ?",
    options: ["Égalité", "Neutralité", "Mutabilité"],
    answer: "Égalité",
    explanation: "Aucune discrimination n’est admise.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe impose la permanence du service public ?",
    options: ["Continuité", "Subsidiarité", "Centralisation"],
    answer: "Continuité",
    explanation: "Le service public doit fonctionner sans interruption.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe impose la neutralité religieuse de l’agent ?",
    options: ["Neutralité", "Liberté d’expression", "Dignité"],
    answer: "Neutralité",
    explanation: "L’agent ne manifeste pas ses convictions religieuses.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit protège l’agent poursuivi pour des faits liés au service ?",
    options: ["Protection fonctionnelle", "Droit syndical", "Droit de retrait"],
    answer: "Protection fonctionnelle",
    explanation: "L’administration prend en charge la défense.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel devoir interdit la diffusion d’informations internes ?",
    options: ["Secret professionnel", "Droit de réserve", "Neutralité"],
    answer: "Secret professionnel",
    explanation: "Obligation pénalement sanctionnée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel organe statue en appel des décisions des tribunaux administratifs ?",
    options: [
      "Cour administrative d’appel",
      "Conseil constitutionnel",
      "Cour de cassation",
    ],
    answer: "Cour administrative d’appel",
    explanation: "Juridiction d’appel en droit administratif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est compétente pour la gestion des bibliothèques municipales ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation: "Compétence culturelle communale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité gère les musées départementaux ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation: "Compétence culturelle départementale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel organe vote les délibérations régionales ?",
    options: ["Conseil régional", "Président de région", "Préfet"],
    answer: "Conseil régional",
    explanation: "Organe délibérant de la région.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel document fixe les orientations budgétaires locales ?",
    options: ["Débat d’orientations budgétaires", "PLU", "Arrêté préfectoral"],
    answer: "Débat d’orientations budgétaires",
    explanation: "Étape préalable au vote du budget.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole républicain est présent dans les écoles publiques ?",
    options: ["La devise républicaine", "Le drapeau européen", "Le coq"],
    answer: "La devise républicaine",
    explanation: "Affichage obligatoire dans les établissements.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel texte est souvent affiché dans les lieux publics depuis 2016 ?",
    options: ["Charte de la laïcité", "Code civil", "Constitution de 1946"],
    answer: "Charte de la laïcité",
    explanation: "Elle rappelle les principes républicains.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe impose que l’administration respecte les décisions de justice ?",
    options: [
      "Principe de légalité",
      "Principe d’autorité",
      "Principe de neutralité",
    ],
    answer: "Principe de légalité",
    explanation: "Soumission de l’administration au droit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe garantit la pluralité des opinions politiques ?",
    options: ["Pluralisme", "Centralisation", "Autorité"],
    answer: "Pluralisme",
    explanation: "Principe reconnu par le Conseil constitutionnel.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe interdit les lois rétroactives pénales plus sévères ?",
    options: ["Non-rétroactivité", "Primauté", "Subsidiarité"],
    answer: "Non-rétroactivité",
    explanation: "Principe fondamental du droit pénal.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quelle institution européenne adopte les actes délégués ?",
    options: ["Commission européenne", "Conseil de l’UE", "Parlement européen"],
    answer: "Commission européenne",
    explanation:
        "Les actes délégués complètent ou modifient des éléments non essentiels d’un acte législatif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe européen peut retirer un acte délégué ?",
    options: ["Parlement européen et Conseil de l’UE", "CJUE", "BCE"],
    answer: "Parlement européen et Conseil de l’UE",
    explanation: "Ils disposent d’un droit d’opposition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe fixe l’agenda stratégique de l’Union ?",
    options: [
      "Conseil européen",
      "Commission européenne",
      "Parlement européen",
    ],
    answer: "Conseil européen",
    explanation: "Il définit les priorités politiques à long terme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne assure la médiation entre citoyens et administration ?",
    options: ["Médiateur européen", "CJUE", "Cour des comptes"],
    answer: "Médiateur européen",
    explanation: "Il traite les cas de mauvaise administration.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe européen publie les appels d’offres de l’UE ?",
    options: ["TED", "Eurostat", "OLAF"],
    answer: "TED",
    explanation: "Tenders Electronic Daily, version en ligne du JOUE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel traité a introduit la citoyenneté européenne ?",
    options: ["Traité de Maastricht", "Traité de Rome", "Traité de Nice"],
    answer: "Traité de Maastricht",
    explanation: "Entré en vigueur en 1993.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne représente l’UE à l’international ?",
    options: [
      "Service européen pour l’action extérieure",
      "Conseil de l’UE",
      "Parlement européen",
    ],
    answer: "Service européen pour l’action extérieure",
    explanation: "Il soutient le Haut représentant.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe européen est basé principalement à Luxembourg ?",
    options: ["CJUE", "Parlement européen", "Commission européenne"],
    answer: "CJUE",
    explanation: "La Cour de justice y siège.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel document européen fixe les grandes orientations climatiques ?",
    options: ["Pacte vert européen", "Traité de Rome", "Livre blanc"],
    answer: "Pacte vert européen",
    explanation: "Stratégie pour la neutralité carbone.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe impose une solidarité entre États membres en cas de crise ?",
    options: ["Solidarité", "Primauté", "Proportionnalité"],
    answer: "Solidarité",
    explanation: "Principe inscrit dans les traités.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose que le service public évolue avec les besoins des usagers ?",
    options: ["Mutabilité", "Continuité", "Neutralité"],
    answer: "Mutabilité",
    explanation: "Principe jurisprudentiel du service public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à l’agent de bénéficier d’une formation professionnelle ?",
    options: ["Droit à la formation", "Droit de réserve", "Droit de grève"],
    answer: "Droit à la formation",
    explanation: "Garanti par le statut général.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose à l’agent d’exécuter les missions confiées avec sérieux ?",
    options: ["Obligation de service", "Neutralité", "Probité"],
    answer: "Obligation de service",
    explanation: "Devoir fondamental du fonctionnaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit protège l’agent victime de menaces dans l’exercice de ses fonctions ?",
    options: ["Protection fonctionnelle", "Droit syndical", "Droit de retrait"],
    answer: "Protection fonctionnelle",
    explanation: "Prise en charge par l’administration.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe interdit toute discrimination dans la carrière ?",
    options: ["Égalité", "Neutralité", "Continuité"],
    answer: "Égalité",
    explanation: "Principe constitutionnel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel organe émet des avis sur les carrières des agents ?",
    options: [
      "Commission administrative paritaire",
      "Conseil constitutionnel",
      "CNIL",
    ],
    answer: "Commission administrative paritaire",
    explanation: "Instance de dialogue social.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est compétente pour la gestion des ports de plaisance ?",
    options: ["Commune", "Département", "État"],
    answer: "Commune",
    explanation: "Compétence locale ou intercommunale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est chef de file pour la transition écologique ?",
    options: ["Région", "Commune", "Département"],
    answer: "Région",
    explanation: "Coordination des politiques environnementales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel organe adopte les arrêtés municipaux ?",
    options: ["Maire", "Conseil municipal", "Préfet"],
    answer: "Maire",
    explanation: "Autorité exécutive de la commune.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel document fixe les orientations stratégiques régionales ?",
    options: ["SRADDET", "PLU", "PADD"],
    answer: "SRADDET",
    explanation:
        "Schéma régional d’aménagement, de développement durable et d’égalité des territoires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole est présent dans la salle du Conseil constitutionnel ?",
    options: ["La Constitution", "Le drapeau européen", "Le coq"],
    answer: "La Constitution",
    explanation: "Texte fondamental de la République.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole républicain est chanté lors des commémorations nationales ?",
    options: ["La Marseillaise", "Le Chant du départ", "L’Internationale"],
    answer: "La Marseillaise",
    explanation: "Hymne national officiel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole est associé à la liberté dans l’iconographie républicaine ?",
    options: ["Bonnet phrygien", "Épée", "Balance"],
    answer: "Bonnet phrygien",
    explanation: "Symbole hérité de la Révolution française.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe impose la conformité des actes administratifs à la loi ?",
    options: [
      "Principe de légalité",
      "Principe de neutralité",
      "Principe d’autorité",
    ],
    answer: "Principe de légalité",
    explanation: "Fondement du droit administratif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe garantit l’indépendance des médias ?",
    options: ["Pluralisme", "Centralisation", "Autorité"],
    answer: "Pluralisme",
    explanation: "Principe reconnu par le Conseil constitutionnel.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe protège les libertés publiques contre l’arbitraire ?",
    options: ["État de droit", "Primauté", "Subsidiarité"],
    answer: "État de droit",
    explanation: "Soumission du pouvoir à la loi et au juge.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut adopter des décisions individuelles contraignantes ?",
    options: [
      "Commission européenne",
      "Parlement européen",
      "Comité des régions",
    ],
    answer: "Commission européenne",
    explanation: "Les décisions peuvent viser un État ou une entreprise.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel instrument juridique européen n’a aucune valeur contraignante ?",
    options: ["Avis", "Règlement", "Décision"],
    answer: "Avis",
    explanation: "Les avis et recommandations n’ont pas de force obligatoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe européen statue sur les recours en annulation ?",
    options: ["CJUE", "Parlement européen", "Cour des comptes"],
    answer: "CJUE",
    explanation: "Elle contrôle la légalité des actes de l’UE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe européen élabore le projet de budget annuel ?",
    options: ["Commission européenne", "Conseil de l’UE", "Parlement européen"],
    answer: "Commission européenne",
    explanation: "Elle soumet le projet aux autorités budgétaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne n’intervient pas dans la procédure législative ordinaire ?",
    options: [
      "Cour des comptes européenne",
      "Parlement européen",
      "Conseil de l’UE",
    ],
    answer: "Cour des comptes européenne",
    explanation: "Elle exerce une mission de contrôle financier.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel État membre possède la plus grande population dans l’UE ?",
    options: ["Allemagne", "France", "Italie"],
    answer: "Allemagne",
    explanation: "Elle est l’État le plus peuplé de l’Union.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen adopte les positions communes en politique étrangère ?",
    options: [
      "Conseil de l’Union européenne",
      "Parlement européen",
      "Commission européenne",
    ],
    answer: "Conseil de l’Union européenne",
    explanation: "Dans le cadre de la PESC.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel représentant incarne la politique étrangère de l’UE ?",
    options: [
      "Haut représentant de l’Union",
      "Président de la Commission",
      "Président du Parlement",
    ],
    answer: "Haut représentant de l’Union",
    explanation: "Il est aussi vice-président de la Commission.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen contrôle la légalité des dépenses de l’UE ?",
    options: ["Cour des comptes européenne", "OLAF", "Eurostat"],
    answer: "Cour des comptes européenne",
    explanation: "Elle publie un rapport annuel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel traité a renforcé les pouvoirs du Parlement européen ?",
    options: ["Traité de Lisbonne", "Traité de Rome", "Traité de Nice"],
    answer: "Traité de Lisbonne",
    explanation: "Il généralise la codécision.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose à l’administration d’agir dans l’intérêt général ?",
    options: [
      "Principe de neutralité",
      "Principe d’intérêt général",
      "Principe de subsidiarité",
    ],
    answer: "Principe d’intérêt général",
    explanation: "Fondement de l’action administrative.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à l’agent d’accéder à son dossier administratif ?",
    options: [
      "Droit à communication du dossier",
      "Droit de retrait",
      "Droit syndical",
    ],
    answer: "Droit à communication du dossier",
    explanation: "Garantie des droits de la défense.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir interdit l’expression publique d’opinions politiques dans le service ?",
    options: ["Devoir de neutralité", "Droit d’opinion", "Devoir d’obéissance"],
    answer: "Devoir de neutralité",
    explanation: "Garantit l’impartialité du service public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel manquement peut entraîner une sanction disciplinaire sans infraction pénale ?",
    options: ["Faute disciplinaire", "Délit pénal", "Crime"],
    answer: "Faute disciplinaire",
    explanation: "Elle relève du droit disciplinaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel organe consultatif traite des conditions de travail des agents ?",
    options: [
      "Comité social d’administration",
      "Conseil constitutionnel",
      "CNIL",
    ],
    answer: "Comité social d’administration",
    explanation: "Instance de dialogue social.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est compétente pour la gestion des écoles primaires ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation: "Compétence éducative de proximité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité gère les routes nationales transférées ?",
    options: ["Région", "Département", "Commune"],
    answer: "Département",
    explanation: "Gestion des routes départementales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel organe exécute les décisions du conseil régional ?",
    options: ["Président du conseil régional", "Préfet", "Conseil régional"],
    answer: "Président du conseil régional",
    explanation: "Autorité exécutive régionale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel acte local est pris par le maire pour assurer l’ordre public ?",
    options: ["Arrêté municipal", "Décret", "Loi"],
    answer: "Arrêté municipal",
    explanation: "Pouvoir de police administrative.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel principe permet à une collectivité de gérer librement ses affaires ?",
    options: ["Libre administration", "Centralisation", "Tutelle"],
    answer: "Libre administration",
    explanation: "Principe constitutionnel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole est apposé dans les mairies lors des cérémonies officielles ?",
    options: [
      "Portrait du Président",
      "Drapeau européen seul",
      "Armoiries régionales",
    ],
    answer: "Portrait du Président",
    explanation: "Usage protocolaire républicain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel symbole républicain est associé à la justice ?",
    options: ["Balance", "Bonnet phrygien", "Faisceau"],
    answer: "Balance",
    explanation: "Symbole d’équité et d’impartialité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quelle date commémore l’armistice de la Première Guerre mondiale ?",
    options: ["11 novembre", "8 mai", "14 juillet"],
    answer: "11 novembre",
    explanation: "Armistice signé en 1918.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe impose que les lois soient claires et accessibles ?",
    options: ["Sécurité juridique", "Autorité", "Primauté"],
    answer: "Sécurité juridique",
    explanation: "Principe dégagé par la jurisprudence.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe permet au citoyen de participer directement à la décision politique ?",
    options: ["Référendum", "Centralisation", "Tutelle"],
    answer: "Référendum",
    explanation: "Expression directe de la souveraineté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe protège la liberté individuelle contre les arrestations arbitraires ?",
    options: ["Contrôle du juge", "Primauté", "Neutralité"],
    answer: "Contrôle du juge",
    explanation: "Garantie constitutionnelle.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen adopte les lignes directrices en matière de politique économique ?",
    options: ["Conseil européen", "Commission européenne", "BCE"],
    answer: "Conseil européen",
    explanation: "Il fixe les grandes orientations économiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut imposer une amende à une entreprise pour abus de position dominante ?",
    options: ["Commission européenne", "CJUE", "Parlement européen"],
    answer: "Commission européenne",
    explanation: "Elle veille au respect des règles de concurrence.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel traité a créé la Communauté économique européenne ?",
    options: ["Traité de Rome", "Traité de Maastricht", "Traité de Lisbonne"],
    answer: "Traité de Rome",
    explanation: "Signé en 1957.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen coordonne les politiques budgétaires de la zone euro ?",
    options: ["Eurogroupe", "BCE", "Conseil européen"],
    answer: "Eurogroupe",
    explanation: "Réunion des ministres des Finances.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe impose aux États membres de coopérer loyalement avec l’UE ?",
    options: ["Coopération loyale", "Primauté", "Proportionnalité"],
    answer: "Coopération loyale",
    explanation: "Principe inscrit dans les traités.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quelle institution européenne ne siège pas à Bruxelles ?",
    options: ["CJUE", "Commission européenne", "Conseil de l’UE"],
    answer: "CJUE",
    explanation: "La CJUE siège à Luxembourg.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen assure la traduction officielle des textes juridiques ?",
    options: [
      "Commission européenne",
      "Parlement européen",
      "Office des publications",
    ],
    answer: "Office des publications",
    explanation: "Il publie les textes dans toutes les langues officielles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel mécanisme permet à un État de contester un acte de l’UE ?",
    options: [
      "Recours en annulation",
      "Référendum européen",
      "Initiative citoyenne",
    ],
    answer: "Recours en annulation",
    explanation: "Introduit devant la CJUE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen valide les accords d’adhésion de nouveaux États ?",
    options: [
      "Conseil européen",
      "Parlement européen",
      "Commission européenne",
    ],
    answer: "Conseil européen",
    explanation: "Décision prise à l’unanimité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe européen gère la politique commerciale commune ?",
    options: [
      "Commission européenne",
      "Conseil européen",
      "Parlement européen",
    ],
    answer: "Commission européenne",
    explanation: "Compétence exclusive de l’UE.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe garantit la stabilité du statut des fonctionnaires ?",
    options: [
      "Principe de carrière",
      "Principe de neutralité",
      "Principe de mutabilité",
    ],
    answer: "Principe de carrière",
    explanation:
        "La carrière évolue indépendamment des changements politiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à un agent de refuser un ordre manifestement illégal ?",
    options: ["Droit de désobéissance", "Droit de réserve", "Droit syndical"],
    answer: "Droit de désobéissance",
    explanation:
        "En cas d’ordre manifestement illégal et compromettant gravement l’intérêt public.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe impose l’impartialité de l’administration ?",
    options: ["Neutralité", "Continuité", "Mutabilité"],
    answer: "Neutralité",
    explanation: "Absence de prise de position idéologique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à l’agent d’adhérer à une organisation syndicale ?",
    options: ["Droit syndical", "Droit de retrait", "Droit de réserve"],
    answer: "Droit syndical",
    explanation: "Liberté syndicale garantie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel manquement consiste en un comportement portant atteinte à l’image du service ?",
    options: ["Manquement à la dignité", "Faute pénale", "Erreur matérielle"],
    answer: "Manquement à la dignité",
    explanation: "Peut justifier une sanction disciplinaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel organe examine les recours contre les sanctions disciplinaires lourdes ?",
    options: ["Conseil de discipline", "CNIL", "Conseil constitutionnel"],
    answer: "Conseil de discipline",
    explanation: "Instance consultative disciplinaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est compétente pour la gestion des crèches municipales ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation: "Compétence sociale de proximité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est compétente pour la gestion des collèges publics ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation: "Compétence éducative départementale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité coordonne les politiques de développement économique local ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "Chef de file en matière économique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel organe est l’exécutif de la commune ?",
    options: ["Maire", "Conseil municipal", "Préfet"],
    answer: "Maire",
    explanation: "Il exécute les décisions du conseil municipal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel document fixe les règles d’urbanisme à l’échelle intercommunale ?",
    options: ["PLUi", "PLU", "SRADDET"],
    answer: "PLUi",
    explanation: "Plan local d’urbanisme intercommunal.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel symbole figure sur le sceau de l’État français ?",
    options: ["Marianne", "Le coq", "Le bonnet phrygien seul"],
    answer: "Marianne",
    explanation: "Symbole officiel de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quelle date correspond à la commémoration de l’abolition de l’esclavage en France ?",
    options: ["10 mai", "14 juillet", "11 novembre"],
    answer: "10 mai",
    explanation: "Journée nationale des mémoires de l’esclavage.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel symbole est associé à la souveraineté nationale ?",
    options: ["Le drapeau tricolore", "Le coq", "La balance"],
    answer: "Le drapeau tricolore",
    explanation: "Symbole de la Nation française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe garantit que nul ne peut être puni sans loi préalable ?",
    options: ["Légalité des délits et des peines", "Primauté", "Subsidiarité"],
    answer: "Légalité des délits et des peines",
    explanation: "Principe fondamental du droit pénal.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe impose la protection des droits fondamentaux par le juge ?",
    options: ["État de droit", "Autorité", "Centralisation"],
    answer: "État de droit",
    explanation: "Garantie juridictionnelle des libertés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe garantit la liberté d’expression politique ?",
    options: ["Pluralisme", "Neutralité", "Continuité"],
    answer: "Pluralisme",
    explanation: "Reconnu par la jurisprudence constitutionnelle.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut proposer des sanctions financières contre un État membre ?",
    options: [
      "Commission européenne",
      "Parlement européen",
      "Cour des comptes",
    ],
    answer: "Commission européenne",
    explanation: "Elle peut saisir la CJUE en cas de manquement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen contrôle le respect de l’État de droit dans les États membres ?",
    options: ["Commission européenne", "BCE", "Comité des régions"],
    answer: "Commission européenne",
    explanation: "Elle publie des rapports annuels sur l’État de droit.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel mécanisme permet aux citoyens de proposer une action européenne ?",
    options: [
      "Initiative citoyenne européenne",
      "Référendum européen",
      "Consultation publique",
    ],
    answer: "Initiative citoyenne européenne",
    explanation: "Un million de signatures sont nécessaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen fixe la politique monétaire de la zone euro ?",
    options: ["BCE", "Eurogroupe", "Commission européenne"],
    answer: "BCE",
    explanation: "La Banque centrale européenne est indépendante.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quelle institution européenne est dirigée par un directoire ?",
    options: ["BCE", "CJUE", "Parlement européen"],
    answer: "BCE",
    explanation: "Le directoire met en œuvre la politique monétaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel traité a supprimé les piliers de l’Union européenne ?",
    options: ["Traité de Lisbonne", "Traité de Maastricht", "Traité de Nice"],
    answer: "Traité de Lisbonne",
    explanation: "Entré en vigueur en 2009.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen assure la collecte des statistiques officielles ?",
    options: ["Eurostat", "OLAF", "Cour des comptes"],
    answer: "Eurostat",
    explanation: "Office statistique de l’UE.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen lutte contre la fraude aux fonds européens ?",
    options: ["OLAF", "Eurojust", "Europol"],
    answer: "OLAF",
    explanation: "Office européen de lutte antifraude.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen est composé de chefs d’État ou de gouvernement ?",
    options: ["Conseil européen", "Conseil de l’UE", "Commission européenne"],
    answer: "Conseil européen",
    explanation: "Il donne les impulsions politiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe permet à l’UE d’agir uniquement si l’action nationale est insuffisante ?",
    options: ["Subsidiarité", "Primauté", "Solidarité"],
    answer: "Subsidiarité",
    explanation: "Principe fondamental de répartition des compétences.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe interdit le favoritisme dans les recrutements publics ?",
    options: ["Égalité d’accès", "Neutralité", "Continuité"],
    answer: "Égalité d’accès",
    explanation: "Principe constitutionnel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à un agent de cesser le travail en cas de danger grave ?",
    options: ["Droit de retrait", "Droit syndical", "Droit de réserve"],
    answer: "Droit de retrait",
    explanation: "En cas de danger grave et imminent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel devoir impose la loyauté envers l’administration ?",
    options: ["Devoir de loyauté", "Neutralité", "Dignité"],
    answer: "Devoir de loyauté",
    explanation: "L’agent agit dans l’intérêt du service.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose une conduite exemplaire y compris hors service ?",
    options: ["Dignité", "Obéissance", "Neutralité"],
    answer: "Dignité",
    explanation: "S’applique même dans la vie privée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quelle sanction disciplinaire est la plus grave ?",
    options: ["Révocation", "Blâme", "Exclusion temporaire"],
    answer: "Révocation",
    explanation:
        "Elle entraîne la perte définitive de la qualité de fonctionnaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe garantit l’indépendance des agents face au pouvoir politique ?",
    options: [
      "Principe de neutralité",
      "Principe de carrière",
      "Principe de mutabilité",
    ],
    answer: "Principe de carrière",
    explanation: "La carrière ne dépend pas du changement de majorité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est chef de file en matière de transports régionaux ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "Elle organise notamment les TER.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité gère l’aide sociale à l’enfance ?",
    options: ["Département", "Commune", "Région"],
    answer: "Département",
    explanation: "Compétence sociale majeure.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel représentant de l’État contrôle la légalité des actes locaux ?",
    options: ["Préfet", "Maire", "Président de région"],
    answer: "Préfet",
    explanation: "Contrôle a posteriori.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel principe interdit à l’État de diriger une collectivité locale ?",
    options: ["Libre administration", "Tutelle", "Centralisation"],
    answer: "Libre administration",
    explanation: "Principe constitutionnel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel document local fixe les orientations d’aménagement communal ?",
    options: ["PADD", "SRADDET", "SCOT"],
    answer: "PADD",
    explanation: "Projet d’aménagement et de développement durables.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel symbole républicain figure sur les timbres français ?",
    options: ["Marianne", "Le coq", "La balance"],
    answer: "Marianne",
    explanation: "Figure emblématique de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle date correspond à la fête nationale française ?",
    options: ["14 juillet", "11 novembre", "8 mai"],
    answer: "14 juillet",
    explanation: "Commémoration de la prise de la Bastille.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel symbole représente la fraternité ?",
    options: ["La devise républicaine", "Le drapeau", "La balance"],
    answer: "La devise républicaine",
    explanation: "Liberté, Égalité, Fraternité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe impose que les pouvoirs soient séparés ?",
    options: ["Séparation des pouvoirs", "Centralisation", "Primauté"],
    answer: "Séparation des pouvoirs",
    explanation: "Principe fondamental de l’État de droit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe garantit l’indépendance de l’autorité judiciaire ?",
    options: ["Indépendance de la justice", "Neutralité", "Continuité"],
    answer: "Indépendance de la justice",
    explanation: "Garantit un procès équitable.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe protège les droits fondamentaux contre l’arbitraire administratif ?",
    options: ["Contrôle juridictionnel", "Autorité", "Centralisation"],
    answer: "Contrôle juridictionnel",
    explanation: "Le juge contrôle l’administration.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut suspendre les droits de vote d’un État membre ?",
    options: [
      "Conseil de l’Union européenne",
      "Commission européenne",
      "Parlement européen",
    ],
    answer: "Conseil de l’Union européenne",
    explanation: "Dans le cadre de la procédure de l’article 7 du TUE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel article du traité prévoit des sanctions en cas de violation grave des valeurs de l’UE ?",
    options: ["Article 7 TUE", "Article 50 TUE", "Article 3 TFUE"],
    answer: "Article 7 TUE",
    explanation: "Il protège les valeurs fondamentales de l’Union.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen coordonne la coopération judiciaire pénale ?",
    options: ["Eurojust", "Europol", "OLAF"],
    answer: "Eurojust",
    explanation: "Il facilite la coopération entre autorités judiciaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe européen coordonne la coopération policière ?",
    options: ["Europol", "Eurojust", "Frontex"],
    answer: "Europol",
    explanation: "Agence européenne de police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle agence européenne est chargée du contrôle des frontières extérieures ?",
    options: ["Frontex", "Europol", "Eurostat"],
    answer: "Frontex",
    explanation: "Agence européenne de garde-frontières et de garde-côtes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe européen statue sur les questions de concurrence ?",
    options: ["Commission européenne", "CJUE", "Conseil européen"],
    answer: "Commission européenne",
    explanation: "Elle applique le droit de la concurrence.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe impose la supériorité du droit européen sur le droit national ?",
    options: ["Primauté", "Subsidiarité", "Proportionnalité"],
    answer: "Primauté",
    explanation: "Principe dégagé par la jurisprudence de la CJUE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel arrêt fondateur consacre la primauté du droit de l’UE ?",
    options: ["Costa c/ ENEL", "Van Gend en Loos", "Simmenthal"],
    answer: "Costa c/ ENEL",
    explanation: "Arrêt de 1964 de la CJUE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel arrêt consacre l’effet direct du droit européen ?",
    options: ["Van Gend en Loos", "Costa c/ ENEL", "Lisbonne"],
    answer: "Van Gend en Loos",
    explanation: "Arrêt fondateur de 1963.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel budget est plafonné à environ 1 % du RNB européen ?",
    options: ["Budget de l’UE", "Budget national", "Budget de la BCE"],
    answer: "Budget de l’UE",
    explanation: "Budget limité par les traités.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose à l’agent d’obéir aux ordres hiérarchiques légaux ?",
    options: ["Obéissance hiérarchique", "Neutralité", "Dignité"],
    answer: "Obéissance hiérarchique",
    explanation: "Limité par l’illégalité manifeste.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir interdit à l’agent de tirer un avantage personnel de ses fonctions ?",
    options: ["Probité", "Neutralité", "Réserve"],
    answer: "Probité",
    explanation: "Interdit la corruption et les conflits d’intérêts.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel manquement correspond à une violation volontaire des obligations professionnelles ?",
    options: [
      "Faute disciplinaire",
      "Erreur matérielle",
      "Faute de service involontaire",
    ],
    answer: "Faute disciplinaire",
    explanation: "Peut entraîner une sanction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe protège l’agent contre l’arbitraire de l’administration ?",
    options: ["Droits de la défense", "Neutralité", "Continuité"],
    answer: "Droits de la défense",
    explanation: "Accès au dossier et possibilité de se défendre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quelle obligation impose la discrétion sur les informations non publiques ?",
    options: [
      "Obligation de discrétion professionnelle",
      "Droit de réserve",
      "Neutralité",
    ],
    answer: "Obligation de discrétion professionnelle",
    explanation: "Même hors service.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à l’agent de participer à la vie démocratique ?",
    options: ["Liberté d’opinion", "Neutralité", "Obéissance"],
    answer: "Liberté d’opinion",
    explanation: "Protégée par le statut général.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité gère les lycées publics ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "Compétence éducative régionale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité gère le RSA ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation: "Compétence sociale majeure.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel organe délibérant vote le budget communal ?",
    options: ["Conseil municipal", "Maire", "Préfet"],
    answer: "Conseil municipal",
    explanation: "Organe délibérant de la commune.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel principe permet aux collectivités de disposer de ressources propres ?",
    options: ["Autonomie financière", "Centralisation", "Tutelle"],
    answer: "Autonomie financière",
    explanation: "Principe constitutionnel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel document planifie les déplacements à l’échelle locale ?",
    options: ["PDU", "PLU", "SCOT"],
    answer: "PDU",
    explanation: "Plan de déplacements urbains.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole est utilisé lors des cérémonies militaires officielles ?",
    options: ["Drapeau tricolore", "Bonnet phrygien", "Balance"],
    answer: "Drapeau tricolore",
    explanation: "Symbole de la Nation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel symbole est gravé sur les pièces en euro françaises ?",
    options: ["Marianne", "Le coq", "La balance"],
    answer: "Marianne",
    explanation: "Figure de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel texte fonde les valeurs républicaines ?",
    options: [
      "Déclaration des droits de l’homme et du citoyen",
      "Code civil",
      "Charte de l’environnement",
    ],
    answer: "Déclaration des droits de l’homme et du citoyen",
    explanation: "Texte fondateur de 1789.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe garantit la liberté d’aller et venir ?",
    options: ["Liberté individuelle", "Autorité", "Centralisation"],
    answer: "Liberté individuelle",
    explanation: "Protégée par la Constitution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe garantit l’égalité devant la loi ?",
    options: ["Égalité", "Neutralité", "Continuité"],
    answer: "Égalité",
    explanation: "Principe constitutionnel fondamental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe permet au juge administratif de contrôler l’administration ?",
    options: ["Séparation des pouvoirs", "Centralisation", "Primauté"],
    answer: "Séparation des pouvoirs",
    explanation: "Fondement de l’équilibre institutionnel.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne détient le monopole de l’initiative législative ?",
    options: ["Commission européenne", "Parlement européen", "Conseil de l’UE"],
    answer: "Commission européenne",
    explanation: "Elle est la seule à pouvoir proposer des textes législatifs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen représente directement les citoyens de l’Union ?",
    options: [
      "Parlement européen",
      "Commission européenne",
      "Conseil européen",
    ],
    answer: "Parlement européen",
    explanation: "Ses membres sont élus au suffrage universel direct.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen vote les amendements aux projets de directives ?",
    options: ["Parlement européen", "Commission européenne", "CJUE"],
    answer: "Parlement européen",
    explanation:
        "Il participe pleinement à la procédure législative ordinaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quelle institution européenne assure le respect des traités ?",
    options: [
      "Commission européenne",
      "Conseil européen",
      "Parlement européen",
    ],
    answer: "Commission européenne",
    explanation: "Elle est la gardienne des traités.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen n’est pas une institution mais une agence ?",
    options: ["Europol", "Parlement européen", "Commission européenne"],
    answer: "Europol",
    explanation: "Europol est une agence de coopération policière.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel vote est requis au Conseil de l’UE dans la majorité des domaines ?",
    options: ["Majorité qualifiée", "Unanimité", "Majorité simple"],
    answer: "Majorité qualifiée",
    explanation: "C’est la règle générale depuis le traité de Lisbonne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose l’égalité de traitement des usagers du service public ?",
    options: ["Égalité", "Neutralité", "Mutabilité"],
    answer: "Égalité",
    explanation: "Principe fondamental du service public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe interdit à un agent public de manifester ses convictions religieuses ?",
    options: ["Neutralité", "Liberté d’opinion", "Continuité"],
    answer: "Neutralité",
    explanation: "Elle garantit l’impartialité du service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe impose l’adaptation constante du service public ?",
    options: ["Mutabilité", "Égalité", "Neutralité"],
    answer: "Mutabilité",
    explanation: "Le service évolue selon les besoins des usagers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit protège l’agent public victime de menaces dans ses fonctions ?",
    options: ["Protection fonctionnelle", "Droit syndical", "Droit de retrait"],
    answer: "Protection fonctionnelle",
    explanation: "L’administration assure la défense de l’agent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel devoir impose à l’agent de servir l’intérêt général ?",
    options: ["Devoir de loyauté", "Devoir de réserve", "Devoir de discrétion"],
    answer: "Devoir de loyauté",
    explanation: "L’agent agit dans l’intérêt du service.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à un agent de cesser le travail face à un danger grave ?",
    options: ["Droit de retrait", "Droit de grève", "Droit syndical"],
    answer: "Droit de retrait",
    explanation: "Applicable en cas de danger grave et imminent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité territoriale est la cellule administrative de base ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation: "Première échelle de la démocratie locale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est chef de file en matière de développement économique ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "Compétence économique principale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité gère l’aide sociale légale ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation: "Il gère notamment le RSA.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Qui exerce le contrôle de légalité des actes des collectivités ?",
    options: ["Préfet", "Maire", "Conseil régional"],
    answer: "Préfet",
    explanation: "Représentant de l’État dans le département.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel principe garantit l’autonomie des collectivités territoriales ?",
    options: ["Libre administration", "Centralisation", "Tutelle"],
    answer: "Libre administration",
    explanation: "Principe inscrit dans la Constitution.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle devise est associée à la République française ?",
    options: [
      "Liberté, Égalité, Fraternité",
      "Ordre et progrès",
      "Unité et justice",
    ],
    answer: "Liberté, Égalité, Fraternité",
    explanation: "Devise officielle depuis la IIIe République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel personnage symbolise la République française ?",
    options: ["Marianne", "Jeanne d’Arc", "Napoléon"],
    answer: "Marianne",
    explanation: "Figure allégorique de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle date correspond à la fête nationale française ?",
    options: ["14 juillet", "11 novembre", "8 mai"],
    answer: "14 juillet",
    explanation: "Commémoration de la prise de la Bastille.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe impose la séparation entre pouvoir exécutif, législatif et judiciaire ?",
    options: ["Séparation des pouvoirs", "Primauté", "Subsidiarité"],
    answer: "Séparation des pouvoirs",
    explanation: "Principe fondamental de l’État de droit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe garantit que l’État est soumis au droit ?",
    options: ["État de droit", "Centralisation", "Autorité"],
    answer: "État de droit",
    explanation: "Le pouvoir est limité par la loi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe garantit l’égalité de tous devant la loi ?",
    options: ["Égalité", "Neutralité", "Continuité"],
    answer: "Égalité",
    explanation: "Principe constitutionnel fondamental.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne approuve le collège des commissaires avant son entrée en fonction ?",
    options: [
      "Parlement européen",
      "Conseil européen",
      "Cour des comptes européenne",
    ],
    answer: "Parlement européen",
    explanation:
        "Le Parlement vote l’approbation de la Commission dans son ensemble.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen fixe le nombre de commissaires et valide leur nomination finale ?",
    options: ["Conseil européen", "Parlement européen", "CJUE"],
    answer: "Conseil européen",
    explanation:
        "Les chefs d’État/gouvernement arrêtent la composition politique globale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen est composé de représentants permanents des États membres (ambassadeurs) ?",
    options: ["COREPER", "Eurostat", "OLAF"],
    answer: "COREPER",
    explanation:
        "Le Comité des représentants permanents prépare les travaux du Conseil.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel est le rôle principal du COREPER ?",
    options: [
      "Préparer les décisions du Conseil de l’UE",
      "Contrôler la politique monétaire",
      "Rendre des arrêts",
    ],
    answer: "Préparer les décisions du Conseil de l’UE",
    explanation:
        "Il filtre et prépare les dossiers avant décision ministérielle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne peut ouvrir une enquête en matière d’aides d’État ?",
    options: [
      "Commission européenne",
      "Parlement européen",
      "Conseil européen",
    ],
    answer: "Commission européenne",
    explanation:
        "Elle contrôle la compatibilité des aides avec le marché intérieur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel domaine relève d’une compétence exclusive de l’UE ?",
    options: ["Politique commerciale commune", "Éducation", "Police nationale"],
    answer: "Politique commerciale commune",
    explanation:
        "L’UE négocie les accords commerciaux au nom des États membres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel instrument juridique européen s’applique immédiatement sans transposition ?",
    options: ["Règlement", "Directive", "Avis"],
    answer: "Règlement",
    explanation:
        "Le règlement est directement applicable dans tous les États membres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel instrument juridique européen impose un objectif mais laisse le choix des moyens ?",
    options: ["Directive", "Règlement", "Décision"],
    answer: "Directive",
    explanation: "Elle nécessite une transposition dans le droit national.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut infliger des sanctions pécuniaires à un État après condamnation ?",
    options: ["CJUE", "Parlement européen", "Cour des comptes européenne"],
    answer: "CJUE",
    explanation:
        "La Cour peut imposer une somme forfaitaire et/ou une astreinte.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen assure l’interprétation uniforme du droit de l’Union ?",
    options: ["CJUE", "Conseil européen", "Eurogroupe"],
    answer: "CJUE",
    explanation:
        "Elle harmonise l’interprétation et l’application du droit de l’UE.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel mécanisme permet à une juridiction nationale de poser une question à la CJUE ?",
    options: [
      "Question préjudicielle",
      "Motion de censure",
      "Déféré préfectoral",
    ],
    answer: "Question préjudicielle",
    explanation:
        "Procédure de renvoi préjudiciel pour interprétation/validité du droit de l’UE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen est chargé de publier les appels d’offres européens ?",
    options: ["TED", "Eurojust", "Frontex"],
    answer: "TED",
    explanation:
        "Tenders Electronic Daily diffuse les marchés publics européens.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen lutte contre la fraude portant atteinte aux intérêts financiers de l’UE ?",
    options: ["OLAF", "Eurostat", "Comité des régions"],
    answer: "OLAF",
    explanation: "OLAF mène des enquêtes administratives antifraude.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen coordonne la coopération judiciaire pénale entre États ?",
    options: ["Eurojust", "Europol", "EASA"],
    answer: "Eurojust",
    explanation:
        "Eurojust facilite la coordination entre autorités judiciaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe européen coordonne la coopération policière ?",
    options: ["Europol", "Eurojust", "Eurostat"],
    answer: "Europol",
    explanation: "Europol soutient les services répressifs des États membres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle agence européenne est liée à la gestion des frontières extérieures ?",
    options: ["Frontex", "Europol", "OLAF"],
    answer: "Frontex",
    explanation: "Agence européenne de garde-frontières et de garde-côtes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne est indépendante des gouvernements pour la politique monétaire ?",
    options: ["BCE", "Conseil européen", "Parlement européen"],
    answer: "BCE",
    explanation: "La BCE conduit la politique monétaire de la zone euro.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe est composé des ministres des Finances de la zone euro ?",
    options: ["Eurogroupe", "Conseil européen", "CJUE"],
    answer: "Eurogroupe",
    explanation:
        "Réunion politique de coordination économique de la zone euro.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen représente les collectivités locales et régionales ?",
    options: [
      "Comité des régions",
      "Conseil européen",
      "Commission européenne",
    ],
    answer: "Comité des régions",
    explanation: "Instance consultative des collectivités territoriales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen représente la société civile organisée (employeurs, salariés, associations) ?",
    options: ["CESE européen", "CJUE", "Eurogroupe"],
    answer: "CESE européen",
    explanation:
        "Le Comité économique et social européen rend des avis consultatifs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe limite l’action de l’UE à ce qui est nécessaire pour atteindre les objectifs ?",
    options: ["Proportionnalité", "Primauté", "Centralisation"],
    answer: "Proportionnalité",
    explanation: "L’UE ne doit pas aller au-delà de ce qui est nécessaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe signifie que l’UE n’agit que si l’échelon national est insuffisant ?",
    options: ["Subsidiarité", "Primauté", "Neutralité"],
    answer: "Subsidiarité",
    explanation: "Décision au niveau le plus proche quand c’est efficace.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel traité a instauré la citoyenneté européenne ?",
    options: ["Traité de Maastricht", "Traité de Rome", "Traité de Nice"],
    answer: "Traité de Maastricht",
    explanation:
        "Il fonde l’Union européenne moderne et la citoyenneté de l’UE.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel traité a renforcé la procédure législative ordinaire (codécision) ?",
    options: ["Traité de Lisbonne", "Traité de Rome", "Acte unique européen"],
    answer: "Traité de Lisbonne",
    explanation: "Il étend les pouvoirs du Parlement européen.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut engager un recours en manquement contre un État ?",
    options: ["Commission européenne", "Eurostat", "Comité des régions"],
    answer: "Commission européenne",
    explanation: "Elle peut saisir la CJUE pour non-respect du droit de l’UE.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut approuver ou rejeter un accord commercial négocié par l’UE ?",
    options: ["Parlement européen", "BCE", "Cour des comptes"],
    answer: "Parlement européen",
    explanation:
        "Le Parlement a un pouvoir d’approbation sur certains accords.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quelles sont les trois fonctions publiques en France ?",
    options: [
      "État, territoriale, hospitalière",
      "État, européenne, privée",
      "Territoriale, judiciaire, militaire",
    ],
    answer: "État, territoriale, hospitalière",
    explanation: "Trois versants de la fonction publique française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel versant de la fonction publique concerne les collectivités territoriales ?",
    options: [
      "Fonction publique territoriale",
      "Fonction publique d’État",
      "Fonction publique hospitalière",
    ],
    answer: "Fonction publique territoriale",
    explanation:
        "Elle regroupe communes, départements, régions, intercommunalités.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel versant de la fonction publique concerne les hôpitaux publics ?",
    options: [
      "Fonction publique hospitalière",
      "Fonction publique territoriale",
      "Fonction publique d’État",
    ],
    answer: "Fonction publique hospitalière",
    explanation:
        "Elle regroupe établissements publics de santé et médico-sociaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose l’égalité de traitement des usagers du service public ?",
    options: ["Égalité", "Mutabilité", "Primauté"],
    answer: "Égalité",
    explanation:
        "Aucune discrimination entre usagers dans une situation comparable.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe impose la permanence du service public ?",
    options: ["Continuité", "Subsidiarité", "Tutelle"],
    answer: "Continuité",
    explanation: "Le service public doit fonctionner de manière régulière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose l’adaptation du service public aux besoins ?",
    options: ["Mutabilité", "Neutralité", "Centralisation"],
    answer: "Mutabilité",
    explanation: "Le service public évolue avec les besoins de la société.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose l’impartialité politique de l’agent dans le service ?",
    options: ["Neutralité", "Libre opinion", "Droit de grève"],
    answer: "Neutralité",
    explanation:
        "L’agent ne doit pas manifester ses opinions dans l’exercice du service.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose la modération dans l’expression publique d’un agent ?",
    options: ["Devoir de réserve", "Droit syndical", "Obligation de résultat"],
    answer: "Devoir de réserve",
    explanation: "Il limite l’expression publique selon la fonction exercée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quelle obligation impose de ne pas divulguer des informations non publiques du service ?",
    options: ["Discrétion professionnelle", "Liberté d’expression", "Primauté"],
    answer: "Discrétion professionnelle",
    explanation: "Obligation générale liée au service.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quelle obligation impose de ne pas révéler des informations protégées par la loi ?",
    options: ["Secret professionnel", "Devoir de réserve", "Neutralité"],
    answer: "Secret professionnel",
    explanation: "Obligation renforcée, parfois pénalement sanctionnée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit protège l’agent poursuivi ou menacé en raison de ses fonctions ?",
    options: [
      "Protection fonctionnelle",
      "Droit de retrait",
      "Droit d’alerte économique",
    ],
    answer: "Protection fonctionnelle",
    explanation: "L’administration apporte protection et assistance à l’agent.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe impose d’éviter les conflits d’intérêts ?",
    options: ["Probité", "Mutabilité", "Continuité"],
    answer: "Probité",
    explanation:
        "L’agent ne doit pas se servir de sa fonction à des fins personnelles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe garantit l’accès aux emplois publics selon le mérite ?",
    options: ["Égal accès aux emplois publics", "Primauté", "Subsidiarité"],
    answer: "Égal accès aux emplois publics",
    explanation: "Principe constitutionnel d’égalité d’accès.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité est responsable des écoles maternelles et élémentaires ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation: "La commune gère les écoles du premier degré.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité est responsable des collèges ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation: "Le département gère les collèges publics.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité est responsable des lycées ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "La région gère les lycées publics.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel est l’organe délibérant d’une commune ?",
    options: ["Conseil municipal", "Maire", "Préfet"],
    answer: "Conseil municipal",
    explanation: "Il vote les délibérations et le budget communal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Qui est l’exécutif de la commune ?",
    options: ["Le maire", "Le conseil municipal", "Le préfet"],
    answer: "Le maire",
    explanation: "Il exécute les décisions du conseil municipal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel est l’organe délibérant du département ?",
    options: ["Conseil départemental", "Préfet", "Conseil régional"],
    answer: "Conseil départemental",
    explanation: "Assemblée élue du département.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel est l’organe délibérant de la région ?",
    options: ["Conseil régional", "Préfet de région", "Conseil départemental"],
    answer: "Conseil régional",
    explanation: "Assemblée élue de la région.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel principe constitutionnel garantit l’autonomie des collectivités ?",
    options: ["Libre administration", "Tutelle", "Centralisation"],
    answer: "Libre administration",
    explanation:
        "Les collectivités s’administrent librement par des conseils élus.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Qui représente l’État dans le département ?",
    options: ["Préfet", "Maire", "Président du département"],
    answer: "Préfet",
    explanation: "Il assure l’ordre public et le contrôle de légalité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel mécanisme permet au préfet de contester un acte local illégal ?",
    options: ["Déféré préfectoral", "Référendum local", "QPC"],
    answer: "Déféré préfectoral",
    explanation: "Saisine du juge administratif contre l’acte.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle structure regroupe plusieurs communes pour exercer des compétences communes ?",
    options: ["Intercommunalité", "Préfecture", "Rectorat"],
    answer: "Intercommunalité",
    explanation: "EPCI : communautés de communes, d’agglomération, etc.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel document fixe les règles d’urbanisme à l’échelle de la commune ?",
    options: ["PLU", "SRADDET", "LOLF"],
    answer: "PLU",
    explanation: "Plan local d’urbanisme : zonage et règles de construction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel document fixe les règles d’urbanisme à l’échelle intercommunale ?",
    options: ["PLUi", "PDU", "SCOT"],
    answer: "PLUi",
    explanation: "Plan local d’urbanisme intercommunal.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel est l’hymne national français ?",
    options: ["La Marseillaise", "Le Chant du départ", "L’Internationale"],
    answer: "La Marseillaise",
    explanation: "Hymne national officiel de la France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelles sont les trois couleurs du drapeau français ?",
    options: ["Bleu, blanc, rouge", "Vert, blanc, rouge", "Noir, blanc, rouge"],
    answer: "Bleu, blanc, rouge",
    explanation: "Le drapeau tricolore est un symbole national.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel symbole incarne la République sur de nombreuses mairies ?",
    options: ["Marianne", "Le lys", "L’aigle impérial"],
    answer: "Marianne",
    explanation: "Allégorie républicaine présente sur bustes et timbres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle date est associée à la fête nationale française ?",
    options: ["14 juillet", "1er mai", "11 novembre"],
    answer: "14 juillet",
    explanation:
        "Fête nationale : prise de la Bastille et Fête de la Fédération.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle date commémore l’Armistice de 1918 ?",
    options: ["11 novembre", "8 mai", "14 juillet"],
    answer: "11 novembre",
    explanation: "Commémoration de la fin de la Première Guerre mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle date commémore la victoire de 1945 en Europe ?",
    options: ["8 mai", "11 novembre", "10 mai"],
    answer: "8 mai",
    explanation: "Victoire des Alliés en Europe (1945).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Où se trouve la tombe du Soldat inconnu ?",
    options: ["Arc de Triomphe", "Panthéon", "Tour Eiffel"],
    answer: "Arc de Triomphe",
    explanation: "Lieu de mémoire nationale à Paris.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle devise est associée à la République française ?",
    options: [
      "Liberté, Égalité, Fraternité",
      "Travail, Famille, Patrie",
      "Ordre, Nation, Progrès",
    ],
    answer: "Liberté, Égalité, Fraternité",
    explanation: "Devise républicaine inscrite sur les bâtiments publics.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe empêche un seul pouvoir de dominer les autres ?",
    options: ["Séparation des pouvoirs", "Primauté", "Centralisation"],
    answer: "Séparation des pouvoirs",
    explanation: "Exécutif, législatif et judiciaire sont distincts.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe signifie que l’administration est soumise à la loi et au juge ?",
    options: ["État de droit", "Souveraineté administrative", "Tutelle"],
    answer: "État de droit",
    explanation: "Le pouvoir public est encadré juridiquement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel organe contrôle la constitutionnalité des lois avant promulgation ?",
    options: ["Conseil constitutionnel", "Conseil d’État", "Cour de cassation"],
    answer: "Conseil constitutionnel",
    explanation: "Contrôle a priori sur saisine prévue par la Constitution.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel mécanisme permet de contester une loi déjà en vigueur ?",
    options: ["QPC", "Déféré préfectoral", "Motion de censure"],
    answer: "QPC",
    explanation: "Question prioritaire de constitutionnalité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe garantit l’égalité de tous devant la loi ?",
    options: ["Égalité", "Neutralité", "Mutabilité"],
    answer: "Égalité",
    explanation: "Principe constitutionnel fondamental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe protège la liberté de conscience dans la République ?",
    options: ["Laïcité", "Centralisation", "Primauté"],
    answer: "Laïcité",
    explanation: "Neutralité de l’État et liberté de croire ou ne pas croire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe impose l’absence de rétroactivité des peines plus sévères ?",
    options: ["Non-rétroactivité", "Primauté", "Subsidiarité"],
    answer: "Non-rétroactivité",
    explanation: "Principe fondamental de sécurité juridique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe garantit que nul ne peut être puni sans texte ?",
    options: ["Légalité des délits et des peines", "Tutelle", "Autorité"],
    answer: "Légalité des délits et des peines",
    explanation: "Principe de base du droit pénal en démocratie.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen adopte les actes d’exécution quand ils sont nécessaires ?",
    options: [
      "Commission européenne",
      "Parlement européen",
      "Comité des régions",
    ],
    answer: "Commission européenne",
    explanation:
        "Les actes d’exécution assurent des conditions uniformes d’application.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut retirer sa confiance à la Commission via un vote ?",
    options: ["Parlement européen", "Conseil européen", "Eurogroupe"],
    answer: "Parlement européen",
    explanation: "La motion de censure entraîne la démission de la Commission.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen réunit les ministres des États membres par domaine (ex : Agriculture, Justice) ?",
    options: [
      "Conseil de l’Union européenne",
      "Conseil européen",
      "Parlement européen",
    ],
    answer: "Conseil de l’Union européenne",
    explanation: "Il se réunit en formations selon le thème traité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen adopte la « position » des États membres en négociation internationale ?",
    options: [
      "Conseil de l’Union européenne",
      "BCE",
      "Cour des comptes européenne",
    ],
    answer: "Conseil de l’Union européenne",
    explanation: "Il autorise la négociation et fixe le mandat.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen est chargé de la politique monétaire de la zone euro ?",
    options: ["BCE", "Commission européenne", "Conseil européen"],
    answer: "BCE",
    explanation: "Son objectif principal est la stabilité des prix.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel est l’objectif principal de la BCE ?",
    options: [
      "Stabilité des prix",
      "Financement direct des États",
      "Fixer les impôts européens",
    ],
    answer: "Stabilité des prix",
    explanation: "Mission prioritaire définie par les traités.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen produit les statistiques officielles de l’UE ?",
    options: ["Eurostat", "Europol", "Eurojust"],
    answer: "Eurostat",
    explanation: "Il harmonise et publie les données statistiques européennes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne siège principalement à Strasbourg pour les sessions plénières ?",
    options: ["Parlement européen", "Commission européenne", "CJUE"],
    answer: "Parlement européen",
    explanation: "Les sessions plénières se tiennent à Strasbourg.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne siège principalement à Luxembourg ?",
    options: ["CJUE", "Conseil européen", "Eurogroupe"],
    answer: "CJUE",
    explanation: "La Cour de justice de l’UE siège à Luxembourg.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut enquêter administrativement sur des fraudes liées aux fonds de l’UE ?",
    options: ["OLAF", "Eurostat", "COREPER"],
    answer: "OLAF",
    explanation: "OLAF mène des enquêtes administratives antifraude.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe signifie que le droit de l’UE prévaut sur le droit national en cas de conflit ?",
    options: ["Primauté", "Subsidiarité", "Proportionnalité"],
    answer: "Primauté",
    explanation: "Principe dégagé par la jurisprudence de la CJUE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe impose que l’action soit décidée au niveau le plus proche du citoyen quand c’est possible ?",
    options: ["Subsidiarité", "Primauté", "Solidarité"],
    answer: "Subsidiarité",
    explanation: "L’UE n’agit que si l’échelon national est insuffisant.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe impose que les mesures de l’UE ne soient pas excessives ?",
    options: ["Proportionnalité", "Neutralité", "Centralisation"],
    answer: "Proportionnalité",
    explanation: "Les moyens doivent être adaptés à l’objectif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut être saisi par un citoyen pour mauvaise administration ?",
    options: ["Médiateur européen", "CJUE", "BCE"],
    answer: "Médiateur européen",
    explanation: "Il traite les plaintes contre les institutions de l’UE.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel document fixe les grandes priorités politiques à long terme de l’UE ?",
    options: [
      "Agenda stratégique du Conseil européen",
      "Programme de stabilité",
      "Livre bleu",
    ],
    answer: "Agenda stratégique du Conseil européen",
    explanation: "Le Conseil européen donne l’impulsion politique générale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen réunit des représentants permanents des États et prépare les travaux du Conseil ?",
    options: ["COREPER", "CESE européen", "Eurojust"],
    answer: "COREPER",
    explanation: "Il prépare les dossiers et les compromis avant décision.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen est consultatif et représente les collectivités territoriales ?",
    options: ["Comité des régions", "Conseil de l’UE", "CJUE"],
    answer: "Comité des régions",
    explanation: "Il rend des avis sur les textes impactant les territoires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen est consultatif et représente partenaires sociaux et société civile ?",
    options: ["CESE européen", "Frontex", "Eurogroupe"],
    answer: "CESE européen",
    explanation: "Il associe employeurs, salariés et autres acteurs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle agence européenne soutient les États membres contre la criminalité organisée et le terrorisme ?",
    options: ["Europol", "Eurostat", "EASA"],
    answer: "Europol",
    explanation: "Agence de coopération policière européenne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle agence européenne est dédiée à la coopération judiciaire pénale ?",
    options: ["Eurojust", "Europol", "OLAF"],
    answer: "Eurojust",
    explanation: "Coordination entre autorités judiciaires nationales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle agence européenne appuie la gestion des frontières extérieures ?",
    options: ["Frontex", "Eurojust", "CESE européen"],
    answer: "Frontex",
    explanation: "Garde-frontières et garde-côtes européens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel traité a formalisé une procédure de retrait volontaire d’un État membre ?",
    options: ["Traité de Lisbonne", "Traité de Rome", "Traité de Nice"],
    answer: "Traité de Lisbonne",
    explanation: "Il a introduit l’article 50 du TUE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Comment s’appelle la procédure de retrait volontaire d’un État membre ?",
    options: ["Article 50", "Article 7", "Article 3"],
    answer: "Article 50",
    explanation: "Procédure prévue par le traité sur l’Union européenne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel versant regroupe les ministères et les administrations centrales ?",
    options: [
      "Fonction publique d’État",
      "Fonction publique territoriale",
      "Fonction publique hospitalière",
    ],
    answer: "Fonction publique d’État",
    explanation: "Elle concerne l’État et ses services déconcentrés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe garantit la non-discrimination entre usagers d’un même service ?",
    options: ["Égalité", "Réserve", "Primauté"],
    answer: "Égalité",
    explanation: "Même situation, même traitement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose que le service public fonctionne de manière régulière ?",
    options: ["Continuité", "Tutelle", "Subsidiarité"],
    answer: "Continuité",
    explanation: "Principe essentiel, notamment pour certains services vitaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe exige l’adaptation du service public aux évolutions techniques et sociales ?",
    options: ["Mutabilité", "Neutralité", "Centralisation"],
    answer: "Mutabilité",
    explanation: "L’organisation peut évoluer pour répondre aux besoins.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose une conduite compatible avec la fonction exercée ?",
    options: ["Dignité", "Primauté", "Proportionnalité"],
    answer: "Dignité",
    explanation:
        "Le comportement ne doit pas porter atteinte à l’image du service.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir interdit l’utilisation des moyens du service à des fins personnelles ?",
    options: ["Probité", "Mutabilité", "Continuité"],
    answer: "Probité",
    explanation:
        "L’agent doit prévenir les conflits d’intérêts et l’enrichissement personnel.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel devoir impose d’exécuter les ordres hiérarchiques légaux ?",
    options: ["Obéissance hiérarchique", "Liberté d’opinion", "Droit de grève"],
    answer: "Obéissance hiérarchique",
    explanation:
        "Avec limite : ordre manifestement illégal et gravement compromettant l’intérêt public.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel droit garantit la possibilité d’adhérer à un syndicat ?",
    options: ["Droit syndical", "Secret professionnel", "Devoir de réserve"],
    answer: "Droit syndical",
    explanation: "Liberté syndicale pour les agents publics.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit protège un agent public agressé en raison de ses fonctions ?",
    options: ["Protection fonctionnelle", "Mutabilité", "Continuité"],
    answer: "Protection fonctionnelle",
    explanation: "Prise en charge et assistance par l’administration.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à un agent d’accéder aux informations de son dossier administratif ?",
    options: [
      "Droit d’accès au dossier",
      "Droit de réserve",
      "Droit de neutralité",
    ],
    answer: "Droit d’accès au dossier",
    explanation: "Garantit les droits de la défense en cas de procédure.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quelle obligation impose de ne pas divulguer des informations internes non publiques ?",
    options: ["Discrétion professionnelle", "Liberté d’expression", "Primauté"],
    answer: "Discrétion professionnelle",
    explanation: "Obligation générale attachée au service.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quelle obligation protège des informations légalement protégées (ex : santé, enquêtes) ?",
    options: ["Secret professionnel", "Droit syndical", "Mutabilité"],
    answer: "Secret professionnel",
    explanation: "Obligation renforcée pouvant être sanctionnée pénalement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel niveau de collectivité gère principalement les écoles du premier degré ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation: "Bâtiments, entretien et fonctionnement des écoles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel niveau de collectivité est traditionnellement chef de file de l’action sociale ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation: "Aide sociale, RSA, ASE notamment.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel niveau de collectivité organise les lycées publics ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "Construction, entretien et équipement des lycées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel organe vote les délibérations d’une commune ?",
    options: ["Conseil municipal", "Maire", "Préfet"],
    answer: "Conseil municipal",
    explanation: "Organe délibérant élu de la commune.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel organe est l’exécutif de la commune ?",
    options: ["Maire", "Conseil municipal", "Conseil régional"],
    answer: "Maire",
    explanation: "Il exécute les décisions du conseil municipal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel organe est l’exécutif du département ?",
    options: [
      "Président du conseil départemental",
      "Préfet",
      "Conseil régional",
    ],
    answer: "Président du conseil départemental",
    explanation:
        "Il prépare et exécute les décisions du conseil départemental.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel organe est l’exécutif de la région ?",
    options: [
      "Président du conseil régional",
      "Préfet de région",
      "Conseil départemental",
    ],
    answer: "Président du conseil régional",
    explanation: "Il exécute les décisions du conseil régional.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel représentant de l’État assure le contrôle de légalité des actes locaux ?",
    options: ["Préfet", "Maire", "Président de région"],
    answer: "Préfet",
    explanation: "Contrôle a posteriori des actes transmis.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel recours permet au préfet de contester un acte local devant le juge administratif ?",
    options: ["Déféré préfectoral", "Recours gracieux", "Référendum local"],
    answer: "Déféré préfectoral",
    explanation: "Le préfet saisit le tribunal administratif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle structure regroupe des communes pour gérer des compétences communes ?",
    options: ["EPCI", "Rectorat", "Sous-préfecture"],
    answer: "EPCI",
    explanation: "Établissement public de coopération intercommunale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel type d’EPCI correspond souvent aux zones rurales ?",
    options: ["Communauté de communes", "Métropole", "Communauté urbaine"],
    answer: "Communauté de communes",
    explanation: "Structure intercommunale adaptée aux territoires ruraux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel type d’EPCI correspond aux grandes agglomérations avec fortes compétences ?",
    options: ["Métropole", "Syndicat scolaire", "Canton"],
    answer: "Métropole",
    explanation: "Intercommunalité renforcée dans les grandes aires urbaines.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel est le nom du drapeau national français ?",
    options: ["Drapeau tricolore", "Drapeau républicain vert", "Drapeau royal"],
    answer: "Drapeau tricolore",
    explanation: "Bleu, blanc, rouge : symbole national.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole républicain est couramment représenté sous forme de buste en mairie ?",
    options: ["Marianne", "Le coq", "La balance"],
    answer: "Marianne",
    explanation: "Allégorie de la République française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel est le nom officiel de la devise républicaine ?",
    options: [
      "Liberté, Égalité, Fraternité",
      "Travail, Famille, Patrie",
      "Paix, Ordre, Progrès",
    ],
    answer: "Liberté, Égalité, Fraternité",
    explanation: "Devise officielle de la République française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel chant est l’hymne national français ?",
    options: ["La Marseillaise", "Le Chant du départ", "L’Ode à la joie"],
    answer: "La Marseillaise",
    explanation: "Hymne national officiel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quelle date est une journée nationale de commémoration de l’abolition de l’esclavage ?",
    options: ["10 mai", "27 janvier", "1er janvier"],
    answer: "10 mai",
    explanation:
        "Journée des mémoires de la traite, de l’esclavage et de leurs abolitions.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel lieu parisien abrite la flamme du souvenir du Soldat inconnu ?",
    options: ["Arc de Triomphe", "Panthéon", "Invalides"],
    answer: "Arc de Triomphe",
    explanation: "La flamme est ravivée régulièrement sous l’Arc.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe impose que l’administration n’agisse que dans le cadre de la loi ?",
    options: [
      "Principe de légalité",
      "Principe de centralisation",
      "Principe d’opportunité",
    ],
    answer: "Principe de légalité",
    explanation:
        "Les actes administratifs doivent être conformes aux normes supérieures.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe garantit un contrôle des autorités publiques par le juge ?",
    options: [
      "État de droit",
      "Souveraineté administrative",
      "Primauté locale",
    ],
    answer: "État de droit",
    explanation:
        "Les pouvoirs publics sont soumis au droit et au contrôle juridictionnel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe vise à empêcher la concentration du pouvoir ?",
    options: [
      "Séparation des pouvoirs",
      "Concentration des compétences",
      "Tutelle administrative",
    ],
    answer: "Séparation des pouvoirs",
    explanation: "Équilibre entre exécutif, législatif et judiciaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel mécanisme permet à un justiciable de contester la constitutionnalité d’une loi en vigueur ?",
    options: ["QPC", "Référendum d’initiative locale", "Déféré préfectoral"],
    answer: "QPC",
    explanation: "Question prioritaire de constitutionnalité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe constitutionnel impose l’égalité devant la loi ?",
    options: ["Égalité", "Neutralité", "Mutabilité"],
    answer: "Égalité",
    explanation:
        "Principe fondamental garantissant l’absence de discrimination.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe protège la liberté de conscience et la neutralité de l’État ?",
    options: ["Laïcité", "Primauté", "Continuité"],
    answer: "Laïcité",
    explanation: "Principe constitutionnel de la République.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe interdit de punir un acte qui n’était pas interdit au moment où il a été commis ?",
    options: ["Légalité des délits et des peines", "Primauté", "Subsidiarité"],
    answer: "Légalité des délits et des peines",
    explanation: "Nul ne peut être puni sans loi préalable.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe interdit l’application rétroactive d’une peine plus sévère ?",
    options: ["Non-rétroactivité", "Centralisation", "Neutralité"],
    answer: "Non-rétroactivité",
    explanation: "Principe de sécurité juridique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe garantit la diversité des opinions dans la démocratie ?",
    options: ["Pluralisme", "Tutelle", "Unicité"],
    answer: "Pluralisme",
    explanation: "Principe reconnu comme essentiel à la vie démocratique.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne examine la bonne gestion financière du budget de l’UE ?",
    options: ["Cour des comptes européenne", "CJUE", "Comité des régions"],
    answer: "Cour des comptes européenne",
    explanation:
        "Elle contrôle les comptes et publie des rapports sur l’utilisation des fonds.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle procédure permet au Parlement européen de contrôler politiquement la Commission ?",
    options: [
      "Questions et auditions",
      "Référendum européen",
      "Déféré préfectoral",
    ],
    answer: "Questions et auditions",
    explanation:
        "Le Parlement exerce un contrôle par des questions, débats et auditions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel type de majorité est souvent utilisé au Conseil de l’UE pour adopter un texte ?",
    options: [
      "Majorité qualifiée",
      "Unanimité",
      "Majorité des deux tiers des citoyens",
    ],
    answer: "Majorité qualifiée",
    explanation: "Elle combine un seuil d’États et de population.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen définit les orientations générales de la politique de sécurité et de défense ?",
    options: ["Conseil européen", "Parlement européen", "BCE"],
    answer: "Conseil européen",
    explanation: "Il fixe l’impulsion politique générale de l’Union.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel est le nom de la procédure législative la plus courante dans l’UE ?",
    options: [
      "Procédure législative ordinaire",
      "Procédure de veto national",
      "Procédure unique de la Commission",
    ],
    answer: "Procédure législative ordinaire",
    explanation: "Le Parlement et le Conseil co-légifèrent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel acte européen est obligatoire seulement pour ses destinataires ?",
    options: ["Décision", "Directive", "Recommandation"],
    answer: "Décision",
    explanation:
        "La décision est contraignante pour ses destinataires (État, entreprise, etc.).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen conduit des enquêtes sur les violations de la concurrence au sein du marché intérieur ?",
    options: [
      "Commission européenne",
      "Cour des comptes européenne",
      "Comité des régions",
    ],
    answer: "Commission européenne",
    explanation:
        "Elle est compétente en matière d’ententes et d’abus de position dominante.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel rôle a la Cour de justice de l’Union européenne ?",
    options: [
      "Assurer le respect du droit de l’UE",
      "Fixer les impôts européens",
      "Élaborer les politiques nationales",
    ],
    answer: "Assurer le respect du droit de l’UE",
    explanation:
        "Elle contrôle l’application des traités et des actes de l’UE.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Comment s’appelle l’obligation pour les États de faciliter l’action de l’UE ?",
    options: ["Coopération loyale", "Centralisation", "Neutralité"],
    answer: "Coopération loyale",
    explanation:
        "Les États doivent prendre les mesures nécessaires pour appliquer le droit de l’UE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel mécanisme permet aux citoyens d’interpeller la Commission sur une proposition de loi ?",
    options: [
      "Initiative citoyenne européenne",
      "Motion de censure",
      "Droit de retrait",
    ],
    answer: "Initiative citoyenne européenne",
    explanation: "Elle invite la Commission à examiner une proposition.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à un agent public de participer à une élection (vote) ?",
    options: ["Liberté d’opinion", "Devoir de réserve", "Secret professionnel"],
    answer: "Liberté d’opinion",
    explanation: "Les agents disposent des droits civiques comme tout citoyen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe oblige l’administration à traiter de manière identique des candidats à compétences égales ?",
    options: ["Égal accès aux emplois publics", "Primauté", "Continuité"],
    answer: "Égal accès aux emplois publics",
    explanation: "Principe constitutionnel d’égalité dans le recrutement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose à l’agent public de ne pas afficher ses opinions politiques dans le service ?",
    options: ["Neutralité", "Droit syndical", "Mutabilité"],
    answer: "Neutralité",
    explanation: "Elle garantit l’impartialité du service rendu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose une modération particulière sur les réseaux sociaux pour certains agents ?",
    options: [
      "Devoir de réserve",
      "Liberté d’expression totale",
      "Secret parlementaire",
    ],
    answer: "Devoir de réserve",
    explanation: "Il varie selon les fonctions et le niveau de responsabilité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir interdit d’accepter des cadeaux pouvant influencer une décision ?",
    options: ["Probité", "Mutabilité", "Neutralité"],
    answer: "Probité",
    explanation: "Il vise à prévenir la corruption et les conflits d’intérêts.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à un agent public d’être assisté en cas de procédure disciplinaire ?",
    options: ["Droits de la défense", "Droit de retrait", "Droit à l’oubli"],
    answer: "Droits de la défense",
    explanation: "Accès au dossier et possibilité de se faire assister.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel est le nom de la notion qui impose de servir l’intérêt général avant l’intérêt personnel ?",
    options: ["Loyauté", "Primauté", "Centralisation"],
    answer: "Loyauté",
    explanation: "L’agent doit agir dans l’intérêt du service.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit protège un agent public lorsqu’il est attaqué pour des faits liés au service ?",
    options: ["Protection fonctionnelle", "Droit de grève", "Droit de retrait"],
    answer: "Protection fonctionnelle",
    explanation:
        "L’administration peut prendre en charge la défense et les frais.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel niveau de collectivité exerce principalement la compétence de l’action sociale (ASE, RSA) ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation:
        "Le département est un acteur central des politiques sociales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel niveau de collectivité a la compétence des transports régionaux (ex : TER) ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "La région organise les transports régionaux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel principe garantit que les collectivités ont des compétences propres ?",
    options: ["Libre administration", "Tutelle", "Primauté de l’État"],
    answer: "Libre administration",
    explanation:
        "Les collectivités s’administrent librement par des conseils élus.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel acte permet au maire d’encadrer la circulation sur sa commune ?",
    options: ["Arrêté municipal", "Décret", "Ordonnance"],
    answer: "Arrêté municipal",
    explanation: "Le maire dispose d’un pouvoir de police administrative.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel organe vote le budget d’une région ?",
    options: [
      "Conseil régional",
      "Préfet de région",
      "Président du département",
    ],
    answer: "Conseil régional",
    explanation: "L’organe délibérant adopte le budget régional.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole républicain apparaît sur de nombreuses pièces françaises en euro ?",
    options: ["Marianne", "Le lys", "L’aigle"],
    answer: "Marianne",
    explanation: "Marianne incarne la République française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quelle cérémonie honore la mémoire des morts pour la France le 11 novembre ?",
    options: [
      "Commémoration de l’Armistice",
      "Fête nationale",
      "Journée de la laïcité",
    ],
    answer: "Commémoration de l’Armistice",
    explanation: "Elle marque la fin de la Première Guerre mondiale en 1918.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole est gravé sur de nombreux frontons de bâtiments publics ?",
    options: [
      "Liberté, Égalité, Fraternité",
      "Dieu et Patrie",
      "Force et Honneur",
    ],
    answer: "Liberté, Égalité, Fraternité",
    explanation: "Devise officielle de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe garantit que les pouvoirs publics sont contrôlables par le juge ?",
    options: [
      "État de droit",
      "Souveraineté administrative",
      "Tutelle nationale",
    ],
    answer: "État de droit",
    explanation:
        "Le pouvoir est soumis à la loi et au contrôle juridictionnel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe vise à protéger les citoyens contre des décisions arbitraires ?",
    options: ["Sécurité juridique", "Centralisation", "Primauté"],
    answer: "Sécurité juridique",
    explanation: "Les règles doivent être stables, accessibles et prévisibles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe signifie que personne n’est au-dessus de la loi ?",
    options: [
      "Principe de légalité",
      "Principe d’opportunité",
      "Principe de privilège",
    ],
    answer: "Principe de légalité",
    explanation: "Toute action publique doit respecter la loi.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen adopte les orientations générales sans voter de lois ?",
    options: [
      "Conseil européen",
      "Parlement européen",
      "Commission européenne",
    ],
    answer: "Conseil européen",
    explanation: "Il fixe les grandes orientations politiques de l’Union.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen représente les États membres au niveau des chefs d’État ou de gouvernement ?",
    options: ["Conseil européen", "Conseil de l’UE", "Parlement européen"],
    answer: "Conseil européen",
    explanation: "Il réunit les dirigeants des États membres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen participe à l’adoption du budget annuel de l’Union ?",
    options: ["Parlement européen", "BCE", "Eurojust"],
    answer: "Parlement européen",
    explanation: "Il vote le budget avec le Conseil de l’UE.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen représente les gouvernements nationaux dans la procédure législative ?",
    options: [
      "Conseil de l’Union européenne",
      "Conseil européen",
      "Commission européenne",
    ],
    answer: "Conseil de l’Union européenne",
    explanation: "Il co-légifère avec le Parlement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut saisir la CJUE contre un État membre ?",
    options: [
      "Commission européenne",
      "Parlement européen",
      "Comité des régions",
    ],
    answer: "Commission européenne",
    explanation: "Elle engage les procédures en manquement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen tranche les litiges entre institutions et États membres ?",
    options: ["CJUE", "Cour des comptes", "Eurogroupe"],
    answer: "CJUE",
    explanation: "Elle interprète et applique le droit de l’Union.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne est indépendante des gouvernements nationaux ?",
    options: ["BCE", "Conseil de l’UE", "Conseil européen"],
    answer: "BCE",
    explanation: "Son indépendance est garantie par les traités.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel document juridique européen est directement applicable dans les États membres ?",
    options: ["Règlement", "Directive", "Avis"],
    answer: "Règlement",
    explanation: "Il s’applique sans transposition nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel acte européen fixe un objectif à atteindre tout en laissant le choix des moyens ?",
    options: ["Directive", "Règlement", "Décision"],
    answer: "Directive",
    explanation: "Elle nécessite une transposition nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen est composé d’un commissaire par État membre ?",
    options: ["Commission européenne", "Conseil européen", "CJUE"],
    answer: "Commission européenne",
    explanation: "Chaque État y est représenté par un commissaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe impose l’impartialité de l’administration ?",
    options: ["Neutralité", "Mutabilité", "Autonomie"],
    answer: "Neutralité",
    explanation: "L’administration ne favorise aucune opinion.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose que le service public fonctionne sans interruption ?",
    options: ["Continuité", "Égalité", "Libre administration"],
    answer: "Continuité",
    explanation: "Principe fondamental du service public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à l’agent de signaler un danger grave pour sa santé ?",
    options: ["Droit de retrait", "Droit syndical", "Droit disciplinaire"],
    answer: "Droit de retrait",
    explanation: "Il peut se retirer d’une situation dangereuse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose à l’agent de respecter la hiérarchie administrative ?",
    options: ["Obéissance hiérarchique", "Loyauté", "Neutralité"],
    answer: "Obéissance hiérarchique",
    explanation: "Sous réserve de l’illégalité manifeste.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose une conduite exemplaire même en dehors du service ?",
    options: ["Dignité", "Continuité", "Mutabilité"],
    answer: "Dignité",
    explanation: "Le comportement ne doit pas porter atteinte à la fonction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit protège l’agent contre les discriminations professionnelles ?",
    options: ["Égalité de traitement", "Primauté", "Secret professionnel"],
    answer: "Égalité de traitement",
    explanation:
        "Aucune discrimination ne peut être fondée sur l’origine ou les opinions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité territoriale dispose de la clause de compétence générale ?",
    options: ["Commune", "État", "Union européenne"],
    answer: "Commune",
    explanation: "Elle peut intervenir pour tout intérêt local.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel organe représente l’État dans la région ?",
    options: ["Préfet de région", "Président du conseil régional", "Maire"],
    answer: "Préfet de région",
    explanation: "Il coordonne les services de l’État.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel type de collectivité exerce des compétences transférées par l’État ?",
    options: [
      "Collectivité territoriale",
      "Autorité judiciaire",
      "Institution européenne",
    ],
    answer: "Collectivité territoriale",
    explanation: "Dans le cadre de la décentralisation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel document fixe les orientations d’aménagement d’un territoire communal ?",
    options: ["PLU", "PDU", "SRADDET"],
    answer: "PLU",
    explanation: "Plan local d’urbanisme.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel organe intercommunal exerce des compétences à la place des communes membres ?",
    options: ["EPCI", "Département", "Région"],
    answer: "EPCI",
    explanation: "Compétences transférées par les communes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole représente la vigilance et la liberté dans l’imaginaire républicain ?",
    options: ["Le coq", "Le lys", "L’aigle"],
    answer: "Le coq",
    explanation: "Symbole historique associé à la France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel monument parisien symbolise la reconnaissance de la Nation envers les grands hommes ?",
    options: ["Panthéon", "Louvre", "Invalides"],
    answer: "Panthéon",
    explanation: "Il abrite les restes de grandes figures nationales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel texte est affiché dans les écoles publiques françaises ?",
    options: [
      "Déclaration des droits de l’homme et du citoyen",
      "Code pénal",
      "Code civil",
    ],
    answer: "Déclaration des droits de l’homme et du citoyen",
    explanation: "Texte fondamental de 1789.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe garantit la liberté de croyance et de non-croyance ?",
    options: ["Laïcité", "Neutralité", "Primauté"],
    answer: "Laïcité",
    explanation: "Principe constitutionnel depuis 1958.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe impose que les normes inférieures respectent les normes supérieures ?",
    options: ["Hiérarchie des normes", "Subsidiarité", "Mutabilité"],
    answer: "Hiérarchie des normes",
    explanation: "Principe fondamental du droit public.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe protège les droits fondamentaux contre les abus du pouvoir ?",
    options: ["État de droit", "Autorité administrative", "Centralisation"],
    answer: "État de droit",
    explanation: "Le pouvoir est limité par la loi et le juge.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen valide la nomination du président de la Commission européenne ?",
    options: ["Parlement européen", "Conseil de l’Union européenne", "CJUE"],
    answer: "Parlement européen",
    explanation:
        "Le président de la Commission doit être approuvé par le Parlement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne fixe les grandes orientations de la politique étrangère de l’UE ?",
    options: [
      "Conseil européen",
      "Commission européenne",
      "Parlement européen",
    ],
    answer: "Conseil européen",
    explanation: "Il définit les orientations stratégiques générales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen contrôle la conformité des lois nationales au droit de l’UE ?",
    options: ["CJUE", "Cour des comptes", "Parlement européen"],
    answer: "CJUE",
    explanation:
        "La Cour de justice garantit l’application uniforme du droit de l’Union.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne prépare le projet de budget annuel de l’Union ?",
    options: [
      "Commission européenne",
      "Conseil européen",
      "Parlement européen",
    ],
    answer: "Commission européenne",
    explanation:
        "Elle élabore le projet soumis ensuite au Conseil et au Parlement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut infliger des amendes pour infraction aux règles de concurrence ?",
    options: ["Commission européenne", "CJUE", "Conseil européen"],
    answer: "Commission européenne",
    explanation:
        "Elle dispose de pouvoirs de sanction en matière de concurrence.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen représente les intérêts des collectivités locales ?",
    options: ["Comité des régions", "CESE", "Conseil de l’UE"],
    answer: "Comité des régions",
    explanation:
        "Il est consulté sur les politiques affectant les territoires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne représente les partenaires économiques et sociaux ?",
    options: ["CESE européen", "Comité des régions", "CJUE"],
    answer: "CESE européen",
    explanation: "Il rassemble employeurs, salariés et autres acteurs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen statue en dernier ressort sur l’interprétation des traités ?",
    options: ["CJUE", "Parlement européen", "Conseil européen"],
    answer: "CJUE",
    explanation: "Ses arrêts s’imposent aux juridictions nationales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne est composée de juges nommés par les États membres ?",
    options: ["CJUE", "Commission européenne", "BCE"],
    answer: "CJUE",
    explanation: "Chaque État y désigne un juge.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel mécanisme permet à la Commission de sanctionner un État membre ?",
    options: [
      "Procédure en manquement",
      "Motion de censure",
      "Initiative citoyenne",
    ],
    answer: "Procédure en manquement",
    explanation: "Elle peut aboutir à une condamnation par la CJUE.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe garantit la neutralité politique du service public ?",
    options: ["Neutralité", "Continuité", "Mutabilité"],
    answer: "Neutralité",
    explanation: "Le service public ne favorise aucune opinion.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose un traitement identique des usagers dans une même situation ?",
    options: ["Égalité", "Autonomie", "Primauté"],
    answer: "Égalité",
    explanation: "Principe fondamental du service public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe justifie l’adaptation d’un service public aux évolutions sociales ?",
    options: ["Mutabilité", "Continuité", "Neutralité"],
    answer: "Mutabilité",
    explanation: "Le service doit évoluer selon les besoins.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe impose la permanence du service public ?",
    options: ["Continuité", "Égalité", "Loyauté"],
    answer: "Continuité",
    explanation: "Certains services doivent fonctionner sans interruption.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose à l’agent de ne pas divulguer des informations sensibles ?",
    options: ["Secret professionnel", "Droit syndical", "Droit de grève"],
    answer: "Secret professionnel",
    explanation: "Il protège des informations légalement protégées.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose une conduite irréprochable dans et hors service ?",
    options: ["Dignité", "Continuité", "Mutabilité"],
    answer: "Dignité",
    explanation: "Le comportement doit être compatible avec la fonction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à un agent public d’exprimer ses opinions personnelles hors service ?",
    options: ["Liberté d’opinion", "Devoir de réserve", "Neutralité"],
    answer: "Liberté d’opinion",
    explanation: "Elle s’exerce dans les limites du devoir de réserve.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit protège un agent public contre les attaques liées à ses fonctions ?",
    options: [
      "Protection fonctionnelle",
      "Droit de retrait",
      "Droit disciplinaire",
    ],
    answer: "Protection fonctionnelle",
    explanation: "L’administration peut assurer sa défense.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel devoir impose à l’agent de servir l’intérêt général ?",
    options: ["Loyauté", "Primauté", "Subsidiarité"],
    answer: "Loyauté",
    explanation: "L’agent agit pour le service public.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité territoriale gère principalement l’entretien des collèges ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation: "Les collèges relèvent du département.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité territoriale gère les transports interurbains régionaux ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "La région est compétente pour les transports régionaux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité territoriale est dirigée par un maire ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation: "Le maire est l’exécutif communal.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel organe vote les délibérations d’un département ?",
    options: ["Conseil départemental", "Préfet", "Président de région"],
    answer: "Conseil départemental",
    explanation: "Il est l’organe délibérant du département.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel principe garantit l’autonomie décisionnelle des collectivités ?",
    options: ["Libre administration", "Tutelle", "Centralisation"],
    answer: "Libre administration",
    explanation: "Principe constitutionnel de la décentralisation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole est associé à la vigilance et à la fierté nationale ?",
    options: ["Le coq", "Le lys", "L’aigle"],
    answer: "Le coq",
    explanation: "Symbole historique de la France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel monument accueille les cendres de personnalités honorées par la Nation ?",
    options: ["Panthéon", "Invalides", "Arc de Triomphe"],
    answer: "Panthéon",
    explanation:
        "Il rend hommage aux grands personnages de l’histoire française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel texte de 1789 fonde les libertés publiques françaises ?",
    options: [
      "Déclaration des droits de l’homme et du citoyen",
      "Constitution de 1958",
      "Code civil",
    ],
    answer: "Déclaration des droits de l’homme et du citoyen",
    explanation: "Texte fondateur de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel jour célèbre-t-on la République française ?",
    options: ["14 juillet", "1er mai", "11 novembre"],
    answer: "14 juillet",
    explanation: "Commémoration de la prise de la Bastille.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe garantit la liberté de conscience et la neutralité de l’État ?",
    options: ["Laïcité", "Primauté", "Centralisation"],
    answer: "Laïcité",
    explanation: "Principe constitutionnel fondamental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe impose que les lois soient claires et prévisibles ?",
    options: ["Sécurité juridique", "Subsidiarité", "Tutelle"],
    answer: "Sécurité juridique",
    explanation: "Il protège les citoyens contre l’arbitraire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe signifie que l’administration doit respecter la loi ?",
    options: [
      "Principe de légalité",
      "Principe d’opportunité",
      "Principe de souveraineté",
    ],
    answer: "Principe de légalité",
    explanation: "Toute action administrative doit être conforme à la loi.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen adopte formellement les directives et règlements avec le Parlement ?",
    options: [
      "Conseil de l’Union européenne",
      "Conseil européen",
      "Commission européenne",
    ],
    answer: "Conseil de l’Union européenne",
    explanation: "Il co-légifère avec le Parlement européen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen ne dispose d’aucun pouvoir législatif direct ?",
    options: ["Conseil européen", "Parlement européen", "Conseil de l’UE"],
    answer: "Conseil européen",
    explanation: "Il donne une impulsion politique sans voter de lois.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen est responsable de la négociation des accords commerciaux internationaux ?",
    options: ["Commission européenne", "Parlement européen", "CJUE"],
    answer: "Commission européenne",
    explanation: "Elle négocie au nom de l’Union sur mandat du Conseil.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne peut être saisie par un juge national pour interprétation du droit de l’UE ?",
    options: ["CJUE", "Cour des comptes", "BCE"],
    answer: "CJUE",
    explanation: "Dans le cadre de la question préjudicielle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen est chargé de l’audit externe des finances de l’Union ?",
    options: ["Cour des comptes européenne", "CJUE", "Eurostat"],
    answer: "Cour des comptes européenne",
    explanation: "Elle contrôle la régularité et la bonne gestion des fonds.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen réunit les ministres des Finances de la zone euro ?",
    options: ["Eurogroupe", "Conseil européen", "BCE"],
    answer: "Eurogroupe",
    explanation:
        "Il coordonne les politiques économiques des États de la zone euro.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel traité a instauré la citoyenneté européenne ?",
    options: ["Traité de Maastricht", "Traité de Rome", "Traité de Nice"],
    answer: "Traité de Maastricht",
    explanation: "Il a créé l’Union européenne en 1992.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel droit permet à un citoyen européen de voter aux élections municipales dans un autre État membre ?",
    options: [
      "Citoyenneté européenne",
      "Droit de subsidiarité",
      "Principe de primauté",
    ],
    answer: "Citoyenneté européenne",
    explanation: "Droit attaché au statut de citoyen de l’Union.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quelle institution européenne fixe les taux directeurs ?",
    options: ["BCE", "Commission européenne", "Eurogroupe"],
    answer: "BCE",
    explanation: "Elle conduit la politique monétaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut être dissous avant la fin de son mandat ?",
    options: ["Parlement européen", "Commission européenne", "CJUE"],
    answer: "Commission européenne",
    explanation: "Par une motion de censure du Parlement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe garantit l’accès aux emplois publics selon le mérite ?",
    options: ["Égal accès aux emplois publics", "Primauté", "Continuité"],
    answer: "Égal accès aux emplois publics",
    explanation: "Principe constitutionnel fondamental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe interdit toute discrimination entre agents à situation équivalente ?",
    options: ["Égalité de traitement", "Neutralité", "Loyauté"],
    answer: "Égalité de traitement",
    explanation: "Il garantit l’équité dans la fonction publique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose de ne pas nuire à l’image de l’administration ?",
    options: ["Dignité", "Mutabilité", "Autonomie"],
    answer: "Dignité",
    explanation: "Il s’applique dans et hors service.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose de signaler un conflit d’intérêts potentiel ?",
    options: ["Probité", "Neutralité", "Continuité"],
    answer: "Probité",
    explanation: "Il vise à prévenir toute atteinte à l’impartialité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet aux agents de défendre collectivement leurs intérêts professionnels ?",
    options: ["Droit syndical", "Droit de retrait", "Droit disciplinaire"],
    answer: "Droit syndical",
    explanation: "Il est garanti par le statut général.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose de respecter les décisions de la hiérarchie administrative ?",
    options: ["Obéissance hiérarchique", "Liberté d’opinion", "Droit de grève"],
    answer: "Obéissance hiérarchique",
    explanation: "Sauf ordre manifestement illégal.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit protège un agent poursuivi pénalement pour des faits liés au service ?",
    options: [
      "Protection fonctionnelle",
      "Droit syndical",
      "Secret professionnel",
    ],
    answer: "Protection fonctionnelle",
    explanation: "L’administration peut assurer sa défense.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose une stricte impartialité religieuse de l’administration ?",
    options: ["Neutralité", "Laïcité", "Mutabilité"],
    answer: "Neutralité",
    explanation: "Les agents ne manifestent pas leurs convictions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité territoriale dispose d’un pouvoir de police municipale ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation: "Exercé par le maire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel niveau de collectivité est compétent pour la voirie départementale ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation: "Il gère les routes départementales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel document régional planifie l’aménagement durable du territoire ?",
    options: ["SRADDET", "PLU", "PDU"],
    answer: "SRADDET",
    explanation:
        "Schéma régional d’aménagement, de développement durable et d’égalité des territoires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel principe impose que l’État ne contrôle pas a priori les actes locaux ?",
    options: ["Libre administration", "Tutelle", "Centralisation"],
    answer: "Libre administration",
    explanation: "Le contrôle est exercé a posteriori.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel organe exécute les décisions du conseil municipal ?",
    options: ["Maire", "Préfet", "Conseil départemental"],
    answer: "Maire",
    explanation: "Il est l’exécutif de la commune.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel symbole figure sur les frontons des mairies françaises ?",
    options: ["Devise républicaine", "Blason royal", "Croix chrétienne"],
    answer: "Devise républicaine",
    explanation: "Liberté, Égalité, Fraternité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel monument parisien abrite la tombe du Soldat inconnu ?",
    options: ["Arc de Triomphe", "Panthéon", "Invalides"],
    answer: "Arc de Triomphe",
    explanation: "Il symbolise la mémoire nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole républicain est utilisé lors des cérémonies officielles ?",
    options: ["Drapeau tricolore", "Bonnet phrygien", "Balance"],
    answer: "Drapeau tricolore",
    explanation: "Symbole national de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel chant républicain est entonné lors des événements sportifs internationaux ?",
    options: ["La Marseillaise", "L’Ode à la joie", "Le Chant du départ"],
    answer: "La Marseillaise",
    explanation: "Hymne national français.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe impose que toute décision administrative puisse être contestée ?",
    options: ["Droit au recours", "Primauté", "Centralisation"],
    answer: "Droit au recours",
    explanation: "Garantie fondamentale de l’État de droit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe garantit l’indépendance de l’autorité judiciaire ?",
    options: ["Séparation des pouvoirs", "Primauté", "Subsidiarité"],
    answer: "Séparation des pouvoirs",
    explanation: "Elle empêche l’ingérence des autres pouvoirs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe interdit toute détention arbitraire ?",
    options: ["Liberté individuelle", "Sécurité juridique", "Autorité"],
    answer: "Liberté individuelle",
    explanation: "Protégée par l’autorité judiciaire.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen adopte le cadre financier pluriannuel de l’Union ?",
    options: ["Conseil de l’Union européenne", "Commission européenne", "BCE"],
    answer: "Conseil de l’Union européenne",
    explanation: "Il fixe le budget à long terme avec l’accord du Parlement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel document fixe les priorités budgétaires de l’Union pour plusieurs années ?",
    options: [
      "Cadre financier pluriannuel",
      "Budget annuel",
      "Agenda stratégique",
    ],
    answer: "Cadre financier pluriannuel",
    explanation: "Il encadre les dépenses de l’UE sur 7 ans.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne peut être saisie par un État contre un autre État membre ?",
    options: ["CJUE", "Commission européenne", "Parlement européen"],
    answer: "CJUE",
    explanation: "Elle règle les différends entre États membres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen assure la surveillance macroéconomique des États membres ?",
    options: ["Commission européenne", "BCE", "Cour des comptes"],
    answer: "Commission européenne",
    explanation: "Elle analyse les politiques budgétaires nationales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel mécanisme européen vise à coordonner les politiques économiques nationales ?",
    options: ["Semestre européen", "Eurojust", "Frontex"],
    answer: "Semestre européen",
    explanation:
        "Il permet une coordination annuelle des politiques économiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen adopte des recommandations économiques aux États ?",
    options: ["Conseil de l’UE", "BCE", "Parlement européen"],
    answer: "Conseil de l’UE",
    explanation: "Sur proposition de la Commission.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen représente les citoyens dans la procédure budgétaire ?",
    options: ["Parlement européen", "Conseil européen", "Eurogroupe"],
    answer: "Parlement européen",
    explanation: "Il vote le budget avec le Conseil.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne peut refuser la décharge budgétaire ?",
    options: ["Parlement européen", "Commission européenne", "BCE"],
    answer: "Parlement européen",
    explanation: "Il contrôle l’exécution du budget.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel organe européen est compétent pour les aides d’État ?",
    options: ["Commission européenne", "CJUE", "Conseil européen"],
    answer: "Commission européenne",
    explanation: "Elle contrôle la concurrence loyale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel principe impose aux États de respecter les objectifs européens communs ?",
    options: ["Coopération loyale", "Centralisation", "Tutelle"],
    answer: "Coopération loyale",
    explanation: "Principe fondamental du droit de l’Union.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe interdit toute distinction fondée sur les convictions personnelles des usagers ?",
    options: ["Neutralité", "Mutabilité", "Continuité"],
    answer: "Neutralité",
    explanation: "Le service public est impartial.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe protège les agents contre les pressions politiques ?",
    options: ["Neutralité", "Primauté", "Autonomie"],
    answer: "Neutralité",
    explanation: "L’agent exerce ses missions sans influence partisane.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose un fonctionnement régulier des services essentiels ?",
    options: ["Continuité", "Libre administration", "Subsidiarité"],
    answer: "Continuité",
    explanation: "Certains services ne peuvent être interrompus.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe permet l’évolution de l’organisation administrative ?",
    options: ["Mutabilité", "Neutralité", "Égalité"],
    answer: "Mutabilité",
    explanation: "Le service public s’adapte aux besoins.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel devoir impose la transparence des intérêts personnels ?",
    options: ["Probité", "Dignité", "Obéissance"],
    answer: "Probité",
    explanation: "Il vise à prévenir les conflits d’intérêts.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose de ne pas utiliser sa fonction à des fins privées ?",
    options: ["Probité", "Neutralité", "Réserve"],
    answer: "Probité",
    explanation: "L’agent agit exclusivement dans l’intérêt général.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel devoir impose une attitude respectueuse envers le public ?",
    options: ["Dignité", "Mutabilité", "Primauté"],
    answer: "Dignité",
    explanation: "Le comportement doit être exemplaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à l’agent de défendre ses intérêts collectifs ?",
    options: ["Droit syndical", "Droit disciplinaire", "Droit de retrait"],
    answer: "Droit syndical",
    explanation: "Liberté fondamentale reconnue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit garantit la protection de l’agent contre les menaces ?",
    options: [
      "Protection fonctionnelle",
      "Liberté d’opinion",
      "Secret professionnel",
    ],
    answer: "Protection fonctionnelle",
    explanation: "L’administration soutient l’agent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel droit impose le respect de la défense en cas de sanction ?",
    options: ["Droits de la défense", "Droit de grève", "Droit de retrait"],
    answer: "Droits de la défense",
    explanation: "Principe fondamental du droit disciplinaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité territoriale est responsable de l’état civil ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation: "Le maire agit comme officier d’état civil.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité gère l’entretien des routes départementales ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation: "Compétence départementale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité planifie l’aménagement régional du territoire ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "Via des schémas régionaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel principe garantit l’absence de tutelle a priori de l’État ?",
    options: ["Libre administration", "Centralisation", "Hiérarchie"],
    answer: "Libre administration",
    explanation: "Le contrôle est exercé après l’acte.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel organe vote les décisions d’une intercommunalité ?",
    options: ["Conseil communautaire", "Maire", "Préfet"],
    answer: "Conseil communautaire",
    explanation: "Organe délibérant des EPCI.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole incarne la souveraineté nationale lors des cérémonies ?",
    options: ["Drapeau tricolore", "Balance", "Bonnet phrygien"],
    answer: "Drapeau tricolore",
    explanation: "Symbole officiel de la Nation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel symbole féminin représente la République française ?",
    options: ["Marianne", "Jeanne d’Arc", "Libertas"],
    answer: "Marianne",
    explanation: "Allégorie républicaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel texte est souvent affiché dans les bâtiments publics ?",
    options: [
      "Déclaration des droits de l’homme et du citoyen",
      "Code du travail",
      "Code pénal",
    ],
    answer: "Déclaration des droits de l’homme et du citoyen",
    explanation: "Texte fondamental de 1789.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quelle journée célèbre les valeurs de la République dans les écoles ?",
    options: ["9 décembre", "14 juillet", "8 mai"],
    answer: "9 décembre",
    explanation: "Journée de la laïcité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe garantit la soumission de l’administration au juge ?",
    options: ["État de droit", "Tutelle", "Centralisation"],
    answer: "État de droit",
    explanation: "Le pouvoir est contrôlé juridiquement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe impose la clarté et l’accessibilité des normes ?",
    options: ["Sécurité juridique", "Neutralité", "Subsidiarité"],
    answer: "Sécurité juridique",
    explanation: "Principe protecteur des citoyens.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe empêche la concentration du pouvoir entre les mêmes mains ?",
    options: ["Séparation des pouvoirs", "Primauté", "Centralisation"],
    answer: "Séparation des pouvoirs",
    explanation: "Fondement de la démocratie.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut adopter des recommandations non contraignantes ?",
    options: ["Conseil de l’Union européenne", "CJUE", "BCE"],
    answer: "Conseil de l’Union européenne",
    explanation: "Les recommandations n’ont pas de force obligatoire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne assure la représentation extérieure de l’UE dans certains domaines ?",
    options: [
      "Commission européenne",
      "Parlement européen",
      "Comité des régions",
    ],
    answer: "Commission européenne",
    explanation:
        "Elle représente l’UE notamment dans les négociations commerciales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen est compétent pour interpréter les traités fondateurs ?",
    options: ["CJUE", "Conseil européen", "Eurogroupe"],
    answer: "CJUE",
    explanation: "Elle garantit une interprétation uniforme du droit de l’UE.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel document européen fixe les règles budgétaires des États membres ?",
    options: [
      "Pacte de stabilité et de croissance",
      "Agenda stratégique",
      "Livre blanc",
    ],
    answer: "Pacte de stabilité et de croissance",
    explanation: "Il encadre les déficits et la dette publique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen valide l’adhésion d’un nouvel État membre ?",
    options: ["Conseil européen", "Commission européenne", "CJUE"],
    answer: "Conseil européen",
    explanation: "Il statue à l’unanimité sur les adhésions.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe impose un traitement impartial des usagers ?",
    options: ["Neutralité", "Autonomie", "Mutabilité"],
    answer: "Neutralité",
    explanation: "Aucune opinion ne doit influencer le service rendu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe garantit la permanence du service public malgré les conflits sociaux ?",
    options: ["Continuité", "Égalité", "Loyauté"],
    answer: "Continuité",
    explanation: "Certains services doivent rester opérationnels.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose à l’agent d’exercer ses missions avec honnêteté ?",
    options: ["Probité", "Mutabilité", "Réserve"],
    answer: "Probité",
    explanation: "Il exclut tout enrichissement personnel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose de garder confidentielles certaines informations ?",
    options: ["Secret professionnel", "Neutralité", "Loyauté"],
    answer: "Secret professionnel",
    explanation: "Il protège des informations sensibles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit protège l’agent public en cas de poursuites liées au service ?",
    options: ["Protection fonctionnelle", "Droit syndical", "Droit de retrait"],
    answer: "Protection fonctionnelle",
    explanation: "L’administration peut prendre en charge la défense.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité territoriale gère les bibliothèques municipales ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation: "Compétence culturelle communale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité territoriale gère les archives départementales ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation: "Compétence patrimoniale départementale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel niveau de collectivité est compétent pour les politiques de formation professionnelle ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "La région pilote la formation et l’apprentissage.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel document communal organise l’occupation des sols ?",
    options: ["PLU", "SRADDET", "PDU"],
    answer: "PLU",
    explanation: "Plan local d’urbanisme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quel principe permet aux collectivités d’exercer leurs compétences librement ?",
    options: ["Libre administration", "Tutelle", "Centralisation"],
    answer: "Libre administration",
    explanation: "Principe constitutionnel de la décentralisation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel symbole républicain est associé à la justice ?",
    options: ["Balance", "Coq", "Bonnet phrygien"],
    answer: "Balance",
    explanation: "Symbole de l’équilibre et de l’impartialité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel monument honore les morts pour la France à Paris ?",
    options: ["Arc de Triomphe", "Panthéon", "Louvre"],
    answer: "Arc de Triomphe",
    explanation: "Il abrite la tombe du Soldat inconnu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quelle journée nationale célèbre le travail ?",
    options: ["1er mai", "14 juillet", "11 novembre"],
    answer: "1er mai",
    explanation: "Fête du Travail.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe garantit la liberté de réunion et d’association ?",
    options: ["Libertés publiques", "Autorité", "Primauté"],
    answer: "Libertés publiques",
    explanation: "Elles sont protégées constitutionnellement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe garantit que nul n’est au-dessus de la loi ?",
    options: [
      "Principe de légalité",
      "Primauté administrative",
      "Centralisation",
    ],
    answer: "Principe de légalité",
    explanation: "La loi s’impose à tous.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen adopte les lignes directrices de la politique économique générale ?",
    options: ["Conseil européen", "Commission européenne", "BCE"],
    answer: "Conseil européen",
    explanation: "Il fixe les grandes orientations économiques et politiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne peut proposer des sanctions financières à un État membre ?",
    options: ["Commission européenne", "Parlement européen", "Eurogroupe"],
    answer: "Commission européenne",
    explanation:
        "Elle peut saisir la CJUE dans le cadre d’une procédure en manquement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen coordonne les politiques budgétaires de la zone euro ?",
    options: ["Eurogroupe", "BCE", "Conseil européen"],
    answer: "Eurogroupe",
    explanation:
        "Il réunit les ministres des Finances des États de la zone euro.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne assure la stabilité financière de la zone euro ?",
    options: ["BCE", "Commission européenne", "Cour des comptes"],
    answer: "BCE",
    explanation: "Elle conduit la politique monétaire de la zone euro.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut adopter des résolutions politiques sans force juridique ?",
    options: ["Parlement européen", "CJUE", "Conseil de l’UE"],
    answer: "Parlement européen",
    explanation: "Les résolutions expriment une position politique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen représente l’Union lors des sommets internationaux ?",
    options: ["Conseil européen", "Parlement européen", "Eurostat"],
    answer: "Conseil européen",
    explanation: "Il incarne la représentation politique au plus haut niveau.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quelle institution européenne peut être saisie par un citoyen pour violation du droit européen ?",
    options: ["Commission européenne", "BCE", "Eurogroupe"],
    answer: "Commission européenne",
    explanation: "Elle peut engager une procédure en manquement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen statue sur les recours en annulation des actes de l’UE ?",
    options: ["CJUE", "Cour des comptes", "Parlement européen"],
    answer: "CJUE",
    explanation: "Elle contrôle la légalité des actes européens.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question: "Quel acte européen n’a aucune force obligatoire ?",
    options: ["Avis", "Directive", "Règlement"],
    answer: "Avis",
    explanation: "Les avis et recommandations sont non contraignants.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Institutions européennes — UE",
    question:
        "Quel organe européen peut modifier sa propre organisation interne ?",
    options: ["Parlement européen", "CJUE", "Conseil européen"],
    answer: "Parlement européen",
    explanation: "Il adopte son règlement intérieur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe garantit la neutralité idéologique du service public ?",
    options: ["Neutralité", "Mutabilité", "Autonomie"],
    answer: "Neutralité",
    explanation: "Le service public est indépendant des opinions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel principe impose une adaptation permanente du service public ?",
    options: ["Mutabilité", "Continuité", "Primauté"],
    answer: "Mutabilité",
    explanation: "Le service évolue avec les besoins des usagers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel principe impose un accès égal aux services publics ?",
    options: ["Égalité", "Neutralité", "Hiérarchie"],
    answer: "Égalité",
    explanation: "Même situation, même traitement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir interdit à l’agent de divulguer des informations protégées ?",
    options: ["Secret professionnel", "Devoir de réserve", "Loyauté"],
    answer: "Secret professionnel",
    explanation: "Il protège les informations sensibles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel devoir impose une conduite respectueuse envers les usagers ?",
    options: ["Dignité", "Probité", "Neutralité"],
    answer: "Dignité",
    explanation: "Le comportement doit être exemplaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question: "Quel devoir impose de servir exclusivement l’intérêt général ?",
    options: ["Loyauté", "Primauté", "Subsidiarité"],
    answer: "Loyauté",
    explanation: "L’agent agit pour le service public.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit permet à un agent de se défendre avant une sanction ?",
    options: ["Droits de la défense", "Droit de retrait", "Droit syndical"],
    answer: "Droits de la défense",
    explanation: "Principe fondamental du droit disciplinaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Fonction publique — France",
    question:
        "Quel droit protège l’agent public contre les violences subies en service ?",
    options: ["Protection fonctionnelle", "Droit de grève", "Neutralité"],
    answer: "Protection fonctionnelle",
    explanation: "L’administration soutient l’agent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question:
        "Quelle collectivité territoriale est compétente pour les écoles maternelles et primaires ?",
    options: ["Commune", "Département", "Région"],
    answer: "Commune",
    explanation: "Compétence éducative communale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité territoriale gère les collèges ?",
    options: ["Département", "Région", "Commune"],
    answer: "Département",
    explanation: "Les collèges relèvent du département.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quelle collectivité territoriale gère les lycées ?",
    options: ["Région", "Département", "Commune"],
    answer: "Région",
    explanation: "Compétence régionale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel organe délibérant adopte les décisions communales ?",
    options: ["Conseil municipal", "Maire", "Préfet"],
    answer: "Conseil municipal",
    explanation: "Il est élu par les citoyens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Décentralisation — Collectivités",
    question: "Quel principe constitutionnel fonde la décentralisation ?",
    options: ["Libre administration", "Centralisation", "Tutelle"],
    answer: "Libre administration",
    explanation: "Les collectivités s’administrent librement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question: "Quel symbole républicain incarne la liberté ?",
    options: ["Bonnet phrygien", "Coq", "Balance"],
    answer: "Bonnet phrygien",
    explanation: "Symbole hérité de la Révolution.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel monument symbolise la mémoire des combattants morts pour la France ?",
    options: ["Arc de Triomphe", "Panthéon", "Invalides"],
    answer: "Arc de Triomphe",
    explanation: "Il abrite la tombe du Soldat inconnu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Symboles de la République — France",
    question:
        "Quel symbole est présent sur le sceau officiel de la République ?",
    options: ["Marianne", "Coq", "Aigle"],
    answer: "Marianne",
    explanation: "Allégorie de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question: "Quel principe garantit l’égalité de tous devant la loi ?",
    options: ["Égalité", "Neutralité", "Centralisation"],
    answer: "Égalité",
    explanation: "Principe fondamental de la République.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe protège les citoyens contre l’arbitraire administratif ?",
    options: ["État de droit", "Autorité", "Tutelle"],
    answer: "État de droit",
    explanation: "Le pouvoir est soumis au contrôle du juge.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Principes constitutionnels — France",
    question:
        "Quel principe impose la séparation entre pouvoir exécutif et judiciaire ?",
    options: ["Séparation des pouvoirs", "Primauté", "Subsidiarité"],
    answer: "Séparation des pouvoirs",
    explanation: "Fondement de l’équilibre démocratique.",
    difficulty: "Facile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizCultureGeneralInstitutionsEuropeenes extends StatefulWidget {
  static const String routeName =
      '/gpx_exam/concours/culture_generale_institutions_europeennes';
  final String uid;
  final String email;

  const QuizCultureGeneralInstitutionsEuropeenes({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizCultureGeneralInstitutionsEuropeenes> createState() =>
      _QuizCultureGeneralInstitutionsEuropeenesState();
}

class _QuizCultureGeneralInstitutionsEuropeenesState
    extends State<QuizCultureGeneralInstitutionsEuropeenes>
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
        ? questionCultureGeneralGPXInstitutionEuropeen
        : questionCultureGeneralGPXInstitutionEuropeen
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
            'module_name': 'Culture générale',
            'quiz_name': 'Quiz culture générale institutions européennes',
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
      await _sb
          .from('quiz_culture_generale_institutions_europeennes_pages')
          .insert({
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
      debugPrint(
        '❌ quiz_culture_generale_institutions_europeennes_pages insert failed: $e',
      );
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
