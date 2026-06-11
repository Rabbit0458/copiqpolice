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

final List<QuizQuestion> questionLibertesPubliquesIntroduction = [
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Définition",
    question:
        "Constitue l’infraction de conduite après usage de stupéfiants le fait de :",
    options: [
      "Conduire ou accompagner un élève conducteur après usage de stupéfiants établi par analyse",
      "Conduire uniquement sous l’emprise visible de stupéfiants",
      "Détenir des stupéfiants dans le véhicule",
    ],
    answer:
        "Conduire ou accompagner un élève conducteur après usage de stupéfiants établi par analyse",
    explanation:
        "Article L.235-1/I CR : l’infraction est constituée dès lors qu’une analyse sanguine ou salivaire établit l’usage de stupéfiants.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Personnes visées",
    question: "Sont concernés par l’infraction :",
    options: [
      "Les conducteurs et les accompagnateurs d’élèves conducteurs",
      "Uniquement les conducteurs professionnels",
      "Uniquement les conducteurs de véhicules à moteur",
    ],
    answer: "Les conducteurs et les accompagnateurs d’élèves conducteurs",
    explanation:
        "Le texte vise expressément les conducteurs de tout véhicule et les accompagnateurs d’élèves conducteurs.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Dépistage obligatoire",
    question: "Le dépistage de stupéfiants est obligatoire en cas :",
    options: [
      "D’accident mortel ou corporel",
      "D’infraction de stationnement",
      "De simple contrôle d’identité",
    ],
    answer: "D’accident mortel ou corporel",
    explanation:
        "Article L.235-2 CR : dépistage obligatoire en cas d’accident mortel ou corporel de la circulation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Refus de dépistage",
    question: "Le refus de se soumettre au dépistage salivaire :",
    options: [
      "N’est pas une infraction mais entraîne des vérifications",
      "Constitue immédiatement le délit L.235-3",
      "Met fin à toute procédure",
    ],
    answer: "N’est pas une infraction mais entraîne des vérifications",
    explanation:
        "Le refus de dépistage n’est pas sanctionné en soi, mais impose des vérifications (prise de sang).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Refus de vérifications",
    question: "Le refus de se soumettre aux vérifications constitue :",
    options: [
      "Le délit prévu par l’article L.235-3 CR",
      "Une contravention",
      "Une circonstance aggravante automatique",
    ],
    answer: "Le délit prévu par l’article L.235-3 CR",
    explanation:
        "Le refus de vérifications destinées à établir l’usage de stupéfiants est un délit autonome.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Preuve",
    question: "Depuis 2016, l’analyse toxicologique doit :",
    options: [
      "Confirmer ou infirmer la présence de stupéfiants sans dosage",
      "Indiquer obligatoirement un taux précis",
      "Être exclusivement sanguine",
    ],
    answer: "Confirmer ou infirmer la présence de stupéfiants sans dosage",
    explanation:
        "Le décret de 2016 a supprimé la notion de dosage : seule la présence est requise.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Élément moral",
    question: "L’infraction suppose :",
    options: [
      "La volonté de conduire après avoir fait usage de stupéfiants",
      "Une faute d’imprudence",
      "Un état de dépendance",
    ],
    answer: "La volonté de conduire après avoir fait usage de stupéfiants",
    explanation:
        "Il s’agit d’une infraction intentionnelle : conscience et volonté de conduire après usage.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Circonstance aggravante",
    question: "Les peines sont aggravées si le conducteur est également :",
    options: [
      "Sous l’empire d’un état alcoolique",
      "En excès de vitesse simple",
      "Sans assurance",
    ],
    answer: "Sous l’empire d’un état alcoolique",
    explanation:
        "Article L.235-1/I al.2 CR : cumul alcool + stupéfiants = aggravation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Peines",
    question: "Peines encourues pour l’infraction simple :",
    options: [
      "2 ans d’emprisonnement et 4 500 € d’amende",
      "1 an d’emprisonnement et 3 750 € d’amende",
      "3 ans d’emprisonnement et 6 000 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 4 500 € d’amende",
    explanation:
        "Article L.235-1/I CR : peines principales de la forme simple.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Tentative",
    question: "La tentative de conduite après usage de stupéfiants est :",
    options: [
      "Non punissable",
      "Punissable",
      "Punissable en récidive uniquement",
    ],
    answer: "Non punissable",
    explanation: "La tentative n’est pas prévue par le texte.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite en état d’ivresse manifeste — Définition",
    question: "La conduite en état d’ivresse manifeste se caractérise par :",
    options: [
      "Des signes extérieurs d’ivresse indépendamment du taux",
      "Un taux d’alcool supérieur à 0,80 g/l",
      "Un refus d’éthylotest",
    ],
    answer: "Des signes extérieurs d’ivresse indépendamment du taux",
    explanation:
        "L’ivresse manifeste repose sur des constatations matérielles, même en dessous des seuils légaux.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite en état d’ivresse manifeste — Preuve",
    question: "L’état d’ivresse manifeste peut être établi :",
    options: [
      "Par tout moyen de preuve",
      "Uniquement par analyse sanguine",
      "Uniquement par éthylomètre",
    ],
    answer: "Par tout moyen de preuve",
    explanation:
        "Les juges apprécient souverainement les éléments matériels constatés.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite sous l’empire d’un état alcoolique — Seuil",
    question: "Le seuil délictuel est atteint à partir de :",
    options: [
      "0,80 g/l de sang ou 0,40 mg/l d’air expiré",
      "0,50 g/l de sang",
      "0,20 g/l de sang",
    ],
    answer: "0,80 g/l de sang ou 0,40 mg/l d’air expiré",
    explanation: "Article L.234-1/I CR : seuil délictuel de l’état alcoolique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Défaut d’assurance — Élément matériel",
    question: "Le défaut d’assurance est constitué lorsque le véhicule :",
    options: [
      "Circule ou stationne sur une voie ouverte à la circulation sans assurance valide",
      "Est simplement non assuré mais garé dans un garage privé",
      "A une prime impayée depuis un jour",
    ],
    answer:
        "Circule ou stationne sur une voie ouverte à la circulation sans assurance valide",
    explanation:
        "L’infraction est constituée dès lors que le véhicule est exposé à la circulation publique.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Défaut d’assurance — Peine",
    question: "Le défaut d’assurance est puni de :",
    options: ["3 750 € d’amende", "1 an d’emprisonnement", "750 € d’amende"],
    answer: "3 750 € d’amende",
    explanation: "Article L.324-2 CR : délit sans peine d’emprisonnement.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Défaut de permis — Distinction",
    question:
        "Le défaut de permis de conduire se distingue de la non-présentation du permis car il concerne :",
    options: [
      "L’absence de droit à conduire",
      "L’oubli du permis",
      "Un permis expiré depuis moins d’un mois",
    ],
    answer: "L’absence de droit à conduire",
    explanation:
        "Il s’agit de ne pas être titulaire de la catégorie requise, et non d’un simple oubli.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délit de fuite — Élément matériel",
    question: "Le délit de fuite suppose :",
    options: [
      "Un accident et une omission volontaire de s’arrêter",
      "Un excès de vitesse",
      "Un refus d’obtempérer",
    ],
    answer: "Un accident et une omission volontaire de s’arrêter",
    explanation:
        "Article 434-10 CP : accident + volonté de se soustraire à la responsabilité.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Refus d’obtempérer — Élément moral",
    question: "Le refus d’obtempérer suppose :",
    options: [
      "La volonté délibérée de ne pas s’arrêter malgré une sommation claire",
      "Un simple doute sur la qualité de l’agent",
      "Un arrêt différé",
    ],
    answer:
        "La volonté délibérée de ne pas s’arrêter malgré une sommation claire",
    explanation: "La connaissance non équivoque de l’ordre est indispensable.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rodéo motorisé — Définition",
    question: "Le rodéo motorisé suppose :",
    options: [
      "Des manœuvres dangereuses répétées compromettant la sécurité ou la tranquillité publique",
      "Une seule infraction au code de la route",
      "Une course de vitesse isolée",
    ],
    answer:
        "Des manœuvres dangereuses répétées compromettant la sécurité ou la tranquillité publique",
    explanation: "Article L.236-1 CR : répétition et danger ou trouble requis.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Plaques d’immatriculation — Usurpation",
    question: "L’usurpation de plaque consiste à :",
    options: [
      "Utiliser un numéro attribué à un autre véhicule exposant un tiers à des poursuites",
      "Circuler sans plaque",
      "Avoir une plaque sale",
    ],
    answer:
        "Utiliser un numéro attribué à un autre véhicule exposant un tiers à des poursuites",
    explanation: "Article L.317-4-1 CR : usurpation de plaque.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite stupéfiants — Définition",
    question:
        "Constitue une infraction le fait de conduire un véhicule après usage de stupéfiants lorsque :",
    options: [
      "Une analyse sanguine ou salivaire révèle la présence de stupéfiants",
      "Le conducteur présente des signes extérieurs évidents",
      "Le conducteur reconnaît avoir consommé",
    ],
    answer:
        "Une analyse sanguine ou salivaire révèle la présence de stupéfiants",
    explanation:
        "Article L.235-1/I CR : l’infraction est constituée par la preuve biologique de l’usage de stupéfiants, indépendamment des signes extérieurs.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite stupéfiants — Personnes concernées",
    question:
        "Quelles personnes peuvent être poursuivies pour conduite après usage de stupéfiants ?",
    options: [
      "Le conducteur uniquement",
      "Le conducteur et l’accompagnateur d’élève conducteur",
      "Toute personne présente dans le véhicule",
    ],
    answer: "Le conducteur et l’accompagnateur d’élève conducteur",
    explanation:
        "L.235-1 CR vise le conducteur et l’accompagnateur d’un élève conducteur.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite stupéfiants — Dépistage",
    question: "Le dépistage de stupéfiants est obligatoire en cas :",
    options: [
      "D’accident corporel ou mortel",
      "D’infraction routière simple",
      "De contrôle préventif sans motif",
    ],
    answer: "D’accident corporel ou mortel",
    explanation:
        "Article L.235-2 CR : dépistage obligatoire en cas d’accident corporel ou mortel.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite stupéfiants — Refus",
    question:
        "Le refus de se soumettre aux vérifications stupéfiants constitue :",
    options: [
      "Une contravention",
      "Un délit autonome",
      "Une circonstance aggravante",
    ],
    answer: "Un délit autonome",
    explanation:
        "Article L.235-3 CR : le refus de vérifications est un délit distinct.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite stupéfiants — Peines",
    question:
        "Les peines principales pour conduite après usage de stupéfiants sont :",
    options: [
      "2 ans d’emprisonnement et 4 500 € d’amende",
      "1 an d’emprisonnement et 3 750 € d’amende",
      "3 ans d’emprisonnement et 6 000 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 4 500 € d’amende",
    explanation: "Article L.235-1/I CR : peines délictuelles de base.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Ivresse manifeste — Définition",
    question: "La conduite en état d’ivresse manifeste se caractérise par :",
    options: [
      "Des signes comportementaux indépendants du taux",
      "Un taux d’alcool précis",
      "Un dépistage obligatoirement positif",
    ],
    answer: "Des signes comportementaux indépendants du taux",
    explanation:
        "L.234-1/II CR : l’ivresse manifeste repose sur des constatations matérielles.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Ivresse manifeste — Preuve",
    question: "La preuve de l’ivresse manifeste peut résulter :",
    options: [
      "Uniquement d’une analyse sanguine",
      "De constatations matérielles seules",
      "D’un aveu du conducteur uniquement",
    ],
    answer: "De constatations matérielles seules",
    explanation:
        "La jurisprudence admet la preuve par observations des forces de l’ordre.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "État alcoolique — Seuils",
    question:
        "Le délit de conduite sous l’empire d’un état alcoolique est constitué à partir de :",
    options: [
      "0,80 g/l de sang ou 0,40 mg/l d’air expiré",
      "0,50 g/l de sang",
      "0,20 g/l de sang",
    ],
    answer: "0,80 g/l de sang ou 0,40 mg/l d’air expiré",
    explanation: "Article L.234-1/I CR : seuils délictuels.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Contravention",
    question:
        "Pour un conducteur non probatoire, l’alcoolémie contraventionnelle débute à :",
    options: ["0,20 g/l", "0,50 g/l", "0,80 g/l"],
    answer: "0,50 g/l",
    explanation:
        "Article R.234-1 CR : seuil contraventionnel pour conducteurs ordinaires.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Défaut d’assurance — Définition",
    question: "Le défaut d’assurance est constitué dès lors que :",
    options: [
      "Le véhicule circule ou stationne sur voie ouverte sans assurance valide",
      "Le contrat est en retard de paiement",
      "Le conducteur ignore l’obligation",
    ],
    answer:
        "Le véhicule circule ou stationne sur voie ouverte sans assurance valide",
    explanation:
        "Article L.324-2 CR : infraction constituée même à l’arrêt sur voie ouverte.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Défaut d’assurance — Procédure",
    question: "Le défaut d’assurance permet-il une garde à vue ?",
    options: [
      "Oui, systématiquement",
      "Non, absence de peine d’emprisonnement",
      "Oui, en cas de récidive",
    ],
    answer: "Non, absence de peine d’emprisonnement",
    explanation: "Le délit n’est puni que d’une amende : pas de GAV possible.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Défaut de permis — Distinction",
    question: "Conduire sans être titulaire du permis se distingue de :",
    options: [
      "La non-présentation du permis",
      "La conduite sans assurance",
      "L’excès de vitesse",
    ],
    answer: "La non-présentation du permis",
    explanation: "L.221-2 CR ≠ R.233-1 CR (simple contravention).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délit de fuite — Élément moral",
    question: "Le délit de fuite suppose :",
    options: [
      "La conscience de l’accident et la volonté d’échapper à la responsabilité",
      "Un accident corporel uniquement",
      "Une fuite définitive",
    ],
    answer:
        "La conscience de l’accident et la volonté d’échapper à la responsabilité",
    explanation: "Article 434-10 CP : double élément intentionnel.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Refus d’obtempérer — Absorption",
    question: "Le refus d’obtempérer est absorbé lorsqu’il constitue :",
    options: [
      "Une violence volontaire aggravée",
      "Une simple contravention",
      "Un délit autonome cumulable",
    ],
    answer: "Une violence volontaire aggravée",
    explanation: "Jurisprudence : l’infraction la plus grave absorbe.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rodéo motorisé — Définition",
    question: "Le rodéo motorisé suppose :",
    options: [
      "Des manœuvres dangereuses répétées",
      "Une seule manœuvre dangereuse",
      "Un accident obligatoire",
    ],
    answer: "Des manœuvres dangereuses répétées",
    explanation: "Article L.236-1 CR : répétition exigée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rodéo motorisé — Aggravation",
    question: "Le rodéo motorisé est aggravé notamment lorsque :",
    options: [
      "Le conducteur est alcoolisé ou sous stupéfiants",
      "Le véhicule est immobilisé",
      "Il n’y a pas de témoins",
    ],
    answer: "Le conducteur est alcoolisé ou sous stupéfiants",
    explanation: "Article L.236-1 III CR : aggravations légales.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Plaques — Usurpation",
    question: "L’usurpation de plaques est caractérisée lorsque :",
    options: [
      "Le numéro correspond à un autre véhicule",
      "La plaque est simplement sale",
      "Le certificat est expiré",
    ],
    answer: "Le numéro correspond à un autre véhicule",
    explanation: "Article L.317-4-1 CR : attribution à un autre véhicule.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Refus de vérifications — Distinction",
    question: "Le refus de se soumettre aux vérifications exclut :",
    options: [
      "Les vérifications alcool et stupéfiants",
      "Les contrôles administratifs",
      "Les contrôles techniques",
    ],
    answer: "Les vérifications alcool et stupéfiants",
    explanation: "L.233-2 CR exclut expressément alcool et stupéfiants.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Conduite stupéfiants — Dépistage facultatif",
    question: "Le dépistage de stupéfiants est facultatif notamment en cas :",
    options: [
      "D’accident matériel",
      "D’accident mortel",
      "D’accident corporel",
    ],
    answer: "D’accident matériel",
    explanation:
        "Article L.235-2 CR : dépistage facultatif en cas d’accident matériel.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite stupéfiants — Dépistage préventif",
    question: "Le dépistage préventif de stupéfiants peut être effectué :",
    options: [
      "Sur réquisition du procureur ou à l’initiative OPJ/APJ",
      "Uniquement après infraction",
      "Uniquement en cas d’accident",
    ],
    answer: "Sur réquisition du procureur ou à l’initiative OPJ/APJ",
    explanation: "Article L.235-2 CR : dépistage préventif autorisé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite stupéfiants — Impossibilité",
    question: "Le dépistage est impossible notamment en cas :",
    options: [
      "De blessures graves ou décès",
      "De refus verbal simple",
      "De stress du conducteur",
    ],
    answer: "De blessures graves ou décès",
    explanation:
        "Contre-indication médicale ou décès rendent le dépistage impossible.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite stupéfiants — Vérifications",
    question: "Les vérifications après dépistage positif consistent en :",
    options: [
      "Analyses ou examens médicaux, cliniques et biologiques",
      "Une audition simple",
      "Une expertise mécanique",
    ],
    answer: "Analyses ou examens médicaux, cliniques et biologiques",
    explanation: "Article L.235-2 CR : modalités de vérification.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite stupéfiants — Prélèvement salivaire",
    question: "Le prélèvement salivaire est réalisé :",
    options: [
      "Par le conducteur sous contrôle OPJ/APJ",
      "Uniquement par un médecin",
      "Par un laboratoire sur place",
    ],
    answer: "Par le conducteur sous contrôle OPJ/APJ",
    explanation: "Article R.235-6 CR : auto-prélèvement contrôlé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite stupéfiants — Droit à expertise",
    question:
        "Après un prélèvement salivaire, le conducteur doit être informé :",
    options: [
      "De la possibilité de demander un examen technique ou une expertise",
      "Du résultat immédiat",
      "De son droit au silence uniquement",
    ],
    answer:
        "De la possibilité de demander un examen technique ou une expertise",
    explanation: "CE 21 novembre 2023 : omission = procédure irrégulière.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Conduite stupéfiants — Accident mortel",
    question: "En cas d’accident mortel, l’analyse autorisée est :",
    options: ["Uniquement sanguine", "Salivaire ou sanguine", "Urinaire"],
    answer: "Uniquement sanguine",
    explanation: "Article R.235-8 CR : prélèvement sanguin exclusif.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite stupéfiants — Élément moral",
    question: "L’infraction est intentionnelle car elle suppose :",
    options: [
      "La conscience d’avoir consommé avant de conduire",
      "Un résultat positif uniquement",
      "Une récidive",
    ],
    answer: "La conscience d’avoir consommé avant de conduire",
    explanation: "Infraction intentionnelle relevant de l’article 121-3 CP.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite stupéfiants — Aggravation",
    question: "La conduite après usage de stupéfiants aggrave :",
    options: [
      "Les homicides et blessures involontaires",
      "Les infractions contraventionnelles",
      "Les délits financiers",
    ],
    answer: "Les homicides et blessures involontaires",
    explanation: "Articles 221-6-1, 222-19-1 et 222-20-1 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite stupéfiants — Complicité",
    question: "La complicité est :",
    options: [
      "Punissable",
      "Impossible",
      "Limitée au propriétaire du véhicule",
    ],
    answer: "Punissable",
    explanation: "Articles 121-6 et 121-7 CP applicables.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Ivresse manifeste — Dépistage",
    question: "La personne en état d’ivresse manifeste peut être soumise :",
    options: [
      "Directement aux vérifications sans dépistage préalable",
      "Uniquement à un alcootest",
      "Uniquement à une audition",
    ],
    answer: "Directement aux vérifications sans dépistage préalable",
    explanation: "Article L.234-6 CR et Cass. crim. 9 octobre 1984.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Ivresse manifeste — Seuil",
    question: "L’état d’ivresse manifeste dépend :",
    options: [
      "Du comportement et non du taux",
      "Uniquement du taux légal",
      "Uniquement du refus",
    ],
    answer: "Du comportement et non du taux",
    explanation: "Signes extérieurs indépendants de l’alcoolémie.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Ivresse manifeste — Élément moral",
    question: "L’élément moral résulte notamment :",
    options: [
      "Du fait de boire en sachant qu’on va conduire",
      "D’un oubli du taux légal",
      "D’un accident matériel",
    ],
    answer: "Du fait de boire en sachant qu’on va conduire",
    explanation: "Cass. crim. 19 décembre 1994.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "État alcoolique — Recherches obligatoires",
    question: "Les recherches d’alcoolémie sont obligatoires pour :",
    options: [
      "Auteur d’une infraction routière sanctionnée par suspension",
      "Toute infraction",
      "Tout contrôle d’identité",
    ],
    answer: "Auteur d’une infraction routière sanctionnée par suspension",
    explanation: "Article L.234-3 al.1 CR.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "État alcoolique — Recherches préventives",
    question: "Les recherches préventives d’alcoolémie sont possibles :",
    options: [
      "Sans infraction ni accident",
      "Uniquement après accident",
      "Uniquement sur aveu",
    ],
    answer: "Sans infraction ni accident",
    explanation: "Article L.234-9 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Éthylomètre",
    question: "L’indication de l’éthylomètre :",
    options: [
      "A la même valeur juridique qu’une analyse de sang",
      "Est indicative seulement",
      "N’a aucune valeur probante",
    ],
    answer: "A la même valeur juridique qu’une analyse de sang",
    explanation: "Article L.234-4 CR.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "État alcoolique — Refus",
    question: "Le refus de l’éthylomètre entraîne :",
    options: [
      "Le délit de refus de se soumettre aux vérifications",
      "Une simple contravention",
      "L’abandon des poursuites",
    ],
    answer: "Le délit de refus de se soumettre aux vérifications",
    explanation: "Article L.234-8 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Marges d’erreur",
    question: "Les marges d’erreur des éthylomètres doivent être :",
    options: [
      "Obligatoirement prises en compte",
      "Appliquées au choix du juge",
      "Ignorées en cas de récidive",
    ],
    answer: "Obligatoirement prises en compte",
    explanation: "Cass. crim. 26 mars 2019.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Défaut d’assurance — Charge de la preuve",
    question: "La preuve de l’assurance incombe :",
    options: [
      "Au conducteur ou souscripteur",
      "Aux forces de l’ordre",
      "À l’assureur",
    ],
    answer: "Au conducteur ou souscripteur",
    explanation: "La charge de la preuve repose sur le titulaire.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Défaut d’assurance — Amende forfaitaire",
    question: "Le défaut d’assurance peut donner lieu :",
    options: [
      "À une amende forfaitaire délictuelle",
      "À une composition pénale uniquement",
      "À un rappel à la loi",
    ],
    answer: "À une amende forfaitaire délictuelle",
    explanation: "Article D.45-3 CPP.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Défaut d’assurance — Élément matériel",
    question:
        "Le défaut d’assurance est constitué dès lors que le véhicule est :",
    options: [
      "Stationné sur la voie publique ou un parking accessible",
      "Uniquement en circulation",
      "Uniquement après un accident",
    ],
    answer: "Stationné sur la voie publique ou un parking accessible",
    explanation: "L’infraction existe même sans circulation effective.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Défaut d’assurance — Résiliation",
    question: "Le défaut d’assurance est constitué lorsque :",
    options: [
      "Le contrat était résilié au moment des faits",
      "La prime est payée en retard",
      "Le véhicule est à l’arrêt moteur coupé",
    ],
    answer: "Le contrat était résilié au moment des faits",
    explanation: "La résiliation rend l’assurance inexistante juridiquement.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Défaut d’assurance — Garde à vue",
    question: "Le défaut d’assurance permet-il une garde à vue ?",
    options: [
      "Non, aucune peine d’emprisonnement n’est prévue",
      "Oui systématiquement",
      "Uniquement en récidive",
    ],
    answer: "Non, aucune peine d’emprisonnement n’est prévue",
    explanation: "Infraction délictuelle sans peine d’emprisonnement.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Défaut de permis — Définition",
    question: "Le défaut de permis consiste à :",
    options: [
      "Conduire sans être titulaire de la catégorie exigée",
      "Oublier son permis chez soi",
      "Conduire avec un permis expiré depuis moins d’un mois",
    ],
    answer: "Conduire sans être titulaire de la catégorie exigée",
    explanation: "Article L.221-2 CR : absence de titre valide.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Défaut de permis — Exclusion",
    question: "Ne constitue PAS un défaut de permis :",
    options: [
      "La non-présentation immédiate du permis",
      "La conduite sans permis",
      "La conduite avec un faux permis",
    ],
    answer: "La non-présentation immédiate du permis",
    explanation: "Article R.233-1 CR : infraction distincte.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Défaut de permis — Élément moral",
    question: "L’élément moral du défaut de permis repose sur :",
    options: [
      "La volonté de conduire sans titre valide",
      "La simple négligence administrative",
      "L’absence de contrôle",
    ],
    answer: "La volonté de conduire sans titre valide",
    explanation: "Infraction intentionnelle.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Défaut de permis — Circonstance aggravante",
    question: "Le défaut de permis est aggravé lorsque :",
    options: [
      "Un permis faux ou falsifié est utilisé",
      "Le véhicule est de forte cylindrée",
      "L’infraction est commise de nuit",
    ],
    answer: "Un permis faux ou falsifié est utilisé",
    explanation: "Article L.221-2-1 CR.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délit de fuite — Définition",
    question: "Le délit de fuite suppose :",
    options: [
      "La conscience d’avoir causé ou occasionné un accident",
      "Un accident mortel uniquement",
      "Une collision avec un véhicule",
    ],
    answer: "La conscience d’avoir causé ou occasionné un accident",
    explanation: "La connaissance de l’accident est indispensable.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délit de fuite — Accident",
    question: "Le délit de fuite peut concerner :",
    options: [
      "Un accident matériel, corporel ou mortel",
      "Uniquement un accident corporel",
      "Uniquement un accident public",
    ],
    answer: "Un accident matériel, corporel ou mortel",
    explanation: "Toute nature d’accident causant un préjudice.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délit de fuite — Omission de s’arrêter",
    question: "L’arrêt du conducteur doit être :",
    options: [
      "Immédiat et volontaire",
      "De plusieurs minutes minimum",
      "Conditionné à l’arrivée des secours",
    ],
    answer: "Immédiat et volontaire",
    explanation: "Cass. crim. 19 mars 1956.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délit de fuite — Faux renseignements",
    question: "Donner un faux nom après un accident constitue :",
    options: [
      "Un délit de fuite",
      "Une simple contravention",
      "Un faux témoignage",
    ],
    answer: "Un délit de fuite",
    explanation: "Cass. crim. 14 avril 1959.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délit de fuite — Retour sur les lieux",
    question: "Le conducteur qui revient après avoir fui :",
    options: [
      "Reste coupable du délit",
      "Bénéficie d’une excuse",
      "Éteint l’action publique",
    ],
    answer: "Reste coupable du délit",
    explanation: "Cass. crim. 4 novembre 2003.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Grand excès de vitesse — Définition",
    question: "Le grand excès de vitesse devient un délit lorsque :",
    options: [
      "Il est commis en récidive",
      "Il dépasse 70 km/h",
      "Il est commis de nuit",
    ],
    answer: "Il est commis en récidive",
    explanation: "Article L.413-1 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Grand excès de vitesse — Seuil",
    question: "Le dépassement concerné est :",
    options: [
      "Égal ou supérieur à 50 km/h",
      "Supérieur à 40 km/h",
      "Supérieur à 30 km/h",
    ],
    answer: "Égal ou supérieur à 50 km/h",
    explanation: "Contravention de 5e classe transformée en délit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Grand excès de vitesse — Délai récidive",
    question: "Le délai de récidive est de :",
    options: ["3 ans", "1 an", "5 ans"],
    answer: "3 ans",
    explanation: "Article 132-11 CP.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Refus de vérifications — Définition",
    question: "Le refus de se soumettre aux vérifications concerne :",
    options: [
      "Les contrôles administratifs et techniques",
      "L’alcoolémie",
      "Les stupéfiants",
    ],
    answer: "Les contrôles administratifs et techniques",
    explanation: "Exclusion alcool et stupéfiants.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Refus de vérifications — Forme",
    question: "Le refus peut être caractérisé par :",
    options: [
      "Un refus verbal ou passif",
      "Une fuite uniquement",
      "Un silence prolongé uniquement",
    ],
    answer: "Un refus verbal ou passif",
    explanation: "Le comportement suffit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Refus d’obtempérer — Sommation",
    question: "La sommation de s’arrêter peut être :",
    options: [
      "Verbale, gestuelle ou lumineuse",
      "Uniquement écrite",
      "Uniquement sonore",
    ],
    answer: "Verbale, gestuelle ou lumineuse",
    explanation: "La forme importe peu.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Refus d’obtempérer — Agents",
    question: "Les agents doivent être :",
    options: [
      "Identifiables par des signes extérieurs",
      "En civil",
      "Assistés d’un supérieur",
    ],
    answer: "Identifiables par des signes extérieurs",
    explanation: "Article L.233-1 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Refus d’obtempérer — Aggravation",
    question: "Le refus est aggravé lorsque :",
    options: [
      "Il expose autrui à un risque grave",
      "Il est commis de nuit",
      "Il dure plus de 5 minutes",
    ],
    answer: "Il expose autrui à un risque grave",
    explanation: "Article L.233-1-1 CR.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Définition",
    question:
        "Constitue une infraction le fait de conduire un véhicule après :",
    options: [
      "Avoir fait usage de substances ou plantes classées comme stupéfiants",
      "Avoir consommé un médicament prescrit",
      "Être fatigué",
    ],
    answer:
        "Avoir fait usage de substances ou plantes classées comme stupéfiants",
    explanation: "Article L.235-1/I du Code de la route.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Personnes concernées",
    question:
        "Qui peut être poursuivi pour conduite après usage de stupéfiants ?",
    options: [
      "Le conducteur et l’accompagnateur d’élève conducteur",
      "Uniquement le conducteur",
      "Uniquement le propriétaire du véhicule",
    ],
    answer: "Le conducteur et l’accompagnateur d’élève conducteur",
    explanation: "Le texte vise également l’accompagnateur.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Dépistage",
    question: "Le dépistage de stupéfiants peut être réalisé par :",
    options: [
      "Prélèvement salivaire ou urinaire",
      "Analyse sanguine uniquement",
      "Test respiratoire",
    ],
    answer: "Prélèvement salivaire ou urinaire",
    explanation: "Recherche des quatre familles de stupéfiants.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Refus de dépistage",
    question: "Le refus de se soumettre au dépistage de stupéfiants :",
    options: [
      "N’est pas une infraction",
      "Constitue un délit",
      "Constitue une contravention",
    ],
    answer: "N’est pas une infraction",
    explanation: "Mais il entraîne des vérifications obligatoires.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Vérifications",
    question: "En cas de dépistage positif, les vérifications consistent en :",
    options: [
      "Analyses médicales, cliniques et biologiques",
      "Un simple interrogatoire",
      "Une fouille du véhicule",
    ],
    answer: "Analyses médicales, cliniques et biologiques",
    explanation: "Article L.235-2 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Prélèvement salivaire",
    question: "Le prélèvement salivaire est réalisé :",
    options: [
      "Par le conducteur sous contrôle de l’OPJ ou APJ",
      "Par un médecin uniquement",
      "Par un laboratoire",
    ],
    answer: "Par le conducteur sous contrôle de l’OPJ ou APJ",
    explanation: "Article R.235-6 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Demande d’expertise",
    question: "Après un prélèvement salivaire, le conducteur peut demander :",
    options: [
      "Une expertise ou un examen technique",
      "L’annulation immédiate de la procédure",
      "Un test respiratoire",
    ],
    answer: "Une expertise ou un examen technique",
    explanation: "Droit fondamental de la défense.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Accident mortel",
    question: "En cas d’accident mortel, la vérification se fait par :",
    options: ["Analyse sanguine uniquement", "Test salivaire", "Test urinaire"],
    answer: "Analyse sanguine uniquement",
    explanation: "Article R.235-8 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Refus de vérifications",
    question: "Le refus de se soumettre aux vérifications constitue :",
    options: [
      "Un délit",
      "Une contravention",
      "Une simple infraction administrative",
    ],
    answer: "Un délit",
    explanation: "Article L.235-3 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Dosage",
    question: "L’analyse des stupéfiants doit-elle mentionner un taux ?",
    options: [
      "Non, seulement la présence",
      "Oui obligatoirement",
      "Uniquement en récidive",
    ],
    answer: "Non, seulement la présence",
    explanation: "Le dosage a été supprimé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Élément moral",
    question: "L’infraction de conduite après usage de stupéfiants est :",
    options: ["Intentionnelle", "Non intentionnelle", "Purement matérielle"],
    answer: "Intentionnelle",
    explanation: "Volonté de conduire après usage.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Cumul alcool",
    question: "La conduite sous stupéfiants est aggravée si :",
    options: [
      "La personne est aussi alcoolisée",
      "La route est humide",
      "Le véhicule est ancien",
    ],
    answer: "La personne est aussi alcoolisée",
    explanation: "Article L.235-1 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Qualification",
    question: "La conduite après usage de stupéfiants est un :",
    options: ["Délit", "Crime", "Contravention"],
    answer: "Délit",
    explanation: "Infraction délictuelle.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Peines",
    question: "La peine encourue en cas simple est :",
    options: [
      "2 ans d’emprisonnement et 4 500 € d’amende",
      "1 an d’emprisonnement",
      "750 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 4 500 € d’amende",
    explanation: "Article L.235-1/I CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Tentative",
    question: "La tentative de conduite après usage de stupéfiants est :",
    options: ["Non punissable", "Punissable", "Assimilée à une contravention"],
    answer: "Non punissable",
    explanation: "La tentative n’est pas prévue.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Complicité",
    question: "La complicité est :",
    options: ["Punissable", "Impossible", "Réservée aux professionnels"],
    answer: "Punissable",
    explanation: "Articles 121-6 et 121-7 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Immunité",
    question: "Les diplomates peuvent-ils être soumis à un dépistage ?",
    options: ["Non", "Oui systématiquement", "Uniquement en cas de délit"],
    answer: "Non",
    explanation: "Convention de Vienne.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Parlementaires",
    question: "Le dépistage d’un parlementaire est possible :",
    options: [
      "En cas de flagrant délit",
      "Jamais",
      "Uniquement avec autorisation écrite",
    ],
    answer: "En cas de flagrant délit",
    explanation: "Article 26 de la Constitution.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Accident corporel",
    question: "Tout accident corporel doit donner lieu à :",
    options: [
      "Un dépistage de stupéfiants",
      "Une audition simple",
      "Une vérification administrative",
    ],
    answer: "Un dépistage de stupéfiants",
    explanation: "Dépistage obligatoire.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Fiche de suivi",
    question: "La fiche de suivi de prélèvement sert à :",
    options: [
      "Garantir la fiabilité des analyses",
      "Identifier le conducteur",
      "Mesurer le taux de stupéfiants",
    ],
    answer: "Garantir la fiabilité des analyses",
    explanation: "Circulaire DACG 10 mai 2017.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Laboratoire",
    question: "L’analyse est réalisée par :",
    options: [
      "Un laboratoire agréé ou expert en toxicologie",
      "L’OPJ",
      "Le médecin urgentiste",
    ],
    answer: "Un laboratoire agréé ou expert en toxicologie",
    explanation: "Article R.235-10 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Usage médical",
    question: "L’usage de médicaments psychoactifs :",
    options: [
      "Peut être recherché sur demande du conducteur",
      "Annule automatiquement la procédure",
      "Est interdit systématiquement",
    ],
    answer: "Peut être recherché sur demande du conducteur",
    explanation: "Droit à l’expertise.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Refus accompagnateur",
    question: "En cas de refus de dépistage par l’accompagnateur :",
    options: [
      "Aucune vérification n’est prévue",
      "Il est placé en garde à vue",
      "Il est verbalisé",
    ],
    answer: "Aucune vérification n’est prévue",
    explanation: "Article L.235-2 al.5 CR.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Finalité",
    question: "L’infraction vise à protéger principalement :",
    options: ["La sécurité routière", "La santé publique", "Le patrimoine"],
    answer: "La sécurité routière",
    explanation: "Prévention des accidents.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Familles",
    question: "Combien de familles de stupéfiants sont recherchées ?",
    options: ["Quatre", "Deux", "Cinq"],
    answer: "Quatre",
    explanation: "Cannabiniques, amphétaminiques, cocaïniques, opiacés.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Nature de la preuve",
    question: "La preuve repose sur :",
    options: [
      "La présence du produit",
      "Le taux précis",
      "Les déclarations du conducteur",
    ],
    answer: "La présence du produit",
    explanation: "Pas de seuil légal.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Usage ancien",
    question: "Un usage ancien mais détecté :",
    options: [
      "Caractérise l’infraction",
      "Écarte l’infraction",
      "Est une excuse légale",
    ],
    answer: "Caractérise l’infraction",
    explanation: "Aucune notion de seuil temporel.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Véhicules concernés",
    question: "Les cycles sont-ils concernés ?",
    options: ["Oui", "Non", "Uniquement en agglomération"],
    answer: "Oui",
    explanation: "Tout véhicule en circulation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — APJ",
    question: "Les APJ peuvent procéder aux vérifications :",
    options: ["Oui", "Non", "Uniquement en présence d’un OPJ"],
    answer: "Oui",
    explanation: "Compétence reconnue.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Procédure irrégulière",
    question:
        "La procédure est irrégulière si le conducteur n’est pas informé :",
    options: [
      "De son droit à expertise",
      "Du lieu du contrôle",
      "De l’identité de l’agent",
    ],
    answer: "De son droit à expertise",
    explanation: "CE 21 novembre 2023.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Finalité pénale",
    question: "Le mobile de l’auteur est :",
    options: ["Indifférent", "Toujours recherché", "Aggravant"],
    answer: "Indifférent",
    explanation: "Jeu, habitude ou contrainte sans effet.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Élément matériel",
    question: "L’élément matériel repose sur :",
    options: [
      "La conduite effective",
      "La détention de stupéfiants",
      "La simple présence dans le véhicule",
    ],
    answer: "La conduite effective",
    explanation: "Lien direct avec la circulation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Accompagnateur",
    question: "L’accompagnateur est poursuivi s’il :",
    options: ["Encadre l’élève conducteur", "Est passager", "Est propriétaire"],
    answer: "Encadre l’élève conducteur",
    explanation: "Responsabilité spécifique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Sanction aggravée",
    question: "La peine est aggravée lorsque :",
    options: [
      "Il y a cumul avec alcool",
      "Le permis est ancien",
      "Le véhicule est loué",
    ],
    answer: "Il y a cumul avec alcool",
    explanation: "Article L.235-1 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Nature juridique",
    question: "L’infraction est classée comme :",
    options: ["Délit routier", "Infraction administrative", "Contravention"],
    answer: "Délit routier",
    explanation: "Sanction pénale.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Effet accident",
    question: "La conduite sous stupéfiants peut constituer :",
    options: [
      "Une circonstance aggravante d’homicide involontaire",
      "Une excuse pénale",
      "Une atténuation de peine",
    ],
    answer: "Une circonstance aggravante d’homicide involontaire",
    explanation: "Articles 221-6-1 et suivants CP.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Assistance médicale",
    question: "Les secours peuvent administrer des substances :",
    options: [
      "À mentionner sur la fiche de suivi",
      "Sans conséquence",
      "Interdites",
    ],
    answer: "À mentionner sur la fiche de suivi",
    explanation: "Impact sur les résultats.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Vérification clinique",
    question: "L’examen clinique est réalisé par :",
    options: ["Un médecin ou interne", "Un OPJ", "Un infirmier seul"],
    answer: "Un médecin ou interne",
    explanation: "Si l’état le permet.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Décès du conducteur",
    question: "En cas de décès, le prélèvement est effectué par :",
    options: ["Un médecin légiste", "Un OPJ", "Un infirmier"],
    answer: "Un médecin légiste",
    explanation: "Procédure spécifique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Choix du prélèvement",
    question: "Le conducteur peut imposer le type de prélèvement :",
    options: ["Non", "Oui", "Uniquement salivaire"],
    answer: "Non",
    explanation: "Choix de l’autorité.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Nature de l’infraction",
    question: "L’infraction est constituée même sans trouble apparent :",
    options: ["Oui", "Non", "Uniquement en cas d’accident"],
    answer: "Oui",
    explanation: "Aucune condition d’altération visible.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Ivresse manifeste — Définition",
    question: "La conduite en état d’ivresse manifeste se caractérise par :",
    options: [
      "Des signes extérieurs d’ivresse indépendamment du taux légal",
      "Un taux d’alcool obligatoirement supérieur au seuil légal",
      "Un refus de dépistage",
    ],
    answer: "Des signes extérieurs d’ivresse indépendamment du taux légal",
    explanation: "Article L.234-1/II du Code de la route.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Ivresse manifeste — Personnes concernées",
    question: "La conduite en état d’ivresse manifeste concerne :",
    options: [
      "Le conducteur et l’accompagnateur d’élève conducteur",
      "Uniquement le conducteur",
      "Uniquement le propriétaire du véhicule",
    ],
    answer: "Le conducteur et l’accompagnateur d’élève conducteur",
    explanation: "Les deux sont expressément visés par le texte.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Ivresse manifeste — Preuve",
    question: "La preuve de l’ivresse manifeste repose principalement sur :",
    options: [
      "Des constatations matérielles",
      "Le taux d’alcool",
      "Les aveux du conducteur",
    ],
    answer: "Des constatations matérielles",
    explanation: "Comportement, haleine, propos, titubation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Ivresse manifeste — Dépistage",
    question: "Un dépistage préalable est-il obligatoire avant vérification ?",
    options: ["Non", "Oui", "Uniquement la nuit"],
    answer: "Non",
    explanation: "Article L.234-6 CR.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Ivresse manifeste — Élément moral",
    question: "L’élément moral est caractérisé par :",
    options: [
      "La volonté de conduire après avoir consommé de l’alcool",
      "La seule consommation d’alcool",
      "Le résultat de l’accident",
    ],
    answer: "La volonté de conduire après avoir consommé de l’alcool",
    explanation: "Cass. crim., 19 décembre 1994.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Ivresse manifeste — Qualification",
    question: "La conduite en état d’ivresse manifeste est un :",
    options: ["Délit", "Crime", "Contravention"],
    answer: "Délit",
    explanation: "Infraction délictuelle.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Ivresse manifeste — Peines",
    question: "La peine principale encourue est :",
    options: [
      "2 ans d’emprisonnement et 4 500 € d’amende",
      "1 an d’emprisonnement",
      "750 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 4 500 € d’amende",
    explanation: "Article L.234-1/II CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Ivresse manifeste — Taux",
    question:
        "Un taux inférieur au seuil légal peut caractériser l’infraction :",
    options: ["Oui", "Non", "Uniquement en récidive"],
    answer: "Oui",
    explanation: "Les signes priment sur le taux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Ivresse manifeste — Tentative",
    question: "La tentative de conduite en état d’ivresse manifeste est :",
    options: ["Non punissable", "Punissable", "Assimilée à une contravention"],
    answer: "Non punissable",
    explanation: "Tentative non prévue.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Ivresse manifeste — Complicité",
    question: "La complicité est :",
    options: ["Punissable", "Impossible", "Limitée aux passagers"],
    answer: "Punissable",
    explanation: "Articles 121-6 et 121-7 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Ivresse manifeste — Immunité",
    question:
        "Les diplomates peuvent être soumis à une vérification alcoolique :",
    options: ["Non", "Oui", "Uniquement sur autorisation"],
    answer: "Non",
    explanation: "Convention de Vienne.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Ivresse manifeste — Parlementaires",
    question: "Le dépistage d’un parlementaire est possible :",
    options: [
      "En cas de flagrant délit",
      "Jamais",
      "Uniquement avec accord écrit",
    ],
    answer: "En cas de flagrant délit",
    explanation: "Article 26 de la Constitution.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "État alcoolique — Définition",
    question:
        "La conduite sous l’empire d’un état alcoolique est caractérisée par :",
    options: [
      "Un taux égal ou supérieur à 0,80 g/L de sang ou 0,40 mg/L d’air",
      "Des signes visibles d’ivresse uniquement",
      "Un refus de contrôle",
    ],
    answer: "Un taux égal ou supérieur à 0,80 g/L de sang ou 0,40 mg/L d’air",
    explanation: "Article L.234-1/I CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Nature",
    question: "La conduite sous l’empire d’un état alcoolique est :",
    options: ["Un délit", "Une contravention", "Une infraction administrative"],
    answer: "Un délit",
    explanation: "Au-delà des seuils légaux.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Élément matériel",
    question: "L’élément matériel repose sur :",
    options: [
      "La concentration mesurée",
      "Les déclarations du conducteur",
      "Les témoins",
    ],
    answer: "La concentration mesurée",
    explanation: "Mesure légale et homologuée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Élément moral",
    question: "L’infraction est intentionnelle :",
    options: ["Oui", "Non", "Uniquement en récidive"],
    answer: "Oui",
    explanation: "Jurisprudence constante.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Dépistage",
    question: "Le dépistage de l’alcoolémie est obligatoire :",
    options: ["En cas d’accident corporel", "Uniquement la nuit", "Jamais"],
    answer: "En cas d’accident corporel",
    explanation: "Article L.234-3 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Refus",
    question:
        "Le refus de se soumettre aux vérifications alcooliques constitue :",
    options: [
      "Un délit autonome",
      "Une circonstance aggravante",
      "Une contravention",
    ],
    answer: "Un délit autonome",
    explanation: "Article L.234-8 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Choix du mode",
    question: "Le conducteur peut choisir le mode de vérification :",
    options: ["Non", "Oui", "Uniquement l’analyse sanguine"],
    answer: "Non",
    explanation: "Choix réservé à l’agent.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "État alcoolique — Éthylomètre",
    question: "La valeur affichée par l’éthylomètre :",
    options: [
      "Constitue une preuve légale",
      "N’a aucune valeur",
      "Doit être confirmée par prise de sang",
    ],
    answer: "Constitue une preuve légale",
    explanation: "Valeur équivalente à l’analyse sanguine.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Marge d’erreur",
    question: "La marge d’erreur doit être :",
    options: [
      "Appliquée obligatoirement",
      "Ignorée",
      "Appliquée uniquement à la demande",
    ],
    answer: "Appliquée obligatoirement",
    explanation: "Cass. crim., 26 mars 2019.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Contravention",
    question: "Un taux compris entre 0,50 et 0,80 g/L caractérise :",
    options: ["Une contravention", "Un délit", "Une absence d’infraction"],
    answer: "Une contravention",
    explanation: "Article R.234-1 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Conducteurs spécifiques",
    question: "Un seuil abaissé s’applique notamment aux :",
    options: [
      "Conducteurs probatoires",
      "Conducteurs de plus de 65 ans",
      "Motocyclistes",
    ],
    answer: "Conducteurs probatoires",
    explanation: "Seuil contraventionnel spécifique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Tentative",
    question:
        "La tentative de conduite sous l’empire d’un état alcoolique est :",
    options: ["Non punissable", "Punissable", "Assimilée à une contravention"],
    answer: "Non punissable",
    explanation: "Tentative non prévue.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "État alcoolique — Complicité",
    question: "La complicité est :",
    options: ["Punissable", "Exclue", "Limitée au propriétaire"],
    answer: "Punissable",
    explanation: "Articles 121-6 et 121-7 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Finalité",
    question: "L’objectif principal de l’incrimination est :",
    options: ["La sécurité routière", "La santé individuelle", "La fiscalité"],
    answer: "La sécurité routière",
    explanation: "Prévention des accidents.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Accident",
    question: "La conduite alcoolisée peut aggraver :",
    options: ["Un homicide involontaire", "Un vol", "Une escroquerie"],
    answer: "Un homicide involontaire",
    explanation: "Articles 221-6-1 et suivants CP.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "État alcoolique — Absence de signes",
    question: "L’infraction peut être constituée sans signe apparent :",
    options: ["Oui", "Non", "Uniquement en récidive"],
    answer: "Oui",
    explanation: "Le taux suffit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Véhicules",
    question: "Les cycles sont concernés par la conduite alcoolisée :",
    options: ["Oui", "Non", "Uniquement en agglomération"],
    answer: "Oui",
    explanation: "Tous véhicules en circulation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — APJA",
    question: "Les APJA peuvent intervenir :",
    options: [
      "Sous l’ordre et la responsabilité d’un OPJ",
      "De manière autonome",
      "Uniquement en présence d’un juge",
    ],
    answer: "Sous l’ordre et la responsabilité d’un OPJ",
    explanation: "Règles de compétence.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "État alcoolique — Deuxième contrôle",
    question: "Un second contrôle est :",
    options: [
      "De droit s’il est demandé",
      "Interdit",
      "Optionnel pour l’agent",
    ],
    answer: "De droit s’il est demandé",
    explanation: "Article L.234-5 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Refus persistant",
    question: "Le refus persistant entraîne :",
    options: [
      "La qualification de refus de vérification",
      "Une simple amende",
      "La nullité de la procédure",
    ],
    answer: "La qualification de refus de vérification",
    explanation: "Article L.234-8 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "État alcoolique — Responsabilité",
    question: "Le propriétaire du véhicule est poursuivi :",
    options: ["Seulement s’il conduisait", "Toujours", "Jamais"],
    answer: "Seulement s’il conduisait",
    explanation: "Responsabilité personnelle.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Définition",
    question: "La conduite après usage de stupéfiants est constituée lorsque :",
    options: [
      "Une analyse révèle la présence de stupéfiants",
      "Le conducteur reconnaît avoir consommé",
      "Des signes physiques sont observés",
    ],
    answer: "Une analyse révèle la présence de stupéfiants",
    explanation:
        "Article L.235-1/I du Code de la route : seule la présence suffit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Personnes concernées",
    question: "Sont concernés par cette infraction :",
    options: [
      "Le conducteur et l’accompagnateur d’élève conducteur",
      "Uniquement le conducteur",
      "Uniquement les professionnels",
    ],
    answer: "Le conducteur et l’accompagnateur d’élève conducteur",
    explanation: "Les deux sont expressément visés par le texte.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Élément légal",
    question: "Le texte applicable est :",
    options: [
      "L.235-1/I du Code de la route",
      "L.234-1 du Code de la route",
      "321-1 du Code pénal",
    ],
    answer: "L.235-1/I du Code de la route",
    explanation: "Article spécifique à l’usage de stupéfiants.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Dépistage",
    question: "Le dépistage peut être réalisé :",
    options: [
      "Par recueil salivaire ou urinaire",
      "Uniquement par prise de sang",
      "Uniquement par observation",
    ],
    answer: "Par recueil salivaire ou urinaire",
    explanation: "Recherche initiale de substances.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Refus",
    question: "Le refus de dépistage :",
    options: [
      "N’est pas une infraction",
      "Constitue un délit",
      "Met fin au contrôle",
    ],
    answer: "N’est pas une infraction",
    explanation: "Mais il entraîne des vérifications obligatoires.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Vérifications",
    question: "En cas de dépistage positif, il est procédé :",
    options: [
      "À des vérifications biologiques",
      "À une simple amende",
      "À une immobilisation automatique",
    ],
    answer: "À des vérifications biologiques",
    explanation: "Analyse salivaire ou sanguine.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Refus de vérification",
    question: "Le refus de se soumettre aux vérifications constitue :",
    options: ["Un délit", "Une contravention", "Une simple faute"],
    answer: "Un délit",
    explanation: "Article L.235-3 du Code de la route.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Dosage",
    question: "L’analyse toxicologique doit indiquer :",
    options: [
      "La présence ou non de stupéfiants",
      "Le taux exact",
      "La durée de consommation",
    ],
    answer: "La présence ou non de stupéfiants",
    explanation: "Le dosage n’est plus exigé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Élément moral",
    question: "L’infraction est :",
    options: ["Intentionnelle", "Non intentionnelle", "Purement matérielle"],
    answer: "Intentionnelle",
    explanation: "Volonté de conduire après usage.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Alcool",
    question: "La présence concomitante d’alcool :",
    options: ["Aggrave les peines", "Annule la procédure", "Est sans effet"],
    answer: "Aggrave les peines",
    explanation: "Circonstance aggravante prévue par la loi.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Accident",
    question: "Un accident mortel implique :",
    options: [
      "Un dépistage obligatoire",
      "Un dépistage facultatif",
      "Aucun dépistage",
    ],
    answer: "Un dépistage obligatoire",
    explanation: "Principe de systématicité.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Tentative",
    question: "La tentative est :",
    options: ["Non punissable", "Punissable", "Assimilée au délit"],
    answer: "Non punissable",
    explanation: "Tentative non prévue.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Complicité",
    question: "La complicité est :",
    options: ["Punissable", "Impossible", "Limitée aux passagers"],
    answer: "Punissable",
    explanation: "Articles 121-6 et 121-7 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Peines",
    question: "La peine principale encourue est :",
    options: [
      "2 ans d’emprisonnement et 4 500 € d’amende",
      "1 an d’emprisonnement",
      "750 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 4 500 € d’amende",
    explanation: "Article L.235-1 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Aggravation",
    question: "Les peines sont portées à 3 ans si :",
    options: ["Alcool + stupéfiants", "Récidive simple", "Véhicule lourd"],
    answer: "Alcool + stupéfiants",
    explanation: "Circonstance aggravante.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Immunité",
    question: "Les diplomates peuvent être dépistés :",
    options: ["Non", "Oui", "Uniquement sur réquisition"],
    answer: "Non",
    explanation: "Convention de Vienne.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Parlementaires",
    question: "Un parlementaire peut être dépisté :",
    options: [
      "En cas de flagrant délit",
      "Jamais",
      "Uniquement avec accord écrit",
    ],
    answer: "En cas de flagrant délit",
    explanation: "Article 26 de la Constitution.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Véhicules",
    question: "Sont concernés :",
    options: [
      "Tous les véhicules",
      "Uniquement les véhicules à moteur",
      "Uniquement les voitures",
    ],
    answer: "Tous les véhicules",
    explanation: "Y compris cycles et traction animale.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Laboratoire",
    question: "Les analyses sont réalisées par :",
    options: [
      "Un laboratoire agréé ou expert",
      "Les forces de l’ordre",
      "Le procureur",
    ],
    answer: "Un laboratoire agréé ou expert",
    explanation: "Garantie de fiabilité.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Fiche de suivi",
    question: "La fiche de suivi sert à :",
    options: [
      "Garantir la fiabilité des résultats",
      "Calculer la peine",
      "Identifier le conducteur",
    ],
    answer: "Garantir la fiabilité des résultats",
    explanation: "Circulaire DACG du 10 mai 2017.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Objectif",
    question: "L’objectif principal est :",
    options: [
      "La sécurité routière",
      "La répression fiscale",
      "La prévention sanitaire",
    ],
    answer: "La sécurité routière",
    explanation: "Protection des usagers.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Élément matériel",
    question: "L’élément matériel repose sur :",
    options: [
      "La conduite et la présence de stupéfiants",
      "Le comportement",
      "Les aveux",
    ],
    answer: "La conduite et la présence de stupéfiants",
    explanation: "Deux conditions cumulatives.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Refus d’expertise",
    question: "Le conducteur peut demander une expertise :",
    options: ["Oui", "Non", "Uniquement par avocat"],
    answer: "Oui",
    explanation: "Droit à contre-expertise.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Omission d’information",
    question: "L’absence d’information sur ce droit rend la procédure :",
    options: ["Irrégulière", "Valide", "Partiellement nulle"],
    answer: "Irrégulière",
    explanation: "CE, 21 novembre 2023.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Nature",
    question: "Cette infraction est :",
    options: ["Un délit", "Une contravention", "Un crime"],
    answer: "Un délit",
    explanation: "Qualification pénale.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Responsabilité",
    question: "La responsabilité est :",
    options: ["Personnelle", "Collective", "Civile uniquement"],
    answer: "Personnelle",
    explanation: "Principe pénal.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — APJA",
    question: "Les APJA peuvent procéder au dépistage :",
    options: [
      "Sous ordre et responsabilité d’un OPJ",
      "De manière autonome",
      "Uniquement en cas d’accident",
    ],
    answer: "Sous ordre et responsabilité d’un OPJ",
    explanation: "Règles de compétence.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Décès",
    question: "En cas de décès du conducteur :",
    options: [
      "Seul le prélèvement sanguin est possible",
      "Aucune vérification",
      "Dépistage salivaire",
    ],
    answer: "Seul le prélèvement sanguin est possible",
    explanation: "Article R.235-8 CR.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Refus et accompagnateur",
    question: "Le refus de dépistage par l’accompagnateur :",
    options: [
      "N’entraîne pas de vérification",
      "Constitue un délit",
      "Met fin à l’enquête",
    ],
    answer: "N’entraîne pas de vérification",
    explanation: "Article L.235-2 al.5 CR.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Causalité",
    question: "Il est nécessaire de prouver une influence sur la conduite :",
    options: ["Non", "Oui", "Uniquement en cas d’accident"],
    answer: "Non",
    explanation: "La seule présence suffit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Prescription",
    question: "L’infraction est poursuivie comme :",
    options: [
      "Un délit routier",
      "Une infraction administrative",
      "Une contravention",
    ],
    answer: "Un délit routier",
    explanation: "Règles de prescription délictuelle.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Finalité",
    question: "La suppression du dosage vise à :",
    options: [
      "Simplifier la preuve",
      "Augmenter les poursuites",
      "Réduire les sanctions",
    ],
    answer: "Simplifier la preuve",
    explanation: "Présence suffit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Principe",
    question: "Cette infraction repose sur un principe de :",
    options: ["Tolérance zéro", "Proportionnalité", "Excuse médicale"],
    answer: "Tolérance zéro",
    explanation: "Aucun seuil légal admis.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conduite après usage de stupéfiants — Conclusion",
    question: "Le comportement sanctionné est :",
    options: [
      "La conduite après usage",
      "La consommation seule",
      "La détention de stupéfiants",
    ],
    answer: "La conduite après usage",
    explanation: "Lien direct avec la conduite.",
    difficulty: "Facile",
  ),

  // =========================================================
  // CONDUITE APRÈS USAGE DE STUPÉFIANTS / ALCOOL / CONTRÔLES
  // SÉRIE 2 — QUESTIONS 51 À 100
  // =========================================================
  const QuizQuestion(
    category: "Stupéfiants — Cas obligatoire",
    question:
        "Dans quel cas le dépistage de stupéfiants est-il obligatoirement réalisé ?",
    options: [
      "Accident mortel ou corporel",
      "Accident matériel",
      "Contrôle aléatoire simple",
    ],
    answer: "Accident mortel ou corporel",
    explanation:
        "Article L.235-2 du Code de la route : dépistage obligatoire en cas d'accident mortel ou corporel.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Cas facultatif",
    question: "Le dépistage de stupéfiants est facultatif lorsque :",
    options: [
      "Il existe une infraction routière",
      "Il y a un accident corporel",
      "Il y a décès",
    ],
    answer: "Il existe une infraction routière",
    explanation:
        "Le dépistage peut être décidé en cas d'infraction routière ou d'accident matériel.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Préventif",
    question: "Un dépistage préventif de stupéfiants peut être réalisé :",
    options: [
      "Sur réquisition du procureur ou à l’initiative de l’OPJ",
      "Uniquement après accident",
      "Uniquement sur ordre judiciaire",
    ],
    answer: "Sur réquisition du procureur ou à l’initiative de l’OPJ",
    explanation: "Article L.235-2 du Code de la route.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Impossibilité",
    question: "Le dépistage est impossible notamment en cas :",
    options: [
      "De blessures graves ou de décès",
      "De refus simple",
      "D’absence de matériel",
    ],
    answer: "De blessures graves ou de décès",
    explanation:
        "Dans ces cas, seules les vérifications biologiques sont possibles.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Vérification",
    question: "Les vérifications après dépistage positif consistent en :",
    options: [
      "Analyses biologiques",
      "Observation comportementale",
      "Audition seule",
    ],
    answer: "Analyses biologiques",
    explanation: "Article L.235-2 du Code de la route.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Prélèvement salivaire",
    question: "Le prélèvement salivaire est réalisé :",
    options: [
      "Par le conducteur sous contrôle d’un OPJ/APJ",
      "Par un médecin uniquement",
      "Par le laboratoire directement",
    ],
    answer: "Par le conducteur sous contrôle d’un OPJ/APJ",
    explanation: "Article R.235-6 du Code de la route.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Contre-expertise",
    question:
        "Après un prélèvement salivaire, le conducteur doit être informé :",
    options: [
      "De la possibilité de demander une expertise",
      "Du montant de l’amende",
      "De la durée de suspension du permis",
    ],
    answer: "De la possibilité de demander une expertise",
    explanation: "Omission = procédure irrégulière (CE, 21 novembre 2023).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Prélèvement sanguin",
    question: "Le prélèvement sanguin est effectué par :",
    options: [
      "Un professionnel de santé requis",
      "Un OPJ",
      "Le conducteur lui-même",
    ],
    answer: "Un professionnel de santé requis",
    explanation: "Médecin, interne, étudiant autorisé ou infirmier.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Accident mortel",
    question: "En cas d'accident mortel, la preuve est établie par :",
    options: [
      "Analyse sanguine uniquement",
      "Analyse salivaire",
      "Dépistage simple",
    ],
    answer: "Analyse sanguine uniquement",
    explanation: "Article R.235-8 du Code de la route.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Dosage",
    question: "L'analyse toxicologique doit préciser :",
    options: [
      "La présence ou l'absence de stupéfiants",
      "Le taux précis",
      "La durée de consommation",
    ],
    answer: "La présence ou l'absence de stupéfiants",
    explanation: "La notion de dosage a été supprimée par décret.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Élément intentionnel",
    question: "L’élément moral est caractérisé par :",
    options: [
      "La volonté de conduire après usage",
      "La seule présence de stupéfiants",
      "Le refus de contrôle",
    ],
    answer: "La volonté de conduire après usage",
    explanation: "Infraction intentionnelle.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Seuil",
    question: "Concernant les stupéfiants, le seuil légal est :",
    options: ["Inexistant", "Fixé par décret", "Variable selon la substance"],
    answer: "Inexistant",
    explanation: "Principe de tolérance zéro.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Causalité",
    question: "Faut-il prouver une altération de la conduite ?",
    options: ["Non", "Oui", "Uniquement en cas d'accident"],
    answer: "Non",
    explanation: "La seule présence suffit à caractériser l'infraction.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Qualification",
    question: "La conduite après usage de stupéfiants est :",
    options: ["Un délit", "Une contravention", "Une infraction administrative"],
    answer: "Un délit",
    explanation: "Article L.235-1 du Code de la route.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Peine simple",
    question: "La peine encourue est de :",
    options: [
      "2 ans d’emprisonnement et 4 500 € d’amende",
      "1 an et 3 750 €",
      "750 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 4 500 € d’amende",
    explanation: "Peines principales prévues par la loi.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Alcool + stupéfiants",
    question: "La présence simultanée d’alcool constitue :",
    options: [
      "Une circonstance aggravante",
      "Une infraction distincte uniquement",
      "Une excuse",
    ],
    answer: "Une circonstance aggravante",
    explanation: "Article L.235-1 du Code de la route.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Peine aggravée",
    question: "En cas de cumul alcool + stupéfiants, la peine maximale est :",
    options: [
      "3 ans d’emprisonnement",
      "2 ans d’emprisonnement",
      "5 ans d’emprisonnement",
    ],
    answer: "3 ans d’emprisonnement",
    explanation: "Peine aggravée prévue par le Code de la route.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Tentative",
    question: "La tentative de conduite après usage de stupéfiants est :",
    options: ["Non punissable", "Punissable", "Assimilée au délit"],
    answer: "Non punissable",
    explanation: "Tentative non prévue par les textes.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Complicité",
    question: "La complicité de cette infraction est :",
    options: ["Punissable", "Impossible", "Limitée aux passagers"],
    answer: "Punissable",
    explanation: "Articles 121-6 et 121-7 du Code pénal.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Immunité diplomatique",
    question: "Un diplomate peut faire l’objet d’un dépistage :",
    options: ["Non", "Oui", "Uniquement avec autorisation"],
    answer: "Non",
    explanation: "Convention de Vienne sur les relations diplomatiques.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Immunité parlementaire",
    question: "Un parlementaire peut être dépisté :",
    options: [
      "En cas de flagrant délit",
      "Jamais",
      "Uniquement après autorisation écrite",
    ],
    answer: "En cas de flagrant délit",
    explanation: "Article 26 de la Constitution.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Véhicules",
    question: "L’infraction concerne :",
    options: [
      "Tous les véhicules",
      "Uniquement les véhicules à moteur",
      "Uniquement les voitures",
    ],
    answer: "Tous les véhicules",
    explanation: "Y compris cycles et véhicules à traction animale.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Accompagnateur",
    question: "L’accompagnateur d’un élève conducteur est :",
    options: [
      "Pénalement responsable",
      "Exempté",
      "Responsable civile uniquement",
    ],
    answer: "Pénalement responsable",
    explanation: "Il est expressément visé par le texte.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Refus accompagnateur",
    question: "En cas de refus de dépistage par l’accompagnateur :",
    options: [
      "Aucune vérification n’est prévue",
      "Une vérification est obligatoire",
      "Il est interpellé",
    ],
    answer: "Aucune vérification n’est prévue",
    explanation: "Spécificité prévue par l'article L.235-2.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Stupéfiants — Finalité",
    question: "La finalité de l’infraction est principalement :",
    options: [
      "La sécurité routière",
      "La lutte contre le trafic",
      "La santé publique",
    ],
    answer: "La sécurité routière",
    explanation: "Protection des usagers de la route.",
    difficulty: "Facile",
  ),

  // =========================================================
  // ALCOOLÉMIE — CONDUITE SOUS EMPIRE / IVRESSE MANIFESTE
  // QUESTIONS 1 À 100
  // =========================================================

  // ---------- DÉFINITIONS / TEXTES ----------
  const QuizQuestion(
    category: "Alcoolémie — Définition",
    question:
        "La conduite sous l’empire d’un état alcoolique est constituée lorsque :",
    options: [
      "Le taux est ≥ 0,80 g/L de sang ou 0,40 mg/L d’air expiré",
      "Des signes d’ivresse sont constatés",
      "Le conducteur reconnaît avoir bu",
    ],
    answer: "Le taux est ≥ 0,80 g/L de sang ou 0,40 mg/L d’air expiré",
    explanation: "Article L.234-1 I du Code de la route.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Alcoolémie — Texte",
    question: "La conduite sous l’empire d’un état alcoolique est prévue par :",
    options: [
      "Article L.234-1 I du Code de la route",
      "Article L.235-1 du Code de la route",
      "Article 222-14 du Code pénal",
    ],
    answer: "Article L.234-1 I du Code de la route",
    explanation: "Texte spécifique à l’alcoolémie délictuelle.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Ivresse manifeste — Définition",
    question: "L’ivresse manifeste se caractérise par :",
    options: [
      "Des signes extérieurs d’alcoolisation",
      "Un taux légal obligatoire",
      "Une expertise médicale systématique",
    ],
    answer: "Des signes extérieurs d’alcoolisation",
    explanation: "L’ivresse manifeste est indépendante du taux.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Ivresse manifeste — Texte",
    question: "L’ivresse manifeste est prévue par :",
    options: [
      "Article L.234-1 II du Code de la route",
      "Article R.234-1 du Code de la route",
      "Article 121-3 du Code pénal",
    ],
    answer: "Article L.234-1 II du Code de la route",
    explanation: "Infraction délictuelle autonome.",
    difficulty: "Facile",
  ),

  // ---------- ÉLÉMENT MATÉRIEL ----------
  const QuizQuestion(
    category: "Alcoolémie — Élément matériel",
    question: "L’élément matériel repose sur :",
    options: [
      "La conduite + un taux ≥ seuil légal",
      "La consommation d’alcool seule",
      "L’aveu du conducteur",
    ],
    answer: "La conduite + un taux ≥ seuil légal",
    explanation: "Deux conditions cumulatives.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Ivresse manifeste — Preuve",
    question: "La preuve de l’ivresse manifeste repose sur :",
    options: [
      "Les constatations matérielles",
      "Un taux précis",
      "Un dépistage obligatoire",
    ],
    answer: "Les constatations matérielles",
    explanation: "Haleine, titubation, propos incohérents, etc.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Alcoolémie — Mise en mouvement",
    question: "La conduite est caractérisée dès lors que le conducteur :",
    options: [
      "Met le contact et enclenche une vitesse",
      "Démarre effectivement",
      "Quitte le stationnement",
    ],
    answer: "Met le contact et enclenche une vitesse",
    explanation: "Cass. crim., 23 mars 1994.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Alcoolémie — Véhicule arrêté",
    question: "Un conducteur sorti de son véhicule peut être poursuivi si :",
    options: [
      "Il est prouvé qu’il a conduit alcoolisé",
      "Le véhicule est à l’arrêt",
      "Il dort dans sa voiture",
    ],
    answer: "Il est prouvé qu’il a conduit alcoolisé",
    explanation: "Cass. crim., 7 mars 1989.",
    difficulty: "Difficile",
  ),

  // ---------- CONTRÔLES ----------
  const QuizQuestion(
    category: "Alcoolémie — Recherche obligatoire",
    question: "La recherche de l’alcoolémie est obligatoire :",
    options: [
      "Après accident corporel",
      "Après accident matériel",
      "Lors d’un contrôle préventif",
    ],
    answer: "Après accident corporel",
    explanation: "Article L.234-3 du Code de la route.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Alcoolémie — Recherche facultative",
    question: "La recherche est facultative en cas :",
    options: ["D’accident matériel", "D’accident corporel", "De délit routier"],
    answer: "D’accident matériel",
    explanation: "Article L.234-3 al.2 CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Alcoolémie — Préventif",
    question: "Un contrôle préventif peut être réalisé :",
    options: [
      "Sans infraction préalable",
      "Uniquement après infraction",
      "Uniquement sur commission rogatoire",
    ],
    answer: "Sans infraction préalable",
    explanation: "Article L.234-9 CR.",
    difficulty: "Moyenne",
  ),

  // ---------- DÉPISTAGE / VÉRIFICATION ----------
  const QuizQuestion(
    category: "Alcoolémie — Dépistage",
    question: "Le dépistage s’effectue à l’aide :",
    options: ["D’un éthylotest", "D’un éthylomètre", "D’une prise de sang"],
    answer: "D’un éthylotest",
    explanation: "Phase préalable.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Alcoolémie — Vérification",
    question: "La vérification est réalisée par :",
    options: [
      "Éthylomètre ou analyse sanguine",
      "Éthylotest uniquement",
      "Expertise médicale obligatoire",
    ],
    answer: "Éthylomètre ou analyse sanguine",
    explanation: "Article L.234-4 CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Alcoolémie — Choix",
    question: "Le choix du mode de vérification appartient :",
    options: ["Aux forces de l’ordre", "Au conducteur", "Au médecin"],
    answer: "Aux forces de l’ordre",
    explanation: "Le conducteur ne peut imposer une prise de sang.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Alcoolémie — Refus",
    question: "Le refus de se soumettre aux vérifications constitue :",
    options: [
      "Un délit autonome",
      "Une contravention",
      "Une circonstance aggravante",
    ],
    answer: "Un délit autonome",
    explanation: "Article L.234-8 du Code de la route.",
    difficulty: "Facile",
  ),

  // ---------- TAUX / PIÈGES ----------
  const QuizQuestion(
    category: "Alcoolémie — Seuil délictuel",
    question: "Le seuil délictuel est fixé à :",
    options: ["0,80 g/L de sang", "0,50 g/L de sang", "0,20 g/L de sang"],
    answer: "0,80 g/L de sang",
    explanation: "Article L.234-1 CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Alcoolémie — Seuil contraventionnel",
    question: "Pour un conducteur classique, le seuil contraventionnel est :",
    options: ["0,50 g/L de sang", "0,80 g/L de sang", "0,20 g/L de sang"],
    answer: "0,50 g/L de sang",
    explanation: "Article R.234-1 CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Alcoolémie — Permis probatoire",
    question: "Pour un conducteur en permis probatoire, le seuil est :",
    options: ["0,20 g/L", "0,50 g/L", "0,80 g/L"],
    answer: "0,20 g/L",
    explanation: "Tolérance quasi nulle.",
    difficulty: "Facile",
  ),

  // ---------- PEINES ----------
  const QuizQuestion(
    category: "Alcoolémie — Peines",
    question: "La conduite sous empire d’un état alcoolique est punie de :",
    options: [
      "2 ans d’emprisonnement et 4 500 € d’amende",
      "1 an et 3 750 €",
      "750 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 4 500 € d’amende",
    explanation: "Article L.234-1 CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Ivresse manifeste — Peines",
    question: "La conduite en état d’ivresse manifeste est punie de :",
    options: [
      "2 ans d’emprisonnement et 4 500 € d’amende",
      "1 an et 1 500 €",
      "Contravention",
    ],
    answer: "2 ans d’emprisonnement et 4 500 € d’amende",
    explanation: "Même régime que l’alcoolémie délictuelle.",
    difficulty: "Facile",
  ),

  // ---------- ULTRA PIÈGES ----------
  const QuizQuestion(
    category: "Alcoolémie — Piège concours",
    question: "Un taux inférieur au seuil légal exclut l’ivresse manifeste :",
    options: ["Faux", "Vrai", "Uniquement si expertise"],
    answer: "Faux",
    explanation: "L’ivresse manifeste est indépendante du taux.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Alcoolémie — Piège concours",
    question: "Un conducteur peut choisir entre éthylomètre et prise de sang :",
    options: ["Faux", "Vrai", "Uniquement en garde à vue"],
    answer: "Faux",
    explanation: "Choix réservé aux forces de l’ordre.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // REFUS — OBTEMPÉRER / VÉRIFICATIONS / ALCOOL / STUPÉFIANTS
  // QUESTIONS 101 À 200
  // =========================================================

  // ---------- REFUS DE SE SOUMETTRE AUX VÉRIFICATIONS ----------
  const QuizQuestion(
    category: "Refus de vérifications — Définition",
    question:
        "Constitue un refus de se soumettre aux vérifications le fait de :",
    options: [
      "Ne pas obéir volontairement aux injonctions de contrôle",
      "Contester verbalement le contrôle",
      "Demander un avocat",
    ],
    answer: "Ne pas obéir volontairement aux injonctions de contrôle",
    explanation: "Article L.233-2 du Code de la route.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus de vérifications — Texte",
    question: "Le refus de se soumettre aux vérifications est prévu par :",
    options: [
      "Article L.233-2 du Code de la route",
      "Article L.234-8 du Code de la route",
      "Article L.235-3 du Code de la route",
    ],
    answer: "Article L.233-2 du Code de la route",
    explanation: "Hors alcool et stupéfiants.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus de vérifications — Nature",
    question: "Le refus de se soumettre aux vérifications constitue :",
    options: [
      "Un délit autonome",
      "Une contravention",
      "Une circonstance aggravante",
    ],
    answer: "Un délit autonome",
    explanation: "Infraction indépendante.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus de vérifications — Objet",
    question: "Les vérifications peuvent porter sur :",
    options: [
      "Le permis et les documents du véhicule",
      "Uniquement le permis",
      "Uniquement le véhicule",
    ],
    answer: "Le permis et les documents du véhicule",
    explanation: "Articles R.233-1 et R.233-3 CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus de vérifications — Mode",
    question: "Le refus peut être caractérisé par :",
    options: [
      "Un refus verbal ou passif",
      "Un refus écrit uniquement",
      "Une fuite du véhicule uniquement",
    ],
    answer: "Un refus verbal ou passif",
    explanation: "Le refus passif suffit.",
    difficulty: "Moyenne",
  ),

  // ---------- REFUS ALCOOLÉMIE ----------
  const QuizQuestion(
    category: "Refus alcool — Texte",
    question:
        "Le refus de se soumettre aux vérifications d’alcoolémie est prévu par :",
    options: [
      "Article L.234-8 du Code de la route",
      "Article L.233-2 du Code de la route",
      "Article L.235-3 du Code de la route",
    ],
    answer: "Article L.234-8 du Code de la route",
    explanation: "Infraction spécifique.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus alcool — Nature",
    question: "Le refus de se soumettre aux vérifications d’alcoolémie est :",
    options: [
      "Un délit autonome",
      "Une circonstance aggravante",
      "Une contravention",
    ],
    answer: "Un délit autonome",
    explanation: "Indépendant de la conduite alcoolisée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus alcool — Élément matériel",
    question: "L’élément matériel du refus d’alcoolémie repose sur :",
    options: [
      "Le refus volontaire des vérifications",
      "Le dépassement du taux",
      "La présence de signes d’ivresse",
    ],
    answer: "Le refus volontaire des vérifications",
    explanation: "Peu importe le taux réel.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus alcool — Élément moral",
    question: "L’élément moral du refus d’alcoolémie est :",
    options: ["Intentionnel", "Non intentionnel", "Présumé"],
    answer: "Intentionnel",
    explanation: "Volonté consciente de refuser.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus alcool — Peines",
    question:
        "Le refus de se soumettre aux vérifications d’alcoolémie est puni de :",
    options: [
      "2 ans d’emprisonnement et 4 500 € d’amende",
      "3 mois et 3 750 €",
      "750 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 4 500 € d’amende",
    explanation: "Article L.234-8 CR.",
    difficulty: "Facile",
  ),

  // ---------- REFUS STUPÉFIANTS ----------
  const QuizQuestion(
    category: "Refus stupéfiants — Texte",
    question:
        "Le refus de se soumettre aux vérifications stupéfiants est prévu par :",
    options: [
      "Article L.235-3 du Code de la route",
      "Article L.233-2 du Code de la route",
      "Article L.234-8 du Code de la route",
    ],
    answer: "Article L.235-3 du Code de la route",
    explanation: "Texte autonome.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus stupéfiants — Nature",
    question: "Le refus de vérification stupéfiants constitue :",
    options: ["Un délit", "Une contravention", "Une circonstance aggravante"],
    answer: "Un délit",
    explanation: "Infraction autonome.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus stupéfiants — Élément matériel",
    question: "L’élément matériel du refus stupéfiants repose sur :",
    options: [
      "Le refus de prélèvement",
      "La positivité du test",
      "La conduite dangereuse",
    ],
    answer: "Le refus de prélèvement",
    explanation: "Refus salivaire ou sanguin.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus stupéfiants — Peines",
    question: "Le refus de vérification stupéfiants est puni de :",
    options: [
      "2 ans d’emprisonnement et 4 500 € d’amende",
      "3 ans et 6 000 €",
      "750 €",
    ],
    answer: "2 ans d’emprisonnement et 4 500 € d’amende",
    explanation: "Article L.235-3 CR.",
    difficulty: "Facile",
  ),

  // ---------- REFUS D’OBTEMPÉRER ----------
  const QuizQuestion(
    category: "Refus d’obtempérer — Définition",
    question: "Le refus d’obtempérer est :",
    options: [
      "Le fait de ne pas s’arrêter malgré une sommation",
      "Le fait de contester un contrôle",
      "Le fait de refuser de présenter ses papiers",
    ],
    answer: "Le fait de ne pas s’arrêter malgré une sommation",
    explanation: "Article L.233-1 CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus d’obtempérer — Agents",
    question: "La sommation doit émaner :",
    options: [
      "D’un agent identifiable",
      "De tout citoyen",
      "Uniquement d’un OPJ",
    ],
    answer: "D’un agent identifiable",
    explanation: "Insignes apparents exigés.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Refus d’obtempérer — Forme",
    question: "La sommation d’arrêt peut être faite :",
    options: [
      "Par gestes ou signaux",
      "Uniquement verbalement",
      "Uniquement par écrit",
    ],
    answer: "Par gestes ou signaux",
    explanation: "La forme importe peu.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus d’obtempérer — Auteur",
    question: "Le refus d’obtempérer ne peut être reproché qu’à :",
    options: ["Le conducteur", "Les passagers", "Le propriétaire"],
    answer: "Le conducteur",
    explanation: "Les passagers peuvent être complices.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus d’obtempérer — Élément moral",
    question: "L’élément moral du refus d’obtempérer est :",
    options: ["La volonté de ne pas obéir", "La peur", "L’imprudence"],
    answer: "La volonté de ne pas obéir",
    explanation: "Refus intentionnel.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus d’obtempérer — Peines simples",
    question: "Le refus d’obtempérer simple est puni de :",
    options: [
      "2 ans d’emprisonnement et 15 000 € d’amende",
      "3 ans et 45 000 €",
      "750 €",
    ],
    answer: "2 ans d’emprisonnement et 15 000 € d’amende",
    explanation: "Article L.233-1 CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus d’obtempérer — Aggravation",
    question: "Le refus d’obtempérer est aggravé lorsque :",
    options: [
      "Il expose autrui à un risque de mort",
      "Il est nocturne",
      "Il dure plus de 5 minutes",
    ],
    answer: "Il expose autrui à un risque de mort",
    explanation: "Article L.233-1-1 CR.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Refus d’obtempérer — Ultra piège",
    question:
        "Foncer sur les forces de l’ordre constitue un refus d’obtempérer :",
    options: ["Faux", "Vrai", "Uniquement si blessure"],
    answer: "Faux",
    explanation: "Qualification violences volontaires aggravées.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Refus — Cumul",
    question: "Les peines du refus d’obtempérer peuvent se cumuler avec :",
    options: [
      "Les autres infractions routières",
      "Une seule infraction",
      "Aucune autre",
    ],
    answer: "Les autres infractions routières",
    explanation: "Cumul sans confusion.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // DÉLIT DE FUITE — QUESTIONS 201 À 300
  // =========================================================

  // ---------- DÉFINITION & TEXTE ----------
  const QuizQuestion(
    category: "Délit de fuite — Définition",
    question: "Le délit de fuite est constitué lorsque le conducteur :",
    options: [
      "Ne s’arrête pas après avoir causé ou occasionné un accident",
      "Quitte les lieux après un simple contrôle",
      "Refuse de présenter ses papiers",
    ],
    answer: "Ne s’arrête pas après avoir causé ou occasionné un accident",
    explanation: "Articles 434-10 CP et L.231-1 CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Texte",
    question: "Le délit de fuite est prévu par :",
    options: [
      "Article 434-10 du Code pénal",
      "Article L.233-1 du Code de la route",
      "Article L.234-8 du Code de la route",
    ],
    answer: "Article 434-10 du Code pénal",
    explanation: "Répression pénale du délit de fuite.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Nature",
    question: "Le délit de fuite est une infraction :",
    options: ["Intentionnelle", "Non intentionnelle", "Contraventionnelle"],
    answer: "Intentionnelle",
    explanation: "Volonté de se soustraire à une responsabilité.",
    difficulty: "Facile",
  ),

  // ---------- AUTEUR & VÉHICULE ----------
  const QuizQuestion(
    category: "Délit de fuite — Auteur",
    question: "Qui peut être auteur du délit de fuite ?",
    options: ["Tout conducteur", "Uniquement un automobiliste", "Un piéton"],
    answer: "Tout conducteur",
    explanation: "Routier, fluvial, maritime, aérien.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Véhicules",
    question: "Le délit de fuite s’applique aux véhicules :",
    options: [
      "Terrestres, fluviaux, maritimes et aériens",
      "Uniquement terrestres",
      "Uniquement motorisés",
    ],
    answer: "Terrestres, fluviaux, maritimes et aériens",
    explanation: "Extension large de l’infraction.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Piège",
    question: "Un piéton peut commettre un délit de fuite :",
    options: ["Faux", "Vrai", "Uniquement en cas de blessure"],
    answer: "Faux",
    explanation: "Le délit vise les conducteurs.",
    difficulty: "Difficile",
  ),

  // ---------- ACCIDENT ----------
  const QuizQuestion(
    category: "Délit de fuite — Accident",
    question: "L’accident à l’origine du délit de fuite peut être :",
    options: [
      "Matériel, corporel ou mortel",
      "Uniquement corporel",
      "Uniquement matériel",
    ],
    answer: "Matériel, corporel ou mortel",
    explanation: "Toute nature d’accident est concernée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Lien de causalité",
    question: "Le véhicule doit :",
    options: [
      "Avoir causé ou occasionné l’accident",
      "Être seul impliqué",
      "Avoir heurté obligatoirement",
    ],
    answer: "Avoir causé ou occasionné l’accident",
    explanation: "Le contact n’est pas obligatoire.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Ultra piège",
    question: "L’absence de contact exclut le délit de fuite :",
    options: ["Faux", "Vrai", "Uniquement la nuit"],
    answer: "Faux",
    explanation: "L’occasion suffit.",
    difficulty: "Difficile",
  ),

  // ---------- OBLIGATIONS DU CONDUCTEUR ----------
  const QuizQuestion(
    category: "Délit de fuite — Obligations",
    question: "Le conducteur impliqué doit :",
    options: [
      "S’arrêter immédiatement",
      "Continuer et se signaler plus tard",
      "Changer de lieu",
    ],
    answer: "S’arrêter immédiatement",
    explanation: "Arrêt immédiat et volontaire exigé.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Arrêt",
    question: "L’arrêt doit être :",
    options: [
      "Immédiat et volontaire",
      "Prolongé obligatoirement",
      "Validé par la police",
    ],
    answer: "Immédiat et volontaire",
    explanation: "Cass. crim. constante.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Faux arrêt",
    question: "S’arrêter brièvement pour repartir constitue :",
    options: ["Un délit de fuite", "Une excuse", "Un fait justificatif"],
    answer: "Un délit de fuite",
    explanation: "Arrêt insuffisant.",
    difficulty: "Moyenne",
  ),

  // ---------- JURISPRUDENCE ULTRA-PIÈGES ----------
  const QuizQuestion(
    category: "Délit de fuite — Jurisprudence",
    question: "Revenir plus tard sur les lieux efface le délit :",
    options: ["Faux", "Vrai", "Uniquement sans blessés"],
    answer: "Faux",
    explanation: "Cass. crim., 4 novembre 2003.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Jurisprudence",
    question: "Se présenter ultérieurement à la police :",
    options: [
      "N’empêche pas le délit",
      "Annule le délit",
      "Atténue automatiquement la peine",
    ],
    answer: "N’empêche pas le délit",
    explanation: "Cass. crim., 19 mars 1956.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Faux nom",
    question: "Donner un faux nom après s’être arrêté constitue :",
    options: ["Un délit de fuite", "Une simple infraction", "Aucun délit"],
    answer: "Un délit de fuite",
    explanation: "Arrêt non loyal.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Non constitué",
    question: "Le délit n’est PAS constitué si :",
    options: [
      "L’arrêt permet l’identification du véhicule",
      "Le conducteur refuse de parler",
      "Le conducteur est choqué",
    ],
    answer: "L’arrêt permet l’identification du véhicule",
    explanation: "Cass. crim., 16 janvier 1958.",
    difficulty: "Difficile",
  ),

  // ---------- ÉLÉMENT MORAL ----------
  const QuizQuestion(
    category: "Délit de fuite — Élément moral",
    question: "L’auteur doit avoir conscience :",
    options: [
      "D’avoir causé ou occasionné un accident",
      "De commettre un délit",
      "D’avoir blessé quelqu’un",
    ],
    answer: "D’avoir causé ou occasionné un accident",
    explanation: "La conscience de l’accident suffit.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Intention",
    question: "L’intention exigée est :",
    options: [
      "Se soustraire à une responsabilité",
      "Nuire à autrui",
      "Fuir la police",
    ],
    answer: "Se soustraire à une responsabilité",
    explanation: "Pénale ou civile.",
    difficulty: "Facile",
  ),

  // ---------- PEINES & CUMUL ----------
  const QuizQuestion(
    category: "Délit de fuite — Peines",
    question: "Le délit de fuite est puni de :",
    options: [
      "3 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans et 15 000 €",
      "1 an et 7 500 €",
    ],
    answer: "3 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Article 434-10 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Cumul",
    question: "Le délit de fuite peut se cumuler avec :",
    options: [
      "Homicide ou blessures involontaires",
      "Aucune autre infraction",
      "Uniquement une contravention",
    ],
    answer: "Homicide ou blessures involontaires",
    explanation: "Circ. aggravante.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Ultra piège concours",
    question: "Le délit de fuite nécessite une responsabilité effective :",
    options: ["Faux", "Vrai", "Uniquement en cas de blessure"],
    answer: "Faux",
    explanation: "Il suffit d’avoir pu l’encourir.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // RODÉO MOTORISÉ — QUESTIONS 301 À 350
  // =========================================================

  // ---------- DÉFINITION & TEXTE ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Définition",
    question: "Constitue un rodéo motorisé le fait :",
    options: [
      "D’adopter une conduite répétée dangereuse compromettant la sécurité ou la tranquillité publique",
      "De commettre une seule manœuvre dangereuse",
      "De circuler à vitesse excessive une seule fois",
    ],
    answer:
        "D’adopter une conduite répétée dangereuse compromettant la sécurité ou la tranquillité publique",
    explanation: "Article L.236-1 du Code de la route : répétition exigée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Texte",
    question: "Le rodéo motorisé est prévu par :",
    options: [
      "Article L.236-1 du Code de la route",
      "Article L.233-1 du Code de la route",
      "Article 434-10 du Code pénal",
    ],
    answer: "Article L.236-1 du Code de la route",
    explanation: "Texte spécifique aux rodéos.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Nature",
    question: "Le rodéo motorisé constitue :",
    options: ["Un délit", "Une contravention", "Une circonstance aggravante"],
    answer: "Un délit",
    explanation: "Délit autonome.",
    difficulty: "Facile",
  ),

  // ---------- VÉHICULE & LIEU ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Véhicules",
    question: "Quels véhicules sont concernés ?",
    options: [
      "Tous les véhicules terrestres à moteur",
      "Uniquement les deux-roues",
      "Uniquement les voitures",
    ],
    answer: "Tous les véhicules terrestres à moteur",
    explanation: "Aucune distinction.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Lieux",
    question: "Le rodéo motorisé peut être commis :",
    options: [
      "Sur voies publiques et certaines voies privées ouvertes",
      "Uniquement sur voie publique",
      "Uniquement sur parking public",
    ],
    answer: "Sur voies publiques et certaines voies privées ouvertes",
    explanation: "Voies privées à accès libre incluses.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Ultra piège",
    question: "Un parking de centre commercial est exclu :",
    options: ["Faux", "Vrai", "Uniquement la nuit"],
    answer: "Faux",
    explanation: "Lieu ouvert à la circulation publique.",
    difficulty: "Difficile",
  ),

  // ---------- MANŒUVRES ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Manœuvres",
    question: "Les manœuvres doivent être :",
    options: ["Répétées", "Uniques", "Accidentelles"],
    answer: "Répétées",
    explanation: "Une manœuvre isolée est insuffisante.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Exemples",
    question: "Constitue un exemple de rodéo :",
    options: [
      "Griller plusieurs feux rouges successifs",
      "Un seul dépassement dangereux",
      "Un freinage brusque isolé",
    ],
    answer: "Griller plusieurs feux rouges successifs",
    explanation: "Répétition caractérisée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Sécurité",
    question: "Le danger exigé doit :",
    options: [
      "Compromettre la sécurité ou troubler la tranquillité publique",
      "Être un risque immédiat de mort",
      "Avoir causé un accident",
    ],
    answer: "Compromettre la sécurité ou troubler la tranquillité publique",
    explanation: "Pas besoin de risque immédiat de mort.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Ultra piège",
    question: "Un accident est nécessaire pour caractériser l’infraction :",
    options: ["Faux", "Vrai", "Uniquement avec blessés"],
    answer: "Faux",
    explanation: "Le trouble ou la compromission suffit.",
    difficulty: "Difficile",
  ),

  // ---------- USAGERS ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Usagers",
    question: "Les usagers exposés peuvent être :",
    options: [
      "Des tiers ou d’autres participants",
      "Uniquement des tiers",
      "Uniquement des piétons",
    ],
    answer: "Des tiers ou d’autres participants",
    explanation: "Participants inclus.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Tranquillité",
    question: "Le trouble à la tranquillité publique peut résulter :",
    options: [
      "De nuisances sonores excessives",
      "Uniquement d’un accident",
      "Uniquement d’une vitesse excessive",
    ],
    answer: "De nuisances sonores excessives",
    explanation: "Exemples jurisprudentiels.",
    difficulty: "Facile",
  ),

  // ---------- ÉLÉMENT MORAL ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Élément moral",
    question: "L’élément moral requis est :",
    options: [
      "Une violation manifestement délibérée et répétée",
      "Une simple imprudence",
      "Une négligence",
    ],
    answer: "Une violation manifestement délibérée et répétée",
    explanation: "Intention caractérisée.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Conscience",
    question: "L’auteur doit avoir conscience :",
    options: [
      "De compromettre la sécurité ou la tranquillité",
      "De violer un texte précis",
      "D’encourir une peine",
    ],
    answer: "De compromettre la sécurité ou la tranquillité",
    explanation: "La conscience du risque suffit.",
    difficulty: "Moyenne",
  ),

  // ---------- CIRCONSTANCES AGGRAVANTES ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Aggravation I",
    question: "Première circonstance aggravante :",
    options: [
      "Commission en réunion",
      "Commission de nuit",
      "Présence d’un mineur",
    ],
    answer: "Commission en réunion",
    explanation: "Article L.236-1 II CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Aggravation II",
    question: "Deuxième degré d’aggravation vise notamment :",
    options: [
      "Alcool, stupéfiants ou défaut de permis",
      "La vitesse seule",
      "Le bruit seul",
    ],
    answer: "Alcool, stupéfiants ou défaut de permis",
    explanation: "Article L.236-1 III CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Aggravation III",
    question: "Troisième degré d’aggravation est caractérisé lorsque :",
    options: [
      "Au moins deux circonstances du III sont réunies",
      "Il y a blessure",
      "Il y a récidive",
    ],
    answer: "Au moins deux circonstances du III sont réunies",
    explanation: "Article L.236-1 IV CR.",
    difficulty: "Moyenne",
  ),

  // ---------- PEINES ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Peine simple",
    question: "La peine du rodéo simple est :",
    options: [
      "1 an d’emprisonnement et 15 000 € d’amende",
      "2 ans et 30 000 €",
      "3 ans et 45 000 €",
    ],
    answer: "1 an d’emprisonnement et 15 000 € d’amende",
    explanation: "Article L.236-1 I CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Peine aggravée II",
    question: "La peine au deuxième degré d’aggravation est :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans et 30 000 €",
      "5 ans et 75 000 €",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Article L.236-1 III CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Peine aggravée III",
    question: "La peine maximale encourue est :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "7 ans et 100 000 €",
      "10 ans et 150 000 €",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Article L.236-1 IV CR.",
    difficulty: "Facile",
  ),

  // ---------- MESURES COMPLÉMENTAIRES ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Confiscation",
    question: "La confiscation du véhicule est :",
    options: ["Obligatoire sauf décision motivée", "Facultative", "Interdite"],
    answer: "Obligatoire sauf décision motivée",
    explanation: "Article L.236-3 CR.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Fourrière",
    question: "Le véhicule peut être immobilisé et mis en fourrière :",
    options: [
      "Sans autorisation préalable du procureur",
      "Uniquement sur autorisation écrite",
      "Jamais",
    ],
    answer: "Sans autorisation préalable du procureur",
    explanation: "Article L.325-1-2 CR.",
    difficulty: "Moyenne",
  ),

  // ---------- INFRACTIONS VOISINES ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Distinction",
    question: "Une manœuvre dangereuse unique relève plutôt :",
    options: [
      "D’une autre infraction routière",
      "Du rodéo motorisé",
      "D’un délit de fuite",
    ],
    answer: "D’une autre infraction routière",
    explanation: "Répétition indispensable.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Incitation",
    question: "Inciter ou promouvoir un rodéo constitue :",
    options: [
      "Une infraction autonome",
      "Une complicité simple",
      "Un fait non punissable",
    ],
    answer: "Une infraction autonome",
    explanation: "Article L.236-2 CR.",
    difficulty: "Facile",
  ),

  // =========================================================
  // RODÉO MOTORISÉ — QUESTIONS 351 À 400
  // =========================================================

  // ---------- RÉUNION / PARTICIPATION ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Réunion",
    question: "La commission en réunion suppose :",
    options: [
      "La participation d’au moins deux auteurs",
      "La présence de spectateurs",
      "Une organisation préalable",
    ],
    answer: "La participation d’au moins deux auteurs",
    explanation: "La simple pluralité d’auteurs suffit.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Ultra piège",
    question:
        "La présence de spectateurs caractérise automatiquement la réunion :",
    options: ["Faux", "Vrai", "Uniquement si filmé"],
    answer: "Faux",
    explanation: "Les spectateurs ne sont pas des coauteurs.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Participants",
    question: "Les autres conducteurs participant au rodéo sont :",
    options: [
      "Des usagers exposés au danger",
      "Toujours complices",
      "Toujours coauteurs",
    ],
    answer: "Des usagers exposés au danger",
    explanation: "Ils peuvent aussi être victimes potentielles.",
    difficulty: "Moyenne",
  ),

  // ---------- DISTINCTIONS JURIDIQUES ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Distinction",
    question: "Le rodéo motorisé se distingue du risque causé à autrui car :",
    options: [
      "Il n’exige pas un risque immédiat de mort",
      "Il exige un accident",
      "Il est contraventionnel",
    ],
    answer: "Il n’exige pas un risque immédiat de mort",
    explanation: "Compromission de la sécurité suffit.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Distinction",
    question: "Un rodéo peut être constitué sans accident :",
    options: ["Vrai", "Faux", "Uniquement de jour"],
    answer: "Vrai",
    explanation: "Aucun dommage exigé.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Distinction",
    question: "Un seul wheeling isolé constitue un rodéo :",
    options: ["Faux", "Vrai", "Uniquement en ville"],
    answer: "Faux",
    explanation: "Répétition indispensable.",
    difficulty: "Difficile",
  ),

  // ---------- ÉLÉMENTS DE PREUVE ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Preuve",
    question: "Les faits peuvent être caractérisés par :",
    options: [
      "Des constatations directes ou vidéoprotection",
      "Uniquement un accident",
      "Uniquement des témoignages écrits",
    ],
    answer: "Des constatations directes ou vidéoprotection",
    explanation: "Images exploitables a posteriori.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Ultra piège",
    question: "L’absence de contrôle immédiat empêche toute poursuite :",
    options: ["Faux", "Vrai", "Uniquement sans vidéo"],
    answer: "Faux",
    explanation: "Preuves différées possibles.",
    difficulty: "Difficile",
  ),

  // ---------- STUPÉFIANTS / ALCOOL ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Alcool",
    question: "La consommation d’alcool lors d’un rodéo :",
    options: [
      "Constitue une circonstance aggravante",
      "Est sans effet",
      "Absorbe l’infraction",
    ],
    answer: "Constitue une circonstance aggravante",
    explanation: "Article L.236-1 III CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Stupéfiants",
    question: "Le refus de se soumettre aux vérifications stupéfiants :",
    options: [
      "Aggrave le rodéo",
      "Annule la poursuite",
      "Constitue une excuse",
    ],
    answer: "Aggrave le rodéo",
    explanation: "Assimilé à la consommation.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Ultra piège",
    question: "La simple suspicion de stupéfiants suffit à aggraver :",
    options: ["Faux", "Vrai", "Uniquement en récidive"],
    answer: "Faux",
    explanation: "Analyse ou refus requis.",
    difficulty: "Difficile",
  ),

  // ---------- PERMIS ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Permis",
    question: "L’absence de permis lors d’un rodéo :",
    options: [
      "Constitue une circonstance aggravante",
      "Absorbe l’infraction",
      "Est sans incidence",
    ],
    answer: "Constitue une circonstance aggravante",
    explanation: "Article L.236-1 III CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Ultra piège",
    question: "Un permis suspendu est assimilé à l’absence de permis :",
    options: ["Vrai", "Faux", "Uniquement en récidive"],
    answer: "Vrai",
    explanation: "Suspension, invalidation ou annulation.",
    difficulty: "Difficile",
  ),

  // ---------- CUMUL / COMPLICITÉ ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Cumul",
    question: "Le rodéo motorisé peut se cumuler avec :",
    options: [
      "Refus d’obtempérer ou conduite alcoolisée",
      "Aucune autre infraction",
      "Uniquement des contraventions",
    ],
    answer: "Refus d’obtempérer ou conduite alcoolisée",
    explanation: "Cumul possible.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Complicité",
    question: "Les passagers peuvent être poursuivis :",
    options: ["Pour complicité", "Uniquement comme témoins", "Jamais"],
    answer: "Pour complicité",
    explanation: "Aide ou encouragement.",
    difficulty: "Moyenne",
  ),

  // ---------- INCITATION / PROMOTION ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Incitation",
    question: "L’incitation à participer à un rodéo est :",
    options: [
      "Punissable même sans rodéo effectif",
      "Punissable uniquement si le rodéo a lieu",
      "Non punissable",
    ],
    answer: "Punissable même sans rodéo effectif",
    explanation: "Infraction formelle.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Promotion",
    question: "La promotion d’un rodéo sur les réseaux sociaux :",
    options: [
      "Constitue une infraction",
      "Est protégée par la liberté d’expression",
      "Est une contravention",
    ],
    answer: "Constitue une infraction",
    explanation: "Article L.236-2 CR.",
    difficulty: "Facile",
  ),

  // ---------- PEINES INCITATION ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Peine incitation",
    question: "L’incitation ou la promotion est punie de :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "1 an et 15 000 €",
      "3 ans et 45 000 €",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation: "Article L.236-2 CR.",
    difficulty: "Facile",
  ),

  // ---------- MESURES ----------
  const QuizQuestion(
    category: "Rodéo motorisé — Immobilisation",
    question: "L’immobilisation administrative du véhicule :",
    options: [
      "Peut être décidée immédiatement",
      "Nécessite une décision judiciaire préalable",
      "Est impossible",
    ],
    answer: "Peut être décidée immédiatement",
    explanation: "Information immédiate du procureur.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Rodéo motorisé — Ultra piège final",
    question: "La confiscation du véhicule est facultative par principe :",
    options: ["Faux", "Vrai", "Uniquement en récidive"],
    answer: "Faux",
    explanation: "Confiscation obligatoire sauf motivation.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // PLAQUES & IMMATRICULATION — QUESTIONS 401 À 450
  // =========================================================

  // ---------- PRINCIPES GÉNÉRAUX ----------
  const QuizQuestion(
    category: "Plaques — Définition",
    question:
        "Les infractions relatives aux plaques d’immatriculation sont prévues par :",
    options: [
      "Les articles L.317-2 à L.317-4-1 du Code de la route",
      "L’article R.317-1 du Code de la route",
      "L’article 434-15-2 du Code pénal",
    ],
    answer: "Les articles L.317-2 à L.317-4-1 du Code de la route",
    explanation:
        "Ces articles répriment l’ensemble des délits liés aux plaques.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Plaques — Principe",
    question: "Les règles relatives aux plaques concernent :",
    options: [
      "Les véhicules à moteur et leurs remorques",
      "Uniquement les voitures",
      "Uniquement les deux-roues",
    ],
    answer: "Les véhicules à moteur et leurs remorques",
    explanation: "Le champ est très large.",
    difficulty: "Facile",
  ),

  // ---------- FAUSSES PLAQUES ----------
  const QuizQuestion(
    category: "Plaques — Fausses plaques",
    question: "Faire usage d’une plaque portant un numéro faux constitue :",
    options: [
      "Un délit",
      "Une contravention",
      "Une simple infraction administrative",
    ],
    answer: "Un délit",
    explanation: "Article L.317-2 I du CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Plaques — Ultra piège",
    question: "La plaque est considérée comme fausse si :",
    options: [
      "Les indications ne correspondent pas au certificat d’immatriculation",
      "Elle est sale ou abîmée",
      "Elle est difficilement lisible",
    ],
    answer:
        "Les indications ne correspondent pas au certificat d’immatriculation",
    explanation: "Lisibilité ≠ fausseté.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Plaques — Fausses plaques",
    question: "Une plaque portant un faux domicile relève de :",
    options: [
      "L’article L.317-2 I du CR",
      "L’article L.317-4-1 du CR",
      "Une simple contravention",
    ],
    answer: "L’article L.317-2 I du CR",
    explanation: "Numéro, nom ou domicile faux.",
    difficulty: "Moyenne",
  ),

  // ---------- ABSENCE DE PLAQUES ----------
  const QuizQuestion(
    category: "Plaques — Absence",
    question:
        "Circuler sans plaque et déclarer de fausses informations constitue :",
    options: [
      "Un délit",
      "Une contravention simple",
      "Une infraction administrative",
    ],
    answer: "Un délit",
    explanation: "Article L.317-3 I du CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Plaques — Ultra piège",
    question:
        "Circuler sans plaque mais avec une identité exacte constitue ce délit :",
    options: ["Faux", "Vrai", "Uniquement en récidive"],
    answer: "Faux",
    explanation: "Le délit suppose aussi une fausse déclaration.",
    difficulty: "Difficile",
  ),

  // ---------- PLAQUE NON CONFORME AU VÉHICULE ----------
  const QuizQuestion(
    category: "Plaques — Non-conformité",
    question: "Utiliser une plaque correspondant à un autre type de véhicule :",
    options: [
      "Constitue un délit",
      "Est une simple contravention",
      "Est sans incidence",
    ],
    answer: "Constitue un délit",
    explanation: "Article L.317-4 I du CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Plaques — Jurisprudence",
    question:
        "Utiliser les plaques d’un véhicule accidenté sur un autre véhicule :",
    options: [
      "Caractérise le délit",
      "Est toléré",
      "Relève uniquement de l’assurance",
    ],
    answer: "Caractérise le délit",
    explanation: "Cass. crim., 15 février 1978.",
    difficulty: "Moyenne",
  ),

  // ---------- USURPATION DE PLAQUES ----------
  const QuizQuestion(
    category: "Plaques — Usurpation",
    question: "L’usurpation de plaques suppose :",
    options: [
      "Un numéro attribué à un autre véhicule",
      "Une simple erreur administrative",
      "Une plaque endommagée",
    ],
    answer: "Un numéro attribué à un autre véhicule",
    explanation: "Article L.317-4-1 I du CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Plaques — Ultra piège concours",
    question:
        "L’usurpation exige que des poursuites aient effectivement été engagées contre un tiers :",
    options: ["Faux", "Vrai", "Uniquement en récidive"],
    answer: "Faux",
    explanation: "Il suffit qu’elles auraient pu l’être.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Plaques — Usurpation",
    question: "L’objectif principal de l’usurpation est souvent :",
    options: [
      "D’échapper aux poursuites",
      "D’améliorer l’esthétique",
      "D’éviter un contrôle technique",
    ],
    answer: "D’échapper aux poursuites",
    explanation: "Responsabilité pénale transférée à un tiers.",
    difficulty: "Facile",
  ),

  // ---------- ÉLÉMENT MORAL ----------
  const QuizQuestion(
    category: "Plaques — Élément moral",
    question: "L’élément moral des délits liés aux plaques est :",
    options: ["Intentionnel", "Toujours involontaire", "Présumé sans preuve"],
    answer: "Intentionnel",
    explanation: "Conscience et volonté requises.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Plaques — Ultra piège",
    question: "Une simple négligence suffit à caractériser ces délits :",
    options: ["Faux", "Vrai", "Uniquement pour l’usurpation"],
    answer: "Faux",
    explanation: "Intention requise.",
    difficulty: "Difficile",
  ),

  // ---------- PEINES ----------
  const QuizQuestion(
    category: "Plaques — Peines",
    question: "La peine maximale pour usurpation de plaques est :",
    options: [
      "7 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans et 15 000 €",
      "3 ans et 45 000 €",
    ],
    answer: "7 ans d’emprisonnement et 30 000 € d’amende",
    explanation: "Article L.317-4-1 CR.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Plaques — Ultra piège",
    question:
        "Toutes les infractions relatives aux plaques sont punies de la même peine :",
    options: ["Faux", "Vrai", "Uniquement en récidive"],
    answer: "Faux",
    explanation: "Peines variables selon l’article.",
    difficulty: "Difficile",
  ),

  // ---------- CUMUL ----------
  const QuizQuestion(
    category: "Plaques — Cumul",
    question: "Les délits relatifs aux plaques peuvent se cumuler avec :",
    options: [
      "Défaut d’assurance ou refus d’obtempérer",
      "Aucune autre infraction",
      "Uniquement des contraventions",
    ],
    answer: "Défaut d’assurance ou refus d’obtempérer",
    explanation: "Cumul fréquent en pratique.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Plaques — Ultra piège final",
    question: "La tentative est punissable pour ces délits :",
    options: ["Faux", "Vrai", "Uniquement pour l’usurpation"],
    answer: "Faux",
    explanation: "Tentative non prévue.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // ALCOOLÉMIE & STUPÉFIANTS — QUESTIONS 451 À 550
  // =========================================================

  // ---------- PRINCIPES GÉNÉRAUX ----------
  const QuizQuestion(
    category: "Alcoolémie — Principe",
    question:
        "La conduite sous l’empire d’un état alcoolique est caractérisée lorsque :",
    options: [
      "Le taux légal est atteint ou dépassé, même sans signe d’ivresse",
      "Des signes d’ivresse sont constatés uniquement",
      "Le conducteur reconnaît avoir bu",
    ],
    answer: "Le taux légal est atteint ou dépassé, même sans signe d’ivresse",
    explanation: "L’ivresse manifeste est distincte du taux légal.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Alcoolémie — Texte",
    question: "La conduite sous l’empire d’un état alcoolique est prévue par :",
    options: [
      "Article L.234-1 I du Code de la route",
      "Article R.234-1 du Code de la route",
      "Article 221-6 du Code pénal",
    ],
    answer: "Article L.234-1 I du Code de la route",
    explanation: "Disposition délictuelle.",
    difficulty: "Facile",
  ),

  // ---------- TAUX DÉLICTUEL / CONTRAVENTIONNEL ----------
  const QuizQuestion(
    category: "Alcoolémie — Taux",
    question: "Le taux délictuel d’alcoolémie est atteint à partir de :",
    options: [
      "0,80 g/l de sang ou 0,40 mg/l d’air expiré",
      "0,50 g/l de sang",
      "0,20 g/l de sang",
    ],
    answer: "0,80 g/l de sang ou 0,40 mg/l d’air expiré",
    explanation: "Seuil pénal.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Alcoolémie — Ultra piège",
    question: "Un conducteur avec 0,79 g/l de sang commet un délit :",
    options: ["Faux", "Vrai", "Uniquement en récidive"],
    answer: "Faux",
    explanation: "Infraction contraventionnelle si seuil atteint.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Alcoolémie — Contravention",
    question: "Le taux contraventionnel général commence à :",
    options: ["0,50 g/l de sang", "0,20 g/l de sang", "0,80 g/l de sang"],
    answer: "0,50 g/l de sang",
    explanation: "Pour les conducteurs ordinaires.",
    difficulty: "Moyenne",
  ),

  // ---------- MARGES D’ERREUR ----------
  const QuizQuestion(
    category: "Alcoolémie — Marge d’erreur",
    question: "La marge d’erreur pour un taux ≥ 0,40 mg/l et ≤ 2 mg/l est :",
    options: ["8 %", "0,032 mg/l", "30 %"],
    answer: "8 %",
    explanation: "Cass. crim., 26 mars 2019.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Alcoolémie — Ultra piège concours",
    question: "La prise en compte de la marge d’erreur par le juge est :",
    options: ["Obligatoire", "Facultative", "Interdite"],
    answer: "Obligatoire",
    explanation: "Obligation jurisprudentielle.",
    difficulty: "Difficile",
  ),

  // ---------- IVRESSE MANIFESTE ----------
  const QuizQuestion(
    category: "Ivresse manifeste — Définition",
    question: "L’ivresse manifeste se caractérise par :",
    options: [
      "Des signes comportementaux observables",
      "Un taux précis d’alcool",
      "Un refus de souffler",
    ],
    answer: "Des signes comportementaux observables",
    explanation: "Indépendant du taux.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Ivresse manifeste — Ultra piège",
    question:
        "Une personne peut être en ivresse manifeste avec un taux inférieur au seuil légal :",
    options: ["Vrai", "Faux", "Uniquement en récidive"],
    answer: "Vrai",
    explanation: "Sensibilité individuelle.",
    difficulty: "Difficile",
  ),

  // ---------- DÉPISTAGE ----------
  const QuizQuestion(
    category: "Alcoolémie — Dépistage",
    question: "Le dépistage alcoolique est obligatoire en cas :",
    options: [
      "D’accident corporel",
      "D’accident matériel",
      "De contrôle routier simple",
    ],
    answer: "D’accident corporel",
    explanation: "Article L.234-3 CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Alcoolémie — Ultra piège",
    question: "Un conducteur peut choisir entre éthylomètre et prise de sang :",
    options: ["Faux", "Vrai", "Uniquement en garde à vue"],
    answer: "Faux",
    explanation: "Choix de l’OPJ.",
    difficulty: "Difficile",
  ),

  // ---------- REFUS ----------
  const QuizQuestion(
    category: "Refus — Alcoolémie",
    question:
        "Le refus de se soumettre aux vérifications alcooliques constitue :",
    options: [
      "Un délit autonome",
      "Une circonstance aggravante",
      "Une contravention",
    ],
    answer: "Un délit autonome",
    explanation: "Article L.234-8 CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus — Ultra piège",
    question: "Le refus de dépistage équivaut à un taux positif :",
    options: ["Faux", "Vrai", "Uniquement en récidive"],
    answer: "Faux",
    explanation: "Infraction distincte.",
    difficulty: "Difficile",
  ),

  // ---------- STUPÉFIANTS ----------
  const QuizQuestion(
    category: "Stupéfiants — Principe",
    question: "La conduite après usage de stupéfiants repose sur :",
    options: [
      "La présence détectée d’une substance",
      "Un seuil minimal",
      "Un état de dépendance",
    ],
    answer: "La présence détectée d’une substance",
    explanation: "Pas de notion de dosage.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Stupéfiants — Ultra piège",
    question: "Le taux de stupéfiants doit être mentionné dans l’analyse :",
    options: ["Faux", "Vrai", "Uniquement en récidive"],
    answer: "Faux",
    explanation: "Suppression du dosage.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Stupéfiants — Refus",
    question:
        "Le refus de se soumettre aux vérifications stupéfiants est prévu par :",
    options: [
      "Article L.235-3 du Code de la route",
      "Article L.235-1 du Code de la route",
      "Article 434-15-2 du Code pénal",
    ],
    answer: "Article L.235-3 du Code de la route",
    explanation: "Délit autonome.",
    difficulty: "Moyenne",
  ),

  // ---------- CUMUL ----------
  const QuizQuestion(
    category: "Alcool + Stupéfiants",
    question: "La conduite sous alcool ET stupéfiants :",
    options: [
      "Aggrave les peines",
      "Constitue une seule infraction",
      "Est impossible juridiquement",
    ],
    answer: "Aggrave les peines",
    explanation: "Circonstance aggravante.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Alcoolémie — Ultra piège final",
    question: "La tentative de conduite sous alcool est punissable :",
    options: ["Faux", "Vrai", "Uniquement en récidive"],
    answer: "Faux",
    explanation: "Tentative non prévue.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // REFUS D’OBTEMPÉRER & DÉLIT DE FUITE — QUESTIONS 551 À 600
  // =========================================================

  // ---------- REFUS D’OBTEMPÉRER — BASE ----------
  const QuizQuestion(
    category: "Refus d’obtempérer — Définition",
    question: "Le refus d’obtempérer consiste pour un conducteur à :",
    options: [
      "Ne pas s’arrêter malgré une sommation claire d’un agent habilité",
      "Refuser un contrôle d’alcoolémie",
      "Refuser de présenter ses papiers",
    ],
    answer: "Ne pas s’arrêter malgré une sommation claire d’un agent habilité",
    explanation: "Article L.233-1 I du Code de la route.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Refus d’obtempérer — Agents",
    question: "Les agents pouvant caractériser le refus d’obtempérer sont :",
    options: [
      "Ceux visés aux articles L.130-1 à L.130-4 du CR",
      "Uniquement les OPJ",
      "Uniquement les policiers en tenue",
    ],
    answer: "Ceux visés aux articles L.130-1 à L.130-4 du CR",
    explanation: "Champ large d’agents habilités.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Refus d’obtempérer — Ultra piège",
    question: "La sommation de s’arrêter doit obligatoirement être verbale :",
    options: ["Faux", "Vrai", "Uniquement la nuit"],
    answer: "Faux",
    explanation: "Gestes, signaux lumineux ou sonores suffisent.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Refus d’obtempérer — Élément moral",
    question: "L’élément moral du refus d’obtempérer repose sur :",
    options: [
      "La volonté de ne pas obéir à la sommation",
      "La simple négligence",
      "L’état d’ivresse",
    ],
    answer: "La volonté de ne pas obéir à la sommation",
    explanation: "Infraction intentionnelle.",
    difficulty: "Facile",
  ),

  // ---------- REFUS D’OBTEMPÉRER — AGGRAVÉ ----------
  const QuizQuestion(
    category: "Refus d’obtempérer — Aggravation",
    question: "Le refus d’obtempérer est aggravé lorsqu’il :",
    options: [
      "Expose directement autrui à un risque de mort ou blessures graves",
      "Dure plus de 5 minutes",
      "Est commis de nuit",
    ],
    answer: "Expose directement autrui à un risque de mort ou blessures graves",
    explanation: "Article L.233-1-1 al.1 CR.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Refus d’obtempérer — Ultra piège concours",
    question: "Un refus d’obtempérer absorbé par des violences volontaires :",
    options: [
      "N’est pas retenu pénalement",
      "Est toujours cumulé",
      "Devient une contravention",
    ],
    answer: "N’est pas retenu pénalement",
    explanation: "Absorption par l’infraction la plus grave.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Refus d’obtempérer — Peines",
    question: "La peine encourue pour un refus d’obtempérer simple est :",
    options: [
      "2 ans d’emprisonnement et 15 000 € d’amende",
      "1 an et 7 500 €",
      "3 ans et 45 000 €",
    ],
    answer: "2 ans d’emprisonnement et 15 000 € d’amende",
    explanation: "Article L.233-1 CR.",
    difficulty: "Facile",
  ),

  // ---------- DÉLIT DE FUITE — BASE ----------
  const QuizQuestion(
    category: "Délit de fuite — Définition",
    question: "Le délit de fuite suppose que le conducteur :",
    options: [
      "Sache qu’il a causé ou occasionné un accident et ne s’arrête pas",
      "Cause obligatoirement un accident corporel",
      "Soit poursuivi par la police",
    ],
    answer: "Sache qu’il a causé ou occasionné un accident et ne s’arrête pas",
    explanation: "Articles 434-10 CP et L.231-1 CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Accident",
    question: "Le délit de fuite peut être constitué après :",
    options: [
      "Un accident matériel, corporel ou mortel",
      "Uniquement un accident corporel",
      "Uniquement un accident mortel",
    ],
    answer: "Un accident matériel, corporel ou mortel",
    explanation: "Nature de l’accident indifférente.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Ultra piège",
    question: "L’absence de contact matériel empêche le délit de fuite :",
    options: ["Faux", "Vrai", "Uniquement la nuit"],
    answer: "Faux",
    explanation: "L’accident peut être seulement occasionné.",
    difficulty: "Difficile",
  ),

  // ---------- DÉLIT DE FUITE — OMISSION ----------
  const QuizQuestion(
    category: "Délit de fuite — Omission",
    question: "Le conducteur doit s’arrêter :",
    options: [
      "Aussitôt que possible sans danger",
      "Uniquement à un poste de police",
      "Dans les 24 heures",
    ],
    answer: "Aussitôt que possible sans danger",
    explanation: "Article R.231-1 CR.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Jurisprudence",
    question: "Un conducteur qui revient sur les lieux après avoir fui :",
    options: [
      "A déjà consommé le délit",
      "Échappe aux poursuites",
      "Bénéficie d’une excuse légale",
    ],
    answer: "A déjà consommé le délit",
    explanation: "Cass. crim., 4 novembre 2003.",
    difficulty: "Moyenne",
  ),

  // ---------- DÉLIT DE FUITE — ÉLÉMENT MORAL ----------
  const QuizQuestion(
    category: "Délit de fuite — Élément moral",
    question: "L’élément moral du délit de fuite repose sur :",
    options: [
      "La conscience de l’accident et la volonté d’échapper à la responsabilité",
      "La seule peur",
      "Le refus de coopérer",
    ],
    answer:
        "La conscience de l’accident et la volonté d’échapper à la responsabilité",
    explanation: "Responsabilité pénale ou civile possible.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Ultra piège concours",
    question:
        "Il faut prouver que le conducteur a effectivement encouru une responsabilité :",
    options: ["Faux", "Vrai", "Uniquement en cas d’accident corporel"],
    answer: "Faux",
    explanation: "Il suffit qu’il ait pu l’encourir.",
    difficulty: "Difficile",
  ),

  // ---------- DÉLIT DE FUITE — PEINES ----------
  const QuizQuestion(
    category: "Délit de fuite — Peines",
    question: "La peine principale du délit de fuite est :",
    options: [
      "3 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans et 15 000 €",
      "5 ans et 150 000 €",
    ],
    answer: "3 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Article 434-10 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Délit de fuite — Ultra piège final",
    question: "La tentative de délit de fuite est punissable :",
    options: ["Faux", "Vrai", "Uniquement en récidive"],
    answer: "Faux",
    explanation: "Infraction instantanée, tentative non prévue.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizIntroductionPA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName = '/pa/libertes_publiques/quiz/introduction';
  final String uid;
  final String email;

  const QuizIntroductionPA({super.key, required this.uid, required this.email});

  @override
  State<QuizIntroductionPA> createState() => _QuizIntroductionPAState();
}

class _QuizIntroductionPAState extends State<QuizIntroductionPA>
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
  static const _introHiddenKey = 'intro_pa_introduction';
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
        ? questionLibertesPubliquesIntroduction
        : questionLibertesPubliquesIntroduction
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
            'mode': UserContextService.I.modeOrDefault,'module_name': 'Libertés publiques (introduction)',
            'quiz_name': 'Quiz - Libertés publiques introduction',
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
      await _sb.from('quiz_introduction').insert({
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
      debugPrint('❌ quiz_introduction insert failed: $e');
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
      'source_file': 'pa_quiz_introduction',
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
                            icon: Icons.school_rounded,
                            title: 'Introduction',
                            description: 'Pose les bases : structure de la procédure pénale, acteurs, principes directeurs et articulation entre les différentes phases.',
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
