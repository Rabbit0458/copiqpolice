import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:copiqpolice/ui/app_notifier.dart'
    show AppNotifier, AppSettingsController;

Color _opa(Color c, double a) => c.withValues(alpha: a);

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

class QuizOption {
  final String label; // texte affiché + valeur comparée
  final String? assetImage; // ex: "assets/images/major.png"
  final String? networkImage; // si un jour tu veux du réseau

  const QuizOption({required this.label, this.assetImage, this.networkImage});
}

class QuizQuestion {
  final String category;
  final String question;
  final List<String> options;
  final String answer;
  final String explanation;
  final String difficulty;
  final String? sub;

  // ✅ nouveau
  final String? questionImageAsset; // ex: "assets/images/dgpn.png"

  const QuizQuestion({
    required this.category,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.difficulty,
    this.sub,
    this.questionImageAsset,
  });
}

final List<QuizQuestion> questionAccueilPublic = [
  QuizQuestion(
    category: "Accueil du public — Principes généraux",
    question: "L’accueil du public constitue pour la police nationale :",
    options: [
      "Une priorité majeure",
      "Une mission secondaire",
      "Une mission réservée à certains services",
    ],
    answer: "Une priorité majeure",
    explanation:
        "Article 1 de la charte : l’accueil du public constitue une priorité majeure pour la police nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Qualité de l’accueil",
    question: "La qualité de l’accueil repose notamment sur :",
    options: [
      "La disponibilité permanente et la réduction des délais d’attente",
      "La rapidité d’interpellation uniquement",
      "La limitation des échanges avec le public",
    ],
    answer: "La disponibilité permanente et la réduction des délais d’attente",
    explanation:
        "Article 1 : disponibilité permanente, réduction des délais d’attente et satisfaction des demandes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Comportement",
    question: "Lors de l’accueil du public, les policiers doivent adopter :",
    options: [
      "Un comportement exemplaire",
      "Un comportement strictement administratif",
      "Un comportement familier",
    ],
    answer: "Un comportement exemplaire",
    explanation:
        "La charte impose un comportement exemplaire dans le cadre de la loi et des principes déontologiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Droit des citoyens",
    question: "Être écouté à tout moment par la police constitue :",
    options: [
      "Un droit ouvert à chaque citoyen",
      "Une faculté selon la charge de travail",
      "Un privilège exceptionnel",
    ],
    answer: "Un droit ouvert à chaque citoyen",
    explanation:
        "Article 2 : être écouté, assisté et secouru constitue un droit pour chaque citoyen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Dépôt de plainte",
    question: "Les policiers sont tenus de recevoir les plaintes :",
    options: [
      "Même hors compétence territoriale",
      "Uniquement sur leur ressort",
      "Uniquement sur rendez-vous",
    ],
    answer: "Même hors compétence territoriale",
    explanation:
        "La loi impose la réception des plaintes même hors ressort territorial.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Traitement des plaintes",
    question: "Le service recevant une plainte doit :",
    options: [
      "Assurer les enregistrements et diffusions nécessaires",
      "Transmettre uniquement au parquet",
      "Reporter le traitement",
    ],
    answer: "Assurer les enregistrements et diffusions nécessaires",
    explanation:
        "Article 2 : le service veille aux enregistrements et diffusions nécessaires à l’enquête.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Disparition",
    question: "Tout signalement de disparition fait l’objet :",
    options: [
      "D’un traitement immédiat",
      "D’une vérification préalable de 48h",
      "D’une main courante obligatoire",
    ],
    answer: "D’un traitement immédiat",
    explanation:
        "Article 6 : toute disparition fait l’objet d’une attention particulière et immédiate.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Disparition",
    question: "Un signalement de disparition concerne :",
    options: [
      "Mineur ou majeur, sans distinction",
      "Uniquement les mineurs",
      "Uniquement les personnes vulnérables",
    ],
    answer: "Mineur ou majeur, sans distinction",
    explanation:
        "Article 6 : toute disparition est prise en compte quel que soit l’âge.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Écoute",
    question: "Toute personne sollicitant la police fait l’objet :",
    options: [
      "D’une écoute attentive",
      "D’une orientation automatique",
      "D’un tri préalable",
    ],
    answer: "D’une écoute attentive",
    explanation:
        "Article 2 : écoute attentive quels que soient l’origine ou le statut.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Requêtes",
    question: "Toute requête, quel que soit son degré de gravité :",
    options: [
      "Est prise en compte avec soin",
      "Peut être ignorée",
      "Est traitée ultérieurement",
    ],
    answer: "Est prise en compte avec soin",
    explanation:
        "La charte impose une prise en compte systématique des requêtes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Politesse",
    question: "La qualité de l’accueil repose sur :",
    options: [
      "La politesse, la retenue et la correction",
      "La fermeté exclusive",
      "La neutralité distante",
    ],
    answer: "La politesse, la retenue et la correction",
    explanation: "Article 3 : politesse, retenue et correction sont exigées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Attitude",
    question: "Les policiers doivent s’abstenir :",
    options: [
      "De toute familiarité et propos déplacés",
      "De toute communication",
      "De toute initiative",
    ],
    answer: "De toute familiarité et propos déplacés",
    explanation:
        "Article 8 : interdiction de toute familiarité ou propos désobligeants.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Comportement",
    question: "Face au public, les policiers agissent avec :",
    options: [
      "Calme, discernement et patience",
      "Autorité systématique",
      "Neutralité passive",
    ],
    answer: "Calme, discernement et patience",
    explanation: "La charte impose calme, sang-froid et discernement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Impartialité",
    question: "Les policiers doivent rester :",
    options: [
      "Impartiaux et objectifs",
      "Solidaires du plaignant",
      "Favorables à la victime",
    ],
    answer: "Impartiaux et objectifs",
    explanation:
        "Même sensibles à la détresse, les policiers restent impartiaux.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Tenue",
    question: "Les missions au contact du public sont assurées :",
    options: [
      "En uniforme ou en tenue civile correcte",
      "Uniquement en uniforme",
      "Sans exigence particulière",
    ],
    answer: "En uniforme ou en tenue civile correcte",
    explanation:
        "Article 8 : uniforme ou tenue de ville correcte selon l’autorisation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Réponse",
    question: "En cas d’impossibilité de répondre immédiatement :",
    options: [
      "Des explications doivent être données",
      "La demande est rejetée",
      "Le public doit revenir",
    ],
    answer: "Des explications doivent être données",
    explanation: "Une réponse adaptée ou explicative est obligatoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Victimes",
    question: "Les victimes d’infractions pénales bénéficient :",
    options: [
      "D’un accueil privilégié",
      "D’un accueil standard",
      "D’un accueil différé",
    ],
    answer: "D’un accueil privilégié",
    explanation: "Article 4 : accueil et écoute privilégiés des victimes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Victimes",
    question: "Les policiers doivent préserver chez les victimes :",
    options: [
      "La dignité, l’intimité et la pudeur",
      "Uniquement la confidentialité",
      "Uniquement la sécurité",
    ],
    answer: "La dignité, l’intimité et la pudeur",
    explanation: "Article 4 : protection de la dignité et de l’intimité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Personnes vulnérables",
    question:
        "À l’égard des personnes vulnérables, les policiers manifestent :",
    options: [
      "Une attention renforcée",
      "Une neutralité stricte",
      "Une distance professionnelle",
    ],
    answer: "Une attention renforcée",
    explanation:
        "La charte prévoit une attention particulière aux personnes vulnérables.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Accueil du public — Principes",
    question: "L’accueil du public par la police nationale doit être :",
    options: [
      "Accessible à tous, sans discrimination",
      "Réservé aux victimes d’infractions",
      "Conditionné à la gravité des faits",
    ],
    answer: "Accessible à tous, sans discrimination",
    explanation:
        "La charte garantit un accueil égal à toute personne sollicitant la police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Disponibilité",
    question:
        "La disponibilité des services de police à l’égard du public est :",
    options: [
      "Une exigence permanente",
      "Limitée aux horaires d’ouverture",
      "Subordonnée à la charge de travail",
    ],
    answer: "Une exigence permanente",
    explanation:
        "La charte insiste sur la disponibilité permanente des services.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Délai d’attente",
    question: "La réduction des délais d’attente vise principalement à :",
    options: [
      "Améliorer la qualité de l’accueil",
      "Limiter le nombre de plaintes",
      "Accélérer les procédures judiciaires",
    ],
    answer: "Améliorer la qualité de l’accueil",
    explanation:
        "La charte lie directement délais d’attente et qualité du service rendu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Orientation",
    question: "Lorsqu’une demande ne relève pas de la police, l’usager doit :",
    options: [
      "Être orienté vers le service compétent",
      "Être invité à revenir plus tard",
      "Être systématiquement éconduit",
    ],
    answer: "Être orienté vers le service compétent",
    explanation:
        "La charte impose une orientation claire et utile de l’usager.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Neutralité",
    question: "Dans l’accueil du public, les policiers doivent faire preuve :",
    options: [
      "De neutralité et d’objectivité",
      "De soutien systématique",
      "De prise de position personnelle",
    ],
    answer: "De neutralité et d’objectivité",
    explanation:
        "Même à l’égard d’une victime, l’agent reste neutre et objectif.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Respect",
    question: "Le respect de la dignité des personnes implique notamment :",
    options: [
      "L’absence de jugement ou de propos déplacés",
      "La brièveté de l’échange",
      "Le refus de certaines demandes",
    ],
    answer: "L’absence de jugement ou de propos déplacés",
    explanation: "La dignité impose retenue, respect et absence de jugement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Confidentialité",
    question: "Les échanges avec le public doivent se dérouler :",
    options: [
      "Dans des conditions garantissant la confidentialité",
      "En présence d’autres usagers",
      "Uniquement par écrit",
    ],
    answer: "Dans des conditions garantissant la confidentialité",
    explanation:
        "La charte insiste sur la protection des propos tenus par l’usager.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Victimes",
    question: "Les victimes doivent être accueillies avec :",
    options: [
      "Empathie et considération",
      "Neutralité distante",
      "Réserve stricte",
    ],
    answer: "Empathie et considération",
    explanation: "L’accueil des victimes nécessite une attention particulière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Victimes",
    question: "La prise en charge des victimes vise notamment à :",
    options: [
      "Éviter toute revictimisation",
      "Accélérer les poursuites",
      "Limiter les échanges",
    ],
    answer: "Éviter toute revictimisation",
    explanation: "La charte cherche à protéger la victime sur le plan humain.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Information",
    question: "Informer la victime sur la procédure permet :",
    options: [
      "De renforcer la confiance dans l’institution",
      "De limiter les plaintes",
      "D’accélérer l’enquête",
    ],
    answer: "De renforcer la confiance dans l’institution",
    explanation:
        "L’information participe à la qualité du service public rendu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Suivi",
    question: "Le suivi de la plainte permet à la victime :",
    options: [
      "De connaître l’évolution de la procédure",
      "D’intervenir dans l’enquête",
      "De diriger l’action policière",
    ],
    answer: "De connaître l’évolution de la procédure",
    explanation: "La victime a droit à une information régulière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Attitude",
    question: "Un comportement impatient ou ironique à l’accueil est :",
    options: [
      "Contraire à la charte",
      "Toléré en cas d’affluence",
      "Acceptable hors dépôt de plainte",
    ],
    answer: "Contraire à la charte",
    explanation: "La charte impose calme et maîtrise en toute circonstance.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Personnes vulnérables",
    question: "Une personne vulnérable doit faire l’objet :",
    options: [
      "D’une prise en charge adaptée",
      "D’un traitement standard",
      "D’une orientation systématique",
    ],
    answer: "D’une prise en charge adaptée",
    explanation:
        "La charte prévoit une attention renforcée aux vulnérabilités.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Violence",
    question: "Face à une personne agressive, le policier doit :",
    options: [
      "Rester calme et professionnel",
      "Répondre sur le même ton",
      "Mettre fin immédiatement à l’accueil",
    ],
    answer: "Rester calme et professionnel",
    explanation: "Le sang-froid est une exigence professionnelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Égalité",
    question: "L’égalité de traitement implique :",
    options: [
      "L’absence de discrimination",
      "Une hiérarchisation des demandes",
      "Une priorité aux habitués",
    ],
    answer: "L’absence de discrimination",
    explanation: "La charte proscrit toute distinction injustifiée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Langage",
    question: "Le langage employé avec le public doit être :",
    options: [
      "Clair et compréhensible",
      "Technique et juridique",
      "Abrégé et formel",
    ],
    answer: "Clair et compréhensible",
    explanation:
        "La qualité de l’accueil passe par une communication accessible.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Orientation victimes",
    question: "Lorsque nécessaire, la victime doit être orientée vers :",
    options: [
      "Des services ou associations d’aide",
      "Uniquement le parquet",
      "Un autre commissariat",
    ],
    answer: "Des services ou associations d’aide",
    explanation: "L’assistance aux victimes inclut l’orientation adaptée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Image institutionnelle",
    question: "La qualité de l’accueil influence directement :",
    options: [
      "L’image de la police nationale",
      "La durée des enquêtes",
      "Les décisions de justice",
    ],
    answer: "L’image de la police nationale",
    explanation: "L’accueil conditionne la confiance de la population.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Continuité",
    question: "La continuité de l’accueil du public est assurée :",
    options: [
      "En toutes circonstances",
      "Uniquement en journée",
      "Selon les effectifs",
    ],
    answer: "En toutes circonstances",
    explanation: "La charte vise un accueil constant et continu.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Service public",
    question: "L’accueil du public s’inscrit avant tout dans la mission :",
    options: [
      "De service public",
      "De police judiciaire",
      "De maintien de l’ordre",
    ],
    answer: "De service public",
    explanation:
        "L’accueil est une composante essentielle du service public de police.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Assistance aux victimes — Principes",
    question: "L’assistance aux victimes a pour objectif principal :",
    options: [
      "De garantir leurs droits et leur dignité",
      "D’accélérer uniquement la procédure",
      "De limiter les échanges avec les services",
    ],
    answer: "De garantir leurs droits et leur dignité",
    explanation:
        "L’assistance aux victimes vise avant tout la protection de leurs droits et de leur dignité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Accueil",
    question: "Toute victime doit être accueillie :",
    options: [
      "Avec respect, écoute et considération",
      "Avec neutralité distante",
      "Avec rapidité uniquement",
    ],
    answer: "Avec respect, écoute et considération",
    explanation:
        "La charte impose un accueil respectueux et attentif des victimes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Dépôt de plainte",
    question: "Refuser de prendre une plainte constitue :",
    options: [
      "Un manquement aux obligations",
      "Une faculté du service",
      "Une simple irrégularité",
    ],
    answer: "Un manquement aux obligations",
    explanation: "La prise de plainte est une obligation légale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Information",
    question: "La victime doit être informée :",
    options: [
      "De ses droits et des démarches possibles",
      "Uniquement du dépôt de plainte",
      "Seulement à sa demande écrite",
    ],
    answer: "De ses droits et des démarches possibles",
    explanation:
        "L’information de la victime fait partie intégrante de sa prise en charge.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Confidentialité",
    question: "Les propos tenus par une victime doivent être :",
    options: [
      "Traités avec confidentialité",
      "Communiqués aux proches",
      "Diffusés aux services partenaires",
    ],
    answer: "Traités avec confidentialité",
    explanation:
        "La confidentialité protège la dignité et la sécurité de la victime.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Orientation",
    question: "L’orientation vers une association d’aide aux victimes est :",
    options: [
      "Une mesure recommandée",
      "Une obligation systématique",
      "Interdite sans accord judiciaire",
    ],
    answer: "Une mesure recommandée",
    explanation:
        "La police peut orienter la victime vers des structures adaptées.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Suivi",
    question: "Informer la victime de l’évolution de sa procédure permet :",
    options: [
      "De maintenir la confiance",
      "D’influencer la décision judiciaire",
      "De clore plus rapidement le dossier",
    ],
    answer: "De maintenir la confiance",
    explanation:
        "L’information régulière renforce le lien entre la victime et l’institution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Neutralité",
    question: "L’assistance aux victimes doit s’exercer :",
    options: [
      "Sans remettre en cause l’impartialité",
      "En prenant systématiquement parti",
      "En privilégiant la version de la victime",
    ],
    answer: "Sans remettre en cause l’impartialité",
    explanation:
        "L’aide à la victime est compatible avec l’impartialité policière.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Écoute",
    question: "L’écoute de la victime doit être :",
    options: [
      "Active et bienveillante",
      "Strictement administrative",
      "Limitée dans le temps",
    ],
    answer: "Active et bienveillante",
    explanation: "L’écoute est un élément central de l’assistance.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Revictimisation",
    question: "La revictimisation correspond :",
    options: [
      "À une souffrance aggravée par une mauvaise prise en charge",
      "À une infraction répétée",
      "À un mensonge de la victime",
    ],
    answer: "À une souffrance aggravée par une mauvaise prise en charge",
    explanation: "Une mauvaise attitude peut accentuer le traumatisme.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Vulnérabilité",
    question: "Les victimes vulnérables nécessitent :",
    options: [
      "Une attention renforcée",
      "Un traitement standard",
      "Une orientation automatique",
    ],
    answer: "Une attention renforcée",
    explanation:
        "La vulnérabilité impose une adaptation de la prise en charge.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Langage",
    question: "Le langage utilisé avec la victime doit être :",
    options: [
      "Clair et compréhensible",
      "Juridique et technique",
      "Succinct uniquement",
    ],
    answer: "Clair et compréhensible",
    explanation: "Un langage accessible facilite la compréhension des droits.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Respect",
    question: "Un propos culpabilisant à l’égard d’une victime est :",
    options: [
      "Contraire aux principes",
      "Toléré en cas de doute",
      "Acceptable hors audition",
    ],
    answer: "Contraire aux principes",
    explanation: "La victime ne doit jamais être culpabilisée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Temps",
    question: "La prise en charge d’une victime doit :",
    options: [
      "S’adapter à son rythme",
      "Être rapide à tout prix",
      "Être limitée dans le temps",
    ],
    answer: "S’adapter à son rythme",
    explanation: "Le respect du rythme de la victime est essentiel.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Protection",
    question: "La protection de la victime vise notamment :",
    options: [
      "Sa sécurité et sa dignité",
      "La rapidité de l’enquête",
      "La clôture du dossier",
    ],
    answer: "Sa sécurité et sa dignité",
    explanation: "La protection humaine prime dans la prise en charge.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Orientation médicale",
    question: "Lorsque l’état de la victime le nécessite, elle doit être :",
    options: [
      "Orientée vers une prise en charge médicale",
      "Invitée à revenir ultérieurement",
      "Simplement conseillée",
    ],
    answer: "Orientée vers une prise en charge médicale",
    explanation: "La santé de la victime est prioritaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Violence",
    question: "Face à une victime en état de choc, le policier doit :",
    options: [
      "Faire preuve de patience et de calme",
      "Accélérer l’audition",
      "Reporter systématiquement l’accueil",
    ],
    answer: "Faire preuve de patience et de calme",
    explanation: "Le sang-froid est indispensable dans ces situations.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Droits",
    question: "La victime a le droit :",
    options: [
      "D’être informée et accompagnée",
      "De diriger l’enquête",
      "De choisir les sanctions",
    ],
    answer: "D’être informée et accompagnée",
    explanation: "Les droits de la victime sont clairement encadrés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Confiance",
    question: "Une bonne assistance aux victimes permet :",
    options: [
      "De renforcer la confiance envers la police",
      "De réduire les infractions",
      "D’éviter toute contestation",
    ],
    answer: "De renforcer la confiance envers la police",
    explanation: "La qualité de l’assistance impacte l’image institutionnelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Service public",
    question: "L’assistance aux victimes s’inscrit dans :",
    options: [
      "La mission de service public",
      "La seule mission judiciaire",
      "Une mission optionnelle",
    ],
    answer: "La mission de service public",
    explanation:
        "L’assistance aux victimes fait partie intégrante du service public de police.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Assistance aux victimes — Violence conjugale",
    question: "Face à une victime de violences conjugales, le policier doit :",
    options: [
      "Assurer écoute, protection et information",
      "Attendre une plainte formelle",
      "Limiter l’intervention au strict minimum",
    ],
    answer: "Assurer écoute, protection et information",
    explanation: "La prise en charge doit être immédiate et adaptée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Violence conjugale",
    question: "Une victime qui hésite à déposer plainte doit être :",
    options: [
      "Informée de ses droits sans pression",
      "Incitée fermement à porter plainte",
      "Renvoyée vers un autre service",
    ],
    answer: "Informée de ses droits sans pression",
    explanation: "La décision appartient à la victime.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Mineur",
    question: "Lorsqu’un mineur est victime, la priorité est :",
    options: [
      "Sa protection immédiate",
      "La rapidité de l’audition",
      "L’information des médias",
    ],
    answer: "Sa protection immédiate",
    explanation: "La protection du mineur prime sur toute autre considération.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Audition",
    question: "Une audition mal conduite peut entraîner :",
    options: [
      "Une revictimisation",
      "Une nullité automatique",
      "Une sanction pénale immédiate",
    ],
    answer: "Une revictimisation",
    explanation: "Une mauvaise prise en charge peut aggraver le traumatisme.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Écoute",
    question: "Interrompre régulièrement une victime lors de son récit est :",
    options: [
      "Contraire aux bonnes pratiques",
      "Acceptable pour gagner du temps",
      "Nécessaire pour cadrer",
    ],
    answer: "Contraire aux bonnes pratiques",
    explanation: "L’écoute doit être respectueuse et continue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Violence sexuelle",
    question: "En cas de violences sexuelles, le policier doit :",
    options: [
      "Préserver la parole et orienter vers les soins",
      "Douter systématiquement",
      "Exiger immédiatement des preuves",
    ],
    answer: "Préserver la parole et orienter vers les soins",
    explanation: "La parole de la victime doit être accueillie sans jugement.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Dignité",
    question: "Le respect de la dignité impose notamment :",
    options: [
      "L’absence de propos déplacés",
      "Une distance froide",
      "Une audition rapide",
    ],
    answer: "L’absence de propos déplacés",
    explanation: "La dignité de la victime est une exigence constante.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Handicap",
    question: "Une victime en situation de handicap nécessite :",
    options: [
      "Une adaptation de la prise en charge",
      "Un traitement identique",
      "Un report systématique",
    ],
    answer: "Une adaptation de la prise en charge",
    explanation: "La prise en compte du handicap est indispensable.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Information judiciaire",
    question: "Informer la victime sur les suites judiciaires permet :",
    options: [
      "De réduire l’angoisse",
      "D’orienter la décision du juge",
      "D’accélérer l’enquête",
    ],
    answer: "De réduire l’angoisse",
    explanation: "La transparence rassure la victime.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Neutralité",
    question: "Manifester de l’émotion excessive face à une victime est :",
    options: ["À éviter", "Recommandé", "Sans conséquence"],
    answer: "À éviter",
    explanation: "Le policier doit rester empathique mais professionnel.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Confidentialité",
    question: "Parler d’une affaire de victime en dehors du service est :",
    options: ["Interdit", "Toléré sans nom", "Acceptable entre collègues"],
    answer: "Interdit",
    explanation: "La confidentialité est une obligation absolue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Temps judiciaire",
    question: "Le temps judiciaire doit être expliqué à la victime afin :",
    options: [
      "D’éviter les incompréhensions",
      "De justifier les lenteurs",
      "De décourager les recours",
    ],
    answer: "D’éviter les incompréhensions",
    explanation: "Comprendre la procédure aide la victime.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Stress",
    question: "Face à une victime agressive par stress, le policier doit :",
    options: [
      "Garder calme et professionnalisme",
      "Répondre avec fermeté immédiate",
      "Mettre fin à l’échange",
    ],
    answer: "Garder calme et professionnalisme",
    explanation: "Le stress peut expliquer certaines réactions.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Orientation",
    question: "Orienter une victime vers un service inadapté est :",
    options: [
      "Une faute professionnelle",
      "Une simple erreur",
      "Sans conséquence",
    ],
    answer: "Une faute professionnelle",
    explanation: "L’orientation doit être pertinente et utile.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Prise de plainte",
    question: "Conditionner la prise de plainte à des preuves est :",
    options: ["Illégal", "Recommandé", "Toléré"],
    answer: "Illégal",
    explanation: "La plainte doit être reçue sans condition.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Respect",
    question: "Le vouvoiement envers une victime est :",
    options: ["Obligatoire", "Optionnel", "Réservé aux personnes âgées"],
    answer: "Obligatoire",
    explanation: "Le vouvoiement est une marque de respect.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Égalité",
    question: "Toutes les victimes doivent être traitées :",
    options: [
      "De manière égale",
      "Selon leur situation sociale",
      "Selon la gravité ressentie",
    ],
    answer: "De manière égale",
    explanation: "L’égalité de traitement est un principe fondamental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Service public",
    question: "Refuser d’aider une victime par manque de temps est :",
    options: [
      "Un manquement déontologique",
      "Une décision acceptable",
      "Une consigne hiérarchique",
    ],
    answer: "Un manquement déontologique",
    explanation: "Le service public impose la prise en charge.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Image",
    question: "Une mauvaise prise en charge des victimes nuit :",
    options: [
      "À l’image de l’institution",
      "Uniquement au dossier",
      "À la procédure pénale",
    ],
    answer: "À l’image de l’institution",
    explanation: "Le comportement individuel engage l’institution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Assistance aux victimes — Engagement",
    question: "L’assistance aux victimes traduit :",
    options: [
      "L’engagement du policier envers la population",
      "Une contrainte administrative",
      "Une mission secondaire",
    ],
    answer: "L’engagement du policier envers la population",
    explanation: "Elle fait partie intégrante du rôle du policier.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Accueil du public — Charte Marianne",
    question: "Quel est l’objectif principal de la charte Marianne ?",
    options: [
      "Garantir la qualité de l’accueil dans les services publics",
      "Renforcer l’autorité administrative",
      "Uniformiser les sanctions disciplinaires",
    ],
    answer: "Garantir la qualité de l’accueil dans les services publics",
    explanation:
        "La charte Marianne définit des engagements garantissant la qualité de l’accueil des usagers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Charte Marianne",
    question: "La charte Marianne concerne l’accueil :",
    options: [
      "Physique, téléphonique, par courrier et par courriel",
      "Uniquement physique",
      "Uniquement numérique",
    ],
    answer: "Physique, téléphonique, par courrier et par courriel",
    explanation:
        "La charte s’applique à toutes les formes de contact avec l’usager.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Charte Marianne",
    question: "Faciliter l’accès des usagers dans les services fait partie :",
    options: [
      "Des engagements de la charte Marianne",
      "Des obligations disciplinaires",
      "Du règlement intérieur",
    ],
    answer: "Des engagements de la charte Marianne",
    explanation:
        "La charte Marianne liste des engagements précis, dont l’accès facilité aux services.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Charte Marianne",
    question: "Accueillir les usagers de manière attentive et courtoise est :",
    options: [
      "Un engagement de la charte Marianne",
      "Une simple recommandation",
      "Une obligation judiciaire",
    ],
    answer: "Un engagement de la charte Marianne",
    explanation:
        "La courtoisie et l’attention font partie des principes fondamentaux de l’accueil.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Charte Marianne",
    question:
        "Répondre de manière compréhensible et dans un délai annoncé relève :",
    options: [
      "Des engagements Marianne",
      "Du pouvoir discrétionnaire de l’agent",
      "Des règles pénales",
    ],
    answer: "Des engagements Marianne",
    explanation:
        "Les délais et la clarté des réponses sont des critères de qualité de l’accueil.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Charte Marianne",
    question: "Le traitement systématique des réclamations est :",
    options: [
      "Une obligation issue de la charte Marianne",
      "Facultatif selon le service",
      "Réservé aux services préfectoraux",
    ],
    answer: "Une obligation issue de la charte Marianne",
    explanation: "Toute réclamation doit être prise en compte.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Charte Marianne",
    question: "Recueillir les propositions des usagers permet :",
    options: [
      "D’améliorer la qualité du service public",
      "De contrôler les agents",
      "D’accélérer les procédures judiciaires",
    ],
    answer: "D’améliorer la qualité du service public",
    explanation: "La participation des usagers est un levier d’amélioration.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Référentiel Marianne",
    question: "Le référentiel Marianne est :",
    options: [
      "Une certification de la qualité de l’accueil",
      "Un règlement disciplinaire",
      "Une loi pénale",
    ],
    answer: "Une certification de la qualité de l’accueil",
    explanation:
        "Le référentiel Marianne prolonge la charte par une certification.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Référentiel Marianne",
    question: "La certification Marianne est délivrée par :",
    options: ["Un organisme indépendant", "Le chef de service", "Le préfet"],
    answer: "Un organisme indépendant",
    explanation: "La certification repose sur une évaluation extérieure.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Référentiel Marianne",
    question: "Le référentiel Marianne comprend :",
    options: ["19 engagements", "10 engagements", "25 engagements"],
    answer: "19 engagements",
    explanation:
        "Le référentiel Marianne est structuré autour de 19 engagements.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Référentiel Marianne",
    question: "Les engagements du référentiel Marianne sont structurés en :",
    options: [
      "6 grandes rubriques",
      "5 grandes rubriques",
      "4 grandes rubriques",
    ],
    answer: "6 grandes rubriques",
    explanation: "Le référentiel Marianne est organisé en 6 rubriques.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Référentiel Marianne",
    question: "Les cinq premières rubriques du référentiel concernent :",
    options: [
      "Les engagements vis-à-vis des usagers",
      "La discipline interne",
      "La gestion budgétaire",
    ],
    answer: "Les engagements vis-à-vis des usagers",
    explanation: "Elles reprennent les critères de la charte Marianne.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Référentiel Marianne",
    question: "La dernière rubrique du référentiel Marianne est dédiée :",
    options: [
      "Au pilotage et au suivi interne de la qualité",
      "Aux sanctions disciplinaires",
      "À la formation initiale",
    ],
    answer: "Au pilotage et au suivi interne de la qualité",
    explanation: "Elle concerne l’organisation interne des services.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Police nationale",
    question: "Dans la police nationale, le texte de référence reste :",
    options: [
      "La charte d’accueil du public et d’assistance aux victimes",
      "Le référentiel Marianne uniquement",
      "Le code de procédure pénale",
    ],
    answer: "La charte d’accueil du public et d’assistance aux victimes",
    explanation:
        "Ce texte demeure la référence principale en police nationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Qualité",
    question: "Les enquêtes mystère ont pour objectif :",
    options: [
      "D’évaluer la qualité de l’accueil",
      "De sanctionner immédiatement les agents",
      "De contrôler les procédures judiciaires",
    ],
    answer: "D’évaluer la qualité de l’accueil",
    explanation: "Elles permettent une appréciation extérieure et objective.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Qualité",
    question: "Les enquêtes mystère peuvent prendre la forme :",
    options: [
      "D’appels téléphoniques ou de visites",
      "Uniquement de questionnaires écrits",
      "Uniquement d’audits internes",
    ],
    answer: "D’appels téléphoniques ou de visites",
    explanation: "Les contrôles peuvent être inopinés et variés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Qualité",
    question: "Les enquêtes mystère sont diligentées notamment par :",
    options: [
      "Les services de contrôle du ministère de l’Intérieur",
      "Les syndicats",
      "Les usagers",
    ],
    answer: "Les services de contrôle du ministère de l’Intérieur",
    explanation: "DNPS, IGPN, etc., peuvent diligenter ces contrôles.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Qualité",
    question: "Le respect du référentiel Marianne engage directement :",
    options: [
      "Les services vis-à-vis des usagers",
      "Uniquement les chefs de service",
      "Uniquement l’administration centrale",
    ],
    answer: "Les services vis-à-vis des usagers",
    explanation: "Les engagements sont tournés vers le public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Qualité",
    question: "La qualité de l’accueil participe directement :",
    options: [
      "À l’image de la police nationale",
      "À l’augmentation des effectifs",
      "À la réduction du contentieux pénal",
    ],
    answer: "À l’image de la police nationale",
    explanation: "L’accueil conditionne la confiance du public.",
    difficulty: "Facile",
  ),

  // ===============================
  // ACCUEIL DU PUBLIC – MARIANNE (SÉRIE)
  // ===============================
  QuizQuestion(
    category: "Accueil du public — Charte Marianne",
    question: "Quel est l’objectif principal de la charte Marianne ?",
    options: [
      "Garantir la qualité de l’accueil dans les services publics",
      "Uniformiser les tenues des agents",
      "Réglementer les horaires d’ouverture",
    ],
    answer: "Garantir la qualité de l’accueil dans les services publics",
    explanation:
        "La charte Marianne fixe des engagements de qualité pour l’accueil des usagers.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Charte Marianne",
    question: "La charte Marianne concerne quel type d’accueil ?",
    options: [
      "Uniquement l’accueil physique",
      "Uniquement l’accueil téléphonique",
      "L’accueil physique, téléphonique, courrier et courriel",
    ],
    answer: "L’accueil physique, téléphonique, courrier et courriel",
    explanation: "Elle couvre tous les modes de contact avec l’usager.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Charte Marianne",
    question: "Combien de grands engagements comporte la charte Marianne ?",
    options: ["3", "5", "10"],
    answer: "5",
    explanation: "La charte Marianne repose sur 5 grands engagements.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Charte Marianne",
    question: "Quel engagement vise l’accessibilité des services ?",
    options: [
      "Faciliter l’accès des usagers aux services",
      "Traiter les réclamations",
      "Former les agents",
    ],
    answer: "Faciliter l’accès des usagers aux services",
    explanation: "L’accessibilité est un engagement fondamental de la charte.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Référentiel Marianne",
    question: "Qu’est-ce que le référentiel Marianne ?",
    options: [
      "Une loi pénale",
      "Une certification de la qualité de l’accueil",
      "Un règlement intérieur",
    ],
    answer: "Une certification de la qualité de l’accueil",
    explanation:
        "Le référentiel Marianne est une certification délivrée par un organisme indépendant.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Référentiel Marianne",
    question: "Combien d’engagements comprend le référentiel Marianne ?",
    options: ["10", "15", "19"],
    answer: "19",
    explanation: "Le référentiel Marianne comprend 19 engagements.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Référentiel Marianne",
    question:
        "Combien de grandes rubriques structurent le référentiel Marianne ?",
    options: ["4", "6", "8"],
    answer: "6",
    explanation: "Les engagements sont regroupés en 6 grandes rubriques.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Référentiel Marianne",
    question: "À quoi sert la dernière rubrique du référentiel Marianne ?",
    options: [
      "À sanctionner les agents",
      "Au pilotage et au suivi interne de la qualité",
      "À informer les usagers",
    ],
    answer: "Au pilotage et au suivi interne de la qualité",
    explanation:
        "La dernière rubrique est dédiée au suivi interne des exigences qualité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Accueil du public — Téléphone",
    question:
        "Dans quel délai un appel téléphonique doit-il être pris en charge ?",
    options: [
      "Moins de 10 sonneries",
      "Moins de 5 sonneries",
      "Moins de 15 sonneries",
    ],
    answer: "Moins de 5 sonneries",
    explanation:
        "Le référentiel impose une prise en charge en moins de 5 sonneries.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Courriel",
    question:
        "Quel est le délai maximal pour une première réponse à un courriel ?",
    options: ["48 heures", "5 jours ouvrés", "10 jours ouvrés"],
    answer: "5 jours ouvrés",
    explanation:
        "Une réponse ou une réponse d’attente doit être envoyée sous 5 jours ouvrés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Courriel",
    question: "Que doit recevoir systématiquement l’usager après un courriel ?",
    options: [
      "Une réponse détaillée",
      "Un accusé de réception",
      "Un appel téléphonique",
    ],
    answer: "Un accusé de réception",
    explanation: "Un accusé de réception électronique est obligatoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Courrier postal",
    question: "Quel est le délai maximal de traitement d’un courrier postal ?",
    options: ["7 jours ouvrés", "10 jours ouvrés", "15 jours ouvrés"],
    answer: "15 jours ouvrés",
    explanation:
        "Le traitement doit intervenir dans un délai maximum de 15 jours ouvrés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Public vulnérable",
    question: "Face à une personne en difficulté, l’agent doit :",
    options: [
      "Appliquer une procédure standard",
      "Adapter son comportement",
      "Refuser la prise en charge",
    ],
    answer: "Adapter son comportement",
    explanation:
        "Les agents doivent s’adapter aux difficultés perçues (handicap, âge, anxiété…).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Langage",
    question: "Comment doivent être rédigées les réponses aux usagers ?",
    options: [
      "Dans un langage administratif strict",
      "Dans un langage adapté à la compréhension",
      "Uniquement à l’oral",
    ],
    answer: "Dans un langage adapté à la compréhension",
    explanation: "Les réponses doivent être claires et compréhensibles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Identification",
    question: "Que doivent comporter les réponses écrites aux usagers ?",
    options: [
      "Uniquement la signature du service",
      "Les références de l’agent chargé du dossier",
      "Aucune identification",
    ],
    answer: "Les références de l’agent chargé du dossier",
    explanation: "L’agent en charge du dossier doit être identifiable.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Accessibilité",
    question: "Pour les personnes à mobilité réduite, l’administration doit :",
    options: [
      "Refuser les démarches",
      "Faciliter l’accomplissement des démarches",
      "Reporter systématiquement l’accueil",
    ],
    answer: "Faciliter l’accomplissement des démarches",
    explanation: "L’accessibilité est une obligation de l’accueil public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Contrôles",
    question: "Que sont les « enquêtes mystère » ?",
    options: [
      "Des enquêtes judiciaires",
      "Des contrôles inopinés de la qualité de l’accueil",
      "Des audits financiers",
    ],
    answer: "Des contrôles inopinés de la qualité de l’accueil",
    explanation:
        "Elles évaluent la qualité de l’accueil par appels ou visites.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Ministère de l’Intérieur",
    question: "Qui peut diligenter des enquêtes mystère ?",
    options: [
      "La mairie uniquement",
      "Les services de contrôle du ministère de l’Intérieur",
      "Les usagers",
    ],
    answer: "Les services de contrôle du ministère de l’Intérieur",
    explanation: "IGPN, DNSP, etc., peuvent diligenter ces contrôles.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Police nationale",
    question: "Quel texte reste la référence dans la police nationale ?",
    options: [
      "La charte Marianne uniquement",
      "La charte d’accueil du public et d’assistance aux victimes",
      "Le code pénal",
    ],
    answer: "La charte d’accueil du public et d’assistance aux victimes",
    explanation: "C’est le texte de référence pour la police nationale.",
    difficulty: "Moyen",
  ),

  // ===============================
  // ACCUEIL DU PUBLIC – VICTIMES & DROITS (SÉRIE SUIVANTE)
  // ===============================
  QuizQuestion(
    category: "Accueil du public — Dépôt de plainte",
    question:
        "Les services de police sont-ils tenus de recevoir toutes les plaintes ?",
    options: [
      "Oui, sans exception",
      "Uniquement pendant les heures ouvrables",
      "Uniquement pour les infractions graves",
    ],
    answer: "Oui, sans exception",
    explanation:
        "Les policiers sont tenus de recevoir toutes les plaintes (article 15-3 CPP).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Dépôt de plainte",
    question:
        "Une plainte peut-elle être refusée en raison de l’absence de certificat médical ?",
    options: ["Oui", "Non", "Uniquement pour les violences"],
    answer: "Non",
    explanation:
        "Le recueil d’une plainte ne peut jamais être conditionné à un certificat médical.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Victimes",
    question: "Dans quel type de lieu une victime doit-elle être reçue ?",
    options: [
      "Un lieu ouvert au public",
      "Un lieu sécurisant et confidentiel",
      "Un bureau administratif standard",
    ],
    answer: "Un lieu sécurisant et confidentiel",
    explanation:
        "La confidentialité est essentielle pour libérer la parole de la victime.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Victimes",
    question: "Quel comportement l’agent doit-il impérativement éviter ?",
    options: ["L’écoute active", "Le jugement", "La neutralité"],
    answer: "Le jugement",
    explanation:
        "Les agents doivent faire preuve de neutralité et s’abstenir de tout jugement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Victimes",
    question:
        "Vers qui la victime doit-elle être orientée en priorité si possible ?",
    options: [
      "Un agent d’accueil",
      "Un policier spécialisé",
      "Un agent administratif",
    ],
    answer: "Un policier spécialisé",
    explanation:
        "Les policiers spécialisés (GPF, référents) sont priorisés pour ces situations.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Victimes",
    question:
        "Qui est informé en dehors des heures ouvrables lorsqu’une victime se présente ?",
    options: [
      "Le chef de service",
      "L’officier de police judiciaire de permanence",
      "Le parquet directement",
    ],
    answer: "L’officier de police judiciaire de permanence",
    explanation:
        "L’OPJ de permanence veille à la qualité de la prise en charge.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Droits des victimes",
    question: "Une victime peut-elle être accompagnée lors de sa plainte ?",
    options: [
      "Non",
      "Oui, par une personne majeure de son choix",
      "Uniquement par un avocat",
    ],
    answer: "Oui, par une personne majeure de son choix",
    explanation: "La victime peut être accompagnée par un proche ou un avocat.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Droits des victimes",
    question:
        "La victime peut-elle élire domicile à une autre adresse que la sienne ?",
    options: [
      "Non",
      "Oui, avec l’accord exprès du tiers",
      "Uniquement à l’hôtel",
    ],
    answer: "Oui, avec l’accord exprès du tiers",
    explanation: "Cette mesure protège la victime contre les représailles.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — MCI",
    question: "Dans quel cas une déclaration MCI est-elle utilisée ?",
    options: [
      "Quand la victime refuse plainte ou audition",
      "À chaque passage au commissariat",
      "Pour les infractions graves uniquement",
    ],
    answer: "Quand la victime refuse plainte ou audition",
    explanation: "La MCI est exceptionnelle et doit être motivée.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — MCI",
    question: "Que doit-on mentionner impérativement dans une MCI ?",
    options: [
      "Le refus explicite de la victime",
      "L’avis du maire",
      "Le nom du préfet",
    ],
    answer: "Le refus explicite de la victime",
    explanation: "Le refus doit être clairement consigné dans la déclaration.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Discrimination",
    question: "Qu’est-ce qu’une discrimination ?",
    options: [
      "Un simple conflit",
      "Un traitement défavorable fondé sur un critère interdit",
      "Une mauvaise communication",
    ],
    answer: "Un traitement défavorable fondé sur un critère interdit",
    explanation:
        "La discrimination repose sur des critères définis par la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Discrimination",
    question:
        "Quel article du code pénal définit les critères de discrimination ?",
    options: ["Article 121-1", "Article 225-1", "Article 222-16"],
    answer: "Article 225-1",
    explanation:
        "L’article 225-1 du code pénal énumère les critères de discrimination.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Discrimination",
    question:
        "Combien de critères de discrimination sont répertoriés par la loi ?",
    options: ["10", "15", "24"],
    answer: "24",
    explanation: "La loi recense actuellement 24 critères de discrimination.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Harcèlement moral",
    question: "Le harcèlement moral repose principalement sur :",
    options: [
      "Un acte isolé",
      "Des propos ou comportements répétés",
      "Une infraction financière",
    ],
    answer: "Des propos ou comportements répétés",
    explanation: "Le harcèlement moral est caractérisé par la répétition.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Harcèlement moral",
    question: "Quel est l’effet principal du harcèlement moral ?",
    options: [
      "Une amélioration du climat de travail",
      "Une dégradation des conditions de travail",
      "Un simple désaccord professionnel",
    ],
    answer: "Une dégradation des conditions de travail",
    explanation:
        "Il porte atteinte aux droits, à la dignité et à la santé de la victime.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Harcèlement sexuel",
    question: "Le harcèlement sexuel nécessite-t-il une répétition ?",
    options: ["Toujours", "Jamais", "Pas forcément"],
    answer: "Pas forcément",
    explanation:
        "Une pression grave unique peut suffire à caractériser l’infraction.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Cellule d’écoute",
    question: "Quel est le rôle principal des cellules d’écoute ?",
    options: [
      "Sanctionner les agents",
      "Écouter, analyser et aider à mettre fin aux situations",
      "Remplacer la justice",
    ],
    answer: "Écouter, analyser et aider à mettre fin aux situations",
    explanation:
        "Elles accompagnent victimes et témoins de discriminations ou harcèlement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Cellule d’écoute",
    question:
        "Les cellules d’écoute sont-elles soumises à la confidentialité ?",
    options: ["Non", "Oui", "Uniquement sur demande"],
    answer: "Oui",
    explanation:
        "Elles sont soumises à des obligations de confidentialité et d’impartialité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Signalement",
    question: "Un signalement peut-il être effectué de manière anonyme ?",
    options: ["Non", "Oui", "Uniquement par écrit"],
    answer: "Oui",
    explanation: "Les signalements anonymes sont possibles sous conditions.",
    difficulty: "Moyen",
  ),

  // ===============================
  // ACCUEIL DU PUBLIC – PROCÉDURES & VICTIMES (SÉRIE SUIVANTE)
  // ===============================
  QuizQuestion(
    category: "Accueil du public — Charte Marianne",
    question:
        "Quel est l’un des engagements fondamentaux de la charte Marianne ?",
    options: [
      "Limiter l’accès aux services",
      "Accueillir les usagers de manière attentive et courtoise",
      "Répondre uniquement par écrit",
    ],
    answer: "Accueillir les usagers de manière attentive et courtoise",
    explanation: "La charte Marianne garantit un accueil attentif et courtois.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Charte Marianne",
    question: "La charte Marianne concerne quels types d’accueil ?",
    options: [
      "Uniquement l’accueil physique",
      "Physique, téléphonique, courrier et courriel",
      "Uniquement l’accueil téléphonique",
    ],
    answer: "Physique, téléphonique, courrier et courriel",
    explanation: "La charte couvre tous les modes de contact avec l’usager.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Référentiel Marianne",
    question: "Le référentiel Marianne est :",
    options: [
      "Un simple guide interne",
      "Une certification délivrée par un organisme indépendant",
      "Un règlement disciplinaire",
    ],
    answer: "Une certification délivrée par un organisme indépendant",
    explanation: "Le référentiel Marianne certifie la qualité de l’accueil.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Référentiel Marianne",
    question: "Combien d’engagements comprend le référentiel Marianne ?",
    options: ["10", "15", "19"],
    answer: "19",
    explanation: "Le référentiel Marianne comporte 19 engagements.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Référentiel Marianne",
    question:
        "Combien de grandes rubriques structurent le référentiel Marianne ?",
    options: ["4", "6", "8"],
    answer: "6",
    explanation: "Les engagements sont répartis en 6 grandes rubriques.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Appels téléphoniques",
    question:
        "Quel est le délai maximal de prise en charge d’un appel téléphonique ?",
    options: ["3 sonneries", "5 sonneries", "10 sonneries"],
    answer: "5 sonneries",
    explanation:
        "Le référentiel impose une prise en charge en moins de 5 sonneries.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Courrier électronique",
    question:
        "Quel est le délai maximal pour une première réponse à un courriel ?",
    options: ["48 heures", "5 jours ouvrés", "10 jours ouvrés"],
    answer: "5 jours ouvrés",
    explanation:
        "Une réponse ou une réponse d’attente doit être faite sous 5 jours ouvrés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Courrier postal",
    question: "Quel est le délai maximal de traitement d’un courrier postal ?",
    options: ["10 jours ouvrés", "15 jours ouvrés", "30 jours ouvrés"],
    answer: "15 jours ouvrés",
    explanation: "Le délai maximal est de 15 jours ouvrés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Enquêtes mystère",
    question:
        "À quoi servent les enquêtes mystère dans les services de police ?",
    options: [
      "Sanctionner les agents",
      "Évaluer la qualité de l’accueil",
      "Contrôler les infractions",
    ],
    answer: "Évaluer la qualité de l’accueil",
    explanation: "Elles permettent une appréciation extérieure de l’accueil.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Enquêtes mystère",
    question: "Qui peut diligenter des enquêtes mystère ?",
    options: [
      "Les usagers",
      "Les services de contrôle du ministère de l’Intérieur",
      "Les élus locaux",
    ],
    answer: "Les services de contrôle du ministère de l’Intérieur",
    explanation: "IGPN, DNSP et autres services peuvent les diligenter.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Personnes en difficulté",
    question: "À quelles personnes l’agent doit-il adapter son comportement ?",
    options: [
      "Uniquement aux victimes",
      "Aux personnes en difficulté (handicap, âge, anxiété, langue)",
      "Uniquement aux mineurs",
    ],
    answer: "Aux personnes en difficulté (handicap, âge, anxiété, langue)",
    explanation: "L’accueil doit être adapté à chaque situation particulière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Langage",
    question:
        "Comment doivent être rédigées les réponses apportées aux usagers ?",
    options: [
      "Avec un langage juridique complexe",
      "Dans un langage adapté à la compréhension du destinataire",
      "Uniquement sous forme standardisée",
    ],
    answer: "Dans un langage adapté à la compréhension du destinataire",
    explanation: "Le langage doit être clair et compréhensible.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Mobilité réduite",
    question:
        "Que doivent faciliter les services pour les personnes à mobilité réduite ?",
    options: [
      "L’accès aux locaux",
      "L’accomplissement des démarches",
      "Les deux",
    ],
    answer: "Les deux",
    explanation: "L’accès et les démarches doivent être facilités.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Discrimination",
    question:
        "Un propos sexiste peut-il entraîner une sanction disciplinaire ?",
    options: ["Non", "Oui", "Uniquement s’il est répété"],
    answer: "Oui",
    explanation:
        "Même sans infraction pénale, une sanction disciplinaire est possible.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Sanctions",
    question: "Quelle est la peine maximale pour discrimination pénale ?",
    options: [
      "1 an de prison",
      "3 ans de prison et 45 000 € d’amende",
      "5 ans de prison",
    ],
    answer: "3 ans de prison et 45 000 € d’amende",
    explanation: "C’est la peine prévue par le code pénal.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Harcèlement moral",
    question: "Quelle est la peine maximale pour harcèlement moral ?",
    options: [
      "1 an de prison",
      "2 ans de prison et 30 000 € d’amende",
      "5 ans de prison",
    ],
    answer: "2 ans de prison et 30 000 € d’amende",
    explanation: "Le harcèlement moral est puni de 2 ans d’emprisonnement.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Harcèlement sexuel",
    question: "Quelle est la peine maximale pour harcèlement sexuel ?",
    options: [
      "1 an de prison",
      "2 à 3 ans de prison et jusqu’à 45 000 € d’amende",
      "10 ans de prison",
    ],
    answer: "2 à 3 ans de prison et jusqu’à 45 000 € d’amende",
    explanation: "La peine varie selon les circonstances.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Discipline",
    question: "Quelle sanction disciplinaire maximale peut être prononcée ?",
    options: ["Blâme", "Suspension", "Radiation des cadres ou révocation"],
    answer: "Radiation des cadres ou révocation",
    explanation: "Les sanctions peuvent aller jusqu’à la révocation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Accueil du public — Cellules d’écoute",
    question: "Qui peut saisir une cellule d’écoute ?",
    options: [
      "Uniquement la victime",
      "Uniquement la hiérarchie",
      "Toute personne victime ou témoin",
    ],
    answer: "Toute personne victime ou témoin",
    explanation:
        "Les cellules sont accessibles aux victimes comme aux témoins.",
    difficulty: "Facile",
  ),

  // ===============================
  // ACCUEIL DU PUBLIC – VICTIMES & PROCÉDURES (SUITE)
  // ===============================
  QuizQuestion(
    category: "Accueil du public — Dépôt de plainte",
    question: "Les policiers sont-ils tenus de recevoir toutes les plaintes ?",
    options: [
      "Non, uniquement celles relevant de leur ressort",
      "Oui, sans condition",
      "Uniquement sur rendez-vous",
    ],
    answer: "Oui, sans condition",
    explanation:
        "Article 15-3 du CPP : les policiers et gendarmes sont tenus de recevoir toutes les plaintes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Victime",
    question:
        "Une victime peut-elle être accompagnée lors du dépôt de plainte ?",
    options: [
      "Non",
      "Oui, par une personne majeure de son choix",
      "Uniquement par un avocat",
    ],
    answer: "Oui, par une personne majeure de son choix",
    explanation: "La victime peut être accompagnée d’un proche ou d’un avocat.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Victime",
    question: "Une victime peut-elle demander un interprète ?",
    options: [
      "Non",
      "Oui, obligatoirement si nécessaire",
      "Uniquement si elle est étrangère",
    ],
    answer: "Oui, obligatoirement si nécessaire",
    explanation: "Un interprète doit être mis à disposition si besoin.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Confidentialité",
    question:
        "Dans quel lieu doit être reçue une victime de violences conjugales ?",
    options: [
      "À l’accueil public",
      "Dans un lieu sécurisant et confidentiel",
      "Dans un bureau partagé",
    ],
    answer: "Dans un lieu sécurisant et confidentiel",
    explanation: "La confidentialité est impérative pour la prise de plainte.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Attitude policière",
    question: "Quelle attitude est exigée de l’agent face à une victime ?",
    options: [
      "Neutralité et absence de jugement",
      "Suspicion systématique",
      "Rapidité uniquement",
    ],
    answer: "Neutralité et absence de jugement",
    explanation:
        "L’agent doit rassurer la victime et s’abstenir de tout jugement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Violences conjugales",
    question:
        "Le dépôt de plainte peut-il être refusé faute de certificat médical ?",
    options: ["Oui", "Non", "Uniquement la nuit"],
    answer: "Non",
    explanation: "Le certificat médical n’est jamais une condition préalable.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Violences conjugales",
    question:
        "Vers quels policiers la victime doit-elle être orientée en priorité ?",
    options: [
      "Police secours",
      "Policiers spécialisés (GPF, référents)",
      "Accueil général",
    ],
    answer: "Policiers spécialisés (GPF, référents)",
    explanation:
        "Les policiers spécialisés assurent une prise en charge adaptée.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Permanence",
    question:
        "Qui est informé hors heures ouvrables de la présence d’une victime ?",
    options: [
      "Le chef de service",
      "L’OPJ de permanence",
      "Le parquet uniquement",
    ],
    answer: "L’OPJ de permanence",
    explanation:
        "L’OPJ de permanence veille à la qualité de la prise en charge.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Procédure",
    question:
        "Quel acte est privilégié pour une victime de violences conjugales ?",
    options: [
      "La main courante",
      "La plainte ou l’audition",
      "Le signalement anonyme",
    ],
    answer: "La plainte ou l’audition",
    explanation: "La plainte est fortement encouragée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — MCI",
    question: "Quand peut-on recourir à une déclaration MCI ?",
    options: [
      "Toujours",
      "En cas de refus explicite de plainte",
      "À la demande du policier",
    ],
    answer: "En cas de refus explicite de plainte",
    explanation: "La MCI est une exception strictement encadrée.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — MCI",
    question: "Le refus de plainte doit-il être mentionné en MCI ?",
    options: [
      "Non",
      "Oui obligatoirement",
      "Uniquement en cas de violences graves",
    ],
    answer: "Oui obligatoirement",
    explanation: "Le refus doit être clairement mentionné dans la procédure.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Hospitalier",
    question: "Une plainte peut-elle être recueillie en milieu hospitalier ?",
    options: [
      "Non",
      "Oui, si l’état de la victime l’exige",
      "Uniquement sur réquisition",
    ],
    answer: "Oui, si l’état de la victime l’exige",
    explanation: "Des conventions permettent la plainte à l’hôpital.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Hospitalier",
    question:
        "Qui doit garantir la confidentialité lors d’une plainte à l’hôpital ?",
    options: ["La police uniquement", "L’établissement de santé", "La victime"],
    answer: "L’établissement de santé",
    explanation: "L’hôpital doit fournir un cadre adapté et confidentiel.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Accueil du public — Signalement en ligne",
    question: "Le portail de signalement est accessible :",
    options: ["Uniquement en semaine", "24h/24 et 7j/7", "Uniquement de jour"],
    answer: "24h/24 et 7j/7",
    explanation: "Le portail est accessible en permanence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Signalement en ligne",
    question: "Qui échange avec les victimes via le tchat du portail ?",
    options: ["Des bénévoles", "Des policiers formés", "Des magistrats"],
    answer: "Des policiers formés",
    explanation: "Les policiers du portail sont spécifiquement formés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Urgence",
    question:
        "En cas d’urgence avérée, que doit faire l’opérateur du portail ?",
    options: [
      "Attendre un dépôt de plainte",
      "Déclencher une intervention",
      "Informer uniquement le parquet",
    ],
    answer: "Déclencher une intervention",
    explanation: "L’intervention des forces est immédiate.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Sécurisation",
    question: "Quelle est la priorité lors d’une intervention police secours ?",
    options: [
      "L’audition de l’auteur",
      "La protection de la victime",
      "La rédaction immédiate du PV",
    ],
    answer: "La protection de la victime",
    explanation: "La sécurité de la victime est prioritaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Hébergement",
    question: "Quel numéro peut être contacté pour un hébergement d’urgence ?",
    options: ["17", "115", "3919"],
    answer: "115",
    explanation: "Le 115 permet l’hébergement d’urgence.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Effets personnels",
    question:
        "La police peut-elle accompagner une victime pour récupérer ses effets ?",
    options: [
      "Non",
      "Oui, sous conditions opérationnelles",
      "Uniquement sur décision judiciaire",
    ],
    answer: "Oui, sous conditions opérationnelles",
    explanation: "L’accompagnement est possible pour la sécurité.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Données personnelles",
    question: "Selon l’article R. 434-21, le policier doit respecter :",
    options: [
      "La vie privée des personnes",
      "Uniquement la confidentialité judiciaire",
      "Les consignes locales uniquement",
    ],
    answer: "La vie privée des personnes",
    explanation:
        "Article R. 434-21 : respect et préservation de la vie privée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Données personnelles",
    question: "L’utilisation des fichiers de police doit être :",
    options: [
      "Motivée par des nécessités de service",
      "Libre si l’agent est habilité",
      "Possible à titre personnel",
    ],
    answer: "Motivée par des nécessités de service",
    explanation:
        "Les fichiers ne peuvent être consultés que pour les besoins du service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Données personnelles",
    question: "Consulter un fichier par curiosité personnelle est :",
    options: ["Autorisé", "Toléré sans diffusion", "Interdit"],
    answer: "Interdit",
    explanation:
        "Toute consultation injustifiée constitue un manquement déontologique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Données personnelles",
    question: "Partager son code d’accès à une application est :",
    options: [
      "Autorisé entre collègues",
      "Interdit",
      "Autorisé en cas d’urgence",
    ],
    answer: "Interdit",
    explanation: "Le partage des codes est expressément proscrit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Données personnelles",
    question: "Créer un fichier nominatif personnel est :",
    options: [
      "Autorisé avec prudence",
      "Interdit hors cadre légal",
      "Toléré temporairement",
    ],
    answer: "Interdit hors cadre légal",
    explanation: "Toute base de données non déclarée est interdite.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Sources humaines",
    question: "Le recours à des informateurs doit respecter :",
    options: [
      "Les règles propres à chaque force",
      "L’initiative personnelle",
      "La seule efficacité opérationnelle",
    ],
    answer: "Les règles propres à chaque force",
    explanation:
        "Article R. 434-22 : respect strict des règles d’exécution du service.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Sources humaines",
    question:
        "Une relation non encadrée avec un informateur peut être analysée comme :",
    options: [
      "Une relation professionnelle classique",
      "Une relation privée",
      "Une relation judiciaire protégée",
    ],
    answer: "Une relation privée",
    explanation: "Hors cadre, la relation est considérée comme privée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Contrôle",
    question: "La police nationale est soumise au contrôle :",
    options: [
      "Uniquement interne",
      "Des autorités prévues par la loi",
      "Uniquement du parquet",
    ],
    answer: "Des autorités prévues par la loi",
    explanation: "Article R. 434-23 : contrôles internes et externes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Contrôle judiciaire",
    question: "Les missions judiciaires sont contrôlées par :",
    options: [
      "L’autorité administrative",
      "L’autorité judiciaire",
      "Le Défenseur des droits",
    ],
    answer: "L’autorité judiciaire",
    explanation: "Le CPP place la PJ sous contrôle judiciaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Défenseur des droits",
    question: "Le Défenseur des droits peut :",
    options: [
      "Engager directement une sanction",
      "Saisir l’autorité disciplinaire",
      "Prononcer une peine pénale",
    ],
    answer: "Saisir l’autorité disciplinaire",
    explanation: "Article R. 434-24 : pouvoir de saisine disciplinaire.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Défenseur des droits",
    question: "Un policier convoqué par le Défenseur des droits doit :",
    options: [
      "Refuser le secret professionnel",
      "Déférer à la convocation",
      "Demander l’autorisation du parquet",
    ],
    answer: "Déférer à la convocation",
    explanation: "Le policier doit coopérer avec le Défenseur des droits.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Inspection",
    question: "Le policier doit faciliter :",
    options: [
      "Les opérations de contrôle",
      "Uniquement les contrôles judiciaires",
      "Uniquement les inspections internes",
    ],
    answer: "Les opérations de contrôle",
    explanation: "Article R. 434-25 : obligation de coopération.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Inspection",
    question: "L’IGPN est un organe :",
    options: ["De contrôle externe", "De contrôle interne", "Judiciaire"],
    answer: "De contrôle interne",
    explanation: "L’IGPN participe au contrôle interne de la police.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Contrôle des pairs",
    question: "Le respect du code de déontologie relève :",
    options: [
      "Uniquement de la hiérarchie",
      "Des pairs individuellement et collectivement",
      "Du seul parquet",
    ],
    answer: "Des pairs individuellement et collectivement",
    explanation: "Article R. 434-26 : contrôle par les pairs.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Contrôle des pairs",
    question: "Le silence face à un manquement déontologique vaut :",
    options: ["Neutralité", "Consentement", "Protection du collègue"],
    answer: "Consentement",
    explanation: "Le silence peut engager la responsabilité collective.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Sanctions",
    question: "Un manquement déontologique expose à :",
    options: [
      "Une sanction disciplinaire",
      "Un rappel oral uniquement",
      "Une sanction pénale automatique",
    ],
    answer: "Une sanction disciplinaire",
    explanation: "Article R. 434-27 : sanctions disciplinaires possibles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Sanctions",
    question: "Les sanctions disciplinaires sont :",
    options: [
      "Indépendantes des sanctions pénales",
      "Toujours cumulatives",
      "Subordonnées au jugement pénal",
    ],
    answer: "Indépendantes des sanctions pénales",
    explanation: "Disciplinaire et pénal sont distincts.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Responsabilité",
    question: "Un même comportement peut constituer :",
    options: [
      "Un seul manquement",
      "Plusieurs manquements déontologiques",
      "Aucun manquement",
    ],
    answer: "Plusieurs manquements déontologiques",
    explanation: "Un acte peut violer plusieurs obligations.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Police nationale",
    question: "Selon l’article R. 434-28, la fonction de policier implique :",
    options: [
      "Des devoirs et des risques",
      "Uniquement des obligations hiérarchiques",
      "Des avantages statutaires",
    ],
    answer: "Des devoirs et des risques",
    explanation:
        "Article R. 434-28 : la fonction de policier comporte des devoirs et des risques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Police nationale",
    question: "Le policier honore la mémoire de ceux qui ont péri :",
    options: [
      "Uniquement lors des cérémonies officielles",
      "Dans l’exercice de missions de sécurité intérieure",
      "En dehors du service uniquement",
    ],
    answer: "Dans l’exercice de missions de sécurité intérieure",
    explanation:
        "Article R. 434-28 : devoir de mémoire envers les policiers morts en service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Police nationale",
    question: "L’absence injustifiée lors d’une minute de silence constitue :",
    options: [
      "Un manquement déontologique",
      "Un simple oubli sans conséquence",
      "Une faute pénale",
    ],
    answer: "Un manquement déontologique",
    explanation: "L’absence sans motif valable est un comportement fautif.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Devoir de réserve",
    question: "Selon l’article R. 434-29, le policier est tenu à :",
    options: [
      "L’obligation de neutralité",
      "La liberté totale d’expression",
      "La neutralité uniquement en service",
    ],
    answer: "L’obligation de neutralité",
    explanation: "Le devoir de réserve impose neutralité et loyauté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Devoir de réserve",
    question: "En service, le policier peut exprimer ses convictions :",
    options: ["Religieuses", "Politiques", "Aucune"],
    answer: "Aucune",
    explanation: "Toute expression de convictions est interdite en service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Devoir de réserve",
    question: "Hors service, le policier s’exprime librement :",
    options: [
      "Sans aucune limite",
      "Dans les limites du devoir de réserve",
      "Uniquement anonymement",
    ],
    answer: "Dans les limites du devoir de réserve",
    explanation: "Le devoir de réserve s’applique aussi hors service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Devoir de réserve",
    question: "Tenir des propos irrespectueux sur une autorité hiérarchique :",
    options: [
      "Est autorisé hors service",
      "Constitue un manquement",
      "Relève de la liberté d’opinion",
    ],
    answer: "Constitue un manquement",
    explanation: "Les propos irrespectueux portent atteinte à l’institution.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Devoir de réserve",
    question:
        "L’affichage de documents politiques sur le lieu de travail est :",
    options: ["Autorisé", "Toléré", "Interdit"],
    answer: "Interdit",
    explanation:
        "Toute manifestation politique est prohibée sur le lieu de service.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Disponibilité",
    question: "Selon l’article R. 434-30, le policier doit être :",
    options: [
      "Disponible à tout moment",
      "Disponible uniquement en service",
      "Disponible sur convocation écrite",
    ],
    answer: "Disponible à tout moment",
    explanation: "La disponibilité est une obligation statutaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Disponibilité",
    question: "Éteindre volontairement son téléphone pour éviter un rappel :",
    options: [
      "Est autorisé hors service",
      "Constitue un manquement",
      "Relève de la vie privée",
    ],
    answer: "Constitue un manquement",
    explanation: "L’indisponibilité volontaire est fautive.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Disponibilité",
    question: "Le changement de résidence doit être :",
    options: [
      "Tenue secret",
      "Signalé à la hiérarchie",
      "Déclaré uniquement à l’administration fiscale",
    ],
    answer: "Signalé à la hiérarchie",
    explanation: "La hiérarchie doit pouvoir joindre l’agent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Disponibilité",
    question: "Une absence injustifiée lors d’un contrôle administratif est :",
    options: ["Tolérée", "Fautive", "Sans conséquence"],
    answer: "Fautive",
    explanation: "L’agent doit se soumettre aux contrôles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Synthèse",
    question: "Le devoir de réserve vise principalement à protéger :",
    options: [
      "La liberté individuelle de l’agent",
      "L’image et la neutralité de l’institution",
      "Le confort personnel du policier",
    ],
    answer: "L’image et la neutralité de l’institution",
    explanation:
        "Il garantit la crédibilité et la neutralité du service public.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Synthèse",
    question: "La disponibilité du policier est liée :",
    options: [
      "À la continuité du service public",
      "À un choix personnel",
      "À l’ancienneté",
    ],
    answer: "À la continuité du service public",
    explanation: "La mission impose une disponibilité permanente.",
    difficulty: "Moyen",
  ),
  QuizQuestion(
    category: "Déontologie — Gendarmerie nationale",
    question: "Selon l’article R. 434-31, l’état militaire exige notamment :",
    options: [
      "Discipline, disponibilité et neutralité",
      "Liberté d’expression renforcée",
      "Autonomie hiérarchique",
    ],
    answer: "Discipline, disponibilité et neutralité",
    explanation:
        "Article R. 434-31 : l’état militaire impose discipline, disponibilité, loyalisme et neutralité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie nationale",
    question: "L’état militaire peut exiger :",
    options: [
      "Un sacrifice suprême",
      "Un engagement uniquement moral",
      "Une disponibilité limitée",
    ],
    answer: "Un sacrifice suprême",
    explanation:
        "L’article R. 434-31 évoque explicitement le sacrifice suprême.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie nationale",
    question: "Les devoirs et sujétions du gendarme méritent :",
    options: [
      "Le respect des citoyens",
      "Une reconnaissance interne uniquement",
      "Une compensation financière",
    ],
    answer: "Le respect des citoyens",
    explanation:
        "L’article R. 434-31 souligne la considération due par la Nation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie nationale",
    question: "Les honneurs militaires sont rendus aux gendarmes :",
    options: [
      "Décédés hors service uniquement",
      "Victimes du devoir ou du port de l’uniforme",
      "Ayant atteint un certain grade",
    ],
    answer: "Victimes du devoir ou du port de l’uniforme",
    explanation:
        "Article R. 434-31 : hommage aux victimes du devoir ou du port de l’uniforme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie nationale",
    question:
        "Refuser de recevoir une personne peu avant la fermeture administrative :",
    options: [
      "Est autorisé",
      "Constitue un comportement fautif",
      "Relève de l’organisation locale",
    ],
    answer: "Constitue un comportement fautif",
    explanation: "Ce refus est cité comme exemple de comportement fautif.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie nationale",
    question: "L’exécution partielle d’une mission sans en rendre compte est :",
    options: ["Tolérée en cas d’urgence", "Fautive", "Autorisé hors service"],
    answer: "Fautive",
    explanation: "L’exécution incomplète sans compte rendu est un manquement.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Devoir de réserve (GN)",
    question:
        "Selon l’article R. 434-32, les gendarmes peuvent exprimer leurs opinions :",
    options: ["En service", "Hors service avec réserve", "Sans aucune limite"],
    answer: "Hors service avec réserve",
    explanation: "Le devoir de réserve découle de l’état militaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Devoir de réserve (GN)",
    question:
        "Exprimer une opinion politique en faisant état de son statut militaire est :",
    options: ["Autorisé", "Interdit", "Toléré hors service"],
    answer: "Interdit",
    explanation: "C’est un comportement fautif explicitement mentionné.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Dialogue interne",
    question: "Les gendarmes disposent d’instances de concertation :",
    options: [
      "Uniquement au niveau local",
      "Au niveau national et local",
      "Uniquement syndicales",
    ],
    answer: "Au niveau national et local",
    explanation: "CFMG et CSFM permettent l’expression encadrée.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Dialogue interne",
    question: "Favoriser le dialogue interne est considéré comme :",
    options: [
      "Un comportement positif",
      "Une obligation pénale",
      "Une option personnelle",
    ],
    answer: "Un comportement positif",
    explanation: "La participation constructive est encouragée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Autres textes",
    question: "Selon l’article R. 434-33, le gendarme est soumis :",
    options: [
      "Uniquement au code de déontologie",
      "Au code de la défense et au statut militaire",
      "Uniquement au code pénal",
    ],
    answer: "Au code de la défense et au statut militaire",
    explanation: "Le gendarme est soumis au statut général des militaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie nationale",
    question: "L’obligation de logement en gendarmerie est liée :",
    options: [
      "À une convenance personnelle",
      "À la nécessité absolue de service",
      "À l’ancienneté",
    ],
    answer: "À la nécessité absolue de service",
    explanation: "Le logement conditionne la disponibilité permanente.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Gendarmerie nationale",
    question: "Cette obligation de logement vise principalement :",
    options: [
      "La discipline",
      "La couverture permanente du territoire",
      "La vie collective",
    ],
    answer: "La couverture permanente du territoire",
    explanation: "Elle garantit la disponibilité opérationnelle.",
    difficulty: "Moyen",
  ),

  QuizQuestion(
    category: "Déontologie — Comparatif",
    question: "Le devoir de réserve est plus strict pour :",
    options: [
      "Les policiers",
      "Les gendarmes",
      "Les deux de manière identique",
    ],
    answer: "Les gendarmes",
    explanation: "Le devoir de réserve est renforcé par l’état militaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Comparatif",
    question: "La neutralité politique est exigée :",
    options: [
      "Uniquement en service",
      "En service et hors service selon le statut",
      "Uniquement hors service",
    ],
    answer: "En service et hors service selon le statut",
    explanation: "Neutralité renforcée pour les militaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Déontologie — Protection",
    question: "Le code de déontologie est aussi :",
    options: [
      "Uniquement répressif",
      "Protecteur pour les agents",
      "Sans valeur juridique",
    ],
    answer: "Protecteur pour les agents",
    explanation: "Il protège l’agent en encadrant son action.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Accueil du public — Information",
    question: "Le plaignant doit être informé :",
    options: [
      "Des suites données à sa plainte",
      "Uniquement du dépôt",
      "Uniquement à sa demande",
    ],
    answer: "Des suites données à sa plainte",
    explanation:
        "Article 7 : information sur les actes entrepris et leurs résultats.",
    difficulty: "Facile",
  ),
];

