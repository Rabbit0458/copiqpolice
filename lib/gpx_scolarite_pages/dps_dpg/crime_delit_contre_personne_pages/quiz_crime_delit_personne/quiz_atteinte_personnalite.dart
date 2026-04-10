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

final List<QuizQuestion> questionAtteintePersonnalite = [
  // =========================================================
  // DÉNONCIATION CALOMNIEUSE — art. 226-10 CP
  // =========================================================
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Fondement',
    question: 'La dénonciation calomnieuse est définie et réprimée par :',
    options: [
      'L’article 226-10 du Code pénal',
      'L’article 226-13 du Code pénal',
      'L’article 226-1 du Code pénal',
    ],
    answer: 'L’article 226-10 du Code pénal',
    explanation:
        'Le cours indique que l’article 226-10 C.P. définit et réprime la dénonciation calomnieuse.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Définition',
    question:
        'La dénonciation calomnieuse suppose une dénonciation dirigée contre :',
    options: [
      'Une personne déterminée',
      'Une catégorie de personnes indéterminée',
      'Un fait sans lien avec une personne',
    ],
    answer: 'Une personne déterminée',
    explanation:
        'L’article 226-10 exige une dénonciation dirigée contre une personne déterminée (physique ou morale), identifiable.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Nature des faits',
    question:
        'Pour relever de la dénonciation calomnieuse, le fait dénoncé doit être :',
    options: [
      'De nature à entraîner des sanctions judiciaires, administratives ou disciplinaires',
      'Simplement désobligeant ou humiliant',
      'Uniquement une critique sur les réseaux sociaux',
    ],
    answer:
        'De nature à entraîner des sanctions judiciaires, administratives ou disciplinaires',
    explanation:
        'Le cours précise que la dénonciation doit être préjudiciable : le fait dénoncé doit être de nature à entraîner des sanctions.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Forme',
    question: 'La dénonciation calomnieuse peut être faite :',
    options: [
      'Par tout moyen (écrit ou oral)',
      'Uniquement par écrit',
      'Uniquement par plainte avec constitution de partie civile',
    ],
    answer: 'Par tout moyen (écrit ou oral)',
    explanation:
        'Le texte prévoit “par tout moyen” : lettre, plainte, pétition, oral, téléphone… sous réserve de preuve.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Moment de consommation',
    question:
        'Selon la jurisprudence, l’infraction est consommée et la prescription commence à courir :',
    options: [
      'Au jour de réception par le destinataire',
      'Au jour de rédaction de la dénonciation',
      'Au jour où la victime en a connaissance',
    ],
    answer: 'Au jour de réception par le destinataire',
    explanation:
        'Le cours indique que la jurisprudence retient la date de réception par l’autorité comme point de consommation et de départ de prescription.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Destinataire',
    question: 'La dénonciation doit être adressée notamment à une autorité :',
    options: [
      'Ayant le pouvoir de sanctionner ou de saisir l’autorité compétente',
      'Choisie au hasard sur internet',
      'Sans aucun lien avec la personne dénoncée',
    ],
    answer:
        'Ayant le pouvoir de sanctionner ou de saisir l’autorité compétente',
    explanation:
        'Le cours vise les autorités pouvant donner suite ou saisir l’autorité compétente, ainsi que supérieurs hiérarchiques/employeur.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Caractère spontané',
    question:
        'La jurisprudence exige que la dénonciation calomnieuse présente un caractère :',
    options: [
      'Spontané (initiative personnelle)',
      'Automatique dès qu’un tiers répète une rumeur',
      'Indifférent : provoquée ou non',
    ],
    answer: 'Spontané (initiative personnelle)',
    explanation:
        'Le cours précise que seule est coupable la personne ayant pris l’initiative : les dénonciations provoquées perdent le caractère spontané.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Dénonciation provoquée',
    question:
        'N’a pas le caractère spontané (donc, en principe, n’entre pas dans 226-10) la dénonciation :',
    options: [
      'Fait en réponse à une interpellation/une demande d’un supérieur ou d’une autorité',
      'Envoyée de sa propre initiative à l’employeur',
      'Adressée spontanément à un OPJ',
    ],
    answer:
        'Fait en réponse à une interpellation/une demande d’un supérieur ou d’une autorité',
    explanation:
        'Le cours indique que répondre à des questions ou rédiger un rapport sur demande fait perdre le caractère spontané.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Inexactitude',
    question:
        'L’infraction requiert que l’auteur sache que les faits dénoncés sont :',
    options: [
      'Totalement ou partiellement inexacts',
      'Simplement difficiles à prouver',
      'Vrais mais embarrassants',
    ],
    answer: 'Totalement ou partiellement inexacts',
    explanation:
        'Le cours reprend l’exigence : dénoncer un fait que l’on sait totalement ou partiellement inexact.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Preuve de la fausseté',
    question:
        'Depuis la réforme rappelée au cours (loi du 9 juillet 2010), la fausseté résulte nécessairement d’une décision définitive :',
    options: [
      'D’acquittement, de relaxe ou de non-lieu déclarant que le fait n’a pas été commis ou n’est pas imputable',
      'De classement sans suite',
      'De mise en examen',
    ],
    answer:
        'D’acquittement, de relaxe ou de non-lieu déclarant que le fait n’a pas été commis ou n’est pas imputable',
    explanation:
        'Le cours précise : acquittement/relaxe/non-lieu définitifs constatant expressément l’absence de fait ou d’imputabilité => fausseté automatique.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Autres cas',
    question:
        'Si la décision définitive est rendue faute de charges suffisantes, la fausseté du fait dénoncé est :',
    options: [
      'Appréciée par le tribunal saisi des poursuites contre le dénonciateur',
      'Automatiquement établie',
      'Impossible à discuter',
    ],
    answer:
        'Appréciée par le tribunal saisi des poursuites contre le dénonciateur',
    explanation:
        'Le cours indique que dans les autres cas (ex : faute de charges), le tribunal apprécie la pertinence des accusations.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Élément moral',
    question:
        'L’élément moral suppose notamment la conscience, au moment de la dénonciation :',
    options: [
      'De dénoncer des faits inexacts',
      'D’exercer une liberté d’expression générale',
      'D’être seulement imprudent',
    ],
    answer: 'De dénoncer des faits inexacts',
    explanation:
        'Le cours souligne que l’auteur doit connaître l’inexactitude des faits au jour de la dénonciation.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Découverte après coup',
    question:
        'Si l’auteur découvre après coup son erreur (il croyait les faits vrais au moment de dénoncer), alors :',
    options: [
      'L’infraction de dénonciation calomnieuse n’est pas constituée',
      'L’infraction est constituée automatiquement',
      'Seule la tentative est constituée',
    ],
    answer: 'L’infraction de dénonciation calomnieuse n’est pas constituée',
    explanation:
        'Le cours précise : il faut la connaissance de l’inexactitude au moment de dénoncer. L’erreur découverte après coup exclut 226-10.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Peines',
    question:
        'Pour une personne physique, la dénonciation calomnieuse (forme simple) est punie de :',
    options: [
      '5 ans d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le tableau du cours indique : délit, art. 226-10, 5 ans + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Tentative',
    question: 'La tentative de dénonciation calomnieuse est :',
    options: [
      'Non punissable (tentative : non)',
      'Toujours punissable',
      'Punissable uniquement en cas de diffusion en ligne',
    ],
    answer: 'Non punissable (tentative : non)',
    explanation:
        'Le cours mentionne explicitement : TENTATIVE : NON pour l’art. 226-10.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Complicité',
    question: 'La complicité de dénonciation calomnieuse est :',
    options: [
      'Punissable (articles 121-6 et 121-7 C.P.)',
      'Non punissable car délit d’opinion',
      'Punissable uniquement pour l’aide matérielle',
    ],
    answer: 'Punissable (articles 121-6 et 121-7 C.P.)',
    explanation:
        'Le cours rappelle : complicité oui, selon 121-6 et 121-7 (aide/assistance, provocation, instructions).',
    difficulty: 'Moyen',
  ),

  // =========================================================
  // PORNODIVULGATION — art. 226-2-1 al.2 CP
  // =========================================================
  QuizQuestion(
    category: 'Pornodivulgation — Fondement',
    question:
        'La diffusion, sans accord, d’un enregistrement à caractère sexuel obtenu avec consentement est prévue par :',
    options: [
      'L’article 226-2-1 alinéa 2 du Code pénal',
      'L’article 226-1 du Code pénal',
      'L’article 226-8 du Code pénal',
    ],
    answer: 'L’article 226-2-1 alinéa 2 du Code pénal',
    explanation:
        'Le cours vise l’art. 226-2-1 al.2 C.P. pour la diffusion sans accord d’un contenu sexuel obtenu avec consentement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Notion',
    question: 'Le terme “revenge porn” correspond en France à :',
    options: [
      'La pornodivulgation',
      'La dénonciation calomnieuse',
      'La violation de domicile',
    ],
    answer: 'La pornodivulgation',
    explanation:
        'Le cours explique que ces agissements ont été popularisés sous “revenge porn”, aujourd’hui aussi appelé pornodivulgation.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Support',
    question: 'Peuvent constituer le support matériel de la pornodivulgation :',
    options: [
      'Photo, vidéo, audio ou échanges de messages (sexting)',
      'Uniquement une vidéo',
      'Uniquement des photographies imprimées',
    ],
    answer: 'Photo, vidéo, audio ou échanges de messages (sexting)',
    explanation:
        'Le cours précise : support visuel, audio, audiovisuel ou écrit (messages), peu importe le support matériel/numérique.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Consentement',
    question:
        'Dans la pornodivulgation, le fait que la victime ait consenti à être filmée/photographiée signifie :',
    options: [
      'Qu’il faut encore son accord pour la diffusion',
      'Que la diffusion est automatiquement autorisée',
      'Que l’infraction ne peut jamais être constituée',
    ],
    answer: 'Qu’il faut encore son accord pour la diffusion',
    explanation:
        'Le cours insiste : l’accord à la captation ne vaut pas accord à la diffusion.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Élément matériel',
    question:
        'L’élément matériel principal de l’infraction est une diffusion :',
    options: [
      'Sans l’accord de la personne concernée',
      'À un seul proche mais avec accord',
      'Dans un cercle privé avec consentement écrit obligatoire',
    ],
    answer: 'Sans l’accord de la personne concernée',
    explanation:
        'Le cours décrit : porter à la connaissance du public ou d’un tiers sans accord (opposition ou absence de consultation).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Peines',
    question:
        'La pornodivulgation (art. 226-2-1 al.2) est punie (personne physique) de :',
    options: [
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '1 an d’emprisonnement et 45 000 € d’amende',
      '5 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 60 000 € d’amende',
    explanation:
        'Le cours indique : art. 226-2-1 al.2, délit, 2 ans + 60 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Tentative',
    question: 'La tentative de pornodivulgation (226-2-1) est :',
    options: [
      'Punissable (prévue par l’article 226-5 C.P.)',
      'Non punissable',
      'Punissable uniquement si la victime est mineure',
    ],
    answer: 'Punissable (prévue par l’article 226-5 C.P.)',
    explanation:
        'Le cours mentionne que l’art. 226-5 prévoit expressément la tentative pour 226-2-1.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Fondement',
    question:
        'La violation de domicile commise par un particulier est prévue par :',
    options: [
      'L’article 226-4 du Code pénal',
      'L’article 315-1 du Code pénal',
      'L’article 226-15 du Code pénal',
    ],
    answer: 'L’article 226-4 du Code pénal',
    explanation:
        'Le cours indique : art. 226-4 C.P. définit et réprime la violation de domicile (particulier).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Définition',
    question: 'La violation de domicile vise notamment :',
    options: [
      'L’introduction par manœuvres, menaces, voies de fait ou contrainte, et aussi le maintien',
      'Uniquement l’introduction de nuit',
      'Uniquement l’introduction avec effraction',
    ],
    answer:
        'L’introduction par manœuvres, menaces, voies de fait ou contrainte, et aussi le maintien',
    explanation:
        'Le cours précise : introduction illicite + maintien à l’issue de cette introduction.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Notion de domicile',
    question: 'Constitue un domicile (au sens du cours) :',
    options: [
      'Tout local d’habitation protégeant l’intimité, résidence principale ou non, occupé ou non (sous conditions)',
      'Uniquement la résidence principale occupée',
      'Uniquement un logement vide entre deux locations',
    ],
    answer:
        'Tout local d’habitation protégeant l’intimité, résidence principale ou non, occupé ou non (sous conditions)',
    explanation:
        'Le cours retient une définition extensive : local d’habitation protégeant l’intimité (résidence, lieu de séjour, etc.).',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Dépendances',
    question:
        'Peuvent être assimilées à des dépendances du domicile (si proximité et prolongement) :',
    options: [
      'Garage, débarras, balcon, terrasse',
      'Un local réservé à la vente ouvert au public',
      'Un immeuble en construction',
    ],
    answer: 'Garage, débarras, balcon, terrasse',
    explanation:
        'Le cours cite des exemples de dépendances : garage, débarras, balcon, terrasse… sous condition de lien/proximité.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Exclusions',
    question:
        'N’est pas considéré comme un domicile (selon les exemples du cours) :',
    options: [
      'Un immeuble en construction',
      'Une chambre d’hôtel',
      'Un véhicule aménagé pour l’habitation (caravane, roulotte)',
    ],
    answer: 'Un immeuble en construction',
    explanation:
        'Le cours liste parmi les exclusions : immeuble en construction, logement vide de meubles, etc.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Moyens',
    question:
        'Les “manœuvres” au sens de la violation de domicile correspondent à :',
    options: [
      'Un procédé astucieux ou une ruse pour favoriser l’introduction',
      'Uniquement une violence contre les personnes',
      'Uniquement une menace verbale explicite',
    ],
    answer: 'Un procédé astucieux ou une ruse pour favoriser l’introduction',
    explanation:
        'Le cours définit les manœuvres comme tout procédé astucieux/ruse permettant l’introduction illicite.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Voies de fait',
    question: 'Constitue une voie de fait (exemples du cours) :',
    options: [
      'Forcer une serrure ou briser une vitre',
      'Entrer par une porte laissée ouverte au public',
      'Passer dans une cour non close',
    ],
    answer: 'Forcer une serrure ou briser une vitre',
    explanation:
        'Le cours cite : forçage de serrure, bris de vitre, défoncer la porte, etc.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Infraction continue',
    question:
        'La violation de domicile est qualifiée par le cours comme une infraction :',
    options: [
      'Continue (tant que l’occupation illicite perdure)',
      'Instantanée uniquement',
      'Non intentionnelle',
    ],
    answer: 'Continue (tant que l’occupation illicite perdure)',
    explanation:
        'Le cours précise que c’est une infraction continue, permettant la flagrance tant que perdure l’occupation illicite.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Cas légitimes',
    question:
        'Peut constituer un cas d’introduction légitime (hors les cas où la loi le permet) :',
    options: [
      'Assistance à personne en péril (indices graves de péril dans le domicile)',
      'Curiosité personnelle',
      'Récupérer un objet oublié sans autorisation',
    ],
    answer:
        'Assistance à personne en péril (indices graves de péril dans le domicile)',
    explanation:
        'Le cours mentionne l’assistance à personne en péril et d’autres hypothèses (incendie, inondation, appel au secours).',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Peines',
    question:
        'La violation de domicile (art. 226-4) est punie (personne physique) de :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le cours indique : art. 226-4 C.P., 3 ans + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Tentative',
    question: 'La tentative de violation de domicile est :',
    options: [
      'Punissable (prévue par l’article 226-5 C.P.)',
      'Non punissable',
      'Punissable uniquement en bande organisée',
    ],
    answer: 'Punissable (prévue par l’article 226-5 C.P.)',
    explanation: 'Le cours mentionne : tentative oui, prévue à l’art. 226-5.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Propagande de “mode d’emploi du squat” — Fondement',
    question:
        'Le fait de faire la propagande ou publicité en faveur de méthodes facilitant la violation de domicile est incriminé par :',
    options: [
      'L’article 226-4-2-1 du Code pénal',
      'L’article 226-4 du Code pénal',
      'L’article 315-2 du Code pénal',
    ],
    answer: 'L’article 226-4-2-1 du Code pénal',
    explanation:
        'Le cours vise l’art. 226-4-2-1 C.P. pour la propagande/publicité en faveur de méthodes facilitant ces délits.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Propagande de “mode d’emploi du squat” — Sanction',
    question:
        'La commission du délit de propagande/publicité en faveur de méthodes de violation de domicile est sanctionnée par :',
    options: [
      '3 750 € d’amende',
      '45 000 € d’amende et 3 ans d’emprisonnement',
      '60 000 € d’amende et 2 ans d’emprisonnement',
    ],
    answer: '3 750 € d’amende',
    explanation:
        'Le cours précise une amende de 3 750 € pour ce délit distinct.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Correspondances électroniques — Fondement',
    question:
        'La violation des correspondances émises par la voie électronique (particulier) est définie par :',
    options: [
      'L’article 226-15 alinéa 2 du Code pénal',
      'L’article 226-15 alinéa 1 du Code pénal',
      'L’article 226-2 du Code pénal',
    ],
    answer: 'L’article 226-15 alinéa 2 du Code pénal',
    explanation:
        'Le cours distingue : al.2 = définition (voie électronique) ; al.1 = répression (peines).',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Objet',
    question: 'Sont visées par l’article 226-15 al.2 des correspondances :',
    options: [
      'Émises, transmises ou reçues par la voie électronique',
      'Uniquement papier',
      'Uniquement publiées sur un réseau social',
    ],
    answer: 'Émises, transmises ou reçues par la voie électronique',
    explanation:
        'Le cours parle de correspondances “dématérialisées” (appels, emails, etc.).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Intercepter',
    question: '“Intercepter” une correspondance électronique consiste à :',
    options: [
      'Capter le message pendant le cours de sa transmission',
      'Ouvrir un mail déjà lu par le destinataire',
      'Supprimer son propre message avant envoi',
    ],
    answer: 'Capter le message pendant le cours de sa transmission',
    explanation:
        'Le cours : intercepter = prendre au passage, capter pendant la transmission (matériel quelconque).',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Détourner',
    question:
        '“Détourner” une correspondance électronique renvoie notamment au fait :',
    options: [
      'De modifier le cours de la transmission (dérivation), ou d’ouvrir un message en attente d’être lu',
      'De publier un tweet',
      'De répondre à l’expéditeur',
    ],
    answer:
        'De modifier le cours de la transmission (dérivation), ou d’ouvrir un message en attente d’être lu',
    explanation:
        'Le cours retient le détournement notamment quand un tiers ouvre des messages en attente d’être lus par le destinataire.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Divulguer',
    question: '“Divulguer” au sens du cours signifie :',
    options: [
      'Révéler à un tiers le contenu d’une correspondance non destinée à l’auteur',
      'Conserver un message sans le lire',
      'Envoyer un message à son propre compte',
    ],
    answer:
        'Révéler à un tiers le contenu d’une correspondance non destinée à l’auteur',
    explanation:
        'Le cours : divulgation = révélation du contenu à un tiers (ex : faire écouter une conversation enregistrée).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Mauvaise foi',
    question: 'La “mauvaise foi” est définie par la Cour de cassation comme :',
    options: [
      'La connaissance que les lettres/messages ne lui étaient pas destinés',
      'Le désir de vengeance',
      'Le fait d’être en colère',
    ],
    answer:
        'La connaissance que les lettres/messages ne lui étaient pas destinés',
    explanation:
        'Le cours cite : Cass. crim., 15 mai 1990, mauvaise foi = connaissance que le message ne lui était pas destiné.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Aggravation',
    question:
        'La violation des correspondances électroniques est aggravée lorsque les faits sont commis :',
    options: [
      'Par le conjoint, concubin ou partenaire de PACS',
      'Par un voisin',
      'Par un collègue',
    ],
    answer: 'Par le conjoint, concubin ou partenaire de PACS',
    explanation:
        'Le cours : art. 226-15 al.3 prévoit une circonstance aggravante liée au lien conjugal/concubinage/PACS.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Peines simples',
    question: 'En forme simple (226-15 al.2), la peine encourue est :',
    options: [
      '1 an d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le cours indique : 226-15 al.2 = 1 an + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Peines aggravées',
    question: 'En forme aggravée (226-15 al.3), la peine encourue est :',
    options: [
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '1 an d’emprisonnement et 45 000 € d’amende',
      '5 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 60 000 € d’amende',
    explanation: 'Le cours : aggravation 226-15 al.3 => 2 ans + 60 000 €.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // ATTEINTE À LA REPRÉSENTATION — 226-8 + deepfake
  // =========================================================
  QuizQuestion(
    category: 'Atteinte à la représentation — Fondement',
    question: 'L’atteinte à la représentation de la personne est prévue par :',
    options: [
      'L’article 226-8 du Code pénal',
      'L’article 226-1 du Code pénal',
      'L’article 226-4 du Code pénal',
    ],
    answer: 'L’article 226-8 du Code pénal',
    explanation:
        'Le cours indique : l’art. 226-8 C.P. définit et réprime l’atteinte à la représentation de la personne.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Condition',
    question:
        'Le délit est constitué si le montage est diffusé sans consentement et :',
    options: [
      'S’il n’apparaît pas à l’évidence qu’il s’agit d’un montage ou si ce n’est pas expressément mentionné',
      'Même si le montage est évidemment humoristique',
      'Uniquement si la victime est une célébrité',
    ],
    answer:
        'S’il n’apparaît pas à l’évidence qu’il s’agit d’un montage ou si ce n’est pas expressément mentionné',
    explanation:
        'Le cours : infraction si montage non apparent et non signalé, sans consentement.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Deepfake',
    question:
        'Le cours assimile à l’infraction la diffusion d’un contenu visuel/sonore :',
    options: [
      'Généré par traitement algorithmique (deepfake) représentant l’image ou la voix d’une personne sans consentement, non apparent/non mentionné',
      'Uniquement réalisé avec ciseaux et collage papier',
      'Toujours licite si publié sur un compte privé',
    ],
    answer:
        'Généré par traitement algorithmique (deepfake) représentant l’image ou la voix d’une personne sans consentement, non apparent/non mentionné',
    explanation:
        'Le cours intègre explicitement les contenus générés algorithmiquement (hypertrucage/deepfake) dans 226-8.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Consentement',
    question:
        'Le consentement pertinent en matière d’atteinte à la représentation porte sur :',
    options: [
      'La publication/révélation à un tiers (pas seulement la création)',
      'Uniquement la création technique du montage',
      'Uniquement la prise de vue initiale',
    ],
    answer: 'La publication/révélation à un tiers (pas seulement la création)',
    explanation:
        'Le cours précise : le consentement exigé concerne la publication/révélation à un tiers.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Aggravation',
    question:
        'La circonstance aggravante de l’art. 226-8 al.2 est constituée lorsque :',
    options: [
      'Le délit est réalisé via un service de communication au public en ligne',
      'Le montage est diffusé sur papier uniquement',
      'La victime est consentante',
    ],
    answer:
        'Le délit est réalisé via un service de communication au public en ligne',
    explanation:
        'Le cours indique : aggravation lorsque le montage/deepfake est réalisé en utilisant un service de communication au public en ligne.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Peines',
    question: 'En forme simple (226-8 al.1), la peine est :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '2 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation: 'Le cours : art. 226-8 al.1 => 1 an + 15 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Peines aggravées',
    question: 'En forme aggravée (226-8 al.2), la peine est :',
    options: [
      '2 ans d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le cours : art. 226-8 al.2 => 2 ans + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Tentative',
    question: 'La tentative de l’atteinte à la représentation (226-8) est :',
    options: [
      'Punissable (prévue par l’article 226-5 C.P.)',
      'Non punissable',
      'Punissable uniquement si la victime est mineure',
    ],
    answer: 'Punissable (prévue par l’article 226-5 C.P.)',
    explanation: 'Le cours précise : tentative oui, prévue à l’art. 226-5.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Atteinte à la vie privée — Fondement',
    question: 'Les atteintes à l’intimité de la vie privée sont prévues par :',
    options: [
      'L’article 226-1 du Code pénal',
      'L’article 226-10 du Code pénal',
      'L’article 226-4 du Code pénal',
    ],
    answer: 'L’article 226-1 du Code pénal',
    explanation:
        'Le cours : art. 226-1 C.P. réprime la captation/enregistrement/transmission des paroles privées, de l’image en lieu privé, et la localisation.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Paroles',
    question: 'Constitue une atteinte (226-1) :',
    options: [
      'La captation, l’enregistrement ou la transmission, sans consentement, de paroles prononcées à titre privé/confidentiel',
      'La reproduction d’une opinion publiée sur un forum',
      'La critique d’un service public dans un journal',
    ],
    answer:
        'La captation, l’enregistrement ou la transmission, sans consentement, de paroles prononcées à titre privé/confidentiel',
    explanation:
        'Le cours liste explicitement cette première branche de 226-1.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Image',
    question: 'Constitue une atteinte (226-1) :',
    options: [
      'La fixation, l’enregistrement ou la transmission, sans consentement, de l’image d’une personne se trouvant dans un lieu privé',
      'La photo d’un paysage sans personne',
      'La photo d’un lieu public sans aucune personne identifiable',
    ],
    answer:
        'La fixation, l’enregistrement ou la transmission, sans consentement, de l’image d’une personne se trouvant dans un lieu privé',
    explanation:
        'Le cours : l’image est protégée quand la personne est dans un lieu privé.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Lieu privé',
    question: 'Un lieu privé est défini (au cours) comme :',
    options: [
      'Un endroit non ouvert à tous sauf autorisation de l’occupant',
      'Tout lieu public après 22h',
      'Uniquement une maison individuelle',
    ],
    answer: 'Un endroit non ouvert à tous sauf autorisation de l’occupant',
    explanation:
        'Le cours reprend la définition jurisprudentielle : endroit non ouvert à personne sauf autorisation de celui qui l’occupe.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Localisation',
    question: 'Depuis les précisions du cours, 226-1 vise aussi :',
    options: [
      'La captation/enregistrement/transmission de la localisation en temps réel ou différé sans consentement',
      'La géolocalisation uniquement si la victime est d’accord',
      'Le suivi uniquement quand il y a diffusion sur internet',
    ],
    answer:
        'La captation/enregistrement/transmission de la localisation en temps réel ou différé sans consentement',
    explanation:
        'Le cours mentionne la localisation (temps réel ou différé) comme branche autonome de 226-1.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Présomption de consentement',
    question:
        'Le consentement est présumé lorsque l’atteinte (paroles/images) est accomplie :',
    options: [
      'Au vu et au su de la personne sans qu’elle s’y oppose alors qu’elle pouvait le faire',
      'Uniquement si la personne signe un formulaire',
      'Toujours, dès qu’il y a un téléphone visible',
    ],
    answer:
        'Au vu et au su de la personne sans qu’elle s’y oppose alors qu’elle pouvait le faire',
    explanation:
        'Le cours indique cette présomption pour paroles/images (mais pas pour la localisation).',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Localisation et consentement',
    question:
        'Selon le cours, la présomption “au vu et au su” ne s’applique pas à :',
    options: [
      'La localisation (souvent clandestine)',
      'Les paroles privées',
      'L’image en lieu privé',
    ],
    answer: 'La localisation (souvent clandestine)',
    explanation:
        'Le cours précise que cette présomption ne vaut pas pour la localisation car elle est très facilement clandestine.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Infraction de conséquence',
    question:
        'La conservation, l’utilisation ou la divulgation d’un enregistrement issu d’une atteinte à la vie privée est réprimée par :',
    options: [
      'L’article 226-2 du Code pénal',
      'L’article 226-1 du Code pénal',
      'L’article 226-13 du Code pénal',
    ],
    answer: 'L’article 226-2 du Code pénal',
    explanation:
        'Le cours : 226-2 réprime la conservation/diffusion/utilisation des documents/enregistrements obtenus via 226-1.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Peines',
    question: 'La peine de base pour l’atteinte à la vie privée (226-1) est :',
    options: [
      '1 an d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 226-1 (simple) => 1 an + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Aggravation conjoint/PACS',
    question:
        'L’atteinte à la vie privée est aggravée (226-1 al.7) lorsqu’elle est commise :',
    options: [
      'Par le conjoint, concubin ou partenaire de PACS',
      'Par un inconnu',
      'Par un journaliste',
    ],
    answer: 'Par le conjoint, concubin ou partenaire de PACS',
    explanation:
        'Le cours cite l’art. 226-1 al.7 comme circonstance aggravante liée au lien conjugal/concubinage/PACS.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Aggravation DAP/Mission public',
    question:
        'Le cours prévoit une aggravation (226-1 al.8) lorsque les faits sont commis au préjudice :',
    options: [
      'D’une personne dépositaire de l’autorité publique / chargée d’une mission de service public / mandat électif (ou candidate) ou d’un membre de sa famille',
      'D’une personne sans profession',
      'D’une personne ayant un compte privé',
    ],
    answer:
        'D’une personne dépositaire de l’autorité publique / chargée d’une mission de service public / mandat électif (ou candidate) ou d’un membre de sa famille',
    explanation:
        'Le cours mentionne explicitement cette aggravation (226-1 al.8).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Contenu sexuel',
    question:
        'Le cours mentionne une aggravation (226-2-1 al.1) quand les faits portent sur :',
    options: [
      'Des paroles ou images à caractère sexuel prises dans un lieu public ou privé',
      'Uniquement des images dans un lieu privé',
      'Uniquement des propos publics',
    ],
    answer:
        'Des paroles ou images à caractère sexuel prises dans un lieu public ou privé',
    explanation:
        'Le cours vise l’art. 226-2-1 al.1 comme circonstance aggravante liée au caractère sexuel.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Tentative',
    question: 'La tentative des délits 226-1 et 226-2 est :',
    options: [
      'Punissable (prévue par l’article 226-5 C.P.)',
      'Non punissable',
      'Punissable uniquement si la victime est mineure',
    ],
    answer: 'Punissable (prévue par l’article 226-5 C.P.)',
    explanation:
        'Le cours : l’art. 226-5 prévoit expressément la tentative des délits 226-1 et 226-2.',
    difficulty: 'Moyen',
  ),

  QuizQuestion(
    category: 'Atteinte à l’intimité d’une personne — Fondement',
    question:
        'L’atteinte à l’intimité d’une personne (“upskirting”) est prévue par :',
    options: [
      'L’article 226-3-1 du Code pénal',
      'L’article 226-1 du Code pénal',
      'L’article 226-8 du Code pénal',
    ],
    answer: 'L’article 226-3-1 du Code pénal',
    explanation:
        'Le cours : art. 226-3-1 C.P. réprime le fait d’apercevoir les parties intimes dissimulées, à l’insu ou sans consentement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité d’une personne — Élément matériel',
    question:
        'Le délit est constitué si l’auteur use de tout moyen afin d’apercevoir :',
    options: [
      'Les parties intimes dissimulées par habillement ou présence dans un lieu clos',
      'Le visage dans un lieu public',
      'Les mains dans un lieu privé',
    ],
    answer:
        'Les parties intimes dissimulées par habillement ou présence dans un lieu clos',
    explanation:
        'Le cours : observation des parties intimes cachées par vêtement ou parce que la personne est dans un lieu clos.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité d’une personne — Condition',
    question: 'L’acte doit être commis :',
    options: [
      'À l’insu ou sans le consentement de la personne',
      'Uniquement en cas de diffusion internet',
      'Uniquement si l’auteur est un professionnel',
    ],
    answer: 'À l’insu ou sans le consentement de la personne',
    explanation: 'Le cours l’énonce comme condition expresse de 226-3-1.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité d’une personne — Aggravations',
    question:
        'Parmi les aggravations prévues au cours (226-3-1 al.2), on trouve :',
    options: [
      'Mineur, vulnérabilité, abus d’autorité, plusieurs auteurs/complices, transport collectif, ou fixation/enregistrement/transmission d’images',
      'Uniquement la récidive',
      'Uniquement la diffusion par presse écrite',
    ],
    answer:
        'Mineur, vulnérabilité, abus d’autorité, plusieurs auteurs/complices, transport collectif, ou fixation/enregistrement/transmission d’images',
    explanation: 'Le cours liste ces circonstances aggravantes à l’alinéa 2.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité d’une personne — Peines simples',
    question: 'En forme simple (226-3-1 al.1), la peine est :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '1 an d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation: 'Le cours : 226-3-1 al.1 => 1 an + 15 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité d’une personne — Peines aggravées',
    question: 'En forme aggravée (226-3-1 al.2), la peine est :',
    options: [
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '2 ans d’emprisonnement et 45 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 30 000 € d’amende',
    explanation: 'Le cours : 226-3-1 al.2 => 2 ans + 30 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité d’une personne — Tentative',
    question: 'La tentative de 226-3-1 est :',
    options: [
      'Punissable (prévue par l’article 226-5 C.P.)',
      'Non punissable',
      'Punissable uniquement si images effectivement diffusées',
    ],
    answer: 'Punissable (prévue par l’article 226-5 C.P.)',
    explanation:
        'Le cours mentionne : tentative expressément prévue par 226-5.',
    difficulty: 'Moyen',
  ),

  // =========================================================
  // SECRET DES CORRESPONDANCES (papier) — 226-15 al.1
  // =========================================================
  QuizQuestion(
    category: 'Secret des correspondances — Fondement',
    question:
        'L’atteinte au secret des correspondances (ouverture/suppression/retard/détournement) est prévue par :',
    options: [
      'L’article 226-15 alinéa 1 du Code pénal',
      'L’article 226-15 alinéa 2 du Code pénal',
      'L’article 226-1 du Code pénal',
    ],
    answer: 'L’article 226-15 alinéa 1 du Code pénal',
    explanation:
        'Le cours : 226-15 al.1 vise les correspondances “arrivées ou non à destination” (papier), et les actes d’atteinte.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Actes',
    question: 'Parmi les actes visés par 226-15 al.1, on trouve :',
    options: [
      'Ouvrir, supprimer, retarder, détourner ou prendre frauduleusement connaissance',
      'Uniquement recopier le contenu avec accord',
      'Uniquement publier un article',
    ],
    answer:
        'Ouvrir, supprimer, retarder, détourner ou prendre frauduleusement connaissance',
    explanation:
        'Le cours liste explicitement ces verbes d’action comme éléments matériels.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Ouvrir',
    question: '“Ouvrir” une correspondance au sens du cours consiste à :',
    options: [
      'Porter atteinte à l’intégrité du support et accéder au contenu (moyen indifférent)',
      'Lire uniquement si l’enveloppe était déjà ouverte',
      'Répondre au courrier',
    ],
    answer:
        'Porter atteinte à l’intégrité du support et accéder au contenu (moyen indifférent)',
    explanation:
        'Le cours : ouvrir = violer la fermeture, atteinte à l’intégrité du support donnant accès au contenu.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Accord de la victime',
    question:
        'Selon le cours (226-14), pour certains signalements effectués par un médecin, il est en principe nécessaire :',
    options: [
      'D’obtenir l’accord de la victime',
      'D’obtenir l’accord de l’auteur des faits',
      'D’obtenir l’accord du maire',
    ],
    answer: 'D’obtenir l’accord de la victime',
    explanation:
        'Le cours précise que, pour certains signalements par un professionnel de santé, l’accord de la victime est requis (sauf exceptions).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Mineur et accord',
    question:
        'Selon le cours (226-14), lorsque la victime est un mineur, l’accord de la victime pour le signalement :',
    options: [
      'N’est pas nécessaire',
      'Est toujours obligatoire',
      'N’est possible que si le mineur a plus de 16 ans',
    ],
    answer: 'N’est pas nécessaire',
    explanation:
        'Le cours indique que lorsque la victime est mineure, l’accord n’est pas nécessaire pour le signalement dans les cas prévus par 226-14.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Incapacité de se protéger',
    question:
        'Selon le cours (226-14), lorsque la victime n’est pas en mesure de se protéger en raison de son âge ou de son incapacité physique ou psychique, l’accord :',
    options: [
      'N’est pas nécessaire',
      'Est indispensable dans tous les cas',
      'Peut être remplacé par l’accord du voisin',
    ],
    answer: 'N’est pas nécessaire',
    explanation:
        'Le cours rappelle l’exception : si la victime ne peut se protéger (âge/incapacité), l’accord n’est pas requis pour le signalement prévu par 226-14.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Sujétion psychologique ou physique',
    question:
        'Selon le cours (226-14), un médecin peut informer le procureur de faits de sujétion psychologique ou physique (223-15-3) lorsque :',
    options: [
      'Il estime en conscience que la sujétion cause une altération grave de la santé ou conduit à un acte/abstention gravement préjudiciable',
      'Il veut accélérer une procédure civile',
      'La victime a seulement un désaccord familial',
    ],
    answer:
        'Il estime en conscience que la sujétion cause une altération grave de la santé ou conduit à un acte/abstention gravement préjudiciable',
    explanation:
        'Le cours mentionne l’exception : signalement possible si la sujétion entraîne une altération grave ou un acte/abstention gravement préjudiciable.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Information de la victime',
    question:
        'Selon le cours (226-14), en cas d’impossibilité d’obtenir l’accord de la victime (dans les cas prévus), le médecin doit :',
    options: [
      'Informer la victime du signalement fait au procureur',
      'Se taire et ne jamais rien signaler',
      'Informer uniquement l’employeur de la victime',
    ],
    answer: 'Informer la victime du signalement fait au procureur',
    explanation:
        'Le cours précise qu’en cas d’impossibilité d’obtenir l’accord, le professionnel doit informer la victime du signalement.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Détention d’arme',
    question:
        'Selon le cours (226-14), les professionnels de la santé ou de l’action sociale peuvent informer le préfet (à Paris le préfet de police) lorsque :',
    options: [
      'Ils savent qu’une personne dangereuse pour elle-même ou autrui détient une arme ou a manifesté l’intention d’en acquérir une',
      'Une personne a un permis de chasse valide',
      'Une personne refuse un rendez-vous médical',
    ],
    answer:
        'Ils savent qu’une personne dangereuse pour elle-même ou autrui détient une arme ou a manifesté l’intention d’en acquérir une',
    explanation:
        'Le cours liste cette exception : information au préfet/préfet de police en cas de dangerosité + détention/intention d’acquérir une arme.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Signalement vétérinaire',
    question:
        'Selon le cours (226-14), le vétérinaire peut porter à la connaissance du procureur :',
    options: [
      'Toute information relative à des sévices graves, acte de cruauté ou atteinte sexuelle sur un animal, ainsi que des mauvais traitements constatés',
      'Uniquement les maladies contagieuses humaines',
      'Uniquement les litiges commerciaux entre éleveurs',
    ],
    answer:
        'Toute information relative à des sévices graves, acte de cruauté ou atteinte sexuelle sur un animal, ainsi que des mauvais traitements constatés',
    explanation:
        'Le cours inclut une exception propre au vétérinaire concernant les sévices graves, cruauté, atteinte sexuelle et mauvais traitements sur un animal.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Secret professionnel — Responsabilité de l’auteur du signalement',
    question:
        'Selon le cours (226-14), le signalement fait dans les conditions prévues :',
    options: [
      'Ne peut engager la responsabilité civile, pénale ou disciplinaire de son auteur, sauf absence de bonne foi',
      'Engage toujours la responsabilité pénale de son auteur',
      'Engage uniquement la responsabilité civile',
    ],
    answer:
        'Ne peut engager la responsabilité civile, pénale ou disciplinaire de son auteur, sauf absence de bonne foi',
    explanation:
        'Le cours précise que le signalement conforme ne peut engager la responsabilité, sauf s’il est établi que l’auteur n’a pas agi de bonne foi.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // DÉNONCIATION CALOMNIEUSE — Approfondissement
  // =========================================================
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Personne morale',
    question:
        'Selon le cours, la “personne déterminée” visée par la dénonciation peut être :',
    options: [
      'Une personne physique ou une personne morale',
      'Uniquement une personne physique',
      'Uniquement une administration',
    ],
    answer: 'Une personne physique ou une personne morale',
    explanation:
        'Le cours précise que la personne dénoncée peut être physique ou morale dès lors qu’elle est identifiable.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Identification sans nom',
    question:
        'Selon le cours, même sans nommer la victime, la dénonciation peut viser une personne déterminée si :',
    options: [
      'Elle contient des détails faisant nécessairement porter les soupçons sur une personne précise',
      'Elle est publiée sur un réseau social',
      'Elle est envoyée à plusieurs destinataires',
    ],
    answer:
        'Elle contient des détails faisant nécessairement porter les soupçons sur une personne précise',
    explanation:
        'Le cours indique que l’identification peut résulter de détails permettant de reconnaître la personne visée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Dénonciation anonyme',
    question:
        'Selon le cours, en cas de dénonciation anonyme, l’infraction peut être poursuivie si :',
    options: [
      'L’auteur est identifiable',
      'La lettre est manuscrite',
      'La victime est une personnalité publique',
    ],
    answer: 'L’auteur est identifiable',
    explanation:
        'Le cours précise que dans le cas d’une dénonciation anonyme, il faut que l’auteur puisse être identifié.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Auteur moral',
    question:
        'Selon le cours, est assimilé à l’auteur de la dénonciation celui qui :',
    options: [
      'La fait effectuer par une tierce personne (auteur moral assimilé à l’auteur juridique)',
      'La lit sans la transmettre',
      'La commente en privé sans la communiquer',
    ],
    answer:
        'La fait effectuer par une tierce personne (auteur moral assimilé à l’auteur juridique)',
    explanation:
        'Le cours indique que l’auteur moral (celui qui fait effectuer) est assimilé à l’auteur de la dénonciation.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Exécutant sur ordre',
    question:
        'Selon le cours, la personne qui exécute matériellement une dénonciation sur instructions hiérarchiques n’est poursuivable que si :',
    options: [
      'Elle y a pris part personnellement (au-delà d’un simple rôle matériel)',
      'Elle a un grade supérieur',
      'Elle est en dehors de son temps de service',
    ],
    answer:
        'Elle y a pris part personnellement (au-delà d’un simple rôle matériel)',
    explanation:
        'Le cours distingue : l’exécutant n’est poursuivi que s’il participe personnellement, contrairement à celui n’ayant eu qu’un rôle matériel.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Sanction effective',
    question:
        'Selon le cours, pour que la dénonciation soit “préjudiciable”, il faut :',
    options: [
      'Que le fait dénoncé soit de nature à entraîner une sanction (même sans sanction effective)',
      'Qu’une sanction ait été effectivement prononcée',
      'Que la victime ait perdu son emploi',
    ],
    answer:
        'Que le fait dénoncé soit de nature à entraîner une sanction (même sans sanction effective)',
    explanation:
        'Le cours précise que peu importe qu’une sanction ait été prononcée : il suffit que le fait soit de nature à entraîner des sanctions.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Différence avec diffamation',
    question:
        'Selon le cours, la dénonciation calomnieuse se distingue de la diffamation car elle est aussi :',
    options: [
      'De nature à entraîner des sanctions judiciaires, administratives ou disciplinaires',
      'Toujours commise publiquement',
      'Toujours commise sur internet',
    ],
    answer:
        'De nature à entraîner des sanctions judiciaires, administratives ou disciplinaires',
    explanation:
        'Le cours souligne la différence : au-delà de l’atteinte à l’honneur, elle expose à des sanctions par une autorité.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Destinataires possibles',
    question:
        'Selon le cours, peuvent recevoir une dénonciation entrant dans 226-10 :',
    options: [
      'Une autorité pouvant donner suite, un supérieur hiérarchique ou l’employeur',
      'Uniquement un juge',
      'Uniquement la presse',
    ],
    answer:
        'Une autorité pouvant donner suite, un supérieur hiérarchique ou l’employeur',
    explanation:
        'Le cours cite notamment : autorités pouvant donner suite/saisir, supérieurs hiérarchiques, employeur.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Réception',
    question:
        'Selon le cours, il n’est pas nécessaire que la dénonciation soit remise en main propre car il suffit :',
    options: [
      'De l’adresser à l’autorité ou de faire en sorte qu’elle lui parvienne',
      'De la publier dans un groupe privé',
      'De la rédiger et la conserver chez soi',
    ],
    answer:
        'De l’adresser à l’autorité ou de faire en sorte qu’elle lui parvienne',
    explanation:
        'Le cours précise : pas besoin de remise en main propre, il suffit que la dénonciation parvienne à l’autorité visée.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // VIOLATION DE DOMICILE — Approfondissement
  // =========================================================
  QuizQuestion(
    category: 'Violation de domicile — Proximité des dépendances',
    question:
        'Selon le cours, une dépendance ne peut entrer dans la notion de domicile que si :',
    options: [
      'Elle est une annexe et se trouve à proximité du local d’habitation',
      'Elle est située dans une autre commune',
      'Elle est ouverte au public',
    ],
    answer:
        'Elle est une annexe et se trouve à proximité du local d’habitation',
    explanation:
        'Le cours insiste sur la nécessité d’un lien étroit et immédiat (annexe + proximité) entre dépendance et habitation.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Lieux protégés',
    question: 'Selon le cours, peuvent être considérés comme domiciles :',
    options: [
      'La chambre d’hôtel, un véhicule aménagé pour l’habitation, une caravane',
      'Un bloc opératoire sans restriction',
      'Un casier de consigne de gare',
    ],
    answer:
        'La chambre d’hôtel, un véhicule aménagé pour l’habitation, une caravane',
    explanation:
        'Le cours liste comme domiciles : chambre d’hôtel, véhicule aménagé, caravane, roulotte, tente, etc.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Lieux ouverts au public',
    question:
        'Selon le cours, les locaux professionnels bénéficient de la protection du domicile :',
    options: [
      'Sauf pendant les heures d’ouverture lorsqu’ils sont ouverts au public',
      'Uniquement le week-end',
      'Jamais, car ce ne sont pas des domiciles',
    ],
    answer:
        'Sauf pendant les heures d’ouverture lorsqu’ils sont ouverts au public',
    explanation:
        'Le cours précise que les lieux ouverts au public ne bénéficient pas de la protection pendant les heures d’ouverture.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Porte non fermée',
    question:
        'Selon le cours, l’introduction illicite par voie de fait peut ne pas être retenue lorsque :',
    options: [
      'La porte du local n’était pas fermée à clé',
      'La personne a sonné avant d’entrer',
      'La personne est connue du voisinage',
    ],
    answer: 'La porte du local n’était pas fermée à clé',
    explanation:
        'Le cours mentionne qu’une introduction illicite n’a pas pu être retenue lorsque la porte n’était pas fermée à clés.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Maintien en connaissance de cause',
    question:
        'Selon le cours, des personnes venues ensuite occuper les lieux peuvent être poursuivies si :',
    options: [
      'Elles ont agi en connaissance de cause en profitant de l’entrée illicite d’un tiers',
      'Elles ont signé un bail',
      'Elles ont seulement visité le logement',
    ],
    answer:
        'Elles ont agi en connaissance de cause en profitant de l’entrée illicite d’un tiers',
    explanation:
        'Le cours indique que le maintien peut viser ceux qui viennent ensuite demeurer en profitant de l’entrée illicite, en connaissance de cause.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // CORRESPONDANCES ÉLECTRONIQUES — Approfondissement
  // =========================================================
  QuizQuestion(
    category: 'Correspondances électroniques — Moment protégé',
    question:
        'Selon le cours, 226-15 al.2 s’applique aux correspondances en cours de transmission ou :',
    options: [
      'Parvenues à destination mais non encore appréhendées par le destinataire',
      'Déjà lues et archivées par le destinataire',
      'Publiées volontairement sur un forum',
    ],
    answer:
        'Parvenues à destination mais non encore appréhendées par le destinataire',
    explanation:
        'Le cours précise que le texte vise les messages en transmission ou arrivés mais pas encore pris connaissance par le destinataire.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Après lecture',
    question:
        'Selon le cours, dès que le destinataire a pris connaissance d’un mail, celui-ci :',
    options: [
      'Perd son caractère spécifique de correspondance et devient une donnée informatique',
      'Reste toujours une correspondance au sens strict',
      'Devient automatiquement un secret professionnel',
    ],
    answer:
        'Perd son caractère spécifique de correspondance et devient une donnée informatique',
    explanation:
        'Le cours indique qu’après lecture par le destinataire, le message ne relève plus du champ spécifique des correspondances électroniques.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ATTEINTE À LA REPRÉSENTATION — Approfondissement
  // =========================================================
  QuizQuestion(
    category: 'Atteinte à la représentation — Blogs/profils fictifs',
    question:
        'Selon la jurisprudence citée au cours, créer un profil de réseau social au nom d’un tiers sans montage image/voix relève :',
    options: [
      'Pas de l’article 226-8',
      'Toujours de l’article 226-8',
      'Uniquement de l’article 226-4',
    ],
    answer: 'Pas de l’article 226-8',
    explanation:
        'Le cours cite une jurisprudence : un simple procédé écrit (sans montage image/voix) ne relève pas de 226-8.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Montage caractérisé',
    question: 'Selon le cours, le montage réprimé est celui qui tend à :',
    options: [
      'Déformer délibérément des images ou paroles par ajout ou retrait d’éléments étrangers',
      'Améliorer la qualité sonore sans modifier le sens',
      'Recadrer une photo sans altérer son contenu',
    ],
    answer:
        'Déformer délibérément des images ou paroles par ajout ou retrait d’éléments étrangers',
    explanation:
        'Le cours rappelle la jurisprudence : montage réprimé quand il déforme volontairement (ajout/retrait d’éléments étrangers).',
    difficulty: 'Difficile',
  ),
  // =========================================================
  // ATTEINTE À LA REPRÉSENTATION — Approfondissement (suite)
  // =========================================================
  QuizQuestion(
    category: 'Atteinte à la représentation — Trucage manifestement apparent',
    question:
        'Selon le cours (226-8), le consentement à la publication n’est pas nécessaire lorsque :',
    options: [
      'Il apparaît à l’évidence qu’il s’agit d’un montage',
      'Le montage est diffusé en journée',
      'La victime a déjà parlé à la presse',
    ],
    answer: 'Il apparaît à l’évidence qu’il s’agit d’un montage',
    explanation:
        'Le cours précise que si le montage est manifestement apparent, le public ne peut pas être dupé : l’incrimination n’est pas constituée dans ce cas.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Mention explicite',
    question:
        'Selon le cours (226-8), le consentement à la publication n’est pas nécessaire si :',
    options: [
      'Il est expressément fait mention qu’il s’agit d’un montage',
      'Le montage est humoristique selon l’auteur',
      'La victime est inconnue',
    ],
    answer: 'Il est expressément fait mention qu’il s’agit d’un montage',
    explanation:
        'Le cours indique qu’une mention claire et univoque (“montage”) évite la méprise et neutralise la condition de consentement à la publication.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — But recherché',
    question:
        'Selon le cours, pour 226-8, le but recherché (notoriété, profit, etc.) :',
    options: [
      'Importe peu pour caractériser l’infraction',
      'Doit être uniquement la volonté de nuire',
      'Doit être uniquement le profit financier',
    ],
    answer: 'Importe peu pour caractériser l’infraction',
    explanation:
        'Le cours précise que le résultat escompté par la diffusion (profit, notoriété…) est indifférent pour l’élément moral.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Élément moral',
    question: 'Selon le cours, l’élément moral de 226-8 repose sur :',
    options: [
      'La volonté de créer un montage en vue de tromper le public',
      'L’obligation de prouver un préjudice financier',
      'Le fait d’avoir agi sous stress',
    ],
    answer: 'La volonté de créer un montage en vue de tromper le public',
    explanation:
        'Le cours indique expressément : volonté de créer un montage pour tromper (le mobile importe peu).',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // ATTEINTE À L’INTIMITÉ DE LA VIE PRIVÉE — Approfondissement
  // =========================================================
  QuizQuestion(
    category: 'Atteinte à la vie privée — Procédé quelconque',
    question: 'Selon le cours (226-1), l’atteinte peut être réalisée :',
    options: [
      'Au moyen d’un procédé quelconque (technique ou non)',
      'Uniquement avec un appareil d’écoute',
      'Uniquement par une caméra cachée',
    ],
    answer: 'Au moyen d’un procédé quelconque (technique ou non)',
    explanation:
        'Le cours précise que toutes les méthodes sont visées, y compris sans appareil, dès lors qu’elles permettent l’atteinte.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Paroles en lieu public',
    question:
        'Selon le cours, le délit de captation/enregistrement de paroles privées (226-1) est constitué si les paroles sont prononcées :',
    options: [
      'Dans un lieu public ou privé, dès lors qu’elles sont à titre privé ou confidentiel',
      'Uniquement dans un domicile',
      'Uniquement dans un lieu fermé au public',
    ],
    answer:
        'Dans un lieu public ou privé, dès lors qu’elles sont à titre privé ou confidentiel',
    explanation:
        'Le cours précise que l’élément déterminant est le caractère privé/confidentiel des propos, pas le lieu.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Enregistrement inaudible',
    question:
        'Selon le cours, l’infraction d’enregistrement de paroles privées est constituée :',
    options: [
      'Même si l’enregistrement est inaudible',
      'Uniquement si l’enregistrement est parfaitement audible',
      'Uniquement si la victime est identifiée à l’écran',
    ],
    answer: 'Même si l’enregistrement est inaudible',
    explanation:
        'Le cours indique que l’infraction est constituée quels que soient les résultats techniques, y compris si les propos enregistrés sont inaudibles.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Transmission',
    question: 'Selon le cours, la “transmission” de paroles privées vise :',
    options: [
      'Tout moyen mettant à disposition la parole captée/enregistrée à un ou plusieurs destinataires avertis',
      'Uniquement la publication sur un site de presse',
      'Uniquement l’envoi par courrier recommandé',
    ],
    answer:
        'Tout moyen mettant à disposition la parole captée/enregistrée à un ou plusieurs destinataires avertis',
    explanation:
        'Le cours précise que toute mise à disposition à des destinataires avertis peut constituer une transmission.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Mineur et consentement',
    question:
        'Selon le cours (226-1), dans le cas d’un mineur, le consentement doit émaner :',
    options: [
      'Des titulaires de l’autorité parentale',
      'Du mineur seul, quel que soit son âge',
      'Du directeur d’établissement scolaire',
    ],
    answer: 'Des titulaires de l’autorité parentale',
    explanation:
        'Le cours rappelle que pour un mineur, l’accord vient des titulaires de l’autorité parentale (dans le respect du code civil).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Image et lieu privé',
    question:
        'Selon le cours, 226-1 réprime l’image d’une personne lorsqu’elle est prise :',
    options: [
      'Dans un lieu privé',
      'Dans n’importe quel lieu public',
      'Uniquement dans un tribunal',
    ],
    answer: 'Dans un lieu privé',
    explanation:
        'Le cours précise que pour l’image, le champ est restreint : la personne doit se trouver dans un lieu privé.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Exemples de lieux privés',
    question:
        'Selon le cours, peuvent être considérés comme des lieux privés :',
    options: [
      'Une chambre d’hôpital, une prison, un commissariat',
      'Une place publique, un marché, une gare',
      'Une salle d’audience ouverte au public',
    ],
    answer: 'Une chambre d’hôpital, une prison, un commissariat',
    explanation:
        'Le cours cite ces exemples jurisprudentiels comme lieux privés au sens de 226-1 (appréciation au cas par cas).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Localisation et moyens',
    question:
        'Selon le cours, la captation de localisation peut notamment résulter :',
    options: [
      'D’une balise placée clandestinement ou d’un logiciel espion installé sur un téléphone',
      'Uniquement d’un témoin oculaire',
      'Uniquement d’une publication volontaire de la victime',
    ],
    answer:
        'D’une balise placée clandestinement ou d’un logiciel espion installé sur un téléphone',
    explanation:
        'Le cours mentionne des exemples de dispositifs techniques : balise, logiciel espion sur un moyen de communication mobile.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Opposition d’un parent',
    question: 'Selon le cours, pour la localisation d’un mineur, il suffit :',
    options: [
      'De l’opposition de l’un des titulaires de l’autorité parentale pour rendre la localisation illicite',
      'De l’accord d’un seul parent pour rendre la localisation toujours licite',
      'De l’accord de l’école',
    ],
    answer:
        'De l’opposition de l’un des titulaires de l’autorité parentale pour rendre la localisation illicite',
    explanation:
        'Le cours précise que pour la localisation, l’opposition d’un parent suffit à rendre la localisation illicite.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Infraction de conséquence',
    question:
        'Selon le cours, la conservation/utilisation/divulgation (226-2) est :',
    options: [
      'Une infraction de conséquence d’une atteinte initiale (226-1)',
      'Une infraction totalement indépendante',
      'Une contravention',
    ],
    answer: 'Une infraction de conséquence d’une atteinte initiale (226-1)',
    explanation:
        'Le cours explique que 226-2 sanctionne le “produit” d’une atteinte à la vie privée prévue par 226-1.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Conservation',
    question: 'Selon le cours (226-2), la “conservation” signifie :',
    options: [
      'Garder à sa disposition le produit de l’atteinte, même sans divulgation ni utilisation',
      'Publier le contenu sur internet',
      'Détruire immédiatement le contenu',
    ],
    answer:
        'Garder à sa disposition le produit de l’atteinte, même sans divulgation ni utilisation',
    explanation:
        'Le cours précise que le simple fait de garder le produit de l’atteinte est réprimé, indépendamment de toute diffusion ou utilisation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Utilisation en justice',
    question:
        'Selon le cours (226-2), utiliser un enregistrement illicite dans une procédure (ex : divorce) :',
    options: [
      'Peut constituer l’infraction d’utilisation du document obtenu par atteinte à la vie privée',
      'Est toujours autorisé car c’est “pour la justice”',
      'N’est jamais répréhensible',
    ],
    answer:
        'Peut constituer l’infraction d’utilisation du document obtenu par atteinte à la vie privée',
    explanation:
        'Le cours donne l’exemple : l’utilisation, même en privé, notamment en procédure, peut tomber sous 226-2.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Diffusion à un tiers',
    question:
        'Selon le cours (226-2), la “diffusion/divulgation” peut être constituée :',
    options: [
      'Même par une simple communication à un tiers',
      'Uniquement par la télévision',
      'Uniquement par une affiche sur la voie publique',
    ],
    answer: 'Même par une simple communication à un tiers',
    explanation:
        'Le cours précise une conception large : presse/radio/télévision mais aussi communication à un tiers jusqu’alors ignorant.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Personne tenue d’empêcher',
    question:
        'Selon le cours (226-2), peut être considéré comme auteur celui qui, ayant connaissance de l’illicéité et le pouvoir d’empêcher la diffusion :',
    options: [
      'Laisse porter à la connaissance du public le document/enregistrement',
      'Ignore le contenu par principe',
      'N’a jamais eu accès au fichier',
    ],
    answer:
        'Laisse porter à la connaissance du public le document/enregistrement',
    explanation:
        'Le cours indique que celui qui pouvait empêcher la divulgation et s’abstient peut être recherché en responsabilité.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // PORNODIVULGATION — Approfondissement
  // =========================================================
  QuizQuestion(
    category: 'Pornodivulgation — Consentement et preuve',
    question:
        'Selon le cours, lorsque la victime affirme ne pas avoir donné son accord à la diffusion, il appartient :',
    options: [
      'À l’auteur de prouver qu’il a reçu l’accord en vue de la diffusion',
      'À la victime de prouver que l’auteur est coupable',
      'Au public de voter sur la véracité',
    ],
    answer:
        'À l’auteur de prouver qu’il a reçu l’accord en vue de la diffusion',
    explanation:
        'Le cours précise que l’accord à être filmé ne vaut pas accord à diffuser : l’auteur doit prouver l’accord de diffusion.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Différence avec 226-1',
    question: 'Selon le cours, la pornodivulgation se distingue de 226-1 car :',
    options: [
      'Le contenu a été obtenu avec le consentement de la personne (mais diffusé sans accord)',
      'Le contenu est toujours capté clandestinement',
      'Le contenu ne peut jamais être sexuel',
    ],
    answer:
        'Le contenu a été obtenu avec le consentement de la personne (mais diffusé sans accord)',
    explanation:
        'Le cours souligne que, contrairement à 226-1, la personne est consentante à la captation, mais pas à la diffusion.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // SECRET DES CORRESPONDANCES — Approfondissement (papier)
  // =========================================================
  QuizQuestion(
    category: 'Secret des correspondances — Notion',
    question: 'Selon le cours, une “correspondance” est :',
    options: [
      'Un message quel qu’en soit le support, dès lors qu’il a vocation à circuler',
      'Uniquement une lettre recommandée',
      'Uniquement un document administratif public',
    ],
    answer:
        'Un message quel qu’en soit le support, dès lors qu’il a vocation à circuler',
    explanation:
        'Le cours indique que la jurisprudence assimile “correspondance” à “message” (lettre, carte postale, télégramme…).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — À destination d’un tiers',
    question:
        'Selon le cours, on viole le secret des correspondances lorsque le message est adressé :',
    options: [
      'À un tiers (autrui)',
      'À soi-même',
      'À un groupe public sans destinataire',
    ],
    answer: 'À un tiers (autrui)',
    explanation:
        'Le cours précise : l’atteinte vise le message adressé à autrui, on ne viole pas le secret de sa propre correspondance.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Suppression',
    question: 'Selon le cours, “supprimer” une correspondance signifie :',
    options: [
      'Empêcher qu’elle parvienne à destination (mise au rebut, destruction ou même conservation)',
      'La remettre en main propre',
      'La photocopier',
    ],
    answer:
        'Empêcher qu’elle parvienne à destination (mise au rebut, destruction ou même conservation)',
    explanation:
        'Le cours reprend la définition jurisprudentielle : tout acte empêchant la correspondance de parvenir à destination.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Retarder',
    question: 'Selon le cours, “retarder” une correspondance consiste à :',
    options: [
      'Retenir le message en interrompant le cours normal de son acheminement',
      'Répondre tardivement',
      'Oublier de poster son propre courrier',
    ],
    answer:
        'Retenir le message en interrompant le cours normal de son acheminement',
    explanation:
        'Le cours indique que retarder revient à faire arriver plus tard en retenant le message et en interrompant l’acheminement.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Prise frauduleuse de connaissance',
    question:
        'Selon le cours, “prendre frauduleusement connaissance” peut exister :',
    options: [
      'Même sans avoir soi-même ouvert/retardé/détourné la correspondance',
      'Uniquement après destruction du courrier',
      'Uniquement si l’auteur est destinataire',
    ],
    answer:
        'Même sans avoir soi-même ouvert/retardé/détourné la correspondance',
    explanation:
        'Le cours précise que le législateur sanctionne aussi ce cas de manière autonome : connaissance frauduleuse sans nécessairement les autres actes.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // VIOLATION DES CORRESPONDANCES ÉLECTRONIQUES — Approfondissement (suite)
  // =========================================================
  QuizQuestion(
    category: 'Correspondances électroniques — Installation d’appareils',
    question:
        'Selon le cours (226-15 al.2), “procéder à l’installation d’appareils” vise :',
    options: [
      'Mettre en œuvre un dispositif ou logiciel permettant intercepter/détourner/utiliser/divulguer des correspondances électroniques',
      'Installer une application de messagerie officielle',
      'Acheter un téléphone neuf',
    ],
    answer:
        'Mettre en œuvre un dispositif ou logiciel permettant intercepter/détourner/utiliser/divulguer des correspondances électroniques',
    explanation:
        'Le cours inclut l’installation de dispositifs (ou logiciels) de nature à permettre l’atteinte aux correspondances.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Intention de nuire',
    question:
        'Selon le cours, pour 226-15 (correspondances), l’intention de nuire :',
    options: [
      'N’est pas exigée (le mobile importe peu)',
      'Est obligatoire',
      'Doit être prouvée par des menaces',
    ],
    answer: 'N’est pas exigée (le mobile importe peu)',
    explanation:
        'Le cours précise que l’infraction repose sur la connaissance de l’illicéité, sans exiger une intention de nuire.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // SECRET PROFESSIONNEL — Approfondissement (suite)
  // =========================================================
  QuizQuestion(
    category: 'Secret professionnel — Caractère secret après décès',
    question: 'Selon le cours, le caractère secret de l’information :',
    options: [
      'Ne s’éteint pas avec le décès de la personne',
      'S’éteint automatiquement au décès',
      'S’éteint si la famille le demande oralement',
    ],
    answer: 'Ne s’éteint pas avec le décès de la personne',
    explanation:
        'Le cours indique que le caractère secret de l’information ne disparaît pas du fait du décès.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Révélation à un autre dépositaire',
    question:
        'Selon le cours, la révélation à une personne également soumise au secret professionnel :',
    options: [
      'Peut quand même constituer l’infraction si l’information est transmise',
      'Est toujours licite',
      'N’est jamais répréhensible',
    ],
    answer:
        'Peut quand même constituer l’infraction si l’information est transmise',
    explanation:
        'Le cours précise qu’il suffit que l’information soit transmise à une seule personne, même tenue au secret, pour constituer l’infraction.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Intention de nuire',
    question: 'Selon le cours, pour 226-13, l’intention de nuire :',
    options: [
      'N’est pas requise (le mobile importe peu)',
      'Est exigée pour être condamné',
      'Est présumée seulement si la victime porte plainte',
    ],
    answer: 'N’est pas requise (le mobile importe peu)',
    explanation:
        'Le cours rappelle que l’infraction est intentionnelle quant à la révélation, mais sans exigence d’intention de nuire.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // DÉNONCIATION CALOMNIEUSE — Approfondissement (suite)
  // =========================================================
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Réponse à une question',
    question:
        'Selon le cours, une dénonciation faite dans les réponses aux questions d’un magistrat instructeur :',
    options: [
      'Perd son caractère spontané',
      'Reste toujours spontanée',
      'Devient une diffamation automatiquement',
    ],
    answer: 'Perd son caractère spontané',
    explanation:
        'Le cours cite des cas où la dénonciation est provoquée (réponses aux questions d’un magistrat) et perd donc le caractère spontané.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Défense du prévenu',
    question:
        'Selon le cours, la dénonciation faite par un prévenu peut perdre son caractère spontané si :',
    options: [
      'Elle se rattache étroitement à sa défense',
      'Elle est écrite',
      'Elle est envoyée par email',
    ],
    answer: 'Elle se rattache étroitement à sa défense',
    explanation:
        'Le cours indique que lorsqu’une dénonciation se rattache étroitement à la défense du prévenu, elle perd le caractère spontané.',
    difficulty: 'Difficile',
  ),
  // =========================================================
  // PACK 50 QUESTIONS (1/50)
  // =========================================================
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Fait partiellement inexact',
    question:
        'Selon le cours (226-10), la dénonciation calomnieuse peut être constituée si les faits dénoncés sont :',
    options: [
      'Totalement ou partiellement inexacts',
      'Seulement imprécis sans accusation',
      'Uniquement diffamatoires en public',
    ],
    answer: 'Totalement ou partiellement inexacts',
    explanation:
        'Le cours précise que l’auteur doit savoir le fait “totalement ou partiellement inexact”.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Moyen de preuve (oral)',
    question:
        'Selon le cours, la dénonciation orale (ex : téléphone) est prise en compte si :',
    options: [
      'Elle peut être prouvée',
      'Elle a été faite à voix basse',
      'Elle a été faite de nuit',
    ],
    answer: 'Elle peut être prouvée',
    explanation:
        'Le cours indique que la dénonciation orale est possible, mais doit pouvoir être prouvée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Plainte et 226-10',
    question:
        'Selon le cours, la dénonciation écrite peut notamment prendre la forme :',
    options: [
      'D’une plainte déposée auprès de la police ou de la gendarmerie',
      'D’un simple “like” sur une publication',
      'D’un message vocal privé non transmis',
    ],
    answer: 'D’une plainte déposée auprès de la police ou de la gendarmerie',
    explanation:
        'Le cours cite la plainte auprès des services de police ou de gendarmerie comme forme de dénonciation écrite.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Pétition',
    question: 'Selon le cours, une dénonciation écrite peut aussi être :',
    options: [
      'Une pétition',
      'Un sondage en ligne sans accusation',
      'Un avis de recherche officiel',
    ],
    answer: 'Une pétition',
    explanation:
        'Le cours énumère la pétition parmi les supports possibles de la dénonciation écrite.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Lettre anonyme',
    question: 'Selon le cours, une dénonciation peut être :',
    options: [
      'Signée ou anonyme',
      'Valable uniquement si signée',
      'Valable uniquement si authentifiée par notaire',
    ],
    answer: 'Signée ou anonyme',
    explanation:
        'Le cours précise que la dénonciation écrite peut être une lettre signée ou anonyme (à condition que l’auteur soit identifiable pour poursuivre).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Autorité de police administrative',
    question:
        'Selon le cours, parmi les destinataires possibles figurent des officiers de police administrative (exemples) :',
    options: [
      'Notaires, huissiers, préfets, recteurs',
      'Uniquement les policiers municipaux',
      'Uniquement les médecins',
    ],
    answer: 'Notaires, huissiers, préfets, recteurs',
    explanation:
        'Le cours cite notamment notaires, huissiers, préfets, recteurs comme officiers de police administrative.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Autorité de police judiciaire',
    question:
        'Selon le cours, parmi les destinataires possibles figurent des officiers de police judiciaire (exemples) :',
    options: [
      'Maires et adjoints, policiers, gendarmes',
      'Uniquement les avocats',
      'Uniquement les enseignants',
    ],
    answer: 'Maires et adjoints, policiers, gendarmes',
    explanation:
        'Le cours mentionne notamment maires/adjoints, policiers et gendarmes comme destinataires possibles au titre des autorités visées.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Autorité “pouvant saisir”',
    question:
        'Selon le cours, peut être destinataire une personne qui n’a pas le pouvoir de sanctionner mais qui peut saisir l’autorité compétente, par exemple :',
    options: [
      'Un médecin ou une assistante sociale',
      'Un commerçant',
      'Un touriste',
    ],
    answer: 'Un médecin ou une assistante sociale',
    explanation:
        'Le cours cite des exemples de personnes pouvant saisir l’autorité compétente, comme le médecin ou l’assistante sociale.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Initiative personnelle',
    question:
        'Selon le cours, l’article 226-10 exige que la dénonciation soit “adressée”, ce qui suppose :',
    options: [
      'Une initiative personnelle du dénonciateur',
      'Une publication automatique par une plateforme',
      'Une simple rumeur entendue',
    ],
    answer: 'Une initiative personnelle du dénonciateur',
    explanation:
        'Le cours explique que “adressée” implique une initiative personnelle, d’où l’exigence de spontanéité.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Rapport sur demande',
    question:
        'Selon le cours, un rapport établi sur demande d’un supérieur est en principe :',
    options: [
      'Une dénonciation provoquée (perte de spontanéité)',
      'Toujours une dénonciation spontanée',
      'Toujours une diffamation',
    ],
    answer: 'Une dénonciation provoquée (perte de spontanéité)',
    explanation:
        'Le cours précise que rapports/comptes rendus sur demande font perdre le caractère spontané.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Devoir d’informer',
    question:
        'Selon le cours, la dénonciation faite par un subordonné à ses supérieurs qu’il avait le devoir d’informer :',
    options: [
      'Perd le caractère spontané',
      'Est toujours spontanée',
      'N’existe pas en droit',
    ],
    answer: 'Perd le caractère spontané',
    explanation:
        'Le cours indique que lorsqu’il existe un devoir d’informer, la dénonciation est provoquée et perd la spontanéité.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Faits prescrits',
    question:
        'Selon le cours, la dénonciation peut rester “préjudiciable” même si l’éventualité de sanction est écartée par :',
    options: [
      'La prescription, une immunité, une amnistie ou le décès',
      'Le simple pardon privé',
      'Un changement de téléphone',
    ],
    answer: 'La prescription, une immunité, une amnistie ou le décès',
    explanation:
        'Le cours précise que peu importe qu’une sanction soit finalement impossible (prescription, immunité, amnistie, décès…).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Tribunal compétent (appréciation)',
    question:
        'Selon le cours, en dehors des cas de fausseté “automatique”, la pertinence des accusations est appréciée par :',
    options: [
      'Le tribunal saisi des poursuites contre le dénonciateur',
      'Le maire',
      'Le service RH de l’entreprise',
    ],
    answer: 'Le tribunal saisi des poursuites contre le dénonciateur',
    explanation:
        'Le cours indique que le tribunal apprécie la pertinence des accusations dans les autres cas.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Omission de témoigner',
    question:
        'Selon le cours, si l’auteur découvre son erreur après coup, il pourrait être poursuivi pour :',
    options: [
      'Omission de témoigner en faveur d’un innocent (434-11 C.P.)',
      'Violation de domicile (226-4 C.P.)',
      'Harcèlement moral (222-33-2 C.P.)',
    ],
    answer: 'Omission de témoigner en faveur d’un innocent (434-11 C.P.)',
    explanation:
        'Le cours mentionne la possibilité d’une poursuite pour omission de témoigner en faveur d’un innocent (434-11).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Obtention préalable',
    question:
        'Selon le cours (226-2-1 al.2), le contenu diffusé sans accord doit avoir été préalablement obtenu :',
    options: [
      'Avec le consentement de la personne concernée ou fourni par elle',
      'Uniquement par piratage',
      'Uniquement par enregistrement clandestin',
    ],
    answer: 'Avec le consentement de la personne concernée ou fourni par elle',
    explanation:
        'Le cours précise que la pornodivulgation vise un contenu obtenu avec le consentement (ou fourni par la personne) puis diffusé sans accord.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Caractère sexuel',
    question: 'Selon le cours, le “caractère sexuel” des paroles ou images :',
    options: [
      'Est apprécié par les juridictions compétentes',
      'Est défini uniquement par une liste fermée',
      'Dépend uniquement de l’intention de la victime',
    ],
    answer: 'Est apprécié par les juridictions compétentes',
    explanation:
        'Le cours rappelle que l’appréciation du caractère sexuel relève des juridictions, les termes étant jugés suffisamment clairs.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Diffusion',
    question:
        'Selon le cours, la “diffusion” vise le fait de porter le contenu :',
    options: [
      'À la connaissance du public ou d’un tiers',
      'Uniquement au public via télévision',
      'Uniquement à la victime elle-même',
    ],
    answer: 'À la connaissance du public ou d’un tiers',
    explanation:
        'Le cours précise que la diffusion consiste à porter le contenu à la connaissance du public ou d’un tiers.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Plainte (mention du cours)',
    question:
        'Selon le cours, l’article 226-6 impose le dépôt d’une plainte notamment parce que :',
    options: [
      'La preuve de l’absence d’accord à la diffusion repose souvent sur la déclaration de la victime',
      'La diffusion est toujours publique',
      'Le contenu est toujours un enregistrement sonore',
    ],
    answer:
        'La preuve de l’absence d’accord à la diffusion repose souvent sur la déclaration de la victime',
    explanation:
        'Le cours explique que l’absence d’accord à la diffusion est fréquemment établie par la déclaration de la victime, d’où l’exigence de plainte.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Complicité',
    question: 'Selon le cours, la complicité de pornodivulgation est :',
    options: [
      'Punissable (121-6 et 121-7 C.P.)',
      'Non punissable',
      'Punissable seulement si l’auteur est conjoint',
    ],
    answer: 'Punissable (121-6 et 121-7 C.P.)',
    explanation:
        'Le cours rappelle : complicité oui, selon les règles générales (aide/assistance, provocation, instructions).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Introduction',
    question:
        'Selon le cours (226-4), l’infraction vise l’introduction dans le domicile d’autrui à l’aide de :',
    options: [
      'Manœuvres, menaces, voies de fait ou contrainte',
      'Simple oubli des clés',
      'Accord oral de la voisine',
    ],
    answer: 'Manœuvres, menaces, voies de fait ou contrainte',
    explanation:
        'Le cours énonce explicitement les moyens : manœuvres, menaces, voies de fait ou contrainte.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Contrainte',
    question: 'Selon le cours, la “contrainte” correspond à une situation où :',
    options: [
      'Le consentement de l’occupant n’est pas libre',
      'L’auteur a un double des clés légal',
      'La porte est entrouverte',
    ],
    answer: 'Le consentement de l’occupant n’est pas libre',
    explanation:
        'Le cours définit la contrainte comme toute situation où le consentement n’est pas libre.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Menaces',
    question: 'Selon le cours, les menaces peuvent être caractérisées par :',
    options: [
      'Des paroles ou comportements inquiétants d’une personne prête à commettre des violences',
      'Une simple demande polie',
      'Une invitation de l’occupant',
    ],
    answer:
        'Des paroles ou comportements inquiétants d’une personne prête à commettre des violences',
    explanation:
        'Le cours indique que les menaces peuvent résulter de comportements inquiétants ou de paroles annonçant des violences.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Manœuvres (exemple type)',
    question: 'Selon le cours, une “manœuvre” peut être :',
    options: [
      'Une ruse pour se faire ouvrir la porte',
      'Une déclaration de naissance',
      'Un ticket de caisse',
    ],
    answer: 'Une ruse pour se faire ouvrir la porte',
    explanation:
        'Le cours définit les manœuvres comme des procédés astucieux/ruses facilitant l’introduction illicite.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Domicile et meubles',
    question:
        'Selon le cours, un logement inoccupé peut être considéré comme domicile si :',
    options: [
      'Il contient des meubles révélant une occupation effective (table, chaises, lit, etc.)',
      'Il contient uniquement une bicyclette',
      'Il est totalement vide',
    ],
    answer:
        'Il contient des meubles révélant une occupation effective (table, chaises, lit, etc.)',
    explanation:
        'Le cours précise que la présence de meubles significatifs peut révéler un droit à s’y dire chez soi (appréciation du juge).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Cour non close',
    question:
        'Selon le cours, la cour d’un immeuble n’est pas un domicile lorsque :',
    options: [
      'Elle n’est pas close',
      'Elle a des plantes',
      'Elle est en pente',
    ],
    answer: 'Elle n’est pas close',
    explanation:
        'Le cours cite la cour d’un immeuble lorsqu’elle n’est pas close parmi les exclusions.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Locaux proposés à la location',
    question:
        'Selon la note du cours, les logements vacants non meublés ou proposés à la location (meublés ou non) :',
    options: [
      'Ne sont pas des domiciles au sens de 226-4',
      'Sont toujours des domiciles',
      'Sont des domiciles uniquement la nuit',
    ],
    answer: 'Ne sont pas des domiciles au sens de 226-4',
    explanation:
        'Le cours précise que ces logements ne sont pas des domiciles au sens de 226-4, l’occupation frauduleuse relevant d’autres articles.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Interception sans lecture',
    question:
        'Selon le cours, l’interception d’une correspondance électronique peut être constituée :',
    options: [
      'Même si l’auteur ne prend pas connaissance du contenu',
      'Uniquement si l’auteur lit et répond',
      'Uniquement si l’auteur imprime le message',
    ],
    answer: 'Même si l’auteur ne prend pas connaissance du contenu',
    explanation:
        'Le cours indique que pour l’interception, il n’est pas nécessaire que l’auteur lise le contenu.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Exemple d’utilisation',
    question:
        'Selon le cours, “utiliser” une correspondance électronique peut viser notamment :',
    options: [
      'Effacer ou transférer un message non destiné, même sans l’ouvrir',
      'Lire son propre mail',
      'Répondre à un spam',
    ],
    answer: 'Effacer ou transférer un message non destiné, même sans l’ouvrir',
    explanation:
        'Le cours donne l’exemple : effacer un email non destiné ou le transférer à un tiers, même sans l’ouvrir, relève de “utiliser”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Installation pour un tiers',
    question:
        'Selon le cours, celui qui installe un dispositif d’interception pour le compte d’un tiers est :',
    options: [
      'Considéré comme auteur de la violation du secret des correspondances',
      'Toujours un simple témoin',
      'Non responsable car il n’exploite pas les données',
    ],
    answer:
        'Considéré comme auteur de la violation du secret des correspondances',
    explanation:
        'Le cours précise qu’en l’absence de précision légale, l’installateur est considéré comme auteur, même s’il agit pour un tiers.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Consentement présumé',
    question:
        'Selon le cours, pour les paroles/images (226-1), le consentement peut être présumé si la personne :',
    options: [
      'Ne s’y oppose pas alors qu’elle pouvait le faire, au vu et au su',
      'Signe un contrat',
      'Est filmée de dos',
    ],
    answer: 'Ne s’y oppose pas alors qu’elle pouvait le faire, au vu et au su',
    explanation:
        'Le cours rappelle la présomption : au vu et au su, sans opposition possible.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Localisation et clandestinité',
    question:
        'Selon le cours, la présomption de consentement “au vu et au su” ne s’applique pas à la localisation car :',
    options: [
      'Elle est très facilement clandestine',
      'Elle est toujours publique',
      'Elle ne concerne jamais les mineurs',
    ],
    answer: 'Elle est très facilement clandestine',
    explanation:
        'Le cours explique que la localisation est facilement clandestine (logiciels espions, balises), donc pas de présomption.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Captation de paroles',
    question: 'Selon le cours, la “captation” de paroles vise principalement :',
    options: [
      'L’audition par des tiers grâce à des moyens techniques (ex : conversations téléphoniques)',
      'La lecture d’un texte publié',
      'La reproduction d’une affiche',
    ],
    answer:
        'L’audition par des tiers grâce à des moyens techniques (ex : conversations téléphoniques)',
    explanation:
        'Le cours mentionne notamment l’audition de conversations téléphoniques via des moyens techniques.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Image (objet exclu)',
    question:
        'Selon le cours, est exclue du champ de l’atteinte à l’image (226-1) :',
    options: [
      'La photographie du lieu de vie ou des biens sans personne, même sans consentement',
      'La photo d’une personne dans un lieu privé',
      'La vidéo d’une personne dans un lieu privé',
    ],
    answer:
        'La photographie du lieu de vie ou des biens sans personne, même sans consentement',
    explanation:
        'Le cours précise que l’incrimination vise l’image d’une personne, pas la seule photo du lieu ou de biens.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Lieu privé (définition)',
    question: 'Selon le cours (jurisprudence), un lieu privé est :',
    options: [
      'Un endroit non ouvert à tous sauf autorisation de celui qui l’occupe',
      'Un lieu public surveillé',
      'Un lieu administratif',
    ],
    answer:
        'Un endroit non ouvert à tous sauf autorisation de celui qui l’occupe',
    explanation:
        'Le cours reprend la définition : non ouvert à personne sans autorisation de l’occupant.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Conservation (but)',
    question:
        'Selon le cours, réprimer la “conservation” (226-2) permet notamment :',
    options: [
      'D’empêcher préventivement une publication ou de prévenir un chantage ultérieur',
      'De favoriser la diffusion',
      'D’autoriser automatiquement l’utilisation en justice',
    ],
    answer:
        'D’empêcher préventivement une publication ou de prévenir un chantage ultérieur',
    explanation:
        'Le cours explique que la conservation est punissable pour prévenir la diffusion et limiter les risques de chantage.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité d’une personne — Lieu clos',
    question:
        'Selon le cours (226-3-1), l’infraction peut être constituée si la victime a caché son intimité :',
    options: [
      'Parce qu’elle se trouvait dans un lieu clos',
      'Parce qu’elle est sur un trottoir',
      'Parce qu’elle a un sac à main',
    ],
    answer: 'Parce qu’elle se trouvait dans un lieu clos',
    explanation:
        'Le cours précise : intimité cachée par habillement ou par présence dans un lieu clos.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité d’une personne — Fixation d’images',
    question:
        'Selon le cours (226-3-1 al.2), constitue une aggravation le fait que :',
    options: [
      'Des images aient été fixées, enregistrées ou transmises',
      'La victime soit majeure',
      'Le lieu soit éclairé',
    ],
    answer: 'Des images aient été fixées, enregistrées ou transmises',
    explanation:
        'Le cours indique que la fixation/enregistrement/transmission d’images figure parmi les circonstances aggravantes.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité d’une personne — Transport collectif',
    question:
        'Selon le cours (226-3-1 al.2), l’infraction est aggravée lorsqu’elle est commise :',
    options: [
      'Dans un véhicule de transport collectif ou un lieu d’accès à un transport collectif',
      'Uniquement dans un domicile',
      'Uniquement dans un bureau',
    ],
    answer:
        'Dans un véhicule de transport collectif ou un lieu d’accès à un transport collectif',
    explanation:
        'Le cours liste comme aggravation : transport collectif et lieux destinés à l’accès à un moyen de transport collectif.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Repartage',
    question:
        'Selon le cours, l’incrimination de 226-8 permet aussi de sanctionner :',
    options: [
      'Les personnes repartageant le contenu',
      'Uniquement l’auteur du montage initial',
      'Uniquement les imprimeurs',
    ],
    answer: 'Les personnes repartageant le contenu',
    explanation:
        'Le cours explique que “par quelque voie que ce soit” englobe aussi les repartages du contenu.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Hiérarchie loi 1881',
    question:
        'Selon le cours, en matière de presse, la détermination des responsables renvoie notamment à :',
    options: [
      'L’article 42 de la loi du 29 juillet 1881',
      'L’article 54 de la loi du 9 mars 2004',
      'L’article 372-1 du code civil',
    ],
    answer: 'L’article 42 de la loi du 29 juillet 1881',
    explanation:
        'Le cours cite l’article 42 de la loi de 1881 (directeur de publication, auteur, imprimeur, etc.).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Achèvement',
    question:
        'Selon le cours, 226-15 al.1 vise les correspondances “arrivées ou non à destination”, ce qui signifie :',
    options: [
      'Que l’atteinte peut avoir lieu pendant ou autour de l’acheminement',
      'Uniquement avant l’envoi',
      'Uniquement après lecture par le destinataire',
    ],
    answer:
        'Que l’atteinte peut avoir lieu pendant ou autour de l’acheminement',
    explanation:
        'Le cours précise que l’atteinte peut se produire même si la correspondance n’est pas encore ou n’est plus acheminée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Moyen indifférent',
    question:
        'Selon le cours, pour “ouvrir” une correspondance, le moyen utilisé est :',
    options: [
      'Indifférent (violent ou subtil)',
      'Toujours une effraction',
      'Toujours un crochetage',
    ],
    answer: 'Indifférent (violent ou subtil)',
    explanation:
        'Le cours indique que l’ouverture peut être violente (déchirer) ou subtile (décacheter à la vapeur).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Renvoi au destinataire',
    question:
        'Selon le cours, l’infraction d’ouverture peut être constituée même si le courrier est ensuite :',
    options: [
      'Renvoyé vers son destinataire',
      'Détruit',
      'Signé par le facteur',
    ],
    answer: 'Renvoyé vers son destinataire',
    explanation:
        'Le cours précise que peu importe que la correspondance ait été renvoyée vers son destinataire après ouverture.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Dépositaire par mission temporaire',
    question:
        'Selon le cours, peuvent être dépositaires du secret en raison d’une mission temporaire :',
    options: [
      'Jurés, experts, membres assesseurs',
      'Uniquement les médecins',
      'Uniquement les journalistes',
    ],
    answer: 'Jurés, experts, membres assesseurs',
    explanation:
        'Le cours mentionne notamment jurés, experts, membres assesseurs parmi les missions temporaires pouvant exposer au secret.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Révélation déjà publique',
    question:
        'Selon le cours, si l’information a déjà été rendue publique, l’infraction peut être retenue si le dépositaire :',
    options: [
      'Confirme ou infirme cette information',
      'Se tait complètement',
      'Demande un rendez-vous',
    ],
    answer: 'Confirme ou infirme cette information',
    explanation:
        'Le cours précise que même si l’info est déjà publique, le dépositaire peut être condamné s’il confirme ou infirme.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Nature de la révélation',
    question: 'Selon le cours, la révélation peut être commise :',
    options: [
      'Par la parole ou par la transmission d’un document couvert par le secret',
      'Uniquement par écrit',
      'Uniquement à la télévision',
    ],
    answer:
        'Par la parole ou par la transmission d’un document couvert par le secret',
    explanation:
        'Le cours indique que la forme importe peu : parole ou transmission de documents.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Élément moral',
    question:
        'Selon le cours, l’atteinte au secret professionnel (226-13) est constituée si l’auteur agit :',
    options: [
      'En toute connaissance de cause, avec une révélation intentionnelle',
      'Par simple négligence sans conscience',
      'Uniquement si la victime subit un dommage financier',
    ],
    answer:
        'En toute connaissance de cause, avec une révélation intentionnelle',
    explanation:
        'Le cours insiste : la révélation est intentionnelle et réalisée en connaissance de cause (sans exiger l’intention de nuire).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Complicité',
    question:
        'Selon le cours, la complicité de l’atteinte au secret professionnel est :',
    options: [
      'Punissable (121-6 et 121-7 C.P.)',
      'Toujours exclue',
      'Punissable seulement en cas de récidive',
    ],
    answer: 'Punissable (121-6 et 121-7 C.P.)',
    explanation:
        'Le cours indique : complicité oui, selon les règles générales (aide/assistance, provocation, instructions).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Tentative',
    question:
        'Selon le cours, la tentative de violation du secret professionnel (226-13) est :',
    options: [
      'Non punissable (tentative : non)',
      'Punissable (226-5)',
      'Punissable uniquement en ligne',
    ],
    answer: 'Non punissable (tentative : non)',
    explanation: 'Le cours mentionne : tentative non pour 226-13.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Élément moral',
    question: 'Selon le cours, l’élément moral de 226-1 suppose notamment :',
    options: [
      'La conscience de se livrer à un acte illicite',
      'Une intention de nuire obligatoire',
      'Un mobile politique',
    ],
    answer: 'La conscience de se livrer à un acte illicite',
    explanation:
        'Le cours indique la conscience d’illégalité et la volonté de ne pas respecter la vie privée, le mobile important peu.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Volonté',
    question: 'Selon le cours, l’auteur de 226-1 a pris le parti :',
    options: [
      'De ne pas respecter la vie privée de la victime',
      'De se tromper sans le savoir',
      'D’agir uniquement pour la science',
    ],
    answer: 'De ne pas respecter la vie privée de la victime',
    explanation:
        'Le cours précise la “volonté de porter atteinte à la vie privée d’autrui”, quelle que soit la motivation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Élément moral (double conscience)',
    question: 'Selon le cours, l’élément moral de 226-4 implique :',
    options: [
      'La volonté de s’introduire/se maintenir + la conscience d’agir en dehors des cas prévus par la loi',
      'Une erreur de bonne foi',
      'La simple imprudence',
    ],
    answer:
        'La volonté de s’introduire/se maintenir + la conscience d’agir en dehors des cas prévus par la loi',
    explanation:
        'Le cours mentionne la volonté d’entrer/ rester à l’insu/contre gré, et la conscience d’agir hors les cas permis par la loi.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Complicité',
    question: 'Selon le cours, la complicité de violation de domicile :',
    options: [
      'Est punissable selon les règles générales',
      'Est impossible car infraction non intentionnelle',
      'N’existe que pour les notaires',
    ],
    answer: 'Est punissable selon les règles générales',
    explanation:
        'Le cours précise : complicité oui, application des règles générales.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Secret des correspondances — Mauvaise foi',
    question: 'L’élément moral (mauvaise foi) suppose la conscience :',
    options: [
      'Que la correspondance ne lui était pas destinée et qu’il a volontairement porté atteinte à sa transmission/contenu',
      'D’avoir rendu service à la victime',
      'D’avoir agi par oubli',
    ],
    answer:
        'Que la correspondance ne lui était pas destinée et qu’il a volontairement porté atteinte à sa transmission/contenu',
    explanation:
        'Le cours reprend la définition jurisprudentielle : connaissance de la destination à autrui et conservation volontaire empêchant/retardant.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Aggravation',
    question:
        'L’aggravation de 226-15 al.3 (secret des correspondances) vise notamment les faits commis par :',
    options: [
      'Le conjoint, concubin ou partenaire de PACS',
      'Le facteur',
      'Un témoin anonyme',
    ],
    answer: 'Le conjoint, concubin ou partenaire de PACS',
    explanation:
        'Le cours : al.3 prévoit l’aggravation lorsque l’auteur est conjoint/concubin/PACS.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Peines',
    question: 'En forme simple (226-15 al.1), la peine est :',
    options: [
      '1 an d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 226-15 al.1 (simple) => 1 an + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Tentative',
    question: 'La tentative pour 226-15 al.1 est :',
    options: [
      'Non punissable (tentative : non)',
      'Punissable (prévue par 226-5)',
      'Punissable uniquement si récidive',
    ],
    answer: 'Non punissable (tentative : non)',
    explanation:
        'Le cours mentionne expressément : TENTATIVE : NON pour 226-15 (atteinte au secret des correspondances).',
    difficulty: 'Facile',
  ),

  // =========================================================
  // SECRET PROFESSIONNEL — 226-13 + exceptions 226-14
  // =========================================================
  QuizQuestion(
    category: 'Secret professionnel — Fondement',
    question: 'L’atteinte au secret professionnel est prévue par :',
    options: [
      'L’article 226-13 du Code pénal',
      'L’article 226-10 du Code pénal',
      'L’article 226-4 du Code pénal',
    ],
    answer: 'L’article 226-13 du Code pénal',
    explanation:
        'Le cours : art. 226-13 C.P. réprime la révélation d’une information à caractère secret par un dépositaire.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Personne dépositaire',
    question:
        'Est “dépositaire” du secret au sens de 226-13 une personne qui en a connaissance :',
    options: [
      'Par état, profession, fonction ou mission temporaire',
      'Uniquement par profession médicale',
      'Uniquement par une relation familiale',
    ],
    answer: 'Par état, profession, fonction ou mission temporaire',
    explanation:
        'Le cours reprend la formule : par état/profession/fonction/mission temporaire.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Définition du secret',
    question: 'Selon le cours (jurisprudence), le secret couvre :',
    options: [
      'Tout ce que le dépositaire a pu constater, découvrir ou déduire à l’occasion de sa profession',
      'Uniquement ce qui est écrit “confidentiel”',
      'Uniquement les aveux explicites de la personne',
    ],
    answer:
        'Tout ce que le dépositaire a pu constater, découvrir ou déduire à l’occasion de sa profession',
    explanation:
        'Le cours indique l’extension : pas seulement la confidence, mais aussi ce qui est constaté/découvert/déduit.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Élément matériel',
    question: 'L’acte réprimé par 226-13 consiste en :',
    options: [
      'La révélation d’une information à caractère secret',
      'Le simple fait d’apprendre une information',
      'Le refus de répondre à une question',
    ],
    answer: 'La révélation d’une information à caractère secret',
    explanation:
        'Le cours : 226-13 = révélation d’une information secrète par un dépositaire.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Transmission minimale',
    question:
        'Le délit est constitué dès lors que l’information secrète est transmise :',
    options: [
      'À une seule personne',
      'À au moins dix personnes',
      'Uniquement au public via médias',
    ],
    answer: 'À une seule personne',
    explanation:
        'Le cours précise : il suffit d’une seule transmission à autrui pour constituer l’infraction.',
    difficulty: 'Moyen',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Peines',
    question:
        'L’atteinte au secret professionnel (226-13) est punie (personne physique) de :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '1 an d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation: 'Le cours indique : 226-13 => 1 an + 15 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Exceptions',
    question:
        'Le cours rappelle que 226-13 n’est pas applicable dans certains cas prévus par :',
    options: [
      'L’article 226-14 du Code pénal',
      'L’article 226-12 du Code pénal',
      'L’article 226-2 du Code pénal',
    ],
    answer: 'L’article 226-14 du Code pénal',
    explanation:
        'Le cours liste les exceptions/levées du secret prévues par l’art. 226-14 C.P.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Signalement maltraitances',
    question:
        'Selon le cours (226-14), le secret ne s’applique pas à celui qui informe les autorités de :',
    options: [
      'Maltraitances/privations/sévices infligés à un mineur ou à une personne incapable de se protéger',
      'Un simple conflit de voisinage',
      'Un retard de paiement de loyer',
    ],
    answer:
        'Maltraitances/privations/sévices infligés à un mineur ou à une personne incapable de se protéger',
    explanation:
        'Le cours rappelle l’exception de signalement aux autorités en cas de maltraitances envers mineur/personne vulnérable.',
    difficulty: 'Moyen',
  ),
  // =========================================================
  // PACK 50 QUESTIONS (2/50)
  // =========================================================
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Fondement',
    question: 'La dénonciation calomnieuse est définie et réprimée par :',
    options: [
      'L’article 226-10 du Code pénal',
      'L’article 226-13 du Code pénal',
      'L’article 226-4 du Code pénal',
    ],
    answer: 'L’article 226-10 du Code pénal',
    explanation:
        'Le cours indique : 226-10 C.P. définit et réprime la dénonciation calomnieuse.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Destinataire (supérieur/employeur)',
    question:
        'Selon le cours, la dénonciation calomnieuse peut être constituée si elle est adressée :',
    options: [
      'Aux supérieurs hiérarchiques ou à l’employeur de la personne dénoncée',
      'Uniquement à la presse',
      'Uniquement à la victime',
    ],
    answer:
        'Aux supérieurs hiérarchiques ou à l’employeur de la personne dénoncée',
    explanation:
        'Le cours mentionne explicitement les supérieurs hiérarchiques ou l’employeur parmi les destinataires visés par 226-10.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Consommation (date)',
    question:
        'Selon la jurisprudence citée au cours, l’infraction est consommée :',
    options: [
      'Au jour de réception de la dénonciation par le destinataire',
      'Au jour de rédaction du courrier',
      'Au jour où la victime en entend parler',
    ],
    answer: 'Au jour de réception de la dénonciation par le destinataire',
    explanation:
        'Le cours précise que la jurisprudence retient la date de réception pour la consommation et le départ de prescription.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Prescription (point de départ)',
    question:
        'Selon le cours, le délai de prescription de l’action publique commence à courir :',
    options: [
      'Le jour de réception de la dénonciation',
      'Le jour où l’auteur regrette',
      'Le jour de l’audience',
    ],
    answer: 'Le jour de réception de la dénonciation',
    explanation:
        'Le cours indique que la jurisprudence fixe le point de départ au jour de réception de la dénonciation.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Fausseté automatique',
    question:
        'Selon le cours, la fausseté du fait dénoncé résulte nécessairement d’une décision définitive de :',
    options: [
      'Relaxe, acquittement ou non-lieu déclarant que le fait n’a pas été commis ou n’est pas imputable',
      'Mise en examen',
      'Renvoi devant le tribunal',
    ],
    answer:
        'Relaxe, acquittement ou non-lieu déclarant que le fait n’a pas été commis ou n’est pas imputable',
    explanation:
        'Le cours explique que seules certaines décisions définitives constatant expressément l’absence de fait ou d’imputabilité établissent automatiquement la fausseté.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Faute de charges suffisantes',
    question:
        'Selon le cours, si la décision définitive de relaxe/non-lieu est rendue “faute de charges suffisantes” :',
    options: [
      'Le tribunal apprécie la pertinence des accusations',
      'La fausseté est automatique',
      'L’infraction est automatiquement constituée',
    ],
    answer: 'Le tribunal apprécie la pertinence des accusations',
    explanation:
        'Le cours précise que dans ce cas, la fausseté n’est pas automatique : le tribunal saisi contre le dénonciateur apprécie la pertinence.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Élément moral (moment)',
    question:
        'Selon le cours, l’auteur doit connaître l’inexactitude des faits :',
    options: [
      'Au moment où il les dénonce',
      'Uniquement au moment du procès',
      'Uniquement après la décision définitive',
    ],
    answer: 'Au moment où il les dénonce',
    explanation:
        'Le cours insiste : la conscience de l’inexactitude doit exister au jour de la dénonciation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Volonté de nuire',
    question:
        'Selon le cours, l’auteur de la dénonciation calomnieuse exprime :',
    options: [
      'Une volonté de nuire à la personne visée',
      'Une simple maladresse sans intention',
      'Une obligation légale automatique',
    ],
    answer: 'Une volonté de nuire à la personne visée',
    explanation:
        'Le cours précise que la connaissance de l’inexactitude révèle la volonté de nuire à la personne dénoncée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Tentative',
    question: 'Selon le cours, la tentative de dénonciation calomnieuse est :',
    options: [
      'Non punissable',
      'Punissable (226-5)',
      'Punissable seulement si la victime est dépositaire de l’autorité publique',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours mentionne : TENTATIVE : NON pour l’article 226-10.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Peine (principale)',
    question: 'Selon le cours, la dénonciation calomnieuse est punie de :',
    options: [
      '5 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le tableau du cours mentionne : 5 ans + 45 000 € pour 226-10.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Pornodivulgation — Fondement',
    question:
        'La diffusion, sans accord, d’un contenu intime à caractère sexuel obtenu avec le consentement est réprimée par :',
    options: [
      'L’article 226-2-1 alinéa 2 du Code pénal',
      'L’article 226-1 du Code pénal',
      'L’article 226-15 alinéa 1 du Code pénal',
    ],
    answer: 'L’article 226-2-1 alinéa 2 du Code pénal',
    explanation:
        'Le cours indique : 226-2-1 al.2 réprime la diffusion sans accord d’un enregistrement/document sexuel obtenu avec consentement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Support possible',
    question: 'Selon le cours, le support du contenu diffusé peut être :',
    options: [
      'Visuel, audio, audiovisuel ou écrit (ex : sexting)',
      'Uniquement une vidéo',
      'Uniquement une photographie papier',
    ],
    answer: 'Visuel, audio, audiovisuel ou écrit (ex : sexting)',
    explanation:
        'Le cours précise que le support peut être photo, audio, vidéo ou échange de messages (sexting).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Accord à la captation',
    question: 'Selon le cours, l’accord à être filmé ou photographié :',
    options: [
      'Ne vaut pas accord à la diffusion',
      'Vaut automatiquement accord à la diffusion',
      'Vaut accord à la diffusion seulement si le couple est marié',
    ],
    answer: 'Ne vaut pas accord à la diffusion',
    explanation:
        'Le cours insiste : consentir à la captation n’implique pas consentir à la diffusion.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Menace et chantage',
    question:
        'Selon la note du cours, si l’auteur obtient une signature/engagement/remise de fonds en menaçant de diffuser le contenu intime, il s’agit de :',
    options: [
      'Chantage (312-10 C.P.)',
      'Violation de domicile (226-4 C.P.)',
      'Dénonciation calomnieuse (226-10 C.P.)',
    ],
    answer: 'Chantage (312-10 C.P.)',
    explanation:
        'Le cours mentionne : si la menace de diffusion sert à obtenir signature/engagement/remise, le chantage (312-10) est constitué.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Menace et harcèlement sexuel',
    question:
        'Selon la note du cours, si l’auteur exige des faveurs sexuelles en menaçant de diffuser le contenu intime, il s’agit de :',
    options: [
      'Harcèlement sexuel (222-33 II C.P.)',
      'Atteinte à la représentation (226-8 C.P.)',
      'Secret professionnel (226-13 C.P.)',
    ],
    answer: 'Harcèlement sexuel (222-33 II C.P.)',
    explanation:
        'Le cours indique que la menace de diffusion pour obtenir des faveurs sexuelles caractérise le harcèlement sexuel (222-33 II).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Tentative',
    question:
        'Selon le cours, la tentative de pornodivulgation (226-2-1) est :',
    options: [
      'Punissable (prévue par 226-5)',
      'Non punissable',
      'Punissable seulement si diffusion effective',
    ],
    answer: 'Punissable (prévue par 226-5)',
    explanation:
        'Le cours précise : l’article 226-5 prévoit la tentative du délit 226-2-1.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Peine',
    question:
        'Selon le cours, la pornodivulgation (226-2-1 al.2) est punie de :',
    options: [
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '1 an d’emprisonnement et 45 000 € d’amende',
      '5 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 60 000 € d’amende',
    explanation:
        'Le tableau du cours mentionne : 2 ans + 60 000 € pour 226-2-1 al.2.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Violation de domicile — Fondement',
    question:
        'La violation de domicile commise par un particulier est prévue par :',
    options: [
      'L’article 226-4 du Code pénal',
      'L’article 226-15 du Code pénal',
      'L’article 226-10 du Code pénal',
    ],
    answer: 'L’article 226-4 du Code pénal',
    explanation:
        'Le cours précise : 226-4 définit et réprime la violation de domicile.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Maintien',
    question: 'Selon le cours, constitue également une violation de domicile :',
    options: [
      'Le maintien dans le domicile d’autrui à l’issue d’une introduction illégitime',
      'Le départ immédiat après entrée',
      'Le passage devant la porte',
    ],
    answer:
        'Le maintien dans le domicile d’autrui à l’issue d’une introduction illégitime',
    explanation:
        'Le cours indique que le maintien après une entrée illégitime constitue aussi l’infraction.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Infraction continue',
    question: 'Selon le cours, la violation de domicile est :',
    options: [
      'Une infraction continue',
      'Une contravention instantanée',
      'Un crime',
    ],
    answer: 'Une infraction continue',
    explanation:
        'Le cours précise que la violation de domicile est continue, ce qui a des conséquences en flagrance.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Flagrance',
    question: 'Selon le cours, une enquête de flagrance est possible :',
    options: [
      'Tant que perdure l’occupation illicite',
      'Uniquement dans les 2 heures suivant l’entrée',
      'Uniquement si la porte a été fracturée',
    ],
    answer: 'Tant que perdure l’occupation illicite',
    explanation:
        'Le cours indique : infraction continue → flagrance tant que l’occupation illicite se poursuit.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Appel au secours',
    question: 'Selon le cours, l’introduction peut être légitime en cas de :',
    options: [
      'Réclamation faite de l’intérieur (appel au secours)',
      'Simple curiosité',
      'Invitation supposée',
    ],
    answer: 'Réclamation faite de l’intérieur (appel au secours)',
    explanation:
        'Le cours prévoit un cas d’introduction légitime : appel au secours (cris/hurlements), même si l’appel est fantaisiste.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Incendie/inondation',
    question:
        'Selon le cours, l’introduction peut être justifiée si la maison est :',
    options: [
      'Atteinte ou menacée par un incendie ou une inondation',
      'En travaux',
      'En vente',
    ],
    answer: 'Atteinte ou menacée par un incendie ou une inondation',
    explanation:
        'Le cours cite l’incendie/inondation comme cas d’introduction légitime, même sans réclamation depuis l’intérieur.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Assistance à personne en péril',
    question:
        'Selon le cours, l’introduction est justifiée par ordre de la loi pour :',
    options: [
      'Assistance à personne en péril (indices de péril grave dans un domicile)',
      'Visite de courtoisie',
      'Contrôle d’identité administratif',
    ],
    answer:
        'Assistance à personne en péril (indices de péril grave dans un domicile)',
    explanation:
        'Le cours mentionne que l’introduction peut être justifiée si des indices font croire qu’une personne est gravement en péril dans le domicile.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Tentative',
    question: 'Selon le cours, la tentative de violation de domicile est :',
    options: [
      'Punissable (prévue par 226-5)',
      'Non punissable',
      'Punissable seulement en cas de récidive',
    ],
    answer: 'Punissable (prévue par 226-5)',
    explanation: 'Le cours indique : tentative oui, prévue par 226-5.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Peine',
    question: 'Selon le cours, la violation de domicile (226-4) est punie de :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le tableau du cours indique : 3 ans + 45 000 € pour 226-4.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Propagande “squat” — Fondement',
    question:
        'Le fait de faire la propagande ou publicité de méthodes facilitant la violation de domicile est incriminé par :',
    options: [
      'L’article 226-4-2-1 du Code pénal',
      'L’article 226-4 du Code pénal',
      'L’article 226-8 du Code pénal',
    ],
    answer: 'L’article 226-4-2-1 du Code pénal',
    explanation:
        'Le cours précise que 226-4-2-1 incrimine la propagande/publicité en faveur de méthodes visant à faciliter la violation de domicile.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Propagande “squat” — Objet',
    question:
        'Selon le cours, 226-4-2-1 vise notamment les contenus qui sont de véritables :',
    options: [
      '“Modes d’emploi du squat” (forcer une serrure, conseils d’installation/pérennisation)',
      'Guides de décoration intérieure',
      'Manuels de secourisme',
    ],
    answer:
        '“Modes d’emploi du squat” (forcer une serrure, conseils d’installation/pérennisation)',
    explanation:
        'Le cours mentionne les vidéos “mode d’emploi du squat” comme exemple typique de ce délit.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Propagande “squat” — Peine',
    question:
        'Selon le cours, la propagande/publicité en faveur de méthodes de squat est sanctionnée de :',
    options: ['3 750 € d’amende', '45 000 € d’amende', '60 000 € d’amende'],
    answer: '3 750 € d’amende',
    explanation:
        'Le cours indique que ce délit est sanctionné d’une amende de 3 750 €.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Correspondances électroniques — Fondement',
    question:
        'La violation des correspondances émises par voie électronique est définie par :',
    options: [
      'L’article 226-15 alinéa 2 du Code pénal',
      'L’article 226-15 alinéa 1 du Code pénal',
      'L’article 226-2-1 alinéa 2 du Code pénal',
    ],
    answer: 'L’article 226-15 alinéa 2 du Code pénal',
    explanation:
        'Le cours indique : 226-15 al.2 définit la violation des correspondances par voie électronique.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Répression',
    question:
        'Selon le cours, la répression (peines) de la violation des correspondances électroniques est prévue par :',
    options: [
      'L’article 226-15 alinéa 1 du Code pénal',
      'L’article 226-15 alinéa 2 du Code pénal',
      'L’article 226-13 du Code pénal',
    ],
    answer: 'L’article 226-15 alinéa 1 du Code pénal',
    explanation:
        'Le cours précise : 226-15 al.2 définit, et 226-15 al.1 prévoit la répression.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Mauvaise foi',
    question: 'Selon le cours, la “mauvaise foi” correspond à :',
    options: [
      'La connaissance que les lettres/messages ne lui étaient pas destinés',
      'Le simple fait d’être en colère',
      'Le fait d’avoir un casier judiciaire',
    ],
    answer:
        'La connaissance que les lettres/messages ne lui étaient pas destinés',
    explanation:
        'Le cours cite la Cour de cassation : mauvaise foi = connaissance que les messages ne lui étaient pas destinés.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Erreur',
    question:
        'Selon le cours, violer des correspondances électroniques par méprise ou erreur :',
    options: [
      'Ne constitue pas l’infraction faute d’intention coupable',
      'Constitue toujours l’infraction',
      'Constitue automatiquement une complicité',
    ],
    answer: 'Ne constitue pas l’infraction faute d’intention coupable',
    explanation:
        'Le cours précise que l’erreur/méprise ne permet pas de caractériser l’infraction (absence d’intention).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Aggravation (conjoint)',
    question:
        'Selon le cours, la circonstance aggravante (226-15 al.3) est retenue lorsque les faits sont commis par :',
    options: [
      'Le conjoint, concubin ou partenaire de PACS',
      'Un collègue de travail',
      'Un voisin',
    ],
    answer: 'Le conjoint, concubin ou partenaire de PACS',
    explanation:
        'Le cours mentionne l’aggravation lorsque l’auteur est conjoint/concubin/partenaire de PACS.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Peine aggravée',
    question:
        'Selon le cours, la peine en cas d’infraction aggravée (226-15 al.3) est :',
    options: [
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '1 an d’emprisonnement et 45 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 60 000 € d’amende',
    explanation:
        'Le tableau du cours indique : aggravé (226-15 al.3) = 2 ans + 60 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Tentative',
    question:
        'Selon le cours, la tentative de violation des correspondances électroniques (226-15 al.2) est :',
    options: [
      'Non punissable (tentative : non)',
      'Punissable (226-5)',
      'Punissable uniquement en cas de diffusion',
    ],
    answer: 'Non punissable (tentative : non)',
    explanation:
        'Le cours mentionne : TENTATIVE : NON pour 226-15 (correspondances).',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Atteinte à la représentation — Fondement',
    question:
        'L’atteinte à la représentation de la personne (montage/déepfake) est prévue par :',
    options: [
      'L’article 226-8 du Code pénal',
      'L’article 226-1 du Code pénal',
      'L’article 226-2-1 du Code pénal',
    ],
    answer: 'L’article 226-8 du Code pénal',
    explanation:
        'Le cours précise : 226-8 définit et réprime l’atteinte à la représentation de la personne.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Contenu généré',
    question:
        'Selon le cours, est assimilé à l’infraction le fait de diffuser un contenu représentant l’image ou la voix d’une personne :',
    options: [
      'Généré par traitement algorithmique, sans consentement, sans mention claire',
      'Uniquement si c’est une caricature dessinée à la main',
      'Uniquement si c’est une photo réelle',
    ],
    answer:
        'Généré par traitement algorithmique, sans consentement, sans mention claire',
    explanation:
        'Le cours assimile le contenu visuel/sonore généré algorithmiquement (deepfake) si absence de consentement et absence de mention/évidence.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Aggravation (en ligne)',
    question:
        'Selon le cours, 226-8 est aggravé lorsque l’acte est réalisé via :',
    options: [
      'Un service de communication au public en ligne',
      'Un échange de vive voix',
      'Une conversation privée',
    ],
    answer: 'Un service de communication au public en ligne',
    explanation:
        'Le cours précise : circonstance aggravante si commis via un service de communication au public en ligne (226-8 al.2).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Peine simple',
    question: 'Selon le cours, la peine principale pour 226-8 (simple) est :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '5 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation: 'Le tableau du cours indique : 226-8 al.1 = 1 an + 15 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Peine aggravée',
    question:
        'Selon le cours, la peine principale pour 226-8 (aggravée en ligne) est :',
    options: [
      '2 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 226-8 al.2 (en ligne) = 2 ans + 45 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Tentative',
    question:
        'Selon le cours, la tentative de l’atteinte à la représentation (226-8) est :',
    options: [
      'Punissable (prévue par 226-5)',
      'Non punissable',
      'Punissable seulement si diffusion à plus de 100 personnes',
    ],
    answer: 'Punissable (prévue par 226-5)',
    explanation: 'Le cours indique : tentative oui, prévue à 226-5.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category:
        'Atteinte à la vie privée — Fondement (paroles/images/localisation)',
    question:
        'Les atteintes à l’intimité de la vie privée (paroles/images/localisation) sont prévues par :',
    options: [
      'L’article 226-1 du Code pénal',
      'L’article 226-2-1 du Code pénal',
      'L’article 226-10 du Code pénal',
    ],
    answer: 'L’article 226-1 du Code pénal',
    explanation:
        'Le cours précise : 226-1 définit et réprime les atteintes à l’intimité de la vie privée.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Document de conséquence',
    question:
        'La conservation, diffusion ou utilisation d’un enregistrement/document obtenu par atteinte à la vie privée est prévue par :',
    options: [
      'L’article 226-2 du Code pénal',
      'L’article 226-4 du Code pénal',
      'L’article 226-13 du Code pénal',
    ],
    answer: 'L’article 226-2 du Code pénal',
    explanation:
        'Le cours précise : 226-2 réprime la conservation/diffusion/utilisation d’un document issu d’une atteinte 226-1.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Captation localisation',
    question: 'Selon le cours, 226-1 vise aussi :',
    options: [
      'La captation/enregistrement/transmission de la localisation en temps réel ou différé, sans consentement',
      'Uniquement les photos dans un domicile',
      'Uniquement les propos au téléphone',
    ],
    answer:
        'La captation/enregistrement/transmission de la localisation en temps réel ou différé, sans consentement',
    explanation:
        'Le cours inclut explicitement la localisation (temps réel ou différé) parmi les atteintes 226-1.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Niveau de précision',
    question:
        'Selon le cours, pour la localisation (226-1), le niveau de précision :',
    options: [
      'Importe peu (zone relais ou GPS précis)',
      'Doit être forcément GPS',
      'Doit être forcément en temps réel',
    ],
    answer: 'Importe peu (zone relais ou GPS précis)',
    explanation:
        'Le cours précise que le niveau de précision est indifférent : zone couverte par relais ou GPS.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Consentement localisation',
    question: 'Selon le cours, concernant la localisation, le consentement :',
    options: [
      'N’est pas présumé “au vu et au su” (localisation souvent clandestine)',
      'Est toujours présumé si la victime se déplace en public',
      'Est présumé si l’auteur est un proche',
    ],
    answer:
        'N’est pas présumé “au vu et au su” (localisation souvent clandestine)',
    explanation:
        'Le cours précise que la présomption au vu/au su ne s’applique pas à la localisation.',
    difficulty: 'Moyenne',
  ),
  // =========================================================
  // PACK 50 QUESTIONS (3/50)
  // =========================================================
  QuizQuestion(
    category: 'Atteinte à la vie privée — Aggravation (conjoint)',
    question:
        'Selon le cours, 226-1 est aggravé lorsque les faits sont commis par :',
    options: [
      'Le conjoint, concubin ou partenaire de PACS',
      'Un collègue de bureau',
      'Un passant',
    ],
    answer: 'Le conjoint, concubin ou partenaire de PACS',
    explanation:
        'Le cours cite l’article 226-1 al.7 : aggravation lorsque l’auteur est conjoint/concubin/partenaire de PACS.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Atteinte à la vie privée — Aggravation (dépositaire autorité publique)',
    question:
        'Selon le cours, 226-1 est aggravé lorsque les faits sont commis au préjudice :',
    options: [
      'D’une personne dépositaire de l’autorité publique/chargée d’une mission de service public/élue ou candidate, ou d’un membre de sa famille',
      'D’un simple voisin',
      'D’un commerçant',
    ],
    answer:
        'D’une personne dépositaire de l’autorité publique/chargée d’une mission de service public/élue ou candidate, ou d’un membre de sa famille',
    explanation:
        'Le cours cite l’article 226-1 al.8 : aggravation quand la victime est dépositaire de l’autorité publique, MSP, titulaire/candidat à un mandat, ou membre de sa famille.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Aggravation (contenu sexuel)',
    question:
        'Selon le cours, une circonstance aggravante existe lorsque les faits portent sur :',
    options: [
      'Des paroles ou images à caractère sexuel (226-2-1 al.1)',
      'Des photos de paysage',
      'Un CV professionnel',
    ],
    answer: 'Des paroles ou images à caractère sexuel (226-2-1 al.1)',
    explanation:
        'Le cours mentionne une aggravation lorsque les faits portent sur des paroles/images à caractère sexuel (226-2-1 al.1).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Peine simple',
    question: 'Selon le cours, la peine principale (simple) pour 226-1 est :',
    options: [
      '1 an d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '5 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 226-1 (simple) = 1 an + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Peine aggravée',
    question:
        'Selon le cours, la peine principale lorsque l’infraction est aggravée (226-1 al.7/8 ou 226-2-1 al.1) est :',
    options: [
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '1 an d’emprisonnement et 45 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 60 000 € d’amende',
    explanation: 'Le tableau du cours mentionne : aggravé = 2 ans + 60 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Tentative',
    question: 'Selon le cours, la tentative des délits 226-1 et 226-2 est :',
    options: [
      'Punissable (prévue par 226-5)',
      'Non punissable',
      'Punissable seulement si la victime porte plainte',
    ],
    answer: 'Punissable (prévue par 226-5)',
    explanation:
        'Le cours indique : l’article 226-5 prévoit la tentative des délits 226-1 et 226-2.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Complicité',
    question: 'Selon le cours, la complicité pour 226-1/226-2 :',
    options: [
      'Est punissable (121-6 et 121-7 C.P.)',
      'N’existe pas',
      'N’existe que si l’auteur est journaliste',
    ],
    answer: 'Est punissable (121-6 et 121-7 C.P.)',
    explanation: 'Le cours rappelle : complicité oui, selon règles générales.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Atteinte à l’intimité d’une personne — Fondement',
    question:
        'L’atteinte à l’intimité d’une personne (upskirting, observation parties intimes) est prévue par :',
    options: [
      'L’article 226-3-1 du Code pénal',
      'L’article 226-1 du Code pénal',
      'L’article 226-8 du Code pénal',
    ],
    answer: 'L’article 226-3-1 du Code pénal',
    explanation:
        'Le cours précise : 226-3-1 prévoit et réprime l’atteinte à l’intimité d’une personne.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Atteinte à l’intimité d’une personne — Condition (parties cachées)',
    question:
        'Selon le cours (226-3-1), l’infraction vise l’observation de parties intimes que la victime a cachées :',
    options: [
      'Du fait de son habillement ou de sa présence dans un lieu clos',
      'Uniquement parce qu’elle est dans un véhicule',
      'Uniquement parce qu’elle est sur internet',
    ],
    answer: 'Du fait de son habillement ou de sa présence dans un lieu clos',
    explanation:
        'Le cours précise les deux hypothèses : cachées par les habits ou par présence dans un lieu clos.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité d’une personne — À l’insu',
    question: 'Selon le cours, l’auteur doit avoir agi :',
    options: [
      'À l’insu ou sans le consentement de la victime',
      'Avec un mandat judiciaire',
      'Avec une autorisation écrite du maire',
    ],
    answer: 'À l’insu ou sans le consentement de la victime',
    explanation:
        'Le cours mentionne explicitement cette condition : à l’insu ou sans consentement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Atteinte à l’intimité d’une personne — Circonstance aggravante (abus d’autorité)',
    question: 'Selon le cours, 226-3-1 est aggravé lorsqu’il est commis :',
    options: [
      'Par une personne abusant de l’autorité que lui confèrent ses fonctions',
      'Par une personne au chômage',
      'Par une personne mineure',
    ],
    answer:
        'Par une personne abusant de l’autorité que lui confèrent ses fonctions',
    explanation:
        'Le cours liste l’abus d’autorité liée aux fonctions parmi les circonstances aggravantes de 226-3-1.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Atteinte à l’intimité d’une personne — Circonstance aggravante (mineur)',
    question:
        'Selon le cours, l’infraction (226-3-1) est aggravée lorsqu’elle est commise :',
    options: [
      'Sur un mineur',
      'Sur une personne connue',
      'Sur une personne qui rit',
    ],
    answer: 'Sur un mineur',
    explanation:
        'Le cours mentionne explicitement l’aggravation lorsque les faits sont commis sur un mineur.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Atteinte à l’intimité d’une personne — Circonstance aggravante (vulnérabilité)',
    question:
        'Selon le cours, l’aggravation est retenue lorsque la victime est vulnérable (âge/maladie/infirmité/déficience/grossesse) :',
    options: [
      'Si cette vulnérabilité est apparente ou connue de l’auteur',
      'Uniquement si la victime a porté plainte',
      'Uniquement si la victime est mineure',
    ],
    answer: 'Si cette vulnérabilité est apparente ou connue de l’auteur',
    explanation:
        'Le cours précise : vulnérabilité due à divers facteurs, apparente ou connue de l’auteur.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Atteinte à l’intimité d’une personne — Circonstance aggravante (plusieurs)',
    question:
        'Selon le cours, l’infraction est aggravée lorsqu’elle est commise :',
    options: [
      'Par plusieurs personnes agissant en qualité d’auteur ou de complice',
      'Uniquement par une personne seule',
      'Uniquement par un professionnel de santé',
    ],
    answer:
        'Par plusieurs personnes agissant en qualité d’auteur ou de complice',
    explanation:
        'Le cours liste l’action de plusieurs personnes (auteur/complice) comme circonstance aggravante.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité d’une personne — Peine simple',
    question: 'Selon le cours, la peine principale (simple) pour 226-3-1 est :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '1 an d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 226-3-1 al.1 = 1 an + 15 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité d’une personne — Peine aggravée',
    question:
        'Selon le cours, la peine principale (aggravée) pour 226-3-1 al.2 est :',
    options: [
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 30 000 € d’amende',
    explanation:
        'Le tableau du cours indique : aggravé (226-3-1 al.2) = 2 ans + 30 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité d’une personne — Tentative',
    question: 'Selon le cours, la tentative de 226-3-1 est :',
    options: [
      'Punissable (prévue par 226-5)',
      'Non punissable',
      'Punissable seulement si des images existent',
    ],
    answer: 'Punissable (prévue par 226-5)',
    explanation:
        'Le cours précise : tentative expressément prévue par 226-5 pour 226-3-1.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité d’une personne — Élément moral',
    question: 'Selon le cours, l’élément moral de 226-3-1 implique notamment :',
    options: [
      'Conscience de commettre un acte impudique et volonté d’attenter à l’intimité',
      'Erreur de bonne foi',
      'Simple maladresse sans intention',
    ],
    answer:
        'Conscience de commettre un acte impudique et volonté d’attenter à l’intimité',
    explanation:
        'Le cours mentionne la conscience de l’acte impudique et la volonté d’atteindre l’intimité de la victime.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Secret des correspondances — Fondement (papier)',
    question:
        'L’atteinte au secret des correspondances (courrier) commise par un particulier est prévue par :',
    options: [
      'L’article 226-15 alinéa 1 du Code pénal',
      'L’article 226-15 alinéa 2 du Code pénal',
      'L’article 226-1 du Code pénal',
    ],
    answer: 'L’article 226-15 alinéa 1 du Code pénal',
    explanation:
        'Le cours précise : 226-15 al.1 définit et réprime l’atteinte au secret des correspondances (support tangible).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Actes visés',
    question: 'Selon le cours, 226-15 al.1 réprime notamment le fait :',
    options: [
      'D’ouvrir, supprimer, retarder, détourner ou prendre frauduleusement connaissance',
      'D’archiver son propre courrier',
      'De changer d’adresse',
    ],
    answer:
        'D’ouvrir, supprimer, retarder, détourner ou prendre frauduleusement connaissance',
    explanation:
        'Le cours énumère ces actes matériels constitutifs de l’atteinte au secret des correspondances.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Altération partielle',
    question:
        'Selon le cours, l’ouverture est caractérisée par tout acte portant atteinte à l’intégrité du support et donnant accès au contenu, même si :',
    options: [
      'L’altération est seulement partielle',
      'Le courrier est de faible valeur',
      'La victime est inconnue',
    ],
    answer: 'L’altération est seulement partielle',
    explanation:
        'Le cours indique que l’altération peut être totale ou partielle : l’infraction peut être constituée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Détournement (sens)',
    question: 'Selon le cours, “détourner” une correspondance consiste à :',
    options: [
      'Modifier le cours normal de la transmission (retard volontaire)',
      'Répondre au courrier',
      'Trier le courrier',
    ],
    answer: 'Modifier le cours normal de la transmission (retard volontaire)',
    explanation:
        'Le cours indique que le détournement se matérialise en modifiant le cours normal de la transmission.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Mauvaise foi (papier)',
    question:
        'Selon le cours, la mauvaise foi (226-15 al.1) implique notamment la connaissance :',
    options: [
      'Que les lettres ne lui étaient pas destinées et qu’il les a volontairement conservées pour empêcher/retarder la transmission',
      'Que la lettre est fragile',
      'Que l’enveloppe est blanche',
    ],
    answer:
        'Que les lettres ne lui étaient pas destinées et qu’il les a volontairement conservées pour empêcher/retarder la transmission',
    explanation:
        'Le cours cite la Cour de cassation : connaissance du caractère “non destiné” + conservation volontaire pour empêcher/retarder.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Intention de nuire',
    question: 'Selon le cours, pour 226-15 al.1, l’intention de nuire :',
    options: [
      'N’est pas exigée',
      'Est obligatoire',
      'Est présumée automatiquement',
    ],
    answer: 'N’est pas exigée',
    explanation:
        'Le cours précise que l’intention de nuire n’est pas exigée : le mobile importe peu.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Tentative',
    question:
        'Selon le cours, la tentative d’atteinte au secret des correspondances (226-15 al.1) est :',
    options: [
      'Non punissable',
      'Punissable (226-5)',
      'Punissable uniquement si l’auteur est conjoint',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours mentionne : TENTATIVE : NON pour 226-15 al.1.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Peine simple',
    question:
        'Selon le cours, la peine principale (simple) pour 226-15 al.1 est :',
    options: [
      '1 an d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le tableau du cours indique : simple (226-15 al.1) = 1 an + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Peine aggravée (conjoint)',
    question: 'Selon le cours, la peine aggravée (226-15 al.3) est :',
    options: [
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '1 an d’emprisonnement et 45 000 € d’amende',
      '5 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 60 000 € d’amende',
    explanation:
        'Le tableau du cours indique : aggravé (226-15 al.3) = 2 ans + 60 000 €.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Secret professionnel — Fondement',
    question:
        'L’atteinte au secret professionnel est définie et réprimée par :',
    options: [
      'L’article 226-13 du Code pénal',
      'L’article 226-10 du Code pénal',
      'L’article 226-8 du Code pénal',
    ],
    answer: 'L’article 226-13 du Code pénal',
    explanation:
        'Le cours indique : 226-13 définit et réprime l’atteinte au secret professionnel.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Dépositaire',
    question:
        'Selon le cours, est dépositaire du secret celui qui détient l’information :',
    options: [
      'Par état, profession, fonction ou mission temporaire',
      'Uniquement par profession médicale',
      'Uniquement par héritage',
    ],
    answer: 'Par état, profession, fonction ou mission temporaire',
    explanation:
        'Le cours reprend la formule de 226-13 : dépositaire par état/profession/fonction/mission temporaire.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — “État” (sens)',
    question: 'Selon le cours, “par son état” renvoie notamment :',
    options: [
      'Au statut juridique/professionnel (ex : ministre du culte, élèves d’une profession soumise au secret)',
      'À l’état civil de la victime',
      'À la météo',
    ],
    answer:
        'Au statut juridique/professionnel (ex : ministre du culte, élèves d’une profession soumise au secret)',
    explanation:
        'Le cours explique que “l’état” renvoie à la situation de fait/droit, au statut (ex : ministre du culte, élèves orthophonistes…).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — “Profession” (sens)',
    question: 'Selon le cours, la “profession” est :',
    options: [
      'L’activité habituellement exercée pour se procurer des ressources',
      'Une activité occasionnelle de loisir',
      'Une mission bénévole unique',
    ],
    answer: 'L’activité habituellement exercée pour se procurer des ressources',
    explanation:
        'Le cours définit la profession comme l’activité exercée habituellement pour vivre.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — “Fonction”',
    question: 'Selon le cours, la “fonction” correspond :',
    options: [
      'À une charge et l’activité occasionnée par cette charge',
      'À un hobby',
      'À un statut familial',
    ],
    answer: 'À une charge et l’activité occasionnée par cette charge',
    explanation:
        'Le cours précise : la fonction est une charge et l’activité qui en découle ; le secret s’applique aux informations reçues à ce titre.',
    difficulty: 'Moyenne',
  ),
  // =========================================================
  // PACK 50 QUESTIONS (4/50)
  // =========================================================
  QuizQuestion(
    category: 'Secret professionnel — Mission temporaire (définition)',
    question: 'Selon le cours, une “mission temporaire” correspond :',
    options: [
      'À une intervention ponctuelle où l’on apprend des infos confidentielles',
      'À un CDI dans une entreprise',
      'À une activité sans aucun accès à des informations',
    ],
    answer:
        'À une intervention ponctuelle où l’on apprend des infos confidentielles',
    explanation:
        'Le cours indique que la mission temporaire est une tâche ponctuelle qui expose à des informations confidentielles/destinées à l’être.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Définition du secret (portée)',
    question: 'Selon le cours, le secret professionnel couvre :',
    options: [
      'Tout ce que le dépositaire a constaté, découvert ou déduit à l’occasion de sa profession',
      'Uniquement les confidences écrites',
      'Uniquement les secrets médicaux',
    ],
    answer:
        'Tout ce que le dépositaire a constaté, découvert ou déduit à l’occasion de sa profession',
    explanation:
        'Le cours étend le secret à ce qui a été constaté/découvert/déduit personnellement dans le cadre professionnel.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Révélation (condition minimale)',
    question:
        'Selon le cours, il suffit que l’information couverte par le secret soit transmise :',
    options: [
      'À une seule personne pour que l’infraction soit constituée',
      'À au moins 10 personnes',
      'Uniquement au public via médias',
    ],
    answer: 'À une seule personne pour que l’infraction soit constituée',
    explanation:
        'Le cours précise : transmission à une seule personne suffit à caractériser la révélation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Personnes morales (responsabilité)',
    question:
        'Selon le cours, la responsabilité pénale des personnes morales pour 226-13 est prévue par :',
    options: [
      'L’article 121-2 du Code pénal',
      'L’article 226-5 du Code pénal',
      'L’article 226-1 du Code pénal',
    ],
    answer: 'L’article 121-2 du Code pénal',
    explanation:
        'Le cours mentionne la responsabilité des personnes morales sur le fondement de l’article 121-2 C.P.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Peine (personne physique)',
    question:
        'Selon le cours, la violation du secret professionnel (226-13) est punie de :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '1 an d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 226-13 = 1 an d’emprisonnement + 15 000 € d’amende.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Exceptions (principe)',
    question:
        'Selon le cours, les exceptions au secret professionnel sont prévues par :',
    options: [
      'L’article 226-14 du Code pénal',
      'L’article 226-12 du Code pénal',
      'L’article 226-4 du Code pénal',
    ],
    answer: 'L’article 226-14 du Code pénal',
    explanation:
        'Le cours rappelle que 226-14 prévoit les cas où 226-13 n’est pas applicable (signalements).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Signalement (mineur/vulnérable)',
    question:
        'Selon le cours (226-14), l’exception vise notamment le signalement de :',
    options: [
      'Maltraitances, privations ou sévices infligés à un mineur ou à une personne incapable de se protéger',
      'Un différend commercial banal',
      'Une dispute entre collègues',
    ],
    answer:
        'Maltraitances, privations ou sévices infligés à un mineur ou à une personne incapable de se protéger',
    explanation:
        'Le cours cite explicitement cette exception majeure au secret professionnel.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Santé (cellule infos préoccupantes)',
    question:
        'Selon le cours (226-14), un professionnel de santé peut porter à la connaissance :',
    options: [
      'De la cellule de recueil/traitement/évaluation des informations préoccupantes relatives aux mineurs',
      'De n’importe quel influenceur',
      'Du voisinage entier',
    ],
    answer:
        'De la cellule de recueil/traitement/évaluation des informations préoccupantes relatives aux mineurs',
    explanation:
        'Le cours mentionne la possibilité de signaler à la cellule compétente (infos préoccupantes) pour les mineurs.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Accords (victime mineure)',
    question:
        'Selon le cours (226-14), lorsque la victime est un mineur ou une personne incapable de se protéger, l’accord de la victime :',
    options: [
      'N’est pas nécessaire',
      'Est toujours obligatoire',
      'Doit être écrit et notarié',
    ],
    answer: 'N’est pas nécessaire',
    explanation:
        'Le cours précise que l’accord de la victime n’est pas nécessaire si la victime est mineure ou incapable de se protéger.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Sujétion (223-15-3)',
    question:
        'Selon le cours (226-14), un professionnel de santé peut signaler des faits de sujétion (223-15-3) si :',
    options: [
      'Il estime en conscience que cela altère gravement la santé ou conduit à un acte/abstention gravement préjudiciable',
      'La victime est célèbre',
      'La victime a déménagé',
    ],
    answer:
        'Il estime en conscience que cela altère gravement la santé ou conduit à un acte/abstention gravement préjudiciable',
    explanation:
        'Le cours décrit précisément cette exception : signalement si sujétion causant altération grave ou conduite gravement préjudiciable.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Secret professionnel — Violence au sein du couple (danger immédiat)',
    question:
        'Selon le cours (226-14), le signalement de violences au sein du couple est possible si :',
    options: [
      'La vie de la victime majeure est en danger immédiat et elle ne peut se protéger du fait de l’emprise/contrainte morale',
      'La victime a simplement peur sans danger',
      'Les faits sont anciens et sans risque',
    ],
    answer:
        'La vie de la victime majeure est en danger immédiat et elle ne peut se protéger du fait de l’emprise/contrainte morale',
    explanation:
        'Le cours fixe les conditions : danger immédiat + impossibilité de se protéger en raison de l’emprise.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Violence au sein du couple (accord)',
    question:
        'Selon le cours (226-14), le médecin/professionnel de santé doit :',
    options: [
      'S’efforcer d’obtenir l’accord de la victime majeure',
      'Toujours signaler sans jamais consulter la victime',
      'Informer d’abord l’auteur des violences',
    ],
    answer: 'S’efforcer d’obtenir l’accord de la victime majeure',
    explanation:
        'Le cours précise que le médecin doit s’efforcer d’obtenir l’accord ; à défaut, il informe la victime du signalement.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Violence au sein du couple (information)',
    question:
        'Selon le cours (226-14), en cas d’impossibilité d’obtenir l’accord, le professionnel doit :',
    options: [
      'Informer la victime du signalement fait au procureur',
      'Ne rien dire à personne',
      'Informer uniquement l’employeur',
    ],
    answer: 'Informer la victime du signalement fait au procureur',
    explanation:
        'Le cours indique que si l’accord est impossible, la victime doit être informée du signalement.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Détention d’arme (préfet)',
    question:
        'Selon le cours (226-14), des professionnels peuvent informer le préfet (ou préfet de police à Paris) lorsqu’ils savent que la personne :',
    options: [
      'Détient une arme ou a manifesté l’intention d’en acquérir une et présente un danger',
      'Possède une voiture',
      'Fume du tabac',
    ],
    answer:
        'Détient une arme ou a manifesté l’intention d’en acquérir une et présente un danger',
    explanation:
        'Le cours mentionne l’exception permettant d’informer le préfet si la personne est dangereuse et détient/veut acquérir une arme.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Vétérinaire (maltraitance animale)',
    question:
        'Selon le cours (226-14), le vétérinaire peut signaler au procureur :',
    options: [
      'Sévices graves, acte de cruauté, atteinte sexuelle sur un animal, ou mauvais traitements constatés',
      'Uniquement les pertes d’animaux domestiques',
      'Uniquement les nuisances sonores',
    ],
    answer:
        'Sévices graves, acte de cruauté, atteinte sexuelle sur un animal, ou mauvais traitements constatés',
    explanation:
        'Le cours cite l’exception spécifique au vétérinaire pour signaler des faits graves sur un animal.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Immunité (bonne foi)',
    question:
        'Selon le cours (226-14), le signalement fait dans ces conditions :',
    options: [
      'Ne peut engager la responsabilité sauf absence de bonne foi',
      'Engage toujours la responsabilité pénale',
      'Annule automatiquement tout secret professionnel futur',
    ],
    answer: 'Ne peut engager la responsabilité sauf absence de bonne foi',
    explanation:
        'Le cours indique que le signalement ne peut engager la responsabilité, sauf si l’auteur n’a pas agi de bonne foi.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Atteinte à la représentation — Montage (condition trompeuse)',
    question:
        'Selon le cours (226-8), l’infraction est constituée si le montage est diffusé sans consentement et :',
    options: [
      'Qu’il n’apparaît pas à l’évidence qu’il s’agit d’un montage ou qu’il n’en est pas fait mention',
      'Que le montage est de mauvaise qualité',
      'Que le montage dure moins de 10 secondes',
    ],
    answer:
        'Qu’il n’apparaît pas à l’évidence qu’il s’agit d’un montage ou qu’il n’en est pas fait mention',
    explanation:
        'Le cours pose la condition : absence d’évidence ou absence de mention explicite.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Création de profils (exclusion)',
    question:
        'Selon la jurisprudence citée au cours, créer un profil sur un réseau social au nom d’un tiers, sans montage parole/image, relève :',
    options: [
      'Pas de 226-8 (hors champ)',
      'Toujours de 226-8',
      'Toujours de 226-4',
    ],
    answer: 'Pas de 226-8 (hors champ)',
    explanation:
        'Le cours cite que l’écrit seul (sans montage parole/image) ne relève pas de 226-8.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Montage (définition générale)',
    question: 'Selon le cours, le montage peut résulter :',
    options: [
      'D’un ajout/retrait d’éléments étrangers à l’objet (détournement délibéré)',
      'D’une simple photo non retouchée',
      'D’un texte manuscrit',
    ],
    answer:
        'D’un ajout/retrait d’éléments étrangers à l’objet (détournement délibéré)',
    explanation:
        'Le cours rappelle la jurisprudence : montage réprimé lorsqu’il déforme délibérément par ajout/retrait d’éléments étrangers.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Consentement (portée)',
    question: 'Selon le cours (226-8), le consentement porte sur :',
    options: [
      'La publication/révélation du contenu (pas nécessairement sa création)',
      'La création du contenu uniquement',
      'L’achat du matériel',
    ],
    answer:
        'La publication/révélation du contenu (pas nécessairement sa création)',
    explanation:
        'Le cours précise : le consentement requis vise la publication/révélation à un tiers.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Correspondances électroniques — Courriel (définition LCEN)',
    question:
        'Selon le cours, la loi du 21 juin 2004 définit le courrier électronique comme :',
    options: [
      'Un message (texte/voix/son/image) envoyé par réseau public et stocké jusqu’à récupération par le destinataire',
      'Un message uniquement imprimé',
      'Un message transmis uniquement par fax',
    ],
    answer:
        'Un message (texte/voix/son/image) envoyé par réseau public et stocké jusqu’à récupération par le destinataire',
    explanation:
        'Le cours reprend la définition LCEN : message stocké sur serveur/terminal jusqu’à récupération.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Limite “données informatiques”',
    question:
        'Selon le cours, une fois que le destinataire a pris connaissance du mail, il :',
    options: [
      'Perd son caractère spécifique et devient une donnée informatique quelconque',
      'Devient automatiquement une preuve irrecevable',
      'Devient une correspondance papier',
    ],
    answer:
        'Perd son caractère spécifique et devient une donnée informatique quelconque',
    explanation:
        'Le cours précise qu’après lecture par le destinataire, la correspondance perd son statut spécifique.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Détournement (mail en attente)',
    question: 'Selon le cours, le “détournement” peut viser des messages :',
    options: [
      'Ouverts par un tiers alors qu’ils sont en attente d’être lus par le destinataire',
      'Publié volontairement par le destinataire',
      'Écrits sur une carte postale',
    ],
    answer:
        'Ouverts par un tiers alors qu’ils sont en attente d’être lus par le destinataire',
    explanation:
        'Le cours indique que la jurisprudence retient le détournement pour des messages ouverts par un tiers alors qu’ils attendent d’être lus.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Divulgation (exemple)',
    question:
        'Selon le cours, “divulguer” une correspondance électronique peut consister à :',
    options: [
      'Transmettre à un tiers un courriel intercepté',
      'Supprimer son propre mail',
      'Envoyer un mail à soi-même',
    ],
    answer: 'Transmettre à un tiers un courriel intercepté',
    explanation:
        'Le cours décrit la divulgation : révéler à un tiers le contenu d’une correspondance qui ne lui est pas destinée.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Violation de domicile — Domicile (définition générale)',
    question: 'Selon le cours, le domicile comprend notamment :',
    options: [
      'Tout local d’habitation contenant des biens meubles appartenant à la personne, qu’elle y habite ou non',
      'Uniquement la résidence principale occupée',
      'Uniquement un logement vide',
    ],
    answer:
        'Tout local d’habitation contenant des biens meubles appartenant à la personne, qu’elle y habite ou non',
    explanation:
        'Le cours donne une définition large : local d’habitation avec biens meubles, résidence principale ou non, habitation effective ou non.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Dépendances',
    question: 'Selon le cours, peuvent être des domiciles (prolongement) :',
    options: [
      'Garage, débarras, balcon, terrasse, dépendances proches',
      'Parking public ouvert',
      'Hall de gare',
    ],
    answer: 'Garage, débarras, balcon, terrasse, dépendances proches',
    explanation:
        'Le cours cite diverses dépendances constituant le prolongement du domicile si elles sont à proximité immédiate.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Nécessité de proximité',
    question:
        'Selon le cours, pour qu’une dépendance soit assimilée au domicile, il faut :',
    options: [
      'Un lien étroit et immédiat et une proximité avec l’habitation',
      'Qu’elle soit située dans une autre ville',
      'Qu’elle soit ouverte au public',
    ],
    answer: 'Un lien étroit et immédiat et une proximité avec l’habitation',
    explanation:
        'Le cours insiste sur la proximité et le lien étroit unissant la dépendance à l’habitation.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Véhicule aménagé',
    question: 'Selon le cours, peut être un domicile :',
    options: [
      'Un véhicule aménagé pour l’habitation, une caravane, une roulotte, une tente',
      'Une voiture classique non aménagée en stationnement',
      'Un vélo',
    ],
    answer:
        'Un véhicule aménagé pour l’habitation, une caravane, une roulotte, une tente',
    explanation:
        'Le cours mentionne ces formes d’habitat comme entrant dans la notion de domicile.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Lieux professionnels',
    question:
        'Selon le cours, les locaux professionnels peuvent être considérés comme domicile :',
    options: [
      'Sauf lorsqu’ils sont ouverts au public pendant les heures d’ouverture',
      'Toujours, même en pleine ouverture au public',
      'Jamais',
    ],
    answer:
        'Sauf lorsqu’ils sont ouverts au public pendant les heures d’ouverture',
    explanation:
        'Le cours précise que les bureaux/locaux pro peuvent être protégés, mais pas les lieux ouverts au public pendant l’ouverture.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Dénonciation calomnieuse — Personne déterminée',
    question: 'Selon le cours (226-10), la dénonciation doit viser :',
    options: [
      'Une personne déterminée (physique ou morale) identifiable',
      'Une catégorie vague (“tout le monde”)',
      'Un lieu sans personne',
    ],
    answer: 'Une personne déterminée (physique ou morale) identifiable',
    explanation:
        'Le cours précise que la victime doit être déterminée et identifiable, personne physique ou morale.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Identification sans nom',
    question:
        'Selon le cours, même sans nomination, une personne peut être identifiée si :',
    options: [
      'La dénonciation contient des détails faisant nécessairement porter les soupçons sur elle',
      'La dénonciation est écrite en majuscules',
      'La dénonciation est envoyée à plusieurs personnes',
    ],
    answer:
        'La dénonciation contient des détails faisant nécessairement porter les soupçons sur elle',
    explanation:
        'Le cours précise que des détails suffisamment précis peuvent permettre l’identification sans nom.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Auteur moral',
    question: 'Selon le cours, est assimilé à l’auteur juridique :',
    options: [
      'L’auteur moral (celui qui fait effectuer la dénonciation par un tiers)',
      'Un simple lecteur de la lettre',
      'La victime',
    ],
    answer:
        'L’auteur moral (celui qui fait effectuer la dénonciation par un tiers)',
    explanation:
        'Le cours indique que l’auteur moral est assimilé à l’auteur juridique.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Dénonciation anonyme',
    question: 'Selon le cours, en cas de dénonciation anonyme, il faut que :',
    options: [
      'L’auteur soit identifiable',
      'Le contenu soit imprimé',
      'La victime soit une personne publique',
    ],
    answer: 'L’auteur soit identifiable',
    explanation:
        'Le cours précise qu’il faut pouvoir identifier l’auteur pour poursuivre en cas d’anonymat.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Atteinte à la vie privée — Paroles (consentement présumé)',
    question:
        'Selon le cours, le consentement aux captations de paroles peut être présumé si l’acte est réalisé :',
    options: [
      'Au vu et au su de la personne sans opposition alors qu’elle pouvait s’y opposer',
      'Toujours si l’auteur est ami',
      'Toujours si c’est sur la voie publique',
    ],
    answer:
        'Au vu et au su de la personne sans opposition alors qu’elle pouvait s’y opposer',
    explanation:
        'Le cours reprend la présomption de consentement au vu et au su, à condition qu’elle puisse s’opposer.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Image (droit général)',
    question: 'Selon le cours, toute personne a le droit :',
    options: [
      'D’interdire la reproduction non autorisée de son image (prolongement de la personnalité)',
      'D’interdire toute photo de paysage',
      'D’exiger une publication systématique',
    ],
    answer:
        'D’interdire la reproduction non autorisée de son image (prolongement de la personnalité)',
    explanation:
        'Le cours rappelle le principe : le droit à l’image est le prolongement de la personnalité.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Pornodivulgation — “Revenge porn” (terme)',
    question:
        'Selon le cours, la pornodivulgation a été popularisée sous le terme :',
    options: ['Revenge porn', 'Happy sharing', 'Open data'],
    answer: 'Revenge porn',
    explanation:
        'Le cours indique que ces agissements ont été popularisés en France sous l’appellation anglophone “revenge porn”.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Définition pratique',
    question: 'Selon le cours, la pornodivulgation consiste à :',
    options: [
      'Obtenir un contenu intime avec consentement puis le diffuser sans consentement',
      'Filmer clandestinement dans un lieu privé',
      'Publier une image de paysage',
    ],
    answer:
        'Obtenir un contenu intime avec consentement puis le diffuser sans consentement',
    explanation:
        'Le cours décrit le schéma typique : obtention consentie (photo/vidéo/sexting) puis diffusion non consentie.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Propagande “squat” — Mode de commission',
    question: 'Selon le cours, 226-4-2-1 réprime la propagande/publicité :',
    options: [
      'Quel qu’en soit le mode',
      'Uniquement en vidéo',
      'Uniquement sur papier',
    ],
    answer: 'Quel qu’en soit le mode',
    explanation:
        'Le cours précise : propagande/publicité “quel qu’en soit le mode”.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Propagande “squat” — Presse (règles spéciales)',
    question:
        'Selon le cours, lorsque 226-4-2-1 est commis par voie de presse écrite ou audiovisuelle :',
    options: [
      'Les lois spéciales de la presse s’appliquent (responsabilités)',
      'Il n’y a jamais de poursuites',
      'Le délit devient une contravention',
    ],
    answer: 'Les lois spéciales de la presse s’appliquent (responsabilités)',
    explanation:
        'Le cours précise l’application des dispositions particulières des lois régissant la presse.',
    difficulty: 'Difficile',
  ),
  // =========================================================
  // PACK 50 QUESTIONS (5/50)
  // =========================================================
  QuizQuestion(
    category: 'Atteinte à la vie privée — Procédé quelconque',
    question:
        'Selon le cours (226-1), les atteintes à la vie privée peuvent être commises :',
    options: [
      'Au moyen d’un procédé quelconque (technique ou non)',
      'Uniquement avec une caméra',
      'Uniquement avec un micro',
    ],
    answer: 'Au moyen d’un procédé quelconque (technique ou non)',
    explanation:
        'Le cours précise que sont visés tous procédés permettant le résultat, avec ou sans appareil.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Enregistrement inaudible',
    question:
        'Selon le cours (226-1), l’infraction d’enregistrement de paroles privées est constituée :',
    options: [
      'Même si l’enregistrement est inaudible',
      'Uniquement si l’enregistrement est parfaitement audible',
      'Uniquement si l’enregistrement est publié',
    ],
    answer: 'Même si l’enregistrement est inaudible',
    explanation:
        'Le cours indique que l’infraction est constituée quels que soient les résultats techniques : même inaudible.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Paroles en lieu public',
    question:
        'Selon le cours (226-1), la captation/enregistrement de paroles privées peut être constituée :',
    options: [
      'Même si les paroles sont prononcées dans un lieu public (si elles sont privées/confidentielles)',
      'Uniquement dans un domicile',
      'Uniquement dans un commissariat',
    ],
    answer:
        'Même si les paroles sont prononcées dans un lieu public (si elles sont privées/confidentielles)',
    explanation:
        'Le cours précise que le délit est constitué même en lieu public si les paroles n’ont pas vocation à être rendues publiques.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Mineur (consentement)',
    question:
        'Selon le cours (226-1), dans le cas d’un mineur, le consentement doit émaner :',
    options: [
      'Des titulaires de l’autorité parentale',
      'Du mineur seul',
      'Du professeur principal',
    ],
    answer: 'Des titulaires de l’autorité parentale',
    explanation:
        'Le cours indique que pour un mineur, le consentement relève des titulaires de l’autorité parentale.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Lieu privé (exemples)',
    question:
        'Selon le cours (jurisprudence), peuvent être considérés comme lieu privé :',
    options: [
      'Une chambre d’hôpital, une prison, un commissariat',
      'Uniquement un domicile',
      'Uniquement un parc public',
    ],
    answer: 'Une chambre d’hôpital, une prison, un commissariat',
    explanation:
        'Le cours cite ces exemples comme lieux privés au cas par cas (jurisprudences).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Photographie vitesse',
    question: 'Selon le cours (jurisprudence), ne tombe pas sous 226-1 :',
    options: [
      'La photo prise pour établir la matérialité d’un excès de vitesse',
      'La photo d’une personne dans un lieu privé',
      'La transmission d’une localisation sans consentement',
    ],
    answer: 'La photo prise pour établir la matérialité d’un excès de vitesse',
    explanation:
        'Le cours mentionne l’exception : procédé photo pour matérialité excès de vitesse.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Signalisation anthropométrique',
    question: 'Selon le cours (jurisprudence), ne relève pas de 226-1 :',
    options: [
      'La prise de photos pour la signalisation anthropométrique en enquête judiciaire',
      'La captation de paroles privées sans consentement',
      'La diffusion d’un enregistrement issu d’une atteinte à la vie privée',
    ],
    answer:
        'La prise de photos pour la signalisation anthropométrique en enquête judiciaire',
    explanation:
        'Le cours cite la prise de photos anthropométriques en enquête judiciaire comme non visée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Localisation (mineur)',
    question:
        'Selon le cours, pour la localisation d’un mineur, le consentement :',
    options: [
      'Doit émaner des titulaires de l’autorité parentale',
      'Est présumé si l’enfant est dehors',
      'N’est jamais requis',
    ],
    answer: 'Doit émaner des titulaires de l’autorité parentale',
    explanation:
        'Le cours précise que la localisation d’un mineur nécessite le consentement des titulaires de l’autorité parentale.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Opposition d’un parent',
    question: 'Selon le cours, pour la localisation d’un mineur, il suffit :',
    options: [
      'De l’opposition de l’un des titulaires pour rendre la localisation illicite',
      'De l’opposition des deux parents',
      'D’une opposition écrite du mineur',
    ],
    answer:
        'De l’opposition de l’un des titulaires pour rendre la localisation illicite',
    explanation:
        'Le cours indique qu’une opposition d’un seul titulaire peut rendre la localisation illicite.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — 226-2 (infraction de conséquence)',
    question: 'Selon le cours, l’infraction de 226-2 est :',
    options: [
      'Une infraction de conséquence d’une atteinte à la vie privée (226-1)',
      'Une contravention autonome',
      'Un crime',
    ],
    answer:
        'Une infraction de conséquence d’une atteinte à la vie privée (226-1)',
    explanation:
        'Le cours précise que 226-2 sanctionne le produit d’une atteinte 226-1 (document/enregistrement).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — 226-2 (conservation seule)',
    question:
        'Selon le cours, pour 226-2, le simple fait de conserver le produit de l’atteinte :',
    options: [
      'Est punissable même sans diffusion ni utilisation',
      'N’est jamais punissable sans diffusion',
      'Est punissable seulement si l’auteur gagne de l’argent',
    ],
    answer: 'Est punissable même sans diffusion ni utilisation',
    explanation:
        'Le cours indique que la conservation est réprimée indépendamment de toute divulgation/utilisation.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — 226-2 (utilisation en divorce)',
    question:
        'Selon le cours, l’utilisation en justice (ex : divorce) d’enregistrements illicites :',
    options: [
      'Peut tomber sous 226-2',
      'Est toujours autorisée',
      'Relève uniquement du droit civil',
    ],
    answer: 'Peut tomber sous 226-2',
    explanation:
        'Le cours donne l’exemple : un conjoint utilisant des enregistrements illicites dans une procédure peut relever de 226-2.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Atteinte à la vie privée — 226-2 (laisser porter à la connaissance)',
    question: 'Selon le cours, 226-2 peut viser aussi celui qui :',
    options: [
      'Laisse porter à la connaissance du public alors qu’il pouvait empêcher la diffusion',
      'Ignore totalement l’existence du contenu',
      'Efface immédiatement le contenu',
    ],
    answer:
        'Laisse porter à la connaissance du public alors qu’il pouvait empêcher la diffusion',
    explanation:
        'Le cours indique que celui qui a le pouvoir d’empêcher la diffusion et ne le fait pas peut être considéré auteur.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Presse (hiérarchie)',
    question:
        'Selon le cours, la hiérarchie des responsables en matière de presse renvoie à :',
    options: [
      'Directeurs de publication, puis auteurs, puis imprimeurs, puis vendeurs/distributeurs/afficheurs',
      'Victime, puis témoin, puis avocat',
      'Maire, puis préfet, puis procureur',
    ],
    answer:
        'Directeurs de publication, puis auteurs, puis imprimeurs, puis vendeurs/distributeurs/afficheurs',
    explanation:
        'Le cours rappelle la hiérarchie de l’article 42 de la loi de 1881.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Dénonciation calomnieuse — “Par tout moyen”',
    question: 'Selon le cours (226-10), la dénonciation peut être effectuée :',
    options: [
      'Par tout moyen',
      'Uniquement par écrit',
      'Uniquement par voie judiciaire',
    ],
    answer: 'Par tout moyen',
    explanation:
        'Le cours précise que 226-10 prévoit une dénonciation “par tout moyen” (écrit ou oral).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Destinataire (remise)',
    question:
        'Selon le cours, il n’est pas nécessaire que la dénonciation soit remise en main propre :',
    options: [
      'Il suffit de l’adresser à l’autorité ou de faire en sorte qu’elle lui parvienne',
      'Il faut obligatoirement une remise en main propre',
      'Il faut obligatoirement un recommandé AR',
    ],
    answer:
        'Il suffit de l’adresser à l’autorité ou de faire en sorte qu’elle lui parvienne',
    explanation:
        'Le cours indique qu’il suffit de l’adresser ou de faire en sorte qu’elle parvienne au destinataire.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Dénonciation calomnieuse — Fait “de nature à entraîner sanctions”',
    question:
        'Selon le cours, la dénonciation est “préjudiciable” si le fait dénoncé est :',
    options: [
      'De nature à entraîner des sanctions judiciaires, administratives ou disciplinaires',
      'Simplement vexant sans conséquence',
      'Seulement une opinion',
    ],
    answer:
        'De nature à entraîner des sanctions judiciaires, administratives ou disciplinaires',
    explanation:
        'Le cours reprend le texte : préjudiciable si de nature à entraîner des sanctions judiciaires/administratives/disciplinaires.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Diffamation (différence)',
    question:
        'Selon le cours, la dénonciation calomnieuse se distingue de la diffamation car elle est :',
    options: [
      'En plus, de nature à entraîner des sanctions par une autorité',
      'Toujours publique (contrairement à la diffamation)',
      'Toujours anonyme',
    ],
    answer: 'En plus, de nature à entraîner des sanctions par une autorité',
    explanation:
        'Le cours indique que la dénonciation calomnieuse expose à des sanctions par l’autorité judiciaire/administrative/disciplinaire.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Dénonciation provoquée',
    question:
        'Selon le cours, révéler des faits (même faux) en réponse à une interpellation de l’autorité :',
    options: [
      'Ne caractérise pas la dénonciation calomnieuse faute de spontanéité',
      'Caractérise toujours 226-10',
      'Caractérise automatiquement 226-13',
    ],
    answer:
        'Ne caractérise pas la dénonciation calomnieuse faute de spontanéité',
    explanation:
        'Le cours indique que la jurisprudence exige une initiative personnelle : réponse à interpellation = pas spontané.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Pornodivulgation — Accord à la diffusion (preuve)',
    question: 'Selon le cours, il appartient à l’auteur :',
    options: [
      'De prouver qu’il a reçu l’accord en vue de la diffusion',
      'De prouver que la victime a vu la caméra',
      'De prouver que la vidéo est de qualité',
    ],
    answer: 'De prouver qu’il a reçu l’accord en vue de la diffusion',
    explanation:
        'Le cours précise : l’accord à la captation ne vaut pas accord à la diffusion, et l’auteur doit prouver l’accord de diffusion.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Absence d’opposition',
    question:
        'Selon le cours, même si la victime avait conscience d’être filmée (assentiment présumé), cela ne suffit pas pour :',
    options: [
      'Établir l’accord à la diffusion',
      'Établir le caractère sexuel',
      'Établir la matérialité du document',
    ],
    answer: 'Établir l’accord à la diffusion',
    explanation:
        'Le cours insiste : consentir à être filmé ≠ consentir à la diffusion.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Correspondances électroniques — Intercepter (définition)',
    question: 'Selon le cours, “intercepter” consiste à :',
    options: [
      'Prendre au passage ce qui est destiné à autrui pendant la transmission',
      'Lire un mail déjà ouvert par le destinataire',
      'Répondre à un message reçu',
    ],
    answer:
        'Prendre au passage ce qui est destiné à autrui pendant la transmission',
    explanation:
        'Le cours définit l’interception comme la captation au passage pendant la transmission.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Détourner (définition)',
    question: 'Selon le cours, “détourner” consiste à :',
    options: [
      'Modifier le cours de transmission pour dériver vers un point déterminé',
      'Supprimer un message publicitaire',
      'Envoyer un mail à son adresse',
    ],
    answer:
        'Modifier le cours de transmission pour dériver vers un point déterminé',
    explanation:
        'Le cours décrit le détournement comme la modification du cours de transmission avec dérivation.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Installation d’appareils',
    question: 'Selon le cours (226-15 al.2), est aussi réprimé le fait :',
    options: [
      'De procéder à l’installation d’appareils permettant de telles interceptions',
      'De réparer un téléphone',
      'De changer de mot de passe',
    ],
    answer:
        'De procéder à l’installation d’appareils permettant de telles interceptions',
    explanation:
        'Le cours vise explicitement l’installation de dispositifs permettant interception/détournement/utilisation/divulgation.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Violation de domicile — Voies de fait (exemples)',
    question: 'Selon le cours, une voie de fait peut consister notamment à :',
    options: [
      'Forcer une serrure, briser une vitre, défoncer une porte, escalader un mur',
      'Sonner poliment',
      'Attendre dehors',
    ],
    answer:
        'Forcer une serrure, briser une vitre, défoncer une porte, escalader un mur',
    explanation:
        'Le cours liste de nombreux exemples de violences contre les choses (forçage, bris, escalade…).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Porte non fermée à clé',
    question:
        'Selon le cours, l’introduction illicite n’a pas pu être retenue lorsque :',
    options: [
      'La porte du local violé n’était pas fermée à clé (selon l’exemple du cours)',
      'La porte était blindée',
      'Le domicile est grand',
    ],
    answer:
        'La porte du local violé n’était pas fermée à clé (selon l’exemple du cours)',
    explanation:
        'Le cours mentionne un cas où l’introduction illicite n’a pu être retenue lorsque la porte n’était pas fermée à clé.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Atteinte à la représentation — Mention “montage”',
    question:
        'Selon le cours (226-8), la publication peut être licite sans consentement si :',
    options: [
      'Il est expressément fait mention qu’il s’agit d’un montage',
      'Le montage est drôle',
      'La personne est célèbre',
    ],
    answer: 'Il est expressément fait mention qu’il s’agit d’un montage',
    explanation:
        'Le cours prévoit une exception : mention claire et univoque indiquant qu’il s’agit d’un montage.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Montage évident',
    question:
        'Selon le cours (226-8), la publication peut ne pas nécessiter de consentement si :',
    options: [
      'Il apparaît à l’évidence qu’il s’agit d’un montage (public non dupable)',
      'Le montage est long',
      'Le montage est en HD',
    ],
    answer:
        'Il apparaît à l’évidence qu’il s’agit d’un montage (public non dupable)',
    explanation:
        'Le cours mentionne l’autre exception : montage manifestement apparent.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Atteinte à l’intimité — “Tout moyen”',
    question:
        'Selon le cours, l’atteinte à l’intimité (226-3-1) peut être commise :',
    options: [
      'En usant de tout moyen (ex : miroir, téléphone, petite caméra)',
      'Uniquement avec un appareil photo professionnel',
      'Uniquement avec un drone',
    ],
    answer: 'En usant de tout moyen (ex : miroir, téléphone, petite caméra)',
    explanation:
        'Le cours indique que la loi prévoit “tout moyen” et cite miroir/téléphone/petits appareils.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Secret des correspondances — Supprimer (définition)',
    question:
        'Selon le cours (226-15 al.1), “supprimer” une correspondance est :',
    options: [
      'Tout acte empêchant qu’elle parvienne à destination (y compris conservation)',
      'Uniquement la déchirer',
      'Uniquement la renvoyer',
    ],
    answer:
        'Tout acte empêchant qu’elle parvienne à destination (y compris conservation)',
    explanation:
        'Le cours précise la définition jurisprudentielle : empêcher qu’elle parvienne à destination (destruction, mise au rebut, conservation…).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Retarder (définition)',
    question: 'Selon le cours, “retarder” une correspondance consiste à :',
    options: [
      'Retenir le message en interrompant le cours normal de son acheminement',
      'Lire le courrier et le remettre tout de suite',
      'Répondre au courrier',
    ],
    answer:
        'Retenir le message en interrompant le cours normal de son acheminement',
    explanation:
        'Le cours définit le retard comme le fait de retenir un message et interrompre son acheminement normal.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Secret professionnel — Caractère secret après décès',
    question: 'Selon le cours, le caractère secret de l’information :',
    options: [
      'Ne s’éteint pas avec le décès de la personne',
      'S’éteint automatiquement au décès',
      'S’éteint après 1 an',
    ],
    answer: 'Ne s’éteint pas avec le décès de la personne',
    explanation:
        'Le cours indique que le caractère secret ne s’éteint pas avec le décès.',
    difficulty: 'Moyenne',
  ),

  // (Pour garder le pack à 50 sans exploser la taille, je continue sur des points
  // très proches et toujours issus de ton cours.)
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Complicité',
    question: 'Selon le cours, la complicité de dénonciation calomnieuse est :',
    options: [
      'Punissable (121-6 et 121-7 C.P.)',
      'Non punissable',
      'Punissable uniquement si le dénonciateur est un mineur',
    ],
    answer: 'Punissable (121-6 et 121-7 C.P.)',
    explanation:
        'Le cours précise : COMPLICITÉ : OUI, selon les règles générales (aide/assistance, provocation, instructions).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Aide/assistance',
    question: 'Selon le cours, la complicité suppose notamment :',
    options: [
      'Aide et assistance, provocation, ou instructions données',
      'Simple présence sans acte',
      'Avoir entendu une rumeur',
    ],
    answer: 'Aide et assistance, provocation, ou instructions données',
    explanation:
        'Le cours rappelle les formes de complicité prévues par la loi.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Pornodivulgation — Aucune circonstance aggravante',
    question: 'Selon le cours, la pornodivulgation (226-2-1 al.2) comporte :',
    options: [
      'Aucune circonstance aggravante spécifique',
      'Une aggravation automatique si en ligne',
      'Une aggravation automatique si anonyme',
    ],
    answer: 'Aucune circonstance aggravante spécifique',
    explanation: 'Le cours indique : IV — Circonstances aggravantes : Aucune.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Aucune circonstance aggravante',
    question: 'Selon le cours, la violation de domicile (226-4) comporte :',
    options: [
      'Aucune circonstance aggravante spécifique',
      'Une aggravation automatique si la victime est majeure',
      'Une aggravation automatique si c’est le jour',
    ],
    answer: 'Aucune circonstance aggravante spécifique',
    explanation:
        'Le cours mentionne : IV — Circonstances aggravantes : Aucune.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Aucune circonstance aggravante',
    question:
        'Selon le cours, l’atteinte au secret professionnel (226-13) comporte :',
    options: [
      'Aucune circonstance aggravante spécifique',
      'Une aggravation automatique si l’info est médicale',
      'Une aggravation automatique si l’info est récente',
    ],
    answer: 'Aucune circonstance aggravante spécifique',
    explanation: 'Le cours indique : IV — Circonstances aggravantes : Aucune.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Atteinte à la représentation — Élément moral',
    question: 'Selon le cours, l’élément moral de 226-8 est :',
    options: [
      'La volonté de créer un montage en vue de tromper le public',
      'Une simple négligence',
      'Une intention de nuire obligatoire',
    ],
    answer: 'La volonté de créer un montage en vue de tromper le public',
    explanation:
        'Le cours indique : volonté de créer un montage afin de tromper le public, le résultat escompté importe peu.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Mobile',
    question:
        'Selon le cours, pour 226-8, le résultat escompté (notoriété, profit…) :',
    options: [
      'Importe peu',
      'Est une condition obligatoire',
      'Doit être prouvé par la victime',
    ],
    answer: 'Importe peu',
    explanation:
        'Le cours précise que le résultat escompté importe peu pour l’élément moral.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // PACK 50 QUESTIONS (6/50)
  // =========================================================
  QuizQuestion(
    category: 'Correspondances électroniques — Champ (en transmission)',
    question: 'Selon le cours, 226-15 al.2 protège les correspondances :',
    options: [
      'En cours de transmission ou parvenues mais non encore appréhendées par le destinataire',
      'Uniquement après lecture',
      'Uniquement avant envoi',
    ],
    answer:
        'En cours de transmission ou parvenues mais non encore appréhendées par le destinataire',
    explanation:
        'Le cours précise que le texte vise les correspondances en transmission ou arrivées mais non encore lues.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Mail déjà ouvert',
    question:
        'Selon le cours, lire un mail déjà ouvert par le destinataire ne relève plus de 226-15 al.2 car :',
    options: [
      'Après lecture, ce ne sont plus que des données informatiques',
      'Le mail devient public',
      'Le mail devient un document papier',
    ],
    answer: 'Après lecture, ce ne sont plus que des données informatiques',
    explanation:
        'Le cours indique qu’après lecture, la correspondance perd son caractère spécifique et devient une donnée informatique.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Exemple d’interception (radio)',
    question: 'Selon le cours, constitue une interception le fait de :',
    options: [
      'Capter des échanges radio entre patrouilles de police',
      'Lire un journal',
      'Scanner un QR code public',
    ],
    answer: 'Capter des échanges radio entre patrouilles de police',
    explanation:
        'Le cours cite l’exemple jurisprudentiel : capter des échanges radio entre patrouilles constitue une interception.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Correspondances électroniques — Exemple de détournement (employeur)',
    question: 'Selon le cours, constitue un détournement :',
    options: [
      'L’employeur qui accède aux courriels du salarié non encore consultés',
      'Le salarié qui lit ses propres mails',
      'Le destinataire qui répond',
    ],
    answer:
        'L’employeur qui accède aux courriels du salarié non encore consultés',
    explanation:
        'Le cours cite un exemple jurisprudentiel : accès aux courriels non encore consultés par le salarié = détournement.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Intention de nuire',
    question:
        'Selon le cours, pour 226-15 (électronique), l’intention de nuire :',
    options: [
      'N’est pas exigée (mobile indifférent)',
      'Est obligatoire',
      'Est présumée dès qu’il y a plainte',
    ],
    answer: 'N’est pas exigée (mobile indifférent)',
    explanation:
        'Le cours précise : l’intention de nuire n’est pas exigée, le mobile importe peu.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Peine simple',
    question: 'Selon le cours, la peine principale (226-15 al.2) est :',
    options: [
      '1 an d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 226-15 al.2 (simple) = 1 an + 45 000 €.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Violation de domicile — Box fermé non attenant',
    question:
        'Selon le cours (jurisprudence), peut être assimilé à un domicile :',
    options: [
      'Un box fermé non attenant au domicile',
      'Un hall de centre commercial',
      'Un terrain vague',
    ],
    answer: 'Un box fermé non attenant au domicile',
    explanation:
        'Le cours cite la jurisprudence : un box fermé non attenant peut être assimilé à un domicile.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Garage parking souterrain',
    question:
        'Selon le cours (jurisprudence), peut être assimilé à une annexe au domicile :',
    options: [
      'Un garage dans un parking souterrain',
      'Un parc public',
      'Un local de vente ouvert au public',
    ],
    answer: 'Un garage dans un parking souterrain',
    explanation:
        'Le cours cite la jurisprudence : garage dans parking souterrain considéré comme annexe au domicile.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Logement vide entre deux locations',
    question: 'Selon le cours, n’est pas considéré comme domicile :',
    options: [
      'Le logement vide de meuble entre deux locations',
      'La chambre d’hôtel',
      'La caravane',
    ],
    answer: 'Le logement vide de meuble entre deux locations',
    explanation:
        'Le cours cite les exclusions : logement vide de meubles entre deux locations.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Immeuble en construction',
    question: 'Selon le cours, n’est pas considéré comme domicile :',
    options: [
      'L’immeuble en construction',
      'La maison de vacances meublée',
      'Le yacht habitable',
    ],
    answer: 'L’immeuble en construction',
    explanation:
        'Le cours liste l’immeuble en construction parmi les lieux non considérés comme domiciles.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Local réservé à la vente',
    question: 'Selon le cours, n’est pas considéré comme domicile :',
    options: [
      'Le local réservé à la vente',
      'Le bureau fermé au public',
      'La remise attenante',
    ],
    answer: 'Le local réservé à la vente',
    explanation:
        'Le cours mentionne le local réservé à la vente parmi les exclusions de la notion de domicile.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Véhicule automobile (non domicile)',
    question: 'Selon le cours, n’est pas considéré comme domicile :',
    options: [
      'Le véhicule automobile qui ne se trouve pas au domicile (et non aménagé)',
      'La péniche habitable',
      'La tente',
    ],
    answer:
        'Le véhicule automobile qui ne se trouve pas au domicile (et non aménagé)',
    explanation:
        'Le cours liste le véhicule automobile (non aménagé/lié au domicile) parmi les exclusions.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Secret des correspondances — Objet',
    question: 'Selon le cours (226-15 al.1), une correspondance est :',
    options: [
      'Un message quel qu’en soit le support, ayant vocation à circuler',
      'Uniquement une lettre manuscrite',
      'Uniquement un SMS',
    ],
    answer: 'Un message quel qu’en soit le support, ayant vocation à circuler',
    explanation:
        'Le cours indique que la jurisprudence assimile “correspondance” à “message” quel qu’en soit le support, dès lors qu’il circule.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Destination à un tiers',
    question:
        'Selon le cours, on viole le secret des correspondances quand l’atteinte porte sur un message :',
    options: [
      'Adressé à un tiers (pas à soi-même)',
      'Qu’on a écrit pour soi',
      'Affiché publiquement',
    ],
    answer: 'Adressé à un tiers (pas à soi-même)',
    explanation:
        'Le cours précise : l’auteur doit s’en prendre à un message adressé à autrui.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Acheminement indifférent',
    question:
        'Selon le cours, le mode d’acheminement de la correspondance est :',
    options: [
      'Indifférent (La Poste, coursier, etc.)',
      'Obligatoirement La Poste',
      'Uniquement un coursier',
    ],
    answer: 'Indifférent (La Poste, coursier, etc.)',
    explanation: 'Le cours indique que le mode d’acheminement est indifférent.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Secret professionnel — Révélation à un autre dépositaire',
    question:
        'Selon le cours, l’infraction peut être constituée même si la révélation est faite :',
    options: [
      'À une personne également soumise au secret professionnel',
      'Seulement à une personne non soumise au secret',
      'Seulement au public',
    ],
    answer: 'À une personne également soumise au secret professionnel',
    explanation:
        'Le cours précise que l’infraction peut être retenue même si l’information est révélée à une personne aussi tenue au secret.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Mobile',
    question: 'Selon le cours, pour 226-13, le mobile :',
    options: [
      'Importe peu (pas besoin d’intention de nuire)',
      'Doit être prouvé (vengeance)',
      'Doit être financier',
    ],
    answer: 'Importe peu (pas besoin d’intention de nuire)',
    explanation:
        'Le cours précise : pas besoin d’intention de nuire ; mobile indifférent.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Atteinte à la représentation — Contenu généré (condition)',
    question:
        'Selon le cours, pour le deepfake (226-8), l’infraction est constituée sans consentement si :',
    options: [
      'Il n’apparaît pas à l’évidence qu’il est généré ou si ce n’est pas expressément mentionné',
      'Le deepfake est de mauvaise qualité',
      'Le deepfake est gratuit',
    ],
    answer:
        'Il n’apparaît pas à l’évidence qu’il est généré ou si ce n’est pas expressément mentionné',
    explanation:
        'Le cours reprend la même logique que pour le montage : évidence ou mention claire évitent la tromperie.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Pornodivulgation — Élément moral',
    question: 'Selon le cours, l’élément moral de 226-2-1 al.2 suppose :',
    options: [
      'La conscience de diffuser sans accord un contenu à caractère sexuel',
      'Une intention de nuire obligatoire',
      'Un profit obligatoire',
    ],
    answer:
        'La conscience de diffuser sans accord un contenu à caractère sexuel',
    explanation:
        'Le cours indique : conscience de diffuser sans accord un contenu sexuel.',
    difficulty: 'Moyenne',
  ),
  // =========================================================
  // PACK 50 QUESTIONS (7/50)
  // =========================================================
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Caractère spontané',
    question:
        'Selon le cours, la jurisprudence exige que la dénonciation calomnieuse ait un caractère :',
    options: [
      'Spontané (initiative personnelle du dénonciateur)',
      'Forcément collectif',
      'Forcément anonyme',
    ],
    answer: 'Spontané (initiative personnelle du dénonciateur)',
    explanation:
        'Le cours précise que seule la personne ayant pris l’initiative de révéler les faits inexacts peut être coupable (spontanéité).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Dénonciation provoquée',
    question: 'Selon le cours, une dénonciation “provoquée” (sur demande) :',
    options: [
      'Perd son caractère spontané',
      'Est toujours plus grave',
      'Est automatiquement une tentative',
    ],
    answer: 'Perd son caractère spontané',
    explanation:
        'Le cours indique que les dénonciations provoquées perdent leur spontanéité (rapports demandés, réponses aux questions, etc.).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Rapport demandé par un supérieur',
    question:
        'Selon le cours, un rapport/compte rendu établi sur demande d’un supérieur :',
    options: [
      'N’est pas spontané (donc pas une dénonciation calomnieuse au sens strict)',
      'Constitue toujours 226-10',
      'Constitue une tentative automatique',
    ],
    answer:
        'N’est pas spontané (donc pas une dénonciation calomnieuse au sens strict)',
    explanation:
        'Le cours cite les rapports demandés par un supérieur comme exemple de dénonciation provoquée (perte de spontanéité).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Devoir d’informer',
    question:
        'Selon le cours (Cass. crim., 03 mai 2000), la dénonciation faite par un subordonné qui avait le devoir d’informer :',
    options: [
      'Perd son caractère spontané',
      'Devient automatiquement aggravée',
      'Est forcément une diffamation',
    ],
    answer: 'Perd son caractère spontané',
    explanation:
        'Le cours mentionne que la dénonciation faite par un subordonné ayant le devoir d’informer est provoquée (pas spontanée).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Réponses au magistrat',
    question:
        'Selon le cours (Cass. crim., 16 juin 1988), les dénonciations contenues dans les réponses aux questions d’un magistrat instructeur :',
    options: [
      'Ne sont pas spontanées',
      'Sont toujours punies comme 226-10',
      'Ne peuvent jamais être prouvées',
    ],
    answer: 'Ne sont pas spontanées',
    explanation:
        'Le cours cite les réponses aux questions d’un magistrat instructeur comme dénonciations provoquées.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Défense du prévenu',
    question:
        'Selon le cours (Cass. crim., 03 mai 2000), une dénonciation faite par un prévenu si elle se rattache étroitement à sa défense :',
    options: [
      'Perd son caractère spontané',
      'Devient forcément une violation de domicile',
      'Est toujours une pornodivulgation',
    ],
    answer: 'Perd son caractère spontané',
    explanation:
        'Le cours indique que si la dénonciation est étroitement liée à la défense, elle est provoquée (pas spontanée).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Dénonciation préjudiciable',
    question:
        'Selon le cours, la dénonciation est “préjudiciable” si elle est de nature à entraîner :',
    options: [
      'Des sanctions judiciaires, administratives ou disciplinaires',
      'Une simple gêne sans conséquence',
      'Un simple débat d’opinion',
    ],
    answer: 'Des sanctions judiciaires, administratives ou disciplinaires',
    explanation:
        'Le cours reprend l’exigence de l’article 226-10 : fait de nature à entraîner des sanctions.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Sanction effective',
    question:
        'Selon le cours, pour la dénonciation calomnieuse, il est nécessaire que la sanction soit effectivement prononcée :',
    options: [
      'Non, peu importe qu’il y ait sanction effective',
      'Oui, sinon pas d’infraction',
      'Oui, mais seulement en matière disciplinaire',
    ],
    answer: 'Non, peu importe qu’il y ait sanction effective',
    explanation:
        'Le cours précise que la dénonciation doit être “de nature” à entraîner des sanctions, même sans sanction effective.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Obstacles (prescription/amnistie)',
    question:
        'Selon le cours, l’infraction peut être constituée même si l’éventualité de sanction est écartée par :',
    options: [
      'Prescription, immunité familiale, amnistie ou décès',
      'Un changement de météo',
      'Un conflit de voisinage',
    ],
    answer: 'Prescription, immunité familiale, amnistie ou décès',
    explanation:
        'Le cours indique que ces obstacles n’empêchent pas la caractérisation si le fait est de nature à entraîner sanction.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Inexactitude totale ou partielle',
    question:
        'Selon le cours, la dénonciation calomnieuse vise un fait que l’on sait :',
    options: [
      'Totalement ou partiellement inexact',
      'Toujours totalement vrai',
      'Toujours une opinion',
    ],
    answer: 'Totalement ou partiellement inexact',
    explanation:
        'Le texte du cours mentionne l’inexactitude totale ou partielle connue de l’auteur.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Violation de domicile — Moyens (liste)',
    question:
        'Selon le cours (226-4), l’introduction illégitime doit être réalisée à l’aide de :',
    options: [
      'Manœuvres, menaces, voies de fait ou contrainte',
      'Uniquement une clé',
      'Uniquement la ruse',
    ],
    answer: 'Manœuvres, menaces, voies de fait ou contrainte',
    explanation:
        'Le cours énumère les moyens : manœuvres/menaces/voies de fait/contrainte.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Manœuvres (définition)',
    question: 'Selon le cours, les “manœuvres” sont :',
    options: [
      'Tout procédé astucieux ou ruse pour favoriser l’introduction illicite',
      'Uniquement une violence physique',
      'Uniquement une menace écrite',
    ],
    answer:
        'Tout procédé astucieux ou ruse pour favoriser l’introduction illicite',
    explanation: 'Le cours définit les manœuvres comme ruse/procédé astucieux.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Menaces (définition)',
    question: 'Selon le cours, les “menaces” peuvent être caractérisées par :',
    options: [
      'Des comportements inquiétants ou des paroles d’une personne prête à la violence',
      'Un sourire',
      'Un silence total',
    ],
    answer:
        'Des comportements inquiétants ou des paroles d’une personne prête à la violence',
    explanation:
        'Le cours précise que menaces = comportements inquiétants/paroles annonçant violence.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Contrainte (définition)',
    question: 'Selon le cours, la “contrainte” correspond à :',
    options: [
      'Toute situation où le consentement de l’occupant n’est pas libre',
      'Une simple gêne sonore',
      'Une invitation écrite',
    ],
    answer: 'Toute situation où le consentement de l’occupant n’est pas libre',
    explanation:
        'Le cours définit la contrainte comme absence de consentement libre.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Occupant présent ou non',
    question:
        'Selon le cours, les moyens d’introduction illicite montrent que l’entrée est non désirée, que l’occupant légitime soit :',
    options: ['Présent ou non', 'Forcément présent', 'Forcément absent'],
    answer: 'Présent ou non',
    explanation:
        'Le cours précise que l’entrée est non désirée même si l’occupant n’est pas présent.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Personne initialement invitée',
    question: 'Selon le cours, la violation de domicile ne concerne pas :',
    options: [
      'Une personne initialement invitée à entrer ou séjourner',
      'Une personne entrant par ruse',
      'Une personne entrant par menace',
    ],
    answer: 'Une personne initialement invitée à entrer ou séjourner',
    explanation:
        'Le cours indique que ce n’est pas une personne initialement invitée : l’entrée est “non désirée”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Maintien après entrée par un tiers',
    question:
        'Selon le cours, peuvent être poursuivies des personnes venues ensuite se maintenir dans le domicile si :',
    options: [
      'Elles ont profité d’une entrée illicite commise par un tiers en connaissance de cause',
      'Elles ignorent tout',
      'Elles sont passées devant le domicile',
    ],
    answer:
        'Elles ont profité d’une entrée illicite commise par un tiers en connaissance de cause',
    explanation:
        'Le cours précise qu’un maintien en connaissance de cause après une entrée illicite par un tiers peut être poursuivi.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Enquête de flagrance',
    question:
        'Selon le cours, en raison du caractère continu, on peut agir en flagrance :',
    options: [
      'Tant que perdure l’occupation illicite',
      'Uniquement dans les 24h',
      'Uniquement si la serrure est cassée',
    ],
    answer: 'Tant que perdure l’occupation illicite',
    explanation:
        'Le cours rappelle l’infraction continue : flagrance tant que l’occupation continue.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Voies de fait (toiture)',
    question: 'Selon le cours, une voie de fait peut être caractérisée par :',
    options: [
      'Enlever une partie de la toiture ou défoncer la porte d’entrée',
      'Écrire une lettre',
      'Attendre dans la rue',
    ],
    answer: 'Enlever une partie de la toiture ou défoncer la porte d’entrée',
    explanation: 'Le cours donne ces exemples de violence contre les biens.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Atteinte à la représentation — Public ou tiers',
    question:
        'Selon le cours (226-8), l’infraction suppose de porter le montage à la connaissance :',
    options: [
      'Du public ou d’un tiers',
      'Uniquement de la victime',
      'Uniquement du procureur',
    ],
    answer: 'Du public ou d’un tiers',
    explanation:
        'Le cours indique : porter à la connaissance du public ou d’un tiers.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Repartage',
    question:
        'Selon le cours, le dispositif 226-8 permet aussi de sanctionner :',
    options: [
      'Les personnes repartageant le contenu',
      'Uniquement le créateur du montage',
      'Uniquement la victime',
    ],
    answer: 'Les personnes repartageant le contenu',
    explanation:
        'Le cours précise que sont englobés les moyens de révéler le montage et que cela peut sanctionner le repartage.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Contenu IA (définition générale)',
    question: 'Selon le cours, l’hypertrucage (deepfake) repose sur :',
    options: [
      'Une technique de synthèse multimédia reposant sur l’intelligence artificielle',
      'Une simple photo argentique',
      'Un papier carbone',
    ],
    answer:
        'Une technique de synthèse multimédia reposant sur l’intelligence artificielle',
    explanation:
        'Le cours décrit le deepfake comme une technique IA de synthèse multimédia.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Exemples deepfake',
    question: 'Selon le cours, le deepfake peut notamment servir à :',
    options: [
      'Changer un visage sur une vidéo ou substituer des propos en reproduisant une voix',
      'Remplacer une ampoule',
      'Retoucher une facture',
    ],
    answer:
        'Changer un visage sur une vidéo ou substituer des propos en reproduisant une voix',
    explanation:
        'Le cours donne ces exemples : changement de visage ou substitution de propos/voix.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Consentement requis',
    question: 'Selon le cours (226-8), le consentement requis porte sur :',
    options: [
      'La publication/révélation du contenu (pas seulement la création)',
      'Uniquement la prise de vue',
      'Uniquement l’achat du logiciel',
    ],
    answer: 'La publication/révélation du contenu (pas seulement la création)',
    explanation:
        'Le cours précise que le consentement visé concerne la publication/révélation à un tiers.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Pornodivulgation — Obtention avec consentement',
    question:
        'Selon le cours, la pornodivulgation (226-2-1 al.2) suppose un contenu :',
    options: [
      'Préalablement obtenu avec le consentement ou fourni par la victime',
      'Toujours volé sans consentement',
      'Toujours enregistré dans un commissariat',
    ],
    answer:
        'Préalablement obtenu avec le consentement ou fourni par la victime',
    explanation:
        'Le cours indique que le contenu a été obtenu avec consentement ou fourni par la personne concernée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Accord absent',
    question: 'Selon le cours, la diffusion est “sans accord” si :',
    options: [
      'La victime s’y oppose ou n’a pas été consultée (donc n’a pas pu s’opposer)',
      'La victime a signé un accord',
      'La victime l’a publié elle-même',
    ],
    answer:
        'La victime s’y oppose ou n’a pas été consultée (donc n’a pas pu s’opposer)',
    explanation:
        'Le cours décrit l’absence d’accord : opposition ou impossibilité de s’opposer faute d’avoir été consultée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Caractère sexuel (appréciation)',
    question:
        'Selon le cours, l’appréciation du caractère sexuel des paroles/images revient :',
    options: [
      'Aux juridictions compétentes (appréciation au cas par cas)',
      'Au voisinage',
      'Uniquement à la victime',
    ],
    answer: 'Aux juridictions compétentes (appréciation au cas par cas)',
    explanation:
        'Le cours (référence Conseil constitutionnel) souligne que l’appréciation du caractère sexuel relève des juridictions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Qualification',
    question: 'Selon le cours, la pornodivulgation (226-2-1 al.2) est un :',
    options: ['Délit', 'Crime', 'Contravention'],
    answer: 'Délit',
    explanation: 'Le tableau de répression indique : CLASSIFICATION = DÉLIT.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Correspondances électroniques — Actes matériels',
    question:
        'Selon le cours (226-15 al.2), l’acte matériel peut consister à :',
    options: [
      'Intercepter, détourner, utiliser ou divulguer',
      'Écrire un mail',
      'Changer de téléphone',
    ],
    answer: 'Intercepter, détourner, utiliser ou divulguer',
    explanation:
        'Le cours énumère les actes matériels : intercepter/détourner/utiliser/divulguer.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Intercepter sans lire',
    question:
        'Selon le cours, pour l’interception, il est nécessaire que l’auteur prenne connaissance du contenu :',
    options: [
      'Non, ce n’est pas nécessaire',
      'Oui, toujours',
      'Oui, seulement si c’est une vidéo',
    ],
    answer: 'Non, ce n’est pas nécessaire',
    explanation:
        'Le cours précise que l’auteur peut intercepter sans forcément prendre connaissance du contenu.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Utiliser (exemple effacer)',
    question:
        'Selon le cours, “utiliser” une correspondance électronique peut viser :',
    options: [
      'Effacer un mail dont on n’est pas destinataire (même sans l’ouvrir)',
      'Lire ses propres messages',
      'Archiver son courrier',
    ],
    answer:
        'Effacer un mail dont on n’est pas destinataire (même sans l’ouvrir)',
    explanation:
        'Le cours donne l’exemple : effacer un mail non destiné, sans l’ouvrir, peut caractériser “utiliser”.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Correspondances électroniques — Divulguer (téléphone enregistré)',
    question: 'Selon le cours, commet une divulgation celui qui :',
    options: [
      'Fait écouter à un tiers le contenu d’une conversation enregistrée',
      'Raccroche',
      'Rappelle un numéro inconnu',
    ],
    answer: 'Fait écouter à un tiers le contenu d’une conversation enregistrée',
    explanation:
        'Le cours donne cet exemple : faire écouter à un tiers une conversation enregistrée = divulgation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Installation pour un tiers',
    question:
        'Selon le cours, celui qui installe un dispositif d’interception pour le compte d’un tiers est :',
    options: [
      'Considéré comme auteur, même s’il agit pour un tiers',
      'Toujours irresponsable',
      'Seulement complice, jamais auteur',
    ],
    answer: 'Considéré comme auteur, même s’il agit pour un tiers',
    explanation:
        'Le cours précise qu’en l’absence de précision, l’installateur est considéré auteur même s’il agit pour un tiers.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Secret des correspondances — “Arrivées ou non à destination”',
    question:
        'Selon le cours (226-15 al.1), l’atteinte peut viser des correspondances :',
    options: [
      'Arrivées ou non à destination',
      'Uniquement arrivées à destination',
      'Uniquement non envoyées',
    ],
    answer: 'Arrivées ou non à destination',
    explanation:
        'Le cours rappelle l’expression légale : “arrivées ou non à destination”.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Ouverture (vapeur)',
    question:
        'Selon le cours, l’ouverture d’une correspondance peut être réalisée :',
    options: [
      'De façon subtile (ex : décacheter à la vapeur)',
      'Uniquement en déchirant',
      'Uniquement par ciseaux',
    ],
    answer: 'De façon subtile (ex : décacheter à la vapeur)',
    explanation:
        'Le cours indique que l’ouverture peut être violente ou subtile (décachetage à la vapeur).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Renvoi après ouverture',
    question:
        'Selon le cours, peu importe que la correspondance soit ensuite renvoyée au destinataire :',
    options: [
      'Oui, l’infraction peut être constituée malgré le renvoi',
      'Non, le renvoi annule l’infraction',
      'Oui, mais seulement si le courrier est recommandé',
    ],
    answer: 'Oui, l’infraction peut être constituée malgré le renvoi',
    explanation:
        'Le cours précise que l’infraction peut être constituée même si la correspondance est renvoyée vers le destinataire.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Atteinte à la vie privée — Lieu privé (définition)',
    question: 'Selon le cours, un lieu privé est :',
    options: [
      'Un endroit non ouvert à tous sauf autorisation de l’occupant permanent ou temporaire',
      'Un lieu avec beaucoup de monde',
      'Un lieu toujours public',
    ],
    answer:
        'Un endroit non ouvert à tous sauf autorisation de l’occupant permanent ou temporaire',
    explanation:
        'Le cours cite la définition jurisprudentielle : lieu privé = non ouvert à tous sauf autorisation de l’occupant.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Véhicule et lieu privé',
    question:
        'Selon le cours (Cass. crim., 28 mars 2023), filmer un conducteur au volant lors d’un contrôle routier, au vu et au su :',
    options: [
      'Peut ne pas caractériser 226-1 si l’opposition n’est pas établie',
      'Caractérise automatiquement 226-1',
      'Constitue automatiquement 226-8',
    ],
    answer: 'Peut ne pas caractériser 226-1 si l’opposition n’est pas établie',
    explanation:
        'Le cours rappelle cette jurisprudence : acte au vu et au su → il faut rechercher l’opposition, la preuve ne pèse pas sur le prévenu.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Localisation (clandestine)',
    question:
        'Selon le cours, la présomption “au vu et au su” ne s’applique pas à la localisation car :',
    options: [
      'La localisation est très facilement clandestine (logiciel espion, balise)',
      'La localisation est toujours publique',
      'La localisation est toujours sonore',
    ],
    answer:
        'La localisation est très facilement clandestine (logiciel espion, balise)',
    explanation:
        'Le cours précise que la localisation étant souvent clandestine, pas de présomption au vu/au su.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Secret professionnel — Dépositaire (exemples)',
    question:
        'Selon le cours, parmi les exemples de professions souvent tenues au secret, on trouve :',
    options: [
      'Médecin, policier, magistrat, avocat (exemples cités)',
      'Photographe de mariage',
      'Livreur de pizza',
    ],
    answer: 'Médecin, policier, magistrat, avocat (exemples cités)',
    explanation:
        'Le cours cite de nombreux exemples de personnes tenues au secret professionnel (médecins, policiers, magistrats, avocats…).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Détermination par les juges',
    question:
        'Selon le cours, en l’absence de texte, la question de savoir si une personne est tenue au secret est déterminée :',
    options: [
      'Au cas par cas par les juges',
      'Uniquement par la victime',
      'Uniquement par un syndicat',
    ],
    answer: 'Au cas par cas par les juges',
    explanation:
        'Le cours indique qu’en l’absence de texte, les juges déterminent au cas par cas l’obligation de secret.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Révélation (document)',
    question: 'Selon le cours, la révélation peut consister :',
    options: [
      'Dans la transmission à autrui d’un document couvert par le secret',
      'Uniquement dans une conversation',
      'Uniquement sur internet',
    ],
    answer: 'Dans la transmission à autrui d’un document couvert par le secret',
    explanation:
        'Le cours précise que la révélation peut être verbale ou par transmission d’un document.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category:
        'Atteinte à l’intimité — Circonstance aggravante (transport collectif)',
    question:
        'Selon le cours (226-3-1), il y a circonstance aggravante lorsque les faits sont commis :',
    options: [
      'Dans un véhicule de transport collectif ou un lieu d’accès à ce transport',
      'Dans une bibliothèque silencieuse',
      'Dans un jardin privé avec accord',
    ],
    answer:
        'Dans un véhicule de transport collectif ou un lieu d’accès à ce transport',
    explanation:
        'Le cours liste le transport collectif et les lieux d’accès comme circonstance aggravante.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité — Circonstance aggravante (images fixées)',
    question: 'Selon le cours (226-3-1), il y a circonstance aggravante si :',
    options: [
      'Des images ont été fixées, enregistrées ou transmises',
      'La victime parle fort',
      'La victime porte un manteau',
    ],
    answer: 'Des images ont été fixées, enregistrées ou transmises',
    explanation:
        'Le cours mentionne l’aggravation lorsque des images ont été fixées/enregistrées/transmises.',
    difficulty: 'Moyenne',
  ),
  // =========================================================
  // PACK 50 QUESTIONS (8/50)
  // =========================================================
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Fondement',
    question: 'La dénonciation calomnieuse est définie et réprimée par :',
    options: [
      'L’article 226-10 du Code pénal',
      'L’article 226-13 du Code pénal',
      'L’article 226-4 du Code pénal',
    ],
    answer: 'L’article 226-10 du Code pénal',
    explanation:
        'Le cours précise : l’article 226-10 C.P. définit et réprime la dénonciation calomnieuse.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Forme écrite',
    question:
        'Selon le cours, une dénonciation écrite peut notamment prendre la forme :',
    options: [
      'D’une lettre, d’une pétition, ou d’une plainte (avec ou sans constitution de partie civile)',
      'D’un simple regard',
      'D’un silence',
    ],
    answer:
        'D’une lettre, d’une pétition, ou d’une plainte (avec ou sans constitution de partie civile)',
    explanation:
        'Le cours cite ces exemples de dénonciations écrites (lettre, pétition, plainte…).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Forme orale',
    question: 'Selon le cours, une dénonciation orale peut être faite :',
    options: [
      'De vive voix ou par téléphone (mais doit pouvoir être prouvée)',
      'Uniquement par écrit',
      'Uniquement par fax',
    ],
    answer: 'De vive voix ou par téléphone (mais doit pouvoir être prouvée)',
    explanation:
        'Le cours indique : dénonciation orale possible (vive voix/téléphone) et doit pouvoir être prouvée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Auteur matériel vs personnel',
    question:
        'Selon le cours, l’exécutant agissant sur instructions hiérarchiques ne peut être poursuivi que :',
    options: [
      'S’il y a pris part personnellement (au-delà d’un rôle purement matériel)',
      'Même s’il n’a fait qu’obéir sans participation',
      'Uniquement si la lettre est anonyme',
    ],
    answer:
        'S’il y a pris part personnellement (au-delà d’un rôle purement matériel)',
    explanation:
        'Le cours distingue la participation personnelle de celui qui n’a qu’un rôle matériel.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Personne déterminée',
    question: 'Selon le cours, la dénonciation doit viser :',
    options: [
      'Une personne déterminée, identifiable (physique ou morale)',
      'Une foule indéterminée',
      'Un concept abstrait',
    ],
    answer: 'Une personne déterminée, identifiable (physique ou morale)',
    explanation:
        'Le cours précise la nécessité d’une personne déterminée et identifiable.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Consommation (date)',
    question: 'Selon le cours, l’infraction est consommée :',
    options: [
      'Au jour de réception par l’autorité destinataire',
      'Au jour d’écriture de la lettre',
      'Au jour où la victime l’apprend',
    ],
    answer: 'Au jour de réception par l’autorité destinataire',
    explanation:
        'Le cours indique que la jurisprudence fixe la consommation au jour de réception (point de départ de la prescription).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Destinataires',
    question:
        'Selon le cours, les destinataires visés par 226-10 peuvent inclure :',
    options: [
      'Officiers de justice, autorités pouvant donner suite/saisir, supérieurs hiérarchiques/employeur',
      'N’importe quel ami',
      'Uniquement la presse',
    ],
    answer:
        'Officiers de justice, autorités pouvant donner suite/saisir, supérieurs hiérarchiques/employeur',
    explanation:
        'Le cours énumère les destinataires : magistrats, autorités aptes, supérieurs/employeur, etc.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Notion de “préjudiciable”',
    question:
        'Selon le cours, “préjudiciable” signifie que le fait dénoncé est de nature à entraîner :',
    options: [
      'Des sanctions judiciaires, administratives ou disciplinaires',
      'Une simple gêne morale',
      'Une émotion passagère',
    ],
    answer: 'Des sanctions judiciaires, administratives ou disciplinaires',
    explanation:
        'Le cours reprend la condition légale : fait de nature à entraîner sanctions.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Fausseté (décisions automatiques)',
    question:
        'Selon le cours, la fausseté résulte nécessairement d’une décision définitive :',
    options: [
      'D’acquittement, de relaxe ou de non-lieu déclarant que le fait n’a pas été commis ou n’est pas imputable',
      'De simple classement sans suite',
      'D’une main courante',
    ],
    answer:
        'D’acquittement, de relaxe ou de non-lieu déclarant que le fait n’a pas été commis ou n’est pas imputable',
    explanation:
        'Le cours indique que seules certaines décisions définitives constatant expressément l’absence de fait/imputabilité établissent automatiquement la fausseté.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — “Faute de charges suffisantes”',
    question:
        'Selon le cours, si la décision définitive est rendue faute de charges suffisantes :',
    options: [
      'Le tribunal apprécie la pertinence des accusations',
      'La fausseté est automatiquement établie',
      'Il n’y a jamais d’infraction possible',
    ],
    answer: 'Le tribunal apprécie la pertinence des accusations',
    explanation:
        'Le cours précise que dans les autres cas (ex : faute de charges suffisantes), le tribunal apprécie la pertinence.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Élément moral',
    question:
        'Selon le cours, l’auteur doit connaître l’inexactitude des faits :',
    options: [
      'Au moment où il les dénonce',
      'Un mois après la dénonciation',
      'Uniquement lors du procès',
    ],
    answer: 'Au moment où il les dénonce',
    explanation:
        'Le cours insiste : la connaissance de l’inexactitude doit exister au jour de la dénonciation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Erreur découverte après coup',
    question: 'Selon le cours, si l’auteur découvre son erreur après coup :',
    options: [
      'L’infraction n’est pas constituée (mais une autre incrimination peut exister)',
      'L’infraction 226-10 est automatiquement constituée',
      'La victime est automatiquement indemnisée',
    ],
    answer:
        'L’infraction n’est pas constituée (mais une autre incrimination peut exister)',
    explanation:
        'Le cours précise : pas de 226-10 si erreur découverte après coup, mais possible poursuite pour omission de témoigner en faveur d’un innocent (434-11).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Omission de témoigner',
    question:
        'Selon le cours, si l’auteur découvre son erreur après coup, il peut être poursuivi pour :',
    options: [
      'Omission de témoigner en faveur d’un innocent (434-11 C.P.)',
      'Violation de domicile (226-4 C.P.)',
      'Harcèlement sexuel (222-33 C.P.)',
    ],
    answer: 'Omission de témoigner en faveur d’un innocent (434-11 C.P.)',
    explanation:
        'Le cours cite explicitement l’article 434-11 (omission de témoigner en faveur d’un innocent).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Circonstances aggravantes',
    question: 'Selon le cours, la dénonciation calomnieuse comporte :',
    options: [
      'Aucune circonstance aggravante spécifique',
      'Une aggravation automatique si écrite',
      'Une aggravation automatique si anonyme',
    ],
    answer: 'Aucune circonstance aggravante spécifique',
    explanation: 'Le cours indique : IV — Circonstances aggravantes : Aucune.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Peine',
    question:
        'Selon le cours, la peine principale (personne physique) de 226-10 est :',
    options: [
      '5 ans d’emprisonnement et 45 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le tableau de répression du cours indique : 226-10 = 5 ans + 45 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Tentative',
    question: 'Selon le cours, la tentative de dénonciation calomnieuse est :',
    options: [
      'Non punissable',
      'Punissable (226-5)',
      'Punissable uniquement en cas d’anonymat',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours indique : TENTATIVE : NON.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Violation de domicile — Fondement',
    question:
        'La violation de domicile commise par un particulier est prévue par :',
    options: [
      'L’article 226-4 du Code pénal',
      'L’article 226-8 du Code pénal',
      'L’article 226-10 du Code pénal',
    ],
    answer: 'L’article 226-4 du Code pénal',
    explanation:
        'Le cours précise : 226-4 définit et réprime la violation de domicile commise par un particulier.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Maintien',
    question: 'Selon le cours, constitue aussi l’infraction :',
    options: [
      'Le maintien dans le domicile à l’issue d’une introduction illégitime',
      'Le départ immédiat après demande',
      'Le passage devant la porte',
    ],
    answer:
        'Le maintien dans le domicile à l’issue d’une introduction illégitime',
    explanation:
        'Le cours indique que le maintien après l’introduction illégitime est également incriminé.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — “Hors les cas où la loi le permet”',
    question: 'Selon le cours, la violation de domicile est punissable :',
    options: [
      'Hors les cas où la loi permet l’introduction',
      'Même quand la loi autorise l’entrée',
      'Uniquement la nuit',
    ],
    answer: 'Hors les cas où la loi permet l’introduction',
    explanation:
        'Le cours rappelle la réserve légale : l’infraction est “hors les cas où la loi le permet”.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Violation de domicile — Introduction légitime (appel au secours)',
    question: 'Selon le cours, une introduction peut être légitime en cas de :',
    options: [
      'Réclamation faite de l’intérieur (cris/hurlements), même si l’appel est fantaisiste',
      'Simple curiosité',
      'Désir de visiter',
    ],
    answer:
        'Réclamation faite de l’intérieur (cris/hurlements), même si l’appel est fantaisiste',
    explanation:
        'Le cours indique que l’appel au secours justifie l’introduction, même si l’appel est fantaisiste.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Violation de domicile — Introduction légitime (incendie/inondation)',
    question: 'Selon le cours, l’introduction est justifiée si la maison est :',
    options: [
      'Atteinte ou menacée par un incendie ou une inondation',
      'En bon état',
      'En vente',
    ],
    answer: 'Atteinte ou menacée par un incendie ou une inondation',
    explanation:
        'Le cours mentionne explicitement l’incendie/inondation comme cas d’introduction légitime.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Violation de domicile — Introduction légitime (assistance personne en péril)',
    question:
        'Selon le cours, l’introduction est justifiée lorsqu’il existe des indices incitant à croire :',
    options: [
      'Qu’une personne est gravement en péril dans un domicile',
      'Qu’un voisin cuisine fort',
      'Qu’un colis est attendu',
    ],
    answer: 'Qu’une personne est gravement en péril dans un domicile',
    explanation:
        'Le cours cite l’assistance à personne en péril (indices : appel sans réponse, odeur suspecte, absence anormale…).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Logement vacant non meublé',
    question:
        'Selon le cours, les logements vacants non meublés ne sont pas des domiciles au sens de 226-4, et l’occupation frauduleuse relève de :',
    options: [
      '315-1 et 315-2 du Code pénal',
      '226-10 du Code pénal',
      '226-13 du Code pénal',
    ],
    answer: '315-1 et 315-2 du Code pénal',
    explanation:
        'Le cours précise que l’occupation frauduleuse de tels locaux est prévue et réprimée aux articles 315-1 et 315-2.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Élément moral',
    question: 'Selon le cours, l’élément moral implique :',
    options: [
      'Volonté de s’introduire ou se maintenir au domicile d’autrui à son insu/contre son gré + conscience d’agir hors cas prévus par la loi',
      'Simple oubli',
      'Intention de nuire obligatoire',
    ],
    answer:
        'Volonté de s’introduire ou se maintenir au domicile d’autrui à son insu/contre son gré + conscience d’agir hors cas prévus par la loi',
    explanation:
        'Le cours mentionne la volonté d’entrer/se maintenir à l’insu/contre gré et la conscience d’être hors cas légaux.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Peine',
    question: 'Selon le cours, la violation de domicile (226-4) est punie de :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le tableau du cours indique : 226-4 = 3 ans + 45 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Tentative',
    question:
        'Selon le cours, la tentative de violation de domicile (226-4) est :',
    options: [
      'Punissable (prévue par 226-5)',
      'Non punissable',
      'Punissable uniquement si violence',
    ],
    answer: 'Punissable (prévue par 226-5)',
    explanation: 'Le cours mentionne : tentative prévue à l’article 226-5.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Propagande/ publicité “squat” — Fondement',
    question:
        'Le fait de faire la propagande ou publicité en faveur de méthodes incitant à la violation de domicile est incriminé par :',
    options: [
      'L’article 226-4-2-1 du Code pénal',
      'L’article 226-4 du Code pénal',
      'L’article 226-2-1 du Code pénal',
    ],
    answer: 'L’article 226-4-2-1 du Code pénal',
    explanation:
        'Le cours précise : 226-4-2-1 incrimine la propagande/publicité en faveur de méthodes visant à faciliter ou inciter à la violation de domicile.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Propagande/ publicité “squat” — Objet',
    question: 'Selon le cours, 226-4-2-1 vise notamment les contenus de type :',
    options: [
      '“Modes d’emploi du squat” (conseils pour forcer serrure, s’installer, pérenniser)',
      'Recettes de cuisine',
      'Tutoriels de sport',
    ],
    answer:
        '“Modes d’emploi du squat” (conseils pour forcer serrure, s’installer, pérenniser)',
    explanation:
        'Le cours cite explicitement les vidéos “mode d’emploi du squat”.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Propagande/ publicité “squat” — Peine',
    question:
        'Selon le cours, la commission du délit 226-4-2-1 est sanctionnée par :',
    options: [
      'Une amende de 3 750 €',
      'Une amende de 15 000 €',
      '5 ans d’emprisonnement',
    ],
    answer: 'Une amende de 3 750 €',
    explanation:
        'Le cours indique : ce délit est sanctionné d’une amende de 3 750 euros.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Secret des correspondances — Aggravation (conjoint/PACS)',
    question:
        'Selon le cours, l’atteinte au secret des correspondances (226-15) est aggravée lorsque les faits sont commis par :',
    options: [
      'Le conjoint, le concubin ou le partenaire de PACS',
      'Un inconnu dans la rue',
      'Un collègue de sport',
    ],
    answer: 'Le conjoint, le concubin ou le partenaire de PACS',
    explanation:
        'Le cours mentionne l’alinéa 3 : aggravation si conjoint/concubin/partenaire de PACS.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Électronique (fondement)',
    question:
        'La violation des correspondances émises par la voie électronique est prévue par :',
    options: [
      'L’article 226-15 alinéa 2 du Code pénal',
      'L’article 226-15 alinéa 1 du Code pénal',
      'L’article 226-13 du Code pénal',
    ],
    answer: 'L’article 226-15 alinéa 2 du Code pénal',
    explanation:
        'Le cours précise que 226-15 al.2 définit la violation des correspondances émises par voie électronique.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Électronique (mauvaise foi)',
    question: 'Selon le cours, la “mauvaise foi” (226-15) correspond à :',
    options: [
      'La connaissance que les correspondances ne lui étaient pas destinées',
      'Le fait d’être énervé',
      'Le fait d’être pressé',
    ],
    answer:
        'La connaissance que les correspondances ne lui étaient pas destinées',
    explanation:
        'Le cours cite la Cour de cassation : mauvaise foi = connaissance que les lettres ne lui étaient pas destinées.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Électronique (tentative)',
    question:
        'Selon le cours, la tentative pour la violation des correspondances électroniques (226-15 al.2) est :',
    options: ['Non punissable', 'Punissable (226-5)', 'Toujours aggravée'],
    answer: 'Non punissable',
    explanation: 'Le cours indique : TENTATIVE : NON pour 226-15.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Atteinte à la représentation — Aggravation (en ligne)',
    question:
        'Selon le cours, l’atteinte à la représentation (226-8) est aggravée lorsque les faits sont commis :',
    options: [
      'En utilisant un service de communication au public en ligne',
      'Par courrier recommandé',
      'Dans un musée',
    ],
    answer: 'En utilisant un service de communication au public en ligne',
    explanation:
        'Le cours cite l’article 226-8 al.2 : aggravation si usage d’un service de communication au public en ligne.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Peine simple',
    question:
        'Selon le cours, la peine principale (simple) de 226-8 al.1 est :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '2 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation: 'Le tableau du cours indique : 226-8 al.1 = 1 an + 15 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Peine aggravée',
    question:
        'Selon le cours, la peine principale (aggravée) de 226-8 al.2 est :',
    options: [
      '2 ans d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le tableau du cours indique : aggravé (226-8 al.2) = 2 ans + 45 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Tentative',
    question:
        'Selon le cours, la tentative de l’atteinte à la représentation (226-8) est :',
    options: [
      'Punissable (226-5)',
      'Non punissable',
      'Punissable uniquement si victime mineure',
    ],
    answer: 'Punissable (226-5)',
    explanation:
        'Le cours précise : TENTATIVE : OUI (prévue à 226-5) pour les délits dont 226-8.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Pornodivulgation — Fondement',
    question:
        'La diffusion sans accord d’un enregistrement à caractère sexuel obtenu avec consentement est prévue par :',
    options: [
      'L’article 226-2-1 alinéa 2 du Code pénal',
      'L’article 226-1 du Code pénal',
      'L’article 226-15 du Code pénal',
    ],
    answer: 'L’article 226-2-1 alinéa 2 du Code pénal',
    explanation:
        'Le cours indique : 226-2-1 al.2 définit et réprime la pornodivulgation (diffusion sans accord).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Peine',
    question:
        'Selon le cours, la pornodivulgation (226-2-1 al.2) est punie de :',
    options: [
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '1 an d’emprisonnement et 45 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 60 000 € d’amende',
    explanation:
        'Le tableau du cours mentionne : 226-2-1 al.2 = 2 ans + 60 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Tentative',
    question:
        'Selon le cours, la tentative de pornodivulgation (226-2-1) est :',
    options: [
      'Punissable (prévue par 226-5)',
      'Non punissable',
      'Punissable uniquement en cas de chantage',
    ],
    answer: 'Punissable (prévue par 226-5)',
    explanation:
        'Le cours indique : la tentative du délit prévu à 226-2-1 est prévue par 226-5.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Atteinte à la vie privée — Fondement',
    question:
        'Les atteintes à l’intimité de la vie privée sont définies et réprimées par :',
    options: [
      'L’article 226-1 du Code pénal',
      'L’article 226-8 du Code pénal',
      'L’article 226-10 du Code pénal',
    ],
    answer: 'L’article 226-1 du Code pénal',
    explanation:
        'Le cours précise : 226-1 définit et réprime les atteintes à l’intimité de la vie privée.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — 226-2 (fondement)',
    question:
        'La conservation, diffusion ou utilisation d’un document issu d’une atteinte à la vie privée est prévue par :',
    options: [
      'L’article 226-2 du Code pénal',
      'L’article 226-3-1 du Code pénal',
      'L’article 226-4-2-1 du Code pénal',
    ],
    answer: 'L’article 226-2 du Code pénal',
    explanation:
        'Le cours indique : 226-2 définit et réprime la conservation/diffusion/utilisation du produit d’une atteinte 226-1.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Atteinte à la vie privée — Localisation (inclut différé)',
    question:
        'Selon le cours, l’atteinte à la vie privée peut aussi consister en :',
    options: [
      'Captation/enregistrement/transmission de la localisation en temps réel ou en différé sans consentement',
      'Le fait de demander son chemin',
      'Le fait de regarder un plan',
    ],
    answer:
        'Captation/enregistrement/transmission de la localisation en temps réel ou en différé sans consentement',
    explanation:
        'Le cours ajoute explicitement la localisation (temps réel ou différé) au champ de 226-1.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Localisation (précision)',
    question:
        'Selon le cours, le niveau de précision de la localisation (zone relais vs GPS précis) :',
    options: [
      'Importe peu',
      'Doit être GPS précis',
      'Doit être une zone large',
    ],
    answer: 'Importe peu',
    explanation:
        'Le cours précise que la précision importe peu (zone relais ou GPS).',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Atteinte à la vie privée — Élément moral (2 composantes)',
    question:
        'Selon le cours, l’élément moral des atteintes à la vie privée implique :',
    options: [
      'Conscience de l’illicéité + volonté de porter atteinte à la vie privée',
      'Simple négligence',
      'Intention de nuire obligatoire',
    ],
    answer:
        'Conscience de l’illicéité + volonté de porter atteinte à la vie privée',
    explanation:
        'Le cours cite : conscience de se livrer à un acte illicite et volonté d’atteindre la vie privée (motivation indifférente).',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Secret professionnel — Définition (acte)',
    question:
        'Selon le cours, l’atteinte au secret professionnel consiste en :',
    options: [
      'La révélation d’une information à caractère secret par un dépositaire',
      'La conservation d’une information secrète',
      'L’oubli d’un rendez-vous',
    ],
    answer:
        'La révélation d’une information à caractère secret par un dépositaire',
    explanation:
        'Le cours définit 226-13 : révélation d’une information secrète par le dépositaire.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Confirmation d’info déjà publique',
    question:
        'Selon le cours, si l’information a déjà fait l’objet de publicité, l’infraction peut être retenue contre le dépositaire qui :',
    options: [
      'Confirme ou infirme cette information',
      'Reste silencieux',
      'Demande un conseil',
    ],
    answer: 'Confirme ou infirme cette information',
    explanation:
        'Le cours précise que confirmer/infirmer une info déjà publique peut constituer la révélation.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Violation de domicile — Domicile et meubles',
    question:
        'Selon le cours, un logement inoccupé peut être considéré domicile si :',
    options: [
      'Il contient des meubles signalant une occupation effective (table, lit, canapé, électroménager, etc.)',
      'Il est totalement vide',
      'Il ne contient qu’une bicyclette',
    ],
    answer:
        'Il contient des meubles signalant une occupation effective (table, lit, canapé, électroménager, etc.)',
    explanation:
        'Le cours explique que la présence de meubles “d’occupation effective” peut permettre de qualifier domicile (appréciation du juge).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Bicyclette/ carton de livres',
    question:
        'Selon le cours, la seule présence d’une bicyclette ou d’un carton de livres dans un logement vacant :',
    options: [
      'Ne suffit pas à regarder le logement comme un domicile',
      'Suffit toujours à caractériser un domicile',
      'Transforme automatiquement en local professionnel',
    ],
    answer: 'Ne suffit pas à regarder le logement comme un domicile',
    explanation:
        'Le cours précise que ces éléments isolés ne suffisent pas à caractériser un domicile.',
    difficulty: 'Moyenne',
  ),
  // =========================================================
  // PACK 50 QUESTIONS (9/50)
  // =========================================================
  QuizQuestion(
    category:
        'Atteinte à la vie privée — Circonstance aggravante (conjoint/PACS)',
    question:
        'Selon le cours, il y a circonstance aggravante (226-1 al.7) lorsque les faits sont commis par :',
    options: [
      'Le conjoint, le concubin ou le partenaire lié par un PACS',
      'Un collègue de travail',
      'Un voisin',
    ],
    answer: 'Le conjoint, le concubin ou le partenaire lié par un PACS',
    explanation:
        'Le cours mentionne l’aggravation prévue à l’article 226-1 al.7 (conjoint/concubin/PACS).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Atteinte à la vie privée — Circonstance aggravante (DAP/MSP/mandat)',
    question:
        'Selon le cours (226-1 al.8), il y a circonstance aggravante lorsque les faits sont commis au préjudice :',
    options: [
      'D’une personne dépositaire de l’autorité publique / chargée d’une mission de service public / titulaire d’un mandat électif public (ou candidate), ou d’un membre de sa famille',
      'D’une personne uniquement majeure',
      'D’un simple passant',
    ],
    answer:
        'D’une personne dépositaire de l’autorité publique / chargée d’une mission de service public / titulaire d’un mandat électif public (ou candidate), ou d’un membre de sa famille',
    explanation:
        'Le cours vise l’aggravation de l’article 226-1 al.8 (DAP/MSP/mandat électif/candidat + membre de la famille).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Atteinte à la vie privée — Paroles/images sexuelles (aggravation)',
    question:
        'Selon le cours (226-2-1 al.1), il y a aggravation lorsque les faits portent sur :',
    options: [
      'Des paroles ou images présentant un caractère sexuel prises dans un lieu public ou privé',
      'Des images de paysage',
      'Un document administratif',
    ],
    answer:
        'Des paroles ou images présentant un caractère sexuel prises dans un lieu public ou privé',
    explanation:
        'Le cours mentionne l’article 226-2-1 al.1 comme circonstance aggravante quand le contenu est sexuel (lieu public ou privé).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Peine (simple 226-1)',
    question:
        'Selon le cours, la peine principale (simple) des atteintes à la vie privée (226-1) est :',
    options: [
      '1 an d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le tableau de répression du cours indique (simple) : 1 an + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Peine aggravée',
    question:
        'Selon le cours, en cas de circonstance aggravante (ex : 226-1 al.7/8), la peine principale peut être :',
    options: [
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '5 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 60 000 € d’amende',
    explanation:
        'Le cours indique une peine aggravée à 2 ans et 60 000 € pour les circonstances prévues.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Tentative',
    question:
        'Selon le cours, la tentative des délits prévus aux articles 226-1 et 226-2 est :',
    options: [
      'Punissable (prévue par 226-5)',
      'Non punissable',
      'Punissable seulement en cas d’argent',
    ],
    answer: 'Punissable (prévue par 226-5)',
    explanation:
        'Le cours mentionne expressément la tentative prévue à l’article 226-5 pour 226-1 et 226-2.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Complicité',
    question:
        'Selon le cours, la complicité des atteintes à la vie privée est :',
    options: [
      'Punissable (121-6 et 121-7 C.P.)',
      'Non punissable',
      'Punissable uniquement pour la presse',
    ],
    answer: 'Punissable (121-6 et 121-7 C.P.)',
    explanation:
        'Le cours rappelle les règles générales de la complicité applicables.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Secret des correspondances — Fondement (particulier)',
    question:
        'L’atteinte au secret des correspondances commise par un particulier est prévue par :',
    options: [
      'L’article 226-15 alinéa 1 du Code pénal',
      'L’article 226-15 alinéa 2 du Code pénal',
      'L’article 226-13 du Code pénal',
    ],
    answer: 'L’article 226-15 alinéa 1 du Code pénal',
    explanation:
        'Le cours précise : 226-15 al.1 définit et réprime l’atteinte au secret des correspondances (non électronique).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Actes matériels (liste)',
    question: 'Selon le cours (226-15 al.1), l’atteinte peut consister à :',
    options: [
      'Ouvrir, supprimer, retarder, détourner ou prendre frauduleusement connaissance',
      'Répondre à une lettre',
      'Écrire une carte postale',
    ],
    answer:
        'Ouvrir, supprimer, retarder, détourner ou prendre frauduleusement connaissance',
    explanation:
        'Le cours énumère précisément les actes matériels de l’alinéa 1.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Ouvrir (notion)',
    question: 'Selon le cours, “ouvrir” une correspondance consiste à :',
    options: [
      'Porter atteinte à l’intégrité du support donnant accès au contenu (même partiellement)',
      'Lire un document public',
      'Regarder l’enveloppe fermée',
    ],
    answer:
        'Porter atteinte à l’intégrité du support donnant accès au contenu (même partiellement)',
    explanation:
        'Le cours indique que tout acte portant atteinte à l’intégrité du support et donnant accès au contenu constitue l’ouverture.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Supprimer (exemple)',
    question:
        'Selon le cours (jurisprudence citée), peut constituer une suppression :',
    options: [
      'Jeter à la poubelle une lettre après l’avoir lue (empêcher qu’elle parvienne)',
      'Remettre le courrier immédiatement',
      'Réexpédier le courrier au bon destinataire',
    ],
    answer:
        'Jeter à la poubelle une lettre après l’avoir lue (empêcher qu’elle parvienne)',
    explanation:
        'Le cours cite l’exemple de la secrétaire de mairie ayant jeté une lettre après l’avoir lue.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Retarder (exemples)',
    question: 'Selon le cours, peut caractériser un retard de correspondance :',
    options: [
      'Retenir le courrier en interrompant son acheminement normal',
      'Ouvrir son propre courrier',
      'Poster une lettre trop tôt',
    ],
    answer: 'Retenir le courrier en interrompant son acheminement normal',
    explanation:
        'Le cours définit le retard comme la rétention qui interrompt le cours normal d’acheminement.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Détourner (notion)',
    question:
        'Selon le cours, “détourner” une correspondance (226-15 al.1) consiste à :',
    options: [
      'Modifier le cours normal de la transmission (retard volontaire infligé)',
      'Lire un panneau public',
      'Ignorer le courrier',
    ],
    answer:
        'Modifier le cours normal de la transmission (retard volontaire infligé)',
    explanation:
        'Le cours indique que le détournement modifie le cours normal de la transmission.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Secret des correspondances — Connaissance frauduleuse (autonome)',
    question:
        'Selon le cours, “prendre frauduleusement connaissance du contenu” est :',
    options: [
      'Sanctionné de façon autonome, même sans ouverture/retard/détournement par l’auteur',
      'Sanctionné seulement si le courrier est détruit',
      'Jamais sanctionné',
    ],
    answer:
        'Sanctionné de façon autonome, même sans ouverture/retard/détournement par l’auteur',
    explanation:
        'Le cours précise que le législateur sanctionne cet acte de façon autonome.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Élément moral (mauvaise foi)',
    question: 'Selon le cours, la mauvaise foi implique notamment :',
    options: [
      'Connaître que le courrier ne lui était pas destiné et agir volontairement',
      'Être stressé',
      'Être en retard',
    ],
    answer:
        'Connaître que le courrier ne lui était pas destiné et agir volontairement',
    explanation:
        'Le cours rappelle la définition jurisprudentielle : connaissance + action volontaire (conserver/empêcher/retarder).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Intention de nuire',
    question: 'Selon le cours, l’intention de nuire pour 226-15 al.1 :',
    options: [
      'N’est pas exigée',
      'Est obligatoire',
      'Est présumée automatiquement',
    ],
    answer: 'N’est pas exigée',
    explanation:
        'Le cours précise que l’intention de nuire n’est pas exigée (mobile indifférent).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Peine (simple)',
    question:
        'Selon le cours, la peine principale (simple) de 226-15 al.1 est :',
    options: [
      '1 an d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le tableau de répression indique : 226-15 al.1 (simple) = 1 an + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Peine (aggravée conjoint/PACS)',
    question:
        'Selon le cours, lorsque 226-15 al.3 s’applique (conjoint/concubin/PACS), la peine est :',
    options: [
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '5 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 60 000 € d’amende',
    explanation:
        'Le tableau de répression indique : aggravé (226-15 al.3) = 2 ans + 60 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Tentative',
    question: 'Selon le cours, la tentative pour 226-15 est :',
    options: [
      'Non punissable',
      'Punissable (226-5)',
      'Punissable uniquement si violence',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours indique : TENTATIVE : NON.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Complicité',
    question: 'Selon le cours, la complicité pour 226-15 est :',
    options: [
      'Punissable',
      'Non punissable',
      'Punissable seulement si l’auteur est dépositaire d’autorité',
    ],
    answer: 'Punissable',
    explanation: 'Le cours précise : COMPLICITÉ : OUI (règles générales).',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Atteinte à l’intimité — Fondement',
    question:
        'L’atteinte à l’intimité d’une personne (observation des parties intimes dissimulées) est prévue par :',
    options: [
      'L’article 226-3-1 du Code pénal',
      'L’article 226-1 du Code pénal',
      'L’article 226-8 du Code pénal',
    ],
    answer: 'L’article 226-3-1 du Code pénal',
    explanation:
        'Le cours précise : 226-3-1 prévoit et réprime l’atteinte à l’intimité d’une personne.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité — Condition (parties intimes cachées)',
    question:
        'Selon le cours, l’infraction suppose d’apercevoir des parties intimes que la victime a cachées :',
    options: [
      'Par son habillement ou par sa présence dans un lieu clos',
      'Uniquement par un masque',
      'Uniquement par une porte ouverte',
    ],
    answer: 'Par son habillement ou par sa présence dans un lieu clos',
    explanation:
        'Le cours indique les 2 cas : habillement ou présence dans un lieu clos.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité — À l’insu ou sans consentement',
    question: 'Selon le cours, l’auteur doit avoir agi :',
    options: [
      'À l’insu ou sans le consentement de la victime',
      'Avec l’accord écrit systématique',
      'Uniquement avec témoins',
    ],
    answer: 'À l’insu ou sans le consentement de la victime',
    explanation:
        'Le cours reprend la condition : à l’insu ou sans consentement.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité — Élément moral',
    question: 'Selon le cours, l’élément moral de 226-3-1 implique :',
    options: [
      'Conscience de commettre un acte impudique + volonté d’attenter à l’intimité',
      'Négligence simple',
      'Intention de nuire obligatoire',
    ],
    answer:
        'Conscience de commettre un acte impudique + volonté d’attenter à l’intimité',
    explanation:
        'Le cours mentionne ces deux composantes : conscience + volonté d’atteinte à l’intimité.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité — Aggravation (abus d’autorité)',
    question:
        'Selon le cours (226-3-1 al.2), il y a circonstance aggravante lorsqu’ils sont commis :',
    options: [
      'Par une personne abusant de l’autorité que lui confèrent ses fonctions',
      'Par un enfant de moins de 10 ans',
      'Par un touriste',
    ],
    answer:
        'Par une personne abusant de l’autorité que lui confèrent ses fonctions',
    explanation:
        'Le cours liste cette circonstance aggravante : abus d’autorité liée aux fonctions.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité — Aggravation (mineur)',
    question:
        'Selon le cours (226-3-1 al.2), il y a circonstance aggravante lorsqu’ils sont commis :',
    options: [
      'Sur un mineur',
      'Sur un majeur uniquement',
      'Uniquement en lieu public',
    ],
    answer: 'Sur un mineur',
    explanation:
        'Le cours mentionne explicitement l’aggravation quand la victime est mineure.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité — Aggravation (vulnérabilité)',
    question:
        'Selon le cours (226-3-1 al.2), il y a circonstance aggravante lorsqu’ils sont commis :',
    options: [
      'Sur une personne vulnérable (âge, maladie, infirmité, déficience, grossesse) connue ou apparente',
      'Sur une personne sportive',
      'Sur une personne riche',
    ],
    answer:
        'Sur une personne vulnérable (âge, maladie, infirmité, déficience, grossesse) connue ou apparente',
    explanation:
        'Le cours vise la vulnérabilité apparente ou connue (âge/maladie/infirmité/déficience/grossesse).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité — Aggravation (pluralité)',
    question:
        'Selon le cours (226-3-1 al.2), il y a circonstance aggravante lorsqu’ils sont commis :',
    options: [
      'Par plusieurs personnes agissant comme auteurs ou complices',
      'Par une seule personne',
      'Par une personne inconnue de la victime',
    ],
    answer: 'Par plusieurs personnes agissant comme auteurs ou complices',
    explanation:
        'Le cours mentionne l’aggravation en cas de pluralité d’auteurs/complices.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité — Peine simple',
    question:
        'Selon le cours, la peine principale (simple) de 226-3-1 al.1 est :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '1 an d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 226-3-1 al.1 = 1 an + 15 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité — Peine aggravée',
    question:
        'Selon le cours, la peine principale (aggravée) de 226-3-1 al.2 est :',
    options: [
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 30 000 € d’amende',
    explanation: 'Le cours indique : aggravé = 2 ans + 30 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité — Tentative',
    question:
        'Selon le cours, la tentative de l’atteinte à l’intimité (226-3-1) est :',
    options: [
      'Punissable (prévue par 226-5)',
      'Non punissable',
      'Punissable uniquement si mineur',
    ],
    answer: 'Punissable (prévue par 226-5)',
    explanation:
        'Le cours précise que la tentative de 226-3-1 est prévue expressément par 226-5.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à l’intimité — Complicité',
    question: 'Selon le cours, la complicité de 226-3-1 est :',
    options: [
      'Punissable (aide/assistance, provocation, instructions)',
      'Non punissable',
      'Punissable uniquement pour l’auteur principal',
    ],
    answer: 'Punissable (aide/assistance, provocation, instructions)',
    explanation:
        'Le cours indique : COMPLICITÉ : OUI, selon les règles générales.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Secret professionnel — Fondement',
    question:
        'L’atteinte au secret professionnel est définie et réprimée par :',
    options: [
      'L’article 226-13 du Code pénal',
      'L’article 226-10 du Code pénal',
      'L’article 226-15 du Code pénal',
    ],
    answer: 'L’article 226-13 du Code pénal',
    explanation:
        'Le cours précise : 226-13 définit et réprime l’atteinte au secret professionnel.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Dépositaire (formule)',
    question:
        'Selon le cours, est dépositaire du secret la personne qui en a connaissance :',
    options: [
      'Par état, profession, fonction ou mission temporaire',
      'Uniquement si elle a signé un contrat',
      'Uniquement si elle est médecin',
    ],
    answer: 'Par état, profession, fonction ou mission temporaire',
    explanation:
        'Le cours reprend la formule légale : état/profession/fonction/mission temporaire.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Secret (définition étendue)',
    question:
        'Selon le cours, le secret couvre aussi ce que le professionnel a pu :',
    options: [
      'Constater, découvrir ou déduire personnellement à l’occasion de sa profession',
      'Lire dans un roman',
      'Voir dans un film',
    ],
    answer:
        'Constater, découvrir ou déduire personnellement à l’occasion de sa profession',
    explanation:
        'Le cours indique que le secret est étendu à tout ce que le dépositaire constate/découvre/déduit dans l’exercice.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Révélation (une seule personne suffit)',
    question:
        'Selon le cours, il suffit que l’information secrète soit transmise :',
    options: [
      'À une seule personne pour que l’infraction soit constituée',
      'À au moins 10 personnes',
      'Au public uniquement',
    ],
    answer: 'À une seule personne pour que l’infraction soit constituée',
    explanation: 'Le cours précise : transmission à une seule personne suffit.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Élément moral',
    question: 'Selon le cours, l’élément moral de 226-13 suppose :',
    options: [
      'La conscience de révéler un secret dont on est dépositaire',
      'Une imprudence simple',
      'Un profit obligatoire',
    ],
    answer: 'La conscience de révéler un secret dont on est dépositaire',
    explanation:
        'Le cours indique une révélation intentionnelle, en connaissance de cause.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Peine',
    question:
        'Selon le cours, l’atteinte au secret professionnel (226-13) est punie de :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '1 an d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation:
        'Le tableau de répression du cours indique : 226-13 = 1 an + 15 000 €.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Secret professionnel — Exceptions (principe)',
    question:
        'Selon le cours, l’article 226-14 prévoit que 226-13 ne s’applique pas dans certains cas de :',
    options: [
      'Signalement aux autorités dans les conditions prévues',
      'Révélation pour se vanter',
      'Publication sur réseaux sociaux',
    ],
    answer: 'Signalement aux autorités dans les conditions prévues',
    explanation:
        'Le cours liste les exceptions de 226-14 : signalements/procédure encadrée.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Secret professionnel — Exception maltraitances (mineur/vulnérable)',
    question:
        'Selon le cours (226-14), le secret ne s’applique pas à celui qui informe les autorités de :',
    options: [
      'Maltraitances/privations/sévices infligés à un mineur ou à une personne incapable de se protéger',
      'Un simple désaccord familial',
      'Un retard de paiement',
    ],
    answer:
        'Maltraitances/privations/sévices infligés à un mineur ou à une personne incapable de se protéger',
    explanation:
        'Le cours rappelle l’exception de signalement aux autorités en cas de maltraitances envers mineur/personne vulnérable.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Secret professionnel — Exception professionnel de santé (avec accord)',
    question:
        'Selon le cours (226-14), un médecin ou professionnel de santé peut porter à la connaissance du procureur :',
    options: [
      'Des violences au sein du couple (conditions spécifiques) ou certains faits, en s’efforçant d’obtenir l’accord selon le cas',
      'N’importe quelle information sans condition',
      'Uniquement les secrets bancaires',
    ],
    answer:
        'Des violences au sein du couple (conditions spécifiques) ou certains faits, en s’efforçant d’obtenir l’accord selon le cas',
    explanation:
        'Le cours détaille plusieurs hypothèses encadrées (accord de la victime selon situation, danger, etc.).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Exception sujétion (223-15-3)',
    question:
        'Selon le cours (226-14), un professionnel de santé peut signaler des faits de sujétion (223-15-3) si :',
    options: [
      'Il estime en conscience que cela altère gravement la santé ou conduit à un acte/abstention gravement préjudiciable (accord victime requis sauf mineur/incapable)',
      'Il veut se protéger juridiquement sans raison',
      'La victime est inconnue',
    ],
    answer:
        'Il estime en conscience que cela altère gravement la santé ou conduit à un acte/abstention gravement préjudiciable (accord victime requis sauf mineur/incapable)',
    explanation:
        'Le cours précise l’exception 226-14 liée à 223-15-3 et ses conditions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Secret professionnel — Exception violences couple (danger immédiat)',
    question:
        'Selon le cours (226-14), un médecin peut signaler des violences au sein du couple lorsque :',
    options: [
      'Il estime que la vie de la victime majeure est en danger immédiat et qu’elle ne peut se protéger en raison de l’emprise/contrainte morale',
      'La victime refuse et il n’y a aucun danger',
      'Les faits sont anciens sans risque',
    ],
    answer:
        'Il estime que la vie de la victime majeure est en danger immédiat et qu’elle ne peut se protéger en raison de l’emprise/contrainte morale',
    explanation:
        'Le cours mentionne cette exception spécifique : danger immédiat + impossibilité de se protéger (emprise/contrainte morale).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Signalement violences couple (accord)',
    question:
        'Selon le cours (226-14), en matière de violences au sein du couple, le professionnel de santé :',
    options: [
      'Doit s’efforcer d’obtenir l’accord de la victime majeure (et l’informer du signalement si impossibilité)',
      'Peut signaler sans jamais informer',
      'N’a aucun devoir particulier',
    ],
    answer:
        'Doit s’efforcer d’obtenir l’accord de la victime majeure (et l’informer du signalement si impossibilité)',
    explanation:
        'Le cours précise : effort pour obtenir l’accord, et information de la victime en cas d’impossibilité.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Prefet/prefet de police (armes)',
    question:
        'Selon le cours (226-14), les professionnels de santé ou de l’action sociale peuvent informer le préfet (à Paris, préfet de police) :',
    options: [
      'Du caractère dangereux de personnes qui les consultent et dont ils savent qu’elles détiennent une arme ou veulent en acquérir une',
      'De toute personne stressée',
      'De toute personne triste',
    ],
    answer:
        'Du caractère dangereux de personnes qui les consultent et dont ils savent qu’elles détiennent une arme ou veulent en acquérir une',
    explanation:
        'Le cours mentionne cette exception 226-14 : information au préfet/prefet de police liée au danger et aux armes.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Vétérinaire (sévices animaux)',
    question:
        'Selon le cours (226-14), le vétérinaire peut porter à la connaissance du procureur :',
    options: [
      'Des sévices graves, actes de cruauté ou atteintes sexuelles sur animal, et mauvais traitements constatés',
      'Toute info sans lien',
      'Uniquement des infos commerciales',
    ],
    answer:
        'Des sévices graves, actes de cruauté ou atteintes sexuelles sur animal, et mauvais traitements constatés',
    explanation:
        'Le cours cite l’exception 226-14 spécifique au vétérinaire (521-1, 521-1-1 et mauvais traitements).',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Secret professionnel — Protection de l’auteur du signalement',
    question:
        'Selon le cours (226-14), le signalement effectué dans les conditions prévues :',
    options: [
      'Ne peut engager la responsabilité de son auteur sauf mauvaise foi',
      'Engage toujours la responsabilité pénale',
      'Engage automatiquement la responsabilité disciplinaire',
    ],
    answer: 'Ne peut engager la responsabilité de son auteur sauf mauvaise foi',
    explanation:
        'Le cours précise que le signalement ne peut engager la responsabilité civile/pénale/disciplininaire sauf absence de bonne foi.',
    difficulty: 'Moyenne',
  ),
  // =========================================================
  // PACK 50 QUESTIONS (10/50)
  // =========================================================
  QuizQuestion(
    category: 'Dénonciation calomnieuse — “Par tout moyen”',
    question:
        'Selon le cours (226-10), la dénonciation calomnieuse peut être faite :',
    options: [
      'Par tout moyen (écrit ou oral)',
      'Uniquement par lettre recommandée',
      'Uniquement en présence d’un avocat',
    ],
    answer: 'Par tout moyen (écrit ou oral)',
    explanation:
        'Le cours précise que 226-10 vise une dénonciation “par tout moyen” : écrite ou verbale.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Dénonciation anonyme',
    question:
        'Selon le cours, en cas de dénonciation anonyme, pour poursuivre il faut que :',
    options: [
      'L’auteur soit identifiable',
      'La lettre soit signée',
      'La victime avoue immédiatement',
    ],
    answer: 'L’auteur soit identifiable',
    explanation:
        'Le cours indique que si la dénonciation est anonyme, il faut que son auteur puisse être identifié.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Personne morale',
    question:
        'Selon le cours, la personne visée par une dénonciation calomnieuse peut être :',
    options: [
      'Une personne physique ou une personne morale',
      'Uniquement une personne physique',
      'Uniquement une association non déclarée',
    ],
    answer: 'Une personne physique ou une personne morale',
    explanation:
        'Le cours précise que la victime peut être une personne physique ou morale, à condition d’être déterminée/identifiable.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Identification sans nom',
    question:
        'Selon le cours, même sans nommer la victime, la dénonciation peut viser une personne déterminée si :',
    options: [
      'Elle contient des détails qui font nécessairement porter les soupçons sur une personne précise',
      'Elle est longue',
      'Elle est écrite en majuscules',
    ],
    answer:
        'Elle contient des détails qui font nécessairement porter les soupçons sur une personne précise',
    explanation:
        'Le cours indique que des détails peuvent suffire à identifier la personne même sans la nommer.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Remise en main propre',
    question:
        'Selon le cours, il est nécessaire que la dénonciation soit remise en main propre à l’autorité :',
    options: [
      'Non, il suffit de l’adresser ou de faire en sorte qu’elle lui parvienne',
      'Oui, sinon pas d’infraction',
      'Oui, uniquement pour une plainte',
    ],
    answer:
        'Non, il suffit de l’adresser ou de faire en sorte qu’elle lui parvienne',
    explanation:
        'Le cours précise qu’il n’est pas nécessaire d’une remise en main propre : il suffit qu’elle parvienne au destinataire.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Faits “de nature à entraîner”',
    question: 'Selon le cours, pour 226-10, le fait dénoncé doit être :',
    options: [
      'De nature à entraîner des sanctions judiciaires, administratives ou disciplinaires',
      'Uniquement un fait pénal déjà jugé',
      'Un simple avis',
    ],
    answer:
        'De nature à entraîner des sanctions judiciaires, administratives ou disciplinaires',
    explanation:
        'Le cours rappelle la condition “de nature à entraîner” des sanctions.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Diffamation vs 226-10',
    question:
        'Selon le cours, une différence essentielle entre dénonciation calomnieuse et diffamation est que la dénonciation calomnieuse :',
    options: [
      'Est de nature à entraîner des sanctions par une autorité (judiciaire/administrative/disciplin.)',
      'Ne porte jamais atteinte à l’honneur',
      'Est toujours publique',
    ],
    answer:
        'Est de nature à entraîner des sanctions par une autorité (judiciaire/administrative/disciplin.)',
    explanation:
        'Le cours explique que 226-10 va au-delà de l’atteinte à l’honneur : elle expose à sanctions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Tribunal (autres cas)',
    question:
        'Selon le cours, en dehors des cas où une décision définitive constate expressément l’absence de fait/imputabilité :',
    options: [
      'Le tribunal saisi apprécie la pertinence des accusations',
      'La fausseté est automatique',
      'La plainte est irrecevable',
    ],
    answer: 'Le tribunal saisi apprécie la pertinence des accusations',
    explanation:
        'Le cours prévoit que dans les autres cas, le tribunal apprécie la pertinence des accusations.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Violation de domicile — Notion extensive',
    question:
        'Selon le cours, la jurisprudence retient une définition du domicile :',
    options: [
      'Extensive (incluant divers lieux d’habitation et certains prolongements)',
      'Très restrictive (uniquement résidence principale)',
      'Limitée aux logements occupés légalement',
    ],
    answer:
        'Extensive (incluant divers lieux d’habitation et certains prolongements)',
    explanation:
        'Le cours souligne une approche extensive de la notion de domicile en jurisprudence.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Dépendances (proximité)',
    question: 'Selon le cours, une dépendance peut relever du domicile si :',
    options: [
      'Elle est une annexe et se trouve à proximité immédiate (lien étroit) de l’habitation',
      'Elle est située dans une autre ville',
      'Elle est un lieu public',
    ],
    answer:
        'Elle est une annexe et se trouve à proximité immédiate (lien étroit) de l’habitation',
    explanation:
        'Le cours insiste sur la nécessité d’un lien étroit et immédiat + proximité pour les dépendances.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Chambre d’hôtel',
    question:
        'Selon le cours, une chambre d’hôtel peut être considérée comme :',
    options: ['Un domicile', 'Un lieu public', 'Un local réservé à la vente'],
    answer: 'Un domicile',
    explanation:
        'Le cours cite explicitement la chambre d’hôtel parmi les domiciles possibles.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Véhicule aménagé',
    question: 'Selon le cours, peut constituer un domicile :',
    options: [
      'Un véhicule aménagé pour l’habitation (caravane, roulotte, tente)',
      'Un simple vélo',
      'Un scooter stationné',
    ],
    answer: 'Un véhicule aménagé pour l’habitation (caravane, roulotte, tente)',
    explanation:
        'Le cours cite les véhicules aménagés (caravane, roulotte, tente) comme pouvant être des domiciles.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Lieux professionnels',
    question:
        'Selon le cours, les locaux professionnels peuvent être protégés comme domicile, mais les lieux ouverts au public :',
    options: [
      'Ne bénéficient pas de la protection pendant les heures d’ouverture',
      'Sont toujours protégés 24/24',
      'Ne sont jamais protégés',
    ],
    answer:
        'Ne bénéficient pas de la protection pendant les heures d’ouverture',
    explanation:
        'Le cours précise que les lieux ouverts au public ne bénéficient pas de la protection du domicile pendant les heures d’ouverture.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Lieu non domicile',
    question: 'Selon le cours, n’est pas considéré comme domicile :',
    options: [
      'Un immeuble en construction',
      'Une maison de vacances meublée',
      'Une chambre d’hôtel',
    ],
    answer: 'Un immeuble en construction',
    explanation:
        'Le cours liste l’immeuble en construction parmi les lieux non considérés comme domicile.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Porte non fermée à clé',
    question:
        'Selon le cours, l’introduction illicite n’a pas pu être retenue lorsque :',
    options: [
      'La porte du local n’était pas fermée à clés',
      'La personne a escaladé un mur',
      'La personne a forcé une serrure',
    ],
    answer: 'La porte du local n’était pas fermée à clés',
    explanation:
        'Le cours mentionne ce cas : l’introduction illicite n’a pas été retenue lorsque la porte n’était pas fermée à clé.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Voies de fait (escalade/forçage)',
    question: 'Selon le cours, une voie de fait peut consister en :',
    options: [
      'Escalader un mur, forcer une serrure, briser une vitre, desceler des barreaux',
      'Demander l’autorisation',
      'Envoyer un SMS',
    ],
    answer:
        'Escalader un mur, forcer une serrure, briser une vitre, desceler des barreaux',
    explanation:
        'Le cours liste ces exemples de violences contre les choses (voies de fait).',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Correspondances électroniques — Objet protégé',
    question:
        'Selon le cours (226-15 al.2), sont protégées les correspondances :',
    options: [
      'Émises, transmises ou reçues par la voie électronique',
      'Imprimées uniquement',
      'Écrites sur un cahier personnel',
    ],
    answer: 'Émises, transmises ou reçues par la voie électronique',
    explanation:
        'Le cours précise que 226-15 al.2 protège les correspondances dématérialisées (électroniques).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Moment de protection',
    question: 'Selon le cours, 226-15 al.2 s’applique aux correspondances :',
    options: [
      'En cours de transmission ou parvenues à destination mais non encore appréhendées',
      'Uniquement après lecture par le destinataire',
      'Uniquement avant envoi',
    ],
    answer:
        'En cours de transmission ou parvenues à destination mais non encore appréhendées',
    explanation:
        'Le cours indique que la protection vise l’en-cours de transmission ou à destination non encore lue.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Mail déjà ouvert',
    question:
        'Selon le cours, une fois que le destinataire a pris connaissance du mail, celui-ci :',
    options: [
      'Perd ce caractère spécifique et devient des données informatiques “quelconques”',
      'Reste toujours une correspondance protégée par 226-15 al.2',
      'Devient automatiquement une image privée',
    ],
    answer:
        'Perd ce caractère spécifique et devient des données informatiques “quelconques”',
    explanation:
        'Le cours explique qu’après lecture par le destinataire, le message perd la spécificité de correspondance au sens 226-15 al.2.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Intercepter (définition)',
    question: 'Selon le cours, “intercepter” consiste à :',
    options: [
      'Capter les messages pendant leur transmission (prendre au passage et par surprise)',
      'Effacer un message déjà lu',
      'Classer un message dans un dossier',
    ],
    answer:
        'Capter les messages pendant leur transmission (prendre au passage et par surprise)',
    explanation:
        'Le cours définit l’interception comme la captation pendant le cours de la transmission.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Détourner (définition)',
    question:
        'Selon le cours, “détourner” en matière électronique consiste à :',
    options: [
      'Modifier le cours de la transmission via un dispositif orientant la correspondance vers un point déterminé',
      'Imprimer un mail',
      'Mettre un mail en brouillon',
    ],
    answer:
        'Modifier le cours de la transmission via un dispositif orientant la correspondance vers un point déterminé',
    explanation:
        'Le cours décrit le détournement comme la dérivation de la correspondance vers un autre point.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Atteinte à la représentation — Montage (condition)',
    question:
        'Selon le cours (226-8), l’infraction suppose la diffusion d’un montage sans consentement si :',
    options: [
      'Il n’apparaît pas à l’évidence que c’est un montage ou si ce n’est pas expressément mentionné',
      'Le montage est toujours signalé clairement',
      'La victime a publié elle-même',
    ],
    answer:
        'Il n’apparaît pas à l’évidence que c’est un montage ou si ce n’est pas expressément mentionné',
    explanation:
        'Le cours précise la condition : montage non évident et/ou non signalé expressément.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Exceptions (montage évident)',
    question:
        'Selon le cours, le consentement à la publication n’est pas nécessaire si :',
    options: [
      'Il apparaît à l’évidence qu’il s’agit d’un montage',
      'La vidéo est longue',
      'La vidéo est en noir et blanc',
    ],
    answer: 'Il apparaît à l’évidence qu’il s’agit d’un montage',
    explanation:
        'Le cours prévoit l’exception : montage manifestement apparent → pas besoin de consentement à la publication.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Exceptions (mention expresse)',
    question:
        'Selon le cours, le consentement à la publication n’est pas nécessaire si :',
    options: [
      'Il est expressément fait mention qu’il s’agit d’un montage',
      'La victime est une personne publique',
      'Le montage est ancien',
    ],
    answer: 'Il est expressément fait mention qu’il s’agit d’un montage',
    explanation:
        'Le cours prévoit l’exception : mention claire/univoque du montage pour éviter la méprise.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Finalité humoristique',
    question:
        'Selon le cours, les limites (montage évident ou mentionné) permettent notamment de ne pas sanctionner :',
    options: [
      'Les contenus à finalité récréative/humoristique clairement identifiés',
      'Tous les deepfakes sans exception',
      'Toutes les parodies même trompeuses',
    ],
    answer:
        'Les contenus à finalité récréative/humoristique clairement identifiés',
    explanation:
        'Le cours précise que ces limites évitent de sanctionner les montages humoristiques clairement apparents ou signalés.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Pornodivulgation — Accord filmé ≠ accord diffusion',
    question:
        'Selon le cours, l’accord à être filmé/photographié vaut accord à la diffusion :',
    options: [
      'Non, l’accord à être filmé ne vaut pas accord à la diffusion',
      'Oui, toujours',
      'Oui, si la vidéo est courte',
    ],
    answer: 'Non, l’accord à être filmé ne vaut pas accord à la diffusion',
    explanation:
        'Le cours insiste : consentement à la captation ≠ consentement à la diffusion.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Preuve de l’accord de diffusion',
    question:
        'Selon le cours, si la victime dit ne pas avoir approuvé la diffusion, il appartient à l’auteur :',
    options: [
      'De prouver qu’il a reçu l’accord en vue d’une diffusion',
      'De prouver que la victime a menti sur tout',
      'De prouver que la vidéo est authentique',
    ],
    answer: 'De prouver qu’il a reçu l’accord en vue d’une diffusion',
    explanation:
        'Le cours précise que c’est à l’auteur de démontrer l’accord spécifique de diffusion.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Notion “revenge porn”',
    question:
        'Selon le cours, la pornodivulgation a été popularisée sous l’appellation :',
    options: ['Revenge porn', 'Home invasion', 'Deepweb mail'],
    answer: 'Revenge porn',
    explanation:
        'Le cours évoque l’appellation anglophone “revenge porn”, et le terme “pornodivulgation” en France.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Atteinte à la vie privée — Paroles privées (lieu)',
    question:
        'Selon le cours, l’atteinte (paroles privées/confidentielles) est constituée si les paroles ont été prononcées :',
    options: [
      'Dans un lieu privé ou public, dès lors qu’elles n’ont pas vocation à être rendues publiques',
      'Uniquement dans un lieu privé',
      'Uniquement sur internet',
    ],
    answer:
        'Dans un lieu privé ou public, dès lors qu’elles n’ont pas vocation à être rendues publiques',
    explanation:
        'Le cours précise que le lieu (public/privé) importe peu pour les paroles, si elles sont privées/confidentielles.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Enregistrement inaudible',
    question:
        'Selon le cours, l’infraction d’enregistrement de paroles privées est constituée même si :',
    options: [
      'Les propos enregistrés sont inaudibles',
      'La victime sourit',
      'La conversation dure moins d’une minute',
    ],
    answer: 'Les propos enregistrés sont inaudibles',
    explanation:
        'Le cours précise que l’infraction existe quels que soient les résultats techniques, même si inaudible.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Atteinte à la vie privée — Consentement présumé (paroles/images)',
    question:
        'Selon le cours, le consentement peut être présumé lorsque l’atteinte est accomplie :',
    options: [
      'Au vu et au su de la personne sans opposition alors qu’elle pouvait le faire',
      'Uniquement avec une signature',
      'Uniquement par un notaire',
    ],
    answer:
        'Au vu et au su de la personne sans opposition alors qu’elle pouvait le faire',
    explanation:
        'Le cours prévoit la présomption de consentement “au vu et au su” (paroles/images), sous réserve d’opposition.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Mineur (consentement)',
    question:
        'Selon le cours, pour un mineur, le consentement (paroles/images/localisation) doit émaner :',
    options: [
      'Des titulaires de l’autorité parentale',
      'D’un ami majeur',
      'Du mineur seul dans tous les cas',
    ],
    answer: 'Des titulaires de l’autorité parentale',
    explanation:
        'Le cours précise que le consentement doit provenir des titulaires de l’autorité parentale (art. 372-1 C. civ.).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Atteinte à la vie privée — Localisation (opposition d’un parent)',
    question: 'Selon le cours, pour la localisation d’un mineur, il suffit :',
    options: [
      'De l’opposition de l’un des titulaires de l’autorité parentale pour rendre la localisation illicite',
      'De l’accord du parent non gardien seulement',
      'De l’accord de l’enfant uniquement',
    ],
    answer:
        'De l’opposition de l’un des titulaires de l’autorité parentale pour rendre la localisation illicite',
    explanation:
        'Le cours indique qu’une opposition d’un des parents suffit à rendre la localisation illicite.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: '226-2 — Conservation (infraction autonome)',
    question:
        'Selon le cours, la simple conservation du produit d’une atteinte à la vie privée :',
    options: [
      'Est punissable même sans divulgation ni utilisation',
      'N’est jamais punissable',
      'Est punissable seulement si vendu',
    ],
    answer: 'Est punissable même sans divulgation ni utilisation',
    explanation:
        'Le cours précise que garder à disposition le produit de l’atteinte est réprimé indépendamment d’une diffusion.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '226-2 — Utilisation (divorce)',
    question: 'Selon le cours, peut constituer une “utilisation” (226-2) :',
    options: [
      'Utiliser des enregistrements illicites dans une procédure de divorce',
      'Jeter ses propres photos',
      'Regarder un film',
    ],
    answer:
        'Utiliser des enregistrements illicites dans une procédure de divorce',
    explanation:
        'Le cours donne l’exemple : usage d’enregistrements illicites dans une procédure de divorce.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: '226-2 — Diffusion (notion large)',
    question: 'Selon le cours, la “diffusion/divulgation” (226-2) vise :',
    options: [
      'Presse/radio/télé mais aussi simple communication à un tiers jusqu’alors ignorant',
      'Uniquement un journal national',
      'Uniquement un post viral',
    ],
    answer:
        'Presse/radio/télé mais aussi simple communication à un tiers jusqu’alors ignorant',
    explanation:
        'Le cours précise une conception large : diffusion à grande échelle ou simple révélation à un tiers.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: '226-2 — “Laisser porter à la connaissance du public”',
    question:
        'Selon le cours, peut être considéré auteur (226-2) celui qui, connaissant l’illicéité et ayant le pouvoir d’empêcher la diffusion :',
    options: [
      'N’agit pas pour empêcher la divulgation',
      'Dépose plainte immédiatement',
      'Supprime le fichier',
    ],
    answer: 'N’agit pas pour empêcher la divulgation',
    explanation:
        'Le cours indique que celui qui a le pouvoir de rendre la divulgation impossible doit agir ; sinon il peut être considéré auteur.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Secret professionnel — Caractère secret après décès',
    question: 'Selon le cours, le caractère secret d’une information :',
    options: [
      'Ne s’éteint pas avec le décès de la personne',
      'Disparaît dès le décès',
      'Disparaît après 1 an',
    ],
    answer: 'Ne s’éteint pas avec le décès de la personne',
    explanation:
        'Le cours précise que le caractère secret ne s’éteint pas avec le décès.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Révélation à un autre dépositaire',
    question:
        'Selon le cours, révéler une information secrète à une personne également soumise au secret professionnel :',
    options: [
      'Peut tout de même constituer l’infraction',
      'Est toujours autorisé',
      'Annule automatiquement l’infraction',
    ],
    answer: 'Peut tout de même constituer l’infraction',
    explanation:
        'Le cours indique que même si le destinataire est soumis au secret, la transmission suffit à caractériser la révélation.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Tentative',
    question:
        'Selon le cours, la tentative de violation du secret professionnel (226-13) est :',
    options: [
      'Non punissable',
      'Punissable (226-5)',
      'Punissable uniquement si média',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours indique : TENTATIVE : NON pour 226-13.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Complicité',
    question: 'Selon le cours, la complicité de 226-13 est :',
    options: [
      'Punissable (121-6 et 121-7)',
      'Non punissable',
      'Punissable seulement si la victime est mineure',
    ],
    answer: 'Punissable (121-6 et 121-7)',
    explanation:
        'Le cours précise : COMPLICITÉ : OUI, selon les règles générales.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Atteinte à la représentation — Élément moral',
    question: 'Selon le cours, l’élément moral de 226-8 implique :',
    options: [
      'La volonté de créer un montage en vue de tromper le public',
      'Une simple maladresse',
      'L’intention de nuire obligatoire',
    ],
    answer: 'La volonté de créer un montage en vue de tromper le public',
    explanation:
        'Le cours mentionne la volonté de tromper le public (le mobile/notoriété/profit importe peu).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Procédé numérique',
    question: 'Selon le cours, l’article 226-8 s’applique :',
    options: [
      'Aux montages numériques ou non, avec ou sans IA, dès lors que les conditions sont réunies',
      'Uniquement aux deepfakes IA',
      'Uniquement aux montages papier',
    ],
    answer:
        'Aux montages numériques ou non, avec ou sans IA, dès lors que les conditions sont réunies',
    explanation:
        'Le cours indique que 226-8 vise les montages “classiques” (numériques ou non) et assimile aussi les contenus générés algorithmiquement.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Pornodivulgation — Objet (supports)',
    question: 'Selon le cours, le support du contenu pornodivulgué peut être :',
    options: [
      'Visuel, audio, audiovisuel ou écrit (messages/sexting), matériel ou numérisé',
      'Uniquement une vidéo',
      'Uniquement une photo imprimée',
    ],
    answer:
        'Visuel, audio, audiovisuel ou écrit (messages/sexting), matériel ou numérisé',
    explanation:
        'Le cours indique que le support peut être photo/son/vidéo/messages, peu importe le format matériel ou numérique.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Élément moral',
    question: 'Selon le cours, l’élément moral de 226-2-1 al.2 suppose :',
    options: [
      'La conscience de diffuser sans accord un contenu à caractère sexuel',
      'Une erreur de manipulation (sans conscience)',
      'Un mobile financier obligatoire',
    ],
    answer:
        'La conscience de diffuser sans accord un contenu à caractère sexuel',
    explanation:
        'Le cours indique que l’auteur agit en connaissance de cause : diffusion sans accord d’un contenu sexuel.',
    difficulty: 'Moyenne',
  ),
  // =========================================================
  // PACK 50 QUESTIONS (11/50)
  // =========================================================
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Notion d’auteur',
    question: 'Selon le cours, l’auteur de la dénonciation est :',
    options: [
      'Celui qui l’effectue ou la fait effectuer par une tierce personne',
      'Uniquement celui qui reçoit la lettre',
      'Uniquement la victime',
    ],
    answer: 'Celui qui l’effectue ou la fait effectuer par une tierce personne',
    explanation:
        'Le cours précise que l’auteur est celui qui dénonce ou fait dénoncer (auteur moral assimilé à l’auteur juridique).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Auteur moral',
    question: 'Selon le cours, l’auteur moral est :',
    options: [
      'Assimilé à l’auteur juridique',
      'Toujours irresponsable',
      'Toujours simple témoin',
    ],
    answer: 'Assimilé à l’auteur juridique',
    explanation:
        'Le cours indique que l’auteur moral est assimilé à l’auteur juridique.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Victime identifiable',
    question: 'Selon le cours, la personne dénoncée doit être :',
    options: [
      'Déterminée et identifiable',
      'Inconnue de tous',
      'Toujours un groupe entier',
    ],
    answer: 'Déterminée et identifiable',
    explanation:
        'Le cours impose une personne déterminée, pouvant être identifiée (physique ou morale).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Prescription',
    question: 'Selon le cours, le délai de prescription commence à courir :',
    options: [
      'Au jour de réception par le destinataire',
      'Au jour où l’auteur a eu l’idée',
      'Au jour où la victime déménage',
    ],
    answer: 'Au jour de réception par le destinataire',
    explanation:
        'Le cours précise que la consommation (et la prescription) est fixée au jour de réception.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Destinataire (pouvoir de sanction)',
    question: 'Selon le cours, le destinataire doit être :',
    options: [
      'Investi d’un pouvoir de sanction à l’égard de la personne dénoncée, ou pouvant saisir l’autorité compétente',
      'N’importe quel tiers',
      'Uniquement un journaliste',
    ],
    answer:
        'Investi d’un pouvoir de sanction à l’égard de la personne dénoncée, ou pouvant saisir l’autorité compétente',
    explanation:
        'Le cours précise que le destinataire doit pouvoir sanctionner ou saisir l’autorité compétente.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Supérieur hiérarchique',
    question: 'Selon le cours, une dénonciation peut être adressée :',
    options: [
      'Aux supérieurs hiérarchiques ou à l’employeur de la personne dénoncée',
      'Uniquement au juge',
      'Uniquement à la victime',
    ],
    answer:
        'Aux supérieurs hiérarchiques ou à l’employeur de la personne dénoncée',
    explanation:
        'Le cours cite expressément supérieurs hiérarchiques/employeur parmi les destinataires possibles.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Nature des sanctions',
    question: 'Selon le cours, les sanctions visées par 226-10 peuvent être :',
    options: [
      'Judiciaires, administratives ou disciplinaires',
      'Uniquement civiles',
      'Uniquement financières privées',
    ],
    answer: 'Judiciaires, administratives ou disciplinaires',
    explanation:
        'Le texte du cours vise des sanctions judiciaires, administratives ou disciplinaires.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Connaissance de l’inexactitude',
    question: 'Selon le cours, l’infraction suppose que l’auteur :',
    options: [
      'Sache les faits totalement ou partiellement inexacts au moment de dénoncer',
      'Se trompe de bonne foi',
      'Ignore totalement le contenu',
    ],
    answer:
        'Sache les faits totalement ou partiellement inexacts au moment de dénoncer',
    explanation:
        'Le cours précise l’exigence de connaissance de l’inexactitude au jour de la dénonciation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Volonté de nuire',
    question:
        'Selon le cours, l’auteur exprime sa volonté de nuire notamment par :',
    options: [
      'La dénonciation consciente de faits inexacts',
      'Le silence complet',
      'La médiation',
    ],
    answer: 'La dénonciation consciente de faits inexacts',
    explanation:
        'Le cours relie l’élément moral à la connaissance de l’inexactitude et à la volonté de nuire.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Personnes morales (responsabilité)',
    question:
        'Selon le cours, la responsabilité pénale des personnes morales pour 226-10 est prévue par :',
    options: [
      'L’article 226-12 du Code pénal',
      'L’article 226-5 du Code pénal',
      'L’article 226-1 du Code pénal',
    ],
    answer: 'L’article 226-12 du Code pénal',
    explanation:
        'Le cours indique que la responsabilité des personnes morales est prévue expressément par 226-12.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Violation de domicile — Domicile (définition générale)',
    question: 'Selon le cours, constitue notamment un domicile :',
    options: [
      'Tout local d’habitation contenant des biens meubles appartenant à la personne, qu’elle y habite ou non',
      'Tout trottoir',
      'Toute boutique ouverte au public',
    ],
    answer:
        'Tout local d’habitation contenant des biens meubles appartenant à la personne, qu’elle y habite ou non',
    explanation:
        'Le cours donne cette définition générale : local d’habitation + biens meubles, habitation effective ou non.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Résidence principale ou non',
    question: 'Selon le cours, la protection du domicile s’applique :',
    options: [
      'Même si ce n’est pas la résidence principale',
      'Uniquement à la résidence principale',
      'Uniquement si propriétaire',
    ],
    answer: 'Même si ce n’est pas la résidence principale',
    explanation:
        'Le cours précise que le domicile peut être la résidence principale ou non.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Lieu occupé sans titre',
    question: 'Selon le cours, peut être considéré comme domicile :',
    options: [
      'Un logement occupé sans titre et pacifiquement',
      'Un immeuble en construction',
      'Un local réservé à la vente',
    ],
    answer: 'Un logement occupé sans titre et pacifiquement',
    explanation:
        'Le cours cite le logement occupé sans titre et pacifiquement comme pouvant être un domicile.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Domicile et bureau',
    question: 'Selon le cours, le bureau et les locaux professionnels :',
    options: [
      'Peuvent être assimilés à un domicile (sauf lieu ouvert au public pendant l’ouverture)',
      'Ne sont jamais protégés',
      'Sont toujours publics',
    ],
    answer:
        'Peuvent être assimilés à un domicile (sauf lieu ouvert au public pendant l’ouverture)',
    explanation:
        'Le cours indique que les locaux professionnels peuvent être un domicile, mais pas les lieux ouverts au public pendant les heures d’ouverture.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Dépendance (exemples)',
    question:
        'Selon le cours, peuvent être des dépendances assimilées au domicile :',
    options: [
      'Garage, terrasse, balcon, débarras, remise, cour close (si prolongement et proximité)',
      'Un parc municipal',
      'Un café',
    ],
    answer:
        'Garage, terrasse, balcon, débarras, remise, cour close (si prolongement et proximité)',
    explanation:
        'Le cours cite plusieurs dépendances : garage, balcon, terrasse… sous condition de proximité et prolongement.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Box fermé non attenant',
    question: 'Selon le cours, a pu être assimilé à un domicile :',
    options: [
      'Un box fermé non attenant (jurisprudence citée)',
      'Un casier de consigne de gare',
      'Un bloc opératoire',
    ],
    answer: 'Un box fermé non attenant (jurisprudence citée)',
    explanation:
        'Le cours cite la jurisprudence assimilant un box fermé non attenant au domicile.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Non-domicile (cour non close)',
    question: 'Selon le cours, n’est pas considéré comme domicile :',
    options: [
      'La cour d’un immeuble lorsqu’elle n’est pas close',
      'Un logement occupé pacifiquement',
      'Une chambre d’hôtel',
    ],
    answer: 'La cour d’un immeuble lorsqu’elle n’est pas close',
    explanation:
        'Le cours liste la cour non close parmi les lieux non considérés comme domicile.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Non-domicile (casier de consigne)',
    question: 'Selon le cours, n’est pas un domicile :',
    options: [
      'Le casier d’une consigne de gare',
      'Un véhicule aménagé pour l’habitation',
      'Un yacht habitable',
    ],
    answer: 'Le casier d’une consigne de gare',
    explanation:
        'Le cours cite le casier de consigne de gare parmi les lieux non considérés comme domicile.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Non-domicile (local réservé à la vente)',
    question: 'Selon le cours, n’est pas considéré comme domicile :',
    options: [
      'Le local réservé à la vente',
      'Une chambre d’hôtel',
      'Une péniche habitable',
    ],
    answer: 'Le local réservé à la vente',
    explanation:
        'Le cours liste le local réservé à la vente parmi les lieux non considérés comme domicile.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Introduction (ruse)',
    question: 'Selon le cours, entrer grâce à une ruse est un exemple de :',
    options: ['Manœuvres', 'Menaces', 'Voies de fait uniquement'],
    answer: 'Manœuvres',
    explanation:
        'Le cours définit les manœuvres comme procédés astucieux ou ruses.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Correspondances électroniques — Exemple (radio police)',
    question:
        'Selon le cours (jurisprudence citée), peut constituer une interception :',
    options: [
      'Capter les échanges radio entre patrouilles de police',
      'Lire un journal',
      'Recevoir un appel volontairement',
    ],
    answer: 'Capter les échanges radio entre patrouilles de police',
    explanation:
        'Le cours cite une jurisprudence : capter les échanges radio de patrouilles = interception.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Exemple (employeur et mails)',
    question:
        'Selon le cours (jurisprudence citée), peut constituer un détournement :',
    options: [
      'Accéder aux courriers électroniques d’un salarié avant qu’il en ait eu connaissance',
      'Lire un mail ouvert par son auteur',
      'Recevoir un mail en copie',
    ],
    answer:
        'Accéder aux courriers électroniques d’un salarié avant qu’il en ait eu connaissance',
    explanation:
        'Le cours cite une jurisprudence où l’employeur accède aux mails du salarié non encore appréhendés = détournement.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Correspondances électroniques — Courrier électronique (définition LCEN)',
    question:
        'Selon le cours, le courrier électronique est un message stocké :',
    options: [
      'Sur un serveur ou dans l’équipement terminal du destinataire jusqu’à récupération',
      'Uniquement sur papier',
      'Uniquement dans la mémoire du clavier',
    ],
    answer:
        'Sur un serveur ou dans l’équipement terminal du destinataire jusqu’à récupération',
    explanation:
        'Le cours reprend la définition LCEN : message stocké sur serveur/terminal jusqu’à récupération par le destinataire.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Correspondances électroniques — Installation (logiciel/matériel)',
    question: 'Selon le cours, “procéder à l’installation d’appareils” vise :',
    options: [
      'Mettre en œuvre un dispositif ou utiliser des matériels/logiciels permettant l’interception/détournement/utilisation/divulgation',
      'Installer une imprimante',
      'Mettre une sonnerie',
    ],
    answer:
        'Mettre en œuvre un dispositif ou utiliser des matériels/logiciels permettant l’interception/détournement/utilisation/divulgation',
    explanation:
        'Le cours précise que l’installation vise tout dispositif ou logiciel permettant ces atteintes.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Intention de nuire',
    question:
        'Selon le cours, pour 226-15 (voie électronique), l’intention de nuire :',
    options: [
      'N’est pas exigée',
      'Est obligatoire',
      'Transforme l’infraction en crime',
    ],
    answer: 'N’est pas exigée',
    explanation:
        'Le cours indique que l’intention de nuire n’est pas exigée (mobile indifférent).',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Erreur/méprise',
    question:
        'Selon le cours, violer une correspondance électronique par méprise :',
    options: [
      'Ne caractérise pas l’infraction faute d’intention coupable',
      'Constitue toujours l’infraction',
      'Constitue automatiquement un chantage',
    ],
    answer: 'Ne caractérise pas l’infraction faute d’intention coupable',
    explanation:
        'Le cours précise : par méprise/erreur → pas d’infraction, faute de mauvaise foi.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Atteinte à la représentation — Blogs/profils sans image',
    question:
        'Selon le cours (jurisprudence citée), créer un blog/profil au nom d’un tiers sans recourir à parole/image/montage :',
    options: [
      'Ne relève pas de l’article 226-8',
      'Relève automatiquement de 226-8',
      'Relève automatiquement de 226-4',
    ],
    answer: 'Ne relève pas de l’article 226-8',
    explanation:
        'Le cours cite une jurisprudence : sans montage utilisant parole ou image, 226-8 ne s’applique pas.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Montage (ajout/retrait)',
    question:
        'Selon le cours (jurisprudence citée), le montage réprimé est celui qui déforme délibérément par :',
    options: [
      'Ajout ou retrait d’éléments étrangers à son objet',
      'Simple compression vidéo',
      'Changement de luminosité',
    ],
    answer: 'Ajout ou retrait d’éléments étrangers à son objet',
    explanation:
        'Le cours cite une jurisprudence : montage déformant par ajout/retrait d’éléments étrangers.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Voix',
    question: 'Selon le cours, un montage peut porter sur :',
    options: [
      'La voix reproduite à l’identique par imitation ou déformée',
      'Uniquement une photo de paysage',
      'Uniquement un texte',
    ],
    answer: 'La voix reproduite à l’identique par imitation ou déformée',
    explanation:
        'Le cours précise que le montage peut porter sur la voix (imitation/déformation).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Consentement (publication)',
    question:
        'Selon le cours, le consentement exigé par 226-8 porte principalement sur :',
    options: [
      'La publication/révélation à un tiers',
      'La création technique du montage seulement',
      'Le choix de la musique',
    ],
    answer: 'La publication/révélation à un tiers',
    explanation:
        'Le cours indique : consentement sur la publication/révélation, pas seulement sur la création.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Contenu algorithmique assimilé',
    question: 'Selon le cours, est assimilé à 226-8 le fait de diffuser :',
    options: [
      'Un contenu visuel/sonore généré par traitement algorithmique représentant l’image/paroles d’une personne sans consentement et sans mention/évidence',
      'Une photo authentique avec accord',
      'Un dessin abstrait',
    ],
    answer:
        'Un contenu visuel/sonore généré par traitement algorithmique représentant l’image/paroles d’une personne sans consentement et sans mention/évidence',
    explanation:
        'Le cours indique l’assimilation des deepfakes (contenu généré algorithmiquement) à l’infraction.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Atteinte à la vie privée — Procédé quelconque',
    question:
        'Selon le cours, les atteintes à la vie privée peuvent être commises :',
    options: [
      'Au moyen d’un procédé quelconque (technique ou non)',
      'Uniquement avec un appareil high-tech',
      'Uniquement avec une caméra',
    ],
    answer: 'Au moyen d’un procédé quelconque (technique ou non)',
    explanation:
        'Le cours précise que toutes les méthodes sont visées, même sans appareil.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Captation (paroles)',
    question: 'Selon le cours, la captation vise notamment :',
    options: [
      'L’audition grâce à des moyens techniques appropriés (ex : conversations téléphoniques)',
      'Le fait d’entendre naturellement dans la rue',
      'Le fait de lire un article',
    ],
    answer:
        'L’audition grâce à des moyens techniques appropriés (ex : conversations téléphoniques)',
    explanation:
        'Le cours évoque l’audition au moyen de techniques (captation) notamment sur conversations téléphoniques.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Transmission (paroles)',
    question: 'Selon le cours, la transmission des paroles vise :',
    options: [
      'Tout moyen mettant à disposition des paroles indûment captées à un ou plusieurs destinataires avertis',
      'Uniquement un envoi postal',
      'Uniquement une diffusion TV',
    ],
    answer:
        'Tout moyen mettant à disposition des paroles indûment captées à un ou plusieurs destinataires avertis',
    explanation:
        'Le cours définit la transmission comme mise à disposition des paroles captées à des destinataires avertis.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Images (lieu privé)',
    question:
        'Selon le cours, l’incrimination de l’image (226-1) exige que la personne soit :',
    options: [
      'Dans un lieu privé',
      'Dans un lieu public uniquement',
      'Dans un tribunal uniquement',
    ],
    answer: 'Dans un lieu privé',
    explanation:
        'Le cours précise que la fixation/enregistrement/transmission de l’image est réprimée si la personne se trouve dans un lieu privé.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Atteinte à la vie privée — Image d’un lieu vs image d’une personne',
    question: 'Selon le cours, est exclue de 226-1 (image) :',
    options: [
      'La photographie du lieu de vie ou de biens (sans viser l’image d’une personne)',
      'La photo d’une personne dans un lieu privé',
      'La vidéo d’une personne dans un lieu privé',
    ],
    answer:
        'La photographie du lieu de vie ou de biens (sans viser l’image d’une personne)',
    explanation:
        'Le cours indique que la photo du lieu ou des biens est exclue : l’infraction vise l’image de la personne.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Atteinte à la vie privée — Lieu privé (exemples jurisprudentiels)',
    question: 'Selon le cours, ont pu être considérés comme lieux privés :',
    options: [
      'Une chambre d’hôpital, une prison, un commissariat',
      'Une place publique',
      'Un marché en plein air',
    ],
    answer: 'Une chambre d’hôpital, une prison, un commissariat',
    explanation:
        'Le cours cite ces exemples de lieux privés reconnus par la jurisprudence.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Pornodivulgation — Notion',
    question: 'Selon le cours, la pornodivulgation consiste à :',
    options: [
      'Diffuser sans consentement un contenu intime obtenu avec consentement initial',
      'Filmer sans consentement dans un lieu privé',
      'Ouvrir une lettre',
    ],
    answer:
        'Diffuser sans consentement un contenu intime obtenu avec consentement initial',
    explanation:
        'Le cours définit la pornodivulgation : obtention consentie, diffusion non consentie.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — “Sexting”',
    question:
        'Selon le cours, le “sexting” peut relever de la pornodivulgation s’il s’agit :',
    options: [
      'D’échanges de messages à caractère érotique/pornographique diffusés sans accord',
      'De messages professionnels',
      'De messages météo',
    ],
    answer:
        'D’échanges de messages à caractère érotique/pornographique diffusés sans accord',
    explanation:
        'Le cours cite le sexting parmi les supports possibles (messages) du contenu pornodivulgué.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Plainte (mention du cours)',
    question:
        'Selon le cours, l’article 226-6 impose le dépôt d’une plainte notamment car :',
    options: [
      'La déclaration de la victime sur l’absence d’accord donne corps au délit',
      'La diffusion est toujours publique',
      'Le contenu doit être vendu',
    ],
    answer:
        'La déclaration de la victime sur l’absence d’accord donne corps au délit',
    explanation:
        'Le cours explique que l’accord de diffusion doit être prouvé par l’auteur, et la déclaration de la victime peut suffire, d’où l’exigence de plainte évoquée.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Secret professionnel — Dépositaire (mission temporaire)',
    question:
        'Selon le cours, peut être dépositaire d’un secret en raison d’une mission temporaire :',
    options: [
      'Un expert, un juré, un membre assesseur (exemples cités)',
      'Un client du professionnel',
      'Un inconnu',
    ],
    answer: 'Un expert, un juré, un membre assesseur (exemples cités)',
    explanation:
        'Le cours cite les jurés, experts, membres assesseurs comme exemples de mission temporaire.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Forme de la révélation',
    question: 'Selon le cours, la forme de la révélation :',
    options: [
      'Importe peu (parole ou transmission d’un document)',
      'Doit être forcément écrite',
      'Doit être forcément publique',
    ],
    answer: 'Importe peu (parole ou transmission d’un document)',
    explanation:
        'Le cours précise que la révélation peut se faire par la parole ou un document ; la forme importe peu.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret professionnel — Mobile',
    question: 'Selon le cours, pour 226-13, le mobile (raison de révéler) :',
    options: ['Importe peu', 'Doit être un profit', 'Doit être une vengeance'],
    answer: 'Importe peu',
    explanation:
        'Le cours précise que l’intention de nuire n’est pas requise et le mobile importe peu.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Secret des correspondances — Correspondance (définition)',
    question: 'Selon le cours, une “correspondance” est :',
    options: [
      'Un message quel qu’en soit le support, ayant vocation à circuler',
      'Uniquement une lettre d’amour',
      'Uniquement un colis',
    ],
    answer: 'Un message quel qu’en soit le support, ayant vocation à circuler',
    explanation:
        'Le cours indique que la correspondance est un message quel que soit le support, dès lors qu’il a vocation à circuler.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Nature (privée/pro)',
    question: 'Selon le cours, une correspondance peut être :',
    options: [
      'Privée ou professionnelle',
      'Uniquement privée',
      'Uniquement administrative',
    ],
    answer: 'Privée ou professionnelle',
    explanation:
        'Le cours précise que la nature de la correspondance (privée ou pro) importe peu.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Message à destination d’un tiers',
    question: 'Selon le cours, pour 226-15, la correspondance doit être :',
    options: [
      'À destination d’un tiers (on ne viole pas sa propre correspondance)',
      'À destination de soi-même',
      'Un message public',
    ],
    answer:
        'À destination d’un tiers (on ne viole pas sa propre correspondance)',
    explanation:
        'Le cours indique que l’auteur s’en prend à un message adressé à autrui.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Mode d’acheminement',
    question: 'Selon le cours, le mode d’acheminement de la correspondance :',
    options: [
      'Est indifférent (La Poste, coursier, etc.)',
      'Doit être La Poste uniquement',
      'Doit être un huissier',
    ],
    answer: 'Est indifférent (La Poste, coursier, etc.)',
    explanation: 'Le cours précise que le mode d’acheminement importe peu.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Arrivée ou non',
    question: 'Selon le cours, l’atteinte peut se produire :',
    options: [
      'Alors que la correspondance n’est pas encore ou n’est plus acheminée',
      'Uniquement pendant le transport',
      'Uniquement après remise en main propre',
    ],
    answer:
        'Alors que la correspondance n’est pas encore ou n’est plus acheminée',
    explanation:
        'Le cours précise : “arrivées ou non à destination” (peut être avant/pendant/après acheminement).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances — Erreur',
    question:
        'Selon le cours, ouvrir/détourner une correspondance par erreur :',
    options: [
      'Ne constitue pas l’infraction (négligence/imprudence, intention coupable fait défaut)',
      'Constitue toujours l’infraction',
      'Constitue automatiquement une tentative',
    ],
    answer:
        'Ne constitue pas l’infraction (négligence/imprudence, intention coupable fait défaut)',
    explanation:
        'Le cours précise que par erreur, l’infraction n’est pas constituée faute d’intention.',
    difficulty: 'Moyenne',
  ),
  // =========================================================
  // PACK 50 QUESTIONS (12/50)
  // =========================================================
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Caractère spontané',
    question:
        'Selon le cours, la jurisprudence exige que la dénonciation ait un caractère :',
    options: [
      'Spontané (initiative personnelle du dénonciateur)',
      'Automatique dès qu’il y a un écrit',
      'Toujours provoqué par l’autorité',
    ],
    answer: 'Spontané (initiative personnelle du dénonciateur)',
    explanation:
        'Le cours indique que la dénonciation calomnieuse suppose une initiative personnelle : caractère spontané.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Réponse à interpellation',
    question:
        'Selon le cours, révéler des faits (même faux) en réponse à une interpellation d’un supérieur/autorité :',
    options: [
      'Ne constitue pas une dénonciation calomnieuse faute de spontanéité',
      'Constitue toujours une dénonciation calomnieuse',
      'Constitue automatiquement une diffamation publique',
    ],
    answer:
        'Ne constitue pas une dénonciation calomnieuse faute de spontanéité',
    explanation:
        'Le cours précise que la dénonciation perd son caractère spontané lorsqu’elle est provoquée (réponse à une demande).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Rapport demandé par supérieur',
    question:
        'Selon le cours, un rapport/compte rendu établi sur demande d’un supérieur :',
    options: [
      'Perd le caractère spontané (pas 226-10 en principe)',
      'Est automatiquement 226-10',
      'Est toujours un faux',
    ],
    answer: 'Perd le caractère spontané (pas 226-10 en principe)',
    explanation:
        'Le cours cite les rapports établis sur demande d’un supérieur comme exemple de dénonciation provoquée (non spontanée).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Réponses au magistrat instructeur',
    question:
        'Selon le cours (jurisprudence citée), des dénonciations contenues dans des réponses aux questions d’un magistrat instructeur :',
    options: [
      'Perdent le caractère spontané',
      'Sont toujours spontanées',
      'Ne peuvent jamais être produites',
    ],
    answer: 'Perdent le caractère spontané',
    explanation:
        'Le cours cite la jurisprudence : réponses aux questions d’un magistrat instructeur → dénonciation provoquée, donc non spontanée.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Défense du prévenu',
    question:
        'Selon le cours (jurisprudence citée), la dénonciation faite par un prévenu :',
    options: [
      'N’est pas calomnieuse si elle se rattache étroitement à sa défense',
      'Est toujours calomnieuse',
      'Est toujours une fausse accusation',
    ],
    answer:
        'N’est pas calomnieuse si elle se rattache étroitement à sa défense',
    explanation:
        'Le cours cite la jurisprudence : dénonciation liée étroitement à la défense du prévenu → perd spontanéité au sens 226-10.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Dénonciation préjudiciable',
    question:
        'Selon le cours, la dénonciation doit être “préjudiciable” car le fait dénoncé doit être :',
    options: [
      'De nature à entraîner des sanctions',
      'Forcément déjà sanctionné',
      'Toujours prescrit',
    ],
    answer: 'De nature à entraîner des sanctions',
    explanation:
        'Le cours lie l’exigence de préjudice au fait que la dénonciation doit être de nature à entraîner des sanctions.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Sanction effective',
    question: 'Selon le cours, pour 226-10, il faut une sanction effective :',
    options: [
      'Non, peu importe qu’il y ait eu sanction effective',
      'Oui, sinon pas d’infraction',
      'Oui, seulement une sanction pénale',
    ],
    answer: 'Non, peu importe qu’il y ait eu sanction effective',
    explanation:
        'Le cours précise que la dénonciation doit être “de nature à” entraîner des sanctions, même sans sanction effective.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Prescription/amnistie/décès',
    question:
        'Selon le cours, l’infraction peut être constituée même si l’éventualité de sanction est écartée par :',
    options: [
      'Prescription, immunité familiale, amnistie ou décès',
      'Le mauvais temps',
      'La fatigue du juge',
    ],
    answer: 'Prescription, immunité familiale, amnistie ou décès',
    explanation:
        'Le cours indique que ces causes n’empêchent pas la constitution de l’infraction : le fait reste “de nature à” entraîner des sanctions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Fausseté automatique (loi 2010)',
    question:
        'Selon le cours, depuis la modification (loi 2010), la fausseté résulte nécessairement d’une décision définitive de :',
    options: [
      'Relaxе, acquittement ou non-lieu constatant expressément que le fait n’a pas été commis ou n’est pas imputable',
      'Classement sans suite simple',
      'Médiation',
    ],
    answer:
        'Relaxе, acquittement ou non-lieu constatant expressément que le fait n’a pas été commis ou n’est pas imputable',
    explanation:
        'Le cours précise que seules ces décisions définitives, constatant expressément absence de fait/imputabilité, établissent automatiquement la fausseté.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Faute de charges suffisantes',
    question:
        'Selon le cours, si la décision définitive est rendue “faute de charges suffisantes”, alors :',
    options: [
      'Le tribunal saisi apprécie la pertinence des accusations',
      'La fausseté est automatique',
      'La dénonciation est toujours vraie',
    ],
    answer: 'Le tribunal saisi apprécie la pertinence des accusations',
    explanation:
        'Le cours précise que si relaxe/non-lieu/acquittement est fondé sur insuffisance de charges, la fausseté n’est pas automatique : le tribunal apprécie.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Violation de domicile — Formes de l’infraction',
    question: 'Selon le cours, la violation de domicile vise :',
    options: [
      'L’introduction illégitime ET le maintien après cette introduction',
      'Uniquement l’introduction',
      'Uniquement le maintien si violence',
    ],
    answer: 'L’introduction illégitime ET le maintien après cette introduction',
    explanation:
        'Le cours précise que l’introduction et le maintien à l’issue de l’entrée illégitime constituent l’infraction.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Introduction (moyens)',
    question:
        'Selon le cours (226-4), l’introduction doit être réalisée à l’aide de :',
    options: [
      'Manœuvres, menaces, voies de fait ou contrainte',
      'Une invitation',
      'Un badge de visiteur',
    ],
    answer: 'Manœuvres, menaces, voies de fait ou contrainte',
    explanation:
        'Le cours énumère les 4 moyens : manœuvres, menaces, voies de fait, contrainte.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Contrainte (définition)',
    question: 'Selon le cours, la contrainte correspond à :',
    options: [
      'Toute situation où le consentement de l’occupant n’est pas libre',
      'Un simple retard',
      'Une discussion',
    ],
    answer: 'Toute situation où le consentement de l’occupant n’est pas libre',
    explanation:
        'Le cours définit la contrainte comme toute situation où le consentement n’est pas libre.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Infraction continue',
    question: 'Selon le cours, la violation de domicile est une infraction :',
    options: [
      'Continue (tant que l’occupation illicite perdure)',
      'Instantanée uniquement',
      'Non punissable en flagrance',
    ],
    answer: 'Continue (tant que l’occupation illicite perdure)',
    explanation:
        'Le cours précise que le délit est continu : la flagrance peut durer tant que le maintien se poursuit.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Enquête de flagrance',
    question: 'Selon le cours, une enquête de flagrance est possible :',
    options: [
      'Tant que perdure l’occupation illicite (infraction continue)',
      'Uniquement le jour de l’entrée',
      'Uniquement si la porte est cassée',
    ],
    answer: 'Tant que perdure l’occupation illicite (infraction continue)',
    explanation:
        'Le cours indique que la flagrance est possible tant que se poursuit l’occupation (délit continu).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Maintien (tiers arrivé après)',
    question:
        'Selon le cours, peuvent être poursuivies des personnes venues ensuite demeurer dans le lieu si :',
    options: [
      'Elles ont profité de l’entrée illicite d’un tiers en connaissance de cause',
      'Elles étaient de passage',
      'Elles ont appelé la police',
    ],
    answer:
        'Elles ont profité de l’entrée illicite d’un tiers en connaissance de cause',
    explanation:
        'Le cours précise que le maintien peut viser ceux qui profitent de l’entrée illicite commise par un tiers, s’ils agissent en connaissance de cause.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Hors les cas où la loi le permet',
    question:
        'Selon le cours, l’introduction n’est infraction que “hors les cas où la loi le permet”, par exemple :',
    options: [
      'Assistance à personne en péril, incendie/inondation, réclamation de l’intérieur',
      'Visite de courtoisie',
      'Curiosité',
    ],
    answer:
        'Assistance à personne en péril, incendie/inondation, réclamation de l’intérieur',
    explanation:
        'Le cours cite des cas d’introduction légitime : appel au secours, incendie/inondation, assistance à personne en péril.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Réclamation de l’intérieur',
    question:
        'Selon le cours, une réclamation faite de l’intérieur (cris/hurlements) :',
    options: [
      'Justifie l’introduction même si l’appel s’avère fantaisiste',
      'Ne justifie jamais l’entrée',
      'Justifie seulement si plainte écrite',
    ],
    answer: 'Justifie l’introduction même si l’appel s’avère fantaisiste',
    explanation:
        'Le cours précise que l’introduction est justifiée même si l’appel au secours s’avère fantaisiste.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Violation de domicile — Assistance à personne en péril (indices)',
    question:
        'Selon le cours, l’introduction est justifiée si des indices incitent à croire qu’une personne est gravement en péril :',
    options: [
      'Oui (appel sans réponse, odeur suspecte, absence anormale, etc.)',
      'Non, jamais',
      'Oui seulement de nuit',
    ],
    answer: 'Oui (appel sans réponse, odeur suspecte, absence anormale, etc.)',
    explanation:
        'Le cours évoque des indices (appel sans réponse, odeur suspecte, absence anormale) justifiant l’entrée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Élément moral',
    question: 'Selon le cours, l’élément moral implique :',
    options: [
      'Volonté de s’introduire/se maintenir au su/contre le gré + conscience d’agir hors les cas prévus par la loi',
      'Une simple maladresse',
      'Une intention de nuire obligatoire',
    ],
    answer:
        'Volonté de s’introduire/se maintenir au su/contre le gré + conscience d’agir hors les cas prévus par la loi',
    explanation:
        'Le cours précise : volonté d’entrer/maintenir contre le gré + conscience d’être en dehors des cas légaux.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Correspondances électroniques — Fondement (définition)',
    question:
        'La violation des correspondances émises par voie électronique est définie par :',
    options: [
      'L’article 226-15 alinéa 2 du Code pénal',
      'L’article 226-15 alinéa 1 du Code pénal',
      'L’article 226-13 du Code pénal',
    ],
    answer: 'L’article 226-15 alinéa 2 du Code pénal',
    explanation:
        'Le cours indique que l’article 226-15 al.2 définit l’infraction pour les correspondances électroniques.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Fondement (répression)',
    question:
        'La répression de la violation des correspondances (voie électronique) est prévue par :',
    options: [
      'L’article 226-15 alinéa 1 du Code pénal',
      'L’article 226-8 du Code pénal',
      'L’article 226-2-1 du Code pénal',
    ],
    answer: 'L’article 226-15 alinéa 1 du Code pénal',
    explanation:
        'Le cours précise : al.2 définit l’infraction, al.1 prévoit la répression.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Actes matériels (liste)',
    question: 'Selon le cours (226-15 al.2), les actes matériels sont :',
    options: [
      'Intercepter, détourner, utiliser, divulguer, ou installer des appareils permettant ces interceptions',
      'Écrire un mail',
      'Archiver un mail lu',
    ],
    answer:
        'Intercepter, détourner, utiliser, divulguer, ou installer des appareils permettant ces interceptions',
    explanation:
        'Le cours liste : intercepter/détourner/utiliser/divulguer + installation d’appareils.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Utiliser (exemple)',
    question:
        'Selon le cours, “utiliser” une correspondance électronique peut viser :',
    options: [
      'Effacer un mail dont on n’est pas destinataire sans l’avoir ouvert, ou le transférer à un tiers',
      'Recevoir un mail en CC',
      'Répondre à un mail reçu',
    ],
    answer:
        'Effacer un mail dont on n’est pas destinataire sans l’avoir ouvert, ou le transférer à un tiers',
    explanation:
        'Le cours donne ces exemples d’“utiliser” : effacer ou transférer un message sans qualité pour en connaître.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Divulguer (définition)',
    question: 'Selon le cours, “divulguer” suppose :',
    options: [
      'Révéler à un tiers le contenu d’une correspondance non destinée à l’auteur',
      'Simplement recevoir un mail',
      'Changer un mot de passe',
    ],
    answer:
        'Révéler à un tiers le contenu d’une correspondance non destinée à l’auteur',
    explanation:
        'Le cours précise que divulguer = révéler à un tiers le contenu d’une correspondance qui ne lui est pas destinée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Mauvaise foi (définition)',
    question: 'Selon le cours, la “mauvaise foi” est définie comme :',
    options: [
      'La connaissance que les lettres ne lui étaient pas destinées',
      'Le fait d’être pressé',
      'Le fait d’oublier son mot de passe',
    ],
    answer: 'La connaissance que les lettres ne lui étaient pas destinées',
    explanation:
        'Le cours cite une définition jurisprudentielle : la mauvaise foi = connaissance que ce n’était pas destiné à lui.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Correspondances électroniques — Circonstance aggravante',
    question:
        'Selon le cours, 226-15 al.3 aggrave l’infraction lorsque les faits sont commis par :',
    options: [
      'Le conjoint, concubin ou partenaire lié par PACS',
      'Un inconnu',
      'Un collègue seulement',
    ],
    answer: 'Le conjoint, concubin ou partenaire lié par PACS',
    explanation:
        'Le cours mentionne l’aggravation à l’alinéa 3 en cas de conjoint/concubin/PACS.',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Atteinte à la représentation — Aggravation “en ligne”',
    question:
        'Selon le cours, 226-8 al.2 prévoit une circonstance aggravante lorsque les faits sont réalisés :',
    options: [
      'En utilisant un service de communication au public en ligne',
      'Uniquement par affichage papier',
      'Uniquement en privé',
    ],
    answer: 'En utilisant un service de communication au public en ligne',
    explanation:
        'Le cours indique l’aggravation à 226-8 al.2 lorsque le montage/deepfake est diffusé via un service de communication au public en ligne.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Peines (simple)',
    question:
        'Selon le cours, la peine principale (simple) de 226-8 al.1 est :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '2 ans d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation:
        'Le tableau de répression du cours indique : 226-8 al.1 = 1 an + 15 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Peines (aggravée)',
    question:
        'Selon le cours, la peine principale (aggravée) de 226-8 al.2 est :',
    options: [
      '2 ans d’emprisonnement et 45 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 226-8 al.2 (aggravée) = 2 ans + 45 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Tentative',
    question: 'Selon le cours, la tentative de 226-8 est :',
    options: [
      'Punissable (prévue par 226-5)',
      'Non punissable',
      'Punissable uniquement si mineur',
    ],
    answer: 'Punissable (prévue par 226-5)',
    explanation: 'Le cours mentionne que la tentative est prévue par 226-5.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Personnes morales',
    question:
        'Selon le cours, la responsabilité pénale des personnes morales en matière de 226-8 est prévue par :',
    options: [
      'Les articles 226-7 et 226-9 du Code pénal',
      'L’article 226-12 du Code pénal',
      'L’article 226-5 du Code pénal',
    ],
    answer: 'Les articles 226-7 et 226-9 du Code pénal',
    explanation:
        'Le cours indique que 226-7 et 226-9 prévoient la responsabilité pénale des personnes morales pour 226-8.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Atteinte à la vie privée — Localisation (nouveau type)',
    question: 'Selon le cours, l’atteinte à la vie privée inclut désormais :',
    options: [
      'La captation/enregistrement/transmission de la localisation en temps réel ou différé sans consentement',
      'Le simple fait de demander une adresse',
      'Le fait de regarder une carte',
    ],
    answer:
        'La captation/enregistrement/transmission de la localisation en temps réel ou différé sans consentement',
    explanation:
        'Le cours mentionne la localisation en temps réel ou différé comme modalité d’atteinte (sans consentement).',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category:
        'Atteinte à la vie privée — Localisation (pas de consentement présumé)',
    question:
        'Selon le cours, la présomption de consentement “au vu et au su” :',
    options: [
      'Ne s’applique pas à la localisation (souvent clandestine)',
      'S’applique toujours à la localisation',
      'S’applique seulement la nuit',
    ],
    answer: 'Ne s’applique pas à la localisation (souvent clandestine)',
    explanation:
        'Le cours précise que la présomption de consentement ne vaut pas pour la localisation (installation facilement clandestine).',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Localisation (moyens techniques)',
    question:
        'Selon le cours, la captation de localisation peut se faire via :',
    options: [
      'Balise clandestine ou logiciel espion sur mobile (exemples cités)',
      'Carte postale',
      'Affiche publicitaire',
    ],
    answer: 'Balise clandestine ou logiciel espion sur mobile (exemples cités)',
    explanation:
        'Le cours cite la balise et le logiciel espion comme exemples de captation de localisation.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Localisation (niveau de précision)',
    question:
        'Selon le cours, le niveau de précision de la localisation (GPS ou zone relais) :',
    options: [
      'Importe peu',
      'Doit être GPS uniquement',
      'Doit être exact au mètre',
    ],
    answer: 'Importe peu',
    explanation:
        'Le cours indique que la précision importe peu (zone relais ou GPS).',
    difficulty: 'Facile',
  ),

  QuizQuestion(
    category: 'Violation de domicile — Propagande “mode d’emploi squat”',
    question: 'Selon le cours, l’article 226-4-2-1 incrimine :',
    options: [
      'La propagande ou publicité en faveur de méthodes facilitant/incitant la violation de domicile ou l’occupation frauduleuse',
      'Le simple fait de déménager',
      'Le fait de fermer une porte',
    ],
    answer:
        'La propagande ou publicité en faveur de méthodes facilitant/incitant la violation de domicile ou l’occupation frauduleuse',
    explanation:
        'Le cours décrit ce délit visant notamment les “modes d’emploi du squat” diffusés sur réseaux sociaux.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Propagande (peine)',
    question:
        'Selon le cours, la propagande/publicité visée par 226-4-2-1 est sanctionnée d’une amende de :',
    options: ['3 750 €', '15 000 €', '45 000 €'],
    answer: '3 750 €',
    explanation: 'Le cours indique une amende de 3 750 euros pour 226-4-2-1.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Peine (226-4)',
    question: 'Selon le cours, la violation de domicile (226-4) est punie de :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le cours indique : 226-4 = 3 ans + 45 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Tentative',
    question:
        'Selon le cours, la tentative de violation de domicile (226-4) est :',
    options: [
      'Punissable (prévue à 226-5)',
      'Non punissable',
      'Punissable seulement en récidive',
    ],
    answer: 'Punissable (prévue à 226-5)',
    explanation: 'Le cours précise : tentative prévue par 226-5.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Complicité',
    question: 'Selon le cours, la complicité de violation de domicile :',
    options: [
      'Est punissable (règles générales)',
      'N’est jamais punissable',
      'Est punissable uniquement si violence',
    ],
    answer: 'Est punissable (règles générales)',
    explanation: 'Le cours indique : complicité = oui, règles générales.',
    difficulty: 'Facile',
  ),
  // =========================================================
  // PACK 50 QUESTIONS (13/50)
  // =========================================================
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Élément légal',
    question: 'La dénonciation calomnieuse est définie et réprimée par :',
    options: [
      'L’article 226-10 du Code pénal',
      'L’article 226-13 du Code pénal',
      'L’article 226-4 du Code pénal',
    ],
    answer: 'L’article 226-10 du Code pénal',
    explanation:
        'Le cours précise expressément : 226-10 définit et réprime la dénonciation calomnieuse.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category:
        'Dénonciation calomnieuse — Plainte avec constitution de partie civile',
    question: 'Selon le cours, une dénonciation écrite peut prendre la forme :',
    options: [
      'D’une plainte avec ou sans constitution de partie civile',
      'Uniquement d’un SMS',
      'Uniquement d’un appel anonyme',
    ],
    answer: 'D’une plainte avec ou sans constitution de partie civile',
    explanation:
        'Le cours cite la plainte (avec ou sans constitution de partie civile) parmi les formes écrites possibles.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Dénonciation orale',
    question: 'Selon le cours, la dénonciation orale peut être faite :',
    options: [
      'De vive voix ou par téléphone (et doit pouvoir être prouvée)',
      'Uniquement par message vocal WhatsApp',
      'Uniquement par visio',
    ],
    answer: 'De vive voix ou par téléphone (et doit pouvoir être prouvée)',
    explanation:
        'Le cours précise que la dénonciation orale est possible, mais doit être prouvée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Agent sur instruction hiérarchique',
    question:
        'Selon le cours, l’auteur agissant sur instructions hiérarchiques ne peut être poursuivi que :',
    options: [
      'S’il y a pris part personnellement (au-delà d’un rôle purement matériel)',
      'Même s’il n’a fait qu’exécuter sans comprendre',
      'Jamais',
    ],
    answer:
        'S’il y a pris part personnellement (au-delà d’un rôle purement matériel)',
    explanation:
        'Le cours distingue participation personnelle vs rôle purement matériel.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Destinataires possibles',
    question: 'Selon le cours (226-10), un destinataire possible est :',
    options: [
      'Une autorité pouvant donner suite ou saisir l’autorité compétente',
      'Un ami de la victime',
      'Un influenceur',
    ],
    answer: 'Une autorité pouvant donner suite ou saisir l’autorité compétente',
    explanation:
        'Le cours vise les autorités ayant pouvoir de donner suite ou de saisir l’autorité compétente.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Officiers de police administrative',
    question:
        'Selon le cours, peuvent être destinataires en tant qu’officiers de police administrative :',
    options: [
      'Notaires, huissiers, préfets, recteurs (exemples cités)',
      'Uniquement des policiers',
      'Uniquement des avocats',
    ],
    answer: 'Notaires, huissiers, préfets, recteurs (exemples cités)',
    explanation:
        'Le cours donne ces exemples d’officiers de police administrative.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category:
        'Dénonciation calomnieuse — Officiers de police judiciaire (exemples)',
    question:
        'Selon le cours, peuvent être destinataires en tant qu’officiers de police judiciaire :',
    options: [
      'Maires et adjoints, policiers, gendarmes (exemples cités)',
      'Uniquement des notaires',
      'Uniquement des médecins',
    ],
    answer: 'Maires et adjoints, policiers, gendarmes (exemples cités)',
    explanation:
        'Le cours cite notamment maires/adjoints, policiers, gendarmes comme destinataires possibles.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Personnes pouvant saisir',
    question:
        'Selon le cours, peut être destinataire une personne n’ayant pas le pouvoir de sanction mais pouvant saisir l’autorité compétente, par exemple :',
    options: [
      'Médecin, assistante sociale (exemples cités)',
      'Boulanger',
      'Client',
    ],
    answer: 'Médecin, assistante sociale (exemples cités)',
    explanation:
        'Le cours cite médecin/assistante sociale comme personnes pouvant saisir l’autorité compétente.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Tentative',
    question: 'Selon le cours, la tentative de dénonciation calomnieuse est :',
    options: [
      'Non punissable',
      'Punissable (226-5)',
      'Punissable seulement si diffusion en ligne',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours indique : TENTATIVE : NON pour 226-10.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Dénonciation calomnieuse — Peines (personne physique)',
    question:
        'Selon le cours, la dénonciation calomnieuse (226-10) est punie (personne physique) de :',
    options: [
      '5 ans d’emprisonnement et 45 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le tableau du cours indique : 226-10 = 5 ans + 45 000 €.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Pornodivulgation — Élément légal',
    question:
        'La diffusion sans accord d’un enregistrement/document à caractère sexuel obtenu avec consentement est prévue par :',
    options: [
      'L’article 226-2-1 alinéa 2 du Code pénal',
      'L’article 226-1 du Code pénal',
      'L’article 226-8 du Code pénal',
    ],
    answer: 'L’article 226-2-1 alinéa 2 du Code pénal',
    explanation:
        'Le cours précise : 226-2-1 al.2 définit et réprime la pornodivulgation.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Obtention consentie',
    question: 'Selon le cours, la pornodivulgation se distingue de 226-1 car :',
    options: [
      'La personne est consentante à être filmée/photographiée/enregistrée',
      'La personne est toujours filmée à son insu',
      'La personne est toujours dans un lieu public',
    ],
    answer:
        'La personne est consentante à être filmée/photographiée/enregistrée',
    explanation:
        'Le cours précise que contrairement à 226-1, la captation initiale est consentie.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Caractère sexuel',
    question: 'Selon le cours, la notion de “caractère sexuel” a été jugée :',
    options: [
      'Suffisamment claire et précise, l’appréciation relevant des juridictions',
      'Trop vague et donc supprimée',
      'Réservée aux seules images',
    ],
    answer:
        'Suffisamment claire et précise, l’appréciation relevant des juridictions',
    explanation:
        'Le cours mentionne la décision du Conseil constitutionnel : notion claire/précise, appréciation par les juridictions.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Diffusion sans accord',
    question:
        'Selon le cours, la diffusion sans accord signifie que le contenu est porté à la connaissance :',
    options: [
      'Du public ou d’un tiers sans accord de la victime',
      'Uniquement de la victime elle-même',
      'Uniquement d’un juge',
    ],
    answer: 'Du public ou d’un tiers sans accord de la victime',
    explanation:
        'Le cours précise : diffusion = connaissance du public ou d’un tiers, sans accord.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Opposition vs absence de consultation',
    question: 'Selon le cours, l’absence d’accord peut résulter :',
    options: [
      'Soit d’une opposition exprimée, soit du fait que la victime n’a pas pu s’opposer car non consultée',
      'Uniquement d’un écrit notarié',
      'Uniquement d’un message public',
    ],
    answer:
        'Soit d’une opposition exprimée, soit du fait que la victime n’a pas pu s’opposer car non consultée',
    explanation:
        'Le cours explique : diffusion sans accord si opposition ou absence de consultation permettant opposition.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Tentative',
    question: 'Selon le cours, la tentative du délit prévu à 226-2-1 est :',
    options: [
      'Punissable (prévue par 226-5)',
      'Non punissable',
      'Punissable uniquement si mineur',
    ],
    answer: 'Punissable (prévue par 226-5)',
    explanation: 'Le cours indique : tentative prévue par 226-5 pour 226-2-1.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Peines',
    question:
        'Selon le cours, la pornodivulgation (226-2-1 al.2) est punie de :',
    options: [
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '1 an d’emprisonnement et 45 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 60 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 226-2-1 al.2 = 2 ans + 60 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Pornodivulgation — Personnes morales',
    question:
        'Selon le cours, la responsabilité pénale des personnes morales pour 226-2-1 est prévue par :',
    options: [
      'L’article 226-7 du Code pénal',
      'L’article 226-12 du Code pénal',
      'L’article 226-10 du Code pénal',
    ],
    answer: 'L’article 226-7 du Code pénal',
    explanation:
        'Le cours précise : 226-7 prévoit la responsabilité pénale des personnes morales pour ce délit.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Atteinte à la vie privée — Fondement (226-1)',
    question:
        'Les atteintes à l’intimité de la vie privée (paroles/image/localisation) sont prévues par :',
    options: [
      'L’article 226-1 du Code pénal',
      'L’article 226-2 du Code pénal',
      'L’article 226-15 du Code pénal',
    ],
    answer: 'L’article 226-1 du Code pénal',
    explanation:
        'Le cours précise que 226-1 définit et réprime les atteintes à l’intimité de la vie privée.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Infraction de conséquence (226-2)',
    question:
        'La conservation, l’utilisation ou la divulgation d’un document issu d’une atteinte à la vie privée est prévue par :',
    options: [
      'L’article 226-2 du Code pénal',
      'L’article 226-1 du Code pénal',
      'L’article 226-3-1 du Code pénal',
    ],
    answer: 'L’article 226-2 du Code pénal',
    explanation:
        'Le cours indique que 226-2 réprime la conservation/diffusion/utilisation des documents/enregistrements issus de 226-1.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Localisation (inclusion 226-1)',
    question: 'Selon le cours, 226-1 vise aussi :',
    options: [
      'La captation/enregistrement/transmission de la localisation en temps réel ou différé',
      'Uniquement les images en lieu privé',
      'Uniquement les paroles confidentielles',
    ],
    answer:
        'La captation/enregistrement/transmission de la localisation en temps réel ou différé',
    explanation:
        'Le cours inclut explicitement la localisation parmi les atteintes à la vie privée.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Consentement (localisation)',
    question: 'Selon le cours, pour la localisation, la victime doit :',
    options: [
      'Avoir donné son accord (pas de présomption “au vu et au su”)',
      'Simplement ne pas s’être opposée',
      'Toujours signer un document',
    ],
    answer: 'Avoir donné son accord (pas de présomption “au vu et au su”)',
    explanation:
        'Le cours précise que la présomption de consentement ne s’applique pas à la localisation.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Atteinte à la vie privée — Enregistrement GAV (jurisprudence)',
    question:
        'Selon le cours (jurisprudence citée), enregistrer la parole ou l’image d’une personne en garde à vue :',
    options: [
      'N’échappe pas ipso facto à 226-1 (peut relever du champ)',
      'Est toujours légal',
      'Relève uniquement du droit civil',
    ],
    answer: 'N’échappe pas ipso facto à 226-1 (peut relever du champ)',
    explanation:
        'Le cours cite une jurisprudence : l’enregistrement en GAV ne sort pas automatiquement du champ de 226-1.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Violation de domicile — Élément légal',
    question:
        'La violation de domicile commise par un particulier est prévue par :',
    options: [
      'L’article 226-4 du Code pénal',
      'L’article 226-4-2-1 du Code pénal',
      'L’article 315-1 du Code pénal',
    ],
    answer: 'L’article 226-4 du Code pénal',
    explanation:
        'Le cours précise : 226-4 définit et réprime la violation de domicile.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Logements vacants non meublés',
    question:
        'Selon le cours (nota), les logements vacants non meublés ne sont pas des domiciles au sens de 226-4 et relèvent de :',
    options: [
      '315-1 et 315-2 (occupation frauduleuse)',
      '226-8 (montage)',
      '226-10 (dénonciation)',
    ],
    answer: '315-1 et 315-2 (occupation frauduleuse)',
    explanation:
        'Le cours indique que les logements vacants non meublés (ou proposés à la location) relèvent de 315-1 et 315-2.',
    difficulty: 'Difficile',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Domicile et meubles',
    question:
        'Selon le cours, la présence de meubles peut permettre d’apprécier l’existence d’un domicile si elle signale :',
    options: [
      'Une occupation effective (table, chaises, lit, canapé, électroménager, etc.)',
      'Uniquement une bicyclette',
      'Uniquement un carton de livres',
    ],
    answer:
        'Une occupation effective (table, chaises, lit, canapé, électroménager, etc.)',
    explanation:
        'Le cours indique que des meubles “signant” l’occupation effective (table/lit/électroménager) sont des indices, contrairement à vélo/carton.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Violation de domicile — Véhicule automobile',
    question: 'Selon le cours, n’est pas considéré comme domicile :',
    options: [
      'Le véhicule automobile (qui ne se trouve pas au domicile et n’est pas aménagé)',
      'La caravane habitable',
      'La péniche habitable',
    ],
    answer:
        'Le véhicule automobile (qui ne se trouve pas au domicile et n’est pas aménagé)',
    explanation:
        'Le cours cite le véhicule automobile (non aménagé/ hors domicile) parmi les lieux non considérés comme domiciles.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Secret des correspondances électroniques — Peine (simple)',
    question: 'Selon le cours, la peine (simple) pour 226-15 al.2 est :',
    options: [
      '1 an d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 45 000 € d’amende',
    explanation:
        'Le tableau du cours indique : 226-15 al.2 (simple) = 1 an + 45 000 €.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Secret des correspondances électroniques — Peine (aggravée)',
    question: 'Selon le cours, la peine (aggravée) pour 226-15 al.3 est :',
    options: [
      '2 ans d’emprisonnement et 60 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '5 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 60 000 € d’amende',
    explanation: 'Le cours indique : 226-15 al.3 = 2 ans + 60 000 €.',
    difficulty: 'Facile',
  ),
  QuizQuestion(
    category: 'Secret des correspondances électroniques — Tentative',
    question:
        'Selon le cours, la tentative de 226-15 (voie électronique) est :',
    options: [
      'Non punissable',
      'Punissable (226-5)',
      'Punissable uniquement si la victime est mineure',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours mentionne : TENTATIVE : NON pour 226-15.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Atteinte à la représentation — Diffusion et repartage',
    question:
        'Selon le cours, “porter à la connaissance du public ou d’un tiers” englobe :',
    options: [
      'Tous moyens de révéler le montage, y compris les repartages',
      'Uniquement la première publication',
      'Uniquement une projection en salle',
    ],
    answer: 'Tous moyens de révéler le montage, y compris les repartages',
    explanation:
        'Le cours indique que le dispositif permet aussi de sanctionner les personnes repartageant le contenu.',
    difficulty: 'Moyenne',
  ),
  QuizQuestion(
    category: 'Atteinte à la représentation — Presse (hiérarchie 1881)',
    question:
        'Selon le cours, en cas de voie de presse, la hiérarchie de responsabilité (loi 1881, art.42) commence par :',
    options: ['Le directeur de publication', 'L’imprimeur', 'Le distributeur'],
    answer: 'Le directeur de publication',
    explanation:
        'Le cours rappelle la hiérarchie : directeur de publication, à défaut auteur, puis imprimeur, etc.',
    difficulty: 'Difficile',
  ),

  QuizQuestion(
    category: 'Dénonciation calomnieuse — Autorité compétente',
    question: 'Selon le cours, le destinataire peut être une autorité :',
    options: [
      'Ayant le pouvoir de donner suite ou de saisir l’autorité compétente',
      'Sans aucun pouvoir ni possibilité d’action',
      'Uniquement un ami',
    ],
    answer:
        'Ayant le pouvoir de donner suite ou de saisir l’autorité compétente',
    explanation:
        'Le cours vise les autorités pouvant donner suite ou saisir l’autorité compétente.',
    difficulty: 'Moyenne',
  ),

  QuizQuestion(
    category: 'Secret professionnel — Violence au sein du couple',
    question:
        'Selon le cours (226-14), un médecin peut signaler au procureur des violences au sein du couple lorsque :',
    options: [
      'Il estime que la vie de la victime majeure est en danger immédiat et qu’elle ne peut se protéger en raison de l’emprise/contrainte morale',
      'La victime refuse et il n’y a aucun danger immédiat',
      'Le fait est ancien et sans danger',
    ],
    answer:
        'Il estime que la vie de la victime majeure est en danger immédiat et qu’elle ne peut se protéger en raison de l’emprise/contrainte morale',
    explanation:
        'Le cours mentionne cette exception spécifique (danger immédiat + impossibilité de se protéger).',
    difficulty: 'Difficile',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizAtteintePersonnalite extends StatefulWidget {
  static const String routeName =
      '/gpx/crimes_personne/quiz/atteinte_personnalite';
  final String uid;
  final String email;

  const QuizAtteintePersonnalite({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizAtteintePersonnalite> createState() =>
      _QuizAtteintePersonnaliteState();
}

class _QuizAtteintePersonnaliteState extends State<QuizAtteintePersonnalite>
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
        ? questionAtteintePersonnalite
        : questionAtteintePersonnalite
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
            'quiz_name': 'Atteinte personnalité',
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
      await _sb.from('quiz_atteinte_personnalite').insert({
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
      debugPrint('❌ quiz_atteinte_personnalite insert failed: $e');
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
