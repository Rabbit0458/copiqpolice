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

final List<QuizQuestion> questionVioletIncesteetAgression = [
  // =========================================================
  // FACILE
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle — Contrainte par un tiers',
    question:
        'Le fait d’imposer à une personne de subir une atteinte sexuelle de la part d’un tiers constitue :',
    options: [
      'Une agression sexuelle',
      'Un viol systématique',
      'Une contravention',
    ],
    answer: 'Une agression sexuelle',
    explanation:
        'L’article 222-22-2 du Code pénal qualifie ces faits d’agression sexuelle.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Moyens',
    question:
        'Quels sont les moyens exclusifs de tout consentement libre de la victime ?',
    options: [
      'Violence, contrainte, menace ou surprise',
      'Erreur, imprudence ou négligence',
      'Pression sociale uniquement',
    ],
    answer: 'Violence, contrainte, menace ou surprise',
    explanation:
        'Ces moyens sont expressément prévus par les articles 222-22 et suivants du Code pénal.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Viol — Définition',
    question: 'Le viol se caractérise par :',
    options: [
      'Tout acte de pénétration sexuelle ou bucco-génital imposé',
      'Tout contact physique à connotation sexuelle',
      'Tout comportement sexiste répété',
    ],
    answer: 'Tout acte de pénétration sexuelle ou bucco-génital imposé',
    explanation:
        'L’article 222-23 du Code pénal définit le viol par la pénétration ou l’acte bucco-génital.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Définition',
    question: 'Une agression sexuelle suppose :',
    options: [
      'Un contact physique sans pénétration ni acte bucco-génital',
      'Une pénétration sexuelle',
      'Une simple parole déplacée',
    ],
    answer: 'Un contact physique sans pénétration ni acte bucco-génital',
    explanation:
        'L’agression sexuelle implique un contact physique sans pénétration.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Consentement — Principe',
    question: 'La violence, la contrainte, la menace ou la surprise sont :',
    options: [
      'Exclusives de tout consentement libre',
      'Compatibles avec le consentement',
      'Appréciées uniquement chez les mineurs',
    ],
    answer: 'Exclusives de tout consentement libre',
    explanation:
        'Ces moyens suppriment juridiquement toute possibilité de consentement.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // MOYENNE
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle — Surprise',
    question: 'La surprise s’entend juridiquement comme :',
    options: [
      'Le fait de surprendre le consentement de la victime',
      'La réaction émotionnelle de la victime',
      'Un événement imprévisible',
    ],
    answer: 'Le fait de surprendre le consentement de la victime',
    explanation:
        'La surprise vise l’absence de capacité à consentir au moment des faits.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Vulnérabilité',
    question:
        'Une personne atteinte de troubles mentaux est juridiquement considérée comme :',
    options: [
      'Incapable de consentir',
      'Responsable de son consentement',
      'Partiellement consentante',
    ],
    answer: 'Incapable de consentir',
    explanation:
        'La jurisprudence considère ces personnes comme vulnérables et incapables de consentir.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Mineur — Consentement',
    question:
        'Un mineur de moins de 15 ans peut-il consentir à un acte sexuel avec un majeur ?',
    options: [
      'Non, le consentement est juridiquement exclu',
      'Oui, sous conditions',
      'Oui, si absence de violence',
    ],
    answer: 'Non, le consentement est juridiquement exclu',
    explanation:
        'La loi considère qu’un mineur de 15 ans n’a pas le discernement nécessaire.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Viol par surprise',
    question:
        'L’état d’ivresse de la victime permet de qualifier les faits de :',
    options: [
      'Viol par surprise',
      'Agression sexuelle simple',
      'Absence d’infraction',
    ],
    answer: 'Viol par surprise',
    explanation:
        'La jurisprudence admet la qualification de viol par surprise en cas d’ivresse.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Auteur',
    question: 'L’auteur d’une agression sexuelle incestueuse doit être :',
    options: ['Un majeur', 'Un mineur', 'Indifféremment majeur ou mineur'],
    answer: 'Un majeur',
    explanation:
        'L’agression sexuelle incestueuse n’est imputable qu’à un auteur majeur.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Viol incestueux — Condition',
    question:
        'Le seul lien de parenté suffit-il à caractériser le viol incestueux ?',
    options: [
      'Non, une autorité de droit ou de fait est exigée',
      'Oui, toujours',
      'Oui uniquement pour les ascendants',
    ],
    answer: 'Non, une autorité de droit ou de fait est exigée',
    explanation:
        'La jurisprudence exige un rapport d’autorité en plus du lien familial.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // DIFFICILE
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle — Contrainte morale',
    question: 'La contrainte morale peut être caractérisée par :',
    options: [
      'Une différence d’âge significative et une autorité de fait',
      'Une simple insistance verbale',
      'Un malentendu affectif',
    ],
    answer: 'Une différence d’âge significative et une autorité de fait',
    explanation:
        'La jurisprudence reconnaît la contrainte morale dans ces situations.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Administration de substances — Soumission chimique',
    question: 'La soumission chimique suppose :',
    options: [
      'Une administration à l’insu de la victime',
      'Une consommation volontaire',
      'Une simple fatigue',
    ],
    answer: 'Une administration à l’insu de la victime',
    explanation:
        'L’article 222-30-1 exige une administration à l’insu de la victime.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Intention',
    question: 'L’élément moral du viol repose sur :',
    options: [
      'La conscience d’imposer un rapport sexuel non consenti',
      'Le résultat subi par la victime',
      'La durée des faits',
    ],
    answer: 'La conscience d’imposer un rapport sexuel non consenti',
    explanation:
        'L’intention coupable réside dans la conscience de l’absence de consentement.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol incestueux — Mineur',
    question:
        'Dans le viol incestueux sur mineur, la preuve de la violence est-elle exigée ?',
    options: [
      'Non, le consentement est juridiquement exclu',
      'Oui, toujours',
      'Uniquement en cas de plainte',
    ],
    answer: 'Non, le consentement est juridiquement exclu',
    explanation:
        'La loi écarte la nécessité de prouver violence, contrainte ou surprise.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Acte unique',
    question:
        'Un acte unique peut constituer un harcèlement sexuel lorsqu’il :',
    options: [
      'Constitue une pression grave pour obtenir un acte sexuel',
      'Est simplement déplacé',
      'Est ambigu',
    ],
    answer: 'Constitue une pression grave pour obtenir un acte sexuel',
    explanation:
        'La loi assimile certains actes uniques graves au harcèlement sexuel.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Consentement',
    question:
        'La victime doit-elle exprimer explicitement son refus pour caractériser le harcèlement ?',
    options: [
      'Non, un faisceau d’indices suffit',
      'Oui, obligatoirement',
      'Uniquement par écrit',
    ],
    answer: 'Non, un faisceau d’indices suffit',
    explanation:
        'La jurisprudence n’exige pas une opposition explicite de la victime.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 🔴 VIOL — NIVEAU CONCOURS
  // =========================================================
  const QuizQuestion(
    category: 'Viol — Élément légal',
    question:
        'Quel article du Code pénal définit le viol commis par violence, contrainte, menace ou surprise ?',
    options: [
      'Article 222-23 du Code pénal',
      'Article 222-22-2 du Code pénal',
      'Article 222-29-2 du Code pénal',
    ],
    answer: 'Article 222-23 du Code pénal',
    explanation:
        'L’article 222-23 du Code pénal définit le viol par violence, contrainte, menace ou surprise.',
    difficulty: 'Concours',
  ),

  const QuizQuestion(
    category: 'Viol — Acte matériel',
    question: 'Lequel de ces actes peut juridiquement constituer un viol ?',
    options: [
      'Une fellation imposée',
      'Une parole obscène',
      'Un regard insistant',
    ],
    answer: 'Une fellation imposée',
    explanation:
        'Tout acte bucco-génital imposé constitue un viol au sens de l’article 222-23.',
    difficulty: 'Concours',
  ),

  const QuizQuestion(
    category: 'Viol — Surprise',
    question: 'La surprise peut être retenue lorsque la victime :',
    options: [
      'Était dans l’impossibilité de consentir au moment des faits',
      'A exprimé sa stupeur après les faits',
      'A changé d’avis ultérieurement',
    ],
    answer: 'Était dans l’impossibilité de consentir au moment des faits',
    explanation:
        'La surprise vise la captation du consentement et non l’émotion ressentie.',
    difficulty: 'Concours',
  ),

  const QuizQuestion(
    category: 'Viol — Ivresse',
    question: 'L’état d’ivresse volontaire de la victime permet :',
    options: [
      'La qualification de viol par surprise',
      'D’exclure toute infraction',
      'De retenir une simple contravention',
    ],
    answer: 'La qualification de viol par surprise',
    explanation:
        'La jurisprudence admet la surprise lorsque la victime est ivre.',
    difficulty: 'Concours',
  ),

  const QuizQuestion(
    category: 'Viol — Tentative',
    question: 'La tentative de viol est-elle punissable ?',
    options: [
      'Oui, comme le crime consommé',
      'Non, faute de résultat',
      'Uniquement en cas de blessure',
    ],
    answer: 'Oui, comme le crime consommé',
    explanation: 'La tentative de viol est expressément punissable.',
    difficulty: 'Concours',
  ),

  const QuizQuestion(
    category: 'Viol — Aggravation',
    question: 'Le viol est aggravé lorsqu’il est commis :',
    options: [
      'Par plusieurs personnes agissant comme auteurs ou complices',
      'Par une seule personne isolée',
      'Sans violence apparente',
    ],
    answer: 'Par plusieurs personnes agissant comme auteurs ou complices',
    explanation:
        'La pluralité d’auteurs ou complices constitue une circonstance aggravante.',
    difficulty: 'Concours',
  ),

  // =========================================================
  // 🟣 INCESTE — VIOL & AGRESSION SEXUELLE
  // =========================================================
  const QuizQuestion(
    category: 'Viol incestueux — Définition',
    question: 'Le viol incestueux suppose :',
    options: [
      'Un lien de parenté et une autorité de droit ou de fait',
      'Uniquement un lien de parenté',
      'Uniquement une différence d’âge',
    ],
    answer: 'Un lien de parenté et une autorité de droit ou de fait',
    explanation:
        'Le lien familial seul ne suffit pas, l’autorité doit être démontrée.',
    difficulty: 'Concours',
  ),

  const QuizQuestion(
    category: 'Viol incestueux — Victime',
    question: 'La victime du viol incestueux doit être :',
    options: [
      'Mineure',
      'Majeure uniquement',
      'Indifféremment majeure ou mineure',
    ],
    answer: 'Mineure',
    explanation:
        'Le viol incestueux est une infraction protégeant spécifiquement les mineurs.',
    difficulty: 'Concours',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle incestueuse',
    question:
        'L’agression sexuelle incestueuse nécessite-t-elle la preuve d’une violence ?',
    options: ['Non', 'Oui systématiquement', 'Uniquement en cas de plainte'],
    answer: 'Non',
    explanation: 'Le consentement du mineur est juridiquement exclu.',
    difficulty: 'Concours',
  ),

  const QuizQuestion(
    category: 'Inceste — Auteur',
    question: 'Qui peut être auteur d’une infraction incestueuse ?',
    options: [
      'Un ascendant ou une personne ayant autorité',
      'Un ami de la famille sans autorité',
      'Un mineur',
    ],
    answer: 'Un ascendant ou une personne ayant autorité',
    explanation: 'La loi énumère précisément les personnes concernées.',
    difficulty: 'Concours',
  ),

  const QuizQuestion(
    category: 'Inceste — Jurisprudence',
    question:
        'Le partenaire pacsé d’une tante peut être qualifié d’auteur incestueux :',
    options: [
      'Seulement s’il exerce une autorité de droit ou de fait',
      'Toujours',
      'Jamais',
    ],
    answer: 'Seulement s’il exerce une autorité de droit ou de fait',
    explanation: 'Cass. crim., 15 mars 2023.',
    difficulty: 'Concours',
  ),

  // =========================================================
  // 🔵 HARCÈLEMENT SEXUEL — NIVEAU CONCOURS
  // =========================================================
  const QuizQuestion(
    category: 'Harcèlement sexuel — Définition',
    question: 'Le harcèlement sexuel suppose :',
    options: [
      'Des propos ou comportements imposés',
      'Un contact physique obligatoire',
      'Une relation sexuelle consommée',
    ],
    answer: 'Des propos ou comportements imposés',
    explanation: 'Le contact physique n’est pas exigé.',
    difficulty: 'Concours',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Répétition',
    question: 'La répétition des faits peut être caractérisée :',
    options: [
      'Par plusieurs auteurs successifs',
      'Uniquement par un seul auteur',
      'Uniquement sur une longue durée',
    ],
    answer: 'Par plusieurs auteurs successifs',
    explanation: 'La loi de 2018 a élargi la notion de répétition.',
    difficulty: 'Concours',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Acte unique',
    question:
        'Un acte unique peut constituer un harcèlement sexuel lorsqu’il :',
    options: [
      'Exerce une pression grave pour obtenir un acte sexuel',
      'Est simplement déplacé',
      'Est ambigu',
    ],
    answer: 'Exerce une pression grave pour obtenir un acte sexuel',
    explanation: 'La pression grave suffit sans répétition.',
    difficulty: 'Concours',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Autorité',
    question: 'Le harcèlement sexuel est aggravé lorsqu’il est commis :',
    options: [
      'Par abus d’autorité',
      'Entre collègues de même niveau',
      'Sans témoin',
    ],
    answer: 'Par abus d’autorité',
    explanation: 'L’abus d’autorité constitue une circonstance aggravante.',
    difficulty: 'Concours',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Consentement',
    question: 'La victime doit-elle exprimer clairement son refus ?',
    options: ['Non', 'Oui obligatoirement', 'Uniquement par écrit'],
    answer: 'Non',
    explanation:
        'L’absence de consentement peut résulter d’un faisceau d’indices.',
    difficulty: 'Concours',
  ),

  // =========================================================
  // 🔴 VIOL — SUITE (mix Moyenne / Difficile)
  // =========================================================
  const QuizQuestion(
    category: 'Viol — Acte de pénétration',
    question: 'Au sens du Code pénal, le viol vise :',
    options: [
      'Tout acte de pénétration sexuelle, de quelque nature qu’il soit',
      'Uniquement la pénétration vaginale',
      'Uniquement la pénétration avec violence physique',
    ],
    answer: 'Tout acte de pénétration sexuelle, de quelque nature qu’il soit',
    explanation:
        'L’article 222-23 vise tout acte de pénétration sexuelle, sans exclure de pratiques.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Viol — Acte bucco-génital',
    question: 'Un acte bucco-génital, au sens pénal, suppose :',
    options: [
      'Un contact bouche / sexe, sans exigence de “pénétration”',
      'Uniquement la pénétration du sexe dans la bouche',
      'Uniquement un acte réalisé par un homme',
    ],
    answer: 'Un contact bouche / sexe, sans exigence de “pénétration”',
    explanation:
        'Le cours précise qu’un contact suffit pour caractériser l’acte bucco-génital.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Viol — Condition de la victime',
    question: 'La qualification de viol peut être retenue quelle que soit :',
    options: [
      'La nature des relations existant entre l’auteur et la victime (y compris mariage)',
      'La plainte immédiate de la victime',
      'La présence obligatoire de blessures',
    ],
    answer:
        'La nature des relations existant entre l’auteur et la victime (y compris mariage)',
    explanation:
        'Le cours rappelle l’indifférence des relations, y compris les liens du mariage.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Viol — Absence de consentement',
    question: 'Les moyens “violence, contrainte, menace, surprise” sont dits :',
    options: [
      'Exclusifs de tout consentement libre',
      'Compatibles avec un consentement implicite',
      'Réservés aux seuls mineurs',
    ],
    answer: 'Exclusifs de tout consentement libre',
    explanation:
        'Ils caractérisent l’absence de consentement libre au moment des faits.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Viol — Contrainte',
    question: 'La contrainte constitutive du viol peut être :',
    options: [
      'Physique ou morale',
      'Uniquement physique',
      'Uniquement économique',
    ],
    answer: 'Physique ou morale',
    explanation:
        'Le cours rappelle que la contrainte peut être physique ou morale (222-22-1).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Viol — Menace',
    question: 'La menace/contrainte doit inspirer à la victime une crainte :',
    options: [
      'Sérieuse et immédiate',
      'Vague et hypothétique',
      'Uniquement liée à un dommage financier',
    ],
    answer: 'Sérieuse et immédiate',
    explanation:
        'Le cours : crainte sérieuse et immédiate, appréciée concrètement selon la victime.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Viol — Surprise',
    question: 'La surprise s’entend comme :',
    options: [
      'Surprendre le consentement de la victime',
      'La surprise ressentie après les faits',
      'Une simple absence de témoin',
    ],
    answer: 'Surprendre le consentement de la victime',
    explanation:
        'Le cours insiste : surprise = captation du consentement, pas l’émotion exprimée.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Viol — Vulnérabilité (alcool/stupéfiants)',
    question:
        'La consommation volontaire d’alcool ou de stupéfiants par la victime caractérise :',
    options: [
      'Pas, à elle seule, une vulnérabilité ouvrant l’aggravation',
      'Toujours une circonstance aggravante',
      'Toujours l’absence d’infraction',
    ],
    answer: 'Pas, à elle seule, une vulnérabilité ouvrant l’aggravation',
    explanation:
        'Le cours : consommation “en toute connaissance” ≠ vulnérabilité aggravante.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Substance à l’insu',
    question:
        'Administrer à l’insu de la victime une substance altérant le discernement est :',
    options: [
      'Une circonstance aggravante du viol',
      'Une cause d’irresponsabilité',
      'Sans effet juridique',
    ],
    answer: 'Une circonstance aggravante du viol',
    explanation:
        'Le cours : l’administration à l’insu pour altérer discernement/contrôle aggrave le viol.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Aggravation (mineur présent)',
    question: 'Le viol est aggravé lorsque :',
    options: [
      'Un mineur était présent au moment des faits et y a assisté',
      'La victime est majeure',
      'Les faits ont lieu de jour',
    ],
    answer: 'Un mineur était présent au moment des faits et y a assisté',
    explanation:
        'Le cours liste la présence d’un mineur assistant aux faits comme aggravation.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Aggravation (auteur ivre/stupéfiants)',
    question: 'Le viol est aggravé lorsqu’il est commis par une personne :',
    options: [
      'En état d’ivresse manifeste ou sous emprise manifeste de stupéfiants',
      'Ayant bu un verre sans signe apparent',
      'Souffrant de stress uniquement',
    ],
    answer:
        'En état d’ivresse manifeste ou sous emprise manifeste de stupéfiants',
    explanation:
        'Le cours retient l’ivresse/emprise “manifeste” comme circonstance aggravante.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Peines (simple)',
    question: 'Le viol simple (222-23) est puni de :',
    options: [
      '15 ans de réclusion criminelle',
      '10 ans d’emprisonnement',
      '20 ans de réclusion criminelle',
    ],
    answer: '15 ans de réclusion criminelle',
    explanation: 'Le cours : viol simple = 15 ans de réclusion.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Viol — Aggravation 1er degré (222-24)',
    question: 'Le 1er degré d’aggravation du viol (222-24) entraîne :',
    options: [
      '20 ans de réclusion criminelle',
      '30 ans de réclusion criminelle',
      'La perpétuité',
    ],
    answer: '20 ans de réclusion criminelle',
    explanation: 'Le cours : viol aggravé 1er degré (222-24) = 20 ans.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Aggravation 2e degré (222-25)',
    question:
        'Le 2e degré d’aggravation du viol (222-25) correspond notamment à :',
    options: ['La mort de la victime', 'La simple ITT', 'L’absence de plainte'],
    answer: 'La mort de la victime',
    explanation: 'Le cours : 222-25 vise le viol ayant entraîné la mort.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Aggravation 3e degré (222-26)',
    question: 'Le 3e degré d’aggravation du viol (222-26) vise :',
    options: [
      'Tortures ou actes de barbarie',
      'Le vol de téléphone',
      'Le mensonge',
    ],
    answer: 'Tortures ou actes de barbarie',
    explanation:
        'Le cours : 222-26 = viol précédé/accompagné/suivi de tortures ou barbarie.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Provocation (infraction distincte)',
    question:
        'Faire des offres/promesses pour qu’une personne commette un viol, si le crime n’a été ni commis ni tenté, relève :',
    options: [
      'D’une infraction distincte (provocation à commettre un viol)',
      'Uniquement de la complicité',
      'D’une contravention',
    ],
    answer: 'D’une infraction distincte (provocation à commettre un viol)',
    explanation:
        'Le cours : 222-26-1 incrimine l’instigation même si aucun viol n’est commis/ tenté.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 🟣 INCESTE — SUITE (viol incestueux + agression sexuelle incestueuse)
  // =========================================================
  const QuizQuestion(
    category: 'Viol incestueux (222-23-2) — Élément légal',
    question: 'Le viol incestueux est défini par :',
    options: [
      'L’article 222-23-2 du Code pénal',
      'L’article 222-29-2 du Code pénal',
      'L’article 222-15 du Code pénal',
    ],
    answer: 'L’article 222-23-2 du Code pénal',
    explanation:
        'Le cours : 222-23-2 définit le viol incestueux (hors 222-23).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Inceste — Liste des personnes (222-22-3)',
    question: 'L’article 222-22-3 fixe une liste :',
    options: [
      'Exhaustive des liens de parenté visés',
      'Indicative, laissant le juge libre',
      'Limitée aux seuls ascendants',
    ],
    answer: 'Exhaustive des liens de parenté visés',
    explanation:
        'Le cours : 222-22-3 établit une liste exhaustive des liens de parenté concernés.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Inceste — Liens visés',
    question: 'Parmi ces liens, lequel est visé par 222-22-3 ?',
    options: ['Oncle / tante', 'Cousin germain', 'Ami d’enfance'],
    answer: 'Oncle / tante',
    explanation:
        'Le cours cite oncles/tantes parmi les liens de parenté visés.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Inceste — Conjoints/concubins/PACS',
    question:
        'Sont aussi visés : les conjoints/concubins/partenaires PACS des personnes listées :',
    options: ['Oui', 'Non', 'Uniquement le conjoint marié'],
    answer: 'Oui',
    explanation:
        'Le cours : la liste inclut conjoints, concubins ou partenaires PACS de ces personnes.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol incestueux — Autorité',
    question:
        'Pour qualifier le viol incestueux, il faut en plus du lien familial démontrer :',
    options: [
      'Une autorité de droit ou de fait sur le mineur',
      'Une différence d’âge d’au moins 5 ans',
      'Une plainte immédiate',
    ],
    answer: 'Une autorité de droit ou de fait sur le mineur',
    explanation:
        'Le cours : lien de parenté seul insuffisant, autorité de droit (parents) ou de fait requise.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle incestueuse (222-29-3) — Victime',
    question: 'L’agression sexuelle incestueuse vise une victime :',
    options: [
      'Mineure (moins de 18 ans)',
      'Uniquement mineure de 15 ans',
      'Majeure uniquement',
    ],
    answer: 'Mineure (moins de 18 ans)',
    explanation:
        'Le cours : agression sexuelle incestueuse = mineur de moins de 18 ans.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle incestueuse — Consentement',
    question:
        'Dans l’agression sexuelle incestueuse sur mineur, la question du consentement :',
    options: [
      'Ne se pose pas juridiquement',
      'Est centrale et doit être prouvée',
      'Dépend uniquement de la maturité',
    ],
    answer: 'Ne se pose pas juridiquement',
    explanation:
        'Le cours : un mineur ne peut consentir dans ce contexte de lien/autorité.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Inceste — Jurisprudence (partenaire de la tante)',
    question:
        'Le partenaire pacsé de la tante de la victime n’est qualifiable d’incestueux que si :',
    options: [
      'L’autorité de droit ou de fait sur la victime est rapportée',
      'Le lien PACS suffit',
      'La victime a moins de 15 ans',
    ],
    answer: 'L’autorité de droit ou de fait sur la victime est rapportée',
    explanation:
        'Le cours cite une décision : sans autorité démontrée, pas de qualification incestueuse.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Inceste — Surqualification (victime majeure)',
    question: 'Si la victime est majeure, la “surqualification” incestueuse :',
    options: [
      'Peut s’appliquer sans véritable conséquence juridique',
      'Supprime la nécessité de violence/contrainte',
      'Transforme automatiquement en crime',
    ],
    answer: 'Peut s’appliquer sans véritable conséquence juridique',
    explanation:
        'Le cours : surqualification possible mais sans conséquence juridique réelle.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 🔵 HARCÈLEMENT SEXUEL — SUITE (niveau pièges)
  // =========================================================
  const QuizQuestion(
    category: 'Harcèlement sexuel — Définition (répétition)',
    question:
        'Le harcèlement sexuel (forme “répétée”) consiste notamment à imposer :',
    options: [
      'Des propos/comportements à connotation sexuelle ou sexiste, de façon répétée',
      'Une pénétration sexuelle',
      'Un acte bucco-génital',
    ],
    answer:
        'Des propos/comportements à connotation sexuelle ou sexiste, de façon répétée',
    explanation:
        'Le cours : propos/comportements répétés, dégradants/humiliants ou intimidants/hostiles/offensants.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Connotation',
    question:
        'Pour caractériser l’élément matériel, il faut un caractère explicitement sexuel :',
    options: [
      'Non, une connotation sexuelle ou sexiste suffit',
      'Oui, obligatoirement',
      'Uniquement en milieu professionnel',
    ],
    answer: 'Non, une connotation sexuelle ou sexiste suffit',
    explanation:
        'Le cours : un caractère explicitement et directement sexuel n’est pas exigé.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Absence de consentement',
    question:
        'La victime doit exprimer de manière expresse et explicite qu’elle n’est pas consentante :',
    options: [
      'Non',
      'Oui, sinon pas d’infraction',
      'Uniquement si les faits sont en ligne',
    ],
    answer: 'Non',
    explanation:
        'Le cours : l’absence de consentement peut se déduire d’un faisceau d’indices.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Répétition (un seul auteur)',
    question: 'Avec un seul auteur, il faut au minimum :',
    options: [
      'Deux faits (au moins deux reprises)',
      'Trois faits sur un mois',
      'Un fait unique seulement',
    ],
    answer: 'Deux faits (au moins deux reprises)',
    explanation:
        'Le cours : au moins deux reprises, sans délai minimum entre les actes.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Plusieurs auteurs (concertation)',
    question:
        'Le harcèlement sexuel peut être constitué si plusieurs personnes imposent des propos :',
    options: [
      'De manière concertée ou à l’instigation de l’une d’elles, même sans répétition individuelle',
      'Uniquement si chaque auteur répète au moins 2 fois',
      'Uniquement hors internet',
    ],
    answer:
        'De manière concertée ou à l’instigation de l’une d’elles, même sans répétition individuelle',
    explanation:
        'Le cours : “raids numériques” et extension aux agissements multiples concertés.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Plusieurs auteurs (successivement)',
    question:
        'Le harcèlement sexuel peut aussi être constitué si plusieurs personnes agissent successivement en sachant :',
    options: [
      'Que cela caractérise une répétition',
      'Que la victime a porté plainte',
      'Que l’auteur principal est majeur',
    ],
    answer: 'Que cela caractérise une répétition',
    explanation:
        'Le cours : successivement, même sans concertation, dès lors qu’ils savent la répétition.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Acte unique assimilé',
    question:
        'Est assimilé au harcèlement sexuel le fait (même non répété) de :',
    options: [
      'User d’une pression grave pour obtenir un acte de nature sexuelle',
      'Tenir un propos maladroit isolé sans pression',
      'Refuser une relation',
    ],
    answer: 'User d’une pression grave pour obtenir un acte de nature sexuelle',
    explanation:
        'Le cours : pression grave, but réel ou apparent d’obtenir un acte sexuel.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Finalité',
    question:
        'Dans la forme “acte unique”, la finalité d’obtenir un acte sexuel peut être :',
    options: [
      'Réelle ou apparente',
      'Uniquement réelle',
      'Uniquement reconnue par aveu',
    ],
    answer: 'Réelle ou apparente',
    explanation:
        'Le cours : but réel ou apparent, pas besoin de dol spécial difficile à prouver.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Aggravation',
    question:
        'Le harcèlement sexuel est aggravé notamment lorsqu’il est commis :',
    options: [
      'Par l’utilisation d’un service de communication au public en ligne',
      'Sans témoin',
      'Dans un lieu public uniquement',
    ],
    answer:
        'Par l’utilisation d’un service de communication au public en ligne',
    explanation:
        'Le cours : circonstance aggravante via support numérique/communication en ligne.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Aggravation (abus autorité)',
    question: 'Le harcèlement sexuel est aggravé lorsqu’il est commis :',
    options: [
      'Par une personne abusant de l’autorité que lui confèrent ses fonctions',
      'Par un inconnu dans la rue uniquement',
      'Par un mineur uniquement',
    ],
    answer:
        'Par une personne abusant de l’autorité que lui confèrent ses fonctions',
    explanation:
        'Le cours : abus d’autorité fonctionnelle = circonstance aggravante.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 🧪 SUBSTANCES — (222-30-1 + 222-15) LIÉES AUX INFRACTIONS SEXUELLES
  // =========================================================
  const QuizQuestion(
    category: 'Soumission chimique (222-30-1) — Élément légal',
    question:
        'L’infraction d’administration d’une substance afin de commettre un viol/agression sexuelle est prévue par :',
    options: [
      'L’article 222-30-1 du Code pénal',
      'L’article 222-15 du Code pénal',
      'L’article 222-29-3 du Code pénal',
    ],
    answer: 'L’article 222-30-1 du Code pénal',
    explanation:
        'Le cours : 222-30-1 définit l’administration à l’insu pour viol/agression sexuelle.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Soumission chimique (222-30-1) — Condition',
    question: 'La victime doit être “à son insu” signifie :',
    options: [
      'Elle ne se doute pas qu’on lui administre la substance',
      'Elle accepte explicitement la substance',
      'Elle boit volontairement de l’alcool',
    ],
    answer: 'Elle ne se doute pas qu’on lui administre la substance',
    explanation: 'Le cours : l’action échappe à l’attention de la victime.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Soumission chimique — Volontaire vs insu',
    question:
        'La consommation volontaire d’alcool/stupéfiants suffit à caractériser 222-30-1 :',
    options: ['Non', 'Oui', 'Oui uniquement si la victime est mineure'],
    answer: 'Non',
    explanation: 'Le cours : 222-30-1 exige une administration à l’insu.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Soumission chimique (222-30-1) — But',
    question: 'L’administration à l’insu doit être faite :',
    options: [
      'Dans le but de commettre un viol ou une agression sexuelle',
      'Dans un but thérapeutique uniquement',
      'Sans intention particulière',
    ],
    answer: 'Dans le but de commettre un viol ou une agression sexuelle',
    explanation:
        'Le cours : finalité = profiter de la “soumission chimique” pour viol/agression.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Soumission chimique (222-30-1) — Aggravations',
    question:
        'L’infraction 222-30-1 est aggravée notamment si les faits sont commis sur :',
    options: [
      'Un mineur de 15 ans ou une personne particulièrement vulnérable',
      'Un majeur de 25 ans',
      'Un témoin',
    ],
    answer: 'Un mineur de 15 ans ou une personne particulièrement vulnérable',
    explanation:
        'Le cours : aggravation si mineur de 15 ans ou vulnérabilité apparente/connue.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Administration substances nuisibles (222-15) — Définition',
    question: 'L’administration de substances nuisibles suppose :',
    options: [
      'Une substance provoquant une atteinte physique ou psychique',
      'Une substance seulement illégale',
      'Une substance uniquement ingérée',
    ],
    answer: 'Une substance provoquant une atteinte physique ou psychique',
    explanation:
        'Le cours : peu importe la nature exacte, dès lors qu’elle est de nature à provoquer une atteinte.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Administration substances nuisibles — Résultat',
    question:
        'L’infraction d’administration de substances nuisibles est une infraction :',
    options: [
      'Matérielle nécessitant un résultat dommageable',
      'Formelle sans résultat',
      'Contraventionnelle',
    ],
    answer: 'Matérielle nécessitant un résultat dommageable',
    explanation:
        'Le cours : il faut une atteinte à la santé (résultat), sinon pas d’infraction.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Administration substances nuisibles — Tentative',
    question: 'La tentative d’administration de substances nuisibles est :',
    options: [
      'Non punissable',
      'Toujours punissable',
      'Punissable seulement sur mineur',
    ],
    answer: 'Non punissable',
    explanation:
        'Le cours : pas de tentative en correctionnel + infraction matérielle nécessitant un résultat.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 🧩 222-22-2 — CONTRAINDRE À SUBIR UNE ATTEINTE SEXUELLE D’UN TIERS
  // =========================================================
  const QuizQuestion(
    category: '222-22-2 — Nature',
    question:
        'Imposer à une personne de subir une atteinte sexuelle de la part d’un tiers est :',
    options: [
      'Une agression sexuelle',
      'Une complicité automatique du tiers',
      'Une simple atteinte sexuelle',
    ],
    answer: 'Une agression sexuelle',
    explanation: 'Le cours : 222-22-2 qualifie ces faits d’agression sexuelle.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: '222-22-2 — Tiers de bonne foi',
    question:
        'Le tiers qui commet l’acte sexuel peut être non informé de la contrainte :',
    options: [
      'Oui, l’auteur de la contrainte reste poursuivable',
      'Non, l’infraction tombe',
      'Oui, mais uniquement si la victime est majeure',
    ],
    answer: 'Oui, l’auteur de la contrainte reste poursuivable',
    explanation:
        'Le cours : l’incrimination couvre même si le tiers ignore la contrainte.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: '222-22-2 — Atteinte sur soi-même',
    question: '222-22-2 vise aussi le fait d’imposer à la victime :',
    options: [
      'De procéder sur elle-même à une atteinte sexuelle',
      'De porter plainte',
      'De se taire',
    ],
    answer: 'De procéder sur elle-même à une atteinte sexuelle',
    explanation: 'Le cours : l’auteur peut imposer un acte sur soi-même.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: '222-22-2 — Peines',
    question: 'Les faits de 222-22-2 sont punis :',
    options: [
      'Des peines prévues pour les viols/agressions selon la nature de l’atteinte',
      'D’une peine fixe de 2 ans',
      'Uniquement d’une amende',
    ],
    answer:
        'Des peines prévues pour les viols/agressions selon la nature de l’atteinte',
    explanation:
        'Le cours : renvoi aux articles 222-23 à 222-30 selon atteinte + circonstances.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: '222-22-2 — Tentative',
    question: 'La tentative de 222-22-2 est :',
    options: [
      'Oui, spécialement prévue',
      'Non',
      'Oui uniquement si l’acte sexuel a eu lieu',
    ],
    answer: 'Oui, spécialement prévue',
    explanation:
        'Le cours : la tentative est prévue par l’alinéa 3 de 222-22-2.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: '222-22-2 — Complicité',
    question: 'La complicité est :',
    options: [
      'Oui (aide/assistance, provocation, instructions)',
      'Non',
      'Oui uniquement si le tiers est complice',
    ],
    answer: 'Oui (aide/assistance, provocation, instructions)',
    explanation:
        'Le cours : complicité possible selon 121-7, sur le fait principal de contraindre.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ✅ BONUS — MINEUR <15 : VIOL / AGRESSION (clause “Roméo et Juliette”)
  // =========================================================
  const QuizQuestion(
    category: 'Viol majeur / mineur <15 (222-23-1) — Différence d’âge',
    question:
        'Le viol “majeur sur mineur de 15 ans” (hors 222-23) suppose en principe :',
    options: [
      'Une différence d’âge d’au moins 5 ans',
      'Une différence d’âge d’au moins 2 ans',
      'Aucune condition d’âge',
    ],
    answer: 'Une différence d’âge d’au moins 5 ans',
    explanation:
        'Le cours : clause “Roméo et Juliette” = seuil 5 ans, sauf contrepartie.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol majeur / mineur <15 — Exception contrepartie',
    question:
        'Si l’écart d’âge est inférieur à 5 ans, le viol peut être retenu si :',
    options: [
      'Les faits sont commis en échange d’une rémunération ou avantage (ou promesse)',
      'La victime ne crie pas',
      'Les faits ont lieu la nuit',
    ],
    answer:
        'Les faits sont commis en échange d’une rémunération ou avantage (ou promesse)',
    explanation:
        'Le cours : la condition d’écart d’âge ne s’applique pas en cas de contrepartie.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category:
        'Agression sexuelle majeur / mineur <15 (222-29-2) — Différence d’âge',
    question:
        'L’agression sexuelle (autre qu’un viol) commise par un majeur sur un mineur de 15 ans suppose en principe :',
    options: [
      'Au moins 5 ans d’écart',
      'Au moins 10 ans d’écart',
      'Aucun écart',
    ],
    answer: 'Au moins 5 ans d’écart',
    explanation: 'Le cours : 222-29-2 = écart ≥ 5 ans, sauf contrepartie.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle majeur / mineur <15 — Peines',
    question: 'L’agression sexuelle 222-29-2 est punie de :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation: 'Le tableau du cours indique 10 ans et 150 000 €.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 🔴 VIOL — SUITE (aggravations / nuances / pièges)
  // =========================================================
  const QuizQuestion(
    category: 'Viol — Pénétration (exemples)',
    question: 'Laquelle de ces situations peut constituer un viol ?',
    options: [
      'Introduction d’un doigt dans le sexe ou l’anus',
      'Attouchements sur les vêtements',
      'Propos sexuels répétés',
    ],
    answer: 'Introduction d’un doigt dans le sexe ou l’anus',
    explanation:
        'Le cours rappelle que tout acte de pénétration sexuelle, quelle que soit sa nature, entre dans le champ du viol.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Viol — Consentement et passé sexuel',
    question:
        'Le fait que la victime ait déjà eu des relations consenties avec l’auteur :',
    options: [
      'N’écarte pas la qualification de viol si l’acte est imposé',
      'Exclut automatiquement l’infraction',
      'Transforme l’infraction en simple harcèlement',
    ],
    answer: 'N’écarte pas la qualification de viol si l’acte est imposé',
    explanation:
        'Le cours précise l’indifférence de la condition de la victime (y compris relations antérieures).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Viol — Victime décédée',
    question: 'Peut-on qualifier “viol” des actes commis sur un cadavre ?',
    options: [
      'Non, un mort ne peut consentir : une autre infraction est prévue',
      'Oui, toujours',
      'Oui, si pénétration',
    ],
    answer: 'Non, un mort ne peut consentir : une autre infraction est prévue',
    explanation:
        'Le cours : pas de viol sur cadavre ; l’atteinte à l’intégrité du cadavre est prévue par l’art. 225-17.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Contrainte morale (autorité)',
    question: 'La contrainte morale peut résulter notamment :',
    options: [
      'D’une autorité de fait ou de droit exercée sur la victime',
      'D’un simple silence de la victime',
      'D’un désaccord amoureux',
    ],
    answer: 'D’une autorité de fait ou de droit exercée sur la victime',
    explanation:
        'Le cours évoque l’autorité et la capacité de résistance appréciée concrètement.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Aggravation (mineur de 15 ans)',
    question:
        'Le viol est aggravé au 1er degré notamment lorsqu’il est commis :',
    options: [
      'Sur un mineur de quinze ans',
      'Sur un majeur de 18 ans',
      'Sans témoin',
    ],
    answer: 'Sur un mineur de quinze ans',
    explanation:
        'Le cours : art. 222-24 vise le viol commis sur un mineur de 15 ans.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Aggravation (vulnérabilité liée à l’âge)',
    question:
        'La seule circonstance que la victime ait 70 ans suffit à retenir la vulnérabilité aggravante :',
    options: [
      'Non, il faut établir une corrélation avec une particulière vulnérabilité',
      'Oui, toujours',
      'Oui, si la victime est isolée',
    ],
    answer:
        'Non, il faut établir une corrélation avec une particulière vulnérabilité',
    explanation:
        'Le cours cite une jurisprudence : l’âge seul ne suffit pas, il faut une vulnérabilité particulière démontrée.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Aggravation (précarité)',
    question:
        'Le viol est aggravé lorsqu’il est commis sur une personne dont la vulnérabilité résulte :',
    options: [
      'De la précarité économique et sociale (apparente ou connue)',
      'Uniquement d’une maladie',
      'Uniquement du fait d’être mineur',
    ],
    answer: 'De la précarité économique et sociale (apparente ou connue)',
    explanation:
        'Le cours mentionne la vulnérabilité/dépendance liée à la précarité comme circonstance aggravante.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Aggravation (arme)',
    question: 'Le viol est aggravé lorsqu’il est commis :',
    options: [
      'Avec usage ou menace d’une arme',
      'Dans un lieu public',
      'Par SMS',
    ],
    answer: 'Avec usage ou menace d’une arme',
    explanation:
        'Le cours liste l’usage ou la menace d’une arme parmi les aggravations.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Aggravation (réseau public)',
    question:
        'Le viol est aggravé lorsque la victime a été mise en contact avec l’auteur grâce :',
    options: [
      'À un réseau de communication électronique diffusant à un public non déterminé',
      'À une discussion privée entre amis',
      'À un courrier administratif',
    ],
    answer:
        'À un réseau de communication électronique diffusant à un public non déterminé',
    explanation:
        'Le cours : aggravation si mise en contact via diffusion de messages à destination d’un public non déterminé.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Aggravation (viol en série)',
    question: 'Le viol est aggravé lorsqu’il est commis en concours avec :',
    options: [
      'Un ou plusieurs autres viols commis sur d’autres victimes',
      'Un vol simple',
      'Une contravention',
    ],
    answer: 'Un ou plusieurs autres viols commis sur d’autres victimes',
    explanation:
        'Le cours évoque l’aggravation visant notamment les “violeurs en série”.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Aggravation (conjoint/concubin/PACS)',
    question: 'Le viol est aggravé lorsqu’il est commis par :',
    options: [
      'Le conjoint, concubin ou partenaire PACS de la victime',
      'Un collègue sans lien',
      'Un témoin',
    ],
    answer: 'Le conjoint, concubin ou partenaire PACS de la victime',
    explanation: 'Le cours liste cette circonstance aggravante au 1er degré.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Complicité',
    question: 'La complicité de viol est :',
    options: [
      'Punissable et constitue même une circonstance aggravante (pluralité)',
      'Impossible car le viol est un crime',
      'Punissable seulement si l’auteur avoue',
    ],
    answer:
        'Punissable et constitue même une circonstance aggravante (pluralité)',
    explanation:
        'Le cours : complicité possible (121-6/121-7) et pluralité peut aggraver selon les cas.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Viol — Preuve de bonne foi',
    question:
        'Lorsque l’auteur prétend avoir cru au consentement, la jurisprudence récente tend à :',
    options: [
      'Mettre à sa charge la preuve de sa bonne foi',
      'Mettre à la charge de la victime la preuve du refus',
      'Exclure toute poursuite',
    ],
    answer: 'Mettre à sa charge la preuve de sa bonne foi',
    explanation:
        'Le cours indique une tendance protectrice des victimes et une charge accrue sur la bonne foi alléguée.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 🟣 VIOL INCESTUEUX — SUITE (liste / autorité / nuances)
  // =========================================================
  const QuizQuestion(
    category: 'Viol incestueux — Liens (exemples)',
    question:
        'Parmi ces personnes, laquelle peut entrer dans la liste 222-22-3 ?',
    options: ['Grand-oncle / grand-tante', 'Cousin issu de germain', 'Voisin'],
    answer: 'Grand-oncle / grand-tante',
    explanation:
        'Le cours cite grand-oncles et grand-tantes dans la liste des liens de parenté visés.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Viol incestueux — Liens (neveux/nièces)',
    question:
        'Les neveux/nièces de la victime sont visés par la liste 222-22-3 :',
    options: ['Oui', 'Non', 'Uniquement si la victime a moins de 15 ans'],
    answer: 'Oui',
    explanation:
        'Le cours inclut neveux et nièces dans la liste exhaustive des liens visés.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Viol incestueux — Autorité de droit',
    question:
        'Une autorité “de droit” sur la victime correspond typiquement à :',
    options: [
      'L’autorité parentale (parents)',
      'Une simple influence affective',
      'Un lien d’amitié',
    ],
    answer: 'L’autorité parentale (parents)',
    explanation:
        'Le cours distingue autorité de droit (parents) et autorité de fait.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Viol incestueux — Autorité de fait',
    question: 'Une autorité “de fait” peut être :',
    options: [
      'Permanente ou discontinue, établie par des circonstances',
      'Impossible à prouver',
      'Automatique dès qu’il y a parenté',
    ],
    answer: 'Permanente ou discontinue, établie par des circonstances',
    explanation:
        'Le cours : autorité de fait caractérisée par des circonstances particulières.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Inceste — Consentement du mineur',
    question:
        'En matière incestueuse sur mineur, la violence/contrainte/menace/surprise :',
    options: [
      'N’ont pas à être démontrées pour caractériser l’infraction autonome',
      'Doivent toujours être prouvées',
      'Sont remplacées par une ITT',
    ],
    answer:
        'N’ont pas à être démontrées pour caractériser l’infraction autonome',
    explanation:
        'Le cours : le mineur ne peut consentir dans ce contexte de lien et d’autorité.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Inceste — Victime majeure (cas)',
    question: 'Si la victime est majeure, on retient en principe :',
    options: [
      'Le viol (222-23) si violence/contrainte/menace/surprise, avec possible surqualification incestueuse',
      'Toujours le viol incestueux autonome',
      'Jamais le viol',
    ],
    answer:
        'Le viol (222-23) si violence/contrainte/menace/surprise, avec possible surqualification incestueuse',
    explanation:
        'Le cours : pour victime majeure, on retient 222-23 ; la surqualification incestueuse peut s’appliquer sans conséquence juridique réelle.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 🟣 AGRESSION SEXUELLE INCESTUEUSE (222-29-3) — SUITE
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle incestueuse — Article',
    question: 'L’agression sexuelle incestueuse est définie par :',
    options: [
      'L’article 222-29-3 du Code pénal',
      'L’article 222-29-2 du Code pénal',
      'L’article 222-33 du Code pénal',
    ],
    answer: 'L’article 222-29-3 du Code pénal',
    explanation:
        'Le cours : 222-29-3 définit l’agression sexuelle incestueuse.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle incestueuse — Peines',
    question:
        'Les peines principales prévues pour l’agression sexuelle incestueuse sont :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation:
        'Le tableau du cours prévoit 10 ans et 150 000 € pour 222-29-3.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle incestueuse — Tentative',
    question: 'La tentative d’agression sexuelle incestueuse est :',
    options: [
      'Oui, spécialement prévue (222-31)',
      'Non, jamais punissable',
      'Oui seulement si la victime est majeure',
    ],
    answer: 'Oui, spécialement prévue (222-31)',
    explanation:
        'Le cours : la tentative est prévue ; mais le commencement d’exécution est souvent déjà une agression consommée.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle incestueuse — Contact',
    question: 'L’atteinte sexuelle (agression sexuelle) se définit comme :',
    options: [
      'Un acte impudique avec contact physique, sans pénétration ni bucco-génital',
      'Une pénétration',
      'Un propos sexiste',
    ],
    answer:
        'Un acte impudique avec contact physique, sans pénétration ni bucco-génital',
    explanation:
        'Le cours : l’agression sexuelle suppose un contact physique sans pénétration.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 🔵 HARCÈLEMENT SEXUEL — SUITE (aggravations / peines / pièges)
  // =========================================================
  const QuizQuestion(
    category: 'Harcèlement sexuel — Article',
    question: 'Le harcèlement sexuel est prévu par :',
    options: [
      'L’article 222-33 du Code pénal',
      'L’article 222-29-2 du Code pénal',
      'L’article 222-23 du Code pénal',
    ],
    answer: 'L’article 222-33 du Code pénal',
    explanation:
        'Le cours : les I et II de l’article 222-33 donnent la définition du harcèlement sexuel.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Deux formes',
    question: 'Le cours distingue :',
    options: [
      'Une forme répétée et une forme assimilée par acte unique (pression grave)',
      'Uniquement une forme par pénétration',
      'Uniquement une forme par contact physique',
    ],
    answer:
        'Une forme répétée et une forme assimilée par acte unique (pression grave)',
    explanation:
        'Le cours : double définition selon répétition ou pression grave unique.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Effet sur la victime',
    question: 'La forme répétée peut être constituée si les faits :',
    options: [
      'Portent atteinte à la dignité (dégradant/humiliant) ou créent un climat intimidant/hostile/offensant',
      'Créent seulement une gêne légère',
      'Sont nécessairement publics',
    ],
    answer:
        'Portent atteinte à la dignité (dégradant/humiliant) ou créent un climat intimidant/hostile/offensant',
    explanation:
        'Le cours reprend les deux branches : atteinte à la dignité ou situation intimidante/hostile/offensante.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Pluralité de victimes',
    question:
        'Des propos tenus devant un groupe peuvent constituer un harcèlement envers plusieurs victimes :',
    options: [
      'Oui, si imposés à chacune d’elles',
      'Non, jamais',
      'Uniquement si chaque victime répond',
    ],
    answer: 'Oui, si imposés à chacune d’elles',
    explanation:
        'Le cours : possibilité de retenir plusieurs victimes lorsque les agissements sont imposés à chacune.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Aggravation (mineur <15)',
    question: 'Le harcèlement sexuel est aggravé lorsqu’il est commis :',
    options: [
      'Sur un mineur de 15 ans',
      'Sur un majeur',
      'Entre époux uniquement',
    ],
    answer: 'Sur un mineur de 15 ans',
    explanation:
        'Le cours liste “sur un mineur de 15 ans” parmi les circonstances aggravantes.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Aggravation (vulnérabilité)',
    question:
        'Le harcèlement sexuel est aggravé lorsqu’il est commis sur une personne vulnérable :',
    options: [
      'En raison de l’âge, maladie, infirmité, déficience ou grossesse (apparente ou connue)',
      'Uniquement si la victime est mineure',
      'Uniquement si la victime est salariée',
    ],
    answer:
        'En raison de l’âge, maladie, infirmité, déficience ou grossesse (apparente ou connue)',
    explanation:
        'Le cours reprend les critères de vulnérabilité apparente ou connue de l’auteur.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Aggravation (précarité)',
    question: 'Le harcèlement sexuel est aggravé si la vulnérabilité résulte :',
    options: [
      'De la précarité économique ou sociale (apparente ou connue)',
      'D’un simple désaccord',
      'D’une réussite scolaire',
    ],
    answer: 'De la précarité économique ou sociale (apparente ou connue)',
    explanation:
        'Le cours liste la précarité économique/sociale comme aggravation.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Aggravation (plusieurs auteurs)',
    question: 'Le harcèlement sexuel est aggravé lorsqu’il est commis :',
    options: [
      'Par plusieurs personnes agissant comme auteur ou complice',
      'Par une seule personne',
      'Uniquement sur internet',
    ],
    answer: 'Par plusieurs personnes agissant comme auteur ou complice',
    explanation:
        'Le cours : pluralité d’auteurs/complices = circonstance aggravante.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Aggravation (mineur présent)',
    question: 'Le harcèlement sexuel est aggravé lorsque :',
    options: [
      'Un mineur était présent et y a assisté',
      'Les faits ont lieu de nuit',
      'La victime est un homme',
    ],
    answer: 'Un mineur était présent et y a assisté',
    explanation: 'Le cours liste cette circonstance aggravante.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Peines (simple)',
    question: 'Le harcèlement sexuel simple est puni de :',
    options: [
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 30 000 € d’amende',
    explanation:
        'Le cours : peines principales du harcèlement sexuel simple = 2 ans et 30 000 €.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Peines (aggravé)',
    question: 'Le harcèlement sexuel aggravé est puni de :',
    options: [
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '3 ans d’emprisonnement et 45 000 € d’amende',
    explanation: 'Le cours : harcèlement aggravé = 3 ans et 45 000 €.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Tentative',
    question: 'La tentative de harcèlement sexuel est :',
    options: ['Non', 'Oui', 'Oui uniquement si la victime est mineure'],
    answer: 'Non',
    explanation:
        'Le cours indique : tentative non prévue pour le harcèlement sexuel.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Harcèlement sexuel — Complicité',
    question: 'La complicité de harcèlement sexuel est :',
    options: [
      'Oui (121-6 et 121-7)',
      'Non',
      'Oui uniquement si l’auteur est supérieur hiérarchique',
    ],
    answer: 'Oui (121-6 et 121-7)',
    explanation: 'Le cours : complicité punissable selon les règles générales.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // ✅ MAJEUR / MINEUR <15 — PREUVES D’ÂGE (pièges)
  // =========================================================
  const QuizQuestion(
    category: 'Mineur <15 — Preuve de l’âge',
    question: 'L’âge de la victime s’apprécie :',
    options: [
      'Au moment des faits',
      'Au moment du dépôt de plainte',
      'Au moment du jugement',
    ],
    answer: 'Au moment des faits',
    explanation:
        'Le cours : c’est l’âge au moment des faits qui est pris en compte.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Mineur <15 — Calcul de l’âge',
    question: 'Selon le cours, l’âge se calcule :',
    options: ['D’heure à heure', 'Par année civile', 'Par trimestre'],
    answer: 'D’heure à heure',
    explanation:
        'Le cours cite la jurisprudence : l’âge se calcule d’heure à heure.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Mineur <15 — Connaissance de l’âge',
    question:
        'En principe, le texte précise que la minorité de 15 ans doit être apparente ou connue de l’auteur :',
    options: [
      'Non, le texte ne l’exige pas',
      'Oui, c’est une condition',
      'Oui, seulement si la victime est une fille',
    ],
    answer: 'Non, le texte ne l’exige pas',
    explanation:
        'Le cours : la loi n’exige pas que la minorité soit apparente ou connue pour la protection du mineur de 15 ans.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Mineur <15 — Erreur sur l’âge',
    question: 'L’erreur sur l’âge de la victime :',
    options: [
      'N’atténue pas la responsabilité, sauf hypothèses très encadrées',
      'Exonère toujours l’auteur',
      'Supprime la qualification pénale',
    ],
    answer: 'N’atténue pas la responsabilité, sauf hypothèses très encadrées',
    explanation:
        'Le cours : erreur sur l’âge n’atténue pas ; certaines hypothèses exigent la preuve d’avoir été trompé.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ✅ AGRESSIONS SEXUELLES AUTRES QUE LE VIOL (222-22 / 222-27)
  // =========================================================
  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Article',
    question:
        'Les agressions sexuelles commises avec violence, contrainte, menace ou surprise sont définies par :',
    options: [
      'L’article 222-22 du Code pénal',
      'L’article 222-27 du Code pénal',
      'L’article 222-32 du Code pénal',
    ],
    answer: 'L’article 222-22 du Code pénal',
    explanation:
        'Le cours : l’art. 222-22 définit les agressions sexuelles commises avec violence, contrainte, menace ou surprise.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Répression',
    question:
        'Les agressions sexuelles autres que le viol sont prévues et réprimées par :',
    options: [
      'L’article 222-27 du Code pénal',
      'L’article 222-23 du Code pénal',
      'L’article 222-29-1 du Code pénal',
    ],
    answer: 'L’article 222-27 du Code pénal',
    explanation:
        'Le cours : 222-27 prévoit et réprime les agressions sexuelles autres que le viol.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Définition',
    question: 'Une agression sexuelle “autre que le viol” suppose :',
    options: [
      'Un contact physique sans pénétration ni acte bucco-génital',
      'Une pénétration sexuelle',
      'Uniquement des propos à connotation sexuelle',
    ],
    answer: 'Un contact physique sans pénétration ni acte bucco-génital',
    explanation:
        'Le cours : acte de nature sexuelle autre qu’une pénétration ou un acte bucco-génital ; contact physique requis.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Distinction',
    question:
        'La différence principale avec le viol est que l’agression sexuelle :',
    options: [
      'N’implique pas de pénétration ni d’acte bucco-génital',
      'Exige toujours une ITT > 8 jours',
      'Ne nécessite jamais l’absence de consentement',
    ],
    answer: 'N’implique pas de pénétration ni d’acte bucco-génital',
    explanation:
        'Le cours : le viol est caractérisé par la pénétration ou l’acte bucco-génital ; l’agression sexuelle par d’autres actes.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Exemples',
    question:
        'Le plus grand nombre d’agressions sexuelles (autres que le viol) correspond à :',
    options: [
      'Attouchements/caresses (sexe, fesses, cuisses, poitrine) éventuellement accompagnés de baisers',
      'Uniquement des messages écrits',
      'Uniquement des menaces à distance sans contact',
    ],
    answer:
        'Attouchements/caresses (sexe, fesses, cuisses, poitrine) éventuellement accompagnés de baisers',
    explanation: 'Le cours mentionne ces gestes comme cas les plus fréquents.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Jurisprudence',
    question:
        'Selon la jurisprudence citée, peut constituer une agression sexuelle :',
    options: [
      'Caresser le dos de la victime en passant la main sous son pull-over',
      'Regarder la victime dans la rue',
      'Parler de sexualité au téléphone',
    ],
    answer:
        'Caresser le dos de la victime en passant la main sous son pull-over',
    explanation: 'Le cours cite l’arrêt CA Agen, 27 octobre 1997.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Auteur/Victime',
    question: 'L’agression sexuelle peut être :',
    options: [
      'Commise par l’auteur sur la victime, ou réalisée par la victime contrainte sur l’auteur',
      'Uniquement commise par l’auteur sur la victime',
      'Uniquement commise par un tiers témoin',
    ],
    answer:
        'Commise par l’auteur sur la victime, ou réalisée par la victime contrainte sur l’auteur',
    explanation:
        'Le cours précise que l’acte peut aussi être effectué par la victime contrainte sur l’auteur.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Cadavre',
    question: 'Une agression sexuelle peut-elle être retenue sur un cadavre ?',
    options: [
      'Non, car l’infraction implique l’absence de consentement et un mort ne peut consentir',
      'Oui, toujours',
      'Oui, si le lieu est public',
    ],
    answer:
        'Non, car l’infraction implique l’absence de consentement et un mort ne peut consentir',
    explanation:
        'Le cours : pas d’agression sexuelle sur cadavre ; l’atteinte à l’intégrité du cadavre est autonome (225-17).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category:
        'Agressions sexuelles autres que le viol — Condition de la victime',
    question:
        'Le fait que la victime soit prostituée ou ait déjà eu des relations consenties avec l’auteur :',
    options: [
      'N’écarte pas l’agression sexuelle si les actes sont imposés',
      'Supprime l’infraction',
      'Transforme l’infraction en contravention',
    ],
    answer: 'N’écarte pas l’agression sexuelle si les actes sont imposés',
    explanation: 'Le cours : indifférence de la condition de la victime.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Mariage',
    question:
        'Les faits peuvent être constitués même si l’auteur et la victime :',
    options: [
      'Sont unis par les liens du mariage',
      'Sont uniquement fiancés',
      'Ont une relation de voisinage',
    ],
    answer: 'Sont unis par les liens du mariage',
    explanation:
        'Le cours : 222-22 précise que les faits existent quelle que soit la nature des relations, y compris mariage.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Consentement',
    question:
        'Comme le viol, l’agression sexuelle “autre que le viol” suppose :',
    options: [
      'Violence, contrainte, menace ou surprise',
      'Uniquement la répétition',
      'Uniquement un écrit obscène',
    ],
    answer: 'Violence, contrainte, menace ou surprise',
    explanation: 'Le cours : absence de consentement caractérisée par V/C/M/S.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Violence',
    question: 'La violence, au sens du cours, correspond à :',
    options: [
      'Une violence physique suffisante pour accomplir l’acte malgré le refus',
      'Une simple gêne psychologique',
      'Un acte uniquement verbal',
    ],
    answer:
        'Une violence physique suffisante pour accomplir l’acte malgré le refus',
    explanation:
        'Le cours : pressions physiques suffisantes pour réaliser l’agression malgré le refus.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Appréciation',
    question:
        'Le caractère contraignant de la violence employée est apprécié :',
    options: [
      'Souverainement par les juges',
      'Uniquement par la victime',
      'Uniquement par un médecin',
    ],
    answer: 'Souverainement par les juges',
    explanation:
        'Le cours : appréciation laissée au pouvoir souverain des juges.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category:
        'Agressions sexuelles autres que le viol — Jurisprudence (violence)',
    question:
        'Selon la jurisprudence citée, la violence peut être caractérisée si l’auteur :',
    options: [
      'Pince les fesses et force la victime à entrer dans son véhicule en la poussant',
      'Fait un compliment',
      'Envoie un emoji',
    ],
    answer:
        'Pince les fesses et force la victime à entrer dans son véhicule en la poussant',
    explanation: 'Le cours cite Cass. crim., 15 avril 1992.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Contrainte/Menace',
    question:
        'La contrainte ou la menace sont assimilées par la jurisprudence à :',
    options: [
      'Des violences morales équivalentes à des violences physiques',
      'Une simple maladresse',
      'Un trouble de voisinage',
    ],
    answer: 'Des violences morales équivalentes à des violences physiques',
    explanation:
        'Le cours : contrainte/menace = violences morales équivalentes.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Contrainte (222-22-1)',
    question: 'L’article 222-22-1 précise que la contrainte peut être :',
    options: ['Physique ou morale', 'Uniquement physique', 'Uniquement morale'],
    answer: 'Physique ou morale',
    explanation: 'Le cours cite 222-22-1 : contrainte physique ou morale.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Menace (critère)',
    question: 'Pour être retenue, la menace/contrainte doit inspirer :',
    options: [
      'Une crainte sérieuse et immédiate',
      'Une inquiétude vague',
      'Une simple gêne',
    ],
    answer: 'Une crainte sérieuse et immédiate',
    explanation:
        'Le cours : crainte sérieuse et immédiate, appréciation concrète selon capacité de résistance.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Surprise (sens)',
    question: 'La surprise s’entend comme :',
    options: [
      'Surprendre le consentement de la victime',
      'La surprise exprimée par la victime après les faits',
      'Une réaction de colère',
    ],
    answer: 'Surprendre le consentement de la victime',
    explanation:
        'Le cours : surprise = surprendre le consentement, pas l’émotion de la victime.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Surprise (prétexte)',
    question: 'La surprise peut être caractérisée lorsque l’auteur utilise :',
    options: [
      'Un prétexte fallacieux (ex: visite médicale) pour commettre l’acte',
      'Un message respectueux',
      'Un contrat de travail',
    ],
    answer:
        'Un prétexte fallacieux (ex: visite médicale) pour commettre l’acte',
    explanation: 'Le cours cite Cass. crim., 20 juin 2001.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Surprise (sommeil)',
    question:
        'La surprise peut être retenue si l’auteur procède à des attouchements :',
    options: [
      'Alors que la victime est endormie',
      'Après un dîner',
      'Dans un taxi',
    ],
    answer: 'Alors que la victime est endormie',
    explanation: 'Le cours cite Cass. crim., 11 septembre 2024, n°23-86.657.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Mineur (15-18)',
    question:
        'Pour les agressions sexuelles 222-27, l’article 222-22-1 (différence d’âge/autorité) concerne :',
    options: [
      'Les mineurs de 15 à 18 ans',
      'Uniquement les mineurs de moins de 15 ans',
      'Uniquement les majeurs',
    ],
    answer: 'Les mineurs de 15 à 18 ans',
    explanation:
        'Le cours : cette disposition ne concerne, pour 222-27, que les mineurs de 15 à 18 ans.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Élément moral',
    question: 'L’élément moral exige :',
    options: [
      'La conscience de commettre un acte immoral ou obscène contre le gré de la victime',
      'Un mobile de vengeance obligatoire',
      'Un résultat médical',
    ],
    answer:
        'La conscience de commettre un acte immoral ou obscène contre le gré de la victime',
    explanation:
        'Le cours : intention coupable, conscience d’agir contre le gré.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agressions sexuelles autres que le viol — Mobile',
    question: 'Le mobile de l’auteur (haine, vengeance, lubricité…) :',
    options: [
      'Importe peu pour caractériser l’infraction',
      'Doit être prouvé pour condamner',
      'Efface l’élément moral',
    ],
    answer: 'Importe peu pour caractériser l’infraction',
    explanation: 'Le cours : le mobile importe peu.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // ✅ AGRESSIONS SEXUELLES — CIRCONSTANCES AGGRAVANTES (222-28)
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle (222-27) — Aggravation',
    question:
        'Les circonstances aggravantes des agressions sexuelles (autres que le viol) sont prévues par :',
    options: [
      'L’article 222-28 du Code pénal',
      'L’article 222-24 du Code pénal',
      'L’article 222-30 du Code pénal',
    ],
    answer: 'L’article 222-28 du Code pénal',
    explanation: 'Le cours : aggravations des 222-27 relèvent de 222-28.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (222-27) — Aggravation ITT',
    question:
        'Une agression sexuelle est aggravée notamment lorsqu’elle a entraîné :',
    options: [
      'Une blessure, une lésion ou une ITT > 8 jours',
      'Une simple peur',
      'Une perte de salaire',
    ],
    answer: 'Une blessure, une lésion ou une ITT > 8 jours',
    explanation:
        'Le cours : 222-28 vise blessure/lésion/ITT supérieure à huit jours.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (222-27) — Concours réel',
    question:
        'Si l’agression sexuelle s’accompagne de tortures/barbarie ou entraîne la mort :',
    options: [
      'Il peut y avoir concours réel entre agression sexuelle simple et violences/tortures/mort',
      'On retient uniquement l’agression sexuelle aggravée',
      'On requalifie automatiquement en viol',
    ],
    answer:
        'Il peut y avoir concours réel entre agression sexuelle simple et violences/tortures/mort',
    explanation:
        'Le cours : dans ces cas graves, il y a simple concours réel d’infractions.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (222-27) — Aggravation autorité',
    question: 'Une agression sexuelle est aggravée lorsqu’elle est commise :',
    options: [
      'Par un ascendant ou toute personne ayant autorité de droit ou de fait',
      'Par un inconnu sans lien',
      'Dans un lieu privé',
    ],
    answer:
        'Par un ascendant ou toute personne ayant autorité de droit ou de fait',
    explanation:
        'Le cours : autorité de droit ou de fait = circonstance aggravante (222-28).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (222-27) — Aggravation abus de fonctions',
    question: 'Le fait d’abuser de l’autorité que confèrent ses fonctions :',
    options: [
      'Aggrave l’agression sexuelle',
      'Supprime l’infraction',
      'Ne vaut que pour le viol',
    ],
    answer: 'Aggrave l’agression sexuelle',
    explanation: 'Le cours : abus d’autorité fonctionnelle = aggravation.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (222-27) — Aggravation pluralité',
    question: 'L’agression sexuelle est aggravée lorsqu’elle est commise :',
    options: [
      'Par plusieurs personnes agissant en qualité d’auteur ou de complice',
      'Uniquement par un auteur unique',
      'Uniquement sur internet',
    ],
    answer:
        'Par plusieurs personnes agissant en qualité d’auteur ou de complice',
    explanation: 'Le cours : pluralité auteurs/complices = aggravation.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (222-27) — Aggravation arme',
    question: 'L’agression sexuelle est aggravée lorsqu’elle est commise :',
    options: [
      'Avec usage ou menace d’une arme',
      'Avec un simple regard',
      'Avec un cadeau',
    ],
    answer: 'Avec usage ou menace d’une arme',
    explanation: 'Le cours : usage/menace d’arme figure dans 222-28.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (222-27) — Aggravation réseau public',
    question:
        'L’agression sexuelle est aggravée lorsque la victime a été mise en contact grâce :',
    options: [
      'À un réseau de communication électronique diffusant à un public non déterminé',
      'À un message privé familial',
      'À un appel aux secours',
    ],
    answer:
        'À un réseau de communication électronique diffusant à un public non déterminé',
    explanation:
        'Le cours : mise en contact via diffusion à un public non déterminé = aggravation.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (222-27) — Aggravation conjoint',
    question: 'L’agression sexuelle est aggravée lorsqu’elle est commise par :',
    options: [
      'Le conjoint, concubin ou partenaire PACS de la victime',
      'Un collègue',
      'Un témoin',
    ],
    answer: 'Le conjoint, concubin ou partenaire PACS de la victime',
    explanation: 'Le cours liste cette aggravation (222-28).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (222-27) — Aggravation ivresse',
    question: 'L’agression sexuelle est aggravée lorsqu’elle est commise :',
    options: [
      'Par une personne en état d’ivresse manifeste ou sous emprise manifeste de stupéfiants',
      'Par une personne fatiguée',
      'Par une personne stressée',
    ],
    answer:
        'Par une personne en état d’ivresse manifeste ou sous emprise manifeste de stupéfiants',
    explanation: 'Le cours : ivresse manifeste / stupéfiants = aggravation.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (222-27) — Aggravation prostitution',
    question: 'L’agression sexuelle est aggravée lorsqu’elle est commise :',
    options: [
      'Dans l’exercice de l’activité, sur une personne se livrant à la prostitution (même occasionnelle)',
      'Sur une personne mariée',
      'Sur une personne majeure',
    ],
    answer:
        'Dans l’exercice de l’activité, sur une personne se livrant à la prostitution (même occasionnelle)',
    explanation:
        'Le cours : aggravation spécifique liée à la prostitution, y compris occasionnelle.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (222-27) — Aggravation mineur témoin',
    question: 'L’agression sexuelle est aggravée lorsque :',
    options: [
      'Un mineur était présent au moment des faits et y a assisté',
      'Un adulte était présent',
      'La victime crie',
    ],
    answer: 'Un mineur était présent au moment des faits et y a assisté',
    explanation: 'Le cours : présence d’un mineur témoin = aggravation.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (222-27) — Aggravation substance',
    question: 'L’agression sexuelle est aggravée lorsque :',
    options: [
      'Une substance est administrée à l’insu de la victime pour altérer son discernement',
      'La victime a bu volontairement',
      'La victime est en colère',
    ],
    answer:
        'Une substance est administrée à l’insu de la victime pour altérer son discernement',
    explanation:
        'Le cours : substance à l’insu altérant discernement/contrôle = aggravation.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (222-27) — Peines (simple)',
    question: 'L’agression sexuelle simple (222-27) est punie de :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Le tableau du cours : 222-27 = 5 ans et 75 000 €.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (222-27) — Peines (aggravée)',
    question: 'L’agression sexuelle aggravée (222-28) est punie de :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Le tableau du cours : 222-28 = 7 ans et 100 000 €.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Tentative',
    question: 'La tentative d’agression sexuelle est :',
    options: [
      'Oui, spécialement prévue par l’article 222-31',
      'Non, jamais punissable',
      'Oui seulement si l’auteur avoue',
    ],
    answer: 'Oui, spécialement prévue par l’article 222-31',
    explanation:
        'Le cours : tentative prévue ; mais le commencement d’exécution est souvent déjà une agression consommée.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Complicité',
    question: 'La complicité d’agression sexuelle est :',
    options: [
      'Punissable (121-6 et 121-7) et peut constituer une circonstance aggravante',
      'Impossible',
      'Punissable uniquement si l’auteur est mineur',
    ],
    answer:
        'Punissable (121-6 et 121-7) et peut constituer une circonstance aggravante',
    explanation:
        'Le cours : complicité punissable et aggravation prévue (pluralité).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Provocation (infraction distincte)',
    question:
        'L’“instigateur” d’une agression sexuelle (offres/promesses pour la faire commettre) est puni par :',
    options: [
      'L’article 222-30-2 du Code pénal',
      'L’article 222-31 du Code pénal',
      'L’article 227-23 du Code pénal',
    ],
    answer: 'L’article 222-30-2 du Code pénal',
    explanation:
        'Le cours : 222-30-2 incrimine la provocation à commettre une agression sexuelle (infraction distincte).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Provocation (condition)',
    question:
        'La provocation à commettre une agression sexuelle est punissable :',
    options: [
      'Même si l’infraction n’a été ni commise ni tentée',
      'Seulement si l’agression a été commise',
      'Seulement si l’auteur est complice',
    ],
    answer: 'Même si l’infraction n’a été ni commise ni tentée',
    explanation:
        'Le cours : l’instigateur est poursuivi même si le comportement n’est pas suivi d’effet.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Provocation (peines)',
    question:
        'La provocation à commettre une agression sexuelle (222-30-2) est punie de :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Le cours : 222-30-2 = 5 ans et 75 000 €.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Provocation (mineur)',
    question:
        'Si l’agression sexuelle devait être commise sur un mineur, la provocation est punie de :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation:
        'Le cours : aggravation des peines de provocation si la cible est mineure.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Provocation suivie d’effet',
    question:
        'Si la provocation est suivie d’une agression sexuelle ou d’une tentative :',
    options: [
      'Les règles de la complicité s’appliquent et l’instigateur encourt les mêmes peines que l’auteur',
      'La provocation disparaît',
      'On retient uniquement une contravention',
    ],
    answer:
        'Les règles de la complicité s’appliquent et l’instigateur encourt les mêmes peines que l’auteur',
    explanation:
        'Le cours : si suivi d’effet, bascule sur complicité et mêmes peines.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ✅ AGRESSIONS SEXUELLES IMPOSÉES À UN MINEUR DE 15 ANS (222-29-1)
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle sur mineur <15 (V/C/M/S) — Article',
    question:
        'Les agressions sexuelles autres que le viol imposées à un mineur de 15 ans (V/C/M/S) sont réprimées par :',
    options: [
      'L’article 222-29-1 du Code pénal',
      'L’article 222-29-2 du Code pénal',
      'L’article 222-28 du Code pénal',
    ],
    answer: 'L’article 222-29-1 du Code pénal',
    explanation:
        'Le cours : 222-29-1 réprime les agressions sexuelles autres que le viol imposées à un mineur de 15 ans par V/C/M/S.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur mineur <15 — Victime vivante',
    question: 'Pour 222-29-1, une agression sexuelle sur un cadavre :',
    options: [
      'Est impossible : pas d’agression sexuelle sur cadavre',
      'Est possible si l’acte est public',
      'Est possible si l’auteur est mineur',
    ],
    answer: 'Est impossible : pas d’agression sexuelle sur cadavre',
    explanation:
        'Le cours : pas d’agression sexuelle sur cadavre ; 225-17 vise l’intégrité du cadavre.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur mineur <15 — Âge',
    question: 'L’âge du mineur s’apprécie :',
    options: [
      'Au moment des faits (calcul d’heure à heure)',
      'Au moment du jugement',
      'Au moment de la plainte',
    ],
    answer: 'Au moment des faits (calcul d’heure à heure)',
    explanation: 'Le cours : âge au moment des faits ; calcul d’heure à heure.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur mineur <15 — Connaissance de l’âge',
    question:
        'Pour un mineur de 15 ans, le texte exige que la minorité soit apparente ou connue :',
    options: ['Non', 'Oui', 'Uniquement si la victime est très jeune'],
    answer: 'Non',
    explanation:
        'Le cours : le texte ne précise pas que la minorité doit être apparente ou connue.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur mineur <15 — Consentement',
    question: 'Pour 222-29-1, l’absence de consentement résulte de :',
    options: [
      'Violence, contrainte, menace ou surprise',
      'La seule minorité',
      'La présence d’un témoin',
    ],
    answer: 'Violence, contrainte, menace ou surprise',
    explanation:
        'Le cours : 222-29-1 vise les agressions imposées à un mineur de 15 ans par V/C/M/S.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur mineur <15 — Surprise et vulnérabilité',
    question:
        'Pour les mineurs de 15 ans, la contrainte morale ou la surprise peuvent être caractérisées par :',
    options: [
      'L’abus de vulnérabilité lié au manque de discernement',
      'Un simple retard scolaire',
      'Le fait d’être en vacances',
    ],
    answer: 'L’abus de vulnérabilité lié au manque de discernement',
    explanation:
        'Le cours : sur mineur de 15 ans, contrainte morale/surprise peuvent résulter de l’abus de vulnérabilité (222-22-1).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur mineur <15 — Peines',
    question: 'Les peines principales de 222-29-1 sont :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation: 'Le cours : 222-29-1 = 10 ans et 150 000 €.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur mineur <15 — Circonstances aggravantes',
    question: 'Les agressions sexuelles 222-29-1 comportent, selon le cours :',
    options: [
      'Aucune circonstance aggravante propre dans la fiche',
      'Les mêmes aggravations que 222-28',
      'Une aggravation automatique ITT > 8 jours',
    ],
    answer: 'Aucune circonstance aggravante propre dans la fiche',
    explanation:
        'Le cours indique “Aucune” en circonstances aggravantes pour 222-29-1 dans cette fiche.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur mineur <15 — Tentative',
    question:
        'La tentative d’agression sexuelle sur mineur de 15 ans (222-29-1) est :',
    options: ['Oui, prévue par 222-31', 'Non', 'Oui uniquement si ITT'],
    answer: 'Oui, prévue par 222-31',
    explanation: 'Le cours : tentative prévue par 222-31.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur mineur <15 — Complicité',
    question: 'La complicité (121-6/121-7) est :',
    options: ['Oui', 'Non', 'Seulement si l’auteur est majeur'],
    answer: 'Oui',
    explanation:
        'Le cours : complicité punissable conformément aux articles 121-6 et 121-7.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur mineur <15 — Erreur sur l’âge',
    question: 'L’erreur sur l’âge du mineur :',
    options: [
      'N’atténue pas la responsabilité ; l’auteur doit prouver qu’il a été trompé (hypothèses)',
      'Exonère automatiquement',
      'Supprime l’élément moral',
    ],
    answer:
        'N’atténue pas la responsabilité ; l’auteur doit prouver qu’il a été trompé (hypothèses)',
    explanation:
        'Le cours : erreur non atténuante ; exception très encadrée si comportement/développement d’un adulte et preuve d’avoir été trompé.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ✅ AGRESSIONS SEXUELLES IMPOSÉES À UNE PERSONNE VULNÉRABLE (222-29 / 222-30)
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle sur personne vulnérable — Article',
    question:
        'Les agressions sexuelles autres que le viol imposées à une personne vulnérable sont prévues par :',
    options: [
      'L’article 222-29 du Code pénal',
      'L’article 222-28 du Code pénal',
      'L’article 222-32 du Code pénal',
    ],
    answer: 'L’article 222-29 du Code pénal',
    explanation:
        'Le cours : 222-29 prévoit ces agressions sexuelles lorsqu’elles sont imposées à une personne vulnérable.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur personne vulnérable — Aggravations',
    question: 'Les circonstances aggravantes de 222-29 sont prévues par :',
    options: [
      'L’article 222-30 du Code pénal',
      'L’article 222-28 du Code pénal',
      'L’article 222-31 du Code pénal',
    ],
    answer: 'L’article 222-30 du Code pénal',
    explanation:
        'Le cours : aggravations des agressions sexuelles sur personne vulnérable = 222-30.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur personne vulnérable — Vulnérabilité',
    question: 'La vulnérabilité doit être :',
    options: [
      'Apparente ou connue de l’auteur',
      'Toujours médicalement constatée par expertise',
      'Forcément due à l’alcool volontaire',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation:
        'Le cours : la cause de vulnérabilité doit être visible ou révélée ; apparente ou connue.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur personne vulnérable — Causes',
    question: 'Les causes de vulnérabilité visées incluent :',
    options: [
      'Âge, maladie, infirmité, déficience physique/psychique, grossesse, précarité éco/sociale',
      'Uniquement la fatigue',
      'Uniquement la timidité',
    ],
    answer:
        'Âge, maladie, infirmité, déficience physique/psychique, grossesse, précarité éco/sociale',
    explanation: 'Le cours énumère ces causes limitativement.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur personne vulnérable — Préexistence',
    question: 'La vulnérabilité doit :',
    options: [
      'Préexister aux faits et ne pas être la conséquence des faits eux-mêmes',
      'Résulter obligatoirement des faits',
      'Être créée par l’auteur sur le moment',
    ],
    answer:
        'Préexister aux faits et ne pas être la conséquence des faits eux-mêmes',
    explanation:
        'Le cours : la vulnérabilité doit préexister aux faits (Cass. crim., 17 octobre 1984).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur personne vulnérable — Âge seul',
    question:
        'Le seul âge de la victime suffit à caractériser la vulnérabilité :',
    options: [
      'Non, il faut une vulnérabilité particulière démontrée',
      'Oui, toujours',
      'Oui, dès 60 ans',
    ],
    answer: 'Non, il faut une vulnérabilité particulière démontrée',
    explanation:
        'Le cours : l’âge ne suffit pas ; il faut prouver une vulnérabilité particulière.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur personne vulnérable — Précarité',
    question: 'La précarité économique ou sociale peut être comprise comme :',
    options: [
      'L’absence de sécurités (notamment emploi) entraînant dépendance et fragilité',
      'Un choix de vie',
      'Un simple conflit familial',
    ],
    answer:
        'L’absence de sécurités (notamment emploi) entraînant dépendance et fragilité',
    explanation:
        'Le cours donne une définition orientée sur l’absence de sécurités et la dépendance.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur personne vulnérable — Peines (simple)',
    question:
        'L’agression sexuelle sur personne vulnérable (222-29) est punie de :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Le tableau du cours : 222-29 = 7 ans et 100 000 €.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur personne vulnérable — Peines (aggravée)',
    question:
        'L’agression sexuelle sur personne vulnérable aggravée (222-30) est punie de :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation: 'Le tableau du cours : 222-30 = 10 ans et 150 000 €.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category:
        'Agression sexuelle sur personne vulnérable — Aggravation (lésion)',
    question:
        'Selon 222-30, l’agression sexuelle sur personne vulnérable est aggravée lorsqu’elle a entraîné :',
    options: [
      'Une blessure ou une lésion',
      'Une ITT > 8 jours uniquement',
      'Une simple gêne',
    ],
    answer: 'Une blessure ou une lésion',
    explanation: 'Le cours : 222-30 vise blessure ou lésion.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur personne vulnérable — Aggravation (arme)',
    question: 'Selon 222-30, est aggravée l’agression sexuelle commise :',
    options: [
      'Avec usage ou menace d’une arme',
      'Dans un lieu public',
      'Par SMS',
    ],
    answer: 'Avec usage ou menace d’une arme',
    explanation: 'Le cours : usage/menace d’arme est listé dans 222-30.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category:
        'Agression sexuelle sur personne vulnérable — Aggravation (ivresse)',
    question:
        'Selon 222-30, est aggravée l’agression sexuelle commise par une personne :',
    options: [
      'En état d’ivresse manifeste ou sous emprise manifeste de stupéfiants',
      'Fatiguée',
      'En retard',
    ],
    answer:
        'En état d’ivresse manifeste ou sous emprise manifeste de stupéfiants',
    explanation: 'Le cours : ivresse manifeste / stupéfiants = aggravation.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category:
        'Agression sexuelle sur personne vulnérable — Aggravation (substance)',
    question: 'Selon 222-30, est aggravée l’agression sexuelle lorsque :',
    options: [
      'Une substance est administrée à l’insu de la victime pour altérer discernement/contrôle',
      'La victime boit volontairement',
      'La victime rit',
    ],
    answer:
        'Une substance est administrée à l’insu de la victime pour altérer discernement/contrôle',
    explanation:
        'Le cours : substance à l’insu altérant discernement/contrôle = aggravation.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur personne vulnérable — Tentative',
    question: 'La tentative d’agression sexuelle sur personne vulnérable est :',
    options: ['Oui (222-31)', 'Non', 'Oui uniquement si arme'],
    answer: 'Oui (222-31)',
    explanation: 'Le cours : tentative prévue par 222-31.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle sur personne vulnérable — Complicité',
    question: 'La complicité est :',
    options: [
      'Oui, punissable et peut être une circonstance aggravante (222-30 4°)',
      'Non',
      'Oui uniquement si l’auteur est ascendant',
    ],
    answer:
        'Oui, punissable et peut être une circonstance aggravante (222-30 4°)',
    explanation:
        'Le cours : complicité punissable et aggravation prévue en cas de pluralité.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ✅ EXHIBITION SEXUELLE (222-32) — BANQUE ÉNORME
  // =========================================================
  const QuizQuestion(
    category: 'Exhibition sexuelle — Article',
    question: 'L’exhibition sexuelle est prévue et réprimée par :',
    options: [
      'L’article 222-32 du Code pénal',
      'L’article 222-27 du Code pénal',
      'L’article 227-22 du Code pénal',
    ],
    answer: 'L’article 222-32 du Code pénal',
    explanation: 'Le cours : 222-32 réprime l’exhibition sexuelle.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Contact',
    question: 'Dans l’exhibition sexuelle, il existe :',
    options: [
      'Aucun contact physique entre l’auteur et la victime',
      'Toujours une pénétration',
      'Toujours un attouchement',
    ],
    answer: 'Aucun contact physique entre l’auteur et la victime',
    explanation:
        'Le cours : pas de contact physique ; victimes = témoins involontaires.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Nature',
    question: 'L’exhibition sexuelle s’entend :',
    options: [
      'D’un acte (pas de simples paroles, écrits, photos)',
      'D’un message SMS',
      'D’un dessin obscène',
    ],
    answer: 'D’un acte (pas de simples paroles, écrits, photos)',
    explanation:
        'Le cours : c’est un acte, pas des paroles/écrits/dessins/photos.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Qualifications voisines',
    question:
        'Des paroles/écrits/affiches obscènes peuvent relever notamment :',
    options: [
      'D’autres qualifications (R.624-2, 227-23 et s.)',
      'Toujours de 222-32',
      'Uniquement d’un délit de vol',
    ],
    answer: 'D’autres qualifications (R.624-2, 227-23 et s.)',
    explanation:
        'Le cours : messages contraires à la décence (R.624-2) / diffusion pornographique (227-23…).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Évolution (loi 2021)',
    question:
        'Depuis la loi du 21 avril 2021, l’exhibition sexuelle peut être constituée :',
    options: [
      'Même sans partie du corps dénudée, si un acte sexuel explicite réel ou simulé est imposé',
      'Uniquement si le sexe est visible',
      'Uniquement si l’auteur parle',
    ],
    answer:
        'Même sans partie du corps dénudée, si un acte sexuel explicite réel ou simulé est imposé',
    explanation:
        'Le cours : l’acte sexuel explicite réel/simulé suffit même sans nudité visible.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Exemple (sous vêtements)',
    question: 'Selon le cours, peut entrer dans l’exhibition sexuelle :',
    options: [
      'Une masturbation pratiquée sous les vêtements (acte explicite imposé)',
      'Un message romantique',
      'Un compliment',
    ],
    answer:
        'Une masturbation pratiquée sous les vêtements (acte explicite imposé)',
    explanation:
        'Le cours : comportements obscènes comme la masturbation sous vêtements sont visés.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Ce qui est puni',
    question: 'Ce qui est puni, ce n’est pas l’acte sexuel en soi mais :',
    options: [
      'Le spectacle imposé à autrui (témoins involontaires)',
      'La relation licite/illicite',
      'L’orientation sexuelle',
    ],
    answer: 'Le spectacle imposé à autrui (témoins involontaires)',
    explanation: 'Le cours : c’est le spectacle pour autrui qui est réprimé.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Indifférence',
    question: 'Peu importe que les relations soient :',
    options: [
      'Licites ou non, homo/hétéro, partenaires majeurs et consentants',
      'Toujours illégales',
      'Uniquement hétérosexuelles',
    ],
    answer: 'Licites ou non, homo/hétéro, partenaires majeurs et consentants',
    explanation:
        'Le cours : l’infraction vise l’exposition au public, peu importe la nature licite ou le consentement des partenaires.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Jurisprudence (péage)',
    question:
        'Selon la jurisprudence citée, constitue une exhibition sexuelle :',
    options: [
      'Exhiber ses parties sexuelles à la vue d’employés au péage d’autoroute',
      'Écrire un poème',
      'Porter un maillot de bain',
    ],
    answer:
        'Exhiber ses parties sexuelles à la vue d’employés au péage d’autoroute',
    explanation: 'Le cours cite Cass. crim., 4 juin 1997.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Jurisprudence (berge)',
    question:
        'Selon la jurisprudence citée (24 nov. 2021), l’exhibition est caractérisée si l’auteur :',
    options: [
      'S’assoit nu en position rendant visible son sexe et refuse de se vêtir malgré sollicitations',
      'Se change rapidement à l’abri',
      'Porte un short',
    ],
    answer:
        'S’assoit nu en position rendant visible son sexe et refuse de se vêtir malgré sollicitations',
    explanation: 'Le cours cite Cass. crim., 24 novembre 2021.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Publicité',
    question: 'Pour être constituée, l’exhibition doit être imposée :',
    options: [
      'À la vue d’autrui dans un lieu accessible aux regards du public',
      'Uniquement dans un domicile privé fermé',
      'Uniquement sur internet',
    ],
    answer: 'À la vue d’autrui dans un lieu accessible aux regards du public',
    explanation:
        'Le cours : 222-32 exige un lieu accessible aux regards du public.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Lieu public',
    question: 'Dans un lieu public, la publicité de l’acte est :',
    options: [
      'Absolue (inhérente au lieu)',
      'Toujours relative',
      'Impossible à retenir',
    ],
    answer: 'Absolue (inhérente au lieu)',
    explanation:
        'Le cours : en lieu public, la publicité est inhérente aux lieux.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Vu ou non vu',
    question:
        'Dans un lieu public, l’exhibition peut être constituée même si :',
    options: [
      'Personne ne l’a effectivement vue, dès lors qu’elle pouvait être vue',
      'Il y a seulement un témoin mineur',
      'L’auteur s’excuse',
    ],
    answer:
        'Personne ne l’a effectivement vue, dès lors qu’elle pouvait être vue',
    explanation: 'Le cours : l’éventualité suffit (pouvait être vu).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Lieux concernés',
    question: 'Sont notamment considérés comme lieux publics :',
    options: [
      'Rue, place, jardin public, plage, et lieux admis sous conditions (école, hôpital, transports)',
      'Uniquement les rues',
      'Uniquement les domiciles',
    ],
    answer:
        'Rue, place, jardin public, plage, et lieux admis sous conditions (école, hôpital, transports)',
    explanation: 'Le cours liste ces exemples.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Lieu privé mais visible',
    question: 'L’exhibition peut être retenue dans un lieu privé si :',
    options: [
      'Elle est visible depuis un lieu public faute de précautions',
      'La victime est consentante',
      'L’auteur est chez lui donc jamais punissable',
    ],
    answer: 'Elle est visible depuis un lieu public faute de précautions',
    explanation:
        'Le cours : lieu privé accessible aux regards du public = possible.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Voyeurisme / naturisme',
    question: 'L’infraction n’est pas retenue si :',
    options: [
      'La “victime” a recherché l’exhibition (voyeurisme, naturisme, spectacles érotiques)',
      'Le lieu est public',
      'Il y a un enfant présent',
    ],
    answer:
        'La “victime” a recherché l’exhibition (voyeurisme, naturisme, spectacles érotiques)',
    explanation:
        'Le cours : pas d’exhibition si l’exposition a été recherchée par le spectateur.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Élément moral',
    question: 'L’élément moral exige :',
    options: [
      'La conscience du caractère impudique de l’acte',
      'Une intention de choquer obligatoirement',
      'Un résultat médical',
    ],
    answer: 'La conscience du caractère impudique de l’acte',
    explanation: 'Le cours : intention coupable = conscience de l’impudicité.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Aggravation',
    question:
        'L’exhibition sexuelle est aggravée lorsque les faits sont commis :',
    options: [
      'Au préjudice d’un mineur de quinze ans',
      'Au préjudice d’un majeur',
      'Dans un lieu privé',
    ],
    answer: 'Au préjudice d’un mineur de quinze ans',
    explanation:
        'Le cours : aggravation prévue par 222-32 al. 3 pour mineur de 15 ans.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Peines (simple)',
    question: 'L’exhibition sexuelle simple est punie de :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation: 'Le cours : 222-32 al. 1 = 1 an et 15 000 €.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Peines (aggravée)',
    question: 'L’exhibition sexuelle aggravée (mineur <15) est punie de :',
    options: [
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 30 000 € d’amende',
    explanation: 'Le cours : 222-32 al. 3 = 2 ans et 30 000 €.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Tentative',
    question: 'La tentative d’exhibition sexuelle est :',
    options: ['Non', 'Oui', 'Oui uniquement si mineur'],
    answer: 'Non',
    explanation: 'Le cours : tentative non.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // ✅ AGRESSIONS SEXUELLES AUTRES QUE LE VIOL — BANQUE (NIVEAUX MIXTES)
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle — Élément matériel',
    question: 'L’agression sexuelle suppose nécessairement :',
    options: [
      'Un contact physique entre l’auteur et la victime',
      'Une pénétration',
      'Une relation sexuelle complète',
    ],
    answer: 'Un contact physique entre l’auteur et la victime',
    explanation:
        'Le cours précise que l’agression sexuelle implique un contact physique, sans pénétration.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Qualification',
    question: 'Un acte sexuel sans contact physique relève en principe :',
    options: [
      'D’une autre infraction que l’agression sexuelle',
      'Toujours d’une agression sexuelle',
      'D’un viol',
    ],
    answer: 'D’une autre infraction que l’agression sexuelle',
    explanation:
        'Sans contact physique, on s’oriente vers d’autres qualifications (exhibition, harcèlement…).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Acte sur soi',
    question:
        'Un individu qui se livre à un acte obscène sur lui-même devant des témoins commet :',
    options: ['Une exhibition sexuelle', 'Une agression sexuelle', 'Un viol'],
    answer: 'Une exhibition sexuelle',
    explanation:
        'Le cours distingue clairement l’exhibition sexuelle de l’agression sexuelle.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Acte imposé',
    question: 'Il y a agression sexuelle lorsque :',
    options: [
      'Un acte impudique est directement exercé sur une personne',
      'Un acte sexuel est seulement imaginé',
      'Un acte est consenti',
    ],
    answer: 'Un acte impudique est directement exercé sur une personne',
    explanation: 'Définition jurisprudentielle de l’agression sexuelle.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Victime contrainte',
    question:
        'Une agression sexuelle peut être constituée si la victime est contrainte :',
    options: [
      'À effectuer un acte sexuel sur l’auteur',
      'À regarder l’auteur',
      'À entendre des propos',
    ],
    answer: 'À effectuer un acte sexuel sur l’auteur',
    explanation:
        'Le cours précise que l’acte peut être commis par la victime contrainte.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Absence de consentement',
    question: 'L’absence de consentement se caractérise par :',
    options: [
      'Violence, contrainte, menace ou surprise',
      'La seule opposition verbale',
      'Le silence de la victime',
    ],
    answer: 'Violence, contrainte, menace ou surprise',
    explanation:
        'Comme pour le viol, ces quatre moyens caractérisent l’absence de consentement.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Violence',
    question: 'La violence doit être suffisante pour :',
    options: [
      'Empêcher la victime de résister',
      'Provoquer une ITT',
      'Laisser des traces visibles',
    ],
    answer: 'Empêcher la victime de résister',
    explanation:
        'La jurisprudence apprécie la violence au regard de la capacité de résistance.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Violence (appréciation)',
    question:
        'L’appréciation du caractère contraignant de la violence appartient :',
    options: ['Aux juges', 'À la victime seule', 'Au médecin'],
    answer: 'Aux juges',
    explanation: 'Pouvoir souverain d’appréciation des juges du fond.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Contrainte morale',
    question: 'La contrainte morale peut être assimilée à :',
    options: [
      'Une violence physique',
      'Une simple gêne',
      'Une politesse maladroite',
    ],
    answer: 'Une violence physique',
    explanation:
        'La jurisprudence assimile la contrainte morale à une violence.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Menace',
    question: 'La menace doit inspirer à la victime :',
    options: [
      'Une crainte sérieuse et immédiate',
      'Une inquiétude abstraite',
      'Un simple malaise',
    ],
    answer: 'Une crainte sérieuse et immédiate',
    explanation:
        'Cass. crim., 8 juin 1994 : appréciation concrète selon la victime.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Surprise',
    question: 'La surprise correspond à :',
    options: [
      'La captation du consentement',
      'La colère de la victime',
      'La plainte déposée tardivement',
    ],
    answer: 'La captation du consentement',
    explanation:
        'La surprise vise l’impossibilité de consentir, pas l’émotion ressentie.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Surprise (sommeil)',
    question: 'Des attouchements commis sur une victime endormie relèvent :',
    options: ['De la surprise', 'D’un simple trouble', 'D’une contravention'],
    answer: 'De la surprise',
    explanation: 'Cass. crim., 11 septembre 2024.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Surprise (tromperie)',
    question:
        'L’utilisation d’un faux prétexte médical pour toucher une victime constitue :',
    options: [
      'La surprise',
      'Une violence physique',
      'Un consentement vicié mais licite',
    ],
    answer: 'La surprise',
    explanation: 'Cass. crim., 20 juin 2001 : prétexte fallacieux.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Intention',
    question: 'L’élément moral exige que l’auteur :',
    options: [
      'Ait conscience de commettre un acte obscène contre le gré de la victime',
      'Veuille blesser la victime',
      'Reconnaisse les faits',
    ],
    answer:
        'Ait conscience de commettre un acte obscène contre le gré de la victime',
    explanation: 'Intention coupable nécessaire à toute infraction.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Mobile',
    question: 'Le mobile de l’auteur est :',
    options: [
      'Indifférent à la qualification',
      'Toujours exigé',
      'Une cause d’exonération',
    ],
    answer: 'Indifférent à la qualification',
    explanation:
        'Vengeance, haine ou lubricité n’ont pas d’incidence juridique.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // ✅ EXHIBITION SEXUELLE — QUESTIONS PAR NIVEAUX
  // =========================================================
  const QuizQuestion(
    category: 'Exhibition sexuelle — Définition',
    question: 'L’exhibition sexuelle suppose :',
    options: [
      'Un acte sexuel imposé à la vue d’autrui',
      'Un contact physique',
      'Une relation consentie',
    ],
    answer: 'Un acte sexuel imposé à la vue d’autrui',
    explanation: 'L’exhibition sexuelle est une infraction sans contact.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Lieu',
    question: 'L’acte doit être commis :',
    options: [
      'Dans un lieu accessible aux regards du public',
      'Uniquement sur internet',
      'Uniquement dans un domicile fermé',
    ],
    answer: 'Dans un lieu accessible aux regards du public',
    explanation: 'Article 222-32 du Code pénal.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Lieu public',
    question: 'Dans un lieu public, la publicité de l’acte est :',
    options: ['Présumée', 'À prouver systématiquement', 'Impossible'],
    answer: 'Présumée',
    explanation: 'La publicité est inhérente au lieu public.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Visible ou non',
    question: 'L’infraction est constituée même si :',
    options: [
      'L’acte n’a pas été vu mais pouvait l’être',
      'La victime détourne le regard',
      'L’auteur est nu partiellement',
    ],
    answer: 'L’acte n’a pas été vu mais pouvait l’être',
    explanation: 'Cass. crim., 16 janvier 1862.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Loi 2021',
    question:
        'Depuis la loi du 21 avril 2021, l’exhibition peut être constituée :',
    options: [
      'Sans nudité visible si un acte sexuel explicite est imposé',
      'Uniquement si le sexe est dénudé',
      'Uniquement en cas de récidive',
    ],
    answer: 'Sans nudité visible si un acte sexuel explicite est imposé',
    explanation: 'Extension légale du champ de l’exhibition sexuelle.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Consentement des témoins',
    question: 'L’infraction n’est pas constituée si les témoins :',
    options: [
      'Ont volontairement recherché l’exhibition',
      'Sont majeurs',
      'Ont déjà vu des scènes similaires',
    ],
    answer: 'Ont volontairement recherché l’exhibition',
    explanation:
        'Exclusion en cas de voyeurisme, naturisme ou spectacles érotiques.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Mineur',
    question: 'L’exhibition sexuelle est aggravée lorsqu’elle est commise :',
    options: [
      'Au préjudice d’un mineur de quinze ans',
      'Devant un adulte',
      'Dans un lieu privé',
    ],
    answer: 'Au préjudice d’un mineur de quinze ans',
    explanation: 'Article 222-32 alinéa 3.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Tentative',
    question: 'La tentative d’exhibition sexuelle est :',
    options: ['Non punissable', 'Punissable', 'Punissable seulement si mineur'],
    answer: 'Non punissable',
    explanation: 'La tentative n’est pas prévue par le texte.',
    difficulty: 'Facile',
  ),

  // =========================================================
  // ✅ AGRESSIONS SEXUELLES (HORS VIOL) + MINEUR 15 + VULNÉRABLE + EXHIBITION
  // ✅ SUITE — 3 NIVEAUX : Facile / Moyenne / Difficile
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle — Définition (222-22 / 222-27)',
    question:
        'Les agressions sexuelles autres que le viol sont réprimées par :',
    options: [
      'L’article 222-27 du Code pénal',
      'L’article 222-23 du Code pénal',
      'L’article 222-32 du Code pénal',
    ],
    answer: 'L’article 222-27 du Code pénal',
    explanation:
        'Le cours précise que l’article 222-27 prévoit et réprime les agressions sexuelles autres que le viol.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Élément matériel',
    question: 'Une agression sexuelle (hors viol) se distingue du viol par :',
    options: [
      'L’absence de pénétration sexuelle ou d’acte bucco-génital',
      'L’absence d’intention',
      'L’absence de victime',
    ],
    answer: 'L’absence de pénétration sexuelle ou d’acte bucco-génital',
    explanation:
        'Le viol implique une pénétration ou un acte bucco-génital, l’agression sexuelle non.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Contact',
    question: 'Le plus grand nombre d’agressions sexuelles est constitué :',
    options: [
      'D’attouchements ou caresses (sexe, fesses, cuisses, poitrine) parfois avec baisers',
      'D’actes sans aucun contact',
      'De propos à connotation sexuelle uniquement',
    ],
    answer:
        'D’attouchements ou caresses (sexe, fesses, cuisses, poitrine) parfois avec baisers',
    explanation:
        'Le cours cite les attouchements/caresses et parfois baisers comme cas typiques.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Victime',
    question:
        'La condition de la victime (ex : prostituée, hôtesse de bar, ex-partenaire) :',
    options: [
      'N’écarte pas la qualification si les actes sont imposés',
      'Écarte toujours la qualification',
      'Transforme automatiquement en contravention',
    ],
    answer: 'N’écarte pas la qualification si les actes sont imposés',
    explanation:
        'Le cours précise l’indifférence de la condition de la victime : seul compte l’acte imposé.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Mariage',
    question: 'Une agression sexuelle peut être constituée entre époux :',
    options: [
      'Oui, quelle que soit la nature des relations, y compris le mariage',
      'Non, le mariage exclut l’infraction',
      'Oui, uniquement si divorce engagé',
    ],
    answer:
        'Oui, quelle que soit la nature des relations, y compris le mariage',
    explanation:
        'L’article 222-22 précise que l’infraction est constituée quelle que soit la relation, y compris le mariage.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Cadavre',
    question: 'Une agression sexuelle sur un cadavre :',
    options: [
      'N’est pas possible juridiquement : un mort ne peut consentir',
      'Est toujours qualifiée d’agression sexuelle',
      'Est une contravention',
    ],
    answer: 'N’est pas possible juridiquement : un mort ne peut consentir',
    explanation:
        'Le cours rappelle qu’il ne peut y avoir agression sexuelle sur un cadavre ; une infraction autonome existe (atteinte à l’intégrité du cadavre).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Violence',
    question: 'La violence, pour l’agression sexuelle, correspond :',
    options: [
      'À une violence physique suffisante pour réaliser l’acte malgré le refus',
      'À une simple pression sociale',
      'À une gêne passagère',
    ],
    answer:
        'À une violence physique suffisante pour réaliser l’acte malgré le refus',
    explanation:
        'Le cours vise la violence physique permettant l’acte malgré le refus de la victime.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Contrainte (222-22-1)',
    question: 'La contrainte prévue pour les agressions sexuelles peut être :',
    options: ['Physique ou morale', 'Uniquement physique', 'Uniquement morale'],
    answer: 'Physique ou morale',
    explanation:
        'Article 222-22-1 : la contrainte peut être physique ou morale.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Menace/Contrainte',
    question: 'La menace ou la contrainte doit inspirer :',
    options: [
      'Une crainte sérieuse et immédiate',
      'Une crainte vague et future',
      'Une simple inquiétude',
    ],
    answer: 'Une crainte sérieuse et immédiate',
    explanation:
        'Le cours reprend l’exigence jurisprudentielle : crainte sérieuse et immédiate.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Surprise',
    question: 'La surprise s’entend principalement comme :',
    options: [
      'Surprendre le consentement de la victime',
      'La surprise ressentie après',
      'Une réaction de colère',
    ],
    answer: 'Surprendre le consentement de la victime',
    explanation:
        'Le cours précise que la surprise vise la captation du consentement, pas l’émotion.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Surprise (prétexte)',
    question:
        'Un prétexte fallacieux de visite médicale utilisé pour toucher une personne caractérise :',
    options: ['La surprise', 'La légitime défense', 'Un consentement présumé'],
    answer: 'La surprise',
    explanation:
        'Cass. crim., 20 juin 2001 : la surprise est retenue en cas de prétexte médical fallacieux.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Mineur 15-18 (222-22-1)',
    question:
        'Pour les agressions sexuelles (222-27), la contrainte morale ou la surprise par différence d’âge et autorité concerne :',
    options: [
      'Les mineurs de 15 à 18 ans',
      'Uniquement les mineurs de moins de 15 ans',
      'Uniquement les majeurs',
    ],
    answer: 'Les mineurs de 15 à 18 ans',
    explanation:
        'Le cours indique que, pour 222-27, cette règle vise les mineurs de 15 à 18 ans.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Élément moral',
    question: 'L’élément moral de l’agression sexuelle exige :',
    options: [
      'La conscience de commettre un acte obscène contre le gré de la victime',
      'La volonté de blesser physiquement',
      'La preuve d’un mobile précis',
    ],
    answer:
        'La conscience de commettre un acte obscène contre le gré de la victime',
    explanation:
        'Le cours rappelle l’intention coupable : conscience de l’acte obscène contre le gré.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Circonstances aggravantes (222-28)',
    question: 'L’une des circonstances aggravantes de l’article 222-28 est :',
    options: [
      'Agression commise avec usage ou menace d’une arme',
      'Agression commise sans témoin',
      'Agression commise dans un lieu privé',
    ],
    answer: 'Agression commise avec usage ou menace d’une arme',
    explanation:
        'Le cours liste l’arme comme circonstance aggravante de l’article 222-28.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Circonstances aggravantes (222-28)',
    question:
        'La circonstance aggravante “par plusieurs personnes agissant en qualité d’auteur ou de complice” concerne :',
    options: [
      'La participation de plusieurs personnes',
      'Uniquement la récidive',
      'Uniquement un auteur isolé',
    ],
    answer: 'La participation de plusieurs personnes',
    explanation:
        'L’article 222-28 vise le cas où plusieurs personnes participent en auteur/complice.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Circonstances aggravantes (222-28)',
    question: 'L’agression sexuelle est aggravée lorsqu’elle est commise :',
    options: [
      'Par le conjoint, concubin ou partenaire de PACS',
      'Uniquement par un inconnu',
      'Uniquement au travail',
    ],
    answer: 'Par le conjoint, concubin ou partenaire de PACS',
    explanation:
        'Le cours cite cette circonstance aggravante à l’article 222-28.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Substances',
    question:
        'Le fait qu’une substance ait été administrée à l’insu de la victime afin d’altérer son discernement est :',
    options: [
      'Une circonstance aggravante (222-28)',
      'Un fait sans effet juridique',
      'Une cause d’irresponsabilité',
    ],
    answer: 'Une circonstance aggravante (222-28)',
    explanation:
        'Le cours mentionne l’administration de substance à l’insu de la victime comme aggravation.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Répression (222-27)',
    question:
        'Les peines principales de l’agression sexuelle simple (222-27) sont :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Le tableau du cours indique 5 ans et 75 000 € pour 222-27.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Répression aggravée (222-28)',
    question:
        'Les peines principales de l’agression sexuelle aggravée (222-28) sont :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '15 ans de réclusion criminelle',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Le cours indique 7 ans et 100 000 € pour 222-28.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Tentative',
    question: 'La tentative d’agression sexuelle est :',
    options: [
      'Punissable',
      'Non punissable',
      'Punissable uniquement si plainte immédiate',
    ],
    answer: 'Punissable',
    explanation: 'Le cours indique que la tentative est prévue (art. 222-31).',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Provocation (222-30-2)',
    question:
        'La provocation à commettre une agression sexuelle (222-30-2) est :',
    options: [
      'Une infraction distincte si l’agression n’a été ni commise ni tentée',
      'Toujours une complicité automatique',
      'Toujours une contravention',
    ],
    answer:
        'Une infraction distincte si l’agression n’a été ni commise ni tentée',
    explanation:
        'Le cours précise que 222-30-2 incrimine l’instigateur même sans passage à l’acte.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Provocation (peine)',
    question:
        'La provocation à commettre une agression sexuelle (hors cas mineur) est punie de :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation: 'Le cours indique 5 ans et 75 000 € pour 222-30-2.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Provocation sur mineur',
    question:
        'Si l’agression sexuelle provoquée devait être commise sur un mineur, la peine de la provocation est portée à :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation:
        'Le cours précise l’aggravation de la provocation en cas de mineur.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ✅ AGRESSIONS SEXUELLES IMPOSÉES À UN MINEUR DE 15 ANS (222-29-1)
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle — Mineur de 15 ans (222-29-1)',
    question:
        'L’article réprimant les agressions sexuelles (hors viol) imposées à un mineur de 15 ans est :',
    options: ['222-29-1', '222-27', '222-32'],
    answer: '222-29-1',
    explanation:
        'Le cours indique que l’article 222-29-1 prévoit et réprime ces faits.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Mineur de 15 ans',
    question: 'Pour 222-29-1, les faits doivent être commis :',
    options: [
      'Par violence, contrainte, menace ou surprise',
      'Uniquement par surprise',
      'Uniquement sans violence',
    ],
    answer: 'Par violence, contrainte, menace ou surprise',
    explanation:
        'Le texte vise explicitement V/C/M/S pour les agressions imposées au mineur de 15 ans.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Mineur de 15 ans',
    question:
        'L’âge pris en compte pour déterminer si la victime a moins de 15 ans est :',
    options: [
      'L’âge au moment des faits',
      'L’âge au moment du jugement',
      'L’âge déclaré par la victime',
    ],
    answer: 'L’âge au moment des faits',
    explanation:
        'Le cours précise que c’est l’âge au moment des faits (calculé d’heure à heure).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Mineur de 15 ans (erreur)',
    question: 'L’erreur sur l’âge de la victime :',
    options: [
      'N’atténue pas la responsabilité, mais certaines hypothèses peuvent exclure l’infraction si l’auteur prouve avoir été trompé',
      'Annule automatiquement l’infraction',
      'Transforme en contravention',
    ],
    answer:
        'N’atténue pas la responsabilité, mais certaines hypothèses peuvent exclure l’infraction si l’auteur prouve avoir été trompé',
    explanation:
        'Le cours rappelle le principe et l’exception jurisprudentielle (preuve d’avoir été trompé).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Mineur de 15 ans (peines)',
    question: 'Les peines principales de 222-29-1 sont :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation: 'Le tableau du cours fixe 10 ans et 150 000 € pour 222-29-1.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Mineur de 15 ans',
    question:
        'Pour un mineur de 15 ans, la contrainte morale ou la surprise peuvent être caractérisées par :',
    options: [
      'L’abus de vulnérabilité du mineur ne disposant pas du discernement nécessaire',
      'Le seul silence du mineur',
      'Le seul lieu public',
    ],
    answer:
        'L’abus de vulnérabilité du mineur ne disposant pas du discernement nécessaire',
    explanation:
        'Art. 222-22-1 et cours : l’abus de vulnérabilité caractérise contrainte morale/surprise.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ✅ AGRESSIONS SEXUELLES SUR PERSONNE VULNÉRABLE (222-29 / 222-30)
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle — Personne vulnérable (222-29)',
    question:
        'L’article réprimant l’agression sexuelle (hors viol) imposée à une personne vulnérable est :',
    options: ['222-29', '222-29-1', '222-27'],
    answer: '222-29',
    explanation:
        'Le cours indique que l’article 222-29 prévoit et réprime ces agressions sur personne vulnérable.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Vulnérabilité',
    question: 'La vulnérabilité prise en compte par 222-29 doit :',
    options: [
      'Préexister aux faits et ne pas être la conséquence des faits',
      'Être créée par l’agression',
      'Être uniquement économique',
    ],
    answer: 'Préexister aux faits et ne pas être la conséquence des faits',
    explanation:
        'Le cours précise que la vulnérabilité doit préexister (Cass. crim., 17 octobre 1984).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Vulnérabilité',
    question: 'La vulnérabilité doit être :',
    options: [
      'Apparente ou connue de l’auteur',
      'Toujours inconnue de l’auteur',
      'Constatée uniquement par certificat médical',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation:
        'Condition d’apparence ou connaissance exigée par le texte et le cours.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Vulnérabilité (âge)',
    question: 'Concernant la vulnérabilité liée à l’âge :',
    options: [
      'Le seul âge ne suffit pas, il faut caractériser une vulnérabilité particulière',
      'Le seul âge suffit toujours',
      'L’âge est toujours ignoré',
    ],
    answer:
        'Le seul âge ne suffit pas, il faut caractériser une vulnérabilité particulière',
    explanation:
        'Le cours indique que l’âge seul ne suffit pas : il faut démontrer une vulnérabilité particulière.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Vulnérabilité (précarité)',
    question:
        'La précarité économique ou sociale peut rendre une personne vulnérable car elle :',
    options: [
      'Peut créer une dépendance et favoriser l’exploitation',
      'Supprime toujours le consentement',
      'Annule toute responsabilité',
    ],
    answer: 'Peut créer une dépendance et favoriser l’exploitation',
    explanation:
        'Le cours définit la précarité et son lien avec la dépendance/exploitation.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Vulnérable (peines)',
    question:
        'Les peines principales de l’agression sexuelle sur personne vulnérable (222-29) sont :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Le tableau du cours indique 7 ans et 100 000 € pour 222-29.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Vulnérable aggravée (222-30)',
    question:
        'L’agression sexuelle sur personne vulnérable est aggravée (222-30) notamment lorsqu’elle :',
    options: [
      'A entraîné une blessure ou une lésion',
      'A été commise dans un lieu public',
      'A été commise de nuit',
    ],
    answer: 'A entraîné une blessure ou une lésion',
    explanation:
        'Le cours cite “blessure ou lésion” comme circonstance aggravante à l’article 222-30.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Vulnérable aggravée (peines)',
    question: 'Les peines principales en cas d’aggravation (222-30) sont :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation: 'Le tableau du cours indique 10 ans et 150 000 € pour 222-30.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // ✅ EXHIBITION SEXUELLE (222-32) — SUITE
  // =========================================================
  const QuizQuestion(
    category: 'Exhibition sexuelle — Texte',
    question: 'L’exhibition sexuelle est prévue et réprimée par :',
    options: [
      'L’article 222-32 du Code pénal',
      'L’article 222-27 du Code pénal',
      'L’article 222-23 du Code pénal',
    ],
    answer: 'L’article 222-32 du Code pénal',
    explanation:
        'Le cours indique que l’article 222-32 prévoit et réprime l’exhibition sexuelle.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Contact',
    question: 'L’exhibition sexuelle se caractérise par :',
    options: [
      'L’absence de contact physique entre auteur et victime',
      'Un contact nécessaire',
      'Une pénétration',
    ],
    answer: 'L’absence de contact physique entre auteur et victime',
    explanation:
        'Le cours précise l’absence de contact : ce n’est pas une agression sexuelle “classique”.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Publicité',
    question: 'L’exhibition doit être imposée :',
    options: [
      'À la vue d’autrui dans un lieu accessible aux regards du public',
      'Uniquement à un proche',
      'Uniquement sur un réseau social',
    ],
    answer: 'À la vue d’autrui dans un lieu accessible aux regards du public',
    explanation:
        'Condition de publicité : “imposée à la vue d’autrui” dans un lieu visible du public.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Lieu privé',
    question:
        'Une exhibition commise dans un lieu privé peut être retenue si :',
    options: [
      'Elle est visible depuis un lieu public faute de précautions',
      'L’auteur est seul',
      'La victime est consentante',
    ],
    answer: 'Elle est visible depuis un lieu public faute de précautions',
    explanation:
        'Le texte vise aussi le lieu “accessible aux regards du public”, y compris depuis un privé.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Nudité',
    question:
        'Depuis l’évolution légale, l’exhibition est constituée même sans nudité visible si :',
    options: [
      'Un acte sexuel explicite réel ou simulé est imposé à la vue d’autrui',
      'Un simple regard est échangé',
      'Un propos grivois est tenu',
    ],
    answer:
        'Un acte sexuel explicite réel ou simulé est imposé à la vue d’autrui',
    explanation:
        'Le cours précise : acte sexuel explicite réel ou simulé, même sans partie dénudée visible.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Élément moral',
    question: 'L’auteur doit avoir :',
    options: [
      'Conscience de l’impudicité de l’acte',
      'L’intention de blesser',
      'Une intention de voler',
    ],
    answer: 'Conscience de l’impudicité de l’acte',
    explanation:
        'Le cours indique que l’intention coupable est la conscience du caractère impudique.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Peines simples',
    question: 'Les peines principales de l’exhibition sexuelle simple sont :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation: 'Le tableau du cours indique 1 an et 15 000 € (222-32 al.1).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Aggravation (mineur 15)',
    question: 'L’exhibition sexuelle est aggravée si commise au préjudice :',
    options: [
      'D’un mineur de quinze ans',
      'D’un majeur uniquement',
      'D’un témoin consentant',
    ],
    answer: 'D’un mineur de quinze ans',
    explanation:
        'Article 222-32 alinéa 3 : aggravation si victime mineure de 15 ans.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Peines aggravées',
    question:
        'Les peines principales de l’exhibition sexuelle aggravée (mineur de 15 ans) sont :',
    options: [
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 30 000 € d’amende',
    explanation:
        'Le cours indique 2 ans et 30 000 € en cas d’aggravation (222-32 al.3).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Tentative',
    question: 'La tentative d’exhibition sexuelle est :',
    options: [
      'Non punissable',
      'Punissable',
      'Punissable seulement en cas de mineur',
    ],
    answer: 'Non punissable',
    explanation: 'Le cours précise : “TENTATIVE : NON”.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Diffusion de messages',
    question:
        'Des photos obscènes diffusées (sans acte imposé à la vue dans un lieu accessible) relèvent plutôt :',
    options: [
      'D’infractions spécifiques de diffusion de messages pornographiques',
      'Toujours de l’exhibition sexuelle',
      'Toujours d’une agression sexuelle',
    ],
    answer:
        'D’infractions spécifiques de diffusion de messages pornographiques',
    explanation:
        'Le cours distingue l’exhibition (acte imposé à la vue) des infractions de diffusion de messages pornographiques.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ✅ SUITE — AGRESSIONS SEXUELLES (222-22 / 222-27 / 222-28)
  // ✅ MINEUR -15 (222-29-1) / VULNÉRABLE (222-29 / 222-30)
  // ✅ EXHIBITION (222-32)
  // ✅ 3 NIVEAUX : Facile / Moyenne / Difficile
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle — Élément légal',
    question: 'L’article 222-22 du Code pénal :',
    options: [
      'Définit les agressions sexuelles commises avec violence, contrainte, menace ou surprise',
      'Réprime l’exhibition sexuelle',
      'Réprime le viol incestueux',
    ],
    answer:
        'Définit les agressions sexuelles commises avec violence, contrainte, menace ou surprise',
    explanation:
        'Le cours indique que 222-22 définit les agressions sexuelles (violence/contrainte/menace/surprise).',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Contenu',
    question:
        'Une agression sexuelle (hors viol) peut être constituée lorsque :',
    options: [
      'La victime est contrainte d’effectuer un acte sur l’auteur, sans pénétration ni acte bucco-génital',
      'Il n’existe aucun contact physique',
      'Il existe une pénétration sexuelle',
    ],
    answer:
        'La victime est contrainte d’effectuer un acte sur l’auteur, sans pénétration ni acte bucco-génital',
    explanation:
        'Le cours précise que l’agression sexuelle peut être le fait de l’auteur sur la victime ou de la victime contrainte sur l’auteur.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Jurisprudence (C.A. Agen)',
    question:
        'Le fait de caresser le dos de la victime en passant la main sous son pull-over a été qualifié :',
    options: [
      'D’agression sexuelle (exemple jurisprudentiel)',
      'D’exhibition sexuelle',
      'De simple injure non publique',
    ],
    answer: 'D’agression sexuelle (exemple jurisprudentiel)',
    explanation:
        'Le cours cite cet exemple (C.A. Agen, 27 octobre 1997) comme illustration d’une atteinte sexuelle.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Consentement',
    question:
        'L’absence de consentement dans l’agression sexuelle (hors viol) est établie par :',
    options: [
      'Violence, contrainte, menace ou surprise',
      'La seule présence d’un témoin',
      'Le seul fait que la victime soit mineure de 18 ans',
    ],
    answer: 'Violence, contrainte, menace ou surprise',
    explanation:
        'Comme le viol, l’agression sexuelle (hors viol) suppose V/C/M/S pour exclure le consentement.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Violence et résistance',
    question: 'Concernant la violence, il faut établir que :',
    options: [
      'La victime n’a pas pu résister à la violence physique employée',
      'La victime a toujours crié',
      'La victime a forcément porté plainte immédiatement',
    ],
    answer: 'La victime n’a pas pu résister à la violence physique employée',
    explanation:
        'Le cours indique que l’absence de consentement suppose que la victime n’a pas pu résister à la violence physique.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Menace/Contrainte (appréciation)',
    question: 'L’appréciation de la menace ou de la contrainte doit être :',
    options: [
      'Concrète, selon la capacité de résistance de la victime',
      'Abstraite, identique pour tous',
      'Basée uniquement sur le lieu',
    ],
    answer: 'Concrète, selon la capacité de résistance de la victime',
    explanation:
        'Le cours rappelle l’appréciation concrète selon la capacité de résistance (Cass. crim., 08 juin 1994).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Surprise (endormissement)',
    question:
        'Des attouchements commis sur une victime endormie peuvent être qualifiés par :',
    options: [
      'La surprise',
      'La légitime défense',
      'Le consentement implicite',
    ],
    answer: 'La surprise',
    explanation:
        'Le cours cite un arrêt validant la surprise lorsque la victime était endormie (Cass. crim., 11 septembre 2024).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Mineur présent',
    question:
        'Le fait qu’un mineur soit présent au moment des faits et y assiste est :',
    options: [
      'Une circonstance aggravante (222-28)',
      'Une cause d’irresponsabilité',
      'Sans incidence pénale',
    ],
    answer: 'Une circonstance aggravante (222-28)',
    explanation:
        'Le cours liste la présence d’un mineur assistant aux faits comme aggravation de l’article 222-28.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Réseaux électroniques',
    question:
        'Le fait que la victime ait été mise en contact avec l’auteur via un réseau de communication électronique est :',
    options: [
      'Une circonstance aggravante (222-28)',
      'Une excuse légale',
      'Une condition de constitution de l’infraction',
    ],
    answer: 'Une circonstance aggravante (222-28)',
    explanation:
        'Le cours mentionne cette circonstance aggravante parmi celles de 222-28.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Concours réel',
    question:
        'Si l’agression sexuelle entraîne la mort ou s’accompagne de tortures :',
    options: [
      'Il peut y avoir concours réel d’infractions (agression sexuelle + violences/tortures/mort)',
      'La qualification devient automatiquement “viol”',
      'L’agression sexuelle disparaît',
    ],
    answer:
        'Il peut y avoir concours réel d’infractions (agression sexuelle + violences/tortures/mort)',
    explanation:
        'Le cours indique qu’en cas de violences graves/tortures/mort, on retient un concours réel avec l’agression sexuelle simple.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Complicité',
    question: 'La complicité en matière d’agression sexuelle :',
    options: [
      'Est punissable et même aggravante (222-28 4°)',
      'N’existe pas car c’est une infraction personnelle',
      'N’est possible que pour les contraventions',
    ],
    answer: 'Est punissable et même aggravante (222-28 4°)',
    explanation:
        'Le cours précise que la complicité est punissable et figure comme circonstance aggravante.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ✅ MINEUR DE 15 ANS (222-29-1) — SUITE
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle — Mineur de 15 ans',
    question: 'Concernant 222-29-1, la minorité de 15 ans :',
    options: [
      'N’a pas à être apparente ou connue de l’auteur',
      'Doit obligatoirement être apparente',
      'Doit être prouvée uniquement par certificat médical',
    ],
    answer: 'N’a pas à être apparente ou connue de l’auteur',
    explanation:
        'Le cours précise que le texte ne demande pas que la minorité soit apparente ou connue : protection particulière.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Mineur de 15 ans',
    question: 'La preuve de l’âge du mineur peut se faire :',
    options: [
      'Par tout moyen à défaut d’acte probant',
      'Uniquement par passeport',
      'Uniquement par déclaration orale',
    ],
    answer: 'Par tout moyen à défaut d’acte probant',
    explanation:
        'Le cours indique qu’à défaut d’acte ayant valeur probante, la preuve se fait par tout moyen.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Mineur de 15 ans',
    question: 'L’âge de la victime se calcule :',
    options: [
      'D’heure à heure',
      'Par année civile uniquement',
      'Par trimestre',
    ],
    answer: 'D’heure à heure',
    explanation: 'Le cours précise que l’âge se calcule d’heure à heure.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Mineur de 15 ans (élément moral)',
    question: 'Pour l’élément moral, il faut notamment :',
    options: [
      'La conscience de commettre l’acte contre le gré et la connaissance de l’âge < 15 ans (principe)',
      'La preuve d’un mobile de haine',
      'La preuve d’une blessure',
    ],
    answer:
        'La conscience de commettre l’acte contre le gré et la connaissance de l’âge < 15 ans (principe)',
    explanation:
        'Le cours rappelle l’intention + la question de la connaissance de l’âge (avec nuance jurisprudentielle).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ✅ PERSONNE VULNÉRABLE (222-29 / 222-30) — SUITE
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle — Personne vulnérable',
    question: 'Les causes de vulnérabilité visées par 222-29 sont :',
    options: [
      'Limitativement énumérées (âge, maladie, infirmité, déficience, grossesse, précarité)',
      'Illimitées, au choix du juge',
      'Uniquement liées à l’âge',
    ],
    answer:
        'Limitativement énumérées (âge, maladie, infirmité, déficience, grossesse, précarité)',
    explanation:
        'Le cours indique que les causes sont listées de manière limitative.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Vulnérabilité (grossesse)',
    question: 'La grossesse peut entraîner une vulnérabilité particulière :',
    options: [
      'Pendant la grossesse et aussi après l’accouchement',
      'Uniquement pendant le premier trimestre',
      'Uniquement si la victime est hospitalisée',
    ],
    answer: 'Pendant la grossesse et aussi après l’accouchement',
    explanation:
        'Le cours précise que la vulnérabilité peut exister pendant la grossesse et après l’accouchement.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Vulnérabilité (déficience)',
    question:
        'La maladie, infirmité ou déficience physique/psychique renvoie à :',
    options: [
      'Des dysfonctionnements corporels/mentaux (innés ou acquis, naturels ou provoqués)',
      'Uniquement une maladie contagieuse',
      'Uniquement un handicap visible',
    ],
    answer:
        'Des dysfonctionnements corporels/mentaux (innés ou acquis, naturels ou provoqués)',
    explanation:
        'Le cours décrit largement ces notions comme dysfonctionnements physiques ou mentaux.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Vulnérable aggravée',
    question: 'L’usage ou menace d’une arme dans 222-30 :',
    options: [
      'Aggrave l’infraction',
      'Supprime l’élément moral',
      'Transforme automatiquement en exhibition',
    ],
    answer: 'Aggrave l’infraction',
    explanation:
        'Le cours liste l’arme comme circonstance aggravante de l’article 222-30.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Vulnérable aggravée (substance)',
    question:
        'Si une substance est administrée à l’insu de la victime pour altérer discernement/contrôle :',
    options: [
      'C’est une circonstance aggravante (222-30)',
      'C’est une excuse',
      'C’est sans incidence',
    ],
    answer: 'C’est une circonstance aggravante (222-30)',
    explanation:
        'Le cours cite l’administration d’une substance à l’insu comme aggravation de 222-30.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // ✅ EXHIBITION SEXUELLE (222-32) — SUITE
  // =========================================================
  const QuizQuestion(
    category: 'Exhibition sexuelle — Nature',
    question: 'L’exhibition sexuelle sanctionne principalement :',
    options: [
      'Le spectacle imposé à autrui, pas l’acte sexuel en lui-même',
      'Le seul fait d’être nu chez soi',
      'Toute parole grivoise',
    ],
    answer: 'Le spectacle imposé à autrui, pas l’acte sexuel en lui-même',
    explanation:
        'Le cours précise : ce n’est pas l’acte impudique qui est punissable, mais le spectacle pour autrui.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Lieux publics',
    question: 'Dans un lieu public, la publicité est :',
    options: [
      'Absolue : l’infraction est constituée même si personne n’a effectivement vu',
      'Conditionnée à la présence d’au moins deux témoins',
      'Impossible à caractériser',
    ],
    answer:
        'Absolue : l’infraction est constituée même si personne n’a effectivement vu',
    explanation:
        'Le cours indique que dans un lieu public, il suffit que l’acte pouvait être vu.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Victime “voyeur”',
    question: 'L’exhibition sexuelle n’est pas retenue si :',
    options: [
      'La “victime” a recherché l’exhibition (voyeurisme, spectacles érotiques, etc.)',
      'L’acte est commis de jour',
      'L’auteur est majeur',
    ],
    answer:
        'La “victime” a recherché l’exhibition (voyeurisme, spectacles érotiques, etc.)',
    explanation:
        'Le cours précise que l’exhibition doit être imposée : pas retenue si la personne la recherche.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Exemple',
    question: 'Exhiber ses parties sexuelles à la vue d’employés de péage :',
    options: [
      'Peut constituer une exhibition sexuelle',
      'Constitue une simple contravention de stationnement',
      'Constitue un viol',
    ],
    answer: 'Peut constituer une exhibition sexuelle',
    explanation:
        'Le cours cite un exemple jurisprudentiel au péage (Cass. crim., 04 juin 1997).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Acte sexuel simulé',
    question:
        'Depuis l’évolution du texte, un acte sexuel simulé imposé à la vue d’autrui :',
    options: [
      'Peut constituer une exhibition sexuelle même sans nudité visible',
      'Ne peut jamais être réprimé',
      'Relève uniquement de l’injure',
    ],
    answer: 'Peut constituer une exhibition sexuelle même sans nudité visible',
    explanation:
        'Le cours indique que l’acte sexuel explicite réel ou simulé suffit, même sans nudité visible.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ✅ SUITE — AGRESSIONS SEXUELLES / MINEUR / VULNÉRABLE
  // ✅ + EXHIBITION SEXUELLE / PROVOCATION (222-30-2)
  // ✅ 3 NIVEAUX : Facile / Moyenne / Difficile
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle (222-27) — Élément légal',
    question: 'L’article 222-27 du Code pénal :',
    options: [
      'Prévoit et réprime les agressions sexuelles autres que le viol',
      'Définit le viol incestueux',
      'Réprime la non-assistance à personne en péril',
    ],
    answer: 'Prévoit et réprime les agressions sexuelles autres que le viol',
    explanation:
        'Le cours précise que 222-27 réprime les agressions sexuelles autres que le viol.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (hors viol) — Définition',
    question: 'Une agression sexuelle (hors viol) se caractérise par :',
    options: [
      'Un contact physique sans pénétration ni acte bucco-génital',
      'Une pénétration sexuelle',
      'Un acte sans aucune interaction corporelle',
    ],
    answer: 'Un contact physique sans pénétration ni acte bucco-génital',
    explanation:
        'Le cours distingue clairement agressions sexuelles (contact) et viol (pénétration/bucco-génital).',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (hors viol) — Cadavre',
    question: 'Concernant la victime, une agression sexuelle :',
    options: [
      'Ne peut pas être commise sur un cadavre',
      'Peut être commise sur un cadavre si l’auteur est majeur',
      'Devient automatiquement une contravention',
    ],
    answer: 'Ne peut pas être commise sur un cadavre',
    explanation:
        'Le cours indique qu’un mort ne peut consentir et que l’atteinte au cadavre relève d’une incrimination autonome.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (hors viol) — Relations entre personnes',
    question: 'Les faits d’agression sexuelle sont constitués :',
    options: [
      'Quelle que soit la nature des relations, y compris mariage',
      'Uniquement si l’auteur est un inconnu',
      'Uniquement si la victime est mineure',
    ],
    answer: 'Quelle que soit la nature des relations, y compris mariage',
    explanation:
        'Le cours rappelle que la qualification est indifférente aux relations existantes, y compris dans le mariage.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (hors viol) — Surprise',
    question: 'La surprise s’entend :',
    options: [
      'Comme “surprendre le consentement”, pas comme la surprise ressentie',
      'Comme une simple émotion de la victime',
      'Uniquement en présence de témoins',
    ],
    answer:
        'Comme “surprendre le consentement”, pas comme la surprise ressentie',
    explanation:
        'Le cours insiste sur la notion de surprise = surprendre le consentement.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (hors viol) — Exemple (prétexte médical)',
    question:
        'L’utilisation d’un prétexte fallacieux de visite médicale pour commettre une agression sexuelle illustre :',
    options: ['La surprise', 'L’erreur invincible', 'La légitime défense'],
    answer: 'La surprise',
    explanation:
        'Le cours cite une jurisprudence validant la surprise via un prétexte de visite médicale (Cass. crim., 20 juin 2001).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (hors viol) — Contrainte',
    question: 'La contrainte prévue par le Code pénal peut être :',
    options: ['Physique ou morale', 'Uniquement physique', 'Uniquement morale'],
    answer: 'Physique ou morale',
    explanation:
        'Le cours rappelle : la contrainte peut être physique ou morale (222-22-1).',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (hors viol) — ITT',
    question: 'Selon 222-28, l’agression sexuelle est aggravée notamment :',
    options: [
      'Si elle entraîne une ITT supérieure à 8 jours',
      'Si elle a lieu un dimanche',
      'Si la victime est mariée',
    ],
    answer: 'Si elle entraîne une ITT supérieure à 8 jours',
    explanation:
        'Le cours cite l’ITT > 8 jours comme circonstance aggravante (222-28).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (hors viol) — Autorité',
    question: 'L’agression sexuelle est aggravée lorsqu’elle est commise :',
    options: [
      'Par une personne abusant de l’autorité que lui confèrent ses fonctions',
      'Par un voisin sans lien particulier',
      'En présence d’un seul témoin',
    ],
    answer:
        'Par une personne abusant de l’autorité que lui confèrent ses fonctions',
    explanation:
        'Le cours liste l’abus d’autorité fonctionnelle comme circonstance aggravante (222-28).',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (hors viol) — Pluralité',
    question:
        'La circonstance aggravante “plusieurs personnes auteurs ou complices” suppose :',
    options: [
      'La participation de plusieurs personnes agissant en qualité d’auteur ou complice',
      'Un seul auteur mais plusieurs victimes',
      'Un acte commis sur internet uniquement',
    ],
    answer:
        'La participation de plusieurs personnes agissant en qualité d’auteur ou complice',
    explanation:
        'Le cours énumère la pluralité d’auteurs/complices comme aggravation (222-28).',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (hors viol) — Substance',
    question:
        'Administrer une substance à l’insu de la victime pour altérer son discernement :',
    options: [
      'Constitue une circonstance aggravante (222-28)',
      'Exclut l’infraction d’agression sexuelle',
      'Ne peut jamais être retenu',
    ],
    answer: 'Constitue une circonstance aggravante (222-28)',
    explanation:
        'Le cours mentionne expressément cette circonstance aggravante dans 222-28.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (hors viol) — Répression',
    question: 'Les peines de base (222-27) sont :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '15 ans de réclusion',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation:
        'Le cours indique : agression sexuelle simple (222-27) = 5 ans + 75 000 €.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (hors viol) — Répression aggravée',
    question: 'En cas d’aggravation (222-28), les peines passent à :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation: 'Le cours : 222-28 = 7 ans + 100 000 €.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle (hors viol) — Tentative',
    question: 'La tentative d’agression sexuelle :',
    options: [
      'Est prévue et punissable',
      'N’est jamais punissable',
      'N’est punissable que pour les contraventions',
    ],
    answer: 'Est prévue et punissable',
    explanation:
        'Le cours précise : tentative prévue par 222-31 (même si la frontière est difficile).',
    difficulty: 'Facile',
  ),

  // =========================================================
  // ✅ PROVOCATION À COMMETTRE UNE AGRESSION SEXUELLE (222-30-2)
  // =========================================================
  const QuizQuestion(
    category: 'Provocation à agression sexuelle (222-30-2)',
    question: 'La provocation à commettre une agression sexuelle est :',
    options: [
      'Une infraction distincte lorsque le délit n’a été ni commis ni tenté',
      'Toujours une simple complicité',
      'Impossible sans violences',
    ],
    answer:
        'Une infraction distincte lorsque le délit n’a été ni commis ni tenté',
    explanation:
        'Le cours : 222-30-2 incrimine l’instigateur même si l’agression n’est ni commise ni tentée.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Provocation à agression sexuelle (222-30-2)',
    question:
        'La provocation à commettre une agression sexuelle (infraction distincte) est punie de :',
    options: [
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
    ],
    answer: '5 ans d’emprisonnement et 75 000 € d’amende',
    explanation:
        'Le cours indique : provocation = 5 ans + 75 000 € si non suivie d’effet.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Provocation à agression sexuelle (mineur)',
    question:
        'Si l’agression sexuelle devait être commise sur un mineur, les peines de provocation sont :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation:
        'Le cours précise que les peines sont portées à 7 ans et 100 000 € si la cible est un mineur.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Provocation suivie d’effet',
    question:
        'Si la provocation est suivie d’une agression sexuelle (ou tentative) :',
    options: [
      'Les règles de la complicité s’appliquent et l’instigateur encourt les mêmes peines que l’auteur',
      'L’instigateur n’est plus punissable',
      'L’instigateur n’encourt qu’une amende',
    ],
    answer:
        'Les règles de la complicité s’appliquent et l’instigateur encourt les mêmes peines que l’auteur',
    explanation:
        'Le cours indique : si suivi d’effet, on bascule sur la complicité (peines de l’auteur).',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // ✅ MINEUR -15 (222-29-1) — PEINES
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle sur mineur -15 (222-29-1)',
    question: 'Les peines prévues pour 222-29-1 sont :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation:
        'Le cours : agressions sexuelles imposées à un mineur de 15 ans (222-29-1) = 10 ans + 150 000 €.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // ✅ PERSONNE VULNÉRABLE (222-29 / 222-30) — PEINES
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle sur personne vulnérable (222-29)',
    question: 'Les peines de base pour 222-29 sont :',
    options: [
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '10 ans d’emprisonnement et 150 000 € d’amende',
    ],
    answer: '7 ans d’emprisonnement et 100 000 € d’amende',
    explanation:
        'Le cours : agression sexuelle sur personne vulnérable (222-29) = 7 ans + 100 000 €.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle vulnérable aggravée (222-30)',
    question: 'En cas d’aggravation (222-30), les peines deviennent :',
    options: [
      '10 ans d’emprisonnement et 150 000 € d’amende',
      '7 ans d’emprisonnement et 100 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '10 ans d’emprisonnement et 150 000 € d’amende',
    explanation: 'Le cours : aggravée (222-30) = 10 ans + 150 000 €.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // ✅ EXHIBITION SEXUELLE (222-32) — PEINES + MINEUR
  // =========================================================
  const QuizQuestion(
    category: 'Exhibition sexuelle — Peines',
    question: 'L’exhibition sexuelle (222-32) est punie de :',
    options: [
      '1 an d’emprisonnement et 15 000 € d’amende',
      '5 ans d’emprisonnement et 75 000 € d’amende',
      '2 ans d’emprisonnement et 30 000 € d’amende',
    ],
    answer: '1 an d’emprisonnement et 15 000 € d’amende',
    explanation: 'Le cours : exhibition sexuelle simple = 1 an + 15 000 €.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Aggravation',
    question: 'L’exhibition sexuelle est aggravée lorsqu’elle est commise :',
    options: [
      'Au préjudice d’un mineur de 15 ans',
      'Dans un lieu privé',
      'Sans témoin',
    ],
    answer: 'Au préjudice d’un mineur de 15 ans',
    explanation:
        'Le cours mentionne l’aggravation (222-32 al.3) si la victime est un mineur de 15 ans.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 🔴 AGRESSIONS SEXUELLES — DISTINCTIONS FINES
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle — Distinction viol',
    question:
        'Quel élément permet de distinguer une agression sexuelle d’un viol ?',
    options: [
      'L’absence de pénétration ou d’acte bucco-génital',
      'Le lien entre l’auteur et la victime',
      'Le sexe de la victime',
    ],
    answer: 'L’absence de pénétration ou d’acte bucco-génital',
    explanation:
        'Le viol suppose un acte de pénétration ou bucco-génital, contrairement à l’agression sexuelle.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Contact physique',
    question: 'Une agression sexuelle suppose nécessairement :',
    options: [
      'Un contact physique entre l’auteur et la victime',
      'Un acte commis en public',
      'Une pluralité d’auteurs',
    ],
    answer: 'Un contact physique entre l’auteur et la victime',
    explanation:
        'Sans contact physique, il n’y a pas agression sexuelle mais éventuellement une autre infraction.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Exhibition',
    question:
        'Un auteur qui se masturbe devant des témoins sans contact physique commet :',
    options: ['Une exhibition sexuelle', 'Une agression sexuelle', 'Un viol'],
    answer: 'Une exhibition sexuelle',
    explanation:
        'L’exhibition sexuelle suppose un acte impudique sans contact avec autrui.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Consentement',
    question:
        'Le consentement de la victime exclut-il toujours l’agression sexuelle ?',
    options: [
      'Oui, sauf lorsque la loi considère la victime incapable de consentir',
      'Oui, sans exception',
      'Non, jamais',
    ],
    answer:
        'Oui, sauf lorsque la loi considère la victime incapable de consentir',
    explanation:
        'Les mineurs de 15 ans ou certaines personnes vulnérables sont juridiquement inaptes à consentir.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 🔴 AGRESSIONS SEXUELLES — SUR MINEUR DE 15 ANS
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle — Mineur de 15 ans',
    question:
        'Pour une agression sexuelle sur un mineur de 15 ans, il faut démontrer :',
    options: [
      'Violence, contrainte, menace ou surprise',
      'Un simple contact sexuel',
      'Une différence d’âge d’au moins 5 ans',
    ],
    answer: 'Violence, contrainte, menace ou surprise',
    explanation:
        'L’article 222-29-1 vise les agressions sexuelles imposées avec VCMS.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Mineur',
    question: 'Concernant l’âge du mineur, l’appréciation se fait :',
    options: [
      'Au moment des faits',
      'Au moment du jugement',
      'Au moment du dépôt de plainte',
    ],
    answer: 'Au moment des faits',
    explanation:
        'La jurisprudence constante retient l’âge au moment des faits.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Mineur',
    question: 'L’erreur sur l’âge du mineur :',
    options: [
      'N’atténue pas automatiquement la responsabilité pénale',
      'Exonère toujours l’auteur',
      'Transforme l’infraction en contravention',
    ],
    answer: 'N’atténue pas automatiquement la responsabilité pénale',
    explanation:
        'L’auteur doit prouver qu’il a été légitimement trompé sur l’âge.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 🔴 AGRESSIONS SEXUELLES — PERSONNE VULNÉRABLE
  // =========================================================
  const QuizQuestion(
    category: 'Agression sexuelle — Vulnérabilité',
    question: 'La vulnérabilité retenue par l’article 222-29 doit être :',
    options: [
      'Apparente ou connue de l’auteur',
      'Créée par l’agression',
      'Présumée automatiquement',
    ],
    answer: 'Apparente ou connue de l’auteur',
    explanation: 'La vulnérabilité doit préexister et être connue ou visible.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Vulnérabilité',
    question:
        'Le seul âge avancé de la victime suffit-il à caractériser la vulnérabilité ?',
    options: [
      'Non, une vulnérabilité particulière doit être démontrée',
      'Oui, toujours',
      'Uniquement au-delà de 80 ans',
    ],
    answer: 'Non, une vulnérabilité particulière doit être démontrée',
    explanation:
        'La jurisprudence refuse une automaticité fondée sur l’âge seul.',
    difficulty: 'Difficile',
  ),

  const QuizQuestion(
    category: 'Agression sexuelle — Précarité',
    question: 'La précarité économique ou sociale peut caractériser :',
    options: [
      'Une vulnérabilité pénale',
      'Une excuse légale',
      'Une cause d’irresponsabilité',
    ],
    answer: 'Une vulnérabilité pénale',
    explanation:
        'La précarité peut placer la victime dans une situation de dépendance.',
    difficulty: 'Moyenne',
  ),

  // =========================================================
  // 🔴 EXHIBITION SEXUELLE — CONDITIONS
  // =========================================================
  const QuizQuestion(
    category: 'Exhibition sexuelle — Élément matériel',
    question: 'L’exhibition sexuelle suppose :',
    options: [
      'Un acte sexuel imposé à la vue d’autrui',
      'Un contact corporel',
      'Une relation sexuelle',
    ],
    answer: 'Un acte sexuel imposé à la vue d’autrui',
    explanation:
        'Il n’y a pas de contact requis en matière d’exhibition sexuelle.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Lieu',
    question: 'L’exhibition sexuelle peut être constituée dans :',
    options: [
      'Un lieu privé visible depuis l’espace public',
      'Uniquement un lieu public',
      'Uniquement un lieu clos',
    ],
    answer: 'Un lieu privé visible depuis l’espace public',
    explanation: 'Le texte vise les lieux accessibles aux regards du public.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Publicité',
    question: 'L’infraction est constituée même si :',
    options: [
      'Aucun témoin n’a effectivement vu l’acte',
      'La victime est consentante',
      'L’acte est discret',
    ],
    answer: 'Aucun témoin n’a effectivement vu l’acte',
    explanation:
        'Il suffit que l’acte puisse être vu, la publicité est potentielle.',
    difficulty: 'Difficile',
  ),

  // =========================================================
  // 🔴 EXHIBITION SEXUELLE — INTENTION
  // =========================================================
  const QuizQuestion(
    category: 'Exhibition sexuelle — Élément moral',
    question: 'L’auteur doit avoir conscience :',
    options: [
      'Du caractère impudique de l’acte',
      'D’être filmé',
      'De choquer une personne précise',
    ],
    answer: 'Du caractère impudique de l’acte',
    explanation:
        'L’intention coupable repose sur la conscience de l’impudicité.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Tentative',
    question: 'La tentative d’exhibition sexuelle est :',
    options: [
      'Non punissable',
      'Punissable comme le délit consommé',
      'Une contravention',
    ],
    answer: 'Non punissable',
    explanation: 'Le texte ne prévoit pas la tentative pour cette infraction.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Complicité',
    question: 'La complicité d’exhibition sexuelle est :',
    options: [
      'Punissable',
      'Exclue par principe',
      'Limitée à l’auteur principal',
    ],
    answer: 'Punissable',
    explanation:
        'La complicité est possible conformément aux articles 121-6 et 121-7.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Peines aggravées',
    question:
        'L’exhibition sexuelle aggravée (mineur de 15 ans) est punie de :',
    options: [
      '2 ans d’emprisonnement et 30 000 € d’amende',
      '1 an d’emprisonnement et 15 000 € d’amende',
      '3 ans d’emprisonnement et 45 000 € d’amende',
    ],
    answer: '2 ans d’emprisonnement et 30 000 € d’amende',
    explanation: 'Le cours : aggravée = 2 ans + 30 000 €.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Complicité',
    question: 'La complicité d’exhibition sexuelle est :',
    options: [
      'Punissable',
      'Impossible',
      'Punissable uniquement si la victime est majeure',
    ],
    answer: 'Punissable',
    explanation: 'Le cours précise : “COMPLICITÉ : OUI”.',
    difficulty: 'Facile',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Complicité',
    question: 'La complicité d’exhibition sexuelle est :',
    options: ['Punissable', 'Impossible', 'Une contravention'],
    answer: 'Punissable',
    explanation: 'Application des articles 121-6 et 121-7 du Code pénal.',
    difficulty: 'Moyenne',
  ),

  const QuizQuestion(
    category: 'Exhibition sexuelle — Complicité',
    question: 'La complicité d’exhibition sexuelle est :',
    options: [
      'Oui (121-6 et 121-7)',
      'Non',
      'Seulement si l’auteur est mineur',
    ],
    answer: 'Oui (121-6 et 121-7)',
    explanation: 'Le cours : complicité punissable selon les règles générales.',
    difficulty: 'Moyenne',
  ),
];

// ============================================================================
// PAGE
// ============================================================================
class QuizViolIncestePA extends StatefulWidget {
  static const String grade = 'pa';
  static const String routeName =
      '/pa/crimes_personne/quiz/viol_inceste_agressions';
  final String uid;
  final String email;

  const QuizViolIncestePA({super.key, required this.uid, required this.email});

  @override
  State<QuizViolIncestePA> createState() => _QuizViolIncestePAState();
}

class _QuizViolIncestePAState extends State<QuizViolIncestePA>
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
  static const _introHiddenKey = 'intro_pa_viol_inceste_agressions';
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
        ? questionVioletIncesteetAgression
        : questionVioletIncesteetAgression
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
            'quiz_name': 'Viol & Inceste',
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
      await _sb.from('quiz_viol_inceste_agressions').insert({
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
      debugPrint('❌ quiz_viol_inceste_agressions insert failed: $e');
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
      'source_file': 'pa_quiz_viol_inceste_agressions',
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
                            icon: Icons.health_and_safety_rounded,
                            title: 'Viols et agressions sexuelles',
                            description: 'Approfondis les infractions sexuelles : viol, agression sexuelle, inceste, circonstances aggravantes et procédures adaptées.',
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
