// ignore_for_file: use_build_context_synchronously

// ============================================================================
//  Quiz Tentative – version refondue
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

// ---------------------------------------------------------------
// BANQUE DES QUESTIONS : colle exactement ce que tu avais déjà.
// (tronqué ici pour la réponse ; garde ta liste complète existante)
// ---------------------------------------------------------------

final List<QuizQuestion> questionsClassificationInfractions = [
  // =========================
  //         FACILE
  // =========================
  QuizQuestion(
    category: 'Juridictions',
    question: 'Quelle juridiction est compétente pour juger les crimes ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Cour d’assises',
    explanation:
        'Crimes → cour d’assises (ou, pour certains crimes, cour criminelle départementale).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Juridictions',
    question: 'Le tribunal correctionnel juge :',
    options: ['Les contraventions', 'Les délits', 'Les crimes'],
    answer: 'Les délits',
    explanation: 'Compétence de principe pour les délits.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Juridictions',
    question: 'Quelle juridiction connaît des contraventions ?',
    options: ['Tribunal correctionnel', 'Cour d’assises', 'Tribunal de police'],
    answer: 'Tribunal de police',
    explanation: 'Contraventions → tribunal de police.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Exemples',
    question: 'Le non-port de la ceinture de sécurité est en principe :',
    options: ['Une contravention', 'Un délit', 'Un crime'],
    answer: 'Une contravention',
    explanation: 'Infraction routière contraventionnelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Exemples',
    question: 'Le vol simple (sans circonstance aggravante) est :',
    options: ['Une contravention', 'Un délit', 'Un crime'],
    answer: 'Un délit',
    explanation: 'Puni correctionnellement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Juridictions',
    question: 'La cour d’assises juge en principe :',
    options: ['Les délits', 'Les crimes', 'Les contraventions'],
    answer: 'Les crimes',
    explanation: 'Juridiction criminelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Astreintes',
    question: 'Le TIG (travail d’intérêt général) est-il rémunéré ?',
    options: ['Oui', 'Non', 'Seulement au SMIC'],
    answer: 'Non',
    explanation: 'Travail non rémunéré au profit d’une structure habilitée.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Contraventions',
    question: 'Combien de classes de contraventions ?',
    options: ['3', '4', '5'],
    answer: '5',
    explanation: 'De la 1re à la 5e classe.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Juridictions',
    question: 'Qui juge le tapage nocturne (hors récidive) ?',
    options: ['Cour d’assises', 'Tribunal correctionnel', 'Tribunal de police'],
    answer: 'Tribunal de police',
    explanation: 'Infraction contraventionnelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Exemples',
    question: 'Conduite sans ceinture :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Contravention',
    explanation: 'Routier contraventionnel.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Exemples',
    question: 'Homicide involontaire par maladresse (cas simple) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Juridiquement correctionnel en principe.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Exemples',
    question: 'Homicide volontaire :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Compétence criminelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Juridictions',
    question: 'Le juge unique du tribunal de police statue sur :',
    options: ['Crimes', 'Délits', 'Contraventions'],
    answer: 'Contraventions',
    explanation: 'Compétence de principe.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Prescription',
    question:
        'Principe : prescription de l’action publique des contraventions :',
    options: ['3 mois', '6 mois', '1 an'],
    answer: '1 an',
    explanation: 'Délai de principe pour les contraventions.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Peines',
    question: 'L’amende contraventionnelle maximale de principe est :',
    options: ['375 €', '750 €', '1500 €'],
    answer: '1500 €',
    explanation: 'Hors récidive/texte spécial.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Juridictions',
    question: 'Qui juge un “délit de fuite” (cas simple) ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal correctionnel',
    explanation: 'Délit routier.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Juridictions',
    question:
        'Qui juge les “violences volontaires ayant entraîné ITT < 8 jours” (sans circonstance aggravante) ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal de police',
    explanation: 'Contravention de 4e classe (selon cas).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Juridictions',
    question: 'Qui juge un “abus de confiance” ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal correctionnel',
    explanation: 'Infraction correctionnelle.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Juridictions',
    question: 'Qui juge une “extorsion” (cas général) ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal correctionnel',
    explanation: 'Délit (sauf formes aggravées relevant du criminel).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Juridictions',
    question: 'Qui juge un “meurtre” ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Cour d’assises',
    explanation: 'Crime.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Procédure',
    question:
        'La classification de l’infraction conditionne-t-elle les modes de poursuite ?',
    options: ['Oui', 'Non'],
    answer: 'Oui',
    explanation: 'CRPC, composition pénale, information, etc.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Juridictions',
    question: 'La contravention de 5e classe est jugée par :',
    options: ['Cour d’assises', 'Tribunal correctionnel', 'Tribunal de police'],
    answer: 'Tribunal de police',
    explanation: 'Toujours contraventionnel.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Exemples',
    question: 'Conduite sans assurance (première constatation) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Infraction correctionnelle (Code des assurances).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Exemples',
    question: 'Menaces de mort réitérées (sans mise à exécution) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Correctionnel (selon circonstances).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Exemples',
    question: 'Tags/dégradations légères (dommages mineurs) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Contravention',
    explanation: 'Selon évaluation du dommage (seuils).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Juridictions',
    question: 'Qui connaît des crimes avec participation de jurés ?',
    options: ['Tribunal correctionnel', 'Cour d’assises', 'Tribunal de police'],
    answer: 'Cour d’assises',
    explanation: 'Jury populaire (selon degré).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Juridictions',
    question: 'Qui connaît des délits de presse (hors exceptions) ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal correctionnel',
    explanation: 'Compétence de principe.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Prescription',
    question: 'Prescription (principe) pour les délits :',
    options: ['1 an', '3 ans', '6 ans'],
    answer: '6 ans',
    explanation: 'Délai de principe (hors régimes spéciaux).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Prescription',
    question: 'Prescription (principe) pour les crimes :',
    options: ['6 ans', '10 ans', '20 ans'],
    answer: '20 ans',
    explanation: 'Délai de principe (hors dérogations).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Prescription',
    question: 'Crimes contre l’humanité :',
    options: ['Prescrits à 20 ans', 'Prescrits à 30 ans', 'Imprescriptibles'],
    answer: 'Imprescriptibles',
    explanation: 'Régime d’imprescriptibilité.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Composition',
    question: 'Cour d’assises (premier ressort) : nombre de jurés populaires ?',
    options: ['6', '9', '12'],
    answer: '6',
    explanation: '6 jurés + 3 magistrats = 9 membres délibérants.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Composition',
    question: 'Cour d’assises d’appel : nombre de jurés populaires ?',
    options: ['6', '9', '12'],
    answer: '9',
    explanation: '9 jurés + 3 magistrats = 12 membres délibérants.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Vote',
    question:
        'Cour d’assises (premier ressort) : majorité requise pour déclarer coupable ?',
    options: ['5 voix', '6 voix', '7 voix'],
    answer: '6 voix',
    explanation: 'Majorité qualifiée (sur 9 votants).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Vote',
    question: 'Cour d’assises d’appel : majorité requise pour la culpabilité ?',
    options: ['7 voix', '8 voix', '9 voix'],
    answer: '8 voix',
    explanation: 'Majorité qualifiée (sur 12 votants).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Contraventions',
    question: 'Récidive de 5e classe : le plafond de l’amende peut atteindre :',
    options: ['1500 €', '2000 €', '3000 €'],
    answer: '3000 €',
    explanation: 'Plafond relevé en récidive pour certaines contraventions.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Peines',
    question: 'Jours-amende : le montant maximal usuel par jour (principe) :',
    options: ['100 €', '500 €', '1000 €'],
    answer: '1000 €',
    explanation: 'Plafond légal courant par jour.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Peines',
    question: 'Jours-amende : nombre de jours maximal usuel (principe) :',
    options: ['90', '180', '360'],
    answer: '360',
    explanation: 'Fixé par le juge dans la limite légale.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Mise en situation',
    question:
        'Dégradation légère d’un abribus (dommage mineur) : juridiction ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal de police',
    explanation: 'Contravention selon l’évaluation du dommage.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Vol simple d’un téléphone dans un café, sans violence :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Vol simple → correctionnel.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Vol avec arme et blessure grave de la victime :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Circonstances aggravantes → criminel.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Blanchiment d’argent (cas courant sans crime connexe) :',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal correctionnel',
    explanation: 'Délit économique/financier.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Tentative de vol à main armée (non aboutie) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Tentative de crime punissable.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Mise en situation',
    question:
        'Blessures involontaires avec ITT de 15 jours par imprudence simple :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Seuil d’ITT et faute → correctionnel.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question:
        'Outrage simple à une personne dépositaire de l’autorité publique :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Correctionnel (Code pénal).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Usage de faux document administratif (premiers faits) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Atteinte à l’autorité publique et à la confiance.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Infractions de presse',
    question: 'Injure publique simple :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Contravention',
    explanation: 'Régime spécial de la presse.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Procédure',
    question:
        'La classification influe sur la durée maximale de détention provisoire :',
    options: ['Vrai', 'Faux'],
    answer: 'Vrai',
    explanation: 'Durées et seuils varient selon la gravité.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Procédure',
    question:
        'La classification oriente aussi les compétences d’instruction (juge d’instruction) :',
    options: ['Vrai', 'Faux'],
    answer: 'Vrai',
    explanation:
        'Information judiciaire plus fréquente pour les crimes/délits complexes.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Recel d’un bien volé (cas simple) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Infraction autonome correctionnelle.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question:
        'Violences volontaires avec ITT de 10 jours sans arme ni circonstance aggravante :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Seuil d’ITT > 8 jours → correctionnel.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Vol simple commis de nuit dans un lieu habité avec effraction :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Aggravations pouvant faire basculer au criminel.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Mise en situation',
    question:
        'Conduite après usage de stupéfiants (premiers faits, hors aggravation) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Correctionnel routier.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question:
        'Conduite avec 0,25 mg/l d’air expiré (0,5 g/l sang), première constatation :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Contravention',
    explanation: 'Seuil contraventionnel (hors récidive/ circonstances).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Conduite avec 0,50 mg/l d’air expiré (1,0 g/l sang) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Seuil délictuel dépassé.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Port d’arme prohibée (couteau) sans motif légitime :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Atteinte à l’ordre public.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Infractions routières',
    question:
        'Grand excès de vitesse (≥ 50 km/h au-dessus) première constatation :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Contravention',
    explanation:
        'Contravention de 5e classe (mesures administratives associées).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Infractions routières',
    question: 'Grand excès de vitesse en récidive dans un délai légal :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Récidive légale → correctionnel.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question:
        'Entrave à la circulation sans dommage humain (manifestation non déclarée) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Atteinte à l’ordre public (textes spéciaux).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Incendie volontaire d’un véhicule sans victime ni propagation :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Destructions volontaires par incendie → criminel.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Compétence',
    question: 'Qui juge la “réception d’un bien volé” (recel) ?',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal correctionnel',
    explanation: 'Infraction correctionnelle.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Procédure',
    question: 'Le jury de cour d’assises prête serment :',
    options: ['Vrai', 'Faux'],
    answer: 'Vrai',
    explanation: 'Serment avant de siéger et de juger.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Harcèlement moral au travail (cas simple) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Correctionnel (Code pénal/Code du travail).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question:
        'Escroquerie à la carte bancaire (sommes modestes, sans bande organisée) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Infraction patrimoniale correctionnelle.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Définitions',
    question: 'La contrainte pénale (ou suivi renforcé) appartient :',
    options: ['Aux mesures d’enquête', 'Aux peines', 'Aux mesures civiles'],
    answer: 'Aux peines',
    explanation: 'Peine alternative/ aménagement, selon régime en vigueur.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Faux et usage de faux en écriture privée (cas simple) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Correctionnel.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question:
        'Agression sexuelle sans pénétration, majeure sur majeure, hors circonstances aggravantes :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Correctionnel (atteinte sexuelle ≠ viol).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Viol (pénétration sexuelle imposée) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Atteinte sexuelle la plus grave → criminel.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Procédure',
    question: 'L’appel d’un jugement correctionnel est porté devant :',
    options: ['Cour d’assises', 'Cour d’appel', 'Cour de cassation'],
    answer: 'Cour d’appel',
    explanation: 'Double degré de juridiction.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Procédure',
    question: 'Le pourvoi contre un arrêt d’assises se fait devant :',
    options: ['Cour d’appel', 'Cour de cassation', 'Conseil d’État'],
    answer: 'Cour de cassation',
    explanation: 'Contrôle de droit.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Mise en situation',
    question:
        'Introduction dans un domicile par ruse de jour sans violence ni effraction (vol) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Aggravation possible, mais reste correctionnel selon faits.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Administration de substances nuisibles sans ITT :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Atteinte à l’intégrité physique (selon résultats).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Spéciales',
    question: 'Traite des êtres humains :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Atteinte grave à la dignité humaine.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Procédure',
    question: 'La présence d’un avocat est obligatoire en cour d’assises :',
    options: ['Vrai', 'Faux'],
    answer: 'Vrai',
    explanation: 'Garanties procédurales renforcées.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Cour criminelle',
    question: 'La cour criminelle connaît en principe des crimes punis :',
    options: ['De 10 ans', 'De 15 ou 20 ans', 'Uniquement de la perpétuité'],
    answer: 'De 15 ou 20 ans',
    explanation: 'Périmètre légal (hors exceptions).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Vote',
    question: 'En assises, le vote sur la peine doit respecter :',
    options: ['Une majorité simple', 'Une majorité qualifiée', 'L’unanimité'],
    answer: 'Une majorité qualifiée',
    explanation: 'Règles identiques à la culpabilité (selon degré).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Procédure',
    question: 'La détention provisoire est plus encadrée pour :',
    options: ['Les contraventions', 'Les délits', 'Les crimes'],
    answer: 'Les crimes',
    explanation:
        'Seuils et durées maximales plus élevées mais fortement encadrées.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Peines',
    question: 'Interdiction des droits civiques (vote, éligibilité…) :',
    options: ['Peine complémentaire', 'Mesure de sûreté', 'Contravention'],
    answer: 'Peine complémentaire',
    explanation: 'Possible en correctionnel/criminel selon texte.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question:
        'Homicide involontaire avec violation délibérée d’une obligation de prudence (alcool + vitesse) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation: 'Correctionnel avec aggravation de la peine.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question:
        'Vol avec arme en bande organisée avec enlèvement de la victime :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Multiples aggravations → criminel.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Séquestration de 8 heures sans motifs légitimes :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Atteinte grave à la liberté → criminel.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Cour criminelle',
    question:
        'En cour criminelle départementale, le nombre de magistrats est :',
    options: ['3', '5', '7'],
    answer: '5',
    explanation: 'Collégialité de cinq magistrats.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Procédure',
    question: 'La participation du public en cour d’assises est :',
    options: ['Active', 'Par tirage au sort de jurés', 'Inexistante'],
    answer: 'Par tirage au sort de jurés',
    explanation: 'Jury populaire tiré au sort.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Vote',
    question:
        'En assises, si la majorité requise n’est pas atteinte pour la culpabilité :',
    options: ['Acquittement', 'Renvoi automatique', 'Peine réduite'],
    answer: 'Acquittement',
    explanation: 'Le doute profite à l’accusé.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Spéciales',
    question:
        'Violences volontaires ayant entraîné une mutilation permanente :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Gravité des conséquences corporelles.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Spéciales',
    question: 'Association de malfaiteurs en vue d’un crime :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Finalité criminelle.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Peines',
    question: 'La peine de sûreté (période incompressible de réclusion) :',
    options: ['Contravention', 'Délit', 'Criminel'],
    answer: 'Criminel',
    explanation: 'Attachée aux peines criminelles lourdes.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Corruption d’agent public (corruption active) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation:
        'Atteinte à la probité publique → correctionnel (peines élevées).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Trafic d’armes à feu en bande organisée :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Gravité et organisation → criminel.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question:
        'Aide à l’entrée/ séjour irrégulier en bande organisée, avec mise en danger :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Crime',
    explanation: 'Aggravations pouvant relever du criminel.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Vote',
    question: 'En cour d’assises, le président a-t-il une voix prépondérante ?',
    options: ['Oui', 'Non'],
    answer: 'Non',
    explanation:
        'Le président délibère avec la même valeur de voix qu’un juré ou qu’un assesseur.',
    difficulty: 'Moyenne',
  ),

  // ------ JURIDICTIONS / COMPOSITION ------
  QuizQuestion(
    category: 'Cour d’assises',
    question: 'Combien de jurés populaires siègent en première instance ?',
    options: ['3', '6', '9'],
    answer: '6',
    explanation:
        'En première instance : 6 jurés + 3 magistrats professionnels.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Cour d’assises',
    question: 'Combien de jurés populaires siègent en appel ?',
    options: ['6', '9', '12'],
    answer: '9',
    explanation: 'En appel : 9 jurés + 3 magistrats professionnels.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Cour d’assises',
    question: 'La cour d’assises juge principalement :',
    options: ['Les contraventions', 'Les délits', 'Les crimes'],
    answer: 'Les crimes',
    explanation:
        'Compétence criminelle de principe (infractions les plus graves).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Tribunal correctionnel',
    question: 'Le tribunal correctionnel statue en principe en formation :',
    options: ['Collégiale', 'Juge unique', 'Avec jurés populaires'],
    answer: 'Collégiale',
    explanation:
        'Formation collégiale de principe ; le juge unique est possible pour certains délits.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tribunal de police',
    question: 'Le tribunal de police statue en principe avec :',
    options: ['Un juge unique', 'Trois juges', 'Des jurés'],
    answer: 'Un juge unique',
    explanation:
        'Juridiction compétente pour les contraventions, siégeant à juge unique.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
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
  QuizQuestion(
    category: 'Compétence',
    question:
        'Un homicide involontaire commis par imprudence à la circulation est en principe :',
    options: ['Un crime', 'Un délit', 'Une contravention'],
    answer: 'Un délit',
    explanation: 'Il relève du tribunal correctionnel (délit).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Compétence',
    question: 'Un viol est en principe jugé par :',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Cour d’assises',
    explanation: 'Le viol est un crime : compétence de la cour d’assises.',
    difficulty: 'Facile',
  ),

  // ------ TERRITORIALE / LIEU DE L’INFRACTION ------
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Procédure',
    question: 'La CRPC (plaider-coupable) concerne :',
    options: ['Les délits', 'Les crimes', 'Toutes les contraventions'],
    answer: 'Les délits',
    explanation:
        'Procédure de comparution sur reconnaissance préalable de culpabilité : uniquement pour des délits.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Mise en situation',
    question:
        'Tapage nocturne (réitéré) avec constat par procès-verbal : relève en principe de…',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Contravention',
    explanation:
        'Les troubles de voisinage/tapage relèvent généralement du régime contraventionnel.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question:
        'Vol à l’étalage simple (faible valeur, sans circonstance aggravante) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation:
        'Le vol est un délit sauf aggravations (bande organisée, armes, violences…).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question:
        'Conduite sous l’empire d’un état alcoolique délictuel (taux délit) :',
    options: ['Tribunal de police', 'Tribunal correctionnel', 'Cour d’assises'],
    answer: 'Tribunal correctionnel',
    explanation:
        'Les délits routiers (seuils délictueux) relèvent du tribunal correctionnel.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mise en situation',
    question: 'Harcèlement moral au travail (hors cas contraventionnels) :',
    options: ['Contravention', 'Délit', 'Crime'],
    answer: 'Délit',
    explanation:
        'Relève du tribunal correctionnel (texte incriminateur spécifique).',
    difficulty: 'Moyenne',
  ),

  // ------ APPEL / COUR D’APPEL ------
  QuizQuestion(
    category: 'Appel',
    question: 'Les arrêts de la cour d’assises sont susceptibles :',
    options: ['D’opposition', 'D’appel', 'Uniquement de pourvoi en cassation'],
    answer: 'D’appel',
    explanation:
        'Possibilité d’appel des arrêts d’assises devant une autre cour d’assises d’appel.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Appel',
    question: 'Les jugements du tribunal correctionnel sont susceptibles :',
    options: ['D’appel', 'Uniquement de pourvoi', 'Jamais de recours'],
    answer: 'D’appel',
    explanation:
        'La voie d’appel est ouverte sous conditions de délais et d’intérêt à agir.',
    difficulty: 'Facile',
  ),

  // ------ ÉLÉMENTS GÉNÉRAUX / RAPPELS ------
  QuizQuestion(
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
  QuizQuestion(
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
  QuizQuestion(
    category: 'Vote',
    question:
        'En cour d’assises, la culpabilité est acquise si la majorité requise est atteinte lors du vote à bulletins secrets.',
    options: ['Vrai', 'Faux'],
    answer: 'Vrai',
    explanation:
        'Le vote se fait à bulletins secrets ; une majorité qualifiée est exigée par la loi.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
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
  QuizQuestion(
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
class QuizClassificationInfractionsPage extends StatefulWidget {
  static const String routeName =
      '/gpx/generalites/quiz/classification_infractions';
  final String uid;
  final String email;

  const QuizClassificationInfractionsPage({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizClassificationInfractionsPage> createState() =>
      _QuizClassificationInfractionsPageState();
}

class _QuizClassificationInfractionsPageState
    extends State<QuizClassificationInfractionsPage>
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
  _selectedDifficulty; // "Facile" | "Moyenne" | "Difficile" | tokens normalisés
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
  /// (insensible casse/variantes ; ex: "Moyen" -> "moyenne")
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

    // Filtrage robuste : compare sur token normalisé des 2 côtés
    final filtered = useAll
        ? questionsClassificationInfractions
        : questionsClassificationInfractions
              .where((q) => _difficultyToken(q.difficulty) == selectedToken)
              .toList();

    // Fallback si aucune question ne matche (évite page vide)
    final pool = filtered.isEmpty
        ? questionsClassificationInfractions
        : filtered;

    _qs = List<QuizQuestion>.from(pool)..shuffle(_rng);
    _opts = _qs
        .map((q) => (List<String>.from(q.options)..shuffle(_rng)))
        .toList();
    _answers = List<String?>.filled(_qs.length, null);
    _hasQuiz = true;

    debugPrint(
      '🎯 Start quiz — mix=$_mixMode, selected=$_selectedDifficulty '
      '→ ${_qs.length} questions',
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
            'module_name': 'Généralités',
            'quiz_name': 'Classification des infractions',
            'score': 0,
            'total_questions': _qs.length,
            'correct_count': 0,
            'started_at': nowUtc,
            // ✅ ces 2 champs sont NOT NULL dans ton schéma → on met une valeur initiale
            'finished_at': nowUtc,
            'completed_at': nowUtc,
          })
          .select('id')
          .single();

      _historyRowId = (res['id'] as num).toInt();
      debugPrint('✅ quiz_history start id=$_historyRowId');
    } on PostgrestException catch (e) {
      debugPrint(
        '❌ quiz_history (start) Postgrest: ${e.message} | ${e.details}',
      );
    } catch (e, st) {
      debugPrint('❌ quiz_history (start) error: $e\n$st');
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
            // si ta colonne "completed_at" est *sans* time zone, envoie locale:
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _historyRowId!)
          .eq('uid', u.id)
          .select('id')
          .maybeSingle();

      debugPrint('✅ quiz_history finish updated: $res');
    } on PostgrestException catch (e) {
      debugPrint(
        '❌ quiz_history (finish) Postgrest: ${e.message} | ${e.details}',
      );
    } catch (e, st) {
      debugPrint('❌ quiz_history (finish) error: $e\n$st');
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
      final u = _requireUser();
      final res = await _sb
          .from('quiz_classification_infractions')
          .insert({
            'uid': u.id,
            'email': u.email ?? '',
            'question': question,
            'user_answer': userAnswer,
            'correct_answer': correctAnswer,
            'is_correct': isCorrect,
          })
          .select('id')
          .single();

      // 🎨 Couleurs ANSI : vert pour bonne réponse, rouge pour mauvaise
      final color = isCorrect ? '\x1B[32m' : '\x1B[31m'; // vert ou rouge
      final reset = '\x1B[0m';

      debugPrint(
        '$color📝 Réponse #${res['id']} sauvegardée (${isCorrect ? "✔️  Correcte" : "❌ Incorrecte"})$reset',
      );
    } on PostgrestException catch (e) {
      debugPrint('❌ quiz_answer insert Postgrest: ${e.message} | ${e.details}');
    } catch (e, st) {
      debugPrint('❌ quiz_answer insert error: $e\n$st');
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

  // ==========================================================================
  // UI (inchangé)
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
                              // on accepte tout (facile/Moyen/…)
                              // le filtrage normalise ensuite
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
                                // ✅ activation via token normalisé
                                active: _is('facile'),
                                // ✅ onSelect envoie toujours un token normalisé
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
