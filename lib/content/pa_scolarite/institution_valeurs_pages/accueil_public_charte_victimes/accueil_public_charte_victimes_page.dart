import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class AccueilPublicCharteVictimesPage extends StatelessWidget {
  const AccueilPublicCharteVictimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/institution_valeurs_pages/accueil_public_charte_victimes/accueil_public_charte_victimes_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
