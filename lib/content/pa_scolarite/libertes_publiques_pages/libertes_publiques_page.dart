import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaLibertesPubliquesPage extends StatelessWidget {
  const PaLibertesPubliquesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/libertes_publiques_pages/libertes_publiques_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
