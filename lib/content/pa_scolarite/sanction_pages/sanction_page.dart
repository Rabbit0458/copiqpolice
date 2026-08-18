import 'package:flutter/material.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaSanctionPage extends StatelessWidget {
  const PaSanctionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/sanction_page.dart",
            "f00001",
            'Page en construction',
          ),
        ),
      ),
    );
  }
}
