// lib/content/reserve_scolarite/introduction/reserve_introduction_page.dart
//
// ⚠️ SQUELETTE À CONFIGURER MANUELLEMENT.
//
// Template d'une page de cours Réserve.
//
// Pour créer une nouvelle page Réserve :
//   1. Dupliquer ce fichier dans le sous-dossier approprié.
//   2. Renommer la classe (`ReserveIntroductionPage` -> ta classe).
//   3. Mettre à jour `routeName`.
//   4. Ajouter le contenu pédagogique dans `build()`.
//   5. Enregistrer la route dans `app_router.dart`.
//
// Pour pointer vers un quiz depuis cette page :
//   Navigator.pushNamed(context, '/reserve/<topic>/quiz/<quiz_name>');
//   → Le QuizRouter le route automatiquement vers le bon fichier de quiz
//     (pour l'instant les quiz PA, en attendant les quiz Réserve dédiés).

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReserveIntroductionPage extends StatelessWidget {
  static const String routeName = '/reserve/introduction';

  const ReserveIntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Introduction à la Réserve'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Text(
            'Bienvenue dans l’espace Réserve.',
            style: GoogleFonts.instrumentSans(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Cette page est un squelette à compléter avec le contenu officiel '
            'de la formation Réserve de la Police Nationale.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          const _SectionTitle(text: 'Objectifs de la Réserve'),
          const SizedBox(height: 8),
          Text(
            '• TODO: compléter avec les missions du Réserviste.\n'
            '• TODO: durée et conditions d’engagement.\n'
            '• TODO: statut juridique et obligations.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          const _SectionTitle(text: 'Procédures essentielles'),
          const SizedBox(height: 8),
          Text(
            'TODO: ajouter ici les procédures couvertes par la formation Réserve.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {
              // Le QuizRouter prendra cette route et la réécrira vers la
              // version PA en attendant les quiz Réserve dédiés.
              Navigator.pushNamed(
                context,
                '/reserve/generalites/quiz/introduction',
              );
            },
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Tester mes connaissances'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.instrumentSans(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: Theme.of(context).colorScheme.primary,
      ),
 
    );
  }
}
