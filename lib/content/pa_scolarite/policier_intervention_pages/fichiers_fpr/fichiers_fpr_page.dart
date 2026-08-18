import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class FichiersFprPage extends StatelessWidget {
  const FichiersFprPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/policier_intervention_pages/fichiers_fpr/fichiers_fpr_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
