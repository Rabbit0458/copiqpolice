// COP'IQ — Connaissances générales PA (Policier Adjoint).
// Hub principal + fiches de cours + agrégations QCM/exercices.
// Module 100 % indépendant du module GPX : routes PA, classes PA,
// tracking PA (track = 'pa', quiz_name préfixé 'PA - ').
//
// Positionnement pédagogique PA : la culture générale est un avantage
// pédagogique (institutions, vocabulaire, aisance à l'oral). Aucun score
// n'est présenté comme une note officielle, un classement ou un seuil
// d'admissibilité.

import 'package:flutter/material.dart';

import '../psycotechniques/pa_psycho_brand.dart';
import '../psycotechniques/pa_tests_psy_hub_pages.dart'
    show PaPsyExercise, PaPsyInfoBlock, PaPsyReveal, PaPsyScaffold, PaPsyTile;

// ======================================================================
//                            ROUTES PA
// ======================================================================

class PaCgRoutes {
  // Routes publiques déclarées dans la catégorie PA.
  static const home = '/pa_exam/concours/connaissances_generales';
  static const fiches =
      '/pa_exam/concours/connaissances_generales/fiches_de_cours';
  static const entrainementsQcm =
      '/pa_exam/concours/connaissances_generales/entrainements_qcm';
  static const entrainementsExercices =
      '/pa_exam/concours/connaissances_generales/entrainements_exercices';
  static const entrainementsCorriges =
      '/pa_exam/concours/connaissances_generales/entrainements_corriges';

  // Routes internes des QCM PA (copies indépendantes du contenu GPX).
  static const exHistoire =
      '/pa_exam/concours/culture_generale_histoire_france';
  static const exInstitutions =
      '/pa_exam/concours/culture_generale_institutions_europeennes';
  static const exActualite = '/pa_exam/concours/culture_generale_actualite';
  static const exGeographie = '/pa_exam/concours/culture_generale_geographie';
  static const exFrancais = '/pa_exam/concours/culture_generale_francais';
  static const exSport = '/pa_exam/concours/culture_generale_sport';
  static const exSciences = '/pa_exam/concours/culture_generale_sciences';
  static const exSante = '/pa_exam/concours/culture_generale_sante';
  static const exPolice = '/pa_exam/concours/culture_generale_police_securite';
  static const exMythologie = '/pa_exam/concours/culture_generale_mythologie';
  static const exMusique = '/pa_exam/concours/culture_generale_musique';
  static const exCinema = '/pa_exam/concours/culture_generale_cinema';
  static const exDroit = '/pa_exam/concours/culture_generale_droit';
  static const exSecuriteRoutiere =
      '/pa_exam/concours/culture_generale_securite_routiere';
}

// ======================================================================
//                       CATALOGUE DES THÈMES
// ======================================================================

