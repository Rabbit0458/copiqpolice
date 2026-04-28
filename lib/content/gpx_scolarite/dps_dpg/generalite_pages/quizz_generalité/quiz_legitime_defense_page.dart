// ignore_for_file: use_build_context_synchronously

// ============================================================================
//  Quiz LegitimeDefense – version refondue
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

// ---------------------------------------------------------------
// BANQUE DES QUESTIONS : colle exactement ce que tu avais déjà.
// (tronqué ici pour la réponse ; garde ta liste complète existante)
// ---------------------------------------------------------------

/// Banque de questions du **QUIZ LEGITIME DEFENSE**
/// Toutes les questions portent sur :
/// - la légitime défense des personnes (art. 122-5 C. pén.)
/// - la légitime défense des biens (art. 122-5 al. 2 C. pén.)
/// - les cas présumés de légitime défense (art. 122-6 C. pén.)

final List<QuizQuestion> questionsLegitimeDefense = [
  // ===================== FACILE (≈30) =====================
  QuizQuestion(
    category: "Généralités",
    question:
        "La légitime défense fait partie de quelle catégorie juridique en droit pénal ?",
    options: [
      "Une circonstance aggravante",
      "Un fait justificatif",
      "Une excuse atténuante",
    ],
    answer: "Un fait justificatif",
    explanation:
        "La légitime défense est un fait justificatif qui rend l'acte pénalement non punissable.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Généralités",
    question:
        "Lorsque la légitime défense est reconnue, la personne ayant commis l'acte de défense est :",
    options: [
      "Pénalement responsable mais excusée",
      "Pénalement irresponsable",
      "Simplement condamnée avec sursis",
    ],
    answer: "Pénalement irresponsable",
    explanation:
        "Le texte précise : « N'est pas pénalement responsable la personne qui… accomplit un acte commandé par la nécessité de la légitime défense ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Légitime défense des personnes",
    question:
        "Selon le document, la légitime défense des personnes est prévue par :",
    options: [
      "L'article 122-4 du Code pénal",
      "L'article 122-5 du Code pénal",
      "L'article 122-6 du Code pénal",
    ],
    answer: "L'article 122-5 du Code pénal",
    explanation:
        "Le titre I indique : « LA LÉGITIME DÉFENSE D'UNE PERSONNE art. 122-5 C.P. ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Légitime défense des personnes",
    question:
        "La légitime défense des personnes suppose une atteinte injustifiée envers :",
    options: [
      "Uniquement la personne elle-même",
      "Uniquement autrui",
      "La personne elle-même ou autrui",
    ],
    answer: "La personne elle-même ou autrui",
    explanation:
        "Le texte vise « une atteinte injustifiée envers elle-même ou autrui ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Légitime défense des personnes",
    question:
        "Combien de conditions principales sont listées pour qu'une personne soit en situation de légitime défense DES PERSONNES ?",
    options: [
      "Deux grands groupes de conditions",
      "Trois grands groupes de conditions",
      "Une seule condition globale",
    ],
    answer: "Deux grands groupes de conditions",
    explanation:
        "Le schéma distingue : I- Lorsqu'une personne subit une atteinte ; II- Elle ou une autre personne peut accomplir un acte de défense.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Atteinte - Personnes",
    question:
        "Pour la légitime défense des personnes, l'atteinte doit être injustifiée. Cela signifie :",
    options: [
      "Qu'elle est autorisée par la loi",
      "Qu'elle est sans motif légitime, contraire au droit",
      "Qu'elle est simplement violente",
    ],
    answer: "Qu'elle est sans motif légitime, contraire au droit",
    explanation:
        "Le document précise : « INJUSTIFIÉE : sans motif légitime, contraire au droit ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Atteinte - Personnes",
    question:
        "Une atteinte \"actuelle\" au sens de la légitime défense des personnes signifie :",
    options: [
      "Qu'elle a eu lieu dans le passé",
      "Qu'elle se produit ou est imminente",
      "Qu'elle aura lieu plus tard",
    ],
    answer: "Qu'elle se produit ou est imminente",
    explanation:
        "Le texte précise : « ACTUELLE : en train de se produire ou sur le point de se réaliser (imminente) ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Atteinte - Personnes",
    question:
        "Pour être en état de légitime défense, l'atteinte doit être réelle. Cela implique :",
    options: [
      "Qu'une simple crainte subjective suffit",
      "Qu'il faut une existence certaine de l'atteinte",
      "Qu'on peut se fier uniquement à un ressenti",
    ],
    answer: "Qu'il faut une existence certaine de l'atteinte",
    explanation:
        "Le document indique : « RÉELLE : L'atteinte doit exister de manière certaine. Une crainte subjective ne suffit pas ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Acte de défense - Personnes",
    question:
        "Pour la légitime défense des personnes, un acte de défense \"nécessaire\" signifie :",
    options: [
      "Qu'il est le plus efficace possible",
      "Que la personne n'a aucun autre moyen de se soustraire au danger",
      "Qu'il inflige le maximum de dommages à l'agresseur",
    ],
    answer: "Que la personne n'a aucun autre moyen de se soustraire au danger",
    explanation:
        "Le texte précise : « Il faut que la personne atteinte n'ait aucun autre moyen de se soustraire au danger ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Acte de défense - Personnes",
    question:
        "Dans la légitime défense des personnes, l'acte de défense doit être :",
    options: [
      "Nécessaire, simultané et proportionné",
      "Préventif, secret et symbolique",
      "Long, réfléchi et planifié",
    ],
    answer: "Nécessaire, simultané et proportionné",
    explanation:
        "Le schéma liste ces trois conditions pour l'acte de défense : nécessaire, simultané, proportionné.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Acte de défense - Personnes",
    question:
        "Un acte de défense \"simultané\" signifie que la personne se défend :",
    options: [
      "Avant toute atteinte possible",
      "Immédiatement par rapport à l'atteinte",
      "Longtemps après l'atteinte",
    ],
    answer: "Immédiatement par rapport à l'atteinte",
    explanation:
        "Le document indique : « SIMULTANÉ : immédiat par rapport à l'atteinte ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Acte de défense - Personnes",
    question:
        "Peut-on invoquer la légitime défense pour une réaction tardive à une agression passée (vengeance) ?",
    options: [
      "Oui, car l'agresseur a déjà commis une faute",
      "Non, la défense ne doit pas être tardive",
      "Oui, uniquement si l'on prévient la police ensuite",
    ],
    answer: "Non, la défense ne doit pas être tardive",
    explanation:
        "Le schéma précise qu'on ne peut se défendre « par réaction tardive à une atteinte déjà passée (vengeance) ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Acte de défense - Personnes",
    question:
        "La condition de proportionnalité, pour la légitime défense des personnes, signifie que :",
    options: [
      "On peut infliger un mal illimité à l'agresseur",
      "Les moyens de défense doivent être mesurés et en rapport avec la gravité de l'atteinte",
      "On doit toujours utiliser une arme",
    ],
    answer:
        "Les moyens de défense doivent être mesurés et en rapport avec la gravité de l'atteinte",
    explanation:
        "Le texte indique : « Les moyens de défense employés doivent être mesurés et en rapport avec la gravité de l'atteinte ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Légitime défense des biens",
    question:
        "La légitime défense des biens est prévue par quel texte selon le document ?",
    options: [
      "Article 122-5 alinéa 2 du Code pénal",
      "Article 122-6 du Code pénal",
      "Article 122-7 du Code pénal",
    ],
    answer: "Article 122-5 alinéa 2 du Code pénal",
    explanation:
        "Le titre II mentionne : « LA LÉGITIME DÉFENSE D'UN BIEN art. 122-5 al. 2 C.P. ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Légitime défense des biens",
    question: "La légitime défense des biens est décrite comme :",
    options: [
      "Plus large que celle des personnes",
      "Plus limitée que celle des personnes",
      "Strictement identique à celle des personnes",
    ],
    answer: "Plus limitée que celle des personnes",
    explanation:
        "Le texte précise : « Plus limitée que celle des personnes, elle est autorisée… ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Légitime défense des biens",
    question:
        "Pour invoquer la légitime défense d'un bien, celui-ci doit être menacé par :",
    options: [
      "Une simple contravention",
      "Un crime ou un délit",
      "Une injonction administrative",
    ],
    answer: "Un crime ou un délit",
    explanation:
        "Le schéma indique : « Lorsqu'un bien est menacé par l'exécution d'un CRIME ou d'un DÉLIT ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Légitime défense des biens",
    question:
        "Dans la légitime défense d'un bien, l'acte de défense NE doit PAS être :",
    options: [
      "Un acte nécessaire",
      "Un homicide volontaire",
      "Proportionné à la gravité de l'infraction",
    ],
    answer: "Un homicide volontaire",
    explanation:
        "Le texte précise : « un acte de défense, autre qu'un homicide volontaire ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Légitime défense des biens",
    question:
        "La légitime défense des biens impose que l'acte de défense soit :",
    options: [
      "Strictement nécessaire au but poursuivi",
      "Simplement utile",
      "Symbolique",
    ],
    answer: "Strictement nécessaire au but poursuivi",
    explanation:
        "Le texte mentionne : « lorsque cet acte est strictement nécessaire au but poursuivi ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Cas présumés",
    question: "Les cas présumés de légitime défense sont prévus à l'article :",
    options: [
      "122-5 du Code pénal",
      "122-6 du Code pénal",
      "122-7 du Code pénal",
    ],
    answer: "122-6 du Code pénal",
    explanation:
        "Le titre III indique : « CAS PRÉSUMÉS DE LÉGITIME DÉFENSE art. 122-6 C.P. ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Cas présumés",
    question:
        "Dans les cas présumés de légitime défense, la personne ayant accompli l'acte est :",
    options: [
      "Présumée avoir agi en état de légitime défense",
      "Présumée coupable d'une infraction",
      "Présumée irresponsable pour cause de trouble mental",
    ],
    answer: "Présumée avoir agi en état de légitime défense",
    explanation:
        "Le texte d'en-tête précise : « EST PRÉSUMÉ AVOIR AGI EN ÉTAT DE LÉGITIME DÉFENSE : CELUI QUI ACCOMPLIT L'ACTE… ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Cas présumés - 1er cas",
    question:
        "Dans le premier cas présumé de légitime défense, l'acte vise à :",
    options: [
      "Empêcher un vol sur la voie publique",
      "Repousser de nuit l'entrée dans un lieu habité",
      "Protéger un véhicule stationné sur un parking public",
    ],
    answer: "Repousser de nuit l'entrée dans un lieu habité",
    explanation:
        "Le schéma indique : « pour REPOUSSER, DE NUIT [...] L'ENTRÉE [...] DANS UN LIEU HABITÉ ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Cas présumés - 1er cas",
    question: "Le premier cas présumé de légitime défense suppose une entrée :",
    options: [
      "Par effraction, violence ou ruse",
      "Par simple négligence du propriétaire",
      "Par invitation préalable",
    ],
    answer: "Par effraction, violence ou ruse",
    explanation:
        "Le texte liste : « par EFFRACTION ou par VIOLENCE ou par RUSE ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Cas présumés - 1er cas",
    question:
        "Le lieu visé dans le premier cas présumé de légitime défense est :",
    options: [
      "Un local commercial",
      "Un lieu habité (maison ou appartement habités)",
      "Un terrain vague",
    ],
    answer: "Un lieu habité (maison ou appartement habités)",
    explanation:
        "Le schéma précise : « DANS UN LIEU HABITÉ : (maison ou appartement habités.) ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Cas présumés - 1er cas",
    question:
        "Dans le premier cas présumé, la notion de \"nuit\" est définie comme :",
    options: [
      "Toute période après 22 h",
      "Toute période avant 6 h",
      "L'intervalle de temps entre le coucher et le lever du soleil",
    ],
    answer: "L'intervalle de temps entre le coucher et le lever du soleil",
    explanation:
        "Le document rappelle : « DE NUIT (intervalle de temps compris entre le coucher et le lever du soleil) ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Cas présumés - 2e cas",
    question:
        "Dans le deuxième cas présumé de légitime défense, on se défend contre les auteurs :",
    options: [
      "De vols ou de pillages",
      "De simples injures",
      "De contraventions routières",
    ],
    answer: "De vols ou de pillages",
    explanation:
        "Le schéma vise : « contre les auteurs de VOLS ou de PILLAGES ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Cas présumés - 2e cas",
    question:
        "Dans le deuxième cas présumé, les vols ou pillages doivent être :",
    options: [
      "Simples, sans violence",
      "Exécutés avec violence",
      "Uniquement commis de nuit",
    ],
    answer: "Exécutés avec violence",
    explanation:
        "Le schéma précise : « EXÉCUTÉS avec VIOLENCE : (Coups, tortures, etc.) ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Cas présumés - 2e cas",
    question:
        "Le deuxième cas présumé de légitime défense s'applique lorsque la personne se défend :",
    options: [
      "Uniquement de nuit",
      "Uniquement de jour",
      "De jour comme de nuit",
    ],
    answer: "De jour comme de nuit",
    explanation:
        "Le texte indique : « Pour SE DÉFENDRE DE JOUR comme de NUIT contre les auteurs… ».",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Cas présumés - nature de la présomption",
    question:
        "La présomption de légitime défense prévue à l'article 122-6 est :",
    options: [
      "Une présomption irréfragable",
      "Une présomption simple pouvant être renversée par la preuve contraire",
      "Une présomption uniquement morale",
    ],
    answer:
        "Une présomption simple pouvant être renversée par la preuve contraire",
    explanation:
        "Le document précise : « Dans les 2 cas, il s'agit d'une PRÉSOMPTION de légitime défense qui peut donc céder devant la preuve contraire. »",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Généralités",
    question:
        "Dans les cas présumés de légitime défense, qui peut apporter la preuve contraire pour renverser la présomption ?",
    options: [
      "La personne poursuivie uniquement",
      "Le juge ou le ministère public au moyen du dossier",
      "Aucun, la présomption est absolue",
    ],
    answer: "Le juge ou le ministère public au moyen du dossier",
    explanation:
        "La mention « peut céder devant la preuve contraire » signifie que la présomption peut être renversée si le juge est convaincu par les éléments du dossier.",
    difficulty: "Facile",
  ),

  // ===================== MOYENNE (≈30) =====================
  QuizQuestion(
    category: "Personnes - Atteinte",
    question:
        "Une personne reçoit un message anonyme disant : « Je te frapperai demain ». Elle frappe aujourd'hui l'auteur supposé. Peut-elle invoquer la légitime défense des personnes ?",
    options: [
      "Oui, car elle avait peur",
      "Non, l'attaque n'était ni actuelle ni imminente",
      "Oui, car la menace constitue une atteinte réelle",
    ],
    answer: "Non, l'attaque n'était ni actuelle ni imminente",
    explanation:
        "La légitime défense exige une atteinte ACTUELLE ou imminente, pas une simple menace future basée sur une crainte subjective.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Personnes - Atteinte",
    question:
        "Un individu estime que son voisin pourrait un jour l'agresser en raison d'un conflit de voisinage. Il achète une arme et tire préventivement. Selon le document, la légitime défense :",
    options: [
      "S'applique car il anticipait une attaque",
      "Ne s'applique pas car on ne peut se défendre contre une attaque future ou éventuelle",
      "S'applique seulement si le voisin est condamné pour menaces",
    ],
    answer:
        "Ne s'applique pas car on ne peut se défendre contre une attaque future ou éventuelle",
    explanation:
        "Le texte précise que l'acte de défense ne peut viser « une attaque future ou éventuelle (peur) ».",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Personnes - Atteinte",
    question:
        "Un automobiliste pense qu'un piéton va peut-être l'insulter et le frappe avant toute parole. L'atteinte qu'il invoque est-elle réelle au sens du document ?",
    options: [
      "Oui, car il est convaincu d'être menacé",
      "Non, il ne s'agit que d'une crainte subjective",
      "Oui, dès qu'il y a conflit verbal",
    ],
    answer: "Non, il ne s'agit que d'une crainte subjective",
    explanation:
        "Le document souligne qu'une « crainte subjective ne suffit pas » : l'atteinte doit exister de manière certaine.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Personnes - Acte de défense",
    question:
        "Une victime poursuivie dans la rue peut fuir sans danger mais préfère rester et frapper lourdement son poursuivant. La condition de nécessité est-elle remplie ?",
    options: [
      "Oui, car elle peut choisir la riposte",
      "Non, puisqu'elle disposait d'un autre moyen de se soustraire au danger (la fuite sans risque)",
      "Oui, car la fuite n'est jamais exigée",
    ],
    answer:
        "Non, puisqu'elle disposait d'un autre moyen de se soustraire au danger (la fuite sans risque)",
    explanation:
        "La défense doit être NÉCESSAIRE : s'il existe une autre issue sûre pour échapper au danger, cette condition peut faire défaut.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Personnes - Simultanéité",
    question:
        "Une personne est giflée dans un bar. Dix minutes plus tard, à l'extérieur, elle revient frapper violemment l'auteur de la gifle. Peut-elle invoquer la légitime défense ?",
    options: [
      "Oui, car il y a eu une atteinte initiale",
      "Non, il s'agit d'une réaction tardive assimilable à de la vengeance",
      "Oui, si la gifle était très forte",
    ],
    answer:
        "Non, il s'agit d'une réaction tardive assimilable à de la vengeance",
    explanation:
        "Le texte exclut « la réaction tardive à une atteinte déjà passée (vengeance) » de la légitime défense.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Personnes - Proportionnalité",
    question:
        "Quel exemple illustre un défaut de proportionnalité entre l'atteinte et la défense ?",
    options: [
      "Repousser un coup de poing par un coup de poing",
      "Répondre à une claque par plusieurs coups de couteau mortels",
      "Repousser une saisie par une poussée pour se dégager",
    ],
    answer: "Répondre à une claque par plusieurs coups de couteau mortels",
    explanation:
        "La riposte doit être proportionnée à la gravité de l'atteinte ; ici, l'emploi d'une arme létale est manifestement excessif.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Biens - Infraction en cours",
    question:
        "Pour la légitime défense d'un bien, l'acte de défense a pour but principal :",
    options: [
      "D'interrompre l'exécution du crime ou du délit contre le bien",
      "De punir l'auteur après coup",
      "De récupérer la chose volée après plusieurs jours",
    ],
    answer: "D'interrompre l'exécution du crime ou du délit contre le bien",
    explanation:
        "Le texte parle d'un acte de défense visant à « interrompre l'exécution d'un crime ou d'un délit contre un bien ».",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Biens - Homicide exclu",
    question:
        "Un propriétaire surprend un voleur en train de briser la vitre de sa voiture et lui tire dessus mortellement. Peut-il en principe invoquer la légitime défense DES BIENS ?",
    options: [
      "Oui, car c'est un crime contre un bien",
      "Non, car la légitime défense des biens exclut l'homicide volontaire",
      "Oui si la valeur de la voiture est très importante",
    ],
    answer:
        "Non, car la légitime défense des biens exclut l'homicide volontaire",
    explanation:
        "L'article 122-5 al. 2 vise un « acte de défense, autre qu'un homicide volontaire ».",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Biens - Proportionnalité",
    question:
        "Un commerçant surprend un voleur qui emporte une tablette de chocolat. Il le frappe avec une barre de fer lui causant une ITT de 30 jours. La condition de proportionnalité est-elle respectée ?",
    options: [
      "Oui, car le vol est un délit",
      "Non, la riposte est manifestement disproportionnée à la gravité du vol",
      "Oui, car la loi autorise toute violence en cas de vol",
    ],
    answer:
        "Non, la riposte est manifestement disproportionnée à la gravité du vol",
    explanation:
        "Les moyens employés doivent être proportionnés à la gravité de l'infraction ; une violence grave pour un objet de faible valeur est excessive.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Biens - Charge de la preuve",
    question:
        "Selon le document, en cas de légitime défense des biens, qui doit démontrer que la proportionnalité des moyens a été respectée ?",
    options: [
      "Le ministère public",
      "La personne poursuivie",
      "La victime du vol",
    ],
    answer: "La personne poursuivie",
    explanation:
        "Le texte indique : « Il appartient à la personne poursuivie de démontrer que le principe de proportionnalité a été respecté ».",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Biens - Nature de l'infraction",
    question:
        "La tentative de vol d'un bien (délit) en cours d'exécution peut-elle, en principe, justifier la légitime défense des biens ?",
    options: [
      "Oui, car il s'agit d'un délit contre un bien en cours d'exécution",
      "Non, car la tentative ne compte pas",
      "Uniquement si le bien est de grande valeur",
    ],
    answer: "Oui, car il s'agit d'un délit contre un bien en cours d'exécution",
    explanation:
        "La condition est l'exécution d'un crime ou d'un délit contre un bien, ce qui inclut l'exécution d'un vol en cours.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Cas présumés - 1er cas",
    question:
        "Une personne repousse à coups de bâton, de nuit, l'entrée par effraction d'un inconnu dans son appartement occupé. Ce cas entre-t-il dans la présomption de légitime défense de l'article 122-6 ?",
    options: [
      "Oui, tous les éléments du premier cas présumé sont réunis",
      "Non, car l'appartement n'est pas un lieu habité",
      "Non, car la personne n'a pas appelé la police",
    ],
    answer: "Oui, tous les éléments du premier cas présumé sont réunis",
    explanation:
        "De nuit, entrée par effraction, dans un lieu habité, pour repousser l'entrée : la présomption de l'article 122-6 joue.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Cas présumés - 1er cas",
    question:
        "Le premier cas présumé de légitime défense (repousser de nuit l'entrée par effraction dans un lieu habité) s'applique-t-il à un garage désaffecté non habité ?",
    options: [
      "Oui, car c'est un local privé",
      "Non, car ce n'est pas un lieu habité",
      "Oui, s'il y a effraction",
    ],
    answer: "Non, car ce n'est pas un lieu habité",
    explanation:
        "Le texte vise explicitement « un lieu habité : maison ou appartement habités ».",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Cas présumés - 1er cas",
    question:
        "Un occupant repousse de jour l'entrée par ruse dans son appartement habité. La présomption de légitime défense de l'article 122-6 s'applique-t-elle ?",
    options: [
      "Oui, car il y a ruse",
      "Non, car la présomption exige une entrée de nuit",
      "Oui, car c'est un lieu habité même de jour",
    ],
    answer: "Non, car la présomption exige une entrée de nuit",
    explanation:
        "Le premier cas présumé exige expressément que l'entrée soit repoussée « DE NUIT ».",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Cas présumés - 2e cas",
    question:
        "Une personne se défend de jour contre des auteurs de vol avec violence dans la rue. Peut-elle bénéficier du deuxième cas présumé de légitime défense ?",
    options: [
      "Oui, car il s'agit de vols exécutés avec violence",
      "Non, car la rue n'est pas un lieu habité",
      "Non, car c'est de jour",
    ],
    answer: "Oui, car il s'agit de vols exécutés avec violence",
    explanation:
        "Le deuxième cas présumé concerne la défense « de jour comme de nuit » contre les auteurs de vols ou pillages exécutés avec violence.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Cas présumés - 2e cas",
    question:
        "Une personne se défend contre des voleurs qui tentent de la dépouiller sans violence (vol à la tire discret). La présomption de l'article 122-6 s'applique-t-elle ?",
    options: [
      "Oui, dès qu'il y a vol",
      "Non, car les vols doivent être exécutés avec violence",
      "Oui, seulement si c'est de nuit",
    ],
    answer: "Non, car les vols doivent être exécutés avec violence",
    explanation:
        "Le texte mentionne des « VOLS ou PILLAGES exécutés avec violence » ; l'absence de violence exclut la présomption.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Cas présumés - Preuve contraire",
    question:
        "Dans un cas présumé de légitime défense, il apparaît que la personne a poursuivi l'agresseur en fuite et l'a frappé à terre. Que peut faire le juge ?",
    options: [
      "Il est lié par la présomption et doit relaxer",
      "Il peut écarter la présomption en raison de la preuve contraire",
      "Il doit appliquer automatiquement une atténuation de peine",
    ],
    answer: "Il peut écarter la présomption en raison de la preuve contraire",
    explanation:
        "La présomption est simple et « peut céder devant la preuve contraire ».",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Comparaison personnes/biens",
    question:
        "Quelle différence majeure existe entre la légitime défense des personnes et celle des biens ?",
    options: [
      "Seules les personnes exigent la proportionnalité",
      "La défense des biens exclut l'homicide volontaire alors que la défense des personnes peut aller jusqu'à la mort de l'agresseur si les conditions sont remplies",
      "La défense des biens ne nécessite pas d'infraction",
    ],
    answer:
        "La défense des biens exclut l'homicide volontaire alors que la défense des personnes peut aller jusqu'à la mort de l'agresseur si les conditions sont remplies",
    explanation:
        "L'article 122-5 al. 2 vise expressément un acte de défense « autre qu'un homicide volontaire » pour les biens.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Généralités - Personnes",
    question:
        "Dans la formule générale de l'article 122-5, la légitime défense des personnes exige que l'acte soit commandé par :",
    options: [
      "La colère de la victime",
      "La nécessité de la légitime défense d'elle-même ou d'autrui",
      "Le souci de donner l'exemple",
    ],
    answer: "La nécessité de la légitime défense d'elle-même ou d'autrui",
    explanation:
        "Le texte parle d'un acte « commandé par la nécessité de la légitime défense d'elle-même ou d'autrui ».",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Personnes - Autrui",
    question:
        "Un passant intervient pour protéger une victime inconnue violemment agressée dans le métro. Peut-il, en principe, invoquer la légitime défense des personnes ?",
    options: [
      "Oui, car la défense d'autrui est prévue",
      "Non, seulement la défense de soi-même est prévue",
      "Non, sauf s'il connaît la victime",
    ],
    answer: "Oui, car la défense d'autrui est prévue",
    explanation:
        "L'article 122-5 vise la légitime défense d'elle-même ou d'autrui.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Biens - Strictement nécessaire",
    question:
        "Un commerçant enferme un voleur dans une réserve, l'attache et le frappe pendant une heure. L'exigence d'acte « strictement nécessaire au but poursuivi » est-elle respectée ?",
    options: [
      "Oui, car il a protégé son bien",
      "Non, la séquestration et les coups excèdent le but d'interrompre l'infraction",
      "Oui, car le voleur a commis un délit",
    ],
    answer:
        "Non, la séquestration et les coups excèdent le but d'interrompre l'infraction",
    explanation:
        "L'acte doit être strictement nécessaire au but d'interrompre l'exécution du crime ou du délit, ce qui n'est plus le cas ici.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Biens - Crime ou délit",
    question:
        "La dégradation légère d'un bien constituant une contravention (et non un délit) permet-elle de se prévaloir de la légitime défense des biens de l'article 122-5 al. 2 ?",
    options: [
      "Oui, car il y a atteinte au bien",
      "Non, la loi exige l'exécution d'un crime ou d'un délit",
      "Oui, seulement si c'est de nuit",
    ],
    answer: "Non, la loi exige l'exécution d'un crime ou d'un délit",
    explanation:
        "Le texte vise « un crime ou un délit contre un bien » ; les simples contraventions sont en principe exclues.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Personnes - Simultanéité",
    question:
        "Lors d'une agression, une personne reçoit un coup de poing puis, dans le même mouvement, repousse violemment l'agresseur qui chute. La condition de simultanéité est-elle a priori remplie ?",
    options: [
      "Oui, car la défense est immédiate par rapport à l'atteinte",
      "Non, car elle aurait dû attendre un second coup",
      "Non, car elle n'a pas fui",
    ],
    answer: "Oui, car la défense est immédiate par rapport à l'atteinte",
    explanation:
        "La défense est intervenue dans le même temps que l'agression, ce qui répond à l'exigence de simultanéité.",
    difficulty: "Moyenne",
  ),

  // ===================== DIFFICILE (≈30) =====================
  QuizQuestion(
    category: "Personnes - Analyse fine",
    question:
        "Une personne insultée gravement (mais sans geste physique) frappe immédiatement l'auteur des insultes. Quel élément de la légitime défense des personnes fait défaut le plus clairement ?",
    options: [
      "L'atteinte injustifiée",
      "L'atteinte actuelle et réelle (atteinte à l'intégrité physique)",
      "La simultanéité",
    ],
    answer: "L'atteinte actuelle et réelle (atteinte à l'intégrité physique)",
    explanation:
        "La légitime défense des personnes vise une atteinte injustifiée à la personne, généralement corporelle ou du moins sérieuse ; de simples injures ne caractérisent pas toujours une atteinte justifiant une riposte violente.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Personnes - Analyse fine",
    question:
        "Une personne menacée au couteau par un agresseur peut, pour se défendre, saisir un objet contondant et blesser gravement l'agresseur. En cas de poursuites, l'analyse de la proportionnalité se fera en comparant :",
    options: [
      "La peur ressentie par la victime et la peine encourue par l'agresseur",
      "Les moyens de défense employés et la gravité de l'atteinte (couteau)",
      "La personnalité de la victime et celle de l'agresseur",
    ],
    answer:
        "Les moyens de défense employés et la gravité de l'atteinte (couteau)",
    explanation:
        "La proportionnalité se mesure entre gravité de l'attaque (arme blanche) et moyens de défense choisis.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Personnes - Cas limite",
    question:
        "Un agent de sécurité repousse un individu qui tente de le frapper avec un poing, en utilisant une clé d'étranglement prolongée, causant un grave dommage. Quel critère risque-t-il d'être jugé non respecté ?",
    options: [
      "La simultanéité",
      "La nécessité et la proportionnalité de la défense",
      "L'injustice de l'atteinte",
    ],
    answer: "La nécessité et la proportionnalité de la défense",
    explanation:
        "Le maintien prolongé d'une clé d'étranglement peut être jugé excessif au regard d'un simple coup de poing.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Biens - Cas pratique",
    question:
        "Un propriétaire déclenche manuellement, au moment où il aperçoit un voleur pénétrer dans son entrepôt pour voler du matériel, un dispositif automatique qui enferme le voleur dans une cage métallique sans lui causer de blessure. Au regard de l'article 122-5 al. 2, cette riposte :",
    options: [
      "Pourrait être considérée comme strictement nécessaire et proportionnée",
      "Est exclue car il n'y a pas de violence physique",
      "Est toujours illégale",
    ],
    answer:
        "Pourrait être considérée comme strictement nécessaire et proportionnée",
    explanation:
        "Le dispositif vise à interrompre le délit sans porter d'atteinte corporelle grave, ce qui peut répondre aux exigences de nécessité et proportionnalité.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Biens - Homicide et personnes",
    question:
        "Un individu vole un sac à main en tirant violemment sur la victime, qui chute. Le compagnon de la victime tire immédiatement, à balle réelle, sur le voleur et le tue. Sur le terrain de la légitime défense DES PERSONNES, l'homicide pourrait-il être examiné ?",
    options: [
      "Oui, car il s'agit de défendre la victime contre une agression violente en cours",
      "Non, car l'homicide est toujours exclu en légitime défense",
      "Non, car seule la défense des biens est possible",
    ],
    answer:
        "Oui, car il s'agit de défendre la victime contre une agression violente en cours",
    explanation:
        "La défense porte ici sur la personne agressée (violence au moment du vol) ; la légitime défense des PERSONNES peut théoriquement aller jusqu'à l'homicide si les autres conditions sont réunies.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Cas présumés - Interprétation",
    question:
        "Dans le premier cas présumé (entrée de nuit par effraction dans un lieu habité), la personne qui frappe l'intrus à l'extérieur de l'immeuble, alors que celui-ci rebrousse chemin avant l'entrée, peut-elle bénéficier automatiquement de la présomption ?",
    options: [
      "Oui, car l'intention d'entrer suffit",
      "Non, car l'acte ne vise plus à repousser l'entrée dans le lieu habité",
      "Oui, dès que c'est de nuit",
    ],
    answer:
        "Non, car l'acte ne vise plus à repousser l'entrée dans le lieu habité",
    explanation:
        "La présomption suppose que l'acte soit accompli pour « repousser l'entrée » ; une poursuite à l'extérieur peut apparaître détachée de ce but.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Cas présumés - Interprétation",
    question:
        "Un occupant blesse gravement un individu qui, de nuit, force la porte de son appartement habité à coups de pied (violence) et réussit à pénétrer. L'occupant le frappe alors. La présomption de l'article 122-6 :",
    options: [
      "Ne s'applique jamais une fois l'intrus entré",
      "Peut encore s'appliquer car l'acte vise à repousser l'entrée ou l'intrusion en cours",
      "Ne concerne que les tentatives d'entrée avortées",
    ],
    answer:
        "Peut encore s'appliquer car l'acte vise à repousser l'entrée ou l'intrusion en cours",
    explanation:
        "La jurisprudence admet que la défense pendant la pénétration peut encore être rattachée au fait de repousser l'entrée.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Cas présumés - Vols violents",
    question:
        "Une victime se défend de jour contre les auteurs d'un pillage commis sans violence sur les personnes (uniquement dégradations de biens). Peut-elle bénéficier du deuxième cas présumé ?",
    options: [
      "Oui, car le texte parle de pillage",
      "Non, car les vols ou pillages doivent être exécutés avec violence (coups, tortures, etc.)",
      "Oui, dès qu'il y a plusieurs auteurs",
    ],
    answer:
        "Non, car les vols ou pillages doivent être exécutés avec violence (coups, tortures, etc.)",
    explanation:
        "Le texte souligne expressément l'exécution « avec violence ».",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Personnes/Biens - Qualification",
    question:
        "Un individu tente d'incendier un immeuble habité de nuit. Un occupant sort et lui inflige des blessures pour l'empêcher de poursuivre. Juridiquement, la défense peut être analysée prioritairement comme :",
    options: [
      "Une légitime défense des biens uniquement",
      "Une légitime défense des personnes (occupants menacés) ET des biens",
      "Un cas présumé de l'article 122-6",
    ],
    answer:
        "Une légitime défense des personnes (occupants menacés) ET des biens",
    explanation:
        "L'incendie met en danger les personnes et les biens ; la défense des personnes (plus favorable) sera souvent mobilisée.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Biens - Charge probatoire",
    question:
        "Dans une affaire de défense de biens, le prévenu affirme avoir seulement poussé un voleur pour l'arrêter, tandis que les blessures constatées laissent penser à des coups répétés. Concernant la proportionnalité, le document rappelle que :",
    options: [
      "Le doute profite toujours au prévenu sans aucune analyse",
      "La preuve du respect de la proportionnalité pèse sur la personne poursuivie",
      "Le ministère public doit prouver l'absence totale de proportionnalité",
    ],
    answer:
        "La preuve du respect de la proportionnalité pèse sur la personne poursuivie",
    explanation:
        "L'article précise que « la personne poursuivie » doit démontrer que le principe de proportionnalité a été respecté.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Personnes - Nécessité",
    question:
        "Un policier en civil est frappé par un individu. Il se trouve à proximité immédiate de collègues en uniforme vers lesquels il pourrait se réfugier sans danger. Il choisit malgré tout une riposte très violente. Quel critère de la légitime défense peut être contesté ?",
    options: [
      "L'atteinte injustifiée",
      "La nécessité (absence d'autre moyen pour se soustraire au danger)",
      "La simultanéité",
    ],
    answer: "La nécessité (absence d'autre moyen pour se soustraire au danger)",
    explanation:
        "La possibilité de se soustraire au danger en rejoignant les collègues peut conduire à considérer que la riposte n'était pas strictement nécessaire.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Personnes - Peur vs réalité",
    question:
        "Une personne souffrant de paranoïa croit que son voisin veut la tuer. Sans geste hostile de ce voisin, elle l'attaque par \"prévention\". Selon le document, la légitime défense :",
    options: [
      "Est exclue, la simple crainte subjective étant insuffisante",
      "Est admise, car la peur est sincère",
      "Est acquise dès qu'il existe un conflit",
    ],
    answer: "Est exclue, la simple crainte subjective étant insuffisante",
    explanation:
        "Le texte insiste sur le caractère RÉEL de l'atteinte et précise qu'une crainte subjective ne suffit pas.",
    difficulty: "Difficile",
  ),

  // ===================== EXPERT (≈30) =====================
  QuizQuestion(
    category: "Expert - Articulation 122-5 / 122-6",
    question:
        "Lorsque la présomption de légitime défense de l'article 122-6 est écartée par la preuve contraire, le juge :",
    options: [
      "Ne peut plus examiner la légitime défense au regard de l'article 122-5",
      "Peut encore contrôler si les conditions de la légitime défense de droit commun (art. 122-5) sont réunies",
      "Doit automatiquement condamner le prévenu",
    ],
    answer:
        "Peut encore contrôler si les conditions de la légitime défense de droit commun (art. 122-5) sont réunies",
    explanation:
        "L'échec de la présomption n'exclut pas l'examen de la légitime défense classique.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "Expert - Qualification mixte",
    question:
        "Lorsqu'une personne repousse, de nuit, l'entrée par effraction d'un cambrioleur dans sa maison, en lui tirant mortellement dessus, l'analyse juridique la plus complète consiste à :",
    options: [
      "Écarter d'emblée la légitime défense car il y a homicide",
      "Examiner d'abord la présomption de l'article 122-6, puis la légitime défense des personnes (art. 122-5) pour apprécier nécessité et proportionnalité",
      "Appliquer automatiquement une excuse atténuante",
    ],
    answer:
        "Examiner d'abord la présomption de l'article 122-6, puis la légitime défense des personnes (art. 122-5) pour apprécier nécessité et proportionnalité",
    explanation:
        "L'homicide interdit la légitime défense DES BIENS mais la défense DES PERSONNES reste envisageable, sous contrôle strict de proportionnalité.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "Expert - Biens et personnes",
    question:
        "Dans un vol avec violence, la victime protège à la fois son intégrité physique et son sac à main. La légitime défense sera en priorité fondée sur :",
    options: [
      "La défense des biens (art. 122-5 al. 2)",
      "La défense des personnes (art. 122-5 al. 1)",
      "Uniquement les cas présumés de l'article 122-6",
    ],
    answer: "La défense des personnes (art. 122-5 al. 1)",
    explanation:
        "En pratique, lorsqu'une atteinte aux personnes existe, le régime plus large de la défense des personnes est privilégié.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "Expert - Crime contre un bien",
    question:
        "Un individu tente de commettre un crime d'incendie volontaire contre un entrepôt vide. Le propriétaire intervient et blesse légèrement l'auteur avec une arme non létale. Sur le terrain de la légitime défense des biens, le juge devra principalement vérifier :",
    options: [
      "Que l'acte de défense était autre qu'un homicide volontaire, strictement nécessaire et proportionné à la gravité de l'infraction (crime d'incendie)",
      "Uniquement que l'entrepôt ait une grande valeur",
      "Uniquement que le propriétaire ait porté plainte auparavant",
    ],
    answer:
        "Que l'acte de défense était autre qu'un homicide volontaire, strictement nécessaire et proportionné à la gravité de l'infraction (crime d'incendie)",
    explanation:
        "Ce sont les trois axes d'analyse prévus à l'article 122-5 al. 2.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "Expert - Intrusion nocturne",
    question:
        "Une personne installe un piège automatique létal dans son couloir (fusil relié à la porte) pour se protéger des intrusions nocturnes. Aucune présence humaine n'est requise au déclenchement. En cas de décès d'un cambrioleur, la qualification de légitime défense :",
    options: [
      "Est exclue car la défense n'est pas exécutée dans le même temps par la personne (absence d'acte commandé par la nécessité immédiate)",
      "Est acquise d'office en raison de la présomption de l'article 122-6",
      "Est automatique puisque le vol est nocturne",
    ],
    answer:
        "Est exclue car la défense n'est pas exécutée dans le même temps par la personne (absence d'acte commandé par la nécessité immédiate)",
    explanation:
        "La légitime défense suppose un acte humain accompli dans le même temps en réaction à l'atteinte ; un piège automatique préprogrammé ne répond pas à cette exigence.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "Expert - Appréciation in concreto",
    question:
        "Dans l'appréciation de la proportionnalité en légitime défense, la jurisprudence tient compte :",
    options: [
      "Uniquement de la valeur du bien protégé",
      "Des circonstances concrètes de l'agression (heure, lieu, nombre d'agresseurs, moyens employés, vulnérabilité de la victime)",
      "Uniquement du casier judiciaire de l'agresseur",
    ],
    answer:
        "Des circonstances concrètes de l'agression (heure, lieu, nombre d'agresseurs, moyens employés, vulnérabilité de la victime)",
    explanation:
        "La proportionnalité est appréciée in concreto, au regard de l'ensemble de la situation au moment des faits.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "Expert - Poursuite de l'agresseur",
    question:
        "Une victime parvient à faire fuir son agresseur. Dix minutes plus tard, elle le retrouve à distance, sans danger immédiat, et le frappe. Sur le terrain de la légitime défense :",
    options: [
      "La simultanéité fait défaut, l'acte s'analysant comme une vengeance",
      "La nécessité est renforcée",
      "La présomption de l'article 122-6 s'applique",
    ],
    answer:
        "La simultanéité fait défaut, l'acte s'analysant comme une vengeance",
    explanation:
        "La défense ne peut être une « réaction tardive à une atteinte déjà passée (vengeance) ».",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "Expert - Défense d'autrui",
    question:
        "Un individu neutralise violemment un agresseur qui tente d'étrangler une victime. Il est poursuivi pour violences aggravées. Pour caractériser la légitime défense d'autrui, le juge devra examiner notamment :",
    options: [
      "Si l'atteinte à autrui était injustifiée, actuelle et réelle, et si la riposte était nécessaire, simultanée et proportionnée",
      "Uniquement la réalité de la strangulation",
      "Uniquement l'absence de fuite possible de la victime",
    ],
    answer:
        "Si l'atteinte à autrui était injustifiée, actuelle et réelle, et si la riposte était nécessaire, simultanée et proportionnée",
    explanation:
        "Les mêmes critères que pour la défense de soi s'appliquent à la défense d'autrui.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "Expert - Chevauchement biens/personnes",
    question:
        "Lorsqu'un cambrioleur pénètre de nuit dans un appartement occupé, armé d'un couteau, la défense de l'occupant sera juridiquement fondée :",
    options: [
      "Uniquement sur la défense des biens",
      "Uniquement sur la présomption de l'article 122-6",
      "À la fois sur la présomption de l'article 122-6 et sur la défense des personnes, compte tenu du danger pour les occupants",
    ],
    answer:
        "À la fois sur la présomption de l'article 122-6 et sur la défense des personnes, compte tenu du danger pour les occupants",
    explanation:
        "Le danger vise aussi la vie des personnes ; le juge combinera souvent ces deux approches.",
    difficulty: "Expert",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizLegitimeDefensePage extends StatefulWidget {
  static const String routeName = '/gpx/generalites/quiz/legitimedefense';
  final String uid;
  final String email;

  const QuizLegitimeDefensePage({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizLegitimeDefensePage> createState() =>
      _QuizLegitimeDefensePageState();
}

class _QuizLegitimeDefensePageState extends State<QuizLegitimeDefensePage>
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
    duration: const Duration(milliseconds: 700), // tu peux ajuster
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
    // (chemins relatifs au dossier déclaré dans pubspec: assets/sfx/)
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
  void _seedAndShuffle() {
    final useAll = _mixMode || _selectedDifficulty == null;
    final pool = useAll
        ? questionsLegitimeDefense
        : questionsLegitimeDefense
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
            'module_name': 'Généralités',
            'quiz_name': 'La Legitime Défense',
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
      final int total = _qs.length.clamp(1, 1 << 30);
      final int percent = ((_score / total) * 100).round();

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

  Future<void> _saveAnswer({
    required String question,
    required String userAnswer,
    required String correctAnswer,
    required bool isCorrect,
    required String difficulty,
  }) async {
    try {
      await _sb.from('quiz_legitimedefense').insert({
        'user_uid': widget.uid,
        'email': widget.email,
        'question': question,
        'user_answer': userAnswer,
        'correct_answer': correctAnswer,
        'is_correct': isCorrect,
        'score': _score, // score cumulé au moment T
        'difficulty': difficulty,
      });
    } catch (e) {
      debugPrint('❌ quiz_legitimedefense insert failed: $e');
    }
  }

  // ==========================================================================
  // AUDIO UTIL
  // ==========================================================================
  Future<void> _playAnswerSfx(bool good) async {
    try {
      // petite vibration sympa
      HapticFeedback.mediumImpact();

      final AudioPlayer p = good ? _goodSfx : _badSfx;
      // on s’assure de repartir du début
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

    // Lance l'animation
    _pulseCtrl
      ..reset()
      ..forward();

    // 🔊 Lecture du son en même temps que l’animation
    unawaited(_playAnswerSfx(ok));

    // Sauvegarde asynchrone
    // Sauvegarde asynchrone
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
  // UI (réécrit)
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

        // hauteur “structurelle” du bas (bouton + marges)
        const double kButtonHeight = 56;
        const double kButtonVPad = 16; // safe area min bottom padding = 16
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
                    // Taille cible de l’animation (en fonction de la largeur)
                    final double animSize = (viewport.maxWidth * 0.56).clamp(
                      140.0,
                      240.0,
                    );

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // =======================
                        // COLONNE CONTENU (scroll)
                        // =======================
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

                                  // >>> padding bas à appliquer à la page courante :
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
                            // Barre de boutons
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

                        // =======================
                        // OVERLAY ANIMATION GLOBAL
                        // =======================
                        if (_validated)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: bottomBarReserved, // au-dessus du bouton
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

                        // =======================
                        // SPLASH DIFFICULTÉ
                        // =======================
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
      // On garde un léger assombrissement, le flou sera appliqué par-dessus.
      barrierColor: Colors.black.withOpacity(0.25),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, __, ___) {
        return Stack(
          children: [
            // ⬇️ Flou gaussien PLEIN ÉCRAN sur l’arrière-plan
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: const SizedBox.expand(),
              ),
            ),
            // ⬇️ La carte de résultat au centre
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
          message: 'Tu maîtrises la légitime défense 💪',
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
