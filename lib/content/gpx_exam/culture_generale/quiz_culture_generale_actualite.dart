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

final List<QuizQuestion> questionCultureActualite = [
  QuizQuestion(
    category: "Actualité internationale — ONU",
    question:
        "Quel organe de l’ONU est chargé du maintien de la paix et de la sécurité internationales ?",
    options: [
      "Conseil de sécurité",
      "Assemblée générale",
      "Conseil économique et social",
    ],
    answer: "Conseil de sécurité",
    explanation:
        "Il peut adopter des résolutions contraignantes pour les États membres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale — UE",
    question:
        "Quel pays assure la présidence tournante du Conseil de l’Union européenne au premier semestre 2025 ?",
    options: ["Pologne", "Espagne", "Hongrie"],
    answer: "Pologne",
    explanation: "La présidence du Conseil de l’UE change tous les six mois.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité internationale — Conflits",
    question: "Quel conflit armé en Europe orientale reste actif en 2025 ?",
    options: ["Guerre en Ukraine", "Guerre du Kosovo", "Conflit chypriote"],
    answer: "Guerre en Ukraine",
    explanation: "Elle a débuté en 2022 avec l’invasion russe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale — Grandes puissances",
    question:
        "Quel pays est membre permanent du Conseil de sécurité de l’ONU ?",
    options: ["Chine", "Allemagne", "Inde"],
    answer: "Chine",
    explanation: "Les cinq membres permanents disposent d’un droit de veto.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale — ONU",
    question: "Quel secrétaire général de l’ONU est en fonction en 2026 ?",
    options: ["António Guterres", "Ban Ki-moon", "Kofi Annan"],
    answer: "António Guterres",
    explanation: "Il occupe cette fonction depuis 2017.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Société française — Laïcité",
    question:
        "Quel principe impose la neutralité religieuse de l’État en France ?",
    options: ["Laïcité", "Pluralisme", "Subsidiarité"],
    answer: "Laïcité",
    explanation:
        "Elle garantit la liberté de conscience et l’égalité des cultes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française — Égalité",
    question:
        "Quelle loi française impose l’égalité salariale entre les femmes et les hommes ?",
    options: [
      "Principe d’égalité professionnelle",
      "Loi sur la parité électorale",
      "Code civil",
    ],
    answer: "Principe d’égalité professionnelle",
    explanation: "Il est inscrit dans le Code du travail.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Société française — Immigration",
    question:
        "Quel droit garantit la protection des personnes persécutées dans leur pays ?",
    options: ["Droit d’asile", "Droit du sol", "Regroupement familial"],
    answer: "Droit d’asile",
    explanation: "Il est reconnu par la Constitution française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française — Démographie",
    question: "Quel indicateur mesure le nombre moyen d’enfants par femme ?",
    options: ["Taux de fécondité", "Taux de natalité", "Solde migratoire"],
    answer: "Taux de fécondité",
    explanation: "Il est essentiel pour analyser l’évolution démographique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Écologie",
    question: "Quel objectif vise la neutralité carbone ?",
    options: [
      "Équilibrer émissions et absorptions de CO₂",
      "Supprimer toute industrie",
      "Interdire les énergies renouvelables",
    ],
    answer: "Équilibrer émissions et absorptions de CO₂",
    explanation: "Objectif central des politiques climatiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Énergie",
    question: "Quelle source d’énergie est considérée comme renouvelable ?",
    options: ["Éolien", "Charbon", "Pétrole"],
    answer: "Éolien",
    explanation: "Elle exploite une ressource naturelle inépuisable.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Intelligence artificielle",
    question:
        "Quel risque principal est souvent associé à l’intelligence artificielle ?",
    options: [
      "Biais algorithmiques",
      "Disparition d’Internet",
      "Fin de l’électricité",
    ],
    answer: "Biais algorithmiques",
    explanation: "Ils peuvent reproduire ou amplifier des discriminations.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Intelligence artificielle",
    question: "Quel domaine est fortement impacté par l’IA générative ?",
    options: [
      "Création de contenus",
      "Agriculture traditionnelle",
      "Artisanat local",
    ],
    answer: "Création de contenus",
    explanation: "Texte, image et audio peuvent être générés automatiquement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question: "Quel principe garantit la liberté de la presse en France ?",
    options: [
      "Liberté d’expression",
      "Neutralité administrative",
      "Secret défense",
    ],
    answer: "Liberté d’expression",
    explanation: "Elle est protégée par la Déclaration des droits de l’homme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question:
        "Comment appelle-t-on une information volontairement fausse diffusée comme vraie ?",
    options: ["Fake news", "Éditorial", "Tribune"],
    answer: "Fake news",
    explanation: "Elle vise à tromper ou manipuler l’opinion.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question: "Quel rôle essentiel jouent les médias dans une démocratie ?",
    options: [
      "Informer les citoyens",
      "Remplacer la justice",
      "Voter les lois",
    ],
    answer: "Informer les citoyens",
    explanation:
        "Une information libre est indispensable au débat démocratique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question:
        "Quel organisme français veille au respect du pluralisme des médias audiovisuels ?",
    options: ["ARCOM", "CSA", "CNIL"],
    answer: "ARCOM",
    explanation: "Elle résulte de la fusion du CSA et de l’HADOPI.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité internationale — UE",
    question:
        "Quel objectif principal poursuit l’Union européenne en matière climatique ?",
    options: [
      "Réduction des émissions de gaz à effet de serre",
      "Abandon du commerce international",
      "Suppression des frontières",
    ],
    answer: "Réduction des émissions de gaz à effet de serre",
    explanation: "Objectif inscrit dans le Pacte vert européen.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité internationale — Conflits",
    question:
        "Quelle organisation internationale est chargée de superviser les missions de maintien de la paix ?",
    options: ["ONU", "OTAN", "Union européenne"],
    answer: "ONU",
    explanation: "L’ONU déploie des casques bleus dans les zones de conflit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale — Grandes puissances",
    question:
        "Quel pays est la première puissance économique mondiale en PIB nominal en 2025 ?",
    options: ["États-Unis", "Chine", "Japon"],
    answer: "États-Unis",
    explanation: "Ils conservent la première place en PIB nominal.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité internationale — UE",
    question:
        "Quel organe de l’UE adopte les sanctions économiques contre des États tiers ?",
    options: [
      "Conseil de l’Union européenne",
      "Parlement européen",
      "Commission européenne",
    ],
    answer: "Conseil de l’Union européenne",
    explanation: "Il décide à l’unanimité en matière de politique étrangère.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité internationale — ONU",
    question:
        "Combien de membres permanents compte le Conseil de sécurité de l’ONU ?",
    options: ["5", "10", "15"],
    answer: "5",
    explanation: "Ils disposent tous d’un droit de veto.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale — UE",
    question:
        "Quel programme européen finance la recherche et l’innovation jusqu’en 2027 ?",
    options: ["Horizon Europe", "Erasmus+", "FEDER"],
    answer: "Horizon Europe",
    explanation: "C’est le principal programme de recherche de l’UE.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Société française — Laïcité",
    question: "Quelle loi fondatrice encadre la laïcité en France ?",
    options: ["Loi de 1905", "Loi de 1958", "Loi de 1981"],
    answer: "Loi de 1905",
    explanation: "Elle établit la séparation des Églises et de l’État.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française — Égalité femmes-hommes",
    question:
        "Quel index mesure l’égalité professionnelle dans les entreprises françaises ?",
    options: [
      "Index égalité femmes-hommes",
      "Indice de parité",
      "Indice social global",
    ],
    answer: "Index égalité femmes-hommes",
    explanation: "Il est obligatoire pour certaines entreprises.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Société française — Immigration",
    question:
        "Quel document autorise un étranger à séjourner légalement en France ?",
    options: ["Titre de séjour", "Carte d’électeur", "Passeport diplomatique"],
    answer: "Titre de séjour",
    explanation: "Il est délivré par l’administration française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française — Démographie",
    question:
        "Comment appelle-t-on la différence entre naissances et décès sur une période donnée ?",
    options: ["Solde naturel", "Solde migratoire", "Taux de fécondité"],
    answer: "Solde naturel",
    explanation: "Il mesure l’évolution démographique interne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Écologie",
    question:
        "Quel accord international vise à limiter le réchauffement climatique à 1,5 °C ?",
    options: ["Accord de Paris", "Protocole de Kyoto", "Sommet de Rio"],
    answer: "Accord de Paris",
    explanation: "Il a été adopté en 2015.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Énergie",
    question: "Quelle énergie est produite par la fission de l’atome ?",
    options: ["Nucléaire", "Solaire", "Hydraulique"],
    answer: "Nucléaire",
    explanation: "Elle repose sur la fission de l’uranium.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Énergie",
    question:
        "Quel enjeu majeur accompagne le développement des énergies renouvelables ?",
    options: [
      "Stockage de l’électricité",
      "Manque de vent",
      "Surproduction pétrolière",
    ],
    answer: "Stockage de l’électricité",
    explanation: "La production est intermittente.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Intelligence artificielle",
    question: "Quel texte européen adopté en 2024 encadre l’usage de l’IA ?",
    options: ["AI Act", "RGPD", "Digital Services Act"],
    answer: "AI Act",
    explanation: "Il régule les usages de l’intelligence artificielle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Intelligence artificielle",
    question:
        "Quel principe vise à rendre les décisions algorithmiques compréhensibles ?",
    options: ["Transparence", "Centralisation", "Automatisation"],
    answer: "Transparence",
    explanation: "Elle est essentielle pour la confiance des citoyens.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Médias & information",
    question:
        "Quel droit protège les journalistes dans l’exercice de leur métier ?",
    options: ["Protection des sources", "Secret défense", "Immunité pénale"],
    answer: "Protection des sources",
    explanation: "Elle garantit la liberté d’informer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Médias & information",
    question:
        "Quel phénomène consiste à ne s’informer qu’à travers des contenus similaires ?",
    options: ["Bulle informationnelle", "Pluralisme", "Censure"],
    answer: "Bulle informationnelle",
    explanation: "Elle limite la diversité des points de vue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Médias & information",
    question: "Quel classement international évalue la liberté de la presse ?",
    options: [
      "Reporters sans frontières",
      "Amnesty International",
      "ONU Femmes",
    ],
    answer: "Reporters sans frontières",
    explanation: "Il publie un classement annuel mondial.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question:
        "Quel risque majeur posent les réseaux sociaux pour l’information ?",
    options: [
      "Propagation rapide de fausses informations",
      "Disparition des médias",
      "Fin du journalisme",
    ],
    answer: "Propagation rapide de fausses informations",
    explanation: "Les contenus se diffusent sans vérification.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale — UE",
    question: "Quel objectif vise la souveraineté numérique européenne ?",
    options: [
      "Réduire la dépendance technologique",
      "Supprimer Internet",
      "Uniformiser les médias",
    ],
    answer: "Réduire la dépendance technologique",
    explanation: "Elle concerne les données et les infrastructures.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Actualité internationale — Conflits",
    question:
        "Quel conflit armé en Europe reste au cœur des tensions internationales en 2025 ?",
    options: [
      "La guerre en Ukraine",
      "Le conflit en Transnistrie",
      "La guerre du Kosovo",
    ],
    answer: "La guerre en Ukraine",
    explanation:
        "Le conflit déclenché en 2022 oppose toujours l’Ukraine à la Russie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale — ONU",
    question:
        "Quel organe de l’ONU peut adopter des sanctions internationales obligatoires ?",
    options: [
      "Conseil de sécurité",
      "Assemblée générale",
      "Secrétariat général",
    ],
    answer: "Conseil de sécurité",
    explanation: "Ses résolutions peuvent être juridiquement contraignantes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale — Grandes puissances",
    question:
        "Quel pays rivalise directement avec les États-Unis pour le leadership mondial en 2025 ?",
    options: ["Chine", "Inde", "Russie"],
    answer: "Chine",
    explanation:
        "La rivalité sino-américaine structure les relations internationales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale — UE",
    question:
        "Quel objectif principal guide la politique étrangère de l’Union européenne ?",
    options: [
      "Préserver la paix et la stabilité",
      "Imposer un modèle politique unique",
      "Remplacer l’ONU",
    ],
    answer: "Préserver la paix et la stabilité",
    explanation:
        "L’UE agit par la diplomatie, les sanctions et la coopération.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité internationale — UE",
    question:
        "Quel instrument l’Union européenne utilise pour sanctionner des États tiers ?",
    options: [
      "Sanctions économiques",
      "Interventions militaires directes",
      "Référendums",
    ],
    answer: "Sanctions économiques",
    explanation: "Elles sont décidées à l’unanimité par les États membres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Société française — Laïcité",
    question:
        "Quel principe garantit la neutralité religieuse de l’État français ?",
    options: ["Laïcité", "Pluralisme", "Tolérance"],
    answer: "Laïcité",
    explanation:
        "Elle assure la liberté de conscience et l’égalité des citoyens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française — Égalité femmes-hommes",
    question:
        "Quel outil mesure les inégalités salariales dans les entreprises françaises ?",
    options: [
      "Index égalité femmes-hommes",
      "Indice de parité sociale",
      "Baromètre national",
    ],
    answer: "Index égalité femmes-hommes",
    explanation:
        "Il est obligatoire pour les entreprises d’une certaine taille.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Société française — Immigration",
    question:
        "Quel droit fondamental protège une personne menacée dans son pays d’origine ?",
    options: ["Droit d’asile", "Droit du sol", "Regroupement familial"],
    answer: "Droit d’asile",
    explanation:
        "Il est reconnu par la Constitution et le droit international.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française — Démographie",
    question:
        "Comment appelle-t-on la différence entre naissances et décès en France ?",
    options: ["Solde naturel", "Solde migratoire", "Taux de dépendance"],
    answer: "Solde naturel",
    explanation: "Il indique la dynamique démographique interne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Écologie",
    question: "Quel objectif vise la neutralité carbone ?",
    options: [
      "Équilibrer émissions et absorptions de CO₂",
      "Arrêter toute production industrielle",
      "Supprimer les transports",
    ],
    answer: "Équilibrer émissions et absorptions de CO₂",
    explanation: "Objectif central des politiques climatiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Énergie",
    question:
        "Quelle énergie est au cœur du débat sur la souveraineté énergétique française ?",
    options: ["Nucléaire", "Charbon", "Pétrole"],
    answer: "Nucléaire",
    explanation:
        "Elle représente une part majeure de l’électricité produite en France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Intelligence artificielle",
    question:
        "Quel risque éthique majeur est associé à l’intelligence artificielle ?",
    options: [
      "Biais algorithmiques",
      "Fin de l’éducation",
      "Disparition de l’État",
    ],
    answer: "Biais algorithmiques",
    explanation: "Ils peuvent renforcer des discriminations existantes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Intelligence artificielle",
    question: "Quel texte européen encadre l’usage de l’IA depuis 2024 ?",
    options: ["AI Act", "RGPD", "Digital Markets Act"],
    answer: "AI Act",
    explanation: "Il classe les systèmes d’IA selon leur niveau de risque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question: "Quel rôle essentiel jouent les médias dans une démocratie ?",
    options: ["Informer les citoyens", "Rendre la justice", "Voter les lois"],
    answer: "Informer les citoyens",
    explanation:
        "Une information libre est indispensable au débat démocratique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question:
        "Comment appelle-t-on une information fausse diffusée volontairement ?",
    options: ["Fake news", "Tribune", "Éditorial"],
    answer: "Fake news",
    explanation: "Elle vise à tromper ou manipuler l’opinion publique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question: "Quel organisme français régule l’audiovisuel et le numérique ?",
    options: ["ARCOM", "CNIL", "CSA"],
    answer: "ARCOM",
    explanation: "Elle est issue de la fusion du CSA et de l’HADOPI.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Médias & information",
    question: "Quel droit protège les journalistes et leurs informateurs ?",
    options: ["Protection des sources", "Secret défense", "Immunité pénale"],
    answer: "Protection des sources",
    explanation: "Elle garantit la liberté et l’indépendance de la presse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité internationale — Société mondiale",
    question:
        "Quel enjeu mondial majeur est lié au vieillissement des populations ?",
    options: [
      "Financement des retraites",
      "Disparition des États",
      "Baisse de l’éducation",
    ],
    answer: "Financement des retraites",
    explanation: "Il concerne de nombreux pays développés.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Actualité internationale — Conflits",
    question:
        "Quel conflit au Moyen-Orient reste une source majeure de tensions internationales en 2025–2026 ?",
    options: [
      "Conflit israélo-palestinien",
      "Guerre Iran-Irak",
      "Conflit du Cachemire",
    ],
    answer: "Conflit israélo-palestinien",
    explanation: "Il demeure un enjeu central de la diplomatie internationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale — Grandes puissances",
    question:
        "Quel pays renforce sa présence diplomatique et économique en Afrique en 2025 ?",
    options: ["Chine", "Canada", "Australie"],
    answer: "Chine",
    explanation:
        "La Chine investit massivement dans les infrastructures africaines.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité internationale — ONU",
    question:
        "Quel objectif principal poursuit l’ONU en matière de développement durable ?",
    options: [
      "Réduction des inégalités mondiales",
      "Uniformisation des cultures",
      "Suppression des frontières",
    ],
    answer: "Réduction des inégalités mondiales",
    explanation: "Cet objectif figure dans l’Agenda 2030.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité internationale — UE",
    question:
        "Quel thème est au cœur des débats européens en 2026 concernant la défense ?",
    options: [
      "Autonomie stratégique",
      "Dissolution de l’OTAN",
      "Service militaire obligatoire européen",
    ],
    answer: "Autonomie stratégique",
    explanation: "L’UE cherche à renforcer ses capacités de défense.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité internationale — UE",
    question:
        "Quel enjeu migratoire mobilise fortement l’Union européenne en 2025 ?",
    options: [
      "Gestion des frontières extérieures",
      "Suppression de Schengen",
      "Vote obligatoire des migrants",
    ],
    answer: "Gestion des frontières extérieures",
    explanation: "Elle implique Frontex et les États membres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Société française — Laïcité",
    question:
        "Dans quel espace public la neutralité religieuse est-elle strictement obligatoire pour les agents ?",
    options: ["Services publics", "Entreprises privées", "Associations"],
    answer: "Services publics",
    explanation: "Les agents doivent respecter une neutralité stricte.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française — Égalité femmes-hommes",
    question:
        "Quel domaine reste marqué par des inégalités femmes-hommes en France ?",
    options: ["Rémunération", "Droit de vote", "Accès à l’éducation"],
    answer: "Rémunération",
    explanation:
        "Les écarts salariaux persistent malgré les politiques publiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française — Immigration",
    question:
        "Quel phénomène désigne l’arrivée durable de populations étrangères sur un territoire ?",
    options: ["Immigration", "Émigration", "Exode rural"],
    answer: "Immigration",
    explanation: "Elle peut être économique, familiale ou politique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française — Démographie",
    question:
        "Quel phénomène démographique concerne particulièrement la France en 2025 ?",
    options: [
      "Vieillissement de la population",
      "Explosion démographique",
      "Baisse de l’espérance de vie",
    ],
    answer: "Vieillissement de la population",
    explanation: "Il pose des enjeux sociaux et économiques majeurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Écologie",
    question:
        "Quel secteur est l’un des principaux émetteurs de gaz à effet de serre en France ?",
    options: ["Transports", "Éducation", "Culture"],
    answer: "Transports",
    explanation: "Ils représentent une part importante des émissions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Écologie",
    question:
        "Quel concept vise à produire et consommer de manière plus durable ?",
    options: ["Transition écologique", "Croissance illimitée", "Productivisme"],
    answer: "Transition écologique",
    explanation: "Elle cherche à réduire l’impact environnemental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Énergie",
    question:
        "Quel enjeu est central dans le débat sur les énergies renouvelables ?",
    options: [
      "Intermittence de la production",
      "Manque de soleil mondial",
      "Coût nul",
    ],
    answer: "Intermittence de la production",
    explanation: "La production dépend des conditions naturelles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Intelligence artificielle",
    question: "Quel secteur professionnel est fortement transformé par l’IA ?",
    options: ["Emploi", "Tourisme traditionnel", "Artisanat rural"],
    answer: "Emploi",
    explanation: "L’IA modifie les métiers et les compétences.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Intelligence artificielle",
    question:
        "Quel principe éthique est invoqué pour encadrer l’IA en Europe ?",
    options: [
      "Respect des droits fondamentaux",
      "Priorité à la rentabilité",
      "Automatisation totale",
    ],
    answer: "Respect des droits fondamentaux",
    explanation: "Il est au cœur de la régulation européenne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question:
        "Quel phénomène affaiblit la confiance du public dans l’information ?",
    options: [
      "Désinformation",
      "Pluralisme médiatique",
      "Journalisme d’investigation",
    ],
    answer: "Désinformation",
    explanation: "Elle brouille la distinction entre vrai et faux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question:
        "Quel rôle jouent les réseaux sociaux dans la diffusion de l’information ?",
    options: [
      "Accélération de la circulation des contenus",
      "Contrôle total de l’information",
      "Suppression des médias",
    ],
    answer: "Accélération de la circulation des contenus",
    explanation:
        "Ils permettent une diffusion rapide, parfois sans vérification.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question:
        "Quel principe garantit la diversité des opinions dans les médias ?",
    options: ["Pluralisme", "Censure", "Centralisation"],
    answer: "Pluralisme",
    explanation: "Il est essentiel au débat démocratique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité française — Débats publics",
    question:
        "Quel thème est régulièrement au centre des débats publics en France en 2025 ?",
    options: [
      "Réforme des retraites",
      "Suppression des communes",
      "Fin de la scolarité obligatoire",
    ],
    answer: "Réforme des retraites",
    explanation: "Elle concerne le financement et l’âge de départ.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité internationale — Conflits",
    question:
        "Quel conflit armé continue d’impliquer directement l’OTAN en soutien indirect en 2025 ?",
    options: [
      "Guerre en Ukraine",
      "Conflit syrien",
      "Conflit du Haut-Karabakh",
    ],
    answer: "Guerre en Ukraine",
    explanation: "L’OTAN soutient l’Ukraine sans engagement militaire direct.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale — ONU",
    question:
        "Quel organe de l’ONU adopte les Objectifs de développement durable ?",
    options: [
      "Assemblée générale",
      "Conseil de sécurité",
      "Secrétariat général",
    ],
    answer: "Assemblée générale",
    explanation: "Elle réunit l’ensemble des États membres.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité internationale — Grandes puissances",
    question:
        "Quel pays renforce sa présence militaire en mer de Chine méridionale ?",
    options: ["Chine", "Indonésie", "Philippines"],
    answer: "Chine",
    explanation: "La zone est stratégique pour le commerce mondial.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale — UE",
    question: "Quel enjeu domine les débats européens sur la défense en 2026 ?",
    options: [
      "Autonomie stratégique",
      "Dissolution de l’UE",
      "Neutralité militaire totale",
    ],
    answer: "Autonomie stratégique",
    explanation: "L’UE cherche à renforcer ses capacités propres.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité internationale — UE",
    question:
        "Quel mécanisme européen vise à protéger l’industrie face aux importations polluantes ?",
    options: [
      "Mécanisme d’ajustement carbone",
      "Politique agricole commune",
      "Plan Juncker",
    ],
    answer: "Mécanisme d’ajustement carbone",
    explanation: "Il lutte contre le dumping environnemental.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Société française — Laïcité",
    question: "Quel principe garantit la liberté de conscience en France ?",
    options: ["Laïcité", "Neutralité politique", "Pluralisme"],
    answer: "Laïcité",
    explanation: "Elle protège croyants et non-croyants.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française — Égalité femmes-hommes",
    question:
        "Quel domaine reste marqué par des écarts de représentation en France ?",
    options: ["Postes de direction", "Scolarisation", "Accès au vote"],
    answer: "Postes de direction",
    explanation: "Les femmes restent sous-représentées aux plus hauts niveaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française — Immigration",
    question:
        "Quel principe juridique encadre l’accueil des réfugiés en France ?",
    options: [
      "Convention de Genève",
      "Traité de Maastricht",
      "Accord de Schengen",
    ],
    answer: "Convention de Genève",
    explanation: "Elle définit le statut de réfugié.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Société française — Démographie",
    question:
        "Quel phénomène impacte le financement du système social français ?",
    options: [
      "Vieillissement de la population",
      "Explosion démographique",
      "Baisse de l’espérance de vie",
    ],
    answer: "Vieillissement de la population",
    explanation: "Il augmente le ratio retraités/actifs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Écologie",
    question:
        "Quel objectif vise la réduction de la dépendance aux énergies fossiles ?",
    options: [
      "Transition énergétique",
      "Croissance illimitée",
      "Mondialisation",
    ],
    answer: "Transition énergétique",
    explanation: "Elle favorise les énergies bas carbone.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Écologie",
    question:
        "Quel secteur est prioritaire dans la lutte contre le réchauffement climatique ?",
    options: ["Transports", "Culture", "Tourisme"],
    answer: "Transports",
    explanation: "Ils représentent une part importante des émissions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Énergie",
    question: "Quel avantage est souvent associé à l’énergie nucléaire ?",
    options: ["Faibles émissions de CO₂", "Coût nul", "Ressource renouvelable"],
    answer: "Faibles émissions de CO₂",
    explanation: "Elle produit peu de gaz à effet de serre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Énergie",
    question:
        "Quel défi majeur accompagne le développement du solaire et de l’éolien ?",
    options: [
      "Stockage de l’énergie",
      "Surabondance de production",
      "Pollution sonore mondiale",
    ],
    answer: "Stockage de l’énergie",
    explanation: "La production est intermittente.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Intelligence artificielle",
    question: "Quel risque social est associé à l’automatisation par l’IA ?",
    options: [
      "Transformation de l’emploi",
      "Disparition de l’école",
      "Fin des services publics",
    ],
    answer: "Transformation de l’emploi",
    explanation: "Certains métiers évoluent ou disparaissent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains — Intelligence artificielle",
    question: "Quel principe européen encadre l’usage responsable de l’IA ?",
    options: [
      "Respect des droits fondamentaux",
      "Priorité économique",
      "Automatisation totale",
    ],
    answer: "Respect des droits fondamentaux",
    explanation: "Il est central dans la régulation européenne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question:
        "Quel phénomène désigne la diffusion massive de fausses informations ?",
    options: ["Désinformation", "Pluralisme", "Journalisme"],
    answer: "Désinformation",
    explanation: "Elle nuit à la qualité du débat public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question: "Quel droit protège les journalistes contre les pressions ?",
    options: ["Protection des sources", "Secret défense", "Immunité totale"],
    answer: "Protection des sources",
    explanation: "Elle garantit l’indépendance de la presse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Médias & information",
    question: "Quel principe garantit la diversité des opinions médiatiques ?",
    options: ["Pluralisme", "Centralisation", "Censure"],
    answer: "Pluralisme",
    explanation: "Il est essentiel à la démocratie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité française — Débats publics",
    question:
        "Quel sujet reste au cœur des débats sociaux en France en 2025–2026 ?",
    options: [
      "Réforme des retraites",
      "Suppression des régions",
      "Fin de la sécurité sociale",
    ],
    answer: "Réforme des retraites",
    explanation: "Elle concerne l’âge légal et le financement.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Médias & information",
    question: "Quel principe garantit la liberté de la presse en France ?",
    options: [
      "Liberté d’expression",
      "Neutralité religieuse",
      "Secret défense",
    ],
    answer: "Liberté d’expression",
    explanation: "Elle est protégée par la Déclaration des droits de l’homme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question:
        "Quel organisme publie chaque année un classement mondial de la liberté de la presse ?",
    options: ["Reporters sans frontières", "ONU", "UNESCO"],
    answer: "Reporters sans frontières",
    explanation: "Ce classement évalue l’indépendance des médias.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question:
        "Quel phénomène désigne la diffusion massive d’informations fausses en ligne ?",
    options: ["Désinformation", "Pluralisme", "Censure"],
    answer: "Désinformation",
    explanation: "Elle vise à manipuler l’opinion publique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Médias & information",
    question:
        "Quel terme décrit une information vraie sortie de son contexte pour tromper ?",
    options: ["Mésinformation", "Fake news", "Propagande"],
    answer: "Mésinformation",
    explanation: "Elle repose sur des faits déformés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question: "Quel acteur vérifie la fiabilité d’une information publiée ?",
    options: ["Journaliste", "Influenceur", "Algorithme"],
    answer: "Journaliste",
    explanation: "Il respecte des règles déontologiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale",
    question:
        "Quelle organisation internationale vise à maintenir la paix mondiale ?",
    options: ["ONU", "OTAN", "G7"],
    answer: "ONU",
    explanation: "Elle a été créée en 1945.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale",
    question:
        "Quel conflit a des conséquences majeures sur l’économie mondiale en 2025 ?",
    options: [
      "Guerre en Ukraine",
      "Conflit israélo-palestinien",
      "Guerre civile syrienne",
    ],
    answer: "Guerre en Ukraine",
    explanation: "Elle impacte l’énergie et l’alimentation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale",
    question:
        "Quel pays est membre permanent du Conseil de sécurité de l’ONU ?",
    options: ["France", "Allemagne", "Japon"],
    answer: "France",
    explanation: "Elle dispose du droit de veto.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité internationale",
    question: "Quel organe de l’ONU vote les résolutions contraignantes ?",
    options: ["Conseil de sécurité", "Assemblée générale", "Secrétariat"],
    answer: "Conseil de sécurité",
    explanation: "Ses décisions peuvent être obligatoires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité internationale",
    question:
        "Quelle grande puissance est au cœur des tensions autour de Taïwan ?",
    options: ["Chine", "Russie", "Inde"],
    answer: "Chine",
    explanation: "Taïwan est revendiquée par Pékin.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française",
    question: "Quel principe interdit les discriminations en France ?",
    options: ["Égalité", "Laïcité", "Neutralité"],
    answer: "Égalité",
    explanation: "Il est inscrit dans la Constitution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française",
    question: "Quel principe impose la neutralité religieuse de l’État ?",
    options: ["Laïcité", "Liberté de culte", "Pluralisme"],
    answer: "Laïcité",
    explanation: "Il garantit la séparation des religions et de l’État.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française",
    question:
        "Quel sujet fait l’objet de débats réguliers dans la société française ?",
    options: [
      "Immigration",
      "Suppression des communes",
      "Fin du suffrage universel",
    ],
    answer: "Immigration",
    explanation: "Il soulève des enjeux sociaux et politiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française",
    question: "Quel indicateur mesure l’évolution de la population française ?",
    options: ["Démographie", "Inflation", "Croissance"],
    answer: "Démographie",
    explanation: "Elle étudie les naissances et les décès.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Société française",
    question:
        "Quel droit protège les femmes contre les discriminations professionnelles ?",
    options: ["Égalité salariale", "Droit syndical", "Liberté d’association"],
    answer: "Égalité salariale",
    explanation: "Elle vise à réduire les écarts de rémunération.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Grands débats contemporains",
    question: "Quel enjeu majeur accompagne le changement climatique ?",
    options: [
      "Transition écologique",
      "Croissance démographique",
      "Centralisation politique",
    ],
    answer: "Transition écologique",
    explanation: "Elle vise à réduire l’impact environnemental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains",
    question:
        "Quel secteur est le plus concerné par la transition énergétique ?",
    options: ["Énergie", "Justice", "Éducation"],
    answer: "Énergie",
    explanation: "Il est au cœur de la réduction des émissions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains",
    question: "Quel risque éthique est lié à l’intelligence artificielle ?",
    options: [
      "Biais algorithmiques",
      "Fin de l’électricité",
      "Disparition d’Internet",
    ],
    answer: "Biais algorithmiques",
    explanation: "Ils peuvent renforcer des discriminations.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Grands débats contemporains",
    question: "Quel domaine est fortement impacté par l’automatisation ?",
    options: ["Emploi", "Religion", "Sport"],
    answer: "Emploi",
    explanation: "Certains métiers évoluent ou disparaissent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains",
    question: "Quel objectif vise le développement durable ?",
    options: [
      "Équilibre économique, social et environnemental",
      "Croissance illimitée",
      "Réduction des droits",
    ],
    answer: "Équilibre économique, social et environnemental",
    explanation: "Il concilie plusieurs dimensions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité française",
    question: "Quel thème est central dans les débats politiques récents ?",
    options: [
      "Pouvoir d’achat",
      "Suppression des élections",
      "Fin des services publics",
    ],
    answer: "Pouvoir d’achat",
    explanation: "Il concerne le niveau de vie des ménages.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité française",
    question: "Quel service public est essentiel au système social français ?",
    options: ["Sécurité sociale", "Banques privées", "Assurances commerciales"],
    answer: "Sécurité sociale",
    explanation: "Elle protège contre les risques sociaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité française",
    question: "Quel débat concerne directement le système des retraites ?",
    options: [
      "Âge de départ",
      "Suppression des pensions",
      "Privatisation totale",
    ],
    answer: "Âge de départ",
    explanation: "Il est au cœur des réformes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité française",
    question:
        "Quel principe garantit la participation des citoyens aux élections ?",
    options: ["Suffrage universel", "Centralisation", "Nomination"],
    answer: "Suffrage universel",
    explanation: "Il permet à tous les citoyens de voter.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité française",
    question: "Quel rôle jouent les médias dans une démocratie ?",
    options: ["Informer", "Censurer", "Diriger"],
    answer: "Informer",
    explanation: "Ils participent au débat public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question: "Quel risque est lié à la viralité sur les réseaux sociaux ?",
    options: [
      "Propagation rapide de fausses informations",
      "Amélioration du pluralisme",
      "Renforcement de la censure",
    ],
    answer: "Propagation rapide de fausses informations",
    explanation: "Les contenus se diffusent sans vérification.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Médias & information",
    question:
        "Quel terme désigne la manipulation de l’opinion par les médias ?",
    options: ["Propagande", "Information", "Pluralisme"],
    answer: "Propagande",
    explanation: "Elle oriente volontairement les opinions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Médias & information",
    question: "Quel support est considéré comme un média numérique ?",
    options: ["Site internet", "Journal papier", "Affiche"],
    answer: "Site internet",
    explanation: "Il diffuse l’information en ligne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question: "Quel principe impose la vérification des sources ?",
    options: [
      "Déontologie journalistique",
      "Liberté totale",
      "Secret professionnel",
    ],
    answer: "Déontologie journalistique",
    explanation: "Elle encadre le métier de journaliste.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Médias & information",
    question:
        "Quel danger menace la démocratie en cas de désinformation massive ?",
    options: [
      "Manipulation de l’opinion",
      "Renforcement des libertés",
      "Meilleure information",
    ],
    answer: "Manipulation de l’opinion",
    explanation: "Elle fausse le débat public.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Actualité internationale",
    question:
        "Quel organisme international coordonne l’aide humanitaire en cas de crise majeure ?",
    options: ["ONU", "OTAN", "G20"],
    answer: "ONU",
    explanation: "Elle coordonne l’aide via plusieurs agences spécialisées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale",
    question:
        "Quel pays est au cœur des tensions en mer de Chine méridionale ?",
    options: ["Chine", "Japon", "Australie"],
    answer: "Chine",
    explanation: "La zone est stratégique pour le commerce mondial.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale",
    question:
        "Quelle organisation regroupe les principales économies mondiales ?",
    options: ["G20", "G7", "OCDE"],
    answer: "G20",
    explanation: "Elle inclut pays développés et émergents.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité internationale",
    question:
        "Quel conflit influence fortement les marchés de l’énergie depuis 2022 ?",
    options: ["Guerre en Ukraine", "Conflit syrien", "Guerre du Yémen"],
    answer: "Guerre en Ukraine",
    explanation: "Il affecte notamment le gaz et le pétrole.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité internationale",
    question:
        "Quel pays joue un rôle central dans la médiation internationale en 2025 ?",
    options: ["États-Unis", "Suisse", "France"],
    answer: "États-Unis",
    explanation: "Ils sont impliqués dans de nombreuses négociations.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Société française",
    question: "Quel principe garantit la liberté de conscience en France ?",
    options: ["Laïcité", "Neutralité", "Centralisation"],
    answer: "Laïcité",
    explanation: "Elle protège la liberté de croire ou non.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française",
    question:
        "Quel phénomène social concerne l’augmentation de l’espérance de vie ?",
    options: ["Vieillissement", "Urbanisation", "Migration"],
    answer: "Vieillissement",
    explanation: "Il a des impacts économiques et sociaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française",
    question: "Quel débat concerne l’intégration des populations immigrées ?",
    options: ["Cohésion sociale", "Privatisation", "Délocalisation"],
    answer: "Cohésion sociale",
    explanation: "Il touche à l’égalité et au vivre-ensemble.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Société française",
    question: "Quel principe protège contre les discriminations ?",
    options: [
      "Égalité devant la loi",
      "Liberté économique",
      "Neutralité commerciale",
    ],
    answer: "Égalité devant la loi",
    explanation: "Il est garanti constitutionnellement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Société française",
    question: "Quel indicateur mesure la pauvreté dans un pays ?",
    options: ["Taux de pauvreté", "PIB", "Inflation"],
    answer: "Taux de pauvreté",
    explanation: "Il évalue les inégalités sociales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Grands débats contemporains",
    question: "Quel enjeu central accompagne la transition écologique ?",
    options: [
      "Réduction des émissions",
      "Augmentation de la production",
      "Centralisation politique",
    ],
    answer: "Réduction des émissions",
    explanation: "Elle vise à limiter le réchauffement climatique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains",
    question: "Quel secteur est le plus concerné par la décarbonation ?",
    options: ["Transports", "Culture", "Justice"],
    answer: "Transports",
    explanation: "Ils sont une source majeure d’émissions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Grands débats contemporains",
    question: "Quel risque social est lié à l’automatisation ?",
    options: [
      "Perte d’emplois",
      "Hausse de la natalité",
      "Fin des services publics",
    ],
    answer: "Perte d’emplois",
    explanation: "Certains métiers sont menacés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Grands débats contemporains",
    question: "Quel enjeu éthique concerne l’usage massif des données ?",
    options: [
      "Protection de la vie privée",
      "Croissance économique",
      "Centralisation étatique",
    ],
    answer: "Protection de la vie privée",
    explanation: "Elle est essentielle aux libertés individuelles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Grands débats contemporains",
    question: "Quel objectif vise la sobriété énergétique ?",
    options: [
      "Réduire la consommation",
      "Augmenter la production",
      "Exporter davantage",
    ],
    answer: "Réduire la consommation",
    explanation: "Elle limite l’impact environnemental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité française",
    question:
        "Quel thème revient fréquemment dans les débats sociaux récents ?",
    options: ["Pouvoir d’achat", "Suppression des communes", "Fin du suffrage"],
    answer: "Pouvoir d’achat",
    explanation: "Il concerne le niveau de vie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité française",
    question: "Quel service public est au cœur du modèle social français ?",
    options: ["Sécurité sociale", "Banques privées", "Assurances commerciales"],
    answer: "Sécurité sociale",
    explanation: "Elle protège contre les risques sociaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité française",
    question: "Quel débat concerne directement le financement des retraites ?",
    options: [
      "Durée de cotisation",
      "Suppression des pensions",
      "Privatisation",
    ],
    answer: "Durée de cotisation",
    explanation: "Elle conditionne l’accès à la retraite.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité française",
    question:
        "Quel principe garantit la participation politique des citoyens ?",
    options: ["Suffrage universel", "Nomination", "Centralisation"],
    answer: "Suffrage universel",
    explanation: "Il permet à tous les citoyens de voter.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité française",
    question: "Quel rôle joue l’État dans la régulation économique ?",
    options: ["Régulateur", "Consommateur", "Producteur unique"],
    answer: "Régulateur",
    explanation: "Il fixe les règles du marché.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Médias & information",
    question: "Quel risque démocratique pose la désinformation ?",
    options: [
      "Manipulation de l’opinion",
      "Renforcement du pluralisme",
      "Amélioration du débat",
    ],
    answer: "Manipulation de l’opinion",
    explanation: "Elle fausse le jugement des citoyens.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Médias & information",
    question: "Quel principe impose l’indépendance des journalistes ?",
    options: ["Déontologie", "Censure", "Centralisation"],
    answer: "Déontologie",
    explanation: "Elle encadre les pratiques professionnelles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Médias & information",
    question: "Quel média permet une diffusion instantanée de l’information ?",
    options: ["Réseaux sociaux", "Presse écrite", "Affiche"],
    answer: "Réseaux sociaux",
    explanation: "Ils accélèrent la circulation de l’information.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Médias & information",
    question: "Quel danger est lié aux bulles informationnelles ?",
    options: [
      "Vision biaisée du monde",
      "Meilleure information",
      "Pluralisme renforcé",
    ],
    answer: "Vision biaisée du monde",
    explanation: "Elles limitent la diversité des points de vue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Médias & information",
    question: "Quel droit protège la liberté d’informer en démocratie ?",
    options: ["Liberté de la presse", "Secret défense", "Immunité totale"],
    answer: "Liberté de la presse",
    explanation: "Elle est un pilier démocratique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe garantit la liberté de manifester en France ?",
    options: ["Liberté d’expression", "Ordre public", "Neutralité"],
    answer: "Liberté d’expression",
    explanation: "Elle est protégée par la Constitution et la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel enjeu social est directement lié à l’inflation ?",
    options: ["Pouvoir d’achat", "Taux de natalité", "Temps de travail"],
    answer: "Pouvoir d’achat",
    explanation: "L’inflation réduit la capacité de consommation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe protège la liberté d’opinion en France ?",
    options: ["Pluralisme", "Centralisation", "Censure"],
    answer: "Pluralisme",
    explanation: "Il garantit la diversité des idées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel phénomène social concerne la hausse des loyers ?",
    options: ["Crise du logement", "Transition écologique", "Décentralisation"],
    answer: "Crise du logement",
    explanation: "Elle touche particulièrement les grandes villes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel droit protège les salariés contre les discriminations ?",
    options: ["Droit du travail", "Droit commercial", "Droit pénal"],
    answer: "Droit du travail",
    explanation: "Il encadre les relations professionnelles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu mondial concerne directement la sécurité alimentaire ?",
    options: ["Changement climatique", "Numérisation", "Urbanisation"],
    answer: "Changement climatique",
    explanation: "Il affecte les productions agricoles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel phénomène mondial provoque des déplacements de population ?",
    options: [
      "Crises humanitaires",
      "Innovation technologique",
      "Croissance économique",
    ],
    answer: "Crises humanitaires",
    explanation: "Elles sont souvent liées aux conflits et au climat.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel acteur international coordonne l’aide aux réfugiés ?",
    options: ["HCR", "OMC", "FMI"],
    answer: "HCR",
    explanation: "Le Haut-Commissariat pour les réfugiés dépend de l’ONU.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel débat concerne la régulation des plateformes numériques ?",
    options: [
      "Liberté d’expression",
      "Souveraineté alimentaire",
      "Politique monétaire",
    ],
    answer: "Liberté d’expression",
    explanation: "Les contenus en ligne posent des enjeux démocratiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel enjeu est central dans les discussions sur l’IA ?",
    options: ["Éthique", "Sport", "Tourisme"],
    answer: "Éthique",
    explanation: "Elle concerne les libertés et les droits fondamentaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel phénomène désigne la diffusion rapide d’informations non vérifiées ?",
    options: ["Viralité", "Pluralisme", "Déontologie"],
    answer: "Viralité",
    explanation: "Les réseaux sociaux accélèrent la diffusion.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel principe impose l’indépendance éditoriale des médias ?",
    options: ["Liberté de la presse", "Contrôle étatique", "Centralisation"],
    answer: "Liberté de la presse",
    explanation: "Elle est essentielle en démocratie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel risque est lié à la concentration des médias ?",
    options: [
      "Réduction du pluralisme",
      "Meilleure information",
      "Neutralité accrue",
    ],
    answer: "Réduction du pluralisme",
    explanation: "Moins d’acteurs signifie moins de diversité d’opinions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel rôle jouent les journalistes dans une démocratie ?",
    options: [
      "Informer les citoyens",
      "Contrôler les élections",
      "Diriger l’État",
    ],
    answer: "Informer les citoyens",
    explanation: "Ils participent au débat public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel danger représente la désinformation massive ?",
    options: [
      "Manipulation de l’opinion",
      "Renforcement du débat",
      "Pluralisme accru",
    ],
    answer: "Manipulation de l’opinion",
    explanation: "Elle peut influencer les choix démocratiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu social accompagne la transition numérique ?",
    options: [
      "Inégalités d’accès",
      "Croissance démographique",
      "Décentralisation",
    ],
    answer: "Inégalités d’accès",
    explanation: "Tout le monde n’a pas les mêmes moyens numériques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel sujet est central dans le débat sur le travail aujourd’hui ?",
    options: [
      "Qualité de vie",
      "Suppression du salariat",
      "Fin du droit du travail",
    ],
    answer: "Qualité de vie",
    explanation: "Elle inclut équilibre vie pro/vie perso.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu accompagne le développement du télétravail ?",
    options: [
      "Organisation du travail",
      "Centralisation",
      "Suppression des congés",
    ],
    answer: "Organisation du travail",
    explanation: "Il modifie les pratiques professionnelles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel objectif vise l’inclusion sociale ?",
    options: [
      "Réduire les exclusions",
      "Accroître les inégalités",
      "Limiter les droits",
    ],
    answer: "Réduire les exclusions",
    explanation: "Elle vise l’égalité des chances.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu concerne directement la jeunesse aujourd’hui ?",
    options: [
      "Insertion professionnelle",
      "Suppression de l’école",
      "Fin de la formation",
    ],
    answer: "Insertion professionnelle",
    explanation: "L’accès à l’emploi est un défi majeur.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel principe constitutionnel garantit la liberté d’expression en France ?",
    options: ["Liberté d’opinion", "Ordre public", "Neutralité administrative"],
    answer: "Liberté d’opinion",
    explanation:
        "Elle est inscrite dans la Déclaration des droits de l’homme et du citoyen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel sujet est au cœur des débats sur le système social français en 2025 ?",
    options: [
      "Financement des retraites",
      "Suppression des communes",
      "Privatisation de l’école",
    ],
    answer: "Financement des retraites",
    explanation:
        "Le vieillissement de la population pose des enjeux budgétaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel droit protège les citoyens contre les discriminations ?",
    options: [
      "Principe d’égalité",
      "Principe de subsidiarité",
      "Principe de précaution",
    ],
    answer: "Principe d’égalité",
    explanation: "Il garantit l’égalité devant la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel phénomène social concerne l’augmentation du nombre de personnes âgées ?",
    options: ["Vieillissement démographique", "Urbanisation", "Mondialisation"],
    answer: "Vieillissement démographique",
    explanation: "Il impacte la santé et les politiques publiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel enjeu est central dans le débat sur l’immigration en France ?",
    options: ["Intégration", "Privatisation", "Centralisation"],
    answer: "Intégration",
    explanation: "Elle concerne l’accès à l’emploi et aux services publics.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel principe impose la neutralité religieuse des services publics ?",
    options: ["Laïcité", "Pluralisme", "Liberté économique"],
    answer: "Laïcité",
    explanation: "Les services publics doivent rester neutres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel enjeu mondial est lié à la hausse des températures ?",
    options: [
      "Changement climatique",
      "Croissance démographique",
      "Numérisation",
    ],
    answer: "Changement climatique",
    explanation: "Il affecte les écosystèmes et les sociétés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel organisme international coordonne l’aide humanitaire d’urgence ?",
    options: ["ONU", "OMC", "FMI"],
    answer: "ONU",
    explanation: "Elle agit via plusieurs agences spécialisées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel phénomène mondial provoque des migrations forcées ?",
    options: [
      "Conflits armés",
      "Innovation technologique",
      "Croissance économique",
    ],
    answer: "Conflits armés",
    explanation: "Ils entraînent des déplacements de populations.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel enjeu concerne la sécurité alimentaire mondiale ?",
    options: [
      "Accès aux ressources agricoles",
      "Numérisation",
      "Décentralisation",
    ],
    answer: "Accès aux ressources agricoles",
    explanation: "Il dépend du climat et des conflits.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel débat oppose régulation et liberté sur Internet ?",
    options: [
      "Liberté d’expression",
      "Politique monétaire",
      "Tourisme international",
    ],
    answer: "Liberté d’expression",
    explanation: "Il concerne la modération des contenus.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel risque est lié à l’absence de coopération internationale ?",
    options: [
      "Instabilité mondiale",
      "Croissance accélérée",
      "Réduction des conflits",
    ],
    answer: "Instabilité mondiale",
    explanation: "La coopération est essentielle pour la paix.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel terme désigne la diffusion volontaire de fausses informations ?",
    options: ["Désinformation", "Pluralisme", "Déontologie"],
    answer: "Désinformation",
    explanation: "Elle vise à tromper le public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel principe protège la diversité des opinions dans les médias ?",
    options: ["Pluralisme", "Censure", "Centralisation"],
    answer: "Pluralisme",
    explanation: "Il garantit un débat démocratique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel risque est lié à la concentration des groupes médiatiques ?",
    options: [
      "Réduction du pluralisme",
      "Amélioration de l’information",
      "Neutralité accrue",
    ],
    answer: "Réduction du pluralisme",
    explanation: "Moins d’acteurs signifie moins de diversité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel droit fondamental protège les journalistes dans l’exercice de leur métier ?",
    options: ["Protection des sources", "Secret défense", "Immunité totale"],
    answer: "Protection des sources",
    explanation: "Elle garantit l’indépendance de la presse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel danger représente la propagation massive de fausses informations ?",
    options: [
      "Manipulation de l’opinion",
      "Renforcement du débat",
      "Pluralisme accru",
    ],
    answer: "Manipulation de l’opinion",
    explanation: "Elle peut influencer les choix démocratiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu social accompagne la transition numérique ?",
    options: [
      "Inégalités d’accès",
      "Croissance démographique",
      "Centralisation politique",
    ],
    answer: "Inégalités d’accès",
    explanation: "Tout le monde n’a pas les mêmes moyens numériques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel risque social est lié à l’automatisation du travail ?",
    options: [
      "Perte d’emplois",
      "Hausse de la natalité",
      "Fin des services publics",
    ],
    answer: "Perte d’emplois",
    explanation: "Certains métiers sont menacés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu éthique est central dans le développement de l’IA ?",
    options: [
      "Respect des droits fondamentaux",
      "Croissance économique",
      "Tourisme",
    ],
    answer: "Respect des droits fondamentaux",
    explanation: "L’IA peut porter atteinte aux libertés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel objectif vise le développement durable ?",
    options: [
      "Équilibre entre économie, social et environnement",
      "Croissance illimitée",
      "Réduction des droits sociaux",
    ],
    answer: "Équilibre entre économie, social et environnement",
    explanation: "Il cherche un modèle soutenable.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe garantit la liberté de conscience en France ?",
    options: ["Laïcité", "Neutralité politique", "Centralisation"],
    answer: "Laïcité",
    explanation: "La laïcité protège la liberté de croire ou de ne pas croire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel enjeu social est lié à l’augmentation du coût de la vie ?",
    options: ["Pouvoir d’achat", "Temps de travail", "Décentralisation"],
    answer: "Pouvoir d’achat",
    explanation: "Il concerne la capacité des ménages à consommer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel droit fondamental protège la liberté de manifester ?",
    options: ["Liberté d’expression", "Ordre public", "Neutralité"],
    answer: "Liberté d’expression",
    explanation: "Elle est garantie par les textes fondamentaux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel phénomène social touche particulièrement les grandes villes ?",
    options: ["Crise du logement", "Exode rural", "Baisse démographique"],
    answer: "Crise du logement",
    explanation: "Elle se traduit par des loyers élevés et une pénurie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe constitutionnel interdit les discriminations ?",
    options: [
      "Égalité devant la loi",
      "Principe de précaution",
      "Subsidiarité",
    ],
    answer: "Égalité devant la loi",
    explanation: "Il garantit les mêmes droits à tous.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu mondial est directement lié aux migrations climatiques ?",
    options: ["Changement climatique", "Numérisation", "Croissance économique"],
    answer: "Changement climatique",
    explanation: "Il provoque des déplacements de populations.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel organisme international s’occupe des réfugiés ?",
    options: ["HCR", "FMI", "OMC"],
    answer: "HCR",
    explanation: "Il dépend des Nations unies.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel risque mondial est lié aux tensions géopolitiques actuelles ?",
    options: [
      "Instabilité internationale",
      "Croissance accélérée",
      "Baisse des conflits",
    ],
    answer: "Instabilité internationale",
    explanation: "Les tensions fragilisent la paix mondiale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu concerne la régulation des grandes plateformes numériques ?",
    options: ["Protection des libertés", "Tourisme", "Agriculture"],
    answer: "Protection des libertés",
    explanation: "Les plateformes influencent l’information.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel thème est central dans les débats sur la mondialisation ?",
    options: ["Inégalités", "Sport", "Culture locale"],
    answer: "Inégalités",
    explanation: "La mondialisation accentue certains écarts.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel principe impose la vérification des informations publiées ?",
    options: ["Déontologie journalistique", "Liberté totale", "Censure"],
    answer: "Déontologie journalistique",
    explanation: "Elle encadre les pratiques des journalistes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel risque est lié à la surinformation ?",
    options: [
      "Confusion du public",
      "Meilleure compréhension",
      "Pluralisme accru",
    ],
    answer: "Confusion du public",
    explanation: "Trop d’informations peut nuire à la compréhension.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel support est considéré comme un média traditionnel ?",
    options: ["Presse écrite", "Réseaux sociaux", "Plateformes vidéo"],
    answer: "Presse écrite",
    explanation: "Elle existe avant le numérique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel danger représente la manipulation de l’information ?",
    options: [
      "Atteinte à la démocratie",
      "Renforcement du débat",
      "Pluralisme accru",
    ],
    answer: "Atteinte à la démocratie",
    explanation: "Elle fausse l’opinion publique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu social accompagne le développement du télétravail ?",
    options: [
      "Équilibre vie professionnelle/vie personnelle",
      "Centralisation",
      "Suppression des congés",
    ],
    answer: "Équilibre vie professionnelle/vie personnelle",
    explanation: "Le télétravail modifie l’organisation du travail.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel objectif vise la transition écologique ?",
    options: [
      "Réduction de l’impact environnemental",
      "Croissance illimitée",
      "Centralisation politique",
    ],
    answer: "Réduction de l’impact environnemental",
    explanation: "Elle vise à préserver les ressources.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel enjeu est central dans le débat sur l’intelligence artificielle ?",
    options: ["Protection des libertés", "Tourisme", "Agriculture"],
    answer: "Protection des libertés",
    explanation: "L’IA peut porter atteinte aux droits fondamentaux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel risque social est lié à la précarité de l’emploi ?",
    options: [
      "Insécurité économique",
      "Hausse de la natalité",
      "Réduction du temps de travail",
    ],
    answer: "Insécurité économique",
    explanation: "Elle fragilise les parcours professionnels.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu concerne directement la jeunesse aujourd’hui ?",
    options: [
      "Insertion professionnelle",
      "Suppression de l’école",
      "Fin de la formation",
    ],
    answer: "Insertion professionnelle",
    explanation: "L’accès à l’emploi est un défi majeur.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe garantit la liberté de réunion en France ?",
    options: ["Liberté d’expression", "Ordre public", "Neutralité"],
    answer: "Liberté d’expression",
    explanation: "La liberté de réunion découle de la liberté d’expression.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel enjeu social est lié à la hausse des prix de l’énergie ?",
    options: ["Précarité énergétique", "Décentralisation", "Mobilité sociale"],
    answer: "Précarité énergétique",
    explanation: "Elle touche les ménages aux revenus modestes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel droit protège la vie privée des citoyens ?",
    options: [
      "Droit au respect de la vie privée",
      "Droit commercial",
      "Droit électoral",
    ],
    answer: "Droit au respect de la vie privée",
    explanation: "Il est garanti par la loi et la jurisprudence.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel phénomène social est lié à l’allongement de la durée de vie ?",
    options: ["Vieillissement de la population", "Urbanisation", "Exode rural"],
    answer: "Vieillissement de la population",
    explanation: "Il modifie les besoins sociaux et sanitaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe fonde l’accès égal aux services publics ?",
    options: ["Égalité", "Subsidiarité", "Centralisation"],
    answer: "Égalité",
    explanation: "Tous les citoyens doivent être traités de la même manière.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel enjeu mondial est lié à l’accès à l’eau potable ?",
    options: [
      "Développement durable",
      "Numérisation",
      "Mondialisation financière",
    ],
    answer: "Développement durable",
    explanation: "L’eau est une ressource essentielle et limitée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel phénomène mondial accentue les inégalités entre pays ?",
    options: ["Mondialisation", "Décentralisation", "Neutralité"],
    answer: "Mondialisation",
    explanation: "Elle peut accentuer les écarts de richesse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel organisme international lutte contre la faim dans le monde ?",
    options: ["PAM", "FMI", "OMC"],
    answer: "PAM",
    explanation: "Le Programme alimentaire mondial dépend de l’ONU.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel risque est lié aux conflits prolongés ?",
    options: [
      "Crises humanitaires",
      "Croissance économique",
      "Stabilité politique",
    ],
    answer: "Crises humanitaires",
    explanation: "Les populations civiles sont fortement touchées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu concerne la régulation d’Internet à l’échelle mondiale ?",
    options: ["Protection des droits fondamentaux", "Tourisme", "Agriculture"],
    answer: "Protection des droits fondamentaux",
    explanation: "Internet influence la liberté d’expression.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel principe impose la distinction entre information et opinion ?",
    options: ["Déontologie journalistique", "Pluralisme", "Liberté totale"],
    answer: "Déontologie journalistique",
    explanation: "Elle encadre la pratique du journalisme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel risque est lié aux algorithmes des réseaux sociaux ?",
    options: [
      "Bulle informationnelle",
      "Pluralisme renforcé",
      "Neutralité accrue",
    ],
    answer: "Bulle informationnelle",
    explanation: "Ils limitent l’exposition à des opinions différentes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel média repose principalement sur l’image et le son ?",
    options: ["Télévision", "Presse écrite", "Radio"],
    answer: "Télévision",
    explanation: "Elle combine image et audio.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel danger est lié à la censure de l’information ?",
    options: [
      "Atteinte à la démocratie",
      "Renforcement du débat",
      "Pluralisme accru",
    ],
    answer: "Atteinte à la démocratie",
    explanation: "La liberté d’informer est essentielle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu social est lié au vieillissement de la population ?",
    options: [
      "Financement des retraites",
      "Suppression des emplois",
      "Centralisation politique",
    ],
    answer: "Financement des retraites",
    explanation: "Moins d’actifs financent plus de retraités.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel objectif vise la lutte contre les discriminations ?",
    options: ["Égalité des chances", "Croissance économique", "Centralisation"],
    answer: "Égalité des chances",
    explanation: "Elle vise à réduire les inégalités sociales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel risque est lié à l’utilisation massive des données personnelles ?",
    options: [
      "Atteinte à la vie privée",
      "Croissance économique",
      "Amélioration automatique des services",
    ],
    answer: "Atteinte à la vie privée",
    explanation: "Les données peuvent être détournées.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu concerne l’adaptation des villes au climat ?",
    options: ["Transition écologique", "Centralisation", "Délocalisation"],
    answer: "Transition écologique",
    explanation: "Les villes doivent réduire leur impact environnemental.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel défi concerne l’accès à l’éducation aujourd’hui ?",
    options: [
      "Égalité d’accès",
      "Suppression de l’école",
      "Fin de la formation",
    ],
    answer: "Égalité d’accès",
    explanation: "Tous doivent pouvoir accéder à l’éducation.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel principe garantit l’accès égal aux droits sociaux en France ?",
    options: [
      "Solidarité nationale",
      "Centralisation",
      "Neutralité économique",
    ],
    answer: "Solidarité nationale",
    explanation: "Elle fonde le modèle social français.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel enjeu social est lié à l’augmentation du nombre de travailleurs pauvres ?",
    options: [
      "Précarité de l’emploi",
      "Décentralisation",
      "Automatisation totale",
    ],
    answer: "Précarité de l’emploi",
    explanation:
        "Elle concerne des personnes en emploi mais en difficulté financière.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel droit protège les citoyens contre l’arbitraire de l’administration ?",
    options: ["État de droit", "Ordre public", "Souveraineté"],
    answer: "État de droit",
    explanation: "Il impose le respect de la loi par les pouvoirs publics.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel phénomène social touche particulièrement les jeunes actifs ?",
    options: [
      "Difficulté d’accès au logement",
      "Exode rural massif",
      "Baisse de la scolarisation",
    ],
    answer: "Difficulté d’accès au logement",
    explanation: "Les loyers élevés limitent l’autonomie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe protège la liberté syndicale ?",
    options: [
      "Liberté d’association",
      "Neutralité religieuse",
      "Centralisation",
    ],
    answer: "Liberté d’association",
    explanation: "Elle permet la création de syndicats.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel enjeu mondial est lié à la hausse des migrations forcées ?",
    options: ["Crises géopolitiques", "Numérisation", "Croissance économique"],
    answer: "Crises géopolitiques",
    explanation: "Les conflits provoquent des déplacements massifs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel organisme international lutte contre le réchauffement climatique ?",
    options: ["ONU", "OMC", "FMI"],
    answer: "ONU",
    explanation: "Elle coordonne les accords climatiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel enjeu concerne la sécurité alimentaire mondiale ?",
    options: [
      "Accès aux ressources agricoles",
      "Tourisme international",
      "Numérisation",
    ],
    answer: "Accès aux ressources agricoles",
    explanation: "Il dépend du climat et des conflits.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel risque est lié à l’absence de coopération internationale ?",
    options: [
      "Instabilité mondiale",
      "Croissance accélérée",
      "Réduction des tensions",
    ],
    answer: "Instabilité mondiale",
    explanation: "La coopération est essentielle à la paix.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel enjeu concerne la régulation des flux migratoires ?",
    options: ["Droits humains", "Politique monétaire", "Décentralisation"],
    answer: "Droits humains",
    explanation: "Les migrants doivent être protégés.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel principe impose l’indépendance éditoriale des médias ?",
    options: ["Liberté de la presse", "Contrôle étatique", "Centralisation"],
    answer: "Liberté de la presse",
    explanation: "Elle est essentielle au débat démocratique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel phénomène limite l’exposition à des opinions divergentes ?",
    options: ["Bulle informationnelle", "Pluralisme", "Déontologie"],
    answer: "Bulle informationnelle",
    explanation: "Elle enferme l’utilisateur dans des contenus similaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel danger démocratique pose la désinformation ?",
    options: [
      "Manipulation de l’opinion",
      "Renforcement du pluralisme",
      "Meilleure information",
    ],
    answer: "Manipulation de l’opinion",
    explanation: "Elle fausse le jugement des citoyens.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel droit protège la liberté d’informer ?",
    options: ["Liberté de la presse", "Secret défense", "Immunité pénale"],
    answer: "Liberté de la presse",
    explanation: "Elle est un pilier de la démocratie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel principe impose la vérification des sources ?",
    options: ["Déontologie journalistique", "Censure", "Liberté totale"],
    answer: "Déontologie journalistique",
    explanation: "Elle encadre le métier de journaliste.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu social accompagne la transition numérique ?",
    options: [
      "Fracture numérique",
      "Centralisation politique",
      "Baisse de l’éducation",
    ],
    answer: "Fracture numérique",
    explanation: "Tout le monde n’a pas le même accès au numérique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel objectif vise la lutte contre la pauvreté ?",
    options: [
      "Réduction des inégalités",
      "Croissance illimitée",
      "Centralisation",
    ],
    answer: "Réduction des inégalités",
    explanation: "Elle vise plus de justice sociale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel risque est lié à l’usage massif de l’intelligence artificielle ?",
    options: [
      "Atteinte aux libertés",
      "Fin de l’éducation",
      "Croissance automatique",
    ],
    answer: "Atteinte aux libertés",
    explanation: "L’IA peut menacer les droits fondamentaux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel enjeu concerne l’adaptation des sociétés au changement climatique ?",
    options: ["Résilience", "Centralisation", "Délocalisation"],
    answer: "Résilience",
    explanation: "Les sociétés doivent s’adapter aux chocs climatiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel défi concerne l’accès à l’emploi pour les jeunes ?",
    options: [
      "Insertion professionnelle",
      "Suppression du salariat",
      "Fin de la formation",
    ],
    answer: "Insertion professionnelle",
    explanation: "L’entrée sur le marché du travail est un enjeu majeur.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel principe garantit l’égal accès des citoyens aux emplois publics ?",
    options: ["Égalité d’accès", "Neutralité politique", "Centralisation"],
    answer: "Égalité d’accès",
    explanation: "Il découle du principe d’égalité devant la loi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel enjeu social est lié à la hausse des loyers dans les métropoles ?",
    options: [
      "Accès au logement",
      "Décentralisation",
      "Mobilité internationale",
    ],
    answer: "Accès au logement",
    explanation: "La tension immobilière limite l’installation des ménages.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel droit protège les salariés face au licenciement abusif ?",
    options: ["Droit du travail", "Droit commercial", "Droit fiscal"],
    answer: "Droit du travail",
    explanation: "Il encadre la rupture du contrat de travail.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe impose l’égalité entre les femmes et les hommes ?",
    options: ["Égalité devant la loi", "Liberté contractuelle", "Subsidiarité"],
    answer: "Égalité devant la loi",
    explanation: "Il interdit toute discrimination fondée sur le sexe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel enjeu est lié au vieillissement de la population active ?",
    options: [
      "Financement des retraites",
      "Baisse de la scolarisation",
      "Centralisation économique",
    ],
    answer: "Financement des retraites",
    explanation: "Le nombre d’actifs diminue par rapport aux retraités.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu mondial est lié à l’augmentation des catastrophes naturelles ?",
    options: [
      "Changement climatique",
      "Numérisation",
      "Mondialisation financière",
    ],
    answer: "Changement climatique",
    explanation: "Il intensifie les phénomènes météorologiques extrêmes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel organisme international coordonne la lutte contre les pandémies ?",
    options: ["OMS", "OMC", "FMI"],
    answer: "OMS",
    explanation:
        "L’Organisation mondiale de la santé pilote la réponse sanitaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel risque mondial est lié à la prolifération des armes ?",
    options: [
      "Instabilité internationale",
      "Croissance économique",
      "Réduction des tensions",
    ],
    answer: "Instabilité internationale",
    explanation: "La prolifération accroît les risques de conflits.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu concerne la protection des civils en temps de guerre ?",
    options: [
      "Droit international humanitaire",
      "Droit commercial",
      "Droit fiscal",
    ],
    answer: "Droit international humanitaire",
    explanation: "Il encadre la conduite des conflits armés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel phénomène accentue les inégalités entre pays riches et pauvres ?",
    options: [
      "Inégal développement",
      "Décentralisation",
      "Neutralité économique",
    ],
    answer: "Inégal développement",
    explanation: "Les écarts de richesse persistent à l’échelle mondiale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel principe impose la séparation entre information et publicité ?",
    options: ["Déontologie journalistique", "Pluralisme", "Censure"],
    answer: "Déontologie journalistique",
    explanation: "Elle garantit l’indépendance de l’information.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel risque est lié à la dépendance aux réseaux sociaux pour s’informer ?",
    options: ["Désinformation", "Pluralisme renforcé", "Neutralité accrue"],
    answer: "Désinformation",
    explanation: "Les contenus ne sont pas toujours vérifiés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel droit protège la liberté d’expression des citoyens ?",
    options: ["Liberté d’expression", "Ordre public", "Secret défense"],
    answer: "Liberté d’expression",
    explanation: "Elle est un droit fondamental en démocratie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel danger démocratique pose la concentration des médias ?",
    options: [
      "Réduction du pluralisme",
      "Meilleure information",
      "Neutralité renforcée",
    ],
    answer: "Réduction du pluralisme",
    explanation: "Moins de diversité limite le débat public.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel rôle joue l’éducation aux médias ?",
    options: [
      "Développer l’esprit critique",
      "Censurer l’information",
      "Contrôler les journalistes",
    ],
    answer: "Développer l’esprit critique",
    explanation: "Elle aide à analyser et vérifier l’information.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu social est lié à la transition énergétique ?",
    options: [
      "Acceptabilité sociale",
      "Centralisation politique",
      "Baisse de l’éducation",
    ],
    answer: "Acceptabilité sociale",
    explanation: "Les changements doivent être compris et acceptés.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel objectif vise la lutte contre les discriminations ?",
    options: ["Égalité des chances", "Croissance illimitée", "Centralisation"],
    answer: "Égalité des chances",
    explanation: "Elle vise une société plus juste.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel risque est lié à la surveillance numérique généralisée ?",
    options: [
      "Atteinte aux libertés",
      "Amélioration automatique de la sécurité",
      "Croissance économique",
    ],
    answer: "Atteinte aux libertés",
    explanation: "La vie privée peut être menacée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel enjeu concerne l’adaptation du travail aux nouvelles technologies ?",
    options: [
      "Formation professionnelle",
      "Suppression de l’emploi",
      "Centralisation",
    ],
    answer: "Formation professionnelle",
    explanation: "Les compétences doivent évoluer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel défi concerne la cohésion sociale aujourd’hui ?",
    options: [
      "Réduction des inégalités",
      "Fin des services publics",
      "Suppression de la protection sociale",
    ],
    answer: "Réduction des inégalités",
    explanation: "Elle favorise le vivre-ensemble.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel principe garantit la protection sociale des citoyens en France ?",
    options: [
      "Solidarité nationale",
      "Liberté contractuelle",
      "Neutralité administrative",
    ],
    answer: "Solidarité nationale",
    explanation: "Elle fonde la Sécurité sociale et les aides publiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel enjeu social est lié à la hausse des déserts médicaux ?",
    options: [
      "Accès aux soins",
      "Décentralisation",
      "Privatisation de la santé",
    ],
    answer: "Accès aux soins",
    explanation: "Certaines zones manquent de professionnels de santé.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel droit fondamental protège la liberté d’aller et venir ?",
    options: ["Liberté individuelle", "Ordre public", "Neutralité"],
    answer: "Liberté individuelle",
    explanation: "Elle est garantie par la Constitution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel phénomène social touche de nombreux jeunes actifs ?",
    options: [
      "Précarité de l’emploi",
      "Baisse de la scolarisation",
      "Exode rural massif",
    ],
    answer: "Précarité de l’emploi",
    explanation: "Les contrats courts sont fréquents chez les jeunes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe garantit l’accès égal à l’éducation ?",
    options: ["Égalité des chances", "Subsidiarité", "Centralisation"],
    answer: "Égalité des chances",
    explanation: "Il vise à réduire les inégalités scolaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu mondial est lié à la pénurie de ressources naturelles ?",
    options: ["Tensions géopolitiques", "Tourisme", "Numérisation"],
    answer: "Tensions géopolitiques",
    explanation:
        "La concurrence pour les ressources peut provoquer des conflits.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel organisme international œuvre pour les droits de l’enfant ?",
    options: ["UNICEF", "FMI", "OMC"],
    answer: "UNICEF",
    explanation: "Il dépend des Nations unies.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel risque mondial est lié aux cyberattaques ?",
    options: [
      "Menace sur la sécurité",
      "Baisse de la connectivité",
      "Fin d’Internet",
    ],
    answer: "Menace sur la sécurité",
    explanation: "Elles peuvent viser des États ou des infrastructures.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel enjeu concerne la régulation des multinationales ?",
    options: [
      "Responsabilité sociale",
      "Tourisme international",
      "Politique monétaire",
    ],
    answer: "Responsabilité sociale",
    explanation: "Les entreprises sont incitées à respecter des normes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel phénomène accentue les déplacements de population dans le monde ?",
    options: [
      "Conflits armés",
      "Croissance économique",
      "Innovation technologique",
    ],
    answer: "Conflits armés",
    explanation: "Ils provoquent des migrations forcées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel principe impose la responsabilité des journalistes face à l’information diffusée ?",
    options: ["Déontologie journalistique", "Liberté totale", "Censure"],
    answer: "Déontologie journalistique",
    explanation: "Elle encadre les pratiques professionnelles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel risque est lié à la course à l’audience ?",
    options: ["Sensationnalisme", "Pluralisme accru", "Neutralité renforcée"],
    answer: "Sensationnalisme",
    explanation: "Il peut nuire à la qualité de l’information.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel média repose principalement sur le format audio ?",
    options: ["Radio", "Télévision", "Presse écrite"],
    answer: "Radio",
    explanation: "Elle diffuse l’information par le son.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel danger représente la manipulation d’images ou de vidéos ?",
    options: [
      "Perte de confiance",
      "Meilleure information",
      "Pluralisme accru",
    ],
    answer: "Perte de confiance",
    explanation: "Les montages trompeurs nuisent à la crédibilité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel droit protège l’accès des citoyens à l’information ?",
    options: ["Liberté d’information", "Secret défense", "Immunité pénale"],
    answer: "Liberté d’information",
    explanation: "Elle est essentielle au fonctionnement démocratique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu social accompagne la transition écologique ?",
    options: [
      "Justice sociale",
      "Centralisation politique",
      "Baisse de l’éducation",
    ],
    answer: "Justice sociale",
    explanation: "Les efforts doivent être équitablement répartis.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel objectif vise la réduction des inégalités territoriales ?",
    options: ["Cohésion territoriale", "Centralisation", "Délocalisation"],
    answer: "Cohésion territoriale",
    explanation: "Elle vise un développement équilibré des territoires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel risque est lié à la dépendance technologique ?",
    options: [
      "Perte d’autonomie",
      "Hausse de l’emploi",
      "Amélioration automatique des services",
    ],
    answer: "Perte d’autonomie",
    explanation: "Une dépendance excessive fragilise les sociétés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel enjeu concerne l’évolution des compétences professionnelles ?",
    options: [
      "Formation continue",
      "Suppression de l’emploi",
      "Centralisation",
    ],
    answer: "Formation continue",
    explanation: "Les métiers évoluent avec les technologies.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel principe garantit la neutralité de l’État vis-à-vis des religions ?",
    options: ["Laïcité", "Liberté d’opinion", "Pluralisme"],
    answer: "Laïcité",
    explanation: "La laïcité impose la neutralité religieuse de l’État.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel enjeu social est lié à l’augmentation des familles monoparentales ?",
    options: [
      "Précarité sociale",
      "Décentralisation",
      "Mobilité internationale",
    ],
    answer: "Précarité sociale",
    explanation: "Ces familles sont plus exposées aux difficultés économiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel droit protège les citoyens contre les discriminations ?",
    options: ["Principe d’égalité", "Ordre public", "Souveraineté nationale"],
    answer: "Principe d’égalité",
    explanation: "Il interdit les discriminations injustifiées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel phénomène social est lié à la numérisation des services publics ?",
    options: [
      "Fracture numérique",
      "Centralisation administrative",
      "Privatisation",
    ],
    answer: "Fracture numérique",
    explanation:
        "Certaines personnes ont des difficultés d’accès au numérique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe garantit la liberté de conscience ?",
    options: ["Liberté individuelle", "Neutralité politique", "Ordre public"],
    answer: "Liberté individuelle",
    explanation: "Elle inclut la liberté de croire ou de ne pas croire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu mondial est lié à l’augmentation des émissions de CO₂ ?",
    options: [
      "Réchauffement climatique",
      "Mondialisation culturelle",
      "Numérisation",
    ],
    answer: "Réchauffement climatique",
    explanation:
        "Les émissions de gaz à effet de serre augmentent la température globale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel organisme international œuvre pour la protection des réfugiés ?",
    options: ["HCR", "OMS", "OMC"],
    answer: "HCR",
    explanation: "Le Haut-Commissariat pour les réfugiés dépend de l’ONU.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel risque mondial est lié aux tensions entre grandes puissances ?",
    options: [
      "Instabilité géopolitique",
      "Croissance économique",
      "Coopération renforcée",
    ],
    answer: "Instabilité géopolitique",
    explanation: "Les rivalités peuvent mener à des conflits.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu concerne la régulation des réseaux sociaux à l’échelle mondiale ?",
    options: ["Liberté d’expression", "Tourisme", "Politique agricole"],
    answer: "Liberté d’expression",
    explanation: "La régulation doit respecter les droits fondamentaux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel phénomène mondial accentue la pression sur les ressources alimentaires ?",
    options: [
      "Croissance démographique",
      "Décentralisation",
      "Innovation numérique",
    ],
    answer: "Croissance démographique",
    explanation: "Une population plus nombreuse augmente la demande.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel principe impose l’honnêteté dans le traitement de l’information ?",
    options: ["Déontologie journalistique", "Pluralisme", "Censure"],
    answer: "Déontologie journalistique",
    explanation: "Elle impose des règles éthiques aux journalistes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel danger est lié à la diffusion massive de fausses informations ?",
    options: ["Désinformation", "Pluralisme renforcé", "Liberté accrue"],
    answer: "Désinformation",
    explanation: "Elle trompe l’opinion publique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel média repose principalement sur le texte écrit ?",
    options: ["Presse écrite", "Radio", "Télévision"],
    answer: "Presse écrite",
    explanation: "Elle diffuse l’information par des articles écrits.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel risque démocratique pose la manipulation de l’information ?",
    options: [
      "Perte de confiance citoyenne",
      "Meilleure information",
      "Neutralité accrue",
    ],
    answer: "Perte de confiance citoyenne",
    explanation: "La confiance dans les institutions peut s’effondrer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel droit protège la liberté de communiquer des informations ?",
    options: ["Liberté d’expression", "Secret défense", "Immunité pénale"],
    answer: "Liberté d’expression",
    explanation: "Elle inclut la liberté de communiquer des idées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu social est lié à l’augmentation du coût de la vie ?",
    options: [
      "Pouvoir d’achat",
      "Centralisation politique",
      "Baisse de l’éducation",
    ],
    answer: "Pouvoir d’achat",
    explanation: "Il influence directement le niveau de vie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel objectif vise la lutte contre l’exclusion sociale ?",
    options: ["Inclusion sociale", "Croissance illimitée", "Centralisation"],
    answer: "Inclusion sociale",
    explanation: "Elle vise l’intégration de tous dans la société.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel risque est lié à l’automatisation excessive du travail ?",
    options: [
      "Suppression d’emplois",
      "Hausse de l’emploi",
      "Amélioration automatique du bien-être",
    ],
    answer: "Suppression d’emplois",
    explanation: "Certaines tâches humaines peuvent disparaître.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel enjeu concerne la régulation de l’intelligence artificielle ?",
    options: ["Encadrement éthique", "Fin de la technologie", "Centralisation"],
    answer: "Encadrement éthique",
    explanation: "Il vise à protéger les droits fondamentaux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel défi concerne la participation citoyenne aujourd’hui ?",
    options: [
      "Engagement démocratique",
      "Fin du vote",
      "Suppression des libertés",
    ],
    answer: "Engagement démocratique",
    explanation:
        "La participation est essentielle au fonctionnement démocratique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel principe garantit l’égalité de traitement des usagers par l’administration ?",
    options: [
      "Principe d’égalité",
      "Principe de subsidiarité",
      "Principe de précaution",
    ],
    answer: "Principe d’égalité",
    explanation:
        "Il impose un traitement identique des usagers dans des situations comparables.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel enjeu social est lié à l’augmentation du télétravail ?",
    options: [
      "Équilibre vie professionnelle/vie privée",
      "Décentralisation politique",
      "Baisse de la productivité",
    ],
    answer: "Équilibre vie professionnelle/vie privée",
    explanation: "Le télétravail modifie l’organisation du temps de travail.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel droit protège les citoyens contre la surveillance abusive ?",
    options: ["Droit à la vie privée", "Droit fiscal", "Droit électoral"],
    answer: "Droit à la vie privée",
    explanation: "Il protège les données et les communications personnelles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel phénomène social est lié à l’augmentation de l’espérance de vie ?",
    options: [
      "Vieillissement démographique",
      "Exode rural",
      "Baisse de la natalité mondiale",
    ],
    answer: "Vieillissement démographique",
    explanation: "La part des personnes âgées augmente dans la population.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe fonde la gratuité de certains services publics ?",
    options: [
      "Intérêt général",
      "Liberté contractuelle",
      "Neutralité religieuse",
    ],
    answer: "Intérêt général",
    explanation:
        "Les services publics visent à répondre aux besoins collectifs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu mondial est lié à la montée des régimes autoritaires ?",
    options: [
      "Affaiblissement de la démocratie",
      "Croissance économique",
      "Coopération renforcée",
    ],
    answer: "Affaiblissement de la démocratie",
    explanation: "Les libertés publiques peuvent être restreintes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel organisme international surveille le respect des droits humains ?",
    options: ["Conseil des droits de l’homme", "FMI", "OCDE"],
    answer: "Conseil des droits de l’homme",
    explanation: "Il dépend des Nations unies.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel risque mondial est lié à la dépendance énergétique ?",
    options: [
      "Vulnérabilité géopolitique",
      "Croissance illimitée",
      "Neutralité stratégique",
    ],
    answer: "Vulnérabilité géopolitique",
    explanation: "La dépendance expose aux pressions extérieures.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel enjeu concerne la protection des océans ?",
    options: [
      "Préservation de la biodiversité",
      "Développement du tourisme",
      "Centralisation des ressources",
    ],
    answer: "Préservation de la biodiversité",
    explanation: "Les océans abritent de nombreuses espèces.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel phénomène mondial est lié à la multiplication des crises sanitaires ?",
    options: [
      "Mondialisation des échanges",
      "Décentralisation politique",
      "Baisse des migrations",
    ],
    answer: "Mondialisation des échanges",
    explanation: "Les échanges favorisent la diffusion rapide des maladies.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel principe impose la pluralité des opinions dans les médias ?",
    options: ["Pluralisme", "Censure", "Neutralité absolue"],
    answer: "Pluralisme",
    explanation: "Il garantit la diversité des points de vue.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel risque est lié à l’utilisation de deepfakes ?",
    options: [
      "Manipulation de l’information",
      "Renforcement de la confiance",
      "Meilleure transparence",
    ],
    answer: "Manipulation de l’information",
    explanation: "Les images truquées peuvent tromper le public.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel média est historiquement lié à la diffusion rapide de l’information locale ?",
    options: ["Radio", "Presse écrite", "Cinéma"],
    answer: "Radio",
    explanation: "La radio diffuse l’information en temps réel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel danger pose la confusion entre information et opinion ?",
    options: [
      "Perte de crédibilité",
      "Meilleure compréhension",
      "Pluralisme accru",
    ],
    answer: "Perte de crédibilité",
    explanation: "Le public peut être induit en erreur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel droit protège la liberté de créer un média ?",
    options: ["Liberté de la presse", "Secret défense", "Immunité pénale"],
    answer: "Liberté de la presse",
    explanation: "Elle garantit l’indépendance des médias.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel enjeu social est lié à la transition numérique des administrations ?",
    options: [
      "Accessibilité des services",
      "Suppression des droits",
      "Centralisation totale",
    ],
    answer: "Accessibilité des services",
    explanation: "Tous les citoyens doivent pouvoir accéder aux démarches.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel objectif vise la lutte contre le changement climatique ?",
    options: [
      "Réduction des émissions",
      "Croissance illimitée",
      "Centralisation politique",
    ],
    answer: "Réduction des émissions",
    explanation: "Limiter les gaz à effet de serre est essentiel.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel risque est lié à l’exclusion numérique ?",
    options: [
      "Marginalisation sociale",
      "Hausse de l’emploi",
      "Meilleure information",
    ],
    answer: "Marginalisation sociale",
    explanation: "Certaines populations restent à l’écart des services.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu concerne la régulation des plateformes numériques ?",
    options: [
      "Protection des droits fondamentaux",
      "Fin d’Internet",
      "Centralisation économique",
    ],
    answer: "Protection des droits fondamentaux",
    explanation: "Les plateformes influencent la liberté d’expression.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe garantit la continuité du service public ?",
    options: ["Continuité", "Neutralité", "Liberté contractuelle"],
    answer: "Continuité",
    explanation:
        "Le service public doit fonctionner sans interruption injustifiée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel enjeu social est lié à la hausse du coût des transports ?",
    options: [
      "Mobilité des citoyens",
      "Décentralisation",
      "Centralisation urbaine",
    ],
    answer: "Mobilité des citoyens",
    explanation: "Le coût impacte l’accès à l’emploi et aux services.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel droit protège les salariés contre les discriminations professionnelles ?",
    options: [
      "Principe de non-discrimination",
      "Liberté d’entreprendre",
      "Ordre public",
    ],
    answer: "Principe de non-discrimination",
    explanation: "Il interdit toute distinction injustifiée au travail.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel phénomène social est lié à l’augmentation des familles recomposées ?",
    options: [
      "Évolution des structures familiales",
      "Baisse de la natalité",
      "Exode rural",
    ],
    answer: "Évolution des structures familiales",
    explanation: "Les modèles familiaux se diversifient.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe garantit l’égalité devant les charges publiques ?",
    options: ["Égalité fiscale", "Neutralité religieuse", "Subsidiarité"],
    answer: "Égalité fiscale",
    explanation: "Les impôts doivent être répartis équitablement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel enjeu mondial est lié à la raréfaction de l’eau potable ?",
    options: ["Conflits d’usage", "Tourisme", "Numérisation"],
    answer: "Conflits d’usage",
    explanation: "La concurrence pour l’eau peut provoquer des tensions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel organisme international est chargé du maintien de la paix ?",
    options: ["Conseil de sécurité de l’ONU", "OMC", "OCDE"],
    answer: "Conseil de sécurité de l’ONU",
    explanation: "Il peut autoriser des opérations de maintien de la paix.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel risque mondial est lié à la prolifération nucléaire ?",
    options: [
      "Menace pour la sécurité internationale",
      "Croissance économique",
      "Stabilité durable",
    ],
    answer: "Menace pour la sécurité internationale",
    explanation:
        "Les armes nucléaires accroissent les risques de conflit majeur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel enjeu concerne la protection des minorités ethniques ?",
    options: ["Droits humains", "Politique commerciale", "Tourisme"],
    answer: "Droits humains",
    explanation:
        "Les minorités doivent être protégées contre les discriminations.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel phénomène mondial est lié à l’urbanisation rapide ?",
    options: [
      "Pression sur les infrastructures",
      "Baisse démographique",
      "Décentralisation politique",
    ],
    answer: "Pression sur les infrastructures",
    explanation: "Les villes doivent s’adapter à une population croissante.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel principe impose la transparence sur les sources de financement des médias ?",
    options: ["Indépendance des médias", "Censure", "Neutralité politique"],
    answer: "Indépendance des médias",
    explanation: "La transparence renforce la confiance du public.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel risque est lié à la viralité des contenus en ligne ?",
    options: [
      "Propagation rapide de fausses informations",
      "Meilleure vérification",
      "Pluralisme renforcé",
    ],
    answer: "Propagation rapide de fausses informations",
    explanation: "Les contenus viraux ne sont pas toujours fiables.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel média est historiquement associé à l’opinion et à l’analyse écrite ?",
    options: ["Presse écrite", "Radio", "Télévision"],
    answer: "Presse écrite",
    explanation: "Elle permet un traitement approfondi de l’information.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel danger pose la concentration des plateformes numériques ?",
    options: [
      "Réduction de la diversité de l’information",
      "Meilleure accessibilité",
      "Neutralité accrue",
    ],
    answer: "Réduction de la diversité de l’information",
    explanation: "Moins d’acteurs limite la pluralité des contenus.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel droit protège les citoyens contre la diffamation ?",
    options: ["Droit à la réputation", "Liberté totale", "Secret défense"],
    answer: "Droit à la réputation",
    explanation: "Il protège l’honneur et la considération des personnes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel enjeu social est lié à la transition vers les énergies renouvelables ?",
    options: [
      "Acceptabilité sociale",
      "Centralisation politique",
      "Baisse de la production",
    ],
    answer: "Acceptabilité sociale",
    explanation: "Les populations doivent adhérer aux changements.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel objectif vise la promotion de la diversité culturelle ?",
    options: [
      "Respect du pluralisme",
      "Uniformisation sociale",
      "Centralisation",
    ],
    answer: "Respect du pluralisme",
    explanation: "Elle favorise la coexistence des cultures.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel risque est lié à l’absence de régulation de l’IA ?",
    options: [
      "Atteinte aux droits fondamentaux",
      "Innovation accrue",
      "Croissance automatique",
    ],
    answer: "Atteinte aux droits fondamentaux",
    explanation: "Des usages abusifs peuvent émerger.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu concerne l’adaptation des systèmes éducatifs ?",
    options: [
      "Évolution des compétences",
      "Suppression de l’école",
      "Centralisation",
    ],
    answer: "Évolution des compétences",
    explanation: "Les formations doivent s’adapter au monde contemporain.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel défi concerne la lutte contre la désinformation ?",
    options: [
      "Renforcement de l’esprit critique",
      "Censure généralisée",
      "Suppression des médias",
    ],
    answer: "Renforcement de l’esprit critique",
    explanation: "Les citoyens doivent apprendre à vérifier l’information.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel principe garantit l’adaptabilité du service public aux besoins des usagers ?",
    options: ["Mutabilité", "Neutralité", "Continuité"],
    answer: "Mutabilité",
    explanation:
        "Le service public doit évoluer pour répondre aux besoins de la société.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel enjeu social est lié à l’augmentation des maladies chroniques ?",
    options: [
      "Pression sur le système de santé",
      "Décentralisation",
      "Baisse de l’espérance de vie",
    ],
    answer: "Pression sur le système de santé",
    explanation:
        "Les soins de longue durée mobilisent davantage de ressources.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel droit garantit la protection des données personnelles des citoyens ?",
    options: ["RGPD", "Droit électoral", "Droit pénal"],
    answer: "RGPD",
    explanation:
        "Le Règlement général sur la protection des données encadre l’usage des données.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel phénomène social est lié à l’augmentation des contrats courts ?",
    options: [
      "Précarisation de l’emploi",
      "Centralisation économique",
      "Baisse de la mobilité",
    ],
    answer: "Précarisation de l’emploi",
    explanation: "Les emplois stables deviennent moins fréquents.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel principe garantit la participation des citoyens à la vie démocratique ?",
    options: [
      "Suffrage universel",
      "Neutralité administrative",
      "Subsidiarité",
    ],
    answer: "Suffrage universel",
    explanation: "Il permet aux citoyens de choisir leurs représentants.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu mondial est lié à la multiplication des conflits régionaux ?",
    options: [
      "Instabilité internationale",
      "Croissance durable",
      "Coopération renforcée",
    ],
    answer: "Instabilité internationale",
    explanation: "Les conflits locaux ont des répercussions globales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel organisme international coordonne l’aide humanitaire d’urgence ?",
    options: ["OCHA", "OMC", "OCDE"],
    answer: "OCHA",
    explanation:
        "Le Bureau de la coordination des affaires humanitaires dépend de l’ONU.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel risque mondial est lié à la dépendance aux chaînes d’approvisionnement mondiales ?",
    options: [
      "Vulnérabilité économique",
      "Stabilité accrue",
      "Autonomie totale",
    ],
    answer: "Vulnérabilité économique",
    explanation: "Les ruptures peuvent provoquer des pénuries.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel enjeu concerne la régulation des géants du numérique ?",
    options: [
      "Concurrence loyale",
      "Tourisme international",
      "Politique agricole",
    ],
    answer: "Concurrence loyale",
    explanation: "La régulation vise à éviter les abus de position dominante.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel phénomène mondial est lié à l’augmentation des migrations climatiques ?",
    options: [
      "Dégradation environnementale",
      "Croissance démographique",
      "Innovation technologique",
    ],
    answer: "Dégradation environnementale",
    explanation: "Le climat pousse certaines populations à se déplacer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel principe impose la séparation entre faits et commentaires ?",
    options: ["Objectivité journalistique", "Pluralisme", "Censure"],
    answer: "Objectivité journalistique",
    explanation: "Elle vise à distinguer information et opinion.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel risque est lié à l’automatisation de la production de contenus ?",
    options: [
      "Uniformisation de l’information",
      "Pluralisme accru",
      "Neutralité renforcée",
    ],
    answer: "Uniformisation de l’information",
    explanation: "Les contenus peuvent manquer de diversité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel média est historiquement associé à l’information de proximité quotidienne ?",
    options: ["Presse locale", "Cinéma", "Télévision nationale"],
    answer: "Presse locale",
    explanation: "Elle couvre les événements locaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel danger pose la pression économique sur les rédactions ?",
    options: [
      "Atteinte à l’indépendance éditoriale",
      "Meilleure information",
      "Neutralité accrue",
    ],
    answer: "Atteinte à l’indépendance éditoriale",
    explanation: "Les choix éditoriaux peuvent être influencés.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel droit protège les journalistes contre les pressions politiques ?",
    options: ["Liberté de la presse", "Secret défense", "Immunité pénale"],
    answer: "Liberté de la presse",
    explanation: "Elle garantit l’indépendance de l’information.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu social est lié à la sobriété énergétique ?",
    options: [
      "Changement des modes de vie",
      "Centralisation politique",
      "Baisse de l’innovation",
    ],
    answer: "Changement des modes de vie",
    explanation: "La sobriété implique de nouveaux comportements.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel objectif vise la régulation des plateformes numériques ?",
    options: [
      "Protection des utilisateurs",
      "Suppression d’Internet",
      "Centralisation économique",
    ],
    answer: "Protection des utilisateurs",
    explanation: "Elle vise à limiter les abus et les contenus illicites.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel risque est lié à la polarisation des opinions ?",
    options: [
      "Fragmentation sociale",
      "Renforcement du consensus",
      "Stabilité accrue",
    ],
    answer: "Fragmentation sociale",
    explanation: "Les divisions peuvent s’accentuer.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel enjeu concerne l’encadrement éthique des nouvelles technologies ?",
    options: ["Respect des libertés", "Fin de l’innovation", "Centralisation"],
    answer: "Respect des libertés",
    explanation: "L’innovation doit respecter les droits fondamentaux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel défi concerne la participation des jeunes à la vie publique ?",
    options: [
      "Renouvellement démocratique",
      "Fin du vote",
      "Suppression des institutions",
    ],
    answer: "Renouvellement démocratique",
    explanation:
        "L’engagement des jeunes est crucial pour l’avenir démocratique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel principe garantit l’égal accès aux services publics sur le territoire ?",
    options: [
      "Égalité territoriale",
      "Liberté contractuelle",
      "Neutralité religieuse",
    ],
    answer: "Égalité territoriale",
    explanation:
        "Les services publics doivent être accessibles à tous les citoyens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel enjeu social est lié à la hausse du nombre de personnes âgées dépendantes ?",
    options: [
      "Prise en charge de la dépendance",
      "Décentralisation",
      "Baisse de la natalité",
    ],
    answer: "Prise en charge de la dépendance",
    explanation: "Elle nécessite des politiques publiques adaptées.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel droit fondamental protège la liberté de manifester ?",
    options: ["Liberté de réunion", "Ordre public", "Neutralité"],
    answer: "Liberté de réunion",
    explanation: "Elle permet l’expression collective des opinions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel phénomène social est lié à l’augmentation du travail indépendant ?",
    options: [
      "Transformation du marché du travail",
      "Baisse de l’emploi",
      "Centralisation économique",
    ],
    answer: "Transformation du marché du travail",
    explanation: "Les formes d’emploi deviennent plus diversifiées.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel principe garantit la protection des libertés individuelles ?",
    options: ["État de droit", "Souveraineté", "Ordre public"],
    answer: "État de droit",
    explanation: "Les pouvoirs publics sont soumis à la loi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu mondial est lié à l’augmentation des dépenses militaires ?",
    options: [
      "Course aux armements",
      "Croissance sociale",
      "Coopération renforcée",
    ],
    answer: "Course aux armements",
    explanation: "Elle accroît les tensions internationales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel organisme international encadre le commerce mondial ?",
    options: ["OMC", "OMS", "UNESCO"],
    answer: "OMC",
    explanation: "L’Organisation mondiale du commerce régule les échanges.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel risque mondial est lié à la désinformation numérique ?",
    options: [
      "Manipulation politique",
      "Renforcement démocratique",
      "Neutralité accrue",
    ],
    answer: "Manipulation politique",
    explanation: "Elle peut influencer les opinions et les élections.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu concerne la protection des journalistes dans le monde ?",
    options: ["Liberté de la presse", "Politique commerciale", "Tourisme"],
    answer: "Liberté de la presse",
    explanation: "Les journalistes sont parfois menacés ou censurés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel phénomène mondial est lié à l’explosion des villes géantes ?",
    options: ["Mégalopolisation", "Décentralisation", "Ruralisation"],
    answer: "Mégalopolisation",
    explanation: "Les grandes villes concentrent population et activités.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel principe garantit l’accès équitable aux médias audiovisuels ?",
    options: ["Pluralisme", "Censure", "Neutralité économique"],
    answer: "Pluralisme",
    explanation: "Il assure la diversité des opinions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel risque est lié à la dépendance aux plateformes numériques pour s’informer ?",
    options: [
      "Biais algorithmique",
      "Information neutre",
      "Pluralisme renforcé",
    ],
    answer: "Biais algorithmique",
    explanation: "Les algorithmes sélectionnent les contenus.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel média est principalement fondé sur l’instantanéité de l’information ?",
    options: ["Internet", "Presse écrite", "Livre"],
    answer: "Internet",
    explanation: "Il permet une diffusion immédiate de l’information.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel danger pose l’absence de vérification des sources ?",
    options: [
      "Propagation de fausses informations",
      "Meilleure transparence",
      "Pluralisme accru",
    ],
    answer: "Propagation de fausses informations",
    explanation: "L’information non vérifiée peut tromper le public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel droit protège la liberté d’opinion dans les médias ?",
    options: ["Liberté d’expression", "Secret défense", "Immunité pénale"],
    answer: "Liberté d’expression",
    explanation: "Elle permet l’expression d’opinions diverses.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu social est lié à la hausse du coût de l’énergie ?",
    options: [
      "Précarité énergétique",
      "Centralisation",
      "Baisse de la consommation",
    ],
    answer: "Précarité énergétique",
    explanation: "Certaines populations peinent à se chauffer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel objectif vise la neutralité carbone ?",
    options: [
      "Équilibre des émissions",
      "Croissance illimitée",
      "Centralisation politique",
    ],
    answer: "Équilibre des émissions",
    explanation: "Les émissions doivent être compensées.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel risque est lié à l’accélération du rythme de travail ?",
    options: [
      "Épuisement professionnel",
      "Hausse du bien-être",
      "Meilleure productivité durable",
    ],
    answer: "Épuisement professionnel",
    explanation: "Le stress chronique peut affecter la santé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu concerne la régulation des données personnelles ?",
    options: [
      "Protection de la vie privée",
      "Fin du numérique",
      "Centralisation",
    ],
    answer: "Protection de la vie privée",
    explanation: "Les données doivent être protégées contre les abus.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel défi concerne la confiance dans l’information aujourd’hui ?",
    options: [
      "Crédibilité des sources",
      "Suppression des médias",
      "Censure généralisée",
    ],
    answer: "Crédibilité des sources",
    explanation: "La confiance dépend de la fiabilité de l’information.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel défi concerne la confiance des citoyens envers les institutions ?",
    options: [
      "Crédibilité démocratique",
      "Fin de la participation",
      "Suppression des libertés",
    ],
    answer: "Crédibilité démocratique",
    explanation: "La confiance est essentielle au fonctionnement démocratique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel défi concerne le vivre-ensemble aujourd’hui ?",
    options: [
      "Cohésion sociale",
      "Fin des libertés",
      "Suppression des droits sociaux",
    ],
    answer: "Cohésion sociale",
    explanation: "Elle favorise la solidarité et la stabilité sociale.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel principe garantit la neutralité du service public vis-à-vis des opinions politiques ?",
    options: ["Neutralité", "Liberté d’expression", "Pluralisme"],
    answer: "Neutralité",
    explanation:
        "Les agents publics doivent exercer leurs fonctions sans parti pris politique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel enjeu social est lié à l’augmentation des prix alimentaires ?",
    options: ["Sécurité alimentaire", "Décentralisation", "Mobilité sociale"],
    answer: "Sécurité alimentaire",
    explanation:
        "La hausse des prix affecte l’accès à une alimentation suffisante.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel droit protège les citoyens contre les décisions arbitraires de l’administration ?",
    options: [
      "Recours administratif",
      "Ordre public",
      "Souveraineté nationale",
    ],
    answer: "Recours administratif",
    explanation: "Il permet de contester une décision devant une juridiction.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel phénomène social est lié à l’augmentation des mobilités professionnelles ?",
    options: ["Flexibilité du travail", "Baisse de l’emploi", "Centralisation"],
    answer: "Flexibilité du travail",
    explanation: "Les carrières sont moins linéaires qu’auparavant.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel principe garantit la participation des citoyens aux décisions locales ?",
    options: ["Démocratie locale", "Centralisation", "Neutralité"],
    answer: "Démocratie locale",
    explanation: "Elle s’exerce notamment par les élections locales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu mondial est lié à la concurrence pour les matières premières ?",
    options: [
      "Tensions géopolitiques",
      "Coopération culturelle",
      "Stabilité économique",
    ],
    answer: "Tensions géopolitiques",
    explanation: "Les ressources stratégiques sont sources de rivalités.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel organisme international est chargé de l’éducation et de la culture ?",
    options: ["UNESCO", "OMS", "FMI"],
    answer: "UNESCO",
    explanation: "Elle œuvre pour l’éducation, la science et la culture.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel risque mondial est lié à l’absence de règles communes sur l’IA ?",
    options: [
      "Usage incontrôlé",
      "Fin de l’innovation",
      "Neutralité technologique",
    ],
    answer: "Usage incontrôlé",
    explanation: "Sans règles, les usages peuvent porter atteinte aux droits.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu concerne la protection des civils lors des conflits armés ?",
    options: [
      "Droit international humanitaire",
      "Politique commerciale",
      "Décentralisation",
    ],
    answer: "Droit international humanitaire",
    explanation: "Il encadre les comportements en temps de guerre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel phénomène mondial est lié à la transition démographique ?",
    options: [
      "Vieillissement de la population",
      "Baisse de l’urbanisation",
      "Ruralisation",
    ],
    answer: "Vieillissement de la population",
    explanation: "La population âgée augmente dans de nombreux pays.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel principe impose l’indépendance des rédactions face aux pouvoirs politiques ?",
    options: ["Liberté de la presse", "Censure", "Neutralité administrative"],
    answer: "Liberté de la presse",
    explanation: "Elle garantit une information libre et indépendante.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel risque est lié à la multiplication des chaînes d’information en continu ?",
    options: [
      "Traitement superficiel de l’information",
      "Meilleure analyse",
      "Neutralité accrue",
    ],
    answer: "Traitement superficiel de l’information",
    explanation: "La rapidité peut nuire à la profondeur de l’analyse.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel média est historiquement associé à l’investigation approfondie ?",
    options: ["Presse écrite", "Radio", "Télévision de divertissement"],
    answer: "Presse écrite",
    explanation: "Elle permet des enquêtes longues et détaillées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel danger pose la confusion entre rumeur et information vérifiée ?",
    options: [
      "Perte de crédibilité médiatique",
      "Renforcement de la confiance",
      "Pluralisme accru",
    ],
    answer: "Perte de crédibilité médiatique",
    explanation: "La confiance du public peut être altérée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel droit protège les citoyens contre la diffusion de fausses accusations ?",
    options: ["Droit à l’honneur", "Liberté totale", "Secret défense"],
    answer: "Droit à l’honneur",
    explanation: "Il protège la réputation des personnes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu social est lié à la sobriété numérique ?",
    options: [
      "Réduction de l’impact environnemental",
      "Centralisation politique",
      "Baisse de l’innovation",
    ],
    answer: "Réduction de l’impact environnemental",
    explanation: "Le numérique consomme des ressources énergétiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel objectif vise la protection des lanceurs d’alerte ?",
    options: ["Transparence démocratique", "Censure", "Centralisation"],
    answer: "Transparence démocratique",
    explanation: "Ils contribuent à révéler des pratiques illégales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel risque est lié à la surinformation ?",
    options: [
      "Désorientation des citoyens",
      "Meilleure compréhension",
      "Neutralité accrue",
    ],
    answer: "Désorientation des citoyens",
    explanation: "Trop d’informations peut nuire à la compréhension.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu concerne la protection des générations futures ?",
    options: [
      "Développement durable",
      "Croissance immédiate",
      "Centralisation",
    ],
    answer: "Développement durable",
    explanation: "Il vise à préserver les ressources à long terme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel défi concerne l’adaptation des démocraties à l’ère numérique ?",
    options: [
      "Renforcement de la participation citoyenne",
      "Fin des institutions",
      "Suppression des libertés",
    ],
    answer: "Renforcement de la participation citoyenne",
    explanation:
        "Le numérique peut favoriser de nouvelles formes d’engagement.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe garantit l’accès égal des citoyens à la justice ?",
    options: [
      "Égalité devant la loi",
      "Neutralité administrative",
      "Liberté contractuelle",
    ],
    answer: "Égalité devant la loi",
    explanation: "Tous les citoyens doivent être jugés selon les mêmes règles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel enjeu social est lié à la hausse des troubles psychologiques ?",
    options: ["Santé mentale", "Décentralisation", "Mobilité internationale"],
    answer: "Santé mentale",
    explanation: "La santé mentale est devenue un enjeu majeur de société.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel droit protège les citoyens contre les discriminations liées à l’origine ?",
    options: ["Principe de non-discrimination", "Ordre public", "Souveraineté"],
    answer: "Principe de non-discrimination",
    explanation: "Il interdit toute distinction fondée sur l’origine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel phénomène social est lié à l’essor des plateformes de livraison ?",
    options: [
      "Économie des plateformes",
      "Centralisation économique",
      "Baisse de l’emploi",
    ],
    answer: "Économie des plateformes",
    explanation: "De nouveaux modèles économiques émergent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe garantit la liberté d’association ?",
    options: ["Liberté individuelle", "Neutralité religieuse", "Ordre public"],
    answer: "Liberté individuelle",
    explanation: "Elle permet de créer des associations librement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu mondial est lié à la crise de confiance envers les institutions internationales ?",
    options: [
      "Remise en cause du multilatéralisme",
      "Croissance économique",
      "Coopération renforcée",
    ],
    answer: "Remise en cause du multilatéralisme",
    explanation: "Certains États contestent les institutions communes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel organisme international est chargé de la protection du patrimoine mondial ?",
    options: ["UNESCO", "OMS", "OMC"],
    answer: "UNESCO",
    explanation: "Elle protège les sites culturels et naturels.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel risque mondial est lié à la désinformation électorale ?",
    options: [
      "Atteinte aux processus démocratiques",
      "Stabilité politique",
      "Neutralité accrue",
    ],
    answer: "Atteinte aux processus démocratiques",
    explanation: "Les élections peuvent être influencées.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu concerne la gestion des pandémies à l’échelle mondiale ?",
    options: [
      "Coopération internationale",
      "Décentralisation",
      "Isolement des États",
    ],
    answer: "Coopération internationale",
    explanation: "La coordination est essentielle face aux crises sanitaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel phénomène mondial est lié à l’augmentation des inégalités sociales ?",
    options: ["Fractures sociales", "Ruralisation", "Stabilité économique"],
    answer: "Fractures sociales",
    explanation: "Les écarts de richesse s’accentuent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel principe impose l’identification claire des contenus sponsorisés ?",
    options: ["Transparence", "Censure", "Pluralisme"],
    answer: "Transparence",
    explanation: "Le public doit distinguer information et publicité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel risque est lié à l’anonymat en ligne ?",
    options: ["Discours haineux", "Pluralisme accru", "Neutralité renforcée"],
    answer: "Discours haineux",
    explanation: "L’anonymat peut favoriser des propos violents.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel média est le plus associé au journalisme d’investigation long format ?",
    options: [
      "Presse écrite",
      "Réseaux sociaux",
      "Télévision de divertissement",
    ],
    answer: "Presse écrite",
    explanation: "Elle permet des enquêtes approfondies.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel danger pose la diffusion d’images hors contexte ?",
    options: [
      "Manipulation de l’opinion",
      "Meilleure information",
      "Pluralisme accru",
    ],
    answer: "Manipulation de l’opinion",
    explanation: "Les images peuvent induire en erreur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel droit protège la liberté de publier des opinions ?",
    options: ["Liberté d’expression", "Secret défense", "Immunité pénale"],
    answer: "Liberté d’expression",
    explanation: "Elle permet le débat public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel enjeu social est lié à l’augmentation du temps passé sur les écrans ?",
    options: [
      "Santé numérique",
      "Centralisation politique",
      "Baisse de l’éducation",
    ],
    answer: "Santé numérique",
    explanation: "Les écrans peuvent affecter la santé physique et mentale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel objectif vise la promotion de l’égalité femmes-hommes ?",
    options: ["Égalité réelle", "Uniformisation sociale", "Centralisation"],
    answer: "Égalité réelle",
    explanation: "Elle vise l’égalité dans les faits.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel risque est lié à la dépendance aux technologies étrangères ?",
    options: [
      "Perte de souveraineté",
      "Hausse de l’innovation",
      "Neutralité accrue",
    ],
    answer: "Perte de souveraineté",
    explanation: "La dépendance peut fragiliser l’autonomie nationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel enjeu concerne la régulation des contenus haineux en ligne ?",
    options: [
      "Protection des personnes",
      "Censure généralisée",
      "Centralisation",
    ],
    answer: "Protection des personnes",
    explanation: "La régulation vise à limiter les abus.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel défi concerne la confiance des citoyens dans les médias ?",
    options: [
      "Crédibilité journalistique",
      "Suppression des médias",
      "Censure",
    ],
    answer: "Crédibilité journalistique",
    explanation: "La confiance repose sur la fiabilité de l’information.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe garantit la liberté d’opinion en France ?",
    options: ["Liberté de conscience", "Ordre public", "Neutralité"],
    answer: "Liberté de conscience",
    explanation: "Elle permet à chacun d’avoir ses propres convictions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel enjeu social est lié à l’augmentation des inégalités de revenus ?",
    options: [
      "Cohésion sociale",
      "Décentralisation",
      "Mobilité internationale",
    ],
    answer: "Cohésion sociale",
    explanation: "Les inégalités peuvent fragiliser le vivre-ensemble.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel droit protège les citoyens contre les atteintes à leur dignité ?",
    options: [
      "Dignité de la personne humaine",
      "Liberté contractuelle",
      "Ordre public",
    ],
    answer: "Dignité de la personne humaine",
    explanation: "C’est un principe fondamental du droit français.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel phénomène social est lié à la hausse du travail à temps partiel ?",
    options: [
      "Précarisation du travail",
      "Centralisation",
      "Baisse de l’activité",
    ],
    answer: "Précarisation du travail",
    explanation: "Le temps partiel subi fragilise certains salariés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe garantit l’accès de tous à l’éducation ?",
    options: ["Droit à l’éducation", "Neutralité économique", "Subsidiarité"],
    answer: "Droit à l’éducation",
    explanation: "Il est reconnu comme un droit fondamental.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel enjeu mondial est lié à la militarisation de l’espace ?",
    options: [
      "Sécurité internationale",
      "Tourisme spatial",
      "Recherche scientifique",
    ],
    answer: "Sécurité internationale",
    explanation: "L’espace devient un nouveau champ stratégique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel organisme international vise à réduire la pauvreté mondiale ?",
    options: ["Banque mondiale", "OTAN", "OCDE"],
    answer: "Banque mondiale",
    explanation: "Elle finance des projets de développement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel risque mondial est lié aux tensions commerciales entre grandes puissances ?",
    options: [
      "Guerres commerciales",
      "Stabilité économique",
      "Coopération accrue",
    ],
    answer: "Guerres commerciales",
    explanation: "Les droits de douane peuvent provoquer des représailles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu concerne la protection des données à l’échelle mondiale ?",
    options: ["Souveraineté numérique", "Tourisme", "Politique agricole"],
    answer: "Souveraineté numérique",
    explanation: "Les États cherchent à contrôler leurs données.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel phénomène mondial est lié à la montée du populisme ?",
    options: [
      "Crise de confiance démocratique",
      "Croissance économique",
      "Stabilité politique",
    ],
    answer: "Crise de confiance démocratique",
    explanation: "Les citoyens se méfient des élites politiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel principe impose l’exactitude des informations diffusées ?",
    options: ["Véracité", "Pluralisme", "Censure"],
    answer: "Véracité",
    explanation: "Les faits doivent être rigoureusement vérifiés.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel risque est lié à la rapidité de diffusion de l’information en ligne ?",
    options: [
      "Erreurs non corrigées",
      "Meilleure fiabilité",
      "Neutralité accrue",
    ],
    answer: "Erreurs non corrigées",
    explanation: "La vitesse peut nuire à la vérification.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel média est le plus associé à l’actualité en temps réel ?",
    options: ["Internet", "Livre", "Presse mensuelle"],
    answer: "Internet",
    explanation: "Il permet une diffusion instantanée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel danger pose la dépendance aux sources uniques ?",
    options: [
      "Biais de l’information",
      "Pluralisme renforcé",
      "Neutralité accrue",
    ],
    answer: "Biais de l’information",
    explanation: "Une seule source limite la diversité des points de vue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel droit protège la liberté de critiquer l’action publique ?",
    options: ["Liberté d’expression", "Secret défense", "Immunité pénale"],
    answer: "Liberté d’expression",
    explanation: "Elle permet le contrôle citoyen des pouvoirs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu social est lié à la robotisation du travail ?",
    options: [
      "Transformation des emplois",
      "Disparition totale du travail",
      "Centralisation",
    ],
    answer: "Transformation des emplois",
    explanation: "Les métiers évoluent avec l’automatisation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel objectif vise la transition écologique ?",
    options: [
      "Réduction de l’impact environnemental",
      "Croissance illimitée",
      "Centralisation politique",
    ],
    answer: "Réduction de l’impact environnemental",
    explanation: "Elle vise à préserver les écosystèmes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel risque est lié à la perte de confiance dans les institutions ?",
    options: [
      "Affaiblissement démocratique",
      "Renforcement de la participation",
      "Stabilité accrue",
    ],
    answer: "Affaiblissement démocratique",
    explanation: "La légitimité des institutions peut être contestée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel enjeu concerne l’encadrement des contenus générés par l’IA ?",
    options: [
      "Responsabilité juridique",
      "Fin de l’innovation",
      "Centralisation",
    ],
    answer: "Responsabilité juridique",
    explanation: "Il faut déterminer qui est responsable des contenus.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel défi concerne la participation citoyenne en ligne ?",
    options: [
      "Qualité du débat public",
      "Suppression des votes",
      "Censure généralisée",
    ],
    answer: "Qualité du débat public",
    explanation: "Le numérique transforme les échanges démocratiques.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel principe garantit la protection de la liberté individuelle face aux pouvoirs publics ?",
    options: ["Habeas corpus", "Ordre public", "Neutralité"],
    answer: "Habeas corpus",
    explanation: "Il protège contre les arrestations arbitraires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel enjeu social est lié à la hausse du nombre de travailleurs indépendants ?",
    options: [
      "Protection sociale",
      "Centralisation économique",
      "Baisse de l’emploi",
    ],
    answer: "Protection sociale",
    explanation:
        "Les indépendants bénéficient d’une couverture différente des salariés.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel droit garantit la liberté d’accès aux documents administratifs ?",
    options: ["Droit à l’information", "Secret professionnel", "Droit pénal"],
    answer: "Droit à l’information",
    explanation: "Il permet la transparence de l’action publique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel phénomène social est lié à la hausse du coût de la vie étudiante ?",
    options: [
      "Précarité étudiante",
      "Décentralisation",
      "Mobilité internationale",
    ],
    answer: "Précarité étudiante",
    explanation: "Les dépenses augmentent plus vite que les ressources.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel principe garantit la liberté syndicale des travailleurs ?",
    options: ["Liberté d’association", "Neutralité politique", "Ordre public"],
    answer: "Liberté d’association",
    explanation: "Elle permet de créer et d’adhérer à un syndicat.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu mondial est lié à l’augmentation des migrations climatiques ?",
    options: ["Déplacements forcés", "Croissance économique", "Numérisation"],
    answer: "Déplacements forcés",
    explanation:
        "Le climat pousse certaines populations à quitter leur territoire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel organisme international coordonne la lutte contre le changement climatique ?",
    options: ["ONU", "OMC", "OCDE"],
    answer: "ONU",
    explanation: "Elle organise les conférences climatiques mondiales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel risque mondial est lié à la fragmentation d’Internet ?",
    options: [
      "Balkanisation du numérique",
      "Sécurité renforcée",
      "Neutralité accrue",
    ],
    answer: "Balkanisation du numérique",
    explanation: "Les réseaux peuvent être cloisonnés par pays.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel enjeu concerne la liberté de navigation en mer ?",
    options: ["Droit maritime international", "Tourisme", "Politique agricole"],
    answer: "Droit maritime international",
    explanation: "Il encadre l’usage des mers et océans.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel phénomène mondial est lié à l’augmentation des zones urbaines ?",
    options: ["Urbanisation", "Ruralisation", "Décentralisation"],
    answer: "Urbanisation",
    explanation: "La population se concentre dans les villes.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel principe impose la responsabilité éditoriale des directeurs de publication ?",
    options: ["Responsabilité juridique", "Neutralité", "Censure"],
    answer: "Responsabilité juridique",
    explanation: "Ils répondent légalement des contenus publiés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel risque est lié à la monétisation des données personnelles ?",
    options: [
      "Atteinte à la vie privée",
      "Meilleure information",
      "Neutralité accrue",
    ],
    answer: "Atteinte à la vie privée",
    explanation: "Les données peuvent être exploitées sans consentement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel média est le plus associé à la diffusion d’informations locales quotidiennes ?",
    options: ["Presse régionale", "Cinéma", "Télévision internationale"],
    answer: "Presse régionale",
    explanation: "Elle couvre l’actualité de proximité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel danger pose l’usage de l’intelligence artificielle pour créer de faux contenus ?",
    options: ["Désinformation", "Pluralisme accru", "Meilleure transparence"],
    answer: "Désinformation",
    explanation: "Les contenus truqués peuvent tromper le public.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel droit protège la liberté de commenter l’actualité ?",
    options: ["Liberté d’expression", "Secret défense", "Immunité pénale"],
    answer: "Liberté d’expression",
    explanation: "Elle permet le débat public.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel enjeu social est lié à l’allongement du temps de travail ?",
    options: [
      "Qualité de vie au travail",
      "Centralisation politique",
      "Baisse de l’emploi",
    ],
    answer: "Qualité de vie au travail",
    explanation: "L’équilibre vie professionnelle/vie privée est concerné.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel objectif vise la régulation des réseaux sociaux ?",
    options: [
      "Protection des utilisateurs",
      "Suppression des échanges",
      "Centralisation",
    ],
    answer: "Protection des utilisateurs",
    explanation: "Elle vise à limiter les abus et contenus illicites.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel risque est lié à la dépendance excessive aux écrans ?",
    options: [
      "Problèmes de santé",
      "Meilleure information",
      "Neutralité accrue",
    ],
    answer: "Problèmes de santé",
    explanation: "L’usage excessif peut nuire au bien-être.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel enjeu concerne l’encadrement juridique de l’IA générative ?",
    options: [
      "Responsabilité des acteurs",
      "Fin de l’innovation",
      "Centralisation",
    ],
    answer: "Responsabilité des acteurs",
    explanation: "Il faut déterminer qui répond des usages de l’IA.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel défi concerne la diffusion d’une information fiable en période de crise ?",
    options: [
      "Gestion de l’information",
      "Censure totale",
      "Suppression des médias",
    ],
    answer: "Gestion de l’information",
    explanation: "Une information claire évite la panique.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel principe impose la neutralité religieuse de l’État français ?",
    options: ["Laïcité", "Pluralisme", "Liberté contractuelle"],
    answer: "Laïcité",
    explanation:
        "La laïcité garantit la neutralité de l’État à l’égard des religions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel enjeu social est lié au vieillissement de la population française ?",
    options: [
      "Financement des retraites",
      "Décentralisation",
      "Mobilité étudiante",
    ],
    answer: "Financement des retraites",
    explanation: "L’augmentation des retraités pose un défi économique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel droit protège la vie privée des citoyens face aux technologies numériques ?",
    options: [
      "Protection des données personnelles",
      "Liberté d’expression",
      "Ordre public",
    ],
    answer: "Protection des données personnelles",
    explanation: "Elle limite la collecte et l’usage des données privées.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question: "Quel phénomène social est lié à l’augmentation du télétravail ?",
    options: [
      "Transformation des modes de travail",
      "Baisse de l’activité",
      "Centralisation",
    ],
    answer: "Transformation des modes de travail",
    explanation: "Le télétravail modifie l’organisation professionnelle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — France",
    question:
        "Quel principe constitutionnel protège la liberté d’aller et venir ?",
    options: ["Liberté individuelle", "Principe de précaution", "Subsidiarité"],
    answer: "Liberté individuelle",
    explanation: "Elle garantit les déplacements des citoyens.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel enjeu mondial est lié aux tensions autour des routes maritimes stratégiques ?",
    options: [
      "Sécurité du commerce mondial",
      "Tourisme",
      "Politique culturelle",
    ],
    answer: "Sécurité du commerce mondial",
    explanation: "Les échanges internationaux dépendent de ces routes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel organisme international arbitre les différends commerciaux entre États ?",
    options: ["OMC", "ONU", "FMI"],
    answer: "OMC",
    explanation:
        "L’Organisation mondiale du commerce règle les litiges commerciaux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel risque mondial est lié à la prolifération nucléaire ?",
    options: [
      "Menace sur la sécurité internationale",
      "Croissance économique",
      "Stabilité politique",
    ],
    answer: "Menace sur la sécurité internationale",
    explanation:
        "La diffusion d’armes nucléaires accroît les risques de conflit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question: "Quel enjeu concerne l’accès à l’eau potable dans le monde ?",
    options: ["Développement durable", "Numérisation", "Centralisation"],
    answer: "Développement durable",
    explanation: "L’eau est une ressource essentielle et limitée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Internationale",
    question:
        "Quel phénomène mondial est lié à la montée des températures moyennes ?",
    options: [
      "Réchauffement climatique",
      "Urbanisation",
      "Mondialisation culturelle",
    ],
    answer: "Réchauffement climatique",
    explanation: "Les températures augmentent à l’échelle mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel principe garantit le pluralisme des opinions dans les médias ?",
    options: ["Liberté de la presse", "Censure", "Secret défense"],
    answer: "Liberté de la presse",
    explanation: "Elle permet l’expression de points de vue variés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel risque est lié à la concentration des groupes médiatiques ?",
    options: [
      "Réduction de la diversité de l’information",
      "Meilleure objectivité",
      "Neutralité accrue",
    ],
    answer: "Réduction de la diversité de l’information",
    explanation: "Moins d’acteurs peut limiter les points de vue.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel média est le plus associé aux formats courts d’information ?",
    options: ["Réseaux sociaux", "Livre", "Revue scientifique"],
    answer: "Réseaux sociaux",
    explanation: "Ils privilégient des contenus rapides et synthétiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question: "Quel danger pose la diffusion massive de deepfakes ?",
    options: [
      "Perte de confiance dans l’information",
      "Meilleure créativité",
      "Pluralisme renforcé",
    ],
    answer: "Perte de confiance dans l’information",
    explanation: "Les contenus falsifiés brouillent la réalité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Médias",
    question:
        "Quel droit permet à une personne de répondre à une information la concernant ?",
    options: ["Droit de réponse", "Droit pénal", "Secret professionnel"],
    answer: "Droit de réponse",
    explanation: "Il permet de faire publier une réponse.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel enjeu social est lié à l’augmentation des prix de l’énergie ?",
    options: ["Pouvoir d’achat", "Décentralisation", "Mobilité internationale"],
    answer: "Pouvoir d’achat",
    explanation: "Les factures énergétiques pèsent sur les ménages.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel objectif vise la sobriété énergétique ?",
    options: [
      "Réduction de la consommation",
      "Croissance illimitée",
      "Centralisation",
    ],
    answer: "Réduction de la consommation",
    explanation: "Elle limite l’usage excessif des ressources.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question: "Quel risque est lié à l’exclusion numérique ?",
    options: [
      "Inégalités sociales accrues",
      "Meilleure intégration",
      "Neutralité technologique",
    ],
    answer: "Inégalités sociales accrues",
    explanation: "L’accès inégal au numérique crée des écarts.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel enjeu concerne l’encadrement des algorithmes de recommandation ?",
    options: [
      "Transparence",
      "Suppression d’Internet",
      "Centralisation politique",
    ],
    answer: "Transparence",
    explanation: "Les utilisateurs doivent comprendre leur fonctionnement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité & société — Débats contemporains",
    question:
        "Quel défi concerne la participation citoyenne aux décisions publiques ?",
    options: [
      "Renforcement de la démocratie",
      "Suppression des élections",
      "Censure",
    ],
    answer: "Renforcement de la démocratie",
    explanation: "La participation favorise l’engagement civique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel enjeu majeur marque les débats politiques français en 2025 concernant le budget de l’État ?",
    options: [
      "La maîtrise de la dette publique",
      "La sortie de l’euro",
      "La suppression des régions",
    ],
    answer: "La maîtrise de la dette publique",
    explanation:
        "La réduction des déficits est au cœur des débats budgétaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel sujet social est au centre des discussions sur le marché du travail en 2025 ?",
    options: [
      "L’adaptation au vieillissement",
      "La fin du salariat",
      "La suppression du SMIC",
    ],
    answer: "L’adaptation au vieillissement",
    explanation: "Le vieillissement de la population impacte l’emploi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quelle problématique énergétique reste prioritaire en France en 2025 ?",
    options: [
      "Sécurité d’approvisionnement",
      "Abandon total du nucléaire",
      "Retour au charbon",
    ],
    answer: "Sécurité d’approvisionnement",
    explanation: "Garantir une énergie stable est un enjeu central.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question: "Quel débat concerne directement l’école en France en 2025 ?",
    options: [
      "L’attractivité du métier d’enseignant",
      "La suppression de l’école obligatoire",
      "La privatisation totale",
    ],
    answer: "L’attractivité du métier d’enseignant",
    explanation: "Le recrutement et la fidélisation sont des enjeux clés.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel enjeu de société est lié à la hausse des loyers dans les grandes villes ?",
    options: [
      "Accès au logement",
      "Décentralisation régionale",
      "Mobilité internationale",
    ],
    answer: "Accès au logement",
    explanation:
        "Le logement devient difficilement accessible pour certains ménages.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel conflit international continue d’avoir des répercussions géopolitiques majeures en 2025 ?",
    options: [
      "Conflits armés régionaux",
      "Guerres coloniales",
      "Conflits médiévaux",
    ],
    answer: "Conflits armés régionaux",
    explanation: "Ils influencent la stabilité mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel enjeu est au cœur des relations entre grandes puissances en 2025 ?",
    options: [
      "Rivalités stratégiques",
      "Unification politique mondiale",
      "Disparition des frontières",
    ],
    answer: "Rivalités stratégiques",
    explanation: "Les équilibres géopolitiques restent tendus.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question: "Quel rôle joue l’ONU face aux crises humanitaires en 2025 ?",
    options: [
      "Coordination de l’aide",
      "Gestion directe des États",
      "Suppression des ONG",
    ],
    answer: "Coordination de l’aide",
    explanation: "L’ONU coordonne l’action internationale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question: "Quel enjeu concerne la sécurité alimentaire mondiale en 2025 ?",
    options: [
      "Approvisionnement durable",
      "Surproduction généralisée",
      "Fin de l’agriculture",
    ],
    answer: "Approvisionnement durable",
    explanation: "L’accès à l’alimentation reste inégal.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel sujet est central dans les discussions climatiques internationales en 2025 ?",
    options: [
      "Réduction des émissions",
      "Abandon des accords",
      "Croissance sans limites",
    ],
    answer: "Réduction des émissions",
    explanation: "Les objectifs climatiques restent prioritaires.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question:
        "Quel enjeu sociétal est lié à l’essor de l’intelligence artificielle en 2025 ?",
    options: [
      "Encadrement éthique",
      "Fin du travail humain",
      "Suppression du droit",
    ],
    answer: "Encadrement éthique",
    explanation: "L’IA pose des questions de responsabilité et d’éthique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question: "Quel débat concerne la protection de la vie privée en 2025 ?",
    options: [
      "Utilisation des données personnelles",
      "Suppression d’Internet",
      "Fin des réseaux",
    ],
    answer: "Utilisation des données personnelles",
    explanation: "Les données sont au cœur des enjeux numériques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question:
        "Quel enjeu est lié à la lutte contre la désinformation en 2025 ?",
    options: [
      "Qualité du débat démocratique",
      "Censure généralisée",
      "Suppression des médias",
    ],
    answer: "Qualité du débat démocratique",
    explanation: "Une information fiable est essentielle à la démocratie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question:
        "Quel phénomène social se renforce avec l’usage intensif des réseaux sociaux ?",
    options: [
      "Polarisation des opinions",
      "Uniformité des idées",
      "Disparition du débat",
    ],
    answer: "Polarisation des opinions",
    explanation: "Les opinions ont tendance à se radicaliser.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question:
        "Quel enjeu concerne l’intégration des nouvelles générations dans la vie civique ?",
    options: [
      "Participation citoyenne",
      "Suppression du vote",
      "Centralisation politique",
    ],
    answer: "Participation citoyenne",
    explanation: "L’engagement des jeunes est un enjeu démocratique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel enjeu domine les débats français de 2025 sur la transition énergétique ?",
    options: [
      "Souveraineté énergétique",
      "Retour au charbon",
      "Privatisation totale",
    ],
    answer: "Souveraineté énergétique",
    explanation:
        "La capacité à produire une énergie stable et nationale est centrale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel sujet structure les discussions sur l’immigration en France en 2025 ?",
    options: [
      "Intégration républicaine",
      "Suppression du droit d’asile",
      "Ouverture totale des frontières",
    ],
    answer: "Intégration républicaine",
    explanation:
        "L’intégration sociale et professionnelle est au cœur des politiques publiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel enjeu concerne la justice française face à l’augmentation des contentieux ?",
    options: [
      "Délais de jugement",
      "Suppression des tribunaux",
      "Justice privée",
    ],
    answer: "Délais de jugement",
    explanation: "L’engorgement des juridictions est un problème récurrent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel thème est central dans les débats sur la fonction publique en 2025 ?",
    options: [
      "Attractivité des carrières",
      "Suppression du statut",
      "Privatisation totale",
    ],
    answer: "Attractivité des carrières",
    explanation: "Le recrutement et la fidélisation sont des enjeux majeurs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel enjeu social est lié à l’augmentation des prix alimentaires en 2025 ?",
    options: ["Pouvoir d’achat", "Décentralisation", "Mobilité étudiante"],
    answer: "Pouvoir d’achat",
    explanation: "La hausse des prix pèse sur les ménages.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel enjeu structure les relations entre grandes puissances en 2025 ?",
    options: [
      "Compétition technologique",
      "Disparition des alliances",
      "Isolement diplomatique",
    ],
    answer: "Compétition technologique",
    explanation: "Les technologies stratégiques sont un levier de puissance.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel rôle joue l’Union européenne face aux crises géopolitiques en 2025 ?",
    options: [
      "Coordination diplomatique",
      "Neutralité absolue",
      "Dissolution politique",
    ],
    answer: "Coordination diplomatique",
    explanation: "L’UE cherche à parler d’une seule voix.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel enjeu mondial est lié à la sécurisation des chaînes d’approvisionnement ?",
    options: [
      "Résilience économique",
      "Fin du commerce",
      "Centralisation mondiale",
    ],
    answer: "Résilience économique",
    explanation: "Les États veulent limiter les dépendances critiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question: "Quel sujet reste central à l’ONU en 2025 ?",
    options: [
      "Gestion des crises humanitaires",
      "Suppression des États",
      "Uniformisation politique",
    ],
    answer: "Gestion des crises humanitaires",
    explanation: "L’aide aux populations reste une mission clé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel enjeu concerne la régulation mondiale de l’intelligence artificielle ?",
    options: [
      "Cadre juridique international",
      "Interdiction totale",
      "Absence de règles",
    ],
    answer: "Cadre juridique international",
    explanation: "Les usages de l’IA dépassent les frontières nationales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question:
        "Quel enjeu sociétal est lié à la hausse des troubles anxieux en 2025 ?",
    options: ["Santé mentale", "Décentralisation", "Mobilité professionnelle"],
    answer: "Santé mentale",
    explanation: "La prise en charge psychologique devient prioritaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question: "Quel débat concerne la place de l’IA dans l’éducation en 2025 ?",
    options: [
      "Usage pédagogique encadré",
      "Suppression de l’école",
      "Remplacement total des enseignants",
    ],
    answer: "Usage pédagogique encadré",
    explanation: "L’IA doit rester un outil au service de l’enseignement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question:
        "Quel enjeu touche la liberté d’expression à l’ère numérique en 2025 ?",
    options: [
      "Équilibre entre liberté et responsabilité",
      "Censure totale",
      "Absence de règles",
    ],
    answer: "Équilibre entre liberté et responsabilité",
    explanation: "Les propos en ligne doivent respecter le droit.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question: "Quel phénomène social est renforcé par les crises successives ?",
    options: [
      "Méfiance institutionnelle",
      "Confiance accrue",
      "Uniformité sociale",
    ],
    answer: "Méfiance institutionnelle",
    explanation: "Les citoyens doutent davantage des institutions.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question:
        "Quel enjeu démocratique est lié à l’abstention électorale persistante ?",
    options: [
      "Représentativité",
      "Suppression du vote",
      "Centralisation politique",
    ],
    answer: "Représentativité",
    explanation: "L’abstention fragilise la légitimité des élus.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel enjeu est central en 2025 dans le débat sur la réforme des retraites en France ?",
    options: [
      "Soutenabilité du système",
      "Suppression des pensions",
      "Privatisation totale",
    ],
    answer: "Soutenabilité du système",
    explanation:
        "Le financement à long terme des retraites est un enjeu majeur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel sujet domine les discussions sur la sécurité intérieure en 2025 ?",
    options: [
      "Prévention et protection",
      "Suppression de la police",
      "Justice privée",
    ],
    answer: "Prévention et protection",
    explanation:
        "Les politiques publiques cherchent à concilier sécurité et libertés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question: "Quel enjeu concerne la lutte contre la fraude sociale en 2025 ?",
    options: [
      "Équité du système social",
      "Réduction des droits",
      "Suppression des aides",
    ],
    answer: "Équité du système social",
    explanation: "La fraude remet en cause la justice sociale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel thème est central dans les débats sur l’hôpital public en 2025 ?",
    options: [
      "Manque de personnels",
      "Privatisation totale",
      "Suppression des urgences",
    ],
    answer: "Manque de personnels",
    explanation:
        "Les tensions sur les effectifs fragilisent le système hospitalier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel enjeu touche directement les collectivités locales en 2025 ?",
    options: [
      "Financement des services publics",
      "Disparition des communes",
      "Centralisation totale",
    ],
    answer: "Financement des services publics",
    explanation: "Les collectivités doivent maintenir leurs missions.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel enjeu est lié à la montée des tensions en mer de Chine en 2025 ?",
    options: ["Liberté de navigation", "Tourisme maritime", "Pêche artisanale"],
    answer: "Liberté de navigation",
    explanation: "Cette zone est stratégique pour le commerce mondial.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question: "Quel rôle jouent les sanctions économiques en 2025 ?",
    options: [
      "Instrument diplomatique",
      "Suppression du commerce",
      "Aide humanitaire",
    ],
    answer: "Instrument diplomatique",
    explanation: "Elles visent à faire pression sans recours militaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel enjeu concerne la réforme du Conseil de sécurité de l’ONU en 2025 ?",
    options: [
      "Représentativité internationale",
      "Suppression de l’ONU",
      "Centralisation mondiale",
    ],
    answer: "Représentativité internationale",
    explanation: "Certains États demandent une meilleure représentation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel sujet est central dans les discussions sur l’aide humanitaire mondiale ?",
    options: [
      "Accès aux populations civiles",
      "Fin des ONG",
      "Privatisation de l’aide",
    ],
    answer: "Accès aux populations civiles",
    explanation: "Les conflits compliquent l’acheminement de l’aide.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel enjeu mondial est lié à la dette des pays en développement ?",
    options: [
      "Stabilité économique",
      "Fin de la coopération",
      "Isolement financier",
    ],
    answer: "Stabilité économique",
    explanation: "La dette excessive fragilise certains États.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question:
        "Quel enjeu sociétal est lié à la pénurie de logements abordables ?",
    options: [
      "Crise du logement",
      "Mobilité internationale",
      "Centralisation urbaine",
    ],
    answer: "Crise du logement",
    explanation: "L’offre ne répond pas à la demande.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question:
        "Quel débat concerne la place du travail dans la société en 2025 ?",
    options: [
      "Équilibre vie professionnelle-vie personnelle",
      "Fin du travail",
      "Suppression des congés",
    ],
    answer: "Équilibre vie professionnelle-vie personnelle",
    explanation: "Les attentes des salariés évoluent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question:
        "Quel enjeu touche la jeunesse face aux transformations économiques ?",
    options: [
      "Insertion professionnelle",
      "Suppression des études",
      "Centralisation",
    ],
    answer: "Insertion professionnelle",
    explanation: "L’accès à l’emploi reste un défi.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question:
        "Quel phénomène social est accentué par la hausse des prix de l’énergie ?",
    options: ["Précarité énergétique", "Décentralisation", "Mobilité sociale"],
    answer: "Précarité énergétique",
    explanation: "Certains ménages peinent à se chauffer.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question:
        "Quel enjeu démocratique est lié à la confiance dans l’information ?",
    options: [
      "Crédibilité des sources",
      "Suppression des médias",
      "Censure généralisée",
    ],
    answer: "Crédibilité des sources",
    explanation: "Une information fiable est essentielle au débat public.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel enjeu est central en 2025 concernant la réforme de l’assurance chômage ?",
    options: [
      "Incitation au retour à l’emploi",
      "Suppression des allocations",
      "Privatisation du système",
    ],
    answer: "Incitation au retour à l’emploi",
    explanation: "Les réformes visent à favoriser la reprise d’activité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question: "Quel sujet domine les débats sur la laïcité en France en 2025 ?",
    options: [
      "Neutralité des services publics",
      "Fin de la liberté religieuse",
      "Suppression des cultes",
    ],
    answer: "Neutralité des services publics",
    explanation: "La laïcité impose la neutralité de l’État.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel enjeu concerne la politique familiale face à la baisse de la natalité ?",
    options: [
      "Soutien aux familles",
      "Suppression des aides",
      "Immigration forcée",
    ],
    answer: "Soutien aux familles",
    explanation: "Les politiques cherchent à encourager les naissances.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel thème est central dans les discussions sur la justice des mineurs en 2025 ?",
    options: [
      "Équilibre entre sanction et éducation",
      "Répression exclusive",
      "Suppression des tribunaux spécialisés",
    ],
    answer: "Équilibre entre sanction et éducation",
    explanation: "La justice des mineurs privilégie l’aspect éducatif.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel enjeu touche la politique de santé publique face aux déserts médicaux ?",
    options: [
      "Accès aux soins",
      "Centralisation hospitalière",
      "Privatisation totale",
    ],
    answer: "Accès aux soins",
    explanation: "Certaines zones manquent de professionnels de santé.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel enjeu est lié à l’élargissement potentiel de l’Union européenne en 2025 ?",
    options: [
      "Cohésion politique",
      "Dissolution de l’UE",
      "Fin des institutions",
    ],
    answer: "Cohésion politique",
    explanation: "L’élargissement pose des défis institutionnels.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel sujet est central dans les relations transatlantiques en 2025 ?",
    options: [
      "Coopération stratégique",
      "Rupture diplomatique",
      "Isolement militaire",
    ],
    answer: "Coopération stratégique",
    explanation: "Les alliances restent un pilier géopolitique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel enjeu mondial concerne la régulation des crypto-actifs en 2025 ?",
    options: [
      "Stabilité financière",
      "Suppression des monnaies",
      "Fin des banques",
    ],
    answer: "Stabilité financière",
    explanation: "Les crypto-actifs posent des risques systémiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel phénomène influence fortement les politiques migratoires mondiales ?",
    options: [
      "Crises géopolitiques",
      "Tourisme international",
      "Échanges universitaires",
    ],
    answer: "Crises géopolitiques",
    explanation: "Les conflits provoquent des déplacements de populations.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel enjeu est central dans la gouvernance mondiale des océans ?",
    options: [
      "Protection de la biodiversité marine",
      "Exploitation sans limite",
      "Privatisation des mers",
    ],
    answer: "Protection de la biodiversité marine",
    explanation: "Les océans sont menacés par la pollution et la surpêche.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question:
        "Quel enjeu sociétal est lié à la généralisation des outils d’IA générative ?",
    options: [
      "Transformation des métiers",
      "Disparition de l’éducation",
      "Fin de la créativité",
    ],
    answer: "Transformation des métiers",
    explanation: "De nombreux emplois évoluent avec l’IA.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question: "Quel débat concerne la protection de l’enfance sur Internet ?",
    options: [
      "Encadrement des contenus",
      "Suppression d’Internet",
      "Liberté totale",
    ],
    answer: "Encadrement des contenus",
    explanation: "Les mineurs doivent être protégés des contenus nocifs.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question: "Quel enjeu est lié à la montée des discours complotistes ?",
    options: [
      "Esprit critique des citoyens",
      "Liberté totale d’opinion",
      "Censure généralisée",
    ],
    answer: "Esprit critique des citoyens",
    explanation: "L’éducation aux médias est essentielle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question: "Quel phénomène social est renforcé par l’isolement numérique ?",
    options: ["Solitude", "Cohésion sociale", "Engagement collectif"],
    answer: "Solitude",
    explanation: "L’usage excessif du numérique peut isoler.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question:
        "Quel enjeu démocratique est lié à la transparence de l’action publique ?",
    options: [
      "Confiance des citoyens",
      "Affaiblissement de l’État",
      "Secret généralisé",
    ],
    answer: "Confiance des citoyens",
    explanation: "La transparence renforce la légitimité démocratique.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel enjeu est central en 2025 concernant la lutte contre la pauvreté en France ?",
    options: [
      "Accès aux droits sociaux",
      "Suppression des aides",
      "Privatisation de l’action sociale",
    ],
    answer: "Accès aux droits sociaux",
    explanation:
        "L’enjeu est de garantir que les aides atteignent les publics concernés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel sujet est au cœur des débats sur la réforme de l’éducation nationale en 2025 ?",
    options: [
      "Réduction des inégalités scolaires",
      "Suppression du collège",
      "Privatisation de l’école",
    ],
    answer: "Réduction des inégalités scolaires",
    explanation: "Les écarts de réussite restent un enjeu majeur.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question: "Quel enjeu concerne la politique de sécurité routière en 2025 ?",
    options: [
      "Réduction de la mortalité",
      "Suppression des limitations",
      "Privatisation des routes",
    ],
    answer: "Réduction de la mortalité",
    explanation: "La sécurité des usagers reste prioritaire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question:
        "Quel thème domine les discussions sur la transition numérique de l’État en 2025 ?",
    options: [
      "Accessibilité des services publics",
      "Suppression des guichets",
      "Centralisation totale",
    ],
    answer: "Accessibilité des services publics",
    explanation: "La dématérialisation doit rester inclusive.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — France",
    question: "Quel enjeu touche la politique pénitentiaire en 2025 ?",
    options: [
      "Surpopulation carcérale",
      "Suppression des peines",
      "Justice privée",
    ],
    answer: "Surpopulation carcérale",
    explanation: "Les prisons françaises sont fortement saturées.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel enjeu mondial est lié à la sécurisation des câbles sous-marins ?",
    options: [
      "Protection des communications",
      "Tourisme maritime",
      "Pêche industrielle",
    ],
    answer: "Protection des communications",
    explanation: "Les câbles sont essentiels aux échanges numériques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel sujet est central dans les négociations climatiques de 2025 ?",
    options: [
      "Financement de l’adaptation",
      "Abandon des accords",
      "Croissance sans limite",
    ],
    answer: "Financement de l’adaptation",
    explanation: "Les pays vulnérables demandent un soutien accru.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel enjeu concerne la régulation des plateformes numériques mondiales ?",
    options: [
      "Souveraineté des États",
      "Fin d’Internet",
      "Uniformisation culturelle",
    ],
    answer: "Souveraineté des États",
    explanation: "Les États cherchent à imposer leurs règles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel phénomène influence fortement la diplomatie énergétique mondiale ?",
    options: [
      "Transition énergétique",
      "Fin des échanges",
      "Retour au charbon",
    ],
    answer: "Transition énergétique",
    explanation: "Les choix énergétiques modifient les rapports de force.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Internationale",
    question:
        "Quel enjeu est lié à la protection des civils dans les conflits armés ?",
    options: [
      "Droit international humanitaire",
      "Politique commerciale",
      "Tourisme humanitaire",
    ],
    answer: "Droit international humanitaire",
    explanation: "Il encadre la conduite des hostilités.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question:
        "Quel enjeu sociétal est lié à l’augmentation des troubles liés au stress ?",
    options: [
      "Bien-être au travail",
      "Centralisation économique",
      "Mobilité internationale",
    ],
    answer: "Bien-être au travail",
    explanation: "Les conditions de travail influencent la santé mentale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question: "Quel débat concerne l’encadrement du télétravail en 2025 ?",
    options: [
      "Droit à la déconnexion",
      "Suppression du travail à distance",
      "Travail sans règles",
    ],
    answer: "Droit à la déconnexion",
    explanation: "Il vise à protéger la vie privée des salariés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question: "Quel enjeu est lié à la montée des discours de haine en ligne ?",
    options: [
      "Protection des personnes",
      "Liberté totale",
      "Absence de règles",
    ],
    answer: "Protection des personnes",
    explanation: "La loi encadre les propos illicites.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question:
        "Quel phénomène social est accentué par la précarité économique ?",
    options: ["Exclusion sociale", "Mobilité ascendante", "Cohésion renforcée"],
    answer: "Exclusion sociale",
    explanation: "La précarité fragilise l’intégration sociale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2025 — Société",
    question: "Quel enjeu démocratique est lié à l’éducation aux médias ?",
    options: ["Esprit critique", "Censure", "Uniformité des opinions"],
    answer: "Esprit critique",
    explanation: "Elle permet de mieux comprendre l’information.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Actualité 2024–2025 — France",
    question: "Quel type d’élection a eu lieu en France en juin 2024 ?",
    options: [
      "Élections européennes",
      "Élections législatives",
      "Élections sénatoriales",
    ],
    answer: "Élections européennes",
    explanation:
        "Les citoyens élisent leurs représentants au Parlement européen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2024–2025 — France",
    question:
        "Quel est le mode de scrutin utilisé pour les élections européennes en France ?",
    options: ["Proportionnel", "Majoritaire", "Mixte"],
    answer: "Proportionnel",
    explanation: "Les sièges sont répartis à la proportionnelle des voix.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2024–2025 — France",
    question: "Quelle institution organise les élections en France ?",
    options: [
      "Ministère de l’Intérieur",
      "Conseil constitutionnel",
      "Assemblée nationale",
    ],
    answer: "Ministère de l’Intérieur",
    explanation: "Il est chargé de l’organisation matérielle des scrutins.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2024–2025 — France",
    question: "Quel organe contrôle la régularité des élections nationales ?",
    options: ["Conseil constitutionnel", "Cour de cassation", "Conseil d’État"],
    answer: "Conseil constitutionnel",
    explanation: "Il veille à la conformité des scrutins nationaux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2024–2025 — France",
    question:
        "Quel phénomène est souvent observé lors des élections européennes en France ?",
    options: ["Abstention élevée", "Participation record", "Vote obligatoire"],
    answer: "Abstention élevée",
    explanation: "La participation est traditionnellement plus faible.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2024–2025 — France",
    question:
        "Quel débat démocratique est relancé après les élections de 2024 ?",
    options: [
      "Représentativité politique",
      "Suppression du suffrage universel",
      "Vote censitaire",
    ],
    answer: "Représentativité politique",
    explanation: "L’abstention interroge la légitimité démocratique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2024–2025 — France",
    question: "Quel principe garantit la sincérité du scrutin électoral ?",
    options: [
      "Liberté et égalité du vote",
      "Centralisation du pouvoir",
      "Neutralité économique",
    ],
    answer: "Liberté et égalité du vote",
    explanation: "Chaque citoyen doit pouvoir voter librement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2024–2025 — Internationale",
    question:
        "Quel pays a organisé une élection présidentielle majeure en 2024 ?",
    options: ["États-Unis", "Canada", "Australie"],
    answer: "États-Unis",
    explanation:
        "L’élection présidentielle américaine a lieu tous les quatre ans.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2024–2025 — Internationale",
    question:
        "Quel enjeu mondial est au cœur des élections américaines de 2024–2025 ?",
    options: [
      "Polarisation politique",
      "Unification mondiale",
      "Fin du bipartisme mondial",
    ],
    answer: "Polarisation politique",
    explanation: "La société américaine est fortement divisée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2024–2025 — Internationale",
    question:
        "Quel risque démocratique est associé à la désinformation électorale ?",
    options: [
      "Manipulation du vote",
      "Hausse de la participation",
      "Neutralité politique",
    ],
    answer: "Manipulation du vote",
    explanation: "Les fausses informations peuvent influencer les électeurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2024–2025 — Internationale",
    question:
        "Quel acteur est souvent accusé d’ingérences électorales étrangères ?",
    options: ["États tiers", "ONG humanitaires", "Institutions judiciaires"],
    answer: "États tiers",
    explanation:
        "Certains États cherchent à influencer des scrutins étrangers.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Actualité 2024–2025 — Société",
    question:
        "Quel débat sociétal accompagne les élections récentes en France ?",
    options: [
      "Confiance dans la démocratie",
      "Suppression du vote",
      "Retour à la monarchie",
    ],
    answer: "Confiance dans la démocratie",
    explanation: "La participation électorale reflète l’engagement citoyen.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2024–2025 — Société",
    question:
        "Quel rôle jouent les réseaux sociaux dans les campagnes électorales récentes ?",
    options: [
      "Diffusion massive des messages",
      "Neutralité totale",
      "Absence d’influence",
    ],
    answer: "Diffusion massive des messages",
    explanation: "Ils sont devenus centraux dans la communication politique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Actualité 2024–2025 — Société",
    question:
        "Quel enjeu concerne la régulation des contenus politiques en ligne ?",
    options: [
      "Lutte contre la désinformation",
      "Censure généralisée",
      "Suppression du débat",
    ],
    answer: "Lutte contre la désinformation",
    explanation: "L’objectif est de préserver un débat démocratique sain.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Actualité 2024–2025 — Société",
    question:
        "Quel principe démocratique permet aux citoyens de choisir leurs représentants ?",
    options: [
      "Suffrage universel",
      "Nomination administrative",
      "Héritage politique",
    ],
    answer: "Suffrage universel",
    explanation: "Tous les citoyens majeurs peuvent voter.",
    difficulty: "Facile",
  ),
  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement marquant de l'histoire a eu lieu en 1789 en France ?",
    options: [
      "La Révolution française",
      "La Déclaration des droits de l'homme",
      "La fin de la monarchie",
    ],
    answer: "La Révolution française",
    explanation:
        "La Révolution française de 1789 a marqué le début d'un changement radical de la société française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été le premier président des États-Unis ?",
    options: ["George Washington", "Abraham Lincoln", "Thomas Jefferson"],
    answer: "George Washington",
    explanation:
        "George Washington a été élu premier président des États-Unis en 1789.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom du traité qui a mis fin à la Première Guerre mondiale ?",
    options: ["Traité de Versailles", "Traité de Trianon", "Traité de Paris"],
    answer: "Traité de Versailles",
    explanation:
        "Le Traité de Versailles a été signé en 1919, mettant officiellement fin à la Première Guerre mondiale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre discours Martin Luther King a-t-il prononcé en 1963 ?",
    options: ["I Have a Dream", "We Shall Overcome", "Give Me Liberty"],
    answer: "I Have a Dream",
    explanation:
        "Le discours 'I Have a Dream' est emblématique du mouvement des droits civiques aux États-Unis.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été le premier à accorder le droit de vote aux femmes ?",
    options: ["Nouvelle-Zélande", "États-Unis", "France"],
    answer: "Nouvelle-Zélande",
    explanation:
        "La Nouvelle-Zélande a accordé le droit de vote aux femmes en 1893.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la date de la chute du mur de Berlin ?",
    options: ["9 novembre 1989", "1er janvier 1990", "14 juillet 1789"],
    answer: "9 novembre 1989",
    explanation:
        "La chute du mur de Berlin a eu lieu le 9 novembre 1989, symbolisant la fin de la guerre froide.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a été déclenché par l'assassinat de l'archiduc François-Ferdinand en 1914 ?",
    options: [
      "La Première Guerre mondiale",
      "La Seconde Guerre mondiale",
      "La Guerre froide",
    ],
    answer: "La Première Guerre mondiale",
    explanation:
        "L'assassinat de François-Ferdinand a été le catalyseur de la Première Guerre mondiale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement social majeur a eu lieu aux États-Unis dans les années 1960 ?",
    options: [
      "Le mouvement des droits civiques",
      "Le mouvement féministe",
      "Le mouvement écologiste",
    ],
    answer: "Le mouvement des droits civiques",
    explanation:
        "Le mouvement des droits civiques visait à mettre fin à la discrimination raciale aux États-Unis.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Qui était le leader de l'Union soviétique pendant la Seconde Guerre mondiale ?",
    options: ["Joseph Staline", "Leon Trotsky", "Nikita Khrouchtchev"],
    answer: "Joseph Staline",
    explanation:
        "Joseph Staline était le dirigeant de l'Union soviétique durant la Seconde Guerre mondiale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été le premier à envoyer un homme dans l'espace ?",
    options: ["Union soviétique", "États-Unis", "Chine"],
    answer: "Union soviétique",
    explanation:
        "L'Union soviétique a envoyé Youri Gagarine dans l'espace en 1961.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a eu lieu le 11 septembre 2001 aux États-Unis ?",
    options: [
      "Attentats terroristes",
      "Lancement de la guerre en Irak",
      "Signature de l'accord de paix",
    ],
    answer: "Attentats terroristes",
    explanation:
        "Les attentats du 11 septembre 2001 ont eu des conséquences majeures sur la politique mondiale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel traité a été signé pour rétablir la paix après la guerre de 30 ans en Europe ?",
    options: ["Traité de Westphalie", "Traité de Ryswick", "Traité de Utrecht"],
    answer: "Traité de Westphalie",
    explanation:
        "Le Traité de Westphalie, signé en 1648, a mis fin à la guerre de 30 ans.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel président français a lancé le programme de décentralisation en 1982 ?",
    options: ["François Mitterrand", "Jacques Chirac", "Nicolas Sarkozy"],
    answer: "François Mitterrand",
    explanation:
        "François Mitterrand a initié la décentralisation en France avec son gouvernement en 1982.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la capitale du Japon ?",
    options: ["Tokyo", "Kyoto", "Osaka"],
    answer: "Tokyo",
    explanation:
        "Tokyo est la capitale du Japon et une des plus grandes villes du monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a marqué la fin de l'apartheid en Afrique du Sud ?",
    options: [
      "Élection de Nelson Mandela",
      "Création de l'ANC",
      "Libération de Mandela",
    ],
    answer: "Élection de Nelson Mandela",
    explanation:
        "L'élection de Nelson Mandela en 1994 a marqué la fin officielle de l'apartheid en Afrique du Sud.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom de l'initiative lancée par l'ONU pour lutter contre le changement climatique ?",
    options: [
      "Accord de Paris",
      "Protocole de Kyoto",
      "Conférence de Copenhague",
    ],
    answer: "Accord de Paris",
    explanation:
        "L'Accord de Paris, signé en 2015, vise à limiter le réchauffement climatique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a été déclenché par la découverte d'une nouvelle monnaie en 2002 ?",
    options: [
      "L'euro devient la monnaie officielle",
      "La crise financière",
      "Le Brexit",
    ],
    answer: "L'euro devient la monnaie officielle",
    explanation:
        "L'euro a été introduit comme monnaie officielle des pays de la zone euro en 2002.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement a été initié par des jeunes en 1968 en France ?",
    options: ["Mai 68", "Mai de la culture", "Mai social"],
    answer: "Mai 68",
    explanation:
        "Les événements de Mai 68 ont été un mouvement étudiant et ouvrier en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom de la première sonde envoyée sur Mars par les États-Unis ?",
    options: ["Mariner 4", "Voyager 1", "Mars Pathfinder"],
    answer: "Mariner 4",
    explanation:
        "La sonde Mariner 4 a été la première à transmettre des images de Mars en 1965.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom de l'accord de paix entre Israël et la Palestine signé en 1993 ?",
    options: ["Accord d'Oslo", "Accord de Camp David", "Accord de Madrid"],
    answer: "Accord d'Oslo",
    explanation:
        "L'Accord d'Oslo, signé en 1993, a jeté les bases de négociations entre Israël et la Palestine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement historique a eu lieu le 14 juillet 1789 en France ?",
    options: [
      "La prise de la Bastille",
      "La proclamation de la République",
      "L'élection de Louis XVI",
    ],
    answer: "La prise de la Bastille",
    explanation:
        "La prise de la Bastille est souvent considérée comme le début de la Révolution française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement artistique a émergé après la Seconde Guerre mondiale ?",
    options: ["Le surréalisme", "Le pop art", "L'impressionnisme"],
    answer: "Le pop art",
    explanation:
        "Le pop art a émergé dans les années 1950 et 1960, influencé par la culture populaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été élu président des États-Unis en 2008 ?",
    options: ["Barack Obama", "George W. Bush", "John McCain"],
    answer: "Barack Obama",
    explanation:
        "Barack Obama a été élu en 2008 et est devenu le premier président afro-américain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a remporté la Coupe du Monde de football en 1998 ?",
    options: ["France", "Brésil", "Allemagne"],
    answer: "France",
    explanation:
        "La France a remporté sa première Coupe du Monde en 1998, en battant le Brésil en finale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a eu lieu en France en 2005 et a entraîné des émeutes ?",
    options: [
      "Les émeutes de banlieue",
      "La réforme des retraites",
      "Les Jeux Olympiques",
    ],
    answer: "Les émeutes de banlieue",
    explanation:
        "Les émeutes de 2005 ont été déclenchées par la mort de deux adolescents dans une banlieue parisienne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel artiste a chanté 'Imagine' ?",
    options: ["John Lennon", "Paul McCartney", "David Bowie"],
    answer: "John Lennon",
    explanation:
        "'Imagine' est une chanson emblématique de John Lennon, sortie en 1971.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel traité a été signé pour établir l'Union Européenne ?",
    options: ["Traité de Maastricht", "Traité de Lisbonne", "Traité de Rome"],
    answer: "Traité de Maastricht",
    explanation:
        "Le Traité de Maastricht, signé en 1992, a établi l'Union Européenne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel artiste a réalisé la sculpture 'Le Penseur' ?",
    options: ["Auguste Rodin", "Henri Matisse", "Pablo Picasso"],
    answer: "Auguste Rodin",
    explanation:
        "'Le Penseur' est une sculpture célèbre d'Auguste Rodin, symbolisant la contemplation.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement est lié à la création des Nations Unies en 1945 ?",
    options: [
      "La fin de la Seconde Guerre mondiale",
      "La Guerre froide",
      "La décolonisation",
    ],
    answer: "La fin de la Seconde Guerre mondiale",
    explanation:
        "Les Nations Unies ont été créées en 1945 pour promouvoir la paix après la Seconde Guerre mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a remporté les Jeux Olympiques d'été en 2016 ?",
    options: ["Brésil", "États-Unis", "Chine"],
    answer: "Brésil",
    explanation:
        "Les Jeux Olympiques d'été de 2016 ont eu lieu à Rio de Janeiro, au Brésil.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel acte a été un déclencheur majeur de la guerre de Sécession aux États-Unis ?",
    options: ["L'esclavage", "Le droit de vote", "La taxation"],
    answer: "L'esclavage",
    explanation:
        "L'esclavage était une question centrale qui a conduit à la guerre de Sécession.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le nom du mouvement pacifiste mené par Gandhi ?",
    options: ["Satyagraha", "Hindouisme", "Non-violence"],
    answer: "Satyagraha",
    explanation:
        "Le Satyagraha est une doctrine de non-violence et de résistance passive développée par Gandhi.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a marqué l'invasion du Pôle Nord par des forces russes en 1985 ?",
    options: [
      "La découverte de nouvelles ressources",
      "La guerre froide",
      "La recherche scientifique",
    ],
    answer: "La guerre froide",
    explanation:
        "L'invasion du Pôle Nord par des forces russes a été un acte symbolique durant la guerre froide.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui était la première femme à obtenir un prix Nobel ?",
    options: ["Marie Curie", "Rosalind Franklin", "Ada Lovelace"],
    answer: "Marie Curie",
    explanation:
        "Marie Curie a été la première femme à recevoir un prix Nobel, en 1903.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a conduit à l'indépendance de l'Inde en 1947 ?",
    options: [
      "La Révolution de 1857",
      "La Seconde Guerre mondiale",
      "Le mouvement de non-coopération",
    ],
    answer: "Le mouvement de non-coopération",
    explanation:
        "Le mouvement de non-coopération a été un facteur clé qui a conduit à l'indépendance de l'Inde.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel acte législatif a été adopté aux États-Unis en 1964 pour interdire la discrimination raciale ?",
    options: ["Civil Rights Act", "Voting Rights Act", "Immigration Act"],
    answer: "Civil Rights Act",
    explanation:
        "Le Civil Rights Act de 1964 a interdit la discrimination raciale dans la plupart des domaines.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel artiste a peint 'La Nuit étoilée' ?",
    options: ["Vincent van Gogh", "Claude Monet", "Pablo Picasso"],
    answer: "Vincent van Gogh",
    explanation:
        "'La Nuit étoilée' est une célèbre peinture de Vincent van Gogh, réalisée en 1889.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a marqué le début de la Révolution russe en 1917 ?",
    options: [
      "La Révolution de Février",
      "La Révolution d'Octobre",
      "La guerre civile",
    ],
    answer: "La Révolution de Février",
    explanation:
        "La Révolution de Février a conduit à l'abdication du tsar Nicolas II.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel traité a été signé en 1919 pour établir la Société des Nations ?",
    options: ["Traité de Versailles", "Traité de Trianon", "Traité de Paris"],
    answer: "Traité de Versailles",
    explanation:
        "Le Traité de Versailles a établi la Société des Nations après la Première Guerre mondiale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle est la date de la déclaration de l'indépendance des États-Unis ?",
    options: ["4 juillet 1776", "1er janvier 1776", "14 juillet 1789"],
    answer: "4 juillet 1776",
    explanation:
        "La déclaration d'indépendance des États-Unis a été signée le 4 juillet 1776.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel traité a été signé en 1998 pour interdire les armes nucléaires ?",
    options: [
      "Traité de Non-Prolifération",
      "Accord de Paris",
      "Traité de Genève",
    ],
    answer: "Traité de Non-Prolifération",
    explanation:
        "Le Traité de Non-Prolifération a été créé pour promouvoir la paix et la sécurité internationale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a eu lieu à Tiananmen en 1989 ?",
    options: [
      "Manifestations pour la démocratie",
      "Attentats terroristes",
      "Guerre civile",
    ],
    answer: "Manifestations pour la démocratie",
    explanation:
        "Les manifestations de Tiananmen en 1989 étaient un appel à la démocratie et aux réformes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a obtenu  la souveraineté de Gibraltar en 1713 ?",
    options: ["Royaume-Uni", "Espagne", "Portugal"],
    answer: "Royaume-Uni",
    explanation:
        "Le Royaume-Uni a obtenu la souveraineté de Gibraltar par le traité d'Utrecht en 1713.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel espace a été le premier à être déclaré patrimoine mondial par l'UNESCO en 1978 ?",
    options: [
      "Parc national de Yellowstone",
      "Centre historique de Rome",
      "Pyramides d'Égypte",
    ],
    answer: "Centre historique de Rome",
    explanation:
        "Le Centre historique de Rome a été le premier site à entrer sur la liste du patrimoine mondial de l'UNESCO.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été le premier homme à marcher sur la Lune ?",
    options: ["Neil Armstrong", "Buzz Aldrin", "Yuri Gagarine"],
    answer: "Neil Armstrong",
    explanation:
        "Neil Armstrong a été le premier homme à marcher sur la Lune lors de la mission Apollo 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement historique est commémoré le 14 juillet en France ?",
    options: [
      "La Prise de la Bastille",
      "La Victoire de 1945",
      "La Révolution de 1848",
    ],
    answer: "La Prise de la Bastille",
    explanation:
        "La Prise de la Bastille en 1789 est un symbole de la Révolution française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été le premier à accueillir des JO d'hiver en 1924 ?",
    options: ["France", "États-Unis", "Canada"],
    answer: "France",
    explanation:
        "La France a accueilli les premiers Jeux olympiques d'hiver en 1924 à Chamonix.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a contribué à l'essor des droits civiques aux États-Unis dans les années 1960 ?",
    options: [
      "Le mouvement de déségrégation scolaire",
      "La signature du Civil Rights Act",
      "Le mouvement féministe",
    ],
    answer: "La signature du Civil Rights Act",
    explanation:
        "La signature du Civil Rights Act a été un moment clé dans le mouvement des droits civiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a été le déclencheur de la crise financière de 2008 ?",
    options: [
      "La faillite de Lehman Brothers",
      "L'éclatement de la bulle immobilière",
      "La crise des subprimes",
    ],
    answer: "La faillite de Lehman Brothers",
    explanation:
        "La faillite de Lehman Brothers en 2008 a précipité la crise financière mondiale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été le premier à dépénaliser l'homosexualité ?",
    options: ["France", "Pays-Bas", "Belgique"],
    answer: "Pays-Bas",
    explanation:
        "Les Pays-Bas ont été le premier pays à dépénaliser l'homosexualité en 1811.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a récemment adopté une nouvelle constitution en 2021 ?",
    options: ["France", "Chili", "Brésil"],
    answer: "Chili",
    explanation:
        "Le Chili a approuvé sa nouvelle constitution par référendum en 2021.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle entreprise a lancé le premier smartphone pliable en 2019 ?",
    options: ["Samsung", "Apple", "Huawei"],
    answer: "Samsung",
    explanation:
        "Samsung a lancé le Galaxy Fold, son premier smartphone pliable, en 2019.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement social a pris de l'ampleur en France en 2018 ?",
    options: ["Les Gilets jaunes", "Les Verts", "Les Blouses blanches"],
    answer: "Les Gilets jaunes",
    explanation:
        "Le mouvement des Gilets jaunes a émergé en France fin 2018 en réaction à la hausse des taxes sur le carburant.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement sportif a été reporté en 2020 en raison de la pandémie de COVID-19 ?",
    options: [
      "La Coupe du Monde de football",
      "Les Jeux Olympiques d'été",
      "Le Tour de France",
    ],
    answer: "Les Jeux Olympiques d'été",
    explanation:
        "Les Jeux Olympiques d'été de Tokyo ont été reportés de 2020 à 2021 à cause de la pandémie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a décidé de quitter l'Union européenne en 2016 ?",
    options: ["France", "Royaume-Uni", "Italie"],
    answer: "Royaume-Uni",
    explanation:
        "Le Royaume-Uni a voté pour quitter l'Union européenne lors du référendum de 2016, un événement connu sous le nom de Brexit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel prix Nobel a été attribué à Greta Thunberg en 2019 ?",
    options: ["Nobel de la paix", "Nobel de littérature", "Nobel de médecine"],
    answer: "Nobel de la paix",
    explanation:
        "Greta Thunberg a été nominée pour le prix Nobel de la paix en raison de son activisme climatique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel accord de paix a été signé entre Israël et les Émirats arabes unis en 2020 ?",
    options: [
      "Accord d'Oslo",
      "Accord de paix d'Abraham",
      "Accord de Camp David",
    ],
    answer: "Accord de paix d'Abraham",
    explanation:
        "L'Accord de paix d'Abraham a normalisé les relations entre Israël et les Émirats arabes unis en 2020.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement a lutté pour les droits civiques aux États-Unis dans les années 1960 ?",
    options: ["Black Lives Matter", "Suffragette", "American Revolution"],
    answer: "Black Lives Matter",
    explanation:
        "Le mouvement Black Lives Matter a été fondé pour lutter contre la violence policière et les injustices raciales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle qualité est souvent associée au journalisme d'investigation ?",
    options: ["Créativité", "Transparence", "Objectivité"],
    answer: "Objectivité",
    explanation:
        "L'objectivité est essentielle dans le journalisme d'investigation pour rapporter des faits de manière neutre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui est devenu président des États-Unis en janvier 2021 ?",
    options: ["Donald Trump", "Joe Biden", "Barack Obama"],
    answer: "Joe Biden",
    explanation:
        "Joe Biden a prêté serment en tant que 46e président des États-Unis en janvier 2021.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement environnemental a été fondé par Greta Thunberg ?",
    options: ["Youth for Climate", "Greenpeace", "Earth Day"],
    answer: "Youth for Climate",
    explanation:
        "Greta Thunberg a initié le mouvement Youth for Climate pour mobiliser les jeunes autour des enjeux climatiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a connu une crise migratoire majeure en 2015 ?",
    options: ["Syrie", "Allemagne", "France"],
    answer: "Syrie",
    explanation:
        "La guerre en Syrie a provoqué une importante crise migratoire, avec des millions de réfugiés cherchant asile en Europe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a marqué la chute du mur de Berlin ?",
    options: ["Guerre froide", "Réunification allemande", "Printemps arabe"],
    answer: "Réunification allemande",
    explanation:
        "La chute du mur de Berlin en 1989 a conduit à la réunification de l'Allemagne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été le premier à accorder le droit de vote aux femmes en 1893 ?",
    options: ["Nouvelle-Zélande", "Norvège", "Finlande"],
    answer: "Nouvelle-Zélande",
    explanation:
        "La Nouvelle-Zélande a été le premier pays à donner aux femmes le droit de vote en 1893.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la capitale de l'Union européenne ?",
    options: ["Bruxelles", "Paris", "Berlin"],
    answer: "Bruxelles",
    explanation:
        "Bruxelles est souvent considérée comme la capitale de l'Union européenne, abritant plusieurs institutions clés.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été élu président de la France en 2017 ?",
    options: ["François Hollande", "Emmanuel Macron", "Marine Le Pen"],
    answer: "Emmanuel Macron",
    explanation:
        "Emmanuel Macron a été élu président de la France lors des élections de 2017.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le principal objectif de l'Accord de Paris (2015) ?",
    options: [
      "Réduction des déchets",
      "Préservation de la biodiversité",
      "Lutte contre le changement climatique",
    ],
    answer: "Lutte contre le changement climatique",
    explanation:
        "L'Accord de Paris vise à limiter le réchauffement climatique à moins de 2°C par rapport aux niveaux préindustriels.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a causé le mouvement des « Spring Arabes » en 2011 ?",
    options: [
      "Un tremblement de terre",
      "Une révolution",
      "Une crise économique",
    ],
    answer: "Une révolution",
    explanation:
        "Les Printemps arabes ont été déclenchés par des mouvements révolutionnaires contre la corruption et pour la démocratie en 2011.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel médecin a découvert le vaccin contre la polio dans les années 1950 ?",
    options: ["Albert Sabin", "Jonas Salk", "Louis Pasteur"],
    answer: "Jonas Salk",
    explanation:
        "Jonas Salk a développé le premier vaccin contre la polio, permettant de réduire la maladie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la monnaie officielle du Royaume-Uni ?",
    options: ["Dollar", "Euro", "Livre sterling"],
    answer: "Livre sterling",
    explanation: "La monnaie officielle du Royaume-Uni est la livre sterling.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre mouvement pacifiste a été fondé par Martin Luther King ?",
    options: ["NAACP", "SCLC", "Black Panthers"],
    answer: "SCLC",
    explanation:
        "Le Southern Christian Leadership Conference (SCLC) a été fondé par Martin Luther King pour promouvoir les droits civiques par des moyens pacifiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a connu un changement climatique extrême qui a généré un des plus grands incendies de forêt en 2019 ?",
    options: ["Australie", "Brésil", "Canada"],
    answer: "Australie",
    explanation:
        "En 2019, l'Australie a été ravagée par des incendies de forêt à cause de conditions climatiques extrêmes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel traité a mis fin à la Première Guerre mondiale en 1919 ?",
    options: [
      "Traité de Versailles",
      "Traité de Paris",
      "Traité de Saint-Germain",
    ],
    answer: "Traité de Versailles",
    explanation:
        "Le Traité de Versailles a officiellement mis fin à la Première Guerre mondiale en 1919.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le principal défi environnemental du XXIe siècle ?",
    options: ["Déforestation", "Changement climatique", "Pollution de l'air"],
    answer: "Changement climatique",
    explanation:
        "Le changement climatique représente un défi majeur pour les sociétés contemporaines en raison de ses impacts globaux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement tragique a eu lieu aux États-Unis le 11 septembre 2001 ?",
    options: [
      "Une élection présidentielle",
      "Une attaque terroriste",
      "Un tremblement de terre",
    ],
    answer: "Une attaque terroriste",
    explanation:
        "Le 11 septembre 2001, des attaques terroristes ont eu lieu sur le sol américain, marquant l'histoire contemporaine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qu'est-ce que le CETA, signé en 2016 ?",
    options: ["Accord économique", "Accord climatique", "Accord migratoire"],
    answer: "Accord économique",
    explanation:
        "Le CETA est un accord économique entre le Canada et l'Union européenne, visant à réduire les barrières commerciales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel traité international vise à protéger la biodiversité à l'échelle mondiale ?",
    options: ["Convention de Rio", "Accord de Paris", "Protocol de Kyoto"],
    answer: "Convention de Rio",
    explanation:
        "La Convention de Rio, signée en 1992, a pour objectif de protéger la biodiversité mondiale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre mouvement a eu pour slogan : \"Je ne peux pas respirer\" ?",
    options: ["MeToo", "Black Lives Matter", "Occupy Wall Street"],
    answer: "Black Lives Matter",
    explanation:
        "Le slogan \"Je ne peux pas respirer\" a été utilisé par le mouvement Black Lives Matter pour protester contre les violences policières.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel chef d'État français a été particulièrement associé à la politique de la décentralisation ?",
    options: ["Jacques Chirac", "François Mitterrand", "Emmanuel Macron"],
    answer: "François Mitterrand",
    explanation:
        "François Mitterrand est connu pour avoir lancé une politique de décentralisation en France dans les années 1980.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a remporté la Coupe du Monde de football en 2018 ?",
    options: ["France", "Brésil", "Allemagne"],
    answer: "France",
    explanation:
        "La France a remporté la Coupe du Monde de football en 2018, battant la Croatie en finale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle plateforme de médias sociaux a connu une forte montée en popularité pendant la pandémie de COVID-19 ?",
    options: ["Facebook", "TikTok", "Twitter"],
    answer: "TikTok",
    explanation:
        "TikTok a connu une hausse significative de l'utilisation durant la pandémie de COVID-19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a prononcé le discours \"I Have a Dream\" en 1963 ?",
    options: ["Malcolm X", "Martin Luther King Jr.", "Rosa Parks"],
    answer: "Martin Luther King Jr.",
    explanation:
        "Martin Luther King Jr. a prononcé son célèbre discours \"I Have a Dream\" lors de la Marche sur Washington en 1963.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel incident a conduit à la création de l'OTAN en 1949 ?",
    options: ["Guerre de Corée", "Guerre froide", "Crise de Cuba"],
    answer: "Guerre froide",
    explanation:
        "L'OTAN a été fondée en 1949 en réponse aux tensions de la guerre froide entre l'Est et l'Ouest.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a récemment connu des manifestations pour la démocratie en 2021 ?",
    options: ["Biélorussie", "Russie", "Chine"],
    answer: "Biélorussie",
    explanation:
        "Des manifestations massives pour la démocratie ont eu lieu en Biélorussie en 2021 après une élection contestée.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel phénomène naturel a fortement touché le Japon en mars 2011 ?",
    options: ["Tsunami", "Ouragan", "Inondation"],
    answer: "Tsunami",
    explanation:
        "Le tsunami de 2011 a été provoqué par un tremblement de terre au large des côtes japonaises.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été le premier à légaliser le mariage entre personnes de même sexe ?",
    options: ["Pays-Bas", "Canada", "Suède"],
    answer: "Pays-Bas",
    explanation:
        "Les Pays-Bas sont devenus le premier pays au monde à légaliser le mariage homosexuel en 2001.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement de réforme politique a vu le jour dans les années 2010 en Europe ?",
    options: ["Indignés", "Occupy Wall Street", "Printemps arabe"],
    answer: "Indignés",
    explanation:
        "Le mouvement des Indignés a émergé en Espagne en 2011, prônant la démocratie et la justice sociale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été le théâtre des événements de Tiananmen en 1989 ?",
    options: ["Chine", "Vietnam", "Corée du Sud"],
    answer: "Chine",
    explanation:
        "Les événements de Tiananmen en 1989 en Chine ont été une répression violente des manifestations pour la démocratie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel traité a été signé pour établir l'Union européenne en 1993 ?",
    options: ["Traité de Maastricht", "Traité de Rome", "Traité de Lisbonne"],
    answer: "Traité de Maastricht",
    explanation:
        "Le Traité de Maastricht, signé en 1992, a créé l'Union européenne en 1993.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a été déclenché par une crise financière en 2008 ?",
    options: ["Printemps arabe", "Crise de la dette", "Récession mondiale"],
    answer: "Récession mondiale",
    explanation:
        "La crise financière de 2008 a conduit à une récession mondiale, affectant de nombreux pays.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel scientifique a été reconnu pour ses travaux sur la relativité ?",
    options: ["Isaac Newton", "Albert Einstein", "Galilée"],
    answer: "Albert Einstein",
    explanation:
        "Albert Einstein est célèbre pour sa théorie de la relativité, révolutionnant la physique moderne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement social a émergé en réponse à la violence policière aux États-Unis en 2013 ?",
    options: ["Occupy Wall Street", "Black Lives Matter", "Tea Party"],
    answer: "Black Lives Matter",
    explanation:
        "Le mouvement Black Lives Matter a été fondé en 2013 pour lutter contre la violence policière et les injustices raciales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom du système de santé universel établi au Royaume-Uni ?",
    options: ["NHS", "Medicare", "SSN"],
    answer: "NHS",
    explanation:
        "Le NHS (National Health Service) est le système de santé universel du Royaume-Uni, fondé en 1948.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel président américain a aboli l'esclavage ?",
    options: ["George Washington", "Abraham Lincoln", "Thomas Jefferson"],
    answer: "Abraham Lincoln",
    explanation:
        "Abraham Lincoln a aboli l'esclavage aux États-Unis avec la Proclamation d'émancipation en 1863.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été le premier à envoyer un homme dans l'espace ?",
    options: ["États-Unis", "Russie", "Chine"],
    answer: "Russie",
    explanation:
        "La Russie, alors Union soviétique, a été le premier pays à envoyer un homme dans l'espace avec Youri Gagarine en 1961.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement a pour objectif de sensibiliser à la lutte contre le racisme et les inégalités en 2019 ?",
    options: ["MeToo", "Black Lives Matter", "Greenpeace"],
    answer: "Black Lives Matter",
    explanation:
        "Black Lives Matter a été créé pour lutter contre les inégalités raciales et sensibiliser à la violence policière.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom du célèbre réseau social lancé en 2004 par Mark Zuckerberg ?",
    options: ["Instagram", "Twitter", "Facebook"],
    answer: "Facebook",
    explanation:
        "Facebook a été créé en 2004 par Mark Zuckerberg et est devenu le réseau social le plus utilisé au monde.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a organisé la Coupe du Monde de football en 1998 ?",
    options: ["Brésil", "France", "Allemagne"],
    answer: "France",
    explanation:
        "La France a accueilli la Coupe du Monde de football en 1998 et l'a également remportée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est l'objectif principal du Forum économique mondial ?",
    options: [
      "Promouvoir l'égalité des sexes",
      "Favoriser la coopération économique mondiale",
      "Développer les technologies vertes",
    ],
    answer: "Favoriser la coopération économique mondiale",
    explanation:
        "Le Forum économique mondial vise à améliorer la coopération économique mondiale et à aborder les enjeux mondiaux.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle ville a été le site des attentats du 11 septembre 2001 ?",
    options: ["Washington D.C.", "New York", "Los Angeles"],
    answer: "New York",
    explanation:
        "Les attentats du 11 septembre 2001 ont principalement touché la ville de New York, avec la destruction des tours jumelles.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement marquant a eu lieu le 11 septembre 2001 ?",
    options: [
      "Un tremblement de terre à San Francisco",
      "Des attentats à New York",
      "Une élection présidentielle aux États-Unis",
    ],
    answer: "Des attentats à New York",
    explanation:
        "Les attentats du 11 septembre 2001 ont ciblé les tours du World Trade Center à New York.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été le premier président afro-américain des États-Unis ?",
    options: ["George W. Bush", "Barack Obama", "Bill Clinton"],
    answer: "Barack Obama",
    explanation: "Barack Obama a été élu président des États-Unis en 2008.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la capitale de l'Égypte ?",
    options: ["Le Caire", "Tunis", "Rabat"],
    answer: "Le Caire",
    explanation: "Le Caire est la capitale et la plus grande ville d'Égypte.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a marqué la chute du mur de Berlin ?",
    options: [
      "La guerre froide",
      "La réunification allemande",
      "La première guerre mondiale",
    ],
    answer: "La réunification allemande",
    explanation:
        "Le mur de Berlin est tombé en 1989, menant à la réunification de l'Allemagne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement social a eu lieu en 1963 aux États-Unis ?",
    options: [
      "La marche pour les droits civiques",
      "Le mouvement hippie",
      "Les manifestations anti-guerre",
    ],
    answer: "La marche pour les droits civiques",
    explanation:
        "La marche de 1963 a été un tournant pour les droits civiques aux États-Unis.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel traité a mis fin à la Première Guerre mondiale ?",
    options: ["Traité de Versailles", "Traité de Trianon", "Traité de Paris"],
    answer: "Traité de Versailles",
    explanation:
        "Le traité de Versailles a été signé en 1919 pour mettre fin à la Première Guerre mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel virus est responsable de la pandémie de 2020 ?",
    options: ["H1N1", "COVID-19", "Ebola"],
    answer: "COVID-19",
    explanation:
        "Le COVID-19 est un coronavirus identifié pour la première fois en 2019.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a remporté le prix Nobel de la paix en 2009 ?",
    options: ["Nelson Mandela", "Barack Obama", "Malala Yousafzai"],
    answer: "Barack Obama",
    explanation:
        "Barack Obama a reçu le prix Nobel de la paix pour ses efforts en diplomatie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la monnaie utilisée au Japon ?",
    options: ["Yen", "Won", "Rupee"],
    answer: "Yen",
    explanation: "Le yen japonais est la monnaie officielle du Japon.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement climatique a eu lieu en 2004 en Asie du Sud-Est ?",
    options: ["Un ouragan", "Un tsunami", "Une sécheresse"],
    answer: "Un tsunami",
    explanation:
        "Un tsunami dévastateur a frappé la région après un tremblement de terre sous-marin.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été le berceau de la démocratie moderne ?",
    options: ["France", "Grèce", "Royaume-Uni"],
    answer: "Grèce",
    explanation:
        "La Grèce est souvent considérée comme le berceau de la démocratie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a écrit \"Les Misérables\" ?",
    options: ["Gustave Flaubert", "Victor Hugo", "Émile Zola"],
    answer: "Victor Hugo",
    explanation: "Victor Hugo a écrit \"Les Misérables\", publié en 1862.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le plus grand océan du monde ?",
    options: ["Atlantique", "Pacifique", "Indien"],
    answer: "Pacifique",
    explanation: "L'océan Pacifique est le plus vaste des océans de la Terre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été la première femme à voyager dans l'espace ?",
    options: ["Valentina Terechkova", "Sally Ride", "Mae Jemison"],
    answer: "Valentina Terechkova",
    explanation:
        "Valentina Terechkova a été la première femme à voyager dans l'espace en 1963.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom du mouvement artistique né au début du 20e siècle ?",
    options: ["Surréalisme", "Cubisme", "Impressionnisme"],
    answer: "Cubisme",
    explanation:
        "Le cubisme, développé par Picasso et Braque, a bouleversé les conventions artistiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a décidé de sortir de l'Union européenne en 2016 ?",
    options: ["Royaume-Uni", "France", "Allemagne"],
    answer: "Royaume-Uni",
    explanation:
        "Le référendum de 2016 a conduit à la décision du Royaume-Uni de quitter l'UE.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement a lutté pour les droits des personnes LGBTQ+ ?",
    options: [
      "Le mouvement féministe",
      "Le mouvement des droits civiques",
      "Le mouvement LGBT",
    ],
    answer: "Le mouvement LGBT",
    explanation:
        "Le mouvement LGBT milite pour les droits des personnes lesbiennes, gays, bisexuelles et transgenres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le sommet le plus haut du monde ?",
    options: ["K2", "Mont Blanc", "Everest"],
    answer: "Everest",
    explanation:
        "Le mont Everest est le sommet le plus élevé de la planète, culminant à 8 848 mètres.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est l'auteur de \"À la recherche du temps perdu\" ?",
    options: ["Flaubert", "Proust", "Hugo"],
    answer: "Proust",
    explanation:
        "Marcel Proust est l'auteur du célèbre roman \"À la recherche du temps perdu\".",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le principal organe législatif de la France ?",
    options: [
      "L'Assemblée nationale",
      "Le Sénat",
      "Le Conseil constitutionnel",
    ],
    answer: "L'Assemblée nationale",
    explanation:
        "L'Assemblée nationale est l'organe législatif principal de la France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le délai de révision du code de la route en France ?",
    options: ["5 ans", "10 ans", "3 ans"],
    answer: "10 ans",
    explanation: "Le code de la route en France est révisé tous les 10 ans.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la population mondiale estimée en 2021 ?",
    options: ["7 milliards", "8 milliards", "6 milliards"],
    answer: "7 milliards",
    explanation:
        "En 2021, la population mondiale était estimée à environ 7,8 milliards.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays est connu pour avoir inventé le papier ?",
    options: ["Chine", "Égypte", "Mésopotamie"],
    answer: "Chine",
    explanation: "La Chine a inventé le papier au cours de la dynastie Han.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement artistique a émergé dans les années 1960 ?",
    options: ["Expressionnisme", "Pop Art", "Romantisme"],
    answer: "Pop Art",
    explanation:
        "Le Pop Art a émergé dans les années 1960, célébrant la culture populaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le pays d'origine du chocolat ?",
    options: ["Mexique", "Belgique", "Suisse"],
    answer: "Mexique",
    explanation:
        "Le chocolat a été découvert et consommé par les civilisations anciennes du Mexique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle invention a révolutionné les communications au 19ème siècle ?",
    options: ["Le télégraphe", "Le téléphone", "La radio"],
    answer: "Le télégraphe",
    explanation:
        "Le télégraphe a permis la transmission rapide d'informations sur de longues distances.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel était le nom du mouvement de la contre-culture des années 1960 ?",
    options: ["Beatniks", "Punk", "Hippie"],
    answer: "Hippie",
    explanation:
        "Le mouvement hippie prônait l'amour, la paix et la libération sociale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la langue officielle du Brésil ?",
    options: ["Espagnol", "Anglais", "Portugais"],
    answer: "Portugais",
    explanation: "Le portugais est la langue officielle du Brésil.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement déclencheur a conduit à la Révolution française ?",
    options: [
      "La prise de la Bastille",
      "L'assassinat de Louis XVI",
      "La déclaration des droits de l'homme",
    ],
    answer: "La prise de la Bastille",
    explanation:
        "La prise de la Bastille le 14 juillet 1789 est considérée comme le début de la Révolution française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle maladie a été éradiquée grâce à la vaccination ?",
    options: ["La poliomyélite", "La variole", "La tuberculose"],
    answer: "La variole",
    explanation:
        "La variole a été déclarée éradiquée grâce à un programme de vaccination mondial.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel dispositif a été créé pour protéger les droits des travailleurs ?",
    options: ["Les syndicats", "Les assurances", "La sécurité sociale"],
    answer: "Les syndicats",
    explanation:
        "Les syndicats ont été créés pour défendre les droits et intérêts des travailleurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le symbole du mouvement écologiste ?",
    options: ["Un arbre", "Une fleur", "Un globe terrestre"],
    answer: "Un globe terrestre",
    explanation:
        "Le globe terrestre est souvent utilisé pour représenter la protection de l'environnement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a écrit \"Le Petit Prince\" ?",
    options: ["Antoine de Saint-Exupéry", "Jules Verne", "Henri Troyat"],
    answer: "Antoine de Saint-Exupéry",
    explanation:
        "Antoine de Saint-Exupéry est l'auteur du célèbre livre \"Le Petit Prince\".",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement a été lancé pour défendre l'égalité raciale ?",
    options: ["Black Lives Matter", "Me Too", "Fridays for Future"],
    answer: "Black Lives Matter",
    explanation:
        "Black Lives Matter lutte contre le racisme et la violence policière envers les Afro-Américains.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel personnage historique est connu pour avoir dit 'Je fais un rêve' ?",
    options: ["Rosa Parks", "Martin Luther King Jr.", "Malcolm X"],
    answer: "Martin Luther King Jr.",
    explanation:
        "Martin Luther King Jr. a prononcé ce célèbre discours lors de la marche de 1963.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel phénomène naturel est lié au changement climatique ?",
    options: [
      "La fonte des glaciers",
      "Les tempêtes de neige",
      "Les vagues de chaleur",
    ],
    answer: "La fonte des glaciers",
    explanation:
        "La fonte des glaciers est un effet direct et visible du changement climatique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle organisation internationale a pour but de maintenir la paix ?",
    options: ["L'OTAN", "L'ONU", "L'UE"],
    answer: "L'ONU",
    explanation:
        "L'ONU a été fondée pour maintenir la paix et la sécurité internationales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel célèbre tableau représente une femme souriante ?",
    options: ["La Nuit étoilée", "La Joconde", "Le Cri"],
    answer: "La Joconde",
    explanation:
        "La Joconde, peinte par Léonard de Vinci, est célèbre pour son sourire mystérieux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a connu le Printemps arabe en 2011 ?",
    options: ["Tunisie", "Syrie", "Égypte"],
    answer: "Tunisie",
    explanation:
        "La Tunisie est le pays d'origine du Printemps arabe, qui a suscité des mouvements de protestation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom de la première femme à avoir été élue présidente d'un pays africain ?",
    options: ["Ellen Johnson Sirleaf", "Wangari Maathai", "Graça Machel"],
    answer: "Ellen Johnson Sirleaf",
    explanation:
        "Ellen Johnson Sirleaf a été élue présidente du Libéria en 2006.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel système politique est basé sur la séparation des pouvoirs ?",
    options: ["Dictature", "Démocratie", "Monarchie"],
    answer: "Démocratie",
    explanation:
        "La démocratie repose sur la séparation des pouvoirs législatif, exécutif et judiciaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle invention a permis de doubler la vitesse de communication dans l'histoire ?",
    options: ["La machine à écrire", "Le téléphone", "L'Internet"],
    answer: "L'Internet",
    explanation:
        "L'Internet a révolutionné la communication, permettant l'échange instantané d'informations.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a peint le plafond de la chapelle Sixtine ?",
    options: ["Raphaël", "Michel-Ange", "Botticelli"],
    answer: "Michel-Ange",
    explanation:
        "Michel-Ange a réalisé le célèbre plafond de la chapelle Sixtine au Vatican.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a conduit à la fin de l'apartheid en Afrique du Sud ?",
    options: [
      "Les élections de 1994",
      "Les émeutes de Soweto",
      "La libération de Mandela",
    ],
    answer: "La libération de Mandela",
    explanation:
        "La libération de Nelson Mandela en 1990 a été un tournant dans la lutte contre l'apartheid.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays est connu pour ses tulipes et ses moulins ?",
    options: ["Belgique", "Pays-Bas", "Allemagne"],
    answer: "Pays-Bas",
    explanation:
        "Les Pays-Bas sont célèbres pour leurs tulipes et leurs moulins à vent.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui est l'auteur du roman \"Les Trois Mousquetaires\" ?",
    options: ["Victor Hugo", "Alexandre Dumas", "Gustave Flaubert"],
    answer: "Alexandre Dumas",
    explanation:
        "Alexandre Dumas est l'auteur du roman classique \"Les Trois Mousquetaires\".",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le principal défi environnemental actuel ?",
    options: [
      "La déforestation",
      "L'extinction des espèces",
      "Le changement climatique",
    ],
    answer: "Le changement climatique",
    explanation:
        "Le changement climatique est considéré comme le plus grand défi environnemental de notre époque.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement historique a eu lieu en 1789 ?",
    options: [
      "L'abolition de l'esclavage",
      "Le début de la Révolution française",
      "La découverte de l'Amérique",
    ],
    answer: "Le début de la Révolution française",
    explanation:
        "La Révolution française a débuté en 1789, marquant un changement majeur en France.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a remporté le prix Nobel de la paix en 2020 ?",
    options: [
      "Le Programme alimentaire mondial (PAM)",
      "Boris Johnson",
      "Angela Merkel",
    ],
    answer: "Le Programme alimentaire mondial (PAM)",
    explanation:
        "Le PAM a été récompensé pour ses efforts dans la lutte contre la faim dans le monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement mondial a été déclaré en mars 2020 par l'OMS ?",
    options: [
      "Une pandémie de grippe",
      "Une pandémie de COVID-19",
      "Une crise sanitaire mondiale",
    ],
    answer: "Une pandémie de COVID-19",
    explanation:
        "L'Organisation mondiale de la santé a déclaré la COVID-19 comme pandémie le 11 mars 2020.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été le premier président noir des États-Unis ?",
    options: ["George Washington", "Barack Obama", "Abraham Lincoln"],
    answer: "Barack Obama",
    explanation:
        "Barack Obama a été élu président des États-Unis en 2008, devenant le premier président afro-américain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a quitté l'Union européenne en 2020 ?",
    options: ["France", "Royaume-Uni", "Allemagne"],
    answer: "Royaume-Uni",
    explanation:
        "Le Royaume-Uni a officiellement quitté l'Union européenne le 31 janvier 2020, un événement connu sous le nom de Brexit.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Qui est l'auteur du livre 'Sapiens: Une brève histoire de l'humanité'?",
    options: ["Yuval Noah Harari", "Jared Diamond", "Steven Pinker"],
    answer: "Yuval Noah Harari",
    explanation:
        "Yuval Noah Harari est l'auteur de 'Sapiens', qui explore l'histoire humaine depuis l'ère préhistorique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quels mouvements ont eu lieu en 2020 pour dénoncer les violences raciales ?",
    options: ["Les Gilets jaunes", "Black Lives Matter", "Me Too"],
    answer: "Black Lives Matter",
    explanation:
        "Le mouvement Black Lives Matter a gagné en visibilité en 2020, suite à la mort de George Floyd aux États-Unis.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a eu lieu le 11 septembre 2001 ?",
    options: [
      "Un tremblement de terre à San Francisco",
      "Des attaques terroristes aux États-Unis",
      "L'élection d'un nouveau président",
    ],
    answer: "Des attaques terroristes aux États-Unis",
    explanation:
        "Le 11 septembre 2001, des attaques terroristes ont ciblé les tours jumelles du World Trade Center à New York.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement féministe a pris de l'ampleur en 2017 ?",
    options: ["Time's Up", "Me Too", "Women March"],
    answer: "Me Too",
    explanation:
        "Le mouvement Me Too a gagné en notoriété en 2017, dénonçant les abus et le harcèlement sexuel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été le premier à légaliser le mariage gay ?",
    options: ["Pays-Bas", "Canada", "Espagne"],
    answer: "Pays-Bas",
    explanation:
        "Les Pays-Bas ont été le premier pays à légaliser le mariage entre personnes de même sexe en 2001.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle catastrophe naturelle a frappé Haïti en 2010 ?",
    options: ["Un ouragan", "Un tremblement de terre", "Un tsunami"],
    answer: "Un tremblement de terre",
    explanation:
        "Un tremblement de terre dévastateur a frappé Haïti le 12 janvier 2010, causant de nombreuses destructions.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre scandale a éclaté dans le football mondial en 2015 ?",
    options: ["FIFA Gate", "Panama Papers", "L’affaire Toto Riina"],
    answer: "FIFA Gate",
    explanation:
        "Le scandale FIFA Gate a révélé des fraudes et des corruptions au sein de la Fédération internationale de football.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le nom du virus responsable de la pandémie de 2020 ?",
    options: ["SARS-CoV-2", "MERS-CoV", "EBOLA"],
    answer: "SARS-CoV-2",
    explanation:
        "Le virus SARS-CoV-2 est responsable de la maladie COVID-19, qui a provoqué une pandémie mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a remporté l'élection présidentielle française de 2017 ?",
    options: ["Marine Le Pen", "François Hollande", "Emmanuel Macron"],
    answer: "Emmanuel Macron",
    explanation:
        "Emmanuel Macron a été élu président de la République française en mai 2017.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle révolution est souvent associée à la chute du mur de Berlin en 1989 ?",
    options: [
      "Révolution de velours",
      "Révolution iranienne",
      "Révolution d'octobre",
    ],
    answer: "Révolution de velours",
    explanation:
        "La chute du mur de Berlin a été un moment symbolique de la fin de la guerre froide et a été précédée par la Révolution de velours en Tchécoslovaquie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle personnalité a été à la tête de l'Union soviétique de 1985 à 1991 ?",
    options: ["Mikhaïl Gorbatchev", "Leonid Brejnev", "Vladimir Poutine"],
    answer: "Mikhaïl Gorbatchev",
    explanation:
        "Mikhaïl Gorbatchev a été le dernier dirigeant de l'Union soviétique, connu pour ses réformes de glasnost et perestroïka.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement populaire a eu lieu en France en mai 1968 ?",
    options: [
      "Les Gilets jaunes",
      "Les mouvements étudiants",
      "La révolution française",
    ],
    answer: "Les mouvements étudiants",
    explanation:
        "Les mouvements étudiants de mai 1968 en France ont été marqués par des grèves et des manifestations contre le gouvernement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a connu une guerre civile de 2011 à 2020 ?",
    options: ["Syrie", "Libye", "Yémen"],
    answer: "Syrie",
    explanation:
        "La guerre civile en Syrie a éclaté en 2011 et a engendré de graves crises humanitaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel traité a été signé après la Première Guerre mondiale ?",
    options: [
      "Traité de Versailles",
      "Traité de Saint-Germain",
      "Traité de Trianon",
    ],
    answer: "Traité de Versailles",
    explanation:
        "Le traité de Versailles, signé en 1919, a mis fin à la Première Guerre mondiale et redessiné les frontières de l'Europe.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement pour l'environnement a été lancé par Greta Thunberg ?",
    options: ["Fridays for Future", "Greenpeace", "Extinction Rebellion"],
    answer: "Fridays for Future",
    explanation:
        "Greta Thunberg a initié le mouvement Fridays for Future pour sensibiliser à la crise climatique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a obtenu son indépendance de l'URSS en 1991 ?",
    options: ["Estonie", "Pologne", "République tchèque"],
    answer: "Estonie",
    explanation:
        "L'Estonie a déclaré son indépendance de l'Union soviétique le 20 août 1991, rejoignant plus tard l'Union européenne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement historique a marqué le début de la Révolution française ?",
    options: [
      "La prise de la Bastille",
      "La Déclaration des droits de l'homme",
      "La fuite de Varennes",
    ],
    answer: "La prise de la Bastille",
    explanation:
        "La prise de la Bastille le 14 juillet 1789 symbolise le début de la Révolution française.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel président américain a été assassiné en 1963 ?",
    options: ["John F. Kennedy", "Richard Nixon", "Lyndon B. Johnson"],
    answer: "John F. Kennedy",
    explanation:
        "John F. Kennedy a été assassiné à Dallas, Texas, le 22 novembre 1963.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel traité a établi l'Union européenne en 1993 ?",
    options: ["Traité de Maastricht", "Traité de Lisbonne", "Traité de Rome"],
    answer: "Traité de Maastricht",
    explanation:
        "Le traité de Maastricht, signé en 1992, a créé l'Union européenne et a introduit l'euro comme monnaie commune.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel conflit a opposé l'Irak aux États-Unis en 2003 ?",
    options: ["Guerre du Golfe", "Guerre en Afghanistan", "Guerre d'Irak"],
    answer: "Guerre d'Irak",
    explanation:
        "La guerre d'Irak, commencée en 2003, a été déclenchée par l'invasion de l'Irak par les États-Unis.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement de protestation a eu lieu à Hong Kong en 2019 ?",
    options: [
      "Les manifestations de Hong Kong",
      "La Révolution de velours",
      "Les manifestations de Tiananmen",
    ],
    answer: "Les manifestations de Hong Kong",
    explanation:
        "Des millions de manifestants à Hong Kong ont protesté en 2019 contre une loi d'extradition controversée.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle guerre a abouti à la création d'Israël en 1948 ?",
    options: [
      "Guerre d'Indépendance d'Israël",
      "Guerre des Six Jours",
      "Guerre de Yom Kippour",
    ],
    answer: "Guerre d'Indépendance d'Israël",
    explanation:
        "La guerre d'Indépendance d'Israël a eu lieu en 1948, conduisant à la création de l'État d'Israël.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel président français a été élu en 2002 après avoir été réélu en 1995 ?",
    options: ["Jacques Chirac", "François Mitterrand", "Nicolas Sarkozy"],
    answer: "Jacques Chirac",
    explanation:
        "Jacques Chirac a été réélu président de la République française en 2002, après son premier mandat commencé en 1995.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement artistique et intellectuel a pris naissance à Paris dans les années 1920 ?",
    options: ["Le surréalisme", "Le cubisme", "Le dadaïsme"],
    answer: "Le surréalisme",
    explanation:
        "Le surréalisme a émergé à Paris dans les années 1920, cherchant à libérer l'imaginaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a connu un coup d'État militaire survenu en 1973 ?",
    options: ["Chili", "Argentine", "Uruguay"],
    answer: "Chili",
    explanation:
        "Le coup d'État au Chili en 1973 a renversé le président Salvador Allende et a instauré une dictature militaire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle crise financière majeure a eu lieu en 2008 ?",
    options: [
      "La crise des subprimes",
      "La bulle Internet",
      "La crise du pétrole",
    ],
    answer: "La crise des subprimes",
    explanation:
        "La crise des subprimes de 2008 a été déclenchée par l'effondrement du marché immobilier aux États-Unis.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement de libération a été fondé par Nelson Mandela ?",
    options: [
      "L'ANC",
      "Le Congrès national africain",
      "Le Parti communiste sud-africain",
    ],
    answer: "L'ANC",
    explanation:
        "L'ANC, ou Congrès national africain, a été fondé pour lutter contre l'apartheid en Afrique du Sud.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays d'Afrique a organisé la Coupe du Monde de football en 2010 ?",
    options: ["Ghana", "Afrique du Sud", "Nigeria"],
    answer: "Afrique du Sud",
    explanation:
        "L'Afrique du Sud a accueilli la Coupe du Monde de football en 2010, étant le premier pays africain à le faire.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement social a eu lieu en France en 1968 pour revendiquer plus de droits économiques et sociaux ?",
    options: ["Les Gilets jaunes", "Mai 68", "Les manifestations de 2010"],
    answer: "Mai 68",
    explanation:
        "Mai 68 a marqué un moment de contestation sociale et étudiante en France pour des réformes économiques et sociales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Que signifie l'acronyme 'OTAN' ?",
    options: [
      "Organisation Traité Atlantique Nord",
      "Organisation du Traité de l'Atlantique Nord",
      "Organisation du Traité Atlantique Nord",
    ],
    answer: "Organisation du Traité de l'Atlantique Nord",
    explanation:
        "L'OTAN est une alliance militaire formée en 1949 pour garantir la sécurité collective de ses membres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a marqué la fin de la Seconde Guerre mondiale en Europe ?",
    options: [
      "La chute du mur de Berlin",
      "Le jour J",
      "La capitulation de l'Allemagne",
    ],
    answer: "La capitulation de l'Allemagne",
    explanation:
        "La capitulation de l'Allemagne le 8 mai 1945 a marqué la fin de la Seconde Guerre mondiale en Europe.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le nom du système de santé britannique ?",
    options: ["NHS", "Hôpital de Londres", "Healthcare UK"],
    answer: "NHS",
    explanation:
        "Le NHS, ou National Health Service, est le système de santé britannique, fondé en 1948.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom du traité qui a mis fin à la guerre de 1812 entre les États-Unis et le Royaume-Uni ?",
    options: ["Traité de Paris", "Traité de Ghent", "Traité de Versailles"],
    answer: "Traité de Ghent",
    explanation:
        "Le traité de Ghent a été signé en 1814 pour mettre fin à la guerre de 1812 entre les États-Unis et le Royaume-Uni.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a accueilli la première Coupe d'Afrique des Nations en 1957 ?",
    options: ["Soudan", "Egypte", "Ghana"],
    answer: "Egypte",
    explanation:
        "L'Egypte a accueilli la première Coupe d'Afrique des Nations en 1957.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel président a été destitué par un coup d'État en 1991 en Équateur ?",
    options: ["Jamil Mahuad", "Sixto Durán Ballén", "Gustavo Noboa"],
    answer: "Jamil Mahuad",
    explanation:
        "Jamil Mahuad a été destitué par un coup d'État militaire en 2001 pendant une grave crise économique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel rapport a été publié en 2018 par le GIEC ?",
    options: [
      "Un rapport sur la biodiversité",
      "Un rapport sur le climat",
      "Un rapport sur la pollution",
    ],
    answer: "Un rapport sur le climat",
    explanation:
        "Le rapport du GIEC de 2018 a mis en lumière l'urgence d'agir contre le changement climatique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel a été le principal objectif des accords d'Oslo en 1993 ?",
    options: [
      "La paix entre Israël et la Palestine",
      "La création d'un État palestinien",
      "Le retrait israélien du Liban",
    ],
    answer: "La paix entre Israël et la Palestine",
    explanation:
        "Les accords d'Oslo visaient à établir des fondations pour une paix durable entre Israël et la Palestine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel évènement important a eu lieu en Russie en 1991 ?",
    options: [
      "La chute du mur de Berlin",
      "La dislocation de l'Union soviétique",
      "La création de la CEI",
    ],
    answer: "La dislocation de l'Union soviétique",
    explanation:
        "La dislocation de l'Union soviétique en 1991 a conduit à l'établissement de la Fédération de Russie en tant qu'État indépendant.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel acteur a remporté l'oscar du meilleur acteur en 2020 ?",
    options: ["Joaquin Phoenix", "Leonardo DiCaprio", "Brad Pitt"],
    answer: "Joaquin Phoenix",
    explanation:
        "Joaquin Phoenix a remporté l'oscar du meilleur acteur pour son rôle dans 'Joker' aux Oscars de 2020.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a accueilli les Jeux Olympiques d'été de 2008 ?",
    options: ["Londres", "Pékin", "Athènes"],
    answer: "Pékin",
    explanation:
        "Les Jeux Olympiques d'été de 2008 ont eu lieu à Pékin, en Chine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle invention a été révélée au public par Alexander Graham Bell en 1876 ?",
    options: ["Le téléphone", "Le gramophone", "Le télégraphe"],
    answer: "Le téléphone",
    explanation:
        "Alexander Graham Bell a obtenu le brevet du téléphone en 1876, révolutionnant la communication.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays d'Asie célèbre son Nouvel An avec le festival de Songkran ?",
    options: ["Thaïlande", "Vietnam", "Chine"],
    answer: "Thaïlande",
    explanation:
        "Le festival de Songkran, qui célèbre le Nouvel An thaïlandais, a lieu en avril et implique des jeux d'eau.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a connu une révolution en 1989 pour mettre fin au régime communiste ?",
    options: ["Tchécoslovaquie", "Hongrie", "Pologne"],
    answer: "Tchécoslovaquie",
    explanation:
        "La Révolution de velours en Tchécoslovaquie a abouti à la fin du régime communiste en 1989.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le nom du mouvement de protestation en Iran en 2009 ?",
    options: [
      "Les manifestations vertes",
      "Les manifestations de la révolution",
      "Les manifestations des droits de l'homme",
    ],
    answer: "Les manifestations vertes",
    explanation:
        "Les manifestations vertes en Iran en 2009 ont été une réaction aux élections présidentielles contestées.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom de l'organisation internationale qui défend les droits de l'homme ?",
    options: ["L'ONU", "L'OTAN", "L'UE"],
    answer: "L'ONU",
    explanation:
        "L'ONU, Organisation des Nations Unies, a pour but de maintenir la paix et de protéger les droits de l'homme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "En quelle année a eu lieu la chute du mur de Berlin ?",
    options: ["1987", "1989", "1991"],
    answer: "1989",
    explanation:
        "La chute du mur de Berlin a eu lieu en 1989, symbolisant la fin de la guerre froide.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le principal organe exécutif de l'Union européenne ?",
    options: [
      "Le Parlement européen",
      "La Commission européenne",
      "Le Conseil européen",
    ],
    answer: "La Commission européenne",
    explanation:
        "La Commission européenne propose des lois et veille à leur application au sein de l'UE.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Qui a été le premier président de la cinquième République française ?",
    options: ["Charles de Gaulle", "François Mitterrand", "Jacques Chirac"],
    answer: "Charles de Gaulle",
    explanation:
        "Charles de Gaulle a été le premier président de la cinquième République, élu en 1958.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a marqué le début de la Première Guerre mondiale ?",
    options: [
      "L'assassinat de François-Ferdinand",
      "La déclaration de guerre de l'Allemagne",
      "La prise de la Bastille",
    ],
    answer: "L'assassinat de François-Ferdinand",
    explanation:
        "L'assassinat de l'archiduc François-Ferdinand en 1914 a été le déclencheur de la Première Guerre mondiale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel était le nom du programme spatial américain qui a conduit à l'atterrissage sur la Lune en 1969 ?",
    options: ["Apollo 11", "Gemini", "Mercury"],
    answer: "Apollo 11",
    explanation:
        "Apollo 11 est la mission qui a permis aux astronautes de poser le premier pied sur la Lune.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est l'auteur de la Déclaration des droits de l'homme et du citoyen ?",
    options: ["L'Assemblée nationale", "Louis XVI", "Napoléon Bonaparte"],
    answer: "L'Assemblée nationale",
    explanation:
        "La Déclaration des droits de l'homme et du citoyen a été adoptée par l'Assemblée nationale en 1789.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Qui a été le leader des droits civiques aux États-Unis dans les années 1960 ?",
    options: ["Malcolm X", "Martin Luther King Jr.", "Rosa Parks"],
    answer: "Martin Luther King Jr.",
    explanation:
        "Martin Luther King Jr. est reconnu pour son rôle dans le mouvement des droits civiques et sa lutte pour l'égalité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement naturel dévastateur a frappé Haïti en 2010 ?",
    options: ["Un tsunami", "Un ouragan", "Un tremblement de terre"],
    answer: "Un tremblement de terre",
    explanation:
        "Le tremblement de terre de magnitude 7,0 a causé des destructions massives en Haïti.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement social a eu lieu en France en mai 1968 ?",
    options: [
      "Les gilets jaunes",
      "Le mouvement étudiant",
      "La Révolution tranquille",
    ],
    answer: "Le mouvement étudiant",
    explanation:
        "Le mouvement de mai 1968 en France a été un soulèvement étudiant pour des réformes sociales et politiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Qui est l'auteur de 'Germinal', un roman sur les conditions de travail des mineurs ?",
    options: ["Émile Zola", "Victor Hugo", "Gustave Flaubert"],
    answer: "Émile Zola",
    explanation:
        "Émile Zola a écrit 'Germinal', un roman emblématique sur la lutte des mineurs au XIXe siècle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le capital de l'Italie ?",
    options: ["Rome", "Milan", "Naples"],
    answer: "Rome",
    explanation:
        "Rome est la capitale de l'Italie et est connue pour son histoire ancienne et sa culture.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a eu lieu le 11 septembre 2001 aux États-Unis ?",
    options: [
      "Une élection présidentielle",
      "Une attaque terroriste",
      "La fin de la guerre froide",
    ],
    answer: "Une attaque terroriste",
    explanation:
        "Le 11 septembre 2001, des attentats terroristes ont frappé le World Trade Center et le Pentagone.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui était la première femme à diriger le Conseil Européen ?",
    options: ["Angela Merkel", "Ursula von der Leyen", "Theresa May"],
    answer: "Ursula von der Leyen",
    explanation:
        "Ursula von der Leyen est devenue la première femme présidente de la Commission européenne en 2019.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le nom de la monnaie utilisée dans la zone euro ?",
    options: ["Dollar", "Yen", "Euro"],
    answer: "Euro",
    explanation:
        "L'Euro est la monnaie officielle utilisée par 19 des 27 pays de l'Union européenne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la capitale du Canada ?",
    options: ["Toronto", "Ottawa", "Montréal"],
    answer: "Ottawa",
    explanation:
        "Ottawa est la capitale du Canada, reconnue pour ses institutions gouvernementales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre mouvement artistique et culturel est né dans les années 1920 à Harlem ?",
    options: ["Le surréalisme", "La renaissance harlem", "Le cubisme"],
    answer: "La renaissance harlem",
    explanation:
        "La renaissance harlem a été un mouvement culturel qui a célébré l'art afro-américain.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui est l'auteur de '1984', un roman sur un état totalitaire ?",
    options: ["Aldous Huxley", "George Orwell", "Ray Bradbury"],
    answer: "George Orwell",
    explanation:
        "George Orwell a écrit '1984', qui décrit une société sous surveillance et contrôle total.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle invention a été popularisée par Alexander Graham Bell ?",
    options: ["La radio", "Le téléphone", "Le télégraphe"],
    answer: "Le téléphone",
    explanation:
        "Alexander Graham Bell est reconnu pour avoir inventé le téléphone en 1876.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement a marqué la fin de l'apartheid en Afrique du Sud ?",
    options: [
      "La lutte des Zoulous",
      "La révolte des étudiants",
      "Le mouvement anti-apartheid",
    ],
    answer: "Le mouvement anti-apartheid",
    explanation:
        "Le mouvement anti-apartheid a conduit à la fin du régime d'apartheid en Afrique du Sud.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a écrit 'Les Misérables' ?",
    options: ["Victor Hugo", "Gustave Flaubert", "Émile Zola"],
    answer: "Victor Hugo",
    explanation:
        "Victor Hugo est l'auteur de 'Les Misérables', un roman qui illustre les luttes sociales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays est considéré comme le berceau de la démocratie ?",
    options: ["La Grèce", "L'Italie", "L'Angleterre"],
    answer: "La Grèce",
    explanation:
        "La Grèce antique est souvent considérée comme le berceau de la démocratie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a déclenché le mouvement 'Me Too' ?",
    options: [
      "Une loi sur l'égalité des sexes",
      "Révélations sur Harvey Weinstein",
      "Une campagne électorale",
    ],
    answer: "Révélations sur Harvey Weinstein",
    explanation:
        "Le mouvement 'Me Too' a été lancé après les révélations sur le producteur Harvey Weinstein en 2017.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le nom de l'organe judiciaire suprême en France ?",
    options: [
      "La Cour de cassation",
      "Le Conseil d'État",
      "Le Tribunal administratif",
    ],
    answer: "La Cour de cassation",
    explanation:
        "La Cour de cassation est la plus haute juridiction de l'ordre judiciaire en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a écrit 'Le Petit Prince' ?",
    options: ["Antoine de Saint-Exupéry", "Jules Verne", "Colette"],
    answer: "Antoine de Saint-Exupéry",
    explanation:
        "Antoine de Saint-Exupéry est l'auteur du célèbre livre 'Le Petit Prince'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est l'océan le plus vaste du monde ?",
    options: ["L'océan Atlantique", "L'océan Indien", "L'océan Pacifique"],
    answer: "L'océan Pacifique",
    explanation:
        "L'océan Pacifique est le plus vaste océan du monde, couvrant plus de 63 millions de kilomètres carrés.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle était la première station spatiale habitée ?",
    options: ["Skylab", "Mir", "Zarya"],
    answer: "Skylab",
    explanation:
        "Skylab a été la première station spatiale habitée, lancée par les États-Unis en 1973.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le plus haut sommet du monde ?",
    options: ["K2", "Mont Everest", "Mont Blanc"],
    answer: "Mont Everest",
    explanation:
        "Le mont Everest est le plus haut sommet du monde, atteignant 8 848 mètres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays est à l'origine des Jeux Olympiques modernes ?",
    options: ["France", "Grèce", "Royaume-Uni"],
    answer: "Grèce",
    explanation:
        "Les Jeux Olympiques modernes ont été inspirés par les anciens jeux grecs, débutés en 1896.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le plus long fleuve du monde ?",
    options: ["Le Nil", "L'Amazone", "Le Yangzi Jiang"],
    answer: "L'Amazone",
    explanation:
        "L'Amazone est souvent considéré comme le plus long fleuve du monde.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été la première femme à gagner un prix Nobel ?",
    options: ["Marie Curie", "Rosalind Franklin", "Ada Lovelace"],
    answer: "Marie Curie",
    explanation:
        "Marie Curie a été la première femme à recevoir un prix Nobel, en physique, en 1903.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le principal gaz à effet de serre responsable du changement climatique ?",
    options: ["Le dioxyde de carbone", "Le méthane", "L'ozone"],
    answer: "Le dioxyde de carbone",
    explanation:
        "Le dioxyde de carbone (CO2) est le principal gaz à effet de serre entraînant le réchauffement climatique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui est le créateur de Facebook ?",
    options: ["Elon Musk", "Mark Zuckerberg", "Steve Jobs"],
    answer: "Mark Zuckerberg",
    explanation: "Mark Zuckerberg a cofondé Facebook en 2004.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été le premier à reconnaître l'indépendance de l'Ukraine ?",
    options: ["Russie", "États-Unis", "Pologne"],
    answer: "Pologne",
    explanation:
        "La Pologne a été l'un des premiers pays à reconnaître l'indépendance de l'Ukraine après la chute de l'URSS.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement historique est connu sous le nom de 'la Grande Dépression' ?",
    options: [
      "Une crise économique",
      "Une guerre mondiale",
      "Un conflit social",
    ],
    answer: "Une crise économique",
    explanation:
        "La Grande Dépression désigne la crise économique mondiale des années 1930.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel traité a été signé pour établir l'Union européenne ?",
    options: [
      "Le traité de Maastricht",
      "Le traité de Lisbonne",
      "Le traité de Rome",
    ],
    answer: "Le traité de Maastricht",
    explanation:
        "Le traité de Maastricht, signé en 1992, a établi l'Union européenne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Qui est l'artiste célèbre connu pour ses peintures de soupes Campbell ?",
    options: ["Andy Warhol", "Pablo Picasso", "Jackson Pollock"],
    answer: "Andy Warhol",
    explanation:
        "Andy Warhol est célèbre pour ses œuvres d'art pop, y compris ses peintures de soupes Campbell.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement marquant a eu lieu en 1963 aux États-Unis ?",
    options: [
      "L'assassinat de John F. Kennedy",
      "Le premier pas sur la Lune",
      "Le mouvement pour les droits civiques",
    ],
    answer: "L'assassinat de John F. Kennedy",
    explanation:
        "L'assassinat de John F. Kennedy a eu lieu le 22 novembre 1963.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel phénomène naturel a lieu lorsque la terre tremble ?",
    options: ["Un séisme", "Un tsunami", "Un ouragan"],
    answer: "Un séisme",
    explanation:
        "Un séisme est un tremblement de terre causé par la libération d'énergie dans la croûte terrestre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel président américain a mis en place le New Deal dans les années 1930 ?",
    options: ["Franklin D. Roosevelt", "Herbert Hoover", "Harry S. Truman"],
    answer: "Franklin D. Roosevelt",
    explanation:
        "Franklin D. Roosevelt a introduit le New Deal pour faire face à la crise économique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement de protestation contre la ségrégation raciale a eu lieu aux États-Unis dans les années 1960 ?",
    options: [
      "Le mouvement des droits civiques",
      "Le mouvement féministe",
      "Le mouvement pacifiste",
    ],
    answer: "Le mouvement des droits civiques",
    explanation:
        "Le mouvement des droits civiques visait à mettre fin à la discrimination raciale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle guerre a été menée entre le Nord et le Sud des États-Unis ?",
    options: [
      "La guerre de Sécession",
      "La Première Guerre mondiale",
      "La guerre du Vietnam",
    ],
    answer: "La guerre de Sécession",
    explanation:
        "La guerre de Sécession a eu lieu entre 1861 et 1865, opposant le Nord et le Sud des États-Unis.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement artistique a émergé à la fin des années 1940 et au début des années 1950 ?",
    options: ["Le surréalisme", "L'expressionnisme abstrait", "Le cubisme"],
    answer: "L'expressionnisme abstrait",
    explanation:
        "L'expressionnisme abstrait est un mouvement artistique centré sur l'émotion et l'abstraction.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom de l'accord signé en 1972 entre les États-Unis et l'URSS qui visait à limiter les armes nucléaires ?",
    options: ["Le traité de TNP", "Le traité SALT I", "Le traité START"],
    answer: "Le traité SALT I",
    explanation:
        "Le traité SALT I, signé en 1972, était un accord pour limiter les armes nucléaires entre les États-Unis et l'URSS.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom du chanteur connu pour son style unique et ses chansons engagées, comme 'Imagine' ?",
    options: ["Bob Dylan", "John Lennon", "Elton John"],
    answer: "John Lennon",
    explanation:
        "John Lennon est connu pour sa chanson 'Imagine', qui prône la paix.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la date de la chute de l'Empire romain ?",
    options: ["476 après J.-C.", "500 après J.-C.", "400 après J.-C."],
    answer: "476 après J.-C.",
    explanation:
        "La chute de l'Empire romain est traditionnellement datée de 476 après J.-C.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la capitale de la France ?",
    options: ["Madrid", "Berlin", "Paris"],
    answer: "Paris",
    explanation: "Paris est la capitale de la France depuis des siècles.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui est le président actuel de la France ?",
    options: ["Emmanuel Macron", "François Hollande", "Nicolas Sarkozy"],
    answer: "Emmanuel Macron",
    explanation:
        "Emmanuel Macron est le président de la République française depuis 2017.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement marquant a eu lieu en 1789 en France ?",
    options: [
      "La Révolution française",
      "La Première Guerre mondiale",
      "La création de l'Union européenne",
    ],
    answer: "La Révolution française",
    explanation:
        "La Révolution française a marqué la fin de la monarchie absolue en France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a gagné la Coupe du Monde de football en 2018 ?",
    options: ["Brésil", "Allemagne", "France"],
    answer: "France",
    explanation:
        "La France a remporté la Coupe du Monde de football en 2018 en battant la Croatie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le symbole de la liberté en France ?",
    options: ["Le Coq", "La Marianne", "La Tour Eiffel"],
    answer: "La Marianne",
    explanation:
        "La Marianne est un symbole de la République et de la liberté en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel traité a mis fin à la Première Guerre mondiale ?",
    options: [
      "Le traité de Versailles",
      "Le traité de Paris",
      "Le traité de Trianon",
    ],
    answer: "Le traité de Versailles",
    explanation:
        "Le traité de Versailles a été signé en 1919 pour mettre fin à la Première Guerre mondiale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel océan borde la côte est des États-Unis ?",
    options: ["Océan Atlantique", "Océan Pacifique", "Océan Indien"],
    answer: "Océan Atlantique",
    explanation: "L'océan Atlantique se situe à l'est des États-Unis.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement historique a eu lieu le 11 septembre 2001 ?",
    options: [
      "L'atterrissage sur la Lune",
      "Les attentats du 11 septembre",
      "La chute du mur de Berlin",
    ],
    answer: "Les attentats du 11 septembre",
    explanation:
        "Les attentats du 11 septembre 2001 ont touché les États-Unis, modifiant la politique mondiale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays est connu pour la pyramide de Gizeh ?",
    options: ["Mexique", "Égypte", "Grèce"],
    answer: "Égypte",
    explanation:
        "La pyramide de Gizeh est l'une des sept merveilles du monde et se trouve en Égypte.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement artistique est associé à Claude Monet ?",
    options: ["Le surréalisme", "L'impressionnisme", "Le cubisme"],
    answer: "L'impressionnisme",
    explanation:
        "Claude Monet est l'un des principaux artistes du mouvement impressionniste.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel scientifique a formulé la théorie de la relativité ?",
    options: ["Isaac Newton", "Galilée", "Albert Einstein"],
    answer: "Albert Einstein",
    explanation:
        "Albert Einstein a développé la théorie de la relativité au début du 20ème siècle.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement social a débuté en 1960 aux États-Unis ?",
    options: ["Les droits civiques", "Le féminisme", "L'écologie"],
    answer: "Les droits civiques",
    explanation:
        "Le mouvement des droits civiques a lutté pour l'égalité des droits des Afro-Américains.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la capitale de l'Italie ?",
    options: ["Madrid", "Rome", "Athènes"],
    answer: "Rome",
    explanation: "Rome est la capitale et la plus grande ville d'Italie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel auteur a écrit 'Le Petit Prince' ?",
    options: ["Antoine de Saint-Exupéry", "Jules Verne", "Marcel Proust"],
    answer: "Antoine de Saint-Exupéry",
    explanation:
        "Antoine de Saint-Exupéry a écrit 'Le Petit Prince', publié en 1943.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a déclenché la Seconde Guerre mondiale ?",
    options: [
      "L'invasion de la Pologne",
      "La signature du traité de Versailles",
      "La Grande Dépression",
    ],
    answer: "L'invasion de la Pologne",
    explanation:
        "L'invasion de la Pologne par l'Allemagne en 1939 a marqué le début de la Seconde Guerre mondiale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays est connu pour sa production de chocolat ?",
    options: ["Belgique", "Russie", "Japon"],
    answer: "Belgique",
    explanation: "La Belgique est célèbre pour son chocolat de haute qualité.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le principal gaz à effet de serre ?",
    options: ["Dioxyde de carbone", "Méthane", "Ozone"],
    answer: "Dioxyde de carbone",
    explanation:
        "Le dioxyde de carbone est le principal gaz responsable du réchauffement climatique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays est la patrie des Vikings ?",
    options: ["Danemark", "France", "Italie"],
    answer: "Danemark",
    explanation:
        "Le Danemark est souvent considéré comme la patrie des Vikings.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la plus grande démocratie du monde ?",
    options: ["États-Unis", "Inde", "Allemagne"],
    answer: "Inde",
    explanation:
        "L'Inde est la plus grande démocratie du monde en termes de population.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel célèbre scientifique a découvert la pénicilline ?",
    options: ["Louis Pasteur", "Alexander Fleming", "Marie Curie"],
    answer: "Alexander Fleming",
    explanation: "Alexander Fleming a découvert la pénicilline en 1928.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le plus haut sommet du monde ?",
    options: ["K2", "Mont Blanc", "Everest"],
    answer: "Everest",
    explanation:
        "L'Everest est le sommet le plus élevé du monde, culminant à 8848 mètres.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel océan est le plus grand du monde ?",
    options: ["Océan Indien", "Océan Atlantique", "Océan Pacifique"],
    answer: "Océan Pacifique",
    explanation: "L'océan Pacifique est le plus grand océan du monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a peint la Joconde ?",
    options: ["Vincent van Gogh", "Pablo Picasso", "Léonard de Vinci"],
    answer: "Léonard de Vinci",
    explanation:
        "Léonard de Vinci est l'auteur de la célèbre peinture 'La Joconde'.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est l'organe principal de la circulation sanguine ?",
    options: ["Le cerveau", "Le cœur", "Les poumons"],
    answer: "Le cœur",
    explanation: "Le cœur est l'organe central de la circulation sanguine.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a fondé l'Empire romain ?",
    options: ["Jules César", "Augustus", "Néron"],
    answer: "Augustus",
    explanation:
        "Augustus, anciennement connu sous le nom d'Octave, a fondé l'Empire romain.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la plus grande île du monde ?",
    options: ["Madagascar", "Groenland", "Borneo"],
    answer: "Groenland",
    explanation: "Le Groenland est la plus grande île du monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel sport est associé à Wimbledon ?",
    options: ["Football", "Tennis", "Rugby"],
    answer: "Tennis",
    explanation:
        "Wimbledon est un tournoi de tennis prestigieux, le plus ancien au monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le plus grand désert du monde ?",
    options: ["Sahara", "Gobi", "Antarctique"],
    answer: "Antarctique",
    explanation:
        "Le désert de l'Antarctique est le plus vaste désert du monde.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel explorateur a découvert l'Amérique ?",
    options: ["Marco Polo", "Christophe Colomb", "Ferdinand Magellan"],
    answer: "Christophe Colomb",
    explanation: "Christophe Colomb a découvert l'Amérique en 1492.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quels sont les trois états de l'eau ?",
    options: [
      "Solide, liquide, gazeux",
      "Solide, dur, mou",
      "Liquide, fluide, solide",
    ],
    answer: "Solide, liquide, gazeux",
    explanation:
        "L'eau existe sous trois états: solide (glace), liquide et gazeux (vapeur).",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a introduit le premier code postal ?",
    options: ["Royaume-Uni", "États-Unis", "France"],
    answer: "Royaume-Uni",
    explanation:
        "Le Royaume-Uni a été le premier à introduire un code postal en 1857.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le principal fleuve d'Amérique du Sud ?",
    options: ["Rio de la Plata", "Amazonie", "Orénoque"],
    answer: "Amazonie",
    explanation: "L'Amazonie est le plus long fleuve d'Amérique du Sud.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le symbole chimique de l'or ?",
    options: ["Au", "Ag", "Fe"],
    answer: "Au",
    explanation:
        "Le symbole chimique de l'or est 'Au', dérivé du latin 'aurum'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le plus grand animal terrestre ?",
    options: ["Éléphant", "Giraffe", "Rhinocéros"],
    answer: "Éléphant",
    explanation:
        "L'éléphant est le plus grand animal terrestre vivant aujourd'hui.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel océan se trouve entre l'Afrique et l'Amérique ?",
    options: ["Océan Atlantique", "Océan Indien", "Océan Pacifique"],
    answer: "Océan Atlantique",
    explanation: "L'océan Atlantique est situé entre l'Afrique et l'Amérique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le principal régime politique en France ?",
    options: ["Monarchie", "République", "Dictature"],
    answer: "République",
    explanation: "La France est une République depuis 1792.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la langue officielle de l'ONU ?",
    options: ["Anglais", "Français", "Espagnol"],
    answer: "Anglais",
    explanation:
        "L'anglais est l'une des principales langues officielles de l'ONU.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a écrit 'Guerre et Paix' ?",
    options: ["Fiodor Dostoïevski", "Léon Tolstoï", "Anton Tchekhov"],
    answer: "Léon Tolstoï",
    explanation:
        "Léon Tolstoï est l'auteur du roman 'Guerre et Paix', publié en 1869.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la durée d'un mandat présidentiel en France ?",
    options: ["5 ans", "7 ans", "4 ans"],
    answer: "5 ans",
    explanation: "Le mandat présidentiel en France dure 5 ans depuis 2002.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la couleur du drapeau français ?",
    options: ["Rouge, blanc, bleu", "Bleu, blanc, rouge", "Jaune, vert, bleu"],
    answer: "Bleu, blanc, rouge",
    explanation:
        "Le drapeau français est composé de trois bandes verticales de bleu, blanc et rouge.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui est l'auteur de 'Roméo et Juliette' ?",
    options: ["William Shakespeare", "Charles Dickens", "Victor Hugo"],
    answer: "William Shakespeare",
    explanation:
        "William Shakespeare a écrit la célèbre tragédie 'Roméo et Juliette'.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le pays d'origine du sushi ?",
    options: ["Chine", "Japon", "Corée"],
    answer: "Japon",
    explanation: "Le sushi est un plat traditionnel japonais.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel phénomène naturel est mesuré par l'échelle de Richeter ?",
    options: ["Tremblements de terre", "Ouragans", "Inondations"],
    answer: "Tremblements de terre",
    explanation:
        "L'échelle de Richter mesure l'intensité des tremblements de terre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le pays le plus peuplé du monde ?",
    options: ["Inde", "Chine", "États-Unis"],
    answer: "Chine",
    explanation: "La Chine est le pays le plus peuplé du monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le principal ingrédient du guacamole ?",
    options: ["Tomate", "Avocat", "Piment"],
    answer: "Avocat",
    explanation: "L'ingrédient principal du guacamole est l'avocat.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement marquant a eu lieu le 11 septembre 2001 aux États-Unis ?",
    options: [
      "Attentats de New York",
      "Récession économique",
      "Élection présidentielle",
    ],
    answer: "Attentats de New York",
    explanation:
        "Les attentats du 11 septembre 2001 ont ciblé les tours jumelles du World Trade Center à New York.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le nom de l'accord qui a mis fin à la guerre froide ?",
    options: [
      "Accord de Maastricht",
      "Traité de Lisbonne",
      "Traitée de l'Atlantique Nord",
    ],
    answer: "Accord de Maastricht",
    explanation:
        "L'Accord de Maastricht a jeté les bases de l'Union européenne et a marqué la fin de la guerre froide.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a remporté le Prix Nobel de la paix en 2014 ?",
    options: ["Malala Yousafzai", "Barack Obama", "Kofi Annan"],
    answer: "Malala Yousafzai",
    explanation:
        "Malala Yousafzai a été honorée pour son combat en faveur de l'éducation des filles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a voté pour quitter l'Union européenne en 2016 ?",
    options: ["France", "Royaume-Uni", "Allemagne"],
    answer: "Royaume-Uni",
    explanation:
        "Le référendum de 2016 a décidé du Brexit, entraînant la sortie du Royaume-Uni de l'UE.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement social a émergé en réponse à l'inégalité raciale aux États-Unis en 2020 ?",
    options: ["MeToo", "Black Lives Matter", "Gilets jaunes"],
    answer: "Black Lives Matter",
    explanation:
        "Le mouvement Black Lives Matter a pris de l'ampleur après le meurtre de George Floyd.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "En quelle année est tombé le mur de Berlin ?",
    options: ["1989", "1991", "1993"],
    answer: "1989",
    explanation:
        "Le mur de Berlin est tombé en 1989, symbolisant la fin de la guerre froide.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été touché par un tsunami dévastateur en 2004 ?",
    options: ["Indonésie", "Japon", "Chili"],
    answer: "Indonésie",
    explanation:
        "Le tsunami de 2004 a profondément touché l'Indonésie, causant des milliers de morts.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle plateforme a popularisé le concept de partage de vidéos en ligne ?",
    options: ["YouTube", "Vimeo", "Dailymotion"],
    answer: "YouTube",
    explanation:
        "YouTube a été lancé en 2005 et a révolutionné le partage de vidéos sur Internet.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement sportif international a eu lieu à Londres en 2012 ?",
    options: [
      "Jeux Olympiques",
      "Coupe du Monde",
      "Championnat d'Europe de football",
    ],
    answer: "Jeux Olympiques",
    explanation: "Londres a accueilli les Jeux Olympiques d'été en 2012.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel président français a lancé le projet de loi sur le mariage pour tous en 2012 ?",
    options: ["Nicolas Sarkozy", "François Hollande", "Jacques Chirac"],
    answer: "François Hollande",
    explanation:
        "François Hollande a promulgué la loi sur le mariage pour tous en 2013.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a organisé la Coupe du Monde de la FIFA en 2014 ?",
    options: ["Brésil", "Allemagne", "France"],
    answer: "Brésil",
    explanation: "Le Brésil a accueilli la Coupe du Monde de la FIFA en 2014.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qu'appelle-t-on le 'Printemps arabe' ?",
    options: [
      "Une série de révoltes au Moyen-Orient",
      "Une révolution en Europe",
      "Un mouvement artistique",
    ],
    answer: "Une série de révoltes au Moyen-Orient",
    explanation:
        "Le Printemps arabe désigne une série de mouvements de protestation dans plusieurs pays arabes en 2011.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui est l'auteur du livre 'Sapiens' ?",
    options: ["Yuval Noah Harari", "Michel Onfray", "Amélie Nothomb"],
    answer: "Yuval Noah Harari",
    explanation:
        "'Sapiens' est un ouvrage de Yuval Noah Harari qui explore l'histoire de l'humanité.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel réseau social a été lancé en 2006 et est devenu très populaire pour le microblogging ?",
    options: ["Facebook", "Twitter", "Instagram"],
    answer: "Twitter",
    explanation:
        "Twitter a été lancé en 2006 et est connu pour ses messages courts appelés tweets.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement environnemental mondial a été fondé par un jeune Suédois en 2018 ?",
    options: ["Greenpeace", "Fridays for Future", "Extinction Rebellion"],
    answer: "Fridays for Future",
    explanation:
        "Fridays for Future a été créé par Greta Thunberg pour lutter contre le changement climatique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle organisation internationale a été fondée en 1945 ?",
    options: ["L'OTAN", "L'ONU", "L'UE"],
    answer: "L'ONU",
    explanation:
        "L'Organisation des Nations Unies (ONU) a été fondée en 1945 pour promouvoir la paix.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a connu des changements politiques majeurs avec le mouvement Euromaidan en 2014 ?",
    options: ["Ukraine", "Syrie", "Hongrie"],
    answer: "Ukraine",
    explanation:
        "Le mouvement Euromaidan en Ukraine a conduit à des changements gouvernementaux en 2014.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre hacker a été arrêté en 2010 pour des activités liées à Wikileaks ?",
    options: ["Edward Snowden", "Julian Assange", "Aaron Swartz"],
    answer: "Julian Assange",
    explanation:
        "Julian Assange, fondateur de Wikileaks, a été arrêté en 2010 pour avoir divulgué des informations sensibles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a déclenché la crise financière mondiale de 2008 ?",
    options: [
      "Effondrement des banques",
      "Crise des subprimes",
      "Chute des marchés boursiers",
    ],
    answer: "Crise des subprimes",
    explanation:
        "La crise des subprimes a été le catalyseur de la crise financière mondiale de 2008.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement a lutté pour les droits civiques aux États-Unis dans les années 1960 ?",
    options: [
      "Black Lives Matter",
      "Occupy Wall Street",
      "Mouvement des droits civiques",
    ],
    answer: "Mouvement des droits civiques",
    explanation:
        "Le mouvement des droits civiques a lutté pour l'égalité raciale aux États-Unis dans les années 60.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été la première femme à diriger le FMI ?",
    options: ["Christine Lagarde", "Janet Yellen", "Nouriel Roubini"],
    answer: "Christine Lagarde",
    explanation:
        "Christine Lagarde est devenue la première femme à diriger le Fonds monétaire international en 2011.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel artiste a popularisé le style musical appelé 'reggae' ?",
    options: ["Bob Marley", "Michael Jackson", "Elvis Presley"],
    answer: "Bob Marley",
    explanation:
        "Bob Marley est considéré comme le roi du reggae, ayant popularisé ce genre musical à l'échelle mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement historique symbolise la fin de l'apartheid en Afrique du Sud ?",
    options: [
      "Élection de Nelson Mandela",
      "Inauguration d'une statue",
      "Libération de prisonniers politiques",
    ],
    answer: "Élection de Nelson Mandela",
    explanation:
        "L'élection de Nelson Mandela en 1994 a marqué la fin officielle de l'apartheid en Afrique du Sud.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel terme désigne le processus d'intégration de l'Europe ?",
    options: ["Euroscepticisme", "Europe unie", "Intégration européenne"],
    answer: "Intégration européenne",
    explanation:
        "L'intégration européenne fait référence au processus de création de liens plus étroits entre les pays européens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été impliqué dans le 'Brexit' ?",
    options: ["Écosse", "Royaume-Uni", "Irlande"],
    answer: "Royaume-Uni",
    explanation:
        "Le Brexit se réfère au vote du Royaume-Uni pour quitter l'Union européenne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement a été initié par Greta Thunberg pour le climat ?",
    options: ["Fridays for Future", "Gilets jaunes", "Black Lives Matter"],
    answer: "Fridays for Future",
    explanation:
        "Fridays for Future est un mouvement créé par Greta Thunberg pour sensibiliser aux questions climatiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a subi une catastrophe nucléaire en 1986 ?",
    options: ["États-Unis", "Japon", "Ukraine"],
    answer: "Ukraine",
    explanation:
        "La catastrophe de Tchernobyl en 1986 a eu lieu en Ukraine et a eu des conséquences mondiales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel traité a été signé pour limiter les armements nucléaires ?",
    options: [
      "Traité de Versailles",
      "Traité de Non-Prolifération",
      "Traité sur l'Atlantique Nord",
    ],
    answer: "Traité de Non-Prolifération",
    explanation:
        "Le Traité de Non-Prolifération vise à empêcher la prolifération des armes nucléaires.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement sportif a eu lieu à Rio de Janeiro en 2016 ?",
    options: [
      "Coupe du Monde",
      "Jeux Olympiques",
      "Championnat du monde de football",
    ],
    answer: "Jeux Olympiques",
    explanation:
        "Les Jeux Olympiques d'été de 2016 se sont tenus à Rio de Janeiro.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement a émergé pour défendre les droits des femmes en 2017 ?",
    options: ["MeToo", "Fridays for Future", "Occupy Wall Street"],
    answer: "MeToo",
    explanation:
        "Le mouvement MeToo a pris de l'ampleur en 2017 pour lutter contre le harcèlement et les abus.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel président américain a été destitué en 1998 ?",
    options: ["George W. Bush", "Bill Clinton", "Ronald Reagan"],
    answer: "Bill Clinton",
    explanation:
        "Bill Clinton a été destitué en 1998 mais a été acquitté par le Sénat.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a connu un séisme dévastateur en 2010 ?",
    options: ["Haïti", "Chili", "Japon"],
    answer: "Haïti",
    explanation:
        "Le tremblement de terre en Haïti en 2010 a causé d'importants dégâts et pertes en vies humaines.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel célèbre dernier roi de France a fui à Varennes ?",
    options: ["Louis XVI", "Louis XIV", "Napoléon Bonaparte"],
    answer: "Louis XVI",
    explanation:
        "Louis XVI a tenté de fuir à Varennes en 1791, ce qui a contribué à sa chute.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été touché par une guerre civile de 2011 à 2020 ?",
    options: ["Syrie", "Libye", "Yémen"],
    answer: "Syrie",
    explanation:
        "La Syrie a été en proie à une guerre civile depuis 2011, entraînant une crise humanitaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement majeur a eu lieu à Paris en 2015 ?",
    options: [
      "Attentats de Charlie Hebdo",
      "Coupe du Monde de rugby",
      "Sommet climatique de la COP21",
    ],
    answer: "Attentats de Charlie Hebdo",
    explanation:
        "Les attentats de Charlie Hebdo en janvier 2015 ont choqué la France et le monde entier.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement de protestation a eu lieu en France en 2018 ?",
    options: ["Gilets jaunes", "MeToo", "Fridays for Future"],
    answer: "Gilets jaunes",
    explanation:
        "Le mouvement des Gilets jaunes a protesté contre la hausse des taxes et les inégalités sociales.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel parti politique a été fondé par Marine Le Pen en France ?",
    options: [
      "Rassemblement National",
      "Les Républicains",
      "Société française",
    ],
    answer: "Rassemblement National",
    explanation:
        "Le Rassemblement National, anciennement Front National, a été fondé par Jean-Marie Le Pen.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel film a remporté l'Oscar du meilleur film en 2020 ?",
    options: ["Parasite", "1917", "Joker"],
    answer: "Parasite",
    explanation:
        "'Parasite' a fait histoire en gagnant l'Oscar du meilleur film en 2020.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a annoncé des mesures de confinement en mars 2020 en raison de la pandémie de COVID-19 ?",
    options: ["France", "Espagne", "Allemagne"],
    answer: "France",
    explanation:
        "La France a imposé un confinement strict en mars 2020 pour lutter contre la pandémie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel scandale a touché le secteur de l'automobile en 2015 ?",
    options: [
      "Scandale Volkswagen",
      "Scandale de l'acier",
      "Scandale de l'eau",
    ],
    answer: "Scandale Volkswagen",
    explanation:
        "Le scandale Volkswagen a révélé l'utilisation de logiciels truqueurs dans des véhicules diesel.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel était le surnom de l'ancien président des États-Unis Barack Obama ?",
    options: ["L'Empereur", "Le Président des espérances", "Le Sauveur"],
    answer: "Le Président des espérances",
    explanation:
        "Barack Obama a souvent été surnommé 'Le Président des espérances' durant sa campagne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement tragique a eu lieu dans un club de musique à Orlando en 2016 ?",
    options: ["Tirs de masse", "Accident de voiture", "Incendie"],
    answer: "Tirs de masse",
    explanation:
        "Une fusillade dans un club de musique à Orlando a causé de nombreuses victimes en 2016.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a conduit au déclenchement de la guerre en Irak en 2003 ?",
    options: [
      "Attentats de 11 septembre",
      "Allégations d'armes de destruction massive",
      "Révolte populaire",
    ],
    answer: "Allégations d'armes de destruction massive",
    explanation:
        "La guerre en Irak a été justifiée par des allégations selon lesquelles Saddam Hussein possédait des armes de destruction massive.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a connu une invasion en 1979 par l'Union soviétique ?",
    options: ["Afghanistan", "Iran", "Pakistan"],
    answer: "Afghanistan",
    explanation:
        "L'Union soviétique a envahi l'Afghanistan en 1979, déclenchant un conflit qui a duré des années.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a connu des manifestations pour la démocratie en 1989 avec la place Tiananmen ?",
    options: ["Chine", "Corée du Sud", "Vietnam"],
    answer: "Chine",
    explanation:
        "Les manifestations de la place Tiananmen en 1989 en Chine ont été un moment clé de la lutte pour la démocratie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement a sensibilisé à la crise climatique à partir de 2018 ?",
    options: ["Fridays for Future", "MeToo", "Black Lives Matter"],
    answer: "Fridays for Future",
    explanation:
        "Fridays for Future a sensibilisé le monde à l'urgence climatique à partir de 2018.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "À quelle date a été signé l'accord de Paris sur le climat ?",
    options: ["12 décembre 2015", "1er janvier 2016", "22 octobre 2016"],
    answer: "12 décembre 2015",
    explanation:
        "L'accord de Paris a été signé le 12 décembre 2015 lors de la COP21.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel phénomène météorologique a été particulièrement intense en 2019 ?",
    options: ["Canicule", "Tempête", "Inondation"],
    answer: "Canicule",
    explanation:
        "La canicule de 2019 a touché de nombreux pays européens, provoquant des records de chaleur.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a donné naissance au mouvement 'Occupy Wall Street' ?",
    options: ["Royaume-Uni", "Canada", "États-Unis"],
    answer: "États-Unis",
    explanation:
        "Le mouvement Occupy Wall Street a émergé aux États-Unis en 2011 pour protester contre l'inégalité économique.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement a été lancé par des étudiants pour sensibiliser au changement climatique en 2018 ?",
    options: ["Fridays for Future", "Youth for Climate", "Climate Strike"],
    answer: "Fridays for Future",
    explanation:
        "Ce mouvement a été initié par Greta Thunberg pour inciter les gouvernements à agir contre le changement climatique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel était le principal sujet traité lors de la COP21 à Paris en 2015 ?",
    options: [
      "La biodiversité",
      "Le changement climatique",
      "L'énergie renouvelable",
    ],
    answer: "Le changement climatique",
    explanation:
        "La COP21 visait à établir un accord international pour limiter le réchauffement climatique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement marquant a eu lieu aux États-Unis le 11 septembre 2001 ?",
    options: [
      "Une élection présidentielle",
      "Une attaque terroriste",
      "Une course automobile",
    ],
    answer: "Une attaque terroriste",
    explanation:
        "Des groupes terroristes ont attaqué le World Trade Center et le Pentagone, causant des milliers de morts.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel prix Nobel a été attribué à Malala Yousafzai pour son combat en faveur de l'éducation ?",
    options: ["Paix", "Littérature", "Médecine"],
    answer: "Paix",
    explanation:
        "Malala a reçu le prix Nobel de la paix en 2014 pour son engagement en faveur de l'éducation des filles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "En quelle année a eu lieu le Brexit, l'élection qui a décidé de la sortie du Royaume-Uni de l'Union européenne ?",
    options: ["2015", "2016", "2017"],
    answer: "2016",
    explanation:
        "Le référendum sur le Brexit a eu lieu le 23 juin 2016 avec un vote pour la sortie de l'UE.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement a pour slogan 'Black Lives Matter' ?",
    options: [
      "Mouvement pour la justice sociale",
      "Mouvement environnemental",
      "Mouvement pour les droits des animaux",
    ],
    answer: "Mouvement pour la justice sociale",
    explanation:
        "Ce mouvement lutte contre les violences policières envers les Afro-Américains et pour l'égalité raciale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre accord a été signé en 1993 pour établir des relations entre Israël et l'Organisation de libération de la Palestine (OLP) ?",
    options: ["Accords de Camp David", "Accords d'Oslo", "Accords de Paris"],
    answer: "Accords d'Oslo",
    explanation:
        "Les Accords d'Oslo ont marqué la première reconnaissance mutuelle entre Israël et l'OLP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel incident a déclenché le mouvement des Gilets Jaunes en France en 2018 ?",
    options: [
      "L'augmentation des taxes sur l'essence",
      "La réforme des retraites",
      "Les élections municipales",
    ],
    answer: "L'augmentation des taxes sur l'essence",
    explanation:
        "L'augmentation des taxes sur le carburant a suscité une forte opposition populaire et des manifestations.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom de la célèbre activiste suédoise pour le climat, connue pour ses discours puissants ?",
    options: ["Greta Thunberg", "Malala Yousafzai", "Emma Watson"],
    answer: "Greta Thunberg",
    explanation:
        "Greta Thunberg a gagné une notoriété mondiale pour sa défense urgente des questions climatiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a accueilli les Jeux Olympiques d'été en 2016 ?",
    options: ["Brésil", "France", "Japon"],
    answer: "Brésil",
    explanation:
        "Les Jeux Olympiques d'été de 2016 se sont tenus à Rio de Janeiro, au Brésil.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Dans quelle ville se trouve le siège de l'ONU ?",
    options: ["Paris", "New York", "Genève"],
    answer: "New York",
    explanation:
        "Le siège des Nations Unies est situé à New York, aux États-Unis, depuis sa fondation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été le premier à légaliser le mariage homosexuel ?",
    options: ["Les États-Unis", "Les Pays-Bas", "La France"],
    answer: "Les Pays-Bas",
    explanation:
        "Les Pays-Bas ont légalisé le mariage entre personnes de même sexe en 2001, devenant les premiers à le faire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a été déclenché par la mort de George Floyd en 2020 ?",
    options: [
      "Les manifestations pour la justice climatique",
      "Les manifestations pour les droits civiques",
      "Les manifestations pour l'égalité des droits",
    ],
    answer: "Les manifestations pour les droits civiques",
    explanation:
        "La mort de George Floyd a provoqué des manifestations mondiales contre le racisme et les violences policières.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel traité a été signé pour mettre fin à la Première Guerre mondiale ?",
    options: [
      "Traité de Versailles",
      "Traité de Trianon",
      "Traité de Saint-Germain",
    ],
    answer: "Traité de Versailles",
    explanation:
        "Le traité de Versailles a été signé en 1919 pour définir les conditions de paix après la Première Guerre mondiale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement de protestation a débuté en 2019 pour défendre un mode de vie durable ?",
    options: ["Extinction Rebellion", "Fridays for Future", "Greenpeace"],
    answer: "Extinction Rebellion",
    explanation:
        "Extinction Rebellion vise à inciter les gouvernements à agir rapidement contre le changement climatique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel traité a créé l'Union européenne en 1993 ?",
    options: ["Traité de Maastricht", "Traité de Lisbonne", "Traité de Rome"],
    answer: "Traité de Maastricht",
    explanation:
        "Le traité de Maastricht a établi les bases de l'Union européenne et de l'euro.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement social a vu le jour aux États-Unis en réponse à la brutalité policière ?",
    options: ["Occupy Wall Street", "MeToo", "Black Lives Matter"],
    answer: "Black Lives Matter",
    explanation:
        "Ce mouvement vise à dénoncer les violences policières à l'encontre des Afro-Américains.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été le premier à abolir la peine de mort ?",
    options: ["France", "Royaume-Uni", "Portugal"],
    answer: "Portugal",
    explanation:
        "Le Portugal a aboli la peine de mort en 1867, devenant le premier pays au monde à le faire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre procès a eu lieu en 1995 concernant un ancien footballeur américain ?",
    options: [
      "Le procès de O.J. Simpson",
      "Le procès de Michael Jackson",
      "Le procès de Bill Cosby",
    ],
    answer: "Le procès de O.J. Simpson",
    explanation:
        "O.J. Simpson a été acquitté des accusations de meurtre lors d'un procès très médiatisé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a été célébré à Paris pour la première fois en 1889 ?",
    options: [
      "L'Exposition universelle",
      "Le Tour de France",
      "Le Festival de Cannes",
    ],
    answer: "L'Exposition universelle",
    explanation:
        "L'Exposition universelle de 1889 a marqué le centenaire de la Révolution française.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre mouvement féministe a commencé dans les années 1960 ?",
    options: ["MeToo", "Suffragette", "Deuxième vague féministe"],
    answer: "Deuxième vague féministe",
    explanation:
        "Ce mouvement a abordé des sujets tels que l'égalité salariale et la sexualité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le principal cadre juridique de protection des droits de l'homme en Europe ?",
    options: [
      "La Déclaration de Genève",
      "La Convention européenne des droits de l'homme",
      "La Charte sociale européenne",
    ],
    answer: "La Convention européenne des droits de l'homme",
    explanation:
        "Cette convention a été adoptée en 1950 pour protéger les droits fondamentaux en Europe.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement historique a eu lieu le 20 juillet 1969 ?",
    options: [
      "Première étape sur la Lune",
      "Guerre du Vietnam",
      "Chute du mur de Berlin",
    ],
    answer: "Première étape sur la Lune",
    explanation:
        "L'astronaute Neil Armstrong a été le premier homme à marcher sur la Lune lors de la mission Apollo 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été à l'origine du mouvement d'indépendance en Afrique au XXe siècle ?",
    options: ["Ghana", "Soudan", "Nigeria"],
    answer: "Ghana",
    explanation:
        "Le Ghana a été le premier pays africain à obtenir son indépendance en 1957.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle crise économique majeure a débuté en 2008 ?",
    options: [
      "La crise asiatique",
      "La crise des subprimes",
      "La crise financière de 1929",
    ],
    answer: "La crise des subprimes",
    explanation:
        "Cette crise a été causée par l'effondrement du marché immobilier américain et a eu des répercussions mondiales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle organisation a été créée après la Seconde Guerre mondiale pour favoriser la paix et la coopération internationale ?",
    options: ["NATO", "G7", "ONU"],
    answer: "ONU",
    explanation:
        "L'Organisation des Nations Unies a été fondée en 1945 pour promouvoir la paix et la sécurité dans le monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle catastrophe environnementale a eu lieu en 1986 en Ukraine ?",
    options: ["Inondation", "Tremblement de terre", "Accident nucléaire"],
    answer: "Accident nucléaire",
    explanation:
        "L'accident de Tchernobyl a été l'une des pires catastrophes nucléaires de l'histoire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement social a pris de l'ampleur grâce aux réseaux sociaux dans les années 2010 ?",
    options: ["Occupy Wall Street", "Black Lives Matter", "Fridays for Future"],
    answer: "Black Lives Matter",
    explanation:
        "Ce mouvement utilise les réseaux sociaux pour organiser des manifestations contre le racisme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été l'hôte de la Coupe du Monde de Rugby en 2015 ?",
    options: ["Angleterre", "Nouvelle-Zélande", "Australie"],
    answer: "Angleterre",
    explanation:
        "La Coupe du Monde de Rugby 2015 s'est déroulée en Angleterre, attirant des équipes du monde entier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le principal sujet de la Déclaration universelle des droits de l'homme adoptée en 1948 ?",
    options: ["Droits économiques", "Droits politiques", "Droits fondamentaux"],
    answer: "Droits fondamentaux",
    explanation:
        "Cette déclaration vise à protéger les droits et libertés de chaque individu dans le monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été le premier astronaute à voyager dans l'espace ?",
    options: ["Yuri Gagarin", "Neil Armstrong", "Buzz Aldrin"],
    answer: "Yuri Gagarin",
    explanation:
        "Yuri Gagarin a été le premier homme à aller dans l'espace en 1961 à bord de Vostok 1.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle plateforme de médias sociaux est devenue très influente dans les mouvements sociaux actuels ?",
    options: ["Facebook", "Instagram", "Twitter"],
    answer: "Twitter",
    explanation:
        "Twitter est souvent utilisé pour organiser et promouvoir des mouvements sociaux en temps réel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été touché par un tremblement de terre dévastateur en 2010 ?",
    options: ["Chili", "Haïti", "Japon"],
    answer: "Haïti",
    explanation:
        "Le tremblement de terre de 2010 en Haïti a causé des dizaines de milliers de morts et des destructions massives.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement de protestation a eu lieu en France contre le projet de réforme des retraites en 2019 ?",
    options: [
      "Les Gilets Jaunes",
      "La grève des transports",
      "La lutte pour le climat",
    ],
    answer: "La grève des transports",
    explanation:
        "Cette grève a été organisée pour s'opposer aux réformes qui menaçaient les droits des travailleurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel traité a été signé pour promouvoir la paix et l'unité en Europe après la Seconde Guerre mondiale ?",
    options: ["Traité de Lisbonne", "Traité de Rome", "Traité de Maastricht"],
    answer: "Traité de Rome",
    explanation:
        "Le traité de Rome en 1957 a établi la Communauté économique européenne, préfigurant l'Union européenne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a eu lieu en Arabie Saoudite en 2018 concernant les droits des femmes ?",
    options: [
      "Le droit de conduire",
      "Le droit de voter",
      "Le droit de travailler",
    ],
    answer: "Le droit de conduire",
    explanation:
        "En 2018, l'Arabie Saoudite a levé l'interdiction pour les femmes de conduire, un changement historique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a voté pour adopter l'euro comme monnaie officielle en 2002 ?",
    options: ["Italie", "Espagne", "France"],
    answer: "France",
    explanation:
        "La France a adopté l'euro comme monnaie officielle avec l'introduction de billets et de pièces en 2002.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel évènement sportif a eu lieu à Londres en 2012 ?",
    options: [
      "Jeux Olympiques d'été",
      "Coupe du Monde de football",
      "Championnat d'Europe de football",
    ],
    answer: "Jeux Olympiques d'été",
    explanation:
        "Les Jeux Olympiques d'été de Londres ont attiré des athlètes du monde entier en 2012.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays d'Asie a connu une révolution pacifique en 1986 appelée la Révolution Édienne ?",
    options: ["Philippines", "Malaisie", "Thaïlande"],
    answer: "Philippines",
    explanation:
        "La Révolution Édienne a abouti à la chute du dictateur Ferdinand Marcos en 1986.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement a été lancé pour promouvoir la consommation responsable et la durabilité ?",
    options: ["Slow Food", "Greenpeace", "Fridays for Future"],
    answer: "Fridays for Future",
    explanation:
        "Fridays for Future appelle à des actions pour lutter contre le changement climatique et promouvoir un avenir durable.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement historique s'est produit le 4 novembre 2008 aux États-Unis ?",
    options: [
      "Élection de Barack Obama",
      "Attentat contre les tours jumelles",
      "Crise financière",
    ],
    answer: "Élection de Barack Obama",
    explanation:
        "Barack Obama a été élu en tant que premier président afro-américain des États-Unis ce jour-là.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel important événement a eu lieu en 2011 en Libye ?",
    options: [
      "Révolution libyenne",
      "Découverte de pétrole",
      "Election présidentielle",
    ],
    answer: "Révolution libyenne",
    explanation:
        "La Révolution libyenne a conduit à la chute du régime de Mouammar Kadhafi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom du programme de santé publique mis en place par Barack Obama ?",
    options: ["Medicare", "Obamacare", "Medicaid"],
    answer: "Obamacare",
    explanation:
        "Obamacare a été conçu pour élargir l'accès aux soins de santé aux Américains.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été à l'origine de la découverte du vaccin contre la poliomyélite ?",
    options: ["États-Unis", "Royaume-Uni", "France"],
    answer: "États-Unis",
    explanation:
        "Le vaccin contre la poliomyélite a été développé par Jonas Salk aux États-Unis dans les années 1950.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement historique a eu lieu en 2004 en Indonésie ?",
    options: [
      "Séisme et tsunami",
      "Election présidentielle",
      "Réforme constitutionnelle",
    ],
    answer: "Séisme et tsunami",
    explanation:
        "Un tremblement de terre sous-marin a provoqué un tsunami dévastateur en Indonésie, causant de nombreuses pertes humaines.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement a été lancé par des étudiants pour sensibiliser au changement climatique en 2018 ?",
    options: ["Fridays for Future", "Youth for Climate", "Climate Strike"],
    answer: "Fridays for Future",
    explanation:
        "Ce mouvement a été initié par Greta Thunberg pour inciter les gouvernements à agir contre le changement climatique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel était le principal sujet traité lors de la COP21 à Paris en 2015 ?",
    options: [
      "La biodiversité",
      "Le changement climatique",
      "L'énergie renouvelable",
    ],
    answer: "Le changement climatique",
    explanation:
        "La COP21 visait à établir un accord international pour limiter le réchauffement climatique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement marquant a eu lieu aux États-Unis le 11 septembre 2001 ?",
    options: [
      "Une élection présidentielle",
      "Une attaque terroriste",
      "Une course automobile",
    ],
    answer: "Une attaque terroriste",
    explanation:
        "Des groupes terroristes ont attaqué le World Trade Center et le Pentagone, causant des milliers de morts.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel prix Nobel a été attribué à Malala Yousafzai pour son combat en faveur de l'éducation ?",
    options: ["Paix", "Littérature", "Médecine"],
    answer: "Paix",
    explanation:
        "Malala a reçu le prix Nobel de la paix en 2014 pour son engagement en faveur de l'éducation des filles.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "En quelle année a eu lieu le Brexit, l'élection qui a décidé de la sortie du Royaume-Uni de l'Union européenne ?",
    options: ["2015", "2016", "2017"],
    answer: "2016",
    explanation:
        "Le référendum sur le Brexit a eu lieu le 23 juin 2016 avec un vote pour la sortie de l'UE.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement a pour slogan 'Black Lives Matter' ?",
    options: [
      "Mouvement pour la justice sociale",
      "Mouvement environnemental",
      "Mouvement pour les droits des animaux",
    ],
    answer: "Mouvement pour la justice sociale",
    explanation:
        "Ce mouvement lutte contre les violences policières envers les Afro-Américains et pour l'égalité raciale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre accord a été signé en 1993 pour établir des relations entre Israël et l'Organisation de libération de la Palestine (OLP) ?",
    options: ["Accords de Camp David", "Accords d'Oslo", "Accords de Paris"],
    answer: "Accords d'Oslo",
    explanation:
        "Les Accords d'Oslo ont marqué la première reconnaissance mutuelle entre Israël et l'OLP.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel incident a déclenché le mouvement des Gilets Jaunes en France en 2018 ?",
    options: [
      "L'augmentation des taxes sur l'essence",
      "La réforme des retraites",
      "Les élections municipales",
    ],
    answer: "L'augmentation des taxes sur l'essence",
    explanation:
        "L'augmentation des taxes sur le carburant a suscité une forte opposition populaire et des manifestations.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom de la célèbre activiste suédoise pour le climat, connue pour ses discours puissants ?",
    options: ["Greta Thunberg", "Malala Yousafzai", "Emma Watson"],
    answer: "Greta Thunberg",
    explanation:
        "Greta Thunberg a gagné une notoriété mondiale pour sa défense urgente des questions climatiques.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a accueilli les Jeux Olympiques d'été en 2016 ?",
    options: ["Brésil", "France", "Japon"],
    answer: "Brésil",
    explanation:
        "Les Jeux Olympiques d'été de 2016 se sont tenus à Rio de Janeiro, au Brésil.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Dans quelle ville se trouve le siège de l'ONU ?",
    options: ["Paris", "New York", "Genève"],
    answer: "New York",
    explanation:
        "Le siège des Nations Unies est situé à New York, aux États-Unis, depuis sa fondation.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été le premier à légaliser le mariage homosexuel ?",
    options: ["Les États-Unis", "Les Pays-Bas", "La France"],
    answer: "Les Pays-Bas",
    explanation:
        "Les Pays-Bas ont légalisé le mariage entre personnes de même sexe en 2001, devenant les premiers à le faire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a été déclenché par la mort de George Floyd en 2020 ?",
    options: [
      "Les manifestations pour la justice climatique",
      "Les manifestations pour les droits civiques",
      "Les manifestations pour l'égalité des droits",
    ],
    answer: "Les manifestations pour les droits civiques",
    explanation:
        "La mort de George Floyd a provoqué des manifestations mondiales contre le racisme et les violences policières.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel traité a été signé pour mettre fin à la Première Guerre mondiale ?",
    options: [
      "Traité de Versailles",
      "Traité de Trianon",
      "Traité de Saint-Germain",
    ],
    answer: "Traité de Versailles",
    explanation:
        "Le traité de Versailles a été signé en 1919 pour définir les conditions de paix après la Première Guerre mondiale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement de protestation a débuté en 2019 pour défendre un mode de vie durable ?",
    options: ["Extinction Rebellion", "Fridays for Future", "Greenpeace"],
    answer: "Extinction Rebellion",
    explanation:
        "Extinction Rebellion vise à inciter les gouvernements à agir rapidement contre le changement climatique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel traité a créé l'Union européenne en 1993 ?",
    options: ["Traité de Maastricht", "Traité de Lisbonne", "Traité de Rome"],
    answer: "Traité de Maastricht",
    explanation:
        "Le traité de Maastricht a établi les bases de l'Union européenne et de l'euro.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement social a vu le jour aux États-Unis en réponse à la brutalité policière ?",
    options: ["Occupy Wall Street", "MeToo", "Black Lives Matter"],
    answer: "Black Lives Matter",
    explanation:
        "Ce mouvement vise à dénoncer les violences policières à l'encontre des Afro-Américains.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été le premier à abolir la peine de mort ?",
    options: ["France", "Royaume-Uni", "Portugal"],
    answer: "Portugal",
    explanation:
        "Le Portugal a aboli la peine de mort en 1867, devenant le premier pays au monde à le faire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre procès a eu lieu en 1995 concernant un ancien footballeur américain ?",
    options: [
      "Le procès de O.J. Simpson",
      "Le procès de Michael Jackson",
      "Le procès de Bill Cosby",
    ],
    answer: "Le procès de O.J. Simpson",
    explanation:
        "O.J. Simpson a été acquitté des accusations de meurtre lors d'un procès très médiatisé.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a été célébré à Paris pour la première fois en 1889 ?",
    options: [
      "L'Exposition universelle",
      "Le Tour de France",
      "Le Festival de Cannes",
    ],
    answer: "L'Exposition universelle",
    explanation:
        "L'Exposition universelle de 1889 a marqué le centenaire de la Révolution française.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre mouvement féministe a commencé dans les années 1960 ?",
    options: ["MeToo", "Suffragette", "Deuxième vague féministe"],
    answer: "Deuxième vague féministe",
    explanation:
        "Ce mouvement a abordé des sujets tels que l'égalité salariale et la sexualité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le principal cadre juridique de protection des droits de l'homme en Europe ?",
    options: [
      "La Déclaration de Genève",
      "La Convention européenne des droits de l'homme",
      "La Charte sociale européenne",
    ],
    answer: "La Convention européenne des droits de l'homme",
    explanation:
        "Cette convention a été adoptée en 1950 pour protéger les droits fondamentaux en Europe.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement historique a eu lieu le 20 juillet 1969 ?",
    options: [
      "Première étape sur la Lune",
      "Guerre du Vietnam",
      "Chute du mur de Berlin",
    ],
    answer: "Première étape sur la Lune",
    explanation:
        "L'astronaute Neil Armstrong a été le premier homme à marcher sur la Lune lors de la mission Apollo 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été à l'origine du mouvement d'indépendance en Afrique au XXe siècle ?",
    options: ["Ghana", "Soudan", "Nigeria"],
    answer: "Ghana",
    explanation:
        "Le Ghana a été le premier pays africain à obtenir son indépendance en 1957.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle crise économique majeure a débuté en 2008 ?",
    options: [
      "La crise asiatique",
      "La crise des subprimes",
      "La crise financière de 1929",
    ],
    answer: "La crise des subprimes",
    explanation:
        "Cette crise a été causée par l'effondrement du marché immobilier américain et a eu des répercussions mondiales.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle organisation a été créée après la Seconde Guerre mondiale pour favoriser la paix et la coopération internationale ?",
    options: ["NATO", "G7", "ONU"],
    answer: "ONU",
    explanation:
        "L'Organisation des Nations Unies a été fondée en 1945 pour promouvoir la paix et la sécurité dans le monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle catastrophe environnementale a eu lieu en 1986 en Ukraine ?",
    options: ["Inondation", "Tremblement de terre", "Accident nucléaire"],
    answer: "Accident nucléaire",
    explanation:
        "L'accident de Tchernobyl a été l'une des pires catastrophes nucléaires de l'histoire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement social a pris de l'ampleur grâce aux réseaux sociaux dans les années 2010 ?",
    options: ["Occupy Wall Street", "Black Lives Matter", "Fridays for Future"],
    answer: "Black Lives Matter",
    explanation:
        "Ce mouvement utilise les réseaux sociaux pour organiser des manifestations contre le racisme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été l'hôte de la Coupe du Monde de Rugby en 2015 ?",
    options: ["Angleterre", "Nouvelle-Zélande", "Australie"],
    answer: "Angleterre",
    explanation:
        "La Coupe du Monde de Rugby 2015 s'est déroulée en Angleterre, attirant des équipes du monde entier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le principal sujet de la Déclaration universelle des droits de l'homme adoptée en 1948 ?",
    options: ["Droits économiques", "Droits politiques", "Droits fondamentaux"],
    answer: "Droits fondamentaux",
    explanation:
        "Cette déclaration vise à protéger les droits et libertés de chaque individu dans le monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été le premier astronaute à voyager dans l'espace ?",
    options: ["Yuri Gagarin", "Neil Armstrong", "Buzz Aldrin"],
    answer: "Yuri Gagarin",
    explanation:
        "Yuri Gagarin a été le premier homme à aller dans l'espace en 1961 à bord de Vostok 1.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle plateforme de médias sociaux est devenue très influente dans les mouvements sociaux actuels ?",
    options: ["Facebook", "Instagram", "Twitter"],
    answer: "Twitter",
    explanation:
        "Twitter est souvent utilisé pour organiser et promouvoir des mouvements sociaux en temps réel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été touché par un tremblement de terre dévastateur en 2010 ?",
    options: ["Chili", "Haïti", "Japon"],
    answer: "Haïti",
    explanation:
        "Le tremblement de terre de 2010 en Haïti a causé des dizaines de milliers de morts et des destructions massives.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement de protestation a eu lieu en France contre le projet de réforme des retraites en 2019 ?",
    options: [
      "Les Gilets Jaunes",
      "La grève des transports",
      "La lutte pour le climat",
    ],
    answer: "La grève des transports",
    explanation:
        "Cette grève a été organisée pour s'opposer aux réformes qui menaçaient les droits des travailleurs.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel traité a été signé pour promouvoir la paix et l'unité en Europe après la Seconde Guerre mondiale ?",
    options: ["Traité de Lisbonne", "Traité de Rome", "Traité de Maastricht"],
    answer: "Traité de Rome",
    explanation:
        "Le traité de Rome en 1957 a établi la Communauté économique européenne, préfigurant l'Union européenne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a eu lieu en Arabie Saoudite en 2018 concernant les droits des femmes ?",
    options: [
      "Le droit de conduire",
      "Le droit de voter",
      "Le droit de travailler",
    ],
    answer: "Le droit de conduire",
    explanation:
        "En 2018, l'Arabie Saoudite a levé l'interdiction pour les femmes de conduire, un changement historique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a voté pour adopter l'euro comme monnaie officielle en 2002 ?",
    options: ["Italie", "Espagne", "France"],
    answer: "France",
    explanation:
        "La France a adopté l'euro comme monnaie officielle avec l'introduction de billets et de pièces en 2002.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel évènement sportif a eu lieu à Londres en 2012 ?",
    options: [
      "Jeux Olympiques d'été",
      "Coupe du Monde de football",
      "Championnat d'Europe de football",
    ],
    answer: "Jeux Olympiques d'été",
    explanation:
        "Les Jeux Olympiques d'été de Londres ont attiré des athlètes du monde entier en 2012.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays d'Asie a connu une révolution pacifique en 1986 appelée la Révolution Édienne ?",
    options: ["Philippines", "Malaisie", "Thaïlande"],
    answer: "Philippines",
    explanation:
        "La Révolution Édienne a abouti à la chute du dictateur Ferdinand Marcos en 1986.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement a été lancé pour promouvoir la consommation responsable et la durabilité ?",
    options: ["Slow Food", "Greenpeace", "Fridays for Future"],
    answer: "Fridays for Future",
    explanation:
        "Fridays for Future appelle à des actions pour lutter contre le changement climatique et promouvoir un avenir durable.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement historique s'est produit le 4 novembre 2008 aux États-Unis ?",
    options: [
      "Élection de Barack Obama",
      "Attentat contre les tours jumelles",
      "Crise financière",
    ],
    answer: "Élection de Barack Obama",
    explanation:
        "Barack Obama a été élu en tant que premier président afro-américain des États-Unis ce jour-là.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel important événement a eu lieu en 2011 en Libye ?",
    options: [
      "Révolution libyenne",
      "Découverte de pétrole",
      "Election présidentielle",
    ],
    answer: "Révolution libyenne",
    explanation:
        "La Révolution libyenne a conduit à la chute du régime de Mouammar Kadhafi.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom du programme de santé publique mis en place par Barack Obama ?",
    options: ["Medicare", "Obamacare", "Medicaid"],
    answer: "Obamacare",
    explanation:
        "Obamacare a été conçu pour élargir l'accès aux soins de santé aux Américains.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été à l'origine de la découverte du vaccin contre la poliomyélite ?",
    options: ["États-Unis", "Royaume-Uni", "France"],
    answer: "États-Unis",
    explanation:
        "Le vaccin contre la poliomyélite a été développé par Jonas Salk aux États-Unis dans les années 1950.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement historique a eu lieu en 2004 en Indonésie ?",
    options: [
      "Séisme et tsunami",
      "Election présidentielle",
      "Réforme constitutionnelle",
    ],
    answer: "Séisme et tsunami",
    explanation:
        "Un tremblement de terre sous-marin a provoqué un tsunami dévastateur en Indonésie, causant de nombreuses pertes humaines.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le fleuve qui traverse Paris ?",
    options: ["La Seine", "Le Rhône", "La Loire"],
    answer: "La Seine",
    explanation: "La Seine est le fleuve qui traverse la ville de Paris.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement majeur a eu lieu en 1789 en France ?",
    options: [
      "La Révolution française",
      "La guerre de 100 ans",
      "L'Exposition universelle",
    ],
    answer: "La Révolution française",
    explanation:
        "La Révolution française a commencé en 1789 et a fortement influencé l'histoire de France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la monnaie utilisée en France ?",
    options: ["Dollar", "Livre", "Euro"],
    answer: "Euro",
    explanation: "L'euro est la monnaie officielle de la France depuis 2002.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le nom de la célèbre tour située à Paris ?",
    options: ["Tour de Londres", "Tour Eiffel", "Empire State Building"],
    answer: "Tour Eiffel",
    explanation:
        "La Tour Eiffel est un symbole emblématique de Paris, construite pour l'Exposition de 1889.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui est le président de la France en 2023 ?",
    options: ["François Hollande", "Emmanuel Macron", "Nicolas Sarkozy"],
    answer: "Emmanuel Macron",
    explanation:
        "Emmanuel Macron est le président de la France depuis mai 2017.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est l'organe législatif en France ?",
    options: ["Le Congrès", "L'Assemblée nationale", "Le Sénat américain"],
    answer: "L'Assemblée nationale",
    explanation:
        "L'Assemblée nationale est l'une des deux chambres du Parlement français.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le principal événement sportif français ?",
    options: [
      "Le Tour de France",
      "Les Jeux Olympiques",
      "La Coupe du Monde de football",
    ],
    answer: "Le Tour de France",
    explanation:
        "Le Tour de France est une course cycliste prestigieuse qui a lieu chaque année.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "En quelle année a eu lieu la première guerre mondiale ?",
    options: ["1914", "1939", "1865"],
    answer: "1914",
    explanation:
        "La première guerre mondiale a commencé en 1914 et a duré jusqu'en 1918.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été le premier à abolir la peine de mort ?",
    options: ["France", "Royaume-Uni", "Finlande"],
    answer: "France",
    explanation: "La France a aboli la peine de mort en 1981.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le plus grand océan du monde ?",
    options: ["L'océan Indien", "L'océan Atlantique", "L'océan Pacifique"],
    answer: "L'océan Pacifique",
    explanation: "L'océan Pacifique est le plus grand océan du monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom de la célèbre peinture de Léonard de Vinci représentant une femme souriante ?",
    options: ["La Nuit étoilée", "La Joconde", "Le Cri"],
    answer: "La Joconde",
    explanation:
        "La Joconde est l'œuvre la plus célèbre de Léonard de Vinci, exposée au Louvre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a inventé l'imprimerie ?",
    options: ["Johannes Gutenberg", "Isaac Newton", "Albert Einstein"],
    answer: "Johannes Gutenberg",
    explanation:
        "Johannes Gutenberg est célèbre pour avoir inventé l'imprimerie au XVe siècle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays est connu pour ses pyramides ?",
    options: ["Grèce", "Egypte", "Mexique"],
    answer: "Egypte",
    explanation:
        "L'Égypte est mondialement connue pour ses pyramides, notamment celles de Gizeh.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été le premier homme sur la Lune ?",
    options: ["Neil Armstrong", "Yuri Gagarin", "John Glenn"],
    answer: "Neil Armstrong",
    explanation:
        "Neil Armstrong a été le premier homme à poser le pied sur la Lune en 1969.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le symbole national de la France ?",
    options: ["Le coq", "Le lion", "L'aigle"],
    answer: "Le coq",
    explanation: "Le coq est considéré comme le symbole national de la France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement artistique est associé à Pablo Picasso ?",
    options: ["Impressionnisme", "Cubisme", "Surréalisme"],
    answer: "Cubisme",
    explanation:
        "Pablo Picasso est l'un des fondateurs du mouvement cubiste au début du XXe siècle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le nom du célèbre festival de cinéma à Cannes ?",
    options: ["Festival de Berlin", "Festival de Cannes", "Festival de Venise"],
    answer: "Festival de Cannes",
    explanation:
        "Le Festival de Cannes est l'un des festivals de cinéma les plus prestigieux au monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est l'artisan célèbre pour ses macarons à Paris ?",
    options: ["Ladurée", "Pierre Hermé", "Fauchon"],
    answer: "Ladurée",
    explanation:
        "Ladurée est renommée pour ses macarons et pâtisseries à Paris.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel océan sépare l'Afrique de l'Amérique du Sud ?",
    options: ["Océan Atlantique", "Océan Indien", "Océan Arctique"],
    answer: "Océan Atlantique",
    explanation: "L'océan Atlantique sépare l'Afrique de l'Amérique du Sud.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle République est réputée pour sa cuisine raffinée ?",
    options: ["France", "Allemagne", "Italie"],
    answer: "France",
    explanation:
        "La France est mondialement reconnue pour sa cuisine et ses spécialités gastronomiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom de la célèbre avenue de Paris connue pour ses boutiques ?",
    options: ["Champs-Élysées", "Boulevard Saint-Germain", "Rue de Rivoli"],
    answer: "Champs-Élysées",
    explanation:
        "Les Champs-Élysées sont célèbres pour leurs boutiques et leurs cafés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel chef d'État a établi la Ve République en France ?",
    options: ["Charles de Gaulle", "François Mitterrand", "Jacques Chirac"],
    answer: "Charles de Gaulle",
    explanation:
        "Charles de Gaulle a fondé la Ve République en France en 1958.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a lieu chaque 14 juillet en France ?",
    options: ["La fête nationale", "Noël", "Pâques"],
    answer: "La fête nationale",
    explanation:
        "Le 14 juillet est célébré comme la fête nationale de la France, commémorant la prise de la Bastille.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est l'actuel nom de l'ancienne URSS ?",
    options: ["Russie", "Ukraine", "Biélorussie"],
    answer: "Russie",
    explanation:
        "La Russie est le principal pays successeur de l'ancienne Union soviétique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le puissant courant océanique qui influence le climat de l'Europe ?",
    options: ["Gulf Stream", "Nordatlantique", "Kuroshio"],
    answer: "Gulf Stream",
    explanation:
        "Le Gulf Stream est un courant océanique qui réchauffe le climat en Europe.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le but du parlement européen ?",
    options: [
      "Élaborer des lois",
      "Créer une armée",
      "Organiser des élections",
    ],
    answer: "Élaborer des lois",
    explanation:
        "Le Parlement européen élabore des lois qui s'appliquent dans l'Union européenne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la langue officielle de la France ?",
    options: ["Anglais", "Espagnol", "Français"],
    answer: "Français",
    explanation:
        "Le français est la langue officielle de la République française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été le premier ministre français après Jacques Chirac ?",
    options: ["Lionel Jospin", "François Hollande", "Dominique de Villepin"],
    answer: "Dominique de Villepin",
    explanation:
        "Dominique de Villepin a été Premier ministre de France de 2005 à 2007.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a remporté la coupe du monde de football en 1998 ?",
    options: ["Allemagne", "France", "Brésil"],
    answer: "France",
    explanation:
        "La France a remporté sa première Coupe du Monde de football en 1998 sur son sol.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom du célèbre monument de Paris construit en arc-de-triomphe ?",
    options: ["Arc de Triomphe", "Sainte-Chapelle", "Palais Garnier"],
    answer: "Arc de Triomphe",
    explanation:
        "L'Arc de Triomphe célèbre les victoires militaires de la France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la principale institution judiciaire française ?",
    options: ["Cours suprême", "Conseil constitutionnel", "Cour de cassation"],
    answer: "Cour de cassation",
    explanation:
        "La Cour de cassation est la plus haute juridiction de l'ordre judiciaire français.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle ville est célèbre pour son festival de jazz ?",
    options: ["New Orleans", "Dublin", "Nice"],
    answer: "New Orleans",
    explanation:
        "New Orleans est célèbre pour son festival de jazz qui attire des musiciens du monde entier.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le plus grand pays du monde ?",
    options: ["Canada", "Chine", "Russie"],
    answer: "Russie",
    explanation:
        "La Russie est le plus grand pays du monde en termes de superficie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays est connu comme le berceau de la démocratie ?",
    options: ["Grèce", "France", "Royaume-Uni"],
    answer: "Grèce",
    explanation:
        "La Grèce est connue comme le berceau de la démocratie, notamment à Athènes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le monument symbole de l'Amérique ?",
    options: ["Statue de la Liberté", "Mont Rushmore", "Empire State Building"],
    answer: "Statue de la Liberté",
    explanation:
        "La Statue de la Liberté est un symbole emblématique des États-Unis, offerte par la France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel personnage historique a dirigé la France pendant la Révolution française ?",
    options: ["Napoléon Bonaparte", "Georges Danton", "Louis XVI"],
    answer: "Georges Danton",
    explanation:
        "Georges Danton était l'un des principaux leaders pendant la Révolution française.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a remporté la Coupe du monde de football 2018 ?",
    options: ["France", "Allemagne", "Argentine"],
    answer: "France",
    explanation:
        "La France a remporté la Coupe du monde de football 2018 en Russie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a lieu chaque année à Paris en mars ?",
    options: ["La Fashion Week", "La Nuit des musées", "Le Salon du livre"],
    answer: "Le Salon du livre",
    explanation:
        "Le Salon du livre est un événement majeur pour les amateurs de littérature à Paris.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le nom du célèbre château dans la vallée de la Loire ?",
    options: [
      "Château de Chambord",
      "Château de Versailles",
      "Château de Fontainebleau",
    ],
    answer: "Château de Chambord",
    explanation:
        "Le château de Chambord est un exemple emblématique de l'architecture de la Renaissance en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "En 1969, qui a marché sur la Lune en premier ?",
    options: ["Buzz Aldrin", "Neil Armstrong", "Michael Collins"],
    answer: "Neil Armstrong",
    explanation:
        "Neil Armstrong a été le premier homme à marcher sur la Lune lors de la mission Apollo 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est l'auteur de 'Cyrano de Bergerac' ?",
    options: ["Victor Hugo", "Edmond Rostand", "Molière"],
    answer: "Edmond Rostand",
    explanation:
        "Edmond Rostand a écrit la célèbre pièce 'Cyrano de Bergerac' au début du XXe siècle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été la première femme à diriger un pays en Europe ?",
    options: ["Margaret Thatcher", "Angela Merkel", "Élisabeth Ière"],
    answer: "Élisabeth Ière",
    explanation:
        "Élisabeth Ière a été la première femme à régner sur un pays européen, l'Angleterre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le nom de la célèbre cathédrale de Paris ?",
    options: ["Notre-Dame", "Sainte-Sophie", "Saint-Pierre"],
    answer: "Notre-Dame",
    explanation:
        "Notre-Dame est une cathédrale emblématique de Paris, connue pour son architecture gothique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel artiste est associé au mouvement surréaliste ?",
    options: ["Salvador Dalí", "Claude Monet", "Henri Matisse"],
    answer: "Salvador Dalí",
    explanation:
        "Salvador Dalí est l'un des artistes les plus célèbres du mouvement surréaliste.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la plus grande ville du Canada ?",
    options: ["Toronto", "Vancouver", "Montréal"],
    answer: "Toronto",
    explanation:
        "Toronto est la plus grande ville du Canada en termes de population.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays d'Asie est connu pour sa grande muraille ?",
    options: ["Inde", "Chine", "Japon"],
    answer: "Chine",
    explanation:
        "La Grande Muraille de Chine est l'une des merveilles du monde, symbole du pays.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le fleuve qui traverse Paris ?",
    options: ["La Seine", "Le Rhône", "La Loire"],
    answer: "La Seine",
    explanation: "La Seine est le fleuve qui traverse la ville de Paris.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement majeur a eu lieu en 1789 en France ?",
    options: [
      "La Révolution française",
      "La guerre de 100 ans",
      "L'Exposition universelle",
    ],
    answer: "La Révolution française",
    explanation:
        "La Révolution française a commencé en 1789 et a fortement influencé l'histoire de France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la monnaie utilisée en France ?",
    options: ["Dollar", "Livre", "Euro"],
    answer: "Euro",
    explanation: "L'euro est la monnaie officielle de la France depuis 2002.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le nom de la célèbre tour située à Paris ?",
    options: ["Tour de Londres", "Tour Eiffel", "Empire State Building"],
    answer: "Tour Eiffel",
    explanation:
        "La Tour Eiffel est un symbole emblématique de Paris, construite pour l'Exposition de 1889.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui est le président de la France en 2023 ?",
    options: ["François Hollande", "Emmanuel Macron", "Nicolas Sarkozy"],
    answer: "Emmanuel Macron",
    explanation:
        "Emmanuel Macron est le président de la France depuis mai 2017.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est l'organe législatif en France ?",
    options: ["Le Congrès", "L'Assemblée nationale", "Le Sénat américain"],
    answer: "L'Assemblée nationale",
    explanation:
        "L'Assemblée nationale est l'une des deux chambres du Parlement français.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le principal événement sportif français ?",
    options: [
      "Le Tour de France",
      "Les Jeux Olympiques",
      "La Coupe du Monde de football",
    ],
    answer: "Le Tour de France",
    explanation:
        "Le Tour de France est une course cycliste prestigieuse qui a lieu chaque année.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "En quelle année a eu lieu la première guerre mondiale ?",
    options: ["1914", "1939", "1865"],
    answer: "1914",
    explanation:
        "La première guerre mondiale a commencé en 1914 et a duré jusqu'en 1918.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été le premier à abolir la peine de mort ?",
    options: ["France", "Royaume-Uni", "Finlande"],
    answer: "France",
    explanation: "La France a aboli la peine de mort en 1981.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le plus grand océan du monde ?",
    options: ["L'océan Indien", "L'océan Atlantique", "L'océan Pacifique"],
    answer: "L'océan Pacifique",
    explanation: "L'océan Pacifique est le plus grand océan du monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom de la célèbre peinture de Léonard de Vinci représentant une femme souriante ?",
    options: ["La Nuit étoilée", "La Joconde", "Le Cri"],
    answer: "La Joconde",
    explanation:
        "La Joconde est l'œuvre la plus célèbre de Léonard de Vinci, exposée au Louvre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a inventé l'imprimerie ?",
    options: ["Johannes Gutenberg", "Isaac Newton", "Albert Einstein"],
    answer: "Johannes Gutenberg",
    explanation:
        "Johannes Gutenberg est célèbre pour avoir inventé l'imprimerie au XVe siècle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays est connu pour ses pyramides ?",
    options: ["Grèce", "Egypte", "Mexique"],
    answer: "Egypte",
    explanation:
        "L'Égypte est mondialement connue pour ses pyramides, notamment celles de Gizeh.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été le premier homme sur la Lune ?",
    options: ["Neil Armstrong", "Yuri Gagarin", "John Glenn"],
    answer: "Neil Armstrong",
    explanation:
        "Neil Armstrong a été le premier homme à poser le pied sur la Lune en 1969.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le symbole national de la France ?",
    options: ["Le coq", "Le lion", "L'aigle"],
    answer: "Le coq",
    explanation: "Le coq est considéré comme le symbole national de la France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement artistique est associé à Pablo Picasso ?",
    options: ["Impressionnisme", "Cubisme", "Surréalisme"],
    answer: "Cubisme",
    explanation:
        "Pablo Picasso est l'un des fondateurs du mouvement cubiste au début du XXe siècle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le nom du célèbre festival de cinéma à Cannes ?",
    options: ["Festival de Berlin", "Festival de Cannes", "Festival de Venise"],
    answer: "Festival de Cannes",
    explanation:
        "Le Festival de Cannes est l'un des festivals de cinéma les plus prestigieux au monde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est l'artisan célèbre pour ses macarons à Paris ?",
    options: ["Ladurée", "Pierre Hermé", "Fauchon"],
    answer: "Ladurée",
    explanation:
        "Ladurée est renommée pour ses macarons et pâtisseries à Paris.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel océan sépare l'Afrique de l'Amérique du Sud ?",
    options: ["Océan Atlantique", "Océan Indien", "Océan Arctique"],
    answer: "Océan Atlantique",
    explanation: "L'océan Atlantique sépare l'Afrique de l'Amérique du Sud.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle République est réputée pour sa cuisine raffinée ?",
    options: ["France", "Allemagne", "Italie"],
    answer: "France",
    explanation:
        "La France est mondialement reconnue pour sa cuisine et ses spécialités gastronomiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom de la célèbre avenue de Paris connue pour ses boutiques ?",
    options: ["Champs-Élysées", "Boulevard Saint-Germain", "Rue de Rivoli"],
    answer: "Champs-Élysées",
    explanation:
        "Les Champs-Élysées sont célèbres pour leurs boutiques et leurs cafés.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel chef d'État a établi la Ve République en France ?",
    options: ["Charles de Gaulle", "François Mitterrand", "Jacques Chirac"],
    answer: "Charles de Gaulle",
    explanation:
        "Charles de Gaulle a fondé la Ve République en France en 1958.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a lieu chaque 14 juillet en France ?",
    options: ["La fête nationale", "Noël", "Pâques"],
    answer: "La fête nationale",
    explanation:
        "Le 14 juillet est célébré comme la fête nationale de la France, commémorant la prise de la Bastille.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est l'actuel nom de l'ancienne URSS ?",
    options: ["Russie", "Ukraine", "Biélorussie"],
    answer: "Russie",
    explanation:
        "La Russie est le principal pays successeur de l'ancienne Union soviétique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le puissant courant océanique qui influence le climat de l'Europe ?",
    options: ["Gulf Stream", "Nordatlantique", "Kuroshio"],
    answer: "Gulf Stream",
    explanation:
        "Le Gulf Stream est un courant océanique qui réchauffe le climat en Europe.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le but du parlement européen ?",
    options: [
      "Élaborer des lois",
      "Créer une armée",
      "Organiser des élections",
    ],
    answer: "Élaborer des lois",
    explanation:
        "Le Parlement européen élabore des lois qui s'appliquent dans l'Union européenne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la langue officielle de la France ?",
    options: ["Anglais", "Espagnol", "Français"],
    answer: "Français",
    explanation:
        "Le français est la langue officielle de la République française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été le premier ministre français après Jacques Chirac ?",
    options: ["Lionel Jospin", "François Hollande", "Dominique de Villepin"],
    answer: "Dominique de Villepin",
    explanation:
        "Dominique de Villepin a été Premier ministre de France de 2005 à 2007.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a remporté la coupe du monde de football en 1998 ?",
    options: ["Allemagne", "France", "Brésil"],
    answer: "France",
    explanation:
        "La France a remporté sa première Coupe du Monde de football en 1998 sur son sol.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom du célèbre monument de Paris construit en arc-de-triomphe ?",
    options: ["Arc de Triomphe", "Sainte-Chapelle", "Palais Garnier"],
    answer: "Arc de Triomphe",
    explanation:
        "L'Arc de Triomphe célèbre les victoires militaires de la France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la principale institution judiciaire française ?",
    options: ["Cours suprême", "Conseil constitutionnel", "Cour de cassation"],
    answer: "Cour de cassation",
    explanation:
        "La Cour de cassation est la plus haute juridiction de l'ordre judiciaire français.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle ville est célèbre pour son festival de jazz ?",
    options: ["New Orleans", "Dublin", "Nice"],
    answer: "New Orleans",
    explanation:
        "New Orleans est célèbre pour son festival de jazz qui attire des musiciens du monde entier.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le plus grand pays du monde ?",
    options: ["Canada", "Chine", "Russie"],
    answer: "Russie",
    explanation:
        "La Russie est le plus grand pays du monde en termes de superficie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays est connu comme le berceau de la démocratie ?",
    options: ["Grèce", "France", "Royaume-Uni"],
    answer: "Grèce",
    explanation:
        "La Grèce est connue comme le berceau de la démocratie, notamment à Athènes.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le monument symbole de l'Amérique ?",
    options: ["Statue de la Liberté", "Mont Rushmore", "Empire State Building"],
    answer: "Statue de la Liberté",
    explanation:
        "La Statue de la Liberté est un symbole emblématique des États-Unis, offerte par la France.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel personnage historique a dirigé la France pendant la Révolution française ?",
    options: ["Napoléon Bonaparte", "Georges Danton", "Louis XVI"],
    answer: "Georges Danton",
    explanation:
        "Georges Danton était l'un des principaux leaders pendant la Révolution française.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a remporté la Coupe du monde de football 2018 ?",
    options: ["France", "Allemagne", "Argentine"],
    answer: "France",
    explanation:
        "La France a remporté la Coupe du monde de football 2018 en Russie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a lieu chaque année à Paris en mars ?",
    options: ["La Fashion Week", "La Nuit des musées", "Le Salon du livre"],
    answer: "Le Salon du livre",
    explanation:
        "Le Salon du livre est un événement majeur pour les amateurs de littérature à Paris.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le nom du célèbre château dans la vallée de la Loire ?",
    options: [
      "Château de Chambord",
      "Château de Versailles",
      "Château de Fontainebleau",
    ],
    answer: "Château de Chambord",
    explanation:
        "Le château de Chambord est un exemple emblématique de l'architecture de la Renaissance en France.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "En 1969, qui a marché sur la Lune en premier ?",
    options: ["Buzz Aldrin", "Neil Armstrong", "Michael Collins"],
    answer: "Neil Armstrong",
    explanation:
        "Neil Armstrong a été le premier homme à marcher sur la Lune lors de la mission Apollo 11.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est l'auteur de 'Cyrano de Bergerac' ?",
    options: ["Victor Hugo", "Edmond Rostand", "Molière"],
    answer: "Edmond Rostand",
    explanation:
        "Edmond Rostand a écrit la célèbre pièce 'Cyrano de Bergerac' au début du XXe siècle.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été la première femme à diriger un pays en Europe ?",
    options: ["Margaret Thatcher", "Angela Merkel", "Élisabeth Ière"],
    answer: "Élisabeth Ière",
    explanation:
        "Élisabeth Ière a été la première femme à régner sur un pays européen, l'Angleterre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le nom de la célèbre cathédrale de Paris ?",
    options: ["Notre-Dame", "Sainte-Sophie", "Saint-Pierre"],
    answer: "Notre-Dame",
    explanation:
        "Notre-Dame est une cathédrale emblématique de Paris, connue pour son architecture gothique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel artiste est associé au mouvement surréaliste ?",
    options: ["Salvador Dalí", "Claude Monet", "Henri Matisse"],
    answer: "Salvador Dalí",
    explanation:
        "Salvador Dalí est l'un des artistes les plus célèbres du mouvement surréaliste.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la plus grande ville du Canada ?",
    options: ["Toronto", "Vancouver", "Montréal"],
    answer: "Toronto",
    explanation:
        "Toronto est la plus grande ville du Canada en termes de population.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays d'Asie est connu pour sa grande muraille ?",
    options: ["Inde", "Chine", "Japon"],
    answer: "Chine",
    explanation:
        "La Grande Muraille de Chine est l'une des merveilles du monde, symbole du pays.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le nom du président français élu en 2017 ?",
    options: ["François Hollande", "Emmanuel Macron", "Nicolas Sarkozy"],
    answer: "Emmanuel Macron",
    explanation:
        "Emmanuel Macron a été élu Président de la République française en mai 2017.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "En quelle année a eu lieu le Football World Cup en Russie ?",
    options: ["2016", "2018", "2020"],
    answer: "2018",
    explanation: "La Coupe du Monde de football a eu lieu en Russie en 2018.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement social a vu le jour en France en 2018 ?",
    options: ["Les Gilets Jaunes", "Les Verts", "Les Sans-Voix"],
    answer: "Les Gilets Jaunes",
    explanation:
        "Le mouvement des Gilets Jaunes a débuté en France en octobre 2018.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement majeur a marqué l'année 2020 à l'échelle mondiale ?",
    options: [
      "Le réchauffement climatique",
      "La pandémie de COVID-19",
      "Les Jeux Olympiques",
    ],
    answer: "La pandémie de COVID-19",
    explanation:
        "La pandémie de COVID-19 a eu un impact significatif sur le monde entier en 2020.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a remporté le prix Nobel de la paix en 2021 ?",
    options: ["Angela Merkel", "Abiy Ahmed", "Boris Johnson"],
    answer: "Abiy Ahmed",
    explanation:
        "Abiy Ahmed, Premier ministre éthiopien, a reçu le prix Nobel de la paix en 2019, mais reste une figure importante en 2021.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre mouvement pour la justice raciale a pris de l'ampleur en 2020 ?",
    options: ["Black Lives Matter", "MeToo", "Stop Hate"],
    answer: "Black Lives Matter",
    explanation:
        "Le mouvement Black Lives Matter a gagné en visibilité après la mort de George Floyd en mai 2020.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui est l'auteur du livre 'Sapiens' publié en 2011 ?",
    options: ["Yuval Noah Harari", "Malcolm Gladwell", "Michel Onfray"],
    answer: "Yuval Noah Harari",
    explanation:
        "Yuval Noah Harari est l'auteur du livre 'Sapiens : Une brève histoire de l'humanité'.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été au centre des tensions géopolitiques en 2014 en raison de l'annexion de la Crimée ?",
    options: ["Ukraine", "Géorgie", "Pologne"],
    answer: "Ukraine",
    explanation:
        "La Crimée a été annexée par la Russie en 2014, provoquant des tensions avec l'Ukraine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel célèbre dirigeant nord-coréen a pris le pouvoir en 2011 ?",
    options: ["Kim Il-sung", "Kim Jong-il", "Kim Jong-un"],
    answer: "Kim Jong-un",
    explanation:
        "Kim Jong-un est devenu le dirigeant suprême de la Corée du Nord en décembre 2011.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement climatique extrême a touché les États-Unis en 2005 ?",
    options: [
      "L'ouragan Katrina",
      "Le cyclone Nargis",
      "Le tremblement de terre de San Francisco",
    ],
    answer: "L'ouragan Katrina",
    explanation:
        "L'ouragan Katrina a causé d'importants dégâts aux États-Unis en 2005, notamment à La Nouvelle-Orléans.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre document a été signé en 1948 concernant les droits de l'homme ?",
    options: [
      "La Déclaration des droits de l'homme",
      "La Charte des Nations Unies",
      "Le Pacte de Varsovie",
    ],
    answer: "La Déclaration des droits de l'homme",
    explanation:
        "La Déclaration universelle des droits de l'homme a été adoptée par l'ONU en 1948.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel traité a été signé en 1992 pour établir l'Union européenne ?",
    options: ["Traité de Maastricht", "Traité de Lisbonne", "Traité de Rome"],
    answer: "Traité de Maastricht",
    explanation:
        "Le traité de Maastricht, signé en 1992, a jeté les bases de l'Union européenne.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel évènement de grande ampleur a eu lieu en France en 2015 ?",
    options: ["Les attentats de Paris", "La Coupe du Monde de rugby", "Le G20"],
    answer: "Les attentats de Paris",
    explanation:
        "Les attentats de Paris en novembre 2015 ont choqué le monde entier et marqué l'histoire récente de la France.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement de solidarité a émergé après l'incendie de la cathédrale Notre-Dame de Paris en 2019 ?",
    options: [
      "Je suis Charlie",
      "La Manif pour Tous",
      "La collecte pour Notre-Dame",
    ],
    answer: "La collecte pour Notre-Dame",
    explanation:
        "Une collecte a été lancée pour financer la restauration de Notre-Dame de Paris après l'incendie de 2019.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre événement sportif a eu lieu à Tokyo en 2021, malgré la pandémie ?",
    options: [
      "Les Jeux Olympiques d'été",
      "La Coupe du Monde de football",
      "Le Tour de France",
    ],
    answer: "Les Jeux Olympiques d'été",
    explanation:
        "Les Jeux Olympiques d'été de Tokyo ont eu lieu en 2021 après avoir été reportés en raison de la pandémie de COVID-19.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement a été déclenché par la mort de George Floyd ?",
    options: ["Black Lives Matter", "MeToo", "Teenage Climate Strike"],
    answer: "Black Lives Matter",
    explanation:
        "La mort de George Floyd a ravivé le mouvement Black Lives Matter à l'échelle mondiale en 2020.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom du célèbre accord de paix signé en 1993 entre Israël et l'OLP ?",
    options: ["Accords de Camp David", "Accords d'Oslo", "Accords de Téhéran"],
    answer: "Accords d'Oslo",
    explanation:
        "Les Accords d'Oslo, signés en 1993, ont été une étape majeure pour la paix au Proche-Orient.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a connu un coup d'État militaire en 2021 ?",
    options: ["Myanmar", "Afghanistan", "Soudan"],
    answer: "Myanmar",
    explanation:
        "Un coup d'État militaire a eu lieu au Myanmar en février 2021, renversant le gouvernement civil.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a célébré les 75 ans de la création des Nations Unies en 2020 ?",
    options: [
      "La Conférence de Paris",
      "Le Sommet de New York",
      "Le Forum de Genève",
    ],
    answer: "Le Sommet de New York",
    explanation:
        "Le Sommet de New York en 2020 a célébré le 75ème anniversaire des Nations Unies.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel célèbre entrepreneur a fondé SpaceX en 2002 ?",
    options: ["Jeff Bezos", "Elon Musk", "Mark Zuckerberg"],
    answer: "Elon Musk",
    explanation:
        "Elon Musk est le fondateur de SpaceX, une entreprise aérospatiale créée en 2002.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a connu un large mouvement de protestation contre le gouvernement en 2019, connu sous le nom de 'Révolution de la soie' ?",
    options: ["Soudan", "Hongrie", "Algérie"],
    answer: "Algérie",
    explanation:
        "La Révolution de la soie en Algérie a vu de nombreuses manifestations contre le gouvernement en 2019.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel a été le principal sujet de préoccupation lors des élections présidentielles américaines de 2020 ?",
    options: [
      "Changement climatique",
      "Économie",
      "Gestion de la pandémie de COVID-19",
    ],
    answer: "Gestion de la pandémie de COVID-19",
    explanation:
        "La gestion de la pandémie de COVID-19 était au cœur des préoccupations lors des élections de 2020.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel prix a été décerné à Greta Thunberg pour son engagement en faveur de l'environnement ?",
    options: ["Prix Nobel de la paix", "Prix Sakharov", "Prix Goldman"],
    answer: "Prix Goldman",
    explanation:
        "Greta Thunberg a reçu le Prix Goldman pour son engagement écologique et ses actions climatiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement sportif majeur a été reporté à 2020 en raison de la pandémie de COVID-19 ?",
    options: [
      "Les Jeux Olympiques d'été",
      "La Coupe du Monde de rugby",
      "Le championnat d'Europe de football",
    ],
    answer: "Les Jeux Olympiques d'été",
    explanation:
        "Les Jeux Olympiques d'été de Tokyo ont été reportés à 2021 à cause de la pandémie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a décidé de se retirer de l'accord de Paris en 2017 ?",
    options: ["Chine", "États-Unis", "Russie"],
    answer: "États-Unis",
    explanation:
        "Les États-Unis sous l'administration Trump se sont retirés de l'accord de Paris sur le climat en 2017.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre mouvement pour les droits des femmes a été popularisé par les marches de 2017 ?",
    options: ["#Metoo", "#TimesUp", "#WomenMarch"],
    answer: "#WomenMarch",
    explanation:
        "Les marches pour les femmes de 2017 ont donné naissance au mouvement #WomenMarch pour les droits des femmes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel drame humain a eu lieu en Syrie à partir de 2011 ?",
    options: ["Guerre civile", "Crise économique", "Révolte estudiantine"],
    answer: "Guerre civile",
    explanation:
        "La guerre civile syrienne a commencé en 2011 et a causé de graves souffrances humanitaires.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le sujet principal des discussions lors de la COP26 en 2021 ?",
    options: [
      "Réduction des émissions de carbone",
      "Protection des océans",
      "Lutte contre la pauvreté",
    ],
    answer: "Réduction des émissions de carbone",
    explanation:
        "La COP26 a principalement porté sur des engagements pour réduire les émissions de carbone afin de lutter contre le changement climatique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a provoqué la démission de plusieurs dirigeants politiques en Amérique Latine en 2019 ?",
    options: [
      "Crise économique",
      "Protests populaires",
      "Catastrophes naturelles",
    ],
    answer: "Protests populaires",
    explanation:
        "Des protests populaires ont secoué plusieurs pays d'Amérique Latine en 2019, entraînant la démission de dirigeants.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a adopté la loi sur le mariage pour tous en 2013 ?",
    options: ["France", "Canada", "Espagne"],
    answer: "France",
    explanation:
        "La France a légalisé le mariage pour tous en mai 2013, devenant l'un des premiers pays à le faire.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement a vu le jour en 2020 en réponse aux violences policières aux États-Unis ?",
    options: ["Black Lives Matter", "Occupy Wall Street", "Les Gilets Jaunes"],
    answer: "Black Lives Matter",
    explanation:
        "Le mouvement Black Lives Matter a réagi aux violences policières et aux inégalités raciales aux États-Unis en 2020.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel accident nucléaire a eu lieu en Ukraine en 1986 ?",
    options: ["Tchernobyl", "Fukushima", "Three Mile Island"],
    answer: "Tchernobyl",
    explanation:
        "L'accident de Tchernobyl est survenu en 1986 et est considéré comme l'une des pires catastrophes nucléaires de l'histoire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a réuni 195 pays pour lutter contre le changement climatique en 2015 ?",
    options: ["Accord de Paris", "Accord de Kyoto", "Réunion de Copenhague"],
    answer: "Accord de Paris",
    explanation:
        "L'Accord de Paris, signé en 2015, a réuni presque tous les pays pour s'engager contre le changement climatique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a remporté le prix Nobel de littérature en 2020 ?",
    options: ["Louise Glück", "Peter Handke", "Bob Dylan"],
    answer: "Louise Glück",
    explanation:
        "Louise Glück a remporté le prix Nobel de littérature en 2020 pour sa voix poétique unique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été le premier à donner le droit de vote aux femmes en 1893 ?",
    options: ["Nouvelle-Zélande", "Suisse", "Finlande"],
    answer: "Nouvelle-Zélande",
    explanation:
        "La Nouvelle-Zélande a été le premier pays à accorder le droit de vote aux femmes en 1893.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été élu président de l'Argentine en 2019 ?",
    options: ["Mauricio Macri", "Alberto Fernández", "Cristina Kirchner"],
    answer: "Alberto Fernández",
    explanation:
        "Alberto Fernández a été élu président de l'Argentine en octobre 2019.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement historique a eu lieu le 11 septembre 2001 ?",
    options: [
      "Des attentats terroristes",
      "L'éclatement de la bulle Internet",
      "L'élection de George W. Bush",
    ],
    answer: "Des attentats terroristes",
    explanation:
        "Les attentats terroristes du 11 septembre 2001 ont profondément marqué l'histoire contemporaine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a noté sa première élection présidentielle en 2005 ?",
    options: ["Irak", "Afghanistan", "Libye"],
    answer: "Irak",
    explanation:
        "L'Irak a organisé sa première élection présidentielle en 2005 après la chute de Saddam Hussein.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel célèbre journaleux a passé 18 mois en prison en 2007 ?",
    options: ["Julian Assange", "Edward Snowden", "David Kay"],
    answer: "Julian Assange",
    explanation:
        "Julian Assange, fondateur de WikiLeaks, a passé 18 mois en prison après la publication de documents sensibles.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement de protestation a débuté en Iran en 2019 ?",
    options: ["Green Movement", "Femme, Vie, Liberté", "Anti-corruption"],
    answer: "Femme, Vie, Liberté",
    explanation:
        "Le mouvement 'Femme, Vie, Liberté' a débuté en Iran en 2019 pour les droits des femmes et contre la répression.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a adopté la légalisation de la marijuana à des fins récréatives en 2018 ?",
    options: ["Canada", "Uruguay", "États-Unis"],
    answer: "Canada",
    explanation:
        "Le Canada a légalisé la marijuana à des fins récréatives en octobre 2018.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel incendie tragique a eu lieu à Paris en 2019 ?",
    options: [
      "Catastrophe de l'ABBey de Saint-Denis",
      "Incendie de Notre-Dame",
      "Incendie de la Tour Eiffel",
    ],
    answer: "Incendie de Notre-Dame",
    explanation:
        "L'incendie de Notre-Dame de Paris a eu lieu en avril 2019, causant d'importants dégâts au monument historique.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom du mouvement qui lutte pour l'égalité raciale aux États-Unis ?",
    options: ["Black Lives Matter", "Justice pour tous", "Stop Racisme"],
    answer: "Black Lives Matter",
    explanation:
        "Le mouvement Black Lives Matter se bat pour l'égalité raciale et contre les violences policières aux États-Unis.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a eu lieu en 2020 à l'initiative de la France concernant l'environnement ?",
    options: ["La COP26", "La COP21", "Le Pacte de Glasgow"],
    answer: "La COP26",
    explanation:
        "La COP26 s'est tenue à Glasgow en 2021 pour discuter des enjeux environnementaux, mais la France a été très active dans la préparation de cet événement.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a connu une guerre civile de 2011 à 2021 ?",
    options: ["Libye", "Yémen", "Syrie"],
    answer: "Syrie",
    explanation:
        "La guerre civile en Syrie a duré de 2011 jusqu'à une période récente, affectant de nombreuses vies.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a causé l'émergence du mouvement #MeToo ?",
    options: [
      "Des abus sexuels sur des femmes",
      "Des violences policières",
      "Des inégalités salariales",
    ],
    answer: "Des abus sexuels sur des femmes",
    explanation:
        "Le mouvement #MeToo a émergé en réponse à des abus sexuels répandus et à la culture du silence autour d'eux.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel traité a été signé en 2015 pour réduire les émissions de gaz à effet de serre ?",
    options: ["Accord de Paris", "Accord de Kyoto", "Accord de Tokyo"],
    answer: "Accord de Paris",
    explanation:
        "L'Accord de Paris, signé en 2015, vise à limiter le réchauffement climatique en réduisant les émissions de gaz à effet de serre.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a organisé les Jeux Olympiques d'été en 2008 ?",
    options: ["Royaume-Uni", "Chine", "France"],
    answer: "Chine",
    explanation:
        "La Chine a accueilli les Jeux Olympiques d'été de 2008 à Pékin.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été le président des États-Unis de 2009 à 2017 ?",
    options: ["George W. Bush", "Barack Obama", "Donald Trump"],
    answer: "Barack Obama",
    explanation:
        "Barack Obama a été le 44ème président des États-Unis de 2009 à 2017.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel accord a été signé pour limiter les émissions de gaz à effet de serre en 2015 ?",
    options: ["Accord de Kyoto", "Accord de Paris", "Accord de Copenhague"],
    answer: "Accord de Paris",
    explanation:
        "L'Accord de Paris est un traité international sur le changement climatique signé en 2015.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a remporté le prix Nobel de la paix en 1993 ?",
    options: ["Nelson Mandela", "Martin Luther King", "Mahatma Gandhi"],
    answer: "Nelson Mandela",
    explanation:
        "Nelson Mandela a reçu le prix Nobel de la paix pour ses efforts dans la lutte contre l'apartheid.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement historique a eu lieu le 11 septembre 2001 ?",
    options: [
      "La chute du Mur de Berlin",
      "Les attaques terroristes contre les États-Unis",
      "La guerre du Vietnam",
    ],
    answer: "Les attaques terroristes contre les États-Unis",
    explanation:
        "Le 11 septembre 2001, des attaques coordonnées ont touché le World Trade Center et le Pentagone.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement de protestation a eu lieu à Hong Kong en 2019 ?",
    options: [
      "Les Gilets Jaunes",
      "Les manifestations pro-démocratie",
      "Le Printemps arabe",
    ],
    answer: "Les manifestations pro-démocratie",
    explanation:
        "Les manifestations de 2019 à Hong Kong visaient à défendre des droits démocratiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Qui a été la première femme à diriger la Commission européenne ?",
    options: ["Ursula von der Leyen", "Christine Lagarde", "Angela Merkel"],
    answer: "Ursula von der Leyen",
    explanation:
        "Ursula von der Leyen a pris ses fonctions en tant que présidente de la Commission européenne en 2019.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom du virus responsable de la pandémie de COVID-19 ?",
    options: ["SARS-CoV-2", "MERS-CoV", "HIV"],
    answer: "SARS-CoV-2",
    explanation:
        "Le SARS-CoV-2 est le virus responsable de la maladie COVID-19.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "En quelle année a été signée la Déclaration des Droits de l'Homme et du Citoyen ?",
    options: ["1789", "1791", "1793"],
    answer: "1789",
    explanation:
        "La Déclaration des Droits de l'Homme et du Citoyen a été adoptée en 1789, pendant la Révolution française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Qui était le leader de l'Union soviétique pendant la Guerre froide ?",
    options: ["Joseph Staline", "Leonid Brejnev", "Mikhail Gorbatchev"],
    answer: "Mikhail Gorbatchev",
    explanation:
        "Mikhail Gorbatchev a dirigé l'Union soviétique pendant la fin de la Guerre froide.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a marqué la fin de l'apartheid en Afrique du Sud ?",
    options: [
      "L'élection de Nelson Mandela",
      "L'abolition de la loi sur le pass",
      "Les émeutes de Soweto",
    ],
    answer: "L'élection de Nelson Mandela",
    explanation:
        "L'élection de Nelson Mandela en 1994 a marqué la fin officielle de l'apartheid.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été le premier secrétaire général des Nations Unies ?",
    options: ["Trygve Lie", "Dag Hammarskjöld", "Kofi Annan"],
    answer: "Trygve Lie",
    explanation:
        "Trygve Lie a été le premier secrétaire général des Nations Unies de 1946 à 1952.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement féministe a eu lieu dans les années 1960-1970 aux États-Unis ?",
    options: [
      "Women’s Liberation Movement",
      "Women’s Suffrage Movement",
      "Me Too Movement",
    ],
    answer: "Women’s Liberation Movement",
    explanation:
        "Le mouvement de libération des femmes a lutté pour l'égalité des droits dans les années 1960-1970.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a eu lieu à Tiananmen en 1989 ?",
    options: [
      "Une guerre civile",
      "Des manifestations pro-démocratie",
      "Une élection présidentielle",
    ],
    answer: "Des manifestations pro-démocratie",
    explanation:
        "Les manifestations de Tiananmen en 1989 demandaient des réformes démocratiques en Chine.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement a été lancé pour protester contre le changement climatique ?",
    options: ["Fridays for Future", "Greenpeace", "Earth Day"],
    answer: "Fridays for Future",
    explanation:
        "Fridays for Future est un mouvement mondial lancé par Greta Thunberg pour lutter contre le changement climatique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle a été la première femme à remporter un prix Nobel ?",
    options: ["Marie Curie", "Bertha Felicie", "Irène Joliot-Curie"],
    answer: "Marie Curie",
    explanation:
        "Marie Curie a été la première femme à recevoir un prix Nobel en 1903.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a connu le mouvement des « Gilets Jaunes » ?",
    options: ["Espagne", "France", "Belgique"],
    answer: "France",
    explanation:
        "Le mouvement des Gilets Jaunes est né en France en 2018 pour protester contre la hausse des taxes sur les carburants.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement historique a eu lieu en 1789 en France ?",
    options: [
      "La Révolution française",
      "La signature du traité de paix",
      "La déclaration de guerre",
    ],
    answer: "La Révolution française",
    explanation:
        "La Révolution française a débuté en 1789 avec des événements marquants comme la prise de la Bastille.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a aboli la peine de mort en 1981 ?",
    options: ["France", "Allemagne", "Italie"],
    answer: "France",
    explanation: "La France a aboli la peine de mort en 1981.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre discours a été prononcé par Martin Luther King en 1963 ?",
    options: [
      "I Have a Dream",
      "We Shall Overcome",
      "The Ballot or the Bullet",
    ],
    answer: "I Have a Dream",
    explanation: "Le discours",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement culturel est né des tensions raciales aux États-Unis dans les années 1960?",
    options: [
      "Black Lives Matter",
      "Harlem Renaissance",
      "Civil Rights Movement",
    ],
    answer: "Civil Rights Movement",
    explanation:
        "Le Civil Rights Movement a lutté pour l'égalité raciale et les droits des Afro-Américains.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a conduit à la création de l'Union européenne ?",
    options: [
      "La chute du Mur de Berlin",
      "La signature du Traité de Rome",
      "La crise économique de 2008",
    ],
    answer: "La signature du Traité de Rome",
    explanation:
        "Le Traité de Rome a été signé en 1957, posant les bases de l'Union européenne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement majeur a eu lieu en 1969 aux États-Unis?",
    options: [
      "La première mission Apollo sur la Lune",
      "La guerre du Vietnam",
      "L'assassinat de JFK",
    ],
    answer: "La première mission Apollo sur la Lune",
    explanation:
        "Apollo 11 a été la première mission à poser des hommes sur la Lune en 1969.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "En quelle année l'ONU a-t-elle été fondée?",
    options: ["1945", "1950", "1960"],
    answer: "1945",
    explanation:
        "L'ONU a été fondée en 1945, à la fin de la Seconde Guerre mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a décidé de quitter l'Union européenne en 2016?",
    options: ["Royaume-Uni", "France", "Allemagne"],
    answer: "Royaume-Uni",
    explanation:
        "Le Royaume-Uni a voté pour quitter l'Union européenne lors du référendum de 2016.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement artistique est apparu dans les années 1920, en réaction à la Première Guerre mondiale?",
    options: ["Surréalisme", "Cubisme", "Dadaïsme"],
    answer: "Dadaïsme",
    explanation:
        "Le Dadaïsme est né comme une réaction anti-guerre et anti-art.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été le premier homme à marcher sur la Lune?",
    options: ["Neil Armstrong", "Buzz Aldrin", "Yuri Gagarin"],
    answer: "Neil Armstrong",
    explanation:
        "Neil Armstrong a été le premier homme à poser le pied sur la Lune en 1969.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a marqué le début de la guerre froide ?",
    options: [
      "La fin de la Seconde Guerre mondiale",
      "Le blocus de Berlin",
      "La création de l'OTAN",
    ],
    answer: "La fin de la Seconde Guerre mondiale",
    explanation:
        "La guerre froide a commencé après la Seconde Guerre mondiale avec des tensions entre les États-Unis et l'URSS.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été le premier en Europe à élire une femme comme chef de gouvernement ?",
    options: ["Allemagne", "Royaume-Uni", "Norvège"],
    answer: "Norvège",
    explanation:
        "La Norvège a été le premier pays à élire une femme, Gro Harlem Brundtland, comme chef de gouvernement.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "En quelle année a eu lieu le premier vol commercial d'un avion à réaction?",
    options: ["1949", "1952", "1958"],
    answer: "1952",
    explanation:
        "Le premier vol commercial d'un avion à réaction a eu lieu en 1952 avec le Comet.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom de la première femme à devenir présidente d'un pays en Afrique ?",
    options: [
      "Ellen Johnson Sirleaf",
      "Wangari Maathai",
      "Ngozi Okonjo-Iweala",
    ],
    answer: "Ellen Johnson Sirleaf",
    explanation:
        "Ellen Johnson Sirleaf a été élue présidente du Libéria en 2006.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement familial a eu lieu en 2011 en Grande-Bretagne?",
    options: [
      "Le mariage royal de William et Kate",
      "La naissance du prince George",
      "La démission de David Cameron",
    ],
    answer: "Le mariage royal de William et Kate",
    explanation:
        "Le mariage royal de William et Kate Middleton a eu lieu en 2011.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement tragique a eu lieu en 2015 à Paris?",
    options: [
      "Les attentats de Charlie Hebdo",
      "Les émeutes de banlieue",
      "La victoire de l'équipe de France",
    ],
    answer: "Les attentats de Charlie Hebdo",
    explanation:
        "Les attentats de Charlie Hebdo ont eu lieu en janvier 2015, ciblant la liberté d'expression.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a marqué la fin de la guerre froide?",
    options: [
      "La chute du Mur de Berlin",
      "La dissolution de l'URSS",
      "L'élection de Mikhail Gorbatchev",
    ],
    answer: "La chute du Mur de Berlin",
    explanation:
        "La chute du Mur de Berlin en 1989 symbolise la fin de la guerre froide.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle découverte scientifique a été faite en 1953 concernant l'ADN?",
    options: ["Sa structure en double hélice", "Les gènes", "Le clonage"],
    answer: "Sa structure en double hélice",
    explanation:
        "James Watson et Francis Crick ont découvert la structure en double hélice de l'ADN en 1953.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement important a eu lieu en 2001 concernant l'Afghanistan?",
    options: [
      "L'invasion par les États-Unis",
      "La chute du régime taliban",
      "La découverte de Ben Laden",
    ],
    answer: "L'invasion par les États-Unis",
    explanation:
        "L'invasion par les États-Unis en 2001 a été déclenchée après les attentats du 11 septembre.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a subi un tremblement de terre dévastateur en 2010?",
    options: ["Haïti", "Chili", "Népal"],
    answer: "Haïti",
    explanation:
        "Le tremblement de terre en Haïti en 2010 a causé des destructions massives et de nombreuses pertes humaines.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement social a eu lieu en 2020 aux États-Unis?",
    options: ["Black Lives Matter", "Women’s March", "Occupy Wall Street"],
    answer: "Black Lives Matter",
    explanation:
        "Le mouvement Black Lives Matter a protesté contre les violences policières et les injustices raciales.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a eu lieu en 1994 en Afrique du Sud?",
    options: [
      "Les élections multiraciales",
      "Le début de l'apartheid",
      "La libération de Nelson Mandela",
    ],
    answer: "Les élections multiraciales",
    explanation:
        "Les élections multiraciales de 1994 ont marqué la fin de l'apartheid en Afrique du Sud.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel traité a été signé pour établir la paix après la Deuxième Guerre mondiale?",
    options: ["Traité de Paris", "Traité de Versailles", "Traité de Potsdam"],
    answer: "Traité de Paris",
    explanation:
        "Le Traité de Paris a été signé pour établir la paix après la Deuxième Guerre mondiale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement mondial a eu lieu en 2020?",
    options: [
      "La pandémie de COVID-19",
      "Les Jeux Olympiques",
      "L'élection présidentielle américaine",
    ],
    answer: "La pandémie de COVID-19",
    explanation:
        "La pandémie de COVID-19 a été déclarée en 2020, affectant le monde entier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle révolution a eu lieu en 1789 en France?",
    options: [
      "La Révolution industrielle",
      "La Révolution française",
      "La Révolution américaine",
    ],
    answer: "La Révolution française",
    explanation:
        "La Révolution française a débuté en 1789 et a profondément changé la société française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a marqué l'unification de l'Allemagne en 1871?",
    options: [
      "La guerre franco-prussienne",
      "La chute du Mur de Berlin",
      "La Révolution allemande",
    ],
    answer: "La guerre franco-prussienne",
    explanation:
        "La guerre franco-prussienne a été un facteur clé menant à l'unification de l'Allemagne en 1871.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été le premier à envoyer un satellite dans l'espace?",
    options: ["États-Unis", "Union soviétique", "France"],
    answer: "Union soviétique",
    explanation:
        "L'Union soviétique a lancé le premier satellite, Spoutnik, en 1957.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a accueilli la Coupe du Monde de football en 1998?",
    options: ["Brésil", "Allemagne", "France"],
    answer: "France",
    explanation:
        "La France a accueilli la Coupe du Monde de football en 1998, qu'elle a également remportée.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a eu lieu en 2016 concernant le choix du président américain?",
    options: [
      "L'élection de Donald Trump",
      "L'élection d'Hillary Clinton",
      "Le référendum Brexit",
    ],
    answer: "L'élection de Donald Trump",
    explanation:
        "L'élection de Donald Trump en 2016 a été un événement marquant de la politique américaine.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement mondial est célébré chaque 22 avril ?",
    options: [
      "La Journée de la Terre",
      "La Journée des droits de l'homme",
      "La Journée de la mer",
    ],
    answer: "La Journée de la Terre",
    explanation:
        "La Journée de la Terre vise à sensibiliser à la protection de l'environnement.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement social a été lancé en 2011 pour dénoncer les inégalités économiques ?",
    options: ["Occupy Wall Street", "Les Gilets Jaunes", "Black Lives Matter"],
    answer: "Occupy Wall Street",
    explanation:
        "Occupy Wall Street a mis en lumière les inégalités de richesse et de pouvoir aux États-Unis.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a voté pour quitter l'Union européenne en 2016 ?",
    options: ["La France", "Le Royaume-Uni", "L'Allemagne"],
    answer: "Le Royaume-Uni",
    explanation:
        "Le référendum de 2016 a conduit au Brexit, la sortie du Royaume-Uni de l'UE.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel organisme international a été créé après la Seconde Guerre mondiale pour maintenir la paix ?",
    options: ["L'OTAN", "Les Nations Unies", "L'Union européenne"],
    answer: "Les Nations Unies",
    explanation:
        "Les Nations Unies ont été établies en 1945 pour promouvoir la coopération internationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel traité a été signé en 1992 pour renforcer l'intégration européenne ?",
    options: [
      "Le traité de Maastricht",
      "Le traité de Lisbonne",
      "Le traité de Rome",
    ],
    answer: "Le traité de Maastricht",
    explanation:
        "Le traité de Maastricht a établi l'Union européenne et introduit la monnaie unique.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement a eu pour slogan 'Je suis Charlie' en 2015 ?",
    options: [
      "Un mouvement pour la paix",
      "Un mouvement pour la liberté d'expression",
      "Un mouvement contre le racisme",
    ],
    answer: "Un mouvement pour la liberté d'expression",
    explanation:
        "Ce slogan est né à la suite de l'attentat contre Charlie Hebdo pour défendre la liberté d'expression.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a accueilli les jeux olympiques d'été en 2016 ?",
    options: ["Le Brésil", "La Chine", "L'Australie"],
    answer: "Le Brésil",
    explanation:
        "Les Jeux Olympiques d'été se sont tenus à Rio de Janeiro en 2016.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel terme désigne les manifestations de masse en faveur de la démocratie à Hong Kong ?",
    options: [
      "Les Umbrella Movement",
      "Les Gilets Jaunes",
      "Occupy Wall Street",
    ],
    answer: "Les Umbrella Movement",
    explanation:
        "Les Umbrella Movement est un mouvement de lutte pour la démocratie à Hong Kong.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement marquant a eu lieu le 11 septembre 2001 aux États-Unis ?",
    options: [
      "Un tremblement de terre",
      "Un attentat terroriste",
      "L'élection présidentielle",
    ],
    answer: "Un attentat terroriste",
    explanation:
        "Les attentats du 11 septembre 2001 ont provoqué la destruction des tours du World Trade Center.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle pandémie mondiale a été déclarée en 2020 ?",
    options: ["La grippe aviaire", "Le COVID-19", "Le virus Ebola"],
    answer: "Le COVID-19",
    explanation:
        "La pandémie de COVID-19 a eu des impacts mondiaux significatifs sur la santé et l'économie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement de protestation est né après la mort de George Floyd ?",
    options: ["Les Gilets Jaunes", "Black Lives Matter", "Occupy Wall Street"],
    answer: "Black Lives Matter",
    explanation:
        "Ce mouvement vise à dénoncer les violences policières et le racisme systémique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le principal produit d'exportation de l'Arabie Saoudite ?",
    options: ["Le café", "Le pétrole", "Le blé"],
    answer: "Le pétrole",
    explanation:
        "L'Arabie Saoudite est le premier producteur de pétrole au monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a marqué la fin de la guerre froide ?",
    options: [
      "La chute du mur de Berlin",
      "La guerre du Vietnam",
      "La première guerre du Golfe",
    ],
    answer: "La chute du mur de Berlin",
    explanation:
        "La chute du mur de Berlin en 1989 symbolise la fin de la guerre froide.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel était le nom de l'initiative de Barack Obama pour la réforme de la santé ?",
    options: ["Obamacare", "Medicare", "Medicaid"],
    answer: "Obamacare",
    explanation:
        "Obamacare a été conçu pour élargir l'accès à l'assurance maladie aux États-Unis.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle conférence internationale a eu lieu à Paris en 2015 pour lutter contre le changement climatique ?",
    options: ["La COP21", "La COP26", "Le Sommet de Cancun"],
    answer: "La COP21",
    explanation: "La COP21 a abouti à l'accord de Paris sur le climat.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel célèbre site de partage de vidéos a été créé en 2005 ?",
    options: ["Vimeo", "Dailymotion", "YouTube"],
    answer: "YouTube",
    explanation:
        "YouTube est devenu la plateforme de référence pour le partage de vidéos en ligne.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui était la première femme à entrer dans l'espace ?",
    options: ["Sally Ride", "Valentina Terechkova", "Mae Jemison"],
    answer: "Valentina Terechkova",
    explanation:
        "Valentina Terechkova a été la première femme dans l'espace en 1963.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel était le nom du mouvement de désobéissance civile en Inde dirigé par Gandhi ?",
    options: [
      "Le mouvement pour l'indépendance",
      "Le mouvement de la non-violence",
      "Le mouvement de l'autonomie",
    ],
    answer: "Le mouvement de la non-violence",
    explanation:
        "Gandhi prônait la non-violence dans sa lutte pour l'indépendance de l'Inde.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom de la célèbre activiste pakistanaise pour l'éducation des filles ?",
    options: ["Malala Yousafzai", "Nazanin Boniadi", "Benazir Bhutto"],
    answer: "Malala Yousafzai",
    explanation:
        "Malala Yousafzai a reçu le prix Nobel de la paix pour son engagement en faveur de l'éducation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a connu le printemps arabe, un mouvement de protestation en 2011 ?",
    options: ["La Syrie", "L'Égypte", "La Libye"],
    answer: "L'Égypte",
    explanation:
        "Le mouvement a débuté en Égypte pour renverser le régime de Hosni Moubarak.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement célèbre est organisé chaque année à Cannes ?",
    options: [
      "Le Festival de la Musique",
      "Le Festival de Cannes",
      "Le Festival de Jazz",
    ],
    answer: "Le Festival de Cannes",
    explanation:
        "Le Festival de Cannes est une prestigieuse cérémonie de remise de prix cinématographiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle application de messagerie a été fondée par Jan Koum et Brian Acton en 2009 ?",
    options: ["Telegram", "Signal", "WhatsApp"],
    answer: "WhatsApp",
    explanation:
        "WhatsApp est devenue l'une des applications de messagerie les plus utilisées au monde.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement politique prône la protection de l'environnement et la lutte contre le changement climatique ?",
    options: ["Le Parti vert", "Le Parti socialiste", "Le Parti républicain"],
    answer: "Le Parti vert",
    explanation:
        "Le Parti vert met l'accent sur les politiques écologiques et la justice sociale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre livre de George Orwell dénonce les dérives totalitaires ?",
    options: ["1984", "Le Meilleur des mondes", "Fahrenheit 451"],
    answer: "1984",
    explanation:
        "1984 est une critique des régimes totalitaires et de la surveillance de masse.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été le site des attentats du 11 septembre 2001 ?",
    options: ["France", "États-Unis", "Allemagne"],
    answer: "États-Unis",
    explanation:
        "Les attentats de 2001 ont été perpétrés sur le sol américain.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays est devenu le premier à légaliser le mariage homosexuel en 2001 ?",
    options: ["Les Pays-Bas", "La Belgique", "Le Canada"],
    answer: "Les Pays-Bas",
    explanation:
        "Les Pays-Bas ont été le premier pays à légaliser le mariage pour tous.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel acteur a joué le rôle de Nelson Mandela dans le film 'Invictus' ?",
    options: ["Morgan Freeman", "Idris Elba", "Denzel Washington"],
    answer: "Morgan Freeman",
    explanation:
        "Morgan Freeman a incarné Nelson Mandela dans le film 'Invictus' de Clint Eastwood.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le principal objectif du développement durable ?",
    options: [
      "Éliminer la pauvreté",
      "Promouvoir la croissance économique",
      "Réduire les inégalités",
    ],
    answer: "Éliminer la pauvreté",
    explanation:
        "L'élimination de la pauvreté est au cœur des objectifs de développement durable.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement a vu le jour pour lutter contre le changement climatique en ligne ?",
    options: [
      "Fridays for Future",
      "Les Gilets Jaunes",
      "Extinction Rebellion",
    ],
    answer: "Fridays for Future",
    explanation:
        "Fridays for Future a été lancé par Greta Thunberg pour sensibiliser à la crise climatique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a connu un tremblement de terre dévastateur en 2010 ?",
    options: ["Haiti", "Chili", "Japon"],
    answer: "Haiti",
    explanation:
        "Le tremblement de terre en Haïti a causé d'importants dégâts et pertes humaines.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement sportif majeur a été reporté en 2020 à cause de la pandémie de COVID-19 ?",
    options: [
      "Les Jeux Olympiques de Tokyo",
      "La Coupe du Monde de football",
      "Le Tour de France",
    ],
    answer: "Les Jeux Olympiques de Tokyo",
    explanation:
        "Les Jeux Olympiques de Tokyo ont été reportés à 2021 en raison de la pandémie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a obtenu son indépendance de l'URSS en 1991 ?",
    options: ["L'Ukraine", "La Pologne", "La République tchèque"],
    answer: "L'Ukraine",
    explanation:
        "L'Ukraine a déclaré son indépendance de l'Union soviétique en août 1991.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été élu président de la France en 2012 ?",
    options: ["François Hollande", "Nicolas Sarkozy", "Emmanuel Macron"],
    answer: "François Hollande",
    explanation:
        "François Hollande a été élu président de la République française en 2012.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement pacifique a été fondé par Martin Luther King Jr. ?",
    options: [
      "Le mouvement des droits civiques",
      "Le mouvement des femmes",
      "Le mouvement de paix",
    ],
    answer: "Le mouvement des droits civiques",
    explanation:
        "Le mouvement des droits civiques a lutté pour l'égalité raciale aux États-Unis.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays est connu pour avoir originellement aboli la peine de mort en 1981 ?",
    options: ["La France", "L'Italie", "Le Canada"],
    answer: "La France",
    explanation:
        "La France a aboli la peine de mort en 1981 sous la présidence de François Mitterrand.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement déclencheur de la Première Guerre mondiale a eu lieu à Sarajevo en 1914 ?",
    options: [
      "L'assassinat de François-Ferdinand",
      "Le début de la guerre",
      "Le traité de Versailles",
    ],
    answer: "L'assassinat de François-Ferdinand",
    explanation:
        "L'assassinat de l'archiduc François-Ferdinand a été un facteur déclencheur de la guerre.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom du mouvement de protection des droits des animaux fondé par Peter Singer ?",
    options: ["Le véganisme", "Le spécisme", "Le mouvement animaliste"],
    answer: "Le mouvement animaliste",
    explanation:
        "Peter Singer a popularisé le mouvement animaliste axé sur le bien-être des animaux.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le véritable nom du mouvement politico-économique connu sous le nom de socialisme ?",
    options: ["Le marxisme", "Le libéralisme", "Le communisme"],
    answer: "Le marxisme",
    explanation:
        "Le marxisme est la théorie économique et politique à la base du socialisme.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a fondé la ville de Rome selon la légende ?",
    options: ["Romulus", "César", "Augustus"],
    answer: "Romulus",
    explanation: "Romulus est, selon la légende, le fondateur de Rome.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel est le nom du célèbre tableau du peintre Edvard Munch ?",
    options: ["La Nuit étoilée", "Le Cri", "L'Angélus"],
    answer: "Le Cri",
    explanation:
        "Le Cri est une œuvre emblématique exprimant l'angoisse humaine.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel secteur est le principal contributeur aux émissions de CO2 dans le monde ?",
    options: ["L'agriculture", "Les transports", "L'industrie"],
    answer: "L'industrie",
    explanation:
        "L'industrie est responsable d'une grande partie des émissions mondiales de CO2.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel organisme a été créé pour promouvoir l'éducation dans le monde ?",
    options: ["L'UNESCO", "L'ONU", "L'OMS"],
    answer: "L'UNESCO",
    explanation:
        "L'UNESCO est une agence des Nations Unies dédiée à l'éducation et à la culture.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été le premier à abolir l'esclavage ?",
    options: ["Le Royaume-Uni", "La France", "Les États-Unis"],
    answer: "La France",
    explanation: "La France a aboli l'esclavage dans les colonies en 1848.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel célèbre auteur a écrit 'Les Misérables' ?",
    options: ["Victor Hugo", "Émile Zola", "Gustave Flaubert"],
    answer: "Victor Hugo",
    explanation:
        "Victor Hugo a écrit 'Les Misérables', un classique de la littérature française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom de la députée et militante écologiste suédoise ?",
    options: ["Greta Thunberg", "Malala Yousafzai", "Angela Merkel"],
    answer: "Greta Thunberg",
    explanation:
        "Greta Thunberg est connue pour son activisme en faveur du climat.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle célèbre œuvre de Léonard de Vinci représente un sourire mystérieux ?",
    options: ["La Cène", "La Joconde", "Le Dernier Jugement"],
    answer: "La Joconde",
    explanation:
        "La Joconde est célèbre pour son sourire et son mystère artistique.",
    difficulty: "Difficile",
  ),
  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "En quelle année la Déclaration des Droits de l'Homme et du Citoyen a-t-elle été adoptée ?",
    options: ["1789", "1792", "1776"],
    answer: "1789",
    explanation:
        "Cette déclaration a été adoptée lors de la Révolution française.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement historique est commémoré le 11 novembre en France ?",
    options: [
      "La chute du Mur de Berlin",
      "La fin de la Première Guerre mondiale",
      "L'armistice de la Seconde Guerre mondiale",
    ],
    answer: "La fin de la Première Guerre mondiale",
    explanation:
        "Le 11 novembre 1918 marque la cessation des combats de la Première Guerre mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom du mouvement de lutte pour les droits civiques aux États-Unis dans les années 1960 ?",
    options: [
      "Le mouvement abolitionniste",
      "Le mouvement des droits civiques",
      "Le mouvement féministe",
    ],
    answer: "Le mouvement des droits civiques",
    explanation:
        "Ce mouvement visait à mettre fin à la ségrégation raciale et à garantir les droits des Afro-Américains.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le principal organisme de l'ONU chargé de maintenir la paix et la sécurité internationales ?",
    options: [
      "L'Assemblée générale",
      "Le Conseil de sécurité",
      "La Cour internationale de justice",
    ],
    answer: "Le Conseil de sécurité",
    explanation:
        "Le Conseil de sécurité est responsable de la prise de décisions concernant la paix et la sécurité.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "En quelle année l'euro a-t-il été introduit comme monnaie officielle en Europe ?",
    options: ["2000", "2002", "1999"],
    answer: "2002",
    explanation:
        "L'euro est devenu la monnaie officielle pour les transactions en espèces en janvier 2002.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a eu lieu le 20 juillet 1969 ?",
    options: [
      "La première télévision couleur",
      "Le premier pas sur la Lune",
      "La chute du Mur de Berlin",
    ],
    answer: "Le premier pas sur la Lune",
    explanation:
        "Neil Armstrong a été le premier homme à marcher sur la Lune lors de cette date.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel était le surnom de la célèbre machine de guerre allemande durant la Seconde Guerre mondiale ?",
    options: ["Panzer", "Tiger", "Bismarck"],
    answer: "Panzer",
    explanation:
        "Les tanks allemands étaient appelés 'Panzer' durant la Seconde Guerre mondiale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a aboli la peine de mort en 1981, devenant ainsi le premier à le faire ?",
    options: ["France", "Canada", "Suède"],
    answer: "France",
    explanation:
        "La France a aboli la peine de mort en 1981, établissant un précédent.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Qui a été le dirigeant soviétique durant la période de la Guerre froide ?",
    options: ["Leonid Brejnev", "Mikhaïl Gorbatchev", "Joseph Staline"],
    answer: "Leonid Brejnev",
    explanation:
        "Leonid Brejnev a dirigé l'URSS de 1964 à 1982, période clé de la Guerre froide.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom du mouvement étudiant qui a eu lieu en Chine en 1989 ?",
    options: [
      "La Révolte des Etudiants",
      "La Révolution culturelle",
      "Les Manifestations de Tiananmen",
    ],
    answer: "Les Manifestations de Tiananmen",
    explanation:
        "Ces manifestations ont été un appel à des réformes politiques et démocratiques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle guerre s'est terminée par l'accord de Dayton en 1995 ?",
    options: [
      "La guerre du Golfe",
      "La guerre de Yougoslavie",
      "La guerre d'Irak",
    ],
    answer: "La guerre de Yougoslavie",
    explanation:
        "L'accord de Dayton a mis fin à la guerre de Yougoslavie, qui a duré de 1991 à 1995.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle invention a été présentée pour la première fois en 1876 par Alexander Graham Bell ?",
    options: ["Le téléphone", "La radio", "Le télégraphe"],
    answer: "Le téléphone",
    explanation:
        "Alexander Graham Bell a obtenu le brevet du premier téléphone en 1876.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel était le nom du programme spatial américain qui a envoyé des astronautes sur la Lune ?",
    options: ["Apollo", "Mercury", "Gemini"],
    answer: "Apollo",
    explanation:
        "Le programme Apollo a permis d'envoyer des astronautes sur la Lune entre 1969 et 1972.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été le premier à légaliser le mariage homosexuel en 2001 ?",
    options: ["Pays-Bas", "Belgique", "Canada"],
    answer: "Pays-Bas",
    explanation:
        "Les Pays-Bas ont été le premier pays à légaliser le mariage homosexuel.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom du célèbre discours de Martin Luther King prononcé en 1963 ?",
    options: ["I Have a Dream", "We Shall Overcome", "Yes We Can"],
    answer: "I Have a Dream",
    explanation:
        "Ce discours emblématique a été prononcé lors de la marche pour l'emploi et la liberté.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a marqué le début de la Révolution française ?",
    options: [
      "La prise de la Bastille",
      "La Déclaration des Droits de l'Homme",
      "Le couronnement de Napoléon",
    ],
    answer: "La prise de la Bastille",
    explanation:
        "La prise de la Bastille le 14 juillet 1789 est souvent considérée comme le début de la Révolution.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a remporté la Coupe du Monde de football 1998 ?",
    options: ["Brésil", "France", "Allemagne"],
    answer: "France",
    explanation:
        "La France a remporté la Coupe du Monde en 1998 en battant le Brésil en finale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel traité a été signé pour unir l'Allemagne en 1990 ?",
    options: [
      "Traité de Maastricht",
      "Traité de Paris",
      "Traité de Réunification",
    ],
    answer: "Traité de Réunification",
    explanation:
        "Ce traité a été signé pour officialiser la réunification de l'Allemagne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a été le fondateur de la République populaire de Chine ?",
    options: ["Mao Zedong", "Sun Yat-sen", "Deng Xiaoping"],
    answer: "Mao Zedong",
    explanation:
        "Mao Zedong a déclaré la République populaire de Chine en 1949.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel phénomène naturel a eu lieu à Fukushima en 2011 ?",
    options: ["Un ouragan", "Un tremblement de terre", "Une inondation"],
    answer: "Un tremblement de terre",
    explanation:
        "Un tremblement de terre suivi d'un tsunami a causé la catastrophe nucléaire de Fukushima.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel est le nom de la première femme à avoir remporté le prix Nobel ?",
    options: ["Marie Curie", "Rosalind Franklin", "Ada Lovelace"],
    answer: "Marie Curie",
    explanation:
        "Marie Curie a remporté le prix Nobel de physique en 1903 et le prix Nobel de chimie en 1911.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel organisme a été créé après la Seconde Guerre mondiale pour promouvoir la paix ?",
    options: ["L'ONU", "L'OTAN", "L'UE"],
    answer: "L'ONU",
    explanation:
        "L'Organisation des Nations Unies a été créée en 1945 pour promouvoir la paix et la coopération internationale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a conduit à la chute de l'URSS en 1991 ?",
    options: [
      "La guerre de Tchétchénie",
      "La Perestroïka",
      "Le coup d'État de 1991",
    ],
    answer: "Le coup d'État de 1991",
    explanation:
        "Le coup d'État d'août 1991 a provoqué la chute définitive de l'URSS.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a peint 'La Joconde' ?",
    options: ["Vincent van Gogh", "Claude Monet", "Léonard de Vinci"],
    answer: "Léonard de Vinci",
    explanation:
        "'La Joconde' est un chef-d'œuvre de Léonard de Vinci, peint au début du 16e siècle.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle est la capitale de l'Inde ?",
    options: ["New Delhi", "Mumbai", "Bangalore"],
    answer: "New Delhi",
    explanation:
        "New Delhi est la capitale et le centre administratif de l'Inde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre mouvement culturel est né à Harlem dans les années 1920 ?",
    options: [
      "La Renaissance de Harlem",
      "Le mouvement des droits civiques",
      "Le jazz",
    ],
    answer: "La Renaissance de Harlem",
    explanation:
        "Ce mouvement a mis en avant les contributions culturelles des Afro-Américains.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a provoqué le début de la Seconde Guerre mondiale ?",
    options: [
      "L'invasion de la Pologne",
      "L'attaque de Pearl Harbor",
      "La signature du traité de Versailles",
    ],
    answer: "L'invasion de la Pologne",
    explanation:
        "L'invasion de la Pologne par l'Allemagne en septembre 1939 a déclenché la Seconde Guerre mondiale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle célèbre loi a été adoptée pour protéger les droits civiques aux États-Unis en 1964 ?",
    options: [
      "La loi sur les droits civiques",
      "La loi sur le travail",
      "La loi sur l'éducation",
    ],
    answer: "La loi sur les droits civiques",
    explanation:
        "Cette loi visait à interdire la discrimination basée sur la race, la couleur, la religion, le sexe ou l'origine nationale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a organisé les premiers Jeux Olympiques modernes en 1896 ?",
    options: ["France", "Grèce", "Australie"],
    answer: "Grèce",
    explanation:
        "La Grèce a accueilli les premiers Jeux Olympiques modernes à Athènes en 1896.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui est l'auteur de '1984' ?",
    options: ["George Orwell", "Aldous Huxley", "Ray Bradbury"],
    answer: "George Orwell",
    explanation: "George Orwell a écrit '1984', une dystopie publiée en 1949.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement artistique a débuté dans les années 1910 et s'est opposé aux conventions traditionnelles ?",
    options: ["Le cubisme", "Le romantisme", "Le surréalisme"],
    answer: "Le cubisme",
    explanation:
        "Le cubisme, fondé par Picasso et Braque, a rompu avec les conventions de la représentation.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre physicien a développé la théorie de la relativité ?",
    options: ["Isaac Newton", "Albert Einstein", "Galileo Galilei"],
    answer: "Albert Einstein",
    explanation:
        "Albert Einstein a formulé la théorie de la relativité, révolutionnant la physique moderne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel document a été produit pendant la Révolution française en 1789 ?",
    options: [
      "La Charte des droits",
      "Le Manifeste du peuple",
      "La Déclaration des droits de l'homme et du citoyen",
    ],
    answer: "La Déclaration des droits de l'homme et du citoyen",
    explanation:
        "Ce document fondateur a établi les droits fondamentaux des citoyens.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a marqué la fondation de l'Union européenne en 1993 ?",
    options: [
      "La création de l'euro",
      "Le traité de Maastricht",
      "La réunification de l'Allemagne",
    ],
    answer: "Le traité de Maastricht",
    explanation:
        "Ce traité a établi les bases de l'Union européenne telle qu'on la connaît aujourd'hui.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle célèbre maison d'édition a été fondée par un groupe d'écrivains américains en 1943 ?",
    options: ["Penguin Random House", "Simon & Schuster", "Grove Press"],
    answer: "Grove Press",
    explanation:
        "Grove Press a été fondée par des écrivains américains pour promouvoir des œuvres littéraires audacieuses.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement artistique est associé à des artistes comme Monet et Renoir ?",
    options: ["Le surréalisme", "Le cubisme", "L'impressionnisme"],
    answer: "L'impressionnisme",
    explanation:
        "L'impressionnisme est un mouvement qui privilégie la lumière et la couleur sur la forme.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel traité a mis fin à la guerre de 1812 entre les États-Unis et le Royaume-Uni ?",
    options: ["Traité de Versailles", "Traité de Ghent", "Traité de Paris"],
    answer: "Traité de Ghent",
    explanation:
        "Le Traité de Ghent, signé en 1814, a mis un terme à la guerre de 1812.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a déclenché la guerre du Vietnam ?",
    options: [
      "L'invasion du Vietnam du Nord",
      "La bataille de Diên Biên Phu",
      "Le Gulf of Tonkin Incident",
    ],
    answer: "Le Gulf of Tonkin Incident",
    explanation:
        "Cet incident en 1964 a conduit les États-Unis à intensifier leur engagement militaire au Vietnam.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Qui a composé la musique de l'hymne national français, 'La Marseillaise' ?",
    options: ["Claude Debussy", "Camille Saint-Saëns", "Giorgio Cacciapaglia"],
    answer: "Claude Debussy",
    explanation:
        "Claude Debussy a arrangé 'La Marseillaise', l'hymne national français.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement a émergé dans les années 1960 pour promouvoir les droits des femmes ?",
    options: ["Le féminisme", "Le libéralisme", "Le courant pacifiste"],
    answer: "Le féminisme",
    explanation:
        "Le féminisme des années 60 visait à obtenir l'égalité des droits pour les femmes.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a déterminé la fin de la Guerre froide ?",
    options: [
      "La chute du Mur de Berlin",
      "La guerre en Afghanistan",
      "L'effondrement de l'URSS",
    ],
    answer: "La chute du Mur de Berlin",
    explanation:
        "La chute du Mur de Berlin en 1989 symbolise la fin de la Guerre froide.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel chef d'État américain a démissionné suite à un scandale en 1974 ?",
    options: ["Richard Nixon", "Lyndon Johnson", "Ronald Reagan"],
    answer: "Richard Nixon",
    explanation:
        "Richard Nixon a démissionné à la suite du scandale du Watergate.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel courant littéraire est marqué par l'écriture d'Honoré de Balzac ?",
    options: ["Le romantisme", "Le réalisme", "Le naturalisme"],
    answer: "Le réalisme",
    explanation:
        "Honoré de Balzac est l'un des principaux auteurs du mouvement réaliste.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a eu lieu en 1969 et a marqué un exploit technologique majeur ?",
    options: [
      "L'envoi de Spoutnik",
      "L'alunissage d'Apollo 11",
      "La première télé en couleur",
    ],
    answer: "L'alunissage d'Apollo 11",
    explanation:
        "L'alunissage d'Apollo 11 en 1969 a marqué un jalon majeur dans l'exploration spatiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a signé le premier accord climatique lors du Sommet de la Terre en 1992 ?",
    options: ["Brésil", "États-Unis", "France"],
    answer: "Brésil",
    explanation:
        "Le Brésil a signé l'accord sur la Convention-cadre des Nations Unies sur les changements climatiques.",
    difficulty: "Moyenne",
  ),
  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Qui a remporté le prix Nobel de la paix en 2020 ?",
    options: [
      "Organisation mondiale de la santé",
      "Greta Thunberg",
      "Barack Obama",
    ],
    answer: "Organisation mondiale de la santé",
    explanation:
        "L'Organisation mondiale de la santé a été récompensée pour ses efforts dans la lutte contre la pandémie de COVID-19.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a été largement célébré en 2021 pour sensibiliser aux enjeux climatiques ?",
    options: [
      "Le sommet de Paris",
      "La journée de la Terre",
      "La conférence de Glasgow",
    ],
    answer: "La conférence de Glasgow",
    explanation:
        "La conférence de Glasgow, aussi appelée COP26, a été un moment clé pour discuter des actions contre le changement climatique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle pandémie mondiale a commencé en 2020 ?",
    options: ["La grippe aviaire", "COVID-19", "Zika"],
    answer: "COVID-19",
    explanation:
        "La pandémie de COVID-19 a été causée par le virus SARS-CoV-2, touchant des millions de personnes dans le monde.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel leader mondial a été élu pour la première fois en 2017 en France ?",
    options: ["François Hollande", "Marine Le Pen", "Emmanuel Macron"],
    answer: "Emmanuel Macron",
    explanation:
        "Emmanuel Macron a été élu président de la République française en mai 2017.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement a pris de l'ampleur après la mort de George Floyd en 2020 ?",
    options: ["Black Lives Matter", "#MeToo", "Occupy Wall Street"],
    answer: "Black Lives Matter",
    explanation:
        "Le mouvement Black Lives Matter a gagné une visibilité mondiale après la mort de George Floyd, appelant à la justice raciale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle technologie a été largement développée pour le télétravail durant la pandémie ?",
    options: [
      "La visioconférence",
      "La réalité virtuelle",
      "Les réseaux sociaux",
    ],
    answer: "La visioconférence",
    explanation:
        "La visioconférence est devenue essentielle pour maintenir la communication à distance pendant les confinements liés à la COVID-19.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été le premier à administrer un vaccin contre la COVID-19 ?",
    options: ["États-Unis", "Royaume-Uni", "Chine"],
    answer: "Royaume-Uni",
    explanation:
        "Le Royaume-Uni a été le premier pays à commencer les vaccinations contre la COVID-19 en décembre 2020.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a eu lieu en 2020 à cause de l'explosion d'une usine à Beyrouth ?",
    options: ["Un tremblement de terre", "Une crise humanitaire", "Un tsunami"],
    answer: "Une crise humanitaire",
    explanation:
        "L'explosion à Beyrouth a causé une grave crise humanitaire, laissant des milliers de personnes sans abri.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel célèbre mouvement pour la justice sociale a été fondé en 2013 ?",
    options: ["Black Lives Matter", "Women’s March", "Fridays for Future"],
    answer: "Black Lives Matter",
    explanation:
        "Black Lives Matter a été fondé en réponse aux violences policières envers les personnes noires et pour promouvoir l'égalité raciale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel accord a été signé en 2015 pour lutter contre le changement climatique ?",
    options: ["Accord de Paris", "Accord de Kyoto", "Accord de Glasgow"],
    answer: "Accord de Paris",
    explanation:
        "L'Accord de Paris vise à limiter le réchauffement climatique à 2 °C par rapport aux niveaux préindustriels.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a annoncé la fin de la vente de voitures à essence d'ici 2035 ?",
    options: ["Allemagne", "France", "Norvège"],
    answer: "France",
    explanation:
        "La France a prévu d'interdire la vente de voitures à essence et diesel d'ici 2035 pour promouvoir les véhicules électriques.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement majeur a eu lieu à Washington D.C. en janvier 2021 ?",
    options: [
      "Une élection présidentielle",
      "Une émeute au Capitole",
      "Un congrès historique",
    ],
    answer: "Une émeute au Capitole",
    explanation:
        "L'émeute au Capitole a eu lieu le 6 janvier 2021, lorsque des partisans de Donald Trump ont tenté de contester l'élection.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été largement touché par des incendies de forêt en 2020 ?",
    options: ["Australie", "Brésil", "Canada"],
    answer: "Australie",
    explanation:
        "L'Australie a connu des incendies de forêt dévastateurs durant l'été 2020, détruisant des milliers d'hectares de terre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement sportif mondial a été repoussé en 2020 à cause de la pandémie ?",
    options: [
      "Les Jeux Olympiques",
      "La Coupe du Monde de football",
      "Le Tour de France",
    ],
    answer: "Les Jeux Olympiques",
    explanation:
        "Les Jeux Olympiques de Tokyo ont été reportés à 2021 en raison de la pandémie de COVID-19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement a été lancé pour lutter contre les violences faites aux femmes en 2017 ?",
    options: ["HeForShe", "#MeToo", "Time's Up"],
    answer: "#MeToo",
    explanation:
        "Le mouvement #MeToo est devenu viral en 2017, dénonçant le harcèlement et les agressions sexuelles à l'échelle mondiale.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a voté pour l'indépendance lors d'un référendum en 2017 ?",
    options: ["Écosse", "Catalogne", "Québec"],
    answer: "Catalogne",
    explanation:
        "Le référendum sur l'indépendance de la Catalogne a eu lieu en octobre 2017, bien qu'il n'ait pas été reconnu par l'Espagne.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement majeur a eu lieu en France en mai 1968 ?",
    options: [
      "Des élections",
      "Des grèves et manifestations",
      "Un festival de musique",
    ],
    answer: "Des grèves et manifestations",
    explanation:
        "Mai 1968 en France a été marqué par de grandes grèves et des manifestations estudiantines contre l'autorité établie.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel accord a été signé entre les États-Unis et la Corée du Nord en 2018 ?",
    options: [
      "Accord de paix",
      "Accord sur la dénucléarisation",
      "Accord commercial",
    ],
    answer: "Accord sur la dénucléarisation",
    explanation:
        "L'accord de 2018 visait à dénucléariser la péninsule coréenne, mais n'a pas été pleinement mis en œuvre.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle technologie a explosé en popularité avec le travail à distance en 2020 ?",
    options: [
      "Les ordinateurs portables",
      "Les applications de messagerie",
      "Les logiciels de visioconférence",
    ],
    answer: "Les logiciels de visioconférence",
    explanation:
        "Les logiciels de visioconférence, comme Zoom, ont connu une utilisation massive pour le travail à distance durant la pandémie.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel leader a été destitué au Brésil en 2016 ?",
    options: ["Luis Inácio Lula da Silva", "Dilma Rousseff", "Michel Temer"],
    answer: "Dilma Rousseff",
    explanation:
        "Dilma Rousseff a été destituée en 2016 à la suite de accusations de manipulation budgétaire.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel mouvement écologique a été fondé par Greta Thunberg ?",
    options: ["Fridays for Future", "Extinction Rebellion", "Greenpeace"],
    answer: "Fridays for Future",
    explanation:
        "Greta Thunberg a lancé le mouvement Fridays for Future pour sensibiliser à l'urgence climatique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a marqué l'histoire en début 2021 à Washington ?",
    options: [
      "L'inauguration de Biden",
      "Le retrait des troupes",
      "Une émeute au Capitole",
    ],
    answer: "Une émeute au Capitole",
    explanation:
        "L'émeute au Capitole a eu lieu le 6 janvier 2021, provoquée par des partisans de l'ancien président Trump.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel pays a été frappé par une épidémie de choléra en 2021 ?",
    options: ["Yémen", "Syrie", "Venezuela"],
    answer: "Yémen",
    explanation:
        "Le Yémen, en proie à une crise humanitaire, a également subi une épidémie de choléra en 2021.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel sujet a été au cœur des élections américaines de 2020 ?",
    options: ["L'immigration", "Le changement climatique", "La santé"],
    answer: "La santé",
    explanation:
        "La gestion de la pandémie de COVID-19 a été un point central des élections américaines de 2020.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel groupe de musique a organisé un concert virtuel en 2020 pour soutenir le personnel de santé ?",
    options: ["Coldplay", "U2", "Lady Gaga"],
    answer: "Lady Gaga",
    explanation:
        "Lady Gaga a organisé le concert virtuel 'One World: Together At Home' pour soutenir les travailleurs de la santé pendant la pandémie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quels jeux Olympiques ont été reportés en raison de la pandémie en 2020 ?",
    options: [
      "Les Jeux d'hiver de Pyeongchang",
      "Les Jeux d'été de Tokyo",
      "Les Jeux de la jeunesse",
    ],
    answer: "Les Jeux d'été de Tokyo",
    explanation:
        "Les Jeux d'été de Tokyo, initialement prévus en 2020, ont été reportés à 2021 à cause de la COVID-19.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement a connu une forte visibilité en 2020 pour dénoncer les violences policières ?",
    options: ["#MeToo", "Black Lives Matter", "Time's Up"],
    answer: "Black Lives Matter",
    explanation:
        "Le mouvement Black Lives Matter a gagné en notoriété après la mort de George Floyd, dénonçant les violences policières.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle catastrophe naturelle a touché l'Indonésie en 2018 ?",
    options: [
      "Un tremblement de terre",
      "Un tsunami",
      "Une éruption volcanique",
    ],
    answer: "Un tsunami",
    explanation:
        "Un tsunami a frappé l'Indonésie en 2018, causant de nombreuses pertes humaines et des destructions.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a connu une crise politique majeure en 2021 avec des manifestations massives ?",
    options: ["Biélorussie", "Ukraine", "Hongrie"],
    answer: "Biélorussie",
    explanation:
        "La Biélorussie a connu d'importantes manifestations en 2021 contre le régime de Loukachenko.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement historique a eu lieu en France en 1789 ?",
    options: [
      "La Révolution française",
      "La déclaration des droits de l'homme",
      "Le couronnement de Napoléon",
    ],
    answer: "La Révolution française",
    explanation:
        "La Révolution française a marqué le début d'un changement politique radical en France et en Europe en 1789.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement anti-raciste a été fondé après la mort de George Floyd ?",
    options: ["Black Lives Matter", "Justice pour Alan", "Stop the Violence"],
    answer: "Black Lives Matter",
    explanation:
        "Le mouvement Black Lives Matter a été revitalisé par les événements entourant la mort de George Floyd en 2020.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle crise a été amplifiée par la pandémie de COVID-19 en 2021 ?",
    options: [
      "La crise économique",
      "La crise des réfugiés",
      "La crise alimentaire",
    ],
    answer: "La crise alimentaire",
    explanation:
        "La pandémie a aggravé la crise alimentaire mondiale, affectant des millions de personnes vulnérables.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement social a provoqué des changements dans les politiques de genre en 2017 ?",
    options: ["#MeToo", "Fridays for Future", "Occupy Wall Street"],
    answer: "#MeToo",
    explanation:
        "Le mouvement #MeToo a incité de nombreuses personnes à dénoncer le harcèlement et les agressions sexuelles, entraînant des modifications politiques.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quel événement a célébré son 75e anniversaire en 2020 ?",
    options: [
      "La Déclaration des droits de l'homme",
      "La fin de la Seconde Guerre mondiale",
      "Les Nations Unies",
    ],
    answer: "Les Nations Unies",
    explanation:
        "Les Nations Unies ont célébré leur 75e anniversaire en 2020, renforçant leur engagement pour la paix mondiale.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a été le premier à rendre le vaccin contre la COVID-19 disponible à ses citoyens ?",
    options: ["Royaume-Uni", "Russie", "États-Unis"],
    answer: "Russie",
    explanation:
        "La Russie a été le premier pays à enregistrer un vaccin contre la COVID-19, le Spoutnik V, en août 2020.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays africain a été frappé par une guerre civile majeure après la chute de son président en 2011 ?",
    options: ["Libye", "Soudan", "Yémen"],
    answer: "Libye",
    explanation:
        "La Libye a plongé dans la guerre civile après la chute de Mouammar Kadhafi en 2011, entraînant des conflits internes persistants.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle compétition sportive a été annulée en 2020 en raison de la COVID-19 ?",
    options: [
      "Le tournoi de Wimbledon",
      "Les Jeux Olympiques",
      "Le Tour de France",
    ],
    answer: "Le tournoi de Wimbledon",
    explanation:
        "Le tournoi de Wimbledon a été annulé pour la première fois depuis la Seconde Guerre mondiale en raison de la pandémie.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a pris des mesures strictes pour limiter la propagation du COVID-19 en 2020 ?",
    options: ["Suède", "Nouvelle-Zélande", "Brésil"],
    answer: "Nouvelle-Zélande",
    explanation:
        "La Nouvelle-Zélande a rapidement imposé des confinements stricts pour maîtriser la propagation du virus COVID-19.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a obtenu l'indépendance en 1960, marquant un tournant pour l'Afrique ?",
    options: ["Ghana", "Nigeria", "Sénégal"],
    answer: "Ghana",
    explanation:
        "Le Ghana est devenu le premier pays africain à obtenir son indépendance en 1960, inspirant d'autres nations à suivre son exemple.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question: "Quelle élection a eu lieu en France en 2022 ?",
    options: ["Les législatives", "Les présidentielles", "Les municipales"],
    answer: "Les présidentielles",
    explanation:
        "Les élections présidentielles de 2022 ont déterminé le président de la République française pour le mandat suivant.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel mouvement politique a émergé en réponse aux problèmes environnementaux en 2018 ?",
    options: ["Les Verts", "Fridays for Future", "Les jeunes écologistes"],
    answer: "Fridays for Future",
    explanation:
        "Fridays for Future a été fondé par des étudiants pour défendre des actions contre le changement climatique.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a bénévolement mobilisé des milliers de personnes pour récolter des fonds pour la lutte contre la COVID-19 en 2020 ?",
    options: ["Un marathon virtuel", "Une vente aux enchères", "Un concert"],
    answer: "Un concert",
    explanation:
        "Un concert virtuel a réuni des artistes pour soutenir la lutte contre la COVID-19 en 2020.",
    difficulty: "Moyenne",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle grande compétition sportive a été reportée en 2021 à cause de la COVID-19 ?",
    options: [
      "La Coupe du Monde de football",
      "Les Jeux Olympiques",
      "Le Tour de France",
    ],
    answer: "Les Jeux Olympiques",
    explanation:
        "Les Jeux Olympiques de Tokyo 2020 ont été reportés à 2021 à cause de la pandémie de COVID-19.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a vu des élections historiques en 2021 avec la promesse d'un changement ?",
    options: ["Colombie", "Chili", "Bolivie"],
    answer: "Chili",
    explanation:
        "Le Chili a tenu des élections historiques en 2021, permettant aux citoyens d'élire des représentants pour rédiger une nouvelle constitution.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel personnage historique a été au cœur des discussions sur les droits civiques aux États-Unis ?",
    options: ["Martin Luther King", "Malcolm X", "Rosa Parks"],
    answer: "Martin Luther King",
    explanation:
        "Martin Luther King est une figure emblématique des droits civiques, connu pour ses discours et ses actions pour l'égalité raciale.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel pays a élevé des préoccupations internationales lors des JO de 2020 à cause des droits humains ?",
    options: ["Chine", "Russie", "Iran"],
    answer: "Chine",
    explanation:
        "La Chine a été critiquée pour ses violations des droits humains en lien avec l'organisation des JO de Pékin 2022.",
    difficulty: "Difficile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quelle technologie a provoqué un changement dans la façon de travailler pendant la pandémie ?",
    options: ["Les réseaux sociaux", "La réalité augmentée", "Le télétravail"],
    answer: "Le télétravail",
    explanation:
        "Le télétravail a été largement adopté durant la pandémie, transformant la manière dont les personnes travaillent et collaborent.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement récurrent a eu lieu chaque année depuis 2006 pour promouvoir l'éducation des filles ?",
    options: [
      "Journée internationale des femmes",
      "Journée des droits de l'homme",
      "Journée mondiale des filles",
    ],
    answer: "Journée mondiale des filles",
    explanation:
        "La Journée mondiale des filles, célébrée le 11 octobre, vise à promouvoir les droits et l'éducation des filles dans le monde entier.",
    difficulty: "Facile",
  ),

  QuizQuestion(
    category: "Culture générale — Actualités (intemporel)",
    question:
        "Quel événement a provoqué une atteinte à la liberté d'expression en 2015 en France ?",
    options: [
      "L'attentat contre Charlie Hebdo",
      "Les manifestations contre la loi travail",
      "Les élections régionales",
    ],
    answer: "L'attentat contre Charlie Hebdo",
    explanation:
        "L'attentat contre Charlie Hebdo a suscité une vive réaction en défense de la liberté d'expression en France et dans le monde.",
    difficulty: "Difficile",
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizCultureGeneraleActualite extends StatefulWidget {
  static const String routeName =
      '/gpx_exam/concours/culture_generale_actualite';
  final String uid;
  final String email;

  const QuizCultureGeneraleActualite({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<QuizCultureGeneraleActualite> createState() =>
      _QuizCultureGeneraleActualiteState();
}

class _QuizCultureGeneraleActualiteState
    extends State<QuizCultureGeneraleActualite>
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
        ? questionCultureActualite
        : questionCultureActualite
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
            'module_name': 'Culture générale',
            'quiz_name': 'Quiz culture générale actualité',
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
      await _sb.from('quiz_culture_generale_actualite_pages').insert({
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
      debugPrint('❌ quiz_culture_generale_actualite_pages insert failed: $e');
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