const List<PaPsyExercise> paCgThemes = [
  PaPsyExercise(
    title: 'Histoire de France',
    description: 'Grands repères, dates et personnages clés.',
    icon: Icons.account_balance_rounded,
    color: Color(0xFF8B5CF6),
    route: PaCgRoutes.exHistoire,
  ),
  PaPsyExercise(
    title: 'Institutions européennes',
    description: 'Union européenne, organes et fonctionnement.',
    icon: Icons.flag_rounded,
    color: Color(0xFF3B82F6),
    route: PaCgRoutes.exInstitutions,
  ),
  PaPsyExercise(
    title: 'Actualité',
    description: 'Actualité institutionnelle et générale.',
    icon: Icons.newspaper_rounded,
    color: PaPsychoBrand.accent,
    route: PaCgRoutes.exActualite,
  ),
  PaPsyExercise(
    title: 'Géographie',
    description: 'France, Europe et monde : repères essentiels.',
    icon: Icons.public_rounded,
    color: Color(0xFF14B8A6),
    route: PaCgRoutes.exGeographie,
  ),
  PaPsyExercise(
    title: 'Langue française',
    description: 'Vocabulaire, expressions et bon usage.',
    icon: Icons.translate_rounded,
    color: Color(0xFFEC4899),
    route: PaCgRoutes.exFrancais,
  ),
  PaPsyExercise(
    title: 'Sport & culture générale',
    description: 'Disciplines, compétitions et grands noms.',
    icon: Icons.sports_soccer_rounded,
    color: Color(0xFFEA580C),
    route: PaCgRoutes.exSport,
  ),
  PaPsyExercise(
    title: 'Sciences',
    description: 'Découvertes, inventions et notions clés.',
    icon: Icons.science_rounded,
    color: Color(0xFF06B6D4),
    route: PaCgRoutes.exSciences,
  ),
  PaPsyExercise(
    title: 'Santé',
    description: 'Corps humain, prévention et santé publique.',
    icon: Icons.health_and_safety_rounded,
    color: Color(0xFF22C55E),
    route: PaCgRoutes.exSante,
  ),
  PaPsyExercise(
    title: 'Police & sécurité',
    description: 'Organisation policière et sécurité intérieure.',
    icon: Icons.local_police_rounded,
    color: Color(0xFF1D4ED8),
    route: PaCgRoutes.exPolice,
  ),
  PaPsyExercise(
    title: 'Mythologie & culture générale',
    description: 'Mythes, légendes et références culturelles.',
    icon: Icons.auto_stories_rounded,
    color: Color(0xFFF59E0B),
    route: PaCgRoutes.exMythologie,
  ),
  PaPsyExercise(
    title: 'Musique & culture générale',
    description: 'Genres, œuvres et artistes majeurs.',
    icon: Icons.music_note_rounded,
    color: Color(0xFFDB2777),
    route: PaCgRoutes.exMusique,
  ),
  PaPsyExercise(
    title: 'Cinéma & culture générale',
    description: 'Films, réalisateurs et histoire du cinéma.',
    icon: Icons.movie_rounded,
    color: Color(0xFF0EA5E9),
    route: PaCgRoutes.exCinema,
  ),
  PaPsyExercise(
    title: 'Droit & culture générale',
    description: 'Notions juridiques et justice au quotidien.',
    icon: Icons.gavel_rounded,
    color: Color(0xFF6366F1),
    route: PaCgRoutes.exDroit,
  ),
  PaPsyExercise(
    title: 'Sécurité routière',
    description: 'Code de la route et conduite responsable.',
    icon: Icons.traffic_rounded,
    color: Color(0xFFEF4444),
    route: PaCgRoutes.exSecuriteRoutiere,
  ),
];

// ======================================================================
//                       PAGE PRINCIPALE DU MODULE
// ======================================================================

class PaConnaissancesGeneralesHomePage extends StatelessWidget {
  static const String routeName = PaCgRoutes.home;
  const PaConnaissancesGeneralesHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const sections = [
      PaPsyExercise(
        title: 'Fiches de cours',
        description: 'Comprendre chaque thème avant de s’entraîner.',
        icon: Icons.menu_book_rounded,
        color: PaPsychoBrand.accent,
        route: PaCgRoutes.fiches,
      ),
      PaPsyExercise(
        title: 'Mes corrigés & historique',
        description: 'Résultats de tes QCM de connaissances générales.',
        icon: Icons.history_rounded,
        color: PaPsychoBrand.cHistorique,
        route: PaCgRoutes.entrainementsCorriges,
      ),
    ];

    return PaPsyScaffold(
      badge: 'Institution & culture',
      title: 'Connaissances générales',
      subtitle:
          'Ce module t’aide à renforcer ta compréhension des institutions, '
          'ta culture générale et ton aisance pour la suite de la sélection '
          'de Policier Adjoint. Il s’agit d’un entraînement pédagogique '
          'COP’IQ, sans note officielle.',
      headerIcon: Icons.school_rounded,
      headerColor: PaPsychoBrand.accent,
      children: [
        for (var i = 0; i < sections.length; i++)
          PaPsyReveal(
            index: 3 + i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PaPsyTile(info: sections[i]),
            ),
          ),
        const SizedBox(height: 8),
        PaPsyReveal(
          index: 5,
          child: Text('Les thèmes', style: PaPsychoBrand.h2(context)),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < paCgThemes.length; i++)
          PaPsyReveal(
            index: 6 + i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PaPsyTile(info: paCgThemes[i]),
            ),
          ),
      ],
    );
  }
}

