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
final List<QuizQuestion> questionsGPXSchoolResponsabilitePenalGeneral = [
  //////////////////////////////////////////////////////////////////////////////
  // PRINCIPES GÉNÉRAUX — RESPONSABILITÉ PÉNALE
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question:
        'En droit pénal, la responsabilité pénale consiste principalement :',
    options: [
      'À réparer civilement le dommage causé',
      'À répondre de ses actes délictueux et, en cas de condamnation, exécuter la sanction prévue',
      'À contester systématiquement la matérialité des faits',
    ],
    answer:
        'À répondre de ses actes délictueux et, en cas de condamnation, exécuter la sanction prévue',
    explanation:
        'La responsabilité pénale est l’obligation de répondre de ses actes délictueux et, en cas de condamnation, d’exécuter la sanction pénale prévue.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question: 'La responsabilité pénale est :',
    options: [
      'Un élément constitutif de l’infraction',
      'L’effet et la conséquence juridique de l’infraction',
      'Une condition exclusive de la tentative',
    ],
    answer: 'L’effet et la conséquence juridique de l’infraction',
    explanation:
        'Le cours précise que la responsabilité n’est pas un élément de l’infraction : elle en est l’effet et la conséquence juridique.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question: 'Quel principe est posé par l’article 121-1 du Code pénal ?',
    options: [
      'Tout le monde est responsable des faits du groupe',
      'Nul n’est responsable que de son propre fait',
      'La responsabilité pénale est toujours collective en cas de bande organisée',
    ],
    answer: 'Nul n’est responsable que de son propre fait',
    explanation:
        'L’article 121-1 du Code pénal pose le principe de responsabilité personnelle : nul n’est responsable que de son propre fait.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question:
        'Le principe « nul n’est responsable que de son propre fait » est applicable :',
    options: [
      'Uniquement aux personnes physiques',
      'Uniquement aux personnes morales',
      'Aux personnes physiques et aux personnes morales',
    ],
    answer: 'Aux personnes physiques et aux personnes morales',
    explanation:
        'Le cours indique que le principe s’applique tant aux personnes physiques qu’aux personnes morales (innovation par rapport à la législation antérieure).',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question:
        'Pour qu’il y ait responsabilité pénale au sens strict, il faut :',
    options: [
      'Une faute (culpabilité) et une imputabilité',
      'Uniquement un dommage',
      'Uniquement une intention coupable',
    ],
    answer: 'Une faute (culpabilité) et une imputabilité',
    explanation:
        'Le cours précise : responsabilité pénale au sens strict = faute (culpabilité) + faute imputable (imputabilité).',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // LA COACTION (COAUTEURS)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question:
        'Lorsque plusieurs personnes participent à égalité à la réalisation de l’infraction, elles sont :',
    options: [
      'Complices uniquement',
      'Coauteurs (auteurs principaux)',
      'Témoins privilégiés',
    ],
    answer: 'Coauteurs (auteurs principaux)',
    explanation:
        'Si plusieurs personnes participent à égalité à la réalisation de l’infraction, elles sont coauteurs : chacune a personnellement commis les éléments matériel et moral sanctionnés.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question:
        'Pourquoi les coauteurs sont-ils considérés comme auteurs principaux ?',
    options: [
      'Parce qu’ils ont seulement conseillé l’auteur',
      'Parce que chacun a personnellement commis les éléments matériel et moral de l’infraction',
      'Parce qu’ils sont membres d’une même famille',
    ],
    answer:
        'Parce que chacun a personnellement commis les éléments matériel et moral de l’infraction',
    explanation:
        'La coaction suppose une participation à égalité : chaque coauteur réalise les éléments matériel et moral de l’infraction.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question:
        'En cas d’infraction collective, la jurisprudence peut qualifier :',
    options: [
      'Uniquement celui qui porte le coup final comme auteur',
      'L’ensemble des membres du groupe ayant participé comme coauteurs',
      'Personne, car l’auteur est indéterminable',
    ],
    answer: 'L’ensemble des membres du groupe ayant participé comme coauteurs',
    explanation:
        'En matière d’infraction collective, il peut être difficile d’identifier le rôle exact : la jurisprudence qualifie souvent l’ensemble des participants de coauteurs.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question:
        'Dans le cas de violences commises par plusieurs individus, ils peuvent être qualifiés de coauteurs selon la jurisprudence (ex : Cass. crim. 1er oct. 1984).',
    options: ['Vrai', 'Faux', 'Seulement si un texte spécial le prévoit'],
    answer: 'Vrai',
    explanation:
        'Le cours cite la jurisprudence : en matière de violences, plusieurs participants peuvent être qualifiés de coauteurs (Cass. crim. 1er oct. 1984).',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question: 'La jurisprudence tend à considérer comme coauteurs :',
    options: [
      'Uniquement ceux qui exécutent matériellement l’acte principal',
      'Ceux qui participent à la commission même s’ils n’ont pas réalisé directement l’élément matériel',
      'Uniquement les instigateurs',
    ],
    answer:
        'Ceux qui participent à la commission même s’ils n’ont pas réalisé directement l’élément matériel',
    explanation:
        'Le cours indique une tendance jurisprudentielle : considérer coauteurs ceux qui participent à la commission, même sans réaliser directement l’élément matériel (ex : faire le guet).',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question:
        'Exemple typique d’une qualification de coauteur (tendance jurisprudentielle) :',
    options: [
      'Celui qui filme une scène sans aider',
      'Celui qui fait le guet pendant l’exécution d’un vol',
      'Celui qui apprend les faits après et se tait',
    ],
    answer: 'Celui qui fait le guet pendant l’exécution d’un vol',
    explanation:
        'Le cours donne l’exemple : celui qui fait le guet pendant l’exécution d’un vol peut être considéré comme coauteur selon la tendance jurisprudentielle.',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // LA COMPLICITÉ — DÉFINITION & PRINCIPE
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Complicité',
    question: 'La complicité est définie par quel article du Code pénal ?',
    options: ['Article 121-1', 'Article 121-7', 'Article 122-5'],
    answer: 'Article 121-7',
    explanation:
        'Le cours indique que la complicité est définie à l’article 121-7 du Code pénal.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité',
    question: 'Le complice est celui qui :',
    options: [
      'Commet personnellement tous les éléments de l’infraction',
      'Aide l’auteur dans la préparation ou l’exécution en accomplissant un acte matériel',
      'Intervient uniquement après l’infraction pour cacher l’auteur',
    ],
    answer:
        'Aide l’auteur dans la préparation ou l’exécution en accomplissant un acte matériel',
    explanation:
        'Le complice aide l’auteur dans la préparation ou l’exécution, en participant intentionnellement par un acte matériel.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité',
    question:
        'Le Code pénal assimile le complice à l’auteur au niveau de la répression (article 121-6). Cela signifie :',
    options: [
      'Le complice ne peut jamais être condamné',
      'Le complice est puni comme auteur',
      'Le complice est puni seulement d’une amende',
    ],
    answer: 'Le complice est puni comme auteur',
    explanation:
        'L’article 121-6 du Code pénal prévoit que le complice sera puni comme auteur : mêmes peines encourues, sans obligation de peine identique.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité',
    question:
        'La complicité est une « criminalité d’emprunt ». Cela signifie :',
    options: [
      'Le complice invente l’infraction',
      'L’acte de complicité n’est punissable qu’à condition d’être rattaché à un fait principal punissable',
      'La complicité n’existe qu’en contravention',
    ],
    answer:
        'L’acte de complicité n’est punissable qu’à condition d’être rattaché à un fait principal punissable',
    explanation:
        'L’acte de complicité n’est pas punissable en tant que tel : il doit se rattacher à un fait principal punissable.',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // COMPLICITÉ — CONDITIONS RELATIVES AU FAIT PRINCIPAL
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (fait principal)',
    question:
        'Si le fait principal échappe à la loi pénale (pas d’infraction), le complice :',
    options: [
      'Est toujours puni quand même',
      'Ne peut pas être puni comme complice',
      'Est automatiquement condamné pour recel',
    ],
    answer: 'Ne peut pas être puni comme complice',
    explanation:
        'La complicité suppose un fait principal prévu et réprimé. Si le fait principal n’est pas punissable, la complicité ne peut être retenue.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité (fait principal)',
    question: 'La complicité de tentative est :',
    options: [
      'Punissable',
      'Jamais punissable',
      'Punissable uniquement en contravention',
    ],
    answer: 'Punissable',
    explanation:
        'Le cours indique que la complicité de tentative est punissable.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité (fait principal)',
    question:
        'Si l’auteur principal ne réalise que des actes préparatoires ou se désiste volontairement, le complice :',
    options: [
      'Peut être poursuivi pour tentative de complicité',
      'Ne peut pas être poursuivi (la « tentative de complicité » n’est pas punissable)',
      'Est poursuivi automatiquement pour provocation',
    ],
    answer:
        'Ne peut pas être poursuivi (la « tentative de complicité » n’est pas punissable)',
    explanation:
        'Le cours précise que si l’auteur principal n’a fait que des actes préparatoires ou s’est désisté volontairement, le complice ne peut être poursuivi : la tentative de complicité n’est pas punissable.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité (fait principal)',
    question:
        'La complicité ne peut pas être retenue lorsque le fait principal est :',
    options: [
      'Justifié par la légitime défense / ordre de la loi / commandement de l’autorité légitime',
      'Un crime',
      'Un délit',
    ],
    answer:
        'Justifié par la légitime défense / ordre de la loi / commandement de l’autorité légitime',
    explanation:
        'Le cours mentionne que la complicité ne peut être retenue si le fait principal est justifié (légitime défense, ordre de la loi, commandement de l’autorité légitime).',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité (fait principal)',
    question:
        'La complicité peut être retenue même si l’auteur principal n’est pas puni, notamment si :',
    options: [
      'L’auteur est en fuite, inconnu ou décédé',
      'L’auteur est mineur',
      'Toutes les réponses sont exactes',
    ],
    answer: 'Toutes les réponses sont exactes',
    explanation:
        'Le complice peut être poursuivi même si l’auteur principal n’est pas puni : auteur en fuite/inconnu/décédé, ou bénéficiant d’une cause d’irresponsabilité (trouble, minorité) ou d’une exemption légale de peine.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité (fait principal)',
    question:
        'Selon l’article 121-7 du Code pénal, sont susceptibles de complicité :',
    options: [
      'Tous les crimes et délits en principe',
      'Uniquement les crimes',
      'Uniquement les délits',
    ],
    answer: 'Tous les crimes et délits en principe',
    explanation:
        'Le cours rappelle qu’en vertu de l’article 121-7, tous les crimes et délits sont en principe susceptibles de complicité.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité (contraventions)',
    question:
        'En matière de contraventions, la complicité par provocation ou instructions est :',
    options: [
      'Jamais réprimée',
      'Systématiquement réprimée (article R. 610-2 du Code pénal)',
      'Réprimée seulement en cas de flagrance',
    ],
    answer: 'Systématiquement réprimée (article R. 610-2 du Code pénal)',
    explanation:
        'Le cours précise qu’en contraventions, la complicité par provocation ou instructions est systématiquement réprimée par l’article R. 610-2 du Code pénal.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité (contraventions)',
    question:
        'En matière de contraventions, la complicité par aide ou assistance est :',
    options: [
      'Toujours réprimée',
      'Réprimée uniquement si un texte le prévoit expressément',
      'Jamais réprimée',
    ],
    answer: 'Réprimée uniquement si un texte le prévoit expressément',
    explanation:
        'Le cours indique que l’aide/assistance en contravention n’est réprimée que si un texte spécial le prévoit.',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // COMPLICITÉ — PARTICIPATION MATÉRIELLE (ART. 121-7)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (actes)',
    question: 'Les actes de complicité doivent être :',
    options: [
      'Uniquement des abstentions',
      'Des actes positifs',
      'Des pensées criminelles non extériorisées',
    ],
    answer: 'Des actes positifs',
    explanation:
        'Le cours précise que les actes de complicité sont des actes positifs. L’abstention ne peut pas, en principe, constituer un acte de complicité.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité (actes)',
    question: 'Les actes de complicité doivent être :',
    options: [
      'Postérieurs à l’infraction',
      'Antérieurs ou concomitants au fait principal',
      'Uniquement postérieurs si l’auteur est en fuite',
    ],
    answer: 'Antérieurs ou concomitants au fait principal',
    explanation:
        'Le cours affirme qu’il n’y a pas de complicité postérieure à l’infraction : les actes doivent être antérieurs ou concomitants.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité (actes)',
    question:
        'Une personne simple spectatrice d’une infraction peut être qualifiée de complice :',
    options: [
      'Oui, automatiquement',
      'Non, l’abstention ne constitue pas un acte de complicité',
      'Oui, si elle filme sans intention',
    ],
    answer: 'Non, l’abstention ne constitue pas un acte de complicité',
    explanation:
        'Le cours précise que la complicité implique des actes positifs : le simple spectateur ne peut être complice (mais d’autres infractions peuvent être envisagées, ex. omission de porter secours).',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité (actes — provocation)',
    question:
        'La provocation, pour constituer une complicité, doit notamment :',
    options: [
      'Être un simple conseil sans plus',
      'Être accompagnée de don, promesse, ordre, menace, abus d’autorité ou de pouvoir',
      'Être adressée à un public indéterminé',
    ],
    answer:
        'Être accompagnée de don, promesse, ordre, menace, abus d’autorité ou de pouvoir',
    explanation:
        'Le cours indique que la provocation doit être accompagnée de circonstances (don, promesse, ordre, menace, abus d’autorité/pouvoir). Le simple conseil ne suffit pas.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité (actes — provocation)',
    question: 'La provocation doit être :',
    options: [
      'Individuelle (adressée à une personne déterminée)',
      'Collective (adressée à une foule)',
      'Toujours anonyme',
    ],
    answer: 'Individuelle (adressée à une personne déterminée)',
    explanation:
        'Le cours précise que la provocation doit être individuelle : adressée à une personne déterminée.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité (actes — provocation)',
    question: 'La provocation doit être suivie d’effets. Cela signifie :',
    options: [
      'L’infraction doit être réalisée ou au moins tentée',
      'Il suffit d’avoir eu l’intention de provoquer',
      'La provocation est punissable même si rien ne se passe',
    ],
    answer: 'L’infraction doit être réalisée ou au moins tentée',
    explanation:
        'Pour être une complicité par provocation, celle-ci doit être suivie d’effets : infraction réalisée ou au moins tentée.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité (actes — instructions)',
    question: 'La fourniture d’instructions correspond à :',
    options: [
      'Des indications précises données en connaissance de cause pour faciliter l’infraction',
      'Une simple discussion générale sur la loi',
      'Une abstention volontaire',
    ],
    answer:
        'Des indications précises données en connaissance de cause pour faciliter l’infraction',
    explanation:
        'Le cours : instructions = indications précises facilitant l’exécution, données en connaissance de cause.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité (actes — aide/assistance)',
    question: 'L’aide ou l’assistance suppose que l’acte ait :',
    options: [
      'Empêché l’infraction',
      'Facilité la préparation ou la consommation de l’infraction',
      'Eu lieu uniquement après l’infraction',
    ],
    answer: 'Facilité la préparation ou la consommation de l’infraction',
    explanation:
        'Le cours : l’aide/assistance doit avoir facilité la préparation ou la consommation (fourniture de moyens, concours au moment de la préparation ou de la réalisation).',
    difficulty: 'Facile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // COMPLICITÉ — INTENTION CRIMINELLE
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (intention)',
    question: 'L’intention criminelle du complice requiert :',
    options: [
      'Une connaissance du caractère délictueux + une volonté de s’associer à l’acte',
      'Uniquement une présence sur les lieux',
      'Uniquement un mobile honorable',
    ],
    answer:
        'Une connaissance du caractère délictueux + une volonté de s’associer à l’acte',
    explanation:
        'Le cours : deux conditions cumulatives — connaissance du caractère délictueux des actes + volonté de s’associer (agir ensemble et de concert).',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // HAPPY SLAPPING (CAS PARTICULIER)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (happy slapping)',
    question:
        'Quel article assimile à un acte de complicité le fait d’enregistrer sciemment des images de violences volontaires (happy slapping) ?',
    options: [
      'Article 222-33-3 du Code pénal',
      'Article 121-1 du Code pénal',
      'Article 122-2 du Code pénal',
    ],
    answer: 'Article 222-33-3 du Code pénal',
    explanation:
        'Le cours cite l’article 222-33-3 du Code pénal : l’enregistrement sciemment d’images de certaines atteintes volontaires à l’intégrité est constitutif d’un acte de complicité.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Complicité (happy slapping)',
    question:
        'Selon le cours, la particularité de l’article 222-33-3 du Code pénal est qu’il :',
    options: [
      'Exige un lien de causalité renforcé entre l’acte accessoire et l’acte principal',
      'Supprime la nécessité du lien de causalité en assimilant l’enregistrement à la complicité',
      'Ne s’applique qu’aux contraventions',
    ],
    answer:
        'Supprime la nécessité du lien de causalité en assimilant l’enregistrement à la complicité',
    explanation:
        'Le cours indique que filmer ne procure pas d’aide matérielle ; pourtant l’article 222-33-3 assimile l’enregistrement à la complicité et supprime la nécessité du lien de causalité.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // RÉPRESSION DE LA COMPLICITÉ (ART. 121-6)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Répression de la complicité',
    question:
        'Dire que « le complice est puni comme auteur » (article 121-6) signifie :',
    options: [
      'Le juge doit prononcer la même peine pour l’auteur et le complice',
      'Les peines encourues sont les mêmes, mais le juge peut individualiser',
      'Le complice ne peut jamais être plus sévèrement puni',
    ],
    answer:
        'Les peines encourues sont les mêmes, mais le juge peut individualiser',
    explanation:
        'Le cours : mêmes peines encourues, mais le juge n’est pas obligé de prononcer des peines identiques.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Répression de la complicité',
    question:
        'Les circonstances personnelles à l’auteur (ex : démence, contrainte, récidive) sont applicables au complice :',
    options: [
      'Oui, toujours',
      'Non, elles ne sont pas applicables au complice',
      'Oui, uniquement si le complice les connaît',
    ],
    answer: 'Non, elles ne sont pas applicables au complice',
    explanation:
        'Le cours : les circonstances personnelles à l’auteur, qu’elles atténuent ou aggravent, ne s’appliquent pas au complice.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Répression de la complicité',
    question: 'Les circonstances réelles (touchant la matérialité de l’acte) :',
    options: [
      'Ne s’appliquent jamais au complice',
      'Peuvent aggraver ou atténuer la peine applicable au complice',
      'S’appliquent seulement si le complice les voulait',
    ],
    answer: 'Peuvent aggraver ou atténuer la peine applicable au complice',
    explanation:
        'Le cours : les circonstances réelles, modifiant la nature de l’infraction, atténuent ou aggravent la peine applicable au complice.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Répression de la complicité',
    question:
        'Les circonstances réelles aggravantes peuvent s’étendre au complice même s’il les ignorait :',
    options: ['Vrai', 'Faux', 'Uniquement en matière contraventionnelle'],
    answer: 'Vrai',
    explanation:
        'Le cours indique que certaines circonstances réelles aggravantes s’étendent au complice même s’il ignorait leur existence (ex : réunion pour le vol).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Répression de la complicité',
    question:
        'Concernant les circonstances aggravantes liées à la qualité de l’auteur principal, la Cour de cassation a jugé qu’elles sont applicables au complice (arrêt du 7 septembre 2005).',
    options: ['Vrai', 'Faux', 'Seulement si le complice est coauteur'],
    answer: 'Vrai',
    explanation:
        'Le cours cite l’arrêt du 7 septembre 2005 (n°04-84.235) : les circonstances aggravantes liées à la qualité de l’auteur principal sont applicables au complice.',
    difficulty: 'Difficile',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // TABLEAU - SYNTHÈSE COMPLICITÉ
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (synthèse)',
    question: 'La complicité repose sur trois blocs :',
    options: [
      'Fait principal punissable + participation à l’infraction + intention criminelle',
      'Mobile + opportunité + dommage',
      'Victime + plainte + enquête',
    ],
    answer:
        'Fait principal punissable + participation à l’infraction + intention criminelle',
    explanation:
        'Le tableau de synthèse rappelle les 3 éléments : fait principal punissable, participation (actes de l’art. 121-7), intention criminelle (connaissance + volonté).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question:
        'En droit pénal, la responsabilité pénale correspond principalement :',
    options: [
      'À l’obligation de réparer civilement un dommage',
      'À l’obligation de répondre de ses actes délictueux et d’exécuter la sanction en cas de condamnation',
      'À l’obligation de prouver son innocence',
    ],
    answer:
        'À l’obligation de répondre de ses actes délictueux et d’exécuter la sanction en cas de condamnation',
    explanation:
        'Le cours : la responsabilité pénale = répondre de ses actes délictueux + exécuter la sanction en cas de condamnation.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question: 'La responsabilité pénale est :',
    options: [
      'Un élément constitutif de l’infraction',
      'L’effet et la conséquence juridique de l’infraction',
      'Une circonstance aggravante automatique',
    ],
    answer: 'L’effet et la conséquence juridique de l’infraction',
    explanation:
        'Le cours : ce n’est pas un élément de l’infraction, mais son effet/conséquence.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question: 'Selon l’article 121-1 du Code pénal, le principe est :',
    options: [
      'Nul n’est responsable que de son propre fait',
      'Tout le monde est responsable des faits du groupe',
      'Seul l’auteur matériel est responsable',
    ],
    answer: 'Nul n’est responsable que de son propre fait',
    explanation: 'Art. 121-1 C.P. : responsabilité personnelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question: 'Le principe de l’article 121-1 s’applique :',
    options: [
      'Uniquement aux personnes physiques',
      'Aux personnes physiques et aux personnes morales',
      'Uniquement aux personnes morales',
    ],
    answer: 'Aux personnes physiques et aux personnes morales',
    explanation:
        'Le cours : principe applicable aux deux (innovation à l’époque).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question:
        'Pour qu’il y ait responsabilité pénale au sens strict, il faut :',
    options: [
      'Une faute (culpabilité) et une imputabilité',
      'Un dommage et une plainte',
      'Une intention uniquement',
    ],
    answer: 'Une faute (culpabilité) et une imputabilité',
    explanation: 'Le cours : culpabilité + imputabilité.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question: 'En droit pénal, le Code pénal prend principalement en compte :',
    options: [
      'La personne du délinquant',
      'La personnalité de la victime uniquement',
      'Le montant du préjudice seulement',
    ],
    answer: 'La personne du délinquant',
    explanation: 'Le cours : prise en compte de la personne du délinquant.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question:
        'Pour être déclarée pénalement responsable, une personne doit avoir participé à l’infraction en qualité :',
    options: [
      'D’auteur ou de complice',
      'De témoin ou d’expert',
      'De victime ou d’assureur',
    ],
    answer: 'D’auteur ou de complice',
    explanation: 'Le cours : auteur/complice.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question: 'Les causes d’irresponsabilité ou d’atténuation agissent sur :',
    options: [
      'La punissabilité / la responsabilité, pas sur l’existence matérielle des faits',
      'La compétence territoriale uniquement',
      'La prescription uniquement',
    ],
    answer:
        'La punissabilité / la responsabilité, pas sur l’existence matérielle des faits',
    explanation:
        'Le cours : elles affectent la responsabilité (ou l’atténuent) sans effacer nécessairement les faits.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question: 'Imputabilité signifie principalement :',
    options: [
      'Que la faute peut être attribuée à la personne',
      'Que le dommage existe',
      'Que la peine est automatique',
    ],
    answer: 'Que la faute peut être attribuée à la personne',
    explanation: 'Le cours : responsabilité stricte = faute + faute imputable.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question: 'Dans un raisonnement pénal, la responsabilité est plutôt :',
    options: [
      'La cause de l’infraction',
      'La conséquence juridique de l’infraction',
      'Une procédure administrative',
    ],
    answer: 'La conséquence juridique de l’infraction',
    explanation: 'Le cours : conséquence juridique.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question: 'Une personne morale peut être responsable pénalement :',
    options: [
      'Jamais',
      'Oui, selon les conditions prévues par le Code pénal',
      'Uniquement en contravention',
    ],
    answer: 'Oui, selon les conditions prévues par le Code pénal',
    explanation: 'Le cours : responsabilité possible des personnes morales.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question:
        'L’idée centrale du principe « nul n’est responsable que de son propre fait » vise surtout :',
    options: [
      'À exclure une responsabilité pénale automatique du fait d’autrui',
      'À empêcher toute coaction',
      'À supprimer la complicité',
    ],
    answer: 'À exclure une responsabilité pénale automatique du fait d’autrui',
    explanation:
        'Responsabilité personnelle : pas de responsabilité pénale générale du fait d’autrui.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question: 'Une cause d’irresponsabilité implique généralement que :',
    options: [
      'L’acte perd son caractère d’infraction ou la personne ne peut en répondre pénalement',
      'Le dommage disparaît',
      'L’action civile est toujours impossible',
    ],
    answer:
        'L’acte perd son caractère d’infraction ou la personne ne peut en répondre pénalement',
    explanation: 'Le cours : faits justificatifs / non-imputabilité.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question: 'Dans le cours, la responsabilité pénale n’est pas :',
    options: [
      'Un effet de l’infraction',
      'Un élément constitutif de l’infraction',
      'Une conséquence juridique',
    ],
    answer: 'Un élément constitutif de l’infraction',
    explanation: 'Le cours le dit expressément.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question: 'Le principe de l’article 121-1 est :',
    options: [
      'Un principe général applicable aux personnes physiques et morales',
      'Une exception limitée aux contraventions',
      'Une règle propre aux mineurs',
    ],
    answer: 'Un principe général applicable aux personnes physiques et morales',
    explanation: 'Le cours : principe général, y compris personnes morales.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question:
        'Participer à une infraction « en qualité de complice » suppose en général :',
    options: [
      'Une participation intentionnelle par un acte matériel',
      'Une abstention pure',
      'Une responsabilité objective sans intention',
    ],
    answer: 'Une participation intentionnelle par un acte matériel',
    explanation: 'Définition de la complicité dans le cours.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question: 'La responsabilité pénale peut être atténuée notamment lorsque :',
    options: [
      'La faute existe mais certaines circonstances conduisent à une atténuation',
      'Aucun fait n’a été commis',
      'La victime retire plainte (toujours)',
    ],
    answer:
        'La faute existe mais certaines circonstances conduisent à une atténuation',
    explanation: 'Le cours : atténuations possibles.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question:
        'Dire que la responsabilité pénale « n’est pas un élément de l’infraction » signifie :',
    options: [
      'Qu’on peut condamner sans infraction',
      'Qu’elle vient après la commission de l’infraction, comme conséquence',
      'Qu’elle remplace l’élément matériel',
    ],
    answer:
        'Qu’elle vient après la commission de l’infraction, comme conséquence',
    explanation: 'Conséquence juridique : elle découle de l’infraction.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Responsabilité pénale (principes)',
    question: 'La responsabilité pénale implique en cas de condamnation :',
    options: [
      'L’exécution de la sanction pénale prévue',
      'Une simple réprimande sans effet',
      'Uniquement une réparation civile',
    ],
    answer: 'L’exécution de la sanction pénale prévue',
    explanation: 'Le cours : exécuter la sanction pénale.',
    difficulty: 'Facile',
  ),

  /////////////////////////////////////////////////////////////////////////////
  /// COACTION / COAUTEURS (21 → 45)
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question: 'L’auteur de l’infraction est celui qui :',
    options: [
      'Commet personnellement les actes prévus et réprimés par le texte',
      'Aide uniquement après les faits',
      'Se contente d’approuver l’acte',
    ],
    answer: 'Commet personnellement les actes prévus et réprimés par le texte',
    explanation:
        'Le cours : auteur = réalisation personnelle des actes incriminés.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question:
        'Lorsque plusieurs personnes participent à égalité à la réalisation, elles sont :',
    options: ['Coauteurs', 'Complices par abstention', 'Non responsables'],
    answer: 'Coauteurs',
    explanation: 'Coaction : participation à égalité = coauteurs.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question: 'Les coauteurs sont considérés comme auteurs principaux car :',
    options: [
      'Chacun a commis les éléments matériel et moral',
      'Un seul a commis l’élément moral',
      'Ils ont agi après l’infraction',
    ],
    answer: 'Chacun a commis les éléments matériel et moral',
    explanation: 'Le cours : chaque coauteur réalise matériel + moral.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question: 'La coaction se rencontre souvent dans :',
    options: [
      'Les infractions commises par plusieurs personnes',
      'Uniquement les infractions non intentionnelles',
      'Uniquement les contraventions',
    ],
    answer: 'Les infractions commises par plusieurs personnes',
    explanation:
        'Le cours : infraction possible par plusieurs personnes : coauteurs / auteur + complices.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question: 'En cas d’infraction collective, la jurisprudence peut :',
    options: [
      'Qualifier coauteurs l’ensemble du groupe ayant participé',
      'Refuser toute qualification',
      'Qualifier toujours complices',
    ],
    answer: 'Qualifier coauteurs l’ensemble du groupe ayant participé',
    explanation:
        'Le cours : difficulté d’identifier le rôle -> coauteur pour le groupe.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question: 'Exemple jurisprudentiel cité pour des violences à plusieurs :',
    options: ['Cass. crim. 1er oct. 1984', 'Cass. civ. 2001', 'CE 1995'],
    answer: 'Cass. crim. 1er oct. 1984',
    explanation: 'Le cours cite Cass. crim 1er oct. 1984.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question:
        'La théorie de la « complicité corespective » visait historiquement à :',
    options: [
      'Assimiler certains coauteurs à des complices',
      'Interdire toute condamnation',
      'Créer une immunité',
    ],
    answer: 'Assimiler certains coauteurs à des complices',
    explanation: 'Le cours : théorie jurisprudentielle ancienne.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question:
        'Aujourd’hui, l’intérêt pratique du subterfuge « complicité corespective » a diminué car :',
    options: [
      'Le complice est puni comme l’auteur',
      'La complicité a disparu',
      'Les crimes ne se commettent plus à plusieurs',
    ],
    answer: 'Le complice est puni comme l’auteur',
    explanation: 'Le cours : complice puni comme auteur -> intérêt perdu.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question: 'La jurisprudence tend à considérer comme coauteurs aussi :',
    options: [
      'Ceux qui participent à la commission même sans réaliser directement l’élément matériel',
      'Uniquement les instigateurs',
      'Uniquement les témoins',
    ],
    answer:
        'Ceux qui participent à la commission même sans réaliser directement l’élément matériel',
    explanation: 'Le cours : ex. guet pendant vol.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question:
        'Exemple : celui qui fait le guet pendant un vol est souvent qualifié :',
    options: ['Coauteur (tendance jurisprudentielle)', 'Victime', 'Juré'],
    answer: 'Coauteur (tendance jurisprudentielle)',
    explanation: 'Exemple direct du cours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question:
        'La coaction suppose une participation « à égalité ». Cela renvoie surtout à :',
    options: [
      'Une participation à la réalisation de l’infraction',
      'Une participation uniquement postérieure',
      'Un lien familial',
    ],
    answer: 'Une participation à la réalisation de l’infraction',
    explanation: 'Coaction : réalisation de l’infraction.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question:
        'Coauteur et complice : la différence centrale porte surtout sur :',
    options: [
      'Le degré et la nature de la participation (réalisation vs aide/intention)',
      'La nationalité',
      'Le lieu de naissance',
    ],
    answer:
        'Le degré et la nature de la participation (réalisation vs aide/intention)',
    explanation: 'Cours : coauteur réalise; complice aide/intention.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question: 'Une infraction peut être commise par :',
    options: [
      'Un seul auteur',
      'Plusieurs personnes (coauteurs / auteurs + complices)',
      'Les deux réponses sont exactes',
    ],
    answer: 'Les deux réponses sont exactes',
    explanation:
        'Le cours : infraction peut être le fait de plusieurs personnes.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question: 'La coaction se distingue de la complicité car le coauteur :',
    options: [
      'Commet personnellement les éléments sanctionnés',
      'Ne fait qu’aider',
      'N’a pas d’intention',
    ],
    answer: 'Commet personnellement les éléments sanctionnés',
    explanation: 'Cours : coauteur = auteur principal.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Coaction (coauteurs)',
    question:
        'Dans une infraction collective, la difficulté d’application vient surtout de :',
    options: [
      'Déterminer précisément le rôle de chacun',
      'Trouver un texte de procédure civile',
      'Identifier la victime',
    ],
    answer: 'Déterminer précisément le rôle de chacun',
    explanation: 'Le cours : difficulté d’identifier le rôle exact.',
    difficulty: 'Moyen',
  ),

  /////////////////////////////////////////////////////////////////////////////
  /// COMPLICITÉ — DÉFINITION & FAIT PRINCIPAL (46 → 95)
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Complicité',
    question: 'La complicité est définie par :',
    options: [
      'Article 121-7 du Code pénal',
      'Article 121-1 du Code pénal',
      'Article 122-7 du Code pénal',
    ],
    answer: 'Article 121-7 du Code pénal',
    explanation: 'Le cours : art. 121-7 C.P.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité',
    question: 'La complicité consiste en :',
    options: [
      'Une entente momentanée pour accomplir une infraction déterminée',
      'Un contrat civil',
      'Une simple rumeur',
    ],
    answer: 'Une entente momentanée pour accomplir une infraction déterminée',
    explanation: 'Le cours : entente momentanée + infraction déterminée.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité',
    question: 'Le complice est celui qui :',
    options: [
      'Aide l’auteur dans la préparation ou l’exécution',
      'Découvre l’infraction après et se tait',
      'Subit l’infraction',
    ],
    answer: 'Aide l’auteur dans la préparation ou l’exécution',
    explanation: 'Définition du cours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité',
    question:
        'La participation du complice à la commission de l’infraction est :',
    options: [
      'Intentionnelle',
      'Toujours involontaire',
      'Sans aucun acte matériel',
    ],
    answer: 'Intentionnelle',
    explanation: 'Le cours : participation intentionnelle par acte matériel.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité',
    question:
        'Le Code pénal assimile le complice à l’auteur au niveau de la répression via :',
    options: [
      'Article 121-6 du Code pénal',
      'Article 122-1 du Code pénal',
      'Article 131-39 du Code pénal',
    ],
    answer: 'Article 121-6 du Code pénal',
    explanation: 'Le cours : art. 121-6 = complice puni comme auteur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (fait principal)',
    question: 'La complicité est une « criminalité d’emprunt » car :',
    options: [
      'L’acte de complicité n’est punissable qu’adossé à un fait principal punissable',
      'Elle ne concerne que les contraventions',
      'Elle impose une peine obligatoire',
    ],
    answer:
        'L’acte de complicité n’est punissable qu’adossé à un fait principal punissable',
    explanation: 'Le cours : rattachement à un fait principal punissable.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (fait principal)',
    question: 'La complicité suppose l’existence :',
    options: [
      'D’un fait prévu et réprimé par les textes',
      'D’une simple intention sans acte',
      'D’une autorisation administrative',
    ],
    answer: 'D’un fait prévu et réprimé par les textes',
    explanation: 'Le cours : existence d’une infraction.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (fait principal)',
    question: 'Si le fait principal n’est pas punissable, le complice :',
    options: [
      'Ne peut pas être puni comme complice',
      'Est toujours condamné',
      'Est condamné uniquement à une amende',
    ],
    answer: 'Ne peut pas être puni comme complice',
    explanation: 'Le cours : pas d’infraction -> pas de complicité.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (fait principal)',
    question:
        'Le suicide n’étant pas incriminé en droit français, celui qui le favorise :',
    options: [
      'N’est pas poursuivi comme complice du suicide',
      'Est poursuivi comme complice du suicide',
      'Est automatiquement acquitté de tout',
    ],
    answer: 'N’est pas poursuivi comme complice du suicide',
    explanation:
        'Le cours : éventuellement poursuites sur un délit distinct (provocation au suicide).',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (fait principal)',
    question: 'La complicité de tentative est :',
    options: [
      'Punissable',
      'Jamais punissable',
      'Punissable seulement en contravention',
    ],
    answer: 'Punissable',
    explanation: 'Le cours : complicité de tentative punissable.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (fait principal)',
    question:
        'Si l’auteur principal s’est désisté volontairement, le complice :',
    options: [
      'Ne peut pas être poursuivi (tentative de complicité non punissable)',
      'Est toujours poursuivi',
      'Est poursuivi uniquement si mineur',
    ],
    answer:
        'Ne peut pas être poursuivi (tentative de complicité non punissable)',
    explanation:
        'Le cours : si auteur = actes préparatoires / désistement -> pas de poursuite du complice.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (fait principal)',
    question:
        'La complicité ne peut pas être retenue si le fait principal est justifié par :',
    options: [
      'La légitime défense',
      'L’ordre de la loi',
      'Toutes les réponses sont exactes',
    ],
    answer: 'Toutes les réponses sont exactes',
    explanation:
        'Le cours : légitime défense / ordre de la loi / commandement autorité légitime.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (fait principal)',
    question:
        'La complicité ne peut pas être retenue si le fait principal n’est plus punissable en cas :',
    options: [
      'De prescription de l’action publique',
      'D’amnistie',
      'Toutes les réponses sont exactes',
    ],
    answer: 'Toutes les réponses sont exactes',
    explanation:
        'Le cours : prescription ou amnistie -> fait principal plus punissable.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (fait principal)',
    question:
        'Le complice peut être poursuivi même si l’auteur principal n’est pas puni lorsque :',
    options: [
      'L’auteur est en fuite',
      'L’auteur est décédé',
      'Toutes les réponses sont exactes',
    ],
    answer: 'Toutes les réponses sont exactes',
    explanation:
        'Le cours : fuite, inconnu, décès, irresponsabilité, exemption légale.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (fait principal)',
    question:
        'Le complice peut être poursuivi si l’auteur principal bénéficie :',
    options: [
      'D’une cause d’irresponsabilité (ex : trouble, minorité)',
      'D’une exemption légale de peine',
      'Toutes les réponses sont exactes',
    ],
    answer: 'Toutes les réponses sont exactes',
    explanation: 'Le cours l’indique clairement.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (fait principal)',
    question:
        'Selon l’article 121-7, en principe, la complicité est possible pour :',
    options: [
      'Tous les crimes et délits',
      'Uniquement les crimes',
      'Uniquement les contraventions',
    ],
    answer: 'Tous les crimes et délits',
    explanation: 'Le cours : crimes et délits susceptibles de complicité.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (contraventions)',
    question:
        'En matière de contraventions, la complicité par provocation ou instructions est :',
    options: [
      'Systématiquement réprimée',
      'Jamais réprimée',
      'Réprimée uniquement pour les 1ère classe',
    ],
    answer: 'Systématiquement réprimée',
    explanation: 'Le cours : art. R. 610-2 C.P.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (contraventions)',
    question:
        'En matière de contraventions, la complicité par aide/assistance est :',
    options: [
      'Toujours réprimée',
      'Réprimée uniquement si un texte spécial le prévoit',
      'Jamais réprimée, même si texte',
    ],
    answer: 'Réprimée uniquement si un texte spécial le prévoit',
    explanation:
        'Le cours : aide/assistance contraventionnelle seulement si texte express.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (contraventions)',
    question:
        'La complicité par aide/assistance en contravention est réprimée :',
    options: [
      'Uniquement lorsque la loi le prévoit expressément',
      'Toujours, par principe',
      'Jamais, même avec texte',
    ],
    answer: 'Uniquement lorsque la loi le prévoit expressément',
    explanation: 'Rappel : nécessité d’un texte spécial.',
    difficulty: 'Moyen',
  ),

  /////////////////////////////////////////////////////////////////////////////
  /// COMPLICITÉ — ACTES DE PARTICIPATION (ART. 121-7) (96 → 135)
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (actes)',
    question: 'Les actes de complicité sont :',
    options: [
      'Des actes positifs',
      'Uniquement des abstentions',
      'Uniquement des pensées',
    ],
    answer: 'Des actes positifs',
    explanation: 'Le cours : abstention ≠ acte de complicité.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (actes)',
    question: 'L’abstention peut être retenue comme acte de complicité :',
    options: [
      'Oui, toujours',
      'Non, en principe',
      'Oui, seulement si la victime le demande',
    ],
    answer: 'Non, en principe',
    explanation: 'Le cours : actes positifs requis.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (actes)',
    question: 'Les actes de complicité doivent être :',
    options: [
      'Antérieurs ou concomitants au fait principal',
      'Uniquement postérieurs',
      'Uniquement très longtemps après',
    ],
    answer: 'Antérieurs ou concomitants au fait principal',
    explanation: 'Le cours : pas de complicité postérieure.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (actes)',
    question: 'Il existe une complicité postérieure à l’infraction :',
    options: ['Oui', 'Non', 'Uniquement en crime'],
    answer: 'Non',
    explanation: 'Le cours : pas de complicité postérieure.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (provocation)',
    question: 'La provocation comme mode de complicité suppose notamment :',
    options: [
      'Don, promesse, ordre, menace, abus d’autorité ou de pouvoir',
      'Une simple opinion',
      'Un silence approbateur',
    ],
    answer: 'Don, promesse, ordre, menace, abus d’autorité ou de pouvoir',
    explanation: 'Le cours : simple conseil insuffisant.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (provocation)',
    question:
        'Un simple conseil donné à quelqu’un pour commettre une infraction entraîne :',
    options: [
      'Toujours la complicité',
      'Pas la complicité en tant que telle (selon le cours)',
      'Une immunité',
    ],
    answer: 'Pas la complicité en tant que telle (selon le cours)',
    explanation:
        'Le cours : la provocation doit être accompagnée de circonstances (don/promesse/ordre…).',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (provocation)',
    question: 'La provocation doit être :',
    options: [
      'Individuelle (adressée à une personne déterminée)',
      'Collective (adressée au public indifférencié)',
      'Anonyme uniquement',
    ],
    answer: 'Individuelle (adressée à une personne déterminée)',
    explanation: 'Le cours : provocation individuelle.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (provocation)',
    question: 'Pour être retenue, la provocation doit être suivie :',
    options: [
      'D’effets (infraction réalisée ou tentée)',
      'D’un simple regret',
      'D’une plainte civile',
    ],
    answer: 'D’effets (infraction réalisée ou tentée)',
    explanation: 'Le cours : exigence d’effets.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (instructions)',
    question: 'La fourniture d’instructions correspond :',
    options: [
      'À des indications précises facilitant l’exécution, données en connaissance de cause',
      'À une abstention',
      'À une menace postérieure',
    ],
    answer:
        'À des indications précises facilitant l’exécution, données en connaissance de cause',
    explanation: 'Le cours : instructions précises + connaissance.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (instructions)',
    question:
        'Donner les horaires d’absence d’une personne en vue d’un cambriolage illustre :',
    options: [
      'La fourniture d’instructions',
      'La légitime défense',
      'L’état de nécessité',
    ],
    answer: 'La fourniture d’instructions',
    explanation: 'Exemple du cours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (aide/assistance)',
    question: 'L’aide ou l’assistance suppose que l’acte ait :',
    options: [
      'Facilité la préparation ou la consommation de l’infraction',
      'Empêché l’infraction',
      'Fait disparaître le dommage',
    ],
    answer: 'Facilité la préparation ou la consommation de l’infraction',
    explanation: 'Le cours : aide/assistance = facilitation.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (aide/assistance)',
    question: 'Fournir une arme en connaissance de cause à l’auteur illustre :',
    options: ['Aide/assistance', 'Erreur de droit', 'Contrainte morale'],
    answer: 'Aide/assistance',
    explanation: 'Exemple du cours : fourniture de moyens matériels.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (aide/assistance)',
    question:
        'Jouer de la musique pour couvrir les cris pendant une agression illustre :',
    options: [
      'Un concours au moment de la réalisation (aide/assistance)',
      'Une provocation nécessairement',
      'Une abstention',
    ],
    answer: 'Un concours au moment de la réalisation (aide/assistance)',
    explanation: 'Exemple du cours.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (actes)',
    question:
        'La liste des actes de participation est énumérée principalement à :',
    options: [
      'L’article 121-7 du Code pénal',
      'L’article 121-1 du Code pénal',
      'L’article 131-39 du Code pénal',
    ],
    answer: 'L’article 121-7 du Code pénal',
    explanation: 'Le cours : art. 121-7.',
    difficulty: 'Facile',
  ),

  /////////////////////////////////////////////////////////////////////////////
  /// COMPLICITÉ — INTENTION / HAPPY SLAPPING / RÉPRESSION (136 → 170)
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (intention)',
    question: 'L’intention criminelle du complice exige :',
    options: [
      'Connaissance du caractère délictueux + volonté de s’associer',
      'Simple présence',
      'Uniquement un mobile honorable',
    ],
    answer: 'Connaissance du caractère délictueux + volonté de s’associer',
    explanation: 'Le cours : deux conditions cumulatives.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (intention)',
    question:
        'Dire que le complice et l’auteur ont agi « ensemble et de concert » renvoie à :',
    options: [
      'La volonté de s’associer à l’acte délictueux',
      'La force majeure',
      'L’amnistie',
    ],
    answer: 'La volonté de s’associer à l’acte délictueux',
    explanation: 'Le cours : volonté de s’associer.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (happy slapping)',
    question: 'Le « happy slapping » est traité comme un cas particulier de :',
    options: ['Complicité', 'Légitime défense', 'Erreur de droit'],
    answer: 'Complicité',
    explanation: 'Le cours : cas particulier de complicité via art. 222-33-3.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (happy slapping)',
    question: 'Le happy slapping est prévu à :',
    options: [
      'L’article 222-33-3 du Code pénal',
      'L’article 122-5 du Code pénal',
      'L’article 121-2 du Code pénal',
    ],
    answer: 'L’article 222-33-3 du Code pénal',
    explanation: 'Le cours : art. 222-33-3.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Complicité (happy slapping)',
    question: 'Selon le cours, l’article 222-33-3 a pour particularité de :',
    options: [
      'Supprimer la nécessité du lien de causalité',
      'Exiger une aide matérielle indispensable',
      'Créer une immunité',
    ],
    answer: 'Supprimer la nécessité du lien de causalité',
    explanation:
        'Le cours : filmer ≠ aide matérielle, pourtant assimilé à complicité.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Répression de la complicité',
    question: 'Selon l’article 121-6 du Code pénal :',
    options: [
      'Le complice sera puni comme auteur',
      'Le complice ne peut pas être condamné',
      'Le complice est puni uniquement d’une amende',
    ],
    answer: 'Le complice sera puni comme auteur',
    explanation: 'Le cours : art. 121-6.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Répression de la complicité',
    question: 'Même peines encourues pour auteur et complice signifie que :',
    options: [
      'Le juge doit prononcer des peines identiques',
      'Le juge peut individualiser et prononcer des peines différentes',
      'Le complice est forcément plus puni',
    ],
    answer: 'Le juge peut individualiser et prononcer des peines différentes',
    explanation: 'Le cours : pas d’obligation de peines identiques.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Répression de la complicité',
    question: 'Le complice peut être puni plus fortement que l’auteur si :',
    options: [
      'Des circonstances personnelles aggravantes lui sont propres',
      'L’auteur est mineur',
      'Toutes les réponses sont exactes',
    ],
    answer: 'Toutes les réponses sont exactes',
    explanation:
        'Le cours : circonstances propres au complice + atténuations pour l’auteur.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Répression de la complicité',
    question: 'Les circonstances personnelles à l’auteur :',
    options: [
      'Ne sont pas applicables au complice',
      'S’appliquent automatiquement au complice',
      'S’appliquent seulement en crime',
    ],
    answer: 'Ne sont pas applicables au complice',
    explanation:
        'Le cours : démence/contrainte/récidive de l’auteur ne s’appliquent pas au complice.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Répression de la complicité',
    question: 'Les circonstances réelles touchant la matérialité de l’acte :',
    options: [
      'Peuvent aggraver ou atténuer la peine applicable au complice',
      'Sont toujours personnelles',
      'Ne concernent que la victime',
    ],
    answer: 'Peuvent aggraver ou atténuer la peine applicable au complice',
    explanation:
        'Le cours : circonstances de fait modifiant la nature de l’infraction.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Répression de la complicité',
    question: 'Une circonstance réelle aggravante peut s’étendre au complice :',
    options: [
      'Même s’il ignorait l’existence de cette circonstance',
      'Uniquement s’il l’avait voulue',
      'Jamais',
    ],
    answer: 'Même s’il ignorait l’existence de cette circonstance',
    explanation: 'Le cours : ex. réunion pour le vol.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Répression de la complicité',
    question:
        'La question des circonstances aggravantes liées à la qualité de l’auteur principal a été tranchée par :',
    options: [
      'Cass. crim. 7 septembre 2005 (n°04-84.235)',
      'Cass. civ. 1998',
      'CE 2007',
    ],
    answer: 'Cass. crim. 7 septembre 2005 (n°04-84.235)',
    explanation: 'Le cours cite cet arrêt : applicables au complice.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Répression de la complicité',
    question:
        'Selon le cours, sont applicables au complice les circonstances aggravantes :',
    options: [
      'Liées à la qualité de l’auteur principal (Cass. 2005)',
      'Uniquement liées à la victime',
      'Jamais',
    ],
    answer: 'Liées à la qualité de l’auteur principal (Cass. 2005)',
    explanation: 'Cass. crim 7 sept. 2005.',
    difficulty: 'Difficile',
  ),

  /////////////////////////////////////////////////////////////////////////////
  /// PERSONNES MORALES — CHAMP / CONDITIONS / PEINES (171 → 200)
  /////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'Le principe de responsabilité pénale des personnes morales est prévu par :',
    options: [
      'Article 121-2 du Code pénal',
      'Article 121-1 du Code pénal',
      'Article 122-2 du Code pénal',
    ],
    answer: 'Article 121-2 du Code pénal',
    explanation: 'Le cours : art. 121-2 C.P.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'En droit public, la seule personne morale pénalement irresponsable est :',
    options: ['L’État', 'La commune', 'Le département'],
    answer: 'L’État',
    explanation: 'Le cours : seul l’État n’est pas pénalement responsable.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'Les établissements publics peuvent être pénalement responsables :',
    options: ['Oui', 'Non', 'Uniquement en cas de contravention'],
    answer: 'Oui',
    explanation:
        'Le cours : autres personnes morales de droit public responsables.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question: 'Les collectivités territoriales ont une responsabilité pénale :',
    options: [
      'Illimitée pour toutes infractions',
      'Limitée aux activités pouvant faire l’objet d’une délégation de service public',
      'Inexistante',
    ],
    answer:
        'Limitée aux activités pouvant faire l’objet d’une délégation de service public',
    explanation: 'Le cours : art. 121-2 al. 2 C.P.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question: 'Une délégation de service public est :',
    options: [
      'Un contrat par lequel une personne morale publique confie la gestion d’un service public à un délégataire',
      'Une décision pénale de condamnation',
      'Une perquisition',
    ],
    answer:
        'Un contrat par lequel une personne morale publique confie la gestion d’un service public à un délégataire',
    explanation: 'Définition donnée dans le cours (cantine scolaire, eau…).',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question: 'Une personne morale de droit privé suppose notamment :',
    options: [
      'Que les formalités légales d’existence aient été réalisées (déclaration, immatriculation…) ',
      'Qu’elle soit forcément lucrative',
      'Qu’elle soit forcément publique',
    ],
    answer:
        'Que les formalités légales d’existence aient été réalisées (déclaration, immatriculation…) ',
    explanation: 'Le cours : personnalité morale + formalités obligatoires.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'Sont concernées par la responsabilité pénale des personnes morales de droit privé :',
    options: [
      'Les structures lucratives et non lucratives',
      'Uniquement les sociétés commerciales',
      'Uniquement les associations',
    ],
    answer: 'Les structures lucratives et non lucratives',
    explanation: 'Le cours : sociétés/associations/syndicats/partis…',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'Deux conditions cumulatives pour engager la responsabilité pénale d’une personne morale :',
    options: [
      'Infraction par organes/représentants + infraction pour le compte de la personne morale',
      'Plainte + expertise',
      'Dommage + aveu',
    ],
    answer:
        'Infraction par organes/représentants + infraction pour le compte de la personne morale',
    explanation: 'Le cours : 2 conditions cumulatives.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'L’infraction commise par un salarié sans mandat de représentation engage en principe la personne morale :',
    options: [
      'Oui, automatiquement',
      'Non, en principe non',
      'Oui, seulement si l’infraction est un crime',
    ],
    answer: 'Non, en principe non',
    explanation: 'Le cours : pas de mandat = en principe pas d’engagement.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'L’action « pour le compte » de la personne morale implique souvent :',
    options: [
      'Un intérêt (profit/économie) ou un acte lié à l’organisation/fonctionnement/objet',
      'Un intérêt exclusivement personnel du dirigeant',
      'Une contrainte',
    ],
    answer:
        'Un intérêt (profit/économie) ou un acte lié à l’organisation/fonctionnement/objet',
    explanation: 'Le cours : intérêt retiré ou acte pour assurer l’objet.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'Si l’infraction est commise au seul profit personnel du dirigeant, la personne morale :',
    options: [
      'N’engage pas sa responsabilité (selon le cours)',
      'Est toujours responsable',
      'Est responsable uniquement en contravention',
    ],
    answer: 'N’engage pas sa responsabilité (selon le cours)',
    explanation: 'Le cours : profit personnel seul -> pas « pour le compte ». ',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question: 'Les personnes morales peuvent être responsables en qualité :',
    options: [
      'D’auteur ou de complice',
      'Uniquement de victime',
      'Uniquement de témoin',
    ],
    answer: 'D’auteur ou de complice',
    explanation:
        'Le cours : art. 121-2 renvoie aux distinctions auteur/complice.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'La responsabilité pénale des personnes morales est une règle de portée générale, sauf exception notamment :',
    options: [
      'Les délits en matière de presse et de communication audiovisuelle',
      'Les crimes uniquement',
      'Les contraventions uniquement',
    ],
    answer: 'Les délits en matière de presse et de communication audiovisuelle',
    explanation:
        'Le cours : art. 121-2 — portée générale, exception presse/communication audiovisuelle.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'La responsabilité de la personne morale exclut celle des personnes physiques :',
    options: [
      'Oui, toujours',
      'Non, elle ne l’exclut pas',
      'Oui, uniquement si l’amende est payée',
    ],
    answer: 'Non, elle ne l’exclut pas',
    explanation: 'Le cours : cumul possible des responsabilités.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question: 'La personne morale peut parfois être poursuivie seule si :',
    options: [
      'Il est impossible d’identifier individuellement le dirigeant/représentant auteur',
      'La victime refuse',
      'Le juge civil l’ordonne',
    ],
    answer:
        'Il est impossible d’identifier individuellement le dirigeant/représentant auteur',
    explanation: 'Le cours : négligence/décision collective, vote secret…',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales (peines)',
    question: 'Pour les personnes morales, l’amende encourue est en principe :',
    options: [
      'Le quintuple de celle prévue pour les personnes physiques',
      'Le double de celle des personnes physiques',
      'Toujours 75 000 €',
    ],
    answer: 'Le quintuple de celle prévue pour les personnes physiques',
    explanation: 'Le cours : amende = quintuple.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales (peines)',
    question:
        'Si aucun crime ne prévoit d’amende pour les personnes physiques, l’amende encourue par la personne morale est :',
    options: ['1 000 000 €', '75 000 €', '10 000 €'],
    answer: '1 000 000 €',
    explanation:
        'Le cours : crime sans amende pour personne physique -> 1 000 000 € pour personne morale.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales (peines)',
    question:
        'Les peines énumérées notamment à l’article 131-39 du Code pénal concernent :',
    options: [
      'Des peines possibles contre une personne morale pour crime/délit si la loi le prévoit',
      'Uniquement les personnes physiques',
      'Uniquement les contraventions',
    ],
    answer:
        'Des peines possibles contre une personne morale pour crime/délit si la loi le prévoit',
    explanation: 'Le cours : 131-39 (liste) + 131-39-2.',
    difficulty: 'Moyen',
  ),
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales (peines)',
    question: 'La sanction-réparation (131-39-1) consiste à :',
    options: [
      'Indemniser la victime dans un délai et selon modalités fixées',
      'Mettre en prison la personne morale',
      'Transformer l’infraction en contravention',
    ],
    answer: 'Indemniser la victime dans un délai et selon modalités fixées',
    explanation: 'Le cours : indemniser la victime (sanction-réparation).',
    difficulty: 'Moyen',
  ),

  //////////////////////////////////////////////////////////////////////////////
  // RESPONSABILITÉ PÉNALE DES PERSONNES MORALES (ART. 121-2)
  //////////////////////////////////////////////////////////////////////////////
  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'Le principe de responsabilité pénale des personnes morales est prévu par :',
    options: [
      'Article 121-2 du Code pénal',
      'Article 121-7 du Code pénal',
      'Article 122-5 du Code pénal',
    ],
    answer: 'Article 121-2 du Code pénal',
    explanation:
        'Le cours indique que le principe de la responsabilité pénale des personnes morales est prévu par l’article 121-2 du Code pénal.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'Concernant les personnes morales de droit public, laquelle n’est pas pénalement responsable ?',
    options: [
      'L’État',
      'Les établissements publics',
      'Les collectivités territoriales',
    ],
    answer: 'L’État',
    explanation:
        'Le cours : seul l’État n’est pas pénalement responsable. Les autres personnes morales de droit public peuvent l’être.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'Les collectivités territoriales (régions, départements, communes) voient leur responsabilité pénale limitée :',
    options: [
      'À toutes les infractions sans exception',
      'Aux infractions commises dans l’exercice d’activités pouvant faire l’objet d’une délégation de service public',
      'Uniquement aux contraventions',
    ],
    answer:
        'Aux infractions commises dans l’exercice d’activités pouvant faire l’objet d’une délégation de service public',
    explanation:
        'Le cours : art. 121-2 al. 2 du Code pénal — limitation aux infractions commises dans l’exercice d’activités pouvant faire l’objet d’une convention de délégation de service public.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'Pour engager la responsabilité pénale d’une personne morale, deux conditions cumulatives sont nécessaires :',
    options: [
      'Une plainte + un dommage',
      'Infraction commise par ses organes/représentants + infraction commise pour son compte',
      'Une condamnation préalable d’un salarié + une mise en demeure',
    ],
    answer:
        'Infraction commise par ses organes/représentants + infraction commise pour son compte',
    explanation:
        'Le cours : deux conditions cumulatives — commission par les organes ou représentants + commission pour le compte de la personne morale.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'La responsabilité pénale de la personne morale exclut celle des personnes physiques impliquées :',
    options: [
      'Oui, toujours',
      'Non, elle n’exclut pas celle des personnes physiques (auteurs/complices)',
      'Oui, uniquement si la personne morale est condamnée',
    ],
    answer:
        'Non, elle n’exclut pas celle des personnes physiques (auteurs/complices)',
    explanation:
        'Le cours : la responsabilité pénale de la personne morale n’exclut pas celle des personnes physiques auteurs ou complices des mêmes faits.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'La responsabilité pénale des personnes morales est une règle de portée générale, sauf exception notamment :',
    options: [
      'Les délits en matière de presse et de communication audiovisuelle',
      'Les crimes uniquement',
      'Les contraventions uniquement',
    ],
    answer: 'Les délits en matière de presse et de communication audiovisuelle',
    explanation:
        'Le cours : art. 121-2 — portée générale, à l’exception des délits en matière de presse (ex : art. 43-1) et de communication audiovisuelle.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'Une infraction commise de son propre chef par un salarié sans mandat de représentation engage en principe la personne morale :',
    options: [
      'Oui, automatiquement',
      'Non, en principe non',
      'Oui, uniquement en contravention',
    ],
    answer: 'Non, en principe non',
    explanation:
        'Le cours : l’infraction commise par un salarié n’ayant aucun mandat de représentation n’engage pas, en principe, la personne morale.',
    difficulty: 'Moyen',
  ),

  const QuizQuestion(
    category: 'Droit pénal général — Personnes morales',
    question:
        'L’action « pour le compte » de la personne morale se matérialise notamment par :',
    options: [
      'Un intérêt retiré (profit ou économie) ou un acte assurant l’organisation/fonctionnement/objet',
      'Un intérêt exclusivement personnel du dirigeant',
      'Une simple rumeur publique',
    ],
    answer:
        'Un intérêt retiré (profit ou économie) ou un acte assurant l’organisation/fonctionnement/objet',
    explanation:
        'Le cours : « pour le compte » = intérêt (profit/économie) ou acte visant l’organisation/le fonctionnement/l’objet de la personne morale.',
    difficulty: 'Moyen',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizResponsabilitePenalePage extends StatefulWidget {
  static const String routeName =
      '/gpx/droit_penal/quiz/responsabilite_penal_general';
  final String uid;
  final String email;

  const QuizResponsabilitePenalePage({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizResponsabilitePenalePage> createState() =>
      _QuizResponsabilitePenalePageState();
}

class _QuizResponsabilitePenalePageState
    extends State<QuizResponsabilitePenalePage>
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
        ? questionsGPXSchoolResponsabilitePenalGeneral
        : questionsGPXSchoolResponsabilitePenalGeneral
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
            'module_name': 'Loi pénale',
            'quiz_name': 'Responsabilité pénale',
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

  /// Garde de réentrance des sorties : deux dialogues de confirmation ne peuvent
  /// pas se superposer (croix tapée deux fois, ou croix pendant un geste retour).
  bool _sortieEnCours = false;

  /// Ferme le quiz après confirmation. Chemin unique de la croix et, quand il
  /// existe, du geste retour système — sans quoi celui-ci contournerait la
  /// confirmation.
  Future<void> _fermerQuiz() async {
    if (_sortieEnCours) return;
    _sortieEnCours = true;
    try {
      // Rien n'est engagé avant le choix du niveau : on sort sans demander.
      if (!_hasQuiz) {
        if (mounted) _quitterEcran();
        return;
      }
      final confirme = await _confirmerSortie(
        titre: 'Quitter le quiz ?',
        actionLabel: 'Quitter',
      );
      if (!confirme || !mounted) return;
      await _updateHistoryOnFinish();
      if (!mounted) return;
      _quitterEcran();
    } finally {
      _sortieEnCours = false;
    }
  }

  /// Sortie effective de l'écran.
  ///
  /// **`pop()` et non `maybePop()`.** `maybePop` consulte les `PopScope` de la
  /// route avant de dépiler : sous un `PopScope` qui bloque la sortie pendant un
  /// quiz, il se ferait refuser et rappellerait la confirmation en boucle — gel
  /// de l'interface. `pop()` dépile directement, ce qui est exactement ce qu'on
  /// veut une fois la décision confirmée.
  void _quitterEcran() {
    final nav = Navigator.of(context);
    if (nav.canPop()) nav.pop();
  }

  /// Dialogue commun à « Mettre fin » et à la fermeture.
  Future<bool> _confirmerSortie({
    required String titre,
    required String actionLabel,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // On reprend la mise en scène de la carte de résultat — flou d'arrière-plan,
    // fondu, léger agrandissement — au lieu de l'`AlertDialog` par défaut.
    final reponse = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Confirmation',
      barrierColor: Colors.black.withValues(alpha: 0.35),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (ctx, __, ___) => Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: const SizedBox.expand(),
            ),
          ),
          Center(
            child: _ConfirmCard(
              isDark: isDark,
              titre: titre,
              message: 'Tes réponses déjà validées sont enregistrées, et ton '
                  'score sera calculé sur cette base.',
              actionLabel: actionLabel,
              onConfirmer: () => Navigator.of(ctx).pop(true),
              onAnnuler: () => Navigator.of(ctx).pop(false),
            ),
          ),
        ],
      ),
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
        child: ScaleTransition(
          scale: Tween(begin: .96, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOutBack))
              .animate(anim),
          child: child,
        ),
      ),
    );
    return reponse ?? false;
  }

  Future<void> _endQuizNow() async {
    if (!_hasQuiz) return;

    final confirme = await _confirmerSortie(
      titre: 'Mettre fin au quiz ?',
      actionLabel: 'Mettre fin',
    );
    if (!confirme || !mounted) return;

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
      await _sb.from('quiz_responsabilite_penale').insert({
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
      debugPrint('❌ quiz_responsabilite_penale insert failed: $e');
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
    HapticFeedback.selectionClick();
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
        final bg = isDark ? const Color(0xFF000B36) : _Brand.bgLight;
        final textCol = isDark ? Colors.white : _Brand.textDark;
        final base = isDark ? ThemeData.dark() : ThemeData.light();

        const double kButtonHeight = 56;
        const double kButtonVPad = 16;
        const double bottomBarReserved = kButtonHeight + kButtonVPad + 8;

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
            child: Stack(
              children: [
                Positioned.fill(child: _QuizBackdrop(isDark: isDark)),
                Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.close_rounded, color: textCol),
                  onPressed: _fermerQuiz,
                  tooltip: 'Fermer',
                ),
              ),
              body: SafeArea(
                top: false,
                child: LayoutBuilder(
                  builder: (context, _) {

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Masquée à la source plutôt que recouverte : on ne
                        // construit pas une interface pour la dissimuler.
                          if (!_showSplash)
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

                                  // La réserve ajoutait jusqu'à 240 px de vide sous la carte pour
// loger la croix flottante. Le feedback vivant désormais dans le
// bandeau, seule la barre de boutons est à compenser.
final double bottomInsetForThisPage = bottomBarReserved;

                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      20,
                                      8,
                                      20,
                                      0,
                                    ),
                                    child: KeyedSubtree(
                                      key: ValueKey('page_$i'),
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
                                        estActive: i == _index,
                                        pulse: _pulseCtrl,
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

                        // L'overlay de feedback a été retiré : il se superposait au bandeau
                          // d'explication dès que l'énoncé était long. L'animation vit
                          // maintenant dans `_OutcomeIcon`, bornée par le bandeau.

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
              ],
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
                  // Ferme la carte de résultat, puis l'écran. `pop()` et non
                  // `maybePop()` : sous un `PopScope`, `maybePop` relancerait
                  // la confirmation de sortie en boucle.
                  Navigator.of(context).pop();
                  _quitterEcran();
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
          'Question ${index + 1} / $totalSafe',
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
          backgroundColor: _opa(_Brand.bad, .10),
          foregroundColor: isEnabled ? _Brand.bad : _opa(_Brand.bad, .35),
          side: BorderSide(
            color: _opa(isEnabled ? _Brand.bad : _opa(_Brand.bad, .35), .55),
            width: 1.4,
          ),
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

class _QuestionCard extends StatefulWidget {
  final QuizQuestion question;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;
  final bool locked;
  final bool showOutcome;
  final bool isCorrect;

  /// Marge basse à ajouter dans le scroll pour éviter toute coupe
  /// `true` quand cette page est celle que l'utilisateur regarde.
  ///
  /// Indispensable : `PageView.builder` construit aussi les pages voisines
  /// à l'avance. Sans ce garde-fou, la cascade de la question suivante se
  /// jouerait hors écran et serait déjà terminée à l'arrivée.
  final bool estActive;

  /// Contrôleur du feedback, relancé à chaque validation par `_validate`.
  final AnimationController pulse;

  final double bottomSafeInset;

  const _QuestionCard({
    required this.question,
    required this.options,
    required this.selected,
    required this.onSelect,
    required this.locked,
    required this.showOutcome,
    required this.isCorrect,
    required this.estActive,
    required this.pulse,
    this.bottomSafeInset = 0,
  });

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard>
    with SingleTickerProviderStateMixin {
  // ─── Cascade d'apparition ────────────────────────────────────────────────
  //
  // Un seul `AnimationController` pilote la séquence ; chaque élément lit une
  // fenêtre différente de sa progression via un `Interval`. L'alternative — un
  // contrôleur et un `Timer` par élément — multiplierait les tickers par le
  // nombre d'options, sur chaque page vivante du `PageView`.
  static const int _msElement = 420;
  static const int _msDecalage = 130;

  int get _nbElements => 1 + (_afficheSousTitre ? 1 : 0) + widget.options.length;

  /// Le sous-titre compte comme un élément de la séquence quand il est affiché.
  bool get _afficheSousTitre => (widget.question.sub?.trim().isNotEmpty ?? false);

  int get _msTotal => _msDecalage * (_nbElements - 1) + _msElement;

  late final AnimationController _cascade = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: _msTotal),
  );

  /// Contrôleur de la colonne, pour amener le bandeau de correction dans le champ
  /// de vision : sur un énoncé long, l'explication naissait sous le pli.
  final ScrollController _colonne = ScrollController();

  /// Ancre posée sur le bandeau, cible du défilement.
  final GlobalKey _ancreBandeau = GlobalKey();

  bool get _mouvementReduit => WidgetsBinding
      .instance
      .platformDispatcher
      .accessibilityFeatures
      .disableAnimations;

  @override
  void initState() {
    super.initState();
    // Accessibilité : on saute à l'état final, jamais à un état invisible.
    if (_mouvementReduit) {
      _cascade.value = 1;
    } else if (widget.estActive) {
      _cascade.forward();
    }
  }

  @override
  void didUpdateWidget(_QuestionCard old) {
    super.didUpdateWidget(old);

    final duree = Duration(milliseconds: _msTotal);
    if (_cascade.duration != duree) _cascade.duration = duree;

    if (_mouvementReduit) {
      _cascade.value = 1;
      return;
    }

    // La page vient de devenir celle qu'on regarde : la cascade démarre en même
    // temps que le glissement du `PageView`, `_index` étant mis à jour avant
    // l'appel à `nextPage`.
    if (!old.estActive && widget.estActive) {
      _cascade
        ..reset()
        ..forward();
    }

    if (!old.showOutcome && widget.showOutcome && widget.estActive) {
      _revelerBandeau();
    }
  }

  @override
  void dispose() {
    _cascade.dispose();
    _colonne.dispose();
    super.dispose();
  }

  void _revelerBandeau() {
    // Après la frame qui insère le bandeau : avant, sa position n'existe pas.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _ancreBandeau.currentContext;
      if (ctx == null || !_colonne.hasClients) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        // 0.9 plutôt que 1.0 : le bandeau se cale vers le bas de la zone visible
        // en gardant les options au-dessus dans le champ.
        alignment: 0.9,
      );
    });
  }

  /// Fenêtre d'animation du n-ième élément de la séquence.
  Animation<double> _fenetre(int rang) {
    final total = _msTotal;
    final debut = (_msDecalage * rang) / total;
    final fin = (_msDecalage * rang + _msElement) / total;
    return CurvedAnimation(
      parent: _cascade,
      curve: Interval(
        debut.clamp(0.0, 1.0),
        fin.clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  /// Énoncé nettoyé de l'énumération des options.
  ///
  /// Beaucoup de questions répètent les réponses dans leur libellé, puis les
  /// mêmes options s'affichent juste en dessous : le titre double de hauteur et
  /// la question perd sa force. La coupe est conservatrice — il faut un `:` suivi
  /// de texte, **toutes** les options retrouvées après lui, une partie conservée
  /// d'au moins 15 caractères, et aucune option de moins de 4 caractères, qui se
  /// retrouverait par hasard dans n'importe quelle phrase.
  String get _enonceAffiche {
    final brut = widget.question.question.trim();
    final coupe = brut.lastIndexOf(':');
    if (coupe <= 0 || coupe >= brut.length - 1) return brut;

    final avant = brut.substring(0, coupe).trim();
    final apres = brut.substring(coupe + 1).toLowerCase();
    if (avant.length < 15) return brut;

    for (final o in widget.options) {
      final option = o.trim();
      if (option.length < 4) return brut;
      if (!apres.contains(option.toLowerCase())) return brut;
    }
    return avant.endsWith('?') ? avant : '$avant ?';
  }

  /// Taille du titre, réduite par palier quand l'énoncé s'allonge : à 28 px fixes
  /// et avec un réglage de texte système élevé, les options passaient sous le pli.
  double _tailleTitre(String enonce) {
    if (enonce.length > 150) return 21;
    if (enonce.length > 110) return 23;
    if (enonce.length > 75) return 25;
    return 28;
  }

  @override
  Widget build(BuildContext context) {
    // Rang dans la cascade : le titre ouvre, le sous-titre suit s'il
    // existe, puis les options dans l'ordre d'affichage.
    var rangCascade = 0;
    final enonce = _enonceAffiche;
    final textCol = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : _Brand.textDark;

    return SingleChildScrollView(
      controller: _colonne,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: 8,
        // marge bas normale + réserve (animation + bouton)
        bottom: 12 + widget.bottomSafeInset,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ElementCascade(
            animation: _fenetre(rangCascade++),
            child: Text(
            enonce,
            style: _Brand.h1(context).copyWith(
              color: textCol,
              fontSize: _tailleTitre(enonce),
            ),
          ),
          ),
          if (widget.question.sub != null) ...[
            const SizedBox(height: 6),
            _ElementCascade(
              animation: _fenetre(rangCascade++),
              child: Text(
              widget.question.sub!,
              style: TextStyle(
                color: textCol.withAlpha(180),
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
            ),
          ],
          const SizedBox(height: 16),

          // Options
          ...widget.options.map((o) {
            final isSel = widget.selected == o;
            final correctShown = widget.showOutcome && o == widget.question.answer;
            final wrongShown = widget.showOutcome && isSel && o != widget.question.answer;

            return _ElementCascade(
              animation: _fenetre(rangCascade++),
              child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OptionTile(
                label: o,
                selected: isSel,
                locked: widget.locked,
                correct: correctShown,
                wrong: wrongShown,
                onTap: () => widget.onSelect(o),
              ),
            ),
            );
          }),

          // Explication
          AnimatedSwitcher(
            key: _ancreBandeau,
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            layoutBuilder: (currentChild, previousChildren) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (currentChild != null) currentChild,
                ...previousChildren,
              ],
            ),
            child: widget.showOutcome
                ? _OutcomeCard(
                    key: ValueKey<bool>(widget.isCorrect),
                    good: widget.isCorrect,
                    explanation: widget.question.explanation,
                    pulse: widget.pulse,
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

  /// Animation du feedback, partagée avec la page : elle doit partir au
  /// moment exact de la validation, pas à la construction du bandeau.
  final AnimationController pulse;
  const _OutcomeCard({
    super.key,
    required this.good,
    required this.explanation,
    required this.pulse,
  });

  @override
  Widget build(BuildContext context) {
    final color = good ? _Brand.good : _Brand.bad;
    final icon = good ? Icons.check_circle_rounded : Icons.cancel_rounded;

    // Dimensionnement adaptatif, sur deux axes : la largeur d'écran — 28 px
    // fixes paraissaient gros sur un petit téléphone et perdus sur une tablette
    // — et le réglage de taille de texte du système, l'icône devant grandir avec
    // l'explication qu'elle accompagne.
    final largeur = MediaQuery.sizeOf(context).width;
    final scaler = MediaQuery.textScalerOf(context);
    final double tailleIcone = scaler
        .scale((largeur / 13.5).clamp(24.0, 34.0))
        .clamp(24.0, 52.0);

    // Zone carrée un peu plus large que l'icône : les étincelles s'y déploient
    // sans empiéter sur le texte, puisqu'elles sont bornées ici et non posées en
    // overlay au-dessus de la page.
    final zone = tailleIcone * 1.7;

    // Alignement optique : l'icône est centrée dans `zone`, son centre est donc
    // à `zone / 2`. La première ligne du texte s'y cale, moins sa demi-hauteur.
    const double tailleTexte = 14.0;
    const double hauteurLigne = 1.32;
    final double demiLigne = scaler.scale(tailleTexte) * hauteurLigne / 2;
    final double decalageTexte = (zone / 2 - demiLigne).clamp(0.0, 24.0);

    // Une seule boîte peinte : bord et fond partagent la même `BoxDecoration`,
    // et la marge est passée à l'extérieur du widget bordé.
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _opa(color, .10),
          // 22 comme les options : le bandeau est collé sous la dernière, à
          // largeur identique — une rupture de rayon se verrait.
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _opa(color, .55), width: 1.2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: zone,
              height: zone,
              child: _OutcomeIcon(
                controller: pulse,
                icon: icon,
                color: color,
                tailleIcone: tailleIcone,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: decalageTexte),
                child: Text(
                  explanation,
                  softWrap: true,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : _Brand.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: tailleTexte,
                    height: hauteurLigne,
                    decoration: TextDecoration.none,
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

// `_FeedbackStrip` et `_FeedbackSparkles` supprimés : l'animation de résultat
// vit désormais dans `_OutcomeIcon`, à l'intérieur du bandeau d'explication.
// `_Star` est conservé, il sert aux étincelles.


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
    with SingleTickerProviderStateMixin {
  // ─── Cascade d'ouverture ─────────────────────────────────────────────────
  //
  // Même mécanique et même widget (`_ElementCascade`) que l'arrivée d'une
  // question : un seul contrôleur, chaque élément lisant une fenêtre différente
  // de sa progression via un `Interval`. Les deux écrans partagent donc le même
  // geste — fondu plus montée de 10 px.
  //
  // Rangs explicites plutôt qu'un compteur incrémenté pendant le build : le
  // `LayoutBuilder` des cartes peut être rappelé à chaque relayout, et un
  // compteur mutable y dériverait à chaque passe.
  static const int _msElement = 380;
  static const int _msDecalage = 90;
  static const int _rangTitre = 0;
  static const int _rangSousTitre = 1;
  static const int _rangFacile = 2;
  static const int _rangMoyen = 3;
  static const int _rangDifficile = 4;
  static const int _rangCommencer = 5;
  static const int _rangMelanger = 6;
  static const int _nbElements = 7;

  late final AnimationController _entree = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: _msDecalage * (_nbElements - 1) + _msElement,
    ),
  );

  @override
  void initState() {
    super.initState();
    final reduit = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    // On saute à l'état final, jamais à un écran vide.
    if (reduit) {
      _entree.value = 1;
    } else {
      _entree.forward();
    }
  }

  @override
  void dispose() {
    _entree.dispose();
    super.dispose();
  }

  Animation<double> _fenetre(int rang) {
    const total = _msDecalage * (_nbElements - 1) + _msElement;
    final debut = (_msDecalage * rang) / total;
    final fin = (_msDecalage * rang + _msElement) / total;
    return CurvedAnimation(
      parent: _entree,
      curve: Interval(
        debut.clamp(0.0, 1.0),
        fin.clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );
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
            // Aucun fond propre : le splash laisse voir le `_QuizBackdrop` de la
            // page. Il empilait auparavant son dégradé et ses halos par-dessus
            // celui du quiz — deux systèmes d'animation superposés, et une
            // rupture de teinte au démarrage. Un voile suffit à détacher le
            // contenu du fond.
            Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: isDark ? .28 : .04),
                ),
              ),
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
                        _ElementCascade(
                          animation: _fenetre(_rangTitre),
                          child: Text(
                          'Sélectionne le niveau de difficulté',
                          textAlign: TextAlign.center,
                          style: _Brand.h1(
                            context,
                          ).copyWith(color: textMain, fontSize: 24),
                        ),
                        ),
                        const SizedBox(height: 8),
                        _ElementCascade(
                          animation: _fenetre(_rangSousTitre),
                          child: Text(
                          'Nouvelles questions à chaque partie.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: sub,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                            decoration: TextDecoration.none,
                          ),
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
                              _ElementCascade(
                                animation: _fenetre(_rangFacile),
                                child: _LevelCard(
                                label: 'Facile',
                                icon: Icons.eco_rounded,
                                tint: const Color(0xFF22C55E),
                                active: widget.selected == 'Facile',
                                onTap: () => widget.onSelect('Facile'),
                                isDark: isDark,
                              ),
                              ),
                              _ElementCascade(
                                animation: _fenetre(_rangMoyen),
                                child: _LevelCard(
                                label: 'Moyen',
                                icon: Icons.military_tech_rounded,
                                tint: const Color(0xFFF59E0B),
                                active: widget.selected == 'Moyenne',
                                onTap: () => widget.onSelect('Moyenne'),
                                isDark: isDark,
                              ),
                              ),
                              _ElementCascade(
                                animation: _fenetre(_rangDifficile),
                                child: _LevelCard(
                                label: 'Difficile',
                                icon: Icons.emoji_events_rounded,
                                tint: const Color(0xFFEF4444),
                                active: widget.selected == 'Difficile',
                                onTap: () => widget.onSelect('Difficile'),
                                isDark: isDark,
                              ),
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
                                  const SizedBox(height: spacing),
                                  children[1],
                                  const SizedBox(height: spacing),
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
                            child: Text(
                              widget.selected == null
                                  ? 'Choisis un niveau'
                                  : 'Commencer',
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Bouton Aléatoire (mix 3 niveaux)
                        _ElementCascade(
                          animation: _fenetre(_rangMelanger),
                          child: SizedBox(
                          height: 56,
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: widget.onStartRandom,
                            icon: const Icon(Icons.shuffle_rounded, size: 20),
                            label: const Text('Mélanger les 3 niveaux'),
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
                                borderRadius: BorderRadius.circular(28),
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

// `_AnimatedBackground` supprimé : dégradé propre au splash, remplacé par le
// `_QuizBackdrop` de la page. Un seul fond pour tout l'écran.


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
  /// Icône du niveau. Remplace un emoji, dont le dessin dépend de la police
  /// système et dont la couleur n'est pas contrôlable.
  final IconData icon;
  final Color tint;
  final bool active;
  final bool isDark;
  final VoidCallback onTap;

  const _LevelCard({
    required this.label,
    required this.icon,
    required this.tint,
    required this.active,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final track = _Brand.radioTrack(context);

    // Carte fixe. Le `AnimatedBuilder` + `Transform.translate` qui la
    // faisait osciller de ±2 px a été retiré : sur trois cartes à
    // comparer, ce balancement désalignait les bords en permanence.
    return AnimatedScale(
            duration: const Duration(milliseconds: 180),
            scale: active ? 1.02 : 1.0,
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
                  color: _opa(tint, isDark
                      ? (active ? .22 : .13)
                      : (active ? .18 : .10)),
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
                        color: _opa(tint, isDark ? .22 : .18),
                        border: Border.all(
                          color: active ? tint : _opa(tint, .45),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 24,
                          color: isDark ? tint : _assombrir(tint, .22),
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
          );
  }
}


/// Assombrit une teinte pour qu'elle reste lisible sur fond clair.
///
/// Les teintes de niveau sont vives (#22C55E, #F59E0B, #EF4444) : parfaites sur
/// fond sombre, trop claires en thème clair. On les rabat vers le noir plutôt
/// que d'entretenir une seconde palette en parallèle.
Color _assombrir(Color c, [double facteur = .45]) =>
    Color.lerp(c, Colors.black, facteur)!;


/// Fond du quiz, dans les deux thèmes.
///
/// Remplace un aplat (noir pur ou gris #2C2C2E) par la matière du module Cas
/// pratiques : dégradé navy, halo de lumière derrière la question, masses
/// colorées dérivantes, vignette. Le thème clair a la même construction en
/// lumineux — ce n'est pas un fond au rabais.
///
/// Trois précautions, ce fond vivant sous un `PageView` :
///  * `RepaintBoundary` isole la couche du reste de l'écran ;
///  * un seul contrôleur de 26 s pour les trois halos ;
///  * aucun flou, coûteux sur mobile d'entrée de gamme — les halos sont des
///    `RadialGradient`, déjà diffus.
class _QuizBackdrop extends StatefulWidget {
  const _QuizBackdrop({required this.isDark});
  final bool isDark;
  @override
  State<_QuizBackdrop> createState() => _QuizBackdropState();
}

class _QuizBackdropState extends State<_QuizBackdrop>
    with SingleTickerProviderStateMixin {
  static const Color _navyTop = Color(0xFF000B36);
  static const Color _navyMid = Color(0xFF000A33);
  static const Color _navyBot = Color(0xFF00082D);

  static const Color _clairTop = Color(0xFFF8FAFF);
  static const Color _clairMid = Color(0xFFEFF3FD);
  static const Color _clairBot = Color(0xFFE6ECFB);

  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 26),
  );

  @override
  void initState() {
    super.initState();
    final reduit = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    if (!reduit) _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sombre = widget.isDark;
    final degrade = sombre
        ? const [_navyTop, _navyMid, _navyBot]
        : const [_clairTop, _clairMid, _clairBot];
    // Un halo blanc serait invisible sur un fond clair : la lumière vient alors
    // du bleu brand, en très faible densité.
    final halo = sombre ? Colors.white : _Brand.accent;
    final haloFort = sombre ? 0.10 : 0.07;
    final haloFaible = sombre ? 0.035 : 0.025;
    // Du noir salirait le thème clair : on referme au bleu dilué.
    final vignette = sombre
        ? Colors.black.withValues(alpha: 0.42)
        : _Brand.accent.withValues(alpha: 0.10);

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: degrade,
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.72),
                radius: 1.15,
                colors: [
                  halo.withValues(alpha: haloFort),
                  halo.withValues(alpha: haloFaible),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
          _Halo(
            color: _Brand.accent,
            size: 300,
            dx: -130,
            dy: -180,
            ctrl: _ctrl,
            strength: sombre ? 0.16 : 0.09,
          ),
          _Halo(
            color: const Color(0xFF1A55E6),
            size: 260,
            dx: 140,
            dy: 200,
            ctrl: _ctrl,
            strength: sombre ? 0.14 : 0.08,
          ),
          _Halo(
            color: _Brand.good,
            size: 200,
            dx: 30,
            dy: 420,
            ctrl: _ctrl,
            strength: sombre ? 0.08 : 0.05,
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.15),
                  radius: 1.10,
                  colors: [Colors.transparent, vignette],
                  stops: const [0.55, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// Un élément d'une cascade d'apparition : fondu et montée de 10 px.
///
/// `FadeTransition` gère l'opacité sans rien reconstruire, et l'enfant est passé
/// à `AnimatedBuilder` via `child:` — seul le `Transform` est rebâti à chaque
/// frame, jamais le contenu.
///
/// Le décalage est en pixels et non en fraction de hauteur (ce que ferait un
/// `SlideTransition`) : un titre et une option n'ont pas la même hauteur, et une
/// fraction commune donnerait des amplitudes différentes.
class _ElementCascade extends StatelessWidget {
  const _ElementCascade({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  static const double _monteeDepart = 10.0;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (_, enfant) => Transform.translate(
          offset: Offset(0, _monteeDepart * (1 - animation.value)),
          child: enfant,
        ),
      ),
    );
  }
}


/// Icône de résultat animée : rebond à l'apparition, puis étincelles qui
/// s'écartent et s'effacent.
///
/// Remplace une croix flottante de 240 px posée en overlay au-dessus de la page,
/// qui chevauchait l'explication dès que l'énoncé était long. Bornée par le
/// `SizedBox` du bandeau, elle ne peut plus rien recouvrir.
class _OutcomeIcon extends StatelessWidget {
  const _OutcomeIcon({
    required this.controller,
    required this.icon,
    required this.color,
    required this.tailleIcone,
  });

  final AnimationController controller;
  final IconData icon;
  final Color color;
  final double tailleIcone;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final t = controller.value.clamp(0.0, 1.0);

          const n = 6;
          final rayonMax = tailleIcone * 0.72;
          final etincelles = <Widget>[];

          // Une fois l'animation finie, on ne peint plus que l'icône : aucune
          // couche inutile ne subsiste dans l'arbre de rendu.
          if (t < 0.999) {
            for (var i = 0; i < n; i++) {
              final angle = (i / n) * 2 * math.pi;
              final r = rayonMax * t;
              etincelles.add(
                Transform.translate(
                  offset: Offset(r * math.cos(angle), r * math.sin(angle)),
                  child: Transform.scale(
                    scale: 0.3 + t * 0.7,
                    child: Opacity(
                      opacity: (1 - t).clamp(0.0, 1.0),
                      child: _Star(color: color, size: tailleIcone * 0.22),
                    ),
                  ),
                ),
              );
            }
          }

          // `Curves.elasticOut` serait trop remuant à côté d'un texte qu'on veut
          // lire : un simple dépassement suffit.
          final echelle = 0.7 + Curves.easeOutBack.transform(t) * 0.3;

          return Stack(
            alignment: Alignment.center,
            children: [
              ...etincelles,
              Transform.scale(
                scale: echelle,
                child: Icon(icon, color: color, size: tailleIcone),
              ),
            ],
          );
        },
      ),
    );
  }
}


/// Carte de confirmation avant une sortie de quiz.
///
/// Sert la croix comme le bouton « Mettre fin » : même mise en page, seuls le
/// titre et le libellé de l'action changent. Remplace un `AlertDialog` Material,
/// qui détonnait avec le reste de l'écran.
///
/// Hiérarchie assumée — l'action sûre est en bas, pleine et dans l'accent de
/// l'app : la plus atteignable au pouce et la plus visible. L'action destructive
/// est au-dessus, en contour rouge : identifiable, jamais tentante.
class _ConfirmCard extends StatelessWidget {
  const _ConfirmCard({
    required this.isDark,
    required this.titre,
    required this.message,
    required this.actionLabel,
    required this.onConfirmer,
    required this.onAnnuler,
  });

  final bool isDark;
  final String titre;
  final String message;
  final String actionLabel;
  final VoidCallback onConfirmer;
  final VoidCallback onAnnuler;

  @override
  Widget build(BuildContext context) {
    final fond = isDark ? const Color(0xFF11131A) : Colors.white;
    final texte = isDark ? Colors.white : _Brand.textDark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
            decoration: BoxDecoration(
              color: fond,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark ? _opa(Colors.white, .10) : _opa(Colors.black, .06),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? .45 : .12),
                  blurRadius: 34,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pastille d'avertissement : donne un point d'entrée au regard et
                // annonce la nature de l'action avant même la lecture.
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _opa(_Brand.bad, .12),
                    border: Border.all(color: _opa(_Brand.bad, .30)),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: _Brand.bad,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  titre,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    color: texte,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    height: 1.2,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    color: _opa(texte, .70),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.45,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: onConfirmer,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _opa(_Brand.bad, .10),
                      foregroundColor: _Brand.bad,
                      side: BorderSide(color: _opa(_Brand.bad, .55), width: 1.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    child: Text(actionLabel),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: onAnnuler,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: _Brand.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    child: const Text('Continuer le quiz'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
