import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PrimoIntervenantSceneInfractionPage extends StatelessWidget {
  const PrimoIntervenantSceneInfractionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/policier_intervention_pages/primo_intervenant_scene_infraction/primo_intervenant_scene_infraction_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