// ======================================================================
//                         FICHES DE COURS
// ======================================================================

class PaCgFichesPage extends StatelessWidget {
  static const String routeName = PaCgRoutes.fiches;
  const PaCgFichesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PaPsyScaffold(
      badge: 'Fiches de cours',
      title: 'Réviser par thème',
      subtitle:
          'Chaque thème se travaille par sessions courtes : lis la '
          'consigne, réponds au QCM et surtout lis les explications des '
          'corrections — c’est là que la culture se construit.',
      headerIcon: Icons.menu_book_rounded,
      headerColor: PaPsychoBrand.accent,
      children: [
        const PaPsyReveal(
          index: 3,
          child: PaPsyInfoBlock(
            title: 'Pourquoi la culture générale ?',
            icon: Icons.lightbulb_rounded,
            color: PaPsychoBrand.warn,
            text:
                'Dans la sélection de Policier Adjoint, la culture générale '
                'n’est pas une épreuve notée : c’est un avantage. Mieux '
                'comprendre les institutions, enrichir ton vocabulaire et '
                'suivre l’actualité te donnent de l’aisance à l’oral et '
                'une meilleure compréhension de l’environnement '
                'professionnel.',
          ),
        ),
        const PaPsyReveal(
          index: 4,
          child: PaPsyInfoBlock(
            title: 'Comment travailler ?',
            icon: Icons.tips_and_updates_outlined,
            color: PaPsychoBrand.good,
            text:
                '• 10 à 15 minutes par jour suffisent.\n'
                '• Alterne les thèmes pour entretenir la mémoire.\n'
                '• Relis toujours les explications, même quand tu as juste.\n'
                '• Note les notions qui reviennent souvent.\n'
                '• Refais les thèmes où ton taux de réussite est bas.',
          ),
        ),
        const SizedBox(height: 6),
        PaPsyReveal(
          index: 5,
          child: Text('Les thèmes', style: PaPsychoBrand.h2(context)),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < paCgThemes.length; i++)
          PaPsyReveal(
            index: 6 + i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PaPsyTile(info: paCgThemes[i]),
            ),
          ),
      ],
    );
  }
}

// ======================================================================
//                     AGRÉGATIONS QCM / EXERCICES
// ======================================================================

class PaCgQcmHubPage extends StatelessWidget {
  static const String routeName = PaCgRoutes.entrainementsQcm;
  const PaCgQcmHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PaPsyScaffold(
      badge: 'Entraînements — QCM',
      title: 'QCM par thème',
      subtitle:
          'Des questionnaires avec correction et explication immédiates. '
          'Ton score est un indicateur d’entraînement COP’IQ, pas une note '
          'officielle.',
      headerIcon: Icons.quiz_rounded,
      headerColor: PaPsychoBrand.cCalcul,
      children: [
        for (var i = 0; i < paCgThemes.length; i++)
          PaPsyReveal(
            index: 3 + i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PaPsyTile(info: paCgThemes[i]),
            ),
          ),
      ],
    );
  }
}

class PaCgExercicesHubPage extends StatelessWidget {
  static const String routeName = PaCgRoutes.entrainementsExercices;
  const PaCgExercicesHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PaPsyScaffold(
      badge: 'Entraînements — Exercices',
      title: 'S’exercer par thème',
      subtitle:
          'Chaque session est un exercice complet : questions variées, '
          'niveaux de difficulté et explications détaillées à chaque '
          'réponse.',
      headerIcon: Icons.fitness_center_rounded,
      headerColor: PaPsychoBrand.cSuiteLogique,
      children: [
        for (var i = 0; i < paCgThemes.length; i++)
          PaPsyReveal(
            index: 3 + i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PaPsyTile(info: paCgThemes[i]),
            ),
          ),
      ],
    );
  }
}
