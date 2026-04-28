// quiz_infraction_page.dart
// Page Quiz des Infractions — visuel et logique 100% identiques à la classification,
// adapté à la table Supabase `quiz_infraction` + même système de logs `quiz_history`.

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

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

/// Banque de questions du **QUIZ INFRACTIONS**
/// Remplis cette liste avec tes questions d'infractions.
/// (tu peux également réutiliser temporairement la banque de classification
/// si besoin — la page fonctionne même si la liste est vide)
final List<QuizQuestion> questionsInfractions = [
  // ===================== FACILE (25) =====================
  QuizQuestion(
    category: 'Élément légal',
    question:
        'Combien d’éléments généraux doivent être réunis pour qu’une infraction existe ?',
    options: ['Deux', 'Trois', 'Quatre'],
    answer: 'Trois',
    explanation:
        'Élément légal, matériel et moral doivent être simultanément réunis.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Élément légal',
    question:
        'Sans texte, il n’y a pas d’infraction : ce principe exprime d’abord…',
    options: [
      'La compétence du juge',
      'Le principe de légalité',
      'Le principe d’opportunité',
    ],
    answer: 'Le principe de légalité',
    explanation: 'Aucun crime ou délit sans texte qui le définit et réprime.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Sources',
    question:
        'La loi détermine crimes et délits et fixe les peines. Vrai ou faux ?',
    options: ['Vrai', 'Faux'],
    answer: 'Vrai',
    explanation:
        'Art. 111-2 C. pén. : la loi fixe la matière criminelle et délictuelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Sources',
    question: 'Les contraventions sont déterminées :',
    options: ['Par la loi', 'Par le règlement', 'Par la coutume'],
    answer: 'Par le règlement',
    explanation:
        'Art. 111-2 al. 2 C. pén. : le règlement détermine et réprime les contraventions.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Sources',
    question:
        'Parmi ces actes, lesquels relèvent du domaine de la loi au sens pénal ?',
    options: [
      'Décisions présidentielles art. 16',
      'Ordonnances ratifiées',
      'Les deux',
    ],
    answer: 'Les deux',
    explanation:
        'Décisions art. 16 et ordonnances ratifiées ont valeur législative.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Sources',
    question: 'Les décrets-lois des IIIe et IVe Républiques :',
    options: [
      'N’ont jamais valeur de loi',
      'Conservent valeur législative',
      'Sont abrogés automatiquement',
    ],
    answer: 'Conservent valeur législative',
    explanation:
        'Ils demeurent des textes assimilés à la loi tant qu’ils ne sont pas abrogés.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Sources',
    question:
        'Les traités internationaux ratifiés et publiés au J.O. ont en France :',
    options: [
      'Une valeur supra-légale',
      'Une valeur infra-réglementaire',
      'Aucune valeur pénale',
    ],
    answer: 'Une valeur supra-légale',
    explanation: 'Constitution 1958, art. 55 : primauté sur la loi interne.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Sources',
    question: 'Un décret d’application non encore paru pour une loi pénale :',
    options: [
      'La loi est immédiatement applicable',
      'La loi est inapplicable tant que le décret manque',
      'La loi est abrogée',
    ],
    answer: 'La loi est inapplicable tant que le décret manque',
    explanation:
        'Sans le décret indispensable, la loi reste « lettre morte ». ',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Sources',
    question: 'Les circulaires ministérielles :',
    options: [
      'Sont une source du droit pénal',
      'N’ont pas valeur normative pénale',
      'Ont la même valeur que la loi',
    ],
    answer: 'N’ont pas valeur normative pénale',
    explanation:
        'Ce sont des instructions de service ; publiées sur site PM ; pas sources de droit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Sources',
    question: 'La jurisprudence en droit pénal :',
    options: [
      'Crée des infractions',
      'Interprète la loi pénale',
      'A valeur de loi',
    ],
    answer: 'Interprète la loi pénale',
    explanation:
        'Principe d’interprétation stricte ; la jurisprudence éclaire sans créer.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Sources',
    question: 'La doctrine :',
    options: [
      'Est une source normative',
      'N’a pas de valeur normative',
      'A valeur de règlement',
    ],
    answer: 'N’a pas de valeur normative',
    explanation:
        'Opinions d’auteurs ; source d’inspiration pour le législateur/juge.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Élément matériel',
    question: 'L’élément matériel est :',
    options: [
      'Un acte positif ou une abstention réprimée',
      'Uniquement un acte positif',
      'Uniquement un résultat',
    ],
    answer: 'Un acte positif ou une abstention réprimée',
    explanation: 'Manifestation concrète de la volonté délictueuse.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Élément matériel',
    question: 'Une pure résolution criminelle (pensée) :',
    options: ['Est punissable', 'N’est pas punissable'],
    answer: 'N’est pas punissable',
    explanation: 'Sans extériorisation réprimée, il n’y a pas d’infraction.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Tentative',
    question:
        'L’infraction non achevée mais commencée peut être réprimée sous la qualification :',
    options: ['Préparation', 'Tentative', 'Résolution'],
    answer: 'Tentative',
    explanation:
        'La tentative sanctionne l’atteinte inachevée dès le commencement d’exécution.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Tentative',
    question: 'Deux éléments classiques de la tentative :',
    options: [
      'Commencement d’exécution et absence de désistement volontaire',
      'Préparation et dommage',
      'Mobile et résultat',
    ],
    answer: 'Commencement d’exécution et absence de désistement volontaire',
    explanation:
        '121-5 : tentative punissable si acte univoque + pas de suspension volontaire.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Tentative',
    question: 'La tentative de contravention :',
    options: ['Peut être punie si prévu', 'N’est jamais punissable'],
    answer: 'N’est jamais punissable',
    explanation:
        '121-4 : tentative non punissable en matière contraventionnelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Élément moral',
    question: 'L’élément moral exige :',
    options: [
      'Le mobile',
      'La conscience et la volonté d’accomplir l’acte illicite',
      'Un dommage',
    ],
    answer: 'La conscience et la volonté d’accomplir l’acte illicite',
    explanation: 'Dol général : intelligence et volonté d’agir.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Élément moral',
    question: 'Le mobile (intérêt, vengeance…) :',
    options: [
      'Conditionne l’existence de l’infraction',
      'Est indifférent à la culpabilité',
    ],
    answer: 'Est indifférent à la culpabilité',
    explanation:
        'Peut influer sur la peine, pas sur la constitution de l’infraction.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Faute intentionnelle',
    question: 'Certaines lois exigent un « dol spécial ». Cela signifie :',
    options: [
      'La volonté d’un résultat particulier',
      'La simple imprudence',
      'Un dommage corporel',
    ],
    answer: 'La volonté d’un résultat particulier',
    explanation: 'Ex. intention de tuer dans l’homicide volontaire.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Faute non intentionnelle',
    question: 'La faute d’imprudence/négligence relève :',
    options: ['De l’élément moral', 'De l’élément matériel', 'D’aucun élément'],
    answer: 'De l’élément moral',
    explanation:
        'Art. 121-3 : imprudence, négligence, manquement à une obligation de prudence ou de sécurité.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Faute non intentionnelle',
    question: 'La faute contraventionnelle résulte :',
    options: [
      'D’une intention de nuire',
      'De la simple violation d’une prescription légale ou réglementaire',
    ],
    answer: 'De la simple violation d’une prescription légale ou réglementaire',
    explanation: 'Indépendante d’un dommage ; ex. feu rouge grillé.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Faute non intentionnelle',
    question:
        'Pour la faute d’imprudence, le comportement de référence est celui :',
    options: [
      'Du meilleur expert',
      'De l’homme normalement prudent et diligent',
    ],
    answer: 'De l’homme normalement prudent et diligent',
    explanation:
        'Appréciation in abstracto, éventuellement par référence au professionnel moyen.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Élément matériel',
    question: 'L’infraction d’omission suppose :',
    options: [
      'Un acte positif',
      'L’abstention de réaliser un acte imposé par la loi',
    ],
    answer: 'L’abstention de réaliser un acte imposé par la loi',
    explanation:
        'Infraction d’omission : non-accomplissement d’un devoir légal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Tentative',
    question:
        'Un acte de préparation (repérage, achat d’outils) sans passage à l’acte :',
    options: [
      'Constitue un commencement d’exécution',
      'Reste non punissable en tant que tel',
    ],
    answer: 'Reste non punissable en tant que tel',
    explanation: 'La préparation seule n’est pas punie, sauf texte spécial.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Schéma',
    question:
        'Dans le schéma de l’élément matériel, l’« acte négatif » renvoie à :',
    options: ['Une abstention', 'Une destruction', 'Un résultat'],
    answer: 'Une abstention',
    explanation: 'Acte négatif = attitude passive prohibée par un texte.',
    difficulty: 'Facile',
  ),

  // ===================== MOYENNE (25) =====================
  QuizQuestion(
    category: 'Sources',
    question: 'Les ordonnances (art. 38 C°) non ratifiées :',
    options: [
      'Ont valeur de loi',
      'Restent de nature réglementaire',
      'Sont nulles',
    ],
    answer: 'Restent de nature réglementaire',
    explanation: 'Elles n’acquièrent valeur législative qu’après ratification.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Sources',
    question:
        'Les décisions prises par le Président en vertu de l’article 16 de la Constitution :',
    options: ['Valeur législative', 'Valeur réglementaire', 'Aucune valeur'],
    answer: 'Valeur législative',
    explanation: 'Actes de crise dotés d’une valeur assimilée à la loi.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Sources',
    question: 'Un règlement administratif contraire à la loi pénale :',
    options: ['Peut s’appliquer', 'Est écarté par le juge pénal'],
    answer: 'Est écarté par le juge pénal',
    explanation: 'Hiérarchie des normes : la loi prime.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Sources',
    question:
        'Les textes pénaux peuvent-ils être issus de traités européens relatifs aux droits fondamentaux ?',
    options: ['Oui, via leur effet direct et primauté', 'Non, jamais'],
    answer: 'Oui, via leur effet direct et primauté',
    explanation: 'CEDH/UE influent et s’imposent à la loi interne publiée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Élément matériel',
    question: 'La pluralité d’actes peut former l’élément matériel lorsque :',
    options: [
      'Ils s’échelonnent sans lien',
      'Ils s’enchaînent vers une même atteinte prohibée',
    ],
    answer: 'Ils s’enchaînent vers une même atteinte prohibée',
    explanation: 'Unité d’action possible (même dessein délictueux).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Élément matériel',
    question:
        'Résolution criminelle non suivie d’effet socialement troublant :',
    options: ['Punissable', 'Non punissable'],
    answer: 'Non punissable',
    explanation: 'Il faut manifestation extérieure réprimée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tentative',
    question: 'Le commencement d’exécution doit être :',
    options: [
      'Équivoque et préparatoire',
      'Univoque et révélateur de l’infraction déterminée',
    ],
    answer: 'Univoque et révélateur de l’infraction déterminée',
    explanation:
        'Jurisprudence : acte caractéristique + intention irrévocable.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tentative',
    question: 'Le simple fait d’exprimer son intention de voler à voix haute :',
    options: ['Tentative punissable', 'Pas punissable'],
    answer: 'Pas punissable',
    explanation: 'Extériorisation d’intention seule insuffisante.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tentative',
    question: 'Désistement volontaire :',
    options: ['Exclut la tentative punissable', 'N’a aucun effet'],
    answer: 'Exclut la tentative punissable',
    explanation:
        'S’il résulte d’une décision libre non due à une cause extérieure.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tentative',
    question: 'Désistement dû à l’alarme d’un coffre-fort :',
    options: ['Volontaire', 'Non volontaire'],
    answer: 'Non volontaire',
    explanation: 'Cause extérieure : tentative reste punissable.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tentative',
    question:
        'Infraction manquée (exécution complète mais résultat non atteint par circonstances indépendantes) :',
    options: ['Punissable comme tentative', 'Non punissable'],
    answer: 'Punissable comme tentative',
    explanation: '121-5 : répression de l’infraction manquée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tentative',
    question:
        'Infraction impossible (poche vide / arme factice ignorée de l’auteur) :',
    options: ['Jamais réprimée', 'Réprimée si la tentative est prévue'],
    answer: 'Réprimée si la tentative est prévue',
    explanation:
        'Punissable quand le texte incrimine la tentative (crimes/certains délits).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Élément moral',
    question: 'L’élément moral non intentionnel suppose :',
    options: [
      'Imprudence/négligence ou manquement à une obligation de prudence/sécurité',
      'L’intention de nuire',
    ],
    answer:
        'Imprudence/négligence ou manquement à une obligation de prudence/sécurité',
    explanation: 'Art. 121-3 al. 3.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Élément moral',
    question:
        'Preuve du lien de causalité en matière de faute non intentionnelle :',
    options: [
      'Toujours directe',
      'Peut être indirecte mais doit être caractérisée',
    ],
    answer: 'Peut être indirecte mais doit être caractérisée',
    explanation: 'Nécessité de démontrer la causalité de la faute au dommage.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Faute non intentionnelle',
    question: 'La mise en danger délibérée d’autrui consiste :',
    options: [
      'À exposer autrui à un risque que l’on ne pouvait ignorer',
      'À causer nécessairement un dommage',
    ],
    answer: 'À exposer autrui à un risque que l’on ne pouvait ignorer',
    explanation:
        'Violation manifestement délibérée d’une obligation particulière de prudence/sécurité.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Faute non intentionnelle',
    question: 'Exemple classique de mise en danger délibérée :',
    options: [
      'Entrepreneur faisant monter des ouvriers sur un échafaudage non conforme',
      'Automobiliste respectant la signalisation',
    ],
    answer:
        'Entrepreneur faisant monter des ouvriers sur un échafaudage non conforme',
    explanation: 'Violation délibérée des normes de sécurité.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Faute non intentionnelle',
    question:
        'La faute contraventionnelle permet sanction sans intention ni dommage :',
    options: ['Vrai', 'Faux'],
    answer: 'Vrai',
    explanation: 'Le simple non-respect d’une prescription suffit.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Schéma',
    question: 'Dans le schéma, l’infraction par commission correspond à :',
    options: [
      'Un acte interdit par la loi',
      'Une simple abstention',
      'Un résultat sans acte',
    ],
    answer: 'Un acte interdit par la loi',
    explanation: 'Commission = accomplir un comportement prohibé.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Schéma',
    question: 'Dans le schéma de l’élément moral, « dol général » signifie :',
    options: [
      'Volonté d’un résultat précis',
      'Conscience et volonté d’accomplir l’acte défendu',
    ],
    answer: 'Conscience et volonté d’accomplir l’acte défendu',
    explanation: 'À distinguer du dol spécial (résultat particulier).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Élément légal',
    question: 'La Constitution de 1958 est-elle source du droit pénal ?',
    options: ['Oui, comme norme suprême', 'Non'],
    answer: 'Oui, comme norme suprême',
    explanation: 'Les sources essentielles du droit pénal s’y rattachent.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Élément légal',
    question:
        'Un règlement administratif hiérarchisé peut-il méconnaître la loi pénale ?',
    options: ['Oui', 'Non'],
    answer: 'Non',
    explanation: 'Un règlement contraire est illégal et écarté.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Jurisprudence/Doctrine',
    question:
        'La jurisprudence peut-elle aggraver une incrimination au-delà du texte clair ?',
    options: ['Oui', 'Non'],
    answer: 'Non',
    explanation: 'Interprétation stricte de la loi pénale.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tentative',
    question:
        'L’auteur qui renonce librement avant la consommation, sans cause extérieure :',
    options: ['Reste punissable de tentative', 'Échappe à la tentative'],
    answer: 'Échappe à la tentative',
    explanation: 'Désistement volontaire exclut la tentative punissable.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Faute non intentionnelle',
    question:
        'La violation d’un texte (loi/règlement) peut suffire à caractériser :',
    options: ['Une faute pénale non intentionnelle', 'Un dol spécial'],
    answer: 'Une faute pénale non intentionnelle',
    explanation: 'Manquement à une obligation de prudence ou sécurité.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Faute contraventionnelle',
    question: 'Automobiliste grillant un feu rouge par inattention :',
    options: ['Infraction intentionnelle', 'Faute contraventionnelle'],
    answer: 'Faute contraventionnelle',
    explanation: 'Simple violation d’une prescription sans intention requise.',
    difficulty: 'Moyenne',
  ),

  // ===================== DIFFICILE (25) =====================
  QuizQuestion(
    category: 'Sources',
    question: 'Pour être invocable, un traité international doit être :',
    options: [
      'Simplement signé',
      'Signé, ratifié et publié',
      'Ratifié uniquement',
    ],
    answer: 'Signé, ratifié et publié',
    explanation: 'Condition d’applicabilité interne et primauté (art. 55 C°).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Sources',
    question: 'Les circulaires non publiées :',
    options: [
      'Sont réputées abrogées',
      'Sont sans valeur normative et non opposables',
    ],
    answer: 'Sont sans valeur normative et non opposables',
    explanation: 'Elles guident le service mais ne créent pas d’infractions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Sources',
    question:
        'La valeur des décisions art. 16 et des ordonnances ratifiées permet :',
    options: ['De créer crimes/délits', 'D’interpréter uniquement'],
    answer: 'De créer crimes/délits',
    explanation:
        'Valeur législative donc compétence en matière criminelle/délictuelle.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Élément matériel',
    question: 'Actes préparatoires :',
    options: ['Toujours punissables', 'Non punissables sauf texte spécial'],
    answer: 'Non punissables sauf texte spécial',
    explanation:
        'Le code ne retient que la tentative après commencement d’exécution.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tentative',
    question: 'Commencement d’exécution apprécié par la Cour de cassation :',
    options: [
      'Question de droit contrôlée par la Cour',
      'Question de fait souveraine des juges du fond',
    ],
    answer: 'Question de droit contrôlée par la Cour',
    explanation: 'La Cour exige acte univoque et intention d’aboutir.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tentative',
    question: 'Caractérisation typique du commencement d’exécution :',
    options: [
      'Acte équivoque compatible avec plusieurs infractions',
      'Acte univoque révélant l’infraction précisément visée',
    ],
    answer: 'Acte univoque révélant l’infraction précisément visée',
    explanation: 'Double exigence jurisprudentielle.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tentative',
    question:
        'Après infraction consommée, l’attitude postérieure de l’auteur (restitution) :',
    options: [
      'Supprime la responsabilité',
      'Peut influer seulement sur la peine',
    ],
    answer: 'Peut influer seulement sur la peine',
    explanation: 'Elle n’efface pas la consommation de l’infraction.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tentative',
    question:
        'Dans l’infraction impossible, l’auteur ignorait l’impossibilité. Conséquence :',
    options: ['Impunit é totale', 'Punissable si tentative incriminée'],
    answer: 'Punissable si tentative incriminée',
    explanation: 'Pickpocket poche vide, coup de feu à blanc.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Élément moral',
    question:
        'Pour les infractions intentionnelles, la connaissance du caractère illicite de l’acte :',
    options: ['Est indifférente', 'Est requise au titre du dol général'],
    answer: 'Est requise au titre du dol général',
    explanation: 'Conscience et volonté d’accomplir l’acte interdit.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Élément moral',
    question: 'Résultat obtenu exactement conforme au résultat voulu :',
    options: ['Dol spécial aggravé', 'Preuve du dol général'],
    answer: 'Preuve du dol général',
    explanation: 'Résultat déterminé recherché par l’auteur.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Élément moral',
    question:
        'Résultat au-delà de l’intention (ex. coups volontaires entraînant la mort) :',
    options: ['Dol spécial de tuer', 'Praeter-intentionnel'],
    answer: 'Praeter-intentionnel',
    explanation:
        'L’agent n’a pas voulu la mort mais l’a causée (ex. art. 222-7 C. pén. pour la qualification).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Faute non intentionnelle',
    question: 'La faute d’imprudence se mesure :',
    options: [
      'Au comportement réellement observé par l’auteur',
      'Au standard abstrait d’un homme normalement prudent',
    ],
    answer: 'Au standard abstrait d’un homme normalement prudent',
    explanation:
        'Appréciation in abstracto, avec référence professionnelle au besoin.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Faute non intentionnelle',
    question: 'Lien de causalité indirect en matière de négligence :',
    options: [
      'Suffit à engager la responsabilité s’il est caractérisé',
      'Est insuffisant par principe',
    ],
    answer: 'Suffit à engager la responsabilité s’il est caractérisé',
    explanation: 'Il faut établir l’enchaînement causal.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Faute non intentionnelle',
    question:
        'La faute caractérisée exposant autrui à un risque que l’on ne pouvait ignorer :',
    options: ['Relève du dol spécial', 'Relève de la mise en danger délibérée'],
    answer: 'Relève de la mise en danger délibérée',
    explanation:
        'Violation manifestement délibérée d’une obligation particulière.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Schéma',
    question:
        'Dans le schéma de l’élément moral, la « faute » se subdivise notamment en :',
    options: [
      'Intentionnelle et non intentionnelle',
      'Dommageable et non dommageable',
    ],
    answer: 'Intentionnelle et non intentionnelle',
    explanation: 'Deux grandes branches du versant moral.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Élément légal',
    question: 'Les textes pénaux étrangers :',
    options: [
      'S’appliquent directement en France',
      'Ne s’appliquent pas, sauf via traités et règles de compétence',
    ],
    answer: 'Ne s’appliquent pas, sauf via traités et règles de compétence',
    explanation: 'Principe de territorialité modulé par conventions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Sources',
    question:
        'L’interprétation des juges du fond contraire à la lettre du texte pénal :',
    options: [
      'Peut créer une infraction',
      'Est censurée au nom de la légalité',
    ],
    answer: 'Est censurée au nom de la légalité',
    explanation: 'Interprétation stricte ; pas d’analogie in malam partem.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tentative',
    question:
        'Un acte univoque + intention de réaliser l’infraction mais renoncement par remords :',
    options: ['Tentative punissable', 'Non punissable'],
    answer: 'Non punissable',
    explanation: 'Désistement volontaire avéré.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Faute contraventionnelle',
    question: 'La responsabilité peut être exclue en cas de :',
    options: ['Force majeure ou contrainte', 'Absence de dommage uniquement'],
    answer: 'Force majeure ou contrainte',
    explanation: 'Toujours invocable comme cause d’irresponsabilité.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Élément matériel',
    question: 'Un résultat dommageable peut-il être exigé ?',
    options: ['Oui pour les infractions matérielles', 'Jamais'],
    answer: 'Oui pour les infractions matérielles',
    explanation:
        'Certains délits exigent un résultat (ex. blessures involontaires).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Élément matériel',
    question: 'Dans les infractions formelles :',
    options: ['Le résultat est exigé', 'Le résultat n’est pas exigé'],
    answer: 'Le résultat n’est pas exigé',
    explanation: 'La seule réalisation de l’acte suffit.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Élément moral',
    question: 'Le dol spécial constitue :',
    options: [
      'Une circonstance aggravante autonome',
      'Un élément constitutif additionnel prévu par le texte',
    ],
    answer: 'Un élément constitutif additionnel prévu par le texte',
    explanation: 'Il doit être expressément exigé.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Sources',
    question:
        'La publication d’une circulaire au site du Premier ministre vise :',
    options: [
      'À créer du droit pénal',
      'À assurer la publicité administrative des instructions',
    ],
    answer: 'À assurer la publicité administrative des instructions',
    explanation: 'Transparence des instructions ; valeur non normative.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Schéma',
    question:
        'Dans le schéma « élément matériel – conditions », l’attitude passive visée entraîne :',
    options: [
      'Toujours une infraction',
      'Infraction seulement si un texte la réprime',
    ],
    answer: 'Infraction seulement si un texte la réprime',
    explanation: 'Omission pénale = obligation légale préalable.',
    difficulty: 'Difficile',
  ),

  // ===================== EXPERT (25) =====================
  QuizQuestion(
    category: 'Sources',
    question:
        'Peut-on fonder une incrimination uniquement sur une jurisprudence constante (sans texte) ?',
    options: ['Oui si constante', 'Non, jamais'],
    answer: 'Non, jamais',
    explanation:
        'Légalité criminelle : seule la loi (ou traités/valeur législative) crée l’infraction.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Sources',
    question:
        'Les règlements administratifs (décrets, arrêtés) : hiérarchie interne ?',
    options: [
      'Peuvent contredire une circulaire',
      'Ne peuvent jamais contredire la loi ou les traités',
    ],
    answer: 'Ne peuvent jamais contredire la loi ou les traités',
    explanation: 'Principe de hiérarchie des normes.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Sources',
    question: 'Un traité non publié mais signé et ratifié :',
    options: ['Est invocable devant le juge pénal', 'Ne l’est pas'],
    answer: 'Ne l’est pas',
    explanation: 'La publication conditionne l’applicabilité interne.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Tentative',
    question:
        'L’« acte univoque » caractéristique du commencement d’exécution :',
    options: [
      'Doit être incompatible avec un comportement licite',
      'Peut rester compatible avec une conduite licite',
    ],
    answer: 'Doit être incompatible avec un comportement licite',
    explanation: 'Il doit manifester la proximité de l’infraction déterminée.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Tentative',
    question:
        'Affaire où le paiement d’un tueur à gages a été jugé préparation et non tentative :',
    options: ['Affaire Lacour 1962', 'Affaire Perdereau 1986'],
    answer: 'Affaire Lacour 1962',
    explanation:
        'La remise d’argent ne constituait pas un acte univoque d’exécution.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Tentative',
    question:
        'Tentative d’évasion par creusement du béton autour d’une fenêtre de cellule :',
    options: ['Préparation', 'Commencement d’exécution'],
    answer: 'Commencement d’exécution',
    explanation:
        'Appréciation jurisprudentielle : acte matériel caractéristique.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Tentative',
    question: 'La tentative « manquée » est punie car :',
    options: [
      'Le résultat fait défaut pour des raisons indépendantes de la volonté',
      'Il n’y avait aucune intention',
    ],
    answer:
        'Le résultat fait défaut pour des raisons indépendantes de la volonté',
    explanation: 'Ex. tir manqué par maladresse.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Tentative',
    question: 'La tentative « impossible » n’est punissable que si :',
    options: ['Le texte l’a expressément prévu', 'Il existe un dommage'],
    answer: 'Le texte l’a expressément prévu',
    explanation:
        'Punissable dans les crimes et certains délits où la tentative est incriminée.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Élément moral',
    question: 'La prévisibilité du dommage en imprudence :',
    options: ['Est indifférente', 'Est centrale pour caractériser la faute'],
    answer: 'Est centrale pour caractériser la faute',
    explanation:
        'On reproche de ne pas avoir prévu ce qu’un prudent aurait prévu.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Élément moral',
    question: 'Praeter-intention :',
    options: [
      'Intention d’atteindre un résultat déterminé mais résultat plus grave survient',
      'Absence de tout résultat',
    ],
    answer:
        'Intention d’atteindre un résultat déterminé mais résultat plus grave survient',
    explanation:
        'Ex. violences volontaires ayant entraîné la mort sans intention de la donner.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Faute non intentionnelle',
    question: 'Pour la mise en danger délibérée, il faut :',
    options: [
      'Une violation manifestement délibérée d’une obligation particulière',
      'Une simple inattention',
    ],
    answer:
        'Une violation manifestement délibérée d’une obligation particulière',
    explanation:
        'Et exposition d’autrui à un risque grave que l’on ne pouvait ignorer.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Faute non intentionnelle',
    question: 'Lien de causalité indirect et pluralité de fautes :',
    options: [
      'Empêche toute responsabilité pénale',
      'N’exclut pas la responsabilité si la faute a contribué au dommage',
    ],
    answer: 'N’exclut pas la responsabilité si la faute a contribué au dommage',
    explanation: 'La causalité juridique peut être multiple.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Faute contraventionnelle',
    question:
        'Exemple jurisprudentiel de prudence routière : obligation de maintenir son véhicule près du bord droit de la chaussée. La violation caractérise :',
    options: ['Un dol général', 'Une faute contraventionnelle'],
    answer: 'Une faute contraventionnelle',
    explanation: 'Cass. crim. 12 nov. 1997 (réf. citée dans le document).',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Sources',
    question:
        'Quand un décret manque pour permettre l’entrée en vigueur d’une loi pénale :',
    options: [
      'La loi s’applique quand même',
      'Le texte reste inopérant jusqu’à parution du décret',
    ],
    answer: 'Le texte reste inopérant jusqu’à parution du décret',
    explanation: 'Le document précise que la loi reste « lettre morte ».',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Élément matériel',
    question:
        'Une série d’actions espacées mais poursuivant un même dessein délictueux :',
    options: [
      'Peut constituer une seule infraction',
      'Constitue toujours plusieurs infractions',
    ],
    answer: 'Peut constituer une seule infraction',
    explanation:
        'Unité d’action si lien de causalité et continuité d’intention.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Élément moral',
    question:
        'Dans les infractions matérielles non intentionnelles, l’élément moral se déduit :',
    options: [
      'Du dommage seul',
      'Du manquement à une obligation et du lien causal',
    ],
    answer: 'Du manquement à une obligation et du lien causal',
    explanation: 'Il faut rattacher la faute au dommage.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Schéma',
    question: 'Dans le schéma de la faute intentionnelle, la préméditation :',
    options: [
      'Aggrave le dol mais n’est pas nécessaire',
      'Est toujours exigée',
    ],
    answer: 'Aggrave le dol mais n’est pas nécessaire',
    explanation:
        'La préméditation est une circonstance aggravante dans certains textes.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Jurisprudence',
    question: 'La Cour de cassation contrôle :',
    options: [
      'L’existence du commencement d’exécution en droit',
      'Seulement la peine',
    ],
    answer: 'L’existence du commencement d’exécution en droit',
    explanation: 'Elle fixe les critères (acte univoque + intention).',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Sources',
    question: 'Les « décrets-lois » antérieurs à 1958 :',
    options: [
      'Sont dépourvus d’effet',
      'Reste des textes de valeur législative tant qu’ils subsistent',
    ],
    answer: 'Reste des textes de valeur législative tant qu’ils subsistent',
    explanation: 'Le document les mentionne comme actes à valeur de loi.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Tentative',
    question: 'La tentative d’un crime est :',
    options: [
      'Punissable de plein droit',
      'Punissable seulement si un décret le prévoit',
    ],
    answer: 'Punissable de plein droit',
    explanation: 'Principe général du code pénal (121-4/121-5).',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Faute non intentionnelle',
    question:
        'Quand l’auteur viole délibérément un texte de sécurité, la caractérisation de la faute :',
    options: [
      'Exige un dommage',
      'Peut être établie même sans dommage en cas d’infraction formelle',
    ],
    answer: 'Peut être établie même sans dommage en cas d’infraction formelle',
    explanation:
        'Certaines infractions de mise en danger n’exigent pas de dommage réalisé.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Élément légal',
    question:
        'La valeur des circulaires de la DACG (chancellerie) en matière pénale :',
    options: ['Normative', 'Interprétative/indicative'],
    answer: 'Interprétative/indicative',
    explanation: 'Ne créent pas d’infractions ; orientent la pratique.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Élément matériel',
    question: 'L’« infraction consommée » se distingue de la tentative par :',
    options: [
      'La seule intention',
      'La réalisation complète des éléments matériels',
    ],
    answer: 'La réalisation complète des éléments matériels',
    explanation: 'Tous les éléments constitutifs sont accomplis.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Élément moral',
    question:
        'Quand le résultat est indéterminé et non connu à l’avance de l’auteur (ex. résultat aléatoire) :',
    options: ['Le dol spécial est établi', 'Le dol spécial n’est pas établi'],
    answer: 'Le dol spécial n’est pas établi',
    explanation: 'Le texte exige un résultat déterminé pour le dol spécial.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Faute contraventionnelle',
    question:
        'La preuve de la contrainte en matière de faute contraventionnelle :',
    options: ['Est indifférente', 'Peut dégager la responsabilité de l’auteur'],
    answer: 'Peut dégager la responsabilité de l’auteur',
    explanation:
        'Contrainte/force majeure restent des causes d’irresponsabilité.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Sources',
    question:
        'Peut-on déroger par circulaire à une incrimination réglementaire existante ?',
    options: ['Oui', 'Non'],
    answer: 'Non',
    explanation:
        'La circulaire ne peut ni abroger ni modifier un texte normatif.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Tentative',
    question:
        'Après désistement volontaire, si un complice poursuit seul et consomme l’infraction :',
    options: [
      'Le premier est co-auteur',
      'Le premier n’est pas punissable de tentative',
    ],
    answer: 'Le premier n’est pas punissable de tentative',
    explanation: 'Son renoncement libre l’exonère de la tentative.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'Élément matériel',
    question: 'Une abstention fautive n’est pénale que si :',
    options: [
      'Le juge l’estime moralement répréhensible',
      'Un texte impose l’acte non accompli',
    ],
    answer: 'Un texte impose l’acte non accompli',
    explanation: 'Principe de légalité des omissions.',
    difficulty: 'Expert',
  ),
];

