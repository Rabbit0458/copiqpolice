// lib/gpx_scolarite_pages/cadres_juridiques/entraide_judiciaire_contenu_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EurojustPage extends StatelessWidget {
  const EurojustPage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/entraide_judiciaire/eurojust';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return const Scaffold();
  }
}
