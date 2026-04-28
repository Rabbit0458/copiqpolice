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

final List<QuizQuestion> questionGPCirconstancesAggravantes = [
  //////////////////////////////////////////////////////////////////////////////
  // AUTEUR IVRE OU SOUS L’EMPRISE DE STUPÉFIANTS
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ivre ou sous l’emprise de stupéfiants',
    question:
        'La circonstance aggravante “par une personne agissant en état d’ivresse manifeste ou sous l’emprise manifeste de produits stupéfiants” est :',
    options: [
      'Une circonstance aggravante personnelle',
      'Une circonstance aggravante réelle',
      'Une cause légale d’exemption de peine',
    ],
    answer: 'Une circonstance aggravante réelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante réelle dont les effets s’étendent à tous les auteurs, coauteurs et complices.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // LA PRÉMÉDITATION (art. 132-72 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation est définie comme :',
    options: [
      'Le fait d’agir sous le coup d’une pulsion',
      'Le dessein formé avant l’action de commettre un crime ou un délit déterminé',
      'Le fait d’agir en groupe, sans préparation',
    ],
    answer:
        'Le dessein formé avant l’action de commettre un crime ou un délit déterminé',
    explanation:
        'Le cours reprend la définition légale : la préméditation est un dessein formé avant l’action.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation est définie par :',
    options: [
      'L’article 132-72 du code pénal',
      'L’article 132-80 du code pénal',
      'L’article 132-75 du code pénal',
    ],
    answer: 'L’article 132-72 du code pénal',
    explanation:
        'Le cours indique que l’article 132-72 du code pénal définit la préméditation.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Selon le cours, la préméditation traduit principalement :',
    options: [
      'Une volonté mûre et réfléchie d’atteindre un but fixé',
      'Une réaction immédiate et spontanée',
      'Une absence de résolution d’agir',
    ],
    answer: 'Une volonté mûre et réfléchie d’atteindre un but fixé',
    explanation:
        'Le cours parle d’une résolution d’agir marquant une volonté mûre et réfléchie.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question:
        'Pour matérialiser la préméditation, il faut notamment une antériorité de la résolution :',
    options: [
      'Après l’acte',
      'Avant l’acte',
      'Uniquement au moment du jugement',
    ],
    answer: 'Avant l’acte',
    explanation:
        'Le cours précise que l’antériorité à l’acte est nécessaire pour matérialiser la préméditation (Cass. crim., 9 janv. 1990).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'L’intervalle de temps lié à la préméditation se situe entre :',
    options: [
      'La plainte et le jugement',
      'La résolution de commettre l’acte et son exécution',
      'La commission des faits et l’enquête',
    ],
    answer: 'La résolution de commettre l’acte et son exécution',
    explanation:
        'Le cours situe l’intervalle entre la décision de commettre l’acte et son exécution.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Un acte prémédité est un acte :',
    options: [
      'Spontané, pouvant faire suite à une pulsion',
      'Médité et préparé, donc non spontané',
      'Imprévisible et sans plan',
    ],
    answer: 'Médité et préparé, donc non spontané',
    explanation:
        'Le cours indique que l’acte prémédité est médité et préparé et ne peut pas faire suite à une pulsion.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Selon le cours, la préméditation vise indifféremment :',
    options: [
      'Uniquement les crimes consommés',
      'Une infraction commise ou tentée',
      'Uniquement les délits',
    ],
    answer: 'Une infraction commise ou tentée',
    explanation:
        'Le cours précise que cette circonstance vise indifféremment une infraction commise ou tentée.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question:
        'D’après la jurisprudence citée, la préméditation doit être recherchée :',
    options: [
      'Uniquement dans les aveux de l’auteur',
      'Dans les faits qui ont accompagné l’acte de l’auteur principal',
      'Uniquement dans le passé judiciaire de l’auteur',
    ],
    answer: 'Dans les faits qui ont accompagné l’acte de l’auteur principal',
    explanation:
        'Le cours cite : “Elle doit être recherchée dans les faits qui ont accompagné l’acte de l’auteur principal” (Cass. crim., 4 sept. 1976).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question:
        'Parmi les éléments suivants, lequel peut illustrer la préméditation selon le cours ?',
    options: [
      'Des actes préparatoires ou des menaces avant les faits',
      'Une simple émotion ressentie après les faits',
      'Une erreur de procédure',
    ],
    answer: 'Des actes préparatoires ou des menaces avant les faits',
    explanation:
        'Le cours donne des exemples : actes préparatoires, menaces, confidences, nature complexe de l’acte, etc.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question:
        'Dans le champ d’application, le meurtre commis avec préméditation est qualifié :',
    options: [
      'D’homicide involontaire',
      'D’assassinat',
      'De violences volontaires simples',
    ],
    answer: 'D’assassinat',
    explanation:
        'Le cours précise que le meurtre avec préméditation (art. 221-3 al. 1 C.P.) est qualifié d’assassinat.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ DE CONJOINT / CONCUBIN / PARTENAIRE PACS (art. 132-80 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question:
        'La circonstance aggravante liée à la qualité de conjoint/concubin/partenaire PACS est définie par :',
    options: [
      'L’article 132-80 du code pénal',
      'L’article 132-72 du code pénal',
      'L’article 132-79 du code pénal',
    ],
    answer: 'L’article 132-80 du code pénal',
    explanation:
        'Le cours indique que l’article 132-80 du code pénal définit cette circonstance.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question: 'Cette circonstance aggravante est, selon le cours :',
    options: [
      'Réelle (elle s’étend à tous)',
      'Personnelle (elle ne s’étend pas aux coauteurs)',
      'Mixte et toujours étendue aux complices',
    ],
    answer: 'Personnelle (elle ne s’étend pas aux coauteurs)',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante personnelle dont les effets ne s’étendent pas aux coauteurs.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question:
        'Le but de cette circonstance aggravante est principalement de réprimer plus sévèrement :',
    options: [
      'Les infractions commises au sein du couple (“infractions conjugales”)',
      'Les infractions commises en bande organisée',
      'Les infractions commises sur internet',
    ],
    answer:
        'Les infractions commises au sein du couple (“infractions conjugales”)',
    explanation:
        'Le cours indique que cette circonstance vise à réprimer plus sévèrement les infractions commises au sein du couple.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question:
        'Cette circonstance peut être retenue même si l’auteur et la victime :',
    options: [
      'Ne cohabitent pas',
      'Sont inconnus l’un de l’autre',
      'Ont uniquement un lien professionnel',
    ],
    answer: 'Ne cohabitent pas',
    explanation:
        'Le texte vise expressément la circonstance “y compris lorsqu’ils ne cohabitent pas”.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question:
        'La circonstance est également constituée lorsque les faits sont commis par :',
    options: [
      'Un ancien conjoint / ancien concubin / ancien partenaire PACS',
      'Un voisin',
      'Un témoin',
    ],
    answer: 'Un ancien conjoint / ancien concubin / ancien partenaire PACS',
    explanation:
        'Le cours reprend le second alinéa : elle vaut aussi pour l’ancien conjoint/concubin/partenaire PACS.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question:
        'Lorsque le lien est rompu, la circonstance n’est retenue que si l’infraction est commise :',
    options: [
      'En raison des relations ayant existé entre l’auteur et la victime',
      'Quel que soit le motif, automatiquement',
      'Uniquement si la victime porte plainte immédiatement',
    ],
    answer: 'En raison des relations ayant existé entre l’auteur et la victime',
    explanation:
        'Le cours précise que, pour l’ancien conjoint/concubin/partenaire, il faut que l’infraction soit commise en raison des relations passées : c’est le mobile.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question: 'La définition du concubinage (art. 515-8 C. civ.) renvoie à :',
    options: [
      'Une union de fait avec vie commune stable et continue',
      'Un contrat signé en mairie',
      'Une simple relation ponctuelle',
    ],
    answer: 'Une union de fait avec vie commune stable et continue',
    explanation:
        'Le cours cite l’art. 515-8 du code civil : union de fait, vie commune, stabilité et continuité.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question:
        'Selon le cours, l’existence d’un concubinage est établie dès lors qu’il est prouvé :',
    options: [
      'Qu’il y a communauté de vie',
      'Qu’il y a un compte bancaire commun',
      'Qu’il y a un enfant commun',
    ],
    answer: 'Qu’il y a communauté de vie',
    explanation:
        'Le cours indique que l’état de concubinage est établi dès lors qu’il est prouvé qu’il y a communauté de vie.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Conjoint / concubin / partenaire PACS',
    question: 'Le pacte civil de solidarité (art. 515-1 C. civ.) est :',
    options: [
      'Un contrat conclu par deux personnes majeures pour organiser leur vie commune',
      'Une simple promesse verbale',
      'Une obligation réservée aux couples mariés',
    ],
    answer:
        'Un contrat conclu par deux personnes majeures pour organiser leur vie commune',
    explanation:
        'Le cours cite l’art. 515-1 du code civil : un contrat conclu par deux personnes physiques majeures pour organiser leur vie commune.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // CARACTÈRE HOMOPHOBE / SEXISTE / TRANSPHOBE (art. 132-77 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe / sexiste / transphobe',
    question:
        'Le caractère homophobe ou sexiste d’une infraction est défini par :',
    options: [
      'L’article 132-77 du code pénal',
      'L’article 132-76 du code pénal',
      'L’article 132-80 du code pénal',
    ],
    answer: 'L’article 132-77 du code pénal',
    explanation:
        'Le cours indique que l’article 132-77 du code pénal définit le caractère homophobe ou sexiste.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe / sexiste / transphobe',
    question: 'Cette circonstance aggravante est, selon le cours :',
    options: ['Personnelle', 'Réelle', 'Toujours mixte'],
    answer: 'Réelle',
    explanation:
        'Le cours précise que cette circonstance est réelle et s’étend à tous les auteurs, coauteurs et complices.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe / sexiste / transphobe',
    question:
        'La circonstance est constituée si le crime/délit est précédé, accompagné ou suivi de :',
    options: [
      'Propos, écrits, images, objets ou actes de toute nature',
      'Uniquement une plainte de la victime',
      'Uniquement un casier judiciaire chargé',
    ],
    answer: 'Propos, écrits, images, objets ou actes de toute nature',
    explanation:
        'Le cours énumère ces éléments comme modes de matérialisation du mobile.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe / sexiste / transphobe',
    question: 'Cette circonstance vise notamment les personnes :',
    options: [
      'Homosexuelles, mais aussi transsexuelles/transgenres/travesties',
      'Uniquement homosexuelles',
      'Uniquement hétérosexuelles',
    ],
    answer: 'Homosexuelles, mais aussi transsexuelles/transgenres/travesties',
    explanation:
        'Le cours précise que la circonstance vise aussi les personnes transsexuelles, transgenres ou travesties.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe / sexiste / transphobe',
    question:
        'La circonstance peut être retenue même si la victime n’est pas réellement concernée, dès lors que l’auteur :',
    options: [
      'Croyait que la victime l’était (orientation/identité vraie ou supposée)',
      'A agi par erreur de droit',
      'A agi uniquement pour un motif financier',
    ],
    answer:
        'Croyait que la victime l’était (orientation/identité vraie ou supposée)',
    explanation:
        'Le cours indique que l’aggravation peut jouer si l’auteur croyait la victime homosexuelle/transgenre/transsexuelle alors qu’elle ne l’était pas.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // CARACTÈRE RACISTE / XÉNOPHOBE / ANTISÉMITE (art. 132-76 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question: 'Le caractère raciste d’une infraction est défini par :',
    options: [
      'L’article 132-76 du code pénal',
      'L’article 132-77 du code pénal',
      'L’article 132-75 du code pénal',
    ],
    answer: 'L’article 132-76 du code pénal',
    explanation:
        'Le cours indique que l’article 132-76 du code pénal définit le caractère raciste.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question: 'Selon le cours, cette circonstance aggravante est :',
    options: [
      'Réelle et s’étend à tous les auteurs, coauteurs et complices',
      'Personnelle et ne vise que l’auteur',
      'Applicable uniquement aux contraventions',
    ],
    answer: 'Réelle et s’étend à tous les auteurs, coauteurs et complices',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante réelle.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question:
        'Le crime ou délit est aggravé notamment s’il est précédé, accompagné ou suivi de :',
    options: [
      'Propos, écrits, images, objets ou actes de toute nature',
      'Une médiation pénale',
      'Un témoignage anonyme uniquement',
    ],
    answer: 'Propos, écrits, images, objets ou actes de toute nature',
    explanation:
        'Le cours reprend cette liste d’éléments objectifs permettant de caractériser l’aggravation.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question:
        'L’article 132-76 vise notamment l’appartenance (vraie ou supposée) à :',
    options: [
      'Une prétendue race, une ethnie, une nation ou une religion déterminée',
      'Un parti politique',
      'Une catégorie professionnelle',
    ],
    answer:
        'Une prétendue race, une ethnie, une nation ou une religion déterminée',
    explanation:
        'Le cours liste ces quatre catégories (prétendue race, ethnie, nation, religion).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question:
        'Peu importe que l’appartenance soit vraie : la circonstance peut jouer si elle est :',
    options: [
      'Vraie ou supposée',
      'Uniquement prouvée par un acte d’état civil',
      'Uniquement reconnue par la victime',
    ],
    answer: 'Vraie ou supposée',
    explanation:
        'Le cours précise que l’auteur peut agir à tort : l’appartenance/non-appartenance peut être vraie ou supposée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question:
        'Dans l’exemple de la circulaire du 20 avril 2017 cité par le cours, l’aggravation peut s’appliquer même sans propos injurieux si :',
    options: [
      'Des éléments établissent l’intention discriminatoire (choix des victimes pour leur origine/religion, etc.)',
      'La victime est inconnue',
      'Il n’y a aucun élément objectif au dossier',
    ],
    answer:
        'Des éléments établissent l’intention discriminatoire (choix des victimes pour leur origine/religion, etc.)',
    explanation:
        'Le cours indique que l’aggravation est possible si des éléments démontrent l’intention discriminatoire, même sans atteinte directe à l’honneur/considération.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // LE GUET-APENS (art. 132-71-1 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens consiste dans le fait :',
    options: [
      'De suivre quelqu’un par hasard',
      'D’attendre un certain temps une ou plusieurs personnes dans un lieu déterminé pour commettre une ou plusieurs infractions',
      'D’agir sans victime déterminée',
    ],
    answer:
        'D’attendre un certain temps une ou plusieurs personnes dans un lieu déterminé pour commettre une ou plusieurs infractions',
    explanation:
        'Le cours reprend la définition légale du guet-apens (art. 132-71-1 C.P.).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens est, selon le cours :',
    options: [
      'Une circonstance aggravante réelle',
      'Une circonstance aggravante personnelle',
      'Une infraction autonome identique à l’embuscade',
    ],
    answer: 'Une circonstance aggravante réelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante réelle, étendue à tous les participants.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question:
        'Le cours précise que le guet-apens est proche de l’embuscade, mais que l’embuscade :',
    options: [
      'Est une infraction autonome, même au stade préparatoire',
      'N’existe que si l’infraction est consommée',
      'Est une simple réunion fortuite',
    ],
    answer: 'Est une infraction autonome, même au stade préparatoire',
    explanation:
        'Le cours indique que l’embuscade (art. 222-15-1 C.P.) est une infraction autonome, alors que le guet-apens est une circonstance aggravante.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question:
        'Concernant l’attente (durée, nature du lieu), le cours indique que le législateur :',
    options: [
      'A fixé une durée minimale précise',
      'N’a apporté aucune précision : notion très large',
      'A limité l’attente aux lieux publics',
    ],
    answer: 'N’a apporté aucune précision : notion très large',
    explanation:
        'Le cours précise que l’article ne fixe ni durée minimale ni nature du lieu : notion large non précisée.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PORT OU USAGE D’UNE ARME (art. 132-75 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Une arme (au sens de l’art. 132-75 C.P.) est :',
    options: [
      'Uniquement une arme à feu',
      'Tout objet conçu pour tuer ou blesser',
      'Uniquement un couteau de cuisine',
    ],
    answer: 'Tout objet conçu pour tuer ou blesser',
    explanation:
        'Le cours reprend l’alinéa 1 : “est une arme tout objet conçu pour tuer ou blesser”.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question:
        'Un objet non conçu pour tuer/blesser peut être assimilé à une arme s’il est :',
    options: [
      'Utilisé ou destiné à tuer, blesser ou menacer',
      'Simplement porté dans un sac, sans intention',
      'Cassé et inutilisable',
    ],
    answer: 'Utilisé ou destiné à tuer, blesser ou menacer',
    explanation:
        'Le cours vise les armes “par destination” : objets dangereux assimilés s’ils sont utilisés/destinés à tuer, blesser ou menacer.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Une arme factice est assimilée à une arme si elle :',
    options: [
      'Ressemble suffisamment à une arme réelle et est utilisée/destinée à menacer',
      'Est un jouet sans ressemblance',
      'Est uniquement montrée dans une vitrine',
    ],
    answer:
        'Ressemble suffisamment à une arme réelle et est utilisée/destinée à menacer',
    explanation:
        'Le cours précise qu’il faut une ressemblance créant confusion et une utilisation/destination de menace de tuer ou blesser.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'L’utilisation d’un animal pour tuer, blesser ou menacer est :',
    options: [
      'Sans effet en droit pénal',
      'Assimilée à l’usage d’une arme',
      'Assimilée uniquement à une infraction de chasse',
    ],
    answer: 'Assimilée à l’usage d’une arme',
    explanation:
        'Le cours indique expressément que l’utilisation d’un animal est assimilée à l’usage d’une arme.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question:
        'Pour l’“usage et menace d’une arme”, il ne suffit pas que l’auteur soit porteur : il faut qu’il l’ait utilisée pour :',
    options: [
      'Tuer, blesser ou menacer',
      'Se défendre uniquement',
      'La collectionner',
    ],
    answer: 'Tuer, blesser ou menacer',
    explanation:
        'Le cours précise que le port ne suffit pas : il faut une utilisation/menace pour tuer, blesser ou menacer.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question:
        'Le “port d’une arme” comme circonstance aggravante est caractérisé si l’auteur était porteur :',
    options: [
      'D’une arme apparente ou cachée au moment des faits',
      'Uniquement d’une arme visible',
      'Uniquement d’une arme déclarée',
    ],
    answer: 'D’une arme apparente ou cachée au moment des faits',
    explanation:
        'Le cours précise que le port suffit si l’arme est apparente ou cachée au moment des faits.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question:
        'Parmi les infractions suivantes, laquelle est citée dans le cours comme aggravée par l’usage ou la menace d’une arme ?',
    options: [
      'Le viol (art. 222-24, 7° C.P.)',
      'La diffamation (loi de 1881)',
      'Le tapage nocturne',
    ],
    answer: 'Le viol (art. 222-24, 7° C.P.)',
    explanation:
        'Le cours liste le viol parmi les infractions aggravées par l’usage/menace d’une arme.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // L’ESCALADE (art. 132-74 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'L’escalade est :',
    options: [
      'Le fait de forcer une serrure',
      'Le fait de s’introduire par-dessus une clôture ou par une ouverture non destinée à servir d’entrée',
      'Le fait d’entrer par une porte ouverte au public',
    ],
    answer:
        'Le fait de s’introduire par-dessus une clôture ou par une ouverture non destinée à servir d’entrée',
    explanation:
        'Le cours reprend la définition légale de l’escalade (art. 132-74 C.P.).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'L’escalade est, selon le cours :',
    options: [
      'Une circonstance aggravante réelle',
      'Une circonstance aggravante personnelle',
      'Une excuse absolutoire',
    ],
    answer: 'Une circonstance aggravante réelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante réelle, étendue à tous les participants.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question:
        'Pour caractériser l’escalade, il faut un endroit clos dont l’accès est normalement interdit par :',
    options: [
      'Une clôture (haie, mur, porte, portail, toiture, etc.)',
      'Un simple panneau publicitaire',
      'Un marquage au sol uniquement',
    ],
    answer: 'Une clôture (haie, mur, porte, portail, toiture, etc.)',
    explanation:
        'Le cours précise qu’il s’agit d’un lieu clos interdit aux tiers par une clôture.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question:
        'Le moyen utilisé pour l’escalade (échelle, corde, échafaudage, etc.) :',
    options: [
      'Doit obligatoirement être prémédité',
      'Importe peu : il peut être prévu, trouvé par hasard ou improvisé',
      'Doit être une échelle uniquement',
    ],
    answer: 'Importe peu : il peut être prévu, trouvé par hasard ou improvisé',
    explanation:
        'Le cours indique que le moyen utilisé importe peu (prévu, improvisé, trouvé par hasard).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Selon le cours, l’escalade ne peut être réalisée que :',
    options: [
      'De l’intérieur vers l’extérieur',
      'De l’extérieur vers l’intérieur',
      'Dans les deux sens, sans condition',
    ],
    answer: 'De l’extérieur vers l’intérieur',
    explanation:
        'Le cours précise que l’escalade ne peut être réalisée que de l’extérieur vers l’intérieur (“s’introduire”).',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // INCAPACITÉ TOTALE DE TRAVAIL (I.T.T.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Incapacité totale de travail (I.T.T.)',
    question: 'L’I.T.T. (au sens pénal) mesure principalement :',
    options: [
      'La gravité des atteintes corporelles ou psychiques subies par la victime',
      'Uniquement la perte de salaire',
      'Uniquement le nombre de jours d’hospitalisation',
    ],
    answer:
        'La gravité des atteintes corporelles ou psychiques subies par la victime',
    explanation:
        'Le cours indique que l’I.T.T. mesure la gravité des atteintes corporelles ou psychiques.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Incapacité totale de travail (I.T.T.)',
    question: 'L’I.T.T. ne doit pas être confondue avec :',
    options: [
      'L’arrêt de travail du droit social',
      'La garde à vue',
      'La mise en examen',
    ],
    answer: 'L’arrêt de travail du droit social',
    explanation:
        'Le cours précise que l’I.T.T. pénale est différente de l’arrêt de travail en droit social.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Incapacité totale de travail (I.T.T.)',
    question:
        'Une victime sans activité professionnelle (enfant, retraité…) peut recevoir une I.T.T. :',
    options: ['Oui', 'Non', 'Uniquement si elle travaille au noir'],
    answer: 'Oui',
    explanation:
        'Le cours précise qu’une victime sans activité professionnelle peut se voir prescrire une I.T.T.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Incapacité totale de travail (I.T.T.)',
    question:
        'Pour constituer la circonstance aggravante, l’I.T.T. doit être :',
    options: ['Partielle', 'Totale', 'Symbolique'],
    answer: 'Totale',
    explanation:
        'Le cours indique que l’I.T.T. doit être totale pour constituer la circonstance.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Incapacité totale de travail (I.T.T.)',
    question: 'Selon le cours, l’I.T.T. s’étend :',
    options: [
      'Uniquement à l’activité professionnelle',
      'À toute l’activité courante et aux efforts physiques nécessaires à la vie quotidienne',
      'Uniquement aux activités sportives',
    ],
    answer:
        'À toute l’activité courante et aux efforts physiques nécessaires à la vie quotidienne',
    explanation:
        'Le cours précise que l’I.T.T. ne concerne pas seulement le travail mais toute l’activité courante.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Incapacité totale de travail (I.T.T.)',
    question:
        'La durée de l’I.T.T. est prise en compte par paliers, notamment :',
    options: [
      'Uniquement 1 jour / 2 jours',
      '≤ 8 jours ou > 8 jours (selon l’infraction)',
      'Uniquement > 30 jours',
    ],
    answer: '≤ 8 jours ou > 8 jours (selon l’infraction)',
    explanation:
        'Le cours présente des paliers de durée, dont inférieur/égal à 8 jours et supérieur à 8 jours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Incapacité totale de travail (I.T.T.)',
    question: 'Concernant la preuve de l’I.T.T., le juge :',
    options: [
      'Doit obligatoirement suivre le certificat médical sans discussion',
      'A un pouvoir d’appréciation et peut se baser sur certificats médicaux ou expertises',
      'Ne peut jamais utiliser d’expertise',
    ],
    answer:
        'A un pouvoir d’appréciation et peut se baser sur certificats médicaux ou expertises',
    explanation:
        'Le cours indique que le juge apprécie et peut s’appuyer sur certificats et rapports d’experts.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // UTILISATION D’UN MOYEN DE CRYPTOLOGIE (art. 132-79 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Moyen de cryptologie',
    question: 'L’utilisation d’un moyen de cryptologie est définie par :',
    options: [
      'L’article 132-79 du code pénal',
      'L’article 132-74 du code pénal',
      'L’article 132-80 du code pénal',
    ],
    answer: 'L’article 132-79 du code pénal',
    explanation:
        'Le cours indique que l’article 132-79 du code pénal définit cette circonstance aggravante.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Moyen de cryptologie',
    question: 'Cette circonstance aggravante est, selon le cours :',
    options: [
      'Réelle',
      'Personnelle',
      'Uniquement applicable aux contraventions',
    ],
    answer: 'Réelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante réelle.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Moyen de cryptologie',
    question: 'Un moyen de cryptologie sert principalement à assurer :',
    options: [
      'La confidentialité (et notamment la sécurité du stockage ou de la transmission des données)',
      'La vitesse de frappe au clavier',
      'La géolocalisation obligatoire',
    ],
    answer:
        'La confidentialité (et notamment la sécurité du stockage ou de la transmission des données)',
    explanation:
        'Le cours explique que la cryptologie vise surtout la confidentialité, l’authentification ou l’intégrité des données.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Moyen de cryptologie',
    question: 'Selon le cours, l’article 132-79 est de portée :',
    options: [
      'Limitée à une liste d’infractions',
      'Générale (tous crimes et délits, commis ou tentés)',
      'Réservée aux seules infractions routières',
    ],
    answer: 'Générale (tous crimes et délits, commis ou tentés)',
    explanation:
        'Le cours précise que l’article 132-79 s’applique à tous les crimes et délits, commis ou tentés.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Moyen de cryptologie',
    question:
        'L’aggravation de l’article 132-79 ne s’applique pas à l’auteur/complice qui, à la demande des autorités, a :',
    options: [
      'Refusé de répondre',
      'Remis la version en clair des messages chiffrés et les conventions secrètes nécessaires',
      'Changé de téléphone',
    ],
    answer:
        'Remis la version en clair des messages chiffrés et les conventions secrètes nécessaires',
    explanation:
        'Le cours précise l’exception : remise de la version en clair et des conventions secrètes nécessaires au déchiffrement.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Moyen de cryptologie',
    question:
        'Selon la jurisprudence citée (11 octobre 2020), le code de déverrouillage d’un téléphone peut constituer :',
    options: [
      'Une clé de déchiffrement, si le téléphone est équipé d’un moyen de cryptologie',
      'Une preuve d’innocence automatique',
      'Un simple identifiant sans lien avec la cryptologie',
    ],
    answer:
        'Une clé de déchiffrement, si le téléphone est équipé d’un moyen de cryptologie',
    explanation:
        'Le cours cite que le code de déverrouillage peut être une clé de déchiffrement si le téléphone embarque un moyen de cryptologie.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ivre ou sous l’emprise de stupéfiants',
    question:
        'Concernant l’ivresse, la jurisprudence majoritaire considère que l’ivresse :',
    options: [
      'Constitue en principe une cause légale d’exemption de peine',
      'Ne constitue pas une cause légale d’exemption de peine',
      'Supprime toujours l’intention et donc la responsabilité',
    ],
    answer: 'Ne constitue pas une cause légale d’exemption de peine',
    explanation:
        'Le cours indique que la grande majorité des décisions refusent de voir dans l’ivresse une cause légale d’exemption de peine.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ivre ou sous l’emprise de stupéfiants',
    question:
        'Pour l’usage volontaire de stupéfiants, la logique du cours est que cette solution s’applique :',
    options: [
      'Moins sévèrement que pour l’alcool, car c’est médical',
      'A fortiori, car l’usage de stupéfiants est illicite en tant que tel',
      'Uniquement si l’auteur a été contraint de consommer',
    ],
    answer:
        'A fortiori, car l’usage de stupéfiants est illicite en tant que tel',
    explanation:
        'Le cours souligne que l’usage volontaire de stupéfiants est illicite, contrairement à la consommation d’alcool, ce qui renforce l’approche.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ivre ou sous l’emprise de stupéfiants',
    question:
        'Quel texte est cité pour imposer, lors de la constatation de certains faits, des vérifications destinées à établir la présence d’alcool ?',
    options: [
      'Article L. 3354-1 du Code de la santé publique',
      'Article 450-1 du Code pénal',
      'Article 132-71 du Code pénal',
    ],
    answer: 'Article L. 3354-1 du Code de la santé publique',
    explanation:
        'Le cours renvoie à l’article L. 3354-1 du CSP qui impose aux OPJ/APJ de faire procéder à des vérifications en cas de crime, délit ou accident.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ivre ou sous l’emprise de stupéfiants',
    question:
        'Selon le cours, les vérifications liées à l’alcool sont obligatoires notamment :',
    options: [
      'Uniquement pour les contraventions',
      'Dans tous les cas de crimes, délits ou accidents suivis de mort',
      'Seulement si la victime le demande',
    ],
    answer: 'Dans tous les cas de crimes, délits ou accidents suivis de mort',
    explanation:
        'Le texte cité précise que ces vérifications sont obligatoires dans tous les cas suivis de mort.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ivre ou sous l’emprise de stupéfiants',
    question:
        'Le cours indique qu’aucune disposition spéciale ne prévoit une telle procédure en matière :',
    options: ['De stupéfiants', 'De vols simples', 'De recel'],
    answer: 'De stupéfiants',
    explanation:
        'Le cours précise qu’il n’existe pas, dans ce passage, de procédure spéciale équivalente à celle de l’alcool pour les stupéfiants.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ivre ou sous l’emprise de stupéfiants',
    question:
        'Pour affiner la preuve de consommation de stupéfiants (niveau et date), le cours mentionne la conjugaison de :',
    options: [
      'Analyses d’urine, de sang et des cheveux',
      'Une simple déclaration de l’auteur',
      'Un test respiratoire uniquement',
    ],
    answer: 'Analyses d’urine, de sang et des cheveux',
    explanation:
        'Selon les représentants de l’ordre des médecins cités, ces trois dépistages permettent de préciser niveau de consommation et date.',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // AVEC UTILISATION D’UN RÉSEAU DE COMMUNICATION ÉLECTRONIQUE
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question:
        'Cette circonstance aggravante vise l’utilisation d’un réseau pour la diffusion de messages :',
    options: [
      'À destination d’un public non déterminé',
      'À destination d’une personne unique identifiée',
      'Uniquement à destination d’un public déterminé et fermé',
    ],
    answer: 'À destination d’un public non déterminé',
    explanation:
        'Le cours retient expressément la diffusion de messages à destination d’un public non déterminé.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'La formule “public non déterminé” exclut :',
    options: [
      'La publication sur un réseau social public',
      'La diffusion sur un forum accessible à tous',
      'L’envoi d’un courriel identique à plusieurs personnes identifiées',
    ],
    answer: 'L’envoi d’un courriel identique à plusieurs personnes identifiées',
    explanation:
        'Le cours précise que cette formule exclut l’envoi d’un courrier électronique identique à plusieurs personnes identifiées.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question:
        'Selon le cours, un “réseau de communication électronique” vise notamment :',
    options: [
      'Le réseau Internet et le réseau téléphonique',
      'Uniquement le courrier postal',
      'Uniquement les communications en face à face',
    ],
    answer: 'Le réseau Internet et le réseau téléphonique',
    explanation:
        'Le cours indique expressément Internet et le réseau téléphonique.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question:
        'Cette circonstance aggravante est qualifiée par le cours comme :',
    options: [
      'Réelle, s’étendant aux auteurs, coauteurs et complices',
      'Personnelle, ne visant que l’auteur principal',
      'Une immunité pénale automatique',
    ],
    answer: 'Réelle, s’étendant aux auteurs, coauteurs et complices',
    explanation:
        'Le cours rappelle qu’il s’agit d’une circonstance aggravante réelle, dont les effets s’étendent à tous les participants.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question:
        'Dans le champ d’application cité par le cours, figure notamment :',
    options: [
      'Le viol (article 222-24 du code pénal)',
      'La diffamation publique (loi de 1881 uniquement)',
      'Le stationnement gênant',
    ],
    answer: 'Le viol (article 222-24 du code pénal)',
    explanation:
        'Le cours mentionne explicitement le viol (article 222-24) parmi les infractions aggravées par l’utilisation d’un réseau.',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // DANS UN ÉTABLISSEMENT D’ENSEIGNEMENT / LOCAUX DE L’ADMINISTRATION
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Établissement d’enseignement / locaux de l’administration',
    question:
        'Cette circonstance aggravante vise à réprimer plus sévèrement certaines infractions commises :',
    options: [
      'En milieu scolaire et dans les locaux de l’administration',
      'Uniquement en zone rurale',
      'Uniquement dans un véhicule',
    ],
    answer: 'En milieu scolaire et dans les locaux de l’administration',
    explanation:
        'Le cours explique qu’elle vise notamment le milieu scolaire, mais aussi les locaux de l’administration visés par le texte.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Établissement d’enseignement / locaux de l’administration',
    question:
        'Concernant les “locaux de l’administration”, un arrêt du 14 octobre 2020 précise que cette notion :',
    options: [
      'Peut viser n’importe quelle administration, sans limite',
      'Ne saurait être étendue à des locaux pouvant dépendre d’autres administrations',
      'Vise uniquement les locaux privés',
    ],
    answer:
        'Ne saurait être étendue à des locaux pouvant dépendre d’autres administrations',
    explanation:
        'Le cours cite un arrêt de la chambre criminelle du 14 octobre 2020 limitant l’extension de la notion.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Établissement d’enseignement / locaux de l’administration',
    question: 'Les faits peuvent être commis “dans” l’établissement :',
    options: [
      'Uniquement dans une salle de classe',
      'Dans toute partie de l’établissement (bureau, salle, escalier, cour, etc.)',
      'Uniquement à l’entrée, jamais ailleurs',
    ],
    answer:
        'Dans toute partie de l’établissement (bureau, salle, escalier, cour, etc.)',
    explanation:
        'Le cours précise que les faits peuvent être commis dans n’importe quelle partie de l’établissement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Établissement d’enseignement / locaux de l’administration',
    question: 'Pour les abords, les faits doivent être commis :',
    options: [
      'À n’importe quelle heure, sans condition',
      'Lors des entrées/sorties ou dans un temps très voisin de celles-ci',
      'Uniquement la nuit',
    ],
    answer:
        'Lors des entrées/sorties ou dans un temps très voisin de celles-ci',
    explanation:
        'Le cours impose, pour les abords, le moment des entrées et sorties ou un temps très voisin.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Établissement d’enseignement / locaux de l’administration',
    question: 'Cette circonstance aggravante est :',
    options: [
      'Personnelle et ne s’applique qu’au mineur',
      'Réelle et s’étend aux auteurs, coauteurs et complices',
      'Une excuse absolutoire',
    ],
    answer: 'Réelle et s’étend aux auteurs, coauteurs et complices',
    explanation:
        'Le cours qualifie explicitement cette circonstance de réelle, avec extension à tous les participants.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // LA BANDE ORGANISÉE (ARTICLE 132-71 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'Selon l’article 132-71 du code pénal, la bande organisée est :',
    options: [
      'Toute réunion fortuite de deux personnes',
      'Tout groupement ou entente en vue de la préparation caractérisée par des faits matériels d’une ou plusieurs infractions',
      'Toute infraction commise sans préparation',
    ],
    answer:
        'Tout groupement ou entente en vue de la préparation caractérisée par des faits matériels d’une ou plusieurs infractions',
    explanation:
        'C’est la définition légale reprise dans le cours (article 132-71 C.P.).',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée est qualifiée par le cours comme :',
    options: [
      'Une circonstance aggravante personnelle',
      'Une circonstance aggravante réelle',
      'Une immunité pénale',
    ],
    answer: 'Une circonstance aggravante réelle',
    explanation:
        'Le cours indique que c’est une circonstance aggravante réelle, s’étendant aux auteurs, coauteurs et complices.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question:
        'La bande organisée se distingue de l’association de malfaiteurs car l’association de malfaiteurs :',
    options: [
      'Est une infraction autonome, caractérisée même au stade préparatoire',
      'N’existe que si l’infraction a été consommée',
      'N’existe que pour les contraventions',
    ],
    answer:
        'Est une infraction autonome, caractérisée même au stade préparatoire',
    explanation:
        'Le cours rappelle que l’association de malfaiteurs (450-1 C.P.) est autonome et peut être constituée au stade des actes préparatoires.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La “réunion” (au sens du cours) se caractérise plutôt par :',
    options: [
      'Un caractère fortuit et occasionnel',
      'Une organisation structurée et hiérarchisée existant depuis longtemps',
      'Une direction et une hiérarchisation systématiques',
    ],
    answer: 'Un caractère fortuit et occasionnel',
    explanation:
        'Le cours oppose la réunion (fortuite/occasionnelle) à la bande organisée (plan concerté, organisation).',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'Selon le cours, la bande organisée suppose :',
    options: [
      'Un plan concerté (préméditation)',
      'L’absence totale de contacts préliminaires',
      'Une décision prise après les faits',
    ],
    answer: 'Un plan concerté (préméditation)',
    explanation:
        'Le cours cite la jurisprudence : la bande organisée suppose un plan concerté et des contacts préliminaires.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée suppose une certaine organisation avec :',
    options: [
      'Aucune répartition des rôles',
      'Direction, hiérarchisation et distribution des rôles',
      'Un seul auteur isolé',
    ],
    answer: 'Direction, hiérarchisation et distribution des rôles',
    explanation:
        'Le cours évoque une organisation structurée et hiérarchisée avec répartition des rôles.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question:
        'D’après la jurisprudence citée (8 juillet 2015), la seule constitution d’une équipe de malfaiteurs ne suffit pas si :',
    options: [
      'Il manque le critère de structure existant depuis un certain temps',
      'Il y a plus de trois personnes',
      'L’infraction est un délit',
    ],
    answer:
        'Il manque le critère de structure existant depuis un certain temps',
    explanation:
        'Le cours mentionne que l’équipe ne suffit pas si elle ne répond pas au critère supplémentaire de structure existant depuis un certain temps.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // LA MINORITÉ DE QUINZE ANS
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question: 'La circonstance aggravante “sur un mineur de 15 ans” vise :',
    options: [
      'Uniquement les victimes âgées de 15 ans révolus',
      'L’âge de 15 ans accompli, donc toute victime en dessous de 15 ans',
      'Uniquement les victimes âgées de 14 ans',
    ],
    answer: 'L’âge de 15 ans accompli, donc toute victime en dessous de 15 ans',
    explanation:
        'Le cours précise que la limite retenue est 15 ans accompli : quel que soit l’âge en dessous de 15 ans, l’aggravation peut jouer.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question: 'Pour déterminer l’âge, on retient :',
    options: [
      'L’âge de la victime au moment du jugement',
      'L’âge de la victime au moment des faits',
      'L’âge apparent de la victime',
    ],
    answer: 'L’âge de la victime au moment des faits',
    explanation:
        'Le cours indique que c’est l’âge au moment des faits qui doit être pris en considération (jurisprudence citée).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question:
        'Le calcul de l’âge “au moment des faits” se fait, selon le cours :',
    options: ['Au jour près uniquement', 'D’heure à heure', 'Au mois près'],
    answer: 'D’heure à heure',
    explanation:
        'Le cours cite une jurisprudence indiquant que l’âge se calcule d’heure à heure.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question:
        'Concernant la minorité de quinze ans, le législateur exige que cet âge soit :',
    options: [
      'Apparent ou connu de l’auteur',
      'Apparent uniquement',
      'Ni apparent ni connu : ce n’est pas exigé',
    ],
    answer: 'Ni apparent ni connu : ce n’est pas exigé',
    explanation:
        'Le cours précise que, contrairement à d’autres circonstances, la minorité de 15 ans n’a pas à être apparente ou connue.',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // LA MORT (AYANT ENTRAÎNÉ LA MORT SANS INTENTION DE LA DONNER)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Mort sans intention de la donner',
    question:
        'La circonstance aggravante “ayant entraîné la mort sans intention de la donner” suppose que :',
    options: [
      'L’auteur a voulu tuer volontairement',
      'La mort est survenue, mais l’auteur n’a jamais voulu donner la mort',
      'La mort est présumée, sans lien avec les faits',
    ],
    answer:
        'La mort est survenue, mais l’auteur n’a jamais voulu donner la mort',
    explanation:
        'Le cours précise que l’infraction a entraîné la mort, sans intention homicide de l’auteur.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Mort sans intention de la donner',
    question: 'Pour retenir cette circonstance, il faut :',
    options: [
      'Une relation de cause à effet entre l’acte délictueux et le décès',
      'Une confession obligatoire',
      'Une plainte déposée dans l’heure',
    ],
    answer: 'Une relation de cause à effet entre l’acte délictueux et le décès',
    explanation:
        'Le cours mentionne la nécessité d’un lien de causalité entre l’acte et le décès.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Mort sans intention de la donner',
    question:
        'L’état de santé préexistant de la victime (même s’il a concouru au décès) rend la circonstance :',
    options: [
      'Inapplicable',
      'Applicable : il est indifférent',
      'Applicable uniquement si la victime était en parfaite santé',
    ],
    answer: 'Applicable : il est indifférent',
    explanation:
        'Le cours précise que la circonstance peut être retenue quel que soit l’état préexistant de la victime.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Mort sans intention de la donner',
    question: 'Cette circonstance aggravante est :',
    options: [
      'Réelle (effets étendus aux auteurs, coauteurs, complices)',
      'Strictement personnelle (uniquement l’auteur principal)',
      'Une cause d’excuse légale',
    ],
    answer: 'Réelle (effets étendus aux auteurs, coauteurs, complices)',
    explanation:
        'Le cours indique qu’il s’agit d’une circonstance aggravante réelle.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // LA MUTILATION OU L’INFIRMITÉ PERMANENTE
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'Selon le cours, la mutilation correspond plutôt à :',
    options: [
      'Une simple douleur passagère',
      'La perte ou l’ablation d’un membre/partie externe entraînant une atteinte irréversible',
      'Une fatigue temporaire',
    ],
    answer:
        'La perte ou l’ablation d’un membre/partie externe entraînant une atteinte irréversible',
    explanation:
        'Le cours reprend l’idée d’une atteinte irréversible à l’intégrité physique liée à la perte/ablation d’un membre ou partie externe.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'L’infirmité permanente peut être :',
    options: [
      'Uniquement esthétique',
      'Uniquement physique',
      'Physique ou affecter les facultés mentales/intellectuelles',
    ],
    answer: 'Physique ou affecter les facultés mentales/intellectuelles',
    explanation:
        'Le cours précise que l’infirmité peut être physique mais aussi toucher les facultés mentales ou intellectuelles.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'Pour l’infirmité, le critère central est son caractère :',
    options: ['Réversible', 'Irréversible / définitif', 'Hypothétique'],
    answer: 'Irréversible / définitif',
    explanation:
        'Le cours exige une infirmité irréversible ou définitive (jurisprudences citées).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question:
        'La preuve de la mutilation/infirmité permanente peut être rapportée notamment par :',
    options: [
      'Certificats médicaux ou expertises médicales',
      'Un simple avis oral d’un témoin',
      'Une rumeur publique',
    ],
    answer: 'Certificats médicaux ou expertises médicales',
    explanation:
        'Le cours indique que la partie poursuivante peut rapporter la preuve par tout moyen, notamment certificats médicaux/expertises.',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // LA PARTICULIÈRE VULNÉRABILITÉ DE LA VICTIME
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Particulière vulnérabilité de la victime',
    question: 'La particulière vulnérabilité doit être due à des causes :',
    options: [
      'Illimitées, au choix du juge',
      'Limitatives et préexistantes aux faits',
      'Uniquement causées par l’infraction elle-même',
    ],
    answer: 'Limitatives et préexistantes aux faits',
    explanation:
        'Le cours précise que les causes sont limitatives et doivent résulter d’un état préexistant, non de la conséquence des faits.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Particulière vulnérabilité de la victime',
    question: 'Pour être retenue, la vulnérabilité doit être :',
    options: [
      'Apparente ou connue de l’auteur',
      'Toujours présumée',
      'Constatée uniquement après le procès',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation:
        'Le cours exige que la cause de vulnérabilité soit apparente (visible) ou connue (révélée) de l’auteur.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Particulière vulnérabilité de la victime',
    question: 'S’agissant de l’âge, le cours précise que :',
    options: [
      'La minorité de 15 ans entre dans cette circonstance',
      'L’âge n’est pas déterminé précisément et la minorité de 15 ans est traitée à part',
      'La vulnérabilité est automatique dès 18 ans',
    ],
    answer:
        'L’âge n’est pas déterminé précisément et la minorité de 15 ans est traitée à part',
    explanation:
        'Le cours indique que la minorité de 15 ans ne relève pas de cette vulnérabilité car elle fait l’objet d’une aggravation spécifique.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Particulière vulnérabilité de la victime',
    question:
        'Le seul “grand âge” suffit à caractériser automatiquement la particulière vulnérabilité :',
    options: [
      'Oui, toujours',
      'Non, il faut des éléments complémentaires prouvant une vulnérabilité particulière',
      'Oui, si la victime a plus de 60 ans',
    ],
    answer:
        'Non, il faut des éléments complémentaires prouvant une vulnérabilité particulière',
    explanation:
        'Le cours indique que l’âge seul ne suffit pas : il faut établir une vulnérabilité particulière.',
    difficulty: 'Difficile',
  ),
  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ D’AUTEUR ABUSANT DE SON AUTORITÉ
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question:
        'La circonstance aggravante « par une personne qui abuse de l’autorité que lui confèrent ses fonctions » est :',
    options: [
      'Une circonstance aggravante réelle',
      'Une circonstance aggravante personnelle',
      'Une cause légale d’irresponsabilité pénale',
    ],
    answer: 'Une circonstance aggravante personnelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante personnelle dont les effets ne s’étendent pas aux coauteurs.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question:
        'Cette circonstance vise les personnes disposant principalement :',
    options: [
      'D’une autorité générale liée à leurs fonctions',
      'D’un simple lien familial',
      'D’une autorité occasionnelle sans fonction',
    ],
    answer: 'D’une autorité générale liée à leurs fonctions',
    explanation:
        'Le cours indique qu’elle concerne les personnes ayant une autorité générale due aux fonctions exercées.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question:
        'Les personnes concernées par cette circonstance sont notamment :',
    options: [
      'Les professeurs, médecins, prêtres, marabouts',
      'Uniquement les ascendants familiaux',
      'Uniquement les élus politiques',
    ],
    answer: 'Les professeurs, médecins, prêtres, marabouts',
    explanation:
        'Le cours cite explicitement ces exemples de personnes ayant autorité sur la victime.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Les fonctions exercées par l’auteur peuvent être :',
    options: [
      'Uniquement publiques',
      'Uniquement privées',
      'Publiques ou privées',
    ],
    answer: 'Publiques ou privées',
    explanation:
        'Le cours précise que les fonctions exercées peuvent être publiques ou privées.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'L’aggravation est retenue lorsque l’auteur :',
    options: [
      'A simplement une fonction reconnue',
      'A abusé de l’autorité conférée par ses fonctions pour commettre l’infraction',
      'Est connu de la victime',
    ],
    answer:
        'A abusé de l’autorité conférée par ses fonctions pour commettre l’infraction',
    explanation:
        'Le cours indique que l’abus de l’autorité est la condition déterminante de l’aggravation.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ D’AUTEUR ASCENDANT OU AYANT AUTORITÉ SUR LA VICTIME
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou ayant autorité sur la victime',
    question:
        'La qualité d’auteur ascendant ou ayant autorité sur la victime constitue :',
    options: [
      'Une circonstance aggravante réelle',
      'Une circonstance aggravante personnelle',
      'Une infraction autonome',
    ],
    answer: 'Une circonstance aggravante personnelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante personnelle dont les effets ne s’étendent pas aux coauteurs.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou ayant autorité sur la victime',
    question: 'Sont considérés comme ascendants de la victime :',
    options: [
      'Les parents, aïeux et aïeules',
      'Les cousins et cousines uniquement',
      'Tous les membres de la famille',
    ],
    answer: 'Les parents, aïeux et aïeules',
    explanation:
        'Le cours vise les père, mère et autres ascendants directs, légitimes, naturels ou adoptifs.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou ayant autorité sur la victime',
    question:
        'Les parents et alliés en ligne collatérale (oncle, tante, cousin) sont :',
    options: [
      'Toujours exclus',
      'Visés uniquement s’ils ont une autorité de fait',
      'Toujours assimilés aux ascendants',
    ],
    answer: 'Visés uniquement s’ils ont une autorité de fait',
    explanation:
        'Le cours précise que la circonstance peut s’appliquer s’ils exercent une autorité de fait sur la victime.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou ayant autorité sur la victime',
    question: 'L’autorité sur la victime peut être :',
    options: [
      'Uniquement de droit',
      'Uniquement de fait',
      'De droit ou de fait, permanente ou discontinue',
    ],
    answer: 'De droit ou de fait, permanente ou discontinue',
    explanation:
        'Le cours mentionne une autorité de droit (tuteur) ou de fait, permanente ou discontinue.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ D’AUTEUR DÉPOSITAIRE DE L’AUTORITÉ PUBLIQUE
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire de l’autorité publique',
    question:
        'La qualité d’auteur dépositaire de l’autorité publique constitue :',
    options: [
      'Une circonstance aggravante réelle',
      'Une circonstance aggravante personnelle',
      'Une cause d’exemption de peine',
    ],
    answer: 'Une circonstance aggravante personnelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante personnelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire de l’autorité publique',
    question: 'Est dépositaire de l’autorité publique celui qui :',
    options: [
      'Exerce un simple emploi public',
      'Dispose d’un pouvoir de décision fondé sur une parcelle de l’autorité publique',
      'Travaille pour une entreprise privée',
    ],
    answer:
        'Dispose d’un pouvoir de décision fondé sur une parcelle de l’autorité publique',
    explanation:
        'Le cours reprend la définition jurisprudentielle de la qualité de dépositaire de l’autorité publique.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire de l’autorité publique',
    question: 'Font notamment partie des dépositaires de l’autorité publique :',
    options: [
      'Les policiers, gendarmes, magistrats',
      'Uniquement les élus locaux',
      'Uniquement les agents contractuels',
    ],
    answer: 'Les policiers, gendarmes, magistrats',
    explanation: 'Le cours cite explicitement ces professions.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire de l’autorité publique',
    question: 'La circonstance est retenue si les faits sont commis :',
    options: [
      'Dans l’exercice ou à l’occasion de l’exercice des fonctions',
      'Uniquement pendant les heures de travail',
      'Uniquement sur le lieu de travail',
    ],
    answer: 'Dans l’exercice ou à l’occasion de l’exercice des fonctions',
    explanation:
        'Le cours précise que l’infraction peut être commise dans l’exercice ou du fait des fonctions.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ DE LA VICTIME ASCENDANT DE L’AUTEUR
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Victime ascendant de l’auteur',
    question:
        'La qualité de victime ascendant de l’auteur est une circonstance aggravante :',
    options: ['Réelle', 'Personnelle', 'Mixte'],
    answer: 'Personnelle',
    explanation:
        'Le cours indique que cette circonstance est de nature personnelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Victime ascendant de l’auteur',
    question: 'Cette circonstance a été réintroduite après la suppression de :',
    options: [
      'L’incrimination de parricide',
      'L’excuse de minorité',
      'La récidive légale',
    ],
    answer: 'L’incrimination de parricide',
    explanation:
        'Le cours précise que cette circonstance a été réintroduite après la suppression du parricide.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Victime ascendant de l’auteur',
    question: 'La filiation naturelle doit être :',
    options: ['Supposée', 'Légalement établie', 'Reconnaissable moralement'],
    answer: 'Légalement établie',
    explanation:
        'Le cours précise que la filiation naturelle doit être légalement établie.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ DE LA VICTIME CHARGÉE D’UNE MISSION DE SERVICE PUBLIC
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime chargée d’une mission de service public',
    question: 'Cette circonstance aggravante est :',
    options: ['Personnelle', 'Réelle', 'Limitée à l’auteur principal'],
    answer: 'Réelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante réelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime chargée d’une mission de service public',
    question: 'Elle vise à protéger principalement :',
    options: [
      'Les personnes exposées en raison de leur mission',
      'Uniquement les fonctionnaires',
      'Uniquement les élus',
    ],
    answer: 'Les personnes exposées en raison de leur mission',
    explanation:
        'Le cours indique que cette circonstance accroît la protection due aux personnes exposées en raison de leur mission.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime chargée d’une mission de service public',
    question: 'La qualité de la victime doit être :',
    options: [
      'Inconnue de l’auteur',
      'Apparente ou connue de l’auteur',
      'Déclarée après les faits',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation:
        'Le cours précise que l’auteur doit agir en raison de la qualité apparente ou connue de la victime.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ DE LA VICTIME DÉPOSITAIRE DE L’AUTORITÉ PUBLIQUE
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire de l’autorité publique',
    question: 'Cette circonstance protège :',
    options: [
      'Uniquement la personne',
      'La personne et la fonction exercée',
      'Uniquement l’institution',
    ],
    answer: 'La personne et la fonction exercée',
    explanation:
        'Le cours précise que la protection concerne la personne et, à travers elle, la fonction.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire de l’autorité publique',
    question: 'Pour retenir cette circonstance, l’infraction doit être :',
    options: [
      'Sans lien avec la fonction',
      'En rapport direct avec la fonction',
      'Postérieure à la cessation des fonctions uniquement',
    ],
    answer: 'En rapport direct avec la fonction',
    explanation:
        'Le cours indique que l’infraction doit être en lien direct avec la fonction exercée.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ DE LA VICTIME SE LIVRANT À LA PROSTITUTION
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Cette circonstance aggravante a été créée par la loi du :',
    options: ['13 avril 2016', '21 juin 2004', '29 juillet 1881'],
    answer: '13 avril 2016',
    explanation:
        'Le cours précise que cette circonstance a été créée par la loi n°2016-444 du 13 avril 2016.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'La prostitution peut être retenue :',
    options: [
      'Uniquement si elle est habituelle',
      'Y compris de façon occasionnelle',
      'Uniquement si elle est déclarée',
    ],
    answer: 'Y compris de façon occasionnelle',
    explanation:
        'Le cours précise qu’un acte unique de prostitution peut suffire.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Les faits doivent avoir été commis :',
    options: [
      'Dans l’exercice de l’activité prostitutionnelle',
      'À n’importe quel moment',
      'Après la cessation de l’activité',
    ],
    answer: 'Dans l’exercice de l’activité prostitutionnelle',
    explanation:
        'Le cours exclut les faits sans lien avec l’activité prostitutionnelle.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ DE TÉMOIN, VICTIME OU PARTIE CIVILE
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Témoin, victime ou partie civile',
    question: 'Cette circonstance vise principalement à protéger :',
    options: [
      'Le bon fonctionnement de la justice',
      'La liberté d’expression',
      'La sécurité routière',
    ],
    answer: 'Le bon fonctionnement de la justice',
    explanation:
        'Le cours précise que cette circonstance vise à préserver l’administration de la justice.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Témoin, victime ou partie civile',
    question:
        'L’auteur peut agir avec une intention dite « préventive » pour :',
    options: [
      'Empêcher la dénonciation ou le dépôt de plainte',
      'Se défendre juridiquement',
      'Accélérer la procédure',
    ],
    answer: 'Empêcher la dénonciation ou le dépôt de plainte',
    explanation:
        'Le cours indique que l’intention préventive vise à empêcher plainte, dénonciation ou témoignage.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Témoin, victime ou partie civile',
    question:
        'Lorsque l’auteur agit par vengeance après une plainte ou une déposition, l’intention est dite :',
    options: ['Préventive', 'Répressive', 'Accidentelle'],
    answer: 'Répressive',
    explanation: 'Le cours qualifie cette intention de répressive.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ DE VICTIME PARENTE D’UNE PERSONNE DÉPOSITAIRE DE L’AUTORITÉ PUBLIQUE
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime parente d’un dépositaire de l’autorité publique',
    question: 'Cette circonstance aggravante est :',
    options: ['Personnelle', 'Réelle', 'Limitée à l’auteur principal'],
    answer: 'Réelle',
    explanation:
        'Le cours précise que cette circonstance est réelle et s’étend à tous les participants.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime parente d’un dépositaire de l’autorité publique',
    question: 'Sont notamment protégés :',
    options: [
      'Le conjoint, les ascendants, les descendants ou les personnes vivant au domicile',
      'Uniquement les enfants mineurs',
      'Uniquement les conjoints mariés',
    ],
    answer:
        'Le conjoint, les ascendants, les descendants ou les personnes vivant au domicile',
    explanation: 'Le cours énumère précisément ces catégories de proches.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime parente d’un dépositaire de l’autorité publique',
    question: 'L’infraction doit avoir été commise :',
    options: [
      'Par hasard',
      'En raison des fonctions exercées par le proche',
      'Pour un motif strictement personnel',
    ],
    answer: 'En raison des fonctions exercées par le proche',
    explanation:
        'Le cours précise que l’auteur doit avoir agi en raison des fonctions exercées par le proche, connues de lui.',
    difficulty: 'Difficile',
  ),
  //////////////////////////////////////////////////////////////////////////////
  // GÉNÉRALITÉS — CIRCONSTANCES AGGRAVANTES (rappels)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance n’est aggravante que lorsque :',
    options: [
      'Le juge le décide librement',
      'La loi le décide expressément',
      'La victime le demande',
    ],
    answer: 'La loi le décide expressément',
    explanation:
        'Le cours précise qu’une circonstance n’est aggravante que lorsque la loi le décide expressément.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Les circonstances aggravantes sont énumérées par la loi :',
    options: [
      'De manière limitative',
      'De manière indicative',
      'Uniquement par circulaire',
    ],
    answer: 'De manière limitative',
    explanation:
        'Le cours indique que la loi les énumère de manière limitative.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance aggravante peut :',
    options: [
      'Modifier la nature de la peine et donc la nature de l’infraction',
      'Supprimer automatiquement l’infraction',
      'Transformer un crime en contravention',
    ],
    answer: 'Modifier la nature de la peine et donc la nature de l’infraction',
    explanation:
        'Le cours précise qu’elle peut modifier la nature de la peine et, par conséquence, la nature de l’infraction.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Les circonstances aggravantes “réelles” :',
    options: [
      'Ne s’étendent jamais aux complices',
      'S’attachent à la matérialité du fait et valent pour tous les participants',
      'Sont uniquement liées à la personnalité',
    ],
    answer:
        'S’attachent à la matérialité du fait et valent pour tous les participants',
    explanation: 'Le cours oppose les réelles (matérialité) aux personnelles.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance “personnelle” :',
    options: [
      'S’attache à la matérialité du fait',
      'Augmente la culpabilité de celui qui agit car liée à sa personnalité',
      'S’applique automatiquement à tous les coauteurs',
    ],
    answer:
        'Augmente la culpabilité de celui qui agit car liée à sa personnalité',
    explanation:
        'Le cours : personnelles = liées à la personnalité/qualité de l’auteur.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Selon Cass. crim. 7 février 2007, une même circonstance peut :',
    options: [
      'Aggraver des crimes distincts',
      'Aggraver seulement un crime et jamais deux',
      'Être interdite si elle est objective',
    ],
    answer: 'Aggraver des crimes distincts',
    explanation:
        'Le cours cite que rien ne s’oppose à ce qu’une même circonstance aggrave des crimes distincts.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Les circonstances aggravantes dites “spéciales” :',
    options: [
      'S’appliquent à toutes les infractions sans exception',
      'Ne s’appliquent qu’aux infractions pour lesquelles la loi les prévoit',
      'Dépendent uniquement d’un décret',
    ],
    answer:
        'Ne s’appliquent qu’aux infractions pour lesquelles la loi les prévoit',
    explanation:
        'Le cours précise qu’elles ne valent que pour les infractions visées.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'La doctrine ajoute parfois une 3e catégorie :',
    options: [
      'Les circonstances mixtes',
      'Les circonstances administratives',
      'Les circonstances morales',
    ],
    answer: 'Les circonstances mixtes',
    explanation:
        'Le cours mentionne la doctrine : mixtes (qualité + criminalité de l’acte).',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PRÉMÉDITATION (art. 132-72 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation est :',
    options: [
      'Le dessein formé avant l’action de commettre un crime ou un délit déterminé',
      'Le fait d’agir en groupe',
      'Le fait d’être armé',
    ],
    answer:
        'Le dessein formé avant l’action de commettre un crime ou un délit déterminé',
    explanation: 'Définition légale reprise au cours (art. 132-72 C.P.).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation est définie par :',
    options: [
      'L’article 132-72 C.P.',
      'L’article 132-75 C.P.',
      'L’article 132-80 C.P.',
    ],
    answer: 'L’article 132-72 C.P.',
    explanation: 'Référence donnée par le cours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Elle traduit une volonté :',
    options: [
      'Mûre et réfléchie',
      'Spontanée et impulsive',
      'Toujours accidentelle',
    ],
    answer: 'Mûre et réfléchie',
    explanation: 'Le cours : résolution d’agir, volonté mûre et réfléchie.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Condition essentielle : la résolution doit être :',
    options: [
      'Postérieure à l’acte',
      'Antérieure à l’acte',
      'Indifférente dans le temps',
    ],
    answer: 'Antérieure à l’acte',
    explanation: 'Antériorité nécessaire (Cass. crim., 9 janv. 1990).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'L’intervalle de temps se situe entre :',
    options: [
      'La résolution et l’exécution',
      'L’enquête et le procès',
      'La plainte et la condamnation',
    ],
    answer: 'La résolution et l’exécution',
    explanation: 'Le cours : entre décision et exécution.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Un acte prémédité est :',
    options: [
      'Médité et préparé',
      'Toujours une pulsion',
      'Toujours une réaction immédiate',
    ],
    answer: 'Médité et préparé',
    explanation: 'Non spontané, pas une pulsion.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation vise :',
    options: [
      'Une infraction commise ou tentée',
      'Uniquement une infraction consommée',
      'Uniquement les contraventions',
    ],
    answer: 'Une infraction commise ou tentée',
    explanation: 'Le cours : indifféremment commise ou tentée.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Elle se matérialise par des faits situés :',
    options: [
      'Avant l’acte, dans l’intervalle qui précède',
      'Uniquement après l’acte',
      'Uniquement au procès',
    ],
    answer: 'Avant l’acte, dans l’intervalle qui précède',
    explanation:
        'Le cours insiste sur les faits/circonstances précédant l’acte.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Exemple de matérialisation :',
    options: [
      'Actes préparatoires / menaces / confidences',
      'Simple maladresse',
      'Absence totale de préparation',
    ],
    answer: 'Actes préparatoires / menaces / confidences',
    explanation: 'Exemples cités par le cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La jurisprudence qualifie parfois la préméditation :',
    options: [
      'Toujours réelle',
      'Tantôt réelle, tantôt personnelle',
      'Toujours mixte au sens légal',
    ],
    answer: 'Tantôt réelle, tantôt personnelle',
    explanation: 'Le cours mentionne cette hésitation jurisprudentielle.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Le meurtre avec préméditation devient :',
    options: ['Un assassinat', 'Un homicide involontaire', 'Une contravention'],
    answer: 'Un assassinat',
    explanation: 'Art. 221-3 al.1 : meurtre qualifié d’assassinat.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Le champ d’application inclut notamment :',
    options: [
      'Le meurtre, l’empoisonnement, certaines violences',
      'Le stationnement gênant',
      'Le recel simple uniquement',
    ],
    answer: 'Le meurtre, l’empoisonnement, certaines violences',
    explanation: 'Liste donnée dans le cours.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // GUET-APENS (art. 132-71-1 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens consiste à :',
    options: [
      'Attendre un certain temps une ou plusieurs personnes dans un lieu déterminé pour commettre une ou plusieurs infractions',
      'Agir sous contrainte d’un tiers',
      'Commettre une infraction sans victime',
    ],
    answer:
        'Attendre un certain temps une ou plusieurs personnes dans un lieu déterminé pour commettre une ou plusieurs infractions',
    explanation: 'Définition de l’art. 132-71-1 reprise au cours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens est une circonstance :',
    options: ['Réelle', 'Personnelle', 'Purement disciplinaire'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue à tous les participants.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens est une forme particulière de :',
    options: ['Préméditation', 'Récidive', 'Tentative'],
    answer: 'Préméditation',
    explanation: 'Le cours : forme particulière de préméditation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Concernant la durée minimale de l’attente, le texte :',
    options: [
      'La fixe précisément',
      'Ne la précise pas',
      'Exige au moins 24 heures',
    ],
    answer: 'Ne la précise pas',
    explanation: 'Le cours : notion large, pas de durée minimum.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'La qualité de la victime est :',
    options: [
      'Indifférente (toute personne)',
      'Limitée aux mineurs',
      'Limitée aux dépositaires d’autorité',
    ],
    answer: 'Indifférente (toute personne)',
    explanation: 'Le cours : “toute personne quelle que soit sa qualité”.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le but poursuivi est caractérisé par :',
    options: [
      'Des actes préparatoires liés à l’infraction visée',
      'Une simple négligence',
      'Un hasard complet',
    ],
    answer: 'Des actes préparatoires liés à l’infraction visée',
    explanation:
        'Le cours : actes préparatoires en relation avec l’infraction.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens se distingue de l’embuscade car l’embuscade :',
    options: [
      'Est une infraction autonome',
      'N’existe jamais en droit',
      'Est une contravention',
    ],
    answer: 'Est une infraction autonome',
    explanation:
        'Le cours : embuscade = infraction autonome (même au stade préparatoire).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Champ d’application : guet-apens peut aggraver :',
    options: [
      'Meurtre, empoisonnement, tortures, violences (liste du cours)',
      'Uniquement des contraventions',
      'Uniquement le recel',
    ],
    answer: 'Meurtre, empoisonnement, tortures, violences (liste du cours)',
    explanation: 'Liste donnée dans le cours.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // PORT / USAGE / MENACE D’UNE ARME (art. 132-75 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Selon l’art. 132-75, une arme est :',
    options: [
      'Tout objet conçu pour tuer ou blesser',
      'Tout objet métallique',
      'Tout objet lourd',
    ],
    answer: 'Tout objet conçu pour tuer ou blesser',
    explanation: 'Arme par nature (alinéa 1).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Un objet du quotidien devient arme “par destination” s’il est :',
    options: [
      'Utilisé/destiné à tuer, blesser ou menacer',
      'Simplement acheté',
      'Transporté dans un carton',
    ],
    answer: 'Utilisé/destiné à tuer, blesser ou menacer',
    explanation: 'Alinéa 2 : assimilation par destination.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Une arme factice est assimilée si elle :',
    options: [
      'Crée une confusion par ressemblance et sert à menacer',
      'Est cassée',
      'N’a aucune ressemblance',
    ],
    answer: 'Crée une confusion par ressemblance et sert à menacer',
    explanation: 'Alinéa 3 : ressemblance + menace/destination.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'L’utilisation d’un animal pour menacer est :',
    options: [
      'Assimilée à l’usage d’une arme',
      'Sans conséquence',
      'Toujours une contravention',
    ],
    answer: 'Assimilée à l’usage d’une arme',
    explanation: 'Alinéa 4 : animal assimilé.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'La circonstance “arme” est :',
    options: ['Réelle', 'Personnelle', 'Uniquement mixte'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue à tous les participants.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Pour l’usage/menace, il faut que l’arme serve à :',
    options: ['Tuer, blesser ou menacer', 'Décorer', 'Travailler uniquement'],
    answer: 'Tuer, blesser ou menacer',
    explanation:
        'Le cours : pas seulement porteur, usage pour tuer/blesser/menacer.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Pour le “port”, il suffit que l’arme soit :',
    options: [
      'Apparente ou cachée',
      'Visible uniquement',
      'Déclarée en préfecture',
    ],
    answer: 'Apparente ou cachée',
    explanation: 'Le cours : port apparente ou cachée au moment des faits.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Une arme factice peut être considérée comme :',
    options: [
      'Une arme apparente ou cachée',
      'Jamais une arme',
      'Une arme uniquement si chargée',
    ],
    answer: 'Une arme apparente ou cachée',
    explanation:
        'Cass. crim. 05/08/1992 citée : arme factice = apparente ou cachée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Exemple d’arme par nature :',
    options: [
      'Grenade / arme à feu',
      'Batte de baseball utilisée pour jouer',
      'Stylo',
    ],
    answer: 'Grenade / arme à feu',
    explanation: 'Le cours cite armes à feu/engins explosifs/incendiaires.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Exemple d’arme par destination :',
    options: [
      'Marteau / véhicule / bouteille utilisés pour blesser',
      'Livre',
      'Oreiller',
    ],
    answer: 'Marteau / véhicule / bouteille utilisés pour blesser',
    explanation:
        'Objets du quotidien assimilés s’ils sont utilisés pour tuer/blesser/menacer.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Champ d’application : l’usage/menace d’arme peut aggraver :',
    options: [
      'Le viol (art. 222-24, 7°)',
      'Le divorce',
      'La contravention de 1re classe',
    ],
    answer: 'Le viol (art. 222-24, 7°)',
    explanation: 'Liste du cours : viol aggravé par arme.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // ESCALADE (art. 132-74 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'L’escalade est :',
    options: [
      'S’introduire par-dessus une clôture ou par une ouverture non destinée à servir d’entrée',
      'Forcer une serrure',
      'Entrer par la porte principale',
    ],
    answer:
        'S’introduire par-dessus une clôture ou par une ouverture non destinée à servir d’entrée',
    explanation: 'Définition légale (art. 132-74).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'L’escalade est une circonstance :',
    options: ['Réelle', 'Personnelle', 'Disciplinaire'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Elle suppose un endroit :',
    options: ['Clos', 'Public sans clôture', 'Virtuel uniquement'],
    answer: 'Clos',
    explanation: 'Lieu clos dont l’accès est interdit par une clôture.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Le moyen utilisé :',
    options: [
      'Importe peu (prévu, improvisé, trouvé)',
      'Doit être une échelle',
      'Doit être un grappin',
    ],
    answer: 'Importe peu (prévu, improvisé, trouvé)',
    explanation: 'Le cours : échelle, corde, échafaudage… peu importe.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'L’escalade ne peut être réalisée que :',
    options: [
      'De l’extérieur vers l’intérieur',
      'De l’intérieur vers l’extérieur',
      'Dans les deux sens sans condition',
    ],
    answer: 'De l’extérieur vers l’intérieur',
    explanation: 'Le texte : “s’introduire…”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Intrusion par une issue non destinée à servir d’entrée :',
    options: [
      'Peut caractériser l’escalade (fenêtre, soupirail, tunnel)',
      'Ne compte jamais',
      'Est uniquement une effraction',
    ],
    answer: 'Peut caractériser l’escalade (fenêtre, soupirail, tunnel)',
    explanation: 'Le cours cite ces exemples.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Champ d’application : l’escalade aggrave notamment :',
    options: [
      'Le vol (art. 311-5, 3°)',
      'Le harcèlement moral',
      'La diffamation',
    ],
    answer: 'Le vol (art. 311-5, 3°)',
    explanation: 'Liste du cours.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // INCAPACITÉ TOTALE DE TRAVAIL (I.T.T.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'L’I.T.T. pénale mesure :',
    options: [
      'La gravité des atteintes corporelles ou psychiques',
      'Le salaire perdu',
      'Le préjudice moral uniquement',
    ],
    answer: 'La gravité des atteintes corporelles ou psychiques',
    explanation: 'Définition au cours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'L’I.T.T. pénale ne se confond pas avec :',
    options: [
      'L’arrêt de travail du droit social',
      'La garde à vue',
      'La mise en examen',
    ],
    answer: 'L’arrêt de travail du droit social',
    explanation: 'Le cours insiste sur la différence.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'Une personne sans emploi peut avoir une I.T.T. :',
    options: ['Oui', 'Non', 'Uniquement si elle est salariée'],
    answer: 'Oui',
    explanation: 'Enfant/retraité… possible.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'Pour la circonstance aggravante, l’incapacité doit être :',
    options: ['Totale', 'Partielle', 'Symbolique'],
    answer: 'Totale',
    explanation: 'Le cours : caractère total.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'L’I.T.T. s’étend :',
    options: [
      'À toute l’activité courante',
      'Uniquement au travail salarié',
      'Uniquement au sport',
    ],
    answer: 'À toute l’activité courante',
    explanation: 'Cass. crim. 7 mars 1967 citée : vie quotidienne.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'La durée se mesure par paliers, dont :',
    options: [
      '≤ 8 jours / > 8 jours',
      '≤ 2 jours / > 2 jours',
      '≤ 1 an uniquement',
    ],
    answer: '≤ 8 jours / > 8 jours',
    explanation: 'Paliers mentionnés au cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'Le juge :',
    options: [
      'A un pouvoir d’appréciation',
      'Doit suivre le certificat sans discussion',
      'Ne peut jamais ordonner d’expertise',
    ],
    answer: 'A un pouvoir d’appréciation',
    explanation: 'Le cours : appréciation, certificats + experts.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'La preuve est rapportée par :',
    options: [
      'La partie poursuivante',
      'La victime uniquement',
      'Le voisinage',
    ],
    answer: 'La partie poursuivante',
    explanation: 'Le cours : preuve par la partie poursuivante.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'Un effort ménager possible n’exclut pas l’I.T.T. totale :',
    options: ['Vrai', 'Faux', 'Uniquement si l’auteur avoue'],
    answer: 'Vrai',
    explanation:
        'Cass. crim. 22 nov. 1982 : tâches ménagères possibles ≠ exclure ITT.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // CRYPTOLOGIE (art. 132-79 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'L’utilisation d’un moyen de cryptologie est prévue par :',
    options: ['Art. 132-79 C.P.', 'Art. 132-72 C.P.', 'Art. 132-74 C.P.'],
    answer: 'Art. 132-79 C.P.',
    explanation: 'Référence du cours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Cette circonstance aggravante est :',
    options: ['Réelle', 'Personnelle', 'Uniquement disciplinaire'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Le moyen de cryptologie sert à assurer :',
    options: [
      'La confidentialité / authentification / intégrité des données',
      'La vitesse du réseau',
      'La publicité des échanges',
    ],
    answer: 'La confidentialité / authentification / intégrité des données',
    explanation: 'Définition issue de la loi du 21 juin 2004 (art. 29) citée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Art. 132-79 s’applique :',
    options: [
      'À tous crimes et délits (commis ou tentés)',
      'Uniquement aux infractions sexuelles',
      'Uniquement aux contraventions',
    ],
    answer: 'À tous crimes et délits (commis ou tentés)',
    explanation: 'Portée générale selon le cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'L’exception d’application vaut si l’auteur/complice a remis :',
    options: [
      'La version en clair + conventions secrètes nécessaires',
      'Un téléphone neuf',
      'Un procès-verbal',
    ],
    answer: 'La version en clair + conventions secrètes nécessaires',
    explanation: 'Exception du texte : remise aux autorités.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question:
        'Selon Cass. crim. 11 oct. 2020, le code de déverrouillage peut être :',
    options: [
      'Une clé de déchiffrement si le téléphone a un moyen de cryptologie',
      'Toujours sans lien avec la cryptologie',
      'Un élément constitutif de l’escroquerie',
    ],
    answer:
        'Une clé de déchiffrement si le téléphone a un moyen de cryptologie',
    explanation: 'Jurisprudence citée dans le cours.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // AUTEUR ABUSANT DE SON AUTORITÉ
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Cette circonstance est :',
    options: ['Personnelle', 'Réelle', 'Une excuse de provocation'],
    answer: 'Personnelle',
    explanation: 'Le cours : personnelle, non étendue aux coauteurs.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Elle vise une autorité :',
    options: [
      'Générale due aux fonctions',
      'Familiale uniquement',
      'Résultant d’un hasard',
    ],
    answer: 'Générale due aux fonctions',
    explanation:
        'Le cours : autorité générale à l’égard d’un certain nombre de personnes.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Exemple de personnes concernées :',
    options: [
      'Professeurs / médecins / prêtres / marabouts',
      'Uniquement ascendants',
      'Uniquement policiers',
    ],
    answer: 'Professeurs / médecins / prêtres / marabouts',
    explanation: 'Exemples donnés au cours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Les fonctions peuvent être :',
    options: [
      'Publiques ou privées',
      'Uniquement publiques',
      'Uniquement privées',
    ],
    answer: 'Publiques ou privées',
    explanation: 'Condition 2.2 du cours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'L’aggravation suppose :',
    options: [
      'Un abus de l’autorité pour commettre l’acte',
      'Une simple connaissance de la victime',
      'Un dommage matériel uniquement',
    ],
    answer: 'Un abus de l’autorité pour commettre l’acte',
    explanation: 'Condition 2.3 : abus de l’autorité.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Champ d’application : figure notamment :',
    options: [
      'Viol (222-24, 5°) / agressions sexuelles (222-28, 3°)',
      'Vol simple',
      'Recel simple',
    ],
    answer: 'Viol (222-24, 5°) / agressions sexuelles (222-28, 3°)',
    explanation: 'Infractions listées au cours.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // AUTEUR ASCENDANT OU AYANT AUTORITÉ SUR LA VICTIME
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur victime',
    question: 'Cette circonstance est :',
    options: ['Personnelle', 'Réelle', 'Toujours mixte'],
    answer: 'Personnelle',
    explanation: 'Le cours : personnelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur victime',
    question: 'Ascendants visés :',
    options: [
      'Père, mère, aïeux/aïeules (légitimes, naturels, adoptifs)',
      'Cousins uniquement',
      'Voisins',
    ],
    answer: 'Père, mère, aïeux/aïeules (légitimes, naturels, adoptifs)',
    explanation: 'Le cours précise la liste des ascendants directs.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur victime',
    question: 'Les collatéraux (oncle/tante/cousin) :',
    options: [
      'Ne sont pas visés comme ascendants',
      'Sont toujours visés',
      'Sont visés seulement si mariage',
    ],
    answer: 'Ne sont pas visés comme ascendants',
    explanation:
        'Le cours : parents/alliés collatéraux non visés comme ascendants.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur victime',
    question: 'Mais un collatéral peut entrer si :',
    options: [
      'Autorité de fait sur la victime',
      'Autorité publique uniquement',
      'Victime majeure uniquement',
    ],
    answer: 'Autorité de fait sur la victime',
    explanation:
        'Le cours : si oncle/tante/cousin ont autorité de fait, la circonstance peut jouer.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur victime',
    question: 'L’autorité sur la victime peut être :',
    options: [
      'De droit ou de fait',
      'Uniquement de droit',
      'Uniquement de fait',
    ],
    answer: 'De droit ou de fait',
    explanation: 'Le cours distingue tuteur (droit) et autorité de fait.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur victime',
    question: 'Exemple d’autorité de fait :',
    options: [
      'Concubin de la mère / cohabitation / chef scout',
      'Employé de banque',
      'Client d’un magasin',
    ],
    answer: 'Concubin de la mère / cohabitation / chef scout',
    explanation: 'Exemples donnés au cours.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // AUTEUR DÉPOSITAIRE DE L’AUTORITÉ PUBLIQUE / MISSION SERVICE PUBLIC (auteur)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique',
    question: 'Cette circonstance (auteur dépositaire) est :',
    options: ['Personnelle', 'Réelle', 'Une cause d’atténuation'],
    answer: 'Personnelle',
    explanation: 'Le cours : personnelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique',
    question: 'Dépositaire de l’autorité publique = personne avec :',
    options: [
      'Pouvoir de décision fondé sur une parcelle d’autorité publique',
      'Simple mission privée',
      'Aucune prérogative',
    ],
    answer: 'Pouvoir de décision fondé sur une parcelle d’autorité publique',
    explanation: 'Définition citée au cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique',
    question: 'Exemples :',
    options: [
      'Policiers / gendarmes / douaniers / huissiers',
      'Uniquement enseignants',
      'Uniquement médecins',
    ],
    answer: 'Policiers / gendarmes / douaniers / huissiers',
    explanation: 'Exemples listés au cours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique',
    question:
        'Personne chargée d’une mission de service public = personne qui :',
    options: [
      'Accomplit un service quelconque temporaire ou permanent, sans parcelle d’autorité publique',
      'A toujours un pouvoir de décision',
      'N’agit jamais sur réquisition',
    ],
    answer:
        'Accomplit un service quelconque temporaire ou permanent, sans parcelle d’autorité publique',
    explanation: 'Définition issue de la circulaire du 14 mai 1993 citée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique',
    question: 'Les faits doivent être commis :',
    options: [
      'Dans l’exercice ou à l’occasion de l’exercice des fonctions',
      'Uniquement hors service',
      'Uniquement à domicile',
    ],
    answer: 'Dans l’exercice ou à l’occasion de l’exercice des fonctions',
    explanation: 'Condition du cours : en service ou du fait de ses fonctions.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // VICTIME DÉPOSITAIRE DE L’AUTORITÉ PUBLIQUE (victime)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire autorité publique',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Toujours mixte'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue à tous les participants.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire autorité publique',
    question: 'Elle protège :',
    options: [
      'La personne et, à travers elle, la fonction',
      'Uniquement la personne',
      'Uniquement l’administration',
    ],
    answer: 'La personne et, à travers elle, la fonction',
    explanation: 'Le cours insiste sur la protection de la fonction.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire autorité publique',
    question: 'Condition : la qualité doit être :',
    options: [
      'Apparente ou connue de l’auteur',
      'Toujours inconnue',
      'Sans importance',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation: 'Condition du cours : apparente ou connue.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire autorité publique',
    question: 'La victime doit être atteinte :',
    options: [
      'Dans l’exercice ou du fait de ses fonctions',
      'Uniquement en dehors de ses fonctions',
      'Uniquement de nuit',
    ],
    answer: 'Dans l’exercice ou du fait de ses fonctions',
    explanation: 'Condition 2.2 du cours.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // VICTIME CHARGÉE D’UNE MISSION DE SERVICE PUBLIC (victime)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Victime mission service public',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Une excuse de minorité'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Victime mission service public',
    question: 'Elle vise notamment :',
    options: [
      'Enseignants/personnels scolaires, agents transport public, professionnels de santé',
      'Uniquement magistrats',
      'Uniquement militaires',
    ],
    answer:
        'Enseignants/personnels scolaires, agents transport public, professionnels de santé',
    explanation: 'Liste détaillée dans le cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Victime mission service public',
    question: 'Condition temporelle : la victime doit être :',
    options: [
      'Dans l’exercice de ses fonctions',
      'Uniquement en congé',
      'Toujours hors service',
    ],
    answer: 'Dans l’exercice de ses fonctions',
    explanation: 'Le cours : en service / acte entrant dans ses attributions.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Victime mission service public',
    question: 'Condition de connaissance : qualité :',
    options: ['Apparente ou connue', 'Toujours ignorée', 'Jamais exigée'],
    answer: 'Apparente ou connue',
    explanation:
        'Le cours : même condition que vulnérabilité (apparente/connue).',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // VICTIME SE LIVRANT À LA PROSTITUTION
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Uniquement disciplinaire'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Condition : la personne doit se livrer à la prostitution =',
    options: [
      'Rapports sexuels contre rémunération',
      'Simple flirt',
      'Simple relation affective',
    ],
    answer: 'Rapports sexuels contre rémunération',
    explanation: 'Définition donnée au cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'La prostitution peut être :',
    options: ['Occasionnelle', 'Uniquement habituelle', 'Uniquement déclarée'],
    answer: 'Occasionnelle',
    explanation: 'Le cours : un acte unique peut suffire.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Les faits doivent être commis :',
    options: [
      'Dans l’exercice de cette activité',
      'Sans aucun lien avec l’activité',
      'Uniquement après la fin de l’activité',
    ],
    answer: 'Dans l’exercice de cette activité',
    explanation: 'Le cours exclut les contentieux sans lien avec l’activité.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Texte créateur : loi du :',
    options: ['13 avril 2016', '21 juin 2004', '14 mai 1993'],
    answer: '13 avril 2016',
    explanation: 'Loi n°2016-444 citée au cours.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // QUALITÉ DE TÉMOIN / VICTIME / PARTIE CIVILE
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Cette circonstance est de nature :',
    options: ['Personnelle', 'Réelle', 'Toujours mixte'],
    answer: 'Personnelle',
    explanation: 'Le cours : dépend de l’intention et du but poursuivi.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Elle vise à protéger :',
    options: [
      'Le bon fonctionnement de la justice',
      'La circulation routière',
      'La propriété intellectuelle',
    ],
    answer: 'Le bon fonctionnement de la justice',
    explanation:
        'Le cours : pressions menacent l’administration de la justice.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Elle suppose qu’une infraction :',
    options: [
      'A été préalablement commise',
      'N’a jamais existé',
      'Est uniquement imaginaire',
    ],
    answer: 'A été préalablement commise',
    explanation:
        'Le cours : une nouvelle infraction vise à éviter/vengeance/dissuader.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Intention “préventive” =',
    options: [
      'Empêcher dénoncer/porter plainte/déposer',
      'Venger une déposition',
      'Réparer un dommage',
    ],
    answer: 'Empêcher dénoncer/porter plainte/déposer',
    explanation: 'Le cours : retirer plainte, influencer déclarations, etc.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Intention “répressive” =',
    options: [
      'Vengeance après plainte/dénonciation/déposition',
      'Empêcher avant plainte',
      'Accident pur',
    ],
    answer: 'Vengeance après plainte/dénonciation/déposition',
    explanation: 'Le cours : volonté de vengeance.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // VICTIME PARENTE D’UN DÉPOSITAIRE / PERSONNE PROTÉGÉE (proches)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Une cause d’excuse'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Sont protégés notamment :',
    options: [
      'Conjoint, ascendants, descendants en ligne directe',
      'Uniquement les frères/sœurs',
      'Uniquement les amis',
    ],
    answer: 'Conjoint, ascendants, descendants en ligne directe',
    explanation: 'Liste du cours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Est aussi visée :',
    options: [
      'Toute personne vivant habituellement au domicile',
      'Toute personne croisée dans la rue',
      'Toute personne travaillant au même endroit',
    ],
    answer: 'Toute personne vivant habituellement au domicile',
    explanation: 'Le cours : personne hébergée, quel que soit lien.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Condition essentielle : faits commis :',
    options: [
      'En raison des fonctions exercées par le proche',
      'Au hasard',
      'Pour un motif sans lien',
    ],
    answer: 'En raison des fonctions exercées par le proche',
    explanation: 'Le cours : lien avec fonctions du proche.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Cela implique que l’auteur :',
    options: [
      'Connaissait la qualité du proche',
      'Ignorait totalement la qualité',
      'N’avait aucune intention',
    ],
    answer: 'Connaissait la qualité du proche',
    explanation: 'Le cours : condition de connaissance.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // CARACTÈRE RACISTE (art. 132-76)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question: 'Le caractère raciste est défini par :',
    options: ['Art. 132-76 C.P.', 'Art. 132-77 C.P.', 'Art. 132-80 C.P.'],
    answer: 'Art. 132-76 C.P.',
    explanation: 'Référence du cours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Toujours mixte'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question: 'Elle vise l’appartenance (vraie ou supposée) à :',
    options: [
      'Prétendue race / ethnie / nation / religion',
      'Profession / diplôme',
      'Équipe sportive',
    ],
    answer: 'Prétendue race / ethnie / nation / religion',
    explanation: '4 catégories du cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question: 'La matérialisation peut venir de :',
    options: [
      'Propos/écrits/images/objets/actes',
      'Uniquement un casier',
      'Uniquement un aveu',
    ],
    answer: 'Propos/écrits/images/objets/actes',
    explanation: 'Éléments objectifs listés.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question: 'L’appartenance peut être :',
    options: [
      'Vraie ou supposée',
      'Uniquement vraie',
      'Uniquement prouvée par certificat',
    ],
    answer: 'Vraie ou supposée',
    explanation: 'Le cours : peu importe l’erreur de l’auteur.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // CARACTÈRE HOMOPHOBE / SEXISTE / TRANSPHOBE (art. 132-77)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe/sexiste/transphobe',
    question: 'Le caractère homophobe/sexiste est défini par :',
    options: ['Art. 132-77 C.P.', 'Art. 132-76 C.P.', 'Art. 132-79 C.P.'],
    answer: 'Art. 132-77 C.P.',
    explanation: 'Référence du cours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe/sexiste/transphobe',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Uniquement mixte'],
    answer: 'Réelle',
    explanation: 'Le cours : réelle, étendue.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe/sexiste/transphobe',
    question: 'Elle peut être établie par :',
    options: [
      'Propos/écrits/images/objets/actes portant atteinte ou prouvant le mobile',
      'Uniquement une expertise',
      'Uniquement une plainte',
    ],
    answer:
        'Propos/écrits/images/objets/actes portant atteinte ou prouvant le mobile',
    explanation:
        'Le cours donne les 2 branches : atteinte ou preuve du mobile.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe/sexiste/transphobe',
    question: 'Elle vise notamment :',
    options: [
      'Homosexuels et personnes transsexuelles/transgenres/travesties',
      'Uniquement homosexuels',
      'Uniquement hétérosexuels',
    ],
    answer: 'Homosexuels et personnes transsexuelles/transgenres/travesties',
    explanation: 'Le cours l’indique expressément.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe/sexiste/transphobe',
    question: 'L’identité/orientation peut être :',
    options: ['Vraie ou supposée', 'Uniquement vraie', 'Toujours déclarée'],
    answer: 'Vraie ou supposée',
    explanation: 'Le cours : même si l’auteur se trompe.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // ------------------------------------------------------------
  // IMPORTANT : Tu as demandé +200 questions.
  // Dans un seul message, je suis limité par la taille max de réponse.
  // Ci-dessous je t’en donne déjà une GROSSE base (≈100+ items) +
  // un “PACK” de questions supplémentaires ultra denses pour arriver
  // au plus près de ta demande dans ce même format.
  // ------------------------------------------------------------
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // PACK DENSE — (questions courtes, même template) :
  // Thèmes : préméditation / guet-apens / arme / escalade / ITT / cryptologie /
  // autorité / victimes protégées / témoin-victime-PC / racisme / homophobie.
  // (Chaque item = 1 QuizQuestion)
  // => Tu peux copier-coller tel quel.
  //////////////////////////////////////////////////////////////////////////////

  // --- PRÉMÉDITATION (pack) ---
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation suppose une résolution :',
    options: ['Instantanée', 'Mûre et réfléchie', 'Toujours involontaire'],
    answer: 'Mûre et réfléchie',
    explanation: 'Volonté persistante et plan tracé à l’avance.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'L’intervalle de temps requis est :',
    options: ['Fixé à 48h', 'Non déterminé (plus ou moins long)', 'Fixé à 1h'],
    answer: 'Non déterminé (plus ou moins long)',
    explanation: 'Le cours : durée non déterminée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Une pulsion immédiate exclut en principe :',
    options: ['La réunion', 'La préméditation', 'La tentative'],
    answer: 'La préméditation',
    explanation: 'Acte prémédité ≠ spontané.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation doit être recherchée dans :',
    options: ['Les faits accompagnant l’acte', 'Le seul casier', 'La rumeur'],
    answer: 'Les faits accompagnant l’acte',
    explanation: 'Cass. crim. 4 sept. 1976 citée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Menaces avant les faits peuvent :',
    options: [
      'Matérialiser la préméditation',
      'L’exclure',
      'La remplacer par escalade',
    ],
    answer: 'Matérialiser la préméditation',
    explanation: 'Exemple du cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Achat de matériel pour commettre l’acte :',
    options: [
      'Indice de préméditation',
      'Indice de contravention',
      'Sans lien possible',
    ],
    answer: 'Indice de préméditation',
    explanation: 'Acte préparatoire typique.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation peut aggraver :',
    options: [
      'Uniquement délits',
      'Meurtre/empoisonnement/violences (selon loi)',
      'Uniquement contraventions',
    ],
    answer: 'Meurtre/empoisonnement/violences (selon loi)',
    explanation: 'Champ d’application du cours.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Cass. crim. 9 janvier 1990 : exigence d’ :',
    options: ['Antériorité', 'Cohabitation', 'Récidive'],
    answer: 'Antériorité',
    explanation: 'Résolution antérieure à l’acte.',
    difficulty: 'Difficile',
  ),

  // --- GUET-APENS (pack) ---
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Guet-apens : “attendre” implique :',
    options: [
      'Aucune attente',
      'Une attente, durée non précisée',
      'Obligatoirement 2h',
    ],
    answer: 'Une attente, durée non précisée',
    explanation: 'Notion large non précisée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le lieu doit être :',
    options: ['Déterminé', 'Toujours public', 'Toujours privé'],
    answer: 'Déterminé',
    explanation: 'Définition : lieu déterminé.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Guet-apens s’applique si la loi a :',
    options: [
      'Visé l’infraction',
      'Oublié l’infraction',
      'Interdit l’aggravation',
    ],
    answer: 'Visé l’infraction',
    explanation: 'La loi doit l’avoir expressément prévu.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens est :',
    options: ['Personnel', 'Réel', 'Une immunité'],
    answer: 'Réel',
    explanation: 'Étendu aux auteurs/coauteurs/complices.',
    difficulty: 'Facile',
  ),

  // --- ARME (pack) ---
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Arme par nature = objet :',
    options: [
      'Conçu pour tuer/blesser',
      'Conçu pour cuisiner',
      'Conçu pour écrire',
    ],
    answer: 'Conçu pour tuer/blesser',
    explanation: 'Art. 132-75 al.1.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Arme par destination :',
    options: [
      'Objet du quotidien utilisé pour menacer',
      'Objet décoratif uniquement',
      'Objet interdit par principe',
    ],
    answer: 'Objet du quotidien utilisé pour menacer',
    explanation: 'Assimilation si utilisé/destiné à tuer/blesser/menacer.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Chaîne à vélo utilisée pour frapper =',
    options: ['Arme par nature', 'Arme par destination', 'Jamais une arme'],
    answer: 'Arme par destination',
    explanation: 'Objet du quotidien détourné.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Port d’arme =',
    options: [
      'Usage obligatoire',
      'Arme apparente ou cachée suffit',
      'Arme doit blesser',
    ],
    answer: 'Arme apparente ou cachée suffit',
    explanation: 'Port caractérisé sans usage.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Menacer avec une imitation réaliste :',
    options: [
      'Arme factice assimilée',
      'Aucun effet',
      'Toujours une contravention',
    ],
    answer: 'Arme factice assimilée',
    explanation: 'Ressemblance + menace.',
    difficulty: 'Moyenne',
  ),

  // --- ESCALADE (pack) ---
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Escalade = franchir :',
    options: [
      'Clôture / ouverture non prévue',
      'Une porte ouverte',
      'Un passage public',
    ],
    answer: 'Clôture / ouverture non prévue',
    explanation: 'Définition légale.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Une fenêtre peut caractériser :',
    options: ['L’escalade', 'La préméditation', 'La cryptologie'],
    answer: 'L’escalade',
    explanation: 'Ouverture non destinée à servir d’entrée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Lieu clos = accès interdit par :',
    options: ['Clôture', 'Téléphone', 'Facture'],
    answer: 'Clôture',
    explanation: 'Haie, mur, porte, portail, toiture…',
    difficulty: 'Facile',
  ),

  // --- ITT (pack) ---
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'I.T.T. =',
    options: ['Gravité atteintes', 'Salaire perdu', 'Nombre de PV'],
    answer: 'Gravité atteintes',
    explanation: 'Atteintes corporelles/psychiques.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'I.T.T. totale n’exige pas :',
    options: [
      'Aucune tâche possible',
      'Incapacité totale au sens pénal',
      'Une hospitalisation',
    ],
    answer: 'Aucune tâche possible',
    explanation: 'Tâches ménagères possibles ≠ exclure ITT.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'Preuve I.T.T. :',
    options: ['Certificats/expertises', 'Réseaux sociaux', 'Rumeur'],
    answer: 'Certificats/expertises',
    explanation: 'Le cours : certificats médicaux + experts.',
    difficulty: 'Moyenne',
  ),

  // --- CRYPTOLOGIE (pack) ---
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Cryptologie = moyen pour :',
    options: ['Confidentialité', 'Publicité', 'Aucune transformation'],
    answer: 'Confidentialité',
    explanation: 'Sécurité des communications/données.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: '132-79 : maximum de peine est :',
    options: ['Réduit', 'Relevé', 'Supprimé'],
    answer: 'Relevé',
    explanation: 'Le texte : “maximum … est relevé”.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Exception 132-79 si remise aux autorités :',
    options: [
      'Version en clair + conventions',
      'Uniquement le téléphone',
      'Uniquement le code PIN sans contexte',
    ],
    answer: 'Version en clair + conventions',
    explanation: 'Condition textuelle.',
    difficulty: 'Difficile',
  ),

  // --- AUTEUR ABUSANT DE SON AUTORITÉ (pack) ---
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Cette circonstance ne concerne pas :',
    options: [
      'Les ascendants (cadre différent)',
      'Les professeurs',
      'Les médecins',
    ],
    answer: 'Les ascendants (cadre différent)',
    explanation:
        'Le cours : ces personnes ne rentrent pas dans le cadre des ascendants.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Effets sur coauteurs :',
    options: ['S’étend', 'Ne s’étend pas', 'S’étend si complice'],
    answer: 'Ne s’étend pas',
    explanation: 'Personnelle : pas d’extension aux coauteurs.',
    difficulty: 'Moyenne',
  ),

  // --- AUTEUR ASCENDANT/AUTORITÉ (pack) ---
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur victime',
    question: 'Ascendant =',
    options: ['Parent/aïeul (direct)', 'Cousin', 'Ami'],
    answer: 'Parent/aïeul (direct)',
    explanation: 'Ascendants directs uniquement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur victime',
    question: 'Tuteur d’un mineur = autorité :',
    options: ['De droit', 'De hasard', 'Impossible'],
    answer: 'De droit',
    explanation: 'Exemple du cours.',
    difficulty: 'Facile',
  ),

  // --- VICTIME PROSTITUTION (pack) ---
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Acte unique de prostitution :',
    options: [
      'Peut suffire',
      'Ne suffit jamais',
      'Suffit seulement si déclaré',
    ],
    answer: 'Peut suffire',
    explanation: 'Occasionnelle admise.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Sans lien avec activité : circonstance :',
    options: ['Écartée', 'Toujours retenue', 'Retenue si auteur mineur'],
    answer: 'Écartée',
    explanation: 'Doit être dans l’exercice de l’activité.',
    difficulty: 'Moyenne',
  ),

  // --- TÉMOIN/VICTIME/PARTIE CIVILE (pack) ---
  QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Catégories visées :',
    options: [
      'Témoin/victime/partie civile',
      'Tout citoyen',
      'Uniquement avocat',
    ],
    answer: 'Témoin/victime/partie civile',
    explanation: 'Le cours : exclusivement ces personnes.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'But : influencer déclarations = intention :',
    options: ['Préventive', 'Répressive', 'Involontaire'],
    answer: 'Préventive',
    explanation: 'Empêcher/contraindre/retirer plainte.',
    difficulty: 'Moyenne',
  ),
  //////////////////////////////////////////////////////////////////////////////
  // Q001–Q020 — GÉNÉRALITÉS (circonstances aggravantes, réelles/personnelles)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance n’est aggravante que lorsque :',
    options: [
      'Le juge le décide librement',
      'La loi le décide expressément',
      'La victime le demande',
    ],
    answer: 'La loi le décide expressément',
    explanation:
        'Le cours précise qu’une circonstance n’est aggravante que lorsque la loi le décide expressément.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Les circonstances aggravantes sont énumérées par la loi :',
    options: [
      'De manière limitative',
      'De manière indicative',
      'Uniquement par circulaire',
    ],
    answer: 'De manière limitative',
    explanation:
        'Le cours indique que la loi les énumère de manière limitative.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance aggravante peut :',
    options: [
      'Modifier la nature de la peine encourue',
      'Supprimer l’infraction',
      'Empêcher toute poursuite',
    ],
    answer: 'Modifier la nature de la peine encourue',
    explanation:
        'Le cours précise qu’elle peut modifier la nature de la peine encourue.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance aggravante peut aussi :',
    options: [
      'Modifier la nature de l’infraction',
      'Transformer un crime en contravention',
      'Rendre l’acte licite',
    ],
    answer: 'Modifier la nature de l’infraction',
    explanation:
        'Le cours indique qu’en modifiant la peine, elle peut modifier la nature de l’infraction.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Les circonstances aggravantes dites “spéciales” :',
    options: [
      'S’appliquent à toutes les infractions',
      'Ne s’appliquent qu’aux infractions visées',
      'S’appliquent seulement aux crimes',
    ],
    answer: 'Ne s’appliquent qu’aux infractions visées',
    explanation:
        'Le cours précise qu’elles ne s’appliquent qu’aux infractions pour lesquelles la loi les prévoit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance aggravante “réelle” :',
    options: [
      'S’attache à la matérialité du fait',
      'Ne vaut que pour l’auteur principal',
      'Dépend du casier judiciaire',
    ],
    answer: 'S’attache à la matérialité du fait',
    explanation:
        'Le cours : les circonstances réelles s’attachent à la matérialité du fait poursuivi.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance aggravante “réelle” vaut :',
    options: [
      'Pour tous les participants',
      'Uniquement pour le complice',
      'Uniquement pour la victime',
    ],
    answer: 'Pour tous les participants',
    explanation:
        'Le cours : elle ne peut exister pour l’un sans exister pour les autres (auteurs/coauteurs/complices).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance aggravante “personnelle” :',
    options: [
      'Augmente uniquement la culpabilité de celui qui agit',
      'S’attache à l’arme utilisée',
      'S’étend toujours aux coauteurs',
    ],
    answer: 'Augmente uniquement la culpabilité de celui qui agit',
    explanation:
        'Le cours : les circonstances personnelles sont liées à la personnalité/qualité de l’auteur.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question:
        'Exemple typique de circonstance “purement” personnelle (cours) :',
    options: ['La récidive', 'L’escalade', 'Le guet-apens'],
    answer: 'La récidive',
    explanation:
        'Le cours cite la récidive comme circonstance “purement” personnelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question:
        'Selon la jurisprudence citée, certaines circonstances personnelles liées à la qualité :',
    options: [
      'Peuvent être applicables au complice',
      'Sont toujours inapplicables au complice',
      'Rendent l’acte non punissable',
    ],
    answer: 'Peuvent être applicables au complice',
    explanation:
        'Le cours cite Cass. crim., 7 septembre 2005 : circonstances liées à la qualité de l’auteur principal applicables au complice.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Le “principe de l’emprunt de criminalité” signifie (cours) :',
    options: [
      'Le complice répond des circonstances qualifiant l’acte',
      'Le complice n’est jamais punissable',
      'Le complice est jugé uniquement civilement',
    ],
    answer: 'Le complice répond des circonstances qualifiant l’acte',
    explanation:
        'Le cours indique que le complice encourt la responsabilité des circonstances qualifiant l’acte poursuivi.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une même circonstance peut aggraver :',
    options: [
      'Des crimes distincts',
      'Un seul crime maximum',
      'Uniquement des délits',
    ],
    answer: 'Des crimes distincts',
    explanation:
        'Le cours cite Cass. crim., 7 février 2007 sur l’aggravation possible de crimes distincts.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Les circonstances aggravantes peuvent tenir :',
    options: [
      'Aux conséquences, à la victime, à l’auteur, aux moyens, au lieu',
      'Uniquement au lieu',
      'Uniquement à la victime',
    ],
    answer: 'Aux conséquences, à la victime, à l’auteur, aux moyens, au lieu',
    explanation:
        'Le cours donne ces grandes familles de circonstances aggravantes.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Le cours traite notamment des circonstances des articles :',
    options: [
      '132-71 à 132-80 C.P.',
      '111-1 à 111-5 C.P.',
      '223-1 à 223-3 C.P.',
    ],
    answer: '132-71 à 132-80 C.P.',
    explanation:
        'Le cours annonce le périmètre : articles 132-71 à 132-80 du code pénal (et communes).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Les circonstances “mixtes” (doctrine) tiennent :',
    options: [
      'À la fois à la qualité de l’auteur et à la criminalité de l’acte',
      'Uniquement à l’âge de la victime',
      'Uniquement au lieu',
    ],
    answer: 'À la fois à la qualité de l’auteur et à la criminalité de l’acte',
    explanation: 'Le cours mentionne cette catégorie doctrinale “mixte”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question:
        'Une circonstance aggravante peut exister sans que le complice l’ait connue (cours) :',
    options: [
      'Oui, pour les circonstances qualifiant l’acte',
      'Non, jamais',
      'Uniquement pour les contraventions',
    ],
    answer: 'Oui, pour les circonstances qualifiant l’acte',
    explanation:
        'Le cours cite Cass. crim., 21 mai 1996 : pas nécessaire qu’elles aient été connues du complice.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance aggravante réelle :',
    options: [
      'Ne peut pas être séparée du fait poursuivi',
      'Dépend uniquement du mobile',
      'Dépend du lien conjugal',
    ],
    answer: 'Ne peut pas être séparée du fait poursuivi',
    explanation:
        'Le cours : elle s’attache à la matérialité du fait dont elle ne peut être séparée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance personnelle s’étend aux coauteurs :',
    options: [
      'Toujours',
      'Jamais, par principe',
      'Uniquement si la loi le prévoit expressément',
    ],
    answer: 'Jamais, par principe',
    explanation:
        'Le cours : personnelle = augmente la culpabilité de celui qui agit, sans extension aux coauteurs (principe).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'La loi détermine, pour chaque circonstance, l’aggravation :',
    options: ['De manière précise', 'Au choix de l’auteur', 'Sans encadrement'],
    answer: 'De manière précise',
    explanation:
        'Le cours : la loi détermine pour chaque cas l’aggravation de la peine encourue.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Généralités',
    question: 'Une circonstance ne peut pas :',
    options: [
      'Être ajoutée par analogie',
      'Être prévue par la loi',
      'Aggraver une peine',
    ],
    answer: 'Être ajoutée par analogie',
    explanation:
        'Le cours insiste sur l’énumération limitative et le principe de légalité : pas d’extension par analogie.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Q021–Q040 — PRÉMÉDITATION (art. 132-72 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation est :',
    options: [
      'Le dessein formé avant l’action',
      'L’acte commis par surprise',
      'Le fait d’être armé',
    ],
    answer: 'Le dessein formé avant l’action',
    explanation: 'Définition de l’art. 132-72 C.P. reprise au cours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation vise :',
    options: [
      'Un crime ou un délit déterminé',
      'Toute contravention',
      'Toute faute civile',
    ],
    answer: 'Un crime ou un délit déterminé',
    explanation: 'Le cours : crime ou délit déterminé.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation traduit une volonté :',
    options: ['Mûre et réfléchie', 'Spontanée', 'Purement accidentelle'],
    answer: 'Mûre et réfléchie',
    explanation: 'Le cours : résolution d’agir, volonté mûre et réfléchie.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'L’antériorité de la résolution à l’acte est :',
    options: ['Nécessaire', 'Indifférente', 'Interdite'],
    answer: 'Nécessaire',
    explanation:
        'Le cours cite Cass. crim., 9 janvier 1990 : antériorité nécessaire.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'L’intervalle de temps entre résolution et exécution est :',
    options: [
      'Fixé par la loi',
      'Plus ou moins long, non déterminé',
      'Toujours 24 heures',
    ],
    answer: 'Plus ou moins long, non déterminé',
    explanation: 'Le cours indique que cet intervalle n’est pas déterminé.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Un acte prémédité est :',
    options: [
      'Médité et préparé',
      'Toujours impulsif',
      'Toujours involontaire',
    ],
    answer: 'Médité et préparé',
    explanation: 'Le cours : non spontané, pas une pulsion.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation peut viser :',
    options: [
      'Une infraction commise ou tentée',
      'Uniquement une infraction consommée',
      'Uniquement un crime',
    ],
    answer: 'Une infraction commise ou tentée',
    explanation: 'Le cours : indifféremment commise ou tentée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation se matérialise par :',
    options: [
      'Des faits/circonstances précédant l’acte',
      'Uniquement l’aveu',
      'Uniquement le casier',
    ],
    answer: 'Des faits/circonstances précédant l’acte',
    explanation:
        'Le cours : elle se recherche dans l’intervalle précédant l’acte.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Exemples de matérialisation (cours) :',
    options: [
      'Actes préparatoires, menaces, confidences',
      'Simple maladresse',
      'Oubli involontaire',
    ],
    answer: 'Actes préparatoires, menaces, confidences',
    explanation: 'Exemples cités dans le cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La jurisprudence qualifie parfois la préméditation :',
    options: [
      'Tantôt réelle, tantôt personnelle',
      'Toujours réelle',
      'Toujours personnelle',
    ],
    answer: 'Tantôt réelle, tantôt personnelle',
    explanation: 'Le cours signale des hésitations jurisprudentielles.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Le meurtre avec préméditation est qualifié :',
    options: ['D’assassinat', 'D’homicide involontaire', 'De contravention'],
    answer: 'D’assassinat',
    explanation:
        'Le cours : meurtre + préméditation = assassinat (art. 221-3).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation est une forme de :',
    options: ['Résolution d’agir', 'Force majeure', 'Erreur de droit'],
    answer: 'Résolution d’agir',
    explanation: 'Le cours : elle se traduit par une résolution d’agir.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation exclut en principe :',
    options: ['La spontanéité', 'La préparation', 'La persistance'],
    answer: 'La spontanéité',
    explanation: 'Le cours : l’acte prémédité n’est pas spontané.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Une préparation visant une seule infraction peut suffire :',
    options: [
      'Oui',
      'Non, il faut plusieurs infractions',
      'Seulement pour les contraventions',
    ],
    answer: 'Oui',
    explanation:
        'Le cours : elle vise une infraction commise ou tentée, même unique.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation peut aggraver (cours) :',
    options: ['Le meurtre', 'La diffamation', 'Le recel'],
    answer: 'Le meurtre',
    explanation: 'Champ d’application : meurtre (assassinat).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation peut aussi aggraver :',
    options: ['L’empoisonnement', 'Le stationnement gênant', 'La mendicité'],
    answer: 'L’empoisonnement',
    explanation: 'Le cours : empoisonnement (art. 221-5 al. 3).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation peut être déduite :',
    options: [
      'De la nature complexe de l’acte',
      'Du seul silence de l’auteur',
      'De la tenue vestimentaire',
    ],
    answer: 'De la nature complexe de l’acte',
    explanation:
        'Le cours cite la complexité traduisant une nécessaire préparation.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'Une confidence préalable sur l’intention de commettre l’acte :',
    options: [
      'Peut contribuer à caractériser la préméditation',
      'L’exclut automatiquement',
      'Ne peut jamais être prise en compte',
    ],
    answer: 'Peut contribuer à caractériser la préméditation',
    explanation: 'Le cours cite les confidences parmi les indices.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Préméditation',
    question: 'La préméditation doit être appréciée :',
    options: [
      'Dans l’intervalle précédant l’acte',
      'Uniquement après l’acte',
      'Uniquement au jugement',
    ],
    answer: 'Dans l’intervalle précédant l’acte',
    explanation:
        'Le cours : elle se recherche dans les faits qui précèdent/accompagnent l’acte.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Q041–Q060 — GUET-APENS (art. 132-71-1 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens consiste à :',
    options: [
      'Attendre une ou plusieurs personnes dans un lieu déterminé pour commettre une ou plusieurs infractions',
      'Agir sous ivresse',
      'Entrer par effraction',
    ],
    answer:
        'Attendre une ou plusieurs personnes dans un lieu déterminé pour commettre une ou plusieurs infractions',
    explanation: 'Définition de l’art. 132-71-1 C.P. reprise au cours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens est une circonstance aggravante :',
    options: ['Réelle', 'Personnelle', 'Disciplinaire'],
    answer: 'Réelle',
    explanation:
        'Le cours : circonstance aggravante réelle, étendue à tous les participants.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens est proche de :',
    options: ['L’embuscade', 'La récidive', 'La contrainte'],
    answer: 'L’embuscade',
    explanation: 'Le cours compare guet-apens et embuscade.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Différence principale avec l’embuscade : l’embuscade est :',
    options: [
      'Une infraction autonome',
      'Une simple circonstance aggravante',
      'Une excuse légale',
    ],
    answer: 'Une infraction autonome',
    explanation:
        'Le cours : embuscade = infraction autonome même au stade des actes préparatoires.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'L’article qui définit le guet-apens est :',
    options: ['132-71-1 C.P.', '132-72 C.P.', '132-75 C.P.'],
    answer: '132-71-1 C.P.',
    explanation: 'Référence donnée dans le cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le texte précise une durée minimale d’attente :',
    options: [
      'Oui, 10 minutes',
      'Non, aucune durée minimale n’est précisée',
      'Oui, 24 heures',
    ],
    answer: 'Non, aucune durée minimale n’est précisée',
    explanation: 'Le cours : notion très large, pas de durée minimum fixée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le texte précise la nature du lieu (public/privé) :',
    options: [
      'Oui, uniquement public',
      'Non, il ne précise pas',
      'Oui, uniquement privé',
    ],
    answer: 'Non, il ne précise pas',
    explanation: 'Le cours : pas de précision sur la nature du lieu.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'La qualité de la victime (profession/âge) est :',
    options: ['Indifférente', 'Limitée aux mineurs', 'Limitée aux policiers'],
    answer: 'Indifférente',
    explanation: 'Le cours : “toute personne quelle que soit sa qualité”.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens est une forme particulière de :',
    options: ['Préméditation', 'Vulnérabilité', 'Récidive'],
    answer: 'Préméditation',
    explanation: 'Le cours : forme particulière de préméditation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le but poursuivi est caractérisé par :',
    options: [
      'Des actes préparatoires en relation avec l’infraction',
      'Un accident de parcours',
      'Un simple regret',
    ],
    answer: 'Des actes préparatoires en relation avec l’infraction',
    explanation:
        'Le cours : actes préparatoires déterminent le caractère délibéré du “piège”.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le nombre de victimes possibles est :',
    options: ['Une ou plusieurs', 'Uniquement une', 'Uniquement deux'],
    answer: 'Une ou plusieurs',
    explanation: 'Le cours : “une ou plusieurs personnes”.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens peut aggraver des infractions :',
    options: [
      'Comprises dans une liste prévue par la loi',
      'Toutes infractions sans texte',
      'Uniquement les contraventions',
    ],
    answer: 'Comprises dans une liste prévue par la loi',
    explanation:
        'Le cours : application si la loi a expressément visé les infractions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens peut aggraver :',
    options: ['Le meurtre', 'Le vol simple sans texte', 'La diffamation'],
    answer: 'Le meurtre',
    explanation: 'Le cours : champ d’application inclut le meurtre.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens peut aussi aggraver :',
    options: [
      'Les tortures ou actes de barbarie',
      'Le non-respect d’un feu rouge',
      'Le tapage nocturne',
    ],
    answer: 'Les tortures ou actes de barbarie',
    explanation:
        'Le cours : champ d’application inclut tortures/actes de barbarie.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens peut également aggraver :',
    options: [
      'Certaines violences',
      'Les infractions de presse',
      'Le droit du travail',
    ],
    answer: 'Certaines violences',
    explanation:
        'Le cours : champ d’application inclut violences (articles listés).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens peut aggraver l’empoisonnement :',
    options: ['Oui', 'Non', 'Uniquement si la victime est mineure'],
    answer: 'Oui',
    explanation: 'Le cours : champ d’application inclut l’empoisonnement.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens est apprécié :',
    options: [
      'Après commission ou tentative d’infractions visées',
      'Avant toute infraction',
      'Uniquement au stade civil',
    ],
    answer: 'Après commission ou tentative d’infractions visées',
    explanation:
        'Le cours : la question se pose après commission ou tentative de certaines infractions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens suppose un “lieu déterminé” :',
    options: ['Oui', 'Non', 'Seulement en milieu scolaire'],
    answer: 'Oui',
    explanation: 'Définition : attente dans un lieu déterminé.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Guet-apens',
    question: 'Le guet-apens s’étend aux complices car il est :',
    options: ['Réel', 'Personnel', 'Mixte au sens légal obligatoire'],
    answer: 'Réel',
    explanation:
        'Le cours : circonstance réelle → effets sur auteurs/coauteurs/complices.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Q061–Q080 — BANDE ORGANISÉE (art. 132-71 C.P.)
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée est définie par :',
    options: [
      'L’article 132-71 C.P.',
      'L’article 132-72 C.P.',
      'L’article 132-75 C.P.',
    ],
    answer: 'L’article 132-71 C.P.',
    explanation:
        'Le cours indique que l’article 132-71 du code pénal définit la bande organisée.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'Constitue une bande organisée :',
    options: [
      'Tout groupement/entente en vue de préparer une ou plusieurs infractions, caractérisée par des faits matériels',
      'Toute réunion fortuite',
      'Toute dispute',
    ],
    answer:
        'Tout groupement/entente en vue de préparer une ou plusieurs infractions, caractérisée par des faits matériels',
    explanation: 'Définition légale reprise au cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée est une circonstance :',
    options: ['Réelle', 'Personnelle', 'Uniquement civile'],
    answer: 'Réelle',
    explanation:
        'Le cours : circonstance aggravante réelle, étendue à tous les participants.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée est proche de :',
    options: [
      'L’association de malfaiteurs',
      'La légitime défense',
      'La tentative',
    ],
    answer: 'L’association de malfaiteurs',
    explanation: 'Le cours rapproche les deux notions.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'Différence majeure : l’association de malfaiteurs est :',
    options: [
      'Une infraction autonome',
      'Une simple circonstance aggravante',
      'Une contravention',
    ],
    answer: 'Une infraction autonome',
    explanation:
        'Le cours : association de malfaiteurs = infraction autonome même au stade préparatoire.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée se pose :',
    options: [
      'Après commission ou tentative de certaines infractions',
      'Avant tout acte',
      'Uniquement en matière civile',
    ],
    answer: 'Après commission ou tentative de certaines infractions',
    explanation:
        'Le cours précise que la question se pose après commission ou tentative.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée est une forme particulière de :',
    options: ['Préméditation', 'Vulnérabilité', 'Récidive'],
    answer: 'Préméditation',
    explanation: 'Le cours : forme particulière de préméditation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'À la différence de la réunion, la bande organisée suppose :',
    options: [
      'Une préparation par des moyens matériels',
      'Un hasard complet',
      'Une absence de concertation',
    ],
    answer: 'Une préparation par des moyens matériels',
    explanation:
        'Le cours cite Cass. crim., 14 mai 1993 : moyens matériels impliquant organisation.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La réunion a un caractère :',
    options: [
      'Fortuit et occasionnel',
      'Toujours planifié',
      'Toujours hiérarchisé',
    ],
    answer: 'Fortuit et occasionnel',
    explanation: 'Le cours : réunion = concertation simple sans préméditation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'Condition : il faut une résolution d’agir en commun :',
    options: [
      'Antérieure à l’action',
      'Postérieure à l’action',
      'Sans importance',
    ],
    answer: 'Antérieure à l’action',
    explanation:
        'Le cours : résolution d’agir en commun antérieure à l’action.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée implique :',
    options: ['Un plan concerté', 'Une impulsion', 'Une erreur'],
    answer: 'Un plan concerté',
    explanation:
        'Le cours cite Cass. crim., 30 novembre 2005 : “plan concerté”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question:
        'Une organisation “structurée et hiérarchisée” est un indice de :',
    options: ['Bande organisée', 'Réunion', 'Contravention'],
    answer: 'Bande organisée',
    explanation:
        'Le cours cite la nécessité d’une organisation structurée et hiérarchisée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question:
        'La bande organisée nécessite de démontrer une participation continuelle :',
    options: ['Non', 'Oui toujours', 'Oui uniquement pour les crimes'],
    answer: 'Non',
    explanation:
        'Le cours : pas nécessaire de démontrer une participation continuelle à l’organisation.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question:
        'Le nombre de personnes nécessaire est fixé par la jurisprudence :',
    options: [
      'Oui, exactement 5',
      'Non, pas de nombre fixé',
      'Oui, exactement 2',
    ],
    answer: 'Non, pas de nombre fixé',
    explanation:
        'Le cours : la jurisprudence ne se prononce pas sur un nombre précis.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question:
        'Selon le cours, pour constituer une bande organisée, il est nécessaire d’être :',
    options: ['Plus de deux', 'Seul', 'Exactement deux'],
    answer: 'Plus de deux',
    explanation: 'Le cours précise qu’il est nécessaire d’être plus de deux.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La Convention ONU évoquée parle d’un groupe de :',
    options: ['Trois personnes ou plus', 'Deux personnes', 'Une personne'],
    answer: 'Trois personnes ou plus',
    explanation:
        'Le cours cite la définition ONU : groupe structuré de trois personnes ou plus.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La seule constitution d’une équipe peut être insuffisante si :',
    options: [
      'Absence de structure existant depuis un certain temps',
      'Présence d’un chef',
      'Présence d’un véhicule',
    ],
    answer: 'Absence de structure existant depuis un certain temps',
    explanation:
        'Le cours cite Cass. crim., 8 juillet 2015 : critère de structure dans le temps.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'Les actes préparatoires peuvent être :',
    options: [
      'Acquisition de matériel / recrutement / plan d’exécution',
      'Uniquement un aveu',
      'Uniquement une plainte',
    ],
    answer: 'Acquisition de matériel / recrutement / plan d’exécution',
    explanation: 'Le cours donne ces exemples d’actes préparatoires.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée peut aggraver (exemple du cours) :',
    options: [
      'Le vol',
      'Le divorce',
      'Le non-respect d’une limitation de vitesse',
    ],
    answer: 'Le vol',
    explanation:
        'Le cours liste le vol (art. 311-9) parmi les infractions aggravées.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Bande organisée',
    question: 'La bande organisée peut aussi aggraver :',
    options: ['L’escroquerie', 'La diffamation', 'Le tapage'],
    answer: 'L’escroquerie',
    explanation: 'Le cours : escroquerie (art. 313-2) dans la liste.',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Q081–Q100 — ARME + ESCALADE
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Selon l’art. 132-75, est une arme :',
    options: [
      'Tout objet conçu pour tuer ou blesser',
      'Tout objet métallique',
      'Tout objet volumineux',
    ],
    answer: 'Tout objet conçu pour tuer ou blesser',
    explanation: 'Le cours : arme par nature (alinéa 1).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Les armes par nature comprennent notamment :',
    options: [
      'Armes à feu et engins explosifs/incendiaires',
      'Uniquement des outils',
      'Uniquement des véhicules',
    ],
    answer: 'Armes à feu et engins explosifs/incendiaires',
    explanation:
        'Le cours cite armes à feu, engins explosifs/incendiaires, gaz toxiques.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Les armes blanches (cours) incluent :',
    options: [
      'Poignards, matraques',
      'Téléphones, ordinateurs',
      'Clés USB, cartes bancaires',
    ],
    answer: 'Poignards, matraques',
    explanation:
        'Le cours cite des exemples d’armes blanches tranchantes/perçantes/contondantes.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Une arme par destination est :',
    options: [
      'Un objet du quotidien utilisé pour tuer/blesser/menacer',
      'Un objet conçu pour tuer',
      'Un objet purement décoratif',
    ],
    answer: 'Un objet du quotidien utilisé pour tuer/blesser/menacer',
    explanation:
        'Le cours : assimilation si objet susceptible de danger est utilisé/destiné à tuer/blesser/menacer.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Un véhicule automobile utilisé pour blesser peut être :',
    options: [
      'Une arme par destination',
      'Jamais une arme',
      'Uniquement une arme factice',
    ],
    answer: 'Une arme par destination',
    explanation:
        'Le cours cite le véhicule automobile comme exemple d’arme par destination.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Une arme factice est assimilée si elle :',
    options: [
      'Crée une confusion par ressemblance et sert à menacer',
      'Est seulement en plastique',
      'Est cachée chez soi',
    ],
    answer: 'Crée une confusion par ressemblance et sert à menacer',
    explanation:
        'Le cours : ressemblance de nature à créer confusion + usage/destination pour menacer.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'L’utilisation d’un animal pour menacer est :',
    options: [
      'Assimilée à l’usage d’une arme',
      'Sans effet',
      'Une circonstance personnelle',
    ],
    answer: 'Assimilée à l’usage d’une arme',
    explanation:
        'Le cours : l’utilisation d’un animal pour tuer/blesser/menacer est assimilée à une arme.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'La circonstance “arme” est :',
    options: ['Réelle', 'Personnelle', 'Une excuse légale'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Pour l’usage/menace d’arme, il faut :',
    options: [
      'Que l’arme soit utilisée pour tuer/blesser/menacer',
      'Seulement posséder l’arme',
      'Seulement l’avoir achetée',
    ],
    answer: 'Que l’arme soit utilisée pour tuer/blesser/menacer',
    explanation:
        'Le cours : être porteur ne suffit pas, il faut usage pour tuer/blesser/menacer.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Pour le port d’arme, il suffit :',
    options: [
      'D’être porteur d’une arme apparente ou cachée',
      'D’avoir menacé avec l’arme',
      'D’avoir blessé avec l’arme',
    ],
    answer: 'D’être porteur d’une arme apparente ou cachée',
    explanation: 'Le cours : port apparente ou cachée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Port ou usage d’une arme',
    question: 'Le port illégal d’arme est :',
    options: [
      'Une infraction autonome possible',
      'Toujours une circonstance aggravante',
      'Toujours dépénalisé',
    ],
    answer: 'Une infraction autonome possible',
    explanation:
        'Le cours : l’arme peut aussi constituer l’élément matériel d’infractions autonomes (ex. port illégal).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'L’escalade est :',
    options: [
      'S’introduire par-dessus une clôture ou par une ouverture non destinée à servir d’entrée',
      'Forcer une serrure',
      'Entrer avec autorisation',
    ],
    answer:
        'S’introduire par-dessus une clôture ou par une ouverture non destinée à servir d’entrée',
    explanation: 'Définition de l’art. 132-74 reprise au cours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'L’escalade est une circonstance :',
    options: ['Réelle', 'Personnelle', 'Exclusivement civile'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Elle suppose un endroit :',
    options: ['Clos', 'Toujours ouvert', 'Virtuel uniquement'],
    answer: 'Clos',
    explanation:
        'Le cours : endroit clos dont l’accès est interdit aux tiers par une clôture.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Le moyen utilisé (échelle, corde…) :',
    options: ['Importe peu', 'Doit être une échelle', 'Doit être un grappin'],
    answer: 'Importe peu',
    explanation: 'Le cours : moyen prévu, improvisé ou trouvé par hasard.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Entrer par une fenêtre peut relever de :',
    options: ['L’escalade', 'La cryptologie', 'La vulnérabilité'],
    answer: 'L’escalade',
    explanation:
        'Le cours : issue non destinée à servir d’entrée (fenêtre, soupirail…).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'La circonstance d’escalade se réalise :',
    options: [
      'De l’extérieur vers l’intérieur',
      'De l’intérieur vers l’extérieur',
      'Dans les deux sens indifféremment',
    ],
    answer: 'De l’extérieur vers l’intérieur',
    explanation:
        'Le cours : “s’introduire…”, donc de l’extérieur vers l’intérieur.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'Comme l’effraction, l’escalade implique :',
    options: [
      'Un moyen illicite pour pénétrer dans un lieu clos',
      'Une autorisation de la victime',
      'Un mandat',
    ],
    answer: 'Un moyen illicite pour pénétrer dans un lieu clos',
    explanation:
        'Le cours compare escalade et effraction : moyen illicite pour pénétrer.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Escalade',
    question: 'L’escalade peut aggraver :',
    options: ['Le vol', 'Le mariage', 'La grève'],
    answer: 'Le vol',
    explanation: 'Le cours : vol (art. 311-5 3°).',
    difficulty: 'Moyenne',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Q101–Q120 — ITT + MORT + MUTILATION/INFIRMITÉ
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'L’I.T.T. pénale mesure :',
    options: [
      'La gravité des atteintes corporelles ou psychiques',
      'Le salaire perdu',
      'Le nombre de jours d’hospitalisation uniquement',
    ],
    answer: 'La gravité des atteintes corporelles ou psychiques',
    explanation: 'Le cours : l’I.T.T. mesure la gravité des atteintes subies.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'L’I.T.T. pénale ne doit pas être confondue avec :',
    options: [
      'L’arrêt de travail du droit social',
      'La détention provisoire',
      'La prescription',
    ],
    answer: 'L’arrêt de travail du droit social',
    explanation: 'Le cours distingue I.T.T. pénale et arrêt de travail social.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question:
        'Une victime sans activité professionnelle peut avoir une I.T.T. :',
    options: ['Oui', 'Non', 'Uniquement si mineure'],
    answer: 'Oui',
    explanation:
        'Le cours : enfant/retraité… peut se voir prescrire une I.T.T.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'Pour constituer la circonstance, l’incapacité doit être :',
    options: ['Totale', 'Partielle', 'Mentale uniquement'],
    answer: 'Totale',
    explanation:
        'Le cours : l’I.T.T. doit être totale pour constituer la circonstance.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'L’I.T.T. s’étend :',
    options: [
      'À l’activité courante et aux efforts de la vie quotidienne',
      'Uniquement au travail salarié',
      'Uniquement au sport',
    ],
    answer: 'À l’activité courante et aux efforts de la vie quotidienne',
    explanation:
        'Le cours (jurisprudence) : s’étend à toute l’activité courante.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'La durée de l’I.T.T. est prise en compte par :',
    options: ['Paliers', 'Pourcentage fixe', 'Appréciation libre sans seuil'],
    answer: 'Paliers',
    explanation: 'Le cours : paliers (≤8j, >8j, ≤3 mois, >3 mois).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'La preuve de l’I.T.T. est rapportée :',
    options: ['Par la partie poursuivante', 'Par l’auteur', 'Par la presse'],
    answer: 'Par la partie poursuivante',
    explanation:
        'Le cours : la preuve doit être rapportée par la partie poursuivante.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — I.T.T.',
    question: 'Le juge peut se baser sur :',
    options: [
      'Certificats médicaux et rapports d’experts',
      'Uniquement l’aveu',
      'Uniquement la plainte',
    ],
    answer: 'Certificats médicaux et rapports d’experts',
    explanation:
        'Le cours : certificats et expertises, avec pouvoir d’appréciation du juge.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — La mort',
    question:
        'La circonstance “ayant entraîné la mort sans intention de la donner” suppose :',
    options: [
      'Absence d’intention homicide',
      'Intention de tuer',
      'Préméditation obligatoire',
    ],
    answer: 'Absence d’intention homicide',
    explanation:
        'Le cours : l’auteur n’a jamais voulu donner volontairement la mort.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — La mort',
    question: 'La circonstance “mort” est :',
    options: ['Réelle', 'Personnelle', 'Toujours mixte'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle, effets étendus.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — La mort',
    question: 'Condition essentielle : il faut une relation :',
    options: [
      'De cause à effet entre l’acte et le décès',
      'De parenté',
      'De voisinage',
    ],
    answer: 'De cause à effet entre l’acte et le décès',
    explanation:
        'Le cours cite Cass. crim., 17 janvier 1991 : relation de cause à effet.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — La mort',
    question: 'L’état préexistant de la victime (santé fragile) est :',
    options: ['Indifférent', 'Excluant la circonstance', 'Toujours atténuant'],
    answer: 'Indifférent',
    explanation:
        'Le cours : circonstance retenue même si l’état a concouru au décès.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — La mort',
    question: 'Cette circonstance peut aggraver :',
    options: [
      'Certaines violences',
      'Uniquement le vol',
      'Uniquement la diffamation',
    ],
    answer: 'Certaines violences',
    explanation: 'Le cours liste des violences ayant entraîné la mort.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'La mutilation correspond à :',
    options: [
      'Perte/ablation d’un membre ou partie externe avec atteinte irréversible',
      'Une douleur passagère',
      'Une simple peur',
    ],
    answer:
        'Perte/ablation d’un membre ou partie externe avec atteinte irréversible',
    explanation:
        'Le cours reprend la définition (Robert) : atteinte irréversible à l’intégrité physique.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'L’infirmité permanente est :',
    options: [
      'Une atteinte majeure et irréversible d’un membre ou d’une fonction',
      'Une ITT de 2 jours',
      'Un simple stress',
    ],
    answer:
        'Une atteinte majeure et irréversible d’un membre ou d’une fonction',
    explanation:
        'Le cours cite Cass. crim., 24 nov. 2021 : atteinte majeure et irréversible.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'L’infirmité peut être :',
    options: [
      'Physique ou mentale/intellectuelle',
      'Uniquement physique',
      'Uniquement professionnelle',
    ],
    answer: 'Physique ou mentale/intellectuelle',
    explanation:
        'Le cours : l’infirmité peut affecter aussi les facultés mentales/intellectuelles.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'Le caractère permanent de l’infirmité signifie :',
    options: ['Irréversible/définitif', 'Temporaire', 'Réversible'],
    answer: 'Irréversible/définitif',
    explanation:
        'Le cours : infirmité doit être irréversible ou définitive (jurisprudence citée).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'La preuve est rapportée par :',
    options: [
      'Tout moyen (certificats/expertises)',
      'Uniquement vidéosurveillance',
      'Uniquement confession',
    ],
    answer: 'Tout moyen (certificats/expertises)',
    explanation: 'Le cours : preuve par certificats médicaux ou expertises.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Mutilation ou infirmité permanente',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Exclusivement administrative'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle, effets étendus.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Q121–Q140 — VULNÉRABILITÉ + MINORITÉ 15 ANS + PROSTITUTION
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'La vulnérabilité particulière vise :',
    options: [
      'La protection des victimes hors d’état de se protéger',
      'Uniquement les mineurs',
      'Uniquement les policiers',
    ],
    answer: 'La protection des victimes hors d’état de se protéger',
    explanation:
        'Le cours : elle protège les victimes en situation de faiblesse.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'Les causes de vulnérabilité sont :',
    options: ['Limitatives', 'Illimitées', 'Au choix du juge sans texte'],
    answer: 'Limitatives',
    explanation:
        'Le cours précise qu’elles sont limitatives (au nombre de sept).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'La vulnérabilité doit être :',
    options: [
      'Apparente ou connue de l’auteur',
      'Ignorée de l’auteur',
      'Toujours supposée',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation:
        'Le cours : condition d’apparence ou de connaissance par l’auteur.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'La vulnérabilité doit résulter :',
    options: [
      'D’un état préexistant aux faits',
      'Uniquement des blessures causées',
      'D’une plainte tardive',
    ],
    answer: 'D’un état préexistant aux faits',
    explanation:
        'Le cours (jurisprudence) : vulnérabilité préexistante, pas conséquence des faits.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'Concernant l’âge, le cours précise que :',
    options: [
      'La minorité de 15 ans est une aggravation spécifique distincte',
      'Tout mineur est automatiquement vulnérable',
      'L’âge ne compte jamais',
    ],
    answer: 'La minorité de 15 ans est une aggravation spécifique distincte',
    explanation:
        'Le cours : la minorité de 15 ans ne rentre pas dans ce champ car aggravation spécifique.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'Le seul grand âge suffit à caractériser la vulnérabilité :',
    options: [
      'Non, il faut prouver une vulnérabilité particulière',
      'Oui, toujours',
      'Oui, si l’auteur est mineur',
    ],
    answer: 'Non, il faut prouver une vulnérabilité particulière',
    explanation:
        'Le cours cite la jurisprudence : l’âge ne suffit pas sans autres constatations.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'La maladie/infirmité/déficience concerne :',
    options: [
      'Dysfonctionnements corporels/mentaux innés ou acquis',
      'Uniquement fractures',
      'Uniquement maladies contagieuses',
    ],
    answer: 'Dysfonctionnements corporels/mentaux innés ou acquis',
    explanation:
        'Le cours : dysfonctionnements corporels, physiques ou mentaux, innés ou acquis.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'L’état de grossesse peut entraîner une vulnérabilité :',
    options: [
      'Pendant et aussi après l’accouchement',
      'Uniquement avant 3 mois',
      'Jamais',
    ],
    answer: 'Pendant et aussi après l’accouchement',
    explanation:
        'Le cours : vulnérabilité possible pendant la grossesse et après l’accouchement.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'La précarité économique/sociale se définit comme :',
    options: [
      'Absence d’une ou plusieurs sécurités (notamment emploi) fragilisant la situation',
      'Simple choix de vie',
      'Un niveau d’études faible',
    ],
    answer:
        'Absence d’une ou plusieurs sécurités (notamment emploi) fragilisant la situation',
    explanation:
        'Le cours donne une définition inspirée : absence de sécurités, notamment emploi.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Vulnérabilité particulière',
    question: 'La vulnérabilité est une circonstance :',
    options: ['Réelle', 'Personnelle', 'Toujours mixte'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle, effets étendus.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question: 'La “minorité de quinze ans” vise :',
    options: [
      'Un mineur de 15 ans (âge accompli)',
      'Un mineur de 18 ans',
      'Un mineur de 13 ans seulement',
    ],
    answer: 'Un mineur de 15 ans (âge accompli)',
    explanation: 'Le cours : c’est l’âge de 15 ans accompli qui est la limite.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question: 'L’âge pris en compte est celui :',
    options: [
      'Au moment des faits',
      'Au moment du jugement',
      'Au moment de la plainte',
    ],
    answer: 'Au moment des faits',
    explanation:
        'Le cours cite Cass. crim., 21 mars 1957 : âge au moment des faits.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question: 'Le calcul de l’âge se fait :',
    options: ['D’heure à heure', 'Par année civile', 'Par trimestre'],
    answer: 'D’heure à heure',
    explanation:
        'Le cours cite Cass. crim., 3 septembre 1985 : calcul d’heure à heure.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question: 'À défaut d’acte probant, la preuve de l’âge se fait :',
    options: [
      'Par tout moyen',
      'Uniquement par passeport',
      'Uniquement par témoignage',
    ],
    answer: 'Par tout moyen',
    explanation:
        'Le cours cite Cass. crim., 17 juillet 1991 : preuve par tout moyen.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question: 'La minorité de 15 ans doit être apparente/connue de l’auteur :',
    options: [
      'Non, ce n’est pas exigé',
      'Oui, toujours',
      'Oui, uniquement pour les délits',
    ],
    answer: 'Non, ce n’est pas exigé',
    explanation:
        'Le cours : pas d’exigence d’apparence ou de connaissance pour cette circonstance.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Minorité de quinze ans',
    question: 'La minorité de 15 ans est une circonstance :',
    options: ['Réelle', 'Personnelle', 'Exclusivement civile'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle, effets étendus.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Une excuse légale'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle, effets étendus.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: '“Se livrer à la prostitution” implique :',
    options: [
      'Rapports sexuels contre rémunération',
      'Simple relation affective',
      'Simple cohabitation',
    ],
    answer: 'Rapports sexuels contre rémunération',
    explanation:
        'Le cours : existence de rapports sexuels contre rémunération.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'La prostitution peut être :',
    options: ['Occasionnelle', 'Uniquement habituelle', 'Uniquement déclarée'],
    answer: 'Occasionnelle',
    explanation: 'Le cours : un acte unique peut suffire.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime se livrant à la prostitution',
    question: 'Les faits doivent être commis :',
    options: [
      'Dans l’exercice de cette activité',
      'Sans lien avec l’activité',
      'Uniquement après l’activité',
    ],
    answer: 'Dans l’exercice de cette activité',
    explanation:
        'Le cours : exclus les faits sans lien avec l’activité prostitutionnelle.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Q141–Q160 — RÉSEAU DE COMMUNICATION ÉLECTRONIQUE + CRYPTOLOGIE
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Cette circonstance vise l’utilisation :',
    options: [
      'D’un réseau pour diffuser des messages à un public non déterminé',
      'D’un courrier papier',
      'D’un appel à une personne identifiée uniquement',
    ],
    answer: 'D’un réseau pour diffuser des messages à un public non déterminé',
    explanation:
        'Le cours : diffusion de messages à destination d’un public non déterminé via réseau électronique.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Elle est une circonstance :',
    options: ['Réelle', 'Personnelle', 'Exclusivement civile'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle, effets étendus.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'La formule “public non déterminé” exclut :',
    options: [
      'L’envoi d’un même email à plusieurs personnes identifiées',
      'La publication sur Internet',
      'La diffusion sur un forum public',
    ],
    answer: 'L’envoi d’un même email à plusieurs personnes identifiées',
    explanation:
        'Le cours précise que cette formule exclut cet envoi ciblé à personnes identifiées.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Le réseau de communication électronique visé est :',
    options: [
      'Internet et le réseau téléphonique',
      'Uniquement la radio',
      'Uniquement la télévision',
    ],
    answer: 'Internet et le réseau téléphonique',
    explanation: 'Le cours : internet + réseau téléphonique.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Cette circonstance vise :',
    options: [
      'Mineurs et majeurs',
      'Uniquement les mineurs',
      'Uniquement les majeurs',
    ],
    answer: 'Mineurs et majeurs',
    explanation: 'Le cours : vise mineurs et majeurs.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Le développement d’Internet a rendu certaines infractions :',
    options: [
      'Plus faciles à commettre et plus difficiles à sanctionner',
      'Toujours impossibles',
      'Toujours locales et simples',
    ],
    answer: 'Plus faciles à commettre et plus difficiles à sanctionner',
    explanation:
        'Le cours souligne la facilité de contact massif et la difficulté d’identification.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Ces procédés peuvent induire :',
    options: [
      'Une internationalisation des délits',
      'Une disparition des preuves',
      'Une dépénalisation automatique',
    ],
    answer: 'Une internationalisation des délits',
    explanation: 'Le cours mentionne l’internationalisation des délits.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Cette circonstance peut aggraver (cours) :',
    options: ['Le harcèlement moral', 'Le stationnement', 'La chasse'],
    answer: 'Le harcèlement moral',
    explanation:
        'Le cours : harcèlement moral (art. 222-33-2-2, 4°) figure dans la liste.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Cette circonstance peut aussi aggraver :',
    options: [
      'La corruption de mineurs',
      'Le tapage',
      'La contravention de 1re classe',
    ],
    answer: 'La corruption de mineurs',
    explanation:
        'Le cours : corruption de mineurs (art. 227-22) figure dans la liste.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Réseau de communication électronique',
    question: 'Elle peut également aggraver :',
    options: [
      'La diffusion/fixation d’images pornographiques de mineur',
      'Le divorce',
      'La vente d’alcool',
    ],
    answer: 'La diffusion/fixation d’images pornographiques de mineur',
    explanation: 'Le cours : art. 227-23 figure dans la liste.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'L’utilisation d’un moyen de cryptologie est prévue par :',
    options: ['Art. 132-79 C.P.', 'Art. 132-77 C.P.', 'Art. 132-74 C.P.'],
    answer: 'Art. 132-79 C.P.',
    explanation: 'Le cours : article 132-79 du code pénal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Disciplinaire'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Le moyen de cryptologie sert principalement à garantir :',
    options: [
      'La confidentialité des communications/données',
      'La publicité des données',
      'La suppression des données',
    ],
    answer: 'La confidentialité des communications/données',
    explanation: 'Le cours : confidentialité, authentification, intégrité.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'L’article 132-79 a une portée :',
    options: [
      'Générale (tous crimes et délits, commis ou tentés)',
      'Limitée aux infractions sexuelles',
      'Limitée aux crimes',
    ],
    answer: 'Générale (tous crimes et délits, commis ou tentés)',
    explanation:
        'Le cours : portée générale, s’applique à tous crimes et délits.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Cette circonstance ne s’applique pas si l’auteur/complice :',
    options: [
      'Remet la version en clair et les conventions secrètes nécessaires',
      'Détruit son téléphone',
      'Explique oralement les faits',
    ],
    answer: 'Remet la version en clair et les conventions secrètes nécessaires',
    explanation:
        'Le cours : exception si remise aux autorités de la version en clair + conventions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question:
        'Un téléphone équipé d’un moyen de cryptologie + code de déverrouillage :',
    options: [
      'Peut constituer une clé de déchiffrement',
      'N’a jamais de lien',
      'Transforme l’infraction en contravention',
    ],
    answer: 'Peut constituer une clé de déchiffrement',
    explanation: 'Le cours cite Cass. crim., 11 octobre 2020.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question:
        'L’objectif de cette aggravation est de réprimer plus sévèrement :',
    options: [
      'L’usage de moyens assurant la confidentialité pour préparer/faciliter/commettre',
      'Le simple achat d’un téléphone',
      'Le simple silence en audition',
    ],
    answer:
        'L’usage de moyens assurant la confidentialité pour préparer/faciliter/commettre',
    explanation:
        'Le cours : réprimer l’usage de moyens techniques de confidentialité.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'Un “moyen de cryptologie” peut être :',
    options: [
      'Matériel ou logiciel conçu/modifié pour transformer des données via conventions secrètes',
      'Uniquement une clé physique',
      'Uniquement une signature manuscrite',
    ],
    answer:
        'Matériel ou logiciel conçu/modifié pour transformer des données via conventions secrètes',
    explanation:
        'Le cours reprend la définition de l’art. 29 de la loi du 21 juin 2004.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Cryptologie',
    question: 'La cryptologie vise notamment :',
    options: [
      'Stockage ou transmission des données (confidentialité/authentification/intégrité)',
      'Uniquement la vitesse internet',
      'Uniquement le graphisme',
    ],
    answer:
        'Stockage ou transmission des données (confidentialité/authentification/intégrité)',
    explanation:
        'Le cours : sécurité du stockage/transmission, confidentialité/authentification/intégrité.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Conjoint/concubin/PACS (auteur)',
    question: 'Cette circonstance est définie par :',
    options: ['Art. 132-80 C.P.', 'Art. 132-75 C.P.', 'Art. 132-72 C.P.'],
    answer: 'Art. 132-80 C.P.',
    explanation: 'Le cours : article 132-80 du code pénal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Conjoint/concubin/PACS (auteur)',
    question: 'Elle est une circonstance aggravante :',
    options: ['Personnelle', 'Réelle', 'Disciplinaire'],
    answer: 'Personnelle',
    explanation:
        'Le cours : circonstance aggravante personnelle, non étendue aux coauteurs.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Conjoint/concubin/PACS (auteur)',
    question: 'Elle s’applique même si les personnes :',
    options: [
      'Ne cohabitent pas',
      'Cohabitent obligatoirement',
      'Sont seulement voisines',
    ],
    answer: 'Ne cohabitent pas',
    explanation: 'Le cours : y compris lorsqu’ils ne cohabitent pas.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Conjoint/concubin/PACS (auteur)',
    question: 'Elle peut aussi être constituée par :',
    options: [
      'L’ancien conjoint/concubin/partenaire',
      'Uniquement le conjoint actuel',
      'Uniquement les fiancés',
    ],
    answer: 'L’ancien conjoint/concubin/partenaire',
    explanation:
        'Le cours : le texte vise aussi l’ancien conjoint/concubin/partenaire.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Conjoint/concubin/PACS (auteur)',
    question:
        'Pour l’ancien conjoint/concubin/partenaire, il faut que l’infraction soit commise :',
    options: [
      'En raison des relations ayant existé',
      'Par hasard',
      'Uniquement en état d’ivresse',
    ],
    answer: 'En raison des relations ayant existé',
    explanation:
        'Le cours : condition du mobile (lien avec la relation passée).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Conjoint/concubin/PACS (auteur)',
    question: 'Le concubinage est défini par le code civil comme :',
    options: [
      'Union de fait avec vie commune stable et continue',
      'Mariage religieux',
      'Colocation temporaire',
    ],
    answer: 'Union de fait avec vie commune stable et continue',
    explanation: 'Le cours reprend l’art. 515-8 du code civil.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Conjoint/concubin/PACS (auteur)',
    question: 'Le PACS est :',
    options: [
      'Un contrat pour organiser la vie commune',
      'Un simple engagement moral',
      'Un mariage',
    ],
    answer: 'Un contrat pour organiser la vie commune',
    explanation: 'Le cours reprend l’art. 515-1 du code civil.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur la victime',
    question: 'Cette circonstance est :',
    options: ['Personnelle', 'Réelle', 'Toujours mixte'],
    answer: 'Personnelle',
    explanation:
        'Le cours : circonstance aggravante personnelle, non étendue aux coauteurs.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur la victime',
    question: 'Ascendants visés :',
    options: [
      'Père, mère, aïeux/aïeules (légitimes/naturels/adoptifs)',
      'Frères et sœurs',
      'Cousins uniquement',
    ],
    answer: 'Père, mère, aïeux/aïeules (légitimes/naturels/adoptifs)',
    explanation:
        'Le cours : ascendants directs, légitimes, naturels ou adoptifs.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur la victime',
    question: 'L’autorité peut être :',
    options: [
      'De droit ou de fait',
      'Uniquement de droit',
      'Uniquement de fait',
    ],
    answer: 'De droit ou de fait',
    explanation:
        'Le cours : tuteur (droit) ou autorité de fait permanente/discontinue.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur ascendant ou autorité sur la victime',
    question: 'Exemple d’autorité de fait (cours) :',
    options: [
      'Concubin de la mère/second mari/cohabitation',
      'Boulanger du quartier',
      'Passant',
    ],
    answer: 'Concubin de la mère/second mari/cohabitation',
    explanation: 'Le cours cite ces exemples d’autorité de fait.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: '“Abusant de l’autorité que lui confèrent ses fonctions” est :',
    options: ['Personnelle', 'Réelle', 'Une cause d’exemption'],
    answer: 'Personnelle',
    explanation: 'Le cours : circonstance aggravante personnelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Les fonctions exercées peuvent être :',
    options: [
      'Publiques ou privées',
      'Uniquement publiques',
      'Uniquement privées',
    ],
    answer: 'Publiques ou privées',
    explanation: 'Le cours : fonctions publiques ou privées.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'Exemples de personnes concernées (cours) :',
    options: [
      'Professeurs, médecins, prêtres, marabouts',
      'Uniquement ascendants',
      'Uniquement policiers',
    ],
    answer: 'Professeurs, médecins, prêtres, marabouts',
    explanation: 'Le cours donne ces exemples.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur abusant de son autorité',
    question: 'La condition centrale est :',
    options: [
      'L’abus de l’autorité pour commettre l’acte',
      'Le simple fait d’avoir une fonction',
      'La présence d’une arme',
    ],
    answer: 'L’abus de l’autorité pour commettre l’acte',
    explanation:
        'Le cours : aggravation encourue lorsque l’auteur abuse de l’autorité.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique/mission service public',
    question: 'Cette circonstance (auteur DAP/MSP) est :',
    options: ['Personnelle', 'Réelle', 'Une excuse légale'],
    answer: 'Personnelle',
    explanation:
        'Le cours : circonstance aggravante personnelle, non étendue aux coauteurs.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique/mission service public',
    question: 'Dépositaire de l’autorité publique =',
    options: [
      'Pouvoir de décision fondé sur une parcelle d’autorité publique',
      'Simple emploi privé',
      'Simple notoriété',
    ],
    answer: 'Pouvoir de décision fondé sur une parcelle d’autorité publique',
    explanation:
        'Le cours donne cette définition (policiers, gendarmes, douaniers, huissiers…).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique/mission service public',
    question: '“Dans l’exercice ou à l’occasion de l’exercice” signifie :',
    options: [
      'En service ou du fait des fonctions',
      'Uniquement en dehors du service',
      'Uniquement dans un tribunal',
    ],
    answer: 'En service ou du fait des fonctions',
    explanation:
        'Le cours : dans l’exercice (en service) ou à l’occasion/du fait des fonctions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Auteur dépositaire autorité publique/mission service public',
    question: 'La “mission de service public” (cours) vise :',
    options: [
      'Un service quelconque, temporaire ou permanent, sans parcelle d’autorité publique',
      'Uniquement les policiers',
      'Uniquement les élus',
    ],
    answer:
        'Un service quelconque, temporaire ou permanent, sans parcelle d’autorité publique',
    explanation:
        'Le cours reprend la définition de la circulaire du 14 mai 1993.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // Q181–Q200 — VICTIMES PROTÉGÉES (DAP/MSP) + PROCHES + TÉMOIN/VICTIME/PC + IVRESSE
  //////////////////////////////////////////////////////////////////////////////
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire de l’autorité publique',
    question: 'Cette circonstance est :',
    options: ['Réelle', 'Personnelle', 'Disciplinaire'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle, effets étendus.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire de l’autorité publique',
    question: 'Pour la retenir, il faut un lien :',
    options: [
      'Direct avec la fonction',
      'Avec la nationalité',
      'Avec le domicile',
    ],
    answer: 'Direct avec la fonction',
    explanation:
        'Le cours : l’infraction doit être en rapport direct avec la fonction.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Victime dépositaire de l’autorité publique',
    question: 'La qualité de la victime doit être :',
    options: [
      'Apparente ou connue de l’auteur',
      'Toujours ignorée',
      'Sans importance',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation: 'Le cours : condition d’apparence/connaissance.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Victime mission de service public',
    question: 'Cette circonstance (victime MSP) est :',
    options: ['Réelle', 'Personnelle', 'Une excuse légale'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Victime mission de service public',
    question: 'Elle protège notamment :',
    options: [
      'Enseignants/personnels scolaires, agents transport public, professionnels de santé',
      'Uniquement magistrats',
      'Uniquement militaires',
    ],
    answer:
        'Enseignants/personnels scolaires, agents transport public, professionnels de santé',
    explanation: 'Le cours détaille ces catégories.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Victime mission de service public',
    question: 'La victime doit être atteinte :',
    options: [
      'Dans l’exercice de ses fonctions',
      'Uniquement en congé',
      'Uniquement à domicile',
    ],
    answer: 'Dans l’exercice de ses fonctions',
    explanation:
        'Le cours : victime en service ou effectuant un acte entrant dans ses attributions.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Victime mission de service public',
    question: 'La qualité doit être :',
    options: [
      'Apparente ou connue de l’auteur',
      'Toujours inconnue',
      'Jamais exigée',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation: 'Le cours : condition identique (apparente/connue).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Cette circonstance (proches) est :',
    options: ['Réelle', 'Personnelle', 'Disciplinaire'],
    answer: 'Réelle',
    explanation: 'Le cours : circonstance aggravante réelle, effets étendus.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Sont visés notamment :',
    options: [
      'Conjoint, ascendants, descendants, ou personne vivant habituellement au domicile',
      'Uniquement les enfants',
      'Uniquement les parents',
    ],
    answer:
        'Conjoint, ascendants, descendants, ou personne vivant habituellement au domicile',
    explanation:
        'Le cours énumère ces liens et la personne vivant habituellement au domicile.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Condition essentielle : faits commis :',
    options: [
      'En raison des fonctions exercées par le proche',
      'Par hasard',
      'Uniquement la nuit',
    ],
    answer: 'En raison des fonctions exercées par le proche',
    explanation:
        'Le cours : l’infraction principale doit être commise en raison des fonctions du proche.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Proches d’une personne protégée',
    question: 'Cela implique que l’auteur :',
    options: [
      'Connaissait la qualité du proche',
      'Ignorait la qualité du proche',
      'N’avait aucun mobile',
    ],
    answer: 'Connaissait la qualité du proche',
    explanation:
        'Le cours : condition de connaissance de la qualité du proche.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Cette circonstance est de nature :',
    options: ['Personnelle', 'Réelle', 'Toujours mixte'],
    answer: 'Personnelle',
    explanation:
        'Le cours : dépend de l’intention de l’auteur et du but poursuivi.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Elle vise à préserver :',
    options: [
      'Le bon fonctionnement de la justice',
      'La liberté contractuelle',
      'Le secret médical',
    ],
    answer: 'Le bon fonctionnement de la justice',
    explanation:
        'Le cours : pressions sur témoins/parties menacent l’administration de la justice.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Intention “préventive” :',
    options: [
      'Empêcher de dénoncer/porter plainte/déposer',
      'Se venger après déposition',
      'Réparer un dommage',
    ],
    answer: 'Empêcher de dénoncer/porter plainte/déposer',
    explanation:
        'Le cours : empêcher, contraindre à retirer plainte, influencer déclarations.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Témoin/victime/partie civile',
    question: 'Intention “répressive” :',
    options: [
      'Vengeance en raison d’une dénonciation/plainte/déposition',
      'Empêcher avant plainte',
      'Erreur matérielle',
    ],
    answer: 'Vengeance en raison d’une dénonciation/plainte/déposition',
    explanation: 'Le cours : intention répressive = volonté de vengeance.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur ivre ou sous stupéfiants',
    question:
        'La circonstance “ivresse manifeste ou emprise manifeste de stupéfiants” est :',
    options: ['Personnelle', 'Réelle', 'Une cause d’exemption de peine'],
    answer: 'Réelle',
    explanation:
        'Le cours précise qu’il s’agit d’une circonstance aggravante réelle, étendue à tous les participants.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur ivre ou sous stupéfiants',
    question:
        'Concernant l’ivresse, la jurisprudence majoritaire considère que l’ivresse :',
    options: [
      'Constitue une cause légale d’exemption',
      'Ne constitue pas une cause légale d’exemption',
      'Supprime toujours la responsabilité',
    ],
    answer: 'Ne constitue pas une cause légale d’exemption',
    explanation:
        'Le cours : la majorité des décisions refusent d’y voir une cause légale d’exemption de peine.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur ivre ou sous stupéfiants',
    question: 'L’usage volontaire de stupéfiants est, par nature :',
    options: [
      'Illicite',
      'Licite comme l’alcool',
      'Toujours prescrit médicalement',
    ],
    answer: 'Illicite',
    explanation:
        'Le cours souligne que l’usage de stupéfiants est illicite, contrairement à la consommation d’alcool.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Circonstances aggravantes — Auteur ivre ou sous stupéfiants',
    question: 'La preuve de l’état manifeste peut être délicate car :',
    options: [
      'Plainte tardive + persistance des traces (stupéfiants)',
      'Elle est toujours automatique',
      'La loi fixe une preuve unique obligatoire',
    ],
    answer: 'Plainte tardive + persistance des traces (stupéfiants)',
    explanation:
        'Le cours évoque la difficulté : plainte tardive pour alcool et présence prolongée des stupéfiants.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Circonstances aggravantes — Caractère raciste',
    question: 'Catégories 132-76 :',
    options: ['Ethnie/nation/race/religion', 'Âge/sexe', 'Profession/salaire'],
    answer: 'Ethnie/nation/race/religion',
    explanation: 'Liste du cours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Caractère homophobe/sexiste/transphobe',
    question: 'Peut viser identité de genre :',
    options: ['Vraie ou supposée', 'Uniquement vraie', 'Jamais'],
    answer: 'Vraie ou supposée',
    explanation: 'Le cours : erreur possible de l’auteur.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Circonstances aggravantes — Particulière vulnérabilité de la victime',
    question:
        'Parmi les causes citées, la précarité économique ou sociale renvoie notamment à :',
    options: [
      'L’absence d’une ou plusieurs sécurités (notamment l’emploi) plaçant la personne en dépendance',
      'Une simple préférence de consommation',
      'Le fait d’être étudiant',
    ],
    answer:
        'L’absence d’une ou plusieurs sécurités (notamment l’emploi) plaçant la personne en dépendance',
    explanation:
        'Le cours définit la précarité comme l’absence de sécurités (dont l’emploi) pouvant placer la victime en dépendance.',
    difficulty: 'Moyen',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizSanctionAggravation extends StatefulWidget {
  static const String routeName =
      '/gpx/sanction/quiz/sanction_causes_aggravation';
  final String uid;
  final String email;

  const QuizSanctionAggravation({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizSanctionAggravation> createState() =>
      _QuizSanctionAggravationState();
}

class _QuizSanctionAggravationState extends State<QuizSanctionAggravation>
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
        ? questionGPCirconstancesAggravantes
        : questionGPCirconstancesAggravantes
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
            'module_name': 'Sanction',
            'quiz_name': 'Aggravation',
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
      await _sb.from('quiz_sanction_aggravation_peine').insert({
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
      debugPrint('❌ quiz_sanction_aggravation_peine insert failed: $e');
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
