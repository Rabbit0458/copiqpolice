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

final List<QuizQuestion> questionCultureSciences = [
  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le symbole chimique de l'hydrogène ?",
    options: ["H", "O", "He"],
    answer: "H",
    explanation:
        "L'hydrogène est représenté par le symbole 'H' dans le tableau périodique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Qui a proposé la théorie de l'évolution par la sélection naturelle ?",
    options: ["Albert Einstein", "Charles Darwin", "Isaac Newton"],
    answer: "Charles Darwin",
    explanation:
        "Charles Darwin a formulé la théorie de l'évolution par la sélection naturelle au XIXe siècle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe principal de la circulation sanguine ?",
    options: ["Poumons", "Cœur", "Foie"],
    answer: "Cœur",
    explanation:
        "Le cœur est l'organe qui pompe le sang à travers le système circulatoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel phénomène est responsable des saisons sur Terre ?",
    options: [
      "La rotation de la Terre",
      "L'inclinaison de l'axe terrestre",
      "L'orbite elliptique",
    ],
    answer: "L'inclinaison de l'axe terrestre",
    explanation:
        "L'inclinaison de l'axe terrestre par rapport à son orbite cause les variations saisonnières.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la loi de Newton sur le mouvement ?",
    options: [
      "La loi de l'inertie",
      "La loi de la gravitation universelle",
      "La loi des gaz parfaits",
    ],
    answer: "La loi de l'inertie",
    explanation:
        "La première loi de Newton, ou loi de l'inertie, stipule que tout objet au repos reste au repos.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la durée d'une année terrestre ?",
    options: ["365 jours", "364 jours", "366 jours"],
    answer: "365 jours",
    explanation:
        "Une année terrestre standard dure 365 jours, sauf les années bissextiles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel gaz est principalement responsable de l'effet de serre ?",
    options: ["Oxygène", "Dioxyde de carbone", "Azote"],
    answer: "Dioxyde de carbone",
    explanation:
        "Le dioxyde de carbone est le principal gaz à effet de serre émis par les activités humaines.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le plus grand mammifère terrestre ?",
    options: ["Éléphant", "Rhinocéros", "Girafe"],
    answer: "Éléphant",
    explanation:
        "L'éléphant d'Afrique est le plus grand mammifère terrestre vivant.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle partie de la cellule contient l'ADN ?",
    options: ["Noyau", "Cytoplasme", "Membrane cellulaire"],
    answer: "Noyau",
    explanation: "L'ADN est contenu dans le noyau des cellules eucaryotes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe qui permet la respiration humaine ?",
    options: ["Cœur", "Poumons", "Foie"],
    answer: "Poumons",
    explanation:
        "Les poumons sont responsables de l'échange de gaz dans le système respiratoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principal composant du Soleil ?",
    options: ["Hydrogène", "Hélium", "Oxygène"],
    answer: "Hydrogène",
    explanation:
        "Le Soleil est principalement composé d'hydrogène, qui représente environ 74 % de sa masse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la plus grande planète du système solaire ?",
    options: ["Terre", "Mars", "Jupiter"],
    answer: "Jupiter",
    explanation:
        "Jupiter est la plus grande planète du système solaire avec son immense taille et sa masse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Qui a découvert la pénicilline ?",
    options: ["Louis Pasteur", "Alexander Fleming", "Marie Curie"],
    answer: "Alexander Fleming",
    explanation:
        "Alexander Fleming a découvert la pénicilline en 1928, révolutionnant ainsi la médecine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'élément chimique avec le symbole 'Na' ?",
    options: ["Néon", "Soufre", "Sodium"],
    answer: "Sodium",
    explanation:
        "Le sodium est représenté par le symbole chimique 'Na' dans le tableau périodique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principal organe de la digestion ?",
    options: ["Estomac", "Intestin grêle", "Foie"],
    answer: "Estomac",
    explanation:
        "L'estomac joue un rôle clé dans la digestion en décomposant les aliments.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principal gaz de l'atmosphère terrestre ?",
    options: ["Azote", "Oxygène", "Dioxyde de carbone"],
    answer: "Azote",
    explanation: "L'azote constitue environ 78 % de l'atmosphère terrestre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du processus par lequel les plantes produisent leur propre nourriture ?",
    options: ["Photosynthèse", "Respiration", "Fermentation"],
    answer: "Photosynthèse",
    explanation:
        "La photosynthèse est le processus par lequel les plantes convertissent la lumière en énergie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe qui contrôle les mouvements du corps ?",
    options: ["Cerveau", "Cervelet", "Moelle épinière"],
    answer: "Cerveau",
    explanation:
        "Le cerveau est l'organe central qui coordonne les mouvements et les fonctions corporelles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel gaz est produit par la respiration humaine ?",
    options: ["Oxygène", "Dioxyde de carbone", "Hydrogène"],
    answer: "Dioxyde de carbone",
    explanation:
        "Le dioxyde de carbone est le gaz que les humains expirent lors de la respiration.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'élément chimique ayant le numéro atomique 6 ?",
    options: ["Carbone", "Azote", "Oxygène"],
    answer: "Carbone",
    explanation: "Le carbone a le numéro atomique 6 et est essentiel à la vie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom donné au phénomène où la lumière se décompose dans un prisme ?",
    options: ["Diffraction", "Réflexion", "Réfraction"],
    answer: "Réfraction",
    explanation:
        "La réfraction est le phénomène par lequel la lumière change de direction lorsqu'elle passe à travers un prisme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel phénomène naturelle est causé par la gravité ?",
    options: ["Le vent", "Les marées", "La foudre"],
    answer: "Les marées",
    explanation:
        "Les marées sont causées par l'attraction gravitationnelle de la lune et du soleil sur les océans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la formule chimique du méthane ?",
    options: ["CH3", "CH4", "C2H6"],
    answer: "CH4",
    explanation:
        "La formule chimique du méthane est CH4, ce qui signifie qu'il est composé d'un atome de carbone et de quatre atomes d'hydrogène.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'objet céleste qui orbite autour de la Terre ?",
    options: ["Mars", "Lune", "Soleil"],
    answer: "Lune",
    explanation:
        "La Lune est le satellite naturel de la Terre et orbite autour d'elle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'acide contenu dans l'estomac ?",
    options: ["Acide sulfurique", "Acide chlorhydrique", "Acide acétique"],
    answer: "Acide chlorhydrique",
    explanation:
        "L'acide chlorhydrique est un composant essentiel du suc gastrique dans l'estomac.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quelle partie des plantes est responsable de l'absorption de l'eau ?",
    options: ["Racines", "Tiges", "Feuilles"],
    answer: "Racines",
    explanation:
        "Les racines des plantes absorbent l'eau et les nutriments du sol.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du processus par lequel les liquides se transforment en gaz ?",
    options: ["Évaporation", "Congélation", "Sublimation"],
    answer: "Évaporation",
    explanation:
        "L'évaporation est le processus par lequel les liquides se transforment en vapeur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'élément chimique représentant le symbole 'Fe' ?",
    options: ["Fer", "Fluor", "Francium"],
    answer: "Fer",
    explanation: "L'élément chimique avec le symbole 'Fe' est le fer.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le nom du plus petit os du corps humain ?",
    options: ["Marteau", "Tibia", "Fémur"],
    answer: "Marteau",
    explanation:
        "Le marteau est l'os le plus petit du corps humain, situé dans l'oreille.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est l'effet observé lorsque les objets paraissent déformés dans l'eau ?",
    options: ["Réfraction", "Reflexion", "Diffraction"],
    answer: "Réfraction",
    explanation:
        "La réfraction est la raison pour laquelle les objets semblent déformés lorsqu'ils sont vus à travers l'eau.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du phénomène par lequel les espèces évoluent progressivement ?",
    options: ["Mutation", "Sélection naturelle", "Spéciation"],
    answer: "Sélection naturelle",
    explanation:
        "La sélection naturelle est le mécanisme par lequel les espèces évoluent au fil du temps.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principal moteur de la tectonique des plaques ?",
    options: ["Gravitation", "Chaleur terrestre", "Magnetisme"],
    answer: "Chaleur terrestre",
    explanation:
        "La chaleur provenant de l'intérieur de la Terre provoque le mouvement des plaques tectoniques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe principal de l'audition chez l'homme ?",
    options: ["Oreille", "Nez", "Bouche"],
    answer: "Oreille",
    explanation:
        "L'oreille est l'organe responsable de la perception des sons.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel type de cellule est responsable du transport de l'oxygène dans le sang ?",
    options: ["Globule blanc", "Globule rouge", "Plaquette"],
    answer: "Globule rouge",
    explanation:
        "Les globules rouges sont responsables du transport de l'oxygène dans le sang.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la principale fonction des cellules nerveuses ?",
    options: [
      "Transporter l'oxygène",
      "Transmettre des signaux",
      "Produire des hormones",
    ],
    answer: "Transmettre des signaux",
    explanation:
        "Les cellules nerveuses transmettent des signaux électriques à travers le système nerveux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le phénomène par lequel un solide devient un liquide ?",
    options: ["Fusion", "Solidification", "Condensation"],
    answer: "Fusion",
    explanation:
        "La fusion est le processus par lequel un solide se transforme en liquide.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe principal de la vision chez l'homme ?",
    options: ["Cerveau", "Yeux", "Oreilles"],
    answer: "Yeux",
    explanation:
        "Les yeux sont les organes responsables de la perception visuelle chez l'homme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du processus par lequel les plantes absorbent l'eau du sol ?",
    options: ["Transpiration", "Absorption", "Photosynthèse"],
    answer: "Absorption",
    explanation:
        "L'absorption est le processus par lequel les plantes prennent de l'eau du sol.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le nom du gaz utilisé pour gonfler les ballons ?",
    options: ["Hélium", "Azote", "Dioxyde de carbone"],
    answer: "Hélium",
    explanation:
        "L'hélium est un gaz léger souvent utilisé pour gonfler les ballons.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel système est responsable de la régulation des hormones dans le corps humain ?",
    options: ["Système nerveux", "Système endocrinien", "Système circulatoire"],
    answer: "Système endocrinien",
    explanation:
        "Le système endocrinien régule la production et la libération des hormones dans le corps.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la partie de l'atome qui porte une charge positive ?",
    options: ["Électron", "Proton", "Neutron"],
    answer: "Proton",
    explanation:
        "Le proton est la particule de l'atome portant une charge positive.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principal effet des vaccins ?",
    options: [
      "Renforcer l'immunité",
      "Provoquer la maladie",
      "Infecter l'organisme",
    ],
    answer: "Renforcer l'immunité",
    explanation:
        "Les vaccins aident le système immunitaire à reconnaître et combattre les infections.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du processus par lequel un liquide se transforme en solide ?",
    options: ["Réaction", "Solidification", "Évaporation"],
    answer: "Solidification",
    explanation:
        "La solidification est le processus par lequel un liquide devient un solide.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe éphemère de l'ouïe chez l'homme ?",
    options: ["Oreille interne", "Oreille externe", "Oreille moyenne"],
    answer: "Oreille externe",
    explanation:
        "L'oreille externe est la partie visible de l'organe de l'audition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom de la première molécule formée dans la respiration cellulaire ?",
    options: ["Acide pyruvique", "Glucose", "ATP"],
    answer: "ATP",
    explanation:
        "L'ATP est la principale molécule énergétique produite lors de la respiration cellulaire.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la plus grande planète de notre système solaire ?",
    options: ["Terre", "Jupiter", "Mars"],
    answer: "Jupiter",
    explanation:
        "Jupiter est la plus grande planète, avec un diamètre de 139 822 km.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe principal de la respiration chez l'homme ?",
    options: ["Cœur", "Poumons", "Foie"],
    answer: "Poumons",
    explanation:
        "Les poumons sont responsables de l'échange des gaz dans le corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel gaz constitue 78% de l'atmosphère terrestre ?",
    options: ["Oxygène", "Azote", "Dioxyde de carbone"],
    answer: "Azote",
    explanation:
        "L'azote est le principal composant de l'air que nous respirons.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Qui est connu pour avoir découvert la pénicilline ?",
    options: ["Louis Pasteur", "Alexander Fleming", "Marie Curie"],
    answer: "Alexander Fleming",
    explanation:
        "La pénicilline a été découverte par Alexander Fleming en 1928.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le processus par lequel les plantes fabriquent leur nourriture ?",
    options: ["Transpiration", "Photosynthèse", "Respiration"],
    answer: "Photosynthèse",
    explanation:
        "La photosynthèse permet aux plantes de convertir la lumière en énergie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est l'état de la matière dont les atomes sont très éloignés ?",
    options: ["Solide", "Liquide", "Gaz"],
    answer: "Gaz",
    explanation:
        "Dans un gaz, les atomes sont dispersés et se déplacent librement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du scientifique qui a élaboré la théorie de l'évolution ?",
    options: ["Charles Darwin", "Gregor Mendel", "James Watson"],
    answer: "Charles Darwin",
    explanation:
        "Charles Darwin est célèbre pour sa théorie de l'évolution par sélection naturelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le symbole chimique de l'or ?",
    options: ["Au", "Ag", "Pb"],
    answer: "Au",
    explanation: "Le symbole 'Au' représente l'or dans le tableau périodique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel type de cellule est responsable du transport de l'oxygène dans le sang ?",
    options: ["Globules rouges", "Globules blancs", "Plaquettes"],
    answer: "Globules rouges",
    explanation:
        "Les globules rouges transportent l'oxygène des poumons vers les cellules du corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel phénomène explique la couleur du ciel ?",
    options: ["Diffraction", "Réfraction", "Diffusion"],
    answer: "Diffusion",
    explanation:
        "La diffusion de la lumière par l'atmosphère donne au ciel sa couleur bleue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le terme utilisé pour décrire la capacité d'un organisme à s'adapter à son environnement ?",
    options: ["Mutation", "Adaptation", "Évolution"],
    answer: "Adaptation",
    explanation:
        "L'adaptation désigne les changements permettant la survie dans un environnement donné.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom de la force qui attire les objets vers le centre de la Terre ?",
    options: [
      "Force de gravité",
      "Force centripète",
      "Force électromagnétique",
    ],
    answer: "Force de gravité",
    explanation:
        "La gravité est la force qui attire les objets vers le centre de la Terre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'acide nucléaire qui porte l'information génétique ?",
    options: ["ADN", "ARN", "Protéines"],
    answer: "ADN",
    explanation:
        "L'ADN contient l'information génétique nécessaire à la reproduction cellulaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le principal gaz à effet de serre produit par les activités humaines ?",
    options: ["Méthane", "Dioxyde de carbone", "Oxygène"],
    answer: "Dioxyde de carbone",
    explanation:
        "Le dioxyde de carbone est principalement émis par la combustion des combustibles fossiles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe responsable de la circulation sanguine ?",
    options: ["Cerveau", "Cœur", "Foie"],
    answer: "Cœur",
    explanation: "Le cœur pompe le sang à travers tout le corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le gaz noble incolore utilisé dans les ampoules ?",
    options: ["Hélium", "Krypton", "Argon"],
    answer: "Argon",
    explanation:
        "L'argon est souvent utilisé dans les ampoules pour éviter l'oxydation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quelle est la température d'ébullition de l'eau à pression normale ?",
    options: ["50°C", "100°C", "150°C"],
    answer: "100°C",
    explanation: "L'eau bout à 100°C sous une pression atmosphérique normale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe principal du système nerveux central ?",
    options: ["Moelle épinière", "Cerveau", "Nerfs"],
    answer: "Cerveau",
    explanation:
        "Le cerveau est l'organe qui contrôle la majorité des fonctions corporelles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le processus par lequel certaines bactéries fixent l'azote de l'air ?",
    options: ["Photosynthèse", "Fixation de l'azote", "Respiration"],
    answer: "Fixation de l'azote",
    explanation:
        "Certaines bactéries possèdent la capacité de transformer l'azote atmosphérique en formes utilisables par les plantes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Comment appelle-t-on une substance qui augmente la vitesse d'une réaction chimique ?",
    options: ["Inhibiteur", "Réducteur", "Catalyseur"],
    answer: "Catalyseur",
    explanation:
        "Un catalyseur accélère une réaction chimique sans être consommé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principal minéral constitutif des os ?",
    options: ["Calcium", "Sodium", "Fer"],
    answer: "Calcium",
    explanation:
        "Le calcium est essentiel pour la solidité et la structure des os.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel phénomène survive à la découverte de l'ADN en double hélice ?",
    options: ["Cellule", "Gène", "Chromosome"],
    answer: "Gène",
    explanation:
        "Le gène est une unité d'information génétique présente sur le chromosome.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le nom de la couche externe de la Terre ?",
    options: ["Manteau", "Croûte", "Noyau"],
    answer: "Croûte",
    explanation:
        "La croûte terrestre est la couche la plus superficielle de la Terre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom de la méthode qui permet de dater les fossiles ?",
    options: ["Datation relative", "Datation absolue", "Datation isotopique"],
    answer: "Datation absolue",
    explanation:
        "La datation absolue utilise des isotopes pour déterminer l'âge des fossiles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe qui sécrète l'insuline ?",
    options: ["Pancréas", "Fois", "Estomac"],
    answer: "Pancréas",
    explanation:
        "Le pancréas produit l'insuline, une hormone essentielle pour réguler le taux de glucose.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel type de cellule est impliqué dans la réponse immunitaire ?",
    options: ["Globules blancs", "Globules rouges", "Plaquettes"],
    answer: "Globules blancs",
    explanation:
        "Les globules blancs jouent un rôle crucial dans la défense de l'organisme contre les infections.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'énergie produite par le mouvement des électrons ?",
    options: ["Énergie thermale", "Énergie mécanique", "Énergie électrique"],
    answer: "Énergie électrique",
    explanation:
        "L'énergie électrique est générée par le mouvement des électrons.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le processus de transformation de l'eau en vapeur ?",
    options: ["Évaporation", "Condensation", "Précipitation"],
    answer: "Évaporation",
    explanation:
        "L'évaporation est le processus par lequel l'eau passe de l'état liquide à l'état gazeux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est l'état de la matière où les molécules sont très proches les unes des autres ?",
    options: ["Solide", "Gaz", "Plasma"],
    answer: "Solide",
    explanation:
        "Dans un solide, les molécules sont étroitement liées et vibrent autour de leurs positions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le gaz produit par la respiration humaine ?",
    options: ["Oxygène", "Hydrogène", "Dioxyde de carbone"],
    answer: "Dioxyde de carbone",
    explanation:
        "Le dioxyde de carbone est un produit de la respiration cellulaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe de la vue chez l'homme ?",
    options: ["Oreille", "Yeux", "Nez"],
    answer: "Yeux",
    explanation:
        "Les yeux sont les organes responsables de la perception visuelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est la première étape de la respiration cellulaire ?",
    options: ["Fermentation", "Glycolyse", "Krebs"],
    answer: "Glycolyse",
    explanation:
        "La glycolyse est la première étape de la respiration cellulaire où le glucose est décomposé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quelle est l'unité de mesure de la masse dans le système international ?",
    options: ["Kilogramme", "Gramme", "Mètre"],
    answer: "Kilogramme",
    explanation:
        "Le kilogramme est l'unité de mesure de la masse dans le Système International.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel élément chimique est essentiel à la photosynthèse ?",
    options: ["Oxygène", "Carbone", "Hydrogène"],
    answer: "Carbone",
    explanation:
        "Le carbone est un élément clé dans le processus de photosynthèse des plantes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le phénomène d'émission de lumière par un objet lorsqu'il est chauffé ?",
    options: ["Fluorescence", "Chaleur", "Incandescence"],
    answer: "Incandescence",
    explanation:
        "L'incandescence se produit lorsqu'un objet émet de la lumière en raison de la chaleur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom de la méthode utilisée pour identifier les bactéries dans un échantillon ?",
    options: ["Culture", "Antibiogramme", "Test de Gram"],
    answer: "Test de Gram",
    explanation:
        "Le test de Gram est une méthode de coloration utilisée pour identifier des bactéries.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le type de reproduction qui nécessite deux parents ?",
    options: ["Asexuée", "Sexuée", "Clonage"],
    answer: "Sexuée",
    explanation:
        "La reproduction sexuée implique la fusion de gamètes de deux parents.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe principal pour la digestion des aliments ?",
    options: ["Estomac", "Intestin", "Foie"],
    answer: "Estomac",
    explanation:
        "L'estomac est l'organe principal où la digestion des aliments commence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le nom de la couche de gaz entourant la Terre ?",
    options: ["Atmosphère", "Stratosphère", "Troposphère"],
    answer: "Atmosphère",
    explanation: "L'atmosphère est la couche de gaz qui entoure notre planète.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est l'organe dans lequel se produit la filtration du sang ?",
    options: ["Cœur", "Reins", "Poumons"],
    answer: "Reins",
    explanation:
        "Les reins sont responsables de la filtration et de l'élimination des déchets du sang.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom de la théorie qui explique l'origine de l'univers ?",
    options: ["Théorie de la relativité", "Big Bang", "Évolution"],
    answer: "Big Bang",
    explanation:
        "La théorie du Big Bang décrit comment l'univers a commencé à partir d'un état extrêmement dense.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le processus d'envoi de signaux électriques dans le système nerveux ?",
    options: ["Transmission synaptique", "Neurotransmission", "Conduction"],
    answer: "Conduction",
    explanation:
        "La conduction est le processus par lequel les signaux sont transmis le long des neurones.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principal composant du sang ?",
    options: ["Plasma", "Globules blancs", "Globules rouges"],
    answer: "Plasma",
    explanation:
        "Le plasma constitue la partie liquide du sang et transporte les cellules.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe responsable de la production de bile ?",
    options: ["Pancréas", "Foie", "Estomac"],
    answer: "Foie",
    explanation:
        "Le foie produit la bile, qui aide à la digestion des graisses.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe qui contrôle l'équilibre du corps ?",
    options: ["Oreille interne", "Pied", "Cerveau"],
    answer: "Oreille interne",
    explanation:
        "L'oreille interne joue un rôle clé dans le maintien de l'équilibre.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est l'organe responsable de la circulation du sang dans le corps humain ?",
    options: ["Le cœur", "Le foie", "Les poumons"],
    answer: "Le cœur",
    explanation:
        "Le cœur est un muscle qui pompte le sang à travers le système circulatoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la principale source d'énergie de notre planète ?",
    options: ["Le vent", "Le soleil", "L'eau"],
    answer: "Le soleil",
    explanation:
        "Le soleil est la principale source d'énergie, fournissant la lumière et la chaleur nécessaires à la vie sur Terre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la théorie qui explique l'origine de l'univers ?",
    options: [
      "La théorie de la relativité",
      "La théorie du Big Bang",
      "La théorie de l'évolution",
    ],
    answer: "La théorie du Big Bang",
    explanation:
        "La théorie du Big Bang décrit l'expansion de l'univers à partir d'un état très chaud et dense.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'élément chimique dont le symbole est 'Fe' ?",
    options: ["Fer", "Fluor", "Francium"],
    answer: "Fer",
    explanation:
        "Le symbole 'Fe' désigne le fer, un métal couramment utilisé dans divers alliages.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la première loi de Newton ?",
    options: [
      "Un corps au repos reste au repos",
      "La force égale la masse multipliée par l'accélération",
      "Pour chaque action, il y a une réaction égale et opposée",
    ],
    answer: "Un corps au repos reste au repos",
    explanation:
        "La première loi de Newton, aussi connue comme le principe d'inertie, stipule que les objets en mouvement restent en mouvement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le processus par lequel les plantes fabriquent leur nourriture ?",
    options: ["La respiration", "La photosynthèse", "La digestion"],
    answer: "La photosynthèse",
    explanation:
        "La photosynthèse est le processus par lequel les plantes convertissent la lumière solaire en énergie chimique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle partie du cerveau est responsable de l'équilibre ?",
    options: ["Le cervelet", "Le cortex", "Le tronc cérébral"],
    answer: "Le cervelet",
    explanation:
        "Le cervelet est la région du cerveau qui coordonne les mouvements et maintient l'équilibre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Qui a développé la théorie de l'évolution par sélection naturelle ?",
    options: ["Albert Einstein", "Charles Darwin", "Isaac Newton"],
    answer: "Charles Darwin",
    explanation:
        "Charles Darwin est connu pour avoir formulé la théorie de l'évolution par sélection naturelle dans son ouvrage 'L'Origine des espèces'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principale composant du noyau terrestre ?",
    options: ["Fer", "Silicium", "Magnésium"],
    answer: "Fer",
    explanation:
        "Le noyau de la Terre est principalement composé de fer et de nickel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel type de cellule est responsable de l’immunité dans le corps humain ?",
    options: ["Globules rouges", "Globules blancs", "Plaquettes"],
    answer: "Globules blancs",
    explanation:
        "Les globules blancs jouent un rôle crucial dans la défense immunitaire de l'organisme contre les infections.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel phénomène naturel est causé par la rotation de la Terre ?",
    options: ["Les marées", "Les saisons", "Le vent"],
    answer: "Les marées",
    explanation:
        "Les marées sont causées par l'attraction gravitationnelle de la Lune et du Soleil sur les océans de la Terre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom donné aux particules élémentaires qui composent les atomes ?",
    options: ["Neutrons", "Électrons", "Quarks"],
    answer: "Quarks",
    explanation:
        "Les quarks sont les particules fondamentales qui constituent les protons et les neutrons dans le noyau des atomes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'élément chimique le plus léger ?",
    options: ["Hydrogène", "Hélium", "Lithium"],
    answer: "Hydrogène",
    explanation:
        "L'hydrogène est l'élément chimique le plus léger, avec un seul proton dans son noyau.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la principale fonction des reins ?",
    options: [
      "Filtrer le sang",
      "Produire des hormones",
      "Réguler la température corporelle",
    ],
    answer: "Filtrer le sang",
    explanation:
        "Les reins filtrent le sang pour éliminer les déchets et réguler l'équilibre hydrique du corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du gaz qui est le principal responsable de l'effet de serre ?",
    options: ["Oxygène", "Méthane", "Dioxyde de carbone"],
    answer: "Dioxyde de carbone",
    explanation:
        "Le dioxyde de carbone est l'un des principaux gaz à effet de serre, contribuant au réchauffement climatique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe responsable de la respiration chez l'homme ?",
    options: ["Le foie", "Les poumons", "Le cœur"],
    answer: "Les poumons",
    explanation:
        "Les poumons sont les organes responsables des échanges gazeux dans le corps humain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel type d'engrais est principalement composé d'azote ?",
    options: ["Engrais organiques", "Engrais minéraux", "Engrais azotés"],
    answer: "Engrais azotés",
    explanation:
        "Les engrais azotés sont spécifiquement conçus pour fournir de l'azote aux plantes, stimulant leur croissance.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quelle est la molécule responsable du transport de l'oxygène dans le sang ?",
    options: ["Hémoglobine", "Glucose", "Protéines"],
    answer: "Hémoglobine",
    explanation:
        "L'hémoglobine se lie à l'oxygène dans les globules rouges pour le transporter vers les cellules du corps.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom de la théorie qui établit que les continents sont en mouvement ?",
    options: [
      "La tectonique des plaques",
      "La dérive des continents",
      "La théorie de l'expansion de l'univers",
    ],
    answer: "La dérive des continents",
    explanation:
        "La dérive des continents est une théorie qui explique que les continents se déplacent lentement sur la surface terrestre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le gaz qui est produit lors de la respiration cellulaire ?",
    options: ["Oxygène", "Dioxyde de carbone", "Azote"],
    answer: "Dioxyde de carbone",
    explanation:
        "Le dioxyde de carbone est produit lors de la respiration cellulaire comme un déchet métabolique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est l'instrument utilisé pour mesurer la pression atmosphérique ?",
    options: ["Thermomètre", "Baromètre", "Hygromètre"],
    answer: "Baromètre",
    explanation:
        "Le baromètre est un appareil destiné à mesurer la pression atmosphérique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principal gaz composé l’atmosphère terrestre ?",
    options: ["Azote", "Argon", "Oxygène"],
    answer: "Azote",
    explanation:
        "Environ 78% de l'atmosphère terrestre est constitué d'azote, rendant ce gaz prédominant.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel phénomène explique la formation des arcs-en-ciel ?",
    options: [
      "La réfraction de la lumière",
      "La réflexion de la lumière",
      "La diffraction de la lumière",
    ],
    answer: "La réfraction de la lumière",
    explanation:
        "Les arcs-en-ciel se forment grâce à la réfraction de la lumière du soleil dans les gouttes de pluie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le nom de la cellule qui permet la vision nocturne ?",
    options: ["Cônes", "Bâtonnets", "Photopigments"],
    answer: "Bâtonnets",
    explanation:
        "Les bâtonnets sont des cellules réceptrices dans la rétine qui permettent de voir dans des conditions de faible luminosité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom de la plante dont l'usage est principalement médicinal et connue pour ses propriétés antiseptiques ?",
    options: ["Aloe vera", "Lavande", "Eucalyptus"],
    answer: "Aloe vera",
    explanation:
        "L'Aloe vera est réputée pour ses propriétés antiseptiques et est largement utilisée en médecine douce.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du processus par lequel les organismes produisent de l’énergie à partir du glucose ?",
    options: [
      "La photosynthèse",
      "La respiration cellulaire",
      "La fermentation",
    ],
    answer: "La respiration cellulaire",
    explanation:
        "La respiration cellulaire est le processus par lequel les cellules convertissent le glucose en énergie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le phénomène qui cause les saisons sur Terre ?",
    options: [
      "La rotation de la Terre",
      "L'inclinaison de l'axe terrestre",
      "La distance de la Terre au Soleil",
    ],
    answer: "L'inclinaison de l'axe terrestre",
    explanation:
        "Les saisons sont causées par l'inclinaison de l'axe terrestre par rapport au plan de son orbite.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom de la loi qui décrit le mouvement des corps en chute libre ?",
    options: ["Loi de gravité", "Loi de l'inertie", "Loi de Newton"],
    answer: "Loi de gravité",
    explanation:
        "La loi de gravité, formulée par Isaac Newton, décrit comment les corps tombent vers le centre de la Terre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la différence entre un acide et une base ?",
    options: [
      "Les acides libèrent des protons et les bases en acceptent",
      "Les acides sont toujours solides et les bases liquides",
      "Les acides sont corrosifs et les bases ne le sont pas",
    ],
    answer: "Les acides libèrent des protons et les bases en acceptent",
    explanation:
        "Les acides et les bases sont définis par leur capacité à donner ou accepter des protons en solution.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du mécanisme par lequel les cellules se divisent ?",
    options: ["La mitose", "La méiose", "L'apoptose"],
    answer: "La mitose",
    explanation:
        "La mitose est le processus par lequel une cellule se divise pour former deux cellules identiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le principal organe sensoriel de l'odorat chez l'homme ?",
    options: ["La langue", "Le nez", "L'oreille"],
    answer: "Le nez",
    explanation:
        "Le nez est l'organe principal responsable de la détection des odeurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du cycle de vie des insectes qui passent par quatre stades ?",
    options: [
      "Métamorphose complète",
      "Métamorphose incomplète",
      "Cycle de vie linéaire",
    ],
    answer: "Métamorphose complète",
    explanation:
        "La métamorphose complète comprend quatre stades : œuf, larve, nymphe et adulte.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe principal de la vision dans l'œil humain ?",
    options: ["La rétine", "Le cristallin", "La cornée"],
    answer: "La rétine",
    explanation:
        "La rétine est la couche de cellules sensibles à la lumière qui envoie des signaux au cerveau pour la vision.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du phénomène par lequel un liquide se transforme en gaz ?",
    options: ["Condensation", "Évaporation", "Solidification"],
    answer: "Évaporation",
    explanation:
        "L'évaporation est le processus par lequel un liquide se transforme en vapeur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom de l'instrument utilisé pour observer les corps célestes ?",
    options: ["Télescope", "Microscope", "Stéthoscope"],
    answer: "Télescope",
    explanation:
        "Le télescope est l'instrument principal pour observer les étoiles et autres corps célestes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le nom du plus grand océan de la Terre ?",
    options: ["L'Océan Atlantique", "L'Océan Indien", "L'Océan Pacifique"],
    answer: "L'Océan Pacifique",
    explanation:
        "L'Océan Pacifique est le plus vaste océan de la planète, couvrant plus de 63 millions de miles carrés.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le principe fondamental de l'optique qui explique comment la lumière se propage ?",
    options: ["Loi de réflexion", "Loi de réfraction", "Loi de diffraction"],
    answer: "Loi de réfraction",
    explanation:
        "La loi de réfraction décrit comment la lumière change de direction lorsqu'elle passe d'un milieu à un autre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le processus par lequel les insectes développent leur exosquelette ?",
    options: ["Mue", "Croissance", "Transformation"],
    answer: "Mue",
    explanation:
        "La mue est le processus par lequel les insectes remplacent leur exosquelette usé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du phénomène par lequel une substance passe directement de l'état solide à l'état gazeux ?",
    options: ["Sublimation", "Évaporation", "Fusion"],
    answer: "Sublimation",
    explanation:
        "La sublimation est le passage direct d'un solide à un gaz sans passer par l'état liquide.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du processus par lequel les plantes absorbent l'eau ?",
    options: ["Transpiration", "Absorption", "Filtration"],
    answer: "Absorption",
    explanation:
        "L'absorption est le mécanisme par lequel les racines des plantes prennent de l'eau du sol.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le nom de la structure qui protège le cerveau ?",
    options: ["Le crâne", "La colonne vertébrale", "Le thorax"],
    answer: "Le crâne",
    explanation: "Le crâne est l'os qui protège le cerveau contre les lésions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le nom du processus par lequel une étoile se forme ?",
    options: [
      "Nucléosynthèse",
      "Contraction gravitationnelle",
      "Fusion nucléaire",
    ],
    answer: "Contraction gravitationnelle",
    explanation:
        "La formation d'une étoile commence par la contraction gravitationnelle d'un nuage de gaz et de poussière.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le nom de la première hormone découverte ?",
    options: ["Insuline", "Adrénaline", "Thyroxine"],
    answer: "Insuline",
    explanation:
        "L'insuline a été la première hormone découverte et est essentielle pour la régulation du glucose dans le sang.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Comment se forme une gouttelette d'eau dans l'air ?",
    options: ["Par condensation", "Par évaporation", "Par solidification"],
    answer: "Par condensation",
    explanation:
        "Les gouttelettes d'eau se forment par condensation de la vapeur d'eau dans l'air refroidi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quelle est la principale fonction de la chlorophylle dans les plantes ?",
    options: [
      "Absorber la lumière",
      "Rendre les plantes vertes",
      "Produire du sucre",
    ],
    answer: "Absorber la lumière",
    explanation:
        "La chlorophylle joue un rôle crucial en absorbant la lumière nécessaire à la photosynthèse.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'élément chimique dont le symbole est He ?",
    options: ["Hydrogène", "Hélium", "Lithium"],
    answer: "Hélium",
    explanation:
        "L'hélium est le deuxième élément le plus léger et se trouve dans le groupe des gaz nobles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel organe est responsible de la filtration du sang dans le corps humain ?",
    options: ["Foie", "Rein", "Poumon"],
    answer: "Rein",
    explanation:
        "Les reins filtrent les déchets et l'excès de fluides du sang pour produire l'urine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le principal gaz à effet de serre émis par l'activité humaine ?",
    options: ["Méthane", "Dioxyde de carbone", "Oxygène"],
    answer: "Dioxyde de carbone",
    explanation:
        "Le dioxyde de carbone est le principal gaz à effet de serre résultant de la combustion des combustibles fossiles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du processus par lequel les plantes convertissent la lumière en énergie ?",
    options: ["Photosynthèse", "Respiration", "Métabolisme"],
    answer: "Photosynthèse",
    explanation:
        "La photosynthèse est le processus par lequel les plantes utilisent la lumière pour transformer le dioxyde de carbone et l'eau en glucose.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel type de cellule est responsable de la transmission des signaux nerveux ?",
    options: ["Globule rouge", "Neurone", "Lymphocyte"],
    answer: "Neurone",
    explanation:
        "Les neurones sont les cellules spécialisées qui transmettent les signaux électriques dans le système nerveux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel phénomène physique permet le vol des oiseaux ?",
    options: ["La pression de l'air", "La gravité", "La force centrifuge"],
    answer: "La pression de l'air",
    explanation:
        "Les oiseaux volent grâce à la différence de pression de l'air sous et au-dessus de leurs ailes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel organe humain produit l'insuline ?",
    options: ["Pancréas", "Foie", "Estomac"],
    answer: "Pancréas",
    explanation:
        "Le pancréas est l'organe responsable de la production d'insuline, une hormone régulant le taux de sucre dans le sang.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le plus gros animal vivant sur Terre ?",
    options: ["Éléphant", "Baleine bleue", "Giraffe"],
    answer: "Baleine bleue",
    explanation:
        "La baleine bleue peut atteindre jusqu'à 30 mètres de long et est le plus grand animal connu à avoir jamais existé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel type d'onde est responsable des phénomènes lumineux ?",
    options: ["Sonore", "Électromagnétique", "Mécanique"],
    answer: "Électromagnétique",
    explanation:
        "Les ondes lumineuses sont des ondes électromagnétiques qui se déplacent à des vitesses extrêmement élevées.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la structure de base des protéines ?",
    options: ["Nucléotides", "Acides aminés", "Lipides"],
    answer: "Acides aminés",
    explanation:
        "Les protéines sont constituées de chaînes d'acides aminés liés entre eux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principal sel minéral présent dans les os ?",
    options: ["Calcium", "Fer", "Phosphore"],
    answer: "Calcium",
    explanation:
        "Le calcium est le minéral principal qui forme la structure des os et des dents.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel unit de mesure est utilisé pour quantifier l'énergie ?",
    options: ["Joule", "Watt", "Calorie"],
    answer: "Joule",
    explanation:
        "Le joule est l'unité de mesure standard de l'énergie dans le système international d'unités.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel gaz constitue environ 78% de l'atmosphère terrestre ?",
    options: ["Oxygène", "Azote", "Dioxyde de carbone"],
    answer: "Azote",
    explanation:
        "L'azote est le gaz le plus abondant dans l'atmosphère, représentant environ trois quarts de son volume.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la principale fonction des globules rouges ?",
    options: [
      "Transporter l'oxygène",
      "Lutter contre les infections",
      "Coaguler le sang",
    ],
    answer: "Transporter l'oxygène",
    explanation:
        "Les globules rouges sont responsables du transport de l'oxygène des poumons vers les tissus du corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe principal de la respiration ?",
    options: ["Cœur", "Poumon", "Foie"],
    answer: "Poumon",
    explanation:
        "Les poumons sont les organes où se produit l'échange des gaz, notamment l'oxygène et le dioxyde de carbone.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le phénomène à l'origine des saisons sur Terre ?",
    options: ["La rotation", "L'inclinaison de l'axe", "L'orbite elliptique"],
    answer: "L'inclinaison de l'axe",
    explanation:
        "L'inclinaison de l'axe de la Terre par rapport à sa trajectoire autour du soleil est responsable des saisons.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel phénomène physique décrit le changement d'état de la matière de liquide à gaz ?",
    options: ["Condensation", "Évaporation", "Congélation"],
    answer: "Évaporation",
    explanation:
        "L'évaporation est le processus par lequel un liquide se transforme en gaz.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est l'unité de mesure de la pression ?",
    options: ["Pascal", "Joule", "Watt"],
    answer: "Pascal",
    explanation:
        "Le pascal est l'unité de mesure de la pression dans le système international.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quelle partie du cerveau est responsable de la coordination des mouvements ?",
    options: ["Cortex", "Cervelet", "Tronc cérébral"],
    answer: "Cervelet",
    explanation:
        "Le cervelet joue un rôle essentiel dans la coordination et l'équilibre des mouvements.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est l'état de la matière lorsque les particules sont très proches et ordonnées ?",
    options: ["Solide", "Liquide", "Gazeux"],
    answer: "Solide",
    explanation:
        "Dans un état solide, les particules sont très proches les unes des autres et se déplacent peu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le processus par lequel les organismes se reproduisent ?",
    options: ["Mitose", "Méiose", "Fission"],
    answer: "Méiose",
    explanation:
        "La méiose est le processus de division cellulaire qui produit des cellules reproductrices.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est l'organe responsable du contrôle hormonal dans le corps ?",
    options: ["Thyroïde", "Pancréas", "Cerveau"],
    answer: "Thyroïde",
    explanation:
        "La thyroïde régule le métabolisme et produit des hormones essentielles au fonctionnement du corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le type de lien chimique qui existe entre les atomes dans une molécule d'eau ?",
    options: ["Liaison ionique", "Liaison covalente", "Liaison métallique"],
    answer: "Liaison covalente",
    explanation:
        "Les atomes d'une molécule d'eau sont maintenus ensemble par des liaisons covalentes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quelle énergie est produite par la combustion d'un combustible fossile ?",
    options: ["Énergie cinétique", "Énergie thermique", "Énergie chimique"],
    answer: "Énergie thermique",
    explanation:
        "La combustion d'un combustible fossile libère de la chaleur, donc de l'énergie thermique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le modèle utilisé pour représenter la structure des atomes ?",
    options: [
      "Modèle atomique de Dalton",
      "Modèle de Rutherford",
      "Modèle de Bohr",
    ],
    answer: "Modèle de Bohr",
    explanation:
        "Le modèle de Bohr décrit les électrons orbitant autour d'un noyau atomique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le nom de la couche externe de la Terre ?",
    options: ["Noyau", "Atmosphère", "Corte"],
    answer: "Corte",
    explanation:
        "La croûte terrestre est la couche externe de la Terre, solide et relativement mince.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom donné à l'étude des astres et des phénomènes célestes ?",
    options: ["Astronomie", "Géologie", "Biologie"],
    answer: "Astronomie",
    explanation:
        "L'astronomie est la science qui étudie l'univers et les objets qui s'y trouvent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la loi qui décrit la conservation de l'énergie ?",
    options: [
      "Loi de Newton",
      "Loi de la thermodynamique",
      "Loi de l'aérodynamique",
    ],
    answer: "Loi de la thermodynamique",
    explanation:
        "La loi de la thermodynamique stipule que l'énergie ne peut être créée ni détruite, seulement transformée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quelle partie de la cellule est responsable de la production d'énergie ?",
    options: ["Noyau", "Mitochondrie", "Ribosome"],
    answer: "Mitochondrie",
    explanation:
        "Les mitochondries sont appelées les centrales énergétiques de la cellule, produisant de l'ATP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel phénomène observable est causé par la rotation de la Terre ?",
    options: ["Jour et nuit", "Saisons", "Éclipse"],
    answer: "Jour et nuit",
    explanation:
        "La rotation de la Terre sur son axe provoque l'alternance entre le jour et la nuit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est l'élément chimique le plus lourd naturellement présent ?",
    options: ["Plomb", "Uranium", "Mercure"],
    answer: "Uranium",
    explanation:
        "L'uranium est l'élément chimique le plus lourd qui se trouve naturellement sur Terre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Comment s'appelle le type de roches formées par la solidification de magma ?",
    options: ["Roches sédimentaires", "Roches métamorphiques", "Roches ignées"],
    answer: "Roches ignées",
    explanation: "Les roches ignées se forment lorsque le magma se solidifie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le principal principale source de l'énergie solaire sur Terre ?",
    options: ["Le Soleil", "Le vent", "Les vagues"],
    answer: "Le Soleil",
    explanation:
        "Le Soleil est la principale source d'énergie qui alimente la Terre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du processus par lequel l'eau passe de l'état liquide à l'état solide ?",
    options: ["Solidification", "Évaporation", "Condensation"],
    answer: "Solidification",
    explanation:
        "La solidification est le processus où un liquide se transforme en solide.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle protéine est essentielle à la coagulation du sang ?",
    options: ["Hémoglobine", "Fibrine", "Insuline"],
    answer: "Fibrine",
    explanation:
        "La fibrine est une protéine clé qui joue un rôle central dans le processus de coagulation sanguine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du phénomène de dispersion de la lumière dans un prisme ?",
    options: ["Réflexion", "Diffraction", "Réfraction"],
    answer: "Réfraction",
    explanation:
        "La réfraction est le changement de direction de la lumière lorsqu'elle traverse un matériau.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe principal du système circulatoire ?",
    options: ["Artères", "Cœur", "Veines"],
    answer: "Cœur",
    explanation:
        "Le cœur est l'organe qui pompe le sang à travers tout le corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le matériau principal des os dans le corps humain ?",
    options: ["Collagène", "Calcium", "Phosphate"],
    answer: "Calcium",
    explanation:
        "Le calcium est un minéral clé dans la structure des os humains.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le terme utilisé pour décrire le changement d'état de la matière de gaz à liquide ?",
    options: ["Évaporation", "Condensation", "Fusion"],
    answer: "Condensation",
    explanation:
        "La condensation est le processus par lequel un gaz se transforme en liquide.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel type de nuage est souvent associé à des tempêtes ?",
    options: ["Cirrus", "Cumulonimbus", "Stratus"],
    answer: "Cumulonimbus",
    explanation:
        "Les nuages cumulonimbus sont de grands nuages d'orage souvent associés à des intempéries.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'élément chimique dont le symbole est Na ?",
    options: ["Sodium", "Calcium", "Potassium"],
    answer: "Sodium",
    explanation:
        "Le sodium est un élément chimique essentiel, souvent trouvé dans le sel de table.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'effet d'un aimant sur un objet en fer ?",
    options: ["Le repousse", "Le magnétise", "Le chauffe"],
    answer: "Le magnétise",
    explanation: "Un aimant attire et peut magnétiser un objet en fer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le cycle qui décrit l'évaporation, la condensation et les précipitations ?",
    options: ["Cycle de l'eau", "Cycle de l'azote", "Cycle du carbone"],
    answer: "Cycle de l'eau",
    explanation:
        "Le cycle de l'eau décrit le mouvement continu de l'eau dans différents états sur Terre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du champ d'étude qui traite des microorganismes ?",
    options: ["Bactériologie", "Mycologie", "Phytologie"],
    answer: "Bactériologie",
    explanation:
        "La bactériologie est la branche de la microbiologie qui étudie les bactéries.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le nom du gaz responsable de l'effet de serre ?",
    options: ["Argon", "Dioxyde de carbone", "Oxygène"],
    answer: "Dioxyde de carbone",
    explanation:
        "Le dioxyde de carbone joue un rôle clé dans l'effet de serre, contribuant au réchauffement climatique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel type de roche est formé par l'accumulation de sédiments ?",
    options: ["Roche ignée", "Roche métamorphique", "Roche sédimentaire"],
    answer: "Roche sédimentaire",
    explanation:
        "Les roches sédimentaires se forment par l'accumulation et la compaction de sédiments.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le symbole chimique de l'eau ?",
    options: ["H2O", "O2", "CO2"],
    answer: "H2O",
    explanation:
        "Le symbole H2O représente deux atomes d'hydrogène et un atome d'oxygène, formant l'eau.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel gaz constitue environ 78 % de l'atmosphère terrestre ?",
    options: ["Oxygène", "Azote", "Dioxyde de carbone"],
    answer: "Azote",
    explanation:
        "L'azote représente environ 78 % de l'atmosphère terrestre, constituant ainsi le principal gaz.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la formule chimique du dioxyde de carbone ?",
    options: ["CO2", "O2", "H2CO3"],
    answer: "CO2",
    explanation:
        "Le dioxyde de carbone est représenté par la formule chimique CO2, indiquant un atome de carbone et deux atomes d'oxygène.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principal organe du système circulatoire ?",
    options: ["Le cœur", "Le foie", "Le poumon"],
    answer: "Le cœur",
    explanation:
        "Le cœur est l'organe central qui pompe le sang à travers le système circulatoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'élément le plus léger de la table périodique ?",
    options: ["Hélium", "Hydrogène", "Lithium"],
    answer: "Hydrogène",
    explanation:
        "L'hydrogène est l'élément le plus léger, avec un numéro atomique de 1.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle loi décrit la gravitation universelle ?",
    options: [
      "Loi de la gravitation de Newton",
      "Loi de Coulomb",
      "Loi de Hooke",
    ],
    answer: "Loi de la gravitation de Newton",
    explanation:
        "La loi de la gravitation de Newton décrit l'attraction entre deux corps en fonction de leur masse et de la distance les séparant.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe principal de la respiration chez l'homme ?",
    options: ["Le cœur", "Le poumon", "Le foie"],
    answer: "Le poumon",
    explanation:
        "Les poumons sont les organes responsables de l'échange gazeux dans le corps humain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Comment s'appelle le processus par lequel les plantes fabriquent leur propre nourriture ?",
    options: ["Photosynthèse", "Respiration", "Fécondation"],
    answer: "Photosynthèse",
    explanation:
        "La photosynthèse est le processus par lequel les plantes convertissent la lumière du soleil en énergie chimique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe qui produit l'insuline ?",
    options: ["Le pancréas", "Le foie", "Les reins"],
    answer: "Le pancréas",
    explanation:
        "Le pancréas est responsable de la production d'insuline, une hormone régulatrice de la glycémie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'effet de serre le plus connu ?",
    options: [
      "Effet de serre naturel",
      "Effet de serre anthropique",
      "Effet de serre artificiel",
    ],
    answer: "Effet de serre anthropique",
    explanation:
        "L'effet de serre anthropique est causé par les activités humaines et contribue au réchauffement climatique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le plus grand organe du corps humain ?",
    options: ["Le cœur", "La peau", "Le foie"],
    answer: "La peau",
    explanation:
        "La peau est le plus grand organe du corps, jouant un rôle crucial dans la protection et la régulation thermique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'acide présent dans l'estomac ?",
    options: ["Acide citrique", "Acide chlorhydrique", "Acide acétique"],
    answer: "Acide chlorhydrique",
    explanation:
        "L'acide chlorhydrique est sécrété par l'estomac pour aider à la digestion des aliments.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la vitesse moyenne de la lumière dans le vide ?",
    options: ["300 000 km/s", "150 000 km/s", "450 000 km/s"],
    answer: "300 000 km/s",
    explanation:
        "La vitesse de la lumière dans le vide est d'environ 300 000 kilomètres par seconde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom de la théorie qui décrit l'origine de l'univers ?",
    options: [
      "La théorie de l'évolution",
      "La théorie du Big Bang",
      "La théorie de la relativité",
    ],
    answer: "La théorie du Big Bang",
    explanation:
        "La théorie du Big Bang décrit l'origine de l'univers comme une expansion d'un état initial chaud et dense.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'élément essentiel à la respiration des animaux ?",
    options: ["Azote", "Oxygène", "Carbone"],
    answer: "Oxygène",
    explanation:
        "L'oxygène est essentiel pour la respiration cellulaire chez les animaux, permettant la production d'énergie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Comment s'appelle le changement d'état de l'eau de liquide à gazeux ?",
    options: ["Condensation", "Vaporisation", "Sublimation"],
    answer: "Vaporisation",
    explanation:
        "Le changement d'état de l'eau de liquide à gazeux est appelé vaporisation, généralement à température élevée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel élément est symbolisé par 'Fe' dans le tableau périodique ?",
    options: ["Fer", "Fluor", "Francium"],
    answer: "Fer",
    explanation:
        "'Fe' est le symbole chimique du fer, un métal essentiel à la construction et à la fabrication.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel type de cellule humaine contient un noyau ?",
    options: ["Cellule prokaryote", "Cellule eucaryote", "Cellule bactérienne"],
    answer: "Cellule eucaryote",
    explanation:
        "Les cellules eucaryotes contiennent un noyau, contrairement aux cellules prokaryotes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la principale source d'énergie pour la Terre ?",
    options: ["L'énergie nucléaire", "Le soleil", "Les énergies fossiles"],
    answer: "Le soleil",
    explanation:
        "Le soleil est la principale source d'énergie pour la Terre, alimentant les processus de vie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la principale fonction des globules rouges ?",
    options: [
      "Transport de l'oxygène",
      "Lutte contre les infections",
      "Coagulation",
    ],
    answer: "Transport de l'oxygène",
    explanation:
        "Les globules rouges, ou érythrocytes, transportent l'oxygène des poumons vers les tissus du corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le nom de la couche extérieure de la Terre ?",
    options: ["Manteau", "Croûte", "Noyau"],
    answer: "Croûte",
    explanation:
        "La croûte est la couche extérieure de la Terre, sur laquelle nous vivons.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel phénomène décrit le changement de couleur de la feuille en automne ?",
    options: ["Photosynthèse", "Hydrolyse", "Chlorose"],
    answer: "Chlorose",
    explanation:
        "La chlorose est la décoloration des feuilles en raison de la dégradation de la chlorophylle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle fonction remplissent les enzymes ?",
    options: [
      "Produire de l'énergie",
      "Accélérer les réactions chimiques",
      "Transporter les nutriments",
    ],
    answer: "Accélérer les réactions chimiques",
    explanation:
        "Les enzymes agissent comme des catalyseurs, augmentant la vitesse des réactions chimiques dans le corps.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du gaz toxique produit par la combustion incomplète du carbone ?",
    options: ["Dioxyde de carbone", "Monoxyde de carbone", "Oxygène"],
    answer: "Monoxyde de carbone",
    explanation:
        "Le monoxyde de carbone est un gaz incolore et inodore, dangereux en cas d'accumulation dans l'air.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe de la vue chez l'homme ?",
    options: ["L'oreille", "Le nez", "L'œil"],
    answer: "L'œil",
    explanation:
        "L'œil est l'organe responsable de la perception visuelle chez l'homme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le rôle des mitochondries dans la cellule ?",
    options: [
      "Stocker des nutriments",
      "Produire de l'énergie",
      "Réguler la température",
    ],
    answer: "Produire de l'énergie",
    explanation:
        "Les mitochondries sont souvent appelées les centrales énergétiques de la cellule, produisant de l'ATP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'acide contenu dans le vinaigre ?",
    options: ["Acide citrique", "Acide acétique", "Acide sulfurique"],
    answer: "Acide acétique",
    explanation:
        "Le vinaigre contient principalement de l'acide acétique, responsable de son goût aigre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quelle est la différence fondamentale entre les plantes et les animaux ?",
    options: [
      "Type de cellules",
      "Mode de reproduction",
      "Capacité à faire de la photosynthèse",
    ],
    answer: "Capacité à faire de la photosynthèse",
    explanation:
        "Les plantes peuvent effectuer la photosynthèse, tandis que les animaux ne le peuvent pas.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le nom du gène responsable de la couleur des yeux ?",
    options: ["Gène OCA2", "Gène SRY", "Gène TP53"],
    answer: "Gène OCA2",
    explanation:
        "Le gène OCA2 joue un rôle clé dans la détermination de la couleur des yeux chez l'homme.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est l'acide aminé essentiel que l'on ne peut pas synthétiser ?",
    options: ["Méthionine", "Alanine", "Glutamine"],
    answer: "Méthionine",
    explanation:
        "La méthionine est un acide aminé essentiel que le corps humain ne peut pas synthétiser par lui-même.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Sur quel type de roches se forment les fossiles ?",
    options: ["Roches ignées", "Roches métamorphiques", "Roches sédimentaires"],
    answer: "Roches sédimentaires",
    explanation:
        "Les fossiles se forment principalement dans les roches sédimentaires, où les organismes sont conservés.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la plus grande espèce de mammifère ?",
    options: ["Éléphant", "Baleine bleue", "Girafe"],
    answer: "Baleine bleue",
    explanation:
        "La baleine bleue est le plus grand mammifère et l'un des plus grands animaux connus sur Terre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est l'organe responsable de la détoxification dans le corps humain ?",
    options: ["Les reins", "Le foie", "Le pancréas"],
    answer: "Le foie",
    explanation:
        "Le foie joue un rôle crucial de détoxification en métabolisant les substances nocives dans le corps.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel phénomène produit de l'électricité à partir de la lumière ?",
    options: [
      "La photosynthèse",
      "L'effet photovoltaïque",
      "La thermodynamique",
    ],
    answer: "L'effet photovoltaïque",
    explanation:
        "L'effet photovoltaïque est le phénomène qui convertit la lumière en électricité, utilisé dans les panneaux solaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du processus par lequel les étoiles émettent de la lumière ?",
    options: ["Fusion nucléaire", "Fission nucléaire", "Radiation"],
    answer: "Fusion nucléaire",
    explanation:
        "La fusion nucléaire est le processus par lequel les étoiles produisent de l'énergie et émettent de la lumière.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quelle est la principale raison de la variation des saisons sur Terre ?",
    options: [
      "L'inclinaison de l'axe terrestre",
      "La distance au Soleil",
      "La rotation de la Terre",
    ],
    answer: "L'inclinaison de l'axe terrestre",
    explanation:
        "L'inclinaison de l'axe terrestre provoque les variations saisonnières en influençant l'exposition au soleil.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la méthode de reproduction des étoiles ?",
    options: ["Fission", "Méridien", "Fusion"],
    answer: "Fusion",
    explanation:
        "Les étoiles naissent par un processus de fusion, où des gaz s'unissent sous haute pression.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel phénomène décrit la diversité des espèces dans un écosystème ?",
    options: ["Succession écologique", "Évolution", "Biodiversité"],
    answer: "Biodiversité",
    explanation:
        "La biodiversité désigne la variété des espèces et des connaissances dans un écosystème donné.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel type d'énergie renouvelable est produit par le vent ?",
    options: ["Énergie solaire", "Énergie éolienne", "Énergie hydraulique"],
    answer: "Énergie éolienne",
    explanation:
        "L'énergie éolienne est produite par la conversion de la force du vent en énergie électrique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le langage de l'ADN ?",
    options: ["Acides aminés", "Nucléotides", "Protéines"],
    answer: "Nucléotides",
    explanation:
        "Les nucléotides sont les unités de base qui composent l'ADN, transportant l'information génétique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'élément chimique le plus abondant dans l'univers ?",
    options: ["Hydrogène", "Hélium", "Carbone"],
    answer: "Hydrogène",
    explanation:
        "L'hydrogène est l'élément chimique le plus abondant, représentant environ 75 % de la masse baryonique de l'univers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel gaz est produit lors de la fermentation ?",
    options: ["Oxygène", "Carbonique", "Dihydrogène"],
    answer: "Carbonique",
    explanation:
        "Le dioxyde de carbone est un sous-produit commun de la fermentation, notamment dans la production de pain et de bière.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du processus par lequel les plantes absorbent l'eau ?",
    options: ["Transpiration", "Absorption", "Photosynthèse"],
    answer: "Transpiration",
    explanation:
        "La transpiration est le processus par lequel les plantes perdent de l'eau par leurs feuilles, régulant l'équilibre hydrique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom de la maladie causée par un manque de vitamine C ?",
    options: ["Scorbut", "Rachitisme", "Anémie"],
    answer: "Scorbut",
    explanation:
        "Le scorbut est dû à une carence en vitamine C, essentiel pour la santé des tissus conjonctifs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe qui produit des spermatozoïdes ?",
    options: ["Les testicules", "Les ovaires", "La prostate"],
    answer: "Les testicules",
    explanation:
        "Les testicules sont les organes responsables de la production de spermatozoïdes chez les hommes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le nom du principal gaz à effet de serre ?",
    options: ["Méthane", "Dioxyde de carbone", "Oxyde nitreux"],
    answer: "Dioxyde de carbone",
    explanation:
        "Le dioxyde de carbone est considéré comme le principal gaz à effet de serre contribuant au réchauffement climatique.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle planète est connue comme la planète rouge ?",
    options: ["Mars", "Jupiter", "Vénus"],
    answer: "Mars",
    explanation:
        "Mars est appelée la planète rouge en raison de sa couleur due à l'oxyde de fer sur sa surface.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la formule chimique de l'eau ?",
    options: ["H₂O", "CO₂", "NaCl"],
    answer: "H₂O",
    explanation:
        "L'eau est composée de deux atomes d'hydrogène et un atome d'oxygène.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'élément chimique dont le symbole est Au ?",
    options: ["Argent", "Or", "Aluminium"],
    answer: "Or",
    explanation: "Le symbole Au vient du mot latin 'aurum', qui signifie or.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le gaz le plus abondant dans l'atmosphère terrestre ?",
    options: ["Oxygène", "Azote", "Dioxyde de carbone"],
    answer: "Azote",
    explanation: "L'azote constitue environ 78% de l'atmosphère terrestre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe qui pompe le sang dans le corps humain ?",
    options: ["Le foie", "Le cœur", "Les poumons"],
    answer: "Le cœur",
    explanation:
        "Le cœur est responsable de la circulation sanguine dans tout le corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel phénomène naturel est à l'origine des marées ?",
    options: ["La gravité de la Lune", "Le vent", "Les courants marins"],
    answer: "La gravité de la Lune",
    explanation:
        "La gravité de la Lune crée des forces qui entraînent les marées sur Terre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est l'état de la matière des glaces à température ambiante ?",
    options: ["Solide", "Liquide", "Gaz"],
    answer: "Solide",
    explanation:
        "Les glaces sont des corps solides à température ambiante normale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'ordre correct des étapes de la photosynthèse ?",
    options: [
      "Absorption, Transformation, Stockage",
      "Stockage, Absorption, Transformation",
      "Transformation, Absorption, Stockage",
    ],
    answer: "Absorption, Transformation, Stockage",
    explanation:
        "La photosynthèse commence par l'absorption de lumière, suivie par la transformation de l'énergie en glucose, puis le stockage de l'énergie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel ingrédient est essentiel à la fermentation ?",
    options: ["Le sucre", "Le sel", "L'eau"],
    answer: "Le sucre",
    explanation:
        "Le sucre est essentiel car il sert de nourriture aux levures pendant la fermentation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom donné au processus par lequel les plantes produisent leur propre nourriture ?",
    options: ["La respiration", "La photosynthèse", "L'absorption"],
    answer: "La photosynthèse",
    explanation:
        "La photosynthèse permet aux plantes de convertir la lumière en énergie chimique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Qui a formulé la théorie de la relativité ?",
    options: ["Isaac Newton", "Galileo Galilei", "Albert Einstein"],
    answer: "Albert Einstein",
    explanation:
        "Albert Einstein est célèbre pour sa théorie de la relativité, qui a révolutionné la physique moderne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le principe de base de la loi de l'offre et de la demande ?",
    options: [
      "L'augmentation des prix réduit la demande",
      "L'augmentation des prix augmente toujours l'offre",
      "La demande n'affecte pas l'offre",
    ],
    answer: "L'augmentation des prix réduit la demande",
    explanation:
        "Lorsque les prix augmentent, la demande des consommateurs a tendance à diminuer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principal gaz à effet de serre ?",
    options: ["Oxygène", "Méthane", "Dioxyde de carbone"],
    answer: "Dioxyde de carbone",
    explanation:
        "Le dioxyde de carbone est le gaz à effet de serre le plus abondant et contribue au réchauffement climatique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principal organe responsable de la digestion ?",
    options: ["L'estomac", "Le foie", "Le pancréas"],
    answer: "L'estomac",
    explanation:
        "L'estomac joue un rôle clé dans la digestion des aliments en les décomposant.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du processus par lequel l'eau passe de l'état liquide à l'état gazeux ?",
    options: ["Condensation", "Évaporation", "Sublimation"],
    answer: "Évaporation",
    explanation:
        "L'évaporation est le processus par lequel l'eau se transforme en vapeur à température ambiante.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est l'organe du corps humain responsable de la filtration du sang ?",
    options: ["Le cœur", "Les poumons", "Les reins"],
    answer: "Les reins",
    explanation:
        "Les reins filtrent le sang pour éliminer les déchets et réguler les fluides.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Qu'est-ce qui accélère une réaction chimique ?",
    options: ["Un inhibiteur", "Un solvant", "Un catalyseur"],
    answer: "Un catalyseur",
    explanation:
        "Un catalyseur augmente la vitesse d'une réaction chimique sans être consommé par celle-ci.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quelle est l'unité de mesure de la température dans le système international ?",
    options: ["Celsius", "Kelvin", "Fahrenheit"],
    answer: "Kelvin",
    explanation:
        "Le Kelvin est l'unité de mesure de la température dans le système international d'unités (SI).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principal acide présent dans l'estomac humain ?",
    options: ["Acide citrique", "Acide acétique", "Acide chlorhydrique"],
    answer: "Acide chlorhydrique",
    explanation:
        "L'acide chlorhydrique joue un rôle crucial dans la digestion des aliments dans l'estomac.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel phénomène décrit le changement d'état d'un solide directement en gaz ?",
    options: ["Condensation", "Sublimation", "Fusion"],
    answer: "Sublimation",
    explanation:
        "La sublimation est le processus où un solide se transforme directement en gaz sans passer par l'état liquide.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la formule de l'ozone ?",
    options: ["O₂", "O₃", "CO₂"],
    answer: "O₃",
    explanation:
        "L'ozone est composé de trois atomes d'oxygène, d'où sa formule O₃.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel terme désigne le phénomène de déviation de la lumière lorsqu'elle passe d'un milieu à un autre ?",
    options: ["Diffraction", "Réfraction", "Dispersion"],
    answer: "Réfraction",
    explanation:
        "La réfraction est le changement de direction des ondes lumineuses lorsqu'elles traversent des milieux différents.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Qui a découvert la circulation sanguine ?",
    options: ["Hippocrate", "William Harvey", "Galilée"],
    answer: "William Harvey",
    explanation:
        "William Harvey a été le premier à décrire la circulation sanguine de manière scientifique au XVIIe siècle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel planétaire est considéré comme le plus grand du système solaire ?",
    options: ["Terre", "Jupiter", "Saturne"],
    answer: "Jupiter",
    explanation:
        "Jupiter est la plus grande planète du système solaire, avec un diamètre d'environ 139 822 km.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe principal de l'équilibre chez l'homme ?",
    options: ["Le cerveau", "L'oreille interne", "Le cœur"],
    answer: "L'oreille interne",
    explanation:
        "L'oreille interne contient des structures qui aident à maintenir l'équilibre du corps.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel élément chimique est essentiel à la respiration cellulaire ?",
    options: ["Carbone", "Azote", "Oxygène"],
    answer: "Oxygène",
    explanation:
        "L'oxygène est crucial pour la respiration cellulaire où les cellules produisent de l'énergie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel type de réaction chimique libère de l'énergie ?",
    options: ["Endothermique", "Exothermique", "Catalytique"],
    answer: "Exothermique",
    explanation:
        "Une réaction exothermique libère de l'énergie sous forme de chaleur ou de lumière.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Dans quel organe se trouve la bile ?",
    options: ["Le foie", "Le pancréas", "La vésicule biliaire"],
    answer: "La vésicule biliaire",
    explanation:
        "La bile est stockée dans la vésicule biliaire avant d'être libérée dans l'intestin.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la principale source de lumière pour notre planète ?",
    options: ["La Lune", "Le Soleil", "Les étoiles"],
    answer: "Le Soleil",
    explanation:
        "Le Soleil est notre principale source de lumière et d'énergie sur Terre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principal organe de la respiration chez l'homme ?",
    options: ["Les reins", "Les poumons", "Le cœur"],
    answer: "Les poumons",
    explanation:
        "Les poumons sont responsables de l'échange gazeux dans le corps humain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle planète est connue comme la planète rouge ?",
    options: ["Mars", "Jupiter", "Vénus"],
    answer: "Mars",
    explanation:
        "Mars est appelée la planète rouge en raison de sa couleur due à l'oxyde de fer sur sa surface.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la formule chimique de l'eau ?",
    options: ["H₂O", "CO₂", "NaCl"],
    answer: "H₂O",
    explanation:
        "L'eau est composée de deux atomes d'hydrogène et un atome d'oxygène.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'élément chimique dont le symbole est Au ?",
    options: ["Argent", "Or", "Aluminium"],
    answer: "Or",
    explanation: "Le symbole Au vient du mot latin 'aurum', qui signifie or.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le gaz le plus abondant dans l'atmosphère terrestre ?",
    options: ["Oxygène", "Azote", "Dioxyde de carbone"],
    answer: "Azote",
    explanation: "L'azote constitue environ 78% de l'atmosphère terrestre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe qui pompe le sang dans le corps humain ?",
    options: ["Le foie", "Le cœur", "Les poumons"],
    answer: "Le cœur",
    explanation:
        "Le cœur est responsable de la circulation sanguine dans tout le corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel phénomène naturel est à l'origine des marées ?",
    options: ["La gravité de la Lune", "Le vent", "Les courants marins"],
    answer: "La gravité de la Lune",
    explanation:
        "La gravité de la Lune crée des forces qui entraînent les marées sur Terre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est l'état de la matière des glaces à température ambiante ?",
    options: ["Solide", "Liquide", "Gaz"],
    answer: "Solide",
    explanation:
        "Les glaces sont des corps solides à température ambiante normale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'ordre correct des étapes de la photosynthèse ?",
    options: [
      "Absorption, Transformation, Stockage",
      "Stockage, Absorption, Transformation",
      "Transformation, Absorption, Stockage",
    ],
    answer: "Absorption, Transformation, Stockage",
    explanation:
        "La photosynthèse commence par l'absorption de lumière, suivie par la transformation de l'énergie en glucose, puis le stockage de l'énergie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel ingrédient est essentiel à la fermentation ?",
    options: ["Le sucre", "Le sel", "L'eau"],
    answer: "Le sucre",
    explanation:
        "Le sucre est essentiel car il sert de nourriture aux levures pendant la fermentation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom donné au processus par lequel les plantes produisent leur propre nourriture ?",
    options: ["La respiration", "La photosynthèse", "L'absorption"],
    answer: "La photosynthèse",
    explanation:
        "La photosynthèse permet aux plantes de convertir la lumière en énergie chimique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Qui a formulé la théorie de la relativité ?",
    options: ["Isaac Newton", "Galileo Galilei", "Albert Einstein"],
    answer: "Albert Einstein",
    explanation:
        "Albert Einstein est célèbre pour sa théorie de la relativité, qui a révolutionné la physique moderne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le principe de base de la loi de l'offre et de la demande ?",
    options: [
      "L'augmentation des prix réduit la demande",
      "L'augmentation des prix augmente toujours l'offre",
      "La demande n'affecte pas l'offre",
    ],
    answer: "L'augmentation des prix réduit la demande",
    explanation:
        "Lorsque les prix augmentent, la demande des consommateurs a tendance à diminuer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principal gaz à effet de serre ?",
    options: ["Oxygène", "Méthane", "Dioxyde de carbone"],
    answer: "Dioxyde de carbone",
    explanation:
        "Le dioxyde de carbone est le gaz à effet de serre le plus abondant et contribue au réchauffement climatique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principal organe responsable de la digestion ?",
    options: ["L'estomac", "Le foie", "Le pancréas"],
    answer: "L'estomac",
    explanation:
        "L'estomac joue un rôle clé dans la digestion des aliments en les décomposant.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du processus par lequel l'eau passe de l'état liquide à l'état gazeux ?",
    options: ["Condensation", "Évaporation", "Sublimation"],
    answer: "Évaporation",
    explanation:
        "L'évaporation est le processus par lequel l'eau se transforme en vapeur à température ambiante.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel organe se trouve dans le système circulatoire humain ?",
    options: ["Le foie", "Les reins", "Le cœur"],
    answer: "Le cœur",
    explanation:
        "Le cœur est essentiel au système circulatoire, pompant le sang à travers le corps.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le type de cellule responsable de la transmission des signaux nerveux ?",
    options: ["Les neurones", "Les globules rouges", "Les lymphocytes"],
    answer: "Les neurones",
    explanation:
        "Les neurones sont spécialisés dans la transmission des signaux dans le système nerveux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel gaz est produit lors de la respiration des êtres vivants ?",
    options: ["Dioxyde de carbone", "Oxygène", "Azote"],
    answer: "Dioxyde de carbone",
    explanation:
        "Le dioxyde de carbone est un sous-produit de la respiration cellulaire.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la planète la plus proche du Soleil ?",
    options: ["Vénus", "Terre", "Mercure"],
    answer: "Mercure",
    explanation:
        "Mercure est la planète la plus proche du Soleil dans notre système solaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la formule chimique de l'eau ?",
    options: ["H2O", "O2H", "CO2"],
    answer: "H2O",
    explanation:
        "La formule chimique de l'eau est H2O, indiquant qu'elle est composée de deux atomes d'hydrogène et un atome d'oxygène.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe principal de la respiration chez l'homme ?",
    options: ["Le cœur", "Les poumons", "Le foie"],
    answer: "Les poumons",
    explanation:
        "Les poumons sont les organes qui permettent l'échange de gaz et la respiration.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel gaz est essentiel à la respiration des êtres vivants ?",
    options: ["Oxygène", "Azote", "Dioxyde de carbone"],
    answer: "Oxygène",
    explanation:
        "L'oxygène est le gaz que les êtres vivants inhalent pour respirer et produire de l'énergie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Qui a développé la théorie de la relativité ?",
    options: ["Isaac Newton", "Albert Einstein", "Galilée"],
    answer: "Albert Einstein",
    explanation:
        "Albert Einstein est célèbre pour avoir formulé la théorie de la relativité, qui a révolutionné la physique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le symbole chimique du fer ?",
    options: ["Fe", "F", "Ir"],
    answer: "Fe",
    explanation:
        "Le fer a pour symbole chimique 'Fe', dérivé du latin 'ferrum'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'élément le plus léger du tableau périodique ?",
    options: ["Hydrogène", "Hélium", "Lithium"],
    answer: "Hydrogène",
    explanation:
        "L'hydrogène est l'élément le plus léger et le premier du tableau périodique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la plus grande partie du cerveau humain ?",
    options: ["Cervelet", "Cortex cérébral", "Tronc cérébral"],
    answer: "Cortex cérébral",
    explanation:
        "Le cortex cérébral est la plus grande partie du cerveau et est responsable de nombreuses fonctions cognitives.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel phénomène physique explique la montée de l'eau dans les plantes ?",
    options: ["Capillarité", "Gravité", "Diffusion"],
    answer: "Capillarité",
    explanation:
        "La capillarité permet à l'eau de monter dans les petites racines et tiges des plantes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la vitesse de la lumière dans le vide ?",
    options: ["300 000 km/s", "150 000 km/s", "450 000 km/s"],
    answer: "300 000 km/s",
    explanation:
        "La vitesse de la lumière dans le vide est d'environ 300 000 km/s.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe responsable de la filtration du sang ?",
    options: ["Le cerveau", "Les reins", "Le foie"],
    answer: "Les reins",
    explanation:
        "Les reins filtrent le sang pour éliminer les déchets et réguler les fluides corporels.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le principal composant de l'air que nous respirons ?",
    options: ["Oxygène", "Dioxyde de carbone", "Azote"],
    answer: "Azote",
    explanation: "L'azote constitue environ 78% de l'air que nous respirons.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel instrument mesure la pression atmosphérique ?",
    options: ["Thermomètre", "Baromètre", "Hygromètre"],
    answer: "Baromètre",
    explanation:
        "Le baromètre est utilisé pour mesurer la pression atmosphérique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la couche externe de la Terre ?",
    options: ["Manteau", "Croûte", "Noyau"],
    answer: "Croûte",
    explanation:
        "La croûte terrestre est la couche externe de la Terre où nous vivons.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel type d'énergie est produite par le mouvement de l'eau ?",
    options: ["Énergie cinétique", "Énergie potentielle", "Énergie thermique"],
    answer: "Énergie cinétique",
    explanation:
        "L'énergie cinétique est l'énergie produite par le mouvement de l'eau.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe responsable de la circulation sanguine ?",
    options: ["Le cœur", "Le poumon", "Le foie"],
    answer: "Le cœur",
    explanation:
        "Le cœur est l'organe principal qui pompe le sang à travers le corps.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom de la théorie qui décrit l'évolution des espèces ?",
    options: [
      "Théorie de l'évolution",
      "Théorie de la création",
      "Théorie des espèces fixistes",
    ],
    answer: "Théorie de l'évolution",
    explanation:
        "La théorie de l'évolution, formulée par Darwin, explique comment les espèces évoluent au fil du temps.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel type de cellule est responsable de la transmission des données génétiques ?",
    options: [
      "Cellule nerveuse",
      "Cellule musculaire",
      "Cellule reproductrice",
    ],
    answer: "Cellule reproductrice",
    explanation:
        "Les cellules reproductrices, comme les spermatozoïdes et les ovules, transmettent les données génétiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est l'acide présent dans l'estomac qui aide à la digestion ?",
    options: ["Acide citrique", "Acide chlorhydrique", "Acide acétique"],
    answer: "Acide chlorhydrique",
    explanation:
        "L'acide chlorhydrique est secreté par l'estomac et joue un rôle clé dans la digestion.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom donné au processus par lequel les plantes fabriquent leur propre nourriture ?",
    options: ["Photosynthèse", "Respiration", "Fermentation"],
    answer: "Photosynthèse",
    explanation:
        "La photosynthèse est le processus par lequel les plantes convertissent la lumière solaire en énergie chimique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quelle est la force qui attire les objets vers le centre de la Terre ?",
    options: ["Électricité", "Magnétisme", "Gravité"],
    answer: "Gravité",
    explanation:
        "La gravité est la force qui attire les objets vers le centre de la Terre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le nom de l'élément chimique dont le symbole est 'O' ?",
    options: ["Oxygène", "Or", "Ozone"],
    answer: "Oxygène",
    explanation:
        "Le symbole 'O' représente l'oxygène, un élément essentiel à la vie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est l'unité de mesure de la force ?",
    options: ["Newton", "Joule", "Pascal"],
    answer: "Newton",
    explanation:
        "Le Newton est l'unité de mesure de la force dans le système international d'unités.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel phénomène décrit la séparation de la lumière en ses couleurs ?",
    options: ["Diffraction", "Réfraction", "Dissémination"],
    answer: "Réfraction",
    explanation:
        "La réfraction est le phénomène par lequel la lumière change de direction en passant d'un milieu à un autre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la plus grande structure de l'Univers connue ?",
    options: ["Galaxie", "Superamas", "Étoile"],
    answer: "Superamas",
    explanation:
        "Les superamas sont les plus grandes structures de l'Univers, regroupant des milliers de galaxies.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe qui produit l'insuline dans le corps humain ?",
    options: ["Pancréas", "Foie", "Estomac"],
    answer: "Pancréas",
    explanation:
        "Le pancréas est l'organe responsable de la production de l'insuline, régulant le taux de sucre dans le sang.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la vitesse de l'onde sonore dans l'air ?",
    options: ["343 m/s", "123 m/s", "234 m/s"],
    answer: "343 m/s",
    explanation:
        "La vitesse du son dans l'air est d'environ 343 mètres par seconde.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le principal gaz à effet de serre émis par les activités humaines ?",
    options: ["Dioxyde de carbone", "Méthane", "Oxyde nitreux"],
    answer: "Dioxyde de carbone",
    explanation:
        "Le dioxyde de carbone est le principal gaz à effet de serre résultant des activités humaines, notamment la combustion des fossiles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe principal de la vision ?",
    options: ["L'oreille", "L'œil", "Le nez"],
    answer: "L'œil",
    explanation:
        "L'œil est l'organe principal qui nous permet de voir et de percevoir la lumière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel élément est essentiel à la photosynthèse ?",
    options: ["Oxygène", "Chlorophylle", "Azote"],
    answer: "Chlorophylle",
    explanation:
        "La chlorophylle est essentielle à la photosynthèse car elle capte la lumière solaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom de l'échelle utilisée pour mesurer la magnitude des tremblements de terre ?",
    options: [
      "Échelle de Richter",
      "Échelle de Beaufort",
      "Échelle de Celsius",
    ],
    answer: "Échelle de Richter",
    explanation:
        "L'échelle de Richter mesure la magnitude des tremblements de terre en fonction de l'énergie libérée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quelle est la forme d'énergie qui provient du mouvement de la chaleur ?",
    options: ["Énergie thermique", "Énergie cinétique", "Énergie chimique"],
    answer: "Énergie thermique",
    explanation:
        "L'énergie thermique provient du mouvement des particules et de la chaleur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est l'acide qui se trouve dans l'acide lactique produit lors de l'effort physique ?",
    options: ["Acide citrique", "Acide lactique", "Acide sulfurique"],
    answer: "Acide lactique",
    explanation:
        "L'acide lactique est produit par le corps pendant l'exercice lorsque l'oxygène est limité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du système responsable de la régulation de la température corporelle ?",
    options: ["Système nerveux", "Système circulatoire", "Système endocrinien"],
    answer: "Système endocrinien",
    explanation:
        "Le système endocrinien régule de nombreuses fonctions corporelles, y compris la température.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du processus de transformation d'un liquide en gaz ?",
    options: ["Condensation", "Évaporation", "Solidification"],
    answer: "Évaporation",
    explanation:
        "L'évaporation est le processus par lequel un liquide se transforme en gaz.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel type de roche provient de la solidification du magma ?",
    options: ["Roches sédimentaires", "Roches métamorphiques", "Roches ignées"],
    answer: "Roches ignées",
    explanation:
        "Les roches ignées se forment à partir de la solidification du magma ou de la lave.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe principal du système immunitaire ?",
    options: ["Le cœur", "La rate", "Le thymus"],
    answer: "La rate",
    explanation:
        "La rate joue un rôle crucial dans le système immunitaire en filtrant le sang et en produisant des lymphocytes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel instrument est utilisé pour observer les petits objets ?",
    options: ["Loupes", "Télescopes", "Microscopes"],
    answer: "Microscopes",
    explanation:
        "Les microscopes permettent d'observer des objets très petits que l'œil humain ne peut pas voir.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe le plus grand du corps humain ?",
    options: ["Le foie", "La peau", "Le cœur"],
    answer: "La peau",
    explanation:
        "La peau est l'organe le plus grand du corps humain et joue un rôle protecteur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la principale source d'énergie de la Terre ?",
    options: ["Le vent", "Le soleil", "Le charbon"],
    answer: "Le soleil",
    explanation:
        "Le soleil est la principale source d'énergie pour la Terre, alimentant les écosystèmes et le climat.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom du processus par lequel les ovules se transforment en embryons ?",
    options: ["Fécondation", "Implantation", "Ovulation"],
    answer: "Fécondation",
    explanation:
        "La fécondation est le processus par lequel un ovule est unionné avec un spermatozoïde pour créer un embryon.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la plus grande cellule du corps humain ?",
    options: ["Le spermatozoïde", "L'ovule", "La cellule musculaire"],
    answer: "L'ovule",
    explanation:
        "L'ovule est la plus grande cellule du corps humain, visible à l'œil nu.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le principal gaz responsable de l'ozone stratosphérique ?",
    options: ["Dioxyde de soufre", "Dioxygène", "Ozone"],
    answer: "Dioxygène",
    explanation:
        "Le dioxygène est essentiel à la formation de l'ozone dans la stratosphère.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est le nom de la science qui étudie les organismes vivants ?",
    options: ["Biologie", "Chimie", "Physique"],
    answer: "Biologie",
    explanation:
        "La biologie est la science qui étudie les organismes vivants et leurs interactions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quel est l'organe qui joue un rôle clé dans la digestion des graisses ?",
    options: ["Le foie", "Le pancreas", "L'estomac"],
    answer: "Le foie",
    explanation:
        "Le foie produit de la bile, qui est essentielle à la digestion des graisses.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quelle est la durée d'une année sur Mars ?",
    options: ["687 jours", "365 jours", "225 jours"],
    answer: "687 jours",
    explanation: "Une année martienne dure environ 687 jours terrestres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est le plus grand mammifère terrestre vivant ?",
    options: ["Éléphant", "Rhinocéros", "Bison"],
    answer: "Éléphant",
    explanation:
        "L'éléphant est le plus grand mammifère terrestre vivant sur la planète.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'organe responsable de la détection des sons ?",
    options: ["L'oreille", "L'œil", "Le nez"],
    answer: "L'oreille",
    explanation:
        "L'oreille est l'organe qui permet de détecter et d'analyser les sons.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question: "Quel est l'acide utilisé dans les batteries au plomb ?",
    options: ["Acide sulfurique", "Acide chlorhydrique", "Acide azotique"],
    answer: "Acide sulfurique",
    explanation:
        "L'acide sulfurique est couramment utilisé dans les batteries au plomb pour le stockage de l'énergie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Sciences",
    question:
        "Quelle partie de la plante est généralement colorée et attire les pollinisateurs ?",
    options: ["Les racines", "Les feuilles", "Les fleurs"],
    answer: "Les fleurs",
    explanation:
        "Les fleurs, souvent colorées, attirent les pollinisateurs comme les abeilles et les papillons.",
    difficulty: "Facile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizCultureGeneraleSciences extends StatefulWidget {
  static const String routeName =
      '/gpx_exam/concours/culture_generale_sciences';
  final String uid;
  final String email;

  const QuizCultureGeneraleSciences({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizCultureGeneraleSciences> createState() =>
      _QuizCultureGeneraleSciencesState();
}

class _QuizCultureGeneraleSciencesState
    extends State<QuizCultureGeneraleSciences>
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
        ? questionCultureSciences
        : questionCultureSciences
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
            'module_name': 'Culture générale - Sciences',
            'quiz_name': 'Quiz culture générale sciences',
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
      await _sb.from('quiz_culture_generale_sciences_pages').insert({
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
      debugPrint('❌ quiz_culture_generale_sciences_pages insert failed: $e');
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
