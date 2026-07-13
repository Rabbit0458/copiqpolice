// lib/pa/dps_dpg/cadres_juridiques/commission_rogatoire_contenu_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPersonneBlesseGrievementContenuPage extends StatelessWidget {
  const PaPersonneBlesseGrievementContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/personne_blesse_contenu';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return const Scaffold();
  }
}