class QuiAccueilGpx extends StatefulWidget {
  static const String routeName = '/gpx/institution/accueil_public/quiz';
  final String uid;
  final String email;

  const QuiAccueilGpx({super.key, required this.uid, required this.email});

  @override
  State<QuiAccueilGpx> createState() => _QuiAccueilGpxState();
}

class _QuiAccueilGpxState extends State<QuiAccueilGpx>
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

    final pool = useAll
        ? questionAccueilPublic
        : questionAccueilPublic
              .where((q) => q.difficulty == _selectedDifficulty)
              .toList();

    _qs = List<QuizQuestion>.from(pool);
    _qs.shuffle(_rng);

    // ✅ Options = List<String>
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
            'module_name': 'Accueil Public',
            'quiz_name': 'Quiz- Accueil Public',
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
      await _sb.from('quiz_accueil_public').insert({
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
      debugPrint('❌ quiz_accueil_public insert failed: $e');
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? Colors.white : _Brand.textDark;

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

          // ✅ Image de la question (galon / grade)
          if (question.questionImageAsset != null &&
              question.questionImageAsset!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Container(
                height: 160,
                padding: const EdgeInsets.all(12),
                color: isDark
                    ? Colors.white.withAlpha(18)
                    : const Color(0xFFF2F3F6),
                child: Image.asset(
                  question.questionImageAsset!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // ✅ Options (String)
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

  // ✅ nouveau : image optionnelle
  final String? assetImage;

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
    this.assetImage,
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

    Widget? thumb() {
      if (assetImage == null || assetImage!.isEmpty) return null;

      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 54,
          height: 54,
          padding: const EdgeInsets.all(6),
          color: isDark ? Colors.white.withAlpha(18) : const Color(0xFFF2F3F6),
          child: Image.asset(assetImage!, fit: BoxFit.contain),
        ),
      );
    }

    final t = thumb();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              dot(selected || correct || wrong),
              const SizedBox(width: 14),

              if (t != null) ...[t, const SizedBox(width: 12)],

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
