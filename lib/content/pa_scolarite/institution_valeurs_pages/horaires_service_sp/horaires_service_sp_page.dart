import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaHorairesServiceSpPage extends StatelessWidget {
  const PaHorairesServiceSpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/institution_valeurs_pages/horaires_service_sp/horaires_service_sp_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
