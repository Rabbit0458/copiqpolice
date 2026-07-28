// COP'IQ — Tests psychotechniques PA (Policier Adjoint).
// Hub principal + pages d'agrégation (raisonnement, observation, QCM,
// exercices). Module 100 % indépendant du module GPX : routes PA,
// classes PA, tracking PA.
//
// Positionnement pédagogique PA : ces tests sont un outil de préparation
// et d'entraînement. Aucun score n'est présenté comme une note officielle.

import 'package:flutter/material.dart';

import 'pa_psycho_brand.dart';

// ======================================================================
//                            ROUTES PA
// ======================================================================

class PaTestsPsyRoutes {
  // Routes publiques déclarées dans la catégorie PA.
  static const home = '/pa_exam/concours/tests_psychotechniques';
  static const analyse = '/pa_exam/concours/tests_psy/analyse';
  static const aptitudeVerbale = '/pa_exam/concours/tests_psy/aptitude_verbale';
  static const raisonnementLogique =
      '/pa_exam/concours/tests_psy/raisonnement_logique';
  static const observationAttention =
      '/pa_exam/concours/tests_psy/observation_attention';
  static const personnalite = '/pa_exam/concours/tests_psy/personnalite';
  static const entrainementsQcm =
      '/pa_exam/concours/tests_psy/entrainements_qcm';
  static const entrainementsExercices =
      '/pa_exam/concours/tests_psy/entrainements_exercices';
  static const entrainementsCorriges =
      '/pa_exam/concours/tests_psy/entrainements_corriges';

  // Routes internes des exercices PA (copies indépendantes du contenu GPX).
  static const exAttentionVisuelle =
      '/pa_exam/concours/tests_psychotechniques/attention_visuelle';
  static const exSuitesLogiques =
      '/pa_exam/concours/tests_psychotechniques/suites_logiques';
  static const exCalcul =
      '/pa_exam/concours/tests_psychotechniques/calcul_rapide';
  static const exConcentration =
      '/pa_exam/concours/tests_psychotechniques/attention_concentration';
  static const exLogiqueVerbale =
      '/pa_exam/concours/tests_psychotechniques/logique_verbale';
  static const exRaisonnement =
      '/pa_exam/concours/tests_psychotechniques/raisonnement_logique';
}

// ======================================================================
//                        CATALOGUE DES EXERCICES
// ======================================================================

class PaPsyExercise {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String route;
  const PaPsyExercise({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });
}

const List<PaPsyExercise> paPsyExercises = [
  PaPsyExercise(
    title: 'Attention visuelle',
    description:
        'Comparer deux textes et repérer s’ils sont strictement identiques.',
    icon: Icons.visibility_rounded,
    color: PaPsychoBrand.cAttention,
    route: PaTestsPsyRoutes.exAttentionVisuelle,
  ),
  PaPsyExercise(
    title: 'Suites logiques',
    description:
        'Trouver le terme manquant d’une suite numérique ou alphabétique.',
    icon: Icons.timeline_rounded,
    color: PaPsychoBrand.cSuiteLogique,
    route: PaTestsPsyRoutes.exSuitesLogiques,
  ),
  PaPsyExercise(
    title: 'Calcul mental',
    description: 'Opérations simples à résoudre rapidement de tête.',
    icon: Icons.calculate_rounded,
    color: PaPsychoBrand.cCalcul,
    route: PaTestsPsyRoutes.exCalcul,
  ),
  PaPsyExercise(
    title: 'Concentration',
    description: 'Comptages, repérages et suites de symboles.',
    icon: Icons.center_focus_strong_rounded,
    color: PaPsychoBrand.cConcentration,
    route: PaTestsPsyRoutes.exConcentration,
  ),
  PaPsyExercise(
    title: 'Logique verbale',
    description: 'Synonymes, antonymes, intrus, analogies.',
    icon: Icons.menu_book_rounded,
    color: PaPsychoBrand.cVerbal,
    route: PaTestsPsyRoutes.exLogiqueVerbale,
  ),
  PaPsyExercise(
    title: 'Raisonnement logique',
    description: 'Déductions, classements, syllogismes.',
    icon: Icons.psychology_alt_rounded,
    color: PaPsychoBrand.cRaisonnement,
    route: PaTestsPsyRoutes.exRaisonnement,
  ),
];

// ======================================================================
//                    WIDGETS PARTAGÉS DU MODULE PA
// ======================================================================

