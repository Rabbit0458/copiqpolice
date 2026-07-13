import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MortInconnueIntroPage extends StatelessWidget {
  const MortInconnueIntroPage({super.key});

  static const String routeName = '/gpx/cadres_juridiques/mort_inconnue/intro';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return const Scaffold();
  }
}
