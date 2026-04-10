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

/// =============================================================
///  QUIZ — CADRE LÉGAL D’USAGE DES ARMES (art. L. 435-1
///  du Code de la sécurité intérieure + lien avec la légitime
///  défense art. 122-5 du Code pénal)
///
///  Remplace ton ancien tableau par celui-ci.
///  (tu peux bien sûr l’enrichir encore si besoin)
/// =============================================================
final List<QuizQuestion> questionsHierarchieJudiciaire = [
  // ===================== NIVEAU FACILE =====================
  QuizQuestion(
    category: "Généralités - Police judiciaire",
    question: "La police judiciaire est exercée sous la direction de :",
    options: [
      "Le ministre de l’Intérieur",
      "Le procureur de la République",
      "Le préfet de police",
    ],
    answer: "Le procureur de la République",
    explanation:
        "Le texte rappelle que la police judiciaire est exercée sous la direction du procureur de la République (article 12 C.P.P.).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Généralités - Police judiciaire",
    question:
        "Dans chaque ressort de Cour d’appel, la police judiciaire est placée sous la surveillance de :",
    options: [
      "La chambre de l’instruction",
      "Le procureur général",
      "Le ministère de l’Intérieur",
    ],
    answer: "Le procureur général",
    explanation:
        "La police judiciaire est placée, dans chaque ressort de Cour d’appel, sous la surveillance du procureur général (article 13 C.P.P.).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Généralités - Police judiciaire",
    question:
        "Dans chaque ressort de Cour d’appel, la police judiciaire est placée sous le contrôle de :",
    options: [
      "La chambre de l’instruction",
      "Le tribunal correctionnel",
      "Le juge des libertés et de la détention",
    ],
    answer: "La chambre de l’instruction",
    explanation:
        "Le texte précise que la police judiciaire est placée sous le contrôle de la chambre de l’instruction (article 13 C.P.P.).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Généralités - Qualifications",
    question:
        "Pour exercer la police judiciaire, les personnels de la police nationale reçoivent principalement les qualifications suivantes :",
    options: [
      "Commissaire, inspecteur, gardien de la paix",
      "Officier de police judiciaire, agent de police judiciaire, agent de police judiciaire adjoint",
      "Officier de police administrative, agent de police administrative, réserviste",
    ],
    answer:
        "Officier de police judiciaire, agent de police judiciaire, agent de police judiciaire adjoint",
    explanation:
        "La loi, en particulier le C.P.P., confère la qualification d’OPJ, d’APJ ou d’APJA aux personnels de la police nationale pour l’exercice de la police judiciaire.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Généralités - Assistants d’enquête",
    question:
        "Les OPJ et APJ peuvent être secondés, dans leur activité judiciaire, par :",
    options: [
      "Des policiers adjoints uniquement",
      "Des assistants d’enquête",
      "Des médiateurs de quartier",
    ],
    answer: "Des assistants d’enquête",
    explanation:
        "Le document indique que les OPJ et APJ peuvent être secondés par des assistants d’enquête.",
    difficulty: "Facile",
  ),

  // ===================== OPJ - QUALITÉ (ART. 16 C.P.P.) =====================
  QuizQuestion(
    category: "OPJ - Qualité (art. 16 C.P.P.)",
    question:
        "Parmi les personnes suivantes, lesquelles ont la qualité d’officier de police judiciaire au sens de l’article 16 C.P.P. ?",
    options: [
      "Les maires uniquement",
      "Les maires et leurs adjoints",
      "Les préfets et sous-préfets",
    ],
    answer: "Les maires et leurs adjoints",
    explanation:
        "L’article 16 C.P.P. mentionne notamment les maires et leurs adjoints comme ayant la qualité d’OPJ.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "OPJ - Qualité (art. 16 C.P.P.)",
    question:
        "Les officiers et gradés de la gendarmerie peuvent avoir la qualité d’OPJ :",
    options: [
      "Toujours, sans condition",
      "S’ils sont nominativement désignés par arrêté des ministres de la justice et de l’intérieur",
      "Uniquement s’ils sont en tenue",
    ],
    answer:
        "S’ils sont nominativement désignés par arrêté des ministres de la justice et de l’intérieur",
    explanation:
        "Le texte précise que les gendarmes peuvent être OPJ s’ils sont nominativement désignés après avis conforme d’une commission.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "OPJ - Qualité (art. 16 C.P.P.)",
    question:
        "Parmi ces catégories, lesquelles ont la qualité d’OPJ selon l’article 16 C.P.P. ?",
    options: [
      "Les inspecteurs généraux, les sous-directeurs de police active, les contrôleurs généraux, les commissaires de police et les officiers de police",
      "Uniquement les commissaires de police",
      "Uniquement les officiers de police",
    ],
    answer:
        "Les inspecteurs généraux, les sous-directeurs de police active, les contrôleurs généraux, les commissaires de police et les officiers de police",
    explanation:
        "Toutes ces fonctions sont citées par le texte comme ayant la qualité d’OPJ au titre de l’article 16 C.P.P.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "OPJ - Qualité (art. 16 C.P.P.)",
    question:
        "Les fonctionnaires du corps d’encadrement et d’application de la police nationale peuvent être OPJ :",
    options: [
      "Sans condition particulière",
      "S’ils sont nominativement désignés par arrêté des ministres de la justice et de l’intérieur",
      "Uniquement s’ils sont en tenue et armés",
    ],
    answer:
        "S’ils sont nominativement désignés par arrêté des ministres de la justice et de l’intérieur",
    explanation:
        "Le texte prévoit que ces fonctionnaires peuvent avoir la qualité d’OPJ s’ils sont nominativement désignés par arrêté conjoint, après avis conforme d’une commission.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "OPJ - Qualité (art. 16 C.P.P.)",
    question:
        "Les personnes exerçant des fonctions de directeur ou sous-directeur de la police judiciaire et de la gendarmerie :",
    options: [
      "N’ont jamais la qualité d’OPJ",
      "Ont la qualité d’OPJ",
      "Ont la qualité d’APJ uniquement",
    ],
    answer: "Ont la qualité d’OPJ",
    explanation:
        "Les personnes exerçant ces fonctions de direction ou sous-direction de la PJ ou de la gendarmerie ont la qualité d’OPJ.",
    difficulty: "Facile",
  ),

  // ===================== OPJ - CONDITIONS D’EXERCICE =====================
  QuizQuestion(
    category: "OPJ - Conditions d’exercice",
    question:
        "Pour exercer effectivement les pouvoirs d’OPJ, un officier de police judiciaire doit notamment :",
    options: [
      "Être simplement titulaire du grade",
      "Être affecté à un emploi comportant l’exercice de la police judiciaire",
      "Être en tenue d’uniforme en toutes circonstances",
    ],
    answer:
        "Être affecté à un emploi comportant l’exercice de la police judiciaire",
    explanation:
        "Les OPJ ne peuvent exercer les pouvoirs afférents à leur qualité que s’ils sont affectés à un emploi comportant l’exercice de la police judiciaire.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "OPJ - Conditions d’exercice",
    question: "L’habilitation personnelle d’un OPJ est délivrée par :",
    options: [
      "Le préfet de département",
      "Le procureur de la République",
      "Le procureur général",
    ],
    answer: "Le procureur général",
    explanation:
        "Le texte indique que les OPJ doivent être habilités personnellement par décision du procureur général.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "OPJ - Conditions d’exercice",
    question:
        "Les OPJ peuvent-ils exercer leurs pouvoirs lorsqu’ils participent, en unité constituée, à une opération de maintien de l’ordre ?",
    options: [
      "Oui, sans restriction",
      "Oui, mais uniquement sur ordre écrit du préfet",
      "Non, ils ne peuvent pas exercer les pouvoirs afférents à la qualité d’OPJ",
    ],
    answer:
        "Non, ils ne peuvent pas exercer les pouvoirs afférents à la qualité d’OPJ",
    explanation:
        "Le texte précise que les OPJ ne peuvent pas exercer leurs pouvoirs lorsqu’ils participent, en unité constituée, à une opération de maintien de l’ordre.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "OPJ - Habilitation",
    question: "La première habilitation d’un OPJ :",
    options: [
      "Doit être renouvelée tous les 5 ans",
      "Vaut pour toute la durée des fonctions",
      "Ne vaut que pour un seul service",
    ],
    answer: "Vaut pour toute la durée des fonctions",
    explanation:
        "Le document précise que la première habilitation d’un OPJ vaut pour toute la durée de ses fonctions.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "OPJ - Habilitation",
    question: "En cas de changement d’affectation, l’habilitation d’OPJ :",
    options: [
      "Doit être systématiquement renouvelée",
      "N’a pas besoin d’être renouvelée",
      "Est automatiquement retirée",
    ],
    answer: "N’a pas besoin d’être renouvelée",
    explanation:
        "Le texte mentionne qu’en cas de changement d’affectation, il n’est pas nécessaire de renouveler la première habilitation.",
    difficulty: "Facile",
  ),

  // ===================== OPJ - MODE DE DÉSIGNATION =====================
  QuizQuestion(
    category: "OPJ - Mode de désignation",
    question:
        "Les maires et adjoints au maire peuvent exercer les fonctions d’OPJ :",
    options: [
      "Uniquement après habilitation du procureur général",
      "De plein droit, sans habilitation préalable",
      "Uniquement s’ils sont en uniforme",
    ],
    answer: "De plein droit, sans habilitation préalable",
    explanation:
        "Les maires, adjoints au maire, directeurs et sous-directeurs de la police judiciaire et de la gendarmerie exercent de plein droit les fonctions d’OPJ.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "OPJ - Mode de désignation",
    question:
        "Pour exercer les fonctions d’OPJ, les gendarmes (sauf directeur et sous-directeur) doivent :",
    options: [
      "Avoir 10 ans d’ancienneté",
      "Recevoir une habilitation du procureur général",
      "Être simplement proposés par leur commandant de brigade",
    ],
    answer: "Recevoir une habilitation du procureur général",
    explanation:
        "Les gendarmes de tous grades, sauf directeur et sous-directeur, doivent être habilités par le procureur général pour exercer les fonctions d’OPJ.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "OPJ - Mode de désignation",
    question:
        "Les inspecteurs généraux, les commissaires de police et les fonctionnaires du corps de commandement de la police nationale :",
    options: [
      "Sont automatiquement OPJ",
      "Doivent recevoir une habilitation du procureur général pour exercer les fonctions d’OPJ",
      "N’ont jamais la qualité d’OPJ",
    ],
    answer:
        "Doivent recevoir une habilitation du procureur général pour exercer les fonctions d’OPJ",
    explanation:
        "Le texte prévoit que ces fonctionnaires doivent recevoir une habilitation du procureur général pour exercer effectivement les fonctions d’OPJ.",
    difficulty: "Facile",
  ),

  // ===================== APJ - CATÉGORIES =====================
  QuizQuestion(
    category: "APJ - Généralités",
    question:
        "Les agents de police judiciaire (APJ) ont pour mission essentielle :",
    options: [
      "D’ordonner les enquêtes",
      "De seconder les OPJ dans l’exercice de leurs fonctions",
      "De diriger la gendarmerie nationale",
    ],
    answer: "De seconder les OPJ dans l’exercice de leurs fonctions",
    explanation:
        "Le texte indique que les APJ sont investis de certaines attributions de police judiciaire et ont la mission essentielle de seconder les OPJ.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "APJ - Catégorie art. 20 C.P.P.",
    question: "Sont APJ au sens de l’article 20 C.P.P. :",
    options: [
      "Les militaires de la gendarmerie nationale volontaires",
      "Les militaires de la gendarmerie nationale autres que les volontaires n’ayant pas la qualité d’OPJ",
      "Uniquement les officiers de gendarmerie",
    ],
    answer:
        "Les militaires de la gendarmerie nationale autres que les volontaires n’ayant pas la qualité d’OPJ",
    explanation:
        "L’article 20 C.P.P. vise les militaires de la gendarmerie nationale autres que les volontaires, n’ayant pas la qualité d’OPJ.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "APJ - Catégorie art. 20 C.P.P.",
    question:
        "Les fonctionnaires des services actifs de la police nationale, titulaires ou stagiaires, n’ayant pas la qualité d’OPJ, sont :",
    options: [
      "Des OPJ",
      "Des APJ de l’article 20 C.P.P.",
      "Des APJA de l’article 21 C.P.P.",
    ],
    answer: "Des APJ de l’article 20 C.P.P.",
    explanation:
        "Le texte précise que ces fonctionnaires sont APJ au sens de l’article 20 C.P.P., sous réserve des dispositions de l’article 20-1.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "APJ - Catégorie art. 20-1 C.P.P.",
    question:
        "Selon l’article 20-1 C.P.P., peuvent bénéficier de la qualité d’APJ dans la réserve opérationnelle :",
    options: [
      "Les fonctionnaires de police et gendarmes n’ayant jamais exercé en tant qu’OPJ ou APJ",
      "Les fonctionnaires de la police nationale et les militaires de la gendarmerie actifs ou retraités ayant exercé comme OPJ ou APJ pendant au moins 5 ans",
      "Uniquement les réservistes civils",
    ],
    answer:
        "Les fonctionnaires de la police nationale et les militaires de la gendarmerie actifs ou retraités ayant exercé comme OPJ ou APJ pendant au moins 5 ans",
    explanation:
        "L’article 20-1 C.P.P. prévoit cette possibilité pour ceux qui ont exercé en tant qu’OPJ ou APJ durant au moins 5 ans.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "APJ - Catégorie art. 20-1 C.P.P.",
    question:
        "Pour un ancien OPJ qui a rompu le lien avec le service depuis plus d’un an et qui veut être APJ en réserve opérationnelle :",
    options: [
      "Aucune condition particulière n’est exigée",
      "Une remise à niveau professionnelle adaptée et périodique est exigée",
      "Il doit repasser l’examen initial d’OPJ",
    ],
    answer:
        "Une remise à niveau professionnelle adaptée et périodique est exigée",
    explanation:
        "Le texte prévoit que les fonctionnaires ayant rompu le lien avec le service depuis plus d’un an sont soumis à une remise à niveau professionnelle adaptée et périodique.",
    difficulty: "Facile",
  ),

  // ===================== APJA - CATÉGORIE ART. 21 C.P.P. =====================
  QuizQuestion(
    category: "APJA - Catégorie art. 21 C.P.P.",
    question: "Les agents de police judiciaire adjoints (APJA) ont :",
    options: [
      "Des pouvoirs de police judiciaire identiques à ceux des APJ",
      "Des pouvoirs en matière de police judiciaire moins étendus",
      "Uniquement des fonctions administratives",
    ],
    answer: "Des pouvoirs en matière de police judiciaire moins étendus",
    explanation:
        "Le texte précise que les APJA disposent de pouvoirs en matière de police judiciaire moins étendus que les APJ.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "APJA - Catégorie art. 21 C.P.P.",
    question:
        "Les policiers adjoints qui ne remplissent pas les conditions de l’article 20 ou 20-1 C.P.P. sont :",
    options: [
      "Des OPJ",
      "Des APJ de l’article 20",
      "Des APJA de l’article 21 C.P.P.",
    ],
    answer: "Des APJA de l’article 21 C.P.P.",
    explanation:
        "Le texte mentionne explicitement que les policiers adjoints sont APJA lorsqu’ils ne remplissent pas les conditions prévues par les articles 16-1 A ou 20-1 C.P.P.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "APJA - Catégorie art. 21 C.P.P.",
    question: "Les agents de police municipale sont :",
    options: [
      "Des APJ de l’article 20 C.P.P.",
      "Des APJA de l’article 21 C.P.P.",
      "Des OPJ",
    ],
    answer: "Des APJA de l’article 21 C.P.P.",
    explanation:
        "Les agents de police municipale sont visés à l’article 21 C.P.P. comme agents de police judiciaire adjoints.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "APJA - Catégorie art. 21 C.P.P.",
    question: "Les gardes champêtres sont APJA lorsqu’ils agissent :",
    options: [
      "En toute circonstance",
      "Uniquement en police administrative",
      "Pour l’exercice des attributions fixées à l’avant-dernier alinéa de l’article L. 521-1 C.S.I.",
    ],
    answer:
        "Pour l’exercice des attributions fixées à l’avant-dernier alinéa de l’article L. 521-1 C.S.I.",
    explanation:
        "Le texte limite la qualité d’APJA des gardes champêtres à l’exercice de ces attributions particulières.",
    difficulty: "Facile",
  ),

  // ===================== APJ 20 - CONDITIONS D’EXERCICE =====================
  QuizQuestion(
    category: "APJ - Conditions d’exercice (art. 20)",
    question:
        "Les APJ de l’article 20 C.P.P. ne peuvent exercer leurs attributions que s’ils :",
    options: [
      "Sont affectés à un emploi comportant l’exercice de la police judiciaire",
      "Sont en tenue d’uniforme",
      "Sont en service de nuit",
    ],
    answer:
        "Sont affectés à un emploi comportant l’exercice de la police judiciaire",
    explanation:
        "Le texte reprend la même logique que pour les OPJ : les APJ 20 doivent être affectés à un emploi comportant l’exercice de la police judiciaire.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "APJ - Conditions d’exercice (art. 20)",
    question:
        "Les APJ de l’article 20 C.P.P. peuvent-ils exercer leurs attributions lorsqu’ils participent, en unité constituée, à une opération de maintien de l’ordre ?",
    options: [
      "Oui, systématiquement",
      "Oui, mais uniquement en flagrant délit",
      "Non, ils ne peuvent pas exercer les attributions attachées à cette qualité",
    ],
    answer:
        "Non, ils ne peuvent pas exercer les attributions attachées à cette qualité",
    explanation:
        "Comme pour les OPJ, les APJ 20 ne peuvent pas exercer leurs attributions lorsqu’ils participent, en unité constituée, à une opération de maintien de l’ordre.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "APJ - Conditions d’exercice (art. 20)",
    question: "Sont exclus de l’exercice effectif des attributions d’APJ 20 :",
    options: [
      "Les fonctionnaires des services actifs affectés à titre principal à des tâches administratives ou de maintien de l’ordre",
      "Tous les gardiens de la paix",
      "Uniquement les agents en formation",
    ],
    answer:
        "Les fonctionnaires des services actifs affectés à titre principal à des tâches administratives ou de maintien de l’ordre",
    explanation:
        "Le texte précise que ces fonctionnaires sont exclus de l’exercice des attributions attachées à la qualité d’APJ 20.",
    difficulty: "Facile",
  ),

  // ===================== ASSISTANTS D’ENQUÊTE =====================
  QuizQuestion(
    category: "Assistants d’enquête",
    question:
        "Les assistants d’enquête, mentionnés à l’article 21-3 C.P.P., sont chargés de :",
    options: [
      "Diriger les enquêtes complexes",
      "Seconder les OPJ et APJ dans certaines formalités procédurales",
      "Rédiger les réquisitions du procureur",
    ],
    answer: "Seconder les OPJ et APJ dans certaines formalités procédurales",
    explanation:
        "Le texte indique que les assistants d’enquête sont chargés de seconder les OPJ et APJ dans l’accomplissement de certaines formalités procédurales.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Assistants d’enquête",
    question:
        "Parmi les personnels suivants, lesquels peuvent être recrutés comme assistants d’enquête ?",
    options: [
      "Les militaires du corps de soutien technique et administratif de la gendarmerie nationale",
      "Uniquement les commissaires de police",
      "Uniquement les policiers adjoints",
    ],
    answer:
        "Les militaires du corps de soutien technique et administratif de la gendarmerie nationale",
    explanation:
        "Le texte mentionne que ces militaires font partie des catégories pouvant être recrutées comme assistants d’enquête.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Assistants d’enquête",
    question:
        "Les personnels administratifs de catégorie B de la police nationale et de la gendarmerie nationale peuvent :",
    options: [
      "Être recrutés comme assistants d’enquête",
      "Être automatiquement OPJ",
      "Être automatiquement APJ",
    ],
    answer: "Être recrutés comme assistants d’enquête",
    explanation:
        "Le texte précise que les personnels administratifs de catégorie B de la police et de la gendarmerie peuvent être assistants d’enquête.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Assistants d’enquête",
    question:
        "Les agents de police judiciaire adjoints (APJA) de la police nationale et de la gendarmerie nationale peuvent :",
    options: [
      "Être recrutés comme assistants d’enquête",
      "Devenir automatiquement OPJ",
      "Ne jamais exercer de fonctions judiciaires",
    ],
    answer: "Être recrutés comme assistants d’enquête",
    explanation:
        "Les APJA de la police nationale et de la gendarmerie nationale font partie des personnels pouvant devenir assistants d’enquête.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Assistants d’enquête",
    question: "Pour exercer leurs missions, les assistants d’enquête doivent :",
    options: [
      "Avoir seulement une ancienneté de 10 ans",
      "Avoir satisfait à une formation sanctionnée par un examen certifiant leur aptitude",
      "Être titulaires de la qualité d’OPJ",
    ],
    answer:
        "Avoir satisfait à une formation sanctionnée par un examen certifiant leur aptitude",
    explanation:
        "Le texte impose une formation spécifique, sanctionnée par un examen, afin de certifier leur aptitude à assurer leurs missions.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU INTERMÉDIAIRE =====================
  QuizQuestion(
    category: "Synthèse - Hiérarchie judiciaire",
    question:
        "La hiérarchie fonctionnelle des personnels de la police nationale en matière de police judiciaire repose principalement sur :",
    options: [
      "OPJ / APJ / APJA / assistants d’enquête",
      "Commissaires / brigadiers / gardiens de la paix",
      "Police administrative / police municipale",
    ],
    answer: "OPJ / APJ / APJA / assistants d’enquête",
    explanation:
        "Le document distingue clairement les fonctions judiciaires selon ces quatre niveaux : OPJ, APJ, APJA et assistants d’enquête.",
    difficulty: "Intermédiaire",
  ),
  QuizQuestion(
    category: "Synthèse - Distinction OPJ/APJ",
    question: "Quelle affirmation distingue correctement OPJ et APJ ?",
    options: [
      "Les OPJ dirigent les enquêtes et les APJ les secondent",
      "Les APJ dirigent les enquêtes et les OPJ les secondent",
      "OPJ et APJ ont exactement les mêmes attributions",
    ],
    answer: "Les OPJ dirigent les enquêtes et les APJ les secondent",
    explanation:
        "Les OPJ disposent des pouvoirs les plus étendus (direction des enquêtes), tandis que les APJ ont pour mission essentielle de les seconder.",
    difficulty: "Intermédiaire",
  ),
  QuizQuestion(
    category: "Synthèse - Réserve opérationnelle",
    question:
        "Concernant la réserve opérationnelle, quelle proposition est exacte ?",
    options: [
      "Les réservistes ne peuvent jamais avoir la qualité d’OPJ ou d’APJ",
      "Certains réservistes peuvent conserver ou obtenir la qualité d’OPJ ou d’APJ sous conditions de durée d’exercice et de formation",
      "Tous les réservistes sont automatiquement OPJ",
    ],
    answer:
        "Certains réservistes peuvent conserver ou obtenir la qualité d’OPJ ou d’APJ sous conditions de durée d’exercice et de formation",
    explanation:
        "Le texte évoque les articles 16-1 A, 20-1 et les dispositions réglementaires permettant à certains réservistes de conserver ou d’acquérir ces qualités sous condition de durée et de remise à niveau.",
    difficulty: "Intermédiaire",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizHierarchiePage extends StatefulWidget {
  static const String routeName = '/gpx/generalites/quiz/hierarchie';
  final String uid;
  final String email;

  const QuizHierarchiePage({super.key, required this.uid, required this.email});

  @override
  State<QuizHierarchiePage> createState() => _QuizHierarchiePageState();
}

class _QuizHierarchiePageState extends State<QuizHierarchiePage>
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
        ? questionsHierarchieJudiciaire
        : questionsHierarchieJudiciaire
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
            'module_name': 'Généralités',
            'quiz_name': 'La hiérarchie des personnels',
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
      final int total = _qs.length.clamp(1, 1 << 30);
      final int percent = ((_score / total) * 100).round();

      await _sb
          .from('quiz_history')
          .update({
            'score': percent,
            'correct_count': _score,
            'finished_at': DateTime.now().toUtc().toIso8601String(),
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _historyRowId!)
          .eq('uid', widget.uid);
    } catch (e) {
      debugPrint('❌ quiz_history (finish) update failed: $e');
    }
  }

  Future<void> _saveAnswer({
    required String question,
    required String userAnswer,
    required String correctAnswer,
    required bool isCorrect,
    required String difficulty,
  }) async {
    try {
      await _sb.from('quiz_hierarchie').insert({
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
      debugPrint('❌ quiz_hierarchie insert failed: $e');
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
      await _updateHistoryOnFinish();
      if (!mounted) return;
      _openResultDialog(_score, _qs.length);
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
      builder: (_, c) {
        final s = c.maxWidth * 0.56;
        final size = s.clamp(140.0, 240.0);
        return SizedBox(
          height: size,
          child: Center(
            // >>> Choisis UNE des 3 lignes ci-dessous <<<
            // child: _FeedbackConfettiBurst(controller: controller, good: good, size: size),
            // child: _FeedbackStrokeDraw(controller: controller, good: good, size: size),
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
        // t normalisé 0..1 (au cas où)
        final t =
            ((controller.value - controller.lowerBound) /
                    (controller.upperBound - controller.lowerBound))
                .clamp(0.0, 1.0);
        final icon = good ? Icons.check_rounded : Icons.close_rounded;
        final iconSize = size * .30;

        const n = 8;
        final maxR = size * .58;
        final kids = <Widget>[];

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

        return Stack(
          alignment: Alignment.center,
          children: [
            ...kids,
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
