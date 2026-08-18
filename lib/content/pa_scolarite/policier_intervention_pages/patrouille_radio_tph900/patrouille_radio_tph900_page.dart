import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PatrouilleRadioTph900Page extends StatelessWidget {
  const PatrouilleRadioTph900Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/policier_intervention_pages/patrouille_radio_tph900/patrouille_radio_tph900_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
