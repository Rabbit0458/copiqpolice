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

final List<QuizQuestion> questionGPMiseEnDangerEtAbstentions = [
  // =========================================================
  // FACILE (Définitions / réflexes)
  // =========================================================
  const QuizQuestion(
    category:
        'Mise en danger par diffusion d’informations personnelles — Fondement',
    question:
        'L’infraction de “mise en danger par la diffusion d’informations personnelles” est prévue par :',
    options: [
      'L’article 223-1-1 du Code pénal',
      'L’article 223-6 du Code pénal',
      'L’article 223-15-2 du Code pénal',
    ],
    answer: 'L’article 223-1-1 du Code pénal',
    explanation:
        'Le cours précise que l’article 223-1-1 C.P. définit et réprime cette infraction.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-assistance à personne en péril — Fondement',
    question: 'La non-assistance à personne en péril est incriminée par :',
    options: [
      'L’article 223-6 alinéa 2 du Code pénal',
      'L’article 223-6 alinéa 1 du Code pénal',
      'L’article 223-3 du Code pénal',
    ],
    answer: 'L’article 223-6 alinéa 2 du Code pénal',
    explanation:
        'Le cours indique : art. 223-6 al.2 = incrimination ; art. 223-6 al.1 = peine applicable.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-obstacle à la commission d’un crime ou délit — Fondement',
    question:
        'Le non-obstacle à la commission d’un crime ou d’un délit contre l’intégrité corporelle est prévu par :',
    options: [
      'L’article 223-6 alinéa 1 du Code pénal',
      'L’article 223-6 alinéa 2 du Code pénal',
      'L’article 223-1 du Code pénal',
    ],
    answer: 'L’article 223-6 alinéa 1 du Code pénal',
    explanation: 'Le cours : non-obstacle = art. 223-6 al.1 C.P.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui — Fondement',
    question: 'Le délit de risques causés à autrui est prévu par :',
    options: [
      'L’article 223-1 du Code pénal',
      'L’article 223-3 du Code pénal',
      'L’article 223-15-2 du Code pénal',
    ],
    answer: 'L’article 223-1 du Code pénal',
    explanation:
        'Le cours : art. 223-1 C.P. prévoit et réprime les risques causés à autrui.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Délaissement d’une personne vulnérable — Fondement',
    question:
        'Le délaissement d’une personne qui n’est pas en mesure de se protéger est prévu par :',
    options: [
      'L’article 223-3 du Code pénal',
      'L’article 223-4 du Code pénal',
      'L’article 227-1 du Code pénal',
    ],
    answer: 'L’article 223-3 du Code pénal',
    explanation:
        'Le cours : délaissement = art. 223-3 C.P. (les conséquences graves relèvent de l’art. 223-4).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category:
        'Mise en danger par diffusion d’informations personnelles — Nature',
    question:
        'La révélation/diffusion/transmission exigée par l’article 223-1-1 doit-elle être publique ?',
    options: [
      'Oui, uniquement publique',
      'Non, elle peut être non publique',
      'Oui, uniquement via réseaux sociaux',
    ],
    answer: 'Non, elle peut être non publique',
    explanation:
        'Le cours : l’incrimination n’exige pas que la diffusion soit publique (SMS/courriels possibles).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Faits non répréhensibles',
    question:
        'Parmi ces comportements, lequel n’est pas répréhensible au titre de l’article 223-1-1 ?',
    options: [
      'La simple détention/captation des informations',
      'La transmission d’une adresse pour exposer à un risque direct',
      'La diffusion d’un numéro de téléphone pour localiser la victime',
    ],
    answer: 'La simple détention/captation des informations',
    explanation:
        'Le cours : la simple réception/captation/détention des informations n’est pas répréhensible.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-assistance — Définition',
    question:
        'La non-assistance à personne en péril consiste principalement à :',
    options: [
      'S’abstenir volontairement d’aider une personne en péril',
      'Mettre autrui en danger par violation d’une règle de sécurité',
      'Abandonner une personne vulnérable dans un lieu quelconque',
    ],
    answer: 'S’abstenir volontairement d’aider une personne en péril',
    explanation:
        'Le cours : abstention volontaire de porter assistance (action personnelle ou en provoquant un secours).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-obstacle — Champ',
    question: 'Le non-obstacle vise :',
    options: [
      'Tout crime ou délit',
      'Uniquement les contraventions',
      'Les crimes et délits contre l’intégrité corporelle',
    ],
    answer: 'Les crimes et délits contre l’intégrité corporelle',
    explanation:
        'Le cours : l’incrimination est limitée aux crimes/délits contre l’intégrité corporelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui — Condition',
    question: 'Le délit de l’article 223-1 exige notamment :',
    options: [
      'Une violation manifestement délibérée d’une obligation particulière de prudence ou sécurité',
      'Une intention de blesser autrui',
      'Un dommage corporel effectivement réalisé',
    ],
    answer:
        'Une violation manifestement délibérée d’une obligation particulière de prudence ou sécurité',
    explanation:
        'Le cours : l’intention coupable est la violation délibérée de la règle, pas l’intention de blesser.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Délaissement — Nature',
    question: 'Le délaissement (art. 223-3) suppose :',
    options: [
      'Une simple omission (ne rien faire)',
      'Un acte positif d’abandon (placer/partir et laisser)',
      'Une diffusion d’informations personnelles',
    ],
    answer: 'Un acte positif d’abandon (placer/partir et laisser)',
    explanation:
        'Le cours : comportement positif (placer la personne et l’abandonner ou s’éloigner volontairement).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Délaissement — Mineurs',
    question:
        'Les mineurs de 15 ans sont-ils visés par l’article 223-3 (délaissement) ?',
    options: [
      'Oui, toujours',
      'Non, car un texte spécifique les vise (art. 227-1)',
      'Seulement si la victime est malade',
    ],
    answer: 'Non, car un texte spécifique les vise (art. 227-1)',
    explanation:
        'Le cours : les mineurs de 15 ans sont exclus du champ (délaissement spécifique art. 227-1).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Objet',
    question:
        'Les informations visées par l’article 223-1-1 sont relatives à :',
    options: [
      'La vie privée, familiale ou professionnelle',
      'Uniquement la vie politique',
      'Uniquement la vie professionnelle',
    ],
    answer: 'La vie privée, familiale ou professionnelle',
    explanation:
        'Le cours : informations relatives à la vie privée, familiale ou professionnelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse — Fondement',
    question:
        'L’abus frauduleux de l’état d’ignorance ou de faiblesse est prévu par :',
    options: [
      'L’article 223-15-2 du Code pénal',
      'L’article 223-1-1 du Code pénal',
      'L’article 223-6 du Code pénal',
    ],
    answer: 'L’article 223-15-2 du Code pénal',
    explanation:
        'Le cours : art. 223-15-2 C.P. prévoit et réprime l’abus frauduleux de faiblesse/ignorance.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse — Victimes protégées',
    question: 'L’article 223-15-2 protège notamment :',
    options: [
      'Toute personne sans condition',
      'Un mineur ou une personne particulièrement vulnérable (âge, maladie, etc.)',
      'Uniquement les personnes âgées',
    ],
    answer:
        'Un mineur ou une personne particulièrement vulnérable (âge, maladie, etc.)',
    explanation:
        'Le cours : protection limitée à des catégories (mineurs / vulnérabilité apparente ou connue).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-assistance — Absence de risque',
    question:
        'La non-assistance impose d’agir uniquement si l’aide peut être apportée :',
    options: [
      'Avec héroïsme obligatoire',
      'Sans risque pour soi ou pour les tiers',
      'Uniquement par action personnelle',
    ],
    answer: 'Sans risque pour soi ou pour les tiers',
    explanation:
        'Le cours : la loi n’impose pas l’héroïsme ; assistance sans risque pour l’intervenant/les tiers.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui — Dommage',
    question:
        'Pour le délit de risques causés à autrui (223-1), faut-il un dommage réalisé ?',
    options: [
      'Oui, une blessure effective est indispensable',
      'Non, c’est une mise en danger (risque immédiat) qui suffit',
      'Oui, uniquement une ITT',
    ],
    answer: 'Non, c’est une mise en danger (risque immédiat) qui suffit',
    explanation:
        'Le cours : il s’agit d’exposer directement autrui à un risque immédiat grave.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Intention',
    question: 'L’élément moral de l’article 223-1-1 est principalement :',
    options: [
      'L’intention de nuire gravement à autrui',
      'La négligence simple',
      'L’intention de voler',
    ],
    answer: 'L’intention de nuire gravement à autrui',
    explanation:
        'Le cours : intention manifeste d’exposer gravement la personne/les proches/les biens.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // MOYENNE (conditions précises / subtilités)
  // =========================================================
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Finalité',
    question:
        'La révélation/diffusion/transmission devient pénalement répréhensible (223-1-1) si elle est faite :',
    options: [
      'Pour informer le public, même sans intention de nuire',
      'Aux fins d’exposer la personne (ou sa famille) à un risque direct d’atteinte',
      'Uniquement si la victime est une personnalité publique',
    ],
    answer:
        'Aux fins d’exposer la personne (ou sa famille) à un risque direct d’atteinte',
    explanation:
        'Le cours : finalité = exposer à un risque direct d’atteinte aux personnes ou aux biens.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Identification/localisation',
    question: 'L’information diffusée doit permettre :',
    options: [
      'Uniquement d’identifier la personne',
      'Uniquement de localiser la personne',
      'D’identifier ou de localiser la personne',
    ],
    answer: 'D’identifier ou de localiser la personne',
    explanation:
        'Le cours : informations permettant d’identifier ou de localiser la personne.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Exemples',
    question:
        'Selon le cours, lequel peut constituer une information relevant de la vie privée/familiale/professionnelle ?',
    options: [
      'Une adresse ou un numéro de téléphone',
      'Une opinion générale sur la police',
      'Un pseudonyme sans lien avec la personne',
    ],
    answer: 'Une adresse ou un numéro de téléphone',
    explanation:
        'Le cours cite notamment adresses/numéros de téléphone (et parfois photographies selon contexte).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Photographie',
    question:
        'Une photographie peut être une information visée par l’article 223-1-1 notamment lorsqu’elle est :',
    options: [
      'Prise dans un lieu privé à l’insu de la personne',
      'Prise dans la rue avec son accord',
      'Uniquement une photo de groupe floue',
    ],
    answer: 'Prise dans un lieu privé à l’insu de la personne',
    explanation:
        'Le cours : une photo peut relever de la vie privée, notamment si prise en lieu privé à l’insu.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Réseaux sociaux',
    question: 'Le cours souligne que l’infraction vise particulièrement :',
    options: [
      'Les réseaux sociaux et propos haineux en ligne',
      'Exclusivement les journaux papier',
      'Uniquement les communications internes d’entreprise',
    ],
    answer: 'Les réseaux sociaux et propos haineux en ligne',
    explanation:
        'Le cours : incriminer les propos haineux en ligne poursuivant des objectifs similaires à des provocations/complicité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Journaliste',
    question: 'Un journaliste peut-il être auteur de l’infraction (223-1-1) ?',
    options: [
      'Jamais, il est toujours immunisé',
      'Oui, si l’intention de nuire gravement est démontrée',
      'Oui, sans condition',
    ],
    answer: 'Oui, si l’intention de nuire gravement est démontrée',
    explanation:
        'Le cours : vise toute personne, y compris journaliste, si la preuve de l’intention de nuire gravement est rapportée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Information du public',
    question:
        'L’infraction 223-1-1 a-t-elle pour objet de réprimer la diffusion faite pour informer le public ?',
    options: [
      'Oui, même si le but est informatif',
      'Non, lorsqu’il s’agit d’informer le public (sauf intention de nuire gravement démontrée)',
      'Oui, uniquement en presse écrite',
    ],
    answer:
        'Non, lorsqu’il s’agit d’informer le public (sauf intention de nuire gravement démontrée)',
    explanation:
        'Le cours : n’a pas pour objet de réprimer l’information du public, même si un tiers pourrait en faire usage.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Mise en danger par diffusion — Circonstances aggravantes (catégories)',
    question:
        'Parmi ces victimes, laquelle est expressément visée par les aggravations de l’article 223-1-1 al.2 ?',
    options: [
      'Une personne dépositaire de l’autorité publique',
      'Un simple voisin',
      'Un commerçant',
    ],
    answer: 'Une personne dépositaire de l’autorité publique',
    explanation:
        'Le cours : aggravation si victime dépositaire autorité publique / mission service public / mandat électif / candidat / journaliste.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Aggravation (proches)',
    question:
        'L’article 223-1-1 al.2 vise aussi des proches de la personne protégée lorsqu’ils sont ciblés :',
    options: [
      'Sans lien avec les fonctions exercées',
      'En raison des fonctions exercées par la personne protégée',
      'Uniquement si le proche est lui-même fonctionnaire',
    ],
    answer: 'En raison des fonctions exercées par la personne protégée',
    explanation:
        'Le cours : aggravation si conjoint/ascendant/descendant/autre personne vivant au domicile, en raison des fonctions de la personne protégée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Aggravation (mineur)',
    question: 'La circonstance aggravante de l’article 223-1-1 al.3 vise :',
    options: [
      'Une personne mineure',
      'Une personne majeure',
      'Une personne dépositaire de l’autorité publique uniquement',
    ],
    answer: 'Une personne mineure',
    explanation:
        'Le cours : al.3 = lorsque les faits sont commis au préjudice d’une personne mineure.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Aggravation (vulnérabilité)',
    question: 'La vulnérabilité aggravante (223-1-1 al.4) doit être :',
    options: [
      'Totalement inconnue de l’auteur',
      'Apparente ou connue de l’auteur',
      'Uniquement liée à la richesse',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation:
        'Le cours : vulnérabilité due à âge/maladie/infirmité/déficience/état de grossesse, apparente ou connue.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Peines (simple)',
    question:
        'Pour la qualification simple (223-1-1 al.1), les peines principales encourues par une personne physique sont :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le tableau du cours : simple = 3 ans + 45 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Peines (aggravée)',
    question:
        'Pour les formes aggravées de l’article 223-1-1, la peine principale indiquée par le cours est :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Le tableau du cours : aggravée = 5 ans + 75 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Tentative/complicité',
    question: 'Pour l’article 223-1-1, le cours indique :',
    options: [
      'Tentative : oui / Complicité : non',
      'Tentative : non / Complicité : oui',
      'Tentative : oui / Complicité : oui',
    ],
    answer: 'Tentative : non / Complicité : oui',
    explanation: 'Le cours : tentative non ; complicité oui (121-6/121-7).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-assistance — Péril',
    question: 'Le péril exigé pour la non-assistance doit être :',
    options: [
      'Hypothétique ou éventuel',
      'Caractérisé et imminent (constaté)',
      'Uniquement d’origine infractionnelle',
    ],
    answer: 'Caractérisé et imminent (constaté)',
    explanation:
        'Le cours : péril caractérisé, non simplement présumé ; danger présent, pas risques éventuels.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-assistance — Cause du péril',
    question:
        'Concernant la cause ou la nature du péril (non-assistance), le cours retient :',
    options: [
      'Une distinction selon la cause (accident/infraction)',
      'Aucune distinction selon la cause ou la nature du péril',
      'Seulement les périls d’origine criminelle',
    ],
    answer: 'Aucune distinction selon la cause ou la nature du péril',
    explanation:
        'Le cours : indifférence de la cause du péril (péril naturel, accidentel ou infractionnel).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-assistance — Forme de l’assistance',
    question: 'L’assistance peut être apportée :',
    options: [
      'Uniquement en agissant personnellement',
      'Soit en agissant personnellement, soit en provoquant un secours',
      'Uniquement en appelant la police',
    ],
    answer: 'Soit en agissant personnellement, soit en provoquant un secours',
    explanation:
        'Le cours : action personnelle ou recherche/provocation de secours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-assistance — Obligation de moyens',
    question: 'La non-assistance impose une obligation :',
    options: [
      'De résultat (il faut sauver la victime)',
      'De moyens (l’aide doit être suffisante, peu importe son efficacité finale)',
      'Aucune obligation',
    ],
    answer:
        'De moyens (l’aide doit être suffisante, peu importe son efficacité finale)',
    explanation:
        'Le cours : obligation de moyens ; l’infraction n’est pas de ne pas sauver, mais de ne pas avoir prêté aide.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-assistance — Élément moral',
    question: 'L’élément moral de la non-assistance suppose notamment :',
    options: [
      'Conscience du péril et volonté de ne pas agir',
      'Intention de tuer',
      'Négligence simple',
    ],
    answer: 'Conscience du péril et volonté de ne pas agir',
    explanation:
        'Le cours : connaissance d’un péril immédiat et refus volontaire d’intervenir par les modes possibles.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-assistance — Aggravation',
    question:
        'La circonstance aggravante de l’article 223-6 al.3 (non-assistance) vise :',
    options: [
      'Une personne mineure de 15 ans',
      'Une personne mineure (sans précision)',
      'Un dépositaire de l’autorité publique',
    ],
    answer: 'Une personne mineure de 15 ans',
    explanation:
        'Le cours : aggravation lorsque la personne en péril est un mineur de 15 ans.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-assistance — Peines',
    question:
        'Pour la non-assistance simple (223-6 al.2), les peines principales indiquées sont :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation:
        'Le tableau du cours : non-assistance simple = 5 ans + 75 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-assistance — Peines aggravées',
    question:
        'Pour la non-assistance aggravée (223-6 al.3), les peines principales indiquées sont :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Le tableau du cours : aggravée = 7 ans + 100 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-obstacle — Exclusion suicide',
    question:
        'Le non-obstacle (223-6 al.1) peut-il sanctionner l’abstention d’empêcher un suicide ?',
    options: [
      'Oui, toujours',
      'Non, car le suicide n’est pas un crime/délit visé',
      'Oui, seulement si la victime est mineure',
    ],
    answer: 'Non, car le suicide n’est pas un crime/délit visé',
    explanation:
        'Le cours : pas d’application au suicide, qui ne constitue pas un crime/délit contre l’intégrité au sens de l’incrimination.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-obstacle — Action immédiate',
    question:
        'Le non-obstacle réprime l’abstention de la personne qui pouvait empêcher l’infraction par :',
    options: [
      'Une action immédiate',
      'Une action future et incertaine',
      'Un dépôt de plainte ultérieur uniquement',
    ],
    answer: 'Une action immédiate',
    explanation:
        'Le cours : proximité temporelle ; possibilité d’empêcher par action immédiate, sans risque.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-obstacle — Forme de l’action',
    question: 'Pour faire obstacle (223-6 al.1), l’action exigée :',
    options: [
      'Doit forcément être physique',
      'Peut consister à prévenir les autorités si c’est le meilleur moyen',
      'Doit toujours être une dissuasion verbale',
    ],
    answer:
        'Peut consister à prévenir les autorités si c’est le meilleur moyen',
    explanation:
        'Le cours : formes non définies ; appel à tiers/autorités possible si meilleur moyen, sans risque.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-obstacle — Absence de risque',
    question: 'Le non-obstacle n’est punissable que si l’action omise était :',
    options: [
      'Sans risque pour soi ou pour les tiers',
      'Toujours risquée',
      'Sans risque uniquement pour soi, peu importe les tiers',
    ],
    answer: 'Sans risque pour soi ou pour les tiers',
    explanation:
        'Le cours : condition explicite “sans risque pour lui ou pour les tiers”.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-obstacle — Élément moral',
    question: 'L’élément moral du non-obstacle suppose notamment :',
    options: [
      'Ignorer l’imminence de l’infraction',
      'Conscience de l’imminence et volonté de ne pas empêcher',
      'Intention de voler',
    ],
    answer: 'Conscience de l’imminence et volonté de ne pas empêcher',
    explanation:
        'Le cours : pas d’abstention volontaire si ignorance ; volonté coupable si abstention en sachant pouvoir empêcher.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui — Source de l’obligation',
    question:
        'L’obligation particulière de prudence/sécurité (223-1) doit être imposée par :',
    options: [
      'La loi ou le règlement',
      'Un règlement intérieur d’entreprise uniquement',
      'Une simple recommandation',
    ],
    answer: 'La loi ou le règlement',
    explanation:
        'Le cours : condition de source textuelle ; loi ou règlement (au sens d’actes généraux et impersonnels).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui — Notion de règlement',
    question: 'Au sens du cours (223-1), sont retenus comme “règlement” :',
    options: [
      'Les actes administratifs généraux et impersonnels',
      'Tout document interne (règlement intérieur)',
      'Tout ordre oral d’un supérieur',
    ],
    answer: 'Les actes administratifs généraux et impersonnels',
    explanation:
        'Le cours : seuls actes administratifs à caractère général et impersonnel (exclusion règlement intérieur, etc.).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui — Obligation “particulière”',
    question: 'Une obligation “particulière” (223-1) correspond plutôt à :',
    options: [
      'Des règles générales de manœuvre',
      'Des règles objectives précises, claires, ne laissant pas de place à l’interprétation subjective',
      'Des usages locaux',
    ],
    answer:
        'Des règles objectives précises, claires, ne laissant pas de place à l’interprétation subjective',
    explanation:
        'Le cours : obligation particulière = règles précises/cla(i)res, sans part d’interprétation subjective.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui — Gravité du risque',
    question: 'Le risque exigé par l’article 223-1 doit être :',
    options: [
      'Un risque léger (ex : petite contusion)',
      'Un risque immédiat de mort ou de blessures graves (mutilation/infirmité permanente)',
      'Un risque purement économique',
    ],
    answer:
        'Un risque immédiat de mort ou de blessures graves (mutilation/infirmité permanente)',
    explanation:
        'Le cours : seules mises en danger les plus graves (mort / mutilation / infirmité permanente).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui — Lien de causalité',
    question: 'Pour 223-1, le lien entre la violation et le risque doit être :',
    options: [
      'Indirect et hypothétique',
      'Direct et immédiat',
      'Sans importance',
    ],
    answer: 'Direct et immédiat',
    explanation:
        'Le cours : la violation doit être la cause directe et immédiate du risque.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui — Peines',
    question: 'Les peines principales pour 223-1 (personnes physiques) sont :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation: 'Le cours : 223-1 = 1 an + 15 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui — Circonstances aggravantes',
    question: 'Le cours indique, pour 223-1, des circonstances aggravantes :',
    options: [
      'Oui, plusieurs',
      'Non, aucune',
      'Uniquement si la victime est mineure',
    ],
    answer: 'Non, aucune',
    explanation: 'Le cours : “Aucune” circonstance aggravante mentionnée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Délaissement — Élément moral',
    question: 'L’élément moral du délaissement (223-3) est :',
    options: [
      'La volonté d’abandonner définitivement la victime',
      'Une simple imprudence',
      'L’intention de voler',
    ],
    answer: 'La volonté d’abandonner définitivement la victime',
    explanation:
        'Le cours : comportement intentionnel consistant en la volonté d’abandonner définitivement la victime.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Délaissement — Tentative',
    question: 'Selon le cours, pour le délaissement :',
    options: [
      'La tentative est toujours punissable en délit',
      'La tentative est punissable en matière criminelle (conséquences graves), pas pour la forme délictuelle',
      'La tentative n’existe jamais',
    ],
    answer:
        'La tentative est punissable en matière criminelle (conséquences graves), pas pour la forme délictuelle',
    explanation:
        'Le cours : tentative non pour 223-3 (délit) ; mais en matière criminelle (223-4), la tentative est punissable.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Délaissement — Peines (simple)',
    question:
        'Pour le délaissement simple (223-3), les peines principales sont :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Le cours : 223-3 = 5 ans + 75 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse — Nature de l’abus',
    question:
        'Selon le cours, l’abus frauduleux (223-15-2) peut consister notamment en :',
    options: [
      'Manœuvres grossières, mensonge, ou pressions',
      'Une simple maladresse sans intention',
      'Une agression physique obligatoire',
    ],
    answer: 'Manœuvres grossières, mensonge, ou pressions',
    explanation:
        'Le cours : l’abus n’est pas défini, peut être manœuvres, simple mensonge, pressions suscitant la crainte.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse — “Conduire”',
    question:
        'Le terme “conduire” la victime à un acte/abstention (223-15-2) signifie :',
    options: [
      'Contraindre nécessairement',
      'N’implique pas forcément contraindre',
      'Obliger par violence uniquement',
    ],
    answer: 'N’implique pas forcément contraindre',
    explanation:
        'Le cours : la Cour de cassation a précisé que “conduire” ne voulait pas dire contraindre.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse — Minorité',
    question:
        'Pour une victime mineure, la seule minorité suffit-elle à établir l’état d’ignorance/faiblesse ?',
    options: [
      'Oui, toujours',
      'Non, d’autres critères peuvent être pris en compte (jeune âge, situation familiale, etc.)',
      'Oui, uniquement si le mineur a plus de 15 ans',
    ],
    answer:
        'Non, d’autres critères peuvent être pris en compte (jeune âge, situation familiale, etc.)',
    explanation:
        'Le cours : la seule minorité ne suffit pas, d’autres critères doivent être appréciés.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse — Préjudice',
    question: 'L’acte ou l’abstention doit être :',
    options: [
      'Sans conséquence',
      'Gravement préjudiciable à la victime',
      'Toujours uniquement patrimonial',
    ],
    answer: 'Gravement préjudiciable à la victime',
    explanation:
        'Le cours : l’acte/abstention doit être gravement préjudiciable (patrimoine, santé, vie familiale, etc.).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse — Aggravation numérique',
    question:
        'Le cours prévoit une aggravation lorsque l’infraction est commise :',
    options: [
      'Par l’utilisation d’un service de communication au public en ligne ou d’un support numérique/électronique',
      'Uniquement en face à face',
      'Uniquement dans un lieu public',
    ],
    answer:
        'Par l’utilisation d’un service de communication au public en ligne ou d’un support numérique/électronique',
    explanation:
        'Le cours : aggravation prévue à l’alinéa 2 (en ligne / support numérique).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse — Aggravation bande organisée',
    question:
        'L’abus de faiblesse est aggravé lorsque l’infraction est commise :',
    options: ['En bande organisée', 'Par un mineur', 'Sans aucun écrit'],
    answer: 'En bande organisée',
    explanation:
        'Le cours : aggravation prévue à l’alinéa 3 (bande organisée).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse — Peines (simple)',
    question:
        'Selon le cours, l’abus de faiblesse simple (223-15-2 al.1) est puni de :',
    options: [
      '3 ans d’emprisonnement et 375 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 375 000 € d’amende',
    explanation: 'Le tableau du cours : simple = 3 ans + 375 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse — Peines (aggravation numérique)',
    question:
        'Selon le cours, l’abus de faiblesse aggravé par usage d’un service en ligne/support numérique (al.2) est puni de :',
    options: [
      '5 ans d’emprisonnement et 750 000 € d’amende',
      '3 ans d’emprisonnement et 375 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 750 000 € d’amende',
    explanation: 'Le tableau du cours : aggravation al.2 = 5 ans + 750 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse — Peines (bande organisée)',
    question:
        'Selon le cours, l’abus de faiblesse en bande organisée (al.3) est puni de :',
    options: [
      '7 ans d’emprisonnement et 1 000 000 € d’amende',
      '5 ans d’emprisonnement et 750 000 € d’amende',
      '3 ans d’emprisonnement et 375 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 1 000 000 € d’amende',
    explanation: 'Le tableau du cours : bande organisée = 7 ans + 1 000 000 €.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse — Tentative/complicité',
    question: 'Pour 223-15-2, le cours indique :',
    options: [
      'Tentative : oui / Complicité : non',
      'Tentative : non / Complicité : oui',
      'Tentative : oui / Complicité : oui',
    ],
    answer: 'Tentative : non / Complicité : oui',
    explanation: 'Le cours : tentative non ; complicité oui (121-6/121-7).',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // DIFFICILE (raisonnement / cas-limites / jurisprudence / articulations)
  // =========================================================
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Auteur/tiers',
    question:
        'Le texte (223-1-1) admet que la personne “identifiée/localisée” par les informations diffusées peut être :',
    options: [
      'Uniquement la personne visée à titre principal',
      'Une personne distincte de celle visée à titre principal',
      'Seulement un membre de la famille',
    ],
    answer: 'Une personne distincte de celle visée à titre principal',
    explanation:
        'Le cours : “Il peut s’agir d’une personne distincte de celle visée à titre principal par la divulgation.”',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Notion de risque',
    question: 'Pour 223-1-1, le risque exigé est :',
    options: [
      'Un risque hypothétique, sans exigence de directeté',
      'Un risque direct d’atteinte à la personne ou aux biens',
      'Un risque uniquement patrimonial',
    ],
    answer: 'Un risque direct d’atteinte à la personne ou aux biens',
    explanation:
        'Le cours exige un risque direct d’atteinte à la personne ou aux biens (victime ou famille).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — “Ne pouvait ignorer”',
    question: 'L’infraction 223-1-1 exige que l’auteur :',
    options: [
      'Prouve qu’il ignorait totalement le risque',
      'Ne pouvait ignorer le risque direct d’atteinte',
      'Soit certain que l’atteinte se réalisera',
    ],
    answer: 'Ne pouvait ignorer le risque direct d’atteinte',
    explanation:
        'Le cours : “risque direct … que l’auteur ne pouvait ignorer”.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion — Jurisprudence 11 février 2025',
    question:
        'Selon l’exemple jurisprudentiel (Cass. crim., 11 fév. 2025), la diffusion concomitante de la qualité de fonctionnaire de police, dans un contexte visant les forces de police, peut :',
    options: [
      'Ne jamais exposer la personne ou sa famille à un risque',
      'Exposer la personne ou sa famille à un risque direct d’atteinte',
      'Être automatiquement justifiée par la liberté d’expression',
    ],
    answer: 'Exposer la personne ou sa famille à un risque direct d’atteinte',
    explanation:
        'Le cours cite cet arrêt : diffusion de la qualité de policier dans un contexte hostile pouvant exposer à un risque direct.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-assistance — Péril “constaté”',
    question:
        'Le cours insiste que le péril doit être “impérativement et expressément constaté” : cela signifie surtout que :',
    options: [
      'On peut se contenter d’une impression vague',
      'Le péril ne doit pas être simplement présumé',
      'Le péril peut être futur et hypothétique',
    ],
    answer: 'Le péril ne doit pas être simplement présumé',
    explanation:
        'Le cours : péril caractérisé, pas seulement présumé ; risques éventuels/hypothétiques exclus.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-assistance — Auteur du péril',
    question: 'En non-assistance, le fait que l’auteur du péril soit :',
    options: [
      'Un tiers uniquement',
      'Le débiteur de l’obligation de secours, ou même la victime elle-même',
      'Une personne publique seulement',
    ],
    answer:
        'Le débiteur de l’obligation de secours, ou même la victime elle-même',
    explanation:
        'Le cours : l’auteur du péril est indifférent (tiers, débiteur, voire la victime).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-assistance — Cumul avec violences',
    question:
        'Le cours indique que non-assistance et violences volontaires peuvent :',
    options: [
      'Ne jamais se cumuler',
      'Se cumuler si elles se situent dans des temps d’action différents',
      'Se cumuler uniquement si la victime est mineure',
    ],
    answer: 'Se cumuler si elles se situent dans des temps d’action différents',
    explanation:
        'Le cours : cumul possible si deux temps d’action différents, protection de valeurs sociales différentes.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-assistance — Appel à autrui insuffisant',
    question:
        'Selon le cours, l’appel à autrui (provoquer un secours) peut ne pas suffire si :',
    options: [
      'Une action personnelle aurait été manifestement plus efficace',
      'La personne n’a pas de téléphone',
      'La victime refuse tout secours',
    ],
    answer: 'Une action personnelle aurait été manifestement plus efficace',
    explanation:
        'Le cours : l’appel à autrui n’acquitte pas si l’action personnelle était manifestement plus efficace.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-obstacle — Temporalité',
    question:
        'Le cours admet que l’obligation d’agir pour le non-obstacle peut viser :',
    options: [
      'Seulement les infractions déjà terminées',
      'Des infractions futures, mais certaines et imminentes',
      'Uniquement les contraventions',
    ],
    answer: 'Des infractions futures, mais certaines et imminentes',
    explanation:
        'Le cours : obligation d’agir dès la certitude de l’imminence (même si pas encore en cours).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-obstacle — Dissuasion verbale',
    question:
        'Selon l’exemple du cours, une simple protestation/dissuasion verbale est :',
    options: [
      'Généralement suffisante',
      'Généralement insuffisante',
      'Toujours exigée',
    ],
    answer: 'Généralement insuffisante',
    explanation:
        'Le cours : l’action doit être apte à empêcher ; la dissuasion verbale est souvent jugée insuffisante.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui — Cause “exclusive”',
    question: 'Le cours précise que le comportement dangereux doit être :',
    options: [
      'Une des causes possibles du risque',
      'La cause directe, immédiate, exclusive et unique du risque',
      'Sans lien avec le risque',
    ],
    answer: 'La cause directe, immédiate, exclusive et unique du risque',
    explanation:
        'Le cours : lien direct ; comportement dangereux = seule cause du risque (cause directe et immédiate).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui — Vitesse excessive',
    question: 'Selon le cours, la vitesse excessive seule :',
    options: [
      'Suffit toujours à caractériser 223-1',
      'Ne suffit pas : il faut un comportement exposant autrui à un risque immédiat grave en plus',
      'Est toujours une tentative d’homicide',
    ],
    answer:
        'Ne suffit pas : il faut un comportement exposant autrui à un risque immédiat grave en plus',
    explanation:
        'Le cours : dépassement vitesse autorisée seul insuffisant ; un comportement exposant à un risque immédiat grave doit s’ajouter.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui — Élément intentionnel',
    question: 'Pour 223-1, l’intention coupable porte principalement sur :',
    options: [
      'La volonté de blesser autrui',
      'La volonté de violer la règle de prudence/sécurité (faute délibérée)',
      'La volonté de créer un risque économique',
    ],
    answer:
        'La volonté de violer la règle de prudence/sécurité (faute délibérée)',
    explanation:
        'Le cours : intention = violer la règle ; pas nécessaire d’avoir une vision précise des risques réellement encourus.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui — Complicité',
    question:
        'Le cours rappelle que, même si 223-1 appartient aux infractions non intentionnelles, la complicité :',
    options: [
      'Est exclue par principe',
      'Peut être retenue (ex : instigation)',
      'N’existe que pour les crimes',
    ],
    answer: 'Peut être retenue (ex : instigation)',
    explanation:
        'Le cours : la mise en danger d’autrui n’exclut pas la complicité (exemple : passager ordonnant de franchir un feu).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Délaissement — Lieu indifférent',
    question: 'Pour le délaissement, le lieu :',
    options: [
      'Doit être un lieu public',
      'Est indifférent (“quel que soit le lieu”)',
      'Doit être le domicile de la victime',
    ],
    answer: 'Est indifférent (“quel que soit le lieu”)',
    explanation:
        'Le cours : le texte punit le délaissement quel que soit le lieu où il se produit.',
    difficulty: 'Difficile',
  ),
  // =========================================================
  // FACILE (suite)
  // =========================================================
  const QuizQuestion(
    category: 'Mise en danger par diffusion (223-1-1) — Actes visés',
    question:
        'Quels verbes décrivent l’acte matériel visé par l’article 223-1-1 ?',
    options: [
      'Révéler, diffuser ou transmettre',
      'Voler, receler ou détruire',
      'Dissimuler, blanchir ou falsifier',
    ],
    answer: 'Révéler, diffuser ou transmettre',
    explanation:
        'Le cours vise la révélation, diffusion ou transmission, par quelque moyen que ce soit.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion (223-1-1) — Moyen',
    question:
        'La révélation/diffusion/transmission (223-1-1) peut être réalisée :',
    options: [
      'Par quelque moyen que ce soit',
      'Uniquement en communication au public en ligne',
      'Uniquement par voie de presse écrite',
    ],
    answer: 'Par quelque moyen que ce soit',
    explanation:
        'Le cours précise “par quelque moyen que ce soit” (réseaux sociaux, SMS, courriels…).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion (223-1-1) — Réseaux sociaux',
    question: 'Le cours précise que l’infraction vise particulièrement :',
    options: [
      'Les réseaux sociaux',
      'Les actes notariés',
      'Les échanges en audience publique',
    ],
    answer: 'Les réseaux sociaux',
    explanation:
        'Le cours indique que l’infraction vise particulièrement les réseaux sociaux.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion (223-1-1) — Publicité',
    question: 'L’acte de diffusion doit être public pour être incriminé ?',
    options: [
      'Oui',
      'Non',
      'Uniquement si plus de 100 personnes reçoivent le message',
    ],
    answer: 'Non',
    explanation:
        'Le cours : l’incrimination n’exige pas que la diffusion soit publique.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion (223-1-1) — SMS/Courriel',
    question:
        'Des moyens confidentiels (SMS/courriel) peuvent-ils tomber sous 223-1-1 ?',
    options: ['Oui', 'Non', 'Uniquement si c’est un message vocal'],
    answer: 'Oui',
    explanation:
        'Le cours : des moyens de transmission plus confidentiels comme SMS/courriels sont visés.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion (223-1-1) — Éléments exclus',
    question:
        'Parmi ces éléments, lequel seul ne suffit pas à caractériser l’infraction 223-1-1 ?',
    options: [
      'La simple réception/captation/détention de l’information',
      'La transmission d’une adresse pour localiser la victime',
      'La diffusion d’un numéro pour l’exposer à un risque direct',
    ],
    answer: 'La simple réception/captation/détention de l’information',
    explanation:
        'Le cours : simple réception/captation/détention n’est pas répréhensible.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion (223-1-1) — Objet',
    question: 'Les informations doivent être relatives à la vie :',
    options: [
      'Privée, familiale ou professionnelle',
      'Politique uniquement',
      'Sportive uniquement',
    ],
    answer: 'Privée, familiale ou professionnelle',
    explanation: 'Le cours liste la vie privée, familiale ou professionnelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion (223-1-1) — Exemples',
    question: 'Le cours cite comme exemples d’informations visées :',
    options: [
      'Numéro de téléphone et adresse',
      'Numéro de plaque d’immatriculation uniquement',
      'Numéro de TVA uniquement',
    ],
    answer: 'Numéro de téléphone et adresse',
    explanation: 'Le cours donne ces exemples (téléphone, adresse).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-assistance (223-6 al.2) — Définition',
    question: 'La non-assistance à personne en péril consiste à :',
    options: [
      'S’abstenir volontairement de porter assistance à une personne en péril',
      'Diffuser des informations personnelles',
      'Abandonner une personne vulnérable',
    ],
    answer:
        'S’abstenir volontairement de porter assistance à une personne en péril',
    explanation:
        'Le cours : s’abstenir volontairement d’aider sans risque pour soi/tiers.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-assistance (223-6 al.2) — Modes',
    question: 'L’assistance peut être apportée :',
    options: [
      'Par action personnelle ou en provoquant un secours',
      'Uniquement en appelant la famille',
      'Uniquement en faisant un signalement écrit',
    ],
    answer: 'Par action personnelle ou en provoquant un secours',
    explanation:
        'Le cours : soit par action personnelle, soit en provoquant un secours.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-assistance (223-6 al.2) — Risque',
    question:
        'L’obligation d’assistance existe seulement si l’aide peut être apportée :',
    options: [
      'Sans risque pour soi ou pour les tiers',
      'Même avec un risque grave pour soi',
      'Uniquement si l’on est professionnel de santé',
    ],
    answer: 'Sans risque pour soi ou pour les tiers',
    explanation:
        'Le cours : la loi n’impose pas l’héroïsme ; assistance sans risque.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Non-obstacle (223-6 al.1) — Définition',
    question: 'Le non-obstacle sanctionne le fait de :',
    options: [
      'S’abstenir volontairement d’empêcher un crime/délit contre l’intégrité corporelle',
      'Ne pas porter secours à une personne en péril',
      'Exposer autrui à un risque par violation d’une règle',
    ],
    answer:
        'S’abstenir volontairement d’empêcher un crime/délit contre l’intégrité corporelle',
    explanation:
        'Le cours : 223-6 al.1 vise l’abstention d’empêcher un crime/délit contre l’intégrité corporelle.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui (223-1) — Définition',
    question:
        'Le risque causé à autrui consiste notamment à exposer directement autrui à :',
    options: [
      'Un risque immédiat de mort ou de blessures graves',
      'Un simple risque financier',
      'Un risque de contravention',
    ],
    answer: 'Un risque immédiat de mort ou de blessures graves',
    explanation:
        'Le cours : risque immédiat de mort ou blessures graves (mutilation/infirmité permanente).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Délaissement (223-3) — Définition',
    question: 'Le délaissement vise le fait :',
    options: [
      'D’abandonner une personne qui ne peut se protéger en raison de son âge ou état',
      'De ne pas empêcher une infraction',
      'De diffuser des informations personnelles',
    ],
    answer:
        'D’abandonner une personne qui ne peut se protéger en raison de son âge ou état',
    explanation:
        'Le cours : délaissement = abandon d’une personne hors d’état de se protéger.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse (223-15-2) — Définition',
    question:
        'L’abus de faiblesse consiste à exploiter l’état d’ignorance/faiblesse pour conduire la victime à :',
    options: [
      'Un acte ou une abstention gravement préjudiciable',
      'Un simple désaccord',
      'Un acte neutre sans conséquence',
    ],
    answer: 'Un acte ou une abstention gravement préjudiciable',
    explanation:
        'Le cours : conduire à un acte/abstention gravement préjudiciable.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // MOYENNE (suite)
  // =========================================================
  const QuizQuestion(
    category: 'Mise en danger par diffusion (223-1-1) — Élément moral',
    question: 'L’élément moral de 223-1-1 est caractérisé par :',
    options: [
      'L’intention de nuire gravement à autrui',
      'La simple négligence',
      'La légitime défense',
    ],
    answer: 'L’intention de nuire gravement à autrui',
    explanation:
        'Le cours : intention manifeste qu’il soit porté gravement atteinte à la personne/proches/biens.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion (223-1-1) — Faisceau d’indices',
    question: 'Selon le cours, l’intention de nuire peut être caractérisée :',
    options: [
      'Par des propos explicites ou un faisceau d’indices',
      'Uniquement par un aveu',
      'Uniquement par une plainte',
    ],
    answer: 'Par des propos explicites ou un faisceau d’indices',
    explanation:
        'Le cours : soit intention clairement exprimée, soit déduite d’un faisceau d’indices.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion (223-1-1) — Personnes visées',
    question: 'L’incrimination vise :',
    options: [
      'Toute personne',
      'Uniquement les particuliers',
      'Uniquement les agents publics',
    ],
    answer: 'Toute personne',
    explanation:
        'Le cours : vise toute personne (y compris journaliste sous condition d’intention).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion (223-1-1) — Aggravation (qualités)',
    question:
        'Parmi ces qualités, laquelle figure dans les aggravations de l’al.2 ?',
    options: [
      'Candidat à un mandat électif public pendant la campagne',
      'Supporter d’un club sportif',
      'Commerçant',
    ],
    answer: 'Candidat à un mandat électif public pendant la campagne',
    explanation:
        'Le cours : al.2 vise notamment le candidat à un mandat électif public pendant la campagne.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category:
        'Mise en danger par diffusion (223-1-1) — Aggravation (journaliste)',
    question:
        'L’article 223-1-1 prévoit aussi une aggravation lorsque la victime est :',
    options: [
      'Un journaliste (au sens de la loi du 29 juillet 1881)',
      'Un influenceur',
      'Un chef d’entreprise',
    ],
    answer: 'Un journaliste (au sens de la loi du 29 juillet 1881)',
    explanation:
        'Le cours : journaliste visé au sens du 2e alinéa de l’article 2 de la loi du 29 juillet 1881.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion (223-1-1) — Aggravation (domicile)',
    question:
        'L’aggravation vise aussi “toute autre personne vivant habituellement au domicile” de la personne protégée :',
    options: [
      'Oui, si c’est en raison des fonctions exercées par la personne protégée',
      'Oui, sans condition',
      'Non, jamais',
    ],
    answer:
        'Oui, si c’est en raison des fonctions exercées par la personne protégée',
    explanation:
        'Le cours : aggravation si ciblage du conjoint/ascendant/descendant/autre vivant au domicile, en raison des fonctions.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion (223-1-1) — Responsabilité PM',
    question: 'Pour 223-1-1, la responsabilité pénale des personnes morales :',
    options: [
      'S’applique selon l’article 121-2 du Code pénal',
      'Est exclue',
      'S’applique uniquement aux associations',
    ],
    answer: 'S’applique selon l’article 121-2 du Code pénal',
    explanation:
        'Le cours : responsabilité des personnes morales selon le principe général de l’art. 121-2.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-assistance (223-6) — Péril présent',
    question: 'Le péril suppose une situation :',
    options: [
      'Présente de danger (pas de risques hypothétiques)',
      'Uniquement future',
      'Uniquement économique',
    ],
    answer: 'Présente de danger (pas de risques hypothétiques)',
    explanation:
        'Le cours : péril = danger présent ; risques éventuels ou hypothétiques non retenus.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-assistance (223-6) — Obligation d’intervenir',
    question: 'Le délit est constitué lorsque la personne :',
    options: [
      'A connu un péril immédiat et s’est volontairement refusée à intervenir',
      'A ignoré le péril',
      'A été empêchée matériellement d’agir',
    ],
    answer:
        'A connu un péril immédiat et s’est volontairement refusée à intervenir',
    explanation:
        'Le cours (Cass. crim., 25 juin 1964) : connaissance péril immédiat et refus volontaire d’intervenir.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-assistance (223-6) — Efficacité',
    question: 'L’assistance doit-elle réussir pour éviter l’infraction ?',
    options: [
      'Non, l’obligation est une obligation de moyens',
      'Oui, sinon il y a infraction',
      'Oui, uniquement pour les professionnels',
    ],
    answer: 'Non, l’obligation est une obligation de moyens',
    explanation:
        'Le cours : peu importe que l’assistance soit efficace ; obligation de moyens.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-assistance (223-6) — Appel + action',
    question: 'Le cours admet que l’on peut devoir utiliser :',
    options: [
      'Un seul mode au choix, jamais cumulatif',
      'Les deux modes (action personnelle + provoquer un secours) si nécessaire',
      'Uniquement provoquer un secours',
    ],
    answer:
        'Les deux modes (action personnelle + provoquer un secours) si nécessaire',
    explanation:
        'Le cours : obligation d’intervenir par le mode que la nécessité commande, et même cumulativement si besoin.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-obstacle (223-6 al.1) — Domaine',
    question: 'Le non-obstacle exclut notamment :',
    options: [
      'Les délits contre les biens',
      'Les crimes contre l’intégrité corporelle',
      'Les délits contre l’intégrité corporelle',
    ],
    answer: 'Les délits contre les biens',
    explanation:
        'Le cours : l’incrimination n’inclut pas les délits contre les biens ou contre la Nation/État/paix publique.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Non-obstacle (223-6 al.1) — Résultat',
    question:
        'Pour le non-obstacle, il est exigé que l’action omise ait réussi ?',
    options: [
      'Oui, sinon pas d’infraction',
      'Non, seule l’abstention est punie si l’action pouvait empêcher sans risque',
      'Oui, uniquement si c’est un crime',
    ],
    answer:
        'Non, seule l’abstention est punie si l’action pouvait empêcher sans risque',
    explanation:
        'Le cours : pas exigé que l’action ait réussi ; obligation d’agir si moyen d’empêcher sans risque.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui (223-1) — Règlement intérieur',
    question:
        'Un règlement intérieur d’entreprise est-il un “règlement” au sens de 223-1 ?',
    options: ['Non', 'Oui', 'Oui seulement s’il est affiché'],
    answer: 'Non',
    explanation:
        'Le cours : sont exclus les règlements intérieurs d’entreprise.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Délaissement (223-3) — Mineurs de 15 ans',
    question: 'Les mineurs de 15 ans relèvent du délaissement 223-3 ?',
    options: [
      'Non, texte spécifique (227-1)',
      'Oui',
      'Oui uniquement si le mineur est malade',
    ],
    answer: 'Non, texte spécifique (227-1)',
    explanation: 'Le cours : mineurs de 15 ans exclus car texte spécifique.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse (223-15-2) — “Conduire”',
    question: 'Selon le cours, “conduire” la victime à un acte signifie :',
    options: [
      'Contraindre obligatoirement',
      'Pas nécessairement contraindre',
      'Forcer physiquement',
    ],
    answer: 'Pas nécessairement contraindre',
    explanation:
        'Le cours : “conduire” ne veut pas dire contraindre (Cass. crim.).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse (223-15-2) — Vulnérabilité',
    question: 'La vulnérabilité peut être due notamment à :',
    options: [
      'Âge, maladie, infirmité, déficience, état de grossesse',
      'Profession',
      'Nationalité',
    ],
    answer: 'Âge, maladie, infirmité, déficience, état de grossesse',
    explanation: 'Le cours liste ces causes de vulnérabilité.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // DIFFICILE (suite)
  // =========================================================
  const QuizQuestion(
    category: 'Mise en danger par diffusion (223-1-1) — Non-public',
    question:
        'Un message privé envoyé à une seule personne contenant une adresse peut relever de 223-1-1 si :',
    options: [
      'La transmission vise à exposer à un risque direct d’atteinte que l’auteur ne pouvait ignorer',
      'Le message est public',
      'La victime est forcément une personnalité',
    ],
    answer:
        'La transmission vise à exposer à un risque direct d’atteinte que l’auteur ne pouvait ignorer',
    explanation:
        'Le cours : pas besoin de publicité ; condition = finalité d’exposition + risque direct + auteur ne pouvait ignorer + intention de nuire gravement.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Mise en danger par diffusion (223-1-1) — Personne distincte',
    question:
        'Pour 223-1-1, la personne identifiée/localisée peut être distincte de la cible principale : conséquence pratique ?',
    options: [
      'Le texte peut viser un tiers “révélé” au passage',
      'Le texte ne vise que la cible principale',
      'Le texte vise seulement l’auteur',
    ],
    answer: 'Le texte peut viser un tiers “révélé” au passage',
    explanation:
        'Le cours : la personne identifiée/localisée peut être distincte de la personne visée à titre principal.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-assistance (223-6) — Péril et dépistage',
    question:
        'Le cours illustre que l’absence de dépistage VIH n’est pas non-assistance lorsque :',
    options: [
      'Le caractère imminent du péril n’est pas établi',
      'La victime est mineure',
      'Les médecins ont appelé les secours',
    ],
    answer: 'Le caractère imminent du péril n’est pas établi',
    explanation:
        'Exemple jurisprudentiel du cours : péril imminent non établi.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-assistance (223-6) — Deux temps d’action',
    question:
        'Pourquoi violences volontaires + non-assistance peuvent se cumuler ?',
    options: [
      'Parce qu’elles protègent deux valeurs sociales différentes et se situent dans deux temps d’action',
      'Parce que la non-assistance est une contravention',
      'Parce que l’une efface l’autre',
    ],
    answer:
        'Parce qu’elles protègent deux valeurs sociales différentes et se situent dans deux temps d’action',
    explanation:
        'Le cours : cumul si deux temps distincts et valeurs sociales différentes.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Non-obstacle (223-6 al.1) — Crainte de représailles',
    question:
        'La crainte de représailles futures constitue-t-elle un “risque” exonérant l’auteur du non-obstacle ?',
    options: [
      'Non, si le risque est futur et tient à une crainte de représailles',
      'Oui, toujours',
      'Oui, uniquement en matière criminelle',
    ],
    answer:
        'Non, si le risque est futur et tient à une crainte de représailles',
    explanation:
        'Le cours : pas de risque justificatif si risque futur lié à crainte de représailles.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui (223-1) — Obligation particulière',
    question:
        'Une simple “règle générale de manœuvre” sur un aérodrome est-elle une obligation particulière (223-1) ?',
    options: [
      'Non, ce sont des règles générales et non des exigences particulières',
      'Oui, toujours',
      'Oui seulement si un accident a eu lieu',
    ],
    answer:
        'Non, ce sont des règles générales et non des exigences particulières',
    explanation:
        'Le cours rapporte un exemple : règles générales de circulation/manœuvre ≠ obligation particulière.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Risque causé à autrui (223-1) — Vitesse (nuance)',
    question:
        'Selon le cours, rouler trop vite ne suffit pas toujours pour 223-1 car :',
    options: [
      'Il faut en plus un comportement exposant autrui à un risque immédiat grave',
      'La vitesse n’est jamais sanctionnée',
      'Le risque doit être uniquement financier',
    ],
    answer:
        'Il faut en plus un comportement exposant autrui à un risque immédiat grave',
    explanation:
        'Le cours : vitesse excessive seule insuffisante ; il faut un comportement ajoutant un risque immédiat de mort/blessures graves.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Délaissement (223-3 / 223-4) — Tentative',
    question:
        'Pourquoi la tentative est-elle retenue surtout quand on bascule en 223-4 ?',
    options: [
      'Parce qu’en matière criminelle, la tentative est toujours punissable',
      'Parce que 223-3 prévoit explicitement la tentative',
      'Parce que la tentative est toujours exclue',
    ],
    answer:
        'Parce qu’en matière criminelle, la tentative est toujours punissable',
    explanation:
        'Le cours : pas de tentative pour le délit 223-3 ; mais en matière criminelle (223-4), la tentative est punissable.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse (223-15-2) — Consentement',
    question:
        'Le cours insiste : le consentement de la personne vulnérable est apprécié :',
    options: [
      'Au moment où l’acte est passé (il doit être libre et éclairé)',
      'Uniquement au moment du premier contact',
      'Uniquement après coup',
    ],
    answer: 'Au moment où l’acte est passé (il doit être libre et éclairé)',
    explanation:
        'Le cours : consentement doit être libre/éclairé au moment de l’acte ; sinon il n’est pas valable.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse (223-15-2) — Préjudice potentiel',
    question: 'Le préjudice exigé doit-il être déjà réalisé ?',
    options: [
      'Non, il peut être seulement potentiel',
      'Oui, toujours',
      'Oui, uniquement si la victime est majeure',
    ],
    answer: 'Non, il peut être seulement potentiel',
    explanation:
        'Le cours : la jurisprudence admet un préjudice seulement potentiel.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Délaissement — Gravité et qualification',
    question:
        'Selon le cours, si le délaissement entraîne la mort de la victime, on bascule :',
    options: [
      'Sur une contravention',
      'Sur une qualification criminelle (art. 223-4 al.2) avec 20 ans de réclusion',
      'Sur une simple amende',
    ],
    answer:
        'Sur une qualification criminelle (art. 223-4 al.2) avec 20 ans de réclusion',
    explanation:
        'Le cours : 223-4 al.2 = crime, 20 ans de réclusion lorsque le délaissement entraîne la mort.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Délaissement — Mutilation/infirmité permanente',
    question:
        'Si le délaissement entraîne une mutilation ou une infirmité permanente, le cours indique :',
    options: [
      'Aucune aggravation',
      'Art. 223-4 al.1 : 15 ans de réclusion',
      'Art. 223-3 : 1 an de prison',
    ],
    answer: 'Art. 223-4 al.1 : 15 ans de réclusion',
    explanation:
        'Le cours : premier degré (223-4 al.1) = 15 ans de réclusion en cas de mutilation/infirmité permanente.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse — Consentement',
    question:
        'Le cours insiste que le consentement de la personne vulnérable doit être :',
    options: [
      'Libre et éclairé au moment de l’acte, sinon il n’est pas valable',
      'Toujours valable s’il a été donné une fois',
      'Inutile à apprécier',
    ],
    answer: 'Libre et éclairé au moment de l’acte, sinon il n’est pas valable',
    explanation:
        'Le cours : consentement libre/éclairé au moment où l’acte est passé ; consentement du vulnérable n’est pas valable.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse — Vulnérabilité “apparente ou connue”',
    question:
        'Pour la vulnérabilité (hors minorité), le cours exige qu’elle soit :',
    options: [
      'Simplement supposée par les enquêteurs',
      'Apparente ou connue de l’auteur, et cette connaissance doit être démontrée',
      'Toujours présumée si la victime est âgée',
    ],
    answer:
        'Apparente ou connue de l’auteur, et cette connaissance doit être démontrée',
    explanation:
        'Le cours : vulnérabilité “apparente ou connue” ; la Cour de cassation exige que la connaissance soit démontrée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Abus de faiblesse — Préjudice potentiel',
    question: 'Le cours indique que le préjudice exigé peut être :',
    options: [
      'Uniquement déjà réalisé',
      'Potentiel (pas nécessairement déjà réalisé)',
      'Uniquement moral',
    ],
    answer: 'Potentiel (pas nécessairement déjà réalisé)',
    explanation:
        'Le cours : la jurisprudence n’exige pas que l’acte préjudiciable soit déjà réalisé ; il peut être potentiel.',
    difficulty: 'Difficile',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizMiseEnDangerPA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName = '/pa/crimes_personne/quiz/mise_en_danger';
  final String uid;
  final String email;

  const QuizMiseEnDangerPA({super.key, required this.uid, required this.email});

  @override
  State<QuizMiseEnDangerPA> createState() => _QuizMiseEnDangerPAState();
}

class _QuizMiseEnDangerPAState extends State<QuizMiseEnDangerPA>
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
  static const _introHiddenKey = 'intro_pa_mise_en_danger';
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
        ? questionGPMiseEnDangerEtAbstentions
        : questionGPMiseEnDangerEtAbstentions
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
            'mode': UserContextService.I.modeOrDefault,'module_name': 'Crimes & délits contre la personne',
            'quiz_name': 'Mise en danger de la personne',
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
      await _sb.from('quiz_mise_en_danger').insert({
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
      debugPrint('❌ quiz_mise_en_danger insert failed: $e');
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
      'source_file': 'pa_quiz_mise_en_danger',
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
                            icon: Icons.emergency_rounded,
                            title: 'Mise en danger',
                            description: 'Comprends l’infraction de mise en danger délibérée d’autrui : éléments constitutifs, distinction avec les infractions de résultat.',
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
