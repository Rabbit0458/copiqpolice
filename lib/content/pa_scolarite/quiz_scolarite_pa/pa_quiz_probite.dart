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

final List<QuizQuestion> questionProbite = [
  const QuizQuestion(
    category: "Concussion — Définition",
    question: "La concussion consiste notamment à :",
    options: [
      "Exiger ou recevoir une somme publique non due ou excédant ce qui est dû",
      "Accepter un cadeau pour accomplir un acte de la fonction",
      "Abuser de son influence pour obtenir un marché",
    ],
    answer:
        "Exiger ou recevoir une somme publique non due ou excédant ce qui est dû",
    explanation:
        "La concussion porte sur des droits, contributions, impôts ou taxes publics indus.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-10",
    question:
        "Vrai/Faux : la concussion est prévue par l’article 432-10 du Code pénal.",
    options: ["Vrai", "Faux", "Ça dépend de l’auteur"],
    answer: "Vrai",
    explanation:
        "La concussion est prévue et réprimée par l’article 432-10 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-10",
    question: "La concussion consiste notamment à :",
    options: [
      "Recevoir, exiger ou ordonner de percevoir une somme non due ou excédant ce qui est dû",
      "Solliciter un avantage pour accomplir un acte de la fonction",
      "Abuser de son influence pour obtenir une décision favorable",
    ],
    answer:
        "Recevoir, exiger ou ordonner de percevoir une somme non due ou excédant ce qui est dû",
    explanation:
        "La concussion porte sur une perception indue à titre de droits/contributions/impôts/taxes publics.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-10",
    question: "Auteur possible de concussion :",
    options: [
      "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
      "Tout particulier",
      "Uniquement un élu local",
    ],
    answer:
        "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
    explanation:
        "Le texte vise un auteur particulier : dépositaire de l’autorité publique ou mission de service public.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-10",
    question: "Les moyens utilisés pour percevoir la somme indue :",
    options: [
      "Importent peu (pas besoin de menaces/manœuvres)",
      "Doivent être des menaces",
      "Doivent être des manœuvres frauduleuses",
    ],
    answer: "Importent peu (pas besoin de menaces/manœuvres)",
    explanation:
        "Ce qui compte est l’illégalité de la perception, pas le moyen employé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-10",
    question: "La « somme » peut être :",
    options: [
      "De l’argent ou une prestation en nature",
      "Uniquement de l’argent",
      "Uniquement un chèque",
    ],
    answer: "De l’argent ou une prestation en nature",
    explanation:
        "La notion de somme est large et peut inclure des prestations en nature.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-10",
    question:
        "Vrai/Faux : la somme peut être partiellement indue (excéder ce qui est dû).",
    options: ["Vrai", "Faux", "Uniquement si taxe locale"],
    answer: "Vrai",
    explanation:
        "La somme est indue si non prévue ou si elle excède ce qui est dû.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-10",
    question: "La concussion peut aussi consister à :",
    options: [
      "Accorder illégalement une exonération ou une franchise d’impôts/taxes publics",
      "Signer un contrat public irrégulier",
      "Refuser une prestation administrative",
    ],
    answer:
        "Accorder illégalement une exonération ou une franchise d’impôts/taxes publics",
    explanation: "L’alinéa 2 vise l’exonération/franchise illégale.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-10",
    question: "Élément moral de la concussion :",
    options: [
      "Conscience que la somme n’était pas due ou excédait ce qui était dû",
      "Intention d’enrichissement obligatoire",
      "Préjudice effectif obligatoire",
    ],
    answer:
        "Conscience que la somme n’était pas due ou excédait ce qui était dû",
    explanation:
        "Les mobiles sont indifférents ; la conscience du caractère indu est centrale.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-10",
    question:
        "Vrai/Faux : une erreur de fait/droit peut faire disparaître l’intention.",
    options: ["Vrai", "Faux", "Jamais"],
    answer: "Vrai",
    explanation:
        "Si la perception résulte d’une erreur ou d’une mauvaise interprétation, l’intention peut manquer.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-10",
    question: "Peines principales de la concussion (432-10) :",
    options: [
      "5 ans d’emprisonnement et 500 000 € d’amende",
      "10 ans d’emprisonnement et 1 000 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 500 000 € d’amende",
    explanation:
        "432-10 : 5 ans + 500 000 € (pouvant être porté au double du produit).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-10",
    question:
        "Vrai/Faux : la concussion prévoit des circonstances aggravantes spécifiques.",
    options: ["Vrai", "Faux", "Seulement en bande organisée"],
    answer: "Faux",
    explanation: "La fiche indique : AUCUNE circonstance aggravante.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-10",
    question: "Vrai/Faux : la tentative de concussion est punissable.",
    options: ["Vrai", "Faux", "Uniquement pour l’alinéa 2"],
    answer: "Vrai",
    explanation: "La tentative est prévue par l’alinéa 3 de l’article 432-10.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Concussion",
    question: "La concussion se caractérise surtout par :",
    options: [
      "Le caractère illégal de la perception",
      "La violence exercée sur la victime",
      "L’existence d’un pacte écrit",
    ],
    answer: "Le caractère illégal de la perception",
    explanation:
        "On compare ce qui est perçu/réclamé à ce que les textes autorisent.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège concours — Concussion",
    question:
        "Un régisseur exige 20€ alors que le tarif légal est 10€. Qualification :",
    options: [
      "Concussion (432-10)",
      "Corruption passive (432-11)",
      "Trafic d’influence (432-11 al.3)",
    ],
    answer: "Concussion (432-10)",
    explanation:
        "Somme excédant ce qui est dû = perception indue (concussion).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Concussion",
    question:
        "Concussion : l’infraction peut être constituée si la somme indue est :",
    options: ["Perçue", "Exigée", "Ordonnée à percevoir"],
    answer: "Ordonnée à percevoir",
    explanation: "Le texte vise recevoir, exiger OU ordonner de percevoir.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège concours — Concussion",
    question:
        "Si un supérieur ordonne une perception indue et le subordonné exécute sciemment :",
    options: [
      "Supérieur = auteur principal, subordonné = complice",
      "Les deux sont toujours auteurs principaux",
      "Aucun n’est punissable",
    ],
    answer: "Supérieur = auteur principal, subordonné = complice",
    explanation:
        "Celui qui ordonne est puni comme concussionnaire ; le subordonné peut être complice s’il sait.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Révisions rapides — 432-11",
    question: "La corruption passive est réprimée par :",
    options: ["Article 432-11 CP", "Article 432-10 CP", "Article 441-1 CP"],
    answer: "Article 432-11 CP",
    explanation: "Corruption passive : article 432-11 al.1 et 2 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-11",
    question: "La corruption passive consiste à :",
    options: [
      "Solliciter ou agréer sans droit un avantage pour accomplir/s’abstenir d’un acte de la fonction",
      "Percevoir une taxe non prévue par la loi",
      "Abuser d’une influence supposée contre paiement",
    ],
    answer:
        "Solliciter ou agréer sans droit un avantage pour accomplir/s’abstenir d’un acte de la fonction",
    explanation:
        "Pacte de corruption : avantage ↔ acte/abstention/acte facilité par la fonction.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-11",
    question: "La corruption est dite « passive » lorsque l’auteur est :",
    options: [
      "Un agent public (dépositaire/mission de service public/mandat électif)",
      "Un particulier",
      "Un témoin",
    ],
    answer:
        "Un agent public (dépositaire/mission de service public/mandat électif)",
    explanation:
        "La qualification active/passive dépend de la qualité de l’auteur.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-11",
    question: "La corruption passive peut être constituée :",
    options: [
      "Même si l’acte promis n’est pas exécuté",
      "Uniquement si l’acte est exécuté",
      "Uniquement si la somme est versée en cash",
    ],
    answer: "Même si l’acte promis n’est pas exécuté",
    explanation: "Le pacte suffit : suivi d’exécution indifférent.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-11",
    question: "« À tout moment » signifie que l’accord peut être :",
    options: ["Avant ou après l’acte", "Uniquement avant", "Uniquement après"],
    answer: "Avant ou après l’acte",
    explanation: "Gratification postérieure possible (remerciement).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-11",
    question: "L’avantage en corruption passive peut être :",
    options: [
      "Offres, promesses, dons, présents, avantages quelconques",
      "Uniquement un prêt bancaire",
      "Uniquement un avantage fiscal",
    ],
    answer: "Offres, promesses, dons, présents, avantages quelconques",
    explanation: "Interprétation large des avantages.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-11",
    question: "L’avantage peut bénéficier :",
    options: [
      "À l’auteur ou à un tiers",
      "Uniquement à l’auteur",
      "Uniquement à la famille",
    ],
    answer: "À l’auteur ou à un tiers",
    explanation: "Le texte vise « pour elle-même ou pour autrui ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-11",
    question: "Élément moral de la corruption passive :",
    options: [
      "Conscience d’agir en violation du devoir de probité + volonté d’obtenir un avantage",
      "Erreur de bonne foi suffisante",
      "Préjudice effectif obligatoire",
    ],
    answer:
        "Conscience d’agir en violation du devoir de probité + volonté d’obtenir un avantage",
    explanation:
        "Il faut que l’agent sache la contrepartie et agisse sciemment.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-11",
    question: "Circonstance aggravante prévue :",
    options: ["Bande organisée", "Réunion", "Arme"],
    answer: "Bande organisée",
    explanation: "432-11 al.4 : bande organisée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-11",
    question: "Peines corruption passive simple :",
    options: [
      "10 ans et 1 000 000 €",
      "5 ans et 500 000 €",
      "3 ans et 45 000 €",
    ],
    answer: "10 ans et 1 000 000 €",
    explanation: "432-11 : 10 ans + 1 000 000 € (double du produit possible).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-11",
    question: "Peines corruption passive aggravée (bande organisée) :",
    options: [
      "10 ans et 2 000 000 €",
      "15 ans et 3 000 000 €",
      "7 ans et 100 000 €",
    ],
    answer: "10 ans et 2 000 000 €",
    explanation: "432-11 al.4 : 10 ans + 2 000 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-11",
    question: "Vrai/Faux : tentative de corruption passive punissable.",
    options: ["Vrai", "Faux", "Seulement en bande organisée"],
    answer: "Faux",
    explanation: "La fiche indique : TENTATIVE : NON.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Corruption",
    question:
        "Un policier accepte de l’argent pour ne pas dresser PV. Qualification :",
    options: [
      "Corruption passive (432-11)",
      "Concussion (432-10)",
      "Trafic d’influence (432-11 al.3)",
    ],
    answer: "Corruption passive (432-11)",
    explanation: "Avantage contre abstention d’un acte de la fonction.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Piège concours — Corruption",
    question:
        "Un agent reçoit un cadeau après l’acte, sans demande explicite, mais en le sachant contrepartie. Qualification :",
    options: [
      "Corruption passive",
      "Aucune infraction car après",
      "Concussion",
    ],
    answer: "Corruption passive",
    explanation: "Pacte possible postérieurement ; « à tout moment ». ",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège concours — Corruption vs Concussion",
    question:
        "Un agent exige un « supplément » non prévu par la loi pour une formalité. Qualification prioritaire :",
    options: ["Concussion", "Corruption passive", "Trafic d’influence"],
    answer: "Concussion",
    explanation:
        "Perception indue de droits/taxes publics (pas un avantage offert pour acte, mais une somme exigée indûment).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Révisions rapides — 432-11 al.3",
    question: "Le trafic d’influence (agent public) est défini/réprimé par :",
    options: [
      "Article 432-11 al.3 CP",
      "Article 432-10 CP",
      "Article 434-5 CP",
    ],
    answer: "Article 432-11 al.3 CP",
    explanation: "Trafic d’influence : 432-11 alinéa 3 CP (selon ta fiche).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-11 al.3",
    question: "Trafic d’influence : l’influence peut être :",
    options: ["Réelle ou supposée", "Uniquement réelle", "Uniquement supposée"],
    answer: "Réelle ou supposée",
    explanation: "L’influence peut être réelle ou supposée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-11 al.3",
    question: "Le trafic d’influence vise l’obtention de :",
    options: [
      "Distinctions, emplois, marchés, décisions favorables",
      "PV annulé par l’agent compétent",
      "Taxe locale réduite par barème légal",
    ],
    answer: "Distinctions, emplois, marchés, décisions favorables",
    explanation:
        "L’auteur abuse de son influence pour faire obtenir une décision favorable d’une autorité/administration.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-11 al.3",
    question: "Élément moral du trafic d’influence :",
    options: [
      "Conscience de violer le devoir de probité + volonté d’obtenir un avantage",
      "Erreur de texte suffit",
      "Préjudice effectif obligatoire",
    ],
    answer:
        "Conscience de violer le devoir de probité + volonté d’obtenir un avantage",
    explanation:
        "Il faut que l’agent sache la contrepartie et agisse sciemment.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-11 al.3",
    question: "Peines trafic d’influence simple :",
    options: [
      "10 ans et 1 000 000 €",
      "5 ans et 500 000 €",
      "3 ans et 45 000 €",
    ],
    answer: "10 ans et 1 000 000 €",
    explanation:
        "Trafic d’influence : mêmes peines que la corruption passive simple (fiche).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-11 al.3",
    question: "Aggravation trafic d’influence :",
    options: ["Bande organisée", "Réunion", "Arme"],
    answer: "Bande organisée",
    explanation:
        "432-11 al.4 : aggravation en bande organisée (aussi pour trafic d’influence).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — 432-11 al.3",
    question: "Vrai/Faux : tentative de trafic d’influence punissable.",
    options: ["Vrai", "Faux", "Seulement si influence réelle"],
    answer: "Faux",
    explanation: "La fiche indique : TENTATIVE : NON.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Trafic d’influence",
    question:
        "Un élu est payé pour « appeler quelqu’un » afin d’obtenir un poste. Qualification :",
    options: ["Trafic d’influence", "Corruption passive", "Concussion"],
    answer: "Trafic d’influence",
    explanation:
        "Abus d’influence réelle/supposée en vue de faire obtenir un emploi (contre avantage).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège concours — Trafic d’influence",
    question: "En trafic d’influence, la décision obtenue peut être :",
    options: [
      "Régulière",
      "Forcément illégale",
      "Forcément frauduleuse au fond",
    ],
    answer: "Régulière",
    explanation:
        "Même régulière : ce sont les moyens d’influence irréguliers qui constituent l’infraction.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège concours — Trafic d’influence",
    question:
        "Vrai/Faux : trafic d’influence = pacte d’avantage pour accomplir un acte de la fonction.",
    options: ["Vrai", "Faux", "Uniquement si acte administratif"],
    answer: "Faux",
    explanation:
        "Ça décrit plutôt la corruption. Trafic = abus d’influence pour obtenir une décision d’une autorité/administration.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas — Distinction (ultra-piège)",
    question:
        "Un agent public propose : « Donne-moi 200€ et je ne verbalise pas ». Qualification la plus juste :",
    options: ["Corruption passive", "Concussion", "Trafic d’influence"],
    answer: "Corruption passive",
    explanation:
        "Avantage contre abstention d’un acte de la fonction : corruption passive.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — Distinction (ultra-piège)",
    question:
        "Un agent exige 50€ « frais obligatoires » inventés pour délivrer un document. Qualification :",
    options: ["Concussion", "Corruption passive", "Trafic d’influence"],
    answer: "Concussion",
    explanation:
        "Perception indue à titre de droits/taxes publics (même si appelée « frais »).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — Distinction (ultra-piège)",
    question:
        "Un agent est payé pour intervenir auprès d’une autre administration afin d’obtenir une décision favorable. Qualification :",
    options: ["Trafic d’influence", "Concussion", "Corruption passive"],
    answer: "Trafic d’influence",
    explanation:
        "Monnayer une influence auprès d’une autorité/administration publique.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — Distinction (ultra-piège)",
    question:
        "Un agent public accepte un cadeau pour transmettre des infos obtenues grâce à l’accès aux dossiers. Qualification :",
    options: [
      "Corruption passive (acte facilité)",
      "Concussion",
      "Trafic d’influence",
    ],
    answer: "Corruption passive (acte facilité)",
    explanation:
        "Avantage contre acte facilité par la fonction (accès aux infos).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Distinction",
    question:
        "Le critère le plus discriminant entre concussion et corruption est :",
    options: [
      "Concussion = perception indue de droits/taxes ; Corruption = avantage contre acte/abstention",
      "Concussion = influence ; Corruption = taxe",
      "Concussion = toujours en espèces ; Corruption = toujours en nature",
    ],
    answer:
        "Concussion = perception indue de droits/taxes ; Corruption = avantage contre acte/abstention",
    explanation:
        "Concussion : sommes publiques indûment réclamées/reçues. Corruption : pacte d’avantage en échange d’un acte/abstention.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Distinction",
    question:
        "Le trafic d’influence se distingue surtout de la corruption car il vise :",
    options: [
      "L’abus d’influence pour obtenir une décision d’une autorité/administration",
      "La perception d’un droit public illégal",
      "La falsification d’un document public",
    ],
    answer:
        "L’abus d’influence pour obtenir une décision d’une autorité/administration",
    explanation:
        "Trafic d’influence = monnayer l’influence réelle/supposée pour obtenir distinctions/emplois/marchés/décisions.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Concussion — Élément matériel",
    question: "La perception indue peut être :",
    options: [
      "Totalement indue ou partiellement indue",
      "Uniquement totalement indue",
      "Uniquement partiellement indue",
    ],
    answer: "Totalement indue ou partiellement indue",
    explanation:
        "Indue si non prévue par texte, ou si excédant ce qui est dû (partiellement indue).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Concussion — Notion de droits",
    question: "La jurisprudence inclut dans les « droits » visés par 432-10 :",
    options: [
      "Salaires/traitements/indemnités et fournitures reçues",
      "Uniquement impôts nationaux",
      "Uniquement taxes locales",
    ],
    answer: "Salaires/traitements/indemnités et fournitures reçues",
    explanation:
        "La notion de « droits » est interprétée largement par la jurisprudence.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Concussion — Prestation fictive",
    question:
        "Percevoir une rémunération pour une fonction non exercée (prestation fictive) peut relever de :",
    options: ["Concussion", "Trafic d’influence", "Outrage"],
    answer: "Concussion",
    explanation:
        "La jurisprudence retient souvent la concussion lorsque des prestations payées dépassent la réalité de celles tarifées/exercées.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Concussion — Comparaison aux textes",
    question: "Pour prouver la concussion, on doit montrer que la somme :",
    options: [
      "N’est prévue par aucun texte OU excède ce que les textes autorisent",
      "Est moralement choquante",
      "A causé un préjudice chiffré obligatoire",
    ],
    answer:
        "N’est prévue par aucun texte OU excède ce que les textes autorisent",
    explanation:
        "Le caractère illicite résulte de l’absence de base légale/réglementaire ou du dépassement du dû.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Concussion — Exonération",
    question: "Accorder une exonération illégale correspond à une concussion :",
    options: [
      "Par abstention (432-10 al.2)",
      "Uniquement si somme perçue",
      "Uniquement si bande organisée",
    ],
    answer: "Par abstention (432-10 al.2)",
    explanation:
        "Le texte vise aussi l’exonération/franchise illégale (forme quelconque, motif quelconque).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Concussion — Vrai/Faux",
    question:
        "Vrai/Faux : la concussion exige que l’auteur s’enrichisse personnellement.",
    options: ["Vrai", "Faux", "Seulement si élu"],
    answer: "Faux",
    explanation:
        "L’infraction vise la perception illégale ; l’enrichissement n’est pas un élément constitutif.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Concussion — Vrai/Faux",
    question:
        "Vrai/Faux : la concussion peut être constituée sans violence ni menace.",
    options: ["Vrai", "Faux", "Seulement si taxe locale"],
    answer: "Vrai",
    explanation:
        "Le moyen importe peu : pas besoin d’abus d’autorité, menaces ou manœuvres.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Concussion — Tentative",
    question: "La tentative de concussion est :",
    options: [
      "Punissable",
      "Non punissable",
      "Punissable uniquement si somme perçue",
    ],
    answer: "Punissable",
    explanation: "La tentative est prévue par l’alinéa 3 de l’article 432-10.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Concussion",
    question:
        "Un agent « invente » un tarif et le fait payer à l’usager, en prétendant que c’est obligatoire. On retient :",
    options: ["Concussion", "Corruption passive", "Trafic d’influence"],
    answer: "Concussion",
    explanation:
        "Perception indue à titre de droits/contributions/taxes (même appelée « frais »).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège concours — Concussion",
    question: "Une somme « indue » peut être :",
    options: [
      "Non prévue par un texte OU excédant le montant légal",
      "Uniquement non prévue par un texte",
      "Uniquement excédant le montant légal",
    ],
    answer: "Non prévue par un texte OU excédant le montant légal",
    explanation: "Le texte vise non due ou excédant ce qui est dû.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Concussion",
    question: "Le délit de concussion peut exister même si l’auteur :",
    options: [
      "N’abuse pas de son autorité",
      "Utilise forcément une menace",
      "Utilise forcément une manœuvre frauduleuse",
    ],
    answer: "N’abuse pas de son autorité",
    explanation:
        "Le moyen importe peu : ce qui compte est la perception illégale.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Corruption passive — Définition",
    question: "La corruption passive est constituée si l’agent public :",
    options: [
      "Sollicite ou agrée sans droit un avantage pour accomplir/s’abstenir d’un acte de sa fonction",
      "Perçoit un droit public non prévu par la loi",
      "Fait pression pour obtenir une dérogation au service public",
    ],
    answer:
        "Sollicite ou agrée sans droit un avantage pour accomplir/s’abstenir d’un acte de sa fonction",
    explanation:
        "Pacte avantage ↔ acte/abstention/acte facilité (article 432-11).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Corruption passive — Sollicitation/Agrément",
    question: "La différence entre sollicitation et agrément est :",
    options: [
      "Sollicitation = initiative de l’agent ; Agrément = acceptation de la proposition",
      "Sollicitation = acceptation ; Agrément = initiative",
      "Sollicitation = contrainte ; Agrément = menace",
    ],
    answer:
        "Sollicitation = initiative de l’agent ; Agrément = acceptation de la proposition",
    explanation:
        "La sollicitation est une démarche de l’agent ; l’agrément est l’accord donné à la proposition.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Corruption passive — Direct/Indirect",
    question: "La corruption « indirecte » correspond à :",
    options: [
      "Un avantage transmis par une personne interposée",
      "Un avantage versé après l’acte uniquement",
      "Un avantage versé par chèque uniquement",
    ],
    answer: "Un avantage transmis par une personne interposée",
    explanation:
        "La sollicitation/acceptation peut transiter via un intermédiaire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Corruption passive — À tout moment",
    question: "En corruption passive, l’accord peut intervenir après l’acte :",
    options: ["Oui", "Non", "Uniquement si acte illégal"],
    answer: "Oui",
    explanation:
        "Le texte précise « à tout moment » : pacte possible postérieurement à l’acte (remerciement).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Corruption passive — Acte facilité",
    question: "L’« acte facilité par la fonction » vise :",
    options: [
      "Un acte rendu possible par la position (accès à des infos/dossiers) même hors attributions strictes",
      "Uniquement un acte prévu par la loi",
      "Uniquement un acte écrit signé",
    ],
    answer:
        "Un acte rendu possible par la position (accès à des infos/dossiers) même hors attributions strictes",
    explanation:
        "Ex : monnayer des informations surprises grâce aux facilités de la fonction.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Corruption passive — Élément moral",
    question: "Pour l’élément moral, on recherche :",
    options: [
      "La conscience d’accepter l’avantage comme contrepartie d’un acte/abstention",
      "La preuve d’un enrichissement important",
      "La preuve d’un préjudice effectif chiffré",
    ],
    answer:
        "La conscience d’accepter l’avantage comme contrepartie d’un acte/abstention",
    explanation:
        "Devoir de probité + volonté d’obtenir avantage ; le mobile importe peu.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Corruption passive — Vrai/Faux",
    question:
        "Vrai/Faux : la corruption passive exige un écrit ou un pacte formalisé.",
    options: ["Vrai", "Faux", "Uniquement si somme > 1 000 €"],
    answer: "Faux",
    explanation:
        "L’accord de volontés peut être tacite ; aucun écrit n’est exigé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Corruption passive — Vrai/Faux",
    question:
        "Vrai/Faux : l’avantage peut être une promesse non encore exécutée.",
    options: ["Vrai", "Faux", "Uniquement si avantage en argent"],
    answer: "Vrai",
    explanation: "Le texte vise aussi les offres et promesses.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Corruption passive — Aggravation",
    question: "La corruption passive est aggravée lorsqu’elle est commise :",
    options: ["En bande organisée", "En réunion", "Avec arme"],
    answer: "En bande organisée",
    explanation: "Article 432-11 al.4 : bande organisée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Corruption passive — Peines",
    question: "Peines corruption passive simple :",
    options: ["10 ans + 1 000 000 €", "5 ans + 500 000 €", "3 ans + 45 000 €"],
    answer: "10 ans + 1 000 000 €",
    explanation:
        "Article 432-11 : 10 ans et 1 000 000 € (double du produit possible).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Corruption passive — Peines",
    question: "Peines corruption passive aggravée (bande organisée) :",
    options: [
      "10 ans + 2 000 000 €",
      "15 ans + 1 000 000 €",
      "7 ans + 100 000 €",
    ],
    answer: "10 ans + 2 000 000 €",
    explanation:
        "Article 432-11 al.4 : 10 ans et 2 000 000 € (double du produit possible).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Corruption passive — Tentative",
    question: "Vrai/Faux : la tentative de corruption passive est punissable.",
    options: ["Vrai", "Faux", "Uniquement en bande organisée"],
    answer: "Faux",
    explanation: "La fiche indique : tentative non punissable.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Corruption",
    question:
        "Un agent public accepte un voyage en échange d’une abstention de contrôle. Qualification :",
    options: ["Corruption passive", "Concussion", "Trafic d’influence"],
    answer: "Corruption passive",
    explanation:
        "Avantage (voyage) contre abstention d’un acte de la fonction.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Corruption",
    question:
        "Un agent reçoit un cadeau « de remerciement » après un acte accompli, et il savait que ce cadeau était la contrepartie. Qualification :",
    options: [
      "Corruption passive",
      "Aucune infraction (après l’acte)",
      "Concussion",
    ],
    answer: "Corruption passive",
    explanation: "Le pacte peut être postérieur (« à tout moment »).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège concours — Corruption vs Trafic",
    question:
        "Un agent est payé pour « intervenir auprès » d’une autre administration afin d’obtenir une décision favorable. Qualification typique :",
    options: ["Trafic d’influence", "Corruption passive", "Concussion"],
    answer: "Trafic d’influence",
    explanation:
        "Monnayer une influence auprès d’une autorité/administration publique.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Trafic d’influence — Définition",
    question: "Le trafic d’influence (agent public) consiste à :",
    options: [
      "Solliciter/agréer un avantage pour abuser d’une influence réelle ou supposée",
      "Recevoir une taxe non due",
      "Falsifier un acte administratif",
    ],
    answer:
        "Solliciter/agréer un avantage pour abuser d’une influence réelle ou supposée",
    explanation:
        "Trafic d’influence : avantage ↔ abus d’influence réelle/supposée pour obtenir une décision favorable.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Trafic d’influence — Influence",
    question: "L’influence en trafic d’influence peut être :",
    options: ["Réelle ou supposée", "Uniquement réelle", "Uniquement supposée"],
    answer: "Réelle ou supposée",
    explanation: "Le texte vise l’influence réelle ou supposée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Trafic d’influence — Destinataire",
    question: "L’influence doit viser :",
    options: [
      "Une autorité ou administration publique disposant d’un pouvoir de décision",
      "N’importe quel particulier",
      "Uniquement un collègue de même service",
    ],
    answer:
        "Une autorité ou administration publique disposant d’un pouvoir de décision",
    explanation:
        "Le destinataire à influencer doit disposer d’un pouvoir de décision (autorité/administration).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Trafic d’influence — Objet",
    question: "Le trafic d’influence vise l’obtention de :",
    options: [
      "Distinctions, emplois, marchés ou toute décision favorable",
      "Uniquement un PV non dressé",
      "Uniquement une exonération de taxe",
    ],
    answer: "Distinctions, emplois, marchés ou toute décision favorable",
    explanation:
        "Cœur de l’infraction : obtenir une décision favorable d’une autorité/administration.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Trafic d’influence — Décision régulière",
    question:
        "Vrai/Faux : la décision recherchée doit être illégale pour retenir le trafic d’influence.",
    options: ["Vrai", "Faux", "Uniquement si marché public"],
    answer: "Faux",
    explanation:
        "Même une décision régulière peut être visée : ce sont les moyens d’influence achetée qui sont illégaux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Trafic d’influence — Acte exercé",
    question:
        "Vrai/Faux : le trafic d’influence exige que l’influence soit effectivement exercée et réussisse.",
    options: ["Vrai", "Faux", "Seulement si influence supposée"],
    answer: "Faux",
    explanation:
        "Peu importe que l’influence ne soit finalement pas exercée ou qu’elle soit vaine.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Trafic d’influence — Peines",
    question: "Peines trafic d’influence simple :",
    options: ["10 ans + 1 000 000 €", "5 ans + 500 000 €", "3 ans + 45 000 €"],
    answer: "10 ans + 1 000 000 €",
    explanation:
        "Trafic d’influence (agent public) : mêmes peines que corruption passive simple.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Trafic d’influence — Aggravation",
    question: "Trafic d’influence aggravé si commis :",
    options: ["En bande organisée", "En réunion", "Avec arme"],
    answer: "En bande organisée",
    explanation: "Article 432-11 al.4.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Trafic d’influence — Tentative",
    question: "Vrai/Faux : la tentative de trafic d’influence est punissable.",
    options: ["Vrai", "Faux", "Uniquement si influence réelle"],
    answer: "Faux",
    explanation: "La fiche : TENTATIVE NON.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Trafic d’influence",
    question:
        "Un élu est payé pour « faire obtenir » un marché public via ses relations. Qualification :",
    options: ["Trafic d’influence", "Corruption passive", "Concussion"],
    answer: "Trafic d’influence",
    explanation:
        "Abus d’influence réelle/supposée en vue de faire obtenir un marché.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Qualification + Article",
    question:
        "Un agent public accepte 500€ pour transmettre un renseignement non public obtenu grâce à l’accès aux dossiers. Qualification + article ?",
    options: [
      "Corruption passive — 432-11 (acte facilité par la fonction)",
      "Trafic d’influence — 432-11 al.3",
      "Concussion — 432-10",
    ],
    answer: "Corruption passive — 432-11 (acte facilité par la fonction)",
    explanation:
        "Avantage contre un acte facilité par la fonction (accès aux dossiers).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Qualification + Article",
    question:
        "Un agent invente un « droit obligatoire » et encaisse 30€ pour un document. Qualification + article ?",
    options: [
      "Concussion — 432-10",
      "Corruption passive — 432-11",
      "Trafic d’influence — 432-11 al.3",
    ],
    answer: "Concussion — 432-10",
    explanation:
        "Perception indue à titre de droits/taxes publics. Peines: 5 ans + 500 000 €.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Qualification + Article",
    question:
        "Un élu accepte un cadeau pour user de son influence afin d’obtenir une nomination. Qualification + article ?",
    options: [
      "Trafic d’influence — 432-11 al.3",
      "Corruption passive — 432-11 al.1-2",
      "Concussion — 432-10",
    ],
    answer: "Trafic d’influence — 432-11 al.3",
    explanation:
        "Avantage contre abus d’influence (réelle ou supposée) pour obtenir un emploi/décision.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Qualification + Peine",
    question:
        "Une corruption passive aggravée est retenue : peine principale (selon fiche) ?",
    options: [
      "10 ans + 2 000 000 €",
      "5 ans + 500 000 €",
      "15 ans + 150 000 €",
    ],
    answer: "10 ans + 2 000 000 €",
    explanation:
        "Bande organisée : 10 ans d’emprisonnement + 2 000 000 € d’amende (double du produit possible).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QCM piège — Concussion",
    question:
        "Pour retenir la concussion, la somme doit être réclamée/reçue à titre de :",
    options: [
      "Droits, contributions, impôts ou taxes publics",
      "Dons, présents ou avantages quelconques",
      "Distinctions, emplois ou marchés",
    ],
    answer: "Droits, contributions, impôts ou taxes publics",
    explanation:
        "La concussion vise la perception indue à titre de prélèvements publics (au sens large).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QCM piège — Concussion",
    question: "La concussion est constituée si la perception :",
    options: [
      "N’est prévue par aucun texte OU excède le montant dû",
      "Est simplement impopulaire",
      "Cause nécessairement un préjudice chiffré",
    ],
    answer: "N’est prévue par aucun texte OU excède le montant dû",
    explanation:
        "Le caractère indu se prouve par comparaison avec les textes applicables.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QCM piège — Concussion",
    question:
        "Un agent public se fait remettre gratuitement un bien/service par un usager en prétendant que c’est « obligatoire ». Qualification la plus proche :",
    options: ["Concussion", "Trafic d’influence", "Outrage"],
    answer: "Concussion",
    explanation:
        "La notion de somme peut inclure des prestations en nature si assimilables à une perception indue.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM piège — Concussion",
    question:
        "Vrai/Faux : la concussion nécessite que la victime soit déterminée nominativement.",
    options: ["Vrai", "Faux", "Uniquement si élu"],
    answer: "Faux",
    explanation:
        "L’infraction porte sur la perception indue ; la détermination nominative n’est pas une condition constitutive.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QCM piège — Concussion",
    question:
        "La concussion peut être retenue lorsque la somme est versée sur :",
    options: [
      "Un compte occulte ou un circuit non officiel",
      "Uniquement le Trésor public",
      "Uniquement le compte personnel de l’agent",
    ],
    answer: "Un compte occulte ou un circuit non officiel",
    explanation:
        "La jurisprudence retient la concussion même si les fonds sont orientés vers un compte occulte d’un établissement public.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM piège — Concussion",
    question:
        "En matière de concussion, ce qui est sanctionné en priorité est :",
    options: [
      "Le caractère illégal de la perception (absence de base légale/réglementaire)",
      "La violence ou l’intimidation",
      "La présence d’un intermédiaire",
    ],
    answer:
        "Le caractère illégal de la perception (absence de base légale/réglementaire)",
    explanation: "Pas besoin de menaces/manœuvres : le moyen importe peu.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QCM piège — Concussion (exonération)",
    question:
        "Accorder illégalement une exonération d’un impôt/taxe public constitue :",
    options: [
      "Concussion (forme assimilée)",
      "Corruption passive",
      "Trafic d’influence",
    ],
    answer: "Concussion (forme assimilée)",
    explanation:
        "L’article 432-10 vise aussi l’exonération/franchise illégale (alinéa 2).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM piège — Concussion",
    question:
        "Vrai/Faux : l’intention est exclue si la perception indue résulte d’une erreur de fait.",
    options: ["Vrai", "Faux", "Uniquement si somme faible"],
    answer: "Vrai",
    explanation:
        "La fiche précise que l’intention peut disparaître en cas d’erreur ou de mauvaise interprétation d’un texte.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions flash — 432-10",
    question: "Peine principale 432-10 :",
    options: ["5 ans + 500 000 €", "10 ans + 1 000 000 €", "2 ans + 30 000 €"],
    answer: "5 ans + 500 000 €",
    explanation:
        "Concussion : 5 ans et 500 000 € (amende possible au double du produit).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions flash — 432-10",
    question:
        "Vrai/Faux : la concussion a des circonstances aggravantes prévues par le texte.",
    options: ["Vrai", "Faux", "Seulement si bande organisée"],
    answer: "Faux",
    explanation: "La fiche indique : AUCUNE aggravante spécifique.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "QCM piège — Corruption passive",
    question: "En corruption passive, l’avantage doit être :",
    options: [
      "Sans droit",
      "Forcément en espèces",
      "Forcément supérieur à 150 €",
    ],
    answer: "Sans droit",
    explanation:
        "Le texte vise « solliciter/agréer sans droit » des avantages.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QCM piège — Corruption passive",
    question: "La corruption passive est constituée même si l’agent public :",
    options: [
      "N’accomplit finalement pas l’acte prévu",
      "A seulement pensé à demander",
      "A remboursé ensuite l’avantage",
    ],
    answer: "N’accomplit finalement pas l’acte prévu",
    explanation: "Le pacte suffit ; l’exécution est indifférente.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM piège — Corruption passive",
    question:
        "Un cadeau « de remerciement » après l’acte peut être de la corruption passive car :",
    options: [
      "L’accord peut intervenir à tout moment, même postérieurement",
      "La corruption n’existe que si l’accord est antérieur",
      "Un remerciement n’est jamais punissable",
    ],
    answer: "L’accord peut intervenir à tout moment, même postérieurement",
    explanation:
        "La fiche insiste sur le caractère « à tout moment » (pacte possible après l’acte).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM piège — Corruption passive",
    question: "L’« acte de la fonction » comprend aussi :",
    options: [
      "Les actes imposés par la discipline de la fonction",
      "Uniquement les actes écrits prévus par la loi",
      "Uniquement les décisions administratives formelles",
    ],
    answer: "Les actes imposés par la discipline de la fonction",
    explanation:
        "Les actes de la fonction ne se limitent pas aux textes : ils incluent la discipline de la fonction.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM piège — Corruption passive",
    question: "« Acte facilité par la fonction » =",
    options: [
      "Acte rendu possible par les facilités de la position (accès, dossiers, infos)",
      "Acte public obligatoirement tarifé",
      "Acte de taxation locale",
    ],
    answer:
        "Acte rendu possible par les facilités de la position (accès, dossiers, infos)",
    explanation:
        "Ex : consulter des dossiers non accessibles et monnayer des renseignements.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions flash — 432-11",
    question: "Peine corruption passive simple :",
    options: ["10 ans + 1 000 000 €", "5 ans + 500 000 €", "3 ans + 45 000 €"],
    answer: "10 ans + 1 000 000 €",
    explanation: "432-11 : 10 ans et 1 000 000 € (double du produit possible).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions flash — 432-11",
    question: "Aggravation principale :",
    options: ["Bande organisée", "Réunion", "Arme"],
    answer: "Bande organisée",
    explanation: "432-11 al.4 : bande organisée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions flash — 432-11",
    question: "Vrai/Faux : tentative corruption passive punissable.",
    options: ["Vrai", "Faux", "Uniquement si bande organisée"],
    answer: "Faux",
    explanation: "La fiche indique : tentative NON.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QCM piège — Corruption passive",
    question: "L’avantage en corruption passive peut profiter :",
    options: [
      "À l’agent OU à un tiers",
      "Uniquement à l’agent",
      "Uniquement à une personne morale",
    ],
    answer: "À l’agent OU à un tiers",
    explanation: "Le texte prévoit l’avantage pour elle-même ou pour autrui.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "QCM piège — Trafic d’influence",
    question: "Le trafic d’influence porte sur :",
    options: [
      "L’abus d’influence réelle ou supposée",
      "La perception d’un droit public illégal",
      "La fabrication d’un document administratif",
    ],
    answer: "L’abus d’influence réelle ou supposée",
    explanation:
        "Trafic d’influence : monnayer une influence, pas percevoir une taxe (concussion) ni acte de la fonction (corruption).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "QCM piège — Trafic d’influence",
    question: "La décision favorable recherchée peut être :",
    options: [
      "Régulière au fond mais obtenue par des moyens irréguliers",
      "Forcément illégale",
      "Toujours une décision de justice uniquement",
    ],
    answer: "Régulière au fond mais obtenue par des moyens irréguliers",
    explanation:
        "L’irrégularité réside dans les moyens (influence achetée), pas forcément dans la décision.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM piège — Trafic d’influence",
    question: "Le trafic d’influence vise notamment :",
    options: [
      "Distinctions, emplois, marchés, toute décision favorable",
      "Le non-paiement d’un impôt par exonération",
      "Le refus d’obtempérer à une sommation",
    ],
    answer: "Distinctions, emplois, marchés, toute décision favorable",
    explanation:
        "Objet du trafic : obtenir une décision favorable d’une autorité/administration.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions flash — 432-11 al.3",
    question: "Peine trafic d’influence simple :",
    options: ["10 ans + 1 000 000 €", "5 ans + 500 000 €", "2 ans + 30 000 €"],
    answer: "10 ans + 1 000 000 €",
    explanation:
        "La fiche donne les mêmes peines que corruption passive simple.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions flash — Trafic",
    question: "Vrai/Faux : tentative trafic d’influence punissable.",
    options: ["Vrai", "Faux", "Uniquement si influence réelle"],
    answer: "Faux",
    explanation: "La fiche indique : tentative NON.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Distinction",
    question:
        "Un agent public demande 50€ « pour ne pas verbaliser ». Qualification la plus juste :",
    options: ["Corruption passive", "Concussion", "Trafic d’influence"],
    answer: "Corruption passive",
    explanation:
        "Avantage contre abstention d’un acte de la fonction (ne pas verbaliser).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Distinction",
    question:
        "Un agent public impose un « droit » inventé pour instruire un dossier. Qualification :",
    options: ["Concussion", "Corruption passive", "Trafic d’influence"],
    answer: "Concussion",
    explanation:
        "Perception indue à titre de droits/contributions/taxes publics.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège concours — Distinction",
    question:
        "Un élu monnaye ses relations pour obtenir une distinction. Qualification :",
    options: ["Trafic d’influence", "Concussion", "Corruption passive"],
    answer: "Trafic d’influence",
    explanation:
        "Monnayer une influence pour obtenir une décision favorable (distinction).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Qualification + Article + Peine",
    question:
        "Un agent public accepte 300€ pour accélérer un acte relevant de ses fonctions. Quelle réponse est correcte ?",
    options: [
      "Corruption passive (432-11) — 10 ans + 1 000 000 €",
      "Concussion (432-10) — 5 ans + 500 000 €",
      "Trafic d’influence (432-11 al.3) — 2 ans + 30 000 €",
    ],
    answer: "Corruption passive (432-11) — 10 ans + 1 000 000 €",
    explanation:
        "Avantage contre acte de la fonction = corruption passive. Peines : 10 ans + 1 000 000 € (double du produit possible).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Qualification + Article + Peine",
    question:
        "Un maire dispense illégalement un proche du paiement d’un loyer communal, sans base légale. Bonne réponse ?",
    options: [
      "Concussion (432-10 al.2) — 5 ans + 500 000 €",
      "Corruption passive (432-11) — 10 ans + 1 000 000 €",
      "Trafic d’influence (432-11 al.3) — 10 ans + 1 000 000 €",
    ],
    answer: "Concussion (432-10 al.2) — 5 ans + 500 000 €",
    explanation:
        "Exonération/franchise illégale = concussion assimilée. Peines : 5 ans + 500 000 €.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Qualification + Article + Peine",
    question:
        "Un élu reçoit un avantage pour user de son influence afin d’obtenir un marché. Bonne réponse ?",
    options: [
      "Trafic d’influence (432-11 al.3) — 10 ans + 1 000 000 €",
      "Concussion (432-10) — 5 ans + 500 000 €",
      "Outrage (433-5) — 6 mois + 7 500 €",
    ],
    answer: "Trafic d’influence (432-11 al.3) — 10 ans + 1 000 000 €",
    explanation:
        "Monnayer une influence pour obtenir un marché/décision favorable = trafic d’influence.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai / Faux — Concussion",
    question:
        "Vrai/Faux : la concussion suppose nécessairement un enrichissement personnel.",
    options: ["Vrai", "Faux", "Seulement si élu"],
    answer: "Faux",
    explanation:
        "L’enrichissement personnel n’est pas requis : seule compte la perception ou exonération illégale.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai / Faux — Concussion",
    question:
        "Vrai/Faux : la concussion peut porter sur des prestations en nature.",
    options: ["Vrai", "Faux", "Uniquement en argent"],
    answer: "Vrai",
    explanation:
        "La jurisprudence assimile certaines prestations en nature à des sommes (ex : repas gratuits).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai / Faux — Concussion",
    question: "Vrai/Faux : la concussion nécessite une manœuvre frauduleuse.",
    options: ["Vrai", "Faux", "Uniquement si taxe locale"],
    answer: "Faux",
    explanation:
        "Le moyen est indifférent : il suffit que la perception soit illégale.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "QCM concours — Concussion",
    question:
        "Un agent réclame une somme prévue par un texte, mais supérieure au tarif légal. Qualification ?",
    options: [
      "Concussion (somme partiellement indue)",
      "Aucune infraction",
      "Corruption passive",
    ],
    answer: "Concussion (somme partiellement indue)",
    explanation: "La perception peut être totalement ou partiellement indue.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM concours — Concussion",
    question:
        "La concussion peut être constituée même si la somme est reversée à :",
    options: ["Un organisme public", "L’agent lui-même", "Un tiers privé"],
    answer: "Un organisme public",
    explanation:
        "L’affectation finale est indifférente : seule compte la perception illégale.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Révisions flash — Article",
    question: "Article réprimant la concussion :",
    options: ["432-10 CP", "432-11 CP", "433-1 CP"],
    answer: "432-10 CP",
    explanation:
        "La concussion est prévue et réprimée par l’article 432-10 du Code pénal.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vrai / Faux — Corruption passive",
    question:
        "Vrai/Faux : en corruption passive, le corrupteur est toujours un particulier.",
    options: ["Vrai", "Faux", "Uniquement si élu"],
    answer: "Vrai",
    explanation:
        "Si l’auteur est un agent public, l’infraction est toujours qualifiée de corruption passive.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai / Faux — Corruption passive",
    question:
        "Vrai/Faux : la corruption passive suppose un acte illégal de la fonction.",
    options: ["Vrai", "Faux", "Uniquement si argent"],
    answer: "Faux",
    explanation:
        "L’acte peut être légal : c’est l’échange avantage ↔ acte qui est illicite.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "QCM concours — Corruption passive",
    question:
        "Un agent accepte un avantage pour accomplir plus rapidement un acte légal. Qualification ?",
    options: ["Corruption passive", "Aucune infraction", "Trafic d’influence"],
    answer: "Corruption passive",
    explanation:
        "Même un acte légal peut constituer la corruption s’il est monnayé.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "QCM concours — Corruption passive",
    question: "L’accord de corruption est constitué dès lors que :",
    options: [
      "Les volontés se rencontrent",
      "L’avantage est effectivement versé",
      "L’acte est accompli",
    ],
    answer: "Les volontés se rencontrent",
    explanation: "Le pacte de corruption suffit, même sans exécution.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Révisions flash — Corruption",
    question: "Peine maximale corruption passive aggravée (bande organisée) :",
    options: [
      "10 ans + 2 000 000 €",
      "15 ans + 1 000 000 €",
      "7 ans + 100 000 €",
    ],
    answer: "10 ans + 2 000 000 €",
    explanation: "Article 432-11 al.4 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vrai / Faux — Trafic d’influence",
    question:
        "Vrai/Faux : le trafic d’influence suppose un acte relevant de la fonction.",
    options: ["Vrai", "Faux", "Uniquement si élu"],
    answer: "Faux",
    explanation:
        "Le trafic d’influence porte sur l’abus d’influence, pas sur l’acte de la fonction.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai / Faux — Trafic d’influence",
    question: "Vrai/Faux : l’influence peut être seulement supposée.",
    options: ["Vrai", "Faux", "Uniquement réelle"],
    answer: "Vrai",
    explanation: "Le texte vise l’influence réelle ou supposée.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "QCM concours — Trafic d’influence",
    question:
        "Un agent promet d’user de ses relations, sans avoir de pouvoir décisionnel. Qualification ?",
    options: ["Trafic d’influence", "Corruption passive", "Aucune infraction"],
    answer: "Trafic d’influence",
    explanation:
        "Il suffit d’une influence supposée pour caractériser l’infraction.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Révisions flash — Trafic",
    question: "Article trafic d’influence (agent public) :",
    options: ["432-11 al.3 CP", "432-10 CP", "433-5 CP"],
    answer: "432-11 al.3 CP",
    explanation:
        "Le trafic d’influence est prévu par l’article 432-11 alinéa 3.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Distinction concours — Ultra piège",
    question:
        "Un agent impose un « droit fictif » pour instruire un dossier. Qualification exacte ?",
    options: ["Concussion", "Corruption passive", "Trafic d’influence"],
    answer: "Concussion",
    explanation: "Perception indue à titre de droits publics, même sans pacte.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Distinction concours — Ultra piège",
    question:
        "Un agent accepte de l’argent pour fermer les yeux sur une infraction. Qualification ?",
    options: ["Corruption passive", "Concussion", "Trafic d’influence"],
    answer: "Corruption passive",
    explanation: "Avantage contre abstention d’un acte de la fonction.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Distinction concours — Ultra piège",
    question:
        "Un élu est payé pour intervenir auprès d’un préfet afin d’obtenir une décision. Qualification ?",
    options: ["Trafic d’influence", "Corruption passive", "Concussion"],
    answer: "Trafic d’influence",
    explanation: "Abus d’influence réelle ou supposée auprès d’une autorité.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Qualification + Article",
    question:
        "Un agent réclame 20€ « obligatoires » non prévus par un texte pour un service administratif. Qualification + article ?",
    options: [
      "Concussion — 432-10 CP",
      "Corruption passive — 432-11 CP",
      "Trafic d’influence — 432-11 al.3 CP",
    ],
    answer: "Concussion — 432-10 CP",
    explanation: "Perception indue à titre de droits publics.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Qualification + Article",
    question:
        "Un agent accepte un avantage pour accélérer un acte relevant de ses fonctions. Qualification + article ?",
    options: [
      "Corruption passive — 432-11 CP",
      "Concussion — 432-10 CP",
      "Trafic d’influence — 432-11 al.3 CP",
    ],
    answer: "Corruption passive — 432-11 CP",
    explanation: "Avantage contre acte de la fonction, même légal.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Qualification + Article",
    question:
        "Un agent accepte de l’argent pour user de ses relations afin d’obtenir une décision favorable. Qualification + article ?",
    options: [
      "Trafic d’influence — 432-11 al.3 CP",
      "Corruption passive — 432-11 CP",
      "Concussion — 432-10 CP",
    ],
    answer: "Trafic d’influence — 432-11 al.3 CP",
    explanation: "Abus d’influence contre avantage.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Révisions rapides — Article",
    question: "La concussion est réprimée par :",
    options: ["Article 432-10 CP", "Article 432-11 CP", "Article 433-10 CP"],
    answer: "Article 432-10 CP",
    explanation:
        "La concussion est prévue et réprimée par l’article 432-10 du Code pénal.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Article",
    question: "La corruption passive (agent public) est réprimée par :",
    options: [
      "Article 432-11 al.1 et 2 CP",
      "Article 432-10 CP",
      "Article 441-6 CP",
    ],
    answer: "Article 432-11 al.1 et 2 CP",
    explanation:
        "L’infraction de corruption passive est prévue par l’article 432-11 al.1 et 2 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Article",
    question: "Le trafic d’influence (agent public) est réprimé par :",
    options: [
      "Article 432-11 al.3 CP",
      "Article 432-10 CP",
      "Article 434-5 CP",
    ],
    answer: "Article 432-11 al.3 CP",
    explanation: "Trafic d’influence : 432-11 alinéa 3 CP (selon ta fiche).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peines",
    question: "Peines principales de la concussion (432-10) :",
    options: [
      "5 ans et 500 000 €",
      "10 ans et 1 000 000 €",
      "3 ans et 45 000 €",
    ],
    answer: "5 ans et 500 000 €",
    explanation:
        "432-10 : 5 ans d’emprisonnement + 500 000 € d’amende (pouvant être portée au double du produit).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peines",
    question: "Peines principales de la corruption passive simple (432-11) :",
    options: [
      "10 ans et 1 000 000 €",
      "5 ans et 500 000 €",
      "2 ans et 30 000 €",
    ],
    answer: "10 ans et 1 000 000 €",
    explanation:
        "432-11 : 10 ans + 1 000 000 € (peut être porté au double du produit).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peines",
    question: "Corruption passive aggravée (bande organisée) :",
    options: [
      "10 ans et 2 000 000 €",
      "15 ans et 3 000 000 €",
      "7 ans et 100 000 €",
    ],
    answer: "10 ans et 2 000 000 €",
    explanation:
        "432-11 al.4 : 10 ans + 2 000 000 € (double du produit possible).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Peines",
    question:
        "Peines principales du trafic d’influence simple (agent public) :",
    options: [
      "10 ans et 1 000 000 €",
      "5 ans et 500 000 €",
      "3 ans et 45 000 €",
    ],
    answer: "10 ans et 1 000 000 €",
    explanation: "432-11 al.3 : mêmes peines que corruption passive simple.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Tentative",
    question: "Tentative de concussion (432-10) :",
    options: [
      "Punissable",
      "Non punissable",
      "Punissable seulement pour l’alinéa 1",
    ],
    answer: "Punissable",
    explanation:
        "432-10 al.3 prévoit expressément la tentative (alinéa 1 et alinéa 2).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Tentative",
    question: "Tentative de corruption passive (432-11) :",
    options: ["Non punissable", "Punissable", "Punissable si somme > 150 €"],
    answer: "Non punissable",
    explanation: "La fiche indique : TENTATIVE : NON.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Tentative",
    question: "Tentative de trafic d’influence (432-11 al.3) :",
    options: ["Non punissable", "Punissable", "Punissable si influence réelle"],
    answer: "Non punissable",
    explanation: "La fiche indique : TENTATIVE : NON.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Aggravantes",
    question: "La concussion comporte :",
    options: ["Aucune circonstance aggravante", "Bande organisée", "Réunion"],
    answer: "Aucune circonstance aggravante",
    explanation: "La fiche : IV — AUCUNE.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Aggravantes",
    question: "Corruption passive aggravée si commise :",
    options: ["En bande organisée", "De nuit", "En réunion"],
    answer: "En bande organisée",
    explanation: "432-11 al.4 : bande organisée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — V/F",
    question:
        "Vrai/Faux : la corruption passive exige que l’acte soit effectivement réalisé.",
    options: ["Vrai", "Faux", "Seulement si pacte écrit"],
    answer: "Faux",
    explanation: "Le « pacte de corruption » suffit, même sans exécution.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — V/F",
    question: "Vrai/Faux : la concussion nécessite des manœuvres ou menaces.",
    options: ["Vrai", "Faux", "Uniquement si agent public"],
    answer: "Faux",
    explanation:
        "Le moyen importe peu : seul compte le caractère illégal de la perception.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — V/F",
    question:
        "Vrai/Faux : en corruption, l’avantage peut bénéficier à un tiers.",
    options: ["Vrai", "Faux", "Uniquement si tiers = famille"],
    answer: "Vrai",
    explanation:
        "L’avantage peut bénéficier à l’auteur OU à autrui (tiers, société, etc.).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — V/F",
    question:
        "Vrai/Faux : en trafic d’influence, l’influence doit être réelle et prouvée.",
    options: ["Vrai", "Faux", "Uniquement si élu"],
    answer: "Faux",
    explanation: "Elle peut être réelle OU supposée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — V/F",
    question:
        "Vrai/Faux : en trafic d’influence, peu importe que la décision favorable soit régulière.",
    options: ["Vrai", "Faux", "Seulement si marché public"],
    answer: "Vrai",
    explanation:
        "Ce sont les moyens irréguliers (l’influence achetée) qui constituent l’infraction.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Révisions rapides — V/F",
    question:
        "Vrai/Faux : en concussion, la somme indue peut être partiellement indue.",
    options: ["Vrai", "Faux", "Uniquement si taxe locale"],
    answer: "Vrai",
    explanation:
        "Somme totalement OU partiellement indue (excède ce qui est dû).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — V/F",
    question: "Vrai/Faux : le mobile (bonne intention) excuse la concussion.",
    options: ["Vrai", "Faux", "Seulement si somme faible"],
    answer: "Faux",
    explanation:
        "Les mobiles ne sont pas retenus ; seule compte la conscience du caractère indu.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Révisions rapides — Complicité",
    question: "Complicité en concussion :",
    options: ["Oui", "Non", "Seulement si bande organisée"],
    answer: "Oui",
    explanation:
        "Les règles générales 121-6 et 121-7 CP s’appliquent (fiche : COMPLICITÉ OUI).",
    difficulty: "Facile",
  ),

  // =========================================================
  // QCM ULTRA-PIÈGES (distinctions concours) — (31-75)
  // =========================================================
  const QuizQuestion(
    category: "Piège concours — Concussion vs Corruption",
    question:
        "Un agent public exige « des frais de dossier » non prévus par les textes pour traiter une demande. On retient d’abord :",
    options: [
      "Concussion (432-10)",
      "Corruption passive (432-11)",
      "Trafic d’influence (432-11 al.3)",
    ],
    answer: "Concussion (432-10)",
    explanation:
        "Perception indue à titre de droits/taxes/contributions, sans nécessité d’avantage offert.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège concours — Concussion",
    question: "La concussion peut être constituée même si l’agent :",
    options: [
      "N’use d’aucune menace/manœuvre",
      "Menace forcément",
      "Signe un pacte écrit",
    ],
    answer: "N’use d’aucune menace/manœuvre",
    explanation:
        "Le moyen importe peu : caractère illégal de la perception suffit.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Corruption",
    question: "En corruption passive, l’élément central est :",
    options: [
      "Le lien de causalité entre avantage et acte/abstention",
      "La perception d’une taxe",
      "L’existence d’un préjudice chiffré",
    ],
    answer: "Le lien de causalité entre avantage et acte/abstention",
    explanation:
        "Pacte de corruption : avantage ↔ acte/abstention/acte facilité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège concours — Corruption (moment)",
    question:
        "Un agent reçoit un cadeau « après coup » pour un service déjà rendu. Cela peut être :",
    options: ["Corruption passive", "Jamais une infraction", "Concussion"],
    answer: "Corruption passive",
    explanation:
        "Le pacte peut être postérieur à l’acte ; gratification de remerciement peut entrer dans l’incrimination.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège concours — Trafic d’influence",
    question: "Le trafic d’influence vise principalement :",
    options: [
      "Obtenir une décision favorable d’une autorité/administration",
      "Éviter un PV directement dans ses fonctions",
      "Percevoir une taxe locale",
    ],
    answer: "Obtenir une décision favorable d’une autorité/administration",
    explanation: "Distinctions, emplois, marchés, toute décision favorable.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Trafic d’influence vs Corruption",
    question:
        "Un élu est payé pour « appeler quelqu’un » afin d’obtenir un poste à un proche. On retient plutôt :",
    options: ["Trafic d’influence", "Corruption passive", "Concussion"],
    answer: "Trafic d’influence",
    explanation:
        "Contre avantage, abus d’influence réelle/supposée pour obtenir un emploi/décision.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège concours — Corruption vs Trafic d’influence",
    question:
        "Un agent public est payé pour accomplir un acte qu’il a compétence à réaliser. Qualification la plus typique :",
    options: ["Corruption passive", "Trafic d’influence", "Concussion"],
    answer: "Corruption passive",
    explanation: "Acte de la fonction contre avantage = corruption passive.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Trafic d’influence (influence)",
    question: "En trafic d’influence, l’auteur :",
    options: [
      "Abuse d’une influence réelle ou supposée",
      "Doit avoir pouvoir de décision",
      "Doit percevoir une taxe",
    ],
    answer: "Abuse d’une influence réelle ou supposée",
    explanation:
        "Il n’est pas nécessaire qu’il ait lui-même un pouvoir décisionnel ; il monnaye une influence.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège concours — Concussion (objet)",
    question: "La concussion porte sur :",
    options: [
      "Droits/contributions/impôts/taxes publics (somme indue)",
      "Offres/promesses/dons/avantages",
      "Décisions favorables obtenues par influence",
    ],
    answer: "Droits/contributions/impôts/taxes publics (somme indue)",
    explanation:
        "Cœur de la concussion : perception indue de sommes publiques.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Piège concours — Concussion (en nature)",
    question:
        "Un directeur d’hôpital se fait nourrir gratuitement chaque jour par la cuisine de l’établissement. Cela peut entrer dans :",
    options: [
      "Concussion (prestation en nature)",
      "Trafic d’influence",
      "Refus d’obtempérer",
    ],
    answer: "Concussion (prestation en nature)",
    explanation:
        "La « somme » peut inclure des prestations en nature (jurisprudence).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège concours — Concussion (salaires)",
    question:
        "Un agent public perçoit des indemnités au-delà de ce à quoi il a droit. Qualification la plus proche :",
    options: ["Concussion", "Corruption passive", "Trafic d’influence"],
    answer: "Concussion",
    explanation:
        "La jurisprudence inclut salaires/traitements/fournitures dans les « droits ». ",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège concours — Concussion (excédent)",
    question: "La somme est « indue » notamment lorsque :",
    options: [
      "Elle excède le montant légalement dû",
      "Elle provient d’un don",
      "Elle provient d’un marché privé",
    ],
    answer: "Elle excède le montant légalement dû",
    explanation:
        "Indue = non prévue OU excédant ce qui est dû (partiellement indue).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Concussion (exonération)",
    question:
        "Accorder volontairement une exonération de redevance du domaine public sans base légale :",
    options: [
      "Concussion (alinéa 2)",
      "Corruption passive",
      "Trafic d’influence",
    ],
    answer: "Concussion (alinéa 2)",
    explanation:
        "Exonération/franchise illégale = concussion assimilée (abstention).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège concours — Corruption (avantage)",
    question: "En corruption passive, l’avantage peut prendre la forme :",
    options: [
      "D’un voyage, d’un immeuble, d’un objet, d’argent",
      "Uniquement d’argent liquide",
      "Uniquement d’un avantage fiscal",
    ],
    answer: "D’un voyage, d’un immeuble, d’un objet, d’argent",
    explanation:
        "Offres/promesses/dons/présents/avantages : interprétation large.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Piège concours — Pacte",
    question: "Le « pacte de corruption » est :",
    options: [
      "La rencontre de volonté entre corrupteur et corrompu",
      "Un contrat écrit obligatoire",
      "Une condition de tentative",
    ],
    answer: "La rencontre de volonté entre corrupteur et corrompu",
    explanation: "Accord de volontés ; exécution indifférente.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Direct/indirect",
    question: "La corruption peut être :",
    options: [
      "Directe ou indirecte (personne interposée)",
      "Uniquement directe",
      "Uniquement indirecte",
    ],
    answer: "Directe ou indirecte (personne interposée)",
    explanation:
        "La sollicitation/agrément peut transiter par un intermédiaire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — « À tout moment »",
    question: "« À tout moment » signifie que la corruption peut être :",
    options: [
      "Antérieure ou postérieure à l’acte",
      "Seulement antérieure",
      "Seulement postérieure",
    ],
    answer: "Antérieure ou postérieure à l’acte",
    explanation: "Le pacte peut intervenir après l’acte (remerciement).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Acte facilité",
    question: "« Acte facilité par la fonction » vise notamment :",
    options: [
      "Monnayer un accès/renseignement obtenu grâce aux facilités de la fonction",
      "Percevoir une taxe",
      "Annuler une loi",
    ],
    answer:
        "Monnayer un accès/renseignement obtenu grâce aux facilités de la fonction",
    explanation:
        "Acte non strictement dans les attributions mais rendu possible par la position.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège concours — Mandat électif",
    question:
        "Les personnes investies d’un mandat électif public peuvent être auteurs de :",
    options: [
      "Corruption passive et trafic d’influence",
      "Concussion uniquement",
      "Aucune infraction de probité",
    ],
    answer: "Corruption passive et trafic d’influence",
    explanation: "432-11 vise aussi mandat électif public.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège concours — Concussion vs Corruption (clé)",
    question: "Différence la plus tranchée :",
    options: [
      "Concussion = perception indue de droits/taxes ; Corruption = avantage contre acte",
      "Concussion = cadeau ; Corruption = taxe",
      "Concussion = influence ; Corruption = amende",
    ],
    answer:
        "Concussion = perception indue de droits/taxes ; Corruption = avantage contre acte",
    explanation:
        "Concussion = sommes publiques indûment perçues ; corruption = pacte d’avantage.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // VRAI/FAUX CONCOURS — (76-105)
  // =========================================================
  const QuizQuestion(
    category: "Vrai/Faux — Concussion",
    question:
        "Vrai/Faux : la concussion peut être commise sans abus d’autorité.",
    options: ["Vrai", "Faux", "Uniquement si élu"],
    answer: "Vrai",
    explanation:
        "Le texte précise qu’il n’est pas nécessaire d’abuser de l’autorité ou d’employer menaces/manœuvres.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Concussion",
    question:
        "Vrai/Faux : la concussion porte uniquement sur des taxes au sens strict.",
    options: ["Vrai", "Faux", "Uniquement sur impôts d’État"],
    answer: "Faux",
    explanation:
        "Elle vise droits/contributions/impôts/taxes, et la jurisprudence inclut même salaires/indemnités/fournitures.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Concussion",
    question:
        "Vrai/Faux : si l’agent se trompe de bonne foi sur un texte, l’intention peut disparaître.",
    options: ["Vrai", "Faux", "Toujours coupable"],
    answer: "Vrai",
    explanation:
        "Erreur de fait ou mauvaise interprétation peut exclure l’intention.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Corruption",
    question:
        "Vrai/Faux : la corruption passive suppose nécessairement que l’agent soit à l’initiative.",
    options: ["Vrai", "Faux", "Seulement si somme élevée"],
    answer: "Faux",
    explanation:
        "Que l’agent sollicite ou agrée, c’est toujours corruption passive (dès lors qu’il a la qualité).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Corruption",
    question:
        "Vrai/Faux : l’exécution de l’acte promis n’est pas indispensable pour caractériser la corruption.",
    options: ["Vrai", "Faux", "Uniquement si pacte écrit"],
    answer: "Vrai",
    explanation: "Le pacte suffit ; suivi d’exécution indifférent.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Corruption",
    question:
        "Vrai/Faux : un avantage peut être versé à une association ou une société écran.",
    options: ["Vrai", "Faux", "Uniquement à la famille"],
    answer: "Vrai",
    explanation:
        "Avantage possible au profit d’un tiers, y compris personne morale.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Trafic d’influence",
    question:
        "Vrai/Faux : le trafic d’influence peut exister même si l’influence n’est jamais exercée.",
    options: ["Vrai", "Faux", "Seulement si décision obtenue"],
    answer: "Vrai",
    explanation:
        "Peu importe que l’influence soit vaine ou non exercée : l’accord suffit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Trafic d’influence",
    question:
        "Vrai/Faux : la décision recherchée doit forcément être illégale pour constituer le trafic d’influence.",
    options: ["Vrai", "Faux", "Uniquement si marché public"],
    answer: "Faux",
    explanation:
        "Même une décision régulière peut être visée : ce sont les moyens irréguliers qui caractérisent l’infraction.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Bande organisée",
    question: "Vrai/Faux : la bande organisée aggrave la corruption passive.",
    options: ["Vrai", "Faux", "Uniquement la concussion"],
    answer: "Vrai",
    explanation: "432-11 al.4.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Tentative",
    question:
        "Vrai/Faux : la tentative est punissable en concussion mais pas en corruption passive.",
    options: ["Vrai", "Faux", "Seulement pour trafic d’influence"],
    answer: "Vrai",
    explanation: "432-10 : tentative OUI ; 432-11 : tentative NON.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // MINI CAS PRATIQUES — QUALIFICATION + ARTICLE + PEINE (106-135)
  // =========================================================
  const QuizQuestion(
    category: "Cas — Qualification + Peine",
    question:
        "Un régisseur exige 20€ alors que le droit de place légal est 10€. Qualification + article ?",
    options: [
      "Concussion — 432-10",
      "Corruption passive — 432-11",
      "Trafic d’influence — 432-11 al.3",
    ],
    answer: "Concussion — 432-10",
    explanation:
        "Perception excédant ce qui est dû = concussion (C.A. Versailles 26/04/2006). Peine: 5 ans + 500 000 € (double du produit possible).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — Qualification + Peine",
    question:
        "Un agent public accepte 300€ pour accélérer un dossier relevant de sa compétence. Qualification ?",
    options: [
      "Corruption passive — 432-11",
      "Concussion — 432-10",
      "Trafic d’influence — 432-11 al.3",
    ],
    answer: "Corruption passive — 432-11",
    explanation:
        "Avantage contre acte de la fonction. Peine: 10 ans + 1 000 000 € (double du produit possible).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — Qualification + Peine",
    question:
        "Un élu est payé pour user de son réseau afin d’obtenir une décoration pour quelqu’un. Qualification ?",
    options: [
      "Trafic d’influence — 432-11 al.3",
      "Corruption passive — 432-11 al.1-2",
      "Concussion — 432-10",
    ],
    answer: "Trafic d’influence — 432-11 al.3",
    explanation:
        "Monnayer une influence (réelle/supposée) en vue d’obtenir une distinction. Peine: 10 ans + 1 000 000 €.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — Concussion (exonération)",
    question:
        "Un maire dispense volontairement son fils du paiement d’une redevance du domaine public prévue par la loi. Qualification ?",
    options: [
      "Concussion — 432-10 al.2",
      "Corruption passive — 432-11",
      "Trafic d’influence — 432-11 al.3",
    ],
    answer: "Concussion — 432-10 al.2",
    explanation:
        "Exonération/franchise accordée illégalement = concussion assimilée (jurisprudence). Peine: 5 ans + 500 000 €.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — Corruption (après l’acte)",
    question:
        "Un agent reçoit un cadeau après avoir rendu un service relevant de sa mission, car il avait « anticipé » la gratification. Qualification ?",
    options: [
      "Corruption passive",
      "Concussion",
      "Aucune infraction car postérieur",
    ],
    answer: "Corruption passive",
    explanation:
        "Le pacte peut être postérieur : gratification en remerciement d’un acte accompli.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — Aggravation",
    question:
        "Un réseau organisé d’agents publics accepte des avantages contre actes de fonction. Qualification + aggravation ?",
    options: [
      "Corruption passive aggravée — 432-11 al.4 (bande organisée)",
      "Concussion aggravée",
      "Trafic d’influence aggravé par réunion",
    ],
    answer: "Corruption passive aggravée — 432-11 al.4 (bande organisée)",
    explanation:
        "Bande organisée = aggravation prévue. Peine: 10 ans + 2 000 000 € (double du produit possible).",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // SÉRIES “ULTRA QCM” — MÉCANISMES, ÉLÉMENTS, PIÈGES (136-165)
  // =========================================================
  const QuizQuestion(
    category: "Concussion — Comparaison aux textes",
    question: "Pour caractériser l’illicéité en concussion, on compare :",
    options: [
      "La somme réclamée aux textes légaux/réglementaires autorisant la perception",
      "La somme aux revenus de l’agent",
      "La somme au barème privé de l’usager",
    ],
    answer:
        "La somme réclamée aux textes légaux/réglementaires autorisant la perception",
    explanation:
        "Le caractère illicite se juge au regard de ce que les textes autorisent à percevoir.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Concussion — Ordre de percevoir",
    question:
        "Celui qui ordonne à un subordonné de percevoir un droit non dû est :",
    options: ["Auteur principal du délit", "Simple complice", "Non punissable"],
    answer: "Auteur principal du délit",
    explanation:
        "Est puni comme concussionnaire celui qui ordonne la perception indue.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Concussion — Subordonné",
    question: "Le subordonné qui exécute sciemment l’ordre illégal peut être :",
    options: [
      "Complice (aide/assistance en connaissance)",
      "Auteur principal automatiquement",
      "Toujours non responsable",
    ],
    answer: "Complice (aide/assistance en connaissance)",
    explanation: "Complicité si aide et assistance sciemment apportées.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Corruption — Sollicitation",
    question: "La sollicitation en corruption passive implique :",
    options: [
      "Une démarche/initiative de l’agent demandant à être payé",
      "Un paiement obligatoire prévu par la loi",
      "Une menace nécessaire",
    ],
    answer: "Une démarche/initiative de l’agent demandant à être payé",
    explanation:
        "L’agent fait comprendre qu’il faut payer pour l’acte/abstention.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Corruption — Agrément",
    question: "L’agrément correspond à :",
    options: [
      "L’acceptation de la proposition faite par le particulier",
      "La fixation d’un barème public",
      "L’exonération d’une taxe",
    ],
    answer: "L’acceptation de la proposition faite par le particulier",
    explanation: "Accord de volontés = pacte de corruption.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Corruption — Direct/Indirect",
    question: "Une corruption « indirecte » suppose :",
    options: [
      "Un intermédiaire (personne interposée)",
      "Une signature obligatoire",
      "Une remise en espèces uniquement",
    ],
    answer: "Un intermédiaire (personne interposée)",
    explanation: "La sollicitation/agrément peut transiter par un tiers.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Trafic d’influence — Destinataire",
    question: "Le destinataire à influencer doit être :",
    options: [
      "Une autorité/administration disposant d’un pouvoir de décision",
      "Un ami sans fonction",
      "Un particulier sans pouvoir",
    ],
    answer: "Une autorité/administration disposant d’un pouvoir de décision",
    explanation:
        "L’influence vise une autorité/administration publique décisionnaire.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Trafic d’influence — Décision régulière",
    question: "En trafic d’influence, si la décision obtenue est régulière :",
    options: [
      "L’infraction peut quand même être constituée",
      "L’infraction est exclue",
      "C’est une contravention",
    ],
    answer: "L’infraction peut quand même être constituée",
    explanation: "Ce sont les moyens (influence coupable) qui comptent.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // BONUS — V/F “FLASH” (166-200) pour révisions rapides
  // =========================================================
  const QuizQuestion(
    category: "Flash V/F — 432-10",
    question:
        "Vrai/Faux : la concussion peut porter sur une prestation en nature.",
    options: ["Vrai", "Faux", "Seulement argent"],
    answer: "Vrai",
    explanation: "Notion large de somme (prestations en nature admises).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Flash V/F — 432-10",
    question:
        "Vrai/Faux : la concussion nécessite un pacte entre deux personnes.",
    options: ["Vrai", "Faux", "Uniquement si élu"],
    answer: "Faux",
    explanation: "Pas de pacte : perception indue suffit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Flash V/F — 432-11",
    question:
        "Vrai/Faux : en corruption passive, l’avantage peut être une promesse.",
    options: ["Vrai", "Faux", "Uniquement don réalisé"],
    answer: "Vrai",
    explanation: "Offres/promesses/dons/présents/avantages.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Flash V/F — 432-11",
    question:
        "Vrai/Faux : la corruption passive exige que l’avantage soit « sans droit ».",
    options: ["Vrai", "Faux", "Seulement si somme en espèces"],
    answer: "Vrai",
    explanation: "Le texte vise « sans droit ».",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Flash V/F — 432-11",
    question:
        "Vrai/Faux : la bande organisée change la peine d’emprisonnement en corruption passive.",
    options: ["Vrai", "Faux", "Seulement amende"],
    answer: "Faux",
    explanation:
        "La peine d’emprisonnement reste à 10 ans, l’amende passe à 2 000 000 €.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Flash V/F — Trafic",
    question:
        "Vrai/Faux : en trafic d’influence, l’influence doit être exercée par l’auteur lui-même.",
    options: ["Vrai", "Faux", "Seulement si influence réelle"],
    answer: "Vrai",
    explanation:
        "La fiche précise une influence directe : l’intéressé est censé l’exercer lui-même.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Flash V/F — Trafic",
    question:
        "Vrai/Faux : en trafic d’influence, peu importe que l’avantage demandé profite à un tiers.",
    options: ["Vrai", "Faux", "Uniquement si tiers = famille"],
    answer: "Vrai",
    explanation: "Avantage pour lui-même ou pour autrui.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Flash V/F — Réduction",
    question:
        "Vrai/Faux : une réduction de peine est prévue en corruption/traﬁc si l’auteur aide à identifier d’autres auteurs.",
    options: ["Vrai", "Faux", "Seulement en concussion"],
    answer: "Vrai",
    explanation:
        "432-11-1 : réduction/exemption de peine prévue pour corruption et trafic d’influence.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Concussion — Auteur",
    question: "Peut être auteur de concussion :",
    options: [
      "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
      "Tout particulier",
      "Uniquement un élu",
    ],
    answer:
        "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
    explanation:
        "L’article 432-10 vise uniquement ces catégories de personnes.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Concussion — Élément matériel",
    question: "La perception indue peut consister à :",
    options: [
      "Recevoir, exiger ou ordonner de percevoir",
      "Uniquement recevoir",
      "Uniquement menacer pour obtenir",
    ],
    answer: "Recevoir, exiger ou ordonner de percevoir",
    explanation:
        "Les trois comportements suffisent, sans manœuvre ni violence.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Concussion — Moyen",
    question: "Les moyens utilisés pour percevoir la somme :",
    options: [
      "Importent peu",
      "Doivent être des menaces",
      "Doivent être des manœuvres frauduleuses",
    ],
    answer: "Importent peu",
    explanation: "Ce qui compte est le caractère illégal de la perception.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Concussion — Somme",
    question: "La notion de somme inclut :",
    options: [
      "L’argent et les prestations en nature",
      "Uniquement l’argent",
      "Uniquement les salaires",
    ],
    answer: "L’argent et les prestations en nature",
    explanation:
        "La jurisprudence inclut les avantages en nature (repas, fournitures…).",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Concussion — Droits",
    question: "La notion de « droits » inclut :",
    options: [
      "Les salaires et indemnités",
      "Uniquement les impôts",
      "Uniquement les taxes locales",
    ],
    answer: "Les salaires et indemnités",
    explanation:
        "La jurisprudence inclut traitements, indemnités et fournitures.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Concussion — Exonération",
    question: "Accorder illégalement une exonération de taxe constitue :",
    options: [
      "Une concussion par abstention",
      "Une corruption",
      "Un trafic d’influence",
    ],
    answer: "Une concussion par abstention",
    explanation: "Prévue à l’alinéa 2 de l’article 432-10.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Concussion — Élément moral",
    question: "L’élément moral exige :",
    options: [
      "La conscience que la somme n’était pas due ou excédait ce qui était dû",
      "Une intention d’enrichissement personnel",
      "Un mobile politique",
    ],
    answer:
        "La conscience que la somme n’était pas due ou excédait ce qui était dû",
    explanation: "Les mobiles sont indifférents.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Concussion — Erreur",
    question: "L’erreur de fait ou de droit :",
    options: [
      "Peut faire disparaître l’intention",
      "Aggrave l’infraction",
      "Est sans effet",
    ],
    answer: "Peut faire disparaître l’intention",
    explanation:
        "Une mauvaise interprétation des textes exclut l’intention frauduleuse.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Concussion — Peines",
    question: "Peines principales de la concussion :",
    options: [
      "5 ans d’emprisonnement et 500 000 € d’amende",
      "10 ans et 1 000 000 €",
      "3 ans et 45 000 €",
    ],
    answer: "5 ans d’emprisonnement et 500 000 € d’amende",
    explanation: "Article 432-10 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vrai/Faux — Concussion",
    question:
        "Vrai ou Faux : la concussion comporte des circonstances aggravantes.",
    options: ["Vrai", "Faux", "Uniquement en bande organisée"],
    answer: "Faux",
    explanation: "Aucune circonstance aggravante n’est prévue.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vrai/Faux — Concussion",
    question: "Vrai ou Faux : la tentative de concussion est punissable.",
    options: ["Vrai", "Faux", "Seulement pour l’alinéa 2"],
    answer: "Vrai",
    explanation: "Prévue par l’alinéa 3 de l’article 432-10.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Concussion",
    question:
        "Un maire impose une somme non prévue par les textes pour chaque logement construit. Qualification ?",
    options: ["Concussion", "Corruption passive", "Trafic d’influence"],
    answer: "Concussion",
    explanation:
        "Perception illégale de droits publics (Cass. crim., 16 mai 2001).",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // CORRUPTION PASSIVE — 432-11 CP
  // =========================================================
  const QuizQuestion(
    category: "Corruption passive — Définition",
    question: "La corruption passive consiste à :",
    options: [
      "Solliciter ou accepter un avantage pour un acte de la fonction",
      "Exiger une taxe illégale",
      "Abuser de son influence supposée",
    ],
    answer: "Solliciter ou accepter un avantage pour un acte de la fonction",
    explanation: "Article 432-11 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Corruption passive — Qualification",
    question: "La qualification passive dépend :",
    options: [
      "De la qualité de l’auteur",
      "De celui qui propose l’argent",
      "Du moment du versement",
    ],
    answer: "De la qualité de l’auteur",
    explanation:
        "Agent public = corruption passive, particulier = corruption active.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Corruption passive — Auteur",
    question: "Peut être auteur de corruption passive :",
    options: [
      "Un dépositaire de l’autorité publique",
      "Un particulier",
      "Un simple usager",
    ],
    answer: "Un dépositaire de l’autorité publique",
    explanation:
        "Sont aussi visés les élus et personnes chargées d’une mission de service public.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Corruption passive — Acte",
    question: "La corruption peut porter sur :",
    options: [
      "Un acte, une abstention ou un acte facilité par la fonction",
      "Uniquement un acte illégal",
      "Uniquement une décision écrite",
    ],
    answer: "Un acte, une abstention ou un acte facilité par la fonction",
    explanation: "Champ très large de l’acte de la fonction.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Corruption passive — Moment",
    question: "Le pacte de corruption peut intervenir :",
    options: ["Avant ou après l’acte", "Uniquement avant", "Uniquement après"],
    answer: "Avant ou après l’acte",
    explanation: "La gratification postérieure est punissable.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Corruption passive — Avantage",
    question: "L’avantage peut être :",
    options: [
      "Pour l’auteur ou pour un tiers",
      "Uniquement pour l’auteur",
      "Uniquement en argent",
    ],
    answer: "Pour l’auteur ou pour un tiers",
    explanation: "Tiers physique ou personne morale.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Corruption passive — Élément moral",
    question: "Il faut établir :",
    options: [
      "La conscience de violer son devoir de probité",
      "Un enrichissement effectif",
      "Un préjudice à l’État",
    ],
    answer: "La conscience de violer son devoir de probité",
    explanation: "Le mobile importe peu.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Corruption passive — Aggravation",
    question: "La corruption est aggravée lorsqu’elle est commise :",
    options: ["En bande organisée", "En réunion", "Avec arme"],
    answer: "En bande organisée",
    explanation: "Article 432-11 al.4 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Corruption passive — Peines",
    question: "Peines de la corruption passive simple :",
    options: [
      "10 ans et 1 000 000 € d’amende",
      "5 ans et 500 000 €",
      "3 ans et 45 000 €",
    ],
    answer: "10 ans et 1 000 000 € d’amende",
    explanation: "Article 432-11 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vrai/Faux — Corruption",
    question:
        "Vrai ou Faux : la tentative de corruption passive est punissable.",
    options: ["Vrai", "Faux", "Uniquement en bande organisée"],
    answer: "Faux",
    explanation: "La tentative n’est pas punissable.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Corruption",
    question:
        "Un policier accepte de l’argent pour ne pas dresser un PV. Qualification ?",
    options: ["Corruption passive", "Concussion", "Trafic d’influence"],
    answer: "Corruption passive",
    explanation:
        "Lien direct entre avantage et abstention d’un acte de la fonction.",
    difficulty: "Facile",
  ),

  // =========================================================
  // TRAFIC D’INFLUENCE — 432-11 AL.3 CP
  // =========================================================
  const QuizQuestion(
    category: "Trafic d’influence — Définition",
    question: "Le trafic d’influence consiste à :",
    options: [
      "Abuser de son influence réelle ou supposée contre avantage",
      "Exiger une taxe illégale",
      "Accepter un cadeau pour un acte de la fonction",
    ],
    answer: "Abuser de son influence réelle ou supposée contre avantage",
    explanation: "Article 432-11 al.3 CP.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Trafic d’influence — Influence",
    question: "L’influence peut être :",
    options: ["Réelle ou supposée", "Uniquement réelle", "Uniquement supposée"],
    answer: "Réelle ou supposée",
    explanation: "Peu importe qu’elle soit effective.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Trafic d’influence — Objet",
    question: "L’influence vise à obtenir :",
    options: [
      "Une décision favorable d’une autorité publique",
      "Un acte personnel privé",
      "Un simple renseignement public",
    ],
    answer: "Une décision favorable d’une autorité publique",
    explanation: "Décorations, emplois, marchés, décisions.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Trafic d’influence — Acte",
    question: "L’auteur agit :",
    options: [
      "En dehors du cadre strict de sa fonction",
      "Uniquement dans sa fonction",
      "Sans aucun lien avec sa position",
    ],
    answer: "En dehors du cadre strict de sa fonction",
    explanation: "Il abuse du crédit lié à sa position.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Trafic d’influence — Peines",
    question: "Peines du trafic d’influence simple :",
    options: [
      "10 ans et 1 000 000 € d’amende",
      "5 ans et 500 000 €",
      "3 ans et 45 000 €",
    ],
    answer: "10 ans et 1 000 000 € d’amende",
    explanation: "Alignées sur la corruption.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vrai/Faux — Trafic d’influence",
    question:
        "Vrai ou Faux : la tentative de trafic d’influence est punissable.",
    options: ["Vrai", "Faux", "Seulement si influence réelle"],
    answer: "Faux",
    explanation: "La tentative n’est pas punissable.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Trafic d’influence",
    question:
        "Un élu accepte de l’argent pour user de son réseau afin d’obtenir un marché public. Qualification ?",
    options: ["Trafic d’influence", "Corruption passive", "Concussion"],
    answer: "Trafic d’influence",
    explanation: "Abus d’influence réelle ou supposée.",
    difficulty: "Moyenne",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizProbitePA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName = '/pa/nation/quiz/probite';
  final String uid;
  final String email;

  const QuizProbitePA({super.key, required this.uid, required this.email});

  @override
  State<QuizProbitePA> createState() => _QuizProbitePAState();
}

class _QuizProbitePAState extends State<QuizProbitePA>
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
  static const _introHiddenKey = 'intro_pa_probite';
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
        ? questionProbite
        : questionProbite
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
            'mode': UserContextService.I.modeOrDefault,'module_name': 'Crimes & délits contre la nation',
            'quiz_name': 'Probité',
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
      await _sb.from('quiz_probite').insert({
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
      debugPrint('❌ quiz_probite insert failed: $e');
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
      'source_file': 'pa_quiz_probite',
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
                            icon: Icons.workspace_premium_rounded,
                            title: 'Probité',
                            description: 'Étudie les infractions contre la probité : corruption active et passive, trafic d’influence, favoritisme, éléments constitutifs et sanctions.',
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