// ============================================================================
// PAGE — Quiz des Infractions
// ============================================================================
class QuizInfractionsPage extends StatefulWidget {
  static const String routeName = '/gpx/infractions/quiz/infractions';

  final String uid;
  final String email;

  const QuizInfractionsPage({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizInfractionsPage> createState() => _QuizInfractionsPageState();
}

class _QuizInfractionsPageState extends State<QuizInfractionsPage>
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
  String?
  _selectedDifficulty; // "facile" | "moyenne" | "difficile" (token normalisé)
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
  User? _user; // snapshot d’utilisateur

  User _requireUser() {
    final u = _sb.auth.currentUser ?? _user;
    if (u == null) {
      throw StateError('Aucun utilisateur connecté.');
    }
    _user = u;
    return u;
  }

  @override
  void initState() {
    super.initState();
    _page = PageController(initialPage: 0);
    _rng = math.Random(DateTime.now().millisecondsSinceEpoch);

    // --- Audio ---
    _goodSfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    _badSfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

    // Précharge
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

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  /// Retourne un token **normalisé** pour la difficulté.
  String _difficultyToken(String? raw) {
    if (raw == null) return '';
    final t = raw.trim().toLowerCase();
    if (t == 'facile') return 'facile';
    if (t == 'moyen' || t == 'moyenne') return 'moyenne';
    if (t == 'difficile') return 'difficile';
    return t;
  }

  void _seedAndShuffle() {
    final useAll = _mixMode || _selectedDifficulty == null;
    final selectedToken = _difficultyToken(_selectedDifficulty);

    final filtered = useAll
        ? questionsInfractions
        : questionsInfractions
              .where((q) => _difficultyToken(q.difficulty) == selectedToken)
              .toList();

    // Fallback si aucune question ne matche (ou si la banque est vide)
    final pool = filtered.isEmpty ? questionsInfractions : filtered;

    _qs = List<QuizQuestion>.from(pool)..shuffle(_rng);
    _opts = _qs
        .map((q) => (List<String>.from(q.options)..shuffle(_rng)))
        .toList();
    _answers = List<String?>.filled(_qs.length, null);
    _hasQuiz = true;

    debugPrint(
      '🎯 Start quiz INFRACTIONS — mix=$_mixMode, selected=$_selectedDifficulty → ${_qs.length} questions',
    );
  }

  // ==========================================================================
  // SUPABASE
  // ==========================================================================
  Future<void> _createHistoryOnStart() async {
    try {
      final u = _requireUser();
      final nowUtc = DateTime.now().toUtc().toIso8601String();

      final res = await _sb
          .from('quiz_history')
          .insert({
            'uid': u.id,
            'email': u.email ?? '',
            'module_name': 'Infractions',
            'quiz_name': 'Quiz des infractions',
            'score': 0,
            'total_questions': _qs.length,
            'correct_count': 0,
            'started_at': nowUtc,
            // champs not null → on pose une valeur initiale
            'finished_at': nowUtc,
            'completed_at': nowUtc,
          })
          .select('id')
          .single();

      _historyRowId = (res['id'] as num).toInt();
      debugPrint('✅ quiz_history (infractions) start id=$_historyRowId');
    } on PostgrestException catch (e) {
      debugPrint(
        '❌ quiz_history (infractions start) Postgrest: ${e.message} | ${e.details}',
      );
    } catch (e, st) {
      debugPrint('❌ quiz_history (infractions start) error: $e\n$st');
    }
  }

  Future<void> _updateHistoryOnFinish() async {
    if (_historyRowId == null) return;
    try {
      final u = _requireUser();
      final int total = _qs.length.clamp(1, 1 << 30);
      final int percent = ((_score / total) * 100).round();

      final res = await _sb
          .from('quiz_history')
          .update({
            'score': percent,
            'correct_count': _score,
            'finished_at': DateTime.now().toUtc().toIso8601String(),
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _historyRowId!)
          .eq('uid', u.id)
          .select('id')
          .maybeSingle();

      debugPrint('✅ quiz_history (infractions) finish updated: $res');
    } on PostgrestException catch (e) {
      debugPrint(
        '❌ quiz_history (infractions finish) Postgrest: ${e.message} | ${e.details}',
      );
    } catch (e, st) {
      debugPrint('❌ quiz_history (infractions finish) error: $e\n$st');
    }
  }

  Future<void> _saveAnswer({
    required String question,
    required String userAnswer,
    required String correctAnswer,
    required bool isCorrect,
  }) async {
    try {
      final u = _requireUser();
      final res = await _sb
          .from('quiz_infraction') // ✅ table cible du screenshot
          .insert({
            'uid': u.id,
            'email': u.email ?? '',
            'question': question,
            'user_answer': userAnswer,
            'correct_answer': correctAnswer,
            'is_correct': isCorrect,
            // created_at géré par la DB (timestamp with time zone)
          })
          .select('id')
          .single();

      final color = isCorrect ? '\x1B[32m' : '\x1B[31m';
      const reset = '\x1B[0m';
      debugPrint(
        '$color📝 [quiz_infraction] #${res['id']} ${isCorrect ? "✔️ Correct" : "❌ Incorrect"}$reset',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        '❌ quiz_infraction insert Postgrest: ${e.message} | ${e.details}',
      );
    } catch (e, st) {
      debugPrint('❌ quiz_infraction insert error: $e\n$st');
    }
  }

  // ==========================================================================
  // AUDIO UTIL
  // ==========================================================================
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

  // ==========================================================================
  // ACTIONS
  // ==========================================================================
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

  // ==========================================================================
  // UI
  // ==========================================================================
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

  // ==========================================================================
  // RESULT DIALOG
  // ==========================================================================
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
          message: 'Tu maîtrises les infractions ✨',
        );
      } else if (pct >= 50) {
        AppNotifier.info(
          context,
          title: 'Bien joué',
          message: 'Encore un petit effort 📈',
        );
      } else {
        AppNotifier.warning(
          context,
          title: 'À retravailler',
          message: 'Revois la leçon et retente 🔁',
        );
      }
    });
  }
}

