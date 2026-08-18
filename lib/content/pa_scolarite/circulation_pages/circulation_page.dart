import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PACirculationPage extends StatelessWidget {
  const PACirculationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/circulation_pages/circulation_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
