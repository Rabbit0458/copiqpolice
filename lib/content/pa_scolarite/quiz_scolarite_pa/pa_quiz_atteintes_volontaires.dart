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

final List<QuizQuestion> questionAtteinteVolontaire = [
  // =========================================================
  // VIOLENCES VOLONTAIRES — PRINCIPES (R. 624-1 / R. 625-1 / 222-11 / 222-7…)
  // =========================================================
  const QuizQuestion(
    category: 'Violences volontaires — Définition',
    question:
        'Les atteintes volontaires à l’intégrité physique et/ou psychique sont qualifiées :',
    options: ['De violences', 'D’atteintes involontaires', 'De destructions'],
    answer: 'De violences',
    explanation:
        'Le cours indique que les atteintes volontaires à l’intégrité physique et/ou psychique constituent des violences.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Violences volontaires — Textes',
    question:
        'Les violences contraventionnelles sont définies et réprimées par :',
    options: [
      'Les articles R. 624-1 et R. 625-1 du Code pénal',
      'L’article 221-6 du Code pénal',
      'L’article 222-20 du Code pénal',
    ],
    answer: 'Les articles R. 624-1 et R. 625-1 du Code pénal',
    explanation:
        'Le cours mentionne R. 624-1 et R. 625-1 CP pour les violences contraventionnelles.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Violences volontaires — Délit (fondement)',
    question: 'Les violences délictuelles sont définies et réprimées par :',
    options: [
      'L’article 222-11 du Code pénal',
      'L’article 222-19 du Code pénal',
      'L’article 450-1 du Code pénal',
    ],
    answer: 'L’article 222-11 du Code pénal',
    explanation:
        'Le cours précise que l’article 222-11 CP définit et réprime les violences délictuelles.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Violences volontaires — Élément matériel',
    question: 'L’élément matériel des violences volontaires repose sur :',
    options: [
      'Un acte positif',
      'Une abstention pure',
      'Une simple intention non matérialisée',
    ],
    answer: 'Un acte positif',
    explanation:
        'Le cours rappelle que les violences supposent une action positive : la simple abstention ne constitue pas une violence.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences volontaires — Contact',
    question: 'Les violences supposent nécessairement :',
    options: [
      'Pas forcément un contact physique direct (un moyen peut être utilisé)',
      'Toujours un contact direct main/corps',
      'Toujours une arme à feu',
    ],
    answer:
        'Pas forcément un contact physique direct (un moyen peut être utilisé)',
    explanation:
        'Le cours précise que le contact peut être indirect : arme, objet, morsure d’animal excité par l’auteur, etc.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences volontaires — Psychologiques',
    question: 'Selon le cours, des violences volontaires peuvent être :',
    options: [
      'Psychologiques, même sans atteinte physique',
      'Uniquement physiques',
      'Uniquement verbales sans choc',
    ],
    answer: 'Psychologiques, même sans atteinte physique',
    explanation:
        'Le cours rappelle la jurisprudence : un acte impressionnant vivement la victime et causant un choc émotif peut constituer une violence.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences volontaires — Victime',
    question: 'Les violences volontaires doivent être commises :',
    options: [
      'Sur une personne humaine vivante, distincte de l’auteur',
      'Sur un animal',
      'Sur un bien matériel uniquement',
    ],
    answer: 'Sur une personne humaine vivante, distincte de l’auteur',
    explanation:
        'Le cours précise : personne humaine, vivante, distincte de l’auteur.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Violences volontaires — Résultat',
    question: 'La réalité de l’atteinte (dommage) est notamment établie par :',
    options: [
      'Un certificat médical',
      'Une simple rumeur',
      'Un aveu de la victime uniquement',
    ],
    answer: 'Un certificat médical',
    explanation:
        'Le cours indique que la réalité de l’atteinte doit être établie, notamment par la production d’un certificat médical.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences volontaires — Élément moral',
    question: 'L’élément moral des violences volontaires suppose :',
    options: [
      'La conscience de commettre un acte affectant l’intégrité d’autrui',
      'L’absence totale de volonté',
      'Une faute d’imprudence simple',
    ],
    answer: 'La conscience de commettre un acte affectant l’intégrité d’autrui',
    explanation:
        'Le cours précise : violences consommées si elles sont intentionnelles (conscience qu’il en résultera un préjudice).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences volontaires — ITT',
    question:
        'Dans la logique du cours, la qualification/gravité des violences varie notamment selon :',
    options: [
      'Le résultat (ITT, mutilation/infirmité permanente, mort)',
      'La couleur du véhicule',
      'Le lieu de résidence de la victime',
    ],
    answer: 'Le résultat (ITT, mutilation/infirmité permanente, mort)',
    explanation:
        'Le cours structure les violences selon le résultat : ITT, mutilation/infirmité permanente, mort sans intention de la donner.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // VIOLENCES — CIRC. AGGRAVANTES (222-13 / 222-12 / 222-10 / 222-8)
  // =========================================================
  const QuizQuestion(
    category: 'Violences — Aggravation — Mineur',
    question:
        'Selon 222-13, commettre des violences (ITT ≤ 8 jours ou aucune) sur un mineur de 15 ans constitue :',
    options: [
      'Une circonstance aggravante (1er degré)',
      'Une excuse absolutoire',
      'Une simple contravention automatique',
    ],
    answer: 'Une circonstance aggravante (1er degré)',
    explanation:
        'Le cours liste “sur un mineur de 15 ans” parmi les circonstances du 1er degré de 222-13.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences — Aggravation — Vulnérabilité',
    question: 'La particulière vulnérabilité aggravante suppose qu’elle soit :',
    options: [
      'Apparente ou connue de l’auteur',
      'Toujours inconnue de l’auteur',
      'Uniquement liée au sexe',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation:
        'Le cours précise : vulnérabilité due à âge/maladie/infirmité/déficience/grossesse apparente ou connue.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences — Aggravation — Personne dépositaire',
    question:
        'Parmi les circonstances aggravantes du 1er degré (222-13), on trouve :',
    options: [
      'Violences sur une personne dépositaire de l’autorité publique dans l’exercice ou du fait de ses fonctions',
      'Un simple désaccord verbal',
      'Un retard de livraison',
    ],
    answer:
        'Violences sur une personne dépositaire de l’autorité publique dans l’exercice ou du fait de ses fonctions',
    explanation:
        'Le cours énumère la qualité de la victime (dépositaire de l’autorité publique, etc.) comme circonstance aggravante.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences — Aggravation — Réunion',
    question:
        '“Par plusieurs personnes agissant en qualité d’auteur ou de complice” correspond à :',
    options: [
      'Une circonstance aggravante (réunion)',
      'Une cause d’irresponsabilité',
      'Une tentative',
    ],
    answer: 'Une circonstance aggravante (réunion)',
    explanation:
        'Le cours liste la réunion (plusieurs personnes auteurs/complices) parmi les circonstances aggravantes.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences — Aggravation — Arme',
    question: 'L’usage ou la menace d’une arme est :',
    options: [
      'Une circonstance aggravante',
      'Toujours neutre',
      'Une excuse de provocation',
    ],
    answer: 'Une circonstance aggravante',
    explanation:
        'Le cours cite l’usage ou menace d’une arme parmi les circonstances aggravantes.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Violences — Aggravation — Visage dissimulé',
    question:
        'Selon le cours, “dissimuler volontairement en tout ou partie son visage” est :',
    options: [
      'Une circonstance aggravante',
      'Un élément constitutif obligatoire des violences',
      'Une contravention distincte uniquement',
    ],
    answer: 'Une circonstance aggravante',
    explanation:
        'Le cours mentionne la dissimulation volontaire du visage afin de ne pas être identifié comme circonstance aggravante.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences — Aggravation — 2e degré (222-13)',
    question:
        'Dans 222-13 (ITT ≤ 8 jours/0 ITT), le 2e degré est caractérisé notamment lorsque :',
    options: [
      'Les violences sont commises dans deux circonstances du 1er degré',
      'Il n’y a aucune circonstance',
      'La victime est inconnue',
    ],
    answer: 'Les violences sont commises dans deux circonstances du 1er degré',
    explanation:
        'Le cours précise : 2e degré = deux circonstances du 1er degré (ou situations spécifiques avec mineur/autorité).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences — Aggravation — 3e degré (222-13)',
    question: 'Dans 222-13, le 3e degré correspond :',
    options: [
      'À trois circonstances du 1er degré',
      'À une seule circonstance',
      'À une absence d’ITT',
    ],
    answer: 'À trois circonstances du 1er degré',
    explanation:
        'Le cours indique : 3e degré = trois circonstances du 1er degré.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // VIOLENCES 222-14-1 — ARME + BANDE ORGANISÉE OU GUET-APENS
  // (victimes spécifiques : DAP, pompiers, transport, etc.)
  // =========================================================
  const QuizQuestion(
    category: 'Violences 222-14-1 — Fondement',
    question:
        'Les violences avec arme sur une personne dépositaire de l’autorité publique (bande organisée ou guet-apens) sont prévues par :',
    options: [
      'L’article 222-14-1 du Code pénal',
      'L’article 222-14-2 du Code pénal',
      'L’article 221-1 du Code pénal',
    ],
    answer: 'L’article 222-14-1 du Code pénal',
    explanation:
        'Le cours précise : 222-14-1 CP définit et réprime cette infraction spécifique.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Conditions',
    question:
        'Pour 222-14-1, la condition “bande organisée ou guet-apens” est :',
    options: [
      'Alternative (l’une ou l’autre suffit)',
      'Cumulative (il faut les deux)',
      'Sans importance',
    ],
    answer: 'Alternative (l’une ou l’autre suffit)',
    explanation: 'Le cours précise que les deux conditions sont alternatives.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Bande organisée',
    question: 'La bande organisée (132-71 CP) suppose :',
    options: [
      'Un groupement/entente en vue de préparer une ou plusieurs infractions, caractérisée par des faits matériels',
      'Un rassemblement pacifique',
      'Une simple coïncidence de présence',
    ],
    answer:
        'Un groupement/entente en vue de préparer une ou plusieurs infractions, caractérisée par des faits matériels',
    explanation:
        'Le cours reprend la définition de 132-71 CP : préparation caractérisée par un ou plusieurs faits matériels.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Guet-apens',
    question: 'Le guet-apens se caractérise par :',
    options: [
      'Attendre la victime un certain temps, dans un lieu déterminé (effet de surprise)',
      'Une dispute spontanée',
      'Un acte involontaire',
    ],
    answer:
        'Attendre la victime un certain temps, dans un lieu déterminé (effet de surprise)',
    explanation:
        'Le cours définit le guet-apens comme l’attente de la victime dans un lieu déterminé.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Arme',
    question: 'Dans 222-14-1, les violences doivent être commises :',
    options: [
      'Avec usage ou menace d’une arme (par nature ou destination)',
      'Sans aucune arme',
      'Uniquement par négligence',
    ],
    answer: 'Avec usage ou menace d’une arme (par nature ou destination)',
    explanation:
        'Le cours précise : usage ou menace d’une arme, quelle qu’elle soit (par nature ou destination).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Victimes visées',
    question: 'Une des catégories de victimes visées par 222-14-1 est :',
    options: [
      'Un fonctionnaire de la police nationale / un militaire de la gendarmerie',
      'Un commerçant sans lien',
      'Un animal',
    ],
    answer:
        'Un fonctionnaire de la police nationale / un militaire de la gendarmerie',
    explanation:
        'Le cours liste les agents de la force publique parmi les victimes visées par le texte.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Contexte',
    question: 'Pour relever de 222-14-1, les violences doivent être commises :',
    options: [
      'Dans l’exercice, à l’occasion, ou en raison des fonctions/mission',
      'Uniquement en dehors du service',
      'Uniquement la nuit',
    ],
    answer: 'Dans l’exercice, à l’occasion, ou en raison des fonctions/mission',
    explanation:
        'Le cours précise le contexte requis : exercice, occasion ou raison des fonctions/mission.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — ITT / types de préjudices',
    question:
        'Le cours indique que 222-14-1 distingue notamment selon que les violences :',
    options: [
      'Ont entraîné mort / mutilation ou infirmité permanente / ITT > 8 jours / ITT ≤ 8 jours',
      'Ont entraîné seulement un dommage matériel',
      'Ne produisent jamais d’ITT',
    ],
    answer:
        'Ont entraîné mort / mutilation ou infirmité permanente / ITT > 8 jours / ITT ≤ 8 jours',
    explanation:
        'Le cours énumère quatre types de préjudices dans 222-14-1 (mort, MIP, ITT > 8, ITT ≤ 8).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Tentative',
    question: 'Selon le cours, pour 222-14-1, la tentative est :',
    options: [
      'Non (texte délictuels ne vise pas la tentative ; criminel théoriquement punissable mais difficile)',
      'Oui automatiquement',
      'Toujours retenue',
    ],
    answer:
        'Non (texte délictuels ne vise pas la tentative ; criminel théoriquement punissable mais difficile)',
    explanation:
        'Le cours indique : pas de tentative visée pour les violences délictuelles ; en criminel c’est théoriquement possible mais difficile à établir.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Complicité',
    question: 'Pour 222-14-1, la complicité est :',
    options: ['Oui', 'Non', 'Non sauf pour les personnes morales'],
    answer: 'Oui',
    explanation:
        'Le cours précise : complicité = OUI (121-6/121-7), notamment car l’infraction peut être commise en bande organisée.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // MEURTRE (221-1) — ELEMENTS + AGGRAVATIONS + TENTATIVE/COMPLICITÉ
  // =========================================================
  const QuizQuestion(
    category: 'Meurtre — Définition',
    question: 'Le meurtre correspond au fait de :',
    options: [
      'Donner volontairement la mort à autrui',
      'Causer involontairement une ITT',
      'Détruire un bien appartenant à autrui',
    ],
    answer: 'Donner volontairement la mort à autrui',
    explanation:
        'Le cours définit le meurtre comme le fait de donner volontairement la mort à autrui.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Fondement',
    question: 'Le meurtre est défini et réprimé par :',
    options: [
      'L’article 221-1 du Code pénal',
      'L’article 221-6 du Code pénal',
      'L’article 222-19 du Code pénal',
    ],
    answer: 'L’article 221-1 du Code pénal',
    explanation: 'Le cours précise : 221-1 CP définit et réprime le meurtre.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Élément matériel',
    question: 'L’élément matériel du meurtre nécessite :',
    options: [
      'Un acte positif de violence physique',
      'Une simple omission (privation de soins) uniquement',
      'Une faute d’imprudence simple',
    ],
    answer: 'Un acte positif de violence physique',
    explanation:
        'Le cours précise : acte positif de violence ; l’omission relève d’autres qualifications.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Moyen',
    question:
        'Dans le meurtre, le moyen utilisé (mains nues, arme, etc.) est :',
    options: [
      'Indifférent',
      'Toujours une arme à feu',
      'Toujours une arme blanche',
    ],
    answer: 'Indifférent',
    explanation:
        'Le cours indique que le moyen utilisé est indifférent (arme par nature/destination, etc.).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Victime',
    question: 'Le meurtre s’applique :',
    options: [
      'À une personne humaine vivante',
      'À un animal',
      'À un bien matériel',
    ],
    answer: 'À une personne humaine vivante',
    explanation:
        'Le cours précise : personne humaine vivante ; le meurtre ne s’applique pas à un animal.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Suicide',
    question: 'Selon le cours, le suicide :',
    options: [
      'N’est pas incriminé',
      'Est toujours poursuivi comme meurtre',
      'Est une contravention',
    ],
    answer: 'N’est pas incriminé',
    explanation:
        'Le cours indique : la victime doit être distincte de l’auteur ; le suicide n’est pas incriminé.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Consentement',
    question:
        'Le consentement de la victime (ex : euthanasie/suicide assisté) :',
    options: [
      'Est indifférent : donner la mort reste un meurtre',
      'Supprime l’infraction',
      'Transforme automatiquement en homicide involontaire',
    ],
    answer: 'Est indifférent : donner la mort reste un meurtre',
    explanation:
        'Le cours précise : même à la prière de la victime, donner la mort constitue un meurtre.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Causalité',
    question: 'Pour le meurtre, il faut établir :',
    options: [
      'Un lien de causalité entre l’acte et le décès',
      'Uniquement une intention sans résultat',
      'Un simple dommage matériel',
    ],
    answer: 'Un lien de causalité entre l’acte et le décès',
    explanation:
        'Le cours rappelle : l’acte doit avoir provoqué directement la mort ; la mort est conséquence de l’acte incriminé.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Élément moral',
    question: 'L’élément moral du meurtre est :',
    options: [
      'Une intention homicide (volonté de tuer)',
      'Une faute d’inattention',
      'Une négligence simple',
    ],
    answer: 'Une intention homicide (volonté de tuer)',
    explanation:
        'Le cours précise : volonté de donner la mort, détermination de tuer.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Intention (indices)',
    question:
        'Selon la jurisprudence rappelée au cours, l’intention homicide peut s’induire notamment :',
    options: [
      'De l’usage d’une arme meurtrière et de la zone du corps visée',
      'Du fait que la victime soit inconnue',
      'Du seul silence de l’auteur',
    ],
    answer: 'De l’usage d’une arme meurtrière et de la zone du corps visée',
    explanation:
        'Le cours rappelle l’induction de l’intention par l’arme et la région du corps frappée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Préméditation',
    question:
        'Ce qui distingue principalement le meurtre de l’assassinat est :',
    options: [
      'La préméditation (assassinat)',
      'L’existence d’une ITT',
      'Le caractère involontaire',
    ],
    answer: 'La préméditation (assassinat)',
    explanation:
        'Le cours indique : l’intention homicide concomitante suffit au meurtre ; l’assassinat requiert la préméditation.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Mobile',
    question: 'Les mobiles (politique, euthanasie, etc.) sont :',
    options: ['Indifférents', 'Toujours aggravants', 'Toujours exonératoires'],
    answer: 'Indifférents',
    explanation: 'Le cours précise : les mobiles sont indifférents.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Erreur sur la personne',
    question: 'L’erreur sur la personne (victime différente de celle visée) :',
    options: [
      'Ne fait pas disparaître l’intention homicide',
      'Supprime l’infraction',
      'Transforme en contravention',
    ],
    answer: 'Ne fait pas disparaître l’intention homicide',
    explanation:
        'Le cours précise : la volonté reste présente, le meurtre est constitué.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Aggravation 221-3',
    question: 'Le meurtre est aggravé lorsqu’il est commis :',
    options: [
      'Avec préméditation ou guet-apens',
      'Par inattention',
      'Sans intention',
    ],
    answer: 'Avec préméditation ou guet-apens',
    explanation:
        'Le cours indique : article 221-3 CP (préméditation ou guet-apens).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Tentative',
    question: 'La tentative de meurtre est :',
    options: [
      'Punissable (si commencement d’exécution)',
      'Jamais punissable',
      'Une contravention',
    ],
    answer: 'Punissable (si commencement d’exécution)',
    explanation:
        'Le cours précise : tentative = OUI (commencement d’exécution).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Complicité',
    question: 'La complicité de meurtre est :',
    options: [
      'Punissable (121-6/121-7 CP)',
      'Impossible',
      'Seulement disciplinaire',
    ],
    answer: 'Punissable (121-6/121-7 CP)',
    explanation: 'Le cours précise : complicité = OUI.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Groupement violent — Fondement',
    question:
        'La participation à un groupement violent est définie et réprimée par :',
    options: [
      'L’article 222-14-2 du Code pénal',
      'L’article 222-14-1 du Code pénal',
      'L’article 450-1 du Code pénal',
    ],
    answer: 'L’article 222-14-2 du Code pénal',
    explanation:
        'Le cours précise que l’article 222-14-2 CP définit et réprime la participation à un groupement violent.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Commencement d’exécution',
    question: 'Pour retenir la tentative de meurtre, il faut notamment :',
    options: [
      'Un commencement d’exécution et l’absence de désistement volontaire',
      'Une simple intention exprimée oralement',
      'Un simple repérage des lieux sans acte matériel',
    ],
    answer:
        'Un commencement d’exécution et l’absence de désistement volontaire',
    explanation:
        'Le cours rappelle que la tentative est punissable en cas de commencement d’exécution.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Indifférence du lieu et de la date',
    question: 'Un homicide volontaire peut être retenu même si :',
    options: [
      'Les actes successifs se déroulent sur une durée et pas en un lieu/date unique',
      'Les actes se déroulent uniquement en un lieu unique',
      'Les actes doivent être instantanés',
    ],
    answer:
        'Les actes successifs se déroulent sur une durée et pas en un lieu/date unique',
    explanation:
        'La jurisprudence citée dans le cours admet des moyens multiples et successifs, sans exigence de lieu/date unique.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Infraction impossible',
    question:
        'Si l’auteur frappe une victime déjà décédée, la qualification la plus juste selon le cours est :',
    options: [
      'Tentative d’homicide volontaire (infraction impossible assimilée)',
      'Meurtre consommé',
      'Aucune infraction possible',
    ],
    answer: 'Tentative d’homicide volontaire (infraction impossible assimilée)',
    explanation:
        'Le cours indique que l’acte sur cadavre relève de l’infraction impossible, assimilée à la tentative.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Consentement de la victime',
    question:
        'Le fait de donner la mort à une personne à sa demande explicite :',
    options: [
      'Reste un meurtre (consentement indifférent)',
      'N’est pas punissable',
      'Relève d’une contravention',
    ],
    answer: 'Reste un meurtre (consentement indifférent)',
    explanation:
        'Le cours rappelle que le consentement de la victime n’exclut pas l’infraction (euthanasie/suicide assisté).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Lien de causalité',
    question:
        'Pour caractériser le meurtre, il faut établir que les violences sont :',
    options: [
      'La cause efficiente, directe et immédiate de la mort',
      'Une simple cause possible parmi d’autres, sans certitude',
      'Un facteur uniquement moral',
    ],
    answer: 'La cause efficiente, directe et immédiate de la mort',
    explanation:
        'Le cours insiste sur la nécessité d’un lien de causalité entre l’acte et le décès.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Intention concomitante',
    question: 'L’intention homicide doit être :',
    options: [
      'Concomitante à l’acte de violence',
      'Nécessairement postérieure à l’acte',
      'Indifférente',
    ],
    answer: 'Concomitante à l’acte de violence',
    explanation:
        'Le cours précise que l’intention homicide doit exister au moment des violences.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Mobiles',
    question: 'Les mobiles (politique, euthanasie…) :',
    options: [
      'Sont indifférents pour la caractérisation du meurtre',
      'Excluent l’infraction',
      'Sont une circonstance aggravante automatique',
    ],
    answer: 'Sont indifférents pour la caractérisation du meurtre',
    explanation:
        'Le cours indique expressément que les mobiles sont indifférents.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Erreur sur la personne',
    question: 'Si l’auteur se trompe de victime (erreur sur la personne) :',
    options: [
      'L’intention homicide demeure et le meurtre est constitué',
      'Il n’y a plus d’intention homicide',
      'On bascule automatiquement en homicide involontaire',
    ],
    answer: 'L’intention homicide demeure et le meurtre est constitué',
    explanation:
        'Le cours rappelle que l’erreur sur la personne ne fait pas disparaître l’intention.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — 221-2 (principe)',
    question: 'Le meurtre est aggravé (221-2 CP) lorsqu’il est :',
    options: [
      'Précédé, accompagné ou suivi d’un autre crime',
      'Accompagné d’une contravention',
      'Commis sans violence',
    ],
    answer: 'Précédé, accompagné ou suivi d’un autre crime',
    explanation:
        'Le cours précise l’aggravation quand le meurtre est concomitant à un autre crime (221-2).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — 221-2 (condition)',
    question: 'Pour retenir 221-2, l’auteur du meurtre doit :',
    options: [
      'Être coupable du crime concomitant (comme auteur ou complice)',
      'Avoir seulement entendu parler du crime concomitant',
      'Avoir commis une contravention concomitante',
    ],
    answer: 'Être coupable du crime concomitant (comme auteur ou complice)',
    explanation:
        'Le cours indique que l’aggravation suppose que l’auteur (ou un auteur/complice) soit déclaré coupable du crime concomitant.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — 221-2 (ordre/lieu)',
    question:
        'Pour 221-2, le lieu et l’ordre de commission du meurtre et de l’autre crime :',
    options: [
      'Sont indifférents',
      'Doivent être identiques',
      'Doivent être dans la même minute',
    ],
    answer: 'Sont indifférents',
    explanation:
        'Le cours précise que le lieu et l’ordre de commission des infractions sont indifférents.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — 221-2 (tentative)',
    question: 'Selon le cours, l’aggravation 221-2 peut s’appliquer même si :',
    options: [
      'Le meurtre ou l’autre crime n’a été que tenté',
      'Aucune des infractions n’a été commencée',
      'Il s’agit uniquement d’une contravention',
    ],
    answer: 'Le meurtre ou l’autre crime n’a été que tenté',
    explanation:
        'Le cours indique que peu importe que le meurtre ou l’autre crime ait seulement été tenté.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — 221-2 (corrélation)',
    question: 'Pour retenir 221-2, il faut notamment :',
    options: [
      'Un lien de corrélation : le meurtre doit viser à faciliter le crime ou assurer l’impunité',
      'Un simple lien temporel quelconque',
      'Une ITT supérieure à 8 jours',
    ],
    answer:
        'Un lien de corrélation : le meurtre doit viser à faciliter le crime ou assurer l’impunité',
    explanation:
        'Le cours exige un rapport de cause à effet et un plan unique (faciliter/favoriser la fuite/assurer l’impunité).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — 221-3',
    question: 'Le meurtre commis avec préméditation ou guet-apens relève :',
    options: [
      'De l’article 221-3 du Code pénal',
      'De l’article 221-2 du Code pénal',
      'De l’article 221-6 du Code pénal',
    ],
    answer: 'De l’article 221-3 du Code pénal',
    explanation:
        'Le cours précise que 221-3 vise la préméditation ou le guet-apens.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — 221-4 (mineur)',
    question: 'Le meurtre est aggravé lorsqu’il est commis sur :',
    options: [
      'Un mineur de 15 ans',
      'Un majeur de 18 ans',
      'Une personne morale',
    ],
    answer: 'Un mineur de 15 ans',
    explanation: 'Le cours vise l’aggravation sur mineur de 15 ans (221-4).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — 221-4 (ascendant)',
    question: 'Le meurtre est aggravé lorsqu’il est commis sur :',
    options: [
      'Un ascendant légitime ou naturel, ou les père/mère adoptifs',
      'Un collègue de travail',
      'Un voisin',
    ],
    answer: 'Un ascendant légitime ou naturel, ou les père/mère adoptifs',
    explanation:
        'Le cours liste l’ascendant et les parents adoptifs parmi les aggravations de 221-4.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — 221-4 (vulnérabilité)',
    question:
        'Le meurtre est aggravé s’il est commis sur une personne vulnérable :',
    options: [
      'Vulnérabilité apparente ou connue (âge, maladie, infirmité, déficience, grossesse)',
      'Uniquement si la victime est majeure',
      'Uniquement si l’auteur est mineur',
    ],
    answer:
        'Vulnérabilité apparente ou connue (âge, maladie, infirmité, déficience, grossesse)',
    explanation:
        'Le cours reprend la vulnérabilité apparente ou connue (221-4).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — 221-4 (sujétion)',
    question: 'Le meurtre est aggravé lorsqu’il est commis sur une personne :',
    options: [
      'En état de sujétion psychologique ou physique connu de l’auteur (223-15-3)',
      'Simplement stressée',
      'Ayant une ITT',
    ],
    answer:
        'En état de sujétion psychologique ou physique connu de l’auteur (223-15-3)',
    explanation:
        'Le cours mentionne l’état de sujétion (223-15-3) comme circonstance aggravante (221-4).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — 221-4 (qualité)',
    question:
        'Le meurtre est aggravé lorsqu’il vise un dépositaire de l’autorité publique :',
    options: [
      'Dans l’exercice ou du fait des fonctions, si la qualité est apparente ou connue',
      'Uniquement hors service',
      'Uniquement si l’auteur ignore la qualité',
    ],
    answer:
        'Dans l’exercice ou du fait des fonctions, si la qualité est apparente ou connue',
    explanation:
        'Le cours précise la condition de contexte et la qualité apparente/connue.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — 221-4 (conjoint)',
    question: 'Le meurtre est aggravé lorsqu’il est commis :',
    options: [
      'Par le conjoint, concubin ou partenaire de PACS (y compris ancien) en raison des relations',
      'Uniquement par un ascendant',
      'Uniquement par un inconnu',
    ],
    answer:
        'Par le conjoint, concubin ou partenaire de PACS (y compris ancien) en raison des relations',
    explanation:
        'Le cours précise l’application aussi à l’ancien conjoint/concubin/partenaire en raison des relations ayant existé.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — 221-4 (refus de mariage)',
    question: 'Le meurtre est aggravé lorsqu’il est commis :',
    options: [
      'Contre une personne en raison de son refus de contracter mariage ou de conclure une union',
      'Uniquement pour un mobile politique',
      'Uniquement pour un vol',
    ],
    answer:
        'Contre une personne en raison de son refus de contracter mariage ou de conclure une union',
    explanation:
        'Le cours liste le refus de mariage/union parmi les aggravations (221-4).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — 221-4 (ivresse/stupéfiants)',
    question: 'Le meurtre est aggravé lorsqu’il est commis par une personne :',
    options: [
      'En état d’ivresse manifeste ou sous l’emprise manifeste de stupéfiants',
      'Ayant bu un café',
      'Simplement fatiguée',
    ],
    answer:
        'En état d’ivresse manifeste ou sous l’emprise manifeste de stupéfiants',
    explanation: 'Le cours mentionne cette aggravation dans l’article 221-4.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // EMPOISONNEMENT — APPROFONDISSEMENT (CONCOURS / PIÈGES)
  // =========================================================
  const QuizQuestion(
    category: 'Empoisonnement — Fondement',
    question: 'L’empoisonnement est défini et réprimé par :',
    options: [
      'L’article 221-5 du Code pénal',
      'L’article 221-1 du Code pénal',
      'L’article 222-14-1 du Code pénal',
    ],
    answer: 'L’article 221-5 du Code pénal',
    explanation: 'Le cours précise l’article 221-5 CP comme fondement.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Mode d’administration',
    question:
        'Le code pénal ne définit pas expressément le mode d’administration : cela signifie que :',
    options: [
      'La manière de procéder est indifférente (piqûre, ingestion, inhalation, etc.)',
      'Seule l’injection est visée',
      'Seule l’ingestion est visée',
    ],
    answer:
        'La manière de procéder est indifférente (piqûre, ingestion, inhalation, etc.)',
    explanation:
        'Le cours indique que la façon de procéder à l’empoisonnement est indifférente.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Administration indirecte',
    question: 'Le mode d’administration peut être indirect lorsque :',
    options: [
      'Le poison est remis à la victime par l’intermédiaire d’un tiers de bonne foi',
      'La victime est informée et consent',
      'Le poison n’est jamais mis à disposition',
    ],
    answer:
        'Le poison est remis à la victime par l’intermédiaire d’un tiers de bonne foi',
    explanation:
        'Le cours prévoit une administration indirecte via un tiers de bonne foi.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Victime trompée',
    question: 'L’empoisonnement peut être caractérisé même si :',
    options: [
      'La victime administre elle-même la substance en étant trompée',
      'La substance est inoffensive',
      'La victime est un animal',
    ],
    answer: 'La victime administre elle-même la substance en étant trompée',
    explanation:
        'Le cours indique que l’administration peut être le fait de la victime elle-même si elle a été trompée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Caractère mortifère',
    question: 'Le caractère mortifère de la substance s’apprécie :',
    options: [
      'Au cas par cas (propriétés, doses, mélanges, sensibilité particulière connue)',
      'Uniquement selon l’étiquette du produit',
      'Uniquement si la mort survient immédiatement',
    ],
    answer:
        'Au cas par cas (propriétés, doses, mélanges, sensibilité particulière connue)',
    explanation:
        'Le cours précise une appréciation in concreto : caractéristiques + usage + sensibilité connue.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Mélanges',
    question:
        'L’administration en connaissance de cause de produits associés :',
    options: [
      'Peut constituer l’élément matériel de l’empoisonnement',
      'Exclut par principe l’empoisonnement',
      'Relève uniquement d’une contravention',
    ],
    answer: 'Peut constituer l’élément matériel de l’empoisonnement',
    explanation:
        'Le cours cite la jurisprudence : l’association de produits peut constituer l’élément matériel.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Infraction formelle',
    question:
        'Dire que l’empoisonnement est une infraction formelle signifie que :',
    options: [
      'Le crime est réalisé du seul fait de l’administration, quelles qu’en soient les suites',
      'La mort est indispensable',
      'Une ITT est indispensable',
    ],
    answer:
        'Le crime est réalisé du seul fait de l’administration, quelles qu’en soient les suites',
    explanation:
        'Le cours indique l’indifférence du résultat : la consommation ne dépend pas du décès.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Connaissance',
    question: 'Si l’auteur ignore la nature mortelle de la substance, alors :',
    options: [
      'Il ne peut pas y avoir empoisonnement',
      'L’empoisonnement est automatiquement constitué',
      'On retient forcément le meurtre',
    ],
    answer: 'Il ne peut pas y avoir empoisonnement',
    explanation:
        'Le cours exige la connaissance du caractère mortifère de la substance employée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Intention',
    question: 'Selon la Cour de cassation (cours), l’empoisonnement suppose :',
    options: [
      'L’intention de donner la mort',
      'La seule connaissance du danger',
      'La seule imprudence',
    ],
    answer: 'L’intention de donner la mort',
    explanation:
        'Le cours rappelle le principe : « ne peut être caractérisé que si l’auteur a agi avec l’intention de donner la mort ».',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Tentative (frontière)',
    question: 'La consommation de l’empoisonnement intervient :',
    options: [
      'Dès que la substance a pénétré dans l’organisme (absorption)',
      'Dès l’achat du poison',
      'Dès la fabrication du poison',
    ],
    answer: 'Dès que la substance a pénétré dans l’organisme (absorption)',
    explanation:
        'Le cours situe la consommation au moment où la substance est introduite dans l’organisme.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Actes préparatoires',
    question:
        'Sont qualifiés d’actes préparatoires (trop éloignés) par le cours :',
    options: [
      'Acheter/fabriquer du poison ou mélanger le poison à des aliments',
      'Mettre le poison à disposition de la victime',
      'Faire absorber le poison',
    ],
    answer: 'Acheter/fabriquer du poison ou mélanger le poison à des aliments',
    explanation:
        'Le cours distingue les actes préparatoires (achat, fabrication, mélange) du commencement d’exécution.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // PROVOCATION (221-5-1) / RÉDUCTION (221-5-3) — EMP. & MEURTRE
  // =========================================================
  const QuizQuestion(
    category: 'Provocation — Principe',
    question:
        'La provocation (offres/promesses/dons) à commettre un assassinat ou un empoisonnement, non suivi d’effet :',
    options: [
      'Est punie en tant qu’infraction distincte',
      'N’est punissable que si le crime est tenté',
      'N’est jamais punissable',
    ],
    answer: 'Est punie en tant qu’infraction distincte',
    explanation:
        'Le cours précise que l’« instigateur » est poursuivi même si le crime n’a été ni commis ni tenté.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Réduction de peine — Empoisonnement',
    question:
        'Pour l’empoisonnement, la peine peut être réduite des deux tiers si :',
    options: [
      'L’auteur/complice avertit l’autorité et permet d’éviter la mort ou d’identifier d’autres auteurs/complices',
      'La victime guérit',
      'L’auteur présente des excuses',
    ],
    answer:
        'L’auteur/complice avertit l’autorité et permet d’éviter la mort ou d’identifier d’autres auteurs/complices',
    explanation:
        'Le cours cite la réduction spécifique (221-5-3 al.3 CP) et ses conditions.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // VIOLENCES 222-14-1 — APPROFONDISSEMENT (CONCOURS / PIÈGES)
  // =========================================================
  const QuizQuestion(
    category: 'Violences 222-14-1 — Alternative',
    question: 'Pour retenir 222-14-1, la commission doit être :',
    options: [
      'En bande organisée OU avec guet-apens',
      'En bande organisée ET avec guet-apens',
      'Sans concertation',
    ],
    answer: 'En bande organisée OU avec guet-apens',
    explanation: 'Le cours précise que les deux conditions sont alternatives.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Arme (nature/destination)',
    question: 'Pour 222-14-1, l’arme peut être :',
    options: [
      'Par nature ou par destination',
      'Uniquement une arme à feu',
      'Uniquement une arme blanche',
    ],
    answer: 'Par nature ou par destination',
    explanation:
        'Le cours vise une arme quelle qu’elle soit (par nature ou destination).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Violences psychologiques',
    question: 'Selon le cours, les violences peuvent être :',
    options: [
      'Physiques ou psychologiques (nature indifférente)',
      'Uniquement physiques',
      'Uniquement psychologiques',
    ],
    answer: 'Physiques ou psychologiques (nature indifférente)',
    explanation:
        'Le cours rappelle que les violences sont constituées quelle que soit leur nature, y compris psychologiques.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Contexte (exercice/occasion/raison)',
    question: '« En raison des fonctions » signifie notamment que :',
    options: [
      'L’auteur agit parce qu’il connaît la qualité de la victime, qui motive son acte',
      'La victime est forcément en service',
      'La victime est forcément hors service',
    ],
    answer:
        'L’auteur agit parce qu’il connaît la qualité de la victime, qui motive son acte',
    explanation:
        'Le cours distingue : exercice des fonctions / à l’occasion / en raison (motivation par la qualité).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Proches',
    question:
        'La protection s’étend aux proches vivant habituellement au domicile :',
    options: [
      'Si les violences sont commises en raison des fonctions de la personne protégée',
      'Sans aucune condition',
      'Uniquement si le proche est dépositaire de l’autorité publique',
    ],
    answer:
        'Si les violences sont commises en raison des fonctions de la personne protégée',
    explanation:
        'Le cours précise l’extension aux proches au domicile, en raison des fonctions exercées.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Fondement',
    question: 'Le meurtre est défini et réprimé par :',
    options: [
      'L’article 221-1 du Code pénal',
      'L’article 221-6 du Code pénal',
      'L’article 222-14-1 du Code pénal',
    ],
    answer: 'L’article 221-1 du Code pénal',
    explanation:
        'Le cours indique que l’article 221-1 CP définit et réprime le meurtre.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Élément matériel',
    question: 'L’élément matériel du meurtre suppose :',
    options: [
      'Un acte positif de violence physique',
      'Une simple abstention (privation de soins)',
      'Une faute d’imprudence',
    ],
    answer: 'Un acte positif de violence physique',
    explanation:
        'Le cours précise que le meurtre repose sur un acte positif de violence ; l’omission relève d’autres qualifications.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Acte d’omission',
    question: 'Une privation de soins est :',
    options: [
      'Un comportement négatif qui ne constitue pas l’élément matériel du meurtre',
      'Toujours un meurtre consommé',
      'Toujours un empoisonnement',
    ],
    answer:
        'Un comportement négatif qui ne constitue pas l’élément matériel du meurtre',
    explanation:
        'Le cours indique qu’un comportement négatif (privation de soins) ne caractérise pas l’élément matériel du meurtre.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Personne visée',
    question: 'Le meurtre suppose une victime :',
    options: ['Humaine et vivante', 'Animale', 'Indéterminée mais non humaine'],
    answer: 'Humaine et vivante',
    explanation:
        'Le cours précise que le meurtre vise une personne humaine, vivante.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Suicide',
    question: 'Le suicide :',
    options: [
      'N’est pas incriminé',
      'Est un meurtre',
      'Est un homicide involontaire',
    ],
    answer: 'N’est pas incriminé',
    explanation: 'Le cours rappelle que le suicide n’est pas incriminé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Intention homicide (preuve)',
    question: 'L’intention homicide peut s’induire notamment :',
    options: [
      'De l’usage d’une arme meurtrière et de la zone du corps visée',
      'Uniquement d’un aveu écrit',
      'Uniquement d’une ITT',
    ],
    answer: 'De l’usage d’une arme meurtrière et de la zone du corps visée',
    explanation:
        'Le cours cite la jurisprudence : arme utilisée + région du corps frappée peuvent révéler l’intention.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — Qualification',
    question:
        'Un meurtre commis avec préméditation ou guet-apens correspond à :',
    options: ['L’assassinat', 'Une contravention', 'Un homicide involontaire'],
    answer: 'L’assassinat',
    explanation:
        'Le cours indique que l’article 221-3 vise le meurtre avec préméditation ou guet-apens : c’est l’assassinat.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — Bande organisée',
    question: 'Le meurtre est aggravé lorsqu’il est commis :',
    options: [
      'Par plusieurs personnes agissant en bande organisée',
      'Par un seul auteur sans concertation',
      'Sans acte de violence',
    ],
    answer: 'Par plusieurs personnes agissant en bande organisée',
    explanation:
        'Le cours liste la bande organisée parmi les circonstances de l’article 221-4 CP.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Répression (simple)',
    question: 'La peine encourue pour meurtre simple (221-1) est :',
    options: [
      '30 ans de réclusion criminelle',
      '15 ans de réclusion criminelle',
      '10 ans d’emprisonnement',
    ],
    answer: '30 ans de réclusion criminelle',
    explanation:
        'Le tableau de répression du cours indique 30 ans de réclusion pour le meurtre simple.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Tentative',
    question: 'La tentative de meurtre est :',
    options: [
      'Punissable',
      'Non punissable en matière criminelle',
      'Punissable uniquement si la victime meurt',
    ],
    answer: 'Punissable',
    explanation:
        'Le cours indique : tentative de meurtre = OUI (si commencement d’exécution).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Complicité',
    question: 'La complicité de meurtre est :',
    options: [
      'Punissable (articles 121-6 et 121-7 CP)',
      'Impossible en matière criminelle',
      'Toujours exclue',
    ],
    answer: 'Punissable (articles 121-6 et 121-7 CP)',
    explanation:
        'Le cours rappelle que la complicité est punissable conformément aux articles 121-6 et 121-7.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre / Empoisonnement — Exemption',
    question:
        'Selon le cours, une personne ayant tenté meurtre/empoisonnement est exempte de peine si :',
    options: [
      'Elle avertit l’autorité administrative/judiciaire et permet d’éviter la mort',
      'Elle se rend spontanément après les faits',
      'Elle rembourse les dommages',
    ],
    answer:
        'Elle avertit l’autorité administrative/judiciaire et permet d’éviter la mort',
    explanation:
        'Le cours mentionne l’exemption spécifique : avertir l’autorité et éviter la mort de la victime.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Réduction de peine',
    question: 'La réduction de peine (2/3) pour meurtre est possible si :',
    options: [
      'Avertir l’autorité permet d’identifier d’autres auteurs/complices ou d’éviter la répétition',
      'L’auteur nie les faits',
      'La victime avait consenti',
    ],
    answer:
        'Avertir l’autorité permet d’identifier d’autres auteurs/complices ou d’éviter la répétition',
    explanation:
        'Le cours décrit la réduction : identification d’autres auteurs/complices ou éviter la répétition de l’infraction.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // EMPOISONNEMENT — SUITE (CONCOURS / TENTATIVE / PIÈGES)
  // =========================================================
  const QuizQuestion(
    category: 'Empoisonnement — Acte positif',
    question:
        'L’empoisonnement est une infraction de commission : cela suppose :',
    options: [
      'Un acte positif (emploi ou administration)',
      'Une simple abstention',
      'Une simple imprudence',
    ],
    answer: 'Un acte positif (emploi ou administration)',
    explanation:
        'Le cours précise que l’empoisonnement suppose un acte positif : une abstention ne suffit pas.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Emploi vs administration',
    question: 'Selon le cours, « l’emploi » de la substance mortifère :',
    options: [
      'Se situe en amont de l’administration et vise les actes de préparation',
      'Est identique à l’administration',
      'N’existe pas en droit pénal',
    ],
    answer:
        'Se situe en amont de l’administration et vise les actes de préparation',
    explanation:
        'Le cours distingue emploi (préparation, mise à disposition) et administration (faire pénétrer dans l’organisme).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Exemple emploi',
    question: 'Selon le cours, mélanger du poison à un plat constitue :',
    options: [
      'Un emploi de la substance (pas une administration)',
      'Une administration',
      'Un homicide involontaire',
    ],
    answer: 'Un emploi de la substance (pas une administration)',
    explanation:
        'Le cours donne cet exemple : mélanger du poison à un plat = emploi, non administration.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Victime déterminée',
    question: 'L’empoisonnement peut être constitué même si la victime est :',
    options: [
      'Déterminée ou indéterminée',
      'Nécessairement déterminée et identifiée',
      'Nécessairement un agent public',
    ],
    answer: 'Déterminée ou indéterminée',
    explanation:
        'Le cours précise que l’infraction peut viser une victime déterminée ou indéterminée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Sur un animal',
    question: 'L’empoisonnement (221-5) :',
    options: [
      'Ne s’applique pas à un animal',
      'S’applique aux animaux',
      'S’applique uniquement aux animaux',
    ],
    answer: 'Ne s’applique pas à un animal',
    explanation:
        'Le cours indique que l’empoisonnement vise une personne humaine.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Substances mortifères',
    question: 'Une substance « de nature à entraîner la mort » :',
    options: [
      'Peut tuer mais pas nécessairement',
      'Doit toujours tuer immédiatement',
      'Doit être un produit interdit',
    ],
    answer: 'Peut tuer mais pas nécessairement',
    explanation:
        'Le cours précise qu’elle peut tuer, sans que la mort soit certaine dans tous les cas.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Incubation',
    question: 'Le caractère mortifère peut s’exprimer :',
    options: [
      'Par action rapide ou à long terme (administrations répétées / incubation)',
      'Uniquement par action instantanée',
      'Uniquement par choc psychologique',
    ],
    answer:
        'Par action rapide ou à long terme (administrations répétées / incubation)',
    explanation:
        'Le cours évoque une action rapide ou une mort à long terme (répétition, incubation).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Tentative (commencement)',
    question:
        'Le commencement d’exécution de l’empoisonnement est retenu notamment lorsque :',
    options: [
      'Le poison est présenté à la victime ou mis à sa disposition',
      'Le poison est seulement acheté',
      'Le poison est seulement mentionné dans une conversation',
    ],
    answer: 'Le poison est présenté à la victime ou mis à sa disposition',
    explanation:
        'Le cours précise : commencement d’exécution dès lors que le poison est présenté ou mis à disposition.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Complicité',
    question: 'La complicité d’empoisonnement est :',
    options: [
      'Punissable (articles 121-6 et 121-7 CP)',
      'Exclue car crime formel',
      'Exclue car infraction non intentionnelle',
    ],
    answer: 'Punissable (articles 121-6 et 121-7 CP)',
    explanation: 'Le cours rappelle : complicité = OUI.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Provocation',
    question:
        'La provocation à commettre un empoisonnement, non suivie d’effet, est :',
    options: [
      'Une infraction distincte (instigateur)',
      'Toujours non punissable',
      'Punissable seulement en contravention',
    ],
    answer: 'Une infraction distincte (instigateur)',
    explanation:
        'Le cours indique que l’instigateur est poursuivi même si le crime n’a été ni commis ni tenté.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // VIOLENCES 222-14-1 — SUITE (RÉSULTATS / PEINES / TECHNIQUE)
  // =========================================================
  const QuizQuestion(
    category: 'Violences 222-14-1 — Victimes protégées',
    question: '222-14-1 vise notamment comme victimes :',
    options: [
      'Police/gendarmerie, administration pénitentiaire, dépositaire de l’autorité publique, sapeur-pompier, agent transport public',
      'Uniquement les mineurs',
      'Uniquement les conjoints',
    ],
    answer:
        'Police/gendarmerie, administration pénitentiaire, dépositaire de l’autorité publique, sapeur-pompier, agent transport public',
    explanation:
        'Le cours énumère les catégories de victimes spécifiquement protégées par 222-14-1.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Dépositaire autorité publique',
    question: 'Selon le cours, est dépositaire de l’autorité publique :',
    options: [
      'Une personne titulaire d’un pouvoir de décision et de contrainte par délégation de la puissance publique',
      'Toute personne salariée du privé',
      'Toute personne témoin',
    ],
    answer:
        'Une personne titulaire d’un pouvoir de décision et de contrainte par délégation de la puissance publique',
    explanation:
        'Le cours donne une définition fonctionnelle du dépositaire de l’autorité publique.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Maire',
    question:
        'Selon le cours, les responsables des exécutifs locaux (ex : maires) :',
    options: [
      'Ont la qualité de dépositaires de l’autorité publique',
      'N’ont jamais cette qualité',
      'Sont assimilés à des personnes privées',
    ],
    answer: 'Ont la qualité de dépositaires de l’autorité publique',
    explanation:
        'Le cours précise que les maires et exécutifs locaux ont cette qualité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — ITT et constat',
    question: 'Selon le cours, l’ITT (222-14-1) peut être constatée :',
    options: [
      'Par un médecin expert, à la demande de la victime ou de la personne poursuivie',
      'Uniquement par un policier',
      'Uniquement par un témoin',
    ],
    answer:
        'Par un médecin expert, à la demande de la victime ou de la personne poursuivie',
    explanation:
        'Le cours indique expressément cette possibilité de constat par médecin expert.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Qualification ITT 0-8 jours',
    question:
        'Les violences 222-14-1 ayant entraîné une ITT de 0 à 8 jours constituent :',
    options: ['Un délit', 'Une contravention', 'Un crime'],
    answer: 'Un délit',
    explanation:
        'Le tableau de répression du cours indique que l’ITT 0 à 8 jours (222-14-1 4°) est un délit.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Peine (ITT 0-8)',
    question: 'Pour 222-14-1 avec ITT 0 à 8 jours, la peine principale est :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation:
        'Le cours (tableau) fixe 10 ans et 150 000 € pour 222-14-1 (ITT 0-8 jours).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Qualification ITT > 8 jours',
    question:
        'Les violences 222-14-1 ayant entraîné une ITT > 8 jours constituent :',
    options: ['Un crime', 'Un délit', 'Une contravention'],
    answer: 'Un crime',
    explanation: 'Le cours classe l’ITT > 8 jours (222-14-1 3°) comme crime.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Peine (ITT > 8)',
    question: 'Pour 222-14-1 avec ITT > 8 jours, la peine principale est :',
    options: [
      '15 ans de réclusion criminelle',
      '10 ans d’emprisonnement',
      '7 ans de réclusion',
    ],
    answer: '15 ans de réclusion criminelle',
    explanation:
        'Le tableau de répression du cours indique 15 ans de réclusion (période de sûreté).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Mutilation/infirmité',
    question:
        'En cas de mutilation ou infirmité permanente (222-14-1), la peine est :',
    options: [
      '20 ans de réclusion criminelle',
      '15 ans de réclusion criminelle',
      '10 ans d’emprisonnement',
    ],
    answer: '20 ans de réclusion criminelle',
    explanation:
        'Le cours indique 20 ans de réclusion (période de sûreté) en cas de mutilation/infirmité permanente.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Mort',
    question:
        'Si les violences 222-14-1 entraînent la mort sans intention de la donner, la peine est :',
    options: [
      '30 ans de réclusion criminelle',
      '20 ans de réclusion criminelle',
      '15 ans de réclusion criminelle',
    ],
    answer: '30 ans de réclusion criminelle',
    explanation:
        'Le cours indique 30 ans de réclusion (période de sûreté) lorsque les violences entraînent la mort.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Tentative',
    question: 'Pour les violences délictuelles 222-14-1, la tentative est :',
    options: [
      'Non (les textes ne visent pas la tentative)',
      'Oui, toujours',
      'Oui uniquement si ITT > 8 jours',
    ],
    answer: 'Non (les textes ne visent pas la tentative)',
    explanation:
        'Le cours précise : tentative = NON pour les violences délictuelles (les textes ne la visent pas).',
    difficulty: 'Moyenne',
  ),
  // =========================================================
  // ATTEINTES INVOLONTAIRES — CONTRAVENTIONS — ITT ≤ 3 MOIS
  // (R. 622-1 / R. 625-2 / R. 625-3 CP)
  // =========================================================
  const QuizQuestion(
    category: 'Atteintes involontaires — Contravention — Principe',
    question:
        'Hors les cas prévus par 222-20 et 222-20-1, causer une ITT ≤ 3 mois par maladresse/imprudence constitue :',
    options: [
      'Une contravention (régime R. 625-2 CP)',
      'Un crime',
      'Un délit automatiquement',
    ],
    answer: 'Une contravention (régime R. 625-2 CP)',
    explanation:
        'Le cours distingue les atteintes involontaires contraventionnelles (ITT ≤ 3 mois) hors régimes délictuels spécifiques.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — Contravention — Faute',
    question:
        'La liste des fautes (maladresse, imprudence, inattention, négligence, manquement à une obligation) en matière contraventionnelle est :',
    options: ['Limitative', 'Indicative', 'Sans importance'],
    answer: 'Limitative',
    explanation:
        'Le cours précise que la liste est limitative et doit être caractérisée par les juges.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — Contravention — Négligence',
    question: 'Selon le cours, la négligence correspond surtout :',
    options: [
      'À ne pas se soucier des conséquences de son abstention',
      'À agir avec préméditation',
      'À dissimuler volontairement son visage',
    ],
    answer: 'À ne pas se soucier des conséquences de son abstention',
    explanation:
        'Le cours définit la négligence comme le fait de ne pas se soucier des conséquences de son abstention.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — Contravention — Obligation',
    question:
        'Le “règlement” au sens du cours (obligation de prudence/sécurité) vise :',
    options: [
      'Des actes administratifs généraux et impersonnels',
      'Uniquement des consignes internes d’entreprise',
      'Uniquement un contrat privé',
    ],
    answer: 'Des actes administratifs généraux et impersonnels',
    explanation:
        'Le cours précise que le règlement s’entend des actes des autorités administratives à caractère général et impersonnel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — Contravention — Source',
    question:
        'En cas de manquement à une obligation textuelle, les magistrats doivent :',
    options: [
      'Préciser la source et la nature exacte de l’obligation violée',
      'Se contenter d’une formule générale',
      'Se référer uniquement à l’équité',
    ],
    answer: 'Préciser la source et la nature exacte de l’obligation violée',
    explanation:
        'Le cours rappelle l’exigence de précision sur la source et la nature de l’obligation (logique Cass. crim., 18 juin 2002).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — Contravention — ITT',
    question: 'Pour R. 625-2 CP, l’ITT retenue doit être :',
    options: [
      '≤ 3 mois consécutifs (non additionnés)',
      'Additionnée sur plusieurs périodes',
      'Toujours > 3 mois',
    ],
    answer: '≤ 3 mois consécutifs (non additionnés)',
    explanation:
        'Le cours précise : ITT ≤ 3 mois consécutifs et non des périodes additionnées.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — Contravention — Sans ITT',
    question: 'R. 622-1 CP vise :',
    options: [
      'Une atteinte sans ITT (contravention 2e classe)',
      'Une ITT > 3 mois',
      'Un homicide involontaire',
    ],
    answer: 'Une atteinte sans ITT (contravention 2e classe)',
    explanation:
        'Le cours présente R. 622-1 comme l’atteinte involontaire sans ITT (2e classe).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — Contravention — Aggravation',
    question: 'La contravention de 5e classe (R. 625-3) correspond :',
    options: [
      'À l’aggravation de R. 622-1 en cas de violation manifestement délibérée d’une obligation particulière',
      'À une tentative de délit',
      'À un crime',
    ],
    answer:
        'À l’aggravation de R. 622-1 en cas de violation manifestement délibérée d’une obligation particulière',
    explanation:
        'Le cours indique que R. 625-3 aggrave R. 622-1 lorsque la violation est manifestement délibérée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — Contravention — Moral',
    question:
        'En matière contraventionnelle d’atteintes involontaires, l’élément moral est :',
    options: [
      'Non exigé',
      'Toujours exigé',
      'Exigé uniquement si la victime le demande',
    ],
    answer: 'Non exigé',
    explanation:
        'Le cours précise : “Non exigé en matière contraventionnelle”.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — Contravention — Tentative',
    question: 'La tentative des contraventions d’atteintes involontaires est :',
    options: ['Non', 'Oui', 'Oui si ITT = 0'],
    answer: 'Non',
    explanation: 'Le cours précise : tentative = NON en contraventionnel.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — Contravention — Complicité',
    question:
        'La complicité en matière de contraventions d’atteintes involontaires est :',
    options: ['Non', 'Oui, toujours', 'Oui seulement si le dommage est grave'],
    answer: 'Non',
    explanation:
        'Le cours précise : complicité = NON en matière contraventionnelle pour ces atteintes involontaires.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // ATTEINTES INVOLONTAIRES — DÉLIT — ITT ≤ 3 MOIS (CONDUCTEUR)
  // (222-20-1 CP)
  // =========================================================
  const QuizQuestion(
    category: 'Atteintes involontaires — Conducteur — Fondement',
    question:
        'Les atteintes involontaires commises par conducteur (ITT ≤ 3 mois) sont prévues par :',
    options: [
      'L’article 222-20-1 du Code pénal',
      'L’article 222-19 du Code pénal',
      'L’article R. 625-2 du Code pénal',
    ],
    answer: 'L’article 222-20-1 du Code pénal',
    explanation:
        'Le cours indique que les blessures involontaires par conducteur avec ITT ≤ 3 mois sont prévues et réprimées à 222-20-1 CP.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — Conducteur — Faute',
    question: 'Pour 222-20-1, les fautes de base sont notamment :',
    options: [
      'Maladresse, imprudence, inattention, négligence, manquement à une obligation',
      'Préméditation, guet-apens, bande organisée',
      'Atteinte volontaire psychologique uniquement',
    ],
    answer:
        'Maladresse, imprudence, inattention, négligence, manquement à une obligation',
    explanation:
        'Le cours renvoie à 222-19 et 121-3 : cinq comportements fautifs (faute d’imprudence simple).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — Conducteur — Peines (simple)',
    question: 'Pour 222-20-1 (régime simple), les peines principales sont :',
    options: [
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 30 000 € d’amende',
    explanation:
        'Le tableau de répression du cours indique 2 ans et 30 000 € pour 222-20-1 (simple).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — Conducteur — Aggravation',
    question: 'Dans 222-20-1, le “2e degré” correspond :',
    options: [
      'À la réunion d’au moins deux circonstances aggravantes listées',
      'À la tentative',
      'Au concours avec un crime',
    ],
    answer: 'À la réunion d’au moins deux circonstances aggravantes listées',
    explanation:
        'Le cours distingue l’aggravation lorsque deux ou plus des circonstances sont réunies.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — Conducteur — Complicité',
    question:
        'Pour 222-20-1 (blessures involontaires conducteur), la complicité est :',
    options: ['Non', 'Oui', 'Oui uniquement par instigation'],
    answer: 'Non',
    explanation:
        'Le cours précise : complicité = NON pour ce délit non intentionnel (222-20-1).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — Conducteur — Tentative',
    question: 'Pour 222-20-1, la tentative est :',
    options: [
      'Non (résultat non souhaité)',
      'Oui dès le premier acte',
      'Oui seulement si alcool',
    ],
    answer: 'Non (résultat non souhaité)',
    explanation:
        'Le cours indique : tentative non envisageable car le résultat dommageable n’est pas souhaité.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // ATTEINTES INVOLONTAIRES — DÉLIT — ITT > 3 MOIS
  // (222-19 CP + aggravations 222-19-1 / 222-19-2 / 434-10)
  // =========================================================
  const QuizQuestion(
    category: 'Atteintes involontaires — ITT > 3 mois — Fondement',
    question:
        'Les blessures involontaires avec ITT > 3 mois sont prévues par :',
    options: [
      'L’article 222-19 al. 1 du Code pénal',
      'L’article 222-20-1 du Code pénal',
      'L’article R. 625-2 du Code pénal',
    ],
    answer: 'L’article 222-19 al. 1 du Code pénal',
    explanation:
        'Le cours indique que l’ITT > 3 mois relève de 222-19 al.1 CP.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — ITT > 3 mois — Élément moral',
    question:
        'Pour les infractions non intentionnelles (blessures involontaires), l’élément moral est :',
    options: [
      'Non requis en principe',
      'Toujours requis comme une intention de blesser',
      'Remplacé par la préméditation',
    ],
    answer: 'Non requis en principe',
    explanation:
        'Le cours rappelle : l’élément moral n’est pas requis pour les infractions non intentionnelles (sauf cas de violation délibérée à caractériser).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — ITT > 3 mois — Violation délibérée',
    question:
        'La circonstance aggravante “violation manifestement délibérée” (222-19 al.2) suppose :',
    options: [
      'Une obligation particulière prévue par la loi ou le règlement et une transgression volontaire',
      'Une simple maladresse',
      'Une intention de tuer',
    ],
    answer:
        'Une obligation particulière prévue par la loi ou le règlement et une transgression volontaire',
    explanation:
        'Le cours précise : obligation particulière + connaissance + choix délibéré de ne pas la respecter.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — ITT > 3 mois — Conducteur',
    question: 'Le 1er degré d’aggravation (222-19-1) vise notamment :',
    options: [
      'La commission par conducteur d’un véhicule terrestre à moteur',
      'La commission par un mineur',
      'La commission sur un animal',
    ],
    answer: 'La commission par conducteur d’un véhicule terrestre à moteur',
    explanation:
        'Le cours indique : 222-19-1 prévoit une aggravation lorsque l’infraction est commise par conducteur de VTAM.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — ITT > 3 mois — 2e degré (routier)',
    question:
        'Le 2e degré (222-19-1) peut être caractérisé si les blessures s’accompagnent notamment :',
    options: [
      'D’alcool/stupéfiants/refus vérifications/sans permis/≥50 km/h/délit de fuite',
      'De préméditation',
      'D’un guet-apens',
    ],
    answer:
        'D’alcool/stupéfiants/refus vérifications/sans permis/≥50 km/h/délit de fuite',
    explanation:
        'Le cours liste ces infractions routières comme circonstances d’aggravation du 2e degré.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — ITT > 3 mois — 3e degré (routier)',
    question: 'Le 3e degré (222-19-1) correspond :',
    options: [
      'À la réunion d’au moins deux des circonstances du 2e degré',
      'À une ITT de 0 à 8 jours',
      'À un simple dommage matériel',
    ],
    answer: 'À la réunion d’au moins deux des circonstances du 2e degré',
    explanation:
        'Le cours précise : 3e degré = deux ou plusieurs circonstances prévues.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — ITT > 3 mois — Délit de fuite',
    question:
        'Selon le cours, une aggravation spécifique peut exister lorsque les blessures sont suivies :',
    options: [
      'D’un délit de fuite (référence 434-10 CP hors cas 222-19-1)',
      'D’une simple erreur de diagnostic',
      'D’un retard administratif',
    ],
    answer: 'D’un délit de fuite (référence 434-10 CP hors cas 222-19-1)',
    explanation:
        'Le cours mentionne l’article 434-10 CP pour le cas du délit de fuite (hors régime 222-19-1).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — ITT > 3 mois — Complicité',
    question:
        'En matière de blessures involontaires (ITT > 3 mois), la complicité est :',
    options: [
      'Non (jurisprudence : complicité exclue en non intentionnel)',
      'Oui, toujours',
      'Oui uniquement si la victime est vulnérable',
    ],
    answer: 'Non (jurisprudence : complicité exclue en non intentionnel)',
    explanation:
        'Le cours indique que la jurisprudence exclut la complicité en matière d’infraction non intentionnelle.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // BLESSURES INVOLONTAIRES — VIOLATION MANIFESTEMENT DÉLIBÉRÉE
  // (222-20 CP + aggravation 222-20-2)
  // =========================================================
  const QuizQuestion(
    category: 'Violation délibérée — Fondement',
    question:
        'Les blessures involontaires par violation manifestement délibérée (ITT ≤ 3 mois) sont prévues par :',
    options: [
      'L’article 222-20 du Code pénal',
      'L’article 222-20-1 du Code pénal',
      'L’article R. 625-2 du Code pénal',
    ],
    answer: 'L’article 222-20 du Code pénal',
    explanation:
        'Le cours précise : l’infraction est prévue et réprimée par 222-20 CP.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Violation délibérée — Obligation particulière',
    question:
        'L’obligation particulière de prudence ou de sécurité doit être prévue par :',
    options: [
      'Un texte (loi, décret, arrêté)',
      'Un simple règlement intérieur',
      'Une consigne orale non écrite',
    ],
    answer: 'Un texte (loi, décret, arrêté)',
    explanation:
        'Le cours précise que l’obligation particulière doit être prévue par un texte (loi/décret/arrêté).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violation délibérée — Connaissance',
    question: 'Pour caractériser 222-20, il faut établir que la personne :',
    options: [
      'Avait connaissance de l’obligation spécifique',
      'Ignorait totalement l’obligation',
      'N’avait aucune compétence',
    ],
    answer: 'Avait connaissance de l’obligation spécifique',
    explanation:
        'Le cours indique que la personne doit avoir connaissance de l’obligation (formation/fonctions/compétences/responsabilités).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violation délibérée — Volonté',
    question: 'La “violation manifestement délibérée” implique :',
    options: [
      'Un choix délibéré de ne pas respecter l’obligation',
      'Une simple erreur d’attention',
      'Une intention de tuer',
    ],
    answer: 'Un choix délibéré de ne pas respecter l’obligation',
    explanation:
        'Le cours précise : le dommage n’est pas voulu, mais le risque est pleinement assumé (choix de transgresser).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violation délibérée — Complicité',
    question: 'Pour 222-20 (faute délibérée), la complicité est :',
    options: ['Oui', 'Non', 'Impossible par nature'],
    answer: 'Oui',
    explanation:
        'Le cours indique : complicité = OUI, car il s’agit d’une faute délibérée (ex : instigation).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violation délibérée — Tentative',
    question: 'Pour 222-20, la tentative est :',
    options: ['Non', 'Oui', 'Oui si deux circonstances aggravantes'],
    answer: 'Non',
    explanation: 'Le cours précise : tentative = NON (résultat non voulu).',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // HOMICIDE INVOLONTAIRE (221-6 + aggravations 221-6-1 / 221-6-2 / 434-10)
  // =========================================================
  const QuizQuestion(
    category: 'Homicide involontaire — Fondement',
    question: 'L’homicide involontaire est prévu et réprimé par :',
    options: [
      'L’article 221-6 du Code pénal',
      'L’article 222-19 du Code pénal',
      'L’article 221-1 du Code pénal',
    ],
    answer: 'L’article 221-6 du Code pénal',
    explanation:
        'Le cours précise que l’article 221-6 CP prévoit et réprime l’homicide involontaire.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Homicide involontaire — Résultat',
    question: 'Le dommage de l’homicide involontaire est :',
    options: [
      'La mort de la victime',
      'Une ITT de 0 à 8 jours',
      'Une simple dégradation de bien',
    ],
    answer: 'La mort de la victime',
    explanation: 'Le cours indique : le dommage est la mort d’autrui.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Homicide involontaire — Faute',
    question: 'La faute simple (221-6) peut être :',
    options: [
      'Maladresse, imprudence, inattention, négligence, manquement à une obligation',
      'Préméditation',
      'Guet-apens',
    ],
    answer:
        'Maladresse, imprudence, inattention, négligence, manquement à une obligation',
    explanation:
        'Le cours renvoie à 121-3 : cinq comportements fautifs (liste limitative).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Homicide involontaire — Causalité',
    question: 'Selon le cours, le lien de causalité exigé par 221-6 :',
    options: [
      'N’exige pas un lien direct et immédiat, il suffit qu’il soit certain',
      'Doit toujours être direct et immédiat',
      'Peut être supposé sans preuve',
    ],
    answer:
        'N’exige pas un lien direct et immédiat, il suffit qu’il soit certain',
    explanation:
        'Le cours indique qu’un lien direct et immédiat n’est pas exigé : il suffit qu’il soit certain.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Homicide involontaire — Causalité indirecte',
    question: 'L’auteur indirect (121-3 al.4) est celui qui :',
    options: [
      'Crée/contribue à créer la situation ayant permis le dommage ou n’a pas pris les mesures pour l’éviter',
      'Porte le coup mortel',
      'Agit avec intention homicide',
    ],
    answer:
        'Crée/contribue à créer la situation ayant permis le dommage ou n’a pas pris les mesures pour l’éviter',
    explanation:
        'Le cours cite la définition légale des auteurs indirects (création de situation dangereuse / omission de mesures).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Homicide involontaire — Aggravation (violation délibérée)',
    question: 'L’homicide involontaire est aggravé (221-6 al.2) lorsque :',
    options: [
      'La mort résulte d’une violation manifestement délibérée d’une obligation particulière',
      'La victime avait consenti',
      'Le mobile est politique',
    ],
    answer:
        'La mort résulte d’une violation manifestement délibérée d’une obligation particulière',
    explanation:
        'Le cours précise 221-6 al.2 : violation manifestement délibérée d’une obligation particulière.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Homicide involontaire — Aggravation conducteur',
    question:
        '221-6-1 prévoit une aggravation lorsque l’homicide involontaire est commis :',
    options: [
      'Par le conducteur d’un véhicule terrestre à moteur',
      'Par un témoin',
      'Par un juge',
    ],
    answer: 'Par le conducteur d’un véhicule terrestre à moteur',
    explanation:
        'Le cours indique : 221-6-1 (1er degré) si commis par conducteur de VTAM.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Homicide involontaire — Peines (simple)',
    question:
        'La peine principale de l’homicide involontaire simple (221-6 al.1) est :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '30 ans de réclusion',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 3 ans et 45 000 € pour 221-6 al.1.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Homicide involontaire — Complicité',
    question: 'Pour l’homicide involontaire, la complicité est :',
    options: ['Non (jurisprudence)', 'Oui', 'Oui si bande organisée'],
    answer: 'Non (jurisprudence)',
    explanation:
        'Le cours indique que la jurisprudence exclut la complicité en matière d’infraction non intentionnelle.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Homicide involontaire — Tentative',
    question: 'La tentative d’homicide involontaire est :',
    options: ['Non (résultat non souhaité)', 'Oui', 'Oui uniquement si alcool'],
    answer: 'Non (résultat non souhaité)',
    explanation:
        'Le cours précise : la tentative n’est pas envisagée car le résultat n’est pas recherché.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Violences 222-14-1 — Complicité',
    question: 'La complicité est :',
    options: [
      'Oui, punissable (121-6/121-7), notamment car l’infraction peut être en bande organisée',
      'Non, exclue',
      'Non, car c’est une contravention',
    ],
    answer:
        'Oui, punissable (121-6/121-7), notamment car l’infraction peut être en bande organisée',
    explanation:
        'Le cours indique complicité = OUI et rappelle le lien avec la bande organisée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Atteintes involontaires — Contravention — Fondement',
    question:
        'Les atteintes involontaires avec ITT ≤ 3 mois, hors délits, sont prévues par :',
    options: [
      'Les articles R. 625-2, R. 625-3 et R. 622-1 du Code pénal',
      'L’article 222-20-1 du Code pénal',
      'L’article 221-6 du Code pénal',
    ],
    answer: 'Les articles R. 625-2, R. 625-3 et R. 622-1 du Code pénal',
    explanation:
        'Le cours précise que les atteintes involontaires contraventionnelles relèvent des articles R. 625-2, R. 625-3 et R. 622-1 CP.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // MEURTRE — art. 221-1 CP
  // =========================================================
  const QuizQuestion(
    category: 'Meurtre — Définition',
    question: 'Le meurtre est :',
    options: [
      'Le fait de donner volontairement la mort à autrui',
      'Le fait de causer la mort par imprudence',
      'Le fait d’aider au suicide',
    ],
    answer: 'Le fait de donner volontairement la mort à autrui',
    explanation:
        'Le cours définit le meurtre comme le fait de donner volontairement la mort à autrui.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Fondement',
    question: 'Le meurtre est défini et réprimé par :',
    options: [
      'L’article 221-1 du Code pénal',
      'L’article 221-6 du Code pénal',
      'L’article 222-7 du Code pénal',
    ],
    answer: 'L’article 221-1 du Code pénal',
    explanation:
        'Le cours précise que l’article 221-1 CP définit et réprime le meurtre.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Élément matériel',
    question: 'L’élément matériel du meurtre suppose :',
    options: [
      'Un acte positif de violence physique',
      'Une simple abstention (privation de soins)',
      'Un manquement involontaire à une obligation',
    ],
    answer: 'Un acte positif de violence physique',
    explanation:
        'Le meurtre exige un acte positif de violence; l’omission relève d’autres qualifications.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Moyen',
    question: 'Le moyen utilisé pour commettre un meurtre est :',
    options: [
      'Indifférent (mains nues, arme, etc.)',
      'Nécessairement une arme par nature',
      'Nécessairement une arme à feu',
    ],
    answer: 'Indifférent (mains nues, arme, etc.)',
    explanation:
        'Le cours indique que le moyen est indifférent : mains nues, arme par nature ou destination…',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Actes successifs',
    question: 'Un homicide volontaire peut résulter :',
    options: [
      'De moyens multiples et successifs sur une durée plus ou moins longue',
      'Uniquement d’un acte unique et instantané',
      'Uniquement d’un acte commis en un seul lieu',
    ],
    answer:
        'De moyens multiples et successifs sur une durée plus ou moins longue',
    explanation:
        'La jurisprudence admet des moyens multiples et successifs, sans date/lieu unique nécessaire.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Victime',
    question: 'Le meurtre vise :',
    options: ['Une personne humaine', 'Un animal', 'Un bien meuble'],
    answer: 'Une personne humaine',
    explanation: 'Le meurtre ne s’applique pas à un animal.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Personne vivante',
    question:
        'Si l’acte est accompli sur un cadavre (victime déjà décédée), la qualification retenue est :',
    options: [
      'Tentative (infraction impossible assimilée)',
      'Meurtre consommé',
      'Homicide involontaire',
    ],
    answer: 'Tentative (infraction impossible assimilée)',
    explanation:
        'Le cours indique que l’acte sur cadavre relève de l’infraction impossible, assimilée à la tentative.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Suicide',
    question: 'Le suicide est :',
    options: [
      'Non incriminé',
      'Incriminé comme meurtre',
      'Incriminé comme empoisonnement',
    ],
    answer: 'Non incriminé',
    explanation: 'Le cours précise que le suicide n’est pas incriminé.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Consentement',
    question: 'Le consentement de la victime (à sa prière/ordre exprès) :',
    options: [
      'N’exclut pas le meurtre',
      'Exclut l’infraction',
      'Transforme l’infraction en contravention',
    ],
    answer: 'N’exclut pas le meurtre',
    explanation:
        'Le cours rappelle l’indifférence du consentement (euthanasie / suicide assisté).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Lien de causalité',
    question: 'Pour le meurtre, il faut établir :',
    options: [
      'Un lien de causalité entre l’acte et le décès',
      'Un simple risque de décès',
      'Une ITT supérieure à 3 mois',
    ],
    answer: 'Un lien de causalité entre l’acte et le décès',
    explanation:
        'L’acte doit avoir provoqué la mort : les violences sont la cause efficiente du décès.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Élément moral',
    question: 'L’élément moral du meurtre est :',
    options: [
      'L’intention homicide (volonté de tuer)',
      'La seule négligence',
      'La seule imprudence',
    ],
    answer: 'L’intention homicide (volonté de tuer)',
    explanation:
        'Le meurtre suppose une intention homicide : la détermination de donner la mort.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Indices d’intention',
    question: 'L’intention homicide peut notamment s’induire :',
    options: [
      'Du caractère meurtrier de l’arme et de la zone frappée',
      'Du seul mobile',
      'Du seul casier judiciaire',
    ],
    answer: 'Du caractère meurtrier de l’arme et de la zone frappée',
    explanation:
        'Le cours mentionne l’induction par l’arme utilisée et la région du corps visée.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Mobiles',
    question: 'Les mobiles en matière de meurtre sont :',
    options: ['Indifférents', 'Toujours aggravants', 'Toujours atténuants'],
    answer: 'Indifférents',
    explanation:
        'Le cours précise que les mobiles sont indifférents (politique, euthanasie…).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Erreur sur la personne',
    question: 'L’erreur sur la personne visée :',
    options: [
      'N’efface pas l’intention homicide',
      'Efface toujours l’intention',
      'Transforme en homicide involontaire',
    ],
    answer: 'N’efface pas l’intention homicide',
    explanation: 'La volonté de tuer demeure : le meurtre reste constitué.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Tentative',
    question: 'La tentative de meurtre est :',
    options: [
      'Punissable',
      'Non punissable',
      'Uniquement punissable en cas d’ITT',
    ],
    answer: 'Punissable',
    explanation:
        'Le cours indique que la tentative est punissable en présence d’un commencement d’exécution.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre — Complicité',
    question: 'La complicité de meurtre est :',
    options: [
      'Punissable (121-6 et 121-7 CP)',
      'Exclue par principe',
      'Uniquement contraventionnelle',
    ],
    answer: 'Punissable (121-6 et 121-7 CP)',
    explanation:
        'Le cours rappelle la punissabilité de la complicité (121-6/121-7 CP).',
    difficulty: 'Facile',
  ),

  // =========================================================
  // MEURTRE — CIRCONSTANCES AGGRAVANTES (221-2 / 221-3 / 221-4)
  // =========================================================
  const QuizQuestion(
    category: 'Meurtre aggravé — Crime concomitant',
    question:
        'Le meurtre est aggravé lorsqu’il est précédé, accompagné ou suivi :',
    options: [
      'D’un autre crime (art. 221-2 CP)',
      'D’une contravention',
      'D’un simple incident civil',
    ],
    answer: 'D’un autre crime (art. 221-2 CP)',
    explanation:
        'Le cours vise l’aggravation de l’article 221-2 CP (concomitance avec un crime).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — Préméditation',
    question: 'Le meurtre commis avec préméditation ou guet-apens relève :',
    options: [
      'De l’article 221-3 CP',
      'De l’article 221-6 CP',
      'De l’article 222-14-1 CP',
    ],
    answer: 'De l’article 221-3 CP',
    explanation:
        'Le cours indique l’article 221-3 CP pour préméditation/guet-apens.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — Victime',
    question: 'Le meurtre est aggravé notamment lorsqu’il est commis sur :',
    options: [
      'Un mineur de 15 ans',
      'Un majeur de 18 ans uniquement',
      'Un animal domestique',
    ],
    answer: 'Un mineur de 15 ans',
    explanation:
        'Le cours liste l’aggravation sur mineur de 15 ans (art. 221-4 CP).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — Qualité de la victime',
    question:
        'Le meurtre est aggravé lorsqu’il est commis sur une personne dépositaire de l’autorité publique :',
    options: [
      'Dans l’exercice ou du fait de ses fonctions et si la qualité est apparente ou connue',
      'Uniquement si la victime porte plainte',
      'Uniquement en cas d’ITT',
    ],
    answer:
        'Dans l’exercice ou du fait de ses fonctions et si la qualité est apparente ou connue',
    explanation:
        'Le cours rappelle l’exigence de contexte + qualité apparente/connue.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — Bande organisée',
    question: 'Le meurtre est aggravé lorsqu’il est commis :',
    options: [
      'Par plusieurs personnes agissant en bande organisée',
      'Par une seule personne sans concertation',
      'Sans aucun acte matériel',
    ],
    answer: 'Par plusieurs personnes agissant en bande organisée',
    explanation:
        'Le cours mentionne la bande organisée parmi les aggravations de l’art. 221-4.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre — Peines',
    question: 'Le meurtre simple (art. 221-1 CP) est puni de :',
    options: [
      '30 ans de réclusion criminelle',
      '10 ans d’emprisonnement',
      '5 ans d’emprisonnement',
    ],
    answer: '30 ans de réclusion criminelle',
    explanation:
        'Le cours rappelle la peine du meurtre simple : 30 ans de réclusion.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Meurtre aggravé — Peine',
    question: 'Le meurtre aggravé (221-2/221-3/221-4) est puni de :',
    options: [
      'Réclusion criminelle à perpétuité (avec période de sûreté)',
      '30 ans de réclusion',
      '3 ans d’emprisonnement',
    ],
    answer: 'Réclusion criminelle à perpétuité (avec période de sûreté)',
    explanation: 'Le cours indique la perpétuité pour les formes aggravées.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // PROVOCATION / EXEMPTION / RÉDUCTION (MEURTRE & EMPOISONNEMENT)
  // =========================================================
  const QuizQuestion(
    category: 'Provocation — Assassinat/Empoisonnement',
    question:
        'Le fait de faire des offres/promesses/dons pour faire commettre un assassinat ou un empoisonnement non commis ni tenté est :',
    options: [
      'Une infraction distincte (art. 221-5-1 CP)',
      'Une simple complicité',
      'Non punissable',
    ],
    answer: 'Une infraction distincte (art. 221-5-1 CP)',
    explanation:
        'Le cours vise l’« instigateur » : infraction autonome si pas de crime/tentative.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Exemption — Tentative',
    question:
        'Une personne ayant tenté un meurtre ou un empoisonnement peut être exempte de peine si :',
    options: [
      'Elle avertit l’autorité et permet d’éviter la mort de la victime',
      'Elle rembourse les frais médicaux',
      'Elle reconnaît les faits à l’audience uniquement',
    ],
    answer: 'Elle avertit l’autorité et permet d’éviter la mort de la victime',
    explanation: 'Le cours cite l’exemption spécifique (221-5-3 al.1 CP).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Réduction de peine — Meurtre',
    question:
        'Pour le meurtre, la peine peut être réduite des deux tiers si l’auteur/complice :',
    options: [
      'Avertit l’autorité et permet d’identifier d’autres auteurs/complices ou d’éviter la répétition',
      'A indemnisé la famille',
      'A quitté le territoire',
    ],
    answer:
        'Avertit l’autorité et permet d’identifier d’autres auteurs/complices ou d’éviter la répétition',
    explanation:
        'Le cours cite la réduction (221-5-3 al.2 CP) et ses conditions.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // EMPOISONNEMENT — art. 221-5 CP
  // =========================================================
  const QuizQuestion(
    category: 'Empoisonnement — Définition',
    question: 'L’empoisonnement est :',
    options: [
      'Attenter à la vie d’autrui par l’emploi ou l’administration de substances de nature à entraîner la mort',
      'Donner des médicaments sans ordonnance',
      'Causer une ITT par imprudence',
    ],
    answer:
        'Attenter à la vie d’autrui par l’emploi ou l’administration de substances de nature à entraîner la mort',
    explanation:
        'Le cours définit l’empoisonnement par emploi/administration de substances mortifères.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Fondement',
    question: 'L’empoisonnement est défini et réprimé par :',
    options: [
      'L’article 221-5 du Code pénal',
      'L’article 221-1 du Code pénal',
      'L’article 222-14-1 du Code pénal',
    ],
    answer: 'L’article 221-5 du Code pénal',
    explanation: 'Le cours indique l’article 221-5 CP.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Acte positif',
    question: 'L’empoisonnement est une infraction :',
    options: [
      'De commission (acte positif requis)',
      'D’omission (abstention suffisante)',
      'Purement contraventionnelle',
    ],
    answer: 'De commission (acte positif requis)',
    explanation: 'Le cours précise qu’une simple abstention ne suffit pas.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Emploi vs Administration',
    question: 'Dans le cours, « administrer » désigne :',
    options: [
      'Faire pénétrer le poison dans l’organisme',
      'Préparer le poison sans le donner',
      'Acheter le poison',
    ],
    answer: 'Faire pénétrer le poison dans l’organisme',
    explanation:
        'L’administration vise l’action directe : ingérer, injecter, inoculer…',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Emploi vs Administration',
    question: 'Dans le cours, « emploi » désigne :',
    options: [
      'Les actes en amont et de préparation, plus larges que l’administration',
      'Uniquement l’injection',
      'Uniquement la boisson',
    ],
    answer:
        'Les actes en amont et de préparation, plus larges que l’administration',
    explanation:
        'L’emploi est en amont : ex. poison mélangé au plat / mise à disposition.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Victime',
    question: 'L’empoisonnement vise :',
    options: ['Une personne humaine', 'Un animal', 'Un objet'],
    answer: 'Une personne humaine',
    explanation:
        'Le cours rappelle que l’empoisonnement ne s’applique pas à un animal.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Victime indéterminée',
    question: 'L’empoisonnement est constitué même si la victime est :',
    options: [
      'Déterminée ou indéterminée',
      'Nécessairement précisément identifiée',
      'Toujours l’auteur lui-même',
    ],
    answer: 'Déterminée ou indéterminée',
    explanation:
        'Le cours admet la victime indéterminée (ex : contamination d’un puits).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Substance',
    question: 'Une « substance de nature à entraîner la mort » :',
    options: [
      'Peut tuer, sans nécessairement tuer à chaque fois',
      'Doit tuer immédiatement',
      'Doit être un poison végétal uniquement',
    ],
    answer: 'Peut tuer, sans nécessairement tuer à chaque fois',
    explanation:
        'Le cours indique : peut entraîner la mort, pas nécessairement.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Résultat',
    question: 'L’empoisonnement est une infraction :',
    options: [
      'Formelle (indifférence du résultat)',
      'Matérielle (mort requise)',
      'Contraventionnelle',
    ],
    answer: 'Formelle (indifférence du résultat)',
    explanation:
        'Le crime est réalisé du seul fait de l’administration, quelles qu’en soient les suites.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Élément moral',
    question: 'Pour caractériser l’empoisonnement, il faut :',
    options: [
      'La connaissance du caractère mortifère + l’intention de donner la mort',
      'La seule connaissance du risque',
      'Une simple négligence',
    ],
    answer:
        'La connaissance du caractère mortifère + l’intention de donner la mort',
    explanation:
        'Le cours précise que la seule connaissance ne suffit pas : intention de tuer requise.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Tentative',
    question:
        'Pour l’empoisonnement, la frontière tentative/consommé se situe :',
    options: [
      'Au moment de l’absorption (entrée dans l’organisme)',
      'Au moment de l’achat du poison',
      'Au moment de la pensée',
    ],
    answer: 'Au moment de l’absorption (entrée dans l’organisme)',
    explanation:
        'Le cours place la consommation dès que la substance pénètre dans l’organisme.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Commencement d’exécution',
    question:
        'Le commencement d’exécution (tentative) est retenu notamment lorsque :',
    options: [
      'Le poison est présenté ou mis à disposition de la victime',
      'Le poison est seulement fabriqué',
      'Le poison est seulement acheté',
    ],
    answer: 'Le poison est présenté ou mis à disposition de la victime',
    explanation:
        'Le cours précise que la tentative peut commencer dès la présentation/mise à disposition.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Complicité',
    question: 'La complicité d’empoisonnement est :',
    options: ['Punissable (121-6 et 121-7 CP)', 'Exclue', 'Uniquement civile'],
    answer: 'Punissable (121-6 et 121-7 CP)',
    explanation: 'Le cours rappelle la complicité punissable.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Provocation',
    question:
        'La provocation à commettre un empoisonnement non commis ni tenté (offres/promesses) est :',
    options: [
      'Une infraction distincte (221-5-1 CP)',
      'Une simple tentative',
      'Une contravention',
    ],
    answer: 'Une infraction distincte (221-5-1 CP)',
    explanation:
        'Le cours vise l’« instigateur » : infraction autonome en l’absence de crime/tentative.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Empoisonnement — Peine',
    question: 'L’empoisonnement simple (art. 221-5 CP) est puni de :',
    options: [
      '30 ans de réclusion criminelle (avec période de sûreté)',
      '10 ans d’emprisonnement',
      '5 ans d’emprisonnement',
    ],
    answer: '30 ans de réclusion criminelle (avec période de sûreté)',
    explanation:
        'Le cours indique 30 ans de réclusion avec période de sûreté pour la forme simple.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Empoisonnement aggravé — Peine',
    question: 'L’empoisonnement aggravé est puni de :',
    options: [
      'Réclusion criminelle à perpétuité (avec période de sûreté)',
      '30 ans de réclusion',
      '7 ans d’emprisonnement',
    ],
    answer: 'Réclusion criminelle à perpétuité (avec période de sûreté)',
    explanation: 'Le cours indique la perpétuité pour la forme aggravée.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // VIOLENCES AVEC ARME SUR D.A.P / SP / TRANSPORT — art. 222-14-1
  // =========================================================
  const QuizQuestion(
    category: 'Violences 222-14-1 — Fondement',
    question:
        'Les violences avec arme sur personne dépositaire de l’autorité publique (bande organisée ou guet-apens) sont définies par :',
    options: [
      'L’article 222-14-1 du Code pénal',
      'L’article 222-14-2 du Code pénal',
      'L’article 221-1 du Code pénal',
    ],
    answer: 'L’article 222-14-1 du Code pénal',
    explanation:
        'Le cours précise que l’article 222-14-1 CP définit et réprime cette infraction.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Condition alternative',
    question:
        'Pour l’article 222-14-1, la condition « bande organisée ou guet-apens » est :',
    options: [
      'Alternative (l’une ou l’autre suffit)',
      'Cumulative (les deux nécessaires)',
      'Inexistante',
    ],
    answer: 'Alternative (l’une ou l’autre suffit)',
    explanation: 'Le cours précise que les deux conditions sont alternatives.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Bande organisée',
    question: 'La bande organisée (132-71 CP) suppose :',
    options: [
      'Une entente en vue de la préparation caractérisée par un ou plusieurs faits matériels',
      'Une simple présence fortuite',
      'Un attroupement pacifique',
    ],
    answer:
        'Une entente en vue de la préparation caractérisée par un ou plusieurs faits matériels',
    explanation:
        'Le cours rappelle la définition de l’article 132-71 CP (préparation + faits matériels).',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Guet-apens',
    question: 'Le guet-apens se caractérise par :',
    options: [
      'Attendre un certain temps et dans un lieu déterminé la victime (effet de surprise)',
      'Une dispute spontanée',
      'Une omission de prudence',
    ],
    answer:
        'Attendre un certain temps et dans un lieu déterminé la victime (effet de surprise)',
    explanation:
        'Le cours indique l’attente en un lieu déterminé, créant l’effet de surprise.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Arme',
    question: 'Pour 222-14-1, les violences doivent être commises :',
    options: [
      'Avec usage ou menace d’une arme (par nature ou destination)',
      'Sans aucun objet',
      'Uniquement par arme à feu',
    ],
    answer: 'Avec usage ou menace d’une arme (par nature ou destination)',
    explanation:
        'Le cours vise l’usage ou la menace d’une arme, quelle qu’elle soit.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Victimes visées',
    question:
        'Parmi les victimes visées explicitement par 222-14-1, on trouve :',
    options: [
      'Fonctionnaire de police / gendarme / personnel pénitentiaire / dépositaire de l’autorité publique',
      'Uniquement les commerçants',
      'Uniquement les mineurs de 15 ans',
    ],
    answer:
        'Fonctionnaire de police / gendarme / personnel pénitentiaire / dépositaire de l’autorité publique',
    explanation:
        'Le cours énumère ces catégories parmi les victimes protégées par 222-14-1.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Dépositaire A.P.',
    question: 'Une personne dépositaire de l’autorité publique est notamment :',
    options: [
      'Une personne titulaire d’un pouvoir de décision et de contrainte par délégation de puissance publique',
      'Un simple usager',
      'Un témoin quelconque',
    ],
    answer:
        'Une personne titulaire d’un pouvoir de décision et de contrainte par délégation de puissance publique',
    explanation:
        'Le cours donne la définition : pouvoir de décision/contrainte investi par délégation.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Autres victimes',
    question: 'Sont aussi visés par 222-14-1 :',
    options: [
      'Sapeur-pompier et agent d’un réseau de transport public de voyageurs',
      'Uniquement les médecins',
      'Uniquement les enseignants',
    ],
    answer:
        'Sapeur-pompier et agent d’un réseau de transport public de voyageurs',
    explanation:
        'Le cours mentionne explicitement les sapeurs-pompiers et agents de transport public.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Proches',
    question: 'L’article 222-14-1 vise aussi les violences commises contre :',
    options: [
      'Le conjoint/ascendant/descendant ou personne vivant au domicile, en raison des fonctions',
      'Uniquement le conjoint, sans condition',
      'Uniquement les amis',
    ],
    answer:
        'Le conjoint/ascendant/descendant ou personne vivant au domicile, en raison des fonctions',
    explanation:
        'Le cours étend la protection aux proches vivant habituellement au domicile, en raison des fonctions.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Contexte',
    question: 'L’infraction doit être commise :',
    options: [
      'Dans l’exercice, à l’occasion, ou en raison des fonctions/mission',
      'Uniquement pendant le service',
      'Uniquement hors service',
    ],
    answer: 'Dans l’exercice, à l’occasion, ou en raison des fonctions/mission',
    explanation:
        'Le cours liste les trois hypothèses : exercice / à l’occasion / en raison.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Résultat',
    question: 'Le texte 222-14-1 distingue notamment selon que les violences :',
    options: [
      'Ont entraîné mort, mutilation/infirmité, ITT > 8 jours, ou ITT ≤ 8 jours',
      'Ont entraîné uniquement une ITT > 3 mois',
      'Sont uniquement psychologiques',
    ],
    answer:
        'Ont entraîné mort, mutilation/infirmité, ITT > 8 jours, ou ITT ≤ 8 jours',
    explanation:
        'Le cours présente les 4 niveaux de résultat retenus par 222-14-1.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — ITT',
    question:
        'L’ITT, à la demande de la victime ou du poursuivi, est constatée par :',
    options: ['Un médecin expert', 'Le maire', 'Le procureur'],
    answer: 'Un médecin expert',
    explanation:
        'Le cours précise la constatation par médecin expert sur demande.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Élément moral',
    question: 'Pour 222-14-1, l’élément moral suppose :',
    options: [
      'La conscience de porter atteinte + la volonté de viser une personne à qualité déterminée',
      'Une simple imprudence',
      'Une négligence involontaire',
    ],
    answer:
        'La conscience de porter atteinte + la volonté de viser une personne à qualité déterminée',
    explanation:
        'Le cours rappelle la conscience + la volonté de violences sur une victime visée par la loi.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Aggravantes',
    question:
        'Le cours indique, pour 222-14-1, des circonstances aggravantes :',
    options: [
      'Aucune (elles sont déjà intégrées dans l’incrimination)',
      'Oui : préméditation obligatoire',
      'Oui : récidive obligatoire',
    ],
    answer: 'Aucune (elles sont déjà intégrées dans l’incrimination)',
    explanation:
        'Le cours mentionne : « Aucune » circonstance aggravante additionnelle.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Tentative',
    question: 'La tentative des violences délictuelles 222-14-1 est :',
    options: [
      'Non visée (donc non punissable en délit)',
      'Toujours punissable',
      'Punissable uniquement si ITT > 3 mois',
    ],
    answer: 'Non visée (donc non punissable en délit)',
    explanation:
        'Le cours indique que les textes relatifs aux violences délictuelles ne visent pas la tentative.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Complicité',
    question: 'La complicité pour 222-14-1 est :',
    options: ['Punissable', 'Exclue', 'Uniquement civile'],
    answer: 'Punissable',
    explanation:
        'Le cours précise la complicité punissable (121-6/121-7) et cohérente avec bande organisée.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Peine (ITT 0 à 8 jours)',
    question: 'Les violences (ITT 0 à 8 jours) de 222-14-1 sont punies de :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '30 ans de réclusion',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation: 'Le cours indique 10 ans et 150 000 € pour ITT 0 à 8 jours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Peine (ITT > 8 jours)',
    question: 'Les violences (ITT > 8 jours) de 222-14-1 sont punies de :',
    options: [
      '15 ans de réclusion',
      '10 ans d’emprisonnement',
      '30 ans de réclusion',
    ],
    answer: '15 ans de réclusion',
    explanation: 'Le cours prévoit 15 ans de réclusion pour ITT > 8 jours.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Peine (Infirmité)',
    question:
        'Les violences ayant entraîné mutilation/infirmité permanente (222-14-1) sont punies de :',
    options: [
      '20 ans de réclusion',
      '15 ans de réclusion',
      '10 ans d’emprisonnement',
    ],
    answer: '20 ans de réclusion',
    explanation:
        'Le cours indique 20 ans de réclusion en cas de mutilation/infirmité permanente.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Violences 222-14-1 — Peine (Mort)',
    question:
        'Les violences ayant entraîné la mort sans intention de la donner (222-14-1) sont punies de :',
    options: [
      '30 ans de réclusion',
      '20 ans de réclusion',
      '10 ans d’emprisonnement',
    ],
    answer: '30 ans de réclusion',
    explanation:
        'Le cours prévoit 30 ans de réclusion lorsque les violences entraînent la mort sans intention.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // QUESTIONS "CONCOURS" — PIÈGES & DISTINCTIONS
  // =========================================================
  const QuizQuestion(
    category: 'Concours — Meurtre vs Omission',
    question: 'Un comportement négatif (privation de soins) constitue :',
    options: [
      'Pas l’élément matériel du meurtre (autres qualifications possibles)',
      'Toujours un meurtre',
      'Toujours un empoisonnement',
    ],
    answer:
        'Pas l’élément matériel du meurtre (autres qualifications possibles)',
    explanation:
        'Le cours exclut l’omission du meurtre : d’autres infractions peuvent s’appliquer.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Concours — Empoisonnement (intention)',
    question:
        'Si l’auteur sait que la substance est mortifère mais n’a pas l’intention de tuer :',
    options: [
      'L’empoisonnement n’est pas caractérisé',
      'L’empoisonnement est toujours constitué',
      'C’est automatiquement un meurtre',
    ],
    answer: 'L’empoisonnement n’est pas caractérisé',
    explanation:
        'Le cours rappelle que l’empoisonnement exige aussi l’intention de donner la mort.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Concours — Empoisonnement (consommation)',
    question: 'L’empoisonnement est consommé :',
    options: [
      'Dès l’absorption/entrée du poison dans l’organisme, quel qu’en soit le résultat',
      'Uniquement si la victime décède',
      'Uniquement si ITT > 8 jours',
    ],
    answer:
        'Dès l’absorption/entrée du poison dans l’organisme, quel qu’en soit le résultat',
    explanation:
        'Infraction formelle : consommation dès que la substance est introduite dans l’organisme.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Concours — 222-14-1 (structure)',
    question: 'Pour retenir 222-14-1, il faut notamment :',
    options: [
      'Bande organisée OU guet-apens + usage/menace d’arme + victime visée + contexte fonctions',
      'Uniquement une ITT',
      'Uniquement une arme',
    ],
    answer:
        'Bande organisée OU guet-apens + usage/menace d’arme + victime visée + contexte fonctions',
    explanation:
        'Le cours structure l’infraction autour de ces conditions cumulatives (avec alternative bande/guet-apens).',
    difficulty: 'Difficile',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizAtteinteVolontairePA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName =
      '/pa/crimes_personne/quiz/atteintes_volontaires_vie';
  final String uid;
  final String email;

  const QuizAtteinteVolontairePA({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizAtteinteVolontairePA> createState() => _QuizAtteinteVolontairePAState();
}

class _QuizAtteinteVolontairePAState extends State<QuizAtteinteVolontairePA>
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
  static const _introHiddenKey = 'intro_pa_atteintes_volontaires';
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
        ? questionAtteinteVolontaire
        : questionAtteinteVolontaire
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
            'quiz_name': 'Atteinte Volontaire',
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
      await _sb.from('quiz_atteintes_volontaires_vie').insert({
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
      debugPrint('❌ quiz_atteintes_volontaires_vie insert failed: $e');
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
      'source_file': 'pa_quiz_atteintes_volontaires',
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
                            icon: Icons.sports_mma_rounded,
                            title: 'Atteintes volontaires',
                            description: 'Maîtrise les crimes et délits volontaires contre les personnes : meurtre, assassinat, violences et leurs circonstances aggravantes.',
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
