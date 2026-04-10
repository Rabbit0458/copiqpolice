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

final List<QuizQuestion> questionOrdonnanceProtection = [
  // =========================================================
  // DÉFAUT DE NOTIFICATION DE CHANGEMENT DE DOMICILE AU CRÉANCIER — FONDEMENTS
  // =========================================================
  QuizQuestion(
    category: 'Défaut de notification — Fondement',
    question:
        'Le défaut de notification de changement de domicile au créancier est prévu par :',
    options: [
      'L’article 227-4-3 du Code pénal',
      'L’article 227-4-2 du Code pénal',
      'L’article 227-22 du Code pénal',
    ],
    answer: 'L’article 227-4-3 du Code pénal',
    explanation:
        'L’élément légal de l’infraction est fixé par l’article 227-4-3 du Code pénal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Fondement',
    question:
        'Le défaut de notification de changement de domicile au créancier est prévu par :',
    options: [
      'L’article 227-4-3 du Code pénal',
      'L’article 227-4-2 du Code pénal',
      'L’article 227-22 du Code pénal',
    ],
    answer: 'L’article 227-4-3 du Code pénal',
    explanation:
        'L’élément légal de l’infraction est fixé par l’article 227-4-3 du Code pénal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Fondement',
    question:
        'L’infraction vise une personne tenue de verser une contribution ou des subsides au titre :',
    options: [
      'D’une ordonnance de protection rendue en application de l’article 515-9 du code civil',
      'D’un jugement de divorce définitif uniquement',
      'D’une simple main courante',
    ],
    answer:
        'D’une ordonnance de protection rendue en application de l’article 515-9 du code civil',
    explanation:
        'Le texte vise la personne tenue de verser une contribution ou des subsides au titre de l’ordonnance de protection (art. 515-9 C. civ.).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Fondement',
    question:
        'Le débiteur doit notifier son changement de domicile au créancier dans un délai de :',
    options: [
      'Un mois à compter du changement',
      'Quinze jours à compter du changement',
      'Deux mois à compter du changement',
    ],
    answer: 'Un mois à compter du changement',
    explanation:
        'Le délai légal est d’un mois à compter du changement de domicile.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question:
        'Concernant la forme de la notification du changement de domicile, le texte :',
    options: [
      'Ne prévoit aucune exigence de forme',
      'Impose une lettre recommandée avec AR',
      'Impose une signification par commissaire de justice',
    ],
    answer: 'Ne prévoit aucune exigence de forme',
    explanation:
        'Aucune exigence n’est formulée quant à la forme de la notification : l’essentiel est d’informer dans le délai.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément moral',
    question:
        'Le défaut de notification de changement de domicile est une infraction :',
    options: [
      'Intentionnelle',
      'Non intentionnelle',
      'Contraventionnelle de police',
    ],
    answer: 'Intentionnelle',
    explanation:
        'L’élément moral repose sur la volonté de ne pas informer le créancier ; la simple négligence n’est pas punissable.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // DÉFAUT DE NOTIFICATION — PRÉCISIONS / MÉCANISME
  // =========================================================
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question:
        'L’infraction a été prévue notamment car le JAF peut se prononcer dans le référé protection sur :',
    options: [
      'La contribution aux charges du ménage',
      'La nationalité',
      'Le permis de conduire',
    ],
    answer: 'La contribution aux charges du ménage',
    explanation:
        'Le cours indique que le JAF peut statuer sur la contribution aux charges du ménage, d’où l’intérêt dissuasif de l’incrimination.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question:
        'Dans ce cadre, la personne visée par 227-4-3 est principalement :',
    options: [
      'Le débiteur d’une contribution ou de subsides',
      'Le créancier uniquement',
      'Le témoin des violences',
    ],
    answer: 'Le débiteur d’une contribution ou de subsides',
    explanation:
        'L’obligation de notifier pèse sur le débiteur tenu de verser la contribution/subsides.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément moral',
    question: 'Pourquoi la simple négligence n’est-elle pas punissable ici ?',
    options: [
      'Car la volonté coupable consiste à priver le titulaire de son droit par le silence',
      'Car l’infraction est toujours une contravention',
      'Car l’infraction n’existe que si le créancier est mineur',
    ],
    answer:
        'Car la volonté coupable consiste à priver le titulaire de son droit par le silence',
    explanation:
        'Le texte insiste sur l’intention : la volonté de priver le créancier de l’exercice de son droit.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Circonstances',
    question:
        'Concernant les circonstances aggravantes du défaut de notification (227-4-3), il y en a :',
    options: [
      'Aucune',
      'Une si récidive légale',
      'Une si le débiteur déménage à l’étranger',
    ],
    answer: 'Aucune',
    explanation:
        'Le cours mentionne : « Aucune » circonstance aggravante prévue.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // DÉFAUT DE NOTIFICATION — RÉPRESSION / PROCÉDURE
  // =========================================================
  QuizQuestion(
    category: 'Défaut de notification — Répression',
    question: 'La peine encourue (personne physique) pour 227-4-3 est :',
    options: [
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '6 mois d’emprisonnement et 7 500 € d’amende',
    explanation: 'La répression prévue est : 6 mois + 7 500 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Répression',
    question: 'La classification de l’infraction 227-4-3 est :',
    options: ['Un délit', 'Une contravention', 'Un crime'],
    answer: 'Un délit',
    explanation: 'Le cours précise : classification = délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'La tentative de l’infraction 227-4-3 est :',
    options: [
      'Non punissable (tentative : non)',
      'Punissable (tentative : oui)',
      'Punissable uniquement en cas de violences',
    ],
    answer: 'Non punissable (tentative : non)',
    explanation: 'Le document indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'La complicité pour 227-4-3 est :',
    options: [
      'Applicable (article 121-7 du Code pénal)',
      'Inapplicable',
      'Applicable uniquement si le créancier est un enfant',
    ],
    answer: 'Applicable (article 121-7 du Code pénal)',
    explanation:
        'La complicité est prévue selon l’article 121-7 du Code pénal.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Personnes morales',
    question:
        'Depuis quand la responsabilité des personnes morales est applicable de façon généralisée (référence cours) ?',
    options: [
      'Depuis le 31 décembre 2005',
      'Depuis le 1er janvier 1990',
      'Depuis le 1er juillet 2025',
    ],
    answer: 'Depuis le 31 décembre 2005',
    explanation:
        'Le support mentionne l’application en la matière depuis le 31 décembre 2005 (dans le cadre de la responsabilité des personnes morales).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // NON-RESPECT DES OBLIGATIONS / INTERDICTIONS D’UNE ORDONNANCE DE PROTECTION — FONDEMENTS
  // =========================================================
  QuizQuestion(
    category: 'Violation ordonnance de protection — Fondement',
    question:
        'Le non-respect des obligations ou interdictions imposées par une ordonnance de protection est prévu par :',
    options: [
      'L’article 227-4-2 du Code pénal',
      'L’article 227-4-3 du Code pénal',
      'L’article 515-11 du code civil',
    ],
    answer: 'L’article 227-4-2 du Code pénal',
    explanation:
        'L’élément légal est fixé par l’article 227-4-2 du Code pénal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Champ',
    question:
        'L’infraction vise le non-respect d’obligations/interdictions imposées dans :',
    options: [
      'Une ordonnance de protection (art. 515-9 ou 515-13 C. civ.)',
      'Une simple médiation familiale',
      'Une audition libre',
    ],
    answer: 'Une ordonnance de protection (art. 515-9 ou 515-13 C. civ.)',
    explanation:
        'Le texte vise l’ordonnance de protection rendue notamment en application des articles 515-9 ou 515-13 du code civil.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Champ',
    question:
        'Sont aussi visées par 227-4-2 les obligations/interdictions imposées dans :',
    options: [
      'Une ordonnance provisoire de protection immédiate (art. 515-13-1 C. civ.)',
      'Un PV de renseignement judiciaire',
      'Une ordonnance de non-conciliation uniquement',
    ],
    answer:
        'Une ordonnance provisoire de protection immédiate (art. 515-13-1 C. civ.)',
    explanation:
        'Le texte vise aussi l’ordonnance provisoire de protection immédiate rendue sur le fondement de l’article 515-13-1.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Champ UE',
    question:
        'Les mêmes peines s’appliquent à la violation d’une mesure de protection civile d’un autre État membre de l’UE reconnue en France via :',
    options: [
      'Le règlement (UE) n° 606/2013 du 12 juin 2013',
      'Le règlement (UE) n° 44/2001',
      'Le traité de Lisbonne',
    ],
    answer: 'Le règlement (UE) n° 606/2013 du 12 juin 2013',
    explanation:
        'Le support mentionne expressément le règlement (UE) 606/2013 relatif à la reconnaissance mutuelle des mesures de protection civiles.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ORDONNANCE DE PROTECTION — CONDITIONS (515-9) / DÉLAIS
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — Conditions',
    question:
        'Selon l’article 515-9 C. civ., l’ordonnance de protection peut être délivrée lorsque des violences au sein du couple :',
    options: [
      'Mettent en danger la victime ou un ou plusieurs enfants',
      'Sont uniquement anciennes de moins de 24h',
      'Ont déjà donné lieu à une condamnation définitive',
    ],
    answer: 'Mettent en danger la victime ou un ou plusieurs enfants',
    explanation:
        'La condition centrale : danger pour la victime (et/ou les enfants).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Conditions',
    question:
        'L’ordonnance de protection peut être délivrée même lorsqu’il n’y a pas de cohabitation :',
    options: [
      'Oui',
      'Non, la cohabitation est obligatoire',
      'Oui, mais seulement si les personnes sont mariées',
    ],
    answer: 'Oui',
    explanation:
        'Le texte vise les violences au sein du couple y compris sans cohabitation, et même sans cohabitation passée.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Délai',
    question:
        'Le JAF délivre l’ordonnance de protection dans un délai maximal de :',
    options: [
      'Six jours à compter de la fixation de la date d’audience',
      'Vingt-quatre heures à compter de la saisine',
      'Un mois à compter de la requête',
    ],
    answer: 'Six jours à compter de la fixation de la date d’audience',
    explanation:
        'Le support indique : délai maximal de six jours (OP classique).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Plainte',
    question:
        'La délivrance d’une ordonnance de protection est-elle conditionnée à une plainte pénale ?',
    options: [
      'Non',
      'Oui',
      'Oui, uniquement en cas de violences psychologiques',
    ],
    answer: 'Non',
    explanation:
        'Le texte précise que l’ordonnance n’est pas conditionnée à l’existence d’une plainte pénale.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // ORDONNANCE DE PROTECTION — MESURES POSSIBLES (515-11) : QCM
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Parmi les mesures possibles, le JAF peut interdire à la partie défenderesse :',
    options: [
      'De recevoir/rencontrer certaines personnes et d’entrer en relation avec elles',
      'D’exercer toute activité professionnelle',
      'De conduire un véhicule',
    ],
    answer:
        'De recevoir/rencontrer certaines personnes et d’entrer en relation avec elles',
    explanation: 'C’est la mesure 1° de l’article 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut interdire à la partie défenderesse de se rendre dans certains lieux fréquentés habituellement par la demanderesse :',
    options: [
      'Oui (1° bis)',
      'Non, jamais',
      'Oui, uniquement si un divorce est engagé',
    ],
    answer: 'Oui (1° bis)',
    explanation:
        'La mesure 1° bis prévoit l’interdiction de se rendre dans certains lieux.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question: 'Concernant les armes, le JAF peut notamment :',
    options: [
      'Interdire de détenir/porter une arme',
      'Imposer une peine de prison immédiate',
      'Prononcer une interdiction de vote',
    ],
    answer: 'Interdire de détenir/porter une arme',
    explanation: 'C’est la mesure 2° de l’article 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut ordonner à la partie défenderesse de remettre ses armes :',
    options: [
      'Au service de police ou de gendarmerie le plus proche du domicile',
      'À la mairie',
      'À l’employeur',
    ],
    answer: 'Au service de police ou de gendarmerie le plus proche du domicile',
    explanation:
        'Mesure 2° bis : remise au service de police/gendarmerie le plus proche.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut proposer une prise en charge sanitaire/sociale/psychologique ou un stage de responsabilisation :',
    options: [
      'Oui (2° ter)',
      'Non, c’est uniquement le rôle du procureur',
      'Oui, mais seulement pour la victime',
    ],
    answer: 'Oui (2° ter)',
    explanation:
        'Mesure 2° ter : proposition de prise en charge ou stage ; en cas de refus, information immédiate du procureur.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Concernant le logement conjugal, sauf circonstances particulières, la jouissance est attribuée :',
    options: [
      'Au conjoint qui n’est pas l’auteur des violences',
      'Au conjoint qui a le plus de revenus',
      'Au conjoint le plus ancien dans le logement',
    ],
    answer: 'Au conjoint qui n’est pas l’auteur des violences',
    explanation:
        'Le principe : protection de la victime, attribution au non-auteur des violences.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut attribuer la jouissance de l’animal de compagnie détenu au sein du foyer :',
    options: ['Oui (3° bis)', 'Non', 'Oui, uniquement si l’animal est assuré'],
    answer: 'Oui (3° bis)',
    explanation:
        'L’article 515-11 prévoit la mesure 3° bis sur l’animal de compagnie.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Pour des partenaires PACS/concubins, la jouissance du logement commun est attribuée en principe :',
    options: [
      'Au partenaire/concubin qui n’est pas l’auteur des violences',
      'Au propriétaire du bail, quoi qu’il arrive',
      'Au partenaire le plus âgé',
    ],
    answer: 'Au partenaire/concubin qui n’est pas l’auteur des violences',
    explanation:
        'Le même principe protecteur est prévu au 4° pour PACS/concubins.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut se prononcer sur l’autorité parentale et aussi sur :',
    options: [
      'Le droit de visite/hébergement et les contributions (mariage/PACS/enfants)',
      'L’inscription à Pôle emploi',
      'Le retrait de permis',
    ],
    answer:
        'Le droit de visite/hébergement et les contributions (mariage/PACS/enfants)',
    explanation:
        'Mesure 5° : autorité parentale, DVH, et contributions selon la situation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut autoriser la demanderesse à dissimuler son domicile et élire domicile :',
    options: [
      'Chez l’avocat ou auprès du procureur de la République (pour les instances civiles)',
      'Uniquement au commissariat',
      'Uniquement chez un membre de la famille',
    ],
    answer:
        'Chez l’avocat ou auprès du procureur de la République (pour les instances civiles)',
    explanation:
        'Mesure 6° : dissimulation + élection de domicile chez avocat ou auprès du procureur.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut aussi autoriser une élection de domicile « pour les besoins de la vie courante » :',
    options: [
      'Chez une personne morale qualifiée (6° bis)',
      'Uniquement chez le notaire',
      'Uniquement à la préfecture',
    ],
    answer: 'Chez une personne morale qualifiée (6° bis)',
    explanation:
        'Mesure 6° bis : élection de domicile vie courante auprès d’une personne morale qualifiée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut prononcer l’admission provisoire à l’aide juridictionnelle :',
    options: [
      'Oui (7°)',
      'Non, jamais',
      'Oui, mais seulement pour la partie défenderesse',
    ],
    answer: 'Oui (7°)',
    explanation: 'Mesure 7° : admission provisoire à l’aide juridictionnelle.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // DISPOSITIF ANTI-RAPPROCHEMENT (515-11-1) — QCM
  // =========================================================
  QuizQuestion(
    category: 'Dispositif anti-rapprochement — 515-11-1',
    question:
        'Si l’interdiction d’entrer en relation (1°) est prononcée, le JAF peut aussi :',
    options: [
      'Fixer une distance minimale et ordonner un dispositif anti-rapprochement',
      'Ordonner une détention provisoire automatique',
      'Prononcer une expulsion locative sans décision',
    ],
    answer:
        'Fixer une distance minimale et ordonner un dispositif anti-rapprochement',
    explanation:
        'L’article 515-11-1 permet l’interdiction de se rapprocher à moins d’une certaine distance + dispositif anti-rapprochement.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ORDONNANCE (515-13) — MARIAGE FORCÉ / SORTIE DU TERRITOIRE
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — Mariage forcé (515-13)',
    question:
        'L’article 515-13 permet une ordonnance de protection en urgence pour :',
    options: [
      'Une personne majeure menacée de mariage forcé',
      'Toute personne souhaitant changer de nom',
      'Un mineur voulant se marier',
    ],
    answer: 'Une personne majeure menacée de mariage forcé',
    explanation:
        'Le texte vise expressément la personne majeure menacée de mariage forcé.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mariage forcé (515-13)',
    question:
        'Dans ce cadre, le JAF peut ordonner à la demande de la personne :',
    options: [
      'Une interdiction temporaire de sortie du territoire',
      'Une interdiction définitive de quitter la ville',
      'Une saisie automatique du passeport par l’employeur',
    ],
    answer: 'Une interdiction temporaire de sortie du territoire',
    explanation:
        'L’article 515-13 mentionne l’interdiction temporaire de sortie du territoire.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mariage forcé (515-13)',
    question:
        'L’interdiction temporaire de sortie du territoire est inscrite au FPR par :',
    options: ['Le procureur de la République', 'Le maire', 'Le préfet'],
    answer: 'Le procureur de la République',
    explanation:
        'Le support précise l’inscription au FPR par le procureur de la République.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ORDONNANCE PROVISOIRE DE PROTECTION IMMÉDIATE (515-13-1) — 24H
  // =========================================================
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question:
        'L’ordonnance provisoire de protection immédiate est délivrée dans un délai de :',
    options: [
      '24 heures à compter de la saisine',
      '6 jours à compter de la fixation d’audience',
      '15 jours à compter de l’enquête',
    ],
    answer: '24 heures à compter de la saisine',
    explanation:
        'Le texte indique : délivrée dans un délai de vingt-quatre heures.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question:
        'Qui peut demander, avec l’accord de la personne en danger, une OPPI en plus de la demande d’OP ?',
    options: ['Le ministère public', 'Le greffe', 'La mairie'],
    answer: 'Le ministère public',
    explanation:
        'L’article 515-13-1 prévoit la demande par le ministère public avec l’accord de la personne en danger.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'Pour délivrer l’OPPI, le JAF statue :',
    options: [
      'Au vu des seuls éléments joints à la requête',
      'Après une enquête de flagrance obligatoire',
      'Uniquement après audition de 3 témoins',
    ],
    answer: 'Au vu des seuls éléments joints à la requête',
    explanation:
        'L’OPPI est délivrée sur la base des éléments joints à la requête (sans débat contradictoire complet).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // VIOLATION ORDONNANCE DE PROTECTION — ÉLÉMENT MATÉRIEL / MORAL
  // =========================================================
  QuizQuestion(
    category: 'Violation ordonnance de protection — Élément matériel',
    question: 'L’élément matériel de 227-4-2 consiste à :',
    options: [
      'Ne pas se conformer aux obligations/interdictions imposées',
      'Ne pas payer une amende forfaitaire',
      'Refuser une audition libre',
    ],
    answer: 'Ne pas se conformer aux obligations/interdictions imposées',
    explanation:
        'La violation est le non-respect des obligations/interdictions fixées par l’ordonnance.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Élément moral',
    question: 'L’infraction 227-4-2 est :',
    options: [
      'Intentionnelle',
      'Non intentionnelle',
      'Une simple faute civile',
    ],
    answer: 'Intentionnelle',
    explanation:
        'Le support précise une infraction intentionnelle : l’auteur agit en connaissance de cause des obligations/interdictions.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Élément moral',
    question: 'Pour caractériser l’élément moral, l’auteur doit notamment :',
    options: [
      'Avoir été informé des termes de l’ordonnance',
      'Avoir changé de travail',
      'Avoir contesté la procédure au civil',
    ],
    answer: 'Avoir été informé des termes de l’ordonnance',
    explanation:
        'La connaissance des obligations/interdictions suppose que l’auteur ait été informé de l’ordonnance.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Finalité',
    question: 'Le texte 227-4-2 vise à rendre l’ordonnance de protection :',
    options: [
      'Pleinement effective et contraignante',
      'Optionnelle',
      'Uniquement symbolique',
    ],
    answer: 'Pleinement effective et contraignante',
    explanation:
        'Le cours insiste sur l’effectivité : sanctionner pénalement la violation pour rendre la mesure réellement protectrice.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // VIOLATION ORDONNANCE DE PROTECTION — RÉPRESSION / PROCÉDURE
  // =========================================================
  QuizQuestion(
    category: 'Violation ordonnance de protection — Répression',
    question: 'La peine encourue (personne physique) pour 227-4-2 est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '10 ans de réclusion et 150 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'La répression prévue par 227-4-2 est de 3 ans et 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Classification',
    question: 'La classification de l’infraction 227-4-2 est :',
    options: ['Un délit', 'Un crime', 'Une contravention'],
    answer: 'Un délit',
    explanation: 'Le cours précise : délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Circonstances',
    question:
        'Concernant les circonstances aggravantes de 227-4-2 (cours), il y en a :',
    options: ['Aucune', 'Deux', 'Uniquement la récidive'],
    answer: 'Aucune',
    explanation: 'Le support indique : aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Tentative / complicité',
    question: 'La tentative de 227-4-2 est :',
    options: [
      'Non punissable (tentative : non)',
      'Punissable (tentative : oui)',
      'Toujours punissable en correctionnelle',
    ],
    answer: 'Non punissable (tentative : non)',
    explanation: 'Le document précise : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Tentative / complicité',
    question: 'La complicité pour 227-4-2 est :',
    options: [
      'Oui (article 121-7 du Code pénal)',
      'Non, jamais',
      'Oui, uniquement si l’auteur est mineur',
    ],
    answer: 'Oui (article 121-7 du Code pénal)',
    explanation:
        'La complicité est applicable conformément à l’article 121-7 du Code pénal.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // QUESTIONS MIXTES (COMPARAISONS 227-4-2 / 227-4-3)
  // =========================================================
  QuizQuestion(
    category: 'Comparatif — 227-4-2 vs 227-4-3',
    question:
        'Quelle infraction est la plus lourdement sanctionnée (peine d’emprisonnement) ?',
    options: ['227-4-2 (3 ans)', '227-4-3 (6 mois)', 'Elles sont identiques'],
    answer: '227-4-2 (3 ans)',
    explanation: '227-4-2 prévoit 3 ans, tandis que 227-4-3 prévoit 6 mois.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparatif — 227-4-2 vs 227-4-3',
    question:
        'Quelle infraction concerne spécifiquement le changement de domicile du débiteur ?',
    options: ['227-4-3', '227-4-2', '515-11'],
    answer: '227-4-3',
    explanation:
        '227-4-3 incrimine le défaut de notification du changement de domicile au créancier.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparatif — Élément moral',
    question: 'Point commun entre 227-4-2 et 227-4-3 :',
    options: [
      'Ce sont des infractions intentionnelles',
      'Ce sont des contraventions',
      'Elles exigent une plainte pénale préalable',
    ],
    answer: 'Ce sont des infractions intentionnelles',
    explanation:
        'Les deux supposent une volonté : ne pas se conformer / ne pas informer.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Comparatif — Tentative',
    question: 'Concernant la tentative, 227-4-2 et 227-4-3 :',
    options: [
      'Ne prévoient pas la tentative (tentative : non)',
      'Prévoient toutes deux la tentative',
      'Prévoient la tentative seulement en cas de récidive',
    ],
    answer: 'Ne prévoient pas la tentative (tentative : non)',
    explanation:
        'Le support indique “TENTATIVE : NON” pour les deux infractions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Comparatif — Complicité',
    question: 'Concernant la complicité (121-7 CP), pour 227-4-2 et 227-4-3 :',
    options: [
      'Elle est applicable pour les deux',
      'Elle est exclue pour les deux',
      'Elle n’est applicable que pour 227-4-3',
    ],
    answer: 'Elle est applicable pour les deux',
    explanation:
        'Les deux supports indiquent “COMPLICITÉ : OUI” + référence à l’article 121-7 CP.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // QUESTIONS "PIÈGES" / PRÉCISION DE TEXTE (PLUS DIFFICILES)
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — Durée',
    question:
        'Les mesures de l’ordonnance de protection peuvent être prises pour une durée maximale de :',
    options: [
      '12 mois (prolongeable sous conditions)',
      '6 mois non prolongeable',
      '24 mois automatiquement',
    ],
    answer: '12 mois (prolongeable sous conditions)',
    explanation:
        'Le support mentionne une durée maximale de 12 mois, prolongeable sous certaines conditions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Logement',
    question:
        'Sauf circonstances particulières, la jouissance du logement est attribuée :',
    options: [
      'À la personne non auteure des violences',
      'À la personne ayant l’autorité parentale exclusive',
      'Toujours au titulaire du bail',
    ],
    answer: 'À la personne non auteure des violences',
    explanation:
        'Principe protecteur : attribution au non-auteur (sauf ordonnance motivée/circonstances particulières).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Domicile dissimulé',
    question:
        'Si un commissaire de justice doit connaître l’adresse réelle pour exécuter une décision :',
    options: [
      'L’adresse lui est communiquée, mais il ne peut pas la révéler à son mandant',
      'L’adresse ne peut jamais être communiquée à personne',
      'L’adresse est rendue publique au dossier',
    ],
    answer:
        'L’adresse lui est communiquée, mais il ne peut pas la révéler à son mandant',
    explanation:
        'Le support précise la communication nécessaire pour l’exécution, avec interdiction de révélation au mandant.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Information autorités',
    question:
        'Quand les mesures 6°/6° bis sont prononcées, qui peut être informé (avec accord de la personne) pour éviter la communication de l’adresse ?',
    options: [
      'Le maire et le représentant de l’État dans le département',
      'Uniquement le préfet de police de Paris',
      'Uniquement le bâtonnier',
    ],
    answer: 'Le maire et le représentant de l’État dans le département',
    explanation:
        'Le support indique l’information du maire et du représentant de l’État dans le département, sous réserve de l’accord de la personne.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Fin des mesures',
    question: 'Les mesures de l’OPPI prennent fin :',
    options: [
      'À compter de la décision statuant sur la demande d’OP (ou incident mettant fin à l’instance)',
      'Uniquement au bout de 12 mois',
      'Quand la victime le décide seule',
    ],
    answer:
        'À compter de la décision statuant sur la demande d’OP (ou incident mettant fin à l’instance)',
    explanation:
        'Le support précise la fin des mesures à compter de la décision sur la demande d’OP ou incident mettant fin à l’instance.',
    difficulty: 'Difficile',
  ),
  // =========================================================
  // PACK ENORME #3 — DÉFAUT DE NOTIFICATION (227-4-3) + VIOLATION OP (227-4-2)
  // + OP / OPPI (515-9 à 515-13-1) + MESURES (515-11 / 515-11-1)
  // =========================================================

  // -----------------------------
  // 227-4-3 — ÉLÉMENT LÉGAL / CHAMP
  // -----------------------------
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question:
        'Le défaut de notification de changement de domicile au créancier est réprimé par :',
    options: [
      'L’article 227-4-3 du Code pénal',
      'L’article 227-4-2 du Code pénal',
      'L’article 515-11 du code civil',
    ],
    answer: 'L’article 227-4-3 du Code pénal',
    explanation: 'L’élément légal est prévu à l’article 227-4-3 du Code pénal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question: 'L’infraction 227-4-3 concerne une personne tenue de verser :',
    options: [
      'Une contribution ou des subsides au titre d’une ordonnance de protection',
      'Une amende forfaitaire délictuelle',
      'Une caution pénale',
    ],
    answer:
        'Une contribution ou des subsides au titre d’une ordonnance de protection',
    explanation:
        'Le texte vise la personne tenue de verser une contribution/subsides au titre de l’ordonnance de protection.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question:
        'Le délai légal pour notifier son changement de domicile au créancier est :',
    options: [
      'Un mois à compter du changement',
      'Quinze jours à compter du changement',
      'Trois mois à compter du changement',
    ],
    answer: 'Un mois à compter du changement',
    explanation: 'Le support fixe un délai d’un mois.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question: 'La notification du changement de domicile au créancier :',
    options: [
      'N’est soumise à aucune exigence de forme',
      'Doit être faite par LRAR',
      'Doit être faite par commissaire de justice',
    ],
    answer: 'N’est soumise à aucune exigence de forme',
    explanation: 'Le texte précise qu’aucune forme n’est exigée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question:
        'L’ordonnance de protection visée pour 227-4-3 est rendue en application de :',
    options: [
      'L’article 515-9 du code civil',
      'L’article 515-4 du code civil',
      'L’article 227-22 du Code pénal',
    ],
    answer: 'L’article 515-9 du code civil',
    explanation:
        'Le support vise expressément l’ordonnance de protection rendue selon 515-9.',
    difficulty: 'Moyenne',
  ),

  // -----------------------------
  // 227-4-3 — ÉLÉMENT MATÉRIEL / LOGIQUE DISUASIVE
  // -----------------------------
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question:
        'L’incrimination 227-4-3 a été prévue notamment car le JAF peut statuer, en référé protection, sur :',
    options: [
      'La contribution aux charges du ménage',
      'La délivrance d’un titre de séjour',
      'La liquidation d’une succession',
    ],
    answer: 'La contribution aux charges du ménage',
    explanation:
        'Le support justifie l’infraction par la nécessité dissuasive liée aux contributions.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question: 'L’acte matériel réprimé par 227-4-3 est :',
    options: [
      'Ne pas notifier son changement de domicile au créancier dans le délai légal',
      'Ne pas se présenter à une convocation de police',
      'Ne pas payer une pension dans le mois',
    ],
    answer:
        'Ne pas notifier son changement de domicile au créancier dans le délai légal',
    explanation:
        'Le cœur de l’infraction est l’absence de notification dans le délai d’un mois.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question: 'Le délai d’un mois court :',
    options: [
      'À compter du changement de domicile',
      'À compter de la signification par huissier',
      'À compter de la plainte pénale',
    ],
    answer: 'À compter du changement de domicile',
    explanation: 'Le texte indique : “à compter de ce changement”.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question: 'Le texte précise que la notification doit être faite :',
    options: [
      'Au créancier',
      'Au juge aux affaires familiales uniquement',
      'Au procureur de la République uniquement',
    ],
    answer: 'Au créancier',
    explanation: 'L’obligation est d’informer le créancier.',
    difficulty: 'Facile',
  ),

  // -----------------------------
  // 227-4-3 — ÉLÉMENT MORAL
  // -----------------------------
  QuizQuestion(
    category: 'Défaut de notification — Élément moral',
    question:
        'Le défaut de notification de changement de domicile (227-4-3) est une infraction :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Contraventionnelle'],
    answer: 'Intentionnelle',
    explanation:
        'Le support indique une volonté de ne pas informer le créancier.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément moral',
    question: 'La simple négligence est punissable pour 227-4-3 :',
    options: ['Non', 'Oui', 'Oui si le créancier le demande'],
    answer: 'Non',
    explanation:
        'Le support précise que la simple négligence n’est pas punissable.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément moral',
    question: 'La volonté coupable, pour 227-4-3, consiste à :',
    options: [
      'Vouloir, par son silence, priver le créancier de l’exercice d’un droit',
      'Oublier sans s’en rendre compte',
      'Changer d’adresse trop souvent',
    ],
    answer:
        'Vouloir, par son silence, priver le créancier de l’exercice d’un droit',
    explanation:
        'Le support décrit la finalité du silence : priver le titulaire du droit.',
    difficulty: 'Difficile',
  ),

  // -----------------------------
  // 227-4-3 — RÉPRESSION / TENTATIVE / COMPLICITÉ
  // -----------------------------
  QuizQuestion(
    category: 'Défaut de notification — Répression',
    question: 'La peine encourue pour 227-4-3 (personne physique) est :',
    options: [
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '6 mois d’emprisonnement et 7 500 € d’amende',
    explanation: 'Le support fixe : 6 mois + 7 500 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Répression',
    question: 'La classification de 227-4-3 est :',
    options: ['Délit', 'Contravention', 'Crime'],
    answer: 'Délit',
    explanation: 'Le tableau répressif indique : délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'Pour 227-4-3, la tentative est :',
    options: ['Non', 'Oui', 'Oui si plusieurs déménagements'],
    answer: 'Non',
    explanation: 'Le support indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'Pour 227-4-3, la complicité est :',
    options: [
      'Oui (article 121-7 CP)',
      'Non (jamais)',
      'Oui seulement si le complice est un proche',
    ],
    answer: 'Oui (article 121-7 CP)',
    explanation: 'Le support indique : COMPLICITÉ : OUI, article 121-7 CP.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Circonstances aggravantes',
    question: 'Pour 227-4-3, les circonstances aggravantes prévues sont :',
    options: ['Aucune', 'Deux', 'Une en cas d’enfant mineur'],
    answer: 'Aucune',
    explanation: 'Le support mentionne : aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // 227-4-2 — NON-RESPECT DES OBLIGATIONS / INTERDICTIONS (OP / OPPI)
  // =========================================================

  // -----------------------------
  // 227-4-2 — ÉLÉMENT LÉGAL / CHAMP
  // -----------------------------
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question:
        'Le non-respect des obligations ou interdictions imposées par une ordonnance de protection est réprimé par :',
    options: [
      'L’article 227-4-2 du Code pénal',
      'L’article 227-4-3 du Code pénal',
      'L’article 515-9 du code civil',
    ],
    answer: 'L’article 227-4-2 du Code pénal',
    explanation: 'L’élément légal est prévu à l’article 227-4-2 du Code pénal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question:
        'Le texte vise une personne faisant l’objet d’une ou plusieurs obligations/interdictions imposées dans :',
    options: [
      'Une ordonnance de protection (515-9 ou 515-13) ou une OPPI (515-13-1)',
      'Un jugement pénal définitif uniquement',
      'Une main courante',
    ],
    answer:
        'Une ordonnance de protection (515-9 ou 515-13) ou une OPPI (515-13-1)',
    explanation: 'Le support vise OP (515-9/515-13) + OPPI (515-13-1).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question:
        'Les mêmes peines s’appliquent aussi à la violation d’une mesure civile ordonnée dans un autre État membre de l’UE si elle est :',
    options: [
      'Reconnue et exécutoire en France',
      'Simplement traduite en français',
      'Uniquement connue de la victime',
    ],
    answer: 'Reconnue et exécutoire en France',
    explanation:
        'Le support exige reconnaissance + force exécutoire en France.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question: 'Le texte UE cité dans le support est :',
    options: [
      'Le règlement (UE) n° 606/2013 du 12 juin 2013',
      'Le règlement (UE) n° 2016/679',
      'Le règlement (CE) n° 44/2001',
    ],
    answer: 'Le règlement (UE) n° 606/2013 du 12 juin 2013',
    explanation: 'Le support cite explicitement le règlement 606/2013.',
    difficulty: 'Difficile',
  ),

  // -----------------------------
  // 227-4-2 — ÉLÉMENT MATÉRIEL
  // -----------------------------
  QuizQuestion(
    category: 'Violation OP — Élément matériel',
    question: 'L’élément matériel de 227-4-2 consiste à :',
    options: [
      'Ne pas se conformer à une ou plusieurs obligations/interdictions imposées',
      'Ne pas notifier un changement de domicile au créancier',
      'Ne pas déposer plainte',
    ],
    answer:
        'Ne pas se conformer à une ou plusieurs obligations/interdictions imposées',
    explanation:
        'Le texte incrimine la violation des obligations/interdictions.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — Élément matériel',
    question: 'La finalité du texte 227-4-2 est de :',
    options: [
      'Donner pleine effectivité à l’ordonnance de protection',
      'Remplacer le juge pénal',
      'Créer une contravention éducative',
    ],
    answer: 'Donner pleine effectivité à l’ordonnance de protection',
    explanation:
        'Le support insiste sur l’effectivité de l’OP en sanctionnant la violation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Élément matériel',
    question: 'L’ordonnance de protection a pour vocation de fournir :',
    options: [
      'Un cadre protecteur aux victimes de violences',
      'Un avantage fiscal aux couples',
      'Un statut administratif de séjour',
    ],
    answer: 'Un cadre protecteur aux victimes de violences',
    explanation: 'Le support présente l’OP comme un cadre protecteur.',
    difficulty: 'Facile',
  ),

  // -----------------------------
  // 227-4-2 — ÉLÉMENT MORAL
  // -----------------------------
  QuizQuestion(
    category: 'Violation OP — Élément moral',
    question: 'L’infraction 227-4-2 est une infraction :',
    options: ['Intentionnelle', 'Non intentionnelle', 'Purement civile'],
    answer: 'Intentionnelle',
    explanation:
        'Le support indique que l’auteur agit en pleine connaissance de cause.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — Élément moral',
    question:
        'Pour que l’élément moral soit caractérisé, l’auteur doit notamment :',
    options: [
      'Avoir été informé des termes de l’ordonnance',
      'Avoir déjà été condamné',
      'Avoir déménagé',
    ],
    answer: 'Avoir été informé des termes de l’ordonnance',
    explanation:
        'Le support précise : l’auteur doit avoir été informé des termes.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Élément moral',
    question:
        'La connaissance par l’auteur des obligations/interdictions implique :',
    options: [
      'Qu’il sache précisément ce qui lui est interdit ou imposé',
      'Qu’il ignore le contenu mais accepte “en général”',
      'Qu’il ait seulement entendu une rumeur',
    ],
    answer: 'Qu’il sache précisément ce qui lui est interdit ou imposé',
    explanation:
        'Infraction intentionnelle : connaissance de cause des obligations/interdictions.',
    difficulty: 'Difficile',
  ),

  // -----------------------------
  // 227-4-2 — RÉPRESSION / TENTATIVE / COMPLICITÉ
  // -----------------------------
  QuizQuestion(
    category: 'Violation OP — Répression',
    question: 'La peine encourue pour 227-4-2 (personne physique) est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le support fixe : 3 ans + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — Répression',
    question: 'La classification de 227-4-2 est :',
    options: ['Délit', 'Contravention', 'Crime'],
    answer: 'Délit',
    explanation: 'Le tableau répressif indique : délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — Tentative / complicité',
    question: 'Pour 227-4-2, la tentative est :',
    options: ['Non', 'Oui', 'Oui si la victime est mineure'],
    answer: 'Non',
    explanation: 'Le support indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Tentative / complicité',
    question: 'Pour 227-4-2, la complicité est :',
    options: [
      'Oui (article 121-7 CP)',
      'Non',
      'Oui uniquement si le complice est un professionnel',
    ],
    answer: 'Oui (article 121-7 CP)',
    explanation: 'Le support mentionne l’article 121-7 CP.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Circonstances aggravantes',
    question:
        'Pour 227-4-2, le support prévoit des circonstances aggravantes :',
    options: [
      'Aucune',
      'Une circonstance liée au domicile',
      'Deux circonstances liées aux armes',
    ],
    answer: 'Aucune',
    explanation: 'IV – circonstances aggravantes : aucune.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // OP (515-9) — CONDITIONS / PRINCIPES (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'OP — 515-9',
    question:
        'Selon 515-9, l’ordonnance de protection peut être délivrée lorsque les violences :',
    options: [
      'Mettent en danger la victime ou un ou plusieurs enfants',
      'Sont uniquement physiques',
      'Ont déjà fait l’objet d’un jugement pénal',
    ],
    answer: 'Mettent en danger la victime ou un ou plusieurs enfants',
    explanation:
        'Le critère central est le danger pour la victime (et/ou les enfants).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question: '515-9 vise aussi les violences commises par :',
    options: [
      'Un ancien conjoint, ancien partenaire PACS ou ancien concubin',
      'Uniquement un conjoint actuel',
      'Uniquement un parent',
    ],
    answer: 'Un ancien conjoint, ancien partenaire PACS ou ancien concubin',
    explanation: 'Le support inclut les “anciens” liens.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question: 'L’ordonnance de protection peut être délivrée même si :',
    options: [
      'Il n’y a pas de cohabitation',
      'Les parties vivent ensemble obligatoirement',
      'Les parties sont divorcées depuis moins de 6 jours',
    ],
    answer: 'Il n’y a pas de cohabitation',
    explanation: 'Le texte vise les situations sans cohabitation.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question:
        'Le juge délivre l’ordonnance de protection si, au vu des éléments, il existe :',
    options: [
      'Des raisons sérieuses de considérer vraisemblables les violences alléguées et le danger',
      'Une preuve absolue et définitive',
      'Une plainte pénale obligatoire',
    ],
    answer:
        'Des raisons sérieuses de considérer vraisemblables les violences alléguées et le danger',
    explanation:
        'Le support utilise la formule “raisons sérieuses” + “vraisemblables”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question:
        'La délivrance de l’ordonnance de protection est conditionnée à une plainte pénale :',
    options: ['Non', 'Oui', 'Oui uniquement si absence de cohabitation'],
    answer: 'Non',
    explanation:
        'Le support précise : pas conditionnée à l’existence d’une plainte pénale.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question:
        'Le délai maximal de délivrance (OP) indiqué dans le support est :',
    options: [
      'Six jours à compter de la fixation de la date d’audience',
      'Vingt-quatre heures à compter de la saisine',
      'Quinze jours à compter de la plainte',
    ],
    answer: 'Six jours à compter de la fixation de la date d’audience',
    explanation: 'Le support indique un délai maximal de six jours.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // OP — 515-12 : DURÉE MAX (selon support)
  // =========================================================
  QuizQuestion(
    category: 'OP — Durée',
    question:
        'Selon le support, les mesures sont prises pour une durée maximale de :',
    options: [
      '12 mois (prolongeable sous certaines conditions)',
      '6 mois (non prolongeable)',
      '24 mois (automatique)',
    ],
    answer: '12 mois (prolongeable sous certaines conditions)',
    explanation:
        'Le support mentionne : durée maximale de 12 mois (prolongeable sous conditions).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 515-11 — MESURES : QCM “CHOISIS LA BONNE MESURE” (EN SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Interdire de recevoir ou rencontrer certaines personnes et d’entrer en relation avec elles » correspond à :',
    options: ['1°', '1° bis', '2°'],
    answer: '1°',
    explanation: 'Mesure 1° de 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Interdire de se rendre dans certains lieux fréquentés habituellement par la demanderesse » correspond à :',
    options: ['1° bis', '1°', '6°'],
    answer: '1° bis',
    explanation: 'Mesure 1° bis de 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question: '« Interdire de détenir ou porter une arme » correspond à :',
    options: ['2°', '2° bis', '2° ter'],
    answer: '2°',
    explanation: 'Mesure 2° de 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Ordonner la remise des armes au service de police/gendarmerie » correspond à :',
    options: ['2° bis', '2°', '7°'],
    answer: '2° bis',
    explanation: 'Mesure 2° bis de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Proposer une prise en charge sanitaire/sociale/psychologique ou un stage » correspond à :',
    options: ['2° ter', '3°', '5°'],
    answer: '2° ter',
    explanation: 'Mesure 2° ter de 515-11.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Statuer sur la résidence séparée des époux et la jouissance du logement conjugal » correspond à :',
    options: ['3°', '4°', '6°'],
    answer: '3°',
    explanation: 'Mesure 3° de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Attribuer la jouissance de l’animal de compagnie du foyer » correspond à :',
    options: ['3° bis', '4°', '5°'],
    answer: '3° bis',
    explanation: 'Mesure 3° bis de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Se prononcer sur le logement commun des partenaires PACS/concubins » correspond à :',
    options: ['4°', '3°', '6° bis'],
    answer: '4°',
    explanation: 'Mesure 4° de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Modalités d’exercice de l’autorité parentale et droit de visite/hébergement » correspond à :',
    options: ['5°', '6°', '7°'],
    answer: '5°',
    explanation: 'Mesure 5° de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Dissimuler son domicile et élire domicile chez l’avocat ou auprès du procureur » correspond à :',
    options: ['6°', '6° bis', '7°'],
    answer: '6°',
    explanation: 'Mesure 6° de 515-11.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Élire domicile pour la vie courante chez une personne morale qualifiée » correspond à :',
    options: ['6° bis', '6°', '1°'],
    answer: '6° bis',
    explanation: 'Mesure 6° bis de 515-11.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — Repérage 515-11',
    question:
        '« Admission provisoire à l’aide juridictionnelle » correspond à :',
    options: ['7°', '5°', '2°'],
    answer: '7°',
    explanation: 'Mesure 7° de 515-11.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 515-11-1 — DISTANCE + DISPOSITIF ANTI-RAPPROCHEMENT
  // =========================================================
  QuizQuestion(
    category: 'Anti-rapprochement — 515-11-1',
    question:
        'Si l’interdiction prévue au 1° de 515-11 est prononcée, le juge peut :',
    options: [
      'Interdire de se rapprocher à moins d’une certaine distance qu’il fixe',
      'Interdire tout déplacement en France',
      'Obliger à déménager immédiatement',
    ],
    answer:
        'Interdire de se rapprocher à moins d’une certaine distance qu’il fixe',
    explanation: 'Le support prévoit la fixation d’une distance minimale.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Anti-rapprochement — 515-11-1',
    question: 'Le dispositif anti-rapprochement est destiné à :',
    options: [
      'Signaler le non-respect de la distance fixée',
      'Mesurer la vitesse de conduite',
      'Vérifier le paiement des pensions',
    ],
    answer: 'Signaler le non-respect de la distance fixée',
    explanation:
        'Le texte indique qu’il permet de signaler le non-respect de la distance.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 515-13 — MARIAGE FORCÉ / FIN DES MESURES
  // =========================================================
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question:
        'Une ordonnance de protection peut être délivrée en urgence à la personne majeure :',
    options: [
      'Menacée de mariage forcé',
      'Menacée de licenciement',
      'Menacée d’expulsion locative',
    ],
    answer: 'Menacée de mariage forcé',
    explanation:
        'Le support vise la personne majeure menacée de mariage forcé.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question:
        'Dans ce cadre, le juge peut ordonner l’interdiction temporaire de sortie du territoire :',
    options: [
      'À la demande de la personne menacée',
      'Automatiquement dans tous les cas',
      'Uniquement à la demande du maire',
    ],
    answer: 'À la demande de la personne menacée',
    explanation: 'Le support précise : “à sa demande”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question: 'Les mesures prises sur 515-13 prennent fin :',
    options: [
      'À compter de la décision statuant sur la demande d’ordonnance de protection (ou incident mettant fin à l’instance)',
      'Au bout de 12 mois automatiquement',
      'À la fin de l’enquête de police',
    ],
    answer:
        'À compter de la décision statuant sur la demande d’ordonnance de protection (ou incident mettant fin à l’instance)',
    explanation: 'Le support indique cette règle de fin des mesures.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 515-13-1 — OPPI : SAISINE / DÉLAI / CONDITIONS / MESURES
  // =========================================================
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'L’OPPI est demandée par :',
    options: [
      'Le ministère public, avec l’accord de la personne en danger',
      'Le maire, sans accord de la victime',
      'Le commissariat, sans juge',
    ],
    answer: 'Le ministère public, avec l’accord de la personne en danger',
    explanation:
        'Le support précise : ministère public + accord de la personne en danger.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'L’OPPI est délivrée dans un délai de :',
    options: [
      '24 heures à compter de la saisine',
      '6 jours à compter de la fixation de l’audience',
      '48 heures à compter de la plainte',
    ],
    answer: '24 heures à compter de la saisine',
    explanation: 'Le support mentionne : délai de vingt-quatre heures.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'Pour délivrer l’OPPI, le juge se fonde sur :',
    options: [
      'Les seuls éléments joints à la requête',
      'Une expertise psychiatrique obligatoire',
      'Un débat contradictoire obligatoire avec les deux parties présentes',
    ],
    answer: 'Les seuls éléments joints à la requête',
    explanation:
        'Le support indique : “au vu des seuls éléments joints à la requête”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'L’OPPI exige la vraisemblance :',
    options: [
      'Des violences alléguées et du danger grave et immédiat',
      'D’un conflit financier uniquement',
      'D’une infraction routière',
    ],
    answer: 'Des violences alléguées et du danger grave et immédiat',
    explanation: 'Le support vise “danger grave et immédiat”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — Mesures',
    question: 'Dans l’OPPI, le juge peut prononcer à titre provisoire :',
    options: [
      'Les mesures 1° à 2° bis de 515-11',
      'La totalité des mesures 1° à 7° sans limite',
      'Uniquement l’aide juridictionnelle',
    ],
    answer: 'Les mesures 1° à 2° bis de 515-11',
    explanation: 'Le support énumère ces mesures dans l’OPPI.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — Mesures',
    question: 'Dans l’OPPI, le juge peut aussi ordonner :',
    options: [
      'La suspension du droit de visite et d’hébergement (mentionné au 5°)',
      'La déchéance automatique de l’autorité parentale',
      'Une interdiction définitive de sortie du territoire',
    ],
    answer:
        'La suspension du droit de visite et d’hébergement (mentionné au 5°)',
    explanation: 'Le support mentionne explicitement la suspension du DVH.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — Mesures',
    question:
        'Dans l’OPPI, la dissimulation du domicile/résidence est possible selon :',
    options: [
      'Les 6° et 6° bis de 515-11',
      'Une simple demande au commissariat',
      'Une déclaration sur l’honneur sans décision',
    ],
    answer: 'Les 6° et 6° bis de 515-11',
    explanation: 'Le support renvoie aux 6° et 6° bis.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — Fin des mesures',
    question: 'Les mesures de l’OPPI prennent fin :',
    options: [
      'À compter de la décision statuant sur la demande d’OP (ou incident mettant fin à l’instance)',
      'Après 24 heures automatiquement',
      'Au bout de 6 jours automatiquement',
    ],
    answer:
        'À compter de la décision statuant sur la demande d’OP (ou incident mettant fin à l’instance)',
    explanation: 'Le support fixe cette règle de fin des mesures.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // QUESTIONS COMPARATIVES (TRÈS UTILES EN QUIZ)
  // =========================================================
  QuizQuestion(
    category: 'Comparatif — 227-4-2 / 227-4-3',
    question:
        'Quelle infraction vise spécifiquement le changement de domicile du débiteur ?',
    options: ['227-4-3', '227-4-2', '515-11-1'],
    answer: '227-4-3',
    explanation:
        '227-4-3 = défaut de notification de changement de domicile au créancier.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparatif — 227-4-2 / 227-4-3',
    question:
        'Quelle infraction vise le non-respect d’obligations/interdictions imposées par une OP/OPPI ?',
    options: ['227-4-2', '227-4-3', '515-12'],
    answer: '227-4-2',
    explanation: '227-4-2 = violation des obligations/interdictions OP/OPPI.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparatif — Peines',
    question:
        'Quelle infraction est la plus lourdement sanctionnée (emprisonnement) ?',
    options: ['227-4-2 (3 ans)', '227-4-3 (6 mois)', 'Elles sont identiques'],
    answer: '227-4-2 (3 ans)',
    explanation: '227-4-2 : 3 ans ; 227-4-3 : 6 mois.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparatif — Élément moral',
    question: 'Point commun entre 227-4-2 et 227-4-3 selon le support :',
    options: [
      'Ce sont des infractions intentionnelles',
      'Ce sont des contraventions',
      'Elles nécessitent une plainte pénale',
    ],
    answer: 'Ce sont des infractions intentionnelles',
    explanation: 'Le support précise l’intention pour les deux infractions.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Comparatif — Tentative',
    question:
        'Concernant la tentative, le support indique que pour 227-4-2 et 227-4-3 :',
    options: [
      'La tentative n’est pas prévue (tentative : non)',
      'La tentative est toujours punissable',
      'La tentative dépend d’un délai',
    ],
    answer: 'La tentative n’est pas prévue (tentative : non)',
    explanation: 'Le support indique “TENTATIVE : NON” pour les deux.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // CAS PRATIQUES (QCM) — GROS RENDU MÉMOIRE
  // =========================================================
  QuizQuestion(
    category: 'Cas pratique — 227-4-2',
    question:
        'Une ordonnance de protection interdit à la défenderesse d’entrer en relation avec la demanderesse. Elle envoie un message via un tiers. La qualification la plus adaptée est :',
    options: [
      'Violation des obligations/interdictions de l’ordonnance (227-4-2)',
      'Défaut de notification de changement de domicile (227-4-3)',
      'Aucune infraction car ce n’est pas un contact direct',
    ],
    answer: 'Violation des obligations/interdictions de l’ordonnance (227-4-2)',
    explanation:
        'Le support souligne que l’interdiction peut viser toute forme de relation/contournement.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — 227-4-3',
    question:
        'Un débiteur soumis à une ordonnance de protection déménage, attend volontairement 35 jours et n’informe pas le créancier. La qualification la plus adaptée est :',
    options: [
      'Défaut de notification de changement de domicile au créancier (227-4-3)',
      'Violation des obligations/interdictions de l’ordonnance (227-4-2)',
      'Aucune car aucune forme n’est imposée',
    ],
    answer:
        'Défaut de notification de changement de domicile au créancier (227-4-3)',
    explanation: 'Délai d’un mois dépassé + intention : 227-4-3.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — 515-11-1',
    question:
        'Après une interdiction d’entrer en relation (1°), le juge fixe une distance minimale et ordonne un dispositif anti-rapprochement. Le fondement cité dans le support est :',
    options: [
      '515-11-1 du code civil',
      '227-4-2 du Code pénal',
      '227-4-3 du Code pénal',
    ],
    answer: '515-11-1 du code civil',
    explanation: 'Le support rattache distance + dispositif à 515-11-1.',
    difficulty: 'Difficile',
  ),
  // =========================================================
  // PACK ENORME #4 — 515-11 / 515-11-1 / 515-13 / 515-13-1 + 227-4-2 + 227-4-3
  // (sans fermeture de liste, prêt à coller)
  // =========================================================

  // =========================================================
  // 515-11 — MESURES : QCM “QUE PEUT FAIRE LE JAF ?” (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'Le JAF peut, dans une ordonnance de protection, interdire à la partie défenderesse :',
    options: [
      'D’entrer en relation avec certaines personnes désignées',
      'De travailler dans la fonction publique',
      'De quitter son emploi',
    ],
    answer: 'D’entrer en relation avec certaines personnes désignées',
    explanation:
        'Mesure 1° : interdiction de rencontrer/entrer en relation avec certaines personnes.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'La mesure qui permet d’interdire à la partie défenderesse de se rendre dans certains lieux est :',
    options: ['1° bis', '2°', '7°'],
    answer: '1° bis',
    explanation:
        'Mesure 1° bis : lieux spécialement désignés où la demanderesse se trouve habituellement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'Le juge peut interdire à la partie défenderesse de détenir ou porter une arme au titre :',
    options: [
      'Du 2° de l’article 515-11',
      'Du 6° de l’article 515-11',
      'Du 1° bis de l’article 515-11',
    ],
    answer: 'Du 2° de l’article 515-11',
    explanation: 'Mesure 2° : interdiction de détenir/porter une arme.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'La remise des armes au service de police ou de gendarmerie le plus proche relève :',
    options: [
      'Du 2° bis de l’article 515-11',
      'Du 2° ter de l’article 515-11',
      'Du 5° de l’article 515-11',
    ],
    answer: 'Du 2° bis de l’article 515-11',
    explanation: 'Mesure 2° bis : remise au service de police/gendarmerie.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'Une “prise en charge sanitaire, sociale ou psychologique” ou un “stage de responsabilisation” relève :',
    options: [
      'Du 2° ter de l’article 515-11',
      'Du 3° bis de l’article 515-11',
      'Du 7° de l’article 515-11',
    ],
    answer: 'Du 2° ter de l’article 515-11',
    explanation: 'Mesure 2° ter : proposition de prise en charge/stage.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question: 'En cas de refus de la prise en charge/stage (2° ter), le juge :',
    options: [
      'En avise immédiatement le procureur de la République',
      'Classe automatiquement la procédure',
      'Ne peut rien faire',
    ],
    answer: 'En avise immédiatement le procureur de la République',
    explanation:
        'Le support prévoit l’information immédiate du procureur en cas de refus.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'La mesure qui permet au juge de statuer sur la résidence séparée des époux est :',
    options: ['3°', '4°', '6° bis'],
    answer: '3°',
    explanation: 'Mesure 3° : résidence séparée + logement conjugal.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'Sauf circonstances particulières, la jouissance du logement conjugal est attribuée :',
    options: [
      'Au conjoint qui n’est pas l’auteur des violences',
      'Au conjoint propriétaire du logement',
      'Au conjoint ayant l’autorité parentale',
    ],
    answer: 'Au conjoint qui n’est pas l’auteur des violences',
    explanation: 'Principe de protection de la victime dans le support.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'Le juge peut attribuer à la demanderesse la jouissance de l’animal de compagnie au titre :',
    options: [
      'Du 3° bis de l’article 515-11',
      'Du 6° de l’article 515-11',
      'Du 1° de l’article 515-11',
    ],
    answer: 'Du 3° bis de l’article 515-11',
    explanation: 'Mesure 3° bis : animal de compagnie.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'Pour des partenaires PACS ou concubins, la jouissance du logement commun est en principe attribuée :',
    options: [
      'Au partenaire/concubin qui n’est pas l’auteur des violences',
      'Toujours au titulaire du bail',
      'Toujours au partenaire ayant le plus de revenus',
    ],
    answer: 'Au partenaire/concubin qui n’est pas l’auteur des violences',
    explanation: 'Mesure 4° : même logique protectrice que pour les époux.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'La mesure relative à l’autorité parentale et au droit de visite/hébergement est :',
    options: ['5°', '7°', '2°'],
    answer: '5°',
    explanation: 'Mesure 5° : autorité parentale + DVH + contributions.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'La dissimulation du domicile/résidence et l’élection de domicile chez l’avocat ou le procureur relève :',
    options: ['Du 6°', 'Du 6° bis', 'Du 1° bis'],
    answer: 'Du 6°',
    explanation:
        'Mesure 6° : dissimulation + élection de domicile (avocat/parquet).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question:
        'L’élection de domicile “pour les besoins de la vie courante” chez une personne morale qualifiée relève :',
    options: ['Du 6° bis', 'Du 7°', 'Du 2° bis'],
    answer: 'Du 6° bis',
    explanation:
        'Mesure 6° bis : vie courante chez une personne morale qualifiée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11',
    question: 'L’admission provisoire à l’aide juridictionnelle relève :',
    options: ['Du 7°', 'Du 3° bis', 'Du 1°'],
    answer: 'Du 7°',
    explanation: 'Mesure 7° : admission provisoire à l’aide juridictionnelle.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 515-11-1 — DISTANCE + DISPOSITIF ANTI-RAPPROCHEMENT (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Anti-rapprochement — 515-11-1',
    question:
        'La possibilité d’interdire de se rapprocher à moins d’une certaine distance est prévue par :',
    options: [
      'L’article 515-11-1 du code civil',
      'L’article 227-4-2 du Code pénal',
      'L’article 515-12 du code civil',
    ],
    answer: 'L’article 515-11-1 du code civil',
    explanation: 'Le support rattache distance + dispositif à 515-11-1.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Anti-rapprochement — 515-11-1',
    question:
        'Le juge peut ordonner le port d’un dispositif anti-rapprochement lorsque :',
    options: [
      'L’interdiction prévue au 1° de 515-11 a été prononcée',
      'Une plainte pénale a été déposée',
      'Les parties ont des enfants',
    ],
    answer: 'L’interdiction prévue au 1° de 515-11 a été prononcée',
    explanation:
        'Le support indique : “Lorsque l’interdiction prévue au 1° a été prononcée…”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Anti-rapprochement — 515-11-1',
    question: 'Le dispositif anti-rapprochement sert principalement à :',
    options: [
      'Signaler que la partie défenderesse ne respecte pas la distance fixée',
      'Contrôler les dépenses du ménage',
      'Mesurer le temps de présence au domicile',
    ],
    answer:
        'Signaler que la partie défenderesse ne respecte pas la distance fixée',
    explanation: 'Finalité : signalement du non-respect de la distance.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 515-13 — ORDONNANCE POUR MENACE DE MARIAGE FORCÉ (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question:
        'L’article 515-13 permet une ordonnance de protection en urgence pour :',
    options: [
      'Une personne majeure menacée de mariage forcé',
      'Une personne mineure menacée de fugue',
      'Un couple en procédure de divorce',
    ],
    answer: 'Une personne majeure menacée de mariage forcé',
    explanation:
        'Le support vise explicitement la personne majeure menacée de mariage forcé.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question:
        'Le juge peut ordonner, à la demande de la personne menacée, une :',
    options: [
      'Interdiction temporaire de sortie du territoire',
      'Interdiction définitive de quitter l’UE',
      'Interdiction de travailler',
    ],
    answer: 'Interdiction temporaire de sortie du territoire',
    explanation:
        'Le support mentionne l’interdiction temporaire de sortie du territoire.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question:
        'L’interdiction temporaire de sortie du territoire est inscrite au FPR par :',
    options: ['Le procureur de la République', 'Le préfet', 'Le maire'],
    answer: 'Le procureur de la République',
    explanation: 'Le support indique l’inscription au FPR par le procureur.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 515-13-1 — OPPI : DEMANDE / CONDITIONS / FIN (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'L’OPPI est demandée par le ministère public :',
    options: [
      'Avec l’accord de la personne en danger',
      'Sans accord de la personne en danger',
      'Uniquement sur instruction de la mairie',
    ],
    answer: 'Avec l’accord de la personne en danger',
    explanation: 'Le support exige l’accord de la personne en danger.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'Le juge délivre l’OPPI s’il estime vraisemblables :',
    options: [
      'Les violences alléguées et le danger grave et immédiat',
      'Le conflit conjugal sans danger',
      'Une difficulté financière',
    ],
    answer: 'Les violences alléguées et le danger grave et immédiat',
    explanation: 'Le support insiste sur “danger grave et immédiat”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'Le délai de délivrance de l’OPPI est :',
    options: [
      '24 heures à compter de la saisine',
      '6 jours à compter de la fixation de l’audience',
      '1 mois à compter du dépôt de plainte',
    ],
    answer: '24 heures à compter de la saisine',
    explanation: 'Le support précise : dans les 24 heures.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question:
        'Dans l’OPPI, le juge peut prononcer provisoirement les mesures :',
    options: [
      '1° à 2° bis de 515-11',
      '1° à 7° de 515-11',
      'Uniquement 7° (AJ)',
    ],
    answer: '1° à 2° bis de 515-11',
    explanation: 'Le support limite explicitement aux 1° à 2° bis.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'Le support indique que les mesures de l’OPPI prennent fin :',
    options: [
      'À compter de la décision statuant sur la demande d’OP (ou incident mettant fin à l’instance)',
      'Au bout de 24 heures automatiquement',
      'Au bout de 12 mois automatiquement',
    ],
    answer:
        'À compter de la décision statuant sur la demande d’OP (ou incident mettant fin à l’instance)',
    explanation:
        'Le support décrit précisément cette règle de fin des mesures.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 227-4-2 — VIOLATION OP/OPPI : ÉLÉMENTS / PEINES (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question: 'La violation d’une ordonnance de protection consiste à :',
    options: [
      'Ne pas se conformer aux obligations/interdictions imposées',
      'Ne pas notifier un changement d’adresse au créancier',
      'Ne pas se présenter au tribunal',
    ],
    answer: 'Ne pas se conformer aux obligations/interdictions imposées',
    explanation:
        'Élément matériel : non-respect des obligations/interdictions imposées.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question: 'L’élément moral de 227-4-2 repose sur :',
    options: [
      'La volonté de ne pas se conformer (connaissance de cause)',
      'Une simple négligence',
      'Une erreur de bonne foi toujours excusable',
    ],
    answer: 'La volonté de ne pas se conformer (connaissance de cause)',
    explanation: 'Le support précise : infraction intentionnelle.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Répression',
    question:
        'La peine principale (personne physique) prévue par 227-4-2 est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le support fixe 3 ans + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — Tentative / complicité',
    question: 'Pour 227-4-2, la complicité est :',
    options: [
      'Applicable (article 121-7 CP)',
      'Inapplicable',
      'Applicable uniquement en cas de violences physiques',
    ],
    answer: 'Applicable (article 121-7 CP)',
    explanation: 'Le support indique : COMPLICITÉ : OUI (121-7 CP).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Tentative / complicité',
    question: 'Pour 227-4-2, la tentative est :',
    options: ['Non', 'Oui', 'Oui si la distance n’est pas respectée'],
    answer: 'Non',
    explanation: 'Le support indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 227-4-3 — DÉFAUT DE NOTIFICATION : ÉLÉMENTS / PEINES (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question: 'L’élément moral de 227-4-3 repose sur :',
    options: [
      'La volonté de ne pas informer le créancier du changement de domicile',
      'La simple distraction',
      'Un conflit conjugal ancien',
    ],
    answer:
        'La volonté de ne pas informer le créancier du changement de domicile',
    explanation:
        'Le support précise : infraction intentionnelle, négligence non punissable.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Répression',
    question:
        'La peine principale (personne physique) prévue par 227-4-3 est :',
    options: [
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
    ],
    answer: '6 mois d’emprisonnement et 7 500 € d’amende',
    explanation: 'Le support fixe 6 mois + 7 500 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'Pour 227-4-3, la complicité est :',
    options: [
      'Applicable (article 121-7 CP)',
      'Inapplicable',
      'Applicable uniquement si le créancier est un enfant',
    ],
    answer: 'Applicable (article 121-7 CP)',
    explanation: 'Le support indique : COMPLICITÉ : OUI (121-7 CP).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'Pour 227-4-3, la tentative est :',
    options: ['Non', 'Oui', 'Oui si le débiteur a déménagé deux fois'],
    answer: 'Non',
    explanation: 'Le support indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // CAS PRATIQUES — MIX 515 / 227 (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Cas pratique — Mix',
    question:
        'Une OP interdit à la défenderesse de se rendre dans un lieu désigné (1° bis). Elle y va volontairement. Infraction la plus adaptée :',
    options: [
      'Violation de l’ordonnance de protection (227-4-2)',
      'Défaut de notification de domicile (227-4-3)',
      'Aucune infraction, c’est civil',
    ],
    answer: 'Violation de l’ordonnance de protection (227-4-2)',
    explanation:
        'Le non-respect d’une interdiction imposée par l’OP est sanctionné par 227-4-2.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — Mix',
    question:
        'Une OP prévoit remise des armes (2° bis). La défenderesse refuse et conserve une arme. Infraction la plus adaptée :',
    options: [
      'Violation de l’ordonnance de protection (227-4-2)',
      'Défaut de notification de domicile (227-4-3)',
      'Aucune, car l’ordonnance n’est pas pénale',
    ],
    answer: 'Violation de l’ordonnance de protection (227-4-2)',
    explanation:
        'La violation des obligations imposées (dont remise des armes) relève de 227-4-2.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Cas pratique — Mix',
    question:
        'Un débiteur soumis à une OP déménage et décide de ne pas informer le créancier pour éviter l’exécution des paiements. Infraction la plus adaptée :',
    options: [
      'Défaut de notification de changement de domicile (227-4-3)',
      'Violation de l’ordonnance (227-4-2)',
      'Aucune, car il peut déménager librement',
    ],
    answer: 'Défaut de notification de changement de domicile (227-4-3)',
    explanation:
        'Le cœur de 227-4-3 est l’absence volontaire d’information du créancier dans le délai.',
    difficulty: 'Moyenne',
  ),
  // =========================================================
  // PACK ENORME #5 — (full QCM) 515-9 / 515-11 / 515-11-1 / 515-13 / 515-13-1
  // + 227-4-2 + 227-4-3 (sans fermeture de liste, prêt à coller)
  // =========================================================

  // =========================================================
  // 515-9 — CONDITIONS / CHAMP (SÉRIES D’ANCRAGE MÉMOIRE)
  // =========================================================
  QuizQuestion(
    category: 'OP — 515-9',
    question:
        'L’ordonnance de protection peut être délivrée lorsque les violences exercées :',
    options: [
      'Mettent en danger la victime ou un ou plusieurs enfants',
      'Sont uniquement des violences physiques',
      'Ont forcément lieu au domicile conjugal',
    ],
    answer: 'Mettent en danger la victime ou un ou plusieurs enfants',
    explanation:
        'Le support vise le danger pour la victime (et/ou les enfants).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question: 'Le champ de 515-9 inclut les violences exercées :',
    options: [
      'Par un ancien conjoint/ancien partenaire PACS/ancien concubin',
      'Uniquement par un époux actuel',
      'Uniquement par une personne vivant au domicile',
    ],
    answer: 'Par un ancien conjoint/ancien partenaire PACS/ancien concubin',
    explanation: 'Le support cite expressément les “anciens” liens.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question: 'L’ordonnance de protection peut être délivrée même lorsque :',
    options: [
      'Il n’y a pas de cohabitation',
      'Les parties sont mariées uniquement',
      'Une plainte pénale a été déposée',
    ],
    answer: 'Il n’y a pas de cohabitation',
    explanation:
        'Le support mentionne l’absence de cohabitation (même jamais).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question:
        'Le juge délivre l’ordonnance s’il existe des raisons sérieuses de considérer vraisemblables :',
    options: [
      'Les violences alléguées et le danger',
      'Une infraction routière',
      'Une dette impayée',
    ],
    answer: 'Les violences alléguées et le danger',
    explanation:
        'Formule du support : raisons sérieuses + vraisemblance + danger.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question:
        'La délivrance d’une ordonnance de protection est conditionnée à une plainte pénale :',
    options: ['Non', 'Oui, toujours', 'Oui seulement en cas d’enfants'],
    answer: 'Non',
    explanation:
        'Le support précise que la plainte pénale n’est pas une condition.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OP — 515-9',
    question:
        'Le délai maximal de délivrance de l’ordonnance de protection indiqué par le support est :',
    options: ['Six jours', 'Vingt-quatre heures', 'Un mois'],
    answer: 'Six jours',
    explanation: 'Le support indique un délai maximal de six jours.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 515-11 — MESURES : QCM “CHOISIS LA MESURE QUI CORRESPOND” (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « interdire à la défenderesse de recevoir ou rencontrer certaines personnes et d’entrer en relation avec elles » ?',
    options: ['1°', '1° bis', '2°'],
    answer: '1°',
    explanation: 'Le support liste cette mesure au 1° de 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « interdire à la défenderesse de se rendre dans certains lieux spécialement désignés » ?',
    options: ['1° bis', '2° bis', '7°'],
    answer: '1° bis',
    explanation: 'Le support liste cette mesure au 1° bis de 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « interdire de détenir ou de porter une arme » ?',
    options: ['2°', '2° bis', '6°'],
    answer: '2°',
    explanation: 'Le support liste cette mesure au 2° de 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « ordonner de remettre les armes au service de police ou de gendarmerie le plus proche » ?',
    options: ['2° bis', '2° ter', '5°'],
    answer: '2° bis',
    explanation: 'Le support liste cette mesure au 2° bis de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « proposer une prise en charge sanitaire, sociale ou psychologique ou un stage de responsabilisation » ?',
    options: ['2° ter', '3°', '3° bis'],
    answer: '2° ter',
    explanation: 'Le support liste cette mesure au 2° ter de 515-11.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « statuer sur la résidence séparée des époux et le logement conjugal » ?',
    options: ['3°', '4°', '6° bis'],
    answer: '3°',
    explanation: 'Le support liste cette mesure au 3° de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « attribuer la jouissance de l’animal de compagnie du foyer » ?',
    options: ['3° bis', '1°', '7°'],
    answer: '3° bis',
    explanation: 'Le support liste cette mesure au 3° bis de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « se prononcer sur le logement commun de partenaires PACS ou concubins » ?',
    options: ['4°', '5°', '6°'],
    answer: '4°',
    explanation: 'Le support liste cette mesure au 4° de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « se prononcer sur l’autorité parentale et le droit de visite/hébergement » ?',
    options: ['5°', '6°', '2°'],
    answer: '5°',
    explanation: 'Le support liste cette mesure au 5° de 515-11.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « autoriser à dissimuler son domicile et à élire domicile chez l’avocat ou auprès du procureur » ?',
    options: ['6°', '6° bis', '7°'],
    answer: '6°',
    explanation: 'Le support liste cette mesure au 6° de 515-11.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « élire domicile pour les besoins de la vie courante chez une personne morale qualifiée » ?',
    options: ['6° bis', '6°', '1° bis'],
    answer: '6° bis',
    explanation: 'Le support liste cette mesure au 6° bis de 515-11.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (repérage)',
    question:
        'Quelle mesure correspond à « admission provisoire à l’aide juridictionnelle » ?',
    options: ['7°', '2° bis', '3° bis'],
    answer: '7°',
    explanation: 'Le support liste cette mesure au 7° de 515-11.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 515-11 — QUESTIONS “DÉTAILS DE RÉDACTION” (TRÈS BON POUR DÉPISTAGE)
  // =========================================================
  QuizQuestion(
    category: 'Mesures OP — 515-11 (détails)',
    question:
        'Le support précise que la jouissance du logement (époux) est attribuée au non-auteur des violences :',
    options: [
      'Sauf ordonnance spécialement motivée justifiée par des circonstances particulières',
      'Uniquement si la victime est propriétaire',
      'Uniquement si une plainte existe',
    ],
    answer:
        'Sauf ordonnance spécialement motivée justifiée par des circonstances particulières',
    explanation:
        'Le support indique ce principe avec l’exception (ordonnance motivée).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (détails)',
    question:
        'Le support indique que la jouissance du logement peut être attribuée à la victime :',
    options: [
      'Même si elle a bénéficié d’un hébergement d’urgence',
      'Uniquement si elle n’a jamais quitté le logement',
      'Uniquement si elle paie le loyer',
    ],
    answer: 'Même si elle a bénéficié d’un hébergement d’urgence',
    explanation:
        'Le support précise “et ce même s’il a bénéficié d’un hébergement d’urgence”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (détails)',
    question: 'La mesure 1° interdit d’entrer en relation :',
    options: [
      'De quelque façon que ce soit',
      'Uniquement par téléphone',
      'Uniquement par messages écrits',
    ],
    answer: 'De quelque façon que ce soit',
    explanation:
        'Le support contient la formule “de quelque façon que ce soit”.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 515-11-1 — “SI… ALORS…” (EXCELLENTS POUR LA MÉMOIRE)
  // =========================================================
  QuizQuestion(
    category: 'Anti-rapprochement — 515-11-1',
    question: 'Si l’interdiction de contact (1°) est prononcée, le juge peut :',
    options: [
      'Fixer une distance minimale de rapprochement',
      'Fixer une distance uniquement si l’auteur est condamné',
      'Fixer une distance uniquement en cas de récidive',
    ],
    answer: 'Fixer une distance minimale de rapprochement',
    explanation: 'Le support prévoit la distance fixée par le juge.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Anti-rapprochement — 515-11-1',
    question:
        'Le support indique que le port du dispositif anti-rapprochement concerne :',
    options: [
      'Chacune des deux parties',
      'Uniquement la partie défenderesse',
      'Uniquement la partie demanderesse',
    ],
    answer: 'Chacune des deux parties',
    explanation: 'Le support mentionne le port “par chacune des deux parties”.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 515-13 — MENACE DE MARIAGE FORCÉ : MESURES / FIN (SÉRIES)
  // =========================================================
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question:
        '515-13 prévoit que le juge est compétent pour prendre les mesures mentionnées notamment aux :',
    options: [
      '1°, 2°, 2° bis, 6° et 7° de 515-11',
      '3°, 3° bis, 4° et 5° de 515-11 uniquement',
      'Toutes les mesures 1° à 7° sans restriction',
    ],
    answer: '1°, 2°, 2° bis, 6° et 7° de 515-11',
    explanation:
        'Le support indique cette compétence spécifique (liste restreinte) pour 515-13.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question:
        'En cas de menace de mariage forcé, le juge peut aussi ordonner :',
    options: [
      'L’interdiction temporaire de sortie du territoire (à la demande)',
      'Une interdiction définitive de sortie du territoire (automatique)',
      'Une confiscation des biens (automatique)',
    ],
    answer: 'L’interdiction temporaire de sortie du territoire (à la demande)',
    explanation: 'Le support mentionne l’ITST temporaire “à sa demande”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question: 'La fin des mesures (515-13) intervient :',
    options: [
      'À compter de la décision statuant sur la demande d’OP ou incident mettant fin à l’instance',
      'Au bout de 6 jours',
      'Au bout de 24 heures',
    ],
    answer:
        'À compter de la décision statuant sur la demande d’OP ou incident mettant fin à l’instance',
    explanation: 'Le support indique cette règle de fin des mesures.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 515-13-1 — OPPI : MESURES PRÉCISES (SÉRIES “LISTE”)
  // =========================================================
  QuizQuestion(
    category: 'OPPI — 515-13-1 (mesures)',
    question: 'Dans l’OPPI, le juge peut prononcer provisoirement :',
    options: [
      'Les mesures 1° à 2° bis de 515-11',
      'Les mesures 3° à 7° uniquement',
      'Uniquement 6° et 6° bis',
    ],
    answer: 'Les mesures 1° à 2° bis de 515-11',
    explanation: 'Le support mentionne explicitement 1° à 2° bis.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1 (mesures)',
    question:
        'Le support précise que dans l’OPPI, le juge peut aussi prononcer :',
    options: [
      'La suspension du droit de visite et d’hébergement (mentionné au 5°)',
      'La déchéance automatique de l’autorité parentale',
      'Une ITST automatique',
    ],
    answer:
        'La suspension du droit de visite et d’hébergement (mentionné au 5°)',
    explanation: 'Le support cite la suspension du DVH.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1 (mesures)',
    question:
        'La dissimulation du domicile/résidence dans l’OPPI se fait selon :',
    options: [
      'Les 6° et 6° bis de 515-11',
      'Le 7° de 515-11 uniquement',
      'Le 3° de 515-11 uniquement',
    ],
    answer: 'Les 6° et 6° bis de 515-11',
    explanation: 'Le support renvoie aux 6° et 6° bis.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 227-4-2 / 227-4-3 — QUESTIONS “CHIFFRES” (PEINES / DÉLAIS) ULTRA RENTABLES
  // =========================================================
  QuizQuestion(
    category: 'Chiffres — 227-4-2',
    question: 'Le quantum d’emprisonnement prévu par 227-4-2 est de :',
    options: ['3 ans', '6 mois', '1 an'],
    answer: '3 ans',
    explanation: 'Le support indique : 3 ans d’emprisonnement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Chiffres — 227-4-2',
    question: 'Le montant de l’amende prévu par 227-4-2 est de :',
    options: ['45 000 €', '7 500 €', '15 000 €'],
    answer: '45 000 €',
    explanation: 'Le support indique : 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Chiffres — 227-4-3',
    question: 'Le quantum d’emprisonnement prévu par 227-4-3 est de :',
    options: ['6 mois', '3 ans', '2 ans'],
    answer: '6 mois',
    explanation: 'Le support indique : 6 mois d’emprisonnement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Chiffres — 227-4-3',
    question: 'Le montant de l’amende prévu par 227-4-3 est de :',
    options: ['7 500 €', '45 000 €', '30 000 €'],
    answer: '7 500 €',
    explanation: 'Le support indique : 7 500 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Chiffres — 227-4-3',
    question: 'Le délai de notification (227-4-3) est de :',
    options: ['1 mois', '6 jours', '24 heures'],
    answer: '1 mois',
    explanation: 'Le support fixe un délai d’un mois.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // CAS PRATIQUES — “BON ARTICLE” (TRÈS EFFICACE POUR EXAMENS)
  // =========================================================
  QuizQuestion(
    category: 'Cas pratique — Bon article',
    question:
        'Une personne visée par une OP ne respecte pas l’interdiction de se rendre dans un lieu désigné (1° bis). Quel article du Code pénal réprime ce non-respect ?',
    options: ['227-4-2', '227-4-3', '515-9'],
    answer: '227-4-2',
    explanation:
        'Le non-respect des obligations/interdictions de l’OP relève de 227-4-2.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — Bon article',
    question:
        'Un débiteur tenu de verser une contribution au titre d’une OP déménage et ne prévient pas le créancier dans le délai. Quel article réprime ce comportement ?',
    options: ['227-4-3', '227-4-2', '515-11-1'],
    answer: '227-4-3',
    explanation:
        'Le défaut de notification de changement de domicile au créancier relève de 227-4-3.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — Bon article',
    question:
        'Le juge fixe une distance minimale et ordonne un dispositif anti-rapprochement. Quel article du code civil est cité dans le support ?',
    options: ['515-11-1', '515-12', '515-4'],
    answer: '515-11-1',
    explanation: 'Distance + dispositif anti-rapprochement : 515-11-1.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question:
        'L’infraction de défaut de notification de changement de domicile au créancier est :',
    options: ['Un délit', 'Une contravention', 'Un crime'],
    answer: 'Un délit',
    explanation: 'Le support classe 227-4-3 comme un délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question:
        'Le délai pour notifier le changement de domicile au créancier est de :',
    options: ['1 mois', '8 jours', '3 mois'],
    answer: '1 mois',
    explanation: 'Le texte prévoit un délai d’un mois à compter du changement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question:
        'Le défaut de notification de changement de domicile au créancier suppose :',
    options: [
      'Une volonté de ne pas informer le créancier',
      'Un simple oubli suffit',
      'Une récidive obligatoire',
    ],
    answer: 'Une volonté de ne pas informer le créancier',
    explanation:
        'C’est une infraction intentionnelle : la simple négligence n’est pas punissable.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question:
        'La notification du changement de domicile au créancier doit obligatoirement être faite :',
    options: [
      'Selon une forme libre',
      'Par lettre recommandée avec AR uniquement',
      'Par acte de commissaire de justice uniquement',
    ],
    answer: 'Selon une forme libre',
    explanation: 'Aucune exigence de forme n’est imposée par le texte.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — 227-4-3',
    question: 'Le défaut de notification de changement de domicile concerne :',
    options: [
      'Une personne tenue de verser une contribution ou des subsides',
      'Toute personne sous contrôle judiciaire',
      'Toute personne condamnée à une amende',
    ],
    answer: 'Une personne tenue de verser une contribution ou des subsides',
    explanation:
        'Le texte vise le débiteur tenu de verser une contribution/subsides au titre de l’ordonnance de protection.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Répression',
    question:
        'La peine principale encourue (personne physique) pour 227-4-3 est :',
    options: [
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
    ],
    answer: '6 mois d’emprisonnement et 7 500 € d’amende',
    explanation: 'Répression prévue : 6 mois + 7 500 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'Pour 227-4-3, la tentative est :',
    options: ['Non', 'Oui', 'Oui uniquement en cas de récidive'],
    answer: 'Non',
    explanation: 'Le document indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'Pour 227-4-3, la complicité est :',
    options: [
      'Oui (article 121-7 CP)',
      'Non',
      'Oui uniquement si l’auteur est marié',
    ],
    answer: 'Oui (article 121-7 CP)',
    explanation:
        'La complicité est applicable conformément à l’article 121-7 du Code pénal.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Circonstances aggravantes',
    question: 'Pour 227-4-3, les circonstances aggravantes sont :',
    options: [
      'Aucune',
      'Une circonstance liée à la récidive',
      'Deux circonstances liées à la durée',
    ],
    answer: 'Aucune',
    explanation: 'Le support indique : Aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Intention',
    question: 'La volonté coupable (élément moral) de 227-4-3 consiste à :',
    options: [
      'Vouloir, par son silence, priver le créancier de l’exercice de son droit',
      'Oublier involontairement de déclarer une adresse',
      'Changer de domicile plus d’une fois',
    ],
    answer:
        'Vouloir, par son silence, priver le créancier de l’exercice de son droit',
    explanation:
        'Le cours précise que la volonté coupable est de priver le titulaire du droit.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ORDONNANCE DE PROTECTION — 515-9 : CONTEXTE / CONDITIONS
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — 515-9',
    question:
        'L’ordonnance de protection peut être délivrée lorsque les violences sont exercées :',
    options: [
      'Au sein du couple ou par un ancien conjoint/partenaire/concubin',
      'Uniquement entre personnes mariées',
      'Uniquement en cas de cohabitation',
    ],
    answer: 'Au sein du couple ou par un ancien conjoint/partenaire/concubin',
    explanation:
        'Le texte vise aussi les anciens conjoints/partenaires/concubins, même sans cohabitation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — 515-9',
    question: 'Selon 515-9, l’ordonnance peut être délivrée même si :',
    options: [
      'Il n’y a jamais eu de cohabitation',
      'Les parties sont toujours cohabitantes',
      'Le couple est uniquement marié',
    ],
    answer: 'Il n’y a jamais eu de cohabitation',
    explanation:
        'Le support précise : y compris lorsqu’il n’y a jamais eu de cohabitation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — 515-9',
    question: 'Pour délivrer l’ordonnance, le juge doit retenir :',
    options: [
      'Des raisons sérieuses de considérer vraisemblables les violences alléguées et le danger',
      'Une preuve scientifique certaine et irréfutable',
      'Une condamnation pénale préalable',
    ],
    answer:
        'Des raisons sérieuses de considérer vraisemblables les violences alléguées et le danger',
    explanation:
        'Le texte parle de “raisons sérieuses” et de violences “vraisemblables” + danger.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — 515-9',
    question:
        'La délivrance de l’ordonnance de protection suppose obligatoirement :',
    options: [
      'Un débat contradictoire devant le juge',
      'Une garde à vue de l’auteur',
      'Une enquête de flagrance',
    ],
    answer: 'Un débat contradictoire devant le juge',
    explanation:
        'Le texte indique que les éléments sont “produits devant lui et contradictoirement débattus”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — 515-9',
    question:
        'L’ordonnance de protection est délivrée dans un délai maximal de :',
    options: ['6 jours', '24 heures', '1 mois'],
    answer: '6 jours',
    explanation:
        'Le support indique : délai maximal de six jours à compter de la fixation de l’audience.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ORDONNANCE DE PROTECTION — 515-11 : LISTE DES MESURES (SÉRIES)
  // =========================================================

  // ---- Mesure 1° : interdiction de recevoir/rencontrer/entrer en relation
  QuizQuestion(
    category: 'Mesures OP — 515-11 (1°)',
    question: 'La mesure 1° permet au JAF :',
    options: [
      'D’interdire de recevoir/rencontrer certaines personnes et d’entrer en relation avec elles',
      'D’interdire d’ouvrir un compte bancaire',
      'D’imposer un TIG',
    ],
    answer:
        'D’interdire de recevoir/rencontrer certaines personnes et d’entrer en relation avec elles',
    explanation: 'Mesure 1° de l’article 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (1°)',
    question: 'L’interdiction d’entrer en relation peut viser :',
    options: [
      'Toute façon de communiquer',
      'Uniquement les appels téléphoniques',
      'Uniquement les SMS',
    ],
    answer: 'Toute façon de communiquer',
    explanation: 'Le texte prévoit “de quelque façon que ce soit”.',
    difficulty: 'Moyenne',
  ),

  // ---- Mesure 1° bis : interdiction de se rendre dans certains lieux
  QuizQuestion(
    category: 'Mesures OP — 515-11 (1° bis)',
    question: 'La mesure 1° bis permet au JAF :',
    options: [
      'D’interdire de se rendre dans certains lieux spécialement désignés',
      'D’interdire de voyager en France',
      'D’interdire de travailler',
    ],
    answer:
        'D’interdire de se rendre dans certains lieux spécialement désignés',
    explanation:
        'Mesure 1° bis : lieux où se trouve habituellement la demanderesse.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (1° bis)',
    question:
        'Les lieux visés au 1° bis sont notamment ceux où la demanderesse se trouve :',
    options: [
      'De façon habituelle',
      'Uniquement le week-end',
      'Uniquement la nuit',
    ],
    answer: 'De façon habituelle',
    explanation:
        'Le texte vise “dans lesquels se trouve de façon habituelle la partie demanderesse”.',
    difficulty: 'Moyenne',
  ),

  // ---- Mesures armes : 2°, 2° bis
  QuizQuestion(
    category: 'Mesures OP — 515-11 (2°)',
    question: 'La mesure 2° permet au JAF :',
    options: [
      'D’interdire à la défenderesse de détenir ou porter une arme',
      'D’imposer le port d’un bracelet électronique pénal',
      'D’imposer une amende forfaitaire',
    ],
    answer: 'D’interdire à la défenderesse de détenir ou porter une arme',
    explanation: 'Mesure 2° : interdiction armes.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (2° bis)',
    question: 'La mesure 2° bis prévoit :',
    options: [
      'La remise des armes au service de police ou de gendarmerie le plus proche',
      'La remise des armes au notaire',
      'La remise des armes à l’avocat',
    ],
    answer:
        'La remise des armes au service de police ou de gendarmerie le plus proche',
    explanation: 'Mesure 2° bis : remise au service de police/gendarmerie.',
    difficulty: 'Moyenne',
  ),

  // ---- Mesure 2° ter : prise en charge / stage + info parquet si refus
  QuizQuestion(
    category: 'Mesures OP — 515-11 (2° ter)',
    question: 'La mesure 2° ter permet au JAF de proposer :',
    options: [
      'Une prise en charge sanitaire/sociale/psychologique ou un stage de responsabilisation',
      'Une peine de prison',
      'Une médiation obligatoire',
    ],
    answer:
        'Une prise en charge sanitaire/sociale/psychologique ou un stage de responsabilisation',
    explanation: 'Mesure 2° ter.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (2° ter)',
    question: 'En cas de refus de la partie défenderesse, le juge :',
    options: [
      'En avise immédiatement le procureur de la République',
      'Classe l’affaire automatiquement',
      'Prononce une condamnation pénale immédiate',
    ],
    answer: 'En avise immédiatement le procureur de la République',
    explanation:
        'Le texte prévoit l’information immédiate du procureur en cas de refus.',
    difficulty: 'Difficile',
  ),

  // ---- Mesure 3° : résidence séparée époux / logement conjugal
  QuizQuestion(
    category: 'Mesures OP — 515-11 (3°)',
    question: 'La mesure 3° permet au JAF de statuer sur :',
    options: [
      'La résidence séparée des époux et la jouissance du logement conjugal',
      'La nullité du mariage',
      'L’adoption',
    ],
    answer:
        'La résidence séparée des époux et la jouissance du logement conjugal',
    explanation: 'Mesure 3° : résidence séparée + logement conjugal.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (3°)',
    question: 'En principe, la jouissance du logement conjugal est attribuée :',
    options: [
      'Au conjoint non auteur des violences',
      'Au conjoint qui paie le loyer',
      'Au conjoint propriétaire uniquement',
    ],
    answer: 'Au conjoint non auteur des violences',
    explanation:
        'Principe protecteur : attribution au non-auteur, sauf ordonnance spécialement motivée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (3°)',
    question:
        'Même si la victime a bénéficié d’un hébergement d’urgence, la jouissance du logement conjugal peut :',
    options: [
      'Lui être attribuée quand même',
      'Lui être refusée automatiquement',
      'Être attribuée à l’auteur des violences',
    ],
    answer: 'Lui être attribuée quand même',
    explanation:
        'Le texte précise “et ce même s’il a bénéficié d’un hébergement d’urgence”.',
    difficulty: 'Difficile',
  ),

  // ---- Mesure 3° bis : animal de compagnie
  QuizQuestion(
    category: 'Mesures OP — 515-11 (3° bis)',
    question: 'La mesure 3° bis concerne :',
    options: [
      'La jouissance de l’animal de compagnie détenu au sein du foyer',
      'La pension alimentaire uniquement',
      'Le partage des meubles',
    ],
    answer: 'La jouissance de l’animal de compagnie détenu au sein du foyer',
    explanation: 'Mesure 3° bis.',
    difficulty: 'Moyenne',
  ),

  // ---- Mesure 4° : logement commun PACS/concubins
  QuizQuestion(
    category: 'Mesures OP — 515-11 (4°)',
    question: 'La mesure 4° permet au JAF de statuer sur :',
    options: [
      'Le logement commun des partenaires PACS ou concubins',
      'La dissolution du PACS par décision pénale',
      'La garde alternée automatique',
    ],
    answer: 'Le logement commun des partenaires PACS ou concubins',
    explanation: 'Mesure 4° : logement commun PACS/concubins.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mesures OP — 515-11 (4°)',
    question:
        'En principe, la jouissance du logement commun (PACS/concubins) est attribuée :',
    options: [
      'Au partenaire/concubin non auteur des violences',
      'Au partenaire/concubin le plus ancien dans le logement',
      'Toujours au titulaire du bail',
    ],
    answer: 'Au partenaire/concubin non auteur des violences',
    explanation: 'Même logique protectrice que pour les époux.',
    difficulty: 'Moyenne',
  ),

  // ---- Mesure 5° : autorité parentale / DVH / contributions
  QuizQuestion(
    category: 'Mesures OP — 515-11 (5°)',
    question: 'La mesure 5° permet au JAF de se prononcer sur :',
    options: [
      'Les modalités d’exercice de l’autorité parentale et, le cas échéant, les contributions',
      'La peine pénale encourue',
      'La saisie des comptes bancaires',
    ],
    answer:
        'Les modalités d’exercice de l’autorité parentale et, le cas échéant, les contributions',
    explanation: 'Mesure 5° : autorité parentale + DVH + contributions.',
    difficulty: 'Moyenne',
  ),

  // ---- Mesure 6° : domicile dissimulé + élection de domicile avocat/parquet
  QuizQuestion(
    category: 'Mesures OP — 515-11 (6°)',
    question: 'La mesure 6° permet à la demanderesse :',
    options: [
      'De dissimuler son domicile/résidence et d’élire domicile chez l’avocat ou auprès du procureur',
      'D’obtenir automatiquement un logement social',
      'D’imposer une interdiction de sortie du territoire à l’auteur',
    ],
    answer:
        'De dissimuler son domicile/résidence et d’élire domicile chez l’avocat ou auprès du procureur',
    explanation: 'Mesure 6°.',
    difficulty: 'Difficile',
  ),

  // ---- Mesure 6° bis : élection domicile vie courante (personne morale qualifiée)
  QuizQuestion(
    category: 'Mesures OP — 515-11 (6° bis)',
    question: 'La mesure 6° bis permet :',
    options: [
      'D’élire domicile pour la vie courante chez une personne morale qualifiée',
      'D’élire domicile uniquement chez un parent',
      'De changer d’état civil',
    ],
    answer:
        'D’élire domicile pour la vie courante chez une personne morale qualifiée',
    explanation: 'Mesure 6° bis.',
    difficulty: 'Difficile',
  ),

  // ---- Mesure 7° : AJ provisoire
  QuizQuestion(
    category: 'Mesures OP — 515-11 (7°)',
    question: 'La mesure 7° concerne :',
    options: [
      'L’admission provisoire à l’aide juridictionnelle',
      'La suspension du permis',
      'La confiscation d’armes',
    ],
    answer: 'L’admission provisoire à l’aide juridictionnelle',
    explanation: 'Mesure 7°.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // ORDONNANCE DE PROTECTION — 515-11-1 : DISTANCE + DISPOSITIF ANTI-RAPPROCHEMENT
  // =========================================================
  QuizQuestion(
    category: 'Dispositif anti-rapprochement — 515-11-1',
    question:
        'Quand le 1° (interdiction d’entrer en relation) est prononcé, le JAF peut :',
    options: [
      'Fixer une distance minimale de rapprochement',
      'Fixer une distance minimale uniquement si les parties sont mariées',
      'Fixer une distance minimale uniquement si une plainte existe',
    ],
    answer: 'Fixer une distance minimale de rapprochement',
    explanation:
        '515-11-1 permet l’interdiction de se rapprocher à moins d’une distance fixée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dispositif anti-rapprochement — 515-11-1',
    question: 'Le dispositif anti-rapprochement a pour objectif :',
    options: [
      'De signaler que la partie défenderesse ne respecte pas la distance',
      'De surveiller les réseaux sociaux de la victime',
      'De remplacer une condamnation pénale',
    ],
    answer:
        'De signaler que la partie défenderesse ne respecte pas la distance',
    explanation:
        'Le texte indique qu’il permet de signaler le non-respect de la distance.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 515-13 : MENACE DE MARIAGE FORCÉ + OPPI
  // =========================================================
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question: 'Une ordonnance de protection peut être délivrée en urgence à :',
    options: [
      'Une personne majeure menacée de mariage forcé',
      'Toute personne mineure menacée de mariage',
      'Uniquement une personne déjà mariée',
    ],
    answer: 'Une personne majeure menacée de mariage forcé',
    explanation: 'Le support vise la personne majeure menacée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question: 'Le juge peut ordonner, à la demande de la personne menacée :',
    options: [
      'Une interdiction temporaire de sortie du territoire',
      'Une interdiction définitive de quitter l’UE',
      'Une incarcération automatique de la famille',
    ],
    answer: 'Une interdiction temporaire de sortie du territoire',
    explanation: 'Mesure spécifique mentionnée à 515-13.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mariage forcé — 515-13',
    question:
        'L’interdiction temporaire de sortie du territoire est inscrite au FPR par :',
    options: [
      'Le procureur de la République',
      'Le juge des enfants',
      'Le maire',
    ],
    answer: 'Le procureur de la République',
    explanation: 'Le support mentionne l’inscription au FPR par le procureur.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 515-13-1 : OPPI — CONDITIONS / MESURES
  // =========================================================
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'L’OPPI est délivrée si le juge estime vraisemblables :',
    options: [
      'Les violences alléguées et le danger grave et immédiat',
      'Une infraction fiscale',
      'Une simple dispute verbale sans danger',
    ],
    answer: 'Les violences alléguées et le danger grave et immédiat',
    explanation: 'Le texte parle de danger “grave et immédiat”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question:
        'Dans l’OPPI, le juge est compétent pour prononcer à titre provisoire :',
    options: [
      'Les mesures 1° à 2° bis de 515-11',
      'Toutes les mesures 1° à 7° automatiquement',
      'Uniquement l’aide juridictionnelle',
    ],
    answer: 'Les mesures 1° à 2° bis de 515-11',
    explanation: 'Le texte vise les mesures 1° à 2° bis.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'Dans l’OPPI, le juge peut aussi prononcer :',
    options: [
      'La suspension du droit de visite et d’hébergement (5°)',
      'La confiscation du véhicule',
      'La déchéance d’autorité parentale automatique',
    ],
    answer: 'La suspension du droit de visite et d’hébergement (5°)',
    explanation: 'Le texte mentionne la suspension du DVH mentionné au 5°.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question:
        'Dans l’OPPI, le juge peut permettre la dissimulation du domicile selon :',
    options: [
      'Les conditions prévues aux 6° et 6° bis de 515-11',
      'Une décision du préfet uniquement',
      'Une déclaration sur l’honneur sans décision',
    ],
    answer: 'Les conditions prévues aux 6° et 6° bis de 515-11',
    explanation: 'Le texte renvoie expressément aux 6° et 6° bis de 515-11.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // VIOLATION OP / OPPI — 227-4-2 : QUALIFICATION / PEINES / ÉLÉMENTS
  // =========================================================
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question: 'La violation d’une ordonnance de protection est réprimée par :',
    options: [
      '227-4-2 du Code pénal',
      '227-4-3 du Code pénal',
      '515-11 du code civil',
    ],
    answer: '227-4-2 du Code pénal',
    explanation: 'Élément légal : 227-4-2 CP.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question: 'La peine principale encourue pour 227-4-2 est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Répression : 3 ans + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question: 'Pour 227-4-2, la tentative est :',
    options: ['Non', 'Oui', 'Oui si l’OP date de moins de 6 jours'],
    answer: 'Non',
    explanation: 'TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — 227-4-2',
    question: 'Pour 227-4-2, la complicité est :',
    options: ['Oui (121-7 CP)', 'Non', 'Non si le complice est un proche'],
    answer: 'Oui (121-7 CP)',
    explanation: 'Complicité : OUI, article 121-7 CP.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Élément moral',
    question: 'L’infraction 227-4-2 exige :',
    options: [
      'La volonté de ne pas se conformer aux obligations/interdictions',
      'Une simple inattention',
      'L’absence de notification de changement de domicile',
    ],
    answer: 'La volonté de ne pas se conformer aux obligations/interdictions',
    explanation:
        'Infraction intentionnelle : connaissance + volonté de ne pas respecter.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Élément moral',
    question: 'Pour que 227-4-2 soit caractérisée, l’auteur doit avoir été :',
    options: [
      'Informé des termes de l’ordonnance',
      'Entendu comme témoin',
      'Condamné auparavant',
    ],
    answer: 'Informé des termes de l’ordonnance',
    explanation:
        'Le support précise que l’auteur doit avoir été informé des termes.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation OP — Circonstances aggravantes',
    question: 'Le support prévoit des circonstances aggravantes pour 227-4-2 :',
    options: ['Non (aucune)', 'Oui (deux)', 'Oui (une seule)'],
    answer: 'Non (aucune)',
    explanation: 'IV – circonstances aggravantes : aucune.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // RÈGLEMENT UE 606/2013 — APPLICATION EN FRANCE (SÉRIE DIFFICILE)
  // =========================================================
  QuizQuestion(
    category: 'Mesures UE — Règlement 606/2013',
    question:
        'Le texte mentionné prévoit la reconnaissance mutuelle des mesures de protection :',
    options: [
      'En matière civile',
      'En matière commerciale uniquement',
      'En matière fiscale uniquement',
    ],
    answer: 'En matière civile',
    explanation:
        'Le support vise explicitement les mesures de protection “en matière civile”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mesures UE — Règlement 606/2013',
    question:
        'Les mêmes peines sont applicables à la violation d’une mesure UE si elle est :',
    options: [
      'Reconnue et ayant force exécutoire en France',
      'Simplement évoquée dans un courrier',
      'Seulement traduite en français',
    ],
    answer: 'Reconnue et ayant force exécutoire en France',
    explanation:
        'Le support précise “reconnue et ayant force exécutoire en France”.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // QUESTIONS DE SYNTHÈSE / CAS PRATIQUES (QCM)
  // =========================================================
  QuizQuestion(
    category: 'Cas pratique — 227-4-3',
    question:
        'Un débiteur soumis à une ordonnance de protection déménage et ne prévient pas le créancier pendant 40 jours, volontairement. Quelle qualification est la plus adaptée ?',
    options: [
      'Défaut de notification de changement de domicile au créancier (227-4-3)',
      'Violation des obligations de l’ordonnance (227-4-2)',
      'Aucune infraction car la forme n’est pas imposée',
    ],
    answer:
        'Défaut de notification de changement de domicile au créancier (227-4-3)',
    explanation:
        'Délai d’un mois dépassé + intention de ne pas informer : 227-4-3.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — 227-4-2',
    question:
        'Une personne interdite de contacter la victime (OP) envoie des messages via un ami. Quelle infraction est la plus adaptée ?',
    options: [
      'Non-respect des obligations/interdictions de l’ordonnance (227-4-2)',
      'Défaut de notification de domicile (227-4-3)',
      'Aucune car ce n’est pas un contact direct',
    ],
    answer:
        'Non-respect des obligations/interdictions de l’ordonnance (227-4-2)',
    explanation:
        'L’interdiction porte sur “entrer en relation de quelque façon que ce soit”.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — 515-11-1',
    question:
        'Après une interdiction d’entrer en relation (1°), le juge fixe une distance minimale et impose un dispositif anti-rapprochement. Sur quel fondement ?',
    options: [
      'Article 515-11-1 du code civil',
      'Article 227-4-3 du Code pénal',
      'Article 515-4 du code civil',
    ],
    answer: 'Article 515-11-1 du code civil',
    explanation:
        'Le dispositif anti-rapprochement et la distance relèvent de 515-11-1.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // (GROS BLOC) QUESTIONS “LISTE” SUR 515-11 : REPÉRER LA BONNE MESURE
  // =========================================================
  QuizQuestion(
    category: 'Repérage — 515-11',
    question:
        'Quelle mesure correspond à « interdire de détenir ou porter une arme » ?',
    options: ['2°', '1° bis', '6°'],
    answer: '2°',
    explanation: 'Interdiction armes = 2°.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Repérage — 515-11',
    question:
        'Quelle mesure correspond à « remettre les armes au service de police/gendarmerie » ?',
    options: ['2° bis', '2°', '7°'],
    answer: '2° bis',
    explanation: 'Remise des armes = 2° bis.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Repérage — 515-11',
    question:
        'Quelle mesure correspond à « attribuer la jouissance de l’animal de compagnie » ?',
    options: ['3° bis', '4°', '1°'],
    answer: '3° bis',
    explanation: 'Animal de compagnie = 3° bis.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Repérage — 515-11',
    question:
        'Quelle mesure correspond à « autoriser la dissimulation du domicile et élection chez l’avocat/parquet » ?',
    options: ['6°', '6° bis', '5°'],
    answer: '6°',
    explanation: 'Dissimulation + élection avocat/parquet = 6°.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Repérage — 515-11',
    question:
        'Quelle mesure correspond à « élection de domicile pour la vie courante chez une personne morale qualifiée » ?',
    options: ['6° bis', '6°', '7°'],
    answer: '6° bis',
    explanation: 'Vie courante personne morale qualifiée = 6° bis.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Repérage — 515-11',
    question:
        'Quelle mesure correspond à « admission provisoire à l’aide juridictionnelle » ?',
    options: ['7°', '5°', '1°'],
    answer: '7°',
    explanation: 'Aide juridictionnelle provisoire = 7°.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // (SÉRIES) QUESTIONS “VRAI/FAUX” CONVERTIES EN QCM (OP / OPPI / CP)
  // =========================================================
  QuizQuestion(
    category: 'Vrai/Faux — OP',
    question:
        'L’ordonnance de protection est conditionnée à une plainte pénale.',
    options: ['Vrai', 'Faux', 'Ça dépend de la cohabitation'],
    answer: 'Faux',
    explanation:
        'Le texte précise qu’elle n’est pas conditionnée à l’existence d’une plainte pénale.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Vrai/Faux — OPPI',
    question:
        'L’OPPI est délivrée dans un délai de 24 heures à compter de la saisine.',
    options: ['Vrai', 'Faux', 'Vrai uniquement si les parties sont mariées'],
    answer: 'Vrai',
    explanation: 'Le texte mentionne : délivrée dans les 24 heures.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Vrai/Faux — 227-4-2',
    question:
        'La violation d’une ordonnance de protection est punie de 6 mois d’emprisonnement.',
    options: ['Vrai', 'Faux', 'Vrai si récidive'],
    answer: 'Faux',
    explanation: '227-4-2 prévoit 3 ans d’emprisonnement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Vrai/Faux — 227-4-3',
    question:
        'Le défaut de notification de changement de domicile au créancier est une infraction non intentionnelle.',
    options: ['Vrai', 'Faux', 'Vrai si la forme n’est pas respectée'],
    answer: 'Faux',
    explanation:
        'C’est une infraction intentionnelle : la négligence n’est pas punissable.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Fondement',
    question:
        'L’infraction vise une personne tenue de verser une contribution ou des subsides au titre :',
    options: [
      'D’une ordonnance de protection rendue en application de l’article 515-9 du code civil',
      'D’un jugement de divorce définitif uniquement',
      'D’une simple main courante',
    ],
    answer:
        'D’une ordonnance de protection rendue en application de l’article 515-9 du code civil',
    explanation:
        'Le texte vise la personne tenue de verser une contribution ou des subsides au titre de l’ordonnance de protection (art. 515-9 C. civ.).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Fondement',
    question:
        'Le débiteur doit notifier son changement de domicile au créancier dans un délai de :',
    options: [
      'Un mois à compter du changement',
      'Quinze jours à compter du changement',
      'Deux mois à compter du changement',
    ],
    answer: 'Un mois à compter du changement',
    explanation:
        'Le délai légal est d’un mois à compter du changement de domicile.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question:
        'Concernant la forme de la notification du changement de domicile, le texte :',
    options: [
      'Ne prévoit aucune exigence de forme',
      'Impose une lettre recommandée avec AR',
      'Impose une signification par commissaire de justice',
    ],
    answer: 'Ne prévoit aucune exigence de forme',
    explanation:
        'Aucune exigence n’est formulée quant à la forme de la notification : l’essentiel est d’informer dans le délai.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément moral',
    question:
        'Le défaut de notification de changement de domicile est une infraction :',
    options: [
      'Intentionnelle',
      'Non intentionnelle',
      'Contraventionnelle de police',
    ],
    answer: 'Intentionnelle',
    explanation:
        'L’élément moral repose sur la volonté de ne pas informer le créancier ; la simple négligence n’est pas punissable.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // DÉFAUT DE NOTIFICATION — PRÉCISIONS / MÉCANISME
  // =========================================================
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question:
        'L’infraction a été prévue notamment car le JAF peut se prononcer dans le référé protection sur :',
    options: [
      'La contribution aux charges du ménage',
      'La nationalité',
      'Le permis de conduire',
    ],
    answer: 'La contribution aux charges du ménage',
    explanation:
        'Le cours indique que le JAF peut statuer sur la contribution aux charges du ménage, d’où l’intérêt dissuasif de l’incrimination.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément matériel',
    question:
        'Dans ce cadre, la personne visée par 227-4-3 est principalement :',
    options: [
      'Le débiteur d’une contribution ou de subsides',
      'Le créancier uniquement',
      'Le témoin des violences',
    ],
    answer: 'Le débiteur d’une contribution ou de subsides',
    explanation:
        'L’obligation de notifier pèse sur le débiteur tenu de verser la contribution/subsides.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Élément moral',
    question: 'Pourquoi la simple négligence n’est-elle pas punissable ici ?',
    options: [
      'Car la volonté coupable consiste à priver le titulaire de son droit par le silence',
      'Car l’infraction est toujours une contravention',
      'Car l’infraction n’existe que si le créancier est mineur',
    ],
    answer:
        'Car la volonté coupable consiste à priver le titulaire de son droit par le silence',
    explanation:
        'Le texte insiste sur l’intention : la volonté de priver le créancier de l’exercice de son droit.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Circonstances',
    question:
        'Concernant les circonstances aggravantes du défaut de notification (227-4-3), il y en a :',
    options: [
      'Aucune',
      'Une si récidive légale',
      'Une si le débiteur déménage à l’étranger',
    ],
    answer: 'Aucune',
    explanation:
        'Le cours mentionne : « Aucune » circonstance aggravante prévue.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // DÉFAUT DE NOTIFICATION — RÉPRESSION / PROCÉDURE
  // =========================================================
  QuizQuestion(
    category: 'Défaut de notification — Répression',
    question: 'La peine encourue (personne physique) pour 227-4-3 est :',
    options: [
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '6 mois d’emprisonnement et 7 500 € d’amende',
    explanation: 'La répression prévue est : 6 mois + 7 500 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Répression',
    question: 'La classification de l’infraction 227-4-3 est :',
    options: ['Un délit', 'Une contravention', 'Un crime'],
    answer: 'Un délit',
    explanation: 'Le cours précise : classification = délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'La tentative de l’infraction 227-4-3 est :',
    options: [
      'Non punissable (tentative : non)',
      'Punissable (tentative : oui)',
      'Punissable uniquement en cas de violences',
    ],
    answer: 'Non punissable (tentative : non)',
    explanation: 'Le document indique : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Tentative / complicité',
    question: 'La complicité pour 227-4-3 est :',
    options: [
      'Applicable (article 121-7 du Code pénal)',
      'Inapplicable',
      'Applicable uniquement si le créancier est un enfant',
    ],
    answer: 'Applicable (article 121-7 du Code pénal)',
    explanation:
        'La complicité est prévue selon l’article 121-7 du Code pénal.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Défaut de notification — Personnes morales',
    question:
        'Depuis quand la responsabilité des personnes morales est applicable de façon généralisée (référence cours) ?',
    options: [
      'Depuis le 31 décembre 2005',
      'Depuis le 1er janvier 1990',
      'Depuis le 1er juillet 2025',
    ],
    answer: 'Depuis le 31 décembre 2005',
    explanation:
        'Le support mentionne l’application en la matière depuis le 31 décembre 2005 (dans le cadre de la responsabilité des personnes morales).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // NON-RESPECT DES OBLIGATIONS / INTERDICTIONS D’UNE ORDONNANCE DE PROTECTION — FONDEMENTS
  // =========================================================
  QuizQuestion(
    category: 'Violation ordonnance de protection — Fondement',
    question:
        'Le non-respect des obligations ou interdictions imposées par une ordonnance de protection est prévu par :',
    options: [
      'L’article 227-4-2 du Code pénal',
      'L’article 227-4-3 du Code pénal',
      'L’article 515-11 du code civil',
    ],
    answer: 'L’article 227-4-2 du Code pénal',
    explanation:
        'L’élément légal est fixé par l’article 227-4-2 du Code pénal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Champ',
    question:
        'L’infraction vise le non-respect d’obligations/interdictions imposées dans :',
    options: [
      'Une ordonnance de protection (art. 515-9 ou 515-13 C. civ.)',
      'Une simple médiation familiale',
      'Une audition libre',
    ],
    answer: 'Une ordonnance de protection (art. 515-9 ou 515-13 C. civ.)',
    explanation:
        'Le texte vise l’ordonnance de protection rendue notamment en application des articles 515-9 ou 515-13 du code civil.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Champ',
    question:
        'Sont aussi visées par 227-4-2 les obligations/interdictions imposées dans :',
    options: [
      'Une ordonnance provisoire de protection immédiate (art. 515-13-1 C. civ.)',
      'Un PV de renseignement judiciaire',
      'Une ordonnance de non-conciliation uniquement',
    ],
    answer:
        'Une ordonnance provisoire de protection immédiate (art. 515-13-1 C. civ.)',
    explanation:
        'Le texte vise aussi l’ordonnance provisoire de protection immédiate rendue sur le fondement de l’article 515-13-1.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Champ UE',
    question:
        'Les mêmes peines s’appliquent à la violation d’une mesure de protection civile d’un autre État membre de l’UE reconnue en France via :',
    options: [
      'Le règlement (UE) n° 606/2013 du 12 juin 2013',
      'Le règlement (UE) n° 44/2001',
      'Le traité de Lisbonne',
    ],
    answer: 'Le règlement (UE) n° 606/2013 du 12 juin 2013',
    explanation:
        'Le support mentionne expressément le règlement (UE) 606/2013 relatif à la reconnaissance mutuelle des mesures de protection civiles.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ORDONNANCE DE PROTECTION — CONDITIONS (515-9) / DÉLAIS
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — Conditions',
    question:
        'Selon l’article 515-9 C. civ., l’ordonnance de protection peut être délivrée lorsque des violences au sein du couple :',
    options: [
      'Mettent en danger la victime ou un ou plusieurs enfants',
      'Sont uniquement anciennes de moins de 24h',
      'Ont déjà donné lieu à une condamnation définitive',
    ],
    answer: 'Mettent en danger la victime ou un ou plusieurs enfants',
    explanation:
        'La condition centrale : danger pour la victime (et/ou les enfants).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Conditions',
    question:
        'L’ordonnance de protection peut être délivrée même lorsqu’il n’y a pas de cohabitation :',
    options: [
      'Oui',
      'Non, la cohabitation est obligatoire',
      'Oui, mais seulement si les personnes sont mariées',
    ],
    answer: 'Oui',
    explanation:
        'Le texte vise les violences au sein du couple y compris sans cohabitation, et même sans cohabitation passée.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Délai',
    question:
        'Le JAF délivre l’ordonnance de protection dans un délai maximal de :',
    options: [
      'Six jours à compter de la fixation de la date d’audience',
      'Vingt-quatre heures à compter de la saisine',
      'Un mois à compter de la requête',
    ],
    answer: 'Six jours à compter de la fixation de la date d’audience',
    explanation:
        'Le support indique : délai maximal de six jours (OP classique).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Plainte',
    question:
        'La délivrance d’une ordonnance de protection est-elle conditionnée à une plainte pénale ?',
    options: [
      'Non',
      'Oui',
      'Oui, uniquement en cas de violences psychologiques',
    ],
    answer: 'Non',
    explanation:
        'Le texte précise que l’ordonnance n’est pas conditionnée à l’existence d’une plainte pénale.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // ORDONNANCE DE PROTECTION — MESURES POSSIBLES (515-11) : QCM
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Parmi les mesures possibles, le JAF peut interdire à la partie défenderesse :',
    options: [
      'De recevoir/rencontrer certaines personnes et d’entrer en relation avec elles',
      'D’exercer toute activité professionnelle',
      'De conduire un véhicule',
    ],
    answer:
        'De recevoir/rencontrer certaines personnes et d’entrer en relation avec elles',
    explanation: 'C’est la mesure 1° de l’article 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut interdire à la partie défenderesse de se rendre dans certains lieux fréquentés habituellement par la demanderesse :',
    options: [
      'Oui (1° bis)',
      'Non, jamais',
      'Oui, uniquement si un divorce est engagé',
    ],
    answer: 'Oui (1° bis)',
    explanation:
        'La mesure 1° bis prévoit l’interdiction de se rendre dans certains lieux.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question: 'Concernant les armes, le JAF peut notamment :',
    options: [
      'Interdire de détenir/porter une arme',
      'Imposer une peine de prison immédiate',
      'Prononcer une interdiction de vote',
    ],
    answer: 'Interdire de détenir/porter une arme',
    explanation: 'C’est la mesure 2° de l’article 515-11.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut ordonner à la partie défenderesse de remettre ses armes :',
    options: [
      'Au service de police ou de gendarmerie le plus proche du domicile',
      'À la mairie',
      'À l’employeur',
    ],
    answer: 'Au service de police ou de gendarmerie le plus proche du domicile',
    explanation:
        'Mesure 2° bis : remise au service de police/gendarmerie le plus proche.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut proposer une prise en charge sanitaire/sociale/psychologique ou un stage de responsabilisation :',
    options: [
      'Oui (2° ter)',
      'Non, c’est uniquement le rôle du procureur',
      'Oui, mais seulement pour la victime',
    ],
    answer: 'Oui (2° ter)',
    explanation:
        'Mesure 2° ter : proposition de prise en charge ou stage ; en cas de refus, information immédiate du procureur.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Concernant le logement conjugal, sauf circonstances particulières, la jouissance est attribuée :',
    options: [
      'Au conjoint qui n’est pas l’auteur des violences',
      'Au conjoint qui a le plus de revenus',
      'Au conjoint le plus ancien dans le logement',
    ],
    answer: 'Au conjoint qui n’est pas l’auteur des violences',
    explanation:
        'Le principe : protection de la victime, attribution au non-auteur des violences.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut attribuer la jouissance de l’animal de compagnie détenu au sein du foyer :',
    options: ['Oui (3° bis)', 'Non', 'Oui, uniquement si l’animal est assuré'],
    answer: 'Oui (3° bis)',
    explanation:
        'L’article 515-11 prévoit la mesure 3° bis sur l’animal de compagnie.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Pour des partenaires PACS/concubins, la jouissance du logement commun est attribuée en principe :',
    options: [
      'Au partenaire/concubin qui n’est pas l’auteur des violences',
      'Au propriétaire du bail, quoi qu’il arrive',
      'Au partenaire le plus âgé',
    ],
    answer: 'Au partenaire/concubin qui n’est pas l’auteur des violences',
    explanation:
        'Le même principe protecteur est prévu au 4° pour PACS/concubins.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut se prononcer sur l’autorité parentale et aussi sur :',
    options: [
      'Le droit de visite/hébergement et les contributions (mariage/PACS/enfants)',
      'L’inscription à Pôle emploi',
      'Le retrait de permis',
    ],
    answer:
        'Le droit de visite/hébergement et les contributions (mariage/PACS/enfants)',
    explanation:
        'Mesure 5° : autorité parentale, DVH, et contributions selon la situation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut autoriser la demanderesse à dissimuler son domicile et élire domicile :',
    options: [
      'Chez l’avocat ou auprès du procureur de la République (pour les instances civiles)',
      'Uniquement au commissariat',
      'Uniquement chez un membre de la famille',
    ],
    answer:
        'Chez l’avocat ou auprès du procureur de la République (pour les instances civiles)',
    explanation:
        'Mesure 6° : dissimulation + élection de domicile chez avocat ou auprès du procureur.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut aussi autoriser une élection de domicile « pour les besoins de la vie courante » :',
    options: [
      'Chez une personne morale qualifiée (6° bis)',
      'Uniquement chez le notaire',
      'Uniquement à la préfecture',
    ],
    answer: 'Chez une personne morale qualifiée (6° bis)',
    explanation:
        'Mesure 6° bis : élection de domicile vie courante auprès d’une personne morale qualifiée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mesures (515-11)',
    question:
        'Le JAF peut prononcer l’admission provisoire à l’aide juridictionnelle :',
    options: [
      'Oui (7°)',
      'Non, jamais',
      'Oui, mais seulement pour la partie défenderesse',
    ],
    answer: 'Oui (7°)',
    explanation: 'Mesure 7° : admission provisoire à l’aide juridictionnelle.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // DISPOSITIF ANTI-RAPPROCHEMENT (515-11-1) — QCM
  // =========================================================
  QuizQuestion(
    category: 'Dispositif anti-rapprochement — 515-11-1',
    question:
        'Si l’interdiction d’entrer en relation (1°) est prononcée, le JAF peut aussi :',
    options: [
      'Fixer une distance minimale et ordonner un dispositif anti-rapprochement',
      'Ordonner une détention provisoire automatique',
      'Prononcer une expulsion locative sans décision',
    ],
    answer:
        'Fixer une distance minimale et ordonner un dispositif anti-rapprochement',
    explanation:
        'L’article 515-11-1 permet l’interdiction de se rapprocher à moins d’une certaine distance + dispositif anti-rapprochement.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ORDONNANCE (515-13) — MARIAGE FORCÉ / SORTIE DU TERRITOIRE
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — Mariage forcé (515-13)',
    question:
        'L’article 515-13 permet une ordonnance de protection en urgence pour :',
    options: [
      'Une personne majeure menacée de mariage forcé',
      'Toute personne souhaitant changer de nom',
      'Un mineur voulant se marier',
    ],
    answer: 'Une personne majeure menacée de mariage forcé',
    explanation:
        'Le texte vise expressément la personne majeure menacée de mariage forcé.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mariage forcé (515-13)',
    question:
        'Dans ce cadre, le JAF peut ordonner à la demande de la personne :',
    options: [
      'Une interdiction temporaire de sortie du territoire',
      'Une interdiction définitive de quitter la ville',
      'Une saisie automatique du passeport par l’employeur',
    ],
    answer: 'Une interdiction temporaire de sortie du territoire',
    explanation:
        'L’article 515-13 mentionne l’interdiction temporaire de sortie du territoire.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Mariage forcé (515-13)',
    question:
        'L’interdiction temporaire de sortie du territoire est inscrite au FPR par :',
    options: ['Le procureur de la République', 'Le maire', 'Le préfet'],
    answer: 'Le procureur de la République',
    explanation:
        'Le support précise l’inscription au FPR par le procureur de la République.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ORDONNANCE PROVISOIRE DE PROTECTION IMMÉDIATE (515-13-1) — 24H
  // =========================================================
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question:
        'L’ordonnance provisoire de protection immédiate est délivrée dans un délai de :',
    options: [
      '24 heures à compter de la saisine',
      '6 jours à compter de la fixation d’audience',
      '15 jours à compter de l’enquête',
    ],
    answer: '24 heures à compter de la saisine',
    explanation:
        'Le texte indique : délivrée dans un délai de vingt-quatre heures.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question:
        'Qui peut demander, avec l’accord de la personne en danger, une OPPI en plus de la demande d’OP ?',
    options: ['Le ministère public', 'Le greffe', 'La mairie'],
    answer: 'Le ministère public',
    explanation:
        'L’article 515-13-1 prévoit la demande par le ministère public avec l’accord de la personne en danger.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'OPPI — 515-13-1',
    question: 'Pour délivrer l’OPPI, le JAF statue :',
    options: [
      'Au vu des seuls éléments joints à la requête',
      'Après une enquête de flagrance obligatoire',
      'Uniquement après audition de 3 témoins',
    ],
    answer: 'Au vu des seuls éléments joints à la requête',
    explanation:
        'L’OPPI est délivrée sur la base des éléments joints à la requête (sans débat contradictoire complet).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // VIOLATION ORDONNANCE DE PROTECTION — ÉLÉMENT MATÉRIEL / MORAL
  // =========================================================
  QuizQuestion(
    category: 'Violation ordonnance de protection — Élément matériel',
    question: 'L’élément matériel de 227-4-2 consiste à :',
    options: [
      'Ne pas se conformer aux obligations/interdictions imposées',
      'Ne pas payer une amende forfaitaire',
      'Refuser une audition libre',
    ],
    answer: 'Ne pas se conformer aux obligations/interdictions imposées',
    explanation:
        'La violation est le non-respect des obligations/interdictions fixées par l’ordonnance.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Élément moral',
    question: 'L’infraction 227-4-2 est :',
    options: [
      'Intentionnelle',
      'Non intentionnelle',
      'Une simple faute civile',
    ],
    answer: 'Intentionnelle',
    explanation:
        'Le support précise une infraction intentionnelle : l’auteur agit en connaissance de cause des obligations/interdictions.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Élément moral',
    question: 'Pour caractériser l’élément moral, l’auteur doit notamment :',
    options: [
      'Avoir été informé des termes de l’ordonnance',
      'Avoir changé de travail',
      'Avoir contesté la procédure au civil',
    ],
    answer: 'Avoir été informé des termes de l’ordonnance',
    explanation:
        'La connaissance des obligations/interdictions suppose que l’auteur ait été informé de l’ordonnance.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Finalité',
    question: 'Le texte 227-4-2 vise à rendre l’ordonnance de protection :',
    options: [
      'Pleinement effective et contraignante',
      'Optionnelle',
      'Uniquement symbolique',
    ],
    answer: 'Pleinement effective et contraignante',
    explanation:
        'Le cours insiste sur l’effectivité : sanctionner pénalement la violation pour rendre la mesure réellement protectrice.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // VIOLATION ORDONNANCE DE PROTECTION — RÉPRESSION / PROCÉDURE
  // =========================================================
  QuizQuestion(
    category: 'Violation ordonnance de protection — Répression',
    question: 'La peine encourue (personne physique) pour 227-4-2 est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '10 ans de réclusion et 150 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'La répression prévue par 227-4-2 est de 3 ans et 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Classification',
    question: 'La classification de l’infraction 227-4-2 est :',
    options: ['Un délit', 'Un crime', 'Une contravention'],
    answer: 'Un délit',
    explanation: 'Le cours précise : délit.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Circonstances',
    question:
        'Concernant les circonstances aggravantes de 227-4-2 (cours), il y en a :',
    options: ['Aucune', 'Deux', 'Uniquement la récidive'],
    answer: 'Aucune',
    explanation: 'Le support indique : aucune circonstance aggravante.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Tentative / complicité',
    question: 'La tentative de 227-4-2 est :',
    options: [
      'Non punissable (tentative : non)',
      'Punissable (tentative : oui)',
      'Toujours punissable en correctionnelle',
    ],
    answer: 'Non punissable (tentative : non)',
    explanation: 'Le document précise : TENTATIVE : NON.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation ordonnance de protection — Tentative / complicité',
    question: 'La complicité pour 227-4-2 est :',
    options: [
      'Oui (article 121-7 du Code pénal)',
      'Non, jamais',
      'Oui, uniquement si l’auteur est mineur',
    ],
    answer: 'Oui (article 121-7 du Code pénal)',
    explanation:
        'La complicité est applicable conformément à l’article 121-7 du Code pénal.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // QUESTIONS MIXTES (COMPARAISONS 227-4-2 / 227-4-3)
  // =========================================================
  QuizQuestion(
    category: 'Comparatif — 227-4-2 vs 227-4-3',
    question:
        'Quelle infraction est la plus lourdement sanctionnée (peine d’emprisonnement) ?',
    options: ['227-4-2 (3 ans)', '227-4-3 (6 mois)', 'Elles sont identiques'],
    answer: '227-4-2 (3 ans)',
    explanation: '227-4-2 prévoit 3 ans, tandis que 227-4-3 prévoit 6 mois.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparatif — 227-4-2 vs 227-4-3',
    question:
        'Quelle infraction concerne spécifiquement le changement de domicile du débiteur ?',
    options: ['227-4-3', '227-4-2', '515-11'],
    answer: '227-4-3',
    explanation:
        '227-4-3 incrimine le défaut de notification du changement de domicile au créancier.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Comparatif — Élément moral',
    question: 'Point commun entre 227-4-2 et 227-4-3 :',
    options: [
      'Ce sont des infractions intentionnelles',
      'Ce sont des contraventions',
      'Elles exigent une plainte pénale préalable',
    ],
    answer: 'Ce sont des infractions intentionnelles',
    explanation:
        'Les deux supposent une volonté : ne pas se conformer / ne pas informer.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Comparatif — Tentative',
    question: 'Concernant la tentative, 227-4-2 et 227-4-3 :',
    options: [
      'Ne prévoient pas la tentative (tentative : non)',
      'Prévoient toutes deux la tentative',
      'Prévoient la tentative seulement en cas de récidive',
    ],
    answer: 'Ne prévoient pas la tentative (tentative : non)',
    explanation:
        'Le support indique “TENTATIVE : NON” pour les deux infractions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Comparatif — Complicité',
    question: 'Concernant la complicité (121-7 CP), pour 227-4-2 et 227-4-3 :',
    options: [
      'Elle est applicable pour les deux',
      'Elle est exclue pour les deux',
      'Elle n’est applicable que pour 227-4-3',
    ],
    answer: 'Elle est applicable pour les deux',
    explanation:
        'Les deux supports indiquent “COMPLICITÉ : OUI” + référence à l’article 121-7 CP.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // QUESTIONS "PIÈGES" / PRÉCISION DE TEXTE (PLUS DIFFICILES)
  // =========================================================
  QuizQuestion(
    category: 'Ordonnance de protection — Durée',
    question:
        'Les mesures de l’ordonnance de protection peuvent être prises pour une durée maximale de :',
    options: [
      '12 mois (prolongeable sous conditions)',
      '6 mois non prolongeable',
      '24 mois automatiquement',
    ],
    answer: '12 mois (prolongeable sous conditions)',
    explanation:
        'Le support mentionne une durée maximale de 12 mois, prolongeable sous certaines conditions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Logement',
    question:
        'Sauf circonstances particulières, la jouissance du logement est attribuée :',
    options: [
      'À la personne non auteure des violences',
      'À la personne ayant l’autorité parentale exclusive',
      'Toujours au titulaire du bail',
    ],
    answer: 'À la personne non auteure des violences',
    explanation:
        'Principe protecteur : attribution au non-auteur (sauf ordonnance motivée/circonstances particulières).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Domicile dissimulé',
    question:
        'Si un commissaire de justice doit connaître l’adresse réelle pour exécuter une décision :',
    options: [
      'L’adresse lui est communiquée, mais il ne peut pas la révéler à son mandant',
      'L’adresse ne peut jamais être communiquée à personne',
      'L’adresse est rendue publique au dossier',
    ],
    answer:
        'L’adresse lui est communiquée, mais il ne peut pas la révéler à son mandant',
    explanation:
        'Le support précise la communication nécessaire pour l’exécution, avec interdiction de révélation au mandant.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Information autorités',
    question:
        'Quand les mesures 6°/6° bis sont prononcées, qui peut être informé (avec accord de la personne) pour éviter la communication de l’adresse ?',
    options: [
      'Le maire et le représentant de l’État dans le département',
      'Uniquement le préfet de police de Paris',
      'Uniquement le bâtonnier',
    ],
    answer: 'Le maire et le représentant de l’État dans le département',
    explanation:
        'Le support indique l’information du maire et du représentant de l’État dans le département, sous réserve de l’accord de la personne.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Ordonnance de protection — Fin des mesures',
    question: 'Les mesures de l’OPPI prennent fin :',
    options: [
      'À compter de la décision statuant sur la demande d’OP (ou incident mettant fin à l’instance)',
      'Uniquement au bout de 12 mois',
      'Quand la victime le décide seule',
    ],
    answer:
        'À compter de la décision statuant sur la demande d’OP (ou incident mettant fin à l’instance)',
    explanation:
        'Le support précise la fin des mesures à compter de la décision sur la demande d’OP ou incident mettant fin à l’instance.',
    difficulty: 'Difficile',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizViolationOrdonnancesJaf extends StatefulWidget {
  static const String routeName =
      '/gpx_scolarite_pages/mineurs_famille_pages/violation_ordonnances_jaf/quiz_ordonnances_jaf';
  final String uid;
  final String email;

  const QuizViolationOrdonnancesJaf({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizViolationOrdonnancesJaf> createState() =>
      _QuizViolationOrdonnancesJafState();
}

class _QuizViolationOrdonnancesJafState
    extends State<QuizViolationOrdonnancesJaf>
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
        ? questionOrdonnanceProtection
        : questionOrdonnanceProtection
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
            'module_name': 'Atteintes aux mineurs & à la famille',
            'quiz_name': 'Violation JAF',
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
      await _sb.from('quiz_violation_ordonnances_jaf').insert({
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
      debugPrint('❌ quiz_violation_ordonnances_jaf insert failed: $e');
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
