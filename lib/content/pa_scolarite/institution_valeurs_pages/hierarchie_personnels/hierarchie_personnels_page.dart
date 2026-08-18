import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class HierarchiePersonnelsPage extends StatelessWidget {
  const HierarchiePersonnelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/institution_valeurs_pages/hierarchie_personnels/hierarchie_personnels_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
