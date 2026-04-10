// lib/reserve/accueil_reserve.dart
// Page Réserve — stub (tu la rempliras plus tard)

import 'package:flutter/material.dart';

class ReserveAccueilPage extends StatelessWidget {
  static const routeName = '/reserve';

  const ReserveAccueilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Réserve')),
      body: Center(
        child: Text(
          'Accueil Réserve — à venir',
          style: th.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
