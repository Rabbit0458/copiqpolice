import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ViolencesConjugalesConduitePage extends StatelessWidget {
  const ViolencesConjugalesConduitePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/policier_intervention_pages/violences_conjugales_conduite/violences_conjugales_conduite_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
