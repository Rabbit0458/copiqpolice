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

final List<QuizQuestion> questionAtteinteActionJustice = [
  // =========================================================
  // AJOUTS — NON-DÉNONCIATION DE CRIME (434-1 / 434-2)
  // =========================================================
  const QuizQuestion(
    category: "Non-dénonciation de crime — Condition d’utilité",
    question:
        "La dénonciation doit être considérée comme « utile » lorsqu’elle peut :",
    options: [
      "Prévenir ou limiter les effets du crime, ou empêcher la commission de nouveaux crimes",
      "Uniquement permettre une condamnation civile",
      "Uniquement satisfaire la curiosité des enquêteurs",
    ],
    answer:
        "Prévenir ou limiter les effets du crime, ou empêcher la commission de nouveaux crimes",
    explanation:
        "Le cours précise que l’obligation concerne les crimes dont la dénonciation peut prévenir/limiter/empêcher.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Nature des infractions",
    question: "L’obligation de dénonciation vise :",
    options: [
      "Les crimes, peu importe leur nature",
      "Uniquement les crimes contre les biens",
      "Uniquement les crimes contre les personnes",
    ],
    answer: "Les crimes, peu importe leur nature",
    explanation:
        "Le cours : « infractions de nature criminelle, peu importe la nature du crime ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Tentative",
    question: "L’incrimination est également applicable :",
    options: [
      "À la tentative de crime",
      "Au simple projet criminel",
      "Uniquement aux crimes consommés",
    ],
    answer: "À la tentative de crime",
    explanation:
        "Le cours indique que la non-dénonciation concerne aussi la tentative de crime.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Simple projet",
    question:
        "Le simple projet criminel, en l’absence de tout commencement d’exécution :",
    options: [
      "N’est pas concerné",
      "Est toujours concerné",
      "Est concerné uniquement si le crime est passible de la perpétuité",
    ],
    answer: "N’est pas concerné",
    explanation:
        "Le cours exclut explicitement le simple projet criminel sans commencement d’exécution.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Infraction d’omission",
    question: "La non-dénonciation de crime est une infraction :",
    options: [
      "D’omission (abstention)",
      "De commission (acte positif)",
      "D’imprudence",
    ],
    answer: "D’omission (abstention)",
    explanation:
        "Le cours précise : l’individu avait la possibilité d’avertir et il ne l’a pas fait.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Autorités",
    question:
        "Sont visées comme autorités judiciaires ou administratives susceptibles de recevoir l’information :",
    options: [
      "Toute autorité capable d’en mesurer l’importance et d’y donner suite",
      "Uniquement le juge d’instruction",
      "Uniquement le maire",
    ],
    answer:
        "Toute autorité capable d’en mesurer l’importance et d’y donner suite",
    explanation:
        "Le cours vise le ministère public, police, gendarmerie et toute autorité utile.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Exemples d’autorités",
    question: "Le cours cite notamment comme destinataires possibles :",
    options: [
      "Le ministère public, les fonctionnaires de police, la gendarmerie nationale",
      "Uniquement un avocat",
      "Uniquement un journaliste",
    ],
    answer:
        "Le ministère public, les fonctionnaires de police, la gendarmerie nationale",
    explanation: "Exemples expressément mentionnés dans le cours.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Dénonciation indirecte",
    question: "La jurisprudence admet que la dénonciation puisse être faite :",
    options: [
      "Auprès d’une personne qui intervient pour le compte des autorités",
      "Uniquement par lettre recommandée",
      "Uniquement en dépôt de plainte formel",
    ],
    answer: "Auprès d’une personne qui intervient pour le compte des autorités",
    explanation:
        "Le cours précise que la dénonciation peut être faite auprès d’un intermédiaire agissant pour leur compte.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Objet de la révélation",
    question: "L’obligation implique la révélation :",
    options: [
      "De l’existence du crime (les faits eux-mêmes)",
      "Uniquement de l’identité de l’auteur",
      "Uniquement du lieu de résidence du complice",
    ],
    answer: "De l’existence du crime (les faits eux-mêmes)",
    explanation:
        "Le cours : l’information doit porter sur les faits, pas nécessairement sur l’identité de l’auteur/complice.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Identité de l’auteur",
    question: "Selon la jurisprudence citée, l’obligation porte :",
    options: [
      "Sur le crime et non sur l’identité ou le refuge des auteurs",
      "Sur l’identité uniquement",
      "Sur l’identité et le refuge obligatoirement",
    ],
    answer: "Sur le crime et non sur l’identité ou le refuge des auteurs",
    explanation:
        "Cass. crim., 26 février 1959 : obligation de dénoncer le crime, pas l’identité/refuge.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Modalités",
    question: "Les modalités de dénonciation sont :",
    options: [
      "Libres (toutes admissibles)",
      "Uniquement écrites",
      "Uniquement orales",
    ],
    answer: "Libres (toutes admissibles)",
    explanation:
        "Le cours : « toutes les modalités de dénonciation sont admissibles ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Finalité",
    question: "L’information vise principalement à :",
    options: [
      "Prévenir un trouble à l’ordre public",
      "Provoquer une sanction disciplinaire",
      "Éviter toute enquête",
    ],
    answer: "Prévenir un trouble à l’ordre public",
    explanation:
        "Le cours : l’information est destinée à prévenir un trouble à l’ordre public.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Prévenir/limiter",
    question: "La dénonciation peut prévenir ou limiter les effets notamment :",
    options: [
      "Dans le cadre d’une tentative où elle peut éviter le crime",
      "Uniquement après condamnation",
      "Uniquement en matière de contravention",
    ],
    answer: "Dans le cadre d’une tentative où elle peut éviter le crime",
    explanation:
        "Le cours donne l’exemple : tentative où la dénonciation est susceptible d’éviter le crime.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Nouveaux crimes",
    question: "La dénonciation peut aussi permettre :",
    options: [
      "D’éviter de nouveaux crimes, notamment par l’identification des auteurs",
      "D’annuler l’enquête",
      "De supprimer la responsabilité pénale",
    ],
    answer:
        "D’éviter de nouveaux crimes, notamment par l’identification des auteurs",
    explanation:
        "Le cours : éviter de nouveaux crimes, notamment par identification des auteurs.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Élément moral",
    question: "L’élément moral est caractérisé si la personne :",
    options: [
      "Consciente qu’un crime se commet ou va se produire, s’abstient volontairement de le dénoncer",
      "A uniquement des doutes vagues",
      "Oublie de dénoncer par inattention",
    ],
    answer:
        "Consciente qu’un crime se commet ou va se produire, s’abstient volontairement de le dénoncer",
    explanation:
        "Le cours : connaissance + absence de dénonciation → intention ; Cass. crim., 7 novembre 1990.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Mobile",
    question: "Le mobile expliquant l’abstention :",
    options: [
      "Est indifférent",
      "Supprime l’intention",
      "Aggrave systématiquement la peine",
    ],
    answer: "Est indifférent",
    explanation: "Le cours : le mobile importe peu.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Aggravation (434-2)",
    question:
        "La non-dénonciation est aggravée lorsque le crime non dénoncé constitue :",
    options: [
      "Une atteinte aux intérêts fondamentaux de la Nation ou un acte de terrorisme",
      "Un vol simple",
      "Une contravention",
    ],
    answer:
        "Une atteinte aux intérêts fondamentaux de la Nation ou un acte de terrorisme",
    explanation: "Article 434-2 : trahison, espionnage, attentat, etc.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Immunité familiale et 434-2",
    question: "En cas de 434-2, l’immunité familiale :",
    options: [
      "Ne s’applique pas",
      "S’applique toujours",
      "S’applique uniquement aux frères et sœurs",
    ],
    answer: "Ne s’applique pas",
    explanation:
        "Le cours précise : l’immunité familiale de 434-1 n’est pas applicable en 434-2.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Peines (simple)",
    question: "Peines encourues (434-1 al.1) :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Peines de la forme simple indiquées dans le cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Peines (aggravée)",
    question: "Peines encourues (434-2) :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Peines aggravées indiquées par le cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Tentative",
    question: "La tentative de non-dénonciation est :",
    options: [
      "Non incriminée",
      "Incriminée",
      "Incriminée seulement en cas de récidive",
    ],
    answer: "Non incriminée",
    explanation: "Le cours précise : tentative non incriminée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Complicité",
    question: "La complicité est possible notamment si une personne :",
    options: [
      "Incite le témoin à ne pas dénoncer un crime",
      "Informe les autorités",
      "Dépose plainte",
    ],
    answer: "Incite le témoin à ne pas dénoncer un crime",
    explanation:
        "Le cours cite explicitement ce cas de complicité (provocation).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Secret professionnel",
    question:
        "Les personnes astreintes au secret professionnel (226-13) sont :",
    options: [
      "Exemptées de l’obligation de dénonciation",
      "Toujours tenues de dénoncer",
      "Tenues de dénoncer uniquement les délits",
    ],
    answer: "Exemptées de l’obligation de dénonciation",
    explanation: "Le cours prévoit l’exception liée au secret professionnel.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Participant au crime",
    question: "Celui qui a participé au crime :",
    options: [
      "Est excepté de l’obligation de dénonciation",
      "Doit dénoncer sinon aggravation",
      "Est soumis à 434-1 automatiquement",
    ],
    answer: "Est excepté de l’obligation de dénonciation",
    explanation:
        "Le cours : celui qui a participé au crime est excepté de l’obligation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Immunité familiale (principe)",
    question: "L’immunité familiale bénéficie notamment :",
    options: [
      "Aux parents en ligne directe et leurs conjoints, frères/sœurs et leurs conjoints, conjoint/concubin/PACS",
      "Uniquement aux amis proches",
      "Uniquement aux collègues",
    ],
    answer:
        "Aux parents en ligne directe et leurs conjoints, frères/sœurs et leurs conjoints, conjoint/concubin/PACS",
    explanation:
        "Liste donnée par le cours, incluant concubin et partenaire de PACS.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Crimes sur mineurs",
    question: "Concernant les crimes commis sur les mineurs :",
    options: [
      "L’immunité familiale est écartée",
      "L’immunité familiale s’applique toujours",
      "Le secret professionnel est écarté",
    ],
    answer: "L’immunité familiale est écartée",
    explanation:
        "Le cours : immunité familiale OUI sauf crimes commis sur mineurs.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // AJOUTS — FAUX TÉMOIGNAGE / TÉMOIGNAGE MENSONGER (434-13 / 434-14)
  // =========================================================
  const QuizQuestion(
    category: "Faux témoignage — Définition",
    question: "Le faux témoignage est constitué par :",
    options: [
      "Un témoignage mensonger fait sous serment devant une juridiction ou devant un OPJ sur commission rogatoire",
      "Un mensonge en audition libre",
      "Un mensonge dans une conversation privée",
    ],
    answer:
        "Un témoignage mensonger fait sous serment devant une juridiction ou devant un OPJ sur commission rogatoire",
    explanation:
        "Le cours : mensonge sous serment, devant juridiction ou OPJ en commission rogatoire.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Texte",
    question: "Le faux témoignage est réprimé par :",
    options: [
      "Article 434-13 du Code pénal",
      "Article 434-1 du Code pénal",
      "Article 434-2 du Code pénal",
    ],
    answer: "Article 434-13 du Code pénal",
    explanation: "Le cours : 434-13 définit et réprime le délit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Juridictions concernées",
    question: "Le faux témoignage peut être commis devant :",
    options: [
      "Des juridictions pénales, civiles, administratives ou financières",
      "Uniquement la cour d’assises",
      "Uniquement le tribunal correctionnel",
    ],
    answer: "Des juridictions pénales, civiles, administratives ou financières",
    explanation:
        "Le terme juridiction est général : pénales, civiles, administratives, financières.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — OPJ et commission rogatoire",
    question: "Le faux témoignage peut aussi être retenu devant un OPJ si :",
    options: [
      "L’OPJ agit en exécution d’une commission rogatoire",
      "L’OPJ agit en enquête préliminaire",
      "L’OPJ agit en flagrance sans mandat",
    ],
    answer: "L’OPJ agit en exécution d’une commission rogatoire",
    explanation:
        "Le cours : punissable devant OPJ uniquement en exécution d’une commission rogatoire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Préliminaire / flagrance",
    question:
        "Les déclarations mensongères faites au cours d’une enquête préliminaire ou de flagrance sont :",
    options: [
      "Non punissables au titre du faux témoignage",
      "Toujours punissables au titre du faux témoignage",
      "Punissables seulement si elles sont écrites",
    ],
    answer: "Non punissables au titre du faux témoignage",
    explanation: "Le cours l’indique expressément.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Serment",
    question: "Le faux témoignage suppose obligatoirement :",
    options: [
      "Une déclaration sous serment",
      "Un écrit signé",
      "Une déclaration enregistrée audio",
    ],
    answer: "Une déclaration sous serment",
    explanation:
        "Le mensonge seul ne suffit pas : il faut la violation du serment.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Formule",
    question: "La formule du serment consiste à jurer :",
    options: [
      "De dire la vérité, toute la vérité",
      "De dire ce qui arrange la justice",
      "De dire seulement ce qu’on a vu",
    ],
    answer: "De dire la vérité, toute la vérité",
    explanation: "Formule rappelée dans le cours.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Mineurs <16 ans",
    question: "L’infraction ne peut être retenue contre :",
    options: [
      "Un mineur de moins de 16 ans (serment non exigé)",
      "Un mineur de 17 ans",
      "Un majeur de 18 ans",
    ],
    answer: "Un mineur de moins de 16 ans (serment non exigé)",
    explanation:
        "Le cours précise : pas de serment avant 16 ans → pas de faux témoignage.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Garde à vue",
    question:
        "La personne entendue par l’OPJ sur commission rogatoire sous le régime de la garde à vue :",
    options: [
      "Ne commet pas de faux témoignage (pas de serment, droit de ne pas s’auto-incriminer)",
      "Prête serment comme un témoin",
      "Commets un faux témoignage automatiquement",
    ],
    answer:
        "Ne commet pas de faux témoignage (pas de serment, droit de ne pas s’auto-incriminer)",
    explanation: "Le cours : pas de serment en GAV → pas de faux témoignage.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Nature du mensonge",
    question: "Le Code pénal :",
    options: [
      "N’énumère pas les moyens trompeurs : toute altération sciemment faite de la vérité est visée",
      "Liste exhaustivement les mensonges interdits",
      "Ne vise que les mensonges écrits",
    ],
    answer:
        "N’énumère pas les moyens trompeurs : toute altération sciemment faite de la vérité est visée",
    explanation:
        "Le cours précise : toute altération sciemment faite de la vérité est incriminée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Commission",
    question: "Le faux témoignage est une infraction de :",
    options: ["Commission (acte positif)", "Omission", "Négligence"],
    answer: "Commission (acte positif)",
    explanation:
        "Le cours : acte positif requis, refus de déposer ≠ faux témoignage.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Refus de déposer",
    question: "Le refus de comparaître ou de déposer :",
    options: [
      "Ne peut être assimilé à un faux témoignage",
      "Est toujours un faux témoignage",
      "Constitue une tentative de faux témoignage",
    ],
    answer: "Ne peut être assimilé à un faux témoignage",
    explanation: "Le cours l’indique explicitement.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Affirmation inexacte",
    question: "Le faux témoignage peut consister en :",
    options: [
      "L’affirmation d’un fait inexact",
      "Une simple hésitation",
      "Une opinion personnelle",
    ],
    answer: "L’affirmation d’un fait inexact",
    explanation: "Exemple classique rappelé dans le cours.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Négation d’un fait vrai",
    question: "Constitue un faux témoignage le fait :",
    options: [
      "De nier un fait véritable (déclarer ne pas savoir alors qu’on sait)",
      "De se tromper de bonne foi",
      "D’être confus",
    ],
    answer:
        "De nier un fait véritable (déclarer ne pas savoir alors qu’on sait)",
    explanation:
        "Le cours : la négation d’un fait vrai (dire ne pas savoir) est visée si c’est sciemment.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Omission",
    question: "Le mensonge peut résulter d’une omission lorsque :",
    options: [
      "Le témoin donne volontairement une réponse partielle qui dénature les faits",
      "Le témoin n’est pas interrogé",
      "Le témoin est stressé",
    ],
    answer:
        "Le témoin donne volontairement une réponse partielle qui dénature les faits",
    explanation:
        "Le cours admet le mensonge par omission si la présentation incomplète dénature la vérité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Caractère déterminant",
    question: "Le faux témoignage est punissable seulement si :",
    options: [
      "La déclaration peut avoir une incidence sur la solution du procès",
      "La déclaration concerne n’importe quel détail",
      "Le témoin parle longtemps",
    ],
    answer: "La déclaration peut avoir une incidence sur la solution du procès",
    explanation:
        "Le cours : le témoignage doit être déterminant (circonstances essentielles).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Circonstances essentielles",
    question: "Une circonstance est dite « essentielle » lorsqu’elle est :",
    options: [
      "Susceptible d’entraîner la conviction du juge",
      "Uniquement mentionnée dans le PV",
      "Uniquement favorable à la partie civile",
    ],
    answer: "Susceptible d’entraîner la conviction du juge",
    explanation:
        "Le cours : essentielle = susceptible d’entraîner la conviction du juge.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Élément moral",
    question: "Le faux témoignage suppose :",
    options: [
      "La conscience de mentir et de trahir le serment prêté",
      "Une erreur involontaire",
      "Une inattention",
    ],
    answer: "La conscience de mentir et de trahir le serment prêté",
    explanation:
        "Le cours : infraction intentionnelle, volonté délibérée de tromper.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Mauvaise foi",
    question: "Le mensonge sanctionné est :",
    options: [
      "Intentionnel et fait de mauvaise foi",
      "Toujours involontaire",
      "Toujours lié à l’émotion",
    ],
    answer: "Intentionnel et fait de mauvaise foi",
    explanation:
        "Le cours : volonté délibérée de tromper, mensonge intentionnel.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Erreur de bonne foi",
    question: "Le témoin qui se trompe ou commet une erreur de bonne foi :",
    options: [
      "N’est pas punissable",
      "Est punissable comme faux témoin",
      "Est punissable uniquement si la partie civile le demande",
    ],
    answer: "N’est pas punissable",
    explanation:
        "Le cours : la loi ne punit pas l’erreur, mais le mensonge volontaire.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Circonstances aggravantes",
    question:
        "Le faux témoignage est aggravé notamment lorsqu’il est provoqué par :",
    options: [
      "La remise d’un don ou d’une récompense quelconque",
      "Une simple peur",
      "Une confusion",
    ],
    answer: "La remise d’un don ou d’une récompense quelconque",
    explanation: "Article 434-14 1° : don/récompense.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Récompense (sens large)",
    question: "La « récompense quelconque » vise :",
    options: [
      "Toute contrepartie ayant un impact sur le témoignage",
      "Uniquement de l’argent liquide",
      "Uniquement un cadeau matériel",
    ],
    answer: "Toute contrepartie ayant un impact sur le témoignage",
    explanation:
        "Le cours : toute contrepartie déterminante (même non monétaire).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Aggravation (peine criminelle)",
    question:
        "Le faux témoignage est aggravé lorsque celui contre lequel ou en faveur duquel il est commis :",
    options: [
      "Est passible d’une peine criminelle",
      "Est passible d’une amende seulement",
      "Est mineur",
    ],
    answer: "Est passible d’une peine criminelle",
    explanation: "Article 434-14 2° : passible d’une peine criminelle.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Peines (simple)",
    question: "Peines encourues (faux témoignage simple) :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Peines indiquées par le cours pour 434-13 al.1.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Peines (aggravé)",
    question: "Peines encourues (faux témoignage aggravé) :",
    options: [
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende",
    explanation: "Peines indiquées par le cours pour 434-14.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Tentative",
    question: "La tentative de faux témoignage est :",
    options: [
      "Non incriminée",
      "Incriminée",
      "Incriminée uniquement si don/récompense",
    ],
    answer: "Non incriminée",
    explanation: "Le cours précise : tentative non incriminée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Complicité",
    question: "La complicité de faux témoignage est :",
    options: [
      "Punissable (121-6 et 121-7) et peut se confondre avec la subornation (434-15)",
      "Impossible",
      "Punissable uniquement si l’auteur principal est condamné à une peine criminelle",
    ],
    answer:
        "Punissable (121-6 et 121-7) et peut se confondre avec la subornation (434-15)",
    explanation:
        "Le cours : complicité possible + lien possible avec subornation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Rétractation (exemption)",
    question: "Le faux témoin est exempt de peine s’il rétracte :",
    options: [
      "Spontanément avant la décision mettant fin à la procédure",
      "Après le jugement définitif",
      "Uniquement après mise en examen",
    ],
    answer: "Spontanément avant la décision mettant fin à la procédure",
    explanation:
        "434-13 al.2 : exemption si rétractation spontanée avant la décision de fin de procédure.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Effet de la rétractation",
    question: "La rétractation entraîne :",
    options: [
      "Exemption de peine (l’infraction reste constituée)",
      "Disparition de l’infraction",
      "Aggravation de la peine",
    ],
    answer: "Exemption de peine (l’infraction reste constituée)",
    explanation: "Le cours : reconnu coupable mais exempté de peine.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Spontanéité (non)",
    question: "N’est pas une rétractation spontanée :",
    options: [
      "La rétractation à la demande du juge d’instruction",
      "La rétractation immédiate sans pression",
      "La rétractation de sa propre initiative avant la fin de procédure",
    ],
    answer: "La rétractation à la demande du juge d’instruction",
    explanation: "Le cours cite cette hypothèse comme non spontanée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Spontanéité après mise en examen",
    question: "N’est pas spontanée :",
    options: [
      "La rétractation après la mise en examen du faux témoin",
      "La rétractation avant toute poursuite",
      "La rétractation immédiate au cours de l’audience",
    ],
    answer: "La rétractation après la mise en examen du faux témoin",
    explanation: "Le cours cite ce cas comme non spontané.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Limite temporelle",
    question:
        "Selon la jurisprudence rappelée, la limite au-delà de laquelle la rétractation est tardive est :",
    options: [
      "La clôture des débats",
      "Le dépôt du PV",
      "L’ouverture de l’audience",
    ],
    answer: "La clôture des débats",
    explanation:
        "Le cours : la clôture des débats marque la limite jurisprudentielle.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // MINI-CAS (QUALIFICATION) — TRÈS UTILE EXAM
  // =========================================================
  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (tentative)",
    question:
        "Une personne apprend qu’un crime est sur le point d’être commis (commencement d’exécution) et qu’une alerte pourrait l’empêcher. Elle se tait. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Faux témoignage (434-13)",
      "Aucune infraction",
    ],
    answer: "Non-dénonciation de crime (434-1)",
    explanation:
        "Le cours : vise aussi la tentative si la dénonciation peut éviter le crime.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (tentative en cours)",
    question:
        "Une personne surprend un individu armé prêt à tirer sur quelqu’un, début de commencement d’exécution d’un meurtre, et sait qu’un appel immédiat à la police pourrait empêcher le crime. Elle ne fait rien. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Complicité de meurtre",
      "Aucune infraction",
    ],
    answer: "Non-dénonciation de crime (434-1)",
    explanation:
        "L’obligation de dénoncer concerne aussi les tentatives de crime lorsque la dénonciation peut encore empêcher la réalisation de l’infraction.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (projet vague)",
    question:
        "Une personne entend dans un bar : ‘Un jour, je braquerai une banque’, sans aucune précision ni préparation concrète. Elle ne signale rien aux autorités. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Tentative de non-dénonciation",
      "Aucune infraction de non-dénonciation",
    ],
    answer: "Aucune infraction de non-dénonciation",
    explanation:
        "L’article 434-1 exige un crime ou une tentative suffisamment caractérisée ; un simple projet flou sans commencement d’exécution n’entre pas dans le champ du texte.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (crime consommé, plus rien à sauver)",
    question:
        "Le soir au journal télévisé, une personne apprend qu’un meurtre a été commis la veille. Elle connaissait ce meurtre au moment des faits mais n’aurait, en pratique, jamais pu avertir à temps pour sauver la victime ou éviter une récidive. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune infraction de non-dénonciation",
      "Complicité de meurtre",
    ],
    answer: "Aucune infraction de non-dénonciation",
    explanation:
        "La dénonciation doit être utile : elle doit permettre de prévenir ou limiter les effets du crime ou d’éviter de nouveaux crimes ; à défaut, l’élément matériel fait défaut.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (nouveaux crimes à éviter)",
    question:
        "Une personne sait qu’un individu a commis un assassinat et se prépare à tuer à nouveau. Prévenir la police permettrait de l’arrêter avant le second crime. Elle se tait. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune infraction car le premier crime est consommé",
      "Complicité d’assassinat",
    ],
    answer: "Non-dénonciation de crime (434-1)",
    explanation:
        "Même si le premier crime est consommé, l’obligation subsiste lorsque la dénonciation peut empêcher de nouveaux crimes par le même auteur.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (secret professionnel de l’avocat)",
    question:
        "Un avocat apprend, au cours d’un entretien avec son client, que celui-ci a commis un crime et compte récidiver. L’avocat ne signale rien. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune non-dénonciation en raison du secret professionnel",
      "Complicité de crime",
    ],
    answer: "Aucune non-dénonciation en raison du secret professionnel",
    explanation:
        "Les personnes tenues au secret professionnel ne sont pas assujetties à l’obligation de dénonciation posée par l’article 434-1, sauf dispositions spéciales.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (médecin tenu au secret)",
    question:
        "Un médecin apprend, dans le cadre de son activité professionnelle, qu’un patient a commis un crime et se vante de vouloir recommencer. Le médecin se tait. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune non-dénonciation de crime en raison du secret professionnel",
      "Complicité de crime",
    ],
    answer:
        "Aucune non-dénonciation de crime en raison du secret professionnel",
    explanation:
        "Les personnes astreintes au secret professionnel, visées par l’article 226-13, bénéficient d’une exception à l’obligation de dénoncer posée par l’article 434-1.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (immunité familiale, victime majeure)",
    question:
        "Une mère apprend que sa fille majeure a commis un meurtre sur une victime majeure. Par affection, elle décide de garder le silence. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune infraction grâce à l’immunité familiale",
      "Complicité de meurtre",
    ],
    answer: "Aucune infraction grâce à l’immunité familiale",
    explanation:
        "L’article 434-1 écarte la responsabilité pénale des parents en ligne directe de l’auteur ou du complice, sauf si le crime a été commis sur un mineur.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (immunité familiale, mineur victime)",
    question:
        "Une tante apprend que son frère a commis un viol sur sa fille de 10 ans. Elle hésite, puis choisit de taire les faits. On retient :",
    options: [
      "Aucune infraction en raison de l’immunité familiale",
      "Non-dénonciation de crime (434-1)",
      "Complicité de viol",
    ],
    answer: "Non-dénonciation de crime (434-1)",
    explanation:
        "L’immunité familiale ne profite pas lorsque le crime est commis sur un mineur ; la tante demeure tenue à la dénonciation du crime.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (concubin auteur du crime)",
    question:
        "Une personne vivant notoirement en concubinage avec l’auteur d’un crime apprend les faits et se tait, pour ‘ne pas trahir son compagnon’. Victime majeure. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune infraction car le concubin bénéficie de l’immunité familiale",
      "Complicité de crime",
    ],
    answer:
        "Aucune infraction car le concubin bénéficie de l’immunité familiale",
    explanation:
        "L’article 434-1 vise le conjoint de l’auteur ou du complice ainsi que la personne vivant notoirement en situation maritale avec lui, sauf crime sur mineur.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (crime sur mineur par concubin)",
    question:
        "Une personne vit en concubinage avec l’auteur d’un crime de viol sur un mineur. Malgré sa connaissance des faits, elle ne dénonce pas. On retient :",
    options: [
      "Aucune infraction grâce à l’immunité familiale",
      "Non-dénonciation de crime (434-1)",
      "Complicité de viol",
    ],
    answer: "Non-dénonciation de crime (434-1)",
    explanation:
        "L’immunité ne joue pas pour les crimes commis sur mineurs, même pour le conjoint ou concubin de l’auteur.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (atteinte aux intérêts fondamentaux de la Nation)",
    question:
        "Un individu a connaissance d’un projet d’espionnage mettant gravement en péril les intérêts fondamentaux de la Nation, incriminé pénalement comme crime. Il garde le silence. On retient :",
    options: [
      "Non-dénonciation simple (434-1)",
      "Non-dénonciation aggravée (434-2)",
      "Aucune infraction, immunité familiale possible",
    ],
    answer: "Non-dénonciation aggravée (434-2)",
    explanation:
        "Lorsque le crime non dénoncé constitue une atteinte aux intérêts fondamentaux de la Nation ou un acte de terrorisme, la peine est aggravée et l’immunité familiale exclue.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (terrorisme, proche auteur)",
    question:
        "Une femme sait que son frère prépare un attentat terroriste imminent. Par loyauté familiale, elle garde le silence. On retient :",
    options: [
      "Non-dénonciation aggravée (434-2)",
      "Aucune infraction car immunité familiale",
      "Complicité d’acte de terrorisme uniquement",
    ],
    answer: "Non-dénonciation aggravée (434-2)",
    explanation:
        "En matière de terrorisme, le régime aggravé de l’article 434-2 s’applique et l’immunité familiale prévue par 434-1 est écartée.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (dénonciation à une autorité administrative)",
    question:
        "Une personne, témoin d’un crime sexuel sur un mineur, en informe un médecin inspecteur de la santé placé sous l’autorité du préfet, qui en avise ensuite le parquet. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Dénonciation valable, pas de non-dénonciation",
      "Complicité de viol",
    ],
    answer: "Dénonciation valable, pas de non-dénonciation",
    explanation:
        "La dénonciation peut être adressée aux autorités judiciaires ou administratives, voire à des personnes intervenant pour leur compte dès lors qu’elles transmettent l’information.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (révélation des faits, pas de l’auteur)",
    question:
        "Un témoin informe la police qu’un crime de séquestration est en cours dans un immeuble, sans connaître ni indiquer l’identité de l’auteur ni l’appartement exact. On retient :",
    options: [
      "Non-dénonciation de crime (434-1), car absence d’identité de l’auteur",
      "Dénonciation suffisante : pas de non-dénonciation",
      "Complicité de séquestration",
    ],
    answer: "Dénonciation suffisante : pas de non-dénonciation",
    explanation:
        "L’obligation porte sur la révélation de l’existence du crime et non sur la dénonciation de l’auteur, de son complice ou de son refuge.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (impossibilité matérielle d’alerter)",
    question:
        "Une personne retenue en otage assiste à un crime commis par ses ravisseurs, sans aucun moyen de communication. Elle n’alerte les autorités que plusieurs semaines plus tard, après sa libération, alors que le crime est déjà consommé. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune infraction faute de possibilité concrète de dénoncer",
      "Complicité de crime",
    ],
    answer: "Aucune infraction faute de possibilité concrète de dénoncer",
    explanation:
        "La non-dénonciation est une infraction d’omission qui suppose une possibilité réelle d’informer les autorités ; à défaut, l’élément matériel fait défaut.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (complicité par provocation à se taire)",
    question:
        "Un individu convainc un témoin de ne pas dénoncer un crime de vol à main armée qu’il a vu, pour ‘ne pas faire d’histoires’. Le témoin, qui aurait pu avertir la police à temps, se tait. On retient pour l’individu qui a incité au silence :",
    options: [
      "Aucune infraction personnelle",
      "Complicité de non-dénonciation de crime",
      "Complicité de vol à main armée",
    ],
    answer: "Complicité de non-dénonciation de crime",
    explanation:
        "La complicité de non-dénonciation est punissable au titre des articles 121-6 et 121-7, notamment par provocation ou instructions données.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Théorie — Non-dénonciation (nature de l’infraction)",
    question:
        "La non-dénonciation de crime prévue par l’article 434-1 du Code pénal est :",
    options: [
      "Un crime puni de 15 ans de réclusion",
      "Un délit puni de 3 ans d’emprisonnement et 45 000 € d’amende",
      "Une contravention de 5e classe",
    ],
    answer: "Un délit puni de 3 ans d’emprisonnement et 45 000 € d’amende",
    explanation:
        "L’article 434-1 réprime la non-dénonciation de crime de 3 ans d’emprisonnement et 45 000 € d’amende, ce qui en fait un délit.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Théorie — Non-dénonciation (infractions concernées)",
    question:
        "Quelles infractions sont visées par l’obligation de dénonciation de l’article 434-1 du Code pénal ?",
    options: [
      "Tous les crimes et délits",
      "Uniquement les crimes (y compris tentatives)",
      "Uniquement les crimes contre les personnes",
    ],
    answer: "Uniquement les crimes (y compris tentatives)",
    explanation:
        "L’article 434-1 vise les crimes dont il est encore possible de prévenir ou de limiter les effets, ainsi que leurs tentatives ; les délits ne sont pas concernés.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Théorie — Non-dénonciation (tentative et complicité)",
    question:
        "Concernant la non-dénonciation de crime (434-1), laquelle de ces affirmations est exacte ?",
    options: [
      "La tentative de non-dénonciation est punissable",
      "La tentative n’est pas punissable mais la complicité l’est",
      "Ni la tentative ni la complicité ne sont punissables",
    ],
    answer: "La tentative n’est pas punissable mais la complicité l’est",
    explanation:
        "Le texte ne prévoit pas la tentative de non-dénonciation, mais la complicité reste punissable suivant les articles 121-6 et 121-7 du Code pénal.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Théorie — Non-dénonciation (immunité familiale, principe)",
    question:
        "Parmi les personnes suivantes, lesquelles bénéficient en principe de l’immunité familiale prévue par l’article 434-1 ?",
    options: [
      "Les parents en ligne directe, les frères et sœurs et leurs conjoints, ainsi que le conjoint ou concubin de l’auteur",
      "Uniquement les parents et enfants de l’auteur",
      "Uniquement le conjoint marié de l’auteur",
    ],
    answer:
        "Les parents en ligne directe, les frères et sœurs et leurs conjoints, ainsi que le conjoint ou concubin de l’auteur",
    explanation:
        "L’article 434-1 exclut de l’incrimination les parents en ligne directe et leurs conjoints, les frères et sœurs et leurs conjoints, ainsi que le conjoint ou concubin de l’auteur ou du complice.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Théorie — Non-dénonciation (exclusions de l’immunité)",
    question:
        "Dans quel cas l’immunité familiale de l’article 434-1 ne s’applique-t-elle pas ?",
    options: [
      "Lorsque le crime est un vol simple",
      "Lorsque le crime est commis sur un mineur",
      "Lorsque le crime est un homicide involontaire",
    ],
    answer: "Lorsque le crime est commis sur un mineur",
    explanation:
        "Le texte précise que l’immunité familiale ne s’applique pas pour les crimes commis sur un mineur.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Théorie — Non-dénonciation (régime aggravé 434-2)",
    question:
        "Quelle est la principale conséquence de l’application de l’article 434-2 du Code pénal ?",
    options: [
      "La peine est abaissée à une simple amende",
      "La peine est portée à 5 ans d’emprisonnement et 75 000 € d’amende, sans bénéfice de l’immunité familiale",
      "La non-dénonciation devient une contravention",
    ],
    answer:
        "La peine est portée à 5 ans d’emprisonnement et 75 000 € d’amende, sans bénéfice de l’immunité familiale",
    explanation:
        "L’article 434-2 aggrave la répression pour certains crimes (intérêts fondamentaux, terrorisme) et exclut les alinéas sur l’immunité familiale.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (définition textuelle)",
    question:
        "Selon l’article 434-13 du Code pénal, le faux témoignage consiste en :",
    options: [
      "Tout mensonge devant un policier",
      "Un témoignage mensonger fait sous serment devant toute juridiction ou un OPJ agissant sur commission rogatoire",
      "Toute déclaration inexacte dans la presse",
    ],
    answer:
        "Un témoignage mensonger fait sous serment devant toute juridiction ou un OPJ agissant sur commission rogatoire",
    explanation:
        "L’article 434-13 vise expressément le témoignage mensonger sous serment devant une juridiction ou un OPJ agissant sur commission rogatoire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (élément matériel)",
    question:
        "Lequel de ces éléments n’est pas requis pour caractériser le faux témoignage au sens de l’article 434-13 ?",
    options: [
      "Une déclaration sous serment",
      "Une altération volontaire de la vérité portant sur un point essentiel",
      "Une contrepartie financière",
    ],
    answer: "Une contrepartie financière",
    explanation:
        "La contrepartie financière n’est qu’une circonstance aggravante (434-14, 1°), pas un élément constitutif du faux témoignage simple.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (champ des juridictions)",
    question:
        "Le faux témoignage de l’article 434-13 peut-il être retenu devant une juridiction civile ou prud’homale ?",
    options: [
      "Non, seulement devant les juridictions pénales",
      "Oui, il peut l’être devant toute juridiction",
      "Non, seulement devant les juridictions administratives",
    ],
    answer: "Oui, il peut l’être devant toute juridiction",
    explanation:
        "Le texte vise ‘toute juridiction’, ce qui inclut les juridictions pénales, civiles, administratives, financières, voire prud’homales.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (peine encourue simple)",
    question:
        "Quelle est la peine maximale encourue pour le faux témoignage simple selon l’article 434-13 ?",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation:
        "L’article 434-13 punit le faux témoignage simple de 5 ans d’emprisonnement et 75 000 € d’amende.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (peines aggravées)",
    question:
        "En cas de faux témoignage aggravé par l’une des circonstances de l’article 434-14, quelle est la peine maximale encourue ?",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "10 ans d’emprisonnement et 150 000 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende",
    explanation:
        "L’article 434-14 porte la peine à 7 ans d’emprisonnement et 100 000 € d’amende lorsque les conditions aggravantes sont réunies.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (circ. aggravante de contrepartie)",
    question:
        "La circonstance aggravante prévue à l’article 434-14, 1° suppose :",
    options: [
      "Que le témoignage concerne une affaire criminelle",
      "Que le témoignage soit motivé par la remise d’un don ou d’une récompense quelconque",
      "Que le témoin soit fonctionnaire",
    ],
    answer:
        "Que le témoignage soit motivé par la remise d’un don ou d’une récompense quelconque",
    explanation:
        "Le 1° de l’article 434-14 vise le témoignage mensonger provoqué par un don, une récompense ou toute contrepartie.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (circ. aggravante peine criminelle)",
    question:
        "La circonstance aggravante prévue à l’article 434-14, 2° est liée :",
    options: [
      "À la qualité de magistrat du témoin",
      "Au fait que la personne en faveur ou à charge de laquelle le témoignage est commis est passible d’une peine criminelle",
      "Au fait que le témoin soit récidiviste",
    ],
    answer:
        "Au fait que la personne en faveur ou à charge de laquelle le témoignage est commis est passible d’une peine criminelle",
    explanation:
        "Le 2° de l’article 434-14 aggrave la peine lorsque la personne concernée par le faux témoignage encourt une sanction criminelle.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (rétractation et exemption de peine)",
    question:
        "Selon l’article 434-13, à quelle condition le faux témoin peut-il être exempté de peine ?",
    options: [
      "S’il reconnaît son mensonge au cours de sa garde à vue",
      "S’il rétracte spontanément son témoignage avant la décision mettant fin à la procédure par la juridiction d’instruction ou de jugement",
      "S’il demande pardon à la victime",
    ],
    answer:
        "S’il rétracte spontanément son témoignage avant la décision mettant fin à la procédure par la juridiction d’instruction ou de jugement",
    explanation:
        "L’alinéa 2 de l’article 434-13 prévoit l’exemption de peine en cas de rétractation spontanée avant la décision mettant fin à la procédure.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Faux témoignage (commission rogatoire, serment prêté)",
    question:
        "Devant un OPJ agissant en exécution d’une commission rogatoire, un témoin, régulièrement assermenté, ment volontairement sur un fait essentiel. On retient :",
    options: [
      "Faux témoignage (434-13)",
      "Non-dénonciation de crime (434-1)",
      "Aucune infraction spécifique",
    ],
    answer: "Faux témoignage (434-13)",
    explanation:
        "Le témoignage mensonger sous serment devant un OPJ agissant sur commission rogatoire est expressément visé par l’article 434-13.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (garde à vue, pas de serment)",
    question:
        "Un mis en examen, entendu sous le régime de la garde à vue par un OPJ sur commission rogatoire, ment volontairement sur sa participation aux faits. Il ne prête pas serment. On retient :",
    options: [
      "Faux témoignage (434-13)",
      "Pas de faux témoignage au sens de 434-13",
      "Non-dénonciation de crime (434-1)",
    ],
    answer: "Pas de faux témoignage au sens de 434-13",
    explanation:
        "La personne entendue en garde à vue ne prête pas serment et bénéficie du droit de ne pas s’auto-incriminer ; son mensonge ne relève pas de 434-13.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Faux témoignage (enquête préliminaire, simple témoin)",
    question:
        "Dans une enquête préliminaire, un témoin, non assermenté, ment volontairement à l’OPJ pour protéger un ami. On retient :",
    options: [
      "Faux témoignage (434-13)",
      "Pas de faux témoignage au sens de 434-13",
      "Non-dénonciation de crime (434-1)",
    ],
    answer: "Pas de faux témoignage au sens de 434-13",
    explanation:
        "Le faux témoignage suppose un témoignage sous serment ; les déclarations mensongères en préliminaire ou flagrance sans serment n’entrent pas dans le champ du texte.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Faux témoignage (omission volontaire, point essentiel)",
    question:
        "À l’audience d’un tribunal correctionnel, un témoin prête serment. Il affirme avoir vu la victime frapper l’auteur, mais s’abstient volontairement de préciser que l’auteur avait d’abord provoqué et frappé la victime. Cette omission altère l’appréciation de la légitime défense. On retient :",
    options: [
      "Pas de faux témoignage, car aucune affirmation inexacte",
      "Faux témoignage (434-13) par omission volontaire sur un point essentiel",
      "Simple manquement moral sans portée pénale",
    ],
    answer:
        "Faux témoignage (434-13) par omission volontaire sur un point essentiel",
    explanation:
        "Toute altération volontaire de la vérité sur des circonstances essentielles, y compris par omission, peut caractériser un faux témoignage.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (élément non déterminant)",
    question:
        "Sous serment, un témoin ment volontairement sur la couleur de la chemise d’un prévenu, élément qui n’a aucune incidence sur la solution du litige. On retient :",
    options: [
      "Faux témoignage (434-13) néanmoins constitué",
      "Pas de faux témoignage faute de caractère déterminant du mensonge",
      "Non-dénonciation de crime (434-1)",
    ],
    answer: "Pas de faux témoignage faute de caractère déterminant du mensonge",
    explanation:
        "La jurisprudence exige que le mensonge porte sur une circonstance présentant un intérêt dans l’affaire et susceptible d’influencer la décision du juge.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (erreur de bonne foi)",
    question:
        "Un témoin, très stressé, prête serment et indique une heure de commission des faits erronée, en toute bonne foi, sans intention de tromper. On retient :",
    options: [
      "Faux témoignage (434-13)",
      "Pas de faux témoignage, faute d’intention coupable",
      "Non-dénonciation de crime (434-1)",
    ],
    answer: "Pas de faux témoignage, faute d’intention coupable",
    explanation:
        "L’infraction est intentionnelle : elle suppose la conscience de mentir et le dessein de tromper ; l’erreur de bonne foi n’est pas punissable.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Faux témoignage (don d’argent, affaire délictuelle)",
    question:
        "Un témoin, sous serment devant le tribunal correctionnel, ment volontairement pour innocenter un ami poursuivi pour vol, en échange d’une somme d’argent. On retient :",
    options: [
      "Faux témoignage simple (434-13)",
      "Faux témoignage aggravé (434-14, 1°)",
      "Corruption passive uniquement",
    ],
    answer: "Faux témoignage aggravé (434-14, 1°)",
    explanation:
        "La remise d’un don ou d’une récompense en contrepartie du mensonge caractérise la circonstance aggravante de l’article 434-14, 1°.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (affaire criminelle, sans don)",
    question:
        "Un témoin mensonge sous serment devant la cour d’assises pour faire acquitter un accusé poursuivi pour assassinat, sans recevoir aucune contrepartie. On retient :",
    options: [
      "Faux témoignage simple (434-13)",
      "Faux témoignage aggravé (434-14, 2°)",
      "Non-dénonciation de crime (434-1)",
    ],
    answer: "Faux témoignage aggravé (434-14, 2°)",
    explanation:
        "Lorsque la personne en faveur ou à charge de laquelle le témoignage mensonger est commis est passible d’une peine criminelle, l’article 434-14, 2° aggrave la peine.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Faux témoignage (rétractation spontanée avant la décision)",
    question:
        "Une témoin ment sous serment devant un OPJ agissant sur commission rogatoire. Deux jours plus tard, avant toute ordonnance de non-lieu ou de renvoi, elle revient d’elle-même pour dire la vérité. On retient :",
    options: [
      "Le faux témoignage n’existe pas",
      "Le faux témoignage est constitué mais elle peut être exemptée de peine",
      "Le faux témoignage est constitué et aucune exemption n’est possible",
    ],
    answer:
        "Le faux témoignage est constitué mais elle peut être exemptée de peine",
    explanation:
        "L’article 434-13 prévoit l’exemption de peine en cas de rétractation spontanée avant la décision mettant fin à la procédure d’instruction ou de jugement.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (rétractation tardive)",
    question:
        "Un témoin ment sous serment à l’audience d’un tribunal correctionnel. Il ne se rétracte qu’après le prononcé du jugement définitif. On retient :",
    options: [
      "Exemption de peine pour rétractation",
      "Le faux témoignage demeure puni, la rétractation étant tardive",
      "Absence d’infraction faute de persistance du mensonge",
    ],
    answer: "Le faux témoignage demeure puni, la rétractation étant tardive",
    explanation:
        "La rétractation doit intervenir avant la décision mettant fin à la procédure ; au-delà, elle ne permet plus l’exemption prévue par l’article 434-13.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (subornation et complicité)",
    question:
        "Une personne fournit un faux récit à une prostituée et l’incite à le répéter sous serment devant un OPJ agissant sur commission rogatoire, afin de mettre en cause à tort des suspects passibles d’une peine criminelle. Elle obtient qu’elle mente effectivement. On retient pour la première personne :",
    options: [
      "Subornation de témoin uniquement",
      "Complicité de faux témoignage aggravé",
      "Aucune infraction tant que le juge n’est pas trompé",
    ],
    answer: "Complicité de faux témoignage aggravé",
    explanation:
        "La subornation peut se cumuler avec la complicité de faux témoignage lorsque le mensonge a effectivement été commis, et l’affaire est criminelle, ce qui aggrave la peine.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (tentative et complicité)",
    question:
        "Quel est le régime de la tentative et de la complicité de faux témoignage au regard de l’article 434-13 ?",
    options: [
      "La tentative est punissable, la complicité ne l’est pas",
      "La tentative n’est pas visée, mais la complicité est punissable",
      "Ni la tentative ni la complicité ne sont punissables",
    ],
    answer: "La tentative n’est pas visée, mais la complicité est punissable",
    explanation:
        "Le texte ne prévoit pas la tentative de faux témoignage, mais la complicité peut être retenue selon le droit commun, voire sous la qualification de subornation de témoin.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (personnes exclues)",
    question:
        "Parmi les personnes suivantes, laquelle ne peut, en principe, être poursuivie pour faux témoignage au sens de l’article 434-13 ?",
    options: [
      "Le mineur de moins de 16 ans qui ne prête pas serment",
      "Le simple témoin majeur assermenté à l’audience",
      "La partie civile, quand elle témoigne sous serment",
    ],
    answer: "Le mineur de moins de 16 ans qui ne prête pas serment",
    explanation:
        "Les mineurs de moins de 16 ans ne prêtent pas serment et ne peuvent donc, en principe, être poursuivis pour faux témoignage sur ce fondement.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (délit et non crime)",
    question:
        "Une personne apprend qu’un voisin a commis un vol simple, qualifié de délit, et qu’il pourrait recommencer. Elle se tait. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune non-dénonciation de crime, l’infraction n’étant pas un crime",
      "Complicité de vol",
    ],
    answer:
        "Aucune non-dénonciation de crime, l’infraction n’étant pas un crime",
    explanation:
        "L’article 434-1 vise exclusivement les crimes, et non les délits.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (dénonciation téléphonique anonyme)",
    question:
        "Une personne témoigne d’un crime en cours et appelle anonymement le 17 pour signaler les faits, sans décliner son identité. Elle raccroche aussitôt. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Dénonciation suffisante, absence de non-dénonciation",
      "Complicité de crime",
    ],
    answer: "Dénonciation suffisante, absence de non-dénonciation",
    explanation:
        "Le texte n’impose pas que le dénonciateur s’identifie ; seule compte l’information utile portée aux autorités.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (information imprécise mais utile)",
    question:
        "Un témoin appelle la gendarmerie et signale qu’un enlèvement vient de se produire sur une aire d’autoroute, sans autre détail. La police retrouve l’enfant grâce à cette alerte. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Dénonciation valable, même imprécise",
      "Complicité d’enlèvement",
    ],
    answer: "Dénonciation valable, même imprécise",
    explanation:
        "La dénonciation n’a pas à être complète ; elle doit seulement rendre possible l’intervention des autorités.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Faux témoignage (commission d’enquête parlementaire)",
    question:
        "Un témoin, entendu sous serment devant une commission d’enquête parlementaire, ment sur un point essentiel. Peut-on retenir l’article 434-13 ?",
    options: [
      "Oui, la commission d’enquête est expressément assimilée à une juridiction",
      "Non, l’article 434-13 vise les juridictions et certains OPJ, pas les commissions d’enquête parlementaires",
      "Oui, mais uniquement si le témoin est fonctionnaire",
    ],
    answer:
        "Non, l’article 434-13 vise les juridictions et certains OPJ, pas les commissions d’enquête parlementaires",
    explanation:
        "Le texte cible ‘toute juridiction’ ou l’OPJ sur commission rogatoire ; la commission d’enquête parlementaire relève d’un autre régime.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (témoin assisté)",
    question:
        "Un témoin assisté, entendu par le juge d’instruction, ne prête pas serment. Il ment pour se protéger. On retient :",
    options: [
      "Faux témoignage (434-13)",
      "Pas de faux témoignage, absence de serment",
      "Non-dénonciation de crime (434-1)",
    ],
    answer: "Pas de faux témoignage, absence de serment",
    explanation:
        "Le témoin assisté n’est pas tenu de prêter serment et bénéficie de garanties proches de celles du mis en examen ; il ne peut être poursuivi pour faux témoignage sur ce fondement.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (juridiction administrative)",
    question:
        "Devant un tribunal administratif, un témoin prête serment et ment volontairement sur des faits essentiels à un contentieux de responsabilité de l’État. On retient :",
    options: [
      "Pas de faux témoignage car il ne s’agit pas d’une juridiction pénale",
      "Faux témoignage (434-13)",
      "Simple responsabilité civile",
    ],
    answer: "Faux témoignage (434-13)",
    explanation:
        "L’article 434-13 s’applique à toute juridiction, y compris administrative, dès lors qu’il y a serment et mensonge sur un point essentiel.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (information indirecte mais précise)",
    question:
        "Un individu apprend par confidences répétées et circonstanciées qu’un ami a commis un crime de viol sur une personne majeure et qu’il pourrait recommencer. Il choisit de ne pas appeler la police. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune infraction car il n’a pas été témoin direct",
      "Complicité de viol",
    ],
    answer: "Non-dénonciation de crime (434-1)",
    explanation:
        "Le texte vise toute personne ayant connaissance d’un crime, même par récit indirect, dès lors que la dénonciation pourrait éviter de nouveaux crimes.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (participation au crime)",
    question:
        "Une personne participe au crime comme co-auteur puis s’abstient de le dénoncer. On envisage la non-dénonciation de crime à son encontre. On retient :",
    options: [
      "Elle peut être poursuivie pour non-dénonciation en plus de l’infraction principale",
      "Elle n’est pas tenue de se dénoncer elle-même au titre de 434-1",
      "Elle n’est responsable que de non-dénonciation",
    ],
    answer: "Elle n’est pas tenue de se dénoncer elle-même au titre de 434-1",
    explanation:
        "Celui qui a participé au crime n’est pas soumis à l’obligation de se dénoncer lui-même ; il répond d’abord de l’infraction principale.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (préliminaire)",
    question:
        "En audition libre en enquête préliminaire, une personne ment (sans serment). On retient :",
    options: [
      "Pas de faux témoignage au sens de 434-13",
      "Faux témoignage (434-13)",
      "Non-dénonciation (434-1)",
    ],
    answer: "Pas de faux témoignage au sens de 434-13",
    explanation:
        "Le cours : mensonges en préliminaire/flagrance non punissables au titre de 434-13.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (commission rogatoire)",
    question:
        "Devant un OPJ agissant sur commission rogatoire, un témoin prête serment puis ment sur un point essentiel. On retient :",
    options: [
      "Faux témoignage (434-13)",
      "Non-dénonciation de crime (434-1)",
      "Aucune infraction",
    ],
    answer: "Faux témoignage (434-13)",
    explanation:
        "Conditions réunies : commission rogatoire + serment + altération volontaire de la vérité.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Définition",
    question:
        "La non-dénonciation de crime consiste, pour une personne ayant connaissance d’un crime, à :",
    options: [
      "Ne pas informer les autorités judiciaires ou administratives alors qu’il est encore possible de prévenir ou limiter les effets, ou d’empêcher de nouveaux crimes",
      "Ne pas dénoncer une contravention dans les 24h",
      "Refuser de témoigner en enquête de flagrance",
    ],
    answer:
        "Ne pas informer les autorités judiciaires ou administratives alors qu’il est encore possible de prévenir ou limiter les effets, ou d’empêcher de nouveaux crimes",
    explanation:
        "Le texte vise l’abstention d’informer les autorités lorsque la dénonciation peut être utile (prévenir/limiter/empêcher).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Texte",
    question: "Le délit de non-dénonciation de crime est prévu par :",
    options: [
      "Article 434-1 du Code pénal",
      "Article 434-13 du Code pénal",
      "Article 432-8 du Code pénal",
    ],
    answer: "Article 434-1 du Code pénal",
    explanation:
        "Le cours indique que l’article 434-1 prévoit et réprime le délit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Nature des faits",
    question: "L’obligation de dénonciation concerne :",
    options: [
      "Les infractions de nature criminelle (crimes), quelle que soit leur nature",
      "Uniquement les délits",
      "Uniquement les contraventions",
    ],
    answer:
        "Les infractions de nature criminelle (crimes), quelle que soit leur nature",
    explanation:
        "Sont visées les infractions criminelles, sans distinction de type de crime.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Utilité de la dénonciation",
    question: "La dénonciation doit être :",
    options: [
      "Utile (prévenir/limiter les effets ou empêcher de nouveaux crimes)",
      "Obligatoire même si elle ne sert à rien",
      "Possible uniquement après jugement",
    ],
    answer:
        "Utile (prévenir/limiter les effets ou empêcher de nouveaux crimes)",
    explanation:
        "Le cours insiste : obligation liée aux crimes dont il est encore possible de prévenir/limiter ou d’empêcher des récidives criminelles.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Tentative de crime",
    question: "La non-dénonciation peut aussi concerner :",
    options: [
      "La tentative de crime",
      "Le simple projet criminel sans commencement d’exécution",
      "Uniquement les crimes consommés",
    ],
    answer: "La tentative de crime",
    explanation:
        "Le cours précise que l’incrimination est applicable à la tentative de crime, mais pas au simple projet sans commencement d’exécution.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Projet criminel",
    question: "Le simple projet criminel, sans commencement d’exécution, est :",
    options: [
      "Exclu du champ de la non-dénonciation",
      "Toujours visé par 434-1",
      "Visé uniquement si le crime est contre un mineur",
    ],
    answer: "Exclu du champ de la non-dénonciation",
    explanation:
        "Le cours indique : pas d’obligation au stade du simple projet criminel sans commencement d’exécution.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Infraction d’omission",
    question: "La non-dénonciation de crime est :",
    options: [
      "Une infraction d’omission (abstention de dénonciation)",
      "Une infraction de commission",
      "Une contravention",
    ],
    answer: "Une infraction d’omission (abstention de dénonciation)",
    explanation:
        "Le cours précise : infraction d’omission, l’individu pouvait avertir et ne l’a pas fait.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Autorités compétentes",
    question: "Peut recevoir une dénonciation au sens du cours :",
    options: [
      "Toute autorité susceptible de mesurer l’importance de l’information et d’y donner suite",
      "Uniquement le procureur de la République",
      "Uniquement un juge d’instruction",
    ],
    answer:
        "Toute autorité susceptible de mesurer l’importance de l’information et d’y donner suite",
    explanation:
        "Le cours vise ministère public, police, gendarmerie… et toute autorité utile.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Exemples d’autorités",
    question:
        "Parmi les autorités mentionnées comme pouvant recevoir l’information :",
    options: [
      "Le ministère public, les fonctionnaires de police, la gendarmerie nationale",
      "Uniquement l’avocat de la victime",
      "Uniquement un journaliste",
    ],
    answer:
        "Le ministère public, les fonctionnaires de police, la gendarmerie nationale",
    explanation: "Le cours donne ces exemples d’autorités susceptibles d’agir.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category:
        "Non-dénonciation de crime — Personne intervenant pour leur compte",
    question: "La jurisprudence admet que la dénonciation peut être faite :",
    options: [
      "Auprès de toute personne intervenant pour le compte des autorités",
      "Uniquement en main propre au procureur",
      "Uniquement par écrit recommandé",
    ],
    answer: "Auprès de toute personne intervenant pour le compte des autorités",
    explanation:
        "Le cours indique que la dénonciation peut être faite à une personne qui intervient pour le compte des autorités.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Objet de l’information",
    question: "L’information donnée doit porter :",
    options: [
      "Sur l’existence des faits (le crime) et non nécessairement sur l’identité de l’auteur",
      "Uniquement sur l’identité de l’auteur",
      "Uniquement sur le lieu de résidence du suspect",
    ],
    answer:
        "Sur l’existence des faits (le crime) et non nécessairement sur l’identité de l’auteur",
    explanation:
        "Cass. crim., 26 février 1959 : obligation de dénoncer le crime, pas l’identité ou le refuge des auteurs.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Modalités",
    question: "Les modalités de dénonciation sont :",
    options: [
      "Libres (toutes modalités admissibles)",
      "Uniquement écrites",
      "Uniquement via dépôt de plainte",
    ],
    answer: "Libres (toutes modalités admissibles)",
    explanation:
        "Le cours indique : toutes modalités de dénonciation sont admissibles.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Finalité",
    question: "L’objectif de la dénonciation est de :",
    options: [
      "Prévenir un trouble à l’ordre public et prévenir/limiter les effets du crime",
      "Remplacer l’enquête judiciaire",
      "Garantir une condamnation automatique",
    ],
    answer:
        "Prévenir un trouble à l’ordre public et prévenir/limiter les effets du crime",
    explanation:
        "Le cours insiste sur la prévention du trouble et la limitation/empêchement.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Nouveaux crimes",
    question: "La dénonciation peut être utile pour :",
    options: [
      "Éviter la commission de nouveaux crimes (notamment via l’identification des auteurs)",
      "Uniquement punir moralement l’auteur",
      "Uniquement réparer le préjudice civil",
    ],
    answer:
        "Éviter la commission de nouveaux crimes (notamment via l’identification des auteurs)",
    explanation:
        "Le cours mentionne l’objectif d’empêcher de nouveaux crimes, notamment par l’identification.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Élément moral",
    question: "L’élément moral suppose :",
    options: [
      "S’abstenir volontairement de dénoncer un crime dont on a connaissance",
      "Une imprudence",
      "Une simple rumeur",
    ],
    answer:
        "S’abstenir volontairement de dénoncer un crime dont on a connaissance",
    explanation:
        "Le cours : intention déduite de la connaissance du crime et de l’absence de dénonciation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Mobile",
    question: "Le mobile expliquant l’abstention :",
    options: [
      "Importe peu",
      "Écarte l’infraction s’il est honorable",
      "Aggrave toujours la peine",
    ],
    answer: "Importe peu",
    explanation: "Le cours précise que le mobile importe peu.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Jurisprudence (preuve des éléments)",
    question: "La Cour de cassation impose aux juges du fond :",
    options: [
      "De constater l’existence de l’infraction dans tous ses éléments",
      "De présumer l’infraction dès qu’un crime existe",
      "De ne vérifier que l’élément moral",
    ],
    answer: "De constater l’existence de l’infraction dans tous ses éléments",
    explanation:
        "Cass. crim., 17 avril 1956 : exigence de caractérisation de tous les éléments.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 434-1 — EXCEPTIONS / IMMUNITÉS
  // =========================================================
  const QuizQuestion(
    category: "Non-dénonciation de crime — Immunité familiale",
    question: "L’immunité familiale prévue par 434-1 s’applique :",
    options: [
      "Aux proches de l’auteur/complice, sauf pour les crimes commis sur les mineurs",
      "À tous les amis de l’auteur",
      "À toute personne vivant dans le même quartier",
    ],
    answer:
        "Aux proches de l’auteur/complice, sauf pour les crimes commis sur les mineurs",
    explanation:
        "Le texte exclut l’immunité familiale lorsque les crimes sont commis sur les mineurs.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Proches concernés",
    question: "Sont visés par l’immunité familiale (434-1) :",
    options: [
      "Parents en ligne directe et leurs conjoints ; frères/sœurs et leurs conjoints ; conjoint/concubin/partenaire de PACS",
      "Uniquement les parents en ligne directe",
      "Uniquement le conjoint marié",
    ],
    answer:
        "Parents en ligne directe et leurs conjoints ; frères/sœurs et leurs conjoints ; conjoint/concubin/partenaire de PACS",
    explanation:
        "Le cours liste précisément ces proches et inclut concubin/PACS.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Crimes sur mineurs",
    question: "Concernant les crimes commis sur les mineurs :",
    options: [
      "L’immunité familiale ne s’applique pas",
      "L’immunité familiale s’applique toujours",
      "Seul le secret professionnel s’applique",
    ],
    answer: "L’immunité familiale ne s’applique pas",
    explanation:
        "Le cours indique : immunité familiale OUI sauf crimes commis sur mineurs.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Secret professionnel",
    question: "Les personnes astreintes au secret professionnel :",
    options: [
      "Sont exemptées de l’obligation de dénonciation (226-13)",
      "Doivent toujours dénoncer tout crime",
      "Ne peuvent jamais dénoncer un crime",
    ],
    answer: "Sont exemptées de l’obligation de dénonciation (226-13)",
    explanation:
        "Le cours précise l’exemption liée au secret professionnel (226-13).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Participant au crime",
    question: "Celui qui a participé au crime :",
    options: [
      "Est également excepté de l’obligation de dénonciation",
      "Doit dénoncer sous peine d’aggravation",
      "Bénéficie d’une immunité uniquement si mineur",
    ],
    answer: "Est également excepté de l’obligation de dénonciation",
    explanation:
        "Le cours indique expressément que le participant est excepté.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 434-2 — CIRCONSTANCES AGGRAVANTES (NON-DÉNONCIATION)
  // =========================================================
  const QuizQuestion(
    category: "Non-dénonciation de crime — Aggravation",
    question:
        "La circonstance aggravante de la non-dénonciation est prévue par :",
    options: [
      "Article 434-2 du Code pénal",
      "Article 434-14 du Code pénal",
      "Article 434-15 du Code pénal",
    ],
    answer: "Article 434-2 du Code pénal",
    explanation:
        "Le cours : aggravation lorsque le crime non dénoncé porte sur intérêts fondamentaux de la Nation ou terrorisme.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Crimes concernés (434-2)",
    question: "L’aggravation 434-2 vise notamment :",
    options: [
      "Atteintes aux intérêts fondamentaux de la Nation ou actes de terrorisme",
      "Tous les délits routiers",
      "Les contraventions de tapage",
    ],
    answer:
        "Atteintes aux intérêts fondamentaux de la Nation ou actes de terrorisme",
    explanation: "Le cours cite trahison, espionnage, attentat, etc.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Immunité et 434-2",
    question: "En cas de 434-2, les dispositions d’immunité familiale :",
    options: [
      "Ne sont pas applicables",
      "Restent applicables",
      "S’appliquent uniquement aux conjoints",
    ],
    answer: "Ne sont pas applicables",
    explanation:
        "Le cours précise : en 434-2, l’immunité familiale de 434-1 ne s’applique pas.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Peines (simple)",
    question: "Peines encourues (434-1 al.1) :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Répression indiquée par le cours pour la forme simple.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Peines (aggravée)",
    question: "Peines encourues en cas d’application de 434-2 :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Répression aggravée indiquée par le cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Personnes morales",
    question: "Les personnes morales :",
    options: [
      "Peuvent être pénalement responsables (121-2)",
      "Ne peuvent jamais être responsables",
      "Sont responsables uniquement en contravention",
    ],
    answer: "Peuvent être pénalement responsables (121-2)",
    explanation:
        "Le cours précise la responsabilité pénale des personnes morales.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Tentative",
    question: "La tentative de non-dénonciation de crime est :",
    options: [
      "Non incriminée",
      "Incriminée",
      "Incriminée uniquement en cas de terrorisme",
    ],
    answer: "Non incriminée",
    explanation: "Le cours précise : TENTATIVE : NON.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Complicité",
    question: "La complicité de non-dénonciation est :",
    options: [
      "Punissable (121-6 et 121-7)",
      "Impossible",
      "Punissable uniquement si l’auteur est un professionnel de santé",
    ],
    answer: "Punissable (121-6 et 121-7)",
    explanation:
        "Le cours : complicité possible, notamment celui qui incite à ne pas dénoncer.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Exemple de complicité",
    question: "Peut se rendre complice :",
    options: [
      "Celui qui incite l’auteur à ne pas dénoncer le crime dont il a été témoin",
      "Celui qui dénonce trop tard",
      "Celui qui transmet l’information aux autorités",
    ],
    answer:
        "Celui qui incite l’auteur à ne pas dénoncer le crime dont il a été témoin",
    explanation: "Exemple explicitement cité dans le cours.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 434-13 — FAUX TÉMOIGNAGE / TÉMOIGNAGE MENSONGER (PRINCIPES)
  // =========================================================
  const QuizQuestion(
    category: "Faux témoignage — Définition",
    question: "Le témoignage mensonger consiste en :",
    options: [
      "Un témoignage mensonger fait sous serment devant une juridiction ou devant un OPJ agissant sur commission rogatoire",
      "Un mensonge en enquête de flagrance",
      "Une dénonciation calomnieuse",
    ],
    answer:
        "Un témoignage mensonger fait sous serment devant une juridiction ou devant un OPJ agissant sur commission rogatoire",
    explanation:
        "Définition donnée : mensonge sous serment, juridiction ou OPJ sur commission rogatoire.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Texte",
    question: "Le délit de faux témoignage est réprimé par :",
    options: [
      "Article 434-13 du Code pénal",
      "Article 434-1 du Code pénal",
      "Article 432-9 du Code pénal",
    ],
    answer: "Article 434-13 du Code pénal",
    explanation: "Le cours : défini et réprimé par l’article 434-13 C.P.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Où ?",
    question: "Le faux témoignage est punissable s’il est fait :",
    options: [
      "Devant une juridiction ou devant un OPJ en exécution d’une commission rogatoire",
      "Devant un OPJ en enquête préliminaire",
      "Devant un ami témoin",
    ],
    answer:
        "Devant une juridiction ou devant un OPJ en exécution d’une commission rogatoire",
    explanation:
        "Le cours exclut les mensonges en enquête préliminaire/flagrance (hors commission rogatoire).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Juridiction (sens large)",
    question: "Le terme « juridiction » doit être compris :",
    options: [
      "Au sens large : pénale, civile, administrative, financière, instruction, jugement, etc.",
      "Uniquement pénale",
      "Uniquement civile",
    ],
    answer:
        "Au sens large : pénale, civile, administrative, financière, instruction, jugement, etc.",
    explanation: "Le cours précise le caractère général du terme juridiction.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Enquête préliminaire/flagrance",
    question:
        "Des déclarations mensongères en enquête préliminaire ou de flagrance :",
    options: [
      "Ne sont pas punissables au titre du faux témoignage",
      "Sont toujours punissables au titre de 434-13",
      "Sont punissables seulement si elles sont écrites",
    ],
    answer: "Ne sont pas punissables au titre du faux témoignage",
    explanation:
        "Le cours : faux témoignage punissable en justice ou CR ; pas en préliminaire/flagrance.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Condition du serment",
    question: "Le faux témoignage suppose :",
    options: [
      "Un témoignage fait sous la foi du serment",
      "Un simple mensonge sans serment",
      "Un mensonge par SMS",
    ],
    answer: "Un témoignage fait sous la foi du serment",
    explanation:
        "Le mensonge ne suffit pas : il faut la violation d’un serment.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Formule du serment",
    question: "Le serment consiste à promettre :",
    options: [
      "De dire la vérité, toute la vérité",
      "De dire ce dont on se souvient vaguement",
      "De ne pas incriminer un proche",
    ],
    answer: "De dire la vérité, toute la vérité",
    explanation: "Formule indiquée : vérité, toute la vérité.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Mineurs",
    question: "Le faux témoignage ne peut être retenu contre :",
    options: [
      "Les mineurs de moins de 16 ans (serment non exigé)",
      "Tout mineur quel que soit l’âge",
      "Uniquement les mineurs de moins de 13 ans",
    ],
    answer: "Les mineurs de moins de 16 ans (serment non exigé)",
    explanation:
        "Le cours précise : pas de serment exigé avant 16 ans → pas de faux témoignage.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Incapacité de témoigner",
    question: "Le faux témoignage ne peut viser :",
    options: [
      "Les personnes interdites de témoigner autrement que pour simples déclarations",
      "Toute personne majeure",
      "Tout témoin sans exception",
    ],
    answer:
        "Les personnes interdites de témoigner autrement que pour simples déclarations",
    explanation:
        "Le cours mentionne les incapacités, notamment l’interdiction de témoigner.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Personnes au statut particulier",
    question:
        "Parmi les personnes dont le statut peut empêcher le faux témoignage :",
    options: [
      "La partie civile, le témoin assisté, etc.",
      "Le procureur",
      "Le greffier",
    ],
    answer: "La partie civile, le témoin assisté, etc.",
    explanation:
        "Le cours cite des incapacités liées au statut (intérêt au litige, témoin assisté…).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Garde à vue sur commission rogatoire",
    question:
        "La personne entendue par l’OPJ en commission rogatoire sous le régime de la garde à vue :",
    options: [
      "Ne peut pas être poursuivie pour faux témoignage car elle ne prête pas serment",
      "Prête serment comme un témoin",
      "Est automatiquement condamnable",
    ],
    answer:
        "Ne peut pas être poursuivie pour faux témoignage car elle ne prête pas serment",
    explanation:
        "Le cours : le suspect en GAV n’est pas tenu de prêter serment (droit de ne pas s’auto-incriminer).",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 434-13 — CARACTÉRISATION DU MENSONGE
  // =========================================================
  const QuizQuestion(
    category: "Faux témoignage — Altération de la vérité",
    question: "Le faux témoignage consiste en :",
    options: [
      "Toute altération sciemment faite de la vérité",
      "Uniquement un mensonge écrit",
      "Uniquement une contradiction",
    ],
    answer: "Toute altération sciemment faite de la vérité",
    explanation:
        "Le code n’énumère pas : toute altération sciemment faite de la vérité est incriminée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Infraction de commission",
    question: "Le faux témoignage est une infraction de :",
    options: ["Commission (acte positif)", "Omission", "Négligence"],
    answer: "Commission (acte positif)",
    explanation:
        "Le cours : acte positif requis. Refus de comparaître/de déposer ≠ faux témoignage.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Refus de déposer",
    question: "Le refus de comparaître ou de déposer :",
    options: [
      "Ne peut pas être assimilé à un faux témoignage",
      "Constitue toujours un faux témoignage",
      "Constitue une tentative de faux témoignage",
    ],
    answer: "Ne peut pas être assimilé à un faux témoignage",
    explanation:
        "Le cours : refus ≠ faux témoignage (infraction de commission).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Mensonge par affirmation",
    question: "Le faux témoignage peut consister en :",
    options: [
      "L’affirmation d’un fait inexact",
      "Uniquement une omission",
      "Uniquement un silence total",
    ],
    answer: "L’affirmation d’un fait inexact",
    explanation:
        "Le cours cite l’affirmation d’un fait inexact comme forme classique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Mensonge par négation",
    question: "Constitue un faux témoignage le fait :",
    options: [
      "De nier un fait véritable (dire ne pas savoir alors qu’on sait)",
      "De répondre trop vite",
      "De se tromper de date par émotion",
    ],
    answer: "De nier un fait véritable (dire ne pas savoir alors qu’on sait)",
    explanation:
        "Le cours : le témoin qui déclare ne pas savoir alors qu’il sait tombe sous le coup de la loi pénale.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Mensonge par omission",
    question: "Le mensonge peut être réalisé par omission lorsque :",
    options: [
      "Le témoin garde le silence sur un point déterminé ou donne une réponse partielle dénaturant les faits",
      "Le témoin oublie involontairement",
      "Le témoin refuse de signer",
    ],
    answer:
        "Le témoin garde le silence sur un point déterminé ou donne une réponse partielle dénaturant les faits",
    explanation:
        "Le cours admet l’omission lorsque la présentation incomplète dénature les faits.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Déclarations déterminantes",
    question: "Le faux témoignage n’est punissable que si :",
    options: [
      "Il porte sur des déclarations pouvant avoir une incidence sur la solution du procès",
      "Il porte sur n’importe quel détail sans intérêt",
      "Il est fait en dehors de toute procédure",
    ],
    answer:
        "Il porte sur des déclarations pouvant avoir une incidence sur la solution du procès",
    explanation:
        "Analyse jurisprudentielle : le témoignage doit être déterminant (incidence sur la solution).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Circonstances essentielles",
    question: "Pour être déterminant, le mensonge doit porter :",
    options: [
      "Sur des circonstances essentielles du fait ayant donné lieu au litige",
      "Uniquement sur l’état civil d’un témoin",
      "Uniquement sur des éléments sans lien avec l’affaire",
    ],
    answer:
        "Sur des circonstances essentielles du fait ayant donné lieu au litige",
    explanation:
        "Le cours cite : altération volontaire portant sur circonstances essentielles.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Élément moral",
    question: "L’infraction de faux témoignage est :",
    options: [
      "Intentionnelle (mauvaise foi, conscience de mentir et de trahir le serment)",
      "Non intentionnelle",
      "Une infraction d’imprudence",
    ],
    answer:
        "Intentionnelle (mauvaise foi, conscience de mentir et de trahir le serment)",
    explanation:
        "Le cours : mensonge intentionnel, volonté délibérée de tromper la justice.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Erreur / inattention",
    question: "Le témoin qui se trompe de bonne foi :",
    options: [
      "N’est pas punissable au titre du faux témoignage",
      "Est toujours punissable",
      "Est punissable uniquement si le juge le décide",
    ],
    answer: "N’est pas punissable au titre du faux témoignage",
    explanation:
        "Le cours : la loi ne punit pas l’erreur de bonne foi, mais le mensonge volontaire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Mobile",
    question: "Le mobile du faux témoin :",
    options: [
      "Est indifférent",
      "Écarte toujours l’infraction",
      "Aggrave automatiquement la peine",
    ],
    answer: "Est indifférent",
    explanation: "Le cours précise : caractérisée quel que soit le mobile.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 434-14 — CIRCONSTANCES AGGRAVANTES (FAUX TÉMOIGNAGE)
  // =========================================================
  const QuizQuestion(
    category: "Faux témoignage — Aggravation (don/récompense)",
    question: "Le faux témoignage est aggravé lorsque :",
    options: [
      "Il est provoqué par la remise d’un don ou d’une récompense quelconque",
      "Il est prononcé trop vite",
      "Il est fait sans émotion",
    ],
    answer:
        "Il est provoqué par la remise d’un don ou d’une récompense quelconque",
    explanation: "Article 434-14 1° : don/récompense quelconque.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Récompense quelconque",
    question: "La notion de « récompense quelconque » est interprétée comme :",
    options: [
      "Toute contrepartie ayant un impact sur le témoignage",
      "Uniquement une somme d’argent",
      "Uniquement un cadeau matériel",
    ],
    answer: "Toute contrepartie ayant un impact sur le témoignage",
    explanation:
        "Le cours : toute contrepartie déterminant le témoignage mensonger.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Aggravation (peine criminelle)",
    question: "Le faux témoignage est aggravé lorsque :",
    options: [
      "La personne contre laquelle ou en faveur de laquelle il est commis est passible d’une peine criminelle",
      "La personne est passible d’une amende seulement",
      "Le témoin est stressé",
    ],
    answer:
        "La personne contre laquelle ou en faveur de laquelle il est commis est passible d’une peine criminelle",
    explanation: "Article 434-14 2° : passible d’une peine criminelle.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Peines (simple)",
    question: "Peines encourues pour le faux témoignage simple (434-13) :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Répression indiquée dans le cours (forme simple).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Peines (aggravé)",
    question: "Peines encourues pour le faux témoignage aggravé (434-14) :",
    options: [
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende",
    explanation: "Répression indiquée pour les formes aggravées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Tentative",
    question: "La tentative de faux témoignage est :",
    options: [
      "Non incriminée",
      "Incriminée",
      "Incriminée uniquement en assises",
    ],
    answer: "Non incriminée",
    explanation: "Le cours précise : TENTATIVE : NON.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Complicité",
    question: "La complicité de faux témoignage est :",
    options: [
      "Punissable (121-6 et 121-7) et peut se confondre avec la subornation de témoin",
      "Impossible",
      "Punissable uniquement si le témoin est mineur",
    ],
    answer:
        "Punissable (121-6 et 121-7) et peut se confondre avec la subornation de témoin",
    explanation:
        "Le cours : complicité possible ; peut se confondre avec subornation (434-15).",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 434-13 al.2 — RÉTRACTATION / EXEMPTION DE PEINE
  // =========================================================
  const QuizQuestion(
    category: "Faux témoignage — Rétractation",
    question: "Le faux témoin est exempt de peine s’il :",
    options: [
      "A rétracté spontanément son témoignage avant la décision mettant fin à la procédure",
      "A rétracté après la condamnation",
      "A rétracté uniquement sur demande du juge",
    ],
    answer:
        "A rétracté spontanément son témoignage avant la décision mettant fin à la procédure",
    explanation:
        "434-13 al.2 : exemption si rétractation spontanée avant décision de fin de procédure.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Spontanéité",
    question: "N’est pas considérée comme spontanée :",
    options: [
      "La rétractation à la demande du juge d’instruction",
      "La rétractation sans pression",
      "La rétractation immédiate de l’initiative du témoin",
    ],
    answer: "La rétractation à la demande du juge d’instruction",
    explanation: "Le cours : rétractation à la demande du juge ≠ spontanée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Rétractation après mise en examen",
    question: "N’est pas spontanée :",
    options: [
      "La rétractation intervenue après la mise en examen du faux témoin",
      "La rétractation immédiate",
      "La rétractation avant toute poursuite",
    ],
    answer: "La rétractation intervenue après la mise en examen du faux témoin",
    explanation: "Le cours cite ce cas comme non spontané.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Effet de la rétractation",
    question: "La rétractation :",
    options: [
      "N’efface pas l’infraction, mais permet l’exemption de peine",
      "Supprime l’infraction",
      "Aggrave la peine",
    ],
    answer: "N’efface pas l’infraction, mais permet l’exemption de peine",
    explanation:
        "Le témoin reste coupable mais n’est pas condamné à une peine.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Moment limite",
    question:
        "En jurisprudence, la limite au-delà de laquelle la rétractation est tardive est :",
    options: [
      "La clôture des débats",
      "L’ouverture de l’audience",
      "Le dépôt de plainte",
    ],
    answer: "La clôture des débats",
    explanation:
        "Le cours indique que la clôture des débats marque traditionnellement la limite.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Délit aggravé et rétractation",
    question: "La rétractation/exemption :",
    options: [
      "Peut logiquement s’appliquer aussi au faux témoignage aggravé",
      "Ne s’applique jamais au faux témoignage aggravé",
      "S’applique uniquement aux mineurs",
    ],
    answer: "Peut logiquement s’appliquer aussi au faux témoignage aggravé",
    explanation:
        "Le cours indique qu’il semble logique d’appliquer l’exemption aussi à l’aggravé.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Définition de la rétractation",
    question: "Une rétractation est :",
    options: [
      "Toute manifestation de repentir suffisamment significative pour effacer le mensonge",
      "Une simple excuse",
      "Une justification du mensonge",
    ],
    answer:
        "Toute manifestation de repentir suffisamment significative pour effacer le mensonge",
    explanation:
        "Le cours : toute manifestation suffisamment significative, avec caractère spontané.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // MINI-CAS / PIÈGES (MIXTE) — ACTION DE LA JUSTICE
  // =========================================================
  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation",
    question:
        "Une personne sait qu’un crime est en cours de préparation (commencement d’exécution), et la dénonciation peut empêcher le passage à l’acte. Elle se tait. On retient :",
    options: [
      "La non-dénonciation de crime (434-1)",
      "Le faux témoignage (434-13)",
      "Aucune infraction possible",
    ],
    answer: "La non-dénonciation de crime (434-1)",
    explanation:
        "Le cours : applicable aux crimes encore évitables ou limitables, y compris tentative.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Projet criminel",
    question:
        "Une personne entend un voisin parler d’un « projet » de crime, sans commencement d’exécution. Elle ne dit rien. Selon le cours :",
    options: [
      "434-1 ne s’applique pas (simple projet sans commencement d’exécution)",
      "434-1 s’applique toujours",
      "On retient 434-13",
    ],
    answer:
        "434-1 ne s’applique pas (simple projet sans commencement d’exécution)",
    explanation:
        "Le cours exclut le simple projet criminel non suivi d’un commencement d’exécution.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Faux témoignage et enquête",
    question:
        "Une personne ment en audition libre en enquête préliminaire, sans serment. On retient :",
    options: [
      "Pas de faux témoignage au sens de 434-13",
      "Faux témoignage (434-13)",
      "Non-dénonciation (434-1)",
    ],
    answer: "Pas de faux témoignage au sens de 434-13",
    explanation:
        "Le cours : les déclarations mensongères en préliminaire/flagrance ne sont pas punissables au titre du faux témoignage.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — OPJ commission rogatoire",
    question:
        "Une personne ment sous serment devant un OPJ agissant sur commission rogatoire. On retient :",
    options: [
      "Faux témoignage (434-13)",
      "Non-dénonciation (434-1)",
      "Aucune infraction",
    ],
    answer: "Faux témoignage (434-13)",
    explanation:
        "Le faux témoignage est punissable devant l’OPJ en exécution d’une commission rogatoire.",
    difficulty: "Moyenne",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizAtteinteActionJusticeGPX extends StatefulWidget {
  static const String grade = 'gpx';
  static const String routeName = '/gpx/nation/quiz/atteintes_action_justice';
  final String uid;
  final String email;

  const QuizAtteinteActionJusticeGPX({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizAtteinteActionJusticeGPX> createState() => _QuizAtteinteActionJusticeGPXState();
}

class _QuizAtteinteActionJusticeGPXState extends State<QuizAtteinteActionJusticeGPX>
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
  static const _introHiddenKey = 'intro_gpx_atteintes_action_justice';
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
        ? questionAtteinteActionJustice
        : questionAtteinteActionJustice
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
            'quiz_name': 'Atteintes à l\'action de la justice',
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
      await _sb.from('quiz_atteintes_action_justice').insert({
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
      debugPrint('❌ quiz_atteintes_action_justice insert failed: $e');
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
      'source_file': 'gpx_quiz_atteintes_action_justice',
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
                            icon: Icons.account_balance_rounded,
                            title: 'Atteintes à la justice',
                            description: 'Approfondis les infractions qui portent atteinte à l’autorité de la justice : entrave, faux témoignage, subornation de témoin.',
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
