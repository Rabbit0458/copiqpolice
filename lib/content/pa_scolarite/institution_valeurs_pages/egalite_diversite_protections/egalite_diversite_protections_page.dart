import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class EgaliteDiversiteProtectionsPage extends StatelessWidget {
  const EgaliteDiversiteProtectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/institution_valeurs_pages/egalite_diversite_protections/egalite_diversite_protections_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
