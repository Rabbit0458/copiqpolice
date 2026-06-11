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

final List<QuizQuestion> questionEnregistrementDiffusion = [
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

  // =========================================================
  // ✅ NOUVEAU BLOC — DIFFUSION / ENREGISTREMENT D’IMAGES DE VIOLENCE
  // =========================================================
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Fondement',
    question: 'La diffusion d’images de violence est incriminée par :',
    options: [
      'L’article 222-33-3 alinéa 2 du Code pénal',
      'L’article 222-33-3 alinéa 1 du Code pénal',
      'L’article 223-6 alinéa 2 du Code pénal',
    ],
    answer: 'L’article 222-33-3 alinéa 2 du Code pénal',
    explanation:
        'Le cours précise que l’art. 222-33-3 al.2 incrimine la diffusion de l’enregistrement des images des atteintes listées.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Nature juridique',
    question:
        'Le fait d’enregistrer sciemment des images de violences (happy slapping) constitue :',
    options: [
      'Un acte de complicité des infractions enregistrées',
      'Une infraction autonome sans lien avec l’infraction principale',
      'Une contravention',
    ],
    answer: 'Un acte de complicité des infractions enregistrées',
    explanation:
        'L’article 222-33-3 al.1 qualifie l’enregistrement sciemment d’images comme un acte de complicité au sens du droit commun.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Élément matériel',
    question: 'La diffusion s’entend notamment comme :',
    options: [
      'Répandre, émettre ou transmettre des images',
      'Uniquement publier sur un réseau social',
      'Uniquement filmer sur place',
    ],
    answer: 'Répandre, émettre ou transmettre des images',
    explanation:
        'Le cours retient une acception large : transmission de portable à portable, internet, prêt de l’original, copies, etc.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Auteur',
    question:
        'Pour être poursuivi pour diffusion d’images de violence, il faut être :',
    options: [
      'L’auteur de la diffusion, même si on n’a pas filmé',
      'Obligatoirement l’auteur de l’enregistrement',
      'Obligatoirement l’auteur des violences',
    ],
    answer: 'L’auteur de la diffusion, même si on n’a pas filmé',
    explanation:
        'Il n’est pas nécessaire que le diffuseur soit l’enregistreur : diffuser suffit.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Définition',
    question: 'Le “happy slapping” désigne :',
    options: [
      'L’enregistrement sciemment d’images de violences',
      'La diffusion d’images de violences uniquement',
      'Le simple fait d’assister à une scène de violences',
    ],
    answer: 'L’enregistrement sciemment d’images de violences',
    explanation:
        'Le cours qualifie l’enregistrement sciemment des images de violences comme le happy slapping.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Liste',
    question:
        'La liste des infractions dont l’enregistrement ou la diffusion d’images est visée est :',
    options: [
      'Limitative',
      'Indicative',
      'Fixée par la jurisprudence uniquement',
    ],
    answer: 'Limitative',
    explanation:
        'Le cours précise que les infractions visées par l’art. 222-33-3 sont limitativement énumérées.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Tentative',
    question: 'La tentative de diffusion d’images de violence est :',
    options: ['Non punissable', 'Punissable', 'Une contravention'],
    answer: 'Non punissable',
    explanation:
        'Le cours indique : TENTATIVE : NON pour la diffusion d’images de violence.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Complicité',
    question: 'La complicité de diffusion d’images de violence est :',
    options: [
      'Punissable',
      'Non punissable',
      'Punissable seulement si la victime est mineure',
    ],
    answer: 'Punissable',
    explanation:
        'Le cours indique : COMPLICITÉ : OUI (articles 121-6 et 121-7 du C.P.).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Répression',
    question:
        'La diffusion d’images de violence est punie (personnes physiques) de :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation:
        'Le cours indique : Délit — art. 222-33-3 al.2 — 5 ans et 75 000 €.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // MOYENNE (Compréhension / pièges)
  // =========================================================
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Champ',
    question:
        'La diffusion d’images est visée lorsqu’elle concerne des atteintes volontaires prévues notamment par :',
    options: [
      'Les articles 222-1 à 222-14-1 et 222-23 à 222-31 et 222-33',
      'Uniquement les articles 222-23 à 222-26',
      'Uniquement les violences contraventionnelles',
    ],
    answer: 'Les articles 222-1 à 222-14-1 et 222-23 à 222-31 et 222-33',
    explanation:
        'L’art. 222-33-3 vise une liste d’atteintes volontaires à l’intégrité de la personne (violences, viol, agressions sexuelles, etc.).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Infraction autonome',
    question:
        'La diffusion d’images de violence est qualifiée par le cours comme :',
    options: [
      'Une infraction autonome',
      'Une simple contravention de décence',
      'Un cas de recel obligatoire',
    ],
    answer: 'Une infraction autonome',
    explanation:
        'Le cours indique que la diffusion d’images de violences est érigée en infraction autonome.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Supports',
    question: 'La diffusion peut être caractérisée par :',
    options: [
      'L’envoi de la vidéo d’un téléphone à un autre',
      'Uniquement une publication sur un site internet',
      'Uniquement un direct en streaming',
    ],
    answer: 'L’envoi de la vidéo d’un téléphone à un autre',
    explanation:
        'La diffusion est entendue largement : même une transmission d’un portable à un autre suffit.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Ce qui est exclu',
    question: 'Le happy slapping exclut notamment :',
    options: [
      'La fixation sonore seule (cris, sons) sans image',
      'L’enregistrement vidéo',
      'La photographie',
    ],
    answer: 'La fixation sonore seule (cris, sons) sans image',
    explanation:
        'L’enregistrement vise une représentation visuelle : la fixation sonore est exclue.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Représentation analogique',
    question:
        'Quel support est exclu de la notion d’enregistrement au sens du happy slapping ?',
    options: [
      'Un dessin ou une peinture',
      'Une vidéo sur téléphone',
      'Une photo',
    ],
    answer: 'Un dessin ou une peinture',
    explanation:
        'Le cours exclut la représentation analogique (peinture, dessin).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Moment décisif',
    question:
        'Pour entrer dans le champ du happy slapping, l’enregistrement doit être réalisé :',
    options: [
      'Pendant la phase d’exécution de l’infraction, y compris la tentative',
      'Uniquement après la commission des faits',
      'Uniquement avant les violences',
    ],
    answer:
        'Pendant la phase d’exécution de l’infraction, y compris la tentative',
    explanation:
        'Le cours précise que la commission inclut la période d’exécution : consommation et tentative.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Actes postérieurs',
    question: 'Filmer uniquement la victime déjà au sol après les violences :',
    options: [
      'N’entre pas dans les prévisions du happy slapping',
      'Constitue nécessairement un happy slapping',
      'Constitue une tentative punissable',
    ],
    answer: 'N’entre pas dans les prévisions du happy slapping',
    explanation:
        'Le moment est décisif : l’enregistrement doit porter sur l’instant où l’atteinte se commet.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Actes antérieurs',
    question:
        'Filmer uniquement l’auteur qui s’approche et menace avant de frapper :',
    options: [
      'N’entre pas dans les prévisions du texte',
      'Constitue directement l’infraction',
      'Constitue une circonstance aggravante automatique',
    ],
    answer: 'N’entre pas dans les prévisions du texte',
    explanation:
        'Le cours exclut l’enregistrement d’actes antérieurs (approche, menaces) s’ils ne coïncident pas avec l’exécution.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Images préalablement créées',
    question:
        'Enregistrer sur son ordinateur une vidéo de violences trouvée sur internet relève plutôt :',
    options: [
      'Du recel (selon le cours)',
      'Du happy slapping',
      'De la non-assistance à personne en péril',
    ],
    answer: 'Du recel (selon le cours)',
    explanation:
        'Le cours précise que l’enregistrement d’images préalablement créées n’entre pas dans l’incrimination ; l’exemple évoque le recel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Hébergeur',
    question: 'Un hébergeur de site peut être poursuivi s’il :',
    options: [
      'Autorise, même tacitement, la diffusion en connaissant le caractère illicite',
      'Ignore totalement le contenu hébergé, sans possibilité d’action',
      'Supprime immédiatement toute vidéo sans l’avoir consultée',
    ],
    answer:
        'Autorise, même tacitement, la diffusion en connaissant le caractère illicite',
    explanation:
        'Le cours indique qu’un hébergeur peut voir sa responsabilité engagée s’il a autorisé la diffusion en connaissant l’illicéité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Fait justificatif',
    question:
        'La diffusion par des professionnels de l’information peut être justifiée au titre :',
    options: [
      'De l’exception d’information',
      'De l’excuse de minorité',
      'Du consentement de la victime',
    ],
    answer: 'De l’exception d’information',
    explanation:
        'Le cours indique que la diffusion peut être justifiée lorsque réalisée par des professionnels pour informer le public.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Limites',
    question:
        'Même en cas d’exception d’information, la diffusion doit notamment :',
    options: [
      'Ne pas porter atteinte à la dignité et ne pas permettre l’identification',
      'Toujours flouter uniquement le décor',
      'Être validée par la victime',
    ],
    answer:
        'Ne pas porter atteinte à la dignité et ne pas permettre l’identification',
    explanation:
        'Le cours rappelle les limites : dignité et non-identification, et respect de la loi du 29 juillet 1881.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Fait justificatif probatoire',
    question:
        'L’enregistrement d’images de violences est justifié s’il est réalisé :',
    options: [
      'Afin de servir de preuve en justice (matérialité / identification)',
      'Uniquement pour publier sur les réseaux',
      'Uniquement pour divertir des amis',
    ],
    answer:
        'Afin de servir de preuve en justice (matérialité / identification)',
    explanation:
        'Le cours reconnaît une exception probatoire lorsque l’enregistrement sert à établir les faits ou identifier les auteurs.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Exception probatoire',
    question:
        'Concernant la diffusion d’images, l’exception probatoire est, selon le cours :',
    options: [
      'Difficilement applicable car la diffusion caractérise l’infraction',
      'Toujours applicable si l’auteur est témoin',
      'Applicable si la vidéo est courte',
    ],
    answer:
        'Difficilement applicable car la diffusion caractérise l’infraction',
    explanation:
        'Le cours indique qu’il paraît impossible de diffuser sur TV/internet “pour servir de preuve” sans constituer l’infraction.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Circonstances aggravantes',
    question:
        'La diffusion d’images de violence comporte-t-elle des circonstances aggravantes propres ?',
    options: [
      'Non',
      'Oui, si la vidéo dure plus de 10 secondes',
      'Oui, si l’auteur est mineur',
    ],
    answer: 'Non',
    explanation:
        'Le cours indique : IV — Circonstances aggravantes : aucune (pour la diffusion).',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // DIFFICILE (Niveau concours / subtilités)
  // =========================================================
  const QuizQuestion(
    category: 'Happy slapping — Consentement de la victime',
    question:
        'Le fait d’enregistrer des violences commises sur un individu consentant :',
    options: [
      'Entre dans le champ du happy slapping',
      'Est exclu car il n’y a pas de victime',
      'Relève uniquement d’une contravention',
    ],
    answer: 'Entre dans le champ du happy slapping',
    explanation:
        'Le cours précise que les violences volontaires sont constituées même si la victime est consentante.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Élément moral',
    question: 'L’élément moral du happy slapping suppose notamment :',
    options: [
      'Un enregistrement réalisé sciemment et volontairement',
      'Une diffusion obligatoire des images',
      'Une intention de nuire à la victime',
    ],
    answer: 'Un enregistrement réalisé sciemment et volontairement',
    explanation:
        'Le cours insiste : enregistrement volontaire (conscience de filmer) + conscience que ce sont des violences.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Erreur de fait',
    question:
        'La responsabilité peut être exclue si l’auteur filme en croyant :',
    options: [
      'Que les coups portés sont feints (absence d’atteinte illicite)',
      'Que la vidéo sera virale',
      'Que la victime portera plainte',
    ],
    answer: 'Que les coups portés sont feints (absence d’atteinte illicite)',
    explanation:
        'Le cours mentionne l’erreur de fait : l’auteur croit qu’il n’y a pas d’atteinte illicite.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Élément moral',
    question:
        'Pour la diffusion d’images de violence, l’élément moral inclut :',
    options: [
      'La connaissance du contenu et la volonté de diffuser',
      'La volonté de filmer sur place',
      'L’intention de blesser la victime',
    ],
    answer: 'La connaissance du contenu et la volonté de diffuser',
    explanation:
        'Le cours : connaissance que ce sont des images de violences + diffusion intentionnelle.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Portée “complicité”',
    question:
        'L’enregistrement d’images de violence est assimilé à la complicité :',
    options: [
      'Au sens du droit commun (121-6 et 121-7), rattachée à l’infraction principale',
      'Comme une infraction autonome sans rattachement',
      'Uniquement si le filmeur participe aux violences',
    ],
    answer:
        'Au sens du droit commun (121-6 et 121-7), rattachée à l’infraction principale',
    explanation:
        'Le cours indique que l’acte d’enregistrement est assimilé à un cas de complicité au sens du droit commun.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Répression',
    question: 'La peine applicable au happy slapping dépend :',
    options: [
      'Des peines prévues pour l’infraction principale enregistrée',
      'D’un barème fixe de 5 ans',
      'D’une contravention unique',
    ],
    answer: 'Des peines prévues pour l’infraction principale enregistrée',
    explanation:
        'Le cours indique que la répression est celle des infractions faisant l’objet de l’enregistrement.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Circonstances communicables',
    question:
        'Les circonstances aggravantes de l’infraction principale peuvent :',
    options: [
      'Être communicables au complice (enregistreur)',
      'Ne jamais se communiquer',
      'Se communiquer uniquement si la victime est mineure',
    ],
    answer: 'Être communicables au complice (enregistreur)',
    explanation:
        'Le cours précise que les circonstances aggravantes attachées à l’infraction principale peuvent être communicables au complice.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Réunion',
    question: 'Selon le cours, l’enregistreur peut également se voir retenir :',
    options: [
      'La circonstance aggravante de réunion, comme complice de l’infraction initiale',
      'Une circonstance aggravante liée au support numérique uniquement',
      'Une immunité si la vidéo est courte',
    ],
    answer:
        'La circonstance aggravante de réunion, comme complice de l’infraction initiale',
    explanation:
        'Le cours évoque la possibilité de retenir la circonstance aggravante de réunion.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Auteur principal et complicité',
    question:
        'L’auteur des violences peut-il être complice du happy slapping s’il demande à être filmé ?',
    options: [
      'Non, selon le cours',
      'Oui, toujours',
      'Oui, uniquement si la victime est d’accord',
    ],
    answer: 'Non, selon le cours',
    explanation:
        'Le cours indique que l’auteur de l’infraction principale ne peut être considéré comme complice s’il demande à être filmé.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Complicité de complicité',
    question: 'La complicité de complicité est :',
    options: [
      'Répréhensible (Cass. crim., 15 décembre 2004)',
      'Impossible en droit pénal',
      'Une contravention',
    ],
    answer: 'Répréhensible (Cass. crim., 15 décembre 2004)',
    explanation:
        'Le cours mentionne expressément : la complicité de complicité est répréhensible.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Infractions incluses',
    question:
        'La diffusion d’images de violence vise notamment des images relatives :',
    options: [
      'Au viol, aux agressions sexuelles délictuelles et au harcèlement sexuel',
      'Uniquement aux homicides',
      'Uniquement aux violences contraventionnelles',
    ],
    answer:
        'Au viol, aux agressions sexuelles délictuelles et au harcèlement sexuel',
    explanation:
        'La liste limitative inclut viol, agressions sexuelles délictuelles, administration de substance à cette fin, harcèlement sexuel.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Infractions exclues',
    question:
        'Selon le cours, les infractions voisines non mentionnées par la liste :',
    options: [
      'Sont exclues du champ du texte',
      'Sont automatiquement incluses',
      'Sont incluses si la vidéo est choquante',
    ],
    answer: 'Sont exclues du champ du texte',
    explanation:
        'Le cours insiste : liste limitative ; infractions voisines exclues.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Tentative',
    question: 'La tentative de happy slapping (enregistrement) est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable uniquement en cas de crime',
    ],
    answer: 'Non punissable',
    explanation:
        'Le cours indique : TENTATIVE : NON pour l’enregistrement d’images de violence.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Personnes morales',
    question:
        'Les personnes morales peuvent-elles être pénalement responsables de diffusion d’images de violence ?',
    options: ['Oui', 'Non, jamais', 'Uniquement si l’auteur est salarié'],
    answer: 'Oui',
    explanation:
        'Le cours précise que les personnes morales peuvent être déclarées pénalement responsables.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // MOYENNE / DIFFICILE — QUESTIONS PIÈGES (CAS COURTS)
  // =========================================================
  const QuizQuestion(
    category: 'Cas pratique — Happy slapping',
    question:
        'Une personne filme sciemment une agression sexuelle délictuelle en cours d’exécution sans y participer. Sa qualification principale est :',
    options: [
      'Complicité de l’infraction enregistrée (happy slapping)',
      'Non-assistance à personne en péril',
      'Atteinte à la vie privée uniquement',
    ],
    answer: 'Complicité de l’infraction enregistrée (happy slapping)',
    explanation:
        'L’enregistrement sciemment d’images relatives à certaines atteintes est un acte de complicité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Cas pratique — Moment de l’enregistrement',
    question:
        'Une personne ne filme que les secondes suivant l’agression, quand la victime est au sol. Selon le cours, le happy slapping :',
    options: [
      'N’est pas constitué au titre de l’enregistrement (moment décisif)',
      'Est automatiquement constitué',
      'Devient une tentative punissable',
    ],
    answer: 'N’est pas constitué au titre de l’enregistrement (moment décisif)',
    explanation:
        'Le cours exclut les actes postérieurs si l’enregistrement ne porte pas sur la phase de commission.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Cas pratique — Diffusion',
    question:
        'Une personne reçoit une vidéo de violences sur messagerie et la transfère à plusieurs amis. Elle :',
    options: [
      'Peut caractériser une diffusion',
      'Ne risque rien car elle n’a pas filmé',
      'Commet une contravention de décence uniquement',
    ],
    answer: 'Peut caractériser une diffusion',
    explanation:
        'La diffusion s’entend largement, y compris par transmission de téléphone à téléphone.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Cas pratique — Information du public',
    question:
        'Un journaliste diffuse une séquence de violences dans le cadre d’un reportage d’actualité. Le fait justificatif mobilisable est :',
    options: [
      'L’exception d’information (sous conditions)',
      'L’exception probatoire',
      'L’erreur sur le droit',
    ],
    answer: 'L’exception d’information (sous conditions)',
    explanation:
        'Le cours indique que la diffusion est justifiée pour informer le public, sous réserve de respecter dignité, non-identification et loi de 1881.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Cas pratique — Probatoire',
    question:
        'Un témoin filme une scène de violences afin de faciliter l’identification des auteurs et remet la vidéo aux enquêteurs sans la publier. Le fait justificatif applicable est :',
    options: [
      'L’exception probatoire (enregistrement)',
      'L’exception d’information',
      'Aucun : l’infraction est toujours constituée',
    ],
    answer: 'L’exception probatoire (enregistrement)',
    explanation:
        'L’article 222-33-3 al.3 prévoit l’exception probatoire pour l’enregistrement destiné à servir de preuve.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Qualification',
    question: 'La diffusion d’images de violence est :',
    options: ['Un délit', 'Une contravention', 'Un crime'],
    answer: 'Un délit',
    explanation:
        'Le cours classe la diffusion d’images de violence (art. 222-33-3 al.2) comme un délit.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Fondement',
    question: 'Le “happy slapping” est prévu par :',
    options: [
      'L’article 222-33-3 du Code pénal',
      'L’article 222-32 du Code pénal',
      'L’article 223-6 du Code pénal',
    ],
    answer: 'L’article 222-33-3 du Code pénal',
    explanation:
        'Le cours indique : art. 222-33-3 C.P. incrimine l’enregistrement sciemment d’images de violences (happy slapping).',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Répression',
    question:
        'La répression du happy slapping (enregistrement) est prévue par :',
    options: [
      'Les textes réprimant l’infraction principale enregistrée',
      'Un barème fixe de 5 ans',
      'Une amende forfaitaire',
    ],
    answer: 'Les textes réprimant l’infraction principale enregistrée',
    explanation:
        'Le cours précise que l’enregistrement est un acte de complicité : la peine suit l’infraction faisant l’objet de l’enregistrement.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Support',
    question: 'L’image enregistrée peut être fixée :',
    options: [
      'Sur tout support (carte mémoire, disque dur, etc.)',
      'Uniquement sur un téléphone',
      'Uniquement sur pellicule',
    ],
    answer: 'Sur tout support (carte mémoire, disque dur, etc.)',
    explanation:
        'Le cours précise : pellicule, cassette, carte mémoire, disque dur…',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Élément moral',
    question: 'Pour la diffusion, il faut notamment :',
    options: [
      'La volonté de diffuser',
      'La participation aux violences',
      'L’accord de la victime',
    ],
    answer: 'La volonté de diffuser',
    explanation:
        'Le cours vise une diffusion intentionnelle : volonté de diffuser et connaissance du contenu.',
    difficulty: 'Facile',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Complicité',
    question: 'Les règles de la complicité applicables sont :',
    options: [
      'Articles 121-6 et 121-7 du Code pénal',
      'Articles 222-32 et 222-33 du Code pénal',
      'Article 223-6 du Code pénal',
    ],
    answer: 'Articles 121-6 et 121-7 du Code pénal',
    explanation:
        'Le cours précise que la complicité est punissable conformément aux articles 121-6 et 121-7 C.P.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // MOYENNE (Compréhension / pièges)
  // =========================================================
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Liste limitative',
    question:
        'Parmi les infractions suivantes, laquelle est explicitement visée dans la liste du cours ?',
    options: [
      'Le harcèlement sexuel',
      'L’exhibition sexuelle',
      'L’atteinte à la vie privée',
    ],
    answer: 'Le harcèlement sexuel',
    explanation:
        'Le cours cite expressément le harcèlement sexuel dans la liste de l’art. 222-33-3 (diffusion/enregistrement).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Infractions exclues',
    question: 'Si une infraction n’est pas dans la liste, selon le cours :',
    options: [
      'Elle est exclue du champ de l’incrimination',
      'Elle est incluse si l’image est choquante',
      'Elle est incluse si la victime est mineure',
    ],
    answer: 'Elle est exclue du champ de l’incrimination',
    explanation:
        'Le cours insiste : liste limitative, les infractions voisines sont exclues.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Ce qui est enregistré',
    question: 'Le happy slapping vise l’enregistrement :',
    options: [
      'D’images relatives à la commission de certaines violences',
      'De tout événement choquant',
      'De tout délit',
    ],
    answer: 'D’images relatives à la commission de certaines violences',
    explanation:
        'Le texte vise des images relatives à la commission d’infractions listées (violences, viol, agressions sexuelles, etc.).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Commission et tentative',
    question: 'Pour le happy slapping, la “commission” inclut :',
    options: [
      'La consommation et la tentative',
      'Uniquement la consommation',
      'Uniquement la préparation',
    ],
    answer: 'La consommation et la tentative',
    explanation:
        'Le cours précise que la phase de commission comprend la tentative.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Hypothèse de recel',
    question:
        'Enregistrer une vidéo déjà existante trouvée en ligne, selon le cours, renvoie plutôt à :',
    options: [
      'Le recel',
      'Le happy slapping',
      'La diffusion d’images de violence',
    ],
    answer: 'Le recel',
    explanation:
        'Le cours donne l’exemple d’une vidéo trouvée sur internet enregistrée sur disque dur : orientation recel.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Hébergement',
    question: 'Un hébergeur peut engager sa responsabilité pénale s’il :',
    options: [
      'Autorise la diffusion en connaissant le caractère illicite',
      'Héberge automatiquement sans aucune connaissance',
      'N’est pas l’auteur de la vidéo',
    ],
    answer: 'Autorise la diffusion en connaissant le caractère illicite',
    explanation:
        'Le cours évoque l’hébergeur qui autorise, même tacitement, en connaissant l’illicéité.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Fait justificatif',
    question: 'L’exception d’information profite principalement :',
    options: [
      'Aux professionnels de l’information',
      'À toute personne qui “informe ses amis”',
      'Aux auteurs des violences',
    ],
    answer: 'Aux professionnels de l’information',
    explanation:
        'Le cours indique que la diffusion peut être justifiée lorsqu’elle est effectuée par des professionnels de l’information.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Conditions',
    question:
        'Selon le cours, l’exception d’information suppose notamment de :',
    options: [
      'Ne pas porter atteinte à la dignité et éviter l’identification',
      'Demander l’accord écrit de la victime',
      'Publier uniquement en noir et blanc',
    ],
    answer: 'Ne pas porter atteinte à la dignité et éviter l’identification',
    explanation:
        'Le cours impose le respect de la dignité et l’absence d’identification, avec la loi du 29 juillet 1881.',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Exception probatoire',
    question:
        'L’exception probatoire s’applique quand l’enregistrement est fait :',
    options: [
      'Pour établir la matérialité des faits ou identifier les auteurs',
      'Pour obtenir des likes',
      'Pour humilier la victime',
    ],
    answer: 'Pour établir la matérialité des faits ou identifier les auteurs',
    explanation:
        'Le cours : exception probatoire si l’enregistrement sert la preuve / identification.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // DIFFICILE (Niveau concours / subtilités)
  // =========================================================
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Élément matériel',
    question:
        'Concernant l’acte de diffusion, quel comportement est explicitement cité par le cours ?',
    options: [
      'Prêter l’original ou distribuer des copies',
      'Conserver la vidéo sans la partager',
      'Supprimer la vidéo après l’avoir reçue',
    ],
    answer: 'Prêter l’original ou distribuer des copies',
    explanation:
        'Le cours énumère : transmettre, internet, prêter l’original, distribuer des copies…',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Fixation sonore',
    question: 'Pourquoi une simple captation audio (cris) est-elle exclue ?',
    options: [
      'Car le texte vise une représentation visuelle parfaite',
      'Car la victime doit être identifiable',
      'Car l’audio est une contravention',
    ],
    answer: 'Car le texte vise une représentation visuelle parfaite',
    explanation:
        'Le cours indique : l’enregistrement d’images = représentation visuelle ; la fixation sonore seule est exclue.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Moment décisif',
    question: 'Quel scénario correspond le mieux au champ du happy slapping ?',
    options: [
      'Filmer la scène pendant que les coups sont portés',
      'Filmer la victime 10 minutes après, aux urgences',
      'Filmer l’auteur la veille en train de menacer',
    ],
    answer: 'Filmer la scène pendant que les coups sont portés',
    explanation:
        'Le cours : l’enregistrement doit être fait à l’instant même où l’atteinte se commet.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Exception probatoire',
    question:
        'Selon le cours, l’exception probatoire est difficilement applicable à la diffusion car :',
    options: [
      'La diffusion constitue l’infraction elle-même',
      'La preuve en justice est interdite en matière pénale',
      'Les images doivent toujours rester privées',
    ],
    answer: 'La diffusion constitue l’infraction elle-même',
    explanation:
        'Le cours explique qu’il paraît impossible de diffuser sur TV/internet “pour servir de preuve” sans constituer l’infraction.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Circonstances aggravantes',
    question: 'En tant que complice, l’enregistreur peut se voir appliquer :',
    options: [
      'Les circonstances aggravantes attachées à l’infraction principale',
      'Aucune circonstance aggravante, jamais',
      'Uniquement des circonstances liées à internet',
    ],
    answer: 'Les circonstances aggravantes attachées à l’infraction principale',
    explanation:
        'Le cours : les circonstances aggravantes de l’infraction principale peuvent être communicables au complice.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Réunion',
    question:
        'Pourquoi la circonstance aggravante de réunion peut viser l’enregistreur ?',
    options: [
      'Car il est complice de l’infraction initiale et peut entrer dans la réunion',
      'Car il diffuse toujours ensuite',
      'Car il est forcément l’auteur principal',
    ],
    answer:
        'Car il est complice de l’infraction initiale et peut entrer dans la réunion',
    explanation:
        'Le cours évoque que l’enregistreur étant complice, la circonstance aggravante de réunion peut être retenue.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Complicité de complicité',
    question:
        'Une personne aide l’enregistreur à filmer (lumière, angle, etc.). Selon le cours :',
    options: [
      'La complicité de complicité est répréhensible',
      'C’est impossible juridiquement',
      'C’est une contravention',
    ],
    answer: 'La complicité de complicité est répréhensible',
    explanation:
        'Le cours cite : Cass. crim., 15 décembre 2004 — la complicité de complicité est répréhensible.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Happy slapping — Auteur principal',
    question:
        'Selon le cours, l’auteur de l’infraction principale ne peut pas être complice du happy slapping s’il :',
    options: [
      'Demande à être filmé',
      'Refuse d’être filmé',
      'Ignore la présence d’un téléphone',
    ],
    answer: 'Demande à être filmé',
    explanation:
        'Le cours précise : l’auteur principal ne peut être complice s’il demande à ce qu’on le filme.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Diffusion d’images de violence — Personnes morales',
    question: 'Quel énoncé est conforme au cours ?',
    options: [
      'Les personnes morales peuvent être pénalement responsables',
      'Les personnes morales sont exclues en matière de diffusion',
      'Seules les associations peuvent être responsables',
    ],
    answer: 'Les personnes morales peuvent être pénalement responsables',
    explanation:
        'Le cours indique expressément que les personnes morales peuvent être déclarées pénalement responsables.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // CAS PRATIQUES (Mix moyen/difficile)
  // =========================================================
  const QuizQuestion(
    category: 'Cas pratique — Diffusion',
    question:
        'Une personne reçoit une vidéo de viol filmé par un tiers et la republie sur un groupe privé. Juridiquement, elle risque :',
    options: [
      'La diffusion d’images de violence (si elle connaît le contenu)',
      'Uniquement une responsabilité civile',
      'Rien car le groupe est privé',
    ],
    answer: 'La diffusion d’images de violence (si elle connaît le contenu)',
    explanation:
        'Le cours : la diffusion est large (même entre téléphones / groupes). L’auteur n’a pas besoin d’être le filmeur, mais doit connaître le contenu et vouloir diffuser.',
    difficulty: 'Difficile',
  ),
  const QuizQuestion(
    category: 'Cas pratique — Information',
    question:
        'Un média diffuse une vidéo de violences en floutant parfaitement la victime et sans atteinte à la dignité dans un sujet d’actualité. Cela se rattache à :',
    options: [
      'L’exception d’information (sous conditions)',
      'L’exception probatoire',
      'Un fait non punissable car “journalisme” suffit',
    ],
    answer: 'L’exception d’information (sous conditions)',
    explanation:
        'Le cours admet l’exception d’information, mais sous réserve (dignité, non-identification, loi de 1881).',
    difficulty: 'Moyenne',
  ),
  const QuizQuestion(
    category: 'Cas pratique — Probatoire',
    question:
        'Un témoin filme une scène de violences pour identifier les auteurs et remet la vidéo à la police, sans la transmettre à d’autres. Selon le cours :',
    options: [
      'Exception probatoire possible pour l’enregistrement',
      'Diffusion d’images de violence constituée',
      'Happy slapping forcément constitué',
    ],
    answer: 'Exception probatoire possible pour l’enregistrement',
    explanation:
        'Le cours prévoit que l’enregistrement est autorisé s’il sert à établir la matérialité des faits ou faciliter l’identification.',
    difficulty: 'Difficile',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizEnregistrementDiffusionImagesGPX extends StatefulWidget {
  static const String grade = 'gpx';
  static const String routeName =
      '/gpx/crimes_personne/quiz/enregistrement_diffusion_images';
  final String uid;
  final String email;

  const QuizEnregistrementDiffusionImagesGPX({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizEnregistrementDiffusionImagesGPX> createState() => _QuizEnregistrementDiffusionImagesGPXState();
}

class _QuizEnregistrementDiffusionImagesGPXState extends State<QuizEnregistrementDiffusionImagesGPX>
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
  static const _introHiddenKey = 'intro_gpx_enregistrement_diffusion_images';
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
        ? questionEnregistrementDiffusion
        : questionEnregistrementDiffusion
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
            'quiz_name': 'Enregistrement & Diffusion',
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
      await _sb.from('quiz_enregistrement_diffusion').insert({
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
      debugPrint('❌ quiz_enregistrement_diffusion insert failed: $e');
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
      'source_file': 'gpx_quiz_enregistrement_diffusion_images',
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
                            icon: Icons.videocam_rounded,
                            title: 'Enregistrement d’images',
                            description: 'Comprends la réglementation sur l’enregistrement et la diffusion d’images de personnes : droits à l’image et infractions.',
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
