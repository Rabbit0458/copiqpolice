import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class FormationInitialePage extends StatelessWidget {
  const FormationInitialePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/institution_valeurs_pages/formation_initiale/formation_initiale_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
