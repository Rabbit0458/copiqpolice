// ignore_for_file: use_build_context_synchronously

// ============================================================================
//  Quiz UsageArmes – version refondue
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

final List<QuizQuestion> questionsLibertesPubliquesIndividuelles = [
  // ===================== NIVEAU FACILE =====================
  // ---------- FONDEMENTS GÉNÉRAUX ----------
  QuizQuestion(
    category: "Fondements juridiques",
    question:
        "Quel texte du Code civil consacre expressément le droit au respect de la vie privée ?",
    options: [
      "L’article 9 du Code civil",
      "L’article 2 du Code civil",
      "L’article 1240 du Code civil",
    ],
    answer: "L’article 9 du Code civil",
    explanation:
        "L’article 9 du Code civil énonce que « chacun a droit au respect de sa vie privée » et sert de base à la protection civile de ce droit.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Respect de la personne — principes",
    question:
        "Tout individu a droit au respect de sa personne et ne doit pas faire l’objet de discriminations notamment en raison :",
    options: [
      "De son origine, sexe, religion, handicap, situation de famille, mœurs, etc.",
      "Uniquement de sa nationalité et de son âge",
      "Uniquement de son niveau d’études",
    ],
    answer:
        "De son origine, sexe, religion, handicap, situation de famille, mœurs, etc.",
    explanation:
        "Le texte liste de nombreux critères protégés : origine, race, religion, sexe, handicap, état de santé, situation de famille, mœurs, etc.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Respect de la personne — principes",
    question:
        "Les forces de sécurité doivent connaître l’arsenal législatif en matière de discrimination afin de :",
    options: [
      "Prévenir, constater et réprimer les comportements discriminatoires",
      "Uniquement informer les victimes sans suite",
      "Uniquement gérer les conflits internes à la police",
    ],
    answer:
        "Prévenir, constater et réprimer les comportements discriminatoires",
    explanation:
        "Le cours souligne ces trois volets : prévention, constatation et répression.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Respect de la personne — textes",
    question:
        "Quels articles du Code de la sécurité intérieure rappellent la protection et le respect des personnes, notamment privées de liberté ?",
    options: [
      "Les articles R. 434-14 et R. 434-16",
      "Les articles R. 111-1 et R. 111-2",
      "Les articles R. 322-5 et R. 322-6",
    ],
    answer: "Les articles R. 434-14 et R. 434-16",
    explanation:
        "Ces dispositions du code de déontologie sont explicitement mentionnées dans le texte.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Respect de la personne — textes",
    question: "La loi du 28 mai 1971 concerne notamment :",
    options: [
      "L’adhésion de la France à la Convention internationale sur l’élimination de toutes les formes de discrimination raciale",
      "La réforme du Code de la route",
      "La création des cartes de séjour pluriannuelles",
    ],
    answer:
        "L’adhésion de la France à la Convention internationale sur l’élimination de toutes les formes de discrimination raciale",
    explanation:
        "Cette loi consacre l’adhésion de la France à cette convention internationale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Respect de la personne — textes",
    question: "Le Défenseur des droits a été créé par :",
    options: [
      "La loi organique n° 2011-333 et la loi ordinaire n° 2011-334 du 29 mars 2011",
      "La loi du 29 juillet 1881 sur la presse",
      "La loi du 3 février 2003",
    ],
    answer:
        "La loi organique n° 2011-333 et la loi ordinaire n° 2011-334 du 29 mars 2011",
    explanation:
        "Ces deux lois de 2011 sont explicitement citées comme créant le Défenseur des droits.",
    difficulty: "Facile",
  ),

  // ================== NIVEAU MOYEN ==================
  // --------- CODE PÉNAL — DÉFINITION GÉNÉRALE ---------
  QuizQuestion(
    category: "Code pénal — définition",
    question:
        "Selon l’article 225-1 du Code pénal, constitue une discrimination :",
    options: [
      "Toute distinction opérée entre les personnes sur la base d’un grand nombre de critères protégés (origine, sexe, opinions, handicap, etc.)",
      "Toute différence de traitement, quel qu’en soit le motif",
      "Uniquement le refus de fournir un service",
    ],
    answer:
        "Toute distinction opérée entre les personnes sur la base d’un grand nombre de critères protégés (origine, sexe, opinions, handicap, etc.)",
    explanation:
        "L’article 225-1 dresse une liste très large de critères prohibés (origine, sexe, situation de famille, apparence physique, état de santé, handicap, opinions, religion, etc.).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Code pénal — définition",
    question:
        "L’article 225-1-1 du Code pénal ajoute à la définition de la discrimination :",
    options: [
      "La distinction faite parce qu’une personne a subi, refusé de subir ou témoigné de faits de harcèlement sexuel",
      "Uniquement la distinction fondée sur la nationalité",
      "La seule discrimination salariale",
    ],
    answer:
        "La distinction faite parce qu’une personne a subi, refusé de subir ou témoigné de faits de harcèlement sexuel",
    explanation:
        "L’article 225-1-1 vise précisément les discriminations en lien avec le harcèlement sexuel.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Code pénal — définition",
    question:
        "L’article 225-1-2 du Code pénal vise les discriminations liées :",
    options: [
      "Au fait d’avoir subi, refusé de subir ou témoigné de faits de bizutage",
      "Uniquement au niveau de revenus",
      "À la profession exercée",
    ],
    answer:
        "Au fait d’avoir subi, refusé de subir ou témoigné de faits de bizutage",
    explanation:
        "Cet article complète la définition en ajoutant les discriminations liées au bizutage.",
    difficulty: "Moyenne",
  ),

  // --------- DISCRIMINATIONS PAR UN FONCTIONNAIRE ---------
  QuizQuestion(
    category: "Code pénal — fonctionnaires",
    question:
        "L’article 432-7 du Code pénal sanctionne la discrimination commise :",
    options: [
      "Par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
      "Uniquement par un salarié du secteur privé",
      "Uniquement par un élu local",
    ],
    answer:
        "Par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
    explanation:
        "L’article 432-7 vise les discriminations commises dans l’exercice ou à l’occasion des fonctions ou de la mission de service public.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Code pénal — fonctionnaires",
    question:
        "Selon l’article 432-7 du Code pénal, la discrimination commise par un fonctionnaire est constituée notamment lorsqu’elle consiste :",
    options: [
      "À refuser le bénéfice d’un droit accordé par la loi ou à entraver l’exercice normal d’une activité économique",
      "À exprimer une opinion personnelle en dehors du service",
      "À appliquer strictement un règlement interne",
    ],
    answer:
        "À refuser le bénéfice d’un droit accordé par la loi ou à entraver l’exercice normal d’une activité économique",
    explanation:
        "Le texte cite précisément ces deux comportements comme exemples de discrimination réprimée par l’article 432-7.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Code pénal — fonctionnaires",
    question:
        "La peine encourue par un fonctionnaire pour une discrimination au sens de l’article 432-7 est :",
    options: [
      "Cinq ans d’emprisonnement et 75 000 € d’amende",
      "Un simple rappel à la loi",
      "Uniquement une sanction disciplinaire sans volet pénal",
    ],
    answer: "Cinq ans d’emprisonnement et 75 000 € d’amende",
    explanation:
        "Le texte indique expressément ces peines pour la discrimination commise par un dépositaire de l’autorité publique.",
    difficulty: "Moyenne",
  ),

  // --------- DISCRIMINATIONS PAR UN PARTICULIER ---------
  QuizQuestion(
    category: "Code pénal — particuliers",
    question:
        "L’article 225-2 du Code pénal réprime notamment, lorsqu’ils sont fondés sur un critère discriminatoire, les faits consistant :",
    options: [
      "À refuser un bien ou un service, refuser d’embaucher, sanctionner ou licencier une personne, etc.",
      "Uniquement à proférer des insultes sur la voie publique",
      "Uniquement à ne pas saluer un client",
    ],
    answer:
        "À refuser un bien ou un service, refuser d’embaucher, sanctionner ou licencier une personne, etc.",
    explanation:
        "L’article 225-2 vise six situations principales, dont refus de fournir un bien ou un service, refus d’embauche, licenciement, conditions discriminatoires, etc.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Code pénal — particuliers",
    question:
        "Parmi les comportements suivants, lequel peut constituer une discrimination au sens de l’article 225-2 ?",
    options: [
      "Subordonner une offre d’emploi à la religion ou à l’origine de la personne",
      "Refuser une candidature pour absence de diplôme exigé",
      "Limiter un poste à temps partiel pour contraintes de service",
    ],
    answer:
        "Subordonner une offre d’emploi à la religion ou à l’origine de la personne",
    explanation:
        "Subordonner une offre d’emploi à un critère prohibé (religion, origine, etc.) est visé par l’article 225-2.",
    difficulty: "Moyenne",
  ),

  // --------- AUTRES INFRACTIONS & ASSOCIATIONS ---------
  QuizQuestion(
    category: "Autres infractions",
    question:
        "Le port ou l’exhibition d’uniformes ou emblèmes rappelant ceux des responsables de crimes contre l’humanité est :",
    options: [
      "Sanctionné par l’article R. 645-1 du Code pénal",
      "Libre au nom de la liberté d’expression",
      "Uniquement sanctionné en droit du travail",
    ],
    answer: "Sanctionné par l’article R. 645-1 du Code pénal",
    explanation:
        "Cet article interdit le port ou l’exhibition de tels uniformes ou emblèmes.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Autres infractions",
    question: "L’article 226-19 du Code pénal réprime notamment :",
    options: [
      "Le fait de mémoriser des données sensibles révélant notamment les origines raciales, opinions politiques ou religieuses, hors cas prévus par la loi",
      "La simple rédaction de notes de service internes",
      "La conservation de données anonymes",
    ],
    answer:
        "Le fait de mémoriser des données sensibles révélant notamment les origines raciales, opinions politiques ou religieuses, hors cas prévus par la loi",
    explanation:
        "L’article 226-19 interdit la constitution de certains fichiers sensibles en dehors des exceptions légales.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Associations",
    question: "Les associations de lutte contre les discriminations peuvent :",
    options: [
      "Se constituer partie civile pour de nombreuses infractions à caractère discriminatoire",
      "Uniquement accompagner la victime sans pouvoir judiciaire",
      "Agir seulement si la victime est mineure",
    ],
    answer:
        "Se constituer partie civile pour de nombreuses infractions à caractère discriminatoire",
    explanation:
        "Le texte mentionne cette faculté, prévue par plusieurs articles du Code de procédure pénale (2-1, 2-6, 2-8, 2-10, etc.).",
    difficulty: "Moyenne",
  ),

  // --------- LOI SUR LA PRESSE ---------
  QuizQuestion(
    category: "Loi sur la presse",
    question:
        "La diffamation à caractère raciste, antisémite, sexiste ou homophobe est réprimée par :",
    options: [
      "L’article 32 de la loi du 29 juillet 1881",
      "L’article 24 bis du Code pénal",
      "L’article L. 1132-1 du Code du travail",
    ],
    answer: "L’article 32 de la loi du 29 juillet 1881",
    explanation:
        "L’article 32 de la loi sur la presse vise la diffamation à raison de ces critères.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Loi sur la presse",
    question:
        "L’injure à caractère raciste, antisémite, sexiste ou homophobe est punie en principe :",
    options: [
      "D’un an d’emprisonnement et 45 000 € d’amende",
      "Uniquement d’une obligation de présenter des excuses",
      "Uniquement d’une amende de 135 €",
    ],
    answer: "D’un an d’emprisonnement et 45 000 € d’amende",
    explanation:
        "L’article 33 de la loi de 1881 prévoit cette peine, portée à trois ans et 75 000 € si l’auteur est dépositaire de l’autorité publique.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Loi sur la presse",
    question:
        "Les provocations à la discrimination, à la haine ou à la violence à caractère raciste ou homophobe sont visées par :",
    options: [
      "L’article 24 de la loi du 29 juillet 1881",
      "L’article 225-2 du Code pénal",
      "L’article L. 1132-2 du Code du travail",
    ],
    answer: "L’article 24 de la loi du 29 juillet 1881",
    explanation:
        "Cet article vise les provocations à la discrimination, à la haine ou à la violence à l’égard de certains groupes.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Loi sur la presse",
    question:
        "Les infractions prévues par la loi du 29 juillet 1881 doivent en principe être commises :",
    options: [
      "Par voie de presse ou par tout moyen de communication au public",
      "Uniquement en privé et sans témoin",
      "Uniquement dans un cadre familial",
    ],
    answer: "Par voie de presse ou par tout moyen de communication au public",
    explanation:
        "La loi sur la presse s’applique aux écrits, discours publics, affiches, tracts, moyens électroniques, etc.",
    difficulty: "Moyenne",
  ),

  // --------- DROIT DU TRAVAIL — DISCRIMINATION ---------
  QuizQuestion(
    category: "Droit du travail",
    question:
        "La loi du 13 juillet 1983 dite « loi Roudy » est notamment connue pour :",
    options: [
      "Instituer l’égalité professionnelle entre les femmes et les hommes et créer un Conseil supérieur de l’égalité professionnelle",
      "Réformer les régimes de retraite des fonctionnaires",
      "Créer le Défenseur des droits",
    ],
    answer:
        "Instituer l’égalité professionnelle entre les femmes et les hommes et créer un Conseil supérieur de l’égalité professionnelle",
    explanation:
        "La loi Roudy organise l’égalité professionnelle et renforce les moyens d’action en justice.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Droit du travail",
    question:
        "La loi du 16 novembre 2001 en matière de discrimination au travail :",
    options: [
      "Augmente le nombre de critères prohibés et introduit la notion de discrimination indirecte",
      "Supprime toute référence à l’égalité professionnelle",
      "Autorise certaines discriminations salariales non justifiées",
    ],
    answer:
        "Augmente le nombre de critères prohibés et introduit la notion de discrimination indirecte",
    explanation:
        "Cette loi renforce la lutte contre les discriminations, y compris les discriminations indirectes.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Droit du travail",
    question:
        "L’article L. 1132-1 du Code du travail pose le principe selon lequel :",
    options: [
      "Aucune personne ne peut être écartée d’un recrutement ou sanctionnée en raison d’un critère discriminatoire",
      "L’employeur peut choisir librement ses salariés sans aucune règle",
      "Seuls les agents publics sont concernés par l’égalité de traitement",
    ],
    answer:
        "Aucune personne ne peut être écartée d’un recrutement ou sanctionnée en raison d’un critère discriminatoire",
    explanation:
        "Cet article énonce un principe général d’interdiction des discriminations en matière d’emploi.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Droit du travail",
    question: "L’article L. 1132-2 du Code du travail protège le salarié :",
    options: [
      "Qui exerce normalement le droit de grève",
      "Qui refuse un ordre hiérarchique légal",
      "Qui demande une augmentation de salaire",
    ],
    answer: "Qui exerce normalement le droit de grève",
    explanation:
        "Il interdit toute sanction, licenciement ou mesure discriminatoire en raison de l’exercice normal du droit de grève.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Droit du travail",
    question: "L’article L. 1132-3 du Code du travail protège :",
    options: [
      "Les salariés ayant témoigné ou relaté des faits discriminatoires",
      "Uniquement les membres du CHSCT",
      "Uniquement les cadres dirigeants",
    ],
    answer: "Les salariés ayant témoigné ou relaté des faits discriminatoires",
    explanation:
        "Aucune sanction ne peut être prise contre un salarié pour ce motif.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Droit du travail",
    question:
        "L’article L. 1142-1 du Code du travail prohibe les discriminations fondées :",
    options: [
      "Sur le sexe ou la grossesse, notamment en matière d’embauche, de rémunération et de promotion",
      "Uniquement sur le niveau de diplôme",
      "Uniquement sur le lieu de résidence",
    ],
    answer:
        "Sur le sexe ou la grossesse, notamment en matière d’embauche, de rémunération et de promotion",
    explanation:
        "Cet article encadre strictement les différences de traitement liées au sexe ou à la grossesse.",
    difficulty: "Moyenne",
  ),

  // --------- HARCÈLEMENT — PÉNAL & TRAVAIL ---------
  QuizQuestion(
    category: "Harcèlement sexuel",
    question:
        "Selon l’article 222-33 du Code pénal, le harcèlement sexuel consiste notamment à :",
    options: [
      "Imposer de façon répétée des propos ou comportements à connotation sexuelle ou sexiste portant atteinte à la dignité",
      "Critiquer le travail d’un collègue une seule fois",
      "Refuser une invitation à déjeuner",
    ],
    answer:
        "Imposer de façon répétée des propos ou comportements à connotation sexuelle ou sexiste portant atteinte à la dignité",
    explanation:
        "L’article 222-33 vise ces comportements répétés et assimile aussi la pression grave en vue d’obtenir un acte sexuel.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Harcèlement sexuel",
    question: "Le Code du travail (article L. 1153-1) :",
    options: [
      "Interdit le harcèlement sexuel au travail et protège victimes comme témoins",
      "Autorise certaines formes de harcèlement au nom de l’autorité hiérarchique",
      "Ne concerne pas les relations entre collègues",
    ],
    answer:
        "Interdit le harcèlement sexuel au travail et protège victimes comme témoins",
    explanation:
        "Le texte mentionne la protection des salariés victimes ou témoins contre les mesures de rétorsion.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Harcèlement moral",
    question:
        "L’article 222-33-2 du Code pénal définit le harcèlement moral comme des propos ou comportements répétés ayant pour effet :",
    options: [
      "Une dégradation des conditions de travail portant atteinte aux droits, à la dignité ou à la santé de la victime",
      "Une simple remarque isolée sur la tenue vestimentaire",
      "Un changement de service décidé pour nécessités de service",
    ],
    answer:
        "Une dégradation des conditions de travail portant atteinte aux droits, à la dignité ou à la santé de la victime",
    explanation:
        "C’est la définition donnée par le texte, assortie de peines pénales.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Harcèlement moral",
    question:
        "En matière de fonction publique, les articles L. 133-1 et L. 133-2 du Code général de la fonction publique prévoient que :",
    options: [
      "Aucun agent ne doit subir de harcèlement sexuel ou moral, ni être sanctionné pour l’avoir dénoncé",
      "Seuls les contractuels sont protégés",
      "Le harcèlement est toléré s’il vient d’un supérieur",
    ],
    answer:
        "Aucun agent ne doit subir de harcèlement sexuel ou moral, ni être sanctionné pour l’avoir dénoncé",
    explanation:
        "Ces articles reprennent les définitions et protections contre le harcèlement dans la fonction publique.",
    difficulty: "Moyenne",
  ),

  // ================== NIVEAU DIFFICILE ==================
  QuizQuestion(
    category: "Discrimination — éléments constitutifs",
    question:
        "Pour caractériser une discrimination au sens pénal, les enquêteurs doivent notamment établir :",
    options: [
      "Le critère prohibé, le comportement concret et le lien de causalité entre les deux",
      "Uniquement le ressenti subjectif de la victime",
      "Uniquement l’intention politique de l’auteur",
    ],
    answer:
        "Le critère prohibé, le comportement concret et le lien de causalité entre les deux",
    explanation:
        "Le texte précise le rôle des enquêteurs : identifier critère, fait discriminatoire et lien entre les deux.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Discrimination indirecte",
    question:
        "La discrimination indirecte, en droit du travail, correspond à :",
    options: [
      "Une disposition apparemment neutre qui désavantage en pratique un groupe déterminé par un critère prohibé",
      "Une discrimination assumée et revendiquée",
      "Une simple différence de salaire sans lien avec un critère protégé",
    ],
    answer:
        "Une disposition apparemment neutre qui désavantage en pratique un groupe déterminé par un critère prohibé",
    explanation:
        "La loi du 16 novembre 2001 et la loi de 2008 définissent la discrimination indirecte de cette manière.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Charge de la preuve",
    question:
        "En matière de discrimination en droit du travail, la charge de la preuve :",
    options: [
      "Est aménagée : le salarié présente des éléments laissant supposer une discrimination, l’employeur doit prouver le contraire",
      "Repose exclusivement sur le salarié",
      "Repose exclusivement sur l’inspection du travail",
    ],
    answer:
        "Est aménagée : le salarié présente des éléments laissant supposer une discrimination, l’employeur doit prouver le contraire",
    explanation:
        "Les lois Roudy, 2001 et 2008 prévoient un aménagement de la preuve, obligeant l’employeur à justifier par des éléments objectifs.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Loi sur la presse — publicité",
    question:
        "Pour qu’une infraction de presse à caractère discriminatoire soit constituée (diffamation, injure, provocation), il faut notamment :",
    options: [
      "Que les propos soient rendus publics par un moyen de communication au public",
      "Qu’ils demeurent strictement privés et confidentiels",
      "Qu’ils soient adressés uniquement à la victime par lettre personnelle",
    ],
    answer:
        "Que les propos soient rendus publics par un moyen de communication au public",
    explanation:
        "La loi de 1881 suppose une publicité des propos (presse, réunion publique, moyen électronique, etc.).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Rôle opérationnel du policier",
    question:
        "En pratique, pour un fonctionnaire de police, le non-respect du principe de non-discrimination peut entraîner :",
    options: [
      "Des sanctions pénales, civiles et disciplinaires",
      "Uniquement une remarque orale sans suite",
      "Uniquement la nullité de la procédure sans autre conséquence",
    ],
    answer: "Des sanctions pénales, civiles et disciplinaires",
    explanation:
        "Comme pour les atteintes à la liberté individuelle, une discrimination illégale peut entraîner un triple impact pour l’agent.",
    difficulty: "Difficile",
  ),
  // ---------- RÉFLEXE OPÉRATIONNEL ----------
  QuizQuestion(
    category: "Réflexe opérationnel",
    question:
        "Avant toute mesure privative de liberté, le policier devrait notamment se demander :",
    options: [
      "Quel texte fonde ma décision, ai-je respecté toutes les garanties de procédure, la mesure est-elle nécessaire et proportionnée ?",
      "Si la personne lui paraît sympathique ou non",
      "Si la mesure permettra d’augmenter les statistiques du service",
    ],
    answer:
        "Quel texte fonde ma décision, ai-je respecté toutes les garanties de procédure, la mesure est-elle nécessaire et proportionnée ?",
    explanation:
        "Le fascicule conclut sur ces trois questions-clés à se poser systématiquement.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Fondements juridiques",
    question:
        "Quel article de la Déclaration universelle des droits de l’Homme (ONU) protège la vie privée, la famille, le domicile et la correspondance ?",
    options: ["L’article 12", "L’article 3", "L’article 10"],
    answer: "L’article 12",
    explanation:
        "L’article 12 de la Déclaration universelle des droits de l’Homme protège contre les immixtions arbitraires dans la vie privée, la famille, le domicile ou la correspondance.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Fondements juridiques",
    question:
        "Quel article de la Convention européenne des droits de l’Homme consacre le droit au respect de la vie privée et familiale, du domicile et de la correspondance ?",
    options: ["L’article 8", "L’article 6", "L’article 10"],
    answer: "L’article 8",
    explanation:
        "L’article 8 de la CEDH protège le droit au respect de la vie privée et familiale, du domicile et de la correspondance.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Fondements juridiques",
    question:
        "La loi du 17 juillet 1970 a principalement pour objet de renforcer :",
    options: [
      "La protection de la vie privée",
      "La liberté syndicale",
      "La liberté de circulation",
    ],
    answer: "La protection de la vie privée",
    explanation:
        "La loi du 17 juillet 1970 tend à renforcer la garantie des droits individuels, notamment par la protection de la vie privée sur les plans pénal et civil.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Fondements juridiques",
    question:
        "Quel article de la Déclaration des droits de l’Homme et du citoyen est explicitement utilisé par le Conseil constitutionnel pour rattacher le droit au respect de la vie privée ?",
    options: ["L’article 2", "L’article 9", "L’article 16"],
    answer: "L’article 2",
    explanation:
        "Le Conseil constitutionnel rattache le droit au respect de la vie privée à l’article 2 de la Déclaration de 1789, qui garantit les droits naturels de l’homme.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Fondements juridiques",
    question:
        "Le Conseil constitutionnel, dans sa décision du 18 janvier 1995, relie les atteintes les plus graves au droit au respect de la vie privée à :",
    options: [
      "La liberté individuelle",
      "La liberté de réunion",
      "La liberté d’entreprendre",
    ],
    answer: "La liberté individuelle",
    explanation:
        "En 1995, le Conseil constitutionnel indique que la méconnaissance grave du droit à la vie privée peut porter atteinte à la liberté individuelle, compétence du juge judiciaire.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Fondements juridiques",
    question:
        "Le droit au respect de la vie privée bénéficie d’une double protection :",
    options: [
      "Pénale et civile",
      "Fiscale et administrative",
      "Constitutionnelle et douanière",
    ],
    answer: "Pénale et civile",
    explanation:
        "La loi du 17 juillet 1970 organise la protection de la vie privée à la fois sur le plan pénal (infractions) et sur le plan civil (action en responsabilité et mesures d’urgence).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Vie privée - principe",
    question:
        "Les juridictions françaises ont une conception de la vie privée qui est :",
    options: [
      "Très large",
      "Strictement limitée à la vie familiale",
      "Limitée à la vie professionnelle",
    ],
    answer: "Très large",
    explanation:
        "La jurisprudence retient une conception large de la vie privée : vie sentimentale, familiale, santé, patrimoine, convictions, loisirs, image, etc.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Vie privée - principe",
    question:
        "La divulgation de faits relevant de la vie privée est licite uniquement si :",
    options: [
      "La personne concernée y consent ou si les faits sont notoirement connus",
      "L’agent de police l’estime utile",
      "Le public est curieux",
    ],
    answer:
        "La personne concernée y consent ou si les faits sont notoirement connus",
    explanation:
        "Sans consentement ou notoriété publique des faits, la divulgation d’éléments de vie privée est en principe illicite.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Vie privée - principe",
    question:
        "Pour un policier, toute intervention (contrôle, fouille, captation d’images…) doit respecter :",
    options: [
      "Une base légale, la nécessité et la proportionnalité",
      "Seulement la hiérarchie",
      "Seulement les ordres verbaux du parquet",
    ],
    answer: "Une base légale, la nécessité et la proportionnalité",
    explanation:
        "Le texte insiste sur le triptyque base légale / garanties procédurales / nécessité et proportionnalité de l’atteinte à la vie privée.",
    difficulty: "Facile",
  ),

  // ---------- VIDÉOPROTECTION : OBJECTIFS ----------
  QuizQuestion(
    category: "Vidéoprotection",
    question:
        "La vidéoprotection a été initialement autorisée par la loi d’orientation et de programmation relative à la sécurité du :",
    options: ["21 janvier 1995", "10 mars 1981", "1 janvier 2000"],
    answer: "21 janvier 1995",
    explanation:
        "La loi du 21 janvier 1995 a introduit le recours à la vidéoprotection, anciennement appelée vidéosurveillance.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Vidéoprotection",
    question:
        "Les dispositions relatives à la vidéoprotection figurent principalement aux articles :",
    options: [
      "L. 251-1 et suivants du Code de la sécurité intérieure",
      "L. 431-1 et suivants du Code pénal",
      "L. 111-1 et suivants du Code de la route",
    ],
    answer: "L. 251-1 et suivants du Code de la sécurité intérieure",
    explanation:
        "Le titre V du Code de la sécurité intérieure (articles L. 251-1 et suivants) encadre la vidéoprotection.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Vidéoprotection",
    question:
        "Parmi les finalités suivantes, laquelle fait partie des objectifs de la vidéoprotection sur la voie publique ?",
    options: [
      "La prévention des atteintes à la sécurité des personnes et des biens",
      "La surveillance des opinions politiques",
      "Le contrôle du temps de travail des salariés",
    ],
    answer:
        "La prévention des atteintes à la sécurité des personnes et des biens",
    explanation:
        "La vidéoprotection vise notamment la prévention des atteintes à la sécurité des personnes et des biens dans les lieux exposés.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Vidéoprotection",
    question:
        "La vidéoprotection peut être utilisée pour constater les infractions :",
    options: [
      "Aux règles de la circulation routière",
      "Au Code du travail",
      "Au Code de la consommation",
    ],
    answer: "Aux règles de la circulation routière",
    explanation:
        "Parmi ses objectifs, la vidéoprotection permet la constatation des infractions aux règles de la circulation.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Vidéoprotection",
    question:
        "Les opérations de vidéoprotection ne doivent pas permettre de visualiser :",
    options: [
      "L’intérieur des immeubles d’habitation",
      "Les trottoirs ouverts au public",
      "Les façades des bâtiments publics",
    ],
    answer: "L’intérieur des immeubles d’habitation",
    explanation:
        "L’article L. 251-3 du Code de la sécurité intérieure interdit de filmer l’intérieur des immeubles d’habitation et, de façon spécifique, leurs entrées.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Vidéoprotection",
    question:
        "Des systèmes de vidéoprotection peuvent-ils être installés dans des établissements recevant du public (magasins, gares, etc.) ?",
    options: [
      "Oui, pour assurer la sécurité des personnes et des biens",
      "Non, jamais",
      "Uniquement dans les bâtiments publics",
    ],
    answer: "Oui, pour assurer la sécurité des personnes et des biens",
    explanation:
        "Le texte prévoit la possibilité de vidéoprotection dans des lieux ouverts au public particulièrement exposés aux risques d’agression ou de vol.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Vidéoprotection",
    question:
        "Les commerçants peuvent mettre en œuvre un système de vidéoprotection sur la voie publique :",
    options: [
      "Après information du maire et autorisation du préfet",
      "Libre­ment, sans autorisation",
      "Uniquement avec l’accord du procureur",
    ],
    answer: "Après information du maire et autorisation du préfet",
    explanation:
        "Des commerçants peuvent protéger les abords immédiats de leurs installations sous réserve d’une autorisation préfectorale, après information du maire.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Vidéoprotection",
    question:
        "Dans chaque département, la commission compétente en matière de vidéoprotection est :",
    options: [
      "La commission départementale de vidéoprotection",
      "La commission de discipline de la police",
      "La commission des libertés numériques",
    ],
    answer: "La commission départementale de vidéoprotection",
    explanation:
        "Cette commission, présidée par un magistrat honoraire ou une personnalité qualifiée, donne un avis et contrôle les dispositifs de vidéoprotection.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Vidéoprotection",
    question:
        "La durée maximale de conservation des images de vidéoprotection, hors nécessité de procédure pénale, est en principe limitée à :",
    options: ["Un mois", "Six mois", "Un an"],
    answer: "Un mois",
    explanation:
        "L’article L. 252-5 CSI prévoit que les enregistrements ne peuvent être conservés au-delà d’un délai fixé par l’autorisation, sans dépasser un mois, sauf besoin d’une procédure pénale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Vidéoprotection",
    question:
        "Une autorisation de vidéoprotection est en principe délivrée pour une durée de :",
    options: [
      "Cinq ans renouvelable",
      "Un an renouvelable",
      "Dix ans non renouvelable",
    ],
    answer: "Cinq ans renouvelable",
    explanation:
        "Les systèmes de vidéoprotection sont autorisés pour cinq ans renouvelables, sous conditions (article L. 252-4 CSI).",
    difficulty: "Facile",
  ),

  // ---------- PROTECTION PÉNALE DE LA VIE PRIVÉE ----------
  QuizQuestion(
    category: "Protection pénale",
    question: "L’article 226-1 du Code pénal réprime notamment le fait de :",
    options: [
      "Capter des paroles privées sans le consentement de leur auteur",
      "Filmer la voie publique en toutes circonstances",
      "Contrôler un titre d’identité sur la voie publique",
    ],
    answer: "Capter des paroles privées sans le consentement de leur auteur",
    explanation:
        "L’article 226-1 sanctionne la captation, l’enregistrement ou la transmission de paroles prononcées à titre privé ou confidentiel, sans consentement.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Protection pénale",
    question:
        "Filmer, sans son consentement, une personne se trouvant dans un lieu privé constitue :",
    options: [
      "Une atteinte à l’intimité de la vie privée (article 226-1 CP)",
      "Un simple manquement disciplinaire",
      "Une contravention routière",
    ],
    answer: "Une atteinte à l’intimité de la vie privée (article 226-1 CP)",
    explanation:
        "La fixation de l’image d’une personne dans un lieu privé sans son accord est incriminée par l’article 226-1 du Code pénal.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Protection pénale",
    question: "L’article 226-2 du Code pénal concerne principalement :",
    options: [
      "La conservation ou diffusion d’enregistrements obtenus illicitement",
      "Les contrôles d’identité sur réquisition",
      "Les visites domiciliaires en enquête de flagrance",
    ],
    answer:
        "La conservation ou diffusion d’enregistrements obtenus illicitement",
    explanation:
        "L’article 226-2 incrimine la conservation, l’utilisation ou la diffusion d’un enregistrement réalisé en violation de l’article 226-1.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Protection pénale",
    question:
        "La diffusion, sans accord, de vidéos intimes à caractère sexuel d’une personne est appelée :",
    options: [
      "Pornodivulgation (revenge porn)",
      "Phishing",
      "Usurpation d’identité",
    ],
    answer: "Pornodivulgation (revenge porn)",
    explanation:
        "L’article 226-2-1 du Code pénal réprime cette pratique, souvent appelée pornodivulgation ou revenge porn.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Protection pénale",
    question:
        "L’article 226-3-1 du Code pénal réprime le fait d’apercevoir les parties intimes d’une personne à son insu. Il s’agit de :",
    options: ["Voyeurisme", "Vol simple", "Usure"],
    answer: "Voyeurisme",
    explanation:
        "Le texte vise le voyeurisme, défini comme le fait d’user de tout moyen pour apercevoir les parties intimes d’une personne sans son consentement.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Protection pénale",
    question: "L’article 226-8 du Code pénal vise notamment :",
    options: [
      "Les montages ou contenus générés artificiellement avec l’image ou la voix d’une personne sans mention apparente",
      "Uniquement les tags et graffitis",
      "Les infractions de conduite en état alcoolique",
    ],
    answer:
        "Les montages ou contenus générés artificiellement avec l’image ou la voix d’une personne sans mention apparente",
    explanation:
        "L’article 226-8 sanctionne les montages et hypertrucages (deepfakes) diffusés sans que leur caractère artificiel soit clairement indiqué.",
    difficulty: "Facile",
  ),

  // ---------- CAMÉRAS PIÉTONS ----------
  QuizQuestion(
    category: "Caméras piétons",
    question:
        "L’article L. 241-1 du Code de la sécurité intérieure autorise l’usage de caméras individuelles par :",
    options: [
      "Les agents de la police nationale et les militaires de la gendarmerie nationale",
      "Tous les agents privés de sécurité sans condition",
      "Uniquement les maires",
    ],
    answer:
        "Les agents de la police nationale et les militaires de la gendarmerie nationale",
    explanation:
        "Les caméras piétons sont prévues pour les forces de sécurité étatiques dans leurs missions de prévention et de police.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Caméras piétons",
    question:
        "Les enregistrements des caméras piétons peuvent être mis en œuvre :",
    options: [
      "En tous lieux, y compris privés, sous conditions légales",
      "Uniquement en commissariat",
      "Uniquement à l’étranger",
    ],
    answer: "En tous lieux, y compris privés, sous conditions légales",
    explanation:
        "Les caméras individuelles peuvent être utilisées en tous lieux, y compris dans des lieux privés, pour les finalités prévues par la loi (prévention incidents, constat des infractions, etc.).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Caméras piétons",
    question:
        "Parmi les finalités suivantes, laquelle est expressément visée pour les caméras piétons ?",
    options: [
      "Prévention des incidents au cours des interventions",
      "Contrôle de la productivité des agents",
      "Surveillance des opinions politiques",
    ],
    answer: "Prévention des incidents au cours des interventions",
    explanation:
        "Les caméras individuelles visent notamment la prévention des incidents, le constat des infractions et la formation des agents.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Caméras piétons",
    question: "Les caméras piétons doivent en principe être :",
    options: [
      "Portées de manière apparente, avec signal d’enregistrement",
      "Cachées dans les vêtements",
      "Fixées dans le véhicule uniquement",
    ],
    answer: "Portées de manière apparente, avec signal d’enregistrement",
    explanation:
        "La loi impose un port apparent et un signal indiquant l’enregistrement, sauf circonstances particulières empêchant l’information des personnes.",
    difficulty: "Facile",
  ),

  // ---------- PROTECTION CIVILE ----------
  QuizQuestion(
    category: "Protection civile",
    question:
        "L’article 1240 du Code civil (ancien 1382) permet à une victime d’atteinte à la vie privée d’agir :",
    options: [
      "En responsabilité civile pour obtenir réparation",
      "Uniquement en responsabilité pénale",
      "Uniquement devant le juge administratif",
    ],
    answer: "En responsabilité civile pour obtenir réparation",
    explanation:
        "L’article 1240 permet d’engager la responsabilité civile de l’auteur d’un dommage, y compris en cas d’atteinte à la vie privée.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Protection civile",
    question: "L’article 9, alinéa 2, du Code civil permet au juge :",
    options: [
      "De prescrire en urgence toutes mesures propres à faire cesser une atteinte à la vie privée",
      "De prononcer uniquement une peine de prison",
      "De retirer la nationalité",
    ],
    answer:
        "De prescrire en urgence toutes mesures propres à faire cesser une atteinte à la vie privée",
    explanation:
        "Cet alinéa permet des mesures comme le séquestre, la saisie ou d’autres mesures en référé pour faire cesser l’atteinte.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Protection civile",
    question: "Le droit au respect de la vie privée s’étend :",
    options: [
      "Au-delà de la mort, notamment au respect de la dépouille mortelle",
      "Uniquement jusqu’au décès",
      "Uniquement aux mineurs",
    ],
    answer: "Au-delà de la mort, notamment au respect de la dépouille mortelle",
    explanation:
        "La jurisprudence protège l’image et la mémoire des personnes décédées, au bénéfice des proches.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Protection civile",
    question:
        "En cas d’urgence, le juge compétent pour ordonner des mesures de remise en état en matière d’atteinte à la vie privée est :",
    options: [
      "Le juge des référés",
      "Le juge de l’application des peines",
      "Le juge des libertés et de la détention en toutes matières",
    ],
    answer: "Le juge des référés",
    explanation:
        "L’article 835 du Code de procédure civile fait du juge des référés le juge de droit commun des troubles manifestement illicites, dont les atteintes à la vie privée.",
    difficulty: "Facile",
  ),

  // ---------- SECRET DES CORRESPONDANCES ----------
  QuizQuestion(
    category: "Secret des correspondances",
    question: "Le secret des correspondances protège en principe :",
    options: [
      "Les échanges de pensées et de sentiments par tout moyen de communication",
      "Uniquement les lettres papier",
      "Uniquement les communications téléphoniques filaires",
    ],
    answer:
        "Les échanges de pensées et de sentiments par tout moyen de communication",
    explanation:
        "Le texte vise les lettres, courriels, appels, messages électroniques, etc.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances",
    question: "L’article 226-15 du Code pénal incrimine notamment :",
    options: [
      "L’ouverture ou le détournement de correspondances adressées à des tiers",
      "Le défaut d’assurance d’un véhicule",
      "La rébellion",
    ],
    answer:
        "L’ouverture ou le détournement de correspondances adressées à des tiers",
    explanation:
        "L’article 226-15 réprime l’atteinte au secret des correspondances commise par des particuliers.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances",
    question:
        "L’article 432-9 du Code pénal concerne l’atteinte au secret des correspondances commise par :",
    options: [
      "Une personne dépositaire de l’autorité publique",
      "Un salarié du secteur privé",
      "Toute personne morale",
    ],
    answer: "Une personne dépositaire de l’autorité publique",
    explanation:
        "L’article 432-9 vise les atteintes commises par des fonctionnaires ou personnes chargées d’une mission de service public.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Secret des correspondances",
    question: "Le secret des correspondances peut être légalement limité :",
    options: [
      "Par des mesures prévues par la loi pour des motifs d’ordre public",
      "Par simple décision orale d’un agent de police",
      "Uniquement par la volonté du destinataire",
    ],
    answer: "Par des mesures prévues par la loi pour des motifs d’ordre public",
    explanation:
        "Les exceptions (interceptions judiciaires, de sécurité, contrôles en prison, etc.) sont strictement encadrées par la loi.",
    difficulty: "Facile",
  ),

  // ---------- NOTION DE DOMICILE ----------
  QuizQuestion(
    category: "Domicile - notion",
    question:
        "Selon la Cour de cassation, le domicile est le lieu où une personne :",
    options: [
      "A le droit de se dire chez elle",
      "Travaille habituellement",
      "Est seulement propriétaire",
    ],
    answer: "A le droit de se dire chez elle",
    explanation:
        "La définition jurisprudentielle vise le lieu où la personne a le droit de se dire chez elle, quel que soit le titre juridique et l’affectation des locaux.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Domicile - notion",
    question:
        "Parmi les lieux suivants, lequel est généralement considéré comme un domicile au sens pénal ?",
    options: [
      "La chambre d’hôtel occupée",
      "La cour non close d’un immeuble",
      "Le bloc opératoire",
    ],
    answer: "La chambre d’hôtel occupée",
    explanation:
        "La chambre d’hôtel constitue un domicile pendant la période d’occupation, à la différence de la cour non close ou du bloc opératoire.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Domicile - notion",
    question:
        "Un véhicule aménagé pour l’habitation et servant effectivement de résidence est :",
    options: [
      "Assimilé à un domicile",
      "Toujours un simple bien meuble sans protection particulière",
      "Un lieu public",
    ],
    answer: "Assimilé à un domicile",
    explanation:
        "Le véhicule aménagé pour l’habitation peut être considéré comme domicile pour la protection pénale du domicile.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Domicile - notion",
    question:
        "Parmi les lieux suivants, lequel n’est en principe pas considéré comme un domicile ?",
    options: [
      "Un logement vide de meubles entre deux locations",
      "Une maison de campagne habitée périodiquement",
      "Une péniche habitable",
    ],
    answer: "Un logement vide de meubles entre deux locations",
    explanation:
        "Le logement vide entre deux locations n’est pas un domicile puisqu’il n’abrite plus l’intimité d’une personne.",
    difficulty: "Facile",
  ),

  // ---------- VIOLATION DE DOMICILE ----------
  QuizQuestion(
    category: "Violation de domicile",
    question:
        "L’article 226-4 du Code pénal réprime la violation de domicile commise par :",
    options: [
      "Un particulier",
      "Uniquement un fonctionnaire",
      "Uniquement un militaire",
    ],
    answer: "Un particulier",
    explanation:
        "L’article 226-4 vise l’introduction ou le maintien dans le domicile d’autrui par manœuvres, menaces, voies de fait ou contrainte, hors les cas prévus par la loi.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Violation de domicile",
    question:
        "L’article 432-8 du Code pénal réprime la violation de domicile commise par :",
    options: [
      "Une personne dépositaire de l’autorité publique",
      "Un mineur",
      "Une personne morale",
    ],
    answer: "Une personne dépositaire de l’autorité publique",
    explanation:
        "L’article 432-8 vise les fonctionnaires ou personnes chargées d’une mission de service public qui s’introduisent illégalement dans un domicile.",
    difficulty: "Facile",
  ),

  // ---------- FOUILLE DES VÉHICULES (PRINCIPES) ----------
  QuizQuestion(
    category: "Fouille des véhicules",
    question: "En principe, un véhicule non aménagé pour l’habitation est :",
    options: [
      "Un lieu distinct du domicile mais protégé par des règles spécifiques",
      "Toujours assimilé à un domicile",
      "Un lieu totalement libre d’accès sans cadre légal",
    ],
    answer:
        "Un lieu distinct du domicile mais protégé par des règles spécifiques",
    explanation:
        "La fouille d’un véhicule n’est pas une perquisition domiciliaire mais porte atteinte à la vie privée et doit respecter le Code de procédure pénale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Fouille des véhicules",
    question:
        "Les visites de véhicules sur réquisitions écrites du procureur de la République sont encadrées par :",
    options: [
      "L’article 78-2-2 du Code de procédure pénale",
      "L’article 100 du Code de procédure pénale",
      "L’article 226-1 du Code pénal",
    ],
    answer: "L’article 78-2-2 du Code de procédure pénale",
    explanation:
        "L’article 78-2-2 CPP encadre les visites de véhicules, inspections de bagages et visites de navires sur réquisitions.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Fouille des véhicules",
    question:
        "Lorsqu’un véhicule est spécialement aménagé pour l’habitation et utilisé comme résidence, sa visite doit respecter :",
    options: [
      "Les règles applicables aux perquisitions domiciliaires",
      "Aucune garantie particulière",
      "Uniquement l’accord du maire",
    ],
    answer: "Les règles applicables aux perquisitions domiciliaires",
    explanation:
        "Ces véhicules sont assimilés à un domicile et bénéficient des protections afférentes.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU MOYENNE =====================
  // ---------- VIDÉOPROTECTION : AUTORISATION & CONTRÔLE ----------
  QuizQuestion(
    category: "Vidéoprotection",
    question:
        "Qui délivre l’autorisation d’installation d’un système de vidéoprotection sur la voie publique (hors défense nationale) ?",
    options: [
      "Le représentant de l’État dans le département ou, à Paris, le préfet de police",
      "Le maire seul",
      "Le président du tribunal judiciaire",
    ],
    answer:
        "Le représentant de l’État dans le département ou, à Paris, le préfet de police",
    explanation:
        "L’article L. 252-1 CSI confie cette compétence au préfet (ou préfet de police à Paris), après avis de la commission départementale.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Vidéoprotection",
    question:
        "En cas d’urgence liée à un risque d’actes de terrorisme, le préfet peut :",
    options: [
      "Délivrer une autorisation provisoire de vidéoprotection pour une durée maximale de quatre mois",
      "Installer des caméras sans aucune autorisation",
      "Ne jamais déroger aux délais ordinaires",
    ],
    answer:
        "Délivrer une autorisation provisoire de vidéoprotection pour une durée maximale de quatre mois",
    explanation:
        "L’article L. 252-6 CSI permet une autorisation provisoire sans avis préalable de la commission, pour quatre mois au maximum.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Vidéoprotection",
    question:
        "Les membres de la commission départementale de vidéoprotection peuvent accéder aux lieux équipés de caméras :",
    options: [
      "De 6 heures à 21 heures, hors parties affectées au domicile privé",
      "À toute heure, y compris dans les chambres privées",
      "Uniquement sur autorisation du propriétaire",
    ],
    answer: "De 6 heures à 21 heures, hors parties affectées au domicile privé",
    explanation:
        "L’article L. 253-3 CSI encadre cet accès, avec information du procureur et garanties pour les locaux privés professionnels.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Vidéoprotection",
    question:
        "Le refus d’un responsable de locaux privés de laisser entrer la commission départementale de vidéoprotection :",
    options: [
      "Peut conduire à une visite autorisée par le juge des libertés et de la détention",
      "N’a aucune conséquence",
      "Autorise immédiatement la commission à pénétrer en force",
    ],
    answer:
        "Peut conduire à une visite autorisée par le juge des libertés et de la détention",
    explanation:
        "En cas d’opposition, la visite ne peut avoir lieu qu’après autorisation du juge des libertés et de la détention (article L. 253-3 CSI).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Vidéoprotection",
    question:
        "Le fait d’entraver l’action de la commission départementale de vidéoprotection est puni de :",
    options: [
      "Un an d’emprisonnement et quinze mille euros d’amende",
      "Une simple amende administrative",
      "Cinq ans d’emprisonnement systématiques",
    ],
    answer: "Un an d’emprisonnement et quinze mille euros d’amende",
    explanation:
        "L’article L. 254-1 CSI prévoit cette sanction pénale en cas d’entrave à la commission.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Vidéoprotection",
    question:
        "Le préfet peut ordonner la fermeture d’un établissement ouvert au public équipé d’un système de vidéoprotection sans autorisation pour :",
    options: [
      "Une durée de trois mois renouvelable en cas de refus de régularisation",
      "Une durée indéterminée sans recours",
      "Uniquement vingt-quatre heures",
    ],
    answer:
        "Une durée de trois mois renouvelable en cas de refus de régularisation",
    explanation:
        "L’article L. 253-4 CSI prévoit une fermeture de trois mois, renouvelable si le système n’est pas régularisé.",
    difficulty: "Moyenne",
  ),

  // ---------- CAMÉRAS PIÉTONS : PRÉCISIONS ----------
  QuizQuestion(
    category: "Caméras piétons",
    question:
        "Les agents peuvent accéder aux enregistrements des caméras piétons :",
    options: [
      "Seulement si cette consultation est nécessaire à la poursuite d’infractions ou à l’établissement des faits",
      "Libre­ment, par curiosité",
      "Uniquement après autorisation du maire",
    ],
    answer:
        "Seulement si cette consultation est nécessaire à la poursuite d’infractions ou à l’établissement des faits",
    explanation:
        "Les agents ne peuvent consulter les images que pour des finalités strictes (recherche d’auteurs, prévention, comptes rendus fidèles).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Caméras piétons",
    question:
        "Les personnes filmées par une caméra piéton doivent, en principe :",
    options: [
      "Être informées de l’enregistrement, sauf circonstances particulières",
      "Signer un formulaire écrit",
      "Donner un accord écrit préalable",
    ],
    answer:
        "Être informées de l’enregistrement, sauf circonstances particulières",
    explanation:
        "Le texte insiste sur l’information des personnes, sauf impossibilité liée aux circonstances de l’intervention.",
    difficulty: "Moyenne",
  ),

  // ---------- PROTECTION PÉNALE : DÉTAILS ----------
  QuizQuestion(
    category: "Protection pénale",
    question:
        "Pour qu’il y ait atteinte à l’intimité de la vie privée par captation de paroles (article 226-1 CP), il faut que les paroles soient :",
    options: [
      "Prononcées à titre privé ou confidentiel",
      "Prononcées en réunion publique",
      "Diffusées déjà sur internet",
    ],
    answer: "Prononcées à titre privé ou confidentiel",
    explanation:
        "L’incrimination vise les paroles prononcées dans un cadre privé ou confidentiel, non destinées au public.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Protection pénale",
    question:
        "L’infraction de conservation ou de diffusion d’un enregistrement illicite (article 226-2 CP) est :",
    options: [
      "Une infraction de conséquence liée à l’atteinte initiale (article 226-1)",
      "Une contravention routière",
      "Une infraction purement administrative",
    ],
    answer:
        "Une infraction de conséquence liée à l’atteinte initiale (article 226-1)",
    explanation:
        "L’article 226-2 sanctionne l’exploitation d’un enregistrement obtenu en violation de l’article 226-1.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Protection pénale",
    question:
        "Le voyeurisme réprimé par l’article 226-3-1 CP suppose notamment que :",
    options: [
      "La personne cache ses parties intimes et ignore la présence de l’auteur",
      "La personne pose volontairement pour la caméra",
      "L’auteur se trouve obligatoirement dans un lieu public",
    ],
    answer:
        "La personne cache ses parties intimes et ignore la présence de l’auteur",
    explanation:
        "Le texte vise le fait d’apercevoir les parties intimes cachées à la vue des tiers, à l’insu ou sans le consentement de la personne.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Protection pénale",
    question:
        "Les hypertrucages (deepfakes) représentant une personne sans indication claire de leur caractère artificiel peuvent être poursuivis sur le fondement de :",
    options: [
      "L’article 226-8 du Code pénal",
      "L’article 226-1 du Code pénal",
      "L’article 226-15 du Code pénal",
    ],
    answer: "L’article 226-8 du Code pénal",
    explanation:
        "Cet article sanctionne les montages ou contenus générés par traitement algorithmique sans mention claire de leur caractère artificiel.",
    difficulty: "Moyenne",
  ),

  // ---------- SECRET DES CORRESPONDANCES : DÉTAILS ----------
  QuizQuestion(
    category: "Secret des correspondances",
    question:
        "L’atteinte au secret des correspondances (article 226-15 CP) réprime notamment :",
    options: [
      "L’interception ou le détournement de messages électroniques",
      "Les refus de répondre à la presse",
      "La simple lecture de journaux publics",
    ],
    answer: "L’interception ou le détournement de messages électroniques",
    explanation:
        "L’article 226-15 vise aussi les correspondances émises, transmises ou reçues par voie électronique.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Secret des correspondances",
    question:
        "L’article 432-9 CP aggrave l’atteinte au secret des correspondances lorsque l’auteur est :",
    options: [
      "Dépositaire de l’autorité publique ou chargé d’une mission de service public",
      "Mineur de moins de seize ans",
      "Simple particulier sans fonction",
    ],
    answer:
        "Dépositaire de l’autorité publique ou chargé d’une mission de service public",
    explanation:
        "La peine est renforcée lorsque l’atteinte est commise par un fonctionnaire ou assimilé, hors les cas prévus par la loi.",
    difficulty: "Moyenne",
  ),

  // ---------- INTERCEPTIONS JUDICIAIRES ----------
  QuizQuestion(
    category: "Interceptions judiciaires",
    question:
        "Les interceptions de correspondances émises par la voie des télécommunications en droit commun sont encadrées par les articles :",
    options: [
      "100 à 100-8 du Code de procédure pénale",
      "78-2 à 78-2-4 du Code de procédure pénale",
      "226-1 à 226-3 du Code pénal",
    ],
    answer: "100 à 100-8 du Code de procédure pénale",
    explanation:
        "Les articles 100 et suivants CPP encadrent les interceptions ordonnées par le juge d’instruction.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Interceptions judiciaires",
    question:
        "Pour ordonner une interception téléphonique en droit commun, il faut notamment que :",
    options: [
      "L’infraction soit punie d’au moins trois ans d’emprisonnement",
      "Il s’agisse d’une simple contravention",
      "La victime ait toujours donné son accord",
    ],
    answer: "L’infraction soit punie d’au moins trois ans d’emprisonnement",
    explanation:
        "Les interceptions ne sont possibles que pour des infractions d’une certaine gravité (peine minimale de trois ans).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Interceptions judiciaires",
    question:
        "Les interceptions judiciaires décidées par le juge d’instruction sont autorisées pour une durée maximale de :",
    options: [
      "Quatre mois renouvelables",
      "Un mois non renouvelable",
      "Deux ans renouvelables",
    ],
    answer: "Quatre mois renouvelables",
    explanation:
        "La décision doit être écrite et motivée, valable quatre mois, renouvelable dans les mêmes conditions.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Interceptions judiciaires",
    question:
        "Lorsqu’une interception vise le cabinet ou le domicile d’un avocat, il faut :",
    options: [
      "Informer le bâtonnier",
      "Informer le maire",
      "Informer le préfet",
    ],
    answer: "Informer le bâtonnier",
    explanation:
        "Le Code de procédure pénale prévoit des garanties spécifiques pour les avocats (information du bâtonnier).",
    difficulty: "Moyenne",
  ),

  // ---------- INTERCEPTIONS CRIMINALITÉ ORGANISÉE ----------
  QuizQuestion(
    category: "Criminalité organisée",
    question:
        "L’article 706-95 CPP permet, pour la criminalité organisée, d’autoriser des interceptions de correspondances :",
    options: [
      "En enquête de flagrance ou préliminaire, sur décision du juge des libertés et de la détention",
      "Uniquement en fin de procès",
      "Uniquement sur décision du maire",
    ],
    answer:
        "En enquête de flagrance ou préliminaire, sur décision du juge des libertés et de la détention",
    explanation:
        "Le JLD peut autoriser interceptions, enregistrements et transcriptions pour certaines infractions graves.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Criminalité organisée",
    question: "L’article 706-95-1 CPP permet notamment :",
    options: [
      "L’accès à distance aux correspondances stockées par voie électronique",
      "La fouille sans limite des domiciles",
      "La garde à vue sans avocat",
    ],
    answer:
        "L’accès à distance aux correspondances stockées par voie électronique",
    explanation:
        "Ce texte autorise l’accès, à l’insu de la personne, aux données stockées, avec saisie ou copie.",
    difficulty: "Moyenne",
  ),

  // ---------- DOMICILE : INTRODUCTIONS HORS HEURES LÉGALES ----------
  QuizQuestion(
    category: "Domicile - interventions",
    question:
        "Les heures légales pour les perquisitions domiciliaires sont en principe fixées entre :",
    options: [
      "6 heures et 21 heures",
      "8 heures et 18 heures",
      "0 heure et 24 heures",
    ],
    answer: "6 heures et 21 heures",
    explanation:
        "L’article 59 CPP fixe les heures légales pour les perquisitions, sauf exceptions prévues par la loi.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Domicile - interventions",
    question:
        "Une introduction dans un domicile est possible même en dehors des heures légales notamment :",
    options: [
      "En cas de réclamation provenant de l’intérieur de la maison",
      "Pour un simple contrôle de titre de transport",
      "Pour vérifier l’état d’entretien du logement",
    ],
    answer: "En cas de réclamation provenant de l’intérieur de la maison",
    explanation:
        "L’appel au secours, les cris ou hurlements justifient l’entrée, même si l’alerte se révèle ensuite infondée.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Domicile - interventions",
    question:
        "L’obligation de porter assistance à personne en péril (article 223-6 CP) peut :",
    options: [
      "Justifier l’introduction dans un domicile pour secourir une personne en danger",
      "Interdire toute intervention de police",
      "Se limiter aux lieux publics",
    ],
    answer:
        "Justifier l’introduction dans un domicile pour secourir une personne en danger",
    explanation:
        "Des indices graves de danger (odeur, absence anormale, etc.) justifient l’entrée pour porter secours.",
    difficulty: "Moyenne",
  ),

  // ---------- FOUILLE DE VÉHICULES : RÉQUISITIONS ----------
  QuizQuestion(
    category: "Fouille des véhicules",
    question:
        "Sur réquisitions écrites du procureur (article 78-2-2 CPP), la durée maximale des opérations (visites de véhicules, inspections de bagages) est en principe de :",
    options: [
      "Vingt-quatre heures, renouvelable une fois",
      "Douze heures, non renouvelable",
      "Quarante-huit heures, sans limitation",
    ],
    answer: "Vingt-quatre heures, renouvelable une fois",
    explanation:
        "La durée est de vingt-quatre heures maximum, renouvelable une fois par décision motivée.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Fouille des véhicules",
    question:
        "Lorsqu’un véhicule est en circulation, la visite sur réquisitions (78-2-2 CPP) :",
    options: [
      "Ne peut durer que le temps strictement nécessaire, en présence du conducteur",
      "Peut durer plusieurs heures sans limite",
      "Peut se faire sans le conducteur et sans témoin",
    ],
    answer:
        "Ne peut durer que le temps strictement nécessaire, en présence du conducteur",
    explanation:
        "Le texte impose la présence du conducteur et la durée strictement nécessaire aux opérations.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Fouille des véhicules",
    question:
        "En cas de visite d’un véhicule à l’arrêt (78-2-2 CPP), si le conducteur ou le propriétaire est absent :",
    options: [
      "Un tiers non placé sous l’autorité de la police doit être requis, sauf risque grave",
      "La visite est interdite",
      "La police peut inventer un témoin fictif",
    ],
    answer:
        "Un tiers non placé sous l’autorité de la police doit être requis, sauf risque grave",
    explanation:
        "La loi impose, sauf risque grave, la présence d’une personne extérieure à l’autorité de l’OPJ/APJ.",
    difficulty: "Moyenne",
  ),

  // ---------- FOUILLE DE VÉHICULES : FLAGRANCE & SÉCURITÉ ----------
  QuizQuestion(
    category: "Fouille des véhicules",
    question: "L’article 78-2-3 CPP autorise la visite de véhicules :",
    options: [
      "En cas de crime ou délit flagrant, sur suspicion à l’égard du conducteur ou d’un passager",
      "Uniquement pour des contraventions",
      "Uniquement sur ordre écrit du maire",
    ],
    answer:
        "En cas de crime ou délit flagrant, sur suspicion à l’égard du conducteur ou d’un passager",
    explanation:
        "La visite peut être effectuée lorsque des raisons plausibles de soupçonner un crime ou délit flagrant existent.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Fouille des véhicules",
    question:
        "L’article 78-2-4 CPP permet la visite de véhicules et la fouille de bagages :",
    options: [
      "Pour prévenir une atteinte grave à la sécurité des personnes et des biens",
      "Uniquement en matière fiscale",
      "Uniquement pour contrôler les vignettes d’assurance",
    ],
    answer:
        "Pour prévenir une atteinte grave à la sécurité des personnes et des biens",
    explanation:
        "Le texte vise la prévention des atteintes graves, avec possibilité d’immobiliser le véhicule trente minutes maximum.",
    difficulty: "Moyenne",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  // ---------- EXCEPTIONS, RENSEIGNEMENT, GARANTIES ----------
  QuizQuestion(
    category: "Renseignement",
    question:
        "La loi du vingt-quatre juillet deux mille quinze relative au renseignement a instauré :",
    options: [
      "Un régime d’autorisation administrative des techniques de recueil de renseignement",
      "La suppression du secret des correspondances",
      "La possibilité pour tout agent de police d’intercepter librement les communications",
    ],
    answer:
        "Un régime d’autorisation administrative des techniques de recueil de renseignement",
    explanation:
        "Cette loi encadre les interceptions de sécurité et les accès aux données de connexion par un régime d’autorisation du Premier ministre.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Renseignement",
    question:
        "L’autorisation d’une interception de sécurité au profit des services de renseignement est délivrée :",
    options: [
      "Par le Premier ministre, par une décision écrite et motivée",
      "Par le maire de la commune concernée",
      "Par le directeur départemental de la sécurité publique",
    ],
    answer: "Par le Premier ministre, par une décision écrite et motivée",
    explanation:
        "Les articles L. 821-2 et L. 821-4 CSI prévoient une décision écrite et motivée du Premier ministre pour une durée limitée.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Renseignement",
    question:
        "La Commission nationale de contrôle des techniques de renseignement (CNCTR) a pour mission principale de :",
    options: [
      "Vérifier la conformité des techniques de renseignement au Code de la sécurité intérieure",
      "Prononcer les peines d’emprisonnement",
      "Nommer les directeurs de police",
    ],
    answer:
        "Vérifier la conformité des techniques de renseignement au Code de la sécurité intérieure",
    explanation:
        "La CNCTR est une autorité administrative indépendante chargée du contrôle des techniques mises en œuvre.",
    difficulty: "Difficile",
  ),

  // ---------- DOMICILE & LIEUX PROTÉGÉS ----------
  QuizQuestion(
    category: "Domicile - lieux protégés",
    question: "Les locaux diplomatiques sont protégés car :",
    options: [
      "Ils sont inviolables sauf consentement du chef de mission",
      "Ils relèvent du domaine privé du préfet",
      "Ils dépendent des règles du Code de la route",
    ],
    answer: "Ils sont inviolables sauf consentement du chef de mission",
    explanation:
        "La convention de Vienne prévoit l’inviolabilité des locaux diplomatiques, les forces de l’ordre ne pouvant y pénétrer sans accord.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Domicile - lieux protégés",
    question: "Les bâtiments de l’Assemblée nationale et du Sénat :",
    options: [
      "Ne peuvent être investis par les forces de l’ordre qu’à la demande du président de l’assemblée concernée",
      "Sont des lieux publics libres d’accès",
      "Peuvent être perquisitionnés à tout moment par un simple OPJ",
    ],
    answer:
        "Ne peuvent être investis par les forces de l’ordre qu’à la demande du président de l’assemblée concernée",
    explanation:
        "Ces bâtiments bénéficient d’une protection particulière, l’intervention des forces de l’ordre nécessitant une réquisition spécifique.",
    difficulty: "Difficile",
  ),

  // ---------- ENQUÊTE PRÉLIMINAIRE & CONSENTEMENT ----------
  QuizQuestion(
    category: "Enquête préliminaire",
    question:
        "En enquête préliminaire, la fouille d’un véhicule non assimilé à un domicile :",
    options: [
      "Ne peut être faite sous contrainte qu’avec l’assentiment du propriétaire ou du conducteur",
      "Peut être réalisée sans limite par simple initiative de l’OPJ",
      "Ne nécessite jamais de procès-verbal",
    ],
    answer:
        "Ne peut être faite sous contrainte qu’avec l’assentiment du propriétaire ou du conducteur",
    explanation:
        "La jurisprudence exige un consentement consigné, faute de quoi la fouille peut être assimilée à une perquisition irrégulière.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Enquête préliminaire",
    question:
        "Lorsque la fouille d’un véhicule en enquête préliminaire est assimilée à une perquisition, l’absence de consentement régulier :",
    options: [
      "Peut entraîner la nullité de l’acte si la personne justifie d’un grief",
      "Est sans conséquence",
      "Est compensée par une simple note de service",
    ],
    answer:
        "Peut entraîner la nullité de l’acte si la personne justifie d’un grief",
    explanation:
        "La méconnaissance de l’article 76 CPP peut entraîner la nullité de la fouille, si la personne prouve un préjudice.",
    difficulty: "Difficile",
  ),

  // ---------- MANIFESTATIONS & VÉHICULES (78-2-5) ----------
  QuizQuestion(
    category: "Manifestations",
    question:
        "L’article 78-2-5 CPP autorise, sur réquisitions du procureur, lors d’une manifestation sur la voie publique :",
    options: [
      "La fouille de bagages et la visite de véhicules pour rechercher des personnes porteuses d’armes",
      "Les contrôles d’identité systématiques des manifestants",
      "La perquisition des domiciles des participants",
    ],
    answer:
        "La fouille de bagages et la visite de véhicules pour rechercher des personnes porteuses d’armes",
    explanation:
        "Le texte exclut les contrôles d’identité du dispositif et cible la recherche de porteurs d’armes.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Manifestations",
    question:
        "Dans le cadre de l’article 78-2-5 CPP, les contrôles d’identité :",
    options: [
      "Sont exclus du dispositif spécifique",
      "Sont la principale mesure prévue",
      "Sont obligatoires pour tous les manifestants",
    ],
    answer: "Sont exclus du dispositif spécifique",
    explanation:
        "Le texte précise que seuls sont autorisés l’inspection ou la fouille des bagages et la visite des véhicules.",
    difficulty: "Difficile",
  ),

  // ---------- VIE PRIVÉE & POLICE : RÉFLEXE OPÉRATIONNEL ----------
  QuizQuestion(
    category: "Réflexe policier",
    question:
        "Avant toute mesure susceptible d’atteindre la vie privée (domicile, véhicule, correspondances, images), le policier devrait se demander en priorité :",
    options: [
      "Quel texte fonde concrètement mon action, et est-elle nécessaire et proportionnée ?",
      "Si la mesure permettra de gagner du temps",
      "Si la mesure plaira aux médias",
    ],
    answer:
        "Quel texte fonde concrètement mon action, et est-elle nécessaire et proportionnée ?",
    explanation:
        "Le fascicule insiste sur trois questions : base légale, respect des garanties procédurales, nécessité/proportionnalité.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Réflexe policier",
    question:
        "Si un agent a un doute sur la légalité d’une mesure portant atteinte à la vie privée, il devrait :",
    options: [
      "Réévaluer la décision, saisir la hiérarchie ou le parquet",
      "Ignorer le doute et agir immédiatement",
      "Demander conseil à la personne contrôlée",
    ],
    answer: "Réévaluer la décision, saisir la hiérarchie ou le parquet",
    explanation:
        "Le texte recommande de réévaluer ou d’escalader la décision en cas d’incertitude sur la base légale ou la proportionnalité.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "CNIL - principes",
    question:
        "Selon l’article 1 de la loi Informatique et Libertés, l’informatique doit être :",
    options: [
      "Au service de chaque citoyen",
      "Au service exclusif de l’État",
      "Au service des grandes entreprises",
    ],
    answer: "Au service de chaque citoyen",
    explanation:
        "L’article 1 de la loi n° 78-17 du 6 janvier 1978 précise que l’informatique doit être au service de chaque citoyen.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "CNIL - principes",
    question:
        "La loi Informatique et Libertés précise que l’informatique ne doit pas porter atteinte :",
    options: [
      "Ni à l’identité humaine, ni aux droits de l’homme, ni à la vie privée, ni aux libertés",
      "Uniquement à la vie privée",
      "Uniquement à la liberté d’expression",
    ],
    answer:
        "Ni à l’identité humaine, ni aux droits de l’homme, ni à la vie privée, ni aux libertés",
    explanation:
        "Le texte vise expressément l’identité humaine, les droits de l’homme, la vie privée et les libertés individuelles ou publiques.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "CNIL - principes",
    question: "La loi du 20 juin 2018 a notamment pour objectif :",
    options: [
      "De mettre le droit français en conformité avec le RGPD",
      "De supprimer la CNIL",
      "De créer un nouveau code pénal",
    ],
    answer: "De mettre le droit français en conformité avec le RGPD",
    explanation:
        "La loi n° 2018-493 adapte la loi Informatique et Libertés au règlement général sur la protection des données (RGPD).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "CNIL - rôle",
    question: "La CNIL est avant tout le régulateur français :",
    options: [
      "Des données personnelles",
      "Des armes à feu",
      "Des marchés publics",
    ],
    answer: "Des données personnelles",
    explanation:
        "La CNIL est l’autorité chargée de réguler la protection des données personnelles en France.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "CNIL - rôle",
    question: "La CNIL accompagne les professionnels :",
    options: [
      "Dans leur mise en conformité au RGPD et à la loi Informatique et Libertés",
      "Uniquement dans la gestion de leur comptabilité",
      "Uniquement pour la rédaction des contrats de travail",
    ],
    answer:
        "Dans leur mise en conformité au RGPD et à la loi Informatique et Libertés",
    explanation:
        "Elle conseille les responsables de traitement pour respecter les règles de protection des données.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "CNIL - rôle",
    question: "La CNIL aide les particuliers à :",
    options: [
      "Maîtriser leurs données et exercer leurs droits",
      "Demander des prêts bancaires",
      "Contester des amendes routières",
    ],
    answer: "Maîtriser leurs données et exercer leurs droits",
    explanation:
        "Elle informe les personnes sur leurs droits (accès, rectification, effacement, etc.) et la manière de les exercer.",
    difficulty: "Facile",
  ),

  // ---------- STATUT & COMPOSITION ----------
  QuizQuestion(
    category: "CNIL - statut",
    question: "La CNIL est composée de :",
    options: [
      "18 membres nommés pour cinq ans",
      "10 membres nommés à vie",
      "25 membres élus au suffrage universel",
    ],
    answer: "18 membres nommés pour cinq ans",
    explanation:
        "Le texte précise que la CNIL compte 18 membres, tous nommés pour un mandat de cinq ans.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "CNIL - statut",
    question: "Parmi les membres de la CNIL, on trouve notamment :",
    options: [
      "Des parlementaires et des représentants des hautes juridictions",
      "Uniquement des policiers et des gendarmes",
      "Exclusivement des agents du ministère de l’Intérieur",
    ],
    answer: "Des parlementaires et des représentants des hautes juridictions",
    explanation:
        "La CNIL comprend des députés, des sénateurs, des représentants du CESE et des membres des hautes juridictions.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "CNIL - statut",
    question: "Le Défenseur des droits siège à la CNIL :",
    options: [
      "Avec voix consultative",
      "Avec une voix prépondérante",
      "Sans y siéger du tout",
    ],
    answer: "Avec voix consultative",
    explanation:
        "Le Défenseur des droits participe aux travaux de la CNIL avec une voix consultative.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "CNIL - statut",
    question:
        "Depuis la loi du 4 août 2014 pour l’égalité réelle entre les femmes et les hommes, la CNIL doit respecter :",
    options: [
      "La parité entre les femmes et les hommes",
      "Un quota minimal d’élus locaux",
      "La présence obligatoire de magistrats administratifs",
    ],
    answer: "La parité entre les femmes et les hommes",
    explanation:
        "Le texte impose la parité au sein de la composition de la CNIL.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "CNIL - fonctionnement",
    question: "Le président de la CNIL est nommé :",
    options: [
      "Par décret du président de la République parmi les membres de la commission",
      "Par le ministre de l’Intérieur",
      "Par vote des agents de la CNIL",
    ],
    answer:
        "Par décret du président de la République parmi les membres de la commission",
    explanation:
        "L’article 9 de la loi prévoit une nomination par décret du président de la République pour cinq ans.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "CNIL - fonctionnement",
    question: "La CNIL établit et présente chaque année :",
    options: [
      "Un rapport public au président de la République, au Premier ministre et au Parlement",
      "Une note interne uniquement à la police",
      "Un rapport secret réservé aux services de renseignement",
    ],
    answer:
        "Un rapport public au président de la République, au Premier ministre et au Parlement",
    explanation:
        "L’article 8 de la loi impose à la CNIL de rendre un rapport annuel public aux plus hautes autorités de l’État.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "CNIL - fonctionnement",
    question: "Les agents de la CNIL sont soumis :",
    options: [
      "Au secret professionnel",
      "Au secret défense uniquement",
      "À aucune obligation particulière",
    ],
    answer: "Au secret professionnel",
    explanation:
        "L’article 11 de la loi les soumet au secret professionnel, par référence notamment aux articles 226-13 et 413-10 du Code pénal.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "CNIL - statut",
    question: "La CNIL est une autorité :",
    options: ["Administrative indépendante", "Judiciaire", "Policière"],
    answer: "Administrative indépendante",
    explanation:
        "Elle agit au nom de l’État, mais sans être placée sous l’autorité d’un ministre, ce qui garantit son indépendance.",
    difficulty: "Facile",
  ),

  // ---------- MISSIONS GÉNÉRALES ----------
  QuizQuestion(
    category: "CNIL - missions",
    question: "L’une des missions principales de la CNIL est :",
    options: [
      "D’informer les personnes et les responsables de traitement de leurs droits et obligations",
      "D’établir les programmes scolaires",
      "De recruter les fonctionnaires de police",
    ],
    answer:
        "D’informer les personnes et les responsables de traitement de leurs droits et obligations",
    explanation:
        "L’information des personnes concernées et des responsables de traitement figure au cœur de ses missions (article 8).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "CNIL - missions",
    question:
        "La CNIL veille à ce que les traitements de données personnelles soient mis en œuvre :",
    options: [
      "Conformément à la loi Informatique et Libertés et au RGPD",
      "Uniquement selon les usages locaux",
      "Uniquement selon la volonté des employeurs",
    ],
    answer: "Conformément à la loi Informatique et Libertés et au RGPD",
    explanation:
        "Elle s’assure du respect du cadre juridique national et européen de la protection des données.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "CNIL - missions",
    question: "La CNIL peut délivrer des labels :",
    options: [
      "À des produits ou procédures respectant la protection des données",
      "Uniquement à des véhicules de police",
      "Uniquement à des sociétés de sécurité privée",
    ],
    answer: "À des produits ou procédures respectant la protection des données",
    explanation:
        "Ces labels attestent la conformité de solutions aux exigences de protection des données.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "CNIL - missions",
    question:
        "La CNIL suit l’évolution des technologies de l’information pour :",
    options: [
      "Apprécier leurs conséquences sur les droits et libertés",
      "Organiser la maintenance des caméras de la ville",
      "Gérer les effectifs de police",
    ],
    answer: "Apprécier leurs conséquences sur les droits et libertés",
    explanation:
        "Elle peut rendre publiques ses analyses sur des sujets comme la vidéoprotection, l’IA ou la reconnaissance faciale.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU MOYENNE =====================
  // ---------- MISSIONS & POUVOIRS ----------
  QuizQuestion(
    category: "CNIL - missions",
    question:
        "La CNIL peut présenter des observations devant une juridiction :",
    options: [
      "Dans les litiges relatifs à l’application de la loi Informatique et Libertés et des textes de protection des données",
      "Uniquement en matière de droit du travail",
      "Uniquement devant la Cour pénale internationale",
    ],
    answer:
        "Dans les litiges relatifs à l’application de la loi Informatique et Libertés et des textes de protection des données",
    explanation:
        "Elle peut intervenir devant toute juridiction pour éclairer le juge sur les règles de protection des données.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "CNIL - missions",
    question: "Pour veiller au respect de la loi, la CNIL dispose notamment :",
    options: [
      "De pouvoirs de contrôle sur place ou sur pièces",
      "Uniquement d’un rôle de conseil sans contrôle",
      "Uniquement d’un rôle de médiation",
    ],
    answer: "De pouvoirs de contrôle sur place ou sur pièces",
    explanation:
        "Elle peut se rendre dans les locaux des organismes ou demander des documents pour vérifier la conformité des traitements.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "CNIL - missions",
    question: "En cas de manquements, la CNIL peut :",
    options: [
      "Prononcer des mises en demeure et des sanctions",
      "Uniquement envoyer un rappel à la loi sans effet juridique",
      "Retirer des points sur le permis de conduire",
    ],
    answer: "Prononcer des mises en demeure et des sanctions",
    explanation:
        "Elle dispose d’un pouvoir de sanction administrative (amendes, injonctions, etc.).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "CNIL - missions",
    question:
        "Les infractions aux dispositions de la loi Informatique et Libertés sont prévues et réprimées par :",
    options: [
      "Les articles 226-16 à 226-24 du Code pénal",
      "Les articles 221-1 à 221-5 du Code pénal",
      "Les articles 78-2 à 78-2-5 du Code de procédure pénale",
    ],
    answer: "Les articles 226-16 à 226-24 du Code pénal",
    explanation:
        "Ces articles prévoient des délits spécifiques en matière de traitements de données illicites.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "CNIL - fonctionnement",
    question:
        "Selon l’article 18 de la loi, le gouvernement et les autorités publiques :",
    options: [
      "Ne peuvent s’opposer à l’action de la CNIL et doivent faciliter sa mission",
      "Peuvent bloquer les contrôles de la CNIL à tout moment",
      "Doivent systématiquement valider les décisions de la CNIL",
    ],
    answer:
        "Ne peuvent s’opposer à l’action de la CNIL et doivent faciliter sa mission",
    explanation:
        "Les autorités publiques sont tenues de prendre toutes mesures utiles pour permettre l’action de la CNIL.",
    difficulty: "Moyenne",
  ),

  // ---------- FICHIERS & TRAITEMENTS ----------
  QuizQuestion(
    category: "Données personnelles - fichiers",
    question: "Constitue un fichier de données à caractère personnel :",
    options: [
      "Tout ensemble structuré de données personnelles, centralisé ou réparti, accessible selon des critères déterminés",
      "Uniquement un classeur papier dans un bureau",
      "Uniquement une base de données informatique centralisée",
    ],
    answer:
        "Tout ensemble structuré de données personnelles, centralisé ou réparti, accessible selon des critères déterminés",
    explanation:
        "La définition (article 2) vise tout ensemble structuré, quel que soit le support ou le mode d’organisation.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Données personnelles - fichiers",
    question:
        "Avec le RGPD, la plupart des déclarations préalables de fichiers auprès de la CNIL :",
    options: [
      "Ont été supprimées",
      "Ont été doublées",
      "Sont devenues obligatoires tous les mois",
    ],
    answer: "Ont été supprimées",
    explanation:
        "Le RGPD a remplacé la logique de déclaration par une logique de responsabilisation des responsables de traitement.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Données personnelles - fichiers",
    question: "Des formalités particulières subsistent notamment pour :",
    options: [
      "Les secteurs sensibles comme la santé ou la police-justice",
      "Tous les fichiers de cantine scolaire",
      "Les simples listes de courses personnelles",
    ],
    answer: "Les secteurs sensibles comme la santé ou la police-justice",
    explanation:
        "Ces domaines, plus sensibles, demeurent soumis à un encadrement renforcé.",
    difficulty: "Moyenne",
  ),

  // ---------- TRAITEMENTS DE SOUVERAINETÉ ----------
  QuizQuestion(
    category: "Données personnelles - État",
    question:
        "Pour certains traitements à risques relevant du secteur public (sûreté de l’État, sécurité publique, prévention des infractions), le législateur a maintenu :",
    options: [
      "Un régime de demande d’avis auprès de la CNIL",
      "Une simple information orale de la CNIL",
      "Une liberté totale sans contrôle",
    ],
    answer: "Un régime de demande d’avis auprès de la CNIL",
    explanation:
        "L’article 31 de la loi prévoit un avis de la CNIL pour ces traitements dits de souveraineté.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Données personnelles - État",
    question:
        "Les traitements de données génétiques ou biométriques mis en œuvre pour le compte de l’État, dans l’exercice de ses prérogatives de puissance publique :",
    options: [
      "Sont autorisés par décret en Conseil d’État après avis motivé et publié de la CNIL",
      "Sont créés librement par chaque service sans formalité",
      "Sont interdits en toute circonstance",
    ],
    answer:
        "Sont autorisés par décret en Conseil d’État après avis motivé et publié de la CNIL",
    explanation:
        "C’est ce qu’indique l’article 32 de la loi Informatique et Libertés.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Données personnelles - État",
    question:
        "Les actes autorisant la création d’un traitement de données sensibles doivent notamment préciser :",
    options: [
      "La finalité du traitement, les catégories de données, les destinataires et le service auprès duquel s’exerce le droit d’accès",
      "Uniquement la date de création du fichier",
      "Uniquement le nom du ministre",
    ],
    answer:
        "La finalité du traitement, les catégories de données, les destinataires et le service auprès duquel s’exerce le droit d’accès",
    explanation:
        "Le texte impose une description détaillée des éléments essentiels : finalité, données, destinataires, droits des personnes, etc.",
    difficulty: "Moyenne",
  ),

  // ---------- DROITS DES PERSONNES : INFORMATION ----------
  QuizQuestion(
    category: "Droits des personnes",
    question:
        "L’article 104 de la loi prévoit que la personne concernée doit être informée notamment :",
    options: [
      "De l’identité du responsable de traitement et de ses coordonnées",
      "Uniquement du nom de l’agent de police qui l’interroge",
      "Uniquement du lieu de stockage des serveurs",
    ],
    answer: "De l’identité du responsable de traitement et de ses coordonnées",
    explanation:
        "L’information porte sur le responsable, ses coordonnées, celles du DPO le cas échéant, et les finalités du traitement.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Droits des personnes",
    question: "La personne concernée doit également être informée :",
    options: [
      "De l’existence du droit d’introduire une réclamation auprès de la CNIL",
      "Uniquement de la durée de conservation des données",
      "Uniquement de l’identité du juge compétent",
    ],
    answer:
        "De l’existence du droit d’introduire une réclamation auprès de la CNIL",
    explanation:
        "L’article 104 impose d’indiquer la possibilité de saisir la CNIL et les coordonnées de celle-ci.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Droits des personnes",
    question: "Parmi les éléments d’information, figure aussi :",
    options: [
      "L’existence des droits d’accès, de rectification, d’effacement et de limitation du traitement",
      "Uniquement le droit à l’oubli bancaire",
      "Uniquement le droit à l’indemnisation automatique",
    ],
    answer:
        "L’existence des droits d’accès, de rectification, d’effacement et de limitation du traitement",
    explanation:
        "La loi impose une information claire sur ces droits fondamentaux.",
    difficulty: "Moyenne",
  ),

  // ---------- DROITS DES PERSONNES : ACCÈS & RECTIFICATION ----------
  QuizQuestion(
    category: "Droits des personnes",
    question: "L’article 105 prévoit que toute personne peut demander :",
    options: [
      "Si des données la concernant sont traitées et obtenir des informations sur ce traitement",
      "Uniquement la suppression immédiate de tous ses fichiers",
      "Uniquement la liste nominative de tous les agents ayant consulté ses données",
    ],
    answer:
        "Si des données la concernant sont traitées et obtenir des informations sur ce traitement",
    explanation:
        "Il s’agit du droit d’accès direct à ses données et aux informations liées au traitement.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Droits des personnes",
    question: "L’article 106 permet à la personne concernée de demander :",
    options: [
      "La rectification des données inexactes, le complément des données incomplètes et l’effacement des données illicites",
      "Uniquement la copie papier du fichier",
      "Uniquement la modification de l’adresse mail",
    ],
    answer:
        "La rectification des données inexactes, le complément des données incomplètes et l’effacement des données illicites",
    explanation:
        "Ce texte consacre les droits de rectification, de complément et d’effacement des données conservées en violation de la loi.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Droits des personnes",
    question:
        "Les décisions judiciaires et données faisant l’objet d’une procédure pénale :",
    options: [
      "Ne relèvent pas des articles 104 à 106, mais du Code de procédure pénale",
      "Sont toujours effacées automatiquement par la CNIL",
      "Ne sont jamais accessibles aux personnes concernées",
    ],
    answer:
        "Ne relèvent pas des articles 104 à 106, mais du Code de procédure pénale",
    explanation:
        "L’article 111 renvoie aux règles spécifiques du CPP pour ces données (par exemple TAJ).",
    difficulty: "Moyenne",
  ),

  // ---------- FOCUS POLICE & FICHIERS ----------
  QuizQuestion(
    category: "CNIL & police",
    question: "Les fichiers de police (TAJ, FPR, etc.) sont :",
    options: [
      "Soumis au contrôle de la CNIL",
      "Totalement hors du champ de la CNIL",
      "Contrôlés uniquement par les maires",
    ],
    answer: "Soumis au contrôle de la CNIL",
    explanation:
        "Le focus opérationnel rappelle que ces fichiers sont encadrés et contrôlés par la CNIL.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "CNIL & police",
    question:
        "Toute création ou consultation d’un fichier de police doit reposer sur :",
    options: [
      "Un fondement légal clair et une finalité déterminée",
      "Une simple décision orale du chef de service",
      "La demande d’un journaliste",
    ],
    answer: "Un fondement légal clair et une finalité déterminée",
    explanation:
        "La légalité des traitements repose sur une base juridique précise et des finalités définies.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "CNIL & police",
    question:
        "En cas de doute sur la légalité d’une consultation de fichier, l’agent devrait :",
    options: [
      "Se référer aux textes réglementaires et aux référents protection des données",
      "Procéder malgré tout et régulariser plus tard",
      "Demander directement l’avis du mis en cause",
    ],
    answer:
        "Se référer aux textes réglementaires et aux référents protection des données",
    explanation:
        "Le fascicule recommande de vérifier la base légale et de solliciter les référents en cas d’incertitude.",
    difficulty: "Moyenne",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  // ---------- CNIL : INDÉPENDANCE & CONTRÔLE DE L’ÉTAT ----------
  QuizQuestion(
    category: "CNIL - indépendance",
    question:
        "Le fait que la CNIL soit une autorité administrative indépendante permet notamment :",
    options: [
      "De contrôler l’action de l’État lui-même en matière de fichiers de police et de justice",
      "De se placer sous l’autorité directe du ministre de l’Intérieur",
      "De décider seule de l’opportunité des poursuites pénales",
    ],
    answer:
        "De contrôler l’action de l’État lui-même en matière de fichiers de police et de justice",
    explanation:
        "Son indépendance est essentielle pour contrôler des traitements mis en œuvre par les pouvoirs publics.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "CNIL - indépendance",
    question:
        "L’impossibilité, pour le gouvernement ou les dirigeants d’entreprises publiques ou privées, de s’opposer à l’action de la CNIL signifie que :",
    options: [
      "Ils doivent faciliter ses contrôles, même lorsqu’ils visent leurs propres fichiers",
      "Ils peuvent annuler les décisions de la CNIL s’ils ne sont pas d’accord",
      "Ils peuvent refuser tout contrôle pour des raisons d’image",
    ],
    answer:
        "Ils doivent faciliter ses contrôles, même lorsqu’ils visent leurs propres fichiers",
    explanation:
        "L’article 18 garantit l’effectivité des contrôles de la CNIL, y compris sur des traitements sensibles.",
    difficulty: "Difficile",
  ),

  // ---------- TRAITEMENTS DE SOUVERAINETÉ : CONTENU DES ACTES ----------
  QuizQuestion(
    category: "Données personnelles - État",
    question:
        "Pour des traitements de souveraineté, les actes d’autorisation doivent préciser, parmi d’autres éléments :",
    options: [
      "Les dérogations à l’obligation d’information et les limitations aux droits des personnes, le cas échéant",
      "Uniquement le coût financier du fichier",
      "Uniquement le logo utilisé sur l’interface",
    ],
    answer:
        "Les dérogations à l’obligation d’information et les limitations aux droits des personnes, le cas échéant",
    explanation:
        "Le texte exige une transparence sur les éventuelles restrictions aux droits des personnes concernées.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Données personnelles - État",
    question:
        "Pour les traitements mis en œuvre conjointement par plusieurs responsables, les actes prévoient :",
    options: [
      "La désignation d’un point de contact pour les personnes concernées",
      "L’absence de tout interlocuteur identifié",
      "La désignation systématique d’un juge d’instruction",
    ],
    answer:
        "La désignation d’un point de contact pour les personnes concernées",
    explanation:
        "Ce point de contact est chargé de répondre aux demandes d’exercice des droits des personnes.",
    difficulty: "Difficile",
  ),

  // ---------- DROITS DES PERSONNES : LIMITES & ARTICULATIONS ----------
  QuizQuestion(
    category: "Droits des personnes",
    question:
        "S’agissant des traitements de police-justice, l’articulation entre la loi Informatique et Libertés et le Code de procédure pénale implique que :",
    options: [
      "Certains droits (accès, rectification, effacement) se exercent selon des modalités spécifiques prévues par le Code de procédure pénale",
      "La loi Informatique et Libertés prime toujours sans exception",
      "Seul le juge administratif est compétent pour en connaître",
    ],
    answer:
        "Certains droits (accès, rectification, effacement) se exercent selon des modalités spécifiques prévues par le Code de procédure pénale",
    explanation:
        "L’article 111 renvoie au CPP pour les décisions judiciaires et dossiers pénaux (ex : TAJ).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Droits des personnes",
    question: "Le droit à l’effacement des données dans un fichier de police :",
    options: [
      "Peut être limité, l’effacement obéissant aux conditions fixées par le Code de procédure pénale",
      "Est automatique dès qu’une personne en fait la demande",
      "Relève exclusivement de la mairie du domicile",
    ],
    answer:
        "Peut être limité, l’effacement obéissant aux conditions fixées par le Code de procédure pénale",
    explanation:
        "Par exemple, les modalités d’effacement dans le TAJ sont encadrées par les articles 230-8 et 230-9 CPP.",
    difficulty: "Difficile",
  ),

  // ---------- POLICE & BONNES PRATIQUES ----------
  QuizQuestion(
    category: "CNIL & police",
    question:
        "Pour un agent de police, la consultation d’un fichier de données personnelles doit respecter en priorité :",
    options: [
      "La finalité du fichier et le strict lien avec la mission de service",
      "La curiosité personnelle de l’agent",
      "La demande informelle d’un ami",
    ],
    answer:
        "La finalité du fichier et le strict lien avec la mission de service",
    explanation:
        "Le recours aux fichiers doit être justifié par la mission et la finalité déclarée du traitement.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "CNIL & police",
    question:
        "La CNIL peut contrôler les fichiers de police pour vérifier notamment :",
    options: [
      "La base légale, les finalités, la durée de conservation et les conditions d’accès",
      "Uniquement la couleur de l’interface informatique",
      "Uniquement la vitesse des ordinateurs utilisés",
    ],
    answer:
        "La base légale, les finalités, la durée de conservation et les conditions d’accès",
    explanation:
        "Ce sont les éléments centraux de la conformité d’un traitement de données.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "CNIL & police",
    question:
        "En cas de contrôle de la CNIL dans un service de police, l’attitude attendue des agents est :",
    options: [
      "Faciliter le contrôle en fournissant les informations et documents demandés",
      "Refuser toute communication pour préserver le secret professionnel",
      "Détruire les données avant l’arrivée des contrôleurs",
    ],
    answer:
        "Faciliter le contrôle en fournissant les informations et documents demandés",
    explanation:
        "L’article 18 oblige les autorités et services à prendre toutes mesures utiles pour faciliter l’action de la CNIL.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Principes généraux",
    question:
        "La liberté individuelle, ou sûreté, est principalement la liberté :",
    options: [
      "De ne pas être arrêté, détenu ou contrôlé arbitrairement",
      "De circuler sans jamais pouvoir être contrôlé",
      "De refuser toute décision de justice",
    ],
    answer: "De ne pas être arrêté, détenu ou contrôlé arbitrairement",
    explanation:
        "Le texte définit la liberté individuelle comme la liberté de ne pas subir d’arrestation, de détention ou de contrôle arbitraires.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Principes généraux",
    question: "La sûreté est qualifiée de :",
    options: [
      "Liberté fondamentale qui garantit toutes les autres",
      "Liberté secondaire par rapport aux autres",
      "Simple principe moral sans valeur juridique",
    ],
    answer: "Liberté fondamentale qui garantit toutes les autres",
    explanation:
        "Le fascicule la décrit comme « la liberté fondamentale qui garantit toutes les autres ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Principes généraux",
    question: "La sûreté est affirmée notamment par :",
    options: [
      "La Déclaration des Droits de l’Homme et du Citoyen de 1789",
      "Uniquement par des circulaires ministérielles",
      "Exclusivement par le code de la route",
    ],
    answer: "La Déclaration des Droits de l’Homme et du Citoyen de 1789",
    explanation:
        "Le texte mentionne notamment les articles 2, 7, 8 et 9 de la DDHC de 1789.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Principes généraux",
    question:
        "Toute mesure portant atteinte à la liberté d’une personne (garde à vue, détention, etc.) doit :",
    options: [
      "Reposer sur un texte précis et une procédure encadrée",
      "Être validée uniquement par la hiérarchie policière",
      "Être décidée librement par l’agent sur le terrain",
    ],
    answer: "Reposer sur un texte précis et une procédure encadrée",
    explanation:
        "Le texte insiste sur la nécessité d’un fondement légal clair et d’un strict respect de la procédure.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Principes généraux",
    question:
        "Une mesure privative de liberté sans base légale claire peut être qualifiée :",
    options: [
      "D’arrestation ou de détention arbitraire",
      "De simple maladresse",
      "De mesure administrative ordinaire",
    ],
    answer: "D’arrestation ou de détention arbitraire",
    explanation:
        "L’absence de base légale fait basculer la mesure dans l’arbitraire, lourdement sanctionné.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Principes généraux",
    question:
        "En cas d’arrestation ou de détention arbitraire, la responsabilité de l’auteur :",
    options: [
      "Peut être pénale, civile et disciplinaire",
      "Est uniquement morale",
      "Est automatiquement effacée au bout de 24 heures",
    ],
    answer: "Peut être pénale, civile et disciplinaire",
    explanation:
        "Le texte précise qu’une privation arbitraire engage à la fois les responsabilités pénale, civile et disciplinaire.",
    difficulty: "Facile",
  ),

  // ---------- TEXTES FONDATEURS ----------
  QuizQuestion(
    category: "Textes fondamentaux",
    question:
        "La liberté individuelle est notamment protégée par un article de la Constitution de 1958 qui confie sa garde :",
    options: [
      "À l’autorité judiciaire (article 66)",
      "À l’autorité militaire",
      "Aux seuls préfets",
    ],
    answer: "À l’autorité judiciaire (article 66)",
    explanation:
        "L’article 66 de la Constitution confie à l’autorité judiciaire la garde de la liberté individuelle.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Textes fondamentaux",
    question:
        "La Convention européenne des droits de l’homme protège la liberté individuelle à travers l’article :",
    options: [
      "5 (droit à la liberté et à la sûreté)",
      "3 (interdiction de la torture)",
      "10 (liberté d’expression)",
    ],
    answer: "5 (droit à la liberté et à la sûreté)",
    explanation:
        "Le texte mentionne l’article 5 de la CEDH qui encadre les cas de privation de liberté.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Textes fondamentaux",
    question: "Selon la DDHC, nul ne peut être arrêté ou détenu :",
    options: [
      "Que dans les cas prévus par la loi et selon les formes qu’elle a prescrites",
      "Qu’avec l’accord de sa famille",
      "Uniquement s’il est déjà condamné",
    ],
    answer:
        "Que dans les cas prévus par la loi et selon les formes qu’elle a prescrites",
    explanation:
        "Les articles 7, 8 et 9 de la DDHC posent ce principe fondamental.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU MOYENNE =====================
  // ---------- IDÉE CLÉ : FONDEMENT LÉGAL ----------
  QuizQuestion(
    category: "Protection légale",
    question:
        "L’idée clé rappelée dans le fascicule est que toute privation de liberté est d’abord :",
    options: [
      "Une question de texte et de fondement légal",
      "Une question d’opportunité politique",
      "Une simple appréciation de l’agent sur place",
    ],
    answer: "Une question de texte et de fondement légal",
    explanation:
        "« Pas de fondement légal clair = mesure arbitraire » : toute mesure doit être rattachée à un texte précis.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Protection légale",
    question:
        "Pour agir légalement, un policier doit pouvoir rattacher son action :",
    options: [
      "À un article précis d’un code (pénal, procédure pénale, CESEDA, etc.)",
      "À une consigne orale de son chef",
      "Au seul bon sens commun",
    ],
    answer:
        "À un article précis d’un code (pénal, procédure pénale, CESEDA, etc.)",
    explanation:
        "Le texte insiste sur la nécessité d’un rattachement clair à un fondement légal écrit.",
    difficulty: "Moyenne",
  ),

  // ---------- PRINCIPES PÉNAUX ----------
  QuizQuestion(
    category: "Mesures judiciaires - principes",
    question: "Le principe de légalité des délits et des peines implique que :",
    options: [
      "Nul ne peut être condamné sans texte clair définissant l’infraction et la peine",
      "Le juge peut créer librement de nouvelles infractions",
      "La coutume suffit pour priver une personne de liberté",
    ],
    answer:
        "Nul ne peut être condamné sans texte clair définissant l’infraction et la peine",
    explanation:
        "L’article 8 de la DDHC exige une loi pénale accessible et prévisible.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Mesures judiciaires - principes",
    question:
        "La non-rétroactivité de la loi pénale plus sévère signifie que :",
    options: [
      "Une loi plus sévère ne s’applique pas aux faits commis avant son entrée en vigueur",
      "Toute nouvelle loi s’applique immédiatement à tous les faits passés",
      "Seules les contraventions sont concernées",
    ],
    answer:
        "Une loi plus sévère ne s’applique pas aux faits commis avant son entrée en vigueur",
    explanation:
        "En revanche, une loi plus douce bénéficie à la personne poursuivie.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Mesures judiciaires - principes",
    question:
        "La présomption d’innocence implique notamment que les mesures privatives de liberté avant jugement :",
    options: [
      "Sont des exceptions strictement encadrées",
      "Sont la règle pour toute personne soupçonnée",
      "Sont décidées automatiquement par la police",
    ],
    answer: "Sont des exceptions strictement encadrées",
    explanation:
        "Garde à vue, détention provisoire, etc. sont des mesures d’exception justifiées par des nécessités précises.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Mesures judiciaires - principes",
    question: "Les garanties procédurales pénales incluent notamment :",
    options: [
      "Droit à un avocat, information des droits, débat contradictoire et contrôle par un juge",
      "Uniquement une information orale de la famille",
      "Uniquement la possibilité de téléphoner à un ami",
    ],
    answer:
        "Droit à un avocat, information des droits, débat contradictoire et contrôle par un juge",
    explanation:
        "Les droits de la défense sont au cœur de toute mesure privative de liberté.",
    difficulty: "Moyenne",
  ),

  // ---------- MESURES DÉCIDÉES PAR LES POLICIERS ----------
  QuizQuestion(
    category: "Mesures judiciaires - police",
    question: "La garde à vue est :",
    options: [
      "Décidée par un officier de police judiciaire, sous contrôle du procureur puis du JLD",
      "Décidée uniquement par le maire",
      "Décidée librement par tout agent de police municipale",
    ],
    answer:
        "Décidée par un officier de police judiciaire, sous contrôle du procureur puis du JLD",
    explanation:
        "Elle est prévue aux articles 62-2 et suivants du Code de procédure pénale.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Mesures judiciaires - police",
    question:
        "La vérification d’identité (articles 78-2 et 78-3 CPP) doit être :",
    options: [
      "Une mesure brève, strictement encadrée, qui ne doit pas devenir une garde à vue déguisée",
      "Une mesure pouvant durer 24 heures sans contrôle",
      "Une simple formalité sans texte",
    ],
    answer:
        "Une mesure brève, strictement encadrée, qui ne doit pas devenir une garde à vue déguisée",
    explanation:
        "Le texte insiste sur le caractère limité et encadré de cette mesure.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Mesures judiciaires - police",
    question: "La retenue judiciaire des mineurs se caractérise par :",
    options: [
      "Une durée et un régime plus protecteurs que la garde à vue classique",
      "Une durée plus longue que pour les majeurs",
      "L’absence de tout contrôle judiciaire",
    ],
    answer:
        "Une durée et un régime plus protecteurs que la garde à vue classique",
    explanation:
        "Le texte rappelle qu’elle est conçue pour protéger davantage les mineurs.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Mesures judiciaires - police",
    question: "La retenue douanière a pour finalité principale :",
    options: [
      "Les besoins de l’enquête en matière douanière",
      "Le contrôle routier systématique",
      "La gestion de la circulation urbaine",
    ],
    answer: "Les besoins de l’enquête en matière douanière",
    explanation:
        "Elle relève du Code des douanes et vise les infractions douanières.",
    difficulty: "Moyenne",
  ),

  // ---------- MESURES DÉCIDÉES PAR LES MAGISTRATS ----------
  QuizQuestion(
    category: "Mesures judiciaires - magistrats",
    question: "Les mandats d’amener, de dépôt et d’arrêt sont :",
    options: [
      "Des décisions de contrainte prises par les magistrats",
      "Des documents internes à la police sans valeur juridique",
      "Des décisions prises par les maires",
    ],
    answer: "Des décisions de contrainte prises par les magistrats",
    explanation:
        "Ils sont délivrés par le juge d’instruction ou la juridiction de jugement.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Mesures judiciaires - magistrats",
    question: "La détention provisoire est décidée par :",
    options: [
      "Le juge des libertés et de la détention",
      "Le chef de service de police",
      "Le préfet",
    ],
    answer: "Le juge des libertés et de la détention",
    explanation:
        "Le JLD statue sur la détention provisoire sur saisine du juge d’instruction ou de la juridiction de jugement.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Mesures judiciaires - magistrats",
    question:
        "Les mesures de sûreté après condamnation ou irresponsabilité pénale peuvent inclure :",
    options: [
      "La rétention de sûreté ou une hospitalisation complète en établissement psychiatrique",
      "Uniquement une simple convocation annuelle",
      "Uniquement une amende symbolique",
    ],
    answer:
        "La rétention de sûreté ou une hospitalisation complète en établissement psychiatrique",
    explanation:
        "Elles visent les personnes particulièrement dangereuses dans des situations très encadrées.",
    difficulty: "Moyenne",
  ),

  // ---------- MESURES ADMINISTRATIVES ----------
  QuizQuestion(
    category: "Mesures administratives",
    question:
        "Les mesures administratives privatives de liberté sont décidées :",
    options: [
      "Par l’autorité administrative (préfet, ministre, maire…) pour prévenir des atteintes graves à l’ordre public",
      "Par le juge pénal uniquement",
      "Par les syndicats de police",
    ],
    answer:
        "Par l’autorité administrative (préfet, ministre, maire…) pour prévenir des atteintes graves à l’ordre public",
    explanation:
        "Elles restent des exceptions, soumises à la loi et au contrôle du juge.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Mesures administratives",
    question: "L’interdiction de paraître vise à empêcher une personne :",
    options: [
      "De se rendre dans certains lieux déterminés en raison d’un risque sérieux de troubles",
      "De circuler sur l’ensemble du territoire français",
      "De parler en public",
    ],
    answer:
        "De se rendre dans certains lieux déterminés en raison d’un risque sérieux de troubles",
    explanation:
        "Elle concerne par exemple les abords d’un stade, d’un quartier sensible ou d’une manifestation.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Mesures administratives",
    question: "L’assignation à résidence oblige une personne à :",
    options: [
      "Demeurer dans un lieu déterminé, avec éventuellement des horaires de pointage ou des obligations de présentation",
      "Quitter immédiatement le territoire",
      "Se présenter tous les jours devant un juge pénal",
    ],
    answer:
        "Demeurer dans un lieu déterminé, avec éventuellement des horaires de pointage ou des obligations de présentation",
    explanation:
        "C’est une limitation forte de la liberté d’aller et venir, notamment utilisée en matière de terrorisme ou pour certains étrangers.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Mesures administratives",
    question:
        "La retenue administrative dans certains contextes (perquisitions, frontières, terrorisme) doit être :",
    options: [
      "Limitée à la durée strictement nécessaire aux vérifications",
      "D’au moins 48 heures dans tous les cas",
      "Non encadrée par un texte",
    ],
    answer: "Limitée à la durée strictement nécessaire aux vérifications",
    explanation:
        "Le texte insiste sur le caractère bref de ces retenues, sous contrôle du procureur.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Mesures administratives",
    question: "Le placement en local de dégrisement vise avant tout :",
    options: [
      "La protection de la personne en ivresse publique et manifeste et de l’ordre public",
      "La sanction immédiate de l’intéressé",
      "La réalisation systématique d’une garde à vue",
    ],
    answer:
        "La protection de la personne en ivresse publique et manifeste et de l’ordre public",
    explanation:
        "Il s’agit d’une mesure de police administrative, non d’une sanction pénale.",
    difficulty: "Moyenne",
  ),

  // ---------- SOINS PSYCHIATRIQUES SANS CONSENTEMENT ----------
  QuizQuestion(
    category: "Soins sans consentement",
    question: "L’hospitalisation psychiatrique sans consentement constitue :",
    options: [
      "Une privation grave de liberté, strictement encadrée par le Code de la santé publique",
      "Une simple formalité médicale sans impact sur la liberté",
      "Une sanction pénale automatique",
    ],
    answer:
        "Une privation grave de liberté, strictement encadrée par le Code de la santé publique",
    explanation:
        "Elle doit être justifiée par l’état mental de la personne et contrôlée par le juge.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Soins sans consentement",
    question:
        "L’admission en soins sans consentement sur décision du préfet est possible lorsqu’il existe :",
    options: [
      "Un danger grave pour l’ordre public ou la sûreté des personnes",
      "Un simple conflit de voisinage",
      "Une difficulté financière de la personne",
    ],
    answer: "Un danger grave pour l’ordre public ou la sûreté des personnes",
    explanation:
        "Le préfet peut décider de l’admission lorsque les troubles mentaux mettent en péril la sécurité.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Soins sans consentement",
    question:
        "Le juge des libertés et de la détention contrôle les hospitalisations sans consentement :",
    options: [
      "Dans des délais courts, notamment à 12 jours puis régulièrement",
      "Uniquement tous les 5 ans",
      "Jamais, car seules les autorités médicales sont compétentes",
    ],
    answer: "Dans des délais courts, notamment à 12 jours puis régulièrement",
    explanation:
        "Le texte rappelle un contrôle systématique du JLD dans des délais rapprochés.",
    difficulty: "Moyenne",
  ),

  // ---------- MESURES CONCERNANT LES ÉTRANGERS ----------
  QuizQuestion(
    category: "Étrangers - CESEDA",
    question: "La zone d’attente concerne notamment :",
    options: [
      "Les étrangers non admis à entrer sur le territoire ou demandant l’asile à la frontière",
      "Les touristes déjà installés en France depuis plusieurs années",
      "Les Français revenant de voyage",
    ],
    answer:
        "Les étrangers non admis à entrer sur le territoire ou demandant l’asile à la frontière",
    explanation: "Le CESEDA prévoit ce dispositif spécifique à la frontière.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Étrangers - CESEDA",
    question:
        "La rétention administrative dans un centre spécialisé a pour finalité principale :",
    options: [
      "Préparer l’éloignement du territoire (OQTF, expulsion, réadmission, etc.)",
      "Sanctionner pénalement l’étranger",
      "Lui permettre de choisir librement un nouveau lieu de vie en France",
    ],
    answer:
        "Préparer l’éloignement du territoire (OQTF, expulsion, réadmission, etc.)",
    explanation:
        "Il s’agit d’une mesure de police administrative en vue de l’éloignement.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Étrangers - CESEDA",
    question: "La durée initiale de la rétention administrative est :",
    options: [
      "De 48 heures, avec possibles prolongations par le JLD",
      "De 30 jours automatiquement",
      "Illimitée dès lors qu’une OQTF est prononcée",
    ],
    answer: "De 48 heures, avec possibles prolongations par le JLD",
    explanation:
        "Le texte mentionne une durée initiale de 48 heures, puis un contrôle et des prolongations possibles par le JLD.",
    difficulty: "Moyenne",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  // ---------- PROTECTION JUDICIAIRE DE LA SÛRETÉ ----------
  QuizQuestion(
    category: "Protection judiciaire",
    question:
        "L’article 66 de la Constitution confie à l’autorité judiciaire le rôle de :",
    options: [
      "Gardienne de la liberté individuelle",
      "Gardienne de la seule liberté d’expression",
      "Gardienne de l’ordre public administratif",
    ],
    answer: "Gardienne de la liberté individuelle",
    explanation:
        "Le fascicule cite expressément l’article 66 et ce rôle central de l’autorité judiciaire.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Protection judiciaire",
    question:
        "Le juge des libertés et de la détention (JLD) contrôle notamment :",
    options: [
      "La garde à vue, la détention provisoire, les hospitalisations sans consentement et la rétention des étrangers",
      "Uniquement les contraventions routières",
      "Exclusivement les décisions du maire",
    ],
    answer:
        "La garde à vue, la détention provisoire, les hospitalisations sans consentement et la rétention des étrangers",
    explanation:
        "Le texte le présente comme un acteur central de la protection de la liberté individuelle.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Protection judiciaire",
    question:
        "Le juge administratif peut, en matière de police administrative, ordonner en urgence :",
    options: [
      "La suspension d’une mesure portant atteinte grave à une liberté fondamentale (référé-liberté)",
      "La condamnation pénale immédiate de l’agent",
      "La révocation directe d’un fonctionnaire de police",
    ],
    answer:
        "La suspension d’une mesure portant atteinte grave à une liberté fondamentale (référé-liberté)",
    explanation:
        "Le texte mentionne le contrôle du juge administratif via notamment le référé-liberté.",
    difficulty: "Difficile",
  ),

  // ---------- SANCTIONS PÉNALES FONCTIONNAIRES ----------
  QuizQuestion(
    category: "Sanctions pénales - fonctionnaires",
    question:
        "Le Code pénal réprime spécifiquement, pour un dépositaire de l’autorité publique, le fait :",
    options: [
      "D’ordonner ou accomplir une arrestation ou une détention arbitraire",
      "De refuser un simple renseignement administratif",
      "De ne pas serrer la main à un administré",
    ],
    answer:
        "D’ordonner ou accomplir une arrestation ou une détention arbitraire",
    explanation:
        "Les articles 432-4 et 432-5 C. pén. visent ces comportements graves.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Sanctions pénales - fonctionnaires",
    question:
        "L’infraction consistant à laisser se prolonger arbitrairement une détention est :",
    options: [
      "Spécialement prévue et réprimée par le Code pénal",
      "Sans aucune conséquence pénale",
      "Uniquement susceptible de donner lieu à un rappel à la loi",
    ],
    answer: "Spécialement prévue et réprimée par le Code pénal",
    explanation:
        "Le texte mentionne explicitement cette infraction (article 432-5 C. pén.).",
    difficulty: "Difficile",
  ),

  // ---------- SANCTIONS PÉNALES PARTICULIERS ----------
  QuizQuestion(
    category: "Sanctions pénales - particuliers",
    question:
        "Pour un particulier, l’arrestation, la détention ou la séquestration arbitraire d’une personne est réprimée :",
    options: [
      "Par l’article 224-1 du Code pénal",
      "Uniquement par une simple amende administrative",
      "Uniquement par un rappel à l’ordre du maire",
    ],
    answer: "Par l’article 224-1 du Code pénal",
    explanation:
        "Le texte cite cet article qui peut entraîner de lourdes peines, jusqu’à la réclusion criminelle en cas d’aggravation.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Sanctions pénales - particuliers",
    question:
        "L’arrestation ou la séquestration arbitraire commise par un particulier peut être punie :",
    options: [
      "De peines pouvant aller jusqu’à 20 ans de réclusion criminelle en cas de circonstances aggravantes",
      "D’un simple stage de citoyenneté",
      "D’une amende plafonnée à 150 euros",
    ],
    answer:
        "De peines pouvant aller jusqu’à 20 ans de réclusion criminelle en cas de circonstances aggravantes",
    explanation:
        "Le fascicule souligne la gravité des peines encourues pour ces atteintes à la liberté individuelle.",
    difficulty: "Difficile",
  ),

  // ---------- SANCTIONS CIVILES ----------
  QuizQuestion(
    category: "Sanctions civiles",
    question:
        "La responsabilité de l’État pour une privation de liberté illégale peut être engagée notamment sur le fondement :",
    options: [
      "De l’article 1240 du Code civil",
      "Uniquement d’un arrêté préfectoral",
      "D’un simple règlement intérieur de commissariat",
    ],
    answer: "De l’article 1240 du Code civil",
    explanation:
        "L’article 1240 fonde l’action en responsabilité pour faute d’un agent public.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Sanctions civiles",
    question:
        "La victime d’une détention provisoire injustifiée peut obtenir :",
    options: [
      "Une indemnisation spécifique devant les juridictions compétentes",
      "Uniquement des excuses écrites",
      "Aucune réparation, la détention étant toujours considérée comme un risque normal",
    ],
    answer: "Une indemnisation spécifique devant les juridictions compétentes",
    explanation:
        "Le texte évoque un dispositif de réparation de la détention provisoire injustifiée.",
    difficulty: "Difficile",
  ),

  // ---------- SANCTIONS DISCIPLINAIRES ----------
  QuizQuestion(
    category: "Sanctions disciplinaires",
    question:
        "Le Code de déontologie de la police nationale et de la gendarmerie, à l’article R. 434-17 CSI, rappelle que :",
    options: [
      "Toute personne appréhendée doit être traitée avec dignité et ne subir aucune violence injustifiée",
      "L’aveu obtenu par la force est une preuve normale",
      "La fin justifie les moyens en toute circonstance",
    ],
    answer:
        "Toute personne appréhendée doit être traitée avec dignité et ne subir aucune violence injustifiée",
    explanation:
        "Cet article consacre l’exigence de dignité et l’interdiction des violences injustifiées.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Sanctions disciplinaires",
    question:
        "En cas d’atteinte illégale à la liberté individuelle, les sanctions disciplinaires possibles pour un agent vont :",
    options: [
      "De l’avertissement à la révocation",
      "Uniquement du rappel à l’ordre au blâme",
      "Uniquement de l’amende pénale à la prison",
    ],
    answer: "De l’avertissement à la révocation",
    explanation:
        "Le texte mentionne l’éventail des sanctions : avertissement, exclusion, rétrogradation, jusqu’à la révocation.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Sanctions disciplinaires",
    question:
        "Le fascicule insiste sur le fait qu’une seule mesure irrégulière peut avoir pour l’agent :",
    options: [
      "Un triple impact pénal, civil et disciplinaire",
      "Uniquement un impact moral",
      "Uniquement un impact hiérarchique",
    ],
    answer: "Un triple impact pénal, civil et disciplinaire",
    explanation:
        "D’où l’importance du respect strict des textes et de la rédaction rigoureuse des procès-verbaux.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Liberté d’aller et venir — principes",
    question: "La liberté d’aller et venir est reconnue en France comme :",
    options: [
      "Un principe de valeur constitutionnelle",
      "Un simple principe administratif",
      "Un droit facultatif sans réelle portée",
    ],
    answer: "Un principe de valeur constitutionnelle",
    explanation:
        "Le texte précise que la liberté d’aller et venir est un principe de valeur constitutionnelle dégagé par le Conseil constitutionnel (notamment décision du 12 janvier 1977).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Liberté d’aller et venir — principes",
    question:
        "La liberté d’aller et venir recouvre principalement trois dimensions :",
    options: [
      "Le mouvement, le séjour et la circulation",
      "Le travail, le logement et la santé",
      "La nationalité, la citoyenneté et le vote",
    ],
    answer: "Le mouvement, le séjour et la circulation",
    explanation:
        "Le cours souligne que cette liberté recouvre le mouvement, le séjour et la circulation sur le territoire.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Liberté d’aller et venir — principes",
    question:
        "Les restrictions à la liberté d’aller et venir doivent toujours être :",
    options: [
      "Prévues par la loi, nécessaires, adaptées et proportionnées",
      "Décidées librement par l’autorité de police sans texte",
      "Validées ensuite par un simple rappel à la loi",
    ],
    answer: "Prévues par la loi, nécessaires, adaptées et proportionnées",
    explanation:
        "Le « triptyque à retenir » insiste sur ces quatre exigences : texte, nécessité, adaptation, proportionnalité.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Liberté d’aller et venir — principes",
    question:
        "Pour les nationaux français, la liberté de mouvement sur le territoire est :",
    options: [
      "La règle, les restrictions étant exceptionnelles et encadrées",
      "Toujours subordonnée à un titre de séjour",
      "Réservée aux personnes exerçant une activité professionnelle",
    ],
    answer: "La règle, les restrictions étant exceptionnelles et encadrées",
    explanation:
        "Le texte rappelle que la liberté de mouvement est la règle pour les citoyens français, sous réserve de mesures exceptionnelles prévues par la loi.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Liberté d’aller et venir — principes",
    question:
        "Pour les forces de l’ordre, un bon réflexe opérationnel consiste d’abord à identifier :",
    options: [
      "Si l’on intervient sur le mouvement, le séjour ou la circulation",
      "Le nombre de verbalisations déjà dressées dans la journée",
      "L’opinion politique de la personne contrôlée",
    ],
    answer: "Si l’on intervient sur le mouvement, le séjour ou la circulation",
    explanation:
        "La synthèse finale invite à toujours vérifier sur quel aspect (mouvement, séjour, circulation/permis) porte l’intervention.",
    difficulty: "Facile",
  ),

  // ================== NIVEAU MOYEN ==================
  // --------- CHAPITRE 1 — LIBERTÉ DE MOUVEMENT ---------
  QuizQuestion(
    category: "Liberté de mouvement",
    question: "La liberté de mouvement des personnes physiques correspond à :",
    options: [
      "La faculté de se déplacer et de résider où l’on souhaite sur le territoire",
      "La possibilité de voyager uniquement à l’étranger",
      "Un droit réservé aux seuls titulaires d’un permis de conduire",
    ],
    answer:
        "La faculté de se déplacer et de résider où l’on souhaite sur le territoire",
    explanation:
        "Le cours définit la liberté de mouvement comme la faculté de se déplacer et de résider librement sur le territoire.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Liberté de mouvement",
    question:
        "L’interdiction de séjour, lorsqu’elle est prononcée à l’encontre d’un national français, doit :",
    options: [
      "Être prévue par la loi et placée sous contrôle du juge",
      "Reposer sur une simple décision orale de l’autorité de police",
      "Être systématique en cas de condamnation pénale",
    ],
    answer: "Être prévue par la loi et placée sous contrôle du juge",
    explanation:
        "Le texte précise que ces mesures limitant les déplacements doivent être prévues par la loi et contrôlées par le juge.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Liberté de mouvement",
    question:
        "Pour les étrangers, la liberté de mouvement sur le territoire français est encadrée par :",
    options: [
      "Le Code de l’entrée et du séjour des étrangers et du droit d’asile (CESEDA)",
      "Uniquement le Code de la route",
      "Uniquement des circulaires préfectorales",
    ],
    answer:
        "Le Code de l’entrée et du séjour des étrangers et du droit d’asile (CESEDA)",
    explanation:
        "Le cours rappelle que les conditions d’entrée et de séjour des étrangers sont fixées par le CESEDA.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Liberté de mouvement",
    question: "Les réfugiés bénéficiant de la protection internationale :",
    options: [
      "Ont droit à un titre leur permettant de résider régulièrement en France",
      "Ne peuvent jamais circuler librement en France",
      "N’ont qu’un droit provisoire limité à 3 mois",
    ],
    answer:
        "Ont droit à un titre leur permettant de résider régulièrement en France",
    explanation:
        "Le texte indique que les réfugiés disposent de titres (carte de résident, titre pluriannuel) leur assurant une liberté de mouvement équivalente aux autres étrangers en situation régulière.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Liberté de mouvement",
    question:
        "Les citoyens des États membres de l’Union européenne bénéficient :",
    options: [
      "Du droit à la libre circulation et au libre séjour sous certaines conditions",
      "Des mêmes restrictions que les ressortissants de pays tiers",
      "D’aucun droit particulier en matière de circulation",
    ],
    answer:
        "Du droit à la libre circulation et au libre séjour sous certaines conditions",
    explanation:
        "Ils disposent d’un droit à la libre circulation et au libre séjour, sous réserve notamment de ne pas devenir une charge déraisonnable et de ne pas constituer une menace grave pour l’ordre public.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Liberté de mouvement",
    question: "Les personnes sans résidence ni domicile fixe (SRDF) :",
    options: [
      "Bénéficient d’un droit à la domiciliation auprès de structures agréées",
      "N’ont aucun droit à une adresse administrative",
      "Doivent être systématiquement expulsées des centres-villes",
    ],
    answer:
        "Bénéficient d’un droit à la domiciliation auprès de structures agréées",
    explanation:
        "Le texte mentionne un « droit à la domiciliation » permettant l’accès à certains droits sociaux et civiques.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Liberté de mouvement",
    question: "Les gens du voyage sont notamment concernés par :",
    options: [
      "Des règles particulières de stationnement des résidences mobiles",
      "Une interdiction totale de circuler en France",
      "Une obligation de résidence fixe",
    ],
    answer: "Des règles particulières de stationnement des résidences mobiles",
    explanation:
        "Le cours évoque les schémas départementaux d’accueil, les aires aménagées et les procédures d’évacuation en cas de stationnement illicite.",
    difficulty: "Moyenne",
  ),

  // --------- CHAPITRE 2 — SÉJOUR DES ÉTRANGERS ---------
  QuizQuestion(
    category: "Séjour des étrangers",
    question:
        "Au-delà de trois mois, un étranger majeur qui souhaite rester en France doit :",
    options: [
      "Être titulaire d’un document de séjour (carte ou titre adapté)",
      "Uniquement déclarer sa présence à la mairie",
      "Simplement conserver son billet de retour",
    ],
    answer: "Être titulaire d’un document de séjour (carte ou titre adapté)",
    explanation:
        "Le texte précise que les étrangers majeurs doivent détenir un document de séjour pour un séjour de plus de trois mois.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Séjour des étrangers",
    question: "La carte de séjour pluriannuelle permet en principe un séjour :",
    options: [
      "Jusqu’à quatre ans après un premier séjour régulier",
      "Limité à six mois non renouvelables",
      "Illimité sans condition d’intégration",
    ],
    answer: "Jusqu’à quatre ans après un premier séjour régulier",
    explanation:
        "Le cours mentionne une durée maximale de quatre ans pour la carte pluriannuelle, sous conditions de stabilité et d’intégration.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Séjour des étrangers",
    question: "La carte de résident :",
    options: [
      "Est en principe délivrée pour dix ans renouvelables après plusieurs années de séjour régulier",
      "Est limitée à trois mois non renouvelables",
      "Est réservée aux touristes de passage",
    ],
    answer:
        "Est en principe délivrée pour dix ans renouvelables après plusieurs années de séjour régulier",
    explanation:
        "Le texte précise que la carte de résident offre une stabilité forte, généralement pour dix ans renouvelables.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Séjour des étrangers",
    question: "L’obligation de quitter le territoire français (OQTF) est :",
    options: [
      "Une mesure administrative d’éloignement prise par le préfet",
      "Une simple recommandation sans effets juridiques",
      "Une peine pénale prononcée par le tribunal correctionnel",
    ],
    answer: "Une mesure administrative d’éloignement prise par le préfet",
    explanation:
        "L’OQTF est une décision préfectorale d’éloignement de l’étranger en situation irrégulière, assortie en principe d’un délai de départ volontaire.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Séjour des étrangers",
    question: "L’expulsion d’un étranger est en principe décidée :",
    options: [
      "Par le ministre de l’Intérieur, en cas de menace grave pour l’ordre public",
      "Par le maire de la commune de résidence",
      "Directement par les services de police sans décision ministérielle",
    ],
    answer:
        "Par le ministre de l’Intérieur, en cas de menace grave pour l’ordre public",
    explanation:
        "L’expulsion est une mesure grave décidée en principe par le ministre de l’Intérieur, après avis d’une commission d’expulsion.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Séjour des étrangers",
    question: "L’extradition consiste à :",
    options: [
      "Remettre une personne à un État étranger qui la recherche pour exécution de peine ou poursuites",
      "Expulser un étranger en situation irrégulière sans contrôle judiciaire",
      "Changer la nationalité d’une personne contre son gré",
    ],
    answer:
        "Remettre une personne à un État étranger qui la recherche pour exécution de peine ou poursuites",
    explanation:
        "Le texte définit l’extradition comme la remise d’une personne à un État qui la poursuit ou veut exécuter une peine, encadrée par des conventions et une décision en France.",
    difficulty: "Moyenne",
  ),

  // --------- CHAPITRE 3 — CIRCULATION & PERMIS ---------
  QuizQuestion(
    category: "Police de la circulation",
    question: "Le stationnement sur la voie publique :",
    options: [
      "Est en principe libre, mais peut être limité dans le temps ou l’espace",
      "Est totalement libre sans aucune réglementation",
      "Est réservé aux seuls résidents de la commune",
    ],
    answer:
        "Est en principe libre, mais peut être limité dans le temps ou l’espace",
    explanation:
        "Le texte rappelle que le stationnement est libre mais peut être encadré (durée, zones payantes, etc.) pour la sécurité et la rotation des véhicules.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Police de la circulation",
    question:
        "Les mesures d’évacuation des gens du voyage en cas d’occupation illicite supposent en principe :",
    options: [
      "Une mise en demeure de quitter les lieux, puis éventuellement une autorisation du juge",
      "Une intervention immédiate sans aucune formalité",
      "Une simple décision du chef de patrouille sans texte",
    ],
    answer:
        "Une mise en demeure de quitter les lieux, puis éventuellement une autorisation du juge",
    explanation:
        "Le cours décrit une procédure comprenant mise en demeure et, si nécessaire, saisine du juge pour autoriser l’évacuation forcée.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Police de la circulation",
    question:
        "Le principe d’égalité devant l’usage de la voie publique implique que :",
    options: [
      "Toute restriction repose sur un motif d’intérêt général et s’applique de manière non discriminatoire",
      "Les autorités peuvent réserver la voie publique à certains groupes sans justification",
      "Les étrangers ne peuvent jamais utiliser la voie publique",
    ],
    answer:
        "Toute restriction repose sur un motif d’intérêt général et s’applique de manière non discriminatoire",
    explanation:
        "Le texte insiste sur le fait que les restrictions de circulation doivent être justifiées et non discriminatoires.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Permis de conduire",
    question: "Le permis de conduire est présenté comme :",
    options: [
      "À la fois la clé d’accès à la liberté de circuler en véhicule et un instrument de police administrative",
      "Un simple document d’identité sans autre fonction",
      "Une autorisation uniquement symbolique sans valeur juridique",
    ],
    answer:
        "À la fois la clé d’accès à la liberté de circuler en véhicule et un instrument de police administrative",
    explanation:
        "Le cours le qualifie d’« instrument de police administrative » permettant de sanctionner les comportements dangereux.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Permis de conduire",
    question:
        "En cas d’infraction grave (alcool, stupéfiants, grand excès de vitesse…), les forces de l’ordre peuvent :",
    options: [
      "Procéder à la rétention immédiate du permis de conduire",
      "Se contenter d’un simple avertissement oral",
      "Uniquement dresser un procès-verbal sans toucher au permis",
    ],
    answer: "Procéder à la rétention immédiate du permis de conduire",
    explanation:
        "Le texte prévoit une rétention immédiate, suivie d’une éventuelle suspension administrative par le préfet.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Permis de conduire",
    question: "Le préfet peut interdire la délivrance du permis de conduire :",
    options: [
      "À une personne non titulaire qui a commis une infraction punie de suspension de permis",
      "Uniquement à un mineur",
      "Uniquement sur décision du tribunal administratif",
    ],
    answer:
        "À une personne non titulaire qui a commis une infraction punie de suspension de permis",
    explanation:
        "L’article L. 224-7 du Code de la route permet au préfet d’interdire la délivrance du permis dans ce cas.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Permis de conduire",
    question:
        "La suspension du permis de conduire prononcée par le tribunal peut constituer :",
    options: [
      "Une peine principale, complémentaire ou alternative",
      "Uniquement une mesure administrative",
      "Uniquement une mesure disciplinaire interne",
    ],
    answer: "Une peine principale, complémentaire ou alternative",
    explanation:
        "Le texte précise que le juge pénal peut prononcer la suspension ou l’interdiction de conduire à ces différents titres.",
    difficulty: "Moyenne",
  ),

  // ================== NIVEAU DIFFICILE ==================
  QuizQuestion(
    category: "Liberté d’aller et venir — synthèse",
    question:
        "Parmi les propositions suivantes, laquelle traduit le mieux l’équilibre à trouver pour les personnes itinérantes (gens du voyage, SRDF, etc.) ?",
    options: [
      "Éviter que les mesures de police ne vident la liberté d’aller et venir de tout contenu",
      "Interdire systématiquement leur présence sur le territoire",
      "Tolérer toute installation même dangereuse pour l’ordre public",
    ],
    answer:
        "Éviter que les mesures de police ne vident la liberté d’aller et venir de tout contenu",
    explanation:
        "Le texte évoque explicitement cet équilibre et rappelle le contrôle de proportionnalité exercé par le Conseil d’État.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Séjour & éloignement",
    question:
        "Sur le plan juridique, quelle différence essentielle sépare l’OQTF de l’expulsion ?",
    options: [
      "L’OQTF sanctionne un séjour irrégulier, l’expulsion vise une menace grave pour l’ordre public ou la sécurité de l’État",
      "L’OQTF est décidée uniquement par un juge, l’expulsion par le préfet",
      "L’OQTF ne peut jamais être contestée, contrairement à l’expulsion",
    ],
    answer:
        "L’OQTF sanctionne un séjour irrégulier, l’expulsion vise une menace grave pour l’ordre public ou la sécurité de l’État",
    explanation:
        "Le cours distingue clairement l’OQTF (maintien irrégulier) de l’expulsion (menace grave pour l’ordre public ou la sécurité de l’État).",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Séjour & éloignement",
    question:
        "L’extradition ne peut légalement aboutir, en France, à la remise d’une personne :",
    options: [
      "Si elle risque la peine de mort ou des traitements inhumains ou dégradants",
      "Si elle est simplement recherchée pour une contravention routière",
      "Si elle est de nationalité étrangère",
    ],
    answer:
        "Si elle risque la peine de mort ou des traitements inhumains ou dégradants",
    explanation:
        "Le texte rappelle que la France ne peut extrader une personne risquant la peine de mort ou des traitements contraires aux droits fondamentaux.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizLibertesPubliquesIndividuellesPage extends StatefulWidget {
  static const String routeName =
      '/gpx/generalites/quiz/libertes_publiques_individuelles';

  final String uid;
  final String email;

  const QuizLibertesPubliquesIndividuellesPage({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizLibertesPubliquesIndividuellesPage> createState() =>
      _QuizLibertesPubliquesIndividuellesPageState();
}

class _QuizLibertesPubliquesIndividuellesPageState
    extends State<QuizLibertesPubliquesIndividuellesPage>
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
  int? _historyRowId; // id (int) retour insert quiz_history
  SupabaseClient get _sb => Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _page = PageController(initialPage: 0);
    _rng = math.Random(DateTime.now().millisecondsSinceEpoch);

    // --- Audio ---
    _goodSfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    _badSfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

    // Pré-charge pour éviter le délai au premier play
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

  // ========================================================================
  // HELPERS
  // ========================================================================
  void _seedAndShuffle() {
    final useAll = _mixMode || _selectedDifficulty == null;
    final pool = useAll
        ? questionsLibertesPubliquesIndividuelles
        : questionsLibertesPubliquesIndividuelles
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

  // ========================================================================
  // SUPABASE
  // ========================================================================
  Future<void> _createHistoryOnStart() async {
    try {
      final res = await _sb
          .from('quiz_history')
          .insert({
            'uid': widget.uid,
            'email': widget.email,
            'module_name': 'Généralités',
            'quiz_name': 'Libertés individuelles',
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
            'score': percent, // pourcentage final
            'correct_count': _score, // nb de bonnes réponses
            'finished_at': DateTime.now().toUtc().toIso8601String(),
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _historyRowId!)
          .eq('uid', widget.uid); // important pour la RLS
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
      await _sb.from('quiz_libertes_individuelles').insert({
        'user_uid': widget.uid,
        'email': widget.email,
        'question': question,
        'user_answer': userAnswer,
        'correct_answer': correctAnswer,
        'is_correct': isCorrect,
        'score': _score, // score cumulé au moment T
        'difficulty': difficulty,
      });
    } catch (e) {
      debugPrint('❌ quiz_libertes_individuelles insert failed: $e');
    }
  }

  // ========================================================================
  // AUDIO UTIL
  // ========================================================================
  Future<void> _playAnswerSfx(bool good) async {
    try {
      HapticFeedback.mediumImpact();

      final AudioPlayer p = good ? _goodSfx : _badSfx;
      await p.stop();
      await p.setSource(
        AssetSource(good ? 'sfx/correct_answer.mp3' : 'sfx/wrong_answer.mp3'),
      );
      await p.resume();
    } catch (_) {
      // on ignore les erreurs audio
    }
  }

  // ========================================================================
  // ACTIONS
  // ========================================================================
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

  // ========================================================================
  // UI
  // ========================================================================
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

  // ========================================================================
  // RESULT DIALOG
  // ========================================================================
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
          message: 'Tu maîtrises les libertés individuelles 💪',
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
          message: 'Reprends les cours',
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

// Carte d'explication + couleur résultat
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

// Bandeau qui calcule automatiquement la taille idéale de l'animation
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

// Carte résultat avec anneau qui tourne infiniment
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

// ---------- widgets internes du splash ----------
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
