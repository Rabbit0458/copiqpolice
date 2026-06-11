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

final List<QuizQuestion> questionCrimesDelitsNation = [
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
    category: "Faux / Usage de faux (441-1) — Définition",
    question: "Le faux (441-1 CP) consiste en :",
    options: [
      "Toute altération de la vérité, de nature à causer un préjudice, dans un support ayant valeur probatoire",
      "Toute erreur sans conséquence juridique",
      "Tout propos insultant envers une administration",
    ],
    answer:
        "Toute altération de la vérité, de nature à causer un préjudice, dans un support ayant valeur probatoire",
    explanation:
        "441-1 : altération de la vérité + nature à causer un préjudice + support destiné/ayant pour effet d’établir la preuve d’un droit ou d’un fait à conséquences juridiques.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-4 — Définition",
    question: "441-4 réprime :",
    options: [
      "Faux/usage dans écriture publique/authentique ou enregistrement ordonné",
      "Obtention indue d’un document administratif",
      "Faux certificats/attestations",
    ],
    answer:
        "Faux/usage dans écriture publique/authentique ou enregistrement ordonné",
    explanation:
        "Texte spécial : écriture publique/authentique + enregistrements.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-4 — Préjudice",
    question: "Dans 441-4, le préjudice éventuel :",
    options: [
      "Résulte de l’atteinte à la foi publique",
      "Doit être chiffré",
      "Est exclu",
    ],
    answer: "Résulte de l’atteinte à la foi publique",
    explanation:
        "Valeur probatoire particulière des actes publics/authentiques.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-4 — Peine simple",
    question: "441-4 (simple) :",
    options: ["10 ans", "7 ans + 100k", "5 ans + 75k"],
    answer: "10 ans",
    explanation: "Tableau : 10 ans d’emprisonnement.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-4 — Aggravation",
    question: "Aggravation 441-4 si :",
    options: ["Dépositaire/Mission SP en exercice", "En réunion", "La nuit"],
    answer: "Dépositaire/Mission SP en exercice",
    explanation: "441-4 al.3.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-4 — Peine aggravée",
    question: "441-4 aggravé :",
    options: ["15 ans de réclusion", "10 ans", "7 ans + 100k"],
    answer: "15 ans de réclusion",
    explanation: "Crime : 15 ans (tableau).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-4",
    question:
        "Vrai/Faux : 441-4 peut viser un enregistrement ordonné par l’autorité publique.",
    options: ["Vrai", "Faux", "Uniquement écrit"],
    answer: "Vrai",
    explanation:
        "Le texte vise aussi enregistrements sonores/visuels/audiovisuels.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège — 441-4 vs 441-2",
    question: "Falsifier un PV d’OPJ (acte de procédure) relève plutôt de :",
    options: ["441-4", "441-2", "441-6"],
    answer: "441-4",
    explanation: "Acte judiciaire/procédural = écriture publique/authentique.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Réflexe — 441-4",
    question: "Peine simple 441-4 :",
    options: ["10 ans", "5 ans + 75k", "3 ans + 45k"],
    answer: "10 ans",
    explanation: "Tableau 441-4.",
    difficulty: "Facile",
  ),

  // mini-cas 9-25 (17)
  const QuizQuestion(
    category: "Cas — 441-4",
    question: "Faux acte notarié :",
    options: ["441-4", "441-1", "441-7"],
    answer: "441-4",
    explanation: "Acte authentique = 441-4.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — 441-4 usage",
    question: "Utiliser un faux acte authentique en banque :",
    options: ["Usage 441-4", "441-6", "441-5"],
    answer: "Usage 441-4",
    explanation: "Usage d’un faux en écriture authentique.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — 441-4 aggravé",
    question: "Officier public falsifie un acte dans sa mission :",
    options: ["441-4 aggravé (15 ans)", "441-2 aggravé", "441-1"],
    answer: "441-4 aggravé (15 ans)",
    explanation: "Qualité + exercice = al.3 (crime).",
    difficulty: "Difficile",
  ),

  // =======================
  // 441-5 — DÉLIVRANCE INDUE (26-60)
  // =======================
  const QuizQuestion(
    category: "441-5 — Définition",
    question: "441-5 :",
    options: [
      "Procurer frauduleusement à autrui un document administratif authentique",
      "Se faire délivrer indûment un document",
      "Falsifier un document administratif",
    ],
    answer:
        "Procurer frauduleusement à autrui un document administratif authentique",
    explanation: "Acteur = celui qui procure/délivre à autrui.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-5 — Authentique",
    question: "441-5 concerne :",
    options: ["Docs authentiques", "Docs falsifiés", "Uniquement attestations"],
    answer: "Docs authentiques",
    explanation: "Ce n’est pas un faux : c’est une délivrance indue.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-5 — Élément moral",
    question: "Il faut :",
    options: [
      "Connaissance que le bénéficiaire n’y a pas droit",
      "Imprudence",
      "Erreur de bonne foi",
    ],
    answer: "Connaissance que le bénéficiaire n’y a pas droit",
    explanation: "Remise en connaissance de cause.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-5 — Aggravation 1°",
    question: "Aggravé si auteur :",
    options: ["Dépositaire/Mission SP en exercice", "Mineur", "Témoin"],
    answer: "Dépositaire/Mission SP en exercice",
    explanation: "441-5 1°.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-5 — Aggravation 2°",
    question: "Aggravé si :",
    options: ["Habituelle", "De nuit", "Avec casier judiciaire"],
    answer: "Habituelle",
    explanation: "441-5 2°.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-5 — Aggravation 3°",
    question: "Aggravé si dessein :",
    options: [
      "Faciliter un crime/procurer impunité",
      "Éviter un contrôle",
      "Gagner du temps",
    ],
    answer: "Faciliter un crime/procurer impunité",
    explanation: "441-5 3°.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-5 — Peine simple",
    question: "441-5 simple :",
    options: ["5 ans + 75 000 €", "2 ans + 30 000 €", "3 ans + 45 000 €"],
    answer: "5 ans + 75 000 €",
    explanation: "Tableau 441-5.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-5 — Peine aggravée",
    question: "441-5 aggravée :",
    options: ["7 ans + 100 000 €", "10 ans", "15 ans réclusion"],
    answer: "7 ans + 100 000 €",
    explanation: "Tableau 441-5 aggravée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-5",
    question:
        "Vrai/Faux : 441-5 exige une falsification matérielle du document.",
    options: ["Vrai", "Faux", "Seulement si permis"],
    answer: "Faux",
    explanation: "C’est un document authentique délivré indûment.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège — 441-5 vs 441-6",
    question: "Auteur = celui qui remet/procure à autrui :",
    options: ["441-5", "441-6", "441-7"],
    answer: "441-5",
    explanation: "441-6 = bénéficiaire ; 441-5 = procure à autrui.",
    difficulty: "Difficile",
  ),

  // mini-cas 36-60 (25)
  const QuizQuestion(
    category: "Cas — 441-5",
    question: "Fonctionnaire donne un document à un non-droit :",
    options: ["441-5", "441-6", "441-2"],
    answer: "441-5",
    explanation: "Délivrance indue.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — 441-5",
    question:
        "Particulier fait remettre le document par un tiers de bonne foi :",
    options: ["441-5 possible", "Jamais 441-5", "Seulement 441-6"],
    answer: "441-5 possible",
    explanation: "Procurer = même si remise via tiers de bonne foi.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-6 — Définition",
    question: "441-6 al.1 :",
    options: [
      "Se faire délivrer indûment un document authentique par moyen frauduleux",
      "Falsifier un document administratif",
      "Délivrer à autrui un document authentique",
    ],
    answer:
        "Se faire délivrer indûment un document authentique par moyen frauduleux",
    explanation: "Auteur = bénéficiaire (ou celui qui obtient pour autrui).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-6 — Fraude",
    question: "Moyen frauduleux =",
    options: [
      "Très large (fausse déclaration, tiers, manœuvres…)",
      "Uniquement faux matériel",
      "Uniquement violence",
    ],
    answer: "Très large (fausse déclaration, tiers, manœuvres…)",
    explanation: "« Quelque moyen frauduleux que ce soit ».",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-6 — Organismes",
    question: "441-6 vise aussi :",
    options: [
      "Organisme chargé mission de service public (ex : protection sociale)",
      "Entreprise privée sans mission SP",
      "Association sportive privée",
    ],
    answer:
        "Organisme chargé mission de service public (ex : protection sociale)",
    explanation: "Extension prévue par le cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-6 — Alinéa 2",
    question: "441-6 al.2 :",
    options: [
      "Fausse/incomplète déclaration pour allocation/prestation/paiement/avantage indu",
      "Falsification de CNI",
      "Faux en écriture publique",
    ],
    answer:
        "Fausse/incomplète déclaration pour allocation/prestation/paiement/avantage indu",
    explanation: "Incrimination assimilée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-6 — Consommation al.2",
    question: "Al.2 : l’avantage doit être versé ?",
    options: ["Non (but suffit)", "Oui obligatoire", "Seulement si écrit"],
    answer: "Non (but suffit)",
    explanation: "Obtenir/tenter d’obtenir (ou faire obtenir).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-6 — Élément moral",
    question: "Il faut :",
    options: [
      "Conscience d’obtenir indûment + volonté d’utiliser moyen frauduleux",
      "Erreur de bonne foi",
      "Mobile lucratif obligatoire",
    ],
    answer:
        "Conscience d’obtenir indûment + volonté d’utiliser moyen frauduleux",
    explanation: "Intention frauduleuse.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-6 — Aggravantes",
    question: "441-6 comporte :",
    options: ["Aucune aggravante", "Réunion", "Arme"],
    answer: "Aucune aggravante",
    explanation: "Ta page : IV AUCUNE.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-6 — Peines",
    question: "441-6 :",
    options: ["2 ans + 30 000 €", "3 ans + 45 000 €", "5 ans + 75 000 €"],
    answer: "2 ans + 30 000 €",
    explanation: "Tableau 441-6.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-6",
    question: "Vrai/Faux : 441-6 exige un préjudice effectif.",
    options: ["Vrai", "Faux", "Seulement si allocation"],
    answer: "Faux",
    explanation:
        "Le cours précise que l’infraction peut être qualifiée sans préjudice.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — 441-6 vs 441-2",
    question:
        "Fausse date d’entrée sur formulaire de séjour (doc ensuite délivré authentique) :",
    options: ["441-6", "441-2", "441-4"],
    answer: "441-6",
    explanation: "Fraude à l’obtention, doc authentique.",
    difficulty: "Difficile",
  ),

  // mini-cas 11-45 (35)
  const QuizQuestion(
    category: "Cas — 441-6",
    question: "Mensonge pour obtenir un plan de chasse :",
    options: ["441-6", "441-2", "441-5"],
    answer: "441-6",
    explanation: "Obtention indue par fausse déclaration.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — 441-6",
    question: "Mariage de complaisance pour titre de séjour :",
    options: ["441-6 (manœuvres)", "441-2", "441-7"],
    answer: "441-6 (manœuvres)",
    explanation:
        "Manœuvres frauduleuses pour obtention indue (selon ton cours).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — 441-6 al.2",
    question: "Omission volontaire de revenus pour aide sociale :",
    options: ["441-6 al.2", "441-7", "441-5"],
    answer: "441-6 al.2",
    explanation: "Déclaration incomplète volontaire + avantage indu.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — 441-6 al.2",
    question: "Déclaration fausse verbale puis consignée et signée :",
    options: ["Peut relever 441-6 al.2", "Jamais 441-6", "Toujours 441-7"],
    answer: "Peut relever 441-6 al.2",
    explanation:
        "Le cours admet fausse déclaration verbale (selon modalités) / ou écrite.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — acteur",
    question: "Celui qui ment pour obtenir pour lui-même :",
    options: ["441-6", "441-5", "441-2"],
    answer: "441-6",
    explanation: "Bénéficiaire = 441-6.",
    difficulty: "Facile",
  ),

  // =======================
  // 441-7 — ATTESTATIONS/CERTIFICATS (46-100)
  // =======================
  const QuizQuestion(
    category: "441-7 — Définition",
    question: "441-7 réprime :",
    options: [
      "Établir inexact / falsifier sincère / usage",
      "Obtenir indûment un permis",
      "Délivrer indûment une CNI",
    ],
    answer: "Établir inexact / falsifier sincère / usage",
    explanation: "Texte spécial attestations/certificats.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-7 — Écrit",
    question: "Condition :",
    options: ["Écrit obligatoire", "Oral suffit", "SMS oral suffit"],
    answer: "Écrit obligatoire",
    explanation: "Renseignements oraux ne suffisent pas.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-7 — Profit d’un tiers",
    question: "Le document doit être :",
    options: [
      "Établi au profit d’autrui",
      "Pour soi-même",
      "Toujours administratif",
    ],
    answer: "Établi au profit d’autrui",
    explanation: "Attestation pour soi-même exclue (selon ton cours).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-7 — Faits matériellement inexacts",
    question: "Cela vise :",
    options: ["Faits objectifs vérifiables", "Opinions", "Suppositions"],
    answer: "Faits objectifs vérifiables",
    explanation: "Éléments susceptibles de preuve contraire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-7 — Consommation",
    question: "Établissement est consommé :",
    options: [
      "Dès rédaction + signature",
      "Uniquement si usage",
      "Uniquement si préjudice",
    ],
    answer: "Dès rédaction + signature",
    explanation: "Indépendant de l’usage futur.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-7 — Élément moral",
    question: "Il faut :",
    options: ["Connaissance de l’inexactitude", "Imprudence", "Bonne foi"],
    answer: "Connaissance de l’inexactitude",
    explanation: "Intention : savoir que c’est inexact.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-7 — Usage",
    question: "Usage 441-7 suppose :",
    options: [
      "Volonté d’user + connaissance fausseté",
      "Détention seule",
      "Abstention",
    ],
    answer: "Volonté d’user + connaissance fausseté",
    explanation: "Comme l’usage de faux : acte + connaissance.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-7 — Aggravation al.5",
    question: "Aggravé si :",
    options: [
      "But préjudice Trésor/patrimoine ou titre de séjour/protection éloignement",
      "En réunion",
      "Avec arme",
    ],
    answer:
        "But préjudice Trésor/patrimoine ou titre de séjour/protection éloignement",
    explanation: "Selon ton cours (alinéa 5).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-7 — Peine simple",
    question: "441-7 simple :",
    options: ["1 an + 15 000 €", "2 ans + 30 000 €", "3 ans + 45 000 €"],
    answer: "1 an + 15 000 €",
    explanation: "Tableau 441-7.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-7 — Peine aggravée",
    question: "441-7 aggravée :",
    options: ["3 ans + 45 000 €", "5 ans + 75 000 €", "7 ans + 100 000 €"],
    answer: "3 ans + 45 000 €",
    explanation: "Tableau 441-7 aggravé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-7",
    question: "Vrai/Faux : l’auteur doit prévoir l’usage futur par le tiers.",
    options: ["Vrai", "Faux", "Seulement si juge"],
    answer: "Faux",
    explanation: "Peu importe qu’il ait prévu l’usage (cours).",
    difficulty: "Difficile",
  ),

  // 57-100 mini-cas + pièges (44 items)
  const QuizQuestion(
    category: "Cas — 441-7",
    question: "Attestation mensongère pour prud’hommes :",
    options: ["441-7", "441-6", "441-2"],
    answer: "441-7",
    explanation: "Attestation écrite inexacte en faveur d’un tiers.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas — 441-7",
    question: "Falsifier une attestation sincère (modifier date) :",
    options: ["441-7", "441-2", "441-6"],
    answer: "441-7",
    explanation: "Falsification d’attestation sincère.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — 441-7 usage",
    question: "Produire en divorce un certificat de mariage fabriqué :",
    options: [
      "Usage 441-2/441-4 selon nature, ici 441-2 si doc admin",
      "441-6",
      "Aucune",
    ],
    answer: "Usage 441-2/441-4 selon nature, ici 441-2 si doc admin",
    explanation:
        "Si certificat de mariage = doc admin (selon ton cours), usage doc admin falsifié.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — 441-7 vs 441-1",
    question: "Attestation = texte spécial :",
    options: ["441-7 prioritaire", "441-1 toujours", "441-6 toujours"],
    answer: "441-7 prioritaire",
    explanation: "Texte spécial pour attestations/certificats.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-7",
    question:
        "Vrai/Faux : une attestation sur l’honneur faite pour soi-même entre dans 441-7.",
    options: ["Vrai", "Faux", "Seulement si signée"],
    answer: "Faux",
    explanation:
        "Le cours indique que ce n’est pas dans le champ (profit d’un tiers).",
    difficulty: "Difficile",
  ),

  // =======================
  // TENTATIVE / COMPLICITÉ / PM (101-110)
  // =======================
  const QuizQuestion(
    category: "Tentative — 441-9",
    question: "La tentative des délits 441-1 à 441-7 :",
    options: ["Est punissable (441-9)", "Ne l’est jamais", "Seulement 441-1"],
    answer: "Est punissable (441-9)",
    explanation: "Texte spécial 441-9.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Complicité — Principe",
    question: "La complicité est :",
    options: [
      "Punissable (règles générales)",
      "Jamais punissable",
      "Uniquement si arme",
    ],
    answer: "Punissable (règles générales)",
    explanation: "Aide/assistance, provocation, instructions (121-6/121-7).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Personnes morales — 441-12",
    question: "PM pénalement responsables :",
    options: ["Oui (441-12)", "Non", "Seulement associations"],
    answer: "Oui (441-12)",
    explanation: "Selon tes pages : responsabilité PM prévue.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question: "Faux/usage de faux général :",
    options: ["441-1", "441-2", "441-6"],
    answer: "441-1",
    explanation: "Texte général.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question: "Faux doc administratif :",
    options: ["441-2", "441-5", "441-7"],
    answer: "441-2",
    explanation: "Texte spécial doc admin.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question: "Faux écriture publique/authentique :",
    options: ["441-4", "441-1", "441-6"],
    answer: "441-4",
    explanation: "Texte spécial.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question: "Délivrance indue doc administratif :",
    options: ["441-5", "441-6", "441-2"],
    answer: "441-5",
    explanation: "Procure à autrui.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question: "Obtention indue doc administratif :",
    options: ["441-6", "441-5", "441-1"],
    answer: "441-6",
    explanation: "Se fait délivrer par fraude.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question: "Faux certificats/attestations :",
    options: ["441-7", "441-2", "441-6"],
    answer: "441-7",
    explanation: "Texte spécial attestations.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peine",
    question: "Peine 441-6 :",
    options: ["2 ans + 30k", "3 ans + 45k", "5 ans + 75k"],
    answer: "2 ans + 30k",
    explanation: "Tableau 441-6.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peine",
    question: "Peine 441-5 simple :",
    options: ["5 ans + 75k", "2 ans + 30k", "1 an + 15k"],
    answer: "5 ans + 75k",
    explanation: "Tableau 441-5.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peine",
    question: "Peine 441-2 simple :",
    options: ["5 ans + 75k", "3 ans + 45k", "2 ans + 30k"],
    answer: "5 ans + 75k",
    explanation: "Tableau 441-2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peine",
    question: "Peine 441-1 :",
    options: ["3 ans + 45k", "5 ans + 75k", "10 ans"],
    answer: "3 ans + 45k",
    explanation: "Tableau 441-1.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peine",
    question: "Peine 441-4 simple :",
    options: ["10 ans", "7 ans + 100k", "3 ans + 45k"],
    answer: "10 ans",
    explanation: "Tableau 441-4.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Réflexe — Peine",
    question: "Peine 441-4 aggravé :",
    options: ["15 ans réclusion", "10 ans", "7 ans + 100k"],
    answer: "15 ans réclusion",
    explanation: "Crime (al.3).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peine",
    question: "Peine 441-7 simple :",
    options: ["1 an + 15k", "2 ans + 30k", "3 ans + 45k"],
    answer: "1 an + 15k",
    explanation: "Tableau 441-7.",
    difficulty: "Facile",
  ),

  // 21-60 — Vrai/Faux (pièges)
  const QuizQuestion(
    category: "Vrai/Faux — Spécialité",
    question: "Vrai/Faux : si doc administratif, 441-2 prime sur 441-1.",
    options: ["Vrai", "Faux", "Toujours 441-7"],
    answer: "Vrai",
    explanation: "Texte spécial généralement appliqué.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-6",
    question: "Vrai/Faux : 441-6 exige une falsification matérielle.",
    options: ["Vrai", "Faux", "Seulement si permis"],
    answer: "Faux",
    explanation: "Fraude à l’obtention d’un doc authentique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-5",
    question:
        "Vrai/Faux : 441-5 vise un document authentique délivré indûment.",
    options: ["Vrai", "Faux", "Seulement si CNI"],
    answer: "Vrai",
    explanation: "Oui, pas un faux matériel.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Usage",
    question: "Vrai/Faux : l’usage nécessite un acte positif.",
    options: ["Vrai", "Faux", "Uniquement 441-1"],
    answer: "Vrai",
    explanation: "Usage ≠ détention.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-7",
    question: "Vrai/Faux : 441-7 peut être constitué sans usage du document.",
    options: ["Vrai", "Faux", "Uniquement si aggravé"],
    answer: "Vrai",
    explanation: "Établissement consommé dès signature.",
    difficulty: "Moyenne",
  ),

  // 61-110 — Cas pratiques “flash” (50)
  const QuizQuestion(
    category: "Cas flash — Qualification",
    question: "Modifier physiquement un titre de séjour :",
    options: ["441-2", "441-6", "441-5"],
    answer: "441-2",
    explanation: "Falsification doc administratif.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas flash — Qualification",
    question:
        "Mentir sur formulaire pour obtenir titre de séjour authentique :",
    options: ["441-6", "441-2", "441-4"],
    answer: "441-6",
    explanation: "Obtention indue par moyen frauduleux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas flash — Qualification",
    question: "Agent délivre permis à non-droit :",
    options: ["441-5", "441-6", "441-2"],
    answer: "441-5",
    explanation: "Délivrance indue.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas flash — Qualification",
    question: "Attestation mensongère signée pour un ami :",
    options: ["441-7", "441-1", "441-6"],
    answer: "441-7",
    explanation: "Texte spécial attestations.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas flash — Qualification",
    question: "Utiliser un permis falsifié au contrôle :",
    options: ["Usage 441-2", "441-6", "441-5"],
    answer: "Usage 441-2",
    explanation: "Usage d’un doc admin falsifié.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas flash — Qualification",
    question: "Omettre revenu pour prestation sociale :",
    options: ["441-6 al.2", "441-7", "441-5"],
    answer: "441-6 al.2",
    explanation: "Déclaration incomplète volontaire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas flash — Qualification",
    question: "Faux acte notarié fabriqué :",
    options: ["441-4", "441-2", "441-7"],
    answer: "441-4",
    explanation: "Acte authentique.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas flash — Peine",
    question: "Qualification 441-6 → peine :",
    options: ["2 ans + 30k", "3 ans + 45k", "5 ans + 75k"],
    answer: "2 ans + 30k",
    explanation: "Tableau 441-6.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas flash — Peine",
    question: "Qualification 441-2 simple → peine :",
    options: ["5 ans + 75k", "2 ans + 30k", "1 an + 15k"],
    answer: "5 ans + 75k",
    explanation: "Tableau 441-2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas flash — Peine",
    question: "Qualification 441-7 simple → peine :",
    options: ["1 an + 15k", "2 ans + 30k", "3 ans + 45k"],
    answer: "1 an + 15k",
    explanation: "Tableau 441-7.",
    difficulty: "Facile",
  ),

  // Pour atteindre 110 sans te pondre un roman illisible,
  // je continue avec une rafale de cas ultra courts (mêmes règles).
  // (Tu peux les laisser tels quels, ils sont valides et variés.)
  const QuizQuestion(
    category: "Cas flash — Piège",
    question: "Doc authentique délivré indûment (pas falsifié) :",
    options: ["441-5/441-6 selon acteur", "441-2", "441-4"],
    answer: "441-5/441-6 selon acteur",
    explanation: "Procure à autrui = 441-5 ; se fait délivrer = 441-6.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas flash — Piège",
    question: "Le bénéficiaire ment, l’agent ne sait pas :",
    options: ["441-6", "441-5", "441-2"],
    answer: "441-6",
    explanation: "Fraude côté bénéficiaire.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas flash — Piège",
    question: "L’agent sait et délivre quand même :",
    options: ["441-5", "441-6", "441-7"],
    answer: "441-5",
    explanation: "Délivrance indue en connaissance de cause.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas flash — Piège",
    question: "Un tiers remet le document à la place de l’auteur :",
    options: ["Peut rester 441-5", "Devient 441-6", "Devient 441-7"],
    answer: "Peut rester 441-5",
    explanation: "Procurer = même si remise via tiers de bonne foi (cours).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — 441-5 aggravé",
    question: "Réseau qui délivre indûment des permis « à la chaîne » :",
    options: ["441-5 aggravé (habitude)", "441-6", "441-7"],
    answer: "441-5 aggravé (habitude)",
    explanation: "Commission habituelle = aggravation 2°.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — Faux vs obtention indue",
    question:
        "Une personne obtient un document administratif authentique en mentant sur sa situation. Aucune falsification matérielle n’est constatée. Quelle qualification ?",
    options: [
      "Obtention indue de document administratif (441-6)",
      "Faux dans un document administratif (441-2)",
      "Faux général (441-1)",
    ],
    answer: "Obtention indue de document administratif (441-6)",
    explanation:
        "Le document est authentique. Le comportement frauduleux porte sur les déclarations ayant permis son obtention → 441-6.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Piège — Faux vs délivrance indue",
    question:
        "Un agent administratif délivre volontairement un permis à une personne qu’il sait ne pas y avoir droit, sans falsifier le document. Qualification ?",
    options: [
      "Délivrance indue de document administratif (441-5)",
      "Faux dans un document administratif (441-2)",
      "Obtention indue (441-6)",
    ],
    answer: "Délivrance indue de document administratif (441-5)",
    explanation:
        "L’auteur est celui qui procure le document authentique à autrui en connaissance de cause → 441-5.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Piège — 441-2 vs 441-6",
    question:
        "Une carte d’identité est matériellement modifiée après sa délivrance pour changer la date de naissance. Qualification ?",
    options: [
      "Faux dans un document administratif (441-2)",
      "Obtention indue de document administratif (441-6)",
      "Délivrance indue (441-5)",
    ],
    answer: "Faux dans un document administratif (441-2)",
    explanation:
        "Il y a falsification matérielle d’un document administratif → faux administratif (441-2).",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Piège — Usage ou simple détention",
    question:
        "Une personne conserve chez elle un faux document administratif sans jamais l’utiliser. Quelle infraction est la plus adaptée ?",
    options: [
      "Détention de faux document administratif (441-3)",
      "Usage de faux (441-2)",
      "Aucune infraction",
    ],
    answer: "Détention de faux document administratif (441-3)",
    explanation:
        "La détention d’un faux document administratif est incriminée indépendamment de l’usage.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // VRAI / FAUX — ULTRA PIÈGES
  // =========================================================
  const QuizQuestion(
    category: "Vrai/Faux — Faux intellectuel",
    question:
        "Vrai ou Faux : le faux intellectuel suppose nécessairement une falsification matérielle du support.",
    options: ["Vrai", "Faux", "Uniquement pour les documents administratifs"],
    answer: "Faux",
    explanation:
        "Le faux intellectuel porte sur le contenu mensonger, pas sur le support matériel.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Vrai/Faux — Usage de faux",
    question:
        "Vrai ou Faux : chaque utilisation d’un même document falsifié constitue une nouvelle infraction.",
    options: ["Vrai", "Faux", "Seulement en matière administrative"],
    answer: "Vrai",
    explanation:
        "L’usage de faux est une infraction instantanée : chaque acte d’usage est distinct.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Vrai/Faux — 441-6",
    question:
        "Vrai ou Faux : l’obtention indue d’un document administratif suppose obligatoirement un préjudice effectif.",
    options: ["Vrai", "Faux", "Uniquement si une somme d’argent est en jeu"],
    answer: "Faux",
    explanation: "Le préjudice n’est pas exigé pour la qualification de 441-6.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Vrai/Faux — 441-7",
    question:
        "Vrai ou Faux : une attestation mensongère établie pour son propre usage personnel entre dans le champ de 441-7.",
    options: ["Vrai", "Faux", "Seulement si elle est produite en justice"],
    answer: "Faux",
    explanation: "441-7 exige une attestation établie au profit d’un tiers.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // QCM — ÉLÉMENT MORAL (ULTRA CLASSIQUE EXAM)
  // =========================================================
  const QuizQuestion(
    category: "Élément moral — Faux (441-1)",
    question: "Quel élément intentionnel est requis pour le faux (441-1) ?",
    options: [
      "La volonté d’altérer la vérité dans des conditions de nature à causer un préjudice",
      "La simple négligence",
      "Un mobile lucratif obligatoire",
    ],
    answer:
        "La volonté d’altérer la vérité dans des conditions de nature à causer un préjudice",
    explanation:
        "Le faux est une infraction intentionnelle ; les mobiles sont indifférents.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Élément moral — Usage de faux",
    question: "Pour caractériser l’usage de faux, il faut :",
    options: [
      "La volonté d’user et la connaissance de la fausseté",
      "La seule détention du document",
      "La volonté de tromper uniquement",
    ],
    answer: "La volonté d’user et la connaissance de la fausseté",
    explanation:
        "Double exigence : usage volontaire + connaissance du caractère faux.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Élément moral — 441-5",
    question: "L’élément moral de la délivrance indue (441-5) repose sur :",
    options: [
      "La connaissance de l’absence de droit du bénéficiaire",
      "Une erreur administrative",
      "Une imprudence simple",
    ],
    answer: "La connaissance de l’absence de droit du bénéficiaire",
    explanation:
        "La fraude est caractérisée par la connaissance que la personne n’a pas droit au document.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Élément moral — 441-6",
    question: "Concernant l’obtention indue (441-6), l’auteur doit :",
    options: [
      "Avoir conscience de se faire délivrer indûment le document et vouloir utiliser un moyen frauduleux",
      "Ignorer totalement les règles",
      "Être fonctionnaire",
    ],
    answer:
        "Avoir conscience de se faire délivrer indûment le document et vouloir utiliser un moyen frauduleux",
    explanation: "Double exigence : conscience + volonté frauduleuse.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // MINI CAS PRATIQUES — QUALIFICATION EXPRESS
  // =========================================================
  const QuizQuestion(
    category: "Cas pratique — Attestation",
    question:
        "Un individu rédige une attestation écrite mensongère en faveur d’un ami pour l’aider dans un litige prud’homal. Qualification + peine ?",
    options: [
      "Faux certificat/attestation (441-7) — 1 an et 15 000 €",
      "Faux général (441-1) — 3 ans et 45 000 €",
      "Obtention indue (441-6) — 2 ans et 30 000 €",
    ],
    answer: "Faux certificat/attestation (441-7) — 1 an et 15 000 €",
    explanation:
        "Attestation écrite, faits matériellement inexacts, au profit d’un tiers → 441-7.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Usage répété",
    question:
        "Une personne utilise à plusieurs reprises le même faux document administratif pour différentes démarches. Combien d’infractions d’usage ?",
    options: [
      "Autant d’infractions que d’utilisations",
      "Une seule infraction",
      "Aucune infraction",
    ],
    answer: "Autant d’infractions que d’utilisations",
    explanation: "Chaque acte d’usage constitue une infraction distincte.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Agent public",
    question:
        "Un fonctionnaire falsifie un document administratif dans l’exercice de ses fonctions. Qualification principale ?",
    options: [
      "Faux dans un document administratif aggravé (441-2 1°)",
      "Faux général (441-1)",
      "Obtention indue (441-6)",
    ],
    answer: "Faux dans un document administratif aggravé (441-2 1°)",
    explanation:
        "Faux administratif + qualité dépositaire de l’autorité publique → circonstance aggravante.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Définition",
    question: "Le faux (441-1 CP) suppose :",
    options: [
      "Une altération de la vérité, de nature à causer un préjudice, sur un support à valeur probatoire",
      "Une simple faute de frappe sans conséquence",
      "Une critique d’un agent public",
    ],
    answer:
        "Une altération de la vérité, de nature à causer un préjudice, sur un support à valeur probatoire",
    explanation:
        "Le faux = altération de la vérité + nature à causer préjudice + support destiné/pouvant servir de preuve d’un droit/fait à conséquences juridiques.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Support",
    question: "Le support du faux peut être :",
    options: [
      "Un écrit ou tout autre support d’expression de la pensée (numérique compris)",
      "Uniquement un acte notarié",
      "Uniquement un document papier signé par un maire",
    ],
    answer:
        "Un écrit ou tout autre support d’expression de la pensée (numérique compris)",
    explanation:
        "Le texte vise aussi les supports informatiques (clé USB, disque dur, etc.).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Valeur probatoire",
    question: "Pour relever de 441-1, le support doit :",
    options: [
      "Avoir pour objet OU pouvoir avoir pour effet d’établir la preuve d’un droit ou d’un fait à conséquences juridiques",
      "Toujours être un document administratif",
      "Toujours être un document public",
    ],
    answer:
        "Avoir pour objet OU pouvoir avoir pour effet d’établir la preuve d’un droit ou d’un fait à conséquences juridiques",
    explanation:
        "Notion de valeur probatoire : supports prévus pour prouver, ou pouvant servir de preuve.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Document de hasard",
    question: "Un document « de hasard » peut être support du faux si :",
    options: [
      "Il sert ensuite de preuve d’un droit/fait à conséquences juridiques",
      "Il est obligatoirement établi par l’administration",
      "Il n’a aucun effet possible en justice",
    ],
    answer:
        "Il sert ensuite de preuve d’un droit/fait à conséquences juridiques",
    explanation:
        "Même si non créé pour prouver, il peut acquérir une valeur probatoire par son usage.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Falsification matérielle",
    question: "Le faux matériel correspond à :",
    options: [
      "Une altération du support (aspect physique) : suppression, modification, adjonction, imitation, fabrication",
      "Un mensonge sur les faits sans toucher au support",
      "Une simple erreur involontaire",
    ],
    answer:
        "Une altération du support (aspect physique) : suppression, modification, adjonction, imitation, fabrication",
    explanation:
        "Faux matériel = atteinte au support, souvent détectable à l’examen du document.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Falsification intellectuelle",
    question: "Le faux intellectuel correspond à :",
    options: [
      "Un défaut de véracité : mensonge sur le contenu (faits) du support",
      "Une déchirure visible du papier",
      "Une absence totale de document",
    ],
    answer:
        "Un défaut de véracité : mensonge sur le contenu (faits) du support",
    explanation:
        "Le mensonge atteint le contenu (faits) et non l’aspect matériel du support.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Préjudice",
    question: "Le préjudice exigé par 441-1 :",
    options: [
      "N’a pas à être réalisé : il suffit qu’il soit possible (de nature à causer un préjudice)",
      "Doit être forcément chiffré",
      "Doit être forcément matériel uniquement",
    ],
    answer:
        "N’a pas à être réalisé : il suffit qu’il soit possible (de nature à causer un préjudice)",
    explanation:
        "Condition : altération de nature à causer un préjudice, même potentiel.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Usage",
    question: "L’usage de faux suppose :",
    options: [
      "Un faux préalable + un acte positif d’utilisation + la connaissance de la fausseté",
      "Une abstention volontaire seulement",
      "La simple détention du document",
    ],
    answer:
        "Un faux préalable + un acte positif d’utilisation + la connaissance de la fausseté",
    explanation:
        "Usage = utilisation effective (acte positif), en connaissance du caractère faux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Infraction instantanée",
    question: "L’usage de faux est une infraction :",
    options: [
      "Instantanée : chaque acte d’usage peut constituer une nouvelle infraction",
      "Continue : un seul usage pour toute la période",
      "Non punissable",
    ],
    answer:
        "Instantanée : chaque acte d’usage peut constituer une nouvelle infraction",
    explanation:
        "Tout acte d’usage est distinct : plusieurs utilisations = plusieurs usages.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Peines",
    question: "Les peines principales de 441-1 sont :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Peines prévues par l’article 441-1 CP.",
    difficulty: "Facile",
  ),

  // =========================================================
  // 441-2 — FAUX DANS UN DOCUMENT ADMINISTRATIF (+ USAGE)
  // =========================================================
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Définition",
    question: "441-2 réprime :",
    options: [
      "Le faux (contrefaçon/falsification) dans un document administratif + l’usage de ce faux",
      "La simple obtention d’un document authentique",
      "La délivrance d’un document authentique par erreur",
    ],
    answer:
        "Le faux (contrefaçon/falsification) dans un document administratif + l’usage de ce faux",
    explanation:
        "Faux administratif = document délivré par administration pour droit/identité/qualité/autorisation, falsifié.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Documents visés",
    question: "Un document administratif (441-2) peut viser :",
    options: [
      "Carte d’identité / titre de séjour / permis / carte grise / certificat (ex : mariage)",
      "Une discussion orale",
      "Une opinion sur un forum",
    ],
    answer:
        "Carte d’identité / titre de séjour / permis / carte grise / certificat (ex : mariage)",
    explanation:
        "Ce sont des documents délivrés par l’administration pour constater/autoriser.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Usage vs R.645-8",
    question:
        "Utiliser un document administratif non falsifié mais devenu inexact/incomplet correspond plutôt à :",
    options: [
      "Contravention 5e classe (R.645-8 CP)",
      "Usage de faux 441-2",
      "Délivrance indue 441-5",
    ],
    answer: "Contravention 5e classe (R.645-8 CP)",
    explanation:
        "Si le document n’est pas falsifié mais simplement inexact/incomplet → R.645-8 (selon ta page).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Aggravation qualité",
    question: "441-2 est aggravé si commis :",
    options: [
      "Par dépositaire de l’autorité publique / mission de SP dans l’exercice des fonctions",
      "En état de fatigue",
      "En présence d’un témoin",
    ],
    answer:
        "Par dépositaire de l’autorité publique / mission de SP dans l’exercice des fonctions",
    explanation: "Circonstance aggravante 441-2 1°.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Aggravation dessein",
    question: "441-2 est aggravé si commis :",
    options: [
      "Dans le dessein de faciliter la commission d’un crime ou de procurer l’impunité",
      "Pour gagner du temps",
      "Par habitude uniquement",
    ],
    answer:
        "Dans le dessein de faciliter la commission d’un crime ou de procurer l’impunité",
    explanation: "Circonstance aggravante (dessein) prévue par le texte (3°).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Peines simples",
    question: "441-2 (simple) :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "10 ans d’emprisonnement",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Tableau : 441-2 simple = 5 ans + 75 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Peines aggravées",
    question: "441-2 (aggravé) :",
    options: [
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende",
    explanation: "Tableau : 441-2 aggravé = 7 ans + 100 000 €.",
    difficulty: "Facile",
  ),

  // =========================================================
  // 441-4 — FAUX DANS ÉCRITURE PUBLIQUE / AUTHENTIQUE (+ USAGE)
  // =========================================================
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Définition",
    question: "441-4 vise :",
    options: [
      "Le faux dans une écriture publique/authentique ou un enregistrement ordonné, + l’usage",
      "Le faux certificat/attestation",
      "L’obtention indue d’un document authentique",
    ],
    answer:
        "Le faux dans une écriture publique/authentique ou un enregistrement ordonné, + l’usage",
    explanation:
        "Écritures publiques/authentiques et enregistrements ordonnés par l’autorité publique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Préjudice",
    question: "Dans 441-4, le préjudice éventuel est considéré :",
    options: [
      "Établi par l’atteinte à la foi publique liée à ces actes",
      "Toujours absent",
      "Seulement matériel",
    ],
    answer: "Établi par l’atteinte à la foi publique liée à ces actes",
    explanation:
        "La valeur probatoire des actes publics/authentiques fonde l’atteinte à la foi publique.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Peine simple",
    question: "441-4 (simple) :",
    options: [
      "10 ans d’emprisonnement",
      "5 ans d’emprisonnement et 75 000 €",
      "3 ans d’emprisonnement et 45 000 €",
    ],
    answer: "10 ans d’emprisonnement",
    explanation:
        "Tableau : faux en écriture publique/authentique simple = 10 ans.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Peine aggravée",
    question: "441-4 (aggravé par qualité en exercice) :",
    options: [
      "15 ans de réclusion",
      "7 ans d’emprisonnement et 100 000 €",
      "10 ans d’emprisonnement",
    ],
    answer: "15 ans de réclusion",
    explanation: "Tableau : 441-4 al.3 = crime, 15 ans de réclusion.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 441-5 — DÉLIVRANCE INDUE DE DOCUMENT ADMINISTRATIF
  // =========================================================
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Cœur du texte",
    question: "441-5 réprime le fait de :",
    options: [
      "Procurer frauduleusement à autrui un document administratif authentique",
      "Falsifier un document administratif",
      "Se faire délivrer indûment un document",
    ],
    answer:
        "Procurer frauduleusement à autrui un document administratif authentique",
    explanation:
        "441-5 = délivrance/procurement à autrui (acteur = celui qui fait obtenir).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Document authentique",
    question: "441-5 concerne :",
    options: [
      "Des documents authentiques délivrés indûment",
      "Des faux documents administratifs",
      "Des attestations entre particuliers",
    ],
    answer: "Des documents authentiques délivrés indûment",
    explanation:
        "Le cours précise : ce ne sont pas des faux, mais des documents authentiques.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Élément moral",
    question: "L’auteur de 441-5 doit :",
    options: [
      "Savoir que le bénéficiaire n’a pas droit au document",
      "Se tromper involontairement",
      "Être nécessairement un policier",
    ],
    answer: "Savoir que le bénéficiaire n’a pas droit au document",
    explanation:
        "Remise en toute connaissance de cause = élément intentionnel central.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Aggravation habitude",
    question: "441-5 est aggravé si commis :",
    options: [
      "De manière habituelle",
      "En présence d’un témoin",
      "Sur internet",
    ],
    answer: "De manière habituelle",
    explanation: "Aggravation 2° : commission habituelle.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Peine simple",
    question: "441-5 (simple) :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 €",
      "3 ans d’emprisonnement et 45 000 €",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Tableau : 441-5 simple = 5 ans + 75 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Peine aggravée",
    question: "441-5 (aggravé) :",
    options: [
      "7 ans de réclusion et 100 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 €",
      "10 ans d’emprisonnement et 150 000 €",
    ],
    answer: "7 ans de réclusion et 100 000 € d’amende",
    explanation: "Tableau : 441-5 aggravé = 7 ans (réclusion) + 100 000 €.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 441-6 — OBTENTION INDUE (+ FAUSSE / INCOMPLÈTE DÉCLARATION AL.2)
  // =========================================================
  const QuizQuestion(
    category: "Obtention indue (441-6) — Définition",
    question: "441-6 (alinéa 1) vise :",
    options: [
      "Se faire délivrer indûment un document authentique par moyen frauduleux",
      "Falsifier matériellement un document administratif",
      "Procurer un document à autrui (acteur-délivreur)",
    ],
    answer:
        "Se faire délivrer indûment un document authentique par moyen frauduleux",
    explanation:
        "441-6 = obtention par le bénéficiaire (ou pour autrui) via fraude.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Moyens frauduleux",
    question: "Les moyens de 441-6 peuvent être :",
    options: [
      "Fausses déclarations, faux renseignements/certificats, déclarations d’un tiers, manœuvres",
      "Uniquement une falsification matérielle",
      "Uniquement des violences",
    ],
    answer:
        "Fausses déclarations, faux renseignements/certificats, déclarations d’un tiers, manœuvres",
    explanation:
        "Le texte vise « quelque moyen frauduleux que ce soit » et donne des exemples.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Alinéa 2",
    question: "441-6 al.2 vise :",
    options: [
      "La fausse déclaration OU déclaration incomplète pour obtenir/tenter d’obtenir une allocation/prestation/paiement/avantage indu",
      "La falsification d’une carte d’identité",
      "La délivrance indue par un agent complaisant",
    ],
    answer:
        "La fausse déclaration OU déclaration incomplète pour obtenir/tenter d’obtenir une allocation/prestation/paiement/avantage indu",
    explanation:
        "Al.2 = avantages indus (personne publique / protection sociale / mission SP).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Consommation al.2",
    question: "Pour 441-6 al.2, l’infraction est consommée :",
    options: [
      "Même sans obtention effective, si la déclaration est faite dans le but d’obtenir",
      "Uniquement si l’avantage est versé",
      "Uniquement si la déclaration est écrite",
    ],
    answer:
        "Même sans obtention effective, si la déclaration est faite dans le but d’obtenir",
    explanation:
        "Le but suffit : obtenir ou tenter d’obtenir (ou faire obtenir).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Circonstances aggravantes",
    question: "441-6 comporte des circonstances aggravantes :",
    options: ["Aucune", "En réunion", "Avec arme"],
    answer: "Aucune",
    explanation: "Ta page : IV — AUCUNE circonstance aggravante.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Peines",
    question: "441-6 (alinéa 1 et 2) :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 €",
      "5 ans d’emprisonnement et 75 000 €",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation: "Tableau : 441-6 al.1 / al.2 = 2 ans + 30 000 €.",
    difficulty: "Facile",
  ),

  // =========================================================
  // 441-7 — FAUX CERTIFICATS / ATTESTATIONS
  // =========================================================
  const QuizQuestion(
    category: "Faux attestations (441-7) — Définition",
    question: "441-7 réprime notamment :",
    options: [
      "Établir une attestation/certificat matériellement inexact, falsifier un document sincère, ou en faire usage",
      "Obtenir indûment un document administratif authentique",
      "Falsifier une écriture publique",
    ],
    answer:
        "Établir une attestation/certificat matériellement inexact, falsifier un document sincère, ou en faire usage",
    explanation:
        "441-7 vise établissement / falsification / usage d’attestations ou certificats.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux attestations (441-7) — Écrit uniquement",
    question: "441-7 exige :",
    options: [
      "Un écrit (l’oral ne suffit pas)",
      "Une déclaration orale si elle est filmée",
      "Un simple message verbal",
    ],
    answer: "Un écrit (l’oral ne suffit pas)",
    explanation:
        "Le cours : seuls certificats/attestations écrits entrent dans le champ.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux attestations (441-7) — Au profit d’un tiers",
    question: "Pour relever de 441-7, le document doit être établi :",
    options: [
      "En faveur d’autrui (tiers)",
      "À son propre profit exclusivement",
      "Uniquement pour un policier",
    ],
    answer: "En faveur d’autrui (tiers)",
    explanation:
        "Le cours exclut l’attestation sur l’honneur établie pour soi-même.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux attestations (441-7) — Peine simple",
    question: "441-7 (simple) :",
    options: [
      "1 an d’emprisonnement et 15 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 €",
      "3 ans d’emprisonnement et 45 000 €",
    ],
    answer: "1 an d’emprisonnement et 15 000 € d’amende",
    explanation: "Tableau : 441-7 simple = 1 an + 15 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux attestations (441-7) — Peine aggravée",
    question: "441-7 (aggravé, notamment al.5) :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 €",
      "7 ans d’emprisonnement et 100 000 €",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Tableau : aggravé = 3 ans + 45 000 €.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 441-9 — TENTATIVE (COMMUN AUX 441-1 / 441-2 / 441-4 / 441-5 / 441-6 / 441-7)
  // =========================================================
  const QuizQuestion(
    category: "Tentative — Principe (441-9)",
    question: "La tentative des délits 441-1 à 441-7 est :",
    options: [
      "Punissable (prévue expressément par 441-9)",
      "Non punissable",
      "Punissable seulement pour 441-4",
    ],
    answer: "Punissable (prévue expressément par 441-9)",
    explanation:
        "Le cours indique que 441-9 prévoit expressément la tentative pour ces délits.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 441-12 — PERSONNES MORALES
  // =========================================================
  const QuizQuestion(
    category: "Personnes morales — 441-12",
    question:
        "La responsabilité pénale des personnes morales pour ces infractions est prévue par :",
    options: [
      "Article 441-12 du Code pénal",
      "Article 121-7 du Code pénal",
      "Article 433-6 du Code pénal",
    ],
    answer: "Article 441-12 du Code pénal",
    explanation:
        "Ta page mentionne 441-12 pour la responsabilité pénale des personnes morales.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // VRAI / FAUX — SÉRIES (format options)
  // =========================================================
  const QuizQuestion(
    category: "Vrai/Faux — 441-5",
    question:
        "Vrai ou Faux : 441-5 réprime la fabrication d’un faux document administratif.",
    options: ["Vrai", "Faux", "Seulement si c’est un permis"],
    answer: "Faux",
    explanation:
        "441-5 vise la délivrance/procurement indus de documents authentiques (pas la falsification).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-2",
    question:
        "Vrai ou Faux : 441-2 réprime aussi l’usage du faux document administratif.",
    options: ["Vrai", "Faux", "Seulement si l’auteur est fonctionnaire"],
    answer: "Vrai",
    explanation:
        "Le texte réprime le faux et l’usage de ce faux (documents administratifs).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-6 al.2",
    question:
        "Vrai ou Faux : une déclaration incomplète peut constituer 441-6 al.2 si elle est volontaire et vise un avantage indu.",
    options: ["Vrai", "Faux", "Uniquement si l’avantage est versé"],
    answer: "Vrai",
    explanation:
        "Omission volontaire (déclaration incomplète) + but d’obtenir un avantage indu suffit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Usage",
    question:
        "Vrai ou Faux : la simple détention d’un faux constitue automatiquement un usage de faux.",
    options: ["Vrai", "Faux", "Seulement si document administratif"],
    answer: "Faux",
    explanation:
        "Usage = acte positif d’utilisation ; la détention seule ne suffit pas.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-7",
    question:
        "Vrai ou Faux : l’infraction 441-7 peut être constituée même si l’auteur n’a pas prévu l’usage que fera le tiers.",
    options: ["Vrai", "Faux", "Seulement si l’auteur est dépositaire"],
    answer: "Vrai",
    explanation:
        "Le cours précise : peu importe que l’auteur ait prévu l’usage futur par le tiers.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // QCM “PIÈGES” — DISTINCTIONS EXPRESS
  // =========================================================
  const QuizQuestion(
    category: "Piège — 441-5 vs 441-6 (acteur)",
    question:
        "Qui est typiquement l’auteur principal de 441-5 (délivrance indue) ?",
    options: [
      "Celui qui procure/fait délivrer le document à une personne qui n’y a pas droit",
      "Celui qui ment pour l’obtenir pour lui-même",
      "Celui qui déchire le document",
    ],
    answer:
        "Celui qui procure/fait délivrer le document à une personne qui n’y a pas droit",
    explanation:
        "441-5 = acteur “délivreur” (fonctionnaire complaisant ou particulier) qui procure à autrui.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — 441-6 (bénéficiaire)",
    question:
        "Qui est typiquement l’auteur principal de 441-6 (obtention indue) ?",
    options: [
      "Celui qui se fait délivrer le document par fraude (bénéficiaire)",
      "Celui qui délivre en connaissance de cause",
      "Celui qui constate les faits",
    ],
    answer: "Celui qui se fait délivrer le document par fraude (bénéficiaire)",
    explanation: "441-6 = obtention indue par moyen frauduleux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège — 441-1 vs 441-7",
    question:
        "Pourquoi une attestation mensongère est plutôt qualifiée sous 441-7 que 441-1 ?",
    options: [
      "Parce que 441-7 est le texte spécial dédié aux attestations/certificats",
      "Parce que 441-1 ne réprime jamais le faux",
      "Parce que 441-7 est une contravention",
    ],
    answer:
        "Parce que 441-7 est le texte spécial dédié aux attestations/certificats",
    explanation:
        "En présence d’un texte spécial (441-7), on l’applique plutôt que le général (441-1).",
    difficulty: "Difficile",
  ),

  // =========================================================
  // MINI CAS PRATIQUES — QUALIF + ARTICLE + PEINE (style concours)
  // =========================================================
  const QuizQuestion(
    category: "Cas pratique — Fausse déclaration (441-6)",
    question:
        "Un individu fournit sciemment de faux renseignements pour obtenir un plan de chasse. Qualification + peine ?",
    options: [
      "Obtention indue (441-6) — 2 ans et 30 000 €",
      "Faux administratif (441-2) — 5 ans et 75 000 €",
      "Faux général (441-1) — 3 ans et 45 000 €",
    ],
    answer: "Obtention indue (441-6) — 2 ans et 30 000 €",
    explanation:
        "Document authentique obtenu par fraude (fausse déclaration) → 441-6 (2 ans / 30 000 €).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Agent complaisant (441-5)",
    question:
        "Un agent remet un titre de séjour authentique à une personne qu’il sait ne pas y avoir droit. Qualification + peine simple ?",
    options: [
      "Délivrance indue (441-5) — 5 ans et 75 000 €",
      "Obtention indue (441-6) — 2 ans et 30 000 €",
      "Faux en écriture publique (441-4) — 10 ans",
    ],
    answer: "Délivrance indue (441-5) — 5 ans et 75 000 €",
    explanation:
        "Procurer frauduleusement à autrui un document authentique → 441-5.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Modification physique (441-2)",
    question:
        "Une personne gratte et remplace une date sur un permis de conduire. Qualification + peine simple ?",
    options: [
      "Faux doc administratif (441-2) — 5 ans et 75 000 €",
      "Obtention indue (441-6) — 2 ans et 30 000 €",
      "Faux attestations (441-7) — 1 an et 15 000 €",
    ],
    answer: "Faux doc administratif (441-2) — 5 ans et 75 000 €",
    explanation:
        "Falsification matérielle d’un document administratif → 441-2.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Usage (441-1)",
    question:
        "Une personne utilise un document falsifié pour prouver un droit dans une procédure. Qualification + peine ?",
    options: [
      "Usage de faux (441-1) — 3 ans et 45 000 €",
      "Délivrance indue (441-5) — 5 ans et 75 000 €",
      "Obtention indue (441-6) — 2 ans et 30 000 €",
    ],
    answer: "Usage de faux (441-1) — 3 ans et 45 000 €",
    explanation:
        "Usage d’une pièce fausse à finalité probatoire → usage de faux (441-1).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Attestation mensongère (441-7)",
    question:
        "Une personne signe une attestation écrite mensongère au profit d’un voisin. Qualification + peine simple ?",
    options: [
      "441-7 — 1 an et 15 000 €",
      "441-1 — 3 ans et 45 000 €",
      "441-6 — 2 ans et 30 000 €",
    ],
    answer: "441-7 — 1 an et 15 000 €",
    explanation:
        "Attestation au profit d’autrui, faits matériellement inexacts → 441-7.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Avantage indu (441-6 al.2)",
    question:
        "Un demandeur omet volontairement de déclarer un revenu pour obtenir une prestation sociale. Qualification + peine ?",
    options: [
      "441-6 al.2 — 2 ans et 30 000 €",
      "441-7 — 1 an et 15 000 €",
      "441-5 — 5 ans et 75 000 €",
    ],
    answer: "441-6 al.2 — 2 ans et 30 000 €",
    explanation:
        "Déclaration incomplète volontaire pour avantage indu → 441-6 al.2.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Écriture publique (441-4)",
    question:
        "Un faux est commis dans une écriture publique/authentique. Qualification + peine simple ?",
    options: [
      "441-4 — 10 ans d’emprisonnement",
      "441-2 — 5 ans et 75 000 €",
      "441-1 — 3 ans et 45 000 €",
    ],
    answer: "441-4 — 10 ans d’emprisonnement",
    explanation:
        "Faux en écriture publique/authentique : 441-4 (simple) = 10 ans.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Écriture publique aggravée (441-4)",
    question:
        "Le faux en écriture publique est commis par un dépositaire de l’autorité publique dans l’exercice des fonctions. Peine ?",
    options: [
      "441-4 al.3 — 15 ans de réclusion",
      "441-2 aggravé — 7 ans et 100 000 €",
      "441-1 — 3 ans et 45 000 €",
    ],
    answer: "441-4 al.3 — 15 ans de réclusion",
    explanation:
        "Circonstance aggravante : qualité + exercice → crime (15 ans).",
    difficulty: "Difficile",
  ),

  // =========================================================
  // SÉRIES “ULTRA COURTES” — RÉFLEXES (mix niveaux)
  // =========================================================
  const QuizQuestion(
    category: "Réflexe — Article",
    question:
        "Quel article réprime l’obtention indue de document administratif ?",
    options: ["441-6", "441-5", "441-2"],
    answer: "441-6",
    explanation: "Obtention indue = 441-6.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question:
        "Quel article réprime la délivrance indue de document administratif ?",
    options: ["441-5", "441-6", "441-7"],
    answer: "441-5",
    explanation: "Délivrance indue = 441-5.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question: "Quel article réprime le faux dans un document administratif ?",
    options: ["441-2", "441-1", "441-4"],
    answer: "441-2",
    explanation: "Faux dans document administratif = 441-2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Article",
    question: "Quel article réprime les faux certificats/attestations ?",
    options: ["441-7", "441-6", "441-5"],
    answer: "441-7",
    explanation: "Faux certificats/attestations = 441-7.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peines",
    question: "Peine de 441-6 (obtenir un document/avantage indu par fraude) :",
    options: ["2 ans et 30 000 €", "3 ans et 45 000 €", "5 ans et 75 000 €"],
    answer: "2 ans et 30 000 €",
    explanation: "Tableau 441-6.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peines",
    question: "Peine de 441-5 (délivrance indue) simple :",
    options: ["5 ans et 75 000 €", "2 ans et 30 000 €", "1 an et 15 000 €"],
    answer: "5 ans et 75 000 €",
    explanation: "Tableau 441-5.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peines",
    question: "Peine de 441-2 (faux doc administratif) simple :",
    options: ["5 ans et 75 000 €", "3 ans et 45 000 €", "10 ans"],
    answer: "5 ans et 75 000 €",
    explanation: "Tableau 441-2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — Peines",
    question: "Peine de 441-1 (faux/usage de faux) :",
    options: ["3 ans et 45 000 €", "2 ans et 30 000 €", "5 ans et 75 000 €"],
    answer: "3 ans et 45 000 €",
    explanation: "Tableau 441-1.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Usage de faux — Acte positif",
    question: "Quel comportement correspond le plus à un usage de faux ?",
    options: [
      "Présenter la pièce fausse à un organisme pour obtenir un résultat",
      "Garder la pièce chez soi sans la montrer",
      "Parler du document sans le produire",
    ],
    answer: "Présenter la pièce fausse à un organisme pour obtenir un résultat",
    explanation:
        "Usage = utilisation effective (acte positif) de la pièce fausse.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Usage de faux — Piège abstention",
    question:
        "Vrai ou Faux : ne pas produire un document falsifié mais espérer qu’un tiers le produise suffit pour l’usage.",
    options: ["Vrai", "Faux", "Seulement si c’est un document administratif"],
    answer: "Faux",
    explanation:
        "L’usage de faux ne peut résulter de la seule abstention (il faut un fait positif).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Usage de faux — Multi-usages",
    question: "Une même pièce fausse est utilisée 3 fois :",
    options: [
      "3 usages possibles (3 infractions distinctes d’usage)",
      "1 seule infraction d’usage",
      "Aucune infraction si le document est ancien",
    ],
    answer: "3 usages possibles (3 infractions distinctes d’usage)",
    explanation: "Chaque utilisation = un acte d’usage distinct.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // PIÈGES SUR “AUTHENTIQUE” vs “FALSIFIÉ”
  // =========================================================
  const QuizQuestion(
    category: "Piège — Authentique vs falsifié",
    question: "Quel couple est correct ?",
    options: [
      "441-5/441-6 : documents authentiques ; 441-2/441-4 : documents falsifiés",
      "441-5 : documents falsifiés ; 441-2 : authentiques",
      "441-6 : uniquement des attestations privées",
    ],
    answer:
        "441-5/441-6 : documents authentiques ; 441-2/441-4 : documents falsifiés",
    explanation:
        "441-5/441-6 = délivrance/obtention indue d’authentiques ; 441-2/441-4 = faux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — 441-6 vs 441-2",
    question:
        "Si la fraude repose sur une fausse déclaration, sans falsification du document délivré :",
    options: ["441-6", "441-2", "441-4"],
    answer: "441-6",
    explanation:
        "Le document est authentique, seule l’obtention est frauduleuse → 441-6.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège — 441-5 vs 441-6",
    question:
        "Si l’auteur est celui qui “donne” le document à une personne qui n’y a pas droit :",
    options: ["441-5", "441-6", "441-7"],
    answer: "441-5",
    explanation:
        "Acteur qui procure à autrui en connaissance de cause → 441-5.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 441-7 — SÉRIES ATTESTATIONS (plus techniques)
  // =========================================================
  const QuizQuestion(
    category: "Attestations (441-7) — Faits vérifiables",
    question: "« Faits matériellement inexacts » vise :",
    options: [
      "Des éléments objectifs vérifiables susceptibles de preuve contraire",
      "Des opinions subjectives",
      "Des émotions ressenties",
    ],
    answer:
        "Des éléments objectifs vérifiables susceptibles de preuve contraire",
    explanation:
        "Le texte vise des faits objectivement constatables/vérifiables.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attestations (441-7) — Consommation",
    question: "L’établissement d’une attestation inexacte est consommé :",
    options: [
      "Dès la rédaction/signature, même sans usage ultérieur",
      "Seulement si produite devant un juge",
      "Seulement si elle cause un dommage concret",
    ],
    answer: "Dès la rédaction/signature, même sans usage ultérieur",
    explanation: "L’infraction d’établissement est indépendante de l’usage.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attestations (441-7) — Élément moral",
    question: "Pour l’établissement (441-7), il faut :",
    options: [
      "La connaissance de l’inexactitude des faits certifiés",
      "Une simple négligence",
      "Un mobile obligatoire",
    ],
    answer: "La connaissance de l’inexactitude des faits certifiés",
    explanation: "Connaissance de l’inexactitude = élément moral central.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Attestations (441-7) — Aggravation (but)",
    question: "441-7 est aggravé notamment si commis :",
    options: [
      "Pour porter préjudice au Trésor public/patrimoine d’autrui ou obtenir un titre de séjour/protection",
      "En réunion",
      "Avec une arme",
    ],
    answer:
        "Pour porter préjudice au Trésor public/patrimoine d’autrui ou obtenir un titre de séjour/protection",
    explanation: "Aggravation prévue (alinéa 5) dans ton cours.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 441-2 — SÉRIES DOCUMENT ADMINISTRATIF (technique)
  // =========================================================
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Condition",
    question: "441-2 vise des documents administratifs établis pour :",
    options: [
      "Constater un droit, une identité, une qualité, ou accorder une autorisation",
      "Exprimer une opinion",
      "Conserver un souvenir personnel",
    ],
    answer:
        "Constater un droit, une identité, une qualité, ou accorder une autorisation",
    explanation: "Finalité administrative : constater/autoriser.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Usage",
    question: "L’usage de faux (441-2) suppose :",
    options: [
      "Un document administratif falsifié + une utilisation",
      "Un document devenu simplement périmé",
      "Une déclaration orale",
    ],
    answer: "Un document administratif falsifié + une utilisation",
    explanation: "Usage = utilisation d’un document déjà falsifié.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 441-5 / 441-6 — SÉRIES “DOCUMENTS VISÉS”
  // =========================================================
  const QuizQuestion(
    category: "Documents visés — 441-5/441-6",
    question: "Lequel est un document typiquement visé par 441-5/441-6 ?",
    options: [
      "Titre de séjour / CNI / passeport / permis / carte grise",
      "Message vocal",
      "Conversation privée sans valeur probatoire",
    ],
    answer: "Titre de séjour / CNI / passeport / permis / carte grise",
    explanation:
        "Documents délivrés pour constater identité/droit/qualité ou accorder autorisation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Documents visés — 441-6 (organisme SP)",
    question: "441-6 peut viser un document délivré par :",
    options: [
      "Un organisme chargé d’une mission de service public",
      "Uniquement une préfecture",
      "Uniquement une entreprise privée commerciale",
    ],
    answer: "Un organisme chargé d’une mission de service public",
    explanation:
        "Le texte étend aux organismes de mission de SP (selon ton cours).",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // QCM VRAI/FAUX — MIX NIVEAUX
  // =========================================================
  const QuizQuestion(
    category: "Vrai/Faux — 441-1",
    question:
        "Vrai ou Faux : les mobiles de l’auteur du faux ont une importance pour caractériser l’infraction.",
    options: ["Vrai", "Faux", "Seulement si gain financier"],
    answer: "Faux",
    explanation:
        "Les mobiles sont indifférents : ce qui compte = volonté d’altérer la vérité + nature à causer préjudice.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-6",
    question:
        "Vrai ou Faux : 441-6 exige une falsification matérielle du document obtenu.",
    options: ["Vrai", "Faux", "Seulement si titre de séjour"],
    answer: "Faux",
    explanation:
        "441-6 vise l’obtention par fraude de documents authentiques (sans falsification du document).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-2",
    question:
        "Vrai ou Faux : 441-2 est un « faux spécial » par rapport à 441-1.",
    options: ["Vrai", "Faux", "Seulement si usage"],
    answer: "Vrai",
    explanation:
        "441-2 vise spécialement les faux commis dans des documents administratifs.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // CAS PRATIQUES — PIÈGES DE QUALIFICATION
  // =========================================================
  const QuizQuestion(
    category: "Cas pratique — 441-5 vs 441-6",
    question:
        "Un particulier fournit à un ami un document administratif authentique obtenu grâce à un agent complaisant, sachant que l’ami n’y a pas droit. Pour le particulier qui remet le document :",
    options: [
      "441-5 (procure frauduleusement à autrui) — 5 ans et 75 000 €",
      "441-6 — 2 ans et 30 000 €",
      "441-7 — 1 an et 15 000 €",
    ],
    answer: "441-5 (procure frauduleusement à autrui) — 5 ans et 75 000 €",
    explanation:
        "Celui qui procure/remet à autrui un document authentique indûment = 441-5.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — 441-6 al.2",
    question:
        "Une personne écrit volontairement une déclaration incomplète pour tenter d’obtenir un avantage indu, mais l’administration refuse. Qualification + peine ?",
    options: [
      "441-6 al.2 — 2 ans et 30 000 €",
      "Aucune infraction",
      "441-1 — 3 ans et 45 000 €",
    ],
    answer: "441-6 al.2 — 2 ans et 30 000 €",
    explanation: "L’avantage n’a pas besoin d’être obtenu : le but suffit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — 441-7 usage",
    question:
        "Une personne utilise devant un juge une attestation falsifiée (préexistante) en sachant qu’elle est fausse. Qualification ?",
    options: [
      "Usage de faux certificat/attestation (441-7) — peine selon tableau",
      "Obtention indue (441-6)",
      "Délivrance indue (441-5)",
    ],
    answer:
        "Usage de faux certificat/attestation (441-7) — peine selon tableau",
    explanation:
        "Usage d’une attestation/certificat faux/falsifié = 441-7 (usage).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Déclarations mensongères",
    question:
        "Une personne omet volontairement de déclarer un revenu pour percevoir une allocation sociale. Qualification ?",
    options: [
      "Obtention indue par déclaration incomplète (441-6 al.2)",
      "Faux général (441-1)",
      "Aucune infraction",
    ],
    answer: "Obtention indue par déclaration incomplète (441-6 al.2)",
    explanation:
        "Omission volontaire destinée à obtenir un avantage indu → 441-6 al.2.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Élément légal",
    question:
        "Le texte qui définit et réprime le faux et l’usage de faux (général) est :",
    options: [
      "Article 441-1 du Code pénal",
      "Article 441-2 du Code pénal",
      "Article 441-6 du Code pénal",
    ],
    answer: "Article 441-1 du Code pénal",
    explanation: "Base générale : 441-1 CP (hors faux spéciaux 441-2 à 441-7).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Support",
    question: "Le support du faux peut être :",
    options: [
      "Un écrit ou tout autre support d’expression de la pensée",
      "Uniquement un document papier",
      "Uniquement un acte notarié",
    ],
    answer: "Un écrit ou tout autre support d’expression de la pensée",
    explanation:
        "Le texte vise aussi d’autres supports (CD, DVD, clés USB, disque dur, etc.).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Valeur probatoire",
    question: "Pour entrer dans 441-1 CP, le support doit :",
    options: [
      "Avoir pour objet ou pouvoir avoir pour effet d’établir la preuve d’un droit ou d’un fait à conséquences juridiques",
      "Être obligatoirement un acte d’état civil",
      "Être obligatoirement signé par un fonctionnaire",
    ],
    answer:
        "Avoir pour objet ou pouvoir avoir pour effet d’établir la preuve d’un droit ou d’un fait à conséquences juridiques",
    explanation:
        "Exigence de valeur probatoire : preuve d’un droit/fait à conséquences juridiques (ou pouvant servir à cela).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Document de hasard",
    question: "Un « document de hasard » peut être un support du faux s’il :",
    options: [
      "N’était pas destiné à prouver au départ mais sert ensuite de preuve",
      "Est toujours un acte administratif",
      "Est toujours un document public",
    ],
    answer:
        "N’était pas destiné à prouver au départ mais sert ensuite de preuve",
    explanation:
        "Le code vise aussi les supports qui peuvent avoir un effet probatoire, même s’ils n’ont pas été créés pour cela.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Exemple probatoire",
    question: "Selon la jurisprudence citée, peut constituer un faux :",
    options: [
      "La falsification d’un constat amiable d’accident",
      "Une simple promesse orale",
      "Un avis personnel sans conséquence",
    ],
    answer: "La falsification d’un constat amiable d’accident",
    explanation:
        "Exemple de document utilisé à des fins probatoires : constat amiable.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Factures",
    question: "Les factures :",
    options: [
      "Peuvent devenir probatoires si passées en comptabilité, et alors être susceptibles de faux",
      "Ne peuvent jamais être un support de faux",
      "Sont toujours des actes publics",
    ],
    answer:
        "Peuvent devenir probatoires si passées en comptabilité, et alors être susceptibles de faux",
    explanation:
        "Le cours précise que la valeur probatoire peut découler de leur usage (comptabilité).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Photocopie",
    question: "La production en justice d’une photocopie contrefaite :",
    options: [
      "Peut constituer un faux si la copie a valeur probatoire",
      "Ne peut jamais constituer un faux",
      "Est seulement une contravention",
    ],
    answer: "Peut constituer un faux si la copie a valeur probatoire",
    explanation:
        "La possibilité dépend de la valeur probatoire reconnue à la copie.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Faux matériel",
    question: "Le faux matériel se caractérise par :",
    options: [
      "Une altération du support (aspect physique) laissant des traces matérielles",
      "Un mensonge uniquement dans le contenu sans modifier le support",
      "Une simple erreur involontaire",
    ],
    answer:
        "Une altération du support (aspect physique) laissant des traces matérielles",
    explanation:
        "Faux matériel = falsification du support (suppression/modification/adjonction, imitation, fabrication…).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Faux intellectuel",
    question: "Le faux intellectuel correspond plutôt à :",
    options: [
      "Un défaut de véracité : mensonge sur le contenu (faits) plutôt que sur le support",
      "Une déchirure visible du document",
      "Un document complètement vierge",
    ],
    answer:
        "Un défaut de véracité : mensonge sur le contenu (faits) plutôt que sur le support",
    explanation:
        "Mensonge atteint le contenu de l’écrit/support, pas l’aspect matériel.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Préjudice",
    question: "Le préjudice exigé par 441-1 CP :",
    options: [
      "N’a pas besoin d’être réalisé : il suffit qu’il soit possible (de nature à causer un préjudice)",
      "Doit toujours être chiffré et prouvé",
      "Doit forcément être matériel uniquement",
    ],
    answer:
        "N’a pas besoin d’être réalisé : il suffit qu’il soit possible (de nature à causer un préjudice)",
    explanation:
        "Le texte exige « de nature à causer un préjudice », pas un préjudice effectivement subi.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Préjudice social",
    question: "Le préjudice social concerne :",
    options: [
      "L’atteinte aux intérêts moraux de la société (confiance dans certains actes)",
      "Uniquement une perte d’argent",
      "Uniquement une atteinte à l’image d’une entreprise",
    ],
    answer:
        "L’atteinte aux intérêts moraux de la société (confiance dans certains actes)",
    explanation: "Le cours distingue préjudice matériel / moral / social.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Usage",
    question: "L’usage de faux (441-1) suppose :",
    options: [
      "L’existence préalable d’un faux et un acte positif d’utilisation",
      "Une simple abstention (ne rien faire)",
      "Uniquement le fait de détenir le document",
    ],
    answer: "L’existence préalable d’un faux et un acte positif d’utilisation",
    explanation:
        "Usage = utilisation positive de la pièce fausse ; l’abstention ne suffit pas.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Infraction instantanée",
    question: "L’usage de faux est une infraction :",
    options: [
      "Instantanée : chaque acte d’usage est une nouvelle infraction",
      "Continue : un seul usage pour toute la vie",
      "Non punissable",
    ],
    answer: "Instantanée : chaque acte d’usage est une nouvelle infraction",
    explanation:
        "Chaque utilisation = nouvelle infraction ; prescription court à partir de la dernière utilisation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Élément moral (faux)",
    question: "Concernant le faux (441-1), l’élément moral exige :",
    options: [
      "La volonté de réaliser la falsification et la conscience d’altérer la vérité de nature à causer un préjudice",
      "Une simple négligence",
      "Un mobile particulier (obligatoire)",
    ],
    answer:
        "La volonté de réaliser la falsification et la conscience d’altérer la vérité de nature à causer un préjudice",
    explanation: "Volonté + conscience ; mobiles indifférents.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Élément moral (usage)",
    question: "Concernant l’usage de faux (441-1), l’élément moral exige :",
    options: [
      "La volonté d’user + la connaissance de la fausseté",
      "La volonté d’user seulement",
      "La connaissance seulement",
    ],
    answer: "La volonté d’user + la connaissance de la fausseté",
    explanation:
        "Double exigence : volonté d’utiliser la pièce + connaissance qu’elle est fausse.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Circonstances aggravantes",
    question: "Le cours indique des circonstances aggravantes pour 441-1 :",
    options: [
      "Aucune (pour l’infraction générale 441-1)",
      "En réunion",
      "Si l’auteur est détenu",
    ],
    answer: "Aucune (pour l’infraction générale 441-1)",
    explanation:
        "Dans ta page : IV — circonstances aggravantes : AUCUNE pour 441-1.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Peines",
    question: "Les peines principales prévues par 441-1 (faux et usage) sont :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Peines 441-1 : 3 ans + 45 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux / Usage de faux (441-1) — Tentative",
    question: "La tentative des délits prévus par 441-1 est :",
    options: [
      "Punissable (441-9 prévoit expressément la tentative)",
      "Non punissable",
      "Punissable seulement si usage",
    ],
    answer: "Punissable (441-9 prévoit expressément la tentative)",
    explanation:
        "441-9 CP : tentative des délits 441-1 (et autres) expressément prévue.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // FAUX DANS UN DOCUMENT ADMINISTRATIF + USAGE (441-2)
  // =========================================================
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Définition",
    question: "Le faux dans un document administratif (441-2) consiste à :",
    options: [
      "Contrefaire ou falsifier un document délivré par l’administration (droit/identité/qualité/autorisation) ; l’usage est aussi réprimé",
      "Obtenir un document authentique sans droit",
      "Refuser de présenter un document",
    ],
    answer:
        "Contrefaire ou falsifier un document délivré par l’administration (droit/identité/qualité/autorisation) ; l’usage est aussi réprimé",
    explanation:
        "441-2 vise les faux matériels (et réprime aussi l’usage) sur des documents administratifs.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Texte",
    question: "Le faux commis dans un document administratif est réprimé par :",
    options: [
      "Article 441-2 du Code pénal",
      "Article 441-5 du Code pénal",
      "Article 441-6 du Code pénal",
    ],
    answer: "Article 441-2 du Code pénal",
    explanation: "Base légale : 441-2 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Documents visés",
    question:
        "Les documents administratifs visés par 441-2 sont établis pour :",
    options: [
      "Constater un droit, une identité, une qualité ou accorder une autorisation",
      "Uniquement prouver une relation familiale",
      "Uniquement servir d’information sans effet",
    ],
    answer:
        "Constater un droit, une identité, une qualité ou accorder une autorisation",
    explanation:
        "Le texte reprend la finalité probatoire/autorisation des documents administratifs.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Exemples",
    question: "Parmi ces documents, lequel est typiquement visé par 441-2 ?",
    options: [
      "Carte d’identité / titre de séjour / permis (conduire, construire, chasser)",
      "Simple brouillon personnel",
      "Message oral non enregistré",
    ],
    answer:
        "Carte d’identité / titre de séjour / permis (conduire, construire, chasser)",
    explanation:
        "Exemples cités : CNI, titre de séjour, certificat de nationalité, permis de construire/chasser/conduire, carte grise, certificat de mariage…",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Nature du faux",
    question: "Selon ta page, 441-2 vise principalement :",
    options: [
      "Les faux matériels (falsification du support / contrefaçon)",
      "Uniquement les faux intellectuels",
      "Uniquement les omissions involontaires",
    ],
    answer: "Les faux matériels (falsification du support / contrefaçon)",
    explanation:
        "Le cours insiste sur la contrefaçon/falsification matérielle du document administratif.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Préjudice",
    question: "Concernant 441-2, la jurisprudence indique que le préjudice :",
    options: [
      "Découle de la nature de la pièce faussée",
      "Doit être obligatoirement chiffré par expertise",
      "N’existe jamais pour les documents administratifs",
    ],
    answer: "Découle de la nature de la pièce faussée",
    explanation:
        "Ta page cite la jurisprudence : le préjudice découle de la nature de la pièce faussée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Usage",
    question: "L’usage de faux (441-2) suppose :",
    options: [
      "Un document administratif préalablement falsifié",
      "Un document devenu simplement inexact avec le temps",
      "Une déclaration orale",
    ],
    answer: "Un document administratif préalablement falsifié",
    explanation:
        "Usage ne se conçoit que sur un document falsifié. Sinon, on est sur autre chose (ex : R.645-8).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Contravention",
    question:
        "L’usage d’un document administratif dont les mentions sont devenues incomplètes ou inexactes constitue :",
    options: [
      "Une contravention de 5e classe (R.645-8 CP)",
      "Un délit 441-2 automatiquement",
      "Un crime 441-4",
    ],
    answer: "Une contravention de 5e classe (R.645-8 CP)",
    explanation:
        "Ta page le précise : document non falsifié mais mentions inexactes/incomplètes → R.645-8.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Élément moral (faux)",
    question: "Pour le faux (441-2), l’élément moral implique :",
    options: [
      "Volonté de falsifier + conscience d’altérer la vérité / l’intégrité du document",
      "Simple imprudence",
      "Nécessité d’un mobile particulier",
    ],
    answer:
        "Volonté de falsifier + conscience d’altérer la vérité / l’intégrité du document",
    explanation:
        "L’acte de falsification révèle l’intention ; mobiles indifférents.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Élément moral (usage)",
    question: "Pour l’usage de faux (441-2), il faut :",
    options: [
      "Volonté d’user + connaissance de la fausseté",
      "Volonté d’user seulement",
      "Connaissance seulement",
    ],
    answer: "Volonté d’user + connaissance de la fausseté",
    explanation: "Conditions classiques rappelées dans ta page.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Aggravation 1°",
    question: "441-2 est aggravé lorsque le faux ou l’usage est commis :",
    options: [
      "Par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public, dans l’exercice des fonctions",
      "En présence de témoins",
      "La nuit",
    ],
    answer:
        "Par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public, dans l’exercice des fonctions",
    explanation: "Aggravation prévue par 441-2 1°.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Aggravation 3°",
    question: "441-2 est aggravé lorsque le faux/usage est commis :",
    options: [
      "Dans le dessein de faciliter la commission d’un crime ou de procurer l’impunité à son auteur",
      "Pour éviter un retard administratif",
      "Pour prouver une opinion",
    ],
    answer:
        "Dans le dessein de faciliter la commission d’un crime ou de procurer l’impunité à son auteur",
    explanation:
        "Aggravation : dessein de faciliter un crime / procurer impunité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Peines simples",
    question:
        "Les peines principales du faux/usage de faux administratif (441-2) simple sont :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "10 ans d’emprisonnement et 150 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Tableau : 441-2 al.1 et 2 → 5 ans + 75 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Peines aggravées",
    question: "Les peines aggravées (441-2) sont :",
    options: [
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende",
    explanation: "Tableau : aggravations 1°/2°/3° → 7 ans + 100 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Tentative",
    question: "La tentative des délits 441-2 est :",
    options: [
      "Punissable (prévue par 441-9 CP)",
      "Non punissable",
      "Punissable seulement si usage",
    ],
    answer: "Punissable (prévue par 441-9 CP)",
    explanation: "441-9 prévoit expressément la tentative des délits 441-2.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux doc administratif (441-2) — Auteur de faux",
    question:
        "Peut être considéré comme auteur du faux (pas seulement complice) :",
    options: [
      "Celui qui donne l’ordre de commettre le faux, au même titre que celui qui le fabrique",
      "Uniquement celui qui tient le document dans ses mains",
      "Uniquement la victime",
    ],
    answer:
        "Celui qui donne l’ordre de commettre le faux, au même titre que celui qui le fabrique",
    explanation:
        "Ta page : la jurisprudence considère auteur celui qui donne l’ordre (ex : secrétaire de mairie).",
    difficulty: "Difficile",
  ),

  // =========================================================
  // FAUX DANS ÉCRITURE PUBLIQUE / AUTHENTIQUE + USAGE (441-4)
  // =========================================================
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Définition",
    question: "Le faux (441-4) vise :",
    options: [
      "Un faux dans une écriture publique/authentique ou un enregistrement ordonné par l’autorité publique ; usage également réprimé",
      "Uniquement les documents administratifs type CNI",
      "Uniquement les attestations entre particuliers",
    ],
    answer:
        "Un faux dans une écriture publique/authentique ou un enregistrement ordonné par l’autorité publique ; usage également réprimé",
    explanation:
        "441-4 : faux dans écritures publiques/authentiques + enregistrements ordonnés + usage.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Texte",
    question: "Le texte applicable est :",
    options: [
      "Article 441-4 du Code pénal",
      "Article 441-2 du Code pénal",
      "Article 441-7 du Code pénal",
    ],
    answer: "Article 441-4 du Code pénal",
    explanation: "Base légale : 441-4 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category:
        "Faux écriture publique/authentique (441-4) — Écritures publiques",
    question: "Les écritures publiques sont des écrits rédigés par :",
    options: [
      "Un représentant de l’autorité publique agissant en vertu de ses fonctions",
      "Un particulier pour lui-même",
      "Un mineur non habilité",
    ],
    answer:
        "Un représentant de l’autorité publique agissant en vertu de ses fonctions",
    explanation:
        "Définition dans ta page : représentant de l’autorité publique en fonction.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category:
        "Faux écriture publique/authentique (441-4) — Écritures authentiques",
    question: "Les écritures authentiques sont établies par :",
    options: [
      "Un officier public habilité par la loi à établir certains actes/constatations",
      "N’importe quel citoyen",
      "Uniquement un policier",
    ],
    answer:
        "Un officier public habilité par la loi à établir certains actes/constatations",
    explanation: "Notaire, huissier, greffier… selon les catégories évoquées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Actes judiciaires",
    question:
        "Parmi ces exemples, lequel correspond à un acte judiciaire cité ?",
    options: [
      "Décision de justice / PV établi par OPJ/APJ / actes de procédure",
      "Carte grise",
      "Permis de chasser",
    ],
    answer: "Décision de justice / PV établi par OPJ/APJ / actes de procédure",
    explanation:
        "Ta page : actes judiciaires = décisions, PV OPJ/APJ, actes de procédure (assignation, appel…).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Enregistrements",
    question:
        "Les enregistrements ordonnés par l’autorité publique peuvent être :",
    options: [
      "Sonores/visuels/audiovisuels (écoutes, interrogatoires filmés, etc.)",
      "Uniquement des emails privés",
      "Uniquement des notes manuscrites",
    ],
    answer:
        "Sonores/visuels/audiovisuels (écoutes, interrogatoires filmés, etc.)",
    explanation:
        "Ta page : enregistrements ordonnés par autorité publique (écoutes, interrogatoires mineurs…).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Préjudice",
    question: "Pour 441-4, le préjudice éventuel est :",
    options: [
      "Nécessairement établi car l’acte porte atteinte à la foi publique",
      "Toujours absent",
      "À prouver uniquement par un chiffrage comptable",
    ],
    answer: "Nécessairement établi car l’acte porte atteinte à la foi publique",
    explanation:
        "Falsification d’un acte public/authentique porte atteinte à la foi publique → préjudice éventuel établi.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Usage",
    question: "L’usage de faux (441-4) est constitué si :",
    options: [
      "La pièce fausse est utilisée par un acte quelconque en vue du résultat final (ou acte de nature à causer préjudice)",
      "La pièce est simplement conservée sans jamais être utilisée",
      "La pièce est seulement lue à voix haute sans effet",
    ],
    answer:
        "La pièce fausse est utilisée par un acte quelconque en vue du résultat final (ou acte de nature à causer préjudice)",
    explanation:
        "Ta page : il suffit d’un acte quelconque d’utilisation en vue du résultat final (ou de nature à causer préjudice).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Aggravation",
    question: "441-4 est aggravé lorsque le faux/usage est commis :",
    options: [
      "Par une personne dépositaire/chargée de mission de SP agissant dans l’exercice des fonctions",
      "Par un particulier sans lien",
      "En cas de mauvais temps",
    ],
    answer:
        "Par une personne dépositaire/chargée de mission de SP agissant dans l’exercice des fonctions",
    explanation:
        "Article 441-4 al.3 : circonstance aggravante de qualité + exercice des fonctions.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Peine simple",
    question:
        "La peine principale du faux en écriture publique/authentique (441-4) simple est :",
    options: [
      "10 ans d’emprisonnement",
      "5 ans d’emprisonnement et 75 000 €",
      "3 ans d’emprisonnement et 45 000 €",
    ],
    answer: "10 ans d’emprisonnement",
    explanation: "Tableau : 441-4 (simple) → 10 ans d’emprisonnement.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Peine aggravée",
    question:
        "La peine aggravée du 441-4 (qualité dépositaire/service public) est :",
    options: [
      "15 ans de réclusion",
      "7 ans d’emprisonnement et 100 000 €",
      "2 ans d’emprisonnement et 30 000 €",
    ],
    answer: "15 ans de réclusion",
    explanation: "Tableau : 441-4 al.3 → crime : 15 ans de réclusion.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux écriture publique/authentique (441-4) — Tentative",
    question: "La tentative des délits 441-4 est :",
    options: [
      "Punissable (441-9 CP)",
      "Non punissable",
      "Punissable seulement si usage",
    ],
    answer: "Punissable (441-9 CP)",
    explanation: "441-9 prévoit la tentative pour les délits 441-4.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // DÉLIVRANCE INDUE DE DOCUMENT ADMINISTRATIF (441-5)
  // =========================================================
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Définition",
    question:
        "La délivrance indue de document administratif (441-5) consiste à :",
    options: [
      "Procurer frauduleusement à autrui un document authentique délivré par une administration (droit/identité/qualité/autorisation)",
      "Falsifier matériellement une carte d’identité",
      "Refuser de présenter un document",
    ],
    answer:
        "Procurer frauduleusement à autrui un document authentique délivré par une administration (droit/identité/qualité/autorisation)",
    explanation:
        "441-5 vise des documents authentiques procurés frauduleusement à une personne qui n’y a pas droit (pas des faux).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Texte",
    question:
        "La délivrance indue de document administratif est réprimée par :",
    options: [
      "Article 441-5 du Code pénal",
      "Article 441-6 du Code pénal",
      "Article 441-2 du Code pénal",
    ],
    answer: "Article 441-5 du Code pénal",
    explanation: "Base légale : 441-5 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Nature du document",
    question: "Les documents visés par 441-5 sont :",
    options: [
      "Des documents authentiques (pas des faux)",
      "Uniquement des documents falsifiés",
      "Uniquement des documents privés",
    ],
    answer: "Des documents authentiques (pas des faux)",
    explanation:
        "Le cours insiste : 441-5 ne s’applique pas à des faux mais à des documents authentiques délivrés indûment.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Exemples",
    question: "Lequel est un exemple de document visé par 441-5 ?",
    options: [
      "Passeport / carte d’identité / titre de séjour",
      "SMS entre amis",
      "Photo personnelle sans usage juridique",
    ],
    answer: "Passeport / carte d’identité / titre de séjour",
    explanation: "Documents d’identité cités dans la page.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Documents de droit/qualité",
    question:
        "Parmi ces exemples, lesquels peuvent constater un droit ou une qualité ?",
    options: [
      "Certificat de nationalité / carte grise / récépissés administratifs",
      "Ticket de caisse ordinaire",
      "Lettre d’amour",
    ],
    answer:
        "Certificat de nationalité / carte grise / récépissés administratifs",
    explanation:
        "Catégorie citée : droit/qualité (certificat de nationalité, carte grise, récépissés…).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Autorisations",
    question:
        "Lequel correspond à un document accordant une autorisation (441-5) ?",
    options: [
      "Permis de construire / permis de chasser / permis de conduire",
      "Carte de fidélité",
      "Carte de visite",
    ],
    answer: "Permis de construire / permis de chasser / permis de conduire",
    explanation:
        "Le cours cite explicitement ces permis comme documents d’autorisation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Procurer à autrui",
    question: "« Procurer » un document à autrui signifie :",
    options: [
      "Fournir/remettre le document (même via un tiers de bonne foi)",
      "Seulement imprimer le document sans le donner",
      "Seulement conseiller verbalement",
    ],
    answer: "Fournir/remettre le document (même via un tiers de bonne foi)",
    explanation:
        "Le fait de procurer est réalisé même si le document est remis par un tiers de bonne foi.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Fraude (caractérisation)",
    question: "Le caractère frauduleux est caractérisé dès lors que l’auteur :",
    options: [
      "Délivre ou fait délivrer un document à une personne qu’il sait ne pas y avoir droit",
      "Commet une simple erreur administrative",
      "Ignore totalement l’identité du demandeur",
    ],
    answer:
        "Délivre ou fait délivrer un document à une personne qu’il sait ne pas y avoir droit",
    explanation:
        "Ta page : fraude caractérisée par la connaissance de l’absence de droit (Cass. crim., 26 janv. 1993).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Élément moral",
    question: "L’élément moral de 441-5 exige :",
    options: [
      "La remise en toute connaissance de cause (savoir que le bénéficiaire n’y a pas droit)",
      "Une simple imprudence",
      "Un mobile particulier obligatoire",
    ],
    answer:
        "La remise en toute connaissance de cause (savoir que le bénéficiaire n’y a pas droit)",
    explanation:
        "Le cours : l’agent sait qu’il procure un document à des personnes qui n’y ont pas droit.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Aggravation 1°",
    question: "441-5 est aggravé lorsque l’infraction est commise :",
    options: [
      "Par une personne dépositaire de l’autorité publique ou chargée d’une mission de SP, dans l’exercice des fonctions",
      "Par un mineur",
      "En état de fatigue",
    ],
    answer:
        "Par une personne dépositaire de l’autorité publique ou chargée d’une mission de SP, dans l’exercice des fonctions",
    explanation: "441-5 1° : qualité + exercice des fonctions.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Aggravation 2°",
    question: "441-5 est aggravé lorsque l’infraction est commise :",
    options: [
      "De manière habituelle",
      "Sur la voie publique",
      "Avec un téléphone",
    ],
    answer: "De manière habituelle",
    explanation: "441-5 2° : commission habituelle.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Aggravation 3°",
    question: "441-5 est aggravé lorsqu’il est commis :",
    options: [
      "Dans le dessein de faciliter la commission d’un crime ou de procurer l’impunité",
      "Pour accélérer une file d’attente",
      "Par erreur de formulaire",
    ],
    answer:
        "Dans le dessein de faciliter la commission d’un crime ou de procurer l’impunité",
    explanation: "441-5 3° : dessein de faciliter crime / procurer impunité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Peines simples",
    question: "Les peines principales de 441-5 simple sont :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Tableau 441-5 al.1 : 5 ans + 75 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Peines aggravées",
    question: "Les peines aggravées de 441-5 (1°,2°,3°) sont :",
    options: [
      "7 ans de réclusion et 100 000 € d’amende",
      "5 ans et 75 000 €",
      "10 ans et 150 000 €",
    ],
    answer: "7 ans de réclusion et 100 000 € d’amende",
    explanation: "Tableau : aggravée → 7 ans (réclusion) + 100 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Tentative",
    question: "La tentative des délits 441-5 est :",
    options: [
      "Punissable (441-9 CP le prévoit expressément)",
      "Non punissable",
      "Punissable seulement si le document est utilisé",
    ],
    answer: "Punissable (441-9 CP le prévoit expressément)",
    explanation: "Ta page : 441-9 prévoit la tentative des délits de 441-5.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Délivrance indue (441-5) — Personnes morales",
    question:
        "La responsabilité pénale des personnes morales est prévue pour 441-5 par :",
    options: [
      "Article 441-12 du Code pénal",
      "Article 121-7 du Code pénal",
      "Article 433-10 du Code pénal",
    ],
    answer: "Article 441-12 du Code pénal",
    explanation:
        "Ta page : 441-12 prévoit la responsabilité pénale des personnes morales.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // OBTENTION INDUE DE DOCUMENT ADMINISTRATIF + FAUSSE DÉCLARATION (441-6)
  // =========================================================
  const QuizQuestion(
    category: "Obtention indue (441-6) — Définition",
    question:
        "L’obtention indue de document administratif (441-6) consiste à :",
    options: [
      "Se faire délivrer indûment, par moyen frauduleux, un document destiné à constater droit/identité/qualité/autorisation",
      "Fabriquer un faux passeport",
      "Donner un document authentique à quelqu’un d’autre",
    ],
    answer:
        "Se faire délivrer indûment, par moyen frauduleux, un document destiné à constater droit/identité/qualité/autorisation",
    explanation:
        "441-6 vise l’action de se faire délivrer indûment un document (authentique) par quelque moyen frauduleux.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Texte",
    question: "Le texte qui définit et réprime l’obtention indue est :",
    options: [
      "Article 441-6 du Code pénal",
      "Article 441-5 du Code pénal",
      "Article 441-2 du Code pénal",
    ],
    answer: "Article 441-6 du Code pénal",
    explanation: "Base légale : 441-6 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Document authentique",
    question: "441-6 s’applique à :",
    options: [
      "Des documents authentiques obtenus indûment (pas des faux)",
      "Uniquement des documents falsifiés",
      "Uniquement des documents privés",
    ],
    answer: "Des documents authentiques obtenus indûment (pas des faux)",
    explanation:
        "Comme 441-5, l’infraction ne vise pas des faux mais des documents authentiques obtenus indûment.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Organismes visés",
    question:
        "En plus des administrations, 441-6 vise aussi les documents délivrés par :",
    options: [
      "Un organisme chargé d’une mission de service public (ex : sécu, OFPRA, Pôle emploi)",
      "Uniquement une mairie",
      "Uniquement des entreprises privées",
    ],
    answer:
        "Un organisme chargé d’une mission de service public (ex : sécu, OFPRA, Pôle emploi)",
    explanation:
        "Le texte étend l’incrimination aux organismes chargés d’une mission de SP.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Moyens frauduleux",
    question: "Les moyens frauduleux peuvent être :",
    options: [
      "Fausses déclarations, faux renseignements/certificats/attestations, déclarations d’un tiers, manœuvres (ex : mariage de complaisance)",
      "Uniquement un faux document administratif",
      "Uniquement une violence",
    ],
    answer:
        "Fausses déclarations, faux renseignements/certificats/attestations, déclarations d’un tiers, manœuvres (ex : mariage de complaisance)",
    explanation:
        "Ta page détaille plusieurs moyens : fausses déclarations, faux renseignements, tiers, manœuvres.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Mariage de complaisance",
    question:
        "Le mariage de complaisance peut constituer des manœuvres frauduleuses lorsqu’il vise :",
    options: [
      "L’obtention indue d’un titre de séjour",
      "L’obtention d’un permis de conduire",
      "Un simple changement d’adresse",
    ],
    answer: "L’obtention indue d’un titre de séjour",
    explanation:
        "Ta page cite le mariage de complaisance comme manœuvre pour obtenir indûment un titre de séjour.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Préjudice",
    question: "Pour 441-6, l’infraction :",
    options: [
      "N’a pas besoin d’être préjudiciable pour être qualifiée",
      "Exige un préjudice chiffré",
      "N’existe que si un agent est trompé volontairement par écrit",
    ],
    answer: "N’a pas besoin d’être préjudiciable pour être qualifiée",
    explanation:
        "Ta page : pas nécessaire qu’elle soit préjudiciable pour être qualifiée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Alinéa 2 (avantages indus)",
    question: "441-6 al.2 assimile aussi à l’infraction :",
    options: [
      "Fournir sciemment une fausse déclaration ou une déclaration incomplète pour obtenir/tenter d’obtenir une allocation, prestation, paiement ou avantage indu",
      "Insulter un agent public",
      "Se battre dans une file d’attente",
    ],
    answer:
        "Fournir sciemment une fausse déclaration ou une déclaration incomplète pour obtenir/tenter d’obtenir une allocation, prestation, paiement ou avantage indu",
    explanation:
        "Ta page : al.2 = fausse/incomplète déclaration pour obtenir ou tenter d’obtenir un avantage indu.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Fausse vs incomplète",
    question: "Une déclaration « incomplète » peut consister en :",
    options: [
      "L’omission volontaire de faits exacts",
      "Une faute de frappe involontaire",
      "Un document illisible",
    ],
    answer: "L’omission volontaire de faits exacts",
    explanation:
        "Ta page : altération de la vérité = affirmation de faits faux OU omission de faits exacts.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Consommation",
    question: "Concernant 441-6 al.2, l’infraction est consommée :",
    options: [
      "Même si l’avantage n’a pas été obtenu, dès lors que la déclaration est faite dans le but d’obtenir",
      "Seulement si l’avantage est effectivement versé",
      "Seulement si la déclaration est écrite",
    ],
    answer:
        "Même si l’avantage n’a pas été obtenu, dès lors que la déclaration est faite dans le but d’obtenir",
    explanation:
        "Ta page : pas besoin que l’avantage soit obtenu ; suffit du but (obtenir ou faire obtenir).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Élément moral",
    question: "L’élément moral de 441-6 implique :",
    options: [
      "Conscience de se faire délivrer indûment + volonté d’utiliser un moyen frauduleux",
      "Simple négligence",
      "Aucun élément moral",
    ],
    answer:
        "Conscience de se faire délivrer indûment + volonté d’utiliser un moyen frauduleux",
    explanation:
        "Ta page : conscience + volonté d’employer un moyen frauduleux (et pour al.2 : fausse/incomplète volontaire).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Circonstances aggravantes",
    question: "441-6 prévoit des circonstances aggravantes :",
    options: ["Aucune", "En réunion", "Si arme"],
    answer: "Aucune",
    explanation: "Ta page : IV — Circonstances aggravantes : AUCUNE.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Peines",
    question: "Les peines principales de 441-6 (alinéa 1 et 2) sont :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation: "Tableau : 441-6 al.1 / al.2 → 2 ans + 30 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Obtention indue (441-6) — Tentative",
    question: "La tentative des délits 441-6 est :",
    options: [
      "Punissable (441-9 CP)",
      "Non punissable",
      "Punissable seulement si avantage obtenu",
    ],
    answer: "Punissable (441-9 CP)",
    explanation: "441-9 prévoit la tentative des délits 441-6.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // FAUX CERTIFICATS / ATTESTATIONS (441-7)
  // =========================================================
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Définition",
    question: "441-7 incrimine notamment :",
    options: [
      "Établir une attestation/certificat matériellement inexact, falsifier un document sincère, ou en faire usage",
      "Obtenir un document authentique indûment",
      "Commettre un faux dans une carte d’identité",
    ],
    answer:
        "Établir une attestation/certificat matériellement inexact, falsifier un document sincère, ou en faire usage",
    explanation: "Ta page : établissement (inexact) / falsification / usage.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Texte",
    question: "Le texte applicable est :",
    options: [
      "Article 441-7 du Code pénal",
      "Article 441-6 du Code pénal",
      "Article 441-5 du Code pénal",
    ],
    answer: "Article 441-7 du Code pénal",
    explanation: "Base légale : 441-7 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category:
        "Faux certificats/attestations (441-7) — Définition jurisprudentielle",
    question: "Selon la jurisprudence, une attestation/certificat est :",
    options: [
      "Toute déclaration écrite, quelle que soit sa forme, faite en faveur d’autrui dans un but probatoire",
      "Toujours un document administratif officiel",
      "Toujours un acte notarié",
    ],
    answer:
        "Toute déclaration écrite, quelle que soit sa forme, faite en faveur d’autrui dans un but probatoire",
    explanation: "Définition rappelée dans ta page.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Écrit uniquement",
    question: "441-7 nécessite :",
    options: [
      "Un écrit (les renseignements oraux ne suffisent pas)",
      "Une déclaration orale enregistrée suffit",
      "Un SMS non sauvegardé suffit",
    ],
    answer: "Un écrit (les renseignements oraux ne suffisent pas)",
    explanation:
        "Ta page : seul l’écrit est pris en compte ; l’oral ne constitue pas 441-7.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Signature",
    question: "Le document inexact doit notamment comporter :",
    options: [
      "La signature authentique de son auteur",
      "Un tampon de mairie obligatoire",
      "Une photo d’identité",
    ],
    answer: "La signature authentique de son auteur",
    explanation:
        "Ta page : exigence jurisprudentielle de signature authentique.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Profit d’un tiers",
    question: "Pour entrer dans 441-7, l’attestation doit être établie :",
    options: [
      "Au profit d’un tiers",
      "Pour soi-même (attestation sur l’honneur personnelle)",
      "Uniquement pour l’administration",
    ],
    answer: "Au profit d’un tiers",
    explanation:
        "Ta page : l’attestation sur l’honneur à son propre profit n’entre pas dans 441-7.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Établissement",
    question: "« Établir » une attestation signifie :",
    options: [
      "Rédiger le document et le signer",
      "Le lire à haute voix",
      "Le déchirer",
    ],
    answer: "Rédiger le document et le signer",
    explanation: "Ta page : établissement = rédaction + signature.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category:
        "Faux certificats/attestations (441-7) — Faits matériellement inexacts",
    question: "« Faits matériellement inexacts » correspond à :",
    options: [
      "Éléments objectifs vérifiables susceptibles de preuve contraire",
      "Opinions subjectives non vérifiables",
      "Jugements de valeur",
    ],
    answer: "Éléments objectifs vérifiables susceptibles de preuve contraire",
    explanation: "Ta page : éléments objectifs, vérifiables/constatables.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Consommation",
    question:
        "L’infraction d’établissement d’une attestation inexacte est consommée :",
    options: [
      "Dès l’établissement, même sans usage ultérieur",
      "Seulement si un tribunal l’utilise",
      "Seulement si la victime est condamnée clarifiée",
    ],
    answer: "Dès l’établissement, même sans usage ultérieur",
    explanation: "Ta page : consommée indépendamment de l’usage par la suite.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Falsification",
    question:
        "La falsification d’un certificat sincère à l’origine correspond à :",
    options: [
      "Une altération de la vérité dans le document (ex : modifier une date, un résultat)",
      "Le simple fait de l’oublier",
      "Le fait d’en parler oralement",
    ],
    answer:
        "Une altération de la vérité dans le document (ex : modifier une date, un résultat)",
    explanation:
        "Ta page : exemples de surcharge de date, modification d’analyse de sang.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Usage",
    question: "L’usage d’un certificat/attestation falsifié suppose :",
    options: [
      "L’existence préalable d’un établissement inexact ou d’une falsification",
      "Aucun acte préalable",
      "Une simple intention non réalisée",
    ],
    answer:
        "L’existence préalable d’un établissement inexact ou d’une falsification",
    explanation: "Usage = utilisation d’un document déjà inexact/falsifié.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Élément moral",
    question: "L’élément moral de l’établissement (441-7) repose sur :",
    options: [
      "La connaissance de l’inexactitude des faits certifiés",
      "Une simple imprudence",
      "Un mobile spécial obligatoire",
    ],
    answer: "La connaissance de l’inexactitude des faits certifiés",
    explanation:
        "Ta page : connaissance de l’inexactitude ; pas besoin d’anticiper l’usage que le tiers en fera.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Aggravation al.5",
    question:
        "L’infraction 441-7 est aggravée notamment lorsqu’elle est commise :",
    options: [
      "En vue de porter préjudice au Trésor public ou au patrimoine d’autrui, ou pour obtenir un titre de séjour / protection contre l’éloignement",
      "En réunion",
      "La nuit",
    ],
    answer:
        "En vue de porter préjudice au Trésor public ou au patrimoine d’autrui, ou pour obtenir un titre de séjour / protection contre l’éloignement",
    explanation: "Ta page : 441-7 al.5 prévoit ces hypothèses aggravantes.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Peines simples",
    question: "Les peines principales de 441-7 (simple) sont :",
    options: [
      "1 an d’emprisonnement et 15 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 €",
      "3 ans d’emprisonnement et 45 000 €",
    ],
    answer: "1 an d’emprisonnement et 15 000 € d’amende",
    explanation: "Ta page : simple → 1 an + 15 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Peines aggravées",
    question: "Les peines aggravées de 441-7 sont :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 €",
      "7 ans d’emprisonnement et 100 000 €",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Ta page : aggravée → 3 ans + 45 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux certificats/attestations (441-7) — Tentative",
    question: "La tentative de 441-7 est :",
    options: [
      "Punissable (441-9 CP)",
      "Non punissable",
      "Punissable seulement en cas d’usage",
    ],
    answer: "Punissable (441-9 CP)",
    explanation: "Ta page : 441-9 prévoit la tentative des délits 441-7.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // DISTINCTIONS “PIÈGES” — 441-1 / 441-2 / 441-4 / 441-5 / 441-6 / 441-7
  // =========================================================
  const QuizQuestion(
    category: "Piège — 441-5 vs 441-6",
    question: "La différence clé entre 441-5 et 441-6 est que :",
    options: [
      "441-5 = procurer frauduleusement à autrui ; 441-6 = se faire délivrer indûment (obtenir) par fraude",
      "441-5 = faux matériel ; 441-6 = faux intellectuel",
      "441-5 = contravention ; 441-6 = crime",
    ],
    answer:
        "441-5 = procurer frauduleusement à autrui ; 441-6 = se faire délivrer indûment (obtenir) par fraude",
    explanation:
        "441-5 = délivrance/procure à autrui ; 441-6 = obtention indue par le bénéficiaire (ou pour autrui via fraude).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège — Document authentique vs faux",
    question: "Quel duo correspond correctement ?",
    options: [
      "441-5/441-6 : documents authentiques obtenus/délivrés indûment ; 441-2/441-4 : documents falsifiés",
      "441-5 : documents falsifiés ; 441-2 : authentiques",
      "441-6 : uniquement des attestations privées",
    ],
    answer:
        "441-5/441-6 : documents authentiques obtenus/délivrés indûment ; 441-2/441-4 : documents falsifiés",
    explanation:
        "441-5 et 441-6 ≠ faux : ce sont des documents authentiques délivrés/obtenus frauduleusement. 441-2/441-4 = faux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — 441-2 vs 441-4",
    question: "La différence principale entre 441-2 et 441-4 :",
    options: [
      "441-2 = faux dans document administratif délivré pour droit/identité/qualité/autorisation ; 441-4 = faux dans écriture publique/authentique ou enregistrement ordonné",
      "441-2 = uniquement enregistrement audio ; 441-4 = uniquement carte grise",
      "441-2 = contravention ; 441-4 = amende seule",
    ],
    answer:
        "441-2 = faux dans document administratif délivré pour droit/identité/qualité/autorisation ; 441-4 = faux dans écriture publique/authentique ou enregistrement ordonné",
    explanation:
        "Deux faux “spéciaux” différents : administratif vs écriture publique/authentique/enregistrement.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — 441-7 vs 441-1",
    question: "Pourquoi 441-7 est un texte « spécial » par rapport à 441-1 ?",
    options: [
      "Il vise spécifiquement les attestations/certificats (établissement, falsification, usage) au profit d’autrui",
      "Il ne punit pas l’usage",
      "Il vise seulement les documents administratifs officiels",
    ],
    answer:
        "Il vise spécifiquement les attestations/certificats (établissement, falsification, usage) au profit d’autrui",
    explanation:
        "441-7 est dédié aux attestations/certificats (écrit probatoire en faveur d’autrui).",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // VRAI / FAUX — format QCM (3 options)
  // =========================================================
  const QuizQuestion(
    category: "Vrai/Faux — 441-5",
    question:
        "Vrai ou Faux : 441-5 s’applique à des documents falsifiés (faux documents).",
    options: ["Vrai", "Faux", "Ça dépend du support"],
    answer: "Faux",
    explanation:
        "441-5 vise des documents authentiques procurés indûment (pas des faux).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-6",
    question:
        "Vrai ou Faux : 441-6 peut viser un document délivré par un organisme chargé d’une mission de service public.",
    options: ["Vrai", "Faux", "Uniquement si c’est une mairie"],
    answer: "Vrai",
    explanation:
        "Le texte étend l’incrimination aux organismes de mission de SP (ex : sécu, OFPRA, Pôle emploi).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-1",
    question:
        "Vrai ou Faux : pour 441-1, il faut un préjudice déjà subi pour que l’infraction existe.",
    options: ["Vrai", "Faux", "Uniquement si usage"],
    answer: "Faux",
    explanation:
        "Il suffit que l’altération soit de nature à causer un préjudice.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Usage",
    question:
        "Vrai ou Faux : l’usage de faux peut résulter d’une simple abstention (ne rien faire).",
    options: ["Vrai", "Faux", "Seulement si c’est grave"],
    answer: "Faux",
    explanation:
        "Ta page : usage = fait positif d’utilisation ; l’abstention ne suffit pas.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-7",
    question:
        "Vrai ou Faux : une simple déclaration orale inexacte peut constituer 441-7.",
    options: ["Vrai", "Faux", "Si elle est répétée"],
    answer: "Faux",
    explanation: "441-7 exige un écrit ; l’oral ne suffit pas.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // MINI CAS PRATIQUES — Qualification + article + peine
  // =========================================================
  const QuizQuestion(
    category: "Cas pratique — 441-6 (obtention indue)",
    question:
        "Une personne fournit une fausse date d’entrée en France sur un formulaire pour obtenir un titre de séjour. Qualification + peine ?",
    options: [
      "Obtention indue de document administratif (441-6) — 2 ans et 30 000 €",
      "Délivrance indue (441-5) — 5 ans et 75 000 €",
      "Faux en écriture publique (441-4) — 10 ans",
    ],
    answer:
        "Obtention indue de document administratif (441-6) — 2 ans et 30 000 €",
    explanation:
        "Moyen frauduleux pour se faire délivrer un document authentique (titre de séjour) : 441-6. Peines : 2 ans + 30 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — 441-5 (délivrance indue)",
    question:
        "Un agent sait qu’un demandeur n’a pas droit au document, mais fait quand même délivrer une attestation administrative à son profit. Qualification + peine simple ?",
    options: [
      "Délivrance indue (441-5) — 5 ans et 75 000 €",
      "Obtention indue (441-6) — 2 ans et 30 000 €",
      "Faux général (441-1) — 3 ans et 45 000 €",
    ],
    answer: "Délivrance indue (441-5) — 5 ans et 75 000 €",
    explanation:
        "Procurer frauduleusement un document authentique à autrui = 441-5 (simple : 5 ans / 75 000 €).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — 441-2 (faux administratif) + usage",
    question:
        "Une personne falsifie matériellement une carte grise puis la présente pour obtenir un crédit. Qualification la plus adaptée ?",
    options: [
      "Faux dans un document administratif + usage (441-2) — 5 ans et 75 000 € (simple)",
      "Obtention indue (441-6) — 2 ans et 30 000 €",
      "Délivrance indue (441-5) — 5 ans et 75 000 €",
    ],
    answer:
        "Faux dans un document administratif + usage (441-2) — 5 ans et 75 000 € (simple)",
    explanation:
        "Document administratif falsifié (carte grise) + usage : 441-2 (simple : 5 ans / 75 000 €).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — 441-7 (attestation inexacte)",
    question:
        "Une personne rédige et signe une attestation pour aider un ami, en affirmant des faits vérifiables faux. Qualification + peine simple ?",
    options: [
      "Faux certificat/attestation (441-7) — 1 an et 15 000 €",
      "Faux administratif (441-2) — 5 ans et 75 000 €",
      "Obtention indue (441-6) — 2 ans et 30 000 €",
    ],
    answer: "Faux certificat/attestation (441-7) — 1 an et 15 000 €",
    explanation:
        "Attestation écrite en faveur d’autrui, faits matériellement inexacts : 441-7 (simple : 1 an / 15 000 €).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — 441-4 (écriture publique) aggravée",
    question:
        "Un agent public falsifie une écriture publique dans l’exercice de ses fonctions. Qualification + peine aggravée ?",
    options: [
      "Faux en écriture publique/authentique aggravé (441-4 al.3) — 15 ans de réclusion",
      "Faux administratif aggravé (441-2) — 7 ans et 100 000 €",
      "Faux général (441-1) — 3 ans et 45 000 €",
    ],
    answer:
        "Faux en écriture publique/authentique aggravé (441-4 al.3) — 15 ans de réclusion",
    explanation:
        "441-4 al.3 : aggravation si dépositaire/mission SP en exercice → crime : 15 ans de réclusion.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-1 — Définition",
    question: "Le faux (441-1) est :",
    options: [
      "Altération de la vérité, nature à causer un préjudice, sur support probatoire",
      "Simple mensonge oral sans support",
      "Critique d’une décision publique",
    ],
    answer:
        "Altération de la vérité, nature à causer un préjudice, sur support probatoire",
    explanation:
        "441-1 = altération + préjudice possible + support servant/pouvant servir de preuve.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-1 — Support",
    question: "Le support peut être :",
    options: [
      "Écrit ou support numérique",
      "Uniquement papier",
      "Uniquement acte notarié",
    ],
    answer: "Écrit ou support numérique",
    explanation:
        "Écrit OU tout autre support d’expression de la pensée (y compris numérique).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-1 — Valeur probatoire",
    question: "Le support doit :",
    options: [
      "Établir OU pouvoir établir la preuve d’un droit/fait à conséquences juridiques",
      "Être signé par un officier public",
      "Être délivré par l’administration",
    ],
    answer:
        "Établir OU pouvoir établir la preuve d’un droit/fait à conséquences juridiques",
    explanation: "Objet OU effet probatoire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-1 — Préjudice",
    question: "Le préjudice exigé :",
    options: [
      "Peut être seulement potentiel",
      "Doit être forcément réalisé",
      "Doit être uniquement matériel",
    ],
    answer: "Peut être seulement potentiel",
    explanation: "« De nature à causer » suffit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-1 — Faux matériel",
    question: "Faux matériel =",
    options: [
      "Altération du support (modif/suppression/adjonction/fabrication)",
      "Mensonge sur le contenu sans toucher au support",
      "Erreur involontaire",
    ],
    answer: "Altération du support (modif/suppression/adjonction/fabrication)",
    explanation: "Atteinte à l’aspect physique du document.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-1 — Faux intellectuel",
    question: "Faux intellectuel =",
    options: [
      "Mensonge sur le contenu (défaut de véracité)",
      "Ticket froissé",
      "Document perdu",
    ],
    answer: "Mensonge sur le contenu (défaut de véracité)",
    explanation: "Altération porte sur les faits, pas le support.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-1 — Usage de faux",
    question: "Usage de faux suppose :",
    options: [
      "Faux préalable + acte positif d’utilisation + connaissance",
      "Simple détention",
      "Abstention (laisser faire un tiers)",
    ],
    answer: "Faux préalable + acte positif d’utilisation + connaissance",
    explanation: "Usage = utiliser volontairement en sachant que c’est faux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-1 — Instantané",
    question: "L’usage de faux est :",
    options: [
      "Instantané (chaque usage compte)",
      "Continu (un seul)",
      "Non punissable",
    ],
    answer: "Instantané (chaque usage compte)",
    explanation:
        "Chaque utilisation = potentiellement une nouvelle infraction.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-1 — Mobiles",
    question: "Les mobiles de l’auteur :",
    options: [
      "Sont indifférents",
      "Doivent être lucratifs",
      "Doivent être politiques",
    ],
    answer: "Sont indifférents",
    explanation: "Ce qui compte = intention d’altérer la vérité.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-1 — Peines",
    question: "441-1 (faux/usage) :",
    options: ["3 ans + 45 000 €", "2 ans + 30 000 €", "5 ans + 75 000 €"],
    answer: "3 ans + 45 000 €",
    explanation: "Peines principales 441-1.",
    difficulty: "Facile",
  ),

  // (11) V/F
  const QuizQuestion(
    category: "Vrai/Faux — 441-1",
    question:
        "Vrai/Faux : un document « de hasard » peut être support du faux.",
    options: ["Vrai", "Faux", "Seulement s’il est administratif"],
    answer: "Vrai",
    explanation: "S’il acquiert une valeur probatoire ensuite.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Usage",
    question: "Vrai/Faux : la détention d’un faux = usage de faux.",
    options: ["Vrai", "Faux", "Uniquement si CNI"],
    answer: "Faux",
    explanation: "Usage nécessite un acte positif d’utilisation.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Préjudice",
    question: "Vrai/Faux : le préjudice doit être effectif pour 441-1.",
    options: ["Vrai", "Faux", "Seulement si argent"],
    answer: "Faux",
    explanation: "Préjudice potentiel suffit.",
    difficulty: "Facile",
  ),

  // (14-25) mini-cas 441-1
  const QuizQuestion(
    category: "Cas — 441-1",
    question: "Photocopie contrefaite produite en justice :",
    options: [
      "Faux (441-1)",
      "Obtention indue (441-6)",
      "Délivrance indue (441-5)",
    ],
    answer: "Faux (441-1)",
    explanation:
        "Production d’une copie contrefaite à valeur probatoire = faux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — Usage 441-1",
    question: "Même pièce fausse utilisée 4 fois :",
    options: ["4 usages possibles", "1 usage unique", "0 si ancien"],
    answer: "4 usages possibles",
    explanation: "Infraction instantanée : chaque acte d’usage compte.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — 441-1",
    question: "Lettre falsifiée pour prouver une embauche :",
    options: ["Faux (441-1)", "441-7", "441-2"],
    answer: "Faux (441-1)",
    explanation: "Support privé devenu probatoire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — 441-1",
    question: "Facture falsifiée passée en comptabilité :",
    options: ["Possible faux (441-1)", "Jamais faux", "Seulement 441-7"],
    answer: "Possible faux (441-1)",
    explanation: "Peut acquérir valeur probatoire via comptabilité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — 441-1",
    question: "Mensonge oral sans écrit/support :",
    options: ["Pas 441-1", "Toujours 441-1", "Toujours 441-2"],
    answer: "Pas 441-1",
    explanation: "441-1 exige support d’expression de la pensée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas — 441-1",
    question: "Faux document créé mais jamais utilisé :",
    options: [
      "Faux possible (441-1)",
      "Impossible sans usage",
      "Contravention",
    ],
    answer: "Faux possible (441-1)",
    explanation:
        "Le faux peut être constitué dès la création (usage distinct).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — Usage",
    question: "Présenter un faux à une banque pour ouvrir compte :",
    options: ["Usage de faux", "Détention seule", "Aucune infraction"],
    answer: "Usage de faux",
    explanation: "Acte positif d’utilisation + connaissance.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège — 441-1 vs 441-7",
    question: "Attestation écrite mensongère au profit d’un tiers :",
    options: [
      "Plutôt 441-7 (texte spécial)",
      "Toujours 441-1",
      "Toujours 441-6",
    ],
    answer: "Plutôt 441-7 (texte spécial)",
    explanation: "Texte spécial prime souvent sur général.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Réflexe — 441-1",
    question: "441-1 incrimine :",
    options: ["Faux et usage", "Obtention indue", "Délivrance indue"],
    answer: "Faux et usage",
    explanation: "Même article incrimine les deux, infractions distinctes.",
    difficulty: "Facile",
  ),

  // =======================
  // 441-2 — DOC ADMIN (26-55)
  // =======================
  const QuizQuestion(
    category: "441-2 — Définition",
    question: "441-2 vise :",
    options: [
      "Faux/usage dans un document administratif",
      "Obtention d’un document authentique par fraude",
      "Attestation mensongère privée",
    ],
    answer: "Faux/usage dans un document administratif",
    explanation: "Texte spécial « document administratif ». ",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-2 — Document administratif",
    question: "Document administratif = délivré pour :",
    options: [
      "Droit/identité/qualité/autorisation",
      "Opinion/politique",
      "Divertissement",
    ],
    answer: "Droit/identité/qualité/autorisation",
    explanation: "Critère finalité du document.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-2 — Faux matériel",
    question: "Gratter et modifier un permis :",
    options: ["441-2", "441-6", "441-5"],
    answer: "441-2",
    explanation: "Falsification matérielle d’un doc administratif.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-2 — Usage",
    question: "Présenter un permis falsifié au contrôle :",
    options: ["Usage 441-2", "441-6", "441-7"],
    answer: "Usage 441-2",
    explanation: "Utiliser un doc administratif falsifié.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-2 — Préjudice",
    question: "Le préjudice du faux administratif :",
    options: [
      "Découle de la nature de la pièce faussée",
      "Doit être chiffré",
      "Doit viser uniquement l’État",
    ],
    answer: "Découle de la nature de la pièce faussée",
    explanation: "Jurisprudence : préjudice déduit de la nature de la pièce.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-2 — Aggravation qualité",
    question: "Aggravé si commis par :",
    options: [
      "Dépositaire/Mission SP en exercice",
      "Toute personne majeure",
      "Mineur seulement",
    ],
    answer: "Dépositaire/Mission SP en exercice",
    explanation: "441-2 1°.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "441-2 — Aggravation dessein",
    question: "Aggravé si but :",
    options: [
      "Faciliter un crime/procurer impunité",
      "Éviter une file d’attente",
      "Faire plaisir à un ami",
    ],
    answer: "Faciliter un crime/procurer impunité",
    explanation: "441-2 3°.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "441-2 — Peine simple",
    question: "441-2 simple :",
    options: ["5 ans + 75 000 €", "3 ans + 45 000 €", "2 ans + 30 000 €"],
    answer: "5 ans + 75 000 €",
    explanation: "Tableau 441-2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "441-2 — Peine aggravée",
    question: "441-2 aggravé :",
    options: ["7 ans + 100 000 €", "10 ans", "1 an + 15 000 €"],
    answer: "7 ans + 100 000 €",
    explanation: "Tableau 441-2 aggravé.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-2",
    question: "Vrai/Faux : 441-2 réprime aussi l’usage.",
    options: ["Vrai", "Faux", "Seulement si fonctionnaire"],
    answer: "Vrai",
    explanation: "Texte vise faux + usage.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Piège — 441-2 vs 441-6",
    question: "Document authentique obtenu par mensonge (sans falsification) :",
    options: ["441-6", "441-2", "441-4"],
    answer: "441-6",
    explanation: "441-2 suppose falsification/contrefaçon.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — R.645-8",
    question: "Doc administratif non falsifié mais devenu inexact, utilisé :",
    options: ["Contravention R.645-8", "Usage 441-2", "441-6"],
    answer: "Contravention R.645-8",
    explanation: "Selon ton cours : doc devenu inexact/incomplet → R.645-8.",
    difficulty: "Difficile",
  ),

  // 38-55 = mini-cas rapides (18)
  const QuizQuestion(
    category: "Cas — 441-2",
    question: "Fausse carte grise utilisée pour s’approprier un véhicule :",
    options: ["441-2", "441-6", "441-7"],
    answer: "441-2",
    explanation: "Falsification de doc administratif (carte grise).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas — 441-2 usage",
    question: "Présenter une carte grise falsifiée à l’assurance :",
    options: ["Usage 441-2", "441-1", "441-6"],
    answer: "Usage 441-2",
    explanation: "Usage d’un faux doc administratif.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — 441-2",
    question: "Imitation de signature sur un doc administratif :",
    options: ["441-2", "441-7", "441-6"],
    answer: "441-2",
    explanation: "Procédé donnant apparence d’authenticité → faux matériel.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas — 441-2",
    question: "Fabriquer de toutes pièces un permis :",
    options: ["441-2", "441-5", "441-6"],
    answer: "441-2",
    explanation: "Contrefaçon d’un doc administratif.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Cas — 441-2 aggravé",
    question: "Agent public falsifie une CNI en service :",
    options: ["441-2 aggravé", "441-6", "441-7"],
    answer: "441-2 aggravé",
    explanation: "Qualité + exercice = aggravation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 441-2",
    question: "Vrai/Faux : 441-2 vise uniquement des écrits papier.",
    options: ["Vrai", "Faux", "Seulement si permis"],
    answer: "Faux",
    explanation: "Peut viser support autre que l’écrit (renvoi cours).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — 441-2 vs 441-1",
    question:
        "Si le support est un document administratif, on retient plutôt :",
    options: ["441-2 (spécial)", "441-1 (général)", "441-7"],
    answer: "441-2 (spécial)",
    explanation: "Texte spécial doc administratif.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Réflexe — 441-2",
    question: "Peine simple 441-2 :",
    options: ["5 ans + 75k", "2 ans + 30k", "3 ans + 45k"],
    answer: "5 ans + 75k",
    explanation: "Tableau 441-2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Réflexe — 441-2",
    question: "Peine aggravée 441-2 :",
    options: ["7 ans + 100k", "10 ans", "15 ans réclusion"],
    answer: "7 ans + 100k",
    explanation: "Tableau 441-2 aggravé.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — But de l’infraction",
    question:
        "La provocation directe à la rébellion vise principalement à réprimer :",
    options: [
      "Les agissements rendant plus difficile la mission des forces de l’ordre",
      "Les critiques politiques des institutions",
      "Les refus d’obtempérer sans violence",
    ],
    answer:
        "Les agissements rendant plus difficile la mission des forces de l’ordre",
    explanation:
        "Le texte indique que l’objectif est de sanctionner ceux qui compliquent la mission (interpellation, expulsion, etc.) en incitant directement à une rébellion.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Lien exigé",
    question: "Pour être répréhensible, la provocation doit présenter :",
    options: [
      "Une relation précise et incontestable avec l’acte de rébellion",
      "Une simple hostilité générale envers la police",
      "Une injure isolée",
    ],
    answer: "Une relation précise et incontestable avec l’acte de rébellion",
    explanation:
        "La provocation doit être directe : lien étroit et précis avec les faits visés.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Opposition violente",
    question: "Les termes de la provocation doivent tendre sans ambiguïté à :",
    options: [
      "Une opposition violente à l’action d’un dépositaire de l’autorité publique",
      "Un débat public contradictoire",
      "Une simple désapprobation",
    ],
    answer:
        "Une opposition violente à l’action d’un dépositaire de l’autorité publique",
    explanation:
        "Condition centrale : l’incitation doit viser une opposition violente à l’action de l’autorité.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Personne visée",
    question: "La provocation directe à la rébellion doit s’adresser :",
    options: [
      "Pas nécessairement à une personne déterminée",
      "Obligatoirement à une personne nommément désignée",
      "Uniquement à un agent public",
    ],
    answer: "Pas nécessairement à une personne déterminée",
    explanation:
        "L’article vise aussi la distribution d’écrits / moyens de diffusion : pas besoin d’une cible déterminée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Cris et discours",
    question: "Les cris ou discours incriminés doivent avoir été tenus :",
    options: [
      "Sur la voie publique ou dans un lieu public",
      "Uniquement dans un commissariat",
      "Uniquement sur Internet",
    ],
    answer: "Sur la voie publique ou dans un lieu public",
    explanation:
        "Le support “cris/discours publics” suppose la voie publique ou un lieu public.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Écrits",
    question: "Les écrits peuvent constituer une provocation s’ils sont :",
    options: [
      "Affichés ou distribués",
      "Gardés dans un carnet privé",
      "Détruits avant toute diffusion",
    ],
    answer: "Affichés ou distribués",
    explanation: "Le texte vise les écrits affichés ou distribués.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Tracts",
    question:
        "Des tracts appelant à la rébellion peuvent caractériser l’infraction s’ils sont :",
    options: [
      "Remis de la main à la main ou distribués dans des boîtes aux lettres",
      "Écrits mais jamais diffusés",
      "Envoyés uniquement à soi-même",
    ],
    answer:
        "Remis de la main à la main ou distribués dans des boîtes aux lettres",
    explanation: "Le document cite explicitement ces modes de distribution.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Presse",
    question:
        "Si la provocation est commise par presse écrite ou audiovisuelle, on applique :",
    options: [
      "Les dispositions particulières (loi du 29 juillet 1881 sur la presse)",
      "Uniquement l’article 433-6",
      "Uniquement le Code de la route",
    ],
    answer:
        "Les dispositions particulières (loi du 29 juillet 1881 sur la presse)",
    explanation:
        "433-10 al.2 renvoie aux règles spécifiques de la presse (loi 1881).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Infraction formelle",
    question:
        "On dit que la provocation à la rébellion est une infraction formelle car :",
    options: [
      "Elle est constituée par le seul acte, même sans résultat",
      "Elle exige une rébellion effectivement commise",
      "Elle exige une blessure d’un agent",
    ],
    answer: "Elle est constituée par le seul acte, même sans résultat",
    explanation:
        "Peu importe que l’incitation ait été suivie d’effet : le résultat est indifférent.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Tentative",
    question:
        "Concernant la provocation directe à la rébellion (433-10), la tentative est :",
    options: [
      "Non punissable (TENTATIVE : NON)",
      "Punissable dans tous les cas",
      "Punissable seulement si un agent est blessé",
    ],
    answer: "Non punissable (TENTATIVE : NON)",
    explanation: "Le document précise : TENTATIVE : NON.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Complicité",
    question: "La complicité de provocation directe à la rébellion est :",
    options: [
      "Oui, punissable (COMPLICITÉ : OUI)",
      "Non, jamais punissable",
      "Punissable seulement pour les mineurs",
    ],
    answer: "Oui, punissable (COMPLICITÉ : OUI)",
    explanation:
        "Le document indique que la complicité est punissable selon 121-6 et 121-7 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Base légale complicité",
    question: "Les textes généraux de la complicité mentionnés sont :",
    options: [
      "Articles 121-6 et 121-7 du Code pénal",
      "Articles 433-6 et 433-7",
      "Article 223-1 uniquement",
    ],
    answer: "Articles 121-6 et 121-7 du Code pénal",
    explanation: "Le document renvoie aux articles 121-6 et 121-7 CP.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Personnes morales",
    question:
        "Les personnes morales peuvent être pénalement responsables sur le fondement de :",
    options: [
      "L’article 121-2 du Code pénal",
      "L’article 433-9 uniquement",
      "Aucun texte",
    ],
    answer: "L’article 121-2 du Code pénal",
    explanation:
        "Le document précise la responsabilité pénale des personnes morales (121-2 CP).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Circonstances aggravantes",
    question:
        "La provocation directe à la rébellion (433-10) comporte des circonstances aggravantes :",
    options: ["Aucune", "Oui, en réunion", "Oui, si l’auteur est détenu"],
    answer: "Aucune",
    explanation:
        "Le document indique explicitement : IV — CIRCONSTANCES AGGRAVANTES : AUCUNE.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Notion de complice",
    question:
        "Si la provocation est suivie d’effet, l’auteur peut être poursuivi comme :",
    options: [
      "Complice de la rébellion par instruction (121-7 CP)",
      "Auteur de violences volontaires uniquement",
      "Victime d’outrage",
    ],
    answer: "Complice de la rébellion par instruction (121-7 CP)",
    explanation:
        "Nota : si suivie d’effet, poursuites possibles comme complice par instruction (121-7).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Exemple jurisprudentiel",
    question:
        "Dans Cass. crim., 21 février 2017, la provocation est caractérisée notamment car le prévenu :",
    options: [
      "Incite la foule à faire obstacle à son interpellation en appelant à les 'défoncer'",
      "Refuse de donner ses papiers calmement",
      "Filme la scène sans parler",
    ],
    answer:
        "Incite la foule à faire obstacle à son interpellation en appelant à les 'défoncer'",
    explanation:
        "Le cas cité : harangue la foule et incite à l’opposition violente à l’interpellation.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // RÉBELLION — ARTICLES 433-6 À 433-9 CP
  // (Banque étendue)
  // =========================================================
  const QuizQuestion(
    category: "Rébellion — Définition complète",
    question:
        "La rébellion correspond au fait d’opposer une résistance violente à :",
    options: [
      "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public agissant dans l’exercice de ses fonctions",
      "N’importe quel particulier",
      "Un commerçant refusant un paiement",
    ],
    answer:
        "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public agissant dans l’exercice de ses fonctions",
    explanation:
        "Définition issue de 433-6 CP : résistance violente à une personne protégée agissant dans l’exercice de ses fonctions.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Répression",
    question: "La rébellion est définie par 433-6 CP et réprimée par :",
    options: [
      "L’article 433-7 du Code pénal",
      "L’article 433-10 du Code pénal",
      "L’article 434-5 du Code pénal",
    ],
    answer: "L’article 433-7 du Code pénal",
    explanation: "Le document précise : 433-6 définit, 433-7 réprime.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Dépositaire autorité publique",
    question: "Est dépositaire de l’autorité publique celui qui :",
    options: [
      "Dispose d’un pouvoir de décision fondé sur une parcelle d’autorité publique",
      "Rend un simple service bénévole",
      "N’a aucun pouvoir et agit pour lui-même",
    ],
    answer:
        "Dispose d’un pouvoir de décision fondé sur une parcelle d’autorité publique",
    explanation:
        "Définition rappelée : pouvoir de décision attaché aux fonctions.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Exemples dépositaires",
    question:
        "Parmi ces personnes, lesquelles sont notamment citées comme dépositaires de l’autorité publique ?",
    options: [
      "Policiers, gendarmes, douaniers, huissiers",
      "Livreurs et agents d’entretien privés",
      "Clients d’un service public",
    ],
    answer: "Policiers, gendarmes, douaniers, huissiers",
    explanation:
        "Le document liste plusieurs exemples : policiers, gendarmes, douaniers, huissiers, etc.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Élus locaux",
    question:
        "Les responsables des exécutifs locaux (maires, présidents d’intercommunalités, etc.) sont cités comme :",
    options: [
      "Dépositaires de l’autorité publique",
      "Toujours simples particuliers",
      "Toujours jurés d’assises",
    ],
    answer: "Dépositaires de l’autorité publique",
    explanation:
        "Ils figurent dans la liste des personnes concernées comme dépositaires.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Mission de service public",
    question: "Est chargé d’une mission de service public celui qui :",
    options: [
      "Accomplit un service public à titre temporaire ou permanent, volontairement ou sur réquisition",
      "Exerce forcément un pouvoir de commandement",
      "Agit exclusivement pour un intérêt privé",
    ],
    answer:
        "Accomplit un service public à titre temporaire ou permanent, volontairement ou sur réquisition",
    explanation:
        "Définition donnée dans le document (mission d’intérêt général sans pouvoir de décision).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Exemple service public",
    question:
        "Le document donne comme exemple de personne chargée d’une mission de service public :",
    options: [
      "Le serrurier requis par l’OPJ",
      "Un voisin témoin",
      "Un vendeur de magasin",
    ],
    answer: "Le serrurier requis par l’OPJ",
    explanation: "Exemple explicite : serrurier requis par l’OPJ.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Condition d’exercice",
    question:
        "Il n’y a rébellion que si la résistance se manifeste alors que l’agent agit :",
    options: [
      "Dans le cadre de ses fonctions",
      "Uniquement en uniforme",
      "Uniquement la nuit",
    ],
    answer: "Dans le cadre de ses fonctions",
    explanation: "Condition essentielle : exercice des fonctions.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — RGE police nationale",
    question:
        "Selon l’art. 113-3 du règlement général d’emploi, un policier même hors service est tenu :",
    options: [
      "D’intervenir pour assistance, prévenir/réprimer trouble à l’ordre public, protéger personnes et biens",
      "De ne jamais intervenir",
      "D’appeler uniquement un collègue",
    ],
    answer:
        "D’intervenir pour assistance, prévenir/réprimer trouble à l’ordre public, protéger personnes et biens",
    explanation:
        "Le document rappelle l’obligation d’intervention même hors service.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Jurisprudence hors service",
    question:
        "Cass. crim., 15 décembre 2015 retient qu’un policier est en service s’il intervient :",
    options: [
      "Dans sa circonscription et dans le cadre de ses attributions, de sa propre initiative ou sur réquisition",
      "Uniquement après ordre écrit",
      "Uniquement s’il est en uniforme",
    ],
    answer:
        "Dans sa circonscription et dans le cadre de ses attributions, de sa propre initiative ou sur réquisition",
    explanation: "Jurisprudence citée dans le document.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Pour l’exécution des lois",
    question: "Il y a rébellion si l’agent agit notamment dans le cadre :",
    options: [
      "D’une mission de police judiciaire ou administrative",
      "D’un litige strictement privé",
      "D’une discussion amicale",
    ],
    answer: "D’une mission de police judiciaire ou administrative",
    explanation:
        "Le document vise PJ (flagrant, préliminaire, CR, mandats...) et PA (ordre public).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Ordre implicite",
    question:
        "Le document précise que l’ordre à l’origine de l’intervention peut être :",
    options: [
      "Implicite (ex : contrôle d’identité APJ sous ordre et responsabilité OPJ)",
      "Toujours écrit et signé",
      "Toujours judiciaire uniquement",
    ],
    answer:
        "Implicite (ex : contrôle d’identité APJ sous ordre et responsabilité OPJ)",
    explanation:
        "L’ordre peut être implicite ou nécessiter autorisation/réquisition selon les cas.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Illégalité de l’acte",
    question:
        "Même si l’acte accompli par l’agent se révèle illégal, la rébellion :",
    options: [
      "Peut être constituée (illégalité sans incidence)",
      "Est automatiquement exclue",
      "Devient uniquement une contravention",
    ],
    answer: "Peut être constituée (illégalité sans incidence)",
    explanation:
        "Cass. crim., 1er sept. 2004 : l’illégalité supposée est sans incidence.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Litige privé",
    question:
        "Si l’agent commet un acte sans lien avec sa mission (litige privé), la résistance :",
    options: [
      "Ne constituerait pas une rébellion",
      "Constitue forcément une rébellion",
      "Constitue automatiquement un outrage",
    ],
    answer: "Ne constituerait pas une rébellion",
    explanation:
        "Le document précise que l’absence de lien missionnel exclut la rébellion.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Résistance violente",
    question: "La rébellion suppose un acte de résistance :",
    options: [
      "Violente (résistance active, initiative de confrontation)",
      "Purement passif",
      "Uniquement verbal",
    ],
    answer: "Violente (résistance active, initiative de confrontation)",
    explanation: "Sont exclus : simple désobéissance et obstacle passif.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Exclusion obstacle passif",
    question:
        "Quel exemple est cité comme ne caractérisant pas la rébellion (obstacle passif) ?",
    options: [
      "S’accrocher au volant et refuser de suivre sans violence",
      "Porter un coup de poing à un agent",
      "Donner un coup de pied à un agent",
    ],
    answer: "S’accrocher au volant et refuser de suivre sans violence",
    explanation:
        "Cass. crim., 1er mars 2006 : refus passif d’un sexagénaire frêle accroché au volant.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Violence sans coups",
    question: "La jurisprudence peut retenir la rébellion même si l’auteur :",
    options: [
      "Se débat et résiste activement sans frapper les agents",
      "Reste immobile et silencieux",
      "S’endort volontairement",
    ],
    answer: "Se débat et résiste activement sans frapper les agents",
    explanation:
        "Cass. crim., 7 nov. 2006 : résistance active, fuite, sans coups portés.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Distinction violences/rébellion",
    question:
        "On retient plutôt la rébellion lorsque l’acte violent est commis :",
    options: [
      "Alors que l’agent exerce ses fonctions à l’égard de l’individu",
      "Toujours, même si l’agent n’agit pas dans ses fonctions",
      "Uniquement si l’agent est blessé gravement",
    ],
    answer: "Alors que l’agent exerce ses fonctions à l’égard de l’individu",
    explanation:
        "Cass. crim., 21 fév. 2006 : si l’acte violent répond à l’exercice des fonctions envers l’auteur → rébellion.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Actes distincts",
    question:
        "Si les violences ne sont pas distinctes de la résistance violente, la Cour retient :",
    options: [
      "La rébellion",
      "Deux infractions systématiques",
      "Aucune infraction",
    ],
    answer: "La rébellion",
    explanation:
        "Cass. crim., 21 fév. 2006 : pas d’actes distincts → qualification de rébellion.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Élément moral 1",
    question: "L’élément moral suppose généralement :",
    options: [
      "La connaissance de la qualité de l’agent (uniforme/signes) et l’objet de l’intervention",
      "L’ignorance totale de l’identité de l’agent",
      "Une simple maladresse",
    ],
    answer:
        "La connaissance de la qualité de l’agent (uniforme/signes) et l’objet de l’intervention",
    explanation:
        "La connaissance découle souvent de l’uniforme/signes distinctifs et des explications données.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Élément moral 2",
    question: "Le mobile de l’auteur de la rébellion est :",
    options: ["Indifférent", "Toujours aggravant", "Toujours justificatif"],
    answer: "Indifférent",
    explanation:
        "Infraction intentionnelle : volonté de résister, mobile indifférent.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Circonstance aggravante réunion",
    question: "La rébellion est aggravée lorsqu’elle est commise :",
    options: [
      "En réunion (433-7 al.2)",
      "En journée",
      "En présence de témoins",
    ],
    answer: "En réunion (433-7 al.2)",
    explanation: "Aggravation expressément prévue à 433-7 al.2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Circonstance aggravante arme",
    question: "La rébellion est aggravée lorsque l’auteur est :",
    options: [
      "Porteur d’une arme apparente ou cachée (433-8)",
      "Sans papiers d’identité",
      "En retard",
    ],
    answer: "Porteur d’une arme apparente ou cachée (433-8)",
    explanation: "Aggravation prévue par 433-8 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Aggravation maximale",
    question:
        "Un degré d’aggravation supplémentaire est prévu lorsque la rébellion armée est commise :",
    options: ["En réunion", "Par un mineur", "Sur la voie publique"],
    answer: "En réunion",
    explanation:
        "Le document mentionne une aggravation supplémentaire si rébellion armée + réunion.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Auteur détenu",
    question:
        "La rébellion est traitée spécifiquement par l’article 433-9 CP lorsque l’auteur :",
    options: ["Est détenu", "Est mineur", "Est journaliste"],
    answer: "Est détenu",
    explanation: "433-9 vise la rébellion commise par une personne détenue.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Peines simple",
    question: "La rébellion simple (433-7 al.1) est punie de :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation: "Peines principales : 2 ans + 30 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Peines réunion",
    question: "La rébellion aggravée en réunion (433-7 al.2) est punie de :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "10 ans d’emprisonnement et 150 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Aggravation en réunion : 3 ans + 45 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Peines arme",
    question: "La rébellion avec port d’arme (433-8 al.1) est punie de :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "433-8 al.1 : 5 ans + 75 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Peines arme + réunion",
    question:
        "La rébellion armée commise en réunion (433-8 al.2) est punie de :",
    options: [
      "10 ans d’emprisonnement et 150 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "10 ans d’emprisonnement et 150 000 € d’amende",
    explanation: "Aggravation maximale : 10 ans + 150 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Rébellion détenu",
    question:
        "Lorsque l’auteur de la rébellion est détenu (433-9), la répression prévoit :",
    options: [
      "Cumul des peines de la rébellion et de l’infraction pour laquelle il est détenu",
      "Un simple avertissement",
      "Uniquement une amende",
    ],
    answer:
        "Cumul des peines de la rébellion et de l’infraction pour laquelle il est détenu",
    explanation: "Le document indique un cumul des peines dans ce cas.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Tentative",
    question: "Concernant la rébellion, la tentative est :",
    options: [
      "Non (TENTATIVE : NON)",
      "Oui, toujours",
      "Oui, seulement en réunion",
    ],
    answer: "Non (TENTATIVE : NON)",
    explanation: "Le document précise : TENTATIVE : NON.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Complicité",
    question: "Concernant la rébellion, la complicité est :",
    options: [
      "Oui (COMPLICITÉ : OUI)",
      "Non",
      "Uniquement pour les personnes morales",
    ],
    answer: "Oui (COMPLICITÉ : OUI)",
    explanation: "Complicité punissable selon 121-6/121-7 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Exemple complicité",
    question:
        "Dans Cass. crim., 8 décembre 2009, constitue une complicité de rébellion le fait :",
    options: [
      "De jeter des graviers/débris de verre sur un policier en sommant de relâcher un interpellé",
      "De filmer la scène",
      "De s’éloigner des lieux",
    ],
    answer:
        "De jeter des graviers/débris de verre sur un policier en sommant de relâcher un interpellé",
    explanation:
        "Le document cite cet exemple comme aide/assistance à la résistance.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Personnes morales",
    question:
        "Les personnes morales peuvent être responsables de rébellion conformément à :",
    options: [
      "L’article 121-2 du Code pénal",
      "L’article 433-10 uniquement",
      "Aucun texte",
    ],
    answer: "L’article 121-2 du Code pénal",
    explanation: "Le document rappelle 121-2 CP pour les personnes morales.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // MENACES DE CRIME OU DÉLIT ENVERS PERSONNES PROTÉGÉES — 433-3
  // (Banque étendue)
  // =========================================================
  const QuizQuestion(
    category: "Menaces 433-3 — Définition (objet)",
    question: "L’article 433-3 vise la menace de commettre :",
    options: [
      "Un crime ou un délit contre les personnes ou les biens",
      "Une simple contravention",
      "Un acte uniquement moral",
    ],
    answer: "Un crime ou un délit contre les personnes ou les biens",
    explanation:
        "La menace doit annoncer la commission prochaine d’un crime/délit contre personnes ou biens.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Bien visé",
    question:
        "Si la menace concerne un bien, elle peut consister en l’annonce :",
    options: [
      "D’une destruction, dégradation ou détérioration",
      "D’un simple déménagement",
      "D’un prêt d’objet",
    ],
    answer: "D’une destruction, dégradation ou détérioration",
    explanation:
        "Le document précise la nature possible du mal annoncé concernant un bien.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Réitération",
    question: "La menace 433-3 est punissable :",
    options: [
      "Même si elle n’a pas été réitérée ni matérialisée",
      "Uniquement si elle est répétée 3 fois",
      "Uniquement si elle est exécutée",
    ],
    answer: "Même si elle n’a pas été réitérée ni matérialisée",
    explanation:
        "Le document indique l’absence d’exigence de réitération ou matérialisation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Destinataires",
    question: "Les destinataires des menaces 433-3 sont :",
    options: [
      "Énumérés de manière limitative par la loi",
      "Toute personne sans exception",
      "Uniquement les policiers",
    ],
    answer: "Énumérés de manière limitative par la loi",
    explanation:
        "La loi liste précisément les catégories de victimes protégées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Mandat électif",
    question:
        "Sont visées par l’expression “mandat électif public” notamment :",
    options: [
      "Députés/sénateurs, élus régionaux/départementaux/communaux, eurodéputés",
      "Uniquement les candidats",
      "Uniquement les ministres",
    ],
    answer:
        "Députés/sénateurs, élus régionaux/départementaux/communaux, eurodéputés",
    explanation:
        "Le document détaille des exemples de mandats électifs publics.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Dépositaire autorité",
    question:
        "Parmi les catégories citées comme dépositaires de l’autorité publique :",
    options: [
      "Magistrats, officiers publics/ministériels, gendarmes, policiers, douanes, inspection du travail, pénitentiaire",
      "Clients d’un service public",
      "Bénévoles d’association",
    ],
    answer:
        "Magistrats, officiers publics/ministériels, gendarmes, policiers, douanes, inspection du travail, pénitentiaire",
    explanation: "Le document énumère ces catégories au titre de 433-3.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Mission service public",
    question:
        "Sont cités comme personnes chargées d’une mission de service public (433-3) :",
    options: [
      "Sapeurs-pompiers/marins-pompiers, enseignants, agents de transport public, professionnels de santé",
      "Uniquement les magistrats",
      "Uniquement les élus",
    ],
    answer:
        "Sapeurs-pompiers/marins-pompiers, enseignants, agents de transport public, professionnels de santé",
    explanation: "Le document cite ces exemples (alinéas 1 et 2).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Activité privée de sécurité",
    question:
        "L’article 433-3 protège aussi les personnes exerçant une activité privée de sécurité :",
    options: [
      "Mentionnée aux articles L.611-1 ou L.621-1 CSI, dans l’exercice des fonctions",
      "Uniquement en dehors de leurs fonctions",
      "Uniquement si elles sont élus",
    ],
    answer:
        "Mentionnée aux articles L.611-1 ou L.621-1 CSI, dans l’exercice des fonctions",
    explanation:
        "Le document vise explicitement ces activités privées de sécurité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Proches",
    question: "L’article 433-3 protège aussi :",
    options: [
      "Le conjoint, ascendants, descendants, ou personne vivant habituellement au domicile, en raison des fonctions",
      "Uniquement les amis",
      "Uniquement les collègues",
    ],
    answer:
        "Le conjoint, ascendants, descendants, ou personne vivant habituellement au domicile, en raison des fonctions",
    explanation:
        "Alinéa 4 : proches et cohabitants, en raison des fonctions exercées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Lien avec fonctions",
    question:
        "Pour les personnes du 1er alinéa, l’infraction est constituée si les menaces interviennent :",
    options: [
      "Dans l’exercice ou du fait de l’exercice des fonctions",
      "Uniquement le soir",
      "Uniquement par écrit",
    ],
    answer: "Dans l’exercice ou du fait de l’exercice des fonctions",
    explanation:
        "Le document distingue : alinéa 1 = dans l’exercice ou du fait ; alinéas 2 et 3 = dans l’exercice.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Alinéas 2 et 3",
    question:
        "Pour les victimes des alinéas 2 et 3, la menace doit avoir lieu :",
    options: [
      "Dans l’exercice des fonctions",
      "Du fait des fonctions uniquement",
      "Sans aucun lien avec les fonctions",
    ],
    answer: "Dans l’exercice des fonctions",
    explanation:
        "Le document précise : alinéas 2 et 3 → dans l’exercice des fonctions.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Qualité connue",
    question: "La qualité de la victime doit être :",
    options: [
      "Apparente ou connue de l’auteur",
      "Nécessairement écrite sur un papier",
      "Toujours ignorée",
    ],
    answer: "Apparente ou connue de l’auteur",
    explanation: "Condition : l’auteur agit en raison de cette qualité.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Élément moral",
    question: "L’élément moral des menaces 433-3 suppose que l’auteur :",
    options: [
      "A conscience du trouble créé par les menaces",
      "Veuille forcément exécuter la menace",
      "Ait forcément les moyens de l’exécuter",
    ],
    answer: "A conscience du trouble créé par les menaces",
    explanation:
        "Peu importe intention/moyens d’exécution ; il faut conscience du trouble.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Intention d’exécution",
    question:
        "Pour caractériser l’infraction 433-3, l’intention de mettre la menace à exécution :",
    options: [
      "Est indifférente",
      "Est obligatoire",
      "Est présumée irréfragable",
    ],
    answer: "Est indifférente",
    explanation:
        "Le document le dit clairement : peu importe intention/moyens.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Texte",
    question:
        "Les menaces envers personnes protégées sont définies et réprimées par :",
    options: [
      "L’article 433-3 du Code pénal",
      "L’article 433-10 du Code pénal",
      "L’article 432-1 du Code pénal",
    ],
    answer: "L’article 433-3 du Code pénal",
    explanation: "Base légale : 433-3 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Infractions spécifiques justice",
    question:
        "Le document rappelle que certaines menaces pour entraver l’action de la justice relèvent d’infractions spécifiques :",
    options: [
      "Articles 434-5, 434-8 et 434-15 CP",
      "Articles 121-6 et 121-7 CP",
      "Articles 222-7 et 222-8 CP",
    ],
    answer: "Articles 434-5, 434-8 et 434-15 CP",
    explanation:
        "Mention explicite : menaces visant la justice → infractions spécifiques 434-5/434-8/434-15.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Aggravation al.5",
    question:
        "L’article 433-3 al.5 prévoit une aggravation notamment lorsque :",
    options: [
      "Il s’agit d’une menace de mort ou d’une menace contre les biens dangereuse pour les personnes",
      "La menace est faite par SMS uniquement",
      "La victime ne porte pas d’uniforme",
    ],
    answer:
        "Il s’agit d’une menace de mort ou d’une menace contre les biens dangereuse pour les personnes",
    explanation: "Aggravation prévue à l’alinéa 5.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Aggravation al.6 (but)",
    question:
        "L’article 433-3 al.6 vise les menaces/violences/intimidations utilisées pour :",
    options: [
      "Obtenir qu’une personne accomplisse ou s’abstienne d’un acte de sa fonction/mission/mandat, ou faciliter par sa fonction",
      "Obtenir un cadeau personnel sans lien",
      "Éviter une contravention de stationnement uniquement",
    ],
    answer:
        "Obtenir qu’une personne accomplisse ou s’abstienne d’un acte de sa fonction/mission/mandat, ou faciliter par sa fonction",
    explanation:
        "Al.6 : pression pour obtenir action/abstention liée aux fonctions/mission/mandat.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Aggravation al.6 (abus d’autorité)",
    question:
        "L’alinéa 6 vise aussi le fait de faire pression pour qu’une personne abuse de son autorité (vraie ou supposée) afin d’obtenir :",
    options: [
      "Distinctions, emplois, marchés, ou toute décision favorable d’une autorité/administration publique",
      "Uniquement une réduction en magasin",
      "Uniquement un remboursement privé",
    ],
    answer:
        "Distinctions, emplois, marchés, ou toute décision favorable d’une autorité/administration publique",
    explanation:
        "Al.6 : obtenir une décision favorable via abus d’autorité vraie ou supposée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Exclusion 433-3-1",
    question:
        "Le document précise que les dispositions de l’alinéa 6 ne s’appliquent pas aux faits prévus par :",
    options: [
      "L’article 433-3-1 du Code pénal",
      "L’article 433-10 du Code pénal",
      "L’article 434-5 du Code pénal",
    ],
    answer: "L’article 433-3-1 du Code pénal",
    explanation:
        "Exclusion explicite : al.6 ne s’applique pas aux faits relevant de 433-3-1.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Peines simples",
    question: "Les menaces simples (433-3) sont punies de :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Peines principales : 3 ans + 45 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Peines aggravées al.5",
    question:
        "Les menaces aggravées par l’alinéa 5 (menace de mort / biens dangereuse) sont punies de :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "10 ans d’emprisonnement et 150 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Aggravation al.5 : 5 ans + 75 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Peines aggravées al.6",
    question:
        "Les faits aggravés par l’alinéa 6 (pression pour acte de fonction/abus d’autorité) sont punis de :",
    options: [
      "10 ans d’emprisonnement et 150 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "10 ans d’emprisonnement et 150 000 € d’amende",
    explanation: "Aggravation al.6 : 10 ans + 150 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Tentative",
    question: "Concernant les menaces 433-3, la tentative est :",
    options: ["Non (TENTATIVE : NON)", "Oui", "Oui si menace de mort"],
    answer: "Non (TENTATIVE : NON)",
    explanation: "Le document précise : TENTATIVE : NON.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Menaces 433-3 — Complicité",
    question: "Concernant les menaces 433-3, la complicité est :",
    options: [
      "Oui (COMPLICITÉ : OUI)",
      "Non",
      "Seulement si violence physique",
    ],
    answer: "Oui (COMPLICITÉ : OUI)",
    explanation: "Complicité punissable selon 121-6/121-7 CP.",
    difficulty: "Facile",
  ),

  // =========================================================
  // 433-3-1 — MENACES/VIOLENCES/INTIMIDATION POUR DÉROGATION
  // AUX RÈGLES DE FONCTIONNEMENT D’UN SERVICE PUBLIC
  // (Banque complète)
  // =========================================================
  const QuizQuestion(
    category: "433-3-1 — Définition",
    question:
        "L’infraction 433-3-1 consiste à user de menaces/violences/intimidation :",
    options: [
      "Pour obtenir une exemption totale/partielle ou une application différenciée des règles d’un service public",
      "Pour insulter un agent public",
      "Pour refuser d’obtempérer sans violence",
    ],
    answer:
        "Pour obtenir une exemption totale/partielle ou une application différenciée des règles d’un service public",
    explanation:
        "But central : obtenir une application dérogatoire des règles de fonctionnement d’un service public.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "433-3-1 — Élément légal",
    question:
        "L’infraction relative à la dérogation aux règles d’un service public est définie et réprimée par :",
    options: [
      "L’article 433-3-1 du Code pénal",
      "L’article 433-3 du Code pénal",
      "L’article 433-10 du Code pénal",
    ],
    answer: "L’article 433-3-1 du Code pénal",
    explanation: "Base légale : 433-3-1 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Comportements visés",
    question:
        "Le 433-3-1 permet de sanctionner des comportements variés car il vise :",
    options: [
      "Les menaces (même sans réitération), les violences et tout acte d’intimidation",
      "Uniquement les violences avec ITT",
      "Uniquement les menaces écrites",
    ],
    answer:
        "Les menaces (même sans réitération), les violences et tout acte d’intimidation",
    explanation:
        "Le texte vise menaces, violences et tout acte d’intimidation, et les menaces même sans réitération.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "433-3-1 — Victime",
    question: "La victime visée par 433-3-1 est :",
    options: [
      "Toute personne participant à l’exécution d’une mission de service public",
      "Uniquement une personne dépositaire de l’autorité publique",
      "Uniquement un élu",
    ],
    answer:
        "Toute personne participant à l’exécution d’une mission de service public",
    explanation:
        "Sans condition de statut, fonction ou responsabilités : toute personne participant au service public.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "433-3-1 — Condition de statut",
    question:
        "Pour 433-3-1, il existe une condition de statut/fonction/responsabilités pour la victime :",
    options: [
      "Non, aucune condition",
      "Oui, uniquement fonctionnaire",
      "Oui, uniquement dépositaire de l’autorité publique",
    ],
    answer: "Non, aucune condition",
    explanation:
        "Le texte précise : sans condition de statut, de fonction ou de responsabilités.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Intention particulière",
    question: "Pour caractériser 433-3-1, il faut démontrer :",
    options: [
      "Une intention particulière d’obtenir une application dérogatoire des règles",
      "Une intention de tuer",
      "Une intention d’insulter",
    ],
    answer:
        "Une intention particulière d’obtenir une application dérogatoire des règles",
    explanation:
        "Le document insiste sur la démonstration d’une intention particulière (objectif précis).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Preuve de l’intention",
    question: "L’intention d’obtenir un régime dérogatoire peut être prouvée :",
    options: [
      "Par des propos explicites ou par des éléments de contexte",
      "Uniquement par aveu écrit",
      "Uniquement par témoins policiers",
    ],
    answer: "Par des propos explicites ou par des éléments de contexte",
    explanation:
        "Le document indique que la preuve peut venir d’une expression claire ou du contexte.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "433-3-1 — Exemples (piscine)",
    question: "Exemple donné par le document d’un objectif de dérogation :",
    options: [
      "Obtenir des horaires réservés aux femmes pour l’accès à une piscine",
      "Obtenir un remboursement bancaire",
      "Obtenir un emploi privé",
    ],
    answer:
        "Obtenir des horaires réservés aux femmes pour l’accès à une piscine",
    explanation: "Exemple cité : horaires réservés pour accès piscine.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Exemples (cantine)",
    question: "Autre exemple de dérogation cité :",
    options: [
      "Obtenir un régime alimentaire particulier dans les cantines scolaires",
      "Obtenir un nouveau téléphone",
      "Obtenir une remise sur un billet de concert",
    ],
    answer:
        "Obtenir un régime alimentaire particulier dans les cantines scolaires",
    explanation: "Exemple cité : régime alimentaire particulier en cantine.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Bénéfice",
    question:
        "Le comportement incriminé doit poursuivre l’objectif d’obtenir une dérogation :",
    options: [
      "Pour soi-même ou pour autrui",
      "Uniquement pour soi",
      "Uniquement pour la victime",
    ],
    answer: "Pour soi-même ou pour autrui",
    explanation: "Le document précise : au bénéfice de soi-même ou d’autrui.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Élément moral (trouble)",
    question: "Pour 433-3-1, l’auteur doit avoir conscience :",
    options: [
      "Du trouble créé par menaces/violences dans l’esprit de la victime",
      "D’être filmé",
      "D’être en tort civilement",
    ],
    answer: "Du trouble créé par menaces/violences dans l’esprit de la victime",
    explanation:
        "Le texte reprend la logique : conscience du trouble ; intention d’obtenir la dérogation.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "433-3-1 — Intention d’exécution",
    question: "Pour 433-3-1, l’intention de mettre les menaces à exécution :",
    options: [
      "Est indifférente",
      "Est obligatoire",
      "Doit être prouvée par un acte préparatoire",
    ],
    answer: "Est indifférente",
    explanation:
        "Peu importe intention/moyens d’exécution, c’est l’objectif dérogatoire qui compte.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "433-3-1 — Circonstances aggravantes",
    question:
        "Le document indique pour 433-3-1 des circonstances aggravantes :",
    options: ["Aucune", "Oui, en réunion", "Oui, si arme"],
    answer: "Aucune",
    explanation: "IV — CIRCONSTANCES AGGRAVANTES : AUCUNE.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Peines",
    question: "Les peines principales encourues pour 433-3-1 sont :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "V — Répression : 5 ans + 75 000 €.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Personnes morales",
    question: "Concernant 433-3-1, les personnes morales :",
    options: [
      "Peuvent être reconnues responsables",
      "Ne peuvent jamais être responsables",
      "Sont responsables uniquement en cas de réunion",
    ],
    answer: "Peuvent être reconnues responsables",
    explanation:
        "Le document précise que les personnes morales peuvent être reconnues responsables.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Tentative",
    question: "Concernant 433-3-1, la tentative est :",
    options: ["Non (TENTATIVE : NON)", "Oui", "Oui uniquement si violence"],
    answer: "Non (TENTATIVE : NON)",
    explanation: "Le document précise : TENTATIVE : NON.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Complicité",
    question: "Concernant 433-3-1, la complicité est :",
    options: [
      "Oui (COMPLICITÉ : OUI)",
      "Non",
      "Uniquement si l’auteur principal est condamné",
    ],
    answer: "Oui (COMPLICITÉ : OUI)",
    explanation: "Complicité punissable selon 121-6/121-7 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "433-3-1 — Nature de l’objectif",
    question: "L’objectif visé par 433-3-1 est d’obtenir :",
    options: [
      "Une exemption totale/partielle ou une application différenciée des règles du service public",
      "Une décision de justice",
      "Une remise commerciale",
    ],
    answer:
        "Une exemption totale/partielle ou une application différenciée des règles du service public",
    explanation:
        "C’est le cœur du texte : application dérogatoire des règles de fonctionnement.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // QUESTIONS “PIÈGES” — DISTINCTIONS
  // Rébellion vs Violences volontaires vs Outrage vs Refus d’obtempérer
  // + QCM Vrai/Faux (format options)
  // + Mini cas pratiques (qualification + article + peine)
  // =========================================================

  // ---------------------------------------------------------
  // OUTRAGE — RAPPELS (Général)  ⚠️
  // NB: Les articles/outils exacts peuvent varier selon la situation.
  // Ici, je reste sur le socle classique : outrage = propos/gestes/écrits
  // portant atteinte à la dignité/respect dû à la fonction, pendant/dû aux fonctions.
  // ---------------------------------------------------------
  const QuizQuestion(
    category: "Distinctions — Rébellion vs Outrage",
    question: "La différence principale entre outrage et rébellion est que :",
    options: [
      "L’outrage est une atteinte verbale/gestuelle à la dignité, la rébellion est une résistance violente",
      "L’outrage implique toujours une violence physique",
      "La rébellion ne concerne jamais les forces de l’ordre",
    ],
    answer:
        "L’outrage est une atteinte verbale/gestuelle à la dignité, la rébellion est une résistance violente",
    explanation:
        "Outrage = paroles/gestes/écrits atteinte au respect dû à la fonction. Rébellion = résistance violente à l’action de l’agent.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Distinctions — Rébellion vs Refus d’obtempérer",
    question:
        "Le refus d’obtempérer se distingue classiquement de la rébellion car :",
    options: [
      "Le refus d’obtempérer vise la désobéissance à un ordre (souvent routier), la rébellion suppose une résistance violente",
      "Le refus d’obtempérer suppose forcément des coups portés",
      "La rébellion est toujours routière",
    ],
    answer:
        "Le refus d’obtempérer vise la désobéissance à un ordre (souvent routier), la rébellion suppose une résistance violente",
    explanation:
        "Dans ton cours : rébellion = violence/résistance active. Le refus d’obtempérer = non-exécution d’un ordre (souvent en circulation) sans nécessaire violence.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Distinctions — Rébellion vs Obstacle passif",
    question: "Un obstacle purement passif à l’action de l’agent :",
    options: [
      "Ne caractérise pas la rébellion",
      "Caractérise toujours la rébellion",
      "Caractérise automatiquement une provocation à la rébellion",
    ],
    answer: "Ne caractérise pas la rébellion",
    explanation:
        "Ton doc : la simple désobéissance et l’obstacle passif sont exclus de la rébellion.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Distinctions — Rébellion (violence) : exemple",
    question:
        "Lequel de ces comportements correspond le plus à une rébellion ?",
    options: [
      "Se débattre violemment pendant l’interpellation en bousculant l’agent",
      "Dire : 'Je ne suis pas d’accord' sans geste",
      "Rester assis sans bouger",
    ],
    answer:
        "Se débattre violemment pendant l’interpellation en bousculant l’agent",
    explanation: "Résistance active et violente = rébellion.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Distinctions — Violences volontaires vs Rébellion",
    question:
        "On retient plutôt les violences volontaires aggravées (plutôt que la rébellion) lorsque :",
    options: [
      "L’agent public n’exerçait pas de prérogative à l’égard de l’auteur au moment du coup",
      "L’agent était en train d’interpeller l’auteur et celui-ci répond par un acte violent",
      "Il n’y a aucun acte violent",
    ],
    answer:
        "L’agent public n’exerçait pas de prérogative à l’égard de l’auteur au moment du coup",
    explanation:
        "Ton doc : si l’agent n’exerce pas sa mission envers l’individu, on bascule plutôt sur violences aggravées. Sinon, rébellion.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Distinctions — Rébellion vs Violences distinctes",
    question:
        "Si les coups portés ne sont pas distincts de la résistance violente lors de l’interpellation :",
    options: [
      "La qualification de rébellion peut suffire (pas d’actes distincts)",
      "Il y a forcément deux infractions cumulées",
      "Il n’y a aucune infraction",
    ],
    answer:
        "La qualification de rébellion peut suffire (pas d’actes distincts)",
    explanation:
        "Ton doc cite Cass. crim. (21 fév. 2006) : pas d’actes de violences distincts -> rébellion.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Distinctions — Outrage vs Menaces 433-3",
    question:
        "Dire à un policier : 'Je vais brûler ta voiture ce soir' (en raison de ses fonctions) correspond plutôt à :",
    options: [
      "Des menaces de crime/délit envers personne dépositaire (433-3 CP)",
      "Un simple outrage",
      "Une provocation à la rébellion (433-10 CP)",
    ],
    answer: "Des menaces de crime/délit envers personne dépositaire (433-3 CP)",
    explanation:
        "Menace d’atteinte aux biens = 433-3 si victime protégée et qualité connue + lien fonctions.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Distinctions — Menaces vs Outrage",
    question: "L’outrage se distingue d’une menace car la menace contient :",
    options: [
      "L’annonce d’un crime ou d’un délit à venir contre personnes ou biens",
      "Une simple critique générale",
      "Un silence méprisant",
    ],
    answer:
        "L’annonce d’un crime ou d’un délit à venir contre personnes ou biens",
    explanation:
        "Menace = annonce de mal criminel/délictuel, outrage = atteinte au respect/dignité (sans annonce d’infraction).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Distinctions — Provocation à la rébellion vs Outrage",
    question:
        "Crier à une foule : 'Allez-y, tapez les policiers !' correspond plutôt à :",
    options: [
      "Provocation directe à la rébellion (433-10 CP)",
      "Outrage",
      "Refus d’obtempérer",
    ],
    answer: "Provocation directe à la rébellion (433-10 CP)",
    explanation:
        "Incitation directe à opposition violente à l’autorité = 433-10 (infraction formelle).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Distinctions — Provocation vs Complicité",
    question:
        "Si après une provocation, la rébellion est réellement commise, l’auteur de la provocation peut être poursuivi :",
    options: [
      "Comme complice de la rébellion par instruction (121-7 CP)",
      "Uniquement pour outrage",
      "Uniquement pour refus d’obtempérer",
    ],
    answer: "Comme complice de la rébellion par instruction (121-7 CP)",
    explanation:
        "Nota de ton doc 433-10 : si suivie d’effet → complicité possible.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Distinctions — Rébellion en réunion",
    question: "La rébellion est aggravée lorsqu’elle est commise :",
    options: ["En réunion (433-7 al.2 CP)", "En plein jour", "Sans témoin"],
    answer: "En réunion (433-7 al.2 CP)",
    explanation: "Circonstance aggravante prévue à 433-7 al.2.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Distinctions — Rébellion armée",
    question: "La rébellion est aggravée lorsque l’auteur est :",
    options: [
      "Porteur d’une arme apparente ou cachée (433-8 CP)",
      "Plus âgé que 40 ans",
      "En état de stress",
    ],
    answer: "Porteur d’une arme apparente ou cachée (433-8 CP)",
    explanation: "Aggravation spécifique prévue à 433-8.",
    difficulty: "Facile",
  ),

  // ---------------------------------------------------------
  // QCM “VRAI/FAUX” — format options (3 choix)
  // ---------------------------------------------------------
  const QuizQuestion(
    category: "Vrai/Faux — Provocation 433-10",
    question:
        "Vrai ou Faux : La provocation directe à la rébellion n’est punissable que si la rébellion a effectivement lieu.",
    options: ["Vrai", "Faux", "Ça dépend de l’uniforme"],
    answer: "Faux",
    explanation:
        "Infraction formelle : punissable même sans résultat (sans être suivie d’effet).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Provocation 433-10",
    question:
        "Vrai ou Faux : La provocation directe à la rébellion doit viser une personne déterminée.",
    options: ["Vrai", "Faux", "Uniquement si c’est écrit"],
    answer: "Faux",
    explanation:
        "Elle peut être diffusée par tracts/écrits/moyens de transmission sans destinataire déterminé.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Rébellion",
    question:
        "Vrai ou Faux : Un obstacle passif (se laisser porter, s’agripper sans violence) suffit à caractériser une rébellion.",
    options: ["Vrai", "Faux", "Uniquement si l’agent tombe"],
    answer: "Faux",
    explanation:
        "Ton doc : obstacle passif et simple désobéissance exclus du champ de la rébellion.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Rébellion",
    question:
        "Vrai ou Faux : La rébellion peut être retenue même si l’acte accompli par l’agent était illégal.",
    options: ["Vrai", "Faux", "Uniquement si c’est un OPJ"],
    answer: "Vrai",
    explanation:
        "Cass. crim., 1er septembre 2004 : illégalité supposée sans incidence.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Menaces 433-3",
    question:
        "Vrai ou Faux : Pour être punissable, la menace 433-3 doit être réitérée.",
    options: ["Vrai", "Faux", "Seulement si menace de mort"],
    answer: "Faux",
    explanation: "Punissable même sans réitération ni matérialisation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Menaces 433-3",
    question:
        "Vrai ou Faux : Peu importe que l’auteur ait réellement l’intention ou les moyens d’exécuter la menace.",
    options: ["Vrai", "Faux", "Ça dépend du lieu"],
    answer: "Vrai",
    explanation:
        "Élément moral : conscience du trouble. Intention/moyens d’exécution indifférents.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — 433-3-1",
    question:
        "Vrai ou Faux : L’infraction 433-3-1 exige de prouver une intention particulière d’obtenir une dérogation aux règles du service public.",
    options: ["Vrai", "Faux", "Uniquement si violences"],
    answer: "Vrai",
    explanation:
        "Le texte insiste sur l’objectif précis : exemption/application différenciée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Vrai/Faux — Rébellion (aggravations)",
    question:
        "Vrai ou Faux : La rébellion commise en réunion est moins sévèrement punie que la rébellion simple.",
    options: ["Vrai", "Faux", "Uniquement si pas d’arme"],
    answer: "Faux",
    explanation:
        "En réunion = aggravation (3 ans / 45 000 €) > simple (2 ans / 30 000 €).",
    difficulty: "Facile",
  ),

  // ---------------------------------------------------------
  // MINI CAS PRATIQUES — Qualification + article + peine
  // (Chaque cas = QCM)
  // ---------------------------------------------------------
  const QuizQuestion(
    category: "Cas pratique — Interpellation (violence)",
    question:
        "Lors d’une interpellation, un homme se débat violemment, bouscule un policier et tente de s’enfuir. Quelle qualification principale ?",
    options: [
      "Rébellion (433-6 CP), réprimée par 433-7 al.1 — 2 ans et 30 000 €",
      "Outrage — 6 mois et 7 500 €",
      "Refus d’obtempérer — contravention",
    ],
    answer: "Rébellion (433-6 CP), réprimée par 433-7 al.1 — 2 ans et 30 000 €",
    explanation:
        "Résistance active et violente à l’action d’un agent dans l’exercice de ses fonctions = rébellion (simple).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Obstacle passif",
    question:
        "Un homme refuse de descendre de sa voiture et s’agrippe au volant sans donner de coups ni bousculer. Qualification la plus adaptée ?",
    options: [
      "Pas rébellion (obstacle passif) — rechercher autre qualification selon contexte",
      "Rébellion certaine (433-6)",
      "Provocation à la rébellion (433-10)",
    ],
    answer:
        "Pas rébellion (obstacle passif) — rechercher autre qualification selon contexte",
    explanation:
        "Ton cours : simple désobéissance/obstacle passif ≠ rébellion (exemple Cass. crim., 1er mars 2006).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Rébellion en réunion",
    question:
        "Trois individus entourent des policiers pour empêcher une interpellation et se débattent violemment avec eux. Qualification/peine ?",
    options: [
      "Rébellion en réunion — 433-7 al.2 — 3 ans et 45 000 €",
      "Rébellion simple — 433-7 al.1 — 2 ans et 30 000 €",
      "Provocation à la rébellion — 433-10 — 2 mois et 7 500 €",
    ],
    answer: "Rébellion en réunion — 433-7 al.2 — 3 ans et 45 000 €",
    explanation:
        "Réunion = circonstance aggravante spécifique de la rébellion.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Rébellion armée",
    question:
        "Lors d’un contrôle, un individu se débat violemment. Une arme blanche est retrouvée sur lui (cachée). Qualification/peine ?",
    options: [
      "Rébellion avec arme — 433-8 al.1 — 5 ans et 75 000 €",
      "Rébellion simple — 433-7 al.1 — 2 ans et 30 000 €",
      "Menaces 433-3 — 3 ans et 45 000 €",
    ],
    answer: "Rébellion avec arme — 433-8 al.1 — 5 ans et 75 000 €",
    explanation:
        "Port d’une arme, apparente ou cachée, pendant la rébellion = aggravation 433-8.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Arme + réunion",
    question:
        "Deux individus se rebellent violemment contre les policiers. L’un d’eux est porteur d’une arme. Qualification/peine maximale dans ton tableau ?",
    options: [
      "Rébellion armée en réunion — 433-8 al.2 — 10 ans et 150 000 €",
      "Rébellion en réunion — 433-7 al.2 — 3 ans et 45 000 €",
      "Rébellion simple — 433-7 al.1 — 2 ans et 30 000 €",
    ],
    answer: "Rébellion armée en réunion — 433-8 al.2 — 10 ans et 150 000 €",
    explanation:
        "Cumul arme + réunion = niveau d’aggravation supérieur (10 ans / 150k).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Provocation à la rébellion",
    question:
        "Un individu crie sur la voie publique : « Venez, ils ne sont que deux, on va les défoncer ! » pour empêcher son interpellation. Qualification/peine ?",
    options: [
      "Provocation directe à la rébellion — 433-10 — 2 mois et 7 500 €",
      "Rébellion simple — 433-7 al.1 — 2 ans et 30 000 €",
      "Menaces 433-3 — 3 ans et 45 000 €",
    ],
    answer: "Provocation directe à la rébellion — 433-10 — 2 mois et 7 500 €",
    explanation:
        "Incitation directe à opposition violente (infraction formelle) = 433-10.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Menaces envers policier",
    question:
        "En raison d’un contrôle, un homme dit à un policier en uniforme : « Je vais te casser la gueule ce soir ». Qualification/peine (simple) ?",
    options: [
      "Menaces de crime/délit envers dépositaire — 433-3 — 3 ans et 45 000 €",
      "Outrage uniquement",
      "Provocation à la rébellion — 433-10 — 2 mois et 7 500 €",
    ],
    answer:
        "Menaces de crime/délit envers dépositaire — 433-3 — 3 ans et 45 000 €",
    explanation:
        "Annonce d’un délit à venir contre la personne + qualité apparente/connue + lien fonctions = 433-3 (simple).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Menace de mort",
    question:
        "Un individu dit à un enseignant : « Je vais te tuer » pendant qu’il est en fonction. Qualification/peine ?",
    options: [
      "Menaces aggravées — 433-3 al.5 — 5 ans et 75 000 €",
      "Menaces simples — 433-3 — 3 ans et 45 000 €",
      "433-3-1 — 5 ans et 75 000 €",
    ],
    answer: "Menaces aggravées — 433-3 al.5 — 5 ans et 75 000 €",
    explanation: "Menace de mort = aggravation al.5.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Pression pour acte de fonction (al.6)",
    question:
        "Un individu menace un agent public pour qu’il falsifie une décision administrative en sa faveur. Qualification/peine ?",
    options: [
      "Menaces/intimidation pour obtenir acte de fonction/abus d’autorité — 433-3 al.6 — 10 ans et 150 000 €",
      "Menaces simples — 433-3 — 3 ans et 45 000 €",
      "433-3-1 — 5 ans et 75 000 €",
    ],
    answer:
        "Menaces/intimidation pour obtenir acte de fonction/abus d’autorité — 433-3 al.6 — 10 ans et 150 000 €",
    explanation:
        "Al.6 vise la pression pour faire accomplir/s’abstenir un acte de fonction ou abus d’autorité pour décision favorable.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Dérogation service public (433-3-1)",
    question:
        "Un usager menace un agent municipal pour obtenir une exemption aux règles d’accès d’un service public (traitement différencié). Qualification/peine ?",
    options: [
      "433-3-1 — 5 ans et 75 000 €",
      "433-3 al.6 — 10 ans et 150 000 €",
      "Outrage uniquement",
    ],
    answer: "433-3-1 — 5 ans et 75 000 €",
    explanation:
        "But = application dérogatoire des règles du service public → 433-3-1 (intention particulière).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Cas pratique — Dérogation (cantine)",
    question:
        "Après plusieurs refus, un parent menace le personnel d’une cantine pour obtenir un régime alimentaire non prévu par le règlement. Qualification/peine ?",
    options: [
      "433-3-1 — 5 ans et 75 000 €",
      "Menaces simples 433-3 — 3 ans et 45 000 €",
      "Provocation 433-10 — 2 mois et 7 500 €",
    ],
    answer: "433-3-1 — 5 ans et 75 000 €",
    explanation:
        "Exemple donné dans ton doc : obtention d’un régime différencié dans cantines scolaires → 433-3-1.",
    difficulty: "Moyenne",
  ),

  // ---------------------------------------------------------
  // SUPER PIÈGES — cas “mixte” et questions à choix proches
  // ---------------------------------------------------------
  const QuizQuestion(
    category: "Piège — Outrage + Rébellion (ordre logique)",
    question:
        "Pendant l’interpellation, un individu insulte l’agent puis se débat violemment pour échapper. La qualification principale liée à l’acte physique est :",
    options: [
      "Rébellion (433-6 / 433-7) ; l’outrage peut exister à côté selon faits distincts",
      "Outrage uniquement",
      "Provocation à la rébellion",
    ],
    answer:
        "Rébellion (433-6 / 433-7) ; l’outrage peut exister à côté selon faits distincts",
    explanation:
        "La résistance violente = rébellion. Les insultes peuvent constituer outrage si distinctes.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — Menace vs Outrage",
    question:
        "Dire à un policier : « T’es nul, t’es un clown » correspond plutôt à :",
    options: [
      "Outrage (atteinte au respect dû à la fonction)",
      "Menaces 433-3",
      "Rébellion",
    ],
    answer: "Outrage (atteinte au respect dû à la fonction)",
    explanation:
        "Pas d’annonce d’un crime/délit futur : c’est insultant/dégradant = outrage (si conditions réunies).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège — Menace de bien",
    question:
        "Dire à un gardien d’immeuble assermenté : « Je vais dégrader ta loge » en raison de sa fonction correspond plutôt à :",
    options: [
      "Menaces 433-3 (contre les biens) — 3 ans et 45 000 € (simple)",
      "Outrage uniquement",
      "433-3-1",
    ],
    answer: "Menaces 433-3 (contre les biens) — 3 ans et 45 000 € (simple)",
    explanation:
        "Menace d’atteinte aux biens + victime protégée (gardien assermenté cité) + lien fonctions → 433-3.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Piège — Provocation vs Rébellion",
    question:
        "Un individu crie à la foule d’empêcher l’interpellation, mais personne ne bouge. Qualification ?",
    options: [
      "Provocation directe à la rébellion (433-10) quand même",
      "Aucune infraction",
      "Rébellion simple",
    ],
    answer: "Provocation directe à la rébellion (433-10) quand même",
    explanation: "Infraction formelle : pas besoin d’effet.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Piège — Menaces vs 433-3-1",
    question:
        "Un usager menace un agent d’un service public pour obtenir un traitement 'hors règle' (dérogation). Qualification la plus pertinente ?",
    options: [
      "433-3-1 (objectif dérogatoire)",
      "433-3 simple dans tous les cas",
      "Rébellion",
    ],
    answer: "433-3-1 (objectif dérogatoire)",
    explanation:
        "Quand le cœur du dossier = obtenir une exemption/application différenciée des règles → 433-3-1.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Provocation à la rébellion — Définition",
    question: "La provocation directe à la rébellion consiste à :",
    options: [
      "Inciter directement quelqu’un à commettre le délit de rébellion",
      "Critiquer verbalement l’action des forces de l’ordre",
      "Refuser d’obtempérer à une sommation",
    ],
    answer: "Inciter directement quelqu’un à commettre le délit de rébellion",
    explanation:
        "L’article 433-10 CP vise la provocation directe à commettre le délit de rébellion.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Texte",
    question: "La provocation directe à la rébellion est prévue par :",
    options: [
      "Article 433-10 du Code pénal",
      "Article 433-6 du Code pénal",
      "Article 433-3 du Code pénal",
    ],
    answer: "Article 433-10 du Code pénal",
    explanation: "Le délit est défini et réprimé par l’article 433-10 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Caractère direct",
    question: "Pour être punissable, la provocation doit :",
    options: [
      "Tendre sans ambiguïté à une opposition violente à l’action de l’autorité",
      "Exprimer un simple mécontentement",
      "Être suivie d’effet",
    ],
    answer:
        "Tendre sans ambiguïté à une opposition violente à l’action de l’autorité",
    explanation:
        "La provocation doit présenter un lien précis et incontestable avec l’acte de rébellion.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Résultat",
    question: "La provocation directe à la rébellion est constituée :",
    options: [
      "Même si elle n’est pas suivie d’effet",
      "Uniquement si la rébellion a lieu",
      "Uniquement si des violences sont commises",
    ],
    answer: "Même si elle n’est pas suivie d’effet",
    explanation:
        "Il s’agit d’une infraction formelle : le résultat est indifférent.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Moyens",
    question: "La provocation peut être réalisée notamment par :",
    options: [
      "Cris, discours publics, écrits affichés ou distribués",
      "Un simple regard menaçant",
      "Une pensée non exprimée",
    ],
    answer: "Cris, discours publics, écrits affichés ou distribués",
    explanation:
        "L’article 433-10 vise divers moyens de transmission de la parole, de l’écrit ou de l’image.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Presse",
    question:
        "Lorsque la provocation est commise par la presse écrite ou audiovisuelle :",
    options: [
      "La loi du 29 juillet 1881 s’applique",
      "L’article 433-10 est inapplicable",
      "Il n’y a pas d’infraction",
    ],
    answer: "La loi du 29 juillet 1881 s’applique",
    explanation:
        "L’alinéa 2 de l’article 433-10 renvoie aux règles spécifiques de la presse.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Élément moral",
    question: "L’élément moral de la provocation à la rébellion suppose :",
    options: [
      "La volonté d’inciter autrui à commettre un acte de rébellion",
      "Une simple imprudence",
      "Un état d’énervement",
    ],
    answer: "La volonté d’inciter autrui à commettre un acte de rébellion",
    explanation: "Il s’agit d’une infraction intentionnelle.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Provocation à la rébellion — Peines",
    question:
        "Les peines encourues pour la provocation directe à la rébellion sont :",
    options: [
      "2 mois d’emprisonnement et 7 500 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "2 mois d’emprisonnement et 7 500 € d’amende",
    explanation: "Peines prévues à l’article 433-10 CP.",
    difficulty: "Facile",
  ),

  // =========================================================
  // RÉBELLION — ARTICLES 433-6 À 433-9 CP
  // =========================================================
  const QuizQuestion(
    category: "Rébellion — Définition",
    question: "La rébellion consiste à :",
    options: [
      "Opposer une résistance violente à un agent public agissant dans l’exercice de ses fonctions",
      "Refuser verbalement un ordre",
      "Contester une décision administrative",
    ],
    answer:
        "Opposer une résistance violente à un agent public agissant dans l’exercice de ses fonctions",
    explanation:
        "L’article 433-6 CP définit la rébellion par une résistance violente.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Texte",
    question: "La rébellion est définie par l’article :",
    options: [
      "433-6 du Code pénal",
      "433-10 du Code pénal",
      "432-8 du Code pénal",
    ],
    answer: "433-6 du Code pénal",
    explanation: "L’article 433-6 CP définit la rébellion.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Victime",
    question: "La victime de la rébellion doit être :",
    options: [
      "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
      "Un simple particulier",
      "Un témoin",
    ],
    answer:
        "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
    explanation: "La qualité de la victime est un élément constitutif.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Exercice des fonctions",
    question: "Il y a rébellion uniquement si l’agent agit :",
    options: [
      "Dans l’exercice de ses fonctions",
      "Dans un cadre privé",
      "En dehors de toute mission",
    ],
    answer: "Dans l’exercice de ses fonctions",
    explanation:
        "La résistance doit intervenir pendant l’exercice des fonctions.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Illégalité de l’acte",
    question: "L’illégalité éventuelle de l’acte accompli par l’agent :",
    options: [
      "N’exclut pas la rébellion",
      "Supprime l’infraction",
      "Transforme la rébellion en outrage",
    ],
    answer: "N’exclut pas la rébellion",
    explanation: "La Cour de cassation juge l’illégalité sans incidence.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Rébellion — Résistance",
    question: "La rébellion suppose :",
    options: [
      "Une résistance violente et active",
      "Une simple inertie",
      "Un refus passif",
    ],
    answer: "Une résistance violente et active",
    explanation: "La simple désobéissance ou l’obstacle passif sont exclus.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Élément moral",
    question: "L’élément moral de la rébellion suppose :",
    options: [
      "La connaissance de la qualité de l’agent et la volonté de résister",
      "Une erreur de perception",
      "Un trouble psychologique",
    ],
    answer:
        "La connaissance de la qualité de l’agent et la volonté de résister",
    explanation:
        "L’auteur doit avoir conscience de s’opposer à un agent public.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Rébellion — Réunion",
    question: "La rébellion est aggravée lorsqu’elle est commise :",
    options: ["En réunion", "La nuit", "En état d’ivresse"],
    answer: "En réunion",
    explanation: "Article 433-7 al.2 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Arme",
    question: "La rébellion est aggravée lorsque l’auteur :",
    options: [
      "Est porteur d’une arme, apparente ou cachée",
      "Crie fortement",
      "Fuit les lieux",
    ],
    answer: "Est porteur d’une arme, apparente ou cachée",
    explanation: "Article 433-8 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Rébellion — Peines simples",
    question: "Les peines encourues pour la rébellion simple sont :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "2 mois d’emprisonnement et 7 500 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation: "Peines prévues par l’article 433-7 al.1 CP.",
    difficulty: "Facile",
  ),

  // =========================================================
  // MENACES ENVERS PERSONNE DÉPOSITAIRE / SERVICE PUBLIC — 433-3
  // =========================================================
  const QuizQuestion(
    category: "Menaces — Définition",
    question: "Les menaces réprimées par l’article 433-3 CP consistent à :",
    options: [
      "Menacer de commettre un crime ou un délit contre une personne protégée",
      "Insulter un agent public",
      "Refuser d’obtempérer",
    ],
    answer:
        "Menacer de commettre un crime ou un délit contre une personne protégée",
    explanation: "L’article 433-3 vise les menaces de crime ou de délit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Menaces — Résultat",
    question: "La menace est punissable :",
    options: [
      "Même si elle n’est pas réitérée ou exécutée",
      "Uniquement si elle est suivie d’effet",
      "Uniquement si elle est écrite",
    ],
    answer: "Même si elle n’est pas réitérée ou exécutée",
    explanation: "La matérialisation ou l’exécution est indifférente.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Menaces — Qualité de la victime",
    question:
        "Pour constituer l’infraction, la qualité de la victime doit être :",
    options: [
      "Apparente ou connue de l’auteur",
      "Mentionnée par écrit",
      "Ignorée de l’auteur",
    ],
    answer: "Apparente ou connue de l’auteur",
    explanation:
        "La menace doit être motivée par les fonctions connues de la victime.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces — Élément moral",
    question: "L’auteur des menaces doit avoir :",
    options: [
      "Conscience du trouble causé par ses propos",
      "L’intention de passer à l’acte",
      "Un mobile légitime",
    ],
    answer: "Conscience du trouble causé par ses propos",
    explanation: "L’intention de réaliser la menace est indifférente.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Menaces — Peines simples",
    question: "Les peines encourues pour les menaces simples sont :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Peines prévues par l’article 433-3 CP.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Condition d’utilité",
    question:
        "La dénonciation doit être considérée comme « utile » lorsqu’elle peut :",
    options: [
      "Prévenir ou limiter les effets du crime, ou empêcher la commission de nouveaux crimes",
      "Uniquement permettre une condamnation civile",
      "Uniquement satisfaire la curiosité des enquêteurs",
    ],
    answer:
        "Prévenir ou limiter les effets du crime, ou empêcher la commission de nouveaux crimes",
    explanation:
        "Le cours précise que l’obligation concerne les crimes dont la dénonciation peut prévenir/limiter/empêcher.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Nature des infractions",
    question: "L’obligation de dénonciation vise :",
    options: [
      "Les crimes, peu importe leur nature",
      "Uniquement les crimes contre les biens",
      "Uniquement les crimes contre les personnes",
    ],
    answer: "Les crimes, peu importe leur nature",
    explanation:
        "Le cours : « infractions de nature criminelle, peu importe la nature du crime ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Tentative",
    question: "L’incrimination est également applicable :",
    options: [
      "À la tentative de crime",
      "Au simple projet criminel",
      "Uniquement aux crimes consommés",
    ],
    answer: "À la tentative de crime",
    explanation:
        "Le cours indique que la non-dénonciation concerne aussi la tentative de crime.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Simple projet",
    question:
        "Le simple projet criminel, en l’absence de tout commencement d’exécution :",
    options: [
      "N’est pas concerné",
      "Est toujours concerné",
      "Est concerné uniquement si le crime est passible de la perpétuité",
    ],
    answer: "N’est pas concerné",
    explanation:
        "Le cours exclut explicitement le simple projet criminel sans commencement d’exécution.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Infraction d’omission",
    question: "La non-dénonciation de crime est une infraction :",
    options: [
      "D’omission (abstention)",
      "De commission (acte positif)",
      "D’imprudence",
    ],
    answer: "D’omission (abstention)",
    explanation:
        "Le cours précise : l’individu avait la possibilité d’avertir et il ne l’a pas fait.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Autorités",
    question:
        "Sont visées comme autorités judiciaires ou administratives susceptibles de recevoir l’information :",
    options: [
      "Toute autorité capable d’en mesurer l’importance et d’y donner suite",
      "Uniquement le juge d’instruction",
      "Uniquement le maire",
    ],
    answer:
        "Toute autorité capable d’en mesurer l’importance et d’y donner suite",
    explanation:
        "Le cours vise le ministère public, police, gendarmerie et toute autorité utile.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Exemples d’autorités",
    question: "Le cours cite notamment comme destinataires possibles :",
    options: [
      "Le ministère public, les fonctionnaires de police, la gendarmerie nationale",
      "Uniquement un avocat",
      "Uniquement un journaliste",
    ],
    answer:
        "Le ministère public, les fonctionnaires de police, la gendarmerie nationale",
    explanation: "Exemples expressément mentionnés dans le cours.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Dénonciation indirecte",
    question: "La jurisprudence admet que la dénonciation puisse être faite :",
    options: [
      "Auprès d’une personne qui intervient pour le compte des autorités",
      "Uniquement par lettre recommandée",
      "Uniquement en dépôt de plainte formel",
    ],
    answer: "Auprès d’une personne qui intervient pour le compte des autorités",
    explanation:
        "Le cours précise que la dénonciation peut être faite auprès d’un intermédiaire agissant pour leur compte.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Objet de la révélation",
    question: "L’obligation implique la révélation :",
    options: [
      "De l’existence du crime (les faits eux-mêmes)",
      "Uniquement de l’identité de l’auteur",
      "Uniquement du lieu de résidence du complice",
    ],
    answer: "De l’existence du crime (les faits eux-mêmes)",
    explanation:
        "Le cours : l’information doit porter sur les faits, pas nécessairement sur l’identité de l’auteur/complice.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Identité de l’auteur",
    question: "Selon la jurisprudence citée, l’obligation porte :",
    options: [
      "Sur le crime et non sur l’identité ou le refuge des auteurs",
      "Sur l’identité uniquement",
      "Sur l’identité et le refuge obligatoirement",
    ],
    answer: "Sur le crime et non sur l’identité ou le refuge des auteurs",
    explanation:
        "Cass. crim., 26 février 1959 : obligation de dénoncer le crime, pas l’identité/refuge.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Modalités",
    question: "Les modalités de dénonciation sont :",
    options: [
      "Libres (toutes admissibles)",
      "Uniquement écrites",
      "Uniquement orales",
    ],
    answer: "Libres (toutes admissibles)",
    explanation:
        "Le cours : « toutes les modalités de dénonciation sont admissibles ».",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Finalité",
    question: "L’information vise principalement à :",
    options: [
      "Prévenir un trouble à l’ordre public",
      "Provoquer une sanction disciplinaire",
      "Éviter toute enquête",
    ],
    answer: "Prévenir un trouble à l’ordre public",
    explanation:
        "Le cours : l’information est destinée à prévenir un trouble à l’ordre public.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Prévenir/limiter",
    question: "La dénonciation peut prévenir ou limiter les effets notamment :",
    options: [
      "Dans le cadre d’une tentative où elle peut éviter le crime",
      "Uniquement après condamnation",
      "Uniquement en matière de contravention",
    ],
    answer: "Dans le cadre d’une tentative où elle peut éviter le crime",
    explanation:
        "Le cours donne l’exemple : tentative où la dénonciation est susceptible d’éviter le crime.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Nouveaux crimes",
    question: "La dénonciation peut aussi permettre :",
    options: [
      "D’éviter de nouveaux crimes, notamment par l’identification des auteurs",
      "D’annuler l’enquête",
      "De supprimer la responsabilité pénale",
    ],
    answer:
        "D’éviter de nouveaux crimes, notamment par l’identification des auteurs",
    explanation:
        "Le cours : éviter de nouveaux crimes, notamment par identification des auteurs.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Élément moral",
    question: "L’élément moral est caractérisé si la personne :",
    options: [
      "Consciente qu’un crime se commet ou va se produire, s’abstient volontairement de le dénoncer",
      "A uniquement des doutes vagues",
      "Oublie de dénoncer par inattention",
    ],
    answer:
        "Consciente qu’un crime se commet ou va se produire, s’abstient volontairement de le dénoncer",
    explanation:
        "Le cours : connaissance + absence de dénonciation → intention ; Cass. crim., 7 novembre 1990.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Mobile",
    question: "Le mobile expliquant l’abstention :",
    options: [
      "Est indifférent",
      "Supprime l’intention",
      "Aggrave systématiquement la peine",
    ],
    answer: "Est indifférent",
    explanation: "Le cours : le mobile importe peu.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Aggravation (434-2)",
    question:
        "La non-dénonciation est aggravée lorsque le crime non dénoncé constitue :",
    options: [
      "Une atteinte aux intérêts fondamentaux de la Nation ou un acte de terrorisme",
      "Un vol simple",
      "Une contravention",
    ],
    answer:
        "Une atteinte aux intérêts fondamentaux de la Nation ou un acte de terrorisme",
    explanation: "Article 434-2 : trahison, espionnage, attentat, etc.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Immunité familiale et 434-2",
    question: "En cas de 434-2, l’immunité familiale :",
    options: [
      "Ne s’applique pas",
      "S’applique toujours",
      "S’applique uniquement aux frères et sœurs",
    ],
    answer: "Ne s’applique pas",
    explanation:
        "Le cours précise : l’immunité familiale de 434-1 n’est pas applicable en 434-2.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Peines (simple)",
    question: "Peines encourues (434-1 al.1) :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Peines de la forme simple indiquées dans le cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Peines (aggravée)",
    question: "Peines encourues (434-2) :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Peines aggravées indiquées par le cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Tentative",
    question: "La tentative de non-dénonciation est :",
    options: [
      "Non incriminée",
      "Incriminée",
      "Incriminée seulement en cas de récidive",
    ],
    answer: "Non incriminée",
    explanation: "Le cours précise : tentative non incriminée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Complicité",
    question: "La complicité est possible notamment si une personne :",
    options: [
      "Incite le témoin à ne pas dénoncer un crime",
      "Informe les autorités",
      "Dépose plainte",
    ],
    answer: "Incite le témoin à ne pas dénoncer un crime",
    explanation:
        "Le cours cite explicitement ce cas de complicité (provocation).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Secret professionnel",
    question:
        "Les personnes astreintes au secret professionnel (226-13) sont :",
    options: [
      "Exemptées de l’obligation de dénonciation",
      "Toujours tenues de dénoncer",
      "Tenues de dénoncer uniquement les délits",
    ],
    answer: "Exemptées de l’obligation de dénonciation",
    explanation: "Le cours prévoit l’exception liée au secret professionnel.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Participant au crime",
    question: "Celui qui a participé au crime :",
    options: [
      "Est excepté de l’obligation de dénonciation",
      "Doit dénoncer sinon aggravation",
      "Est soumis à 434-1 automatiquement",
    ],
    answer: "Est excepté de l’obligation de dénonciation",
    explanation:
        "Le cours : celui qui a participé au crime est excepté de l’obligation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Immunité familiale (principe)",
    question: "L’immunité familiale bénéficie notamment :",
    options: [
      "Aux parents en ligne directe et leurs conjoints, frères/sœurs et leurs conjoints, conjoint/concubin/PACS",
      "Uniquement aux amis proches",
      "Uniquement aux collègues",
    ],
    answer:
        "Aux parents en ligne directe et leurs conjoints, frères/sœurs et leurs conjoints, conjoint/concubin/PACS",
    explanation:
        "Liste donnée par le cours, incluant concubin et partenaire de PACS.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Crimes sur mineurs",
    question: "Concernant les crimes commis sur les mineurs :",
    options: [
      "L’immunité familiale est écartée",
      "L’immunité familiale s’applique toujours",
      "Le secret professionnel est écarté",
    ],
    answer: "L’immunité familiale est écartée",
    explanation:
        "Le cours : immunité familiale OUI sauf crimes commis sur mineurs.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // AJOUTS — FAUX TÉMOIGNAGE / TÉMOIGNAGE MENSONGER (434-13 / 434-14)
  // =========================================================
  const QuizQuestion(
    category: "Faux témoignage — Définition",
    question: "Le faux témoignage est constitué par :",
    options: [
      "Un témoignage mensonger fait sous serment devant une juridiction ou devant un OPJ sur commission rogatoire",
      "Un mensonge en audition libre",
      "Un mensonge dans une conversation privée",
    ],
    answer:
        "Un témoignage mensonger fait sous serment devant une juridiction ou devant un OPJ sur commission rogatoire",
    explanation:
        "Le cours : mensonge sous serment, devant juridiction ou OPJ en commission rogatoire.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Texte",
    question: "Le faux témoignage est réprimé par :",
    options: [
      "Article 434-13 du Code pénal",
      "Article 434-1 du Code pénal",
      "Article 434-2 du Code pénal",
    ],
    answer: "Article 434-13 du Code pénal",
    explanation: "Le cours : 434-13 définit et réprime le délit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Juridictions concernées",
    question: "Le faux témoignage peut être commis devant :",
    options: [
      "Des juridictions pénales, civiles, administratives ou financières",
      "Uniquement la cour d’assises",
      "Uniquement le tribunal correctionnel",
    ],
    answer: "Des juridictions pénales, civiles, administratives ou financières",
    explanation:
        "Le terme juridiction est général : pénales, civiles, administratives, financières.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — OPJ et commission rogatoire",
    question: "Le faux témoignage peut aussi être retenu devant un OPJ si :",
    options: [
      "L’OPJ agit en exécution d’une commission rogatoire",
      "L’OPJ agit en enquête préliminaire",
      "L’OPJ agit en flagrance sans mandat",
    ],
    answer: "L’OPJ agit en exécution d’une commission rogatoire",
    explanation:
        "Le cours : punissable devant OPJ uniquement en exécution d’une commission rogatoire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Préliminaire / flagrance",
    question:
        "Les déclarations mensongères faites au cours d’une enquête préliminaire ou de flagrance sont :",
    options: [
      "Non punissables au titre du faux témoignage",
      "Toujours punissables au titre du faux témoignage",
      "Punissables seulement si elles sont écrites",
    ],
    answer: "Non punissables au titre du faux témoignage",
    explanation: "Le cours l’indique expressément.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Serment",
    question: "Le faux témoignage suppose obligatoirement :",
    options: [
      "Une déclaration sous serment",
      "Un écrit signé",
      "Une déclaration enregistrée audio",
    ],
    answer: "Une déclaration sous serment",
    explanation:
        "Le mensonge seul ne suffit pas : il faut la violation du serment.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Formule",
    question: "La formule du serment consiste à jurer :",
    options: [
      "De dire la vérité, toute la vérité",
      "De dire ce qui arrange la justice",
      "De dire seulement ce qu’on a vu",
    ],
    answer: "De dire la vérité, toute la vérité",
    explanation: "Formule rappelée dans le cours.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Mineurs <16 ans",
    question: "L’infraction ne peut être retenue contre :",
    options: [
      "Un mineur de moins de 16 ans (serment non exigé)",
      "Un mineur de 17 ans",
      "Un majeur de 18 ans",
    ],
    answer: "Un mineur de moins de 16 ans (serment non exigé)",
    explanation:
        "Le cours précise : pas de serment avant 16 ans → pas de faux témoignage.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Garde à vue",
    question:
        "La personne entendue par l’OPJ sur commission rogatoire sous le régime de la garde à vue :",
    options: [
      "Ne commet pas de faux témoignage (pas de serment, droit de ne pas s’auto-incriminer)",
      "Prête serment comme un témoin",
      "Commets un faux témoignage automatiquement",
    ],
    answer:
        "Ne commet pas de faux témoignage (pas de serment, droit de ne pas s’auto-incriminer)",
    explanation: "Le cours : pas de serment en GAV → pas de faux témoignage.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Nature du mensonge",
    question: "Le Code pénal :",
    options: [
      "N’énumère pas les moyens trompeurs : toute altération sciemment faite de la vérité est visée",
      "Liste exhaustivement les mensonges interdits",
      "Ne vise que les mensonges écrits",
    ],
    answer:
        "N’énumère pas les moyens trompeurs : toute altération sciemment faite de la vérité est visée",
    explanation:
        "Le cours précise : toute altération sciemment faite de la vérité est incriminée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Commission",
    question: "Le faux témoignage est une infraction de :",
    options: ["Commission (acte positif)", "Omission", "Négligence"],
    answer: "Commission (acte positif)",
    explanation:
        "Le cours : acte positif requis, refus de déposer ≠ faux témoignage.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Refus de déposer",
    question: "Le refus de comparaître ou de déposer :",
    options: [
      "Ne peut être assimilé à un faux témoignage",
      "Est toujours un faux témoignage",
      "Constitue une tentative de faux témoignage",
    ],
    answer: "Ne peut être assimilé à un faux témoignage",
    explanation: "Le cours l’indique explicitement.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Affirmation inexacte",
    question: "Le faux témoignage peut consister en :",
    options: [
      "L’affirmation d’un fait inexact",
      "Une simple hésitation",
      "Une opinion personnelle",
    ],
    answer: "L’affirmation d’un fait inexact",
    explanation: "Exemple classique rappelé dans le cours.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Négation d’un fait vrai",
    question: "Constitue un faux témoignage le fait :",
    options: [
      "De nier un fait véritable (déclarer ne pas savoir alors qu’on sait)",
      "De se tromper de bonne foi",
      "D’être confus",
    ],
    answer:
        "De nier un fait véritable (déclarer ne pas savoir alors qu’on sait)",
    explanation:
        "Le cours : la négation d’un fait vrai (dire ne pas savoir) est visée si c’est sciemment.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Omission",
    question: "Le mensonge peut résulter d’une omission lorsque :",
    options: [
      "Le témoin donne volontairement une réponse partielle qui dénature les faits",
      "Le témoin n’est pas interrogé",
      "Le témoin est stressé",
    ],
    answer:
        "Le témoin donne volontairement une réponse partielle qui dénature les faits",
    explanation:
        "Le cours admet le mensonge par omission si la présentation incomplète dénature la vérité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Caractère déterminant",
    question: "Le faux témoignage est punissable seulement si :",
    options: [
      "La déclaration peut avoir une incidence sur la solution du procès",
      "La déclaration concerne n’importe quel détail",
      "Le témoin parle longtemps",
    ],
    answer: "La déclaration peut avoir une incidence sur la solution du procès",
    explanation:
        "Le cours : le témoignage doit être déterminant (circonstances essentielles).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Circonstances essentielles",
    question: "Une circonstance est dite « essentielle » lorsqu’elle est :",
    options: [
      "Susceptible d’entraîner la conviction du juge",
      "Uniquement mentionnée dans le PV",
      "Uniquement favorable à la partie civile",
    ],
    answer: "Susceptible d’entraîner la conviction du juge",
    explanation:
        "Le cours : essentielle = susceptible d’entraîner la conviction du juge.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Élément moral",
    question: "Le faux témoignage suppose :",
    options: [
      "La conscience de mentir et de trahir le serment prêté",
      "Une erreur involontaire",
      "Une inattention",
    ],
    answer: "La conscience de mentir et de trahir le serment prêté",
    explanation:
        "Le cours : infraction intentionnelle, volonté délibérée de tromper.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Mauvaise foi",
    question: "Le mensonge sanctionné est :",
    options: [
      "Intentionnel et fait de mauvaise foi",
      "Toujours involontaire",
      "Toujours lié à l’émotion",
    ],
    answer: "Intentionnel et fait de mauvaise foi",
    explanation:
        "Le cours : volonté délibérée de tromper, mensonge intentionnel.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Erreur de bonne foi",
    question: "Le témoin qui se trompe ou commet une erreur de bonne foi :",
    options: [
      "N’est pas punissable",
      "Est punissable comme faux témoin",
      "Est punissable uniquement si la partie civile le demande",
    ],
    answer: "N’est pas punissable",
    explanation:
        "Le cours : la loi ne punit pas l’erreur, mais le mensonge volontaire.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Circonstances aggravantes",
    question:
        "Le faux témoignage est aggravé notamment lorsqu’il est provoqué par :",
    options: [
      "La remise d’un don ou d’une récompense quelconque",
      "Une simple peur",
      "Une confusion",
    ],
    answer: "La remise d’un don ou d’une récompense quelconque",
    explanation: "Article 434-14 1° : don/récompense.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Récompense (sens large)",
    question: "La « récompense quelconque » vise :",
    options: [
      "Toute contrepartie ayant un impact sur le témoignage",
      "Uniquement de l’argent liquide",
      "Uniquement un cadeau matériel",
    ],
    answer: "Toute contrepartie ayant un impact sur le témoignage",
    explanation:
        "Le cours : toute contrepartie déterminante (même non monétaire).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Aggravation (peine criminelle)",
    question:
        "Le faux témoignage est aggravé lorsque celui contre lequel ou en faveur duquel il est commis :",
    options: [
      "Est passible d’une peine criminelle",
      "Est passible d’une amende seulement",
      "Est mineur",
    ],
    answer: "Est passible d’une peine criminelle",
    explanation: "Article 434-14 2° : passible d’une peine criminelle.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Peines (simple)",
    question: "Peines encourues (faux témoignage simple) :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Peines indiquées par le cours pour 434-13 al.1.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Peines (aggravé)",
    question: "Peines encourues (faux témoignage aggravé) :",
    options: [
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende",
    explanation: "Peines indiquées par le cours pour 434-14.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Tentative",
    question: "La tentative de faux témoignage est :",
    options: [
      "Non incriminée",
      "Incriminée",
      "Incriminée uniquement si don/récompense",
    ],
    answer: "Non incriminée",
    explanation: "Le cours précise : tentative non incriminée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Complicité",
    question: "La complicité de faux témoignage est :",
    options: [
      "Punissable (121-6 et 121-7) et peut se confondre avec la subornation (434-15)",
      "Impossible",
      "Punissable uniquement si l’auteur principal est condamné à une peine criminelle",
    ],
    answer:
        "Punissable (121-6 et 121-7) et peut se confondre avec la subornation (434-15)",
    explanation:
        "Le cours : complicité possible + lien possible avec subornation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Rétractation (exemption)",
    question: "Le faux témoin est exempt de peine s’il rétracte :",
    options: [
      "Spontanément avant la décision mettant fin à la procédure",
      "Après le jugement définitif",
      "Uniquement après mise en examen",
    ],
    answer: "Spontanément avant la décision mettant fin à la procédure",
    explanation:
        "434-13 al.2 : exemption si rétractation spontanée avant la décision de fin de procédure.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Effet de la rétractation",
    question: "La rétractation entraîne :",
    options: [
      "Exemption de peine (l’infraction reste constituée)",
      "Disparition de l’infraction",
      "Aggravation de la peine",
    ],
    answer: "Exemption de peine (l’infraction reste constituée)",
    explanation: "Le cours : reconnu coupable mais exempté de peine.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Spontanéité (non)",
    question: "N’est pas une rétractation spontanée :",
    options: [
      "La rétractation à la demande du juge d’instruction",
      "La rétractation immédiate sans pression",
      "La rétractation de sa propre initiative avant la fin de procédure",
    ],
    answer: "La rétractation à la demande du juge d’instruction",
    explanation: "Le cours cite cette hypothèse comme non spontanée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Spontanéité après mise en examen",
    question: "N’est pas spontanée :",
    options: [
      "La rétractation après la mise en examen du faux témoin",
      "La rétractation avant toute poursuite",
      "La rétractation immédiate au cours de l’audience",
    ],
    answer: "La rétractation après la mise en examen du faux témoin",
    explanation: "Le cours cite ce cas comme non spontané.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Limite temporelle",
    question:
        "Selon la jurisprudence rappelée, la limite au-delà de laquelle la rétractation est tardive est :",
    options: [
      "La clôture des débats",
      "Le dépôt du PV",
      "L’ouverture de l’audience",
    ],
    answer: "La clôture des débats",
    explanation:
        "Le cours : la clôture des débats marque la limite jurisprudentielle.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // MINI-CAS (QUALIFICATION) — TRÈS UTILE EXAM
  // =========================================================
  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (tentative)",
    question:
        "Une personne apprend qu’un crime est sur le point d’être commis (commencement d’exécution) et qu’une alerte pourrait l’empêcher. Elle se tait. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Faux témoignage (434-13)",
      "Aucune infraction",
    ],
    answer: "Non-dénonciation de crime (434-1)",
    explanation:
        "Le cours : vise aussi la tentative si la dénonciation peut éviter le crime.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (tentative en cours)",
    question:
        "Une personne surprend un individu armé prêt à tirer sur quelqu’un, début de commencement d’exécution d’un meurtre, et sait qu’un appel immédiat à la police pourrait empêcher le crime. Elle ne fait rien. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Complicité de meurtre",
      "Aucune infraction",
    ],
    answer: "Non-dénonciation de crime (434-1)",
    explanation:
        "L’obligation de dénoncer concerne aussi les tentatives de crime lorsque la dénonciation peut encore empêcher la réalisation de l’infraction.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (projet vague)",
    question:
        "Une personne entend dans un bar : ‘Un jour, je braquerai une banque’, sans aucune précision ni préparation concrète. Elle ne signale rien aux autorités. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Tentative de non-dénonciation",
      "Aucune infraction de non-dénonciation",
    ],
    answer: "Aucune infraction de non-dénonciation",
    explanation:
        "L’article 434-1 exige un crime ou une tentative suffisamment caractérisée ; un simple projet flou sans commencement d’exécution n’entre pas dans le champ du texte.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (crime consommé, plus rien à sauver)",
    question:
        "Le soir au journal télévisé, une personne apprend qu’un meurtre a été commis la veille. Elle connaissait ce meurtre au moment des faits mais n’aurait, en pratique, jamais pu avertir à temps pour sauver la victime ou éviter une récidive. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune infraction de non-dénonciation",
      "Complicité de meurtre",
    ],
    answer: "Aucune infraction de non-dénonciation",
    explanation:
        "La dénonciation doit être utile : elle doit permettre de prévenir ou limiter les effets du crime ou d’éviter de nouveaux crimes ; à défaut, l’élément matériel fait défaut.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (nouveaux crimes à éviter)",
    question:
        "Une personne sait qu’un individu a commis un assassinat et se prépare à tuer à nouveau. Prévenir la police permettrait de l’arrêter avant le second crime. Elle se tait. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune infraction car le premier crime est consommé",
      "Complicité d’assassinat",
    ],
    answer: "Non-dénonciation de crime (434-1)",
    explanation:
        "Même si le premier crime est consommé, l’obligation subsiste lorsque la dénonciation peut empêcher de nouveaux crimes par le même auteur.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (secret professionnel de l’avocat)",
    question:
        "Un avocat apprend, au cours d’un entretien avec son client, que celui-ci a commis un crime et compte récidiver. L’avocat ne signale rien. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune non-dénonciation en raison du secret professionnel",
      "Complicité de crime",
    ],
    answer: "Aucune non-dénonciation en raison du secret professionnel",
    explanation:
        "Les personnes tenues au secret professionnel ne sont pas assujetties à l’obligation de dénonciation posée par l’article 434-1, sauf dispositions spéciales.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (médecin tenu au secret)",
    question:
        "Un médecin apprend, dans le cadre de son activité professionnelle, qu’un patient a commis un crime et se vante de vouloir recommencer. Le médecin se tait. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune non-dénonciation de crime en raison du secret professionnel",
      "Complicité de crime",
    ],
    answer:
        "Aucune non-dénonciation de crime en raison du secret professionnel",
    explanation:
        "Les personnes astreintes au secret professionnel, visées par l’article 226-13, bénéficient d’une exception à l’obligation de dénoncer posée par l’article 434-1.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (immunité familiale, victime majeure)",
    question:
        "Une mère apprend que sa fille majeure a commis un meurtre sur une victime majeure. Par affection, elle décide de garder le silence. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune infraction grâce à l’immunité familiale",
      "Complicité de meurtre",
    ],
    answer: "Aucune infraction grâce à l’immunité familiale",
    explanation:
        "L’article 434-1 écarte la responsabilité pénale des parents en ligne directe de l’auteur ou du complice, sauf si le crime a été commis sur un mineur.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (immunité familiale, mineur victime)",
    question:
        "Une tante apprend que son frère a commis un viol sur sa fille de 10 ans. Elle hésite, puis choisit de taire les faits. On retient :",
    options: [
      "Aucune infraction en raison de l’immunité familiale",
      "Non-dénonciation de crime (434-1)",
      "Complicité de viol",
    ],
    answer: "Non-dénonciation de crime (434-1)",
    explanation:
        "L’immunité familiale ne profite pas lorsque le crime est commis sur un mineur ; la tante demeure tenue à la dénonciation du crime.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (concubin auteur du crime)",
    question:
        "Une personne vivant notoirement en concubinage avec l’auteur d’un crime apprend les faits et se tait, pour ‘ne pas trahir son compagnon’. Victime majeure. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune infraction car le concubin bénéficie de l’immunité familiale",
      "Complicité de crime",
    ],
    answer:
        "Aucune infraction car le concubin bénéficie de l’immunité familiale",
    explanation:
        "L’article 434-1 vise le conjoint de l’auteur ou du complice ainsi que la personne vivant notoirement en situation maritale avec lui, sauf crime sur mineur.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (crime sur mineur par concubin)",
    question:
        "Une personne vit en concubinage avec l’auteur d’un crime de viol sur un mineur. Malgré sa connaissance des faits, elle ne dénonce pas. On retient :",
    options: [
      "Aucune infraction grâce à l’immunité familiale",
      "Non-dénonciation de crime (434-1)",
      "Complicité de viol",
    ],
    answer: "Non-dénonciation de crime (434-1)",
    explanation:
        "L’immunité ne joue pas pour les crimes commis sur mineurs, même pour le conjoint ou concubin de l’auteur.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (atteinte aux intérêts fondamentaux de la Nation)",
    question:
        "Un individu a connaissance d’un projet d’espionnage mettant gravement en péril les intérêts fondamentaux de la Nation, incriminé pénalement comme crime. Il garde le silence. On retient :",
    options: [
      "Non-dénonciation simple (434-1)",
      "Non-dénonciation aggravée (434-2)",
      "Aucune infraction, immunité familiale possible",
    ],
    answer: "Non-dénonciation aggravée (434-2)",
    explanation:
        "Lorsque le crime non dénoncé constitue une atteinte aux intérêts fondamentaux de la Nation ou un acte de terrorisme, la peine est aggravée et l’immunité familiale exclue.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (terrorisme, proche auteur)",
    question:
        "Une femme sait que son frère prépare un attentat terroriste imminent. Par loyauté familiale, elle garde le silence. On retient :",
    options: [
      "Non-dénonciation aggravée (434-2)",
      "Aucune infraction car immunité familiale",
      "Complicité d’acte de terrorisme uniquement",
    ],
    answer: "Non-dénonciation aggravée (434-2)",
    explanation:
        "En matière de terrorisme, le régime aggravé de l’article 434-2 s’applique et l’immunité familiale prévue par 434-1 est écartée.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (dénonciation à une autorité administrative)",
    question:
        "Une personne, témoin d’un crime sexuel sur un mineur, en informe un médecin inspecteur de la santé placé sous l’autorité du préfet, qui en avise ensuite le parquet. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Dénonciation valable, pas de non-dénonciation",
      "Complicité de viol",
    ],
    answer: "Dénonciation valable, pas de non-dénonciation",
    explanation:
        "La dénonciation peut être adressée aux autorités judiciaires ou administratives, voire à des personnes intervenant pour leur compte dès lors qu’elles transmettent l’information.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (révélation des faits, pas de l’auteur)",
    question:
        "Un témoin informe la police qu’un crime de séquestration est en cours dans un immeuble, sans connaître ni indiquer l’identité de l’auteur ni l’appartement exact. On retient :",
    options: [
      "Non-dénonciation de crime (434-1), car absence d’identité de l’auteur",
      "Dénonciation suffisante : pas de non-dénonciation",
      "Complicité de séquestration",
    ],
    answer: "Dénonciation suffisante : pas de non-dénonciation",
    explanation:
        "L’obligation porte sur la révélation de l’existence du crime et non sur la dénonciation de l’auteur, de son complice ou de son refuge.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (impossibilité matérielle d’alerter)",
    question:
        "Une personne retenue en otage assiste à un crime commis par ses ravisseurs, sans aucun moyen de communication. Elle n’alerte les autorités que plusieurs semaines plus tard, après sa libération, alors que le crime est déjà consommé. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune infraction faute de possibilité concrète de dénoncer",
      "Complicité de crime",
    ],
    answer: "Aucune infraction faute de possibilité concrète de dénoncer",
    explanation:
        "La non-dénonciation est une infraction d’omission qui suppose une possibilité réelle d’informer les autorités ; à défaut, l’élément matériel fait défaut.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (complicité par provocation à se taire)",
    question:
        "Un individu convainc un témoin de ne pas dénoncer un crime de vol à main armée qu’il a vu, pour ‘ne pas faire d’histoires’. Le témoin, qui aurait pu avertir la police à temps, se tait. On retient pour l’individu qui a incité au silence :",
    options: [
      "Aucune infraction personnelle",
      "Complicité de non-dénonciation de crime",
      "Complicité de vol à main armée",
    ],
    answer: "Complicité de non-dénonciation de crime",
    explanation:
        "La complicité de non-dénonciation est punissable au titre des articles 121-6 et 121-7, notamment par provocation ou instructions données.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Théorie — Non-dénonciation (nature de l’infraction)",
    question:
        "La non-dénonciation de crime prévue par l’article 434-1 du Code pénal est :",
    options: [
      "Un crime puni de 15 ans de réclusion",
      "Un délit puni de 3 ans d’emprisonnement et 45 000 € d’amende",
      "Une contravention de 5e classe",
    ],
    answer: "Un délit puni de 3 ans d’emprisonnement et 45 000 € d’amende",
    explanation:
        "L’article 434-1 réprime la non-dénonciation de crime de 3 ans d’emprisonnement et 45 000 € d’amende, ce qui en fait un délit.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Théorie — Non-dénonciation (infractions concernées)",
    question:
        "Quelles infractions sont visées par l’obligation de dénonciation de l’article 434-1 du Code pénal ?",
    options: [
      "Tous les crimes et délits",
      "Uniquement les crimes (y compris tentatives)",
      "Uniquement les crimes contre les personnes",
    ],
    answer: "Uniquement les crimes (y compris tentatives)",
    explanation:
        "L’article 434-1 vise les crimes dont il est encore possible de prévenir ou de limiter les effets, ainsi que leurs tentatives ; les délits ne sont pas concernés.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Théorie — Non-dénonciation (tentative et complicité)",
    question:
        "Concernant la non-dénonciation de crime (434-1), laquelle de ces affirmations est exacte ?",
    options: [
      "La tentative de non-dénonciation est punissable",
      "La tentative n’est pas punissable mais la complicité l’est",
      "Ni la tentative ni la complicité ne sont punissables",
    ],
    answer: "La tentative n’est pas punissable mais la complicité l’est",
    explanation:
        "Le texte ne prévoit pas la tentative de non-dénonciation, mais la complicité reste punissable suivant les articles 121-6 et 121-7 du Code pénal.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Théorie — Non-dénonciation (immunité familiale, principe)",
    question:
        "Parmi les personnes suivantes, lesquelles bénéficient en principe de l’immunité familiale prévue par l’article 434-1 ?",
    options: [
      "Les parents en ligne directe, les frères et sœurs et leurs conjoints, ainsi que le conjoint ou concubin de l’auteur",
      "Uniquement les parents et enfants de l’auteur",
      "Uniquement le conjoint marié de l’auteur",
    ],
    answer:
        "Les parents en ligne directe, les frères et sœurs et leurs conjoints, ainsi que le conjoint ou concubin de l’auteur",
    explanation:
        "L’article 434-1 exclut de l’incrimination les parents en ligne directe et leurs conjoints, les frères et sœurs et leurs conjoints, ainsi que le conjoint ou concubin de l’auteur ou du complice.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Théorie — Non-dénonciation (exclusions de l’immunité)",
    question:
        "Dans quel cas l’immunité familiale de l’article 434-1 ne s’applique-t-elle pas ?",
    options: [
      "Lorsque le crime est un vol simple",
      "Lorsque le crime est commis sur un mineur",
      "Lorsque le crime est un homicide involontaire",
    ],
    answer: "Lorsque le crime est commis sur un mineur",
    explanation:
        "Le texte précise que l’immunité familiale ne s’applique pas pour les crimes commis sur un mineur.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Théorie — Non-dénonciation (régime aggravé 434-2)",
    question:
        "Quelle est la principale conséquence de l’application de l’article 434-2 du Code pénal ?",
    options: [
      "La peine est abaissée à une simple amende",
      "La peine est portée à 5 ans d’emprisonnement et 75 000 € d’amende, sans bénéfice de l’immunité familiale",
      "La non-dénonciation devient une contravention",
    ],
    answer:
        "La peine est portée à 5 ans d’emprisonnement et 75 000 € d’amende, sans bénéfice de l’immunité familiale",
    explanation:
        "L’article 434-2 aggrave la répression pour certains crimes (intérêts fondamentaux, terrorisme) et exclut les alinéas sur l’immunité familiale.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (définition textuelle)",
    question:
        "Selon l’article 434-13 du Code pénal, le faux témoignage consiste en :",
    options: [
      "Tout mensonge devant un policier",
      "Un témoignage mensonger fait sous serment devant toute juridiction ou un OPJ agissant sur commission rogatoire",
      "Toute déclaration inexacte dans la presse",
    ],
    answer:
        "Un témoignage mensonger fait sous serment devant toute juridiction ou un OPJ agissant sur commission rogatoire",
    explanation:
        "L’article 434-13 vise expressément le témoignage mensonger sous serment devant une juridiction ou un OPJ agissant sur commission rogatoire.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (élément matériel)",
    question:
        "Lequel de ces éléments n’est pas requis pour caractériser le faux témoignage au sens de l’article 434-13 ?",
    options: [
      "Une déclaration sous serment",
      "Une altération volontaire de la vérité portant sur un point essentiel",
      "Une contrepartie financière",
    ],
    answer: "Une contrepartie financière",
    explanation:
        "La contrepartie financière n’est qu’une circonstance aggravante (434-14, 1°), pas un élément constitutif du faux témoignage simple.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (champ des juridictions)",
    question:
        "Le faux témoignage de l’article 434-13 peut-il être retenu devant une juridiction civile ou prud’homale ?",
    options: [
      "Non, seulement devant les juridictions pénales",
      "Oui, il peut l’être devant toute juridiction",
      "Non, seulement devant les juridictions administratives",
    ],
    answer: "Oui, il peut l’être devant toute juridiction",
    explanation:
        "Le texte vise ‘toute juridiction’, ce qui inclut les juridictions pénales, civiles, administratives, financières, voire prud’homales.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (peine encourue simple)",
    question:
        "Quelle est la peine maximale encourue pour le faux témoignage simple selon l’article 434-13 ?",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation:
        "L’article 434-13 punit le faux témoignage simple de 5 ans d’emprisonnement et 75 000 € d’amende.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (peines aggravées)",
    question:
        "En cas de faux témoignage aggravé par l’une des circonstances de l’article 434-14, quelle est la peine maximale encourue ?",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "10 ans d’emprisonnement et 150 000 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende",
    explanation:
        "L’article 434-14 porte la peine à 7 ans d’emprisonnement et 100 000 € d’amende lorsque les conditions aggravantes sont réunies.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (circ. aggravante de contrepartie)",
    question:
        "La circonstance aggravante prévue à l’article 434-14, 1° suppose :",
    options: [
      "Que le témoignage concerne une affaire criminelle",
      "Que le témoignage soit motivé par la remise d’un don ou d’une récompense quelconque",
      "Que le témoin soit fonctionnaire",
    ],
    answer:
        "Que le témoignage soit motivé par la remise d’un don ou d’une récompense quelconque",
    explanation:
        "Le 1° de l’article 434-14 vise le témoignage mensonger provoqué par un don, une récompense ou toute contrepartie.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (circ. aggravante peine criminelle)",
    question:
        "La circonstance aggravante prévue à l’article 434-14, 2° est liée :",
    options: [
      "À la qualité de magistrat du témoin",
      "Au fait que la personne en faveur ou à charge de laquelle le témoignage est commis est passible d’une peine criminelle",
      "Au fait que le témoin soit récidiviste",
    ],
    answer:
        "Au fait que la personne en faveur ou à charge de laquelle le témoignage est commis est passible d’une peine criminelle",
    explanation:
        "Le 2° de l’article 434-14 aggrave la peine lorsque la personne concernée par le faux témoignage encourt une sanction criminelle.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (rétractation et exemption de peine)",
    question:
        "Selon l’article 434-13, à quelle condition le faux témoin peut-il être exempté de peine ?",
    options: [
      "S’il reconnaît son mensonge au cours de sa garde à vue",
      "S’il rétracte spontanément son témoignage avant la décision mettant fin à la procédure par la juridiction d’instruction ou de jugement",
      "S’il demande pardon à la victime",
    ],
    answer:
        "S’il rétracte spontanément son témoignage avant la décision mettant fin à la procédure par la juridiction d’instruction ou de jugement",
    explanation:
        "L’alinéa 2 de l’article 434-13 prévoit l’exemption de peine en cas de rétractation spontanée avant la décision mettant fin à la procédure.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Faux témoignage (commission rogatoire, serment prêté)",
    question:
        "Devant un OPJ agissant en exécution d’une commission rogatoire, un témoin, régulièrement assermenté, ment volontairement sur un fait essentiel. On retient :",
    options: [
      "Faux témoignage (434-13)",
      "Non-dénonciation de crime (434-1)",
      "Aucune infraction spécifique",
    ],
    answer: "Faux témoignage (434-13)",
    explanation:
        "Le témoignage mensonger sous serment devant un OPJ agissant sur commission rogatoire est expressément visé par l’article 434-13.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (garde à vue, pas de serment)",
    question:
        "Un mis en examen, entendu sous le régime de la garde à vue par un OPJ sur commission rogatoire, ment volontairement sur sa participation aux faits. Il ne prête pas serment. On retient :",
    options: [
      "Faux témoignage (434-13)",
      "Pas de faux témoignage au sens de 434-13",
      "Non-dénonciation de crime (434-1)",
    ],
    answer: "Pas de faux témoignage au sens de 434-13",
    explanation:
        "La personne entendue en garde à vue ne prête pas serment et bénéficie du droit de ne pas s’auto-incriminer ; son mensonge ne relève pas de 434-13.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Faux témoignage (enquête préliminaire, simple témoin)",
    question:
        "Dans une enquête préliminaire, un témoin, non assermenté, ment volontairement à l’OPJ pour protéger un ami. On retient :",
    options: [
      "Faux témoignage (434-13)",
      "Pas de faux témoignage au sens de 434-13",
      "Non-dénonciation de crime (434-1)",
    ],
    answer: "Pas de faux témoignage au sens de 434-13",
    explanation:
        "Le faux témoignage suppose un témoignage sous serment ; les déclarations mensongères en préliminaire ou flagrance sans serment n’entrent pas dans le champ du texte.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Faux témoignage (omission volontaire, point essentiel)",
    question:
        "À l’audience d’un tribunal correctionnel, un témoin prête serment. Il affirme avoir vu la victime frapper l’auteur, mais s’abstient volontairement de préciser que l’auteur avait d’abord provoqué et frappé la victime. Cette omission altère l’appréciation de la légitime défense. On retient :",
    options: [
      "Pas de faux témoignage, car aucune affirmation inexacte",
      "Faux témoignage (434-13) par omission volontaire sur un point essentiel",
      "Simple manquement moral sans portée pénale",
    ],
    answer:
        "Faux témoignage (434-13) par omission volontaire sur un point essentiel",
    explanation:
        "Toute altération volontaire de la vérité sur des circonstances essentielles, y compris par omission, peut caractériser un faux témoignage.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (élément non déterminant)",
    question:
        "Sous serment, un témoin ment volontairement sur la couleur de la chemise d’un prévenu, élément qui n’a aucune incidence sur la solution du litige. On retient :",
    options: [
      "Faux témoignage (434-13) néanmoins constitué",
      "Pas de faux témoignage faute de caractère déterminant du mensonge",
      "Non-dénonciation de crime (434-1)",
    ],
    answer: "Pas de faux témoignage faute de caractère déterminant du mensonge",
    explanation:
        "La jurisprudence exige que le mensonge porte sur une circonstance présentant un intérêt dans l’affaire et susceptible d’influencer la décision du juge.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (erreur de bonne foi)",
    question:
        "Un témoin, très stressé, prête serment et indique une heure de commission des faits erronée, en toute bonne foi, sans intention de tromper. On retient :",
    options: [
      "Faux témoignage (434-13)",
      "Pas de faux témoignage, faute d’intention coupable",
      "Non-dénonciation de crime (434-1)",
    ],
    answer: "Pas de faux témoignage, faute d’intention coupable",
    explanation:
        "L’infraction est intentionnelle : elle suppose la conscience de mentir et le dessein de tromper ; l’erreur de bonne foi n’est pas punissable.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Faux témoignage (don d’argent, affaire délictuelle)",
    question:
        "Un témoin, sous serment devant le tribunal correctionnel, ment volontairement pour innocenter un ami poursuivi pour vol, en échange d’une somme d’argent. On retient :",
    options: [
      "Faux témoignage simple (434-13)",
      "Faux témoignage aggravé (434-14, 1°)",
      "Corruption passive uniquement",
    ],
    answer: "Faux témoignage aggravé (434-14, 1°)",
    explanation:
        "La remise d’un don ou d’une récompense en contrepartie du mensonge caractérise la circonstance aggravante de l’article 434-14, 1°.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (affaire criminelle, sans don)",
    question:
        "Un témoin mensonge sous serment devant la cour d’assises pour faire acquitter un accusé poursuivi pour assassinat, sans recevoir aucune contrepartie. On retient :",
    options: [
      "Faux témoignage simple (434-13)",
      "Faux témoignage aggravé (434-14, 2°)",
      "Non-dénonciation de crime (434-1)",
    ],
    answer: "Faux témoignage aggravé (434-14, 2°)",
    explanation:
        "Lorsque la personne en faveur ou à charge de laquelle le témoignage mensonger est commis est passible d’une peine criminelle, l’article 434-14, 2° aggrave la peine.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Faux témoignage (rétractation spontanée avant la décision)",
    question:
        "Une témoin ment sous serment devant un OPJ agissant sur commission rogatoire. Deux jours plus tard, avant toute ordonnance de non-lieu ou de renvoi, elle revient d’elle-même pour dire la vérité. On retient :",
    options: [
      "Le faux témoignage n’existe pas",
      "Le faux témoignage est constitué mais elle peut être exemptée de peine",
      "Le faux témoignage est constitué et aucune exemption n’est possible",
    ],
    answer:
        "Le faux témoignage est constitué mais elle peut être exemptée de peine",
    explanation:
        "L’article 434-13 prévoit l’exemption de peine en cas de rétractation spontanée avant la décision mettant fin à la procédure d’instruction ou de jugement.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (rétractation tardive)",
    question:
        "Un témoin ment sous serment à l’audience d’un tribunal correctionnel. Il ne se rétracte qu’après le prononcé du jugement définitif. On retient :",
    options: [
      "Exemption de peine pour rétractation",
      "Le faux témoignage demeure puni, la rétractation étant tardive",
      "Absence d’infraction faute de persistance du mensonge",
    ],
    answer: "Le faux témoignage demeure puni, la rétractation étant tardive",
    explanation:
        "La rétractation doit intervenir avant la décision mettant fin à la procédure ; au-delà, elle ne permet plus l’exemption prévue par l’article 434-13.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (subornation et complicité)",
    question:
        "Une personne fournit un faux récit à une prostituée et l’incite à le répéter sous serment devant un OPJ agissant sur commission rogatoire, afin de mettre en cause à tort des suspects passibles d’une peine criminelle. Elle obtient qu’elle mente effectivement. On retient pour la première personne :",
    options: [
      "Subornation de témoin uniquement",
      "Complicité de faux témoignage aggravé",
      "Aucune infraction tant que le juge n’est pas trompé",
    ],
    answer: "Complicité de faux témoignage aggravé",
    explanation:
        "La subornation peut se cumuler avec la complicité de faux témoignage lorsque le mensonge a effectivement été commis, et l’affaire est criminelle, ce qui aggrave la peine.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (tentative et complicité)",
    question:
        "Quel est le régime de la tentative et de la complicité de faux témoignage au regard de l’article 434-13 ?",
    options: [
      "La tentative est punissable, la complicité ne l’est pas",
      "La tentative n’est pas visée, mais la complicité est punissable",
      "Ni la tentative ni la complicité ne sont punissables",
    ],
    answer: "La tentative n’est pas visée, mais la complicité est punissable",
    explanation:
        "Le texte ne prévoit pas la tentative de faux témoignage, mais la complicité peut être retenue selon le droit commun, voire sous la qualification de subornation de témoin.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Théorie — Faux témoignage (personnes exclues)",
    question:
        "Parmi les personnes suivantes, laquelle ne peut, en principe, être poursuivie pour faux témoignage au sens de l’article 434-13 ?",
    options: [
      "Le mineur de moins de 16 ans qui ne prête pas serment",
      "Le simple témoin majeur assermenté à l’audience",
      "La partie civile, quand elle témoigne sous serment",
    ],
    answer: "Le mineur de moins de 16 ans qui ne prête pas serment",
    explanation:
        "Les mineurs de moins de 16 ans ne prêtent pas serment et ne peuvent donc, en principe, être poursuivis pour faux témoignage sur ce fondement.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (délit et non crime)",
    question:
        "Une personne apprend qu’un voisin a commis un vol simple, qualifié de délit, et qu’il pourrait recommencer. Elle se tait. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune non-dénonciation de crime, l’infraction n’étant pas un crime",
      "Complicité de vol",
    ],
    answer:
        "Aucune non-dénonciation de crime, l’infraction n’étant pas un crime",
    explanation:
        "L’article 434-1 vise exclusivement les crimes, et non les délits.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (dénonciation téléphonique anonyme)",
    question:
        "Une personne témoigne d’un crime en cours et appelle anonymement le 17 pour signaler les faits, sans décliner son identité. Elle raccroche aussitôt. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Dénonciation suffisante, absence de non-dénonciation",
      "Complicité de crime",
    ],
    answer: "Dénonciation suffisante, absence de non-dénonciation",
    explanation:
        "Le texte n’impose pas que le dénonciateur s’identifie ; seule compte l’information utile portée aux autorités.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (information imprécise mais utile)",
    question:
        "Un témoin appelle la gendarmerie et signale qu’un enlèvement vient de se produire sur une aire d’autoroute, sans autre détail. La police retrouve l’enfant grâce à cette alerte. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Dénonciation valable, même imprécise",
      "Complicité d’enlèvement",
    ],
    answer: "Dénonciation valable, même imprécise",
    explanation:
        "La dénonciation n’a pas à être complète ; elle doit seulement rendre possible l’intervention des autorités.",
    difficulty: "Facile",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Faux témoignage (commission d’enquête parlementaire)",
    question:
        "Un témoin, entendu sous serment devant une commission d’enquête parlementaire, ment sur un point essentiel. Peut-on retenir l’article 434-13 ?",
    options: [
      "Oui, la commission d’enquête est expressément assimilée à une juridiction",
      "Non, l’article 434-13 vise les juridictions et certains OPJ, pas les commissions d’enquête parlementaires",
      "Oui, mais uniquement si le témoin est fonctionnaire",
    ],
    answer:
        "Non, l’article 434-13 vise les juridictions et certains OPJ, pas les commissions d’enquête parlementaires",
    explanation:
        "Le texte cible ‘toute juridiction’ ou l’OPJ sur commission rogatoire ; la commission d’enquête parlementaire relève d’un autre régime.",
    difficulty: "Difficile",
  ),

  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (témoin assisté)",
    question:
        "Un témoin assisté, entendu par le juge d’instruction, ne prête pas serment. Il ment pour se protéger. On retient :",
    options: [
      "Faux témoignage (434-13)",
      "Pas de faux témoignage, absence de serment",
      "Non-dénonciation de crime (434-1)",
    ],
    answer: "Pas de faux témoignage, absence de serment",
    explanation:
        "Le témoin assisté n’est pas tenu de prêter serment et bénéficie de garanties proches de celles du mis en examen ; il ne peut être poursuivi pour faux témoignage sur ce fondement.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (juridiction administrative)",
    question:
        "Devant un tribunal administratif, un témoin prête serment et ment volontairement sur des faits essentiels à un contentieux de responsabilité de l’État. On retient :",
    options: [
      "Pas de faux témoignage car il ne s’agit pas d’une juridiction pénale",
      "Faux témoignage (434-13)",
      "Simple responsabilité civile",
    ],
    answer: "Faux témoignage (434-13)",
    explanation:
        "L’article 434-13 s’applique à toute juridiction, y compris administrative, dès lors qu’il y a serment et mensonge sur un point essentiel.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category:
        "Cas pratique — Non-dénonciation (information indirecte mais précise)",
    question:
        "Un individu apprend par confidences répétées et circonstanciées qu’un ami a commis un crime de viol sur une personne majeure et qu’il pourrait recommencer. Il choisit de ne pas appeler la police. On retient :",
    options: [
      "Non-dénonciation de crime (434-1)",
      "Aucune infraction car il n’a pas été témoin direct",
      "Complicité de viol",
    ],
    answer: "Non-dénonciation de crime (434-1)",
    explanation:
        "Le texte vise toute personne ayant connaissance d’un crime, même par récit indirect, dès lors que la dénonciation pourrait éviter de nouveaux crimes.",
    difficulty: "Moyenne",
  ),

  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation (participation au crime)",
    question:
        "Une personne participe au crime comme co-auteur puis s’abstient de le dénoncer. On envisage la non-dénonciation de crime à son encontre. On retient :",
    options: [
      "Elle peut être poursuivie pour non-dénonciation en plus de l’infraction principale",
      "Elle n’est pas tenue de se dénoncer elle-même au titre de 434-1",
      "Elle n’est responsable que de non-dénonciation",
    ],
    answer: "Elle n’est pas tenue de se dénoncer elle-même au titre de 434-1",
    explanation:
        "Celui qui a participé au crime n’est pas soumis à l’obligation de se dénoncer lui-même ; il répond d’abord de l’infraction principale.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (préliminaire)",
    question:
        "En audition libre en enquête préliminaire, une personne ment (sans serment). On retient :",
    options: [
      "Pas de faux témoignage au sens de 434-13",
      "Faux témoignage (434-13)",
      "Non-dénonciation (434-1)",
    ],
    answer: "Pas de faux témoignage au sens de 434-13",
    explanation:
        "Le cours : mensonges en préliminaire/flagrance non punissables au titre de 434-13.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Faux témoignage (commission rogatoire)",
    question:
        "Devant un OPJ agissant sur commission rogatoire, un témoin prête serment puis ment sur un point essentiel. On retient :",
    options: [
      "Faux témoignage (434-13)",
      "Non-dénonciation de crime (434-1)",
      "Aucune infraction",
    ],
    answer: "Faux témoignage (434-13)",
    explanation:
        "Conditions réunies : commission rogatoire + serment + altération volontaire de la vérité.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Définition",
    question:
        "La non-dénonciation de crime consiste, pour une personne ayant connaissance d’un crime, à :",
    options: [
      "Ne pas informer les autorités judiciaires ou administratives alors qu’il est encore possible de prévenir ou limiter les effets, ou d’empêcher de nouveaux crimes",
      "Ne pas dénoncer une contravention dans les 24h",
      "Refuser de témoigner en enquête de flagrance",
    ],
    answer:
        "Ne pas informer les autorités judiciaires ou administratives alors qu’il est encore possible de prévenir ou limiter les effets, ou d’empêcher de nouveaux crimes",
    explanation:
        "Le texte vise l’abstention d’informer les autorités lorsque la dénonciation peut être utile (prévenir/limiter/empêcher).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Texte",
    question: "Le délit de non-dénonciation de crime est prévu par :",
    options: [
      "Article 434-1 du Code pénal",
      "Article 434-13 du Code pénal",
      "Article 432-8 du Code pénal",
    ],
    answer: "Article 434-1 du Code pénal",
    explanation:
        "Le cours indique que l’article 434-1 prévoit et réprime le délit.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Nature des faits",
    question: "L’obligation de dénonciation concerne :",
    options: [
      "Les infractions de nature criminelle (crimes), quelle que soit leur nature",
      "Uniquement les délits",
      "Uniquement les contraventions",
    ],
    answer:
        "Les infractions de nature criminelle (crimes), quelle que soit leur nature",
    explanation:
        "Sont visées les infractions criminelles, sans distinction de type de crime.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Utilité de la dénonciation",
    question: "La dénonciation doit être :",
    options: [
      "Utile (prévenir/limiter les effets ou empêcher de nouveaux crimes)",
      "Obligatoire même si elle ne sert à rien",
      "Possible uniquement après jugement",
    ],
    answer:
        "Utile (prévenir/limiter les effets ou empêcher de nouveaux crimes)",
    explanation:
        "Le cours insiste : obligation liée aux crimes dont il est encore possible de prévenir/limiter ou d’empêcher des récidives criminelles.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Tentative de crime",
    question: "La non-dénonciation peut aussi concerner :",
    options: [
      "La tentative de crime",
      "Le simple projet criminel sans commencement d’exécution",
      "Uniquement les crimes consommés",
    ],
    answer: "La tentative de crime",
    explanation:
        "Le cours précise que l’incrimination est applicable à la tentative de crime, mais pas au simple projet sans commencement d’exécution.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Projet criminel",
    question: "Le simple projet criminel, sans commencement d’exécution, est :",
    options: [
      "Exclu du champ de la non-dénonciation",
      "Toujours visé par 434-1",
      "Visé uniquement si le crime est contre un mineur",
    ],
    answer: "Exclu du champ de la non-dénonciation",
    explanation:
        "Le cours indique : pas d’obligation au stade du simple projet criminel sans commencement d’exécution.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Infraction d’omission",
    question: "La non-dénonciation de crime est :",
    options: [
      "Une infraction d’omission (abstention de dénonciation)",
      "Une infraction de commission",
      "Une contravention",
    ],
    answer: "Une infraction d’omission (abstention de dénonciation)",
    explanation:
        "Le cours précise : infraction d’omission, l’individu pouvait avertir et ne l’a pas fait.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Autorités compétentes",
    question: "Peut recevoir une dénonciation au sens du cours :",
    options: [
      "Toute autorité susceptible de mesurer l’importance de l’information et d’y donner suite",
      "Uniquement le procureur de la République",
      "Uniquement un juge d’instruction",
    ],
    answer:
        "Toute autorité susceptible de mesurer l’importance de l’information et d’y donner suite",
    explanation:
        "Le cours vise ministère public, police, gendarmerie… et toute autorité utile.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Exemples d’autorités",
    question:
        "Parmi les autorités mentionnées comme pouvant recevoir l’information :",
    options: [
      "Le ministère public, les fonctionnaires de police, la gendarmerie nationale",
      "Uniquement l’avocat de la victime",
      "Uniquement un journaliste",
    ],
    answer:
        "Le ministère public, les fonctionnaires de police, la gendarmerie nationale",
    explanation: "Le cours donne ces exemples d’autorités susceptibles d’agir.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category:
        "Non-dénonciation de crime — Personne intervenant pour leur compte",
    question: "La jurisprudence admet que la dénonciation peut être faite :",
    options: [
      "Auprès de toute personne intervenant pour le compte des autorités",
      "Uniquement en main propre au procureur",
      "Uniquement par écrit recommandé",
    ],
    answer: "Auprès de toute personne intervenant pour le compte des autorités",
    explanation:
        "Le cours indique que la dénonciation peut être faite à une personne qui intervient pour le compte des autorités.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Objet de l’information",
    question: "L’information donnée doit porter :",
    options: [
      "Sur l’existence des faits (le crime) et non nécessairement sur l’identité de l’auteur",
      "Uniquement sur l’identité de l’auteur",
      "Uniquement sur le lieu de résidence du suspect",
    ],
    answer:
        "Sur l’existence des faits (le crime) et non nécessairement sur l’identité de l’auteur",
    explanation:
        "Cass. crim., 26 février 1959 : obligation de dénoncer le crime, pas l’identité ou le refuge des auteurs.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Modalités",
    question: "Les modalités de dénonciation sont :",
    options: [
      "Libres (toutes modalités admissibles)",
      "Uniquement écrites",
      "Uniquement via dépôt de plainte",
    ],
    answer: "Libres (toutes modalités admissibles)",
    explanation:
        "Le cours indique : toutes modalités de dénonciation sont admissibles.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Finalité",
    question: "L’objectif de la dénonciation est de :",
    options: [
      "Prévenir un trouble à l’ordre public et prévenir/limiter les effets du crime",
      "Remplacer l’enquête judiciaire",
      "Garantir une condamnation automatique",
    ],
    answer:
        "Prévenir un trouble à l’ordre public et prévenir/limiter les effets du crime",
    explanation:
        "Le cours insiste sur la prévention du trouble et la limitation/empêchement.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Nouveaux crimes",
    question: "La dénonciation peut être utile pour :",
    options: [
      "Éviter la commission de nouveaux crimes (notamment via l’identification des auteurs)",
      "Uniquement punir moralement l’auteur",
      "Uniquement réparer le préjudice civil",
    ],
    answer:
        "Éviter la commission de nouveaux crimes (notamment via l’identification des auteurs)",
    explanation:
        "Le cours mentionne l’objectif d’empêcher de nouveaux crimes, notamment par l’identification.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Élément moral",
    question: "L’élément moral suppose :",
    options: [
      "S’abstenir volontairement de dénoncer un crime dont on a connaissance",
      "Une imprudence",
      "Une simple rumeur",
    ],
    answer:
        "S’abstenir volontairement de dénoncer un crime dont on a connaissance",
    explanation:
        "Le cours : intention déduite de la connaissance du crime et de l’absence de dénonciation.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Mobile",
    question: "Le mobile expliquant l’abstention :",
    options: [
      "Importe peu",
      "Écarte l’infraction s’il est honorable",
      "Aggrave toujours la peine",
    ],
    answer: "Importe peu",
    explanation: "Le cours précise que le mobile importe peu.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Jurisprudence (preuve des éléments)",
    question: "La Cour de cassation impose aux juges du fond :",
    options: [
      "De constater l’existence de l’infraction dans tous ses éléments",
      "De présumer l’infraction dès qu’un crime existe",
      "De ne vérifier que l’élément moral",
    ],
    answer: "De constater l’existence de l’infraction dans tous ses éléments",
    explanation:
        "Cass. crim., 17 avril 1956 : exigence de caractérisation de tous les éléments.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 434-1 — EXCEPTIONS / IMMUNITÉS
  // =========================================================
  const QuizQuestion(
    category: "Non-dénonciation de crime — Immunité familiale",
    question: "L’immunité familiale prévue par 434-1 s’applique :",
    options: [
      "Aux proches de l’auteur/complice, sauf pour les crimes commis sur les mineurs",
      "À tous les amis de l’auteur",
      "À toute personne vivant dans le même quartier",
    ],
    answer:
        "Aux proches de l’auteur/complice, sauf pour les crimes commis sur les mineurs",
    explanation:
        "Le texte exclut l’immunité familiale lorsque les crimes sont commis sur les mineurs.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Proches concernés",
    question: "Sont visés par l’immunité familiale (434-1) :",
    options: [
      "Parents en ligne directe et leurs conjoints ; frères/sœurs et leurs conjoints ; conjoint/concubin/partenaire de PACS",
      "Uniquement les parents en ligne directe",
      "Uniquement le conjoint marié",
    ],
    answer:
        "Parents en ligne directe et leurs conjoints ; frères/sœurs et leurs conjoints ; conjoint/concubin/partenaire de PACS",
    explanation:
        "Le cours liste précisément ces proches et inclut concubin/PACS.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Crimes sur mineurs",
    question: "Concernant les crimes commis sur les mineurs :",
    options: [
      "L’immunité familiale ne s’applique pas",
      "L’immunité familiale s’applique toujours",
      "Seul le secret professionnel s’applique",
    ],
    answer: "L’immunité familiale ne s’applique pas",
    explanation:
        "Le cours indique : immunité familiale OUI sauf crimes commis sur mineurs.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Secret professionnel",
    question: "Les personnes astreintes au secret professionnel :",
    options: [
      "Sont exemptées de l’obligation de dénonciation (226-13)",
      "Doivent toujours dénoncer tout crime",
      "Ne peuvent jamais dénoncer un crime",
    ],
    answer: "Sont exemptées de l’obligation de dénonciation (226-13)",
    explanation:
        "Le cours précise l’exemption liée au secret professionnel (226-13).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Participant au crime",
    question: "Celui qui a participé au crime :",
    options: [
      "Est également excepté de l’obligation de dénonciation",
      "Doit dénoncer sous peine d’aggravation",
      "Bénéficie d’une immunité uniquement si mineur",
    ],
    answer: "Est également excepté de l’obligation de dénonciation",
    explanation:
        "Le cours indique expressément que le participant est excepté.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 434-2 — CIRCONSTANCES AGGRAVANTES (NON-DÉNONCIATION)
  // =========================================================
  const QuizQuestion(
    category: "Non-dénonciation de crime — Aggravation",
    question:
        "La circonstance aggravante de la non-dénonciation est prévue par :",
    options: [
      "Article 434-2 du Code pénal",
      "Article 434-14 du Code pénal",
      "Article 434-15 du Code pénal",
    ],
    answer: "Article 434-2 du Code pénal",
    explanation:
        "Le cours : aggravation lorsque le crime non dénoncé porte sur intérêts fondamentaux de la Nation ou terrorisme.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Crimes concernés (434-2)",
    question: "L’aggravation 434-2 vise notamment :",
    options: [
      "Atteintes aux intérêts fondamentaux de la Nation ou actes de terrorisme",
      "Tous les délits routiers",
      "Les contraventions de tapage",
    ],
    answer:
        "Atteintes aux intérêts fondamentaux de la Nation ou actes de terrorisme",
    explanation: "Le cours cite trahison, espionnage, attentat, etc.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Immunité et 434-2",
    question: "En cas de 434-2, les dispositions d’immunité familiale :",
    options: [
      "Ne sont pas applicables",
      "Restent applicables",
      "S’appliquent uniquement aux conjoints",
    ],
    answer: "Ne sont pas applicables",
    explanation:
        "Le cours précise : en 434-2, l’immunité familiale de 434-1 ne s’applique pas.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Peines (simple)",
    question: "Peines encourues (434-1 al.1) :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Répression indiquée par le cours pour la forme simple.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Peines (aggravée)",
    question: "Peines encourues en cas d’application de 434-2 :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Répression aggravée indiquée par le cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Personnes morales",
    question: "Les personnes morales :",
    options: [
      "Peuvent être pénalement responsables (121-2)",
      "Ne peuvent jamais être responsables",
      "Sont responsables uniquement en contravention",
    ],
    answer: "Peuvent être pénalement responsables (121-2)",
    explanation:
        "Le cours précise la responsabilité pénale des personnes morales.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Tentative",
    question: "La tentative de non-dénonciation de crime est :",
    options: [
      "Non incriminée",
      "Incriminée",
      "Incriminée uniquement en cas de terrorisme",
    ],
    answer: "Non incriminée",
    explanation: "Le cours précise : TENTATIVE : NON.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Complicité",
    question: "La complicité de non-dénonciation est :",
    options: [
      "Punissable (121-6 et 121-7)",
      "Impossible",
      "Punissable uniquement si l’auteur est un professionnel de santé",
    ],
    answer: "Punissable (121-6 et 121-7)",
    explanation:
        "Le cours : complicité possible, notamment celui qui incite à ne pas dénoncer.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Non-dénonciation de crime — Exemple de complicité",
    question: "Peut se rendre complice :",
    options: [
      "Celui qui incite l’auteur à ne pas dénoncer le crime dont il a été témoin",
      "Celui qui dénonce trop tard",
      "Celui qui transmet l’information aux autorités",
    ],
    answer:
        "Celui qui incite l’auteur à ne pas dénoncer le crime dont il a été témoin",
    explanation: "Exemple explicitement cité dans le cours.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 434-13 — FAUX TÉMOIGNAGE / TÉMOIGNAGE MENSONGER (PRINCIPES)
  // =========================================================
  const QuizQuestion(
    category: "Faux témoignage — Définition",
    question: "Le témoignage mensonger consiste en :",
    options: [
      "Un témoignage mensonger fait sous serment devant une juridiction ou devant un OPJ agissant sur commission rogatoire",
      "Un mensonge en enquête de flagrance",
      "Une dénonciation calomnieuse",
    ],
    answer:
        "Un témoignage mensonger fait sous serment devant une juridiction ou devant un OPJ agissant sur commission rogatoire",
    explanation:
        "Définition donnée : mensonge sous serment, juridiction ou OPJ sur commission rogatoire.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Texte",
    question: "Le délit de faux témoignage est réprimé par :",
    options: [
      "Article 434-13 du Code pénal",
      "Article 434-1 du Code pénal",
      "Article 432-9 du Code pénal",
    ],
    answer: "Article 434-13 du Code pénal",
    explanation: "Le cours : défini et réprimé par l’article 434-13 C.P.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Où ?",
    question: "Le faux témoignage est punissable s’il est fait :",
    options: [
      "Devant une juridiction ou devant un OPJ en exécution d’une commission rogatoire",
      "Devant un OPJ en enquête préliminaire",
      "Devant un ami témoin",
    ],
    answer:
        "Devant une juridiction ou devant un OPJ en exécution d’une commission rogatoire",
    explanation:
        "Le cours exclut les mensonges en enquête préliminaire/flagrance (hors commission rogatoire).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Juridiction (sens large)",
    question: "Le terme « juridiction » doit être compris :",
    options: [
      "Au sens large : pénale, civile, administrative, financière, instruction, jugement, etc.",
      "Uniquement pénale",
      "Uniquement civile",
    ],
    answer:
        "Au sens large : pénale, civile, administrative, financière, instruction, jugement, etc.",
    explanation: "Le cours précise le caractère général du terme juridiction.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Enquête préliminaire/flagrance",
    question:
        "Des déclarations mensongères en enquête préliminaire ou de flagrance :",
    options: [
      "Ne sont pas punissables au titre du faux témoignage",
      "Sont toujours punissables au titre de 434-13",
      "Sont punissables seulement si elles sont écrites",
    ],
    answer: "Ne sont pas punissables au titre du faux témoignage",
    explanation:
        "Le cours : faux témoignage punissable en justice ou CR ; pas en préliminaire/flagrance.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Condition du serment",
    question: "Le faux témoignage suppose :",
    options: [
      "Un témoignage fait sous la foi du serment",
      "Un simple mensonge sans serment",
      "Un mensonge par SMS",
    ],
    answer: "Un témoignage fait sous la foi du serment",
    explanation:
        "Le mensonge ne suffit pas : il faut la violation d’un serment.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Formule du serment",
    question: "Le serment consiste à promettre :",
    options: [
      "De dire la vérité, toute la vérité",
      "De dire ce dont on se souvient vaguement",
      "De ne pas incriminer un proche",
    ],
    answer: "De dire la vérité, toute la vérité",
    explanation: "Formule indiquée : vérité, toute la vérité.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Mineurs",
    question: "Le faux témoignage ne peut être retenu contre :",
    options: [
      "Les mineurs de moins de 16 ans (serment non exigé)",
      "Tout mineur quel que soit l’âge",
      "Uniquement les mineurs de moins de 13 ans",
    ],
    answer: "Les mineurs de moins de 16 ans (serment non exigé)",
    explanation:
        "Le cours précise : pas de serment exigé avant 16 ans → pas de faux témoignage.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Incapacité de témoigner",
    question: "Le faux témoignage ne peut viser :",
    options: [
      "Les personnes interdites de témoigner autrement que pour simples déclarations",
      "Toute personne majeure",
      "Tout témoin sans exception",
    ],
    answer:
        "Les personnes interdites de témoigner autrement que pour simples déclarations",
    explanation:
        "Le cours mentionne les incapacités, notamment l’interdiction de témoigner.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Personnes au statut particulier",
    question:
        "Parmi les personnes dont le statut peut empêcher le faux témoignage :",
    options: [
      "La partie civile, le témoin assisté, etc.",
      "Le procureur",
      "Le greffier",
    ],
    answer: "La partie civile, le témoin assisté, etc.",
    explanation:
        "Le cours cite des incapacités liées au statut (intérêt au litige, témoin assisté…).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Garde à vue sur commission rogatoire",
    question:
        "La personne entendue par l’OPJ en commission rogatoire sous le régime de la garde à vue :",
    options: [
      "Ne peut pas être poursuivie pour faux témoignage car elle ne prête pas serment",
      "Prête serment comme un témoin",
      "Est automatiquement condamnable",
    ],
    answer:
        "Ne peut pas être poursuivie pour faux témoignage car elle ne prête pas serment",
    explanation:
        "Le cours : le suspect en GAV n’est pas tenu de prêter serment (droit de ne pas s’auto-incriminer).",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 434-13 — CARACTÉRISATION DU MENSONGE
  // =========================================================
  const QuizQuestion(
    category: "Faux témoignage — Altération de la vérité",
    question: "Le faux témoignage consiste en :",
    options: [
      "Toute altération sciemment faite de la vérité",
      "Uniquement un mensonge écrit",
      "Uniquement une contradiction",
    ],
    answer: "Toute altération sciemment faite de la vérité",
    explanation:
        "Le code n’énumère pas : toute altération sciemment faite de la vérité est incriminée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Infraction de commission",
    question: "Le faux témoignage est une infraction de :",
    options: ["Commission (acte positif)", "Omission", "Négligence"],
    answer: "Commission (acte positif)",
    explanation:
        "Le cours : acte positif requis. Refus de comparaître/de déposer ≠ faux témoignage.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Refus de déposer",
    question: "Le refus de comparaître ou de déposer :",
    options: [
      "Ne peut pas être assimilé à un faux témoignage",
      "Constitue toujours un faux témoignage",
      "Constitue une tentative de faux témoignage",
    ],
    answer: "Ne peut pas être assimilé à un faux témoignage",
    explanation:
        "Le cours : refus ≠ faux témoignage (infraction de commission).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Mensonge par affirmation",
    question: "Le faux témoignage peut consister en :",
    options: [
      "L’affirmation d’un fait inexact",
      "Uniquement une omission",
      "Uniquement un silence total",
    ],
    answer: "L’affirmation d’un fait inexact",
    explanation:
        "Le cours cite l’affirmation d’un fait inexact comme forme classique.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Mensonge par négation",
    question: "Constitue un faux témoignage le fait :",
    options: [
      "De nier un fait véritable (dire ne pas savoir alors qu’on sait)",
      "De répondre trop vite",
      "De se tromper de date par émotion",
    ],
    answer: "De nier un fait véritable (dire ne pas savoir alors qu’on sait)",
    explanation:
        "Le cours : le témoin qui déclare ne pas savoir alors qu’il sait tombe sous le coup de la loi pénale.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Mensonge par omission",
    question: "Le mensonge peut être réalisé par omission lorsque :",
    options: [
      "Le témoin garde le silence sur un point déterminé ou donne une réponse partielle dénaturant les faits",
      "Le témoin oublie involontairement",
      "Le témoin refuse de signer",
    ],
    answer:
        "Le témoin garde le silence sur un point déterminé ou donne une réponse partielle dénaturant les faits",
    explanation:
        "Le cours admet l’omission lorsque la présentation incomplète dénature les faits.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Déclarations déterminantes",
    question: "Le faux témoignage n’est punissable que si :",
    options: [
      "Il porte sur des déclarations pouvant avoir une incidence sur la solution du procès",
      "Il porte sur n’importe quel détail sans intérêt",
      "Il est fait en dehors de toute procédure",
    ],
    answer:
        "Il porte sur des déclarations pouvant avoir une incidence sur la solution du procès",
    explanation:
        "Analyse jurisprudentielle : le témoignage doit être déterminant (incidence sur la solution).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Circonstances essentielles",
    question: "Pour être déterminant, le mensonge doit porter :",
    options: [
      "Sur des circonstances essentielles du fait ayant donné lieu au litige",
      "Uniquement sur l’état civil d’un témoin",
      "Uniquement sur des éléments sans lien avec l’affaire",
    ],
    answer:
        "Sur des circonstances essentielles du fait ayant donné lieu au litige",
    explanation:
        "Le cours cite : altération volontaire portant sur circonstances essentielles.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Élément moral",
    question: "L’infraction de faux témoignage est :",
    options: [
      "Intentionnelle (mauvaise foi, conscience de mentir et de trahir le serment)",
      "Non intentionnelle",
      "Une infraction d’imprudence",
    ],
    answer:
        "Intentionnelle (mauvaise foi, conscience de mentir et de trahir le serment)",
    explanation:
        "Le cours : mensonge intentionnel, volonté délibérée de tromper la justice.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Erreur / inattention",
    question: "Le témoin qui se trompe de bonne foi :",
    options: [
      "N’est pas punissable au titre du faux témoignage",
      "Est toujours punissable",
      "Est punissable uniquement si le juge le décide",
    ],
    answer: "N’est pas punissable au titre du faux témoignage",
    explanation:
        "Le cours : la loi ne punit pas l’erreur de bonne foi, mais le mensonge volontaire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Mobile",
    question: "Le mobile du faux témoin :",
    options: [
      "Est indifférent",
      "Écarte toujours l’infraction",
      "Aggrave automatiquement la peine",
    ],
    answer: "Est indifférent",
    explanation: "Le cours précise : caractérisée quel que soit le mobile.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 434-14 — CIRCONSTANCES AGGRAVANTES (FAUX TÉMOIGNAGE)
  // =========================================================
  const QuizQuestion(
    category: "Faux témoignage — Aggravation (don/récompense)",
    question: "Le faux témoignage est aggravé lorsque :",
    options: [
      "Il est provoqué par la remise d’un don ou d’une récompense quelconque",
      "Il est prononcé trop vite",
      "Il est fait sans émotion",
    ],
    answer:
        "Il est provoqué par la remise d’un don ou d’une récompense quelconque",
    explanation: "Article 434-14 1° : don/récompense quelconque.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Récompense quelconque",
    question: "La notion de « récompense quelconque » est interprétée comme :",
    options: [
      "Toute contrepartie ayant un impact sur le témoignage",
      "Uniquement une somme d’argent",
      "Uniquement un cadeau matériel",
    ],
    answer: "Toute contrepartie ayant un impact sur le témoignage",
    explanation:
        "Le cours : toute contrepartie déterminant le témoignage mensonger.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Aggravation (peine criminelle)",
    question: "Le faux témoignage est aggravé lorsque :",
    options: [
      "La personne contre laquelle ou en faveur de laquelle il est commis est passible d’une peine criminelle",
      "La personne est passible d’une amende seulement",
      "Le témoin est stressé",
    ],
    answer:
        "La personne contre laquelle ou en faveur de laquelle il est commis est passible d’une peine criminelle",
    explanation: "Article 434-14 2° : passible d’une peine criminelle.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Peines (simple)",
    question: "Peines encourues pour le faux témoignage simple (434-13) :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Répression indiquée dans le cours (forme simple).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Peines (aggravé)",
    question: "Peines encourues pour le faux témoignage aggravé (434-14) :",
    options: [
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "7 ans d’emprisonnement et 100 000 € d’amende",
    explanation: "Répression indiquée pour les formes aggravées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Tentative",
    question: "La tentative de faux témoignage est :",
    options: [
      "Non incriminée",
      "Incriminée",
      "Incriminée uniquement en assises",
    ],
    answer: "Non incriminée",
    explanation: "Le cours précise : TENTATIVE : NON.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Complicité",
    question: "La complicité de faux témoignage est :",
    options: [
      "Punissable (121-6 et 121-7) et peut se confondre avec la subornation de témoin",
      "Impossible",
      "Punissable uniquement si le témoin est mineur",
    ],
    answer:
        "Punissable (121-6 et 121-7) et peut se confondre avec la subornation de témoin",
    explanation:
        "Le cours : complicité possible ; peut se confondre avec subornation (434-15).",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 434-13 al.2 — RÉTRACTATION / EXEMPTION DE PEINE
  // =========================================================
  const QuizQuestion(
    category: "Faux témoignage — Rétractation",
    question: "Le faux témoin est exempt de peine s’il :",
    options: [
      "A rétracté spontanément son témoignage avant la décision mettant fin à la procédure",
      "A rétracté après la condamnation",
      "A rétracté uniquement sur demande du juge",
    ],
    answer:
        "A rétracté spontanément son témoignage avant la décision mettant fin à la procédure",
    explanation:
        "434-13 al.2 : exemption si rétractation spontanée avant décision de fin de procédure.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Spontanéité",
    question: "N’est pas considérée comme spontanée :",
    options: [
      "La rétractation à la demande du juge d’instruction",
      "La rétractation sans pression",
      "La rétractation immédiate de l’initiative du témoin",
    ],
    answer: "La rétractation à la demande du juge d’instruction",
    explanation: "Le cours : rétractation à la demande du juge ≠ spontanée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Rétractation après mise en examen",
    question: "N’est pas spontanée :",
    options: [
      "La rétractation intervenue après la mise en examen du faux témoin",
      "La rétractation immédiate",
      "La rétractation avant toute poursuite",
    ],
    answer: "La rétractation intervenue après la mise en examen du faux témoin",
    explanation: "Le cours cite ce cas comme non spontané.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Effet de la rétractation",
    question: "La rétractation :",
    options: [
      "N’efface pas l’infraction, mais permet l’exemption de peine",
      "Supprime l’infraction",
      "Aggrave la peine",
    ],
    answer: "N’efface pas l’infraction, mais permet l’exemption de peine",
    explanation:
        "Le témoin reste coupable mais n’est pas condamné à une peine.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Moment limite",
    question:
        "En jurisprudence, la limite au-delà de laquelle la rétractation est tardive est :",
    options: [
      "La clôture des débats",
      "L’ouverture de l’audience",
      "Le dépôt de plainte",
    ],
    answer: "La clôture des débats",
    explanation:
        "Le cours indique que la clôture des débats marque traditionnellement la limite.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Délit aggravé et rétractation",
    question: "La rétractation/exemption :",
    options: [
      "Peut logiquement s’appliquer aussi au faux témoignage aggravé",
      "Ne s’applique jamais au faux témoignage aggravé",
      "S’applique uniquement aux mineurs",
    ],
    answer: "Peut logiquement s’appliquer aussi au faux témoignage aggravé",
    explanation:
        "Le cours indique qu’il semble logique d’appliquer l’exemption aussi à l’aggravé.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Faux témoignage — Définition de la rétractation",
    question: "Une rétractation est :",
    options: [
      "Toute manifestation de repentir suffisamment significative pour effacer le mensonge",
      "Une simple excuse",
      "Une justification du mensonge",
    ],
    answer:
        "Toute manifestation de repentir suffisamment significative pour effacer le mensonge",
    explanation:
        "Le cours : toute manifestation suffisamment significative, avec caractère spontané.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // MINI-CAS / PIÈGES (MIXTE) — ACTION DE LA JUSTICE
  // =========================================================
  const QuizQuestion(
    category: "Cas pratique — Non-dénonciation",
    question:
        "Une personne sait qu’un crime est en cours de préparation (commencement d’exécution), et la dénonciation peut empêcher le passage à l’acte. Elle se tait. On retient :",
    options: [
      "La non-dénonciation de crime (434-1)",
      "Le faux témoignage (434-13)",
      "Aucune infraction possible",
    ],
    answer: "La non-dénonciation de crime (434-1)",
    explanation:
        "Le cours : applicable aux crimes encore évitables ou limitables, y compris tentative.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Projet criminel",
    question:
        "Une personne entend un voisin parler d’un « projet » de crime, sans commencement d’exécution. Elle ne dit rien. Selon le cours :",
    options: [
      "434-1 ne s’applique pas (simple projet sans commencement d’exécution)",
      "434-1 s’applique toujours",
      "On retient 434-13",
    ],
    answer:
        "434-1 ne s’applique pas (simple projet sans commencement d’exécution)",
    explanation:
        "Le cours exclut le simple projet criminel non suivi d’un commencement d’exécution.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — Faux témoignage et enquête",
    question:
        "Une personne ment en audition libre en enquête préliminaire, sans serment. On retient :",
    options: [
      "Pas de faux témoignage au sens de 434-13",
      "Faux témoignage (434-13)",
      "Non-dénonciation (434-1)",
    ],
    answer: "Pas de faux témoignage au sens de 434-13",
    explanation:
        "Le cours : les déclarations mensongères en préliminaire/flagrance ne sont pas punissables au titre du faux témoignage.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Cas pratique — OPJ commission rogatoire",
    question:
        "Une personne ment sous serment devant un OPJ agissant sur commission rogatoire. On retient :",
    options: [
      "Faux témoignage (434-13)",
      "Non-dénonciation (434-1)",
      "Aucune infraction",
    ],
    answer: "Faux témoignage (434-13)",
    explanation:
        "Le faux témoignage est punissable devant l’OPJ en exécution d’une commission rogatoire.",
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
  const QuizQuestion(
    category: "Inviolabilité du domicile — Définition",
    question:
        "Constitue une atteinte à l’inviolabilité du domicile le fait, par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public, de :",
    options: [
      "S’introduire ou tenter de s’introduire dans le domicile d’autrui contre le gré de l’occupant hors les cas prévus par la loi",
      "Se maintenir dans le domicile d’autrui après une invitation",
      "Refuser d’ouvrir la porte à l’occupant",
    ],
    answer:
        "S’introduire ou tenter de s’introduire dans le domicile d’autrui contre le gré de l’occupant hors les cas prévus par la loi",
    explanation:
        "L’article vise l’introduction ou la tentative d’introduction, contre le gré, hors les cas légaux.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Texte",
    question:
        "L’infraction d’atteinte à l’inviolabilité du domicile est prévue par :",
    options: [
      "Article 432-8 du Code pénal",
      "Article 432-9 du Code pénal",
      "Article 432-7 du Code pénal",
    ],
    answer: "Article 432-8 du Code pénal",
    explanation:
        "Le cours indique que l’infraction est prévue et réprimée par l’article 432-8 C.P.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Auteur",
    question: "Peut être auteur de l’infraction (432-8) :",
    options: [
      "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
      "Tout particulier sans qualité",
      "Uniquement un magistrat",
    ],
    answer:
        "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
    explanation: "L’infraction vise spécifiquement ces qualités.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Dépositaire autorité publique",
    question: "Est dépositaire de l’autorité publique celui qui :",
    options: [
      "Dispose d’un pouvoir de décision fondé sur une parcelle de l’autorité publique conférée par ses fonctions",
      "Réalise une mission d’intérêt général sans pouvoir de décision",
      "Est uniquement salarié d’une entreprise privée",
    ],
    answer:
        "Dispose d’un pouvoir de décision fondé sur une parcelle de l’autorité publique conférée par ses fonctions",
    explanation:
        "Définition donnée : pouvoir de décision lié à l’autorité publique conférée par les fonctions.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Exemples",
    question:
        "Parmi les personnes citées comme dépositaires de l’autorité publique, on retrouve notamment :",
    options: [
      "Policiers et gendarmes",
      "Agents immobiliers",
      "Livreurs privés",
    ],
    answer: "Policiers et gendarmes",
    explanation:
        "Le cours cite policiers, gendarmes, douaniers, huissiers, etc.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Mission de service public",
    question: "Est chargé d’une mission de service public celui qui :",
    options: [
      "Accomplit un service public quelconque à titre temporaire ou permanent, volontairement ou sur réquisition",
      "A toujours un pouvoir de commandement",
      "Exerce obligatoirement une fonction militaire",
    ],
    answer:
        "Accomplit un service public quelconque à titre temporaire ou permanent, volontairement ou sur réquisition",
    explanation: "Définition textuelle du cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Contexte d’action",
    question: "Pour que 432-8 soit constitué, l’auteur doit agir :",
    options: [
      "Dans l’exercice ou à l’occasion de l’exercice de ses fonctions ou de sa mission",
      "Uniquement en dehors de toute fonction",
      "Seulement pendant ses congés",
    ],
    answer:
        "Dans l’exercice ou à l’occasion de l’exercice de ses fonctions ou de sa mission",
    explanation: "Condition explicitement mentionnée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Abus de qualité",
    question:
        "L’auteur doit avoir abusé de sa qualité pour pénétrer au domicile, ce qui exclut :",
    options: [
      "Une violation de domicile pour des raisons personnelles",
      "Une action réalisée pendant une mission",
      "Une action en lien avec ses attributions",
    ],
    answer: "Une violation de domicile pour des raisons personnelles",
    explanation: "Le cours indique que les raisons personnelles sont exclues.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Notion de domicile",
    question: "Le domicile est :",
    options: [
      "Le lieu où une personne a le droit de se dire chez elle, qu’elle y habite ou non",
      "Uniquement le domicile légal déclaré",
      "Uniquement un lieu dont on est propriétaire",
    ],
    answer:
        "Le lieu où une personne a le droit de se dire chez elle, qu’elle y habite ou non",
    explanation: "Définition du cours : droit de se dire chez soi.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Étendue",
    question: "Peuvent entrer dans la notion de domicile :",
    options: [
      "Résidence, lieu de séjour occasionnel, domicile légal",
      "Uniquement une résidence principale occupée en permanence",
      "Uniquement un logement meublé et habité",
    ],
    answer: "Résidence, lieu de séjour occasionnel, domicile légal",
    explanation: "Le cours étend la notion à résidence et séjour occasionnel.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Logements inoccupés",
    question: "Un logement inoccupé peut être considéré comme un domicile si :",
    options: [
      "Il contient des meubles traduisant une occupation effective (table, chaises, lit, etc.)",
      "Il contient uniquement une bicyclette",
      "Il est vide mais la porte est fermée",
    ],
    answer:
        "Il contient des meubles traduisant une occupation effective (table, chaises, lit, etc.)",
    explanation:
        "Le cours précise que des meubles caractérisant l’occupation peuvent suffire selon appréciation du juge.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Dépendances",
    question: "Le domicile comprend aussi :",
    options: [
      "Les dépendances (caves, terrasses, etc.)",
      "Uniquement les pièces principales",
      "Uniquement l’entrée",
    ],
    answer: "Les dépendances (caves, terrasses, etc.)",
    explanation: "Le cours vise l’habitation avec ses dépendances.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Cours/Jardins",
    question:
        "Cours, jardins et parcs sont assimilés au domicile lorsqu’ils sont :",
    options: [
      "Clos et attenants à l’habitation",
      "Toujours assimilés",
      "Jamais assimilés",
    ],
    answer: "Clos et attenants à l’habitation",
    explanation: "Condition explicitement mentionnée (clos + attenants).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Proximité",
    question: "Pour une dépendance, la jurisprudence exige :",
    options: [
      "Un lien étroit et immédiat + proximité avec l’habitation",
      "Aucune condition, toute dépendance suffit",
      "Uniquement que ce soit dans la même commune",
    ],
    answer: "Un lien étroit et immédiat + proximité avec l’habitation",
    explanation: "Le cours insiste sur l’annexe au domicile et la proximité.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Acte matériel",
    question: "L’action incriminée au 432-8 est :",
    options: [
      "L’introduction ou la tentative d’introduction dans un domicile",
      "Le maintien dans un domicile",
      "La surveillance du domicile depuis la voie publique",
    ],
    answer: "L’introduction ou la tentative d’introduction dans un domicile",
    explanation: "Le texte précise que le maintien n’est pas visé.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Consentement",
    question:
        "L’article 432-8 réprime l’introduction seulement si elle est effectuée :",
    options: [
      "Contre le gré de l’occupant",
      "Avec consentement",
      "Uniquement de nuit",
    ],
    answer: "Contre le gré de l’occupant",
    explanation: "Condition : contre le gré, sinon pas d’infraction.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Consentement vicié",
    question: "Le consentement de l’occupant ne doit pas être vicié par :",
    options: [
      "Des manœuvres/stratagèmes policiers",
      "Une demande écrite",
      "Une invitation orale",
    ],
    answer: "Des manœuvres/stratagèmes policiers",
    explanation: "Le cours mentionne le consentement vicié par stratagèmes.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — À l’insu",
    question: "L’absence de consentement englobe le fait de pénétrer :",
    options: [
      "À l’insu de l’occupant",
      "Uniquement après refus écrit",
      "Uniquement avec violence",
    ],
    answer: "À l’insu de l’occupant",
    explanation:
        "Le cours cite l’exemple de pénétrer à l’insu (fenêtre ouverte).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Cas légaux",
    question: "Le 432-8 sanctionne l’introduction lorsqu’elle est faite :",
    options: [
      "Hors les cas permis par la loi",
      "Même lorsqu’un texte autorise l’entrée",
      "Uniquement en cas d’urgence médicale",
    ],
    answer: "Hors les cas permis par la loi",
    explanation: "Le texte vise uniquement les introductions hors cas légaux.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Élément moral",
    question: "L’élément moral du 432-8 suppose :",
    options: [
      "La conscience de pénétrer irrégulièrement au domicile d’autrui",
      "Une intention de nuire obligatoire",
      "L’accord écrit de l’occupant",
    ],
    answer: "La conscience de pénétrer irrégulièrement au domicile d’autrui",
    explanation: "Conscience de l’irrégularité des agissements.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Circonstances aggravantes",
    question: "Pour l’infraction 432-8, les circonstances aggravantes sont :",
    options: ["Aucune", "Toujours présentes", "Uniquement si violence"],
    answer: "Aucune",
    explanation: "Le cours indique : AUCUNE.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Répression",
    question: "Peines principales encourues (personnes physiques) pour 432-8 :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "3 ans et 45 000 €",
      "5 ans et 75 000 €",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation: "Répression mentionnée : 2 ans + 30 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Tentative",
    question: "La tentative pour 432-8 est :",
    options: [
      "Incriminée (OUI)",
      "Non incriminée",
      "Uniquement en cas de violence",
    ],
    answer: "Incriminée (OUI)",
    explanation:
        "Le cours précise : TENTATIVE : OUI (spécifiquement incriminée).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Complicité",
    question: "La complicité (432-8) est :",
    options: [
      "Punissable (121-6 et 121-7)",
      "Impossible",
      "Punissable uniquement si l’auteur est un particulier",
    ],
    answer: "Punissable (121-6 et 121-7)",
    explanation: "Complicité punissable selon 121-6 et 121-7.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 432-9 — ATTEINTE AU SECRET DES CORRESPONDANCES
  // =========================================================
  const QuizQuestion(
    category: "Secret des correspondances — Texte",
    question:
        "L’atteinte au secret des correspondances est prévue et réprimée par :",
    options: [
      "Article 432-9 du Code pénal",
      "Article 432-8 du Code pénal",
      "Article 225-1 du Code pénal",
    ],
    answer: "Article 432-9 du Code pénal",
    explanation: "Le cours indique : article 432-9 C.P.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Définition",
    question:
        "L’infraction (432-9) peut consister à ordonner, commettre ou faciliter :",
    options: [
      "Le détournement, la suppression, l’ouverture de correspondances ou la révélation de leur contenu, hors les cas prévus par la loi",
      "Uniquement la lecture d’un journal",
      "Uniquement la destruction d’un colis perdu",
    ],
    answer:
        "Le détournement, la suppression, l’ouverture de correspondances ou la révélation de leur contenu, hors les cas prévus par la loi",
    explanation: "Définition textuelle du cours.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Auteurs",
    question: "Peuvent être auteurs (432-9) :",
    options: [
      "Dépositaires de l’autorité publique / chargés mission service public, et certains agents d’opérateurs télécoms dans l’exercice de leurs fonctions",
      "Uniquement un juge d’instruction",
      "Uniquement un particulier",
    ],
    answer:
        "Dépositaires de l’autorité publique / chargés mission service public, et certains agents d’opérateurs télécoms dans l’exercice de leurs fonctions",
    explanation:
        "Le cours vise aussi des agents exploitants de réseaux/fournisseurs télécoms.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Réseau ouvert au public",
    question: "Un réseau ouvert au public (CPCE) est :",
    options: [
      "Un réseau établi/utilisé pour fournir au public des services de communications électroniques",
      "Un réseau privé domestique uniquement",
      "Un réseau réservé aux administrations",
    ],
    answer:
        "Un réseau établi/utilisé pour fournir au public des services de communications électroniques",
    explanation: "Définition reprise du cours (CPCE).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Communications électroniques",
    question: "Les communications électroniques s’entendent comme :",
    options: [
      "Émissions/transmissions/réceptions de signes, signaux, écrits, images ou sons par divers moyens",
      "Uniquement les appels téléphoniques",
      "Uniquement les SMS",
    ],
    answer:
        "Émissions/transmissions/réceptions de signes, signaux, écrits, images ou sons par divers moyens",
    explanation: "Formulation du cours : câble, hertzien, optique, etc.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Correspondances matérielles",
    question: "Sont protégées comme correspondances matérielles :",
    options: [
      "Plis clos et plis ouverts, imprimés, journaux, paquets, etc.",
      "Uniquement les plis clos",
      "Uniquement les courriers professionnels",
    ],
    answer: "Plis clos et plis ouverts, imprimés, journaux, paquets, etc.",
    explanation:
        "Le cours précise que les plis clos comme ouverts sont protégés.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Contenu",
    question: "Le contenu de la correspondance protégée peut être :",
    options: [
      "Professionnel ou privé",
      "Uniquement privé",
      "Uniquement professionnel",
    ],
    answer: "Professionnel ou privé",
    explanation: "Peu importe le contenu : pro ou privé.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Télécommunications",
    question:
        "Pour les correspondances par télécommunications, elles doivent être :",
    options: [
      "En cours de transmission ou parvenues à destination mais non encore appréhendées par le destinataire",
      "Uniquement non envoyées",
      "Uniquement déjà lues",
    ],
    answer:
        "En cours de transmission ou parvenues à destination mais non encore appréhendées par le destinataire",
    explanation: "Condition donnée pour correspondances dématérialisées.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Modalités",
    question: "Dans 432-9, 'ordonner' correspond à :",
    options: [
      "Un ordre émanant d’une personne dépositaire de l’autorité publique (abus de pouvoir)",
      "Un simple conseil sans autorité",
      "Une demande de service entre collègues",
    ],
    answer:
        "Un ordre émanant d’une personne dépositaire de l’autorité publique (abus de pouvoir)",
    explanation: "Le cours relie ordonner à l’abus de pouvoir.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Contenu de l’atteinte",
    question: "Le 'détournement' d’une correspondance vise :",
    options: [
      "La modification du cours de sa transmission (atteinte à l’acheminement)",
      "La remise au bon destinataire",
      "La destruction d’un brouillon",
    ],
    answer:
        "La modification du cours de sa transmission (atteinte à l’acheminement)",
    explanation:
        "Le cours précise : atteinte à l’acheminement = détourner/modifier le cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Inviolabilité du support",
    question: "L’atteinte à l’inviolabilité du support peut consister en :",
    options: [
      "L’ouverture d’une correspondance",
      "La lecture d’un courrier reçu par soi-même",
      "L’affranchissement d’une lettre",
    ],
    answer: "L’ouverture d’une correspondance",
    explanation: "Exemple clair donné dans le cours.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Suppression",
    question: "La suppression d’une correspondance consiste en :",
    options: [
      "Tout acte empêchant qu’elle ne parvienne à destination",
      "Le fait de la remettre en main propre",
      "Le fait de l’archiver",
    ],
    answer: "Tout acte empêchant qu’elle ne parvienne à destination",
    explanation: "Définition du cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Télécoms",
    question: "Pour les télécommunications, l’atteinte peut consister en :",
    options: [
      "Interception/détournement, utilisation ou divulgation du contenu",
      "Uniquement l’envoi d’un SMS",
      "Uniquement la suppression d’un mail de sa propre boîte",
    ],
    answer: "Interception/détournement, utilisation ou divulgation du contenu",
    explanation: "Le cours liste ces formes pour télécommunications.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Divulgation",
    question: "La divulgation consiste à :",
    options: [
      "Révéler à un tiers sans qualité le contenu d’une correspondance non destinée à l’agent",
      "Remettre à l’expéditeur",
      "Informer le destinataire",
    ],
    answer:
        "Révéler à un tiers sans qualité le contenu d’une correspondance non destinée à l’agent",
    explanation: "Définition du cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Élément moral",
    question: "L’élément moral (432-9) suppose :",
    options: [
      "Conscience d’agir sans droit, savoir que la correspondance ne lui est pas destinée",
      "Obligation d’intention de nuire",
      "Simple négligence",
    ],
    answer:
        "Conscience d’agir sans droit, savoir que la correspondance ne lui est pas destinée",
    explanation: "Le cours insiste sur la conscience d’agir sans droit.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Erreur de fait",
    question: "L’erreur de fait :",
    options: [
      "Peut faire disparaître l’intention si l’ouverture est par méprise (ex: rechercher l’adresse pour réexpédier)",
      "Aggrave toujours la peine",
      "N’a aucun effet",
    ],
    answer:
        "Peut faire disparaître l’intention si l’ouverture est par méprise (ex: rechercher l’adresse pour réexpédier)",
    explanation:
        "Le cours : l’erreur de fait entraîne la disparition de l’intention.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Circonstances aggravantes",
    question: "Pour 432-9, circonstances aggravantes :",
    options: ["Aucune", "Toujours présentes", "Uniquement si récidive"],
    answer: "Aucune",
    explanation: "Le cours indique : AUCUNE.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Répression",
    question: "Peines (432-9) :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans et 30 000 €",
      "5 ans et 75 000 €",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Répression indiquée : 3 ans + 45 000 € (al.1 et al.2).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Tentative",
    question: "La tentative (432-9) est :",
    options: ["NON", "OUI", "OUI uniquement pour télécoms"],
    answer: "NON",
    explanation: "Le cours précise : TENTATIVE : NON.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Complicité",
    question: "La complicité (432-9) est :",
    options: ["OUI", "NON", "Uniquement si l’auteur est un magistrat"],
    answer: "OUI",
    explanation: "Le cours indique : COMPLICITÉ : OUI.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Faits justificatifs",
    question: "432-9 exclut l’infraction lorsqu’elle est réalisée :",
    options: [
      "Dans les cas prévus par la loi (ex: procédures judiciaires)",
      "En dehors de tout texte",
      "Uniquement la nuit",
    ],
    answer: "Dans les cas prévus par la loi (ex: procédures judiciaires)",
    explanation: "Cas prévus par la loi : procédure judiciaire notamment.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Interceptions judiciaires",
    question:
        "Les interceptions télécoms peuvent être autorisées par le juge d’instruction :",
    options: [
      "En matière criminelle et pour les délits punis d’au moins 3 ans d’emprisonnement",
      "Pour tout délit, sans condition",
      "Uniquement pour contraventions",
    ],
    answer:
        "En matière criminelle et pour les délits punis d’au moins 3 ans d’emprisonnement",
    explanation: "Le cours cite le cadre (CPP 100 à 100-8).",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 432-7 — DISCRIMINATIONS PAR PERSONNE EXERÇANT FONCTION PUBLIQUE
  // =========================================================
  const QuizQuestion(
    category: "Discriminations — Texte",
    question:
        "L’infraction de discrimination (par une personne exerçant une fonction publique) est prévue par :",
    options: [
      "Article 432-7 du Code pénal",
      "Article 432-8 du Code pénal",
      "Article 225-1 du Code pénal uniquement",
    ],
    answer: "Article 432-7 du Code pénal",
    explanation: "Le cours indique : article 432-7 C.P.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Définition",
    question:
        "La discrimination (432-7) commise par une personne dépositaire/chargée mission SP consiste notamment à :",
    options: [
      "Refuser le bénéfice d’un droit accordé par la loi ou entraver l’exercice normal d’une activité économique",
      "Uniquement insulter une personne",
      "Uniquement refuser de saluer",
    ],
    answer:
        "Refuser le bénéfice d’un droit accordé par la loi ou entraver l’exercice normal d’une activité économique",
    explanation: "Définition donnée en 1° et 2°.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Fondements",
    question:
        "La discrimination vise une distinction opérée entre personnes sur certains fondements, par exemple :",
    options: [
      "Origine, sexe, situation de famille, grossesse, handicap, âge, etc.",
      "Uniquement le niveau de diplôme",
      "Uniquement la tenue vestimentaire professionnelle",
    ],
    answer:
        "Origine, sexe, situation de famille, grossesse, handicap, âge, etc.",
    explanation: "Le cours liste de nombreux critères (225-1 et 225-1-1).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Qualité de l’auteur",
    question: "Pour 432-7, l’auteur doit être :",
    options: [
      "Dépositaire de l’autorité publique ou chargé d’une mission de service public",
      "Un particulier",
      "Uniquement une personne morale",
    ],
    answer:
        "Dépositaire de l’autorité publique ou chargé d’une mission de service public",
    explanation: "Condition de qualité rappelée dans le cours.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Exemples de droits",
    question: "Le 'droit accordé par la loi' peut consister en :",
    options: [
      "Une prestation sociale, un document administratif, un concours, une mutation, un congé, etc.",
      "Une faveur au bon vouloir d’un agent",
      "Un pourboire obligatoire",
    ],
    answer:
        "Une prestation sociale, un document administratif, un concours, une mutation, un congé, etc.",
    explanation: "Exemples donnés dans le cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Discrétion",
    question: "Ne constitue pas un 'droit accordé par la loi' :",
    options: [
      "Une simple liberté d’appréciation laissée à la discrétion d’un fonctionnaire (ex: distinction)",
      "L’obtention d’un document administratif prévu par un texte",
      "Le bénéfice d’une prestation sociale",
    ],
    answer:
        "Une simple liberté d’appréciation laissée à la discrétion d’un fonctionnaire (ex: distinction)",
    explanation: "Le cours le précise explicitement.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Discriminations — Activité économique",
    question: "Entraver une activité économique consiste à :",
    options: [
      "Rendre plus difficile l’exercice d’une activité (tracasseries, pressions, dénigrement, etc.)",
      "Refuser de travailler",
      "Faire une publicité",
    ],
    answer:
        "Rendre plus difficile l’exercice d’une activité (tracasseries, pressions, dénigrement, etc.)",
    explanation: "Le cours donne des exemples d’entrave.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Victime",
    question: "Les agissements discriminatoires peuvent viser :",
    options: [
      "Une personne physique ou les membres d’une personne morale",
      "Uniquement une personne physique",
      "Uniquement une association",
    ],
    answer: "Une personne physique ou les membres d’une personne morale",
    explanation: "Le cours précise les deux.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Élément moral",
    question: "L’élément moral de 432-7 exige :",
    options: [
      "Une volonté discriminatoire (conscience de se livrer à des agissements discriminatoires)",
      "Une simple imprudence",
      "Aucune intention",
    ],
    answer:
        "Une volonté discriminatoire (conscience de se livrer à des agissements discriminatoires)",
    explanation: "Le cours : existence d’une volonté discriminatoire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Circonstances aggravantes",
    question: "Circonstances aggravantes pour 432-7 :",
    options: ["Aucune", "Uniquement si récidive", "Uniquement si violence"],
    answer: "Aucune",
    explanation: "Le cours indique : AUCUNE.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Répression",
    question: "Peines principales (personnes physiques) pour 432-7 :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans et 45 000 €",
      "2 ans et 30 000 €",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Répression mentionnée : 5 ans + 75 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Tentative",
    question: "La tentative (432-7) est :",
    options: ["NON", "OUI", "OUI uniquement si entrave économique"],
    answer: "NON",
    explanation: "Le cours précise : la tentative n’est pas incriminée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Complicité",
    question: "La complicité (432-7) est :",
    options: [
      "OUI (121-6 et 121-7)",
      "NON",
      "OUI uniquement si l’auteur est maire",
    ],
    answer: "OUI (121-6 et 121-7)",
    explanation:
        "Complicité punissable conformément aux articles 121-6 et 121-7.",
    difficulty: "Moyenne",
  ),

  // ✅ Questions supplémentaires à ajouter après celles-ci (432-8 — inviolabilité du domicile)
  const QuizQuestion(
    category: "Inviolabilité du domicile — Conditions",
    question:
        "Pour que l’infraction (432-8) soit constituée, l’auteur doit agir :",
    options: [
      "Dans l’exercice ou à l’occasion de l’exercice de ses fonctions ou de sa mission",
      "Uniquement en dehors de ses fonctions",
      "Uniquement en dehors de tout cadre professionnel",
    ],
    answer:
        "Dans l’exercice ou à l’occasion de l’exercice de ses fonctions ou de sa mission",
    explanation:
        "Le texte exige que l’auteur agisse dans l’exercice ou à l’occasion de l’exercice de ses fonctions/mission.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Abus de qualité",
    question:
        "L’auteur doit avoir abusé de sa qualité pour pénétrer au domicile, ce qui exclut :",
    options: [
      "Une violation de domicile pour des raisons personnelles",
      "Une action réalisée dans le cadre de ses attributions",
      "Une action liée à l’exercice de la mission",
    ],
    answer: "Une violation de domicile pour des raisons personnelles",
    explanation:
        "Le cours précise que l’auteur doit avoir abusé de sa qualité et que les raisons personnelles sont exclues.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Notion de domicile",
    question: "Le domicile se définit comme :",
    options: [
      "Le lieu où une personne a le droit de se dire chez elle, qu’elle y habite ou non",
      "Uniquement le domicile légal déclaré",
      "Uniquement un logement dont la personne est propriétaire",
    ],
    answer:
        "Le lieu où une personne a le droit de se dire chez elle, qu’elle y habite ou non",
    explanation:
        "Le cours définit le domicile comme le lieu où la personne a le droit de se dire chez elle, indépendamment du titre.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Étendue",
    question: "La notion de domicile peut recouvrir :",
    options: [
      "Le domicile légal, une résidence, ou un lieu de séjour occasionnel",
      "Uniquement la résidence principale",
      "Uniquement un logement occupé en permanence",
    ],
    answer:
        "Le domicile légal, une résidence, ou un lieu de séjour occasionnel",
    explanation:
        "Le cours indique que le domicile peut être légal, résidence, ou lieu de séjour occasionnel.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Logement inoccupé",
    question: "Un logement inoccupé peut être considéré comme un domicile si :",
    options: [
      "Il contient des meubles signalant une occupation effective (table, chaises, lit, etc.)",
      "Il contient seulement une bicyclette ou un carton de livres",
      "Il est vide mais la porte est verrouillée",
    ],
    answer:
        "Il contient des meubles signalant une occupation effective (table, chaises, lit, etc.)",
    explanation:
        "Le cours précise que la présence de meubles peut caractériser le domicile si elle permet de s’y dire chez soi; vélo/carton seuls insuffisants.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Dépendances",
    question: "Le domicile se comprend comme :",
    options: [
      "Une habitation quelconque avec ses dépendances (caves, terrasses, etc.)",
      "Uniquement les pièces à vivre",
      "Uniquement l’entrée et le salon",
    ],
    answer:
        "Une habitation quelconque avec ses dépendances (caves, terrasses, etc.)",
    explanation:
        "Le cours inclut les dépendances (caves, terrasses…) dans la notion de domicile.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Jardins/Parcs",
    question: "Cours, jardins et parcs sont assimilés au domicile lorsque :",
    options: [
      "Ils sont clos et attenants à l’habitation",
      "Ils sont visibles depuis la rue",
      "Ils appartiennent à la commune",
    ],
    answer: "Ils sont clos et attenants à l’habitation",
    explanation:
        "Le cours précise l’assimilation dès lors que ces lieux sont clos et attenants à l’habitation.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Proximité",
    question:
        "Pour qu’une dépendance entre dans la notion de domicile, la jurisprudence exige :",
    options: [
      "Un lien étroit et immédiat et une proximité avec l’habitation",
      "Uniquement qu’elle soit sur la même parcelle cadastrale",
      "Aucune condition particulière",
    ],
    answer: "Un lien étroit et immédiat et une proximité avec l’habitation",
    explanation:
        "Le cours insiste sur la nécessité d’un lien étroit et immédiat et d’une proximité entre dépendance et habitation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Acte matériel",
    question: "L’action incriminée par l’article 432-8 vise :",
    options: [
      "L’introduction ou la tentative d’introduction dans un domicile",
      "Le maintien dans un domicile",
      "Le fait de rester sur le trottoir devant le domicile",
    ],
    answer: "L’introduction ou la tentative d’introduction dans un domicile",
    explanation:
        "Le texte vise l’introduction/tentative; il ne vise pas le maintien dans les lieux.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Moyen",
    question: "L’introduction illicite (432-8) peut être réalisée :",
    options: [
      "Quel que soit le moyen, même sans violence ou artifice",
      "Uniquement avec violence",
      "Uniquement avec effraction",
    ],
    answer: "Quel que soit le moyen, même sans violence ou artifice",
    explanation:
        "Le cours indique que l’introduction est répréhensible quel que soit le moyen, même sans violence ni artifice.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Contre le gré",
    question:
        "L’article 432-8 ne réprime l’introduction que si elle est effectuée :",
    options: [
      "Contre le gré de l’occupant",
      "Avec consentement exprès",
      "Sur invitation de l’occupant",
    ],
    answer: "Contre le gré de l’occupant",
    explanation:
        "Condition centrale : l’introduction doit être contre le gré de l’occupant; sinon l’infraction n’est pas constituée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Absence de consentement",
    question:
        "Même sans opposition formelle, l’absence de consentement peut être retenue notamment si l’auteur pénètre :",
    options: [
      "À l’insu de l’occupant (ex: en enjambant une fenêtre ouverte)",
      "Uniquement après un refus écrit",
      "Uniquement après violence",
    ],
    answer: "À l’insu de l’occupant (ex: en enjambant une fenêtre ouverte)",
    explanation:
        "Le cours indique qu’il suffit que la personne n’ait pas consenti, ce qui englobe une entrée à l’insu de l’occupant.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Consentement vicié",
    question: "Le consentement de l’occupant ne doit pas être vicié par :",
    options: [
      "Des manœuvres ou stratagèmes policiers",
      "Une demande polie",
      "Une présence en uniforme",
    ],
    answer: "Des manœuvres ou stratagèmes policiers",
    explanation:
        "Le cours précise que le consentement vicié par des manœuvres/stratagèmes ne fait pas obstacle à la caractérisation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Cas légaux",
    question: "432-8 sanctionne l’introduction lorsque celle-ci intervient :",
    options: [
      "Hors les cas permis par la loi",
      "Même lorsqu’un texte l’autorise",
      "Uniquement en journée",
    ],
    answer: "Hors les cas permis par la loi",
    explanation:
        "Le cours rappelle que certains textes autorisent l’entrée; 432-8 sanctionne l’entrée hors de ces cas.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Élément moral",
    question: "L’élément moral de l’infraction (432-8) implique :",
    options: [
      "La conscience de pénétrer irrégulièrement au domicile d’autrui",
      "L’intention obligatoire de nuire",
      "Une simple imprudence",
    ],
    answer: "La conscience de pénétrer irrégulièrement au domicile d’autrui",
    explanation:
        "Le cours vise la conscience de l’irrégularité des agissements (intention).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Circonstances aggravantes",
    question:
        "Concernant l’article 432-8, les circonstances aggravantes sont :",
    options: ["Aucune", "Toujours présentes", "Uniquement si effraction"],
    answer: "Aucune",
    explanation: "Le cours indique : IV - Circonstances aggravantes : AUCUNE.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Répression",
    question: "Peines encourues (personne physique) pour 432-8 :",
    options: [
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "2 ans d’emprisonnement et 30 000 € d’amende",
    explanation:
        "Le cours mentionne comme peines principales : 2 ans d’emprisonnement et 30 000 € d’amende.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Tentative",
    question:
        "La tentative de violation de domicile par une personne dépositaire/chargée mission SP (432-8) est :",
    options: [
      "Incriminée (OUI)",
      "Non incriminée",
      "Incriminée uniquement en cas de violence",
    ],
    answer: "Incriminée (OUI)",
    explanation:
        "Le cours indique explicitement : TENTATIVE : OUI (incriminée spécifiquement).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Complicité",
    question: "La complicité (432-8) est :",
    options: [
      "Punissable conformément aux articles 121-6 et 121-7 du Code pénal",
      "Impossible",
      "Punissable uniquement si l’auteur principal est un particulier",
    ],
    answer: "Punissable conformément aux articles 121-6 et 121-7 du Code pénal",
    explanation:
        "Le cours indique : complicité punissable (aide/assistance, provocation, instructions).",
    difficulty: "Moyenne",
  ),

  // ✅ Suite — encore plus de questions 432-8 (Inviolabilité du domicile)
  const QuizQuestion(
    category: "Inviolabilité du domicile — Dépositaire de l'autorité publique",
    question:
        "Sont notamment concernés comme dépositaires de l’autorité publique :",
    options: [
      "Policiers, gendarmes, douaniers, huissiers de justice",
      "Agents immobiliers, employés de supermarché, commerçants",
      "Médecins, infirmiers, pharmaciens",
    ],
    answer: "Policiers, gendarmes, douaniers, huissiers de justice",
    explanation:
        "Le cours cite explicitement policiers, gendarmes, douaniers, huissiers, etc.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Responsables exécutifs locaux",
    question: "Ont aussi la qualité de dépositaires de l’autorité publique :",
    options: [
      "Maires, présidents d’intercommunalités, conseils départementaux et régionaux",
      "Uniquement les députés",
      "Uniquement les agents d’entretien municipaux",
    ],
    answer:
        "Maires, présidents d’intercommunalités, conseils départementaux et régionaux",
    explanation:
        "Le cours vise les responsables des exécutifs locaux (et certains adjoints/délégués).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Adjoints et délégués",
    question:
        "Le cours indique que possèdent la qualité de dépositaires de l’autorité publique :",
    options: [
      "Les adjoints au maire et conseillers municipaux délégués",
      "Tous les élus sans distinction",
      "Uniquement les parlementaires",
    ],
    answer: "Les adjoints au maire et conseillers municipaux délégués",
    explanation:
        "Ils sont mentionnés comme ayant la qualité de dépositaires de l’autorité publique.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Mission de service public",
    question: "Une personne chargée d’une mission de service public :",
    options: [
      "Participe à une mission d’intérêt général sans pouvoir de décision/commandement",
      "Dispose toujours d’un pouvoir de décision",
      "Est forcément fonctionnaire au sens strict",
    ],
    answer:
        "Participe à une mission d’intérêt général sans pouvoir de décision/commandement",
    explanation:
        "Le cours précise qu’elle participe à une mission d’intérêt général sans prérogatives de puissance publique.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Élus locaux et mission SP",
    question:
        "Les élus locaux peuvent être qualifiés de 'chargés d’une mission de service public' :",
    options: [
      "Lorsqu’ils ne reçoivent pas, par délégation, de prérogatives de puissance publique",
      "Uniquement lorsqu’ils sont maires",
      "Jamais, car un élu est toujours dépositaire de l’autorité publique",
    ],
    answer:
        "Lorsqu’ils ne reçoivent pas, par délégation, de prérogatives de puissance publique",
    explanation:
        "Le cours indique que sans délégation de prérogatives de puissance publique, ils sont chargés d’une mission SP.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — 'À l’occasion' des fonctions",
    question:
        "Agir 'à l’occasion de l’exercice des fonctions' implique que l’agent :",
    options: [
      "A abusé de sa qualité dans un contexte lié à ses fonctions, même hors stricte compétence",
      "A agi uniquement dans sa vie privée, sans lien avec ses fonctions",
      "A toujours agi en service et en uniforme",
    ],
    answer:
        "A abusé de sa qualité dans un contexte lié à ses fonctions, même hors stricte compétence",
    explanation:
        "Le cours distingue agir dans l’exercice ou à l’occasion : l’acte reste rattaché aux fonctions/mission.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Domicile et titre juridique",
    question: "Pour caractériser un domicile, il faut :",
    options: [
      "Que la personne ait le droit de s’y dire chez elle, quel que soit le titre juridique d’occupation",
      "Que la personne soit propriétaire des lieux",
      "Que la personne y soit domiciliée administrativement",
    ],
    answer:
        "Que la personne ait le droit de s’y dire chez elle, quel que soit le titre juridique d’occupation",
    explanation:
        "Le cours précise que le titre juridique importe peu : c’est le droit de s’y dire chez soi.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Condition d’intimité",
    question:
        "La seule condition rappelée par le cours pour retenir la notion de domicile est que :",
    options: [
      "Le lieu protège l’intimité",
      "Le lieu soit une résidence principale",
      "Le lieu soit déclaré aux impôts",
    ],
    answer: "Le lieu protège l’intimité",
    explanation:
        "Le cours indique : la condition est la protection de l’intimité.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Exemples meubles suffisants",
    question:
        "Parmi les éléments cités comme pouvant signaler une occupation effective d’un logement vacant :",
    options: [
      "Table, chaises, lit, canapé, appareils électroménagers",
      "Un carton de livres et une bicyclette",
      "Un tapis de sol seul",
    ],
    answer: "Table, chaises, lit, canapé, appareils électroménagers",
    explanation:
        "Le cours donne ces exemples et précise que bicyclette/carton seuls ne suffisent pas.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Moyen d’introduction",
    question: "Pour 432-8, l’introduction peut être caractérisée :",
    options: [
      "Même sans violence ni artifice, quel que soit le moyen",
      "Uniquement avec effraction",
      "Uniquement s’il y a dégradation",
    ],
    answer: "Même sans violence ni artifice, quel que soit le moyen",
    explanation:
        "Le cours précise : quel que soit le moyen, même sans violence ou artifice.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Non visé",
    question: "Le cours indique que n’est pas visé par 432-8 :",
    options: [
      "Le maintien dans un domicile",
      "La tentative d’introduction",
      "L’introduction sans violence",
    ],
    answer: "Le maintien dans un domicile",
    explanation:
        "Il est précisé : l’action incriminée est l’introduction ou la tentative, pas le maintien.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Enquête préliminaire (exemple)",
    question:
        "Selon l’exemple du cours, un OPJ en enquête préliminaire qui refuse de quitter les lieux après retrait du consentement écrit :",
    options: [
      "Ne commet pas une violation de domicile au sens de 432-8 (sur ce fondement)",
      "Commet automatiquement une violation de domicile",
      "Commet forcément une tentative de violation",
    ],
    answer:
        "Ne commet pas une violation de domicile au sens de 432-8 (sur ce fondement)",
    explanation:
        "Le cours donne cet exemple pour illustrer que le maintien n’est pas visé par 432-8.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Jurisprudence (hôtel)",
    question:
        "D’après la jurisprudence citée, des policiers qui invitent par téléphone un occupant d’hôtel à les rejoindre dans le hall :",
    options: [
      "Ne constituent pas une pénétration dans un domicile",
      "Constituent toujours une introduction dans un domicile",
      "Constituent une tentative d’introduction",
    ],
    answer: "Ne constituent pas une pénétration dans un domicile",
    explanation:
        "Le cours cite une décision où le hall d’hôtel + invitation ne vaut pas pénétration dans un domicile.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Jurisprudence (garage)",
    question:
        "D’après la jurisprudence citée, des gendarmes sur le seuil d’un garage ouvert par l’agent immobilier, sans y pénétrer :",
    options: [
      "Ne sont pas constitutifs d’une introduction dans un domicile",
      "Sont constitutifs d’une introduction dans un domicile",
      "Sont constitutifs d’une suppression de correspondance",
    ],
    answer: "Ne sont pas constitutifs d’une introduction dans un domicile",
    explanation:
        "Le cours cite une décision : photographie sur le seuil sans pénétrer ≠ introduction.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Consentement",
    question:
        "L’infraction n’est pas constituée si l’agent de la force publique pénètre au domicile :",
    options: [
      "Avec le consentement de l’occupant",
      "Même avec consentement",
      "Uniquement si l’occupant est absent",
    ],
    answer: "Avec le consentement de l’occupant",
    explanation:
        "Le texte précise : pas d’infraction si l’entrée est consentie (hors consentement vicié).",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Consentement vicié (rappel)",
    question:
        "Le consentement n’empêche pas l’infraction s’il est obtenu par :",
    options: [
      "Manœuvres ou stratagèmes policiers",
      "Une demande claire et loyale",
      "Une autorisation écrite librement donnée",
    ],
    answer: "Manœuvres ou stratagèmes policiers",
    explanation:
        "Le cours précise que le consentement vicié par manœuvres/stratagèmes ne vaut pas consentement.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Hors les cas prévus par la loi",
    question:
        "Pourquoi 432-8 est qualifié de sanction du non-respect des conditions de fond ?",
    options: [
      "Parce qu’il sanctionne l’entrée au domicile lorsque les conditions légales d’intervention ne sont pas respectées",
      "Parce qu’il sanctionne toute intervention, même régulière",
      "Parce qu’il sanctionne uniquement les dégradations",
    ],
    answer:
        "Parce qu’il sanctionne l’entrée au domicile lorsque les conditions légales d’intervention ne sont pas respectées",
    explanation:
        "Le cours indique que 432-8 sanctionne le non-respect des conditions de fond encadrant les interventions publiques.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Personnes morales",
    question: "Le cours indique que les personnes morales :",
    options: [
      "Peuvent être reconnues responsables pénalement",
      "Ne peuvent jamais être responsables",
      "Sont responsables uniquement pour les contraventions",
    ],
    answer: "Peuvent être reconnues responsables pénalement",
    explanation:
        "Le tableau de répression mentionne : personnes morales peuvent être reconnues responsables.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Inviolabilité du domicile — Complicité (formes)",
    question: "La complicité peut résulter notamment de :",
    options: [
      "Aide/assistance, provocation, ou instructions données",
      "Uniquement d’un silence",
      "Uniquement d’un témoignage ultérieur",
    ],
    answer: "Aide/assistance, provocation, ou instructions données",
    explanation:
        "Le cours cite ces faits constitutifs de complicité (121-6 et 121-7).",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 432-9 — ATTEINTE AU SECRET DES CORRESPONDANCES
  // =========================================================
  const QuizQuestion(
    category: "Secret des correspondances — Définition",
    question:
        "L’atteinte au secret des correspondances consiste notamment, pour une personne dépositaire de l’autorité publique ou chargée d’une mission de service public, à :",
    options: [
      "Ordonner, commettre ou faciliter le détournement, la suppression, l’ouverture ou la révélation du contenu de correspondances, hors les cas prévus par la loi",
      "Lire une correspondance avec l’accord de son destinataire",
      "Conserver une correspondance déjà remise à son destinataire",
    ],
    answer:
        "Ordonner, commettre ou faciliter le détournement, la suppression, l’ouverture ou la révélation du contenu de correspondances, hors les cas prévus par la loi",
    explanation:
        "Définition complète de l’atteinte au secret des correspondances donnée par le cours.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Texte",
    question:
        "L’infraction d’atteinte au secret des correspondances est prévue par :",
    options: [
      "L’article 432-9 du Code pénal",
      "L’article 432-8 du Code pénal",
      "L’article 225-1 du Code pénal",
    ],
    answer: "L’article 432-9 du Code pénal",
    explanation:
        "Le cours indique que l’infraction est prévue et réprimée par l’article 432-9 du C.P.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Auteurs",
    question: "Peut être auteur de l’infraction prévue à l’article 432-9 :",
    options: [
      "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
      "Uniquement un particulier",
      "Uniquement un magistrat",
    ],
    answer:
        "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
    explanation: "Le texte vise spécifiquement ces catégories d’auteurs.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Autres auteurs",
    question: "Peut également être auteur de l’atteinte aux correspondances :",
    options: [
      "Un agent d’un exploitant de réseaux ouverts au public de communications électroniques ou d’un fournisseur de services de télécommunications",
      "Uniquement un agent de La Poste",
      "Uniquement un officier de police judiciaire",
    ],
    answer:
        "Un agent d’un exploitant de réseaux ouverts au public de communications électroniques ou d’un fournisseur de services de télécommunications",
    explanation:
        "Le cours étend l’infraction à certains agents des réseaux et télécommunications.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Agissement",
    question: "L’auteur doit agir :",
    options: [
      "Dans l’exercice ou à l’occasion de l’exercice de ses fonctions ou de sa mission",
      "Uniquement en dehors de ses fonctions",
      "Uniquement à titre personnel",
    ],
    answer:
        "Dans l’exercice ou à l’occasion de l’exercice de ses fonctions ou de sa mission",
    explanation: "Condition identique à celle des autres abus d’autorité.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Correspondances matérielles",
    question: "Sont considérées comme correspondances matérielles :",
    options: [
      "Plis clos, plis ouverts, imprimés, journaux, paquets",
      "Uniquement les lettres fermées",
      "Uniquement les colis recommandés",
    ],
    answer: "Plis clos, plis ouverts, imprimés, journaux, paquets",
    explanation:
        "Le cours précise que les plis clos comme ouverts sont protégés.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Télécommunications",
    question:
        "Les correspondances émises par la voie des télécommunications sont :",
    options: [
      "Des correspondances dématérialisées sans support tangible",
      "Uniquement des courriers électroniques",
      "Uniquement des appels téléphoniques",
    ],
    answer: "Des correspondances dématérialisées sans support tangible",
    explanation:
        "Le cours définit les correspondances télécoms comme dématérialisées.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — État de la correspondance",
    question:
        "Pour être protégées, les correspondances télécoms doivent être :",
    options: [
      "En cours de transmission ou parvenues à destination mais non encore appréhendées par le destinataire",
      "Uniquement non envoyées",
      "Uniquement déjà lues",
    ],
    answer:
        "En cours de transmission ou parvenues à destination mais non encore appréhendées par le destinataire",
    explanation: "Condition précisée dans le cours.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Actes matériels",
    question: "L’atteinte peut consister notamment à :",
    options: [
      "Détourner, supprimer, ouvrir une correspondance ou en révéler le contenu",
      "Retarder une réponse administrative",
      "Refuser d’écrire une lettre",
    ],
    answer:
        "Détourner, supprimer, ouvrir une correspondance ou en révéler le contenu",
    explanation: "Liste des actes matériels constitutifs de l’infraction.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Détournement",
    question: "Le détournement d’une correspondance consiste à :",
    options: [
      "Modifier le cours de sa transmission",
      "La remettre à son destinataire",
      "La classer dans un dossier",
    ],
    answer: "Modifier le cours de sa transmission",
    explanation:
        "Le cours vise l’atteinte à l’acheminement de la correspondance.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Ouverture",
    question: "L’ouverture d’une correspondance constitue :",
    options: [
      "Une atteinte à l’inviolabilité du support",
      "Une simple irrégularité administrative",
      "Un fait justificatif",
    ],
    answer: "Une atteinte à l’inviolabilité du support",
    explanation:
        "Le cours qualifie l’ouverture comme atteinte à l’inviolabilité du support.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Révélation",
    question: "La révélation du contenu d’une correspondance consiste à :",
    options: [
      "Divulguer à un tiers sans qualité le contenu d’une correspondance qui ne lui est pas destinée",
      "Informer le destinataire",
      "Transmettre la correspondance à son auteur",
    ],
    answer:
        "Divulguer à un tiers sans qualité le contenu d’une correspondance qui ne lui est pas destinée",
    explanation: "Définition donnée par le cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Élément moral",
    question: "L’élément moral de l’infraction 432-9 suppose :",
    options: [
      "La conscience d’agir sans droit et de porter atteinte au secret de la correspondance",
      "Une intention de nuire obligatoire",
      "Une simple négligence",
    ],
    answer:
        "La conscience d’agir sans droit et de porter atteinte au secret de la correspondance",
    explanation: "Le cours précise que l’intention de nuire n’est pas exigée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Erreur de fait",
    question: "L’erreur de fait peut entraîner :",
    options: [
      "La disparition de l’intention et donc l’absence d’infraction",
      "Une aggravation de la peine",
      "Une qualification automatique",
    ],
    answer: "La disparition de l’intention et donc l’absence d’infraction",
    explanation: "Exemple : ouverture par méprise pour réexpédier une lettre.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Tentative",
    question:
        "La tentative d’atteinte au secret des correspondances (432-9) est :",
    options: [
      "Non incriminée",
      "Incriminée",
      "Incriminée uniquement pour les télécommunications",
    ],
    answer: "Non incriminée",
    explanation: "Le cours précise expressément : TENTATIVE : NON.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Répression",
    question: "Les peines encourues pour l’article 432-9 sont :",
    options: [
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "3 ans d’emprisonnement et 45 000 € d’amende",
    explanation: "Répression prévue par l’article 432-9.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 432-7 — DISCRIMINATIONS PAR PERSONNE EXERÇANT UNE FONCTION PUBLIQUE
  // =========================================================
  const QuizQuestion(
    category: "Discriminations — Définition",
    question:
        "La discrimination commise par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public consiste notamment à :",
    options: [
      "Refuser le bénéfice d’un droit accordé par la loi ou entraver l’exercice normal d’une activité économique",
      "Tenir des propos désobligeants",
      "Refuser une faveur discrétionnaire",
    ],
    answer:
        "Refuser le bénéfice d’un droit accordé par la loi ou entraver l’exercice normal d’une activité économique",
    explanation: "Définition donnée par l’article 432-7 du Code pénal.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Texte",
    question: "L’infraction de discrimination est prévue par :",
    options: [
      "L’article 432-7 du Code pénal",
      "L’article 225-1 du Code pénal uniquement",
      "L’article 432-8 du Code pénal",
    ],
    answer: "L’article 432-7 du Code pénal",
    explanation:
        "Le cours indique que l’infraction est prévue par l’article 432-7.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Critères",
    question: "La discrimination peut être fondée notamment sur :",
    options: [
      "L’origine, le sexe, la situation de famille, l’état de santé, le handicap, l’âge",
      "Le niveau scolaire uniquement",
      "La tenue vestimentaire professionnelle",
    ],
    answer:
        "L’origine, le sexe, la situation de famille, l’état de santé, le handicap, l’âge",
    explanation:
        "Liste non exhaustive des critères mentionnés par le Code pénal.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Droit accordé par la loi",
    question: "Le 'droit accordé par la loi' s’entend :",
    options: [
      "De toute règle de portée générale et impersonnelle",
      "Uniquement d’une loi votée par le Parlement",
      "Uniquement d’un règlement intérieur",
    ],
    answer: "De toute règle de portée générale et impersonnelle",
    explanation:
        "Le cours précise que la notion de loi n’est pas entendue de manière restrictive.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Discriminations — Activité économique",
    question: "Entraver l’exercice d’une activité économique consiste à :",
    options: [
      "Rendre plus difficile l’exercice de cette activité",
      "Empêcher toute activité commerciale",
      "Refuser une aide facultative",
    ],
    answer: "Rendre plus difficile l’exercice de cette activité",
    explanation:
        "Le cours cite notamment les tracasseries administratives, pressions, dénigrement.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Élément moral",
    question: "L’élément moral de la discrimination suppose :",
    options: [
      "Une volonté discriminatoire consciente",
      "Une simple erreur administrative",
      "Une négligence",
    ],
    answer: "Une volonté discriminatoire consciente",
    explanation: "Le cours précise l’existence d’une volonté discriminatoire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Tentative",
    question: "La tentative de discrimination (432-7) est :",
    options: [
      "Non incriminée",
      "Incriminée",
      "Incriminée uniquement en cas de récidive",
    ],
    answer: "Non incriminée",
    explanation: "Le cours précise que la tentative n’est pas incriminée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Répression",
    question: "Les peines encourues pour l’article 432-7 sont :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Répression prévue par l’article 432-7 du Code pénal.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 432-9 — ATTEINTE AU SECRET DES CORRESPONDANCES (SUITE)
  // =========================================================
  const QuizQuestion(
    category: "Secret des correspondances — Ordonner",
    question:
        "Dans le cadre de l’article 432-9, l’action d’« ordonner » suppose :",
    options: [
      "Un abus de pouvoir émanant d’une personne dépositaire de l’autorité publique",
      "Une simple suggestion sans autorité",
      "Une demande amicale entre collègues",
    ],
    answer:
        "Un abus de pouvoir émanant d’une personne dépositaire de l’autorité publique",
    explanation:
        "Le cours précise que l’ordre doit émaner d’une personne dépositaire de l’autorité publique.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Commettre",
    question: "Dans l’article 432-9, le terme « commettre » vise :",
    options: [
      "L’acte matériel directement accompli par l’auteur lui-même",
      "Uniquement le fait de donner des instructions",
      "Uniquement le fait de surveiller",
    ],
    answer: "L’acte matériel directement accompli par l’auteur lui-même",
    explanation:
        "Le cours distingue clairement ordonner / commettre / faciliter.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Faciliter",
    question:
        "Faciliter une atteinte au secret des correspondances consiste à :",
    options: [
      "Fournir des indications, instructions ou une aide permettant la commission de l’infraction",
      "Observer sans intervenir",
      "Ignorer volontairement les faits",
    ],
    answer:
        "Fournir des indications, instructions ou une aide permettant la commission de l’infraction",
    explanation:
        "La facilitation correspond à une aide matérielle ou intellectuelle.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Photocopie",
    question:
        "La photocopie de documents contenus dans une correspondance constitue :",
    options: [
      "Une atteinte au secret des correspondances",
      "Un acte neutre sans conséquence pénale",
      "Un simple manquement disciplinaire",
    ],
    answer: "Une atteinte au secret des correspondances",
    explanation:
        "Le cours cite expressément la photocopie comme modalité d’atteinte.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Interception",
    question: "L’interception d’une correspondance consiste à :",
    options: [
      "Capter un message pendant le cours de sa transmission",
      "Lire un message déjà ouvert par son destinataire",
      "Archiver un message reçu légalement",
    ],
    answer: "Capter un message pendant le cours de sa transmission",
    explanation: "Définition donnée pour les correspondances télécoms.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Utilisation",
    question: "L’utilisation du contenu d’une correspondance vise :",
    options: [
      "Le fait de se servir du contenu comme si l’agent en était le destinataire",
      "La simple conservation de la correspondance",
      "La restitution immédiate",
    ],
    answer:
        "Le fait de se servir du contenu comme si l’agent en était le destinataire",
    explanation: "L’utilisation est distincte de la divulgation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Jurisprudence",
    question:
        "Selon la jurisprudence citée, la lecture et la divulgation de mails d’un étudiant constituent :",
    options: [
      "Une violation du secret des correspondances",
      "Un simple contrôle administratif",
      "Un fait justificatif",
    ],
    answer: "Une violation du secret des correspondances",
    explanation: "C.A. Paris, 17 décembre 2001.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Intention",
    question: "L’élément intentionnel de l’article 432-9 :",
    options: [
      "N’exige pas l’intention de nuire",
      "Exige nécessairement une intention de nuire",
      "Est présumé automatiquement",
    ],
    answer: "N’exige pas l’intention de nuire",
    explanation:
        "La Cour de cassation précise que l’intention de nuire n’est pas requise.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Erreur de fait (limite)",
    question:
        "L’erreur de fait en matière de correspondances télécoms ne s’applique que si :",
    options: [
      "Il est possible de recevoir la correspondance sans en connaître le contenu",
      "La correspondance a déjà été lue",
      "L’agent est en service",
    ],
    answer:
        "Il est possible de recevoir la correspondance sans en connaître le contenu",
    explanation:
        "Précision du cours concernant l’application de l’erreur de fait.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Faits justificatifs",
    question:
        "L’atteinte au secret des correspondances n’est pas constituée lorsqu’elle est réalisée :",
    options: [
      "Dans les cas prévus par la loi",
      "Pour faciliter une enquête",
      "À titre préventif",
    ],
    answer: "Dans les cas prévus par la loi",
    explanation: "Exemples : procédures judiciaires autorisées par le CPP.",
    difficulty: "Facile",
  ),

  // =========================================================
  // 432-7 — DISCRIMINATIONS (SUITE ET APPROFONDISSEMENT)
  // =========================================================
  const QuizQuestion(
    category: "Discriminations — Qualité de l’auteur",
    question: "L’article 432-7 vise les discriminations commises par :",
    options: [
      "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
      "Tout particulier",
      "Uniquement les élus",
    ],
    answer:
        "Une personne dépositaire de l’autorité publique ou chargée d’une mission de service public",
    explanation: "Condition de qualité indispensable à la qualification.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Refus de droit",
    question:
        "Refuser le bénéfice d’un droit accordé par la loi peut concerner :",
    options: [
      "L’obtention d’un document administratif",
      "Une faveur discrétionnaire",
      "Une décision purement politique",
    ],
    answer: "L’obtention d’un document administratif",
    explanation: "Le cours cite explicitement les documents administratifs.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Libertés publiques",
    question: "Le droit accordé par la loi peut consister en :",
    options: [
      "L’exercice des libertés publiques",
      "Une simple tolérance administrative",
      "Une faveur personnelle",
    ],
    answer: "L’exercice des libertés publiques",
    explanation: "Le cours mentionne expressément les libertés publiques.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Exclusion",
    question:
        "Ne constitue pas un refus du bénéfice d’un droit accordé par la loi :",
    options: [
      "L’exercice d’un pouvoir discrétionnaire (ex : attribution d’une distinction)",
      "Le refus d’un document obligatoire",
      "Le refus d’un droit social",
    ],
    answer:
        "L’exercice d’un pouvoir discrétionnaire (ex : attribution d’une distinction)",
    explanation: "Cass. crim., 17 juin 2008.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Discriminations — Entrave économique",
    question: "L’entrave à une activité économique peut résulter :",
    options: [
      "De tracasseries administratives ou de pressions",
      "Uniquement d’une interdiction formelle",
      "Uniquement d’une condamnation judiciaire",
    ],
    answer: "De tracasseries administratives ou de pressions",
    explanation: "Le cours cite les tracasseries, pressions, dénigrement.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Victime",
    question:
        "Les discriminations réprimées par l’article 432-7 peuvent viser :",
    options: [
      "Une personne physique ou une personne morale",
      "Uniquement une personne physique",
      "Uniquement une entreprise",
    ],
    answer: "Une personne physique ou une personne morale",
    explanation: "Le cours précise que les deux sont visées.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Élément moral",
    question: "La discrimination suppose :",
    options: [
      "La conscience de se livrer à des agissements discriminatoires",
      "Une simple négligence",
      "Un résultat préjudiciable",
    ],
    answer: "La conscience de se livrer à des agissements discriminatoires",
    explanation: "L’élément moral est une volonté discriminatoire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Fait justificatif",
    question:
        "La répression est écartée lorsque les agissements discriminatoires sont :",
    options: [
      "Conformes à un texte légal autorisant ces agissements",
      "Motivés par une urgence",
      "Justifiés moralement",
    ],
    answer: "Conformes à un texte légal autorisant ces agissements",
    explanation: "Exemple : directives gouvernementales prévues par la loi.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Discriminations — Tentative",
    question: "La tentative de discrimination est :",
    options: [
      "Non incriminée",
      "Incriminée",
      "Incriminée uniquement en cas de récidive",
    ],
    answer: "Non incriminée",
    explanation: "Le cours précise expressément : tentative non incriminée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Complicité",
    question: "La complicité de discrimination est punissable :",
    options: [
      "Conformément aux articles 121-6 et 121-7 du Code pénal",
      "Uniquement pour les personnes morales",
      "Uniquement en cas de violence",
    ],
    answer: "Conformément aux articles 121-6 et 121-7 du Code pénal",
    explanation: "Régime classique de la complicité pénale.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 432-9 — ATTEINTE AU SECRET DES CORRESPONDANCES (ENCORE)
  // =========================================================
  const QuizQuestion(
    category: "Secret des correspondances — Réseau ouvert au public",
    question:
        "Un réseau ouvert au public de communications électroniques est un réseau :",
    options: [
      "Établi ou utilisé pour fournir au public des services de communications électroniques",
      "Réservé uniquement aux forces de l’ordre",
      "Exclusivement interne à une entreprise privée",
    ],
    answer:
        "Établi ou utilisé pour fournir au public des services de communications électroniques",
    explanation:
        "Définition reprise du code des postes et communications électroniques citée dans le cours.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Exemples de réseaux",
    question:
        "Sont cités comme pouvant être des réseaux de communications électroniques :",
    options: [
      "Réseaux satellitaires, terrestres et certains systèmes utilisant le réseau électrique",
      "Uniquement les réseaux téléphoniques filaires",
      "Uniquement la radio FM",
    ],
    answer:
        "Réseaux satellitaires, terrestres et certains systèmes utilisant le réseau électrique",
    explanation: "Le cours énumère ces exemples de réseaux.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Auteur (agent de réseau)",
    question:
        "Pour être auteur en tant qu’agent d’un exploitant de réseau ouvert au public, il faut :",
    options: [
      "Travailler pour une personne physique ou morale exploitant ce réseau, salariée ou non",
      "Être obligatoirement cadre dirigeant",
      "Être exclusivement fonctionnaire",
    ],
    answer:
        "Travailler pour une personne physique ou morale exploitant ce réseau, salariée ou non",
    explanation:
        "Le cours précise que cela vise toute personne relevant de l’autorité de l’exploitant, salariée ou non.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Fournisseur télécoms",
    question:
        "Un agent d’un fournisseur de services de télécommunications est :",
    options: [
      "Toute personne travaillant pour une personne physique ou morale qui assure une fourniture de services",
      "Uniquement un agent public",
      "Uniquement un sous-traitant indépendant hors entreprise",
    ],
    answer:
        "Toute personne travaillant pour une personne physique ou morale qui assure une fourniture de services",
    explanation:
        "Définition large donnée par le cours : salariée ou non, quelle que soit la position.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Peu importe le contenu",
    question: "Pour 432-9, le contenu de la correspondance :",
    options: [
      "Est indifférent : privé ou professionnel",
      "Doit être uniquement privé",
      "Doit être uniquement professionnel",
    ],
    answer: "Est indifférent : privé ou professionnel",
    explanation:
        "Le cours précise que peu importe le contenu : privé ou professionnel.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Moment de protection",
    question:
        "Une correspondance par télécommunications est protégée lorsqu’elle est :",
    options: [
      "En cours de transmission ou arrivée à destination mais non encore appréhendée",
      "Uniquement avant envoi",
      "Uniquement après lecture par le destinataire",
    ],
    answer:
        "En cours de transmission ou arrivée à destination mais non encore appréhendée",
    explanation: "Condition exacte rappelée dans le cours.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Détournement (mail)",
    question: "Le détournement d’un courrier électronique peut consister à :",
    options: [
      "Dévier le mail vers une autre boîte que celle du destinataire",
      "Supprimer le mail de sa propre boîte",
      "Répondre au mail",
    ],
    answer: "Dévier le mail vers une autre boîte que celle du destinataire",
    explanation: "Exemple de manipulation informatique cité dans le cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Divulgation (tiers)",
    question: "Effectue une divulgation le tiers qui :",
    options: [
      "Transmet à autrui un e-mail qu’il a réussi à intercepter",
      "Supprime un e-mail intercepté",
      "Avertit le destinataire qu’il a été intercepté",
    ],
    answer: "Transmet à autrui un e-mail qu’il a réussi à intercepter",
    explanation: "Le cours donne cet exemple pour qualifier la divulgation.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Complicité",
    question:
        "Un particulier peut être complice d’un dépositaire de l’autorité publique (432-9) s’il :",
    options: [
      "Fournit les moyens matériels pour intercepter ou détourner une correspondance",
      "Se contente d’entendre parler des faits",
      "Refuse de témoigner",
    ],
    answer:
        "Fournit les moyens matériels pour intercepter ou détourner une correspondance",
    explanation:
        "Le cours indique qu’un particulier peut se rendre complice en fournissant des moyens.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Élément intentionnel (Cass.)",
    question:
        "Selon la jurisprudence citée (27 février 2018), l’élément intentionnel implique :",
    options: [
      "L’intention de porter atteinte au contenu des correspondances litigieuses",
      " provenir d’un dommage effectif",
      "Une intention de nuire obligatoire",
    ],
    answer:
        "L’intention de porter atteinte au contenu des correspondances litigieuses",
    explanation:
        "Le cours cite : intention de porter atteinte au contenu (sans exigence d’intention de nuire).",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Circonstances aggravantes",
    question: "Pour l’infraction 432-9, les circonstances aggravantes sont :",
    options: [
      "Aucune",
      "Toujours présentes si télécommunications",
      "Présentes si la correspondance est privée",
    ],
    answer: "Aucune",
    explanation: "Le cours indique : IV - Circonstances aggravantes : AUCUNE.",
    difficulty: "Facile",
  ),

  // =========================================================
  // 432-7 — DISCRIMINATIONS (ENCORE)
  // =========================================================
  const QuizQuestion(
    category: "Discriminations — Définition (2 branches)",
    question: "L’article 432-7 vise deux types d’actes discriminatoires :",
    options: [
      "Refuser un droit accordé par la loi / Entraver une activité économique",
      "Refuser un droit / Intercepter un courrier",
      "Entraver une activité économique / Violer un domicile",
    ],
    answer:
        "Refuser un droit accordé par la loi / Entraver une activité économique",
    explanation: "Le texte liste expressément 1° et 2°.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Droit accordé par la loi",
    question: "Le mot « loi » au sens de 432-7 doit être compris comme :",
    options: [
      "Toute règle de portée générale et impersonnelle",
      "Uniquement une loi parlementaire",
      "Uniquement un arrêté municipal",
    ],
    answer: "Toute règle de portée générale et impersonnelle",
    explanation: "Le cours précise que la notion n’est pas restrictive.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Discriminations — Exemples de droits",
    question:
        "Parmi les exemples de « droit accordé par la loi » cités par le cours :",
    options: [
      "Prestation sociale, document administratif, inscription à un concours, mutation, congé",
      "Uniquement un logement de fonction",
      "Uniquement une prime",
    ],
    answer:
        "Prestation sociale, document administratif, inscription à un concours, mutation, congé",
    explanation: "Liste d’exemples donnée dans le cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Ne constitue pas un droit",
    question: "Ne constitue pas un « droit accordé par la loi » :",
    options: [
      "Une distinction attribuée à la discrétion d’un fonctionnaire",
      "Une prestation sociale prévue par un texte",
      "Une liberté publique prévue par un texte",
    ],
    answer: "Une distinction attribuée à la discrétion d’un fonctionnaire",
    explanation:
        "Le cours précise qu’un pouvoir discrétionnaire (ex : distinction) n’est pas un droit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Discriminations — Entrave économique (formes)",
    question:
        "Selon le cours, l’entrave à une activité économique peut résulter de :",
    options: [
      "Tracasseries administratives, dénigrement, pressions auprès de fournisseurs",
      "Uniquement d’une fermeture administrative",
      "Uniquement d’une condamnation pénale",
    ],
    answer:
        "Tracasseries administratives, dénigrement, pressions auprès de fournisseurs",
    explanation: "Exemples explicitement donnés dans le cours.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Victime",
    question:
        "Les agissements discriminatoires peuvent être commis au détriment :",
    options: [
      "D’une personne physique ou des membres d’une personne morale",
      "Uniquement d’une personne physique",
      "Uniquement d’une personne morale",
    ],
    answer: "D’une personne physique ou des membres d’une personne morale",
    explanation: "Le cours vise les deux hypothèses.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Élément moral",
    question: "La volonté discriminatoire se caractérise par :",
    options: [
      "La conscience de se livrer à des agissements discriminatoires",
      "La simple maladresse",
      "Le fait que la victime se sente discriminée",
    ],
    answer: "La conscience de se livrer à des agissements discriminatoires",
    explanation: "L’élément moral est une conscience/volonté discriminatoire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Circonstances aggravantes",
    question: "Pour 432-7, les circonstances aggravantes sont :",
    options: [
      "Aucune",
      "Toujours présentes en cas de pluralité de victimes",
      "Présentes si la discrimination est publique",
    ],
    answer: "Aucune",
    explanation: "Le cours indique : IV - Circonstances aggravantes : AUCUNE.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Répression",
    question: "Les peines principales encourues pour 432-7 sont :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "3 ans d’emprisonnement et 45 000 € d’amende",
      "2 ans d’emprisonnement et 30 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Le cours fixe la répression à 5 ans et 75 000 €.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Tentative",
    question: "La tentative en matière de discrimination (432-7) est :",
    options: [
      "Non incriminée",
      "Incriminée",
      "Incriminée si l’entrave est économique",
    ],
    answer: "Non incriminée",
    explanation: "Le cours précise : tentative non incriminée.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Complicité",
    question: "La complicité de discrimination suppose :",
    options: [
      "Aide/assistance, provocation ou instructions données (121-6/121-7)",
      "Uniquement l’accord moral",
      "Uniquement une présence sur place",
    ],
    answer:
        "Aide/assistance, provocation ou instructions données (121-6/121-7)",
    explanation: "Rappel du régime de complicité évoqué dans le cours.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 432-9 — ATTEINTE AU SECRET DES CORRESPONDANCES (APPROFONDISSEMENT)
  // =========================================================
  const QuizQuestion(
    category: "Secret des correspondances — Moment de l’atteinte",
    question:
        "L’atteinte au secret des correspondances peut être constituée même si :",
    options: [
      "La correspondance n’a pas encore été lue par son destinataire",
      "La correspondance est déjà lue par son destinataire",
      "La correspondance est détruite par son auteur",
    ],
    answer: "La correspondance n’a pas encore été lue par son destinataire",
    explanation:
        "Le cours précise que les correspondances sont protégées tant qu’elles ne sont pas appréhendées par leur destinataire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Support",
    question:
        "Pour les correspondances télécoms, l’absence de support matériel implique que :",
    options: [
      "L’atteinte porte sur le flux de communication",
      "L’infraction ne peut jamais être constituée",
      "Seules les correspondances écrites sont protégées",
    ],
    answer: "L’atteinte porte sur le flux de communication",
    explanation:
        "Les correspondances dématérialisées sont protégées pendant leur transmission.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Enquête pénale",
    question:
        "Hors autorisation judiciaire, l’interception d’une correspondance dans le cadre d’une enquête constitue :",
    options: [
      "Une atteinte au secret des correspondances",
      "Un acte d’enquête régulier",
      "Un simple manquement disciplinaire",
    ],
    answer: "Une atteinte au secret des correspondances",
    explanation:
        "Les interceptions ne sont licites que dans les cas prévus par la loi (CPP).",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — CPP",
    question:
        "Les interceptions judiciaires de correspondances sont encadrées par :",
    options: [
      "Les articles 100 à 100-8 du Code de procédure pénale",
      "L’article 432-9 du Code pénal",
      "Le Code civil",
    ],
    answer: "Les articles 100 à 100-8 du Code de procédure pénale",
    explanation: "Référence expresse citée dans le cours.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — JLD",
    question:
        "Dans certaines enquêtes, les interceptions peuvent être autorisées par :",
    options: [
      "Le juge des libertés et de la détention",
      "Le maire",
      "Le préfet seul",
    ],
    answer: "Le juge des libertés et de la détention",
    explanation:
        "Le cours vise les autorisations dans le cadre des enquêtes de flagrance/préliminaire.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Utilisation interne",
    question:
        "Se servir du contenu d’une correspondance interceptée à des fins personnelles constitue :",
    options: [
      "Une utilisation réprimée par l’article 432-9",
      "Un fait justificatif",
      "Une simple indiscrétion",
    ],
    answer: "Une utilisation réprimée par l’article 432-9",
    explanation: "L’utilisation est une modalité autonome de l’atteinte.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Qualité de la victime",
    question: "La qualité de la victime est indifférente car :",
    options: [
      "Toute correspondance est protégée, quel que soit son auteur ou destinataire",
      "Seules les correspondances privées sont protégées",
      "Seules les correspondances professionnelles sont protégées",
    ],
    answer:
        "Toute correspondance est protégée, quel que soit son auteur ou destinataire",
    explanation:
        "Le cours précise que le contenu et la qualité des personnes importent peu.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Absence de préjudice",
    question: "L’absence de préjudice pour la victime :",
    options: [
      "N’empêche pas la constitution de l’infraction",
      "Écarte systématiquement l’infraction",
      "Transforme le délit en contravention",
    ],
    answer: "N’empêche pas la constitution de l’infraction",
    explanation: "L’infraction est formelle : le préjudice n’est pas exigé.",
    difficulty: "Moyenne",
  ),

  // =========================================================
  // 432-7 — DISCRIMINATIONS (APPROFONDISSEMENT)
  // =========================================================
  const QuizQuestion(
    category: "Discriminations — Principe d’égalité",
    question:
        "L’infraction de discrimination sanctionne une atteinte au principe :",
    options: [
      "D’égalité devant la loi et le service public",
      "De hiérarchie administrative",
      "De continuité du service public",
    ],
    answer: "D’égalité devant la loi et le service public",
    explanation: "La discrimination porte atteinte au principe d’égalité.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Situation de famille",
    question:
        "Refuser un droit en raison de la situation de famille constitue :",
    options: [
      "Une discrimination pénalement réprimée",
      "Une simple erreur administrative",
      "Un fait justificatif",
    ],
    answer: "Une discrimination pénalement réprimée",
    explanation: "La situation de famille figure parmi les critères prohibés.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Langue",
    question:
        "La capacité à s’exprimer dans une langue autre que le français peut constituer :",
    options: [
      "Un critère prohibé de discrimination",
      "Un critère toujours légitime",
      "Un critère disciplinaire",
    ],
    answer: "Un critère prohibé de discrimination",
    explanation: "Ce critère est expressément visé par les textes.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Discriminations — Lanceur d’alerte",
    question:
        "Le fait de discriminer une personne en raison de sa qualité de lanceur d’alerte est :",
    options: [
      "Pénalement réprimé",
      "Autorisé en cas de trouble",
      "Un simple manquement déontologique",
    ],
    answer: "Pénalement réprimé",
    explanation: "La qualité de lanceur d’alerte est expressément protégée.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Discriminations — Absence de droit",
    question: "Si aucun droit n’est accordé par la loi, il ne peut y avoir :",
    options: [
      "Discrimination pénale au sens de l’article 432-7",
      "Responsabilité pénale",
      "Responsabilité disciplinaire",
    ],
    answer: "Discrimination pénale au sens de l’article 432-7",
    explanation: "L’existence d’un droit légal est une condition essentielle.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Activité économique (preuve)",
    question:
        "Pour caractériser l’entrave à une activité économique, il suffit de démontrer que :",
    options: [
      "L’exercice de l’activité a été rendu plus difficile",
      "L’activité a cessé totalement",
      "Un préjudice financier chiffré existe",
    ],
    answer: "L’exercice de l’activité a été rendu plus difficile",
    explanation: "La cessation ou le préjudice chiffré ne sont pas exigés.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Motivation",
    question: "Une motivation administrative apparemment neutre peut :",
    options: [
      "Dissimuler une discrimination",
      "Écarter toute discrimination",
      "Supprimer l’élément moral",
    ],
    answer: "Dissimuler une discrimination",
    explanation:
        "La volonté discriminatoire peut être déduite des circonstances.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Discriminations — Absence d’intention",
    question: "Si l’auteur n’a pas conscience de discriminer :",
    options: [
      "L’infraction n’est pas constituée",
      "L’infraction est automatique",
      "La peine est aggravée",
    ],
    answer: "L’infraction n’est pas constituée",
    explanation: "L’élément moral exige une conscience discriminatoire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Personnes morales",
    question:
        "Les personnes morales peuvent être reconnues responsables de discrimination :",
    options: ["Oui", "Non", "Uniquement en matière contraventionnelle"],
    answer: "Oui",
    explanation:
        "Le cours précise que la responsabilité pénale des personnes morales peut être retenue.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Finalité",
    question: "La répression de la discrimination vise principalement à :",
    options: [
      "Garantir l’égalité d’accès aux droits et aux activités",
      "Sanctionner les erreurs administratives",
      "Assurer l’efficacité des services publics",
    ],
    answer: "Garantir l’égalité d’accès aux droits et aux activités",
    explanation:
        "La finalité est la protection de l’égalité et des droits fondamentaux.",
    difficulty: "Facile",
  ),

  // =========================================================
  // 432-9 — ATTEINTE AU SECRET DES CORRESPONDANCES (NIVEAU EXPERT)
  // =========================================================
  const QuizQuestion(
    category: "Secret des correspondances — Infraction formelle",
    question: "L’infraction prévue par l’article 432-9 est une infraction :",
    options: [
      "Formelle, ne nécessitant aucun résultat dommageable",
      "Matérielle, nécessitant un préjudice",
      "De résultat uniquement",
    ],
    answer: "Formelle, ne nécessitant aucun résultat dommageable",
    explanation: "Aucun préjudice n’est exigé : l’atteinte suffit.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Lecture partielle",
    question: "Le fait de lire partiellement une correspondance constitue :",
    options: [
      "Une atteinte au secret des correspondances",
      "Un acte non punissable",
      "Une tentative non incriminée",
    ],
    answer: "Une atteinte au secret des correspondances",
    explanation:
        "Toute prise de connaissance non autorisée du contenu est réprimée.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Professionnel / privé",
    question: "Une correspondance professionnelle est protégée :",
    options: [
      "Au même titre qu’une correspondance privée",
      "Uniquement si elle est confidentielle",
      "Uniquement si elle est personnelle",
    ],
    answer: "Au même titre qu’une correspondance privée",
    explanation: "Le contenu professionnel ou privé est indifférent.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Courrier arrivé",
    question:
        "Une correspondance arrivée à destination mais non encore ouverte :",
    options: [
      "Reste protégée pénalement",
      "N’est plus protégée",
      "Relève uniquement du droit civil",
    ],
    answer: "Reste protégée pénalement",
    explanation:
        "La protection cesse uniquement après appréhension par le destinataire.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Consentement du tiers",
    question: "Le consentement d’un tiers non destinataire :",
    options: [
      "N’a aucun effet juridique",
      "Autorise la lecture",
      "Supprime l’élément moral",
    ],
    answer: "N’a aucun effet juridique",
    explanation: "Seul le destinataire peut consentir.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Conservation",
    question:
        "La conservation d’une correspondance interceptée sans en révéler le contenu :",
    options: [
      "Peut constituer une atteinte",
      "N’est jamais punissable",
      "Est toujours justifiée",
    ],
    answer: "Peut constituer une atteinte",
    explanation:
        "Selon les circonstances, elle peut révéler une utilisation illicite.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Suppression",
    question:
        "La suppression d’une correspondance empêchement sa réception constitue :",
    options: [
      "Une atteinte au secret des correspondances",
      "Un simple dysfonctionnement",
      "Une tentative non punissable",
    ],
    answer: "Une atteinte au secret des correspondances",
    explanation: "La suppression est expressément visée par le texte.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Secret des correspondances — Autorité hiérarchique",
    question:
        "L’ordre donné par un supérieur hiérarchique n’exonère pas l’exécutant :",
    options: [
      "De sa responsabilité pénale",
      "De toute responsabilité",
      "Uniquement disciplinaire",
    ],
    answer: "De sa responsabilité pénale",
    explanation: "L’ordre illégal n’est pas justificatif.",
    difficulty: "Difficile",
  ),

  // =========================================================
  // 432-7 — DISCRIMINATIONS (NIVEAU EXPERT)
  // =========================================================
  const QuizQuestion(
    category: "Discriminations — Infraction intentionnelle",
    question:
        "La discrimination prévue par l’article 432-7 est une infraction :",
    options: ["Intentionnelle", "Non intentionnelle", "De négligence"],
    answer: "Intentionnelle",
    explanation: "Elle suppose une volonté discriminatoire consciente.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Neutralité apparente",
    question:
        "Une décision apparemment neutre peut constituer une discrimination si :",
    options: [
      "Elle est fondée sur un critère prohibé",
      "Elle est écrite correctement",
      "Elle est prise collectivement",
    ],
    answer: "Elle est fondée sur un critère prohibé",
    explanation:
        "La forme de la décision n’écarte pas l’intention discriminatoire.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Discriminations — Charge de travail",
    question:
        "Alourdir volontairement la charge administrative d’un professionnel pour un motif discriminatoire constitue :",
    options: [
      "Une entrave à l’exercice d’une activité économique",
      "Un simple contrôle",
      "Un fait justificatif",
    ],
    answer: "Une entrave à l’exercice d’une activité économique",
    explanation: "Rendre l’activité plus difficile suffit.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Dénigrement",
    question:
        "Le dénigrement d’un professionnel auprès de ses partenaires peut caractériser :",
    options: [
      "Une discrimination par entrave économique",
      "Une simple opinion",
      "Un fait non répréhensible",
    ],
    answer: "Une discrimination par entrave économique",
    explanation: "Le cours cite expressément le dénigrement.",
    difficulty: "Moyenne",
  ),
  const QuizQuestion(
    category: "Discriminations — Absence de texte",
    question:
        "En l’absence de texte accordant un droit, la qualification de discrimination :",
    options: [
      "N’est pas possible pénalement",
      "Est automatique",
      "Est présumée",
    ],
    answer: "N’est pas possible pénalement",
    explanation: "L’existence d’un droit légal est indispensable.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Discriminations — Critère multiple",
    question: "Une discrimination peut être fondée sur :",
    options: [
      "Un ou plusieurs critères prohibés",
      "Un seul critère",
      "Uniquement l’origine",
    ],
    answer: "Un ou plusieurs critères prohibés",
    explanation: "La pluralité de critères n’exclut pas l’infraction.",
    difficulty: "Facile",
  ),
  const QuizQuestion(
    category: "Discriminations — Personnes morales",
    question: "La responsabilité pénale d’une personne morale suppose :",
    options: [
      "Une infraction commise pour son compte par un organe ou représentant",
      "Une faute personnelle du dirigeant",
      "Une condamnation préalable d’un salarié",
    ],
    answer:
        "Une infraction commise pour son compte par un organe ou représentant",
    explanation:
        "Application du droit commun de la responsabilité pénale des personnes morales.",
    difficulty: "Difficile",
  ),
  const QuizQuestion(
    category: "Discriminations — But poursuivi",
    question: "Le but poursuivi par l’auteur est :",
    options: [
      "Indifférent dès lors que le critère discriminatoire est établi",
      "Toujours déterminant",
      "Toujours exonératoire",
    ],
    answer: "Indifférent dès lors que le critère discriminatoire est établi",
    explanation: "Le mobile n’efface pas la discrimination.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizCrimesDelitsNationPA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName =
      '/pa/crime_delit_nation_pages/quiz/pa_quiz_crimes_delits_nation';
  final String uid;
  final String email;

  const QuizCrimesDelitsNationPA({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizCrimesDelitsNationPA> createState() => _QuizCrimesDelitsNationPAState();
}

class _QuizCrimesDelitsNationPAState extends State<QuizCrimesDelitsNationPA>
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
  static const _introHiddenKey = 'intro_pa_crimes_delits_nation';
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
        ? questionCrimesDelitsNation
        : questionCrimesDelitsNation
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
            'quiz_name': 'Crimes & délits contre la nation',
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
      await _sb.from('quiz_crimes_delits_nation').insert({
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
      debugPrint('❌ quiz_crimes_delits_nation insert failed: $e');
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
      'source_file': 'pa_quiz_crimes_delits_nation',
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
                            icon: Icons.flag_rounded,
                            title: 'Crimes contre la nation',
                            description: 'Étudie les infractions contre les intérêts fondamentaux de la nation : trahison, espionnage, terrorisme et atteintes aux institutions.',
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