/// Apparition douce (fondu + légère translation), staggered par index.
/// Respecte MediaQuery.disableAnimations.
class PaPsyReveal extends StatelessWidget {
  final int index;
  final Widget child;
  const PaPsyReveal({super.key, required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return child;
    final delayMs = (60 * index).clamp(0, 420);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 320 + delayMs),
      curve: Curves.easeOutCubic,
      builder: (context, t, c) {
        final local = ((t * (320 + delayMs) - delayMs) / 320).clamp(0.0, 1.0);
        return Opacity(
          opacity: local,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - local)),
            child: c,
          ),
        );
      },
      child: child,
    );
  }
}

class PaPsyTile extends StatelessWidget {
  final PaPsyExercise info;
  const PaPsyTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.pushNamed(context, info.route),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: PaPsychoBrand.card(context),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: PaPsychoBrand.tinted(
                  context,
                  color: info.color,
                  radius: 14,
                ),
                child: Icon(info.icon, color: info.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(info.title, style: PaPsychoBrand.h3(context)),
                    const SizedBox(height: 2),
                    Text(
                      info.description,
                      style: PaPsychoBrand.small(context).copyWith(
                        fontWeight: FontWeight.w500,
                        color: PaPsychoBrand.textMuted(context),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: PaPsychoBrand.textMuted(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaPsyScaffold extends StatelessWidget {
  final String badge;
  final String title;
  final String subtitle;
  final IconData headerIcon;
  final Color headerColor;
  final List<Widget> children;
  const PaPsyScaffold({
    super.key,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.headerIcon,
    required this.headerColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PaPsychoBrand.bg(context),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: PaPsychoBrand.text(context),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: PaPsychoBrand.tinted(
                          context,
                          color: headerColor,
                          radius: 999,
                          alpha: .14,
                        ),
                        child: Text(
                          badge,
                          style: PaPsychoBrand.small(
                            context,
                          ).copyWith(color: headerColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  PaPsyReveal(
                    index: 0,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: PaPsychoBrand.tinted(
                        context,
                        color: headerColor,
                        radius: 22,
                      ),
                      child: Icon(headerIcon, color: headerColor, size: 30),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PaPsyReveal(
                    index: 1,
                    child: Text(title, style: PaPsychoBrand.h1(context)),
                  ),
                  const SizedBox(height: 8),
                  PaPsyReveal(
                    index: 2,
                    child: Text(
                      subtitle,
                      style: PaPsychoBrand.body(
                        context,
                      ).copyWith(color: PaPsychoBrand.textMuted(context)),
                    ),
                  ),
                  const SizedBox(height: 22),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PaPsyInfoBlock extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String text;
  const PaPsyInfoBlock({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: PaPsychoBrand.card(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: PaPsychoBrand.tinted(
                    context,
                    color: color,
                    radius: 10,
                    alpha: .15,
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(title, style: PaPsychoBrand.h3(context))),
              ],
            ),
            const SizedBox(height: 10),
            Text(text, style: PaPsychoBrand.body(context)),
          ],
        ),
      ),
    );
  }
}

// ======================================================================
//                       PAGE PRINCIPALE DU MODULE
// ======================================================================

class PaTestsPsyHomePage extends StatelessWidget {
  static const String routeName = PaTestsPsyRoutes.home;
  const PaTestsPsyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Tuiles utilitaires compactes (méthode, personnalité, historique).
    const sections = [
      PaPsyExercise(
        title: 'Analyse de l’épreuve',
        description: 'Comprendre les tests et ce qu’ils évaluent.',
        icon: Icons.insights_rounded,
        color: PaPsychoBrand.accent,
        route: PaTestsPsyRoutes.analyse,
      ),
      PaPsyExercise(
        title: 'Personnalité & comportements',
        description: 'Repères pour aborder les questionnaires sereinement.',
        icon: Icons.self_improvement_rounded,
        color: PaPsychoBrand.cPersonnalite,
        route: PaTestsPsyRoutes.personnalite,
      ),
      PaPsyExercise(
        title: 'Mes corrigés & historique',
        description: 'Résultats de tes sessions d’entraînement PA.',
        icon: Icons.history_rounded,
        color: PaPsychoBrand.cHistorique,
        route: PaTestsPsyRoutes.entrainementsCorriges,
      ),
    ];

    return PaPsyScaffold(
      badge: 'Logique & profil',
      title: 'Tests psychotechniques',
      subtitle:
          'Un entraînement complet pour développer ta logique, ta '
          'concentration et ta vitesse de raisonnement avant la sélection '
          'de Policier Adjoint. Les scores affichés sont des indicateurs '
          'd’entraînement COP’IQ, pas des notes officielles.',
      headerIcon: Icons.psychology_rounded,
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
          index: 6,
          child: Text('Les exercices', style: PaPsychoBrand.h2(context)),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < paPsyExercises.length; i++)
          PaPsyReveal(
            index: 7 + i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PaPsyTile(info: paPsyExercises[i]),
            ),
          ),
      ],
    );
  }
}

// ======================================================================
//                     PAGES D'AGRÉGATION PA
// ======================================================================

class PaTestsPsyRaisonnementHubPage extends StatelessWidget {
  static const String routeName = PaTestsPsyRoutes.raisonnementLogique;
  const PaTestsPsyRaisonnementHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = paPsyExercises
        .where(
          (e) =>
              e.route == PaTestsPsyRoutes.exSuitesLogiques ||
              e.route == PaTestsPsyRoutes.exCalcul ||
              e.route == PaTestsPsyRoutes.exRaisonnement,
        )
        .toList();
    return PaPsyScaffold(
      badge: 'Raisonnement logique',
      title: 'Raisonnement logique',
      subtitle:
          'Suites, déductions et calcul : les exercices qui musclent ta '
          'logique pour les tests de sélection.',
      headerIcon: Icons.psychology_alt_rounded,
      headerColor: PaPsychoBrand.cRaisonnement,
      children: [
        for (var i = 0; i < items.length; i++)
          PaPsyReveal(
            index: 3 + i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PaPsyTile(info: items[i]),
            ),
          ),
      ],
    );
  }
}

