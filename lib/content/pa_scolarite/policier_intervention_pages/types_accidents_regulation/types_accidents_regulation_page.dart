import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class TypesAccidentsRegulationPage extends StatelessWidget {
  const TypesAccidentsRegulationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/policier_intervention_pages/types_accidents_regulation/types_accidents_regulation_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
