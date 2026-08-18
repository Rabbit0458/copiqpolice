import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaIndicateursBasculementPage extends StatelessWidget {
  const PaIndicateursBasculementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/policier_intervention_pages/indicateurs_basculement/indicateurs_basculement_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
