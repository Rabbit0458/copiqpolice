import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class HorsServiceIntervenirPage extends StatelessWidget {
  const HorsServiceIntervenirPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/institution_valeurs_pages/hors_service_intervenir/hors_service_intervenir_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
