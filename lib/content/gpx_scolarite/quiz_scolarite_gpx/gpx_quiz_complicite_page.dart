// quiz_complicite_page.dart
// Page Quiz des Complicite — visuel et logique 100% identiques à la classification,
// adapté à la table Supabase `quiz_complicite` + même système de logs `quiz_history`.

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

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
// ============================================================================
// DATA – QUIZ COMPLICITÉ
// ============================================================================

class QuizQuestion {
  final String category;
  final String question;
  final List<String> options;
  final String answer;
  final String explanation;
  final String difficulty; // "Facile" | "Moyenne" | "Difficile" | "Expert"
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

/// Banque de questions du **QUIZ Complicité**
final List<QuizQuestion> questionsComplicite = [
  // ===================== FACILE =====================
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

  // ===================== EXPERT =====================
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
    difficulty: 'Expert',
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
    difficulty: 'Expert',
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
    difficulty: 'Expert',
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
    difficulty: 'Expert',
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
    difficulty: 'Expert',
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
    difficulty: 'Expert',
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
    difficulty: 'Expert',
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
    difficulty: 'Expert',
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
    difficulty: 'Expert',
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
    difficulty: 'Expert',
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
    difficulty: 'Expert',
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
    difficulty: 'Expert',
  ),
];

// ============================================================================
// PAGE — Quiz des Complicite
// ============================================================================
class QuizComplicitePageGPX extends StatefulWidget {
  static const String grade = 'gpx';
  static const String routeName = '/gpx/complicite/quiz/complicite';

  final String uid;
  final String email;

  const QuizComplicitePageGPX({super.key, required this.uid, required this.email});

  @override
  State<QuizComplicitePageGPX> createState() => _QuizComplicitePageGPXState();
}

class _QuizComplicitePageGPXState extends State<QuizComplicitePageGPX>
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
  static const _introHiddenKey = 'intro_gpx_complicite';
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

  void _seedAndShuffle() {
    final useAll = _mixMode || _selectedDifficulty == null;
    final selectedToken = _difficultyToken(_selectedDifficulty);

    final filtered = useAll
        ? questionsComplicite
        : questionsComplicite
              .where((q) => _difficultyToken(q.difficulty) == selectedToken)
              .toList();

    // Fallback si aucune question ne matche (ou si la banque est vide)
    final pool = filtered.isEmpty ? questionsComplicite : filtered;

    _qs = List<QuizQuestion>.from(pool)..shuffle(_rng);
    _opts = _qs
        .map((q) => (List<String>.from(q.options)..shuffle(_rng)))
        .toList();
    _answers = List<String?>.filled(_qs.length, null);
    _hasQuiz = true;

    debugPrint(
      '🎯 Start quiz Complicite — mix=$_mixMode, selected=$_selectedDifficulty → ${_qs.length} questions',
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
            
            'grade': UserContextService.I.trackOrDefault,
            'track': UserContextService.I.trackOrDefault,
            'mode': UserContextService.I.modeOrDefault,'module_name': 'Complicite',
            'quiz_name': 'Quiz des Complicite',
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
      debugPrint('✅ quiz_history (Complicite) start id=$_historyRowId');
    } on PostgrestException catch (e) {
      debugPrint(
        '❌ quiz_history (Complicite start) Postgrest: ${e.message} | ${e.details}',
      );
    } catch (e, st) {
      debugPrint('❌ quiz_history (Complicite start) error: $e\n$st');
    }
  }

  Future<void> _updateHistoryOnFinish() async {
    if (_historyRowId == null) return;
    try {
      final u = _requireUser();
      final int answered = _answers.where((a) => a != null).length;
      final int totalForScore = answered <= 0 ? 1 : answered;
      final int percent = (_score * 100 ~/ totalForScore).clamp(0, 100);

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

      debugPrint('✅ quiz_history (Complicite) finish updated: $res');
    } on PostgrestException catch (e) {
      debugPrint(
        '❌ quiz_history (Complicite finish) Postgrest: ${e.message} | ${e.details}',
      );
    } catch (e, st) {
      debugPrint('❌ quiz_history (Complicite finish) error: $e\n$st');
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
  }) async {
    try {
      final u = _requireUser();
      final res = await _sb
          .from('quiz_complicite') // ✅ table cible du screenshot
          .insert({
            'uid': u.id,
            'email': u.email ?? '',
            
            'grade': UserContextService.I.trackOrDefault,'question': question,
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
        '$color📝 [quiz_complicite] #${res['id']} ${isCorrect ? "✔️ Correct" : "❌ Incorrect"}$reset',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        '❌ quiz_complicite insert Postgrest: ${e.message} | ${e.details}',
      );
    } catch (e, st) {
      debugPrint('❌ quiz_complicite insert error: $e\n$st');
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
      'source_file': 'gpx_quiz_complicite_page',
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
                            icon: Icons.group_rounded,
                            title: 'Complicité',
                            description: 'Maîtrise la notion de complicité en droit pénal : modes de participation, conditions par aide et instigation, et sanctions applicables.',
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

  // ==========================================================================
  // RESULT DIALOG
  // ==========================================================================
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
          message: 'Tu maîtrises la tentative 💪',
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
          message: 'Reprends 121-5 C. pén. 🔁',
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
                                label: 'Moyenne',
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
