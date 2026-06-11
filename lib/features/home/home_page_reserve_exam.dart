// lib/features/home/home_page_reserve_exam.dart
//
// ⚠️ SQUELETTE À CONFIGURER MANUELLEMENT.
//
// Home page du parcours Réserve en mode "préparation concours".
// Pour l'instant, le concours de Réserviste passe principalement par les
// modules de scolarité, mais on garde une home dédiée pour pouvoir y intégrer :
//   - Une auto-évaluation / quiz blanc
//   - Les annales et rapports de jury (si applicables)
//   - Les épreuves spécifiques Réserve (entretien, motivation, etc.)
//
// Pour enrichir : voir `home_page_pa_exam.dart` ou `home_page_gpx_exam.dart`
// comme modèles.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/services/user_context_service.dart';

class HomePageReserveExam extends StatefulWidget {
  const HomePageReserveExam({super.key});

  static const String routeName = '/home-reserve-exam';

  @override
  State<HomePageReserveExam> createState() => _HomePageReserveExamState();
}

class _HomePageReserveExamState extends State<HomePageReserveExam> {
  @override
  void initState() {
    super.initState();
    UserContextService.I.setTrack('reserve');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Réserve — Concours'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shield_moon_rounded, size: 72),
              const SizedBox(height: 20),
              Text(
                'Préparation Réserve',
                style: GoogleFonts.instrumentSans(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Cet espace est en cours de construction.\nLes épreuves, annales et quiz blancs Réserve arrivent bientôt.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: .7),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () =>
                    Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home-bootstrap',
                  (_) => false,
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Choisir un autre parcours'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
