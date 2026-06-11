// COP'IQ — États transitoires partagés (loading, empty, error).

import 'package:flutter/material.dart';

import 'psycho_brand.dart';

class PsychoLoadingState extends StatelessWidget {
  final String message;
  const PsychoLoadingState({super.key, this.message = 'Chargement…'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 42,
            height: 42,
            child: CircularProgressIndicator(
              strokeWidth: 2.6,
              valueColor: AlwaysStoppedAnimation(PsychoBrand.accent),
            ),
          ),
          const SizedBox(height: 16),
          Text(message, style: PsychoBrand.small(context)),
        ],
      ),
    );
  }
}

class PsychoEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onRetry;
  final IconData icon;
  const PsychoEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.onRetry,
    this.icon = Icons.inventory_2_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: PsychoBrand.tinted(
                context,
                color: PsychoBrand.accent,
                radius: 24,
              ),
              child: Icon(icon, size: 30, color: PsychoBrand.accent),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: PsychoBrand.h2(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: PsychoBrand.body(
                context,
              ).copyWith(color: PsychoBrand.textMuted(context)),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Réessayer'),
                style: FilledButton.styleFrom(
                  backgroundColor: PsychoBrand.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'InstrumentSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PsychoErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const PsychoErrorState({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return PsychoEmptyState(
      title: 'Une erreur est survenue',
      description: message,
      icon: Icons.error_outline_rounded,
      onRetry: onRetry,
    );

  }
}
