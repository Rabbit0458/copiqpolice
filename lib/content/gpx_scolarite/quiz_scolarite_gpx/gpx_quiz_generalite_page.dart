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

/// =============================================================
///  QUIZ — CADRE LÉGAL D’USAGE DES ARMES (art. L. 435-1
///  du Code de la sécurité intérieure + lien avec la légitime
///  défense art. 122-5 du Code pénal)
///
///  Remplace ton ancien tableau par celui-ci.
///  (tu peux bien sûr l’enrichir encore si besoin)
/// =============================================================

final List<QuizQuestion> questionsGeneralitePage = [
  // =========================
  //         FACILE
  // =========================
  const QuizQuestion(
    category: 'Juridictions',
    question: 'Quelle juridiction est compétente pour juger les crimes ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Cour d’assises',
    explanation:
        'Crimes → cour d’assises (ou, pour certains crimes, cour criminelle départementale).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Définition',
    question: 'Qu’est-ce que la complicité en droit pénal français ?',
    options: [
      'La participation à plusieurs à une infraction sans accord préalable',
      'L’entente momentanée entre deux ou plusieurs personnes en vue d’accomplir une infraction déterminée',
      'Toute présence sur les lieux d’une infraction, même passive',
    ],
    answer:
        'L’entente momentanée entre deux ou plusieurs personnes en vue d’accomplir une infraction déterminée',
    explanation:
        'Le cours précise que la complicité consiste en une entente momentanée entre plusieurs personnes dans le but d’accomplir une infraction déterminée.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Acteurs',
    question:
        'Le complice est celui qui, selon l’article 121-7 du Code pénal, est…',
    options: [
      'Celui qui réalise tous les éléments constitutifs de l’infraction',
      'Celui qui aide ou assiste l’auteur dans la préparation ou l’exécution de l’infraction',
      'Celui qui se contente de désapprouver l’infraction',
    ],
    answer:
        'Celui qui aide ou assiste l’auteur dans la préparation ou l’exécution de l’infraction',
    explanation:
        'Art. 121-7 C. pén. : est complice celui qui, volontairement, aide ou assiste l’auteur dans la préparation ou la consommation de l’infraction.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Acteurs',
    question: 'Qui est le coauteur d’une infraction ?',
    options: [
      'Celui qui filme la scène',
      'Celui qui réalise tout ou partie des éléments constitutifs de l’infraction',
      'Celui qui se contente d’être présent',
    ],
    answer:
        'Celui qui réalise tout ou partie des éléments constitutifs de l’infraction',
    explanation:
        'Le coauteur participe directement à la réalisation des éléments constitutifs de l’infraction, contrairement au complice qui se situe en soutien.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Conditions',
    question:
        'Combien de conditions sont classiquement exigées pour qu’une complicité punissable soit retenue ?',
    options: ['Deux', 'Trois', 'Quatre'],
    answer: 'Trois',
    explanation:
        'Le cours rappelle les trois conditions : un fait principal punissable, une participation à l’infraction et une intention de participer à cette infraction.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Fait principal',
    question: 'La complicité punissable suppose en premier lieu l’existence :',
    options: [
      'D’un simple projet criminel',
      'D’un fait principal punissable',
      'D’un dommage grave',
    ],
    answer: 'D’un fait principal punissable',
    explanation:
        'Sans fait principal punissable, il n’y a pas de « criminalité d’emprunt » et donc pas de complicité.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Participation',
    question:
        'La participation à l’infraction, au sens de la complicité, peut notamment prendre la forme :',
    options: [
      'D’un simple avis moral sans lien avec l’infraction',
      'D’une aide ou assistance facilitant la consommation de l’infraction',
      'D’un simple témoignage après les faits',
    ],
    answer:
        'D’une aide ou assistance facilitant la consommation de l’infraction',
    explanation:
        'La complicité par aide ou assistance consiste à fournir un soutien matériel ou moral facilitant la préparation ou la consommation de l’infraction.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Intention',
    question:
        'La troisième condition de la complicité punissable concerne l’intention. Le complice doit :',
    options: [
      'Agir par simple imprudence',
      'Avoir l’intention de participer à l’infraction',
      'Ignorer totalement le caractère délictueux des faits',
    ],
    answer: 'Avoir l’intention de participer à l’infraction',
    explanation:
        'Le complice doit vouloir s’associer à l’acte délictueux et connaître le caractère délictueux des faits.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Répression',
    question:
        'Selon l’article 121-6 du Code pénal, comment le complice est-il puni ?',
    options: [
      'Plus légèrement que l’auteur principal',
      'Plus sévèrement que l’auteur principal',
      'Comme l’auteur de l’infraction',
    ],
    answer: 'Comme l’auteur de l’infraction',
    explanation:
        'Art. 121-6 C. pén. : le complice d’un crime ou d’un délit est puni comme auteur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Fait principal',
    question:
        'La complicité peut-elle être retenue si l’auteur principal n’est pas identifié mais que le fait principal est établi ?',
    options: ['Oui', 'Non'],
    answer: 'Oui',
    explanation:
        'Le complice peut être poursuivi même si l’auteur principal n’est pas poursuivi ou identifié, dès lors que le fait principal punissable est démontré.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Contraventions',
    question:
        'En matière contraventionnelle, la complicité par provocation ou instructions :',
    options: [
      'Est systématiquement réprimée par des textes spéciaux',
      'N’est jamais réprimée',
      'Est réprimée uniquement si l’auteur est condamné',
    ],
    answer: 'Est systématiquement réprimée par des textes spéciaux',
    explanation:
        'Certaines contraventions sont expressément réprimées par provocation ou instructions (référence à l’article R. 610-2 C. pén.).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Définition',
    question:
        'La complicité par aide ou assistance consiste principalement à :',
    options: [
      'Remplacer l’auteur au dernier moment',
      'Fournir un appui matériel ou moral à l’auteur',
      'Observer la scène sans intervenir',
    ],
    answer: 'Fournir un appui matériel ou moral à l’auteur',
    explanation:
        'Le complice facilite l’infraction en soutenant l’auteur, sans réaliser lui-même tous les éléments de l’infraction.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Illustration',
    question:
        'Une personne laisse volontairement sa voiture à disposition pour que son ami aille commettre un braquage. Elle :',
    options: [
      'Est simple prêteur de véhicule',
      'Peut être complice par aide ou assistance',
      'Est coauteur automatiquement',
    ],
    answer: 'Peut être complice par aide ou assistance',
    explanation:
        'Elle met sciemment un moyen à disposition pour faciliter l’infraction, ce qui caractérise l’aide ou assistance.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Illustration',
    question:
        'Une personne garde la porte pendant que l’auteur principal vole dans le magasin. Elle est :',
    options: [
      'Témoin neutre',
      'Complice par aide ou assistance',
      'Responsable civilement seulement',
    ],
    answer: 'Complice par aide ou assistance',
    explanation:
        'La surveillance de l’arrivée de la police ou du personnel est une aide matérielle à la commission du vol.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Présence sur les lieux',
    question:
        'La seule présence sur les lieux d’une infraction, sans acte positif ni accord préalable :',
    options: [
      'Constitue automatiquement une complicité',
      'Ne suffit pas, en principe, à caractériser la complicité',
    ],
    answer: 'Ne suffit pas, en principe, à caractériser la complicité',
    explanation:
        'Il faut un acte positif ou au minimum un comportement significatif d’une volonté d’adhésion à l’infraction.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Fait principal',
    question:
        'Le fait principal punissable, pour fonder la complicité, doit être :',
    options: [
      'Soit un crime, soit un délit',
      'Exclusivement un crime',
      'Uniquement une contravention',
    ],
    answer: 'Soit un crime, soit un délit',
    explanation:
        'Tous les crimes et délits sont en principe susceptibles de complicité.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Tentative',
    question:
        'La complicité est-elle possible lorsqu’il n’y a qu’une tentative de l’infraction principale ?',
    options: ['Oui', 'Non'],
    answer: 'Oui',
    explanation:
        'Dès lors que la tentative est elle-même punissable, la complicité de cette tentative peut être retenue.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Intention',
    question:
        'Pour que la complicité soit retenue, le complice doit connaître :',
    options: [
      'La personnalité de la victime',
      'La nature délictueuse ou criminelle du fait principal',
      'Le montant exact du préjudice',
    ],
    answer: 'La nature délictueuse ou criminelle du fait principal',
    explanation:
        'Il suffit qu’il sache qu’il se joint à un comportement interdit par la loi pénale, sans connaître tous les détails.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Intention',
    question:
        'Un individu pensant aider à un acte licite (ex : déménagement) alors qu’il s’agit en réalité d’un vol organisé :',
    options: [
      'Est nécessairement complice',
      'Ne peut pas être complice faute d’intention de participer à un délit',
    ],
    answer:
        'Ne peut pas être complice faute d’intention de participer à un délit',
    explanation:
        'La complicité suppose la connaissance du caractère délictueux des faits.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Répression',
    question:
        'En pratique, pourquoi la peine du complice peut-elle être différente de celle de l’auteur ?',
    options: [
      'Parce que la loi fixe toujours un maximum inférieur',
      'Parce que le juge individualise les peines pour chacun',
    ],
    answer: 'Parce que le juge individualise les peines pour chacun',
    explanation:
        'Même peine encourue, mais le juge tient compte du rôle concret, des antécédents, de la personnalité, etc.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Contraventions',
    question:
        'En matière de contravention, la complicité par aide ou assistance :',
    options: [
      'N’est réprimée que si un texte spécial le prévoit',
      'Est toujours réprimée comme en matière délictuelle',
    ],
    answer: 'N’est réprimée que si un texte spécial le prévoit',
    explanation:
        'Le principe est l’absence de complicité de contravention, sauf disposition expresse.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Happy slapping',
    question:
        'Filmer sciemment une agression pour la diffuser sur les réseaux sociaux :',
    options: [
      'Est assimilé par la loi à un acte de complicité de ces violences',
      'Est sans conséquence pénale',
    ],
    answer: 'Est assimilé par la loi à un acte de complicité de ces violences',
    explanation:
        'Le dispositif dit de « happy slapping » assimile l’enregistrement à un acte de complicité des atteintes volontaires à l’intégrité.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Exemple',
    question:
        'Une personne qui indique « la porte reste toujours ouverte à telle heure » à un voleur :',
    options: [
      'Fournit une information anodine',
      'Se rend complice par fourniture d’instructions',
    ],
    answer: 'Se rend complice par fourniture d’instructions',
    explanation:
        'Elle donne une indication précise destinée à faciliter le cambriolage.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Exemple',
    question:
        'Un ami qui garde les bijoux volés « le temps que ça se calme » est :',
    options: ['Complice du vol', 'Auteur d’un recel (infraction distincte)'],
    answer: 'Auteur d’un recel (infraction distincte)',
    explanation:
        'La garde postérieure des choses provenant d’un crime ou délit caractérise le recel, non la complicité.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Auteur moral',
    question:
        'Comment désigne-t-on celui qui incite autrui à commettre une infraction sans y participer matériellement ?',
    options: [
      'L’auteur moral ou provocateur',
      'Le simple témoin',
      'Le coauteur matériel',
    ],
    answer: 'L’auteur moral ou provocateur',
    explanation:
        'C’est l’exemple type du complice par provocation : il pousse une personne déterminée à commettre un crime ou un délit.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Conditions',
    question:
        'La complicité suppose-t-elle que l’infraction principale soit effectivement consommée ?',
    options: ['Oui, toujours', 'Non, la tentative punissable suffit'],
    answer: 'Non, la tentative punissable suffit',
    explanation:
        'Criminalité d’emprunt : il suffit que le fait principal (même à l’état de tentative punissable) soit établi.',
    difficulty: 'Facile',
  ),

  // ===================== MOYENNE =====================
  const QuizQuestion(
    category: 'Fait principal punissable',
    question: 'La complicité ne sera pas retenue lorsque le fait principal :',
    options: [
      'Est justifié par la légitime défense',
      'Constitue un crime ou un délit',
      'Est seulement tenté',
    ],
    answer: 'Est justifié par la légitime défense',
    explanation:
        'Si le fait principal est justifié (légitime défense, ordre de la loi, commandement de l’autorité légitime), il n’est pas punissable : la criminalité d’emprunt fait défaut.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Fait principal punissable',
    question:
        'La complicité ne pourra pas non plus être retenue si le fait principal :',
    options: [
      'N’est plus punissable suite à une prescription de l’action publique',
      'Est toujours incriminé par la loi',
      'A été tenté mais non consommé',
    ],
    answer:
        'N’est plus punissable suite à une prescription de l’action publique',
    explanation:
        'Si le fait principal n’est plus punissable en raison de la prescription ou d’une amnistie, la complicité tombe également.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Fait principal punissable',
    question:
        'Selon l’article 121-7 du Code pénal, les crimes et délits sont en principe :',
    options: [
      'Insusceptibles de complicité',
      'Tous susceptibles de complicité',
      'Seulement les délits qui le prévoient',
    ],
    answer: 'Tous susceptibles de complicité',
    explanation:
        'Art. 121-7 C. pén. : en principe, tous les crimes et délits peuvent donner lieu à complicité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Fait principal punissable',
    question: 'En matière contraventionnelle, la complicité :',
    options: [
      'Est admise pour certaines contraventions prévues par des textes spéciaux',
      'Est toujours exclue',
      'Est automatique dès qu’il y a plusieurs personnes',
    ],
    answer:
        'Est admise pour certaines contraventions prévues par des textes spéciaux',
    explanation:
        'La complicité de contravention est réprimée uniquement lorsqu’un texte le prévoit (ex. R. 610-2 C. pén.).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Aide ou assistance',
    question:
        'Quelle formule décrit le mieux la complicité par aide ou assistance ?',
    options: [
      'Conseil purement théorique sans rapport avec les faits',
      'Acte qui facilite matériellement ou moralement la préparation ou la consommation de l’infraction',
      'Absence volontaire du domicile au moment des faits',
    ],
    answer:
        'Acte qui facilite matériellement ou moralement la préparation ou la consommation de l’infraction',
    explanation:
        'Exemples : fournir une arme, prêter un véhicule, héberger les auteurs avant les faits…',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Aide ou assistance',
    question:
        'Parmi les exemples suivants, lequel illustre une complicité par aide ou assistance ?',
    options: [
      'Une personne qui regarde la scène par curiosité',
      'Une personne qui procure sciemment l’arme utilisée pour commettre le crime',
      'Une personne qui apprend après coup qu’un vol a eu lieu',
    ],
    answer:
        'Une personne qui procure sciemment l’arme utilisée pour commettre le crime',
    explanation:
        'Fournir l’arme ou le poison ayant servi à l’infraction est un cas classique de complicité par aide ou assistance.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation',
    question:
        'Pour qu’il y ait complicité par provocation, la provocation doit notamment :',
    options: [
      'Être vague et adressée à toute personne',
      'Être individuelle, accompagnée de promesses, dons, menaces ou abus d’autorité, et suivie d’effets',
      'Être purement morale, sans lien avec l’infraction',
    ],
    answer:
        'Être individuelle, accompagnée de promesses, dons, menaces ou abus d’autorité, et suivie d’effets',
    explanation:
        'Le « provocateur » est l’auteur moral de l’infraction ; la provocation doit être déterminée et avoir produit au moins une tentative.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Provocation',
    question:
        'La Chambre criminelle a jugé que le passager d’un véhicule qui donne l’ordre de forcer un barrage de gendarmerie :',
    options: [
      'Ne peut jamais être complice',
      'Doit être considéré comme complice par provocation',
      'Est seulement témoin',
    ],
    answer: 'Doit être considéré comme complice par provocation',
    explanation:
        'Cass. crim. 18 mars 2003 : le passager incitant le conducteur à forcer le barrage est complice par provocation.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Fourniture d’instructions',
    question: 'La complicité par fourniture d’instructions suppose :',
    options: [
      'Des indications vagues sur l’attitude morale à adopter',
      'Des indications précises sur la manière de commettre l’infraction, données en connaissance de cause',
      'Une simple absence de réaction pendant les faits',
    ],
    answer:
        'Des indications précises sur la manière de commettre l’infraction, données en connaissance de cause',
    explanation:
        'Exemple : indiquer les heures d’absence des occupants pour faciliter un cambriolage.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Intention criminelle',
    question: 'Pour l’intention criminelle du complice, il faut notamment :',
    options: [
      'Une simple imprudence',
      'La connaissance du caractère délictueux des actes envisagés par l’auteur et la volonté de s’y associer',
      'Un mobile égoïste',
    ],
    answer:
        'La connaissance du caractère délictueux des actes envisagés par l’auteur et la volonté de s’y associer',
    explanation:
        'Le cours insiste sur ces deux éléments : connaissance et volonté d’agir « ensemble et de concert ». ',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Scénario',
    question:
        'A prête sa maison à B pour « une petite soirée », en sachant que B souhaite y organiser un trafic de stupéfiants. A :',
    options: [
      'Ne risque rien, il n’est pas présent pendant la soirée',
      'Peut être poursuivi comme complice par aide ou assistance',
    ],
    answer: 'Peut être poursuivi comme complice par aide ou assistance',
    explanation:
        'Il met volontairement un lieu à disposition en connaissance du projet délictueux.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Scénario',
    question:
        'Une personne donne au futur auteur un conseil juridique abstrait sur la notion de vol, sans savoir qu’il compte commettre un cambriolage le soir même. Elle :',
    options: [
      'Est complice par fourniture d’instructions',
      'N’est pas complice, faute de lien intentionnel avec une infraction déterminée',
    ],
    answer:
        'N’est pas complice, faute de lien intentionnel avec une infraction déterminée',
    explanation:
        'La complicité exige un lien avec une infraction concrète connue du complice.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Temporalité',
    question:
        'Les actes de participation du complice doivent, sauf texte contraire, intervenir :',
    options: [
      'Avant ou pendant la commission de l’infraction',
      'Uniquement après la consommation',
    ],
    answer: 'Avant ou pendant la commission de l’infraction',
    explanation:
        'Il n’y a en principe pas de complicité postérieure ; les actes postérieurs relèvent d’autres infractions (recel, non-dénonciation…).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Criminalité d’emprunt',
    question: 'La complicité est qualifiée de « criminalité d’emprunt » car :',
    options: [
      'Elle emprunte la nature, la qualification et les circonstances au fait principal',
      'Elle n’est pas réprimée par le Code pénal',
    ],
    answer:
        'Elle emprunte la nature, la qualification et les circonstances au fait principal',
    explanation:
        'Le complice est puni par référence à l’infraction principale commise ou tentée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Répression',
    question:
        'Les peines encourues par le complice et l’auteur sont identiques, mais le juge :',
    options: [
      'Doit prononcer exactement la même peine',
      'Peut individualiser la peine de chacun en fonction de son rôle',
    ],
    answer: 'Peut individualiser la peine de chacun en fonction de son rôle',
    explanation:
        'C’est l’« application de la règle » : même peine possible, mais dosages différents.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances personnelles',
    question:
        'Une circonstance personnelle liée à la personne de l’auteur (ex : récidive) :',
    options: [
      'S’applique automatiquement au complice',
      'Ne s’applique pas au complice',
    ],
    answer: 'Ne s’applique pas au complice',
    explanation:
        'Les circonstances strictement personnelles à l’auteur restent attachées à sa seule personne.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Circonstances réelles',
    question:
        'Une circonstance réelle tenant aux modalités de l’acte (ex : vol commis de nuit) :',
    options: [
      'S’étend au complice même s’il l’ignorait',
      'Ne peut jamais s’étendre au complice',
    ],
    answer: 'S’étend au complice même s’il l’ignorait',
    explanation:
        'Les circonstances liées à la matérialité des faits s’appliquent à tous les participants, auteurs et complices.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Happy slapping',
    question:
        'Dans le dispositif du happy slapping, pour être puni comme complice, l’auteur de l’enregistrement doit avoir :',
    options: [
      'Filmé par inadvertance',
      'Enregistré sciemment des images d’atteintes volontaires à l’intégrité',
    ],
    answer:
        'Enregistré sciemment des images d’atteintes volontaires à l’intégrité',
    explanation:
        'L’élément intentionnel demeure essentiel : l’enregistrement doit être réalisé en connaissance de cause.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Scénario',
    question:
        'Un étudiant filme une bagarre grave en riant et en encourageant les coups pour partager la vidéo. Sur le plan pénal, il risque :',
    options: [
      'Rien, car il ne porte pas les coups',
      'Une poursuite comme complice des violences par enregistrement des images',
    ],
    answer:
        'Une poursuite comme complice des violences par enregistrement des images',
    explanation:
        'Le texte assimile l’enregistrement volontaire à un acte de complicité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Limites',
    question:
        'Le simple silence d’une personne informée d’un projet d’infraction, sans obligation légale d’agir :',
    options: [
      'Constitue en lui-même une complicité',
      'Ne suffit pas, sauf texte spécial, pour caractériser la complicité',
    ],
    answer:
        'Ne suffit pas, sauf texte spécial, pour caractériser la complicité',
    explanation:
        'En l’absence d’obligation d’agir, le silence n’est pas en soi une aide ou une instigation.',
    difficulty: 'Moyenne',
  ),

  // ===================== DIFFICILE =====================
  const QuizQuestion(
    category: 'Criminalité d’emprunt',
    question:
        'Pourquoi dit-on que la complicité est une « criminalité d’emprunt » ?',
    options: [
      'Parce que le complice emprunte l’instrument ayant servi à l’infraction',
      'Parce que la responsabilité du complice emprunte sa nature au fait principal punissable',
      'Parce que la peine n’est pas individualisée',
    ],
    answer:
        'Parce que la responsabilité du complice emprunte sa nature au fait principal punissable',
    explanation:
        'Le complice n’est punissable que par référence à l’infraction principale, même s’il n’en a pas commis les éléments matériels.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Fait principal punissable',
    question:
        'La complicité reste possible même si l’auteur principal n’est pas puni lorsque :',
    options: [
      'L’auteur est en fuite ou inconnu',
      'Les faits ne sont pas prévus par la loi pénale',
      'L’infraction est amnistiée',
    ],
    answer: 'L’auteur est en fuite ou inconnu',
    explanation:
        'Le cours liste les hypothèses où le complice peut être poursuivi malgré l’absence de poursuites contre l’auteur : fuite, décès, irresponsabilité, etc.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Fait principal punissable',
    question:
        'La complicité ne pourra pas être retenue si le fait principal échappe à la loi pénale parce que :',
    options: [
      'Il se déroule à l’étranger',
      'Il est justifié ou amnistié',
      'Il est simplement tenté',
    ],
    answer: 'Il est justifié ou amnistié',
    explanation:
        'Un fait principal justifié ou bénéficiant d’une amnistie n’est plus punissable : la complicité disparaît.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Participation matérielle',
    question:
        'Les actes de participation du complice doivent être, par principe :',
    options: [
      'Antérieurs ou concomitants au fait principal',
      'Postérieurs au fait principal',
      'Indifférents dans le temps',
    ],
    answer: 'Antérieurs ou concomitants au fait principal',
    explanation:
        'Il n’y a pas de complicité postérieure à l’infraction ; les actes doivent précéder ou accompagner la commission.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Provocation',
    question:
        'Le simple conseil donné à une personne de commettre une infraction, sans don, menace, ou promesse :',
    options: [
      'Suffit à caractériser une complicité par provocation',
      'Ne suffit pas à caractériser une complicité par provocation',
    ],
    answer: 'Ne suffit pas à caractériser une complicité par provocation',
    explanation:
        'Le cours précise que le « simple conseil » ne suffit pas ; il faut des circonstances telles qu’un don, une promesse, un ordre, une menace ou un abus d’autorité.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping',
    question:
        'Dans le cas du « happy slapping », l’enregistrement d’images de violences volontaires est :',
    options: [
      'Considéré comme un acte de complicité des atteintes volontairement commises',
      'Un simple comportement moralement condamnable mais pénalement neutre',
    ],
    answer:
        'Considéré comme un acte de complicité des atteintes volontairement commises',
    explanation:
        'L’article 222-33-3-1 C. pén. assimile l’enregistrement sciemment réalisé à un acte de complicité des atteintes principales.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Répression',
    question:
        'En matière de répression de la complicité, les peines encourues par le complice et l’auteur :',
    options: [
      'Sont identiques en nature et en quantum, mais le juge n’est pas obligé de prononcer la même peine',
      'Doivent obligatoirement être identiques en pratique',
      'Sont toujours plus faibles pour le complice',
    ],
    answer:
        'Sont identiques en nature et en quantum, mais le juge n’est pas obligé de prononcer la même peine',
    explanation:
        'Le sens de la règle (art. 121-6) : même peine encourue, mais individualisation par le juge.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances personnelles',
    question:
        'Les circonstances personnelles à l’auteur (ex : récidive, démence) :',
    options: [
      'Sont applicables de plein droit au complice',
      'Ne sont pas applicables au complice',
    ],
    answer: 'Ne sont pas applicables au complice',
    explanation:
        'Les circonstances personnelles aggravant ou atténuant la culpabilité de l’auteur ne s’étendent pas au complice.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances réelles',
    question:
        'Les circonstances réelles qui touchent à la matérialité de l’acte (ex : réunion pour un vol) :',
    options: [
      'S’étendent au complice même s’il en ignorait l’existence',
      'Ne concernent que l’auteur principal',
    ],
    answer: 'S’étendent au complice même s’il en ignorait l’existence',
    explanation:
        'Les circonstances matérielles aggravant l’infraction (arme, réunion…) s’appliquent au complice, même s’il ne les connaissait pas.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances mixtes',
    question:
        'Les circonstances mixtes qui concernent à la fois la personne et l’acte (ex : qualité professionnelle de l’auteur) :',
    options: [
      'Sont automatiquement personnelles',
      'Peuvent être applicables au complice selon l’arrêt du 7 septembre 2005',
    ],
    answer:
        'Peuvent être applicables au complice selon l’arrêt du 7 septembre 2005',
    explanation:
        'La Cour de cassation a admis que certaines circonstances aggravantes liées à la qualité de l’auteur principal peuvent aussi s’appliquer au complice.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Tentative & complicité',
    question:
        'La complicité d’une tentative manquée (exécution complète mais résultat non atteint par hasard) :',
    options: [
      'N’est jamais punissable',
      'Est punissable comme la tentative elle-même',
    ],
    answer: 'Est punissable comme la tentative elle-même',
    explanation:
        'Le complice emprunte la qualification de la tentative manquée, dès lors qu’elle est incriminée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Scénario',
    question:
        'A donne à B l’ordre de tirer sur C. B tire mais manque sa cible. Quelle qualification pour A ?',
    options: [
      'Complice de tentative d’homicide',
      'Aucune responsabilité pénale',
    ],
    answer: 'Complice de tentative d’homicide',
    explanation:
        'B est auteur d’une tentative d’homicide, A en est complice par provocation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Scénario',
    question:
        'A fournit un pistolet à B pour tuer C. L’arme était en réalité déchargée, ce que B ignorait. B tire. A :',
    options: [
      'Reste sans responsabilité, car le résultat était impossible',
      'Peut être complice de tentative d’homicide impossible',
    ],
    answer: 'Peut être complice de tentative d’homicide impossible',
    explanation:
        'La tentative impossible demeure punissable lorsque l’intention et le commencement d’exécution sont caractérisés.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Limites',
    question:
        'Peut-on retenir une complicité si l’acte principal est finalement qualifié de fait justificatif (ex : légitime défense) ?',
    options: [
      'Oui, le complice reste punissable',
      'Non, la justification profite également au complice',
    ],
    answer: 'Non, la justification profite également au complice',
    explanation:
        'Si le fait principal n’est pas infractionnel, la criminalité d’emprunt disparaît pour tous les participants.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Auteur / Complice',
    question: 'On parle de « coaction » lorsque plusieurs personnes :',
    options: [
      'Se contentent d’aider moralement l’auteur',
      'Réalisation ensemble les éléments matériels de l’infraction',
    ],
    answer: 'Réalisation ensemble les éléments matériels de l’infraction',
    explanation:
        'Dans ce cas, chacun est coauteur, non complice : ils réalisent l’infraction de concert.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping',
    question:
        'Pour que l’enregistrement soit qualifié de complicité dans le happy slapping, il faut notamment que :',
    options: [
      'L’auteur ait l’intention de constituer une preuve pour la victime',
      'L’enregistrement soit réalisé dans un but de diffusion ou de valorisation de la violence',
    ],
    answer:
        'L’enregistrement soit réalisé dans un but de diffusion ou de valorisation de la violence',
    explanation:
        'L’esprit du texte est de viser les enregistrements qui participent à la mise en scène de la violence.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Répression',
    question: 'La complicité d’un crime jugé en cour d’assises :',
    options: [
      'Relève aussi de la cour d’assises',
      'Relève d’un tribunal correctionnel',
    ],
    answer: 'Relève aussi de la cour d’assises',
    explanation:
        'Le complice est jugé devant la même juridiction que l’auteur pour le crime ou le délit auquel il s’est associé.',
    difficulty: 'Difficile',
  ),

  // ===================== Difficile =====================
  const QuizQuestion(
    category: 'Fait principal & tentative',
    question: 'La complicité de tentative d’infraction est-elle punissable ?',
    options: [
      'Oui, si la tentative est elle-même punissable',
      'Non, seule la complicité d’infraction consommée est réprimée',
    ],
    answer: 'Oui, si la tentative est elle-même punissable',
    explanation:
        'Le complice emprunte la criminalité du fait principal : si la tentative est incriminée, la complicité demeure possible.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Temporalité des actes',
    question:
        'Une personne qui aide l’auteur à dissimuler le corps après un homicide déjà consommé :',
    options: [
      'Est complice d’homicide',
      'N’est pas complice d’homicide mais peut être poursuivie pour d’autres infractions (ex : recel de cadavre, obstruction à la justice)',
    ],
    answer:
        'N’est pas complice d’homicide mais peut être poursuivie pour d’autres infractions (ex : recel de cadavre, obstruction à la justice)',
    explanation:
        'Les actes purement postérieurs ne constituent pas, en principe, une complicité.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Instigation vs aide',
    question:
        'Quelle nuance principale distingue la complicité par provocation (instigation) de la complicité par aide ou assistance ?',
    options: [
      'La provocation suppose un rôle moteur dans la décision de commettre l’infraction',
      'La provocation est toujours moins grave',
    ],
    answer:
        'La provocation suppose un rôle moteur dans la décision de commettre l’infraction',
    explanation:
        'Le provocateur est l’auteur moral : il déclenche la décision criminelle.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping',
    question:
        'Dans le dispositif sur le « happy slapping », pourquoi le législateur a-t-il choisi de qualifier l’enregistrement d’images de violences de complicité plutôt que d’infraction autonome ?',
    options: [
      'Pour supprimer toute référence au fait principal',
      'Pour rattacher la responsabilité de l’enregistreur aux atteintes principales sans devoir démontrer un lien matériel de causalité',
    ],
    answer:
        'Pour rattacher la responsabilité de l’enregistreur aux atteintes principales sans devoir démontrer un lien matériel de causalité',
    explanation:
        'L’enregistrement est directement rattaché aux violences principales comme forme de participation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Circonstances mixtes',
    question:
        'Que décide l’arrêt n° 04-84.235 du 7 septembre 2005 à propos des circonstances aggravantes liées à la qualité de l’auteur principal ?',
    options: [
      'Elles ne peuvent jamais être retenues contre le complice',
      'Elles peuvent être appliquées au complice comme circonstances aggravantes',
    ],
    answer:
        'Elles peuvent être appliquées au complice comme circonstances aggravantes',
    explanation:
        'La Cour de cassation admet l’extension au complice de certaines circonstances liées à la qualité de l’auteur.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Intention',
    question:
        'Un individu fournit un tournevis à un ami en sachant qu’il va « s’en servir pour entrer chez quelqu’un et voler », mais prétend ensuite n’avoir voulu qu’un simple « service ». Sur le plan pénal :',
    options: [
      'L’absence de mobile égoïste exclut la complicité',
      'La connaissance du projet et la fourniture d’un moyen caractérisent une complicité par aide ou assistance',
    ],
    answer:
        'La connaissance du projet et la fourniture d’un moyen caractérisent une complicité par aide ou assistance',
    explanation:
        'Le mobile (amitié, service) est indifférent : ce qui compte est la volonté de s’associer à un projet délictueux connu.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Application de la règle',
    question:
        'Un complice ayant joué un rôle limité peut-il recevoir une peine plus faible que l’auteur principal ?',
    options: [
      'Non, la peine doit être identique',
      'Oui, même si la peine encourue est la même, le juge individualise et peut prononcer une peine plus faible',
    ],
    answer:
        'Oui, même si la peine encourue est la même, le juge individualise et peut prononcer une peine plus faible',
    explanation:
        'Individualisation des peines : le rôle concret du complice peut justifier une sanction moindre.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Illustration pratique',
    question:
        'Une personne qui joue de la musique très fort pour couvrir les cris de la victime pendant l’agression :',
    options: [
      'Est un simple voisin gênant',
      'Peut être considérée comme complice par aide ou assistance',
    ],
    answer: 'Peut être considérée comme complice par aide ou assistance',
    explanation: 'Elle facilite sciemment l’agression en empêchant l’alerte.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Illustration pratique',
    question:
        'Une personne indique au cambrioleur les heures précises d’absence des occupants :',
    options: [
      'Ne peut être inquiétée pénalement',
      'Se rend complice par fourniture d’instructions',
    ],
    answer: 'Se rend complice par fourniture d’instructions',
    explanation:
        'Elle fournit une information déterminante, en connaissance de cause, pour la réalisation du cambriolage.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Limites de la complicité',
    question:
        'Peut-on retenir la complicité de complicité (une personne aidant un complice et non directement l’auteur) ?',
    options: [
      'Oui, la complicité se répercute à l’infini',
      'En principe non, la jurisprudence exige un lien direct avec le fait principal',
    ],
    answer:
        'En principe non, la jurisprudence exige un lien direct avec le fait principal',
    explanation:
        'La théorie classique reste réticente à admettre une « complicité de complicité » déconnectée de l’infraction principale.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Scénario avancé',
    question:
        'A fournit une arme à B en sachant que B va la revendre à C, lequel envisage un homicide. A :',
    options: [
      'Est automatiquement complice de l’homicide que commettra C',
      'Ne sera complice que si l’on prouve qu’il avait connaissance du projet précis de C',
    ],
    answer:
        'Ne sera complice que si l’on prouve qu’il avait connaissance du projet précis de C',
    explanation:
        'Il faut un lien intentionnel avec l’infraction déterminée, pas seulement une connaissance vague d’un usage possible.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Scénario avancé',
    question:
        'A organise un plan détaillé de braquage et remet ce plan à B, mais ne participe pas matériellement. B réalise le vol. A est :',
    options: [
      'Sans responsabilité, car absent des lieux',
      'Complice par fourniture d’instructions',
    ],
    answer: 'Complice par fourniture d’instructions',
    explanation:
        'Il a fourni des indications précises permettant la commission de l’infraction.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
    category: 'Élément légal',
    question:
        'Combien d’éléments généraux doivent être réunis pour qu’une infraction existe ?',
    options: ['Deux', 'Trois', 'Quatre'],
    answer: 'Trois',
    explanation:
        'Élément légal, matériel et moral doivent être simultanément réunis.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
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
  const QuizQuestion(
    category: 'Sources',
    question:
        'La loi détermine crimes et délits et fixe les peines. Vrai ou faux ?',
    options: ['Vrai', 'Faux'],
    answer: 'Vrai',
    explanation:
        'Art. 111-2 C. pén. : la loi fixe la matière criminelle et délictuelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Sources',
    question: 'Les contraventions sont déterminées :',
    options: ['Par la loi', 'Par le règlement', 'Par la coutume'],
    answer: 'Par le règlement',
    explanation:
        'Art. 111-2 al. 2 C. pén. : le règlement détermine et réprime les contraventions.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
    category: 'Élément matériel',
    question: 'Une pure résolution criminelle (pensée) :',
    options: ['Est punissable', 'N’est pas punissable'],
    answer: 'N’est pas punissable',
    explanation: 'Sans extériorisation réprimée, il n’y a pas d’infraction.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Tentative',
    question:
        'L’infraction non achevée mais commencée peut être réprimée sous la qualification :',
    options: ['Préparation', 'Tentative', 'Résolution'],
    answer: 'Tentative',
    explanation:
        'La tentative sanctionne l’atteinte inachevée dès le commencement d’exécution.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
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
  const QuizQuestion(
    category: 'Tentative',
    question: 'La tentative de contravention :',
    options: ['Peut être punie si prévu', 'N’est jamais punissable'],
    answer: 'N’est jamais punissable',
    explanation:
        '121-4 : tentative non punissable en matière contraventionnelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
    category: 'Faute non intentionnelle',
    question: 'La faute d’imprudence/négligence relève :',
    options: ['De l’élément moral', 'De l’élément matériel', 'D’aucun élément'],
    answer: 'De l’élément moral',
    explanation:
        'Art. 121-3 : imprudence, négligence, manquement à une obligation de prudence ou de sécurité.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
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
  const QuizQuestion(
    category: 'Faute non intentionnelle',
    question:
        'Pour la faute d’imprudence, le comportement de référence est celui :',
    options: [
      'Du meilleur Difficile',
      'De l’homme normalement prudent et diligent',
    ],
    answer: 'De l’homme normalement prudent et diligent',
    explanation:
        'Appréciation in abstracto, éventuellement par référence au professionnel moyen.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
    category: 'Schéma',
    question:
        'Dans le schéma de l’élément matériel, l’« acte négatif » renvoie à :',
    options: ['Une abstention', 'Une destruction', 'Un résultat'],
    answer: 'Une abstention',
    explanation: 'Acte négatif = attitude passive prohibée par un texte.',
    difficulty: 'Facile',
  ),

  // ===================== MOYENNE (25) =====================
  const QuizQuestion(
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
  const QuizQuestion(
    category: 'Sources',
    question:
        'Les décisions prises par le Président en vertu de l’article 16 de la Constitution :',
    options: ['Valeur législative', 'Valeur réglementaire', 'Aucune valeur'],
    answer: 'Valeur législative',
    explanation: 'Actes de crise dotés d’une valeur assimilée à la loi.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Sources',
    question: 'Un règlement administratif contraire à la loi pénale :',
    options: ['Peut s’appliquer', 'Est écarté par le juge pénal'],
    answer: 'Est écarté par le juge pénal',
    explanation: 'Hiérarchie des normes : la loi prime.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Sources',
    question:
        'Les textes pénaux peuvent-ils être issus de traités européens relatifs aux droits fondamentaux ?',
    options: ['Oui, via leur effet direct et primauté', 'Non, jamais'],
    answer: 'Oui, via leur effet direct et primauté',
    explanation: 'CEDH/UE influent et s’imposent à la loi interne publiée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
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
  const QuizQuestion(
    category: 'Élément matériel',
    question:
        'Résolution criminelle non suivie d’effet socialement troublant :',
    options: ['Punissable', 'Non punissable'],
    answer: 'Non punissable',
    explanation: 'Il faut manifestation extérieure réprimée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
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
  const QuizQuestion(
    category: 'Tentative',
    question: 'Le simple fait d’exprimer son intention de voler à voix haute :',
    options: ['Tentative punissable', 'Pas punissable'],
    answer: 'Pas punissable',
    explanation: 'Extériorisation d’intention seule insuffisante.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Tentative',
    question: 'Désistement volontaire :',
    options: ['Exclut la tentative punissable', 'N’a aucun effet'],
    answer: 'Exclut la tentative punissable',
    explanation:
        'S’il résulte d’une décision libre non due à une cause extérieure.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Tentative',
    question: 'Désistement dû à l’alarme d’un coffre-fort :',
    options: ['Volontaire', 'Non volontaire'],
    answer: 'Non volontaire',
    explanation: 'Cause extérieure : tentative reste punissable.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Tentative',
    question:
        'Infraction manquée (exécution complète mais résultat non atteint par circonstances indépendantes) :',
    options: ['Punissable comme tentative', 'Non punissable'],
    answer: 'Punissable comme tentative',
    explanation: '121-5 : répression de l’infraction manquée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Tentative',
    question:
        'Infraction impossible (poche vide / arme factice ignorée de l’auteur) :',
    options: ['Jamais réprimée', 'Réprimée si la tentative est prévue'],
    answer: 'Réprimée si la tentative est prévue',
    explanation:
        'Punissable quand le texte incrimine la tentative (crimes/certains délits).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
    category: 'Faute non intentionnelle',
    question:
        'La faute contraventionnelle permet sanction sans intention ni dommage :',
    options: ['Vrai', 'Faux'],
    answer: 'Vrai',
    explanation: 'Le simple non-respect d’une prescription suffit.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
    category: 'Élément légal',
    question: 'La Constitution de 1958 est-elle source du droit pénal ?',
    options: ['Oui, comme norme suprême', 'Non'],
    answer: 'Oui, comme norme suprême',
    explanation: 'Les sources essentielles du droit pénal s’y rattachent.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Élément légal',
    question:
        'Un règlement administratif hiérarchisé peut-il méconnaître la loi pénale ?',
    options: ['Oui', 'Non'],
    answer: 'Non',
    explanation: 'Un règlement contraire est illégal et écarté.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Jurisprudence/Doctrine',
    question:
        'La jurisprudence peut-elle aggraver une incrimination au-delà du texte clair ?',
    options: ['Oui', 'Non'],
    answer: 'Non',
    explanation: 'Interprétation stricte de la loi pénale.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Tentative',
    question:
        'L’auteur qui renonce librement avant la consommation, sans cause extérieure :',
    options: ['Reste punissable de tentative', 'Échappe à la tentative'],
    answer: 'Échappe à la tentative',
    explanation: 'Désistement volontaire exclut la tentative punissable.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Faute non intentionnelle',
    question:
        'La violation d’un texte (loi/règlement) peut suffire à caractériser :',
    options: ['Une faute pénale non intentionnelle', 'Un dol spécial'],
    answer: 'Une faute pénale non intentionnelle',
    explanation: 'Manquement à une obligation de prudence ou sécurité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Faute contraventionnelle',
    question: 'Automobiliste grillant un feu rouge par inattention :',
    options: ['Infraction intentionnelle', 'Faute contraventionnelle'],
    answer: 'Faute contraventionnelle',
    explanation: 'Simple violation d’une prescription sans intention requise.',
    difficulty: 'Moyenne',
  ),

  // ===================== DIFFICILE (25) =====================
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
    category: 'Sources',
    question:
        'La valeur des décisions art. 16 et des ordonnances ratifiées permet :',
    options: ['De créer crimes/délits', 'D’interpréter uniquement'],
    answer: 'De créer crimes/délits',
    explanation:
        'Valeur législative donc compétence en matière criminelle/délictuelle.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Élément matériel',
    question: 'Actes préparatoires :',
    options: ['Toujours punissables', 'Non punissables sauf texte spécial'],
    answer: 'Non punissables sauf texte spécial',
    explanation:
        'Le code ne retient que la tentative après commencement d’exécution.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
    category: 'Tentative',
    question:
        'Dans l’infraction impossible, l’auteur ignorait l’impossibilité. Conséquence :',
    options: ['Impunit é totale', 'Punissable si tentative incriminée'],
    answer: 'Punissable si tentative incriminée',
    explanation: 'Pickpocket poche vide, coup de feu à blanc.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Élément moral',
    question:
        'Pour les infractions intentionnelles, la connaissance du caractère illicite de l’acte :',
    options: ['Est indifférente', 'Est requise au titre du dol général'],
    answer: 'Est requise au titre du dol général',
    explanation: 'Conscience et volonté d’accomplir l’acte interdit.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Élément moral',
    question: 'Résultat obtenu exactement conforme au résultat voulu :',
    options: ['Dol spécial aggravé', 'Preuve du dol général'],
    answer: 'Preuve du dol général',
    explanation: 'Résultat déterminé recherché par l’auteur.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Élément moral',
    question:
        'Résultat au-delà de l’intention (ex. coups volontaires entraînant la mort) :',
    options: ['Dol spécial de tuer', 'Praeter-intentionnel'],
    answer: 'Praeter-intentionnel',
    explanation:
        'L’agent n’a pas voulu la mort mais l’a causée (ex. art. 222-7 C. pén. pour la qualification).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
    category: 'Faute non intentionnelle',
    question:
        'La faute caractérisée exposant autrui à un risque que l’on ne pouvait ignorer :',
    options: ['Relève du dol spécial', 'Relève de la mise en danger délibérée'],
    answer: 'Relève de la mise en danger délibérée',
    explanation:
        'Violation manifestement délibérée d’une obligation particulière.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
    category: 'Tentative',
    question:
        'Un acte univoque + intention de réaliser l’infraction mais renoncement par remords :',
    options: ['Tentative punissable', 'Non punissable'],
    answer: 'Non punissable',
    explanation: 'Désistement volontaire avéré.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Faute contraventionnelle',
    question: 'La responsabilité peut être exclue en cas de :',
    options: ['Force majeure ou contrainte', 'Absence de dommage uniquement'],
    answer: 'Force majeure ou contrainte',
    explanation: 'Toujours invocable comme cause d’irresponsabilité.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Élément matériel',
    question: 'Un résultat dommageable peut-il être exigé ?',
    options: ['Oui pour les infractions matérielles', 'Jamais'],
    answer: 'Oui pour les infractions matérielles',
    explanation:
        'Certains délits exigent un résultat (ex. blessures involontaires).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Élément matériel',
    question: 'Dans les infractions formelles :',
    options: ['Le résultat est exigé', 'Le résultat n’est pas exigé'],
    answer: 'Le résultat n’est pas exigé',
    explanation: 'La seule réalisation de l’acte suffit.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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

  // ===================== Difficile (25) =====================
  const QuizQuestion(
    category: 'Sources',
    question:
        'Peut-on fonder une incrimination uniquement sur une jurisprudence constante (sans texte) ?',
    options: ['Oui si constante', 'Non, jamais'],
    answer: 'Non, jamais',
    explanation:
        'Légalité criminelle : seule la loi (ou traités/valeur législative) crée l’infraction.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Sources',
    question:
        'Les règlements administratifs (décrets, arrêtés) : hiérarchie interne ?',
    options: [
      'Peuvent contredire une circulaire',
      'Ne peuvent jamais contredire la loi ou les traités',
    ],
    answer: 'Ne peuvent jamais contredire la loi ou les traités',
    explanation: 'Principe de hiérarchie des normes.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Sources',
    question: 'Un traité non publié mais signé et ratifié :',
    options: ['Est invocable devant le juge pénal', 'Ne l’est pas'],
    answer: 'Ne l’est pas',
    explanation: 'La publication conditionne l’applicabilité interne.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Tentative',
    question:
        'L’« acte univoque » caractéristique du commencement d’exécution :',
    options: [
      'Doit être incompatible avec un comportement licite',
      'Peut rester compatible avec une conduite licite',
    ],
    answer: 'Doit être incompatible avec un comportement licite',
    explanation: 'Il doit manifester la proximité de l’infraction déterminée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Tentative',
    question:
        'Affaire où le paiement d’un tueur à gages a été jugé préparation et non tentative :',
    options: ['Affaire Lacour 1962', 'Affaire Perdereau 1986'],
    answer: 'Affaire Lacour 1962',
    explanation:
        'La remise d’argent ne constituait pas un acte univoque d’exécution.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Tentative',
    question:
        'Tentative d’évasion par creusement du béton autour d’une fenêtre de cellule :',
    options: ['Préparation', 'Commencement d’exécution'],
    answer: 'Commencement d’exécution',
    explanation:
        'Appréciation jurisprudentielle : acte matériel caractéristique.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Tentative',
    question: 'La tentative « manquée » est punie car :',
    options: [
      'Le résultat fait défaut pour des raisons indépendantes de la volonté',
      'Il n’y avait aucune intention',
    ],
    answer:
        'Le résultat fait défaut pour des raisons indépendantes de la volonté',
    explanation: 'Ex. tir manqué par maladresse.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Tentative',
    question: 'La tentative « impossible » n’est punissable que si :',
    options: ['Le texte l’a expressément prévu', 'Il existe un dommage'],
    answer: 'Le texte l’a expressément prévu',
    explanation:
        'Punissable dans les crimes et certains délits où la tentative est incriminée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Élément moral',
    question: 'La prévisibilité du dommage en imprudence :',
    options: ['Est indifférente', 'Est centrale pour caractériser la faute'],
    answer: 'Est centrale pour caractériser la faute',
    explanation:
        'On reproche de ne pas avoir prévu ce qu’un prudent aurait prévu.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
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
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
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
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Faute non intentionnelle',
    question: 'Lien de causalité indirect et pluralité de fautes :',
    options: [
      'Empêche toute responsabilité pénale',
      'N’exclut pas la responsabilité si la faute a contribué au dommage',
    ],
    answer: 'N’exclut pas la responsabilité si la faute a contribué au dommage',
    explanation: 'La causalité juridique peut être multiple.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Faute contraventionnelle',
    question:
        'Exemple jurisprudentiel de prudence routière : obligation de maintenir son véhicule près du bord droit de la chaussée. La violation caractérise :',
    options: ['Un dol général', 'Une faute contraventionnelle'],
    answer: 'Une faute contraventionnelle',
    explanation: 'Cass. crim. 12 nov. 1997 (réf. citée dans le document).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Sources',
    question:
        'Quand un décret manque pour permettre l’entrée en vigueur d’une loi pénale :',
    options: [
      'La loi s’applique quand même',
      'Le texte reste inopérant jusqu’à parution du décret',
    ],
    answer: 'Le texte reste inopérant jusqu’à parution du décret',
    explanation: 'Le document précise que la loi reste « lettre morte ».',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
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
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Élément moral',
    question:
        'Dans les infractions matérielles non intentionnelles, l’élément moral se déduit :',
    options: [
      'Du dommage seul',
      'Du manquement à une obligation et du lien causal',
    ],
    answer: 'Du manquement à une obligation et du lien causal',
    explanation: 'Il faut rattacher la faute au dommage.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Schéma',
    question: 'Dans le schéma de la faute intentionnelle, la préméditation :',
    options: [
      'Aggrave le dol mais n’est pas nécessaire',
      'Est toujours exigée',
    ],
    answer: 'Aggrave le dol mais n’est pas nécessaire',
    explanation:
        'La préméditation est une circonstance aggravante dans certains textes.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Jurisprudence',
    question: 'La Cour de cassation contrôle :',
    options: [
      'L’existence du commencement d’exécution en droit',
      'Seulement la peine',
    ],
    answer: 'L’existence du commencement d’exécution en droit',
    explanation: 'Elle fixe les critères (acte univoque + intention).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Sources',
    question: 'Les « décrets-lois » antérieurs à 1958 :',
    options: [
      'Sont dépourvus d’effet',
      'Reste des textes de valeur législative tant qu’ils subsistent',
    ],
    answer: 'Reste des textes de valeur législative tant qu’ils subsistent',
    explanation: 'Le document les mentionne comme actes à valeur de loi.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Tentative',
    question: 'La tentative d’un crime est :',
    options: [
      'Punissable de plein droit',
      'Punissable seulement si un décret le prévoit',
    ],
    answer: 'Punissable de plein droit',
    explanation: 'Principe général du code pénal (121-4/121-5).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
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
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Élément légal',
    question:
        'La valeur des circulaires de la DACG (chancellerie) en matière pénale :',
    options: ['Normative', 'Interprétative/indicative'],
    answer: 'Interprétative/indicative',
    explanation: 'Ne créent pas d’infractions ; orientent la pratique.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Élément matériel',
    question: 'L’« infraction consommée » se distingue de la tentative par :',
    options: [
      'La seule intention',
      'La réalisation complète des éléments matériels',
    ],
    answer: 'La réalisation complète des éléments matériels',
    explanation: 'Tous les éléments constitutifs sont accomplis.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Élément moral',
    question:
        'Quand le résultat est indéterminé et non connu à l’avance de l’auteur (ex. résultat aléatoire) :',
    options: ['Le dol spécial est établi', 'Le dol spécial n’est pas établi'],
    answer: 'Le dol spécial n’est pas établi',
    explanation: 'Le texte exige un résultat déterminé pour le dol spécial.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Faute contraventionnelle',
    question:
        'La preuve de la contrainte en matière de faute contraventionnelle :',
    options: ['Est indifférente', 'Peut dégager la responsabilité de l’auteur'],
    answer: 'Peut dégager la responsabilité de l’auteur',
    explanation:
        'Contrainte/force majeure restent des causes d’irresponsabilité.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Sources',
    question:
        'Peut-on déroger par circulaire à une incrimination réglementaire existante ?',
    options: ['Oui', 'Non'],
    answer: 'Non',
    explanation:
        'La circulaire ne peut ni abroger ni modifier un texte normatif.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Tentative',
    question:
        'Après désistement volontaire, si un complice poursuit seul et consomme l’infraction :',
    options: [
      'Le premier est co-auteur',
      'Le premier n’est pas punissable de tentative',
    ],
    answer: 'Le premier n’est pas punissable de tentative',
    explanation: 'Son renoncement libre l’exonère de la tentative.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Élément matériel',
    question: 'Une abstention fautive n’est pénale que si :',
    options: [
      'Le juge l’estime moralement répréhensible',
      'Un texte impose l’acte non accompli',
    ],
    answer: 'Un texte impose l’acte non accompli',
    explanation: 'Principe de légalité des omissions.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: "Généralités",
    question:
        "La légitime défense fait partie de quelle catégorie juridique en droit pénal ?",
    options: [
      "Une circonstance aggravante",
      "Un fait justificatif",
      "Une excuse atténuante",
    ],
    answer: "Un fait justificatif",
    explanation:
        "La légitime défense est un fait justificatif qui rend l'acte pénalement non punissable.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Généralités",
    question:
        "Lorsque la légitime défense est reconnue, la personne ayant commis l'acte de défense est :",
    options: [
      "Pénalement responsable mais excusée",
      "Pénalement irresponsable",
      "Simplement condamnée avec sursis",
    ],
    answer: "Pénalement irresponsable",
    explanation:
        "Le texte précise : « N'est pas pénalement responsable la personne qui… accomplit un acte commandé par la nécessité de la légitime défense ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Légitime défense des personnes",
    question:
        "Selon le document, la légitime défense des personnes est prévue par :",
    options: [
      "L'article 122-4 du Code pénal",
      "L'article 122-5 du Code pénal",
      "L'article 122-6 du Code pénal",
    ],
    answer: "L'article 122-5 du Code pénal",
    explanation:
        "Le titre I indique : « LA LÉGITIME DÉFENSE D'UNE PERSONNE art. 122-5 C.P. ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Légitime défense des personnes",
    question:
        "La légitime défense des personnes suppose une atteinte injustifiée envers :",
    options: [
      "Uniquement la personne elle-même",
      "Uniquement autrui",
      "La personne elle-même ou autrui",
    ],
    answer: "La personne elle-même ou autrui",
    explanation:
        "Le texte vise « une atteinte injustifiée envers elle-même ou autrui ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Légitime défense des personnes",
    question:
        "Combien de conditions principales sont listées pour qu'une personne soit en situation de légitime défense DES PERSONNES ?",
    options: [
      "Deux grands groupes de conditions",
      "Trois grands groupes de conditions",
      "Une seule condition globale",
    ],
    answer: "Deux grands groupes de conditions",
    explanation:
        "Le schéma distingue : I- Lorsqu'une personne subit une atteinte ; II- Elle ou une autre personne peut accomplir un acte de défense.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Atteinte - Personnes",
    question:
        "Pour la légitime défense des personnes, l'atteinte doit être injustifiée. Cela signifie :",
    options: [
      "Qu'elle est autorisée par la loi",
      "Qu'elle est sans motif légitime, contraire au droit",
      "Qu'elle est simplement violente",
    ],
    answer: "Qu'elle est sans motif légitime, contraire au droit",
    explanation:
        "Le document précise : « INJUSTIFIÉE : sans motif légitime, contraire au droit ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Atteinte - Personnes",
    question:
        "Une atteinte \"actuelle\" au sens de la légitime défense des personnes signifie :",
    options: [
      "Qu'elle a eu lieu dans le passé",
      "Qu'elle se produit ou est imminente",
      "Qu'elle aura lieu plus tard",
    ],
    answer: "Qu'elle se produit ou est imminente",
    explanation:
        "Le texte précise : « ACTUELLE : en train de se produire ou sur le point de se réaliser (imminente) ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Atteinte - Personnes",
    question:
        "Pour être en état de légitime défense, l'atteinte doit être réelle. Cela implique :",
    options: [
      "Qu'une simple crainte subjective suffit",
      "Qu'il faut une existence certaine de l'atteinte",
      "Qu'on peut se fier uniquement à un ressenti",
    ],
    answer: "Qu'il faut une existence certaine de l'atteinte",
    explanation:
        "Le document indique : « RÉELLE : L'atteinte doit exister de manière certaine. Une crainte subjective ne suffit pas ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Acte de défense - Personnes",
    question:
        "Pour la légitime défense des personnes, un acte de défense \"nécessaire\" signifie :",
    options: [
      "Qu'il est le plus efficace possible",
      "Que la personne n'a aucun autre moyen de se soustraire au danger",
      "Qu'il inflige le maximum de dommages à l'agresseur",
    ],
    answer: "Que la personne n'a aucun autre moyen de se soustraire au danger",
    explanation:
        "Le texte précise : « Il faut que la personne atteinte n'ait aucun autre moyen de se soustraire au danger ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Acte de défense - Personnes",
    question:
        "Dans la légitime défense des personnes, l'acte de défense doit être :",
    options: [
      "Nécessaire, simultané et proportionné",
      "Préventif, secret et symbolique",
      "Long, réfléchi et planifié",
    ],
    answer: "Nécessaire, simultané et proportionné",
    explanation:
        "Le schéma liste ces trois conditions pour l'acte de défense : nécessaire, simultané, proportionné.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Acte de défense - Personnes",
    question:
        "Un acte de défense \"simultané\" signifie que la personne se défend :",
    options: [
      "Avant toute atteinte possible",
      "Immédiatement par rapport à l'atteinte",
      "Longtemps après l'atteinte",
    ],
    answer: "Immédiatement par rapport à l'atteinte",
    explanation:
        "Le document indique : « SIMULTANÉ : immédiat par rapport à l'atteinte ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Acte de défense - Personnes",
    question:
        "Peut-on invoquer la légitime défense pour une réaction tardive à une agression passée (vengeance) ?",
    options: [
      "Oui, car l'agresseur a déjà commis une faute",
      "Non, la défense ne doit pas être tardive",
      "Oui, uniquement si l'on prévient la police ensuite",
    ],
    answer: "Non, la défense ne doit pas être tardive",
    explanation:
        "Le schéma précise qu'on ne peut se défendre « par réaction tardive à une atteinte déjà passée (vengeance) ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Acte de défense - Personnes",
    question:
        "La condition de proportionnalité, pour la légitime défense des personnes, signifie que :",
    options: [
      "On peut infliger un mal illimité à l'agresseur",
      "Les moyens de défense doivent être mesurés et en rapport avec la gravité de l'atteinte",
      "On doit toujours utiliser une arme",
    ],
    answer:
        "Les moyens de défense doivent être mesurés et en rapport avec la gravité de l'atteinte",
    explanation:
        "Le texte indique : « Les moyens de défense employés doivent être mesurés et en rapport avec la gravité de l'atteinte ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Légitime défense des biens",
    question:
        "La légitime défense des biens est prévue par quel texte selon le document ?",
    options: [
      "Article 122-5 alinéa 2 du Code pénal",
      "Article 122-6 du Code pénal",
      "Article 122-7 du Code pénal",
    ],
    answer: "Article 122-5 alinéa 2 du Code pénal",
    explanation:
        "Le titre II mentionne : « LA LÉGITIME DÉFENSE D'UN BIEN art. 122-5 al. 2 C.P. ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Légitime défense des biens",
    question: "La légitime défense des biens est décrite comme :",
    options: [
      "Plus large que celle des personnes",
      "Plus limitée que celle des personnes",
      "Strictement identique à celle des personnes",
    ],
    answer: "Plus limitée que celle des personnes",
    explanation:
        "Le texte précise : « Plus limitée que celle des personnes, elle est autorisée… ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Légitime défense des biens",
    question:
        "Pour invoquer la légitime défense d'un bien, celui-ci doit être menacé par :",
    options: [
      "Une simple contravention",
      "Un crime ou un délit",
      "Une injonction administrative",
    ],
    answer: "Un crime ou un délit",
    explanation:
        "Le schéma indique : « Lorsqu'un bien est menacé par l'exécution d'un CRIME ou d'un DÉLIT ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Légitime défense des biens",
    question:
        "Dans la légitime défense d'un bien, l'acte de défense NE doit PAS être :",
    options: [
      "Un acte nécessaire",
      "Un homicide volontaire",
      "Proportionné à la gravité de l'infraction",
    ],
    answer: "Un homicide volontaire",
    explanation:
        "Le texte précise : « un acte de défense, autre qu'un homicide volontaire ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Légitime défense des biens",
    question:
        "La légitime défense des biens impose que l'acte de défense soit :",
    options: [
      "Strictement nécessaire au but poursuivi",
      "Simplement utile",
      "Symbolique",
    ],
    answer: "Strictement nécessaire au but poursuivi",
    explanation:
        "Le texte mentionne : « lorsque cet acte est strictement nécessaire au but poursuivi ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas présumés",
    question: "Les cas présumés de légitime défense sont prévus à l'article :",
    options: [
      "122-5 du Code pénal",
      "122-6 du Code pénal",
      "122-7 du Code pénal",
    ],
    answer: "122-6 du Code pénal",
    explanation:
        "Le titre III indique : « CAS PRÉSUMÉS DE LÉGITIME DÉFENSE art. 122-6 C.P. ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas présumés",
    question:
        "Dans les cas présumés de légitime défense, la personne ayant accompli l'acte est :",
    options: [
      "Présumée avoir agi en état de légitime défense",
      "Présumée coupable d'une infraction",
      "Présumée irresponsable pour cause de trouble mental",
    ],
    answer: "Présumée avoir agi en état de légitime défense",
    explanation:
        "Le texte d'en-tête précise : « EST PRÉSUMÉ AVOIR AGI EN ÉTAT DE LÉGITIME DÉFENSE : CELUI QUI ACCOMPLIT L'ACTE… ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas présumés - 1er cas",
    question:
        "Dans le premier cas présumé de légitime défense, l'acte vise à :",
    options: [
      "Empêcher un vol sur la voie publique",
      "Repousser de nuit l'entrée dans un lieu habité",
      "Protéger un véhicule stationné sur un parking public",
    ],
    answer: "Repousser de nuit l'entrée dans un lieu habité",
    explanation:
        "Le schéma indique : « pour REPOUSSER, DE NUIT [...] L'ENTRÉE [...] DANS UN LIEU HABITÉ ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas présumés - 1er cas",
    question: "Le premier cas présumé de légitime défense suppose une entrée :",
    options: [
      "Par effraction, violence ou ruse",
      "Par simple négligence du propriétaire",
      "Par invitation préalable",
    ],
    answer: "Par effraction, violence ou ruse",
    explanation:
        "Le texte liste : « par EFFRACTION ou par VIOLENCE ou par RUSE ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas présumés - 1er cas",
    question:
        "Le lieu visé dans le premier cas présumé de légitime défense est :",
    options: [
      "Un local commercial",
      "Un lieu habité (maison ou appartement habités)",
      "Un terrain vague",
    ],
    answer: "Un lieu habité (maison ou appartement habités)",
    explanation:
        "Le schéma précise : « DANS UN LIEU HABITÉ : (maison ou appartement habités.) ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas présumés - 1er cas",
    question:
        "Dans le premier cas présumé, la notion de \"nuit\" est définie comme :",
    options: [
      "Toute période après 22 h",
      "Toute période avant 6 h",
      "L'intervalle de temps entre le coucher et le lever du soleil",
    ],
    answer: "L'intervalle de temps entre le coucher et le lever du soleil",
    explanation:
        "Le document rappelle : « DE NUIT (intervalle de temps compris entre le coucher et le lever du soleil) ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas présumés - 2e cas",
    question:
        "Dans le deuxième cas présumé de légitime défense, on se défend contre les auteurs :",
    options: [
      "De vols ou de pillages",
      "De simples injures",
      "De contraventions routières",
    ],
    answer: "De vols ou de pillages",
    explanation:
        "Le schéma vise : « contre les auteurs de VOLS ou de PILLAGES ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas présumés - 2e cas",
    question:
        "Dans le deuxième cas présumé, les vols ou pillages doivent être :",
    options: [
      "Simples, sans violence",
      "Exécutés avec violence",
      "Uniquement commis de nuit",
    ],
    answer: "Exécutés avec violence",
    explanation:
        "Le schéma précise : « EXÉCUTÉS avec VIOLENCE : (Coups, tortures, etc.) ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas présumés - 2e cas",
    question:
        "Le deuxième cas présumé de légitime défense s'applique lorsque la personne se défend :",
    options: [
      "Uniquement de nuit",
      "Uniquement de jour",
      "De jour comme de nuit",
    ],
    answer: "De jour comme de nuit",
    explanation:
        "Le texte indique : « Pour SE DÉFENDRE DE JOUR comme de NUIT contre les auteurs… ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas présumés - nature de la présomption",
    question:
        "La présomption de légitime défense prévue à l'article 122-6 est :",
    options: [
      "Une présomption irréfragable",
      "Une présomption simple pouvant être renversée par la preuve contraire",
      "Une présomption uniquement morale",
    ],
    answer:
        "Une présomption simple pouvant être renversée par la preuve contraire",
    explanation:
        "Le document précise : « Dans les 2 cas, il s'agit d'une PRÉSOMPTION de légitime défense qui peut donc céder devant la preuve contraire. »",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Généralités",
    question:
        "Dans les cas présumés de légitime défense, qui peut apporter la preuve contraire pour renverser la présomption ?",
    options: [
      "La personne poursuivie uniquement",
      "Le juge ou le ministère public au moyen du dossier",
      "Aucun, la présomption est absolue",
    ],
    answer: "Le juge ou le ministère public au moyen du dossier",
    explanation:
        "La mention « peut céder devant la preuve contraire » signifie que la présomption peut être renversée si le juge est convaincu par les éléments du dossier.",
    difficulty: "Facile",
  ),

  // ===================== MOYENNE (≈30) =====================
  const QuizQuestion(
    category: "Personnes - Atteinte",
    question:
        "Une personne reçoit un message anonyme disant : « Je te frapperai demain ». Elle frappe aujourd'hui l'auteur supposé. Peut-elle invoquer la légitime défense des personnes ?",
    options: [
      "Oui, car elle avait peur",
      "Non, l'attaque n'était ni actuelle ni imminente",
      "Oui, car la menace constitue une atteinte réelle",
    ],
    answer: "Non, l'attaque n'était ni actuelle ni imminente",
    explanation:
        "La légitime défense exige une atteinte ACTUELLE ou imminente, pas une simple menace future basée sur une crainte subjective.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Personnes - Atteinte",
    question:
        "Un individu estime que son voisin pourrait un jour l'agresser en raison d'un conflit de voisinage. Il achète une arme et tire préventivement. Selon le document, la légitime défense :",
    options: [
      "S'applique car il anticipait une attaque",
      "Ne s'applique pas car on ne peut se défendre contre une attaque future ou éventuelle",
      "S'applique seulement si le voisin est condamné pour menaces",
    ],
    answer:
        "Ne s'applique pas car on ne peut se défendre contre une attaque future ou éventuelle",
    explanation:
        "Le texte précise que l'acte de défense ne peut viser « une attaque future ou éventuelle (peur) ».",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Personnes - Atteinte",
    question:
        "Un automobiliste pense qu'un piéton va peut-être l'insulter et le frappe avant toute parole. L'atteinte qu'il invoque est-elle réelle au sens du document ?",
    options: [
      "Oui, car il est convaincu d'être menacé",
      "Non, il ne s'agit que d'une crainte subjective",
      "Oui, dès qu'il y a conflit verbal",
    ],
    answer: "Non, il ne s'agit que d'une crainte subjective",
    explanation:
        "Le document souligne qu'une « crainte subjective ne suffit pas » : l'atteinte doit exister de manière certaine.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Personnes - Acte de défense",
    question:
        "Une victime poursuivie dans la rue peut fuir sans danger mais préfère rester et frapper lourdement son poursuivant. La condition de nécessité est-elle remplie ?",
    options: [
      "Oui, car elle peut choisir la riposte",
      "Non, puisqu'elle disposait d'un autre moyen de se soustraire au danger (la fuite sans risque)",
      "Oui, car la fuite n'est jamais exigée",
    ],
    answer:
        "Non, puisqu'elle disposait d'un autre moyen de se soustraire au danger (la fuite sans risque)",
    explanation:
        "La défense doit être NÉCESSAIRE : s'il existe une autre issue sûre pour échapper au danger, cette condition peut faire défaut.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Personnes - Simultanéité",
    question:
        "Une personne est giflée dans un bar. Dix minutes plus tard, à l'extérieur, elle revient frapper violemment l'auteur de la gifle. Peut-elle invoquer la légitime défense ?",
    options: [
      "Oui, car il y a eu une atteinte initiale",
      "Non, il s'agit d'une réaction tardive assimilable à de la vengeance",
      "Oui, si la gifle était très forte",
    ],
    answer:
        "Non, il s'agit d'une réaction tardive assimilable à de la vengeance",
    explanation:
        "Le texte exclut « la réaction tardive à une atteinte déjà passée (vengeance) » de la légitime défense.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Personnes - Proportionnalité",
    question:
        "Quel exemple illustre un défaut de proportionnalité entre l'atteinte et la défense ?",
    options: [
      "Repousser un coup de poing par un coup de poing",
      "Répondre à une claque par plusieurs coups de couteau mortels",
      "Repousser une saisie par une poussée pour se dégager",
    ],
    answer: "Répondre à une claque par plusieurs coups de couteau mortels",
    explanation:
        "La riposte doit être proportionnée à la gravité de l'atteinte ; ici, l'emploi d'une arme létale est manifestement excessif.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Biens - Infraction en cours",
    question:
        "Pour la légitime défense d'un bien, l'acte de défense a pour but principal :",
    options: [
      "D'interrompre l'exécution du crime ou du délit contre le bien",
      "De punir l'auteur après coup",
      "De récupérer la chose volée après plusieurs jours",
    ],
    answer: "D'interrompre l'exécution du crime ou du délit contre le bien",
    explanation:
        "Le texte parle d'un acte de défense visant à « interrompre l'exécution d'un crime ou d'un délit contre un bien ».",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Biens - Homicide exclu",
    question:
        "Un propriétaire surprend un voleur en train de briser la vitre de sa voiture et lui tire dessus mortellement. Peut-il en principe invoquer la légitime défense DES BIENS ?",
    options: [
      "Oui, car c'est un crime contre un bien",
      "Non, car la légitime défense des biens exclut l'homicide volontaire",
      "Oui si la valeur de la voiture est très importante",
    ],
    answer:
        "Non, car la légitime défense des biens exclut l'homicide volontaire",
    explanation:
        "L'article 122-5 al. 2 vise un « acte de défense, autre qu'un homicide volontaire ».",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Biens - Proportionnalité",
    question:
        "Un commerçant surprend un voleur qui emporte une tablette de chocolat. Il le frappe avec une barre de fer lui causant une ITT de 30 jours. La condition de proportionnalité est-elle respectée ?",
    options: [
      "Oui, car le vol est un délit",
      "Non, la riposte est manifestement disproportionnée à la gravité du vol",
      "Oui, car la loi autorise toute violence en cas de vol",
    ],
    answer:
        "Non, la riposte est manifestement disproportionnée à la gravité du vol",
    explanation:
        "Les moyens employés doivent être proportionnés à la gravité de l'infraction ; une violence grave pour un objet de faible valeur est excessive.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Biens - Charge de la preuve",
    question:
        "Selon le document, en cas de légitime défense des biens, qui doit démontrer que la proportionnalité des moyens a été respectée ?",
    options: [
      "Le ministère public",
      "La personne poursuivie",
      "La victime du vol",
    ],
    answer: "La personne poursuivie",
    explanation:
        "Le texte indique : « Il appartient à la personne poursuivie de démontrer que le principe de proportionnalité a été respecté ».",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Biens - Nature de l'infraction",
    question:
        "La tentative de vol d'un bien (délit) en cours d'exécution peut-elle, en principe, justifier la légitime défense des biens ?",
    options: [
      "Oui, car il s'agit d'un délit contre un bien en cours d'exécution",
      "Non, car la tentative ne compte pas",
      "Uniquement si le bien est de grande valeur",
    ],
    answer: "Oui, car il s'agit d'un délit contre un bien en cours d'exécution",
    explanation:
        "La condition est l'exécution d'un crime ou d'un délit contre un bien, ce qui inclut l'exécution d'un vol en cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas présumés - 1er cas",
    question:
        "Une personne repousse à coups de bâton, de nuit, l'entrée par effraction d'un inconnu dans son appartement occupé. Ce cas entre-t-il dans la présomption de légitime défense de l'article 122-6 ?",
    options: [
      "Oui, tous les éléments du premier cas présumé sont réunis",
      "Non, car l'appartement n'est pas un lieu habité",
      "Non, car la personne n'a pas appelé la police",
    ],
    answer: "Oui, tous les éléments du premier cas présumé sont réunis",
    explanation:
        "De nuit, entrée par effraction, dans un lieu habité, pour repousser l'entrée : la présomption de l'article 122-6 joue.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas présumés - 1er cas",
    question:
        "Le premier cas présumé de légitime défense (repousser de nuit l'entrée par effraction dans un lieu habité) s'applique-t-il à un garage désaffecté non habité ?",
    options: [
      "Oui, car c'est un local privé",
      "Non, car ce n'est pas un lieu habité",
      "Oui, s'il y a effraction",
    ],
    answer: "Non, car ce n'est pas un lieu habité",
    explanation:
        "Le texte vise explicitement « un lieu habité : maison ou appartement habités ».",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas présumés - 1er cas",
    question:
        "Un occupant repousse de jour l'entrée par ruse dans son appartement habité. La présomption de légitime défense de l'article 122-6 s'applique-t-elle ?",
    options: [
      "Oui, car il y a ruse",
      "Non, car la présomption exige une entrée de nuit",
      "Oui, car c'est un lieu habité même de jour",
    ],
    answer: "Non, car la présomption exige une entrée de nuit",
    explanation:
        "Le premier cas présumé exige expressément que l'entrée soit repoussée « DE NUIT ».",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas présumés - 2e cas",
    question:
        "Une personne se défend de jour contre des auteurs de vol avec violence dans la rue. Peut-elle bénéficier du deuxième cas présumé de légitime défense ?",
    options: [
      "Oui, car il s'agit de vols exécutés avec violence",
      "Non, car la rue n'est pas un lieu habité",
      "Non, car c'est de jour",
    ],
    answer: "Oui, car il s'agit de vols exécutés avec violence",
    explanation:
        "Le deuxième cas présumé concerne la défense « de jour comme de nuit » contre les auteurs de vols ou pillages exécutés avec violence.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas présumés - 2e cas",
    question:
        "Une personne se défend contre des voleurs qui tentent de la dépouiller sans violence (vol à la tire discret). La présomption de l'article 122-6 s'applique-t-elle ?",
    options: [
      "Oui, dès qu'il y a vol",
      "Non, car les vols doivent être exécutés avec violence",
      "Oui, seulement si c'est de nuit",
    ],
    answer: "Non, car les vols doivent être exécutés avec violence",
    explanation:
        "Le texte mentionne des « VOLS ou PILLAGES exécutés avec violence » ; l'absence de violence exclut la présomption.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas présumés - Preuve contraire",
    question:
        "Dans un cas présumé de légitime défense, il apparaît que la personne a poursuivi l'agresseur en fuite et l'a frappé à terre. Que peut faire le juge ?",
    options: [
      "Il est lié par la présomption et doit relaxer",
      "Il peut écarter la présomption en raison de la preuve contraire",
      "Il doit appliquer automatiquement une atténuation de peine",
    ],
    answer: "Il peut écarter la présomption en raison de la preuve contraire",
    explanation:
        "La présomption est simple et « peut céder devant la preuve contraire ».",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Comparaison personnes/biens",
    question:
        "Quelle différence majeure existe entre la légitime défense des personnes et celle des biens ?",
    options: [
      "Seules les personnes exigent la proportionnalité",
      "La défense des biens exclut l'homicide volontaire alors que la défense des personnes peut aller jusqu'à la mort de l'agresseur si les conditions sont remplies",
      "La défense des biens ne nécessite pas d'infraction",
    ],
    answer:
        "La défense des biens exclut l'homicide volontaire alors que la défense des personnes peut aller jusqu'à la mort de l'agresseur si les conditions sont remplies",
    explanation:
        "L'article 122-5 al. 2 vise expressément un acte de défense « autre qu'un homicide volontaire » pour les biens.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Généralités - Personnes",
    question:
        "Dans la formule générale de l'article 122-5, la légitime défense des personnes exige que l'acte soit commandé par :",
    options: [
      "La colère de la victime",
      "La nécessité de la légitime défense d'elle-même ou d'autrui",
      "Le souci de donner l'exemple",
    ],
    answer: "La nécessité de la légitime défense d'elle-même ou d'autrui",
    explanation:
        "Le texte parle d'un acte « commandé par la nécessité de la légitime défense d'elle-même ou d'autrui ».",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Personnes - Autrui",
    question:
        "Un passant intervient pour protéger une victime inconnue violemment agressée dans le métro. Peut-il, en principe, invoquer la légitime défense des personnes ?",
    options: [
      "Oui, car la défense d'autrui est prévue",
      "Non, seulement la défense de soi-même est prévue",
      "Non, sauf s'il connaît la victime",
    ],
    answer: "Oui, car la défense d'autrui est prévue",
    explanation:
        "L'article 122-5 vise la légitime défense d'elle-même ou d'autrui.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Biens - Strictement nécessaire",
    question:
        "Un commerçant enferme un voleur dans une réserve, l'attache et le frappe pendant une heure. L'exigence d'acte « strictement nécessaire au but poursuivi » est-elle respectée ?",
    options: [
      "Oui, car il a protégé son bien",
      "Non, la séquestration et les coups excèdent le but d'interrompre l'infraction",
      "Oui, car le voleur a commis un délit",
    ],
    answer:
        "Non, la séquestration et les coups excèdent le but d'interrompre l'infraction",
    explanation:
        "L'acte doit être strictement nécessaire au but d'interrompre l'exécution du crime ou du délit, ce qui n'est plus le cas ici.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Biens - Crime ou délit",
    question:
        "La dégradation légère d'un bien constituant une contravention (et non un délit) permet-elle de se prévaloir de la légitime défense des biens de l'article 122-5 al. 2 ?",
    options: [
      "Oui, car il y a atteinte au bien",
      "Non, la loi exige l'exécution d'un crime ou d'un délit",
      "Oui, seulement si c'est de nuit",
    ],
    answer: "Non, la loi exige l'exécution d'un crime ou d'un délit",
    explanation:
        "Le texte vise « un crime ou un délit contre un bien » ; les simples contraventions sont en principe exclues.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Personnes - Simultanéité",
    question:
        "Lors d'une agression, une personne reçoit un coup de poing puis, dans le même mouvement, repousse violemment l'agresseur qui chute. La condition de simultanéité est-elle a priori remplie ?",
    options: [
      "Oui, car la défense est immédiate par rapport à l'atteinte",
      "Non, car elle aurait dû attendre un second coup",
      "Non, car elle n'a pas fui",
    ],
    answer: "Oui, car la défense est immédiate par rapport à l'atteinte",
    explanation:
        "La défense est intervenue dans le même temps que l'agression, ce qui répond à l'exigence de simultanéité.",
    difficulty: "Moyenne",
  ),

  // ===================== DIFFICILE (≈30) =====================
  const QuizQuestion(
    category: "Personnes - Analyse fine",
    question:
        "Une personne insultée gravement (mais sans geste physique) frappe immédiatement l'auteur des insultes. Quel élément de la légitime défense des personnes fait défaut le plus clairement ?",
    options: [
      "L'atteinte injustifiée",
      "L'atteinte actuelle et réelle (atteinte à l'intégrité physique)",
      "La simultanéité",
    ],
    answer: "L'atteinte actuelle et réelle (atteinte à l'intégrité physique)",
    explanation:
        "La légitime défense des personnes vise une atteinte injustifiée à la personne, généralement corporelle ou du moins sérieuse ; de simples injures ne caractérisent pas toujours une atteinte justifiant une riposte violente.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Personnes - Analyse fine",
    question:
        "Une personne menacée au couteau par un agresseur peut, pour se défendre, saisir un objet contondant et blesser gravement l'agresseur. En cas de poursuites, l'analyse de la proportionnalité se fera en comparant :",
    options: [
      "La peur ressentie par la victime et la peine encourue par l'agresseur",
      "Les moyens de défense employés et la gravité de l'atteinte (couteau)",
      "La personnalité de la victime et celle de l'agresseur",
    ],
    answer:
        "Les moyens de défense employés et la gravité de l'atteinte (couteau)",
    explanation:
        "La proportionnalité se mesure entre gravité de l'attaque (arme blanche) et moyens de défense choisis.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Personnes - Cas limite",
    question:
        "Un agent de sécurité repousse un individu qui tente de le frapper avec un poing, en utilisant une clé d'étranglement prolongée, causant un grave dommage. Quel critère risque-t-il d'être jugé non respecté ?",
    options: [
      "La simultanéité",
      "La nécessité et la proportionnalité de la défense",
      "L'injustice de l'atteinte",
    ],
    answer: "La nécessité et la proportionnalité de la défense",
    explanation:
        "Le maintien prolongé d'une clé d'étranglement peut être jugé excessif au regard d'un simple coup de poing.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Biens - Cas pratique",
    question:
        "Un propriétaire déclenche manuellement, au moment où il aperçoit un voleur pénétrer dans son entrepôt pour voler du matériel, un dispositif automatique qui enferme le voleur dans une cage métallique sans lui causer de blessure. Au regard de l'article 122-5 al. 2, cette riposte :",
    options: [
      "Pourrait être considérée comme strictement nécessaire et proportionnée",
      "Est exclue car il n'y a pas de violence physique",
      "Est toujours illégale",
    ],
    answer:
        "Pourrait être considérée comme strictement nécessaire et proportionnée",
    explanation:
        "Le dispositif vise à interrompre le délit sans porter d'atteinte corporelle grave, ce qui peut répondre aux exigences de nécessité et proportionnalité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Biens - Homicide et personnes",
    question:
        "Un individu vole un sac à main en tirant violemment sur la victime, qui chute. Le compagnon de la victime tire immédiatement, à balle réelle, sur le voleur et le tue. Sur le terrain de la légitime défense DES PERSONNES, l'homicide pourrait-il être examiné ?",
    options: [
      "Oui, car il s'agit de défendre la victime contre une agression violente en cours",
      "Non, car l'homicide est toujours exclu en légitime défense",
      "Non, car seule la défense des biens est possible",
    ],
    answer:
        "Oui, car il s'agit de défendre la victime contre une agression violente en cours",
    explanation:
        "La défense porte ici sur la personne agressée (violence au moment du vol) ; la légitime défense des PERSONNES peut théoriquement aller jusqu'à l'homicide si les autres conditions sont réunies.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas présumés - Interprétation",
    question:
        "Dans le premier cas présumé (entrée de nuit par effraction dans un lieu habité), la personne qui frappe l'intrus à l'extérieur de l'immeuble, alors que celui-ci rebrousse chemin avant l'entrée, peut-elle bénéficier automatiquement de la présomption ?",
    options: [
      "Oui, car l'intention d'entrer suffit",
      "Non, car l'acte ne vise plus à repousser l'entrée dans le lieu habité",
      "Oui, dès que c'est de nuit",
    ],
    answer:
        "Non, car l'acte ne vise plus à repousser l'entrée dans le lieu habité",
    explanation:
        "La présomption suppose que l'acte soit accompli pour « repousser l'entrée » ; une poursuite à l'extérieur peut apparaître détachée de ce but.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas présumés - Interprétation",
    question:
        "Un occupant blesse gravement un individu qui, de nuit, force la porte de son appartement habité à coups de pied (violence) et réussit à pénétrer. L'occupant le frappe alors. La présomption de l'article 122-6 :",
    options: [
      "Ne s'applique jamais une fois l'intrus entré",
      "Peut encore s'appliquer car l'acte vise à repousser l'entrée ou l'intrusion en cours",
      "Ne concerne que les tentatives d'entrée avortées",
    ],
    answer:
        "Peut encore s'appliquer car l'acte vise à repousser l'entrée ou l'intrusion en cours",
    explanation:
        "La jurisprudence admet que la défense pendant la pénétration peut encore être rattachée au fait de repousser l'entrée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas présumés - Vols violents",
    question:
        "Une victime se défend de jour contre les auteurs d'un pillage commis sans violence sur les personnes (uniquement dégradations de biens). Peut-elle bénéficier du deuxième cas présumé ?",
    options: [
      "Oui, car le texte parle de pillage",
      "Non, car les vols ou pillages doivent être exécutés avec violence (coups, tortures, etc.)",
      "Oui, dès qu'il y a plusieurs auteurs",
    ],
    answer:
        "Non, car les vols ou pillages doivent être exécutés avec violence (coups, tortures, etc.)",
    explanation:
        "Le texte souligne expressément l'exécution « avec violence ».",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Personnes/Biens - Qualification",
    question:
        "Un individu tente d'incendier un immeuble habité de nuit. Un occupant sort et lui inflige des blessures pour l'empêcher de poursuivre. Juridiquement, la défense peut être analysée prioritairement comme :",
    options: [
      "Une légitime défense des biens uniquement",
      "Une légitime défense des personnes (occupants menacés) ET des biens",
      "Un cas présumé de l'article 122-6",
    ],
    answer:
        "Une légitime défense des personnes (occupants menacés) ET des biens",
    explanation:
        "L'incendie met en danger les personnes et les biens ; la défense des personnes (plus favorable) sera souvent mobilisée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Biens - Charge probatoire",
    question:
        "Dans une affaire de défense de biens, le prévenu affirme avoir seulement poussé un voleur pour l'arrêter, tandis que les blessures constatées laissent penser à des coups répétés. Concernant la proportionnalité, le document rappelle que :",
    options: [
      "Le doute profite toujours au prévenu sans aucune analyse",
      "La preuve du respect de la proportionnalité pèse sur la personne poursuivie",
      "Le ministère public doit prouver l'absence totale de proportionnalité",
    ],
    answer:
        "La preuve du respect de la proportionnalité pèse sur la personne poursuivie",
    explanation:
        "L'article précise que « la personne poursuivie » doit démontrer que le principe de proportionnalité a été respecté.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Personnes - Nécessité",
    question:
        "Un policier en civil est frappé par un individu. Il se trouve à proximité immédiate de collègues en uniforme vers lesquels il pourrait se réfugier sans danger. Il choisit malgré tout une riposte très violente. Quel critère de la légitime défense peut être contesté ?",
    options: [
      "L'atteinte injustifiée",
      "La nécessité (absence d'autre moyen pour se soustraire au danger)",
      "La simultanéité",
    ],
    answer: "La nécessité (absence d'autre moyen pour se soustraire au danger)",
    explanation:
        "La possibilité de se soustraire au danger en rejoignant les collègues peut conduire à considérer que la riposte n'était pas strictement nécessaire.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Personnes - Peur vs réalité",
    question:
        "Une personne souffrant de paranoïa croit que son voisin veut la tuer. Sans geste hostile de ce voisin, elle l'attaque par \"prévention\". Selon le document, la légitime défense :",
    options: [
      "Est exclue, la simple crainte subjective étant insuffisante",
      "Est admise, car la peur est sincère",
      "Est acquise dès qu'il existe un conflit",
    ],
    answer: "Est exclue, la simple crainte subjective étant insuffisante",
    explanation:
        "Le texte insiste sur le caractère RÉEL de l'atteinte et précise qu'une crainte subjective ne suffit pas.",
    difficulty: "Difficile",
  ),

  // ===================== Difficile (≈30) =====================
  const QuizQuestion(
    category: "Difficile - Articulation 122-5 / 122-6",
    question:
        "Lorsque la présomption de légitime défense de l'article 122-6 est écartée par la preuve contraire, le juge :",
    options: [
      "Ne peut plus examiner la légitime défense au regard de l'article 122-5",
      "Peut encore contrôler si les conditions de la légitime défense de droit commun (art. 122-5) sont réunies",
      "Doit automatiquement condamner le prévenu",
    ],
    answer:
        "Peut encore contrôler si les conditions de la légitime défense de droit commun (art. 122-5) sont réunies",
    explanation:
        "L'échec de la présomption n'exclut pas l'examen de la légitime défense classique.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Difficile - Qualification mixte",
    question:
        "Lorsqu'une personne repousse, de nuit, l'entrée par effraction d'un cambrioleur dans sa maison, en lui tirant mortellement dessus, l'analyse juridique la plus complète consiste à :",
    options: [
      "Écarter d'emblée la légitime défense car il y a homicide",
      "Examiner d'abord la présomption de l'article 122-6, puis la légitime défense des personnes (art. 122-5) pour apprécier nécessité et proportionnalité",
      "Appliquer automatiquement une excuse atténuante",
    ],
    answer:
        "Examiner d'abord la présomption de l'article 122-6, puis la légitime défense des personnes (art. 122-5) pour apprécier nécessité et proportionnalité",
    explanation:
        "L'homicide interdit la légitime défense DES BIENS mais la défense DES PERSONNES reste envisageable, sous contrôle strict de proportionnalité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Difficile - Biens et personnes",
    question:
        "Dans un vol avec violence, la victime protège à la fois son intégrité physique et son sac à main. La légitime défense sera en priorité fondée sur :",
    options: [
      "La défense des biens (art. 122-5 al. 2)",
      "La défense des personnes (art. 122-5 al. 1)",
      "Uniquement les cas présumés de l'article 122-6",
    ],
    answer: "La défense des personnes (art. 122-5 al. 1)",
    explanation:
        "En pratique, lorsqu'une atteinte aux personnes existe, le régime plus large de la défense des personnes est privilégié.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Difficile - Crime contre un bien",
    question:
        "Un individu tente de commettre un crime d'incendie volontaire contre un entrepôt vide. Le propriétaire intervient et blesse légèrement l'auteur avec une arme non létale. Sur le terrain de la légitime défense des biens, le juge devra principalement vérifier :",
    options: [
      "Que l'acte de défense était autre qu'un homicide volontaire, strictement nécessaire et proportionné à la gravité de l'infraction (crime d'incendie)",
      "Uniquement que l'entrepôt ait une grande valeur",
      "Uniquement que le propriétaire ait porté plainte auparavant",
    ],
    answer:
        "Que l'acte de défense était autre qu'un homicide volontaire, strictement nécessaire et proportionné à la gravité de l'infraction (crime d'incendie)",
    explanation:
        "Ce sont les trois axes d'analyse prévus à l'article 122-5 al. 2.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Difficile - Intrusion nocturne",
    question:
        "Une personne installe un piège automatique létal dans son couloir (fusil relié à la porte) pour se protéger des intrusions nocturnes. Aucune présence humaine n'est requise au déclenchement. En cas de décès d'un cambrioleur, la qualification de légitime défense :",
    options: [
      "Est exclue car la défense n'est pas exécutée dans le même temps par la personne (absence d'acte commandé par la nécessité immédiate)",
      "Est acquise d'office en raison de la présomption de l'article 122-6",
      "Est automatique puisque le vol est nocturne",
    ],
    answer:
        "Est exclue car la défense n'est pas exécutée dans le même temps par la personne (absence d'acte commandé par la nécessité immédiate)",
    explanation:
        "La légitime défense suppose un acte humain accompli dans le même temps en réaction à l'atteinte ; un piège automatique préprogrammé ne répond pas à cette exigence.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Difficile - Appréciation in concreto",
    question:
        "Dans l'appréciation de la proportionnalité en légitime défense, la jurisprudence tient compte :",
    options: [
      "Uniquement de la valeur du bien protégé",
      "Des circonstances concrètes de l'agression (heure, lieu, nombre d'agresseurs, moyens employés, vulnérabilité de la victime)",
      "Uniquement du casier judiciaire de l'agresseur",
    ],
    answer:
        "Des circonstances concrètes de l'agression (heure, lieu, nombre d'agresseurs, moyens employés, vulnérabilité de la victime)",
    explanation:
        "La proportionnalité est appréciée in concreto, au regard de l'ensemble de la situation au moment des faits.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Difficile - Poursuite de l'agresseur",
    question:
        "Une victime parvient à faire fuir son agresseur. Dix minutes plus tard, elle le retrouve à distance, sans danger immédiat, et le frappe. Sur le terrain de la légitime défense :",
    options: [
      "La simultanéité fait défaut, l'acte s'analysant comme une vengeance",
      "La nécessité est renforcée",
      "La présomption de l'article 122-6 s'applique",
    ],
    answer:
        "La simultanéité fait défaut, l'acte s'analysant comme une vengeance",
    explanation:
        "La défense ne peut être une « réaction tardive à une atteinte déjà passée (vengeance) ».",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Difficile - Défense d'autrui",
    question:
        "Un individu neutralise violemment un agresseur qui tente d'étrangler une victime. Il est poursuivi pour violences aggravées. Pour caractériser la légitime défense d'autrui, le juge devra examiner notamment :",
    options: [
      "Si l'atteinte à autrui était injustifiée, actuelle et réelle, et si la riposte était nécessaire, simultanée et proportionnée",
      "Uniquement la réalité de la strangulation",
      "Uniquement l'absence de fuite possible de la victime",
    ],
    answer:
        "Si l'atteinte à autrui était injustifiée, actuelle et réelle, et si la riposte était nécessaire, simultanée et proportionnée",
    explanation:
        "Les mêmes critères que pour la défense de soi s'appliquent à la défense d'autrui.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Difficile - Chevauchement biens/personnes",
    question:
        "Lorsqu'un cambrioleur pénètre de nuit dans un appartement occupé, armé d'un couteau, la défense de l'occupant sera juridiquement fondée :",
    options: [
      "Uniquement sur la défense des biens",
      "Uniquement sur la présomption de l'article 122-6",
      "À la fois sur la présomption de l'article 122-6 et sur la défense des personnes, compte tenu du danger pour les occupants",
    ],
    answer:
        "À la fois sur la présomption de l'article 122-6 et sur la défense des personnes, compte tenu du danger pour les occupants",
    explanation:
        "Le danger vise aussi la vie des personnes ; le juge combinera souvent ces deux approches.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Manifestations – Cadre général",
    question:
        "La manifestation sur la voie publique est principalement encadrée par :",
    options: [
      "Le Code du travail",
      "Les articles L.211-1 et suivants du Code de la sécurité intérieure",
      "Les articles 431-1 et suivants du Code pénal",
    ],
    answer:
        "Les articles L.211-1 et suivants du Code de la sécurité intérieure",
    explanation:
        "Le régime juridique des cortèges, défilés et rassemblements sur la voie publique est organisé par les articles L.211-1 et suivants du Code de la sécurité intérieure.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Déclaration",
    question:
        "L’un des principaux objectifs de la déclaration préalable de manifestation est :",
    options: [
      "D’augmenter le nombre de manifestants",
      "De permettre à l’autorité de police d’évaluer les risques et d’adapter le dispositif",
      "D’identifier les personnes qui assisteront en tant que simples spectateurs",
    ],
    answer:
        "De permettre à l’autorité de police d’évaluer les risques et d’adapter le dispositif",
    explanation:
        "La déclaration permet la préparation opérationnelle : évaluation des risques, effectifs à prévoir, itinéraire, mesures de sécurité.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Itinéraire",
    question: "L’itinéraire d’un cortège déclaré doit être :",
    options: [
      "Imposé uniquement par le préfet",
      "Précisé dans la déclaration pour permettre l’organisation du dispositif de sécurité",
      "Toujours tenu secret pour les forces de l’ordre",
    ],
    answer:
        "Précisé dans la déclaration pour permettre l’organisation du dispositif de sécurité",
    explanation:
        "La déclaration doit comporter l’itinéraire lorsqu’il s’agit d’un défilé, afin de dimensionner les moyens et de sécuriser le parcours.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Organisateurs",
    question:
        "Les organisateurs d’une manifestation sont particulièrement responsables :",
    options: [
      "Du comportement des forces de l’ordre",
      "Du respect de l’itinéraire et des consignes de sécurité communiqués",
      "De la rédaction des procès-verbaux de police",
    ],
    answer:
        "Du respect de l’itinéraire et des consignes de sécurité communiqués",
    explanation:
        "Les organisateurs sont interlocuteurs de l’autorité et doivent veiller au respect des modalités arrêtées (itinéraire, horaires, encadrement).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Non-déclaration",
    question: "Une manifestation organisée sans déclaration préalable est :",
    options: [
      "Toujours autorisée si elle est pacifique",
      "Susceptible de constituer une infraction pour les organisateurs",
      "Sans conséquence juridique",
    ],
    answer: "Susceptible de constituer une infraction pour les organisateurs",
    explanation:
        "L’article 431-9 du Code Pénal. sanctionne l’organisation d’une manifestation non déclarée ou malgré interdiction.",
    difficulty: "Facile",
  ),
  // ===================== BLOC 3 – Nouvelles questions (50) =====================

  // ===================== NIVEAU FACILE =====================
  const QuizQuestion(
    category: "Notions générales",
    question:
        "Parmi les propositions suivantes, laquelle relève d’une liberté publique collective ?",
    options: [
      "La liberté d’aller et venir",
      "La liberté de manifester",
      "Le droit au respect de la vie privée",
    ],
    answer: "La liberté de manifester",
    explanation:
        "La liberté de manifester s’exerce collectivement, contrairement à des libertés essentiellement individuelles comme la vie privée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Distinction",
    question:
        "La manifestation sur la voie publique se distingue principalement de l’attroupement par :",
    options: [
      "L’existence d’une déclaration préalable à l’autorité de police",
      "La présence obligatoire de banderoles",
      "La diffusion de musique",
    ],
    answer: "L’existence d’une déclaration préalable à l’autorité de police",
    explanation:
        "La manifestation est en principe déclarée, alors que l’attroupement est un rassemblement susceptible de troubler l’ordre public sans nécessaire déclaration.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Lieu de déclaration",
    question:
        "À Paris, la déclaration préalable de manifestation doit être déposée :",
    options: [
      "À la mairie de l’arrondissement",
      "À la préfecture de police",
      "Au tribunal judiciaire",
    ],
    answer: "À la préfecture de police",
    explanation:
        "À Paris, c’est la préfecture de police qui reçoit les déclarations de manifestations (art. L.211-1 C.S.I. et suivants).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Délai",
    question:
        "Le délai légal pour déposer une déclaration de manifestation est de :",
    options: [
      "Au moins 3 jours francs et au plus 15 jours francs avant la date",
      "Au moins 24 heures avant la date",
      "Exactement 30 jours avant la date",
    ],
    answer: "Au moins 3 jours francs et au plus 15 jours francs avant la date",
    explanation:
        "Ce délai permet à l’autorité d’anticiper et d’organiser les mesures nécessaires au maintien de l’ordre.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Exceptions",
    question:
        "Les manifestations traditionnelles à caractère folklorique ou religieux :",
    options: [
      "Sont en principe exemptées de déclaration préalable",
      "Sont automatiquement interdites",
      "Sont toujours soumises à un régime criminel",
    ],
    answer: "Sont en principe exemptées de déclaration préalable",
    explanation:
        "L’article L.211-1 C.S.I. réserve une exception pour certaines manifestations traditionnelles.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Organisateurs",
    question: "Les organisateurs d’une manifestation doivent être :",
    options: [
      "Majeurs et clairement identifiés dans la déclaration",
      "Obligatoirement des élus",
      "Uniquement des associations reconnues d’utilité publique",
    ],
    answer: "Majeurs et clairement identifiés dans la déclaration",
    explanation:
        "L’autorité doit pouvoir identifier des interlocuteurs responsables et joignables.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Récépissé",
    question:
        "Lorsqu’une déclaration de manifestation est déposée, l’autorité doit :",
    options: [
      "Remettre immédiatement un récépissé",
      "Conserver la déclaration secrète",
      "Transmettre automatiquement au juge d’instruction",
    ],
    answer: "Remettre immédiatement un récépissé",
    explanation:
        "Le récépissé atteste de la déclaration et pourra être présenté lors de contrôles.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Sanction organisateur",
    question:
        "Organiser une manifestation non déclarée ou interdite est puni :",
    options: [
      "D’un simple rappel à la loi",
      "De 6 mois d’emprisonnement et 7 500 € d’amende (art. 431-9 du Code Pénal.)",
      "D’une peine criminelle",
    ],
    answer:
        "De 6 mois d’emprisonnement et 7 500 € d’amende (art. 431-9 du Code Pénal.)",
    explanation:
        "Le Code pénal sanctionne sévèrement l’organisation d’une manifestation illégale.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Attroupements – Nombre de personnes",
    question: "Pour qu’il y ait attroupement au sens de la loi pénale :",
    options: [
      "Il suffit d’un rassemblement de plusieurs personnes",
      "Il faut obligatoirement plus de 1 000 personnes",
      "Il faut au moins 100 personnes armées",
    ],
    answer: "Il suffit d’un rassemblement de plusieurs personnes",
    explanation:
        "Le texte ne fixe pas de seuil chiffré ; c’est l’aptitude à troubler l’ordre public qui caractérise l’attroupement.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Attroupements – Sommations",
    question:
        "Avant d’avoir recours à la force pour disperser un attroupement, il est en principe nécessaire :",
    options: [
      "D’effectuer deux sommations réglementaires",
      "D’attendre la tombée de la nuit",
      "De consulter un juge",
    ],
    answer: "D’effectuer deux sommations réglementaires",
    explanation:
        "L’article R.211-11 C.S.I. impose en principe deux sommations avant l’usage de la force.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Attroupements – Visage dissimulé",
    question:
        "Participer à un attroupement après sommations en dissimulant volontairement son visage :",
    options: [
      "N’a pas d’incidence",
      "Aggrave la peine encourue",
      "Est obligatoire pour tous les participants",
    ],
    answer: "Aggrave la peine encourue",
    explanation:
        "Les textes aggravent la répression lorsque la personne dissimule son visage pour échapper à l’identification.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Presse – Fondement constitutionnel",
    question: "La liberté de la presse trouve son principal fondement dans :",
    options: [
      "L’article 11 de la Déclaration de 1789",
      "L’article 16 de la Constitution de 1958",
      "Le Code de la route",
    ],
    answer: "L’article 11 de la Déclaration de 1789",
    explanation:
        "L’article 11 consacre la libre communication des pensées et des opinions, base de la liberté de la presse.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Presse – Grande loi",
    question: "La « charte » de la liberté de la presse en France est :",
    options: [
      "La loi du 29 juillet 1881",
      "La loi du 5 mars 2007",
      "L’ordonnance de 1944 uniquement",
    ],
    answer: "La loi du 29 juillet 1881",
    explanation:
        "Cette loi organise le régime libéral de la presse et les délits de presse.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Presse – Journalistes",
    question: "La carte d’identité de journaliste professionnel :",
    options: [
      "Est délivrée par une commission paritaire",
      "Est délivrée par la mairie",
      "Est automatiquement obtenue après un an de travail",
    ],
    answer: "Est délivrée par une commission paritaire",
    explanation:
        "Une commission composée de journalistes et d’éditeurs attribue la carte, selon des critères précis.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Presse – Délit de fausses nouvelles",
    question:
        "La publication de fausses nouvelles de nature à troubler la paix publique :",
    options: [
      "Est toujours sans sanction",
      "Constitue une infraction de presse prévue par la loi de 1881",
      "Relève du Code de la route",
    ],
    answer: "Constitue une infraction de presse prévue par la loi de 1881",
    explanation:
        "L’article 27 de la loi de 1881 réprime la diffusion de fausses nouvelles dangereuses pour la paix publique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Presse – Délai de prescription",
    question:
        "En matière de délits de presse, le délai de prescription « de droit commun » est :",
    options: ["De 3 mois", "De 2 ans", "De 10 ans"],
    answer: "De 3 mois",
    explanation:
        "Sauf cas particuliers (notamment faits à caractère raciste), les délits de presse se prescrivent par trois mois.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU MOYEN =====================
  const QuizQuestion(
    category: "Manifestations – Contenu déclaration",
    question:
        "La déclaration préalable d’une manifestation doit notamment comporter :",
    options: [
      "Les seules coordonnées des journalistes présents",
      "L’identité des organisateurs, l’objet, le lieu, la date, l’horaire et, le cas échéant, l’itinéraire",
      "Une liste complète de tous les participants",
    ],
    answer:
        "L’identité des organisateurs, l’objet, le lieu, la date, l’horaire et, le cas échéant, l’itinéraire",
    explanation:
        "Ces informations permettent à l’autorité d’apprécier les risques et d’organiser le maintien de l’ordre.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Manifestations – Pouvoir de substitution",
    question:
        "Si le maire refuse d’interdire une manifestation alors que le risque de trouble grave est manifeste, le préfet :",
    options: [
      "Ne peut rien faire",
      "Peut se substituer à lui et prendre lui-même l’arrêté d’interdiction",
      "Doit saisir le Conseil constitutionnel",
    ],
    answer:
        "Peut se substituer à lui et prendre lui-même l’arrêté d’interdiction",
    explanation:
        "Le préfet peut se substituer au maire défaillant en matière de maintien de l’ordre (police administrative).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Manifestations – Contravention R.644-4 du Code Pénal.",
    question: "L’article R.644-4 du Code pénal vise :",
    options: [
      "Le simple fait de regarder une manifestation",
      "La participation à une manifestation interdite sur le fondement de l’article L.211-4 C.S.I.",
      "Le refus de lire le journal officiel",
    ],
    answer:
        "La participation à une manifestation interdite sur le fondement de l’article L.211-4 C.S.I.",
    explanation:
        "Cet article prévoit une contravention de 4 ème classe pour la participation à une manifestation interdite.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Manifestations – Peines complémentaires",
    question:
        "L’interdiction de participer à des manifestations sur la voie publique pour une durée maximale de 3 ans :",
    options: [
      "Ne peut jamais être prononcée",
      "Constitue une peine complémentaire possible (art. 131-32-1 du Code Pénal.)",
      "Est automatique pour toute personne interpellée",
    ],
    answer:
        "Constitue une peine complémentaire possible (art. 131-32-1 du Code Pénal.)",
    explanation:
        "Le juge peut l’ordonner pour certains délits commis lors de manifestations.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Manifestations – Responsabilité de l’État",
    question:
        "Les dommages causés lors de crimes ou délits commis à force ouverte ou par violence au cours d’une manifestation :",
    options: [
      "Ne donnent jamais lieu à indemnisation",
      "Engagent la responsabilité civile de l’État de plein droit (art. L.211-10 C.S.I.)",
      "Sont toujours exclusivement à la charge des communes",
    ],
    answer:
        "Engagent la responsabilité civile de l’État de plein droit (art. L.211-10 C.S.I.)",
    explanation:
        "L’État peut ensuite se retourner contre les auteurs, mais répond de plein droit vis-à-vis des victimes.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attroupements – Textes applicables",
    question:
        "Le régime juridique des attroupements est principalement fixé par :",
    options: [
      "Les articles 431-3 à 431-8-1 du Code Pénal. et L.211-9 à L.211-10 C.S.I.",
      "Le Code de commerce",
      "Uniquement la loi de 1881",
    ],
    answer:
        "Les articles 431-3 à 431-8-1 du Code Pénal. et L.211-9 à L.211-10 C.S.I.",
    explanation:
        "Ces textes organisent définition, dispersion, infractions et réparation des dommages.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attroupements – Nature politique",
    question:
        "Le fait que le délit d’attroupement soit qualifié de « délit politique » par la Cour de cassation :",
    options: [
      "Empêche toute poursuite",
      "Influe sur certains régimes (extradition, etc.) mais n’empêche pas la comparution immédiate",
      "Signifie qu’il relève des juridictions administratives",
    ],
    answer:
        "Influe sur certains régimes (extradition, etc.) mais n’empêche pas la comparution immédiate",
    explanation:
        "La loi a expressément prévu la possibilité des procédures rapides malgré cette qualification.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attroupements – Insignes distinctifs",
    question:
        "Lors des sommations de dispersion, les autorités habilitées doivent :",
    options: [
      "Être en civil sans signe distinctif",
      "Porter des insignes distinctifs (écharpe ou brassard tricolore selon la fonction)",
      "Se masquer le visage",
    ],
    answer:
        "Porter des insignes distinctifs (écharpe ou brassard tricolore selon la fonction)",
    explanation:
        "L’article R.211-12 C.S.I. impose ces insignes pour matérialiser l’autorité civile qui procède aux sommations.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attroupements – Participation armée",
    question:
        "Participer à un attroupement en étant porteur d’une arme (art. 431-5 du Code Pénal.) est puni :",
    options: [
      "D’une simple amende",
      "De 3 ans d’emprisonnement et 45 000 € d’amende, voire plus en cas de visage dissimulé",
      "Uniquement d’un travail d’intérêt général",
    ],
    answer:
        "De 3 ans d’emprisonnement et 45 000 € d’amende, voire plus en cas de visage dissimulé",
    explanation:
        "Le texte prévoit une aggravation si le visage est dissimulé après sommations.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Transparence capitalistique",
    question:
        "Les règles de transparence des entreprises de presse visant à identifier actionnaires et dirigeants ont pour but principal :",
    options: [
      "D’organiser un contrôle policier permanent",
      "De permettre au lecteur de connaître les intérêts en présence et de garantir le pluralisme",
      "De fixer les prix de vente des journaux",
    ],
    answer:
        "De permettre au lecteur de connaître les intérêts en présence et de garantir le pluralisme",
    explanation:
        "La transparence est un outil de protection de la liberté d’expression et du pluralisme.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Clause de conscience",
    question: "La clause de conscience permet au journaliste :",
    options: [
      "De refuser tout contrôle hiérarchique",
      "De rompre son contrat avec des indemnités majorées en cas de changement notable de la ligne du journal portant atteinte à ses intérêts moraux",
      "De s’opposer à toute sanction disciplinaire",
    ],
    answer:
        "De rompre son contrat avec des indemnités majorées en cas de changement notable de la ligne du journal portant atteinte à ses intérêts moraux",
    explanation:
        "Elle protège l’indépendance morale du journaliste en cas de cession ou de changement de ligne éditoriale.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Entreprise de presse",
    question:
        "Les règles limitant les investissements étrangers dans les entreprises de presse ont pour objectif :",
    options: [
      "D’empêcher tout financement",
      "De préserver l’indépendance nationale de l’information",
      "De favoriser les monopoles privés",
    ],
    answer: "De préserver l’indépendance nationale de l’information",
    explanation:
        "Elles visent à éviter que des puissances étrangères contrôlent des organes d’information stratégique.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Secret des sources (limites)",
    question: "Le secret des sources des journalistes peut être levé :",
    options: [
      "Uniquement pour convenance de la police",
      "En présence d’un impératif prépondérant d’intérêt public, par des mesures nécessaires et proportionnées",
      "Jamais, en aucune circonstance",
    ],
    answer:
        "En présence d’un impératif prépondérant d’intérêt public, par des mesures nécessaires et proportionnées",
    explanation:
        "C’est l’équilibre recherché par la loi et la jurisprudence entre liberté de la presse et exigences de la justice.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Responsabilité en cascade",
    question:
        "En matière de délits de presse, la personne principalement responsable est :",
    options: [
      "Le directeur de la publication pour les écrits périodiques",
      "Le vendeur de journaux",
      "Le lecteur",
    ],
    answer: "Le directeur de la publication pour les écrits périodiques",
    explanation:
        "La loi de 1881 organise un système de responsabilité dite « en cascade » qui commence par le directeur de publication.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Publication jeunesse",
    question:
        "Lorsqu’un juge ordonne la saisie d’une publication dangereuse pour la jeunesse (incitation à la violence, pornographie) :",
    options: [
      "Il porte atteinte à la liberté de la presse mais dans le cadre des limites prévues par la loi",
      "Il viole automatiquement la Constitution",
      "Il doit saisir le Conseil de sécurité de l’ONU",
    ],
    answer:
        "Il porte atteinte à la liberté de la presse mais dans le cadre des limites prévues par la loi",
    explanation:
        "La liberté de la presse n’est pas absolue ; elle est conciliée avec la protection des mineurs et de l’ordre public.",
    difficulty: "Moyenne",
  ),

  // ===================== NIVEAU DIFFICILE (inclut Difficile) =====================
  const QuizQuestion(
    category: "Manifestations – Mesures préventives",
    question:
        "L’article L.211-3 C.S.I. autorisant l’interdiction temporaire du port d’objets pouvant constituer une arme par destination suppose :",
    options: [
      "Un simple souhait du préfet",
      "L’existence de risques sérieux de troubles graves à l’ordre public dans un périmètre et une durée déterminés",
      "Qu’un crime ait déjà été commis",
    ],
    answer:
        "L’existence de risques sérieux de troubles graves à l’ordre public dans un périmètre et une durée déterminés",
    explanation:
        "La mesure doit être justifiée, ciblée et proportionnée au risque anticipé.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Manifestations – Réquisitions 78-2-5 CPP",
    question:
        "Les réquisitions du procureur de la République fondées sur l’article 78-2-5 CPP lors d’une manifestation doivent :",
    options: [
      "Pouvoir être orales et générales",
      "Être écrites, préciser les lieux, la durée et les infractions visées (ex. port d’armes lors d’une réunion publique)",
      "Être validées par le Conseil constitutionnel",
    ],
    answer:
        "Être écrites, préciser les lieux, la durée et les infractions visées (ex. port d’armes lors d’une réunion publique)",
    explanation:
        "Elles encadrent les contrôles de bagages ou de véhicules, pour garantir le respect des libertés individuelles.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Manifestations – État d’urgence & contrôle",
    question:
        "Même en état d’urgence ou régime d’exception, les interdictions générales de manifester :",
    options: [
      "Échappent à tout contrôle juridictionnel",
      "Restent contrôlées par le juge administratif (nécessité, proportionnalité, adaptation)",
      "Sont décidées exclusivement par le président du Sénat",
    ],
    answer:
        "Restent contrôlées par le juge administratif (nécessité, proportionnalité, adaptation)",
    explanation:
        "Les juridictions administratives veillent à la conciliation entre sauvegarde de l’ordre public et libertés fondamentales.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Attroupements – Article 431-4 du Code Pénal.",
    question:
        "Pour que l’infraction de participation à un attroupement après sommations (art. 431-4 du Code Pénal.) soit constituée, il faut notamment :",
    options: [
      "Que la personne soit restée volontairement après les sommations et qu’elles aient été régulièrement faites",
      "Qu’il y ait au moins 500 personnes",
      "Que les forces de l’ordre soient armées",
    ],
    answer:
        "Que la personne soit restée volontairement après les sommations et qu’elles aient été régulièrement faites",
    explanation:
        "La preuve des sommations et de la présence persistante de la personne est centrale pour la qualification.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Attroupements – Article 431-6 du Code Pénal.",
    question:
        "La provocation directe à un attroupement armé réprimée par l’article 431-6 du Code Pénal. vise :",
    options: [
      "Uniquement les discours prononcés dans une salle fermée",
      "Les discours, écrits ou tout autre moyen de communication publique",
      "Uniquement les tracts distribués dans la rue",
    ],
    answer:
        "Les discours, écrits ou tout autre moyen de communication publique",
    explanation:
        "Le champ est large et inclut les différents vecteurs de diffusion, y compris modernes (réseaux sociaux).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Attroupements – Documentation pour l’action récursoire",
    question:
        "En vue de l’action récursoire de l’État après des dégradations commises lors d’attroupements, les forces de l’ordre doivent :",
    options: [
      "Se limiter à un compte-rendu très succinct",
      "Réaliser des constatations détaillées (photos, vidéos, descriptions), identités, et les consigner avec précision",
      "Ne conserver aucune trace pour préserver la paix sociale",
    ],
    answer:
        "Réaliser des constatations détaillées (photos, vidéos, descriptions), identités, et les consigner avec précision",
    explanation:
        "La qualité des procès-verbaux conditionne la possibilité pour l’État d’agir contre les auteurs.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Attroupements – Usage des armes non létales",
    question:
        "L’usage de certaines armes non létales (ex. LBD, grenades de désencerclement) dans le cadre des attroupements :",
    options: [
      "Peut intervenir seulement après sommations, sauf cas d’urgence définis par la loi",
      "Est entièrement discrétionnaire",
      "Ne fait l’objet d’aucune traçabilité",
    ],
    answer:
        "Peut intervenir seulement après sommations, sauf cas d’urgence définis par la loi",
    explanation:
        "L’usage est encadré par le C.S.I. (nécessité, proportionnalité, procédure) et doit pouvoir être justifié.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Pluralisme (C. const.)",
    question:
        "Le Conseil constitutionnel a érigé le pluralisme des courants d’expression en :",
    options: [
      "Principe à valeur simplement réglementaire",
      "Objectif et principe à valeur constitutionnelle",
      "Principe sans portée juridique",
    ],
    answer: "Objectif et principe à valeur constitutionnelle",
    explanation:
        "Les décisions notamment de 1984 et 1986 reconnaissent au pluralisme une valeur constitutionnelle forte.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Décision de 1984",
    question:
        "Dans sa décision du 11 octobre 1984, le Conseil constitutionnel a particulièrement insisté sur :",
    options: [
      "Le rôle du Conseil d’État dans la censure",
      "La nécessité de la transparence des organes de presse pour garantir la liberté d’opinion",
      "L’interdiction totale de la publicité",
    ],
    answer:
        "La nécessité de la transparence des organes de presse pour garantir la liberté d’opinion",
    explanation:
        "La transparence permet au public de mesurer les influences qui pèsent sur l’information.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Perquisitions (magistrat)",
    question:
        "En matière de perquisitions dans les locaux de presse, il est exigé que :",
    options: [
      "Elles soient décidées et dirigées par un magistrat spécifiant l’infraction et les documents recherchés",
      "Elles soient faites uniquement sur ordre oral d’un policier",
      "Elles soient systématiquement nocturnes",
    ],
    answer:
        "Elles soient décidées et dirigées par un magistrat spécifiant l’infraction et les documents recherchés",
    explanation:
        "Cette exigence renforce les garanties entourant la liberté de la presse et le secret des sources.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Diffamation/non public",
    question:
        "La diffamation non publique (par exemple dans un courrier privé) :",
    options: [
      "Relève d’un régime de contravention distinct de la diffamation publique",
      "Est plus sévèrement punie que la diffamation publique",
      "N’est pas réprimée du tout",
    ],
    answer:
        "Relève d’un régime de contravention distinct de la diffamation publique",
    explanation:
        "La publicité est un élément aggravant ; son absence entraîne un régime contraventionnel.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Apologie / provocation",
    question: "Les articles 23 et 24 de la loi de 1881 répriment notamment :",
    options: [
      "Les seules erreurs typographiques",
      "La provocation et l’apologie de certains crimes et délits, notamment terroristes ou contre l’humanité",
      "La critique politique pacifique",
    ],
    answer:
        "La provocation et l’apologie de certains crimes et délits, notamment terroristes ou contre l’humanité",
    explanation:
        "La loi encadre fermement les discours de haine ou de glorification de crimes graves.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Injure discriminatoire",
    question: "L’injure publique à caractère raciste ou discriminatoire :",
    options: [
      "Est moins gravement sanctionnée qu’une injure simple",
      "Bénéficie d’un délai de prescription allongé et de peines aggravées",
      "N’est pas visée par la loi de 1881",
    ],
    answer:
        "Bénéficie d’un délai de prescription allongé et de peines aggravées",
    explanation:
        "Le législateur a renforcé la répression des propos discriminatoires, y compris sur la durée de prescription.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Équilibre enquête / sources",
    question:
        "Lorsqu’un enquêteur doit entendre un journaliste sur une affaire en cours, il doit :",
    options: [
      "Lui demander systématiquement l’identité de ses sources",
      "Concilier la recherche de la vérité avec le respect du secret des sources et des garanties procédurales",
      "Refuser de l’entendre",
    ],
    answer:
        "Concilier la recherche de la vérité avec le respect du secret des sources et des garanties procédurales",
    explanation:
        "La liberté de la presse impose un équilibre subtil entre besoin d’enquête et protection des sources.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Rôle pratique du policier",
    question:
        "Pour un policier sur la voie publique, filmer ou photographier des journalistes en action lors d’une manifestation :",
    options: [
      "Est toujours interdit",
      "Peut être justifié pour les besoins probatoires, mais ne doit pas servir à intimider ou entraver la liberté de la presse",
      "Est obligatoire pour tous les journalistes",
    ],
    answer:
        "Peut être justifié pour les besoins probatoires, mais ne doit pas servir à intimider ou entraver la liberté de la presse",
    explanation:
        "La captation d’images doit rester proportionnée, justifiée et respectueuse des libertés fondamentales.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Manifestations – Contraventions",
    question:
        "La participation à une manifestation interdite sur le fondement de l’article L.211-4 C.S.I. peut être sanctionnée :",
    options: [
      "Par une contravention de 4 ème classe",
      "Uniquement par un avertissement verbal",
      "Par une peine criminelle",
    ],
    answer: "Par une contravention de 4 ème classe",
    explanation:
        "L’article R.644-4 du Code Pénal. prévoit une contravention de 4 ème classe pour la participation à une manifestation interdite.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Notion d’ordre public",
    question:
        "Lorsqu’il apprécie la légalité d’une manifestation, le préfet doit notamment tenir compte :",
    options: [
      "De la couleur politique des organisateurs",
      "Des risques d’atteinte à l’ordre public (sécurité, tranquillité, salubrité)",
      "Du nombre de journalistes présents",
    ],
    answer:
        "Des risques d’atteinte à l’ordre public (sécurité, tranquillité, salubrité)",
    explanation:
        "Le pouvoir de police administrative générale vise le maintien de l’ordre public, non la censure d’opinions.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – État d’urgence / régime exceptionnel",
    question:
        "En période d’état d’urgence ou de régime exceptionnel, les pouvoirs de police :",
    options: [
      "Peuvent être significativement renforcés (couvre-feux, interdictions générales, etc.)",
      "Sont supprimés",
      "Sont exercés uniquement par les juges",
    ],
    answer:
        "Peuvent être significativement renforcés (couvre-feux, interdictions générales, etc.)",
    explanation:
        "Les régimes d’exception permettent des restrictions plus fortes aux libertés publiques, sous contrôle du juge.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Attroupements – Voie publique",
    question: "Un attroupement suppose un rassemblement :",
    options: [
      "Sur la voie publique ou dans un lieu public",
      "Uniquement dans un domicile privé",
      "Uniquement à la télévision",
    ],
    answer: "Sur la voie publique ou dans un lieu public",
    explanation:
        "La notion d’attroupement vise les espaces publics, susceptibles de troubler l’ordre public.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Attroupements – Troubles effectifs",
    question:
        "Pour qu’il y ait attroupement au sens de l’article 431-3 du Code Pénal., il est :",
    options: [
      "Indispensable qu’il y ait déjà des violences commises",
      "Suffisant qu’il y ait un risque ou une menace de troubles à l’ordre public",
      "Nécessaire que les manifestants soient armés",
    ],
    answer:
        "Suffisant qu’il y ait un risque ou une menace de troubles à l’ordre public",
    explanation:
        "La simple susceptibilité de trouble suffit : il n’est pas exigé que des violences soient déjà réalisées.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Attroupements – Sommations",
    question:
        "La formule traditionnellement utilisée lors des sommations de dispersion est introduite par :",
    options: [
      "« Attention ! Attention ! Obéissance à la loi. Dispersez-vous. »",
      "« Peuple de France, écoutez-moi. »",
      "« Silence dans les rangs. »",
    ],
    answer: "« Attention ! Attention ! Obéissance à la loi. Dispersez-vous. »",
    explanation:
        "Cette formule, ou toute formule équivalente rappelant la loi et la nécessité de se disperser, est utilisée pour matérialiser les sommations.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Attroupements – Participation après sommations",
    question:
        "Après les sommations réglementaires, les personnes qui restent volontairement dans l’attroupement :",
    options: [
      "Prennent le risque de commettre un délit",
      "Sont automatiquement considérées comme victimes",
      "Ne peuvent pas être poursuivies",
    ],
    answer: "Prennent le risque de commettre un délit",
    explanation:
        "Rester dans un attroupement après sommations constitue le délit visé par l’article 431-4 du Code Pénal.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Attroupements – Port d’arme",
    question: "Participer à un attroupement en étant porteur d’une arme :",
    options: [
      "Est plus sévèrement puni qu’en étant non armé",
      "N’a aucune incidence sur la peine",
      "Est autorisé si l’arme est déclarée",
    ],
    answer: "Est plus sévèrement puni qu’en étant non armé",
    explanation:
        "L’article 431-5 du Code Pénal. aggrave la répression lorsque le participant est porteur d’une arme.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Presse – 4ème pouvoir",
    question: "La presse est parfois qualifiée de « 4 ème pouvoir » car :",
    options: [
      "Elle fait partie officiellement des pouvoirs constitutionnels",
      "Elle joue un rôle de contrôle et de critique des pouvoirs publics",
      "Elle commande directement la police",
    ],
    answer: "Elle joue un rôle de contrôle et de critique des pouvoirs publics",
    explanation:
        "En informant, dénonçant et analysant, la presse influence durablement l’opinion et contrôle symboliquement les pouvoirs institués.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Presse – Délits de presse",
    question:
        "Les infractions commises par voie de presse (injure, diffamation, etc.) sont régies principalement par :",
    options: [
      "Le Code du travail",
      "La loi du 29 juillet 1881",
      "Le Code de la défense",
    ],
    answer: "La loi du 29 juillet 1881",
    explanation:
        "La plupart des infractions commises par voie de presse trouvent leur régime spécifique dans la loi de 1881.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Presse – Injure publique",
    question: "L’injure publique se définit comme :",
    options: [
      "Une allégation d’un fait précis",
      "Une expression outrageante, terme de mépris ou invective ne renfermant l’imputation d’aucun fait",
      "Une simple critique politique",
    ],
    answer:
        "Une expression outrageante, terme de mépris ou invective ne renfermant l’imputation d’aucun fait",
    explanation:
        "L’injure vise le propos dégradant, sans fait précis susceptible de preuve, contrairement à la diffamation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Presse – Diffamation",
    question: "La diffamation suppose :",
    options: [
      "Une appréciation purement subjective",
      "L’allégation ou l’imputation d’un fait précis portant atteinte à l’honneur ou à la considération",
      "Une simple caricature humoristique",
    ],
    answer:
        "L’allégation ou l’imputation d’un fait précis portant atteinte à l’honneur ou à la considération",
    explanation:
        "Il faut un fait déterminé, susceptible de débat probatoire, pour caractériser la diffamation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Presse – Personnes protégées",
    question:
        "Les injures ou diffamations visant un agent public dans l’exercice de ses fonctions :",
    options: [
      "Sont plus sévèrement réprimées",
      "Sont dépourvues d’importance juridique",
      "Ne peuvent jamais être poursuivies",
    ],
    answer: "Sont plus sévèrement réprimées",
    explanation:
        "La loi de 1881 prévoit des circonstances aggravantes lorsque la victime est dépositaire de l’autorité publique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Presse – Jeunesse",
    question: "Les publications destinées à la jeunesse :",
    options: [
      "Ne font l’objet d’aucun contrôle particulier",
      "Peuvent être encadrées plus strictement pour éviter les contenus violents, pornographiques ou discriminatoires",
      "Doivent toujours être validées par le ministre de l’Éducation",
    ],
    answer:
        "Peuvent être encadrées plus strictement pour éviter les contenus violents, pornographiques ou discriminatoires",
    explanation:
        "La loi protège particulièrement les mineurs face à certains contenus susceptibles de les heurter.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU MOYEN =====================
  const QuizQuestion(
    category: "Manifestations – Multi-communes",
    question:
        "Lorsque le cortège d’une manifestation doit traverser plusieurs communes :",
    options: [
      "Une seule déclaration au ministère suffit",
      "Chacune des mairies concernées doit être saisie",
      "Seule la préfecture de région est compétente",
    ],
    answer: "Chacune des mairies concernées doit être saisie",
    explanation:
        "Chaque autorité de police municipale concernée doit être informée, pour adapter les mesures de maintien de l’ordre.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Manifestations – Notification interdiction",
    question: "Une décision d’interdiction de manifestation doit :",
    options: [
      "Toujours être publiée au Journal officiel",
      "Être notifiée aux organisateurs par un OPJ ou tout agent mandaté, ou rendue publique par tous moyens si nécessaire",
      "Être annoncée uniquement sur les réseaux sociaux",
    ],
    answer:
        "Être notifiée aux organisateurs par un OPJ ou tout agent mandaté, ou rendue publique par tous moyens si nécessaire",
    explanation:
        "La notification peut être individuelle ou, si ce n’est pas possible, réalisée par voie d’affichage ou autre moyen public.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Manifestations – Référé",
    question: "Un arrêté d’interdiction de manifestation peut être contesté :",
    options: [
      "Uniquement devant la Cour de cassation",
      "Par un référé devant le tribunal administratif",
      "Uniquement par un recours hiérarchique auprès du préfet",
    ],
    answer: "Par un référé devant le tribunal administratif",
    explanation:
        "Le juge administratif, saisi en urgence, contrôle la réalité du risque et la proportionnalité de l’interdiction.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Manifestations – Interdiction d’objets",
    question:
        "L’interdiction temporaire de port d’objets pouvant constituer une arme par destination (L.211-3 C.S.I.) vise :",
    options: [
      "Un périmètre déterminé et une durée limitée",
      "Tout le territoire national sans limite de temps",
      "Uniquement les locaux privés",
    ],
    answer: "Un périmètre déterminé et une durée limitée",
    explanation:
        "La mesure doit être ciblée dans l’espace et le temps, en lien avec le risque identifié.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Manifestations – Outrage au drapeau",
    question:
        "L’outrage public au drapeau tricolore lors d’une manifestation est :",
    options: [
      "Une simple incivilité sans sanction",
      "Une infraction punie d’amende, aggravée en cas de commission en réunion",
      "Toujours un crime",
    ],
    answer:
        "Une infraction punie d’amende, aggravée en cas de commission en réunion",
    explanation:
        "L’article 433-5-1 du Code Pénal. réprime l’outrage au drapeau ou à l’hymne national, notamment en réunion.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attroupements – Autorités habilitées",
    question:
        "Parmi les autorités suivantes, laquelle peut être habilitée à procéder aux sommations de dispersion :",
    options: [
      "Le directeur de cabinet du préfet dûment mandaté",
      "Le président du tribunal judiciaire",
      "Tout agent de police municipale",
    ],
    answer: "Le directeur de cabinet du préfet dûment mandaté",
    explanation:
        "Outre le préfet, certaines autorités comme le directeur de cabinet, les maires, ou certains officiers de police peuvent être habilitées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attroupements – Signal visuel/sonore",
    question:
        "Lorsque l’usage d’un haut-parleur est impossible lors des sommations :",
    options: [
      "Les sommations sont inutiles",
      "Un signal sonore ou visuel (par exemple fusée) peut compléter ou remplacer l’annonce",
      "Il faut attendre le lendemain pour disperser",
    ],
    answer:
        "Un signal sonore ou visuel (par exemple fusée) peut compléter ou remplacer l’annonce",
    explanation:
        "Le texte prévoit la possibilité d’employer d’autres moyens pour matérialiser les sommations.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attroupements – Proportionnalité",
    question:
        "En matière de dispersion d’attroupements, la proportionnalité de la force signifie que :",
    options: [
      "La force doit être strictement adaptée au trouble à faire cesser",
      "Il faut toujours utiliser toutes les armes disponibles",
      "La force peut être utilisée même après la fin du trouble",
    ],
    answer: "La force doit être strictement adaptée au trouble à faire cesser",
    explanation:
        "La force doit cesser lorsque le trouble disparaît et ne peut excéder ce qui est nécessaire pour rétablir l’ordre.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attroupements – Procès-verbal",
    question:
        "En cas d’interpellation lors d’un attroupement, il est essentiel de mentionner dans le procès-verbal :",
    options: [
      "La couleur des vêtements de tous les manifestants",
      "Les sommations effectuées, la situation de la personne (présente après sommations, armée ou non, visage dissimulé ou non)",
      "Les opinions politiques supposées de l’intéressé",
    ],
    answer:
        "Les sommations effectuées, la situation de la personne (présente après sommations, armée ou non, visage dissimulé ou non)",
    explanation:
        "Ces éléments conditionnent la qualification pénale (431-4, 431-5, 431-6 du Code Pénal.) et la solidité du dossier.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attroupements – Responsabilité de l’État",
    question:
        "L’article L.211-10 C.S.I. concernant les attroupements prévoit une responsabilité :",
    options: [
      "Sans faute de l’État pour certains dommages causés par crimes ou délits commis à force ouverte ou par violence",
      "Uniquement en cas de faute lourde des forces de l’ordre",
      "Uniquement en cas de manifestation autorisée",
    ],
    answer:
        "Sans faute de l’État pour certains dommages causés par crimes ou délits commis à force ouverte ou par violence",
    explanation:
        "La responsabilité de plein droit de l’État permet aux victimes d’être indemnisées, l’État pouvant ensuite exercer un recours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Création d’un journal",
    question: "Pour créer un journal au regard de la loi de 1881, il faut :",
    options: [
      "Une autorisation préalable du préfet",
      "Une simple déclaration, sans autorisation ni cautionnement",
      "L’accord du Conseil constitutionnel",
    ],
    answer: "Une simple déclaration, sans autorisation ni cautionnement",
    explanation:
        "La loi de 1881 consacre un régime très libéral pour la création d’un journal.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Directeur de publication",
    question: "Le directeur de la publication d’un journal :",
    options: [
      "N’a aucune responsabilité pénale",
      "Est la personne pénalement responsable en premier lieu des infractions de presse",
      "Est uniquement responsable de la mise en page",
    ],
    answer:
        "Est la personne pénalement responsable en premier lieu des infractions de presse",
    explanation:
        "Le système de responsabilité en cascade place le directeur de publication au premier rang.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Secret des sources et témoignage",
    question:
        "Lorsqu’un journaliste est entendu comme témoin sur des faits révélés par ses articles :",
    options: [
      "Il est tenu de divulguer systématiquement ses sources",
      "Il peut refuser de révéler l’identité de ses sources, sauf cas strictement encadrés",
      "Il doit prêter serment de révéler toute information",
    ],
    answer:
        "Il peut refuser de révéler l’identité de ses sources, sauf cas strictement encadrés",
    explanation:
        "La protection des sources est un élément central de la liberté de la presse, rappelée par la CEDH et la Cour de cassation.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Pluralisme et concentration",
    question:
        "Les règles limitant les concentrations d’entreprises de presse visent avant tout à :",
    options: [
      "Protéger la rentabilité des entreprises",
      "Garantir le pluralisme des courants d’expression",
      "Limiter les exportations de journaux à l’étranger",
    ],
    answer: "Garantir le pluralisme des courants d’expression",
    explanation:
        "Le pluralisme est un objectif de valeur constitutionnelle ; les règles de concentration visent à éviter des situations de monopole d’information.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Aides publiques",
    question:
        "Les aides publiques à la presse (fiscales, postales, directes) soulèvent notamment la question :",
    options: [
      "De l’indépendance réelle de la presse vis-à-vis du pouvoir politique",
      "De la suppression de toute liberté éditoriale",
      "De la nationalisation obligatoire des journaux",
    ],
    answer:
        "De l’indépendance réelle de la presse vis-à-vis du pouvoir politique",
    explanation:
        "Si les aides visent le pluralisme, elles interrogent aussi sur la dépendance financière à l’égard de l’État.",
    difficulty: "Moyenne",
  ),

  // ===================== NIVEAU DIFFICILE (inclut Difficile) =====================
  const QuizQuestion(
    category: "Manifestations – Réquisitions 78-2-5 CPP",
    question:
        "Les réquisitions fondées sur l’article 78-2-5 CPP lors d’une manifestation doivent notamment :",
    options: [
      "Être générales et permanentes sur tout le territoire",
      "Préciser le périmètre, la durée et la nature des contrôles (bagages, véhicules, etc.)",
      "Être orales et non écrites",
    ],
    answer:
        "Préciser le périmètre, la durée et la nature des contrôles (bagages, véhicules, etc.)",
    explanation:
        "Le procureur doit détailler le cadre spatial, temporel et matériel des contrôles pour respecter la proportionnalité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Manifestations – Contrôle d’identité préventif",
    question:
        "Les contrôles d’identité aux abords d’une manifestation sur le fondement de l’art. 78-2 al. 8 CPP sont possibles :",
    options: [
      "Sans limite de temps ni de lieu",
      "Dans des lieux et pour une durée déterminés, en cas de risque d’atteinte à l’ordre public",
      "Uniquement si un délit a déjà été commis",
    ],
    answer:
        "Dans des lieux et pour une durée déterminés, en cas de risque d’atteinte à l’ordre public",
    explanation:
        "Il s’agit de contrôles préventifs encadrés, justifiés par des risques d’atteintes aux personnes et aux biens.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Manifestations – État de siège / état d’urgence",
    question:
        "En état de siège ou d’urgence, certaines mesures comme la censure de la presse et l’interdiction généralisée de manifestations :",
    options: [
      "Sont automatiquement applicables sans texte",
      "Nécessitent un fondement légal spécifique et restent soumises au contrôle du juge",
      "Sont décidées exclusivement par les maires",
    ],
    answer:
        "Nécessitent un fondement légal spécifique et restent soumises au contrôle du juge",
    explanation:
        "Même en régime d’exception, les limitations aux libertés doivent se fonder sur la loi et restent contrôlées par les juridictions.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Attroupements – Délit politique",
    question:
        "La qualification de « délit politique » du délit d’attroupement (431-4 du Code Pénal.) par la Cour de cassation implique notamment :",
    options: [
      "Qu’il est jugé par des juridictions spéciales",
      "Qu’il bénéficie de certains régimes particuliers (extradition, etc.), sans faire obstacle aux procédures pénales rapides",
      "Qu’il ne peut jamais faire l’objet d’une comparution immédiate",
    ],
    answer:
        "Qu’il bénéficie de certains régimes particuliers (extradition, etc.), sans faire obstacle aux procédures pénales rapides",
    explanation:
        "La loi a précisément prévu la compatibilité de ce caractère politique avec les procédures prévues aux art. 393 à 397-7 et 495-7 à 495-15-1 CPP.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Attroupements – Usage des armes réglementé",
    question:
        "Les armes susceptibles d’être utilisées dans le cadre de la dispersion d’attroupements sont listées :",
    options: [
      "Dans l’article D.211-17 du Code de la sécurité intérieure",
      "Uniquement dans le Code pénal",
      "Dans la loi de 1881",
    ],
    answer: "Dans l’article D.211-17 du Code de la sécurité intérieure",
    explanation:
        "Cet article énumère les armes (grenades à effet sonore, lacrymogènes, LBD, etc.) utilisables dans ce cadre.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Attroupements – Usage immédiat de la force",
    question:
        "L’article L.211-9 C.S.I. permet de faire usage immédiatement de la force, sans attendre l’issue des sommations, lorsque :",
    options: [
      "Les forces de l’ordre subissent des violences ou que des lieux stratégiques sont menacés",
      "Les manifestants chantent trop fort",
      "Il pleut fortement",
    ],
    answer:
        "Les forces de l’ordre subissent des violences ou que des lieux stratégiques sont menacés",
    explanation:
        "Il s’agit de situations d’urgence où la sécurité des forces ou de certains lieux ne permet plus de suivre intégralement la procédure ordinaire.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Attroupements – Provocation et responsabilité",
    question:
        "En cas de provocation à un attroupement armé (art. 431-6 du Code Pénal.), la responsabilité pénale :",
    options: [
      "Ne peut être retenue qu’en présence d’une arme à feu",
      "Peut être engagée même si la provocation n’a pas été suivie d’effet, mais avec une peine moindre",
      "Suppose toujours une atteinte à la vie",
    ],
    answer:
        "Peut être engagée même si la provocation n’a pas été suivie d’effet, mais avec une peine moindre",
    explanation:
        "La peine est aggravée lorsque l’attroupement armé a effectivement eu lieu, mais l’infraction existe déjà au stade de la simple provocation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Secret des sources (principe)",
    question:
        "Selon la jurisprudence de la CEDH, la protection des sources des journalistes est :",
    options: [
      "Un simple privilège que le législateur peut supprimer facilement",
      "Une pierre angulaire de la liberté de la presse",
      "Une mesure réservée aux journalistes de service public",
    ],
    answer: "Une pierre angulaire de la liberté de la presse",
    explanation:
        "La Cour européenne rappelle régulièrement que la protection des sources est essentielle à la liberté journalistique.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Perquisitions nulles",
    question:
        "Une perquisition irrégulière dans les locaux d’un organe de presse :",
    options: [
      "N’a aucune conséquence",
      "Peut entraîner la nullité des actes et des saisies qui en découlent",
      "Est automatiquement validée après coup par le procureur",
    ],
    answer:
        "Peut entraîner la nullité des actes et des saisies qui en découlent",
    explanation:
        "Le non-respect des garanties légales en matière de perquisitions peut conduire à l’annulation des actes.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Publication d’informations secrètes",
    question:
        "La publication d’informations relatives à la défense nationale ou au secret de l’instruction :",
    options: [
      "Est toujours libre au nom du droit à l’information",
      "Peut constituer une infraction spécifique réprimée par la loi de 1881 et le Code pénal",
      "N’est sanctionnée que moralement",
    ],
    answer:
        "Peut constituer une infraction spécifique réprimée par la loi de 1881 et le Code pénal",
    explanation:
        "Plusieurs textes encadrent la diffusion d’informations sensibles, notamment pour protéger la défense nationale et le bon déroulement de la justice.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Droit de réponse",
    question: "La personne mise en cause par un article de presse dispose :",
    options: [
      "D’un droit de réponse permettant de faire publier sa version des faits",
      "Uniquement du droit de porter plainte pénale",
      "D’aucun moyen spécifique de réaction",
    ],
    answer:
        "D’un droit de réponse permettant de faire publier sa version des faits",
    explanation:
        "La loi de 1881 organise le droit de réponse, en plus des actions civiles ou pénales éventuelles.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Délais de prescription raciste",
    question:
        "Pourquoi le législateur a-t-il allongé à un an la prescription pour certains délits de presse à caractère raciste ou discriminatoire ?",
    options: [
      "Parce qu’ils sont considérés comme particulièrement graves et parfois difficiles à poursuivre rapidement",
      "Pour simplifier la tâche des auteurs",
      "Pour éviter la plainte des victimes",
    ],
    answer:
        "Parce qu’ils sont considérés comme particulièrement graves et parfois difficiles à poursuivre rapidement",
    explanation:
        "Le délai plus long permet un traitement plus effectif de ces infractions, en tenant compte de leur gravité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Intervention policière en rédaction",
    question:
        "Lorsqu’un policier intervient dans les locaux d’un média sur réquisition judiciaire, il doit veiller :",
    options: [
      "À exiger toutes les notes des journalistes sans distinction",
      "À limiter son intervention aux éléments visés par la réquisition, en respectant la liberté de la presse et le secret des sources",
      "À interroger tous les journalistes sur leurs sources",
    ],
    answer:
        "À limiter son intervention aux éléments visés par la réquisition, en respectant la liberté de la presse et le secret des sources",
    explanation:
        "Toute intervention dans un média est sensible : l’agent doit strictement respecter le cadre légal fixé par la réquisition et les garanties protectrices.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Manifestations – Définition",
    question:
        "Une manifestation sur la voie publique se caractérise principalement par :",
    options: [
      "Une occupation momentanée de la voie publique par un rassemblement statique ou mobile",
      "Toute réunion dans un local privé",
      "Tout échange sur les réseaux sociaux",
    ],
    answer:
        "Une occupation momentanée de la voie publique par un rassemblement statique ou mobile",
    explanation:
        "On entend généralement par manifestation l’occupation momentanée de la voie publique par un rassemblement statique ou mobile (cortège), à caractère revendicatif, festif ou protestataire.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Liberté fondamentale",
    question:
        "La liberté de manifester est principalement rattachée en droit français :",
    options: [
      "À la liberté d’entreprendre",
      "À la liberté d’expression et aux libertés publiques à valeur constitutionnelle",
      "Au droit de propriété",
    ],
    answer:
        "À la liberté d’expression et aux libertés publiques à valeur constitutionnelle",
    explanation:
        "La manifestation est un mode collectif d’exercice de la liberté d’expression, reconnue comme principe à valeur constitutionnelle.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Déclaration",
    question:
        "Selon l’article L.211-1 du C.S.I., les cortèges et rassemblements sur la voie publique :",
    options: [
      "Doivent faire l’objet d’une déclaration préalable",
      "Nécessitent toujours une autorisation écrite du préfet",
      "Ne sont soumis à aucune formalité",
    ],
    answer: "Doivent faire l’objet d’une déclaration préalable",
    explanation:
        "L’article L.211-1 du Code de la sécurité intérieure soumet les cortèges, défilés et rassemblements sur la voie publique à une obligation de déclaration préalable.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Exceptions",
    question:
        "Parmi les manifestations suivantes, laquelle est en principe dispensée de déclaration préalable ?",
    options: [
      "Les cortèges revendicatifs sur la voie publique",
      "Les manifestations traditionnelles à caractère folklorique ou religieux",
      "Les rassemblements politiques devant une préfecture",
    ],
    answer:
        "Les manifestations traditionnelles à caractère folklorique ou religieux",
    explanation:
        "L’article L.211-1 C.S.I. prévoit une exception pour certaines manifestations traditionnelles à caractère folklorique ou religieux.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Autorité compétente",
    question:
        "À Paris, l’autorité compétente pour recevoir la déclaration préalable de manifestation est :",
    options: [
      "Le maire de l’arrondissement",
      "La préfecture de police",
      "Le ministère de l’Intérieur",
    ],
    answer: "La préfecture de police",
    explanation:
        "À Paris, la déclaration préalable est déposée auprès de la préfecture de police.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Délai",
    question:
        "Le délai légal pour déposer une déclaration de manifestation est en principe :",
    options: [
      "Au moins 3 jours francs avant et au plus 15 jours francs avant la date",
      "La veille avant 18h",
      "Au moins un mois avant",
    ],
    answer:
        "Au moins 3 jours francs avant et au plus 15 jours francs avant la date",
    explanation:
        "La déclaration doit parvenir entre 3 et 15 jours francs avant la manifestation, afin de permettre à l’autorité de préparer le dispositif.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Déclaration",
    question:
        "La déclaration de manifestation doit obligatoirement comporter :",
    options: [
      "Les noms, prénoms et domiciles des organisateurs",
      "Le budget prévisionnel détaillé de la manifestation",
      "La liste nominative de tous les participants",
    ],
    answer: "Les noms, prénoms et domiciles des organisateurs",
    explanation:
        "Le contenu de la déclaration comprend notamment l’identité des organisateurs, l’objet, le lieu, la date, l’horaire et l’itinéraire envisagé.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Interdiction",
    question:
        "L’article L.211-4 du C.S.I. permet d’interdire une manifestation lorsque :",
    options: [
      "Elle n’est pas populaire",
      "Elle est de nature à troubler gravement l’ordre public et qu’aucune mesure moins restrictive ne suffit",
      "Elle se déroule un jour férié",
    ],
    answer:
        "Elle est de nature à troubler gravement l’ordre public et qu’aucune mesure moins restrictive ne suffit",
    explanation:
        "L’interdiction est une mesure grave, justifiée seulement en cas de risques sérieux de troubles graves à l’ordre public et en l’absence d’autres moyens suffisants.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Sanctions pénales",
    question:
        "Organiser une manifestation non déclarée ou malgré interdiction est puni par l’article 431-9 du Code Pénal. de :",
    options: [
      "Une simple amende forfaitaire de 135 €",
      "6 mois d’emprisonnement et 7 500 € d’amende",
      "10 ans d’emprisonnement",
    ],
    answer: "6 mois d’emprisonnement et 7 500 € d’amende",
    explanation:
        "L’article 431-9 du Code pénal sanctionne l’organisation d’une manifestation non déclarée, interdite ou déclarée de manière mensongère.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Participants",
    question:
        "La simple participation à une manifestation interdite sur le fondement de l’article L.211-4 C.S.I. est :",
    options: [
      "Un crime",
      "Une contravention de 4 ème classe",
      "Toujours un délit",
    ],
    answer: "Une contravention de 4 ème classe",
    explanation:
        "L’article R.644-4 du Code pénal punit la participation à une manifestation interdite d’une contravention de 4 ème classe.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Port d’arme",
    question:
        "Participer à une manifestation ou réunion publique en étant porteur d’une arme constitue :",
    options: [
      "Une simple contravention",
      "Un délit puni de 3 ans d’emprisonnement et 45 000 € d’amende",
      "Un crime puni de 20 ans de réclusion",
    ],
    answer: "Un délit puni de 3 ans d’emprisonnement et 45 000 € d’amende",
    explanation:
        "L’article 431-10 du Code pénal réprime le fait de participer armé à une manifestation ou réunion publique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Manifestations – Dissimulation du visage",
    question:
        "Sans motif légitime, dissimuler volontairement son visage lors d’une manifestation, dans un contexte de risque d’atteintes à l’ordre public, est puni :",
    options: [
      "D’un simple rappel à la loi",
      "D’un an d’emprisonnement et 15 000 € d’amende",
      "De 10 ans d’emprisonnement",
    ],
    answer: "D’un an d’emprisonnement et 15 000 € d’amende",
    explanation:
        "L’article 431-9-1 du Code pénal réprime la dissimulation volontaire du visage dans certaines manifestations, en vue d’échapper à l’identification.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Attroupements – Définition",
    question:
        "Selon l’article 431-3 du Code pénal, constitue un attroupement :",
    options: [
      "Tout rassemblement de personnes dans un domicile privé",
      "Tout rassemblement de personnes sur la voie publique ou dans un lieu public susceptible de troubler l’ordre public",
      "Toute file d’attente devant un commerce",
    ],
    answer:
        "Tout rassemblement de personnes sur la voie publique ou dans un lieu public susceptible de troubler l’ordre public",
    explanation:
        "L’attroupement vise un rassemblement sur la voie publique ou dans un lieu public susceptible de troubler l’ordre public, même sans violences effectives.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Attroupements – Sommations",
    question:
        "En principe, avant de disperser un attroupement par la force, l’autorité compétente doit :",
    options: [
      "Faire deux sommations préalables",
      "Toujours procéder à des arrestations massives",
      "Demander l’autorisation du procureur de la République",
    ],
    answer: "Faire deux sommations préalables",
    explanation:
        "L’article R.211-11 C.S.I. prévoit deux sommations avant l’usage de la force pour disperser un attroupement.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Attroupements – Participation",
    question:
        "Continuer à participer volontairement à un attroupement après les sommations, sans être porteur d’une arme, est puni :",
    options: [
      "D’un an d’emprisonnement et 15 000 € d’amende",
      "De 6 mois d’emprisonnement",
      "Uniquement d’une amende contraventionnelle",
    ],
    answer: "D’un an d’emprisonnement et 15 000 € d’amende",
    explanation:
        "L’article 431-4 du Code pénal réprime la participation à un attroupement après sommations, même sans arme.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Attroupements – Nature politique",
    question:
        "Le délit d’attroupement prévu à l’article 431-4 du Code pénal a été qualifié par la Cour de cassation comme :",
    options: [
      "Un délit politique",
      "Un simple délit de droit commun",
      "Un crime de guerre",
    ],
    answer: "Un délit politique",
    explanation:
        "Par un arrêt du 28 mars 2017, la chambre criminelle a qualifié le délit d’attroupement comme un délit politique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Presse – Textes fondateurs",
    question:
        "La grande « charte » de la liberté de la presse en France est la loi du :",
    options: ["10 août 1792", "29 juillet 1881", "1ère août 1986"],
    answer: "29 juillet 1881",
    explanation:
        "La loi du 29 juillet 1881 constitue la grande loi de référence sur la liberté de la presse en France.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Presse – Référence constitutionnelle",
    question:
        "La liberté d’expression et la libre communication des pensées et des opinions sont proclamées par :",
    options: [
      "L’article 11 de la Déclaration de 1789",
      "L’article 2 de la Constitution de 1958",
      "L’article 66 de la Constitution",
    ],
    answer: "L’article 11 de la Déclaration de 1789",
    explanation:
        "L’article 11 de la Déclaration des droits de l’Homme et du citoyen proclame la libre communication des pensées et des opinions.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Presse – Principe",
    question:
        "Selon la loi du 29 juillet 1881, la presse est en principe soumise :",
    options: [
      "À un régime d’autorisation préalable",
      "À un régime de censure administrative",
      "À un régime libéral, la répression n’intervenant qu’a posteriori en cas d’abus",
    ],
    answer:
        "À un régime libéral, la répression n’intervenant qu’a posteriori en cas d’abus",
    explanation:
        "La loi de 1881 rompt avec les régimes d’autorisation et de censure, pour consacrer un régime de liberté sous responsabilité.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Presse – Entreprise de presse",
    question:
        "L’article 5 de la loi du 29 juillet 1881 prévoit que tout journal ou écrit périodique peut être publié :",
    options: [
      "Uniquement avec autorisation préalable du préfet",
      "Sans autorisation préalable ni dépôt de cautionnement",
      "Seulement après contrôle du ministère de l’Intérieur",
    ],
    answer: "Sans autorisation préalable ni dépôt de cautionnement",
    explanation:
        "L’article 5 consacre un régime de simple déclaration, sans autorisation ni cautionnement.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Presse – Journaliste",
    question:
        "Le journaliste professionnel est, en principe, une personne qui :",
    options: [
      "Exerce à titre bénévole dans un journal",
      "Exerce à titre principal et rétribué une activité de rédaction ou de diffusion d’informations",
      "Est fonctionnaire du ministère de la Culture",
    ],
    answer:
        "Exerce à titre principal et rétribué une activité de rédaction ou de diffusion d’informations",
    explanation:
        "Le statut de journaliste professionnel suppose une activité principale, rémunérée, au sein d’un ou plusieurs organes de presse.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU MOYEN =====================
  const QuizQuestion(
    category: "Manifestations – Lieu de déclaration",
    question:
        "Dans une commune où la police n’est pas étatisée, la déclaration de manifestation sur la voie publique est normalement déposée :",
    options: [
      "Auprès du maire de la commune",
      "Exclusivement à la préfecture de région",
      "Directement auprès du ministère de l’Intérieur",
    ],
    answer: "Auprès du maire de la commune",
    explanation:
        "En dehors de Paris et des communes à police étatisée, la déclaration se fait en mairie ; si la manifestation traverse plusieurs communes, chaque maire doit être saisi.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Manifestations – Contrôle du préfet",
    question:
        "Lorsqu’un maire interdit une manifestation dans une zone de police non étatisée, son arrêté :",
    options: [
      "Est insusceptible de tout contrôle",
      "Doit être transmis au préfet dans les 24 heures",
      "N’est valable que s’il est publié au Journal officiel",
    ],
    answer: "Doit être transmis au préfet dans les 24 heures",
    explanation:
        "L’arrêté d’interdiction du maire doit être transmis au préfet, qui peut saisir le tribunal administratif en cas de désaccord.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Manifestations – Contrôle du juge",
    question:
        "Le juge administratif contrôle la légalité d’un arrêté d’interdiction de manifestation en particulier au regard :",
    options: [
      "Du simple ressenti politique du préfet",
      "Des principes de nécessité et de proportionnalité des mesures de police",
      "Du nombre de participants annoncés uniquement",
    ],
    answer:
        "Des principes de nécessité et de proportionnalité des mesures de police",
    explanation:
        "Comme pour tout acte de police, le juge vérifie la nécessité, l’adaptation et la proportionnalité de l’interdiction aux risques allégués.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Manifestations – Contrôles d’identité",
    question:
        "Les contrôles d’identité aux abords d’une manifestation, pour prévenir les atteintes aux personnes et aux biens, peuvent reposer sur :",
    options: [
      "L’article 78-2 alinéa 8 du Code de procédure pénale",
      "L’article 66 de la Constitution",
      "Le Code du travail",
    ],
    answer: "L’article 78-2 alinéa 8 du Code de procédure pénale",
    explanation:
        "L’article 78-2 CPP permet notamment des contrôles préventifs aux abords des manifestations en cas de risque avéré.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Manifestations – Fouilles",
    question:
        "Les réquisitions permettant de contrôler bagages et véhicules aux abords d’une manifestation reposent sur :",
    options: [
      "L’article 78-2-5 du Code de procédure pénale",
      "L’article L.211-10 du C.S.I.",
      "L’article 431-9-1 du Code pénal",
    ],
    answer: "L’article 78-2-5 du Code de procédure pénale",
    explanation:
        "L’article 78-2-5 CPP autorise le procureur à délivrer des réquisitions pour fouilles de bagages et visites de véhicules dans un périmètre et une durée limités.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Manifestations – Objets dangereux",
    question:
        "En cas de risques sérieux de troubles graves à l’ordre public, l’article L.211-3 C.S.I. permet :",
    options: [
      "D’interdire le port et le transport, sans motif légitime, d’objets pouvant constituer une arme",
      "D’interdire toute circulation routière sur le territoire national",
      "D’interdire tous les déplacements à plus de 5 km du domicile",
    ],
    answer:
        "D’interdire le port et le transport, sans motif légitime, d’objets pouvant constituer une arme",
    explanation:
        "L’article L.211-3 C.S.I. est une mesure préventive liée au risque de violence lors de certaines manifestations.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Manifestations – Responsabilité de l’État",
    question:
        "Selon l’article L.211-10 du C.S.I., l’État est civilement responsable :",
    options: [
      "Des simples contraventions commises isolément",
      "Des dégâts résultant des crimes et délits commis à force ouverte ou par violence lors de manifestations ou rassemblements",
      "Uniquement des erreurs des organisateurs",
    ],
    answer:
        "Des dégâts résultant des crimes et délits commis à force ouverte ou par violence lors de manifestations ou rassemblements",
    explanation:
        "L’article L.211-10 pose une responsabilité de plein droit de l’État pour certains dommages causés en lien avec des manifestations ou attroupements.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attroupements – Autorité compétente",
    question:
        "En matière d’attroupements, le maintien de l’ordre relève, selon le C.S.I., principalement :",
    options: [
      "Du ministre de l’Intérieur",
      "Du garde des Sceaux",
      "Du ministre de la Justice militaire",
    ],
    answer: "Du ministre de l’Intérieur",
    explanation:
        "L’article D.211-10 C.S.I. précise que le maintien de l’ordre dans ces cas relève exclusivement du ministre de l’Intérieur.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attroupements – Forces armées",
    question:
        "Les forces armées autres que la gendarmerie nationale peuvent participer au maintien de l’ordre :",
    options: [
      "Sans condition particulière",
      "Uniquement lorsqu’elles sont légalement requises par l’autorité civile compétente",
      "Jamais, même sur réquisition",
    ],
    answer:
        "Uniquement lorsqu’elles sont légalement requises par l’autorité civile compétente",
    explanation:
        "La participation de forces militaires au maintien de l’ordre suppose une réquisition régulière de l’autorité civile compétente.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attroupements – Insignes",
    question:
        "Lorsqu’une autorité exécute les sommations de dispersion d’un attroupement, elle doit :",
    options: [
      "Porter un insigne distinctif (écharpe ou brassard tricolore)",
      "Être en civil sans aucun signe distinctif",
      "Être accompagnée d’un huissier de justice",
    ],
    answer: "Porter un insigne distinctif (écharpe ou brassard tricolore)",
    explanation:
        "L’article R.211-12 C.S.I. impose le port d’insignes distinctifs aux autorités procédant aux sommations.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attroupements – Usage de la force",
    question:
        "Selon l’article R.211-13 C.S.I., le recours à la force pour disperser un attroupement :",
    options: [
      "Doit être absolument nécessaire au maintien de l’ordre public",
      "Peut être utilisé à titre préventif sans sommations",
      "Nécessite toujours l’accord du maire",
    ],
    answer: "Doit être absolument nécessaire au maintien de l’ordre public",
    explanation:
        "La force ne peut être employée que si elle est absolument nécessaire et proportionnée au trouble à faire cesser.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attroupements – Dispense de sommations",
    question: "Dans certains cas, l’article L.211-9 C.S.I. permet :",
    options: [
      "De renoncer aux sommations et de recourir immédiatement à la force dans certaines situations de violences ou menaces graves",
      "D’interdire tout attroupement sur le territoire national",
      "De placer automatiquement les participants en garde à vue",
    ],
    answer:
        "De renoncer aux sommations et de recourir immédiatement à la force dans certaines situations de violences ou menaces graves",
    explanation:
        "En cas de violences ou de menaces graves contre les forces de l’ordre ou certains lieux, la loi autorise un recours immédiat à la force.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attroupements – Dissimulation et arme",
    question:
        "Participer à un attroupement après sommations, en étant porteur d’une arme et le visage dissimulé pour ne pas être identifié, est puni au maximum :",
    options: [
      "D’un an d’emprisonnement",
      "De 5 ans d’emprisonnement et 75 000 € d’amende",
      "De 10 ans de réclusion criminelle",
    ],
    answer: "De 5 ans d’emprisonnement et 75 000 € d’amende",
    explanation:
        "L’article 431-5 du Code pénal aggrave les peines lorsque le participant porte une arme et dissimule son visage.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Pluralisme",
    question:
        "Le pluralisme des courants d’expression, en matière de presse, a été reconnu par le Conseil constitutionnel comme :",
    options: [
      "Un simple objectif de politique publique sans valeur juridique",
      "Un principe à valeur constitutionnelle",
      "Une notion uniquement morale sans portée juridique",
    ],
    answer: "Un principe à valeur constitutionnelle",
    explanation:
        "Le Conseil constitutionnel, dans sa décision du 11 octobre 1984 notamment, fait du pluralisme un principe à valeur constitutionnelle.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Transparence",
    question:
        "Les règles de transparence sur la propriété et la direction des entreprises de presse ont été renforcées notamment par :",
    options: [
      "L’ordonnance du 26 août 1944 et la loi du 23 octobre 1984",
      "Le Code du travail",
      "Le Code de procédure pénale",
    ],
    answer: "L’ordonnance du 26 août 1944 et la loi du 23 octobre 1984",
    explanation:
        "Ces textes visent à favoriser la transparence des organes de presse pour informer le public sur leurs responsables et leurs propriétaires.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Carte professionnelle",
    question:
        "La carte d’identité professionnelle des journalistes est délivrée :",
    options: [
      "Par une Commission paritaire composée de journalistes et d’éditeurs",
      "Par le préfet de département",
      "Par le Conseil constitutionnel",
    ],
    answer:
        "Par une Commission paritaire composée de journalistes et d’éditeurs",
    explanation:
        "Cette Commission paritaire décide de l’octroi ou du retrait de la carte de presse, décision susceptible de recours devant le juge administratif.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Clause de conscience",
    question: "La « clause de conscience » d’un journaliste lui permet :",
    options: [
      "De refuser tout contrôle fiscal",
      "De rompre son contrat avec indemnités majorées en cas de changement profond de la ligne éditoriale",
      "De bénéficier automatiquement d’un logement de fonction",
    ],
    answer:
        "De rompre son contrat avec indemnités majorées en cas de changement profond de la ligne éditoriale",
    explanation:
        "La clause de conscience protège le journaliste lorsqu’un changement de l’orientation du journal porte atteinte à son honneur ou à ses intérêts moraux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Secret des sources",
    question: "Le secret des sources des journalistes peut être levé :",
    options: [
      "Uniquement en cas de crime de terrorisme commis par un journaliste",
      "Lorsque un impératif prépondérant d’intérêt public l’exige et que les mesures sont nécessaires et proportionnées",
      "À la simple demande d’un officier de police judiciaire",
    ],
    answer:
        "Lorsque un impératif prépondérant d’intérêt public l’exige et que les mesures sont nécessaires et proportionnées",
    explanation:
        "La loi protège le secret des sources ; les atteintes doivent rester exceptionnelles, justifiées et proportionnées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Injure / diffamation",
    question:
        "La diffamation se distingue de l’injure publique notamment parce qu’elle comporte :",
    options: [
      "Une menace de violence physique",
      "L’allégation ou l’imputation d’un fait précis portant atteinte à l’honneur",
      "Toujours des propos à caractère religieux",
    ],
    answer:
        "L’allégation ou l’imputation d’un fait précis portant atteinte à l’honneur",
    explanation:
        "La diffamation implique un fait précis susceptible de preuve, alors que l’injure consiste en des propos outrageants sans fait précis.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Presse – Prescription",
    question:
        "En matière de délits de presse, le délai de prescription de l’action publique est en principe :",
    options: [
      "De 3 mois à compter de la publication",
      "De 5 ans à compter de la publication",
      "De 10 ans à compter de la publication",
    ],
    answer: "De 3 mois à compter de la publication",
    explanation:
        "La loi de 1881 prévoit un bref délai de prescription de 3 mois, porté à un an pour certains délits à caractère raciste ou discriminatoire.",
    difficulty: "Moyenne",
  ),

  // ===================== NIVEAU DIFFICILE (inclut Difficile) =====================
  const QuizQuestion(
    category: "Manifestations – Déclaration mensongère",
    question:
        "Selon l’article 431-9 du Code pénal, est puni comme organisateur de manifestation illicite celui qui :",
    options: [
      "Omet de mentionner l’heure précise de fin",
      "Présente une déclaration incomplète ou inexacte destinée à tromper sur l’objet ou les conditions de la manifestation",
      "Ne joint pas de plan de situation détaillé",
    ],
    answer:
        "Présente une déclaration incomplète ou inexacte destinée à tromper sur l’objet ou les conditions de la manifestation",
    explanation:
        "L’article 431-9 vise aussi la déclaration frauduleuse destinée à tromper l’autorité, assimilée à l’organisation d’une manifestation non conforme.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Manifestations – Dissimulation du visage (contravention)",
    question:
        "À côté du délit de dissimulation du visage (art. 431-9-1 du Code Pénal.), une contravention de 5ᵉ classe (art. R.645-14 du Code Pénal.) peut viser :",
    options: [
      "Les mêmes faits, mais en l’absence de trouble grave à l’ordre public",
      "Uniquement la dissimulation par un mineur",
      "Uniquement la dissimulation lors d’événements sportifs",
    ],
    answer:
        "Les mêmes faits, mais en l’absence de trouble grave à l’ordre public",
    explanation:
        "Lorsque le contexte est moins grave, l’infraction est requalifiée en contravention de 5ᵉ classe, toujours pour dissimulation illicite.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Manifestations – Substances explosives",
    question: "L’article 322-11-1 du Code pénal réprime notamment :",
    options: [
      "La simple possession d’un briquet",
      "La détention ou le transport de substances ou produits incendiaires ou explosifs destinés à préparer des atteintes graves lors d’une manifestation",
      "Le simple fait de filmer des violences",
    ],
    answer:
        "La détention ou le transport de substances ou produits incendiaires ou explosifs destinés à préparer des atteintes graves lors d’une manifestation",
    explanation:
        "Cette disposition vise les comportements préparatoires à des violences graves contre les personnes ou les biens.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Attroupements – Procédures rapides",
    question:
        "L’article 431-8-1 du Code pénal permet, pour les délits commis à l’occasion d’attroupements :",
    options: [
      "D’écarter toute garantie procédurale",
      "De recourir à des procédures rapides comme la comparution immédiate ou la CRPC",
      "De juger les mis en cause sans avocat",
    ],
    answer:
        "De recourir à des procédures rapides comme la comparution immédiate ou la CRPC",
    explanation:
        "L’attroupement étant qualifié de délit politique, le texte précise la compatibilité avec les procédures pénales rapides.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Attroupements – Provocation armée",
    question:
        "L’article 431-6 du Code pénal réprime la provocation directe à un attroupement armé. Lorsque cette provocation a été suivie d’effet, la peine maximale est :",
    options: [
      "3 ans d’emprisonnement",
      "5 ans d’emprisonnement",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende",
    explanation:
        "La peine est aggravée lorsque l’attroupement armé s’est effectivement produit à la suite de la provocation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Attroupements – Loi du 29 juillet 1881",
    question:
        "L’article 24 de la loi du 29 juillet 1881 est mobilisable lorsque :",
    options: [
      "Il y a provocation à certains crimes ou délits commis à l’occasion d’attroupements",
      "Une manifestation n’a pas été déclarée",
      "Le préfet refuse de signer un arrêté",
    ],
    answer:
        "Il y a provocation à certains crimes ou délits commis à l’occasion d’attroupements",
    explanation:
        "L’article 24 réprime la provocation à certains crimes ou délits, ce qui peut concerner des faits commis lors d’attroupements.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Droit au respect de la vie privée",
    question:
        "La publication en presse écrite de détails intimes non justifiés par l’intérêt général constitue :",
    options: [
      "Une diffamation",
      "Une atteinte à la vie privée",
      "Un simple manquement déontologique non sanctionné",
    ],
    answer: "Une atteinte à la vie privée",
    explanation:
        "La divulgation non autorisée d’éléments de la vie personnelle (adresse, santé, vie sentimentale…) engage la responsabilité de l’éditeur.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Fausses nouvelles",
    question:
        "La publication de fausses nouvelles, au sens de la loi de 1881, suppose notamment :",
    options: [
      "Que la nouvelle soit fausse, et de nature à troubler la paix publique",
      "Que la nouvelle soit simplement impopulaire",
      "Qu’un préfet ait démenti l’information",
    ],
    answer:
        "Que la nouvelle soit fausse, et de nature à troubler la paix publique",
    explanation:
        "L’infraction vise la diffusion de nouvelles inexactes ou falsifiées susceptibles de troubler l’ordre public.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Secret des sources et perquisitions",
    question:
        "Une perquisition dans les locaux d’un journal pour obtenir les sources d’un journaliste :",
    options: [
      "Doit être dirigée par un magistrat et respecter des exigences strictes de nécessité et proportionnalité",
      "Peut être décidée librement par un officier de police judiciaire",
      "Peut être réalisée sans procès-verbal",
    ],
    answer:
        "Doit être dirigée par un magistrat et respecter des exigences strictes de nécessité et proportionnalité",
    explanation:
        "Le secret des sources est fortement protégé ; les perquisitions doivent être encadrées par un magistrat et justifiées.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Personne responsable",
    question:
        "En matière de délits de presse, la personne responsable principale est en principe :",
    options: [
      "Le directeur de la publication pour les écrits périodiques",
      "Le journaliste auteur de l’article",
      "L’imprimeur",
    ],
    answer: "Le directeur de la publication pour les écrits périodiques",
    explanation:
        "Le système de la loi de 1881 établit une hiérarchie des responsabilités, plaçant en tête le directeur de la publication.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Délits racistes",
    question:
        "Pour certains délits de presse à caractère raciste ou discriminatoire, le délai de prescription est porté :",
    options: ["À 6 mois", "À un an", "À 5 ans"],
    answer: "À un an",
    explanation:
        "Le législateur a prolongé la prescription à un an pour tenir compte de la gravité particulière de ces infractions.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Presse – Interventions policières",
    question:
        "Lorsqu’une enquête vise un média ou un journaliste, le policier doit notamment :",
    options: [
      "Chercher à connaître toutes les sources par tous moyens",
      "Respecter strictement le cadre de la réquisition judiciaire et la protection des sources",
      "Appeler directement la rédaction pour exiger des informations",
    ],
    answer:
        "Respecter strictement le cadre de la réquisition judiciaire et la protection des sources",
    explanation:
        "La liberté de la presse et le secret des sources imposent aux forces de l’ordre un comportement particulièrement encadré.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Constitution – Norme suprême",
    question:
        "Dans l’ordre juridique français, la norme qui se situe au sommet de la hiérarchie des normes est :",
    options: ["La loi", "La Constitution", "Le règlement"],
    answer: "La Constitution",
    explanation:
        "La Constitution est la norme suprême : toutes les lois et règlements doivent lui être conformes.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Constitution – Norme suprême",
    question:
        "La supériorité de la Constitution sur la loi n’a de sens que si :",
    options: [
      "Le Président de la République la lit chaque année au Parlement",
      "La Constitution est révisée tous les 5 ans",
      "Il existe un mécanisme de contrôle de la constitutionnalité des lois",
    ],
    answer:
        "Il existe un mécanisme de contrôle de la constitutionnalité des lois",
    explanation:
        "Sans contrôle de constitutionnalité, une loi contraire à la Constitution pourrait s’appliquer malgré tout.",
    difficulty: "Facile",
  ),

  // ---------- Types de Constitution ----------
  const QuizQuestion(
    category: "Types de Constitution",
    question: "Une Constitution dite « souple » est une Constitution qui :",
    options: [
      "Ne peut jamais être modifiée",
      "Peut être révisée comme une simple loi ordinaire",
      "N’a aucune valeur juridique",
    ],
    answer: "Peut être révisée comme une simple loi ordinaire",
    explanation:
        "Dans une Constitution souple, la procédure de révision est identique à celle des lois ordinaires.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Types de Constitution",
    question: "Une Constitution est qualifiée de « rigide » lorsqu’elle :",
    options: [
      "Est entièrement coutumière",
      "Prévoit une procédure de révision spéciale, plus exigeante que pour la loi",
      "Peut être modifiée par décret simple",
    ],
    answer:
        "Prévoit une procédure de révision spéciale, plus exigeante que pour la loi",
    explanation:
        "La rigidité signifie que la révision obéit à des conditions plus strictes que l’adoption d’une loi ordinaire.",
    difficulty: "Facile",
  ),

  // ---------- Révision de la Constitution ----------
  const QuizQuestion(
    category: "Révision constitutionnelle",
    question:
        "Quel article de la Constitution de 1958 encadre la procédure de révision constitutionnelle ?",
    options: ["Article 16", "Article 61-1", "Article 89"],
    answer: "Article 89",
    explanation:
        "L’article 89 fixe la procédure de révision : initiative, adoption identique par les deux assemblées, puis référendum ou Congrès.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révision constitutionnelle",
    question:
        "En France, la révision de la Constitution doit d’abord être adoptée :",
    options: [
      "Par le Conseil constitutionnel",
      "En termes identiques par l’Assemblée nationale et le Sénat",
      "Par le seul Président de la République",
    ],
    answer: "En termes identiques par l’Assemblée nationale et le Sénat",
    explanation:
        "L’article 89 exige un vote en termes identiques par les deux chambres avant approbation par référendum ou Congrès.",
    difficulty: "Facile",
  ),

  // ---------- Contrôle de constitutionnalité – principes ----------
  const QuizQuestion(
    category: "Contrôle de constitutionnalité – Principes",
    question:
        "Le contrôle de constitutionnalité des lois sert principalement à :",
    options: [
      "Contrôler la moralité des citoyens",
      "Vérifier la conformité des lois à la Constitution",
      "Organiser les élections municipales",
    ],
    answer: "Vérifier la conformité des lois à la Constitution",
    explanation:
        "Le contrôle de constitutionnalité protège la suprématie de la Constitution et les droits fondamentaux qu’elle garantit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Contrôle de constitutionnalité – Principes",
    question:
        "Dans un État à Constitution rigide, une loi contraire à la Constitution est :",
    options: [
      "Inconstitutionnelle",
      "Légitime car votée par le Parlement",
      "Supérieure à la Constitution",
    ],
    answer: "Inconstitutionnelle",
    explanation:
        "La loi doit respecter la Constitution : une loi contraire est inconstitutionnelle et doit être écartée ou abrogée.",
    difficulty: "Facile",
  ),

  // ---------- Modèles de contrôle ----------
  const QuizQuestion(
    category: "Modèles de contrôle",
    question: "Le contrôle de constitutionnalité par voie d’exception est :",
    options: [
      "Concentré entre les mains d’une seule juridiction",
      "Diffus et exercé par l’ensemble des juges",
      "Exercé uniquement par le Chef de l’État",
    ],
    answer: "Diffus et exercé par l’ensemble des juges",
    explanation:
        "Par voie d’exception, tout juge saisi d’un litige peut refuser d’appliquer une loi qu’il estime inconstitutionnelle.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Modèles de contrôle",
    question:
        "Le modèle français de contrôle par le Conseil constitutionnel est un contrôle :",
    options: ["Abstrait et concentré", "Diffus et concret", "International"],
    answer: "Abstrait et concentré",
    explanation:
        "Le Conseil constitutionnel exerce un contrôle concentré, souvent abstrait (a priori) avant la promulgation de la loi.",
    difficulty: "Facile",
  ),

  // ---------- Conseil constitutionnel – généralités ----------
  const QuizQuestion(
    category: "Conseil constitutionnel",
    question: "Le Conseil constitutionnel a été créé par la Constitution de :",
    options: ["1875", "1946", "1958"],
    answer: "1958",
    explanation:
        "Il s’agit d’une innovation majeure de la Ve République pour contrôler la conformité des lois à la Constitution.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conseil constitutionnel",
    question:
        "Avant la promulgation d’une loi, le contrôle de constitutionnalité exercé par le Conseil constitutionnel est qualifié de :",
    options: [
      "Contrôle a posteriori",
      "Contrôle a priori",
      "Contrôle de conventionnalité",
    ],
    answer: "Contrôle a priori",
    explanation:
        "Le contrôle a priori intervient avant l’entrée en vigueur de la loi.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conseil constitutionnel",
    question:
        "En cas de censure d’une loi par le Conseil constitutionnel avant sa promulgation :",
    options: [
      "La disposition censurée ne peut pas être promulguée",
      "La loi est quand même publiée telle quelle",
      "Seul le Gouvernement peut décider de l’appliquer ou non",
    ],
    answer: "La disposition censurée ne peut pas être promulguée",
    explanation:
        "Une disposition déclarée contraire à la Constitution ne peut entrer en vigueur.",
    difficulty: "Facile",
  ),

  // ---------- QPC – généralités ----------
  const QuizQuestion(
    category: "Question prioritaire de constitutionnalité (QPC)",
    question:
        "La question prioritaire de constitutionnalité (QPC) est prévue par :",
    options: [
      "L’article 16 de la Constitution",
      "L’article 61-1 de la Constitution",
      "L’article 89 de la Constitution",
    ],
    answer: "L’article 61-1 de la Constitution",
    explanation:
        "L’article 61-1 introduit la QPC, permettant de contester une loi déjà entrée en vigueur.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "QPC – généralités",
    question:
        "La QPC permet à un justiciable de soutenir qu’une disposition législative :",
    options: [
      "Violerait un traité international",
      "Porterait atteinte aux droits et libertés que la Constitution garantit",
      "Serait contraire aux circulaires ministérielles",
    ],
    answer:
        "Porterait atteinte aux droits et libertés que la Constitution garantit",
    explanation:
        "La QPC vise la compatibilité de la loi avec les droits et libertés constitutionnels.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "QPC – généralités",
    question: "La QPC est soulevée :",
    options: [
      "À l’occasion d’un procès en cours devant une juridiction",
      "Uniquement par le Président de la République",
      "Uniquement devant le maire",
    ],
    answer: "À l’occasion d’un procès en cours devant une juridiction",
    explanation:
        "La QPC est rattachée à un litige concret : elle se soulève devant une juridiction déjà saisie.",
    difficulty: "Facile",
  ),

  // ---------- Recours juridictionnels – généralités ----------
  const QuizQuestion(
    category: "Recours juridictionnels – Notion",
    question: "Les recours juridictionnels permettent à un individu de :",
    options: [
      "Demander une réforme constitutionnelle",
      "Contester l’activité des gouvernants devant un juge",
      "Révoquer directement un élu",
    ],
    answer: "Contester l’activité des gouvernants devant un juge",
    explanation:
        "Les recours juridictionnels sont les moyens offerts aux justiciables pour contester une décision ou une atteinte aux libertés devant une juridiction.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recours juridictionnels – Notion",
    question: "Les recours juridictionnels sont exercés devant :",
    options: [
      "Des autorités administratives indépendantes uniquement",
      "Les juridictions judiciaires et administratives",
      "Le Président de la République",
    ],
    answer: "Les juridictions judiciaires et administratives",
    explanation:
        "Ils s’exercent devant les juridictions chargées de la fonction de juger (pénale, civile, administrative).",
    difficulty: "Facile",
  ),

  // ---------- Recours judiciaires – pénal ----------
  const QuizQuestion(
    category: "Recours devant le juge pénal",
    question:
        "Lorsque l’atteinte à une liberté constitue une infraction, la victime peut saisir :",
    options: [
      "Le juge pénal",
      "Le Défenseur des droits uniquement",
      "Le Conseil constitutionnel directement",
    ],
    answer: "Le juge pénal",
    explanation:
        "Si les faits sont incriminés par le Code pénal, c’est la juridiction pénale qui sanctionne.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recours devant le juge pénal",
    question: "L’article 431-1 du Code pénal incrimine notamment :",
    options: [
      "L’entrave concertée, avec menaces, à l’exercice de certaines libertés",
      "Le défaut de carte d’identité",
      "La simple critique d’une décision administrative",
    ],
    answer:
        "L’entrave concertée, avec menaces, à l’exercice de certaines libertés",
    explanation:
        "L’article 431-1 vise les atteintes organisées à l’exercice de libertés comme la réunion, la manifestation, l’enseignement.",
    difficulty: "Facile",
  ),

  // ---------- Recours administratifs (indemnité / REP) ----------
  const QuizQuestion(
    category: "Recours administratifs – Généralités",
    question: "Les juridictions administratives contrôlent principalement :",
    options: [
      "Les litiges entre particuliers uniquement",
      "La légalité de l’action de l’administration et les dommages qu’elle cause",
      "Les élections professionnelles en entreprise",
    ],
    answer:
        "La légalité de l’action de l’administration et les dommages qu’elle cause",
    explanation:
        "Elles sont compétentes pour juger des actes administratifs et de la responsabilité de l’administration.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recours administratifs – Indemnité",
    question:
        "Le recours en indemnité devant le juge administratif vise à obtenir :",
    options: [
      "L’annulation d’un acte",
      "La réparation d’un dommage causé par l’administration",
      "La démission d’un élu",
    ],
    answer: "La réparation d’un dommage causé par l’administration",
    explanation:
        "Il s’agit d’un recours de pleine juridiction, visant à obtenir des dommages-intérêts.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recours administratifs – Excès de pouvoir",
    question: "Le recours pour excès de pouvoir a pour objet principal :",
    options: [
      "D’obtenir la condamnation pénale d’un agent public",
      "D’obtenir l’annulation d’un acte administratif illégal",
      "De modifier la Constitution",
    ],
    answer: "D’obtenir l’annulation d’un acte administratif illégal",
    explanation:
        "Le REP est un recours objectif visant à faire disparaître de l’ordre juridique un acte contraire à la légalité.",
    difficulty: "Facile",
  ),

  // ---------- Recours non juridictionnels – administratifs ----------
  const QuizQuestion(
    category: "Recours non juridictionnels – Administratifs",
    question: "Un recours gracieux est adressé :",
    options: [
      "À l’auteur même de la décision contestée",
      "Au juge administratif",
      "À la Cour européenne des droits de l’Homme",
    ],
    answer: "À l’auteur même de la décision contestée",
    explanation:
        "Le recours gracieux demande à l’autorité qui a pris la décision de la modifier ou de la retirer.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recours non juridictionnels – Administratifs",
    question: "Un recours hiérarchique est adressé :",
    options: [
      "Au supérieur de l’auteur de la décision",
      "À l’agent qui a exécuté la décision",
      "Au Président de la République uniquement",
    ],
    answer: "Au supérieur de l’auteur de la décision",
    explanation:
        "On s’adresse au supérieur hiérarchique pour qu’il réexamine la décision et la confirme ou l’annule.",
    difficulty: "Facile",
  ),

  // ---------- Recours non juridictionnels – politiques ----------
  const QuizQuestion(
    category: "Recours à caractère politique",
    question: "Le droit de pétition permet principalement :",
    options: [
      "De saisir le juge administratif",
      "D’adresser une demande ou une protestation à une autorité publique",
      "De saisir directement la Cour de cassation",
    ],
    answer:
        "D’adresser une demande ou une protestation à une autorité publique",
    explanation:
        "La pétition est un moyen d’expression politique, souvent collectif, adressé à une institution.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recours à caractère politique",
    question: "L’objection de conscience concerne traditionnellement :",
    options: [
      "Le refus de payer l’impôt sur le revenu",
      "Le refus d’accomplir le service militaire armé",
      "Le refus de répondre à un contrôle d’identité",
    ],
    answer: "Le refus d’accomplir le service militaire armé",
    explanation:
        "L’objection de conscience vise le refus de porter les armes pour des raisons religieuses, philosophiques ou morales.",
    difficulty: "Facile",
  ),

  // ---------- Résistance à l’oppression ----------
  const QuizQuestion(
    category: "Résistance à l’oppression",
    question: "La résistance à l’oppression est mentionnée dans :",
    options: [
      "Le Code de la sécurité intérieure",
      "La Déclaration des droits de l’Homme et du citoyen de 1789",
      "Le Code de procédure pénale",
    ],
    answer: "La Déclaration des droits de l’Homme et du citoyen de 1789",
    explanation:
        "L’article 2 de la DDHC évoque le droit de résistance à l’oppression comme un droit naturel et imprescriptible.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Résistance à l’oppression",
    question:
        "Pour un policier, la notion de résistance à l’oppression rappelle notamment que :",
    options: [
      "Il doit toujours obéir sans discuter à sa hiérarchie",
      "Il ne doit jamais appliquer un ordre manifestement illégal et gravement attentatoire aux libertés",
      "Il peut décider seul de suspendre une loi",
    ],
    answer:
        "Il ne doit jamais appliquer un ordre manifestement illégal et gravement attentatoire aux libertés",
    explanation:
        "Le policier doit refuser d’exécuter un ordre manifestement illégal, spécialement lorsqu’il porte gravement atteinte aux droits fondamentaux.",
    difficulty: "Facile",
  ),

  // ---------- Défenseur des droits – généralités ----------
  const QuizQuestion(
    category: "Défenseur des droits – Généralités",
    question: "Le Défenseur des droits est :",
    options: [
      "Une juridiction administrative",
      "Une autorité constitutionnelle indépendante",
      "Un service du ministère de l’Intérieur",
    ],
    answer: "Une autorité constitutionnelle indépendante",
    explanation:
        "Le Défenseur des droits est une autorité indépendante, mentionnée dans la Constitution.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Défenseur des droits – Généralités",
    question: "Le Défenseur des droits est nommé pour une durée de :",
    options: [
      "3 ans renouvelable",
      "6 ans non renouvelable",
      "9 ans renouvelable",
    ],
    answer: "6 ans non renouvelable",
    explanation:
        "Son mandat de 6 ans non renouvelable garantit son indépendance vis-à-vis des pouvoirs publics.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Défenseur des droits – Généralités",
    question: "Le Défenseur des droits peut être saisi :",
    options: [
      "Uniquement par un avocat",
      "Par toute personne physique ou morale, gratuitement",
      "Uniquement par un préfet",
    ],
    answer: "Par toute personne physique ou morale, gratuitement",
    explanation:
        "L’accès au Défenseur des droits est gratuit et ouvert à tous.",
    difficulty: "Facile",
  ),

  // ---------- Défenseur des droits – Missions ----------
  const QuizQuestion(
    category: "Défenseur des droits – Missions",
    question: "Parmi les missions du Défenseur des droits figure :",
    options: [
      "L’organisation des élections législatives",
      "La protection et la promotion des droits de l’enfant",
      "La rédaction des lois",
    ],
    answer: "La protection et la promotion des droits de l’enfant",
    explanation:
        "Le Défenseur des droits veille notamment aux droits de l’enfant et à leur respect.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Défenseur des droits – Missions",
    question: "Le Défenseur des droits intervient aussi pour :",
    options: [
      "Contrôler les permis de construire",
      "Lutter contre les discriminations et promouvoir l’égalité",
      "Diriger la police nationale",
    ],
    answer: "Lutter contre les discriminations et promouvoir l’égalité",
    explanation:
        "La lutte contre les discriminations est au cœur de ses missions.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Défenseur des droits – Déontologie sécurité",
    question:
        "En matière de sécurité, le Défenseur des droits veille notamment :",
    options: [
      "À la répartition budgétaire de la police",
      "Au respect de la déontologie par les personnes exerçant des activités de sécurité",
      "À la nomination des commissaires de police",
    ],
    answer:
        "Au respect de la déontologie par les personnes exerçant des activités de sécurité",
    explanation:
        "L’une des missions est le contrôle de la déontologie des forces de sécurité (art. L. 142-1 CSI).",
    difficulty: "Facile",
  ),

  // ---------- CGLPL – généralités ----------
  const QuizQuestion(
    category:
        "Contrôleur général des lieux de privation de liberté – Généralités",
    question: "Le Contrôleur général des lieux de privation de liberté est :",
    options: [
      "Une autorité administrative indépendante",
      "Un service de police judiciaire",
      "Une juridiction internationale",
    ],
    answer: "Une autorité administrative indépendante",
    explanation:
        "Institué par la loi de 2007, le CGLPL est chargé de contrôler les lieux de privation de liberté.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category:
        "Contrôleur général des lieux de privation de liberté – Compétence",
    question:
        "Le Contrôleur général des lieux de privation de liberté peut visiter :",
    options: [
      "Uniquement les établissements pénitentiaires",
      "Tout lieu de privation de liberté (garde à vue, prison, rétention, hôpital psychiatrique…)",
      "Uniquement les tribunaux",
    ],
    answer:
        "Tout lieu de privation de liberté (garde à vue, prison, rétention, hôpital psychiatrique…)",
    explanation:
        "Sa compétence couvre l’ensemble des lieux où des personnes sont privées de liberté sur décision publique.",
    difficulty: "Facile",
  ),

  // ---------- Organes internationaux – principe ----------
  const QuizQuestion(
    category: "Organes internationaux – Subsidiarité",
    question:
        "Avant de saisir un organe international de protection des droits de l’Homme, la personne doit en principe :",
    options: [
      "S’adresser d’abord au maire de son domicile",
      "Épuiser les voies de recours internes",
      "S’adresser directement à l’ONU sans aucune formalité",
    ],
    answer: "Épuiser les voies de recours internes",
    explanation:
        "C’est le principe de subsidiarité : les organes internationaux n’interviennent qu’en dernier ressort.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Organes internationaux – Généralités",
    question: "La Cour européenne des droits de l’Homme (CEDH) siège :",
    options: ["À Strasbourg", "À Luxembourg", "À Genève"],
    answer: "À Strasbourg",
    explanation:
        "La CEDH contrôle le respect de la Convention européenne des droits de l’Homme par les États membres du Conseil de l’Europe.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Organes internationaux – Généralités",
    question: "La Cour de justice de l’Union européenne (CJUE) siège :",
    options: ["À Strasbourg", "À Luxembourg", "À Bruxelles"],
    answer: "À Luxembourg",
    explanation: "La CJUE veille au respect du droit de l’Union européenne.",
    difficulty: "Facile",
  ),

  // =========================================================
  // ===================== NIVEAU MOYEN ======================
  // =========================================================

  // ---------- Constitution souple / rigide : effets ----------
  const QuizQuestion(
    category: "Types de Constitution – Effets",
    question: "Dans un système de Constitution souple, la loi ordinaire :",
    options: [
      "Peut modifier la Constitution sans procédure spéciale",
      "Est soumise à un contrôle strict de constitutionnalité",
      "Est toujours inférieure au règlement",
    ],
    answer: "Peut modifier la Constitution sans procédure spéciale",
    explanation:
        "La Constitution souple n’est pas protégée par une procédure de révision renforcée : la loi peut la remettre en cause.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Types de Constitution – Effets",
    question:
        "Dans un État à Constitution rigide, la protection des libertés publiques est en principe :",
    options: [
      "Moins forte, car la Constitution est plus difficile à modifier",
      "Renforcée, car la loi doit respecter des normes supérieures plus stables",
      "Indifférente à la hiérarchie des normes",
    ],
    answer:
        "Renforcée, car la loi doit respecter des normes supérieures plus stables",
    explanation:
        "La rigidité de la Constitution garantit une meilleure stabilité des droits fondamentaux.",
    difficulty: "Moyenne",
  ),

  // ---------- Révision constitutionnelle : procédure ----------
  const QuizQuestion(
    category: "Révision constitutionnelle – Procédure",
    question:
        "En application de l’article 89, l’initiative de la révision constitutionnelle appartient :",
    options: [
      "Uniquement au Président de la République",
      "Au Président de la République et aux membres du Parlement",
      "Uniquement au peuple par référendum",
    ],
    answer: "Au Président de la République et aux membres du Parlement",
    explanation:
        "Le projet de révision peut venir du Président sur proposition du Premier ministre ou des parlementaires.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révision constitutionnelle – Procédure",
    question:
        "Après le vote de la révision en termes identiques par les deux chambres, l’adoption définitive peut se faire :",
    options: [
      "Uniquement par référendum",
      "Soit par référendum, soit par le Congrès (3/5 des suffrages exprimés)",
      "Par décret simple du Gouvernement",
    ],
    answer:
        "Soit par référendum, soit par le Congrès (3/5 des suffrages exprimés)",
    explanation:
        "Le Président choisit entre référendum et réunion du Parlement en Congrès.",
    difficulty: "Moyenne",
  ),

  // ---------- Contrôle par voie d’exception ----------
  const QuizQuestion(
    category: "Contrôle par voie d’exception",
    question:
        "Dans le contrôle par voie d’exception, lorsqu’un juge estime une loi inconstitutionnelle :",
    options: [
      "Il l’abroge pour tous les justiciables",
      "Il refuse de l’appliquer au litige dont il est saisi",
      "Il doit saisir le Président de la République",
    ],
    answer: "Il refuse de l’appliquer au litige dont il est saisi",
    explanation:
        "Le juge écarte la loi dans le cas concret, sans nécessairement l’annuler pour l’avenir.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Contrôle par voie d’exception",
    question: "Le contrôle par voie d’exception est qualifié de concret car :",
    options: [
      "Il porte sur la loi indépendamment de tout litige",
      "Il est exercé sans demander l’avis des parties",
      "Il intervient à l’occasion d’un litige particulier",
    ],
    answer: "Il intervient à l’occasion d’un litige particulier",
    explanation:
        "Le juge examine la conformité de la loi parce qu’elle doit être appliquée dans une affaire précise.",
    difficulty: "Moyenne",
  ),

  // ---------- Contrôle par une juridiction constitutionnelle ----------
  const QuizQuestion(
    category: "Contrôle par une juridiction constitutionnelle",
    question:
        "Dans le modèle concentré, la constitutionnalité des lois est contrôlée :",
    options: [
      "Par toutes les juridictions sans distinction",
      "Par une juridiction spécialisée (ex : Conseil constitutionnel)",
      "Par le seul Président de la République",
    ],
    answer: "Par une juridiction spécialisée (ex : Conseil constitutionnel)",
    explanation:
        "Le contrôle est centralisé : seule cette juridiction peut déclarer une loi inconstitutionnelle.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Contrôle par une juridiction constitutionnelle",
    question:
        "L’effet principal d’une décision du Conseil constitutionnel déclarant une loi contraire à la Constitution (a priori) est :",
    options: [
      "La loi est promulguée mais inappliquée",
      "La disposition censurée ne peut être promulguée ni appliquée",
      "Seul le Gouvernement peut choisir de l’appliquer ou non",
    ],
    answer: "La disposition censurée ne peut être promulguée ni appliquée",
    explanation:
        "La décision a un effet erga omnes : la disposition ne peut entrer en vigueur.",
    difficulty: "Moyenne",
  ),

  // ---------- QPC – conditions d’examen ----------
  const QuizQuestion(
    category: "QPC – Conditions",
    question:
        "Pour qu’une juridiction transmette une QPC au Conseil d’État ou à la Cour de cassation, il faut notamment que :",
    options: [
      "La disposition législative soit applicable au litige",
      "La loi n’ait jamais été critiquée politiquement",
      "Le Gouvernement donne son accord",
    ],
    answer: "La disposition législative soit applicable au litige",
    explanation:
        "La QPC ne peut porter que sur une disposition ayant une incidence sur la solution du litige.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QPC – Conditions",
    question: "Parmi les conditions de transmission d’une QPC, on trouve :",
    options: [
      "La question doit être dépourvue de tout caractère sérieux",
      "La disposition ne doit pas avoir déjà été déclarée conforme dans les mêmes conditions",
      "La question doit concerner un règlement administratif",
    ],
    answer:
        "La disposition ne doit pas avoir déjà été déclarée conforme dans les mêmes conditions",
    explanation:
        "Si le Conseil constitutionnel a déjà jugé la disposition conforme dans les mêmes circonstances, la QPC n’est pas transmise.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QPC – Rôle des juridictions suprêmes",
    question:
        "Le Conseil d’État ou la Cour de cassation, saisis d’une QPC, exercent :",
    options: [
      "Un rôle de filtre avant la saisine éventuelle du Conseil constitutionnel",
      "Un contrôle politique des lois",
      "Un contrôle disciplinaire des juges",
    ],
    answer:
        "Un rôle de filtre avant la saisine éventuelle du Conseil constitutionnel",
    explanation:
        "Ils décident, dans un délai encadré, s’il y a lieu ou non de renvoyer la question au Conseil constitutionnel.",
    difficulty: "Moyenne",
  ),

  // ---------- QPC – effets de la décision ----------
  const QuizQuestion(
    category: "QPC – Effets",
    question:
        "Lorsqu’une disposition législative est déclarée inconstitutionnelle à l’occasion d’une QPC :",
    options: [
      "Elle est automatiquement réécrite par le Conseil constitutionnel",
      "Elle est abrogée et ne peut plus être appliquée",
      "Elle n’est écartée que pour le seul requérant",
    ],
    answer: "Elle est abrogée et ne peut plus être appliquée",
    explanation:
        "La décision a une portée générale, même si le Conseil peut différer la date d’abrogation.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QPC – Effets",
    question:
        "Après une déclaration d’inconstitutionnalité, une disposition similaire pourra être réintroduite si :",
    options: [
      "Le Parlement la vote à l’unanimité",
      "Le Conseil constitutionnel change de composition",
      "Un changement de circonstances de droit ou de fait le justifie",
    ],
    answer: "Un changement de circonstances de droit ou de fait le justifie",
    explanation:
        "Le Conseil constitutionnel admet qu’une nouvelle loi puisse intervenir en cas de changement de circonstances.",
    difficulty: "Moyenne",
  ),

  // ---------- Recours devant les juridictions judiciaires ----------
  const QuizQuestion(
    category: "Recours juridictionnels – Juge pénal",
    question:
        "En matière pénale, la victime d’une atteinte à une liberté peut :",
    options: [
      "Porter plainte et se constituer partie civile",
      "Saisir directement le Conseil constitutionnel",
      "Saisir la CEDH sans passer par les juridictions internes",
    ],
    answer: "Porter plainte et se constituer partie civile",
    explanation:
        "La plainte et la constitution de partie civile permettent de déclencher des poursuites et de demander réparation.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recours juridictionnels – Juge civil",
    question: "Le juge civil peut être saisi notamment pour :",
    options: [
      "Annuler un arrêté préfectoral",
      "Réparer une atteinte à la vie privée commise par un particulier",
      "Contrôler la régularité d’un scrutin national",
    ],
    answer: "Réparer une atteinte à la vie privée commise par un particulier",
    explanation:
        "Le juge civil sanctionne les manquements aux droits civils (ex : vie privée, image, honneur).",
    difficulty: "Moyenne",
  ),

  // ---------- Recours judiciaires – actes administratifs ----------
  const QuizQuestion(
    category: "Recours judiciaires – Exception d’illégalité",
    question: "L’exception d’illégalité permet au juge judiciaire :",
    options: [
      "D’annuler un acte administratif pour l’avenir",
      "De refuser d’appliquer un acte administratif illégal dans le litige soumis",
      "De modifier une loi contraire à la Constitution",
    ],
    answer:
        "De refuser d’appliquer un acte administratif illégal dans le litige soumis",
    explanation:
        "L’acte est écarté dans l’affaire mais n’est pas formellement annulé pour tous.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recours judiciaires – Emprise irrégulière",
    question:
        "Lorsque l’administration s’empare d’un bien privé sans respecter la procédure d’expropriation, on parle :",
    options: [
      "D’emprise régulière",
      "D’emprise irrégulière",
      "D’acte administratif détachable",
    ],
    answer: "D’emprise irrégulière",
    explanation:
        "L’emprise irrégulière permet au juge judiciaire de contrôler la dépossession et d’indemniser le propriétaire.",
    difficulty: "Moyenne",
  ),

  // ---------- Voie de fait ----------
  const QuizQuestion(
    category: "Voie de fait",
    question: "La voie de fait se caractérise notamment par :",
    options: [
      "Une simple illégalité mineure",
      "Une atteinte particulièrement grave à une liberté fondamentale ou à la propriété par l’administration",
      "Un litige entre deux particuliers",
    ],
    answer:
        "Une atteinte particulièrement grave à une liberté fondamentale ou à la propriété par l’administration",
    explanation:
        "La voie de fait suppose une gravité telle que l’acte ne peut se rattacher à aucun pouvoir administratif.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Voie de fait",
    question:
        "En cas de voie de fait, le juge compétent pour faire cesser l’atteinte et indemniser la victime est :",
    options: [
      "Le juge administratif exclusivement",
      "Le juge judiciaire",
      "Le Conseil constitutionnel",
    ],
    answer: "Le juge judiciaire",
    explanation:
        "La voie de fait est une exception : elle redonne compétence au juge judiciaire pour sanctionner l’administration.",
    difficulty: "Moyenne",
  ),

  // ---------- Recours administratifs – Indemnité / REP ----------
  const QuizQuestion(
    category: "Recours administratifs – Indemnité",
    question:
        "Dans le cadre d’un recours en indemnité, le juge administratif peut :",
    options: [
      "Annuler la Constitution",
      "Condamner l’administration à verser des dommages-intérêts",
      "Modifier une loi votée par le Parlement",
    ],
    answer: "Condamner l’administration à verser des dommages-intérêts",
    explanation:
        "C’est un recours de pleine juridiction qui porte sur la réparation financière du dommage.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recours administratifs – Excès de pouvoir",
    question:
        "Parmi les causes classiques d’illégalité d’un acte administratif, on trouve :",
    options: [
      "L’incompétence de l’auteur",
      "L’absence de débat politique",
      "Le caractère impopulaire de la mesure",
    ],
    answer: "L’incompétence de l’auteur",
    explanation:
        "Un acte pris par une autorité non compétente est illégal et peut être annulé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recours administratifs – Excès de pouvoir",
    question: "Le détournement de pouvoir consiste pour l’administration à :",
    options: [
      "Ne pas motiver un acte",
      "Utiliser une compétence à des fins étrangères à l’intérêt général",
      "Prendre une décision en urgence",
    ],
    answer: "Utiliser une compétence à des fins étrangères à l’intérêt général",
    explanation:
        "Le juge peut annuler un acte pris pour un motif personnel ou politique sans lien avec l’objet légal du pouvoir.",
    difficulty: "Moyenne",
  ),

  // ---------- Recours administratifs – Libertés publiques ----------
  const QuizQuestion(
    category: "Recours administratifs – Libertés publiques",
    question:
        "Lorsqu’un arrêté de police limite l’exercice d’une liberté publique, le juge administratif vérifie notamment :",
    options: [
      "La popularité de la mesure",
      "La nécessité et la proportionnalité des restrictions",
      "Le coût financier de la décision",
    ],
    answer: "La nécessité et la proportionnalité des restrictions",
    explanation:
        "En application de la jurisprudence Benjamin, toute atteinte à une liberté doit être nécessaire et proportionnée.",
    difficulty: "Moyenne",
  ),

  // ---------- Responsabilité de l’État du fait des lois ----------
  const QuizQuestion(
    category: "Responsabilité de l’État du fait des lois",
    question:
        "La responsabilité de l’État du fait des lois peut être engagée notamment lorsque :",
    options: [
      "Une loi cause un préjudice spécial et anormal à certains particuliers",
      "Une loi est contestée politiquement",
      "Le Conseil constitutionnel le décide automatiquement",
    ],
    answer:
        "Une loi cause un préjudice spécial et anormal à certains particuliers",
    explanation:
        "Selon la jurisprudence La Fleurette, l’État peut être responsable sans faute pour les dommages causés par une loi.",
    difficulty: "Moyenne",
  ),

  // ---------- Défenseur des droits – Saisine et pouvoirs ----------
  const QuizQuestion(
    category: "Défenseur des droits – Saisine",
    question: "La saisine du Défenseur des droits est :",
    options: [
      "Écrite ou orale, directe ou via un parlementaire",
      "Uniquement possible via un recours gracieux",
      "Soumise à des frais de dossier",
    ],
    answer: "Écrite ou orale, directe ou via un parlementaire",
    explanation:
        "La saisine est simplifiée, gratuite et peut se faire par différents canaux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Défenseur des droits – Pouvoirs",
    question: "Le Défenseur des droits peut, dans le cadre de ses enquêtes :",
    options: [
      "Prononcer directement des peines de prison",
      "Demander la communication de pièces et formuler des recommandations",
      "Modifier à lui seul un règlement de police",
    ],
    answer:
        "Demander la communication de pièces et formuler des recommandations",
    explanation:
        "Il dispose de pouvoirs d’enquête importants mais ses décisions ont une nature principalement recommandatoire.",
    difficulty: "Moyenne",
  ),

  // ---------- CGLPL – Pouvoirs ----------
  const QuizQuestion(
    category: "CGLPL – Pouvoirs d’enquête",
    question:
        "Le Contrôleur général peut se rendre dans un lieu de privation de liberté :",
    options: [
      "Uniquement sur autorisation du préfet",
      "À tout moment, sans préavis particulier",
      "Seulement tous les cinq ans",
    ],
    answer: "À tout moment, sans préavis particulier",
    explanation:
        "La loi lui donne un droit de visite très large, sous réserve de certains secrets protégés.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "CGLPL – Pouvoirs d’enquête",
    question:
        "En cas d’atteinte grave aux droits fondamentaux constatée par le CGLPL, celui-ci peut :",
    options: [
      "Saisir le procureur de la République",
      "Modifier les règles internes de la prison",
      "Prononcer la remise en liberté immédiate",
    ],
    answer: "Saisir le procureur de la République",
    explanation:
        "Le CGLPL peut alerter le parquet et les autorités disciplinaires lorsqu’il constate des faits graves.",
    difficulty: "Moyenne",
  ),

  // ---------- Organes internationaux – Comité discrimination raciale ----------
  const QuizQuestion(
    category: "ONU – Comité discrimination raciale",
    question:
        "Le Comité pour l’élimination de la discrimination raciale contrôle l’application :",
    options: [
      "De la Convention internationale sur l’élimination de toutes les formes de discrimination raciale",
      "De la Convention européenne des droits de l’Homme",
      "Du Traité sur l’Union européenne",
    ],
    answer:
        "De la Convention internationale sur l’élimination de toutes les formes de discrimination raciale",
    explanation:
        "Ce comité, créé en 1969, veille au respect de cette convention par les États parties.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "ONU – Comité discrimination raciale",
    question:
        "Le recours individuel devant le Comité pour l’élimination de la discrimination raciale suppose :",
    options: [
      "Que la personne ait d’abord épuisé les recours internes",
      "Qu’aucun recours interne ne soit possible",
      "Que le Défenseur des droits donne son accord",
    ],
    answer: "Que la personne ait d’abord épuisé les recours internes",
    explanation:
        "C’est l’illustration du principe de subsidiarité en droit international des droits de l’Homme.",
    difficulty: "Moyenne",
  ),

  // ---------- CEDH – Saisine ----------
  const QuizQuestion(
    category: "CEDH – Saisine",
    question:
        "Une requête individuelle devant la Cour européenne des droits de l’Homme peut être introduite par :",
    options: [
      "Toute personne physique, ONG ou groupement de particuliers",
      "Uniquement par un État",
      "Uniquement par le Conseil constitutionnel",
    ],
    answer: "Toute personne physique, ONG ou groupement de particuliers",
    explanation: "La CEDH est largement ouverte aux requêtes individuelles.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "CEDH – Effets",
    question: "En cas de condamnation de la France par la CEDH :",
    options: [
      "La France doit verser une satisfaction équitable et adapter son droit interne",
      "La France peut ignorer la décision sans conséquence",
      "La décision n’a effet que symbolique",
    ],
    answer:
        "La France doit verser une satisfaction équitable et adapter son droit interne",
    explanation:
        "Les arrêts de la CEDH entraînent souvent des réformes législatives ou réglementaires.",
    difficulty: "Moyenne",
  ),

  // ---------- CJUE – Renvoi préjudiciel ----------
  const QuizQuestion(
    category: "CJUE – Renvoi préjudiciel",
    question: "Le renvoi préjudiciel à la CJUE permet :",
    options: [
      "De faire juger un litige entre particuliers",
      "À une juridiction nationale de demander l’interprétation d’une norme de l’UE",
      "Au Gouvernement de faire annuler une loi nationale",
    ],
    answer:
        "À une juridiction nationale de demander l’interprétation d’une norme de l’UE",
    explanation:
        "Le renvoi préjudiciel garantit l’unité d’interprétation du droit de l’Union.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // ============ NIVEAU DIFFICILE (INCL. Difficile) ============
  // =========================================================

  // ---------- Hiérarchie des normes & libertés ----------
  const QuizQuestion(
    category: "Hiérarchie des normes – Libertés",
    question:
        "Dans la hiérarchie des normes, le « bloc de constitutionnalité » comprend notamment :",
    options: [
      "La Constitution de 1958, la DDHC de 1789, le Préambule de 1946 et la Charte de l’environnement",
      "La Constitution, les décrets et les circulaires",
      "Les seuls traités internationaux relatifs aux droits de l’Homme",
    ],
    answer:
        "La Constitution de 1958, la DDHC de 1789, le Préambule de 1946 et la Charte de l’environnement",
    explanation:
        "Ces textes ont valeur constitutionnelle et protègent directement les droits et libertés.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Hiérarchie des normes – Libertés",
    question:
        "Lorsqu’un règlement de police porte atteinte à une liberté publique, le juge administratif contrôle :",
    options: [
      "Uniquement sa conformité à la loi",
      "Sa conformité à l’ensemble des normes supérieures (Constitution, conventions, lois)",
      "Uniquement sa conformité aux circulaires ministérielles",
    ],
    answer:
        "Sa conformité à l’ensemble des normes supérieures (Constitution, conventions, lois)",
    explanation:
        "Le contrôle s’effectue en fonction de toute la hiérarchie des normes, notamment des textes à valeur constitutionnelle et conventionnelle.",
    difficulty: "Difficile",
  ),

  // ---------- Jurisprudence Benjamin – Police & libertés ----------
  const QuizQuestion(
    category: "Police administrative & libertés – Benjamin",
    question:
        "L’arrêt CE, 19 mai 1933, Benjamin impose à l’autorité de police :",
    options: [
      "De privilégier systématiquement l’interdiction générale des réunions",
      "De concilier liberté et ordre public en recourant aux mesures les moins restrictives possibles",
      "De soumettre toute réunion publique à autorisation préalable",
    ],
    answer:
        "De concilier liberté et ordre public en recourant aux mesures les moins restrictives possibles",
    explanation:
        "Le juge impose un contrôle strict de nécessité et de proportionnalité des mesures de police.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Police administrative & libertés – Benjamin",
    question:
        "Dans le cadre d’un recours contre une interdiction de manifestation, le juge administratif vérifie notamment si :",
    options: [
      "Des moyens de maintien de l’ordre moins attentatoires à la liberté étaient disponibles",
      "L’interdiction était politiquement populaire",
      "La police bénéficiait d’un budget suffisant",
    ],
    answer:
        "Des moyens de maintien de l’ordre moins attentatoires à la liberté étaient disponibles",
    explanation:
        "Si d’autres moyens permettaient de prévenir le trouble à l’ordre public, l’interdiction est jugée disproportionnée.",
    difficulty: "Difficile",
  ),

  // ---------- QPC vs contrôle a priori ----------
  const QuizQuestion(
    category: "QPC & contrôle a priori",
    question:
        "Le contrôle a priori du Conseil constitutionnel et la QPC se distinguent notamment par :",
    options: [
      "Le moment où ils interviennent (avant ou après l’entrée en vigueur de la loi)",
      "Le fait que seul le Président peut les déclencher",
      "Leur absence de lien avec les libertés",
    ],
    answer:
        "Le moment où ils interviennent (avant ou après l’entrée en vigueur de la loi)",
    explanation:
        "Le contrôle a priori intervient avant la promulgation, la QPC porte sur une loi déjà en vigueur.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QPC & contrôle a priori",
    question:
        "La QPC a renforcé la protection des libertés fondamentales car elle permet :",
    options: [
      "De contrôler des lois anciennes à partir de situations concrètes",
      "De modifier directement la Constitution",
      "De contourner la hiérarchie des normes",
    ],
    answer: "De contrôler des lois anciennes à partir de situations concrètes",
    explanation:
        "La QPC ouvre un contrôle a posteriori d’une grande partie du stock législatif.",
    difficulty: "Difficile",
  ),

  // ---------- Articulation QPC / conventions internationales ----------
  const QuizQuestion(
    category: "QPC & conventions internationales",
    question:
        "Face à une loi contraire à la fois à la Constitution et à la CEDH, un justiciable peut invoquer :",
    options: [
      "Seulement la CEDH",
      "Seulement la Constitution",
      "La QPC pour la Constitution et un moyen de conventionnalité pour la CEDH",
    ],
    answer:
        "La QPC pour la Constitution et un moyen de conventionnalité pour la CEDH",
    explanation:
        "Les deux contrôles coexistent : constitutionnalité via QPC, conventionnalité via les juges ordinaires.",
    difficulty: "Difficile",
  ),

  // ---------- Recours administratifs d’urgence – Référé-liberté ----------
  const QuizQuestion(
    category: "Référé-liberté",
    question: "Le référé-liberté permet au juge administratif de :",
    options: [
      "Statuer en urgence pour faire cesser une atteinte grave et manifestement illégale à une liberté fondamentale",
      "Réviser la Constitution",
      "Sanctionner pénalement un agent public",
    ],
    answer:
        "Statuer en urgence pour faire cesser une atteinte grave et manifestement illégale à une liberté fondamentale",
    explanation:
        "Introduit par la loi de 2000, il offre un outil de protection rapide des libertés.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Référé-liberté",
    question: "Pour qu’un référé-liberté soit recevable, il faut notamment :",
    options: [
      "Une atteinte grave et manifestement illégale à une liberté fondamentale",
      "Un délai d’au moins un an après la décision contestée",
      "L’accord préalable du préfet",
    ],
    answer:
        "Une atteinte grave et manifestement illégale à une liberté fondamentale",
    explanation:
        "Le juge des référés intervient en urgence pour sauvegarder une liberté fondamentale menacée.",
    difficulty: "Difficile",
  ),

  // ---------- Voie de fait / compétence judiciaire vs administrative ----------
  const QuizQuestion(
    category: "Voie de fait – Compétence",
    question: "La qualification de voie de fait emporte principalement :",
    options: [
      "Compétence du juge administratif",
      "Compétence du juge judiciaire pour faire cesser l’atteinte et indemniser",
      "Compétence du Défenseur des droits pour prononcer une sanction pénale",
    ],
    answer:
        "Compétence du juge judiciaire pour faire cesser l’atteinte et indemniser",
    explanation:
        "La voie de fait retire exceptionnellement la compétence au juge administratif.",
    difficulty: "Difficile",
  ),

  // ---------- Responsabilité de l’État du fait des lois – Conditions détaillées ----------
  const QuizQuestion(
    category: "Responsabilité de l’État du fait des lois – Conditions",
    question:
        "Selon la jurisprudence La Fleurette, la responsabilité de l’État du fait d’une loi suppose que :",
    options: [
      "Le législateur ait expressément prévu l’absence d’indemnisation",
      "Le préjudice soit spécial, anormal, et ne résulte pas d’une activité illicite",
      "La loi soit déclarée inconstitutionnelle",
    ],
    answer:
        "Le préjudice soit spécial, anormal, et ne résulte pas d’une activité illicite",
    explanation:
        "L’État peut être responsable même sans faute si ces conditions sont remplies.",
    difficulty: "Difficile",
  ),

  // ---------- Défenseur des droits & police – Difficile ----------
  const QuizQuestion(
    category: "Défenseur des droits & Police",
    question:
        "En matière de déontologie des forces de sécurité, le Défenseur des droits peut :",
    options: [
      "Prononcer directement des sanctions disciplinaires contre les policiers",
      "Recommander des sanctions disciplinaires à l’autorité compétente",
      "Modifier le Code de déontologie de la police",
    ],
    answer: "Recommander des sanctions disciplinaires à l’autorité compétente",
    explanation:
        "Il exerce un pouvoir d’influence important mais ne se substitue pas aux autorités disciplinaires.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Défenseur des droits & Police",
    question:
        "Pour un policier, la saisine du Défenseur des droits par un citoyen implique :",
    options: [
      "Une obligation de coopérer et de répondre aux demandes d’information",
      "Un droit de refuser toute information pour ne pas se compromettre",
      "Une suspension automatique du service",
    ],
    answer:
        "Une obligation de coopérer et de répondre aux demandes d’information",
    explanation:
        "Le refus de coopération peut être signalé et avoir des conséquences disciplinaires.",
    difficulty: "Difficile",
  ),

  // ---------- CGLPL & locaux de garde à vue – Difficile ----------
  const QuizQuestion(
    category: "CGLPL & Garde à vue",
    question:
        "Lors d’une visite de locaux de garde à vue, le CGLPL porte une attention particulière :",
    options: [
      "Aux conditions matérielles, au respect de la dignité et à l’accès aux droits (avocat, médecin, famille…)",
      "Uniquement au nombre d’interpellations réalisées",
      "À la performance statistique du service",
    ],
    answer:
        "Aux conditions matérielles, au respect de la dignité et à l’accès aux droits (avocat, médecin, famille…)",
    explanation:
        "Le CGLPL veille à ce que la privation de liberté s’exerce dans des conditions respectueuses des droits fondamentaux.",
    difficulty: "Difficile",
  ),

  // ---------- CEDH – Recevabilité & procédure – Difficile ----------
  const QuizQuestion(
    category: "CEDH – Recevabilité",
    question:
        "Pour qu’une requête soit recevable devant la CEDH, il faut notamment :",
    options: [
      "Que le requérant ait épuisé les voies de recours internes et agisse dans un certain délai après la décision interne définitive",
      "Que le Défenseur des droits donne son accord écrit",
      "Que le Gouvernement français ne s’y oppose pas",
    ],
    answer:
        "Que le requérant ait épuisé les voies de recours internes et agisse dans un certain délai après la décision interne définitive",
    explanation:
        "Le principe de subsidiarité impose d’utiliser d’abord les recours internes avant de saisir la CEDH.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "CEDH – Effets en droit interne",
    question:
        "Les condamnations de la France par la CEDH ont pour conséquence :",
    options: [
      "Uniquement le versement d’une indemnité à la victime",
      "Souvent une réforme de la législation ou de la pratique administrative",
      "La nullité de toutes les lois votées dans l’année",
    ],
    answer:
        "Souvent une réforme de la législation ou de la pratique administrative",
    explanation:
        "Les États doivent tirer les conséquences des arrêts de la CEDH pour éviter de nouvelles violations.",
    difficulty: "Difficile",
  ),

  // ---------- CJUE & données personnelles / police – Difficile ----------
  const QuizQuestion(
    category: "CJUE & Libertés – Données",
    question:
        "Les décisions de la CJUE en matière de protection des données personnelles influencent :",
    options: [
      "Uniquement les entreprises privées",
      "Les pratiques policières (fichiers, conservation des données, échanges d’informations)",
      "Uniquement les réseaux sociaux",
    ],
    answer:
        "Les pratiques policières (fichiers, conservation des données, échanges d’informations)",
    explanation:
        "Les policiers doivent respecter le droit de l’Union en matière de protection des données.",
    difficulty: "Difficile",
  ),

  // ---------- Synthèse – Garanties multiples des libertés ----------
  const QuizQuestion(
    category: "Synthèse – Garanties des libertés",
    question:
        "La protection des libertés publiques en France repose notamment sur :",
    options: [
      "La seule activité du Parlement",
      "Un ensemble de garanties combinées (Constitution, QPC, recours juridictionnels, autorités indépendantes, organes internationaux)",
      "La seule intervention des organes internationaux",
    ],
    answer:
        "Un ensemble de garanties combinées (Constitution, QPC, recours juridictionnels, autorités indépendantes, organes internationaux)",
    explanation:
        "C’est l’articulation de ces différents mécanismes qui assure une protection effective des libertés.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
    category: "Fondements juridiques",
    question:
        "Quel article de la Déclaration universelle des droits de l’Homme (ONU) protège la vie privée, la famille, le domicile et la correspondance ?",
    options: ["L’article 12", "L’article 3", "L’article 10"],
    answer: "L’article 12",
    explanation:
        "L’article 12 de la Déclaration universelle des droits de l’Homme protège contre les immixtions arbitraires dans la vie privée, la famille, le domicile ou la correspondance.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Fondements juridiques",
    question:
        "Quel article de la Convention européenne des droits de l’Homme consacre le droit au respect de la vie privée et familiale, du domicile et de la correspondance ?",
    options: ["L’article 8", "L’article 6", "L’article 10"],
    answer: "L’article 8",
    explanation:
        "L’article 8 de la CEDH protège le droit au respect de la vie privée et familiale, du domicile et de la correspondance.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
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
  const QuizQuestion(
    category: "Fondements juridiques",
    question:
        "Quel article de la Déclaration des droits de l’Homme et du citoyen est explicitement utilisé par le Conseil constitutionnel pour rattacher le droit au respect de la vie privée ?",
    options: ["L’article 2", "L’article 9", "L’article 16"],
    answer: "L’article 2",
    explanation:
        "Le Conseil constitutionnel rattache le droit au respect de la vie privée à l’article 2 de la Déclaration de 1789, qui garantit les droits naturels de l’homme.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
    category: "Vidéoprotection",
    question:
        "La vidéoprotection a été initialement autorisée par la loi d’orientation et de programmation relative à la sécurité du :",
    options: ["21 janvier 1995", "10 mars 1981", "1 janvier 2000"],
    answer: "21 janvier 1995",
    explanation:
        "La loi du 21 janvier 1995 a introduit le recours à la vidéoprotection, anciennement appelée vidéosurveillance.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
    category: "Vidéoprotection",
    question:
        "La durée maximale de conservation des images de vidéoprotection, hors nécessité de procédure pénale, est en principe limitée à :",
    options: ["Un mois", "Six mois", "Un an"],
    answer: "Un mois",
    explanation:
        "L’article L. 252-5 CSI prévoit que les enregistrements ne peuvent être conservés au-delà d’un délai fixé par l’autorisation, sans dépasser un mois, sauf besoin d’une procédure pénale.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
    category: "Protection pénale",
    question:
        "L’article 226-3-1 du Code pénal réprime le fait d’apercevoir les parties intimes d’une personne à son insu. Il s’agit de :",
    options: ["Voyeurisme", "Vol simple", "Usure"],
    answer: "Voyeurisme",
    explanation:
        "Le texte vise le voyeurisme, défini comme le fait d’user de tout moyen pour apercevoir les parties intimes d’une personne sans son consentement.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
    category: "CNIL - statut",
    question: "La CNIL est une autorité :",
    options: ["Administrative indépendante", "Judiciaire", "Policière"],
    answer: "Administrative indépendante",
    explanation:
        "Elle agit au nom de l’État, mais sans être placée sous l’autorité d’un ministre, ce qui garantit son indépendance.",
    difficulty: "Facile",
  ),

  // ---------- MISSIONS GÉNÉRALES ----------
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
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
  const QuizQuestion(
    category: "D.D.H.C. — Généralités",
    question:
        "La Déclaration des droits de l’homme et du citoyen (D.D.H.C.) a été adoptée le :",
    options: ["14 juillet 1789", "26 août 1789", "4 octobre 1958"],
    answer: "26 août 1789",
    explanation:
        "Le texte rappelle que la D.D.H.C. a été adoptée le 26 août 1789, en pleine Révolution française.",
    difficulty: "Facile",
  ),
  // ===================== RÉGIME JURIDIQUE — NIVEAU FACILE =====================
  const QuizQuestion(
    category: "Régime juridique — Généralités",
    question:
        "Selon le cours, pourquoi ne peut-il pas exister de liberté publique absolue ?",
    options: [
      "Parce que l’État doit toujours tout contrôler",
      "Parce que sans règles, la liberté se transforme en anarchie",
      "Parce que les citoyens refusent la liberté",
    ],
    answer: "Parce que sans règles, la liberté se transforme en anarchie",
    explanation:
        "Le texte précise qu’en l’absence de règles, la liberté se transforme en anarchie, ce qui justifie l’encadrement juridique des libertés publiques.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Généralités",
    question:
        "L’idée directrice du régime juridique des libertés publiques est que :",
    options: [
      "La restriction est la règle et la liberté l’exception",
      "Réglementer une liberté publique ne signifie pas la supprimer",
      "Toute liberté doit être supprimée pour préserver l’ordre public",
    ],
    answer: "Réglementer une liberté publique ne signifie pas la supprimer",
    explanation:
        "La fiche insiste sur le fait que la réglementation fixe des bornes, mais maintient la liberté comme principe et la restriction comme exception.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Autorités",
    question:
        "Quels sont les deux grands acteurs qui encadrent les libertés publiques ?",
    options: [
      "Le législateur et le pouvoir exécutif",
      "Le juge judiciaire et les particuliers",
      "Les partis politiques et les syndicats",
    ],
    answer: "Le législateur et le pouvoir exécutif",
    explanation:
        "Le cours indique que le législateur (loi) et le pouvoir exécutif (pouvoir réglementaire) sont les deux grands acteurs qui réglementent les libertés.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Législateur",
    question:
        "La Constitution de 1958 confie au Parlement la détermination des règles concernant :",
    options: [
      "Uniquement le budget de l’État",
      "Les droits civiques et les garanties fondamentales accordées aux citoyens pour leur exercice",
      "La seule organisation des collectivités territoriales",
    ],
    answer:
        "Les droits civiques et les garanties fondamentales accordées aux citoyens pour leur exercice",
    explanation:
        "L’article 34 de la Constitution de 1958 donne compétence au législateur pour fixer les règles relatives aux droits civiques et à leurs garanties.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Législateur",
    question:
        "En matière de libertés publiques, le législateur dispose d’une :",
    options: [
      "Compétence de principe",
      "Compétence purement accessoire",
      "Compétence inexistante",
    ],
    answer: "Compétence de principe",
    explanation:
        "La fiche précise que le législateur a une compétence de principe pour fixer le régime des libertés publiques.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Législateur",
    question:
        "Le législateur peut, en matière de libertés publiques, notamment :",
    options: [
      "Créer de nouvelles libertés et définir leurs modalités d’exercice",
      "Modifier directement la Constitution par simple loi",
      "Supprimer n’importe quelle liberté sans contrôle",
    ],
    answer: "Créer de nouvelles libertés et définir leurs modalités d’exercice",
    explanation:
        "Le cours explique que la loi peut créer de nouvelles libertés, en préciser les modalités et, parfois, en restreindre l’exercice.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Pouvoir réglementaire",
    question: "Le pouvoir réglementaire appartient principalement :",
    options: [
      "Au Gouvernement et aux autorités administratives (préfet, maire…)",
      "Aux juges constitutionnels",
      "Aux organisations non gouvernementales",
    ],
    answer: "Au Gouvernement et aux autorités administratives (préfet, maire…)",
    explanation:
        "Le texte souligne que le pouvoir exécutif (gouvernement, préfet, maire) met en œuvre les libertés par des règlements.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Pouvoir réglementaire",
    question: "Le pouvoir réglementaire complète principalement :",
    options: [
      "Les lois, en précisant les conditions d’exercice des libertés",
      "Les décisions de l’ONU uniquement",
      "Les coutumes locales sans base légale",
    ],
    answer: "Les lois, en précisant les conditions d’exercice des libertés",
    explanation:
        "Le cours indique que le règlement vient détailler et compléter la loi, par exemple via la partie réglementaire des codes.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Période normale",
    question: "En période normale, l’autorité administrative ne peut pas :",
    options: [
      "Limiter une liberté dans le temps et l’espace",
      "Interdire de manière générale et absolue l’exercice d’une liberté",
      "Prendre des mesures proportionnées à un risque précis",
    ],
    answer: "Interdire de manière générale et absolue l’exercice d’une liberté",
    explanation:
        "Le cours rappelle qu’aucune interdiction générale et absolue n’est possible en matière de liberté publique en période ordinaire.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Période normale",
    question:
        "Toute mesure d’interdiction d’une liberté en période normale doit être :",
    options: [
      "Purement symbolique",
      "Indispensable au maintien de l’ordre public",
      "Décidée par référendum",
    ],
    answer: "Indispensable au maintien de l’ordre public",
    explanation:
        "Le texte précise que l’interdiction doit être indispensable au maintien de l’ordre public et motivée par des circonstances précises.",
    difficulty: "Facile",
  ),

  // ===================== RÉGIME JURIDIQUE — NIVEAU MOYEN =====================
  const QuizQuestion(
    category: "Régime juridique — Législateur",
    question:
        "Parmi les propositions suivantes, laquelle illustre une création de liberté par la loi ?",
    options: [
      "La loi du 17 juillet 1970 renforçant le droit au respect de la vie privée",
      "Un simple arrêté municipal limitant la circulation",
      "Une circulaire de service interne à un commissariat",
    ],
    answer:
        "La loi du 17 juillet 1970 renforçant le droit au respect de la vie privée",
    explanation:
        "La loi de 1970 est citée comme exemple de texte législatif créant ou renforçant une liberté fondamentale, ici la vie privée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Régime juridique — Législateur",
    question:
        "Le législateur peut revenir sur une liberté publique déjà acquise :",
    options: [
      "Sans aucune limite",
      "Uniquement si cette liberté n’a jamais été légalement consacrée ou pour atteindre un objectif de valeur constitutionnelle",
      "Seulement avec l’accord des maires",
    ],
    answer:
        "Uniquement si cette liberté n’a jamais été légalement consacrée ou pour atteindre un objectif de valeur constitutionnelle",
    explanation:
        "Le cours indique que la remise en cause d’une liberté n’est possible que si elle n’était pas juridiquement acquise ou pour un motif de valeur constitutionnelle.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Régime juridique — Pouvoir réglementaire",
    question:
        "Le pouvoir réglementaire peut restreindre l’exercice d’une liberté à condition de respecter :",
    options: [
      "Les principes de légalité, de nécessité et de proportionnalité",
      "Uniquement la volonté du maire",
      "Exclusivement l’intérêt économique de la commune",
    ],
    answer: "Les principes de légalité, de nécessité et de proportionnalité",
    explanation:
        "La fiche insiste sur ces trois principes pour encadrer les restrictions réglementaires aux libertés.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Régime juridique — Période normale",
    question:
        "Pourquoi le juge contrôle-t-il plus strictement les mesures de police qui touchent une liberté fondamentale ?",
    options: [
      "Parce que la liberté fondamentale est toujours illégale",
      "Parce que ces libertés (aller et venir, réunion, expression…) bénéficient d’une protection renforcée",
      "Parce qu’il ne peut jamais annuler de mesure de police",
    ],
    answer:
        "Parce que ces libertés (aller et venir, réunion, expression…) bénéficient d’une protection renforcée",
    explanation:
        "Le texte explique que plus la liberté est fondamentale, plus le contrôle de proportionnalité du juge administratif est rigoureux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Régime juridique — États d’exception",
    question: "L’état de siège est principalement destiné à faire face :",
    options: [
      "À une simple manifestation locale",
      "À une guerre étrangère ou une insurrection armée",
      "À un conflit familial",
    ],
    answer: "À une guerre étrangère ou une insurrection armée",
    explanation:
        "Le cours définit l’état de siège comme un régime destiné au péril résultant d’une guerre ou d’une insurrection armée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Régime juridique — États d’exception",
    question:
        "Pendant l’état de siège, certaines compétences de police sont transférées :",
    options: [
      "Au Conseil constitutionnel",
      "À l’autorité militaire",
      "Aux maires seulement",
    ],
    answer: "À l’autorité militaire",
    explanation:
        "La fiche précise que l’état de siège entraîne le transfert de certains pouvoirs de police à l’autorité militaire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Régime juridique — Article 16",
    question:
        "Les pouvoirs exceptionnels de l’article 16 de la Constitution peuvent être mis en œuvre lorsque :",
    options: [
      "Les institutions de la République sont gravement menacées et le fonctionnement régulier des pouvoirs publics est interrompu",
      "Le Parlement est simplement en vacances",
      "Une commune connaît une petite hausse de la délinquance",
    ],
    answer:
        "Les institutions de la République sont gravement menacées et le fonctionnement régulier des pouvoirs publics est interrompu",
    explanation:
        "L’article 16 vise une situation de crise extrême combinant menace grave et interruption du fonctionnement régulier des pouvoirs publics.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Régime juridique — Article 16",
    question:
        "Avant de recourir à l’article 16, le Président de la République doit :",
    options: [
      "Organiser un référendum local",
      "Consulter plusieurs autorités (Premier ministre, présidents des Assemblées, Conseil constitutionnel)",
      "Obtenir l’accord du maire de Paris",
    ],
    answer:
        "Consulter plusieurs autorités (Premier ministre, présidents des Assemblées, Conseil constitutionnel)",
    explanation:
        "La fiche rappelle cette consultation préalable avant la mise en œuvre des pouvoirs exceptionnels de l’article 16.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Régime juridique — État d’urgence",
    question: "L’état d’urgence (loi de 1955) est principalement destiné à :",
    options: [
      "Gérer les élections municipales",
      "Faire face à un péril imminent résultant d’atteintes graves à l’ordre public ou de calamités publiques",
      "Limiter les dépenses publiques",
    ],
    answer:
        "Faire face à un péril imminent résultant d’atteintes graves à l’ordre public ou de calamités publiques",
    explanation:
        "Le cours définit l’état d’urgence comme un régime permettant de répondre à un péril imminent, notamment en matière de sécurité.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Régime juridique — État d’urgence",
    question:
        "Parmi les mesures possibles sous état d’urgence, on trouve notamment :",
    options: [
      "L’assignation à résidence et les perquisitions administratives",
      "La dissolution automatique du Parlement",
      "La suppression de tous les recours juridictionnels",
    ],
    answer: "L’assignation à résidence et les perquisitions administratives",
    explanation:
        "La fiche mentionne l’assignation à résidence, les perquisitions administratives et les interdictions de réunions comme exemples de mesures d’état d’urgence.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Régime juridique — État d’urgence sanitaire",
    question: "L’état d’urgence sanitaire a été instauré principalement pour :",
    options: [
      "Lutter contre une catastrophe sanitaire comme la pandémie de Covid-19",
      "Régler un conflit du travail dans la fonction publique",
      "Organiser les élections présidentielles",
    ],
    answer:
        "Lutter contre une catastrophe sanitaire comme la pandémie de Covid-19",
    explanation:
        "Le texte précise que l’état d’urgence sanitaire a été créé pour faire face à un risque sanitaire majeur, notamment la Covid-19.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Régime juridique — Circumstances exceptionnelles",
    question:
        "La théorie des circonstances exceptionnelles permet au juge administratif :",
    options: [
      "De refuser tout contrôle en cas de crise",
      "D’admettre que l’administration dispose provisoirement de pouvoirs plus étendus en cas de guerre ou de trouble grave",
      "De légiférer à la place du Parlement",
    ],
    answer:
        "D’admettre que l’administration dispose provisoirement de pouvoirs plus étendus en cas de guerre ou de trouble grave",
    explanation:
        "La théorie permet au juge de tenir compte des circonstances anormales pour apprécier la légalité de mesures plus restrictives.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Régime juridique — Vigipirate",
    question: "Le plan Vigipirate est principalement :",
    options: [
      "Un véritable état d’exception prévu par la Constitution",
      "Un dispositif gouvernemental permanent de lutte contre la menace terroriste",
      "Un simple document interne à la Police nationale",
    ],
    answer:
        "Un dispositif gouvernemental permanent de lutte contre la menace terroriste",
    explanation:
        "La fiche décrit Vigipirate comme un dispositif permanent associant autorités civiles et militaires pour prévenir la menace terroriste.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Régime juridique — Vigipirate",
    question: "Quel niveau Vigipirate correspond à la menace la plus élevée ?",
    options: [
      "Niveau « vigilance »",
      "Niveau « sécurité renforcée – risque attentat »",
      "Niveau « urgence attentat »",
    ],
    answer: "Niveau « urgence attentat »",
    explanation:
        "Le cours indique que le niveau « urgence attentat » est déclenché après un attentat ou en cas de menace imminente liée à un groupe identifié.",
    difficulty: "Moyenne",
  ),

  // ===================== RÉGIME JURIDIQUE — NIVEAU DIFFICILE =====================
  const QuizQuestion(
    category: "Régime juridique — Régime répressif",
    question: "Dans le régime répressif, la liberté est :",
    options: [
      "L’exception, la censure étant la règle",
      "La règle, la sanction n’intervenant qu’en cas d’abus caractérisé",
      "Toujours soumise à autorisation préalable",
    ],
    answer: "La règle, la sanction n’intervenant qu’en cas d’abus caractérisé",
    explanation:
        "La fiche précise que le régime répressif est le plus favorable aux libertés : on agit librement, mais on est sanctionné en cas d’abus.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Régime répressif",
    question:
        "Dans un régime répressif, qui prononce la sanction en cas d’abus d’une liberté ?",
    options: [
      "Le juge, à l’issue d’une procédure contradictoire",
      "Le maire, sans contrôle",
      "Le ministre de l’Intérieur par simple circulaire",
    ],
    answer: "Le juge, à l’issue d’une procédure contradictoire",
    explanation:
        "Le texte indique que l’abus est sanctionné par le juge sur le fondement des textes pénaux ou administratifs.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Régime préventif",
    question: "Quelle formule résume le mieux le régime préventif ?",
    options: [
      "« Tout est interdit sauf ce qui est expressément autorisé »",
      "« Tout est autorisé sauf ce qui est expressément interdit »",
      "« Rien n’est ni autorisé ni interdit »",
    ],
    answer: "« Tout est interdit sauf ce qui est expressément autorisé »",
    explanation:
        "Le cours reprend cette formule : dans le régime préventif, n’est permis que ce qui est autorisé expressément ou tacitement.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Régime préventif",
    question: "Le régime préventif repose essentiellement sur :",
    options: [
      "L’action du pouvoir exécutif responsable de l’ordre public",
      "La seule initiative des citoyens",
      "Les décisions des juridictions pénales",
    ],
    answer: "L’action du pouvoir exécutif responsable de l’ordre public",
    explanation:
        "Le texte précise que le régime préventif est mis en œuvre par l’autorité administrative chargée de l’ordre public.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Autorisation préalable",
    question: "La technique de l’autorisation préalable implique que :",
    options: [
      "La liberté peut s’exercer sans formalité",
      "L’exercice de la liberté est subordonné à l’accord préalable de l’administration",
      "La liberté est définitivement supprimée",
    ],
    answer:
        "L’exercice de la liberté est subordonné à l’accord préalable de l’administration",
    explanation:
        "La fiche explique qu’en l’absence d’autorisation, la liberté ne peut être exercée légalement.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Autorisation préalable",
    question:
        "Parmi les exemples suivants, lequel relève de l’autorisation préalable ?",
    options: [
      "La déclaration d’une manifestation",
      "Le permis de construire",
      "Le dépôt d’un mémoire devant le juge",
    ],
    answer: "Le permis de construire",
    explanation:
        "Le cours cite le permis de construire comme exemple d’activité soumise à autorisation préalable.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Déclaration préalable",
    question: "Dans le régime de la déclaration préalable :",
    options: [
      "La liberté ne peut jamais s’exercer",
      "La liberté s’exerce, mais son titulaire doit informer préalablement l’autorité",
      "Seul le juge peut autoriser l’activité",
    ],
    answer:
        "La liberté s’exerce, mais son titulaire doit informer préalablement l’autorité",
    explanation:
        "La fiche décrit la déclaration préalable comme une information à l’administration qui peut ensuite encadrer l’activité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Déclaration préalable",
    question:
        "Parmi les exemples suivants, lequel illustre une déclaration préalable ?",
    options: [
      "Demander un permis de conduire",
      "Informer la préfecture de l’organisation d’une manifestation sur la voie publique",
      "Demander un passeport",
    ],
    answer:
        "Informer la préfecture de l’organisation d’une manifestation sur la voie publique",
    explanation:
        "Le cours cite la déclaration de manifestation comme exemple typique de déclaration préalable.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Interdiction préalable",
    question: "L’interdiction préalable est :",
    options: [
      "La technique la moins attentatoire aux libertés",
      "La technique la plus attentatoire aux libertés, qui doit rester un ultime recours",
      "Une mesure toujours licite, même générale et absolue",
    ],
    answer:
        "La technique la plus attentatoire aux libertés, qui doit rester un ultime recours",
    explanation:
        "Le texte présente l’interdiction préalable comme un outil extrême, strictement encadré par le juge.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Régime juridique — Interdiction préalable",
    question: "L’arrêt Benjamin (Conseil d’État, 1933) illustre que :",
    options: [
      "L’autorité de police peut toujours interdire un événement par précaution",
      "L’interdiction d’une manifestation n’est légale que s’il n’existe pas de mesures moins restrictives suffisantes pour assurer l’ordre public",
      "Le maire décide seul sans contrôle du juge",
    ],
    answer:
        "L’interdiction d’une manifestation n’est légale que s’il n’existe pas de mesures moins restrictives suffisantes pour assurer l’ordre public",
    explanation:
        "L’arrêt Benjamin consacre l’idée que l’interdiction totale est illégale quand des moyens moins radicaux (forces de l’ordre, encadrement) suffisent.",
    difficulty: "Difficile",
  ),

  // ===================== SOURCES DES LIBERTÉS — NIVEAU FACILE =====================
  const QuizQuestion(
    category: "Sources — Généralités",
    question: "Les libertés publiques actuelles en France résultent :",
    options: [
      "D’un seul texte adopté en 1958",
      "D’une construction historique longue mêlant textes philosophiques, déclarations, constitutions et conventions internationales",
      "Uniquement des coutumes locales",
    ],
    answer:
        "D’une construction historique longue mêlant textes philosophiques, déclarations, constitutions et conventions internationales",
    explanation:
        "L’introduction souligne la pluralité des sources et la longue histoire des libertés publiques.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Sources — Philosophiques",
    question:
        "La pensée chrétienne a contribué aux libertés publiques en affirmant :",
    options: [
      "La supériorité de certains peuples",
      "L’égalité fondamentale de tous les hommes et la valeur de la personne humaine",
      "La nécessité de supprimer la liberté religieuse",
    ],
    answer:
        "L’égalité fondamentale de tous les hommes et la valeur de la personne humaine",
    explanation:
        "Le cours présente la pensée chrétienne comme source de l’égalité et de la dignité humaines.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Sources — Philosophiques",
    question:
        "La théorie du droit naturel et du contrat social (Locke, Rousseau…) met en avant :",
    options: [
      "Des droits naturels, universels et inaliénables attachés à toute personne",
      "Le pouvoir absolu du souverain sans limite",
      "La supériorité de la force sur le droit",
    ],
    answer:
        "Des droits naturels, universels et inaliénables attachés à toute personne",
    explanation:
        "Le texte rappelle que ces courants fondent l’idée de droits antérieurs et supérieurs au pouvoir politique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Sources — Philosophiques",
    question:
        "La philosophie des Lumières, au XVIIIᵉ siècle, promeut notamment :",
    options: [
      "L’arbitraire du pouvoir royal",
      "La tolérance religieuse, la liberté d’expression et la séparation des pouvoirs",
      "La suppression des Parlements",
    ],
    answer:
        "La tolérance religieuse, la liberté d’expression et la séparation des pouvoirs",
    explanation:
        "La fiche insiste sur ces thèmes majeurs des Lumières qui inspireront la Déclaration de 1789.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Sources — Juridiques avant 1789",
    question:
        "Parmi les textes anglais suivants, lequel fait partie des « pactes » contribuant à la protection des libertés ?",
    options: [
      "La Grande Charte (Magna Carta)",
      "Le Code civil",
      "La Constitution de 1958",
    ],
    answer: "La Grande Charte (Magna Carta)",
    explanation:
        "La Magna Carta, le Habeas Corpus et le Bill of Rights sont cités comme sources juridiques préalables à 1789.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Sources — Juridiques avant 1789",
    question: "Les déclarations américaines de 1776 affirment notamment :",
    options: [
      "La supériorité du roi d’Angleterre",
      "L’égalité et des droits inaliénables (vie, liberté, bonheur)",
      "La suppression du Parlement",
    ],
    answer: "L’égalité et des droits inaliénables (vie, liberté, bonheur)",
    explanation:
        "La fiche souligne que ces déclarations annoncent les principes de la Déclaration française de 1789.",
    difficulty: "Facile",
  ),

  // ===================== SOURCES — NIVEAU MOYEN =====================
  const QuizQuestion(
    category: "Sources — Déclaration 1789",
    question: "Parmi les caractéristiques de la Déclaration de 1789 figure :",
    options: [
      "La reconnaissance explicite de droits collectifs (syndicats, associations)",
      "Un individualisme centré sur l’homme titulaire de droits",
      "Un rejet total de la notion de droit naturel",
    ],
    answer: "Un individualisme centré sur l’homme titulaire de droits",
    explanation:
        "Le texte présente la Déclaration comme individualiste : elle vise l’homme plutôt que les groupes.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Sources — Déclaration 1789",
    question: "La Déclaration de 1789 présente les droits proclamés comme :",
    options: [
      "Purement politiques et relatifs",
      "Naturels, inaliénables et sacrés",
      "Attribués seulement par le roi",
    ],
    answer: "Naturels, inaliénables et sacrés",
    explanation:
        "La dimension métaphysique du texte est rappelée : les droits sont antérieurs et supérieurs au pouvoir politique.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Sources — Déclaration 1789",
    question: "La Déclaration de 1789 a une portée :",
    options: [
      "Exclusivement française, sans vocation universelle",
      "Universelle, visant « tous les hommes » même si l’application pratique est limitée",
      "Uniquement locale (Paris et sa région)",
    ],
    answer:
        "Universelle, visant « tous les hommes » même si l’application pratique est limitée",
    explanation:
        "Le cours souligne l’universalité affirmée du texte, même si son application réelle est plus restreinte.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Sources — Déclaration 1789",
    question:
        "Parmi les droits de l’Homme proclamés en 1789, on trouve notamment :",
    options: [
      "La dignité, l’égalité, la liberté individuelle et la résistance à l’oppression",
      "Uniquement le droit au logement",
      "Uniquement la liberté d’entreprise",
    ],
    answer:
        "La dignité, l’égalité, la liberté individuelle et la résistance à l’oppression",
    explanation:
        "La fiche mentionne ces droits comme exemples de droits de l’Homme inspirant les libertés publiques.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Sources — Évolution postérieure",
    question: "La IIIᵉ République a consacré par diverses lois :",
    options: [
      "La suppression de la liberté d’association",
      "La liberté de réunion, de presse et d’association",
      "Le retour à la monarchie absolue",
    ],
    answer: "La liberté de réunion, de presse et d’association",
    explanation:
        "Le cours indique que la IIIᵉ République est marquée par de grandes lois libérales.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Sources — Évolution postérieure",
    question: "Le préambule de 1946 ajoute notamment :",
    options: [
      "Des droits économiques et sociaux (travail, grève, protection de la famille…) ",
      "Uniquement des devoirs envers l’État",
      "La suppression de toute liberté religieuse",
    ],
    answer:
        "Des droits économiques et sociaux (travail, grève, protection de la famille…) ",
    explanation:
        "La fiche rappelle que le préambule de 1946 enrichit le catalogue par des droits sociaux toujours en vigueur.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Sources — Préambule 1958",
    question: "Le préambule de la Constitution de 1958 renvoie expressément :",
    options: [
      "Uniquement à la Déclaration universelle de 1948",
      "À la Déclaration de 1789, au préambule de 1946 et à la Charte de l’environnement de 2004",
      "Seulement au Code pénal",
    ],
    answer:
        "À la Déclaration de 1789, au préambule de 1946 et à la Charte de l’environnement de 2004",
    explanation:
        "Ces textes, avec la Constitution, forment le bloc de constitutionnalité en matière de libertés.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Sources — Préambule 1958",
    question:
        "Les lois telles que « Informatique et libertés » (1978) ou le droit d’accès aux documents administratifs (1979) :",
    options: [
      "N’ont aucun lien avec les libertés publiques",
      "Complètent le bloc constitutionnel en créant de nouveaux droits ou en précisant leur protection",
      "Suppriment les droits fondamentaux",
    ],
    answer:
        "Complètent le bloc constitutionnel en créant de nouveaux droits ou en précisant leur protection",
    explanation:
        "La fiche les cite comme exemples de lois importantes en matière de libertés.",
    difficulty: "Moyenne",
  ),

  // ===================== SOURCES INTERNATIONALES — NIVEAU MOYEN/DÉLICAT =====================
  const QuizQuestion(
    category: "Sources — Droit international humanitaire",
    question: "Les conventions de Genève de 1949 visent principalement à :",
    options: [
      "Réglementer la fiscalité des États",
      "Protéger les blessés, prisonniers de guerre et civils en temps de conflit armé",
      "Organiser la vie politique interne des États",
    ],
    answer:
        "Protéger les blessés, prisonniers de guerre et civils en temps de conflit armé",
    explanation:
        "Le cours cite ces conventions comme source de protection des personnes en temps de guerre.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Sources — ONU",
    question:
        "La Déclaration universelle des droits de l’Homme (ONU, 1948) a principalement :",
    options: [
      "Une valeur politique forte et inspire des traités contraignants",
      "La même valeur juridique qu’une loi municipale",
      "Un rôle exclusivement historique sans effet contemporain",
    ],
    answer: "Une valeur politique forte et inspire des traités contraignants",
    explanation:
        "La fiche rappelle qu’elle n’est pas directement contraignante mais a inspiré de nombreuses conventions obligatoires.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Sources — ONU",
    question:
        "Parmi les conventions suivantes, laquelle relève du système onusien de protection des droits fondamentaux ?",
    options: [
      "Convention contre la torture (1984)",
      "Traité de Maastricht",
      "Code de la route",
    ],
    answer: "Convention contre la torture (1984)",
    explanation:
        "Le cours cite la convention contre la torture parmi les grands instruments internationaux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Sources — CEDH",
    question:
        "La Convention européenne des droits de l’Homme (CEDH) a été ratifiée par la France en :",
    options: ["1789", "1958", "1974"],
    answer: "1974",
    explanation:
        "Le texte indique que la France a ratifié la CEDH en 1974, permettant une protection conventionnelle renforcée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Sources — CEDH",
    question: "Une originalité majeure de la CEDH est de permettre :",
    options: [
      "À chaque citoyen de saisir la Cour européenne des droits de l’Homme après épuisement des recours internes",
      "Uniquement aux États de se plaindre entre eux",
      "Aux maires de saisir la Cour pour des litiges locaux",
    ],
    answer:
        "À chaque citoyen de saisir la Cour européenne des droits de l’Homme après épuisement des recours internes",
    explanation:
        "Le cours insiste sur ce mécanisme de recours individuel, très important pour la protection concrète des libertés.",
    difficulty: "Moyenne",
  ),

  // ===================== HIÉRARCHIE DES NORMES — NIVEAU DIFFICILE/Difficile =====================
  const QuizQuestion(
    category: "Hiérarchie des normes",
    question:
        "Selon la fiche, au sommet de la hiérarchie des normes en matière de libertés publiques se trouvent :",
    options: [
      "Les règlements municipaux",
      "La Constitution et les textes à valeur constitutionnelle",
      "Les circulaires ministérielles",
    ],
    answer: "La Constitution et les textes à valeur constitutionnelle",
    explanation:
        "La fiche place au sommet Constitution, Déclaration de 1789, préambule de 1946, Charte de l’environnement et PFRLR.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Hiérarchie des normes",
    question:
        "Dans cette hiérarchie, les engagements internationaux (CEDH, conventions ONU…) :",
    options: [
      "Sont inférieurs à la Constitution mais supérieurs aux lois",
      "Sont inférieurs aux règlements municipaux",
      "N’ont aucune valeur en droit interne",
    ],
    answer: "Sont inférieurs à la Constitution mais supérieurs aux lois",
    explanation:
        "Le cours les place au second niveau, au-dessus des lois ordinaires.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Hiérarchie des normes",
    question: "Un règlement de police administrative doit être conforme :",
    options: [
      "Uniquement à la volonté du maire",
      "À la loi et aux normes supérieures (Constitution, conventions internationales)",
      "Aux usages locaux uniquement",
    ],
    answer:
        "À la loi et aux normes supérieures (Constitution, conventions internationales)",
    explanation:
        "Le rappel final insiste sur le contrôle de conformité d’une mesure de police à l’ensemble de la hiérarchie des normes.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Hiérarchie des normes",
    question:
        "Si une loi portant atteinte aux libertés publiques est suspectée de méconnaître la Constitution, les justiciables peuvent :",
    options: [
      "Saisir le Conseil constitutionnel par la voie de la QPC",
      "S’adresser uniquement au maire",
      "Saisir directement le Président de la République",
    ],
    answer: "Saisir le Conseil constitutionnel par la voie de la QPC",
    explanation:
        "La fiche évoque la QPC comme mécanisme permettant de contrôler la constitutionnalité d’une loi déjà en vigueur.",
    difficulty: "Difficile",
  ),

  // ===================== NOTION DE LIBERTÉS PUBLIQUES — NIVEAU FACILE =====================
  const QuizQuestion(
    category: "Notion — Généralités",
    question: "Dans le langage courant, on confond souvent :",
    options: [
      "Droits de l’Homme et libertés publiques",
      "Fiscalité et procédure pénale",
      "Droit civil et droit routier",
    ],
    answer: "Droits de l’Homme et libertés publiques",
    explanation:
        "La fiche commence par constater cette confusion fréquente en langage courant.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Notion — Généralités",
    question: "En droit, les libertés publiques sont définies comme :",
    options: [
      "Une catégorie de droits fondamentaux reconnus et organisés par l’État",
      "De simples habitudes sociales",
      "Des privilèges réservés aux fonctionnaires",
    ],
    answer:
        "Une catégorie de droits fondamentaux reconnus et organisés par l’État",
    explanation:
        "La fiche en donne précisément cette définition pour distinguer libertés publiques et droits de l’Homme en général.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Notion — Libertés publiques et droits de l’Homme",
    question:
        "Parmi les trois idées issues du polycopié, la première est que les libertés publiques sont :",
    options: [
      "Des droits dont on n’attend rien de l’État",
      "Des droits « attendus » de l’État, qui doit mettre en place les moyens concrets de leur exercice",
      "Des droits purement théoriques sans application",
    ],
    answer:
        "Des droits « attendus » de l’État, qui doit mettre en place les moyens concrets de leur exercice",
    explanation:
        "Le cours explique que les citoyens attendent de l’État non seulement une abstention, mais aussi une action positive.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Notion — Libertés publiques et droits de l’Homme",
    question: "La deuxième idée est que les libertés publiques sont :",
    options: [
      "Des droits consacrés par un texte juridique (constitutionnel, législatif, réglementaire…)",
      "Des coutumes sociales sans trace écrite",
      "Des traditions locales uniquement",
    ],
    answer:
        "Des droits consacrés par un texte juridique (constitutionnel, législatif, réglementaire…)",
    explanation:
        "La fiche insiste sur la nécessité d’une consécration par un texte pour qu’une liberté soit « publique ». ",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Notion — Libertés publiques et droits de l’Homme",
    question:
        "La troisième idée est que certaines libertés, dites « fondamentales », :",
    options: [
      "Ne bénéficient d’aucune protection particulière",
      "Profitent d’un régime juridique plus favorable (contrôle du juge, procédures d’urgence, valeur constitutionnelle…)",
      "Sont abandonnées à l’arbitrage des autorités de police",
    ],
    answer:
        "Profitent d’un régime juridique plus favorable (contrôle du juge, procédures d’urgence, valeur constitutionnelle…)",
    explanation:
        "Le texte précise que ces libertés fondamentales bénéficient de protections renforcées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Notion — Liberté",
    question: "Le polycopié définit la liberté comme :",
    options: [
      "La possibilité de ne jamais respecter la loi",
      "Le pouvoir d’autodétermination, c’est-à-dire la capacité de choisir son comportement personnel",
      "La simple absence de sanctions pénales",
    ],
    answer:
        "Le pouvoir d’autodétermination, c’est-à-dire la capacité de choisir son comportement personnel",
    explanation:
        "C’est la définition large rappelée au début du chapitre 2 de la fiche « Notion ».",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Notion — Libertés publiques",
    question:
        "Le qualificatif « publiques » dans l’expression « libertés publiques » renvoie principalement :",
    options: [
      "À la publicité des décisions",
      "À l’intervention de l’État qui reconnaît, encadre et protège ces libertés",
      "À la nécessité d’exercer la liberté sur la voie publique",
    ],
    answer:
        "À l’intervention de l’État qui reconnaît, encadre et protège ces libertés",
    explanation:
        "La fiche explique que « publiques » souligne le rôle de l’État dans la reconnaissance et la protection des libertés.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Notion — Libertés publiques",
    question:
        "Selon la définition juridique donnée, une liberté publique est notamment :",
    options: [
      "Une liberté fondamentale reconnue par l’État, consacrée par un texte, dont l’exercice est organisé et les atteintes sanctionnées",
      "Une liberté laissée à la discrétion des maires",
      "Une simple opinion morale sans portée juridique",
    ],
    answer:
        "Une liberté fondamentale reconnue par l’État, consacrée par un texte, dont l’exercice est organisé et les atteintes sanctionnées",
    explanation:
        "C’est la définition précise fournie dans la fiche avec l’idée de texte, d’organisation et de sanction des atteintes.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Notion — Pratique policière",
    question: "La fiche rappelle que sont des libertés publiques celles qui :",
    options: [
      "Intéressent les rapports entre particuliers uniquement",
      "Intéressent les rapports entre particuliers et autorités publiques et que l’État a choisi de consacrer, d’organiser et de protéger",
      "Ne concernent jamais l’action de la police",
    ],
    answer:
        "Intéressent les rapports entre particuliers et autorités publiques et que l’État a choisi de consacrer, d’organiser et de protéger",
    explanation:
        "Ce critère permet de cibler les libertés au cœur de l’action policière et du contrôle du juge.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Notion — Pratique policière",
    question:
        "Lorsque le policier intervient dans le domaine des libertés publiques (manifestation, contrôle d’identité, perquisition…), la légalité de son action :",
    options: [
      "Ne sera quasiment jamais contrôlée",
      "Sera particulièrement contrôlée par le juge, notamment au regard de la proportionnalité",
      "Dépend exclusivement de l’avis de sa hiérarchie",
    ],
    answer:
        "Sera particulièrement contrôlée par le juge, notamment au regard de la proportionnalité",
    explanation:
        "La fiche insiste sur le contrôle accru du juge dès lors que des droits fondamentaux sont en jeu.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Valeur juridique",
    question:
        "Aujourd’hui, la Déclaration des droits de l’homme et du citoyen de 1789 :",
    options: [
      "N’a plus aucune valeur juridique",
      "Figure dans le Préambule de la Constitution de 1958 et a valeur constitutionnelle",
      "Est seulement un texte symbolique d’histoire",
    ],
    answer:
        "Figure dans le Préambule de la Constitution de 1958 et a valeur constitutionnelle",
    explanation:
        "La D.D.H.C. figure dans le Préambule de la Constitution de 1958 et fait partie du bloc de constitutionnalité.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Bloc de constitutionnalité",
    question: "La D.D.H.C. fait partie :",
    options: [
      "Uniquement du Code civil",
      "Du « bloc de constitutionnalité »",
      "Du règlement intérieur de l’Assemblée nationale",
    ],
    answer: "Du « bloc de constitutionnalité »",
    explanation:
        "Le cours précise que la D.D.H.C. appartient au « bloc de constitutionnalité » avec le Préambule de 1946, la Constitution de 1958 et la Charte de l’environnement.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Principes généraux",
    question:
        "L’article 1er de la D.D.H.C. proclame notamment que les hommes :",
    options: [
      "Naissent et demeurent libres et égaux en droits",
      "Naissent tous avec les mêmes revenus",
      "Naissent et demeurent soumis à l’État",
    ],
    answer: "Naissent et demeurent libres et égaux en droits",
    explanation:
        "L’article 1er pose le principe d’égalité et de liberté et interdit les privilèges de naissance.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Droits naturels",
    question:
        "Selon l’article 2 de la D.D.H.C., parmi les droits naturels et imprescriptibles de l’homme figurent notamment :",
    options: [
      "La liberté, la propriété, la sûreté et la résistance à l’oppression",
      "Le droit au travail garanti et au logement",
      "Le droit à la gratuité des transports",
    ],
    answer:
        "La liberté, la propriété, la sûreté et la résistance à l’oppression",
    explanation:
        "L’article 2 énumère les droits naturels et imprescriptibles : liberté, propriété, sûreté, résistance à l’oppression.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Souveraineté",
    question:
        "L’article 3 de la D.D.H.C. affirme que le principe de toute souveraineté réside essentiellement dans :",
    options: ["Le Gouvernement", "Le Président de la République", "La Nation"],
    answer: "La Nation",
    explanation:
        "L’article 3 consacre le principe de souveraineté nationale en indiquant que la souveraineté réside dans la Nation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Loi et volonté générale",
    question: "Selon l’article 6 de la D.D.H.C., la loi est avant tout :",
    options: [
      "L’expression de la volonté générale",
      "L’expression de la volonté du Gouvernement",
      "L’expression de la volonté du juge",
    ],
    answer: "L’expression de la volonté générale",
    explanation:
        "L’article 6 pose que la loi est l’expression de la volonté générale et qu’elle doit être la même pour tous.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Séparation des pouvoirs",
    question:
        "L’article 16 de la D.D.H.C. affirme qu’une société sans séparation des pouvoirs :",
    options: [
      "Est en état de guerre",
      "N’a point de Constitution",
      "Est automatiquement démocratique",
    ],
    answer: "N’a point de Constitution",
    explanation:
        "L’article 16 précise qu’une société sans garantie des droits ni séparation des pouvoirs « n’a point de Constitution ». ",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Liberté d’opinion",
    question: "L’article 10 de la D.D.H.C. protège principalement :",
    options: [
      "La liberté d’opinion, notamment religieuse",
      "Le droit de grève",
      "Le droit de vote uniquement",
    ],
    answer: "La liberté d’opinion, notamment religieuse",
    explanation:
        "L’article 10 garantit que nul ne doit être inquiété pour ses opinions, même religieuses, tant que leur manifestation ne trouble pas l’ordre public.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Liberté d’expression",
    question:
        "L’article 11 de la D.D.H.C. qualifie la libre communication des pensées et des opinions de :",
    options: [
      "Droit secondaire",
      "Droit facultatif",
      "Un des droits les plus précieux de l’homme",
    ],
    answer: "Un des droits les plus précieux de l’homme",
    explanation:
        "L’article 11 présente la libre communication des pensées et des opinions comme l’un des droits les plus précieux de l’homme.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Notion — Libertés publiques",
    question: "En droit, les libertés publiques sont avant tout :",
    options: [
      "Une catégorie de droits fondamentaux reconnus et organisés par l’État",
      "Des simples valeurs morales sans texte",
      "Des privilèges accordés à certaines professions",
    ],
    answer:
        "Une catégorie de droits fondamentaux reconnus et organisés par l’État",
    explanation:
        "La fiche précise que les libertés publiques sont une catégorie de droits fondamentaux reconnus, organisés et protégés par l’État.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU MOYEN =====================
  const QuizQuestion(
    category: "D.D.H.C. — Contexte historique",
    question: "La D.D.H.C. s’inspire principalement :",
    options: [
      "Du Code Napoléon et de la IIIe République",
      "Des Lumières et des déclarations américaines d’indépendance",
      "Uniquement de la doctrine socialiste du XIXe siècle",
    ],
    answer: "Des Lumières et des déclarations américaines d’indépendance",
    explanation:
        "Le texte mentionne les influence des philosophes des Lumières (Montesquieu, Rousseau, Voltaire) et des déclarations américaines.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Finalité",
    question:
        "Selon son préambule, une des finalités de la D.D.H.C. est notamment de permettre :",
    options: [
      "De limiter les droits des citoyens au profit du Gouvernement",
      "De comparer à chaque instant les actes du pouvoir avec le but de toute institution politique",
      "De supprimer les Constitutions antérieures",
    ],
    answer:
        "De comparer à chaque instant les actes du pouvoir avec le but de toute institution politique",
    explanation:
        "La finalité indiquée est de rappeler les droits afin que les actes du pouvoir puissent être constamment comparés avec le but de toute institution politique.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Portée",
    question:
        "La D.D.H.C., bien que rédigée en France, est présentée dans le cours comme :",
    options: [
      "Un texte strictement réservé aux citoyens français",
      "Un texte à portée universelle visant tous les êtres humains",
      "Un texte exclusivement applicable aux fonctionnaires",
    ],
    answer: "Un texte à portée universelle visant tous les êtres humains",
    explanation:
        "La fiche souligne la portée universelle du texte, même s’il est adopté en France.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Décision Liberté d’association",
    question:
        "La reconnaissance explicite de la valeur constitutionnelle de la D.D.H.C. par le Conseil constitutionnel date :",
    options: [
      "De la décision « Liberté d’association » de 1971",
      "De la décision « Blocage des routes » de 1982",
      "De la Constitution de 1875",
    ],
    answer: "De la décision « Liberté d’association » de 1971",
    explanation:
        "Depuis la décision « Liberté d’association » de 1971, le Conseil constitutionnel reconnaît la valeur constitutionnelle de la D.D.H.C.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Liberté (art. 4)",
    question:
        "Selon l’article 4 de la D.D.H.C., la liberté consiste principalement à :",
    options: [
      "Pouvoir faire tout ce qui ne nuit pas à autrui",
      "Pouvoir faire tout ce qui est autorisé par son supérieur hiérarchique",
      "Pouvoir ne jamais respecter la loi",
    ],
    answer: "Pouvoir faire tout ce qui ne nuit pas à autrui",
    explanation:
        "L’article 4 définit la liberté comme la possibilité de faire tout ce qui ne nuit pas à autrui, sous le contrôle de la loi.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Sûreté",
    question: "Les articles 7 à 9 de la D.D.H.C. concernent principalement :",
    options: [
      "La liberté de réunion",
      "La sûreté et la protection contre les arrestations arbitraires",
      "La liberté de la presse uniquement",
    ],
    answer: "La sûreté et la protection contre les arrestations arbitraires",
    explanation:
        "Les articles 7 à 9 encadrent la sûreté, l’interdiction des arrestations arbitraires et la présomption d’innocence.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Propriété",
    question: "L’article 17 de la D.D.H.C. qualifie la propriété de :",
    options: [
      "Droit inviolable et sacré",
      "Droit secondaire et facultatif",
      "Privilège réservé aux propriétaires fonciers",
    ],
    answer: "Droit inviolable et sacré",
    explanation:
        "L’article 17 affirme que la propriété est un droit inviolable et sacré, dont on ne peut être privé que pour cause d’utilité publique et avec indemnité.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Garanties pénales",
    question:
        "Le principe de légalité des délits et des peines (art. 8) signifie que :",
    options: [
      "Le juge peut créer librement de nouvelles infractions",
      "Nul ne peut être puni qu’en vertu d’une loi établie et promulguée antérieurement au délit",
      "La loi peut toujours être appliquée rétroactivement au profit de la répression",
    ],
    answer:
        "Nul ne peut être puni qu’en vertu d’une loi établie et promulguée antérieurement au délit",
    explanation:
        "L’article 8 consacre le principe de légalité pénale et prohibe les incriminations et peines rétroactives.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Libertés publiques — Attentes vis-à-vis de l’État",
    question:
        "Selon le cours, concernant les libertés publiques, les individus attendent de l’État :",
    options: [
      "Uniquement qu’il s’abstienne d’agir",
      "Qu’il mette en place des moyens concrets permettant d’exercer les droits",
      "Qu’il supprime toute réglementation",
    ],
    answer:
        "Qu’il mette en place des moyens concrets permettant d’exercer les droits",
    explanation:
        "La première idée du cours est que les individus attendent de l’État une action positive, par exemple l’organisation de l’enseignement.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Libertés publiques — Reconnaissance par l’État",
    question:
        "Une caractéristique essentielle d’une liberté publique est qu’elle :",
    options: [
      "Résulte uniquement de la coutume sociale",
      "N’est jamais écrite dans un texte",
      "Est consacrée par un texte juridique (constitutionnel, législatif, etc.)",
    ],
    answer:
        "Est consacrée par un texte juridique (constitutionnel, législatif, etc.)",
    explanation:
        "La deuxième idée du cours souligne que les libertés publiques sont des droits de l’Homme intégrés dans le droit positif et reconnus par des textes.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Libertés publiques — Protection particulière",
    question: "Certaines libertés, dites « fondamentales », bénéficient :",
    options: [
      "D’une absence totale de contrôle du juge",
      "D’un régime juridique plus favorable (procédures d’urgence, contrôle renforcé)",
      "Un statut purement symbolique sans recours",
    ],
    answer:
        "D’un régime juridique plus favorable (procédures d’urgence, contrôle renforcé)",
    explanation:
        "Le cours insiste sur les protections particulières accordées aux libertés fondamentales (contrôle du juge administratif, procédures d’urgence, valeur constitutionnelle…).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Liberté — Autodétermination",
    question:
        "La liberté, au sens large, est définie dans le polycopié comme :",
    options: [
      "Le pouvoir d’autodétermination, c’est-à-dire la capacité de choisir son comportement",
      "Le pouvoir de ne jamais obéir aux lois",
      "La simple absence de contraintes physiques",
    ],
    answer:
        "Le pouvoir d’autodétermination, c’est-à-dire la capacité de choisir son comportement",
    explanation:
        "Le cours définit la liberté comme pouvoir d’autodétermination de l’individu, même si cette définition reste incomplète si l’on oublie le rôle de l’État.",
    difficulty: "Moyenne",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  const QuizQuestion(
    category: "D.D.H.C. — Contrôle de la loi",
    question:
        "Le fait que la D.D.H.C. fasse partie du bloc de constitutionnalité permet notamment :",
    options: [
      "Au juge de censurer une loi contraire aux droits qu’elle proclame",
      "Au Gouvernement de modifier la D.D.H.C. par décret simple",
      "Au Parlement de s’en affranchir par une loi ordinaire",
    ],
    answer: "Au juge de censurer une loi contraire aux droits qu’elle proclame",
    explanation:
        "Parce qu’elle a valeur constitutionnelle, la D.D.H.C. permet au Conseil constitutionnel de censurer les lois incompatibles.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Juge et libertés",
    question: "Pour un policier, la D.D.H.C. encadre son action car :",
    options: [
      "Elle ne concerne que le Parlement",
      "Elle s’impose à toutes les autorités (Parlement, Gouvernement, administration, juges…) et donc à la police",
      "Elle ne s’applique qu’aux juges constitutionnels",
    ],
    answer:
        "Elle s’impose à toutes les autorités (Parlement, Gouvernement, administration, juges…) et donc à la police",
    explanation:
        "Le texte indique que la D.D.H.C. s’impose à toutes les autorités, y compris l’administration et la police.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Principe d’égalité",
    question:
        "Le principe d’égalité dégagé de l’article 1er de la D.D.H.C. est souvent invoqué :",
    options: [
      "Pour justifier toutes les discriminations",
      "Pour contester des différences de traitement injustifiées entre catégories de personnes",
      "Uniquement dans les litiges fiscaux",
    ],
    answer:
        "Pour contester des différences de traitement injustifiées entre catégories de personnes",
    explanation:
        "La fiche donne l’exemple de différences de traitement entre fonctionnaires, étrangers, détenus… au regard du principe d’égalité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Séparation des pouvoirs",
    question: "L’article 16 de la D.D.H.C. sert notamment de fondement :",
    options: [
      "À la notion de monopole du Parlement",
      "Au contrôle de la séparation des pouvoirs et au droit à un procès équitable",
      "Au principe de gratuité de l’enseignement supérieur",
    ],
    answer:
        "Au contrôle de la séparation des pouvoirs et au droit à un procès équitable",
    explanation:
        "L’article 16 est utilisé pour exiger des garanties effectives, notamment l’indépendance du juge et un recours effectif.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Nécessité et proportionnalité des peines",
    question:
        "Le principe de nécessité et de proportionnalité des peines, issu de l’article 8 de la D.D.H.C., implique que :",
    options: [
      "La loi peut prévoir des peines illimitées si le juge est d’accord",
      "La loi ne doit établir que des peines strictement et évidemment nécessaires",
      "Seul le Gouvernement fixe librement le niveau des peines",
    ],
    answer:
        "La loi ne doit établir que des peines strictement et évidemment nécessaires",
    explanation:
        "L’article 8 impose que les peines prévues par la loi soient strictement et évidemment nécessaires.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Présomption d’innocence",
    question:
        "Selon l’article 9 de la D.D.H.C., la rigueur des mesures privatives de liberté :",
    options: [
      "Peut excéder ce qui est nécessaire pour faire un exemple",
      "Ne doit pas excéder ce qui est nécessaire",
      "N’est pas encadrée par le texte",
    ],
    answer: "Ne doit pas excéder ce qui est nécessaire",
    explanation:
        "L’article 9 impose que la rigueur liée à la privation de liberté reste limitée à ce qui est nécessaire, en lien avec la présomption d’innocence.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Libertés publiques — Définition",
    question:
        "La définition juridique des libertés publiques insiste sur le fait qu’elles sont :",
    options: [
      "Des convenances sociales non écrites",
      "Des libertés fondamentales reconnues par l’État, consacrées par un texte, organisées et protégées",
      "Des coutumes internationales sans valeur interne",
    ],
    answer:
        "Des libertés fondamentales reconnues par l’État, consacrées par un texte, organisées et protégées",
    explanation:
        "La fiche donne une définition précise : libertés fondamentales reconnues par l’État, consacrées par un texte, dont l’exercice est encadré et les atteintes sanctionnées.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Libertés publiques — Reconnaissance par un texte",
    question:
        "Pourquoi une liberté n’est-elle « publique » que si elle est reconnue par un texte ?",
    options: [
      "Parce que seules les libertés écrites sur Internet existent",
      "Parce que le droit objectif organise les rapports entre l’État et les individus autour de cette liberté",
      "Parce que la coutume est toujours illégale",
    ],
    answer:
        "Parce que le droit objectif organise les rapports entre l’État et les individus autour de cette liberté",
    explanation:
        "Le cours insiste sur le rôle des textes (constitution, loi, conventions) qui intègrent les droits de l’Homme dans le droit positif.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Libertés publiques — Rôle du juge",
    question:
        "En cas d’atteinte illégale à une liberté publique, le rôle du juge est :",
    options: [
      "Inexistant, car l’administration a toujours raison",
      "De pouvoir censurer la restriction et sanctionner l’administration",
      "De simplement donner un avis consultatif",
    ],
    answer:
        "De pouvoir censurer la restriction et sanctionner l’administration",
    explanation:
        "La sanction des atteintes par le juge garantit concrètement l’effectivité des libertés publiques.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Police — Atteinte aux libertés",
    question:
        "Selon la fiche, pour les mesures de police (contrôles, fouilles, gardes à vue…), le principe de base est que :",
    options: [
      "Aucune liberté n’est concernée",
      "Toute mesure de police porte atteinte à une liberté et doit être justifiée",
      "La police agit toujours sans limite juridique",
    ],
    answer:
        "Toute mesure de police porte atteinte à une liberté et doit être justifiée",
    explanation:
        "Le cours rappelle que toute mesure de police constitue une atteinte à une liberté et doit respecter les principes de nécessité, proportionnalité, égalité, sûreté…",
    difficulty: "Difficile",
  ),

  // ===================== NIVEAU Difficile =====================
  const QuizQuestion(
    category: "Articulation D.D.H.C. / Libertés publiques",
    question:
        "En pratique, le lien entre D.D.H.C. et libertés publiques peut être résumé ainsi :",
    options: [
      "Les libertés publiques ignorent totalement la D.D.H.C.",
      "Les libertés publiques prolongent les principes de la D.D.H.C. en les intégrant dans le droit positif et en prévoyant des garanties concrètes",
      "La D.D.H.C. ne concerne que le droit pénal et pas les libertés publiques",
    ],
    answer:
        "Les libertés publiques prolongent les principes de la D.D.H.C. en les intégrant dans le droit positif et en prévoyant des garanties concrètes",
    explanation:
        "La D.D.H.C. proclame des principes, tandis que la notion de libertés publiques désigne ces droits intégrés dans le droit positif et protégés par des mécanismes juridiques.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Libertés publiques — Dimension « publique »",
    question:
        "Le qualificatif « publiques » dans l’expression « libertés publiques » signifie principalement :",
    options: [
      "Que ces libertés ne concernent que les agents publics",
      "Qu’il existe nécessairement une intervention de l’État, qui reconnaît, encadre et protège ces libertés",
      "Que ces libertés ne s’exercent qu’en plein air",
    ],
    answer:
        "Qu’il existe nécessairement une intervention de l’État, qui reconnaît, encadre et protège ces libertés",
    explanation:
        "Le cours insiste sur la dualité : liberté individuelle + intervention de l’État via des normes juridiques.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Libertés publiques — Encadrement",
    question:
        "La réglementation de l’exercice d’une liberté publique par l’État :",
    options: [
      "Peut aller jusqu’à vider totalement la liberté de sa substance",
      "Ne doit jamais vider la liberté de sa substance, malgré les encadrements (déclarations, autorisations…)",
      "Est toujours contraire à la D.D.H.C.",
    ],
    answer:
        "Ne doit jamais vider la liberté de sa substance, malgré les encadrements (déclarations, autorisations…)",
    explanation:
        "La fiche précise que l’État peut organiser l’exercice des libertés, mais sans les priver de leur contenu essentiel.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Libertés publiques — Sélection des libertés",
    question:
        "Selon le cours, toutes les libertés n’entrent pas dans la catégorie des libertés publiques car :",
    options: [
      "La plupart des libertés sont purement économiques",
      "Sont des libertés publiques celles qui intéressent les rapports entre particuliers et autorités publiques et que l’État a choisi de consacrer et protéger",
      "Les libertés publiques ne concernent que les relations entre particuliers",
    ],
    answer:
        "Sont des libertés publiques celles qui intéressent les rapports entre particuliers et autorités publiques et que l’État a choisi de consacrer et protéger",
    explanation:
        "Le critère central est le rapport avec les autorités publiques et la consécration par l’État.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Police — Niveau de contrôle",
    question:
        "Lorsqu’un policier intervient dans un domaine touchant aux libertés publiques (manifestation, perquisition, contrôle d’identité…), la légalité de son action :",
    options: [
      "Est peu contrôlée car il s’agit d’ordre public",
      "Est particulièrement contrôlée par le juge au regard des droits fondamentaux",
      "Ne peut jamais être contestée devant un juge",
    ],
    answer:
        "Est particulièrement contrôlée par le juge au regard des droits fondamentaux",
    explanation:
        "La fiche souligne que le juge administratif ou judiciaire appréciera la compatibilité de l’acte de police avec la D.D.H.C. et les libertés publiques.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Contrôle concret",
    question:
        "Un exemple donné dans la fiche montre qu’une loi créant une nouvelle infraction vague et trop large peut être censurée :",
    options: [
      "Sur le fondement de l’article 8 (principe de légalité et de nécessité des peines)",
      "Uniquement sur la base d’une décision ministérielle",
      "Sur le fondement d’un simple usage administratif",
    ],
    answer:
        "Sur le fondement de l’article 8 (principe de légalité et de nécessité des peines)",
    explanation:
        "L’article 8 sert de base au contrôle des incriminations floues ou disproportionnées.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "D.D.H.C. — Sûreté et garde à vue",
    question:
        "Selon la fiche, des conditions de garde à vue trop longues ou insuffisamment encadrées peuvent être jugées contraires :",
    options: [
      "À l’article 9 de la D.D.H.C. sur la présomption d’innocence et la nécessité des mesures",
      "À l’article 17 sur la propriété",
      "À l’article 3 sur la souveraineté nationale",
    ],
    answer:
        "À l’article 9 de la D.D.H.C. sur la présomption d’innocence et la nécessité des mesures",
    explanation:
        "L’exemple donné relie directement les conditions de garde à vue à l’article 9 et à la nécessité des mesures privatives de liberté.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Synthèse — Intérêt pour le policier",
    question:
        "Connaître les grands articles de la D.D.H.C. et la notion de libertés publiques permet au policier :",
    options: [
      "Uniquement de réussir ses examens, sans impact sur le terrain",
      "De mieux comprendre le sens des libertés, d’appliquer la loi et d’anticiper les risques juridiques de ses interventions",
      "De se soustraire aux règles en invoquant la Constitution",
    ],
    answer:
        "De mieux comprendre le sens des libertés, d’appliquer la loi et d’anticiper les risques juridiques de ses interventions",
    explanation:
        "La fiche conclut en soulignant l’importance pratique de ces textes pour l’action quotidienne du policier.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Principes généraux",
    question:
        "La rétention dans les locaux de police constitue avant tout une atteinte à :",
    options: [
      "La liberté d’aller et venir",
      "La liberté d’expression",
      "La liberté de réunion",
    ],
    answer: "La liberté d’aller et venir",
    explanation:
        "La rétention limite la liberté d’aller et venir, qui est une composante de la liberté individuelle.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Principes généraux",
    question:
        "Parmi les administrations suivantes, lesquelles disposent du droit de retenir des individus ?",
    options: [
      "Police, gendarmerie, douanes, justice",
      "Police seulement",
      "Police, gendarmerie et mairie",
    ],
    answer: "Police, gendarmerie, douanes, justice",
    explanation:
        "Le texte précise que seules la police, la gendarmerie, les douanes et la justice disposent du droit de retenir des individus.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Principes généraux",
    question:
        "La rétention dans les locaux de police est légitime lorsqu’elle :",
    options: [
      "Permet de sanctionner immédiatement une personne",
      "Est justifiée par la protection d’une autre liberté ou d’un autre droit",
      "Est décidée par n’importe quel agent de police sans contrôle",
    ],
    answer:
        "Est justifiée par la protection d’une autre liberté ou d’un autre droit",
    explanation:
        "Le texte indique que la rétention est une limitation de la liberté d’aller et venir justifiée par une atteinte à une autre liberté ou à un autre droit.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Article 9 DDHC",
    question:
        "Selon l’article 9 de la Déclaration des droits de l’homme et du citoyen, la rigueur appliquée lors d’une arrestation doit être :",
    options: [
      "La plus sévère possible pour impressionner la personne",
      "Strictement nécessaire pour s’assurer de la personne",
      "Laissée à l’appréciation personnelle de l’agent",
    ],
    answer: "Strictement nécessaire pour s’assurer de la personne",
    explanation:
        "L’article 9 DDHC prévoit que toute rigueur qui ne serait pas strictement nécessaire pour s’assurer de la personne doit être sévèrement réprimée par la loi.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Principes généraux",
    question:
        "Lequel de ces éléments fait partie du formalisme entourant la rétention ?",
    options: [
      "Absence de trace écrite pour ne pas surcharger les procédures",
      "Contrôle par l’autorité judiciaire et limitation dans le temps",
      "Décision uniquement orale de l’agent de police",
    ],
    answer: "Contrôle par l’autorité judiciaire et limitation dans le temps",
    explanation:
        "Le texte insiste sur un formalisme, un contrôle par l’autorité judiciaire et des conditions de temps et de coercition nettement déterminées.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Typologie des mesures",
    question:
        "La rétention d’une personne dans les locaux de police peut être justifiée :",
    options: [
      "Uniquement par des mesures à caractère judiciaire",
      "Uniquement par des mesures à caractère administratif",
      "Par des mesures à caractère judiciaire ou administratif",
    ],
    answer: "Par des mesures à caractère judiciaire ou administratif",
    explanation:
        "Le texte distingue les mesures à caractère judiciaire et les mesures à caractère administratif.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue",
    question:
        "La durée initiale de la garde à vue décidée par un officier de police judiciaire est de :",
    options: ["12 heures", "24 heures", "48 heures"],
    answer: "24 heures",
    explanation:
        "La garde à vue est décidée pour une durée de 24 heures, renouvelable dans certaines conditions.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue",
    question:
        "Pour des faits de criminalité organisée ou de trafic de stupéfiants, la durée maximale de garde à vue peut atteindre :",
    options: ["48 heures", "72 heures", "96 heures"],
    answer: "96 heures",
    explanation:
        "Le texte mentionne une durée globale pouvant atteindre 96 heures pour ces infractions.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Garde à vue – Terrorisme",
    question:
        "Pour les infractions liées au terrorisme, la durée maximale de garde à vue peut aller jusqu’à :",
    options: ["72 heures", "96 heures", "144 heures"],
    answer: "144 heures",
    explanation:
        "Le texte indique qu’en matière de terrorisme, la durée peut atteindre 144 heures.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Mineurs 10–13 ans",
    question:
        "La retenue d’un mineur âgé de 10 à 13 ans peut durer initialement :",
    options: ["6 heures", "12 heures", "24 heures"],
    answer: "12 heures",
    explanation:
        "La retenue des mineurs de 10 à 13 ans est d’une durée de 12 heures, exceptionnellement renouvelable.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Mineurs 10–13 ans",
    question:
        "Pour retenir un mineur de 10 à 13 ans, il doit exister des raisons plausibles de présumer qu’il a commis :",
    options: [
      "Une simple contravention routière",
      "Un crime ou un délit puni d’au moins 5 ans de prison",
      "N’importe quelle infraction",
    ],
    answer: "Un crime ou un délit puni d’au moins 5 ans de prison",
    explanation:
        "La retenue de 10–13 ans est prévue lorsqu’il existe des raisons plausibles de penser que le mineur a commis un crime ou un délit puni d’au moins 5 ans d’emprisonnement.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vérification d’identité",
    question:
        "En cas de refus ou d’impossibilité de justifier son identité, la personne peut être conduite au commissariat :",
    options: [
      "Uniquement si elle a déjà un casier judiciaire",
      "En cas de nécessité, pour être présentée à l’O.P.J.",
      "Uniquement sur ordre écrit du procureur",
    ],
    answer: "En cas de nécessité, pour être présentée à l’O.P.J.",
    explanation:
        "L’article 78-3 CPP permet la conduite au commissariat en cas de nécessité pour vérification d’identité devant l’O.P.J.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vérification d’identité",
    question:
        "La durée maximale de rétention pour vérification d’identité (en métropole) est de :",
    options: ["2 heures", "4 heures", "8 heures"],
    answer: "4 heures",
    explanation:
        "La durée maximale est de 4 heures à compter du contrôle, portée à 8 heures à Mayotte.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Droit au séjour",
    question:
        "La retenue pour vérification du droit au séjour d’un étranger peut durer au maximum :",
    options: ["4 heures", "12 heures", "24 heures"],
    answer: "24 heures",
    explanation:
        "La retenue pour vérification du droit au séjour est d’une durée maximale de 24 heures.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Ivresse publique",
    question:
        "Pour une personne en état d’ivresse publique et manifeste placée en chambre de sûreté, la rétention est légale :",
    options: [
      "Pendant 24 heures fixes",
      "Jusqu’au complet dégrisement",
      "Uniquement jusqu’à 6 heures du matin",
    ],
    answer: "Jusqu’au complet dégrisement",
    explanation:
        "La règle est que la rétention dure jusqu’au complet dégrisement, sans durée chiffrée dans le texte.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vérification de situation – Terrorisme",
    question:
        "La retenue pour vérification de situation d’une personne suspectée d’activités terroristes ne peut excéder :",
    options: ["2 heures", "4 heures", "8 heures"],
    answer: "4 heures",
    explanation:
        "Le texte précise que cette retenue ne peut excéder 4 heures à compter du début du contrôle.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Typologie des mesures",
    question:
        "Dans la pratique, la distinction entre mesure judiciaire et mesure administrative peut être :",
    options: [
      "Parfaitement évidente dans tous les cas",
      "Parfois délicate, par exemple pour la vérification d’identité",
      "Réservée aux seuls magistrats",
    ],
    answer: "Parfois délicate, par exemple pour la vérification d’identité",
    explanation:
        "Le texte souligne que, pour certaines procédures comme la vérification d’identité, la frontière judiciaire/administrative est difficile à établir.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "But pédagogique",
    question:
        "La classification des cas de rétention en mesures judiciaires et administratives a avant tout :",
    options: [
      "Un intérêt purement théorique et pédagogique",
      "Une valeur constitutionnelle",
      "Pour but de fixer la rémunération des agents",
    ],
    answer: "Un intérêt purement théorique et pédagogique",
    explanation:
        "Le texte indique que cette classification est théorique et choisie pour faciliter l’apprentissage du thème.",
    difficulty: "Facile",
  ),

  // =========================================================
  // ================== NIVEAU INTERMÉDIAIRE =================
  // =========================================================
  const QuizQuestion(
    category: "Garde à vue – Mise en situation",
    question:
        "Vous placez un individu en garde à vue à 14h00 pour un délit de droit commun. Aucune prolongation n’est décidée. Au plus tard, l’intéressé doit être libéré ou présenté à un magistrat à :",
    options: ["02h00", "14h00 le lendemain", "20h00 le même jour"],
    answer: "14h00 le lendemain",
    explanation:
        "La durée initiale de garde à vue est de 24 heures à compter du début de la mesure, soit jusqu’à 14h00 le lendemain.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Mineurs 10–13 ans – Mise en situation",
    question:
        "Un enfant de 12 ans est suspecté d’un vol simple puni de 3 ans d’emprisonnement. Peut-il faire l’objet d’une retenue de 10–13 ans ?",
    options: [
      "Oui, car tout délit suffit",
      "Non, car la peine encourue est inférieure à 5 ans",
      "Oui, mais seulement pendant 6 heures",
    ],
    answer: "Non, car la peine encourue est inférieure à 5 ans",
    explanation:
        "La retenue 10–13 ans suppose un crime ou un délit puni d’au moins 5 ans de prison, ce qui n’est pas le cas ici.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification d’identité – Mise en situation",
    question:
        "Lors d’un contrôle, une personne refuse de donner son identité et tente de partir. Vous la conduisez au commissariat pour vérification d’identité à 18h00. Au plus tard, la rétention devra cesser à :",
    options: ["20h00", "22h00", "02h00"],
    answer: "22h00",
    explanation:
        "La durée maximale de rétention pour vérification d’identité est de 4 heures à compter du contrôle.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Mandat d’amener / d’arrêt",
    question:
        "La rétention d’une personne arrêtée en exécution d’un mandat d’amener ou d’arrêt doit durer :",
    options: [
      "Le temps strictement nécessaire à la notification du mandat et à l’avis au magistrat",
      "24 heures maximum",
      "48 heures maximum",
    ],
    answer:
        "Le temps strictement nécessaire à la notification du mandat et à l’avis au magistrat",
    explanation:
        "Le texte insiste sur le caractère strictement nécessaire de la rétention pour ce type de mandat.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Mandat de recherche",
    question:
        "Le mandat de recherche ordonne à la force publique de rechercher la personne visée et :",
    options: [
      "De la remettre immédiatement en liberté après audition",
      "De la placer en garde à vue",
      "De la conduire devant le maire",
    ],
    answer: "De la placer en garde à vue",
    explanation:
        "Le mandat de recherche prévoit la recherche de la personne et son placement en garde à vue.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Retenue judiciaire – Contrainte",
    question: "Une contrainte judiciaire vise principalement à :",
    options: [
      "Contrôler le respect des obligations du contrôle judiciaire",
      "Incarcérer une personne qui ne s’est pas acquittée d’une amende",
      "Vérifier l’identité d’un suspect",
    ],
    answer: "Incarcérer une personne qui ne s’est pas acquittée d’une amende",
    explanation:
        "La contrainte judiciaire est une mesure visant à incarcérer une personne n’ayant pas payé volontairement une amende liée à un délit puni d’emprisonnement.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Retenue judiciaire – Obligations",
    question:
        "La retenue pour vérification du respect des obligations judiciaires concerne :",
    options: [
      "Toute personne interpellée pour un délit routier",
      "Une personne condamnée ou placée sous contrôle judiciaire",
      "Uniquement les mineurs de moins de 16 ans",
    ],
    answer: "Une personne condamnée ou placée sous contrôle judiciaire",
    explanation:
        "Le texte vise les personnes condamnées ou sous contrôle judiciaire pour vérifier qu’elles respectent leurs obligations.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Droit au séjour – Mise en situation",
    question:
        "Vous retenez un étranger à 09h00 pour vérification de son droit au séjour. À 22h00, les vérifications sont toujours en cours. Quelle est la bonne conduite ?",
    options: [
      "Vous pouvez le retenir jusqu’au lendemain 09h00 sans formalité",
      "Vous devez veiller à ce que la rétention ne dépasse pas 24h et envisager une autre mesure ou la remise en liberté",
      "Vous pouvez automatiquement transformer la mesure en garde à vue",
    ],
    answer:
        "Vous devez veiller à ce que la rétention ne dépasse pas 24h et envisager une autre mesure ou la remise en liberté",
    explanation:
        "La retenue pour vérification du droit au séjour ne peut excéder 24 heures.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Ivresse – Mise en situation",
    question:
        "Un homme en état d’ivresse publique manifeste est placé en chambre de sûreté à 01h00. À 08h00, il parle clairement, marche sans difficulté et souhaite rentrer chez lui. Vous devez :",
    options: [
      "Le maintenir jusqu’à 24h car la mesure est automatique",
      "Le remettre en liberté si le dégrisement est constaté et les vérifications terminées",
      "Le placer d’office en garde à vue",
    ],
    answer:
        "Le remettre en liberté si le dégrisement est constaté et les vérifications terminées",
    explanation:
        "La rétention pour ivresse dure jusqu’au complet dégrisement, pas plus. Une fois dégrisé, il n’y a plus lieu de maintenir la mesure.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Malades mentaux – Mise en situation",
    question:
        "Une personne présentant des troubles mentaux graves est interpellée en pleine crise dans la rue. Elle est dangereuse pour elle-même. La rétention dans les locaux de police doit :",
    options: [
      "Pouvoir durer 24h pour la calmer",
      "Être exceptionnelle et conduire immédiatement à un transfert médical",
      "Être systématique en attendant une place disponible dans un hôpital",
    ],
    answer:
        "Être exceptionnelle et conduire immédiatement à un transfert médical",
    explanation:
        "Le recueil temporaire des malades mentaux est une mesure exceptionnelle qui doit immédiatement aboutir au transfert médical.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Mineurs en fugue – Mise en situation",
    question:
        "Un mineur de 15 ans en fugue est retrouvé à 23h00. Les parents ne sont joignables qu’à 06h00. La rétention au commissariat :",
    options: [
      "A pour but de permettre aux détenteurs de l’autorité parentale de le retrouver",
      "Est assimilée à une garde à vue",
      "Doit impérativement cesser à minuit",
    ],
    answer:
        "A pour but de permettre aux détenteurs de l’autorité parentale de le retrouver",
    explanation:
        "La garde des mineurs en fugue vise à permettre aux personnes en ayant la garde de retrouver leurs enfants, pour la durée strictement nécessaire.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Vérification de situation – Terrorisme",
    question:
        "Une personne contrôlée à 15h00 fait l’objet d’une retenue pour vérification de situation liée au terrorisme. À quelle heure au plus tard la mesure doit-elle prendre fin ?",
    options: ["17h00", "19h00", "23h00"],
    answer: "19h00",
    explanation:
        "La durée maximale est de 4 heures à compter du début du contrôle.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Principe de proportionnalité",
    question:
        "Quel principe doit guider l’usage de la coercition (menottage, fouille, immobilisation) lors d’une rétention ?",
    options: [
      "La commodité du service",
      "La proportionnalité et la stricte nécessité",
      "L’égalité stricte : même traitement pour tous",
    ],
    answer: "La proportionnalité et la stricte nécessité",
    explanation:
        "En application de l’article 9 DDHC et des principes généraux, la coercition doit rester strictement nécessaire et proportionnée.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Formalisme",
    question:
        "Pourquoi le formalisme (écrits, durée, notification des droits) est-il essentiel en matière de rétention ?",
    options: [
      "Pour faciliter uniquement les statistiques de service",
      "Parce qu’il conditionne la légalité de la mesure et permet un contrôle par l’autorité judiciaire",
      "Parce qu’il remplace le contrôle du parquet",
    ],
    answer:
        "Parce qu’il conditionne la légalité de la mesure et permet un contrôle par l’autorité judiciaire",
    explanation:
        "Le formalisme est la garantie de la légalité et de la traçabilité des atteintes à la liberté individuelle.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Choix du cadre",
    question:
        "Vous interpellez un individu soupçonné d’un délit grave puni d’emprisonnement. Vous hésitez entre une garde à vue et une simple vérification d’identité prolongée. Le bon réflexe est :",
    options: [
      "Utiliser une mesure administrative pour éviter les droits de la garde à vue",
      "Choisir la mesure qui correspond vraiment à la situation juridique, quitte à solliciter le parquet",
      "Toujours privilégier la vérification d’identité",
    ],
    answer:
        "Choisir la mesure qui correspond vraiment à la situation juridique, quitte à solliciter le parquet",
    explanation:
        "On ne doit pas utiliser une mesure administrative pour contourner la garde à vue. En cas de doute, on sollicite le parquet ou le supérieur hiérarchique.",
    difficulty: "Intermédiaire",
  ),

  const QuizQuestion(
    category: "Contrôle de durée",
    question:
        "Qui est responsable, sur le terrain, du respect des durées maximales de rétention dans les locaux de police ?",
    options: [
      "Uniquement le magistrat",
      "L’agent qui surveille les geôles",
      "L’ensemble de la chaîne : agent, gradé, OPJ, sous le contrôle de l’autorité judiciaire",
    ],
    answer:
        "L’ensemble de la chaîne : agent, gradé, OPJ, sous le contrôle de l’autorité judiciaire",
    explanation:
        "Même si l’autorité judiciaire contrôle la mesure, les policiers sont responsables du respect concret des durées et doivent alerter en cas de dépassement.",
    difficulty: "Intermédiaire",
  ),

  // =========================================================
  // ===================== NIVEAU DIFFICILE ==================
  // =========================================================
  const QuizQuestion(
    category: "Qualification de la mesure",
    question:
        "Vous contrôlez un étranger sans titre de séjour, soupçonné par ailleurs d’un vol aggravé. Vous souhaitez le retenir. Quel enchaînement est juridiquement le plus sûr ?",
    options: [
      "Retenue pour droit au séjour, puis éventuellement garde à vue si des éléments confirment l’infraction",
      "Garde à vue d’abord, puis on verra après pour le droit au séjour",
      "Vérification d’identité prolongée même au-delà de 4 heures",
    ],
    answer:
        "Retenue pour droit au séjour, puis éventuellement garde à vue si des éléments confirment l’infraction",
    explanation:
        "Il convient de choisir le cadre adapté à l’objectif poursuivi. On évite de masquer une mesure de police des étrangers sous couvert d’une garde à vue sans éléments suffisants.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cumuls de mesures",
    question:
        "Un individu est placé en chambre de sûreté pour ivresse publique manifeste. Pendant la nuit, des éléments nouveaux montrent son implication dans un cambriolage. Que faire ?",
    options: [
      "Le maintenir en chambre de sûreté jusqu’au matin puis le relâcher",
      "Basculer vers une garde à vue avec heure de début clairement fixée et droits notifiés",
      "Le garder en chambre de sûreté mais lui lire les droits de la garde à vue",
    ],
    answer:
        "Basculer vers une garde à vue avec heure de début clairement fixée et droits notifiés",
    explanation:
        "La chambre de sûreté ne doit pas servir à masquer une garde à vue. Dès qu’un soupçon sérieux d’infraction apparaît, le cadre GAV doit être utilisé avec les droits associés.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Contrôle de proportionnalité",
    question:
        "Une personne retenue pour vérification d’identité est coopérative, calme, non violente. Elle est immédiatement menottée et laissée entravée dans la geôle pendant 4 heures. Quel risque juridique majeur existe ?",
    options: [
      "Aucun, la menotte est automatique en geôle",
      "Un risque de contestation pour rigueur non strictement nécessaire au sens de l’article 9 DDHC",
      "Simple remarque disciplinaire sans enjeu pénal",
    ],
    answer:
        "Un risque de contestation pour rigueur non strictement nécessaire au sens de l’article 9 DDHC",
    explanation:
        "La coercition doit être strictement nécessaire. Une entrave prolongée sans justification peut être jugée disproportionnée.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Traçabilité – Terrorisme",
    question:
        "Dans une retenue pour vérification de situation liée au terrorisme, lequel de ces éléments est le plus déterminant pour la légalité de la mesure ?",
    options: [
      "La simple intuition des agents",
      "La rédaction précise des « raisons sérieuses de penser » et la consignation des horaires",
      "Le fait que la personne soit déjà connue des services",
    ],
    answer:
        "La rédaction précise des « raisons sérieuses de penser » et la consignation des horaires",
    explanation:
        "La mesure doit reposer sur des éléments factuels objectifs et une traçabilité stricte (horaires, motifs).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Frontière judiciaire/administratif",
    question:
        "Dans quelle situation la frontière entre mesure judiciaire et administrative est-elle particulièrement délicate à manier pour l’agent ?",
    options: [
      "Lors d’un dépôt de plainte simple",
      "Lors d’une vérification d’identité pouvant déboucher sur une GAV ou une mesure d’éloignement",
      "Lors de la rédaction d’un main-courante",
    ],
    answer:
        "Lors d’une vérification d’identité pouvant déboucher sur une GAV ou une mesure d’éloignement",
    explanation:
        "La vérification d’identité est citée dans le texte comme un exemple où la nature judiciaire ou administrative peut être difficile à établir.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Nullité de procédure",
    question:
        "Quel comportement expose le plus la procédure à une nullité pour atteinte disproportionnée à la liberté individuelle ?",
    options: [
      "Libérer une personne avant le terme légal de la mesure",
      "Prolonger une vérification d’identité au-delà de 4 heures en la qualifiant de « surveillance informelle »",
      "Notifier trop tôt les droits à un gardé à vue",
    ],
    answer:
        "Prolonger une vérification d’identité au-delà de 4 heures en la qualifiant de « surveillance informelle »",
    explanation:
        "Dépasser la durée légale en conservant la personne au poste sans base juridique claire constitue une atteinte grave à la liberté individuelle.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Gestion opérationnelle",
    question:
        "Vous êtes gradé de service et constatez que plusieurs retenues approchent de leur durée maximale simultanément. Quel réflexe est prioritaire ?",
    options: [
      "Reporter la décision au service suivant",
      "Faire immédiatement le point avec les O.P.J. et, si besoin, avec le parquet pour décider soit de la libération, soit d’un changement de cadre",
      "Ne rien faire car la durée n’est qu’indicative",
    ],
    answer:
        "Faire immédiatement le point avec les O.P.J. et, si besoin, avec le parquet pour décider soit de la libération, soit d’un changement de cadre",
    explanation:
        "Le respect des durées maximales est impératif. Le gradé doit anticiper les échéances et adapter les mesures avec l’avis de l’autorité judiciaire.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Responsabilité de l’État",
    question:
        "Une personne est maintenue en chambre de sûreté bien après son dégrisement, sans motif, parce que les agents sont débordés. Quel risque principal pour l’administration ?",
    options: [
      "Aucun, car la personne n’a pas été blessée",
      "Engagement de la responsabilité de l’État pour détention arbitraire ou faute lourde",
      "Simple remarque orale du parquet",
    ],
    answer:
        "Engagement de la responsabilité de l’État pour détention arbitraire ou faute lourde",
    explanation:
        "Le maintien sans base juridique ni nécessité peut être qualifié de détention arbitraire et engager la responsabilité de l’État et des agents.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Éthique professionnelle",
    question:
        "Pourquoi est-il dangereux, même « pour rendre service », de garder quelques heures au poste un mineur en fugue sans formaliser le cadre de la rétention ?",
    options: [
      "Parce que cela complique les statistiques",
      "Parce qu’en cas d’accident, l’absence de cadre juridique et de traçabilité pourrait engager fortement la responsabilité des fonctionnaires",
      "Parce que le mineur pourrait refuser de revenir au commissariat",
    ],
    answer:
        "Parce qu’en cas d’accident, l’absence de cadre juridique et de traçabilité pourrait engager fortement la responsabilité des fonctionnaires",
    explanation:
        "Toute atteinte à la liberté doit être formalisée, notamment pour les mineurs. Un « accueil informel » sans base légale est très risqué.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cadre général",
    question:
        "Le cadre légal spécifique d’usage des armes par les policiers et gendarmes est prévu par :",
    options: [
      "L’article 122-5 du Code pénal",
      "L’article L. 435-1 du Code de la sécurité intérieure",
      "L’article L. 211-9 du Code de la sécurité intérieure",
    ],
    answer: "L’article L. 435-1 du Code de la sécurité intérieure",
    explanation:
        "Le document précise que le cadre commun aux agents de la police et de la gendarmerie nationales est fixé par l’article L. 435-1 du Code de la sécurité intérieure.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cadre général",
    question:
        "L’article L. 435-1 du Code de la sécurité intérieure s’applique aux policiers lorsqu’ils :",
    options: [
      "Font usage de leur arme dans l’exercice de leurs fonctions",
      "Portent une arme en dehors de tout service et de toute mission",
      "Partent en vacances à l’étranger",
    ],
    answer: "Font usage de leur arme dans l’exercice de leurs fonctions",
    explanation:
        "L’article vise les policiers et gendarmes régulièrement armés qui font usage de leur arme dans l’exercice de leurs fonctions.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conditions préalables",
    question:
        "Combien de conditions préalables l’article L. 435-1 du Code de la sécurité intérieure impose-t-il avant tout usage d’une arme par un policier ?",
    options: ["Deux conditions", "Trois conditions", "Cinq conditions"],
    answer: "Trois conditions",
    explanation:
        "Le texte indique que l’article L. 435-1 du Code de la sécurité intérieure impose trois conditions préalables à l’usage d’une arme : l’exercice des fonctions, le port de l’uniforme ou d’insignes apparents, et l’absolue nécessité avec proportionnalité.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conditions préalables",
    question:
        "La première condition préalable à l’usage d’une arme par un policier est :",
    options: [
      "Être en repos hebdomadaire",
      "Agir dans l’exercice de ses fonctions",
      "Être en tenue civile discrète",
    ],
    answer: "Agir dans l’exercice de ses fonctions",
    explanation:
        "Le policier doit agir dans l’exercice de ses fonctions, soit pendant son temps de service, soit hors service lorsqu’il agit au titre des obligations d’assistance aux personnes en danger.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conditions préalables",
    question:
        "La deuxième condition préalable à l’usage d’une arme par un policier est :",
    options: [
      "Être seul sur l’intervention",
      "Être revêtu de son uniforme ou d’insignes extérieurs et apparents de sa qualité",
      "Être affecté en unité spécialisée",
    ],
    answer:
        "Être revêtu de son uniforme ou d’insignes extérieurs et apparents de sa qualité",
    explanation:
        "Le texte impose que le policier soit en uniforme ou porte des insignes extérieurs et apparents de sa qualité (par exemple le brassard police).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conditions préalables",
    question:
        "La troisième condition préalable exige que l’usage de l’arme soit :",
    options: [
      "Moralement acceptable",
      "Absolument nécessaire et strictement proportionné",
      "Autorisé par un supérieur hiérarchique",
    ],
    answer: "Absolument nécessaire et strictement proportionné",
    explanation:
        "L’article L. 435-1 du Code de la sécurité intérieure impose une absolue nécessité et une stricte proportionnalité entre la menace et la riposte armée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Policiers adjoints",
    question:
        "Les policiers adjoints peuvent-ils conserver leur arme individuelle en dehors des heures de service ?",
    options: [
      "Oui, comme les fonctionnaires actifs de la Police nationale",
      "Non, ils ne sont pas autorisés à conserver leur arme en dehors du service",
      "Oui, mais uniquement au domicile familial",
    ],
    answer:
        "Non, ils ne sont pas autorisés à conserver leur arme en dehors du service",
    explanation:
        "Le document précise que, contrairement aux fonctionnaires actifs, les policiers adjoints ne peuvent concevoir l’usage de leur arme hors service car ils ne sont pas autorisés à la conserver en dehors des heures de service.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Situations — Vue d’ensemble",
    question:
        "Lorsque les trois conditions préalables sont remplies, l’article L. 435-1 du Code de la sécurité intérieure autorise l’usage de l’arme dans :",
    options: ["Trois situations", "Cinq situations", "Dix situations"],
    answer: "Cinq situations",
    explanation:
        "Le cadre juridique spécifique prévoit cinq situations limitativement énumérées dans lesquelles l’usage de l’arme peut intervenir.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Situations — Somations",
    question:
        "Dans plusieurs situations prévues par l’article L. 435-1 (défense de lieux, fuite d’un individu dangereux, véhicule dangereux), les sommations :",
    options: [
      "Sont facultatives",
      "Sont obligatoires sauf impossibilité",
      "Sont interdites pour ne pas se dévoiler",
    ],
    answer: "Sont obligatoires sauf impossibilité",
    explanation:
        "Le texte parle de sommations obligatoires faites à haute voix, sauf impossibilité pratique liée à l’urgence ou à la nature de la menace.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Lien avec la légitime défense",
    question:
        "En dehors des cinq situations prévues à l’article L. 435-1 du Code de la sécurité intérieure (et hors dispersion d’attroupement), quel régime de droit commun reste applicable pour justifier l’usage des armes ?",
    options: [
      "L’article 122-5 du Code pénal sur la légitime défense",
      "L’article 122-1 du Code pénal sur l’irresponsabilité pénale pour trouble mental",
      "L’article 121-3 du Code pénal sur la faute d’imprudence",
    ],
    answer: "L’article 122-5 du Code pénal sur la légitime défense",
    explanation:
        "Lorsque le cadre spécial n’est pas applicable, l’usage de l’arme peut être apprécié au regard du régime général de la légitime défense prévu à l’article 122-5 du Code pénal.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU MOYEN =====================
  const QuizQuestion(
    category: "Situation 1 — Atteintes à la vie",
    question:
        "La première situation de l’article L. 435-1 du Code de la sécurité intérieure permet l’usage des armes lorsque :",
    options: [
      "Des atteintes à la vie ou à l’intégrité physique sont portées contre le policier ou un tiers",
      "Un simple outrage est proféré contre un policier",
      "Une contravention routière est constatée",
    ],
    answer:
        "Des atteintes à la vie ou à l’intégrité physique sont portées contre le policier ou un tiers",
    explanation:
        "La situation 1 vise les atteintes à la vie ou à l’intégrité physique du policier ou d’un tiers, ou la menace d’une telle atteinte par des personnes armées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Situation 1 — Atteintes à la vie",
    question:
        "Dans la situation 1 (atteintes à la vie ou à l’intégrité physique), le texte indique qu’il n’est pas prévu de procéder à des sommations car :",
    options: [
      "La loi les interdit absolument",
      "L’atteinte à la vie ou à l’intégrité physique est imminente",
      "Le policier n’a jamais le temps de parler",
    ],
    answer: "L’atteinte à la vie ou à l’intégrité physique est imminente",
    explanation:
        "Compte tenu de l’imminence de l’atteinte à la vie ou à l’intégrité physique, la réalisation de sommations peut être incompatible avec la sauvegarde des personnes.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Situation 2 — Lieux occupés",
    question:
        "La deuxième situation de l’article L. 435-1 concerne la défense des lieux occupés par les policiers ou des personnes qui leur sont confiées. L’usage des armes est possible :",
    options: [
      "Après avoir procédé à deux sommations à haute voix, sauf impossibilité",
      "Sans aucune sommation",
      "Seulement après autorisation écrite du procureur de la République",
    ],
    answer:
        "Après avoir procédé à deux sommations à haute voix, sauf impossibilité",
    explanation:
        "Le texte prévoit des sommations obligatoires à haute voix avant l’usage des armes pour défendre des lieux ou des personnes confiées, sauf impossibilité matérielle.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Situation 2 — Lieux occupés",
    question:
        "La défense des lieux occupés à titre permanent par les policiers peut viser par exemple :",
    options: [
      "Un poste de police ou un centre de rétention administrative",
      "Le domicile personnel d’un policier en repos",
      "Un commerce privé voisin du commissariat",
    ],
    answer: "Un poste de police ou un centre de rétention administrative",
    explanation:
        "Le document cite comme exemples un poste de police ou un centre de rétention administrative provisoire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Situation 3 — Fuite individu dangereux",
    question:
        "Dans la troisième situation (fuite d’un individu dangereux placé sous leur garde), l’usage des armes est possible après sommations lorsque :",
    options: [
      "Une personne cherche à s’échapper à leur garde au cours d’investigations",
      "Une personne refuse simplement de répondre aux questions",
      "Un témoin ne se présente pas à une audition",
    ],
    answer:
        "Une personne cherche à s’échapper à leur garde au cours d’investigations",
    explanation:
        "Le texte vise la personne placée sous garde à vue ou sous escorte qui tente de s’échapper alors qu’elle est sous la garde des policiers.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Situation 3 — Individu dangereux",
    question:
        "Dans la troisième situation, l’usage des armes n’est légitime que si les policiers disposent :",
    options: [
      "D’un simple doute sur la dangerosité",
      "De raisons réelles et objectives de penser que la personne représente une menace grave pour la vie ou l’intégrité physique",
      "D’une intuition personnelle",
    ],
    answer:
        "De raisons réelles et objectives de penser que la personne représente une menace grave pour la vie ou l’intégrité physique",
    explanation:
        "Le texte exige des raisons réelles et objectives de penser que l’individu, au moment de sa fuite, peut porter atteinte à la vie ou à l’intégrité physique des policiers ou d’autrui.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Situation 4 — Véhicule dangereux",
    question:
        "Dans la quatrième situation, les policiers peuvent faire usage de leur arme pour immobiliser un véhicule lorsque :",
    options: [
      "Le conducteur n’a pas obtempéré immédiatement à l’ordre d’arrêt et le véhicule est susceptible de porter atteinte à la vie ou à l’intégrité physique",
      "Le conducteur refuse un contrôle de documents",
      "Le véhicule est en stationnement gênant",
    ],
    answer:
        "Le conducteur n’a pas obtempéré immédiatement à l’ordre d’arrêt et le véhicule est susceptible de porter atteinte à la vie ou à l’intégrité physique",
    explanation:
        "L’article vise le refus d’obtempérer à un ordre d’arrêt accompagné de raisons réelles et objectives de penser que le véhicule ou ses occupants sont dangereux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Situation 4 — Véhicule dangereux",
    question: "L’ordre d’arrêt, dans la quatrième situation, doit être :",
    options: [
      "Ambigu pour laisser une marge d’interprétation",
      "Équivoque et difficilement compréhensible",
      "Clair, explicite et constituer une injonction manifeste de s’arrêter",
    ],
    answer:
        "Clair, explicite et constituer une injonction manifeste de s’arrêter",
    explanation:
        "Le texte précise que l’ordre d’arrêt doit être dépourvu d’ambiguïté et clairement entendu par le conducteur.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Situation 4 — Limites",
    question:
        "Selon l’article L. 435-1, il ne peut être fait usage des armes pour immobiliser un véhicule dans le seul but :",
    options: [
      "D’empêcher une fuite lorsque le véhicule est manifestement dangereux",
      "De contraindre un véhicule à s’arrêter alors qu’il ne présente aucune dangerosité pour ses occupants",
      "De protéger la vie d’autrui face à un véhicule-bélier",
    ],
    answer:
        "De contraindre un véhicule à s’arrêter alors qu’il ne présente aucune dangerosité pour ses occupants",
    explanation:
        "Le texte rappelle que l’on ne peut pas utiliser l’arme pour contraindre un véhicule à s’arrêter lorsque ce véhicule n’est pas dangereux pour ses occupants ou pour autrui.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Situation 5 — Périple meurtrier",
    question:
        "Dans la cinquième situation, le périple meurtrier, les policiers peuvent faire usage de leur arme contre un individu lorsque la première condition suivante est remplie :",
    options: [
      "L’individu vient de commettre ou de tenter de commettre un ou plusieurs meurtres",
      "L’individu est simplement connu défavorablement de la police",
      "L’individu se trouve dans un quartier sensible",
    ],
    answer:
        "L’individu vient de commettre ou de tenter de commettre un ou plusieurs meurtres",
    explanation:
        "Le périple meurtrier concerne un individu qui vient de commettre ou de tenter de commettre un ou plusieurs meurtres.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Situation 5 — Périple meurtrier",
    question:
        "Toujours dans la cinquième situation, les policiers doivent avoir des raisons réelles et objectives de penser que :",
    options: [
      "L’individu va se rendre de lui-même",
      "Une réitération de ces crimes est probable dans un temps rapproché",
      "L’individu veut simplement fuir le pays",
    ],
    answer:
        "Une réitération de ces crimes est probable dans un temps rapproché",
    explanation:
        "Le texte exige que le policier ait des raisons réelles et objectives de penser qu’une réitération des meurtres est probable et proche dans le temps.",
    difficulty: "Moyenne",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  const QuizQuestion(
    category: "Conditions préalables — Exercice des fonctions",
    question:
        "Un policier hors service, en tenue civile, assiste à une agression mortelle et intervient en utilisant son arme sans porter d’insigne extérieur. Pour apprécier la légalité de son geste, on pourra :",
    options: [
      "Écarter automatiquement toute justification",
      "Constater que la condition d’insignes extérieurs de l’article L. 435-1 n’est pas remplie et examiner subsidiairement la légitime défense au sens de l’article 122-5 du Code pénal",
      "Appliquer automatiquement la présomption de légitime défense",
    ],
    answer:
        "Constater que la condition d’insignes extérieurs de l’article L. 435-1 n’est pas remplie et examiner subsidiairement la légitime défense au sens de l’article 122-5 du Code pénal",
    explanation:
        "Le cadre spécial ne peut s’appliquer faute d’insignes apparents, mais le policier peut encore invoquer la légitime défense de droit commun s’il en remplit les conditions.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Somations — Appréciation",
    question:
        "Dans une situation de fuite d’un individu dangereux placé sous garde, les sommations ne sont pas matériellement possibles (tir immédiat nécessaire pour protéger une victime menacée d’un couteau). Juridiquement :",
    options: [
      "L’absence de sommations rend l’usage des armes illégal en toute hypothèse",
      "L’exigence de sommations peut être écartée si leur réalisation mettrait gravement en péril la vie des personnes",
      "Les sommations doivent toujours être effectuées, même si cela met en danger les victimes",
    ],
    answer:
        "L’exigence de sommations peut être écartée si leur réalisation mettrait gravement en péril la vie des personnes",
    explanation:
        "Le texte prévoit les sommations « sauf impossibilité », ce qui permet de les écarter en cas de danger immédiat pour la vie ou l’intégrité physique.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Situation 3 — Individu dangereux",
    question:
        "Un individu placé en garde à vue pour un délit mineur s’enfuit en courant, sans antécédent violent connu. Le policier, après deux sommations, fait usage de son arme pour l’empêcher de fuir. Quel critère fait le plus défaut ?",
    options: [
      "La fuite de l’individu",
      "Les raisons réelles et objectives de le considérer comme dangereux pour la vie ou l’intégrité physique",
      "La réalisation des sommations",
    ],
    answer:
        "Les raisons réelles et objectives de le considérer comme dangereux pour la vie ou l’intégrité physique",
    explanation:
        "La seule fuite ne suffit pas : il faut en plus des raisons réelles et objectives de penser que l’individu représente une menace grave pour la vie ou l’intégrité physique.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Situation 4 — Véhicule",
    question:
        "Lors d’un simple refus d’obtempérer à un contrôle routier, un véhicule prend la fuite à faible vitesse sur une route déserte. Aucun élément ne laisse penser que le conducteur est armé ou dangereux. Le tir sur le véhicule pour le contraindre à s’arrêter :",
    options: [
      "Entre dans la quatrième situation car il y a refus d’obtempérer",
      "N’est pas justifié car le véhicule ne présente pas de dangerosité particulière pour ses occupants ou pour autrui",
      "Est automatiquement couvert par la notion de fuite",
    ],
    answer:
        "N’est pas justifié car le véhicule ne présente pas de dangerosité particulière pour ses occupants ou pour autrui",
    explanation:
        "Le texte interdit d’utiliser les armes pour contraindre un véhicule à s’arrêter en l’absence de dangerosité réelle de ce véhicule ou de ses occupants.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Situation 5 — Périple meurtrier",
    question:
        "Dans la situation de périple meurtrier, l’usage des armes par les policiers suppose notamment que :",
    options: [
      "L’individu ait menacé verbalement de recommencer un jour",
      "L’individu soit susceptible de réitérer immédiatement les meurtres et que l’usage des armes soit le seul moyen d’empêcher cette réitération",
      "L’individu soit simplement en fuite après un vol simple",
    ],
    answer:
        "L’individu soit susceptible de réitérer immédiatement les meurtres et que l’usage des armes soit le seul moyen d’empêcher cette réitération",
    explanation:
        "Les conditions cumulatives sont la commission ou tentative de meurtre, la probabilité d’une réitération dans un temps rapproché et le caractère exclusif du recours aux armes pour l’empêcher.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Lien avec la légitime défense",
    question:
        "Un policier en uniforme, dans l’exercice de ses fonctions, fait usage de son arme dans une situation qui n’entre dans aucune des cinq hypothèses de l’article L. 435-1. Pour apprécier sa responsabilité, il conviendra :",
    options: [
      "De considérer que tout usage de l’arme est illégal en dehors des cinq situations",
      "D’examiner si les conditions de la légitime défense prévues par l’article 122-5 du Code pénal sont réunies",
      "De considérer l’usage comme automatiquement légitime",
    ],
    answer:
        "D’examiner si les conditions de la légitime défense prévues par l’article 122-5 du Code pénal sont réunies",
    explanation:
        "Le régime spécial n’exclut pas le recours au régime général de la légitime défense lorsque les conditions de ce dernier sont remplies.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Attroupement — Lien L. 211-9",
    question: "L’article L. 211-9 du Code de la sécurité intérieure traite :",
    options: [
      "Du périple meurtrier",
      "De l’usage des armes pour la dispersion d’un attroupement",
      "Du refus d’obtempérer à un ordre d’arrêt",
    ],
    answer: "De l’usage des armes pour la dispersion d’un attroupement",
    explanation:
        "Le document rappelle que la dispersion d’un attroupement relève d’un régime spécifique prévu à l’article L. 211-9 du Code de la sécurité intérieure.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Appréciation in concreto",
    question:
        "Pour apprécier la condition d’« absolue nécessité » posée par l’article L. 435-1, le juge tient compte notamment :",
    options: [
      "Uniquement du ressenti subjectif du policier",
      "Des circonstances concrètes (nombre d’assaillants, armes utilisées, lieu, heure, présence de tiers, possibilité de repli)",
      "Uniquement de la gravité médiatique de l’affaire",
    ],
    answer:
        "Des circonstances concrètes (nombre d’assaillants, armes utilisées, lieu, heure, présence de tiers, possibilité de repli)",
    explanation:
        "Comme pour la légitime défense, la nécessité et la proportionnalité sont appréciées in concreto à partir de tous les éléments de la situation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Policier adjoint — Hors service",
    question:
        "Un policier adjoint conserve illégalement son arme à son domicile et s’en sert pour intervenir dans une agression de rue en dehors de tout service. Même si les critères de la légitime défense sont par ailleurs remplis, sur le terrain de l’article L. 435-1 :",
    options: [
      "Le cadre spécial ne peut s’appliquer car le policier adjoint ne peut concevoir l’usage de son arme hors service",
      "L’usage est automatiquement légitime car il a sauvé une vie",
      "La question du service ou du hors service est indifférente",
    ],
    answer:
        "Le cadre spécial ne peut s’appliquer car le policier adjoint ne peut concevoir l’usage de son arme hors service",
    explanation:
        "Le texte rappelle expressément que les policiers adjoints ne sont pas autorisés à conserver leur arme individuelle en dehors des heures de service.",
    difficulty: "Difficile",
  ),

  // ===================== NIVEAU Difficile =====================
  const QuizQuestion(
    category: "Articulation régimes spéciaux / droit commun",
    question:
        "Lorsque l’usage des armes par un policier ne remplit pas une des conditions préalables de l’article L. 435-1 du Code de la sécurité intérieure mais que la situation correspond à une agression mortelle en cours, la juridiction pénale pourra :",
    options: [
      "Écarter toute justification et condamner automatiquement",
      "Examiner l’affaire à la lumière de la légitime défense de droit commun de l’article 122-5 du Code pénal",
      "Se prononcer uniquement sur la responsabilité disciplinaire",
    ],
    answer:
        "Examiner l’affaire à la lumière de la légitime défense de droit commun de l’article 122-5 du Code pénal",
    explanation:
        "Le cadre spécial n’exclut pas l’application subsidiaire du régime général de la légitime défense dès lors que ses conditions sont réunies.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Périple meurtrier — Exclusivité du moyen",
    question:
        "Dans la situation de périple meurtrier, l’exclusivité du moyen signifie que :",
    options: [
      "Les policiers doivent toujours tenter une négociation avant toute autre chose",
      "L’usage des armes est le seul moyen d’empêcher la réitération des crimes dans un temps rapproché",
      "Les policiers ne peuvent jamais utiliser d’autres armes que l’arme de service",
    ],
    answer:
        "L’usage des armes est le seul moyen d’empêcher la réitération des crimes dans un temps rapproché",
    explanation:
        "La loi exige que l’usage de l’arme ait pour but exclusif d’empêcher la réitération des meurtres lorsqu’aucun autre moyen n’est réellement disponible.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Véhicule dangereux — Analyse fine",
    question:
        "Un véhicule vient de forcer un barrage, a tenté de percuter des piétons et continue sa course à grande vitesse vers une zone très fréquentée. Les policiers, après sommations à la radio et gestes réglementaires, ouvrent le feu sur le conducteur. L’analyse juridique au regard de l’article L. 435-1 se fonde principalement sur :",
    options: [
      "La simple infraction de refus d’obtempérer",
      "Les raisons réelles et objectives de considérer le véhicule comme un moyen d’atteinte grave à la vie ou à l’intégrité physique des personnes",
      "La seule absence de permis de conduire",
    ],
    answer:
        "Les raisons réelles et objectives de considérer le véhicule comme un moyen d’atteinte grave à la vie ou à l’intégrité physique des personnes",
    explanation:
        "Le véhicule-bélier rend la menace grave et actuelle, ce qui permet d’entrer dans la quatrième situation si les autres conditions sont remplies.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Somations — Formule",
    question:
        "Les sommations en matière d’usage des armes doivent être faites à haute voix avec des formules explicites telles que :",
    options: [
      "« Police, veuillez ralentir » une seule fois",
      "« Halte police » puis, en cas d’inobservation, « Halte ou je fais feu »",
      "Une phrase libre choisie par chaque policier",
    ],
    answer:
        "« Halte police » puis, en cas d’inobservation, « Halte ou je fais feu »",
    explanation:
        "Le document reprend l’exemple classique de sommations successives « Halte police » puis « Halte ou je fais feu », qui doivent se succéder dans un temps court.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Appréciation judiciaire",
    question:
        "En pratique, lors d’un contentieux pénal sur l’usage des armes, les juges vont confronter la version du policier :",
    options: [
      "Uniquement avec les instructions de sa hiérarchie",
      "Avec les éléments objectifs du dossier (témoignages, vidéos, traces balistiques, horaires, Difficileises, etc.) pour vérifier nécessité et proportionnalité",
      "Avec l’opinion publique relayée dans les médias",
    ],
    answer:
        "Avec les éléments objectifs du dossier (témoignages, vidéos, traces balistiques, horaires, Difficileises, etc.) pour vérifier nécessité et proportionnalité",
    explanation:
        "L’examen porte sur la réalité de la menace et l’adéquation de la riposte, à partir de tous les éléments de preuve disponibles.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: 'Juridictions',
    question: 'Le tribunal correctionnel juge :',
    options: ['Les contraventions', 'Les délits', 'Les crimes'],
    answer: 'Les délits',
    explanation: 'Compétence de principe pour les délits.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Juridictions',
    question: 'Quelle juridiction connaît des contraventions ?',
    options: ['Tribunal correctionnel', 'Cour d’assises', 'Tribunal de police'],
    answer: 'Tribunal de police',
    explanation: 'Contraventions → tribunal de police.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Gravité',
    question: 'Classe de gravité (du moins grave au plus grave) :',
    options: [
      'Contraventions → Délits → Crimes',
      'Délits → Contraventions → Crimes',
      'Crimes → Délits → Contraventions',
    ],
    answer: 'Contraventions → Délits → Crimes',
    explanation: 'Hiérarchie légale classique.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Exemples',
    question: 'Le non-port de la ceinture de sécurité est en principe :',
    options: ['Une contravention', 'Un délit', 'Un crime'],
    answer: 'Une contravention',
    explanation: 'Infraction routière contraventionnelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Exemples',
    question: 'Le vol simple (sans circonstance aggravante) est :',
    options: ['Une contravention', 'Un délit', 'Un crime'],
    answer: 'Un délit',
    explanation: 'Puni correctionnellement.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Juridictions',
    question: 'La cour d’assises juge en principe :',
    options: ['Les délits', 'Les crimes', 'Les contraventions'],
    answer: 'Les crimes',
    explanation: 'Juridiction criminelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Peines',
    question: 'Les crimes sont principalement punis par :',
    options: [
      'Amendes contraventionnelles',
      'Peines criminelles (réclusion)',
      'Stages obligatoires',
    ],
    answer: 'Peines criminelles (réclusion)',
    explanation: 'La réclusion est la peine criminelle de référence.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Définitions',
    question: 'Une “peine principale” est celle qui :',
    options: [
      'S’ajoute à une autre peine',
      'Constitue la sanction de base',
      'Ne peut jamais être aménagée',
    ],
    answer: 'Constitue la sanction de base',
    explanation: 'Elle peut être complétée par des peines complémentaires.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Procédure',
    question: 'La classification impacte :',
    options: [
      'La juridiction compétente',
      'Les peines encourues',
      'La prescription',
      'Tout ce qui précède',
    ],
    answer: 'Tout ce qui précède',
    explanation: 'C’est le socle de l’orientation pénale.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Juridictions',
    question: 'La chambre spécialisée pour mineurs peut connaître :',
    options: [
      'Uniquement des contraventions',
      'De matières spécifiques prévues par les textes',
      'Uniquement des crimes',
    ],
    answer: 'De matières spécifiques prévues par les textes',
    explanation: 'Organisation spéciale pour les mineurs délinquants.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Peines complémentaires',
    question: 'La suspension du permis de conduire est :',
    options: [
      'Une peine principale criminelle',
      'Une peine complémentaire',
      'Une simple mesure administrative',
    ],
    answer: 'Une peine complémentaire',
    explanation: 'Peine privative/restrictive de droits.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Astreintes',
    question: 'Le TIG (travail d’intérêt général) est-il rémunéré ?',
    options: ['Oui', 'Non', 'Seulement au SMIC'],
    answer: 'Non',
    explanation: 'Travail non rémunéré au profit d’une structure habilitée.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Tentative',
    question: 'La tentative de contravention est :',
    options: [
      'Toujours punissable',
      'Jamais punissable',
      'Punissable si un texte le prévoit',
    ],
    answer: 'Jamais punissable',
    explanation: 'Principe : pas de tentative pour les contraventions.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Complicité',
    question: 'La complicité de crime ou de délit est :',
    options: [
      'Jamais punissable',
      'Toujours punissable',
      'Punissable selon les textes',
    ],
    answer: 'Toujours punissable',
    explanation: 'Principe pénal général.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Contraventions',
    question: 'Combien de classes de contraventions ?',
    options: ['3', '4', '5'],
    answer: '5',
    explanation: 'De la 1re à la 5e classe.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Définitions',
    question: 'La “sanction-réparation” vise principalement :',
    options: [
      'À indemniser la victime',
      'À emprisonner le condamné',
      'À retirer le permis automatiquement',
    ],
    answer: 'À indemniser la victime',
    explanation: 'Réparation du dommage causé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Gravité',
    question: 'Quelle affirmation est correcte ?',
    options: [
      'Tous les vols sont des crimes',
      'Un vol simple est un délit',
      'Les contraventions sont plus graves que les délits',
    ],
    answer: 'Un vol simple est un délit',
    explanation: 'Sans aggravation, c’est correctionnel.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Juridictions',
    question: 'Qui juge le tapage nocturne (hors récidive) ?',
    options: ['Cour d’assises', 'Tribunal correctionnel', 'Tribunal de police'],
    answer: 'Tribunal de police',
    explanation: 'Infraction contraventionnelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Exemples',
    question: 'Conduite sans ceinture :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Contravention',
    explanation: 'Routier contraventionnel.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Exemples',
    question: 'Homicide involontaire par maladresse (cas simple) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Juridiquement correctionnel en principe.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Exemples',
    question: 'Homicide volontaire :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Compétence criminelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Juridictions',
    question: 'Le juge unique du tribunal de police statue sur :',
    options: ['Crimes', 'Délits', 'Contraventions'],
    answer: 'Contraventions',
    explanation: 'Compétence de principe.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Prescription',
    question:
        'Principe : prescription de l’action publique des contraventions :',
    options: ['3 mois', '6 mois', '1 an'],
    answer: '1 an',
    explanation: 'Délai de principe pour les contraventions.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Définitions',
    question: '“Jours-amende”, c’est :',
    options: [
      'Un nombre de jours de prison',
      'Une somme/jour × nb de jours',
      'Un stage de sensibilisation',
    ],
    answer: 'Une somme/jour × nb de jours',
    explanation: 'Montant global = nb jours × montant/jour.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Peines',
    question: 'L’amende contraventionnelle maximale de principe est :',
    options: ['375 €', '750 €', '1500 €'],
    answer: '1500 €',
    explanation: 'Hors récidive/texte spécial.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Tentative',
    question: 'La tentative de crime est :',
    options: [
      'Toujours punissable',
      'Jamais punissable',
      'Punissable si un texte le prévoit',
    ],
    answer: 'Toujours punissable',
    explanation: 'Même si le crime n’a pas abouti.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Tentative',
    question: 'La tentative de délit est :',
    options: [
      'Toujours punissable',
      'Jamais punissable',
      'Punissable si un texte le prévoit',
    ],
    answer: 'Punissable si un texte le prévoit',
    explanation: 'Selon les textes.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Juridictions',
    question: 'Qui juge un “délit de fuite” (cas simple) ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal correctionnel',
    explanation: 'Délit routier.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Juridictions',
    question:
        'Qui juge les “violences volontaires ayant entraîné ITT < 8 jours” (sans circonstance aggravante) ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal de police',
    explanation: 'Contravention de 4e classe (selon cas).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Juridictions',
    question: 'Qui juge un “abus de confiance” ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal correctionnel',
    explanation: 'Infraction correctionnelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Juridictions',
    question: 'Qui juge une “extorsion” (cas général) ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal correctionnel',
    explanation: 'Délit (sauf formes aggravées relevant du criminel).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Juridictions',
    question: 'Qui juge un “meurtre” ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Cour d’assises',
    explanation: 'Crime.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Peines',
    question: 'Une interdiction de détenir des armes est :',
    options: [
      'Une peine complémentaire',
      'Une mesure de sûreté seulement',
      'Une contravention automatique',
    ],
    answer: 'Une peine complémentaire',
    explanation: 'Peine privative/restrictive de droits possible.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Exécution',
    question: 'Les peines privatives/restrictives de droits :',
    options: [
      'Ne concernent que les contraventions',
      'Peuvent s’ajouter aux peines principales',
      'Sont réservées aux crimes',
    ],
    answer: 'Peuvent s’ajouter aux peines principales',
    explanation: 'Elles complètent la peine principale.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Infractions de presse',
    question: 'La diffamation publique relève :',
    options: [
      'D’un régime spécial avec délais adaptés',
      'Uniquement de la cour d’assises',
      'Jamais de règles dérogatoires',
    ],
    answer: 'D’un régime spécial avec délais adaptés',
    explanation: 'Droit de la presse : règles spécifiques.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Procédure',
    question:
        'La classification de l’infraction conditionne-t-elle les modes de poursuite ?',
    options: ['Oui', 'Non'],
    answer: 'Oui',
    explanation: 'CRPC, composition pénale, information, etc.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Juridictions',
    question: 'La contravention de 5e classe est jugée par :',
    options: ['Cour d’assises', 'Tribunal correctionnel', 'Tribunal de police'],
    answer: 'Tribunal de police',
    explanation: 'Toujours contraventionnel.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Exemples',
    question: 'Conduite sans assurance (première constatation) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Infraction correctionnelle (Code des assurances).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Exemples',
    question: 'Menaces de mort réitérées (sans mise à exécution) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Correctionnel (selon circonstances).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Exemples',
    question: 'Tags/dégradations légères (dommages mineurs) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Contravention',
    explanation: 'Selon évaluation du dommage (seuils).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Juridictions',
    question: 'Qui connaît des crimes avec participation de jurés ?',
    options: ['Tribunal correctionnel', 'Cour d’assises', 'Tribunal de police'],
    answer: 'Cour d’assises',
    explanation: 'Jury populaire (selon degré).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Juridictions',
    question: 'Qui connaît des délits de presse (hors exceptions) ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal correctionnel',
    explanation: 'Compétence de principe.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Peines',
    question: 'Un stage de citoyenneté peut être :',
    options: [
      'Une peine principale criminelle',
      'Une peine complémentaire/obligatoire possible',
      'Impossible en correctionnel',
    ],
    answer: 'Une peine complémentaire/obligatoire possible',
    explanation: 'Selon les textes.',
    difficulty: 'Facile',
  ),

  // =========================
  //         MOYENNE
  // =========================
  const QuizQuestion(
    category: 'Prescription',
    question: 'Prescription (principe) pour les délits :',
    options: ['1 an', '3 ans', '6 ans'],
    answer: '6 ans',
    explanation: 'Délai de principe (hors régimes spéciaux).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Prescription',
    question: 'Prescription (principe) pour les crimes :',
    options: ['6 ans', '10 ans', '20 ans'],
    answer: '20 ans',
    explanation: 'Délai de principe (hors dérogations).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Prescription',
    question: 'Crimes contre l’humanité :',
    options: ['Prescrits à 20 ans', 'Prescrits à 30 ans', 'Imprescriptibles'],
    answer: 'Imprescriptibles',
    explanation: 'Régime d’imprescriptibilité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Juridictions',
    question: 'La “cour criminelle départementale” juge :',
    options: [
      'Des délits complexes',
      'Certains crimes sans jurés',
      'Uniquement des contraventions de 5e classe',
    ],
    answer: 'Certains crimes sans jurés',
    explanation:
        'Crimes punis de 15 ou 20 ans réclusion (selon périmètre légal).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Composition',
    question: 'Cour d’assises (premier ressort) : nombre de jurés populaires ?',
    options: ['6', '9', '12'],
    answer: '6',
    explanation: '6 jurés + 3 magistrats = 9 membres délibérants.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Composition',
    question: 'Cour d’assises d’appel : nombre de jurés populaires ?',
    options: ['6', '9', '12'],
    answer: '9',
    explanation: '9 jurés + 3 magistrats = 12 membres délibérants.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Vote',
    question:
        'Cour d’assises (premier ressort) : majorité requise pour déclarer coupable ?',
    options: ['5 voix', '6 voix', '7 voix'],
    answer: '6 voix',
    explanation: 'Majorité qualifiée (sur 9 votants).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Vote',
    question: 'Cour d’assises d’appel : majorité requise pour la culpabilité ?',
    options: ['7 voix', '8 voix', '9 voix'],
    answer: '8 voix',
    explanation: 'Majorité qualifiée (sur 12 votants).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Compétence',
    question:
        'Le tribunal correctionnel connaît des délits dont la peine encourue est :',
    options: [
      'Amende uniquement',
      'Emprisonnement ≤ 10 ans (selon textes) ou autres peines correctionnelles',
      'Réclusion criminelle',
    ],
    answer:
        'Emprisonnement ≤ 10 ans (selon textes) ou autres peines correctionnelles',
    explanation: 'Peines correctionnelles (emprisonnement/ amende).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Contraventions',
    question: 'Récidive de 5e classe : le plafond de l’amende peut atteindre :',
    options: ['1500 €', '2000 €', '3000 €'],
    answer: '3000 €',
    explanation: 'Plafond relevé en récidive pour certaines contraventions.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Peines',
    question: 'Jours-amende : le montant maximal usuel par jour (principe) :',
    options: ['100 €', '500 €', '1000 €'],
    answer: '1000 €',
    explanation: 'Plafond légal courant par jour.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Peines',
    question: 'Jours-amende : nombre de jours maximal usuel (principe) :',
    options: ['90', '180', '360'],
    answer: '360',
    explanation: 'Fixé par le juge dans la limite légale.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Procédure',
    question: 'La classification (crime/délit/contravention) influe sur :',
    options: [
      'La possibilité de CRPC (plaider-coupable)',
      'La compétence du parquet',
      'Les deux',
    ],
    answer: 'Les deux',
    explanation: 'Modes de poursuite et organisation.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question:
        'Dégradation légère d’un abribus (dommage mineur) : juridiction ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal de police',
    explanation: 'Contravention selon l’évaluation du dommage.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Vol simple d’un téléphone dans un café, sans violence :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Vol simple → correctionnel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Vol avec arme et blessure grave de la victime :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Circonstances aggravantes → criminel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Blanchiment d’argent (cas courant sans crime connexe) :',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal correctionnel',
    explanation: 'Délit économique/financier.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Tentative de vol à main armée (non aboutie) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Tentative de crime punissable.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Compétence territoriale',
    question:
        'En principe, la juridiction territorialement compétente est celle :',
    options: [
      'Du domicile de la victime uniquement',
      'Du lieu de l’infraction, ou de la résidence du prévenu, etc.',
      'Toujours la cour d’appel',
    ],
    answer: 'Du lieu de l’infraction, ou de la résidence du prévenu, etc.',
    explanation: 'Règles de compétence territoriale pénale.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Spéciales',
    question:
        'Certaines matières (terrorisme, trafic de stupéfiants en bande organisée…) :',
    options: [
      'Sont toujours renvoyées au tribunal de police',
      'Peuvent relever de juridictions spécialisées',
      'Sont jugées par un jury populaire rural',
    ],
    answer: 'Peuvent relever de juridictions spécialisées',
    explanation: 'Compétences spécialisées prévues par la loi.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Vote',
    question: 'En cour d’assises, qui participe au vote ?',
    options: [
      'Uniquement les jurés',
      'Uniquement les magistrats',
      'Jurés et magistrats',
    ],
    answer: 'Jurés et magistrats',
    explanation: 'Collégialité mixte.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mesures',
    question:
        'La détention à domicile sous surveillance électronique (DDSE) est :',
    options: [
      'Un mode d’exécution/aménagement de peine',
      'Une amende forfaitaire',
      'Une contravention de 5e classe',
    ],
    answer: 'Un mode d’exécution/aménagement de peine',
    explanation: 'Substitut/ aménagement de l’emprisonnement.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Stages',
    question: 'Des “peines de stage” peuvent viser :',
    options: [
      'La sécurité routière',
      'La prévention des violences intrafamiliales',
      'Toutes les réponses',
    ],
    answer: 'Toutes les réponses',
    explanation: 'Divers stages prévus par les textes.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question:
        'Blessures involontaires avec ITT de 15 jours par imprudence simple :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Seuil d’ITT et faute → correctionnel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question:
        'Outrage simple à une personne dépositaire de l’autorité publique :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Correctionnel (Code pénal).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Usage de faux document administratif (premiers faits) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Atteinte à l’autorité publique et à la confiance.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Infractions de presse',
    question: 'Injure publique simple :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Contravention',
    explanation: 'Régime spécial de la presse.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Procédure',
    question:
        'La classification influe sur la durée maximale de détention provisoire :',
    options: ['Vrai', 'Faux'],
    answer: 'Vrai',
    explanation: 'Durées et seuils varient selon la gravité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Procédure',
    question:
        'La classification oriente aussi les compétences d’instruction (juge d’instruction) :',
    options: ['Vrai', 'Faux'],
    answer: 'Vrai',
    explanation:
        'Information judiciaire plus fréquente pour les crimes/délits complexes.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Peines',
    question: 'La réclusion criminelle à perpétuité relève :',
    options: [
      'Des peines correctionnelles',
      'Des peines criminelles',
      'Des contraventions de 5e classe',
    ],
    answer: 'Des peines criminelles',
    explanation: 'Peine criminelle.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Juridictions',
    question: 'La CRPC (“plaider-coupable”) est possible :',
    options: [
      'Pour les contraventions seulement',
      'Pour certains délits',
      'Pour les crimes en principe',
    ],
    answer: 'Pour certains délits',
    explanation: 'Procédure applicable à des délits déterminés.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Recel d’un bien volé (cas simple) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Infraction autonome correctionnelle.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question:
        'Violences volontaires avec ITT de 10 jours sans arme ni circonstance aggravante :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Seuil d’ITT > 8 jours → correctionnel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Vol simple commis de nuit dans un lieu habité avec effraction :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Aggravations pouvant faire basculer au criminel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Complicité',
    question: 'La complicité de contravention :',
    options: [
      'Toujours punissable',
      'Jamais punissable',
      'Punissable si un texte le prévoit',
    ],
    answer: 'Punissable si un texte le prévoit',
    explanation: 'Spécificité du droit contraventionnel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Contraventions',
    question: 'Contravention : la juridiction statue en principe avec :',
    options: [
      'Un jury de citoyens',
      'Un juge unique',
      'Trois magistrats professionnels',
    ],
    answer: 'Un juge unique',
    explanation: 'Tribunal de police (juge unique).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Territoriale',
    question:
        'Un délit commis sur Internet : compétence territoriale possible :',
    options: [
      'Uniquement le lieu de résidence de la victime',
      'Lieu d’émission, de réception, résidence du prévenu…',
      'Uniquement la cour d’assises',
    ],
    answer: 'Lieu d’émission, de réception, résidence du prévenu…',
    explanation: 'Multiplicité de rattachements en cyberdélinquance.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Peines',
    question: 'La confiscation d’un bien est :',
    options: [
      'Une peine complémentaire possible',
      'Impossible en correctionnel',
      'Réservée aux contraventions',
    ],
    answer: 'Une peine complémentaire possible',
    explanation: 'Selon texte d’incrimination.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question:
        'Conduite après usage de stupéfiants (premiers faits, hors aggravation) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Correctionnel routier.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question:
        'Conduite avec 0,25 mg/l d’air expiré (0,5 g/l sang), première constatation :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Contravention',
    explanation: 'Seuil contraventionnel (hors récidive/ circonstances).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Conduite avec 0,50 mg/l d’air expiré (1,0 g/l sang) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Seuil délictuel dépassé.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Spéciales',
    question: 'Terrorisme : compétence :',
    options: [
      'Juridictions de droit commun',
      'Juridictions spécialisées',
      'Jury rural',
    ],
    answer: 'Juridictions spécialisées',
    explanation: 'Organisation centralisée (PNAT, etc.).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Procédure',
    question: 'La publicité des débats en cour d’assises est :',
    options: [
      'Toujours absolue',
      'En principe publique avec exceptions',
      'Toujours à huis clos',
    ],
    answer: 'En principe publique avec exceptions',
    explanation: 'Huis clos possible selon cas (mineurs, ordre public…).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Vote',
    question: 'Le secret du vote en cour d’assises :',
    options: [
      'Ne s’applique pas',
      'S’applique aux jurés uniquement',
      'S’applique à tous les votants',
    ],
    answer: 'S’applique à tous les votants',
    explanation: 'Jurés et magistrats votent au secret.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Peines',
    question: 'L’interdiction d’exercer une activité professionnelle est :',
    options: [
      'Une peine complémentaire possible',
      'Impossible en correctionnel',
      'Une contravention',
    ],
    answer: 'Une peine complémentaire possible',
    explanation: 'Selon les textes.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Port d’arme prohibée (couteau) sans motif légitime :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Atteinte à l’ordre public.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Infractions routières',
    question:
        'Grand excès de vitesse (≥ 50 km/h au-dessus) première constatation :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Contravention',
    explanation:
        'Contravention de 5e classe (mesures administratives associées).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Infractions routières',
    question: 'Grand excès de vitesse en récidive dans un délai légal :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Récidive légale → correctionnel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question:
        'Entrave à la circulation sans dommage humain (manifestation non déclarée) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Atteinte à l’ordre public (textes spéciaux).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Incendie volontaire d’un véhicule sans victime ni propagation :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Destructions volontaires par incendie → criminel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Compétence',
    question: 'Qui juge la “réception d’un bien volé” (recel) ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal correctionnel',
    explanation: 'Infraction correctionnelle.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Procédure',
    question: 'Le jury de cour d’assises prête serment :',
    options: ['Vrai', 'Faux'],
    answer: 'Vrai',
    explanation: 'Serment avant de siéger et de juger.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Territoriale',
    question:
        'Infraction commise à bord d’un avion français en vol international :',
    options: [
      'Compétence systématique de l’État survolé',
      'Compétence possible de l’État de l’immatriculation',
      'Jamais de compétence française',
    ],
    answer: 'Compétence possible de l’État de l’immatriculation',
    explanation: 'Règles de compétence extraterritoriale.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Spéciales',
    question: 'Trafic de stupéfiants en bande organisée :',
    options: [
      'Tribunal de police',
      'Juridictions spécialisées/correctionnel',
      'Cour d’assises systématique',
    ],
    answer: 'Juridictions spécialisées/correctionnel',
    explanation:
        'Organisation spécialisée, peines correctionnelles très élevées.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Harcèlement moral au travail (cas simple) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Correctionnel (Code pénal/Code du travail).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question:
        'Escroquerie à la carte bancaire (sommes modestes, sans bande organisée) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Infraction patrimoniale correctionnelle.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Vote',
    question: 'En cour d’assises, le président et les assesseurs votent :',
    options: [
      'Avant les jurés',
      'Après les jurés',
      'En même temps que les jurés et à égalité de voix',
    ],
    answer: 'En même temps que les jurés et à égalité de voix',
    explanation: 'Un seul collège de vote.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Peines',
    question: 'Interdiction du territoire français (ITF) :',
    options: [
      'Peine principale contraventionnelle',
      'Peine complémentaire possible',
      'Mesure uniquement civile',
    ],
    answer: 'Peine complémentaire possible',
    explanation: 'Prévue pour certaines infractions.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Définitions',
    question: 'La contrainte pénale (ou suivi renforcé) appartient :',
    options: ['Aux mesures d’enquête', 'Aux peines', 'Aux mesures civiles'],
    answer: 'Aux peines',
    explanation: 'Peine alternative/ aménagement, selon régime en vigueur.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Infractions de presse',
    question: 'Délais de prescription en matière de presse sont :',
    options: [
      'Identiques au droit commun',
      'Spécifiques et plus courts dans certains cas',
      'Toujours imprescriptibles',
    ],
    answer: 'Spécifiques et plus courts dans certains cas',
    explanation: 'Règles spéciales (ex. délais brefs).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Compétence matérielle',
    question: 'Les juridictions de proximité pénale ont été :',
    options: [
      'Créées puis supprimées/transférées',
      'Toujours compétentes pour les crimes',
      'Jamais existé',
    ],
    answer: 'Créées puis supprimées/transférées',
    explanation: 'Évolutions organisationnelles.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Faux et usage de faux en écriture privée (cas simple) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Correctionnel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question:
        'Agression sexuelle sans pénétration, majeure sur majeure, hors circonstances aggravantes :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Correctionnel (atteinte sexuelle ≠ viol).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Viol (pénétration sexuelle imposée) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Atteinte sexuelle la plus grave → criminel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Procédure',
    question: 'L’appel d’un jugement correctionnel est porté devant :',
    options: ['Cour d’assises', 'Cour d’appel', 'Cour de cassation'],
    answer: 'Cour d’appel',
    explanation: 'Double degré de juridiction.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Procédure',
    question: 'Le pourvoi contre un arrêt d’assises se fait devant :',
    options: ['Cour d’appel', 'Cour de cassation', 'Conseil d’État'],
    answer: 'Cour de cassation',
    explanation: 'Contrôle de droit.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Vote',
    question: 'En cour d’assises, la peine est votée :',
    options: [
      'Par les jurés seuls',
      'Par les magistrats seuls',
      'Par jurés et magistrats ensemble',
    ],
    answer: 'Par jurés et magistrats ensemble',
    explanation: 'Même collège délibérant.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Territoriale',
    question: 'Infraction commise à bord d’un navire français en haute mer :',
    options: [
      'Compétence possible de la France',
      'Compétence de l’État du port seulement',
      'Aucune poursuite possible',
    ],
    answer: 'Compétence possible de la France',
    explanation: 'Rattachement pavillon.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Spéciales',
    question: 'Crimes commis par un mineur de 16 ans :',
    options: [
      'Toujours cour d’assises',
      'Juridictions pour mineurs avec aménagements',
      'Tribunal de police',
    ],
    answer: 'Juridictions pour mineurs avec aménagements',
    explanation: 'Organisation spécifique (juridictions pour mineurs).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Peines',
    question: 'Interdiction d’entrer en contact avec la victime est :',
    options: [
      'Une mesure de sûreté uniquement',
      'Une peine complémentaire possible',
      'Une contravention',
    ],
    answer: 'Une peine complémentaire possible',
    explanation: 'Peine restrictive de droits.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question:
        'Introduction dans un domicile par ruse de jour sans violence ni effraction (vol) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Aggravation possible, mais reste correctionnel selon faits.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Administration de substances nuisibles sans ITT :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Atteinte à l’intégrité physique (selon résultats).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Classes',
    question: 'Une contravention de 3e classe est jugée :',
    options: [
      'Par la cour d’assises',
      'Par le tribunal de police',
      'Par le tribunal correctionnel',
    ],
    answer: 'Par le tribunal de police',
    explanation: 'Contraventions → tribunal de police.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Infractions de presse',
    question: 'Diffamation envers un particulier :',
    options: [
      'Toujours crime',
      'Régime spécial, correctionnel/contraventionnel selon cas',
      'Toujours contravention',
    ],
    answer: 'Régime spécial, correctionnel/contraventionnel selon cas',
    explanation: 'Droit de la presse.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Spéciales',
    question: 'Traite des êtres humains :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Atteinte grave à la dignité humaine.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Vote',
    question: 'En assises, l’acquittement est adopté :',
    options: [
      'À l’unanimité uniquement',
      'À la majorité qualifiée',
      'À la majorité simple',
    ],
    answer: 'À la majorité qualifiée',
    explanation: 'Mêmes règles de majorité que la culpabilité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Procédure',
    question: 'La présence d’un avocat est obligatoire en cour d’assises :',
    options: ['Vrai', 'Faux'],
    answer: 'Vrai',
    explanation: 'Garanties procédurales renforcées.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Peines',
    question: 'Interdiction de paraître dans certains lieux :',
    options: ['Peine complémentaire', 'Mesure civile', 'Contravention'],
    answer: 'Peine complémentaire',
    explanation: 'Peine restrictive de droits.',
    difficulty: 'Moyenne',
  ),

  // =========================
  //        DIFFICILE
  // =========================
  const QuizQuestion(
    category: 'Prescription',
    question:
        'Pour certaines infractions commises contre des mineurs, la prescription peut courir :',
    options: [
      'À compter des faits uniquement',
      'À compter de la majorité de la victime',
      'Jamais',
    ],
    answer: 'À compter de la majorité de la victime',
    explanation: 'Point de départ retardé par la loi.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Dérogations',
    question: 'Infractions de presse : délais de prescription :',
    options: [
      'Toujours 6 ans',
      'Toujours 20 ans',
      'Spécifiques et parfois très courts',
    ],
    answer: 'Spécifiques et parfois très courts',
    explanation: 'Régime dérogatoire (délais brefs).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Cour criminelle',
    question: 'La cour criminelle départementale statue :',
    options: [
      'Avec jurés et magistrats',
      'Sans jurés, avec des magistrats professionnels',
      'Avec magistrats honoraires uniquement',
    ],
    answer: 'Sans jurés, avec des magistrats professionnels',
    explanation: 'Composition collégiale de magistrats.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Cour criminelle',
    question: 'La cour criminelle connaît en principe des crimes punis :',
    options: ['De 10 ans', 'De 15 ou 20 ans', 'Uniquement de la perpétuité'],
    answer: 'De 15 ou 20 ans',
    explanation: 'Périmètre légal (hors exceptions).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Vote',
    question: 'En assises, le vote sur la peine doit respecter :',
    options: ['Une majorité simple', 'Une majorité qualifiée', 'L’unanimité'],
    answer: 'Une majorité qualifiée',
    explanation: 'Règles identiques à la culpabilité (selon degré).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Procédure',
    question: 'L’“information judiciaire” est :',
    options: [
      'Toujours obligatoire',
      'Facultative selon la gravité/complexité',
      'Interdite en délit',
    ],
    answer: 'Facultative selon la gravité/complexité',
    explanation: 'Surtout pour crimes/délits complexes.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Spéciales',
    question: 'Crimes contre l’humanité : juridiction :',
    options: [
      'Tribunal correctionnel',
      'Cour d’assises spécialisée',
      'Tribunal de police',
    ],
    answer: 'Cour d’assises spécialisée',
    explanation: 'Compétence criminelle spécifique.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Territoriale',
    question:
        'Infraction commise par un Français à l’étranger contre un Français :',
    options: [
      'Jamais poursuivable en France',
      'Possible poursuite en France sous conditions',
      'Toujours poursuivable automatiquement',
    ],
    answer: 'Possible poursuite en France sous conditions',
    explanation: 'Compétences extraterritoriales sous conditions.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Territoriale',
    question:
        'Infraction commise à l’étranger par un étranger contre un Français :',
    options: [
      'Jamais poursuivable en France',
      'Toujours poursuivable en France',
      'Poursuite possible sous conditions légales',
    ],
    answer: 'Poursuite possible sous conditions légales',
    explanation: 'Conditions de recevabilité/ plainte / double incrimination.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Définitions',
    question: '“Crime flagrant” :',
    options: [
      'Infraction en train de se commettre ou venant de se commettre',
      'Infraction prescrite',
      'Infraction contraventionnelle uniquement',
    ],
    answer: 'Infraction en train de se commettre ou venant de se commettre',
    explanation: 'Mode d’enquête spécifique (flagrance).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Procédure',
    question: 'La détention provisoire est plus encadrée pour :',
    options: ['Les contraventions', 'Les délits', 'Les crimes'],
    answer: 'Les crimes',
    explanation:
        'Seuils et durées maximales plus élevées mais fortement encadrées.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Vote',
    question: 'En assises, en cas de doute sur la culpabilité :',
    options: [
      'Le doute profite à l’accusé',
      'Le doute profite à la partie civile',
      'Le juge tranche seul',
    ],
    answer: 'Le doute profite à l’accusé',
    explanation: 'Principe de présomption d’innocence.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Peines',
    question: 'Interdiction des droits civiques (vote, éligibilité…) :',
    options: ['Peine complémentaire', 'Mesure de sûreté', 'Contravention'],
    answer: 'Peine complémentaire',
    explanation: 'Possible en correctionnel/criminel selon texte.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question:
        'Homicide involontaire avec violation délibérée d’une obligation de prudence (alcool + vitesse) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Correctionnel avec aggravation de la peine.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question:
        'Vol avec arme en bande organisée avec enlèvement de la victime :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Multiples aggravations → criminel.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Séquestration de 8 heures sans motifs légitimes :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Atteinte grave à la liberté → criminel.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Cour criminelle',
    question:
        'En cour criminelle départementale, le nombre de magistrats est :',
    options: ['3', '5', '7'],
    answer: '5',
    explanation: 'Collégialité de cinq magistrats.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Procédure',
    question: 'La participation du public en cour d’assises est :',
    options: ['Active', 'Par tirage au sort de jurés', 'Inexistante'],
    answer: 'Par tirage au sort de jurés',
    explanation: 'Jury populaire tiré au sort.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Territoriale',
    question:
        'Infraction continue commise sur plusieurs ressorts (escroquerie en série) :',
    options: [
      'Un seul tribunal possible (domicile du prévenu)',
      'Compétences multiples (lieu d’un fait, du préjudice, résidence du prévenu…)',
      'Cour d’assises obligatoire',
    ],
    answer:
        'Compétences multiples (lieu d’un fait, du préjudice, résidence du prévenu…)',
    explanation: 'Règles cumulatives de compétence.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Vote',
    question:
        'En assises, si la majorité requise n’est pas atteinte pour la culpabilité :',
    options: ['Acquittement', 'Renvoi automatique', 'Peine réduite'],
    answer: 'Acquittement',
    explanation: 'Le doute profite à l’accusé.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Spéciales',
    question:
        'Violences volontaires ayant entraîné une mutilation permanente :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Gravité des conséquences corporelles.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Spéciales',
    question: 'Association de malfaiteurs en vue d’un crime :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Finalité criminelle.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Procédure',
    question:
        'En matière criminelle, l’instruction par un juge d’instruction est :',
    options: [
      'Toujours exclue',
      'La règle en principe',
      'Réservée aux contraventions',
    ],
    answer: 'La règle en principe',
    explanation:
        'Instruction criminelle obligatoire (sauf régimes dérogatoires).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Peines',
    question: 'La peine de sûreté (période incompressible de réclusion) :',
    options: ['Contravention', 'Délit', 'Criminel'],
    answer: 'Criminel',
    explanation: 'Attachée aux peines criminelles lourdes.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Corruption d’agent public (corruption active) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation:
        'Atteinte à la probité publique → correctionnel (peines élevées).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Trafic d’armes à feu en bande organisée :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Gravité et organisation → criminel.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question:
        'Aide à l’entrée/ séjour irrégulier en bande organisée, avec mise en danger :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Aggravations pouvant relever du criminel.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Territoriale',
    question:
        'Infractions boursières commises sur une place étrangère impactant un marché français :',
    options: [
      'Jamais poursuivable en France',
      'Poursuite possible en France sous conditions',
      'Compétence uniquement de la cour d’assises',
    ],
    answer: 'Poursuite possible en France sous conditions',
    explanation: 'Compétence extraterritoriale économique.',
    difficulty: 'Difficile',
  ),

  // --- Suite après 'territoriale' ---
  const QuizQuestion(
    category: 'Vote',
    question: 'En cour d’assises, le président a-t-il une voix prépondérante ?',
    options: ['Oui', 'Non'],
    answer: 'Non',
    explanation:
        'Le président délibère avec la même valeur de voix qu’un juré ou qu’un assesseur.',
    difficulty: 'Moyenne',
  ),

  // ------ JURIDICTIONS / COMPOSITION ------
  const QuizQuestion(
    category: 'Cour d’assises',
    question: 'Combien de jurés populaires siègent en première instance ?',
    options: ['3', '6', '9'],
    answer: '6',
    explanation:
        'En première instance : 6 jurés + 3 magistrats professionnels.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Cour d’assises',
    question: 'Combien de jurés populaires siègent en appel ?',
    options: ['6', '9', '12'],
    answer: '9',
    explanation: 'En appel : 9 jurés + 3 magistrats professionnels.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Cour d’assises',
    question: 'La cour d’assises juge principalement :',
    options: ['Les contraventions', 'Les délits', 'Les crimes'],
    answer: 'Les crimes',
    explanation:
        'Compétence criminelle de principe (infractions les plus graves).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Tribunal correctionnel',
    question: 'Le tribunal correctionnel statue en principe en formation :',
    options: ['Collégiale', 'Juge unique', 'Avec jurés populaires'],
    answer: 'Collégiale',
    explanation:
        'Formation collégiale de principe ; le juge unique est possible pour certains délits.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Tribunal de police',
    question: 'Le tribunal de police statue en principe avec :',
    options: ['Un juge unique', 'Trois juges', 'Des jurés'],
    answer: 'Un juge unique',
    explanation:
        'Juridiction compétente pour les contraventions, siégeant à juge unique.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Compétence',
    question: 'Une contravention de 5e classe relève en principe :',
    options: [
      'Du tribunal correctionnel',
      'Du tribunal de police',
      'De la cour d’assises',
    ],
    answer: 'Du tribunal de police',
    explanation:
        'Toutes les contraventions, y compris la 5e classe, relèvent du tribunal de police.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Compétence',
    question:
        'Un homicide involontaire commis par imprudence à la circulation est en principe :',
    options: ['Un crime', 'Un délit', 'Une contravention'],
    answer: 'Un délit',
    explanation: 'Il relève du tribunal correctionnel (délit).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Compétence',
    question: 'Un viol est en principe jugé par :',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Cour d’assises',
    explanation: 'Le viol est un crime : compétence de la cour d’assises.',
    difficulty: 'Facile',
  ),

  // ------ TERRITORIALE / LIEU DE L’INFRACTION ------
  const QuizQuestion(
    category: 'Territoriale',
    question:
        'Une escroquerie réalisée en ligne depuis l’étranger, avec des victimes en France, peut-elle être poursuivie en France ?',
    options: [
      'Jamais poursuivable en France',
      'Poursuite possible en France sous conditions',
      'Uniquement au lieu de résidence de l’auteur',
    ],
    answer: 'Poursuite possible en France sous conditions',
    explanation:
        'Compétence possible si un élément constitutif ou le résultat a lieu en France.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Territoriale',
    question:
        'En cas d’infraction commise dans plusieurs ressorts, est compétent :',
    options: [
      'Le seul lieu d’arrestation',
      'L’un des lieux de commission ou de constatation',
      'Uniquement le lieu du domicile de la victime',
    ],
    answer: 'L’un des lieux de commission ou de constatation',
    explanation:
        'Compétences concurrentes (commission, découverte, arrestation, domicile du prévenu selon les cas).',
    difficulty: 'Moyenne',
  ),

  // ------ MINEURS ------
  const QuizQuestion(
    category: 'Mineurs',
    question: 'Qui juge en principe un délit commis par un mineur ?',
    options: [
      'Le tribunal correctionnel',
      'Le tribunal pour enfants',
      'La cour d’assises',
    ],
    answer: 'Le tribunal pour enfants',
    explanation:
        'Le tribunal pour enfants juge les délits des mineurs (procédure et peines adaptées).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mineurs',
    question: 'Un crime commis par un mineur relève :',
    options: [
      'De la cour d’assises des mineurs',
      'Du tribunal correctionnel',
      'Du tribunal de police',
    ],
    answer: 'De la cour d’assises des mineurs',
    explanation:
        'Formation spéciale de la cour d’assises pour les crimes des mineurs.',
    difficulty: 'Moyenne',
  ),

  // ------ PRESCRIPTION (rappels généraux sûrs) ------
  const QuizQuestion(
    category: 'Prescription',
    question: 'La prescription de l’action publique court en principe :',
    options: [
      'À compter du jour des faits',
      'À compter de l’arrestation',
      'À compter de la décision de première instance',
    ],
    answer: 'À compter du jour des faits',
    explanation:
        'Sauf textes prévoyant un point de départ différé (ex. mineurs).',
    difficulty: 'Moyenne',
  ),

  // ------ PROCÉDURE / MODES DE POURSUITE ------
  const QuizQuestion(
    category: 'Procédure',
    question: 'La composition pénale peut viser :',
    options: [
      'Des délits et certaines contraventions',
      'Uniquement des crimes',
      'Uniquement des contraventions de 1re classe',
    ],
    answer: 'Des délits et certaines contraventions',
    explanation: 'Mesure proposée par le procureur pour certaines infractions.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Procédure',
    question: 'La CRPC (plaider-coupable) concerne :',
    options: ['Les délits', 'Les crimes', 'Toutes les contraventions'],
    answer: 'Les délits',
    explanation:
        'Procédure de comparution sur reconnaissance préalable de culpabilité : uniquement pour des délits.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Procédure',
    question:
        'L’ordonnance pénale est un mode de poursuite possible notamment pour :',
    options: [
      'Certaines contraventions et délits',
      'Les crimes',
      'Uniquement les crimes routiers',
    ],
    answer: 'Certaines contraventions et délits',
    explanation:
        'Procédure simplifiée écrite, hors détention et pour des infractions déterminées par la loi.',
    difficulty: 'Moyenne',
  ),

  // ------ PEINES / PRINCIPES ------
  const QuizQuestion(
    category: 'Peines',
    question: 'Le sursis probatoire est :',
    options: [
      'Un mode d’exécution de la réclusion criminelle',
      'Un sursis avec obligations et contrôle',
      'Une amende forfaitaire',
    ],
    answer: 'Un sursis avec obligations et contrôle',
    explanation:
        'Sursis assorti d’obligations (soins, travail, indemnisation, etc.), suivi par le SPIP.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Peines',
    question: 'Un stage de sensibilisation à la sécurité routière est :',
    options: [
      'Une peine complémentaire possible',
      'Uniquement une mesure administrative',
      'Réservé aux crimes',
    ],
    answer: 'Une peine complémentaire possible',
    explanation:
        'Peine de stage prévue par les textes pour certaines infractions.',
    difficulty: 'Facile',
  ),

  // ------ EXEMPLES / MISES EN SITUATION ------
  const QuizQuestion(
    category: 'Mise en situation',
    question:
        'Tapage nocturne (réitéré) avec constat par procès-verbal : relève en principe de…',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Contravention',
    explanation:
        'Les troubles de voisinage/tapage relèvent généralement du régime contraventionnel.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question:
        'Vol à l’étalage simple (faible valeur, sans circonstance aggravante) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation:
        'Le vol est un délit sauf aggravations (bande organisée, armes, violences…).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question:
        'Conduite sous l’empire d’un état alcoolique délictuel (taux délit) :',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal correctionnel',
    explanation:
        'Les délits routiers (seuils délictueux) relèvent du tribunal correctionnel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en situation',
    question: 'Harcèlement moral au travail (hors cas contraventionnels) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation:
        'Relève du tribunal correctionnel (texte incriminateur spécifique).',
    difficulty: 'Moyenne',
  ),

  // ------ APPEL / COUR D’APPEL ------
  const QuizQuestion(
    category: 'Appel',
    question: 'Les arrêts de la cour d’assises sont susceptibles :',
    options: ['D’opposition', 'D’appel', 'Uniquement de pourvoi en cassation'],
    answer: 'D’appel',
    explanation:
        'Possibilité d’appel des arrêts d’assises devant une autre cour d’assises d’appel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Appel',
    question: 'Les jugements du tribunal correctionnel sont susceptibles :',
    options: ['D’appel', 'Uniquement de pourvoi', 'Jamais de recours'],
    answer: 'D’appel',
    explanation:
        'La voie d’appel est ouverte sous conditions de délais et d’intérêt à agir.',
    difficulty: 'Facile',
  ),

  // ------ ÉLÉMENTS GÉNÉRAUX / RAPPELS ------
  const QuizQuestion(
    category: 'Gravité',
    question: 'Classement par gravité croissante :',
    options: [
      'Crimes → Délits → Contraventions',
      'Contraventions → Délits → Crimes',
      'Délits → Contraventions → Crimes',
    ],
    answer: 'Contraventions → Délits → Crimes',
    explanation: 'Ordre légal : contravention < délit < crime.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Juridictions spécialisées',
    question:
        'Des juridictions/compétences spécialisées existent (presse, terrorisme, mineurs, éco-financier…).',
    options: ['Vrai', 'Faux'],
    answer: 'Vrai',
    explanation:
        'La loi prévoit des formations ou juridictions spécialisées selon la matière.',
    difficulty: 'Facile',
  ),

  // ------ AUTRES POINTS CIBLES ------
  const QuizQuestion(
    category: 'Vote',
    question:
        'En cour d’assises, la culpabilité est acquise si la majorité requise est atteinte lors du vote à bulletins secrets.',
    options: ['Vrai', 'Faux'],
    answer: 'Vrai',
    explanation:
        'Le vote se fait à bulletins secrets ; une majorité qualifiée est exigée par la loi.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Définitions',
    question: 'Une peine complémentaire :',
    options: [
      'Ne peut jamais s’ajouter à une peine principale',
      'Peut s’ajouter à la peine principale si la loi le prévoit',
      'Est réservée aux contraventions uniquement',
    ],
    answer: 'Peut s’ajouter à la peine principale si la loi le prévoit',
    explanation:
        'Suspension de permis, interdictions, confiscations… selon textes.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Exécution',
    question:
        'La DDSE (détention à domicile sous surveillance électronique) est :',
    options: [
      'Un mode d’exécution/alternative à l’emprisonnement',
      'Un simple avertissement',
      'Réservée aux crimes',
    ],
    answer: 'Un mode d’exécution/alternative à l’emprisonnement',
    explanation: 'Peut remplacer l’incarcération sous contrôle électronique.',
    difficulty: 'Moyenne',
  ),

  // --- (Tu peux continuer à cet endroit pour ajouter d’autres séries si besoin) ---
];

// ============================================================================
// PAGE
// ============================================================================
class QuizGeneralitePageGPX extends StatefulWidget {
  static const String grade = 'gpx';
  static const String routeName =
      '/gpx/procedure_penale/quiz/generalité_principales';
  final String uid;
  final String email;

  const QuizGeneralitePageGPX({super.key, required this.uid, required this.email});

  @override
  State<QuizGeneralitePageGPX> createState() => _QuizGeneralitePageGPXState();
}

class _QuizGeneralitePageGPXState extends State<QuizGeneralitePageGPX>
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
  static const _introHiddenKey = 'intro_gpx_generalite';
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
        ? questionsGeneralitePage
        : questionsGeneralitePage
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
            'mode': UserContextService.I.modeOrDefault,'module_name': 'Généralité',
            'quiz_name': 'Quiz Page',
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
      await _sb.from('quiz_generalite_principales').insert({
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
      debugPrint('❌ quiz_generalite_principales insert failed: $e');
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
      'source_file': 'gpx_quiz_generalite_page',
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
                            icon: Icons.info_rounded,
                            title: 'Généralités',
                            description: 'Découvre les bases du droit et de la procédure pénale : principes fondamentaux, sources du droit, organisations judiciaires et notions clés.',
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
