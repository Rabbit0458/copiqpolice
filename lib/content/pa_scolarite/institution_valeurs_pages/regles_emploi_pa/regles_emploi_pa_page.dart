import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaReglesEmploiPaPage extends StatelessWidget {
  const PaReglesEmploiPaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/institution_valeurs_pages/regles_emploi_pa/regles_emploi_pa_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
