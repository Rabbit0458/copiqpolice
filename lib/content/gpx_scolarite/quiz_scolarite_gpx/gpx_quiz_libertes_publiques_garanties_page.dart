// ignore_for_file: use_build_context_synchronously

// ============================================================================
//  Quiz UsageArmes – version refondue
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

final List<QuizQuestion> questionsGarantiesLibertesPubliques = [
  // =========================================================
  // ===================== NIVEAU FACILE =====================
  // =========================================================

  // ---------- Constitution & suprématie ----------
  const QuizQuestion(
    category: "Constitution – Norme suprême",
    question:
        "Dans l’ordre juridique français, la norme qui se situe au sommet de la hiérarchie des normes est :",
    options: ["La loi", "La Constitution", "Le règlement"],
    answer: "La Constitution",
    explanation:
        "La Constitution est la norme suprême : toutes les lois et règlements doivent lui être conformes.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Constitution – Norme suprême",
    question:
        "La supériorité de la Constitution sur la loi n’a de sens que si :",
    options: [
      "Le Président de la République la lit chaque année au Parlement",
      "La Constitution est révisée tous les 5 ans",
      "Il existe un mécanisme de contrôle de la constitutionnalité des lois",
    ],
    answer:
        "Il existe un mécanisme de contrôle de la constitutionnalité des lois",
    explanation:
        "Sans contrôle de constitutionnalité, une loi contraire à la Constitution pourrait s’appliquer malgré tout.",
    difficulty: "Facile",
  ),

  // ---------- Types de Constitution ----------
  const QuizQuestion(
    category: "Types de Constitution",
    question: "Une Constitution dite « souple » est une Constitution qui :",
    options: [
      "Ne peut jamais être modifiée",
      "Peut être révisée comme une simple loi ordinaire",
      "N’a aucune valeur juridique",
    ],
    answer: "Peut être révisée comme une simple loi ordinaire",
    explanation:
        "Dans une Constitution souple, la procédure de révision est identique à celle des lois ordinaires.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Types de Constitution",
    question: "Une Constitution est qualifiée de « rigide » lorsqu’elle :",
    options: [
      "Est entièrement coutumière",
      "Prévoit une procédure de révision spéciale, plus exigeante que pour la loi",
      "Peut être modifiée par décret simple",
    ],
    answer:
        "Prévoit une procédure de révision spéciale, plus exigeante que pour la loi",
    explanation:
        "La rigidité signifie que la révision obéit à des conditions plus strictes que l’adoption d’une loi ordinaire.",
    difficulty: "Facile",
  ),

  // ---------- Révision de la Constitution ----------
  const QuizQuestion(
    category: "Révision constitutionnelle",
    question:
        "Quel article de la Constitution de 1958 encadre la procédure de révision constitutionnelle ?",
    options: ["Article 16", "Article 61-1", "Article 89"],
    answer: "Article 89",
    explanation:
        "L’article 89 fixe la procédure de révision : initiative, adoption identique par les deux assemblées, puis référendum ou Congrès.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révision constitutionnelle",
    question:
        "En France, la révision de la Constitution doit d’abord être adoptée :",
    options: [
      "Par le Conseil constitutionnel",
      "En termes identiques par l’Assemblée nationale et le Sénat",
      "Par le seul Président de la République",
    ],
    answer: "En termes identiques par l’Assemblée nationale et le Sénat",
    explanation:
        "L’article 89 exige un vote en termes identiques par les deux chambres avant approbation par référendum ou Congrès.",
    difficulty: "Facile",
  ),

  // ---------- Contrôle de constitutionnalité – principes ----------
  const QuizQuestion(
    category: "Contrôle de constitutionnalité – Principes",
    question:
        "Le contrôle de constitutionnalité des lois sert principalement à :",
    options: [
      "Contrôler la moralité des citoyens",
      "Vérifier la conformité des lois à la Constitution",
      "Organiser les élections municipales",
    ],
    answer: "Vérifier la conformité des lois à la Constitution",
    explanation:
        "Le contrôle de constitutionnalité protège la suprématie de la Constitution et les droits fondamentaux qu’elle garantit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Contrôle de constitutionnalité – Principes",
    question:
        "Dans un État à Constitution rigide, une loi contraire à la Constitution est :",
    options: [
      "Inconstitutionnelle",
      "Légitime car votée par le Parlement",
      "Supérieure à la Constitution",
    ],
    answer: "Inconstitutionnelle",
    explanation:
        "La loi doit respecter la Constitution : une loi contraire est inconstitutionnelle et doit être écartée ou abrogée.",
    difficulty: "Facile",
  ),

  // ---------- Modèles de contrôle ----------
  const QuizQuestion(
    category: "Modèles de contrôle",
    question: "Le contrôle de constitutionnalité par voie d’exception est :",
    options: [
      "Concentré entre les mains d’une seule juridiction",
      "Diffus et exercé par l’ensemble des juges",
      "Exercé uniquement par le Chef de l’État",
    ],
    answer: "Diffus et exercé par l’ensemble des juges",
    explanation:
        "Par voie d’exception, tout juge saisi d’un litige peut refuser d’appliquer une loi qu’il estime inconstitutionnelle.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Modèles de contrôle",
    question:
        "Le modèle français de contrôle par le Conseil constitutionnel est un contrôle :",
    options: ["Abstrait et concentré", "Diffus et concret", "International"],
    answer: "Abstrait et concentré",
    explanation:
        "Le Conseil constitutionnel exerce un contrôle concentré, souvent abstrait (a priori) avant la promulgation de la loi.",
    difficulty: "Facile",
  ),

  // ---------- Conseil constitutionnel – généralités ----------
  const QuizQuestion(
    category: "Conseil constitutionnel",
    question: "Le Conseil constitutionnel a été créé par la Constitution de :",
    options: ["1875", "1946", "1958"],
    answer: "1958",
    explanation:
        "Il s’agit d’une innovation majeure de la Ve République pour contrôler la conformité des lois à la Constitution.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conseil constitutionnel",
    question:
        "Avant la promulgation d’une loi, le contrôle de constitutionnalité exercé par le Conseil constitutionnel est qualifié de :",
    options: [
      "Contrôle a posteriori",
      "Contrôle a priori",
      "Contrôle de conventionnalité",
    ],
    answer: "Contrôle a priori",
    explanation:
        "Le contrôle a priori intervient avant l’entrée en vigueur de la loi.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Conseil constitutionnel",
    question:
        "En cas de censure d’une loi par le Conseil constitutionnel avant sa promulgation :",
    options: [
      "La disposition censurée ne peut pas être promulguée",
      "La loi est quand même publiée telle quelle",
      "Seul le Gouvernement peut décider de l’appliquer ou non",
    ],
    answer: "La disposition censurée ne peut pas être promulguée",
    explanation:
        "Une disposition déclarée contraire à la Constitution ne peut entrer en vigueur.",
    difficulty: "Facile",
  ),

  // ---------- QPC – généralités ----------
  const QuizQuestion(
    category: "Question prioritaire de constitutionnalité (QPC)",
    question:
        "La question prioritaire de constitutionnalité (QPC) est prévue par :",
    options: [
      "L’article 16 de la Constitution",
      "L’article 61-1 de la Constitution",
      "L’article 89 de la Constitution",
    ],
    answer: "L’article 61-1 de la Constitution",
    explanation:
        "L’article 61-1 introduit la QPC, permettant de contester une loi déjà entrée en vigueur.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "QPC – généralités",
    question:
        "La QPC permet à un justiciable de soutenir qu’une disposition législative :",
    options: [
      "Violerait un traité international",
      "Porterait atteinte aux droits et libertés que la Constitution garantit",
      "Serait contraire aux circulaires ministérielles",
    ],
    answer:
        "Porterait atteinte aux droits et libertés que la Constitution garantit",
    explanation:
        "La QPC vise la compatibilité de la loi avec les droits et libertés constitutionnels.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "QPC – généralités",
    question: "La QPC est soulevée :",
    options: [
      "À l’occasion d’un procès en cours devant une juridiction",
      "Uniquement par le Président de la République",
      "Uniquement devant le maire",
    ],
    answer: "À l’occasion d’un procès en cours devant une juridiction",
    explanation:
        "La QPC est rattachée à un litige concret : elle se soulève devant une juridiction déjà saisie.",
    difficulty: "Facile",
  ),

  // ---------- Recours juridictionnels – généralités ----------
  const QuizQuestion(
    category: "Recours juridictionnels – Notion",
    question: "Les recours juridictionnels permettent à un individu de :",
    options: [
      "Demander une réforme constitutionnelle",
      "Contester l’activité des gouvernants devant un juge",
      "Révoquer directement un élu",
    ],
    answer: "Contester l’activité des gouvernants devant un juge",
    explanation:
        "Les recours juridictionnels sont les moyens offerts aux justiciables pour contester une décision ou une atteinte aux libertés devant une juridiction.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recours juridictionnels – Notion",
    question: "Les recours juridictionnels sont exercés devant :",
    options: [
      "Des autorités administratives indépendantes uniquement",
      "Les juridictions judiciaires et administratives",
      "Le Président de la République",
    ],
    answer: "Les juridictions judiciaires et administratives",
    explanation:
        "Ils s’exercent devant les juridictions chargées de la fonction de juger (pénale, civile, administrative).",
    difficulty: "Facile",
  ),

  // ---------- Recours judiciaires – pénal ----------
  const QuizQuestion(
    category: "Recours devant le juge pénal",
    question:
        "Lorsque l’atteinte à une liberté constitue une infraction, la victime peut saisir :",
    options: [
      "Le juge pénal",
      "Le Défenseur des droits uniquement",
      "Le Conseil constitutionnel directement",
    ],
    answer: "Le juge pénal",
    explanation:
        "Si les faits sont incriminés par le Code pénal, c’est la juridiction pénale qui sanctionne.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recours devant le juge pénal",
    question: "L’article 431-1 du Code pénal incrimine notamment :",
    options: [
      "L’entrave concertée, avec menaces, à l’exercice de certaines libertés",
      "Le défaut de carte d’identité",
      "La simple critique d’une décision administrative",
    ],
    answer:
        "L’entrave concertée, avec menaces, à l’exercice de certaines libertés",
    explanation:
        "L’article 431-1 vise les atteintes organisées à l’exercice de libertés comme la réunion, la manifestation, l’enseignement.",
    difficulty: "Facile",
  ),

  // ---------- Recours administratifs (indemnité / REP) ----------
  const QuizQuestion(
    category: "Recours administratifs – Généralités",
    question: "Les juridictions administratives contrôlent principalement :",
    options: [
      "Les litiges entre particuliers uniquement",
      "La légalité de l’action de l’administration et les dommages qu’elle cause",
      "Les élections professionnelles en entreprise",
    ],
    answer:
        "La légalité de l’action de l’administration et les dommages qu’elle cause",
    explanation:
        "Elles sont compétentes pour juger des actes administratifs et de la responsabilité de l’administration.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recours administratifs – Indemnité",
    question:
        "Le recours en indemnité devant le juge administratif vise à obtenir :",
    options: [
      "L’annulation d’un acte",
      "La réparation d’un dommage causé par l’administration",
      "La démission d’un élu",
    ],
    answer: "La réparation d’un dommage causé par l’administration",
    explanation:
        "Il s’agit d’un recours de pleine juridiction, visant à obtenir des dommages-intérêts.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recours administratifs – Excès de pouvoir",
    question: "Le recours pour excès de pouvoir a pour objet principal :",
    options: [
      "D’obtenir la condamnation pénale d’un agent public",
      "D’obtenir l’annulation d’un acte administratif illégal",
      "De modifier la Constitution",
    ],
    answer: "D’obtenir l’annulation d’un acte administratif illégal",
    explanation:
        "Le REP est un recours objectif visant à faire disparaître de l’ordre juridique un acte contraire à la légalité.",
    difficulty: "Facile",
  ),

  // ---------- Recours non juridictionnels – administratifs ----------
  const QuizQuestion(
    category: "Recours non juridictionnels – Administratifs",
    question: "Un recours gracieux est adressé :",
    options: [
      "À l’auteur même de la décision contestée",
      "Au juge administratif",
      "À la Cour européenne des droits de l’Homme",
    ],
    answer: "À l’auteur même de la décision contestée",
    explanation:
        "Le recours gracieux demande à l’autorité qui a pris la décision de la modifier ou de la retirer.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recours non juridictionnels – Administratifs",
    question: "Un recours hiérarchique est adressé :",
    options: [
      "Au supérieur de l’auteur de la décision",
      "À l’agent qui a exécuté la décision",
      "Au Président de la République uniquement",
    ],
    answer: "Au supérieur de l’auteur de la décision",
    explanation:
        "On s’adresse au supérieur hiérarchique pour qu’il réexamine la décision et la confirme ou l’annule.",
    difficulty: "Facile",
  ),

  // ---------- Recours non juridictionnels – politiques ----------
  const QuizQuestion(
    category: "Recours à caractère politique",
    question: "Le droit de pétition permet principalement :",
    options: [
      "De saisir le juge administratif",
      "D’adresser une demande ou une protestation à une autorité publique",
      "De saisir directement la Cour de cassation",
    ],
    answer:
        "D’adresser une demande ou une protestation à une autorité publique",
    explanation:
        "La pétition est un moyen d’expression politique, souvent collectif, adressé à une institution.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Recours à caractère politique",
    question: "L’objection de conscience concerne traditionnellement :",
    options: [
      "Le refus de payer l’impôt sur le revenu",
      "Le refus d’accomplir le service militaire armé",
      "Le refus de répondre à un contrôle d’identité",
    ],
    answer: "Le refus d’accomplir le service militaire armé",
    explanation:
        "L’objection de conscience vise le refus de porter les armes pour des raisons religieuses, philosophiques ou morales.",
    difficulty: "Facile",
  ),

  // ---------- Résistance à l’oppression ----------
  const QuizQuestion(
    category: "Résistance à l’oppression",
    question: "La résistance à l’oppression est mentionnée dans :",
    options: [
      "Le Code de la sécurité intérieure",
      "La Déclaration des droits de l’Homme et du citoyen de 1789",
      "Le Code de procédure pénale",
    ],
    answer: "La Déclaration des droits de l’Homme et du citoyen de 1789",
    explanation:
        "L’article 2 de la DDHC évoque le droit de résistance à l’oppression comme un droit naturel et imprescriptible.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Résistance à l’oppression",
    question:
        "Pour un policier, la notion de résistance à l’oppression rappelle notamment que :",
    options: [
      "Il doit toujours obéir sans discuter à sa hiérarchie",
      "Il ne doit jamais appliquer un ordre manifestement illégal et gravement attentatoire aux libertés",
      "Il peut décider seul de suspendre une loi",
    ],
    answer:
        "Il ne doit jamais appliquer un ordre manifestement illégal et gravement attentatoire aux libertés",
    explanation:
        "Le policier doit refuser d’exécuter un ordre manifestement illégal, spécialement lorsqu’il porte gravement atteinte aux droits fondamentaux.",
    difficulty: "Facile",
  ),

  // ---------- Défenseur des droits – généralités ----------
  const QuizQuestion(
    category: "Défenseur des droits – Généralités",
    question: "Le Défenseur des droits est :",
    options: [
      "Une juridiction administrative",
      "Une autorité constitutionnelle indépendante",
      "Un service du ministère de l’Intérieur",
    ],
    answer: "Une autorité constitutionnelle indépendante",
    explanation:
        "Le Défenseur des droits est une autorité indépendante, mentionnée dans la Constitution.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Défenseur des droits – Généralités",
    question: "Le Défenseur des droits est nommé pour une durée de :",
    options: [
      "3 ans renouvelable",
      "6 ans non renouvelable",
      "9 ans renouvelable",
    ],
    answer: "6 ans non renouvelable",
    explanation:
        "Son mandat de 6 ans non renouvelable garantit son indépendance vis-à-vis des pouvoirs publics.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Défenseur des droits – Généralités",
    question: "Le Défenseur des droits peut être saisi :",
    options: [
      "Uniquement par un avocat",
      "Par toute personne physique ou morale, gratuitement",
      "Uniquement par un préfet",
    ],
    answer: "Par toute personne physique ou morale, gratuitement",
    explanation:
        "L’accès au Défenseur des droits est gratuit et ouvert à tous.",
    difficulty: "Facile",
  ),

  // ---------- Défenseur des droits – Missions ----------
  const QuizQuestion(
    category: "Défenseur des droits – Missions",
    question: "Parmi les missions du Défenseur des droits figure :",
    options: [
      "L’organisation des élections législatives",
      "La protection et la promotion des droits de l’enfant",
      "La rédaction des lois",
    ],
    answer: "La protection et la promotion des droits de l’enfant",
    explanation:
        "Le Défenseur des droits veille notamment aux droits de l’enfant et à leur respect.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Défenseur des droits – Missions",
    question: "Le Défenseur des droits intervient aussi pour :",
    options: [
      "Contrôler les permis de construire",
      "Lutter contre les discriminations et promouvoir l’égalité",
      "Diriger la police nationale",
    ],
    answer: "Lutter contre les discriminations et promouvoir l’égalité",
    explanation:
        "La lutte contre les discriminations est au cœur de ses missions.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Défenseur des droits – Déontologie sécurité",
    question:
        "En matière de sécurité, le Défenseur des droits veille notamment :",
    options: [
      "À la répartition budgétaire de la police",
      "Au respect de la déontologie par les personnes exerçant des activités de sécurité",
      "À la nomination des commissaires de police",
    ],
    answer:
        "Au respect de la déontologie par les personnes exerçant des activités de sécurité",
    explanation:
        "L’une des missions est le contrôle de la déontologie des forces de sécurité (art. L. 142-1 CSI).",
    difficulty: "Facile",
  ),

  // ---------- CGLPL – généralités ----------
  const QuizQuestion(
    category:
        "Contrôleur général des lieux de privation de liberté – Généralités",
    question: "Le Contrôleur général des lieux de privation de liberté est :",
    options: [
      "Une autorité administrative indépendante",
      "Un service de police judiciaire",
      "Une juridiction internationale",
    ],
    answer: "Une autorité administrative indépendante",
    explanation:
        "Institué par la loi de 2007, le CGLPL est chargé de contrôler les lieux de privation de liberté.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category:
        "Contrôleur général des lieux de privation de liberté – Compétence",
    question:
        "Le Contrôleur général des lieux de privation de liberté peut visiter :",
    options: [
      "Uniquement les établissements pénitentiaires",
      "Tout lieu de privation de liberté (garde à vue, prison, rétention, hôpital psychiatrique…)",
      "Uniquement les tribunaux",
    ],
    answer:
        "Tout lieu de privation de liberté (garde à vue, prison, rétention, hôpital psychiatrique…)",
    explanation:
        "Sa compétence couvre l’ensemble des lieux où des personnes sont privées de liberté sur décision publique.",
    difficulty: "Facile",
  ),

  // ---------- Organes internationaux – principe ----------
  const QuizQuestion(
    category: "Organes internationaux – Subsidiarité",
    question:
        "Avant de saisir un organe international de protection des droits de l’Homme, la personne doit en principe :",
    options: [
      "S’adresser d’abord au maire de son domicile",
      "Épuiser les voies de recours internes",
      "S’adresser directement à l’ONU sans aucune formalité",
    ],
    answer: "Épuiser les voies de recours internes",
    explanation:
        "C’est le principe de subsidiarité : les organes internationaux n’interviennent qu’en dernier ressort.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Organes internationaux – Généralités",
    question: "La Cour européenne des droits de l’Homme (CEDH) siège :",
    options: ["À Strasbourg", "À Luxembourg", "À Genève"],
    answer: "À Strasbourg",
    explanation:
        "La CEDH contrôle le respect de la Convention européenne des droits de l’Homme par les États membres du Conseil de l’Europe.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Organes internationaux – Généralités",
    question: "La Cour de justice de l’Union européenne (CJUE) siège :",
    options: ["À Strasbourg", "À Luxembourg", "À Bruxelles"],
    answer: "À Luxembourg",
    explanation: "La CJUE veille au respect du droit de l’Union européenne.",
    difficulty: "Facile",
  ),

  // =========================================================
  // ===================== NIVEAU MOYEN ======================
  // =========================================================

  // ---------- Constitution souple / rigide : effets ----------
  const QuizQuestion(
    category: "Types de Constitution – Effets",
    question: "Dans un système de Constitution souple, la loi ordinaire :",
    options: [
      "Peut modifier la Constitution sans procédure spéciale",
      "Est soumise à un contrôle strict de constitutionnalité",
      "Est toujours inférieure au règlement",
    ],
    answer: "Peut modifier la Constitution sans procédure spéciale",
    explanation:
        "La Constitution souple n’est pas protégée par une procédure de révision renforcée : la loi peut la remettre en cause.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Types de Constitution – Effets",
    question:
        "Dans un État à Constitution rigide, la protection des libertés publiques est en principe :",
    options: [
      "Moins forte, car la Constitution est plus difficile à modifier",
      "Renforcée, car la loi doit respecter des normes supérieures plus stables",
      "Indifférente à la hiérarchie des normes",
    ],
    answer:
        "Renforcée, car la loi doit respecter des normes supérieures plus stables",
    explanation:
        "La rigidité de la Constitution garantit une meilleure stabilité des droits fondamentaux.",
    difficulty: "Moyenne",
  ),

  // ---------- Révision constitutionnelle : procédure ----------
  const QuizQuestion(
    category: "Révision constitutionnelle – Procédure",
    question:
        "En application de l’article 89, l’initiative de la révision constitutionnelle appartient :",
    options: [
      "Uniquement au Président de la République",
      "Au Président de la République et aux membres du Parlement",
      "Uniquement au peuple par référendum",
    ],
    answer: "Au Président de la République et aux membres du Parlement",
    explanation:
        "Le projet de révision peut venir du Président sur proposition du Premier ministre ou des parlementaires.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révision constitutionnelle – Procédure",
    question:
        "Après le vote de la révision en termes identiques par les deux chambres, l’adoption définitive peut se faire :",
    options: [
      "Uniquement par référendum",
      "Soit par référendum, soit par le Congrès (3/5 des suffrages exprimés)",
      "Par décret simple du Gouvernement",
    ],
    answer:
        "Soit par référendum, soit par le Congrès (3/5 des suffrages exprimés)",
    explanation:
        "Le Président choisit entre référendum et réunion du Parlement en Congrès.",
    difficulty: "Moyenne",
  ),

  // ---------- Contrôle par voie d’exception ----------
  const QuizQuestion(
    category: "Contrôle par voie d’exception",
    question:
        "Dans le contrôle par voie d’exception, lorsqu’un juge estime une loi inconstitutionnelle :",
    options: [
      "Il l’abroge pour tous les justiciables",
      "Il refuse de l’appliquer au litige dont il est saisi",
      "Il doit saisir le Président de la République",
    ],
    answer: "Il refuse de l’appliquer au litige dont il est saisi",
    explanation:
        "Le juge écarte la loi dans le cas concret, sans nécessairement l’annuler pour l’avenir.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Contrôle par voie d’exception",
    question: "Le contrôle par voie d’exception est qualifié de concret car :",
    options: [
      "Il porte sur la loi indépendamment de tout litige",
      "Il est exercé sans demander l’avis des parties",
      "Il intervient à l’occasion d’un litige particulier",
    ],
    answer: "Il intervient à l’occasion d’un litige particulier",
    explanation:
        "Le juge examine la conformité de la loi parce qu’elle doit être appliquée dans une affaire précise.",
    difficulty: "Moyenne",
  ),

  // ---------- Contrôle par une juridiction constitutionnelle ----------
  const QuizQuestion(
    category: "Contrôle par une juridiction constitutionnelle",
    question:
        "Dans le modèle concentré, la constitutionnalité des lois est contrôlée :",
    options: [
      "Par toutes les juridictions sans distinction",
      "Par une juridiction spécialisée (ex : Conseil constitutionnel)",
      "Par le seul Président de la République",
    ],
    answer: "Par une juridiction spécialisée (ex : Conseil constitutionnel)",
    explanation:
        "Le contrôle est centralisé : seule cette juridiction peut déclarer une loi inconstitutionnelle.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Contrôle par une juridiction constitutionnelle",
    question:
        "L’effet principal d’une décision du Conseil constitutionnel déclarant une loi contraire à la Constitution (a priori) est :",
    options: [
      "La loi est promulguée mais inappliquée",
      "La disposition censurée ne peut être promulguée ni appliquée",
      "Seul le Gouvernement peut choisir de l’appliquer ou non",
    ],
    answer: "La disposition censurée ne peut être promulguée ni appliquée",
    explanation:
        "La décision a un effet erga omnes : la disposition ne peut entrer en vigueur.",
    difficulty: "Moyenne",
  ),

  // ---------- QPC – conditions d’examen ----------
  const QuizQuestion(
    category: "QPC – Conditions",
    question:
        "Pour qu’une juridiction transmette une QPC au Conseil d’État ou à la Cour de cassation, il faut notamment que :",
    options: [
      "La disposition législative soit applicable au litige",
      "La loi n’ait jamais été critiquée politiquement",
      "Le Gouvernement donne son accord",
    ],
    answer: "La disposition législative soit applicable au litige",
    explanation:
        "La QPC ne peut porter que sur une disposition ayant une incidence sur la solution du litige.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QPC – Conditions",
    question: "Parmi les conditions de transmission d’une QPC, on trouve :",
    options: [
      "La question doit être dépourvue de tout caractère sérieux",
      "La disposition ne doit pas avoir déjà été déclarée conforme dans les mêmes conditions",
      "La question doit concerner un règlement administratif",
    ],
    answer:
        "La disposition ne doit pas avoir déjà été déclarée conforme dans les mêmes conditions",
    explanation:
        "Si le Conseil constitutionnel a déjà jugé la disposition conforme dans les mêmes circonstances, la QPC n’est pas transmise.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QPC – Rôle des juridictions suprêmes",
    question:
        "Le Conseil d’État ou la Cour de cassation, saisis d’une QPC, exercent :",
    options: [
      "Un rôle de filtre avant la saisine éventuelle du Conseil constitutionnel",
      "Un contrôle politique des lois",
      "Un contrôle disciplinaire des juges",
    ],
    answer:
        "Un rôle de filtre avant la saisine éventuelle du Conseil constitutionnel",
    explanation:
        "Ils décident, dans un délai encadré, s’il y a lieu ou non de renvoyer la question au Conseil constitutionnel.",
    difficulty: "Moyenne",
  ),

  // ---------- QPC – effets de la décision ----------
  const QuizQuestion(
    category: "QPC – Effets",
    question:
        "Lorsqu’une disposition législative est déclarée inconstitutionnelle à l’occasion d’une QPC :",
    options: [
      "Elle est automatiquement réécrite par le Conseil constitutionnel",
      "Elle est abrogée et ne peut plus être appliquée",
      "Elle n’est écartée que pour le seul requérant",
    ],
    answer: "Elle est abrogée et ne peut plus être appliquée",
    explanation:
        "La décision a une portée générale, même si le Conseil peut différer la date d’abrogation.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QPC – Effets",
    question:
        "Après une déclaration d’inconstitutionnalité, une disposition similaire pourra être réintroduite si :",
    options: [
      "Le Parlement la vote à l’unanimité",
      "Le Conseil constitutionnel change de composition",
      "Un changement de circonstances de droit ou de fait le justifie",
    ],
    answer: "Un changement de circonstances de droit ou de fait le justifie",
    explanation:
        "Le Conseil constitutionnel admet qu’une nouvelle loi puisse intervenir en cas de changement de circonstances.",
    difficulty: "Moyenne",
  ),

  // ---------- Recours devant les juridictions judiciaires ----------
  const QuizQuestion(
    category: "Recours juridictionnels – Juge pénal",
    question:
        "En matière pénale, la victime d’une atteinte à une liberté peut :",
    options: [
      "Porter plainte et se constituer partie civile",
      "Saisir directement le Conseil constitutionnel",
      "Saisir la CEDH sans passer par les juridictions internes",
    ],
    answer: "Porter plainte et se constituer partie civile",
    explanation:
        "La plainte et la constitution de partie civile permettent de déclencher des poursuites et de demander réparation.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recours juridictionnels – Juge civil",
    question: "Le juge civil peut être saisi notamment pour :",
    options: [
      "Annuler un arrêté préfectoral",
      "Réparer une atteinte à la vie privée commise par un particulier",
      "Contrôler la régularité d’un scrutin national",
    ],
    answer: "Réparer une atteinte à la vie privée commise par un particulier",
    explanation:
        "Le juge civil sanctionne les manquements aux droits civils (ex : vie privée, image, honneur).",
    difficulty: "Moyenne",
  ),

  // ---------- Recours judiciaires – actes administratifs ----------
  const QuizQuestion(
    category: "Recours judiciaires – Exception d’illégalité",
    question: "L’exception d’illégalité permet au juge judiciaire :",
    options: [
      "D’annuler un acte administratif pour l’avenir",
      "De refuser d’appliquer un acte administratif illégal dans le litige soumis",
      "De modifier une loi contraire à la Constitution",
    ],
    answer:
        "De refuser d’appliquer un acte administratif illégal dans le litige soumis",
    explanation:
        "L’acte est écarté dans l’affaire mais n’est pas formellement annulé pour tous.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recours judiciaires – Emprise irrégulière",
    question:
        "Lorsque l’administration s’empare d’un bien privé sans respecter la procédure d’expropriation, on parle :",
    options: [
      "D’emprise régulière",
      "D’emprise irrégulière",
      "D’acte administratif détachable",
    ],
    answer: "D’emprise irrégulière",
    explanation:
        "L’emprise irrégulière permet au juge judiciaire de contrôler la dépossession et d’indemniser le propriétaire.",
    difficulty: "Moyenne",
  ),

  // ---------- Voie de fait ----------
  const QuizQuestion(
    category: "Voie de fait",
    question: "La voie de fait se caractérise notamment par :",
    options: [
      "Une simple illégalité mineure",
      "Une atteinte particulièrement grave à une liberté fondamentale ou à la propriété par l’administration",
      "Un litige entre deux particuliers",
    ],
    answer:
        "Une atteinte particulièrement grave à une liberté fondamentale ou à la propriété par l’administration",
    explanation:
        "La voie de fait suppose une gravité telle que l’acte ne peut se rattacher à aucun pouvoir administratif.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Voie de fait",
    question:
        "En cas de voie de fait, le juge compétent pour faire cesser l’atteinte et indemniser la victime est :",
    options: [
      "Le juge administratif exclusivement",
      "Le juge judiciaire",
      "Le Conseil constitutionnel",
    ],
    answer: "Le juge judiciaire",
    explanation:
        "La voie de fait est une exception : elle redonne compétence au juge judiciaire pour sanctionner l’administration.",
    difficulty: "Moyenne",
  ),

  // ---------- Recours administratifs – Indemnité / REP ----------
  const QuizQuestion(
    category: "Recours administratifs – Indemnité",
    question:
        "Dans le cadre d’un recours en indemnité, le juge administratif peut :",
    options: [
      "Annuler la Constitution",
      "Condamner l’administration à verser des dommages-intérêts",
      "Modifier une loi votée par le Parlement",
    ],
    answer: "Condamner l’administration à verser des dommages-intérêts",
    explanation:
        "C’est un recours de pleine juridiction qui porte sur la réparation financière du dommage.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recours administratifs – Excès de pouvoir",
    question:
        "Parmi les causes classiques d’illégalité d’un acte administratif, on trouve :",
    options: [
      "L’incompétence de l’auteur",
      "L’absence de débat politique",
      "Le caractère impopulaire de la mesure",
    ],
    answer: "L’incompétence de l’auteur",
    explanation:
        "Un acte pris par une autorité non compétente est illégal et peut être annulé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Recours administratifs – Excès de pouvoir",
    question: "Le détournement de pouvoir consiste pour l’administration à :",
    options: [
      "Ne pas motiver un acte",
      "Utiliser une compétence à des fins étrangères à l’intérêt général",
      "Prendre une décision en urgence",
    ],
    answer: "Utiliser une compétence à des fins étrangères à l’intérêt général",
    explanation:
        "Le juge peut annuler un acte pris pour un motif personnel ou politique sans lien avec l’objet légal du pouvoir.",
    difficulty: "Moyenne",
  ),

  // ---------- Recours administratifs – Libertés publiques ----------
  const QuizQuestion(
    category: "Recours administratifs – Libertés publiques",
    question:
        "Lorsqu’un arrêté de police limite l’exercice d’une liberté publique, le juge administratif vérifie notamment :",
    options: [
      "La popularité de la mesure",
      "La nécessité et la proportionnalité des restrictions",
      "Le coût financier de la décision",
    ],
    answer: "La nécessité et la proportionnalité des restrictions",
    explanation:
        "En application de la jurisprudence Benjamin, toute atteinte à une liberté doit être nécessaire et proportionnée.",
    difficulty: "Moyenne",
  ),

  // ---------- Responsabilité de l’État du fait des lois ----------
  const QuizQuestion(
    category: "Responsabilité de l’État du fait des lois",
    question:
        "La responsabilité de l’État du fait des lois peut être engagée notamment lorsque :",
    options: [
      "Une loi cause un préjudice spécial et anormal à certains particuliers",
      "Une loi est contestée politiquement",
      "Le Conseil constitutionnel le décide automatiquement",
    ],
    answer:
        "Une loi cause un préjudice spécial et anormal à certains particuliers",
    explanation:
        "Selon la jurisprudence La Fleurette, l’État peut être responsable sans faute pour les dommages causés par une loi.",
    difficulty: "Moyenne",
  ),

  // ---------- Défenseur des droits – Saisine et pouvoirs ----------
  const QuizQuestion(
    category: "Défenseur des droits – Saisine",
    question: "La saisine du Défenseur des droits est :",
    options: [
      "Écrite ou orale, directe ou via un parlementaire",
      "Uniquement possible via un recours gracieux",
      "Soumise à des frais de dossier",
    ],
    answer: "Écrite ou orale, directe ou via un parlementaire",
    explanation:
        "La saisine est simplifiée, gratuite et peut se faire par différents canaux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Défenseur des droits – Pouvoirs",
    question: "Le Défenseur des droits peut, dans le cadre de ses enquêtes :",
    options: [
      "Prononcer directement des peines de prison",
      "Demander la communication de pièces et formuler des recommandations",
      "Modifier à lui seul un règlement de police",
    ],
    answer:
        "Demander la communication de pièces et formuler des recommandations",
    explanation:
        "Il dispose de pouvoirs d’enquête importants mais ses décisions ont une nature principalement recommandatoire.",
    difficulty: "Moyenne",
  ),

  // ---------- CGLPL – Pouvoirs ----------
  const QuizQuestion(
    category: "CGLPL – Pouvoirs d’enquête",
    question:
        "Le Contrôleur général peut se rendre dans un lieu de privation de liberté :",
    options: [
      "Uniquement sur autorisation du préfet",
      "À tout moment, sans préavis particulier",
      "Seulement tous les cinq ans",
    ],
    answer: "À tout moment, sans préavis particulier",
    explanation:
        "La loi lui donne un droit de visite très large, sous réserve de certains secrets protégés.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "CGLPL – Pouvoirs d’enquête",
    question:
        "En cas d’atteinte grave aux droits fondamentaux constatée par le CGLPL, celui-ci peut :",
    options: [
      "Saisir le procureur de la République",
      "Modifier les règles internes de la prison",
      "Prononcer la remise en liberté immédiate",
    ],
    answer: "Saisir le procureur de la République",
    explanation:
        "Le CGLPL peut alerter le parquet et les autorités disciplinaires lorsqu’il constate des faits graves.",
    difficulty: "Moyenne",
  ),

  // ---------- Organes internationaux – Comité discrimination raciale ----------
  const QuizQuestion(
    category: "ONU – Comité discrimination raciale",
    question:
        "Le Comité pour l’élimination de la discrimination raciale contrôle l’application :",
    options: [
      "De la Convention internationale sur l’élimination de toutes les formes de discrimination raciale",
      "De la Convention européenne des droits de l’Homme",
      "Du Traité sur l’Union européenne",
    ],
    answer:
        "De la Convention internationale sur l’élimination de toutes les formes de discrimination raciale",
    explanation:
        "Ce comité, créé en 1969, veille au respect de cette convention par les États parties.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "ONU – Comité discrimination raciale",
    question:
        "Le recours individuel devant le Comité pour l’élimination de la discrimination raciale suppose :",
    options: [
      "Que la personne ait d’abord épuisé les recours internes",
      "Qu’aucun recours interne ne soit possible",
      "Que le Défenseur des droits donne son accord",
    ],
    answer: "Que la personne ait d’abord épuisé les recours internes",
    explanation:
        "C’est l’illustration du principe de subsidiarité en droit international des droits de l’Homme.",
    difficulty: "Moyenne",
  ),

  // ---------- CEDH – Saisine ----------
  const QuizQuestion(
    category: "CEDH – Saisine",
    question:
        "Une requête individuelle devant la Cour européenne des droits de l’Homme peut être introduite par :",
    options: [
      "Toute personne physique, ONG ou groupement de particuliers",
      "Uniquement par un État",
      "Uniquement par le Conseil constitutionnel",
    ],
    answer: "Toute personne physique, ONG ou groupement de particuliers",
    explanation: "La CEDH est largement ouverte aux requêtes individuelles.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "CEDH – Effets",
    question: "En cas de condamnation de la France par la CEDH :",
    options: [
      "La France doit verser une satisfaction équitable et adapter son droit interne",
      "La France peut ignorer la décision sans conséquence",
      "La décision n’a effet que symbolique",
    ],
    answer:
        "La France doit verser une satisfaction équitable et adapter son droit interne",
    explanation:
        "Les arrêts de la CEDH entraînent souvent des réformes législatives ou réglementaires.",
    difficulty: "Moyenne",
  ),

  // ---------- CJUE – Renvoi préjudiciel ----------
  const QuizQuestion(
    category: "CJUE – Renvoi préjudiciel",
    question: "Le renvoi préjudiciel à la CJUE permet :",
    options: [
      "De faire juger un litige entre particuliers",
      "À une juridiction nationale de demander l’interprétation d’une norme de l’UE",
      "Au Gouvernement de faire annuler une loi nationale",
    ],
    answer:
        "À une juridiction nationale de demander l’interprétation d’une norme de l’UE",
    explanation:
        "Le renvoi préjudiciel garantit l’unité d’interprétation du droit de l’Union.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // ============ NIVEAU DIFFICILE (INCL. EXPERT) ============
  // =========================================================

  // ---------- Hiérarchie des normes & libertés ----------
  const QuizQuestion(
    category: "Hiérarchie des normes – Libertés",
    question:
        "Dans la hiérarchie des normes, le « bloc de constitutionnalité » comprend notamment :",
    options: [
      "La Constitution de 1958, la DDHC de 1789, le Préambule de 1946 et la Charte de l’environnement",
      "La Constitution, les décrets et les circulaires",
      "Les seuls traités internationaux relatifs aux droits de l’Homme",
    ],
    answer:
        "La Constitution de 1958, la DDHC de 1789, le Préambule de 1946 et la Charte de l’environnement",
    explanation:
        "Ces textes ont valeur constitutionnelle et protègent directement les droits et libertés.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Hiérarchie des normes – Libertés",
    question:
        "Lorsqu’un règlement de police porte atteinte à une liberté publique, le juge administratif contrôle :",
    options: [
      "Uniquement sa conformité à la loi",
      "Sa conformité à l’ensemble des normes supérieures (Constitution, conventions, lois)",
      "Uniquement sa conformité aux circulaires ministérielles",
    ],
    answer:
        "Sa conformité à l’ensemble des normes supérieures (Constitution, conventions, lois)",
    explanation:
        "Le contrôle s’effectue en fonction de toute la hiérarchie des normes, notamment des textes à valeur constitutionnelle et conventionnelle.",
    difficulty: "Difficile",
  ),

  // ---------- Jurisprudence Benjamin – Police & libertés ----------
  const QuizQuestion(
    category: "Police administrative & libertés – Benjamin",
    question:
        "L’arrêt CE, 19 mai 1933, Benjamin impose à l’autorité de police :",
    options: [
      "De privilégier systématiquement l’interdiction générale des réunions",
      "De concilier liberté et ordre public en recourant aux mesures les moins restrictives possibles",
      "De soumettre toute réunion publique à autorisation préalable",
    ],
    answer:
        "De concilier liberté et ordre public en recourant aux mesures les moins restrictives possibles",
    explanation:
        "Le juge impose un contrôle strict de nécessité et de proportionnalité des mesures de police.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Police administrative & libertés – Benjamin",
    question:
        "Dans le cadre d’un recours contre une interdiction de manifestation, le juge administratif vérifie notamment si :",
    options: [
      "Des moyens de maintien de l’ordre moins attentatoires à la liberté étaient disponibles",
      "L’interdiction était politiquement populaire",
      "La police bénéficiait d’un budget suffisant",
    ],
    answer:
        "Des moyens de maintien de l’ordre moins attentatoires à la liberté étaient disponibles",
    explanation:
        "Si d’autres moyens permettaient de prévenir le trouble à l’ordre public, l’interdiction est jugée disproportionnée.",
    difficulty: "Difficile",
  ),

  // ---------- QPC vs contrôle a priori ----------
  const QuizQuestion(
    category: "QPC & contrôle a priori",
    question:
        "Le contrôle a priori du Conseil constitutionnel et la QPC se distinguent notamment par :",
    options: [
      "Le moment où ils interviennent (avant ou après l’entrée en vigueur de la loi)",
      "Le fait que seul le Président peut les déclencher",
      "Leur absence de lien avec les libertés",
    ],
    answer:
        "Le moment où ils interviennent (avant ou après l’entrée en vigueur de la loi)",
    explanation:
        "Le contrôle a priori intervient avant la promulgation, la QPC porte sur une loi déjà en vigueur.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QPC & contrôle a priori",
    question:
        "La QPC a renforcé la protection des libertés fondamentales car elle permet :",
    options: [
      "De contrôler des lois anciennes à partir de situations concrètes",
      "De modifier directement la Constitution",
      "De contourner la hiérarchie des normes",
    ],
    answer: "De contrôler des lois anciennes à partir de situations concrètes",
    explanation:
        "La QPC ouvre un contrôle a posteriori d’une grande partie du stock législatif.",
    difficulty: "Difficile",
  ),

  // ---------- Articulation QPC / conventions internationales ----------
  const QuizQuestion(
    category: "QPC & conventions internationales",
    question:
        "Face à une loi contraire à la fois à la Constitution et à la CEDH, un justiciable peut invoquer :",
    options: [
      "Seulement la CEDH",
      "Seulement la Constitution",
      "La QPC pour la Constitution et un moyen de conventionnalité pour la CEDH",
    ],
    answer:
        "La QPC pour la Constitution et un moyen de conventionnalité pour la CEDH",
    explanation:
        "Les deux contrôles coexistent : constitutionnalité via QPC, conventionnalité via les juges ordinaires.",
    difficulty: "Difficile",
  ),

  // ---------- Recours administratifs d’urgence – Référé-liberté ----------
  const QuizQuestion(
    category: "Référé-liberté",
    question: "Le référé-liberté permet au juge administratif de :",
    options: [
      "Statuer en urgence pour faire cesser une atteinte grave et manifestement illégale à une liberté fondamentale",
      "Réviser la Constitution",
      "Sanctionner pénalement un agent public",
    ],
    answer:
        "Statuer en urgence pour faire cesser une atteinte grave et manifestement illégale à une liberté fondamentale",
    explanation:
        "Introduit par la loi de 2000, il offre un outil de protection rapide des libertés.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Référé-liberté",
    question: "Pour qu’un référé-liberté soit recevable, il faut notamment :",
    options: [
      "Une atteinte grave et manifestement illégale à une liberté fondamentale",
      "Un délai d’au moins un an après la décision contestée",
      "L’accord préalable du préfet",
    ],
    answer:
        "Une atteinte grave et manifestement illégale à une liberté fondamentale",
    explanation:
        "Le juge des référés intervient en urgence pour sauvegarder une liberté fondamentale menacée.",
    difficulty: "Difficile",
  ),

  // ---------- Voie de fait / compétence judiciaire vs administrative ----------
  const QuizQuestion(
    category: "Voie de fait – Compétence",
    question: "La qualification de voie de fait emporte principalement :",
    options: [
      "Compétence du juge administratif",
      "Compétence du juge judiciaire pour faire cesser l’atteinte et indemniser",
      "Compétence du Défenseur des droits pour prononcer une sanction pénale",
    ],
    answer:
        "Compétence du juge judiciaire pour faire cesser l’atteinte et indemniser",
    explanation:
        "La voie de fait retire exceptionnellement la compétence au juge administratif.",
    difficulty: "Difficile",
  ),

  // ---------- Responsabilité de l’État du fait des lois – Conditions détaillées ----------
  const QuizQuestion(
    category: "Responsabilité de l’État du fait des lois – Conditions",
    question:
        "Selon la jurisprudence La Fleurette, la responsabilité de l’État du fait d’une loi suppose que :",
    options: [
      "Le législateur ait expressément prévu l’absence d’indemnisation",
      "Le préjudice soit spécial, anormal, et ne résulte pas d’une activité illicite",
      "La loi soit déclarée inconstitutionnelle",
    ],
    answer:
        "Le préjudice soit spécial, anormal, et ne résulte pas d’une activité illicite",
    explanation:
        "L’État peut être responsable même sans faute si ces conditions sont remplies.",
    difficulty: "Difficile",
  ),

  // ---------- Défenseur des droits & police – Expert ----------
  const QuizQuestion(
    category: "Défenseur des droits & Police",
    question:
        "En matière de déontologie des forces de sécurité, le Défenseur des droits peut :",
    options: [
      "Prononcer directement des sanctions disciplinaires contre les policiers",
      "Recommander des sanctions disciplinaires à l’autorité compétente",
      "Modifier le Code de déontologie de la police",
    ],
    answer: "Recommander des sanctions disciplinaires à l’autorité compétente",
    explanation:
        "Il exerce un pouvoir d’influence important mais ne se substitue pas aux autorités disciplinaires.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Défenseur des droits & Police",
    question:
        "Pour un policier, la saisine du Défenseur des droits par un citoyen implique :",
    options: [
      "Une obligation de coopérer et de répondre aux demandes d’information",
      "Un droit de refuser toute information pour ne pas se compromettre",
      "Une suspension automatique du service",
    ],
    answer:
        "Une obligation de coopérer et de répondre aux demandes d’information",
    explanation:
        "Le refus de coopération peut être signalé et avoir des conséquences disciplinaires.",
    difficulty: "Difficile",
  ),

  // ---------- CGLPL & locaux de garde à vue – Expert ----------
  const QuizQuestion(
    category: "CGLPL & Garde à vue",
    question:
        "Lors d’une visite de locaux de garde à vue, le CGLPL porte une attention particulière :",
    options: [
      "Aux conditions matérielles, au respect de la dignité et à l’accès aux droits (avocat, médecin, famille…)",
      "Uniquement au nombre d’interpellations réalisées",
      "À la performance statistique du service",
    ],
    answer:
        "Aux conditions matérielles, au respect de la dignité et à l’accès aux droits (avocat, médecin, famille…)",
    explanation:
        "Le CGLPL veille à ce que la privation de liberté s’exerce dans des conditions respectueuses des droits fondamentaux.",
    difficulty: "Difficile",
  ),

  // ---------- CEDH – Recevabilité & procédure – Expert ----------
  const QuizQuestion(
    category: "CEDH – Recevabilité",
    question:
        "Pour qu’une requête soit recevable devant la CEDH, il faut notamment :",
    options: [
      "Que le requérant ait épuisé les voies de recours internes et agisse dans un certain délai après la décision interne définitive",
      "Que le Défenseur des droits donne son accord écrit",
      "Que le Gouvernement français ne s’y oppose pas",
    ],
    answer:
        "Que le requérant ait épuisé les voies de recours internes et agisse dans un certain délai après la décision interne définitive",
    explanation:
        "Le principe de subsidiarité impose d’utiliser d’abord les recours internes avant de saisir la CEDH.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "CEDH – Effets en droit interne",
    question:
        "Les condamnations de la France par la CEDH ont pour conséquence :",
    options: [
      "Uniquement le versement d’une indemnité à la victime",
      "Souvent une réforme de la législation ou de la pratique administrative",
      "La nullité de toutes les lois votées dans l’année",
    ],
    answer:
        "Souvent une réforme de la législation ou de la pratique administrative",
    explanation:
        "Les États doivent tirer les conséquences des arrêts de la CEDH pour éviter de nouvelles violations.",
    difficulty: "Difficile",
  ),

  // ---------- CJUE & données personnelles / police – Expert ----------
  const QuizQuestion(
    category: "CJUE & Libertés – Données",
    question:
        "Les décisions de la CJUE en matière de protection des données personnelles influencent :",
    options: [
      "Uniquement les entreprises privées",
      "Les pratiques policières (fichiers, conservation des données, échanges d’informations)",
      "Uniquement les réseaux sociaux",
    ],
    answer:
        "Les pratiques policières (fichiers, conservation des données, échanges d’informations)",
    explanation:
        "Les policiers doivent respecter le droit de l’Union en matière de protection des données.",
    difficulty: "Difficile",
  ),

  // ---------- Synthèse – Garanties multiples des libertés ----------
  const QuizQuestion(
    category: "Synthèse – Garanties des libertés",
    question:
        "La protection des libertés publiques en France repose notamment sur :",
    options: [
      "La seule activité du Parlement",
      "Un ensemble de garanties combinées (Constitution, QPC, recours juridictionnels, autorités indépendantes, organes internationaux)",
      "La seule intervention des organes internationaux",
    ],
    answer:
        "Un ensemble de garanties combinées (Constitution, QPC, recours juridictionnels, autorités indépendantes, organes internationaux)",
    explanation:
        "C’est l’articulation de ces différents mécanismes qui assure une protection effective des libertés.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizGarantiesLibertesPageGPX extends StatefulWidget {
  static const String grade = 'gpx';
  static const String routeName =
      '/gpx/generalites/quiz/garanties_libertes_publiques';

  final String uid;
  final String email;

  const QuizGarantiesLibertesPageGPX({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizGarantiesLibertesPageGPX> createState() => _QuizGarantiesLibertesPageGPXState();
}

class _QuizGarantiesLibertesPageGPXState extends State<QuizGarantiesLibertesPageGPX>
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
  static const _introHiddenKey = 'intro_gpx_libertes_publiques_garanties';
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
  int? _historyRowId; // id (int) retour insert quiz_history
  SupabaseClient get _sb => Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _page = PageController(initialPage: 0);
    _rng = math.Random(DateTime.now().millisecondsSinceEpoch);

    // --- Audio ---
    _goodSfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    _badSfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

    // Pré-charge pour éviter le délai au premier play
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
    final pool = useAll
        ? questionsGarantiesLibertesPubliques
        : questionsGarantiesLibertesPubliques
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

  // ==========================================================================
  // SUPABASE
  // ==========================================================================
  Future<void> _createHistoryOnStart() async {
    try {
      final res = await _sb
          .from('quiz_history')
          .insert({
            'uid': widget.uid,
            'email': widget.email,
            
            'grade': UserContextService.I.trackOrDefault,
            'track': UserContextService.I.trackOrDefault,
            'mode': UserContextService.I.modeOrDefault,'module_name': 'Généralités',
            'quiz_name': 'Garanties des libertés publiques',
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
      final int answered = _answers.where((a) => a != null).length;
      final int totalForScore = answered <= 0 ? 1 : answered;
      final int percent = (_score * 100 ~/ totalForScore).clamp(0, 100);

      await _sb
          .from('quiz_history')
          .update({
            'score': percent, // pourcentage final
            'correct_count': _score, // nb de bonnes réponses
            'finished_at': DateTime.now().toUtc().toIso8601String(),
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _historyRowId!)
          .eq('uid', widget.uid); // important pour la RLS
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
      await _sb.from('quiz_garanties_libertes').insert({
        'user_uid': widget.uid,
        'email': widget.email,
        
            'grade': UserContextService.I.trackOrDefault,'question': question,
        'user_answer': userAnswer,
        'correct_answer': correctAnswer,
        'is_correct': isCorrect,
        'score': _score, // score cumulé au moment T
        'difficulty': difficulty,
      });
    } catch (e) {
      debugPrint('❌ quiz_garanties_libertes insert failed: $e');
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
    } catch (_) {
      // on ignore les erreurs audio
    }
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
      'source_file': 'gpx_quiz_libertes_publiques_garanties_page',
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
                            icon: Icons.verified_user_rounded,
                            title: 'Garanties des libertés',
                            description: 'Comprends les mécanismes de garantie des libertés publiques : rôle du juge, contrôle de constitutionnalité et recours disponibles.',
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
          message: 'Tu maîtrises les garanties des libertés publiques 💪',
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
          message: 'Reprends les cours',
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
