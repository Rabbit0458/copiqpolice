import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaPluraliteInfractionsPage extends StatelessWidget {
  const PaPluraliteInfractionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/pluralite_infractions/pluralite_infractions_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
