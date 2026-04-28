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

final List<QuizQuestion> questionSTAD = [
  // ✅ À COLLER DANS questionSTAD (sans réécrire la liste) — SUITE ENORME
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "STAD — Jurisprudence (radiotéléphone)",
    question:
        "Vrai/Faux : un radiotéléphone peut être considéré comme un STAD.",
    options: ["Vrai", "Faux", "Seulement s’il est connecté à Internet"],
    answer: "Vrai",
    explanation:
        "Jurisprudence : le radiotéléphone a été jugé système (CA Paris, 18 nov. 1992).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "STAD — Jurisprudence (annuaire électronique)",
    question:
        "Vrai/Faux : l’annuaire électronique de France Télécom a été jugé STAD.",
    options: ["Vrai", "Faux", "Seulement si payant"],
    answer: "Vrai",
    explanation:
        "Jurisprudence : annuaire électronique FT = système (Tr. corr. Brest, 14 mars 1995).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "Accès frauduleux (323-1) — Piège protection",
    question:
        "Vrai/Faux : il faut un dispositif de protection (mot de passe) pour que l’accès frauduleux existe.",
    options: ["Vrai", "Faux", "Seulement si Internet"],
    answer: "Faux",
    explanation:
        "CA Paris 05/04/1994 : pas nécessaire que l’accès soit limité par un dispositif de protection.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Accès frauduleux (323-1) — Code d’essai (jurisprudence)",
    question:
        "Vrai/Faux : utiliser pendant plus de 2 ans un code remis pour une période d’essai peut constituer 323-1.",
    options: ["Vrai", "Faux", "Seulement si vol du code"],
    answer: "Vrai",
    explanation:
        "Cass. crim., 03 oct. 2007 : usage prolongé d’un code d’essai = accès sans droit.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "Maintien frauduleux (323-1) — Inoffensif",
    question:
        "Vrai/Faux : un maintien « inoffensif » (simple promenade) est incriminable.",
    options: ["Vrai", "Faux", "Seulement si données modifiées"],
    answer: "Vrai",
    explanation:
        "Le cours : maintien inoffensif ou actif = incriminable si sans droit.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "STAD (323-1) — Accès par erreur (piège)",
    question:
        "Vrai/Faux : un accès purement par erreur (sans intention) n’est pas sanctionné.",
    options: ["Vrai", "Faux", "Toujours sanctionné"],
    answer: "Vrai",
    explanation:
        "Le cours : accès par erreur, possible si système non protégé, n’est pas pénalement sanctionné.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: "STAD (323-1) — Mobile indifférent",
    question:
        "Vrai/Faux : agir “par jeu” ou “pour prouver une faille” peut quand même être puni.",
    options: ["Vrai", "Faux", "Jamais si but éthique"],
    answer: "Vrai",
    explanation:
        "Le cours : mobile indifférent (jeu, prouesse, démonstration de faiblesse).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: "STAD (323-1) — Peines simples",
    question: "Peines de base (323-1 al.1) :",
    options: ["3 ans + 100 000 €", "2 ans + 30 000 €", "5 ans + 150 000 €"],
    answer: "3 ans + 100 000 €",
    explanation:
        "Tableau : 323-1 al.1 = 3 ans d’emprisonnement + 100 000 € d’amende.",
    difficulty: "Facile",
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: "STAD (323-1) — Peines al.2",
    question: "Peines 323-1 al.2 :",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "7 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation:
        "Tableau : al.2 = 5 ans d’emprisonnement + 150 000 € d’amende.",
    difficulty: "Facile",
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: "STAD (323-1) — Peines al.3",
    question: "Peines 323-1 al.3 :",
    options: ["7 ans + 300 000 €", "5 ans + 150 000 €", "10 ans + 300 000 €"],
    answer: "7 ans + 300 000 €",
    explanation:
        "Tableau : al.3 = 7 ans d’emprisonnement + 300 000 € d’amende.",
    difficulty: "Facile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "Données (323-3) — Système en cours (piège)",
    question:
        "Vrai/Faux : 323-3 peut s’appliquer même si le système est en cours d’élaboration.",
    options: ["Vrai", "Faux", "Seulement si système finalisé"],
    answer: "Vrai",
    explanation:
        "Le cours : peu importe que le système soit finalisé ou en cours (Cass. crim., 05 janv. 1994).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Données (323-3) — Accès licite ou non (piège)",
    question:
        "Vrai/Faux : l’auteur doit forcément avoir un accès illicite au système pour tomber sous 323-3.",
    options: ["Vrai", "Faux", "Seulement si suppression"],
    answer: "Faux",
    explanation:
        "Le cours : l’auteur peut avoir eu un accès licite ou non ; l’action frauduleuse sur les données suffit.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Données (323-3) — Perturbation",
    question:
        "Vrai/Faux : il faut une perturbation apparente du fonctionnement pour 323-3.",
    options: ["Vrai", "Faux", "Seulement si transmission"],
    answer: "Faux",
    explanation:
        "Le cours : peu importe l’absence de perturbation apparente ou immédiate.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "Données (323-3) — Peines simples",
    question: "Peines de base de 323-3 :",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "7 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation:
        "Tableau : 323-3 = 5 ans d’emprisonnement + 150 000 € d’amende.",
    difficulty: "Facile",
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: "Données (323-3) — Bande organisée",
    question: "Bande organisée (323-4-1) sur 323-3 :",
    options: ["7 ans + 300 000 €", "10 ans + 300 000 €", "5 ans + 150 000 €"],
    answer: "7 ans + 300 000 €",
    explanation:
        "Tableau 323-3 : aggravation bande organisée = 7 ans + 300 000 €.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Données (323-3) — Risque mort (323-4-2)",
    question:
        "Si l’infraction expose autrui à un risque immédiat de mort (323-4-2) :",
    options: ["10 ans + 300 000 €", "7 ans + 300 000 €", "5 ans + 150 000 €"],
    answer: "10 ans + 300 000 €",
    explanation:
        "Tableau : 323-4-2 = 10 ans d’emprisonnement + 300 000 € d’amende.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Données (323-3) — Tentative",
    question: "Tentative pour 323-3 :",
    options: ["Oui (323-7)", "Non", "Seulement si l’auteur est professionnel"],
    answer: "Oui (323-7)",
    explanation:
        "Le cours : tentative spécialement prévue et réprimée par 323-7.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "Outils hacking (323-3-1) — Intention de nuire (piège)",
    question:
        "Vrai/Faux : 323-3-1 exige forcément la volonté directe de nuire.",
    options: ["Vrai", "Faux", "Seulement si virus"],
    answer: "Faux",
    explanation:
        "Le cours : pas forcément volonté directe de nuire ; simple détention peut suffire sans intention de diffusion.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "Outils hacking (323-3-1) — Tentative",
    question: "Tentative pour 323-3-1 :",
    options: ["Oui (323-7)", "Non", "Seulement si bande organisée"],
    answer: "Oui (323-7)",
    explanation:
        "Le cours : tentative spécialement prévue et réprimée par 323-7.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "Association hackers (323-4) — Nombre de personnes (piège)",
    question: "Vrai/Faux : une entente à 2 personnes peut suffire.",
    options: ["Vrai", "Faux", "Minimum 3 personnes"],
    answer: "Vrai",
    explanation:
        "Le cours : entente retenue pour deux personnes (Tr. corr. Limoges, 14 mars 1994).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Association hackers (323-4) — But initial",
    question:
        "Vrai/Faux : le groupement doit avoir été créé dès l’origine pour pirater.",
    options: ["Vrai", "Faux", "Seulement si association déclarée"],
    answer: "Faux",
    explanation:
        "Le cours : pas nécessaire ; une association peut dériver vers délinquance, seuls participants conscients sont visés.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "Association hackers (323-4) — Tentative",
    question: "Tentative pour 323-4 :",
    options: ["Non", "Oui (323-7)", "Oui mais seulement si mineur"],
    answer: "Non",
    explanation: "Le tableau : TENTATIVE : NON pour 323-4.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "Révisions rapides — Article",
    question:
        "L’accès ou le maintien frauduleux dans un STAD est réprimé par :",
    options: ["323-1 CP", "323-3 CP", "323-4 CP"],
    answer: "323-1 CP",
    explanation:
        "323-1 : accès ou maintien frauduleux dans tout ou partie d’un STAD.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Révisions rapides — Article",
    question:
        "L’introduction / extraction / suppression / modification frauduleuse de données est réprimée par :",
    options: ["323-3 CP", "323-1 CP", "323-3-1 CP"],
    answer: "323-3 CP",
    explanation:
        "323-3 : actions frauduleuses portant sur les données contenues dans le système.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Révisions rapides — Article",
    question:
        "La détention/offre/cession/mise à disposition d’outils adaptés au piratage (sans motif légitime) est réprimée par :",
    options: ["323-3-1 CP", "323-4 CP", "323-1 CP"],
    answer: "323-3-1 CP",
    explanation:
        "323-3-1 : moyens conçus/spécialement adaptés pour commettre 323-1 à 323-3.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Révisions rapides — Article",
    question:
        "L’association de malfaiteurs en informatique (entente/groupement) est réprimée par :",
    options: ["323-4 CP", "450-1 CP", "323-7 CP"],
    answer: "323-4 CP",
    explanation:
        "323-4 : participation à une entente/groupement préparant des infractions 323-1 à 323-3-1.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Révisions rapides — Peine (323-1 al.1)",
    question: "Peines 323-1 al.1 (accès/maintien frauduleux simple) :",
    options: ["3 ans + 100 000 €", "5 ans + 150 000 €", "7 ans + 300 000 €"],
    answer: "3 ans + 100 000 €",
    explanation:
        "Tableau : 323-1 al.1 = 3 ans d’emprisonnement + 100 000 € d’amende.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Révisions rapides — Peine (323-1 al.2)",
    question:
        "Peines 323-1 al.2 (si suppression/modification données OU altération fonctionnement) :",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "10 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation: "Tableau : 323-1 al.2 = 5 ans + 150 000 €.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Révisions rapides — Peine (323-1 al.3)",
    question:
        "Peines 323-1 al.3 (STAD à caractère personnel mis en œuvre par l’État) :",
    options: ["7 ans + 300 000 €", "5 ans + 150 000 €", "3 ans + 100 000 €"],
    answer: "7 ans + 300 000 €",
    explanation: "Tableau : 323-1 al.3 = 7 ans + 300 000 €.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Révisions rapides — Peine (323-3)",
    question: "Peines 323-3 (actions frauduleuses sur les données) :",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "7 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation:
        "Tableau : 323-3 = 5 ans d’emprisonnement + 150 000 € d’amende.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Révisions rapides — Peine (323-4-2)",
    question:
        "Lorsque l’infraction expose autrui à un risque immédiat de mort / obstacle aux secours (323-4-2), la peine peut aller à :",
    options: ["10 ans + 300 000 €", "7 ans + 300 000 €", "5 ans + 150 000 €"],
    answer: "10 ans + 300 000 €",
    explanation:
        "Tableau : 323-4-2 = 10 ans d’emprisonnement + 300 000 € d’amende.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "STAD — Vrai/Faux ultra-piège",
    question: "Vrai/Faux : un STAD, c’est uniquement « un site internet ».",
    options: ["Vrai", "Faux", "Seulement s’il y a des données personnelles"],
    answer: "Faux",
    explanation:
        "Le cours : ensemble matériel + logiciel (machine, composants, programmes...).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "STAD — Vrai/Faux (maître du système)",
    question: "Vrai/Faux : le maître du système est forcément son concepteur.",
    options: ["Vrai", "Faux", "Seulement si c’est une PME"],
    answer: "Faux",
    explanation:
        "Le cours : le maître du système peut être celui qui a acquis le droit de l’exploiter.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "Maintien frauduleux — Délit continu",
    question:
        "Vrai/Faux : pour le maintien, la prescription court à partir de la fin du maintien.",
    options: ["Vrai", "Faux", "Seulement si données modifiées"],
    answer: "Vrai",
    explanation:
        "Le cours : maintien = délit continu, prescription à la fin du maintien.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "323-1 — Élément moral (V/F)",
    question:
        "Vrai/Faux : 323-1 exige la conscience d’agir contre le gré du maître du système.",
    options: ["Vrai", "Faux", "Seulement en bande organisée"],
    answer: "Vrai",
    explanation:
        "Le cours : conscience d’accéder ou se maintenir sans droit (contre la volonté du maître).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "323-1 — Mobile (piège)",
    question:
        "Vrai/Faux : si l’auteur agit « pour prouver une faille », il n’y a pas d’infraction.",
    options: ["Vrai", "Faux", "Seulement si aucune donnée n’est vue"],
    answer: "Faux",
    explanation:
        "Le cours : mobile indifférent (jeu, prouesse, démonstration) → peut être poursuivi.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
    category: "323-3-1 — Motif légitime (V/F)",
    question:
        "Vrai/Faux : la recherche en sécurité informatique peut constituer un motif légitime.",
    options: ["Vrai", "Faux", "Jamais"],
    answer: "Vrai",
    explanation:
        "Le cours : motifs légitimes possibles = recherche + sécurisation des SI/réseaux.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "323-3-1 — Intention de nuire (V/F)",
    question: "Vrai/Faux : 323-3-1 exige une intention directe de nuire.",
    options: ["Vrai", "Faux", "Seulement en bande organisée"],
    answer: "Faux",
    explanation:
        "Le cours : la simple détention peut être réprimée même sans intention initiale de diffuser/contaminer.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
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
  QuizQuestion(
    category: "323-4 — Piège effectif",
    question:
        "Vrai/Faux : on peut être poursuivi 323-4 même si aucun piratage n’a finalement eu lieu.",
    options: ["Vrai", "Faux", "Seulement si un mineur participe"],
    answer: "Vrai",
    explanation:
        "Le cours : 323-4 vise la préparation caractérisée par faits matériels, en amont.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "323-4 — Piège connaissance totale",
    question:
        "Vrai/Faux : chaque membre doit connaître toutes les activités de l’entente pour être condamné.",
    options: ["Vrai", "Faux", "Seulement le chef"],
    answer: "Faux",
    explanation:
        "Le cours : pas nécessaire que chaque membre connaisse toutes les activités (CA Aix, 02/06/1993).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "Mini-cas — Qualification (323-3-1)",
    question:
        "Une personne vend un programme conçu spécialement pour casser des accès, sans motif légitime :",
    options: ["323-3-1", "323-1", "323-4"],
    answer: "323-3-1",
    explanation:
        "323-3-1 vise l’offre/cession/mise à disposition d’outils adaptés, sans motif légitime.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Mini-cas — Qualification (323-4)",
    question:
        "Deux personnes échangent des codes et scripts pour préparer des intrusions futures :",
    options: ["323-4", "323-1 seulement", "323-3 seulement"],
    answer: "323-4",
    explanation:
        "Entente + faits matériels préparatoires = 323-4 même si l’infraction finale n’a pas eu lieu.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
    category: "323-1 — Tentative (V/F)",
    question:
        "Vrai/Faux : la tentative d’accès/maintien frauduleux est punissable (323-7).",
    options: ["Vrai", "Faux", "Seulement si l’État est visé"],
    answer: "Vrai",
    explanation: "Le cours : tentative spécialement prévue par 323-7.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "323-3 — Tentative (V/F)",
    question: "Vrai/Faux : la tentative de 323-3 est punissable (323-7).",
    options: ["Vrai", "Faux", "Seulement si bande organisée"],
    answer: "Vrai",
    explanation:
        "Le cours : tentative prévue par 323-7 pour les délits du chapitre.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "323-1 — Complicité (V/F)",
    question:
        "Vrai/Faux : la complicité est possible pour 323-1 via 121-7 (aide/assistance, provocation, instructions).",
    options: ["Vrai", "Faux", "Seulement si le complice touche de l’argent"],
    answer: "Vrai",
    explanation: "Le cours : complicité applicable conformément à 121-7.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "323-3 — Complicité (V/F)",
    question: "Vrai/Faux : la complicité est possible pour 323-3 via 121-7.",
    options: ["Vrai", "Faux", "Jamais"],
    answer: "Vrai",
    explanation:
        "Le cours : complicité applicable (aide/assistance, provocation, instructions).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "STAD — Jurisprudence (piège)",
    question:
        "Vrai/Faux : un radiotéléphone a déjà été jugé comme étant un STAD.",
    options: ["Vrai", "Faux", "Seulement s’il a un navigateur web"],
    answer: "Vrai",
    explanation:
        "Le cours cite : radiotéléphone = système (CA Paris, 18/11/1992).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "STAD — Jurisprudence (piège)",
    question:
        "Vrai/Faux : l’annuaire électronique de France Télécom a déjà été jugé comme étant un STAD.",
    options: ["Vrai", "Faux", "Seulement si l’accès est payant"],
    answer: "Vrai",
    explanation:
        "Le cours cite : annuaire électronique FT = système (Tr. corr. Brest, 14/03/1995).",
    difficulty: "Difficile",
  ),

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
    category: "Cas pratique concours — Qualification + peine",
    question:
        "Un individu accède sans droit à un STAD et modifie des données (323-1 al.2) : peine encourue ?",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "7 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation:
        "323-1 al.2 : suppression/modification données ou altération fonctionnement.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Cas pratique concours — Qualification + peine",
    question:
        "Accès frauduleux contre un STAD à caractère personnel mis en œuvre par l’État : peine ?",
    options: ["7 ans + 300 000 €", "5 ans + 150 000 €", "10 ans + 300 000 €"],
    answer: "7 ans + 300 000 €",
    explanation:
        "323-1 al.3 : aggravation spéciale État (données personnelles).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Cas pratique concours — Qualification + peine",
    question: "Introduction frauduleuse de données (323-3) : peine de base ?",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "7 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation: "Tableau : 323-3 = 5 ans + 150 000 €.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
    category: "Vrai/Faux — Pacte inutile",
    question:
        "Vrai/Faux : Pour 323-1, il faut obligatoirement un dommage pour que l’infraction existe.",
    options: ["Vrai", "Faux", "Seulement si données personnelles"],
    answer: "Faux",
    explanation:
        "323-1 al.1 existe sans dommage ; le dommage est une aggravation (al.2/3).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Vrai/Faux — Promenade",
    question:
        "Vrai/Faux : un maintien « inoffensif » peut être réprimé s’il est sans droit.",
    options: ["Vrai", "Faux", "Seulement si l’auteur est informaticien"],
    answer: "Vrai",
    explanation: "Le cours : maintien inoffensif ou actif est incriminable.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
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
  QuizQuestion(
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

  QuizQuestion(
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
  QuizQuestion(
    category: "Mix concours — Choisis la bonne qualification",
    question:
        "On ne touche pas aux données, mais on reste connecté sans droit pour « explorer » :",
    options: ["323-1 (maintien)", "323-3", "323-3-1"],
    answer: "323-1 (maintien)",
    explanation:
        "Le maintien sans droit est incriminé même « inoffensif » (simple promenade).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Mix concours — Choisis la bonne qualification",
    question:
        "On met à disposition un outil adapté au piratage, sans motif légitime, mais aucun piratage n’a encore eu lieu :",
    options: ["323-3-1", "323-1", "323-3"],
    answer: "323-3-1",
    explanation:
        "323-3-1 sanctionne la simple fourniture/détention/offre d’outils adaptés, sans besoin d’infraction consommée.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Mix concours — Choisis la bonne qualification",
    question:
        "On s’organise à plusieurs, échanges de codes + méthodes, préparation matérialisée, sans passage à l’acte :",
    options: ["323-4", "323-1", "323-3-1"],
    answer: "323-4",
    explanation:
        "323-4 : entente/groupement + préparation caractérisée par faits matériels.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Révisions rapides — Peine (323-3 aggravé État)",
    question:
        "Peines pour 323-3 lorsqu’il est commis contre un STAD à caractère personnel mis en œuvre par l’État :",
    options: ["7 ans + 300 000 €", "5 ans + 150 000 €", "10 ans + 300 000 €"],
    answer: "7 ans + 300 000 €",
    explanation:
        "Le cours : aggravation « État / caractère personnel » = 7 ans + 300 000 € (tableau).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Révisions rapides — Peine (323-3 bande organisée)",
    question:
        "Peines (max) quand l’infraction est commise en bande organisée :",
    options: ["7 ans + 300 000 €", "5 ans + 150 000 €", "3 ans + 100 000 €"],
    answer: "7 ans + 300 000 €",
    explanation:
        "Le cours mentionne l’aggravation bande organisée (323-4-1) : 7 ans + 300 000 €.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "STAD — Inclusion (V/F)",
    question:
        "Vrai/Faux : un STAD inclut aussi les programmes/logiciels assurant son fonctionnement.",
    options: ["Vrai", "Faux", "Uniquement les serveurs"],
    answer: "Vrai",
    explanation:
        "Le cours : le système = machine + composants + programmes/logiciels.",
    difficulty: "Facile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "323-1 — Protection (ultra piège)",
    question:
        "Vrai/Faux : si un système n’a aucun mot de passe, l’accès frauduleux est impossible à retenir.",
    options: ["Vrai", "Faux", "Seulement si c’est un site public"],
    answer: "Faux",
    explanation:
        "Le cours : pas nécessaire que l’accès soit limité par un dispositif de protection.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: "323-1 — Accès par personne interposée (piège)",
    question:
        "Vrai/Faux : utiliser l’identifiant d’un tiers (même obtenu « gentiment ») peut caractériser un accès sans droit.",
    options: ["Vrai", "Faux", "Seulement si volé"],
    answer: "Vrai",
    explanation:
        "L’accès sans droit vise aussi se faire passer pour une personne autorisée / forcer les codes.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "323-1 — Maintien inoffensif (V/F)",
    question:
        "Vrai/Faux : un maintien « promenade » sans dommage peut être sanctionné.",
    options: ["Vrai", "Faux", "Seulement si l’auteur est informaticien"],
    answer: "Vrai",
    explanation: "Le cours : maintien inoffensif ou actif est incriminable.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "323-4-1 — Bande organisée (V/F)",
    question:
        "Vrai/Faux : la bande organisée est une circonstance aggravante autonome des infractions STAD.",
    options: ["Vrai", "Faux", "Uniquement pour 323-4"],
    answer: "Vrai",
    explanation:
        "Le cours : 323-4-1 prévoit l’aggravation lorsque l’infraction est commise en bande organisée.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: "323-3 — Portée (piège)",
    question:
        "Vrai/Faux : pour 323-3, il faut un trouble visible du fonctionnement du système.",
    options: ["Vrai", "Faux", "Seulement si État visé"],
    answer: "Faux",
    explanation:
        "Le cours : l’action peut être sanctionnée même sans perturbation apparente/immediate.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "323-3 — Accès licite (ultra piège)",
    question:
        "Vrai/Faux : l’auteur doit forcément avoir un accès frauduleux au système pour être poursuivi 323-3.",
    options: ["Vrai", "Faux", "Seulement si données personnelles"],
    answer: "Faux",
    explanation:
        "Le cours : l’auteur peut avoir eu un accès licite ou non ; l’action frauduleuse porte sur les données.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "323-3-1 — Lien avec infraction consommée (piège)",
    question:
        "Vrai/Faux : 323-3-1 exige que l’infraction STAD (323-1 à 323-3) ait déjà été commise.",
    options: ["Vrai", "Faux", "Seulement pour la détention"],
    answer: "Faux",
    explanation:
        "Le cours : incrimination peut sanctionner la simple détention/mise à disposition sans infraction commise révélée.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "323-4 — Groupement/entente (piège)",
    question:
        "Vrai/Faux : l’entente peut être retenue même si le groupement ne comporte que deux personnes.",
    options: ["Vrai", "Faux", "Minimum 3"],
    answer: "Vrai",
    explanation:
        "Le cours : entente retenue pour deux personnes (exemple jurisprudentiel cité).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "323-4 — Objet (piège)",
    question: "Les infractions préparées visées par 323-4 peuvent être :",
    options: ["323-1 à 323-3-1", "Uniquement 323-1", "Uniquement 323-3"],
    answer: "323-1 à 323-3-1",
    explanation: "Le cours : infractions visées = 323-1 à 323-3-1.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "Flash V/F — 323-1",
    question:
        "Vrai/Faux : l’accès peut être réprimé même si la personne n’a pas « forcé » un mot de passe.",
    options: ["Vrai", "Faux", "Seulement si mineur"],
    answer: "Vrai",
    explanation:
        "Le cours : pas nécessaire de dispositif de protection ; ce qui compte = sans droit.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Flash V/F — 323-1",
    question:
        "Vrai/Faux : le maintien est incriminable même s’il est « sans préjudice ».",
    options: ["Vrai", "Faux", "Seulement si données modifiées"],
    answer: "Vrai",
    explanation:
        "Le cours : maintien inoffensif (« promenade ») = incriminable.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Flash V/F — 323-3",
    question:
        "Vrai/Faux : 323-3 peut viser la simple copie (extraction) sans suppression.",
    options: ["Vrai", "Faux", "Seulement si diffusion"],
    answer: "Vrai",
    explanation:
        "Le cours : extraction protège les données même si elles restent disponibles au propriétaire.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Flash V/F — 323-3-1",
    question:
        "Vrai/Faux : la simple détention d’un outil adapté peut suffire (sans intention de nuire).",
    options: ["Vrai", "Faux", "Seulement si déjà utilisé"],
    answer: "Vrai",
    explanation:
        "Le cours : pas forcément volonté directe de nuire ; détention réprimée.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Flash V/F — 323-4",
    question:
        "Vrai/Faux : 323-4 exige que l’infraction finale (piratage) soit commise.",
    options: ["Vrai", "Faux", "Seulement si bande organisée"],
    answer: "Faux",
    explanation:
        "Le cours : vise la préparation caractérisée par faits matériels, en amont.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Révisions rapides — Peine (323-1 simple)",
    question:
        "Peine encourue pour l’accès/maintien frauduleux simple (323-1 al.1) :",
    options: ["3 ans + 100 000 €", "5 ans + 150 000 €", "7 ans + 300 000 €"],
    answer: "3 ans + 100 000 €",
    explanation:
        "Tableau : 323-1 al.1 = 3 ans d’emprisonnement + 100 000 € d’amende.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Révisions rapides — Peine (323-1 al.2)",
    question:
        "Peine encourue si suppression/modification de données OU altération du fonctionnement (323-1 al.2) :",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "10 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation: "Tableau : aggravation 323-1 al.2 = 5 ans + 150 000 €.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Révisions rapides — Peine (323-1 al.3)",
    question:
        "Peine encourue si STAD à caractère personnel mis en œuvre par l’État (323-1 al.3) :",
    options: ["7 ans + 300 000 €", "5 ans + 150 000 €", "3 ans + 100 000 €"],
    answer: "7 ans + 300 000 €",
    explanation: "Tableau : 323-1 al.3 = 7 ans + 300 000 €.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Révisions rapides — Peine (323-3)",
    question:
        "Peine de base pour introduction/extraction/détention/reproduction/transmission/suppression/modification frauduleuse (323-3) :",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "7 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation:
        "Tableau : 323-3 = 5 ans d’emprisonnement + 150 000 € d’amende.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "323-1 — Mobile (V/F)",
    question:
        "Vrai/Faux : agir « par jeu » exclut l’infraction d’accès frauduleux.",
    options: ["Vrai", "Faux", "Seulement si mineur"],
    answer: "Faux",
    explanation:
        "Le cours : le mobile est indifférent (jeu, prouesse, démonstration).",
    difficulty: "Facile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "323-3 — Champ (piège « système en cours »)",
    question:
        "Vrai/Faux : 323-3 peut s’appliquer même si le système est en cours d’élaboration.",
    options: ["Vrai", "Faux", "Seulement si finalisé"],
    answer: "Vrai",
    explanation:
        "Le cours : peu importe que le système soit finalisé ou en cours d’élaboration.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "323-3 — Accès licite (V/F)",
    question: "Vrai/Faux : 323-3 exige un accès frauduleux préalable (323-1).",
    options: ["Vrai", "Faux", "Seulement si extraction"],
    answer: "Faux",
    explanation: "Le cours : l’auteur peut avoir eu un accès licite ou non.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "323-3 — « cracking » (culture concours)",
    question:
        "Dans le cours, l’action sur les données (323-3) est souvent appelée :",
    options: ["Cracking", "Phishing", "Spoofing"],
    answer: "Cracking",
    explanation:
        "Le cours : cette forme de piratage est souvent appelée « cracking ».",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "323-3 — Aggravation État (peine)",
    question:
        "323-3 commis contre un STAD à caractère personnel mis en œuvre par l’État :",
    options: ["7 ans + 300 000 €", "5 ans + 150 000 €", "10 ans + 300 000 €"],
    answer: "7 ans + 300 000 €",
    explanation: "Tableau : aggravation État = 7 ans + 300 000 €.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "323-3-1 — Motif légitime (V/F)",
    question:
        "Vrai/Faux : la recherche en sécurité informatique peut constituer un motif légitime.",
    options: ["Vrai", "Faux", "Jamais"],
    answer: "Vrai",
    explanation:
        "Le cours cite explicitement recherche/sécurité informatique parmi les motifs possibles.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "323-3-1 — Absence d’intention (piège)",
    question:
        "Vrai/Faux : l’absence d’intention de diffuser un virus exclut 323-3-1.",
    options: ["Vrai", "Faux", "Seulement si mineur"],
    answer: "Faux",
    explanation:
        "Le cours : la simple détention peut suffire, même sans volonté directe de nuire.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "Flash V/F — STAD",
    question: "Vrai/Faux : un radiotéléphone a déjà été jugé comme un STAD.",
    options: ["Vrai", "Faux", "Seulement si connecté à Internet"],
    answer: "Vrai",
    explanation: "Le cours cite : radiotéléphone = système (jurisprudence).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Flash V/F — STAD",
    question: "Vrai/Faux : un annuaire électronique peut constituer un STAD.",
    options: ["Vrai", "Faux", "Uniquement un site web moderne"],
    answer: "Vrai",
    explanation:
        "Le cours cite : annuaire électronique France Télécom = système.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Flash V/F — 323-1",
    question:
        "Vrai/Faux : l’infraction nécessite forcément un dispositif de protection (mot de passe).",
    options: ["Vrai", "Faux", "Seulement si données sensibles"],
    answer: "Faux",
    explanation:
        "Le cours : pas nécessaire qu’il y ait un dispositif de protection.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Flash V/F — 323-1",
    question:
        "Vrai/Faux : l’accès sans droit peut résulter du non-respect d’une procédure (code/paiement).",
    options: ["Vrai", "Faux", "Seulement si contrat signé"],
    answer: "Vrai",
    explanation:
        "Le cours : absence de droit = non-respect procédure imposée par le maître du système.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Flash V/F — 323-3",
    question:
        "Vrai/Faux : la manipulation de données sur support externe (clé USB) tombe automatiquement sous 323-3.",
    options: ["Vrai", "Faux", "Toujours"],
    answer: "Faux",
    explanation:
        "Le cours : action sur données sorties du système pas visée, sauf réintroduction.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "323-1 — Jurisprudence (V/F)",
    question:
        "Vrai/Faux : un terminal de paiement peut être une partie intégrante d’un STAD.",
    options: ["Vrai", "Faux", "Seulement s’il est piraté"],
    answer: "Vrai",
    explanation:
        "Le cours : terminal de paiement fait partie du système carte bleue car il traite des données.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "323-1 — Peine (al.2)",
    question: "Peine encourue pour 323-1 al.2 :",
    options: ["5 ans + 150 000 €", "3 ans + 100 000 €", "7 ans + 300 000 €"],
    answer: "5 ans + 150 000 €",
    explanation:
        "Tableau : 323-1 al.2 = 5 ans d’emprisonnement + 150 000 € d’amende.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: "323-1 — Peine (al.3)",
    question: "Peine encourue pour 323-1 al.3 :",
    options: ["7 ans + 300 000 €", "5 ans + 150 000 €", "10 ans + 300 000 €"],
    answer: "7 ans + 300 000 €",
    explanation:
        "Tableau : 323-1 al.3 = 7 ans d’emprisonnement + 300 000 € d’amende.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "323-4-1 — Bande organisée (piège)",
    question:
        "Lorsque l’infraction est commise en bande organisée (323-4-1), la peine peut aller jusqu’à :",
    options: ["10 ans + 300 000 €", "7 ans + 300 000 €", "5 ans + 150 000 €"],
    answer: "10 ans + 300 000 €",
    explanation:
        "Tableau : 323-4-1 = 10 ans d’emprisonnement + 300 000 € d’amende.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "323-3-1 — Élément moral (piège concours)",
    question: "323-3-1 exige forcément une intention directe de nuire :",
    options: ["Faux", "Vrai", "Seulement si virus"],
    answer: "Faux",
    explanation:
        "Le cours : la simple détention peut être réprimée même sans intention de diffuser/contaminer.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "323-4 — Nombre de participants (piège)",
    question: "Le nombre de participants requis pour une « entente » :",
    options: ["Peut être 2", "Minimum 5", "Minimum 3"],
    answer: "Peut être 2",
    explanation: "Le cours : entente retenue pour deux personnes (exemple).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "QCM piège — Bonne qualification",
    question:
        "Quel texte vise spécifiquement la fourniture/détention d’outils conçus pour attaquer un STAD ?",
    options: ["323-3-1", "323-1", "323-3"],
    answer: "323-3-1",
    explanation:
        "323-3-1 : moyens adaptés (programme, instrument, donnée) sans motif légitime.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "QCM piège — Bonne qualification",
    question:
        "Quel texte vise l’action directe sur les données (copie, suppression, modification) ?",
    options: ["323-3", "323-1", "323-4"],
    answer: "323-3",
    explanation:
        "323-3 : actions frauduleuses sur les données contenues dans le système.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "QCM piège — Bonne qualification",
    question:
        "Quel texte vise l’accès sans droit, même sans toucher aux données ?",
    options: ["323-1", "323-3", "323-3-1"],
    answer: "323-1",
    explanation: "323-1 : accès/maintien frauduleux, même « promenade ». ",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: "Flash V/F — 323-1",
    question:
        "Vrai/Faux : l’accès peut être frauduleux même si le système n’a aucun mot de passe.",
    options: ["Vrai", "Faux", "Seulement si l’État"],
    answer: "Vrai",
    explanation:
        "Le cours : pas nécessaire d’un dispositif de protection ; volonté du maître suffit.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Flash V/F — 323-3",
    question:
        "Vrai/Faux : modifier des données enregistrées définitivement dans un système peut relever de 323-3.",
    options: ["Vrai", "Faux", "Seulement si elles sont publiques"],
    answer: "Vrai",
    explanation:
        "Le cours cite la modification de données comptables enregistrées définitivement.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Flash V/F — 323-3-1",
    question:
        "Vrai/Faux : l’absence de liste précise des « motifs légitimes » laisse l’appréciation aux magistrats.",
    options: ["Vrai", "Faux", "Motifs fixés uniquement par décret"],
    answer: "Vrai",
    explanation:
        "Le cours : notion imprécise → appréciation par les magistrats.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Flash V/F — 323-4",
    question:
        "Vrai/Faux : un groupement initialement légal peut tomber sous 323-4 s’il dérive vers la délinquance informatique.",
    options: ["Vrai", "Faux", "Jamais"],
    answer: "Vrai",
    explanation:
        "Le cours : association déclarée qui dérive → seuls ceux qui continuent à participer sont visés.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizStad extends StatefulWidget {
  static const String routeName = '/gpx/crimes_biens/quiz/stad';
  final String uid;
  final String email;

  const QuizStad({super.key, required this.uid, required this.email});

  @override
  State<QuizStad> createState() => _QuizStadState();
}

class _QuizStadState extends State<QuizStad> with TickerProviderStateMixin {
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
        ? questionSTAD
        : questionSTAD
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
            'module_name': 'Crimes & délits contre les biens',
            'quiz_name': 'Atteintes aux STAD',
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
      await _sb.from('quiz_stad').insert({
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
      debugPrint('❌ quiz_stad insert failed: $e');
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
