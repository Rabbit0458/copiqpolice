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

final List<QuizQuestion> questionsStupefiants = [
  QuizQuestion(
    category: "Stupéfiants — Conventions internationales",
    question:
        "La lutte internationale contre les stupéfiants repose notamment sur :",
    options: [
      "Trois conventions internationales adoptées en 1961, 1971 et 1988",
      "Une seule convention européenne",
      "Des accords bilatéraux entre États",
    ],
    answer: "Trois conventions internationales adoptées en 1961, 1971 et 1988",
    explanation:
        "Conventions de 1961 (stupéfiants), 1971 (psychotropes) et 1988 (trafic).",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Trafic de stupéfiants — Cession ou offre",
    question:
        "La cession ou l’offre illicite de stupéfiants en vue de la consommation personnelle est réprimée par :",
    options: [
      "L’article 222-39 du code pénal",
      "L’article 222-37 du code pénal",
      "L’article L.3421-1 du code de la santé publique",
    ],
    answer: "L’article 222-39 du code pénal",
    explanation:
        "L’article 222-39 CP vise spécifiquement la cession ou l’offre à un consommateur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Élément matériel",
    question: "L’offre de stupéfiants correspond :",
    options: [
      "À l’instant qui précède la remise du produit",
      "À la remise effective du produit",
      "À l’achat de stupéfiants",
    ],
    answer: "À l’instant qui précède la remise du produit",
    explanation: "L’offre existe même sans remise matérielle du produit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Élément matériel",
    question: "La cession de stupéfiants signifie que :",
    options: [
      "Le produit a changé de mains",
      "Le produit est proposé sans remise",
      "Le produit est uniquement transporté",
    ],
    answer: "Le produit a changé de mains",
    explanation: "La transaction est déjà réalisée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Nature de la transaction",
    question: "Le caractère onéreux ou gratuit de la cession est :",
    options: [
      "Indifférent pour la qualification pénale",
      "Obligatoirement onéreux",
      "Exclu s’il est gratuit",
    ],
    answer: "Indifférent pour la qualification pénale",
    explanation:
        "La loi ne distingue pas selon le caractère désintéressé ou non.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Auteur",
    question: "L’auteur de la cession peut être :",
    options: [
      "Un usager cherchant à financer sa propre consommation",
      "Uniquement un trafiquant professionnel",
      "Uniquement un grossiste",
    ],
    answer: "Un usager cherchant à financer sa propre consommation",
    explanation: "Les « petits dealers » sont visés par l’article 222-39 CP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Élément moral",
    question: "La cession ou l’offre illicite de stupéfiants suppose :",
    options: [
      "Une connaissance du caractère stupéfiant du produit",
      "Une simple négligence",
      "Une imprudence",
    ],
    answer: "Une connaissance du caractère stupéfiant du produit",
    explanation: "L’infraction est intentionnelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Circonstance aggravante",
    question: "La cession ou l’offre est aggravée lorsqu’elle est commise :",
    options: [
      "À l’égard de mineurs ou dans des établissements scolaires",
      "Entre majeurs consentants",
      "À domicile",
    ],
    answer: "À l’égard de mineurs ou dans des établissements scolaires",
    explanation: "Article 222-39 al.2 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Peines",
    question: "La cession ou l’offre simple de stupéfiants est punie de :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "10 ans d’emprisonnement et 7 500 000 € d’amende",
      "1 an d’emprisonnement",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Article 222-39 al.1 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Tentative",
    question:
        "La tentative de cession ou d’offre illicite de stupéfiants est :",
    options: ["Punissable", "Non punissable", "Contraventionnelle"],
    answer: "Punissable",
    explanation: "Article 222-40 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Complicité",
    question:
        "La complicité de cession ou d’offre illicite de stupéfiants est :",
    options: [
      "Punissable selon les articles 121-6 et 121-7 du code pénal",
      "Exclue",
      "Punissable uniquement pour les crimes",
    ],
    answer: "Punissable selon les articles 121-6 et 121-7 du code pénal",
    explanation: "Aide, assistance, provocation ou instructions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Réduction de peine",
    question: "Une réduction de peine est possible si l’auteur :",
    options: [
      "Permet de faire cesser les agissements ou d’identifier les complices",
      "Avoue spontanément sans autre condition",
      "Est primo-délinquant",
    ],
    answer:
        "Permet de faire cesser les agissements ou d’identifier les complices",
    explanation: "Article 222-43 CP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Exemption de peine",
    question: "Une exemption de peine est possible lorsque l’auteur :",
    options: [
      "A averti les autorités avant la commission de l’infraction",
      "A déjà été condamné",
      "A agi seul",
    ],
    answer: "A averti les autorités avant la commission de l’infraction",
    explanation: "Article 222-43-1 CP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Transport",
    question: "Le transport illicite de stupéfiants correspond :",
    options: [
      "Au fait de déplacer des stupéfiants sans autorisation",
      "À la seule importation",
      "À l’usage personnel",
    ],
    answer: "Au fait de déplacer des stupéfiants sans autorisation",
    explanation: "Article 222-37 al.1 CP.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Trafic de stupéfiants — Détention et usage personnel",
    question:
        "Selon la jurisprudence (Cass. crim., 14 mars 2017), la détention de 3 g de cannabis pour consommation personnelle relève plutôt :",
    options: [
      "De l’usage illicite de stupéfiants",
      "De la détention illicite de stupéfiants (trafic)",
      "D’une infraction inexistante",
    ],
    answer: "De l’usage illicite de stupéfiants",
    explanation:
        "La détention nécessaire à l’usage ne suffit pas : la détention (222-37) est réservée aux hypothèses de trafic ou à l’article 222-39.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Détention sans port sur soi",
    question:
        "La détention de stupéfiants peut être retenue même si les produits ne sont pas sur la personne, par exemple :",
    options: [
      "S’ils sont dans une cache proche connue de l’intéressé",
      "Uniquement s’ils sont dans la poche",
      "Uniquement s’ils sont dans un véhicule en marche",
    ],
    answer: "S’ils sont dans une cache proche connue de l’intéressé",
    explanation:
        "La détention peut être caractérisée si l’intéressé sait où se trouvent les stupéfiants et en a la maîtrise (ex : cache à quelques mètres).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Cumul transport/détention",
    question:
        "Être trouvé porteur de stupéfiants sur la voie publique caractérise :",
    options: [
      "À la fois le transport et la détention",
      "Uniquement l’usage",
      "Uniquement le recel",
    ],
    answer: "À la fois le transport et la détention",
    explanation:
        "La jurisprudence admet le cumul : port sur soi = détention et transport.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Emploi vs usage",
    question:
        "L’« emploi » de stupéfiants se distingue de l’usage car il vise :",
    options: [
      "Toute utilisation autre que la consommation (ex : couper des doses)",
      "Uniquement la prise par inhalation",
      "Uniquement la consommation répétée",
    ],
    answer:
        "Toute utilisation autre que la consommation (ex : couper des doses)",
    explanation:
        "L’emploi concerne l’utilisation du produit en dehors de l’absorption/consommation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Importation (définition)",
    question:
        "L’importation illicite de stupéfiants est constituée dès lors que :",
    options: [
      "L’intéressé pénètre ou tente de pénétrer sur le territoire national en possession de stupéfiants",
      "Les stupéfiants sont destinés à être vendus en France",
      "La quantité dépasse un seuil légal fixe",
    ],
    answer:
        "L’intéressé pénètre ou tente de pénétrer sur le territoire national en possession de stupéfiants",
    explanation:
        "Peu importe la destination finale alléguée : le franchissement/tentative avec stupéfiants suffit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Importation (destination)",
    question:
        "Si un prévenu affirme que la drogue importée était destinée à un autre pays, cela :",
    options: [
      "N’empêche pas la qualification d’importation sur le territoire national",
      "Supprime l’infraction",
      "Transforme l’infraction en simple usage",
    ],
    answer:
        "N’empêche pas la qualification d’importation sur le territoire national",
    explanation:
        "La qualification repose sur l’entrée/tentative d’entrée sur le territoire avec des stupéfiants.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Texte applicable import/export",
    question:
        "L’importation ou l’exportation illicites de stupéfiants sont réprimées par :",
    options: [
      "L’article 222-36 du code pénal",
      "L’article 222-39 du code pénal",
      "L’article L.3421-1 du code de la santé publique",
    ],
    answer: "L’article 222-36 du code pénal",
    explanation:
        "L’article 222-36 CP vise l’importation et l’exportation illicites de stupéfiants.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Bande organisée (import/export)",
    question:
        "Lorsque l’importation/exportation est commise en bande organisée, la qualification devient :",
    options: ["Crime", "Contravention", "Infraction purement administrative"],
    answer: "Crime",
    explanation:
        "L’article 222-36 al.2 CP prévoit l’aggravation en bande organisée, avec peines criminelles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Direction/organisation d’un trafic",
    question:
        "Diriger ou organiser un groupement ayant pour objet un trafic de stupéfiants est réprimé par :",
    options: [
      "L’article 222-34 du code pénal",
      "L’article 222-37 du code pénal",
      "L’article 321-6 du code pénal",
    ],
    answer: "L’article 222-34 du code pénal",
    explanation:
        "L’article 222-34 CP vise la direction/organisation d’un groupement dédié au trafic.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — 222-34 vs association de malfaiteurs",
    question:
        "La différence principale entre 222-34 CP et l’association de malfaiteurs est que 222-34 suppose :",
    options: [
      "La commission effective d’un trafic",
      "Un simple projet de trafic non réalisé",
      "Aucun acte matériel",
    ],
    answer: "La commission effective d’un trafic",
    explanation:
        "222-34 vise un trafic réalisé, alors que l’association de malfaiteurs peut exister avant la réalisation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Notion de groupement (222-34)",
    question: "Au sens de l’article 222-34 CP, un « groupement » désigne :",
    options: [
      "Un ensemble de personnes structuré, quelle que soit la forme (y compris société écran)",
      "Un individu seul avec du matériel",
      "Uniquement une association déclarée en préfecture",
    ],
    answer:
        "Un ensemble de personnes structuré, quelle que soit la forme (y compris société écran)",
    explanation:
        "Le groupement implique une structuration minimale car il doit être dirigé ou organisé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Membre simple du groupement",
    question:
        "Le seul fait d’être membre d’un groupement de trafic est, au titre de 222-34 CP :",
    options: [
      "Insuffisant : il faut diriger ou organiser",
      "Suffisant pour être auteur du crime",
      "Toujours non punissable",
    ],
    answer: "Insuffisant : il faut diriger ou organiser",
    explanation:
        "L’article 222-34 vise ceux qui dirigent ou organisent, pas le simple membre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Peine (222-34)",
    question:
        "La direction ou l’organisation d’un trafic de stupéfiants (222-34 CP) est punie de :",
    options: [
      "Réclusion criminelle à perpétuité et 7 500 000 € d’amende",
      "10 ans d’emprisonnement et 75 000 € d’amende",
      "1 an d’emprisonnement et 3 750 € d’amende",
    ],
    answer: "Réclusion criminelle à perpétuité et 7 500 000 € d’amende",
    explanation: "Article 222-34 CP : crime, avec période de sûreté.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Production (définition)",
    question: "La « production » de stupéfiants correspond notamment :",
    options: [
      "À la récolte/recueil de substances issues de plantes (opium, coca, cannabis, résine)",
      "À la vente au détail",
      "À la simple consommation",
    ],
    answer:
        "À la récolte/recueil de substances issues de plantes (opium, coca, cannabis, résine)",
    explanation:
        "La production vise les opérations de recueil des substances à partir des plantes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Fabrication (définition)",
    question: "La « fabrication » de stupéfiants correspond :",
    options: [
      "Aux opérations permettant d’obtenir des stupéfiants (purification, transformation…)",
      "À la détention pour usage",
      "À l’exportation uniquement",
    ],
    answer:
        "Aux opérations permettant d’obtenir des stupéfiants (purification, transformation…)",
    explanation:
        "La fabrication inclut notamment purification et transformation d’un stupéfiant en un autre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Texte production/fabrication",
    question:
        "La production ou la fabrication illicites de stupéfiants sont réprimées par :",
    options: [
      "L’article 222-35 du code pénal",
      "L’article 222-38 du code pénal",
      "L’article L.3421-4 du code de la santé publique",
    ],
    answer: "L’article 222-35 du code pénal",
    explanation: "Article 222-35 CP : production/fabrication illicites.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Aggravation production/fabrication",
    question:
        "La production ou fabrication est aggravée notamment lorsque les faits sont commis :",
    options: [
      "En bande organisée",
      "En réunion sur la voie publique",
      "Sans antécédent judiciaire",
    ],
    answer: "En bande organisée",
    explanation: "Article 222-35 al.2 CP : bande organisée = aggravation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Définition légale des stupéfiants",
    question: "Au sens légal, constituent des stupéfiants :",
    options: [
      "Les substances/plantes classées comme stupéfiants par la réglementation (CSP)",
      "Toute substance provoquant une dépendance",
      "Toute substance vendue dans la rue",
    ],
    answer:
        "Les substances/plantes classées comme stupéfiants par la réglementation (CSP)",
    explanation:
        "Article 222-41 CP renvoie au classement prévu par le code de la santé publique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Classement (autorité)",
    question: "Une substance est classée comme stupéfiant par décision :",
    options: [
      "Du directeur général de l’ANSM",
      "Du procureur de la République",
      "Du maire",
    ],
    answer: "Du directeur général de l’ANSM",
    explanation:
        "Le CSP prévoit le classement par décision du directeur général de l’Agence nationale de sécurité du médicament (ANSM).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Trafic de stupéfiants — Liste des substances",
    question:
        "L’infraction liée aux stupéfiants ne peut s’appliquer qu’à une substance :",
    options: [
      "Figurant sur une liste réglementaire (évolutive) des stupéfiants",
      "Ayant un effet relaxant prouvé médicalement",
      "Vendue sous forme de comprimés uniquement",
    ],
    answer: "Figurant sur une liste réglementaire (évolutive) des stupéfiants",
    explanation:
        "La définition légale renvoie au classement réglementaire : seules les substances classées comme stupéfiants sont visées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Obligation de précision (jurisprudence)",
    question:
        "Selon la jurisprudence (Cass. crim., 16 sept. 1985), un juge ne peut pas :",
    options: [
      "Viser des « substances stupéfiantes » sans préciser lesquelles",
      "Retenir l’intention coupable sans aveux",
      "Appliquer une peine d’amende",
    ],
    answer: "Viser des « substances stupéfiantes » sans préciser lesquelles",
    explanation:
        "La décision doit désigner suffisamment la substance : viser trop généralement est insuffisant.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Usage illicite — Définition",
    question: "L’usage illicite de stupéfiants s’entend comme :",
    options: [
      "La consommation/absorption, quel que soit le mode, public/privé, occasionnel/répété",
      "Uniquement l’injection en seringue",
      "Uniquement la consommation en public",
    ],
    answer:
        "La consommation/absorption, quel que soit le mode, public/privé, occasionnel/répété",
    explanation:
        "L’usage vise la consommation, peu importe le mode d’administration ou le contexte.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Usage illicite — Éléments pouvant être assimilés à l’usage",
    question:
        "Sont aussi considérés comme « usage » quand c’est destiné à l’usage exclusif de la personne :",
    options: [
      "L’acquisition, la détention ou le transport",
      "La vente à un tiers",
      "La direction d’un réseau",
    ],
    answer: "L’acquisition, la détention ou le transport",
    explanation:
        "Quand il est établi que c’est pour l’usage exclusif, ces actes peuvent être requalifiés en usage selon les critères (quantité, intoxication…).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Usage illicite — Texte applicable",
    question: "L’usage illicite de stupéfiants est réprimé par :",
    options: [
      "L’article L.3421-1 du code de la santé publique",
      "L’article 222-39 du code pénal",
      "L’article 222-38 du code pénal",
    ],
    answer: "L’article L.3421-1 du code de la santé publique",
    explanation: "Le CSP (L.3421-1) incrimine l’usage illicite de stupéfiants.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Usage illicite — Élément moral",
    question: "L’élément moral de l’usage illicite suppose :",
    options: [
      "Un usage intentionnel, en connaissance de cause",
      "Une simple imprudence",
      "Le fait d’être présent à côté d’un usager",
    ],
    answer: "Un usage intentionnel, en connaissance de cause",
    explanation:
        "La personne doit avoir conscience d’user d’un produit classé stupéfiant ; pas de sanction si consommation à l’insu ou traitement médical.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Usage illicite — Circonstance aggravante",
    question:
        "Les peines d’usage illicite sont aggravées notamment si l’infraction est commise :",
    options: [
      "Par une personne dépositaire de l’autorité publique dans l’exercice/à l’occasion de ses fonctions",
      "Uniquement par un mineur",
      "Uniquement dans un domicile privé",
    ],
    answer:
        "Par une personne dépositaire de l’autorité publique dans l’exercice/à l’occasion de ses fonctions",
    explanation:
        "L.3421-1 al.2 CSP : aggravation pour certaines professions/fonctions mettant en cause la sécurité ou l’autorité publique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Usage illicite — Peines (forme simple)",
    question:
        "Les peines encourues pour l’usage illicite (forme simple) sont :",
    options: [
      "1 an d’emprisonnement et 3 750 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "10 ans d’emprisonnement et 7 500 000 € d’amende",
    ],
    answer: "1 an d’emprisonnement et 3 750 € d’amende",
    explanation: "L.3421-1 al.1 CSP : 1 an et 3 750 €.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Usage illicite — Peines (forme aggravée)",
    question:
        "En cas de circonstance aggravante prévue à L.3421-1 al.2 CSP, les peines sont portées à :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "2 ans d’emprisonnement et 15 000 € d’amende",
      "10 ans d’emprisonnement et 75 000 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "L.3421-1 al.2 CSP : aggravation à 5 ans et 75 000 €.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Usage illicite — Tentative",
    question: "La tentative d’usage illicite de stupéfiants est :",
    options: [
      "Non punissable (non prévue)",
      "Toujours punissable",
      "Punissable uniquement en bande organisée",
    ],
    answer: "Non punissable (non prévue)",
    explanation:
        "La tentative de l’infraction d’usage n’est pas prévue : pas de répression de la tentative.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Usage illicite — Amende forfaitaire délictuelle (principe)",
    question: "L’usage illicite de stupéfiants peut faire l’objet :",
    options: [
      "D’une amende forfaitaire délictuelle (procédure spécifique)",
      "Uniquement d’un rappel à la loi",
      "Uniquement d’une peine criminelle",
    ],
    answer: "D’une amende forfaitaire délictuelle (procédure spécifique)",
    explanation:
        "L.3421-1 CSP ouvre la possibilité de recourir à la procédure d’amende forfaitaire délictuelle (CPP).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Usage illicite — AFD (exclusion)",
    question:
        "L’amende forfaitaire délictuelle est exclue lorsque l’usage est commis :",
    options: [
      "Dans l’exercice/à l’occasion des fonctions d’une personne dépositaire de l’autorité publique ou dans certaines fonctions de transport",
      "Par un usager occasionnel",
      "En réunion",
    ],
    answer:
        "Dans l’exercice/à l’occasion des fonctions d’une personne dépositaire de l’autorité publique ou dans certaines fonctions de transport",
    explanation:
        "L.3421-1 al.2 CSP : ces hypothèses aggravées sont exclues du champ de l’AFD.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Usage illicite — Dispositif thérapeutique (principe)",
    question:
        "Dans une procédure pour usage illicite, un traitement médical peut être :",
    options: [
      "Prescrit/ordonné à tous les stades de la procédure pénale (injonction thérapeutique)",
      "Uniquement proposé après condamnation définitive",
      "Impossible car l’usage est toujours traité uniquement par l’amende",
    ],
    answer:
        "Prescrit/ordonné à tous les stades de la procédure pénale (injonction thérapeutique)",
    explanation:
        "Le CSP prévoit des injonctions thérapeutiques possibles à différents stades (procureur, instruction, jugement…).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Cession/offre à usage personnel — Définition",
    question:
        "La cession ou l’offre illicites de stupéfiants « en vue de la consommation personnelle » vise principalement :",
    options: [
      "Les « petits dealers » vendant une ou quelques doses",
      "Uniquement les trafiquants internationaux",
      "Uniquement les médecins",
    ],
    answer: "Les « petits dealers » vendant une ou quelques doses",
    explanation:
        "Cette qualification cible la vente au détail à un usager (article 222-39 al.1 CP).",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cession/offre à usage personnel — Offre vs cession",
    question: "Dans ce cadre, l’« offre » correspond :",
    options: [
      "À l’instant qui précède la remise (proposition sans remise effectuée)",
      "Au produit déjà remis et payé",
      "À l’achat pour soi-même",
    ],
    answer:
        "À l’instant qui précède la remise (proposition sans remise effectuée)",
    explanation:
        "L’offre est avant la remise ; la cession implique que le produit a déjà changé de mains.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cession/offre à usage personnel — Caractère onéreux",
    question:
        "Pour l’article 222-39 CP, le caractère onéreux (payant) de la transaction :",
    options: [
      "Est indifférent (payant ou gratuit)",
      "Est indispensable",
      "Écarte toujours l’infraction",
    ],
    answer: "Est indifférent (payant ou gratuit)",
    explanation:
        "Le texte ne distingue pas : l’opération peut être désintéressée ou non.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Cession/offre à usage personnel — Circonstances aggravantes",
    question:
        "L’infraction de 222-39 al.2 CP est aggravée notamment lorsque l’offre/cession a lieu :",
    options: [
      "À des mineurs ou dans/aux abords d’établissements d’enseignement (entrées/sorties)",
      "Uniquement la nuit",
      "Uniquement sur internet",
    ],
    answer:
        "À des mineurs ou dans/aux abords d’établissements d’enseignement (entrées/sorties)",
    explanation:
        "222-39 al.2 CP : aggravation mineurs + établissements d’enseignement/éducation + locaux administration et abords.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Cession/offre à usage personnel — Peines (forme simple)",
    question: "Les peines encourues pour 222-39 al.1 CP (forme simple) sont :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "10 ans d’emprisonnement et 75 000 € d’amende",
      "1 an d’emprisonnement et 3 750 € d’amende",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "222-39 al.1 CP : délit, 5 ans et 75 000 €.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cession/offre à usage personnel — Peines (forme aggravée)",
    question:
        "Les peines encourues pour 222-39 al.2 CP (forme aggravée) sont :",
    options: [
      "10 ans d’emprisonnement et 75 000 € d’amende",
      "7 ans d’emprisonnement et 100 000 € d’amende",
      "20 ans de réclusion et 7 500 000 € d’amende",
    ],
    answer: "10 ans d’emprisonnement et 75 000 € d’amende",
    explanation:
        "222-39 al.2 CP : aggravation à 10 ans, 75 000 € (période de sûreté).",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Facilitation de l’usage — Définition",
    question:
        "Faciliter l’usage illicite de stupéfiants consiste notamment à :",
    options: [
      "Apporter une aide matérielle permettant la consommation",
      "Consommer soi-même des stupéfiants",
      "Importer des stupéfiants",
    ],
    answer: "Apporter une aide matérielle permettant la consommation",
    explanation:
        "Article 222-37 al.2 CP : il s’agit d’un acte facilitant l’usage, érigé en infraction autonome.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Facilitation de l’usage — Nature de l’infraction",
    question: "La facilitation de l’usage illicite est juridiquement :",
    options: [
      "Une infraction autonome",
      "Une simple complicité",
      "Une contravention",
    ],
    answer: "Une infraction autonome",
    explanation:
        "Le législateur a érigé cette forme de complicité en infraction distincte.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Facilitation de l’usage — Moyens",
    question: "Les moyens de facilitation de l’usage sont :",
    options: [
      "Non limitativement énumérés par la loi",
      "Limités aux locaux privés",
      "Limités aux professionnels de santé",
    ],
    answer: "Non limitativement énumérés par la loi",
    explanation: "Tout moyen matériel peut caractériser la facilitation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Facilitation de l’usage — Jurisprudence",
    question:
        "Permettre sciemment l’usage de stupéfiants dans un établissement ouvert au public constitue :",
    options: [
      "Le délit de facilitation de l’usage",
      "Une simple tolérance légale",
      "Un usage personnel",
    ],
    answer: "Le délit de facilitation de l’usage",
    explanation:
        "La jurisprudence retient la responsabilité du dirigeant ou exploitant.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Facilitation de l’usage — Ordonnances",
    question:
        "Délivrer sciemment des stupéfiants sur ordonnance fictive constitue :",
    options: [
      "Une facilitation de l’usage illicite",
      "Un usage illicite",
      "Un simple manquement disciplinaire",
    ],
    answer: "Une facilitation de l’usage illicite",
    explanation: "Article 222-37 al.2 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Facilitation de l’usage — Auteur",
    question:
        "Se faire délivrer des stupéfiants via ordonnance fictive vise pénalement :",
    options: [
      "Le toxicomane bénéficiaire",
      "Uniquement le pharmacien",
      "Uniquement le médecin",
    ],
    answer: "Le toxicomane bénéficiaire",
    explanation: "L’usager est aussi auteur de la facilitation par ce moyen.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Facilitation de l’usage — Élément moral",
    question: "L’élément moral de la facilitation suppose :",
    options: [
      "Une connaissance du caractère fictif ou illicite",
      "Une simple imprudence",
      "Une négligence",
    ],
    answer: "Une connaissance du caractère fictif ou illicite",
    explanation: "L’infraction est intentionnelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Facilitation de l’usage — Circonstance aggravante",
    question:
        "La facilitation est aggravée lorsqu’un majeur agit avec l’aide :",
    options: ["D’un mineur", "D’un majeur", "D’un professionnel de santé"],
    answer: "D’un mineur",
    explanation: "Article 222-37-1 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Facilitation de l’usage — Qualification aggravée",
    question: "La facilitation avec l’aide d’un mineur devient :",
    options: ["Un crime", "Une contravention", "Une infraction administrative"],
    answer: "Un crime",
    explanation: "Article 222-37-1 CP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Facilitation de l’usage — Peines simples",
    question: "La facilitation simple est punie de :",
    options: [
      "10 ans d’emprisonnement et 7 500 000 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "1 an d’emprisonnement",
    ],
    answer: "10 ans d’emprisonnement et 7 500 000 € d’amende",
    explanation: "Article 222-37 al.2 CP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Provocation — Définition",
    question: "La provocation à l’usage de stupéfiants est punissable :",
    options: [
      "Même si elle n’est pas suivie d’effet",
      "Uniquement si l’usage a lieu",
      "Uniquement sur mineur",
    ],
    answer: "Même si elle n’est pas suivie d’effet",
    explanation: "Article L.3421-4 CSP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Provocation — Formes",
    question: "La provocation peut prendre la forme :",
    options: [
      "D’une publicité ou d’une valorisation",
      "D’un usage personnel",
      "D’un transport",
    ],
    answer: "D’une publicité ou d’une valorisation",
    explanation: "Présenter l’usage sous un jour favorable suffit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Provocation — Produits factices",
    question:
        "Vendre des produits non toxiques présentés comme stupéfiants constitue :",
    options: [
      "Une provocation à l’usage",
      "Une infraction inexistante",
      "Un usage illicite",
    ],
    answer: "Une provocation à l’usage",
    explanation: "Même si le produit n’est pas réellement stupéfiant.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Provocation — Élément moral",
    question: "La provocation suppose :",
    options: [
      "Une volonté d’inciter ou de valoriser",
      "Une simple plaisanterie",
      "Un usage personnel",
    ],
    answer: "Une volonté d’inciter ou de valoriser",
    explanation: "L’intention peut résulter des circonstances.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Provocation — Circonstance aggravante",
    question: "La provocation est aggravée lorsqu’elle est commise :",
    options: [
      "Dans un établissement scolaire",
      "Dans un domicile privé",
      "Entre majeurs",
    ],
    answer: "Dans un établissement scolaire",
    explanation: "Article L.3421-4 al.3 CSP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Provocation — Presse",
    question: "Lorsque la provocation est commise par voie de presse :",
    options: [
      "Les règles spécifiques de la presse s’appliquent",
      "Elle est dépénalisée",
      "Elle devient une contravention",
    ],
    answer: "Les règles spécifiques de la presse s’appliquent",
    explanation: "Article L.3421-4 al.4 CSP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Provocation — Peines simples",
    question: "La provocation simple est punie de :",
    options: [
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "1 an d’emprisonnement",
      "10 ans d’emprisonnement",
    ],
    answer: "5 ans d’emprisonnement et 75 000 € d’amende",
    explanation: "Article L.3421-4 al.1 CSP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Blanchiment — Définition",
    question: "Le blanchiment du produit du trafic consiste à :",
    options: [
      "Dissimuler ou justifier frauduleusement l’origine des fonds",
      "Consommer des stupéfiants",
      "Importer des stupéfiants",
    ],
    answer: "Dissimuler ou justifier frauduleusement l’origine des fonds",
    explanation: "Article 222-38 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Blanchiment — Auteur",
    question: "Le blanchiment peut être retenu :",
    options: [
      "Même contre l’auteur de l’infraction d’origine",
      "Uniquement contre un tiers",
      "Uniquement contre un banquier",
    ],
    answer: "Même contre l’auteur de l’infraction d’origine",
    explanation: "La jurisprudence admet le cumul.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Blanchiment — Élément matériel",
    question:
        "Utiliser de fausses factures pour dissimuler des fonds constitue :",
    options: [
      "Un blanchiment",
      "Une simple fraude fiscale",
      "Un usage illicite",
    ],
    answer: "Un blanchiment",
    explanation: "Justification mensongère de l’origine des biens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Blanchiment — Circonstance aggravante",
    question: "Le blanchiment est aggravé lorsque les fonds proviennent :",
    options: [
      "D’un crime de trafic",
      "D’un simple usage",
      "D’une contravention",
    ],
    answer: "D’un crime de trafic",
    explanation: "Article 222-38 al.2 CP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Blanchiment — Peines simples",
    question: "Le blanchiment simple est puni de :",
    options: [
      "10 ans d’emprisonnement et 750 000 € d’amende",
      "5 ans d’emprisonnement",
      "20 ans de réclusion",
    ],
    answer: "10 ans d’emprisonnement et 750 000 € d’amende",
    explanation: "Article 222-38 al.1 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Blanchiment — Tentative",
    question: "La tentative de blanchiment est :",
    options: ["Punissable", "Non punissable", "Contraventionnelle"],
    answer: "Punissable",
    explanation: "Article 222-40 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic — Complicité",
    question: "La complicité en matière de stupéfiants suppose :",
    options: [
      "Aide, assistance, provocation ou instructions",
      "Une simple connaissance des faits",
      "Une abstention",
    ],
    answer: "Aide, assistance, provocation ou instructions",
    explanation: "Articles 121-6 et 121-7 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic — Réduction de peine",
    question: "La réduction de peine est possible si l’auteur :",
    options: [
      "Permet d’identifier les autres auteurs",
      "Nie les faits",
      "Est mineur",
    ],
    answer: "Permet d’identifier les autres auteurs",
    explanation: "Article 222-43 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic — Exemption",
    question: "L’exemption de peine est possible si l’auteur :",
    options: [
      "Permet d’éviter la commission de l’infraction",
      "A déjà été condamné",
      "Est récidiviste",
    ],
    answer: "Permet d’éviter la commission de l’infraction",
    explanation: "Article 222-43-1 CP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic — Classification",
    question: "La majorité des infractions de trafic de stupéfiants relèvent :",
    options: [
      "De la criminalité organisée",
      "Des contraventions",
      "Du droit administratif",
    ],
    answer: "De la criminalité organisée",
    explanation: "Article 706-73 CPP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic — Procédure",
    question: "Les infractions de trafic peuvent relever :",
    options: [
      "D’une procédure spéciale",
      "D’une procédure civile",
      "D’une procédure disciplinaire",
    ],
    answer: "D’une procédure spéciale",
    explanation: "Régime spécifique de la criminalité organisée.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Transport de stupéfiants — Définition",
    question: "Le transport de stupéfiants est constitué lorsque :",
    options: [
      "Une personne déplace des stupéfiants sans autorisation administrative",
      "Une personne consomme un stupéfiant",
      "Une personne détient un produit licite",
    ],
    answer:
        "Une personne déplace des stupéfiants sans autorisation administrative",
    explanation:
        "Le transport consiste à déplacer des stupéfiants, quel que soit le mode ou la distance.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Transport de stupéfiants — Cumul",
    question:
        "Le fait d’être trouvé porteur de stupéfiants sur la voie publique permet :",
    options: [
      "De retenir à la fois le transport et la détention",
      "De retenir uniquement l’usage",
      "D’exclure toute infraction",
    ],
    answer: "De retenir à la fois le transport et la détention",
    explanation: "La jurisprudence admet le cumul transport/détention.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention de stupéfiants — Notion",
    question: "La détention de stupéfiants suppose :",
    options: [
      "La possession ou la maîtrise du produit",
      "La consommation effective",
      "Le transport transfrontalier",
    ],
    answer: "La possession ou la maîtrise du produit",
    explanation: "La détention peut être caractérisée même sans port sur soi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Détention de stupéfiants — Cache",
    question:
        "Des stupéfiants cachés à proximité peuvent caractériser une détention si :",
    options: [
      "L’intéressé sait où ils se trouvent",
      "Ils appartiennent à un tiers",
      "Ils sont dissimulés hors du domicile",
    ],
    answer: "L’intéressé sait où ils se trouvent",
    explanation:
        "La connaissance et la maîtrise suffisent à caractériser la détention.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Détention — Usage personnel",
    question:
        "La détention de stupéfiants pour usage personnel est en principe :",
    options: [
      "Requalifiée en usage illicite",
      "Toujours un trafic",
      "Non punissable",
    ],
    answer: "Requalifiée en usage illicite",
    explanation:
        "La détention nécessaire à l’usage relève de l’article L.3421-1 CSP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Offre de stupéfiants — Définition",
    question: "L’offre de stupéfiants correspond :",
    options: [
      "À la proposition précédant la remise",
      "À la remise effective",
      "À la consommation collective",
    ],
    answer: "À la proposition précédant la remise",
    explanation:
        "L’offre précède la cession, sans transfert matériel du produit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cession de stupéfiants — Définition",
    question: "La cession de stupéfiants est caractérisée lorsque :",
    options: [
      "Le produit a changé de mains",
      "Le produit est simplement proposé",
      "Le produit est consommé",
    ],
    answer: "Le produit a changé de mains",
    explanation: "La transaction est réalisée : il y a transfert du produit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cession — Initiative",
    question: "Pour la cession de stupéfiants, il importe peu que :",
    options: [
      "L’auteur ait pris l’initiative ou répondu à une demande",
      "La cession soit répétée",
      "Le produit soit gratuit",
    ],
    answer: "L’auteur ait pris l’initiative ou répondu à une demande",
    explanation: "Le texte ne distingue pas selon l’initiative de l’opération.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Cession — Usage personnel",
    question: "La cession en vue de la consommation personnelle vise surtout :",
    options: [
      "La vente au détail à un usager",
      "Le trafic international",
      "La fabrication",
    ],
    answer: "La vente au détail à un usager",
    explanation: "Article 222-39 CP : qualification des « petits dealers ».",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Acquisition de stupéfiants — Définition",
    question: "L’acquisition de stupéfiants correspond :",
    options: [
      "Au fait de recevoir le produit après une offre ou une cession",
      "Au transport du produit",
      "À la culture",
    ],
    answer: "Au fait de recevoir le produit après une offre ou une cession",
    explanation: "L’acquisition est l’acte de celui qui obtient le produit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Emploi de stupéfiants — Distinction",
    question: "L’emploi de stupéfiants se distingue de l’usage car il vise :",
    options: [
      "Toute utilisation autre que la consommation",
      "Uniquement l’injection",
      "Uniquement l’inhalation",
    ],
    answer: "Toute utilisation autre que la consommation",
    explanation: "Exemple : couper des doses ou transformer le produit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Élément moral — Trafic",
    question: "Les infractions de trafic exigent :",
    options: [
      "Une intention et une connaissance du caractère illicite",
      "Une simple imprudence",
      "Une négligence",
    ],
    answer: "Une intention et une connaissance du caractère illicite",
    explanation:
        "L’intention coupable est requise pour les infractions de trafic.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Mineur — Rôle",
    question: "Le recours à un mineur dans un trafic constitue :",
    options: [
      "Une circonstance aggravante",
      "Une cause d’exonération",
      "Un fait neutre",
    ],
    answer: "Une circonstance aggravante",
    explanation: "Articles 222-35-1 et 222-37-1 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Mineur — Participation",
    question:
        "L’aide d’un mineur peut être caractérisée même si sa participation est :",
    options: ["Contrainte", "Rémunérée", "Ponctuelle"],
    answer: "Contrainte",
    explanation:
        "La loi vise toute intégration d’un mineur, volontaire ou non.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tentative — Trafic",
    question: "En matière de trafic de stupéfiants, la tentative est :",
    options: ["Punissable", "Non punissable", "Toujours contraventionnelle"],
    answer: "Punissable",
    explanation: "Article 222-40 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Complicité — Principe",
    question: "La complicité en matière de stupéfiants est punissable :",
    options: [
      "Dans les mêmes conditions que l’infraction principale",
      "Uniquement en cas de récidive",
      "Uniquement pour les crimes",
    ],
    answer: "Dans les mêmes conditions que l’infraction principale",
    explanation: "Articles 121-6 et 121-7 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Procédure — Criminalité organisée",
    question: "Les infractions de trafic de stupéfiants relèvent :",
    options: [
      "Du régime de la criminalité organisée",
      "Du droit disciplinaire",
      "Du contentieux administratif",
    ],
    answer: "Du régime de la criminalité organisée",
    explanation: "Article 706-73 CPP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Procédure — Conséquence",
    question: "Le rattachement à la criminalité organisée permet notamment :",
    options: [
      "Des techniques spéciales d’enquête",
      "La dépénalisation partielle",
      "La suppression des peines",
    ],
    answer: "Des techniques spéciales d’enquête",
    explanation: "Écoutes, infiltrations, surveillances, etc.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Personnes morales — Principe",
    question:
        "Les personnes morales peuvent être pénalement responsables en matière de stupéfiants :",
    options: ["Oui", "Non", "Uniquement pour l’usage"],
    answer: "Oui",
    explanation: "Article 222-42 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Personnes morales — Sanctions",
    question: "Les peines applicables aux personnes morales sont prévues par :",
    options: [
      "L’article 222-42 du code pénal",
      "L’article L.3421-1 CSP",
      "L’article 121-3 CP",
    ],
    answer: "L’article 222-42 du code pénal",
    explanation: "Il fixe les peines spécifiques aux personnes morales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Stupéfiants — Classement",
    question: "La liste des stupéfiants est dite :",
    options: ["Évolutive", "Définitive", "Jurisprudentielle"],
    answer: "Évolutive",
    explanation: "Le classement évolue selon les connaissances scientifiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Stupéfiants — Fondement",
    question: "Le classement des stupéfiants relève du :",
    options: ["Code de la santé publique", "Code du travail", "Code civil"],
    answer: "Code de la santé publique",
    explanation: "Article L.5132-7 CSP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Preuve — Substance",
    question: "Pour caractériser une infraction, la substance doit être :",
    options: [
      "Désignée avec précision",
      "Simplement supposée",
      "Évoquée de manière générale",
    ],
    answer: "Désignée avec précision",
    explanation: "La jurisprudence l’exige (Cass. crim., 16 sept. 1985).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Usage — Conscience",
    question: "Il n’y a pas usage illicite si la personne consomme :",
    options: ["À son insu", "En réunion", "À domicile"],
    answer: "À son insu",
    explanation: "L’usage suppose une consommation volontaire et consciente.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Usage — Traitement médical",
    question: "La consommation de stupéfiants dans un cadre médical :",
    options: [
      "N’est pas punissable",
      "Constitue toujours un délit",
      "Relève du trafic",
    ],
    answer: "N’est pas punissable",
    explanation: "Elle est licite lorsqu’elle est médicalement prescrite.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Usage — Caractère public/privé",
    question: "Le caractère public ou privé de l’usage :",
    options: [
      "Est indifférent",
      "Aggrave toujours l’infraction",
      "Supprime l’infraction",
    ],
    answer: "Est indifférent",
    explanation: "L’usage est réprimé quel que soit le lieu.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Usage — Fréquence",
    question: "L’usage illicite peut être sanctionné même s’il est :",
    options: ["Occasionnel", "Unique", "Collectif"],
    answer: "Occasionnel",
    explanation: "La répétition n’est pas exigée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Usage — Qualification",
    question: "L’usage illicite est juridiquement :",
    options: ["Un délit", "Une contravention", "Un crime"],
    answer: "Un délit",
    explanation: "Article L.3421-1 CSP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cession/offre à usage personnel — Tentative",
    question:
        "La tentative de l’infraction de cession/offre à usage personnel (222-39) est :",
    options: [
      "Punissable",
      "Non punissable",
      "Punissable uniquement si mineur",
    ],
    answer: "Punissable",
    explanation:
        "La tentative est prévue (article 222-40 CP) pour plusieurs infractions de trafic, dont 222-39.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic de stupéfiants — Détention",
    question: "La détention illicite de stupéfiants suppose :",
    options: [
      "Une détention s’inscrivant dans un trafic ou relevant de l’article 222-39",
      "Toute possession de stupéfiants",
      "Uniquement une détention en grande quantité",
    ],
    answer:
        "Une détention s’inscrivant dans un trafic ou relevant de l’article 222-39",
    explanation: "La détention pour usage personnel relève de l’usage.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Stupéfiants — Droit français",
    question:
        "La France a transposé les conventions internationales sur les stupéfiants :",
    options: [
      "Dans le code pénal et le code de la santé publique",
      "Uniquement dans le code pénal",
      "Uniquement dans le code de la santé publique",
    ],
    answer: "Dans le code pénal et le code de la santé publique",
    explanation: "Trafic : code pénal / Usage : code de la santé publique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Stupéfiants — Logique législative",
    question: "Le dispositif français distingue principalement :",
    options: [
      "Les usagers à soigner et les trafiquants à sanctionner",
      "Les consommateurs occasionnels et réguliers",
      "Les stupéfiants légers et lourds",
    ],
    answer: "Les usagers à soigner et les trafiquants à sanctionner",
    explanation: "Principe fondamental de la politique pénale française.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Définition légale — Stupéfiants",
    question: "Constituent des stupéfiants au sens pénal :",
    options: [
      "Les substances ou plantes classées comme stupéfiants par le code de la santé publique",
      "Toutes les substances ayant un effet psychotrope",
      "Les substances provoquant une dépendance",
    ],
    answer:
        "Les substances ou plantes classées comme stupéfiants par le code de la santé publique",
    explanation: "Article 222-41 CP et article L.5132-7 CSP.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Définition légale — Classement",
    question: "Le classement d’une substance comme stupéfiant relève :",
    options: [
      "D’une décision du directeur général de l’ANSM",
      "D’un juge pénal",
      "D’un arrêté préfectoral",
    ],
    answer: "D’une décision du directeur général de l’ANSM",
    explanation: "Article L.5132-7 du code de la santé publique.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Définition légale — Listes",
    question: "La liste des substances classées comme stupéfiants est :",
    options: [
      "Évolutive et fixée par voie réglementaire",
      "Fixe et définitive",
      "Déterminée par la jurisprudence",
    ],
    answer: "Évolutive et fixée par voie réglementaire",
    explanation: "Arrêté du 22 février 1990 et mises à jour ultérieures.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Jurisprudence — Qualification",
    question:
        "Un juge peut-il viser de manière générale des substances stupéfiantes sans les préciser ?",
    options: ["Non", "Oui", "Oui si la quantité est faible"],
    answer: "Non",
    explanation:
        "Cass. crim., 16 septembre 1985 : la substance doit être précisément désignée.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Usage illicite — Définition",
    question: "L’usage illicite de stupéfiants correspond :",
    options: [
      "À toute consommation ou absorption d’un produit classé stupéfiant",
      "Uniquement à la consommation répétée",
      "Uniquement à l’usage public",
    ],
    answer: "À toute consommation ou absorption d’un produit classé stupéfiant",
    explanation: "Article L.3421-1 CSP.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Usage illicite — Mode",
    question: "Le mode d’administration du stupéfiant :",
    options: [
      "Est indifférent pour caractériser l’infraction",
      "Doit être injectable",
      "Doit être fumé",
    ],
    answer: "Est indifférent pour caractériser l’infraction",
    explanation: "Usage = absorption, quel que soit le mode.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Usage illicite — Assimilation",
    question: "Peuvent être assimilés à l’usage illicite :",
    options: [
      "L’acquisition, la détention ou le transport destinés à un usage personnel",
      "Toute détention de stupéfiants",
      "Toute acquisition, quelle que soit la quantité",
    ],
    answer:
        "L’acquisition, la détention ou le transport destinés à un usage personnel",
    explanation: "Jurisprudence constante.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Usage illicite — Élément moral",
    question: "L’infraction d’usage illicite suppose :",
    options: [
      "Une consommation volontaire et consciente",
      "Une simple exposition au produit",
      "Une négligence",
    ],
    answer: "Une consommation volontaire et consciente",
    explanation:
        "Absence d’infraction si consommation à l’insu de la personne.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Usage illicite — Peines",
    question: "L’usage illicite de stupéfiants est puni de :",
    options: [
      "1 an d’emprisonnement et 3 750 € d’amende",
      "5 ans d’emprisonnement et 75 000 € d’amende",
      "Une contravention",
    ],
    answer: "1 an d’emprisonnement et 3 750 € d’amende",
    explanation: "Article L.3421-1 al.1 CSP.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Usage illicite — Circonstance aggravante",
    question: "L’usage illicite est aggravé lorsqu’il est commis :",
    options: [
      "Par une personne dépositaire de l’autorité publique dans l’exercice de ses fonctions",
      "Par un majeur",
      "En réunion",
    ],
    answer:
        "Par une personne dépositaire de l’autorité publique dans l’exercice de ses fonctions",
    explanation: "Article L.3421-1 al.2 CSP.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Usage illicite — Amende forfaitaire",
    question: "L’usage illicite de stupéfiants peut faire l’objet :",
    options: [
      "D’une amende forfaitaire délictuelle",
      "D’une contravention",
      "D’une composition pénale uniquement",
    ],
    answer: "D’une amende forfaitaire délictuelle",
    explanation: "Articles 495-17 à 495-25 CPP et L.3421-1 CSP.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Usage illicite — Exclusion AFD",
    question:
        "L’amende forfaitaire délictuelle est exclue lorsque l’usage est commis :",
    options: [
      "Par un agent public dans l’exercice de ses fonctions",
      "À domicile",
      "Pour une première fois",
    ],
    answer: "Par un agent public dans l’exercice de ses fonctions",
    explanation: "Article L.3421-1 al.2 CSP.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Importation de stupéfiants — Élément matériel",
    question: "L’importation illicite de stupéfiants est constituée lorsque :",
    options: [
      "La personne pénètre ou tente de pénétrer sur le territoire national avec des stupéfiants",
      "La drogue est destinée à être vendue en France",
      "La quantité dépasse un seuil minimal",
    ],
    answer:
        "La personne pénètre ou tente de pénétrer sur le territoire national avec des stupéfiants",
    explanation:
        "La destination finale est indifférente : l’entrée ou la tentative suffit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Importation — Jurisprudence",
    question: "Le fait que la drogue soit destinée à un autre pays :",
    options: [
      "N’exclut pas l’importation illicite",
      "Supprime l’infraction",
      "Transforme l’infraction en transport",
    ],
    answer: "N’exclut pas l’importation illicite",
    explanation:
        "Cass. crim. : l’infraction est constituée dès l’entrée sur le territoire français.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Exportation de stupéfiants — Rareté",
    question: "L’exportation illicite de stupéfiants est :",
    options: [
      "Plus rare que l’importation",
      "Plus fréquente que l’importation",
      "Non réprimée",
    ],
    answer: "Plus rare que l’importation",
    explanation:
        "Elle est moins courante mais pénalement réprimée de la même manière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Import/export — Texte applicable",
    question: "L’importation ou l’exportation illicites sont réprimées par :",
    options: [
      "L’article 222-36 du code pénal",
      "L’article 222-35 du code pénal",
      "L’article 222-39 du code pénal",
    ],
    answer: "L’article 222-36 du code pénal",
    explanation:
        "222-36 CP vise spécifiquement l’importation et l’exportation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Import/export — Bande organisée",
    question:
        "Lorsque l’importation est commise en bande organisée, l’infraction devient :",
    options: ["Un crime", "Un simple délit", "Une contravention"],
    answer: "Un crime",
    explanation: "L’aggravation entraîne une qualification criminelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic — Grossiste vs détaillant",
    question: "L’article 222-37 CP vise principalement :",
    options: [
      "Les intermédiaires, grossistes et revendeurs",
      "Uniquement les usagers",
      "Uniquement les producteurs",
    ],
    answer: "Les intermédiaires, grossistes et revendeurs",
    explanation: "Il s’agit du trafic entre plusieurs personnes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic — Indices",
    question: "La démonstration d’un trafic repose souvent sur :",
    options: [
      "Un faisceau d’indices",
      "Des aveux obligatoires",
      "Un seuil légal de quantité",
    ],
    answer: "Un faisceau d’indices",
    explanation:
        "Balances, témoignages, déplacements, argent, matériel de coupe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic — Matériel caractéristique",
    question: "La découverte d’une balance de précision peut constituer :",
    options: [
      "Un indice de trafic",
      "Un usage personnel",
      "Une preuve de fabrication",
    ],
    answer: "Un indice de trafic",
    explanation: "Elle révèle une activité de revente ou de préparation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Transport — Autorisation",
    question: "Le transport de stupéfiants est licite uniquement en cas :",
    options: [
      "D’autorisation administrative",
      "D’usage personnel",
      "De petite quantité",
    ],
    answer: "D’autorisation administrative",
    explanation: "Sans autorisation, le transport est illicite.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Détention — Distance",
    question:
        "Des stupéfiants situés à plusieurs mètres peuvent caractériser une détention si :",
    options: [
      "La personne en a la maîtrise",
      "Ils sont visibles",
      "Ils appartiennent à un proche",
    ],
    answer: "La personne en a la maîtrise",
    explanation: "La proximité et la connaissance suffisent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic — Usage exclusif",
    question:
        "Lorsque les stupéfiants sont destinés à l’usage exclusif de la personne :",
    options: [
      "La qualification d’usage est privilégiée",
      "La détention de trafic est automatique",
      "Il n’y a pas d’infraction",
    ],
    answer: "La qualification d’usage est privilégiée",
    explanation: "Appréciation au cas par cas (quantité, intoxication).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Trafic — Emploi illicite",
    question: "L’emploi illicite de stupéfiants vise notamment :",
    options: [
      "La préparation ou transformation du produit",
      "La consommation personnelle",
      "L’importation",
    ],
    answer: "La préparation ou transformation du produit",
    explanation: "Exemple : couper ou conditionner les doses.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Élément moral — Connaissance",
    question: "L’auteur d’une infraction de trafic doit agir :",
    options: ["En connaissance de cause", "Par négligence", "Par imprudence"],
    answer: "En connaissance de cause",
    explanation: "L’intention coupable est exigée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Trafic — Profit",
    question: "L’intention coupable peut être déduite :",
    options: [
      "Du profit tiré des actes",
      "Uniquement des aveux",
      "Uniquement d’une surveillance",
    ],
    answer: "Du profit tiré des actes",
    explanation: "Le profit est un indice fort de l’intention.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Mineur — Rôle aggravant",
    question:
        "L’intégration d’un mineur dans un trafic est caractérisée même si :",
    options: [
      "Le mineur est contraint",
      "Le mineur est consentant",
      "Le mineur est rémunéré",
    ],
    answer: "Le mineur est contraint",
    explanation: "La loi vise toute participation, volontaire ou non.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Tentative — Crime",
    question: "En matière de crime de trafic, la tentative est :",
    options: [
      "Toujours punissable",
      "Jamais punissable",
      "Punissable uniquement si réussie",
    ],
    answer: "Toujours punissable",
    explanation: "Principe général du droit pénal des crimes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Complicité — Conditions",
    question: "La complicité suppose :",
    options: [
      "Un fait principal punissable",
      "Une simple intention",
      "Un lien familial",
    ],
    answer: "Un fait principal punissable",
    explanation: "Sans infraction principale, pas de complicité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Complicité — Formes",
    question: "La complicité peut résulter :",
    options: [
      "D’instructions données",
      "D’un silence",
      "D’une abstention simple",
    ],
    answer: "D’instructions données",
    explanation: "Articles 121-6 et 121-7 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Procédure — Conséquences",
    question: "Le rattachement à la criminalité organisée permet :",
    options: [
      "L’usage de techniques spéciales d’enquête",
      "La suppression du juge",
      "La prescription immédiate",
    ],
    answer: "L’usage de techniques spéciales d’enquête",
    explanation: "Infiltrations, sonorisations, écoutes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Stupéfiants — Définition légale",
    question: "La définition légale des stupéfiants est :",
    options: [
      "Plus restrictive que la définition médicale",
      "Identique à la définition médicale",
      "Plus large que la définition médicale",
    ],
    answer: "Plus restrictive que la définition médicale",
    explanation: "Seules les substances classées sont concernées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Stupéfiants — Effets",
    question: "Le fait qu’une substance ait des effets psychotropes :",
    options: [
      "Ne suffit pas à la qualifier de stupéfiant",
      "Suffit à la qualifier pénalement",
      "Supprime toute infraction",
    ],
    answer: "Ne suffit pas à la qualifier de stupéfiant",
    explanation: "Elle doit être classée réglementairement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Usage — Quantité",
    question: "La quantité de stupéfiants détenue pour l’usage :",
    options: [
      "Est appréciée au cas par cas",
      "Est fixée par la loi",
      "Est toujours indifférente",
    ],
    answer: "Est appréciée au cas par cas",
    explanation: "Quantité, nature, intoxication sont analysées.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Usage — Culture",
    question: "La culture de cannabis pour consommation personnelle :",
    options: [
      "Peut être qualifiée d’usage",
      "N’est jamais punissable",
      "Est toujours un trafic",
    ],
    answer: "Peut être qualifiée d’usage",
    explanation: "Selon la jurisprudence, si usage exclusif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Usage — Lieu",
    question: "L’usage de stupéfiants est réprimé même s’il a lieu :",
    options: [
      "Dans un lieu privé",
      "Uniquement sur la voie publique",
      "Uniquement en réunion",
    ],
    answer: "Dans un lieu privé",
    explanation: "Le lieu est indifférent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Usage — Qualification pénale",
    question: "L’usage illicite de stupéfiants est :",
    options: ["Un délit", "Une contravention", "Un crime"],
    answer: "Un délit",
    explanation: "Article L.3421-1 CSP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Usage — Amende forfaitaire",
    question: "L’amende forfaitaire délictuelle pour usage est :",
    options: ["Possible sous conditions", "Automatique", "Interdite"],
    answer: "Possible sous conditions",
    explanation: "Certaines situations en sont exclues.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Cas pratique — Contrôle routier",
    question:
        "Lors d’un contrôle, un conducteur reconnaît avoir fumé un joint la veille. Aucun stupéfiant n’est trouvé sur lui. Quelle infraction peut être recherchée ?",
    options: [
      "Usage illicite de stupéfiants",
      "Détention de stupéfiants",
      "Aucune infraction possible",
    ],
    answer: "Usage illicite de stupéfiants",
    explanation:
        "L’aveu peut caractériser l’usage, sous réserve d’éléments complémentaires (test salivaire).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Usage",
    question:
        "L’usage de stupéfiants est constitué même si la consommation est :",
    options: ["Occasionnelle", "Répétée", "Collective"],
    answer: "Occasionnelle",
    explanation: "La répétition n’est pas exigée : un usage unique suffit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Cache",
    question:
        "Un individu est interpellé. Des stupéfiants sont découverts dans une cache connue de lui à 5 mètres. Qualification possible ?",
    options: [
      "Détention de stupéfiants",
      "Usage uniquement",
      "Aucune infraction",
    ],
    answer: "Détention de stupéfiants",
    explanation: "La maîtrise et la connaissance de la cache suffisent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Détention",
    question: "La détention de stupéfiants suppose nécessairement :",
    options: [
      "La possession physique sur soi",
      "La maîtrise du produit",
      "La consommation préalable",
    ],
    answer: "La maîtrise du produit",
    explanation: "La détention peut exister sans port sur soi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Petit dealer",
    question:
        "Un usager revend une partie de sa drogue pour financer sa consommation. Qualification principale ?",
    options: ["Cession de stupéfiants", "Usage simple", "Blanchiment"],
    answer: "Cession de stupéfiants",
    explanation:
        "Le mobile personnel est indifférent : la cession est constituée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Offre",
    question: "L’offre de stupéfiants est constituée lorsque :",
    options: [
      "Le produit est proposé sans remise",
      "Le produit est remis",
      "Le produit est consommé",
    ],
    answer: "Le produit est proposé sans remise",
    explanation: "L’offre précède la cession.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Soirée privée",
    question:
        "Un organisateur met son appartement à disposition pour consommer de la cocaïne. Qualification ?",
    options: ["Facilitation de l’usage", "Usage personnel", "Provocation"],
    answer: "Facilitation de l’usage",
    explanation: "Mise à disposition d’un lieu = aide matérielle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Facilitation",
    question: "La facilitation de l’usage est :",
    options: [
      "Une infraction autonome",
      "Une simple complicité",
      "Une contravention",
    ],
    answer: "Une infraction autonome",
    explanation: "Article 222-37 al.2 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Mineur guetteur",
    question:
        "Un majeur utilise un mineur comme guetteur dans un trafic. Conséquence ?",
    options: [
      "Circonstance aggravante",
      "Infraction distincte",
      "Aucune incidence",
    ],
    answer: "Circonstance aggravante",
    explanation: "Recours à un mineur = aggravation, même contraint.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Mineur",
    question: "L’aide d’un mineur est caractérisée même si le mineur est :",
    options: ["Contraint", "Rémunéré", "Ponctuel"],
    answer: "Contraint",
    explanation: "La volonté du mineur est indifférente.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Cas pratique — Importation",
    question:
        "Un individu est intercepté avec de la résine venant du Maroc mais affirme que c’était pour les Pays-Bas. Qualification ?",
    options: ["Importation illicite", "Transport simple", "Aucune infraction"],
    answer: "Importation illicite",
    explanation: "La destination finale est indifférente.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Importation",
    question: "L’importation est constituée dès lors que :",
    options: [
      "La frontière est franchie ou tentée",
      "La drogue est vendue",
      "La drogue est consommée",
    ],
    answer: "La frontière est franchie ou tentée",
    explanation: "La tentative suffit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Balance",
    question:
        "Lors d’une perquisition, une balance de précision est trouvée. Cela constitue :",
    options: [
      "Un indice de trafic",
      "Une preuve d’usage",
      "Une preuve de blanchiment",
    ],
    answer: "Un indice de trafic",
    explanation: "Matériel caractéristique du commerce.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Preuve",
    question: "Un trafic peut être établi sans aveux grâce :",
    options: [
      "À un faisceau d’indices",
      "À une présomption automatique",
      "À la seule quantité",
    ],
    answer: "À un faisceau d’indices",
    explanation: "La jurisprudence facilite la démonstration du trafic.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Cas pratique — Usage à l’insu",
    question: "Une personne consomme un stupéfiant à son insu. Qualification ?",
    options: ["Aucune infraction", "Usage illicite", "Détention"],
    answer: "Aucune infraction",
    explanation: "L’élément moral fait défaut.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Élément moral",
    question: "Les infractions de trafic supposent :",
    options: [
      "Une intention coupable",
      "Une simple imprudence",
      "Une négligence",
    ],
    answer: "Une intention coupable",
    explanation: "Connaissance du caractère illicite requise.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Culture personnelle",
    question:
        "Un individu cultive quelques plants pour lui-même. Qualification possible ?",
    options: ["Usage illicite", "Trafic systématique", "Aucune infraction"],
    answer: "Usage illicite",
    explanation: "Selon la jurisprudence, si usage exclusif.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "QCM piège — Tentative",
    question: "La tentative en matière de trafic est :",
    options: ["Punissable", "Non prévue", "Contraventionnelle"],
    answer: "Punissable",
    explanation: "Article 222-40 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Blanchiment",
    question:
        "Un proche reçoit de l’argent du trafic et le place sur son compte. Qualification ?",
    options: ["Blanchiment", "Recel", "Usage"],
    answer: "Blanchiment",
    explanation: "Justification et dissimulation de l’origine des fonds.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Blanchiment",
    question: "Le blanchiment peut être retenu contre :",
    options: [
      "L’auteur de l’infraction d’origine",
      "Uniquement un tiers",
      "Uniquement un banquier",
    ],
    answer: "L’auteur de l’infraction d’origine",
    explanation: "Le cumul est admis.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Cas pratique — Provocation",
    question: "Vendre des T-shirts faisant l’apologie du cannabis constitue :",
    options: [
      "Une provocation à l’usage",
      "Une liberté d’expression",
      "Un usage illicite",
    ],
    answer: "Une provocation à l’usage",
    explanation: "Présentation sous un jour favorable.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Provocation",
    question: "La provocation est punissable même si :",
    options: [
      "Elle n’est pas suivie d’effet",
      "Aucun usager n’est identifié",
      "Elle est symbolique",
    ],
    answer: "Elle n’est pas suivie d’effet",
    explanation: "Infraction formelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Presse",
    question:
        "Un article de presse valorise l’usage du cannabis. Régime applicable ?",
    options: [
      "Droit spécifique de la presse",
      "Droit commun",
      "Dépénalisation",
    ],
    answer: "Droit spécifique de la presse",
    explanation: "Article L.3421-4 al.4 CSP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Peines",
    question: "L’usage illicite simple est puni de :",
    options: [
      "1 an d’emprisonnement",
      "5 ans d’emprisonnement",
      "10 ans d’emprisonnement",
    ],
    answer: "1 an d’emprisonnement",
    explanation: "Article L.3421-1 CSP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Fonctionnaire",
    question:
        "Un policier consomme des stupéfiants en service. Conséquence pénale ?",
    options: ["Aggravation des peines", "Aucune incidence", "Dépénalisation"],
    answer: "Aggravation des peines",
    explanation: "Circonstance aggravante spécifique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — AFD",
    question:
        "L’amende forfaitaire délictuelle est exclue lorsque l’usage est commis :",
    options: [
      "Dans l’exercice des fonctions",
      "À domicile",
      "Occasionnellement",
    ],
    answer: "Dans l’exercice des fonctions",
    explanation: "Article L.3421-1 al.2 CSP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Cas pratique — OPJ",
    question:
        "Pourquoi les infractions de trafic relèvent-elles souvent de la criminalité organisée ?",
    options: [
      "Pour permettre des techniques spéciales d’enquête",
      "Pour dépénaliser",
      "Pour accélérer la prescription",
    ],
    answer: "Pour permettre des techniques spéciales d’enquête",
    explanation: "Article 706-73 CPP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Personnes morales",
    question:
        "Les personnes morales peuvent être pénalement responsables en matière de stupéfiants :",
    options: ["Oui", "Non", "Uniquement pour l’usage"],
    answer: "Oui",
    explanation: "Article 222-42 CP.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Cas pratique — Contrôle piéton",
    question:
        "Un individu est contrôlé, il jette un sachet de cannabis à l’arrivée des policiers. Qualification immédiate ?",
    options: [
      "Détention de stupéfiants",
      "Usage illicite",
      "Tentative de cession",
    ],
    answer: "Détention de stupéfiants",
    explanation:
        "Le fait de se débarrasser du produit ne fait pas disparaître la détention.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Détention",
    question: "La détention de stupéfiants suppose :",
    options: [
      "Un contact physique permanent",
      "La connaissance et la maîtrise",
      "Une intention de revente",
    ],
    answer: "La connaissance et la maîtrise",
    explanation: "La détention est caractérisée par la maîtrise du produit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Véhicule",
    question:
        "Des stupéfiants sont découverts sous le siège conducteur. Le conducteur nie. Qualification possible ?",
    options: ["Détention", "Usage uniquement", "Aucune infraction"],
    answer: "Détention",
    explanation:
        "La proximité et la maîtrise peuvent suffire selon les circonstances.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Usage",
    question: "L’usage de stupéfiants peut être constitué même s’il a lieu :",
    options: ["En privé", "En public", "Les deux"],
    answer: "Les deux",
    explanation: "Le lieu est indifférent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Joint collectif",
    question:
        "Plusieurs personnes fument le même joint. Qualifications possibles ?",
    options: ["Usage pour tous", "Détention pour le détenteur", "Les deux"],
    answer: "Les deux",
    explanation: "Usage collectif et détention individualisée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Transport",
    question: "Le transport de stupéfiants est constitué lorsque :",
    options: [
      "Le produit est déplacé",
      "Le produit est vendu",
      "Le produit est consommé",
    ],
    answer: "Le produit est déplacé",
    explanation: "Tout déplacement sans autorisation constitue le transport.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Gare",
    question:
        "Un individu transporte de la cocaïne dans son sac sans intention de revente. Qualification ?",
    options: ["Transport illicite", "Usage uniquement", "Aucune infraction"],
    answer: "Transport illicite",
    explanation: "Le transport est constitué indépendamment de la revente.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Emploi",
    question:
        "L’emploi de stupéfiants se distingue de l’usage lorsqu’il consiste à :",
    options: ["Consommer", "Transformer ou couper", "Détenir"],
    answer: "Transformer ou couper",
    explanation:
        "L’emploi concerne toute utilisation autre que la consommation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Cas pratique — Préparation",
    question:
        "Un individu est surpris en train de couper de la cocaïne. Qualification ?",
    options: ["Emploi illicite", "Usage", "Aucune infraction"],
    answer: "Emploi illicite",
    explanation: "L’emploi est une infraction distincte de l’usage.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Intention",
    question: "Les infractions de trafic exigent :",
    options: [
      "Une intention frauduleuse",
      "Une simple imprudence",
      "Une négligence",
    ],
    answer: "Une intention frauduleuse",
    explanation: "L’élément moral est essentiel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Réseau",
    question:
        "Un individu coordonne plusieurs vendeurs sans vendre lui-même. Qualification ?",
    options: [
      "Organisation d’un trafic",
      "Association de malfaiteurs",
      "Usage",
    ],
    answer: "Organisation d’un trafic",
    explanation: "La direction ou l’organisation suffit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Groupement",
    question: "Le groupement requis pour l’article 222-34 suppose :",
    options: ["Une structuration minimale", "Une société déclarée", "Un écrit"],
    answer: "Une structuration minimale",
    explanation: "Aucune forme juridique n’est exigée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Complicité",
    question:
        "Une personne fournit un véhicule pour un transport de stupéfiants. Qualification ?",
    options: ["Complicité", "Usage", "Recel"],
    answer: "Complicité",
    explanation: "Aide matérielle à la commission de l’infraction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Complicité",
    question: "La complicité suppose :",
    options: [
      "Un fait principal punissable",
      "Une condamnation préalable",
      "Un profit",
    ],
    answer: "Un fait principal punissable",
    explanation: "La condamnation de l’auteur n’est pas exigée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Cas pratique — Argent liquide",
    question:
        "De grosses sommes en liquide sont trouvées avec de la drogue. Qualification complémentaire possible ?",
    options: ["Blanchiment", "Usage", "Aucune"],
    answer: "Blanchiment",
    explanation: "Selon l’origine et la dissimulation des fonds.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Cumul",
    question: "Peut-on cumuler trafic et blanchiment ?",
    options: ["Oui", "Non", "Uniquement pour un tiers"],
    answer: "Oui",
    explanation: "La jurisprudence admet le cumul.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Provocation indirecte",
    question:
        "Une affiche vantant les bienfaits du cannabis est exposée lors d’un festival. Qualification ?",
    options: ["Provocation à l’usage", "Liberté d’expression", "Usage"],
    answer: "Provocation à l’usage",
    explanation: "Présentation sous un jour favorable.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Effet",
    question: "La provocation est punissable même si aucun usage n’a lieu :",
    options: ["Vrai", "Faux", "Uniquement pour les mineurs"],
    answer: "Vrai",
    explanation: "Infraction formelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Mineur consommateur",
    question:
        "Un majeur incite un mineur à consommer. Qualification aggravée ?",
    options: ["Oui", "Non", "Uniquement disciplinaire"],
    answer: "Oui",
    explanation: "Circonstance aggravante prévue par la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Tentative",
    question: "La tentative d’usage de stupéfiants est :",
    options: ["Non punissable", "Punissable", "Une contravention"],
    answer: "Non punissable",
    explanation: "La tentative n’est pas prévue pour l’usage.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Cas pratique — Frontière",
    question:
        "Un individu est interpellé avant de passer la frontière avec de la drogue. Qualification ?",
    options: [
      "Tentative d’importation",
      "Transport simple",
      "Aucune infraction",
    ],
    answer: "Tentative d’importation",
    explanation: "La tentative est punissable.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Prescription",
    question:
        "Les infractions criminelles liées aux stupéfiants se prescrivent en principe par :",
    options: ["20 ans", "10 ans", "6 ans"],
    answer: "20 ans",
    explanation: "Prescription des crimes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Cas pratique — APJ",
    question:
        "Pourquoi les dossiers stupéfiants exigent-ils une qualification précise ?",
    options: [
      "Pour éviter la nullité",
      "Pour accélérer la procédure",
      "Pour alléger la peine",
    ],
    answer: "Pour éviter la nullité",
    explanation: "Une mauvaise qualification fragilise la procédure.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Hiérarchie",
    question: "La définition légale des stupéfiants repose sur :",
    options: [
      "Une liste réglementaire",
      "L’avis des policiers",
      "La jurisprudence uniquement",
    ],
    answer: "Une liste réglementaire",
    explanation: "Article L.5132-7 CSP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Substance non classée",
    question:
        "Un produit n’est pas classé stupéfiant mais est dangereux. Quelle infraction possible ?",
    options: [
      "Infractions CSP substances vénéneuses",
      "Usage de stupéfiants",
      "Aucune",
    ],
    answer: "Infractions CSP substances vénéneuses",
    explanation: "Les substances non classées relèvent d’un autre régime.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Classement",
    question: "Le classement d’une substance comme stupéfiant relève :",
    options: ["De l’ANSM", "Du juge", "Du préfet"],
    answer: "De l’ANSM",
    explanation: "Décision administrative sous contrôle du juge.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Intervention PA",
    question:
        "Lors d’une patrouille, quelle priorité face à une suspicion de trafic ?",
    options: ["Sécuriser et observer", "Interpeller immédiatement", "Ignorer"],
    answer: "Sécuriser et observer",
    explanation: "Préserver les preuves et la sécurité.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Cas pratique — Abandon de produit",
    question:
        "Un individu abandonne un sachet de cocaïne dans une poubelle publique avant contrôle. Qualification ?",
    options: ["Détention de stupéfiants", "Usage simple", "Aucune infraction"],
    answer: "Détention de stupéfiants",
    explanation:
        "L’abandon n’efface pas la détention antérieure dès lors qu’elle est caractérisée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Détention",
    question: "La détention suppose nécessairement :",
    options: [
      "Une maîtrise consciente du produit",
      "Un contact physique",
      "Une revente",
    ],
    answer: "Une maîtrise consciente du produit",
    explanation: "La détention peut être indirecte.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Appartement partagé",
    question:
        "Des stupéfiants sont trouvés dans un salon commun. Plusieurs occupants. Quelle analyse ?",
    options: [
      "Recherche de la maîtrise individuelle",
      "Responsabilité collective automatique",
      "Aucune infraction",
    ],
    answer: "Recherche de la maîtrise individuelle",
    explanation: "La détention n’est jamais présumée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Présomption",
    question: "En matière de stupéfiants, la présomption de détention :",
    options: ["N’existe pas", "Est automatique", "Est irréfragable"],
    answer: "N’existe pas",
    explanation: "La preuve de la détention incombe à l’accusation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Cache",
    question:
        "Des stupéfiants sont dissimulés dans une cache connue de l’intéressé. Qualification ?",
    options: ["Détention", "Usage uniquement", "Aucune"],
    answer: "Détention",
    explanation: "La connaissance et l’accès suffisent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Usage",
    question: "L’usage de stupéfiants nécessite :",
    options: ["Une absorption volontaire", "Une dépendance", "Une récidive"],
    answer: "Une absorption volontaire",
    explanation: "L’intention est indispensable.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Insu",
    question:
        "Une personne consomme une boisson contenant des stupéfiants à son insu. Qualification ?",
    options: ["Aucune infraction", "Usage illicite", "Détention"],
    answer: "Aucune infraction",
    explanation: "Absence d’élément moral.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Mode d’administration",
    question: "Le mode de consommation du stupéfiant est :",
    options: ["Indifférent", "Déterminant", "Atténuant"],
    answer: "Indifférent",
    explanation: "Injection, inhalation, ingestion : peu importe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Usage collectif",
    question:
        "Lors d’une soirée, un individu fournit un joint à plusieurs personnes. Qualification principale ?",
    options: ["Cession illicite", "Usage collectif", "Aucune"],
    answer: "Cession illicite",
    explanation: "La fourniture constitue une cession, même gratuite.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Gratuité",
    question: "Le caractère gratuit de la remise de stupéfiants :",
    options: [
      "N’exclut pas l’infraction",
      "Supprime l’infraction",
      "Atténue automatiquement la peine",
    ],
    answer: "N’exclut pas l’infraction",
    explanation: "La loi ne distingue pas.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Petit dealer",
    question:
        "La vente de quelques doses pour financer sa propre consommation relève :",
    options: [
      "De l’article 222-39 CP",
      "De l’usage simple",
      "De la non-punissabilité",
    ],
    answer: "De l’article 222-39 CP",
    explanation: "Cession en vue de consommation personnelle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Quantité",
    question: "La quantité de stupéfiants vendue :",
    options: [
      "N’est pas un critère légal déterminant",
      "Détermine seule la qualification",
      "Supprime le trafic",
    ],
    answer: "N’est pas un critère légal déterminant",
    explanation: "Elle est un indice parmi d’autres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Mineur transporteur",
    question:
        "Un majeur utilise un mineur pour transporter de la drogue. Qualification aggravée ?",
    options: ["Oui", "Non", "Uniquement civile"],
    answer: "Oui",
    explanation: "Circonstance aggravante spécifique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Consentement",
    question: "Le consentement du mineur dans un trafic :",
    options: [
      "Est indifférent",
      "Supprime l’aggravation",
      "Supprime l’infraction",
    ],
    answer: "Est indifférent",
    explanation: "La loi protège le mineur indépendamment de sa volonté.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Bande organisée",
    question: "Qu’est-ce qui caractérise principalement une bande organisée ?",
    options: [
      "La préparation concertée",
      "Le nombre de personnes",
      "La récidive",
    ],
    answer: "La préparation concertée",
    explanation: "Organisation préalable, même minimale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Organisation",
    question: "Une organisation peut être qualifiée même si elle est :",
    options: ["Très rudimentaire", "Occasionnelle", "Imprévisible"],
    answer: "Très rudimentaire",
    explanation: "La loi exige une structuration minimale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Chef invisible",
    question:
        "Le chef d’un réseau n’est jamais en possession de drogue. Qualification ?",
    options: ["Direction de trafic", "Complicité simple", "Aucune"],
    answer: "Direction de trafic",
    explanation: "La détention n’est pas nécessaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Association de malfaiteurs",
    question: "L’association de malfaiteurs se distingue du trafic car :",
    options: [
      "Le trafic doit être réalisé",
      "Elle nécessite une vente",
      "Elle exclut les stupéfiants",
    ],
    answer: "Le trafic doit être réalisé",
    explanation: "L’association vise la préparation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Cas pratique — Faux documents",
    question:
        "L’usage de fausses factures pour masquer l’origine d’argent issu de la drogue relève :",
    options: ["Du blanchiment", "Du recel simple", "De l’usage"],
    answer: "Du blanchiment",
    explanation: "Justification mensongère de l’origine des fonds.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Auteur principal",
    question:
        "L’auteur de l’infraction principale peut être poursuivi pour blanchiment :",
    options: ["Oui", "Non", "Uniquement en récidive"],
    answer: "Oui",
    explanation: "Le cumul est admis.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Banque",
    question:
        "Un établissement bancaire ferme les yeux sur des flux suspects. Qualification possible ?",
    options: ["Blanchiment", "Usage", "Aucune"],
    answer: "Blanchiment",
    explanation: "Participation par concours aux opérations.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Fonds",
    question: "Le blanchiment porte sur :",
    options: [
      "Le produit d’infractions déterminées",
      "Toute somme d’argent",
      "Uniquement l’argent liquide",
    ],
    answer: "Le produit d’infractions déterminées",
    explanation: "Articles 222-34 à 222-37 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Provocation numérique",
    question:
        "Une vidéo sur les réseaux sociaux glorifie la consommation de drogues. Qualification ?",
    options: ["Provocation à l’usage", "Liberté d’expression", "Aucune"],
    answer: "Provocation à l’usage",
    explanation: "Présentation sous un jour favorable.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Support",
    question: "La provocation à l’usage peut être constituée par :",
    options: [
      "Tout support",
      "Uniquement la presse écrite",
      "Uniquement la parole",
    ],
    answer: "Tout support",
    explanation: "Affiches, réseaux, objets, etc.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Établissement scolaire",
    question: "Une provocation à l’usage dans un lycée entraîne :",
    options: ["Une aggravation", "Une dépénalisation", "Une contravention"],
    answer: "Une aggravation",
    explanation: "Circonstance aggravante légale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Tentative",
    question: "La tentative est punissable pour :",
    options: ["Les infractions de trafic", "L’usage", "La provocation"],
    answer: "Les infractions de trafic",
    explanation: "Article 222-40 CP.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Frontière",
    question:
        "Un individu est intercepté en zone frontalière avant entrée sur le territoire. Qualification ?",
    options: ["Tentative d’importation", "Transport simple", "Usage"],
    answer: "Tentative d’importation",
    explanation: "L’intention et les actes préparatoires suffisent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Autorité",
    question: "Le classement d’une substance comme stupéfiant relève :",
    options: ["Du pouvoir administratif", "Du législateur", "Du policier"],
    answer: "Du pouvoir administratif",
    explanation: "ANSM sous contrôle du juge.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — PA sur le terrain",
    question: "Face à une suspicion de trafic, le PA doit prioritairement :",
    options: [
      "Observer et rendre compte",
      "Interpeller seul",
      "Procéder à une fouille immédiate",
    ],
    answer: "Observer et rendre compte",
    explanation: "Sécurité et procédure avant tout.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Procédure",
    question: "Une mauvaise qualification pénale entraîne principalement :",
    options: [
      "Un risque de nullité",
      "Une relaxe automatique",
      "Une simple amende",
    ],
    answer: "Un risque de nullité",
    explanation: "D’où l’importance de la précision.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Cas pratique — Odeur de cannabis",
    question:
        "Lors d’un contrôle, une forte odeur de cannabis émane d’un véhicule. Cela permet :",
    options: [
      "De suspecter une infraction",
      "De caractériser automatiquement l’usage",
      "De conclure à un trafic",
    ],
    answer: "De suspecter une infraction",
    explanation: "L’odeur est un indice mais ne suffit pas à elle seule.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Preuve",
    question: "En matière de stupéfiants, la preuve peut être rapportée par :",
    options: ["Tout moyen", "Uniquement un test", "Uniquement des aveux"],
    answer: "Tout moyen",
    explanation: "Principe de liberté de la preuve en matière pénale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Test salivaire",
    question: "Un test salivaire positif permet de caractériser :",
    options: ["Un usage de stupéfiants", "Une détention", "Un trafic"],
    answer: "Un usage de stupéfiants",
    explanation: "Il atteste d’une consommation, pas d’un trafic.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Détention",
    question:
        "La détention de stupéfiants peut être retenue même sans saisie si :",
    options: [
      "Elle est prouvée par d’autres éléments",
      "Le produit a été consommé",
      "Le produit a disparu",
    ],
    answer: "Elle est prouvée par d’autres éléments",
    explanation: "La saisie n’est pas toujours indispensable.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Cas pratique — Cache extérieure",
    question:
        "Un individu cache de la drogue dans un buisson et revient régulièrement. Qualification ?",
    options: ["Détention", "Usage simple", "Aucune infraction"],
    answer: "Détention",
    explanation:
        "La maîtrise et l’usage de la cache caractérisent la détention.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Revente",
    question: "L’intention de revente est :",
    options: [
      "Un élément d’appréciation",
      "Un élément légal obligatoire",
      "Sans importance",
    ],
    answer: "Un élément d’appréciation",
    explanation:
        "Elle aide à qualifier le trafic mais n’est pas toujours exigée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Téléphone",
    question:
        "Des messages de vente de drogue sont retrouvés sur un téléphone. Cela constitue :",
    options: [
      "Un indice de trafic",
      "Une preuve d’usage",
      "Une infraction autonome",
    ],
    answer: "Un indice de trafic",
    explanation: "Les échanges renforcent la qualification de trafic.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — SMS",
    question: "Des SMS seuls suffisent à caractériser un trafic :",
    options: [
      "Non, ils doivent être corroborés",
      "Oui, systématiquement",
      "Uniquement en récidive",
    ],
    answer: "Non, ils doivent être corroborés",
    explanation: "Ils font partie d’un faisceau d’indices.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Cas pratique — Argent fractionné",
    question:
        "De petites coupures sont retrouvées sur un individu. Cela peut indiquer :",
    options: [
      "Une activité de revente",
      "Un usage simple",
      "Une contravention",
    ],
    answer: "Une activité de revente",
    explanation: "Les coupures sont un indice classique du trafic.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Indices",
    question: "Un trafic est souvent établi grâce à :",
    options: [
      "Un faisceau d’indices",
      "Un seul élément décisif",
      "Une quantité minimale légale",
    ],
    answer: "Un faisceau d’indices",
    explanation: "La jurisprudence raisonne globalement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Consommateur-revendeur",
    question:
        "Un usager revend une partie pour financer sa consommation. Qualification ?",
    options: ["Cession illicite", "Usage simple", "Aucune"],
    answer: "Cession illicite",
    explanation:
        "La revente, même partielle, constitue une infraction distincte.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Motivation",
    question: "Le motif personnel de l’auteur :",
    options: [
      "Est indifférent à la qualification",
      "Supprime l’infraction",
      "Atténue automatiquement la peine",
    ],
    answer: "Est indifférent à la qualification",
    explanation: "La loi ne distingue pas selon le motif.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Mineur consommateur",
    question:
        "Un mineur est contrôlé consommant un joint. Quelle approche pénale ?",
    options: [
      "Usage illicite avec régime spécifique",
      "Aucune infraction",
      "Trafic",
    ],
    answer: "Usage illicite avec régime spécifique",
    explanation: "L’infraction existe mais la réponse est adaptée au mineur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Mineur",
    question: "Le mineur usager est pénalement irresponsable :",
    options: ["Faux", "Vrai", "Uniquement avant 13 ans"],
    answer: "Faux",
    explanation: "Il est responsable pénalement selon son discernement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Cas pratique — Réunion",
    question:
        "Une réunion régulière dans un hall pour vendre de la drogue peut caractériser :",
    options: [
      "Une organisation",
      "Un usage collectif",
      "Une simple contravention",
    ],
    answer: "Une organisation",
    explanation: "La répétition et la structuration sont déterminantes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Bande organisée",
    question: "La bande organisée suppose :",
    options: [
      "Une préparation concertée",
      "Un nombre minimum de personnes",
      "Une récidive légale",
    ],
    answer: "Une préparation concertée",
    explanation: "Le nombre n’est pas fixé par la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Rôle logistique",
    question:
        "Une personne stocke la drogue sans la vendre. Qualification possible ?",
    options: ["Détention et complicité", "Usage", "Aucune"],
    answer: "Détention et complicité",
    explanation: "Le rôle logistique est pénalement répréhensible.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Stockage",
    question: "Le stockage de stupéfiants constitue :",
    options: ["Une détention", "Un usage", "Une contravention"],
    answer: "Une détention",
    explanation: "Le stockage révèle la maîtrise du produit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Livraison",
    question:
        "Un individu livre de la drogue à vélo pour un tiers. Qualification ?",
    options: ["Transport et complicité", "Usage", "Aucune"],
    answer: "Transport et complicité",
    explanation: "Le transport est une infraction autonome.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Paiement",
    question: "Le fait de ne pas être rémunéré :",
    options: [
      "N’exclut pas l’infraction",
      "Supprime l’infraction",
      "Transforme en usage",
    ],
    answer: "N’exclut pas l’infraction",
    explanation: "La gratuité est indifférente.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Blanchiment simple",
    question:
        "Un proche encaisse de l’argent issu du trafic pour aider. Qualification ?",
    options: ["Blanchiment", "Recel simple", "Aucune"],
    answer: "Blanchiment",
    explanation: "Aide à la dissimulation de l’origine des fonds.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Lien familial",
    question: "Le lien familial avec l’auteur principal :",
    options: [
      "N’exonère pas de responsabilité",
      "Supprime l’infraction",
      "Atténue automatiquement",
    ],
    answer: "N’exonère pas de responsabilité",
    explanation: "Aucune immunité familiale en la matière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Provocation indirecte",
    question: "Vendre des objets glorifiant la drogue peut constituer :",
    options: ["Une provocation", "Un usage", "Une simple liberté commerciale"],
    answer: "Une provocation",
    explanation: "Valorisation de l’usage illicite.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Intention",
    question: "La provocation nécessite :",
    options: [
      "Une connaissance du message diffusé",
      "Un résultat effectif",
      "Une récidive",
    ],
    answer: "Une connaissance du message diffusé",
    explanation: "L’effet n’est pas requis.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Intervention PA",
    question: "Face à un usage simple, le PA doit prioritairement :",
    options: [
      "Sécuriser et rendre compte",
      "Sanctionner immédiatement",
      "Relâcher sans trace",
    ],
    answer: "Sécuriser et rendre compte",
    explanation: "Respect de la procédure et de la hiérarchie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Procédure",
    question: "Une procédure stupéfiants mal motivée entraîne :",
    options: [
      "Un risque de nullité",
      "Une simple remarque",
      "Une automaticité de condamnation",
    ],
    answer: "Un risque de nullité",
    explanation: "La motivation est essentielle.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Cas pratique — Consommation récente",
    question:
        "Un individu reconnaît avoir consommé la veille mais ne détient plus rien. Qualification possible ?",
    options: ["Usage illicite", "Aucune infraction", "Détention"],
    answer: "Usage illicite",
    explanation:
        "L’aveu peut suffire à caractériser l’usage s’il est corroboré.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Aveux",
    question: "Les aveux en matière pénale :",
    options: [
      "Peuvent suffire s’ils sont crédibles",
      "Sont irrecevables seuls",
      "Doivent toujours être écrits",
    ],
    answer: "Peuvent suffire s’ils sont crédibles",
    explanation: "Les aveux sont un mode de preuve comme un autre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Joint en cours",
    question:
        "Un individu est contrôlé alors qu’il termine un joint. Qualification ?",
    options: ["Usage illicite", "Détention", "Cession"],
    answer: "Usage illicite",
    explanation: "La consommation est caractérisée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Détention préalable",
    question: "L’usage de stupéfiants implique nécessairement :",
    options: ["Une détention préalable", "Une cession", "Un transport"],
    answer: "Une détention préalable",
    explanation: "Mais la loi distingue les qualifications.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Cas pratique — Quantité faible",
    question:
        "Un individu est porteur d’un demi-gramme de cannabis pour lui seul. Qualification ?",
    options: ["Usage illicite", "Détention de trafic", "Aucune"],
    answer: "Usage illicite",
    explanation: "La faible quantité oriente vers l’usage.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Quantité",
    question: "La faible quantité de stupéfiants :",
    options: [
      "N’exclut jamais une infraction",
      "Exclut toute poursuite",
      "Transforme en contravention",
    ],
    answer: "N’exclut jamais une infraction",
    explanation: "L’usage reste pénalement sanctionné.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Cache commune",
    question:
        "Une cache est utilisée par plusieurs individus. Quelle difficulté principale ?",
    options: [
      "Identifier la maîtrise individuelle",
      "Prouver l’existence du produit",
      "Qualifier l’usage",
    ],
    answer: "Identifier la maîtrise individuelle",
    explanation: "La détention n’est pas collective par principe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Maîtrise",
    question: "La notion de maîtrise implique :",
    options: [
      "La possibilité d’en disposer",
      "La consommation immédiate",
      "La propriété du produit",
    ],
    answer: "La possibilité d’en disposer",
    explanation: "La propriété n’est pas exigée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Prêt de véhicule",
    question:
        "Un individu prête son véhicule pour transporter de la drogue en connaissance de cause. Qualification ?",
    options: ["Complicité", "Usage", "Aucune"],
    answer: "Complicité",
    explanation: "Aide matérielle à l’infraction.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Ignorance",
    question: "L’ignorance réelle de la présence de stupéfiants :",
    options: ["Exclut l’infraction", "Atténue la peine", "Est indifférente"],
    answer: "Exclut l’infraction",
    explanation: "Absence d’élément moral.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Cas pratique — Sac abandonné",
    question:
        "Un sac contenant de la drogue est abandonné sans auteur identifié. Conséquence ?",
    options: ["Aucune poursuite possible", "Usage", "Détention collective"],
    answer: "Aucune poursuite possible",
    explanation: "Absence d’auteur identifié.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Élément moral",
    question: "Toutes les infractions stupéfiants exigent :",
    options: ["Un élément moral", "Une récidive", "Un profit"],
    answer: "Un élément moral",
    explanation: "La connaissance est essentielle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Transport public",
    question:
        "Un individu transporte des stupéfiants dans un train. Qualification ?",
    options: ["Transport illicite", "Usage", "Aucune"],
    answer: "Transport illicite",
    explanation: "Le moyen de transport est indifférent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Lieu",
    question: "Le lieu de commission de l’infraction est :",
    options: ["Indifférent", "Toujours aggravant", "Toujours atténuant"],
    answer: "Indifférent",
    explanation: "Sauf circonstances particulières prévues par la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Hall d’immeuble",
    question:
        "Un trafic régulier est observé dans un hall. Qualification aggravée possible ?",
    options: ["Oui", "Non", "Uniquement civile"],
    answer: "Oui",
    explanation: "Lieu fréquenté par le public.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Circonstance",
    question: "Les circonstances aggravantes :",
    options: [
      "Doivent être expressément prévues",
      "Sont appréciées librement",
      "Sont automatiques",
    ],
    answer: "Doivent être expressément prévues",
    explanation: "Principe de légalité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Recel",
    question: "Le recel de stupéfiants est :",
    options: [
      "Inexistant en tant que tel",
      "Une contravention",
      "Un délit autonome",
    ],
    answer: "Inexistant en tant que tel",
    explanation: "Les faits sont absorbés par les infractions spécifiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Recel",
    question: "Une personne qui cache de la drogue pour un tiers commet :",
    options: ["Une détention", "Un recel", "Aucune infraction"],
    answer: "Une détention",
    explanation: "La détention prime.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Téléphonie",
    question: "L’usage de plusieurs téléphones peut indiquer :",
    options: [
      "Une organisation de trafic",
      "Un usage simple",
      "Aucune infraction",
    ],
    answer: "Une organisation de trafic",
    explanation: "Indice classique du trafic.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Indice isolé",
    question: "Un indice isolé permet de caractériser un trafic :",
    options: ["Rarement", "Toujours", "Jamais"],
    answer: "Rarement",
    explanation: "Appréciation globale nécessaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Rémunération",
    question: "Être rémunéré en stupéfiants pour un service constitue :",
    options: ["Une participation au trafic", "Un usage simple", "Aucune"],
    answer: "Une participation au trafic",
    explanation: "La contrepartie peut être en nature.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "QCM piège — Contrepartie",
    question: "La contrepartie financière est :",
    options: ["Indifférente à la qualification", "Obligatoire", "Exonératoire"],
    answer: "Indifférente à la qualification",
    explanation: "La loi ne distingue pas.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Signalement",
    question:
        "Un PA observe un trafic sans intervenir seul. Son action correcte est :",
    options: ["Rendre compte", "Interpeller seul", "Ignorer"],
    answer: "Rendre compte",
    explanation: "Respect de la sécurité et de la hiérarchie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "QCM piège — Sécurité",
    question: "La priorité absolue du PA sur une scène stupéfiants est :",
    options: ["La sécurité", "La saisie", "L’audition"],
    answer: "La sécurité",
    explanation: "Toujours avant la procédure.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Cas pratique — Procédure",
    question: "Pourquoi les faits doivent-ils être précisément décrits au PV ?",
    options: [
      "Pour sécuriser la qualification",
      "Pour accélérer la sanction",
      "Pour alourdir la peine",
    ],
    answer: "Pour sécuriser la qualification",
    explanation: "Clarté = solidité judiciaire.",
    difficulty: "Facile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizStupefiant extends StatefulWidget {
  static const String routeName =
      '/gpx/stupéfiants_pages/quiz/quiz_stupéfiants';
  final String uid;
  final String email;

  const QuizStupefiant({super.key, required this.uid, required this.email});

  @override
  State<QuizStupefiant> createState() => _QuizStupefiantState();
}

class _QuizStupefiantState extends State<QuizStupefiant>
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
        ? questionsStupefiants
        : questionsStupefiants
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
            'module_name': 'Stupéfiants — usage & trafic',
            'quiz_name': 'Quiz - Stupéfiants — usage & trafic',
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
      await _sb.from('quiz_stupéfiants').insert({
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
      debugPrint('❌ quiz_stupéfiants insert failed: $e');
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
