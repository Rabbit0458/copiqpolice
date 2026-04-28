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
final List<QuizQuestion> questionsLibertesPubliquesIntro = [
  // ===================== NIVEAU FACILE =====================
  QuizQuestion(
    category: "D.D.H.C. — Généralités",
    question:
        "La Déclaration des droits de l’homme et du citoyen (D.D.H.C.) a été adoptée le :",
    options: ["14 juillet 1789", "26 août 1789", "4 octobre 1958"],
    answer: "26 août 1789",
    explanation:
        "Le texte rappelle que la D.D.H.C. a été adoptée le 26 août 1789, en pleine Révolution française.",
    difficulty: "Facile",
  ),
  // ===================== RÉGIME JURIDIQUE — NIVEAU FACILE =====================
  QuizQuestion(
    category: "Régime juridique — Généralités",
    question:
        "Selon le cours, pourquoi ne peut-il pas exister de liberté publique absolue ?",
    options: [
      "Parce que l’État doit toujours tout contrôler",
      "Parce que sans règles, la liberté se transforme en anarchie",
      "Parce que les citoyens refusent la liberté",
    ],
    answer: "Parce que sans règles, la liberté se transforme en anarchie",
    explanation:
        "Le texte précise qu’en l’absence de règles, la liberté se transforme en anarchie, ce qui justifie l’encadrement juridique des libertés publiques.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Régime juridique — Généralités",
    question:
        "L’idée directrice du régime juridique des libertés publiques est que :",
    options: [
      "La restriction est la règle et la liberté l’exception",
      "Réglementer une liberté publique ne signifie pas la supprimer",
      "Toute liberté doit être supprimée pour préserver l’ordre public",
    ],
    answer: "Réglementer une liberté publique ne signifie pas la supprimer",
    explanation:
        "La fiche insiste sur le fait que la réglementation fixe des bornes, mais maintient la liberté comme principe et la restriction comme exception.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Régime juridique — Autorités",
    question:
        "Quels sont les deux grands acteurs qui encadrent les libertés publiques ?",
    options: [
      "Le législateur et le pouvoir exécutif",
      "Le juge judiciaire et les particuliers",
      "Les partis politiques et les syndicats",
    ],
    answer: "Le législateur et le pouvoir exécutif",
    explanation:
        "Le cours indique que le législateur (loi) et le pouvoir exécutif (pouvoir réglementaire) sont les deux grands acteurs qui réglementent les libertés.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Régime juridique — Législateur",
    question:
        "La Constitution de 1958 confie au Parlement la détermination des règles concernant :",
    options: [
      "Uniquement le budget de l’État",
      "Les droits civiques et les garanties fondamentales accordées aux citoyens pour leur exercice",
      "La seule organisation des collectivités territoriales",
    ],
    answer:
        "Les droits civiques et les garanties fondamentales accordées aux citoyens pour leur exercice",
    explanation:
        "L’article 34 de la Constitution de 1958 donne compétence au législateur pour fixer les règles relatives aux droits civiques et à leurs garanties.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Régime juridique — Législateur",
    question:
        "En matière de libertés publiques, le législateur dispose d’une :",
    options: [
      "Compétence de principe",
      "Compétence purement accessoire",
      "Compétence inexistante",
    ],
    answer: "Compétence de principe",
    explanation:
        "La fiche précise que le législateur a une compétence de principe pour fixer le régime des libertés publiques.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Régime juridique — Législateur",
    question:
        "Le législateur peut, en matière de libertés publiques, notamment :",
    options: [
      "Créer de nouvelles libertés et définir leurs modalités d’exercice",
      "Modifier directement la Constitution par simple loi",
      "Supprimer n’importe quelle liberté sans contrôle",
    ],
    answer: "Créer de nouvelles libertés et définir leurs modalités d’exercice",
    explanation:
        "Le cours explique que la loi peut créer de nouvelles libertés, en préciser les modalités et, parfois, en restreindre l’exercice.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Régime juridique — Pouvoir réglementaire",
    question: "Le pouvoir réglementaire appartient principalement :",
    options: [
      "Au Gouvernement et aux autorités administratives (préfet, maire…)",
      "Aux juges constitutionnels",
      "Aux organisations non gouvernementales",
    ],
    answer: "Au Gouvernement et aux autorités administratives (préfet, maire…)",
    explanation:
        "Le texte souligne que le pouvoir exécutif (gouvernement, préfet, maire) met en œuvre les libertés par des règlements.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Régime juridique — Pouvoir réglementaire",
    question: "Le pouvoir réglementaire complète principalement :",
    options: [
      "Les lois, en précisant les conditions d’exercice des libertés",
      "Les décisions de l’ONU uniquement",
      "Les coutumes locales sans base légale",
    ],
    answer: "Les lois, en précisant les conditions d’exercice des libertés",
    explanation:
        "Le cours indique que le règlement vient détailler et compléter la loi, par exemple via la partie réglementaire des codes.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Régime juridique — Période normale",
    question: "En période normale, l’autorité administrative ne peut pas :",
    options: [
      "Limiter une liberté dans le temps et l’espace",
      "Interdire de manière générale et absolue l’exercice d’une liberté",
      "Prendre des mesures proportionnées à un risque précis",
    ],
    answer: "Interdire de manière générale et absolue l’exercice d’une liberté",
    explanation:
        "Le cours rappelle qu’aucune interdiction générale et absolue n’est possible en matière de liberté publique en période ordinaire.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Régime juridique — Période normale",
    question:
        "Toute mesure d’interdiction d’une liberté en période normale doit être :",
    options: [
      "Purement symbolique",
      "Indispensable au maintien de l’ordre public",
      "Décidée par référendum",
    ],
    answer: "Indispensable au maintien de l’ordre public",
    explanation:
        "Le texte précise que l’interdiction doit être indispensable au maintien de l’ordre public et motivée par des circonstances précises.",
    difficulty: "Facile",
  ),

  // ===================== RÉGIME JURIDIQUE — NIVEAU MOYEN =====================
  QuizQuestion(
    category: "Régime juridique — Législateur",
    question:
        "Parmi les propositions suivantes, laquelle illustre une création de liberté par la loi ?",
    options: [
      "La loi du 17 juillet 1970 renforçant le droit au respect de la vie privée",
      "Un simple arrêté municipal limitant la circulation",
      "Une circulaire de service interne à un commissariat",
    ],
    answer:
        "La loi du 17 juillet 1970 renforçant le droit au respect de la vie privée",
    explanation:
        "La loi de 1970 est citée comme exemple de texte législatif créant ou renforçant une liberté fondamentale, ici la vie privée.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Régime juridique — Législateur",
    question:
        "Le législateur peut revenir sur une liberté publique déjà acquise :",
    options: [
      "Sans aucune limite",
      "Uniquement si cette liberté n’a jamais été légalement consacrée ou pour atteindre un objectif de valeur constitutionnelle",
      "Seulement avec l’accord des maires",
    ],
    answer:
        "Uniquement si cette liberté n’a jamais été légalement consacrée ou pour atteindre un objectif de valeur constitutionnelle",
    explanation:
        "Le cours indique que la remise en cause d’une liberté n’est possible que si elle n’était pas juridiquement acquise ou pour un motif de valeur constitutionnelle.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Régime juridique — Pouvoir réglementaire",
    question:
        "Le pouvoir réglementaire peut restreindre l’exercice d’une liberté à condition de respecter :",
    options: [
      "Les principes de légalité, de nécessité et de proportionnalité",
      "Uniquement la volonté du maire",
      "Exclusivement l’intérêt économique de la commune",
    ],
    answer: "Les principes de légalité, de nécessité et de proportionnalité",
    explanation:
        "La fiche insiste sur ces trois principes pour encadrer les restrictions réglementaires aux libertés.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Régime juridique — Période normale",
    question:
        "Pourquoi le juge contrôle-t-il plus strictement les mesures de police qui touchent une liberté fondamentale ?",
    options: [
      "Parce que la liberté fondamentale est toujours illégale",
      "Parce que ces libertés (aller et venir, réunion, expression…) bénéficient d’une protection renforcée",
      "Parce qu’il ne peut jamais annuler de mesure de police",
    ],
    answer:
        "Parce que ces libertés (aller et venir, réunion, expression…) bénéficient d’une protection renforcée",
    explanation:
        "Le texte explique que plus la liberté est fondamentale, plus le contrôle de proportionnalité du juge administratif est rigoureux.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Régime juridique — États d’exception",
    question: "L’état de siège est principalement destiné à faire face :",
    options: [
      "À une simple manifestation locale",
      "À une guerre étrangère ou une insurrection armée",
      "À un conflit familial",
    ],
    answer: "À une guerre étrangère ou une insurrection armée",
    explanation:
        "Le cours définit l’état de siège comme un régime destiné au péril résultant d’une guerre ou d’une insurrection armée.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Régime juridique — États d’exception",
    question:
        "Pendant l’état de siège, certaines compétences de police sont transférées :",
    options: [
      "Au Conseil constitutionnel",
      "À l’autorité militaire",
      "Aux maires seulement",
    ],
    answer: "À l’autorité militaire",
    explanation:
        "La fiche précise que l’état de siège entraîne le transfert de certains pouvoirs de police à l’autorité militaire.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Régime juridique — Article 16",
    question:
        "Les pouvoirs exceptionnels de l’article 16 de la Constitution peuvent être mis en œuvre lorsque :",
    options: [
      "Les institutions de la République sont gravement menacées et le fonctionnement régulier des pouvoirs publics est interrompu",
      "Le Parlement est simplement en vacances",
      "Une commune connaît une petite hausse de la délinquance",
    ],
    answer:
        "Les institutions de la République sont gravement menacées et le fonctionnement régulier des pouvoirs publics est interrompu",
    explanation:
        "L’article 16 vise une situation de crise extrême combinant menace grave et interruption du fonctionnement régulier des pouvoirs publics.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Régime juridique — Article 16",
    question:
        "Avant de recourir à l’article 16, le Président de la République doit :",
    options: [
      "Organiser un référendum local",
      "Consulter plusieurs autorités (Premier ministre, présidents des Assemblées, Conseil constitutionnel)",
      "Obtenir l’accord du maire de Paris",
    ],
    answer:
        "Consulter plusieurs autorités (Premier ministre, présidents des Assemblées, Conseil constitutionnel)",
    explanation:
        "La fiche rappelle cette consultation préalable avant la mise en œuvre des pouvoirs exceptionnels de l’article 16.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Régime juridique — État d’urgence",
    question: "L’état d’urgence (loi de 1955) est principalement destiné à :",
    options: [
      "Gérer les élections municipales",
      "Faire face à un péril imminent résultant d’atteintes graves à l’ordre public ou de calamités publiques",
      "Limiter les dépenses publiques",
    ],
    answer:
        "Faire face à un péril imminent résultant d’atteintes graves à l’ordre public ou de calamités publiques",
    explanation:
        "Le cours définit l’état d’urgence comme un régime permettant de répondre à un péril imminent, notamment en matière de sécurité.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Régime juridique — État d’urgence",
    question:
        "Parmi les mesures possibles sous état d’urgence, on trouve notamment :",
    options: [
      "L’assignation à résidence et les perquisitions administratives",
      "La dissolution automatique du Parlement",
      "La suppression de tous les recours juridictionnels",
    ],
    answer: "L’assignation à résidence et les perquisitions administratives",
    explanation:
        "La fiche mentionne l’assignation à résidence, les perquisitions administratives et les interdictions de réunions comme exemples de mesures d’état d’urgence.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Régime juridique — État d’urgence sanitaire",
    question: "L’état d’urgence sanitaire a été instauré principalement pour :",
    options: [
      "Lutter contre une catastrophe sanitaire comme la pandémie de Covid-19",
      "Régler un conflit du travail dans la fonction publique",
      "Organiser les élections présidentielles",
    ],
    answer:
        "Lutter contre une catastrophe sanitaire comme la pandémie de Covid-19",
    explanation:
        "Le texte précise que l’état d’urgence sanitaire a été créé pour faire face à un risque sanitaire majeur, notamment la Covid-19.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Régime juridique — Circumstances exceptionnelles",
    question:
        "La théorie des circonstances exceptionnelles permet au juge administratif :",
    options: [
      "De refuser tout contrôle en cas de crise",
      "D’admettre que l’administration dispose provisoirement de pouvoirs plus étendus en cas de guerre ou de trouble grave",
      "De légiférer à la place du Parlement",
    ],
    answer:
        "D’admettre que l’administration dispose provisoirement de pouvoirs plus étendus en cas de guerre ou de trouble grave",
    explanation:
        "La théorie permet au juge de tenir compte des circonstances anormales pour apprécier la légalité de mesures plus restrictives.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Régime juridique — Vigipirate",
    question: "Le plan Vigipirate est principalement :",
    options: [
      "Un véritable état d’exception prévu par la Constitution",
      "Un dispositif gouvernemental permanent de lutte contre la menace terroriste",
      "Un simple document interne à la Police nationale",
    ],
    answer:
        "Un dispositif gouvernemental permanent de lutte contre la menace terroriste",
    explanation:
        "La fiche décrit Vigipirate comme un dispositif permanent associant autorités civiles et militaires pour prévenir la menace terroriste.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Régime juridique — Vigipirate",
    question: "Quel niveau Vigipirate correspond à la menace la plus élevée ?",
    options: [
      "Niveau « vigilance »",
      "Niveau « sécurité renforcée – risque attentat »",
      "Niveau « urgence attentat »",
    ],
    answer: "Niveau « urgence attentat »",
    explanation:
        "Le cours indique que le niveau « urgence attentat » est déclenché après un attentat ou en cas de menace imminente liée à un groupe identifié.",
    difficulty: "Moyenne",
  ),

  // ===================== RÉGIME JURIDIQUE — NIVEAU DIFFICILE =====================
  QuizQuestion(
    category: "Régime juridique — Régime répressif",
    question: "Dans le régime répressif, la liberté est :",
    options: [
      "L’exception, la censure étant la règle",
      "La règle, la sanction n’intervenant qu’en cas d’abus caractérisé",
      "Toujours soumise à autorisation préalable",
    ],
    answer: "La règle, la sanction n’intervenant qu’en cas d’abus caractérisé",
    explanation:
        "La fiche précise que le régime répressif est le plus favorable aux libertés : on agit librement, mais on est sanctionné en cas d’abus.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Régime juridique — Régime répressif",
    question:
        "Dans un régime répressif, qui prononce la sanction en cas d’abus d’une liberté ?",
    options: [
      "Le juge, à l’issue d’une procédure contradictoire",
      "Le maire, sans contrôle",
      "Le ministre de l’Intérieur par simple circulaire",
    ],
    answer: "Le juge, à l’issue d’une procédure contradictoire",
    explanation:
        "Le texte indique que l’abus est sanctionné par le juge sur le fondement des textes pénaux ou administratifs.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Régime juridique — Régime préventif",
    question: "Quelle formule résume le mieux le régime préventif ?",
    options: [
      "« Tout est interdit sauf ce qui est expressément autorisé »",
      "« Tout est autorisé sauf ce qui est expressément interdit »",
      "« Rien n’est ni autorisé ni interdit »",
    ],
    answer: "« Tout est interdit sauf ce qui est expressément autorisé »",
    explanation:
        "Le cours reprend cette formule : dans le régime préventif, n’est permis que ce qui est autorisé expressément ou tacitement.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Régime juridique — Régime préventif",
    question: "Le régime préventif repose essentiellement sur :",
    options: [
      "L’action du pouvoir exécutif responsable de l’ordre public",
      "La seule initiative des citoyens",
      "Les décisions des juridictions pénales",
    ],
    answer: "L’action du pouvoir exécutif responsable de l’ordre public",
    explanation:
        "Le texte précise que le régime préventif est mis en œuvre par l’autorité administrative chargée de l’ordre public.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Régime juridique — Autorisation préalable",
    question: "La technique de l’autorisation préalable implique que :",
    options: [
      "La liberté peut s’exercer sans formalité",
      "L’exercice de la liberté est subordonné à l’accord préalable de l’administration",
      "La liberté est définitivement supprimée",
    ],
    answer:
        "L’exercice de la liberté est subordonné à l’accord préalable de l’administration",
    explanation:
        "La fiche explique qu’en l’absence d’autorisation, la liberté ne peut être exercée légalement.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Régime juridique — Autorisation préalable",
    question:
        "Parmi les exemples suivants, lequel relève de l’autorisation préalable ?",
    options: [
      "La déclaration d’une manifestation",
      "Le permis de construire",
      "Le dépôt d’un mémoire devant le juge",
    ],
    answer: "Le permis de construire",
    explanation:
        "Le cours cite le permis de construire comme exemple d’activité soumise à autorisation préalable.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Régime juridique — Déclaration préalable",
    question: "Dans le régime de la déclaration préalable :",
    options: [
      "La liberté ne peut jamais s’exercer",
      "La liberté s’exerce, mais son titulaire doit informer préalablement l’autorité",
      "Seul le juge peut autoriser l’activité",
    ],
    answer:
        "La liberté s’exerce, mais son titulaire doit informer préalablement l’autorité",
    explanation:
        "La fiche décrit la déclaration préalable comme une information à l’administration qui peut ensuite encadrer l’activité.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Régime juridique — Déclaration préalable",
    question:
        "Parmi les exemples suivants, lequel illustre une déclaration préalable ?",
    options: [
      "Demander un permis de conduire",
      "Informer la préfecture de l’organisation d’une manifestation sur la voie publique",
      "Demander un passeport",
    ],
    answer:
        "Informer la préfecture de l’organisation d’une manifestation sur la voie publique",
    explanation:
        "Le cours cite la déclaration de manifestation comme exemple typique de déclaration préalable.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Régime juridique — Interdiction préalable",
    question: "L’interdiction préalable est :",
    options: [
      "La technique la moins attentatoire aux libertés",
      "La technique la plus attentatoire aux libertés, qui doit rester un ultime recours",
      "Une mesure toujours licite, même générale et absolue",
    ],
    answer:
        "La technique la plus attentatoire aux libertés, qui doit rester un ultime recours",
    explanation:
        "Le texte présente l’interdiction préalable comme un outil extrême, strictement encadré par le juge.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Régime juridique — Interdiction préalable",
    question: "L’arrêt Benjamin (Conseil d’État, 1933) illustre que :",
    options: [
      "L’autorité de police peut toujours interdire un événement par précaution",
      "L’interdiction d’une manifestation n’est légale que s’il n’existe pas de mesures moins restrictives suffisantes pour assurer l’ordre public",
      "Le maire décide seul sans contrôle du juge",
    ],
    answer:
        "L’interdiction d’une manifestation n’est légale que s’il n’existe pas de mesures moins restrictives suffisantes pour assurer l’ordre public",
    explanation:
        "L’arrêt Benjamin consacre l’idée que l’interdiction totale est illégale quand des moyens moins radicaux (forces de l’ordre, encadrement) suffisent.",
    difficulty: "Difficile",
  ),

  // ===================== SOURCES DES LIBERTÉS — NIVEAU FACILE =====================
  QuizQuestion(
    category: "Sources — Généralités",
    question: "Les libertés publiques actuelles en France résultent :",
    options: [
      "D’un seul texte adopté en 1958",
      "D’une construction historique longue mêlant textes philosophiques, déclarations, constitutions et conventions internationales",
      "Uniquement des coutumes locales",
    ],
    answer:
        "D’une construction historique longue mêlant textes philosophiques, déclarations, constitutions et conventions internationales",
    explanation:
        "L’introduction souligne la pluralité des sources et la longue histoire des libertés publiques.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Sources — Philosophiques",
    question:
        "La pensée chrétienne a contribué aux libertés publiques en affirmant :",
    options: [
      "La supériorité de certains peuples",
      "L’égalité fondamentale de tous les hommes et la valeur de la personne humaine",
      "La nécessité de supprimer la liberté religieuse",
    ],
    answer:
        "L’égalité fondamentale de tous les hommes et la valeur de la personne humaine",
    explanation:
        "Le cours présente la pensée chrétienne comme source de l’égalité et de la dignité humaines.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Sources — Philosophiques",
    question:
        "La théorie du droit naturel et du contrat social (Locke, Rousseau…) met en avant :",
    options: [
      "Des droits naturels, universels et inaliénables attachés à toute personne",
      "Le pouvoir absolu du souverain sans limite",
      "La supériorité de la force sur le droit",
    ],
    answer:
        "Des droits naturels, universels et inaliénables attachés à toute personne",
    explanation:
        "Le texte rappelle que ces courants fondent l’idée de droits antérieurs et supérieurs au pouvoir politique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Sources — Philosophiques",
    question:
        "La philosophie des Lumières, au XVIIIᵉ siècle, promeut notamment :",
    options: [
      "L’arbitraire du pouvoir royal",
      "La tolérance religieuse, la liberté d’expression et la séparation des pouvoirs",
      "La suppression des Parlements",
    ],
    answer:
        "La tolérance religieuse, la liberté d’expression et la séparation des pouvoirs",
    explanation:
        "La fiche insiste sur ces thèmes majeurs des Lumières qui inspireront la Déclaration de 1789.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Sources — Juridiques avant 1789",
    question:
        "Parmi les textes anglais suivants, lequel fait partie des « pactes » contribuant à la protection des libertés ?",
    options: [
      "La Grande Charte (Magna Carta)",
      "Le Code civil",
      "La Constitution de 1958",
    ],
    answer: "La Grande Charte (Magna Carta)",
    explanation:
        "La Magna Carta, le Habeas Corpus et le Bill of Rights sont cités comme sources juridiques préalables à 1789.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Sources — Juridiques avant 1789",
    question: "Les déclarations américaines de 1776 affirment notamment :",
    options: [
      "La supériorité du roi d’Angleterre",
      "L’égalité et des droits inaliénables (vie, liberté, bonheur)",
      "La suppression du Parlement",
    ],
    answer: "L’égalité et des droits inaliénables (vie, liberté, bonheur)",
    explanation:
        "La fiche souligne que ces déclarations annoncent les principes de la Déclaration française de 1789.",
    difficulty: "Facile",
  ),

  // ===================== SOURCES — NIVEAU MOYEN =====================
  QuizQuestion(
    category: "Sources — Déclaration 1789",
    question: "Parmi les caractéristiques de la Déclaration de 1789 figure :",
    options: [
      "La reconnaissance explicite de droits collectifs (syndicats, associations)",
      "Un individualisme centré sur l’homme titulaire de droits",
      "Un rejet total de la notion de droit naturel",
    ],
    answer: "Un individualisme centré sur l’homme titulaire de droits",
    explanation:
        "Le texte présente la Déclaration comme individualiste : elle vise l’homme plutôt que les groupes.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Sources — Déclaration 1789",
    question: "La Déclaration de 1789 présente les droits proclamés comme :",
    options: [
      "Purement politiques et relatifs",
      "Naturels, inaliénables et sacrés",
      "Attribués seulement par le roi",
    ],
    answer: "Naturels, inaliénables et sacrés",
    explanation:
        "La dimension métaphysique du texte est rappelée : les droits sont antérieurs et supérieurs au pouvoir politique.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Sources — Déclaration 1789",
    question: "La Déclaration de 1789 a une portée :",
    options: [
      "Exclusivement française, sans vocation universelle",
      "Universelle, visant « tous les hommes » même si l’application pratique est limitée",
      "Uniquement locale (Paris et sa région)",
    ],
    answer:
        "Universelle, visant « tous les hommes » même si l’application pratique est limitée",
    explanation:
        "Le cours souligne l’universalité affirmée du texte, même si son application réelle est plus restreinte.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Sources — Déclaration 1789",
    question:
        "Parmi les droits de l’Homme proclamés en 1789, on trouve notamment :",
    options: [
      "La dignité, l’égalité, la liberté individuelle et la résistance à l’oppression",
      "Uniquement le droit au logement",
      "Uniquement la liberté d’entreprise",
    ],
    answer:
        "La dignité, l’égalité, la liberté individuelle et la résistance à l’oppression",
    explanation:
        "La fiche mentionne ces droits comme exemples de droits de l’Homme inspirant les libertés publiques.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Sources — Évolution postérieure",
    question: "La IIIᵉ République a consacré par diverses lois :",
    options: [
      "La suppression de la liberté d’association",
      "La liberté de réunion, de presse et d’association",
      "Le retour à la monarchie absolue",
    ],
    answer: "La liberté de réunion, de presse et d’association",
    explanation:
        "Le cours indique que la IIIᵉ République est marquée par de grandes lois libérales.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Sources — Évolution postérieure",
    question: "Le préambule de 1946 ajoute notamment :",
    options: [
      "Des droits économiques et sociaux (travail, grève, protection de la famille…) ",
      "Uniquement des devoirs envers l’État",
      "La suppression de toute liberté religieuse",
    ],
    answer:
        "Des droits économiques et sociaux (travail, grève, protection de la famille…) ",
    explanation:
        "La fiche rappelle que le préambule de 1946 enrichit le catalogue par des droits sociaux toujours en vigueur.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Sources — Préambule 1958",
    question: "Le préambule de la Constitution de 1958 renvoie expressément :",
    options: [
      "Uniquement à la Déclaration universelle de 1948",
      "À la Déclaration de 1789, au préambule de 1946 et à la Charte de l’environnement de 2004",
      "Seulement au Code pénal",
    ],
    answer:
        "À la Déclaration de 1789, au préambule de 1946 et à la Charte de l’environnement de 2004",
    explanation:
        "Ces textes, avec la Constitution, forment le bloc de constitutionnalité en matière de libertés.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Sources — Préambule 1958",
    question:
        "Les lois telles que « Informatique et libertés » (1978) ou le droit d’accès aux documents administratifs (1979) :",
    options: [
      "N’ont aucun lien avec les libertés publiques",
      "Complètent le bloc constitutionnel en créant de nouveaux droits ou en précisant leur protection",
      "Suppriment les droits fondamentaux",
    ],
    answer:
        "Complètent le bloc constitutionnel en créant de nouveaux droits ou en précisant leur protection",
    explanation:
        "La fiche les cite comme exemples de lois importantes en matière de libertés.",
    difficulty: "Moyenne",
  ),

  // ===================== SOURCES INTERNATIONALES — NIVEAU MOYEN/DÉLICAT =====================
  QuizQuestion(
    category: "Sources — Droit international humanitaire",
    question: "Les conventions de Genève de 1949 visent principalement à :",
    options: [
      "Réglementer la fiscalité des États",
      "Protéger les blessés, prisonniers de guerre et civils en temps de conflit armé",
      "Organiser la vie politique interne des États",
    ],
    answer:
        "Protéger les blessés, prisonniers de guerre et civils en temps de conflit armé",
    explanation:
        "Le cours cite ces conventions comme source de protection des personnes en temps de guerre.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Sources — ONU",
    question:
        "La Déclaration universelle des droits de l’Homme (ONU, 1948) a principalement :",
    options: [
      "Une valeur politique forte et inspire des traités contraignants",
      "La même valeur juridique qu’une loi municipale",
      "Un rôle exclusivement historique sans effet contemporain",
    ],
    answer: "Une valeur politique forte et inspire des traités contraignants",
    explanation:
        "La fiche rappelle qu’elle n’est pas directement contraignante mais a inspiré de nombreuses conventions obligatoires.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Sources — ONU",
    question:
        "Parmi les conventions suivantes, laquelle relève du système onusien de protection des droits fondamentaux ?",
    options: [
      "Convention contre la torture (1984)",
      "Traité de Maastricht",
      "Code de la route",
    ],
    answer: "Convention contre la torture (1984)",
    explanation:
        "Le cours cite la convention contre la torture parmi les grands instruments internationaux.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Sources — CEDH",
    question:
        "La Convention européenne des droits de l’Homme (CEDH) a été ratifiée par la France en :",
    options: ["1789", "1958", "1974"],
    answer: "1974",
    explanation:
        "Le texte indique que la France a ratifié la CEDH en 1974, permettant une protection conventionnelle renforcée.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Sources — CEDH",
    question: "Une originalité majeure de la CEDH est de permettre :",
    options: [
      "À chaque citoyen de saisir la Cour européenne des droits de l’Homme après épuisement des recours internes",
      "Uniquement aux États de se plaindre entre eux",
      "Aux maires de saisir la Cour pour des litiges locaux",
    ],
    answer:
        "À chaque citoyen de saisir la Cour européenne des droits de l’Homme après épuisement des recours internes",
    explanation:
        "Le cours insiste sur ce mécanisme de recours individuel, très important pour la protection concrète des libertés.",
    difficulty: "Moyenne",
  ),

  // ===================== HIÉRARCHIE DES NORMES — NIVEAU DIFFICILE/EXPERT =====================
  QuizQuestion(
    category: "Hiérarchie des normes",
    question:
        "Selon la fiche, au sommet de la hiérarchie des normes en matière de libertés publiques se trouvent :",
    options: [
      "Les règlements municipaux",
      "La Constitution et les textes à valeur constitutionnelle",
      "Les circulaires ministérielles",
    ],
    answer: "La Constitution et les textes à valeur constitutionnelle",
    explanation:
        "La fiche place au sommet Constitution, Déclaration de 1789, préambule de 1946, Charte de l’environnement et PFRLR.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Hiérarchie des normes",
    question:
        "Dans cette hiérarchie, les engagements internationaux (CEDH, conventions ONU…) :",
    options: [
      "Sont inférieurs à la Constitution mais supérieurs aux lois",
      "Sont inférieurs aux règlements municipaux",
      "N’ont aucune valeur en droit interne",
    ],
    answer: "Sont inférieurs à la Constitution mais supérieurs aux lois",
    explanation:
        "Le cours les place au second niveau, au-dessus des lois ordinaires.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Hiérarchie des normes",
    question: "Un règlement de police administrative doit être conforme :",
    options: [
      "Uniquement à la volonté du maire",
      "À la loi et aux normes supérieures (Constitution, conventions internationales)",
      "Aux usages locaux uniquement",
    ],
    answer:
        "À la loi et aux normes supérieures (Constitution, conventions internationales)",
    explanation:
        "Le rappel final insiste sur le contrôle de conformité d’une mesure de police à l’ensemble de la hiérarchie des normes.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Hiérarchie des normes",
    question:
        "Si une loi portant atteinte aux libertés publiques est suspectée de méconnaître la Constitution, les justiciables peuvent :",
    options: [
      "Saisir le Conseil constitutionnel par la voie de la QPC",
      "S’adresser uniquement au maire",
      "Saisir directement le Président de la République",
    ],
    answer: "Saisir le Conseil constitutionnel par la voie de la QPC",
    explanation:
        "La fiche évoque la QPC comme mécanisme permettant de contrôler la constitutionnalité d’une loi déjà en vigueur.",
    difficulty: "Difficile",
  ),

  // ===================== NOTION DE LIBERTÉS PUBLIQUES — NIVEAU FACILE =====================
  QuizQuestion(
    category: "Notion — Généralités",
    question: "Dans le langage courant, on confond souvent :",
    options: [
      "Droits de l’Homme et libertés publiques",
      "Fiscalité et procédure pénale",
      "Droit civil et droit routier",
    ],
    answer: "Droits de l’Homme et libertés publiques",
    explanation:
        "La fiche commence par constater cette confusion fréquente en langage courant.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Notion — Généralités",
    question: "En droit, les libertés publiques sont définies comme :",
    options: [
      "Une catégorie de droits fondamentaux reconnus et organisés par l’État",
      "De simples habitudes sociales",
      "Des privilèges réservés aux fonctionnaires",
    ],
    answer:
        "Une catégorie de droits fondamentaux reconnus et organisés par l’État",
    explanation:
        "La fiche en donne précisément cette définition pour distinguer libertés publiques et droits de l’Homme en général.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Notion — Libertés publiques et droits de l’Homme",
    question:
        "Parmi les trois idées issues du polycopié, la première est que les libertés publiques sont :",
    options: [
      "Des droits dont on n’attend rien de l’État",
      "Des droits « attendus » de l’État, qui doit mettre en place les moyens concrets de leur exercice",
      "Des droits purement théoriques sans application",
    ],
    answer:
        "Des droits « attendus » de l’État, qui doit mettre en place les moyens concrets de leur exercice",
    explanation:
        "Le cours explique que les citoyens attendent de l’État non seulement une abstention, mais aussi une action positive.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Notion — Libertés publiques et droits de l’Homme",
    question: "La deuxième idée est que les libertés publiques sont :",
    options: [
      "Des droits consacrés par un texte juridique (constitutionnel, législatif, réglementaire…)",
      "Des coutumes sociales sans trace écrite",
      "Des traditions locales uniquement",
    ],
    answer:
        "Des droits consacrés par un texte juridique (constitutionnel, législatif, réglementaire…)",
    explanation:
        "La fiche insiste sur la nécessité d’une consécration par un texte pour qu’une liberté soit « publique ». ",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Notion — Libertés publiques et droits de l’Homme",
    question:
        "La troisième idée est que certaines libertés, dites « fondamentales », :",
    options: [
      "Ne bénéficient d’aucune protection particulière",
      "Profitent d’un régime juridique plus favorable (contrôle du juge, procédures d’urgence, valeur constitutionnelle…)",
      "Sont abandonnées à l’arbitrage des autorités de police",
    ],
    answer:
        "Profitent d’un régime juridique plus favorable (contrôle du juge, procédures d’urgence, valeur constitutionnelle…)",
    explanation:
        "Le texte précise que ces libertés fondamentales bénéficient de protections renforcées.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Notion — Liberté",
    question: "Le polycopié définit la liberté comme :",
    options: [
      "La possibilité de ne jamais respecter la loi",
      "Le pouvoir d’autodétermination, c’est-à-dire la capacité de choisir son comportement personnel",
      "La simple absence de sanctions pénales",
    ],
    answer:
        "Le pouvoir d’autodétermination, c’est-à-dire la capacité de choisir son comportement personnel",
    explanation:
        "C’est la définition large rappelée au début du chapitre 2 de la fiche « Notion ».",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Notion — Libertés publiques",
    question:
        "Le qualificatif « publiques » dans l’expression « libertés publiques » renvoie principalement :",
    options: [
      "À la publicité des décisions",
      "À l’intervention de l’État qui reconnaît, encadre et protège ces libertés",
      "À la nécessité d’exercer la liberté sur la voie publique",
    ],
    answer:
        "À l’intervention de l’État qui reconnaît, encadre et protège ces libertés",
    explanation:
        "La fiche explique que « publiques » souligne le rôle de l’État dans la reconnaissance et la protection des libertés.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Notion — Libertés publiques",
    question:
        "Selon la définition juridique donnée, une liberté publique est notamment :",
    options: [
      "Une liberté fondamentale reconnue par l’État, consacrée par un texte, dont l’exercice est organisé et les atteintes sanctionnées",
      "Une liberté laissée à la discrétion des maires",
      "Une simple opinion morale sans portée juridique",
    ],
    answer:
        "Une liberté fondamentale reconnue par l’État, consacrée par un texte, dont l’exercice est organisé et les atteintes sanctionnées",
    explanation:
        "C’est la définition précise fournie dans la fiche avec l’idée de texte, d’organisation et de sanction des atteintes.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Notion — Pratique policière",
    question: "La fiche rappelle que sont des libertés publiques celles qui :",
    options: [
      "Intéressent les rapports entre particuliers uniquement",
      "Intéressent les rapports entre particuliers et autorités publiques et que l’État a choisi de consacrer, d’organiser et de protéger",
      "Ne concernent jamais l’action de la police",
    ],
    answer:
        "Intéressent les rapports entre particuliers et autorités publiques et que l’État a choisi de consacrer, d’organiser et de protéger",
    explanation:
        "Ce critère permet de cibler les libertés au cœur de l’action policière et du contrôle du juge.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Notion — Pratique policière",
    question:
        "Lorsque le policier intervient dans le domaine des libertés publiques (manifestation, contrôle d’identité, perquisition…), la légalité de son action :",
    options: [
      "Ne sera quasiment jamais contrôlée",
      "Sera particulièrement contrôlée par le juge, notamment au regard de la proportionnalité",
      "Dépend exclusivement de l’avis de sa hiérarchie",
    ],
    answer:
        "Sera particulièrement contrôlée par le juge, notamment au regard de la proportionnalité",
    explanation:
        "La fiche insiste sur le contrôle accru du juge dès lors que des droits fondamentaux sont en jeu.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Valeur juridique",
    question:
        "Aujourd’hui, la Déclaration des droits de l’homme et du citoyen de 1789 :",
    options: [
      "N’a plus aucune valeur juridique",
      "Figure dans le Préambule de la Constitution de 1958 et a valeur constitutionnelle",
      "Est seulement un texte symbolique d’histoire",
    ],
    answer:
        "Figure dans le Préambule de la Constitution de 1958 et a valeur constitutionnelle",
    explanation:
        "La D.D.H.C. figure dans le Préambule de la Constitution de 1958 et fait partie du bloc de constitutionnalité.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Bloc de constitutionnalité",
    question: "La D.D.H.C. fait partie :",
    options: [
      "Uniquement du Code civil",
      "Du « bloc de constitutionnalité »",
      "Du règlement intérieur de l’Assemblée nationale",
    ],
    answer: "Du « bloc de constitutionnalité »",
    explanation:
        "Le cours précise que la D.D.H.C. appartient au « bloc de constitutionnalité » avec le Préambule de 1946, la Constitution de 1958 et la Charte de l’environnement.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Principes généraux",
    question:
        "L’article 1er de la D.D.H.C. proclame notamment que les hommes :",
    options: [
      "Naissent et demeurent libres et égaux en droits",
      "Naissent tous avec les mêmes revenus",
      "Naissent et demeurent soumis à l’État",
    ],
    answer: "Naissent et demeurent libres et égaux en droits",
    explanation:
        "L’article 1er pose le principe d’égalité et de liberté et interdit les privilèges de naissance.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Droits naturels",
    question:
        "Selon l’article 2 de la D.D.H.C., parmi les droits naturels et imprescriptibles de l’homme figurent notamment :",
    options: [
      "La liberté, la propriété, la sûreté et la résistance à l’oppression",
      "Le droit au travail garanti et au logement",
      "Le droit à la gratuité des transports",
    ],
    answer:
        "La liberté, la propriété, la sûreté et la résistance à l’oppression",
    explanation:
        "L’article 2 énumère les droits naturels et imprescriptibles : liberté, propriété, sûreté, résistance à l’oppression.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Souveraineté",
    question:
        "L’article 3 de la D.D.H.C. affirme que le principe de toute souveraineté réside essentiellement dans :",
    options: ["Le Gouvernement", "Le Président de la République", "La Nation"],
    answer: "La Nation",
    explanation:
        "L’article 3 consacre le principe de souveraineté nationale en indiquant que la souveraineté réside dans la Nation.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Loi et volonté générale",
    question: "Selon l’article 6 de la D.D.H.C., la loi est avant tout :",
    options: [
      "L’expression de la volonté générale",
      "L’expression de la volonté du Gouvernement",
      "L’expression de la volonté du juge",
    ],
    answer: "L’expression de la volonté générale",
    explanation:
        "L’article 6 pose que la loi est l’expression de la volonté générale et qu’elle doit être la même pour tous.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Séparation des pouvoirs",
    question:
        "L’article 16 de la D.D.H.C. affirme qu’une société sans séparation des pouvoirs :",
    options: [
      "Est en état de guerre",
      "N’a point de Constitution",
      "Est automatiquement démocratique",
    ],
    answer: "N’a point de Constitution",
    explanation:
        "L’article 16 précise qu’une société sans garantie des droits ni séparation des pouvoirs « n’a point de Constitution ». ",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Liberté d’opinion",
    question: "L’article 10 de la D.D.H.C. protège principalement :",
    options: [
      "La liberté d’opinion, notamment religieuse",
      "Le droit de grève",
      "Le droit de vote uniquement",
    ],
    answer: "La liberté d’opinion, notamment religieuse",
    explanation:
        "L’article 10 garantit que nul ne doit être inquiété pour ses opinions, même religieuses, tant que leur manifestation ne trouble pas l’ordre public.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Liberté d’expression",
    question:
        "L’article 11 de la D.D.H.C. qualifie la libre communication des pensées et des opinions de :",
    options: [
      "Droit secondaire",
      "Droit facultatif",
      "Un des droits les plus précieux de l’homme",
    ],
    answer: "Un des droits les plus précieux de l’homme",
    explanation:
        "L’article 11 présente la libre communication des pensées et des opinions comme l’un des droits les plus précieux de l’homme.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Notion — Libertés publiques",
    question: "En droit, les libertés publiques sont avant tout :",
    options: [
      "Une catégorie de droits fondamentaux reconnus et organisés par l’État",
      "Des simples valeurs morales sans texte",
      "Des privilèges accordés à certaines professions",
    ],
    answer:
        "Une catégorie de droits fondamentaux reconnus et organisés par l’État",
    explanation:
        "La fiche précise que les libertés publiques sont une catégorie de droits fondamentaux reconnus, organisés et protégés par l’État.",
    difficulty: "Facile",
  ),

  // ===================== NIVEAU MOYEN =====================
  QuizQuestion(
    category: "D.D.H.C. — Contexte historique",
    question: "La D.D.H.C. s’inspire principalement :",
    options: [
      "Du Code Napoléon et de la IIIe République",
      "Des Lumières et des déclarations américaines d’indépendance",
      "Uniquement de la doctrine socialiste du XIXe siècle",
    ],
    answer: "Des Lumières et des déclarations américaines d’indépendance",
    explanation:
        "Le texte mentionne les influence des philosophes des Lumières (Montesquieu, Rousseau, Voltaire) et des déclarations américaines.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Finalité",
    question:
        "Selon son préambule, une des finalités de la D.D.H.C. est notamment de permettre :",
    options: [
      "De limiter les droits des citoyens au profit du Gouvernement",
      "De comparer à chaque instant les actes du pouvoir avec le but de toute institution politique",
      "De supprimer les Constitutions antérieures",
    ],
    answer:
        "De comparer à chaque instant les actes du pouvoir avec le but de toute institution politique",
    explanation:
        "La finalité indiquée est de rappeler les droits afin que les actes du pouvoir puissent être constamment comparés avec le but de toute institution politique.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Portée",
    question:
        "La D.D.H.C., bien que rédigée en France, est présentée dans le cours comme :",
    options: [
      "Un texte strictement réservé aux citoyens français",
      "Un texte à portée universelle visant tous les êtres humains",
      "Un texte exclusivement applicable aux fonctionnaires",
    ],
    answer: "Un texte à portée universelle visant tous les êtres humains",
    explanation:
        "La fiche souligne la portée universelle du texte, même s’il est adopté en France.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Décision Liberté d’association",
    question:
        "La reconnaissance explicite de la valeur constitutionnelle de la D.D.H.C. par le Conseil constitutionnel date :",
    options: [
      "De la décision « Liberté d’association » de 1971",
      "De la décision « Blocage des routes » de 1982",
      "De la Constitution de 1875",
    ],
    answer: "De la décision « Liberté d’association » de 1971",
    explanation:
        "Depuis la décision « Liberté d’association » de 1971, le Conseil constitutionnel reconnaît la valeur constitutionnelle de la D.D.H.C.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Liberté (art. 4)",
    question:
        "Selon l’article 4 de la D.D.H.C., la liberté consiste principalement à :",
    options: [
      "Pouvoir faire tout ce qui ne nuit pas à autrui",
      "Pouvoir faire tout ce qui est autorisé par son supérieur hiérarchique",
      "Pouvoir ne jamais respecter la loi",
    ],
    answer: "Pouvoir faire tout ce qui ne nuit pas à autrui",
    explanation:
        "L’article 4 définit la liberté comme la possibilité de faire tout ce qui ne nuit pas à autrui, sous le contrôle de la loi.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Sûreté",
    question: "Les articles 7 à 9 de la D.D.H.C. concernent principalement :",
    options: [
      "La liberté de réunion",
      "La sûreté et la protection contre les arrestations arbitraires",
      "La liberté de la presse uniquement",
    ],
    answer: "La sûreté et la protection contre les arrestations arbitraires",
    explanation:
        "Les articles 7 à 9 encadrent la sûreté, l’interdiction des arrestations arbitraires et la présomption d’innocence.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Propriété",
    question: "L’article 17 de la D.D.H.C. qualifie la propriété de :",
    options: [
      "Droit inviolable et sacré",
      "Droit secondaire et facultatif",
      "Privilège réservé aux propriétaires fonciers",
    ],
    answer: "Droit inviolable et sacré",
    explanation:
        "L’article 17 affirme que la propriété est un droit inviolable et sacré, dont on ne peut être privé que pour cause d’utilité publique et avec indemnité.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Garanties pénales",
    question:
        "Le principe de légalité des délits et des peines (art. 8) signifie que :",
    options: [
      "Le juge peut créer librement de nouvelles infractions",
      "Nul ne peut être puni qu’en vertu d’une loi établie et promulguée antérieurement au délit",
      "La loi peut toujours être appliquée rétroactivement au profit de la répression",
    ],
    answer:
        "Nul ne peut être puni qu’en vertu d’une loi établie et promulguée antérieurement au délit",
    explanation:
        "L’article 8 consacre le principe de légalité pénale et prohibe les incriminations et peines rétroactives.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Libertés publiques — Attentes vis-à-vis de l’État",
    question:
        "Selon le cours, concernant les libertés publiques, les individus attendent de l’État :",
    options: [
      "Uniquement qu’il s’abstienne d’agir",
      "Qu’il mette en place des moyens concrets permettant d’exercer les droits",
      "Qu’il supprime toute réglementation",
    ],
    answer:
        "Qu’il mette en place des moyens concrets permettant d’exercer les droits",
    explanation:
        "La première idée du cours est que les individus attendent de l’État une action positive, par exemple l’organisation de l’enseignement.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Libertés publiques — Reconnaissance par l’État",
    question:
        "Une caractéristique essentielle d’une liberté publique est qu’elle :",
    options: [
      "Résulte uniquement de la coutume sociale",
      "N’est jamais écrite dans un texte",
      "Est consacrée par un texte juridique (constitutionnel, législatif, etc.)",
    ],
    answer:
        "Est consacrée par un texte juridique (constitutionnel, législatif, etc.)",
    explanation:
        "La deuxième idée du cours souligne que les libertés publiques sont des droits de l’Homme intégrés dans le droit positif et reconnus par des textes.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Libertés publiques — Protection particulière",
    question: "Certaines libertés, dites « fondamentales », bénéficient :",
    options: [
      "D’une absence totale de contrôle du juge",
      "D’un régime juridique plus favorable (procédures d’urgence, contrôle renforcé)",
      "Un statut purement symbolique sans recours",
    ],
    answer:
        "D’un régime juridique plus favorable (procédures d’urgence, contrôle renforcé)",
    explanation:
        "Le cours insiste sur les protections particulières accordées aux libertés fondamentales (contrôle du juge administratif, procédures d’urgence, valeur constitutionnelle…).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Liberté — Autodétermination",
    question:
        "La liberté, au sens large, est définie dans le polycopié comme :",
    options: [
      "Le pouvoir d’autodétermination, c’est-à-dire la capacité de choisir son comportement",
      "Le pouvoir de ne jamais obéir aux lois",
      "La simple absence de contraintes physiques",
    ],
    answer:
        "Le pouvoir d’autodétermination, c’est-à-dire la capacité de choisir son comportement",
    explanation:
        "Le cours définit la liberté comme pouvoir d’autodétermination de l’individu, même si cette définition reste incomplète si l’on oublie le rôle de l’État.",
    difficulty: "Moyenne",
  ),

  // ===================== NIVEAU DIFFICILE =====================
  QuizQuestion(
    category: "D.D.H.C. — Contrôle de la loi",
    question:
        "Le fait que la D.D.H.C. fasse partie du bloc de constitutionnalité permet notamment :",
    options: [
      "Au juge de censurer une loi contraire aux droits qu’elle proclame",
      "Au Gouvernement de modifier la D.D.H.C. par décret simple",
      "Au Parlement de s’en affranchir par une loi ordinaire",
    ],
    answer: "Au juge de censurer une loi contraire aux droits qu’elle proclame",
    explanation:
        "Parce qu’elle a valeur constitutionnelle, la D.D.H.C. permet au Conseil constitutionnel de censurer les lois incompatibles.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Juge et libertés",
    question: "Pour un policier, la D.D.H.C. encadre son action car :",
    options: [
      "Elle ne concerne que le Parlement",
      "Elle s’impose à toutes les autorités (Parlement, Gouvernement, administration, juges…) et donc à la police",
      "Elle ne s’applique qu’aux juges constitutionnels",
    ],
    answer:
        "Elle s’impose à toutes les autorités (Parlement, Gouvernement, administration, juges…) et donc à la police",
    explanation:
        "Le texte indique que la D.D.H.C. s’impose à toutes les autorités, y compris l’administration et la police.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Principe d’égalité",
    question:
        "Le principe d’égalité dégagé de l’article 1er de la D.D.H.C. est souvent invoqué :",
    options: [
      "Pour justifier toutes les discriminations",
      "Pour contester des différences de traitement injustifiées entre catégories de personnes",
      "Uniquement dans les litiges fiscaux",
    ],
    answer:
        "Pour contester des différences de traitement injustifiées entre catégories de personnes",
    explanation:
        "La fiche donne l’exemple de différences de traitement entre fonctionnaires, étrangers, détenus… au regard du principe d’égalité.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Séparation des pouvoirs",
    question: "L’article 16 de la D.D.H.C. sert notamment de fondement :",
    options: [
      "À la notion de monopole du Parlement",
      "Au contrôle de la séparation des pouvoirs et au droit à un procès équitable",
      "Au principe de gratuité de l’enseignement supérieur",
    ],
    answer:
        "Au contrôle de la séparation des pouvoirs et au droit à un procès équitable",
    explanation:
        "L’article 16 est utilisé pour exiger des garanties effectives, notamment l’indépendance du juge et un recours effectif.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Nécessité et proportionnalité des peines",
    question:
        "Le principe de nécessité et de proportionnalité des peines, issu de l’article 8 de la D.D.H.C., implique que :",
    options: [
      "La loi peut prévoir des peines illimitées si le juge est d’accord",
      "La loi ne doit établir que des peines strictement et évidemment nécessaires",
      "Seul le Gouvernement fixe librement le niveau des peines",
    ],
    answer:
        "La loi ne doit établir que des peines strictement et évidemment nécessaires",
    explanation:
        "L’article 8 impose que les peines prévues par la loi soient strictement et évidemment nécessaires.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Présomption d’innocence",
    question:
        "Selon l’article 9 de la D.D.H.C., la rigueur des mesures privatives de liberté :",
    options: [
      "Peut excéder ce qui est nécessaire pour faire un exemple",
      "Ne doit pas excéder ce qui est nécessaire",
      "N’est pas encadrée par le texte",
    ],
    answer: "Ne doit pas excéder ce qui est nécessaire",
    explanation:
        "L’article 9 impose que la rigueur liée à la privation de liberté reste limitée à ce qui est nécessaire, en lien avec la présomption d’innocence.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Libertés publiques — Définition",
    question:
        "La définition juridique des libertés publiques insiste sur le fait qu’elles sont :",
    options: [
      "Des convenances sociales non écrites",
      "Des libertés fondamentales reconnues par l’État, consacrées par un texte, organisées et protégées",
      "Des coutumes internationales sans valeur interne",
    ],
    answer:
        "Des libertés fondamentales reconnues par l’État, consacrées par un texte, organisées et protégées",
    explanation:
        "La fiche donne une définition précise : libertés fondamentales reconnues par l’État, consacrées par un texte, dont l’exercice est encadré et les atteintes sanctionnées.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Libertés publiques — Reconnaissance par un texte",
    question:
        "Pourquoi une liberté n’est-elle « publique » que si elle est reconnue par un texte ?",
    options: [
      "Parce que seules les libertés écrites sur Internet existent",
      "Parce que le droit objectif organise les rapports entre l’État et les individus autour de cette liberté",
      "Parce que la coutume est toujours illégale",
    ],
    answer:
        "Parce que le droit objectif organise les rapports entre l’État et les individus autour de cette liberté",
    explanation:
        "Le cours insiste sur le rôle des textes (constitution, loi, conventions) qui intègrent les droits de l’Homme dans le droit positif.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Libertés publiques — Rôle du juge",
    question:
        "En cas d’atteinte illégale à une liberté publique, le rôle du juge est :",
    options: [
      "Inexistant, car l’administration a toujours raison",
      "De pouvoir censurer la restriction et sanctionner l’administration",
      "De simplement donner un avis consultatif",
    ],
    answer:
        "De pouvoir censurer la restriction et sanctionner l’administration",
    explanation:
        "La sanction des atteintes par le juge garantit concrètement l’effectivité des libertés publiques.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Police — Atteinte aux libertés",
    question:
        "Selon la fiche, pour les mesures de police (contrôles, fouilles, gardes à vue…), le principe de base est que :",
    options: [
      "Aucune liberté n’est concernée",
      "Toute mesure de police porte atteinte à une liberté et doit être justifiée",
      "La police agit toujours sans limite juridique",
    ],
    answer:
        "Toute mesure de police porte atteinte à une liberté et doit être justifiée",
    explanation:
        "Le cours rappelle que toute mesure de police constitue une atteinte à une liberté et doit respecter les principes de nécessité, proportionnalité, égalité, sûreté…",
    difficulty: "Difficile",
  ),

  // ===================== NIVEAU EXPERT =====================
  QuizQuestion(
    category: "Articulation D.D.H.C. / Libertés publiques",
    question:
        "En pratique, le lien entre D.D.H.C. et libertés publiques peut être résumé ainsi :",
    options: [
      "Les libertés publiques ignorent totalement la D.D.H.C.",
      "Les libertés publiques prolongent les principes de la D.D.H.C. en les intégrant dans le droit positif et en prévoyant des garanties concrètes",
      "La D.D.H.C. ne concerne que le droit pénal et pas les libertés publiques",
    ],
    answer:
        "Les libertés publiques prolongent les principes de la D.D.H.C. en les intégrant dans le droit positif et en prévoyant des garanties concrètes",
    explanation:
        "La D.D.H.C. proclame des principes, tandis que la notion de libertés publiques désigne ces droits intégrés dans le droit positif et protégés par des mécanismes juridiques.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "Libertés publiques — Dimension « publique »",
    question:
        "Le qualificatif « publiques » dans l’expression « libertés publiques » signifie principalement :",
    options: [
      "Que ces libertés ne concernent que les agents publics",
      "Qu’il existe nécessairement une intervention de l’État, qui reconnaît, encadre et protège ces libertés",
      "Que ces libertés ne s’exercent qu’en plein air",
    ],
    answer:
        "Qu’il existe nécessairement une intervention de l’État, qui reconnaît, encadre et protège ces libertés",
    explanation:
        "Le cours insiste sur la dualité : liberté individuelle + intervention de l’État via des normes juridiques.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "Libertés publiques — Encadrement",
    question:
        "La réglementation de l’exercice d’une liberté publique par l’État :",
    options: [
      "Peut aller jusqu’à vider totalement la liberté de sa substance",
      "Ne doit jamais vider la liberté de sa substance, malgré les encadrements (déclarations, autorisations…)",
      "Est toujours contraire à la D.D.H.C.",
    ],
    answer:
        "Ne doit jamais vider la liberté de sa substance, malgré les encadrements (déclarations, autorisations…)",
    explanation:
        "La fiche précise que l’État peut organiser l’exercice des libertés, mais sans les priver de leur contenu essentiel.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "Libertés publiques — Sélection des libertés",
    question:
        "Selon le cours, toutes les libertés n’entrent pas dans la catégorie des libertés publiques car :",
    options: [
      "La plupart des libertés sont purement économiques",
      "Sont des libertés publiques celles qui intéressent les rapports entre particuliers et autorités publiques et que l’État a choisi de consacrer et protéger",
      "Les libertés publiques ne concernent que les relations entre particuliers",
    ],
    answer:
        "Sont des libertés publiques celles qui intéressent les rapports entre particuliers et autorités publiques et que l’État a choisi de consacrer et protéger",
    explanation:
        "Le critère central est le rapport avec les autorités publiques et la consécration par l’État.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "Police — Niveau de contrôle",
    question:
        "Lorsqu’un policier intervient dans un domaine touchant aux libertés publiques (manifestation, perquisition, contrôle d’identité…), la légalité de son action :",
    options: [
      "Est peu contrôlée car il s’agit d’ordre public",
      "Est particulièrement contrôlée par le juge au regard des droits fondamentaux",
      "Ne peut jamais être contestée devant un juge",
    ],
    answer:
        "Est particulièrement contrôlée par le juge au regard des droits fondamentaux",
    explanation:
        "La fiche souligne que le juge administratif ou judiciaire appréciera la compatibilité de l’acte de police avec la D.D.H.C. et les libertés publiques.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Contrôle concret",
    question:
        "Un exemple donné dans la fiche montre qu’une loi créant une nouvelle infraction vague et trop large peut être censurée :",
    options: [
      "Sur le fondement de l’article 8 (principe de légalité et de nécessité des peines)",
      "Uniquement sur la base d’une décision ministérielle",
      "Sur le fondement d’un simple usage administratif",
    ],
    answer:
        "Sur le fondement de l’article 8 (principe de légalité et de nécessité des peines)",
    explanation:
        "L’article 8 sert de base au contrôle des incriminations floues ou disproportionnées.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "D.D.H.C. — Sûreté et garde à vue",
    question:
        "Selon la fiche, des conditions de garde à vue trop longues ou insuffisamment encadrées peuvent être jugées contraires :",
    options: [
      "À l’article 9 de la D.D.H.C. sur la présomption d’innocence et la nécessité des mesures",
      "À l’article 17 sur la propriété",
      "À l’article 3 sur la souveraineté nationale",
    ],
    answer:
        "À l’article 9 de la D.D.H.C. sur la présomption d’innocence et la nécessité des mesures",
    explanation:
        "L’exemple donné relie directement les conditions de garde à vue à l’article 9 et à la nécessité des mesures privatives de liberté.",
    difficulty: "Expert",
  ),
  QuizQuestion(
    category: "Synthèse — Intérêt pour le policier",
    question:
        "Connaître les grands articles de la D.D.H.C. et la notion de libertés publiques permet au policier :",
    options: [
      "Uniquement de réussir ses examens, sans impact sur le terrain",
      "De mieux comprendre le sens des libertés, d’appliquer la loi et d’anticiper les risques juridiques de ses interventions",
      "De se soustraire aux règles en invoquant la Constitution",
    ],
    answer:
        "De mieux comprendre le sens des libertés, d’appliquer la loi et d’anticiper les risques juridiques de ses interventions",
    explanation:
        "La fiche conclut en soulignant l’importance pratique de ces textes pour l’action quotidienne du policier.",
    difficulty: "Expert",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizLibertesPubliquesPage extends StatefulWidget {
  static const String routeName = '/gpx/generalites/quiz/libertes_publiques';
  final String uid;
  final String email;

  const QuizLibertesPubliquesPage({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizLibertesPubliquesPage> createState() =>
      _QuizLibertesPubliquesPageState();
}

class _QuizLibertesPubliquesPageState extends State<QuizLibertesPubliquesPage>
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
        ? questionsLibertesPubliquesIntro
        : questionsLibertesPubliquesIntro
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
            'quiz_name': 'Les libertés publiques',
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
      await _sb.from('quiz_libertes_intro').insert({
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
      debugPrint('❌ quiz_libertes_intro insert failed: $e');
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
          message: 'Tu maîtrises les libertés publiques 💪',
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
