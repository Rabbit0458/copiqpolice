// lib/gpx_scolarite_pages/cadres_juridiques/commission_rogatoire_contenu_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonneBlesseGrievementContenuPage extends StatelessWidget {
  const PersonneBlesseGrievementContenuPage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/personne_blesse_contenu';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return const Scaffold();
  }
}