class PaTestsPsyObservationHubPage extends StatelessWidget {
  static const String routeName = PaTestsPsyRoutes.observationAttention;
  const PaTestsPsyObservationHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = paPsyExercises
        .where(
          (e) =>
              e.route == PaTestsPsyRoutes.exAttentionVisuelle ||
              e.route == PaTestsPsyRoutes.exConcentration,
        )
        .toList();
    return PaPsyScaffold(
      badge: 'Observation & attention',
      title: 'Observation & attention',
      subtitle:
          'Des exercices courts et chronométrés pour entraîner ton œil et '
          'ta capacité à rester concentré dans la durée.',
      headerIcon: Icons.visibility_rounded,
      headerColor: PaPsychoBrand.cAttention,
      children: [
        for (var i = 0; i < items.length; i++)
          PaPsyReveal(
            index: 3 + i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PaPsyTile(info: items[i]),
            ),
          ),
      ],
    );
  }
}

class PaTestsPsyQcmHubPage extends StatelessWidget {
  static const String routeName = PaTestsPsyRoutes.entrainementsQcm;
  const PaTestsPsyQcmHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = paPsyExercises
        .where(
          (e) =>
              e.route == PaTestsPsyRoutes.exCalcul ||
              e.route == PaTestsPsyRoutes.exConcentration ||
              e.route == PaTestsPsyRoutes.exLogiqueVerbale ||
              e.route == PaTestsPsyRoutes.exRaisonnement,
        )
        .toList();
    return PaPsyScaffold(
      badge: 'Entraînements — QCM',
      title: 'QCM chronométrés',
      subtitle:
          'Des questionnaires à choix multiples avec correction immédiate. '
          'Ton score est un indicateur d’entraînement, pas une note '
          'officielle.',
      headerIcon: Icons.quiz_rounded,
      headerColor: PaPsychoBrand.cCalcul,
      children: [
        for (var i = 0; i < items.length; i++)
          PaPsyReveal(
            index: 3 + i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PaPsyTile(info: items[i]),
            ),
          ),
      ],
    );
  }
}

class PaTestsPsyExercicesHubPage extends StatelessWidget {
  static const String routeName = PaTestsPsyRoutes.entrainementsExercices;
  const PaTestsPsyExercicesHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PaPsyScaffold(
      badge: 'Entraînements — Exercices',
      title: 'Exercices par compétence',
      subtitle:
          'Choisis une compétence et enchaîne les séries. La régularité '
          'compte plus que la durée : 10 minutes par jour suffisent.',
      headerIcon: Icons.fitness_center_rounded,
      headerColor: PaPsychoBrand.cSuiteLogique,
      children: [
        for (var i = 0; i < paPsyExercises.length; i++)
          PaPsyReveal(
            index: 3 + i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PaPsyTile(info: paPsyExercises[i]),
            ),
          ),
      ],
    );
  }
}
