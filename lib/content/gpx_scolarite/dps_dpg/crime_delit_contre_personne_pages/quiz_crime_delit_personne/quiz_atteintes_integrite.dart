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

final List<QuizQuestion> questionAtteinteIntegrite = [
  // =========================================================
  // MENACE DE COMMETTRE UN CRIME OU UN DÉLIT (222-17 CP)
  // =========================================================
  QuizQuestion(
    category: 'Menace — Définition',
    question:
        'La menace de commettre un crime ou un délit contre les personnes constitue une infraction lorsque :',
    options: [
      'Elle est réitérée ou matérialisée par un écrit, une image ou un objet',
      'Elle est simplement pensée',
      'Elle concerne une infraction non punissable',
    ],
    answer:
        'Elle est réitérée ou matérialisée par un écrit, une image ou un objet',
    explanation:
        'L’article 222-17 CP exige une réitération ou une matérialisation de la menace.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Menace — Fondement légal',
    question:
        'La menace de commettre un crime ou un délit contre les personnes est prévue par :',
    options: [
      'L’article 222-17 du Code pénal',
      'L’article 222-18 du Code pénal',
      'L’article R.623-1 du Code pénal',
    ],
    answer: 'L’article 222-17 du Code pénal',
    explanation:
        'Le cours indique que l’article 222-17 CP définit et réprime cette infraction.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Menace — Nature',
    question: 'Selon la jurisprudence, une menace est :',
    options: [
      'Tout acte d’intimidation inspirant la crainte d’un mal',
      'Une simple insulte',
      'Une violence involontaire',
    ],
    answer: 'Tout acte d’intimidation inspirant la crainte d’un mal',
    explanation:
        'Définition issue de la jurisprudence (Cass. crim., 11 juin 1937).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace — Infraction visée',
    question: 'La menace doit porter sur :',
    options: [
      'Un crime ou un délit contre les personnes dont la tentative est punissable',
      'Une contravention',
      'Une infraction non pénale',
    ],
    answer:
        'Un crime ou un délit contre les personnes dont la tentative est punissable',
    explanation:
        'Le texte exclut les menaces portant sur des violences dont la tentative n’est pas punissable.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Menace — Direction',
    question: 'La menace doit être :',
    options: [
      'Dirigée contre une ou plusieurs personnes déterminées',
      'Générale et impersonnelle',
      'Adressée à la cantonade',
    ],
    answer: 'Dirigée contre une ou plusieurs personnes déterminées',
    explanation:
        'Une menace faite à la cantonade ne constitue pas l’infraction.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace — Réitération',
    question: 'La réitération de la menace suppose :',
    options: [
      'Au moins deux menaces envers la même personne',
      'Un délai minimum entre les menaces',
      'Un écrit obligatoire',
    ],
    answer: 'Au moins deux menaces envers la même personne',
    explanation:
        'La jurisprudence exige une répétition à l’égard de la même personne.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace — Matérialisation',
    question: 'Une menace matérialisée peut l’être notamment par :',
    options: [
      'Un écrit, une image ou un objet',
      'Un simple geste isolé',
      'Un regard insistant',
    ],
    answer: 'Un écrit, une image ou un objet',
    explanation: 'Le cours précise les modes de matérialisation admis.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Menace — Élément moral',
    question: 'L’élément moral de la menace consiste en :',
    options: [
      'La conscience d’exercer une pression sur la victime',
      'La volonté de passer à l’acte',
      'Une imprudence',
    ],
    answer: 'La conscience d’exercer une pression sur la victime',
    explanation: 'Il suffit d’avoir conscience d’impressionner la victime.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace — Aggravation',
    question: 'La menace est aggravée lorsqu’elle constitue :',
    options: [
      'Une menace de mort',
      'Une menace verbale simple',
      'Une plaisanterie',
    ],
    answer: 'Une menace de mort',
    explanation: 'Article 222-17 alinéa 2 du Code pénal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Menace — Tentative',
    question: 'La tentative de menace est :',
    options: ['Non punissable', 'Punissable', 'Toujours retenue'],
    answer: 'Non punissable',
    explanation: 'Le texte ne prévoit pas la tentative.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // EMBUSCADE (222-15-1 CP)
  // =========================================================
  QuizQuestion(
    category: 'Embuscade — Définition',
    question: 'L’embuscade consiste à :',
    options: [
      'Attendre une victime dans un lieu déterminé en vue de violences avec arme',
      'Menacer sans préparation',
      'Commettre une violence spontanée',
    ],
    answer:
        'Attendre une victime dans un lieu déterminé en vue de violences avec arme',
    explanation: 'Le cours définit l’embuscade comme un guet-apens préparé.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Embuscade — Fondement',
    question: 'Le délit d’embuscade est prévu par :',
    options: [
      'L’article 222-15-1 du Code pénal',
      'L’article 222-14-1 du Code pénal',
      'L’article 221-1 du Code pénal',
    ],
    answer: 'L’article 222-15-1 du Code pénal',
    explanation:
        'Le cours indique que l’article 222-15-1 CP réprime l’embuscade.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Embuscade — Résultat',
    question: 'L’infraction d’embuscade est constituée :',
    options: [
      'Même si les violences ne sont pas réalisées',
      'Uniquement si la victime est blessée',
      'Uniquement en cas d’ITT',
    ],
    answer: 'Même si les violences ne sont pas réalisées',
    explanation: 'L’embuscade est une infraction préparée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Embuscade — Tentative',
    question: 'La tentative d’embuscade est :',
    options: ['Non punissable', 'Punissable', 'Une contravention'],
    answer: 'Non punissable',
    explanation: 'La consommation intervient avant le stade de la tentative.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // APPELS MALVEILLANTS / MESSAGES / AGRESSIONS SONORES (222-16)
  // =========================================================
  QuizQuestion(
    category: 'Appels malveillants — Définition',
    question: 'Les appels téléphoniques malveillants réitérés constituent :',
    options: [
      'Une infraction pénale',
      'Une simple incivilité',
      'Une contravention uniquement',
    ],
    answer: 'Une infraction pénale',
    explanation: 'Article 222-16 du Code pénal.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Appels malveillants — Réitération',
    question: 'La réitération est caractérisée à partir de :',
    options: [
      'Deux appels successifs',
      'Trois appels minimum',
      'Un seul appel',
    ],
    answer: 'Deux appels successifs',
    explanation:
        'La jurisprudence admet deux appels, même à des destinataires différents.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Appels malveillants — Élément moral',
    question: 'L’élément moral repose sur :',
    options: ['La malveillance', 'La préméditation', 'La négligence'],
    answer: 'La malveillance',
    explanation: 'La volonté de nuire suffit.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // MENACE AVEC ORDRE DE REMPLIR UNE CONDITION (222-18 CP)
  // =========================================================
  QuizQuestion(
    category: 'Menace avec condition — Définition',
    question: 'La menace avec ordre de remplir une condition consiste à :',
    options: [
      'Contraindre la victime à faire ou ne pas faire un acte sous la menace',
      'Répéter une menace simple',
      'Menacer sans exigence',
    ],
    answer:
        'Contraindre la victime à faire ou ne pas faire un acte sous la menace',
    explanation: 'L’article 222-18 CP vise l’atteinte à la liberté d’agir.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace avec condition — Tentative',
    question: 'La tentative de menace avec condition est :',
    options: ['Non punissable', 'Punissable', 'Un crime'],
    answer: 'Non punissable',
    explanation: 'Le texte ne prévoit pas la tentative.',
    difficulty: 'Facile',
  ),
  // =======================
  // SUITE — ENORMEMENT DE QUESTIONS (3 niveaux)
  // À coller APRÈS les dernières questions déjà mises dans questionAtteinteIntegrite
  // =======================

  // =========================================================
  // MENACE (222-17 CP) — APPROFONDISSEMENT / CONCOURS
  // =========================================================
  QuizQuestion(
    category: 'Menace (222-17) — Exclusion',
    question:
        'Quand la menace porte sur des violences dont la tentative n’est pas réprimée, il convient de viser :',
    options: [
      'La contravention de l’article R. 623-1 du Code pénal',
      'L’article 222-17 du Code pénal',
      'L’article 222-18 du Code pénal',
    ],
    answer: 'La contravention de l’article R. 623-1 du Code pénal',
    explanation:
        'Le cours précise que les menaces de violences (tentative non réprimée) sortent du champ de 222-17 et relèvent de R.623-1 CP.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Réitération',
    question: 'Pour être punissables, les menaces doivent être réitérées :',
    options: [
      'À l’égard de la même personne',
      'À l’égard de plusieurs personnes différentes',
      'Dans un délai minimum de 7 jours',
    ],
    answer: 'À l’égard de la même personne',
    explanation:
        'Jurisprudence citée au cours : menaces réitérées envers la même personne.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Matérialisation',
    question:
        'La matérialisation de la menace par un écrit rend la réitération :',
    options: [
      'Inutile',
      'Obligatoire',
      'Possible uniquement si la victime répond',
    ],
    answer: 'Inutile',
    explanation:
        'Le cours indique que la matérialisation représente la répétition nécessaire de la pensée de l’agent.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Moyen',
    question: 'Dans le cadre de l’article 222-17 CP, la menace doit être :',
    options: [
      'Réitérée OU matérialisée par un écrit, une image ou un objet',
      'Exclusivement écrite',
      'Exclusivement verbale',
    ],
    answer: 'Réitérée OU matérialisée par un écrit, une image ou un objet',
    explanation:
        'Le texte exige l’une des deux modalités : réitération ou matérialisation.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Direction',
    question: 'La menace faite « à la cantonade » :',
    options: [
      'Ne constitue pas l’infraction',
      'Constitue l’infraction automatiquement',
      'Constitue une tentative',
    ],
    answer: 'Ne constitue pas l’infraction',
    explanation: 'Le cours : la menace doit être dirigée contre une personne.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Élément moral',
    question: 'Pour caractériser l’infraction de menace, la loi exige :',
    options: [
      'L’intention d’impressionner la victime, pas la volonté de passer à l’acte',
      'La volonté certaine de passer à l’acte',
      'Un mobile haineux',
    ],
    answer:
        'L’intention d’impressionner la victime, pas la volonté de passer à l’acte',
    explanation:
        'Le cours précise que l’auteur n’a pas à vouloir exécuter la menace.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Aggravation',
    question:
        'La menace est aggravée au titre de l’article 222-17 al.2 CP lorsqu’il s’agit :',
    options: [
      'D’une menace de mort',
      'D’une menace de vol',
      'D’une menace de dégradation',
    ],
    answer: 'D’une menace de mort',
    explanation: 'Le cours : aggravation spécifique pour la menace de mort.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Répression',
    question: 'La menace simple (222-17 al.1 CP) est punie de :',
    options: [
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '6 mois d’emprisonnement et 7 500 € d’amende',
    explanation:
        'Tableau de répression du cours pour l’article 222-17 al.1 CP.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Répression',
    question: 'La menace de mort (222-17 al.2 CP) est punie de :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le cours : aggravation « menace de mort » à 3 ans / 45 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Conjugalité',
    question:
        'L’article 222-18-3 CP prévoit deux degrés d’aggravation lorsque les menaces sont commises :',
    options: [
      'Par le conjoint/concubin/partenaire PACS',
      'Par un voisin',
      'Par un collègue',
    ],
    answer: 'Par le conjoint/concubin/partenaire PACS',
    explanation:
        'Le cours : 222-18-3 CP organise l’aggravation en contexte conjugal.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Conjugalité',
    question: 'Le second degré d’aggravation (222-18-3 CP) concerne :',
    options: [
      'Les menaces de mort commises par le conjoint/concubin/partenaire PACS',
      'Les menaces simples commises par un tiers',
      'Les menaces par écrit uniquement',
    ],
    answer:
        'Les menaces de mort commises par le conjoint/concubin/partenaire PACS',
    explanation:
        'Le cours : aggravation renforcée si menace de mort en contexte conjugal.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // MENACE AVEC CONDITION (222-18 CP) — CONCOURS
  // =========================================================
  QuizQuestion(
    category: 'Menace avec condition (222-18) — Fondement',
    question:
        'La menace de commettre un crime ou un délit avec ordre de remplir une condition est prévue par :',
    options: [
      'L’article 222-18 du Code pénal',
      'L’article 222-17 du Code pénal',
      'L’article 222-16 du Code pénal',
    ],
    answer: 'L’article 222-18 du Code pénal',
    explanation: 'Le cours : 222-18 CP réprime la menace avec condition.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Menace avec condition (222-18) — Champ',
    question: 'À la différence de 222-17, 222-18 vise :',
    options: [
      'Tout crime ou délit contre les personnes, sans exiger que la tentative soit punissable',
      'Uniquement les crimes',
      'Uniquement les contraventions',
    ],
    answer:
        'Tout crime ou délit contre les personnes, sans exiger que la tentative soit punissable',
    explanation:
        'Le cours : 222-18 ne conditionne pas à la punissabilité de la tentative.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Menace avec condition (222-18) — Condition',
    question: 'La « condition » peut prendre la forme :',
    options: [
      'D’une obligation de faire ou de ne pas faire',
      'Uniquement d’une somme d’argent',
      'Uniquement d’une action matérielle',
    ],
    answer: 'D’une obligation de faire ou de ne pas faire',
    explanation:
        'Le cours : action ou abstention, obligation de faire ou ne pas faire.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace avec condition (222-18) — Moyen',
    question: 'Le moyen de menace au sens de 222-18 est :',
    options: [
      'Indéterminé (« par quelque moyen que ce soit »)',
      'Nécessairement écrit',
      'Nécessairement réitéré',
    ],
    answer: 'Indéterminé (« par quelque moyen que ce soit »)',
    explanation: 'Le cours : pas besoin de réitération, moyen indéterminé.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Menace avec condition (222-18) — Élément moral',
    question: 'L’élément moral de 222-18 consiste dans :',
    options: [
      'La conscience d’exercer une pression pour contraindre la victime',
      'L’intention certaine de tuer',
      'Une imprudence',
    ],
    answer: 'La conscience d’exercer une pression pour contraindre la victime',
    explanation:
        'Le cours : dessein de peser méchamment par contrainte morale.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace avec condition (222-18) — Aggravation',
    question: 'L’aggravation spécifique de 222-18 al.2 CP vise :',
    options: [
      'La menace de mort',
      'La menace de diffamation',
      'La menace de tapage nocturne',
    ],
    answer: 'La menace de mort',
    explanation:
        'Le cours : aggravation lorsqu’il s’agit d’une menace de mort.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Menace avec condition (222-18) — Répression',
    question: 'La menace avec condition (222-18 al.1 CP) est punie de :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Tableau de répression du cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace avec condition (222-18) — Répression',
    question:
        'La menace de mort avec condition (222-18 al.2 CP) est punie de :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Le cours : aggravation à 5 ans / 75 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace avec condition (222-18) — Conjugalité',
    question:
        'En contexte conjugal, 222-18-3 CP prévoit pour la menace avec condition :',
    options: [
      'Deux degrés d’aggravation (dont le second pour la menace de mort)',
      'Une atténuation automatique',
      'Une contravention',
    ],
    answer: 'Deux degrés d’aggravation (dont le second pour la menace de mort)',
    explanation: 'Le cours : 222-18-3 CP s’applique à 222-18 al.1 et al.2.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Menace avec condition (222-18) — Tentative',
    question: 'La tentative de menace avec condition est :',
    options: ['Non punissable', 'Punissable', 'Un crime'],
    answer: 'Non punissable',
    explanation: 'Le cours : tentative non prévue.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // EMBUSCADE (222-15-1 CP) — ENORME BANQUE
  // =========================================================
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Fondement',
    question: 'L’embuscade est définie comme :',
    options: [
      'Le fait d’attendre un certain temps et dans un lieu déterminé une victime',
      'Le fait de suivre une personne dans la rue',
      'Le fait d’insulter une personne',
    ],
    answer:
        'Le fait d’attendre un certain temps et dans un lieu déterminé une victime',
    explanation:
        'Le cours : définition du guet-apens dans le délit d’embuscade.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — But',
    question: 'Le but de l’embuscade est de commettre :',
    options: [
      'Des violences avec usage ou menace d’une arme',
      'Une contravention routière',
      'Un vol sans violence uniquement',
    ],
    answer: 'Des violences avec usage ou menace d’une arme',
    explanation: 'Le texte vise violences avec usage ou menace d’une arme.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Arme',
    question: 'Dans l’embuscade, la notion d’arme vise :',
    options: [
      'Arme par nature ou par destination',
      'Uniquement arme à feu',
      'Uniquement arme blanche',
    ],
    answer: 'Arme par nature ou par destination',
    explanation: 'Le cours mentionne arme à feu, couteau, bâton, chien, etc.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Violence non réalisée',
    question: 'Concernant l’embuscade, les violences projetées :',
    options: [
      'N’ont pas besoin d’être consommées',
      'Doivent entraîner une ITT',
      'Doivent être réalisées au minimum',
    ],
    answer: 'N’ont pas besoin d’être consommées',
    explanation:
        'Le législateur permet d’intervenir avant la consommation des violences.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Passage à l’action',
    question:
        'Si l’auteur passe à l’action et commet les violences, il est poursuivi :',
    options: [
      'Sur les textes réprimant les violences (physiques/psychologiques)',
      'Uniquement pour embuscade',
      'Pour une contravention',
    ],
    answer: 'Sur les textes réprimant les violences (physiques/psychologiques)',
    explanation:
        'Le cours : embuscade vise les violences en voie de réalisation, pas celles déjà réalisées.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Victimes',
    question: 'Les victimes visées incluent :',
    options: [
      'Police, gendarmerie, administration pénitentiaire, DDAP, sapeurs-pompiers, transport public',
      'Uniquement les forces de l’ordre',
      'Uniquement les élus',
    ],
    answer:
        'Police, gendarmerie, administration pénitentiaire, DDAP, sapeurs-pompiers, transport public',
    explanation:
        'Liste prévue au cours (agents force publique, AP, DDAP, pompiers, transport).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Proches',
    question: 'Constitue aussi une embuscade le fait d’attendre :',
    options: [
      'Le conjoint/ascendant/descendant ou une personne vivant au domicile de la victime principale',
      'Un collègue de travail quelconque',
      'Un voisin sans lien',
    ],
    answer:
        'Le conjoint/ascendant/descendant ou une personne vivant au domicile de la victime principale',
    explanation:
        'Le texte étend l’embuscade aux proches vivant habituellement au domicile.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Contexte',
    question: 'L’embuscade doit être commise :',
    options: [
      'À l’occasion de l’exercice des fonctions/mission ou en raison de la qualité',
      'Uniquement en service',
      'Uniquement hors service',
    ],
    answer:
        'À l’occasion de l’exercice des fonctions/mission ou en raison de la qualité',
    explanation: 'Le cours : deux alternatives de contexte.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Élément moral',
    question: 'L’embuscade doit être caractérisée par :',
    options: [
      'Un ou plusieurs faits matériels traduisant la détermination d’agir',
      'Une simple idée',
      'Une imprudence',
    ],
    answer:
        'Un ou plusieurs faits matériels traduisant la détermination d’agir',
    explanation:
        'Le cours : matérialisation de la volonté d’agir par des faits matériels.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Aggravation',
    question: 'L’embuscade est aggravée lorsqu’elle est commise :',
    options: ['En réunion', 'Avec une ITT > 8 jours', 'Sur mineur de 15 ans'],
    answer: 'En réunion',
    explanation: 'Article 222-15-1 al.4 CP : aggravation en réunion.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Peines',
    question: 'L’embuscade simple est punie de :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Tableau de répression du cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Peines',
    question: 'L’embuscade aggravée (en réunion) est punie de :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Le cours : aggravation en réunion → 7 ans / 100 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Tentative',
    question: 'La tentative d’embuscade est :',
    options: ['Non punissable', 'Punissable', 'Toujours retenue'],
    answer: 'Non punissable',
    explanation: 'Le cours : la consommation se situe avant la tentative.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Complicité',
    question: 'La complicité d’embuscade est :',
    options: ['Punissable', 'Non punissable', 'Une contravention'],
    answer: 'Punissable',
    explanation: 'Le cours : complicité oui (121-6 et 121-7 CP).',
    difficulty: 'Facile',
  ),

  // =========================================================
  // APPELS / MESSAGES / AGRESSIONS SONORES (222-16 CP) — ENORME
  // =========================================================
  QuizQuestion(
    category: 'Appels malveillants (222-16) — Fondement',
    question:
        'Les appels téléphoniques malveillants réitérés sont prévus par :',
    options: [
      'L’article 222-16 du Code pénal',
      'L’article 222-17 du Code pénal',
      'L’article 222-18 du Code pénal',
    ],
    answer: 'L’article 222-16 du Code pénal',
    explanation: 'Le cours : 222-16 CP.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Appels malveillants (222-16) — Supports',
    question: 'Sont visés par 222-16 CP :',
    options: [
      'Appels téléphoniques, messages électroniques réitérés, agressions sonores',
      'Uniquement les appels en direct',
      'Uniquement les courriers postaux',
    ],
    answer:
        'Appels téléphoniques, messages électroniques réitérés, agressions sonores',
    explanation:
        'Le texte vise appels, messages électroniques, agressions sonores.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Appels malveillants (222-16) — Répondeur',
    question: 'Les appels reçus sur répondeur/boîte vocale :',
    options: [
      'Sont pris en compte',
      'Ne sont jamais pris en compte',
      'Sont pris en compte uniquement si l’auteur est identifié',
    ],
    answer: 'Sont pris en compte',
    explanation:
        'Jurisprudence au cours : appels reçus directement ou sur boîte vocale.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Messages malveillants (222-16) — Réitération',
    question: 'Les messages malveillants visés peuvent être :',
    options: [
      'SMS, MMS, courriers électroniques',
      'Uniquement lettres manuscrites',
      'Uniquement messages vocaux',
    ],
    answer: 'SMS, MMS, courriers électroniques',
    explanation: 'Le cours cite ces exemples de communications électroniques.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Appels malveillants (222-16) — Malveillance',
    question: 'La malveillance se définit comme :',
    options: [
      'La volonté de faire le mal, de nuire à autrui',
      'Une maladresse',
      'Un simple désaccord',
    ],
    answer: 'La volonté de faire le mal, de nuire à autrui',
    explanation: 'Définition donnée par le cours.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Appels malveillants (222-16) — Preuve',
    question: 'Le caractère malveillant peut être déduit :',
    options: [
      'Du contenu ET/OU de la multiplication des appels',
      'Uniquement du contenu du message',
      'Uniquement de l’ITT',
    ],
    answer: 'Du contenu ET/OU de la multiplication des appels',
    explanation: 'Le cours : la seule multiplication peut suffire.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Appels malveillants (222-16) — Réitération',
    question: 'La réitération est caractérisée dès lors qu’il existe :',
    options: [
      'Deux appels successifs, même à des destinataires différents',
      'Trois appels minimum à la même personne',
      'Deux appels espacés d’au moins 24h',
    ],
    answer: 'Deux appels successifs, même à des destinataires différents',
    explanation: 'Cass. crim. (4 mars 2003) citée au cours.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Agressions sonores (222-16) — Réitération',
    question: 'Pour les agressions sonores, la réitération est :',
    options: ['Non exigée', 'Toujours exigée', 'Exigée seulement la nuit'],
    answer: 'Non exigée',
    explanation:
        'Le cours : pas de condition de réitération pour les agressions sonores.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Agressions sonores (222-16) — Intention',
    question: 'L’élément intentionnel des agressions sonores est :',
    options: [
      'La volonté de troubler la tranquillité d’autrui',
      'La préméditation',
      'La maladresse',
    ],
    answer: 'La volonté de troubler la tranquillité d’autrui',
    explanation: 'Le texte vise des agissements commis « en vue de troubler ».',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Appels/mails (222-16) — Tentative',
    question: 'La tentative de l’infraction prévue à l’article 222-16 CP est :',
    options: ['Non punissable', 'Punissable', 'Toujours retenue'],
    answer: 'Non punissable',
    explanation: 'Le cours : tentative non.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Appels/mails (222-16) — Aggravation',
    question:
        'L’infraction 222-16 CP est aggravée lorsque les faits sont commis :',
    options: [
      'Par le conjoint/concubin/partenaire PACS',
      'Par un mineur',
      'Par un agent public',
    ],
    answer: 'Par le conjoint/concubin/partenaire PACS',
    explanation: 'Article 222-16 al.2 CP.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Appels/mails (222-16) — Répression',
    question: 'La forme simple (222-16 CP) est punie de :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation: 'Le cours : 1 an / 15 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Appels/mails (222-16) — Répression',
    question: 'La forme aggravée (222-16 al.2 CP) est punie de :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le cours : aggravée conjugalité → 3 ans / 45 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Appels/mails (222-16) — Complicité',
    question: 'La complicité pour 222-16 CP est :',
    options: ['Punissable', 'Non punissable', 'Une contravention'],
    answer: 'Punissable',
    explanation: 'Le cours : complicité oui (121-6 et 121-7 CP).',
    difficulty: 'Facile',
  ),

  // =========================================================
  // TORTURES ET ACTES DE BARBARIE (222-1 et s.) — ENORME
  // =========================================================
  QuizQuestion(
    category: 'Tortures/Barbarie — Fondement',
    question:
        'Le fait de soumettre une personne à des actes de torture ou de barbarie est prévu par :',
    options: [
      'L’article 222-1 du Code pénal',
      'L’article 222-14 du Code pénal',
      'L’article 221-1 du Code pénal',
    ],
    answer: 'L’article 222-1 du Code pénal',
    explanation: 'Le cours : 222-1 CP.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Définition ONU',
    question: 'La Convention ONU (10 décembre 1984) définit la torture comme :',
    options: [
      'Tout acte infligeant intentionnellement une douleur ou des souffrances aiguës',
      'Toute douleur involontaire',
      'Toute insulte',
    ],
    answer:
        'Tout acte infligeant intentionnellement une douleur ou des souffrances aiguës',
    explanation:
        'Le cours cite la Convention des Nations Unies contre la torture.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Jurisprudence',
    question:
        'Selon la jurisprudence, les tortures ou actes de barbarie supposent :',
    options: [
      'Des actes d’une gravité exceptionnelle dépassant de simples violences',
      'Des violences légères répétées',
      'Une imprudence',
    ],
    answer:
        'Des actes d’une gravité exceptionnelle dépassant de simples violences',
    explanation:
        'Définition jurisprudentielle reprise au cours (gravité exceptionnelle, dignité).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Souffrance',
    question: 'La souffrance infligée peut être :',
    options: ['Physique ou morale', 'Uniquement physique', 'Uniquement morale'],
    answer: 'Physique ou morale',
    explanation: 'Le cours : souffrance d’ordre physique ou moral.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Victime',
    question: 'Les tortures et actes de barbarie doivent être commis :',
    options: [
      'Sur une personne humaine vivante distincte de l’auteur',
      'Sur un animal',
      'Sur un cadavre',
    ],
    answer: 'Sur une personne humaine vivante distincte de l’auteur',
    explanation: 'Le cours : personne humaine, vivante, distincte.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Élément moral',
    question: 'L’élément moral comprend :',
    options: [
      'La volonté de causer une souffrance exceptionnellement aiguë / nier la dignité',
      'Une simple négligence',
      'Un doute sur le résultat',
    ],
    answer:
        'La volonté de causer une souffrance exceptionnellement aiguë / nier la dignité',
    explanation: 'Le cours : volonté de nier la dignité humaine.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — 1er degré (222-3)',
    question:
        'Le premier degré d’aggravation (222-3 CP) vise notamment des faits commis :',
    options: [
      'Sur mineur de 15 ans, personne vulnérable, dépositaire autorité publique, avec arme, préméditation ou guet-apens…',
      'Uniquement en bande organisée',
      'Uniquement sur conjoint',
    ],
    answer:
        'Sur mineur de 15 ans, personne vulnérable, dépositaire autorité publique, avec arme, préméditation ou guet-apens…',
    explanation:
        'Le cours liste les circonstances de 222-3 CP (alinéas 2 à 18).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — 2e degré',
    question: 'Le deuxième degré d’aggravation peut résulter notamment :',
    options: [
      'De la bande organisée (222-4) ou d’une mutilation/infirmité permanente (222-5)',
      'Uniquement d’une ITT',
      'Uniquement d’une menace',
    ],
    answer:
        'De la bande organisée (222-4) ou d’une mutilation/infirmité permanente (222-5)',
    explanation:
        'Le cours : 222-4 (bande organisée…), 222-5 (mutilation/infirmité permanente).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — 3e degré',
    question: 'Le troisième degré d’aggravation peut viser :',
    options: [
      'Les tortures précédant/accompagnant/suivant un crime autre que meurtre/viol (222-2) ou la mort sans intention (222-6)',
      'Une simple blessure légère',
      'Une contravention',
    ],
    answer:
        'Les tortures précédant/accompagnant/suivant un crime autre que meurtre/viol (222-2) ou la mort sans intention (222-6)',
    explanation:
        'Le cours distingue 222-2 et 222-6 (mort sans intention de la donner).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Peine simple',
    question: 'Les tortures/actes de barbarie (forme simple) sont punis de :',
    options: [
      '15 ans de réclusion (période de sûreté)',
      '10 ans d’emprisonnement',
      '30 ans de réclusion',
    ],
    answer: '15 ans de réclusion (période de sûreté)',
    explanation:
        'Tableau du cours : 222-1 CP → 15 ans réclusion + période de sûreté.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Peine 1er degré',
    question:
        'Les tortures/actes de barbarie aggravés (1er degré) sont punis de :',
    options: [
      '20 ans de réclusion (période de sûreté)',
      '15 ans de réclusion',
      '30 ans de réclusion',
    ],
    answer: '20 ans de réclusion (période de sûreté)',
    explanation:
        'Tableau du cours : 222-3 CP → 20 ans réclusion + période de sûreté.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Peine 2e degré',
    question:
        'Le 2e degré (ex : bande organisée / habitude sur mineur / vulnérabilité / sujétion) est puni de :',
    options: [
      '30 ans de réclusion (période de sûreté)',
      '20 ans de réclusion',
      '10 ans d’emprisonnement',
    ],
    answer: '30 ans de réclusion (période de sûreté)',
    explanation:
        'Le cours : aggravations 2e degré → 30 ans réclusion + période de sûreté.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Peine 3e degré',
    question:
        'Le 3e degré (ex : mort sans intention de la donner / concours crime autre que meurtre ou viol) est puni de :',
    options: [
      'Réclusion criminelle à perpétuité (période de sûreté)',
      '30 ans de réclusion',
      '15 ans de réclusion',
    ],
    answer: 'Réclusion criminelle à perpétuité (période de sûreté)',
    explanation:
        'Le cours : aggravations 3e degré → perpétuité + période de sûreté.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Tentative',
    question: 'La tentative de tortures/actes de barbarie est :',
    options: ['Punissable', 'Non punissable', 'Une contravention'],
    answer: 'Punissable',
    explanation: 'Le cours : tentative de crime toujours punissable.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Complicité',
    question: 'La complicité de tortures/actes de barbarie est :',
    options: [
      'Punissable (121-6 et 121-7 CP)',
      'Non punissable',
      'Une contravention',
    ],
    answer: 'Punissable (121-6 et 121-7 CP)',
    explanation: 'Le cours : complicité oui.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Provocation',
    question: 'La provocation à commettre des tortures/actes de barbarie est :',
    options: [
      'Une infraction distincte',
      'Une simple tentative',
      'Une contravention',
    ],
    answer: 'Une infraction distincte',
    explanation: 'Le cours : incrimination autonome (222-6-4 CP).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Exemption',
    question:
        'L’exemption de peine est possible si la personne ayant tenté d’un crime du paragraphe :',
    options: [
      'A averti l’autorité et a permis d’éviter la réalisation de l’infraction',
      'A simplement regretté',
      'A payé une amende',
    ],
    answer:
        'A averti l’autorité et a permis d’éviter la réalisation de l’infraction',
    explanation: 'Le cours : 222-6-2 al.1 CP.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Réduction',
    question:
        'La réduction de peine intervient si l’auteur/complice a averti l’autorité et a permis :',
    options: [
      'De faire cesser l’infraction, éviter mort/infirmité permanente, ou identifier les autres',
      'Uniquement de retrouver l’arme',
      'Uniquement de récupérer un objet volé',
    ],
    answer:
        'De faire cesser l’infraction, éviter mort/infirmité permanente, ou identifier les autres',
    explanation: 'Le cours : 222-6-2 al.2 CP.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // VIOLENCES HABITUELLES AU SEIN DU COUPLE / EX (222-14 al.6)
  // =========================================================
  QuizQuestion(
    category: 'Violences habituelles (couple/ex) — Fondement',
    question:
        'Les violences habituelles au sein du couple ou commises par un « ex » sont définies par :',
    options: [
      'L’article 222-14 alinéa 6 du Code pénal',
      'L’article 222-14-5 du Code pénal',
      'L’article 222-15-1 du Code pénal',
    ],
    answer: 'L’article 222-14 alinéa 6 du Code pénal',
    explanation: 'Le cours : définition 222-14 al.6 ; répression al.2 à 5.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences habituelles (couple/ex) — Habitude',
    question: 'L’habitude suppose que les violences aient été commises :',
    options: ['À plusieurs reprises', 'Une seule fois', 'Uniquement de nuit'],
    answer: 'À plusieurs reprises',
    explanation: 'Le cours : répétition nécessaire.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violences habituelles (couple/ex) — Nature',
    question: 'Les violences volontaires peuvent être :',
    options: [
      'Physiques et/ou psychologiques',
      'Uniquement physiques',
      'Uniquement morales',
    ],
    answer: 'Physiques et/ou psychologiques',
    explanation: 'Le cours : violences psychologiques reconnues et codifiées.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violences habituelles (couple/ex) — Omission',
    question: 'La simple abstention (omission) constitue :',
    options: [
      'Pas une violence (d’autres qualifications possibles)',
      'Toujours une violence',
      'Toujours une contravention',
    ],
    answer: 'Pas une violence (d’autres qualifications possibles)',
    explanation:
        'Le cours : violence = acte positif, sinon qualification différente (privation de soins, etc.).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences habituelles (couple/ex) — Lien',
    question: 'Le lien exigé entre l’auteur et la victime vise :',
    options: [
      'Conjoint/concubin/partenaire PACS, y compris sans cohabitation',
      'Uniquement les époux mariés',
      'Uniquement les ex-époux',
    ],
    answer: 'Conjoint/concubin/partenaire PACS, y compris sans cohabitation',
    explanation: 'Le cours : couple, même sans cohabitation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences habituelles (couple/ex) — Ex',
    question:
        'L’alinéa 6 renvoie à l’article 132-80 al.2 : la circonstance est constituée lorsque les faits sont commis :',
    options: [
      'Par l’ancien conjoint/concubin/partenaire PACS en raison des relations ayant existé',
      'Par n’importe quelle personne sans lien',
      'Uniquement si la victime a porté plainte auparavant',
    ],
    answer:
        'Par l’ancien conjoint/concubin/partenaire PACS en raison des relations ayant existé',
    explanation: 'Le cours reprend le mécanisme de 132-80 al.2.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences habituelles (couple/ex) — Résultat',
    question: 'Le résultat dommageable se caractérise notamment par :',
    options: [
      'Une atteinte à l’intégrité physique et/ou psychique constatée médicalement',
      'Une simple dispute',
      'Une rumeur',
    ],
    answer:
        'Une atteinte à l’intégrité physique et/ou psychique constatée médicalement',
    explanation: 'Le cours : certificat médical, atteinte physique/psychique.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences habituelles (couple/ex) — Préjudices',
    question:
        'L’article 222-14 distingue notamment les violences selon qu’elles :',
    options: [
      'Ont entraîné mort, infirmité permanente, ITT > 8 jours, ou ITT ≤ 8 jours/aucune',
      'Ont entraîné uniquement une ITT',
      'Sont commises de nuit ou de jour',
    ],
    answer:
        'Ont entraîné mort, infirmité permanente, ITT > 8 jours, ou ITT ≤ 8 jours/aucune',
    explanation: 'Le cours : 4 catégories de préjudices.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences habituelles (couple/ex) — Peine ITT ≤ 8',
    question:
        'Les violences habituelles (couple/ex) avec ITT de 0 à 8 jours sont punies de :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Tableau du cours pour 222-14 (délit).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences habituelles (couple/ex) — Peine ITT > 8',
    question:
        'Les violences habituelles (couple/ex) avec ITT > 8 jours sont punies de :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '20 ans de réclusion',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation: 'Tableau du cours : ITT > 8 jours → 10 ans / 150 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences habituelles (couple/ex) — Peine infirmité',
    question:
        'Les violences habituelles (couple/ex) ayant entraîné une mutilation ou infirmité permanente sont punies de :',
    options: [
      '20 ans de réclusion (période de sûreté)',
      '10 ans d’emprisonnement',
      '30 ans de réclusion',
    ],
    answer: '20 ans de réclusion (période de sûreté)',
    explanation: 'Tableau du cours : passage en crime → 20 ans réclusion.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences habituelles (couple/ex) — Peine mort',
    question:
        'Les violences habituelles (couple/ex) ayant entraîné la mort sans intention de la donner sont punies de :',
    options: [
      '30 ans de réclusion (période de sûreté)',
      '20 ans de réclusion',
      '15 ans de réclusion',
    ],
    answer: '30 ans de réclusion (période de sûreté)',
    explanation: 'Tableau du cours : mort sans intention → 30 ans réclusion.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences habituelles (couple/ex) — Tentative',
    question:
        'La tentative en matière de violences délictuelles (dont 222-14) est :',
    options: [
      'Non visée par les textes (donc non punissable en principe)',
      'Toujours punissable',
      'Toujours retenue',
    ],
    answer: 'Non visée par les textes (donc non punissable en principe)',
    explanation:
        'Le cours : textes relatifs aux violences délictuelles ne visent pas la tentative.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences habituelles (couple/ex) — Complicité',
    question: 'La complicité pour les violences habituelles (222-14) est :',
    options: ['Punissable', 'Non punissable', 'Une contravention'],
    answer: 'Punissable',
    explanation: 'Le cours : 121-6 et 121-7 CP.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // VIOLENCES HABITUELLES SUR MINEUR / VULNÉRABLE (222-14 al.1)
  // =========================================================
  QuizQuestion(
    category: 'Violences habituelles (mineur/vulnérable) — Fondement',
    question:
        'Les violences habituelles sur mineur de 15 ans ou personne vulnérable sont définies par :',
    options: [
      'L’article 222-14 alinéa 1 du Code pénal',
      'L’article 222-14 alinéa 6 du Code pénal',
      'L’article 222-14-5 du Code pénal',
    ],
    answer: 'L’article 222-14 alinéa 1 du Code pénal',
    explanation: 'Le cours : alinéa 1 définit, alinéas 2 à 5 répriment.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences habituelles (mineur/vulnérable) — Mineur',
    question: 'La condition de minorité visée est :',
    options: ['Mineur de 15 ans', 'Mineur de 18 ans', 'Mineur de 13 ans'],
    answer: 'Mineur de 15 ans',
    explanation: 'Le cours : mineur de 15 ans.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violences habituelles (mineur/vulnérable) — Vulnérabilité',
    question: 'La particulière vulnérabilité peut être due :',
    options: [
      'À l’âge, la maladie, une infirmité, une déficience physique/psychique, ou la grossesse',
      'Uniquement à la pauvreté',
      'Uniquement à l’isolement social',
    ],
    answer:
        'À l’âge, la maladie, une infirmité, une déficience physique/psychique, ou la grossesse',
    explanation: 'Le cours reprend la liste classique.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences habituelles (mineur/vulnérable) — Préexistence',
    question: 'La vulnérabilité doit :',
    options: [
      'Préexister aux faits (ne pas être leur conséquence)',
      'Résulter des violences',
      'Être déclarée par la victime uniquement',
    ],
    answer: 'Préexister aux faits (ne pas être leur conséquence)',
    explanation: 'Le cours : état préexistant.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences habituelles (mineur/vulnérable) — Sujétion',
    question: 'L’état de sujétion (223-15-3 CP) résulte :',
    options: [
      'De pressions graves/réitérées ou techniques altérant le jugement, causant altération grave ou conduisant à un acte/abstention gravement préjudiciable',
      'D’une simple dispute',
      'D’un seul appel téléphonique',
    ],
    answer:
        'De pressions graves/réitérées ou techniques altérant le jugement, causant altération grave ou conduisant à un acte/abstention gravement préjudiciable',
    explanation: 'Définition détaillée donnée dans le cours.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences habituelles (mineur/vulnérable) — Peine ITT ≤ 8',
    question:
        'Les violences habituelles sur mineur/vulnérable avec ITT ≤ 8 jours sont punies de :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Le cours : même échelle 222-14 selon résultat.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences habituelles (mineur/vulnérable) — Peine ITT > 8',
    question:
        'Les violences habituelles sur mineur/vulnérable avec ITT > 8 jours sont punies de :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '20 ans de réclusion',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation: 'Tableau du cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences habituelles (mineur/vulnérable) — Peine infirmité',
    question:
        'Les violences habituelles sur mineur/vulnérable ayant entraîné une infirmité permanente sont punies de :',
    options: [
      '20 ans de réclusion (période de sûreté)',
      '10 ans d’emprisonnement',
      '30 ans de réclusion',
    ],
    answer: '20 ans de réclusion (période de sûreté)',
    explanation: 'Le cours : crime → 20 ans réclusion.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences habituelles (mineur/vulnérable) — Peine mort',
    question:
        'Les violences habituelles sur mineur/vulnérable ayant entraîné la mort sans intention de la donner sont punies de :',
    options: [
      '30 ans de réclusion (période de sûreté)',
      '20 ans de réclusion',
      '15 ans de réclusion',
    ],
    answer: '30 ans de réclusion (période de sûreté)',
    explanation: 'Le cours : mort sans intention → 30 ans réclusion.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // VIOLENCES SUR FORCES DE SÉCURITÉ INTÉRIEURE / ÉLUS (222-14-5)
  // =========================================================
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — Fondement',
    question:
        'Les violences sur les forces de sécurité intérieure ou sur les élus locaux sont définies et réprimées par :',
    options: [
      'L’article 222-14-5 du Code pénal',
      'L’article 222-14-1 du Code pénal',
      'L’article 222-16 du Code pénal',
    ],
    answer: 'L’article 222-14-5 du Code pénal',
    explanation: 'Le cours : article 222-14-5 CP.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — Victimes',
    question: 'Parmi les victimes visées, on trouve notamment :',
    options: [
      'Gendarmerie, police nationale, police municipale, garde champêtre, douanes, sapeurs-pompiers, administration pénitentiaire, élus',
      'Uniquement police nationale',
      'Uniquement élus',
    ],
    answer:
        'Gendarmerie, police nationale, police municipale, garde champêtre, douanes, sapeurs-pompiers, administration pénitentiaire, élus',
    explanation: 'Le cours énumère la liste exhaustive du I.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — Élus',
    question:
        'Sont aussi visés les anciens titulaires d’un mandat électif public :',
    options: [
      'Dans la limite de six ans à compter de l’expiration du mandat',
      'Sans limite de temps',
      'Seulement pendant un an',
    ],
    answer: 'Dans la limite de six ans à compter de l’expiration du mandat',
    explanation: 'Le cours : limite de six ans.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — Proches',
    question:
        'Les proches pouvant être victimes en raison des fonctions du proche sont :',
    options: [
      'Conjoint, ascendants/descendants en ligne directe, ou toute personne vivant habituellement au domicile',
      'Uniquement les enfants',
      'Uniquement le conjoint',
    ],
    answer:
        'Conjoint, ascendants/descendants en ligne directe, ou toute personne vivant habituellement au domicile',
    explanation: 'Le cours : 222-14-5 II 1°.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — Personnels concourants',
    question:
        'Sont visées les personnes affectées dans les services (PN/GN/PM/AP) agissant sous l’autorité des FSI/élus, comme :',
    options: [
      'Réservistes, contractuels, personnels administratifs, service civique',
      'Uniquement les magistrats',
      'Uniquement les journalistes',
    ],
    answer:
        'Réservistes, contractuels, personnels administratifs, service civique',
    explanation: 'Le cours donne ces exemples.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — Contexte',
    question: 'Les violences doivent être commises :',
    options: [
      'Dans l’exercice des fonctions ou du fait des fonctions (actuelles ou passées), avec qualité apparente ou connue',
      'Uniquement en service',
      'Uniquement si la victime est blessée',
    ],
    answer:
        'Dans l’exercice des fonctions ou du fait des fonctions (actuelles ou passées), avec qualité apparente ou connue',
    explanation:
        'Le cours : exercice ou du fait + qualité apparente ou connue.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — Résultat',
    question: 'L’article 222-14-5 distingue les violences selon qu’elles :',
    options: [
      'Ont entraîné une ITT > 8 jours ou une ITT ≤ 8 jours / aucune ITT',
      'Ont entraîné une mort',
      'Ont entraîné une infirmité permanente',
    ],
    answer: 'Ont entraîné une ITT > 8 jours ou une ITT ≤ 8 jours / aucune ITT',
    explanation: 'Le cours : deux catégories seulement pour 222-14-5.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — Élément moral',
    question: 'L’élément moral implique :',
    options: [
      'La volonté de commettre des violences sur une personne dont la qualité est déterminée',
      'Une imprudence',
      'Un accident',
    ],
    answer:
        'La volonté de commettre des violences sur une personne dont la qualité est déterminée',
    explanation:
        'Le cours : conscience + volonté de viser une personne à qualité déterminée.',
    difficulty: 'Moyenne',
  ),

  // --- Aggravations ITT ≤ 8 / aucune ITT (222-14-5) ---
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — Aggravation',
    question:
        'Pour les violences ITT ≤ 8 jours / aucune ITT, 222-14-5 prévoit :',
    options: [
      'Deux degrés d’aggravation',
      'Un seul degré d’aggravation',
      'Aucune aggravation possible',
    ],
    answer: 'Deux degrés d’aggravation',
    explanation:
        'Le cours : premier degré (1 circonstance), second degré (au moins 2).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — 1er degré',
    question:
        'Le premier degré d’aggravation (ITT ≤ 8) s’applique lorsque les faits sont accompagnés :',
    options: [
      'D’une des circonstances des 8° à 15° de l’article 222-12 CP',
      'D’une seule menace verbale',
      'D’une simple bousculade',
    ],
    answer: 'D’une des circonstances des 8° à 15° de l’article 222-12 CP',
    explanation: 'Le cours : renvoi aux 8° à 15° de 222-12.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — 2e degré',
    question:
        'Le deuxième degré d’aggravation (ITT ≤ 8) s’applique lorsque les faits sont accompagnés :',
    options: [
      'D’au moins deux circonstances des 8° à 15° de 222-12 CP',
      'D’une seule circonstance',
      'D’aucune circonstance',
    ],
    answer: 'D’au moins deux circonstances des 8° à 15° de 222-12 CP',
    explanation: 'Le cours : cumul d’au moins deux circonstances.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — Exemples circonst. 222-12',
    question:
        'Parmi les circonstances 8° à 15° de 222-12, on retrouve notamment :',
    options: [
      'Préméditation/guet-apens, arme, plusieurs auteurs/complices, dissimulation du visage, ivresse/stupéfiants, transport collectif…',
      'Uniquement l’âge de la victime',
      'Uniquement la vulnérabilité',
    ],
    answer:
        'Préméditation/guet-apens, arme, plusieurs auteurs/complices, dissimulation du visage, ivresse/stupéfiants, transport collectif…',
    explanation: 'Le cours liste ces circonstances.',
    difficulty: 'Moyenne',
  ),

  // --- Aggravation ITT > 8 (222-14-5) ---
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — ITT > 8',
    question:
        'Pour les violences ayant entraîné une ITT > 8 jours, 222-14-5 prévoit :',
    options: [
      'Un degré d’aggravation en cas de circonstance 8° à 15° de 222-12 CP',
      'Deux degrés d’aggravation',
      'Aucune aggravation',
    ],
    answer:
        'Un degré d’aggravation en cas de circonstance 8° à 15° de 222-12 CP',
    explanation: 'Le cours : un degré d’aggravation pour ITT > 8.',
    difficulty: 'Difficile',
  ),

  // --- Peines (222-14-5) ---
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — Peine de base',
    question:
        'Les violences (aucune ITT ou ITT ≤ 8 jours) sur FSI/élus sont punies de :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Tableau du cours : 222-14-5 I/2°.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — Peine 1 circonstance',
    question:
        'Si (ITT ≤ 8) + une circonstance 8° à 15° de 222-12, la peine est :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Tableau du cours : 222-14-5 al.4.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — Peine 2 circonstances',
    question:
        'Si (ITT ≤ 8) + deux circonstances 8° à 15° de 222-12, la peine est :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation: 'Tableau du cours : second degré d’aggravation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — ITT > 8 (base)',
    question:
        'Les violences ayant entraîné une ITT > 8 jours sur FSI/élus sont punies de :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Tableau du cours : 222-14-5 I/1°.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — ITT > 8 + circonstance',
    question:
        'Si ITT > 8 jours + une circonstance 8° à 15° de 222-12, la peine est :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende (période de sûreté)',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende (période de sûreté)',
    explanation:
        'Tableau du cours : aggravation ITT > 8 + circonstance → 10 ans + période de sûreté.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — Personnes morales',
    question:
        'Les personnes morales peuvent être déclarées pénalement responsables et encourent :',
    options: [
      'Les peines prévues à l’article 222-16-1 du Code pénal',
      'Uniquement un rappel à la loi',
      'Aucune peine',
    ],
    answer: 'Les peines prévues à l’article 222-16-1 du Code pénal',
    explanation: 'Le cours : renvoi à 222-16-1 CP.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — Tentative',
    question:
        'La tentative pour les violences délictuelles visées par 222-14-5 est :',
    options: [
      'Non visée (donc non punissable en principe)',
      'Punissable',
      'Toujours retenue',
    ],
    answer: 'Non visée (donc non punissable en principe)',
    explanation:
        'Le cours : les textes relatifs aux violences délictuelles ne visent pas la tentative.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences FSI/Élus (222-14-5) — Complicité',
    question: 'La complicité pour 222-14-5 est :',
    options: [
      'Punissable (121-6 et 121-7 CP)',
      'Non punissable',
      'Une contravention',
    ],
    answer: 'Punissable (121-6 et 121-7 CP)',
    explanation: 'Le cours : complicité oui.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // BONUS — QUESTIONS "PIÈGES CONCOURS" (MÉLANGE DES THÈMES)
  // =========================================================
  QuizQuestion(
    category: 'Concours — Distinction 222-17 / 222-18',
    question: 'Quelle affirmation est exacte ?',
    options: [
      '222-17 exige réitération ou matérialisation + infraction menacée dont la tentative est punissable',
      '222-18 exige réitération et écrit obligatoires',
      '222-17 vise toute menace, même avec condition',
    ],
    answer:
        '222-17 exige réitération ou matérialisation + infraction menacée dont la tentative est punissable',
    explanation: 'Synthèse fidèle au cours.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Concours — Embuscade',
    question: 'Dans l’embuscade, le cœur de l’infraction est :',
    options: [
      'La préparation (guet-apens) en vue de violences avec arme, avant la consommation',
      'Le résultat (ITT) obligatoire',
      'La menace écrite',
    ],
    answer:
        'La préparation (guet-apens) en vue de violences avec arme, avant la consommation',
    explanation:
        'Le cours insiste : infraction préparée, violences non réalisées.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Concours — 222-16',
    question: 'Quel couple est correct ?',
    options: [
      'Appels malveillants/mails : réitération — Agressions sonores : pas de réitération exigée',
      'Appels malveillants : pas de réitération — Agressions sonores : réitération obligatoire',
      'Messages électroniques : interdits uniquement la nuit',
    ],
    answer:
        'Appels malveillants/mails : réitération — Agressions sonores : pas de réitération exigée',
    explanation:
        'Le cours : réitération pour appels/messages, pas pour agressions sonores.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Concours — Tortures',
    question:
        'Ce qui distingue principalement tortures/barbarie des violences « simples » est :',
    options: [
      'La gravité exceptionnelle des actes et l’atteinte à la dignité humaine',
      'Le fait qu’il y ait toujours une arme',
      'Le fait qu’il y ait toujours une ITT',
    ],
    answer:
        'La gravité exceptionnelle des actes et l’atteinte à la dignité humaine',
    explanation: 'Définition jurisprudentielle reprise par le cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Concours — Violences habituelles',
    question: 'La notion « d’habitude » signifie :',
    options: [
      'Répétition des violences (plusieurs reprises)',
      'Un acte unique particulièrement violent',
      'Une violence uniquement psychologique',
    ],
    answer: 'Répétition des violences (plusieurs reprises)',
    explanation: 'Le cours : répétition obligatoire.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Concours — 222-14-5',
    question: 'Sous 222-14-5, les préjudices pris en compte sont :',
    options: [
      'ITT > 8 jours / ITT ≤ 8 jours ou aucune ITT',
      'Mort / infirmité permanente uniquement',
      'Uniquement ITT > 3 mois',
    ],
    answer: 'ITT > 8 jours / ITT ≤ 8 jours ou aucune ITT',
    explanation: 'Le cours : deux catégories pour 222-14-5.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Concours — 222-14-5 aggravations',
    question:
        'Pour ITT ≤ 8 (ou aucune), l’aggravation « second degré » suppose :',
    options: [
      'Au moins deux circonstances 8° à 15° de 222-12 CP',
      'Une seule circonstance',
      'Une ITT > 8 jours',
    ],
    answer: 'Au moins deux circonstances 8° à 15° de 222-12 CP',
    explanation:
        'Le cours : second degré = cumul d’au moins deux circonstances.',
    difficulty: 'Difficile',
  ),
  // =======================
  // ENCORE — GROS AJOUT (3 niveaux) — À coller à la suite
  // =======================

  // =========================================================
  // MENACE 222-17 — CAS PRATIQUES / PIÈGES
  // =========================================================
  QuizQuestion(
    category: 'Menace (222-17) — Cas pratique',
    question:
        'Une personne dit à la victime : « Je vais te tuer » puis le répète plus tard à la même victime. L’élément matériel est :',
    options: [
      'Caractérisé par la réitération',
      'Non caractérisé car il faut un écrit',
      'Non caractérisé car il faut une condition',
    ],
    answer: 'Caractérisé par la réitération',
    explanation:
        '222-17 : menace réitérée (au moins deux fois) ou matérialisée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Cas pratique',
    question:
        'Une menace est formulée une seule fois mais envoyée par message écrit. L’infraction 222-17 est :',
    options: [
      'Constituée (matérialisation)',
      'Non constituée car il faut deux menaces',
      'Constituée uniquement si menace de mort',
    ],
    answer: 'Constituée (matérialisation)',
    explanation: 'La matérialisation par écrit dispense de la réitération.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Cas pratique',
    question:
        'Une personne mime une arme avec ses doigts en disant « pan pan » sans autre élément. Selon le cours, cela :',
    options: [
      'Ne suffit pas à matérialiser la menace',
      'Suffit toujours à matérialiser la menace',
      'Caractérise automatiquement une image',
    ],
    answer: 'Ne suffit pas à matérialiser la menace',
    explanation:
        'Le cours cite une jurisprudence excluant la gestuelle seule de la matérialisation.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Sens clair',
    question: 'La menace doit :',
    options: [
      'Avoir un sens suffisamment clair même si l’infraction n’est pas expressément désignée',
      'Désigner obligatoirement l’article du Code pénal',
      'Être formulée uniquement par écrit',
    ],
    answer:
        'Avoir un sens suffisamment clair même si l’infraction n’est pas expressément désignée',
    explanation:
        'Le cours : pas besoin d’infraction explicitement désignée si sens clair.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Tiers',
    question:
        'Une menace adressée à un tiers pour être rapportée à la victime :',
    options: [
      'Peut constituer l’infraction',
      'Ne peut jamais constituer l’infraction',
      'Constitue uniquement une contravention',
    ],
    answer: 'Peut constituer l’infraction',
    explanation: 'Le cours : menace directe ou indirecte (tiers / transmise).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Cantonade',
    question:
        '« Je tirerai sur quiconque touche ma voiture » (sans viser une personne) :',
    options: [
      'Ne constitue pas 222-17 (menace à la cantonade)',
      'Constitue 222-18 automatiquement',
      'Constitue toujours 222-16',
    ],
    answer: 'Ne constitue pas 222-17 (menace à la cantonade)',
    explanation: 'Le cours : la menace doit être dirigée contre une personne.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Tentative punissable',
    question:
        '222-17 réprime une menace portant sur un crime ou délit contre les personnes :',
    options: [
      'Dont la tentative est punissable',
      'Même si la tentative n’est jamais punissable',
      'Uniquement si l’auteur passe à l’acte',
    ],
    answer: 'Dont la tentative est punissable',
    explanation: 'Condition spécifique de 222-17 rappelée au cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Contravention R.623-1',
    question:
        'Les menaces de commettre des violences (tentative non réprimée) basculent vers :',
    options: [
      'R. 623-1 du Code pénal',
      '222-18 du Code pénal',
      '222-15-1 du Code pénal',
    ],
    answer: 'R. 623-1 du Code pénal',
    explanation: 'Le cours : exclusion de 222-17, renvoi vers R.623-1.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // MENACE AVEC CONDITION 222-18 — CAS PRATIQUES / PIÈGES
  // =========================================================
  QuizQuestion(
    category: 'Menace avec condition (222-18) — Cas pratique',
    question:
        '« Si tu ne me donnes pas ton téléphone, je te plante. » Cette situation relève :',
    options: [
      'De 222-18 (menace avec ordre de remplir une condition)',
      'De 222-17 uniquement',
      'D’une contravention R.623-2',
    ],
    answer: 'De 222-18 (menace avec ordre de remplir une condition)',
    explanation:
        'La condition est une injonction (faire/ne pas faire) pour éviter le mal annoncé.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Menace avec condition (222-18) — Moyen',
    question: 'Pour 222-18, la menace peut être extériorisée :',
    options: [
      'Par quelque moyen que ce soit (écrit, vidéo, verbal, informatique...)',
      'Uniquement par écrit',
      'Uniquement par appels réitérés',
    ],
    answer:
        'Par quelque moyen que ce soit (écrit, vidéo, verbal, informatique...)',
    explanation: 'Le cours : moyen indéterminé, pas besoin de réitération.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace avec condition (222-18) — Élément moral',
    question: 'L’intention exigée est :',
    options: [
      'La conscience de contraindre la victime par pression',
      'La volonté de tuer forcément',
      'L’imprudence',
    ],
    answer: 'La conscience de contraindre la victime par pression',
    explanation:
        'Le cours : dessein de peser méchamment sur la volonté d’autrui.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Menace avec condition (222-18) — Tentative',
    question: 'La tentative de 222-18 est :',
    options: ['Non punissable', 'Punissable', 'Un crime'],
    answer: 'Non punissable',
    explanation: 'Le cours : tentative non.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // EMBUSCADE 222-15-1 — GROS BLOC "CONCOURS"
  // =========================================================
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Conditions',
    question: 'L’embuscade est constituée lorsque l’auteur :',
    options: [
      'Attend une victime déterminée (ou proche) dans un lieu déterminé avec un but de violences avec arme, caractérisé par des faits matériels',
      'Insulte la victime en public',
      'Envoie un seul SMS agressif',
    ],
    answer:
        'Attend une victime déterminée (ou proche) dans un lieu déterminé avec un but de violences avec arme, caractérisé par des faits matériels',
    explanation:
        'Synthèse fidèle du cours : guet-apens + but + faits matériels.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Surprise',
    question: 'Le guet-apens vise notamment à provoquer :',
    options: [
      'Un effet de surprise empêchant la victime de se défendre',
      'Une médiation',
      'Une erreur de procédure',
    ],
    answer: 'Un effet de surprise empêchant la victime de se défendre',
    explanation:
        'Le cours : surprise qui interdit à la victime de préparer sa défense.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Menace avec arme',
    question:
        'L’embuscade vise aussi le fait de menacer avec une arme afin de provoquer :',
    options: [
      'Un choc émotionnel ou un trouble psychologique',
      'Une ITT automatique',
      'Une contravention',
    ],
    answer: 'Un choc émotionnel ou un trouble psychologique',
    explanation: 'Le cours : menace avec arme = choc/trouble psychologique.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Seuil du processus',
    question: 'Pourquoi la tentative d’embuscade n’est pas punissable ?',
    options: [
      'Parce que l’infraction se situe à un stade antérieur à la tentative',
      'Parce que c’est une contravention',
      'Parce que l’auteur doit blesser la victime',
    ],
    answer:
        'Parce que l’infraction se situe à un stade antérieur à la tentative',
    explanation: 'Le cours : consommation située avant la tentative.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Aggravation',
    question: 'La circonstance aggravante spécifique est :',
    options: [
      'La commission en réunion',
      'La commission de nuit',
      'L’usage d’un véhicule',
    ],
    answer: 'La commission en réunion',
    explanation: 'Le cours : 222-15-1 al.4.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // APPELS / MESSAGES / AGRESSIONS SONORES 222-16 — PIÈGES
  // =========================================================
  QuizQuestion(
    category: '222-16 — Violence psychologique',
    question:
        'Selon le cours, les appels malveillants et agressions sonores constituent :',
    options: [
      'Une forme de violences physiques ou psychologiques (222-14-3)',
      'Une atteinte involontaire',
      'Une destruction',
    ],
    answer: 'Une forme de violences physiques ou psychologiques (222-14-3)',
    explanation:
        'Le cours : rattachement au régime des violences (nature y compris psychologique).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: '222-16 — Réitération (minimum)',
    question: 'Le minimum d’appels pour caractériser la réitération est :',
    options: ['Deux appels successifs', 'Trois appels', 'Cinq appels'],
    answer: 'Deux appels successifs',
    explanation: 'Jurisprudence citée : 2 appels suffisent.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-16 — Destinataires',
    question:
        'Deux appels successifs effectués à des destinataires différents :',
    options: [
      'Peuvent suffire à caractériser la réitération',
      'Ne comptent jamais',
      'Sont une contravention',
    ],
    answer: 'Peuvent suffire à caractériser la réitération',
    explanation: 'Le cours : même à des destinataires différents.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: '222-16 — Bruit',
    question: 'Le terme « agression sonore » suppose :',
    options: [
      'Un bruit d’une certaine importance',
      'Un bruit imperceptible',
      'Un bruit obligatoirement nocturne',
    ],
    answer: 'Un bruit d’une certaine importance',
    explanation: 'Le cours : bruit d’une certaine importance.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-16 — Mobile',
    question:
        'Le texte de 222-16 prend en compte le mobile en exigeant que les agissements soient commis :',
    options: [
      'En vue de troubler la tranquillité d’autrui',
      'En vue de s’excuser',
      'Pour se défendre',
    ],
    answer: 'En vue de troubler la tranquillité d’autrui',
    explanation: 'Formule citée par le cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-16 — Infraction voisine',
    question:
        'Le cours indique que l’élément intentionnel permet de distinguer 222-16 de :',
    options: [
      'R. 623-2 (bruits ou tapages injurieux/nocturnes)',
      '222-18',
      '221-1',
    ],
    answer: 'R. 623-2 (bruits ou tapages injurieux/nocturnes)',
    explanation: 'Le cours fait le rapprochement explicite.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // TORTURES / BARBARIE — CAS PRATIQUES (3 niveaux)
  // =========================================================
  QuizQuestion(
    category: 'Tortures/Barbarie — Cas pratique',
    question:
        'Une personne inflige volontairement des souffrances aiguës pendant plusieurs heures en humiliant la victime. La qualification la plus cohérente est :',
    options: [
      'Tortures ou actes de barbarie (222-1)',
      'Appels malveillants (222-16)',
      'Menace (222-17)',
    ],
    answer: 'Tortures ou actes de barbarie (222-1)',
    explanation:
        'Le cours : souffrances aiguës + gravité exceptionnelle + atteinte dignité.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Tentative (cas)',
    question:
        'Ligoter une victime en vue de lui infliger des sévices, interrompu par l’arrivée de tiers, peut relever :',
    options: [
      'D’une tentative punissable',
      'D’une simple contravention',
      'D’une infraction non punissable',
    ],
    answer: 'D’une tentative punissable',
    explanation: 'Le cours donne précisément cet exemple pour la tentative.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Aggravation 222-6',
    question:
        'Lorsque les tortures/actes de barbarie entraînent la mort sans intention de la donner, on vise :',
    options: [
      'L’article 222-6 du Code pénal',
      'L’article 222-5 du Code pénal',
      'L’article 222-4 du Code pénal',
    ],
    answer: 'L’article 222-6 du Code pénal',
    explanation: 'Le cours : 222-6 = mort sans intention de la donner.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Aggravation 222-2',
    question:
        'Lorsque les tortures/actes de barbarie précèdent, accompagnent ou suivent un crime autre que meurtre ou viol, on vise :',
    options: [
      'L’article 222-2 du Code pénal',
      'L’article 222-6-4 du Code pénal',
      'L’article 222-3 du Code pénal',
    ],
    answer: 'L’article 222-2 du Code pénal',
    explanation:
        'Le cours : 222-2 = concours avec un crime autre que meurtre ou viol.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // VIOLENCES HABITUELLES — PIÈGES + CAS PRATIQUES
  // =========================================================
  QuizQuestion(
    category: 'Violences habituelles — Cas pratique',
    question:
        'Des violences répétées sur une période de deux mois peuvent caractériser :',
    options: [
      'Les violences habituelles',
      'Un fait unique non punissable',
      'Une menace simple',
    ],
    answer: 'Les violences habituelles',
    explanation:
        'Le cours cite une jurisprudence : période de deux mois suffisante.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences habituelles — Psychologique',
    question:
        'Le délit de violences peut être constitué sans atteinte physique par :',
    options: [
      'Tout acte de nature à impressionner vivement et causer un choc émotif',
      'Uniquement une blessure',
      'Uniquement une ITT',
    ],
    answer:
        'Tout acte de nature à impressionner vivement et causer un choc émotif',
    explanation:
        'Le cours cite la jurisprudence et 222-14-3 (violences psychologiques).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences habituelles — Différence',
    question:
        'La particularité des violences habituelles par rapport aux violences « simples » est :',
    options: [
      'La répétition des faits (habitude)',
      'L’obligation d’une arme',
      'L’obligation d’une menace écrite',
    ],
    answer: 'La répétition des faits (habitude)',
    explanation: 'Le cours : l’habitude suppose plusieurs reprises.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violences habituelles — Tentative',
    question: 'Pour les violences délictuelles, la tentative est en principe :',
    options: [
      'Non punissable car non visée par les textes',
      'Toujours punissable',
      'Toujours retenue si l’auteur a voulu',
    ],
    answer: 'Non punissable car non visée par les textes',
    explanation: 'Le cours le rappelle à plusieurs reprises.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 222-14-5 — CAS PRATIQUES "CONCOURS"
  // =========================================================
  QuizQuestion(
    category: '222-14-5 — Cas pratique',
    question:
        'Un agent de police municipale est agressé pendant une intervention. La qualification spéciale applicable est :',
    options: ['222-14-5 CP', '222-16 CP', '222-15-1 CP'],
    answer: '222-14-5 CP',
    explanation:
        'Le cours : PM fait partie des forces de sécurité intérieure visées.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: '222-14-5 — Cas pratique',
    question:
        'Un élu local est frappé en raison d’une décision prise dans l’exercice de son mandat. Condition de contexte :',
    options: [
      'Du fait de ses fonctions (actuelles ou passées)',
      'Uniquement à l’occasion des loisirs',
      'Sans lien nécessaire',
    ],
    answer: 'Du fait de ses fonctions (actuelles ou passées)',
    explanation: 'Le cours : exercice ou du fait des fonctions.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-14-5 — Cas pratique',
    question:
        'La victime est l’ascendant vivant au domicile d’un gendarme, agressé en raison des fonctions du gendarme. Cela entre dans :',
    options: [
      'Les proches visés par 222-14-5 II 1°',
      'Uniquement 222-17',
      'Uniquement 222-16',
    ],
    answer: 'Les proches visés par 222-14-5 II 1°',
    explanation:
        'Le cours : proches (conjoint, ascendants/descendants, cohabitants) en raison des fonctions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: '222-14-5 — Aggravation (cas)',
    question:
        'Violences sur FSI sans ITT, commises avec dissimulation du visage (circonstance 222-12). Peine attendue :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation:
        'ITT ≤ 8 (ou aucune) + 1 circonstance 8° à 15° → 7 ans / 100 000 €.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: '222-14-5 — Aggravation (cas)',
    question:
        'Violences sur FSI sans ITT, commises avec arme + préméditation (2 circonstances). Peine attendue :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation:
        'ITT ≤ 8 (ou aucune) + au moins 2 circonstances → second degré.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: '222-14-5 — Aggravation ITT > 8 (cas)',
    question:
        'Violences sur FSI avec ITT > 8 jours, commises avec usage d’une arme. Peine attendue :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende (période de sûreté)',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende (période de sûreté)',
    explanation:
        'ITT > 8 + circonstance 8° à 15° → 10 ans / 150 000 € + période de sûreté.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // MÉGA "VRAI/FAUX" (FORMAT QCM) — PIÈGES CONCOURS
  // =========================================================
  QuizQuestion(
    category: 'Concours — Vrai/Faux',
    question:
        'Affirmation : « Une menace verbale unique non matérialisée peut relever de 222-17. »',
    options: [
      'Faux',
      'Vrai',
      'Vrai uniquement si la victime est dépositaire de l’autorité publique',
    ],
    answer: 'Faux',
    explanation:
        '222-17 exige réitération OU matérialisation. Une menace unique verbale ne suffit pas.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Concours — Vrai/Faux',
    question:
        'Affirmation : « L’embuscade est constituée même si aucune violence n’a été commise. »',
    options: ['Vrai', 'Faux', 'Vrai uniquement s’il y a ITT'],
    answer: 'Vrai',
    explanation: 'Infraction préparée : violences non réalisées.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Concours — Vrai/Faux',
    question:
        'Affirmation : « Les agressions sonores exigent une réitération. »',
    options: ['Faux', 'Vrai', 'Vrai seulement le week-end'],
    answer: 'Faux',
    explanation:
        'Le cours : pas de condition de réitération pour les agressions sonores.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Concours — Vrai/Faux',
    question:
        'Affirmation : « La tentative de tortures et actes de barbarie est punissable. »',
    options: ['Vrai', 'Faux', 'Dépend de l’ITT'],
    answer: 'Vrai',
    explanation: 'Crime : tentative punissable (121-4 2°).',
    difficulty: 'Facile',
  ),
  // =======================
  // ENCORE — PACK XXL (3 niveaux) — À coller à la suite
  // =======================

  // =========================================================
  // MENACE 222-17 — PEINES / AGGRAVATIONS (CONCOURS)
  // =========================================================
  QuizQuestion(
    category: 'Menace (222-17) — Peine simple',
    question: 'La menace (222-17 al.1) réitérée ou matérialisée est punie de :',
    options: [
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '6 mois d’emprisonnement et 7 500 € d’amende',
    explanation: 'Cours : 222-17 al.1 (simple) = 6 mois + 7 500 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Menace de mort',
    question:
        'Lorsque la menace visée à 222-17 est une menace de mort (al.2), la peine est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Cours : 222-17 al.2 = 3 ans + 45 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Aggravation couple',
    question:
        'L’aggravation « couple/ex-couple » des menaces est traitée par :',
    options: [
      '222-18-3 du Code pénal',
      '222-16-1 du Code pénal',
      '222-15-1 du Code pénal',
    ],
    answer: '222-18-3 du Code pénal',
    explanation:
        'Cours : 222-18-3 prévoit deux degrés d’aggravation selon menace simple ou menace de mort.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Couple (1er degré)',
    question:
        'Menaces (222-17 al.1) commises par conjoint/concubin/PACS : peine (1er degré) ?',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Cours : 222-18-3 (1er degré) aggrave la menace simple à 3 ans / 45 000 €.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Menace (222-17) — Couple (2e degré)',
    question:
        'Menaces de mort (222-17 al.2) commises par conjoint/concubin/PACS : peine (2e degré) ?',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation:
        'Cours : 222-18-3 (2e degré) pour menaces de mort au sein du couple = 5 ans / 75 000 €.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // MENACE AVEC CONDITION 222-18 — PEINES / AGGRAVATIONS (CONCOURS)
  // =========================================================
  QuizQuestion(
    category: 'Menace avec condition (222-18) — Peine simple',
    question:
        'La menace avec ordre de remplir une condition (222-18 al.1) est punie de :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Cours : 222-18 al.1 = 3 ans + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Menace avec condition (222-18) — Menace de mort',
    question:
        'La menace avec condition lorsqu’il s’agit d’une menace de mort (222-18 al.2) est punie de :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Cours : 222-18 al.2 = 5 ans + 75 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace (222-18) — Couple (1er degré)',
    question:
        'Menace avec condition (222-18 al.1) commise par conjoint/concubin/PACS (aggravation 222-18-3) :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Cours : 222-18-3 aggrave 222-18 al.1 à 7 ans / 100 000 €.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Menace (222-18) — Couple (2e degré)',
    question:
        'Menace de mort avec condition (222-18 al.2) commise par conjoint/concubin/PACS (222-18-3) :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation:
        'Cours : 222-18-3 (2e degré) pour menaces de mort au sein du couple = 7 ans / 100 000 €.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 222-16 — APPELS / MESSAGES / AGRESSIONS SONORES — PEINES
  // =========================================================
  QuizQuestion(
    category: '222-16 — Peine simple',
    question:
        'Les appels malveillants réitérés / messages malveillants réitérés / agressions sonores (222-16) sont punis de :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation: 'Cours : 222-16 (simple) = 1 an + 15 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: '222-16 — Aggravation couple',
    question:
        'Lorsque 222-16 est commis par conjoint/concubin/PACS (al.2), la peine est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Cours : 222-16 al.2 = 3 ans + 45 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-16 — Tentative',
    question: 'La tentative de 222-16 est :',
    options: ['Non punissable', 'Punissable', 'Toujours criminelle'],
    answer: 'Non punissable',
    explanation: 'Cours : tentative non.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // 222-15-1 — EMBUSCADE — PEINES + CAS (CONCOURS)
  // =========================================================
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Peine simple',
    question: 'L’embuscade (222-15-1) est punie (simple) de :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Cours : 222-15-1 (simple) = 5 ans / 75 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Peine aggravée',
    question: 'L’embuscade aggravée (en réunion, 222-15-1 al.4) est punie de :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Cours : réunion = 7 ans / 100 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Embuscade (222-15-1) — Cas pratique',
    question:
        'Un individu attend un policier dans un lieu déterminé avec un couteau, repéré avant l’attaque. Qualification :',
    options: [
      'Embuscade (222-15-1)',
      'Menace (222-17)',
      'Appels malveillants (222-16)',
    ],
    answer: 'Embuscade (222-15-1)',
    explanation:
        'Attente + lieu + victime visée + projet de violences avec arme + faits matériels.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 222-1 à 222-6 — TORTURES/BARBARIE — PEINES (CONCOURS)
  // =========================================================
  QuizQuestion(
    category: 'Tortures/Barbarie — Peine simple',
    question: 'Les tortures ou actes de barbarie (222-1) sont punis de :',
    options: [
      '15 ans de réclusion',
      '20 ans de réclusion',
      '30 ans de réclusion',
    ],
    answer: '15 ans de réclusion',
    explanation:
        'Cours : 222-1 (simple) = 15 ans de réclusion (période de sûreté).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — 1er degré (222-3)',
    question:
        'Les tortures/actes de barbarie aggravés par une circonstance du 1er degré (222-3) :',
    options: [
      '20 ans de réclusion',
      '15 ans de réclusion',
      '30 ans de réclusion',
    ],
    answer: '20 ans de réclusion',
    explanation: 'Cours : 222-3 = 20 ans de réclusion (période de sûreté).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — 222-5 (mutilation/infirmité)',
    question:
        'Lorsque les tortures/actes de barbarie entraînent une mutilation ou une infirmité permanente (222-5) :',
    options: [
      '30 ans de réclusion',
      '20 ans de réclusion',
      'Réclusion à perpétuité',
    ],
    answer: '30 ans de réclusion',
    explanation: 'Cours : 222-5 = 30 ans de réclusion (période de sûreté).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — 222-6 (mort sans intention)',
    question:
        'Lorsque les tortures/actes de barbarie entraînent la mort sans intention de la donner (222-6) :',
    options: [
      'Réclusion à perpétuité',
      '30 ans de réclusion',
      '20 ans de réclusion',
    ],
    answer: 'Réclusion à perpétuité',
    explanation: 'Cours : 222-6 = perpétuité (période de sûreté).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Provocation',
    question:
        'Le fait de faire des offres/promesses/dons pour provoquer des tortures et actes de barbarie (si non commis ni tenté) relève :',
    options: [
      'D’une infraction distincte (222-6-4)',
      'De la complicité automatiquement',
      'D’une contravention',
    ],
    answer: 'D’une infraction distincte (222-6-4)',
    explanation:
        'Cours : provocation = infraction distincte (si non suivi d’effet).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 222-14 (VIOLENCES HABITUELLES) — BARÈME / RÉSULTATS
  // =========================================================
  QuizQuestion(
    category: 'Violences habituelles (222-14) — ITT 0-8',
    question:
        'Les violences habituelles (mineur/vulnérable ou couple/ex) ayant entraîné une ITT de 0 à 8 jours :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '20 ans de réclusion',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation:
        'Cours : barème violences habituelles ITT 0-8 = 5 ans / 75 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violences habituelles (222-14) — ITT > 8',
    question:
        'Les violences habituelles ayant entraîné une ITT > 8 jours sont punies de :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '15 ans de réclusion',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation: 'Cours : ITT > 8 = 10 ans / 150 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violences habituelles (222-14) — Mutilation/infirmité',
    question:
        'Les violences habituelles ayant entraîné une mutilation ou infirmité permanente :',
    options: [
      '20 ans de réclusion',
      '30 ans de réclusion',
      '10 ans d’emprisonnement',
    ],
    answer: '20 ans de réclusion',
    explanation:
        'Cours : mutilation/infirmité permanente = 20 ans de réclusion (période de sûreté).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violences habituelles (222-14) — Mort',
    question:
        'Les violences habituelles ayant entraîné la mort sans intention de la donner :',
    options: [
      '30 ans de réclusion',
      '20 ans de réclusion',
      '15 ans de réclusion',
    ],
    answer: '30 ans de réclusion',
    explanation:
        'Cours : mort sans intention = 30 ans de réclusion (période de sûreté).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 222-14-1 (ARME + BO / GUET-APENS sur DAP, SP, TRANSPORT) — BARÈME
  // =========================================================
  QuizQuestion(
    category: '222-14-1 — ITT 0-8',
    question:
        'Violences avec arme sur dépositaire/SP/transport, commises en bande organisée OU avec guet-apens, ITT 0-8 :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation:
        'Cours : 222-14-1 4° = 10 ans / 150 000 € (+ période de sûreté).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-14-1 — ITT > 8',
    question: 'Violences 222-14-1 avec ITT > 8 jours :',
    options: [
      '15 ans de réclusion',
      '10 ans d’emprisonnement',
      '20 ans de réclusion',
    ],
    answer: '15 ans de réclusion',
    explanation:
        'Cours : 222-14-1 3° = 15 ans de réclusion (+ période de sûreté).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-14-1 — Infirmité',
    question:
        'Violences 222-14-1 ayant entraîné une mutilation/infirmité permanente :',
    options: [
      '20 ans de réclusion',
      '30 ans de réclusion',
      '15 ans de réclusion',
    ],
    answer: '20 ans de réclusion',
    explanation:
        'Cours : 222-14-1 2° = 20 ans de réclusion (+ période de sûreté).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: '222-14-1 — Mort',
    question:
        'Violences 222-14-1 ayant entraîné la mort sans intention de la donner :',
    options: [
      '30 ans de réclusion',
      '20 ans de réclusion',
      'Réclusion à perpétuité',
    ],
    answer: '30 ans de réclusion',
    explanation:
        'Cours : 222-14-1 1° = 30 ans de réclusion (+ période de sûreté).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // MINI-SÉRIES "MOTS-CLÉS" — ULTRA EFFICACE CONCOURS
  // =========================================================
  QuizQuestion(
    category: 'Mots-clés — 222-17',
    question: 'Le duo clé de l’élément matériel de 222-17 est :',
    options: [
      'Réitération OU matérialisation',
      'Condition OU réunion',
      'Arme OU ITT',
    ],
    answer: 'Réitération OU matérialisation',
    explanation: 'Cours : c’est le pivot de 222-17.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mots-clés — 222-18',
    question: 'Le mot-clé de 222-18 est :',
    options: [
      'Condition (ordre de faire/ne pas faire)',
      'Réitération',
      'Bande organisée',
    ],
    answer: 'Condition (ordre de faire/ne pas faire)',
    explanation:
        'Cours : contrainte par condition = atteinte à la liberté d’agir.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Mots-clés — 222-15-1',
    question: 'Le mot-clé de 222-15-1 est :',
    options: [
      'Attendre (guet-apens) + projet de violences avec arme',
      'Réitérer + écrire',
      'Tapage nocturne',
    ],
    answer: 'Attendre (guet-apens) + projet de violences avec arme',
    explanation:
        'Cours : préparation des violences avec arme sur victime qualifiée.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // SÉRIE "QCM MÉLANGÉS" — POUR T’ENTRAÎNER COMME AU QCM
  // =========================================================
  QuizQuestion(
    category: 'Mix concours — Qualification',
    question:
        '« Si tu ne me réponds pas, je te tue » envoyé une fois par SMS :',
    options: [
      '222-18 (condition) + menace de mort',
      '222-17 uniquement',
      'R.623-2',
    ],
    answer: '222-18 (condition) + menace de mort',
    explanation:
        'Condition (« si tu ne… ») + moyen indifférent + menace de mort.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Mix concours — Qualification',
    question:
        'Attendre un agent de la force publique dans un lieu déterminé, avec un bâton, dans l’intention de le menacer avec l’arme :',
    options: [
      'Embuscade (222-15-1)',
      'Appels malveillants (222-16)',
      'Menace 222-17 (sans plus)',
    ],
    answer: 'Embuscade (222-15-1)',
    explanation:
        'Attente + lieu déterminé + but violences avec usage/menace d’une arme.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Mix concours — Qualification',
    question:
        'Deux appels successifs (sans paroles) à la victime, uniquement pour la réveiller et la gêner :',
    options: ['222-16 (appels malveillants réitérés)', '222-17', 'R.623-2'],
    answer: '222-16 (appels malveillants réitérés)',
    explanation:
        'Réitération + malveillance (nuire / troubler). Le contenu n’est pas seul déterminant.',
    difficulty: 'Difficile',
  ),
  // =======================
  // ENCORE — SÉRIE MASSIVE (Cas pratiques + QCM pièges) — 3 niveaux
  // =======================

  // =========================================================
  // 222-17 — MENACE (SANS CONDITION) — CAS PRATIQUES
  // =========================================================
  QuizQuestion(
    category: 'Menace 222-17 — Cas pratique',
    question:
        'Un individu dit à son voisin : « Je vais te tuer », une seule fois, oralement, sans écrit, sans image, sans objet. Qualification ?',
    options: [
      'Pas 222-17 : absence de réitération ou matérialisation',
      '222-17 al.1 constitué',
      '222-18 constitué',
    ],
    answer: 'Pas 222-17 : absence de réitération ou matérialisation',
    explanation:
        'Cours : 222-17 exige une menace réitérée OU matérialisée (écrit/image/objet).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace 222-17 — Cas pratique',
    question:
        'Un individu envoie une lettre : « Je vais te casser la mâchoire » (une seule lettre). Qualification la plus adaptée ?',
    options: [
      '222-17 (matérialisation par écrit) si la tentative du délit menacé est punissable',
      '222-16',
      'R.623-2 (tapage)',
    ],
    answer:
        '222-17 (matérialisation par écrit) si la tentative du délit menacé est punissable',
    explanation:
        'Cours : 222-17 = réitérée OU matérialisée. Attention : doit viser crime/délit contre les personnes dont la tentative est punissable.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Menace 222-17 — Menace de violence',
    question:
        'Le texte 222-17 exclut les menaces de commettre des violences (dont la tentative n’est pas réprimée). Dans ce cas, on vise :',
    options: ['La contravention R.623-1 du Code pénal', '222-16', '222-15-1'],
    answer: 'La contravention R.623-1 du Code pénal',
    explanation:
        'Cours : menaces de violences (tentative non réprimée) → R.623-1.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace 222-17 — Réitération',
    question: 'La menace doit être réitérée à l’égard :',
    options: [
      'De la même personne',
      'De n’importe quelle personne',
      'D’au moins deux personnes différentes',
    ],
    answer: 'De la même personne',
    explanation:
        'Cours : menaces punissables si réitérées envers la même personne.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Menace 222-17 — Matérialisation',
    question: 'La matérialisation d’une menace peut se faire par :',
    options: [
      'Écrit, image ou tout autre objet',
      'Uniquement un SMS',
      'Uniquement une lettre recommandée',
    ],
    answer: 'Écrit, image ou tout autre objet',
    explanation:
        'Cours : écrit / image / objet (ex : figurine, cercueil miniature…).',
    difficulty: 'Facile',
  ),

  // =========================================================
  // 222-18 — MENACE AVEC CONDITION — CAS PRATIQUES
  // =========================================================
  QuizQuestion(
    category: 'Menace 222-18 — Cas pratique',
    question:
        '« Donne-moi 500 € sinon je te tue » (oral, une seule fois). Qualification ?',
    options: [
      '222-18 (condition) + menace de mort',
      '222-17 (réitération) uniquement',
      '222-16',
    ],
    answer: '222-18 (condition) + menace de mort',
    explanation:
        'Cours : 222-18 = menace avec ordre de remplir une condition ; moyen indifférent ; menace de mort = al.2.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Menace 222-18 — Condition',
    question: 'La condition au sens de 222-18 peut être :',
    options: [
      'Une action OU une abstention (faire / ne pas faire)',
      'Uniquement une action',
      'Uniquement un paiement d’argent',
    ],
    answer: 'Une action OU une abstention (faire / ne pas faire)',
    explanation:
        'Cours : condition = injonction, obligation de faire ou de ne pas faire.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Menace 222-18 — Moyen',
    question: 'Pour 222-18 (menace avec condition), la menace :',
    options: [
      'Peut être extériorisée par quelque moyen que ce soit',
      'Doit être matérialisée',
      'Doit être réitérée',
    ],
    answer: 'Peut être extériorisée par quelque moyen que ce soit',
    explanation: 'Cours : moyen indéterminé, pas d’exigence de réitération.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // 222-16 — APPELS / MESSAGES MALVEILLANTS — CAS PRATIQUES
  // =========================================================
  QuizQuestion(
    category: '222-16 — Réitération',
    question:
        'Le minimum pour caractériser la réitération au sens de 222-16 est :',
    options: ['Deux appels successifs', 'Cinq appels', 'Dix appels'],
    answer: 'Deux appels successifs',
    explanation:
        'Cours : deux appels successifs suffisent à caractériser la réitération.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-16 — Messages',
    question: 'Les messages visés par 222-16 peuvent être :',
    options: [
      'SMS, MMS, courriels (communications électroniques)',
      'Uniquement des lettres',
      'Uniquement des messages vocaux',
    ],
    answer: 'SMS, MMS, courriels (communications électroniques)',
    explanation:
        'Cours : messages malveillants réitérés émis par voie électronique.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: '222-16 — Agressions sonores',
    question: 'Pour les agressions sonores (222-16), la réitération :',
    options: [
      'N’est pas exigée',
      'Est exigée au minimum 2 fois',
      'Est exigée au minimum 3 fois',
    ],
    answer: 'N’est pas exigée',
    explanation:
        'Cours : pas de condition de réitération pour les agressions sonores.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: '222-16 — Élément moral',
    question: 'L’élément intentionnel des agressions sonores (222-16) est :',
    options: [
      'La volonté de troubler la tranquillité d’autrui',
      'L’intention de tuer',
      'La préméditation',
    ],
    answer: 'La volonté de troubler la tranquillité d’autrui',
    explanation: 'Cours : « en vue de troubler la tranquillité d’autrui ».',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 222-15-1 — EMBUSCADE — CAS PRATIQUES PIÈGES
  // =========================================================
  QuizQuestion(
    category: 'Embuscade 222-15-1 — Définition',
    question: 'L’embuscade consiste principalement à :',
    options: [
      'Attendre un certain temps et dans un lieu déterminé une victime qualifiée',
      'Envoyer des messages malveillants',
      'Proférer une menace par écrit',
    ],
    answer:
        'Attendre un certain temps et dans un lieu déterminé une victime qualifiée',
    explanation:
        'Cours : « attendre un certain temps et dans un lieu déterminé » (guet-apens).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Embuscade 222-15-1 — Objet',
    question: 'L’embuscade vise une préparation en vue de :',
    options: [
      'Violences avec usage ou menace d’une arme',
      'Destructions volontaires',
      'Vol simple',
    ],
    answer: 'Violences avec usage ou menace d’une arme',
    explanation:
        'Cours : but = violences avec usage/menace d’une arme (arme par nature ou destination).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Embuscade 222-15-1 — Point clé',
    question: 'L’embuscade est constituée :',
    options: [
      'Même si les violences ne sont pas réalisées',
      'Seulement si un coup est porté',
      'Seulement si la victime est blessée',
    ],
    answer: 'Même si les violences ne sont pas réalisées',
    explanation:
        'Cours : infraction préparée, intervention possible avant consommation des violences.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Embuscade 222-15-1 — Tentative',
    question: 'La tentative du délit d’embuscade est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable uniquement en réunion',
    ],
    answer: 'Non punissable',
    explanation:
        'Cours : tentative non (consommation située avant le stade de la tentative).',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // TORTURES / BARBARIE — DÉFINITIONS + CAS PRATIQUES
  // =========================================================
  QuizQuestion(
    category: 'Tortures/Barbarie — Définition jurisprudentielle',
    question:
        'Les tortures ou actes de barbarie se caractérisent notamment par :',
    options: [
      'Des actes d’une gravité exceptionnelle dépassant de simples violences et niant la dignité',
      'Un simple coup sans douleur',
      'Une contravention de tapage',
    ],
    answer:
        'Des actes d’une gravité exceptionnelle dépassant de simples violences et niant la dignité',
    explanation:
        'Cours : gravité exceptionnelle + volonté de nier la dignité de la personne humaine.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Élément moral',
    question:
        'L’élément moral principal des tortures et actes de barbarie est :',
    options: [
      'La volonté de causer une souffrance exceptionnellement aiguë / nier la dignité',
      'La négligence',
      'L’imprudence',
    ],
    answer:
        'La volonté de causer une souffrance exceptionnellement aiguë / nier la dignité',
    explanation:
        'Cours : volonté de souffrance exceptionnelle (physique ou morale) / atteinte à la dignité.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Aggravation 222-4',
    question:
        'Parmi les cas suivants, lequel correspond à une aggravation de 2e degré (222-4) ?',
    options: ['En bande organisée', 'Menace par écrit', 'Tapage injurieux'],
    answer: 'En bande organisée',
    explanation: 'Cours : 222-4 (2e degré) vise notamment la bande organisée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Tentative',
    question: 'La tentative de tortures et actes de barbarie est :',
    options: [
      'Punissable',
      'Non punissable',
      'Punissable seulement si la victime a une ITT',
    ],
    answer: 'Punissable',
    explanation: 'Cours : tentative de crime toujours punissable (121-4 2°).',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // VIOLENCES HABITUELLES 222-14 — PIÈGES "HABITUDE"
  // =========================================================
  QuizQuestion(
    category: 'Violences habituelles — Notion',
    question: 'La notion d’habitude (222-14) implique :',
    options: [
      'Des violences à plusieurs reprises',
      'Un acte unique très violent',
      'Une menace matérialisée',
    ],
    answer: 'Des violences à plusieurs reprises',
    explanation: 'Cours : l’habitude suppose la répétition.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violences habituelles — Couple/ex',
    question:
        'Les violences habituelles commises par un ancien conjoint/concubin/PACS sont visées via :',
    options: [
      'Le renvoi à 132-80 al.2 (pris en compte par 222-14 al.6)',
      'Uniquement 222-16',
      'Uniquement 222-17',
    ],
    answer: 'Le renvoi à 132-80 al.2 (pris en compte par 222-14 al.6)',
    explanation: 'Cours : 222-14 al.6 vise aussi l’« ex » via 132-80 al.2.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 222-14-5 — VIOLENCES SUR FSI / ÉLUS — BARÈME + CIRCONSTANCES
  // =========================================================
  QuizQuestion(
    category: '222-14-5 — Texte',
    question:
        'Les violences sur forces de sécurité intérieure / élus locaux relèvent de :',
    options: [
      'L’article 222-14-5 du Code pénal',
      'L’article 222-14-1 du Code pénal',
      'L’article 222-17 du Code pénal',
    ],
    answer: 'L’article 222-14-5 du Code pénal',
    explanation: 'Cours : 222-14-5 définit et réprime ces violences.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: '222-14-5 — Peine de base (≤8j)',
    question: 'Violences 222-14-5 sans ITT ou ITT ≤ 8 jours : peine de base ?',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Cours : 222-14-5 /2° (base) = 5 ans / 75 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-14-5 — 1 circonstance (≤8j)',
    question:
        'Violences 222-14-5 (≤8j) + une circonstance 8° à 15° de 222-12 : peine ?',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation:
        'Cours : 222-14-5 al.4 (≤8j) + 1 circonstance = 7 ans / 100 000 €.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: '222-14-5 — 2 circonstances (≤8j)',
    question:
        'Violences 222-14-5 (≤8j) + deux circonstances 8° à 15° de 222-12 : peine ?',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation:
        'Cours : 222-14-5 al.5 (≤8j) + 2 circonstances = 10 ans / 150 000 € (+ période de sûreté).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: '222-14-5 — ITT > 8',
    question: 'Violences 222-14-5 avec ITT > 8 jours : peine de base ?',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Cours : 222-14-5 I/1° = 7 ans / 100 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-14-5 — ITT > 8 + circonstance',
    question:
        'Violences 222-14-5 avec ITT > 8 jours + une circonstance 8° à 15° de 222-12 :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation:
        'Cours : 222-14-5 al.4 (ITT > 8) + 1 circonstance = 10 ans / 150 000 € (+ période de sûreté).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // SÉRIE "VRAI/FAUX" — ULTRA CONCOURS (3 niveaux)
  // =========================================================
  QuizQuestion(
    category: 'Vrai/Faux — 222-17',
    question:
        'Vrai ou faux : une menace verbale unique peut constituer 222-17 si elle fait peur.',
    options: ['Vrai', 'Faux', 'Ça dépend de la victime'],
    answer: 'Faux',
    explanation:
        'Cours : 222-17 exige réitération OU matérialisation, pas seulement la peur.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Vrai/Faux — 222-18',
    question:
        'Vrai ou faux : pour 222-18, la menace doit être matérialisée par écrit.',
    options: ['Vrai', 'Faux', 'Uniquement si menace de mort'],
    answer: 'Faux',
    explanation: 'Cours : 222-18 = « par quelque moyen que ce soit ».',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Vrai/Faux — 222-16',
    question:
        'Vrai ou faux : le caractère malveillant se déduit uniquement du contenu des appels/messages.',
    options: ['Vrai', 'Faux', 'Vrai seulement pour les SMS'],
    answer: 'Faux',
    explanation:
        'Cours : la seule multiplication des appels peut suffire à caractériser la malveillance.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Vrai/Faux — Embuscade',
    question:
        'Vrai ou faux : l’embuscade suppose que les violences aient été consommées.',
    options: ['Vrai', 'Faux', 'Vrai seulement si arme'],
    answer: 'Faux',
    explanation:
        'Cours : infraction préparée, indépendante de la réalisation des violences.',
    difficulty: 'Moyenne',
  ),
  // =======================
  // ENCORE — BLOC 3 (MASSIF) : 50 Q "PEINES & BARÈMES" + 30 CAS PIÈGES
  // 3 niveaux (Facile/Moyenne/Difficile)
  // =======================

  // =========================================================
  // MENACES 222-17 — PEINES (BARÈME) + AGGRAVATIONS
  // =========================================================
  QuizQuestion(
    category: '222-17 — Répression — Base',
    question: 'La peine encourue pour la menace (222-17 al.1) est :',
    options: [
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '6 mois d’emprisonnement et 7 500 € d’amende',
    explanation: 'Cours : 222-17 al.1 = 6 mois + 7 500 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: '222-17 — Répression — Menace de mort',
    question: 'La peine encourue pour la menace de mort (222-17 al.2) est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Cours : 222-17 al.2 (menace de mort) = 3 ans + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: '222-18-3 — Aggravation — Premier degré',
    question: '222-18-3 (1er degré) aggrave :',
    options: [
      '222-17 al.1 et 222-18 al.1 si commis par conjoint/concubin/PACS',
      'Uniquement 222-16',
      'Uniquement 222-15-1',
    ],
    answer: '222-17 al.1 et 222-18 al.1 si commis par conjoint/concubin/PACS',
    explanation:
        'Cours : 222-18-3 prévoit deux degrés (conjoint/concubin/PACS) et s’applique aux menaces.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-18-3 — Répression — Menaces (base)',
    question:
        'Quand les menaces (sans mort) sont aggravées par 222-18-3 : peine ?',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Cours : 222-18-3 aggrave l’infraction prévue à 222-17 al.1 → 3 ans / 45 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-18-3 — Répression — Menaces de mort',
    question: 'Quand les menaces de mort sont aggravées par 222-18-3 : peine ?',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation:
        'Cours : 222-18-3 aggrave l’infraction prévue à 222-17 al.2 → 5 ans / 75 000 €.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // MENACES 222-18 — PEINES + AGGRAVATIONS
  // =========================================================
  QuizQuestion(
    category: '222-18 — Répression — Base',
    question:
        'La peine encourue pour la menace avec condition (222-18 al.1) est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Cours : 222-18 al.1 = 3 ans + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: '222-18 — Répression — Menace de mort',
    question:
        'La peine encourue pour 222-18 al.2 (menace de mort avec condition) est :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Cours : 222-18 al.2 = 5 ans + 75 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: '222-18-3 — Répression — Condition (base)',
    question: 'Quand 222-18 (sans mort) est aggravé par 222-18-3 : peine ?',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation:
        'Cours : 222-18-3 aggrave l’infraction prévue à 222-18 al.1 → 7 ans / 100 000 €.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: '222-18-3 — Répression — Condition + mort',
    question:
        'Quand 222-18 (menace de mort) est aggravé par 222-18-3 : peine ?',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation:
        'Cours : 222-18-3 aggrave l’infraction prévue à 222-18 al.2 → 10 ans / 150 000 €.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 222-16 — APPELS / MESSAGES / AGRESSIONS SONORES — PEINES
  // =========================================================
  QuizQuestion(
    category: '222-16 — Répression — Base',
    question: 'La peine encourue pour 222-16 (base) est :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '6 mois d’emprisonnement et 7 500 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation: 'Cours : 222-16 (simple) = 1 an / 15 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: '222-16 — Répression — Conjoint/concubin/PACS',
    question: 'La peine encourue pour 222-16 al.2 (aggravé) est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Cours : 222-16 al.2 = 3 ans / 45 000 €.',
    difficulty: 'Facile',
  ),
  // =======================
  // ENCORE — BLOC 4 (MÉGA MASSIF) : 120 QUESTIONS
  // - 60 QCM "repérage rapide" (Facile/Moyenne/Difficile)
  // - 60 Cas pratiques concours (énoncés longs + pièges)
  // Thèmes : 222-17 / 222-18 / 222-18-3 / 222-16 / 222-15-1 / 222-1 à 222-6 / 222-14 / 222-14-5
  // =======================

  // =========================================================
  // A) 60 QCM — REPÉRAGE RAPIDE (BARÈMES + CONDITIONS + DÉFINITIONS)
  // =========================================================

  // ---------- 222-17 : CONDITIONS DE CONSTITUTION ----------
  QuizQuestion(
    category: '222-17 — Condition de punissabilité',
    question: 'La menace 222-17 est punissable lorsqu’elle est :',
    options: [
      'Réitérée OU matérialisée (écrit/image/objet)',
      'Toujours punissable dès qu’elle est proférée',
      'Punissable seulement si la victime porte plainte',
    ],
    answer: 'Réitérée OU matérialisée (écrit/image/objet)',
    explanation: 'Cours : 222-17 exige la réitération OU la matérialisation.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: '222-17 — Domaine',
    question: '222-17 vise la menace de :',
    options: [
      'Crime ou délit contre les personnes dont la tentative est punissable',
      'Toute menace de violence même simple',
      'Toute menace contre les biens',
    ],
    answer:
        'Crime ou délit contre les personnes dont la tentative est punissable',
    explanation:
        'Cours : 222-17 exclut les menaces de violences (tentative non réprimée) → R.623-1.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-17 — Menace à la cantonade',
    question: 'Une menace « à la cantonade » (non dirigée) :',
    options: [
      'Ne caractérise pas 222-17',
      'Caractérise toujours 222-17',
      'Relève automatiquement de 222-18',
    ],
    answer: 'Ne caractérise pas 222-17',
    explanation: 'Cours : la menace doit être dirigée contre une personne.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-17 — Réitération',
    question: 'La réitération suppose :',
    options: [
      'Au moins deux menaces',
      'Au moins trois menaces',
      'Un délai minimal d’une heure entre deux menaces',
    ],
    answer: 'Au moins deux menaces',
    explanation: 'Cours : menace répétée au moins deux fois.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: '222-17 — Réitération (même personne)',
    question: 'Pour être punissables, les menaces réitérées doivent viser :',
    options: [
      'La même personne',
      'Deux personnes différentes',
      'N’importe qui dans un groupe',
    ],
    answer: 'La même personne',
    explanation: 'Cours : réitération à l’égard de la même personne.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-17 — Matérialisation',
    question: 'La matérialisation peut se faire par :',
    options: [
      'Écrit, image ou tout autre objet',
      'Seulement par une lettre manuscrite',
      'Uniquement par SMS',
    ],
    answer: 'Écrit, image ou tout autre objet',
    explanation: 'Cours : écrit / image / objet.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: '222-17 — Gestuelle seule',
    question: 'Une gestuelle seule (mimer une arme sans support) :',
    options: [
      'Ne suffit pas à matérialiser la menace',
      'Suffit toujours',
      'Suffit uniquement si la victime a peur',
    ],
    answer: 'Ne suffit pas à matérialiser la menace',
    explanation: 'Cours : gestuelle seule exclue de la matérialisation.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: '222-17 — Élément moral',
    question: 'L’élément moral de 222-17 est :',
    options: [
      'Conscience d’exercer une pression / intention d’impressionner',
      'Intention obligatoire de passer à l’acte',
      'Absence totale d’intention requise',
    ],
    answer: 'Conscience d’exercer une pression / intention d’impressionner',
    explanation:
        'Cours : pas besoin de vouloir exécuter, mais volonté d’impressionner/troubler.',
    difficulty: 'Moyenne',
  ),

  // ---------- 222-18 : CONDITION ----------
  QuizQuestion(
    category: '222-18 — Définition',
    question: '222-18 vise la menace de crime ou délit contre les personnes :',
    options: [
      'Avec ordre de remplir une condition',
      'Réitérée ou matérialisée',
      'Uniquement par écrit',
    ],
    answer: 'Avec ordre de remplir une condition',
    explanation: 'Cours : 222-18 = menace avec condition.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: '222-18 — Domaine',
    question: 'Contrairement à 222-17, 222-18 vise :',
    options: [
      'Tout crime ou tout délit contre les personnes (pas besoin tentative punissable)',
      'Uniquement les crimes',
      'Uniquement les menaces de violences simples',
    ],
    answer:
        'Tout crime ou tout délit contre les personnes (pas besoin tentative punissable)',
    explanation:
        'Cours : 222-18 couvre tout délit contre les personnes, sans condition “tentative punissable”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: '222-18 — Moyen',
    question: 'Le moyen de la menace dans 222-18 est :',
    options: [
      'Indifférent (“par quelque moyen que ce soit”)',
      'Obligatoirement écrit',
      'Obligatoirement verbal',
    ],
    answer: 'Indifférent (“par quelque moyen que ce soit”)',
    explanation: 'Cours : moyen indéterminé, pas besoin de réitération.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-18 — Condition',
    question: 'La condition peut être :',
    options: [
      'Une action OU une abstention',
      'Uniquement une action',
      'Uniquement une abstention',
    ],
    answer: 'Une action OU une abstention',
    explanation: 'Cours : obligation de faire ou de ne pas faire.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: '222-18 — Élément moral',
    question: 'L’élément moral de 222-18 correspond à :',
    options: [
      'Conscience de contraindre la victime à faire/ne pas faire un acte déterminé',
      'Intention obligatoire de tuer',
      'Simple imprudence',
    ],
    answer:
        'Conscience de contraindre la victime à faire/ne pas faire un acte déterminé',
    explanation: 'Cours : pression morale pour contraindre.',
    difficulty: 'Moyenne',
  ),

  // ---------- 222-16 : APPELS / MESSAGES / AGRESSIONS SONORES ----------
  QuizQuestion(
    category: '222-16 — Champ',
    question: '222-16 réprime notamment :',
    options: [
      'Appels téléphoniques malveillants réitérés',
      'Menaces de mort avec condition',
      'Vol avec violence',
    ],
    answer: 'Appels téléphoniques malveillants réitérés',
    explanation:
        'Cours : appels malveillants réitérés, messages malveillants réitérés, agressions sonores.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: '222-16 — Réitération (minimum)',
    question: 'Pour caractériser la réitération (222-16), il faut au moins :',
    options: ['2 appels successifs', '5 appels', '10 appels'],
    answer: '2 appels successifs',
    explanation: 'Cours : 2 appels successifs suffisent.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-16 — Agressions sonores',
    question: 'Les agressions sonores (222-16) exigent :',
    options: [
      'La volonté de troubler la tranquillité d’autrui',
      'La réitération obligatoire',
      'Une menace de mort',
    ],
    answer: 'La volonté de troubler la tranquillité d’autrui',
    explanation:
        'Cours : intention “en vue de troubler”, pas de réitération exigée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-16 — Aggravation',
    question: '222-16 est aggravé lorsque commis par :',
    options: [
      'Conjoint/concubin/PACS',
      'Un mineur de 15 ans',
      'Un fonctionnaire',
    ],
    answer: 'Conjoint/concubin/PACS',
    explanation: 'Cours : 222-16 al.2.',
    difficulty: 'Facile',
  ),

  // ---------- 222-15-1 : EMBUSCADE ----------
  QuizQuestion(
    category: '222-15-1 — Définition',
    question: 'L’embuscade (222-15-1) est :',
    options: [
      'Attendre une victime visée dans un lieu/temps déterminé pour violences avec usage/menace d’arme',
      'Menacer par écrit une personne',
      'Appeler de façon répétée une victime',
    ],
    answer:
        'Attendre une victime visée dans un lieu/temps déterminé pour violences avec usage/menace d’arme',
    explanation:
        'Cours : guet-apens + but de violences avec arme (usage ou menace).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-15-1 — Stade',
    question: '222-15-1 permet d’intervenir :',
    options: [
      'Avant la consommation des violences',
      'Uniquement après violences réalisées',
      'Uniquement après ITT > 8 jours',
    ],
    answer: 'Avant la consommation des violences',
    explanation: 'Cours : infraction préparée, violences non réalisées.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-15-1 — Tentative',
    question: 'La tentative du délit d’embuscade est :',
    options: [
      'Non punissable',
      'Toujours punissable',
      'Punissable uniquement en réunion',
    ],
    answer: 'Non punissable',
    explanation: 'Cours : l’infraction est antérieure à la tentative.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-15-1 — Aggravation',
    question: 'L’embuscade est aggravée lorsqu’elle est commise :',
    options: ['En réunion', 'Avec ITT > 8 jours', 'Avec préméditation'],
    answer: 'En réunion',
    explanation: 'Cours : 222-15-1 al.4.',
    difficulty: 'Moyenne',
  ),

  // ---------- 222-14 : VIOLENCES HABITUELLES ----------
  QuizQuestion(
    category: '222-14 — Habitude',
    question: 'La notion d’habitude suppose :',
    options: [
      'Des violences commises à plusieurs reprises',
      'Une seule violence grave',
      'Un acte uniquement verbal',
    ],
    answer: 'Des violences commises à plusieurs reprises',
    explanation: 'Cours : répétition des violences.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: '222-14 — Violence psychologique',
    question: 'Les violences peuvent être constituées :',
    options: [
      'Même si elles sont psychologiques',
      'Seulement si elles sont physiques',
      'Seulement si ITT > 8 jours',
    ],
    answer: 'Même si elles sont psychologiques',
    explanation: 'Cours : 222-14-3 codifie violences psychologiques.',
    difficulty: 'Moyenne',
  ),

  // ---------- 222-14-5 : FORCES DE SÉCURITÉ / ÉLUS ----------
  QuizQuestion(
    category: '222-14-5 — Victimes',
    question: '222-14-5 vise notamment :',
    options: [
      'Forces de sécurité intérieure, élus locaux, et certains proches',
      'Uniquement les policiers nationaux',
      'Uniquement les magistrats',
    ],
    answer: 'Forces de sécurité intérieure, élus locaux, et certains proches',
    explanation:
        'Cours : liste (gendarmerie, police, municipale, douanes, pompiers, AP, élus...).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-14-5 — ITT (seuil)',
    question: '222-14-5 distingue :',
    options: [
      'ITT > 8 jours et ITT ≤ 8 jours (ou aucune)',
      'ITT ≤ 3 mois et ITT > 3 mois',
      'ITT ≤ 8 jours uniquement',
    ],
    answer: 'ITT > 8 jours et ITT ≤ 8 jours (ou aucune)',
    explanation: 'Cours : deux types de préjudices selon ITT.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // B) 60 CAS PRATIQUES — CONCOURS (ÉNONCÉS LONGS, PIÈGES)
  // =========================================================
  QuizQuestion(
    category: 'Cas concours — 222-17 vs R.623-1',
    question:
        'En dispute, X dit une seule fois : « Je vais te casser la gueule ». Aucune lettre, aucun SMS, aucune répétition. Texte le plus adapté ?',
    options: ['R.623-1 (menace de violence)', '222-17', '222-18'],
    answer: 'R.623-1 (menace de violence)',
    explanation:
        'Cours : 222-17 exclut les menaces de violences (tentative non punissable) → R.623-1.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Cas concours — 222-17 (matérialisée)',
    question:
        'X envoie un seul courrier : « Je vais te brûler ». Pas d’autre message. Qualification principale ?',
    options: [
      '222-17 (menace matérialisée par écrit)',
      '222-16 (messages malveillants)',
      '222-18 (condition)',
    ],
    answer: '222-17 (menace matérialisée par écrit)',
    explanation: 'Cours : écrit = matérialisation, pas besoin de répétition.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas concours — 222-18 (condition explicite)',
    question:
        'X dit : « Donne-moi 500 € sinon je te tue ». Une seule fois, oral. Qualification ?',
    options: ['222-18 (condition) + menace de mort', '222-17 al.2', '222-16'],
    answer: '222-18 (condition) + menace de mort',
    explanation:
        'Cours : condition = injonction “donne-moi…”, moyen indifférent.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas concours — 222-18 (condition + pas de mort)',
    question:
        'X dit : « Si tu ne retires pas ta plainte, je te frappe ». Une seule fois. Qualification la plus adaptée ?',
    options: [
      '222-18 (condition) — menace de délit contre les personnes',
      '222-17',
      'R.623-1',
    ],
    answer: '222-18 (condition) — menace de délit contre les personnes',
    explanation:
        'Cours : 222-18 vise tout délit contre les personnes, sans exigence “tentative punissable”, dès lors qu’il y a condition.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Cas concours — 222-16 (messages)',
    question:
        'Pendant 2 semaines, X envoie 2 SMS par jour : insultes, propos humiliants, aucun chantage. Qualification ?',
    options: [
      '222-16 (envois réitérés de messages malveillants)',
      '222-17',
      '222-18',
    ],
    answer: '222-16 (envois réitérés de messages malveillants)',
    explanation: 'Cours : messages malveillants réitérés = 222-16.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Cas concours — 222-16 (agressions sonores)',
    question:
        'Un voisin met la musique très fort chaque nuit “pour faire craquer” la voisine. Qualification la plus adaptée ?',
    options: [
      '222-16 (agressions sonores en vue de troubler)',
      'R.623-2 (tapage) automatiquement',
      '222-17 (menace)',
    ],
    answer: '222-16 (agressions sonores en vue de troubler)',
    explanation:
        'Cours : agressions sonores = volonté de troubler la tranquillité.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas concours — 222-15-1 (embuscade)',
    question:
        'Deux individus repèrent les horaires d’un agent pénitentiaire, l’attendent chaque soir près de son domicile avec un couteau “pour lui faire peur”. Ils sont interpellés avant toute attaque. Qualification ?',
    options: [
      '222-15-1 (embuscade)',
      '222-14-1 (violences avec arme sur DAP)',
      '222-17 (menace)',
    ],
    answer: '222-15-1 (embuscade)',
    explanation:
        'Cours : guet-apens + but de menacer/commettre violences avec arme ; violences non réalisées OK.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Cas concours — 222-15-1 (si passage à l’acte)',
    question:
        'Même situation, mais ils sortent le couteau et le menacent réellement. On poursuit :',
    options: [
      'Les textes sur les violences (selon faits) plutôt que 222-15-1',
      'Toujours 222-15-1 uniquement',
      'Toujours 222-16',
    ],
    answer: 'Les textes sur les violences (selon faits) plutôt que 222-15-1',
    explanation:
        'Cours : 222-15-1 vise les violences en voie de réalisation ; si passage à l’action → textes des violences.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Cas concours — Tortures/Barbarie (critère)',
    question:
        'Une victime est soumise à des actes d’une gravité exceptionnelle, dépassant de simples violences, visant à nier sa dignité. Qualification ?',
    options: [
      '222-1 (tortures et actes de barbarie)',
      '222-14 (violences habituelles)',
      '222-16 (messages malveillants)',
    ],
    answer: '222-1 (tortures et actes de barbarie)',
    explanation: 'Cours : gravité exceptionnelle + volonté de nier dignité.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas concours — 222-14 (habitude)',
    question:
        'X frappe sa compagne “souvent”, sur plusieurs mois. Certificats médicaux établissent des ITT variables. Texte principal ?',
    options: [
      '222-14 (violences habituelles au sein du couple / ex)',
      '222-17',
      '222-16',
    ],
    answer: '222-14 (violences habituelles au sein du couple / ex)',
    explanation: 'Cours : répétition + lien conjugal = 222-14.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas concours — 222-14-5 (élu local)',
    question:
        'Après une décision municipale, un conseiller municipal est frappé “en représailles”. La qualité était connue. Texte ?',
    options: ['222-14-5', '222-14', '222-16'],
    answer: '222-14-5',
    explanation:
        'Cours : élus locaux visés (mandat actuel ou dans les 6 ans) du fait des fonctions.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // C) 50 CAS PRATIQUES SUPPLÉMENTAIRES (ULTRA CONCOURS)
  // (Pour rester lisible ici, je te mets un gros pack de 50
  //  sous forme condensée — mêmes règles, 3 niveaux)
  // =========================================================
  QuizQuestion(
    category: 'Pack concours — Menace indirecte',
    question:
        'X menace Y en passant par Z (“dis-lui que je vais le tuer”). Condition 222-17 ?',
    options: [
      'Oui : menace peut être indirecte',
      'Non : doit être directe',
      'Non : relève seulement de 222-16',
    ],
    answer: 'Oui : menace peut être indirecte',
    explanation: 'Cours : menace directe ou indirecte (tiers/rapportée).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Pack concours — 222-17 (infraction pas précisée)',
    question:
        'X écrit : “Tu vas payer, tu vas mourir” sans préciser comment. 222-17 possible ?',
    options: [
      'Oui si sens clair (menace de mort)',
      'Non car il faut décrire le crime exact',
      'Non car il faut une condition',
    ],
    answer: 'Oui si sens clair (menace de mort)',
    explanation:
        'Cours : l’infraction menacée n’a pas à être expressément désignée si le sens est clair.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Pack concours — 222-16 (contenu vs fréquence)',
    question:
        'X appelle 30 fois sans parler. Le caractère malveillant peut se déduire :',
    options: [
      'De la fréquence seule, même sans contenu',
      'Uniquement du contenu verbal',
      'Uniquement si menace écrite',
    ],
    answer: 'De la fréquence seule, même sans contenu',
    explanation:
        'Cours : malveillance déductible de la multiplication des appels.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Pack concours — 222-18 (condition implicite)',
    question:
        'X dit : “Si tu continues à témoigner, tu vas y passer”. Qualification la plus adaptée ?',
    options: ['222-18 (condition) + menace de mort', '222-16', 'R.623-2'],
    answer: '222-18 (condition) + menace de mort',
    explanation:
        'Cours : condition peut être formulée comme un ordre/contrainte (faire/ne pas faire).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Pack concours — 222-15-1 (victime proche)',
    question:
        'On attend le fils d’un policier à la sortie de l’école pour lui “mettre un couteau sous la gorge” en raison du métier du père. Texte ?',
    options: ['222-15-1 (embuscade) — proche visé', '222-17', '222-14'],
    answer: '222-15-1 (embuscade) — proche visé',
    explanation:
        'Cours : 222-15-1 vise aussi conjoint/ascendant/descendant/domicilié des personnes listées.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // D) 20 Q "RÉFLEXE PEINE" (chronométré concours)
  // =========================================================
  QuizQuestion(
    category: 'Réflexe peine — 222-17 al.1',
    question: '222-17 al.1 :',
    options: ['6 mois + 7 500 €', '1 an + 15 000 €', '3 ans + 45 000 €'],
    answer: '6 mois + 7 500 €',
    explanation: 'Cours : barème 222-17 al.1.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Réflexe peine — 222-17 al.2',
    question: '222-17 al.2 :',
    options: ['3 ans + 45 000 €', '5 ans + 75 000 €', '7 ans + 100 000 €'],
    answer: '3 ans + 45 000 €',
    explanation: 'Cours : menace de mort 222-17 al.2.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Réflexe peine — 222-16 (simple)',
    question: '222-16 (simple) :',
    options: ['1 an + 15 000 €', '6 mois + 7 500 €', '3 ans + 45 000 €'],
    answer: '1 an + 15 000 €',
    explanation: 'Cours : barème 222-16.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Réflexe peine — 222-15-1 (simple)',
    question: '222-15-1 (simple) :',
    options: ['5 ans + 75 000 €', '7 ans + 100 000 €', '3 ans + 45 000 €'],
    answer: '5 ans + 75 000 €',
    explanation: 'Cours : barème 222-15-1.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Réflexe peine — 222-1',
    question: '222-1 (tortures/barbarie) :',
    options: [
      '15 ans de réclusion (période de sûreté)',
      '20 ans de réclusion (période de sûreté)',
      '30 ans de réclusion (période de sûreté)',
    ],
    answer: '15 ans de réclusion (période de sûreté)',
    explanation: 'Cours : 222-1.',
    difficulty: 'Moyenne',
  ),

  // =======================
  // FIN BLOC 4
  // Dis "ENCORE" et je te fais un BLOC 5 (200 questions) :
  // - 100 Q "flashcards" (article -> définition -> peine)
  // - 100 cas concours ultra longs (qualif + article + peine + tentative/complicité)
  // =======================

  // =========================================================
  // 222-15-1 — EMBUSCADE — PEINES
  // =========================================================
  QuizQuestion(
    category: '222-15-1 — Répression — Base',
    question: 'La peine encourue pour l’embuscade (222-15-1) est :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Cours : 222-15-1 (simple) = 5 ans / 75 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: '222-15-1 — Répression — Réunion',
    question: 'La peine encourue pour l’embuscade aggravée (réunion) est :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Cours : 222-15-1 al.4 (réunion) = 7 ans / 100 000 €.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 222-1 et s. — TORTURES / BARBARIE — PEINES (RÉCAP)
  // =========================================================
  QuizQuestion(
    category: 'Tortures/Barbarie — Répression — Base',
    question: 'La peine encourue pour 222-1 (tortures/actes de barbarie) est :',
    options: [
      '15 ans de réclusion (période de sûreté)',
      '20 ans de réclusion (période de sûreté)',
      '30 ans de réclusion (période de sûreté)',
    ],
    answer: '15 ans de réclusion (période de sûreté)',
    explanation: 'Cours : 222-1 = 15 ans de réclusion + période de sûreté.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Répression — 1er degré',
    question: 'La peine encourue pour 222-3 (1er degré d’aggravation) est :',
    options: [
      '20 ans de réclusion (période de sûreté)',
      '15 ans de réclusion (période de sûreté)',
      '30 ans de réclusion (période de sûreté)',
    ],
    answer: '20 ans de réclusion (période de sûreté)',
    explanation: 'Cours : 222-3 = 20 ans de réclusion + période de sûreté.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Répression — 2e degré',
    question: 'La peine encourue pour 222-4 (2e degré d’aggravation) est :',
    options: [
      '30 ans de réclusion (période de sûreté)',
      '20 ans de réclusion (période de sûreté)',
      'Réclusion à perpétuité',
    ],
    answer: '30 ans de réclusion (période de sûreté)',
    explanation: 'Cours : 222-4 = 30 ans de réclusion + période de sûreté.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Répression — Mutilation/infirmité',
    question:
        'Quand les tortures/actes de barbarie entraînent une mutilation ou une infirmité permanente (222-5), la peine est :',
    options: [
      '30 ans de réclusion (période de sûreté)',
      '20 ans de réclusion (période de sûreté)',
      '15 ans de réclusion (période de sûreté)',
    ],
    answer: '30 ans de réclusion (période de sûreté)',
    explanation:
        'Cours : 222-5 (mutilation/infirmité) = 30 ans de réclusion + période de sûreté.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tortures/Barbarie — Répression — Mort sans intention',
    question:
        'Quand les tortures/actes de barbarie entraînent la mort sans intention de la donner (222-6), la peine est :',
    options: [
      'Réclusion à perpétuité (période de sûreté)',
      '30 ans de réclusion (période de sûreté)',
      '20 ans de réclusion (période de sûreté)',
    ],
    answer: 'Réclusion à perpétuité (période de sûreté)',
    explanation: 'Cours : 222-6 = réclusion à perpétuité + période de sûreté.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 222-14 — VIOLENCES HABITUELLES (COUPLE / MINEUR / VULNÉRABLE) — PEINES
  // =========================================================
  QuizQuestion(
    category: '222-14 — Violences habituelles — ITT 0 à 8',
    question: 'Violences habituelles (222-14) avec ITT 0 à 8 jours :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Cours : tableau 222-14 : ITT 0-8 = 5 ans / 75 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-14 — Violences habituelles — ITT > 8',
    question: 'Violences habituelles (222-14) avec ITT > 8 jours :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation: 'Cours : tableau 222-14 : ITT > 8 = 10 ans / 150 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '222-14 — Violences habituelles — Infirmité',
    question:
        'Violences habituelles (222-14) ayant entraîné une mutilation ou une infirmité permanente :',
    options: [
      '20 ans de réclusion (période de sûreté)',
      '30 ans de réclusion (période de sûreté)',
      '15 ans de réclusion (période de sûreté)',
    ],
    answer: '20 ans de réclusion (période de sûreté)',
    explanation:
        'Cours : tableau 222-14 : mutilation/infirmité = 20 ans de réclusion + période de sûreté.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: '222-14 — Violences habituelles — Mort',
    question:
        'Violences habituelles (222-14) ayant entraîné la mort sans intention de la donner :',
    options: [
      '30 ans de réclusion (période de sûreté)',
      '20 ans de réclusion (période de sûreté)',
      'Réclusion à perpétuité',
    ],
    answer: '30 ans de réclusion (période de sûreté)',
    explanation:
        'Cours : tableau 222-14 : mort sans intention = 30 ans de réclusion + période de sûreté.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 222-14-1 — VIOLENCES AVEC ARME SUR DAP / SP / TRANSPORT (bande/guet-apens) — PEINES
  // =========================================================
  QuizQuestion(
    category: '222-14-1 — Répression — ITT 0 à 8',
    question:
        '222-14-1 (arme + bande organisée ou guet-apens) avec ITT 0 à 8 jours :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation: 'Cours : 222-14-1 4° (ITT 0-8) = 10 ans / 150 000 €.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: '222-14-1 — Répression — ITT > 8',
    question:
        '222-14-1 (arme + bande organisée ou guet-apens) avec ITT > 8 jours :',
    options: [
      '15 ans de réclusion (période de sûreté)',
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '20 ans de réclusion (période de sûreté)',
    ],
    answer: '15 ans de réclusion (période de sûreté)',
    explanation:
        'Cours : 222-14-1 3° = 15 ans de réclusion + période de sûreté.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: '222-14-1 — Répression — Infirmité',
    question:
        '222-14-1 (arme + bande organisée ou guet-apens) avec mutilation/infirmité permanente :',
    options: [
      '20 ans de réclusion (période de sûreté)',
      '30 ans de réclusion (période de sûreté)',
      '15 ans de réclusion (période de sûreté)',
    ],
    answer: '20 ans de réclusion (période de sûreté)',
    explanation:
        'Cours : 222-14-1 2° = 20 ans de réclusion + période de sûreté.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: '222-14-1 — Répression — Mort',
    question:
        '222-14-1 (arme + bande organisée ou guet-apens) ayant entraîné la mort sans intention de la donner :',
    options: [
      '30 ans de réclusion (période de sûreté)',
      '20 ans de réclusion (période de sûreté)',
      'Réclusion à perpétuité',
    ],
    answer: '30 ans de réclusion (période de sûreté)',
    explanation:
        'Cours : 222-14-1 1° = 30 ans de réclusion + période de sûreté.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 30 CAS PRATIQUES ULTRA PIÈGES (QUALIF + TEXTE)
  // =========================================================
  QuizQuestion(
    category: 'Cas pratique — 222-16 vs 222-17',
    question:
        'Un individu appelle 2 fois un médecin à 3h du matin, sans parler, juste pour le réveiller. Qualification la plus adaptée ?',
    options: [
      '222-16 (appels malveillants réitérés)',
      '222-17 (menace)',
      'R.623-1 (menace de violence)',
    ],
    answer: '222-16 (appels malveillants réitérés)',
    explanation:
        'Cours : 222-16 = appels malveillants réitérés ; 2 appels suffisent pour la réitération.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — 222-17 (écrit)',
    question:
        'Un individu écrit sur un mur : « Je vais te tuer ». Qualification principale ?',
    options: [
      '222-17 (menace matérialisée par écrit)',
      '222-18 (condition)',
      '222-16 (messages)',
    ],
    answer: '222-17 (menace matérialisée par écrit)',
    explanation:
        'Cours : matérialisation par écrit = 222-17, sans besoin de réitération.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — 222-17 (gestuelle seule)',
    question:
        'Une personne mime un pistolet avec ses doigts et fait « pan pan », sans rien écrire ni répéter. Qualification 222-17 ?',
    options: [
      'Non : gestuelle seule insuffisante pour matérialiser',
      'Oui : 222-17 constitué',
      'Oui : 222-18 constitué',
    ],
    answer: 'Non : gestuelle seule insuffisante pour matérialiser',
    explanation:
        'Cours : la gestuelle seule est exclue de la matérialisation de la menace.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Cas pratique — 222-18 (condition par abstention)',
    question:
        '« Si tu ne quittes pas la ville, je te tue » (oral, une seule fois). Qualification ?',
    options: [
      '222-18 (condition = abstention exigée) + menace de mort',
      '222-17 al.2 uniquement',
      '222-16',
    ],
    answer: '222-18 (condition = abstention exigée) + menace de mort',
    explanation: 'Cours : condition = faire/ne pas faire ; moyen indifférent.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — Embuscade',
    question:
        'Deux individus attendent cachés près d’un commissariat avec un bâton pour « faire peur » à un policier à la sortie. Ils sont interpellés avant tout acte. Qualification ?',
    options: [
      '222-15-1 (embuscade) si but = violences avec usage/menace d’une arme',
      '222-16 (agression sonore)',
      '222-17 (menace)',
    ],
    answer:
        '222-15-1 (embuscade) si but = violences avec usage/menace d’une arme',
    explanation:
        'Cours : embuscade = guet-apens + but de violences avec usage/menace d’une arme ; violences non réalisées OK.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Cas pratique — 222-14-5 (victime)',
    question:
        'Des violences sont commises sur le conjoint d’un gendarme « pour se venger » du gendarme. Texte adapté ?',
    options: [
      '222-14-5 (proche visé en raison des fonctions)',
      '222-14 (violences habituelles)',
      '222-16 (messages)',
    ],
    answer: '222-14-5 (proche visé en raison des fonctions)',
    explanation:
        'Cours : 222-14-5 vise aussi le conjoint/ascendants/descendants/domiciliés en raison des fonctions.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Cas pratique — 222-16 (SMS)',
    question:
        'Une personne envoie chaque jour 1 SMS insultant pendant 10 jours. Qualification ?',
    options: [
      '222-16 (envois réitérés de messages malveillants)',
      '222-17 (menace réitérée)',
      'R.623-2 (tapage)',
    ],
    answer: '222-16 (envois réitérés de messages malveillants)',
    explanation: 'Cours : SMS réitérés malveillants = 222-16.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Cas pratique — Tortures/Barbarie',
    question:
        'Une victime est ligotée et subit des sévices destinés à l’humilier et nier sa dignité pendant plusieurs heures. Qualification la plus adaptée ?',
    options: [
      'Tortures et actes de barbarie (222-1)',
      'Violences simples',
      'Menace 222-17',
    ],
    answer: 'Tortures et actes de barbarie (222-1)',
    explanation:
        'Cours : gravité exceptionnelle + volonté de nier la dignité de la personne humaine.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // MINI RAFRAÎCHISSEMENT "TENTATIVE / COMPLICITÉ" (Consolidation)
  // =========================================================
  QuizQuestion(
    category: 'Tentative — 222-17',
    question: 'La tentative de 222-17 est :',
    options: [
      'Non (délit formalisé par conditions déjà exigées)',
      'Oui, toujours',
      'Oui uniquement si menace de mort',
    ],
    answer: 'Non (délit formalisé par conditions déjà exigées)',
    explanation: 'Cours : 222-17 : tentative non.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Tentative — 222-16',
    question: 'La tentative de 222-16 est :',
    options: ['Non', 'Oui', 'Oui uniquement si aggravé'],
    answer: 'Non',
    explanation: 'Cours : 222-16 : tentative non.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Tentative — 222-15-1',
    question: 'La tentative de 222-15-1 (embuscade) est :',
    options: ['Non', 'Oui', 'Oui uniquement en réunion'],
    answer: 'Non',
    explanation:
        'Cours : tentative non, l’infraction est déjà au stade préparatoire.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tentative — 222-1',
    question: 'La tentative de tortures/actes de barbarie (222-1) est :',
    options: ['Oui', 'Non', 'Oui seulement si la victime est blessée'],
    answer: 'Oui',
    explanation: 'Cours : tentative de crime punissable.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Complicité — Menaces',
    question: 'La complicité pour les menaces 222-17 / 222-18 est :',
    options: ['Oui (121-6 / 121-7)', 'Non', 'Oui seulement si menace de mort'],
    answer: 'Oui (121-6 / 121-7)',
    explanation: 'Cours : complicité oui, selon 121-6 et 121-7.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Vrai/Faux — Tortures/Barbarie',
    question:
        'Vrai ou faux : les tortures/actes de barbarie se distinguent des violences simples par une gravité exceptionnelle et l’atteinte à la dignité.',
    options: ['Vrai', 'Faux', 'Uniquement si ITT > 8'],
    answer: 'Vrai',
    explanation: 'Cours : gravité exceptionnelle + volonté de nier la dignité.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Concours — Vrai/Faux',
    question:
        'Affirmation : « En 222-14-5, les anciens élus sont protégés sans limite de temps. »',
    options: [
      'Faux',
      'Vrai',
      'Vrai uniquement si l’auteur est en bande organisée',
    ],
    answer: 'Faux',
    explanation:
        'Le cours : protection dans la limite de 6 ans après expiration du mandat.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Concours — Tentatives',
    question: 'Quelle combinaison est correcte ?',
    options: [
      'Menaces (222-17/222-18) : tentative non — Embuscade : tentative non — Tortures : tentative oui',
      'Menaces : tentative oui — Embuscade : tentative oui — Tortures : tentative non',
      'Tout est tentative oui',
    ],
    answer:
        'Menaces (222-17/222-18) : tentative non — Embuscade : tentative non — Tortures : tentative oui',
    explanation: 'Le cours : menaces et embuscade non ; crime de torture oui.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Tortures — Définition',
    question: 'Les tortures et actes de barbarie se caractérisent par :',
    options: [
      'Des souffrances exceptionnellement aiguës niant la dignité humaine',
      'De simples violences',
      'Une imprudence',
    ],
    answer:
        'Des souffrances exceptionnellement aiguës niant la dignité humaine',
    explanation: 'Définition jurisprudentielle reprise au cours.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Tortures — Fondement',
    question: 'Les tortures et actes de barbarie sont prévus par :',
    options: [
      'L’article 222-1 du Code pénal',
      'L’article 221-1 du Code pénal',
      'L’article 222-14 du Code pénal',
    ],
    answer: 'L’article 222-1 du Code pénal',
    explanation: 'Le cours cite l’article 222-1 CP.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Tortures — Tentative',
    question: 'La tentative de tortures et actes de barbarie est :',
    options: ['Punissable', 'Non punissable', 'Une contravention'],
    answer: 'Punissable',
    explanation: 'La tentative de crime est toujours punissable.',
    difficulty: 'Facile',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizAtteinteIntegrite extends StatefulWidget {
  static const String routeName =
      '/gpx/crimes_personne/quiz/atteintes_volontaires_integrite';
  final String uid;
  final String email;

  const QuizAtteinteIntegrite({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizAtteinteIntegrite> createState() => _QuizAtteinteIntegriteState();
}

class _QuizAtteinteIntegriteState extends State<QuizAtteinteIntegrite>
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
        ? questionAtteinteIntegrite
        : questionAtteinteIntegrite
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
            'module_name': 'Crimes & délits contre la personne',
            'quiz_name': 'Atteinte Intégrité',
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
      await _sb.from('quiz_atteintes_integrite').insert({
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
      debugPrint('❌ quiz_atteintes_integrite insert failed: $e');
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
