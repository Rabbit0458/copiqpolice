// COP'IQ — Page "Comprendre l'épreuve" pour les tests psychotechniques.
// Présentation pédagogique premium des tests, conseils, et raccourci de démarrage.

import 'package:flutter/material.dart';

import '../widgets/psycho_brand.dart';
import 'calcul_mental_page.dart';
import 'concentration_page.dart';
import 'logique_verbale_page.dart';
import 'raisonnement_logique_page.dart';
import 'raisonnement_spatial_page.dart';
import 'rotations_symetries_page.dart';

class ComprendreEpreuvePsychoPage extends StatelessWidget {
  static const String routeName =
      '/gpx_exam/concours/tests_psychotechniques/comprendre_epreuve';

  const ComprendreEpreuvePsychoPage({super.key});

  static const _exercises = [
    _ExerciseInfo(
      title: 'Attention visuelle',
      description:
          'Comparer deux textes pour repérer s’ils sont strictement identiques.',
      icon: Icons.visibility_rounded,
      color: PsychoBrand.cAttention,
      route: '/gpx_exam/concours/tests_psychotechniques/attention_visuelle',
    ),
    _ExerciseInfo(
      title: 'Suites logiques',
      description:
          'Trouver le terme manquant d’une suite numérique ou alphabétique.',
      icon: Icons.timeline_rounded,
      color: PsychoBrand.cSuiteLogique,
      route: '/gpx_exam/concours/tests_psychotechniques/suites_logiques',
    ),
    _ExerciseInfo(
      title: 'Calcul mental',
      description: 'Opérations simples à résoudre rapidement de tête.',
      icon: Icons.calculate_rounded,
      color: PsychoBrand.cCalcul,
      route: CalculMentalPage.routeName,
    ),
    _ExerciseInfo(
      title: 'Logique verbale',
      description: 'Synonymes, antonymes, intrus, analogies.',
      icon: Icons.menu_book_rounded,
      color: PsychoBrand.cVerbal,
      route: LogiqueVerbalePage.routeName,
    ),
    _ExerciseInfo(
      title: 'Raisonnement logique',
      description: 'Déductions, classements, syllogismes.',
      icon: Icons.psychology_alt_rounded,
      color: PsychoBrand.cRaisonnement,
      route: RaisonnementLogiquePage.routeName,
    ),
    _ExerciseInfo(
      title: 'Raisonnement spatial',
      description: 'Visualisation 3D, pliages, vues de solides.',
      icon: Icons.view_in_ar_rounded,
      color: PsychoBrand.cSpatial,
      route: RaisonnementSpatialPage.routeName,
    ),
    _ExerciseInfo(
      title: 'Rotations & symétries',
      description: 'Transformations géométriques de figures.',
      icon: Icons.auto_awesome_motion_rounded,
      color: PsychoBrand.cRotation,
      route: RotationsSymetriesPage.routeName,
    ),
    _ExerciseInfo(
      title: 'Concentration',
      description: 'Comptages, repérages, suites de symboles.',
      icon: Icons.center_focus_strong_rounded,
      color: PsychoBrand.cConcentration,
      route: ConcentrationPage.routeName,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PsychoBrand.bg(context),
      body: SafeArea(
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
                      color: PsychoBrand.text(context),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: PsychoBrand.tinted(
                      context,
                      color: PsychoBrand.accent,
                      radius: 999,
                      alpha: .14,
                    ),
                    child: Text(
                      'Comprendre l’épreuve',
                      style: PsychoBrand.small(context).copyWith(
                        color: PsychoBrand.accent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: 64,
                height: 64,
                decoration: PsychoBrand.tinted(
                  context,
                  color: PsychoBrand.accent,
                  radius: 22,
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  color: PsychoBrand.accent,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text('Tests psychotechniques', style: PsychoBrand.h1(context)),
              const SizedBox(height: 8),
              Text(
                'Une série d’épreuves chronométrées pour évaluer ta logique, '
                'ta concentration et ta vitesse de raisonnement.',
                style: PsychoBrand.body(context).copyWith(
                  color: PsychoBrand.textMuted(context),
                ),
              ),
              const SizedBox(height: 22),
              const _Block(
                title: 'Pourquoi cette épreuve ?',
                icon: Icons.flag_rounded,
                color: PsychoBrand.accent,
                child:
                    'Les tests psychotechniques évaluent les aptitudes utiles '
                    'au métier de gardien de la paix : prise de décision rapide, '
                    'attention soutenue, capacité de mémorisation, raisonnement '
                    'logique. Ils sont éliminatoires : un score trop bas peut '
                    'compromettre l’admissibilité.',
              ),
              const _Block(
                title: 'Compétences évaluées',
                icon: Icons.checklist_rounded,
                color: PsychoBrand.cSuiteLogique,
                child:
                    '• Logique numérique et verbale\n'
                    '• Concentration et attention visuelle\n'
                    '• Raisonnement spatial et géométrique\n'
                    '• Mémoire de travail\n'
                    '• Vitesse et précision sous contrainte de temps',
              ),
              const _Block(
                title: 'Conseils pour réussir',
                icon: Icons.tips_and_updates_outlined,
                color: PsychoBrand.warn,
                child:
                    '• Entraîne-toi régulièrement, même 10 min par jour.\n'
                    '• Ne reste pas bloqué sur une question : passe et reviens.\n'
                    '• Lis chaque énoncé deux fois en cas de doute.\n'
                    '• Travaille les opérations mentales sans calculatrice.\n'
                    '• Apprends à respirer avant de répondre.',
              ),
              const SizedBox(height: 12),
              Text('Les exercices', style: PsychoBrand.h2(context)),
              const SizedBox(height: 12),
              ..._exercises.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ExerciseTile(info: e),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    '/gpx_exam/concours/tests_psychotechniques/mode_concours',
                  ),
                  icon: const Icon(Icons.bolt_rounded),
                  label: const Text('Commencer en mode concours'),
                  style: FilledButton.styleFrom(
                    backgroundColor: PsychoBrand.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
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

class _ExerciseInfo {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String route;
  const _ExerciseInfo({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class _ExerciseTile extends StatelessWidget {
  final _ExerciseInfo info;
  const _ExerciseTile({required this.info});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.pushNamed(context, info.route),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: PsychoBrand.card(context),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: PsychoBrand.tinted(
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
                    Text(info.title, style: PsychoBrand.h3(context)),
                    const SizedBox(height: 2),
                    Text(
                      info.description,
                      style: PsychoBrand.small(context).copyWith(
                        fontWeight: FontWeight.w500,
                        color: PsychoBrand.textMuted(context),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: PsychoBrand.textMuted(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String child;
  const _Block({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: PsychoBrand.card(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: PsychoBrand.tinted(
                    context,
                    color: color,
                    radius: 10,
                    alpha: .15,
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Text(title, style: PsychoBrand.h3(context)),
              ],
            ),
            const SizedBox(height: 10),
            Text(child, style: PsychoBrand.body(context)),
          ],
        ),
      ),
    );
  }
}
