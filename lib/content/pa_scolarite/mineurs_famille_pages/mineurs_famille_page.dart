import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaAbandonDeFamillePage extends StatelessWidget {
  const PaAbandonDeFamillePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/mineurs_famille_pages/mineurs_famille_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