// ============================================================================
// WIDGETS — copié-collé à l’identique (visuel strictement identique)
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              dot(selected || correct || wrong),
              const SizedBox(width: 14),
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
        // t normalisé 0..1
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
                                value: null,
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
// SPLASH: Choix de difficulté — full-screen, FR + bouton ALÉATOIRE
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
  // -- Controllers d’animation (identiques au design initial)
  late final AnimationController _bgCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat(reverse: true);

  late final AnimationController _floatCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat(reverse: true);

  // ---------------------------
  // Normalisation des difficultés
  // ---------------------------
  String _norm(String? s) {
    if (s == null) return '';
    final t = s.trim().toLowerCase();
    if (t == 'facile') return 'facile';
    if (t == 'moyen' || t == 'moyenne') return 'moyenne';
    if (t == 'difficile') return 'difficile';
    return t; // laisse passer mais restera non-match
  }

  /// True si la difficulté sélectionnée correspond au token voulu.
  bool _is(String token) => _norm(widget.selected) == token;

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
            // Fond dégradé animé + halos
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

                        // Cartes de niveau
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
                                active: _is('facile'),
                                onTap: () => widget.onSelect('facile'),
                                isDark: isDark,
                                floatCtrl: _floatCtrl,
                              ),
                              _LevelCard(
                                label: 'Moyen',
                                emoji: '🏅',
                                tint: const Color(0xFFFCE7B2),
                                active: _is('moyenne'),
                                onTap: () => widget.onSelect('moyenne'),
                                isDark: isDark,
                                floatCtrl: _floatCtrl,
                                floatDelay: .15,
                              ),
                              _LevelCard(
                                label: 'Difficile',
                                emoji: '🏆',
                                tint: const Color(0xFFF8C2BE),
                                active: _is('difficile'),
                                onTap: () => widget.onSelect('difficile'),
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
