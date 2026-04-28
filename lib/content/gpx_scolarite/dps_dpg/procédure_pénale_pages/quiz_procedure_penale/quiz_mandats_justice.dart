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
final List<QuizQuestion> questionsMandatsJustice = [
  QuizQuestion(
    category: 'Mandats de justice — Notions générales',
    question: 'Les mandats de justice sont :',
    options: [
      'Des actes judiciaires écrits ordonnant certaines mesures de contrainte',
      'Des simples convocations téléphoniques',
      'Des décisions administratives du préfet',
    ],
    answer:
        'Des actes judiciaires écrits ordonnant certaines mesures de contrainte',
    explanation:
        'Les mandats de justice sont définis comme des actes judiciaires écrits ordonnant la garde à vue, la comparution, l’arrestation ou la détention d’une personne.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Notions générales',
    question: 'Les mandats de justice peuvent être délivrés :',
    options: [
      'Par tout policier',
      'Uniquement par des magistrats',
      'Par le maire de la commune',
    ],
    answer: 'Uniquement par des magistrats',
    explanation:
        'Le texte précise que les mandats de justice ne peuvent être délivrés que par des magistrats.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Notions générales',
    question:
        'Selon l’article 122 alinéa 1 du C.P.P., combien de types de mandats de justice sont énumérés ?',
    options: ['Trois', 'Quatre', 'Cinq'],
    answer: 'Cinq',
    explanation:
        'L’article 122 al. 1 du C.P.P. énumère cinq types de mandats : recherche, comparution, amener, dépôt et arrêt.',
    difficulty: 'Facile',
  ),

  // =====================================================
  // QUESTIONS SUPPLÉMENTAIRES — NIVEAU 1 (FACILE)
  // =====================================================
  QuizQuestion(
    category: 'Mandats de justice — Notions générales',
    question:
        'Les mandats de justice se trouvent principalement dans le C.P.P. au chapitre consacré :',
    options: [
      'À la garde à vue',
      'Au juge d’instruction',
      'À l’exécution des peines',
    ],
    answer: 'Au juge d’instruction',
    explanation:
        'Les textes qui fixent les règles de forme et de fond des mandats sont situés dans la section consacrée au juge d’instruction.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Notions générales',
    question: 'Les mandats de justice ordonnent notamment :',
    options: [
      'La perquisition des locaux administratifs',
      'La garde à vue, la comparution, l’arrestation ou la détention d’une personne',
      'La saisie des biens immobiliers',
    ],
    answer:
        'La garde à vue, la comparution, l’arrestation ou la détention d’une personne',
    explanation:
        'Leur objet est de contraindre la personne par différents degrés de mesures (recherche, comparution, amener, dépôt, arrêt).',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Principes',
    question: 'Les mandats de justice sont valables :',
    options: [
      'Uniquement dans le ressort du tribunal qui les a décernés',
      'Sur tout le territoire de la République',
      'Uniquement dans le département concerné',
    ],
    answer: 'Sur tout le territoire de la République',
    explanation:
        'Le texte indique que les mandats sont exécutoires sur l’ensemble du territoire de la République.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Forme',
    question: 'Pour être régulier, un mandat doit être :',
    options: [
      'Daté, signé et revêtu du sceau du magistrat',
      'Signé uniquement par le greffier',
      'Non daté mais tamponné par le commissariat',
    ],
    answer: 'Daté, signé et revêtu du sceau du magistrat',
    explanation:
        'Ces mentions formelles sont exigées pour attester de l’authenticité et de la régularité du mandat.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de recherche — Personnes visées',
    question: 'Le mandat de recherche ne peut pas être délivré contre :',
    options: [
      'Le mis en examen',
      'Le témoin assisté',
      'Une personne totalement inconnue et non désignée',
    ],
    answer: 'Une personne totalement inconnue et non désignée',
    explanation:
        'Il doit viser une personne identifiée (mise en examen, témoin assisté ou personne nommément désignée dans un réquisitoire).',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de comparution — Usage',
    question: 'Le mandat de comparution est principalement utilisé :',
    options: [
      'Pour convoquer une personne domiciliée que l’on ne croit pas en fuite',
      'Pour rechercher une personne en cavale',
      'Pour exécuter une peine',
    ],
    answer:
        'Pour convoquer une personne domiciliée que l’on ne croit pas en fuite',
    explanation:
        'C’est l’outil privilégié pour appeler devant le juge une personne que l’on s’attend à voir se présenter.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de comparution — Notification',
    question: 'La notification d’un mandat de comparution peut être faite :',
    options: [
      'À la personne elle-même ou, en son absence, à son domicile',
      'Uniquement en main propre au tribunal',
      'Uniquement par courrier recommandé avec accusé de réception',
    ],
    answer: 'À la personne elle-même ou, en son absence, à son domicile',
    explanation:
        'Le mandat de comparution n’a pas vocation à une diffusion générale comme un mandat d’arrêt.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Objet',
    question: 'L’objectif principal du mandat d’amener est :',
    options: [
      'De rechercher la personne sur l’ensemble du territoire',
      'De conduire immédiatement la personne devant le magistrat',
      'De la maintenir en détention plusieurs mois',
    ],
    answer: 'De conduire immédiatement la personne devant le magistrat',
    explanation:
        'Le mandat d’amener est centré sur la présentation immédiate de la personne devant la justice.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Nature',
    question: 'Le mandat d’arrêt est à la fois :',
    options: [
      'Un simple avis de recherche sans contrainte',
      'Un ordre de recherche et d’arrestation et un titre de détention',
      'Un document purement administratif',
    ],
    answer: 'Un ordre de recherche et d’arrestation et un titre de détention',
    explanation:
        'Il permet l’arrestation de la personne et son éventuelle conduite en maison d’arrêt.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de dépôt — Effet',
    question:
        'La remise de la personne par l’agent au chef d’établissement pénitentiaire en exécution d’un mandat de dépôt :',
    options: [
      'Met fin à toute responsabilité de l’État',
      'Doit donner lieu à une reconnaissance écrite de réception',
      'N’a pas besoin de trace écrite',
    ],
    answer: 'Doit donner lieu à une reconnaissance écrite de réception',
    explanation:
        'L’article 135 al. 2 C.P.P. prévoit que le chef d’établissement délivre une reconnaissance de la remise.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats — Sanctions',
    question:
        'En cas d’irrégularité non substantielle dans la notification d’un mandat, la conséquence la plus probable est :',
    options: [
      'Aucune conséquence',
      'La nullité de l’exécution mais pas du mandat lui-même',
      'La nullité automatique de tout le dossier pénal',
    ],
    answer: 'La nullité de l’exécution mais pas du mandat lui-même',
    explanation:
        'Seules les irrégularités substantielles justifient la nullité du mandat ; les autres peuvent entraîner la nullité de l’exécution.',
    difficulty: 'Facile',
  ),

  // =====================================================
  // QUESTIONS SUPPLÉMENTAIRES — NIVEAU 2 (MOYEN)
  // =====================================================
  QuizQuestion(
    category: 'Mandat de recherche — Exécution',
    question:
        'Lorsqu’un mandat de recherche est exécuté au domicile de la personne recherchée, la perquisition effectuée :',
    options: [
      'Obéit aux règles de l’article 134 C.P.P. et doit respecter les heures légales',
      'Peut se faire de nuit sans condition',
      'Peut viser n’importe quel voisin',
    ],
    answer:
        'Obéit aux règles de l’article 134 C.P.P. et doit respecter les heures légales',
    explanation:
        'La perquisition se fait dans le respect des articles 133 et 134 C.P.P. et des heures légales de perquisition.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de recherche — Enquête préliminaire',
    question:
        'En enquête préliminaire, un mandat de recherche délivré par le procureur de la République :',
    options: [
      'Permet l’arrestation de toute personne se trouvant sur les lieux',
      'Vise une personne déterminée dont on a des raisons plausibles de soupçonner la commission ou la tentative d’une infraction',
      'Ne peut jamais être utilisé',
    ],
    answer:
        'Vise une personne déterminée dont on a des raisons plausibles de soupçonner la commission ou la tentative d’une infraction',
    explanation:
        'L’article 77-4 C.P.P. reprend le mécanisme de l’article 70 pour l’enquête préliminaire.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de comparution — Choix du magistrat',
    question:
        'Pourquoi le juge préfère-t-il souvent décerner un mandat de comparution plutôt qu’une simple convocation ?',
    options: [
      'Parce qu’il n’y a alors aucune garantie de comparution',
      'Parce que le mandat est plus solennel et soumis à des règles précises de notification',
      'Pour pouvoir immédiatement placer en détention la personne',
    ],
    answer:
        'Parce que le mandat est plus solennel et soumis à des règles précises de notification',
    explanation:
        'Le mandat de comparution renforce l’obligation de se présenter devant le magistrat.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Témoins assistés',
    question: 'Le mandat d’amener peut également être délivré à l’encontre :',
    options: [
      'D’un témoin assisté',
      'Du conseil de la personne',
      'D’un juré de cour d’assises',
    ],
    answer: 'D’un témoin assisté',
    explanation:
        'Le texte mentionne que le mandat d’amener peut viser le mis en examen comme le témoin assisté.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Régime horaire',
    question:
        'L’agent chargé de l’exécution d’un mandat d’amener ne peut pénétrer dans le domicile d’un citoyen :',
    options: [
      'Qu’entre 6 heures et 21 heures, sauf dispositions particulières',
      'Qu’entre 8 heures et 18 heures',
      'À n’importe quelle heure sans restriction',
    ],
    answer: 'Qu’entre 6 heures et 21 heures, sauf dispositions particulières',
    explanation:
        'L’article 134 C.P.P. encadre strictement les horaires d’introduction dans un lieu d’habitation.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Rapport écrit',
    question:
        'Lorsque l’agent n’a pas trouvé la personne faisant l’objet d’un mandat d’amener, il doit :',
    options: [
      'Rien faire, le mandat reste valable indéfiniment',
      'Dresser un procès-verbal de perquisition et de recherches infructueuses',
      'Rédiger un simple mot manuscrit sans valeur juridique',
    ],
    answer:
        'Dresser un procès-verbal de perquisition et de recherches infructueuses',
    explanation:
        'L’article 134 C.P.P. impose un procès-verbal lorsque la personne recherchée n’est pas trouvée.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Règlement de l’information',
    question:
        'Après le règlement de l’information, le mandat d’arrêt conserve :',
    options: [
      'Aucune force exécutoire',
      'Sa force exécutoire tant qu’il n’a pas été retiré',
      'Une force limitée aux frontières du département',
    ],
    answer: 'Sa force exécutoire tant qu’il n’a pas été retiré',
    explanation:
        'L’article 179 C.P.P. précise que le mandat d’arrêt conserve sa force après le règlement de l’information.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Personnes condamnées',
    question:
        'Le juge de l’application des peines peut décerner un mandat d’arrêt :',
    options: [
      'Contre une personne condamnée à un suivi socio-judiciaire qui ne respecte pas ses obligations',
      'Uniquement contre un prévenu avant jugement',
      'Uniquement en cas de contravention routière',
    ],
    answer:
        'Contre une personne condamnée à un suivi socio-judiciaire qui ne respecte pas ses obligations',
    explanation:
        'Le texte mentionne cette hypothèse de mandat d’arrêt décerné par le JAP (art. 712-17 ou 763-5 C.P.P. selon les cas).',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de dépôt — Chambre de l’instruction',
    question:
        'La chambre de l’instruction peut décerner un mandat de dépôt ou d’arrêt lorsque :',
    options: [
      'Elle est saisie de l’appel d’une ordonnance du JLD ou du juge d’instruction',
      'Elle statue sur un simple litige civil',
      'Elle examine un recours administratif',
    ],
    answer:
        'Elle est saisie de l’appel d’une ordonnance du JLD ou du juge d’instruction',
    explanation:
        'Dans le cadre de l’appel, la chambre peut ordonner, maintenir ou lever les mandats concernés.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandats — Discipline des magistrats',
    question:
        'Les sanctions disciplinaires contre un juge d’instruction ou un JLD pour irrégularités de mandats :',
    options: [
      'Peuvent être prononcées selon les règles du statut de la magistrature',
      'Sont décidées par les policiers',
      'Sont automatiques dès qu’une nullité est prononcée',
    ],
    answer:
        'Peuvent être prononcées selon les règles du statut de la magistrature',
    explanation:
        'Le statut de la magistrature fixe les règles disciplinaires applicables aux juges.',
    difficulty: 'Moyen',
  ),

  // =====================================================
  // QUESTIONS SUPPLÉMENTAIRES — NIVEAU 3 (DIFFICILE)
  // =====================================================
  QuizQuestion(
    category: 'Mandats — Cas avancés',
    question:
        'Une personne est appréhendée sous mandat d’amener, à plus de 200 km du siège du juge d’instruction mandant. Faute de pouvoir l’interroger immédiatement, le magistrat local :',
    options: [
      'Doit la placer en détention sans délai',
      'Peut la retenir au maximum 24 heures en lui faisant bénéficier des droits de la garde à vue',
      'Doit immédiatement la remettre en liberté sans aucune formalité',
    ],
    answer:
        'Peut la retenir au maximum 24 heures en lui faisant bénéficier des droits de la garde à vue',
    explanation:
        'Les articles 133-1 et suivants organisent cette “retenue” avec les mêmes droits que la garde à vue.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Transfert après mandat d’amener',
    question:
        'Lorsque le JLD prolonge la retenue d’une personne appréhendée hors du ressort du juge d’instruction, le transfert vers la maison d’arrêt désignée sur le mandat doit intervenir :',
    options: [
      'Dans un délai de quatre jours au plus à compter de la notification du mandat, sauf circonstances insurmontables',
      'Sans aucun délai, à la convenance de l’administration',
      'Uniquement si la personne donne son accord écrit',
    ],
    answer:
        'Dans un délai de quatre jours au plus à compter de la notification du mandat, sauf circonstances insurmontables',
    explanation:
        'Ces délais visent à éviter des détentions arbitraires prolongées en simple attente de transfert.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Présentation au JLD',
    question:
        'Lorsqu’une personne recherchée sous mandat d’arrêt est arrêtée à plus de 200 km du siège du magistrat mandant, elle doit être présentée :',
    options: [
      'Au juge d’instruction mandant dans les 6 heures',
      'À un juge ou JLD du ressort de l’arrestation dans les 24 heures',
      'Uniquement au procureur de la République',
    ],
    answer: 'À un juge ou JLD du ressort de l’arrestation dans les 24 heures',
    explanation:
        'Les articles 127 et 133 C.P.P. prévoient cette présentation devant un magistrat local avant le transfert.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Vidéo-audience',
    question:
        'Selon l’article 135-2 C.P.P., le recours à la visioconférence pour l’audition d’une personne détenue sous mandat d’arrêt :',
    options: [
      'Est toujours obligatoire',
      'Est possible mais suppose que la personne ne s’y oppose pas lorsqu’elle encourt une peine criminelle',
      'Ne peut jamais être utilisé',
    ],
    answer:
        'Est possible mais suppose que la personne ne s’y oppose pas lorsqu’elle encourt une peine criminelle',
    explanation:
        'Le texte encadre l’usage de la visioconférence pour respecter les droits de la défense.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Personne en fuite',
    question:
        'Les recherches d’une personne en fuite faisant l’objet d’un mandat d’arrêt peuvent être confiées :',
    options: [
      'À des services spécialisés de police judiciaire, y compris pour la surveillance téléphonique',
      'Uniquement à la police municipale',
      'Uniquement au procureur général',
    ],
    answer:
        'À des services spécialisés de police judiciaire, y compris pour la surveillance téléphonique',
    explanation:
        'Les textes prévoient que des services spécialisés peuvent être requis, y compris via les moyens modernes de télécommunications (art. 74-2 C.P.P. et s.).',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat de dépôt — Exécution',
    question:
        'En exécution d’un mandat de dépôt, la notification de l’ordonnance de placement en détention provisoire :',
    options: [
      'Vaut notification du mandat de dépôt lui-même',
      'Doit être distincte et répétée au moment de l’arrivée à la maison d’arrêt',
      'N’a aucune importance juridique',
    ],
    answer: 'Vaut notification du mandat de dépôt lui-même',
    explanation:
        'La loi prévoit que la notification de l’ordonnance de placement vaut notification du mandat de dépôt.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Nullité et droits de la défense',
    question:
        'Parmi les irrégularités suivantes, laquelle est la plus susceptible d’entraîner la nullité du mandat lui-même ?',
    options: [
      'Une simple faute d’orthographe dans le texte du mandat',
      'L’absence totale de mention de la qualification juridique des faits pour un mandat d’arrêt',
      'Un léger retard de quelques minutes dans la notification',
    ],
    answer:
        'L’absence totale de mention de la qualification juridique des faits pour un mandat d’arrêt',
    explanation:
        'Cette omission touche aux mentions substantielles exigées par l’article 123 C.P.P. et peut porter atteinte aux droits de la défense.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Responsabilité du greffier',
    question:
        'Le greffier est responsable de la régularité formelle des mandats. S’il laisse partir un mandat sans sceau ni signature :',
    options: [
      'Il commet une faute susceptible d’engager sa responsabilité disciplinaire',
      'Cela n’a aucune conséquence',
      'La responsabilité incombe uniquement au policier qui l’exécute',
    ],
    answer:
        'Il commet une faute susceptible d’engager sa responsabilité disciplinaire',
    explanation:
        'Le greffier doit veiller à la régularité externe de l’acte ; sa négligence peut faire l’objet de sanctions internes.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Détention arbitraire et responsabilité',
    question:
        'Un juge d’instruction laisse volontairement une personne en détention au-delà des délais légaux après un mandat d’amener. Il peut être poursuivi sur le fondement :',
    options: [
      'Des articles 432-4 à 432-6 du Code pénal, relatifs à la détention arbitraire',
      'Uniquement pour négligence civile',
      'D’aucun texte spécifique',
    ],
    answer:
        'Des articles 432-4 à 432-6 du Code pénal, relatifs à la détention arbitraire',
    explanation:
        'L’article 126 C.P.P. renvoie explicitement à ces dispositions pour sanctionner les détentions arbitraires.',
    difficulty: 'Difficile',
  ),

  // =====================================================
  // SALVE SUPPLÉMENTAIRE — NIVEAU 1 (FACILE)
  // =====================================================
  QuizQuestion(
    category: 'Mandats de justice — Notions générales',
    question:
        'Quel article du C.P.P. énumère les cinq types de mandats de justice ?',
    options: ['Article 122', 'Article 63-1', 'Article 706-54'],
    answer: 'Article 122',
    explanation:
        'L’article 122 alinéa 1 du C.P.P. énumère les cinq mandats : recherche, comparution, amener, dépôt et arrêt.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Notions générales',
    question: 'Les mandats de justice sont principalement utilisés par :',
    options: [
      'Le juge d’instruction',
      'Le juge de l’application des peines exclusivement',
      'Le préfet',
    ],
    answer: 'Le juge d’instruction',
    explanation:
        'Le texte précise qu’ils sont principalement utilisés par le juge d’instruction, même si d’autres juridictions peuvent en décerner.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Non-délégation',
    question:
        'Pourquoi dit-on que les mandats de justice sont des actes « incommunicables » ?',
    options: [
      'Parce qu’on ne peut pas les montrer au mis en examen',
      'Parce que le pouvoir de les délivrer ne peut pas être délégué par le magistrat',
      'Parce qu’ils ne sont jamais versés au dossier',
    ],
    answer:
        'Parce que le pouvoir de les délivrer ne peut pas être délégué par le magistrat',
    explanation:
        'Le juge d’instruction ne peut pas transmettre à un autre la compétence de décerner un mandat dans le cadre d’une commission rogatoire.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats — Contenu minimal',
    question: 'Pour être valable, tout mandat doit au minimum contenir :',
    options: [
      'Le nom du procureur général',
      'L’identité de la personne visée et la signature du magistrat',
      'Le numéro de matricule de l’OPJ',
    ],
    answer: 'L’identité de la personne visée et la signature du magistrat',
    explanation:
        'L’article 123 al. 1 exige l’identité de la personne et la signature du magistrat, le tout revêtu du sceau.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats — Types',
    question:
        'Lequel de ces documents correspond à un mandat de contrainte et non à une simple convocation ?',
    options: [
      'Mandat de comparution',
      'Convocation simple par officier de police judiciaire',
      'Invitation à se présenter à la mairie',
    ],
    answer: 'Mandat de comparution',
    explanation:
        'Le mandat de comparution est un acte judiciaire contraignant, à la différence d’une simple convocation.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de recherche — Finalité',
    question: 'La finalité d’un mandat de recherche est de :',
    options: [
      'Reporter une audience',
      'Rechercher une personne et la placer en garde à vue',
      'Confisquer les biens d’une personne',
    ],
    answer: 'Rechercher une personne et la placer en garde à vue',
    explanation:
        'Le mandat de recherche ordonne la recherche de la personne et son placement éventuel en garde à vue.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de comparution — Sanction du défaut de présentation',
    question:
        'Si la personne ne se présente pas à la date indiquée sur un mandat de comparution, le juge peut :',
    options: [
      'Ne rien faire',
      'Dresser un procès-verbal de non-comparution et décerner un mandat d’amener',
      'La déclarer immédiatement coupable',
    ],
    answer:
        'Dresser un procès-verbal de non-comparution et décerner un mandat d’amener',
    explanation:
        'Le mandat de comparution peut être suivi d’un mandat d’amener en cas de non-présentation.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Personne visée',
    question: 'Le mandat d’amener est destiné :',
    options: [
      'À une personne que l’on veut entendre comme mis en examen ou témoin assisté',
      'Uniquement à un juré de cour d’assises',
      'À un simple témoin de moralité',
    ],
    answer:
        'À une personne que l’on veut entendre comme mis en examen ou témoin assisté',
    explanation:
        'Il vise une personne susceptible d’être impliquée dans les faits et que le juge veut entendre.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Personne en fuite',
    question: 'Le mandat d’arrêt est particulièrement adapté lorsque :',
    options: [
      'La personne est domiciliée et se présente spontanément',
      'La personne est en fuite ou se trouve à l’étranger',
      'La procédure concerne une simple contravention',
    ],
    answer: 'La personne est en fuite ou se trouve à l’étranger',
    explanation:
        'C’est un titre de recherche et de détention pour les personnes qui se soustraient à la justice.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de dépôt — Qualité',
    question: 'Le mandat de dépôt permet :',
    options: [
      'De placer ou maintenir une personne en détention provisoire',
      'D’ordonner une simple garde à vue',
      'De prononcer une peine définitive',
    ],
    answer: 'De placer ou maintenir une personne en détention provisoire',
    explanation:
        'Il s’agit du titre de détention provisoire décerné par le juge ou le tribunal.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats — Territoire',
    question: 'Les mandats de justice sont exécutoires :',
    options: [
      'Uniquement dans la ville où ils sont émis',
      'Dans toute la France, y compris outre-mer',
      'Uniquement dans le ressort de la cour d’appel',
    ],
    answer: 'Dans toute la France, y compris outre-mer',
    explanation:
        'Ils ont vocation à s’appliquer sur l’ensemble du territoire de la République.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats — Greffier',
    question: 'Le greffier, en matière de mandats, doit notamment vérifier :',
    options: [
      'Que le mandat est signé, daté, revêtu du sceau et comporte les mentions obligatoires',
      'Que la personne est bien coupable',
      'Que le policier est disponible',
    ],
    answer:
        'Que le mandat est signé, daté, revêtu du sceau et comporte les mentions obligatoires',
    explanation:
        'C’est lui qui est responsable de la régularité formelle de l’acte.',
    difficulty: 'Facile',
  ),

  // =====================================================
  // SALVE SUPPLÉMENTAIRE — NIVEAU 2 (MOYEN)
  // =====================================================
  QuizQuestion(
    category: 'Mandat de recherche — Notification',
    question:
        'Lorsqu’une personne détenue pour une autre cause fait l’objet d’un mandat de recherche, la notification du mandat :',
    options: [
      'Doit lui être faite au plus tard lors de sa remise en liberté',
      'Est inutile car elle est déjà détenue',
      'Est remplacée par un simple appel téléphonique',
    ],
    answer: 'Doit lui être faite au plus tard lors de sa remise en liberté',
    explanation:
        'L’article 123 C.P.P. prévoit une notification même lorsqu’une personne est déjà détenue pour une autre cause.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de recherche — Effets selon l’auteur',
    question:
        'Lorsque le mandat de recherche est délivré par le procureur de la République et que la personne n’est pas découverte :',
    options: [
      'Le mandat prend fin automatiquement sans suite',
      'Le procureur peut requérir l’ouverture d’une information contre personne non dénommée',
      'La personne est déclarée coupable par défaut',
    ],
    answer:
        'Le procureur peut requérir l’ouverture d’une information contre personne non dénommée',
    explanation:
        'Le mandat de recherche peut déboucher sur l’ouverture d’une information si la personne n’est pas retrouvée.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de comparution — Public visé',
    question:
        'Pourquoi le mandat de comparution ne vise-t-il en principe pas les personnes supposées en fuite ?',
    options: [
      'Parce qu’il n’est pas exécutoire',
      'Parce qu’il repose sur l’idée que la personne est domiciliée et ne cherche pas à se soustraire à la justice',
      'Parce qu’il n’est possible que pour les témoins',
    ],
    answer:
        'Parce qu’il repose sur l’idée que la personne est domiciliée et ne cherche pas à se soustraire à la justice',
    explanation:
        'En cas de crainte de fuite, le juge optera plutôt pour un mandat d’amener ou d’arrêt.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de comparution — Exécution',
    question:
        'Dans la pratique, lorsque la personne visée par un mandat de comparution est introuvable à l’adresse indiquée :',
    options: [
      'Le mandat est réputé exécuté',
      'L’agent dresse un procès-verbal d’impossibilité de notification',
      'La personne est immédiatement recherchée sur tout le territoire par mandat d’arrêt',
    ],
    answer: 'L’agent dresse un procès-verbal d’impossibilité de notification',
    explanation:
        'Ce PV permet au magistrat de décider ensuite d’un éventuel mandat d’amener ou d’arrêt.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Conversion depuis un mandat de comparution',
    question: 'Le plus souvent, un mandat d’amener est décerné :',
    options: [
      'Directement, sans autre acte préalable',
      'Après l’échec d’un mandat de comparution ou d’une convocation restée sans effet',
      'Exclusivement à la demande de la victime',
    ],
    answer:
        'Après l’échec d’un mandat de comparution ou d’une convocation restée sans effet',
    explanation:
        'C’est la logique graduée des mesures de contrainte : comparution, puis amener, puis éventuellement arrestation.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Force utilisée',
    question:
        'L’article 134 du C.P.P. précise que la force utilisée pour exécuter un mandat d’amener :',
    options: [
      'Peut être illimitée si nécessaire',
      'Doit être strictement proportionnée et la plus douce possible pour assurer l’exécution',
      'Est laissée à l’appréciation libre de l’OPJ sans contrôle',
    ],
    answer:
        'Doit être strictement proportionnée et la plus douce possible pour assurer l’exécution',
    explanation:
        'L’usage de la force est encadré pour respecter les droits fondamentaux.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Formules d’arrestation',
    question:
        'Les formalités d’arrestation applicables lors de l’exécution d’un mandat d’arrêt (article 133 C.P.P.) imposent notamment :',
    options: [
      'La lecture intégrale du C.P.P.',
      'L’information de la personne sur l’existence du mandat et la nature des faits reprochés',
      'L’obligation de menotter la personne quelles que soient les circonstances',
    ],
    answer:
        'L’information de la personne sur l’existence du mandat et la nature des faits reprochés',
    explanation:
        'La personne doit savoir pourquoi elle est arrêtée et sur quel titre.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Maintien en rétention',
    question:
        'Lorsqu’une personne arrêtée sous mandat d’arrêt est retenue 24 heures avant d’être conduite devant le juge :',
    options: [
      'Elle ne bénéficie d’aucun droit spécifique',
      'Elle bénéficie des droits de la garde à vue (médecin, avocat, information d’un proche)',
      'Elle doit obligatoirement être mise en isolement',
    ],
    answer:
        'Elle bénéficie des droits de la garde à vue (médecin, avocat, information d’un proche)',
    explanation:
        'L’article 133-1 renvoie aux garanties de la garde à vue pendant cette période.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de dépôt — Notification',
    question:
        'Pourquoi dit-on que la notification de l’ordonnance de placement en détention provisoire vaut notification du mandat de dépôt ?',
    options: [
      'Pour éviter une double notification inutile',
      'Parce que le mandat de dépôt n’a pas à être lu à la personne',
      'Parce que la personne n’a pas le droit de prendre connaissance de la décision',
    ],
    answer: 'Pour éviter une double notification inutile',
    explanation:
        'La décision de placement en détention et le mandat de dépôt sont liés, la loi simplifie la procédure en fusionnant les notifications.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandats — Nullité et défense',
    question:
        'Une irrégularité dans la délivrance d’un mandat n’entraîne nullité qu’à condition :',
    options: [
      'Qu’elle soit substantielle et ait porté atteinte aux droits de la défense',
      'Qu’elle soit simplement mentionnée par l’avocat',
      'Qu’elle ait été commise par un policier',
    ],
    answer:
        'Qu’elle soit substantielle et ait porté atteinte aux droits de la défense',
    explanation:
        'La jurisprudence conditionne la nullité à une atteinte réelle aux droits de la défense.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandats — Discipline et pénal',
    question:
        'En cas de détention arbitraire liée à un dépassement injustifié des délais de présentation après mandat d’amener :',
    options: [
      'Seule la responsabilité disciplinaire peut être engagée',
      'La responsabilité pénale des magistrats ou fonctionnaires peut être engagée sur le fondement des articles 432-4 à 432-6 du Code pénal',
      'Aucune responsabilité n’est possible',
    ],
    answer:
        'La responsabilité pénale des magistrats ou fonctionnaires peut être engagée sur le fondement des articles 432-4 à 432-6 du Code pénal',
    explanation:
        'L’article 126 C.P.P. vise expressément cette hypothèse de détention arbitraire.',
    difficulty: 'Moyen',
  ),

  // =====================================================
  // SALVE SUPPLÉMENTAIRE — NIVEAU 3 (DIFFICILE)
  // =====================================================
  QuizQuestion(
    category: 'Mandats — Cas pratiques complexes',
    question:
        'Un mandat d’arrêt a été délivré, mais l’acte ne mentionne pas la qualification juridique des faits alors que la loi l’exige. La personne arrêtée soulève l’irrégularité :',
    options: [
      'La nullité du mandat est envisageable car une mention substantielle fait défaut',
      'La nullité est impossible car il s’agit d’un simple oubli',
      'Le juge peut corriger oralement le mandat sans conséquence',
    ],
    answer:
        'La nullité du mandat est envisageable car une mention substantielle fait défaut',
    explanation:
        'L’absence de qualification juridique peut porter atteinte au droit d’être informé des faits reprochés, ce qui est substantiel.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Distance et transferts',
    question:
        'Une personne arrêtée à plus de 200 km du siège du juge d’instruction mandant reste 48 heures avant d’être présentée au JLD local. Quel est le risque principal ?',
    options: [
      'Aucun, le délai est purement indicatif',
      'Une contestation pour non-respect des délais prévus aux articles 127 et 133 C.P.P., pouvant entraîner une nullité de la rétention',
      'La nullité automatique du jugement à venir',
    ],
    answer:
        'Une contestation pour non-respect des délais prévus aux articles 127 et 133 C.P.P., pouvant entraîner une nullité de la rétention',
    explanation:
        'La loi encadre strictement les délais pour éviter les détentions arbitraires prolongées.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Interaction avec la garde à vue',
    question:
        'Une personne est arrêtée sous mandat de recherche et immédiatement placée en garde à vue. Pour être régulière, cette garde à vue :',
    options: [
      'Doit respecter les conditions de la garde à vue (indices, finalité, droits) en plus du mandat',
      'N’a plus aucune règle puisque le mandat existe',
      'Dispense l’OPJ de notifier les droits à la personne',
    ],
    answer:
        'Doit respecter les conditions de la garde à vue (indices, finalité, droits) en plus du mandat',
    explanation:
        'Le mandat ne dispense pas du respect intégral du régime de la garde à vue.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Recours et indemnisation',
    question:
        'Une personne obtient devant le premier président de la cour d’appel une indemnité pour détention irrégulière consécutive à un mandat d’arrêt. L’État décide de se retourner contre le dénonciateur de mauvaise foi. Ce recours :',
    options: [
      'Est prévu par les textes en cas de dénonciation mensongère ou de faux témoignage',
      'Est impossible car l’État ne peut jamais agir contre un particulier',
      'Annule automatiquement l’indemnité accordée',
    ],
    answer:
        'Est prévu par les textes en cas de dénonciation mensongère ou de faux témoignage',
    explanation:
        'Le texte mentionne explicitement que l’État dispose d’un recours contre le dénonciateur de mauvaise foi ou le faux témoin.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Hiérarchie des mesures',
    question:
        'Sur le plan théorique, comment peut-on classer les mandats de justice par intensité croissante de contrainte ?',
    options: [
      'Comparution → recherche → amener → dépôt → arrêt',
      'Recherche → comparution → amener → arrêt → dépôt',
      'Comparution → amener → arrestation/dépôt/arrêt (titres de détention)',
    ],
    answer:
        'Comparution → amener → arrestation/dépôt/arrêt (titres de détention)',
    explanation:
        'On passe de la convocation contrainte (comparution), à l’amenée forcée, puis aux titres de détention (dépôt/arrêt).',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Choix de l’outil procédural',
    question:
        'Dans une information criminelle, le juge d’instruction souhaite interroger un mis en examen qui reste au domicile mais refuse de se déplacer. Quel mandat est, en principe, le plus adapté ?',
    options: ['Mandat de comparution', 'Mandat d’amener', 'Mandat de dépôt'],
    answer: 'Mandat d’amener',
    explanation:
        'Le juge sait où se trouve la personne mais doit la faire conduire devant lui de manière contrainte.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Publicité et diffusion',
    question:
        'En matière de sécurité intérieure, certains mandats d’amener ou d’arrêt peuvent être inscrits au fichier des personnes recherchées. Cette inscription :',
    options: [
      'Transforme automatiquement le mandat en peine',
      'Permet la diffusion nationale mais ne change pas la nature du mandat lui-même',
      'Supprime les droits de la défense',
    ],
    answer:
        'Permet la diffusion nationale mais ne change pas la nature du mandat lui-même',
    explanation:
        'Il s’agit d’un outil d’exécution, pas d’une modification de la nature juridique de l’acte.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Cumul des irrégularités',
    question:
        'Plusieurs irrégularités mineures affectent un mandat (erreur de date, coquilles dans l’adresse) mais aucune n’a porté atteinte aux droits de la défense. La défense invoque la nullité du mandat :',
    options: [
      'La nullité sera probablement rejetée faute d’atteinte aux droits de la défense',
      'La nullité doit être prononcée automatiquement',
      'La nullité entraîne d’office la relaxe au fond',
    ],
    answer:
        'La nullité sera probablement rejetée faute d’atteinte aux droits de la défense',
    explanation:
        'La jurisprudence se montre stricte : l’irrégularité doit être substantielle et porter atteinte à la défense.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Interaction avec le contrôle judiciaire',
    question:
        'Une personne ne respecte pas de manière répétée les obligations de son contrôle judiciaire. Le juge d’instruction décide de la faire arrêter pour l’entendre sur ces manquements. L’outil procédural logique est :',
    options: [
      'Un mandat d’amener',
      'Un mandat de comparution',
      'Un simple avertissement écrit sans titre',
    ],
    answer: 'Un mandat d’amener',
    explanation:
        'Le juge souhaite l’entendre immédiatement sous contrainte, ce qui correspond à la logique du mandat d’amener.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Équilibre libertés / ordre public',
    question:
        'Sur le plan théorique, le recours aux mandats de justice s’analyse comme :',
    options: [
      'Une atteinte injustifiée aux libertés individuelles',
      'Un équilibre entre la nécessité de l’enquête et la protection des libertés, sous le contrôle de la loi et du juge',
      'Une mesure purement administrative',
    ],
    answer:
        'Un équilibre entre la nécessité de l’enquête et la protection des libertés, sous le contrôle de la loi et du juge',
    explanation:
        'Les mandats encadrent les atteintes à la liberté individuelle par des règles strictes de forme, de fond et de contrôle juridictionnel.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Recours et indemnisation',
    question:
        'Une personne a subi une détention jugée irrégulière à la suite d’un mandat. Elle obtient une indemnisation. L’État :',
    options: [
      'Ne peut jamais agir contre quiconque',
      'Peut exercer un recours contre le dénonciateur de mauvaise foi ou le faux témoin',
      'Doit indemniser également le dénonciateur',
    ],
    answer:
        'Peut exercer un recours contre le dénonciateur de mauvaise foi ou le faux témoin',
    explanation:
        'La loi autorise l’État à se retourner contre l’auteur de la dénonciation mensongère ayant provoqué la détention.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Notions générales',
    question:
        'Parmi ces propositions, lequel N’EST PAS un type de mandat de justice ?',
    options: [
      'Mandat de recherche',
      'Mandat de dépôt',
      'Mandat de contrôle judiciaire',
    ],
    answer: 'Mandat de contrôle judiciaire',
    explanation:
        'Les cinq mandats sont : recherche, comparution, amener, dépôt, arrêt. Il n’existe pas de “mandat de contrôle judiciaire”.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Notions générales',
    question:
        'Les mandats de justice sont des actes incommunicables, c’est-à-dire :',
    options: [
      'Qu’ils ne peuvent pas être montrés à la personne concernée',
      'Qu’ils sont non délégables, le magistrat ne peut pas déléguer son pouvoir de les décerner',
      'Qu’ils ne sont pas versés au dossier de la procédure',
    ],
    answer:
        'Qu’ils sont non délégables, le magistrat ne peut pas déléguer son pouvoir de les décerner',
    explanation:
        'Le texte précise que les mandats sont des actes incommunicables au sens où le pouvoir de les décerner ne peut être délégué.',
    difficulty: 'Facile',
  ),

  // PRINCIPES GÉNÉRAUX — FORME
  QuizQuestion(
    category: 'Mandats de justice — Principes généraux',
    question:
        'Tout mandat doit préciser l’identité de la personne à l’encontre de laquelle il est décerné et :',
    options: [
      'Être signé et revêtu du sceau du magistrat qui le délivre',
      'Être validé par le préfet',
      'Être enregistré au registre du commerce',
    ],
    answer: 'Être signé et revêtu du sceau du magistrat qui le délivre',
    explanation:
        'L’article 123 alinéa 1 du C.P.P. impose que le mandat soit signé par le magistrat et revêtu de son sceau.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Principes généraux',
    question:
        'Les mandats d’amener, de dépôt, d’arrêt ou de recherche doivent mentionner :',
    options: [
      'La nature des faits imputés, leur qualification juridique et les textes applicables',
      'Uniquement le nom de la victime',
      'Uniquement la date de la prochaine audience',
    ],
    answer:
        'La nature des faits imputés, leur qualification juridique et les textes applicables',
    explanation:
        'Pour ces mandats, la loi exige l’indication des faits, de leur qualification et des textes pénaux applicables.',
    difficulty: 'Facile',
  ),

  // MANDAT DE RECHERCHE — DÉFINITION
  QuizQuestion(
    category: 'Mandat de recherche — Notions de base',
    question: 'Le mandat de recherche est défini comme :',
    options: [
      'Un ordre de conduire immédiatement une personne devant le juge',
      'Un ordre donné à la force publique de rechercher une personne et de la placer en garde à vue',
      'Un ordre de convoquer un témoin à une audience',
    ],
    answer:
        'Un ordre donné à la force publique de rechercher une personne et de la placer en garde à vue',
    explanation:
        'Le mandat de recherche ordonne de rechercher la personne et de la placer en garde à vue (art. 122 al. 2 C.P.P.).',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de recherche — Personnes visées',
    question: 'Le mandat de recherche peut être délivré contre :',
    options: [
      'Une personne mise en examen',
      'Un simple passant sans aucune raison',
      'Uniquement un témoin',
    ],
    answer: 'Une personne mise en examen',
    explanation:
        'Il peut viser le mis en examen, le témoin assisté ou la personne visée par un réquisitoire nominatif.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de recherche — Personnes visées',
    question:
        'Outre le mis en examen, le mandat de recherche peut être délivré contre :',
    options: ['Le témoin assisté', 'L’avocat de la personne', 'Le greffier'],
    answer: 'Le témoin assisté',
    explanation:
        'Le texte indique qu’il peut viser le mis en examen, le témoin assisté ou la personne visée par un réquisitoire nominatif.',
    difficulty: 'Facile',
  ),

  // MANDAT DE COMPARUTION — DÉFINITION
  QuizQuestion(
    category: 'Mandat de comparution — Notions de base',
    question: 'Le mandat de comparution a pour objet de :',
    options: [
      'Faire rechercher une personne en fuite',
      'Faire comparaître une personne devant le juge à une date et une heure indiquées',
      'Placer immédiatement la personne en détention',
    ],
    answer:
        'Faire comparaître une personne devant le juge à une date et une heure indiquées',
    explanation:
        'Le mandat de comparution ordonne à la personne de se présenter devant le juge à la date et l’heure fixées (art. 122 al. 4 C.P.P.).',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de comparution — Public visé',
    question:
        'Le mandat de comparution est surtout utilisé à l’égard de personnes :',
    options: [
      'Dont on suppose qu’elles sont en fuite',
      'Domiciliées et dont on ne craint pas la fuite',
      'Déjà détenues dans un autre établissement',
    ],
    answer: 'Domiciliées et dont on ne craint pas la fuite',
    explanation:
        'Il est utilisé pour des personnes domiciliées que l’on ne suppose pas en fuite.',
    difficulty: 'Facile',
  ),

  // MANDAT D’AMENER — DÉFINITION
  QuizQuestion(
    category: 'Mandat d’amener — Notions de base',
    question: 'Le mandat d’amener est l’ordre de :',
    options: [
      'Conduire immédiatement une personne devant le juge',
      'La maintenir en détention pendant toute la procédure',
      'La placer sous contrôle judiciaire',
    ],
    answer: 'Conduire immédiatement une personne devant le juge',
    explanation:
        'Le mandat d’amener ordonne de conduire immédiatement la personne devant le magistrat (art. 122 al. 5 C.P.P.).',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Nature',
    question: 'Le mandat d’amener est :',
    options: [
      'Une peine d’emprisonnement',
      'Une mesure de contrainte mais pas un titre de détention en soi',
      'Une simple convocation écrite',
    ],
    answer: 'Une mesure de contrainte mais pas un titre de détention en soi',
    explanation:
        'Le mandat d’amener n’est pas un titre de détention définitif, il a pour objet de présenter la personne devant la justice.',
    difficulty: 'Facile',
  ),

  // MANDAT D’ARRÊT — DÉFINITION
  QuizQuestion(
    category: 'Mandat d’arrêt — Notions de base',
    question: 'Le mandat d’arrêt est l’ordre :',
    options: [
      'D’assigner une personne à résidence',
      'D’arrêter une personne et de la conduire devant le juge d’instruction ou à la maison d’arrêt',
      'De simplement la convoquer à une date ultérieure',
    ],
    answer:
        'D’arrêter une personne et de la conduire devant le juge d’instruction ou à la maison d’arrêt',
    explanation:
        'Le mandat d’arrêt est un ordre de recherche, d’arrestation et de conduite devant le juge ou en détention (art. 122 al. 6 et art. 131 C.P.P.).',
    difficulty: 'Facile',
  ),

  // MANDAT DE DÉPÔT — DÉFINITION
  QuizQuestion(
    category: 'Mandat de dépôt — Notions de base',
    question: 'Le mandat de dépôt est avant tout :',
    options: [
      'Un titre de détention provisoire',
      'Une simple mesure de contrôle judiciaire',
      'Un mandat de perquisition',
    ],
    answer: 'Un titre de détention provisoire',
    explanation:
        'Le mandat de dépôt est le titre par lequel une personne est placée ou maintenue en détention provisoire.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Mandat de dépôt — Exécution',
    question: 'L’agent de la force publique qui exécute un mandat de dépôt :',
    options: [
      'Décide de la durée de la détention',
      'Effectue une mission purement matérielle en conduisant la personne à la maison d’arrêt',
      'Peut modifier le lieu de détention comme il le souhaite',
    ],
    answer:
        'Effectue une mission purement matérielle en conduisant la personne à la maison d’arrêt',
    explanation:
        'Il ne fait qu’exécuter matériellement la décision de placement en détention et remet la personne au chef d’établissement.',
    difficulty: 'Facile',
  ),

  // SANCTIONS — PRINCIPES
  QuizQuestion(
    category: 'Mandats de justice — Sanctions',
    question:
        'Qui est considéré comme responsable de la régularité formelle des mandats ?',
    options: [
      'Le greffier',
      'Le chef d’escorte',
      'Le directeur de la maison d’arrêt',
    ],
    answer: 'Le greffier',
    explanation:
        'Le greffier doit s’assurer que les mandats sont régulièrement signés, datés, revêtus du sceau et comportent les mentions nécessaires.',
    difficulty: 'Facile',
  ),

  // =====================================================
  // NIVEAU 2 — MOYEN
  // =====================================================

  // PRINCIPES — DIFFUSION ET FORMES
  QuizQuestion(
    category: 'Mandats de justice — Principes (niveau 2)',
    question:
        'En cas d’urgence, les mandats d’amener, d’arrêt et de recherche peuvent être diffusés :',
    options: [
      'Par simple texto d’un policier',
      'Par tous moyens, notamment télégramme, télécopie ou voie électronique',
      'Uniquement par courrier recommandé',
    ],
    answer:
        'Par tous moyens, notamment télégramme, télécopie ou voie électronique',
    explanation:
        'Le texte précise que ces mandats peuvent être diffusés par tous moyens en cas d’urgence (art. 123 al. 6 C.P.P.).',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandats de justice — Principes (niveau 2)',
    question: 'Les mandats sont des actes individuels, cela signifie que :',
    options: [
      'Ils ne concernent qu’une seule personne par mandat',
      'Ils peuvent viser plusieurs personnes à la fois',
      'Ils sont valables pour tout le département',
    ],
    answer: 'Ils ne concernent qu’une seule personne par mandat',
    explanation:
        'Chaque mandat doit viser une personne déterminée avec ses mentions d’identité.',
    difficulty: 'Moyen',
  ),

  // MANDAT DE RECHERCHE — REMARQUES
  QuizQuestion(
    category: 'Mandat de recherche — Délivrance (niveau 2)',
    question:
        'Selon l’article 70 du C.P.P., le procureur de la République peut décerner un mandat de recherche :',
    options: [
      'Uniquement en cas de crime',
      'Lorsqu’une enquête porte sur un crime ou un délit flagrant puni d’au moins trois ans d’emprisonnement',
      'Uniquement après l’ouverture d’une information judiciaire',
    ],
    answer:
        'Lorsqu’une enquête porte sur un crime ou un délit flagrant puni d’au moins trois ans d’emprisonnement',
    explanation:
        'Le texte précise que le procureur peut délivrer un mandat de recherche en enquête lorsque la gravité des faits le justifie.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de recherche — Agents habilités',
    question:
        'L’exécution d’un mandat de recherche est notifiée et exécutée par :',
    options: [
      'Tout citoyen',
      'Un officier ou agent de police judiciaire ou un agent de la force publique',
      'Uniquement le juge d’instruction',
    ],
    answer:
        'Un officier ou agent de police judiciaire ou un agent de la force publique',
    explanation:
        'L’article 123 al. 4 C.P.P. prévoit que ces agents notifient et exécutent les mandats.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat de recherche — Effets',
    question:
        'Lorsque le mandat de recherche est délivré par le juge d’instruction et que la personne est découverte, elle est alors :',
    options: [
      'Simplement entendue comme témoin',
      'Considérée comme personne mise en examen',
      'Automatiquement jugée',
    ],
    answer: 'Considérée comme personne mise en examen',
    explanation:
        'Le texte indique qu’en cas de découverte au cours de l’instruction, la personne visée par un mandat de recherche du juge d’instruction est mise en examen.',
    difficulty: 'Moyen',
  ),

  // MANDAT DE COMPARUTION — NON-COMPARUTION
  QuizQuestion(
    category: 'Mandat de comparution — Non-présentation',
    question:
        'Si la personne ne se présente pas en exécution d’un mandat de comparution :',
    options: [
      'Le juge d’instruction ne peut rien faire',
      'Le juge dresse un procès-verbal de non-comparution et peut décerner un mandat d’amener',
      'La personne est automatiquement condamnée',
    ],
    answer:
        'Le juge dresse un procès-verbal de non-comparution et peut décerner un mandat d’amener',
    explanation:
        'Le juge apprécie la suite à donner : nouvelle tentative de comparution ou mandat d’amener.',
    difficulty: 'Moyen',
  ),

  // MANDAT D’AMENER — PERSONNES VISÉES ET CONDITIONS
  QuizQuestion(
    category: 'Mandat d’amener — Délivrance (niveau 2)',
    question:
        'Le mandat d’amener peut être décerné à l’encontre d’une personne :',
    options: [
      'Dont il existe des indices graves ou concordants rendant vraisemblable sa participation à l’infraction',
      'Uniquement déjà condamnée',
      'Uniquement témoin neutre',
    ],
    answer:
        'Dont il existe des indices graves ou concordants rendant vraisemblable sa participation à l’infraction',
    explanation:
        'Le mandat d’amener vise une personne soupçonnée sur la base d’indices graves ou concordants.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Diffusion',
    question: 'En principe, le mandat d’amener n’a pas vocation à être :',
    options: [
      'Exécuté par la police judiciaire',
      'Diffusé de façon générale comme un mandat d’arrêt',
      'Signé par le juge',
    ],
    answer: 'Diffusé de façon générale comme un mandat d’arrêt',
    explanation:
        'Le mandat d’amener concerne en principe des personnes domiciliées et n’a pas une diffusion générale.',
    difficulty: 'Moyen',
  ),

  // RÈGLES D’EXÉCUTION — PERQUISITION
  QuizQuestion(
    category: 'Mandats — Exécution (niveau 2)',
    question:
        'Selon l’article 134 du C.P.P., l’agent chargé d’exécuter un mandat d’amener, d’arrêt ou de recherche :',
    options: [
      'Ne peut jamais pénétrer au domicile',
      'Peut se rendre au domicile dans le respect des heures légales de perquisition',
      'Peut perquisitionner à toute heure sans restriction',
    ],
    answer:
        'Peut se rendre au domicile dans le respect des heures légales de perquisition',
    explanation:
        'L’introduction coercitive dans un lieu privé doit respecter les heures légales et les règles de perquisition.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandats — Exécution (niveau 2)',
    question:
        'La perquisition effectuée lors de l’exécution d’un mandat d’amener ou de recherche :',
    options: [
      'Permet toutes saisies éventuelles dans les lieux visités',
      'Ne peut tendre qu’à la découverte de la personne recherchée et des éléments utiles aux investigations',
      'N’est jamais autorisée',
    ],
    answer:
        'Ne peut tendre qu’à la découverte de la personne recherchée et des éléments utiles aux investigations',
    explanation:
        'La perquisition est strictement encadrée et doit être en lien avec l’objet du mandat.',
    difficulty: 'Moyen',
  ),

  // MANDAT D’ARRÊT — SITUATIONS PARTICULIÈRES
  QuizQuestion(
    category: 'Mandat d’arrêt — Conditions (niveau 2)',
    question: 'Le mandat d’arrêt peut être décerné notamment à l’encontre :',
    options: [
      'D’une personne en fuite hors du territoire',
      'D’un simple témoin',
      'D’un avocat dans l’exercice de ses fonctions',
    ],
    answer: 'D’une personne en fuite hors du territoire',
    explanation:
        'Il est notamment décerné en cas de fuite de la personne à l’étranger ou d’inobservation de certaines obligations.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Notifications',
    question:
        'Les agents habilités à notifier et exécuter un mandat d’arrêt sont :',
    options: [
      'Les mêmes que pour le mandat d’amener (OPJ, APJ, agents de la force publique)',
      'Uniquement les douaniers',
      'Uniquement les maires',
    ],
    answer:
        'Les mêmes que pour le mandat d’amener (OPJ, APJ, agents de la force publique)',
    explanation:
        'Les règles de notification/exécution sont alignées sur celles du mandat d’amener (art. 123, art. 188 C.P.P.).',
    difficulty: 'Moyen',
  ),

  // MANDAT DE DÉPÔT — TRIBUNAL CORRECTIONNEL
  QuizQuestion(
    category: 'Mandat de dépôt — Tribunal correctionnel',
    question:
        'Le tribunal correctionnel peut décerner un mandat de dépôt contre un prévenu :',
    options: [
      'Uniquement pour une contravention',
      'Encourant une peine d’emprisonnement égale ou supérieure à deux ans',
      'Uniquement en cas de relaxe',
    ],
    answer:
        'Encourant une peine d’emprisonnement égale ou supérieure à deux ans',
    explanation:
        'Les textes (art. 410-1 C.P.P.) prévoient cette possibilité lorsque le prévenu encourt au moins deux ans d’emprisonnement.',
    difficulty: 'Moyen',
  ),

  // SANCTIONS — NULLITÉS
  QuizQuestion(
    category: 'Mandats — Sanctions (niveau 2)',
    question:
        'Les irrégularités de forme commises lors de la délivrance d’un mandat peuvent entraîner :',
    options: [
      'La nullité du mandat lui-même si elles sont substantielles',
      'Jamais aucune conséquence',
      'La nullité automatique de toute la procédure pénale',
    ],
    answer: 'La nullité du mandat lui-même si elles sont substantielles',
    explanation:
        'Seules les irrégularités substantielles portant atteinte aux droits de la défense justifient la nullité du mandat.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Mandats — Sanctions (niveau 2)',
    question:
        'Les irrégularités commises lors de la notification ou de l’exécution d’un mandat entraînent en principe :',
    options: [
      'La nullité de l’exécution ou la caducité du mandat',
      'La nullité du jugement',
      'L’absence totale de sanction',
    ],
    answer: 'La nullité de l’exécution ou la caducité du mandat',
    explanation:
        'La jurisprudence distingue la nullité de l’acte lui-même et la nullité de son exécution.',
    difficulty: 'Moyen',
  ),

  // RESPONSABILITÉ PÉNALE DES MAGISTRATS
  QuizQuestion(
    category: 'Mandats — Responsabilité pénale',
    question:
        'Selon l’article 126 du C.P.P., les sanctions pénales des articles 432-4 à 432-6 du Code pénal s’appliquent :',
    options: [
      'Aux magistrats ou fonctionnaires qui ont ordonné ou toléré une détention arbitraire',
      'Aux simples témoins de l’infraction',
      'Uniquement aux avocats de la défense',
    ],
    answer:
        'Aux magistrats ou fonctionnaires qui ont ordonné ou toléré une détention arbitraire',
    explanation:
        'Ces dispositions visent notamment un dépassement injustifié des délais légaux d’interrogatoire après arrestation.',
    difficulty: 'Moyen',
  ),

  // =====================================================
  // NIVEAU 3 — DIFFICILE
  // =====================================================

  // CAS PRATIQUES — MANDAT DE RECHERCHE
  QuizQuestion(
    category: 'Mandats — Cas pratiques (niveau 3)',
    question:
        'Un mandat de recherche délivré par le procureur de la République dans le cadre d’une enquête n’a pas permis de retrouver la personne. Il n’y a aucun élément nominatif contre elle. Le procureur peut alors :',
    options: [
      'Ouvrir une information contre personne non dénommée',
      'Prononcer lui-même une peine d’emprisonnement',
      'Décider seul d’une détention provisoire',
    ],
    answer: 'Ouvrir une information contre personne non dénommée',
    explanation:
        'Le texte prévoit que le mandat de recherche peut déboucher sur l’ouverture d’une information contre personne non dénommée lorsque la personne n’est pas découverte.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Garde à vue et droits',
    question:
        'Lorsqu’une personne est retenue en vertu d’un mandat d’amener, les droits relatifs à la garde à vue lui sont reconnus, notamment :',
    options: [
      'Le droit d’être examinée par un médecin et assistée par un avocat',
      'Uniquement le droit à un repas',
      'Aucun droit particulier',
    ],
    answer: 'Le droit d’être examinée par un médecin et assistée par un avocat',
    explanation:
        'Les articles 63-3 et 63-3-1 à 63-4-4 C.P.P. sont applicables : médecin, avocat, information d’un proche, etc.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat d’amener — Délai de 24 heures',
    question:
        'En matière de mandat d’amener, le délai maximal de 24 heures prévu par l’article 128 du C.P.P. concerne :',
    options: [
      'Le temps dont dispose le juge d’instruction pour interroger la personne retenue',
      'La durée de la procédure devant la cour d’assises',
      'Le temps de transport de la maison d’arrêt vers le tribunal',
    ],
    answer:
        'Le temps dont dispose le juge d’instruction pour interroger la personne retenue',
    explanation:
        'Au-delà de 24 heures après arrestation, la personne doit être interrogée ou remise en liberté, sous peine de détention arbitraire.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Exécution à plus de 200 km',
    question:
        'Lorsqu’une personne arrêtée en vertu d’un mandat d’arrêt se trouve à plus de 200 km du siège du magistrat mandant, elle doit être présentée à un magistrat de ce ressort dans un délai maximal de :',
    options: ['12 heures', '24 heures', '48 heures'],
    answer: '24 heures',
    explanation:
        'Les articles 127 et suivants du C.P.P. prévoient un délai maximal de 24 heures pour la présentation devant un magistrat local.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Transfert ultérieur',
    question:
        'Après audition de la personne par le juge ou le JLD du lieu d’arrestation, le transfert vers la maison d’arrêt désignée par le mandat doit intervenir :',
    options: [
      'Dans les 4 jours (ou 6 jours en cas de changement de département) à compter de la notification du mandat, sauf circonstances insurmontables',
      'Sans aucun délai légal',
      'Uniquement avec l’accord écrit de la personne',
    ],
    answer:
        'Dans les 4 jours (ou 6 jours en cas de changement de département) à compter de la notification du mandat, sauf circonstances insurmontables',
    explanation:
        'Le texte prévoit des délais précis de transfert pour les personnes arrêtées loin du siège du juge mandant.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat d’arrêt — Après règlement de l’information',
    question:
        'Après règlement de l’information, l’exécution d’un mandat d’arrêt reste possible. Dans ce cas, la rétention de la personne par les services de police :',
    options: [
      'Est limitée à 24 heures avec application des droits de la garde à vue',
      'Peut durer indéfiniment jusqu’au jugement',
      'Ne peut jamais avoir lieu',
    ],
    answer:
        'Est limitée à 24 heures avec application des droits de la garde à vue',
    explanation:
        'L’article 179 et les articles 133-1 et suivants encadrent cette rétention postérieure au règlement de l’information.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat de dépôt — Comparution immédiate',
    question:
        'En procédure de comparution immédiate, le tribunal correctionnel peut décerner un mandat de dépôt lorsque :',
    options: [
      'Le prévenu encourt une peine d’amende',
      'Le prévenu encourt une peine d’emprisonnement et que les conditions de la détention provisoire sont réunies',
      'La victime le demande systématiquement',
    ],
    answer:
        'Le prévenu encourt une peine d’emprisonnement et que les conditions de la détention provisoire sont réunies',
    explanation:
        'Les articles 395 et suivants C.P.P. permettent au tribunal de délivrer un mandat de dépôt en comparution immédiate.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandat de dépôt — Trouble à l’audience',
    question:
        'En cas de trouble à l’audience, le président du tribunal correctionnel peut :',
    options: [
      'Uniquement expulser le perturbateur',
      'Placer sous mandat de dépôt le perturbateur qui résiste à un ordre d’expulsion ou cause du tumulte',
      'Rien faire, ce n’est pas prévu par la loi',
    ],
    answer:
        'Placer sous mandat de dépôt le perturbateur qui résiste à un ordre d’expulsion ou cause du tumulte',
    explanation:
        'L’article 404 C.P.P. prévoit cette possibilité pour garantir l’ordre de l’audience.',
    difficulty: 'Difficile',
  ),

  // SANCTIONS — DÉTENTION ARBITRAIRE
  QuizQuestion(
    category: 'Mandats — Détention arbitraire (niveau 3)',
    question:
        'En cas de dépassement injustifié du délai de 24 heures pour l’interrogatoire d’une personne arrêtée en vertu d’un mandat d’amener, la responsabilité pénale peut être engagée :',
    options: [
      'Du simple agent de police uniquement',
      'Du procureur de la République, du juge d’instruction ou du chef d’établissement pénitentiaire ayant ordonné ou toléré la détention arbitraire',
      'De la victime de l’infraction',
    ],
    answer:
        'Du procureur de la République, du juge d’instruction ou du chef d’établissement pénitentiaire ayant ordonné ou toléré la détention arbitraire',
    explanation:
        'L’article 126 C.P.P. renvoie aux articles 432-4 à 432-6 du Code pénal pour réprimer la détention arbitraire.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Nullités et indemnisation',
    question:
        'La jurisprudence admet que les irrégularités commises lors de la délivrance ou de l’exécution d’un mandat entraînent nullité ou indemnisation :',
    options: [
      'Uniquement si elles sont substantielles et portent atteinte aux droits de la défense',
      'Dans tous les cas, même pour des erreurs mineures sans conséquence',
      'Jamais, car les mandats sont insusceptibles de contestation',
    ],
    answer:
        'Uniquement si elles sont substantielles et portent atteinte aux droits de la défense',
    explanation:
        'Les nullités sont d’interprétation stricte ; l’indemnisation est accordée par le premier président de la cour d’appel.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Indemnisation',
    question:
        'L’indemnisation d’une détention irrégulière liée à un mandat est allouée :',
    options: [
      'Par le premier président de la cour d’appel',
      'Par le maire de la commune',
      'Par le chef de la police municipale',
    ],
    answer: 'Par le premier président de la cour d’appel',
    explanation:
        'Le texte mentionne que l’indemnisation est allouée par le premier président de la cour d’appel, avec recours possible de l’État contre le dénonciateur de mauvaise foi.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Mandats — Recours contre le dénonciateur',
    question:
        'Lorsque la détention résulte d’une dénonciation mensongère, l’État :',
    options: [
      'Dispose d’un recours contre le dénonciateur de mauvaise foi ou le faux témoin',
      'Ne peut jamais se retourner contre cette personne',
      'Doit indemniser le dénonciateur',
    ],
    answer:
        'Dispose d’un recours contre le dénonciateur de mauvaise foi ou le faux témoin',
    explanation:
        'Le texte indique expressément que l’État peut exercer un recours contre l’auteur de la dénonciation mensongère ayant provoqué la détention.',
    difficulty: 'Difficile',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizMandatsPage extends StatefulWidget {
  static const String routeName = '/gpx/procedure_penale/quiz/mandats_justice';
  final String uid;
  final String email;

  const QuizMandatsPage({super.key, required this.uid, required this.email});

  @override
  State<QuizMandatsPage> createState() => _QuizMandatsPageState();
}

class _QuizMandatsPageState extends State<QuizMandatsPage>
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
        ? questionsMandatsJustice
        : questionsMandatsJustice
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
            'module_name': 'Procédure Pénale',
            'quiz_name': 'Mandats justice',
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
      await _sb.from('quiz_mandats_justice').insert({
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
      debugPrint('❌ quiz_mandats_justice insert failed: $e');
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
