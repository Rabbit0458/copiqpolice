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

final List<QuizQuestion> questionCultureMythologie = [
  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le roi des dieux dans la mythologie romaine ?",
    options: ["Jupiter", "Mars", "Neptune"],
    answer: "Jupiter",
    explanation:
        "Jupiter est considéré comme le roi des dieux dans la mythologie romaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le royaume d'Hadès dans la mythologie grecque ?",
    options: ["Les champs Élysées", "L'Olympe", "L'Enfer"],
    answer: "L'Enfer",
    explanation:
        "Hadès est le dieu des morts et son royaume est souvent appelé l'Enfer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle déesse est souvent associée à la guerre dans la mythologie grecque ?",
    options: ["Athena", "Aphrodite", "Héra"],
    answer: "Athena",
    explanation:
        "Athena est la déesse de la guerre, de la sagesse et des arts dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Comment s'appelle le serpent géant de la mythologie nordique ?",
    options: ["Fenrir", "Jörmungandr", "Nidhogg"],
    answer: "Jörmungandr",
    explanation:
        "Jörmungandr est le serpent de mer géant dans la mythologie nordique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle est la source de la force d'Hercule ?",
    options: ["Sa colère", "Son père", "Son intelligence"],
    answer: "Son père",
    explanation:
        "Hercule tire sa force de sa nature divine, étant le fils de Zeus.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Que représente le sphinx dans la mythologie égyptienne ?",
    options: ["La sagesse", "La protection", "Le savoir"],
    answer: "La protection",
    explanation:
        "Le sphinx est souvent associé à la protection des tombeaux et des temples.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a piégé Phaéton dans un char de soleil ?",
    options: ["Apollon", "Hercule", "Zeus"],
    answer: "Apollon",
    explanation:
        "Apollon est le dieu du soleil et a permis à Phaéton de conduire son char.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est l'animal sacré d'Athena ?",
    options: ["Le hibou", "Le lion", "Le serpent"],
    answer: "Le hibou",
    explanation:
        "Le hibou est considéré comme le symbole de sagesse associé à Athena.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu romain du vin ?",
    options: ["Dionysos", "Bacchus", "Poséidon"],
    answer: "Bacchus",
    explanation: "Bacchus est le dieu romain du vin et des réjouissances.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la chasse dans la mythologie grecque ?",
    options: ["Artémis", "Déméter", "Hestia"],
    answer: "Artémis",
    explanation: "Artémis est la déesse de la chasse et de la nature sauvage.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros grec a vaincu le Minotaure ?",
    options: ["Thésée", "Achille", "Ulysse"],
    answer: "Thésée",
    explanation:
        "Thésée est célèbre pour avoir tué le Minotaure dans le labyrinthe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "De quelle manière Prométhée a-t-il été puni par Zeus ?",
    options: [
      "Il a été exilé",
      "Il a été enchaîné",
      "Il a été transformé en oiseau",
    ],
    answer: "Il a été enchaîné",
    explanation:
        "Prométhée a été enchaîné à un rocher où un aigle lui dévorait le foie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de l'amour dans la mythologie grecque ?",
    options: ["Aphrodite", "Héra", "Artemis"],
    answer: "Aphrodite",
    explanation: "Aphrodite est la déesse de l'amour et de la beauté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du dieu grec des océans ?",
    options: ["Poséidon", "Zeus", "Hadès"],
    answer: "Poséidon",
    explanation: "Poséidon est le dieu grec des mers et des océans.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a accompli les douze travaux ?",
    options: ["Achille", "Hercule", "Jason"],
    answer: "Hercule",
    explanation:
        "Hercule est célèbre pour ses douze travaux imposés par Eurysthée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui, dans la mythologie égyptienne, pèse le cœur des défunts ?",
    options: ["Anubis", "Osiris", "Thot"],
    answer: "Anubis",
    explanation:
        "Anubis est le dieu des morts qui pèse le cœur lors du jugement des âmes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle créature mythologique a une tête de femme et un corps de serpent ?",
    options: ["La sirène", "La méduse", "La sphinx"],
    answer: "La méduse",
    explanation:
        "La méduse est une créature avec des cheveux de serpents et un regard pétrifiant.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a offert la pomme de la discorde ?",
    options: ["Eris", "Athena", "Héra"],
    answer: "Eris",
    explanation:
        "Eris, la déesse de la discorde, a offert la pomme qui a provoqué la guerre de Troie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle divinité est associée à la moisson dans la mythologie grecque ?",
    options: ["Déméter", "Perséphone", "Gaïa"],
    answer: "Déméter",
    explanation: "Déméter est la déesse des moissons et de l'agriculture.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel était le nom du cheval ailé de Bellérophon ?",
    options: ["Pégase", "Triton", "Sleipnir"],
    answer: "Pégase",
    explanation:
        "Pégase est le cheval ailé associé à Bellérophon dans la mythologie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui était le père de Zeus ?",
    options: ["Cronos", "Ouranos", "Hadès"],
    answer: "Cronos",
    explanation: "Cronos est le père de Zeus dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu est souvent représenté avec une foudre ?",
    options: ["Zeus", "Hercule", "Apollon"],
    answer: "Zeus",
    explanation:
        "Zeus est souvent représenté comme le maître de la foudre dans la mythologie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu des forgerons dans la mythologie grecque ?",
    options: ["Héphaïstos", "Hermès", "Arès"],
    answer: "Héphaïstos",
    explanation:
        "Héphaïstos est le dieu du feu et des forgerons dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel animal est associé à la déesse Héra ?",
    options: ["Le paon", "Le serpent", "Le cygne"],
    answer: "Le paon",
    explanation: "Le paon est un symbole associé à Héra, déesse du mariage.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le principal symbole de la déesse de la sagesse ?",
    options: ["L'olive", "Le serpent", "La chouette"],
    answer: "La chouette",
    explanation: "La chouette est un symbole de sagesse associé à Athena.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la victoire dans la mythologie grecque ?",
    options: ["Niki", "Tyche", "Gaïa"],
    answer: "Niki",
    explanation:
        "Niki est la déesse de la victoire dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Que représente le caducée, le symbole d'Hermès ?",
    options: ["La paix", "Le commerce", "La guerre"],
    answer: "Le commerce",
    explanation:
        "Le caducée est traditionnellement un symbole du commerce et des échanges.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui était la mère de Zeus dans la mythologie grecque ?",
    options: ["Rhéa", "Gaïa", "Héra"],
    answer: "Rhéa",
    explanation:
        "Rhéa est la mère des dieux, y compris Zeus, dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le titan qui soutient le ciel ?",
    options: ["Atlas", "Cronos", "Prométhée"],
    answer: "Atlas",
    explanation:
        "Atlas est le titan chargé de soutenir le ciel sur ses épaules.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la terre dans la mythologie grecque ?",
    options: ["Gaïa", "Hécate", "Déméter"],
    answer: "Gaïa",
    explanation:
        "Gaïa est la déesse primordiale de la terre dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du dieu du vent ?",
    options: ["Éole", "Poséidon", "Zeus"],
    answer: "Éole",
    explanation: "Éole est le dieu des vents dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la lune dans la mythologie grecque ?",
    options: ["Sélène", "Artémis", "Demeter"],
    answer: "Sélène",
    explanation:
        "Sélène est la déesse de la lune et est souvent représentée dans la mythologie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom de l'épouse d'Hadès ?",
    options: ["Perséphone", "Héra", "Athena"],
    answer: "Perséphone",
    explanation: "Perséphone est l'épouse d'Hadès et la reine des enfers.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du roi des Titans ?",
    options: ["Cronos", "Uranos", "Gaïa"],
    answer: "Cronos",
    explanation: "Cronos est le roi des Titans dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le principal attribut de Poséidon ?",
    options: ["Le trident", "La lyre", "Le sceptre"],
    answer: "Le trident",
    explanation:
        "Le trident est l'attribut principal de Poséidon, le dieu de la mer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la guerre dans la mythologie romaine ?",
    options: ["Bellona", "Minerva", "Vénus"],
    answer: "Bellona",
    explanation:
        "Bellona est la déesse de la guerre dans la mythologie romaine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Comment se nomme la déesse de la fertilité en Égypte ?",
    options: ["Isis", "Neith", "Hathor"],
    answer: "Isis",
    explanation:
        "Isis est la déesse de la fertilité, de la maternité et de la magie en Égypte.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a utilisé des sandales ailées pour voler ?",
    options: ["Hermès", "Achille", "Jason"],
    answer: "Hermès",
    explanation:
        "Hermès est souvent représenté avec des sandales ailées lui permettant de voler.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la chasse dans la mythologie romaine ?",
    options: ["Diana", "Artemis", "Aphrodite"],
    answer: "Diana",
    explanation: "Diana est la déesse de la chasse dans la mythologie romaine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle est la signification de l'Acropole ?",
    options: ["Ville haute", "Temple sacré", "Colline de la sagesse"],
    answer: "Ville haute",
    explanation:
        "L'Acropole désigne la partie haute de la ville d'Athènes, souvent sacrée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle créature a une tête de lion et un corps de femme dans la mythologie égyptienne ?",
    options: ["Sphinx", "Manticore", "Chimère"],
    answer: "Sphinx",
    explanation:
        "Le sphinx égyptien est une créature avec la tête d'un homme (ou d'un lion) et le corps d'un lion.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom de la déesse de la sagesse en Égypte ?",
    options: ["Maât", "Isis", "Neith"],
    answer: "Maât",
    explanation:
        "Maât est la déesse de la vérité, de la justice et de la sagesse.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a donné son nom à la constellation du Taureau ?",
    options: ["Aldebaran", "Orion", "Hercule"],
    answer: "Aldebaran",
    explanation:
        "Aldebaran est une étoile brillante dans la constellation du Taureau.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu grec est le messager des dieux ?",
    options: ["Hermès", "Apollon", "Hercule"],
    answer: "Hermès",
    explanation:
        "Hermès est connu comme le messager des dieux dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel animal est associé au dieu grec Arès ?",
    options: ["Le chien", "Le serpent", "Le coq"],
    answer: "Le coq",
    explanation: "Le coq est souvent associé au dieu de la guerre, Arès.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a fondé la ville de Rome selon la légende ?",
    options: ["Romulus", "Rémus", "Achille"],
    answer: "Romulus",
    explanation: "Romulus est le fondateur légendaire de Rome.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le symbole de la déesse Artémis ?",
    options: ["L'arc", "Le miroir", "Le serpent"],
    answer: "L'arc",
    explanation: "L'arc est le principal attribut de la déesse Artémis.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est l'autre nom d'Hercule dans la mythologie romaine ?",
    options: ["Herculis", "Heracles", "Herculeus"],
    answer: "Heracles",
    explanation: "Heracles est le nom romain d'Hercule dans la mythologie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la ville où se trouve le célèbre temple de Zeus ?",
    options: ["Olympie", "Athènes", "Corinthe"],
    answer: "Olympie",
    explanation:
        "Le temple de Zeus était situé à Olympie, un site sacré pour les anciens Grecs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui sont les Muses dans la mythologie grecque ?",
    options: [
      "Déesse de l'inspiration",
      "Sœurs de Zeus",
      "Déesse de la sagesse",
    ],
    answer: "Déesse de l'inspiration",
    explanation:
        "Les Muses sont considérées comme les déesses de l'inspiration artistique.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le roi des dieux dans la mythologie grecque ?",
    options: ["Zeus", "Hadès", "Poséidon"],
    answer: "Zeus",
    explanation:
        "Zeus est considéré comme le roi des dieux dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle héroïne est connue pour avoir tissé une toile magnifique et affronté Athéna ?",
    options: ["Pénélope", "Arachne", "Icare"],
    answer: "Arachne",
    explanation:
        "Arachne a défié Athéna en tissant une toile si belle qu'elle a été punie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel être mythologique a des ailes et a été considéré comme un messager des dieux ?",
    options: ["Hermès", "Prométhée", "Hercule"],
    answer: "Hermès",
    explanation:
        "Hermès est le messager des dieux et est souvent représenté avec des ailes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a été puni à rouler un rocher éternellement en enfer ?",
    options: ["Sisyphe", "Tartare", "Orphée"],
    answer: "Sisyphe",
    explanation:
        "Sisyphe est condamné à pousser un rocher en haut d'une colline, qui roule toujours vers le bas.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse de l'amour est également associée à la beauté ?",
    options: ["Athéna", "Artémis", "Aphrodite"],
    answer: "Aphrodite",
    explanation:
        "Aphrodite est la déesse de l'amour et de la beauté dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel titan a volé le feu aux dieux pour le donner aux humains ?",
    options: ["Cronos", "Prométhée", "Atlas"],
    answer: "Prométhée",
    explanation:
        "Prométhée est connu pour avoir dérobé le feu aux dieux pour l'offrir aux mortels.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu de la guerre dans la mythologie romaine ?",
    options: ["Mars", "Jupiter", "Vénus"],
    answer: "Mars",
    explanation: "Mars est le dieu de la guerre dans la mythologie romaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du chien à trois têtes de la mythologie grecque ?",
    options: ["Cerbère", "Chimère", "Hydre"],
    answer: "Cerbère",
    explanation:
        "Cerbère est le chien à trois têtes qui garde l'entrée des enfers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle déesse est souvent associée à la chasse et aux animaux sauvages ?",
    options: ["Artemis", "Déméter", "Héra"],
    answer: "Artemis",
    explanation:
        "Artemis est la déesse de la chasse et des animaux sauvages dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a construit les murs de Troie avec l'aide d'Athènes ?",
    options: ["Hector", "Laomédon", "Priam"],
    answer: "Laomédon",
    explanation:
        "Laomédon, roi de Troie, a fait construire les murs de la ville grâce à l'aide divine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros a fait le voyage jusqu'aux Enfers pour retrouver sa fiancée ?",
    options: ["Hercule", "Orphée", "Thésée"],
    answer: "Orphée",
    explanation:
        "Orphée est célèbre pour avoir descendu aux Enfers pour ramener sa femme, Eurydice.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est le père de tous les dieux dans la mythologie égyptienne ?",
    options: ["Râ", "Osiris", "Amon"],
    answer: "Râ",
    explanation:
        "Râ est considéré comme le dieu suprême et le père de tous les dieux dans la mythologie égyptienne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du célèbre cheval de Troie ?",
    options: ["Pégase", "Syrinx", "Le Cheval de Troie"],
    answer: "Le Cheval de Troie",
    explanation:
        "Le Cheval de Troie a été utilisé par les Grecs pour infiltrer la ville de Troie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel personnage mythologique est connu pour avoir des pieds ailés ?",
    options: ["Hermès", "Zeus", "Achille"],
    answer: "Hermès",
    explanation:
        "Hermès a des pieds ailés, ce qui lui permet de se déplacer rapidement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la sagesse dans la mythologie grecque ?",
    options: ["Athéna", "Héra", "Déméter"],
    answer: "Athéna",
    explanation:
        "Athéna est la déesse de la sagesse et de la guerre stratégique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle figure mythologique est souvent représentée avec une lyre ?",
    options: ["Orphée", "Hercule", "Achille"],
    answer: "Orphée",
    explanation:
        "Orphée est célèbre pour son talent musical et est souvent représenté avec une lyre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros a mené les Argonautes à la recherche de la Toison d'Or ?",
    options: ["Jason", "Hercule", "Thésée"],
    answer: "Jason",
    explanation:
        "Jason a dirigé les Argonautes pour récupérer la précieuse Toison d'Or.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle mythologie contient le personnage de Loki ?",
    options: ["Nordique", "Égyptienne", "Grecque"],
    answer: "Nordique",
    explanation:
        "Loki est un personnage central de la mythologie nordique, connu pour sa malice.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu grec des océans ?",
    options: ["Poséidon", "Néréus", "Hades"],
    answer: "Poséidon",
    explanation:
        "Poséidon est le dieu des mers et des océans dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel titan a été condamné à porter le ciel sur ses épaules ?",
    options: ["Atlas", "Cronos", "Prométhée"],
    answer: "Atlas",
    explanation:
        "Atlas est le titan qui est condamné à porter le ciel sur ses épaules.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu du vin dans la mythologie romaine ?",
    options: ["Bacchus", "Mars", "Apollon"],
    answer: "Bacchus",
    explanation:
        "Bacchus est le dieu du vin et de la fête dans la mythologie romaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse est connue pour ses pouvoirs de guérison ?",
    options: ["Déméter", "Hécate", "Asclépios"],
    answer: "Asclépios",
    explanation:
        "Asclépios est le dieu de la médecine et de la guérison dans la mythologie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel être mythologique est souvent le gardien des portes du monde souterrain ?",
    options: ["Charon", "Hadès", "Cerbère"],
    answer: "Charon",
    explanation:
        "Charon est le passeur qui conduit les âmes à travers le Styx vers l'enfer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros est célèbre pour avoir réalisé douze travaux impossibles ?",
    options: ["Hercule", "Achille", "Thésée"],
    answer: "Hercule",
    explanation:
        "Hercule est connu pour ses douze travaux, qui démontrent sa force et son courage.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du roi de la mer dans la mythologie égyptienne ?",
    options: ["Osiris", "Râ", "Sobek"],
    answer: "Sobek",
    explanation:
        "Sobek est le dieu-crocodile de l'eau et des marais dans la mythologie égyptienne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu du soleil dans la mythologie grecque ?",
    options: ["Apollon", "Hélios", "Zeus"],
    answer: "Hélios",
    explanation:
        "Hélios est le dieu du soleil et est souvent représenté conduisant un char de feu.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom de la montagne où résident les dieux grecs ?",
    options: ["Mont Olympe", "Mont Atlas", "Mont Parnasse"],
    answer: "Mont Olympe",
    explanation:
        "Le Mont Olympe est la résidence des dieux dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du dieu des morts dans la mythologie égyptienne ?",
    options: ["Osiris", "Anubis", "Râ"],
    answer: "Osiris",
    explanation:
        "Osiris est le dieu des morts et de la résurrection dans la mythologie égyptienne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la chasse dans la mythologie romaine ?",
    options: ["Diana", "Vénus", "Minerve"],
    answer: "Diana",
    explanation: "Diana est la déesse de la chasse dans la mythologie romaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros est connu pour sa force surhumaine et ses escroqueries ?",
    options: ["Hercule", "Achille", "Ulysse"],
    answer: "Ulysse",
    explanation:
        "Ulysse est célèbre pour son intelligence et ses ruses durant son long voyage.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Comment s'appelle la déesse de la sagesse dans la mythologie romaine ?",
    options: ["Minerva", "Vénus", "Déméter"],
    answer: "Minerva",
    explanation:
        "Minerva est la déesse de la sagesse, équivalente à Athéna dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel titan est connu pour avoir avalé ses enfants ?",
    options: ["Cronos", "Ouranos", "Atlas"],
    answer: "Cronos",
    explanation:
        "Cronos a avalé ses enfants par crainte qu'ils ne le détrônent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le héros qui a vaincu la Méduse ?",
    options: ["Persée", "Achille", "Hercule"],
    answer: "Persée",
    explanation:
        "Persée a vaincu la Méduse en utilisant un miroir pour éviter son regard pétrifiant.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du dieu du commerce et des voleurs dans la mythologie grecque ?",
    options: ["Hermès", "Zeus", "Apollon"],
    answer: "Hermès",
    explanation:
        "Hermès est le dieu du commerce, des voleurs et le messager des dieux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la frontière entre les vivants et les morts ?",
    options: ["Hécate", "Artemis", "Aphrodite"],
    answer: "Hécate",
    explanation:
        "Hécate est la déesse de la magie et de la sorcellerie, souvent associée aux passages entre les mondes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Comment s'appelle le fils de Poséidon et de la déesse des nymphes ?",
    options: ["Triton", "Nérée", "Éole"],
    answer: "Triton",
    explanation:
        "Triton est le fils de Poséidon et est souvent représenté comme un homme-poisson.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la femme d'Hercule ?",
    options: ["Mégara", "Diane", "Héra"],
    answer: "Mégara",
    explanation: "Mégara est connue comme la première épouse d'Hercule.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a fondé Rome selon la légende ?",
    options: ["Romulus", "Rémus", "Aeneas"],
    answer: "Romulus",
    explanation:
        "Romulus est le fondateur légendaire de Rome, ayant tué son frère Rémus.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est le dieu des arts et de la lumière dans la mythologie grecque ?",
    options: ["Apollon", "Hermès", "Dionysos"],
    answer: "Apollon",
    explanation:
        "Apollon est le dieu des arts, de la musique et de la divination.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la récolte dans la mythologie grecque ?",
    options: ["Déméter", "Gaïa", "Héra"],
    answer: "Déméter",
    explanation:
        "Déméter est la déesse de la récolte et de l'agriculture dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu est souvent représenté avec un trident ?",
    options: ["Poséidon", "Zeus", "Hades"],
    answer: "Poséidon",
    explanation:
        "Poséidon est souvent représenté avec un trident, symbole de sa domination sur les mers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du roi des enfers dans la mythologie grecque ?",
    options: ["Hadès", "Hermès", "Chronos"],
    answer: "Hadès",
    explanation:
        "Hadès est le roi des enfers et frère de Zeus dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est la déesse de l'amour et de la beauté dans la mythologie romaine ?",
    options: ["Vénus", "Minerva", "Flore"],
    answer: "Vénus",
    explanation:
        "Vénus est la déesse de l'amour et de la beauté dans la mythologie romaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle déesse est souvent associée aux moissons et aux labours ?",
    options: ["Déméter", "Athéna", "Artémis"],
    answer: "Déméter",
    explanation:
        "Déméter est la déesse des moissons et de l'agriculture dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui a été condamné à éternellement boire de l'eau d'une source sans jamais s'étancher ?",
    options: ["Tantalus", "Sisyphe", "Prométhée"],
    answer: "Tantalus",
    explanation:
        "Tantalus a été puni en étant placé près d'une source qu'il ne pouvait jamais atteindre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le héros qui a combattu les Trojans ?",
    options: ["Achille", "Hercule", "Ulysse"],
    answer: "Achille",
    explanation:
        "Achille est le héros grec le plus célèbre de la guerre de Troie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle déesse est souvent associée à la guerre et à la protection ?",
    options: ["Athéna", "Artémis", "Héra"],
    answer: "Athéna",
    explanation:
        "Athéna est la déesse de la guerre stratégique et de la sagesse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle est la créature mythologique avec le corps d'un lion et une tête d'aigle ?",
    options: ["Griffon", "Sphinx", "Chimère"],
    answer: "Griffon",
    explanation:
        "Le griffon est une créature mythologique avec le corps d'un lion et la tête d'un aigle.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle déesse est associée à la guerre dans la mythologie romaine ?",
    options: ["Vénus", "Minerve", "Diane"],
    answer: "Minerve",
    explanation: "Minerve est la déesse romaine de la guerre et de la sagesse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom de l'océan dans la mythologie grecque ?",
    options: ["Océanus", "Néptune", "Acheron"],
    answer: "Océanus",
    explanation:
        "Océanus est le titan représentant l'océan dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Comment s'appelle le dieu des enfers dans la mythologie grecque ?",
    options: ["Hadès", "Hermès", "Arès"],
    answer: "Hadès",
    explanation: "Hadès est le dieu des enfers dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros grec a accompli les douze travaux ?",
    options: ["Thésée", "Héraclès", "Achille"],
    answer: "Héraclès",
    explanation:
        "Héraclès est célèbre pour avoir réalisé les douze travaux imposés par Eurysthée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel animal est associé à Poséidon ?",
    options: ["Le cheval", "Le serpent", "Le lion"],
    answer: "Le cheval",
    explanation: "Poséidon est souvent associé au cheval, qu'il aurait créé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le symbole de la déesse de la sagesse ?",
    options: ["Le hibou", "Le serpent", "La couronne"],
    answer: "Le hibou",
    explanation:
        "Le hibou est le symbole de la sagesse, associé à la déesse Athéna.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse du foyer dans la mythologie romaine ?",
    options: ["Vesta", "Cérès", "Proserpine"],
    answer: "Vesta",
    explanation: "Vesta est la déesse romaine du foyer et de la maison.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Avec quel animal était Aphrodite souvent associée ?",
    options: ["La colombe", "Le paon", "Le cheval"],
    answer: "La colombe",
    explanation:
        "La colombe est un symbole de paix et d'amour associé à Aphrodite.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros est célèbre pour avoir tué le Minotaure ?",
    options: ["Thésée", "Persée", "Héraclès"],
    answer: "Thésée",
    explanation:
        "Thésée est le héros qui a tué le Minotaure dans le labyrinthe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du fils de Zeus et d'Alcmène ?",
    options: ["Héraclès", "Apollon", "Arès"],
    answer: "Héraclès",
    explanation: "Héraclès est le fils illégitime de Zeus et d'Alcmène.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le rôle de Charon dans la mythologie grecque ?",
    options: ["Ferry des âmes", "Gardien des enfers", "Dieu de la mort"],
    answer: "Ferry des âmes",
    explanation: "Charon est le passeur des âmes qui traversent le Styx.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "De quel mont est l'Olympe le nom dans la mythologie grecque ?",
    options: [
      "Montagne des dieux",
      "Montagne sacrée",
      "Montagne de la sagesse",
    ],
    answer: "Montagne des dieux",
    explanation: "L'Olympe est considéré comme la résidence des dieux grecs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du dieu du vent dans la mythologie grecque ?",
    options: ["Éole", "Zéphyr", "Borée"],
    answer: "Éole",
    explanation: "Éole est le dieu des vents dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a volé le feu aux dieux pour le donner aux hommes ?",
    options: ["Prométhée", "Héraclès", "Achille"],
    answer: "Prométhée",
    explanation: "Prométhée est connu pour avoir volé le feu aux dieux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle divinité est connue pour sa beauté et son charme irrésistible ?",
    options: ["Aphrodite", "Héra", "Artémis"],
    answer: "Aphrodite",
    explanation: "Aphrodite est la déesse de l'amour et de la beauté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui a été puni de vivre avec un rocher qu'il doit pousser en haut d'une montagne ?",
    options: ["Sisyphus", "Prométhée", "Tantalus"],
    answer: "Sisyphus",
    explanation:
        "Sisyphus est condamné à pousser un rocher sans jamais l'atteindre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse représente la terre nourricière ?",
    options: ["Gaïa", "Déméter", "Cérès"],
    answer: "Gaïa",
    explanation: "Gaïa est la déesse de la Terre dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a combattu les géants dans la mythologie grecque ?",
    options: ["Zeus", "Héraclès", "Thésée"],
    answer: "Zeus",
    explanation:
        "Zeus est connu pour avoir combattu les géants et rétabli l'ordre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle créature mythologique a des serpents à la place des cheveux ?",
    options: ["Méduse", "Chimère", "Sphinx"],
    answer: "Méduse",
    explanation: "Méduse est une Gorgone avec des serpents comme cheveux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la moisson dans la mythologie romaine ?",
    options: ["Cérès", "Déméter", "Flore"],
    answer: "Cérès",
    explanation:
        "Cérès est la déesse romaine de l'agriculture et de la moisson.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a combattu pour la ville de Troie ?",
    options: ["Achille", "Ulysse", "Héraclès"],
    answer: "Achille",
    explanation:
        "Achille est le héros grec célèbre pour son rôle dans la guerre de Troie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la fertilité dans la mythologie grecque ?",
    options: ["Déméter", "Héra", "Perséphone"],
    answer: "Déméter",
    explanation: "Déméter est la déesse de l'agriculture et de la fertilité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle créature mythologique a un corps de lion et une tête d'homme ?",
    options: ["Sphinx", "Chimère", "Minotaure"],
    answer: "Sphinx",
    explanation:
        "Le Sphinx est une créature mythologique avec un corps de lion et une tête d'homme.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du dieu de la médecine dans la mythologie grecque ?",
    options: ["Asclépios", "Apollon", "Hermès"],
    answer: "Asclépios",
    explanation: "Asclépios est le dieu de la médecine et de la guérison.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui a conduit les Argonautes dans leur quête de la Toison d'or ?",
    options: ["Jason", "Thésée", "Achille"],
    answer: "Jason",
    explanation:
        "Jason est le chef des Argonautes dans leur quête de la Toison d'or.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la beauté dans la mythologie romaine ?",
    options: ["Vénus", "Minerve", "Diane"],
    answer: "Vénus",
    explanation: "Vénus est la déesse romaine de l'amour et de la beauté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom de l'épouse de Zeus ?",
    options: ["Héra", "Athéna", "Déméter"],
    answer: "Héra",
    explanation: "Héra est l'épouse de Zeus et la déesse du mariage.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la vengeance dans la mythologie grecque ?",
    options: ["Némésis", "Erinyes", "Athéna"],
    answer: "Némésis",
    explanation: "Némésis est la déesse de la vengeance et de la rétribution.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du demi-dieu grec connu pour sa force surhumaine ?",
    options: ["Achille", "Héraclès", "Thésée"],
    answer: "Héraclès",
    explanation:
        "Héraclès est un demi-dieu réputé pour sa force exceptionnelle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel titan a défié les dieux en offrant le feu aux humains ?",
    options: ["Prométhée", "Cronos", "Atlas"],
    answer: "Prométhée",
    explanation: "Prométhée a défié les dieux en offrant le feu aux hommes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel dieu a été trahi par sa propre fille qui a donné la mort en s'aimant ?",
    options: ["Zeus", "Hadès", "Poséidon"],
    answer: "Hadès",
    explanation:
        "Hadès a été trahi par sa propre fille, Perséphone, qui a choisi d'aimer un mortel.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a volé la Toison d'or ?",
    options: ["Jason", "Thésée", "Achille"],
    answer: "Jason",
    explanation: "Jason est le héros qui a volé la Toison d'or.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du serpent que Héraclès a tué à l'âge de 12 ans ?",
    options: ["L'Hydre", "Le Python", "Le Kraken"],
    answer: "Le Python",
    explanation: "Héraclès a tué le Python à l'âge de 12 ans.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros est connu pour sa ruse et son intelligence ?",
    options: ["Ulysse", "Achille", "Héraclès"],
    answer: "Ulysse",
    explanation:
        "Ulysse est connu pour sa ruse et son intelligence, surtout dans le cadre de la guerre de Troie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu est symbolisé par le caducée ?",
    options: ["Hermès", "Apollon", "Arès"],
    answer: "Hermès",
    explanation:
        "Hermès est symbolisé par le caducée, un bâton entouré de serpents.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse a été enlevée par Hadès ?",
    options: ["Perséphone", "Artémis", "Athéna"],
    answer: "Perséphone",
    explanation:
        "Perséphone a été enlevée par Hadès pour devenir la reine des enfers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse qui a donné naissance à Minotaure ?",
    options: ["Pasiphaé", "Ariane", "Héra"],
    answer: "Pasiphaé",
    explanation:
        "Pasiphaé est la mère du Minotaure, née d'une union contre nature.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle créature mythologique est souvent décrite comme ayant plusieurs têtes ?",
    options: ["Hydre", "Chimère", "Sphinx"],
    answer: "Hydre",
    explanation: "L'Hydre est une créature mythologique avec plusieurs têtes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de l'amour et de la beauté dans la mythologie grecque ?",
    options: ["Aphrodite", "Héra", "Artémis"],
    answer: "Aphrodite",
    explanation:
        "Aphrodite est la déesse de l'amour et de la beauté dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a été condamné à être dévoré par des vautours ?",
    options: ["Prométhée", "Tantalus", "Sisyphus"],
    answer: "Prométhée",
    explanation:
        "Prométhée a été puni en étant dévoré par des vautours pour avoir volé le feu.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse des vents dans la mythologie grecque ?",
    options: ["Éole", "Zéphyr", "Borée"],
    answer: "Éole",
    explanation: "Éole est le maître des vents dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse est célébrée pendant les fêtes de Dionysos ?",
    options: ["Déméter", "Artemis", "Aphrodite"],
    answer: "Déméter",
    explanation:
        "Déméter est la déesse de l'agriculture célébrée lors des fêtes de Dionysos.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros est connu pour sa beauté et son habileté à jouer de la lyre ?",
    options: ["Apollon", "Orphée", "Achille"],
    answer: "Orphée",
    explanation: "Orphée est célèbre pour sa beauté et son talent musical.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du roi des dieux dans la mythologie romaine ?",
    options: ["Jupiter", "Mars", "Saturne"],
    answer: "Jupiter",
    explanation: "Jupiter est le roi des dieux dans la mythologie romaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a combattu la Gorgone Méduse ?",
    options: ["Persée", "Achille", "Héraclès"],
    answer: "Persée",
    explanation: "Persée est le héros qui a décapité la Gorgone Méduse.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse romaine est associée à la sagesse ?",
    options: ["Déméter", "Athena", "Vénus"],
    answer: "Athena",
    explanation:
        "Athena est la déesse de la sagesse dans la mythologie romaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu du vent dans la mythologie grecque ?",
    options: ["Éole", "Gaïa", "Hermès"],
    answer: "Éole",
    explanation: "Éole est le dieu des vents dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Dans la mythologie égyptienne, qui est le dieu du soleil ?",
    options: ["Rê", "Osiris", "Anubis"],
    answer: "Rê",
    explanation: "Rê est le dieu du soleil dans la mythologie égyptienne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle est la déesse de l'amour en Grèce antique ?",
    options: ["Héra", "Vénus", "Aphrodite"],
    answer: "Aphrodite",
    explanation:
        "Aphrodite est la déesse de l'amour et de la beauté dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du serpent géant dans la mythologie nordique ?",
    options: ["Nidhogg", "Fafnir", "Jörmungand"],
    answer: "Jörmungand",
    explanation:
        "Jörmungand est le serpent de Midgard dans la mythologie nordique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la chasse dans la mythologie romaine ?",
    options: ["Diane", "Artémis", "Cérès"],
    answer: "Diane",
    explanation: "Diane est la déesse de la chasse dans la mythologie romaine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu grec est associé au commerce et aux voleurs ?",
    options: ["Hermès", "Héphaïstos", "Ares"],
    answer: "Hermès",
    explanation:
        "Hermès est le dieu du commerce et des voleurs dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est souvent représenté avec des ailes aux pieds dans la mythologie grecque ?",
    options: ["Hermès", "Eros", "Zephyr"],
    answer: "Hermès",
    explanation: "Hermès est souvent représenté avec des ailes aux pieds.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel titan est condamné à porter le ciel sur ses épaules ?",
    options: ["Cronos", "Atlas", "Prométhée"],
    answer: "Atlas",
    explanation:
        "Atlas est condamné à porter le ciel dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle est la déesse des moissons dans la mythologie grecque ?",
    options: ["Demeter", "Artémis", "Athena"],
    answer: "Demeter",
    explanation: "Déméter est la déesse des moissons et de l'agriculture.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a volé le feu aux dieux pour le donner aux hommes ?",
    options: ["Héraclès", "Prométhée", "Zeus"],
    answer: "Prométhée",
    explanation: "Prométhée a volé le feu aux dieux pour l'offrir aux humains.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros est connu pour avoir vaincu Méduse ?",
    options: ["Thésée", "Achille", "Persée"],
    answer: "Persée",
    explanation: "Persée est le héros qui a vaincu Méduse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu de la guerre est souvent représenté avec une armure ?",
    options: ["Ares", "Poséidon", "Héphaïstos"],
    answer: "Ares",
    explanation: "Ares est le dieu de la guerre dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu des enfers dans la mythologie grecque ?",
    options: ["Hadès", "Hercule", "Éros"],
    answer: "Hadès",
    explanation: "Hadès est le dieu des enfers dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la chasse dans la mythologie grecque ?",
    options: ["Artemis", "Déméter", "Aphrodite"],
    answer: "Artemis",
    explanation:
        "Artémis est la déesse de la chasse dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du héros troyen connu pour sa force ?",
    options: ["Hector", "Achille", "Agamemnon"],
    answer: "Achille",
    explanation:
        "Achille est reconnu pour sa force et sa bravoure pendant la guerre de Troie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Dans la mythologie nordique, qui est le dieu de la lumière ?",
    options: ["Baldur", "Thor", "Loki"],
    answer: "Baldur",
    explanation:
        "Baldur est le dieu de la lumière et de la pureté dans la mythologie nordique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du dieu de la mer dans la mythologie romaine ?",
    options: ["Poséidon", "Néréus", "Neptune"],
    answer: "Neptune",
    explanation: "Neptune est le dieu de la mer dans la mythologie romaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la terre dans la mythologie grecque ?",
    options: ["Gaïa", "Héra", "Athena"],
    answer: "Gaïa",
    explanation: "Gaïa est la déesse de la terre dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros est connu pour avoir traversé la mer en utilisant un cheval ailé ?",
    options: ["Bellerophon", "Achille", "Thésée"],
    answer: "Bellerophon",
    explanation:
        "Bellerophon est connu pour avoir chevauché Pégase, le cheval ailé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du dieu des forges dans la mythologie grecque ?",
    options: ["Héphaïstos", "Hermès", "Zeus"],
    answer: "Héphaïstos",
    explanation: "Héphaïstos est le dieu des forges et des artisans.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la victoire dans la mythologie grecque ?",
    options: ["Niké", "Héra", "Athena"],
    answer: "Niké",
    explanation:
        "Niké est la déesse de la victoire dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est souvent représenté comme un demi-dieu dans la mythologie grecque ?",
    options: ["Hercule", "Achille", "Thésée"],
    answer: "Hercule",
    explanation: "Hercule est un demi-dieu célèbre pour sa force surhumaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du dieu de la joie dans la mythologie romaine ?",
    options: ["Bacchus", "Mars", "Jupiter"],
    answer: "Bacchus",
    explanation:
        "Bacchus est le dieu de la joie et du vin dans la mythologie romaine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros est le fils de Zeus et célèbre pour sa force ?",
    options: ["Héraclès", "Achille", "Jason"],
    answer: "Héraclès",
    explanation:
        "Héraclès est le fils de Zeus et est connu pour sa force légendaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la nuit dans la mythologie grecque ?",
    options: ["Nyx", "Hécate", "Perséphone"],
    answer: "Nyx",
    explanation: "Nyx est la déesse de la nuit dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du héros qui a été trahi par sa femme et a tué son fils dans la mythologie grecque ?",
    options: ["Oreste", "Oedipe", "Achille"],
    answer: "Oedipe",
    explanation:
        "Oedipe a tué son père et a épousé sa mère, entraînant sa propre tragédie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du demi-dieu qui a mené les Argonautes ?",
    options: ["Jason", "Thésée", "Héraclès"],
    answer: "Jason",
    explanation:
        "Jason a mené les Argonautes dans leur quête pour la Toison d'or.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu de la mort dans la mythologie grecque ?",
    options: ["Thanatos", "Hadès", "Hercule"],
    answer: "Thanatos",
    explanation:
        "Thanatos est généralement considéré comme le dieu de la mort dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui a été puni de porter des pierres pour l'éternité dans la mythologie grecque ?",
    options: ["Sisyphe", "Ixion", "Tantalus"],
    answer: "Sisyphe",
    explanation: "Sisyphe est condamné à pousser un rocher éternellement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Dans la mythologie égyptienne, qui est le dieu des morts ?",
    options: ["Osiris", "Anubis", "Horus"],
    answer: "Osiris",
    explanation:
        "Osiris est considéré comme le dieu des morts et de l'au-delà.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel personnage mythologique est connu pour sa beauté et sa fureur ?",
    options: ["Hélène", "Héra", "Vénus"],
    answer: "Hélène",
    explanation:
        "Hélène de Troie est célèbre pour sa beauté, qui a provoqué la guerre de Troie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu de la tromperie dans la mythologie nordique ?",
    options: ["Loki", "Thor", "Odin"],
    answer: "Loki",
    explanation:
        "Loki est le dieu de la tromperie et de la malice dans la mythologie nordique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du géant qui a défié les dieux dans la mythologie nordique ?",
    options: ["Jotunn", "Thor", "Ymir"],
    answer: "Ymir",
    explanation: "Ymir est un géant primordial dans la mythologie nordique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a vaincu le Minotaure dans le labyrinthe ?",
    options: ["Thésée", "Achille", "Persée"],
    answer: "Thésée",
    explanation: "Thésée a vaincu le Minotaure dans le labyrinthe de Crète.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le messager des dieux dans la mythologie romaine ?",
    options: ["Hermès", "Mercure", "Apollon"],
    answer: "Mercure",
    explanation:
        "Mercure est le messager des dieux dans la mythologie romaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du dieu du vin dans la mythologie grecque ?",
    options: ["Dionysos", "Apollon", "Hermès"],
    answer: "Dionysos",
    explanation:
        "Dionysos est le dieu du vin et de la fête dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la sagesse dans la mythologie romaine ?",
    options: ["Athena", "Minerve", "Vénus"],
    answer: "Minerve",
    explanation:
        "Minerve est la déesse de la sagesse et de la stratégie dans la mythologie romaine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a donné naissance à des jumeaux, Romulus et Remus ?",
    options: ["Vénus", "Rhea Silvia", "Héra"],
    answer: "Rhea Silvia",
    explanation:
        "Rhea Silvia est la mère de Romulus et Remus dans la mythologie romaine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel personnage est connu pour sa quête de l'immortalité dans la mythologie grecque ?",
    options: ["Gilgamesh", "Héraclès", "Achille"],
    answer: "Gilgamesh",
    explanation:
        "Gilgamesh est connu pour sa quête de l'immortalité dans l'épopée de Gilgamesh.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Dans la mythologie grecque, quel est le nom du fleuve des morts ?",
    options: ["Styx", "Nile", "Danube"],
    answer: "Styx",
    explanation:
        "Styx est le fleuve qui sépare le monde des vivants de celui des morts.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du dieu du ciel dans la mythologie romaine ?",
    options: ["Uranus", "Jupiter", "Mars"],
    answer: "Jupiter",
    explanation:
        "Jupiter est le dieu du ciel et le roi des dieux dans la mythologie romaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom de la femme de Zeus, la déesse du mariage ?",
    options: ["Aphrodite", "Héra", "Déméter"],
    answer: "Héra",
    explanation: "Héra est la déesse du mariage et l'épouse de Zeus.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel titan est associé à la création de l'humanité dans la mythologie grecque ?",
    options: ["Prométhée", "Cronos", "Atlas"],
    answer: "Prométhée",
    explanation:
        "Prométhée est le titan qui a créé l'humanité et a volé le feu.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros est connu pour avoir sauvé sa mère des enfers ?",
    options: ["Orphée", "Hercule", "Thésée"],
    answer: "Orphée",
    explanation: "Orphée a tenté de sauver sa femme Eurydice des enfers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse du printemps dans la mythologie grecque ?",
    options: ["Perséphone", "Déméter", "Aphrodite"],
    answer: "Perséphone",
    explanation: "Perséphone est la déesse du printemps et des plantes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de l'ennemi juré d'Achille dans la guerre de Troie ?",
    options: ["Hector", "Agamemnon", "Paris"],
    answer: "Hector",
    explanation: "Hector est l'ennemi juré d'Achille dans la guerre de Troie.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Dans la mythologie romaine, qui est la déesse de l'amour ?",
    options: ["Vénus", "Minerve", "Junon"],
    answer: "Vénus",
    explanation:
        "Vénus est la déesse de l'amour et de la beauté dans la mythologie romaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros grec a accompli douze travaux imposés par Eurysthée ?",
    options: ["Héraclès", "Thésée", "Achille"],
    answer: "Héraclès",
    explanation:
        "Héraclès est connu pour ses douze travaux, un exploit héroïque de la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la sagesse dans la mythologie grecque ?",
    options: ["Athena", "Artémis", "Déméter"],
    answer: "Athena",
    explanation:
        "Athena est la déesse de la sagesse et de la stratégie guerrière dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Dans la mythologie nordique, qui est le dieu du tonnerre ?",
    options: ["Odin", "Thor", "Loki"],
    answer: "Thor",
    explanation:
        "Thor est le dieu du tonnerre, connu pour sa force et son marteau, Mjolnir.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel animal est souvent associé à la déesse égyptienne Isis ?",
    options: ["Le hibou", "Le serpent", "Le scorpion"],
    answer: "Le hibou",
    explanation:
        "Le hibou est souvent associé à la sagesse et à la protection, des attributs d'Isis.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de l'épouse d'Osiris dans la mythologie égyptienne ?",
    options: ["Isis", "Hathor", "Sekhmet"],
    answer: "Isis",
    explanation:
        "Isis est l'épouse d'Osiris et la déesse de la maternité et de la magie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est l'auteur de l'Iliade et de l'Odyssée ?",
    options: ["Hésiode", "Homère", "Socrate"],
    answer: "Homère",
    explanation:
        "Homère est l'auteur de ces deux célèbres épopées de la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a tué le Minotaure dans le labyrinthe ?",
    options: ["Thésée", "Persée", "Achille"],
    answer: "Thésée",
    explanation:
        "Thésée est connu pour avoir tué le Minotaure à l'aide d'un fil d'Ariane.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est le dieu de l'art de la médecine dans la mythologie grecque ?",
    options: ["Asclépios", "Hermès", "Apollon"],
    answer: "Asclépios",
    explanation: "Asclépios est le dieu grec de la médecine et de la guérison.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom de la déesse grecque de la chasse ?",
    options: ["Artémis", "Aphrodite", "Héra"],
    answer: "Artémis",
    explanation:
        "Artémis est la déesse de la chasse, de la nature et des animaux dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Dans la mythologie romaine, qui est le dieu des enfers ?",
    options: ["Pluton", "Mars", "Jupiter"],
    answer: "Pluton",
    explanation:
        "Pluton est le dieu des enfers et des richesses dans la mythologie romaine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel personnage mythologique est connu pour avoir été transformé en cygne ?",
    options: ["Leda", "Phaéton", "Icare"],
    answer: "Leda",
    explanation: "Leda a été transformée en cygne par Zeus dans la mythologie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu du vin dans la mythologie grecque ?",
    options: ["Dionysos", "Apollon", "Hermès"],
    answer: "Dionysos",
    explanation:
        "Dionysos est le dieu du vin, de la fête et de l'extase dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel monstre de la mythologie grecque avait des serpents à la place des cheveux ?",
    options: ["Méduse", "Chimère", "Sphinx"],
    answer: "Méduse",
    explanation:
        "Méduse est l'une des Gorgones, connue pour ses cheveux de serpents.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du géant de la mythologie grecque qui portait le ciel sur ses épaules ?",
    options: ["Atlas", "Cronos", "Hyperion"],
    answer: "Atlas",
    explanation:
        "Atlas est le géant qui est condamné à porter le ciel sur ses épaules dans la mythologie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle déesse est connue pour sa beauté et son élégance parmi les Grecs ?",
    options: ["Aphrodite", "Artémis", "Athena"],
    answer: "Aphrodite",
    explanation:
        "Aphrodite est la déesse de l'amour et de la beauté dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros grec a combattu contre les Troyens pour récupérer Hélène ?",
    options: ["Achille", "Héraclès", "Ulysse"],
    answer: "Achille",
    explanation:
        "Achille est connu pour son rôle central dans la guerre de Troie, notamment dans le contexte de Hélène.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est le dieu du commerce et des voleurs dans la mythologie grecque ?",
    options: ["Hermès", "Dionysos", "Apollon"],
    answer: "Hermès",
    explanation:
        "Hermès est le dieu du commerce, des voleurs et le messager des dieux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Dans la mythologie romaine, qui est la déesse de la chasse ?",
    options: ["Diana", "Juno", "Vénus"],
    answer: "Diana",
    explanation:
        "Diana est la déesse de la chasse et de la nature dans la mythologie romaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui a volé le feu aux dieux pour le donner aux hommes dans la mythologie grecque ?",
    options: ["Prométhée", "Epiméthée", "Atlas"],
    answer: "Prométhée",
    explanation:
        "Prométhée est le titan qui a volé le feu aux dieux pour en faire don à l'humanité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du roi de la mer dans la mythologie grecque ?",
    options: ["Poséidon", "Héraclès", "Zeus"],
    answer: "Poséidon",
    explanation:
        "Poséidon est le dieu des mers et des océans dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel animal est sacred à Apollon dans la mythologie grecque ?",
    options: ["Le corbeau", "Le loup", "Le serpent"],
    answer: "Le serpent",
    explanation:
        "Le serpent est considéré comme un animal sacré d'Apollon, représentant la sagesse.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle créature mythologique est souvent décrite comme ayant un corps de lion et une tête d'homme ?",
    options: ["Sphinx", "Chimère", "Griffon"],
    answer: "Sphinx",
    explanation:
        "Le Sphinx est une créature mythologique connue pour son énigme et sa tête humaine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est le roi de la lumière et de la musique dans la mythologie grecque ?",
    options: ["Apollon", "Dionysos", "Hades"],
    answer: "Apollon",
    explanation:
        "Apollon est le dieu de la lumière, de la musique et des arts dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du fleuve des Enfers dans la mythologie ?",
    options: ["Styx", "Acheron", "Lathos"],
    answer: "Styx",
    explanation:
        "Le Styx est le fleuve qui sépare le monde des vivants de celui des morts.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui sont les Muses dans la mythologie grecque ?",
    options: [
      "Les déesses des arts",
      "Les déesses de la guerre",
      "Les déesses de la beauté",
    ],
    answer: "Les déesses des arts",
    explanation:
        "Les Muses sont les déesses inspiratrices des arts et des sciences.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros a été élevé par une ourse dans la mythologie grecque ?",
    options: ["Romulus", "Thésée", "Héraclès"],
    answer: "Romulus",
    explanation:
        "Romulus, le fondateur de Rome, a été élevé par une ourse selon la légende.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu de la mort dans la mythologie grecque ?",
    options: ["Hadès", "Chronos", "Eros"],
    answer: "Hadès",
    explanation:
        "Hadès est le dieu des morts et des Enfers dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse du foyer dans la mythologie gréco-romaine ?",
    options: ["Hestia", "Demeter", "Vesta"],
    answer: "Hestia",
    explanation:
        "Hestia est la déesse du foyer et de la famille dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle créature mythologique est connue pour avoir le corps d'un homme et la queue d'un poisson ?",
    options: ["Sirène", "Nymphe", "Mermidon"],
    answer: "Sirène",
    explanation:
        "Les Sirènes sont des créatures mythologiques avec un corps de femme et une queue de poisson.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a fabriqué la célèbre boîte de Pandore ?",
    options: ["Héphaïstos", "Zeus", "Hermès"],
    answer: "Héphaïstos",
    explanation:
        "Héphaïstos a créé la boîte de Pandore, contenant tous les maux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du fils de Zeus et de Léto ?",
    options: ["Apollon", "Héraclès", "Hermès"],
    answer: "Apollon",
    explanation:
        "Apollon est le fils de Zeus et de Léto, dieu de la musique et des arts.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a reçu un cheval ailé après avoir tué un monstre ?",
    options: ["Bellerophon", "Thésée", "Héraclès"],
    answer: "Bellerophon",
    explanation:
        "Bellerophon a reçu Pégase, le cheval ailé, après avoir tué la Chimère.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le forgeron des dieux dans la mythologie grecque ?",
    options: ["Héphaïstos", "Apollon", "Hermès"],
    answer: "Héphaïstos",
    explanation: "Héphaïstos est le dieu du feu et le forgeron des dieux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel titan a été condamné à rouler une pierre en haut d'une colline éternellement ?",
    options: ["Sisyphe", "Prométhée", "Atlas"],
    answer: "Sisyphe",
    explanation:
        "Sisyphe a été puni de rouler une pierre éternellement en haut d'une colline.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel personnage mythologique est connu pour avoir fait le tour du monde en 80 jours ?",
    options: ["Phileas Fogg", "Ulysse", "Héraclès"],
    answer: "Ulysse",
    explanation:
        "Ulysse, à travers ses voyages, a fait le tour du monde dans la mythologie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a écrit l'Enéide, une œuvre sur la fondation de Rome ?",
    options: ["Virgile", "Ovide", "Horace"],
    answer: "Virgile",
    explanation:
        "Virgile est l'auteur de l'Enéide, racontant les aventures d'Énée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la moisson dans la mythologie gréco-romaine ?",
    options: ["Déméter", "Cérès", "Gaïa"],
    answer: "Déméter",
    explanation:
        "Déméter est la déesse de la moisson et des récoltes dans la mythologie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la créature mi-homme mi-cheval dans la mythologie ?",
    options: ["Centaure", "Minotaure", "Satyr"],
    answer: "Centaure",
    explanation:
        "Les Centaures sont des créatures mythologiques à moitié hommes, à moitié chevaux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est le protecteur des voyageurs dans la mythologie grecque ?",
    options: ["Hermès", "Apollon", "Artémis"],
    answer: "Hermès",
    explanation: "Hermès est le dieu des voyageurs et messager des dieux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la discorde dans la mythologie greco-romaine ?",
    options: ["Eris", "Athena", "Héra"],
    answer: "Eris",
    explanation: "Eris est la déesse de la discorde et du chaos.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du voyageur mythologique qui a découvert la mer Rouge ?",
    options: ["Odyssée", "Ulysse", "Énée"],
    answer: "Ulysse",
    explanation:
        "Ulysse est le héros de l'Odyssée, qui a réalisé de nombreux voyages.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le fils de Zeus et Hera dans la mythologie grecque ?",
    options: ["Héphaïstos", "Arès", "Hermès"],
    answer: "Arès",
    explanation: "Arès est le dieu de la guerre, fils de Zeus et d'Héra.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le symbole associé à la déesse de la sagesse ?",
    options: ["La chouette", "Le serpent", "Le lion"],
    answer: "La chouette",
    explanation:
        "La chouette est le symbole associé à la déesse Athena dans la mythologie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du dieu du feu et de la forge dans la mythologie romaine ?",
    options: ["Vulcain", "Mars", "Jupiter"],
    answer: "Vulcain",
    explanation:
        "Vulcain est le dieu du feu et de la forge dans la mythologie romaine.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui était le roi des dieux dans la mythologie grecque ?",
    options: ["Zeus", "Poséidon", "Hadès"],
    answer: "Zeus",
    explanation:
        "Zeus est considéré comme le roi des dieux et le dieu du ciel dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle déesse était connue pour sa sagesse et son intelligence ?",
    options: ["Athena", "Héra", "Artémis"],
    answer: "Athena",
    explanation:
        "Athena est la déesse de la sagesse, de la guerre et des arts dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui était le messager des dieux dans la mythologie romaine ?",
    options: ["Hermès", "Mercure", "Apollon"],
    answer: "Mercure",
    explanation:
        "Mercure est le messager des dieux et est associé au commerce et aux voyageurs dans la mythologie romaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros grec a accompli les douze travaux ?",
    options: ["Thésée", "Hercule", "Achille"],
    answer: "Hercule",
    explanation:
        "Hercule est célèbre pour avoir accompli les douze travaux en tant que pénitence imposée par les dieux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de l'épée d'Arthur dans la légende arthurienne ?",
    options: ["Durandal", "Excalibur", "Caliburn"],
    answer: "Excalibur",
    explanation:
        "Excalibur est l'épée mythique du roi Arthur, symbolisant son droit à régner.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui était le dieu de la mort chez les Égyptiens ?",
    options: ["Anubis", "Râ", "Osiris"],
    answer: "Anubis",
    explanation:
        "Anubis est le dieu égyptien des morts, souvent représenté avec une tête de chacal.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle créature était connue pour séduire les marins dans la mythologie ?",
    options: ["Sirenes", "Mérmaids", "Nymphes"],
    answer: "Sirenes",
    explanation:
        "Les sirènes sont des créatures mythologiques qui attirent les marins par leur chant envoûtant.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui était le dieu du vin dans la mythologie grecque ?",
    options: ["Dionysos", "Appolon", "Hadès"],
    answer: "Dionysos",
    explanation:
        "Dionysos est le dieu du vin, de la fête et de l'extase dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du serpent géant dans la mythologie nordique ?",
    options: ["Jörmungandr", "Fenrir", "Nidhogg"],
    answer: "Jörmungandr",
    explanation:
        "Jörmungandr, également connu sous le nom de Serpent de Midgard, est un serpent géant dans la mythologie nordique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse romaine est associée à la chasse ?",
    options: ["Artémis", "Diana", "Vénus"],
    answer: "Diana",
    explanation:
        "Diana est la déesse de la chasse et de la nature dans la mythologie romaine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a créé les premiers hommes selon la mythologie grecque ?",
    options: ["Prométhée", "Zeus", "Héphaïstos"],
    answer: "Prométhée",
    explanation:
        "Prométhée est connu pour avoir façonné les premiers hommes à partir de l'argile.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu de la médecine dans la mythologie grecque ?",
    options: ["Esculape", "Hermès", "Apollon"],
    answer: "Esculape",
    explanation:
        "Esculape est le dieu de la médecine et de la guérison dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Comment s'appelle le dieu égyptien de la sagesse ?",
    options: ["Thot", "Osiris", "Horus"],
    answer: "Thot",
    explanation:
        "Thot est le dieu égyptien de la sagesse, de l'écriture et de la magie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel roi de Thèbes a eu une fin tragique en raison d'une prophétie ?",
    options: ["Laios", "Oedipe", "Créon"],
    answer: "Oedipe",
    explanation:
        "Oedipe, roi de Thèbes, a tragiquement accompli une prophétie qui prédisait qu'il tuerait son père et épouserait sa mère.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle était la mère de Zeus ?",
    options: ["Gaïa", "Rhea", "Héra"],
    answer: "Rhea",
    explanation:
        "Rhea est la mère de Zeus, l'un des titans dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle est la déesse du foyer dans la mythologie romaine ?",
    options: ["Vesta", "Cérès", "Junon"],
    answer: "Vesta",
    explanation:
        "Vesta est la déesse romaine du foyer et de la famille, représentée par le feu sacré.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui était le dieu du tonnerre dans la mythologie nordique ?",
    options: ["Thor", "Loki", "Odin"],
    answer: "Thor",
    explanation:
        "Thor est le dieu du tonnerre, des tempêtes et des combats dans la mythologie nordique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel personnage mythologique a été transformé en mouche par les dieux ?",
    options: ["Pygmalion", "Narcisse", "Daphné"],
    answer: "Daphné",
    explanation:
        "Daphné a été transformée en laurier pour échapper à l'amour d'Apollon, en se transformant en une plante.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle créature mythologique a des ailes et peut être vue comme un symbole de paix ?",
    options: ["Colombe", "Phénix", "Grue"],
    answer: "Colombe",
    explanation:
        "La colombe est souvent vue comme un symbole de paix dans différentes mythologies.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui était la déesse de la chasse dans la mythologie grecque ?",
    options: ["Artémis", "Athena", "Aphrodite"],
    answer: "Artémis",
    explanation:
        "Artémis est la déesse de la chasse, des animaux et de la nature dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel roi des Enfers a été surpris par l'amour pour Perséphone ?",
    options: ["Hadès", "Poséidon", "Cronos"],
    answer: "Hadès",
    explanation:
        "Hadès est le dieu des Enfers qui a enlevé Perséphone et l'a faite sa reine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui était la déesse de la victoire dans la mythologie grecque ?",
    options: ["Nike", "Athena", "Déméter"],
    answer: "Nike",
    explanation:
        "Nike est la déesse de la victoire, souvent représentée avec des ailes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel titan a volé le feu aux dieux pour le donner aux hommes ?",
    options: ["Atlas", "Prométhée", "Hyperion"],
    answer: "Prométhée",
    explanation:
        "Prométhée est le titan qui a volé le feu pour l'offrir à l'humanité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est le dieu des arts et de la musique dans la mythologie grecque ?",
    options: ["Apollon", "Hermès", "Dionysos"],
    answer: "Apollon",
    explanation:
        "Apollon est le dieu de la musique, des arts et de la prophétie dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel personnage de la mythologie grecque était connu pour sa beauté et a causé la guerre de Troie ?",
    options: ["Pâris", "Hector", "Achille"],
    answer: "Pâris",
    explanation:
        "Pâris est connu pour avoir enlevé Hélène, ce qui a déclenché la guerre de Troie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom de l'arbre sacré de la déesse Athéna ?",
    options: ["Chêne", "Olivier", "Figuiers"],
    answer: "Olivier",
    explanation:
        "L'olivier est l'arbre sacré d'Athéna, symbolisant la paix et la prospérité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a créé les femmes selon la mythologie grecque ?",
    options: ["Héphaïstos", "Zeus", "Prométhée"],
    answer: "Héphaïstos",
    explanation:
        "Héphaïstos a façonné les premières femmes, appelées Pandore, pour les dieux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de l'agriculture dans la mythologie romaine ?",
    options: ["Cérès", "Persephone", "Vesta"],
    answer: "Cérès",
    explanation:
        "Cérès est la déesse de l'agriculture, des moissons et de la fécondité dans la mythologie romaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a défié les dieux en s'attaquant au mont Olympe ?",
    options: ["Hercule", "Phaéton", "Icare"],
    answer: "Phaéton",
    explanation:
        "Phaéton a tenté de conduire le char du soleil, défiant ainsi les dieux et causant sa perte.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui était le dieu du feu et des forges chez les Grecs ?",
    options: ["Zeus", "Héphaïstos", "Hermès"],
    answer: "Héphaïstos",
    explanation:
        "Héphaïstos est le dieu du feu, des forges et des artisans dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros mythique a eu un talon vulnérable ?",
    options: ["Hercule", "Achille", "Thésée"],
    answer: "Achille",
    explanation:
        "Achille est connu pour son talon vulnérable, qui a conduit à sa chute.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du dieu égyptien de la lumière et du soleil ?",
    options: ["Ra", "Osiris", "Anubis"],
    answer: "Ra",
    explanation:
        "Ra est le dieu égyptien du soleil et de la lumière, souvent représenté avec un disque solaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Comment se nomme la déesse du printemps et des fleurs dans la mythologie grecque ?",
    options: ["Déméter", "Perséphone", "Héra"],
    answer: "Perséphone",
    explanation:
        "Perséphone est la déesse du printemps et des fleurs, et est aussi associée à l'enfer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a défié les dieux en tentant de voler le feu ?",
    options: ["Prométhée", "Icare", "Hercule"],
    answer: "Prométhée",
    explanation:
        "Prométhée a défié les dieux en volant le feu pour le donner aux humains.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu romain est l'équivalent de Zeus ?",
    options: ["Jupiter", "Mars", "Mercure"],
    answer: "Jupiter",
    explanation:
        "Jupiter est le roi des dieux dans la mythologie romaine, équivalent de Zeus dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros a été aidé par les dieux lors de sa quête pour tuer Méduse ?",
    options: ["Perseus", "Hercule", "Thésée"],
    answer: "Perseus",
    explanation:
        "Perseus a été aidé par des dieux pour accomplir sa quête de tuer Méduse.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu des océans dans la mythologie grecque ?",
    options: ["Poséidon", "Zeus", "Héphaïstos"],
    answer: "Poséidon",
    explanation:
        "Poséidon est le dieu des océans, des tempêtes et des tremblements de terre dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel monstre mythologique avait la tête d'un lion, le corps d'une chèvre et la queue d'un serpent ?",
    options: ["Sphinx", "Chimère", "Hydre"],
    answer: "Chimère",
    explanation:
        "La Chimère est un monstre mythologique avec un lion, une chèvre et un serpent dans sa composition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel dieu égyptien est souvent associé à la fertilité et à la végétation ?",
    options: ["Osiris", "Seth", "Horus"],
    answer: "Osiris",
    explanation:
        "Osiris est le dieu égyptien de l'agriculture et de la fertilité, symbolisant la résurrection et la renaissance.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui était le père d'Apollon dans la mythologie grecque ?",
    options: ["Zeus", "Hermès", "Poséidon"],
    answer: "Zeus",
    explanation:
        "Zeus est le père d'Apollon, le dieu de la lumière, de la musique et des arts.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel animal est souvent associé à la déesse de la guerre Athéna ?",
    options: ["Chouette", "Serpent", "Cheval"],
    answer: "Chouette",
    explanation:
        "La chouette est l'animal sacré d'Athéna, symbolisant la sagesse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Comment s'appelle le fruit que Perséphone a mangé aux Enfers ?",
    options: ["Grenade", "Pomme", "Figue"],
    answer: "Grenade",
    explanation:
        "Perséphone a mangé des graines de grenade aux Enfers, ce qui l'a liée à Hadès.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui était le fils de Poséidon dans la mythologie grecque ?",
    options: ["Achille", "Thésée", "Triton"],
    answer: "Triton",
    explanation:
        "Triton est le fils de Poséidon et est souvent représenté comme un dieu marin.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle était la déesse de la fertilité et de l'agriculture ?",
    options: ["Déméter", "Héra", "Athena"],
    answer: "Déméter",
    explanation:
        "Déméter est la déesse de l'agriculture et de la fertilité dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la chasse dans la mythologie nordique ?",
    options: ["Skaði", "Freya", "Idunn"],
    answer: "Skaði",
    explanation:
        "Skaði est la déesse nordique associée à la chasse et à l'hiver.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du dieu du sommeil dans la mythologie grecque ?",
    options: ["Hypnos", "Thanatos", "Eros"],
    answer: "Hypnos",
    explanation:
        "Hypnos est le dieu du sommeil et du repos dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros de la mythologie grecque était connu pour sa grande force ?",
    options: ["Achille", "Hercule", "Persée"],
    answer: "Hercule",
    explanation:
        "Hercule est reconnu pour sa force surhumaine et ses exploits extraordinaires.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle déesse est souvent associée à la sagesse et à la guerre ?",
    options: ["Athena", "Artémis", "Héra"],
    answer: "Athena",
    explanation:
        "Athena est la déesse de la sagesse, de la guerre et de la stratégie dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le héros de l'Iliade ?",
    options: ["Achille", "Héraclès", "Ulysse"],
    answer: "Achille",
    explanation:
        "Achille est le personnage principal de l'Iliade, connu pour sa force et sa bravoure.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du dieu égyptien des morts ?",
    options: ["Osiris", "Râ", "Horace"],
    answer: "Osiris",
    explanation:
        "Osiris est le dieu égyptien associé à la résurrection et aux morts.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de l'amour dans la mythologie romaine ?",
    options: ["Vénus", "Junon", "Cérès"],
    answer: "Vénus",
    explanation: "Vénus est la déesse romaine de l'amour et de la beauté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a accompli les Douze Travaux ?",
    options: ["Persée", "Héraclès", "Thésée"],
    answer: "Héraclès",
    explanation:
        "Héraclès est célèbre pour ses Douze Travaux imposés par la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est l'autre nom de Poséidon ?",
    options: ["Neptune", "Hades", "Uranus"],
    answer: "Neptune",
    explanation:
        "Neptune est le nom romain du dieu grec Poséidon, dieu des mers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a créé l'homme dans la mythologie grecque ?",
    options: ["Prométhée", "Héphaïstos", "Zeus"],
    answer: "Prométhée",
    explanation:
        "Prométhée est le titan connu pour avoir créé les premiers hommes à partir d'argile.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du roi de la crête qui a enfermé le Minotaure ?",
    options: ["Minos", "Zeus", "Héraclès"],
    answer: "Minos",
    explanation:
        "Minos est le roi crétois célèbre pour avoir enfermé le Minotaure dans le Labyrinthe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu des forgerons et du feu chez les Grecs ?",
    options: ["Héphaïstos", "Arès", "Hermès"],
    answer: "Héphaïstos",
    explanation:
        "Héphaïstos est le dieu des forgerons, du feu et de la métallurgie dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a vaincu la Méduse ?",
    options: ["Persée", "Achille", "Héraclès"],
    answer: "Persée",
    explanation:
        "Persée est le héros mythologique qui a réussi à décapiter la Méduse.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est le dieu de la musique et de la poésie dans la mythologie grecque ?",
    options: ["Apollon", "Artémis", "Hermès"],
    answer: "Apollon",
    explanation:
        "Apollon est le dieu grec de la musique, des arts et de la poésie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel animal est sacré pour la déesse Isis ?",
    options: ["Le chat", "Le crocodile", "Le faucon"],
    answer: "Le chat",
    explanation:
        "Le chat est un animal sacré associé à la déesse égyptienne Isis.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle créature mythologique a le corps d'un homme et la tête d'un taureau ?",
    options: ["Minotaure", "Cérbère", "Chimère"],
    answer: "Minotaure",
    explanation:
        "Le Minotaure est une créature mythologique avec le corps d'un homme et la tête d'un taureau.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu romain de la guerre ?",
    options: ["Mars", "Jupiter", "Vénus"],
    answer: "Mars",
    explanation:
        "Mars est le dieu romain de la guerre, souvent associé à la force militaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel dieu est le messager des dieux dans la mythologie grecque ?",
    options: ["Hermès", "Apollon", "Zeus"],
    answer: "Hermès",
    explanation:
        "Hermès est connu comme le messager des dieux, ainsi que le dieu du commerce.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de l'île où se trouve le Labyrinthe du Minotaure ?",
    options: ["Crète", "Chypre", "Rhodes"],
    answer: "Crète",
    explanation:
        "Le Labyrinthe du Minotaure était situé sur l'île de Crète dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui a été puni à tirer un rocher en haut d'une colline pour l'éternité ?",
    options: ["Sisyphe", "Prométhée", "Tantalus"],
    answer: "Sisyphe",
    explanation:
        "Sisyphe a été puni par les dieux à rouler un rocher en haut d'une colline sans jamais y parvenir.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du père de Zeus ?",
    options: ["Cronos", "Ouranos", "Poséidon"],
    answer: "Cronos",
    explanation:
        "Cronos est le père de Zeus, connu pour avoir dévoré ses enfants.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a pris part à la guerre de Troie ?",
    options: ["Ulysse", "Achille", "Héraclès"],
    answer: "Ulysse",
    explanation:
        "Ulysse est l'un des héros grecs ayant participé à la guerre de Troie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le symbole de la déesse de la chasse, Artémis ?",
    options: ["Le cerf", "Le lion", "Le serpent"],
    answer: "Le cerf",
    explanation:
        "Artémis est souvent associée au cerf, qu'elle protège en tant que déesse de la chasse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu des océans dans la mythologie ?",
    options: ["Poséidon", "Oceanus", "Râ"],
    answer: "Poséidon",
    explanation:
        "Poséidon est le dieu des océans et des séismes dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du fils de Poséidon ?",
    options: ["Triton", "Héraclès", "Jason"],
    answer: "Triton",
    explanation: "Triton est le fils de Poséidon et le messager des mers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu romain est associé à Mercure ?",
    options: ["Hermès", "Apollon", "Vénus"],
    answer: "Hermès",
    explanation:
        "La version romaine de Hermès est Mercure, le messager des dieux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse des moissons ?",
    options: ["Cérès", "Déméter", "Vénus"],
    answer: "Cérès",
    explanation:
        "Cérès est la déesse romaine des moissons, équivalente à Déméter dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel titan a volé le feu aux dieux ?",
    options: ["Prométhée", "Atlas", "Cronos"],
    answer: "Prométhée",
    explanation: "Prométhée a volé le feu aux dieux pour le donner aux hommes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le roi des enfers dans la mythologie grecque ?",
    options: ["Hadès", "Cronos", "Zeus"],
    answer: "Hadès",
    explanation:
        "Hadès est le dieu des enfers et le frère de Zeus dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle est la déesse de la fertilité dans la mythologie égyptienne ?",
    options: ["Isis", "Bastet", "Hathor"],
    answer: "Isis",
    explanation:
        "Isis est la déesse égyptienne de la fertilité, de la maternité et de la magie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom de la déesse de la terre chez les Grecs ?",
    options: ["Gaïa", "Héra", "Déméter"],
    answer: "Gaïa",
    explanation:
        "Gaïa est la déesse primordiale de la terre dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros est connu pour avoir vaincu le dragon ?",
    options: ["Jason", "Thésée", "Héraclès"],
    answer: "Jason",
    explanation:
        "Jason est célèbre pour avoir vaincu le dragon qui gardait la Toison d'or.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la vengeance grecque ?",
    options: ["Némésis", "Hécate", "Rhiannon"],
    answer: "Némésis",
    explanation:
        "Némésis est la déesse grecque de la vengeance et de la rétribution.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros a obtenu des pouvoirs divins après avoir bu le nectar des dieux ?",
    options: ["Héraclès", "Achille", "Ulysse"],
    answer: "Héraclès",
    explanation:
        "Héraclès a été rendu immortel après avoir bu le nectar des dieux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la santé dans la mythologie grecque ?",
    options: ["Hygeia", "Atropos", "Éris"],
    answer: "Hygeia",
    explanation: "Hygeia est la déesse grecque de la santé et du bien-être.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu du vin chez les Grecs ?",
    options: ["Dionysos", "Apollon", "Hermès"],
    answer: "Dionysos",
    explanation: "Dionysos est le dieu grec du vin, de la fête et de l'extase.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel titan a porté le monde sur ses épaules ?",
    options: ["Atlas", "Prométhée", "Cronos"],
    answer: "Atlas",
    explanation:
        "Atlas est le titan condamné à porter le ciel sur ses épaules.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui a donné son nom aux jours de la semaine en rapport avec les dieux ?",
    options: ["Romains", "Grecs", "Égyptiens"],
    answer: "Romains",
    explanation:
        "Les Romains ont nommé les jours de la semaine d'après leurs dieux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel animal transporte le dieu du vent Éole ?",
    options: ["Les chevaux", "Les oiseaux", "Les vaches"],
    answer: "Les chevaux",
    explanation:
        "Éole est souvent représenté comme contrôlant les vents, transportés par des chevaux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros est connu pour avoir sauvé Andromède ?",
    options: ["Persée", "Achille", "Ulysse"],
    answer: "Persée",
    explanation:
        "Persée est le héros qui a sauvé Andromède d'un monstre marin.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel dieu est le père des dieux et des hommes dans la mythologie romaine ?",
    options: ["Jupiter", "Neptune", "Mars"],
    answer: "Jupiter",
    explanation: "Jupiter est le roi des dieux dans la mythologie romaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle déesse était la protectrice des artisans et des bâtisseurs ?",
    options: ["Athena", "Artémis", "Héra"],
    answer: "Athena",
    explanation:
        "Athena est également la déesse des artisans et des bâtisseurs dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la beauté dans la mythologie grecque ?",
    options: ["Aphrodite", "Héra", "Athena"],
    answer: "Aphrodite",
    explanation:
        "Aphrodite est la déesse de la beauté et de l'amour dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le roi d'Argos dans la mythologie grecque ?",
    options: ["Agamemnon", "Thésée", "Pélée"],
    answer: "Agamemnon",
    explanation:
        "Agamemnon était le roi d'Argos et un leader durant la guerre de Troie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros est célèbre pour sa quête de la Toison d'or ?",
    options: ["Jason", "Héraclès", "Thésée"],
    answer: "Jason",
    explanation: "Jason est connu pour sa quête héroïque de la Toison d'or.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel titan a été condamné à être enchaîné à un rocher ?",
    options: ["Prométhée", "Atlas", "Cronos"],
    answer: "Prométhée",
    explanation: "Prométhée a été puni par Zeus pour avoir volé le feu.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est la déesse du foyer et de la maison dans la mythologie romaine ?",
    options: ["Vesta", "Cérès", "Artémis"],
    answer: "Vesta",
    explanation: "Vesta est la déesse romaine du foyer et de la maison.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu des rêves dans la mythologie grecque ?",
    options: ["Hypnos", "Thanatos", "Morpheus"],
    answer: "Morpheus",
    explanation:
        "Morpheus est le dieu des rêves, capable de prendre n'importe quelle forme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a affronté Charybde et Scylla ?",
    options: ["Ulysse", "Achille", "Thésée"],
    answer: "Ulysse",
    explanation:
        "Ulysse a dû naviguer entre Charybde et Scylla lors de son voyage.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse est associée à la sagesse et à la guerre ?",
    options: ["Athena", "Héra", "Artémis"],
    answer: "Athena",
    explanation:
        "Athena est la déesse de la sagesse et de la guerre dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a effectué les travaux d'Hercule ?",
    options: ["Achille", "Hercule", "Persée"],
    answer: "Hercule",
    explanation:
        "Les travaux d'Hercule sont des exploits réalisés par le héros Hercule lui-même dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Dans la mythologie romaine, qui est l'équivalent de Poséidon ?",
    options: ["Neptune", "Mars", "Jupiter"],
    answer: "Neptune",
    explanation:
        "Neptune est le dieu de la mer dans la mythologie romaine, équivalent de Poséidon.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le symbole associé à Aphrodite ?",
    options: ["Le laurier", "La colombe", "Le serpent"],
    answer: "La colombe",
    explanation:
        "La colombe est souvent considérée comme le symbole d'Aphrodite, la déesse de l'amour.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui a créé l'homme dans la mythologie grecque selon le mythe de Prométhée ?",
    options: ["Zeus", "Héraclès", "Prométhée"],
    answer: "Prométhée",
    explanation:
        "Prométhée est le titan qui a façonné l'homme à partir de la terre dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle créature mythologique est connue pour avoir plusieurs têtes ?",
    options: ["La chimère", "Le sphinx", "L'hydre"],
    answer: "L'hydre",
    explanation:
        "L'hydre est une créature mythologique qui a plusieurs têtes et qui repousse celles qui sont coupées.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a vaincu le Minotaure ?",
    options: ["Thésée", "Jason", "Achille"],
    answer: "Thésée",
    explanation:
        "Thésée est le héros qui a vaincu le Minotaure dans le labyrinthe de Crète.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse est la sœur de Zeus ?",
    options: ["Héra", "Déméter", "Artémis"],
    answer: "Héra",
    explanation:
        "Héra est la sœur et l'épouse de Zeus dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du fleuve des Enfers dans la mythologie grecque ?",
    options: ["Styx", "Syrène", "Euphrate"],
    answer: "Styx",
    explanation:
        "Le Styx est le fleuve qui sépare le monde des vivants de celui des morts dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Comment s'appelle le dieu du vin dans la mythologie grecque ?",
    options: ["Dionysos", "Apollon", "Hermès"],
    answer: "Dionysos",
    explanation:
        "Dionysos est le dieu du vin et des festivités dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle est la déesse du foyer et du mariage ?",
    options: ["Hestia", "Hécate", "Gaïa"],
    answer: "Hestia",
    explanation:
        "Hestia est la déesse du foyer et de la vie domestique dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le messager des dieux dans la mythologie grecque ?",
    options: ["Hermès", "Arès", "Atlas"],
    answer: "Hermès",
    explanation:
        "Hermès est connu comme le messager des dieux dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel titan est souvent représenté portant le ciel sur ses épaules ?",
    options: ["Atlas", "Cronos", "Ouranos"],
    answer: "Atlas",
    explanation:
        "Atlas est le titan qui est condamné à porter le ciel sur ses épaules dans la mythologie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom de la déesse de la chasse ?",
    options: ["Artemis", "Athena", "Déméter"],
    answer: "Artemis",
    explanation:
        "Artemis est la déesse de la chasse et de la nature dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros grec est connu pour son talon vulnérable ?",
    options: ["Hercule", "Achille", "Ulysse"],
    answer: "Achille",
    explanation:
        "Achille est célèbre pour son talon vulnérable, source de sa chute dans la guerre de Troie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui était le roi de Troie pendant la guerre de Troie ?",
    options: ["Priam", "Hector", "Achille"],
    answer: "Priam",
    explanation:
        "Priam était le roi de Troie pendant la guerre de Troie dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse est connue pour sa jalousie envers Hercule ?",
    options: ["Héra", "Athena", "Artemis"],
    answer: "Héra",
    explanation:
        "Héra est souvent représentée comme jalouse d'Hercule, le fils de Zeus avec une mortelle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a créé Pandore dans la mythologie grecque ?",
    options: ["Zeus", "Héphaïstos", "Prométhée"],
    answer: "Zeus",
    explanation:
        "C'est Zeus qui a ordonné la création de Pandore, la première femme, comme punition pour les hommes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est l'autre nom du dieu romain Mars ?",
    options: ["Arès", "Ares", "Hercule"],
    answer: "Arès",
    explanation:
        "Mars est l'équivalent du dieu grec Arès, le dieu de la guerre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel monstre de la mythologie grecque avait un corps de lion et une tête d'homme ?",
    options: ["Sphinx", "Chimère", "Cérbère"],
    answer: "Sphinx",
    explanation:
        "Le Sphinx est un monstre mythologique connu pour sa tête d'homme et son corps de lion.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel était le nom du cheval ailé d'origine mythologique ?",
    options: ["Pégase", "Griffon", "Céto"],
    answer: "Pégase",
    explanation:
        "Pégase est le célèbre cheval ailé qui apparaît dans plusieurs mythes grecs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du chien à trois têtes gardant les enfers ?",
    options: ["Cérbère", "Chimère", "Hydre"],
    answer: "Cérbère",
    explanation:
        "Cérbère est le chien à trois têtes qui garde l'entrée des enfers dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a fondé la ville de Rome ?",
    options: ["Romulus", "Rémus", "Aeneas"],
    answer: "Romulus",
    explanation:
        "Romulus est le fondateur mythique de la ville de Rome, selon la légende.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est le dieu de la lumière et de la musique dans la mythologie grecque ?",
    options: ["Apollon", "Hermès", "Dionysos"],
    answer: "Apollon",
    explanation:
        "Apollon est le dieu de la lumière, de la musique et de la prophétie dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a perdu sa femme Eurydice dans le royaume des morts ?",
    options: ["Orphée", "Hercule", "Achille"],
    answer: "Orphée",
    explanation:
        "Orphée est connu pour avoir tenté de ramener sa femme Eurydice des enfers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel titan est connu pour avoir été puni à faire tourner un disque éternel ?",
    options: ["Atlas", "Cronos", "Prométhée"],
    answer: "Atlas",
    explanation:
        "Atlas a été condamné à porter le ciel sur ses épaules, ce qui est souvent interprété comme un disque éternel.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom de la déesse de la terre et de l'agriculture ?",
    options: ["Déméter", "Gaïa", "Artemis"],
    answer: "Déméter",
    explanation:
        "Déméter est la déesse de l'agriculture et des moissons dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le père des dieux dans la mythologie grecque ?",
    options: ["Cronos", "Zeus", "Ouranos"],
    answer: "Cronos",
    explanation:
        "Cronos est souvent considéré comme le père des dieux avant que Zeus ne prenne le pouvoir.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a volé les pommes d'or du jardin des Hespérides ?",
    options: ["Hercule", "Thésée", "Ulysse"],
    answer: "Hercule",
    explanation:
        "Hercule a accompli l'un de ses célèbres travaux en volant les pommes d'or du jardin des Hespérides.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du géant qui défia les dieux en les servant de l' ambroisie et du nectar ?",
    options: ["Tityos", "Gérion", "Antée"],
    answer: "Tityos",
    explanation:
        "Tityos est connu pour avoir défié les dieux en essayant de servir l'ambroisie et le nectar aux mortels.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du cyclope qui a emprisonné Ulysse ?",
    options: ["Polyphème", "Calypso", "Poséidon"],
    answer: "Polyphème",
    explanation:
        "Polyphème est le cyclope qui a capturé Ulysse dans l'Odyssée d'Homère.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Comment s'appelle la déesse romaine de l'amour ?",
    options: ["Vénus", "Minerve", "Diane"],
    answer: "Vénus",
    explanation:
        "Vénus est la déesse romaine de l'amour et de la beauté, équivalente à Aphrodite.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros a porté l'armure d'Achille lors de la guerre de Troie ?",
    options: ["Patrocle", "Agamemnon", "Hector"],
    answer: "Patrocle",
    explanation:
        "Patrocle a porté l'armure d'Achille lors de la guerre de Troie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle créature légendaire est née de l'union de la Méduse et de Poséidon ?",
    options: ["Pégase", "Chimère", "Cérbère"],
    answer: "Pégase",
    explanation:
        "Pégase est né de l'union de Méduse et de Poséidon dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la vengeance dans la mythologie grecque ?",
    options: ["Némésis", "Athena", "Héra"],
    answer: "Némésis",
    explanation:
        "Némésis est la déesse de la vengeance et de la rétribution dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a été transformé en cygne par Zeus ?",
    options: ["Léda", "Héra", "Déméter"],
    answer: "Léda",
    explanation:
        "Léda a été transformée en cygne par Zeus, qui a pris cette forme pour s'approcher d'elle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du roi des Assyriens, souvent associé aux légendes de la mythologie grecque ?",
    options: ["Sennachérib", "Ninive", "Assurbanipal"],
    answer: "Sennachérib",
    explanation:
        "Sennachérib est souvent mentionné dans les récits mythologiques grecs comme un roi puissant.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle ville est connue comme le lieu de naissance d'Aphrodite ?",
    options: ["Chypre", "Troyes", "Athènes"],
    answer: "Chypre",
    explanation:
        "Aphrodite est souvent associée à Chypre, où elle est censée être née de la mer.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du jardin mythologique gardé par des dragons ?",
    options: [
      "Les Jardins des Hespérides",
      "Le Jardin d'Éden",
      "Le Jardin de Perséphone",
    ],
    answer: "Les Jardins des Hespérides",
    explanation:
        "Les Jardins des Hespérides sont gardés par des dragons et abritent des pommes d'or.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a combattu les amazones dans la mythologie grecque ?",
    options: ["Hercule", "Thésée", "Achille"],
    answer: "Hercule",
    explanation:
        "Hercule est célèbre pour avoir combattu les amazones lors de ses aventures mythologiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel Dieu a été enfermé dans une jarre par les autres dieux ?",
    options: ["Éros", "Héraclès", "Hades"],
    answer: "Éros",
    explanation:
        "Dans une légende, Éros, le dieu de l'amour, a été enfermé dans une jarre par d'autres divinités.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse est souvent représentée avec un miroir ?",
    options: ["Vénus", "Athena", "Artémis"],
    answer: "Vénus",
    explanation:
        "Vénus, déesse de la beauté, est souvent représentée avec un miroir dans l'art.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la nymphe qui a incité Apollon à la poursuivre ?",
    options: ["Daphné", "Eurydice", "Calypso"],
    answer: "Daphné",
    explanation:
        "Daphné est la nymphe qui a été poursuivie par Apollon, le dieu de la lumière.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Comment s'appelle le fleuve des âmes dans la mythologie grecque ?",
    options: ["Acheron", "Styx", "Phlégéthon"],
    answer: "Acheron",
    explanation:
        "L'Acheron est le fleuve associé aux âmes des morts dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse du destin dans la mythologie grecque ?",
    options: ["Clotho", "Lachésis", "Atropos"],
    answer: "Clotho",
    explanation:
        "Clotho est une des trois Parques qui tisse le fil de la vie dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a été maudit par Aphrodite de ne jamais être aimé ?",
    options: ["Lysandre", "Cynosure", "Clytemnestre"],
    answer: "Cynosure",
    explanation:
        "Cynosure a été maudit par Aphrodite pour ne jamais connaître l'amour.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse du vent dans la mythologie grecque ?",
    options: ["Éole", "Boreas", "Tempête"],
    answer: "Éole",
    explanation:
        "Éole est souvent considéré comme le dieu et le maître des vents dans la mythologie grecque.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros est connu pour avoir accompli douze travaux impossibles ?",
    options: ["Hercule", "Achille", "Thésée"],
    answer: "Hercule",
    explanation:
        "Hercule est célèbre pour ses douze travaux, réalisés pour expier sa colère.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Dans la mythologie romaine, quel est le nom du dieu de la guerre ?",
    options: ["Mars", "Jupiter", "Vénus"],
    answer: "Mars",
    explanation:
        "Mars est le dieu romain de la guerre, équivalent d'Arès dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est le dieu du vin et de la fête dans la mythologie grecque ?",
    options: ["Dionysos", "Hermès", "Apollon"],
    answer: "Dionysos",
    explanation:
        "Dionysos est le dieu du vin, de la fertilité et des festivités dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle est la déesse de l'amour et de la beauté chez les Grecs ?",
    options: ["Aphrodite", "Hera", "Déméter"],
    answer: "Aphrodite",
    explanation:
        "Aphrodite est la déesse de l'amour et de la beauté dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du serpent monstre tué par Héraclès ?",
    options: ["L'hydre de Lerne", "Le Minotaure", "Cerbère"],
    answer: "L'hydre de Lerne",
    explanation:
        "L'hydre de Lerne est un serpent à plusieurs têtes que Héraclès a dû tuer comme l'un de ses travaux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros de la mythologie grecque a vaincu le Minotaure ?",
    options: ["Thésée", "Persée", "Héraclès"],
    answer: "Thésée",
    explanation:
        "Thésée est connu pour avoir tué le Minotaure dans le labyrinthe de Crète.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du titan qui a volé le feu aux dieux pour le donner aux humains ?",
    options: ["Prométhée", "Atlas", "Cronos"],
    answer: "Prométhée",
    explanation:
        "Prométhée est connu pour avoir dérobé le feu aux dieux et l'avoir offert aux mortels.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du dieu des enfers dans la mythologie grecque ?",
    options: ["Hadès", "Aeolus", "Hermès"],
    answer: "Hadès",
    explanation:
        "Hadès est le dieu des enfers et le frère de Zeus dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la mère d'Apollon et d'Artémis ?",
    options: ["Léto", "Déméter", "Gaïa"],
    answer: "Léto",
    explanation:
        "Léto est la mère des jumeaux Apollon et Artémis dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros grec a mené l'expédition de la Toison d'or ?",
    options: ["Jason", "Achille", "Hercule"],
    answer: "Jason",
    explanation:
        "Jason a mené les Argonautes dans leur quête pour récupérer la Toison d'or.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom de la déesse de la moisson chez les Romains ?",
    options: ["Cérès", "Vénus", "Minerve"],
    answer: "Cérès",
    explanation:
        "Cérès est la déesse de la moisson et de l'agriculture dans la mythologie romaine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du héros grec qui a tué Méduse ?",
    options: ["Persée", "Thésée", "Achille"],
    answer: "Persée",
    explanation:
        "Persée a réussi à tuer Méduse, la gorgone, en utilisant un miroir.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du dieu des commerçants et des voleurs chez les Grecs ?",
    options: ["Hermès", "Apollon", "Dionysos"],
    answer: "Hermès",
    explanation:
        "Hermès est le dieu des commerçants, des voleurs et des voyageurs dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est connu comme le père des dieux dans la mythologie romaine ?",
    options: ["Jupiter", "Mars", "Neptune"],
    answer: "Jupiter",
    explanation:
        "Jupiter est le père des dieux et le dieu du ciel dans la mythologie romaine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel monstre mythologique avait le corps d'un lion et la tête d'un homme ?",
    options: ["Sphinx", "Minotaure", "Chimère"],
    answer: "Sphinx",
    explanation:
        "Le Sphinx est une créature mythologique avec le corps d'un lion et la tête d'un homme.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros est connu pour sa force et son combat contre des lions ?",
    options: ["Hercule", "Achille", "Ulysse"],
    answer: "Hercule",
    explanation:
        "Hercule est célèbre pour sa force et ses combats contre des lions, parmi d'autres défis.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu est associé au soleil dans la mythologie grecque ?",
    options: ["Apollon", "Hermès", "Dionysos"],
    answer: "Apollon",
    explanation:
        "Apollon est le dieu du soleil, de la musique et de la prophétie dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le roi de Troie durant la guerre de Troie ?",
    options: ["Priam", "Hector", "Achille"],
    answer: "Priam",
    explanation: "Priam était le roi de Troie au début de la guerre de Troie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a échappé aux sirènes en se bouchant les oreilles ?",
    options: ["Ulysse", "Thésée", "Persée"],
    answer: "Ulysse",
    explanation:
        "Ulysse a fait face aux sirènes en se bouchant les oreilles et en se faisant attacher au mât de son navire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle est la déesse du foyer et de la famille chez les Romains ?",
    options: ["Vesta", "Déméter", "Minerva"],
    answer: "Vesta",
    explanation:
        "Vesta est la déesse du foyer et de la famille dans la mythologie romaine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel personnage mythologique est connu pour avoir déclenché la guerre de Troie ?",
    options: ["Pâris", "Hector", "Achille"],
    answer: "Pâris",
    explanation:
        "Pâris est connu pour avoir enlevé Hélène, ce qui a déclenché la guerre de Troie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le guérisseur des dieux dans la mythologie grecque ?",
    options: ["Asclépios", "Hermès", "Apollon"],
    answer: "Asclépios",
    explanation:
        "Asclépios est le dieu de la médecine et le guérisseur des dieux dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel monstre était connu pour avoir plusieurs têtes qui repoussaient ?",
    options: ["Hydre", "Cérbère", "Chimère"],
    answer: "Hydre",
    explanation:
        "L'hydre de Lerne avait plusieurs têtes qui repoussaient une fois coupées.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est connu comme la déesse de la guerre ?",
    options: ["Athena", "Artémis", "Hera"],
    answer: "Athena",
    explanation:
        "Athena est la déesse de la guerre, de la sagesse et de la stratégie dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a été transformé en oiseau après sa mort ?",
    options: ["Achille", "Orphée", "Dionysos"],
    answer: "Orphée",
    explanation:
        "Orphée, le célèbre musicien, a été transformé en un oiseau après sa mort.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu des vents dans la mythologie grecque ?",
    options: ["Éole", "Poséidon", "Zeus"],
    answer: "Éole",
    explanation:
        "Éole est le dieu des vents et gardien des tempêtes dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a été trahi par sa femme, Cléopâtre ?",
    options: ["Marc Antoine", "Néron", "Jules César"],
    answer: "Marc Antoine",
    explanation:
        "Marc Antoine a été trahi par Cléopâtre, ce qui a conduit à sa chute.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel titan a été dévoré par ses propres enfants ?",
    options: ["Cronos", "Atlas", "Prométhée"],
    answer: "Cronos",
    explanation:
        "Cronos a dévoré ses enfants par crainte d'être détrôné par l'un d'eux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle déesse est souvent représentée avec une balance dans la mythologie romaine ?",
    options: ["Thémis", "Justice", "Vénus"],
    answer: "Thémis",
    explanation:
        "Thémis est la déesse de la justice et de l'ordre, souvent représentée avec une balance.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros grec a réalisé un voyage épique pour rentrer chez lui après la guerre de Troie ?",
    options: ["Ulysse", "Achille", "Hercule"],
    answer: "Ulysse",
    explanation:
        "Ulysse a entrepris un long voyage après la guerre de Troie, raconté dans l'Odyssée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel grand monstre a été vaincu par Héraclès lors de son deuxième travail ?",
    options: ["L'hydre", "Le lion de Némée", "Le sanglier d'Érymanthos"],
    answer: "Le lion de Némée",
    explanation:
        "Le lion de Némée était le premier travail d'Héraclès, qu'il a tué pour prouver sa force.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel roi de Sparte est connu pour ses exploits lors de la bataille des Thermopyles ?",
    options: ["Léonidas", "Achille", "Thésée"],
    answer: "Léonidas",
    explanation:
        "Léonidas est célèbre pour sa résistance héroïque avec ses 300 guerriers aux Thermopyles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la lune dans la mythologie romaine ?",
    options: ["Luna", "Selene", "Hécate"],
    answer: "Luna",
    explanation: "Luna est la déesse de la lune dans la mythologie romaine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros est connu pour avoir reçu des dons de la déesse de la guerre ?",
    options: ["Achille", "Hercule", "Ajax"],
    answer: "Achille",
    explanation:
        "Achille a reçu des dons d'Athena, ce qui l'a rendu presque invincible.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel roi d'Argos était célèbre pour avoir des yeux partout ?",
    options: ["Argos", "Persée", "Sisyphus"],
    answer: "Argos",
    explanation:
        "Argos était un titan dont le corps était couvert d'yeux, ce qui le rendait vigilant.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle créature mythologique se nourrit de sang et est souvent associée à la nuit ?",
    options: ["Vampire", "Sphinx", "Loup-garou"],
    answer: "Vampire",
    explanation:
        "Les vampires sont des créatures mythologiques se nourrissant de sang, souvent associées à la nuit.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la mère de Dionysos selon la mythologie grecque ?",
    options: ["Sémélé", "Héra", "Athena"],
    answer: "Sémélé",
    explanation:
        "Sémélé est la mère de Dionysos, le dieu du vin, selon la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel roi de la mythologie grecque a été transformé en cerf par sa propre mère ?",
    options: ["Actéon", "Achille", "Thiésée"],
    answer: "Actéon",
    explanation:
        "Actéon a été transformé en cerf par Artémis, sa mère, comme punition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du dieu des océans dans la mythologie grecque ?",
    options: ["Poséidon", "Zeus", "Hades"],
    answer: "Poséidon",
    explanation:
        "Poséidon est le dieu des océans, des tremblements de terre et des chevaux dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est le héros qui a défié les dieux et a été puni pour cela ?",
    options: ["Phaéton", "Ulysse", "Hercule"],
    answer: "Phaéton",
    explanation:
        "Phaéton a défié les dieux en volant le char du soleil, ce qui lui a valu une punition.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel titan est connu pour son intelligence et son inventivité ?",
    options: ["Prométhée", "Cronos", "Atlas"],
    answer: "Prométhée",
    explanation:
        "Prométhée est connu pour son intelligence et pour avoir donné le feu aux humains.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la victoire dans la mythologie grecque ?",
    options: ["Niké", "Thémis", "Hécate"],
    answer: "Niké",
    explanation:
        "Niké est la déesse de la victoire, souvent symbolisée par une couronne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros s'est battu contre le roi de la mer dans un célèbre mythe ?",
    options: ["Achille", "Héraclès", "Ulysse"],
    answer: "Ulysse",
    explanation:
        "Ulysse a dû s'affronter à Poséidon, le roi de la mer, lors de son voyage.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel personnage mythologique a été transformé en nymphe de la mer ?",
    options: ["Leucothée", "Psyche", "Eurydice"],
    answer: "Leucothée",
    explanation:
        "Leucothée a été transformée en nymphe de la mer pour aider son fils.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle créature a été créée par les dieux pour punir l'humanité selon la mythologie grecque ?",
    options: ["Pandore", "Méduse", "Sphinx"],
    answer: "Pandore",
    explanation:
        "Pandore a été créée par les dieux comme punition pour l'humanité.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle est la déesse de la sagesse dans la mythologie grecque ?",
    options: ["Artémis", "Athéna", "Héra"],
    answer: "Athéna",
    explanation:
        "Athéna est la déesse de la sagesse et de la guerre stratégique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Comment s'appelle le roi des dieux dans la mythologie grecque ?",
    options: ["Zeus", "Hadès", "Poséidon"],
    answer: "Zeus",
    explanation:
        "Zeus est considéré comme le roi des dieux dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros grec a accompli douze travaux ?",
    options: ["Achille", "Hercule", "Thésée"],
    answer: "Hercule",
    explanation:
        "Hercule a été célèbre pour ses douze travaux, imposés par Eurysthée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a offert une pomme d'or lors du jugement de Pâris ?",
    options: ["Artémis", "Héra", "Erèbe"],
    answer: "Erèbe",
    explanation:
        "Erèbe a eu un rôle indirect dans le jugement de Pâris, lié à la pomme d'or.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom de la déesse de la chasse chez les Grecs ?",
    options: ["Déméter", "Artémis", "Héra"],
    answer: "Artémis",
    explanation: "Artémis est la déesse de la chasse et de la nature sauvage.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le frère de Zeus dans la mythologie ?",
    options: ["Poséidon", "Hades", "Hermès"],
    answer: "Poséidon",
    explanation: "Poséidon est le frère de Zeus et le dieu de la mer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle est la déesse de l'amour dans la mythologie grecque ?",
    options: ["Artémis", "Aphrodite", "Héra"],
    answer: "Aphrodite",
    explanation: "Aphrodite est la déesse de l'amour et de la beauté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du serpent qui gardait les pommes d'or dans le jardin des Hespérides ?",
    options: ["Ladon", "Typhon", "Python"],
    answer: "Ladon",
    explanation:
        "Ladon est le serpent qui protégeait les pommes d'or des Hespérides.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a volé le feu pour le donner aux hommes ?",
    options: ["Prométhée", "Hercule", "Hermès"],
    answer: "Prométhée",
    explanation:
        "Prométhée est célèbre pour avoir volé le feu aux dieux pour l'offrir aux humains.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle est la mythologie qui parle de Thor ?",
    options: ["Égyptienne", "Nordique", "Greque"],
    answer: "Nordique",
    explanation:
        "Thor est une divinité majeure dans la mythologie nordique, représentant le tonnerre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel monstre a été tué par Thésée ?",
    options: ["Le Minotaure", "Le Kraken", "L'Hydre"],
    answer: "Le Minotaure",
    explanation: "Thésée a tué le Minotaure dans le labyrinthe de Crète.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel était le nom du père d'Apollon et d'Artémis ?",
    options: ["Cronos", "Zeus", "Hadès"],
    answer: "Zeus",
    explanation: "Zeus est le père d'Apollon et d'Artémis.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui était la première femme dans la mythologie grecque ?",
    options: ["Hélène", "Pandore", "Athéna"],
    answer: "Pandore",
    explanation:
        "Pandore est considérée comme la première femme dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu était connu comme le messager des dieux ?",
    options: ["Poséidon", "Hermès", "Arès"],
    answer: "Hermès",
    explanation: "Hermès est le messager des dieux dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel phénomène naturel est associé à Poséidon ?",
    options: ["Des tempêtes", "Des tremblements de terre", "Des éclipses"],
    answer: "Des tremblements de terre",
    explanation:
        "Poséidon est associé aux tremblements de terre, en plus de la mer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel titan a été puni à porter le ciel ?",
    options: ["Atlas", "Cronos", "Prométhée"],
    answer: "Atlas",
    explanation: "Atlas a été condamné à porter le ciel sur ses épaules.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui était la déesse du foyer ?",
    options: ["Hestia", "Perséphone", "Athena"],
    answer: "Hestia",
    explanation: "Hestia est la déesse du foyer et de la famille.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros est connu pour sa rapidité et son agilité ?",
    options: ["Achille", "Hermès", "Thésée"],
    answer: "Hermès",
    explanation:
        "Hermès est reconnu pour sa rapidité, souvent représenté avec des ailes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle créature mythologique a une tête de lion et un corps de chèvre ?",
    options: ["Le Sphinx", "La Chimère", "Le Minotaure"],
    answer: "La Chimère",
    explanation:
        "La Chimère est une créature mythologique composée d'une tête de lion, d'un corps de chèvre et d'une queue de serpent.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a combattu les géants lors de la Gigantomachie ?",
    options: ["Hercule", "Achille", "Thésée"],
    answer: "Hercule",
    explanation:
        "Hercule a joué un rôle clé dans la lutte contre les géants pendant la Gigantomachie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel titan a englouti ses enfants ?",
    options: ["Cronos", "Ouranos", "Atlas"],
    answer: "Cronos",
    explanation: "Cronos a englouti ses enfants de peur d'être renversé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle était la mission de Jason et des Argonautes ?",
    options: [
      "Trouver la Toison d'or",
      "Sauver une princesse",
      "Battre un dragon",
    ],
    answer: "Trouver la Toison d'or",
    explanation: "Jason et les Argonautes étaient en quête de la Toison d'or.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle est la ville où se trouve le célèbre temple d'Athéna ?",
    options: ["Athènes", "Thèbes", "Corinthe"],
    answer: "Athènes",
    explanation:
        "Le célèbre temple d'Athéna, le Parthénon, se trouve à Athènes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu du vent est souvent représenté avec des ailes ?",
    options: ["Éole", "Poséidon", "Zeus"],
    answer: "Éole",
    explanation: "Éole est connu comme le dieu des vents dans la mythologie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Comment s'appelle le chien à trois têtes de Hadès ?",
    options: ["Cerbère", "Argos", "Pégase"],
    answer: "Cerbère",
    explanation:
        "Cerbère est le chien à trois têtes qui garde l'entrée des Enfers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le symbole principal de Dionysos ?",
    options: ["Le vin", "La guerre", "La sagesse"],
    answer: "Le vin",
    explanation: "Dionysos est le dieu du vin et des festivités.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros a reçu une armure d'invincibilité forgée par Héphaïstos ?",
    options: ["Achille", "Hercule", "Thésée"],
    answer: "Achille",
    explanation:
        "Achille a porté une armure d'invincibilité faite par Héphaïstos.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel été le nom de l'épée d'Excalibur ?",
    options: ["Excalibur", "Durendal", "Glamdring"],
    answer: "Excalibur",
    explanation: "Excalibur est l'épée magique du roi Arthur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du héros qui a vaincu le Cyclope ?",
    options: ["Ulysse", "Thésée", "Hercule"],
    answer: "Ulysse",
    explanation: "Ulysse a vaincu le Cyclope Polyphemus dans l'Odyssée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu égyptien de la mort ?",
    options: ["Osiris", "Râ", "Anubis"],
    answer: "Osiris",
    explanation:
        "Osiris est le dieu égyptien associé à la mort et à la résurrection.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel enfant de Zeus a été caché pour éviter la colère de Cronos ?",
    options: ["Hermès", "Dionysos", "Zagreus"],
    answer: "Dionysos",
    explanation:
        "Dionysos a été caché pour échapper à Cronos qui engloutissait ses enfants.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom des jumeaux célèbres de la mythologie romaine ?",
    options: ["Romulus et Rémus", "Castor et Pollux", "Hercule et Thésée"],
    answer: "Romulus et Rémus",
    explanation: "Romulus et Rémus sont les fondateurs mythiques de Rome.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel titan a été emprisonné sous le mont Olympe ?",
    options: ["Cronos", "Atlas", "Prométhée"],
    answer: "Cronos",
    explanation: "Cronos a été emprisonné sous le mont Olympe par ses enfants.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu est connu pour son char tiré par des chevaux ?",
    options: ["Apollon", "Poséidon", "Zeus"],
    answer: "Apollon",
    explanation:
        "Apollon est souvent représenté conduisant un char tiré par des chevaux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a été transformé en cygne par Zeus ?",
    options: ["Leda", "Héra", "Athéna"],
    answer: "Leda",
    explanation: "Leda a été transformée en cygne par Zeus.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros grec a été trahi par sa femme ?",
    options: ["Achille", "Hercule", "Oreste"],
    answer: "Oreste",
    explanation: "Oreste a été trahi par sa mère, Clytemnestre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du pouvoir de transformation d'Apollon ?",
    options: ["Métamorphose", "Transfiguration", "Métamorphorisation"],
    answer: "Métamorphose",
    explanation:
        "Apollon a la capacité de se transformer sous différentes formes dans les mythes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de l'endroit où les âmes des morts se rendent dans la mythologie grecque ?",
    options: ["L'Elysée", "Les Champs-Élysées", "Les Enfers"],
    answer: "Les Enfers",
    explanation:
        "Les âmes des morts se rendent aux Enfers selon la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu était souvent représenté avec un serpent ?",
    options: ["Hermès", "Aphrodite", "Esculape"],
    answer: "Esculape",
    explanation:
        "Esculape, le dieu de la médecine, est souvent associé à un serpent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a construit le labyrinthe pour le Minotaure ?",
    options: ["Dédale", "Thésée", "Icare"],
    answer: "Dédale",
    explanation:
        "Dédale est l'architecte qui a conçu le labyrinthe pour le Minotaure.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du héros qui a réussi à voler la Toison d'or ?",
    options: ["Jason", "Achille", "Hercule"],
    answer: "Jason",
    explanation: "Jason a mené une expédition pour obtenir la Toison d'or.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel titan a été connu pour sa force immense ?",
    options: ["Atlas", "Cronos", "Prométhée"],
    answer: "Atlas",
    explanation:
        "Atlas est souvent représenté comme un titan ayant une force énorme.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du roi d'Ithaque ?",
    options: ["Ulysse", "Achille", "Télémarque"],
    answer: "Ulysse",
    explanation:
        "Ulysse est le roi d'Ithaque, connu pour ses aventures dans l'Odyssée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la guerre dans la mythologie grecque ?",
    options: ["Athena", "Artémis", "Héra"],
    answer: "Athena",
    explanation:
        "Athena est la déesse de la guerre stratégique et de la sagesse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du géant de l'Antiquité qui a défié Zeus ?",
    options: ["Typhon", "Hercule", "Cronos"],
    answer: "Typhon",
    explanation:
        "Typhon est un géant qui a défié Zeus lors d'une bataille mythique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui était le roi des dieux dans la mythologie égyptienne ?",
    options: ["Osiris", "Râ", "Anubis"],
    answer: "Râ",
    explanation:
        "Râ était considéré comme le roi des dieux dans la mythologie égyptienne.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle déesse est souvent associée avec la sagesse et la guerre ?",
    options: ["Aphrodite", "Athena", "Artémis"],
    answer: "Athena",
    explanation:
        "Athena est la déesse grecque de la sagesse et de la stratégie militaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros est connu pour avoir accompli les travaux d'Hercule ?",
    options: ["Achille", "Ulysse", "Hercule"],
    answer: "Hercule",
    explanation:
        "Hercule est célèbre pour ses douze travaux, qui sont des épreuves héroïques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du titan qui a été condamné à porter le ciel ?",
    options: ["Atlas", "Prométhée", "Cronos"],
    answer: "Atlas",
    explanation:
        "Atlas est un titan connu pour être puni en portant le ciel sur ses épaules.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a offert le cheval de Troie aux Grecs ?",
    options: ["Achille", "Ulysse", "Hector"],
    answer: "Ulysse",
    explanation:
        "Ulysse est le stratège qui a conçu le plan du cheval de Troie pour infiltrer la ville.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros mythologique était célèbre pour sa force et sa bravoure dans la guerre de Troie ?",
    options: ["Achille", "Hercule", "Persée"],
    answer: "Achille",
    explanation:
        "Achille est le héros troyen connu pour sa force incroyable et son rôle central dans la guerre de Troie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu romain est le équivalent de Poséidon ?",
    options: ["Mars", "Neptune", "Jupiter"],
    answer: "Neptune",
    explanation:
        "Neptune est le dieu romain des mers, équivalent de Poséidon dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel personnage mythologique a vaincu Méduse ?",
    options: ["Thésée", "Persée", "Hercule"],
    answer: "Persée",
    explanation:
        "Persée est connu pour avoir tué Méduse, la gorgone, avec l'aide des dieux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel titan a volé le feu aux dieux pour l'offrir aux humains ?",
    options: ["Atlas", "Prométhée", "Cronos"],
    answer: "Prométhée",
    explanation:
        "Prométhée a défié les dieux en offrant le feu aux humains, un symbole de connaissance et de progrès.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de l'armée de squelettes invoquée par un héros dans la mythologie grecque ?",
    options: ["Les Sphinx", "Les Revenants", "Les Morts-vivants"],
    answer: "Les Morts-vivants",
    explanation:
        "Les Morts-vivants sont souvent cités dans des mythes comme une armée de squelettes commandée par des héros.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu est associé à la musique et à la poésie ?",
    options: ["Apollon", "Hermès", "Dionysos"],
    answer: "Apollon",
    explanation:
        "Apollon est le dieu des arts, notamment de la musique et de la poésie dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le père de Zeus ?",
    options: ["Cronos", "Uranus", "Hadès"],
    answer: "Cronos",
    explanation:
        "Cronos est le titan qui a engendré Zeus, ainsi que ses frères et sœurs, avant d'être renversé par son fils.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le roi qui a reçu le don de la sagesse après avoir coupé les rochers ?",
    options: ["Midas", "Solomon", "Oedipe"],
    answer: "Midas",
    explanation:
        "Le roi Midas est connu pour son vœu de transformer tout ce qu'il touchait en or, mais il a appris une leçon sur la sagesse.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros a combattu les monstres marins pour sauver sa bien-aimée ?",
    options: ["Ulysse", "Orphée", "Persée"],
    answer: "Ulysse",
    explanation:
        "Ulysse a affronté divers monstres marins lors de son voyage de retour vers Ithaque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a été transformée en étoile après sa mort ?",
    options: ["Cassiopeia", "Andromède", "Pégase"],
    answer: "Cassiopeia",
    explanation:
        "Cassiopeia est une reine mythologique qui a été placée parmi les constellations après sa mort.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros de la mythologie a trouvé la Toison d'Or ?",
    options: ["Jason", "Thésée", "Hercule"],
    answer: "Jason",
    explanation:
        "Jason est connu pour avoir dirigé les Argonautes dans leur quête pour récupérer la Toison d'Or.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse symbolise la fertilité et l'agriculture ?",
    options: ["Déméter", "Héra", "Artemis"],
    answer: "Déméter",
    explanation:
        "Déméter est la déesse de l'agriculture et de la fertilité dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le serpent de mer géant dans la mythologie scandinave ?",
    options: ["Jörmungandr", "Fenrir", "Nidhogg"],
    answer: "Jörmungandr",
    explanation:
        "Jörmungandr est le serpent de mer qui entoure le monde dans la mythologie nordique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la victoire dans la mythologie grecque ?",
    options: ["Nike", "Eiréné", "Thanatos"],
    answer: "Nike",
    explanation:
        "Nike est la déesse grecque de la victoire, souvent représentée avec des ailes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel roi a été puni de ne jamais pouvoir boire ou manger ?",
    options: ["Sisyphe", "Tantalus", "Midas"],
    answer: "Tantalus",
    explanation:
        "Tantalus a été condamné à une éternité de faim et de soif dans les Enfers, inaccessible à la nourriture et à l'eau.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros est connu pour avoir vaincu le Minotaure ?",
    options: ["Thésée", "Persée", "Hercule"],
    answer: "Thésée",
    explanation:
        "Thésée est célèbre pour avoir tué le Minotaure dans le labyrinthe de Crète.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel guerrier est connu pour son talon comme point faible ?",
    options: ["Achille", "Hercule", "Ulysse"],
    answer: "Achille",
    explanation:
        "Achille est célèbre pour son talon, qui a été sa seule faiblesse lors de sa bataille.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Comment s'appelle la déesse des champs et des moissons ?",
    options: ["Héra", "Déméter", "Artemis"],
    answer: "Déméter",
    explanation:
        "Déméter est la déesse des moissons et de l'agriculture dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros est le fils de Poséidon ?",
    options: ["Hercule", "Thésée", "Achille"],
    answer: "Hercule",
    explanation:
        "Hercule est le fils de Poséidon et est connu pour sa grande force et ses aventures épiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a fabriqué le labyrinthe où était enfermé le Minotaure ?",
    options: ["Dédale", "Icare", "Thésée"],
    answer: "Dédale",
    explanation:
        "Dédale est le créateur du labyrinthe, un chef-d'œuvre d'ingéniosité architecturale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du dieu des vents dans la mythologie grecque ?",
    options: ["Éole", "Boreas", "Zephyros"],
    answer: "Éole",
    explanation:
        "Éole est le dieu des vents, souvent représenté comme le gardien des vents dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu est souvent représenté avec une couronne de laurier ?",
    options: ["Apollon", "Zeus", "Hermès"],
    answer: "Apollon",
    explanation:
        "Apollon est souvent symbolisé par une couronne de laurier, représentant la victoire et l'accomplissement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le gardien du royaume des enfers ?",
    options: ["Cerbère", "Hadès", "Charon"],
    answer: "Cerbère",
    explanation:
        "Cerbère est le chien à trois têtes qui garde l'entrée des enfers.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a découvert le secret d'un oracle célèbre ?",
    options: ["Thésée", "Oedipe", "Ulysse"],
    answer: "Oedipe",
    explanation:
        "Oedipe a découvert la prophétie de l'oracle de Delphes, ce qui a changé le cours de son destin.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui était la déesse de la chasse dans la mythologie romaine ?",
    options: ["Vénus", "Minerva", "Diana"],
    answer: "Diana",
    explanation:
        "Diana est la déesse romaine de la chasse, équivalente à Artémis dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du héros qui a défendu Troie pendant ses dix ans de siège ?",
    options: ["Achille", "Hector", "Patrocle"],
    answer: "Hector",
    explanation:
        "Hector était le prince de Troie et le plus grand guerrier de la ville pendant la guerre de Troie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel roi a reçu le pouvoir de transformer tout ce qu'il touchait en or ?",
    options: ["Midas", "Eros", "Jason"],
    answer: "Midas",
    explanation:
        "Le roi Midas a reçu le don de transformer tout en or, mais ce pouvoir s'est avéré être une malédiction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel personnage mythologique est connu pour ses voyages et ses aventures ?",
    options: ["Ulysse", "Thésée", "Hercule"],
    answer: "Ulysse",
    explanation:
        "Ulysse est le héros d'Homère, connu pour ses voyages épiques dans 'L'Odyssée'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse est souvent représentée avec des épis de blé ?",
    options: ["Déméter", "Athena", "Artémis"],
    answer: "Déméter",
    explanation:
        "Déméter est la déesse des moissons, souvent associée à la fertilité des champs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le créateur de l'humanité selon la mythologie grecque ?",
    options: ["Prométhée", "Zeus", "Hercule"],
    answer: "Prométhée",
    explanation:
        "Prométhée est souvent crédité d'avoir façonné les premiers humains à partir d'argile.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du dieu du vin et de la fête dans la mythologie grecque ?",
    options: ["Dionysos", "Apollon", "Hermès"],
    answer: "Dionysos",
    explanation:
        "Dionysos est le dieu du vin et de la fête, symbole de l'extase et de la célébration.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la mère de Zeus ?",
    options: ["Gaïa", "Rhéo", "Héra"],
    answer: "Rhéo",
    explanation:
        "Rhéo est la mère de Zeus, qui a caché son fils pour le protéger de Cronos.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom de la déesse de la terre et de la nature ?",
    options: ["Gaïa", "Héra", "Athena"],
    answer: "Gaïa",
    explanation:
        "Gaïa est la personnification de la Terre et une déesse primordiale dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du père de Zeus, connu pour avoir dévoré ses enfants ?",
    options: ["Cronos", "Uranus", "Hades"],
    answer: "Cronos",
    explanation:
        "Cronos a dévoré plusieurs de ses enfants pour éviter d'être renversé, mais Zeus a échappé à son sort.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel personnage mythologique est souvent représenté avec une lyre ?",
    options: ["Appolon", "Hermès", "Orphée"],
    answer: "Orphée",
    explanation:
        "Orphée est un héros et musicien dont la lyre pouvait charmer tous les êtres vivants.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a écrit les 'Métamorphoses' dans la littérature romaine ?",
    options: ["Ovide", "Virgile", "Horace"],
    answer: "Ovide",
    explanation:
        "Ovide est célèbre pour ses 'Métamorphoses', une œuvre qui raconte des transformations mythologiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de l'instrument que joue Hermès dans la mythologie ?",
    options: ["La lyre", "La flûte", "Le tambour"],
    answer: "La lyre",
    explanation:
        "Hermès est souvent représenté avec une lyre, qu'il a inventée à partir d'une carapace de tortue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros est célèbre pour avoir mené les Argonautes ?",
    options: ["Jason", "Thésée", "Hercule"],
    answer: "Jason",
    explanation:
        "Jason est connu pour son rôle de chef des Argonautes dans la quête de la Toison d'Or.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse est associée au commerce et aux voyages ?",
    options: ["Héra", "Athena", "Hermès"],
    answer: "Hermès",
    explanation:
        "Hermès est le dieu du commerce, des voleurs et des voyageurs dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la vengeance dans la mythologie grecque ?",
    options: ["Furie", "Athena", "Artemis"],
    answer: "Furie",
    explanation:
        "Les Furies sont des déesses de la vengeance, représentant la colère et le châtiment des coupables.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel héros a reçu une armure magique pour combattre les géants ?",
    options: ["Achille", "Hercule", "Persée"],
    answer: "Achille",
    explanation:
        "Achille a reçu une armure magique pour le protéger lors de ses combats contre les ennemis.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est le personnage mythologique connu pour avoir été transformé en oiseau ?",
    options: ["Io", "Déméter", "Héra"],
    answer: "Io",
    explanation:
        "Io a été transformée en vache et finalement en oiseau pour échapper à la jalousie d'Héra.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu grec de la guerre ?",
    options: ["Arès", "Hermès", "Poséidon"],
    answer: "Arès",
    explanation:
        "Arès est considéré comme le dieu de la guerre dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse est souvent associée à la sagesse ?",
    options: ["Artémis", "Athena", "Aphrodite"],
    answer: "Athena",
    explanation:
        "Athena est la déesse de la sagesse et de la stratégie militaire dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Dans la mythologie romaine, qui est l'équivalent de Zeus ?",
    options: ["Jupiter", "Mars", "Neptune"],
    answer: "Jupiter",
    explanation:
        "Jupiter est le roi des dieux dans la mythologie romaine, équivalent de Zeus en Grèce.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est le héros grec célèbre pour avoir accompli les Travaux d'Hercule ?",
    options: ["Achille", "Hercule", "Thésée"],
    answer: "Hercule",
    explanation:
        "Hercule est connu pour ses douze travaux, faisant de lui un héros emblématique de la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quelle créature mythologique est célèbre pour son souffle mortel ?",
    options: ["Chimère", "Sphinx", "Méduse"],
    answer: "Méduse",
    explanation:
        "Méduse est connue pour transformer en pierre quiconque croise son regard.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de la déesse de la chasse dans la mythologie grecque ?",
    options: ["Artémis", "Héra", "Déméter"],
    answer: "Artémis",
    explanation:
        "Artémis est la déesse de la chasse et des animaux sauvages dans la mythologie grecque.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le père de tous les dieux dans la mythologie nordique ?",
    options: ["Odin", "Thor", "Loki"],
    answer: "Odin",
    explanation:
        "Odin est considéré comme le dieu principal et le père de tous les dieux dans la mythologie nordique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom de la déesse de l'amour et de la beauté ?",
    options: ["Aphrodite", "Héra", "Perséphone"],
    answer: "Aphrodite",
    explanation:
        "Aphrodite est la déesse de l'amour et de la beauté dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle est la terre d'origine des dieux grecs ?",
    options: ["Olympe", "Péloponnèse", "Crète"],
    answer: "Olympe",
    explanation:
        "L'Olympe est le mont où résidaient les dieux grecs dans la mythologie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le dieu romain des enfers ?",
    options: ["Pluton", "Cérès", "Vesta"],
    answer: "Pluton",
    explanation:
        "Pluton est le dieu romain des enfers, équivalent d'Hadès dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a puni Prométhée pour avoir donné le feu aux humains ?",
    options: ["Zeus", "Héra", "Poséidon"],
    answer: "Zeus",
    explanation:
        "Zeus a puni Prométhée en le condamnant à être enchaîné et dévoré par un aigle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom du demi-dieu célèbre pour sa force prodigieuse ?",
    options: ["Achille", "Hercule", "Persée"],
    answer: "Hercule",
    explanation:
        "Hercule est connu pour sa force exceptionnelle et ses exploits héroïques dans la mythologie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle est la représentation de la justice dans la mythologie ?",
    options: ["Thémis", "Eris", "Athena"],
    answer: "Thémis",
    explanation:
        "Thémis est la déesse de la justice et de l'ordre dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a vaincu le Minotaure ?",
    options: ["Thésée", "Hercule", "Persée"],
    answer: "Thésée",
    explanation:
        "Thésée est célèbre pour avoir tué le Minotaure dans le labyrinthe de Crète.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la moisson dans la mythologie grecque ?",
    options: ["Déméter", "Héra", "Aphrodite"],
    answer: "Déméter",
    explanation:
        "Déméter est la déesse de l'agriculture et de la moisson dans la mythologie grecque.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse du destin et du sort ?",
    options: ["Moires", "Eris", "Gaïa"],
    answer: "Moires",
    explanation:
        "Les Moires sont les déesses du destin qui contrôlent la vie des mortels.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu est souvent représenté avec des ailes et un caducée ?",
    options: ["Hermès", "Arès", "Apollon"],
    answer: "Hermès",
    explanation:
        "Hermès est le messager des dieux et est souvent représenté avec un caducée et des ailes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel animal est associé à la déesse Athena ?",
    options: ["Écrevisse", "Chouette", "Serpent"],
    answer: "Chouette",
    explanation:
        "La chouette est considérée comme le symbole de sagesse d'Athena.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le titan condamné à porter le ciel sur ses épaules ?",
    options: ["Atlas", "Prométhée", "Cronos"],
    answer: "Atlas",
    explanation:
        "Atlas est puni et condamné à porter le ciel sur ses épaules pour l'éternité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du serpent géant dans la mythologie grecque ?",
    options: ["Python", "Hydre", "Chimère"],
    answer: "Python",
    explanation:
        "Python est un serpent géant que Apollon a tué pour établir son oracle à Delphes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le surnom du dieu Thor dans la mythologie nordique ?",
    options: ["Dieu du tonnerre", "Dieu de la guerre", "Dieu de la mort"],
    answer: "Dieu du tonnerre",
    explanation:
        "Thor est connu comme le dieu du tonnerre dans la mythologie nordique à cause de son marteau, Mjolnir.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel oiseau est lié aux légendes de la femme fatale, la harpie ?",
    options: ["Aigle", "Harpie", "Serpent"],
    answer: "Harpie",
    explanation:
        "Les harpies sont des créatures ailées associées à la mythologie grecque qui symbolisent des femmes fatales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Qui est le dieu de la musique et des arts dans la mythologie grecque ?",
    options: ["Apollon", "Hermès", "Dionysos"],
    answer: "Apollon",
    explanation:
        "Apollon est le dieu de la musique, des arts et de la prophétie dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel monstre à tête de lion est célèbre dans la mythologie grecque ?",
    options: ["Sphinx", "Chimère", "Minotaure"],
    answer: "Sphinx",
    explanation:
        "Le Sphinx est un monstre légendaire à tête de femme et corps de lion, célèbre pour ses énigmes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse était l'épouse de Zeus ?",
    options: ["Héra", "Athena", "Déméter"],
    answer: "Héra",
    explanation:
        "Héra, déesse du mariage, est l'épouse de Zeus dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a capturé Cerbère, le chien à trois têtes ?",
    options: ["Hercule", "Achille", "Jason"],
    answer: "Hercule",
    explanation:
        "Hercule a dû capturer Cerbère comme l'un de ses douze travaux dans la mythologie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le symbole de la paix dans la mythologie ?",
    options: ["Colombe", "Serpent", "Chouette"],
    answer: "Colombe",
    explanation:
        "La colombe est traditionnellement associée à la paix dans de nombreuses cultures et mythologies.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros est connu pour avoir obtenu la Toison d'Or ?",
    options: ["Jason", "Thésée", "Hercule"],
    answer: "Jason",
    explanation:
        "Jason est célèbre pour son expédition à la recherche de la Toison d'Or, aidé par les Argonautes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom du fils de Poséidon connu pour ses aventures ?",
    options: ["Thésée", "Persée", "Triton"],
    answer: "Triton",
    explanation:
        "Triton est souvent considéré comme le fils de Poséidon et est le dieu de la mer dans la mythologie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la chasse chez les Romains ?",
    options: ["Diana", "Vénus", "Cérès"],
    answer: "Diana",
    explanation:
        "Diana est la déesse romaine de la chasse, équivalente à Artémis chez les Grecs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le nom de l'élément aquatique associé à Poséidon ?",
    options: ["Océan", "Atlantique", "Mer"],
    answer: "Océan",
    explanation:
        "Poséidon est le dieu des mers et est souvent associé à l'océan dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu est représenté avec un trident ?",
    options: ["Poséidon", "Zeus", "Hercule"],
    answer: "Poséidon",
    explanation:
        "Poséidon est souvent représenté avec un trident, symbole de son pouvoir sur les mers.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le roi des enfers dans la mythologie romaine ?",
    options: ["Hadès", "Pluton", "Cronos"],
    answer: "Pluton",
    explanation:
        "Pluton est le roi des enfers dans la mythologie romaine, équivalent d'Hadès chez les Grecs.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a vaincu la Gorgone ?",
    options: ["Achille", "Perseus", "Hercule"],
    answer: "Perseus",
    explanation:
        "Perseus a tué la Gorgone Méduse pour sauver Andromède dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel emblème est souvent associé à Hermès ?",
    options: ["Ailes", "Serpent", "Sceptre"],
    answer: "Ailes",
    explanation:
        "Hermès est souvent représenté avec des ailes, symbolisant sa fonction de messager des dieux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la mort dans la mythologie égyptienne ?",
    options: ["Isis", "Maât", "Sekhmet"],
    answer: "Maât",
    explanation:
        "Maât est la déesse de la vérité et de l'ordre, souvent associée à la mort dans la mythologie égyptienne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros est connu pour ses voyages dans l'Odyssée ?",
    options: ["Ulysse", "Achille", "Thésée"],
    answer: "Ulysse",
    explanation:
        "Ulysse est le héros principal de l'Odyssée, célèbre pour ses longs voyages et ses aventures.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel animal est souvent associé à Zeus ?",
    options: ["Aigle", "Serpent", "Lion"],
    answer: "Aigle",
    explanation:
        "L'aigle est souvent vu comme l'animal sacré de Zeus, représentant la puissance et la majesté.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est la déesse de la guerre chez les Grecs ?",
    options: ["Athena", "Arès", "Artémis"],
    answer: "Athena",
    explanation:
        "Athena est la déesse de la guerre et de la sagesse dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui a donné naissance au héros Achille ?",
    options: ["Thétis", "Héra", "Gaïa"],
    answer: "Thétis",
    explanation:
        "Thétis est la mère d'Achille, un des héros les plus célèbres de la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel est le fardeau de Sisyphe dans la mythologie ?",
    options: [
      "Faire rouler un rocher",
      "Cultiver un jardin",
      "Gagner une bataille",
    ],
    answer: "Faire rouler un rocher",
    explanation:
        "Sisyphe est condamné à faire rouler un rocher en haut d'une colline, tâche vaine et sans fin.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel dieu est le patron des voleurs et des commerçants ?",
    options: ["Hermès", "Dionysos", "Apollon"],
    answer: "Hermès",
    explanation:
        "Hermès est le dieu des voleurs et des commerçants dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Qui est le roi des dieux dans la mythologie égyptienne ?",
    options: ["Râ", "Osiris", "Horus"],
    answer: "Râ",
    explanation:
        "Râ est considéré comme le roi des dieux et le dieu du soleil dans la mythologie égyptienne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse est souvent représentée avec un miroir ?",
    options: ["Aphrodite", "Isis", "Athena"],
    answer: "Aphrodite",
    explanation:
        "Aphrodite est souvent représentée avec un miroir, symbole de sa beauté et de l'amour.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a été transformé en grenouille par une déesse ?",
    options: ["Orphée", "Hercule", "Pygmalion"],
    answer: "Pygmalion",
    explanation:
        "Pygmalion a été transformé en grenouille par la déesse Aphrodite dans la mythologie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question:
        "Quel est le nom de l'endroit où les âmes des morts vont dans la mythologie grecque ?",
    options: ["Hades", "Tartare", "Elysium"],
    answer: "Hades",
    explanation:
        "Les âmes des morts vont dans l'Hades, le royaume des morts selon la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quel héros a participé à la guerre de Troie ?",
    options: ["Achille", "Ulysse", "Hercule"],
    answer: "Achille",
    explanation:
        "Achille est l'un des héros les plus importants de la guerre de Troie dans la mythologie grecque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Mythologie",
    question: "Quelle déesse est symbolisée par le hibou ?",
    options: ["Athena", "Déméter", "Artémis"],
    answer: "Athena",
    explanation:
        "Le hibou est le symbole d'Athena, déesse de la sagesse dans la mythologie grecque.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizCultureGeneraleMythologie extends StatefulWidget {
  static const String routeName =
      '/gpx_exam/concours/culture_generale_mythologie';
  final String uid;
  final String email;

  const QuizCultureGeneraleMythologie({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizCultureGeneraleMythologie> createState() =>
      _QuizCultureGeneraleMythologieState();
}

class _QuizCultureGeneraleMythologieState
    extends State<QuizCultureGeneraleMythologie>
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
        ? questionCultureMythologie
        : questionCultureMythologie
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
            'module_name': 'Culture générale - Mythologie',
            'quiz_name': 'Quiz culture générale mythologie',
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
      await _sb.from('quiz_culture_generale_mythologie_pages').insert({
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
      debugPrint('❌ quiz_culture_generale_mythologie_pages insert failed: $e');
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
