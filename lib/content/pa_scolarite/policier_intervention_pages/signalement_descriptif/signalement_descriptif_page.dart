import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaSignalementDescriptifPage extends StatelessWidget {
  const PaSignalementDescriptifPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/policier_intervention_pages/signalement_descriptif/signalement_descriptif_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
